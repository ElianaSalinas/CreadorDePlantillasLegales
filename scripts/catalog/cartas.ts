/**
 * CATÁLOGO DE CARTAS · BORRADOR PARA REVISIÓN LEGAL
 *
 * ⚠️  Todas se cargan con status = 'DRAFT'. Ningún usuario las ve hasta
 *     que las revisen y publiquen legalcifuentes@gmail.com o
 *     jmarquez@saveconsult.net. Ninguna de estas redacciones ha pasado
 *     todavía por un abogado dominicano.
 *
 * ── POR QUÉ LAS CARTAS NO SON PLANTILLAS DE CONTRATO ──────────────
 *
 * El generador de contratos (scripts/generate-catalog.ts) monta cada
 * documento con tres secciones: comparecientes ("ENTRE ... Y DE LA OTRA
 * PARTE ..."), cláusulas numeradas y dos firmas.
 *
 * Una carta no tiene nada de eso. Tiene lugar y fecha, un destinatario,
 * un asunto, un cuerpo corrido y UNA sola firma. Si se cargaran por el
 * camino de los contratos, todas saldrían encabezadas por un "SE HA
 * CONVENIDO Y PACTADO LO SIGUIENTE" que no viene a cuento.
 *
 * Por eso las cartas tienen su propio archivo y su propio generador:
 *   npm run cartas:build   →   supabase/migrations/…_catalog_cartas.sql
 *
 * ── LO QUE SÍ COMPARTEN CON LOS CONTRATOS ─────────────────────────
 *
 * El motor. Son filas de `templates` con secciones y variables, así que
 * el editor, la vista previa, el PDF y el control de estado DRAFT →
 * PUBLISHED funcionan igual. No hay un segundo motor.
 *
 * ── LAS 8 REPETIDAS (decisión D12 del plan) ───────────────────────
 *
 * La lista original traía 227 entradas y 219 títulos únicos: ocho cartas
 * aparecían en dos o tres categorías. Aquí cada carta se carga UNA sola
 * vez, en la categoría donde el usuario la busca primero. Repetirla
 * haría que los revisores aprobaran el mismo texto tres veces y que el
 * usuario la encontrara duplicada. Que una carta aparezca en varias
 * categorías es un problema de navegación, no de catálogo, y se resuelve
 * en la Fase 6 con etiquetas.
 */

import type { VarMeta } from './variables'

export type CartaSeed = {
  /** Identificador estable. No cambiarlo una vez cargado. */
  slug: string
  /** Slug de template_categories. Debe existir en CATEGORIAS_CARTAS. */
  categoria: string
  titulo: string
  descripcion: string
  asunto: string
  /** Cuerpo de la carta. Párrafos separados por línea en blanco. */
  cuerpo: string
  /** Bloque del destinatario. Por defecto, el estándar con nombre y cargo. */
  destinatario?: string
  /** Fórmula de despedida. Por defecto, "Atentamente,". */
  despedida?: string
  /** Bloque de firma. Por defecto, una firma con nombre y cédula. */
  firma?: string
  /** Referencia legal, solo donde estoy seguro de la norma. */
  referencia?: string
}

/* ══════════════════ CATEGORÍAS ══════════════════
   Van con prefijo "cartas-" para no chocar con las once categorías de
   contratos que ya existen (laboral, empresarial, comercio…). Son otro
   producto y el usuario no las confunde. */

export const CATEGORIAS_CARTAS: { slug: string; nombre: string; orden: number }[] = [
  { slug: 'cartas-tramites',      nombre: 'Cartas · Trámites personales',   orden: 20 },
  { slug: 'cartas-laborales',     nombre: 'Cartas · Laborales',             orden: 21 },
  { slug: 'cartas-instituciones', nombre: 'Cartas · Instituciones públicas', orden: 22 },
  { slug: 'cartas-migracion',     nombre: 'Cartas · Migración y viajes',    orden: 23 },
  { slug: 'cartas-familia',       nombre: 'Cartas · Familia',               orden: 24 },
  { slug: 'cartas-empresas',      nombre: 'Cartas · Empresas',              orden: 25 },
  { slug: 'cartas-comercio',      nombre: 'Cartas · Compras y ventas',      orden: 26 },
  { slug: 'cartas-legales',       nombre: 'Cartas · Legales',               orden: 27 },
  { slug: 'cartas-impuestos',     nombre: 'Cartas · Impuestos',             orden: 28 },
]

/**
 * Cartas que sustituyen a una plantilla del catálogo de contratos.
 *
 * Alguna entró en su día por el camino de los contratos y salió con
 * comparecientes y dos firmas, que no es lo que es. Aquí se declara qué
 * slug antiguo reemplaza cada carta; el SQL generado lo archiva, y solo
 * si sigue en DRAFT: si un revisor ya lo aprobó, no se toca.
 */
export const SUSTITUYE: Record<string, string> = {
  'carta-intimacion-de-pago': 'intimacion-de-pago',
}

/* ══════════════════ BLOQUES ESTÁNDAR ══════════════════ */

/** Destinatario con nombre y cargo: lo normal. */
export const DESTINATARIO_ESTANDAR =
  `{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-`

/** Cuando la carta no va dirigida a nadie en concreto. */
export const DESTINATARIO_ABIERTO = `A QUIEN PUEDA INTERESAR:`

/** Cuando va a una institución, sin persona nombrada. */
export const DESTINATARIO_INSTITUCION =
  `{{destinatario_institucion}}
{{destinatario_cargo}}
Ciudad.-`

export const DESPEDIDA_ESTANDAR = 'Atentamente,'
export const DESPEDIDA_FORMAL = 'Sin otro particular por el momento, se despide con la mayor consideración,'

/** Una sola firma: quien escribe la carta. */
export const FIRMA_PERSONA =
  `_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}`

/** Firma de quien representa a una empresa. */
export const FIRMA_EMPRESA =
  `_______________________________
{{firmante_nombre}}
{{firmante_cargo}}
{{empresa_nombre}}
RNC {{empresa_rnc}}
{{firmante_telefono}} · {{firmante_correo}}`

/**
 * Variables que lleva toda carta, esté o no en el cuerpo.
 * El generador crea una variable por cada etiqueta que encuentre; estas
 * se declaran a mano porque viven en las secciones fijas.
 */
export const TAGS_CARTA = [
  'ciudad_firma',
  'fecha_carta',
  'firmante_nombre',
  'firmante_cedula',
  'firmante_telefono',
  'firmante_correo',
]

/* ══════════════════ LAS CARTAS ══════════════════
   Primera entrega: 30 cartas, las de mayor demanda. El resto del
   catálogo entra cuando estas estén aprobadas — meterle 219 de golpe a
   quien tiene 251 plantillas sin revisar desde el 2 de septiembre es la
   forma más segura de que no se apruebe ninguna. */

export const CARTAS: CartaSeed[] = [

/* ─────────── TRÁMITES PERSONALES (6) ─────────── */

{
  slug: 'carta-autorizacion-retirar-documentos',
  categoria: 'cartas-tramites',
  titulo: 'Carta de Autorización para Retirar Documentos',
  descripcion: 'Autoriza a otra persona a retirar documentos personales en una institución cuando uno no puede ir.',
  asunto: 'Autorización para retirar documentos',
  destinatario: DESTINATARIO_INSTITUCION,
  cuerpo:
`Por medio de la presente, yo, {{firmante_nombre}}, {{firmante_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral núm. {{firmante_cedula}}, domiciliado(a) y residente en {{firmante_domicilio}}, AUTORIZO de manera expresa al señor(a) {{autorizado_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{autorizado_cedula}}, para que en mi nombre y representación retire ante esa institución el (los) siguiente(s) documento(s):

{{documentos_a_retirar}}

Esta autorización se otorga únicamente para el fin antes indicado y tendrá vigencia hasta el {{fecha_vencimiento_larga}}.

Declaro que la persona autorizada actúa por cuenta mía y que reconozco como válida la entrega que se le haga, quedando esa institución liberada de toda responsabilidad frente a mí por dicha entrega.

Anexo copia de mi cédula de identidad y electoral y de la del autorizado.`,
},

{
  slug: 'carta-autorizacion-retirar-paquete',
  categoria: 'cartas-tramites',
  titulo: 'Carta de Autorización para Retirar Paquetes o Encomiendas',
  descripcion: 'Autoriza a un tercero a recoger un paquete, encomienda o envío a nombre de uno.',
  asunto: 'Autorización para retirar paquete',
  destinatario: DESTINATARIO_INSTITUCION,
  cuerpo:
`Por medio de la presente, yo, {{firmante_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{firmante_cedula}}, AUTORIZO al señor(a) {{autorizado_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{autorizado_cedula}}, a retirar en mi nombre el envío identificado como sigue:

{{descripcion_envio}}

Número de guía o referencia: {{numero_guia}}

Reconozco como recibida por mí toda entrega hecha a la persona aquí autorizada, y libero a esa empresa de responsabilidad por la misma. Anexo copia de ambas cédulas.`,
},

{
  slug: 'carta-poder-simple',
  categoria: 'cartas-tramites',
  titulo: 'Carta de Poder Simple',
  descripcion: 'Poder por escrito para que otra persona realice un trámite concreto en nombre de uno. No sustituye un poder notarial cuando la ley lo exige.',
  asunto: 'Poder para realizar gestión',
  destinatario: DESTINATARIO_ABIERTO,
  cuerpo:
`Yo, {{firmante_nombre}}, {{firmante_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral núm. {{firmante_cedula}}, domiciliado(a) y residente en {{firmante_domicilio}}, por medio del presente documento OTORGO PODER al señor(a) {{autorizado_nombre}}, {{autorizado_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral núm. {{autorizado_cedula}}, para que en mi nombre y representación realice la siguiente gestión:

{{gestion_encomendada}}

El apoderado queda facultado para firmar los documentos, recibos y formularios que la gestión requiera, y para recibir lo que en ella me corresponda.

Este poder es especial y se limita estrictamente a la gestión descrita. No comprende la facultad de vender, hipotecar, gravar ni disponer de bien alguno de mi patrimonio, ni de contraer obligaciones a mi cargo.

Vigencia: hasta el {{fecha_vencimiento_larga}}.

ADVERTENCIA: para determinados actos —entre otros la venta o hipoteca de inmuebles y las actuaciones ante el Registro de Títulos— la ley exige poder otorgado ante notario. Si su trámite es de esos, este documento no basta.`,
},

{
  slug: 'carta-declaracion-dependencia-economica',
  categoria: 'cartas-tramites',
  titulo: 'Declaración de Dependencia Económica',
  descripcion: 'Declara que una o varias personas dependen económicamente de quien firma. Se pide en trámites de seguro, migración y escuelas.',
  asunto: 'Declaración de dependencia económica',
  destinatario: DESTINATARIO_ABIERTO,
  cuerpo:
`Yo, {{firmante_nombre}}, {{firmante_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral núm. {{firmante_cedula}}, domiciliado(a) y residente en {{firmante_domicilio}}, DECLARO bajo la fe del juramento lo siguiente:

PRIMERO: Que me desempeño como {{firmante_ocupacion}} y percibo un ingreso mensual aproximado de {{ingreso_mensual_letras}}.

SEGUNDO: Que de mis ingresos dependen económicamente, de manera total y para su sustento, alojamiento, salud y educación, las siguientes personas:

{{personas_dependientes}}

TERCERO: Que dichas personas no perciben ingresos propios suficientes para su manutención y conviven conmigo en el domicilio antes indicado.

CUARTO: Que hago esta declaración para los fines legales que correspondan y asumo la responsabilidad de su contenido.

ADVERTENCIA: muchas instituciones exigen que esta declaración se haga ante notario y bajo juramento. Verifique el requisito antes de presentarla.`,
},

{
  slug: 'carta-solicitud-certificacion',
  categoria: 'cartas-tramites',
  titulo: 'Carta de Solicitud de Certificación',
  descripcion: 'Solicita a una institución la expedición de una certificación o constancia.',
  asunto: 'Solicitud de certificación',
  destinatario: DESTINATARIO_ESTANDAR,
  cuerpo:
`Cortésmente le saludo y me dirijo a usted para SOLICITAR la expedición de la siguiente certificación:

{{certificacion_solicitada}}

La requiero para el siguiente fin: {{finalidad_certificacion}}.

Mis datos, para localizar el expediente, son:

Nombre completo: {{firmante_nombre}}
Cédula de identidad y electoral: {{firmante_cedula}}
Número de expediente o referencia: {{numero_referencia}}

Agradeceré me informen el costo, si lo hubiere, y el plazo de entrega. Quedo atento(a) a través del teléfono {{firmante_telefono}} o del correo {{firmante_correo}}.`,
},

{
  slug: 'carta-solicitud-correccion-datos',
  categoria: 'cartas-tramites',
  titulo: 'Carta de Solicitud de Corrección de Datos',
  descripcion: 'Pide a una institución o empresa que corrija un dato personal equivocado en sus registros.',
  asunto: 'Solicitud de rectificación de datos personales',
  destinatario: DESTINATARIO_ESTANDAR,
  referencia: 'Ley núm. 172-13 sobre protección de datos personales',
  cuerpo:
`Cortésmente le saludo y me dirijo a usted en ejercicio de mi derecho de rectificación, para SOLICITAR la corrección del siguiente dato que figura de manera errónea en sus registros:

Dato como aparece actualmente: {{dato_incorrecto}}
Dato correcto: {{dato_correcto}}

El error afecta al registro identificado con {{numero_referencia}}, correspondiente a {{firmante_nombre}}, cédula de identidad y electoral núm. {{firmante_cedula}}.

Anexo los documentos que acreditan el dato correcto.

La Ley núm. 172-13 sobre protección de datos personales reconoce al titular el derecho a que sus datos sean exactos y a obtener su rectificación cuando no lo sean. Agradeceré la corrección y que se me confirme por escrito una vez realizada.`,
},

/* ─────────── LABORALES (9) ─────────── */

{
  slug: 'carta-renuncia-voluntaria',
  categoria: 'cartas-laborales',
  titulo: 'Carta de Renuncia Voluntaria',
  descripcion: 'Comunica al empleador la decisión de dejar el trabajo por voluntad propia.',
  asunto: 'Renuncia al cargo de {{cargo_ocupado}}',
  destinatario: DESTINATARIO_ESTANDAR,
  referencia: 'Código de Trabajo de la República Dominicana (Ley núm. 16-92)',
  cuerpo:
`Por medio de la presente le comunico mi decisión de RENUNCIAR de manera voluntaria al cargo de {{cargo_ocupado}}, que vengo desempeñando en {{empresa_nombre}} desde el {{fecha_ingreso_larga}}.

Mi último día de labores será el {{fecha_ultimo_dia_larga}}.

Durante el tiempo que resta me pongo a disposición para entregar de manera ordenada las funciones a mi cargo, los bienes de la empresa que tengo asignados y la información necesaria para la continuidad del trabajo.

Agradezco la oportunidad y la experiencia adquirida durante este tiempo.

ADVERTENCIA IMPORTANTE: la renuncia y el desahucio no producen los mismos efectos económicos. Quien renuncia por voluntad propia no genera el auxilio de cesantía que sí genera el desahucio ejercido por el empleador. Si usted está dejando el trabajo por faltas cometidas por su empleador, lo que corresponde no es una renuncia sino una dimisión, que tiene plazos y formalidades propias. Consulte a un abogado laboral antes de firmar.`,
},

{
  slug: 'carta-constancia-de-trabajo',
  categoria: 'cartas-laborales',
  titulo: 'Constancia de Trabajo',
  descripcion: 'Documento con el que la empresa certifica que una persona trabaja allí, su cargo y su salario. La piden bancos, embajadas y arrendadores.',
  asunto: 'Constancia de trabajo',
  destinatario: DESTINATARIO_ABIERTO,
  firma: FIRMA_EMPRESA,
  cuerpo:
`Por medio de la presente, {{empresa_nombre}}, RNC {{empresa_rnc}}, con domicilio social en {{empresa_domicilio}}, HACE CONSTAR que:

El señor(a) {{empleado_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{empleado_cedula}}, labora en esta empresa desde el {{fecha_ingreso_larga}}, desempeñando el cargo de {{cargo_ocupado}}, bajo un contrato de trabajo {{tipo_contrato}}.

Devenga un salario mensual de {{salario_mensual_letras}}.

La presente constancia se expide a solicitud de la parte interesada, en {{ciudad_firma}}, para los fines que estime convenientes.`,
},

{
  slug: 'carta-recomendacion-laboral',
  categoria: 'cartas-laborales',
  titulo: 'Carta de Recomendación Laboral',
  descripcion: 'Recomienda a un ex empleado o colaborador, describiendo su desempeño.',
  asunto: 'Carta de recomendación',
  destinatario: DESTINATARIO_ABIERTO,
  firma: FIRMA_EMPRESA,
  cuerpo:
`Por medio de la presente me complace recomendar al señor(a) {{empleado_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{empleado_cedula}}, quien laboró en {{empresa_nombre}} desde el {{fecha_ingreso_larga}} hasta el {{fecha_egreso_larga}}, desempeñando el cargo de {{cargo_ocupado}}.

Durante ese tiempo tuvo a su cargo, entre otras, las siguientes funciones:

{{funciones_desempenadas}}

{{valoracion_desempeno}}

Su salida de la empresa se produjo por {{motivo_salida}}, en buenos términos.

Quedo a disposición para ampliar esta referencia a través del teléfono {{firmante_telefono}} o del correo {{firmante_correo}}.`,
},

{
  slug: 'carta-solicitud-empleo',
  categoria: 'cartas-laborales',
  titulo: 'Carta de Solicitud de Empleo',
  descripcion: 'Acompaña el currículo al postularse a una vacante.',
  asunto: 'Solicitud para la vacante de {{cargo_solicitado}}',
  destinatario: DESTINATARIO_ESTANDAR,
  cuerpo:
`Cortésmente le saludo y me dirijo a usted con el interés de postularme a la vacante de {{cargo_solicitado}} en {{empresa_destino}}, de la cual tuve conocimiento por {{fuente_vacante}}.

{{presentacion_candidato}}

{{motivo_interes}}

Anexo mi currículo con el detalle de mi formación y experiencia. Quedo a su disposición para una entrevista en el momento que estimen oportuno, a través del teléfono {{firmante_telefono}} o del correo {{firmante_correo}}.`,
},

{
  slug: 'carta-solicitud-vacaciones',
  categoria: 'cartas-laborales',
  titulo: 'Carta de Solicitud de Vacaciones',
  descripcion: 'Solicita al empleador el disfrute del período de vacaciones.',
  asunto: 'Solicitud de vacaciones',
  destinatario: DESTINATARIO_ESTANDAR,
  referencia: 'Código de Trabajo de la República Dominicana (Ley núm. 16-92)',
  cuerpo:
`Cortésmente me dirijo a usted para SOLICITAR el disfrute de mi período de vacaciones correspondiente al año {{ano_vacaciones}}.

Propongo tomarlas desde el {{fecha_desde_larga}} hasta el {{fecha_hasta_larga}}, reintegrándome a mis labores el {{fecha_reintegro_larga}}.

Durante mi ausencia, mis funciones quedarán cubiertas de la siguiente manera:

{{plan_cobertura}}

Agradeceré me confirmen la aprobación para organizar la entrega de pendientes.`,
},

{
  slug: 'carta-solicitud-permiso-laboral',
  categoria: 'cartas-laborales',
  titulo: 'Carta de Solicitud de Permiso o Licencia',
  descripcion: 'Pide autorización para ausentarse del trabajo por un motivo concreto.',
  asunto: 'Solicitud de permiso',
  destinatario: DESTINATARIO_ESTANDAR,
  cuerpo:
`Cortésmente me dirijo a usted para SOLICITAR un permiso para ausentarme de mis labores desde el {{fecha_desde_larga}} hasta el {{fecha_hasta_larga}}, por el siguiente motivo:

{{motivo_permiso}}

{{documentos_sustento}}

Me reintegraré a mis funciones el {{fecha_reintegro_larga}}. Durante mi ausencia mis pendientes quedarán al día y coordinados según se me indique.`,
},

{
  slug: 'carta-solicitud-aumento-salario',
  categoria: 'cartas-laborales',
  titulo: 'Carta de Solicitud de Aumento de Salario',
  descripcion: 'Plantea al empleador una revisión del salario, con argumentos.',
  asunto: 'Solicitud de revisión salarial',
  destinatario: DESTINATARIO_ESTANDAR,
  cuerpo:
`Cortésmente me dirijo a usted para solicitar la revisión de mi salario actual.

Ingresé a la empresa el {{fecha_ingreso_larga}} en el cargo de {{cargo_ocupado}}, y desde entonces mis responsabilidades han crecido de la siguiente manera:

{{responsabilidades_asumidas}}

{{logros_alcanzados}}

Mi salario mensual actual es de {{salario_actual_letras}} y no ha sido revisado desde el {{fecha_ultima_revision_larga}}. Planteo respetuosamente una revisión a {{salario_propuesto_letras}}.

Quedo a su disposición para conversarlo cuando lo estime oportuno.`,
},

{
  slug: 'carta-descargo-empleado',
  categoria: 'cartas-laborales',
  titulo: 'Carta de Descargo del Empleado',
  descripcion: 'Respuesta escrita del trabajador a una amonestación o a la imputación de una falta.',
  asunto: 'Descargo respecto de la comunicación de fecha {{fecha_comunicacion_larga}}',
  destinatario: DESTINATARIO_ESTANDAR,
  cuerpo:
`Acuso recibo de su comunicación de fecha {{fecha_comunicacion_larga}}, mediante la cual se me imputa lo siguiente:

{{hecho_imputado}}

Dentro del plazo concedido, presento mi descargo:

{{descargo_hechos}}

{{pruebas_ofrecidas}}

Por lo anterior, solicito respetuosamente que se reconsidere la medida y que esta comunicación se agregue a mi expediente junto a la que la motivó.

Reitero mi compromiso con el buen desempeño de mis funciones.

ADVERTENCIA: si la empresa le ha imputado una falta que pueda dar lugar a despido, presente su descargo por escrito, con acuse de recibo, y consulte a un abogado laboral. Guardar silencio puede interpretarse en su contra.`,
},

{
  slug: 'carta-amonestacion-empleado',
  categoria: 'cartas-laborales',
  titulo: 'Carta de Amonestación al Empleado',
  descripcion: 'Comunicación del empleador que deja constancia escrita de una falta y de la advertencia.',
  asunto: 'Amonestación',
  destinatario: DESTINATARIO_ESTANDAR,
  firma: FIRMA_EMPRESA,
  cuerpo:
`Por medio de la presente, {{empresa_nombre}} le comunica formalmente lo siguiente.

En fecha {{fecha_hecho_larga}} se produjo el siguiente hecho:

{{hecho_imputado}}

Dicha conducta contraviene {{norma_incumplida}}.

Por lo anterior se le AMONESTA por escrito y se le advierte que la reincidencia podrá dar lugar a las medidas que el Código de Trabajo y el reglamento interno autorizan.

Usted dispone de {{dias_para_descargo}} días hábiles para presentar por escrito su descargo, el cual se agregará a su expediente junto a esta comunicación.

Recibido conforme por el trabajador:


_______________________________
{{empleado_nombre}}
Cédula núm. {{empleado_cedula}}
Fecha de recepción: ____________`,
},

/* ─────────── INSTITUCIONES PÚBLICAS (3) ─────────── */

{
  slug: 'carta-solicitud-institucion-publica',
  categoria: 'cartas-instituciones',
  titulo: 'Carta de Solicitud a Institución Pública',
  descripcion: 'Solicitud formal dirigida a una institución del Estado.',
  asunto: 'Solicitud de {{objeto_solicitud}}',
  destinatario: DESTINATARIO_ESTANDAR,
  cuerpo:
`Cortésmente le saludo y me dirijo a usted, en mi calidad de {{calidad_solicitante}}, para SOLICITAR lo siguiente:

{{objeto_solicitud}}

Fundamento la solicitud en lo siguiente:

{{fundamento_solicitud}}

Anexo la documentación de sustento:

{{documentos_anexos}}

Agradeceré que la respuesta me sea comunicada al domicilio {{firmante_domicilio}}, al teléfono {{firmante_telefono}} o al correo {{firmante_correo}}.`,
},

{
  slug: 'carta-respuesta-requerimiento',
  categoria: 'cartas-instituciones',
  titulo: 'Carta de Respuesta a Requerimiento',
  descripcion: 'Contesta dentro de plazo un requerimiento de información de una institución.',
  asunto: 'Respuesta al requerimiento núm. {{numero_referencia}}',
  destinatario: DESTINATARIO_ESTANDAR,
  cuerpo:
`Acuso recibo del requerimiento núm. {{numero_referencia}}, de fecha {{fecha_requerimiento_larga}}, recibido el {{fecha_recepcion_larga}}, y dentro del plazo concedido doy respuesta en los términos siguientes.

Sobre lo requerido:

{{respuesta_requerimiento}}

Documentación que se acompaña:

{{documentos_anexos}}

{{reserva_derechos}}

Quedo a disposición para ampliar cualquier punto a través del teléfono {{firmante_telefono}} o del correo {{firmante_correo}}.`,
},

{
  slug: 'carta-reclamacion-proconsumidor',
  categoria: 'cartas-instituciones',
  titulo: 'Reclamación ante Pro Consumidor',
  descripcion: 'Reclamación por un producto o servicio defectuoso ante el Instituto Nacional de Protección de los Derechos del Consumidor.',
  asunto: 'Reclamación contra {{proveedor_nombre}}',
  destinatario: DESTINATARIO_INSTITUCION,
  referencia: 'Ley núm. 358-05, General de Protección de los Derechos del Consumidor',
  cuerpo:
`Cortésmente me dirijo a esa institución para presentar formal RECLAMACIÓN contra {{proveedor_nombre}}, RNC {{proveedor_rnc}}, con establecimiento en {{proveedor_domicilio}}, por los hechos que expongo.

PRIMERO — Lo adquirido. En fecha {{fecha_compra_larga}} adquirí {{descripcion_producto}}, por un valor de {{monto_pagado_letras}}, según consta en {{comprobante_compra}}.

SEGUNDO — El problema. {{descripcion_problema}}

TERCERO — Lo gestionado con el proveedor. {{gestiones_previas}}

CUARTO — Lo que solicito. {{pretension}}

Anexo copia de mi cédula, del comprobante de compra y de las comunicaciones sostenidas con el proveedor.

La Ley núm. 358-05, General de Protección de los Derechos del Consumidor, reconoce el derecho a recibir productos y servicios de la calidad ofrecida y a ser resarcido cuando no lo son.`,
},

/* ─────────── MIGRACIÓN Y VIAJES (3) ─────────── */

{
  slug: 'carta-invitacion-visa',
  categoria: 'cartas-migracion',
  titulo: 'Carta de Invitación para Visa',
  descripcion: 'Invita formalmente a una persona extranjera a visitar el país, para acompañar su solicitud de visa.',
  asunto: 'Carta de invitación a favor de {{invitado_nombre}}',
  destinatario: DESTINATARIO_INSTITUCION,
  cuerpo:
`Por medio de la presente, yo, {{firmante_nombre}}, {{firmante_nacionalidad}}, mayor de edad, portador(a) de {{firmante_documento}} núm. {{firmante_cedula}}, con domicilio en {{firmante_domicilio}}, tengo a bien INVITAR formalmente al señor(a) {{invitado_nombre}}, de nacionalidad {{invitado_nacionalidad}}, portador(a) del pasaporte núm. {{invitado_pasaporte}}, a visitarme.

Motivo de la visita: {{motivo_visita}}.
Vínculo que nos une: {{vinculo_invitado}}.
Fecha prevista de llegada: {{fecha_llegada_larga}}.
Fecha prevista de regreso: {{fecha_regreso_larga}}.
Lugar de alojamiento durante la estadía: {{lugar_alojamiento}}.

{{compromiso_gastos}}

Declaro que la información aquí consignada es cierta y asumo la responsabilidad de su contenido.

ADVERTENCIA: cada consulado fija sus propios requisitos y muchos exigen que esta carta esté legalizada ante notario y, en algunos casos, apostillada. Confirme el requisito con el consulado antes de presentarla.`,
},

{
  slug: 'carta-sostenimiento-economico',
  categoria: 'cartas-migracion',
  titulo: 'Carta de Sostenimiento Económico',
  descripcion: 'Quien firma se compromete a cubrir los gastos de otra persona durante su estadía o sus estudios.',
  asunto: 'Compromiso de sostenimiento económico a favor de {{beneficiario_nombre}}',
  destinatario: DESTINATARIO_ABIERTO,
  cuerpo:
`Yo, {{firmante_nombre}}, {{firmante_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral núm. {{firmante_cedula}}, domiciliado(a) en {{firmante_domicilio}}, de ocupación {{firmante_ocupacion}}, DECLARO Y ME COMPROMETO a lo siguiente:

PRIMERO: Que percibo un ingreso mensual de {{ingreso_mensual_letras}}, proveniente de {{fuente_ingresos}}.

SEGUNDO: Que asumo de manera voluntaria el sostenimiento económico del señor(a) {{beneficiario_nombre}}, portador(a) de {{beneficiario_documento}} núm. {{beneficiario_documento_numero}}, con quien me une el siguiente vínculo: {{vinculo_beneficiario}}.

TERCERO: Que este compromiso comprende los gastos de {{gastos_cubiertos}}, durante el período comprendido entre el {{fecha_desde_larga}} y el {{fecha_hasta_larga}}.

CUARTO: Que asumo dicho compromiso con mis propios recursos y que la persona beneficiaria no representará carga alguna para el Estado.

Anexo los documentos que acreditan mis ingresos.`,
},

{
  slug: 'carta-no-objecion-viaje',
  categoria: 'cartas-migracion',
  titulo: 'Carta de No Objeción para Viaje',
  descripcion: 'La empresa o institución declara no tener objeción a que la persona viaje, y confirma su vínculo y su regreso.',
  asunto: 'No objeción para viaje de {{empleado_nombre}}',
  destinatario: DESTINATARIO_ABIERTO,
  firma: FIRMA_EMPRESA,
  cuerpo:
`Por medio de la presente, {{empresa_nombre}}, RNC {{empresa_rnc}}, con domicilio social en {{empresa_domicilio}}, HACE CONSTAR que:

El señor(a) {{empleado_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{empleado_cedula}}, labora en esta empresa desde el {{fecha_ingreso_larga}} en el cargo de {{cargo_ocupado}}.

Esta empresa NO TIENE OBJECIÓN a que realice un viaje a {{pais_destino}} entre el {{fecha_desde_larga}} y el {{fecha_hasta_larga}}, por motivo de {{motivo_viaje}}.

Se hace constar igualmente que su puesto de trabajo le será conservado y que se espera su reintegro a sus funciones el {{fecha_reintegro_larga}}.

La presente se expide a solicitud de la parte interesada, para los fines que estime convenientes.`,
},

/* ─────────── FAMILIA (2) ─────────── */

{
  slug: 'carta-autorizacion-viaje-menor',
  categoria: 'cartas-familia',
  titulo: 'Autorización de Viaje de Menor',
  descripcion: 'Los padres autorizan a que un menor de edad viaje, solo o acompañado por un tercero.',
  asunto: 'Autorización de viaje del menor {{menor_nombre}}',
  destinatario: DESTINATARIO_INSTITUCION,
  referencia: 'Ley núm. 136-03, Código para el Sistema de Protección y los Derechos Fundamentales de Niños, Niñas y Adolescentes',
  cuerpo:
`Nosotros, {{padre_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{padre_cedula}}, y {{madre_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{madre_cedula}}, en nuestra calidad de padres del menor {{menor_nombre}}, nacido(a) el {{menor_fecha_nacimiento_larga}}, portador(a) del acta de nacimiento núm. {{menor_acta_nacimiento}} y del pasaporte núm. {{menor_pasaporte}}, por medio de la presente AUTORIZAMOS:

Que nuestro hijo(a) viaje a {{pais_destino}}, saliendo el {{fecha_salida_larga}} y regresando el {{fecha_regreso_larga}}, {{modalidad_viaje}}.

Persona responsable durante el viaje: {{acompanante_nombre}}, portador(a) de {{acompanante_documento}} núm. {{acompanante_documento_numero}}, con quien nos une el siguiente vínculo: {{vinculo_acompanante}}.

Lugar de alojamiento: {{lugar_alojamiento}}.

Autorizamos igualmente a que, en caso de emergencia médica y ante la imposibilidad de contactarnos, se le brinde la atención de urgencia que su salud requiera.

Podemos ser localizados en los teléfonos {{padre_telefono}} y {{madre_telefono}}.

ADVERTENCIA: la salida del país de un menor de edad exige autorización otorgada conforme a la ley y su presentación ante las autoridades migratorias; en la práctica se requiere que esté legalizada ante notario y, con frecuencia, apostillada. Este documento es el borrador del texto: confirme la formalidad exigida antes de viajar.`,
},

{
  slug: 'carta-consentimiento-progenitor',
  categoria: 'cartas-familia',
  titulo: 'Consentimiento del Otro Progenitor',
  descripcion: 'Uno de los padres autoriza un trámite del hijo menor: pasaporte, escuela, cambio de centro o atención médica.',
  asunto: 'Consentimiento para trámite del menor {{menor_nombre}}',
  destinatario: DESTINATARIO_INSTITUCION,
  referencia: 'Ley núm. 136-03, Código para el Sistema de Protección y los Derechos Fundamentales de Niños, Niñas y Adolescentes',
  cuerpo:
`Yo, {{firmante_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{firmante_cedula}}, en mi calidad de {{calidad_progenitor}} del menor {{menor_nombre}}, nacido(a) el {{menor_fecha_nacimiento_larga}}, portador(a) del acta de nacimiento núm. {{menor_acta_nacimiento}}, por medio de la presente doy mi CONSENTIMIENTO expreso para lo siguiente:

{{tramite_autorizado}}

Este consentimiento se otorga en interés superior del menor y podrá ser presentado ante {{destinatario_institucion}} para los fines correspondientes.

Anexo copia de mi cédula de identidad y electoral y del acta de nacimiento del menor.`,
},

/* ─────────── EMPRESAS (3) ─────────── */

{
  slug: 'carta-referencia-comercial',
  categoria: 'cartas-empresas',
  titulo: 'Carta de Referencia Comercial',
  descripcion: 'Una empresa da referencia sobre el comportamiento comercial de un cliente o suplidor.',
  asunto: 'Referencia comercial de {{referido_nombre}}',
  destinatario: DESTINATARIO_ABIERTO,
  firma: FIRMA_EMPRESA,
  cuerpo:
`Por medio de la presente, {{empresa_nombre}}, RNC {{empresa_rnc}}, HACE CONSTAR que mantiene relaciones comerciales con {{referido_nombre}}, RNC o cédula núm. {{referido_identificacion}}, desde el {{fecha_inicio_relacion_larga}}.

Durante ese período, la relación se ha desarrollado en los siguientes términos:

Naturaleza de la relación: {{naturaleza_relacion}}
Volumen aproximado de operaciones: {{volumen_operaciones}}
Condiciones de pago pactadas: {{condiciones_pago}}
Comportamiento de pago observado: {{comportamiento_pago}}

{{observaciones_adicionales}}

La presente referencia se expide a solicitud de la parte interesada y refleja únicamente la experiencia de esta empresa. Quedamos a disposición para ampliarla en {{firmante_telefono}} o {{firmante_correo}}.`,
},

{
  slug: 'carta-autorizacion-representante',
  categoria: 'cartas-empresas',
  titulo: 'Carta de Autorización de Representante',
  descripcion: 'La empresa designa a una persona para actuar en su nombre ante un tercero o una institución.',
  asunto: 'Designación de representante',
  destinatario: DESTINATARIO_INSTITUCION,
  firma: FIRMA_EMPRESA,
  cuerpo:
`Por medio de la presente, {{empresa_nombre}}, RNC {{empresa_rnc}}, con domicilio social en {{empresa_domicilio}}, debidamente representada por el(la) suscrito(a) en su calidad de {{firmante_cargo}}, AUTORIZA al señor(a) {{autorizado_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{autorizado_cedula}}, quien ocupa el cargo de {{autorizado_cargo}} en esta empresa, para que la represente ante {{destinatario_institucion}} en lo siguiente:

{{gestion_encomendada}}

El representante queda facultado para firmar los formularios y recibos que la gestión requiera y para recibir las comunicaciones que de ella se deriven.

Esta autorización no comprende la facultad de contraer obligaciones a cargo de la empresa, ni de disponer de sus bienes o fondos, salvo lo expresamente indicado más arriba.

Vigencia: hasta el {{fecha_vencimiento_larga}}, o hasta que esta empresa comunique su revocación por escrito.`,
},

{
  slug: 'carta-presentacion-empresa',
  categoria: 'cartas-empresas',
  titulo: 'Carta de Presentación de Empresa',
  descripcion: 'Presenta la empresa y sus servicios a un cliente potencial.',
  asunto: 'Presentación de {{empresa_nombre}}',
  destinatario: DESTINATARIO_ESTANDAR,
  firma: FIRMA_EMPRESA,
  cuerpo:
`Cortésmente le saludo en nombre de {{empresa_nombre}}, RNC {{empresa_rnc}}, empresa dedicada a {{actividad_empresa}} desde el año {{ano_fundacion}}.

{{presentacion_empresa}}

Los servicios que ofrecemos y que entendemos de interés para {{destinatario_institucion}} son:

{{servicios_ofrecidos}}

{{diferenciales}}

Quedo a su disposición para coordinar una reunión y presentarle una propuesta ajustada a sus necesidades, a través del teléfono {{firmante_telefono}} o del correo {{firmante_correo}}.`,
},

/* ─────────── COMPRAS Y VENTAS (2) ─────────── */

{
  slug: 'carta-reclamacion-producto-defectuoso',
  categoria: 'cartas-comercio',
  titulo: 'Carta de Reclamación por Producto o Servicio Defectuoso',
  descripcion: 'Reclama directamente al comercio antes de acudir a Pro Consumidor.',
  asunto: 'Reclamación por {{descripcion_producto}}',
  destinatario: DESTINATARIO_ESTANDAR,
  referencia: 'Ley núm. 358-05, General de Protección de los Derechos del Consumidor',
  cuerpo:
`Cortésmente me dirijo a ustedes para presentar una RECLAMACIÓN formal.

En fecha {{fecha_compra_larga}} adquirí en su establecimiento {{descripcion_producto}}, por un valor de {{monto_pagado_letras}}, según {{comprobante_compra}}.

El problema que presenta es el siguiente:

{{descripcion_problema}}

{{gestiones_previas}}

En consecuencia, SOLICITO: {{pretension}}

Agradeceré una respuesta dentro de los {{dias_respuesta}} días siguientes al recibo de esta comunicación, al teléfono {{firmante_telefono}} o al correo {{firmante_correo}}.

De no recibir respuesta en dicho plazo, me reservo el derecho de acudir a Pro Consumidor y a las demás vías que la ley me reconoce.`,
},

{
  slug: 'carta-oferta-comercial',
  categoria: 'cartas-comercio',
  titulo: 'Carta de Oferta o Cotización Comercial',
  descripcion: 'Presenta por escrito el precio y las condiciones de un producto o servicio.',
  asunto: 'Cotización núm. {{numero_referencia}}',
  destinatario: DESTINATARIO_ESTANDAR,
  firma: FIRMA_EMPRESA,
  cuerpo:
`Cortésmente le saludo y, atendiendo a su solicitud, tengo a bien presentarle la siguiente oferta.

Objeto: {{objeto_oferta}}

Detalle:

{{detalle_oferta}}

Precio: {{precio_oferta_letras}}, {{itbis_incluido}}.
Forma de pago: {{forma_pago_oferta}}.
Plazo de entrega o ejecución: {{plazo_entrega}}.
Garantía: {{garantia_ofrecida}}.
Validez de esta oferta: {{dias_validez}} días a partir de su fecha.

{{condiciones_adicionales}}

Quedo a su disposición para cualquier aclaración en el teléfono {{firmante_telefono}} o el correo {{firmante_correo}}.`,
},

/* ─────────── LEGALES (2) ─────────── */

{
  slug: 'carta-intimacion-de-pago',
  categoria: 'cartas-legales',
  titulo: 'Intimación de Pago',
  descripcion: 'Requiere formalmente el pago de una deuda vencida y deja constancia de la puesta en mora.',
  asunto: 'Intimación de pago',
  destinatario: DESTINATARIO_ESTANDAR,
  referencia: 'Código Civil Dominicano, artículo 1139',
  cuerpo:
`Por medio de la presente, y en mi calidad de acreedor(a), le INTIMO formalmente al pago de la suma que se detalla.

ORIGEN DE LA DEUDA: {{origen_deuda}}

MONTO ADEUDADO: {{monto_adeudado_letras}}
FECHA EN QUE SE HIZO EXIGIBLE: {{fecha_vencimiento_larga}}
{{detalle_intereses}}

En consecuencia, le requiero para que dentro del plazo de {{dias_plazo_pago}} días, contados a partir del recibo de esta comunicación, proceda al pago íntegro de dicha suma, mediante {{forma_pago_requerida}}.

Vencido el plazo sin haberse efectuado el pago, quedará usted constituido en mora y me reservo el derecho de accionar por las vías legales correspondientes, con los intereses, costas y honorarios que procedan.

ADVERTENCIA: la puesta en mora produce sus efectos plenos cuando se hace por acto de alguacil. Esta carta deja constancia del requerimiento, pero si la deuda es de importancia, encargue el acto a un abogado antes de que corran los plazos.`,
},

{
  slug: 'carta-descargo-y-finiquito',
  categoria: 'cartas-legales',
  titulo: 'Carta de Descargo y Finiquito',
  descripcion: 'Quien recibe un pago declara que nada más se le adeuda por ese concepto.',
  asunto: 'Descargo y finiquito',
  destinatario: DESTINATARIO_ESTANDAR,
  cuerpo:
`Yo, {{firmante_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{firmante_cedula}}, por medio de la presente DECLARO:

PRIMERO: Que he recibido de {{deudor_nombre}}, {{deudor_identificacion}}, la suma de {{monto_recibido_letras}}, mediante {{forma_pago_recibida}}, en fecha {{fecha_pago_larga}}.

SEGUNDO: Que dicha suma corresponde íntegramente a {{concepto_pago}}.

TERCERO: Que con el recibo de dicha suma otorgo el más amplio DESCARGO Y FINIQUITO por ese concepto, declarando que nada más se me adeuda por él y que no tengo reclamación alguna que formular al respecto.

ADVERTENCIA: firmar un descargo cierra la posibilidad de reclamar después por ese mismo concepto. Lea con cuidado qué está declarando recibido y por qué concepto. En materia laboral, un descargo firmado no impide reclamar los derechos que la ley declara irrenunciables, pero complica la reclamación: consulte a un abogado antes de firmar.`,
},

/* ─────────── IMPUESTOS (2) ─────────── */

{
  slug: 'carta-solicitud-dgii',
  categoria: 'cartas-impuestos',
  titulo: 'Carta de Solicitud a la DGII',
  descripcion: 'Solicitud dirigida a la Dirección General de Impuestos Internos: constancias, autorizaciones o actualización de datos.',
  asunto: 'Solicitud de {{objeto_solicitud}}',
  destinatario: DESTINATARIO_INSTITUCION,
  cuerpo:
`Cortésmente me dirijo a esa Dirección General para SOLICITAR lo siguiente:

{{objeto_solicitud}}

Datos del contribuyente:

Nombre o razón social: {{contribuyente_nombre}}
RNC o cédula: {{contribuyente_rnc}}
Domicilio fiscal: {{contribuyente_domicilio}}
Actividad económica: {{actividad_economica}}

Motivo de la solicitud:

{{fundamento_solicitud}}

Anexo la documentación de sustento: {{documentos_anexos}}

Agradeceré que la respuesta me sea comunicada al correo {{firmante_correo}} o al teléfono {{firmante_telefono}}.`,
},

{
  slug: 'carta-respuesta-requerimiento-dgii',
  categoria: 'cartas-impuestos',
  titulo: 'Respuesta a Requerimiento de la DGII',
  descripcion: 'Contesta dentro de plazo un requerimiento de información o una notificación de la DGII.',
  asunto: 'Respuesta al requerimiento núm. {{numero_referencia}}',
  destinatario: DESTINATARIO_INSTITUCION,
  cuerpo:
`Acuso recibo del requerimiento núm. {{numero_referencia}}, de fecha {{fecha_requerimiento_larga}}, notificado el {{fecha_recepcion_larga}}, correspondiente al contribuyente {{contribuyente_nombre}}, RNC {{contribuyente_rnc}}, y dentro del plazo concedido doy respuesta.

Sobre el período fiscal {{periodo_fiscal}} y los puntos requeridos:

{{respuesta_requerimiento}}

Documentación que se acompaña:

{{documentos_anexos}}

{{reserva_derechos}}

Quedo a disposición de esa Dirección General para cualquier aclaración adicional.

ADVERTENCIA: los plazos en materia tributaria son perentorios y su vencimiento tiene consecuencias. Si el requerimiento anuncia una determinación de oficio o una sanción, consulte a un asesor fiscal o a un abogado tributario antes de responder.`,
},

]

/* ══════════════════ ETIQUETAS DE LAS VARIABLES ══════════════════
   Solo lo que el generador no deduce bien del nombre, o donde la
   pregunta al usuario importa. Lo demás se infiere en variables.ts. */


export const META_CARTAS: Record<string, VarMeta> = {
  /* Encabezado y firma, en todas las cartas */
  fecha_carta: {
    label: 'Fecha de la carta',
    question: '¿Con qué fecha se firma la carta?',
    type: 'date',
    derived: { transform: 'fecha_larga', as: 'fecha_carta_larga' },
  },
  fecha_desde: {
    label: 'Fecha de inicio',
    question: '¿Desde qué día?',
    type: 'date',
    derived: { transform: 'fecha_larga', as: 'fecha_desde_larga' },
  },
  fecha_hasta: {
    label: 'Fecha de término',
    question: '¿Hasta qué día?',
    type: 'date',
    derived: { transform: 'fecha_larga', as: 'fecha_hasta_larga' },
  },
  fecha_compra: { label: 'Fecha de la compra', question: '¿Qué día se compró?', type: 'date', derived: { transform: 'fecha_larga', as: 'fecha_compra_larga' } },
  fecha_comunicacion: { label: 'Fecha de la comunicación recibida', type: 'date', derived: { transform: 'fecha_larga', as: 'fecha_comunicacion_larga' } },
  fecha_hecho: { label: 'Fecha en que ocurrió el hecho', type: 'date', derived: { transform: 'fecha_larga', as: 'fecha_hecho_larga' } },
  fecha_ingreso: { label: 'Fecha de ingreso a la empresa', question: '¿Cuándo empezó a trabajar allí?', type: 'date', derived: { transform: 'fecha_larga', as: 'fecha_ingreso_larga' } },
  fecha_egreso: { label: 'Fecha de salida de la empresa', question: '¿Cuándo dejó de trabajar allí?', type: 'date', derived: { transform: 'fecha_larga', as: 'fecha_egreso_larga' } },
  fecha_ultimo_dia: { label: 'Último día de labores', question: '¿Cuál será su último día de trabajo?', type: 'date', derived: { transform: 'fecha_larga', as: 'fecha_ultimo_dia_larga' } },
  fecha_reintegro: { label: 'Fecha de reintegro', question: '¿Qué día vuelve a sus labores?', type: 'date', derived: { transform: 'fecha_larga', as: 'fecha_reintegro_larga' } },
  fecha_ultima_revision: { label: 'Fecha de la última revisión salarial', type: 'date', derived: { transform: 'fecha_larga', as: 'fecha_ultima_revision_larga' } },
  fecha_inicio_relacion: { label: 'Inicio de la relación comercial', question: '¿Desde cuándo trabajan juntos?', type: 'date', derived: { transform: 'fecha_larga', as: 'fecha_inicio_relacion_larga' } },
  fecha_llegada: { label: 'Fecha de llegada', type: 'date', derived: { transform: 'fecha_larga', as: 'fecha_llegada_larga' } },
  fecha_regreso: { label: 'Fecha de regreso', type: 'date', derived: { transform: 'fecha_larga', as: 'fecha_regreso_larga' } },
  fecha_salida: { label: 'Fecha de salida del país', question: '¿Qué día sale?', type: 'date', derived: { transform: 'fecha_larga', as: 'fecha_salida_larga' } },
  fecha_pago: { label: 'Fecha del pago', type: 'date', derived: { transform: 'fecha_larga', as: 'fecha_pago_larga' } },
  fecha_recepcion: { label: 'Fecha en que se recibió', question: '¿Qué día le fue notificado?', type: 'date', derived: { transform: 'fecha_larga', as: 'fecha_recepcion_larga' } },
  fecha_requerimiento: { label: 'Fecha del requerimiento', type: 'date', derived: { transform: 'fecha_larga', as: 'fecha_requerimiento_larga' } },
  fecha_vencimiento: { label: 'Fecha de vencimiento', question: '¿Hasta cuándo tiene vigencia?', type: 'date', derived: { transform: 'fecha_larga', as: 'fecha_vencimiento_larga' } },
  menor_fecha_nacimiento: { label: 'Fecha de nacimiento del menor', type: 'date', derived: { transform: 'fecha_larga', as: 'menor_fecha_nacimiento_larga' } },
  monto_pagado: { label: 'Monto pagado', type: 'currency', derived: { transform: 'monto_letras', as: 'monto_pagado_letras', currency: 'DOP' } },
  salario_mensual: { label: 'Salario mensual', type: 'currency', derived: { transform: 'monto_letras', as: 'salario_mensual_letras', currency: 'DOP' } },
  salario_actual: { label: 'Salario actual', type: 'currency', derived: { transform: 'monto_letras', as: 'salario_actual_letras', currency: 'DOP' } },
  salario_propuesto: { label: 'Salario que se propone', type: 'currency', derived: { transform: 'monto_letras', as: 'salario_propuesto_letras', currency: 'DOP' } },
  firmante_nombre: { label: 'Nombre de quien firma', question: '¿Quién firma la carta?', type: 'person' },
  firmante_cedula: { label: 'Cédula de quien firma', type: 'cedula' },
  firmante_nacionalidad: { label: 'Nacionalidad de quien firma', type: 'text', default: 'dominicano(a)' },
  firmante_domicilio: { label: 'Domicilio de quien firma', type: 'address' },
  firmante_telefono: { label: 'Teléfono de contacto', type: 'phone' },
  firmante_correo: { label: 'Correo de contacto', type: 'email' },
  firmante_cargo: { label: 'Cargo de quien firma', question: '¿Qué cargo ocupa quien firma?', type: 'text' },
  firmante_ocupacion: { label: 'Ocupación de quien firma', question: '¿A qué se dedica?', type: 'text' },
  firmante_documento: { label: 'Tipo de documento de identidad', type: 'select', default: 'la cédula de identidad y electoral', options: [
    { value: 'la cédula de identidad y electoral', label: 'Cédula de identidad y electoral' },
    { value: 'el pasaporte', label: 'Pasaporte' },
  ] },

  /* Destinatario */
  destinatario_nombre: { label: 'Nombre del destinatario', question: '¿A quién va dirigida?', type: 'person' },
  destinatario_cargo: { label: 'Cargo del destinatario', question: '¿Qué cargo ocupa?', type: 'text', required: false },
  destinatario_institucion: { label: 'Institución o empresa destinataria', question: '¿A qué institución o empresa?', type: 'text' },

  /* Persona autorizada */
  autorizado_nombre: { label: 'Nombre de la persona autorizada', question: '¿A quién autoriza?', type: 'person' },
  autorizado_cedula: { label: 'Cédula de la persona autorizada', type: 'cedula' },
  autorizado_nacionalidad: { label: 'Nacionalidad de la persona autorizada', type: 'text', default: 'dominicano(a)' },
  autorizado_cargo: { label: 'Cargo de la persona autorizada', type: 'text' },

  /* Empresa que firma */
  empresa_nombre: { label: 'Razón social de la empresa', type: 'company' },
  empresa_rnc: { label: 'RNC de la empresa', type: 'rnc' },
  empresa_domicilio: { label: 'Domicilio social', type: 'address' },
  actividad_empresa: { label: 'Actividad de la empresa', question: '¿A qué se dedica la empresa?', type: 'text' },
  ano_fundacion: { label: 'Año de fundación', type: 'number' },

  /* Laborales */
  empleado_nombre: { label: 'Nombre del trabajador', type: 'person' },
  empleado_cedula: { label: 'Cédula del trabajador', type: 'cedula' },
  cargo_ocupado: { label: 'Cargo que ocupa', question: '¿Qué cargo ocupa o ocupaba?', type: 'text' },
  cargo_solicitado: { label: 'Cargo al que se postula', type: 'text' },
  tipo_contrato: { label: 'Tipo de contrato', type: 'select', default: 'por tiempo indefinido', options: [
    { value: 'por tiempo indefinido', label: 'Por tiempo indefinido' },
    { value: 'por tiempo determinado', label: 'Por tiempo determinado' },
    { value: 'para una obra o servicio determinado', label: 'Por obra o servicio' },
  ] },
  funciones_desempenadas: { label: 'Funciones desempeñadas', type: 'textarea' },
  valoracion_desempeno: { label: 'Valoración del desempeño', question: '¿Cómo describiría su desempeño?', type: 'textarea' },
  motivo_salida: { label: 'Motivo de la salida', type: 'text' },
  plan_cobertura: { label: 'Cómo quedan cubiertas sus funciones', type: 'textarea', required: false },
  motivo_permiso: { label: 'Motivo del permiso', type: 'textarea' },
  documentos_sustento: { label: 'Documentos que sustentan la solicitud', type: 'textarea', required: false },
  responsabilidades_asumidas: { label: 'Responsabilidades asumidas desde el ingreso', type: 'textarea' },
  logros_alcanzados: { label: 'Logros alcanzados', type: 'textarea', required: false },
  hecho_imputado: { label: 'Hecho que se imputa', type: 'textarea' },
  descargo_hechos: { label: 'Explicación de los hechos', type: 'textarea' },
  pruebas_ofrecidas: { label: 'Pruebas que se acompañan', type: 'textarea', required: false },
  norma_incumplida: { label: 'Norma o política incumplida', type: 'text' },
  dias_para_descargo: { label: 'Días para presentar descargo', type: 'number', default: '3' },
  ano_vacaciones: { label: 'Año de las vacaciones', type: 'number' },
  presentacion_candidato: { label: 'Presentación del candidato', question: '¿Cómo se presenta? Formación y experiencia principal.', type: 'textarea' },
  motivo_interes: { label: 'Motivo del interés en el puesto', type: 'textarea' },
  fuente_vacante: { label: 'Dónde vio la vacante', type: 'text' },
  empresa_destino: { label: 'Empresa a la que se postula', type: 'company' },

  /* Trámites */
  documentos_a_retirar: { label: 'Documentos a retirar', question: '¿Qué documentos se van a retirar?', type: 'textarea' },
  descripcion_envio: { label: 'Descripción del envío', type: 'textarea' },
  numero_guia: { label: 'Número de guía o referencia', type: 'text', required: false },
  gestion_encomendada: { label: 'Gestión encomendada', question: '¿Qué gestión exactamente puede hacer?', type: 'textarea' },
  certificacion_solicitada: { label: 'Certificación que se solicita', type: 'textarea' },
  finalidad_certificacion: { label: 'Para qué se necesita', type: 'text' },
  numero_referencia: { label: 'Número de referencia o expediente', type: 'text', required: false },
  dato_incorrecto: { label: 'Dato como aparece hoy', type: 'text' },
  dato_correcto: { label: 'Dato correcto', type: 'text' },
  personas_dependientes: { label: 'Personas que dependen económicamente', question: 'Nombre, cédula o acta, edad y parentesco de cada una.', type: 'textarea' },
  ingreso_mensual: { label: 'Ingreso mensual', type: 'currency', derived: { transform: 'monto_letras', as: 'ingreso_mensual_letras', currency: 'DOP' } },
  fuente_ingresos: { label: 'De dónde provienen los ingresos', type: 'text' },
  calidad_solicitante: { label: 'Calidad en que solicita', question: '¿En qué calidad escribe? Ej.: propietario, ciudadano, representante.', type: 'text' },
  objeto_solicitud: { label: 'Qué se solicita', type: 'textarea' },
  fundamento_solicitud: { label: 'Por qué se solicita', type: 'textarea' },
  documentos_anexos: { label: 'Documentos anexos', type: 'textarea', required: false },
  respuesta_requerimiento: { label: 'Respuesta a lo requerido', type: 'textarea' },
  reserva_derechos: { label: 'Reserva de derechos', type: 'textarea', required: false },

  /* Consumo */
  proveedor_nombre: { label: 'Nombre del proveedor o comercio', type: 'company' },
  proveedor_rnc: { label: 'RNC del proveedor', type: 'rnc', required: false },
  proveedor_domicilio: { label: 'Dirección del proveedor', type: 'address' },
  descripcion_producto: { label: 'Producto o servicio', type: 'textarea' },
  comprobante_compra: { label: 'Comprobante de compra', question: '¿Con qué documento acredita la compra? Ej.: factura con NCF B0100000123.', type: 'text' },
  descripcion_problema: { label: 'Problema que presenta', type: 'textarea' },
  gestiones_previas: { label: 'Gestiones ya realizadas', question: '¿Qué ha hecho ya para resolverlo?', type: 'textarea' },
  pretension: { label: 'Qué solicita', question: '¿Qué pide: devolución, cambio, reparación?', type: 'textarea' },
  dias_respuesta: { label: 'Días para responder', type: 'number', default: '15' },

  /* Migración y viajes */
  invitado_nombre: { label: 'Nombre de la persona invitada', type: 'person' },
  invitado_nacionalidad: { label: 'Nacionalidad de la persona invitada', type: 'text' },
  invitado_pasaporte: { label: 'Pasaporte de la persona invitada', type: 'text' },
  motivo_visita: { label: 'Motivo de la visita', type: 'text' },
  vinculo_invitado: { label: 'Vínculo con la persona invitada', type: 'text' },
  lugar_alojamiento: { label: 'Lugar de alojamiento', type: 'address' },
  compromiso_gastos: { label: 'Compromiso sobre los gastos', question: '¿Quién cubre los gastos y cuáles?', type: 'textarea' },
  beneficiario_nombre: { label: 'Nombre de la persona beneficiaria', type: 'person' },
  beneficiario_documento: { label: 'Tipo de documento de la persona beneficiaria', type: 'text', default: 'el pasaporte' },
  beneficiario_documento_numero: { label: 'Número del documento', type: 'text' },
  vinculo_beneficiario: { label: 'Vínculo con la persona beneficiaria', type: 'text' },
  gastos_cubiertos: { label: 'Gastos que se cubren', type: 'textarea' },
  pais_destino: { label: 'País de destino', type: 'text' },
  motivo_viaje: { label: 'Motivo del viaje', type: 'text' },

  /* Familia */
  padre_nombre: { label: 'Nombre del padre', type: 'person' },
  padre_cedula: { label: 'Cédula del padre', type: 'cedula' },
  padre_telefono: { label: 'Teléfono del padre', type: 'phone' },
  madre_nombre: { label: 'Nombre de la madre', type: 'person' },
  madre_cedula: { label: 'Cédula de la madre', type: 'cedula' },
  madre_telefono: { label: 'Teléfono de la madre', type: 'phone' },
  menor_nombre: { label: 'Nombre del menor', type: 'person' },
  menor_acta_nacimiento: { label: 'Acta de nacimiento del menor', type: 'text' },
  menor_pasaporte: { label: 'Pasaporte del menor', type: 'text', required: false },
  modalidad_viaje: { label: 'Cómo viaja el menor', type: 'select', default: 'en compañía de la persona responsable que más abajo se indica', options: [
    { value: 'en compañía de la persona responsable que más abajo se indica', label: 'Acompañado por un tercero' },
    { value: 'no acompañado, bajo el servicio de menor no acompañado de la aerolínea', label: 'Solo (menor no acompañado)' },
  ] },
  acompanante_nombre: { label: 'Nombre del acompañante', type: 'person', required: false },
  acompanante_documento: { label: 'Tipo de documento del acompañante', type: 'text', default: 'la cédula de identidad y electoral', required: false },
  acompanante_documento_numero: { label: 'Número del documento del acompañante', type: 'text', required: false },
  vinculo_acompanante: { label: 'Vínculo con el acompañante', type: 'text', required: false },
  calidad_progenitor: { label: 'Calidad en que firma', type: 'select', default: 'padre', options: [
    { value: 'padre', label: 'Padre' }, { value: 'madre', label: 'Madre' }, { value: 'tutor legal', label: 'Tutor legal' },
  ] },
  tramite_autorizado: { label: 'Trámite que se autoriza', type: 'textarea' },

  /* Empresas y comercio */
  referido_nombre: { label: 'Nombre de quien se refiere', type: 'company' },
  referido_identificacion: { label: 'RNC o cédula de quien se refiere', type: 'text' },
  naturaleza_relacion: { label: 'Naturaleza de la relación', question: '¿Es cliente, suplidor, distribuidor?', type: 'text' },
  volumen_operaciones: { label: 'Volumen aproximado de operaciones', type: 'text' },
  condiciones_pago: { label: 'Condiciones de pago pactadas', type: 'text' },
  comportamiento_pago: { label: 'Comportamiento de pago observado', type: 'textarea' },
  observaciones_adicionales: { label: 'Observaciones adicionales', type: 'textarea', required: false },
  presentacion_empresa: { label: 'Presentación de la empresa', type: 'textarea' },
  servicios_ofrecidos: { label: 'Servicios que se ofrecen', type: 'textarea' },
  diferenciales: { label: 'Qué la diferencia', type: 'textarea', required: false },
  objeto_oferta: { label: 'Objeto de la oferta', type: 'text' },
  detalle_oferta: { label: 'Detalle de la oferta', question: 'Partidas, cantidades y precios unitarios.', type: 'textarea' },
  precio_oferta: { label: 'Precio ofertado', type: 'currency', derived: { transform: 'monto_letras', as: 'precio_oferta_letras', currency: 'DOP' } },
  itbis_incluido: { label: 'ITBIS', type: 'select', default: 'ITBIS incluido', options: [
    { value: 'ITBIS incluido', label: 'ITBIS incluido' },
    { value: 'más el ITBIS correspondiente', label: 'ITBIS aparte' },
    { value: 'exento de ITBIS', label: 'Exento' },
  ] },
  forma_pago_oferta: { label: 'Forma de pago', type: 'text' },
  plazo_entrega: { label: 'Plazo de entrega o ejecución', type: 'text' },
  garantia_ofrecida: { label: 'Garantía ofrecida', type: 'text' },
  dias_validez: { label: 'Días de validez de la oferta', type: 'number', default: '15' },
  condiciones_adicionales: { label: 'Condiciones adicionales', type: 'textarea', required: false },

  /* Legales */
  origen_deuda: { label: 'Origen de la deuda', question: '¿De dónde viene la deuda? Contrato, factura, préstamo.', type: 'textarea' },
  monto_adeudado: { label: 'Monto adeudado', type: 'currency', derived: { transform: 'monto_letras', as: 'monto_adeudado_letras', currency: 'DOP' } },
  detalle_intereses: { label: 'Intereses o recargos', type: 'textarea', required: false },
  dias_plazo_pago: { label: 'Días de plazo para pagar', type: 'number', default: '15' },
  forma_pago_requerida: { label: 'Cómo debe pagarse', type: 'text' },
  deudor_nombre: { label: 'Nombre de quien paga', type: 'person' },
  deudor_identificacion: { label: 'Cédula o RNC de quien paga', type: 'text' },
  monto_recibido: { label: 'Monto recibido', type: 'currency', derived: { transform: 'monto_letras', as: 'monto_recibido_letras', currency: 'DOP' } },
  forma_pago_recibida: { label: 'Cómo se recibió el pago', type: 'text' },
  concepto_pago: { label: 'Concepto del pago', question: '¿Por qué concepto se paga? Sea específico: el descargo cubre solo esto.', type: 'textarea' },

  /* Impuestos */
  contribuyente_nombre: { label: 'Nombre o razón social del contribuyente', type: 'text' },
  contribuyente_rnc: { label: 'RNC o cédula del contribuyente', type: 'rnc' },
  contribuyente_domicilio: { label: 'Domicilio fiscal', type: 'address' },
  actividad_economica: { label: 'Actividad económica', type: 'text' },
  periodo_fiscal: { label: 'Período fiscal', question: '¿A qué período se refiere? Ej.: octubre 2026.', type: 'text' },
}
