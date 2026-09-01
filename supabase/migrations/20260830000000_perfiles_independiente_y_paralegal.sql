-- ==========================================================
-- SA&VE Comercial, S.R.L. — Punta Cana, República Dominicana
-- Perfiles nuevos en el registro: INDEPENDIENTE y PARALEGAL
--
-- Hasta ahora quien se registraba sin marcar nada quedaba como
-- ABOGADO, porque el trigger no tenía otra cosa que poner. Eso
-- etiquetaba mal a los asistentes y, peor, les daba derecho a
-- liderar un despacho: roleCanLeadTeam() acepta ABOGADO.
--
-- INDEPENDIENTE: no es abogado ni notario. Empresarios, agentes
--   inmobiliarios, contables. Espacio propio y plantillas, pero
--   no puede montar despacho ni sumar paralegales.
-- PARALEGAL: se registra por su cuenta y trabaja en su espacio.
--   Cuando un abogado lo añade, al entrar ve el despacho de este
--   (la regla de despacho activo de src/lib/session.ts).
--
-- Ninguno de los dos puede liderar equipo. Eso NO se toca aquí:
-- roleCanLeadTeam() es una lista blanca de ABOGADO/NOTARIO/AMBOS,
-- así que los valores nuevos quedan fuera por construcción.
-- ==========================================================

ALTER TYPE professional_role ADD VALUE IF NOT EXISTS 'INDEPENDIENTE';
ALTER TYPE professional_role ADD VALUE IF NOT EXISTS 'PARALEGAL';

-- El formulario ahora manda prof_role directamente. Se mantiene la
-- lectura de is_lawyer/is_notary para las cuentas que se registraron
-- con la versión anterior del formulario y para no romper nada si
-- queda algún cliente viejo en caché.
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_first  TEXT := COALESCE(NEW.raw_user_meta_data->>'first_name', '');
  v_last   TEXT := COALESCE(NEW.raw_user_meta_data->>'last_name', '');
  v_pedido TEXT := UPPER(TRIM(COALESCE(NEW.raw_user_meta_data->>'prof_role', '')));
  v_role   professional_role;
  v_org_id UUID;
  v_name   TEXT;
BEGIN
  IF v_pedido IN ('ABOGADO', 'NOTARIO', 'AMBOS', 'INDEPENDIENTE', 'PARALEGAL') THEN
    v_role := v_pedido::professional_role;
  ELSIF (NEW.raw_user_meta_data->>'is_lawyer')::boolean IS TRUE
        AND (NEW.raw_user_meta_data->>'is_notary')::boolean IS TRUE THEN
    v_role := 'AMBOS';
  ELSIF (NEW.raw_user_meta_data->>'is_notary')::boolean IS TRUE THEN
    v_role := 'NOTARIO';
  ELSIF (NEW.raw_user_meta_data->>'is_lawyer')::boolean IS TRUE THEN
    v_role := 'ABOGADO';
  ELSE
    -- Antes esto era ABOGADO, que regalaba facultades a quien no las pidió.
    v_role := 'INDEPENDIENTE';
  END IF;

  INSERT INTO public.profiles (id, email, first_name, last_name, prof_role)
  VALUES (NEW.id, NEW.email, NULLIF(v_first, ''), NULLIF(v_last, ''), v_role)
  ON CONFLICT (id) DO NOTHING;

  v_name := TRIM(v_first || ' ' || v_last);
  IF v_name = '' THEN
    v_name := split_part(NEW.email, '@', 1);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM public.organizations WHERE owner_id = NEW.id) THEN
    INSERT INTO public.organizations (owner_id, name, is_firm)
    VALUES (NEW.id, 'Despacho de ' || v_name, false)
    RETURNING id INTO v_org_id;

    INSERT INTO public.org_members (org_id, user_id, role)
    VALUES (v_org_id, NEW.id, 'OWNER')
    ON CONFLICT (org_id, user_id) DO NOTHING;
  END IF;

  RETURN NEW;

EXCEPTION WHEN OTHERS THEN
  -- Preparar el espacio de trabajo nunca debe impedir crear la cuenta.
  -- Una cuenta sin perfil se repara con reparar_cuentas_incompletas();
  -- una persona que no puede registrarse se pierde.
  RAISE WARNING '[handle_new_user] no se pudo preparar el espacio de %: % (SQLSTATE %)',
    NEW.email, SQLERRM, SQLSTATE;
  RETURN NEW;
END;
$$;

-- ---------- Reparación de cuentas a medias ----------
-- La consulta de estado detectó una cuenta sin perfil o sin despacho.
-- Esto la deja utilizable. Es idempotente.
-- El DROP permite cambiar la forma de la tabla devuelta sin romper.
DROP FUNCTION IF EXISTS public.reparar_cuentas_incompletas();

CREATE OR REPLACE FUNCTION public.reparar_cuentas_incompletas()
RETURNS TABLE (correo TEXT, reparado TEXT)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  r RECORD;
  v_org_id UUID;
  v_name   TEXT;
BEGIN
  FOR r IN
    SELECT u.id, u.email, u.raw_user_meta_data FROM auth.users u
     WHERE NOT EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = u.id)
  LOOP
    INSERT INTO public.profiles (id, email, first_name, last_name, prof_role)
    VALUES (r.id, r.email,
            NULLIF(COALESCE(r.raw_user_meta_data->>'first_name',''), ''),
            NULLIF(COALESCE(r.raw_user_meta_data->>'last_name',''), ''),
            'INDEPENDIENTE')
    ON CONFLICT (id) DO NOTHING;
    correo := r.email; reparado := 'perfil creado'; RETURN NEXT;
  END LOOP;

  FOR r IN
    SELECT p.id, p.email, p.first_name, p.last_name FROM public.profiles p
     WHERE NOT EXISTS (SELECT 1 FROM public.organizations o WHERE o.owner_id = p.id)
  LOOP
    v_name := TRIM(COALESCE(r.first_name,'') || ' ' || COALESCE(r.last_name,''));
    IF v_name = '' THEN v_name := split_part(r.email, '@', 1); END IF;

    INSERT INTO public.organizations (owner_id, name, is_firm)
    VALUES (r.id, 'Despacho de ' || v_name, false)
    RETURNING id INTO v_org_id;

    INSERT INTO public.org_members (org_id, user_id, role)
    VALUES (v_org_id, r.id, 'OWNER')
    ON CONFLICT (org_id, user_id) DO NOTHING;

    correo := r.email; reparado := 'espacio de trabajo creado'; RETURN NEXT;
  END LOOP;

  -- Titulares sin su fila en org_members.
  FOR r IN
    SELECT o.owner_id AS id, o.id AS org_id, p.email FROM public.organizations o
      JOIN public.profiles p ON p.id = o.owner_id
     WHERE NOT EXISTS (SELECT 1 FROM public.org_members m
                        WHERE m.org_id = o.id AND m.user_id = o.owner_id)
  LOOP
    INSERT INTO public.org_members (org_id, user_id, role)
    VALUES (r.org_id, r.id, 'OWNER')
    ON CONFLICT (org_id, user_id) DO NOTHING;
    correo := r.email; reparado := 'membresia de titular creada'; RETURN NEXT;
  END LOOP;

  RETURN;
END;
$$;

-- Revocar de PUBLIC basta: anon y authenticated heredan de ahi, y asi
-- la migracion no depende de que esos roles existan.
REVOKE ALL ON FUNCTION public.reparar_cuentas_incompletas() FROM PUBLIC;

COMMENT ON FUNCTION public.reparar_cuentas_incompletas() IS
  'Repara cuentas a medias. Ejecutar: SELECT * FROM reparar_cuentas_incompletas();';
