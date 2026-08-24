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

-- PARTE 0 de 10: cláusulas y variables. Ejecutar PRIMERO.

-- ══════════════ CLÁUSULAS ══════════════

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-definiciones', 'Definiciones', 'Generales', 'Fija el significado de los términos que se repiten en el contrato.',
  'DEFINICIONES. Para los efectos del presente contrato, los términos que aparezcan en mayúscula inicial tendrán el significado que se les atribuye en esta cláusula o en el cuerpo del documento. El singular comprende el plural y viceversa, salvo que el contexto indique lo contrario.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-obligaciones-partes', 'Obligaciones de las partes', 'Generales', 'Declaración general del deber de cumplir de buena fe.',
  'OBLIGACIONES. Las partes se obligan a cumplir de buena fe todas y cada una de las estipulaciones del presente contrato, así como aquellas obligaciones que, sin estar expresamente pactadas, se deriven de la naturaleza del acuerdo, de la equidad, del uso o de la ley.',
  'Código Civil Dominicano, artículo 1135', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-renovacion-automatica', 'Renovación automática', 'Generales', 'El contrato se prorroga solo si nadie avisa lo contrario.',
  'RENOVACIÓN. Al vencimiento del plazo pactado, el presente contrato se entenderá prorrogado automáticamente por períodos iguales y sucesivos, salvo que cualquiera de las partes comunique a la otra, por escrito y con al menos treinta (30) días de anticipación, su voluntad de no renovarlo.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-terminacion-mutuo-acuerdo', 'Terminación por mutuo acuerdo', 'Generales', 'Ambas partes pueden terminar de común acuerdo.',
  'TERMINACIÓN POR MUTUO ACUERDO. Las partes podrán poner fin al presente contrato en cualquier momento, mediante acuerdo escrito y firmado por ambas, en el que se establecerán las condiciones de liquidación de las obligaciones pendientes.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-penalidad', 'Penalidad por incumplimiento', 'Generales', 'Cláusula penal por incumplimiento de las obligaciones.',
  'CLÁUSULA PENAL. La parte que incumpla cualquiera de las obligaciones esenciales del presente contrato pagará a la otra, a título de cláusula penal y sin necesidad de puesta en mora previa, la suma de {{monto_penalidad_letras}}, sin perjuicio del derecho de la parte cumplidora a exigir la ejecución forzosa del contrato o su resolución, y la reparación de los daños que excedan dicha suma.',
  'Código Civil Dominicano, artículos 1226 y siguientes', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-intereses-moratorios', 'Intereses moratorios', 'Generales', 'Interés que corre sobre las sumas vencidas.',
  'INTERESES MORATORIOS. Toda suma vencida y no pagada devengará, de pleno derecho y sin necesidad de intimación, un interés moratorio de {{interes_mora_porcentaje}} mensual, calculado desde la fecha de vencimiento y hasta el día del pago efectivo.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-fuerza-mayor', 'Fuerza mayor y caso fortuito', 'Generales', 'Suspende obligaciones ante hechos imprevisibles e irresistibles.',
  'FUERZA MAYOR. Ninguna de las partes será responsable por el incumplimiento de sus obligaciones cuando este obedezca a caso fortuito o fuerza mayor, entendiéndose por tales los hechos imprevisibles e irresistibles ajenos a su voluntad, incluyendo desastres naturales, huracanes, terremotos, actos de autoridad, conmoción civil o epidemias declaradas. La parte afectada deberá notificar a la otra dentro de los cinco (5) días siguientes al hecho, y las obligaciones quedarán suspendidas mientras dure el impedimento. Si este se prolonga por más de sesenta (60) días, cualquiera de las partes podrá resolver el contrato sin responsabilidad.',
  'Código Civil Dominicano, artículos 1147 y 1148', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-arbitraje', 'Arbitraje', 'Generales', 'Somete las controversias a arbitraje en lugar de a los tribunales.',
  'ARBITRAJE. Toda controversia derivada del presente contrato, o que guarde relación con él, será resuelta definitivamente mediante arbitraje de derecho administrado por el Centro de Resolución Alternativa de Controversias de la Cámara de Comercio y Producción de Santo Domingo, conforme a su reglamento vigente. El tribunal arbitral estará compuesto por un (1) árbitro, el arbitraje tendrá su sede en la República Dominicana y se conducirá en idioma español. El laudo será definitivo y obligatorio para las partes.',
  'Ley 489-08 sobre Arbitraje Comercial', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-mediacion-previa', 'Mediación previa', 'Generales', 'Obliga a intentar un acuerdo antes de demandar.',
  'MEDIACIÓN PREVIA. Antes de acudir a la vía judicial o arbitral, las partes se obligan a intentar de buena fe una solución amigable mediante mediación, por un plazo no menor de treinta (30) días contados desde la notificación escrita de la controversia. El incumplimiento de este requisito no impedirá el ejercicio de las acciones que correspondan una vez transcurrido dicho plazo.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-divisibilidad', 'Divisibilidad', 'Generales', 'Si una cláusula es nula, el resto del contrato sigue vigente.',
  'DIVISIBILIDAD. Si alguna disposición del presente contrato fuera declarada nula, inválida o inejecutable por autoridad competente, dicha declaración no afectará la validez de las restantes disposiciones, que continuarán vigentes. Las partes se obligan a sustituir la disposición afectada por otra válida que se aproxime en lo posible a la finalidad económica perseguida.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-seguro-bienes', 'Seguro de los bienes', 'Generales', 'Quién asegura los bienes que cubre el contrato y hasta dónde responde cada parte.',
  'SEGURO. {{parte_responsable_seguro}} mantendrá vigente, durante toda la vigencia del presente contrato y a su exclusivo costo, una póliza de seguro que cubra los bienes objeto del mismo contra los riesgos habituales de pérdida, daño, incendio y robo, así como la responsabilidad civil frente a terceros derivada de su uso u operación. La otra parte podrá exigir en cualquier momento la exhibición de la póliza y de los recibos de prima al día. La existencia del seguro no libera a la parte responsable de los daños que excedan la cobertura contratada ni de los causados por dolo o falta grave.',
  'Ley 146-02 sobre Seguros y Fianzas de la República Dominicana', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-devolucion-bien', 'Devolución del bien', 'Generales', 'Cómo y en qué estado se devuelve el bien al terminar el contrato.',
  'DEVOLUCIÓN. Al vencimiento del presente contrato o al producirse su terminación por cualquier causa, la parte que tenga el bien en su poder se obliga a devolverlo de inmediato en el mismo estado en que lo recibió, salvo el desgaste normal derivado del uso convenido, con todos sus accesorios, documentos y llaves, y libre de gravámenes, multas o cargos generados durante el período de uso. Las partes levantarán un acta de devolución en la que se hará constar el estado del bien; los daños que consten en dicha acta serán de cargo de la parte que lo devuelve.',
  'Código Civil Dominicano, artículos 1730 y 1731', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-objeto-uso-bien', 'Objeto y uso del bien', 'Generales', 'Qué bien se cede y para qué puede usarse, sin suponer que es un inmueble.',
  'OBJETO. Por el presente contrato, LA PRIMERA PARTE cede a LA SEGUNDA PARTE el uso del bien descrito en este documento, en adelante EL BIEN, el cual será destinado exclusivamente a {{destino_uso}}. LA SEGUNDA PARTE declara recibir EL BIEN en buen estado de conservación y funcionamiento, y se obliga a emplearlo conforme a su naturaleza y al destino convenido, sin poder cambiarlo ni cederlo a terceros sin autorización previa y por escrito de LA PRIMERA PARTE.',
  'Código Civil Dominicano, artículos 1709 y siguientes', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'e-precio-alquiler', 'Precio del alquiler', 'Económicas', 'Cuánto se paga por el uso del bien y cuándo, sin suponer que es un inmueble.',
  'PRECIO. El precio por el uso de EL BIEN se fija en la suma de {{precio_alquiler_letras}} por cada {{periodo_alquiler}}, que LA SEGUNDA PARTE se obliga a pagar por adelantado, a más tardar el día {{dia_pago}} de cada período, mediante transferencia a la cuenta que LA PRIMERA PARTE indique o en el domicilio de esta. El pago deberá hacerse sin necesidad de requerimiento previo y no podrá compensarse ni retenerse por reclamaciones pendientes entre las partes.',
  'Código Civil Dominicano, artículo 1728', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-notificaciones', 'Notificaciones', 'Generales', 'Dónde y cómo se notifican las partes, sin atarlo a un inmueble.',
  'NOTIFICACIONES. Para todos los fines del presente contrato, LA PRIMERA PARTE elige domicilio en {{parte_primera_domicilio}} y LA SEGUNDA PARTE en {{parte_segunda_domicilio}}. Toda notificación, requerimiento o comunicación relacionada con este contrato se reputará válidamente hecha si se entrega en dichos domicilios mediante acto de alguacil, correo certificado con acuse de recibo o entrega personal con constancia escrita. Cualquier cambio de domicilio deberá comunicarse a la otra parte por escrito dentro de los diez (10) días siguientes; mientras no se comunique, las notificaciones hechas al domicilio anterior conservarán plena validez.',
  'Código de Procedimiento Civil Dominicano, artículos 68 y siguientes', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-ley-aplicable', 'Ley aplicable y jurisdicción', 'Generales', 'Ley dominicana y tribunales competentes, sin atarlo a un inmueble.',
  'LEY APLICABLE Y JURISDICCIÓN. El presente contrato se rige por las leyes de la República Dominicana. Para el conocimiento de cualquier controversia derivada de su interpretación, ejecución o terminación, las partes se someten voluntariamente a la competencia de los tribunales del Distrito Judicial de {{distrito_judicial}}, renunciando expresamente a cualquier otro fuero que pudiera corresponderles.',
  'Código de Procedimiento Civil Dominicano; Ley 834 de 1978', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-cesion-prohibida', 'Prohibición de cesión', 'Generales', 'Impide traspasar el contrato a un tercero.',
  'CESIÓN. Ninguna de las partes podrá ceder, transferir ni delegar, total ni parcialmente, los derechos y obligaciones derivados del presente contrato sin el consentimiento previo y por escrito de la otra parte. Toda cesión realizada en contravención de esta cláusula será nula y de ningún efecto.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-cesion-permitida', 'Cesión autorizada', 'Generales', 'Permite ceder el contrato avisando previamente.',
  'CESIÓN. Cualquiera de las partes podrá ceder los derechos y obligaciones derivados del presente contrato a una sociedad de su mismo grupo económico o como consecuencia de una fusión, escisión o transferencia de activos, comunicándolo por escrito a la otra parte con al menos quince (15) días de anticipación. El cedente continuará siendo solidariamente responsable del cumplimiento de las obligaciones cedidas.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-modificaciones', 'Modificaciones', 'Generales', 'Todo cambio debe constar por escrito.',
  'MODIFICACIONES. Ninguna modificación, adición o renuncia a las disposiciones del presente contrato surtirá efecto si no consta por escrito y está firmada por ambas partes. La tolerancia de una de las partes ante el incumplimiento de la otra no constituirá renuncia a exigir su cumplimiento en el futuro.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-declaraciones-partes', 'Declaraciones de las partes', 'Generales', 'Las partes declaran tener capacidad y facultades para contratar.',
  'DECLARACIONES. Cada parte declara y garantiza a la otra que: (a) tiene plena capacidad legal para celebrar el presente contrato; (b) quien lo suscribe cuenta con las facultades suficientes para obligarla; (c) la celebración de este contrato no infringe ninguna obligación previamente asumida; y (d) la información suministrada a la otra parte es veraz y completa.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-encabezados', 'Encabezados y anexos', 'Generales', 'Los títulos son orientativos y los anexos forman parte del contrato.',
  'ENCABEZADOS Y ANEXOS. Los títulos de las cláusulas se incluyen únicamente para facilitar la lectura y no afectan la interpretación del contrato. Los anexos que se acompañan forman parte integrante e inseparable del mismo y se entienden aceptados por ambas partes.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-idioma-ejemplares', 'Idioma y ejemplares', 'Generales', 'Idioma del contrato y número de originales.',
  'IDIOMA Y EJEMPLARES. El presente contrato se otorga en idioma español, que prevalecerá sobre cualquier traducción. Se firma en {{cantidad_ejemplares}} ejemplares de un mismo tenor y efecto, quedando uno en poder de cada parte.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-firma-electronica', 'Firma electrónica', 'Generales', 'Reconoce validez a la firma en medios electrónicos.',
  'FIRMA ELECTRÓNICA. Las partes reconocen expresamente la validez y eficacia jurídica de la firma electrónica y de los documentos digitales, conforme a la legislación dominicana sobre comercio electrónico, documentos y firmas digitales, y aceptan que el presente contrato pueda ser suscrito por dichos medios.',
  'Ley 126-02 sobre Comercio Electrónico, Documentos y Firmas Digitales', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-domicilio-eleccion', 'Elección de domicilio', 'Generales', 'Domicilio elegido por cada parte para notificaciones.',
  'ELECCIÓN DE DOMICILIO. Para todos los fines y consecuencias del presente contrato, las partes eligen domicilio en las direcciones consignadas en el encabezamiento, donde se reputarán válidas todas las notificaciones, citaciones y actos procesales que se realicen.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-buena-fe', 'Buena fe contractual', 'Generales', 'Compromiso de ejecutar el contrato de buena fe.',
  'BUENA FE. Las partes declaran haber negociado y suscrito el presente contrato de buena fe y se obligan a ejecutarlo con la misma diligencia, absteniéndose de toda conducta que pueda frustrar su finalidad o perjudicar los legítimos intereses de la otra parte.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'g-solucion-controversias', 'Escalamiento de controversias', 'Generales', 'Escalonamiento: negociación, luego mediación, luego tribunales.',
  'SOLUCIÓN DE CONTROVERSIAS. Ante cualquier desacuerdo, las partes se obligan a agotar en orden las siguientes instancias: (a) negociación directa entre los representantes designados, por quince (15) días; (b) mediación ante un tercero imparcial, por treinta (30) días adicionales; y (c) solo agotadas las anteriores, la vía judicial o arbitral que corresponda.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'e-precio-servicios', 'Precio de los servicios', 'Económicas', 'Honorarios pactados por los servicios.',
  'PRECIO. Como contraprestación por los servicios objeto del presente contrato, EL CLIENTE pagará a EL PRESTADOR la suma de {{monto_total_letras}}, monto que no incluye los impuestos aplicables conforme a la legislación dominicana vigente.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'e-forma-pago', 'Forma de pago', 'Económicas', 'Medio y plazo en que se realiza el pago.',
  'FORMA DE PAGO. Los pagos se realizarán mediante transferencia bancaria a la cuenta que indique la parte acreedora, dentro de los {{dias_pago}} días siguientes a la recepción de la factura correspondiente. Los gastos y comisiones bancarias correrán por cuenta del ordenante.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'e-pago-anticipado', 'Pago anticipado', 'Económicas', 'Adelanto que se entrega al inicio.',
  'PAGO ANTICIPADO. A la firma del presente contrato, EL CLIENTE entregará un anticipo equivalente al {{anticipo_porcentaje}} del precio total pactado. Dicho anticipo se imputará al pago final y no será reembolsable si la terminación del contrato obedece a causa imputable a EL CLIENTE.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'e-pago-cuotas', 'Pago por cuotas', 'Económicas', 'Precio dividido en pagos periódicos.',
  'PAGO POR CUOTAS. El precio se pagará en {{cantidad_cuotas}} cuotas iguales y consecutivas de {{monto_cuota_letras}} cada una, pagaderas el día {{dia_pago}} de cada mes. La falta de pago de dos (2) cuotas consecutivas producirá la caducidad del plazo y hará exigible la totalidad del saldo pendiente.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'e-comision-porcentaje', 'Comisión sobre ventas', 'Económicas', 'Comisión calculada como porcentaje.',
  'COMISIÓN. Se pagará una comisión equivalente al {{comision_porcentaje}} sobre el valor neto de cada operación efectivamente cobrada, excluidos impuestos. La comisión se liquidará dentro de los primeros diez (10) días de cada mes respecto de las operaciones cobradas en el mes anterior.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'e-deposito-general', 'Depósito en garantía', 'Económicas', 'Suma retenida como garantía de cumplimiento.',
  'DEPÓSITO. Se constituye un depósito en garantía por la suma de {{deposito_letras}}, destinado exclusivamente a responder por los daños o incumplimientos imputables a la parte obligada. Dicho depósito no genera intereses y será devuelto dentro de los treinta (30) días siguientes a la terminación del contrato, previa deducción de las sumas que resulten adeudadas.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'e-reembolso-gastos', 'Reembolso de gastos', 'Económicas', 'Gastos que se reembolsan contra comprobante.',
  'REEMBOLSO DE GASTOS. Los gastos razonables y documentados en que incurra una parte por cuenta de la otra en ejecución del presente contrato serán reembolsados dentro de los quince (15) días siguientes a la presentación de los comprobantes fiscales correspondientes, siempre que hayan sido autorizados previamente por escrito.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'e-gastos-cada-parte', 'Gastos a cargo de cada parte', 'Económicas', 'Cada parte asume sus propios gastos.',
  'GASTOS. Salvo pacto expreso en contrario, cada parte asumirá los gastos, honorarios y tributos que le correspondan por la negociación, formalización y ejecución del presente contrato, incluidos los honorarios de sus asesores legales.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'e-ajuste-precio-anual', 'Ajuste anual del precio', 'Económicas', 'Actualización periódica del precio pactado.',
  'AJUSTE DE PRECIO. Transcurridos doce (12) meses desde el inicio del contrato, el precio podrá ser ajustado anualmente en un porcentaje no superior a la variación del Índice de Precios al Consumidor publicado por el Banco Central de la República Dominicana para el período correspondiente. El ajuste deberá comunicarse por escrito con treinta (30) días de anticipación.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'e-penalidad-retraso', 'Penalidad por retraso en la entrega', 'Económicas', 'Multa diaria por demora en cumplir.',
  'PENALIDAD POR RETRASO. El retraso injustificado en la entrega o en la prestación pactada generará una penalidad equivalente al {{penalidad_diaria_porcentaje}} del valor del contrato por cada día de demora, hasta un máximo del diez por ciento (10%) del precio total, sin perjuicio del derecho de la parte afectada a resolver el contrato.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'e-impuestos-retenciones', 'Impuestos y retenciones', 'Económicas', 'Reparto de la carga tributaria.',
  'IMPUESTOS. Los montos pactados no incluyen el Impuesto sobre Transferencias de Bienes Industrializados y Servicios (ITBIS) ni cualquier otro tributo aplicable, que serán facturados adicionalmente cuando corresponda. Cada parte será responsable de las retenciones y declaraciones que le imponga la legislación tributaria dominicana.',
  'Código Tributario Dominicano, Ley 11-92', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'e-facturacion', 'Facturación', 'Económicas', 'Requisitos formales de las facturas.',
  'FACTURACIÓN. Toda factura emitida en virtud del presente contrato deberá contener Número de Comprobante Fiscal válido y cumplir los requisitos que exija la Dirección General de Impuestos Internos. La parte obligada al pago podrá rechazar, dentro de los cinco (5) días siguientes a su recepción, cualquier factura que no cumpla dichos requisitos.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'e-moneda-pago', 'Moneda de pago', 'Económicas', 'Moneda y conversión aplicable.',
  'MONEDA. Todos los pagos se efectuarán en {{moneda_contrato}}. Cuando el pago deba realizarse en moneda distinta a la pactada, se aplicará la tasa de cambio de venta publicada por el Banco Central de la República Dominicana el día hábil anterior a la fecha de pago.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'e-retencion-garantia', 'Retención en garantía de obra', 'Económicas', 'Porcentaje retenido hasta la recepción definitiva.',
  'RETENCIÓN EN GARANTÍA. De cada pago se retendrá un {{retencion_porcentaje}} en concepto de garantía de buena ejecución. Las sumas retenidas serán liberadas dentro de los sesenta (60) días siguientes a la recepción definitiva de la obra, siempre que no existan vicios pendientes de subsanar.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'i-servicios-excluidos', 'Servicios excluidos', 'Inmobiliarias', 'Servicios que no cubre la renta.',
  'SERVICIOS EXCLUIDOS. La renta pactada no comprende los servicios de energía eléctrica, agua potable, gas, telefonía, internet, televisión por suscripción ni recogida de basura, cuyo pago corresponde íntegramente a EL ARRENDATARIO. La falta de pago de dichos servicios se considerará incumplimiento contractual.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'i-entrega-inmueble', 'Entrega del inmueble', 'Inmobiliarias', 'Momento y estado de la entrega.',
  'ENTREGA. EL ARRENDADOR entregará EL INMUEBLE a EL ARRENDATARIO el {{fecha_entrega_larga}}, en buen estado de habitabilidad, con todos sus servicios funcionando y libre de ocupantes. De la entrega se levantará un acta firmada por ambas partes, en la que se hará constar el estado del inmueble y la lectura de los contadores.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'i-inspeccion-periodica', 'Inspección del inmueble', 'Inmobiliarias', 'Derecho del arrendador a inspeccionar con aviso.',
  'INSPECCIÓN. EL ARRENDADOR podrá inspeccionar EL INMUEBLE para verificar su estado de conservación, previa comunicación a EL ARRENDATARIO con al menos cuarenta y ocho (48) horas de anticipación y en horario razonable. EL ARRENDATARIO no podrá negar el acceso sin causa justificada.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'i-pintura-conservacion', 'Pintura y conservación', 'Inmobiliarias', 'Obligación de devolver el inmueble pintado.',
  'PINTURA. EL ARRENDATARIO se obliga a devolver EL INMUEBLE recién pintado en colores neutros, o a abonar a EL ARRENDADOR el costo de dicho trabajo, salvo que la duración del arrendamiento haya sido inferior a doce (12) meses y el inmueble se encuentre en el mismo estado en que fue recibido.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'i-areas-comunes', 'Uso de áreas comunes', 'Inmobiliarias', 'Reglas de uso de las zonas compartidas.',
  'ÁREAS COMUNES. EL ARRENDATARIO podrá hacer uso de las áreas comunes del inmueble conforme a su destino y al reglamento aplicable, respetando los horarios establecidos y absteniéndose de causar molestias a los demás ocupantes. Los daños que ocasione en dichas áreas serán de su exclusiva responsabilidad.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'i-reglamento-condominio', 'Reglamento de condominio', 'Inmobiliarias', 'Sujeción al reglamento interno del condominio.',
  'REGLAMENTO DE CONDOMINIO. EL ARRENDATARIO declara conocer y aceptar el reglamento interno del condominio en que se ubica EL INMUEBLE, obligándose a cumplirlo en todos sus términos. Las multas o sanciones que se le impongan por su incumplimiento serán de su exclusiva cuenta.',
  'Ley 5038 sobre Condominios', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'i-seguro-inmueble', 'Seguro del inmueble', 'Inmobiliarias', 'Quién asegura el inmueble y su contenido.',
  'SEGURO. EL ARRENDADOR mantendrá vigente una póliza de seguro que cubra la estructura de EL INMUEBLE. EL ARRENDATARIO será responsable de asegurar sus bienes muebles y su responsabilidad civil frente a terceros, sin que EL ARRENDADOR responda por pérdidas o daños sufridos por aquellos.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'i-descripcion-inmueble', 'Descripción del inmueble', 'Inmobiliarias', 'Identificación registral y física del inmueble.',
  'DESCRIPCIÓN DEL INMUEBLE. EL INMUEBLE objeto del presente contrato se identifica como {{descripcion_registral}}, ubicado en {{direccion_inmueble}}, con una superficie aproximada de {{superficie_metros}} metros cuadrados, amparado en el Certificado de Título número {{certificado_titulo}}.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'i-garantia-saneamiento', 'Garantía de saneamiento', 'Inmobiliarias', 'El vendedor garantiza la propiedad frente a terceros.',
  'SANEAMIENTO. EL VENDEDOR garantiza a EL COMPRADOR la posesión pacífica y útil del inmueble vendido, y responde por la evicción y por los vicios ocultos conforme a la ley. Declara que el inmueble se encuentra libre de gravámenes, hipotecas, embargos, litigios y de toda carga que limite su libre disposición.',
  'Código Civil Dominicano, artículos 1625 y siguientes', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'i-transferencia-propiedad', 'Transferencia de propiedad', 'Inmobiliarias', 'Momento en que se transfiere el dominio.',
  'TRANSFERENCIA. La transferencia del derecho de propiedad se perfeccionará con la inscripción del presente acto por ante el Registro de Títulos correspondiente. Los gastos de transferencia, impuestos y honorarios que dicha inscripción genere correrán por cuenta de {{parte_paga_transferencia}}.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'b-exclusividad', 'Exclusividad', 'Empresariales', 'Concede derechos en exclusiva.',
  'EXCLUSIVIDAD. Durante la vigencia del presente contrato, se concede a {{parte_exclusiva}} el derecho exclusivo de {{objeto_exclusividad}} dentro del territorio pactado. La parte concedente se abstendrá de designar a terceros para los mismos fines, así como de operar directamente en dicho territorio.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'b-no-exclusividad', 'No exclusividad', 'Empresariales', 'Aclara que la relación no es exclusiva.',
  'NO EXCLUSIVIDAD. Las partes declaran expresamente que la presente relación no tiene carácter exclusivo. Cada una conserva el derecho de contratar con terceros servicios o productos iguales o similares, sin que ello constituya incumplimiento ni genere derecho a indemnización alguna.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'b-territorio', 'Territorio', 'Empresariales', 'Ámbito geográfico de la relación.',
  'TERRITORIO. Los derechos y obligaciones derivados del presente contrato se circunscriben al territorio de {{territorio_contrato}}. Cualquier actuación fuera de dicho ámbito requerirá autorización previa y por escrito de la otra parte.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'b-referidos', 'Comisión por referidos', 'Empresariales', 'Retribución por clientes referidos.',
  'REFERIDOS. Se reconocerá una comisión del {{comision_referido_porcentaje}} sobre el primer contrato efectivamente cobrado que se celebre con cada cliente presentado por la parte referidora, siempre que dicho cliente no hubiera mantenido relación comercial previa y que la presentación se haya documentado por escrito.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'b-confidencialidad', 'Confidencialidad', 'Empresariales', 'Obligación de reserva sobre la información recibida.',
  'CONFIDENCIALIDAD. Las partes se obligan a mantener estricta reserva sobre toda información técnica, comercial, financiera o de cualquier otra naturaleza a la que accedan con motivo del presente contrato, y a no divulgarla ni utilizarla para fines distintos a su ejecución. Esta obligación subsistirá durante {{anios_confidencialidad}} años contados a partir de la terminación del contrato. Se exceptúa la información que sea de dominio público sin culpa de la parte receptora, o cuya divulgación sea ordenada por autoridad competente.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'b-no-competencia', 'No competencia', 'Empresariales', 'Restricción de competir tras terminar el contrato.',
  'NO COMPETENCIA. Durante la vigencia del presente contrato y por {{meses_no_competencia}} meses posteriores a su terminación, la parte obligada se abstendrá de desarrollar, por cuenta propia o ajena, actividades que compitan directamente con el objeto de este contrato dentro del territorio pactado. Esta restricción se entiende limitada en tiempo, espacio y objeto a lo estrictamente necesario para proteger los intereses legítimos de la otra parte.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'b-propiedad-intelectual', 'Propiedad intelectual', 'Empresariales', 'A quién pertenecen los derechos sobre lo creado.',
  'PROPIEDAD INTELECTUAL. Los derechos patrimoniales sobre las obras, desarrollos, diseños y demás creaciones producidas en ejecución del presente contrato pertenecerán a {{titular_propiedad_intelectual}}, quien podrá explotarlos sin limitación de tiempo, territorio ni modalidad. Los derechos morales del autor permanecen irrenunciablemente en cabeza de su creador.',
  'Ley 65-00 sobre Derecho de Autor', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'b-distribucion', 'Condiciones de distribución', 'Empresariales', 'Obligaciones del distribuidor.',
  'DISTRIBUCIÓN. EL DISTRIBUIDOR se obliga a comercializar los productos objeto del presente contrato en las condiciones, precios y presentaciones que fije EL PROVEEDOR, a mantener un inventario razonable, a preservar la imagen de la marca y a no alterar los productos ni sus empaques.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'b-representacion', 'Alcance de la representación', 'Empresariales', 'Límites de la facultad de representar.',
  'REPRESENTACIÓN. EL REPRESENTANTE actuará en nombre y por cuenta de EL REPRESENTADO únicamente dentro de los límites expresamente conferidos en el presente contrato. No podrá obligar a EL REPRESENTADO más allá de dichas facultades, y responderá personalmente por los actos que excedan el mandato conferido.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'b-relacion-independiente', 'Independencia de las partes', 'Empresariales', 'Aclara que no hay relación laboral ni sociedad.',
  'INDEPENDENCIA. El presente contrato no crea entre las partes relación laboral, sociedad, asociación en participación ni agencia de ningún tipo. Cada parte actúa como contratista independiente, asume sus propios riesgos y responde por las obligaciones laborales y de seguridad social de su personal.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'b-anticorrupcion', 'Cumplimiento y anticorrupción', 'Empresariales', 'Compromiso de no incurrir en prácticas corruptas.',
  'CUMPLIMIENTO NORMATIVO. Las partes declaran no haber ofrecido ni prometido, directa o indirectamente, ventaja alguna a funcionario público o particular para obtener la celebración del presente contrato, y se obligan a cumplir la legislación dominicana en materia de prevención de lavado de activos y de actos de corrupción.',
  'Ley 155-17 contra el Lavado de Activos', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'o-alcance-obra', 'Alcance de la obra', 'Inmobiliarias', 'Qué trabajos comprende la obra y qué queda expresamente fuera.',
  'ALCANCE DE LA OBRA. EL CONTRATISTA ejecutará los trabajos descritos en {{descripcion_obra}}, conforme a los planos, especificaciones técnicas y presupuesto que las partes suscriben y que forman parte integrante del presente contrato. Todo trabajo no comprendido expresamente en dichos documentos constituirá una obra extraordinaria y requerirá acuerdo previo y por escrito sobre su alcance, precio y plazo, sin que su ejecución pueda presumirse por el solo hecho de haberse iniciado. EL CONTRATISTA suministrará la mano de obra, dirección técnica, herramientas y equipos necesarios; los materiales correrán a cargo de {{parte_suministra_materiales}}.',
  'Código Civil Dominicano, artículos 1787 y siguientes', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'o-plazo-obra', 'Plazo de ejecución de la obra', 'Empresariales', 'Tiempo comprometido para terminar la obra.',
  'PLAZO DE OBRA. EL CONTRATISTA se obliga a ejecutar y entregar la obra en un plazo de {{plazo_obra_dias}} días calendario, contados a partir de la fecha de inicio. Este plazo se prorrogará automáticamente por los días de paralización imputables a caso fortuito, fuerza mayor o a hechos de EL PROPIETARIO.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'o-materiales', 'Materiales de la obra', 'Empresariales', 'Quién suministra los materiales y su calidad.',
  'MATERIALES. Los materiales necesarios para la ejecución de la obra serán suministrados por {{parte_suministra_materiales}} y deberán cumplir las especificaciones técnicas del proyecto y las normas dominicanas aplicables. EL PROPIETARIO podrá rechazar todo material que no se ajuste a dichas especificaciones.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'o-recepcion-obra', 'Recepción de la obra', 'Empresariales', 'Recepción provisional y definitiva.',
  'RECEPCIÓN. Concluida la obra, las partes suscribirán un acta de recepción provisional en la que se harán constar las observaciones pendientes. Subsanadas estas, y transcurridos {{dias_recepcion_definitiva}} días sin que aparezcan vicios, se procederá a la recepción definitiva, momento a partir del cual comienza a correr la garantía legal.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'm-derechos-imagen', 'Derechos de imagen', 'Empresariales', 'Autorización para usar imagen o voz.',
  'DERECHOS DE IMAGEN. {{titular_imagen}} autoriza expresamente el uso de su imagen, voz y nombre en los materiales producidos en ejecución del presente contrato, para los fines, medios y territorio aquí pactados y por un plazo de {{anios_uso_imagen}} años. Esta autorización no comprende usos distintos a los expresamente señalados.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'm-entregables-creativos', 'Entregables creativos', 'Empresariales', 'Qué se entrega y cuántas revisiones incluye.',
  'ENTREGABLES. EL PRESTADOR entregará {{descripcion_entregables}}, incluyendo hasta {{cantidad_revisiones}} rondas de revisión sin costo adicional. Las revisiones que excedan dicho número, o los cambios de alcance solicitados por EL CLIENTE, se cotizarán por separado.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'l-salario', 'Salario', 'Laborales', 'Remuneración pactada y su periodicidad.',
  'SALARIO. EL EMPLEADOR pagará a EL TRABAJADOR un salario de {{salario_letras}} mensuales, pagadero por quincenas vencidas, del cual se deducirán las retenciones de ley por concepto de seguridad social e impuesto sobre la renta.',
  'Código de Trabajo, Ley 16-92', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'l-jornada', 'Jornada de trabajo', 'Laborales', 'Horario y duración de la jornada.',
  'JORNADA. La jornada ordinaria de trabajo será de {{horas_semanales}} horas semanales, distribuidas de {{horario_trabajo}}. Las horas trabajadas en exceso se remunerarán con los recargos que establece el Código de Trabajo.',
  'Código de Trabajo, artículos 147 y siguientes', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'l-trabajo-remoto', 'Trabajo remoto', 'Laborales', 'Prestación del servicio a distancia.',
  'TRABAJO REMOTO. EL TRABAJADOR prestará sus servicios de manera remota desde el domicilio que declare, disponiendo de conexión y espacio adecuados. EL EMPLEADOR proveerá las herramientas de trabajo necesarias y EL TRABAJADOR se obliga a cumplir los mismos deberes de diligencia, disponibilidad y confidencialidad que en la modalidad presencial.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'l-trabajo-hibrido', 'Trabajo híbrido', 'Laborales', 'Combinación de presencialidad y trabajo remoto.',
  'MODALIDAD HÍBRIDA. EL TRABAJADOR asistirá presencialmente a las instalaciones de EL EMPLEADOR {{dias_presenciales}} días por semana, prestando el resto de la jornada de forma remota. EL EMPLEADOR podrá modificar razonablemente la distribución, comunicándolo con al menos una (1) semana de anticipación.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'l-vacaciones', 'Vacaciones', 'Laborales', 'Derecho a vacaciones anuales.',
  'VACACIONES. EL TRABAJADOR disfrutará del período de vacaciones anuales remuneradas que le corresponda conforme a su antigüedad y al Código de Trabajo. La fecha de disfrute se acordará entre las partes atendiendo a las necesidades del servicio.',
  'Código de Trabajo, artículos 177 y siguientes', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'l-bonificacion', 'Bonificación', 'Laborales', 'Participación en los beneficios de la empresa.',
  'BONIFICACIÓN. EL TRABAJADOR participará en los beneficios de la empresa en la proporción y condiciones que establece el Código de Trabajo, sin que dicha participación constituya salario ordinario ni genere derecho adquirido cuando la empresa no obtenga beneficios.',
  'Código de Trabajo, artículos 223 y siguientes', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'l-comision-ventas', 'Comisión sobre ventas', 'Laborales', 'Retribución variable ligada a resultados.',
  'COMISIÓN. Adicionalmente al salario fijo, EL TRABAJADOR percibirá una comisión del {{comision_porcentaje}} sobre las ventas netas efectivamente cobradas que gestione. La comisión se liquidará mensualmente y forma parte del salario para todos los efectos legales.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'l-confidencialidad', 'Confidencialidad laboral', 'Laborales', 'Deber de reserva del trabajador.',
  'CONFIDENCIALIDAD. EL TRABAJADOR se obliga a guardar absoluta reserva sobre la información técnica, comercial, financiera y de clientes a la que acceda por razón de su cargo, tanto durante la vigencia del contrato como después de su terminación. El incumplimiento de este deber constituye falta grave.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'l-propiedad-intelectual', 'Creaciones del trabajador', 'Laborales', 'Titularidad de lo creado durante la relación laboral.',
  'CREACIONES. Los derechos patrimoniales sobre las obras, invenciones y desarrollos que EL TRABAJADOR produzca en ejecución de sus funciones y con los recursos de EL EMPLEADOR corresponderán a este último, sin más contraprestación que el salario pactado, quedando a salvo los derechos morales del autor.',
  'Ley 65-00 sobre Derecho de Autor', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'l-equipos-trabajo', 'Equipos de trabajo', 'Laborales', 'Uso y devolución de las herramientas entregadas.',
  'EQUIPOS. EL EMPLEADOR entrega a EL TRABAJADOR los equipos y herramientas necesarios para el desempeño de sus funciones, que continúan siendo propiedad de aquel. EL TRABAJADOR los destinará exclusivamente a fines laborales, responderá por su pérdida o deterioro imputable a su negligencia y los devolverá al terminar la relación.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'l-gastos-reembolsables', 'Gastos del trabajador', 'Laborales', 'Reembolso de gastos incurridos por el trabajador.',
  'GASTOS. EL EMPLEADOR reembolsará a EL TRABAJADOR los gastos de transporte, alojamiento y representación en que incurra por razón de sus funciones, previa autorización y presentación de los comprobantes correspondientes, dentro de los quince (15) días siguientes.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'l-terminacion-laboral', 'Terminación del contrato de trabajo', 'Laborales', 'Causas y efectos de la terminación.',
  'TERMINACIÓN. El presente contrato podrá terminar por las causas previstas en el Código de Trabajo. En caso de desahucio ejercido por EL EMPLEADOR, este pagará el preaviso y el auxilio de cesantía que correspondan según la antigüedad de EL TRABAJADOR. La terminación por falta grave debidamente comprobada no generará dichas prestaciones.',
  'Código de Trabajo, artículos 68 y siguientes', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'l-periodo-prueba', 'Período de prueba', 'Laborales', 'Plazo inicial de prueba.',
  'PERÍODO DE PRUEBA. Los primeros tres (3) meses de la relación se considerarán período de prueba, durante el cual cualquiera de las partes podrá poner fin al contrato sin responsabilidad, conforme al Código de Trabajo.',
  'Código de Trabajo, artículo 79', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 't-licencia-uso', 'Licencia de uso', 'Tecnología', 'Alcance de la licencia concedida sobre el software.',
  'LICENCIA. EL PROVEEDOR concede a EL CLIENTE una licencia no exclusiva, intransferible y revocable para usar el software objeto del presente contrato, limitada a {{cantidad_usuarios}} usuarios y al territorio pactado. Queda prohibida su copia, descompilación, sublicencia o cesión a terceros sin autorización escrita.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 't-propiedad-codigo', 'Propiedad del código', 'Tecnología', 'Titularidad del software desarrollado.',
  'PROPIEDAD DEL CÓDIGO. Una vez satisfecho el precio íntegro pactado, los derechos patrimoniales sobre el código fuente desarrollado específicamente para EL CLIENTE le pertenecerán a este. EL PROVEEDOR conserva la titularidad de sus componentes, bibliotecas y herramientas preexistentes, sobre los que concede a EL CLIENTE una licencia perpetua de uso.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 't-entrega-codigo-fuente', 'Entrega del código fuente', 'Tecnología', 'Obligación de entregar el código y su documentación.',
  'CÓDIGO FUENTE. EL PROVEEDOR entregará a EL CLIENTE el código fuente completo, debidamente documentado y en un repositorio de control de versiones, dentro de los quince (15) días siguientes a la aceptación final de los entregables.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 't-soporte-tecnico', 'Soporte técnico', 'Tecnología', 'Alcance y horario del soporte.',
  'SOPORTE. EL PROVEEDOR prestará soporte técnico en horario de {{horario_soporte}}, a través de los canales acordados. El soporte comprende la corrección de errores y la asistencia en el uso del sistema; no comprende el desarrollo de nuevas funcionalidades, que se cotizarán por separado.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 't-nivel-servicio', 'Nivel de servicio (SLA)', 'Tecnología', 'Tiempos de respuesta comprometidos.',
  'NIVEL DE SERVICIO. EL PROVEEDOR atenderá las incidencias conforme a los siguientes tiempos máximos de respuesta: incidencias críticas, que impiden el uso del sistema, cuatro (4) horas hábiles; incidencias mayores, ocho (8) horas hábiles; e incidencias menores, tres (3) días hábiles. El incumplimiento reiterado de estos plazos dará derecho a EL CLIENTE a resolver el contrato.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 't-disponibilidad', 'Disponibilidad del servicio', 'Tecnología', 'Porcentaje de tiempo en que el servicio estará activo.',
  'DISPONIBILIDAD. EL PROVEEDOR garantiza una disponibilidad mensual del servicio no inferior al {{disponibilidad_porcentaje}}, calculada sobre el tiempo total del mes y excluyendo las ventanas de mantenimiento programado, que serán comunicadas con al menos cuarenta y ocho (48) horas de anticipación.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 't-seguridad-informacion', 'Seguridad de la información', 'Tecnología', 'Medidas técnicas de protección.',
  'SEGURIDAD. EL PROVEEDOR implementará medidas técnicas y organizativas razonables para proteger la información de EL CLIENTE, incluyendo cifrado en tránsito y en reposo, control de accesos por roles y registro de auditoría. Notificará a EL CLIENTE cualquier incidente de seguridad dentro de las setenta y dos (72) horas siguientes a su detección.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 't-proteccion-datos', 'Protección de datos personales', 'Tecnología', 'Tratamiento de datos personales por cuenta del cliente.',
  'PROTECCIÓN DE DATOS. EL PROVEEDOR tratará los datos personales a los que acceda únicamente siguiendo las instrucciones de EL CLIENTE y para los fines del presente contrato, absteniéndose de cederlos a terceros. Ambas partes se obligan a cumplir la legislación dominicana sobre protección de datos de carácter personal.',
  'Ley 172-13 sobre Protección de Datos Personales', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 't-respaldos', 'Respaldos', 'Tecnología', 'Frecuencia y retención de las copias de seguridad.',
  'RESPALDOS. EL PROVEEDOR realizará copias de seguridad automáticas con frecuencia {{frecuencia_respaldo}}, conservándolas durante al menos treinta (30) días en ubicación distinta a la del sistema productivo, y verificará periódicamente que puedan restaurarse.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 't-continuidad', 'Continuidad y recuperación', 'Tecnología', 'Plan de recuperación ante desastres.',
  'CONTINUIDAD. EL PROVEEDOR mantendrá un plan de continuidad que permita restablecer el servicio en un plazo máximo de {{horas_recuperacion}} horas ante un incidente grave, con una pérdida máxima de datos no superior a {{horas_perdida_datos}} horas. El plan será revisado y probado al menos una vez al año.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 't-uso-inteligencia-artificial', 'Uso de inteligencia artificial', 'Tecnología', 'Condiciones para emplear herramientas de IA.',
  'INTELIGENCIA ARTIFICIAL. Cuando en la ejecución del presente contrato se empleen herramientas de inteligencia artificial, EL PROVEEDOR lo comunicará previamente a EL CLIENTE, se abstendrá de introducir información confidencial en sistemas de terceros sin autorización escrita, y responderá por la exactitud y la titularidad de los resultados entregados como si hubiesen sido producidos íntegramente por medios propios.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 't-portabilidad-datos', 'Portabilidad y salida', 'Tecnología', 'Devolución de los datos al terminar el contrato.',
  'PORTABILIDAD. A la terminación del contrato, EL PROVEEDOR entregará a EL CLIENTE la totalidad de sus datos en un formato estructurado y de uso común, dentro de los treinta (30) días siguientes, y procederá a su eliminación segura de sus sistemas una vez confirmada la entrega.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 't-aceptacion-entregables', 'Aceptación de entregables', 'Tecnología', 'Plazo y criterio para aceptar lo entregado.',
  'ACEPTACIÓN. EL CLIENTE dispondrá de {{dias_aceptacion}} días hábiles desde la entrega de cada hito para revisarlo y comunicar por escrito su aceptación o las observaciones que procedan. Transcurrido dicho plazo sin pronunciamiento, el entregable se tendrá por aceptado.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'c-objeto-compraventa', 'Objeto de la compraventa', 'Económicas', 'Bien vendido y precio acordado.',
  'OBJETO. EL VENDEDOR vende, cede y transfiere a EL COMPRADOR, quien acepta y adquiere, el bien descrito como {{descripcion_bien}}, por el precio convenido de {{precio_venta_letras}}, que EL COMPRADOR paga en este acto y EL VENDEDOR declara recibir a su entera satisfacción.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'c-vicios-ocultos', 'Vicios ocultos', 'Económicas', 'Responsabilidad del vendedor por defectos no visibles.',
  'VICIOS OCULTOS. EL VENDEDOR responde frente a EL COMPRADOR por los vicios ocultos del bien vendido que lo hagan impropio para el uso al que se destina o que disminuyan de tal modo ese uso que, de haberlos conocido, EL COMPRADOR no lo habría adquirido o habría pagado un precio menor.',
  'Código Civil Dominicano, artículos 1641 y siguientes', 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'c-entrega-bien', 'Entrega del bien', 'Económicas', 'Momento y lugar de la entrega.',
  'ENTREGA. EL VENDEDOR entregará el bien a EL COMPRADOR el {{fecha_entrega_larga}} en {{lugar_entrega}}, libre de todo gravamen y en el estado en que se encuentra, que EL COMPRADOR declara conocer y aceptar. Los riesgos se transmiten a EL COMPRADOR desde el momento de la entrega.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'v-descripcion-vehiculo', 'Descripción del vehículo', 'Económicas', 'Identificación completa del vehículo.',
  'DESCRIPCIÓN DEL VEHÍCULO. El vehículo objeto del presente contrato es marca {{vehiculo_marca}}, modelo {{vehiculo_modelo}}, año {{vehiculo_anio}}, color {{vehiculo_color}}, chasis número {{vehiculo_chasis}}, placa {{vehiculo_placa}}, amparado en la matrícula número {{vehiculo_matricula}}.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'v-traspaso-vehiculo', 'Traspaso del vehículo', 'Económicas', 'Trámite de transferencia ante la DGII.',
  'TRASPASO. Las partes se obligan a comparecer ante la Dirección General de Impuestos Internos para formalizar el traspaso de la matrícula dentro de los treinta (30) días siguientes a la firma. Los impuestos, tasas y gastos de dicho traspaso correrán por cuenta de {{parte_paga_traspaso}}.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'p-capital-prestamo', 'Capital del préstamo', 'Económicas', 'Monto prestado y su destino.',
  'CAPITAL. EL PRESTAMISTA entrega a EL PRESTATARIO, quien declara recibir a su entera satisfacción, la suma de {{capital_letras}}, que este se obliga a restituir en las condiciones y plazos establecidos en el presente contrato.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'p-amortizacion', 'Amortización', 'Económicas', 'Plan de pagos del préstamo.',
  'AMORTIZACIÓN. EL PRESTATARIO restituirá el capital más los intereses pactados mediante {{cantidad_cuotas}} cuotas mensuales, iguales y consecutivas de {{monto_cuota_letras}} cada una, pagaderas el día {{dia_pago}} de cada mes, hasta la total cancelación de la deuda.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)
VALUES (NULL, 'p-garantia-prestamo', 'Garantía del préstamo', 'Económicas', 'Bien o aval que respalda la deuda.',
  'GARANTÍA. En respaldo de las obligaciones asumidas, EL PRESTATARIO constituye a favor de EL PRESTAMISTA garantía sobre {{descripcion_garantia}}. En caso de incumplimiento, EL PRESTAMISTA podrá ejecutar dicha garantía conforme a los procedimientos que establece la legislación dominicana.',
  NULL, 'DRAFT')
ON CONFLICT DO NOTHING;

-- ══════════════ VARIABLES ══════════════

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'anios_confidencialidad', 'Años de confidencialidad', NULL, NULL,
  'number'::variable_data_type, '[]'::jsonb, '3', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'anios_uso_imagen', 'Años de uso de la imagen', NULL, NULL,
  'number'::variable_data_type, '[]'::jsonb, '2', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'anticipo_porcentaje', 'Anticipo', '¿Qué porcentaje se paga por adelantado?', NULL,
  'percentage'::variable_data_type, '[]'::jsonb, '50', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'cantidad_cuotas', 'Número de cuotas', NULL, NULL,
  'number'::variable_data_type, '[]'::jsonb, '12', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'cantidad_ejemplares', 'Número de ejemplares', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, 'dos (2)', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'cantidad_revisiones', 'Rondas de revisión incluidas', NULL, NULL,
  'number'::variable_data_type, '[]'::jsonb, '2', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'cantidad_usuarios', 'Usuarios de la licencia', NULL, NULL,
  'number'::variable_data_type, '[]'::jsonb, '10', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'capital_letras', 'Capital prestado', NULL, NULL,
  'currency'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"monto_letras","as":"capital_letras","currency":"DOP"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'certificado_titulo', 'Número de Certificado de Título', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'comision_porcentaje', 'Comisión', NULL, NULL,
  'percentage'::variable_data_type, '[]'::jsonb, '10', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'comision_referido_porcentaje', 'Comisión por referido', NULL, NULL,
  'percentage'::variable_data_type, '[]'::jsonb, '10', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'deposito_letras', 'Monto del depósito', NULL, NULL,
  'currency'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"monto_letras","as":"deposito_letras","currency":"DOP"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'descripcion_bien', 'Descripción del bien', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'descripcion_entregables', 'Entregables', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'descripcion_garantia', 'Descripción de la garantía', NULL, NULL,
  'textarea'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'descripcion_obra', 'Descripción de la obra', '¿Qué trabajos comprende la obra?', NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'descripcion_registral', 'Designación catastral', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'destino_uso', 'Destino o uso del bien', '¿Para qué se usará el bien?', NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'dias_aceptacion', 'Días para aceptar entregables', NULL, NULL,
  'number'::variable_data_type, '[]'::jsonb, '10', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'dias_pago', 'Días para pagar', '¿En cuántos días se paga cada factura?', NULL,
  'number'::variable_data_type, '[]'::jsonb, '30', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'dias_presenciales', 'Días presenciales por semana', NULL, NULL,
  'number'::variable_data_type, '[]'::jsonb, '2', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'dias_recepcion_definitiva', 'Días hasta la recepción definitiva', NULL, NULL,
  'number'::variable_data_type, '[]'::jsonb, '30', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'disponibilidad_porcentaje', 'Disponibilidad garantizada', NULL, NULL,
  'percentage'::variable_data_type, '[]'::jsonb, '99.5', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'distrito_judicial', 'Distrito Judicial competente', '¿Qué Distrito Judicial conoce las controversias?', NULL,
  'text'::variable_data_type, '[]'::jsonb, 'La Altagracia', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'fecha_entrega_larga', 'Fecha de entrega', NULL, NULL,
  'date'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"fecha_larga","as":"fecha_entrega_larga"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'frecuencia_respaldo', 'Frecuencia de respaldos', NULL, NULL,
  'select'::variable_data_type, '[{"value":"diaria","label":"diaria"},{"value":"semanal","label":"semanal"},{"value":"horaria","label":"cada hora"}]'::jsonb, 'diaria', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'horario_soporte', 'Horario de soporte', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, 'lunes a viernes, de 9:00 a.m. a 6:00 p.m.', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'horario_trabajo', 'Horario', '¿Cuál es el horario?', NULL,
  'text'::variable_data_type, '[]'::jsonb, 'lunes a viernes, de 8:00 a.m. a 5:00 p.m.', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'horas_perdida_datos', 'Pérdida máxima de datos en horas', NULL, NULL,
  'number'::variable_data_type, '[]'::jsonb, '4', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'horas_recuperacion', 'Horas para restablecer el servicio', NULL, NULL,
  'number'::variable_data_type, '[]'::jsonb, '24', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'horas_semanales', 'Horas semanales', NULL, NULL,
  'number'::variable_data_type, '[]'::jsonb, '44', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'interes_mora_porcentaje', 'Interés por mora', NULL, NULL,
  'percentage'::variable_data_type, '[]'::jsonb, '3', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'lugar_entrega', 'Lugar de entrega', NULL, NULL,
  'address'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'meses_no_competencia', 'Meses de no competencia', NULL, NULL,
  'number'::variable_data_type, '[]'::jsonb, '12', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'moneda_contrato', 'Moneda del contrato', NULL, NULL,
  'select'::variable_data_type, '[{"value":"DOP","label":"Pesos dominicanos"},{"value":"USD","label":"Dólares"},{"value":"EUR","label":"Euros"}]'::jsonb, 'DOP', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'monto_cuota_letras', 'Monto de cada cuota', NULL, NULL,
  'currency'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"monto_letras","as":"monto_cuota_letras","currency":"DOP"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'monto_penalidad_letras', 'Monto de la penalidad', NULL, NULL,
  'currency'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"monto_letras","as":"monto_penalidad_letras","currency":"DOP"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'monto_total_letras', 'Monto total', '¿Cuál es el monto total?', NULL,
  'currency'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"monto_letras","as":"monto_total_letras","currency":"DOP"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'objeto_exclusividad', 'Objeto de la exclusividad', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_exclusiva', 'Parte con exclusividad', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_paga_transferencia', 'Quién paga la transferencia', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_paga_traspaso', 'Quién paga el traspaso', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_primera_cedula', 'Cédula de la primera parte', NULL, NULL,
  'cedula'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_primera_domicilio', 'Domicilio de la primera parte', NULL, NULL,
  'address'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_primera_nacionalidad', 'Nacionalidad de la primera parte', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, 'dominicana', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_primera_nombre', 'Nombre de la primera parte', '¿Quién es la primera parte?', NULL,
  'person'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_responsable_seguro', 'Parte que contrata el seguro', '¿Quién contrata y paga la póliza?', NULL,
  'text'::variable_data_type, '[]'::jsonb, 'LA PRIMERA PARTE', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_segunda_cedula', 'Cédula de la segunda parte', NULL, NULL,
  'cedula'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_segunda_domicilio', 'Domicilio de la segunda parte', NULL, NULL,
  'address'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_segunda_nacionalidad', 'Nacionalidad de la segunda parte', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, 'dominicana', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_segunda_nombre', 'Nombre de la segunda parte', '¿Quién es la segunda parte?', NULL,
  'person'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'parte_suministra_materiales', 'Quién suministra los materiales', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'penalidad_diaria_porcentaje', 'Penalidad diaria', NULL, NULL,
  'percentage'::variable_data_type, '[]'::jsonb, '0.5', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'periodo_alquiler', 'Período de pago del alquiler', '¿Cada cuánto se paga?', NULL,
  'text'::variable_data_type, '[]'::jsonb, 'mes', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'plazo_obra_dias', 'Plazo de la obra en días', NULL, NULL,
  'number'::variable_data_type, '[]'::jsonb, '90', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'precio_alquiler_letras', 'Precio del alquiler', '¿Cuánto se paga por período?', NULL,
  'currency'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"monto_letras","as":"precio_alquiler_letras","currency":"DOP"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'precio_venta_letras', 'Precio de venta', NULL, NULL,
  'currency'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"monto_letras","as":"precio_venta_letras","currency":"DOP"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'retencion_porcentaje', 'Retención en garantía', NULL, NULL,
  'percentage'::variable_data_type, '[]'::jsonb, '10', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'salario_letras', 'Salario mensual', '¿Cuál es el salario?', NULL,
  'currency'::variable_data_type, '[]'::jsonb, NULL, true, '{"transform":"monto_letras","as":"salario_letras","currency":"DOP"}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'superficie_metros', 'Superficie en metros cuadrados', NULL, NULL,
  'number'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'territorio_contrato', 'Territorio', '¿En qué territorio aplica?', NULL,
  'text'::variable_data_type, '[]'::jsonb, 'la República Dominicana', true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'titular_imagen', 'Titular de los derechos de imagen', NULL, NULL,
  'person'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'titular_propiedad_intelectual', 'Titular de la propiedad intelectual', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'vehiculo_anio', 'Año', NULL, NULL,
  'number'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'vehiculo_chasis', 'Número de chasis', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'vehiculo_color', 'Color', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'vehiculo_marca', 'Marca del vehículo', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'vehiculo_matricula', 'Número de matrícula', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'vehiculo_modelo', 'Modelo', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
VALUES (NULL, 'vehiculo_placa', 'Placa', NULL, NULL,
  'text'::variable_data_type, '[]'::jsonb, NULL, true, NULL)
ON CONFLICT DO NOTHING;

