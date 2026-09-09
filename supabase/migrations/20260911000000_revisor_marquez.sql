-- ==========================================================
-- SA&VE Comercial, S.R.L.
-- Segundo revisor del catalogo, y reparacion de handle_new_user
--
-- 1. jmarquez@saveconsult.net recibe el mismo permiso que
--    legalcifuentes@gmail.com: ver, corregir y aprobar el catalogo
--    maestro. Ni panel de administracion, ni acceso a un solo
--    documento de cliente.
--
--    NO HACE FALTA UN TRIGGER NUEVO. El que enlaza a un revisor con su
--    cuenta ya existe desde el 2 de septiembre, dentro de
--    handle_new_user: cuando esa persona se registre, el permiso que
--    le esperaba se le engancha solo. Se apunta el correo ANTES de que
--    tenga cuenta, y se enlaza por NEW.email -el que Supabase
--    verifico- y nunca por los metadatos del registro, que los
--    controla quien llama a la API.
--
-- 2. REPARACION. Las migraciones 20260909 y 20260910 reescribieron
--    handle_new_user partiendo de una version anterior a la del 2 de
--    septiembre, y al hacerlo perdieron dos bloques:
--
--      · el enlace del revisor. La abogada no habria recibido su
--        permiso al registrarse, y la Fase 2 -el camino critico del
--        proyecto- se habria quedado parada sin causa visible.
--      · el EXCEPTION WHEN OTHERS. Sin el, cualquier error dentro del
--        trigger ABORTA el alta: la persona no puede crear su cuenta.
--
--    Aqui se vuelve a dejar la funcion completa. Es idempotente y no
--    importa si las otras dos ya se corrieron o no.
-- ==========================================================

INSERT INTO revisores_contenido (email, nombre)
VALUES ('jmarquez@saveconsult.net', 'Revisor de contenido de SA&VE')
ON CONFLICT (email) DO UPDATE SET activo = true, nombre = EXCLUDED.nombre;

-- Si ya tuviera cuenta creada antes de esta migracion, se enlaza ahora.
UPDATE revisores_contenido r
   SET user_id = u.id, linked_at = timezone('utc', now())
  FROM auth.users u
 WHERE r.user_id IS NULL AND LOWER(u.email) = r.email;

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  m        JSONB := COALESCE(NEW.raw_user_meta_data, '{}'::jsonb);
  v_full   TEXT  := COALESCE(m->>'full_name', m->>'name', '');
  v_first  TEXT  := COALESCE(NULLIF(m->>'first_name',''), NULLIF(m->>'given_name',''),
                             NULLIF(split_part(v_full, ' ', 1), ''), '');
  v_last   TEXT  := COALESCE(NULLIF(m->>'last_name',''), NULLIF(m->>'family_name',''),
                             NULLIF(NULLIF(TRIM(SUBSTRING(v_full FROM POSITION(' ' IN v_full))), ''), ''), '');
  v_pedido TEXT  := UPPER(TRIM(COALESCE(m->>'prof_role', '')));
  v_tipo   TEXT  := UPPER(TRIM(COALESCE(m->>'tipo_cuenta', 'PERSONA')));
  v_completo BOOLEAN := (m ? 'tipo_cuenta');
  v_fnac   DATE;
  v_role   professional_role;
  v_cuenta tipo_de_cuenta;
  v_org_id UUID;
  v_name   TEXT;
  v_inv    RECORD;
BEGIN
  IF v_pedido IN ('ABOGADO', 'NOTARIO', 'AMBOS', 'INDEPENDIENTE', 'PARALEGAL') THEN
    v_role := v_pedido::professional_role;
  ELSIF (m->>'is_lawyer')::boolean IS TRUE AND (m->>'is_notary')::boolean IS TRUE THEN
    v_role := 'AMBOS';
  ELSIF (m->>'is_notary')::boolean IS TRUE THEN
    v_role := 'NOTARIO';
  ELSIF (m->>'is_lawyer')::boolean IS TRUE THEN
    v_role := 'ABOGADO';
  ELSE
    v_role := 'INDEPENDIENTE';
  END IF;

  v_cuenta := CASE WHEN v_tipo = 'EMPRESA' THEN 'EMPRESA' ELSE 'PERSONA' END::tipo_de_cuenta;

  IF v_cuenta = 'PERSONA' THEN
    BEGIN
      v_fnac := NULLIF(m->>'fecha_nacimiento', '')::date;
      IF v_fnac IS NOT NULL
         AND (v_fnac <= DATE '1900-01-01' OR v_fnac >= CURRENT_DATE) THEN
        v_fnac := NULL;
      END IF;
    EXCEPTION WHEN others THEN
      v_fnac := NULL;
    END;
  END IF;

  DELETE FROM public.profiles p
   WHERE p.email = NEW.email
     AND p.id <> NEW.id
     AND NOT EXISTS (SELECT 1 FROM auth.users u WHERE u.id = p.id);

  INSERT INTO public.profiles (
    id, email, first_name, last_name, prof_role,
    tipo_cuenta, fecha_nacimiento, razon_social, rnc, perfil_completado
  )
  VALUES (
    NEW.id, NEW.email, NULLIF(v_first, ''), NULLIF(v_last, ''), v_role,
    v_cuenta, v_fnac,
    CASE WHEN v_cuenta = 'EMPRESA' THEN NULLIF(TRIM(COALESCE(m->>'razon_social','')), '') END,
    CASE WHEN v_cuenta = 'EMPRESA' THEN NULLIF(TRIM(COALESCE(m->>'rnc','')), '') END,
    v_completo
  )
  ON CONFLICT (id) DO NOTHING;

  v_name := COALESCE(
    CASE WHEN v_cuenta = 'EMPRESA' THEN NULLIF(TRIM(COALESCE(m->>'razon_social','')), '') END,
    NULLIF(TRIM(v_first || ' ' || v_last), ''),
    split_part(NEW.email, '@', 1)
  );

  IF NOT EXISTS (SELECT 1 FROM public.organizations WHERE owner_id = NEW.id) THEN
    INSERT INTO public.organizations (owner_id, name, is_firm)
    VALUES (NEW.id,
            CASE WHEN v_cuenta = 'EMPRESA' THEN v_name ELSE 'Despacho de ' || v_name END,
            false)
    RETURNING id INTO v_org_id;

    INSERT INTO public.org_members (org_id, user_id, role)
    VALUES (v_org_id, NEW.id, 'OWNER')
    ON CONFLICT (org_id, user_id) DO NOTHING;
  END IF;

  SELECT * INTO v_inv
    FROM public.invitaciones
   WHERE email = LOWER(NEW.email)
     AND estado = 'PENDIENTE'
     AND expires_at > timezone('utc', now())
   ORDER BY created_at DESC
   LIMIT 1;

  IF FOUND THEN
    INSERT INTO public.org_members (org_id, user_id, role, permissions)
    VALUES (v_inv.org_id, NEW.id, v_inv.role, v_inv.permissions)
    ON CONFLICT (org_id, user_id) DO NOTHING;

    UPDATE public.invitaciones
       SET estado = 'ACEPTADA', accepted_at = timezone('utc', now())
     WHERE id = v_inv.id;
  END IF;

  -- ¿Le esperaba el permiso de revisar el catálogo? Por NEW.email, que
  -- es el que Supabase verificó, nunca por los metadatos del registro:
  -- esos los controla quien llama a la API y cualquiera podría
  -- reclamarlos.
  UPDATE public.revisores_contenido
     SET user_id = NEW.id, linked_at = timezone('utc', now())
   WHERE email = LOWER(NEW.email)
     AND user_id IS NULL;

  RETURN NEW;

-- Sin esto, CUALQUIER error aquí dentro aborta la creación de la
-- cuenta: la persona no puede registrarse y el mensaje que ve no dice
-- nada útil. Preferimos un espacio a medio preparar y un aviso en los
-- registros, que se arregla, a una puerta cerrada.
EXCEPTION WHEN OTHERS THEN
  RAISE WARNING '[handle_new_user] no se pudo preparar el espacio de %: % (SQLSTATE %)',
    NEW.email, SQLERRM, SQLSTATE;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- ---------- Comprobacion ----------
DO $$
DECLARE
  v_def TEXT;
  v_rev INT;
BEGIN
  SELECT prosrc INTO v_def FROM pg_proc
   WHERE proname = 'handle_new_user'
     AND pronamespace = 'public'::regnamespace;

  IF v_def IS NULL THEN
    RAISE EXCEPTION 'handle_new_user no existe';
  END IF;

  -- Las dos piezas que se perdieron. Si vuelven a caerse, esto falla
  -- en vez de dejarlo pasar en silencio, que es como se perdieron.
  IF position('revisores_contenido' in v_def) = 0 THEN
    RAISE EXCEPTION 'handle_new_user NO enlaza a los revisores: el permiso no se concederia al registrarse';
  END IF;

  IF position('EXCEPTION WHEN OTHERS' in v_def) = 0 THEN
    RAISE EXCEPTION 'handle_new_user NO captura errores: un fallo impediria crear cuentas';
  END IF;

  SELECT count(*) INTO v_rev FROM revisores_contenido WHERE activo;

  SELECT string_agg(
           email || CASE WHEN user_id IS NULL THEN ' (sin cuenta todavia)' ELSE ' (enlazado)' END,
           E'\n  - ' ORDER BY email)
    INTO v_def
    FROM revisores_contenido WHERE activo;

  RAISE NOTICE 'Revisores activos (%):%s  - %', v_rev, E'\n', v_def;
END $$;
