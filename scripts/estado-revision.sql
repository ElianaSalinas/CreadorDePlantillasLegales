-- ==========================================================
-- Estado de la revisión del catálogo.
-- Pegar completo en el SQL Editor de Supabase.
-- ==========================================================

-- ---------- 1. ¿Quedó bien aplicada la migración? ----------
SELECT 'tabla revisores_contenido' AS comprobacion,
       to_regclass('public.revisores_contenido') IS NOT NULL AS ok
UNION ALL SELECT 'funcion es_revisor_contenido',
       EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'es_revisor_contenido')
UNION ALL SELECT 'funcion contar_catalogo_publicado',
       EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'contar_catalogo_publicado')
UNION ALL SELECT 'guardian del catalogo en templates',
       EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'guard_catalogo_maestro'
               AND tgrelid = 'public.templates'::regclass)
UNION ALL SELECT 'guardian del catalogo en clauses',
       EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'guard_catalogo_maestro'
               AND tgrelid = 'public.clauses'::regclass)
UNION ALL SELECT 'la revisora ve los borradores del maestro',
       (SELECT qual::text LIKE '%es_revisor_contenido%' FROM pg_policies
        WHERE tablename = 'templates' AND policyname = 'templates_select')
UNION ALL SELECT 'la revisora NO puede borrar el maestro',
       (SELECT qual::text NOT LIKE '%es_revisor_contenido%' FROM pg_policies
        WHERE tablename = 'templates' AND policyname = 'templates_delete');

-- ---------- 2. ¿Está enlazada la abogada? ----------
-- user_id en NULL es normal MIENTRAS no se haya registrado.
SELECT email, nombre, activo,
       user_id IS NOT NULL AS ya_tiene_cuenta,
       linked_at
  FROM revisores_contenido;

-- ---------- 3. Cómo va la revisión ----------
SELECT 'plantillas maestras' AS que,
       COUNT(*) FILTER (WHERE status = 'PUBLISHED') AS aprobadas,
       COUNT(*) FILTER (WHERE status <> 'PUBLISHED') AS pendientes,
       COUNT(*) AS total
  FROM templates WHERE is_master
UNION ALL
SELECT 'clausulas globales',
       COUNT(*) FILTER (WHERE status = 'PUBLISHED'),
       COUNT(*) FILTER (WHERE status <> 'PUBLISHED'),
       COUNT(*)
  FROM clauses WHERE org_id IS NULL;

-- Lo mismo que ve la portada:
SELECT * FROM public.contar_catalogo_publicado();

-- ==========================================================
-- 4. QUÉ VA A REBOTAR AL APROBAR, Y POR QUÉ
--
--    El sistema no publica una plantilla maestra si le falta algo. Vale
--    la pena saberlo ANTES de que la abogada se siente a revisar, para
--    no hacerle perder la tarde. Estas dos consultas dicen exactamente
--    lo mismo que la comprobación de calidad de la aplicación.
-- ==========================================================

-- 4a. Variables que el texto usa pero que nadie declaró en el formulario.
--     Esto es lo único que impide publicar y que hay que arreglar a mano.
WITH usadas AS (
  SELECT t.id, t.title, m[1] AS tag
    FROM templates t
    JOIN template_sections s ON s.template_id = t.id
    CROSS JOIN LATERAL regexp_matches(COALESCE(s.body, ''), '\{\{\s*([A-Za-z0-9_]+)\s*\}\}', 'g') AS m
   WHERE t.is_master
  UNION
  SELECT t.id, t.title, m[1]
    FROM templates t
    JOIN template_clauses tc ON tc.template_id = t.id
    JOIN clauses c ON c.id = tc.clause_id
    CROSS JOIN LATERAL regexp_matches(COALESCE(c.body, ''), '\{\{\s*([A-Za-z0-9_]+)\s*\}\}', 'g') AS m
   WHERE t.is_master
),
declaradas AS (
  SELECT tv.template_id, v.tag
    FROM template_variables tv
    JOIN variables v ON v.id = tv.variable_id
  UNION
  -- Las derivadas ({{precio_letras}}) existen aunque no sean una variable.
  SELECT tv.template_id,
         COALESCE(v.derived_config->>'as', v.tag || '_' || (v.derived_config->>'transform'))
    FROM template_variables tv
    JOIN variables v ON v.id = tv.variable_id
   WHERE v.derived_config->>'transform' IS NOT NULL
)
SELECT u.title AS plantilla,
       string_agg(DISTINCT u.tag, ', ' ORDER BY u.tag) AS variables_que_faltan
  FROM usadas u
 WHERE NOT EXISTS (
        SELECT 1 FROM declaradas d WHERE d.template_id = u.id AND d.tag = u.tag)
 GROUP BY u.title
 ORDER BY u.title;

-- 4b. Plantillas atadas a cláusulas todavía en borrador.
--     Estas NO hay que arreglarlas: se resuelven solas en cuanto se
--     aprueben las cláusulas. Por eso conviene empezar por ellas.
SELECT COUNT(DISTINCT t.id) AS plantillas_esperando_a_sus_clausulas
  FROM templates t
  JOIN template_clauses tc ON tc.template_id = t.id
  JOIN clauses c ON c.id = tc.clause_id
 WHERE t.is_master
   AND c.org_id IS NULL
   AND c.status <> 'PUBLISHED';

-- 4c. Plantillas sin secciones o solo con anexos (saldrían vacías).
SELECT t.title AS plantilla_sin_cuerpo
  FROM templates t
 WHERE t.is_master
   AND NOT EXISTS (
        SELECT 1 FROM template_sections s
         WHERE s.template_id = t.id AND s.is_annex = false)
 ORDER BY t.title;
