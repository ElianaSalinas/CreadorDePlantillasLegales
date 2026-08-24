-- ==========================================================
-- SA&VE Comercial, S.R.L. — Punta Cana, República Dominicana
-- Migración 6: Núcleo del motor documental
--
-- Convierte `templates` de un catálogo de textos en una plantilla
-- de verdad: variables y cláusulas como entidades propias y
-- reutilizables, secciones, anexos, reglas e historial de versiones.
--
-- No se destruye nada: `templates.content` y `templates.category`
-- se conservan tal cual para no romper la pantalla actual.
-- ==========================================================

-- ==========================================================
-- 1. TIPOS
-- ==========================================================

-- Ciclo de vida compartido por plantillas y cláusulas.
DO $$ BEGIN
  CREATE TYPE content_status AS ENUM ('DRAFT', 'REVIEW', 'APPROVED', 'PUBLISHED', 'ARCHIVED');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- Cómo participa una cláusula dentro de una plantilla concreta.
DO $$ BEGIN
  CREATE TYPE clause_kind AS ENUM ('MANDATORY', 'OPTIONAL', 'CONDITIONAL', 'RECOMMENDED');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE variable_data_type AS ENUM (
    'text', 'textarea', 'number', 'currency', 'percentage', 'date',
    'email', 'phone', 'boolean', 'select', 'multiselect',
    'address', 'person', 'company', 'cedula', 'rnc'
  );
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- ==========================================================
-- 2. JURISDICCIONES
--    RD es la primera, no la única. Nada en el esquema la asume.
-- ==========================================================

CREATE TABLE IF NOT EXISTS jurisdictions (
  code VARCHAR PRIMARY KEY,
  name VARCHAR NOT NULL,
  language VARCHAR NOT NULL DEFAULT 'es',
  is_active BOOLEAN NOT NULL DEFAULT true
);

INSERT INTO jurisdictions (code, name, language) VALUES ('DO', 'República Dominicana', 'es')
ON CONFLICT (code) DO NOTHING;

ALTER TABLE jurisdictions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "jurisdictions_select" ON jurisdictions;
CREATE POLICY "jurisdictions_select" ON jurisdictions FOR SELECT USING (true);

-- ==========================================================
-- 3. CATEGORÍAS Y SUBCATEGORÍAS
--    Autorreferencia: una fila con parent_id es una subcategoría.
-- ==========================================================

CREATE TABLE IF NOT EXISTS template_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_id UUID REFERENCES template_categories(id) ON DELETE CASCADE,
  slug VARCHAR NOT NULL UNIQUE,
  name VARCHAR NOT NULL,
  description TEXT,
  sort_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now())
);

CREATE INDEX IF NOT EXISTS template_categories_parent_idx ON template_categories(parent_id);

INSERT INTO template_categories (slug, name, sort_order) VALUES
  ('inmobiliario',   'Inmobiliario',              1),
  ('legal-general',  'Legal / General',           2),
  ('empresarial',    'Empresarial / Corporativo', 3),
  ('laboral',        'Laboral / RR. HH.',         4),
  ('servicios',      'Servicios Profesionales',   5),
  ('construccion',   'Construcción',              6),
  ('tecnologia',     'Tecnología / Software',     7),
  ('marketing',      'Marketing / Creativo',      8),
  ('comercio',       'Compraventa / Comercio',    9),
  ('vehiculos',      'Vehículos',                10),
  ('financiamiento', 'Préstamos / Financiamiento', 11)
ON CONFLICT (slug) DO NOTHING;

ALTER TABLE template_categories ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "categories_select" ON template_categories;
DROP POLICY IF EXISTS "categories_write" ON template_categories;

CREATE POLICY "categories_select" ON template_categories FOR SELECT USING (true);
CREATE POLICY "categories_write" ON template_categories FOR ALL
  USING (public.is_save_admin(auth.uid()))
  WITH CHECK (public.is_save_admin(auth.uid()));

-- ==========================================================
-- 4. VARIABLES REUTILIZABLES
--    org_id NULL = variable global de SA&VE.
--    org_id lleno = variable propia de un despacho.
-- ==========================================================

CREATE TABLE IF NOT EXISTS variables (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
  tag VARCHAR NOT NULL,
  label VARCHAR NOT NULL,
  question TEXT,
  help_text TEXT,
  data_type variable_data_type NOT NULL DEFAULT 'text',
  options JSONB NOT NULL DEFAULT '[]'::jsonb,
  default_value TEXT,
  validation_regex TEXT,
  validation_message TEXT,
  is_required BOOLEAN NOT NULL DEFAULT true,
  derived_config JSONB,
  created_by UUID REFERENCES profiles(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now())
);

COMMENT ON COLUMN variables.question IS
  'La pregunta que ve el usuario en el formulario: "¿El inmueble está amueblado?".';
COMMENT ON COLUMN variables.derived_config IS
  'Transformación automática: monto a letras, fecha notarial, formato de cédula.';

-- UNIQUE no sirve con NULL: en Postgres dos NULL no colisionan.
CREATE UNIQUE INDEX IF NOT EXISTS variables_global_tag_idx
  ON variables(tag) WHERE org_id IS NULL;
CREATE UNIQUE INDEX IF NOT EXISTS variables_org_tag_idx
  ON variables(org_id, tag) WHERE org_id IS NOT NULL;

ALTER TABLE variables ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "variables_select" ON variables;
DROP POLICY IF EXISTS "variables_insert" ON variables;
DROP POLICY IF EXISTS "variables_update" ON variables;
DROP POLICY IF EXISTS "variables_delete" ON variables;

CREATE POLICY "variables_select" ON variables FOR SELECT
  USING (org_id IS NULL OR org_id IN (SELECT public.user_org_ids(auth.uid())) OR public.is_save_admin(auth.uid()));

CREATE POLICY "variables_insert" ON variables FOR INSERT
  WITH CHECK (
    (org_id IS NOT NULL AND org_id IN (SELECT public.user_org_ids(auth.uid())))
    OR public.is_save_admin(auth.uid())
  );

CREATE POLICY "variables_update" ON variables FOR UPDATE
  USING (
    (org_id IS NOT NULL AND org_id IN (SELECT public.user_org_ids(auth.uid())))
    OR public.is_save_admin(auth.uid())
  );

CREATE POLICY "variables_delete" ON variables FOR DELETE
  USING (
    (org_id IS NOT NULL AND org_id IN (SELECT public.user_org_ids(auth.uid())))
    OR public.is_save_admin(auth.uid())
  );

-- ==========================================================
-- 5. CLÁUSULAS REUTILIZABLES
--    Entidad propia, NO una copia dentro de cada plantilla.
--    Corregir el texto aquí corrige todas las plantillas que la usan.
-- ==========================================================

CREATE TABLE IF NOT EXISTS clauses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
  jurisdiction_code VARCHAR NOT NULL DEFAULT 'DO' REFERENCES jurisdictions(code),
  slug VARCHAR NOT NULL,
  title VARCHAR NOT NULL,
  family VARCHAR NOT NULL,
  description TEXT,
  body TEXT NOT NULL,
  legal_reference TEXT,
  version VARCHAR NOT NULL DEFAULT '1.0',
  status content_status NOT NULL DEFAULT 'DRAFT',
  reviewed_by UUID REFERENCES profiles(id) ON DELETE SET NULL,
  reviewed_at TIMESTAMPTZ,
  created_by UUID REFERENCES profiles(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now())
);

COMMENT ON COLUMN clauses.family IS
  'Familia: Generales, Económicas, Inmobiliarias, Empresariales, Laborales, Tecnología.';
COMMENT ON COLUMN clauses.reviewed_by IS
  'Profesional que revisó el texto. Sin esto una cláusula no debería publicarse.';

CREATE UNIQUE INDEX IF NOT EXISTS clauses_global_slug_idx
  ON clauses(slug) WHERE org_id IS NULL;
CREATE UNIQUE INDEX IF NOT EXISTS clauses_org_slug_idx
  ON clauses(org_id, slug) WHERE org_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS clauses_family_idx ON clauses(family);
CREATE INDEX IF NOT EXISTS clauses_status_idx ON clauses(status);

ALTER TABLE clauses ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "clauses_select" ON clauses;
DROP POLICY IF EXISTS "clauses_insert" ON clauses;
DROP POLICY IF EXISTS "clauses_update" ON clauses;
DROP POLICY IF EXISTS "clauses_delete" ON clauses;

-- Las globales solo se ven publicadas; el admin las ve todas.
CREATE POLICY "clauses_select" ON clauses FOR SELECT
  USING (
    (org_id IS NULL AND status = 'PUBLISHED')
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
    OR public.is_save_admin(auth.uid())
  );

CREATE POLICY "clauses_delete" ON clauses FOR DELETE
  USING (
    (org_id IS NOT NULL AND org_id IN (SELECT public.user_org_ids(auth.uid())))
    OR public.is_save_admin(auth.uid())
  );

-- ==========================================================
-- 6. PLANTILLAS: COLUMNAS NUEVAS
--    Se amplía la tabla existente. No se crea una tabla paralela.
-- ==========================================================

ALTER TABLE templates ADD COLUMN IF NOT EXISTS slug VARCHAR;
ALTER TABLE templates ADD COLUMN IF NOT EXISTS description TEXT;
ALTER TABLE templates ADD COLUMN IF NOT EXISTS category_id UUID REFERENCES template_categories(id) ON DELETE SET NULL;
ALTER TABLE templates ADD COLUMN IF NOT EXISTS jurisdiction_code VARCHAR NOT NULL DEFAULT 'DO' REFERENCES jurisdictions(code);
ALTER TABLE templates ADD COLUMN IF NOT EXISTS status content_status NOT NULL DEFAULT 'DRAFT';
ALTER TABLE templates ADD COLUMN IF NOT EXISTS reviewed_by UUID REFERENCES profiles(id) ON DELETE SET NULL;
ALTER TABLE templates ADD COLUMN IF NOT EXISTS reviewed_at TIMESTAMPTZ;
ALTER TABLE templates ADD COLUMN IF NOT EXISTS created_by UUID REFERENCES profiles(id) ON DELETE SET NULL;
ALTER TABLE templates ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now());

CREATE INDEX IF NOT EXISTS templates_category_idx ON templates(category_id);
CREATE INDEX IF NOT EXISTS templates_status_idx ON templates(status);
CREATE INDEX IF NOT EXISTS templates_org_idx ON templates(org_id);

-- Lo que ya existía se da por publicado para no ocultarlo de golpe.
UPDATE templates SET status = 'PUBLISHED' WHERE status = 'DRAFT' AND created_at < timezone('utc', now());

-- Enlaza la categoría de texto libre que ya había con la tabla nueva.
UPDATE templates t
SET category_id = c.id
FROM template_categories c
WHERE t.category_id IS NULL AND lower(t.category) = lower(c.name);

-- Solo SA&VE publica plantillas maestras; el resto ve las publicadas.
DROP POLICY IF EXISTS "templates_select" ON templates;
CREATE POLICY "templates_select" ON templates FOR SELECT
  USING (
    (is_master = true AND status = 'PUBLISHED')
    OR org_id IN (SELECT public.user_org_ids(auth.uid()))
    OR public.is_save_admin(auth.uid())
  );

-- ==========================================================
-- 7. SECCIONES Y ANEXOS
--    Un anexo es una sección marcada. Misma tabla, misma lógica.
-- ==========================================================

CREATE TABLE IF NOT EXISTS template_sections (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id UUID NOT NULL REFERENCES templates(id) ON DELETE CASCADE,
  title VARCHAR NOT NULL,
  body TEXT,
  sort_order INT NOT NULL DEFAULT 0,
  is_enabled BOOLEAN NOT NULL DEFAULT true,
  is_annex BOOLEAN NOT NULL DEFAULT false,
  condition JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now())
);

CREATE INDEX IF NOT EXISTS template_sections_template_idx
  ON template_sections(template_id, sort_order);

-- ==========================================================
-- 8. QUÉ VARIABLES Y CLÁUSULAS USA CADA PLANTILLA
-- ==========================================================

CREATE TABLE IF NOT EXISTS template_variables (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id UUID NOT NULL REFERENCES templates(id) ON DELETE CASCADE,
  variable_id UUID NOT NULL REFERENCES variables(id) ON DELETE CASCADE,
  section_id UUID REFERENCES template_sections(id) ON DELETE SET NULL,
  sort_order INT NOT NULL DEFAULT 0,
  is_required BOOLEAN,
  UNIQUE (template_id, variable_id)
);

COMMENT ON COLUMN template_variables.is_required IS
  'Si es NULL manda variables.is_required. Permite que una variable sea obligatoria en una plantilla y opcional en otra.';

CREATE TABLE IF NOT EXISTS template_clauses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id UUID NOT NULL REFERENCES templates(id) ON DELETE CASCADE,
  clause_id UUID NOT NULL REFERENCES clauses(id) ON DELETE CASCADE,
  section_id UUID REFERENCES template_sections(id) ON DELETE SET NULL,
  kind clause_kind NOT NULL DEFAULT 'MANDATORY',
  is_default_on BOOLEAN NOT NULL DEFAULT true,
  sort_order INT NOT NULL DEFAULT 0,
  condition JSONB,
  UNIQUE (template_id, clause_id)
);

COMMENT ON TABLE template_clauses IS
  'Vincular aquí una cláusula BASTA para que salga en el documento. No hace falta ningún marcador escrito a mano en el texto.';
COMMENT ON COLUMN template_clauses.condition IS
  'Solo para kind = CONDITIONAL. Árbol de condiciones con AND/OR/NOT.';

CREATE INDEX IF NOT EXISTS template_variables_template_idx ON template_variables(template_id, sort_order);
CREATE INDEX IF NOT EXISTS template_clauses_template_idx ON template_clauses(template_id, sort_order);

-- ==========================================================
-- 9. REGLAS
--    conditions es un árbol, no una tripleta: soporta AND/OR/NOT.
--    { "op": "AND", "children": [
--        { "variable": "mascotas", "operator": "is_true" },
--        { "op": "NOT", "children": [ { "variable": "tipo", "operator": "equals", "value": "comercial" } ] }
--    ] }
-- ==========================================================

CREATE TABLE IF NOT EXISTS template_rules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id UUID NOT NULL REFERENCES templates(id) ON DELETE CASCADE,
  name VARCHAR NOT NULL,
  conditions JSONB NOT NULL,
  action VARCHAR NOT NULL,
  action_payload JSONB NOT NULL DEFAULT '{}'::jsonb,
  is_active BOOLEAN NOT NULL DEFAULT true,
  sort_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now())
);

COMMENT ON COLUMN template_rules.action IS
  'SHOW_CLAUSE, HIDE_CLAUSE, SHOW_SECTION, HIDE_SECTION, SHOW_VARIABLE, HIDE_VARIABLE, REQUIRE_VARIABLE, OPTIONAL_VARIABLE, SET_VALUE, WARN_USER.';

CREATE INDEX IF NOT EXISTS template_rules_template_idx ON template_rules(template_id, sort_order);

-- ==========================================================
-- 10. HISTORIAL DE VERSIONES
--     El snapshot congela la plantilla entera. Un documento
--     generado apunta a la versión con la que se hizo, así que
--     editar la plantilla nunca cambia documentos ya emitidos.
-- ==========================================================

CREATE TABLE IF NOT EXISTS template_versions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id UUID NOT NULL REFERENCES templates(id) ON DELETE CASCADE,
  version VARCHAR NOT NULL,
  snapshot JSONB NOT NULL,
  status content_status NOT NULL DEFAULT 'PUBLISHED',
  note TEXT,
  published_at TIMESTAMPTZ,
  created_by UUID REFERENCES profiles(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now()),
  UNIQUE (template_id, version)
);

-- Un snapshot vacío destruiría la plantilla al restaurarlo.
-- Esto lo impide a nivel de base de datos.
ALTER TABLE template_versions DROP CONSTRAINT IF EXISTS template_versions_snapshot_not_empty;
ALTER TABLE template_versions ADD CONSTRAINT template_versions_snapshot_not_empty
  CHECK (snapshot ? 'template');

CREATE INDEX IF NOT EXISTS template_versions_template_idx ON template_versions(template_id, created_at DESC);

-- ==========================================================
-- 11. DOCUMENTOS GENERADOS
-- ==========================================================

ALTER TABLE documents ADD COLUMN IF NOT EXISTS template_version_id UUID REFERENCES template_versions(id) ON DELETE SET NULL;
ALTER TABLE documents ADD COLUMN IF NOT EXISTS content TEXT;
ALTER TABLE documents ADD COLUMN IF NOT EXISTS clause_selection JSONB NOT NULL DEFAULT '{}'::jsonb;
ALTER TABLE documents ADD COLUMN IF NOT EXISTS generated_at TIMESTAMPTZ;

COMMENT ON COLUMN documents.template_version_id IS
  'Versión exacta con la que se generó. Editar la plantilla no altera este documento.';
COMMENT ON COLUMN documents.clause_selection IS
  'Qué cláusulas opcionales activó el usuario, para poder reconstruir el documento.';

CREATE INDEX IF NOT EXISTS documents_org_idx ON documents(org_id, created_at DESC);

-- ==========================================================
-- 12. POLÍTICAS DE LAS TABLAS HIJAS
--     Todas heredan el acceso de su plantilla. Se resuelve con
--     una función SECURITY DEFINER para no repetir el subselect
--     ni arriesgar recursión.
-- ==========================================================

CREATE OR REPLACE FUNCTION public.can_read_template(uid UUID, tid UUID)
RETURNS BOOLEAN
LANGUAGE sql SECURITY DEFINER STABLE SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM templates t
    WHERE t.id = tid
      AND (
        (t.is_master = true AND t.status = 'PUBLISHED')
        OR t.org_id IN (SELECT public.user_org_ids(uid))
        OR public.is_save_admin(uid)
      )
  );
$$;

CREATE OR REPLACE FUNCTION public.can_edit_template(uid UUID, tid UUID)
RETURNS BOOLEAN
LANGUAGE sql SECURITY DEFINER STABLE SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM templates t
    WHERE t.id = tid
      AND (
        (t.is_master = false AND t.org_id IN (SELECT public.user_org_ids(uid)))
        OR public.is_save_admin(uid)
      )
  );
$$;

DO $$
DECLARE tbl TEXT;
BEGIN
  FOREACH tbl IN ARRAY ARRAY['template_sections', 'template_variables', 'template_clauses', 'template_rules', 'template_versions']
  LOOP
    EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', tbl);

    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', tbl || '_select', tbl);
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', tbl || '_write', tbl);

    EXECUTE format(
      'CREATE POLICY %I ON %I FOR SELECT USING (public.can_read_template(auth.uid(), template_id))',
      tbl || '_select', tbl
    );

    EXECUTE format(
      'CREATE POLICY %I ON %I FOR ALL USING (public.can_edit_template(auth.uid(), template_id)) WITH CHECK (public.can_edit_template(auth.uid(), template_id))',
      tbl || '_write', tbl
    );
  END LOOP;
END $$;

-- ==========================================================
-- 13. updated_at automático
-- ==========================================================

DROP TRIGGER IF EXISTS update_templates_modtime ON templates;
CREATE TRIGGER update_templates_modtime
  BEFORE UPDATE ON templates
  FOR EACH ROW EXECUTE PROCEDURE update_modified_column();

DROP TRIGGER IF EXISTS update_clauses_modtime ON clauses;
CREATE TRIGGER update_clauses_modtime
  BEFORE UPDATE ON clauses
  FOR EACH ROW EXECUTE PROCEDURE update_modified_column();

DROP TRIGGER IF EXISTS update_variables_modtime ON variables;
CREATE TRIGGER update_variables_modtime
  BEFORE UPDATE ON variables
  FOR EACH ROW EXECUTE PROCEDURE update_modified_column();
