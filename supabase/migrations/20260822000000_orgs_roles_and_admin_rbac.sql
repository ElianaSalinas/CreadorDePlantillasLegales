-- ==========================================================
-- SA&VE Comercial, S.R.L.
-- Migración 3: Organizaciones automáticas, estado de usuario,
-- RBAC de Super Admin y corrección de recursión en RLS.
--
-- Requiere: 20260819000000_initial_schema.sql
--           20260821000000_admin_table_and_profile_trigger.sql
-- ==========================================================

-- ==========================================================
-- 1. COLUMNAS NUEVAS
-- ==========================================================

-- Desactivar un usuario sin borrar su historial (borrado suave).
ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT true;

-- No todo profesional tiene despacho. Trabaja solo por defecto;
-- activa el modo despacho cuando quiere sumar paralegales/asistentes.
ALTER TABLE organizations
  ADD COLUMN IF NOT EXISTS is_firm BOOLEAN NOT NULL DEFAULT false;

-- Contador real de la bóveda (el límite de 30 del PRD).
ALTER TABLE organizations
  ADD COLUMN IF NOT EXISTS vault_used_count INT NOT NULL DEFAULT 0;

-- ==========================================================
-- 2. FUNCIONES AUXILIARES (SECURITY DEFINER)
--    Evitan la recursión infinita de RLS: una policy sobre
--    org_members que consulta org_members se autorreferencia.
-- ==========================================================

CREATE OR REPLACE FUNCTION public.user_org_ids(uid UUID)
RETURNS SETOF UUID
LANGUAGE sql
SECURITY DEFINER
STABLE
SET search_path = public
AS $$
  SELECT org_id FROM org_members WHERE user_id = uid
  UNION
  SELECT id FROM organizations WHERE owner_id = uid;
$$;

CREATE OR REPLACE FUNCTION public.is_save_admin(uid UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
STABLE
SET search_path = public
AS $$
  SELECT EXISTS (SELECT 1 FROM save_admins WHERE id = uid);
$$;

CREATE OR REPLACE FUNCTION public.is_org_owner(uid UUID, target_org UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
STABLE
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM organizations WHERE id = target_org AND owner_id = uid
  );
$$;

-- ==========================================================
-- 3. TRIGGER DE REGISTRO AMPLIADO
--    Antes: solo creaba la fila en profiles.
--    Ahora: profiles + organizations + org_members(OWNER).
--    Sin esto, documentos/plantillas/bóveda no tienen org_id
--    al que colgarse y las pantallas salen siempre vacías.
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
  v_role   professional_role;
  v_org_id UUID;
  v_name   TEXT;
BEGIN
  -- Rol profesional según lo marcado en el registro
  IF (NEW.raw_user_meta_data->>'is_lawyer')::boolean IS TRUE
     AND (NEW.raw_user_meta_data->>'is_notary')::boolean IS TRUE THEN
    v_role := 'AMBOS';
  ELSIF (NEW.raw_user_meta_data->>'is_notary')::boolean IS TRUE THEN
    v_role := 'NOTARIO';
  ELSE
    v_role := 'ABOGADO';
  END IF;

  INSERT INTO public.profiles (id, email, first_name, last_name, prof_role)
  VALUES (NEW.id, NEW.email, NULLIF(v_first, ''), NULLIF(v_last, ''), v_role)
  ON CONFLICT (id) DO NOTHING;

  -- Espacio de trabajo propio. Se llama "despacho" solo cuando
  -- el usuario activa is_firm desde Mi Despacho.
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
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- ==========================================================
-- 4. BACKFILL: usuarios que ya existen y se quedaron sin org
-- ==========================================================

INSERT INTO public.organizations (owner_id, name, is_firm)
SELECT p.id,
       'Despacho de ' || COALESCE(NULLIF(TRIM(COALESCE(p.first_name,'') || ' ' || COALESCE(p.last_name,'')), ''), split_part(p.email, '@', 1)),
       false
FROM public.profiles p
WHERE NOT EXISTS (SELECT 1 FROM public.organizations o WHERE o.owner_id = p.id);

INSERT INTO public.org_members (org_id, user_id, role)
SELECT o.id, o.owner_id, 'OWNER'
FROM public.organizations o
WHERE NOT EXISTS (
  SELECT 1 FROM public.org_members m WHERE m.org_id = o.id AND m.user_id = o.owner_id
)
ON CONFLICT (org_id, user_id) DO NOTHING;

-- ==========================================================
-- 5. POLÍTICAS RLS
-- ==========================================================

-- ---------- PROFILES ----------
-- La policy original era USING (true): cualquier usuario autenticado
-- podía leer el correo de todos. En una plataforma legal eso no va.
DROP POLICY IF EXISTS "Public profiles are viewable by everyone." ON profiles;
DROP POLICY IF EXISTS "Users can insert their own profile." ON profiles;
DROP POLICY IF EXISTS "Users can update own profile." ON profiles;
DROP POLICY IF EXISTS "profiles_select" ON profiles;
DROP POLICY IF EXISTS "profiles_insert" ON profiles;
DROP POLICY IF EXISTS "profiles_update" ON profiles;
DROP POLICY IF EXISTS "profiles_delete" ON profiles;

CREATE POLICY "profiles_select" ON profiles FOR SELECT
  USING (
    auth.uid() = id
    OR public.is_save_admin(auth.uid())
    OR id IN (
      SELECT m.user_id FROM org_members m
      WHERE m.org_id IN (SELECT public.user_org_ids(auth.uid()))
    )
  );

CREATE POLICY "profiles_insert" ON profiles FOR INSERT
  WITH CHECK (auth.uid() = id OR public.is_save_admin(auth.uid()));

CREATE POLICY "profiles_update" ON profiles FOR UPDATE
  USING (auth.uid() = id OR public.is_save_admin(auth.uid()));

CREATE POLICY "profiles_delete" ON profiles FOR DELETE
  USING (public.is_save_admin(auth.uid()));

-- ---------- ORGANIZATIONS ----------
DROP POLICY IF EXISTS "Owners can view own organization" ON organizations;
DROP POLICY IF EXISTS "Owners can update own organization" ON organizations;
DROP POLICY IF EXISTS "orgs_select" ON organizations;
DROP POLICY IF EXISTS "orgs_insert" ON organizations;
DROP POLICY IF EXISTS "orgs_update" ON organizations;

CREATE POLICY "orgs_select" ON organizations FOR SELECT
  USING (
    auth.uid() = owner_id
    OR public.is_save_admin(auth.uid())
    OR id IN (SELECT public.user_org_ids(auth.uid()))
  );

CREATE POLICY "orgs_insert" ON organizations FOR INSERT
  WITH CHECK (auth.uid() = owner_id OR public.is_save_admin(auth.uid()));

CREATE POLICY "orgs_update" ON organizations FOR UPDATE
  USING (auth.uid() = owner_id OR public.is_save_admin(auth.uid()));

-- ---------- ORG_MEMBERS ----------
-- La policy original se consultaba a sí misma -> recursión infinita.
DROP POLICY IF EXISTS "Members can view their org members" ON org_members;
DROP POLICY IF EXISTS "org_members_select" ON org_members;
DROP POLICY IF EXISTS "org_members_insert" ON org_members;
DROP POLICY IF EXISTS "org_members_update" ON org_members;
DROP POLICY IF EXISTS "org_members_delete" ON org_members;

CREATE POLICY "org_members_select" ON org_members FOR SELECT
  USING (
    user_id = auth.uid()
    OR public.is_save_admin(auth.uid())
    OR org_id IN (SELECT public.user_org_ids(auth.uid()))
  );

CREATE POLICY "org_members_insert" ON org_members FOR INSERT
  WITH CHECK (public.is_org_owner(auth.uid(), org_id) OR public.is_save_admin(auth.uid()));

CREATE POLICY "org_members_update" ON org_members FOR UPDATE
  USING (public.is_org_owner(auth.uid(), org_id) OR public.is_save_admin(auth.uid()));

CREATE POLICY "org_members_delete" ON org_members FOR DELETE
  USING (public.is_org_owner(auth.uid(), org_id) OR public.is_save_admin(auth.uid()));

-- ---------- TEMPLATES ----------
DROP POLICY IF EXISTS "Everyone can read master templates" ON templates;
DROP POLICY IF EXISTS "templates_select" ON templates;
DROP POLICY IF EXISTS "templates_insert" ON templates;
DROP POLICY IF EXISTS "templates_update" ON templates;
DROP POLICY IF EXISTS "templates_delete" ON templates;

CREATE POLICY "templates_select" ON templates FOR SELECT
  USING (
    is_master = true
    OR public.is_save_admin(auth.uid())
    OR org_id IN (SELECT public.user_org_ids(auth.uid()))
  );

-- Solo los admins de SA&VE crean plantillas maestras globales.
CREATE POLICY "templates_insert" ON templates FOR INSERT
  WITH CHECK (
    (is_master = false AND org_id IN (SELECT public.user_org_ids(auth.uid())))
    OR public.is_save_admin(auth.uid())
  );

CREATE POLICY "templates_update" ON templates FOR UPDATE
  USING (
    (is_master = false AND org_id IN (SELECT public.user_org_ids(auth.uid())))
    OR public.is_save_admin(auth.uid())
  );

CREATE POLICY "templates_delete" ON templates FOR DELETE
  USING (
    (is_master = false AND org_id IN (SELECT public.user_org_ids(auth.uid())))
    OR public.is_save_admin(auth.uid())
  );

-- ---------- DOCUMENTS ----------
DROP POLICY IF EXISTS "Org members can read org documents" ON documents;
DROP POLICY IF EXISTS "Org members can insert documents" ON documents;
DROP POLICY IF EXISTS "documents_select" ON documents;
DROP POLICY IF EXISTS "documents_insert" ON documents;
DROP POLICY IF EXISTS "documents_update" ON documents;
DROP POLICY IF EXISTS "documents_delete" ON documents;

CREATE POLICY "documents_select" ON documents FOR SELECT
  USING (org_id IN (SELECT public.user_org_ids(auth.uid())) OR public.is_save_admin(auth.uid()));

CREATE POLICY "documents_insert" ON documents FOR INSERT
  WITH CHECK (org_id IN (SELECT public.user_org_ids(auth.uid())));

CREATE POLICY "documents_update" ON documents FOR UPDATE
  USING (org_id IN (SELECT public.user_org_ids(auth.uid())) OR public.is_save_admin(auth.uid()));

CREATE POLICY "documents_delete" ON documents FOR DELETE
  USING (org_id IN (SELECT public.user_org_ids(auth.uid())) OR public.is_save_admin(auth.uid()));

-- ---------- AUDIT LOGS ----------
DROP POLICY IF EXISTS "Org members can view audit logs" ON audit_logs;
DROP POLICY IF EXISTS "audit_select" ON audit_logs;
DROP POLICY IF EXISTS "audit_insert" ON audit_logs;

CREATE POLICY "audit_select" ON audit_logs FOR SELECT
  USING (org_id IN (SELECT public.user_org_ids(auth.uid())) OR public.is_save_admin(auth.uid()));

CREATE POLICY "audit_insert" ON audit_logs FOR INSERT
  WITH CHECK (org_id IN (SELECT public.user_org_ids(auth.uid())));

-- Sin UPDATE ni DELETE a propósito: el registro de auditoría es inmutable.

-- ---------- SAVE_ADMINS ----------
DROP POLICY IF EXISTS "Admins can view own admin row" ON save_admins;
DROP POLICY IF EXISTS "save_admins_select" ON save_admins;

CREATE POLICY "save_admins_select" ON save_admins FOR SELECT
  USING (auth.uid() = id OR public.is_save_admin(auth.uid()));

-- Alta y baja de administradores se hace solo con la service role key
-- desde el servidor, nunca desde el navegador.
