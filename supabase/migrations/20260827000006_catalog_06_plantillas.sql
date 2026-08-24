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

-- PARTE 6 de 10: plantillas 126–150. Requiere la parte 0.

-- ── Contrato de Consultoría ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-consultoria';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-consultoria', 'Contrato de Consultoría', 'Asesoría especializada por proyecto.',
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
    ('b-relacion-independiente', 5),
    ('t-aceptacion-entregables', 6),
    ('b-propiedad-intelectual', 7),
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
    ('dias_aceptacion', 2),
    ('dias_pago', 3),
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
    ('titular_propiedad_intelectual', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Coaching Ejecutivo ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-coaching-ejecutivo';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-coaching-ejecutivo', 'Contrato de Coaching Ejecutivo', 'Acompañamiento profesional individual.',
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
    ('b-confidencialidad', 3),
    ('b-relacion-independiente', 4),
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
    ('anios_confidencialidad', 1),
    ('ciudad_firma', 2),
    ('dias_pago', 3),
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

-- ── Contrato de Capacitación ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-capacitacion';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-capacitacion', 'Contrato de Capacitación', 'Impartición de formación al personal.',
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
    ('m-entregables-creativos', 5),
    ('b-propiedad-intelectual', 6),
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
    ('cantidad_revisiones', 1),
    ('ciudad_firma', 2),
    ('descripcion_entregables', 3),
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
    ('parte_segunda_nombre', 14),
    ('titular_propiedad_intelectual', 15)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Traducción ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-traduccion';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-traduccion', 'Contrato de Traducción', 'Traducción de documentos.',
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
    ('b-confidencialidad', 3),
    ('e-penalidad-retraso', 4),
    ('b-propiedad-intelectual', 5),
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
    ('anios_confidencialidad', 1),
    ('ciudad_firma', 2),
    ('dias_pago', 3),
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
    ('penalidad_diaria_porcentaje', 14),
    ('titular_propiedad_intelectual', 15)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Interpretación ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-interpretacion';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-interpretacion', 'Contrato de Interpretación', 'Interpretación simultánea o consecutiva.',
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
    ('b-confidencialidad', 3),
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
    ('anios_confidencialidad', 1),
    ('ciudad_firma', 2),
    ('dias_pago', 3),
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

-- ── Contrato de Servicios Médicos ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-servicios-medicos';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-servicios-medicos', 'Contrato de Servicios Médicos', 'Prestación de servicios de salud.',
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
    ('b-confidencialidad', 2),
    ('t-proteccion-datos', 3),
    ('b-relacion-independiente', 4),
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
    ('anios_confidencialidad', 1),
    ('ciudad_firma', 2),
    ('distrito_judicial', 3),
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

-- ── Contrato de Servicios Odontológicos ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-servicios-odontologicos';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-servicios-odontologicos', 'Contrato de Servicios Odontológicos', 'Tratamiento dental y plan de pagos.',
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
    ('e-pago-cuotas', 2),
    ('b-confidencialidad', 3),
    ('t-proteccion-datos', 4),
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
    ('anios_confidencialidad', 1),
    ('cantidad_cuotas', 2),
    ('ciudad_firma', 3),
    ('dia_pago', 4),
    ('distrito_judicial', 5),
    ('monto_cuota_letras', 6),
    ('monto_total_letras', 7),
    ('parte_primera_cedula', 8),
    ('parte_primera_domicilio', 9),
    ('parte_primera_nacionalidad', 10),
    ('parte_primera_nombre', 11),
    ('parte_segunda_cedula', 12),
    ('parte_segunda_domicilio', 13),
    ('parte_segunda_nacionalidad', 14),
    ('parte_segunda_nombre', 15)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Servicios Veterinarios ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-servicios-veterinarios';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-servicios-veterinarios', 'Contrato de Servicios Veterinarios', 'Atención de animales.',
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
    ('b-relacion-independiente', 3),
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

-- ── Contrato de Servicios de Arquitectura ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-servicios-de-arquitectura';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-servicios-de-arquitectura', 'Contrato de Servicios de Arquitectura', 'Diseño arquitectónico y planos.',
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
    ('b-propiedad-intelectual', 5),
    ('t-aceptacion-entregables', 6),
    ('e-penalidad-retraso', 7),
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
    ('dias_aceptacion', 2),
    ('dias_pago', 3),
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
    ('penalidad_diaria_porcentaje', 14),
    ('titular_propiedad_intelectual', 15)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Servicios de Ingeniería ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-servicios-de-ingenieria';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-servicios-de-ingenieria', 'Contrato de Servicios de Ingeniería', 'Diseño y supervisión técnica.',
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
    ('b-propiedad-intelectual', 5),
    ('t-aceptacion-entregables', 6),
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
    ('dias_aceptacion', 2),
    ('dias_pago', 3),
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
    ('titular_propiedad_intelectual', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Servicios de Seguridad ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-servicios-de-seguridad';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-servicios-de-seguridad', 'Contrato de Servicios de Seguridad', 'Vigilancia y protección de instalaciones.',
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
    ('b-relacion-independiente', 3),
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
    ('dias_pago', 2),
    ('distrito_judicial', 3),
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

-- ── Contrato de Servicios de Limpieza ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-servicios-de-limpieza';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-servicios-de-limpieza', 'Contrato de Servicios de Limpieza', 'Limpieza periódica de instalaciones.',
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
    ('g-renovacion-automatica', 3),
    ('b-relacion-independiente', 4),
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

-- ── Contrato de Catering ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-catering';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-catering', 'Contrato de Catering', 'Servicio de alimentos para un evento.',
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
    ('e-pago-anticipado', 2),
    ('e-penalidad-retraso', 3),
    ('g-terminacion-mutuo-acuerdo', 4),
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
    ('anticipo_porcentaje', 1),
    ('ciudad_firma', 2),
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
    ('penalidad_diaria_porcentaje', 13)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Organización de Eventos ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-organizacion-de-eventos';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-organizacion-de-eventos', 'Contrato de Organización de Eventos', 'Planificación y ejecución de un evento.',
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
    ('e-pago-anticipado', 5),
    ('m-entregables-creativos', 6),
    ('e-penalidad-retraso', 7),
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
    ('anticipo_porcentaje', 1),
    ('cantidad_revisiones', 2),
    ('ciudad_firma', 3),
    ('descripcion_entregables', 4),
    ('dias_pago', 5),
    ('distrito_judicial', 6),
    ('monto_total_letras', 7),
    ('parte_primera_cedula', 8),
    ('parte_primera_domicilio', 9),
    ('parte_primera_nacionalidad', 10),
    ('parte_primera_nombre', 11),
    ('parte_segunda_cedula', 12),
    ('parte_segunda_domicilio', 13),
    ('parte_segunda_nacionalidad', 14),
    ('parte_segunda_nombre', 15),
    ('penalidad_diaria_porcentaje', 16)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Fotografía ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-fotografia';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-fotografia', 'Contrato de Fotografía', 'Servicio fotográfico y cesión de imágenes.',
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
    ('e-pago-anticipado', 2),
    ('m-derechos-imagen', 3),
    ('b-propiedad-intelectual', 4),
    ('m-entregables-creativos', 5),
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
    ('anios_uso_imagen', 1),
    ('anticipo_porcentaje', 2),
    ('cantidad_revisiones', 3),
    ('ciudad_firma', 4),
    ('descripcion_entregables', 5),
    ('distrito_judicial', 6),
    ('monto_total_letras', 7),
    ('parte_primera_cedula', 8),
    ('parte_primera_domicilio', 9),
    ('parte_primera_nacionalidad', 10),
    ('parte_primera_nombre', 11),
    ('parte_segunda_cedula', 12),
    ('parte_segunda_domicilio', 13),
    ('parte_segunda_nacionalidad', 14),
    ('parte_segunda_nombre', 15),
    ('titular_imagen', 16),
    ('titular_propiedad_intelectual', 17)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Video y Producción Audiovisual ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-video-y-produccion-audiovisual';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-video-y-produccion-audiovisual', 'Contrato de Video y Producción Audiovisual', 'Producción de piezas audiovisuales.',
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
    ('m-derechos-imagen', 5),
    ('b-propiedad-intelectual', 6),
    ('m-entregables-creativos', 7),
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
    ('anios_uso_imagen', 1),
    ('cantidad_revisiones', 2),
    ('ciudad_firma', 3),
    ('descripcion_entregables', 4),
    ('dias_pago', 5),
    ('distrito_judicial', 6),
    ('monto_total_letras', 7),
    ('parte_primera_cedula', 8),
    ('parte_primera_domicilio', 9),
    ('parte_primera_nacionalidad', 10),
    ('parte_primera_nombre', 11),
    ('parte_segunda_cedula', 12),
    ('parte_segunda_domicilio', 13),
    ('parte_segunda_nacionalidad', 14),
    ('parte_segunda_nombre', 15),
    ('titular_imagen', 16),
    ('titular_propiedad_intelectual', 17)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Servicios de Transporte de Personas ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-servicios-de-transporte-de-personas';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-servicios-de-transporte-de-personas', 'Contrato de Servicios de Transporte de Personas', 'Traslado de pasajeros.',
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
    ('b-relacion-independiente', 3),
    ('g-seguro-bienes', 4),
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
    ('monto_total_letras', 4),
    ('parte_primera_cedula', 5),
    ('parte_primera_domicilio', 6),
    ('parte_primera_nacionalidad', 7),
    ('parte_primera_nombre', 8),
    ('parte_responsable_seguro', 9),
    ('parte_segunda_cedula', 10),
    ('parte_segunda_domicilio', 11),
    ('parte_segunda_nacionalidad', 12),
    ('parte_segunda_nombre', 13)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Mensajería ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-mensajeria';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-mensajeria', 'Contrato de Mensajería', 'Entrega de documentos y paquetes.',
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
    ('c-entrega-bien', 2),
    ('e-penalidad-retraso', 3),
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
    ('distrito_judicial', 2),
    ('fecha_entrega_larga', 3),
    ('lugar_entrega', 4),
    ('monto_total_letras', 5),
    ('parte_primera_cedula', 6),
    ('parte_primera_domicilio', 7),
    ('parte_primera_nacionalidad', 8),
    ('parte_primera_nombre', 9),
    ('parte_segunda_cedula', 10),
    ('parte_segunda_domicilio', 11),
    ('parte_segunda_nacionalidad', 12),
    ('parte_segunda_nombre', 13),
    ('penalidad_diaria_porcentaje', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Servicios de Recursos Humanos ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-servicios-de-recursos-humanos';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-servicios-de-recursos-humanos', 'Contrato de Servicios de Recursos Humanos', 'Reclutamiento y gestión de personal.',
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
    ('b-confidencialidad', 5),
    ('t-proteccion-datos', 6),
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
    ('anios_confidencialidad', 1),
    ('ciudad_firma', 2),
    ('dias_pago', 3),
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

-- ── Contrato de Headhunting ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-headhunting';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-headhunting', 'Contrato de Headhunting', 'Búsqueda y selección de ejecutivos.',
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
    ('e-comision-porcentaje', 2),
    ('b-confidencialidad', 3),
    ('g-penalidad', 4),
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
    ('anios_confidencialidad', 1),
    ('ciudad_firma', 2),
    ('comision_porcentaje', 3),
    ('distrito_judicial', 4),
    ('monto_penalidad_letras', 5),
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

-- ── Contrato de Servicios de Diseño Gráfico ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-servicios-de-diseno-grafico';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-servicios-de-diseno-grafico', 'Contrato de Servicios de Diseño Gráfico', 'Diseño de piezas gráficas y marca.',
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
    ('m-entregables-creativos', 2),
    ('b-propiedad-intelectual', 3),
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
    ('cantidad_revisiones', 1),
    ('ciudad_firma', 2),
    ('descripcion_entregables', 3),
    ('dias_aceptacion', 4),
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
    ('titular_propiedad_intelectual', 15)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Redacción de Contenidos ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-redaccion-de-contenidos';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-redaccion-de-contenidos', 'Contrato de Redacción de Contenidos', 'Creación de textos por encargo.',
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
    ('m-entregables-creativos', 2),
    ('b-propiedad-intelectual', 3),
    ('t-uso-inteligencia-artificial', 4),
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
    ('cantidad_revisiones', 1),
    ('ciudad_firma', 2),
    ('descripcion_entregables', 3),
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
    ('titular_propiedad_intelectual', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Servicios de Mantenimiento Técnico ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-servicios-de-mantenimiento-tecnico';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-servicios-de-mantenimiento-tecnico', 'Contrato de Servicios de Mantenimiento Técnico', 'Mantenimiento de equipos e instalaciones.',
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
    ('t-nivel-servicio', 2),
    ('g-renovacion-automatica', 3),
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
    ('distrito_judicial', 2),
    ('monto_total_letras', 3),
    ('parte_primera_cedula', 4),
    ('parte_primera_domicilio', 5),
    ('parte_primera_nacionalidad', 6),
    ('parte_primera_nombre', 7),
    ('parte_segunda_cedula', 8),
    ('parte_segunda_domicilio', 9),
    ('parte_segunda_nacionalidad', 10),
    ('parte_segunda_nombre', 11)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Peritaje ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-peritaje';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-peritaje', 'Contrato de Peritaje', 'Dictamen técnico o valoración.',
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
    ('b-confidencialidad', 2),
    ('t-aceptacion-entregables', 3),
    ('b-relacion-independiente', 4),
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
    ('anios_confidencialidad', 1),
    ('ciudad_firma', 2),
    ('dias_aceptacion', 3),
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

-- ── Propuesta de Servicios Profesionales ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'servicios';
  SELECT id INTO v_template FROM templates WHERE slug = 'propuesta-de-servicios-profesionales';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'propuesta-de-servicios-profesionales', 'Propuesta de Servicios Profesionales', 'Oferta formal de servicios con alcance y precio.',
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
    ('m-entregables-creativos', 2),
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
    ('cantidad_revisiones', 1),
    ('ciudad_firma', 2),
    ('descripcion_entregables', 3),
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

