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

-- PARTE 11 de 32: plantillas 81–88. Requiere la parte 0.

-- ── Contrato de Logística y Transporte ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'empresarial';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-logistica-y-transporte';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-logistica-y-transporte', 'Contrato de Logística y Transporte', 'Servicios de transporte y almacenaje de mercancía.',
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
    ('e-precio-servicios', 1),
    ('c-entrega-bien', 2),
    ('e-penalidad-retraso', 3),
    ('g-seguro-bienes', 4),
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
    (v_template, 'Ocultar parte_segunda_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_domicilio'), 18);

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('cantidad_ejemplares', 1),
    ('ciudad_firma', 2),
    ('distrito_judicial', 3),
    ('fecha_entrega_larga', 4),
    ('fecha_firma', 5),
    ('lugar_entrega', 6),
    ('monto_total_letras', 7),
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
    ('parte_responsable_seguro', 24),
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
    ('parte_segunda_tipo_documento', 40),
    ('penalidad_diaria_porcentaje', 41)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Corretaje Comercial ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'empresarial';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-corretaje-comercial';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-corretaje-comercial', 'Contrato de Corretaje Comercial', 'Intermediación en operaciones comerciales.',
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
    ('e-comision-porcentaje', 1),
    ('b-relacion-independiente', 2),
    ('b-territorio', 3),
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
    ('comision_porcentaje', 3),
    ('distrito_judicial', 4),
    ('fecha_firma', 5),
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
    ('parte_primera_tipo_documento', 21),
    ('parte_segunda_cantidad', 22),
    ('parte_segunda_cedula', 23),
    ('parte_segunda_domicilio', 24),
    ('parte_segunda_genero', 25),
    ('parte_segunda_miembro2_cedula', 26),
    ('parte_segunda_miembro2_domicilio', 27),
    ('parte_segunda_miembro2_nombre', 28),
    ('parte_segunda_miembro3_cedula', 29),
    ('parte_segunda_miembro3_domicilio', 30),
    ('parte_segunda_miembro3_nombre', 31),
    ('parte_segunda_miembro4_cedula', 32),
    ('parte_segunda_miembro4_domicilio', 33),
    ('parte_segunda_miembro4_nombre', 34),
    ('parte_segunda_nacionalidad', 35),
    ('parte_segunda_nombre', 36),
    ('parte_segunda_tipo_documento', 37),
    ('territorio_contrato', 38)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Acuerdo de Nivel de Servicio Comercial ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'empresarial';
  SELECT id INTO v_template FROM templates WHERE slug = 'acuerdo-de-nivel-de-servicio-comercial';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'acuerdo-de-nivel-de-servicio-comercial', 'Acuerdo de Nivel de Servicio Comercial', 'Compromisos de servicio entre empresas.',
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
    ('t-nivel-servicio', 1),
    ('t-disponibilidad', 2),
    ('g-penalidad', 3),
    ('e-precio-servicios', 4),
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
    (v_template, 'Ocultar parte_segunda_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_domicilio'), 18);

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('cantidad_ejemplares', 1),
    ('ciudad_firma', 2),
    ('disponibilidad_porcentaje', 3),
    ('distrito_judicial', 4),
    ('fecha_firma', 5),
    ('monto_penalidad_letras', 6),
    ('monto_total_letras', 7),
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
    ('parte_segunda_tipo_documento', 39)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Publicidad Corporativa ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'empresarial';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-publicidad-corporativa';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-publicidad-corporativa', 'Contrato de Publicidad Corporativa', 'Contratación de espacios y campañas publicitarias.',
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
    ('e-precio-servicios', 1),
    ('m-entregables-creativos', 2),
    ('m-derechos-imagen', 3),
    ('b-propiedad-intelectual', 4),
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
    (v_template, 'Ocultar parte_segunda_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_domicilio'), 18);

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('anios_uso_imagen', 1),
    ('cantidad_ejemplares', 2),
    ('cantidad_revisiones', 3),
    ('ciudad_firma', 4),
    ('descripcion_entregables', 5),
    ('distrito_judicial', 6),
    ('fecha_firma', 7),
    ('monto_total_letras', 8),
    ('parte_primera_cantidad', 9),
    ('parte_primera_cedula', 10),
    ('parte_primera_domicilio', 11),
    ('parte_primera_genero', 12),
    ('parte_primera_miembro2_cedula', 13),
    ('parte_primera_miembro2_domicilio', 14),
    ('parte_primera_miembro2_nombre', 15),
    ('parte_primera_miembro3_cedula', 16),
    ('parte_primera_miembro3_domicilio', 17),
    ('parte_primera_miembro3_nombre', 18),
    ('parte_primera_miembro4_cedula', 19),
    ('parte_primera_miembro4_domicilio', 20),
    ('parte_primera_miembro4_nombre', 21),
    ('parte_primera_nacionalidad', 22),
    ('parte_primera_nombre', 23),
    ('parte_primera_tipo_documento', 24),
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
    ('parte_segunda_tipo_documento', 40),
    ('titular_imagen', 41),
    ('titular_propiedad_intelectual', 42)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Patrocinio ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'empresarial';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-patrocinio';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-patrocinio', 'Contrato de Patrocinio', 'Aportación económica a cambio de exposición de marca.',
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
    ('e-precio-servicios', 1),
    ('m-derechos-imagen', 2),
    ('b-propiedad-intelectual', 3),
    ('b-exclusividad', 4),
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
    (v_template, 'Ocultar parte_segunda_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_domicilio'), 18);

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('anios_uso_imagen', 1),
    ('cantidad_ejemplares', 2),
    ('ciudad_firma', 3),
    ('distrito_judicial', 4),
    ('fecha_firma', 5),
    ('monto_total_letras', 6),
    ('objeto_exclusividad', 7),
    ('parte_exclusiva', 8),
    ('parte_primera_cantidad', 9),
    ('parte_primera_cedula', 10),
    ('parte_primera_domicilio', 11),
    ('parte_primera_genero', 12),
    ('parte_primera_miembro2_cedula', 13),
    ('parte_primera_miembro2_domicilio', 14),
    ('parte_primera_miembro2_nombre', 15),
    ('parte_primera_miembro3_cedula', 16),
    ('parte_primera_miembro3_domicilio', 17),
    ('parte_primera_miembro3_nombre', 18),
    ('parte_primera_miembro4_cedula', 19),
    ('parte_primera_miembro4_domicilio', 20),
    ('parte_primera_miembro4_nombre', 21),
    ('parte_primera_nacionalidad', 22),
    ('parte_primera_nombre', 23),
    ('parte_primera_tipo_documento', 24),
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
    ('parte_segunda_tipo_documento', 40),
    ('titular_imagen', 41),
    ('titular_propiedad_intelectual', 42)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Alianza Estratégica ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'empresarial';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-alianza-estrategica';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-alianza-estrategica', 'Contrato de Alianza Estratégica', 'Cooperación de largo plazo entre empresas.',
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
    ('b-relacion-independiente', 1),
    ('b-exclusividad', 2),
    ('b-confidencialidad', 3),
    ('g-arbitraje', 4),
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
    (v_template, 'Ocultar parte_segunda_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_domicilio'), 18);

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('anios_confidencialidad', 1),
    ('cantidad_ejemplares', 2),
    ('ciudad_firma', 3),
    ('distrito_judicial', 4),
    ('fecha_firma', 5),
    ('objeto_exclusividad', 6),
    ('parte_exclusiva', 7),
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
    ('parte_segunda_tipo_documento', 39)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Compra de Activos ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'empresarial';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-compra-de-activos';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-compra-de-activos', 'Contrato de Compra de Activos', 'Adquisición de activos de una empresa.',
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
    ('c-objeto-compraventa', 1),
    ('g-declaraciones-partes', 2),
    ('c-vicios-ocultos', 3),
    ('e-forma-pago', 4),
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
    ('descripcion_bien', 3),
    ('dias_pago', 4),
    ('distrito_judicial', 5),
    ('fecha_firma', 6),
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
    ('precio_venta_letras', 39)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Cesión de Cartera de Clientes ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'empresarial';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-cesion-de-cartera-de-clientes';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-cesion-de-cartera-de-clientes', 'Contrato de Cesión de Cartera de Clientes', 'Traspaso de una cartera comercial.',
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
    ('g-cesion-permitida', 1),
    ('b-confidencialidad', 2),
    ('b-no-competencia', 3),
    ('e-forma-pago', 4),
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
    (v_template, 'Ocultar parte_segunda_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_domicilio'), 18);

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('anios_confidencialidad', 1),
    ('cantidad_ejemplares', 2),
    ('ciudad_firma', 3),
    ('dias_pago', 4),
    ('distrito_judicial', 5),
    ('fecha_firma', 6),
    ('meses_no_competencia', 7),
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
    ('parte_segunda_tipo_documento', 39)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

