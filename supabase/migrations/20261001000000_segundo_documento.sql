-- ═══════════════════════════════════════════════════════════════════
-- Segundo documento de identidad, y tipo de documento para las
-- personas 2 a 4 de cada parte. 1 de octubre de 2026.
--
-- QUÉ HACE
--   Una persona puede identificarse con dos documentos (cédula y
--   pasaporte, por ejemplo) y el contrato debe mencionar los dos:
--     "portador de la cédula de identidad y electoral número
--      001-0000000-1, y del pasaporte número AB1234567, domiciliado en…"
--   Además, las personas 2 a 4 de cada parte decían FIJO "cédula de
--   identidad y electoral": un segundo comprador extranjero no se podía
--   poner con su pasaporte.
--
-- CÓMO
--   1. 22 variables nuevas (para 8 personas: quien firma por cada parte
--      y las personas 2, 3 y 4 de cada una).
--   2. El texto de Comparecientes de las plantillas.
--   3. Enlaza las variables nuevas a las plantillas que ya tienen a esa
--      persona.
--   4. Reglas para que el formulario solo pida lo que aplica.
--   5. Comprobación al final: léela, no la ignores.
--
-- SEGURIDAD
--   Aditiva: no reescribe ninguna migración anterior. Cada paso tiene su
--   guarda (ON CONFLICT / NOT LIKE / NOT EXISTS): se puede correr dos
--   veces sin duplicar nada. No toca el estado (DRAFT/PUBLISHED) de
--   ninguna plantilla ni ningún documento ya generado.
--
--   La fuente equivalente está en scripts/catalog/variables.ts
--   (PERSONAS_CON_DOCUMENTO) y scripts/generate-catalog.ts: un
--   catalog:build futuro produce lo mismo.
--
-- PEGAR COMPLETO EN EL SQL EDITOR DE SUPABASE.
-- ═══════════════════════════════════════════════════════════════════

BEGIN;

-- ── 1. Variables ─────────────────────────────────────────────────────

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_primera_tipo_documento_2', 'Otro documento de quien firma por la primera parte', '¿Tiene además otro documento de identidad?',
  'Por ejemplo, cédula y pasaporte. Si lo indicas, el contrato menciona los dos.',
  'select'::variable_data_type, '[{"value": "ninguno", "label": "No, solo uno"}, {"value": "la cédula de identidad y electoral", "label": "Cédula de identidad y electoral"}, {"value": "el pasaporte", "label": "Pasaporte"}, {"value": "la licencia de conducir", "label": "Licencia de conducir"}, {"value": "el carnet de residencia", "label": "Carnet de residencia"}]'::jsonb, 'ninguno', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_primera_documento_2', 'Número del otro documento de quien firma por la primera parte', 'Número del otro documento', NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform": "otro_documento", "as": "parte_primera_otro_documento"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_primera_miembro2_tipo_documento', 'Tipo de documento de la segunda persona de la primera parte', '¿Con qué documento se identifica?', NULL,
  'select'::variable_data_type, '[{"value": "la cédula de identidad y electoral", "label": "Cédula de identidad y electoral"}, {"value": "el pasaporte", "label": "Pasaporte"}, {"value": "la licencia de conducir", "label": "Licencia de conducir"}, {"value": "el carnet de residencia", "label": "Carnet de residencia"}]'::jsonb, 'la cédula de identidad y electoral', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_primera_miembro2_tipo_documento_2', 'Otro documento de la segunda persona de la primera parte', '¿Tiene además otro documento de identidad?',
  'Por ejemplo, cédula y pasaporte. Si lo indicas, el contrato menciona los dos.',
  'select'::variable_data_type, '[{"value": "ninguno", "label": "No, solo uno"}, {"value": "la cédula de identidad y electoral", "label": "Cédula de identidad y electoral"}, {"value": "el pasaporte", "label": "Pasaporte"}, {"value": "la licencia de conducir", "label": "Licencia de conducir"}, {"value": "el carnet de residencia", "label": "Carnet de residencia"}]'::jsonb, 'ninguno', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_primera_miembro2_documento_2', 'Número del otro documento de la segunda persona de la primera parte', 'Número del otro documento', NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform": "otro_documento", "as": "parte_primera_miembro2_otro_documento"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_primera_miembro3_tipo_documento', 'Tipo de documento de la tercera persona de la primera parte', '¿Con qué documento se identifica?', NULL,
  'select'::variable_data_type, '[{"value": "la cédula de identidad y electoral", "label": "Cédula de identidad y electoral"}, {"value": "el pasaporte", "label": "Pasaporte"}, {"value": "la licencia de conducir", "label": "Licencia de conducir"}, {"value": "el carnet de residencia", "label": "Carnet de residencia"}]'::jsonb, 'la cédula de identidad y electoral', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_primera_miembro3_tipo_documento_2', 'Otro documento de la tercera persona de la primera parte', '¿Tiene además otro documento de identidad?',
  'Por ejemplo, cédula y pasaporte. Si lo indicas, el contrato menciona los dos.',
  'select'::variable_data_type, '[{"value": "ninguno", "label": "No, solo uno"}, {"value": "la cédula de identidad y electoral", "label": "Cédula de identidad y electoral"}, {"value": "el pasaporte", "label": "Pasaporte"}, {"value": "la licencia de conducir", "label": "Licencia de conducir"}, {"value": "el carnet de residencia", "label": "Carnet de residencia"}]'::jsonb, 'ninguno', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_primera_miembro3_documento_2', 'Número del otro documento de la tercera persona de la primera parte', 'Número del otro documento', NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform": "otro_documento", "as": "parte_primera_miembro3_otro_documento"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_primera_miembro4_tipo_documento', 'Tipo de documento de la cuarta persona de la primera parte', '¿Con qué documento se identifica?', NULL,
  'select'::variable_data_type, '[{"value": "la cédula de identidad y electoral", "label": "Cédula de identidad y electoral"}, {"value": "el pasaporte", "label": "Pasaporte"}, {"value": "la licencia de conducir", "label": "Licencia de conducir"}, {"value": "el carnet de residencia", "label": "Carnet de residencia"}]'::jsonb, 'la cédula de identidad y electoral', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_primera_miembro4_tipo_documento_2', 'Otro documento de la cuarta persona de la primera parte', '¿Tiene además otro documento de identidad?',
  'Por ejemplo, cédula y pasaporte. Si lo indicas, el contrato menciona los dos.',
  'select'::variable_data_type, '[{"value": "ninguno", "label": "No, solo uno"}, {"value": "la cédula de identidad y electoral", "label": "Cédula de identidad y electoral"}, {"value": "el pasaporte", "label": "Pasaporte"}, {"value": "la licencia de conducir", "label": "Licencia de conducir"}, {"value": "el carnet de residencia", "label": "Carnet de residencia"}]'::jsonb, 'ninguno', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_primera_miembro4_documento_2', 'Número del otro documento de la cuarta persona de la primera parte', 'Número del otro documento', NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform": "otro_documento", "as": "parte_primera_miembro4_otro_documento"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_segunda_tipo_documento_2', 'Otro documento de quien firma por la segunda parte', '¿Tiene además otro documento de identidad?',
  'Por ejemplo, cédula y pasaporte. Si lo indicas, el contrato menciona los dos.',
  'select'::variable_data_type, '[{"value": "ninguno", "label": "No, solo uno"}, {"value": "la cédula de identidad y electoral", "label": "Cédula de identidad y electoral"}, {"value": "el pasaporte", "label": "Pasaporte"}, {"value": "la licencia de conducir", "label": "Licencia de conducir"}, {"value": "el carnet de residencia", "label": "Carnet de residencia"}]'::jsonb, 'ninguno', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_segunda_documento_2', 'Número del otro documento de quien firma por la segunda parte', 'Número del otro documento', NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform": "otro_documento", "as": "parte_segunda_otro_documento"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_segunda_miembro2_tipo_documento', 'Tipo de documento de la segunda persona de la segunda parte', '¿Con qué documento se identifica?', NULL,
  'select'::variable_data_type, '[{"value": "la cédula de identidad y electoral", "label": "Cédula de identidad y electoral"}, {"value": "el pasaporte", "label": "Pasaporte"}, {"value": "la licencia de conducir", "label": "Licencia de conducir"}, {"value": "el carnet de residencia", "label": "Carnet de residencia"}]'::jsonb, 'la cédula de identidad y electoral', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_segunda_miembro2_tipo_documento_2', 'Otro documento de la segunda persona de la segunda parte', '¿Tiene además otro documento de identidad?',
  'Por ejemplo, cédula y pasaporte. Si lo indicas, el contrato menciona los dos.',
  'select'::variable_data_type, '[{"value": "ninguno", "label": "No, solo uno"}, {"value": "la cédula de identidad y electoral", "label": "Cédula de identidad y electoral"}, {"value": "el pasaporte", "label": "Pasaporte"}, {"value": "la licencia de conducir", "label": "Licencia de conducir"}, {"value": "el carnet de residencia", "label": "Carnet de residencia"}]'::jsonb, 'ninguno', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_segunda_miembro2_documento_2', 'Número del otro documento de la segunda persona de la segunda parte', 'Número del otro documento', NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform": "otro_documento", "as": "parte_segunda_miembro2_otro_documento"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_segunda_miembro3_tipo_documento', 'Tipo de documento de la tercera persona de la segunda parte', '¿Con qué documento se identifica?', NULL,
  'select'::variable_data_type, '[{"value": "la cédula de identidad y electoral", "label": "Cédula de identidad y electoral"}, {"value": "el pasaporte", "label": "Pasaporte"}, {"value": "la licencia de conducir", "label": "Licencia de conducir"}, {"value": "el carnet de residencia", "label": "Carnet de residencia"}]'::jsonb, 'la cédula de identidad y electoral', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_segunda_miembro3_tipo_documento_2', 'Otro documento de la tercera persona de la segunda parte', '¿Tiene además otro documento de identidad?',
  'Por ejemplo, cédula y pasaporte. Si lo indicas, el contrato menciona los dos.',
  'select'::variable_data_type, '[{"value": "ninguno", "label": "No, solo uno"}, {"value": "la cédula de identidad y electoral", "label": "Cédula de identidad y electoral"}, {"value": "el pasaporte", "label": "Pasaporte"}, {"value": "la licencia de conducir", "label": "Licencia de conducir"}, {"value": "el carnet de residencia", "label": "Carnet de residencia"}]'::jsonb, 'ninguno', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_segunda_miembro3_documento_2', 'Número del otro documento de la tercera persona de la segunda parte', 'Número del otro documento', NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform": "otro_documento", "as": "parte_segunda_miembro3_otro_documento"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_segunda_miembro4_tipo_documento', 'Tipo de documento de la cuarta persona de la segunda parte', '¿Con qué documento se identifica?', NULL,
  'select'::variable_data_type, '[{"value": "la cédula de identidad y electoral", "label": "Cédula de identidad y electoral"}, {"value": "el pasaporte", "label": "Pasaporte"}, {"value": "la licencia de conducir", "label": "Licencia de conducir"}, {"value": "el carnet de residencia", "label": "Carnet de residencia"}]'::jsonb, 'la cédula de identidad y electoral', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_segunda_miembro4_tipo_documento_2', 'Otro documento de la cuarta persona de la segunda parte', '¿Tiene además otro documento de identidad?',
  'Por ejemplo, cédula y pasaporte. Si lo indicas, el contrato menciona los dos.',
  'select'::variable_data_type, '[{"value": "ninguno", "label": "No, solo uno"}, {"value": "la cédula de identidad y electoral", "label": "Cédula de identidad y electoral"}, {"value": "el pasaporte", "label": "Pasaporte"}, {"value": "la licencia de conducir", "label": "Licencia de conducir"}, {"value": "el carnet de residencia", "label": "Carnet de residencia"}]'::jsonb, 'ninguno', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_segunda_miembro4_documento_2', 'Número del otro documento de la cuarta persona de la segunda parte', 'Número del otro documento', NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform": "otro_documento", "as": "parte_segunda_miembro4_otro_documento"}'::jsonb)
ON CONFLICT DO NOTHING;

-- ── 2. Texto de Comparecientes ───────────────────────────────────────
-- Quien firma por cada parte (variantes persona y empresa): el segundo
-- documento va pegado detrás del primer número.

UPDATE template_sections
SET body = REPLACE(body, 'número {{parte_primera_cedula}}, {{parte_primera_domiciliado}}', 'número {{parte_primera_cedula}}{{parte_primera_otro_documento}}, {{parte_primera_domiciliado}}')
WHERE body LIKE '%número {{parte_primera_cedula}}, {{parte_primera_domiciliado}}%'
  AND body NOT LIKE '%parte_primera_otro_documento%';

UPDATE template_sections
SET body = REPLACE(body, 'número {{parte_segunda_cedula}}, {{parte_segunda_domiciliado}}', 'número {{parte_segunda_cedula}}{{parte_segunda_otro_documento}}, {{parte_segunda_domiciliado}}')
WHERE body LIKE '%número {{parte_segunda_cedula}}, {{parte_segunda_domiciliado}}%'
  AND body NOT LIKE '%parte_segunda_otro_documento%';

-- Personas 2 a 4: dejan de decir "cédula" fijo.

UPDATE template_sections
SET body = REPLACE(body, 'portador(a) de cédula de identidad y electoral número {{parte_primera_miembro2_cedula}}', 'portador(a) de {{parte_primera_miembro2_tipo_documento}} número {{parte_primera_miembro2_cedula}}{{parte_primera_miembro2_otro_documento}}')
WHERE body LIKE '%{{parte_primera_miembro2_cedula}}%'
  AND body NOT LIKE '%parte_primera_miembro2_otro_documento%';

UPDATE template_sections
SET body = REPLACE(body, 'portador(a) de cédula de identidad y electoral número {{parte_primera_miembro3_cedula}}', 'portador(a) de {{parte_primera_miembro3_tipo_documento}} número {{parte_primera_miembro3_cedula}}{{parte_primera_miembro3_otro_documento}}')
WHERE body LIKE '%{{parte_primera_miembro3_cedula}}%'
  AND body NOT LIKE '%parte_primera_miembro3_otro_documento%';

UPDATE template_sections
SET body = REPLACE(body, 'portador(a) de cédula de identidad y electoral número {{parte_primera_miembro4_cedula}}', 'portador(a) de {{parte_primera_miembro4_tipo_documento}} número {{parte_primera_miembro4_cedula}}{{parte_primera_miembro4_otro_documento}}')
WHERE body LIKE '%{{parte_primera_miembro4_cedula}}%'
  AND body NOT LIKE '%parte_primera_miembro4_otro_documento%';

UPDATE template_sections
SET body = REPLACE(body, 'portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro2_cedula}}', 'portador(a) de {{parte_segunda_miembro2_tipo_documento}} número {{parte_segunda_miembro2_cedula}}{{parte_segunda_miembro2_otro_documento}}')
WHERE body LIKE '%{{parte_segunda_miembro2_cedula}}%'
  AND body NOT LIKE '%parte_segunda_miembro2_otro_documento%';

UPDATE template_sections
SET body = REPLACE(body, 'portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro3_cedula}}', 'portador(a) de {{parte_segunda_miembro3_tipo_documento}} número {{parte_segunda_miembro3_cedula}}{{parte_segunda_miembro3_otro_documento}}')
WHERE body LIKE '%{{parte_segunda_miembro3_cedula}}%'
  AND body NOT LIKE '%parte_segunda_miembro3_otro_documento%';

UPDATE template_sections
SET body = REPLACE(body, 'portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro4_cedula}}', 'portador(a) de {{parte_segunda_miembro4_tipo_documento}} número {{parte_segunda_miembro4_cedula}}{{parte_segunda_miembro4_otro_documento}}')
WHERE body LIKE '%{{parte_segunda_miembro4_cedula}}%'
  AND body NOT LIKE '%parte_segunda_miembro4_otro_documento%';

-- ── 3. Enlazar a las plantillas que ya tienen a esa persona ─────────
-- Misma sección que su número de documento y al final del orden, para
-- no mover los campos que ya existen.

INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, vn.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_primera_cedula' AND vref.org_id IS NULL
JOIN variables vn ON vn.tag = 'parte_primera_tipo_documento_2' AND vn.org_id IS NULL
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;

INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, vn.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_primera_cedula' AND vref.org_id IS NULL
JOIN variables vn ON vn.tag = 'parte_primera_documento_2' AND vn.org_id IS NULL
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;

INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, vn.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_primera_miembro2_cedula' AND vref.org_id IS NULL
JOIN variables vn ON vn.tag = 'parte_primera_miembro2_tipo_documento' AND vn.org_id IS NULL
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;

INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, vn.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_primera_miembro2_cedula' AND vref.org_id IS NULL
JOIN variables vn ON vn.tag = 'parte_primera_miembro2_tipo_documento_2' AND vn.org_id IS NULL
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;

INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, vn.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_primera_miembro2_cedula' AND vref.org_id IS NULL
JOIN variables vn ON vn.tag = 'parte_primera_miembro2_documento_2' AND vn.org_id IS NULL
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;

INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, vn.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_primera_miembro3_cedula' AND vref.org_id IS NULL
JOIN variables vn ON vn.tag = 'parte_primera_miembro3_tipo_documento' AND vn.org_id IS NULL
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;

INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, vn.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_primera_miembro3_cedula' AND vref.org_id IS NULL
JOIN variables vn ON vn.tag = 'parte_primera_miembro3_tipo_documento_2' AND vn.org_id IS NULL
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;

INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, vn.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_primera_miembro3_cedula' AND vref.org_id IS NULL
JOIN variables vn ON vn.tag = 'parte_primera_miembro3_documento_2' AND vn.org_id IS NULL
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;

INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, vn.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_primera_miembro4_cedula' AND vref.org_id IS NULL
JOIN variables vn ON vn.tag = 'parte_primera_miembro4_tipo_documento' AND vn.org_id IS NULL
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;

INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, vn.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_primera_miembro4_cedula' AND vref.org_id IS NULL
JOIN variables vn ON vn.tag = 'parte_primera_miembro4_tipo_documento_2' AND vn.org_id IS NULL
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;

INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, vn.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_primera_miembro4_cedula' AND vref.org_id IS NULL
JOIN variables vn ON vn.tag = 'parte_primera_miembro4_documento_2' AND vn.org_id IS NULL
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;

INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, vn.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_segunda_cedula' AND vref.org_id IS NULL
JOIN variables vn ON vn.tag = 'parte_segunda_tipo_documento_2' AND vn.org_id IS NULL
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;

INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, vn.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_segunda_cedula' AND vref.org_id IS NULL
JOIN variables vn ON vn.tag = 'parte_segunda_documento_2' AND vn.org_id IS NULL
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;

INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, vn.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_segunda_miembro2_cedula' AND vref.org_id IS NULL
JOIN variables vn ON vn.tag = 'parte_segunda_miembro2_tipo_documento' AND vn.org_id IS NULL
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;

INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, vn.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_segunda_miembro2_cedula' AND vref.org_id IS NULL
JOIN variables vn ON vn.tag = 'parte_segunda_miembro2_tipo_documento_2' AND vn.org_id IS NULL
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;

INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, vn.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_segunda_miembro2_cedula' AND vref.org_id IS NULL
JOIN variables vn ON vn.tag = 'parte_segunda_miembro2_documento_2' AND vn.org_id IS NULL
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;

INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, vn.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_segunda_miembro3_cedula' AND vref.org_id IS NULL
JOIN variables vn ON vn.tag = 'parte_segunda_miembro3_tipo_documento' AND vn.org_id IS NULL
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;

INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, vn.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_segunda_miembro3_cedula' AND vref.org_id IS NULL
JOIN variables vn ON vn.tag = 'parte_segunda_miembro3_tipo_documento_2' AND vn.org_id IS NULL
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;

INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, vn.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_segunda_miembro3_cedula' AND vref.org_id IS NULL
JOIN variables vn ON vn.tag = 'parte_segunda_miembro3_documento_2' AND vn.org_id IS NULL
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;

INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, vn.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_segunda_miembro4_cedula' AND vref.org_id IS NULL
JOIN variables vn ON vn.tag = 'parte_segunda_miembro4_tipo_documento' AND vn.org_id IS NULL
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;

INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, vn.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_segunda_miembro4_cedula' AND vref.org_id IS NULL
JOIN variables vn ON vn.tag = 'parte_segunda_miembro4_tipo_documento_2' AND vn.org_id IS NULL
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;

INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, vn.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_segunda_miembro4_cedula' AND vref.org_id IS NULL
JOIN variables vn ON vn.tag = 'parte_segunda_miembro4_documento_2' AND vn.org_id IS NULL
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;

-- ── 4. Reglas del formulario ────────────────────────────────────────
-- a) El número del segundo documento solo se pide si dijo que lo tiene.
-- b) Los campos nuevos de las personas 2-4 se ocultan, como los demás de
--    esa persona, mientras la cantidad de personas no la incluya.

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_primera_documento_2 si no tiene otro documento', '{"variable": "parte_primera_tipo_documento_2", "operator": "equals", "value": "ninguno"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_documento_2'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_primera_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_primera_documento_2 si no tiene otro documento');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_primera_miembro2_documento_2 si no tiene otro documento', '{"variable": "parte_primera_miembro2_tipo_documento_2", "operator": "equals", "value": "ninguno"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro2_documento_2'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_primera_miembro2_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_primera_miembro2_documento_2 si no tiene otro documento');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_primera_miembro3_documento_2 si no tiene otro documento', '{"variable": "parte_primera_miembro3_tipo_documento_2", "operator": "equals", "value": "ninguno"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro3_documento_2'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_primera_miembro3_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_primera_miembro3_documento_2 si no tiene otro documento');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_primera_miembro4_documento_2 si no tiene otro documento', '{"variable": "parte_primera_miembro4_tipo_documento_2", "operator": "equals", "value": "ninguno"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro4_documento_2'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_primera_miembro4_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_primera_miembro4_documento_2 si no tiene otro documento');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_segunda_documento_2 si no tiene otro documento', '{"variable": "parte_segunda_tipo_documento_2", "operator": "equals", "value": "ninguno"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_documento_2'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_segunda_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_segunda_documento_2 si no tiene otro documento');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_segunda_miembro2_documento_2 si no tiene otro documento', '{"variable": "parte_segunda_miembro2_tipo_documento_2", "operator": "equals", "value": "ninguno"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro2_documento_2'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_segunda_miembro2_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_segunda_miembro2_documento_2 si no tiene otro documento');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_segunda_miembro3_documento_2 si no tiene otro documento', '{"variable": "parte_segunda_miembro3_tipo_documento_2", "operator": "equals", "value": "ninguno"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro3_documento_2'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_segunda_miembro3_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_segunda_miembro3_documento_2 si no tiene otro documento');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_segunda_miembro4_documento_2 si no tiene otro documento', '{"variable": "parte_segunda_miembro4_tipo_documento_2", "operator": "equals", "value": "ninguno"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_documento_2'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_segunda_miembro4_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_segunda_miembro4_documento_2 si no tiene otro documento');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_primera_miembro2_tipo_documento si la parte tiene menos de 2 personas', '{"variable": "parte_primera_cantidad", "operator": "less_than", "value": 2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro2_tipo_documento'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_primera_miembro2_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_primera_miembro2_tipo_documento si la parte tiene menos de 2 personas');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_primera_miembro2_tipo_documento_2 si la parte tiene menos de 2 personas', '{"variable": "parte_primera_cantidad", "operator": "less_than", "value": 2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro2_tipo_documento_2'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_primera_miembro2_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_primera_miembro2_tipo_documento_2 si la parte tiene menos de 2 personas');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_primera_miembro2_documento_2 si la parte tiene menos de 2 personas', '{"variable": "parte_primera_cantidad", "operator": "less_than", "value": 2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro2_documento_2'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_primera_miembro2_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_primera_miembro2_documento_2 si la parte tiene menos de 2 personas');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_primera_miembro3_tipo_documento si la parte tiene menos de 3 personas', '{"variable": "parte_primera_cantidad", "operator": "less_than", "value": 3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro3_tipo_documento'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_primera_miembro3_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_primera_miembro3_tipo_documento si la parte tiene menos de 3 personas');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_primera_miembro3_tipo_documento_2 si la parte tiene menos de 3 personas', '{"variable": "parte_primera_cantidad", "operator": "less_than", "value": 3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro3_tipo_documento_2'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_primera_miembro3_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_primera_miembro3_tipo_documento_2 si la parte tiene menos de 3 personas');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_primera_miembro3_documento_2 si la parte tiene menos de 3 personas', '{"variable": "parte_primera_cantidad", "operator": "less_than", "value": 3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro3_documento_2'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_primera_miembro3_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_primera_miembro3_documento_2 si la parte tiene menos de 3 personas');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_primera_miembro4_tipo_documento si la parte tiene menos de 4 personas', '{"variable": "parte_primera_cantidad", "operator": "less_than", "value": 4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro4_tipo_documento'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_primera_miembro4_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_primera_miembro4_tipo_documento si la parte tiene menos de 4 personas');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_primera_miembro4_tipo_documento_2 si la parte tiene menos de 4 personas', '{"variable": "parte_primera_cantidad", "operator": "less_than", "value": 4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro4_tipo_documento_2'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_primera_miembro4_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_primera_miembro4_tipo_documento_2 si la parte tiene menos de 4 personas');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_primera_miembro4_documento_2 si la parte tiene menos de 4 personas', '{"variable": "parte_primera_cantidad", "operator": "less_than", "value": 4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro4_documento_2'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_primera_miembro4_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_primera_miembro4_documento_2 si la parte tiene menos de 4 personas');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_segunda_miembro2_tipo_documento si la parte tiene menos de 2 personas', '{"variable": "parte_segunda_cantidad", "operator": "less_than", "value": 2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro2_tipo_documento'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_segunda_miembro2_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_segunda_miembro2_tipo_documento si la parte tiene menos de 2 personas');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_segunda_miembro2_tipo_documento_2 si la parte tiene menos de 2 personas', '{"variable": "parte_segunda_cantidad", "operator": "less_than", "value": 2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro2_tipo_documento_2'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_segunda_miembro2_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_segunda_miembro2_tipo_documento_2 si la parte tiene menos de 2 personas');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_segunda_miembro2_documento_2 si la parte tiene menos de 2 personas', '{"variable": "parte_segunda_cantidad", "operator": "less_than", "value": 2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro2_documento_2'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_segunda_miembro2_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_segunda_miembro2_documento_2 si la parte tiene menos de 2 personas');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_segunda_miembro3_tipo_documento si la parte tiene menos de 3 personas', '{"variable": "parte_segunda_cantidad", "operator": "less_than", "value": 3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro3_tipo_documento'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_segunda_miembro3_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_segunda_miembro3_tipo_documento si la parte tiene menos de 3 personas');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_segunda_miembro3_tipo_documento_2 si la parte tiene menos de 3 personas', '{"variable": "parte_segunda_cantidad", "operator": "less_than", "value": 3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro3_tipo_documento_2'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_segunda_miembro3_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_segunda_miembro3_tipo_documento_2 si la parte tiene menos de 3 personas');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_segunda_miembro3_documento_2 si la parte tiene menos de 3 personas', '{"variable": "parte_segunda_cantidad", "operator": "less_than", "value": 3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro3_documento_2'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_segunda_miembro3_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_segunda_miembro3_documento_2 si la parte tiene menos de 3 personas');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_segunda_miembro4_tipo_documento si la parte tiene menos de 4 personas', '{"variable": "parte_segunda_cantidad", "operator": "less_than", "value": 4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_tipo_documento'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_segunda_miembro4_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_segunda_miembro4_tipo_documento si la parte tiene menos de 4 personas');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_segunda_miembro4_tipo_documento_2 si la parte tiene menos de 4 personas', '{"variable": "parte_segunda_cantidad", "operator": "less_than", "value": 4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_tipo_documento_2'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_segunda_miembro4_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_segunda_miembro4_tipo_documento_2 si la parte tiene menos de 4 personas');

INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
SELECT DISTINCT tv.template_id, 'Ocultar parte_segunda_miembro4_documento_2 si la parte tiene menos de 4 personas', '{"variable": "parte_segunda_cantidad", "operator": "less_than", "value": 4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_documento_2'),
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_rules r WHERE r.template_id = tv.template_id)
FROM template_variables tv
JOIN variables vref ON vref.id = tv.variable_id AND vref.tag = 'parte_segunda_miembro4_cedula' AND vref.org_id IS NULL
WHERE NOT EXISTS (SELECT 1 FROM template_rules r WHERE r.template_id = tv.template_id AND r.name = 'Ocultar parte_segunda_miembro4_documento_2 si la parte tiene menos de 4 personas');

COMMIT;

-- ── 5. Comprobación ─────────────────────────────────────────────────
-- Lo esperado: 22 variables; y para cada persona, el mismo número de
-- plantillas con el texto nuevo que con su número de documento enlazado
-- (249 para quien firma; las que tengan personas 2-4 para el resto).
-- Si "con_texto_nuevo" sale menor que "con_la_persona", hay plantillas
-- cuyo texto no coincidía con el esperado: NO seguir, avisar.
SELECT count(*) AS variables_nuevas
FROM variables
WHERE org_id IS NULL
  AND (tag LIKE '%\_tipo\_documento\_2' OR tag LIKE '%\_documento\_2' OR tag ~ '^parte_(primera|segunda)_miembro[2-4]_tipo_documento$');

SELECT 'parte_primera' AS persona,
  (SELECT count(DISTINCT tv.template_id) FROM template_variables tv JOIN variables v ON v.id = tv.variable_id WHERE v.tag = 'parte_primera_cedula' AND v.org_id IS NULL) AS con_la_persona,
  (SELECT count(DISTINCT s.template_id) FROM template_sections s WHERE s.body LIKE '%{{parte_primera_otro_documento}}%') AS con_texto_nuevo,
  (SELECT count(DISTINCT tv.template_id) FROM template_variables tv JOIN variables v ON v.id = tv.variable_id WHERE v.tag = 'parte_primera_documento_2') AS con_variable_nueva
UNION ALL
SELECT 'parte_primera_miembro2' AS persona,
  (SELECT count(DISTINCT tv.template_id) FROM template_variables tv JOIN variables v ON v.id = tv.variable_id WHERE v.tag = 'parte_primera_miembro2_cedula' AND v.org_id IS NULL) AS con_la_persona,
  (SELECT count(DISTINCT s.template_id) FROM template_sections s WHERE s.body LIKE '%{{parte_primera_miembro2_otro_documento}}%') AS con_texto_nuevo,
  (SELECT count(DISTINCT tv.template_id) FROM template_variables tv JOIN variables v ON v.id = tv.variable_id WHERE v.tag = 'parte_primera_miembro2_documento_2') AS con_variable_nueva
UNION ALL
SELECT 'parte_primera_miembro3' AS persona,
  (SELECT count(DISTINCT tv.template_id) FROM template_variables tv JOIN variables v ON v.id = tv.variable_id WHERE v.tag = 'parte_primera_miembro3_cedula' AND v.org_id IS NULL) AS con_la_persona,
  (SELECT count(DISTINCT s.template_id) FROM template_sections s WHERE s.body LIKE '%{{parte_primera_miembro3_otro_documento}}%') AS con_texto_nuevo,
  (SELECT count(DISTINCT tv.template_id) FROM template_variables tv JOIN variables v ON v.id = tv.variable_id WHERE v.tag = 'parte_primera_miembro3_documento_2') AS con_variable_nueva
UNION ALL
SELECT 'parte_primera_miembro4' AS persona,
  (SELECT count(DISTINCT tv.template_id) FROM template_variables tv JOIN variables v ON v.id = tv.variable_id WHERE v.tag = 'parte_primera_miembro4_cedula' AND v.org_id IS NULL) AS con_la_persona,
  (SELECT count(DISTINCT s.template_id) FROM template_sections s WHERE s.body LIKE '%{{parte_primera_miembro4_otro_documento}}%') AS con_texto_nuevo,
  (SELECT count(DISTINCT tv.template_id) FROM template_variables tv JOIN variables v ON v.id = tv.variable_id WHERE v.tag = 'parte_primera_miembro4_documento_2') AS con_variable_nueva
UNION ALL
SELECT 'parte_segunda' AS persona,
  (SELECT count(DISTINCT tv.template_id) FROM template_variables tv JOIN variables v ON v.id = tv.variable_id WHERE v.tag = 'parte_segunda_cedula' AND v.org_id IS NULL) AS con_la_persona,
  (SELECT count(DISTINCT s.template_id) FROM template_sections s WHERE s.body LIKE '%{{parte_segunda_otro_documento}}%') AS con_texto_nuevo,
  (SELECT count(DISTINCT tv.template_id) FROM template_variables tv JOIN variables v ON v.id = tv.variable_id WHERE v.tag = 'parte_segunda_documento_2') AS con_variable_nueva
UNION ALL
SELECT 'parte_segunda_miembro2' AS persona,
  (SELECT count(DISTINCT tv.template_id) FROM template_variables tv JOIN variables v ON v.id = tv.variable_id WHERE v.tag = 'parte_segunda_miembro2_cedula' AND v.org_id IS NULL) AS con_la_persona,
  (SELECT count(DISTINCT s.template_id) FROM template_sections s WHERE s.body LIKE '%{{parte_segunda_miembro2_otro_documento}}%') AS con_texto_nuevo,
  (SELECT count(DISTINCT tv.template_id) FROM template_variables tv JOIN variables v ON v.id = tv.variable_id WHERE v.tag = 'parte_segunda_miembro2_documento_2') AS con_variable_nueva
UNION ALL
SELECT 'parte_segunda_miembro3' AS persona,
  (SELECT count(DISTINCT tv.template_id) FROM template_variables tv JOIN variables v ON v.id = tv.variable_id WHERE v.tag = 'parte_segunda_miembro3_cedula' AND v.org_id IS NULL) AS con_la_persona,
  (SELECT count(DISTINCT s.template_id) FROM template_sections s WHERE s.body LIKE '%{{parte_segunda_miembro3_otro_documento}}%') AS con_texto_nuevo,
  (SELECT count(DISTINCT tv.template_id) FROM template_variables tv JOIN variables v ON v.id = tv.variable_id WHERE v.tag = 'parte_segunda_miembro3_documento_2') AS con_variable_nueva
UNION ALL
SELECT 'parte_segunda_miembro4' AS persona,
  (SELECT count(DISTINCT tv.template_id) FROM template_variables tv JOIN variables v ON v.id = tv.variable_id WHERE v.tag = 'parte_segunda_miembro4_cedula' AND v.org_id IS NULL) AS con_la_persona,
  (SELECT count(DISTINCT s.template_id) FROM template_sections s WHERE s.body LIKE '%{{parte_segunda_miembro4_otro_documento}}%') AS con_texto_nuevo,
  (SELECT count(DISTINCT tv.template_id) FROM template_variables tv JOIN variables v ON v.id = tv.variable_id WHERE v.tag = 'parte_segunda_miembro4_documento_2') AS con_variable_nueva;
