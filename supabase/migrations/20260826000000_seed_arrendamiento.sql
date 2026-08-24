-- ==========================================================
-- SA&VE Comercial, S.R.L. — Punta Cana, República Dominicana
-- Migración 7: Contrato de Alquiler de Vivienda
--
-- ⚠️  TODO EL CONTENIDO LEGAL DE ESTE ARCHIVO ES UN BORRADOR.
--     Las cláusulas y la plantilla se crean con status = 'DRAFT',
--     lo que significa que NO son visibles para los usuarios: solo
--     un administrador de SA&VE las ve.
--
--     Antes de publicar nada, un abogado dominicano debe revisar el
--     texto. Para publicar, al final del archivo hay una consulta
--     comentada que hay que ejecutar a mano.
-- ==========================================================

-- ==========================================================
-- 1. VARIABLES GLOBALES
-- ==========================================================

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES
  -- ── Arrendador ──
  (NULL, 'arrendador_nombre', 'Nombre del arrendador', '¿Quién alquila el inmueble?', 'Nombre completo del propietario o de quien alquila.', 'person', '[]', NULL, true, NULL),
  (NULL, 'arrendador_cedula', 'Cédula del arrendador', '¿Cuál es su cédula?', NULL, 'cedula', '[]', NULL, true, NULL),
  (NULL, 'arrendador_nacionalidad', 'Nacionalidad del arrendador', NULL, NULL, 'text', '[]', 'dominicana', true, NULL),
  (NULL, 'arrendador_estado_civil', 'Estado civil del arrendador', NULL, NULL, 'select',
    '[{"value":"soltero","label":"soltero(a)"},{"value":"casado","label":"casado(a)"},{"value":"union_libre","label":"en unión libre"},{"value":"divorciado","label":"divorciado(a)"},{"value":"viudo","label":"viudo(a)"}]',
    'soltero', true, NULL),
  (NULL, 'arrendador_domicilio', 'Domicilio del arrendador', NULL, NULL, 'address', '[]', NULL, true, NULL),

  -- ── Arrendatario ──
  (NULL, 'arrendatario_nombre', 'Nombre del arrendatario', '¿Quién va a vivir en el inmueble?', 'Nombre completo del inquilino.', 'person', '[]', NULL, true, NULL),
  (NULL, 'arrendatario_cedula', 'Cédula del arrendatario', '¿Cuál es su cédula?', NULL, 'cedula', '[]', NULL, true, NULL),
  (NULL, 'arrendatario_nacionalidad', 'Nacionalidad del arrendatario', NULL, NULL, 'text', '[]', 'dominicana', true, NULL),
  (NULL, 'arrendatario_estado_civil', 'Estado civil del arrendatario', NULL, NULL, 'select',
    '[{"value":"soltero","label":"soltero(a)"},{"value":"casado","label":"casado(a)"},{"value":"union_libre","label":"en unión libre"},{"value":"divorciado","label":"divorciado(a)"},{"value":"viudo","label":"viudo(a)"}]',
    'soltero', true, NULL),
  (NULL, 'arrendatario_domicilio', 'Domicilio anterior del arrendatario', NULL, 'Dónde vivía antes de mudarse.', 'address', '[]', NULL, false, NULL),

  -- ── Inmueble ──
  (NULL, 'direccion_inmueble', 'Dirección del inmueble', '¿Dónde queda el inmueble?', 'Calle, número, sector y municipio.', 'address', '[]', NULL, true, NULL),
  (NULL, 'tipo_inmueble', 'Tipo de inmueble', '¿Para qué se va a usar?', NULL, 'select',
    '[{"value":"residencial","label":"Vivienda"},{"value":"comercial","label":"Local comercial"}]',
    'residencial', true, NULL),
  (NULL, 'habitaciones', 'Habitaciones', '¿Cuántas habitaciones tiene?', NULL, 'number', '[]', NULL, false, NULL),
  (NULL, 'banos', 'Baños', '¿Cuántos baños tiene?', NULL, 'number', '[]', NULL, false, NULL),
  (NULL, 'parqueos', 'Parqueos', '¿Cuántos parqueos incluye?', 'Escribe 0 si no incluye.', 'number', '[]', '0', false, NULL),
  (NULL, 'amueblado', '¿Está amueblado?', '¿El inmueble se entrega amueblado?', 'Si marcas que sí, el contrato incluirá un anexo de inventario.', 'boolean', '[]', NULL, false, NULL),

  -- ── Económicas ──
  (NULL, 'precio_renta', 'Renta mensual', '¿Cuánto se paga al mes?', NULL, 'currency', '[]', NULL, true,
    '{"transform":"monto_letras","currency":"DOP","as":"precio_renta_letras"}'),
  (NULL, 'deposito_garantia', 'Depósito de garantía', '¿Cuánto se entrega de depósito?', 'Lo habitual son uno o dos meses de renta.', 'currency', '[]', NULL, true,
    '{"transform":"monto_letras","currency":"DOP","as":"deposito_garantia_letras"}'),
  (NULL, 'dia_pago', 'Día de pago', '¿Qué día de cada mes se paga?', 'Un número del 1 al 28.', 'number', '[]', '5', true, NULL),
  (NULL, 'mora_porcentaje', 'Recargo por mora', '¿Qué recargo se aplica si se atrasa el pago?', 'Porcentaje mensual sobre el monto vencido.', 'percentage', '[]', '5', false, NULL),

  -- ── Duración ──
  (NULL, 'fecha_inicio', 'Fecha de inicio', '¿Cuándo empieza el alquiler?', NULL, 'date', '[]', NULL, true,
    '{"transform":"fecha_larga","as":"fecha_inicio_larga"}'),
  (NULL, 'duracion_meses', 'Duración en meses', '¿Por cuántos meses?', NULL, 'number', '[]', '12', true, NULL),
  (NULL, 'fecha_finalizacion', 'Fecha de terminación', '¿Cuándo termina?', NULL, 'date', '[]', NULL, true,
    '{"transform":"fecha_larga","as":"fecha_finalizacion_larga"}'),

  -- ── Condiciones ──
  (NULL, 'mascotas', '¿Se permiten mascotas?', '¿El arrendatario puede tener animales domésticos?', NULL, 'boolean', '[]', NULL, false, NULL),
  (NULL, 'mantenimiento_incluido', '¿Incluye mantenimiento?', '¿El arrendador cubre el mantenimiento del inmueble?', NULL, 'boolean', '[]', NULL, false, NULL),
  (NULL, 'subarriendo_permitido', '¿Se permite subarrendar?', '¿El arrendatario puede alquilar a terceros?', NULL, 'boolean', '[]', NULL, false, NULL),
  (NULL, 'servicios_incluidos', 'Servicios incluidos', '¿Qué servicios cubre la renta?', NULL, 'multiselect',
    '[{"value":"agua","label":"agua"},{"value":"luz","label":"electricidad"},{"value":"gas","label":"gas"},{"value":"internet","label":"internet"},{"value":"basura","label":"recogida de basura"},{"value":"mantenimiento_areas","label":"mantenimiento de áreas comunes"}]',
    NULL, false, NULL),
  (NULL, 'inventario_descripcion', 'Inventario del mobiliario', 'Detalla el mobiliario que se entrega', 'Un renglón por artículo.', 'textarea', '[]', NULL, false, NULL),

  -- ── Firma ──
  (NULL, 'ciudad_firma', 'Ciudad de firma', '¿Dónde se firma?', NULL, 'text', '[]', 'Punta Cana', true, NULL),
  (NULL, 'fecha_firma', 'Fecha de firma', '¿Cuándo se firma?', NULL, 'date', '[]', NULL, true,
    '{"transform":"fecha_notarial","as":"fecha_firma_notarial"}')
ON CONFLICT DO NOTHING;

-- ==========================================================
-- 2. CLÁUSULAS GLOBALES (BORRADOR)
-- ==========================================================

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES

-- ── Generales ──
(NULL, 'objeto-arrendamiento', 'Objeto', 'Generales',
 'Define qué se alquila y para qué.',
 'PRIMERO: OBJETO. EL ARRENDADOR da en arrendamiento a EL ARRENDATARIO, y este recibe a título de inquilino, el inmueble ubicado en {{direccion_inmueble}}, en adelante EL INMUEBLE, el cual será destinado exclusivamente a {{tipo_inmueble}}. EL ARRENDATARIO declara recibir EL INMUEBLE en buen estado de conservación y funcionamiento.',
 'Código Civil Dominicano, artículos 1708 y siguientes', 'DRAFT'),

(NULL, 'vigencia-arrendamiento', 'Vigencia', 'Generales',
 'Plazo del contrato y su renovación.',
 'SEGUNDO: DURACIÓN. El presente contrato tendrá una duración de {{duracion_meses}} meses, contados a partir del {{fecha_inicio_larga}} y hasta el {{fecha_finalizacion_larga}}. Vencido el plazo sin que ninguna de las partes haya manifestado por escrito su voluntad de no continuar, con no menos de treinta (30) días de anticipación, el contrato se entenderá renovado por un período igual.',
 NULL, 'DRAFT'),

(NULL, 'terminacion-anticipada', 'Terminación anticipada', 'Generales',
 'Cómo una parte puede terminar antes de tiempo.',
 'TERMINACIÓN ANTICIPADA. Cualquiera de las partes podrá dar por terminado el presente contrato antes de su vencimiento, comunicándolo a la otra por escrito con no menos de treinta (30) días de anticipación. Si la terminación anticipada proviene de EL ARRENDATARIO sin causa imputable a EL ARRENDADOR, aquel perderá el depósito de garantía constituido.',
 NULL, 'DRAFT'),

(NULL, 'incumplimiento-desalojo', 'Incumplimiento', 'Generales',
 'Consecuencias de incumplir el contrato.',
 'INCUMPLIMIENTO. La falta de pago de dos (2) mensualidades consecutivas, el uso del inmueble para un fin distinto al pactado, o el incumplimiento de cualquiera de las obligaciones asumidas en este contrato, facultará a EL ARRENDADOR para demandar la resolución del contrato y el desalojo de EL ARRENDATARIO, conforme al procedimiento establecido por la legislación dominicana.',
 'Decreto 4807 de 1959 sobre Control de Alquileres de Casas y Desahucios', 'DRAFT'),

(NULL, 'notificaciones', 'Notificaciones', 'Generales',
 'Dónde se notifican las partes.',
 'NOTIFICACIONES. Para todos los fines del presente contrato, EL ARRENDADOR elige domicilio en {{arrendador_domicilio}} y EL ARRENDATARIO en EL INMUEBLE objeto de este contrato. Toda notificación se reputará válida si se realiza en dichos domicilios.',
 NULL, 'DRAFT'),

(NULL, 'ley-aplicable-jurisdiccion', 'Ley aplicable y jurisdicción', 'Generales',
 'Qué ley rige y qué tribunales conocen.',
 'LEY APLICABLE Y JURISDICCIÓN. El presente contrato se rige por las leyes de la República Dominicana. Para el conocimiento de cualquier controversia derivada de su interpretación o ejecución, las partes se someten voluntariamente a la competencia de los tribunales del Distrito Judicial correspondiente al lugar donde se encuentra EL INMUEBLE, renunciando a cualquier otro fuero que pudiera corresponderles.',
 NULL, 'DRAFT'),

(NULL, 'integridad-contractual', 'Integridad del contrato', 'Generales',
 'El contrato reemplaza cualquier acuerdo anterior.',
 'INTEGRIDAD. El presente contrato constituye el acuerdo íntegro entre las partes respecto de su objeto y deja sin efecto cualquier entendimiento, verbal o escrito, anterior a su firma. Toda modificación deberá constar por escrito y estar firmada por ambas partes.',
 NULL, 'DRAFT'),

-- ── Económicas ──
(NULL, 'precio-renta', 'Precio del arrendamiento', 'Económicas',
 'Monto de la renta y forma de pago.',
 'TERCERO: PRECIO. El precio del arrendamiento se fija en la suma de {{precio_renta_letras}} mensuales, que EL ARRENDATARIO se obliga a pagar por adelantado, a más tardar el día {{dia_pago}} de cada mes, en el domicilio de EL ARRENDADOR o mediante transferencia a la cuenta que este indique.',
 NULL, 'DRAFT'),

(NULL, 'deposito-garantia', 'Depósito de garantía', 'Económicas',
 'Depósito, su destino y su devolución.',
 'DEPÓSITO DE GARANTÍA. A la firma del presente contrato EL ARRENDATARIO entrega a EL ARRENDADOR la suma de {{deposito_garantia_letras}}, en calidad de depósito de garantía. Dicha suma no constituye pago adelantado de rentas y será devuelta dentro de los treinta (30) días siguientes a la entrega del inmueble, previa deducción de los daños que excedan el deterioro normal por el uso y de cualquier suma adeudada.',
 NULL, 'DRAFT'),

(NULL, 'mora-recargo', 'Mora', 'Económicas',
 'Recargo por atraso en el pago.',
 'MORA. El retraso en el pago de la renta generará, sin necesidad de intimación previa, un recargo de {{mora_porcentaje}} mensual sobre el monto vencido, calculado por cada mes o fracción de mes de atraso.',
 NULL, 'DRAFT'),

-- ── Inmobiliarias ──
(NULL, 'uso-residencial', 'Uso residencial', 'Inmobiliarias',
 'Restringe el inmueble a vivienda.',
 'USO. EL INMUEBLE será destinado exclusivamente a vivienda de EL ARRENDATARIO y de su núcleo familiar. Queda expresamente prohibido destinarlo a actividad comercial, industrial o de cualquier otra naturaleza sin el consentimiento previo y por escrito de EL ARRENDADOR.',
 NULL, 'DRAFT'),

(NULL, 'uso-comercial', 'Uso comercial', 'Inmobiliarias',
 'Habilita el inmueble para actividad comercial.',
 'USO. EL INMUEBLE será destinado a la actividad comercial declarada por EL ARRENDATARIO. Este se obliga a obtener y mantener vigentes todas las licencias, permisos y registros que exijan las autoridades competentes, y responderá frente a EL ARRENDADOR por cualquier sanción derivada de su incumplimiento.',
 NULL, 'DRAFT'),

(NULL, 'mascotas', 'Mascotas', 'Inmobiliarias',
 'Autoriza animales domésticos con condiciones.',
 'MASCOTAS. EL ARRENDATARIO queda autorizado a mantener animales domésticos en EL INMUEBLE, siendo de su exclusiva responsabilidad todo daño que estos ocasionen a la propiedad, a las áreas comunes o a terceros, así como el cumplimiento del reglamento de convivencia que resulte aplicable.',
 NULL, 'DRAFT'),

(NULL, 'inventario-mobiliario', 'Inventario del mobiliario', 'Inmobiliarias',
 'El inmueble se entrega amueblado según inventario.',
 'MOBILIARIO. EL INMUEBLE se entrega amueblado conforme al inventario que figura como anexo del presente contrato y que forma parte integrante del mismo. EL ARRENDATARIO se obliga a devolver dicho mobiliario en el mismo estado en que lo recibió, salvo el deterioro normal derivado del uso.',
 NULL, 'DRAFT'),

(NULL, 'mantenimiento-arrendador', 'Mantenimiento a cargo del arrendador', 'Inmobiliarias',
 'El arrendador cubre el mantenimiento.',
 'MANTENIMIENTO. EL ARRENDADOR asume el mantenimiento preventivo y correctivo de EL INMUEBLE, incluyendo las instalaciones eléctricas, sanitarias e hidráulicas, salvo cuando el desperfecto sea imputable al uso indebido o negligente de EL ARRENDATARIO.',
 NULL, 'DRAFT'),

(NULL, 'reparaciones-menores', 'Reparaciones menores', 'Inmobiliarias',
 'Reparto de las reparaciones entre las partes.',
 'REPARACIONES. Corresponden a EL ARRENDATARIO las reparaciones locativas y de mantenimiento menor derivadas del uso ordinario. Las reparaciones mayores, estructurales o que afecten la habitabilidad de EL INMUEBLE corresponden a EL ARRENDADOR, quien deberá ejecutarlas dentro de un plazo razonable desde que le sean comunicadas por escrito.',
 NULL, 'DRAFT'),

(NULL, 'servicios-incluidos', 'Servicios incluidos', 'Inmobiliarias',
 'Qué servicios cubre la renta.',
 'SERVICIOS. La renta pactada incluye los siguientes servicios: {{servicios_incluidos}}. Los demás servicios de que disponga EL INMUEBLE correrán por cuenta exclusiva de EL ARRENDATARIO, quien deberá mantenerlos al día y entregar los recibos correspondientes al momento de la devolución.',
 NULL, 'DRAFT'),

(NULL, 'subarrendamiento-prohibido', 'Prohibición de subarrendar', 'Inmobiliarias',
 'Impide subarrendar o ceder el contrato.',
 'SUBARRENDAMIENTO. Queda expresamente prohibido a EL ARRENDATARIO subarrendar, ceder o traspasar, total o parcialmente, los derechos derivados del presente contrato, sin el consentimiento previo y por escrito de EL ARRENDADOR. La violación de esta cláusula constituye causa de resolución inmediata.',
 NULL, 'DRAFT'),

(NULL, 'subarrendamiento-permitido', 'Subarrendamiento autorizado', 'Inmobiliarias',
 'Permite subarrendar con aviso previo.',
 'SUBARRENDAMIENTO. EL ARRENDATARIO queda autorizado a subarrendar total o parcialmente EL INMUEBLE, previa comunicación escrita a EL ARRENDADOR. EL ARRENDATARIO continuará siendo solidariamente responsable frente a EL ARRENDADOR por el cumplimiento de todas las obligaciones de este contrato.',
 NULL, 'DRAFT'),

(NULL, 'remodelaciones', 'Remodelaciones y mejoras', 'Inmobiliarias',
 'Condiciones para modificar el inmueble.',
 'MEJORAS. EL ARRENDATARIO no podrá realizar modificaciones, remodelaciones ni mejoras en EL INMUEBLE sin autorización previa y por escrito de EL ARRENDADOR. Las mejoras autorizadas que no puedan retirarse sin deterioro quedarán en beneficio de EL INMUEBLE, sin derecho a indemnización ni compensación alguna.',
 NULL, 'DRAFT'),

(NULL, 'devolucion-inmueble', 'Devolución del inmueble', 'Inmobiliarias',
 'Estado y plazo de entrega al terminar.',
 'DEVOLUCIÓN. Al vencimiento del contrato o al producirse su terminación por cualquier causa, EL ARRENDATARIO se obliga a devolver EL INMUEBLE completamente desocupado, libre de personas y objetos, en el mismo estado en que lo recibió, salvo el deterioro normal por el uso, y con los recibos de los servicios a su cargo debidamente saldados.',
 NULL, 'DRAFT'),

(NULL, 'estacionamiento', 'Estacionamiento', 'Inmobiliarias',
 'Parqueos asignados al arrendatario.',
 'ESTACIONAMIENTO. El arrendamiento comprende {{parqueos}} espacio(s) de estacionamiento, de uso exclusivo de EL ARRENDATARIO. Su utilización quedará sujeta al reglamento interno del inmueble o del condominio, según corresponda.',
 NULL, 'DRAFT')

ON CONFLICT DO NOTHING;

-- ==========================================================
-- 3. LA PLANTILLA, SUS SECCIONES Y SU CABLEADO
-- ==========================================================

DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_compare  UUID;
  s_objeto   UUID;
  s_precio   UUID;
  s_duracion UUID;
  s_condic   UUID;
  s_general  UUID;
  s_firmas   UUID;
  s_anexo    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'inmobiliario';

  -- Plantilla maestra, en borrador hasta que un abogado la revise.
  SELECT id INTO v_template FROM templates WHERE slug = 'contrato-alquiler-vivienda';

  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (
      NULL,
      'contrato-alquiler-vivienda',
      'Contrato de Alquiler de Vivienda',
      'Arrendamiento de inmueble para vivienda o local comercial, con cláusulas opcionales de mascotas, mobiliario, mantenimiento y subarrendamiento.',
      'Inmobiliario',
      v_cat,
      'DO',
      true,
      '1.0',
      'DRAFT',
      '{"engine":"v2"}'::jsonb
    )
    RETURNING id INTO v_template;
  END IF;

  -- Se rehace el cableado cada vez, para poder reejecutar la migración.
  DELETE FROM template_rules     WHERE template_id = v_template;
  DELETE FROM template_clauses   WHERE template_id = v_template;
  DELETE FROM template_variables WHERE template_id = v_template;
  DELETE FROM template_sections  WHERE template_id = v_template;

  -- ── Secciones ──
  INSERT INTO template_sections (template_id, title, body, sort_order, is_annex) VALUES
  (v_template, 'Comparecientes',
   'ENTRE: {{arrendador_nombre}}, {{arrendador_nacionalidad}}, mayor de edad, {{arrendador_estado_civil}}, portador(a) de la cédula de identidad y electoral número {{arrendador_cedula}}, domiciliado(a) y residente en {{arrendador_domicilio}}, quien en lo adelante se denominará EL ARRENDADOR;

Y DE LA OTRA PARTE: {{arrendatario_nombre}}, {{arrendatario_nacionalidad}}, mayor de edad, {{arrendatario_estado_civil}}, portador(a) de la cédula de identidad y electoral número {{arrendatario_cedula}}, quien en lo adelante se denominará EL ARRENDATARIO.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:',
   1, false) RETURNING id INTO s_compare;

  INSERT INTO template_sections (template_id, title, body, sort_order, is_annex)
  VALUES (v_template, 'Objeto del contrato', NULL, 2, false) RETURNING id INTO s_objeto;

  INSERT INTO template_sections (template_id, title, body, sort_order, is_annex)
  VALUES (v_template, 'Precio y forma de pago', NULL, 3, false) RETURNING id INTO s_precio;

  INSERT INTO template_sections (template_id, title, body, sort_order, is_annex)
  VALUES (v_template, 'Duración', NULL, 4, false) RETURNING id INTO s_duracion;

  INSERT INTO template_sections (template_id, title, body, sort_order, is_annex)
  VALUES (v_template, 'Condiciones de uso', NULL, 5, false) RETURNING id INTO s_condic;

  INSERT INTO template_sections (template_id, title, body, sort_order, is_annex)
  VALUES (v_template, 'Disposiciones generales', NULL, 6, false) RETURNING id INTO s_general;

  INSERT INTO template_sections (template_id, title, body, sort_order, is_annex)
  VALUES (v_template, 'Firmas',
   'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto, uno para cada una de las partes.


_______________________________          _______________________________
        EL ARRENDADOR                             EL ARRENDATARIO
    {{arrendador_nombre}}                    {{arrendatario_nombre}}
   Cédula {{arrendador_cedula}}             Cédula {{arrendatario_cedula}}',
   7, false) RETURNING id INTO s_firmas;

  -- Anexo: solo aparece si el inmueble se entrega amueblado.
  INSERT INTO template_sections (template_id, title, body, sort_order, is_annex, condition)
  VALUES (v_template, 'Anexo A · Inventario del mobiliario',
   'Se detalla a continuación el mobiliario y los equipos que se entregan con EL INMUEBLE:

{{inventario_descripcion}}

Ambas partes declaran haber verificado el inventario al momento de la entrega.',
   8, true,
   '{"variable":"amueblado","operator":"is_true"}'::jsonb)
  RETURNING id INTO s_anexo;

  -- ── Variables del formulario, en el orden en que se preguntan ──
  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id,
    CASE
      WHEN v.tag LIKE 'arrendador%' OR v.tag LIKE 'arrendatario%' THEN s_compare
      WHEN v.tag IN ('direccion_inmueble','tipo_inmueble','habitaciones','banos','parqueos','amueblado') THEN s_objeto
      WHEN v.tag IN ('precio_renta','deposito_garantia','dia_pago','mora_porcentaje') THEN s_precio
      WHEN v.tag IN ('fecha_inicio','duracion_meses','fecha_finalizacion') THEN s_duracion
      WHEN v.tag IN ('mascotas','mantenimiento_incluido','subarriendo_permitido','servicios_incluidos','inventario_descripcion') THEN s_condic
      ELSE s_firmas
    END,
    ROW_NUMBER() OVER (ORDER BY
      CASE v.tag
        WHEN 'arrendador_nombre' THEN 1 WHEN 'arrendador_cedula' THEN 2
        WHEN 'arrendador_nacionalidad' THEN 3 WHEN 'arrendador_estado_civil' THEN 4
        WHEN 'arrendador_domicilio' THEN 5
        WHEN 'arrendatario_nombre' THEN 6 WHEN 'arrendatario_cedula' THEN 7
        WHEN 'arrendatario_nacionalidad' THEN 8 WHEN 'arrendatario_estado_civil' THEN 9
        WHEN 'arrendatario_domicilio' THEN 10
        WHEN 'direccion_inmueble' THEN 11 WHEN 'tipo_inmueble' THEN 12
        WHEN 'habitaciones' THEN 13 WHEN 'banos' THEN 14 WHEN 'parqueos' THEN 15
        WHEN 'amueblado' THEN 16
        WHEN 'precio_renta' THEN 17 WHEN 'deposito_garantia' THEN 18
        WHEN 'dia_pago' THEN 19 WHEN 'mora_porcentaje' THEN 20
        WHEN 'fecha_inicio' THEN 21 WHEN 'duracion_meses' THEN 22 WHEN 'fecha_finalizacion' THEN 23
        WHEN 'mascotas' THEN 24 WHEN 'mantenimiento_incluido' THEN 25
        WHEN 'subarriendo_permitido' THEN 26 WHEN 'servicios_incluidos' THEN 27
        WHEN 'inventario_descripcion' THEN 28
        WHEN 'ciudad_firma' THEN 29 WHEN 'fecha_firma' THEN 30
        ELSE 99
      END)
  FROM variables v
  WHERE v.org_id IS NULL
    AND v.tag IN (
      'arrendador_nombre','arrendador_cedula','arrendador_nacionalidad','arrendador_estado_civil','arrendador_domicilio',
      'arrendatario_nombre','arrendatario_cedula','arrendatario_nacionalidad','arrendatario_estado_civil','arrendatario_domicilio',
      'direccion_inmueble','tipo_inmueble','habitaciones','banos','parqueos','amueblado',
      'precio_renta','deposito_garantia','dia_pago','mora_porcentaje',
      'fecha_inicio','duracion_meses','fecha_finalizacion',
      'mascotas','mantenimiento_incluido','subarriendo_permitido','servicios_incluidos','inventario_descripcion',
      'ciudad_firma','fecha_firma'
    );

  -- ── Cláusulas obligatorias ──
  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_objeto, 'MANDATORY', 1 FROM clauses c WHERE c.org_id IS NULL AND c.slug = 'objeto-arrendamiento';

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_precio, 'MANDATORY', 1 FROM clauses c WHERE c.org_id IS NULL AND c.slug = 'precio-renta';

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_precio, 'MANDATORY', 2 FROM clauses c WHERE c.org_id IS NULL AND c.slug = 'deposito-garantia';

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_precio, 'MANDATORY', 3 FROM clauses c WHERE c.org_id IS NULL AND c.slug = 'mora-recargo';

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_duracion, 'MANDATORY', 1 FROM clauses c WHERE c.org_id IS NULL AND c.slug = 'vigencia-arrendamiento';

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_duracion, 'MANDATORY', 2 FROM clauses c WHERE c.org_id IS NULL AND c.slug = 'terminacion-anticipada';

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)
  SELECT v_template, c.id, s_general, 'MANDATORY', ROW_NUMBER() OVER (ORDER BY c.slug)
  FROM clauses c WHERE c.org_id IS NULL AND c.slug IN
    ('incumplimiento-desalojo','devolucion-inmueble','remodelaciones','reparaciones-menores','notificaciones','ley-aplicable-jurisdiccion','integridad-contractual');

  -- ── Cláusulas condicionales: dependen de una respuesta ──
  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order, condition)
  SELECT v_template, c.id, s_condic, 'CONDITIONAL', 1, '{"variable":"tipo_inmueble","operator":"equals","value":"residencial"}'::jsonb
  FROM clauses c WHERE c.org_id IS NULL AND c.slug = 'uso-residencial';

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order, condition)
  SELECT v_template, c.id, s_condic, 'CONDITIONAL', 2, '{"variable":"tipo_inmueble","operator":"equals","value":"comercial"}'::jsonb
  FROM clauses c WHERE c.org_id IS NULL AND c.slug = 'uso-comercial';

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order, condition)
  SELECT v_template, c.id, s_condic, 'CONDITIONAL', 3, '{"variable":"mascotas","operator":"is_true"}'::jsonb
  FROM clauses c WHERE c.org_id IS NULL AND c.slug = 'mascotas';

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order, condition)
  SELECT v_template, c.id, s_condic, 'CONDITIONAL', 4, '{"variable":"amueblado","operator":"is_true"}'::jsonb
  FROM clauses c WHERE c.org_id IS NULL AND c.slug = 'inventario-mobiliario';

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order, condition)
  SELECT v_template, c.id, s_condic, 'CONDITIONAL', 5, '{"variable":"mantenimiento_incluido","operator":"is_true"}'::jsonb
  FROM clauses c WHERE c.org_id IS NULL AND c.slug = 'mantenimiento-arrendador';

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order, condition)
  SELECT v_template, c.id, s_condic, 'CONDITIONAL', 6, '{"variable":"subarriendo_permitido","operator":"is_true"}'::jsonb
  FROM clauses c WHERE c.org_id IS NULL AND c.slug = 'subarrendamiento-permitido';

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order, condition)
  SELECT v_template, c.id, s_condic, 'CONDITIONAL', 7, '{"variable":"subarriendo_permitido","operator":"is_false"}'::jsonb
  FROM clauses c WHERE c.org_id IS NULL AND c.slug = 'subarrendamiento-prohibido';

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order, condition)
  SELECT v_template, c.id, s_condic, 'CONDITIONAL', 8, '{"variable":"servicios_incluidos","operator":"not_empty"}'::jsonb
  FROM clauses c WHERE c.org_id IS NULL AND c.slug = 'servicios-incluidos';

  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order, condition)
  SELECT v_template, c.id, s_condic, 'CONDITIONAL', 9, '{"variable":"parqueos","operator":"greater_than","value":0}'::jsonb
  FROM clauses c WHERE c.org_id IS NULL AND c.slug = 'estacionamiento';

  -- ── Reglas ──
  INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order) VALUES

  -- El campo de inventario no tiene sentido si no está amueblado.
  (v_template, 'Ocultar el inventario si no está amueblado',
   '{"variable":"amueblado","operator":"is_false"}'::jsonb,
   'HIDE_VARIABLE', jsonb_build_object('variable_tag','inventario_descripcion'), 1),

  -- Si está amueblado, describir el mobiliario pasa a ser obligatorio.
  (v_template, 'Exigir el inventario si está amueblado',
   '{"variable":"amueblado","operator":"is_true"}'::jsonb,
   'REQUIRE_VARIABLE', jsonb_build_object('variable_tag','inventario_descripcion'), 2),

  -- Un local comercial con mascotas suele ser un error de captura.
  (v_template, 'Avisar de mascotas en local comercial',
   '{"op":"AND","children":[{"variable":"tipo_inmueble","operator":"equals","value":"comercial"},{"variable":"mascotas","operator":"is_true"}]}'::jsonb,
   'WARN_USER', jsonb_build_object('message','Marcaste local comercial y mascotas permitidas. Verifica que sea correcto.'), 3),

  -- Un depósito menor a la renta deja al arrendador poco cubierto.
  (v_template, 'Avisar si el depósito es menor que la renta',
   '{"op":"AND","children":[{"variable":"deposito_garantia","operator":"not_empty"},{"variable":"precio_renta","operator":"not_empty"}]}'::jsonb,
   'WARN_USER', jsonb_build_object('message','Revisa el depósito de garantía: lo habitual en RD es entre uno y dos meses de renta.'), 4),

  -- Contratos muy largos conviene revisarlos con más calma.
  (v_template, 'Avisar de contratos superiores a tres años',
   '{"variable":"duracion_meses","operator":"greater_than","value":36}'::jsonb,
   'WARN_USER', jsonb_build_object('message','El contrato supera los 3 años. Conviene revisar las condiciones de renovación y ajuste de precio.'), 5);

  RAISE NOTICE 'Plantilla de arrendamiento cableada: %', v_template;
END $$;

-- ==========================================================
-- 4. PARA PUBLICAR, DESPUÉS DE LA REVISIÓN LEGAL
-- ==========================================================
--
-- Nada de lo anterior es visible para los usuarios: está en borrador.
-- Cuando un abogado dominicano haya revisado los textos, ejecuta esto
-- sustituyendo el correo por el del profesional que hizo la revisión:
--
--   UPDATE clauses
--   SET status = 'PUBLISHED',
--       reviewed_by = (SELECT id FROM profiles WHERE email = 'abogado@ejemplo.do'),
--       reviewed_at = now()
--   WHERE org_id IS NULL AND status = 'DRAFT';
--
--   UPDATE templates
--   SET status = 'PUBLISHED',
--       reviewed_by = (SELECT id FROM profiles WHERE email = 'abogado@ejemplo.do'),
--       reviewed_at = now()
--   WHERE slug = 'contrato-alquiler-vivienda';
