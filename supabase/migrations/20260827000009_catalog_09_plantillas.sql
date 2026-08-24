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

-- PARTE 9 de 10: plantillas 201–225. Requiere la parte 0.

-- ── Contrato de SEO y Posicionamiento ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'marketing';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-seo-y-posicionamiento';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-seo-y-posicionamiento', 'Contrato de SEO y Posicionamiento', 'Optimización para buscadores.',
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
    ('g-renovacion-automatica', 2),
    ('t-aceptacion-entregables', 3),
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
    ('dias_aceptacion', 2),
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

-- ── Contrato de Publicidad Digital ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'marketing';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-publicidad-digital';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-publicidad-digital', 'Contrato de Publicidad Digital', 'Gestión de campañas pagadas en línea.',
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
    ('m-entregables-creativos', 3),
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
    ('cantidad_revisiones', 1),
    ('ciudad_firma', 2),
    ('comision_porcentaje', 3),
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
    ('parte_segunda_nombre', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Investigación de Mercado ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'marketing';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-investigacion-de-mercado';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-investigacion-de-mercado', 'Contrato de Investigación de Mercado', 'Estudio de mercado y análisis.',
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
    ('parte_segunda_nombre', 13),
    ('titular_propiedad_intelectual', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Licencia de Contenido ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'marketing';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-licencia-de-contenido';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-licencia-de-contenido', 'Contrato de Licencia de Contenido', 'Autorización de uso de material creativo.',
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
    ('b-propiedad-intelectual', 1),
    ('b-territorio', 2),
    ('e-precio-servicios', 3),
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
    ('parte_segunda_nombre', 11),
    ('territorio_contrato', 12),
    ('titular_propiedad_intelectual', 13)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Ilustración ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'marketing';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-ilustracion';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-ilustracion', 'Contrato de Ilustración', 'Encargo de obra ilustrada.',
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
    ('m-entregables-creativos', 1),
    ('b-propiedad-intelectual', 2),
    ('e-pago-anticipado', 3),
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
    ('anticipo_porcentaje', 1),
    ('cantidad_revisiones', 2),
    ('ciudad_firma', 3),
    ('descripcion_entregables', 4),
    ('distrito_judicial', 5),
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

-- ── Contrato de Locución ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'marketing';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-locucion';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-locucion', 'Contrato de Locución', 'Grabación de voz para producción.',
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
    ('m-derechos-imagen', 1),
    ('e-precio-servicios', 2),
    ('b-propiedad-intelectual', 3),
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
    ('anios_uso_imagen', 1),
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
    ('titular_imagen', 13),
    ('titular_propiedad_intelectual', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Modelaje ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'marketing';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-modelaje';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-modelaje', 'Contrato de Modelaje', 'Participación de modelo en producción.',
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
    ('m-derechos-imagen', 1),
    ('e-precio-servicios', 2),
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
    ('anios_uso_imagen', 1),
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
    ('territorio_contrato', 13),
    ('titular_imagen', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Impresión ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'marketing';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-impresion';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-impresion', 'Contrato de Impresión', 'Producción de material impreso.',
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
    ('o-materiales', 4),
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

-- ── Contrato de Stand y Ferias ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'marketing';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-stand-y-ferias';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-stand-y-ferias', 'Contrato de Stand y Ferias', 'Participación en feria comercial.',
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
    ('g-objeto-uso-bien', 1),
    ('e-precio-servicios', 2),
    ('e-pago-anticipado', 3),
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
    ('anticipo_porcentaje', 1),
    ('ciudad_firma', 2),
    ('destino_uso', 3),
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

-- ── Acuerdo de Colaboración Creativa ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'marketing';
  SELECT id INTO v_template FROM templates WHERE slug = 'acuerdo-de-colaboracion-creativa';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'acuerdo-de-colaboracion-creativa', 'Acuerdo de Colaboración Creativa', 'Coautoría en un proyecto creativo.',
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
    ('b-propiedad-intelectual', 1),
    ('m-entregables-creativos', 2),
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
    ('cantidad_revisiones', 1),
    ('ciudad_firma', 2),
    ('descripcion_entregables', 3),
    ('distrito_judicial', 4),
    ('parte_primera_cedula', 5),
    ('parte_primera_domicilio', 6),
    ('parte_primera_nacionalidad', 7),
    ('parte_primera_nombre', 8),
    ('parte_segunda_cedula', 9),
    ('parte_segunda_domicilio', 10),
    ('parte_segunda_nacionalidad', 11),
    ('parte_segunda_nombre', 12),
    ('titular_propiedad_intelectual', 13)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Compraventa de Bienes Muebles ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'comercio';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-compraventa-de-bienes-muebles';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-compraventa-de-bienes-muebles', 'Contrato de Compraventa de Bienes Muebles', 'Venta de bienes con entrega y garantía.',
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
    ('c-entrega-bien', 2),
    ('c-vicios-ocultos', 3),
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
    ('ciudad_firma', 1),
    ('descripcion_bien', 2),
    ('dias_pago', 3),
    ('distrito_judicial', 4),
    ('fecha_entrega_larga', 5),
    ('lugar_entrega', 6),
    ('parte_primera_cedula', 7),
    ('parte_primera_domicilio', 8),
    ('parte_primera_nacionalidad', 9),
    ('parte_primera_nombre', 10),
    ('parte_segunda_cedula', 11),
    ('parte_segunda_domicilio', 12),
    ('parte_segunda_nacionalidad', 13),
    ('parte_segunda_nombre', 14),
    ('precio_venta_letras', 15)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Compraventa a Plazos ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'comercio';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-compraventa-a-plazos';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-compraventa-a-plazos', 'Contrato de Compraventa a Plazos', 'Venta con pago fraccionado.',
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
    ('e-pago-cuotas', 2),
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

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('cantidad_cuotas', 1),
    ('ciudad_firma', 2),
    ('descripcion_bien', 3),
    ('descripcion_garantia', 4),
    ('dia_pago', 5),
    ('distrito_judicial', 6),
    ('interes_mora_porcentaje', 7),
    ('monto_cuota_letras', 8),
    ('parte_primera_cedula', 9),
    ('parte_primera_domicilio', 10),
    ('parte_primera_nacionalidad', 11),
    ('parte_primera_nombre', 12),
    ('parte_segunda_cedula', 13),
    ('parte_segunda_domicilio', 14),
    ('parte_segunda_nacionalidad', 15),
    ('parte_segunda_nombre', 16),
    ('precio_venta_letras', 17)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Compraventa con Reserva de Dominio ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'comercio';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-compraventa-con-reserva-de-dominio';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-compraventa-con-reserva-de-dominio', 'Contrato de Compraventa con Reserva de Dominio', 'La propiedad se transfiere al pagar la última cuota.',
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
    ('e-pago-cuotas', 2),
    ('p-garantia-prestamo', 3),
    ('c-entrega-bien', 4),
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
    ('cantidad_cuotas', 1),
    ('ciudad_firma', 2),
    ('descripcion_bien', 3),
    ('descripcion_garantia', 4),
    ('dia_pago', 5),
    ('distrito_judicial', 6),
    ('fecha_entrega_larga', 7),
    ('lugar_entrega', 8),
    ('monto_cuota_letras', 9),
    ('parte_primera_cedula', 10),
    ('parte_primera_domicilio', 11),
    ('parte_primera_nacionalidad', 12),
    ('parte_primera_nombre', 13),
    ('parte_segunda_cedula', 14),
    ('parte_segunda_domicilio', 15),
    ('parte_segunda_nacionalidad', 16),
    ('parte_segunda_nombre', 17),
    ('precio_venta_letras', 18)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Compraventa Internacional ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'comercio';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-compraventa-internacional';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-compraventa-internacional', 'Contrato de Compraventa Internacional', 'Operación de comercio exterior.',
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
    ('c-entrega-bien', 2),
    ('e-moneda-pago', 3),
    ('g-arbitraje', 4),
    ('g-fuerza-mayor', 5),
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
    ('descripcion_bien', 2),
    ('distrito_judicial', 3),
    ('fecha_entrega_larga', 4),
    ('lugar_entrega', 5),
    ('moneda_contrato', 6),
    ('parte_primera_cedula', 7),
    ('parte_primera_domicilio', 8),
    ('parte_primera_nacionalidad', 9),
    ('parte_primera_nombre', 10),
    ('parte_segunda_cedula', 11),
    ('parte_segunda_domicilio', 12),
    ('parte_segunda_nacionalidad', 13),
    ('parte_segunda_nombre', 14),
    ('precio_venta_letras', 15)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Permuta de Bienes ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'comercio';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-permuta-de-bienes';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-permuta-de-bienes', 'Contrato de Permuta de Bienes', 'Intercambio de bienes muebles.',
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
    ('c-entrega-bien', 2),
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
    ('descripcion_bien', 2),
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
    ('precio_venta_letras', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Venta al Por Mayor ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'comercio';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-venta-al-por-mayor';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-venta-al-por-mayor', 'Contrato de Venta al Por Mayor', 'Suministro mayorista con descuentos.',
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
    ('e-forma-pago', 2),
    ('c-entrega-bien', 3),
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
    ('descripcion_bien', 2),
    ('dias_pago', 3),
    ('distrito_judicial', 4),
    ('fecha_entrega_larga', 5),
    ('lugar_entrega', 6),
    ('parte_primera_cedula', 7),
    ('parte_primera_domicilio', 8),
    ('parte_primera_nacionalidad', 9),
    ('parte_primera_nombre', 10),
    ('parte_segunda_cedula', 11),
    ('parte_segunda_domicilio', 12),
    ('parte_segunda_nacionalidad', 13),
    ('parte_segunda_nombre', 14),
    ('penalidad_diaria_porcentaje', 15),
    ('precio_venta_letras', 16)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Orden de Compra ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'comercio';
  SELECT id INTO v_template FROM templates WHERE slug = 'orden-de-compra';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'orden-de-compra', 'Orden de Compra', 'Pedido formal de bienes o servicios.',
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
    ('c-entrega-bien', 2),
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
    ('descripcion_bien', 2),
    ('dias_pago', 3),
    ('distrito_judicial', 4),
    ('fecha_entrega_larga', 5),
    ('lugar_entrega', 6),
    ('parte_primera_cedula', 7),
    ('parte_primera_domicilio', 8),
    ('parte_primera_nacionalidad', 9),
    ('parte_primera_nombre', 10),
    ('parte_segunda_cedula', 11),
    ('parte_segunda_domicilio', 12),
    ('parte_segunda_nacionalidad', 13),
    ('parte_segunda_nombre', 14),
    ('precio_venta_letras', 15)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Factura Proforma ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'comercio';
  SELECT id INTO v_template FROM templates WHERE slug = 'factura-proforma';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'factura-proforma', 'Factura Proforma', 'Cotización formal previa a la venta.',
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
    ('e-impuestos-retenciones', 2),
    ('c-entrega-bien', 3),
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
    ('parte_segunda_nombre', 13)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Garantía de Producto ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'comercio';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-garantia-de-producto';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-garantia-de-producto', 'Contrato de Garantía de Producto', 'Cobertura de defectos de fabricación.',
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
    ('t-soporte-tecnico', 2),
    ('e-reembolso-gastos', 3),
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
    ('horario_soporte', 3),
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

-- ── Política de Devoluciones ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'comercio';
  SELECT id INTO v_template FROM templates WHERE slug = 'politica-de-devoluciones';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'politica-de-devoluciones', 'Política de Devoluciones', 'Condiciones para devolver un producto.',
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
    ('e-reembolso-gastos', 2),
    ('c-entrega-bien', 3),
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

-- ── Contrato de Comisión Mercantil ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'comercio';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-comision-mercantil';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-comision-mercantil', 'Contrato de Comisión Mercantil', 'Venta por cuenta de un tercero.',
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
    ('b-representacion', 2),
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
    ('comision_porcentaje', 2),
    ('distrito_judicial', 3),
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

-- ── Contrato de Exportación ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'comercio';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-exportacion';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-exportacion', 'Contrato de Exportación', 'Venta de bienes al exterior.',
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
    ('c-entrega-bien', 2),
    ('e-moneda-pago', 3),
    ('g-fuerza-mayor', 4),
    ('g-arbitraje', 5),
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
    ('descripcion_bien', 2),
    ('distrito_judicial', 3),
    ('fecha_entrega_larga', 4),
    ('lugar_entrega', 5),
    ('moneda_contrato', 6),
    ('parte_primera_cedula', 7),
    ('parte_primera_domicilio', 8),
    ('parte_primera_nacionalidad', 9),
    ('parte_primera_nombre', 10),
    ('parte_segunda_cedula', 11),
    ('parte_segunda_domicilio', 12),
    ('parte_segunda_nacionalidad', 13),
    ('parte_segunda_nombre', 14),
    ('precio_venta_letras', 15)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Importación ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'comercio';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-importacion';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-importacion', 'Contrato de Importación', 'Compra de bienes del exterior.',
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
    ('c-entrega-bien', 2),
    ('e-moneda-pago', 3),
    ('e-impuestos-retenciones', 4),
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
    ('descripcion_bien', 2),
    ('distrito_judicial', 3),
    ('fecha_entrega_larga', 4),
    ('lugar_entrega', 5),
    ('moneda_contrato', 6),
    ('parte_primera_cedula', 7),
    ('parte_primera_domicilio', 8),
    ('parte_primera_nacionalidad', 9),
    ('parte_primera_nombre', 10),
    ('parte_segunda_cedula', 11),
    ('parte_segunda_domicilio', 12),
    ('parte_segunda_nacionalidad', 13),
    ('parte_segunda_nombre', 14),
    ('precio_venta_letras', 15)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Almacenaje ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'comercio';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-almacenaje';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-almacenaje', 'Contrato de Almacenaje', 'Depósito de mercancía en almacén.',
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
    ('e-deposito-general', 1),
    ('e-precio-servicios', 2),
    ('g-seguro-bienes', 3),
    ('c-entrega-bien', 4),
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
    ('deposito_letras', 2),
    ('distrito_judicial', 3),
    ('fecha_entrega_larga', 4),
    ('lugar_entrega', 5),
    ('monto_total_letras', 6),
    ('parte_primera_cedula', 7),
    ('parte_primera_domicilio', 8),
    ('parte_primera_nacionalidad', 9),
    ('parte_primera_nombre', 10),
    ('parte_responsable_seguro', 11),
    ('parte_segunda_cedula', 12),
    ('parte_segunda_domicilio', 13),
    ('parte_segunda_nacionalidad', 14),
    ('parte_segunda_nombre', 15)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Recibo de Pago ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'comercio';
  SELECT id INTO v_template FROM templates WHERE slug = 'recibo-de-pago';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'recibo-de-pago', 'Recibo de Pago', 'Comprobante de un pago recibido.',
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
    ('e-forma-pago', 1),
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
    ('dias_pago', 2),
    ('distrito_judicial', 3),
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

