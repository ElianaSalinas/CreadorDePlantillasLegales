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

-- PARTE 10 de 10: plantillas 226–249. Requiere la parte 0.

-- ── Contrato de Compraventa de Vehículo a Plazos ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'vehiculos';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-compraventa-de-vehiculo-a-plazos';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-compraventa-de-vehiculo-a-plazos', 'Contrato de Compraventa de Vehículo a Plazos', 'Venta de vehículo con pago fraccionado.',
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
    ('v-descripcion-vehiculo', 1),
    ('e-pago-cuotas', 2),
    ('p-garantia-prestamo', 3),
    ('v-traspaso-vehiculo', 4),
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
    ('cantidad_cuotas', 1),
    ('cantidad_ejemplares', 2),
    ('ciudad_firma', 3),
    ('descripcion_garantia', 4),
    ('dia_pago', 5),
    ('distrito_judicial', 6),
    ('fecha_firma', 7),
    ('monto_cuota_letras', 8),
    ('parte_paga_traspaso', 9),
    ('parte_primera_cantidad', 10),
    ('parte_primera_cedula', 11),
    ('parte_primera_domicilio', 12),
    ('parte_primera_genero', 13),
    ('parte_primera_miembro2_cedula', 14),
    ('parte_primera_miembro2_domicilio', 15),
    ('parte_primera_miembro2_nombre', 16),
    ('parte_primera_miembro3_cedula', 17),
    ('parte_primera_miembro3_domicilio', 18),
    ('parte_primera_miembro3_nombre', 19),
    ('parte_primera_miembro4_cedula', 20),
    ('parte_primera_miembro4_domicilio', 21),
    ('parte_primera_miembro4_nombre', 22),
    ('parte_primera_nacionalidad', 23),
    ('parte_primera_nombre', 24),
    ('parte_primera_tipo_documento', 25),
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
    ('parte_segunda_tipo_documento', 41),
    ('vehiculo_anio', 42),
    ('vehiculo_chasis', 43),
    ('vehiculo_color', 44),
    ('vehiculo_marca', 45),
    ('vehiculo_matricula', 46),
    ('vehiculo_modelo', 47),
    ('vehiculo_placa', 48)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Alquiler de Vehículo ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'vehiculos';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-alquiler-de-vehiculo';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-alquiler-de-vehiculo', 'Contrato de Alquiler de Vehículo', 'Arrendamiento de vehículo por días o meses.',
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
    ('v-descripcion-vehiculo', 1),
    ('e-precio-alquiler', 2),
    ('e-deposito-general', 3),
    ('g-seguro-bienes', 4),
    ('g-devolucion-bien', 5),
    ('g-declaraciones-partes', 6),
    ('g-modificaciones', 7),
    ('g-divisibilidad', 8),
    ('g-notificaciones', 9),
    ('g-ley-aplicable', 10),
    ('integridad-contractual', 11)
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
    ('deposito_letras', 3),
    ('dia_pago', 4),
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
    ('parte_responsable_seguro', 23),
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
    ('periodo_alquiler', 40),
    ('precio_alquiler_letras', 41),
    ('vehiculo_anio', 42),
    ('vehiculo_chasis', 43),
    ('vehiculo_color', 44),
    ('vehiculo_marca', 45),
    ('vehiculo_matricula', 46),
    ('vehiculo_modelo', 47),
    ('vehiculo_placa', 48)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Leasing de Vehículo ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'vehiculos';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-leasing-de-vehiculo';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-leasing-de-vehiculo', 'Contrato de Leasing de Vehículo', 'Arrendamiento financiero con opción de compra.',
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
    ('v-descripcion-vehiculo', 1),
    ('e-pago-cuotas', 2),
    ('v-traspaso-vehiculo', 3),
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
    ('cantidad_cuotas', 1),
    ('cantidad_ejemplares', 2),
    ('ciudad_firma', 3),
    ('dia_pago', 4),
    ('distrito_judicial', 5),
    ('fecha_firma', 6),
    ('monto_cuota_letras', 7),
    ('parte_paga_traspaso', 8),
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
    ('parte_responsable_seguro', 25),
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
    ('parte_segunda_tipo_documento', 41),
    ('vehiculo_anio', 42),
    ('vehiculo_chasis', 43),
    ('vehiculo_color', 44),
    ('vehiculo_marca', 45),
    ('vehiculo_matricula', 46),
    ('vehiculo_modelo', 47),
    ('vehiculo_placa', 48)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Consignación de Vehículo ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'vehiculos';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-consignacion-de-vehiculo';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-consignacion-de-vehiculo', 'Contrato de Consignación de Vehículo', 'Entrega para su venta por un tercero.',
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
    ('v-descripcion-vehiculo', 1),
    ('e-comision-porcentaje', 2),
    ('c-entrega-bien', 3),
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
    ('vehiculo_anio', 40),
    ('vehiculo_chasis', 41),
    ('vehiculo_color', 42),
    ('vehiculo_marca', 43),
    ('vehiculo_matricula', 44),
    ('vehiculo_modelo', 45),
    ('vehiculo_placa', 46)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Acta de Entrega de Vehículo ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'vehiculos';
  SELECT id INTO v_template FROM templates WHERE slug = 'acta-de-entrega-de-vehiculo';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'acta-de-entrega-de-vehiculo', 'Acta de Entrega de Vehículo', 'Constancia del estado al entregar.',
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
    ('v-descripcion-vehiculo', 1),
    ('c-entrega-bien', 2),
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
    ('vehiculo_anio', 39),
    ('vehiculo_chasis', 40),
    ('vehiculo_color', 41),
    ('vehiculo_marca', 42),
    ('vehiculo_matricula', 43),
    ('vehiculo_modelo', 44),
    ('vehiculo_placa', 45)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Autorización de Conducción ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'vehiculos';
  SELECT id INTO v_template FROM templates WHERE slug = 'autorizacion-de-conduccion';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'autorizacion-de-conduccion', 'Autorización de Conducción', 'Permiso para que un tercero conduzca el vehículo.',
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
    ('v-descripcion-vehiculo', 1),
    ('b-representacion', 2),
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
    ('parte_segunda_tipo_documento', 36),
    ('vehiculo_anio', 37),
    ('vehiculo_chasis', 38),
    ('vehiculo_color', 39),
    ('vehiculo_marca', 40),
    ('vehiculo_matricula', 41),
    ('vehiculo_modelo', 42),
    ('vehiculo_placa', 43)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Taller Mecánico ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'vehiculos';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-taller-mecanico';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-taller-mecanico', 'Contrato de Taller Mecánico', 'Reparación y mantenimiento de vehículo.',
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
    ('v-descripcion-vehiculo', 1),
    ('e-precio-servicios', 2),
    ('c-vicios-ocultos', 3),
    ('e-penalidad-retraso', 4),
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
    ('penalidad_diaria_porcentaje', 38),
    ('vehiculo_anio', 39),
    ('vehiculo_chasis', 40),
    ('vehiculo_color', 41),
    ('vehiculo_marca', 42),
    ('vehiculo_matricula', 43),
    ('vehiculo_modelo', 44),
    ('vehiculo_placa', 45)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Transporte de Carga ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'vehiculos';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-transporte-de-carga';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-transporte-de-carga', 'Contrato de Transporte de Carga', 'Traslado de mercancía por carretera.',
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
    ('g-seguro-bienes', 3),
    ('e-penalidad-retraso', 4),
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

-- ── Declaración de Venta de Vehículo ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'vehiculos';
  SELECT id INTO v_template FROM templates WHERE slug = 'declaracion-de-venta-de-vehiculo';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'declaracion-de-venta-de-vehiculo', 'Declaración de Venta de Vehículo', 'Declaración jurada de la venta realizada.',
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
    ('v-descripcion-vehiculo', 1),
    ('g-declaraciones-partes', 2),
    ('v-traspaso-vehiculo', 3),
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
    (v_template, 'Ocultar parte_segunda_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_domicilio'), 18);

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('cantidad_ejemplares', 1),
    ('ciudad_firma', 2),
    ('distrito_judicial', 3),
    ('fecha_firma', 4),
    ('parte_paga_traspaso', 5),
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
    ('vehiculo_anio', 38),
    ('vehiculo_chasis', 39),
    ('vehiculo_color', 40),
    ('vehiculo_marca', 41),
    ('vehiculo_matricula', 42),
    ('vehiculo_modelo', 43),
    ('vehiculo_placa', 44)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Préstamo Personal ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'financiamiento';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-prestamo-personal';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-prestamo-personal', 'Contrato de Préstamo Personal', 'Préstamo entre particulares con plan de pagos.',
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
    ('p-capital-prestamo', 1),
    ('p-amortizacion', 2),
    ('g-intereses-moratorios', 3),
    ('p-garantia-prestamo', 4),
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
    ('cantidad_cuotas', 1),
    ('cantidad_ejemplares', 2),
    ('capital_letras', 3),
    ('ciudad_firma', 4),
    ('descripcion_garantia', 5),
    ('dia_pago', 6),
    ('distrito_judicial', 7),
    ('fecha_firma', 8),
    ('interes_mora_porcentaje', 9),
    ('monto_cuota_letras', 10),
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
    ('parte_primera_tipo_documento', 26),
    ('parte_segunda_cantidad', 27),
    ('parte_segunda_cedula', 28),
    ('parte_segunda_domicilio', 29),
    ('parte_segunda_genero', 30),
    ('parte_segunda_miembro2_cedula', 31),
    ('parte_segunda_miembro2_domicilio', 32),
    ('parte_segunda_miembro2_nombre', 33),
    ('parte_segunda_miembro3_cedula', 34),
    ('parte_segunda_miembro3_domicilio', 35),
    ('parte_segunda_miembro3_nombre', 36),
    ('parte_segunda_miembro4_cedula', 37),
    ('parte_segunda_miembro4_domicilio', 38),
    ('parte_segunda_miembro4_nombre', 39),
    ('parte_segunda_nacionalidad', 40),
    ('parte_segunda_nombre', 41),
    ('parte_segunda_tipo_documento', 42)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Préstamo con Garantía Hipotecaria ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'financiamiento';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-prestamo-con-garantia-hipotecaria';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-prestamo-con-garantia-hipotecaria', 'Contrato de Préstamo con Garantía Hipotecaria', 'Préstamo respaldado por un inmueble.',
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
    ('p-capital-prestamo', 1),
    ('p-amortizacion', 2),
    ('p-garantia-prestamo', 3),
    ('i-descripcion-inmueble', 4),
    ('g-intereses-moratorios', 5),
    ('g-declaraciones-partes', 6),
    ('g-modificaciones', 7),
    ('g-divisibilidad', 8),
    ('g-notificaciones', 9),
    ('g-ley-aplicable', 10),
    ('integridad-contractual', 11)
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
    ('cantidad_cuotas', 1),
    ('cantidad_ejemplares', 2),
    ('capital_letras', 3),
    ('certificado_titulo', 4),
    ('ciudad_firma', 5),
    ('descripcion_garantia', 6),
    ('descripcion_registral', 7),
    ('dia_pago', 8),
    ('direccion_inmueble', 9),
    ('distrito_judicial', 10),
    ('fecha_firma', 11),
    ('interes_mora_porcentaje', 12),
    ('monto_cuota_letras', 13),
    ('parte_primera_cantidad', 14),
    ('parte_primera_cedula', 15),
    ('parte_primera_domicilio', 16),
    ('parte_primera_genero', 17),
    ('parte_primera_miembro2_cedula', 18),
    ('parte_primera_miembro2_domicilio', 19),
    ('parte_primera_miembro2_nombre', 20),
    ('parte_primera_miembro3_cedula', 21),
    ('parte_primera_miembro3_domicilio', 22),
    ('parte_primera_miembro3_nombre', 23),
    ('parte_primera_miembro4_cedula', 24),
    ('parte_primera_miembro4_domicilio', 25),
    ('parte_primera_miembro4_nombre', 26),
    ('parte_primera_nacionalidad', 27),
    ('parte_primera_nombre', 28),
    ('parte_primera_tipo_documento', 29),
    ('parte_segunda_cantidad', 30),
    ('parte_segunda_cedula', 31),
    ('parte_segunda_domicilio', 32),
    ('parte_segunda_genero', 33),
    ('parte_segunda_miembro2_cedula', 34),
    ('parte_segunda_miembro2_domicilio', 35),
    ('parte_segunda_miembro2_nombre', 36),
    ('parte_segunda_miembro3_cedula', 37),
    ('parte_segunda_miembro3_domicilio', 38),
    ('parte_segunda_miembro3_nombre', 39),
    ('parte_segunda_miembro4_cedula', 40),
    ('parte_segunda_miembro4_domicilio', 41),
    ('parte_segunda_miembro4_nombre', 42),
    ('parte_segunda_nacionalidad', 43),
    ('parte_segunda_nombre', 44),
    ('parte_segunda_tipo_documento', 45),
    ('superficie_metros', 46)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Préstamo con Garantía Prendaria ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'financiamiento';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-prestamo-con-garantia-prendaria';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-prestamo-con-garantia-prendaria', 'Contrato de Préstamo con Garantía Prendaria', 'Préstamo respaldado por bienes muebles.',
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
    ('p-capital-prestamo', 1),
    ('p-amortizacion', 2),
    ('p-garantia-prestamo', 3),
    ('g-intereses-moratorios', 4),
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
    ('cantidad_cuotas', 1),
    ('cantidad_ejemplares', 2),
    ('capital_letras', 3),
    ('ciudad_firma', 4),
    ('descripcion_garantia', 5),
    ('dia_pago', 6),
    ('distrito_judicial', 7),
    ('fecha_firma', 8),
    ('interes_mora_porcentaje', 9),
    ('monto_cuota_letras', 10),
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
    ('parte_primera_tipo_documento', 26),
    ('parte_segunda_cantidad', 27),
    ('parte_segunda_cedula', 28),
    ('parte_segunda_domicilio', 29),
    ('parte_segunda_genero', 30),
    ('parte_segunda_miembro2_cedula', 31),
    ('parte_segunda_miembro2_domicilio', 32),
    ('parte_segunda_miembro2_nombre', 33),
    ('parte_segunda_miembro3_cedula', 34),
    ('parte_segunda_miembro3_domicilio', 35),
    ('parte_segunda_miembro3_nombre', 36),
    ('parte_segunda_miembro4_cedula', 37),
    ('parte_segunda_miembro4_domicilio', 38),
    ('parte_segunda_miembro4_nombre', 39),
    ('parte_segunda_nacionalidad', 40),
    ('parte_segunda_nombre', 41),
    ('parte_segunda_tipo_documento', 42)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Pagaré ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'financiamiento';
  SELECT id INTO v_template FROM templates WHERE slug = 'pagare';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'pagare', 'Pagaré', 'Promesa incondicional de pago.',
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
    ('p-capital-prestamo', 1),
    ('g-intereses-moratorios', 2),
    ('g-notificaciones', 3),
    ('g-declaraciones-partes', 4),
    ('g-modificaciones', 5),
    ('g-divisibilidad', 6),
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
    (v_template, 'Ocultar parte_segunda_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_domicilio'), 18);

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('cantidad_ejemplares', 1),
    ('capital_letras', 2),
    ('ciudad_firma', 3),
    ('distrito_judicial', 4),
    ('fecha_firma', 5),
    ('interes_mora_porcentaje', 6),
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
    ('parte_segunda_tipo_documento', 38)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Línea de Crédito ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'financiamiento';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-linea-de-credito';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-linea-de-credito', 'Contrato de Línea de Crédito', 'Crédito disponible hasta un límite.',
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
    ('p-capital-prestamo', 1),
    ('g-intereses-moratorios', 2),
    ('p-garantia-prestamo', 3),
    ('g-renovacion-automatica', 4),
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
    ('capital_letras', 2),
    ('ciudad_firma', 3),
    ('descripcion_garantia', 4),
    ('distrito_judicial', 5),
    ('fecha_firma', 6),
    ('interes_mora_porcentaje', 7),
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

-- ── Contrato de Factoring ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'financiamiento';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-factoring';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-factoring', 'Contrato de Factoring', 'Cesión de facturas para obtener liquidez.',
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
    ('e-comision-porcentaje', 2),
    ('g-notificaciones', 3),
    ('g-declaraciones-partes', 4),
    ('g-modificaciones', 5),
    ('g-divisibilidad', 6),
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
    ('parte_segunda_tipo_documento', 37)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Inversión ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'financiamiento';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-inversion';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-inversion', 'Contrato de Inversión', 'Aportación de capital a un proyecto.',
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
    ('p-capital-prestamo', 1),
    ('g-declaraciones-partes', 2),
    ('b-confidencialidad', 3),
    ('g-arbitraje', 4),
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
    ('anios_confidencialidad', 1),
    ('cantidad_ejemplares', 2),
    ('capital_letras', 3),
    ('ciudad_firma', 4),
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
    ('parte_segunda_tipo_documento', 38)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Acuerdo de Reestructuración de Deuda ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'financiamiento';
  SELECT id INTO v_template FROM templates WHERE slug = 'acuerdo-de-reestructuracion-de-deuda';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'acuerdo-de-reestructuracion-de-deuda', 'Acuerdo de Reestructuración de Deuda', 'Nuevo plan de pagos de una deuda vencida.',
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
    ('p-amortizacion', 1),
    ('g-intereses-moratorios', 2),
    ('g-modificaciones', 3),
    ('g-terminacion-mutuo-acuerdo', 4),
    ('g-declaraciones-partes', 5),
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
    ('cantidad_cuotas', 1),
    ('cantidad_ejemplares', 2),
    ('ciudad_firma', 3),
    ('dia_pago', 4),
    ('distrito_judicial', 5),
    ('fecha_firma', 6),
    ('interes_mora_porcentaje', 7),
    ('monto_cuota_letras', 8),
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
    ('parte_segunda_tipo_documento', 40)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Aval ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'financiamiento';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-aval';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-aval', 'Contrato de Aval', 'Garantía personal de una obligación.',
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
    ('p-garantia-prestamo', 1),
    ('g-obligaciones-partes', 2),
    ('g-penalidad', 3),
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
    ('descripcion_garantia', 3),
    ('distrito_judicial', 4),
    ('fecha_firma', 5),
    ('monto_penalidad_letras', 6),
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
    ('parte_segunda_tipo_documento', 38)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Cancelación de Deuda ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'financiamiento';
  SELECT id INTO v_template FROM templates WHERE slug = 'carta-de-cancelacion-de-deuda';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-de-cancelacion-de-deuda', 'Carta de Cancelación de Deuda', 'Constancia de que la deuda quedó saldada.',
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

-- ── Contrato de Cesión de Derechos de Cobro ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'financiamiento';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-cesion-de-derechos-de-cobro';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-cesion-de-derechos-de-cobro', 'Contrato de Cesión de Derechos de Cobro', 'Traspaso del derecho a cobrar.',
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
    ('g-notificaciones', 2),
    ('e-forma-pago', 3),
    ('g-declaraciones-partes', 4),
    ('g-modificaciones', 5),
    ('g-divisibilidad', 6),
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
    (v_template, 'Ocultar parte_segunda_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_domicilio'), 18);

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('cantidad_ejemplares', 1),
    ('ciudad_firma', 2),
    ('dias_pago', 3),
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
    ('parte_segunda_tipo_documento', 37)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Arrendamiento Financiero ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'financiamiento';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-arrendamiento-financiero';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-arrendamiento-financiero', 'Contrato de Arrendamiento Financiero', 'Leasing de bienes de capital.',
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
    ('e-pago-cuotas', 1),
    ('c-entrega-bien', 2),
    ('p-garantia-prestamo', 3),
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
    ('cantidad_cuotas', 1),
    ('cantidad_ejemplares', 2),
    ('ciudad_firma', 3),
    ('descripcion_garantia', 4),
    ('dia_pago', 5),
    ('distrito_judicial', 6),
    ('fecha_entrega_larga', 7),
    ('fecha_firma', 8),
    ('lugar_entrega', 9),
    ('monto_cuota_letras', 10),
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
    ('parte_primera_tipo_documento', 26),
    ('parte_responsable_seguro', 27),
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
    ('parte_segunda_tipo_documento', 43)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Mutuo con Interés ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'financiamiento';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-mutuo-con-interes';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-mutuo-con-interes', 'Contrato de Mutuo con Interés', 'Préstamo de dinero con interés pactado.',
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
    ('p-capital-prestamo', 1),
    ('p-amortizacion', 2),
    ('g-intereses-moratorios', 3),
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
    ('cantidad_cuotas', 1),
    ('cantidad_ejemplares', 2),
    ('capital_letras', 3),
    ('ciudad_firma', 4),
    ('dia_pago', 5),
    ('distrito_judicial', 6),
    ('fecha_firma', 7),
    ('interes_mora_porcentaje', 8),
    ('monto_cuota_letras', 9),
    ('parte_primera_cantidad', 10),
    ('parte_primera_cedula', 11),
    ('parte_primera_domicilio', 12),
    ('parte_primera_genero', 13),
    ('parte_primera_miembro2_cedula', 14),
    ('parte_primera_miembro2_domicilio', 15),
    ('parte_primera_miembro2_nombre', 16),
    ('parte_primera_miembro3_cedula', 17),
    ('parte_primera_miembro3_domicilio', 18),
    ('parte_primera_miembro3_nombre', 19),
    ('parte_primera_miembro4_cedula', 20),
    ('parte_primera_miembro4_domicilio', 21),
    ('parte_primera_miembro4_nombre', 22),
    ('parte_primera_nacionalidad', 23),
    ('parte_primera_nombre', 24),
    ('parte_primera_tipo_documento', 25),
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
    ('parte_segunda_tipo_documento', 41)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Plan de Pagos ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'financiamiento';
  SELECT id INTO v_template FROM templates WHERE slug = 'plan-de-pagos';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'plan-de-pagos', 'Plan de Pagos', 'Calendario de amortización acordado.',
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
    ('p-amortizacion', 1),
    ('e-pago-cuotas', 2),
    ('g-intereses-moratorios', 3),
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
    ('cantidad_cuotas', 1),
    ('cantidad_ejemplares', 2),
    ('ciudad_firma', 3),
    ('dia_pago', 4),
    ('distrito_judicial', 5),
    ('fecha_firma', 6),
    ('interes_mora_porcentaje', 7),
    ('monto_cuota_letras', 8),
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
    ('parte_segunda_tipo_documento', 40)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Fideicomiso de Garantía ── 
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'financiamiento';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-fideicomiso-de-garantia';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-fideicomiso-de-garantia', 'Contrato de Fideicomiso de Garantía', 'Bienes en fideicomiso como garantía.',
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
    ('p-garantia-prestamo', 1),
    ('g-declaraciones-partes', 2),
    ('g-obligaciones-partes', 3),
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
    (v_template, 'Ocultar parte_segunda_miembro4_domicilio si la parte tiene menos de 4 personas', '{"variable":"parte_segunda_cantidad","operator":"less_than","value":4}'::jsonb, 'HIDE_VARIABLE', jsonb_build_object('variable_tag', 'parte_segunda_miembro4_domicilio'), 18);

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('cantidad_ejemplares', 1),
    ('ciudad_firma', 2),
    ('descripcion_garantia', 3),
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
    ('parte_segunda_tipo_documento', 37)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

