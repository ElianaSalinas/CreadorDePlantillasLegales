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

-- PARTE 12 de 32: plantillas 89–96. Requiere la parte 0.

-- ── Política de Cumplimiento Anticorrupción ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'empresarial';
  SELECT id INTO v_template FROM templates WHERE slug = 'politica-de-cumplimiento-anticorrupcion';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'politica-de-cumplimiento-anticorrupcion', 'Política de Cumplimiento Anticorrupción', 'Normas internas de integridad y prevención.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;
  DELETE FROM template_rules    WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, de nacionalidad {{parte_primera_nacionalidad}}, mayor de edad, {{parte_primera_portador}} de {{parte_primera_tipo_documento}} número {{parte_primera_cedula}}, {{parte_primera_domiciliado}} en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, de nacionalidad {{parte_segunda_nacionalidad}}, mayor de edad, {{parte_segunda_portador}} de {{parte_segunda_tipo_documento}} número {{parte_segunda_cedula}}, {{parte_segunda_domiciliado}} en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro2_cedula}}, domiciliado(a) en {{parte_primera_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 2, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro3_cedula}}, domiciliado(a) en {{parte_primera_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 3, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro4_cedula}}, domiciliado(a) en {{parte_primera_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 4, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro2_cedula}}, domiciliado(a) en {{parte_segunda_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 5, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro3_cedula}}, domiciliado(a) en {{parte_segunda_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 6, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro4_cedula}}, domiciliado(a) en {{parte_segunda_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 7, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, '', 'SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 8);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 9) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en {{cantidad_ejemplares}} originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 10)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('b-anticorrupcion', 1),
    ('l-confidencialidad', 2),
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
    (v_template, 'Ocultar parte_segunda_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_domicilio'), 18);

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
    ('parte_primera_tipo_documento', 20),
    ('parte_segunda_cantidad', 21),
    ('parte_segunda_cedula', 22),
    ('parte_segunda_domicilio', 23),
    ('parte_segunda_genero', 24),
    ('parte_segunda_miembro2_cedula', 25),
    ('parte_segunda_miembro2_domicilio', 26),
    ('parte_segunda_miembro2_nombre', 27),
    ('parte_segunda_miembro3_cedula', 28),
    ('parte_segunda_miembro3_domicilio', 29),
    ('parte_segunda_miembro3_nombre', 30),
    ('parte_segunda_miembro4_cedula', 31),
    ('parte_segunda_miembro4_domicilio', 32),
    ('parte_segunda_miembro4_nombre', 33),
    ('parte_segunda_nacionalidad', 34),
    ('parte_segunda_nombre', 35),
    ('parte_segunda_tipo_documento', 36)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Trabajo por Tiempo Indefinido ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'laboral';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-trabajo-por-tiempo-indefinido';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-trabajo-por-tiempo-indefinido', 'Contrato de Trabajo por Tiempo Indefinido', 'Relación laboral sin plazo determinado.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;
  DELETE FROM template_rules    WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, de nacionalidad {{parte_primera_nacionalidad}}, mayor de edad, {{parte_primera_portador}} de {{parte_primera_tipo_documento}} número {{parte_primera_cedula}}, {{parte_primera_domiciliado}} en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, de nacionalidad {{parte_segunda_nacionalidad}}, mayor de edad, {{parte_segunda_portador}} de {{parte_segunda_tipo_documento}} número {{parte_segunda_cedula}}, {{parte_segunda_domiciliado}} en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro2_cedula}}, domiciliado(a) en {{parte_primera_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 2, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro3_cedula}}, domiciliado(a) en {{parte_primera_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 3, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro4_cedula}}, domiciliado(a) en {{parte_primera_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 4, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro2_cedula}}, domiciliado(a) en {{parte_segunda_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 5, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro3_cedula}}, domiciliado(a) en {{parte_segunda_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 6, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro4_cedula}}, domiciliado(a) en {{parte_segunda_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 7, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, '', 'SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 8);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 9) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en {{cantidad_ejemplares}} originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 10)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('l-salario', 1),
    ('l-jornada', 2),
    ('l-vacaciones', 3),
    ('l-confidencialidad', 4),
    ('l-terminacion-laboral', 5),
    ('l-periodo-prueba', 6),
    ('l-equipos-trabajo', 7),
    ('l-propiedad-intelectual', 8),
    ('g-declaraciones-partes', 9),
    ('g-modificaciones', 10),
    ('g-divisibilidad', 11),
    ('g-notificaciones', 12),
    ('g-ley-aplicable', 13),
    ('integridad-contractual', 14)
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
    (v_template, 'Ocultar parte_segunda_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_domicilio'), 18);

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('cantidad_ejemplares', 1),
    ('ciudad_firma', 2),
    ('distrito_judicial', 3),
    ('fecha_firma', 4),
    ('horario_trabajo', 5),
    ('horas_semanales', 6),
    ('parte_primera_cantidad', 7),
    ('parte_primera_cedula', 8),
    ('parte_primera_domicilio', 9),
    ('parte_primera_genero', 10),
    ('parte_primera_miembro2_cedula', 11),
    ('parte_primera_miembro2_domicilio', 12),
    ('parte_primera_miembro2_nombre', 13),
    ('parte_primera_miembro3_cedula', 14),
    ('parte_primera_miembro3_domicilio', 15),
    ('parte_primera_miembro3_nombre', 16),
    ('parte_primera_miembro4_cedula', 17),
    ('parte_primera_miembro4_domicilio', 18),
    ('parte_primera_miembro4_nombre', 19),
    ('parte_primera_nacionalidad', 20),
    ('parte_primera_nombre', 21),
    ('parte_primera_tipo_documento', 22),
    ('parte_segunda_cantidad', 23),
    ('parte_segunda_cedula', 24),
    ('parte_segunda_domicilio', 25),
    ('parte_segunda_genero', 26),
    ('parte_segunda_miembro2_cedula', 27),
    ('parte_segunda_miembro2_domicilio', 28),
    ('parte_segunda_miembro2_nombre', 29),
    ('parte_segunda_miembro3_cedula', 30),
    ('parte_segunda_miembro3_domicilio', 31),
    ('parte_segunda_miembro3_nombre', 32),
    ('parte_segunda_miembro4_cedula', 33),
    ('parte_segunda_miembro4_domicilio', 34),
    ('parte_segunda_miembro4_nombre', 35),
    ('parte_segunda_nacionalidad', 36),
    ('parte_segunda_nombre', 37),
    ('parte_segunda_tipo_documento', 38),
    ('salario_letras', 39)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Trabajo por Tiempo Determinado ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'laboral';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-trabajo-por-tiempo-determinado';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-trabajo-por-tiempo-determinado', 'Contrato de Trabajo por Tiempo Determinado', 'Relación laboral con fecha de término.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;
  DELETE FROM template_rules    WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, de nacionalidad {{parte_primera_nacionalidad}}, mayor de edad, {{parte_primera_portador}} de {{parte_primera_tipo_documento}} número {{parte_primera_cedula}}, {{parte_primera_domiciliado}} en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, de nacionalidad {{parte_segunda_nacionalidad}}, mayor de edad, {{parte_segunda_portador}} de {{parte_segunda_tipo_documento}} número {{parte_segunda_cedula}}, {{parte_segunda_domiciliado}} en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro2_cedula}}, domiciliado(a) en {{parte_primera_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 2, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro3_cedula}}, domiciliado(a) en {{parte_primera_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 3, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro4_cedula}}, domiciliado(a) en {{parte_primera_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 4, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro2_cedula}}, domiciliado(a) en {{parte_segunda_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 5, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro3_cedula}}, domiciliado(a) en {{parte_segunda_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 6, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro4_cedula}}, domiciliado(a) en {{parte_segunda_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 7, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, '', 'SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 8);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 9) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en {{cantidad_ejemplares}} originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 10)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('l-salario', 1),
    ('l-jornada', 2),
    ('l-vacaciones', 3),
    ('l-confidencialidad', 4),
    ('l-terminacion-laboral', 5),
    ('l-periodo-prueba', 6),
    ('vigencia-arrendamiento', 7),
    ('g-declaraciones-partes', 8),
    ('g-modificaciones', 9),
    ('g-divisibilidad', 10),
    ('g-notificaciones', 11),
    ('g-ley-aplicable', 12),
    ('integridad-contractual', 13)
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
    (v_template, 'Ocultar parte_segunda_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_domicilio'), 18);

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('cantidad_ejemplares', 1),
    ('ciudad_firma', 2),
    ('distrito_judicial', 3),
    ('fecha_firma', 4),
    ('horario_trabajo', 5),
    ('horas_semanales', 6),
    ('parte_primera_cantidad', 7),
    ('parte_primera_cedula', 8),
    ('parte_primera_domicilio', 9),
    ('parte_primera_genero', 10),
    ('parte_primera_miembro2_cedula', 11),
    ('parte_primera_miembro2_domicilio', 12),
    ('parte_primera_miembro2_nombre', 13),
    ('parte_primera_miembro3_cedula', 14),
    ('parte_primera_miembro3_domicilio', 15),
    ('parte_primera_miembro3_nombre', 16),
    ('parte_primera_miembro4_cedula', 17),
    ('parte_primera_miembro4_domicilio', 18),
    ('parte_primera_miembro4_nombre', 19),
    ('parte_primera_nacionalidad', 20),
    ('parte_primera_nombre', 21),
    ('parte_primera_tipo_documento', 22),
    ('parte_segunda_cantidad', 23),
    ('parte_segunda_cedula', 24),
    ('parte_segunda_domicilio', 25),
    ('parte_segunda_genero', 26),
    ('parte_segunda_miembro2_cedula', 27),
    ('parte_segunda_miembro2_domicilio', 28),
    ('parte_segunda_miembro2_nombre', 29),
    ('parte_segunda_miembro3_cedula', 30),
    ('parte_segunda_miembro3_domicilio', 31),
    ('parte_segunda_miembro3_nombre', 32),
    ('parte_segunda_miembro4_cedula', 33),
    ('parte_segunda_miembro4_domicilio', 34),
    ('parte_segunda_miembro4_nombre', 35),
    ('parte_segunda_nacionalidad', 36),
    ('parte_segunda_nombre', 37),
    ('parte_segunda_tipo_documento', 38),
    ('salario_letras', 39)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Trabajo para Obra o Servicio ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'laboral';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-trabajo-para-obra-o-servicio';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-trabajo-para-obra-o-servicio', 'Contrato de Trabajo para Obra o Servicio', 'Contratación ligada a una obra concreta.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;
  DELETE FROM template_rules    WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, de nacionalidad {{parte_primera_nacionalidad}}, mayor de edad, {{parte_primera_portador}} de {{parte_primera_tipo_documento}} número {{parte_primera_cedula}}, {{parte_primera_domiciliado}} en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, de nacionalidad {{parte_segunda_nacionalidad}}, mayor de edad, {{parte_segunda_portador}} de {{parte_segunda_tipo_documento}} número {{parte_segunda_cedula}}, {{parte_segunda_domiciliado}} en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro2_cedula}}, domiciliado(a) en {{parte_primera_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 2, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro3_cedula}}, domiciliado(a) en {{parte_primera_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 3, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro4_cedula}}, domiciliado(a) en {{parte_primera_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 4, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro2_cedula}}, domiciliado(a) en {{parte_segunda_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 5, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro3_cedula}}, domiciliado(a) en {{parte_segunda_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 6, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro4_cedula}}, domiciliado(a) en {{parte_segunda_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 7, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, '', 'SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 8);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 9) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en {{cantidad_ejemplares}} originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 10)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('l-salario', 1),
    ('l-jornada', 2),
    ('l-vacaciones', 3),
    ('l-confidencialidad', 4),
    ('l-terminacion-laboral', 5),
    ('l-periodo-prueba', 6),
    ('o-plazo-obra', 7),
    ('g-declaraciones-partes', 8),
    ('g-modificaciones', 9),
    ('g-divisibilidad', 10),
    ('g-notificaciones', 11),
    ('g-ley-aplicable', 12),
    ('integridad-contractual', 13)
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
    (v_template, 'Ocultar parte_segunda_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_domicilio'), 18);

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('cantidad_ejemplares', 1),
    ('ciudad_firma', 2),
    ('distrito_judicial', 3),
    ('fecha_firma', 4),
    ('horario_trabajo', 5),
    ('horas_semanales', 6),
    ('parte_primera_cantidad', 7),
    ('parte_primera_cedula', 8),
    ('parte_primera_domicilio', 9),
    ('parte_primera_genero', 10),
    ('parte_primera_miembro2_cedula', 11),
    ('parte_primera_miembro2_domicilio', 12),
    ('parte_primera_miembro2_nombre', 13),
    ('parte_primera_miembro3_cedula', 14),
    ('parte_primera_miembro3_domicilio', 15),
    ('parte_primera_miembro3_nombre', 16),
    ('parte_primera_miembro4_cedula', 17),
    ('parte_primera_miembro4_domicilio', 18),
    ('parte_primera_miembro4_nombre', 19),
    ('parte_primera_nacionalidad', 20),
    ('parte_primera_nombre', 21),
    ('parte_primera_tipo_documento', 22),
    ('parte_segunda_cantidad', 23),
    ('parte_segunda_cedula', 24),
    ('parte_segunda_domicilio', 25),
    ('parte_segunda_genero', 26),
    ('parte_segunda_miembro2_cedula', 27),
    ('parte_segunda_miembro2_domicilio', 28),
    ('parte_segunda_miembro2_nombre', 29),
    ('parte_segunda_miembro3_cedula', 30),
    ('parte_segunda_miembro3_domicilio', 31),
    ('parte_segunda_miembro3_nombre', 32),
    ('parte_segunda_miembro4_cedula', 33),
    ('parte_segunda_miembro4_domicilio', 34),
    ('parte_segunda_miembro4_nombre', 35),
    ('parte_segunda_nacionalidad', 36),
    ('parte_segunda_nombre', 37),
    ('parte_segunda_tipo_documento', 38),
    ('plazo_obra_dias', 39),
    ('salario_letras', 40)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Trabajo a Tiempo Parcial ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'laboral';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-trabajo-a-tiempo-parcial';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-trabajo-a-tiempo-parcial', 'Contrato de Trabajo a Tiempo Parcial', 'Jornada reducida respecto de la ordinaria.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;
  DELETE FROM template_rules    WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, de nacionalidad {{parte_primera_nacionalidad}}, mayor de edad, {{parte_primera_portador}} de {{parte_primera_tipo_documento}} número {{parte_primera_cedula}}, {{parte_primera_domiciliado}} en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, de nacionalidad {{parte_segunda_nacionalidad}}, mayor de edad, {{parte_segunda_portador}} de {{parte_segunda_tipo_documento}} número {{parte_segunda_cedula}}, {{parte_segunda_domiciliado}} en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro2_cedula}}, domiciliado(a) en {{parte_primera_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 2, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro3_cedula}}, domiciliado(a) en {{parte_primera_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 3, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro4_cedula}}, domiciliado(a) en {{parte_primera_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 4, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro2_cedula}}, domiciliado(a) en {{parte_segunda_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 5, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro3_cedula}}, domiciliado(a) en {{parte_segunda_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 6, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro4_cedula}}, domiciliado(a) en {{parte_segunda_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 7, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, '', 'SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 8);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 9) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en {{cantidad_ejemplares}} originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 10)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('l-salario', 1),
    ('l-jornada', 2),
    ('l-vacaciones', 3),
    ('l-confidencialidad', 4),
    ('l-terminacion-laboral', 5),
    ('l-periodo-prueba', 6),
    ('g-declaraciones-partes', 7),
    ('g-modificaciones', 8),
    ('g-divisibilidad', 9),
    ('g-notificaciones', 10),
    ('g-ley-aplicable', 11),
    ('integridad-contractual', 12)
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
    (v_template, 'Ocultar parte_segunda_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_domicilio'), 18);

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('cantidad_ejemplares', 1),
    ('ciudad_firma', 2),
    ('distrito_judicial', 3),
    ('fecha_firma', 4),
    ('horario_trabajo', 5),
    ('horas_semanales', 6),
    ('parte_primera_cantidad', 7),
    ('parte_primera_cedula', 8),
    ('parte_primera_domicilio', 9),
    ('parte_primera_genero', 10),
    ('parte_primera_miembro2_cedula', 11),
    ('parte_primera_miembro2_domicilio', 12),
    ('parte_primera_miembro2_nombre', 13),
    ('parte_primera_miembro3_cedula', 14),
    ('parte_primera_miembro3_domicilio', 15),
    ('parte_primera_miembro3_nombre', 16),
    ('parte_primera_miembro4_cedula', 17),
    ('parte_primera_miembro4_domicilio', 18),
    ('parte_primera_miembro4_nombre', 19),
    ('parte_primera_nacionalidad', 20),
    ('parte_primera_nombre', 21),
    ('parte_primera_tipo_documento', 22),
    ('parte_segunda_cantidad', 23),
    ('parte_segunda_cedula', 24),
    ('parte_segunda_domicilio', 25),
    ('parte_segunda_genero', 26),
    ('parte_segunda_miembro2_cedula', 27),
    ('parte_segunda_miembro2_domicilio', 28),
    ('parte_segunda_miembro2_nombre', 29),
    ('parte_segunda_miembro3_cedula', 30),
    ('parte_segunda_miembro3_domicilio', 31),
    ('parte_segunda_miembro3_nombre', 32),
    ('parte_segunda_miembro4_cedula', 33),
    ('parte_segunda_miembro4_domicilio', 34),
    ('parte_segunda_miembro4_nombre', 35),
    ('parte_segunda_nacionalidad', 36),
    ('parte_segunda_nombre', 37),
    ('parte_segunda_tipo_documento', 38),
    ('salario_letras', 39)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Trabajo Remoto ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'laboral';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-trabajo-remoto';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-trabajo-remoto', 'Contrato de Trabajo Remoto', 'Prestación del servicio desde el domicilio.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;
  DELETE FROM template_rules    WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, de nacionalidad {{parte_primera_nacionalidad}}, mayor de edad, {{parte_primera_portador}} de {{parte_primera_tipo_documento}} número {{parte_primera_cedula}}, {{parte_primera_domiciliado}} en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, de nacionalidad {{parte_segunda_nacionalidad}}, mayor de edad, {{parte_segunda_portador}} de {{parte_segunda_tipo_documento}} número {{parte_segunda_cedula}}, {{parte_segunda_domiciliado}} en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro2_cedula}}, domiciliado(a) en {{parte_primera_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 2, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro3_cedula}}, domiciliado(a) en {{parte_primera_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 3, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro4_cedula}}, domiciliado(a) en {{parte_primera_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 4, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro2_cedula}}, domiciliado(a) en {{parte_segunda_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 5, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro3_cedula}}, domiciliado(a) en {{parte_segunda_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 6, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro4_cedula}}, domiciliado(a) en {{parte_segunda_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 7, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, '', 'SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 8);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 9) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en {{cantidad_ejemplares}} originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 10)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('l-salario', 1),
    ('l-jornada', 2),
    ('l-vacaciones', 3),
    ('l-confidencialidad', 4),
    ('l-terminacion-laboral', 5),
    ('l-periodo-prueba', 6),
    ('l-trabajo-remoto', 7),
    ('l-equipos-trabajo', 8),
    ('g-declaraciones-partes', 9),
    ('g-modificaciones', 10),
    ('g-divisibilidad', 11),
    ('g-notificaciones', 12),
    ('g-ley-aplicable', 13),
    ('integridad-contractual', 14)
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
    (v_template, 'Ocultar parte_segunda_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_domicilio'), 18);

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('cantidad_ejemplares', 1),
    ('ciudad_firma', 2),
    ('distrito_judicial', 3),
    ('fecha_firma', 4),
    ('horario_trabajo', 5),
    ('horas_semanales', 6),
    ('parte_primera_cantidad', 7),
    ('parte_primera_cedula', 8),
    ('parte_primera_domicilio', 9),
    ('parte_primera_genero', 10),
    ('parte_primera_miembro2_cedula', 11),
    ('parte_primera_miembro2_domicilio', 12),
    ('parte_primera_miembro2_nombre', 13),
    ('parte_primera_miembro3_cedula', 14),
    ('parte_primera_miembro3_domicilio', 15),
    ('parte_primera_miembro3_nombre', 16),
    ('parte_primera_miembro4_cedula', 17),
    ('parte_primera_miembro4_domicilio', 18),
    ('parte_primera_miembro4_nombre', 19),
    ('parte_primera_nacionalidad', 20),
    ('parte_primera_nombre', 21),
    ('parte_primera_tipo_documento', 22),
    ('parte_segunda_cantidad', 23),
    ('parte_segunda_cedula', 24),
    ('parte_segunda_domicilio', 25),
    ('parte_segunda_genero', 26),
    ('parte_segunda_miembro2_cedula', 27),
    ('parte_segunda_miembro2_domicilio', 28),
    ('parte_segunda_miembro2_nombre', 29),
    ('parte_segunda_miembro3_cedula', 30),
    ('parte_segunda_miembro3_domicilio', 31),
    ('parte_segunda_miembro3_nombre', 32),
    ('parte_segunda_miembro4_cedula', 33),
    ('parte_segunda_miembro4_domicilio', 34),
    ('parte_segunda_miembro4_nombre', 35),
    ('parte_segunda_nacionalidad', 36),
    ('parte_segunda_nombre', 37),
    ('parte_segunda_tipo_documento', 38),
    ('salario_letras', 39)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Trabajo Híbrido ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'laboral';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-trabajo-hibrido';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-trabajo-hibrido', 'Contrato de Trabajo Híbrido', 'Combinación de presencialidad y trabajo remoto.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;
  DELETE FROM template_rules    WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, de nacionalidad {{parte_primera_nacionalidad}}, mayor de edad, {{parte_primera_portador}} de {{parte_primera_tipo_documento}} número {{parte_primera_cedula}}, {{parte_primera_domiciliado}} en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, de nacionalidad {{parte_segunda_nacionalidad}}, mayor de edad, {{parte_segunda_portador}} de {{parte_segunda_tipo_documento}} número {{parte_segunda_cedula}}, {{parte_segunda_domiciliado}} en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro2_cedula}}, domiciliado(a) en {{parte_primera_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 2, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro3_cedula}}, domiciliado(a) en {{parte_primera_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 3, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro4_cedula}}, domiciliado(a) en {{parte_primera_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 4, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro2_cedula}}, domiciliado(a) en {{parte_segunda_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 5, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro3_cedula}}, domiciliado(a) en {{parte_segunda_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 6, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro4_cedula}}, domiciliado(a) en {{parte_segunda_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 7, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, '', 'SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 8);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 9) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en {{cantidad_ejemplares}} originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 10)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('l-salario', 1),
    ('l-jornada', 2),
    ('l-vacaciones', 3),
    ('l-confidencialidad', 4),
    ('l-terminacion-laboral', 5),
    ('l-periodo-prueba', 6),
    ('l-trabajo-hibrido', 7),
    ('l-equipos-trabajo', 8),
    ('g-declaraciones-partes', 9),
    ('g-modificaciones', 10),
    ('g-divisibilidad', 11),
    ('g-notificaciones', 12),
    ('g-ley-aplicable', 13),
    ('integridad-contractual', 14)
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
    (v_template, 'Ocultar parte_segunda_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_domicilio'), 18);

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('cantidad_ejemplares', 1),
    ('ciudad_firma', 2),
    ('dias_presenciales', 3),
    ('distrito_judicial', 4),
    ('fecha_firma', 5),
    ('horario_trabajo', 6),
    ('horas_semanales', 7),
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
    ('parte_primera_tipo_documento', 23),
    ('parte_segunda_cantidad', 24),
    ('parte_segunda_cedula', 25),
    ('parte_segunda_domicilio', 26),
    ('parte_segunda_genero', 27),
    ('parte_segunda_miembro2_cedula', 28),
    ('parte_segunda_miembro2_domicilio', 29),
    ('parte_segunda_miembro2_nombre', 30),
    ('parte_segunda_miembro3_cedula', 31),
    ('parte_segunda_miembro3_domicilio', 32),
    ('parte_segunda_miembro3_nombre', 33),
    ('parte_segunda_miembro4_cedula', 34),
    ('parte_segunda_miembro4_domicilio', 35),
    ('parte_segunda_miembro4_nombre', 36),
    ('parte_segunda_nacionalidad', 37),
    ('parte_segunda_nombre', 38),
    ('parte_segunda_tipo_documento', 39),
    ('salario_letras', 40)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Trabajo con Comisiones ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'laboral';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-trabajo-con-comisiones';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-trabajo-con-comisiones', 'Contrato de Trabajo con Comisiones', 'Salario fijo más retribución variable por ventas.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;
  DELETE FROM template_rules    WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, de nacionalidad {{parte_primera_nacionalidad}}, mayor de edad, {{parte_primera_portador}} de {{parte_primera_tipo_documento}} número {{parte_primera_cedula}}, {{parte_primera_domiciliado}} en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, de nacionalidad {{parte_segunda_nacionalidad}}, mayor de edad, {{parte_segunda_portador}} de {{parte_segunda_tipo_documento}} número {{parte_segunda_cedula}}, {{parte_segunda_domiciliado}} en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro2_cedula}}, domiciliado(a) en {{parte_primera_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 2, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro3_cedula}}, domiciliado(a) en {{parte_primera_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 3, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la primera parte, también comparece: {{parte_primera_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_primera_miembro4_cedula}}, domiciliado(a) en {{parte_primera_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA PRIMERA PARTE.', 4, '{"variable":"parte_primera_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro2_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro2_cedula}}, domiciliado(a) en {{parte_segunda_miembro2_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 5, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":2}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro3_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro3_cedula}}, domiciliado(a) en {{parte_segunda_miembro3_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 6, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":3}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order, condition)
  VALUES (v_template, '', 'Y, en conjunto con la segunda parte, también comparece: {{parte_segunda_miembro4_nombre}}, mayor de edad, portador(a) de cédula de identidad y electoral número {{parte_segunda_miembro4_cedula}}, domiciliado(a) en {{parte_segunda_miembro4_domicilio}}, quien en lo adelante se entenderá incluido(a) en la denominación LA SEGUNDA PARTE.', 7, '{"variable":"parte_segunda_cantidad","operator":"greater_or_equal","value":4}'::jsonb);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, '', 'SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 8);

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 9) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en {{cantidad_ejemplares}} originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 10)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('l-salario', 1),
    ('l-jornada', 2),
    ('l-vacaciones', 3),
    ('l-confidencialidad', 4),
    ('l-terminacion-laboral', 5),
    ('l-periodo-prueba', 6),
    ('l-comision-ventas', 7),
    ('g-declaraciones-partes', 8),
    ('g-modificaciones', 9),
    ('g-divisibilidad', 10),
    ('g-notificaciones', 11),
    ('g-ley-aplicable', 12),
    ('integridad-contractual', 13)
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
    (v_template, 'Ocultar parte_segunda_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_domicilio'), 18);

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('cantidad_ejemplares', 1),
    ('ciudad_firma', 2),
    ('comision_porcentaje', 3),
    ('distrito_judicial', 4),
    ('fecha_firma', 5),
    ('horario_trabajo', 6),
    ('horas_semanales', 7),
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
    ('parte_primera_tipo_documento', 23),
    ('parte_segunda_cantidad', 24),
    ('parte_segunda_cedula', 25),
    ('parte_segunda_domicilio', 26),
    ('parte_segunda_genero', 27),
    ('parte_segunda_miembro2_cedula', 28),
    ('parte_segunda_miembro2_domicilio', 29),
    ('parte_segunda_miembro2_nombre', 30),
    ('parte_segunda_miembro3_cedula', 31),
    ('parte_segunda_miembro3_domicilio', 32),
    ('parte_segunda_miembro3_nombre', 33),
    ('parte_segunda_miembro4_cedula', 34),
    ('parte_segunda_miembro4_domicilio', 35),
    ('parte_segunda_miembro4_nombre', 36),
    ('parte_segunda_nacionalidad', 37),
    ('parte_segunda_nombre', 38),
    ('parte_segunda_tipo_documento', 39),
    ('salario_letras', 40)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

