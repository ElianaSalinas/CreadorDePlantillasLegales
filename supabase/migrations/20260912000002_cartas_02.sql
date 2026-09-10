-- ==========================================================
-- SA&VE Comercial, S.R.L. — Punta Cana, República Dominicana
-- CATÁLOGO DE CARTAS · GENERADO AUTOMÁTICAMENTE
--
-- NO EDITAR A MANO. Este archivo lo produce:
--   npm run cartas:build
-- a partir de scripts/catalog/cartas.ts
--
-- ⚠️  32 cartas, TODAS en estado DRAFT.
--     Ningún usuario las ve hasta que un abogado dominicano las
--     revise y las publique. Al final hay instrucciones.
--
-- Se puede ejecutar más de una vez sin duplicar nada.
-- ==========================================================

-- PARTE 2 de 2: cartas 21–32. Requiere la parte 0.

-- ── Carta de No Objeción para Viaje ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-migracion';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-migracion';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-no-objecion-viaje';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-no-objecion-viaje', 'Carta de No Objeción para Viaje', 'La empresa o institución declara no tener objeción a que la persona viaje, y confirma su vínculo y su regreso.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

A QUIEN PUEDA INTERESAR:

Asunto: No objeción para viaje de {{empleado_nombre}}', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Por medio de la presente, {{empresa_nombre}}, RNC {{empresa_rnc}}, con domicilio social en {{empresa_domicilio}}, HACE CONSTAR que:

El señor(a) {{empleado_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{empleado_cedula}}, labora en esta empresa desde el {{fecha_ingreso_larga}} en el cargo de {{cargo_ocupado}}.

Esta empresa NO TIENE OBJECIÓN a que realice un viaje a {{pais_destino}} entre el {{fecha_desde_larga}} y el {{fecha_hasta_larga}}, por motivo de {{motivo_viaje}}.

Se hace constar igualmente que su puesto de trabajo le será conservado y que se espera su reintegro a sus funciones el {{fecha_reintegro_larga}}.

La presente se expide a solicitud de la parte interesada, para los fines que estime convenientes.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
{{firmante_cargo}}
{{empresa_nombre}}
RNC {{empresa_rnc}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('cargo_ocupado', 1),
    ('ciudad_firma', 2),
    ('empleado_cedula', 3),
    ('empleado_nombre', 4),
    ('empresa_domicilio', 5),
    ('empresa_nombre', 6),
    ('empresa_rnc', 7),
    ('fecha_carta', 8),
    ('fecha_desde', 9),
    ('fecha_hasta', 10),
    ('fecha_ingreso', 11),
    ('fecha_reintegro', 12),
    ('firmante_cargo', 13),
    ('firmante_cedula', 14),
    ('firmante_correo', 15),
    ('firmante_nombre', 16),
    ('firmante_telefono', 17),
    ('motivo_viaje', 18),
    ('pais_destino', 19)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Autorización de Viaje de Menor ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-familia';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-familia';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-autorizacion-viaje-menor';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-autorizacion-viaje-menor', 'Autorización de Viaje de Menor', 'Los padres autorizan a que un menor de edad viaje, solo o acompañado por un tercero.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2","referencia_legal":"Ley núm. 136-03, Código para el Sistema de Protección y los Derechos Fundamentales de Niños, Niñas y Adolescentes"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_institucion}}
{{destinatario_cargo}}
Ciudad.-

Asunto: Autorización de viaje del menor {{menor_nombre}}', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Nosotros, {{padre_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{padre_cedula}}, y {{madre_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{madre_cedula}}, en nuestra calidad de padres del menor {{menor_nombre}}, nacido(a) el {{menor_fecha_nacimiento_larga}}, portador(a) del acta de nacimiento núm. {{menor_acta_nacimiento}} y del pasaporte núm. {{menor_pasaporte}}, por medio de la presente AUTORIZAMOS:

Que nuestro hijo(a) viaje a {{pais_destino}}, saliendo el {{fecha_salida_larga}} y regresando el {{fecha_regreso_larga}}, {{modalidad_viaje}}.

Persona responsable durante el viaje: {{acompanante_nombre}}, portador(a) de {{acompanante_documento}} núm. {{acompanante_documento_numero}}, con quien nos une el siguiente vínculo: {{vinculo_acompanante}}.

Lugar de alojamiento: {{lugar_alojamiento}}.

Autorizamos igualmente a que, en caso de emergencia médica y ante la imposibilidad de contactarnos, se le brinde la atención de urgencia que su salud requiera.

Podemos ser localizados en los teléfonos {{padre_telefono}} y {{madre_telefono}}.

ADVERTENCIA: la salida del país de un menor de edad exige autorización otorgada conforme a la ley y su presentación ante las autoridades migratorias; en la práctica se requiere que esté legalizada ante notario y, con frecuencia, apostillada. Este documento es el borrador del texto: confirme la formalidad exigida antes de viajar.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('acompanante_documento', 1),
    ('acompanante_documento_numero', 2),
    ('acompanante_nombre', 3),
    ('ciudad_firma', 4),
    ('destinatario_cargo', 5),
    ('destinatario_institucion', 6),
    ('fecha_carta', 7),
    ('fecha_regreso', 8),
    ('fecha_salida', 9),
    ('firmante_cedula', 10),
    ('firmante_correo', 11),
    ('firmante_nombre', 12),
    ('firmante_telefono', 13),
    ('lugar_alojamiento', 14),
    ('madre_cedula', 15),
    ('madre_nombre', 16),
    ('madre_telefono', 17),
    ('menor_acta_nacimiento', 18),
    ('menor_fecha_nacimiento', 19),
    ('menor_nombre', 20),
    ('menor_pasaporte', 21),
    ('modalidad_viaje', 22),
    ('padre_cedula', 23),
    ('padre_nombre', 24),
    ('padre_telefono', 25),
    ('pais_destino', 26),
    ('vinculo_acompanante', 27)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Consentimiento del Otro Progenitor ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-familia';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-familia';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-consentimiento-progenitor';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-consentimiento-progenitor', 'Consentimiento del Otro Progenitor', 'Uno de los padres autoriza un trámite del hijo menor: pasaporte, escuela, cambio de centro o atención médica.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2","referencia_legal":"Ley núm. 136-03, Código para el Sistema de Protección y los Derechos Fundamentales de Niños, Niñas y Adolescentes"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_institucion}}
{{destinatario_cargo}}
Ciudad.-

Asunto: Consentimiento para trámite del menor {{menor_nombre}}', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Yo, {{firmante_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{firmante_cedula}}, en mi calidad de {{calidad_progenitor}} del menor {{menor_nombre}}, nacido(a) el {{menor_fecha_nacimiento_larga}}, portador(a) del acta de nacimiento núm. {{menor_acta_nacimiento}}, por medio de la presente doy mi CONSENTIMIENTO expreso para lo siguiente:

{{tramite_autorizado}}

Este consentimiento se otorga en interés superior del menor y podrá ser presentado ante {{destinatario_institucion}} para los fines correspondientes.

Anexo copia de mi cédula de identidad y electoral y del acta de nacimiento del menor.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('calidad_progenitor', 1),
    ('ciudad_firma', 2),
    ('destinatario_cargo', 3),
    ('destinatario_institucion', 4),
    ('fecha_carta', 5),
    ('firmante_cedula', 6),
    ('firmante_correo', 7),
    ('firmante_nombre', 8),
    ('firmante_telefono', 9),
    ('menor_acta_nacimiento', 10),
    ('menor_fecha_nacimiento', 11),
    ('menor_nombre', 12),
    ('tramite_autorizado', 13)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Referencia Comercial ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-empresas';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-empresas';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-referencia-comercial';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-referencia-comercial', 'Carta de Referencia Comercial', 'Una empresa da referencia sobre el comportamiento comercial de un cliente o suplidor.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

A QUIEN PUEDA INTERESAR:

Asunto: Referencia comercial de {{referido_nombre}}', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Por medio de la presente, {{empresa_nombre}}, RNC {{empresa_rnc}}, HACE CONSTAR que mantiene relaciones comerciales con {{referido_nombre}}, RNC o cédula núm. {{referido_identificacion}}, desde el {{fecha_inicio_relacion_larga}}.

Durante ese período, la relación se ha desarrollado en los siguientes términos:

Naturaleza de la relación: {{naturaleza_relacion}}
Volumen aproximado de operaciones: {{volumen_operaciones}}
Condiciones de pago pactadas: {{condiciones_pago}}
Comportamiento de pago observado: {{comportamiento_pago}}

{{observaciones_adicionales}}

La presente referencia se expide a solicitud de la parte interesada y refleja únicamente la experiencia de esta empresa. Quedamos a disposición para ampliarla en {{firmante_telefono}} o {{firmante_correo}}.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
{{firmante_cargo}}
{{empresa_nombre}}
RNC {{empresa_rnc}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('comportamiento_pago', 2),
    ('condiciones_pago', 3),
    ('empresa_nombre', 4),
    ('empresa_rnc', 5),
    ('fecha_carta', 6),
    ('fecha_inicio_relacion', 7),
    ('firmante_cargo', 8),
    ('firmante_cedula', 9),
    ('firmante_correo', 10),
    ('firmante_nombre', 11),
    ('firmante_telefono', 12),
    ('naturaleza_relacion', 13),
    ('observaciones_adicionales', 14),
    ('referido_identificacion', 15),
    ('referido_nombre', 16),
    ('volumen_operaciones', 17)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Autorización de Representante ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-empresas';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-empresas';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-autorizacion-representante';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-autorizacion-representante', 'Carta de Autorización de Representante', 'La empresa designa a una persona para actuar en su nombre ante un tercero o una institución.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_institucion}}
{{destinatario_cargo}}
Ciudad.-

Asunto: Designación de representante', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Por medio de la presente, {{empresa_nombre}}, RNC {{empresa_rnc}}, con domicilio social en {{empresa_domicilio}}, debidamente representada por el(la) suscrito(a) en su calidad de {{firmante_cargo}}, AUTORIZA al señor(a) {{autorizado_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{autorizado_cedula}}, quien ocupa el cargo de {{autorizado_cargo}} en esta empresa, para que la represente ante {{destinatario_institucion}} en lo siguiente:

{{gestion_encomendada}}

El representante queda facultado para firmar los formularios y recibos que la gestión requiera y para recibir las comunicaciones que de ella se deriven.

Esta autorización no comprende la facultad de contraer obligaciones a cargo de la empresa, ni de disponer de sus bienes o fondos, salvo lo expresamente indicado más arriba.

Vigencia: hasta el {{fecha_vencimiento_larga}}, o hasta que esta empresa comunique su revocación por escrito.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
{{firmante_cargo}}
{{empresa_nombre}}
RNC {{empresa_rnc}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('autorizado_cargo', 1),
    ('autorizado_cedula', 2),
    ('autorizado_nombre', 3),
    ('ciudad_firma', 4),
    ('destinatario_cargo', 5),
    ('destinatario_institucion', 6),
    ('empresa_domicilio', 7),
    ('empresa_nombre', 8),
    ('empresa_rnc', 9),
    ('fecha_carta', 10),
    ('fecha_vencimiento', 11),
    ('firmante_cargo', 12),
    ('firmante_cedula', 13),
    ('firmante_correo', 14),
    ('firmante_nombre', 15),
    ('firmante_telefono', 16),
    ('gestion_encomendada', 17)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Presentación de Empresa ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-empresas';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-empresas';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-presentacion-empresa';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-presentacion-empresa', 'Carta de Presentación de Empresa', 'Presenta la empresa y sus servicios a un cliente potencial.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Presentación de {{empresa_nombre}}', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Cortésmente le saludo en nombre de {{empresa_nombre}}, RNC {{empresa_rnc}}, empresa dedicada a {{actividad_empresa}} desde el año {{ano_fundacion}}.

{{presentacion_empresa}}

Los servicios que ofrecemos y que entendemos de interés para {{destinatario_institucion}} son:

{{servicios_ofrecidos}}

{{diferenciales}}

Quedo a su disposición para coordinar una reunión y presentarle una propuesta ajustada a sus necesidades, a través del teléfono {{firmante_telefono}} o del correo {{firmante_correo}}.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
{{firmante_cargo}}
{{empresa_nombre}}
RNC {{empresa_rnc}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('actividad_empresa', 1),
    ('ano_fundacion', 2),
    ('ciudad_firma', 3),
    ('destinatario_cargo', 4),
    ('destinatario_institucion', 5),
    ('destinatario_nombre', 6),
    ('diferenciales', 7),
    ('empresa_nombre', 8),
    ('empresa_rnc', 9),
    ('fecha_carta', 10),
    ('firmante_cargo', 11),
    ('firmante_cedula', 12),
    ('firmante_correo', 13),
    ('firmante_nombre', 14),
    ('firmante_telefono', 15),
    ('presentacion_empresa', 16),
    ('servicios_ofrecidos', 17)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Reclamación por Producto o Servicio Defectuoso ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-comercio';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-comercio';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-reclamacion-producto-defectuoso';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-reclamacion-producto-defectuoso', 'Carta de Reclamación por Producto o Servicio Defectuoso', 'Reclama directamente al comercio antes de acudir a Pro Consumidor.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2","referencia_legal":"Ley núm. 358-05, General de Protección de los Derechos del Consumidor"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Reclamación por {{descripcion_producto}}', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Cortésmente me dirijo a ustedes para presentar una RECLAMACIÓN formal.

En fecha {{fecha_compra_larga}} adquirí en su establecimiento {{descripcion_producto}}, por un valor de {{monto_pagado_letras}}, según {{comprobante_compra}}.

El problema que presenta es el siguiente:

{{descripcion_problema}}

{{gestiones_previas}}

En consecuencia, SOLICITO: {{pretension}}

Agradeceré una respuesta dentro de los {{dias_respuesta}} días siguientes al recibo de esta comunicación, al teléfono {{firmante_telefono}} o al correo {{firmante_correo}}.

De no recibir respuesta en dicho plazo, me reservo el derecho de acudir a Pro Consumidor y a las demás vías que la ley me reconoce.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('comprobante_compra', 2),
    ('descripcion_problema', 3),
    ('descripcion_producto', 4),
    ('destinatario_cargo', 5),
    ('destinatario_institucion', 6),
    ('destinatario_nombre', 7),
    ('dias_respuesta', 8),
    ('fecha_carta', 9),
    ('fecha_compra', 10),
    ('firmante_cedula', 11),
    ('firmante_correo', 12),
    ('firmante_nombre', 13),
    ('firmante_telefono', 14),
    ('gestiones_previas', 15),
    ('monto_pagado', 16),
    ('pretension', 17)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Oferta o Cotización Comercial ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-comercio';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-comercio';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-oferta-comercial';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-oferta-comercial', 'Carta de Oferta o Cotización Comercial', 'Presenta por escrito el precio y las condiciones de un producto o servicio.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Cotización núm. {{numero_referencia}}', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Cortésmente le saludo y, atendiendo a su solicitud, tengo a bien presentarle la siguiente oferta.

Objeto: {{objeto_oferta}}

Detalle:

{{detalle_oferta}}

Precio: {{precio_oferta_letras}}, {{itbis_incluido}}.
Forma de pago: {{forma_pago_oferta}}.
Plazo de entrega o ejecución: {{plazo_entrega}}.
Garantía: {{garantia_ofrecida}}.
Validez de esta oferta: {{dias_validez}} días a partir de su fecha.

{{condiciones_adicionales}}

Quedo a su disposición para cualquier aclaración en el teléfono {{firmante_telefono}} o el correo {{firmante_correo}}.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
{{firmante_cargo}}
{{empresa_nombre}}
RNC {{empresa_rnc}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('condiciones_adicionales', 2),
    ('destinatario_cargo', 3),
    ('destinatario_institucion', 4),
    ('destinatario_nombre', 5),
    ('detalle_oferta', 6),
    ('dias_validez', 7),
    ('empresa_nombre', 8),
    ('empresa_rnc', 9),
    ('fecha_carta', 10),
    ('firmante_cargo', 11),
    ('firmante_cedula', 12),
    ('firmante_correo', 13),
    ('firmante_nombre', 14),
    ('firmante_telefono', 15),
    ('forma_pago_oferta', 16),
    ('garantia_ofrecida', 17),
    ('itbis_incluido', 18),
    ('numero_referencia', 19),
    ('objeto_oferta', 20),
    ('plazo_entrega', 21),
    ('precio_oferta', 22)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Intimación de Pago ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-legales';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-legales';
  END IF;

  -- Esta carta sustituye a intimacion-de-pago, que estaba montado como contrato.
  -- Solo se archiva si sigue en DRAFT: lo aprobado no se toca.
  UPDATE templates SET status = 'ARCHIVED'
  WHERE org_id IS NULL AND slug = 'intimacion-de-pago' AND status = 'DRAFT';

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-intimacion-de-pago';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-intimacion-de-pago', 'Intimación de Pago', 'Requiere formalmente el pago de una deuda vencida y deja constancia de la puesta en mora.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2","referencia_legal":"Código Civil Dominicano, artículo 1139"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Intimación de pago', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Por medio de la presente, y en mi calidad de acreedor(a), le INTIMO formalmente al pago de la suma que se detalla.

ORIGEN DE LA DEUDA: {{origen_deuda}}

MONTO ADEUDADO: {{monto_adeudado_letras}}
FECHA EN QUE SE HIZO EXIGIBLE: {{fecha_vencimiento_larga}}
{{detalle_intereses}}

En consecuencia, le requiero para que dentro del plazo de {{dias_plazo_pago}} días, contados a partir del recibo de esta comunicación, proceda al pago íntegro de dicha suma, mediante {{forma_pago_requerida}}.

Vencido el plazo sin haberse efectuado el pago, quedará usted constituido en mora y me reservo el derecho de accionar por las vías legales correspondientes, con los intereses, costas y honorarios que procedan.

ADVERTENCIA: la puesta en mora produce sus efectos plenos cuando se hace por acto de alguacil. Esta carta deja constancia del requerimiento, pero si la deuda es de importancia, encargue el acto a un abogado antes de que corran los plazos.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('destinatario_cargo', 2),
    ('destinatario_institucion', 3),
    ('destinatario_nombre', 4),
    ('detalle_intereses', 5),
    ('dias_plazo_pago', 6),
    ('fecha_carta', 7),
    ('fecha_vencimiento', 8),
    ('firmante_cedula', 9),
    ('firmante_correo', 10),
    ('firmante_nombre', 11),
    ('firmante_telefono', 12),
    ('forma_pago_requerida', 13),
    ('monto_adeudado', 14),
    ('origen_deuda', 15)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Descargo y Finiquito ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-legales';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-legales';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-descargo-y-finiquito';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-descargo-y-finiquito', 'Carta de Descargo y Finiquito', 'Quien recibe un pago declara que nada más se le adeuda por ese concepto.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Descargo y finiquito', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Yo, {{firmante_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{firmante_cedula}}, por medio de la presente DECLARO:

PRIMERO: Que he recibido de {{deudor_nombre}}, {{deudor_identificacion}}, la suma de {{monto_recibido_letras}}, mediante {{forma_pago_recibida}}, en fecha {{fecha_pago_larga}}.

SEGUNDO: Que dicha suma corresponde íntegramente a {{concepto_pago}}.

TERCERO: Que con el recibo de dicha suma otorgo el más amplio DESCARGO Y FINIQUITO por ese concepto, declarando que nada más se me adeuda por él y que no tengo reclamación alguna que formular al respecto.

ADVERTENCIA: firmar un descargo cierra la posibilidad de reclamar después por ese mismo concepto. Lea con cuidado qué está declarando recibido y por qué concepto. En materia laboral, un descargo firmado no impide reclamar los derechos que la ley declara irrenunciables, pero complica la reclamación: consulte a un abogado antes de firmar.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('concepto_pago', 2),
    ('destinatario_cargo', 3),
    ('destinatario_institucion', 4),
    ('destinatario_nombre', 5),
    ('deudor_identificacion', 6),
    ('deudor_nombre', 7),
    ('fecha_carta', 8),
    ('fecha_pago', 9),
    ('firmante_cedula', 10),
    ('firmante_correo', 11),
    ('firmante_nombre', 12),
    ('firmante_telefono', 13),
    ('forma_pago_recibida', 14),
    ('monto_recibido', 15)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Solicitud a la DGII ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-impuestos';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-impuestos';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-solicitud-dgii';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-solicitud-dgii', 'Carta de Solicitud a la DGII', 'Solicitud dirigida a la Dirección General de Impuestos Internos: constancias, autorizaciones o actualización de datos.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_institucion}}
{{destinatario_cargo}}
Ciudad.-

Asunto: Solicitud de {{objeto_solicitud}}', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Cortésmente me dirijo a esa Dirección General para SOLICITAR lo siguiente:

{{objeto_solicitud}}

Datos del contribuyente:

Nombre o razón social: {{contribuyente_nombre}}
RNC o cédula: {{contribuyente_rnc}}
Domicilio fiscal: {{contribuyente_domicilio}}
Actividad económica: {{actividad_economica}}

Motivo de la solicitud:

{{fundamento_solicitud}}

Anexo la documentación de sustento: {{documentos_anexos}}

Agradeceré que la respuesta me sea comunicada al correo {{firmante_correo}} o al teléfono {{firmante_telefono}}.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('actividad_economica', 1),
    ('ciudad_firma', 2),
    ('contribuyente_domicilio', 3),
    ('contribuyente_nombre', 4),
    ('contribuyente_rnc', 5),
    ('destinatario_cargo', 6),
    ('destinatario_institucion', 7),
    ('documentos_anexos', 8),
    ('fecha_carta', 9),
    ('firmante_cedula', 10),
    ('firmante_correo', 11),
    ('firmante_nombre', 12),
    ('firmante_telefono', 13),
    ('fundamento_solicitud', 14),
    ('objeto_solicitud', 15)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Respuesta a Requerimiento de la DGII ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-impuestos';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-impuestos';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-respuesta-requerimiento-dgii';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-respuesta-requerimiento-dgii', 'Respuesta a Requerimiento de la DGII', 'Contesta dentro de plazo un requerimiento de información o una notificación de la DGII.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_institucion}}
{{destinatario_cargo}}
Ciudad.-

Asunto: Respuesta al requerimiento núm. {{numero_referencia}}', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Acuso recibo del requerimiento núm. {{numero_referencia}}, de fecha {{fecha_requerimiento_larga}}, notificado el {{fecha_recepcion_larga}}, correspondiente al contribuyente {{contribuyente_nombre}}, RNC {{contribuyente_rnc}}, y dentro del plazo concedido doy respuesta.

Sobre el período fiscal {{periodo_fiscal}} y los puntos requeridos:

{{respuesta_requerimiento}}

Documentación que se acompaña:

{{documentos_anexos}}

{{reserva_derechos}}

Quedo a disposición de esa Dirección General para cualquier aclaración adicional.

ADVERTENCIA: los plazos en materia tributaria son perentorios y su vencimiento tiene consecuencias. Si el requerimiento anuncia una determinación de oficio o una sanción, consulte a un asesor fiscal o a un abogado tributario antes de responder.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('contribuyente_nombre', 2),
    ('contribuyente_rnc', 3),
    ('destinatario_cargo', 4),
    ('destinatario_institucion', 5),
    ('documentos_anexos', 6),
    ('fecha_carta', 7),
    ('fecha_recepcion', 8),
    ('fecha_requerimiento', 9),
    ('firmante_cedula', 10),
    ('firmante_correo', 11),
    ('firmante_nombre', 12),
    ('firmante_telefono', 13),
    ('numero_referencia', 14),
    ('periodo_fiscal', 15),
    ('reserva_derechos', 16),
    ('respuesta_requerimiento', 17)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;


-- ==========================================================
-- COMPROBACIÓN
-- ==========================================================
DO $$
DECLARE v_n INT;
BEGIN
  SELECT count(*) INTO v_n FROM templates WHERE org_id IS NULL AND slug IN ('carta-autorizacion-retirar-documentos', 'carta-autorizacion-retirar-paquete', 'carta-poder-simple', 'carta-declaracion-dependencia-economica', 'carta-solicitud-certificacion', 'carta-solicitud-correccion-datos', 'carta-renuncia-voluntaria', 'carta-constancia-de-trabajo', 'carta-recomendacion-laboral', 'carta-solicitud-empleo', 'carta-solicitud-vacaciones', 'carta-solicitud-permiso-laboral', 'carta-solicitud-aumento-salario', 'carta-descargo-empleado', 'carta-amonestacion-empleado', 'carta-solicitud-institucion-publica', 'carta-respuesta-requerimiento', 'carta-reclamacion-proconsumidor', 'carta-invitacion-visa', 'carta-sostenimiento-economico', 'carta-no-objecion-viaje', 'carta-autorizacion-viaje-menor', 'carta-consentimiento-progenitor', 'carta-referencia-comercial', 'carta-autorizacion-representante', 'carta-presentacion-empresa', 'carta-reclamacion-producto-defectuoso', 'carta-oferta-comercial', 'carta-intimacion-de-pago', 'carta-descargo-y-finiquito', 'carta-solicitud-dgii', 'carta-respuesta-requerimiento-dgii');
  IF v_n <> 32 THEN
    RAISE EXCEPTION 'Se esperaban 32 cartas y hay %', v_n;
  END IF;
  SELECT count(*) INTO v_n FROM templates t
  WHERE t.org_id IS NULL AND t.slug IN ('carta-autorizacion-retirar-documentos', 'carta-autorizacion-retirar-paquete', 'carta-poder-simple', 'carta-declaracion-dependencia-economica', 'carta-solicitud-certificacion', 'carta-solicitud-correccion-datos', 'carta-renuncia-voluntaria', 'carta-constancia-de-trabajo', 'carta-recomendacion-laboral', 'carta-solicitud-empleo', 'carta-solicitud-vacaciones', 'carta-solicitud-permiso-laboral', 'carta-solicitud-aumento-salario', 'carta-descargo-empleado', 'carta-amonestacion-empleado', 'carta-solicitud-institucion-publica', 'carta-respuesta-requerimiento', 'carta-reclamacion-proconsumidor', 'carta-invitacion-visa', 'carta-sostenimiento-economico', 'carta-no-objecion-viaje', 'carta-autorizacion-viaje-menor', 'carta-consentimiento-progenitor', 'carta-referencia-comercial', 'carta-autorizacion-representante', 'carta-presentacion-empresa', 'carta-reclamacion-producto-defectuoso', 'carta-oferta-comercial', 'carta-intimacion-de-pago', 'carta-descargo-y-finiquito', 'carta-solicitud-dgii', 'carta-respuesta-requerimiento-dgii')
    AND NOT EXISTS (SELECT 1 FROM template_sections s WHERE s.template_id = t.id);
  IF v_n > 0 THEN
    RAISE EXCEPTION '% cartas se quedaron sin secciones', v_n;
  END IF;
  RAISE NOTICE 'OK: 32 cartas cargadas en DRAFT, con sus secciones.';
END $$;

-- Para publicar una carta, DESPUÉS de la revisión legal:
--   UPDATE templates SET status = 'PUBLISHED',
--     reviewed_by = (SELECT id FROM profiles WHERE email = 'legalcifuentes@gmail.com'),
--     reviewed_at = now()
--   WHERE org_id IS NULL AND slug = 'carta-renuncia-voluntaria';
