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

-- PARTE 0 de 3: categorías y variables. Ejecutar PRIMERO.

-- ══════════════ CATEGORÍAS ══════════════

INSERT INTO template_categories (slug, name, sort_order) VALUES
  ('cartas-tramites', 'Cartas · Trámites personales', 20),
  ('cartas-laborales', 'Cartas · Laborales', 21),
  ('cartas-instituciones', 'Cartas · Instituciones públicas', 22),
  ('cartas-migracion', 'Cartas · Migración y viajes', 23),
  ('cartas-familia', 'Cartas · Familia', 24),
  ('cartas-empresas', 'Cartas · Empresas', 25),
  ('cartas-comercio', 'Cartas · Compras y ventas', 26),
  ('cartas-legales', 'Cartas · Legales', 27),
  ('cartas-impuestos', 'Cartas · Impuestos', 28)
ON CONFLICT (slug) DO NOTHING;

-- ══════════════ VARIABLES ══════════════

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'acompanante_documento', 'Tipo de documento del acompañante', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, 'la cédula de identidad y electoral', false, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'acompanante_documento_numero', 'Número del documento del acompañante', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, false, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'acompanante_nombre', 'Nombre del acompañante', NULL, NULL,
  'person'::variable_data_type, '[]'::jsonb, NULL, false, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'actividad_economica', 'Actividad económica', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'actividad_empresa', 'Actividad de la empresa', '¿A qué se dedica la empresa?', NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'ano_fundacion', 'Año de fundación', NULL, NULL,
  'number'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'ano_vacaciones', 'Año de las vacaciones', NULL, NULL,
  'number'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'autorizado_cargo', 'Cargo de la persona autorizada', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'autorizado_cedula', 'Cédula de la persona autorizada', NULL, NULL,
  'cedula'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'autorizado_nacionalidad', 'Nacionalidad de la persona autorizada', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, 'dominicano(a)', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'autorizado_nombre', 'Nombre de la persona autorizada', '¿A quién autoriza?', NULL,
  'person'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'beneficiario_documento', 'Tipo de documento de la persona beneficiaria', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, 'el pasaporte', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'beneficiario_documento_numero', 'Número del documento', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'beneficiario_nombre', 'Nombre de la persona beneficiaria', NULL, NULL,
  'person'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'calidad_progenitor', 'Calidad en que firma', NULL, NULL,
  'select'::variable_data_type, '[{"value":"padre","label":"Padre"},{"value":"madre","label":"Madre"},{"value":"tutor legal","label":"Tutor legal"}]'::jsonb, 'padre', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'calidad_solicitante', 'Calidad en que solicita', '¿En qué calidad escribe? Ej.: propietario, ciudadano, representante.', NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'cargo_ocupado', 'Cargo que ocupa', '¿Qué cargo ocupa o ocupaba?', NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'cargo_solicitado', 'Cargo al que se postula', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'certificacion_solicitada', 'Certificación que se solicita', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'ciudad_firma', 'Ciudad de firma', '¿Dónde se firma?', NULL,
  'text'::variable_data_type, '[]'::jsonb, 'Punta Cana', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'comportamiento_pago', 'Comportamiento de pago observado', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'comprobante_compra', 'Comprobante de compra', '¿Con qué documento acredita la compra? Ej.: factura con NCF B0100000123.', NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'compromiso_gastos', 'Compromiso sobre los gastos', '¿Quién cubre los gastos y cuáles?', NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'concepto_pago', 'Concepto del pago', '¿Por qué concepto se paga? Sea específico: el descargo cubre solo esto.', NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'condiciones_adicionales', 'Condiciones adicionales', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, false, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'condiciones_pago', 'Condiciones de pago pactadas', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'contribuyente_domicilio', 'Domicilio fiscal', NULL, NULL,
  'address'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'contribuyente_nombre', 'Nombre o razón social del contribuyente', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'contribuyente_rnc', 'RNC o cédula del contribuyente', NULL, NULL,
  'rnc'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'dato_correcto', 'Dato correcto', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'dato_incorrecto', 'Dato como aparece hoy', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'descargo_hechos', 'Explicación de los hechos', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'descripcion_envio', 'Descripción del envío', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'descripcion_problema', 'Problema que presenta', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'descripcion_producto', 'Producto o servicio', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'destinatario_cargo', 'Cargo del destinatario', '¿Qué cargo ocupa?', NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, false, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'destinatario_institucion', 'Institución o empresa destinataria', '¿A qué institución o empresa?', NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'destinatario_nombre', 'Nombre del destinatario', '¿A quién va dirigida?', NULL,
  'person'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'detalle_intereses', 'Intereses o recargos', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, false, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'detalle_oferta', 'Detalle de la oferta', 'Partidas, cantidades y precios unitarios.', NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'deudor_identificacion', 'Cédula o RNC de quien paga', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'deudor_nombre', 'Nombre de quien paga', NULL, NULL,
  'person'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'dias_para_descargo', 'Días para presentar descargo', NULL, NULL,
  'number'::variable_data_type, '[]'::jsonb, '3', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'dias_plazo_pago', 'Días de plazo para pagar', NULL, NULL,
  'number'::variable_data_type, '[]'::jsonb, '15', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'dias_respuesta', 'Días para responder', NULL, NULL,
  'number'::variable_data_type, '[]'::jsonb, '15', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'dias_validez', 'Días de validez de la oferta', NULL, NULL,
  'number'::variable_data_type, '[]'::jsonb, '15', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'diferenciales', 'Qué la diferencia', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, false, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'documentos_a_retirar', 'Documentos a retirar', '¿Qué documentos se van a retirar?', NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'documentos_anexos', 'Documentos anexos', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, false, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'documentos_sustento', 'Documentos que sustentan la solicitud', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, false, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'empleado_cedula', 'Cédula del trabajador', NULL, NULL,
  'cedula'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'empleado_nombre', 'Nombre del trabajador', NULL, NULL,
  'person'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'empresa_destino', 'Empresa a la que se postula', NULL, NULL,
  'company'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'empresa_domicilio', 'Domicilio social', NULL, NULL,
  'address'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'empresa_nombre', 'Razón social de la empresa', NULL, NULL,
  'company'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'empresa_rnc', 'RNC de la empresa', NULL, NULL,
  'rnc'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'fecha_carta', 'Fecha de la carta', '¿Con qué fecha se firma la carta?', NULL,
  'date'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"fecha_larga","as":"fecha_carta_larga"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'fecha_compra', 'Fecha de la compra', '¿Qué día se compró?', NULL,
  'date'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"fecha_larga","as":"fecha_compra_larga"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'fecha_comunicacion', 'Fecha de la comunicación recibida', NULL, NULL,
  'date'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"fecha_larga","as":"fecha_comunicacion_larga"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'fecha_desde', 'Fecha de inicio', '¿Desde qué día?', NULL,
  'date'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"fecha_larga","as":"fecha_desde_larga"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'fecha_egreso', 'Fecha de salida de la empresa', '¿Cuándo dejó de trabajar allí?', NULL,
  'date'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"fecha_larga","as":"fecha_egreso_larga"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'fecha_hasta', 'Fecha de término', '¿Hasta qué día?', NULL,
  'date'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"fecha_larga","as":"fecha_hasta_larga"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'fecha_hecho', 'Fecha en que ocurrió el hecho', NULL, NULL,
  'date'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"fecha_larga","as":"fecha_hecho_larga"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'fecha_ingreso', 'Fecha de ingreso a la empresa', '¿Cuándo empezó a trabajar allí?', NULL,
  'date'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"fecha_larga","as":"fecha_ingreso_larga"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'fecha_inicio_relacion', 'Inicio de la relación comercial', '¿Desde cuándo trabajan juntos?', NULL,
  'date'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"fecha_larga","as":"fecha_inicio_relacion_larga"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'fecha_llegada', 'Fecha de llegada', NULL, NULL,
  'date'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"fecha_larga","as":"fecha_llegada_larga"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'fecha_pago', 'Fecha del pago', NULL, NULL,
  'date'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"fecha_larga","as":"fecha_pago_larga"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'fecha_recepcion', 'Fecha en que se recibió', '¿Qué día le fue notificado?', NULL,
  'date'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"fecha_larga","as":"fecha_recepcion_larga"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'fecha_regreso', 'Fecha de regreso', NULL, NULL,
  'date'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"fecha_larga","as":"fecha_regreso_larga"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'fecha_reintegro', 'Fecha de reintegro', '¿Qué día vuelve a sus labores?', NULL,
  'date'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"fecha_larga","as":"fecha_reintegro_larga"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'fecha_requerimiento', 'Fecha del requerimiento', NULL, NULL,
  'date'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"fecha_larga","as":"fecha_requerimiento_larga"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'fecha_salida', 'Fecha de salida del país', '¿Qué día sale?', NULL,
  'date'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"fecha_larga","as":"fecha_salida_larga"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'fecha_ultima_revision', 'Fecha de la última revisión salarial', NULL, NULL,
  'date'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"fecha_larga","as":"fecha_ultima_revision_larga"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'fecha_ultimo_dia', 'Último día de labores', '¿Cuál será su último día de trabajo?', NULL,
  'date'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"fecha_larga","as":"fecha_ultimo_dia_larga"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'fecha_vencimiento', 'Fecha de vencimiento', '¿Hasta cuándo tiene vigencia?', NULL,
  'date'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"fecha_larga","as":"fecha_vencimiento_larga"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'finalidad_certificacion', 'Para qué se necesita', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'firmante_cargo', 'Cargo de quien firma', '¿Qué cargo ocupa quien firma?', NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'firmante_cedula', 'Cédula de quien firma', NULL, NULL,
  'cedula'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'firmante_correo', 'Correo de contacto', NULL, NULL,
  'email'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'firmante_documento', 'Tipo de documento de identidad', NULL, NULL,
  'select'::variable_data_type, '[{"value":"la cédula de identidad y electoral","label":"Cédula de identidad y electoral"},{"value":"el pasaporte","label":"Pasaporte"}]'::jsonb, 'la cédula de identidad y electoral', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'firmante_domicilio', 'Domicilio de quien firma', NULL, NULL,
  'address'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'firmante_nacionalidad', 'Nacionalidad de quien firma', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, 'dominicano(a)', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'firmante_nombre', 'Nombre de quien firma', '¿Quién firma la carta?', NULL,
  'person'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'firmante_ocupacion', 'Ocupación de quien firma', '¿A qué se dedica?', NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'firmante_telefono', 'Teléfono de contacto', NULL, NULL,
  'phone'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'forma_pago_oferta', 'Forma de pago', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'forma_pago_recibida', 'Cómo se recibió el pago', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'forma_pago_requerida', 'Cómo debe pagarse', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'fuente_ingresos', 'De dónde provienen los ingresos', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'fuente_vacante', 'Dónde vio la vacante', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'funciones_desempenadas', 'Funciones desempeñadas', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'fundamento_solicitud', 'Por qué se solicita', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'garantia_ofrecida', 'Garantía ofrecida', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'gastos_cubiertos', 'Gastos que se cubren', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'gestion_encomendada', 'Gestión encomendada', '¿Qué gestión exactamente puede hacer?', NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'gestiones_previas', 'Gestiones ya realizadas', '¿Qué ha hecho ya para resolverlo?', NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'hecho_imputado', 'Hecho que se imputa', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'ingreso_mensual', 'Ingreso mensual', NULL, NULL,
  'currency'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"monto_letras","as":"ingreso_mensual_letras","currency":"DOP"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'invitado_nacionalidad', 'Nacionalidad de la persona invitada', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'invitado_nombre', 'Nombre de la persona invitada', NULL, NULL,
  'person'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'invitado_pasaporte', 'Pasaporte de la persona invitada', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'itbis_incluido', 'ITBIS', NULL, NULL,
  'select'::variable_data_type, '[{"value":"ITBIS incluido","label":"ITBIS incluido"},{"value":"más el ITBIS correspondiente","label":"ITBIS aparte"},{"value":"exento de ITBIS","label":"Exento"}]'::jsonb, 'ITBIS incluido', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'logros_alcanzados', 'Logros alcanzados', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, false, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'lugar_alojamiento', 'Lugar de alojamiento', NULL, NULL,
  'address'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'madre_cedula', 'Cédula de la madre', NULL, NULL,
  'cedula'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'madre_nombre', 'Nombre de la madre', NULL, NULL,
  'person'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'madre_telefono', 'Teléfono de la madre', NULL, NULL,
  'phone'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'menor_acta_nacimiento', 'Acta de nacimiento del menor', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'menor_fecha_nacimiento', 'Fecha de nacimiento del menor', NULL, NULL,
  'date'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"fecha_larga","as":"menor_fecha_nacimiento_larga"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'menor_nombre', 'Nombre del menor', NULL, NULL,
  'person'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'menor_pasaporte', 'Pasaporte del menor', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, false, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'modalidad_viaje', 'Cómo viaja el menor', NULL, NULL,
  'select'::variable_data_type, '[{"value":"en compañía de la persona responsable que más abajo se indica","label":"Acompañado por un tercero"},{"value":"no acompañado, bajo el servicio de menor no acompañado de la aerolínea","label":"Solo (menor no acompañado)"}]'::jsonb, 'en compañía de la persona responsable que más abajo se indica', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'monto_adeudado', 'Monto adeudado', NULL, NULL,
  'currency'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"monto_letras","as":"monto_adeudado_letras","currency":"DOP"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'monto_pagado', 'Monto pagado', NULL, NULL,
  'currency'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"monto_letras","as":"monto_pagado_letras","currency":"DOP"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'monto_recibido', 'Monto recibido', NULL, NULL,
  'currency'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"monto_letras","as":"monto_recibido_letras","currency":"DOP"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'motivo_interes', 'Motivo del interés en el puesto', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'motivo_permiso', 'Motivo del permiso', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'motivo_salida', 'Motivo de la salida', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'motivo_viaje', 'Motivo del viaje', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'motivo_visita', 'Motivo de la visita', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'naturaleza_relacion', 'Naturaleza de la relación', '¿Es cliente, suplidor, distribuidor?', NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'norma_incumplida', 'Norma o política incumplida', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'numero_guia', 'Número de guía o referencia', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, false, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'numero_referencia', 'Número de referencia o expediente', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, false, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'objeto_oferta', 'Objeto de la oferta', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'objeto_solicitud', 'Qué se solicita', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'observaciones_adicionales', 'Observaciones adicionales', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, false, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'origen_deuda', 'Origen de la deuda', '¿De dónde viene la deuda? Contrato, factura, préstamo.', NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'padre_cedula', 'Cédula del padre', NULL, NULL,
  'cedula'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'padre_nombre', 'Nombre del padre', NULL, NULL,
  'person'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'padre_telefono', 'Teléfono del padre', NULL, NULL,
  'phone'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'pais_destino', 'País de destino', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'periodo_fiscal', 'Período fiscal', '¿A qué período se refiere? Ej.: octubre 2026.', NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'personas_dependientes', 'Personas que dependen económicamente', 'Nombre, cédula o acta, edad y parentesco de cada una.', NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'plan_cobertura', 'Cómo quedan cubiertas sus funciones', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, false, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'plazo_entrega', 'Plazo de entrega o ejecución', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'precio_oferta', 'Precio ofertado', NULL, NULL,
  'currency'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"monto_letras","as":"precio_oferta_letras","currency":"DOP"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'presentacion_candidato', 'Presentación del candidato', '¿Cómo se presenta? Formación y experiencia principal.', NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'presentacion_empresa', 'Presentación de la empresa', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'pretension', 'Qué solicita', '¿Qué pide: devolución, cambio, reparación?', NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'proveedor_domicilio', 'Dirección del proveedor', NULL, NULL,
  'address'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'proveedor_nombre', 'Nombre del proveedor o comercio', NULL, NULL,
  'company'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'proveedor_rnc', 'RNC del proveedor', NULL, NULL,
  'rnc'::variable_data_type, '[]'::jsonb, NULL, false, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'pruebas_ofrecidas', 'Pruebas que se acompañan', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, false, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'referido_identificacion', 'RNC o cédula de quien se refiere', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'referido_nombre', 'Nombre de quien se refiere', NULL, NULL,
  'company'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'reserva_derechos', 'Reserva de derechos', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, false, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'responsabilidades_asumidas', 'Responsabilidades asumidas desde el ingreso', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'respuesta_requerimiento', 'Respuesta a lo requerido', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'salario_actual', 'Salario actual', NULL, NULL,
  'currency'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"monto_letras","as":"salario_actual_letras","currency":"DOP"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'salario_mensual', 'Salario mensual', NULL, NULL,
  'currency'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"monto_letras","as":"salario_mensual_letras","currency":"DOP"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'salario_propuesto', 'Salario que se propone', NULL, NULL,
  'currency'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"monto_letras","as":"salario_propuesto_letras","currency":"DOP"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'servicios_ofrecidos', 'Servicios que se ofrecen', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'tipo_contrato', 'Tipo de contrato', NULL, NULL,
  'select'::variable_data_type, '[{"value":"por tiempo indefinido","label":"Por tiempo indefinido"},{"value":"por tiempo determinado","label":"Por tiempo determinado"},{"value":"para una obra o servicio determinado","label":"Por obra o servicio"}]'::jsonb, 'por tiempo indefinido', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'tramite_autorizado', 'Trámite que se autoriza', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'valoracion_desempeno', 'Valoración del desempeño', '¿Cómo describiría su desempeño?', NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'vinculo_acompanante', 'Vínculo con el acompañante', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, false, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'vinculo_beneficiario', 'Vínculo con la persona beneficiaria', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'vinculo_invitado', 'Vínculo con la persona invitada', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'volumen_operaciones', 'Volumen aproximado de operaciones', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

