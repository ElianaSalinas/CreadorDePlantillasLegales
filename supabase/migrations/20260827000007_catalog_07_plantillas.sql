-- ==========================================================
-- SA&VE Comercial, S.R.L. — Punta Cana, República Dominicana
-- CATÁLOGO COMPLETO · GENERADO AUTOMÁTICAMENTE
--
-- NO EDITAR A MANO. Este archivo lo produce:
--   npm run catalog:build
-- a partir de scripts/catalog/clauses.ts y templates.ts
--
-- ⚠️  101 cláusulas y 250 plantillas, TODAS en estado DRAFT.
--     Ningún usuario las ve hasta que un abogado dominicano las
--     revise y las publique. Al final hay instrucciones.
-- ==========================================================

-- PARTE 7 de 10: plantillas 151–175. Requiere la parte 0.

-- ── Contrato de Construcción a Precio Alzado ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'construccion';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-construccion-a-precio-alzado';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-construccion-a-precio-alzado', 'Contrato de Construcción a Precio Alzado', 'Obra por un precio fijo global.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('o-plazo-obra', 1),
    ('o-materiales', 2),
    ('o-recepcion-obra', 3),
    ('e-retencion-garantia', 4),
    ('e-precio-servicios', 5),
    ('e-penalidad-retraso', 6),
    ('c-vicios-ocultos', 7),
    ('g-declaraciones-partes', 8),
    ('g-modificaciones', 9),
    ('g-divisibilidad', 10),
    ('g-notificaciones', 11),
    ('g-ley-aplicable', 12),
    ('integridad-contractual', 13)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('dias_recepcion_definitiva', 2),
    ('distrito_judicial', 3),
    ('monto_total_letras', 4),
    ('parte_primera_cedula', 5),
    ('parte_primera_domicilio', 6),
    ('parte_primera_nacionalidad', 7),
    ('parte_primera_nombre', 8),
    ('parte_segunda_cedula', 9),
    ('parte_segunda_domicilio', 10),
    ('parte_segunda_nacionalidad', 11),
    ('parte_segunda_nombre', 12),
    ('parte_suministra_materiales', 13),
    ('penalidad_diaria_porcentaje', 14),
    ('plazo_obra_dias', 15),
    ('retencion_porcentaje', 16)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Construcción por Administración ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'construccion';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-construccion-por-administracion';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-construccion-por-administracion', 'Contrato de Construcción por Administración', 'Obra facturada por costos más honorarios.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('o-plazo-obra', 1),
    ('o-materiales', 2),
    ('o-recepcion-obra', 3),
    ('e-retencion-garantia', 4),
    ('e-reembolso-gastos', 5),
    ('e-comision-porcentaje', 6),
    ('g-declaraciones-partes', 7),
    ('g-modificaciones', 8),
    ('g-divisibilidad', 9),
    ('g-notificaciones', 10),
    ('g-ley-aplicable', 11),
    ('integridad-contractual', 12)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('comision_porcentaje', 2),
    ('dias_recepcion_definitiva', 3),
    ('distrito_judicial', 4),
    ('parte_primera_cedula', 5),
    ('parte_primera_domicilio', 6),
    ('parte_primera_nacionalidad', 7),
    ('parte_primera_nombre', 8),
    ('parte_segunda_cedula', 9),
    ('parte_segunda_domicilio', 10),
    ('parte_segunda_nacionalidad', 11),
    ('parte_segunda_nombre', 12),
    ('parte_suministra_materiales', 13),
    ('plazo_obra_dias', 14),
    ('retencion_porcentaje', 15)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Remodelación ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'construccion';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-remodelacion';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-remodelacion', 'Contrato de Remodelación', 'Reforma de un inmueble existente.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('o-plazo-obra', 1),
    ('o-materiales', 2),
    ('o-recepcion-obra', 3),
    ('e-retencion-garantia', 4),
    ('e-precio-servicios', 5),
    ('o-alcance-obra', 6),
    ('g-declaraciones-partes', 7),
    ('g-modificaciones', 8),
    ('g-divisibilidad', 9),
    ('g-notificaciones', 10),
    ('g-ley-aplicable', 11),
    ('integridad-contractual', 12)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('descripcion_obra', 2),
    ('dias_recepcion_definitiva', 3),
    ('distrito_judicial', 4),
    ('monto_total_letras', 5),
    ('parte_primera_cedula', 6),
    ('parte_primera_domicilio', 7),
    ('parte_primera_nacionalidad', 8),
    ('parte_primera_nombre', 9),
    ('parte_segunda_cedula', 10),
    ('parte_segunda_domicilio', 11),
    ('parte_segunda_nacionalidad', 12),
    ('parte_segunda_nombre', 13),
    ('parte_suministra_materiales', 14),
    ('plazo_obra_dias', 15),
    ('retencion_porcentaje', 16)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Subcontratación de Obra ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'construccion';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-subcontratacion-de-obra';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-subcontratacion-de-obra', 'Contrato de Subcontratación de Obra', 'Encargo parcial a un subcontratista.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('o-plazo-obra', 1),
    ('o-materiales', 2),
    ('o-recepcion-obra', 3),
    ('e-retencion-garantia', 4),
    ('b-relacion-independiente', 5),
    ('e-penalidad-retraso', 6),
    ('g-declaraciones-partes', 7),
    ('g-modificaciones', 8),
    ('g-divisibilidad', 9),
    ('g-notificaciones', 10),
    ('g-ley-aplicable', 11),
    ('integridad-contractual', 12)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('dias_recepcion_definitiva', 2),
    ('distrito_judicial', 3),
    ('parte_primera_cedula', 4),
    ('parte_primera_domicilio', 5),
    ('parte_primera_nacionalidad', 6),
    ('parte_primera_nombre', 7),
    ('parte_segunda_cedula', 8),
    ('parte_segunda_domicilio', 9),
    ('parte_segunda_nacionalidad', 10),
    ('parte_segunda_nombre', 11),
    ('parte_suministra_materiales', 12),
    ('penalidad_diaria_porcentaje', 13),
    ('plazo_obra_dias', 14),
    ('retencion_porcentaje', 15)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Supervisión de Obra ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'construccion';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-supervision-de-obra';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-supervision-de-obra', 'Contrato de Supervisión de Obra', 'Dirección técnica y control de calidad.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('e-precio-servicios', 1),
    ('o-recepcion-obra', 2),
    ('b-relacion-independiente', 3),
    ('t-aceptacion-entregables', 4),
    ('g-declaraciones-partes', 5),
    ('g-modificaciones', 6),
    ('g-divisibilidad', 7),
    ('g-notificaciones', 8),
    ('g-ley-aplicable', 9),
    ('integridad-contractual', 10)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('dias_aceptacion', 2),
    ('dias_recepcion_definitiva', 3),
    ('distrito_judicial', 4),
    ('monto_total_letras', 5),
    ('parte_primera_cedula', 6),
    ('parte_primera_domicilio', 7),
    ('parte_primera_nacionalidad', 8),
    ('parte_primera_nombre', 9),
    ('parte_segunda_cedula', 10),
    ('parte_segunda_domicilio', 11),
    ('parte_segunda_nacionalidad', 12),
    ('parte_segunda_nombre', 13)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Diseño y Construcción ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'construccion';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-diseno-y-construccion';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-diseno-y-construccion', 'Contrato de Diseño y Construcción', 'Proyecto y ejecución bajo un mismo contrato.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('o-plazo-obra', 1),
    ('o-materiales', 2),
    ('o-recepcion-obra', 3),
    ('e-retencion-garantia', 4),
    ('b-propiedad-intelectual', 5),
    ('e-precio-servicios', 6),
    ('g-declaraciones-partes', 7),
    ('g-modificaciones', 8),
    ('g-divisibilidad', 9),
    ('g-notificaciones', 10),
    ('g-ley-aplicable', 11),
    ('integridad-contractual', 12)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('dias_recepcion_definitiva', 2),
    ('distrito_judicial', 3),
    ('monto_total_letras', 4),
    ('parte_primera_cedula', 5),
    ('parte_primera_domicilio', 6),
    ('parte_primera_nacionalidad', 7),
    ('parte_primera_nombre', 8),
    ('parte_segunda_cedula', 9),
    ('parte_segunda_domicilio', 10),
    ('parte_segunda_nacionalidad', 11),
    ('parte_segunda_nombre', 12),
    ('parte_suministra_materiales', 13),
    ('plazo_obra_dias', 14),
    ('retencion_porcentaje', 15),
    ('titular_propiedad_intelectual', 16)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Instalación Eléctrica ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'construccion';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-instalacion-electrica';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-instalacion-electrica', 'Contrato de Instalación Eléctrica', 'Instalación y certificación eléctrica.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('o-plazo-obra', 1),
    ('o-materiales', 2),
    ('o-recepcion-obra', 3),
    ('e-retencion-garantia', 4),
    ('c-vicios-ocultos', 5),
    ('g-declaraciones-partes', 6),
    ('g-modificaciones', 7),
    ('g-divisibilidad', 8),
    ('g-notificaciones', 9),
    ('g-ley-aplicable', 10),
    ('integridad-contractual', 11)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('dias_recepcion_definitiva', 2),
    ('distrito_judicial', 3),
    ('parte_primera_cedula', 4),
    ('parte_primera_domicilio', 5),
    ('parte_primera_nacionalidad', 6),
    ('parte_primera_nombre', 7),
    ('parte_segunda_cedula', 8),
    ('parte_segunda_domicilio', 9),
    ('parte_segunda_nacionalidad', 10),
    ('parte_segunda_nombre', 11),
    ('parte_suministra_materiales', 12),
    ('plazo_obra_dias', 13),
    ('retencion_porcentaje', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Instalación Sanitaria ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'construccion';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-instalacion-sanitaria';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-instalacion-sanitaria', 'Contrato de Instalación Sanitaria', 'Instalación de sistemas hidráulicos y sanitarios.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('o-plazo-obra', 1),
    ('o-materiales', 2),
    ('o-recepcion-obra', 3),
    ('e-retencion-garantia', 4),
    ('c-vicios-ocultos', 5),
    ('g-declaraciones-partes', 6),
    ('g-modificaciones', 7),
    ('g-divisibilidad', 8),
    ('g-notificaciones', 9),
    ('g-ley-aplicable', 10),
    ('integridad-contractual', 11)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('dias_recepcion_definitiva', 2),
    ('distrito_judicial', 3),
    ('parte_primera_cedula', 4),
    ('parte_primera_domicilio', 5),
    ('parte_primera_nacionalidad', 6),
    ('parte_primera_nombre', 7),
    ('parte_segunda_cedula', 8),
    ('parte_segunda_domicilio', 9),
    ('parte_segunda_nacionalidad', 10),
    ('parte_segunda_nombre', 11),
    ('parte_suministra_materiales', 12),
    ('plazo_obra_dias', 13),
    ('retencion_porcentaje', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Instalación de Aire Acondicionado ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'construccion';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-instalacion-de-aire-acondicionado';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-instalacion-de-aire-acondicionado', 'Contrato de Instalación de Aire Acondicionado', 'Suministro e instalación de climatización.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('c-entrega-bien', 1),
    ('o-plazo-obra', 2),
    ('c-vicios-ocultos', 3),
    ('t-soporte-tecnico', 4),
    ('g-declaraciones-partes', 5),
    ('g-modificaciones', 6),
    ('g-divisibilidad', 7),
    ('g-notificaciones', 8),
    ('g-ley-aplicable', 9),
    ('integridad-contractual', 10)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('distrito_judicial', 2),
    ('fecha_entrega_larga', 3),
    ('horario_soporte', 4),
    ('lugar_entrega', 5),
    ('parte_primera_cedula', 6),
    ('parte_primera_domicilio', 7),
    ('parte_primera_nacionalidad', 8),
    ('parte_primera_nombre', 9),
    ('parte_segunda_cedula', 10),
    ('parte_segunda_domicilio', 11),
    ('parte_segunda_nacionalidad', 12),
    ('parte_segunda_nombre', 13),
    ('plazo_obra_dias', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Impermeabilización ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'construccion';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-impermeabilizacion';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-impermeabilizacion', 'Contrato de Impermeabilización', 'Tratamiento de techos y superficies.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('o-plazo-obra', 1),
    ('o-materiales', 2),
    ('o-recepcion-obra', 3),
    ('e-retencion-garantia', 4),
    ('c-vicios-ocultos', 5),
    ('g-declaraciones-partes', 6),
    ('g-modificaciones', 7),
    ('g-divisibilidad', 8),
    ('g-notificaciones', 9),
    ('g-ley-aplicable', 10),
    ('integridad-contractual', 11)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('dias_recepcion_definitiva', 2),
    ('distrito_judicial', 3),
    ('parte_primera_cedula', 4),
    ('parte_primera_domicilio', 5),
    ('parte_primera_nacionalidad', 6),
    ('parte_primera_nombre', 7),
    ('parte_segunda_cedula', 8),
    ('parte_segunda_domicilio', 9),
    ('parte_segunda_nacionalidad', 10),
    ('parte_segunda_nombre', 11),
    ('parte_suministra_materiales', 12),
    ('plazo_obra_dias', 13),
    ('retencion_porcentaje', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Pintura ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'construccion';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-pintura';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-pintura', 'Contrato de Pintura', 'Trabajos de pintura interior y exterior.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('o-plazo-obra', 1),
    ('o-materiales', 2),
    ('e-precio-servicios', 3),
    ('o-recepcion-obra', 4),
    ('g-declaraciones-partes', 5),
    ('g-modificaciones', 6),
    ('g-divisibilidad', 7),
    ('g-notificaciones', 8),
    ('g-ley-aplicable', 9),
    ('integridad-contractual', 10)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('dias_recepcion_definitiva', 2),
    ('distrito_judicial', 3),
    ('monto_total_letras', 4),
    ('parte_primera_cedula', 5),
    ('parte_primera_domicilio', 6),
    ('parte_primera_nacionalidad', 7),
    ('parte_primera_nombre', 8),
    ('parte_segunda_cedula', 9),
    ('parte_segunda_domicilio', 10),
    ('parte_segunda_nacionalidad', 11),
    ('parte_segunda_nombre', 12),
    ('parte_suministra_materiales', 13),
    ('plazo_obra_dias', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Carpintería ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'construccion';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-carpinteria';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-carpinteria', 'Contrato de Carpintería', 'Fabricación e instalación de piezas de madera.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('o-materiales', 1),
    ('o-plazo-obra', 2),
    ('c-entrega-bien', 3),
    ('c-vicios-ocultos', 4),
    ('g-declaraciones-partes', 5),
    ('g-modificaciones', 6),
    ('g-divisibilidad', 7),
    ('g-notificaciones', 8),
    ('g-ley-aplicable', 9),
    ('integridad-contractual', 10)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('distrito_judicial', 2),
    ('fecha_entrega_larga', 3),
    ('lugar_entrega', 4),
    ('parte_primera_cedula', 5),
    ('parte_primera_domicilio', 6),
    ('parte_primera_nacionalidad', 7),
    ('parte_primera_nombre', 8),
    ('parte_segunda_cedula', 9),
    ('parte_segunda_domicilio', 10),
    ('parte_segunda_nacionalidad', 11),
    ('parte_segunda_nombre', 12),
    ('parte_suministra_materiales', 13),
    ('plazo_obra_dias', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Herrería ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'construccion';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-herreria';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-herreria', 'Contrato de Herrería', 'Trabajos metálicos por encargo.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('o-materiales', 1),
    ('o-plazo-obra', 2),
    ('c-entrega-bien', 3),
    ('c-vicios-ocultos', 4),
    ('g-declaraciones-partes', 5),
    ('g-modificaciones', 6),
    ('g-divisibilidad', 7),
    ('g-notificaciones', 8),
    ('g-ley-aplicable', 9),
    ('integridad-contractual', 10)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('distrito_judicial', 2),
    ('fecha_entrega_larga', 3),
    ('lugar_entrega', 4),
    ('parte_primera_cedula', 5),
    ('parte_primera_domicilio', 6),
    ('parte_primera_nacionalidad', 7),
    ('parte_primera_nombre', 8),
    ('parte_segunda_cedula', 9),
    ('parte_segunda_domicilio', 10),
    ('parte_segunda_nacionalidad', 11),
    ('parte_segunda_nombre', 12),
    ('parte_suministra_materiales', 13),
    ('plazo_obra_dias', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Movimiento de Tierra ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'construccion';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-movimiento-de-tierra';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-movimiento-de-tierra', 'Contrato de Movimiento de Tierra', 'Excavación y nivelación de terreno.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('o-plazo-obra', 1),
    ('e-precio-servicios', 2),
    ('i-descripcion-inmueble', 3),
    ('e-penalidad-retraso', 4),
    ('g-declaraciones-partes', 5),
    ('g-modificaciones', 6),
    ('g-divisibilidad', 7),
    ('g-notificaciones', 8),
    ('g-ley-aplicable', 9),
    ('integridad-contractual', 10)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('certificado_titulo', 1),
    ('ciudad_firma', 2),
    ('descripcion_registral', 3),
    ('direccion_inmueble', 4),
    ('distrito_judicial', 5),
    ('monto_total_letras', 6),
    ('parte_primera_cedula', 7),
    ('parte_primera_domicilio', 8),
    ('parte_primera_nacionalidad', 9),
    ('parte_primera_nombre', 10),
    ('parte_segunda_cedula', 11),
    ('parte_segunda_domicilio', 12),
    ('parte_segunda_nacionalidad', 13),
    ('parte_segunda_nombre', 14),
    ('penalidad_diaria_porcentaje', 15),
    ('plazo_obra_dias', 16),
    ('superficie_metros', 17)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Suministro de Materiales ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'construccion';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-suministro-de-materiales';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-suministro-de-materiales', 'Contrato de Suministro de Materiales', 'Provisión de materiales de construcción.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('c-entrega-bien', 1),
    ('o-materiales', 2),
    ('e-forma-pago', 3),
    ('e-penalidad-retraso', 4),
    ('g-declaraciones-partes', 5),
    ('g-modificaciones', 6),
    ('g-divisibilidad', 7),
    ('g-notificaciones', 8),
    ('g-ley-aplicable', 9),
    ('integridad-contractual', 10)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('dias_pago', 2),
    ('distrito_judicial', 3),
    ('fecha_entrega_larga', 4),
    ('lugar_entrega', 5),
    ('parte_primera_cedula', 6),
    ('parte_primera_domicilio', 7),
    ('parte_primera_nacionalidad', 8),
    ('parte_primera_nombre', 9),
    ('parte_segunda_cedula', 10),
    ('parte_segunda_domicilio', 11),
    ('parte_segunda_nacionalidad', 12),
    ('parte_segunda_nombre', 13),
    ('parte_suministra_materiales', 14),
    ('penalidad_diaria_porcentaje', 15)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Acta de Inicio de Obra ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'construccion';
  SELECT id INTO v_template FROM templates WHERE slug = 'acta-de-inicio-de-obra';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'acta-de-inicio-de-obra', 'Acta de Inicio de Obra', 'Constancia del comienzo de los trabajos.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('o-plazo-obra', 1),
    ('g-declaraciones-partes', 2),
    ('g-modificaciones', 3),
    ('g-divisibilidad', 4),
    ('g-notificaciones', 5),
    ('g-ley-aplicable', 6),
    ('integridad-contractual', 7)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('distrito_judicial', 2),
    ('parte_primera_cedula', 3),
    ('parte_primera_domicilio', 4),
    ('parte_primera_nacionalidad', 5),
    ('parte_primera_nombre', 6),
    ('parte_segunda_cedula', 7),
    ('parte_segunda_domicilio', 8),
    ('parte_segunda_nacionalidad', 9),
    ('parte_segunda_nombre', 10),
    ('plazo_obra_dias', 11)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Acta de Recepción Provisional ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'construccion';
  SELECT id INTO v_template FROM templates WHERE slug = 'acta-de-recepcion-provisional';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'acta-de-recepcion-provisional', 'Acta de Recepción Provisional', 'Entrega con observaciones pendientes.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('o-recepcion-obra', 1),
    ('e-retencion-garantia', 2),
    ('g-declaraciones-partes', 3),
    ('g-modificaciones', 4),
    ('g-divisibilidad', 5),
    ('g-notificaciones', 6),
    ('g-ley-aplicable', 7),
    ('integridad-contractual', 8)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('dias_recepcion_definitiva', 2),
    ('distrito_judicial', 3),
    ('parte_primera_cedula', 4),
    ('parte_primera_domicilio', 5),
    ('parte_primera_nacionalidad', 6),
    ('parte_primera_nombre', 7),
    ('parte_segunda_cedula', 8),
    ('parte_segunda_domicilio', 9),
    ('parte_segunda_nacionalidad', 10),
    ('parte_segunda_nombre', 11),
    ('retencion_porcentaje', 12)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Acta de Recepción Definitiva ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'construccion';
  SELECT id INTO v_template FROM templates WHERE slug = 'acta-de-recepcion-definitiva';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'acta-de-recepcion-definitiva', 'Acta de Recepción Definitiva', 'Entrega final y liberación de retenciones.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('o-recepcion-obra', 1),
    ('e-retencion-garantia', 2),
    ('c-vicios-ocultos', 3),
    ('g-declaraciones-partes', 4),
    ('g-modificaciones', 5),
    ('g-divisibilidad', 6),
    ('g-notificaciones', 7),
    ('g-ley-aplicable', 8),
    ('integridad-contractual', 9)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('dias_recepcion_definitiva', 2),
    ('distrito_judicial', 3),
    ('parte_primera_cedula', 4),
    ('parte_primera_domicilio', 5),
    ('parte_primera_nacionalidad', 6),
    ('parte_primera_nombre', 7),
    ('parte_segunda_cedula', 8),
    ('parte_segunda_domicilio', 9),
    ('parte_segunda_nacionalidad', 10),
    ('parte_segunda_nombre', 11),
    ('retencion_porcentaje', 12)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Orden de Cambio de Obra ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'construccion';
  SELECT id INTO v_template FROM templates WHERE slug = 'orden-de-cambio-de-obra';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'orden-de-cambio-de-obra', 'Orden de Cambio de Obra', 'Modificación del alcance o del precio de la obra.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('g-modificaciones', 1),
    ('e-precio-servicios', 2),
    ('o-plazo-obra', 3),
    ('g-declaraciones-partes', 4),
    ('g-divisibilidad', 5),
    ('g-notificaciones', 6),
    ('g-ley-aplicable', 7),
    ('integridad-contractual', 8)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('distrito_judicial', 2),
    ('monto_total_letras', 3),
    ('parte_primera_cedula', 4),
    ('parte_primera_domicilio', 5),
    ('parte_primera_nacionalidad', 6),
    ('parte_primera_nombre', 7),
    ('parte_segunda_cedula', 8),
    ('parte_segunda_domicilio', 9),
    ('parte_segunda_nacionalidad', 10),
    ('parte_segunda_nombre', 11),
    ('plazo_obra_dias', 12)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Garantía de Obra ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'construccion';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-garantia-de-obra';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-garantia-de-obra', 'Contrato de Garantía de Obra', 'Cobertura de vicios posteriores a la entrega.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('c-vicios-ocultos', 1),
    ('e-retencion-garantia', 2),
    ('o-recepcion-obra', 3),
    ('g-declaraciones-partes', 4),
    ('g-modificaciones', 5),
    ('g-divisibilidad', 6),
    ('g-notificaciones', 7),
    ('g-ley-aplicable', 8),
    ('integridad-contractual', 9)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('dias_recepcion_definitiva', 2),
    ('distrito_judicial', 3),
    ('parte_primera_cedula', 4),
    ('parte_primera_domicilio', 5),
    ('parte_primera_nacionalidad', 6),
    ('parte_primera_nombre', 7),
    ('parte_segunda_cedula', 8),
    ('parte_segunda_domicilio', 9),
    ('parte_segunda_nacionalidad', 10),
    ('parte_segunda_nombre', 11),
    ('retencion_porcentaje', 12)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Desarrollo de Software ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'tecnologia';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-desarrollo-de-software';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-desarrollo-de-software', 'Contrato de Desarrollo de Software', 'Desarrollo a medida con entregables por hitos.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('e-precio-servicios', 1),
    ('e-forma-pago', 2),
    ('e-impuestos-retenciones', 3),
    ('e-facturacion', 4),
    ('t-propiedad-codigo', 5),
    ('t-entrega-codigo-fuente', 6),
    ('t-aceptacion-entregables', 7),
    ('b-confidencialidad', 8),
    ('g-declaraciones-partes', 9),
    ('g-modificaciones', 10),
    ('g-divisibilidad', 11),
    ('g-notificaciones', 12),
    ('g-ley-aplicable', 13),
    ('integridad-contractual', 14)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('anios_confidencialidad', 1),
    ('ciudad_firma', 2),
    ('dias_aceptacion', 3),
    ('dias_pago', 4),
    ('distrito_judicial', 5),
    ('monto_total_letras', 6),
    ('parte_primera_cedula', 7),
    ('parte_primera_domicilio', 8),
    ('parte_primera_nacionalidad', 9),
    ('parte_primera_nombre', 10),
    ('parte_segunda_cedula', 11),
    ('parte_segunda_domicilio', 12),
    ('parte_segunda_nacionalidad', 13),
    ('parte_segunda_nombre', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Licencia de Software ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'tecnologia';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-licencia-de-software';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-licencia-de-software', 'Contrato de Licencia de Software', 'Autorización de uso de un programa.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('t-licencia-uso', 1),
    ('e-precio-servicios', 2),
    ('t-soporte-tecnico', 3),
    ('b-propiedad-intelectual', 4),
    ('g-declaraciones-partes', 5),
    ('g-modificaciones', 6),
    ('g-divisibilidad', 7),
    ('g-notificaciones', 8),
    ('g-ley-aplicable', 9),
    ('integridad-contractual', 10)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('cantidad_usuarios', 1),
    ('ciudad_firma', 2),
    ('distrito_judicial', 3),
    ('horario_soporte', 4),
    ('monto_total_letras', 5),
    ('parte_primera_cedula', 6),
    ('parte_primera_domicilio', 7),
    ('parte_primera_nacionalidad', 8),
    ('parte_primera_nombre', 9),
    ('parte_segunda_cedula', 10),
    ('parte_segunda_domicilio', 11),
    ('parte_segunda_nacionalidad', 12),
    ('parte_segunda_nombre', 13),
    ('titular_propiedad_intelectual', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato SaaS ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'tecnologia';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-saas';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-saas', 'Contrato SaaS', 'Software como servicio con suscripción mensual.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('t-licencia-uso', 1),
    ('t-soporte-tecnico', 2),
    ('t-nivel-servicio', 3),
    ('t-seguridad-informacion', 4),
    ('t-proteccion-datos', 5),
    ('t-disponibilidad', 6),
    ('t-portabilidad-datos', 7),
    ('g-renovacion-automatica', 8),
    ('g-declaraciones-partes', 9),
    ('g-modificaciones', 10),
    ('g-divisibilidad', 11),
    ('g-notificaciones', 12),
    ('g-ley-aplicable', 13),
    ('integridad-contractual', 14)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('cantidad_usuarios', 1),
    ('ciudad_firma', 2),
    ('disponibilidad_porcentaje', 3),
    ('distrito_judicial', 4),
    ('horario_soporte', 5),
    ('parte_primera_cedula', 6),
    ('parte_primera_domicilio', 7),
    ('parte_primera_nacionalidad', 8),
    ('parte_primera_nombre', 9),
    ('parte_segunda_cedula', 10),
    ('parte_segunda_domicilio', 11),
    ('parte_segunda_nacionalidad', 12),
    ('parte_segunda_nombre', 13)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Mantenimiento de Software ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'tecnologia';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-mantenimiento-de-software';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-mantenimiento-de-software', 'Contrato de Mantenimiento de Software', 'Corrección de errores y actualizaciones.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('t-soporte-tecnico', 1),
    ('t-nivel-servicio', 2),
    ('e-precio-servicios', 3),
    ('g-renovacion-automatica', 4),
    ('g-declaraciones-partes', 5),
    ('g-modificaciones', 6),
    ('g-divisibilidad', 7),
    ('g-notificaciones', 8),
    ('g-ley-aplicable', 9),
    ('integridad-contractual', 10)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('distrito_judicial', 2),
    ('horario_soporte', 3),
    ('monto_total_letras', 4),
    ('parte_primera_cedula', 5),
    ('parte_primera_domicilio', 6),
    ('parte_primera_nacionalidad', 7),
    ('parte_primera_nombre', 8),
    ('parte_segunda_cedula', 9),
    ('parte_segunda_domicilio', 10),
    ('parte_segunda_nacionalidad', 11),
    ('parte_segunda_nombre', 12)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Soporte Técnico ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'tecnologia';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-soporte-tecnico';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-soporte-tecnico', 'Contrato de Soporte Técnico', 'Asistencia técnica con niveles de servicio.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_clauses  WHERE template_id = v_template;
  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Comparecientes',
    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;

Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)
  RETURNING id INTO s_partes;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Firmas',
    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.


_______________________________          _______________________________
      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)
  RETURNING id INTO s_cierre;

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_cuerpo, 'MANDATORY', t.ord
  FROM (VALUES
    ('t-soporte-tecnico', 1),
    ('t-nivel-servicio', 2),
    ('e-forma-pago', 3),
    ('g-declaraciones-partes', 4),
    ('g-modificaciones', 5),
    ('g-divisibilidad', 6),
    ('g-notificaciones', 7),
    ('g-ley-aplicable', 8),
    ('integridad-contractual', 9)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('dias_pago', 2),
    ('distrito_judicial', 3),
    ('horario_soporte', 4),
    ('parte_primera_cedula', 5),
    ('parte_primera_domicilio', 6),
    ('parte_primera_nacionalidad', 7),
    ('parte_primera_nombre', 8),
    ('parte_segunda_cedula', 9),
    ('parte_segunda_domicilio', 10),
    ('parte_segunda_nacionalidad', 11),
    ('parte_segunda_nombre', 12)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

