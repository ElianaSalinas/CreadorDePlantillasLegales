-- ==========================================================
-- SA&VE Comercial, S.R.L. — Punta Cana, República Dominicana
-- CATÁLOGO COMPLETO · GENERADO AUTOMÁTICAMENTE
--
-- NO EDITAR A MANO. Este archivo lo produce:
--   npm run catalog:build
-- a partir de scripts/catalog/clauses.ts y templates.ts
--
-- ⚠️  101 cláusulas y 249 plantillas, TODAS en estado DRAFT.
--     Ningún usuario las ve hasta que un abogado dominicano las
--     revise y las publique. Al final hay instrucciones.
-- ==========================================================

-- PARTE 9 de 42: plantillas 49–54. Requiere la parte 0.

-- ── Contrato de Cesión de Derechos ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'legal-general';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-cesion-de-derechos';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-cesion-de-derechos', 'Contrato de Cesión de Derechos', 'Transferencia de derechos a un tercero.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;
  DELETE FROM template_rules    WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, de nacionalidad {{parte_primera_nacionalidad}}, mayor de edad, {{parte_primera_portador}} de {{parte_primera_tipo_documento}} número {{parte_primera_cedula}}, {{parte_primera_domiciliado}} en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;', 1,
    '{"variable":"parte_primera_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_razon_social}}, sociedad organizada y existente de acuerdo con las leyes de la República Dominicana, con RNC número {{parte_primera_rnc}} y domicilio en {{parte_primera_domicilio}}, debidamente representada por su {{parte_primera_representante_cargo}}, {{parte_primera_nombre}}, de nacionalidad {{parte_primera_nacionalidad}}, mayor de edad, {{parte_primera_portador}} de {{parte_primera_tipo_documento}} número {{parte_primera_cedula}}, {{parte_primera_domiciliado}} en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;', 2,
    '{"variable":"parte_primera_tipo_parte","operator":"equals","value":"empresa"}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '',
    'Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, de nacionalidad {{parte_segunda_nacionalidad}}, mayor de edad, {{parte_segunda_portador}} de {{parte_segunda_tipo_documento}} número {{parte_segunda_cedula}}, {{parte_segunda_domiciliado}} en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.', 3,
    '{"variable":"parte_segunda_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '',
    'Y DE LA OTRA PARTE: {{parte_segunda_razon_social}}, sociedad organizada y existente de acuerdo con las leyes de la República Dominicana, con RNC número {{parte_segunda_rnc}} y domicilio en {{parte_segunda_domicilio}}, debidamente representada por su {{parte_segunda_representante_cargo}}, {{parte_segunda_nombre}}, de nacionalidad {{parte_segunda_nacionalidad}}, mayor de edad, {{parte_segunda_portador}} de {{parte_segunda_tipo_documento}} número {{parte_segunda_cedula}}, {{parte_segunda_domiciliado}} en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.', 4,
    '{"variable":"parte_segunda_tipo_parte","operator":"equals","value":"empresa"}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro2_cedula}}, domiciliado(a) en {{parte_primera_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 5, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro3_cedula}}, domiciliado(a) en {{parte_primera_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 6, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro4_cedula}}, domiciliado(a) en {{parte_primera_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 7, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro2_cedula}}, domiciliado(a) en {{parte_segunda_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 8, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro3_cedula}}, domiciliado(a) en {{parte_segunda_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 9, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro4_cedula}}, domiciliado(a) en {{parte_segunda_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 10, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, '', 'SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 11);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 12) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en {{cantidad_ejemplares}} originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 13)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('g-cesion-permitida', 1),
    ('e-precio-servicios', 2),
    ('g-declaraciones-partes', 3),
    ('g-modificaciones', 4),
    ('g-divisibilidad', 5),
    ('g-notificaciones', 6),
    ('g-ley-aplicable', 7),
    ('integridad-contractual', 8)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order) VALUES
    (v_template, 'Ocultar parte_primera_miembro2_nombre si la parte tiene menos de 2 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro2_nombre'), 1),
    (v_template, 'Ocultar parte_primera_miembro2_cedula si la parte tiene menos de 2 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro2_cedula'), 2),
    (v_template, 'Ocultar parte_primera_miembro2_domicilio si la parte tiene menos de 2 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro2_domicilio'), 3),
    (v_template, 'Ocultar parte_primera_miembro3_nombre si la parte tiene menos de 3 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro3_nombre'), 4),
    (v_template, 'Ocultar parte_primera_miembro3_cedula si la parte tiene menos de 3 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro3_cedula'), 5),
    (v_template, 'Ocultar parte_primera_miembro3_domicilio si la parte tiene menos de 3 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro3_domicilio'), 6),
    (v_template, 'Ocultar parte_primera_miembro4_nombre si la parte tiene menos de 4 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro4_nombre'), 7),
    (v_template, 'Ocultar parte_primera_miembro4_cedula si la parte tiene menos de 4 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro4_cedula'), 8),
    (v_template, 'Ocultar parte_primera_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro4_domicilio'), 9),
    (v_template, 'Ocultar parte_segunda_miembro2_nombre si la parte tiene menos de 2 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro2_nombre'), 10),
    (v_template, 'Ocultar parte_segunda_miembro2_cedula si la parte tiene menos de 2 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro2_cedula'), 11),
    (v_template, 'Ocultar parte_segunda_miembro2_domicilio si la parte tiene menos de 2 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro2_domicilio'), 12),
    (v_template, 'Ocultar parte_segunda_miembro3_nombre si la parte tiene menos de 3 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro3_nombre'), 13),
    (v_template, 'Ocultar parte_segunda_miembro3_cedula si la parte tiene menos de 3 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro3_cedula'), 14),
    (v_template, 'Ocultar parte_segunda_miembro3_domicilio si la parte tiene menos de 3 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro3_domicilio'), 15),
    (v_template, 'Ocultar parte_segunda_miembro4_nombre si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_nombre'), 16),
    (v_template, 'Ocultar parte_segunda_miembro4_cedula si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_cedula'), 17),
    (v_template, 'Ocultar parte_segunda_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_domicilio'), 18),
    (v_template, 'Ocultar parte_primera_razon_social si la parte no es una empresa', '{"variable":"parte_primera_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_razon_social'), 19),
    (v_template, 'Ocultar parte_primera_rnc si la parte no es una empresa', '{"variable":"parte_primera_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_rnc'), 20),
    (v_template, 'Ocultar parte_primera_representante_cargo si la parte no es una empresa', '{"variable":"parte_primera_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_representante_cargo'), 21),
    (v_template, 'Ocultar parte_primera_cantidad si la parte es una empresa', '{"variable":"parte_primera_tipo_parte","operator":"equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_cantidad'), 22),
    (v_template, 'Ocultar parte_segunda_razon_social si la parte no es una empresa', '{"variable":"parte_segunda_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_razon_social'), 23),
    (v_template, 'Ocultar parte_segunda_rnc si la parte no es una empresa', '{"variable":"parte_segunda_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_rnc'), 24),
    (v_template, 'Ocultar parte_segunda_representante_cargo si la parte no es una empresa', '{"variable":"parte_segunda_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_representante_cargo'), 25),
    (v_template, 'Ocultar parte_segunda_cantidad si la parte es una empresa', '{"variable":"parte_segunda_tipo_parte","operator":"equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_cantidad'), 26);

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('cantidad_ejemplares', 1),
    ('ciudad_firma', 2),
    ('distrito_judicial', 3),
    ('fecha_firma', 4),
    ('monto_total_letras', 5),
    ('parte_primera_cantidad', 6),
    ('parte_primera_cedula', 7),
    ('parte_primera_domicilio', 8),
    ('parte_primera_genero', 9),
    ('parte_primera_miembro2_cedula', 10),
    ('parte_primera_miembro2_domicilio', 11),
    ('parte_primera_miembro2_nombre', 12),
    ('parte_primera_miembro3_cedula', 13),
    ('parte_primera_miembro3_domicilio', 14),
    ('parte_primera_miembro3_nombre', 15),
    ('parte_primera_miembro4_cedula', 16),
    ('parte_primera_miembro4_domicilio', 17),
    ('parte_primera_miembro4_nombre', 18),
    ('parte_primera_nacionalidad', 19),
    ('parte_primera_nombre', 20),
    ('parte_primera_razon_social', 21),
    ('parte_primera_representante_cargo', 22),
    ('parte_primera_rnc', 23),
    ('parte_primera_tipo_documento', 24),
    ('parte_primera_tipo_parte', 25),
    ('parte_segunda_cantidad', 26),
    ('parte_segunda_cedula', 27),
    ('parte_segunda_domicilio', 28),
    ('parte_segunda_genero', 29),
    ('parte_segunda_miembro2_cedula', 30),
    ('parte_segunda_miembro2_domicilio', 31),
    ('parte_segunda_miembro2_nombre', 32),
    ('parte_segunda_miembro3_cedula', 33),
    ('parte_segunda_miembro3_domicilio', 34),
    ('parte_segunda_miembro3_nombre', 35),
    ('parte_segunda_miembro4_cedula', 36),
    ('parte_segunda_miembro4_domicilio', 37),
    ('parte_segunda_miembro4_nombre', 38),
    ('parte_segunda_nacionalidad', 39),
    ('parte_segunda_nombre', 40),
    ('parte_segunda_razon_social', 41),
    ('parte_segunda_representante_cargo', 42),
    ('parte_segunda_rnc', 43),
    ('parte_segunda_tipo_documento', 44),
    ('parte_segunda_tipo_parte', 45)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Cesión de Crédito ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'legal-general';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-cesion-de-credito';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-cesion-de-credito', 'Contrato de Cesión de Crédito', 'Traspaso de un crédito a un nuevo acreedor.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;
  DELETE FROM template_rules    WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, de nacionalidad {{parte_primera_nacionalidad}}, mayor de edad, {{parte_primera_portador}} de {{parte_primera_tipo_documento}} número {{parte_primera_cedula}}, {{parte_primera_domiciliado}} en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;', 1,
    '{"variable":"parte_primera_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_razon_social}}, sociedad organizada y existente de acuerdo con las leyes de la República Dominicana, con RNC número {{parte_primera_rnc}} y domicilio en {{parte_primera_domicilio}}, debidamente representada por su {{parte_primera_representante_cargo}}, {{parte_primera_nombre}}, de nacionalidad {{parte_primera_nacionalidad}}, mayor de edad, {{parte_primera_portador}} de {{parte_primera_tipo_documento}} número {{parte_primera_cedula}}, {{parte_primera_domiciliado}} en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;', 2,
    '{"variable":"parte_primera_tipo_parte","operator":"equals","value":"empresa"}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '',
    'Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, de nacionalidad {{parte_segunda_nacionalidad}}, mayor de edad, {{parte_segunda_portador}} de {{parte_segunda_tipo_documento}} número {{parte_segunda_cedula}}, {{parte_segunda_domiciliado}} en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.', 3,
    '{"variable":"parte_segunda_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '',
    'Y DE LA OTRA PARTE: {{parte_segunda_razon_social}}, sociedad organizada y existente de acuerdo con las leyes de la República Dominicana, con RNC número {{parte_segunda_rnc}} y domicilio en {{parte_segunda_domicilio}}, debidamente representada por su {{parte_segunda_representante_cargo}}, {{parte_segunda_nombre}}, de nacionalidad {{parte_segunda_nacionalidad}}, mayor de edad, {{parte_segunda_portador}} de {{parte_segunda_tipo_documento}} número {{parte_segunda_cedula}}, {{parte_segunda_domiciliado}} en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.', 4,
    '{"variable":"parte_segunda_tipo_parte","operator":"equals","value":"empresa"}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro2_cedula}}, domiciliado(a) en {{parte_primera_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 5, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro3_cedula}}, domiciliado(a) en {{parte_primera_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 6, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro4_cedula}}, domiciliado(a) en {{parte_primera_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 7, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro2_cedula}}, domiciliado(a) en {{parte_segunda_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 8, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro3_cedula}}, domiciliado(a) en {{parte_segunda_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 9, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro4_cedula}}, domiciliado(a) en {{parte_segunda_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 10, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, '', 'SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 11);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 12) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en {{cantidad_ejemplares}} originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 13)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('g-cesion-permitida', 1),
    ('g-notificaciones', 2),
    ('g-declaraciones-partes', 3),
    ('g-modificaciones', 4),
    ('g-divisibilidad', 5),
    ('g-ley-aplicable', 6),
    ('integridad-contractual', 7)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order) VALUES
    (v_template, 'Ocultar parte_primera_miembro2_nombre si la parte tiene menos de 2 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro2_nombre'), 1),
    (v_template, 'Ocultar parte_primera_miembro2_cedula si la parte tiene menos de 2 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro2_cedula'), 2),
    (v_template, 'Ocultar parte_primera_miembro2_domicilio si la parte tiene menos de 2 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro2_domicilio'), 3),
    (v_template, 'Ocultar parte_primera_miembro3_nombre si la parte tiene menos de 3 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro3_nombre'), 4),
    (v_template, 'Ocultar parte_primera_miembro3_cedula si la parte tiene menos de 3 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro3_cedula'), 5),
    (v_template, 'Ocultar parte_primera_miembro3_domicilio si la parte tiene menos de 3 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro3_domicilio'), 6),
    (v_template, 'Ocultar parte_primera_miembro4_nombre si la parte tiene menos de 4 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro4_nombre'), 7),
    (v_template, 'Ocultar parte_primera_miembro4_cedula si la parte tiene menos de 4 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro4_cedula'), 8),
    (v_template, 'Ocultar parte_primera_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro4_domicilio'), 9),
    (v_template, 'Ocultar parte_segunda_miembro2_nombre si la parte tiene menos de 2 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro2_nombre'), 10),
    (v_template, 'Ocultar parte_segunda_miembro2_cedula si la parte tiene menos de 2 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro2_cedula'), 11),
    (v_template, 'Ocultar parte_segunda_miembro2_domicilio si la parte tiene menos de 2 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro2_domicilio'), 12),
    (v_template, 'Ocultar parte_segunda_miembro3_nombre si la parte tiene menos de 3 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro3_nombre'), 13),
    (v_template, 'Ocultar parte_segunda_miembro3_cedula si la parte tiene menos de 3 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro3_cedula'), 14),
    (v_template, 'Ocultar parte_segunda_miembro3_domicilio si la parte tiene menos de 3 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro3_domicilio'), 15),
    (v_template, 'Ocultar parte_segunda_miembro4_nombre si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_nombre'), 16),
    (v_template, 'Ocultar parte_segunda_miembro4_cedula si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_cedula'), 17),
    (v_template, 'Ocultar parte_segunda_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_domicilio'), 18),
    (v_template, 'Ocultar parte_primera_razon_social si la parte no es una empresa', '{"variable":"parte_primera_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_razon_social'), 19),
    (v_template, 'Ocultar parte_primera_rnc si la parte no es una empresa', '{"variable":"parte_primera_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_rnc'), 20),
    (v_template, 'Ocultar parte_primera_representante_cargo si la parte no es una empresa', '{"variable":"parte_primera_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_representante_cargo'), 21),
    (v_template, 'Ocultar parte_primera_cantidad si la parte es una empresa', '{"variable":"parte_primera_tipo_parte","operator":"equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_cantidad'), 22),
    (v_template, 'Ocultar parte_segunda_razon_social si la parte no es una empresa', '{"variable":"parte_segunda_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_razon_social'), 23),
    (v_template, 'Ocultar parte_segunda_rnc si la parte no es una empresa', '{"variable":"parte_segunda_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_rnc'), 24),
    (v_template, 'Ocultar parte_segunda_representante_cargo si la parte no es una empresa', '{"variable":"parte_segunda_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_representante_cargo'), 25),
    (v_template, 'Ocultar parte_segunda_cantidad si la parte es una empresa', '{"variable":"parte_segunda_tipo_parte","operator":"equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_cantidad'), 26);

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('cantidad_ejemplares', 1),
    ('ciudad_firma', 2),
    ('distrito_judicial', 3),
    ('fecha_firma', 4),
    ('parte_primera_cantidad', 5),
    ('parte_primera_cedula', 6),
    ('parte_primera_domicilio', 7),
    ('parte_primera_genero', 8),
    ('parte_primera_miembro2_cedula', 9),
    ('parte_primera_miembro2_domicilio', 10),
    ('parte_primera_miembro2_nombre', 11),
    ('parte_primera_miembro3_cedula', 12),
    ('parte_primera_miembro3_domicilio', 13),
    ('parte_primera_miembro3_nombre', 14),
    ('parte_primera_miembro4_cedula', 15),
    ('parte_primera_miembro4_domicilio', 16),
    ('parte_primera_miembro4_nombre', 17),
    ('parte_primera_nacionalidad', 18),
    ('parte_primera_nombre', 19),
    ('parte_primera_razon_social', 20),
    ('parte_primera_representante_cargo', 21),
    ('parte_primera_rnc', 22),
    ('parte_primera_tipo_documento', 23),
    ('parte_primera_tipo_parte', 24),
    ('parte_segunda_cantidad', 25),
    ('parte_segunda_cedula', 26),
    ('parte_segunda_domicilio', 27),
    ('parte_segunda_genero', 28),
    ('parte_segunda_miembro2_cedula', 29),
    ('parte_segunda_miembro2_domicilio', 30),
    ('parte_segunda_miembro2_nombre', 31),
    ('parte_segunda_miembro3_cedula', 32),
    ('parte_segunda_miembro3_domicilio', 33),
    ('parte_segunda_miembro3_nombre', 34),
    ('parte_segunda_miembro4_cedula', 35),
    ('parte_segunda_miembro4_domicilio', 36),
    ('parte_segunda_miembro4_nombre', 37),
    ('parte_segunda_nacionalidad', 38),
    ('parte_segunda_nombre', 39),
    ('parte_segunda_razon_social', 40),
    ('parte_segunda_representante_cargo', 41),
    ('parte_segunda_rnc', 42),
    ('parte_segunda_tipo_documento', 43),
    ('parte_segunda_tipo_parte', 44)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Reconocimiento de Deuda ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'legal-general';
  SELECT id INTO v_template FROM templates WHERE slug = 'reconocimiento-de-deuda';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'reconocimiento-de-deuda', 'Reconocimiento de Deuda', 'El deudor reconoce lo que debe y cómo pagará.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;
  DELETE FROM template_rules    WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, de nacionalidad {{parte_primera_nacionalidad}}, mayor de edad, {{parte_primera_portador}} de {{parte_primera_tipo_documento}} número {{parte_primera_cedula}}, {{parte_primera_domiciliado}} en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;', 1,
    '{"variable":"parte_primera_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_razon_social}}, sociedad organizada y existente de acuerdo con las leyes de la República Dominicana, con RNC número {{parte_primera_rnc}} y domicilio en {{parte_primera_domicilio}}, debidamente representada por su {{parte_primera_representante_cargo}}, {{parte_primera_nombre}}, de nacionalidad {{parte_primera_nacionalidad}}, mayor de edad, {{parte_primera_portador}} de {{parte_primera_tipo_documento}} número {{parte_primera_cedula}}, {{parte_primera_domiciliado}} en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;', 2,
    '{"variable":"parte_primera_tipo_parte","operator":"equals","value":"empresa"}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '',
    'Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, de nacionalidad {{parte_segunda_nacionalidad}}, mayor de edad, {{parte_segunda_portador}} de {{parte_segunda_tipo_documento}} número {{parte_segunda_cedula}}, {{parte_segunda_domiciliado}} en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.', 3,
    '{"variable":"parte_segunda_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '',
    'Y DE LA OTRA PARTE: {{parte_segunda_razon_social}}, sociedad organizada y existente de acuerdo con las leyes de la República Dominicana, con RNC número {{parte_segunda_rnc}} y domicilio en {{parte_segunda_domicilio}}, debidamente representada por su {{parte_segunda_representante_cargo}}, {{parte_segunda_nombre}}, de nacionalidad {{parte_segunda_nacionalidad}}, mayor de edad, {{parte_segunda_portador}} de {{parte_segunda_tipo_documento}} número {{parte_segunda_cedula}}, {{parte_segunda_domiciliado}} en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.', 4,
    '{"variable":"parte_segunda_tipo_parte","operator":"equals","value":"empresa"}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro2_cedula}}, domiciliado(a) en {{parte_primera_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 5, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro3_cedula}}, domiciliado(a) en {{parte_primera_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 6, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro4_cedula}}, domiciliado(a) en {{parte_primera_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 7, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro2_cedula}}, domiciliado(a) en {{parte_segunda_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 8, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro3_cedula}}, domiciliado(a) en {{parte_segunda_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 9, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro4_cedula}}, domiciliado(a) en {{parte_segunda_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 10, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, '', 'SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 11);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 12) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en {{cantidad_ejemplares}} originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 13)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('p-capital-prestamo', 1),
    ('p-amortizacion', 2),
    ('g-intereses-moratorios', 3),
    ('g-penalidad', 4),
    ('g-declaraciones-partes', 5),
    ('g-modificaciones', 6),
    ('g-divisibilidad', 7),
    ('g-notificaciones', 8),
    ('g-ley-aplicable', 9),
    ('integridad-contractual', 10)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order) VALUES
    (v_template, 'Ocultar parte_primera_miembro2_nombre si la parte tiene menos de 2 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro2_nombre'), 1),
    (v_template, 'Ocultar parte_primera_miembro2_cedula si la parte tiene menos de 2 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro2_cedula'), 2),
    (v_template, 'Ocultar parte_primera_miembro2_domicilio si la parte tiene menos de 2 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro2_domicilio'), 3),
    (v_template, 'Ocultar parte_primera_miembro3_nombre si la parte tiene menos de 3 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro3_nombre'), 4),
    (v_template, 'Ocultar parte_primera_miembro3_cedula si la parte tiene menos de 3 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro3_cedula'), 5),
    (v_template, 'Ocultar parte_primera_miembro3_domicilio si la parte tiene menos de 3 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro3_domicilio'), 6),
    (v_template, 'Ocultar parte_primera_miembro4_nombre si la parte tiene menos de 4 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro4_nombre'), 7),
    (v_template, 'Ocultar parte_primera_miembro4_cedula si la parte tiene menos de 4 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro4_cedula'), 8),
    (v_template, 'Ocultar parte_primera_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro4_domicilio'), 9),
    (v_template, 'Ocultar parte_segunda_miembro2_nombre si la parte tiene menos de 2 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro2_nombre'), 10),
    (v_template, 'Ocultar parte_segunda_miembro2_cedula si la parte tiene menos de 2 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro2_cedula'), 11),
    (v_template, 'Ocultar parte_segunda_miembro2_domicilio si la parte tiene menos de 2 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro2_domicilio'), 12),
    (v_template, 'Ocultar parte_segunda_miembro3_nombre si la parte tiene menos de 3 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro3_nombre'), 13),
    (v_template, 'Ocultar parte_segunda_miembro3_cedula si la parte tiene menos de 3 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro3_cedula'), 14),
    (v_template, 'Ocultar parte_segunda_miembro3_domicilio si la parte tiene menos de 3 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro3_domicilio'), 15),
    (v_template, 'Ocultar parte_segunda_miembro4_nombre si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_nombre'), 16),
    (v_template, 'Ocultar parte_segunda_miembro4_cedula si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_cedula'), 17),
    (v_template, 'Ocultar parte_segunda_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_domicilio'), 18),
    (v_template, 'Ocultar parte_primera_razon_social si la parte no es una empresa', '{"variable":"parte_primera_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_razon_social'), 19),
    (v_template, 'Ocultar parte_primera_rnc si la parte no es una empresa', '{"variable":"parte_primera_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_rnc'), 20),
    (v_template, 'Ocultar parte_primera_representante_cargo si la parte no es una empresa', '{"variable":"parte_primera_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_representante_cargo'), 21),
    (v_template, 'Ocultar parte_primera_cantidad si la parte es una empresa', '{"variable":"parte_primera_tipo_parte","operator":"equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_cantidad'), 22),
    (v_template, 'Ocultar parte_segunda_razon_social si la parte no es una empresa', '{"variable":"parte_segunda_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_razon_social'), 23),
    (v_template, 'Ocultar parte_segunda_rnc si la parte no es una empresa', '{"variable":"parte_segunda_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_rnc'), 24),
    (v_template, 'Ocultar parte_segunda_representante_cargo si la parte no es una empresa', '{"variable":"parte_segunda_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_representante_cargo'), 25),
    (v_template, 'Ocultar parte_segunda_cantidad si la parte es una empresa', '{"variable":"parte_segunda_tipo_parte","operator":"equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_cantidad'), 26);

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('cantidad_cuotas', 1),
    ('cantidad_ejemplares', 2),
    ('capital_letras', 3),
    ('ciudad_firma', 4),
    ('dia_pago', 5),
    ('distrito_judicial', 6),
    ('fecha_firma', 7),
    ('interes_mora_porcentaje', 8),
    ('monto_cuota_letras', 9),
    ('monto_penalidad_letras', 10),
    ('parte_primera_cantidad', 11),
    ('parte_primera_cedula', 12),
    ('parte_primera_domicilio', 13),
    ('parte_primera_genero', 14),
    ('parte_primera_miembro2_cedula', 15),
    ('parte_primera_miembro2_domicilio', 16),
    ('parte_primera_miembro2_nombre', 17),
    ('parte_primera_miembro3_cedula', 18),
    ('parte_primera_miembro3_domicilio', 19),
    ('parte_primera_miembro3_nombre', 20),
    ('parte_primera_miembro4_cedula', 21),
    ('parte_primera_miembro4_domicilio', 22),
    ('parte_primera_miembro4_nombre', 23),
    ('parte_primera_nacionalidad', 24),
    ('parte_primera_nombre', 25),
    ('parte_primera_razon_social', 26),
    ('parte_primera_representante_cargo', 27),
    ('parte_primera_rnc', 28),
    ('parte_primera_tipo_documento', 29),
    ('parte_primera_tipo_parte', 30),
    ('parte_segunda_cantidad', 31),
    ('parte_segunda_cedula', 32),
    ('parte_segunda_domicilio', 33),
    ('parte_segunda_genero', 34),
    ('parte_segunda_miembro2_cedula', 35),
    ('parte_segunda_miembro2_domicilio', 36),
    ('parte_segunda_miembro2_nombre', 37),
    ('parte_segunda_miembro3_cedula', 38),
    ('parte_segunda_miembro3_domicilio', 39),
    ('parte_segunda_miembro3_nombre', 40),
    ('parte_segunda_miembro4_cedula', 41),
    ('parte_segunda_miembro4_domicilio', 42),
    ('parte_segunda_miembro4_nombre', 43),
    ('parte_segunda_nacionalidad', 44),
    ('parte_segunda_nombre', 45),
    ('parte_segunda_razon_social', 46),
    ('parte_segunda_representante_cargo', 47),
    ('parte_segunda_rnc', 48),
    ('parte_segunda_tipo_documento', 49),
    ('parte_segunda_tipo_parte', 50)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Finiquito ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'legal-general';
  SELECT id INTO v_template FROM templates WHERE slug = 'finiquito';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'finiquito', 'Finiquito', 'Declaración de que no queda nada pendiente entre las partes.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;
  DELETE FROM template_rules    WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, de nacionalidad {{parte_primera_nacionalidad}}, mayor de edad, {{parte_primera_portador}} de {{parte_primera_tipo_documento}} número {{parte_primera_cedula}}, {{parte_primera_domiciliado}} en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;', 1,
    '{"variable":"parte_primera_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_razon_social}}, sociedad organizada y existente de acuerdo con las leyes de la República Dominicana, con RNC número {{parte_primera_rnc}} y domicilio en {{parte_primera_domicilio}}, debidamente representada por su {{parte_primera_representante_cargo}}, {{parte_primera_nombre}}, de nacionalidad {{parte_primera_nacionalidad}}, mayor de edad, {{parte_primera_portador}} de {{parte_primera_tipo_documento}} número {{parte_primera_cedula}}, {{parte_primera_domiciliado}} en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;', 2,
    '{"variable":"parte_primera_tipo_parte","operator":"equals","value":"empresa"}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '',
    'Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, de nacionalidad {{parte_segunda_nacionalidad}}, mayor de edad, {{parte_segunda_portador}} de {{parte_segunda_tipo_documento}} número {{parte_segunda_cedula}}, {{parte_segunda_domiciliado}} en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.', 3,
    '{"variable":"parte_segunda_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '',
    'Y DE LA OTRA PARTE: {{parte_segunda_razon_social}}, sociedad organizada y existente de acuerdo con las leyes de la República Dominicana, con RNC número {{parte_segunda_rnc}} y domicilio en {{parte_segunda_domicilio}}, debidamente representada por su {{parte_segunda_representante_cargo}}, {{parte_segunda_nombre}}, de nacionalidad {{parte_segunda_nacionalidad}}, mayor de edad, {{parte_segunda_portador}} de {{parte_segunda_tipo_documento}} número {{parte_segunda_cedula}}, {{parte_segunda_domiciliado}} en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.', 4,
    '{"variable":"parte_segunda_tipo_parte","operator":"equals","value":"empresa"}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro2_cedula}}, domiciliado(a) en {{parte_primera_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 5, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro3_cedula}}, domiciliado(a) en {{parte_primera_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 6, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro4_cedula}}, domiciliado(a) en {{parte_primera_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 7, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro2_cedula}}, domiciliado(a) en {{parte_segunda_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 8, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro3_cedula}}, domiciliado(a) en {{parte_segunda_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 9, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro4_cedula}}, domiciliado(a) en {{parte_segunda_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 10, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, '', 'SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 11);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 12) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en {{cantidad_ejemplares}} originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 13)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('g-terminacion-mutuo-acuerdo', 1),
    ('g-declaraciones-partes', 2),
    ('g-modificaciones', 3),
    ('g-divisibilidad', 4),
    ('g-notificaciones', 5),
    ('g-ley-aplicable', 6),
    ('integridad-contractual', 7)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order) VALUES
    (v_template, 'Ocultar parte_primera_miembro2_nombre si la parte tiene menos de 2 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro2_nombre'), 1),
    (v_template, 'Ocultar parte_primera_miembro2_cedula si la parte tiene menos de 2 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro2_cedula'), 2),
    (v_template, 'Ocultar parte_primera_miembro2_domicilio si la parte tiene menos de 2 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro2_domicilio'), 3),
    (v_template, 'Ocultar parte_primera_miembro3_nombre si la parte tiene menos de 3 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro3_nombre'), 4),
    (v_template, 'Ocultar parte_primera_miembro3_cedula si la parte tiene menos de 3 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro3_cedula'), 5),
    (v_template, 'Ocultar parte_primera_miembro3_domicilio si la parte tiene menos de 3 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro3_domicilio'), 6),
    (v_template, 'Ocultar parte_primera_miembro4_nombre si la parte tiene menos de 4 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro4_nombre'), 7),
    (v_template, 'Ocultar parte_primera_miembro4_cedula si la parte tiene menos de 4 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro4_cedula'), 8),
    (v_template, 'Ocultar parte_primera_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro4_domicilio'), 9),
    (v_template, 'Ocultar parte_segunda_miembro2_nombre si la parte tiene menos de 2 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro2_nombre'), 10),
    (v_template, 'Ocultar parte_segunda_miembro2_cedula si la parte tiene menos de 2 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro2_cedula'), 11),
    (v_template, 'Ocultar parte_segunda_miembro2_domicilio si la parte tiene menos de 2 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro2_domicilio'), 12),
    (v_template, 'Ocultar parte_segunda_miembro3_nombre si la parte tiene menos de 3 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro3_nombre'), 13),
    (v_template, 'Ocultar parte_segunda_miembro3_cedula si la parte tiene menos de 3 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro3_cedula'), 14),
    (v_template, 'Ocultar parte_segunda_miembro3_domicilio si la parte tiene menos de 3 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro3_domicilio'), 15),
    (v_template, 'Ocultar parte_segunda_miembro4_nombre si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_nombre'), 16),
    (v_template, 'Ocultar parte_segunda_miembro4_cedula si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_cedula'), 17),
    (v_template, 'Ocultar parte_segunda_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_domicilio'), 18),
    (v_template, 'Ocultar parte_primera_razon_social si la parte no es una empresa', '{"variable":"parte_primera_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_razon_social'), 19),
    (v_template, 'Ocultar parte_primera_rnc si la parte no es una empresa', '{"variable":"parte_primera_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_rnc'), 20),
    (v_template, 'Ocultar parte_primera_representante_cargo si la parte no es una empresa', '{"variable":"parte_primera_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_representante_cargo'), 21),
    (v_template, 'Ocultar parte_primera_cantidad si la parte es una empresa', '{"variable":"parte_primera_tipo_parte","operator":"equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_cantidad'), 22),
    (v_template, 'Ocultar parte_segunda_razon_social si la parte no es una empresa', '{"variable":"parte_segunda_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_razon_social'), 23),
    (v_template, 'Ocultar parte_segunda_rnc si la parte no es una empresa', '{"variable":"parte_segunda_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_rnc'), 24),
    (v_template, 'Ocultar parte_segunda_representante_cargo si la parte no es una empresa', '{"variable":"parte_segunda_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_representante_cargo'), 25),
    (v_template, 'Ocultar parte_segunda_cantidad si la parte es una empresa', '{"variable":"parte_segunda_tipo_parte","operator":"equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_cantidad'), 26);

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('cantidad_ejemplares', 1),
    ('ciudad_firma', 2),
    ('distrito_judicial', 3),
    ('fecha_firma', 4),
    ('parte_primera_cantidad', 5),
    ('parte_primera_cedula', 6),
    ('parte_primera_domicilio', 7),
    ('parte_primera_genero', 8),
    ('parte_primera_miembro2_cedula', 9),
    ('parte_primera_miembro2_domicilio', 10),
    ('parte_primera_miembro2_nombre', 11),
    ('parte_primera_miembro3_cedula', 12),
    ('parte_primera_miembro3_domicilio', 13),
    ('parte_primera_miembro3_nombre', 14),
    ('parte_primera_miembro4_cedula', 15),
    ('parte_primera_miembro4_domicilio', 16),
    ('parte_primera_miembro4_nombre', 17),
    ('parte_primera_nacionalidad', 18),
    ('parte_primera_nombre', 19),
    ('parte_primera_razon_social', 20),
    ('parte_primera_representante_cargo', 21),
    ('parte_primera_rnc', 22),
    ('parte_primera_tipo_documento', 23),
    ('parte_primera_tipo_parte', 24),
    ('parte_segunda_cantidad', 25),
    ('parte_segunda_cedula', 26),
    ('parte_segunda_domicilio', 27),
    ('parte_segunda_genero', 28),
    ('parte_segunda_miembro2_cedula', 29),
    ('parte_segunda_miembro2_domicilio', 30),
    ('parte_segunda_miembro2_nombre', 31),
    ('parte_segunda_miembro3_cedula', 32),
    ('parte_segunda_miembro3_domicilio', 33),
    ('parte_segunda_miembro3_nombre', 34),
    ('parte_segunda_miembro4_cedula', 35),
    ('parte_segunda_miembro4_domicilio', 36),
    ('parte_segunda_miembro4_nombre', 37),
    ('parte_segunda_nacionalidad', 38),
    ('parte_segunda_nombre', 39),
    ('parte_segunda_razon_social', 40),
    ('parte_segunda_representante_cargo', 41),
    ('parte_segunda_rnc', 42),
    ('parte_segunda_tipo_documento', 43),
    ('parte_segunda_tipo_parte', 44)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Renuncia a Reclamación ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'legal-general';
  SELECT id INTO v_template FROM templates WHERE slug = 'carta-de-renuncia-a-reclamacion';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-de-renuncia-a-reclamacion', 'Carta de Renuncia a Reclamación', 'Renuncia expresa a ejercer una acción.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;
  DELETE FROM template_rules    WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, de nacionalidad {{parte_primera_nacionalidad}}, mayor de edad, {{parte_primera_portador}} de {{parte_primera_tipo_documento}} número {{parte_primera_cedula}}, {{parte_primera_domiciliado}} en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;', 1,
    '{"variable":"parte_primera_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_razon_social}}, sociedad organizada y existente de acuerdo con las leyes de la República Dominicana, con RNC número {{parte_primera_rnc}} y domicilio en {{parte_primera_domicilio}}, debidamente representada por su {{parte_primera_representante_cargo}}, {{parte_primera_nombre}}, de nacionalidad {{parte_primera_nacionalidad}}, mayor de edad, {{parte_primera_portador}} de {{parte_primera_tipo_documento}} número {{parte_primera_cedula}}, {{parte_primera_domiciliado}} en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;', 2,
    '{"variable":"parte_primera_tipo_parte","operator":"equals","value":"empresa"}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '',
    'Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, de nacionalidad {{parte_segunda_nacionalidad}}, mayor de edad, {{parte_segunda_portador}} de {{parte_segunda_tipo_documento}} número {{parte_segunda_cedula}}, {{parte_segunda_domiciliado}} en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.', 3,
    '{"variable":"parte_segunda_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '',
    'Y DE LA OTRA PARTE: {{parte_segunda_razon_social}}, sociedad organizada y existente de acuerdo con las leyes de la República Dominicana, con RNC número {{parte_segunda_rnc}} y domicilio en {{parte_segunda_domicilio}}, debidamente representada por su {{parte_segunda_representante_cargo}}, {{parte_segunda_nombre}}, de nacionalidad {{parte_segunda_nacionalidad}}, mayor de edad, {{parte_segunda_portador}} de {{parte_segunda_tipo_documento}} número {{parte_segunda_cedula}}, {{parte_segunda_domiciliado}} en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.', 4,
    '{"variable":"parte_segunda_tipo_parte","operator":"equals","value":"empresa"}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro2_cedula}}, domiciliado(a) en {{parte_primera_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 5, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro3_cedula}}, domiciliado(a) en {{parte_primera_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 6, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro4_cedula}}, domiciliado(a) en {{parte_primera_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 7, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro2_cedula}}, domiciliado(a) en {{parte_segunda_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 8, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro3_cedula}}, domiciliado(a) en {{parte_segunda_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 9, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro4_cedula}}, domiciliado(a) en {{parte_segunda_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 10, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, '', 'SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 11);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 12) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en {{cantidad_ejemplares}} originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 13)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('g-declaraciones-partes', 1),
    ('g-terminacion-mutuo-acuerdo', 2),
    ('g-modificaciones', 3),
    ('g-divisibilidad', 4),
    ('g-notificaciones', 5),
    ('g-ley-aplicable', 6),
    ('integridad-contractual', 7)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order) VALUES
    (v_template, 'Ocultar parte_primera_miembro2_nombre si la parte tiene menos de 2 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro2_nombre'), 1),
    (v_template, 'Ocultar parte_primera_miembro2_cedula si la parte tiene menos de 2 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro2_cedula'), 2),
    (v_template, 'Ocultar parte_primera_miembro2_domicilio si la parte tiene menos de 2 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro2_domicilio'), 3),
    (v_template, 'Ocultar parte_primera_miembro3_nombre si la parte tiene menos de 3 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro3_nombre'), 4),
    (v_template, 'Ocultar parte_primera_miembro3_cedula si la parte tiene menos de 3 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro3_cedula'), 5),
    (v_template, 'Ocultar parte_primera_miembro3_domicilio si la parte tiene menos de 3 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro3_domicilio'), 6),
    (v_template, 'Ocultar parte_primera_miembro4_nombre si la parte tiene menos de 4 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro4_nombre'), 7),
    (v_template, 'Ocultar parte_primera_miembro4_cedula si la parte tiene menos de 4 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro4_cedula'), 8),
    (v_template, 'Ocultar parte_primera_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro4_domicilio'), 9),
    (v_template, 'Ocultar parte_segunda_miembro2_nombre si la parte tiene menos de 2 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro2_nombre'), 10),
    (v_template, 'Ocultar parte_segunda_miembro2_cedula si la parte tiene menos de 2 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro2_cedula'), 11),
    (v_template, 'Ocultar parte_segunda_miembro2_domicilio si la parte tiene menos de 2 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro2_domicilio'), 12),
    (v_template, 'Ocultar parte_segunda_miembro3_nombre si la parte tiene menos de 3 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro3_nombre'), 13),
    (v_template, 'Ocultar parte_segunda_miembro3_cedula si la parte tiene menos de 3 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro3_cedula'), 14),
    (v_template, 'Ocultar parte_segunda_miembro3_domicilio si la parte tiene menos de 3 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro3_domicilio'), 15),
    (v_template, 'Ocultar parte_segunda_miembro4_nombre si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_nombre'), 16),
    (v_template, 'Ocultar parte_segunda_miembro4_cedula si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_cedula'), 17),
    (v_template, 'Ocultar parte_segunda_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_domicilio'), 18),
    (v_template, 'Ocultar parte_primera_razon_social si la parte no es una empresa', '{"variable":"parte_primera_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_razon_social'), 19),
    (v_template, 'Ocultar parte_primera_rnc si la parte no es una empresa', '{"variable":"parte_primera_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_rnc'), 20),
    (v_template, 'Ocultar parte_primera_representante_cargo si la parte no es una empresa', '{"variable":"parte_primera_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_representante_cargo'), 21),
    (v_template, 'Ocultar parte_primera_cantidad si la parte es una empresa', '{"variable":"parte_primera_tipo_parte","operator":"equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_cantidad'), 22),
    (v_template, 'Ocultar parte_segunda_razon_social si la parte no es una empresa', '{"variable":"parte_segunda_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_razon_social'), 23),
    (v_template, 'Ocultar parte_segunda_rnc si la parte no es una empresa', '{"variable":"parte_segunda_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_rnc'), 24),
    (v_template, 'Ocultar parte_segunda_representante_cargo si la parte no es una empresa', '{"variable":"parte_segunda_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_representante_cargo'), 25),
    (v_template, 'Ocultar parte_segunda_cantidad si la parte es una empresa', '{"variable":"parte_segunda_tipo_parte","operator":"equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_cantidad'), 26);

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('cantidad_ejemplares', 1),
    ('ciudad_firma', 2),
    ('distrito_judicial', 3),
    ('fecha_firma', 4),
    ('parte_primera_cantidad', 5),
    ('parte_primera_cedula', 6),
    ('parte_primera_domicilio', 7),
    ('parte_primera_genero', 8),
    ('parte_primera_miembro2_cedula', 9),
    ('parte_primera_miembro2_domicilio', 10),
    ('parte_primera_miembro2_nombre', 11),
    ('parte_primera_miembro3_cedula', 12),
    ('parte_primera_miembro3_domicilio', 13),
    ('parte_primera_miembro3_nombre', 14),
    ('parte_primera_miembro4_cedula', 15),
    ('parte_primera_miembro4_domicilio', 16),
    ('parte_primera_miembro4_nombre', 17),
    ('parte_primera_nacionalidad', 18),
    ('parte_primera_nombre', 19),
    ('parte_primera_razon_social', 20),
    ('parte_primera_representante_cargo', 21),
    ('parte_primera_rnc', 22),
    ('parte_primera_tipo_documento', 23),
    ('parte_primera_tipo_parte', 24),
    ('parte_segunda_cantidad', 25),
    ('parte_segunda_cedula', 26),
    ('parte_segunda_domicilio', 27),
    ('parte_segunda_genero', 28),
    ('parte_segunda_miembro2_cedula', 29),
    ('parte_segunda_miembro2_domicilio', 30),
    ('parte_segunda_miembro2_nombre', 31),
    ('parte_segunda_miembro3_cedula', 32),
    ('parte_segunda_miembro3_domicilio', 33),
    ('parte_segunda_miembro3_nombre', 34),
    ('parte_segunda_miembro4_cedula', 35),
    ('parte_segunda_miembro4_domicilio', 36),
    ('parte_segunda_miembro4_nombre', 37),
    ('parte_segunda_nacionalidad', 38),
    ('parte_segunda_nombre', 39),
    ('parte_segunda_razon_social', 40),
    ('parte_segunda_representante_cargo', 41),
    ('parte_segunda_rnc', 42),
    ('parte_segunda_tipo_documento', 43),
    ('parte_segunda_tipo_parte', 44)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Depósito ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'legal-general';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-deposito';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-deposito', 'Contrato de Depósito', 'Custodia de un bien por cuenta de otro.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;
  DELETE FROM template_rules    WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, de nacionalidad {{parte_primera_nacionalidad}}, mayor de edad, {{parte_primera_portador}} de {{parte_primera_tipo_documento}} número {{parte_primera_cedula}}, {{parte_primera_domiciliado}} en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;', 1,
    '{"variable":"parte_primera_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_razon_social}}, sociedad organizada y existente de acuerdo con las leyes de la República Dominicana, con RNC número {{parte_primera_rnc}} y domicilio en {{parte_primera_domicilio}}, debidamente representada por su {{parte_primera_representante_cargo}}, {{parte_primera_nombre}}, de nacionalidad {{parte_primera_nacionalidad}}, mayor de edad, {{parte_primera_portador}} de {{parte_primera_tipo_documento}} número {{parte_primera_cedula}}, {{parte_primera_domiciliado}} en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;', 2,
    '{"variable":"parte_primera_tipo_parte","operator":"equals","value":"empresa"}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '',
    'Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, de nacionalidad {{parte_segunda_nacionalidad}}, mayor de edad, {{parte_segunda_portador}} de {{parte_segunda_tipo_documento}} número {{parte_segunda_cedula}}, {{parte_segunda_domiciliado}} en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.', 3,
    '{"variable":"parte_segunda_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '',
    'Y DE LA OTRA PARTE: {{parte_segunda_razon_social}}, sociedad organizada y existente de acuerdo con las leyes de la República Dominicana, con RNC número {{parte_segunda_rnc}} y domicilio en {{parte_segunda_domicilio}}, debidamente representada por su {{parte_segunda_representante_cargo}}, {{parte_segunda_nombre}}, de nacionalidad {{parte_segunda_nacionalidad}}, mayor de edad, {{parte_segunda_portador}} de {{parte_segunda_tipo_documento}} número {{parte_segunda_cedula}}, {{parte_segunda_domiciliado}} en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.', 4,
    '{"variable":"parte_segunda_tipo_parte","operator":"equals","value":"empresa"}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro2_cedula}}, domiciliado(a) en {{parte_primera_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 5, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro3_cedula}}, domiciliado(a) en {{parte_primera_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 6, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro4_cedula}}, domiciliado(a) en {{parte_primera_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 7, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro2_cedula}}, domiciliado(a) en {{parte_segunda_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 8, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro3_cedula}}, domiciliado(a) en {{parte_segunda_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 9, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro4_cedula}}, domiciliado(a) en {{parte_segunda_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 10, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, '', 'SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 11);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 12) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en {{cantidad_ejemplares}} originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 13)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('e-deposito-general', 1),
    ('c-entrega-bien', 2),
    ('g-obligaciones-partes', 3),
    ('g-declaraciones-partes', 4),
    ('g-modificaciones', 5),
    ('g-divisibilidad', 6),
    ('g-notificaciones', 7),
    ('g-ley-aplicable', 8),
    ('integridad-contractual', 9)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order) VALUES
    (v_template, 'Ocultar parte_primera_miembro2_nombre si la parte tiene menos de 2 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro2_nombre'), 1),
    (v_template, 'Ocultar parte_primera_miembro2_cedula si la parte tiene menos de 2 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro2_cedula'), 2),
    (v_template, 'Ocultar parte_primera_miembro2_domicilio si la parte tiene menos de 2 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro2_domicilio'), 3),
    (v_template, 'Ocultar parte_primera_miembro3_nombre si la parte tiene menos de 3 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro3_nombre'), 4),
    (v_template, 'Ocultar parte_primera_miembro3_cedula si la parte tiene menos de 3 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro3_cedula'), 5),
    (v_template, 'Ocultar parte_primera_miembro3_domicilio si la parte tiene menos de 3 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro3_domicilio'), 6),
    (v_template, 'Ocultar parte_primera_miembro4_nombre si la parte tiene menos de 4 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro4_nombre'), 7),
    (v_template, 'Ocultar parte_primera_miembro4_cedula si la parte tiene menos de 4 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro4_cedula'), 8),
    (v_template, 'Ocultar parte_primera_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_primera_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_miembro4_domicilio'), 9),
    (v_template, 'Ocultar parte_segunda_miembro2_nombre si la parte tiene menos de 2 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro2_nombre'), 10),
    (v_template, 'Ocultar parte_segunda_miembro2_cedula si la parte tiene menos de 2 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro2_cedula'), 11),
    (v_template, 'Ocultar parte_segunda_miembro2_domicilio si la parte tiene menos de 2 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":2}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro2_domicilio'), 12),
    (v_template, 'Ocultar parte_segunda_miembro3_nombre si la parte tiene menos de 3 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro3_nombre'), 13),
    (v_template, 'Ocultar parte_segunda_miembro3_cedula si la parte tiene menos de 3 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro3_cedula'), 14),
    (v_template, 'Ocultar parte_segunda_miembro3_domicilio si la parte tiene menos de 3 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":3}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro3_domicilio'), 15),
    (v_template, 'Ocultar parte_segunda_miembro4_nombre si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_nombre'), 16),
    (v_template, 'Ocultar parte_segunda_miembro4_cedula si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_cedula'), 17),
    (v_template, 'Ocultar parte_segunda_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_domicilio'), 18),
    (v_template, 'Ocultar parte_primera_razon_social si la parte no es una empresa', '{"variable":"parte_primera_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_razon_social'), 19),
    (v_template, 'Ocultar parte_primera_rnc si la parte no es una empresa', '{"variable":"parte_primera_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_rnc'), 20),
    (v_template, 'Ocultar parte_primera_representante_cargo si la parte no es una empresa', '{"variable":"parte_primera_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_representante_cargo'), 21),
    (v_template, 'Ocultar parte_primera_cantidad si la parte es una empresa', '{"variable":"parte_primera_tipo_parte","operator":"equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_primera_cantidad'), 22),
    (v_template, 'Ocultar parte_segunda_razon_social si la parte no es una empresa', '{"variable":"parte_segunda_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_razon_social'), 23),
    (v_template, 'Ocultar parte_segunda_rnc si la parte no es una empresa', '{"variable":"parte_segunda_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_rnc'), 24),
    (v_template, 'Ocultar parte_segunda_representante_cargo si la parte no es una empresa', '{"variable":"parte_segunda_tipo_parte","operator":"not_equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_representante_cargo'), 25),
    (v_template, 'Ocultar parte_segunda_cantidad si la parte es una empresa', '{"variable":"parte_segunda_tipo_parte","operator":"equals","value":"empresa"}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_cantidad'), 26);

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('cantidad_ejemplares', 1),
    ('ciudad_firma', 2),
    ('deposito_letras', 3),
    ('distrito_judicial', 4),
    ('fecha_entrega_larga', 5),
    ('fecha_firma', 6),
    ('lugar_entrega', 7),
    ('parte_primera_cantidad', 8),
    ('parte_primera_cedula', 9),
    ('parte_primera_domicilio', 10),
    ('parte_primera_genero', 11),
    ('parte_primera_miembro2_cedula', 12),
    ('parte_primera_miembro2_domicilio', 13),
    ('parte_primera_miembro2_nombre', 14),
    ('parte_primera_miembro3_cedula', 15),
    ('parte_primera_miembro3_domicilio', 16),
    ('parte_primera_miembro3_nombre', 17),
    ('parte_primera_miembro4_cedula', 18),
    ('parte_primera_miembro4_domicilio', 19),
    ('parte_primera_miembro4_nombre', 20),
    ('parte_primera_nacionalidad', 21),
    ('parte_primera_nombre', 22),
    ('parte_primera_razon_social', 23),
    ('parte_primera_representante_cargo', 24),
    ('parte_primera_rnc', 25),
    ('parte_primera_tipo_documento', 26),
    ('parte_primera_tipo_parte', 27),
    ('parte_segunda_cantidad', 28),
    ('parte_segunda_cedula', 29),
    ('parte_segunda_domicilio', 30),
    ('parte_segunda_genero', 31),
    ('parte_segunda_miembro2_cedula', 32),
    ('parte_segunda_miembro2_domicilio', 33),
    ('parte_segunda_miembro2_nombre', 34),
    ('parte_segunda_miembro3_cedula', 35),
    ('parte_segunda_miembro3_domicilio', 36),
    ('parte_segunda_miembro3_nombre', 37),
    ('parte_segunda_miembro4_cedula', 38),
    ('parte_segunda_miembro4_domicilio', 39),
    ('parte_segunda_miembro4_nombre', 40),
    ('parte_segunda_nacionalidad', 41),
    ('parte_segunda_nombre', 42),
    ('parte_segunda_razon_social', 43),
    ('parte_segunda_representante_cargo', 44),
    ('parte_segunda_rnc', 45),
    ('parte_segunda_tipo_documento', 46),
    ('parte_segunda_tipo_parte', 47)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

