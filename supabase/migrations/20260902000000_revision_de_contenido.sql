-- ==========================================================
-- SA&VE Comercial, S.R.L. — Punta Cana, República Dominicana
-- FASE 1 · Revisión legal del catálogo
--
-- Las 251 plantillas y las 123 cláusulas del catálogo entraron en
-- DRAFT a propósito: nadie las ve hasta que una abogada las lea y
-- las apruebe. Falta quién las aprueba y con qué facultades.
--
-- POR QUÉ NO SE USA save_admins
--
-- La tentación es meter a la revisora en save_admins y listo, porque
-- is_save_admin() ya abre todas las políticas. Pero eso le daría el
-- panel de Administración entero: leer los datos de todos los
-- despachos, cambiar planes y borrar cuentas de forma permanente.
-- Revisar textos legales no requiere nada de eso.
--
-- Así que se crea un permiso propio y estrecho: ver y editar el
-- catálogo maestro, y publicarlo. Ni crear plantillas maestras, ni
-- borrarlas, ni ver un solo documento de un cliente.
--
-- CÓMO SE LE CONCEDE
--
-- Por correo, en una tabla en la que solo se escribe con la llave de
-- servicio. Cuando esa persona se registra, handle_new_user enlaza su
-- cuenta con la fila que le esperaba. Deliberadamente NO se lee el
-- correo de los metadatos del registro: esos los controla quien llama
-- a la API con la clave anónima, y cualquiera podría reclamarlos.
-- Se lee NEW.email, que Supabase ya verificó.
-- ==========================================================

-- ==========================================================
-- 1. QUIÉN REVISA
-- ==========================================================

CREATE TABLE IF NOT EXISTS revisores_contenido (
  email      VARCHAR PRIMARY KEY,
  user_id    UUID UNIQUE REFERENCES auth.users(id) ON DELETE SET NULL,
  nombre     TEXT,
  activo     BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now()),
  linked_at  TIMESTAMPTZ
);

COMMENT ON TABLE revisores_contenido IS
  'Fase 1: quién puede aprobar el catálogo maestro. El correo se apunta antes de que la persona tenga cuenta; handle_new_user enlaza user_id al registrarse.';
COMMENT ON COLUMN revisores_contenido.user_id IS
  'Se rellena solo, al registrarse. NULL mientras la persona no tenga cuenta.';

CREATE OR REPLACE FUNCTION public.revisor_normaliza_email()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.email := LOWER(TRIM(NEW.email));
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS revisor_normaliza_email ON revisores_contenido;
CREATE TRIGGER revisor_normaliza_email
  BEFORE INSERT OR UPDATE ON revisores_contenido
  FOR EACH ROW EXECUTE FUNCTION public.revisor_normaliza_email();

-- La abogada del despacho.
INSERT INTO revisores_contenido (email, nombre)
VALUES ('legalcifuentes@gmail.com', 'Abogada revisora de SA&VE')
ON CONFLICT (email) DO UPDATE SET activo = true;

-- Si ya tenía cuenta antes de esta migración, se enlaza ahora.
UPDATE revisores_contenido r
   SET user_id = u.id, linked_at = timezone('utc', now())
  FROM auth.users u
 WHERE r.user_id IS NULL AND LOWER(u.email) = r.email;

ALTER TABLE revisores_contenido ENABLE ROW LEVEL SECURITY;

-- Cada quien ve su propia fila; el admin las ve todas. Escribir, solo
-- con la llave de servicio: es lo que hace fiable la comprobación.
DROP POLICY IF EXISTS "revisores_select" ON revisores_contenido;
CREATE POLICY "revisores_select" ON revisores_contenido FOR SELECT
  USING (user_id = auth.uid() OR public.is_save_admin(auth.uid()));

-- ==========================================================
-- 2. LA COMPROBACIÓN
--    SECURITY DEFINER para que la política no dependa de que quien
--    pregunta pueda leer la tabla.
-- ==========================================================

CREATE OR REPLACE FUNCTION public.es_revisor_contenido(uid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM revisores_contenido
     WHERE user_id = uid AND activo = true
  );
$$;

REVOKE ALL ON FUNCTION public.es_revisor_contenido(UUID) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.es_revisor_contenido(UUID) TO authenticated;

-- ==========================================================
-- 3. QUÉ VE Y QUÉ TOCA LA REVISORA
--
--    Se reescriben las cuatro políticas de cada tabla enteras, no
--    solo la que cambia, para que quede a la vista que el reparto
--    completo es este y no haya que ir a buscar la mitad a otra
--    migración.
-- ==========================================================

-- ---------- PLANTILLAS ----------
DROP POLICY IF EXISTS "templates_select" ON templates;
DROP POLICY IF EXISTS "templates_insert" ON templates;
DROP POLICY IF EXISTS "templates_update" ON templates;
DROP POLICY IF EXISTS "templates_delete" ON templates;

-- Del catálogo maestro, el público solo ve lo aprobado. La revisora ve
-- también lo que está pendiente, que es justo su trabajo.
CREATE POLICY "templates_select" ON templates FOR SELECT
  USING (
    (is_master = true AND status = 'PUBLISHED')
    OR (is_master = true AND public.es_revisor_contenido(auth.uid()))
    OR org_id IN (SELECT public.user_org_ids(auth.uid()))
    OR public.is_save_admin(auth.uid())
  );

-- Crear plantillas maestras sigue siendo cosa de SA&VE. La revisora
-- aprueba y corrige lo que hay; no añade catálogo.
CREATE POLICY "templates_insert" ON templates FOR INSERT
  WITH CHECK (
    (is_master = false AND org_id IN (SELECT public.user_org_ids(auth.uid())))
    OR public.is_save_admin(auth.uid())
  );

CREATE POLICY "templates_update" ON templates FOR UPDATE
  USING (
    (is_master = false AND org_id IN (SELECT public.user_org_ids(auth.uid())))
    OR (is_master = true AND public.es_revisor_contenido(auth.uid()))
    OR public.is_save_admin(auth.uid())
  )
  WITH CHECK (
    (is_master = false AND org_id IN (SELECT public.user_org_ids(auth.uid())))
    OR (is_master = true AND public.es_revisor_contenido(auth.uid()))
    OR public.is_save_admin(auth.uid())
  );

-- Borrar catálogo maestro, nunca. Una plantilla que no sirve se
-- archiva (status ARCHIVED) y queda su rastro.
CREATE POLICY "templates_delete" ON templates FOR DELETE
  USING (
    (is_master = false AND org_id IN (SELECT public.user_org_ids(auth.uid())))
    OR public.is_save_admin(auth.uid())
  );

-- ---------- CLÁUSULAS ----------
DROP POLICY IF EXISTS "clauses_select" ON clauses;
DROP POLICY IF EXISTS "clauses_insert" ON clauses;
DROP POLICY IF EXISTS "clauses_update" ON clauses;
DROP POLICY IF EXISTS "clauses_delete" ON clauses;

CREATE POLICY "clauses_select" ON clauses FOR SELECT
  USING (
    (org_id IS NULL AND status = 'PUBLISHED')
    OR (org_id IS NULL AND public.es_revisor_contenido(auth.uid()))
    OR org_id IN (SELECT public.user_org_ids(auth.uid()))
    OR public.is_save_admin(auth.uid())
  );

CREATE POLICY "clauses_insert" ON clauses FOR INSERT
  WITH CHECK (
    (org_id IS NOT NULL AND org_id IN (SELECT public.user_org_ids(auth.uid())))
    OR public.is_save_admin(auth.uid())
  );

CREATE POLICY "clauses_update" ON clauses FOR UPDATE
  USING (
    (org_id IS NOT NULL AND org_id IN (SELECT public.user_org_ids(auth.uid())))
    OR (org_id IS NULL AND public.es_revisor_contenido(auth.uid()))
    OR public.is_save_admin(auth.uid())
  )
  WITH CHECK (
    (org_id IS NOT NULL AND org_id IN (SELECT public.user_org_ids(auth.uid())))
    OR (org_id IS NULL AND public.es_revisor_contenido(auth.uid()))
    OR public.is_save_admin(auth.uid())
  );

CREATE POLICY "clauses_delete" ON clauses FOR DELETE
  USING (
    (org_id IS NOT NULL AND org_id IN (SELECT public.user_org_ids(auth.uid())))
    OR public.is_save_admin(auth.uid())
  );

-- ==========================================================
-- 4. LO QUE LA POLÍTICA NO PUEDE IMPEDIR
--
--    Una política de UPDATE mira filas enteras, no columnas. Sin esto,
--    la revisora podría poner is_master = false en una plantilla del
--    catálogo y sacarla del maestro, o asignársela a un despacho.
--    El guardián lo impide fila por fila.
--
--    De paso, sella la fecha y el nombre de quien aprueba, para que no
--    dependa de que la aplicación se acuerde de escribirlos.
-- ==========================================================

CREATE OR REPLACE FUNCTION public.guard_catalogo_maestro()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_uid UUID := auth.uid();
BEGIN
  -- Migraciones y tareas del servidor (sin sesión) pasan de largo,
  -- igual que los administradores de SA&VE.
  IF v_uid IS NOT NULL
     AND NOT public.is_save_admin(v_uid)
     AND public.es_revisor_contenido(v_uid) THEN

    IF TG_TABLE_NAME = 'templates' THEN
      IF NEW.is_master IS DISTINCT FROM OLD.is_master
         OR NEW.org_id IS DISTINCT FROM OLD.org_id THEN
        RAISE EXCEPTION
          'La revisión no puede sacar una plantilla del catálogo maestro ni asignarla a un despacho.'
          USING ERRCODE = '42501';
      END IF;
    ELSE
      IF NEW.org_id IS DISTINCT FROM OLD.org_id THEN
        RAISE EXCEPTION
          'La revisión no puede mover una cláusula global a un despacho.'
          USING ERRCODE = '42501';
      END IF;
    END IF;
  END IF;

  -- Quién aprobó y cuándo. Se sella aquí y no en la aplicación para
  -- que valga también si algún día se aprueba desde otro sitio.
  IF NEW.status = 'PUBLISHED' AND OLD.status IS DISTINCT FROM 'PUBLISHED' THEN
    NEW.reviewed_by := COALESCE(v_uid, NEW.reviewed_by);
    NEW.reviewed_at := timezone('utc', now());
  END IF;

  NEW.updated_at := timezone('utc', now());
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS guard_catalogo_maestro ON templates;
CREATE TRIGGER guard_catalogo_maestro
  BEFORE UPDATE ON templates
  FOR EACH ROW EXECUTE FUNCTION public.guard_catalogo_maestro();

DROP TRIGGER IF EXISTS guard_catalogo_maestro ON clauses;
CREATE TRIGGER guard_catalogo_maestro
  BEFORE UPDATE ON clauses
  FOR EACH ROW EXECUTE FUNCTION public.guard_catalogo_maestro();

-- ==========================================================
-- 5. EL NÚMERO DE LA PORTADA
--
--    La portada la ve gente sin sesión, así que la cuenta va por una
--    función SECURITY DEFINER y no por una consulta a la tabla: así
--    el número no depende de qué puede leer un visitante anónimo, y
--    de paso no se le abre la tabla entera para contar filas.
-- ==========================================================

CREATE OR REPLACE FUNCTION public.contar_catalogo_publicado()
RETURNS TABLE (plantillas INTEGER, clausulas INTEGER)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT
    (SELECT COUNT(*)::INTEGER FROM templates
      WHERE is_master = true AND status = 'PUBLISHED'),
    (SELECT COUNT(*)::INTEGER FROM clauses
      WHERE org_id IS NULL AND status = 'PUBLISHED');
$$;

REVOKE ALL ON FUNCTION public.contar_catalogo_publicado() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.contar_catalogo_publicado() TO anon, authenticated;

COMMENT ON FUNCTION public.contar_catalogo_publicado() IS
  'Lo que anuncia la portada. Sube solo, según la revisora va aprobando.';

-- ==========================================================
-- 6. EL REGISTRO ENLAZA A LA REVISORA
--    Se reescribe handle_new_user entera (es CREATE OR REPLACE, no
--    hay forma de añadir un trozo) conservando todo lo de la Fase 0
--    y las invitaciones.
-- ==========================================================

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
  v_inv    RECORD;
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
    v_role := 'INDEPENDIENTE';
  END IF;

  DELETE FROM public.profiles p
   WHERE p.email = NEW.email
     AND p.id <> NEW.id
     AND NOT EXISTS (SELECT 1 FROM auth.users u WHERE u.id = p.id);

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
  -- es el que Supabase verificó, nunca por los metadatos del registro.
  UPDATE public.revisores_contenido
     SET user_id = NEW.id, linked_at = timezone('utc', now())
   WHERE email = LOWER(NEW.email)
     AND user_id IS NULL;

  RETURN NEW;

EXCEPTION WHEN OTHERS THEN
  RAISE WARNING '[handle_new_user] no se pudo preparar el espacio de %: % (SQLSTATE %)',
    NEW.email, SQLERRM, SQLSTATE;
  RETURN NEW;
END;
$$;
