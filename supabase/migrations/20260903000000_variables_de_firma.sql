-- ==========================================================
-- SA&VE Comercial, S.R.L. — Punta Cana, República Dominicana
-- FASE 1 · Las variables de la firma, que bloqueaban el catálogo entero
--
-- SÍNTOMA
--
-- Ninguna de las 250 plantillas maestras se podía aprobar. Todas
-- terminan con "Hecho y firmado en {{ciudad_firma}}, República
-- Dominicana, {{fecha_firma_notarial}}", y checkTemplateQuality
-- marcaba {{fecha_firma_notarial}} como variable inexistente. Es un
-- bloqueante, así que la abogada habría rebotado 250 veces seguidas.
--
-- CAUSA
--
-- {{fecha_firma_notarial}} no es una variable: es el ALIAS DERIVADO de
-- la variable `fecha_firma`, que lleva
-- derived_config = {"transform":"fecha_notarial","as":"fecha_firma_notarial"}.
--
-- El generador del catálogo enganchaba a cada plantilla el alias en vez
-- de la variable (scripts/generate-catalog.ts, TAGS_SECCIONES). Como el
-- enganche es un INSERT ... SELECT que une contra `variables`, y el
-- alias no es ninguna fila de esa tabla, la unión no devolvía nada y el
-- enganche se perdía en silencio: ni error, ni fila.
--
-- Y quality.ts solo reconoce los alias de las variables ENGANCHADAS a
-- esa plantilla, no los de toda la base. Sin `fecha_firma` enganchada,
-- el alias no existe para esa plantilla.
--
-- QUÉ HACE ESTE ARCHIVO
--
-- 1. Se asegura de que existan las cuatro variables. Las declara igual
--    que 20260826000000_seed_arrendamiento.sql, por si ese seed nunca
--    llegó a ejecutarse en producción. Si ya están, no toca nada.
--
-- 2. Engancha a cada plantilla maestra TODAS las variables que su texto
--    usa de verdad —resolviendo los alias derivados hasta la variable
--    que los produce—, no solo estas cuatro. Así queda cerrada la clase
--    entera de fallo, no el caso concreto.
--
-- Es repetible: lanzarlo dos veces no duplica nada.
-- ==========================================================

-- ==========================================================
-- 1. LAS CUATRO VARIABLES
-- ==========================================================

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES
  (NULL, 'ciudad_firma', 'Ciudad de firma', '¿Dónde se firma?', NULL,
   'text', '[]'::jsonb, 'Punta Cana', true, NULL),

  -- La que arregla las 250. El texto usa su alias, no su nombre.
  (NULL, 'fecha_firma', 'Fecha de firma', '¿Cuándo se firma?', NULL,
   'date', '[]'::jsonb, NULL, true,
   '{"transform":"fecha_notarial","as":"fecha_firma_notarial"}'::jsonb),

  (NULL, 'dia_pago', 'Día de pago', '¿Qué día de cada mes se paga?',
   'Un número del 1 al 31.',
   'number', '[]'::jsonb, NULL, true, NULL),

  (NULL, 'direccion_inmueble', 'Dirección del inmueble', '¿Dónde está el inmueble?', NULL,
   'address', '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

-- Si `fecha_firma` ya existía pero sin su derived_config, el alias
-- seguiría sin resolverse. Se repara sin pisar nada más.
UPDATE variables
   SET derived_config = '{"transform":"fecha_notarial","as":"fecha_firma_notarial"}'::jsonb
 WHERE org_id IS NULL
   AND tag = 'fecha_firma'
   AND (derived_config IS NULL OR derived_config->>'as' IS DISTINCT FROM 'fecha_firma_notarial');

-- ==========================================================
-- 2. ENGANCHAR LO QUE CADA PLANTILLA USA DE VERDAD
--
--    Se lee el texto —secciones propias y cláusulas enlazadas—, se
--    saca cada {{etiqueta}} y se busca la variable que la produce:
--    o bien porque su `tag` es esa etiqueta, o bien porque la genera
--    como alias derivado.
-- ==========================================================

WITH usadas AS (
  SELECT t.id AS template_id, m[1] AS etiqueta
    FROM templates t
    JOIN template_sections s ON s.template_id = t.id
    CROSS JOIN LATERAL regexp_matches(COALESCE(s.body, ''), '\{\{\s*([A-Za-z0-9_]+)', 'g') AS m
   WHERE t.is_master
  UNION
  SELECT t.id, m[1]
    FROM templates t
    JOIN template_clauses tc ON tc.template_id = t.id
    JOIN clauses c ON c.id = tc.clause_id
    CROSS JOIN LATERAL regexp_matches(COALESCE(c.body, ''), '\{\{\s*([A-Za-z0-9_]+)', 'g') AS m
   WHERE t.is_master
),
resueltas AS (
  SELECT DISTINCT u.template_id, v.id AS variable_id
    FROM usadas u
    JOIN variables v
      ON v.org_id IS NULL
     AND (
          v.tag = u.etiqueta
          OR v.derived_config->>'as' = u.etiqueta
          OR (v.derived_config->>'transform' IS NOT NULL
              AND v.tag || '_' || (v.derived_config->>'transform') = u.etiqueta)
         )
),
siguiente AS (
  SELECT template_id, COALESCE(MAX(sort_order), 0) AS tope
    FROM template_variables
   GROUP BY template_id
)
INSERT INTO template_variables (template_id, variable_id, sort_order, is_required)
SELECT r.template_id,
       r.variable_id,
       COALESCE(s.tope, 0) + ROW_NUMBER() OVER (PARTITION BY r.template_id ORDER BY r.variable_id),
       NULL
  FROM resueltas r
  LEFT JOIN siguiente s ON s.template_id = r.template_id
 WHERE NOT EXISTS (
        SELECT 1 FROM template_variables tv
         WHERE tv.template_id = r.template_id
           AND tv.variable_id = r.variable_id)
ON CONFLICT (template_id, variable_id) DO NOTHING;

-- ==========================================================
-- 3. QUÉ QUEDA SIN RESOLVER
--
--    Si esto devuelve filas, esas etiquetas no existen como variable
--    ni como alias de ninguna, y hay que crearlas a mano. Si devuelve
--    cero, ya no queda ninguna plantilla bloqueada por variables.
-- ==========================================================

WITH usadas AS (
  SELECT t.id AS template_id, t.title, m[1] AS etiqueta
    FROM templates t
    JOIN template_sections s ON s.template_id = t.id
    CROSS JOIN LATERAL regexp_matches(COALESCE(s.body, ''), '\{\{\s*([A-Za-z0-9_]+)', 'g') AS m
   WHERE t.is_master
  UNION
  SELECT t.id, t.title, m[1]
    FROM templates t
    JOIN template_clauses tc ON tc.template_id = t.id
    JOIN clauses c ON c.id = tc.clause_id
    CROSS JOIN LATERAL regexp_matches(COALESCE(c.body, ''), '\{\{\s*([A-Za-z0-9_]+)', 'g') AS m
   WHERE t.is_master
),
enganchadas AS (
  SELECT tv.template_id, v.tag, v.derived_config
    FROM template_variables tv
    JOIN variables v ON v.id = tv.variable_id
)
SELECT u.etiqueta,
       COUNT(DISTINCT u.template_id) AS plantillas_bloqueadas
  FROM usadas u
 WHERE NOT EXISTS (
        SELECT 1 FROM enganchadas e
         WHERE e.template_id = u.template_id
           AND (e.tag = u.etiqueta
                OR e.derived_config->>'as' = u.etiqueta
                OR (e.derived_config->>'transform' IS NOT NULL
                    AND e.tag || '_' || (e.derived_config->>'transform') = u.etiqueta)))
 GROUP BY u.etiqueta
 ORDER BY plantillas_bloqueadas DESC;
