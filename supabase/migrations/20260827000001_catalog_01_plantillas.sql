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

-- PARTE 1 de 10: plantillas 1–25. Requiere la parte 0.

-- ══════════════ PLANTILLAS ══════════════

-- ── Contrato de Alquiler de Local Comercial ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-alquiler-de-local-comercial';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-alquiler-de-local-comercial', 'Contrato de Alquiler de Local Comercial', 'Arrendamiento de local para actividad comercial, con uso comercial y reglamento de condominio.',
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
    ('e-precio-alquiler', 2),
    ('deposito-garantia', 3),
    ('mora-recargo', 4),
    ('vigencia-arrendamiento', 5),
    ('terminacion-anticipada', 6),
    ('i-entrega-inmueble', 7),
    ('g-devolucion-bien', 8),
    ('reparaciones-menores', 9),
    ('incumplimiento-desalojo', 10),
    ('uso-comercial', 11),
    ('i-reglamento-condominio', 12),
    ('i-servicios-excluidos', 13),
    ('remodelaciones', 14),
    ('subarrendamiento-prohibido', 15),
    ('g-declaraciones-partes', 16),
    ('g-modificaciones', 17),
    ('g-divisibilidad', 18),
    ('g-notificaciones', 19),
    ('g-ley-aplicable', 20),
    ('integridad-contractual', 21)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('destino_uso', 2),
    ('dia_pago', 3),
    ('distrito_judicial', 4),
    ('fecha_entrega_larga', 5),
    ('parte_primera_cedula', 6),
    ('parte_primera_domicilio', 7),
    ('parte_primera_nacionalidad', 8),
    ('parte_primera_nombre', 9),
    ('parte_segunda_cedula', 10),
    ('parte_segunda_domicilio', 11),
    ('parte_segunda_nacionalidad', 12),
    ('parte_segunda_nombre', 13),
    ('periodo_alquiler', 14),
    ('precio_alquiler_letras', 15)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Alquiler de Apartamento Amueblado ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-alquiler-de-apartamento-amueblado';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-alquiler-de-apartamento-amueblado', 'Contrato de Alquiler de Apartamento Amueblado', 'Arrendamiento de apartamento con mobiliario, inventario anexo y depósito reforzado.',
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
    ('e-precio-alquiler', 2),
    ('deposito-garantia', 3),
    ('mora-recargo', 4),
    ('vigencia-arrendamiento', 5),
    ('terminacion-anticipada', 6),
    ('i-entrega-inmueble', 7),
    ('g-devolucion-bien', 8),
    ('reparaciones-menores', 9),
    ('incumplimiento-desalojo', 10),
    ('uso-residencial', 11),
    ('inventario-mobiliario', 12),
    ('i-areas-comunes', 13),
    ('i-reglamento-condominio', 14),
    ('servicios-incluidos', 15),
    ('g-declaraciones-partes', 16),
    ('g-modificaciones', 17),
    ('g-divisibilidad', 18),
    ('g-notificaciones', 19),
    ('g-ley-aplicable', 20),
    ('integridad-contractual', 21)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('destino_uso', 2),
    ('dia_pago', 3),
    ('distrito_judicial', 4),
    ('fecha_entrega_larga', 5),
    ('parte_primera_cedula', 6),
    ('parte_primera_domicilio', 7),
    ('parte_primera_nacionalidad', 8),
    ('parte_primera_nombre', 9),
    ('parte_segunda_cedula', 10),
    ('parte_segunda_domicilio', 11),
    ('parte_segunda_nacionalidad', 12),
    ('parte_segunda_nombre', 13),
    ('periodo_alquiler', 14),
    ('precio_alquiler_letras', 15)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Alquiler de Habitación ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-alquiler-de-habitacion';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-alquiler-de-habitacion', 'Contrato de Alquiler de Habitación', 'Arrendamiento de habitación en vivienda compartida.',
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
    ('e-precio-alquiler', 2),
    ('deposito-garantia', 3),
    ('mora-recargo', 4),
    ('vigencia-arrendamiento', 5),
    ('terminacion-anticipada', 6),
    ('i-entrega-inmueble', 7),
    ('g-devolucion-bien', 8),
    ('reparaciones-menores', 9),
    ('incumplimiento-desalojo', 10),
    ('uso-residencial', 11),
    ('i-areas-comunes', 12),
    ('i-servicios-excluidos', 13),
    ('subarrendamiento-prohibido', 14),
    ('g-declaraciones-partes', 15),
    ('g-modificaciones', 16),
    ('g-divisibilidad', 17),
    ('g-notificaciones', 18),
    ('g-ley-aplicable', 19),
    ('integridad-contractual', 20)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('destino_uso', 2),
    ('dia_pago', 3),
    ('distrito_judicial', 4),
    ('fecha_entrega_larga', 5),
    ('parte_primera_cedula', 6),
    ('parte_primera_domicilio', 7),
    ('parte_primera_nacionalidad', 8),
    ('parte_primera_nombre', 9),
    ('parte_segunda_cedula', 10),
    ('parte_segunda_domicilio', 11),
    ('parte_segunda_nacionalidad', 12),
    ('parte_segunda_nombre', 13),
    ('periodo_alquiler', 14),
    ('precio_alquiler_letras', 15)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Alquiler Vacacional ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-alquiler-vacacional';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-alquiler-vacacional', 'Contrato de Alquiler Vacacional', 'Arrendamiento de corta estancia para uso turístico.',
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
    ('objeto-arrendamiento', 1),
    ('precio-renta', 2),
    ('deposito-garantia', 3),
    ('i-entrega-inmueble', 4),
    ('inventario-mobiliario', 5),
    ('devolucion-inmueble', 6),
    ('i-reglamento-condominio', 7),
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
    ('fecha_entrega_larga', 3),
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

-- ── Contrato de Alquiler de Villa ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-alquiler-de-villa';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-alquiler-de-villa', 'Contrato de Alquiler de Villa', 'Arrendamiento de villa residencial con áreas y servicios propios.',
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
    ('e-precio-alquiler', 2),
    ('deposito-garantia', 3),
    ('mora-recargo', 4),
    ('vigencia-arrendamiento', 5),
    ('terminacion-anticipada', 6),
    ('i-entrega-inmueble', 7),
    ('g-devolucion-bien', 8),
    ('reparaciones-menores', 9),
    ('incumplimiento-desalojo', 10),
    ('uso-residencial', 11),
    ('inventario-mobiliario', 12),
    ('mantenimiento-arrendador', 13),
    ('estacionamiento', 14),
    ('i-seguro-inmueble', 15),
    ('g-declaraciones-partes', 16),
    ('g-modificaciones', 17),
    ('g-divisibilidad', 18),
    ('g-notificaciones', 19),
    ('g-ley-aplicable', 20),
    ('integridad-contractual', 21)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('destino_uso', 2),
    ('dia_pago', 3),
    ('distrito_judicial', 4),
    ('fecha_entrega_larga', 5),
    ('parte_primera_cedula', 6),
    ('parte_primera_domicilio', 7),
    ('parte_primera_nacionalidad', 8),
    ('parte_primera_nombre', 9),
    ('parte_segunda_cedula', 10),
    ('parte_segunda_domicilio', 11),
    ('parte_segunda_nacionalidad', 12),
    ('parte_segunda_nombre', 13),
    ('periodo_alquiler', 14),
    ('precio_alquiler_letras', 15)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Alquiler de Oficina ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-alquiler-de-oficina';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-alquiler-de-oficina', 'Contrato de Alquiler de Oficina', 'Arrendamiento de espacio de oficina en edificio corporativo.',
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
    ('e-precio-alquiler', 2),
    ('deposito-garantia', 3),
    ('mora-recargo', 4),
    ('vigencia-arrendamiento', 5),
    ('terminacion-anticipada', 6),
    ('i-entrega-inmueble', 7),
    ('g-devolucion-bien', 8),
    ('reparaciones-menores', 9),
    ('incumplimiento-desalojo', 10),
    ('uso-comercial', 11),
    ('i-areas-comunes', 12),
    ('i-reglamento-condominio', 13),
    ('estacionamiento', 14),
    ('g-declaraciones-partes', 15),
    ('g-modificaciones', 16),
    ('g-divisibilidad', 17),
    ('g-notificaciones', 18),
    ('g-ley-aplicable', 19),
    ('integridad-contractual', 20)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('destino_uso', 2),
    ('dia_pago', 3),
    ('distrito_judicial', 4),
    ('fecha_entrega_larga', 5),
    ('parte_primera_cedula', 6),
    ('parte_primera_domicilio', 7),
    ('parte_primera_nacionalidad', 8),
    ('parte_primera_nombre', 9),
    ('parte_segunda_cedula', 10),
    ('parte_segunda_domicilio', 11),
    ('parte_segunda_nacionalidad', 12),
    ('parte_segunda_nombre', 13),
    ('periodo_alquiler', 14),
    ('precio_alquiler_letras', 15)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Alquiler de Nave Industrial ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-alquiler-de-nave-industrial';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-alquiler-de-nave-industrial', 'Contrato de Alquiler de Nave Industrial', 'Arrendamiento de nave o almacén para uso industrial o logístico.',
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
    ('e-precio-alquiler', 2),
    ('deposito-garantia', 3),
    ('mora-recargo', 4),
    ('vigencia-arrendamiento', 5),
    ('terminacion-anticipada', 6),
    ('i-entrega-inmueble', 7),
    ('g-devolucion-bien', 8),
    ('reparaciones-menores', 9),
    ('incumplimiento-desalojo', 10),
    ('uso-comercial', 11),
    ('i-seguro-inmueble', 12),
    ('remodelaciones', 13),
    ('i-servicios-excluidos', 14),
    ('g-declaraciones-partes', 15),
    ('g-modificaciones', 16),
    ('g-divisibilidad', 17),
    ('g-notificaciones', 18),
    ('g-ley-aplicable', 19),
    ('integridad-contractual', 20)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('destino_uso', 2),
    ('dia_pago', 3),
    ('distrito_judicial', 4),
    ('fecha_entrega_larga', 5),
    ('parte_primera_cedula', 6),
    ('parte_primera_domicilio', 7),
    ('parte_primera_nacionalidad', 8),
    ('parte_primera_nombre', 9),
    ('parte_segunda_cedula', 10),
    ('parte_segunda_domicilio', 11),
    ('parte_segunda_nacionalidad', 12),
    ('parte_segunda_nombre', 13),
    ('periodo_alquiler', 14),
    ('precio_alquiler_letras', 15)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Alquiler de Terreno ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-alquiler-de-terreno';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-alquiler-de-terreno', 'Contrato de Alquiler de Terreno', 'Arrendamiento de solar o parcela sin edificación.',
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
    ('objeto-arrendamiento', 1),
    ('i-descripcion-inmueble', 2),
    ('precio-renta', 3),
    ('vigencia-arrendamiento', 4),
    ('remodelaciones', 5),
    ('devolucion-inmueble', 6),
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
    ('certificado_titulo', 1),
    ('ciudad_firma', 2),
    ('descripcion_registral', 3),
    ('direccion_inmueble', 4),
    ('distrito_judicial', 5),
    ('parte_primera_cedula', 6),
    ('parte_primera_domicilio', 7),
    ('parte_primera_nacionalidad', 8),
    ('parte_primera_nombre', 9),
    ('parte_segunda_cedula', 10),
    ('parte_segunda_domicilio', 11),
    ('parte_segunda_nacionalidad', 12),
    ('parte_segunda_nombre', 13),
    ('superficie_metros', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Alquiler de Parqueo ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-alquiler-de-parqueo';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-alquiler-de-parqueo', 'Contrato de Alquiler de Parqueo', 'Arrendamiento de espacio de estacionamiento.',
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
    ('objeto-arrendamiento', 1),
    ('precio-renta', 2),
    ('vigencia-arrendamiento', 3),
    ('estacionamiento', 4),
    ('i-reglamento-condominio', 5),
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

-- ── Contrato de Compraventa de Inmueble ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-compraventa-de-inmueble';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-compraventa-de-inmueble', 'Contrato de Compraventa de Inmueble', 'Venta de inmueble con transferencia ante Registro de Títulos.',
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
    ('i-descripcion-inmueble', 2),
    ('i-garantia-saneamiento', 3),
    ('i-transferencia-propiedad', 4),
    ('e-forma-pago', 5),
    ('c-entrega-bien', 6),
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
    ('certificado_titulo', 1),
    ('ciudad_firma', 2),
    ('descripcion_bien', 3),
    ('descripcion_registral', 4),
    ('dias_pago', 5),
    ('direccion_inmueble', 6),
    ('distrito_judicial', 7),
    ('fecha_entrega_larga', 8),
    ('lugar_entrega', 9),
    ('parte_paga_transferencia', 10),
    ('parte_primera_cedula', 11),
    ('parte_primera_domicilio', 12),
    ('parte_primera_nacionalidad', 13),
    ('parte_primera_nombre', 14),
    ('parte_segunda_cedula', 15),
    ('parte_segunda_domicilio', 16),
    ('parte_segunda_nacionalidad', 17),
    ('parte_segunda_nombre', 18),
    ('precio_venta_letras', 19),
    ('superficie_metros', 20)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Promesa de Venta de Inmueble ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'promesa-de-venta-de-inmueble';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'promesa-de-venta-de-inmueble', 'Promesa de Venta de Inmueble', 'Compromiso de venta futura con arras y plazo para formalizar.',
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
    ('i-descripcion-inmueble', 1),
    ('e-pago-anticipado', 2),
    ('i-garantia-saneamiento', 3),
    ('i-transferencia-propiedad', 4),
    ('g-penalidad', 5),
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
    ('anticipo_porcentaje', 1),
    ('certificado_titulo', 2),
    ('ciudad_firma', 3),
    ('descripcion_registral', 4),
    ('direccion_inmueble', 5),
    ('distrito_judicial', 6),
    ('monto_penalidad_letras', 7),
    ('parte_paga_transferencia', 8),
    ('parte_primera_cedula', 9),
    ('parte_primera_domicilio', 10),
    ('parte_primera_nacionalidad', 11),
    ('parte_primera_nombre', 12),
    ('parte_segunda_cedula', 13),
    ('parte_segunda_domicilio', 14),
    ('parte_segunda_nacionalidad', 15),
    ('parte_segunda_nombre', 16),
    ('superficie_metros', 17)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Opción de Compra ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-opcion-de-compra';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-opcion-de-compra', 'Contrato de Opción de Compra', 'Derecho de compra dentro de un plazo determinado.',
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
    ('i-descripcion-inmueble', 1),
    ('e-pago-anticipado', 2),
    ('i-garantia-saneamiento', 3),
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
    ('certificado_titulo', 2),
    ('ciudad_firma', 3),
    ('descripcion_registral', 4),
    ('direccion_inmueble', 5),
    ('distrito_judicial', 6),
    ('monto_penalidad_letras', 7),
    ('parte_primera_cedula', 8),
    ('parte_primera_domicilio', 9),
    ('parte_primera_nacionalidad', 10),
    ('parte_primera_nombre', 11),
    ('parte_segunda_cedula', 12),
    ('parte_segunda_domicilio', 13),
    ('parte_segunda_nacionalidad', 14),
    ('parte_segunda_nombre', 15),
    ('superficie_metros', 16)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Corretaje Inmobiliario ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-corretaje-inmobiliario';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-corretaje-inmobiliario', 'Contrato de Corretaje Inmobiliario', 'Intermediación en la venta o alquiler de un inmueble.',
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
    ('b-exclusividad', 1),
    ('e-comision-porcentaje', 2),
    ('b-territorio', 3),
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
    ('comision_porcentaje', 2),
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
    ('parte_segunda_nombre', 13),
    ('territorio_contrato', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Administración de Inmuebles ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-administracion-de-inmuebles';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-administracion-de-inmuebles', 'Contrato de Administración de Inmuebles', 'Gestión de uno o varios inmuebles por cuenta del propietario.',
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
    ('e-reembolso-gastos', 3),
    ('g-renovacion-automatica', 4),
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

-- ── Contrato de Permuta de Inmuebles ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-permuta-de-inmuebles';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-permuta-de-inmuebles', 'Contrato de Permuta de Inmuebles', 'Intercambio de inmuebles entre dos partes.',
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
    ('i-descripcion-inmueble', 1),
    ('i-garantia-saneamiento', 2),
    ('i-transferencia-propiedad', 3),
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
    ('certificado_titulo', 1),
    ('ciudad_firma', 2),
    ('descripcion_registral', 3),
    ('direccion_inmueble', 4),
    ('distrito_judicial', 5),
    ('fecha_entrega_larga', 6),
    ('lugar_entrega', 7),
    ('parte_paga_transferencia', 8),
    ('parte_primera_cedula', 9),
    ('parte_primera_domicilio', 10),
    ('parte_primera_nacionalidad', 11),
    ('parte_primera_nombre', 12),
    ('parte_segunda_cedula', 13),
    ('parte_segunda_domicilio', 14),
    ('parte_segunda_nacionalidad', 15),
    ('parte_segunda_nombre', 16),
    ('superficie_metros', 17)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Arrendamiento con Opción a Compra ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-arrendamiento-con-opcion-a-compra';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-arrendamiento-con-opcion-a-compra', 'Contrato de Arrendamiento con Opción a Compra', 'Alquiler que permite adquirir el inmueble al final del plazo.',
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
    ('e-precio-alquiler', 2),
    ('deposito-garantia', 3),
    ('mora-recargo', 4),
    ('vigencia-arrendamiento', 5),
    ('terminacion-anticipada', 6),
    ('i-entrega-inmueble', 7),
    ('g-devolucion-bien', 8),
    ('reparaciones-menores', 9),
    ('incumplimiento-desalojo', 10),
    ('i-descripcion-inmueble', 11),
    ('i-transferencia-propiedad', 12),
    ('e-pago-anticipado', 13),
    ('g-declaraciones-partes', 14),
    ('g-modificaciones', 15),
    ('g-divisibilidad', 16),
    ('g-notificaciones', 17),
    ('g-ley-aplicable', 18),
    ('integridad-contractual', 19)
  ) AS t(slug, ord)
  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_partes, t.ord
  FROM (VALUES
    ('anticipo_porcentaje', 1),
    ('certificado_titulo', 2),
    ('ciudad_firma', 3),
    ('descripcion_registral', 4),
    ('destino_uso', 5),
    ('dia_pago', 6),
    ('direccion_inmueble', 7),
    ('distrito_judicial', 8),
    ('fecha_entrega_larga', 9),
    ('parte_paga_transferencia', 10),
    ('parte_primera_cedula', 11),
    ('parte_primera_domicilio', 12),
    ('parte_primera_nacionalidad', 13),
    ('parte_primera_nombre', 14),
    ('parte_segunda_cedula', 15),
    ('parte_segunda_domicilio', 16),
    ('parte_segunda_nacionalidad', 17),
    ('parte_segunda_nombre', 18),
    ('periodo_alquiler', 19),
    ('precio_alquiler_letras', 20),
    ('superficie_metros', 21)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Contrato de Subarrendamiento ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-subarrendamiento';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-subarrendamiento', 'Contrato de Subarrendamiento', 'Cesión parcial o total del uso por parte del arrendatario.',
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
    ('objeto-arrendamiento', 1),
    ('subarrendamiento-permitido', 2),
    ('precio-renta', 3),
    ('vigencia-arrendamiento', 4),
    ('devolucion-inmueble', 5),
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

-- ── Acta de Entrega de Inmueble ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'acta-de-entrega-de-inmueble';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'acta-de-entrega-de-inmueble', 'Acta de Entrega de Inmueble', 'Constancia del estado del inmueble al entregarlo.',
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
    ('i-entrega-inmueble', 1),
    ('inventario-mobiliario', 2),
    ('i-inspeccion-periodica', 3),
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

-- ── Acta de Devolución de Inmueble ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'acta-de-devolucion-de-inmueble';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'acta-de-devolucion-de-inmueble', 'Acta de Devolución de Inmueble', 'Constancia del estado al finalizar el arrendamiento.',
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
    ('devolucion-inmueble', 1),
    ('i-pintura-conservacion', 2),
    ('deposito-garantia', 3),
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

-- ── Recibo de Depósito de Garantía ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'recibo-de-deposito-de-garantia';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'recibo-de-deposito-de-garantia', 'Recibo de Depósito de Garantía', 'Comprobante de entrega del depósito.',
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
    ('deposito-garantia', 1),
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
    ('parte_segunda_nombre', 10)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Desalojo ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'carta-de-desalojo';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-de-desalojo', 'Carta de Desalojo', 'Requerimiento formal de desocupación del inmueble.',
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
    ('incumplimiento-desalojo', 1),
    ('devolucion-inmueble', 2),
    ('g-notificaciones', 3),
    ('g-declaraciones-partes', 4),
    ('g-modificaciones', 5),
    ('g-divisibilidad', 6),
    ('g-ley-aplicable', 7),
    ('integridad-contractual', 8)
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

-- ── Notificación de No Renovación ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'notificacion-de-no-renovacion';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'notificacion-de-no-renovacion', 'Notificación de No Renovación', 'Aviso de que el contrato no se prorrogará.',
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
    ('g-renovacion-automatica', 1),
    ('devolucion-inmueble', 2),
    ('g-notificaciones', 3),
    ('g-declaraciones-partes', 4),
    ('g-modificaciones', 5),
    ('g-divisibilidad', 6),
    ('g-ley-aplicable', 7),
    ('integridad-contractual', 8)
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

-- ── Notificación de Aumento de Renta ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'notificacion-de-aumento-de-renta';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'notificacion-de-aumento-de-renta', 'Notificación de Aumento de Renta', 'Comunicación del ajuste del precio del alquiler.',
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
    ('e-ajuste-precio-anual', 1),
    ('g-notificaciones', 2),
    ('g-declaraciones-partes', 3),
    ('g-modificaciones', 4),
    ('g-divisibilidad', 5),
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

-- ── Contrato de Mantenimiento de Inmueble ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-de-mantenimiento-de-inmueble';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'contrato-de-mantenimiento-de-inmueble', 'Contrato de Mantenimiento de Inmueble', 'Servicio periódico de mantenimiento de una propiedad.',
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
    ('mantenimiento-arrendador', 1),
    ('e-precio-servicios', 2),
    ('e-forma-pago', 3),
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

-- ── Reglamento Interno de Condominio ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_partes   UUID;
  s_cuerpo   UUID;
  s_cierre   UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';
  SELECT id INTO v_template FROM templates WHERE slug = 'reglamento-interno-de-condominio';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'reglamento-interno-de-condominio', 'Reglamento Interno de Condominio', 'Normas de convivencia y uso de áreas comunes.',
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
    ('i-reglamento-condominio', 1),
    ('i-areas-comunes', 2),
    ('estacionamiento', 3),
    ('mascotas', 4),
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

