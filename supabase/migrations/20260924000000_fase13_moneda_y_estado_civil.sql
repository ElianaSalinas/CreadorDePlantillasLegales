-- Fase 13.2, correcciones del 24/09/2026.
-- No reemplaza ninguna migración anterior: es aditiva, sobre datos que
-- ya están en producción. Todo usa ON CONFLICT DO NOTHING o una guarda
-- NOT LIKE, así que es seguro correrla más de una vez por accidente.

-- 1. Las dos variables de estado civil, que existían en el catálogo del
--    código pero nunca se habían insertado en Supabase.
INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_primera_estado_civil', 'Estado civil de quien firma por la primera parte', NULL, NULL,
  'select'::variable_data_type,
  '[{"value":"soltero","label":"Soltero(a)"},{"value":"casado","label":"Casado(a)"},{"value":"union_libre","label":"En unión libre"},{"value":"divorciado","label":"Divorciado(a)"},{"value":"viudo","label":"Viudo(a)"}]'::jsonb,
  'soltero', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_segunda_estado_civil', 'Estado civil de quien firma por la segunda parte', NULL, NULL,
  'select'::variable_data_type,
  '[{"value":"soltero","label":"Soltero(a)"},{"value":"casado","label":"Casado(a)"},{"value":"union_libre","label":"En unión libre"},{"value":"divorciado","label":"Divorciado(a)"},{"value":"viudo","label":"Viudo(a)"}]'::jsonb,
  'soltero', true, NULL)
ON CONFLICT DO NOTHING;

-- 2. El texto de "Comparecientes" de las 249 plantillas: se le agrega el
--    estado civil justo después de "mayor de edad,", en las cuatro
--    variantes (persona/empresa × primera/segunda parte).
UPDATE template_sections
SET body = REPLACE(body,
  'mayor de edad, {{parte_primera_portador}} de {{parte_primera_tipo_documento}} número {{parte_primera_cedula}}, {{parte_primera_domiciliado}} en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;',
  'mayor de edad, {{parte_primera_estado_civil}}, {{parte_primera_portador}} de {{parte_primera_tipo_documento}} número {{parte_primera_cedula}}, {{parte_primera_domiciliado}} en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;'
)
WHERE body LIKE '%{{parte_primera_portador}}%'
  AND body NOT LIKE '%{{parte_primera_estado_civil}}%';

UPDATE template_sections
SET body = REPLACE(body,
  'mayor de edad, {{parte_segunda_portador}} de {{parte_segunda_tipo_documento}} número {{parte_segunda_cedula}}, {{parte_segunda_domiciliado}} en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.',
  'mayor de edad, {{parte_segunda_estado_civil}}, {{parte_segunda_portador}} de {{parte_segunda_tipo_documento}} número {{parte_segunda_cedula}}, {{parte_segunda_domiciliado}} en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.'
)
WHERE body LIKE '%{{parte_segunda_portador}}%'
  AND body NOT LIKE '%{{parte_segunda_estado_civil}}%';

-- 3. Vincular estado civil a todas las plantillas que ya tienen género
--    (que son las 249: género está en TAGS_SECCIONES desde hace tiempo).
--    Usa la misma sección y un sort_order al final de esa plantilla, para
--    no reordenar los campos que ya existen.
INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, v_ec.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vg ON vg.id = tv.variable_id AND vg.tag = 'parte_primera_genero'
JOIN variables v_ec ON v_ec.tag = 'parte_primera_estado_civil'
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;

INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, v_ec.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vg ON vg.id = tv.variable_id AND vg.tag = 'parte_segunda_genero'
JOIN variables v_ec ON v_ec.tag = 'parte_segunda_estado_civil'
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;

-- 4. Vincular moneda_contrato a toda plantilla que ya tenga alguna
--    variable de tipo currency (las 3 que ya la tenían quedan intactas
--    por el ON CONFLICT DO NOTHING).
INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
SELECT DISTINCT ON (tv.template_id) tv.template_id, v_mc.id, tv.section_id,
  (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_variables WHERE template_id = tv.template_id)
FROM template_variables tv
JOIN variables vcur ON vcur.id = tv.variable_id AND vcur.data_type = 'currency'
JOIN variables v_mc ON v_mc.tag = 'moneda_contrato'
ORDER BY tv.template_id
ON CONFLICT DO NOTHING;