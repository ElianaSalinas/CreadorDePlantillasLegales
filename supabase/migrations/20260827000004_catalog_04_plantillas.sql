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

-- PARTE 4 de 10: plantillas 76–100. Requiere la parte 0.

-- ── Acta de Consejo de Administración ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'empresarial';
  SELECT id INTO v_template FROM templates WHERE slug = 'acta-de-consejo-de-administracion';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'acta-de-consejo-de-administracion', 'Acta de Consejo de Administración', 'Registro de decisiones del órgano de administración.',
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
    ('g-declaraciones-partes', 1),
    ('g-encabezados', 2),
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
    ('parte_segunda_nombre', 10)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Gerencia ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'empresarial';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-gerencia';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-gerencia', 'Contrato de Gerencia', 'Designación y condiciones de un gerente.',
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
    ('b-representacion', 1),
    ('l-salario', 2),
    ('b-confidencialidad', 3),
    ('b-no-competencia', 4),
    ('l-terminacion-laboral', 5),
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
    ('distrito_judicial', 3),
    ('meses_no_competencia', 4),
    ('parte_primera_cedula', 5),
    ('parte_primera_domicilio', 6),
    ('parte_primera_nacionalidad', 7),
    ('parte_primera_nombre', 8),
    ('parte_segunda_cedula', 9),
    ('parte_segunda_domicilio', 10),
    ('parte_segunda_nacionalidad', 11),
    ('parte_segunda_nombre', 12),
    ('salario_letras', 13)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Consultoría Empresarial ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'empresarial';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-consultoria-empresarial';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-consultoria-empresarial', 'Contrato de Consultoría Empresarial', 'Asesoría estratégica a una empresa.',
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
    ('t-aceptacion-entregables', 5),
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

-- ── Contrato de Auditoría ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'empresarial';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-auditoria';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-auditoria', 'Contrato de Auditoría', 'Revisión independiente de estados financieros.',
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

-- ── Contrato de Outsourcing ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'empresarial';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-outsourcing';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-outsourcing', 'Contrato de Outsourcing', 'Externalización de un proceso de negocio.',
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
    ('b-confidencialidad', 3),
    ('t-proteccion-datos', 4),
    ('b-relacion-independiente', 5),
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

-- ── Contrato de Maquila ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'empresarial';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-maquila';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-maquila', 'Contrato de Maquila', 'Fabricación por encargo.',
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
    ('e-precio-servicios', 2),
    ('e-penalidad-retraso', 3),
    ('b-propiedad-intelectual', 4),
    ('b-confidencialidad', 5),
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
    ('distrito_judicial', 3),
    ('fecha_entrega_larga', 4),
    ('lugar_entrega', 5),
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
    ('titular_propiedad_intelectual', 16)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

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
    ('distrito_judicial', 2),
    ('fecha_entrega_larga', 3),
    ('lugar_entrega', 4),
    ('monto_total_letras', 5),
    ('parte_primera_cedula', 6),
    ('parte_primera_domicilio', 7),
    ('parte_primera_nacionalidad', 8),
    ('parte_primera_nombre', 9),
    ('parte_responsable_seguro', 10),
    ('parte_segunda_cedula', 11),
    ('parte_segunda_domicilio', 12),
    ('parte_segunda_nacionalidad', 13),
    ('parte_segunda_nombre', 14),
    ('penalidad_diaria_porcentaje', 15)
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

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('comision_porcentaje', 2),
    ('distrito_judicial', 3),
    ('parte_primera_cedula', 4),
    ('parte_primera_domicilio', 5),
    ('parte_primera_nacionalidad', 6),
    ('parte_primera_nombre', 7),
    ('parte_segunda_cedula', 8),
    ('parte_segunda_domicilio', 9),
    ('parte_segunda_nacionalidad', 10),
    ('parte_segunda_nombre', 11),
    ('territorio_contrato', 12)
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

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('disponibilidad_porcentaje', 2),
    ('distrito_judicial', 3),
    ('monto_penalidad_letras', 4),
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

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('anios_uso_imagen', 1),
    ('cantidad_revisiones', 2),
    ('ciudad_firma', 3),
    ('descripcion_entregables', 4),
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
    ('titular_imagen', 15),
    ('titular_propiedad_intelectual', 16)
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

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('anios_uso_imagen', 1),
    ('ciudad_firma', 2),
    ('distrito_judicial', 3),
    ('monto_total_letras', 4),
    ('objeto_exclusividad', 5),
    ('parte_exclusiva', 6),
    ('parte_primera_cedula', 7),
    ('parte_primera_domicilio', 8),
    ('parte_primera_nacionalidad', 9),
    ('parte_primera_nombre', 10),
    ('parte_segunda_cedula', 11),
    ('parte_segunda_domicilio', 12),
    ('parte_segunda_nacionalidad', 13),
    ('parte_segunda_nombre', 14),
    ('titular_imagen', 15),
    ('titular_propiedad_intelectual', 16)
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

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('anios_confidencialidad', 1),
    ('ciudad_firma', 2),
    ('distrito_judicial', 3),
    ('objeto_exclusividad', 4),
    ('parte_exclusiva', 5),
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

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('descripcion_bien', 2),
    ('dias_pago', 3),
    ('distrito_judicial', 4),
    ('parte_primera_cedula', 5),
    ('parte_primera_domicilio', 6),
    ('parte_primera_nacionalidad', 7),
    ('parte_primera_nombre', 8),
    ('parte_segunda_cedula', 9),
    ('parte_segunda_domicilio', 10),
    ('parte_segunda_nacionalidad', 11),
    ('parte_segunda_nombre', 12),
    ('precio_venta_letras', 13)
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

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('anios_confidencialidad', 1),
    ('ciudad_firma', 2),
    ('dias_pago', 3),
    ('distrito_judicial', 4),
    ('meses_no_competencia', 5),
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
    ('parte_segunda_nombre', 10)
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

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('distrito_judicial', 2),
    ('horario_trabajo', 3),
    ('horas_semanales', 4),
    ('parte_primera_cedula', 5),
    ('parte_primera_domicilio', 6),
    ('parte_primera_nacionalidad', 7),
    ('parte_primera_nombre', 8),
    ('parte_segunda_cedula', 9),
    ('parte_segunda_domicilio', 10),
    ('parte_segunda_nacionalidad', 11),
    ('parte_segunda_nombre', 12),
    ('salario_letras', 13)
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

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('distrito_judicial', 2),
    ('horario_trabajo', 3),
    ('horas_semanales', 4),
    ('parte_primera_cedula', 5),
    ('parte_primera_domicilio', 6),
    ('parte_primera_nacionalidad', 7),
    ('parte_primera_nombre', 8),
    ('parte_segunda_cedula', 9),
    ('parte_segunda_domicilio', 10),
    ('parte_segunda_nacionalidad', 11),
    ('parte_segunda_nombre', 12),
    ('salario_letras', 13)
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

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('distrito_judicial', 2),
    ('horario_trabajo', 3),
    ('horas_semanales', 4),
    ('parte_primera_cedula', 5),
    ('parte_primera_domicilio', 6),
    ('parte_primera_nacionalidad', 7),
    ('parte_primera_nombre', 8),
    ('parte_segunda_cedula', 9),
    ('parte_segunda_domicilio', 10),
    ('parte_segunda_nacionalidad', 11),
    ('parte_segunda_nombre', 12),
    ('plazo_obra_dias', 13),
    ('salario_letras', 14)
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

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('distrito_judicial', 2),
    ('horario_trabajo', 3),
    ('horas_semanales', 4),
    ('parte_primera_cedula', 5),
    ('parte_primera_domicilio', 6),
    ('parte_primera_nacionalidad', 7),
    ('parte_primera_nombre', 8),
    ('parte_segunda_cedula', 9),
    ('parte_segunda_domicilio', 10),
    ('parte_segunda_nacionalidad', 11),
    ('parte_segunda_nombre', 12),
    ('salario_letras', 13)
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

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('distrito_judicial', 2),
    ('horario_trabajo', 3),
    ('horas_semanales', 4),
    ('parte_primera_cedula', 5),
    ('parte_primera_domicilio', 6),
    ('parte_primera_nacionalidad', 7),
    ('parte_primera_nombre', 8),
    ('parte_segunda_cedula', 9),
    ('parte_segunda_domicilio', 10),
    ('parte_segunda_nacionalidad', 11),
    ('parte_segunda_nombre', 12),
    ('salario_letras', 13)
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

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('dias_presenciales', 2),
    ('distrito_judicial', 3),
    ('horario_trabajo', 4),
    ('horas_semanales', 5),
    ('parte_primera_cedula', 6),
    ('parte_primera_domicilio', 7),
    ('parte_primera_nacionalidad', 8),
    ('parte_primera_nombre', 9),
    ('parte_segunda_cedula', 10),
    ('parte_segunda_domicilio', 11),
    ('parte_segunda_nacionalidad', 12),
    ('parte_segunda_nombre', 13),
    ('salario_letras', 14)
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

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('comision_porcentaje', 2),
    ('distrito_judicial', 3),
    ('horario_trabajo', 4),
    ('horas_semanales', 5),
    ('parte_primera_cedula', 6),
    ('parte_primera_domicilio', 7),
    ('parte_primera_nacionalidad', 8),
    ('parte_primera_nombre', 9),
    ('parte_segunda_cedula', 10),
    ('parte_segunda_domicilio', 11),
    ('parte_segunda_nacionalidad', 12),
    ('parte_segunda_nombre', 13),
    ('salario_letras', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Pasantía ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'laboral';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-pasantia';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-pasantia', 'Contrato de Pasantía', 'Formación práctica de estudiante en la empresa.',
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
    ('l-jornada', 1),
    ('l-confidencialidad', 2),
    ('l-equipos-trabajo', 3),
    ('vigencia-arrendamiento', 4),
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
    ('horario_trabajo', 3),
    ('horas_semanales', 4),
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

-- ── Contrato de Aprendizaje ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'laboral';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-aprendizaje';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-aprendizaje', 'Contrato de Aprendizaje', 'Formación laboral con componente educativo.',
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
    ('l-jornada', 1),
    ('l-salario', 2),
    ('l-confidencialidad', 3),
    ('vigencia-arrendamiento', 4),
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
    ('horario_trabajo', 3),
    ('horas_semanales', 4),
    ('parte_primera_cedula', 5),
    ('parte_primera_domicilio', 6),
    ('parte_primera_nacionalidad', 7),
    ('parte_primera_nombre', 8),
    ('parte_segunda_cedula', 9),
    ('parte_segunda_domicilio', 10),
    ('parte_segunda_nacionalidad', 11),
    ('parte_segunda_nombre', 12),
    ('salario_letras', 13)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Trabajo Doméstico ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'laboral';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-trabajo-domestico';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-trabajo-domestico', 'Contrato de Trabajo Doméstico', 'Servicio doméstico en hogar particular.',
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
    ('l-salario', 1),
    ('l-jornada', 2),
    ('l-vacaciones', 3),
    ('l-terminacion-laboral', 4),
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
    ('horario_trabajo', 3),
    ('horas_semanales', 4),
    ('parte_primera_cedula', 5),
    ('parte_primera_domicilio', 6),
    ('parte_primera_nacionalidad', 7),
    ('parte_primera_nombre', 8),
    ('parte_segunda_cedula', 9),
    ('parte_segunda_domicilio', 10),
    ('parte_segunda_nacionalidad', 11),
    ('parte_segunda_nombre', 12),
    ('salario_letras', 13)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

