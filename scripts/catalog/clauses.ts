/**
 * BIBLIOTECA DE CLÁUSULAS · BORRADOR PARA REVISIÓN LEGAL
 *
 * ⚠️  Ninguno de estos textos ha sido revisado por un abogado dominicano.
 *     Todos se cargan con status = 'DRAFT' y NO son visibles para los
 *     usuarios de la plataforma hasta que un profesional los apruebe.
 *
 * Cada cláusula es una entidad reutilizable: corregir el texto aquí lo
 * corrige en todas las plantillas que la usan.
 *
 * Las variables van entre llaves dobles y deben existir en el catálogo
 * de variables, o el documento saldrá con el hueco sin rellenar.
 */

export type ClauseSeed = {
  slug: string
  title: string
  family: 'Generales' | 'Económicas' | 'Inmobiliarias' | 'Empresariales' | 'Laborales' | 'Tecnología'
  description: string
  body: string
  legal_reference?: string
}

export const CLAUSES: ClauseSeed[] = [

/* ═══════════════════ GENERALES ═══════════════════ */

{ slug: 'g-definiciones', title: 'Definiciones', family: 'Generales',
  description: 'Fija el significado de los términos que se repiten en el contrato.',
  body: 'DEFINICIONES. Para los efectos del presente contrato, los términos que aparezcan en mayúscula inicial tendrán el significado que se les atribuye en esta cláusula o en el cuerpo del documento. El singular comprende el plural y viceversa, salvo que el contexto indique lo contrario.' },

{ slug: 'g-obligaciones-partes', title: 'Obligaciones de las partes', family: 'Generales',
  description: 'Declaración general del deber de cumplir de buena fe.',
  body: 'OBLIGACIONES. Las partes se obligan a cumplir de buena fe todas y cada una de las estipulaciones del presente contrato, así como aquellas obligaciones que, sin estar expresamente pactadas, se deriven de la naturaleza del acuerdo, de la equidad, del uso o de la ley.',
  legal_reference: 'Código Civil Dominicano, artículo 1135' },

{ slug: 'g-renovacion-automatica', title: 'Renovación automática', family: 'Generales',
  description: 'El contrato se prorroga solo si nadie avisa lo contrario.',
  body: 'RENOVACIÓN. Al vencimiento del plazo pactado, el presente contrato se entenderá prorrogado automáticamente por períodos iguales y sucesivos, salvo que cualquiera de las partes comunique a la otra, por escrito y con al menos treinta (30) días de anticipación, su voluntad de no renovarlo.' },

{ slug: 'g-terminacion-mutuo-acuerdo', title: 'Terminación por mutuo acuerdo', family: 'Generales',
  description: 'Ambas partes pueden terminar de común acuerdo.',
  body: 'TERMINACIÓN POR MUTUO ACUERDO. Las partes podrán poner fin al presente contrato en cualquier momento, mediante acuerdo escrito y firmado por ambas, en el que se establecerán las condiciones de liquidación de las obligaciones pendientes.' },

{ slug: 'g-penalidad', title: 'Penalidad por incumplimiento', family: 'Generales',
  description: 'Cláusula penal por incumplimiento de las obligaciones.',
  body: 'CLÁUSULA PENAL. La parte que incumpla cualquiera de las obligaciones esenciales del presente contrato pagará a la otra, a título de cláusula penal y sin necesidad de puesta en mora previa, la suma de {{monto_penalidad_letras}}, sin perjuicio del derecho de la parte cumplidora a exigir la ejecución forzosa del contrato o su resolución, y la reparación de los daños que excedan dicha suma.',
  legal_reference: 'Código Civil Dominicano, artículos 1226 y siguientes' },

{ slug: 'g-intereses-moratorios', title: 'Intereses moratorios', family: 'Generales',
  description: 'Interés que corre sobre las sumas vencidas.',
  body: 'INTERESES MORATORIOS. Toda suma vencida y no pagada devengará, de pleno derecho y sin necesidad de intimación, un interés moratorio de {{interes_mora_porcentaje}} mensual, calculado desde la fecha de vencimiento y hasta el día del pago efectivo.' },

{ slug: 'g-fuerza-mayor', title: 'Fuerza mayor y caso fortuito', family: 'Generales',
  description: 'Suspende obligaciones ante hechos imprevisibles e irresistibles.',
  body: 'FUERZA MAYOR. Ninguna de las partes será responsable por el incumplimiento de sus obligaciones cuando este obedezca a caso fortuito o fuerza mayor, entendiéndose por tales los hechos imprevisibles e irresistibles ajenos a su voluntad, incluyendo desastres naturales, huracanes, terremotos, actos de autoridad, conmoción civil o epidemias declaradas. La parte afectada deberá notificar a la otra dentro de los cinco (5) días siguientes al hecho, y las obligaciones quedarán suspendidas mientras dure el impedimento. Si este se prolonga por más de sesenta (60) días, cualquiera de las partes podrá resolver el contrato sin responsabilidad.',
  legal_reference: 'Código Civil Dominicano, artículos 1147 y 1148' },

{ slug: 'g-arbitraje', title: 'Arbitraje', family: 'Generales',
  description: 'Somete las controversias a arbitraje en lugar de a los tribunales.',
  body: 'ARBITRAJE. Toda controversia derivada del presente contrato, o que guarde relación con él, será resuelta definitivamente mediante arbitraje de derecho administrado por el Centro de Resolución Alternativa de Controversias de la Cámara de Comercio y Producción de Santo Domingo, conforme a su reglamento vigente. El tribunal arbitral estará compuesto por un (1) árbitro, el arbitraje tendrá su sede en la República Dominicana y se conducirá en idioma español. El laudo será definitivo y obligatorio para las partes.',
  legal_reference: 'Ley 489-08 sobre Arbitraje Comercial' },

{ slug: 'g-mediacion-previa', title: 'Mediación previa', family: 'Generales',
  description: 'Obliga a intentar un acuerdo antes de demandar.',
  body: 'MEDIACIÓN PREVIA. Antes de acudir a la vía judicial o arbitral, las partes se obligan a intentar de buena fe una solución amigable mediante mediación, por un plazo no menor de treinta (30) días contados desde la notificación escrita de la controversia. El incumplimiento de este requisito no impedirá el ejercicio de las acciones que correspondan una vez transcurrido dicho plazo.' },

{ slug: 'g-divisibilidad', title: 'Divisibilidad', family: 'Generales',
  description: 'Si una cláusula es nula, el resto del contrato sigue vigente.',
  body: 'DIVISIBILIDAD. Si alguna disposición del presente contrato fuera declarada nula, inválida o inejecutable por autoridad competente, dicha declaración no afectará la validez de las restantes disposiciones, que continuarán vigentes. Las partes se obligan a sustituir la disposición afectada por otra válida que se aproxime en lo posible a la finalidad económica perseguida.' },

{ slug: 'g-seguro-bienes', title: 'Seguro de los bienes', family: 'Generales',
  description: 'Quién asegura los bienes que cubre el contrato y hasta dónde responde cada parte.',
  body: 'SEGURO. {{parte_responsable_seguro}} mantendrá vigente, durante toda la vigencia del presente contrato y a su exclusivo costo, una póliza de seguro que cubra los bienes objeto del mismo contra los riesgos habituales de pérdida, daño, incendio y robo, así como la responsabilidad civil frente a terceros derivada de su uso u operación. La otra parte podrá exigir en cualquier momento la exhibición de la póliza y de los recibos de prima al día. La existencia del seguro no libera a la parte responsable de los daños que excedan la cobertura contratada ni de los causados por dolo o falta grave.',
  legal_reference: 'Ley 146-02 sobre Seguros y Fianzas de la República Dominicana' },

{ slug: 'g-devolucion-bien', title: 'Devolución del bien', family: 'Generales',
  description: 'Cómo y en qué estado se devuelve el bien al terminar el contrato.',
  body: 'DEVOLUCIÓN. Al vencimiento del presente contrato o al producirse su terminación por cualquier causa, la parte que tenga el bien en su poder se obliga a devolverlo de inmediato en el mismo estado en que lo recibió, salvo el desgaste normal derivado del uso convenido, con todos sus accesorios, documentos y llaves, y libre de gravámenes, multas o cargos generados durante el período de uso. Las partes levantarán un acta de devolución en la que se hará constar el estado del bien; los daños que consten en dicha acta serán de cargo de la parte que lo devuelve.',
  legal_reference: 'Código Civil Dominicano, artículos 1730 y 1731' },

{ slug: 'g-objeto-uso-bien', title: 'Objeto y uso del bien', family: 'Generales',
  description: 'Qué bien se cede y para qué puede usarse, sin suponer que es un inmueble.',
  body: 'OBJETO. Por el presente contrato, LA PRIMERA PARTE cede a LA SEGUNDA PARTE el uso del bien descrito en este documento, en adelante EL BIEN, el cual será destinado exclusivamente a {{destino_uso}}. LA SEGUNDA PARTE declara recibir EL BIEN en buen estado de conservación y funcionamiento, y se obliga a emplearlo conforme a su naturaleza y al destino convenido, sin poder cambiarlo ni cederlo a terceros sin autorización previa y por escrito de LA PRIMERA PARTE.',
  legal_reference: 'Código Civil Dominicano, artículos 1709 y siguientes' },

{ slug: 'e-precio-alquiler', title: 'Precio del alquiler', family: 'Económicas',
  description: 'Cuánto se paga por el uso del bien y cuándo, sin suponer que es un inmueble.',
  body: 'PRECIO. El precio por el uso de EL BIEN se fija en la suma de {{precio_alquiler_letras}} por cada {{periodo_alquiler}}, que LA SEGUNDA PARTE se obliga a pagar por adelantado, a más tardar el día {{dia_pago}} de cada período, mediante transferencia a la cuenta que LA PRIMERA PARTE indique o en el domicilio de esta. El pago deberá hacerse sin necesidad de requerimiento previo y no podrá compensarse ni retenerse por reclamaciones pendientes entre las partes.',
  legal_reference: 'Código Civil Dominicano, artículo 1728' },

{ slug: 'g-notificaciones', title: 'Notificaciones', family: 'Generales',
  description: 'Dónde y cómo se notifican las partes, sin atarlo a un inmueble.',
  body: 'NOTIFICACIONES. Para todos los fines del presente contrato, LA PRIMERA PARTE elige domicilio en {{parte_primera_domicilio}} y LA SEGUNDA PARTE en {{parte_segunda_domicilio}}. Toda notificación, requerimiento o comunicación relacionada con este contrato se reputará válidamente hecha si se entrega en dichos domicilios mediante acto de alguacil, correo certificado con acuse de recibo o entrega personal con constancia escrita. Cualquier cambio de domicilio deberá comunicarse a la otra parte por escrito dentro de los diez (10) días siguientes; mientras no se comunique, las notificaciones hechas al domicilio anterior conservarán plena validez.',
  legal_reference: 'Código de Procedimiento Civil Dominicano, artículos 68 y siguientes' },

{ slug: 'g-ley-aplicable', title: 'Ley aplicable y jurisdicción', family: 'Generales',
  description: 'Ley dominicana y tribunales competentes, sin atarlo a un inmueble.',
  body: 'LEY APLICABLE Y JURISDICCIÓN. El presente contrato se rige por las leyes de la República Dominicana. Para el conocimiento de cualquier controversia derivada de su interpretación, ejecución o terminación, las partes se someten voluntariamente a la competencia de los tribunales del Distrito Judicial de {{distrito_judicial}}, renunciando expresamente a cualquier otro fuero que pudiera corresponderles.',
  legal_reference: 'Código de Procedimiento Civil Dominicano; Ley 834 de 1978' },

{ slug: 'g-cesion-prohibida', title: 'Prohibición de cesión', family: 'Generales',
  description: 'Impide traspasar el contrato a un tercero.',
  body: 'CESIÓN. Ninguna de las partes podrá ceder, transferir ni delegar, total ni parcialmente, los derechos y obligaciones derivados del presente contrato sin el consentimiento previo y por escrito de la otra parte. Toda cesión realizada en contravención de esta cláusula será nula y de ningún efecto.' },

{ slug: 'g-cesion-permitida', title: 'Cesión autorizada', family: 'Generales',
  description: 'Permite ceder el contrato avisando previamente.',
  body: 'CESIÓN. Cualquiera de las partes podrá ceder los derechos y obligaciones derivados del presente contrato a una sociedad de su mismo grupo económico o como consecuencia de una fusión, escisión o transferencia de activos, comunicándolo por escrito a la otra parte con al menos quince (15) días de anticipación. El cedente continuará siendo solidariamente responsable del cumplimiento de las obligaciones cedidas.' },

{ slug: 'g-modificaciones', title: 'Modificaciones', family: 'Generales',
  description: 'Todo cambio debe constar por escrito.',
  body: 'MODIFICACIONES. Ninguna modificación, adición o renuncia a las disposiciones del presente contrato surtirá efecto si no consta por escrito y está firmada por ambas partes. La tolerancia de una de las partes ante el incumplimiento de la otra no constituirá renuncia a exigir su cumplimiento en el futuro.' },

{ slug: 'g-declaraciones-partes', title: 'Declaraciones de las partes', family: 'Generales',
  description: 'Las partes declaran tener capacidad y facultades para contratar.',
  body: 'DECLARACIONES. Cada parte declara y garantiza a la otra que: (a) tiene plena capacidad legal para celebrar el presente contrato; (b) quien lo suscribe cuenta con las facultades suficientes para obligarla; (c) la celebración de este contrato no infringe ninguna obligación previamente asumida; y (d) la información suministrada a la otra parte es veraz y completa.' },

{ slug: 'g-encabezados', title: 'Encabezados y anexos', family: 'Generales',
  description: 'Los títulos son orientativos y los anexos forman parte del contrato.',
  body: 'ENCABEZADOS Y ANEXOS. Los títulos de las cláusulas se incluyen únicamente para facilitar la lectura y no afectan la interpretación del contrato. Los anexos que se acompañan forman parte integrante e inseparable del mismo y se entienden aceptados por ambas partes.' },

{ slug: 'g-idioma-ejemplares', title: 'Idioma y ejemplares', family: 'Generales',
  description: 'Idioma del contrato y número de originales.',
  body: 'IDIOMA Y EJEMPLARES. El presente contrato se otorga en idioma español, que prevalecerá sobre cualquier traducción. Se firma en {{cantidad_ejemplares}} ejemplares de un mismo tenor y efecto, quedando uno en poder de cada parte.' },

{ slug: 'g-firma-electronica', title: 'Firma electrónica', family: 'Generales',
  description: 'Reconoce validez a la firma en medios electrónicos.',
  body: 'FIRMA ELECTRÓNICA. Las partes reconocen expresamente la validez y eficacia jurídica de la firma electrónica y de los documentos digitales, conforme a la legislación dominicana sobre comercio electrónico, documentos y firmas digitales, y aceptan que el presente contrato pueda ser suscrito por dichos medios.',
  legal_reference: 'Ley 126-02 sobre Comercio Electrónico, Documentos y Firmas Digitales' },

{ slug: 'g-domicilio-eleccion', title: 'Elección de domicilio', family: 'Generales',
  description: 'Domicilio elegido por cada parte para notificaciones.',
  body: 'ELECCIÓN DE DOMICILIO. Para todos los fines y consecuencias del presente contrato, las partes eligen domicilio en las direcciones consignadas en el encabezamiento, donde se reputarán válidas todas las notificaciones, citaciones y actos procesales que se realicen.' },

{ slug: 'g-buena-fe', title: 'Buena fe contractual', family: 'Generales',
  description: 'Compromiso de ejecutar el contrato de buena fe.',
  body: 'BUENA FE. Las partes declaran haber negociado y suscrito el presente contrato de buena fe y se obligan a ejecutarlo con la misma diligencia, absteniéndose de toda conducta que pueda frustrar su finalidad o perjudicar los legítimos intereses de la otra parte.' },

{ slug: 'g-solucion-controversias', title: 'Escalamiento de controversias', family: 'Generales',
  description: 'Escalonamiento: negociación, luego mediación, luego tribunales.',
  body: 'SOLUCIÓN DE CONTROVERSIAS. Ante cualquier desacuerdo, las partes se obligan a agotar en orden las siguientes instancias: (a) negociación directa entre los representantes designados, por quince (15) días; (b) mediación ante un tercero imparcial, por treinta (30) días adicionales; y (c) solo agotadas las anteriores, la vía judicial o arbitral que corresponda.' },

/* ═══════════════════ ECONÓMICAS ═══════════════════ */

{ slug: 'e-precio-servicios', title: 'Precio de los servicios', family: 'Económicas',
  description: 'Honorarios pactados por los servicios.',
  body: 'PRECIO. Como contraprestación por los servicios objeto del presente contrato, EL CLIENTE pagará a EL PRESTADOR la suma de {{monto_total_letras}}, monto que no incluye los impuestos aplicables conforme a la legislación dominicana vigente.' },

{ slug: 'e-forma-pago', title: 'Forma de pago', family: 'Económicas',
  description: 'Medio y plazo en que se realiza el pago.',
  body: 'FORMA DE PAGO. Los pagos se realizarán mediante transferencia bancaria a la cuenta que indique la parte acreedora, dentro de los {{dias_pago}} días siguientes a la recepción de la factura correspondiente. Los gastos y comisiones bancarias correrán por cuenta del ordenante.' },

{ slug: 'e-pago-anticipado', title: 'Pago anticipado', family: 'Económicas',
  description: 'Adelanto que se entrega al inicio.',
  body: 'PAGO ANTICIPADO. A la firma del presente contrato, EL CLIENTE entregará un anticipo equivalente al {{anticipo_porcentaje}} del precio total pactado. Dicho anticipo se imputará al pago final y no será reembolsable si la terminación del contrato obedece a causa imputable a EL CLIENTE.' },

{ slug: 'e-pago-cuotas', title: 'Pago por cuotas', family: 'Económicas',
  description: 'Precio dividido en pagos periódicos.',
  body: 'PAGO POR CUOTAS. El precio se pagará en {{cantidad_cuotas}} cuotas iguales y consecutivas de {{monto_cuota_letras}} cada una, pagaderas el día {{dia_pago}} de cada mes. La falta de pago de dos (2) cuotas consecutivas producirá la caducidad del plazo y hará exigible la totalidad del saldo pendiente.' },

{ slug: 'e-comision-porcentaje', title: 'Comisión sobre ventas', family: 'Económicas',
  description: 'Comisión calculada como porcentaje.',
  body: 'COMISIÓN. Se pagará una comisión equivalente al {{comision_porcentaje}} sobre el valor neto de cada operación efectivamente cobrada, excluidos impuestos. La comisión se liquidará dentro de los primeros diez (10) días de cada mes respecto de las operaciones cobradas en el mes anterior.' },

{ slug: 'e-deposito-general', title: 'Depósito en garantía', family: 'Económicas',
  description: 'Suma retenida como garantía de cumplimiento.',
  body: 'DEPÓSITO. Se constituye un depósito en garantía por la suma de {{deposito_letras}}, destinado exclusivamente a responder por los daños o incumplimientos imputables a la parte obligada. Dicho depósito no genera intereses y será devuelto dentro de los treinta (30) días siguientes a la terminación del contrato, previa deducción de las sumas que resulten adeudadas.' },

{ slug: 'e-reembolso-gastos', title: 'Reembolso de gastos', family: 'Económicas',
  description: 'Gastos que se reembolsan contra comprobante.',
  body: 'REEMBOLSO DE GASTOS. Los gastos razonables y documentados en que incurra una parte por cuenta de la otra en ejecución del presente contrato serán reembolsados dentro de los quince (15) días siguientes a la presentación de los comprobantes fiscales correspondientes, siempre que hayan sido autorizados previamente por escrito.' },

{ slug: 'e-gastos-cada-parte', title: 'Gastos a cargo de cada parte', family: 'Económicas',
  description: 'Cada parte asume sus propios gastos.',
  body: 'GASTOS. Salvo pacto expreso en contrario, cada parte asumirá los gastos, honorarios y tributos que le correspondan por la negociación, formalización y ejecución del presente contrato, incluidos los honorarios de sus asesores legales.' },

{ slug: 'e-ajuste-precio-anual', title: 'Ajuste anual del precio', family: 'Económicas',
  description: 'Actualización periódica del precio pactado.',
  body: 'AJUSTE DE PRECIO. Transcurridos doce (12) meses desde el inicio del contrato, el precio podrá ser ajustado anualmente en un porcentaje no superior a la variación del Índice de Precios al Consumidor publicado por el Banco Central de la República Dominicana para el período correspondiente. El ajuste deberá comunicarse por escrito con treinta (30) días de anticipación.' },

{ slug: 'e-penalidad-retraso', title: 'Penalidad por retraso en la entrega', family: 'Económicas',
  description: 'Multa diaria por demora en cumplir.',
  body: 'PENALIDAD POR RETRASO. El retraso injustificado en la entrega o en la prestación pactada generará una penalidad equivalente al {{penalidad_diaria_porcentaje}} del valor del contrato por cada día de demora, hasta un máximo del diez por ciento (10%) del precio total, sin perjuicio del derecho de la parte afectada a resolver el contrato.' },

{ slug: 'e-impuestos-retenciones', title: 'Impuestos y retenciones', family: 'Económicas',
  description: 'Reparto de la carga tributaria.',
  body: 'IMPUESTOS. Los montos pactados no incluyen el Impuesto sobre Transferencias de Bienes Industrializados y Servicios (ITBIS) ni cualquier otro tributo aplicable, que serán facturados adicionalmente cuando corresponda. Cada parte será responsable de las retenciones y declaraciones que le imponga la legislación tributaria dominicana.',
  legal_reference: 'Código Tributario Dominicano, Ley 11-92' },

{ slug: 'e-facturacion', title: 'Facturación', family: 'Económicas',
  description: 'Requisitos formales de las facturas.',
  body: 'FACTURACIÓN. Toda factura emitida en virtud del presente contrato deberá contener Número de Comprobante Fiscal válido y cumplir los requisitos que exija la Dirección General de Impuestos Internos. La parte obligada al pago podrá rechazar, dentro de los cinco (5) días siguientes a su recepción, cualquier factura que no cumpla dichos requisitos.' },

{ slug: 'e-moneda-pago', title: 'Moneda de pago', family: 'Económicas',
  description: 'Moneda y conversión aplicable.',
  body: 'MONEDA. Todos los pagos se efectuarán en {{moneda_contrato}}. Cuando el pago deba realizarse en moneda distinta a la pactada, se aplicará la tasa de cambio de venta publicada por el Banco Central de la República Dominicana el día hábil anterior a la fecha de pago.' },

{ slug: 'e-retencion-garantia', title: 'Retención en garantía de obra', family: 'Económicas',
  description: 'Porcentaje retenido hasta la recepción definitiva.',
  body: 'RETENCIÓN EN GARANTÍA. De cada pago se retendrá un {{retencion_porcentaje}} en concepto de garantía de buena ejecución. Las sumas retenidas serán liberadas dentro de los sesenta (60) días siguientes a la recepción definitiva de la obra, siempre que no existan vicios pendientes de subsanar.' },

/* ═══════════════════ INMOBILIARIAS ═══════════════════ */

{ slug: 'i-servicios-excluidos', title: 'Servicios excluidos', family: 'Inmobiliarias',
  description: 'Servicios que no cubre la renta.',
  body: 'SERVICIOS EXCLUIDOS. La renta pactada no comprende los servicios de energía eléctrica, agua potable, gas, telefonía, internet, televisión por suscripción ni recogida de basura, cuyo pago corresponde íntegramente a EL ARRENDATARIO. La falta de pago de dichos servicios se considerará incumplimiento contractual.' },

{ slug: 'i-entrega-inmueble', title: 'Entrega del inmueble', family: 'Inmobiliarias',
  description: 'Momento y estado de la entrega.',
  body: 'ENTREGA. EL ARRENDADOR entregará EL INMUEBLE a EL ARRENDATARIO el {{fecha_entrega_larga}}, en buen estado de habitabilidad, con todos sus servicios funcionando y libre de ocupantes. De la entrega se levantará un acta firmada por ambas partes, en la que se hará constar el estado del inmueble y la lectura de los contadores.' },

{ slug: 'i-inspeccion-periodica', title: 'Inspección del inmueble', family: 'Inmobiliarias',
  description: 'Derecho del arrendador a inspeccionar con aviso.',
  body: 'INSPECCIÓN. EL ARRENDADOR podrá inspeccionar EL INMUEBLE para verificar su estado de conservación, previa comunicación a EL ARRENDATARIO con al menos cuarenta y ocho (48) horas de anticipación y en horario razonable. EL ARRENDATARIO no podrá negar el acceso sin causa justificada.' },

{ slug: 'i-pintura-conservacion', title: 'Pintura y conservación', family: 'Inmobiliarias',
  description: 'Obligación de devolver el inmueble pintado.',
  body: 'PINTURA. EL ARRENDATARIO se obliga a devolver EL INMUEBLE recién pintado en colores neutros, o a abonar a EL ARRENDADOR el costo de dicho trabajo, salvo que la duración del arrendamiento haya sido inferior a doce (12) meses y el inmueble se encuentre en el mismo estado en que fue recibido.' },

{ slug: 'i-areas-comunes', title: 'Uso de áreas comunes', family: 'Inmobiliarias',
  description: 'Reglas de uso de las zonas compartidas.',
  body: 'ÁREAS COMUNES. EL ARRENDATARIO podrá hacer uso de las áreas comunes del inmueble conforme a su destino y al reglamento aplicable, respetando los horarios establecidos y absteniéndose de causar molestias a los demás ocupantes. Los daños que ocasione en dichas áreas serán de su exclusiva responsabilidad.' },

{ slug: 'i-reglamento-condominio', title: 'Reglamento de condominio', family: 'Inmobiliarias',
  description: 'Sujeción al reglamento interno del condominio.',
  body: 'REGLAMENTO DE CONDOMINIO. EL ARRENDATARIO declara conocer y aceptar el reglamento interno del condominio en que se ubica EL INMUEBLE, obligándose a cumplirlo en todos sus términos. Las multas o sanciones que se le impongan por su incumplimiento serán de su exclusiva cuenta.',
  legal_reference: 'Ley 5038 sobre Condominios' },

{ slug: 'i-seguro-inmueble', title: 'Seguro del inmueble', family: 'Inmobiliarias',
  description: 'Quién asegura el inmueble y su contenido.',
  body: 'SEGURO. EL ARRENDADOR mantendrá vigente una póliza de seguro que cubra la estructura de EL INMUEBLE. EL ARRENDATARIO será responsable de asegurar sus bienes muebles y su responsabilidad civil frente a terceros, sin que EL ARRENDADOR responda por pérdidas o daños sufridos por aquellos.' },

{ slug: 'i-descripcion-inmueble', title: 'Descripción del inmueble', family: 'Inmobiliarias',
  description: 'Identificación registral y física del inmueble.',
  body: 'DESCRIPCIÓN DEL INMUEBLE. EL INMUEBLE objeto del presente contrato se identifica como {{descripcion_registral}}, ubicado en {{direccion_inmueble}}, con una superficie aproximada de {{superficie_metros}} metros cuadrados, amparado en el Certificado de Título número {{certificado_titulo}}.' },

{ slug: 'i-garantia-saneamiento', title: 'Garantía de saneamiento', family: 'Inmobiliarias',
  description: 'El vendedor garantiza la propiedad frente a terceros.',
  body: 'SANEAMIENTO. EL VENDEDOR garantiza a EL COMPRADOR la posesión pacífica y útil del inmueble vendido, y responde por la evicción y por los vicios ocultos conforme a la ley. Declara que el inmueble se encuentra libre de gravámenes, hipotecas, embargos, litigios y de toda carga que limite su libre disposición.',
  legal_reference: 'Código Civil Dominicano, artículos 1625 y siguientes' },

{ slug: 'i-transferencia-propiedad', title: 'Transferencia de propiedad', family: 'Inmobiliarias',
  description: 'Momento en que se transfiere el dominio.',
  body: 'TRANSFERENCIA. La transferencia del derecho de propiedad se perfeccionará con la inscripción del presente acto por ante el Registro de Títulos correspondiente. Los gastos de transferencia, impuestos y honorarios que dicha inscripción genere correrán por cuenta de {{parte_paga_transferencia}}.' },

/* ═══════════════════ EMPRESARIALES ═══════════════════ */

{ slug: 'b-exclusividad', title: 'Exclusividad', family: 'Empresariales',
  description: 'Concede derechos en exclusiva.',
  body: 'EXCLUSIVIDAD. Durante la vigencia del presente contrato, se concede a {{parte_exclusiva}} el derecho exclusivo de {{objeto_exclusividad}} dentro del territorio pactado. La parte concedente se abstendrá de designar a terceros para los mismos fines, así como de operar directamente en dicho territorio.' },

{ slug: 'b-no-exclusividad', title: 'No exclusividad', family: 'Empresariales',
  description: 'Aclara que la relación no es exclusiva.',
  body: 'NO EXCLUSIVIDAD. Las partes declaran expresamente que la presente relación no tiene carácter exclusivo. Cada una conserva el derecho de contratar con terceros servicios o productos iguales o similares, sin que ello constituya incumplimiento ni genere derecho a indemnización alguna.' },

{ slug: 'b-territorio', title: 'Territorio', family: 'Empresariales',
  description: 'Ámbito geográfico de la relación.',
  body: 'TERRITORIO. Los derechos y obligaciones derivados del presente contrato se circunscriben al territorio de {{territorio_contrato}}. Cualquier actuación fuera de dicho ámbito requerirá autorización previa y por escrito de la otra parte.' },

{ slug: 'b-referidos', title: 'Comisión por referidos', family: 'Empresariales',
  description: 'Retribución por clientes referidos.',
  body: 'REFERIDOS. Se reconocerá una comisión del {{comision_referido_porcentaje}} sobre el primer contrato efectivamente cobrado que se celebre con cada cliente presentado por la parte referidora, siempre que dicho cliente no hubiera mantenido relación comercial previa y que la presentación se haya documentado por escrito.' },

{ slug: 'b-confidencialidad', title: 'Confidencialidad', family: 'Empresariales',
  description: 'Obligación de reserva sobre la información recibida.',
  body: 'CONFIDENCIALIDAD. Las partes se obligan a mantener estricta reserva sobre toda información técnica, comercial, financiera o de cualquier otra naturaleza a la que accedan con motivo del presente contrato, y a no divulgarla ni utilizarla para fines distintos a su ejecución. Esta obligación subsistirá durante {{anios_confidencialidad}} años contados a partir de la terminación del contrato. Se exceptúa la información que sea de dominio público sin culpa de la parte receptora, o cuya divulgación sea ordenada por autoridad competente.' },

{ slug: 'b-no-competencia', title: 'No competencia', family: 'Empresariales',
  description: 'Restricción de competir tras terminar el contrato.',
  body: 'NO COMPETENCIA. Durante la vigencia del presente contrato y por {{meses_no_competencia}} meses posteriores a su terminación, la parte obligada se abstendrá de desarrollar, por cuenta propia o ajena, actividades que compitan directamente con el objeto de este contrato dentro del territorio pactado. Esta restricción se entiende limitada en tiempo, espacio y objeto a lo estrictamente necesario para proteger los intereses legítimos de la otra parte.' },

{ slug: 'b-propiedad-intelectual', title: 'Propiedad intelectual', family: 'Empresariales',
  description: 'A quién pertenecen los derechos sobre lo creado.',
  body: 'PROPIEDAD INTELECTUAL. Los derechos patrimoniales sobre las obras, desarrollos, diseños y demás creaciones producidas en ejecución del presente contrato pertenecerán a {{titular_propiedad_intelectual}}, quien podrá explotarlos sin limitación de tiempo, territorio ni modalidad. Los derechos morales del autor permanecen irrenunciablemente en cabeza de su creador.',
  legal_reference: 'Ley 65-00 sobre Derecho de Autor' },

{ slug: 'b-distribucion', title: 'Condiciones de distribución', family: 'Empresariales',
  description: 'Obligaciones del distribuidor.',
  body: 'DISTRIBUCIÓN. EL DISTRIBUIDOR se obliga a comercializar los productos objeto del presente contrato en las condiciones, precios y presentaciones que fije EL PROVEEDOR, a mantener un inventario razonable, a preservar la imagen de la marca y a no alterar los productos ni sus empaques.' },

{ slug: 'b-representacion', title: 'Alcance de la representación', family: 'Empresariales',
  description: 'Límites de la facultad de representar.',
  body: 'REPRESENTACIÓN. EL REPRESENTANTE actuará en nombre y por cuenta de EL REPRESENTADO únicamente dentro de los límites expresamente conferidos en el presente contrato. No podrá obligar a EL REPRESENTADO más allá de dichas facultades, y responderá personalmente por los actos que excedan el mandato conferido.' },

{ slug: 'b-relacion-independiente', title: 'Independencia de las partes', family: 'Empresariales',
  description: 'Aclara que no hay relación laboral ni sociedad.',
  body: 'INDEPENDENCIA. El presente contrato no crea entre las partes relación laboral, sociedad, asociación en participación ni agencia de ningún tipo. Cada parte actúa como contratista independiente, asume sus propios riesgos y responde por las obligaciones laborales y de seguridad social de su personal.' },

{ slug: 'b-anticorrupcion', title: 'Cumplimiento y anticorrupción', family: 'Empresariales',
  description: 'Compromiso de no incurrir en prácticas corruptas.',
  body: 'CUMPLIMIENTO NORMATIVO. Las partes declaran no haber ofrecido ni prometido, directa o indirectamente, ventaja alguna a funcionario público o particular para obtener la celebración del presente contrato, y se obligan a cumplir la legislación dominicana en materia de prevención de lavado de activos y de actos de corrupción.',
  legal_reference: 'Ley 155-17 contra el Lavado de Activos' },

{ slug: 'o-alcance-obra', title: 'Alcance de la obra', family: 'Inmobiliarias',
  description: 'Qué trabajos comprende la obra y qué queda expresamente fuera.',
  body: 'ALCANCE DE LA OBRA. EL CONTRATISTA ejecutará los trabajos descritos en {{descripcion_obra}}, conforme a los planos, especificaciones técnicas y presupuesto que las partes suscriben y que forman parte integrante del presente contrato. Todo trabajo no comprendido expresamente en dichos documentos constituirá una obra extraordinaria y requerirá acuerdo previo y por escrito sobre su alcance, precio y plazo, sin que su ejecución pueda presumirse por el solo hecho de haberse iniciado. EL CONTRATISTA suministrará la mano de obra, dirección técnica, herramientas y equipos necesarios; los materiales correrán a cargo de {{parte_suministra_materiales}}.',
  legal_reference: 'Código Civil Dominicano, artículos 1787 y siguientes' },

{ slug: 'o-plazo-obra', title: 'Plazo de ejecución de la obra', family: 'Empresariales',
  description: 'Tiempo comprometido para terminar la obra.',
  body: 'PLAZO DE OBRA. EL CONTRATISTA se obliga a ejecutar y entregar la obra en un plazo de {{plazo_obra_dias}} días calendario, contados a partir de la fecha de inicio. Este plazo se prorrogará automáticamente por los días de paralización imputables a caso fortuito, fuerza mayor o a hechos de EL PROPIETARIO.' },

{ slug: 'o-materiales', title: 'Materiales de la obra', family: 'Empresariales',
  description: 'Quién suministra los materiales y su calidad.',
  body: 'MATERIALES. Los materiales necesarios para la ejecución de la obra serán suministrados por {{parte_suministra_materiales}} y deberán cumplir las especificaciones técnicas del proyecto y las normas dominicanas aplicables. EL PROPIETARIO podrá rechazar todo material que no se ajuste a dichas especificaciones.' },

{ slug: 'o-recepcion-obra', title: 'Recepción de la obra', family: 'Empresariales',
  description: 'Recepción provisional y definitiva.',
  body: 'RECEPCIÓN. Concluida la obra, las partes suscribirán un acta de recepción provisional en la que se harán constar las observaciones pendientes. Subsanadas estas, y transcurridos {{dias_recepcion_definitiva}} días sin que aparezcan vicios, se procederá a la recepción definitiva, momento a partir del cual comienza a correr la garantía legal.' },

{ slug: 'm-derechos-imagen', title: 'Derechos de imagen', family: 'Empresariales',
  description: 'Autorización para usar imagen o voz.',
  body: 'DERECHOS DE IMAGEN. {{titular_imagen}} autoriza expresamente el uso de su imagen, voz y nombre en los materiales producidos en ejecución del presente contrato, para los fines, medios y territorio aquí pactados y por un plazo de {{anios_uso_imagen}} años. Esta autorización no comprende usos distintos a los expresamente señalados.' },

{ slug: 'm-entregables-creativos', title: 'Entregables creativos', family: 'Empresariales',
  description: 'Qué se entrega y cuántas revisiones incluye.',
  body: 'ENTREGABLES. EL PRESTADOR entregará {{descripcion_entregables}}, incluyendo hasta {{cantidad_revisiones}} rondas de revisión sin costo adicional. Las revisiones que excedan dicho número, o los cambios de alcance solicitados por EL CLIENTE, se cotizarán por separado.' },

/* ═══════════════════ LABORALES ═══════════════════ */

{ slug: 'l-salario', title: 'Salario', family: 'Laborales',
  description: 'Remuneración pactada y su periodicidad.',
  body: 'SALARIO. EL EMPLEADOR pagará a EL TRABAJADOR un salario de {{salario_letras}} mensuales, pagadero por quincenas vencidas, del cual se deducirán las retenciones de ley por concepto de seguridad social e impuesto sobre la renta.',
  legal_reference: 'Código de Trabajo, Ley 16-92' },

{ slug: 'l-jornada', title: 'Jornada de trabajo', family: 'Laborales',
  description: 'Horario y duración de la jornada.',
  body: 'JORNADA. La jornada ordinaria de trabajo será de {{horas_semanales}} horas semanales, distribuidas de {{horario_trabajo}}. Las horas trabajadas en exceso se remunerarán con los recargos que establece el Código de Trabajo.',
  legal_reference: 'Código de Trabajo, artículos 147 y siguientes' },

{ slug: 'l-trabajo-remoto', title: 'Trabajo remoto', family: 'Laborales',
  description: 'Prestación del servicio a distancia.',
  body: 'TRABAJO REMOTO. EL TRABAJADOR prestará sus servicios de manera remota desde el domicilio que declare, disponiendo de conexión y espacio adecuados. EL EMPLEADOR proveerá las herramientas de trabajo necesarias y EL TRABAJADOR se obliga a cumplir los mismos deberes de diligencia, disponibilidad y confidencialidad que en la modalidad presencial.' },

{ slug: 'l-trabajo-hibrido', title: 'Trabajo híbrido', family: 'Laborales',
  description: 'Combinación de presencialidad y trabajo remoto.',
  body: 'MODALIDAD HÍBRIDA. EL TRABAJADOR asistirá presencialmente a las instalaciones de EL EMPLEADOR {{dias_presenciales}} días por semana, prestando el resto de la jornada de forma remota. EL EMPLEADOR podrá modificar razonablemente la distribución, comunicándolo con al menos una (1) semana de anticipación.' },

{ slug: 'l-vacaciones', title: 'Vacaciones', family: 'Laborales',
  description: 'Derecho a vacaciones anuales.',
  body: 'VACACIONES. EL TRABAJADOR disfrutará del período de vacaciones anuales remuneradas que le corresponda conforme a su antigüedad y al Código de Trabajo. La fecha de disfrute se acordará entre las partes atendiendo a las necesidades del servicio.',
  legal_reference: 'Código de Trabajo, artículos 177 y siguientes' },

{ slug: 'l-bonificacion', title: 'Bonificación', family: 'Laborales',
  description: 'Participación en los beneficios de la empresa.',
  body: 'BONIFICACIÓN. EL TRABAJADOR participará en los beneficios de la empresa en la proporción y condiciones que establece el Código de Trabajo, sin que dicha participación constituya salario ordinario ni genere derecho adquirido cuando la empresa no obtenga beneficios.',
  legal_reference: 'Código de Trabajo, artículos 223 y siguientes' },

{ slug: 'l-comision-ventas', title: 'Comisión sobre ventas', family: 'Laborales',
  description: 'Retribución variable ligada a resultados.',
  body: 'COMISIÓN. Adicionalmente al salario fijo, EL TRABAJADOR percibirá una comisión del {{comision_porcentaje}} sobre las ventas netas efectivamente cobradas que gestione. La comisión se liquidará mensualmente y forma parte del salario para todos los efectos legales.' },

{ slug: 'l-confidencialidad', title: 'Confidencialidad laboral', family: 'Laborales',
  description: 'Deber de reserva del trabajador.',
  body: 'CONFIDENCIALIDAD. EL TRABAJADOR se obliga a guardar absoluta reserva sobre la información técnica, comercial, financiera y de clientes a la que acceda por razón de su cargo, tanto durante la vigencia del contrato como después de su terminación. El incumplimiento de este deber constituye falta grave.' },

{ slug: 'l-propiedad-intelectual', title: 'Creaciones del trabajador', family: 'Laborales',
  description: 'Titularidad de lo creado durante la relación laboral.',
  body: 'CREACIONES. Los derechos patrimoniales sobre las obras, invenciones y desarrollos que EL TRABAJADOR produzca en ejecución de sus funciones y con los recursos de EL EMPLEADOR corresponderán a este último, sin más contraprestación que el salario pactado, quedando a salvo los derechos morales del autor.',
  legal_reference: 'Ley 65-00 sobre Derecho de Autor' },

{ slug: 'l-equipos-trabajo', title: 'Equipos de trabajo', family: 'Laborales',
  description: 'Uso y devolución de las herramientas entregadas.',
  body: 'EQUIPOS. EL EMPLEADOR entrega a EL TRABAJADOR los equipos y herramientas necesarios para el desempeño de sus funciones, que continúan siendo propiedad de aquel. EL TRABAJADOR los destinará exclusivamente a fines laborales, responderá por su pérdida o deterioro imputable a su negligencia y los devolverá al terminar la relación.' },

{ slug: 'l-gastos-reembolsables', title: 'Gastos del trabajador', family: 'Laborales',
  description: 'Reembolso de gastos incurridos por el trabajador.',
  body: 'GASTOS. EL EMPLEADOR reembolsará a EL TRABAJADOR los gastos de transporte, alojamiento y representación en que incurra por razón de sus funciones, previa autorización y presentación de los comprobantes correspondientes, dentro de los quince (15) días siguientes.' },

{ slug: 'l-terminacion-laboral', title: 'Terminación del contrato de trabajo', family: 'Laborales',
  description: 'Causas y efectos de la terminación.',
  body: 'TERMINACIÓN. El presente contrato podrá terminar por las causas previstas en el Código de Trabajo. En caso de desahucio ejercido por EL EMPLEADOR, este pagará el preaviso y el auxilio de cesantía que correspondan según la antigüedad de EL TRABAJADOR. La terminación por falta grave debidamente comprobada no generará dichas prestaciones.',
  legal_reference: 'Código de Trabajo, artículos 68 y siguientes' },

{ slug: 'l-periodo-prueba', title: 'Período de prueba', family: 'Laborales',
  description: 'Plazo inicial de prueba.',
  body: 'PERÍODO DE PRUEBA. Los primeros tres (3) meses de la relación se considerarán período de prueba, durante el cual cualquiera de las partes podrá poner fin al contrato sin responsabilidad, conforme al Código de Trabajo.',
  legal_reference: 'Código de Trabajo, artículo 79' },

/* ═══════════════════ TECNOLOGÍA ═══════════════════ */

{ slug: 't-licencia-uso', title: 'Licencia de uso', family: 'Tecnología',
  description: 'Alcance de la licencia concedida sobre el software.',
  body: 'LICENCIA. EL PROVEEDOR concede a EL CLIENTE una licencia no exclusiva, intransferible y revocable para usar el software objeto del presente contrato, limitada a {{cantidad_usuarios}} usuarios y al territorio pactado. Queda prohibida su copia, descompilación, sublicencia o cesión a terceros sin autorización escrita.' },

{ slug: 't-propiedad-codigo', title: 'Propiedad del código', family: 'Tecnología',
  description: 'Titularidad del software desarrollado.',
  body: 'PROPIEDAD DEL CÓDIGO. Una vez satisfecho el precio íntegro pactado, los derechos patrimoniales sobre el código fuente desarrollado específicamente para EL CLIENTE le pertenecerán a este. EL PROVEEDOR conserva la titularidad de sus componentes, bibliotecas y herramientas preexistentes, sobre los que concede a EL CLIENTE una licencia perpetua de uso.' },

{ slug: 't-entrega-codigo-fuente', title: 'Entrega del código fuente', family: 'Tecnología',
  description: 'Obligación de entregar el código y su documentación.',
  body: 'CÓDIGO FUENTE. EL PROVEEDOR entregará a EL CLIENTE el código fuente completo, debidamente documentado y en un repositorio de control de versiones, dentro de los quince (15) días siguientes a la aceptación final de los entregables.' },

{ slug: 't-soporte-tecnico', title: 'Soporte técnico', family: 'Tecnología',
  description: 'Alcance y horario del soporte.',
  body: 'SOPORTE. EL PROVEEDOR prestará soporte técnico en horario de {{horario_soporte}}, a través de los canales acordados. El soporte comprende la corrección de errores y la asistencia en el uso del sistema; no comprende el desarrollo de nuevas funcionalidades, que se cotizarán por separado.' },

{ slug: 't-nivel-servicio', title: 'Nivel de servicio (SLA)', family: 'Tecnología',
  description: 'Tiempos de respuesta comprometidos.',
  body: 'NIVEL DE SERVICIO. EL PROVEEDOR atenderá las incidencias conforme a los siguientes tiempos máximos de respuesta: incidencias críticas, que impiden el uso del sistema, cuatro (4) horas hábiles; incidencias mayores, ocho (8) horas hábiles; e incidencias menores, tres (3) días hábiles. El incumplimiento reiterado de estos plazos dará derecho a EL CLIENTE a resolver el contrato.' },

{ slug: 't-disponibilidad', title: 'Disponibilidad del servicio', family: 'Tecnología',
  description: 'Porcentaje de tiempo en que el servicio estará activo.',
  body: 'DISPONIBILIDAD. EL PROVEEDOR garantiza una disponibilidad mensual del servicio no inferior al {{disponibilidad_porcentaje}}, calculada sobre el tiempo total del mes y excluyendo las ventanas de mantenimiento programado, que serán comunicadas con al menos cuarenta y ocho (48) horas de anticipación.' },

{ slug: 't-seguridad-informacion', title: 'Seguridad de la información', family: 'Tecnología',
  description: 'Medidas técnicas de protección.',
  body: 'SEGURIDAD. EL PROVEEDOR implementará medidas técnicas y organizativas razonables para proteger la información de EL CLIENTE, incluyendo cifrado en tránsito y en reposo, control de accesos por roles y registro de auditoría. Notificará a EL CLIENTE cualquier incidente de seguridad dentro de las setenta y dos (72) horas siguientes a su detección.' },

{ slug: 't-proteccion-datos', title: 'Protección de datos personales', family: 'Tecnología',
  description: 'Tratamiento de datos personales por cuenta del cliente.',
  body: 'PROTECCIÓN DE DATOS. EL PROVEEDOR tratará los datos personales a los que acceda únicamente siguiendo las instrucciones de EL CLIENTE y para los fines del presente contrato, absteniéndose de cederlos a terceros. Ambas partes se obligan a cumplir la legislación dominicana sobre protección de datos de carácter personal.',
  legal_reference: 'Ley 172-13 sobre Protección de Datos Personales' },

{ slug: 't-respaldos', title: 'Respaldos', family: 'Tecnología',
  description: 'Frecuencia y retención de las copias de seguridad.',
  body: 'RESPALDOS. EL PROVEEDOR realizará copias de seguridad automáticas con frecuencia {{frecuencia_respaldo}}, conservándolas durante al menos treinta (30) días en ubicación distinta a la del sistema productivo, y verificará periódicamente que puedan restaurarse.' },

{ slug: 't-continuidad', title: 'Continuidad y recuperación', family: 'Tecnología',
  description: 'Plan de recuperación ante desastres.',
  body: 'CONTINUIDAD. EL PROVEEDOR mantendrá un plan de continuidad que permita restablecer el servicio en un plazo máximo de {{horas_recuperacion}} horas ante un incidente grave, con una pérdida máxima de datos no superior a {{horas_perdida_datos}} horas. El plan será revisado y probado al menos una vez al año.' },

{ slug: 't-uso-inteligencia-artificial', title: 'Uso de inteligencia artificial', family: 'Tecnología',
  description: 'Condiciones para emplear herramientas de IA.',
  body: 'INTELIGENCIA ARTIFICIAL. Cuando en la ejecución del presente contrato se empleen herramientas de inteligencia artificial, EL PROVEEDOR lo comunicará previamente a EL CLIENTE, se abstendrá de introducir información confidencial en sistemas de terceros sin autorización escrita, y responderá por la exactitud y la titularidad de los resultados entregados como si hubiesen sido producidos íntegramente por medios propios.' },

{ slug: 't-portabilidad-datos', title: 'Portabilidad y salida', family: 'Tecnología',
  description: 'Devolución de los datos al terminar el contrato.',
  body: 'PORTABILIDAD. A la terminación del contrato, EL PROVEEDOR entregará a EL CLIENTE la totalidad de sus datos en un formato estructurado y de uso común, dentro de los treinta (30) días siguientes, y procederá a su eliminación segura de sus sistemas una vez confirmada la entrega.' },

{ slug: 't-aceptacion-entregables', title: 'Aceptación de entregables', family: 'Tecnología',
  description: 'Plazo y criterio para aceptar lo entregado.',
  body: 'ACEPTACIÓN. EL CLIENTE dispondrá de {{dias_aceptacion}} días hábiles desde la entrega de cada hito para revisarlo y comunicar por escrito su aceptación o las observaciones que procedan. Transcurrido dicho plazo sin pronunciamiento, el entregable se tendrá por aceptado.' },

/* ═══════════════════ COMPRAVENTA, VEHÍCULOS Y PRÉSTAMOS ═══════════════════ */

{ slug: 'c-objeto-compraventa', title: 'Objeto de la compraventa', family: 'Económicas',
  description: 'Bien vendido y precio acordado.',
  body: 'OBJETO. EL VENDEDOR vende, cede y transfiere a EL COMPRADOR, quien acepta y adquiere, el bien descrito como {{descripcion_bien}}, por el precio convenido de {{precio_venta_letras}}, que EL COMPRADOR paga en este acto y EL VENDEDOR declara recibir a su entera satisfacción.' },

{ slug: 'c-vicios-ocultos', title: 'Vicios ocultos', family: 'Económicas',
  description: 'Responsabilidad del vendedor por defectos no visibles.',
  body: 'VICIOS OCULTOS. EL VENDEDOR responde frente a EL COMPRADOR por los vicios ocultos del bien vendido que lo hagan impropio para el uso al que se destina o que disminuyan de tal modo ese uso que, de haberlos conocido, EL COMPRADOR no lo habría adquirido o habría pagado un precio menor.',
  legal_reference: 'Código Civil Dominicano, artículos 1641 y siguientes' },

{ slug: 'c-entrega-bien', title: 'Entrega del bien', family: 'Económicas',
  description: 'Momento y lugar de la entrega.',
  body: 'ENTREGA. EL VENDEDOR entregará el bien a EL COMPRADOR el {{fecha_entrega_larga}} en {{lugar_entrega}}, libre de todo gravamen y en el estado en que se encuentra, que EL COMPRADOR declara conocer y aceptar. Los riesgos se transmiten a EL COMPRADOR desde el momento de la entrega.' },

{ slug: 'v-descripcion-vehiculo', title: 'Descripción del vehículo', family: 'Económicas',
  description: 'Identificación completa del vehículo.',
  body: 'DESCRIPCIÓN DEL VEHÍCULO. El vehículo objeto del presente contrato es marca {{vehiculo_marca}}, modelo {{vehiculo_modelo}}, año {{vehiculo_anio}}, color {{vehiculo_color}}, chasis número {{vehiculo_chasis}}, placa {{vehiculo_placa}}, amparado en la matrícula número {{vehiculo_matricula}}.' },

{ slug: 'v-traspaso-vehiculo', title: 'Traspaso del vehículo', family: 'Económicas',
  description: 'Trámite de transferencia ante la DGII.',
  body: 'TRASPASO. Las partes se obligan a comparecer ante la Dirección General de Impuestos Internos para formalizar el traspaso de la matrícula dentro de los treinta (30) días siguientes a la firma. Los impuestos, tasas y gastos de dicho traspaso correrán por cuenta de {{parte_paga_traspaso}}.' },

{ slug: 'p-capital-prestamo', title: 'Capital del préstamo', family: 'Económicas',
  description: 'Monto prestado y su destino.',
  body: 'CAPITAL. EL PRESTAMISTA entrega a EL PRESTATARIO, quien declara recibir a su entera satisfacción, la suma de {{capital_letras}}, que este se obliga a restituir en las condiciones y plazos establecidos en el presente contrato.' },

{ slug: 'p-amortizacion', title: 'Amortización', family: 'Económicas',
  description: 'Plan de pagos del préstamo.',
  body: 'AMORTIZACIÓN. EL PRESTATARIO restituirá el capital más los intereses pactados mediante {{cantidad_cuotas}} cuotas mensuales, iguales y consecutivas de {{monto_cuota_letras}} cada una, pagaderas el día {{dia_pago}} de cada mes, hasta la total cancelación de la deuda.' },

{ slug: 'p-garantia-prestamo', title: 'Garantía del préstamo', family: 'Económicas',
  description: 'Bien o aval que respalda la deuda.',
  body: 'GARANTÍA. En respaldo de las obligaciones asumidas, EL PRESTATARIO constituye a favor de EL PRESTAMISTA garantía sobre {{descripcion_garantia}}. En caso de incumplimiento, EL PRESTAMISTA podrá ejecutar dicha garantía conforme a los procedimientos que establece la legislación dominicana.' },
]
