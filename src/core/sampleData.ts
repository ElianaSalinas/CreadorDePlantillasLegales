import { LegalTemplate } from '../types';
import { DEFAULT_DOMINICAN_CLAUSES } from './clauseEngine';

export const INITIAL_TEMPLATES: LegalTemplate[] = [
  {
    id: 'tpl_alquiler_residencial_rd',
    name: 'Contrato de Alquiler Residencial (RD)',
    description: 'Contrato estándar de arrendamiento de vivienda bajo la Ley No. 4314 de Inquilinato y el Código Civil Dominicano.',
    category: 'Inmobiliario',
    jurisdiction: 'República Dominicana',
    version: '2.0',
    status: 'PUBLISHED',
    author: 'Lic. Stephania Montero (Notaria Pública)',
    createdAt: '2026-08-10T09:00:00Z',
    updatedAt: '2026-08-15T05:30:00Z',
    content: `CONTRATO DE ARRENDAMIENTO DE VIVIENDA URBANA

ENTRE:

De una parte, {{propietario_nombre}}, de nacionalidad {{propietario_nacionalidad}}, mayor de edad, titular de la Cédula de Identidad y Electoral No. {{propietario_cedula}}, domiciliado y residente en {{propietario_direccion}}, a quien en lo que sigue del presente contrato se denominará EL PROPIETARIO o LA PRIMERA PARTE;

Y de la otra parte, {{inquilino_nombre}}, de nacionalidad {{inquilino_nacionalidad}}, mayor de edad, titular de la Cédula de Identidad y Electoral No. {{inquilino_cedula}}, domiciliado y residente en {{inquilino_direccion}}, a quien en lo sucesivo se denominará EL INQUILINO o LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:

PRIMERO: OBJETO DEL CONTRATO: EL PROPIETARIO concede en calidad de alquiler a EL INQUILINO, quien acepta conforme, el inmueble ubicado en: {{inmueble_direccion}}, el cual será destinado exclusivamente para vivienda familiar del inquilino y sus dependientes directos.

SEGUNDO: PRECIO DEL ALQUILER: El precio mensual del arrendamiento pactado libremente entre las partes es de {{renta_mensual_monto}} ({{renta_mensual_letras}}), pagaderos por mensualidades adelantadas dentro de los primeros {{dias_gracia}} días de cada mes mediante transferencia bancaria o pago directo.

TERCERO: VIGENCIA Y TÉRMINO: El presente contrato tendrá una duración de {{duracion_meses}} meses, iniciando en fecha {{fecha_inicio}} y finalizando en fecha {{fecha_fin}}, renovable por mutuo acuerdo escrito entre las partes con no menos de {{dias_preaviso_terminacion}} días de anticipación.

{{#clause:clausula_deposito_garantia}}
CUARTO: DE LOS DEPÓSITOS DE GARANTÍA: EL INQUILINO entrega en este acto a EL PROPIETARIO la suma de {{deposito_garantia_monto}} ({{deposito_garantia_letras}}), equivalente a {{meses_deposito}} meses de depósito de garantía, el cual será retenido como fianza para responder por daños a la propiedad o incumplimientos de pago de servicios según las disposiciones de la Ley No. 4314 de la República Dominicana. Dicho monto no podrá ser imputado al pago de mensualidades corrientes.
{{/clause:clausula_deposito_garantia}}

{{#clause:clausula_mantenimiento_condominio}}
QUINTO: CUOTA DE MANTENIMIENTO: La cuota mensual ordinaria de mantenimiento del condominio asciende a la suma de {{mantenimiento_monto}} ({{mantenimiento_letras}}), la cual correrá por cuenta de EL INQUILINO y deberá ser cancelada puntualmente junto con la renta mensual para el sostenimiento de las áreas comunes conforme a la Ley No. 5038 de Condominios.
{{/clause:clausula_mantenimiento_condominio}}

{{#clause:clausula_mora_penalidades}}
SEXTO: DE LA MORA EN EL PAGO: Las partes convienen expresamente que la falta de pago de la mensualidad convenida dentro de los primeros {{dias_gracia}} días de cada mes generará un recargo moratorio mensual del {{porcentaje_mora}}% calculado sobre el monto adeudado, sin necesidad de requerimiento o intimación judicial previa.
{{/clause:clausula_mora_penalidades}}

{{#clause:clausula_competencia_tribunales}}
SÉPTIMO: DE LA JURISDICCIÓN COMPETENTE: Para la ejecución del presente contrato y de todas sus consecuencias legales, las partes eligen domicilio en las direcciones indicadas al encabezado y convienen expresamente someter cualquier diferendo o litis a la jurisdicción y competencia territorial de los Tribunales Ordinarios de la República Dominicana correspondientes al {{distrito_judicial}}, con renuncia expresa a cualquier otro fuero que pudiera corresponderles.
{{/clause:clausula_competencia_tribunales}}

HECHO Y FIRMADO en dos (2) originales de un mismo tenor y efecto, en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}.


________________________________________
{{propietario_nombre}}
EL PROPIETARIO
Cédula: {{propietario_cedula}}


________________________________________
{{inquilino_nombre}}
EL INQUILINO
Cédula: {{inquilino_cedula}}`,
    variables: [
      {
        id: 'v_prop_nom',
        tag: 'propietario_nombre',
        label: 'Nombre Completo del Propietario',
        category: 'CAT_NAME',
        dataType: 'person',
        required: true,
        gender: 'masculino',
        role: 'arrendador',
        defaultValue: 'Marcos Miguel Cabrera Díaz',
        originalValue: 'Marcos Miguel Cabrera Díaz',
      },
      {
        id: 'v_prop_nac',
        tag: 'propietario_nacionalidad',
        label: 'Nacionalidad del Propietario',
        category: 'CAT_NAME',
        dataType: 'string',
        required: true,
        defaultValue: 'dominicana',
      },
      {
        id: 'v_prop_ced',
        tag: 'propietario_cedula',
        label: 'Cédula del Propietario',
        category: 'CAT_CEDULA',
        dataType: 'cedula',
        required: true,
        defaultValue: '001-0894561-2',
        originalValue: '001-0894561-2',
      },
      {
        id: 'v_prop_dir',
        tag: 'propietario_direccion',
        label: 'Dirección del Propietario',
        category: 'CAT_ADDRESS',
        dataType: 'address',
        required: true,
        defaultValue: 'Calle Los Prados No. 45, Ensanche Bella Vista, Santo Domingo, D.N.',
      },
      {
        id: 'v_inq_nom',
        tag: 'inquilino_nombre',
        label: 'Nombre Completo del Inquilino',
        category: 'CAT_NAME',
        dataType: 'person',
        required: true,
        gender: 'masculino',
        role: 'arrendatario',
        defaultValue: 'Juan Carlos Rodríguez Pérez',
        originalValue: 'Juan Carlos Rodríguez Pérez',
      },
      {
        id: 'v_inq_nac',
        tag: 'inquilino_nacionalidad',
        label: 'Nacionalidad del Inquilino',
        category: 'CAT_NAME',
        dataType: 'string',
        required: true,
        defaultValue: 'dominicana',
      },
      {
        id: 'v_inq_ced',
        tag: 'inquilino_cedula',
        label: 'Cédula del Inquilino',
        category: 'CAT_CEDULA',
        dataType: 'cedula',
        required: true,
        defaultValue: '402-2345678-9',
        originalValue: '402-2345678-9',
      },
      {
        id: 'v_inq_dir',
        tag: 'inquilino_direccion',
        label: 'Domicilio Actual del Inquilino',
        category: 'CAT_ADDRESS',
        dataType: 'address',
        required: true,
        defaultValue: 'Av. Winston Churchill No. 102, Piantini, Santo Domingo, D.N.',
      },
      {
        id: 'v_inm_dir',
        tag: 'inmueble_direccion',
        label: 'Dirección del Inmueble Alquilado',
        category: 'CAT_ADDRESS',
        dataType: 'address',
        required: true,
        defaultValue: 'Apto. 4-B, Torre Bella Mare, Calle Sarasota No. 88, Bella Vista, Santo Domingo, D.N.',
        originalValue: 'Apto. 4-B, Torre Bella Mare, Calle Sarasota No. 88, Bella Vista',
      },
      {
        id: 'v_renta_monto',
        tag: 'renta_mensual_monto',
        label: 'Renta Mensual (Monto)',
        category: 'CAT_AMOUNT',
        dataType: 'currency',
        currency: 'DOP',
        required: true,
        defaultValue: 35000,
        originalValue: 'RD$35,000.00',
      },
      {
        id: 'v_renta_letras',
        tag: 'renta_mensual_letras',
        label: 'Renta Mensual en Letras',
        category: 'CAT_AMOUNT',
        dataType: 'string',
        required: true,
        derivedConfig: {
          sourceVariableId: 'renta_mensual_monto',
          transformType: 'amount_in_words',
        },
      },
      {
        id: 'v_dias_gracia',
        tag: 'dias_gracia',
        label: 'Días de Gracia para Pago',
        category: 'CAT_TERM',
        dataType: 'integer',
        required: true,
        defaultValue: 5,
      },
      {
        id: 'v_duracion',
        tag: 'duracion_meses',
        label: 'Duración del Contrato (Meses)',
        category: 'CAT_TERM',
        dataType: 'integer',
        required: true,
        defaultValue: 12,
      },
      {
        id: 'v_fecha_ini',
        tag: 'fecha_inicio',
        label: 'Fecha de Inicio',
        category: 'CAT_DATE',
        dataType: 'date',
        required: true,
        defaultValue: '2026-09-01',
      },
      {
        id: 'v_fecha_fin',
        tag: 'fecha_fin',
        label: 'Fecha de Finalización',
        category: 'CAT_DATE',
        dataType: 'date',
        required: true,
        defaultValue: '2027-08-31',
      },
      {
        id: 'v_preaviso',
        tag: 'dias_preaviso_terminacion',
        label: 'Días de Preaviso para No Renovación',
        category: 'CAT_TERM',
        dataType: 'integer',
        required: true,
        defaultValue: 60,
      },
      {
        id: 'v_meses_dep',
        tag: 'meses_deposito',
        label: 'Cantidad de Meses de Depósito',
        category: 'CAT_TERM',
        dataType: 'integer',
        required: true,
        defaultValue: 2,
      },
      {
        id: 'v_dep_monto',
        tag: 'deposito_garantia_monto',
        label: 'Monto Total de Depósito de Garantía',
        category: 'CAT_AMOUNT',
        dataType: 'currency',
        currency: 'DOP',
        required: true,
        derivedConfig: {
          sourceVariableId: 'renta_mensual_monto',
          transformType: 'multiply',
          params: { factor: 2 },
        },
      },
      {
        id: 'v_dep_letras',
        tag: 'deposito_garantia_letras',
        label: 'Monto de Depósito en Letras',
        category: 'CAT_AMOUNT',
        dataType: 'string',
        required: true,
        derivedConfig: {
          sourceVariableId: 'deposito_garantia_monto',
          transformType: 'amount_in_words',
        },
      },
      {
        id: 'v_mora_pct',
        tag: 'porcentaje_mora',
        label: 'Porcentaje de Penalidad por Mora (%)',
        category: 'CAT_AMOUNT',
        dataType: 'percentage',
        required: true,
        defaultValue: 5,
      },
      {
        id: 'v_inc_mant',
        tag: 'incluye_mantenimiento',
        label: '¿El inquilino paga cuota de condominio?',
        category: 'CAT_CUSTOM',
        dataType: 'boolean',
        required: false,
        defaultValue: false,
      },
      {
        id: 'v_mant_monto',
        tag: 'mantenimiento_monto',
        label: 'Monto Cuota de Mantenimiento',
        category: 'CAT_AMOUNT',
        dataType: 'currency',
        currency: 'DOP',
        required: false,
        defaultValue: 4500,
      },
      {
        id: 'v_mant_letras',
        tag: 'mantenimiento_letras',
        label: 'Monto de Mantenimiento en Letras',
        category: 'CAT_AMOUNT',
        dataType: 'string',
        required: false,
        derivedConfig: {
          sourceVariableId: 'mantenimiento_monto',
          transformType: 'amount_in_words',
        },
      },
      {
        id: 'v_distrito',
        tag: 'distrito_judicial',
        label: 'Distrito Judicial Competente',
        category: 'CAT_ROLE',
        dataType: 'legal_role',
        required: true,
        defaultValue: 'Distrito Nacional',
      },
      {
        id: 'v_ciudad_firma',
        tag: 'ciudad_firma',
        label: 'Ciudad de Firma',
        category: 'CAT_ADDRESS',
        dataType: 'string',
        required: true,
        defaultValue: 'Santo Domingo de Guzmán, Distrito Nacional',
      },
      {
        id: 'v_fecha_firma_raw',
        tag: 'fecha_firma',
        label: 'Fecha de Suscripción',
        category: 'CAT_DATE',
        dataType: 'date',
        required: true,
        defaultValue: '2026-08-15',
      },
      {
        id: 'v_fecha_firma_notarial',
        tag: 'fecha_firma_notarial',
        label: 'Fecha de Suscripción Notarial Solemne',
        category: 'CAT_DATE',
        dataType: 'string',
        required: true,
        derivedConfig: {
          sourceVariableId: 'fecha_firma',
          transformType: 'date_in_words',
        },
      },
    ],
    clauses: [
      DEFAULT_DOMINICAN_CLAUSES[0], // Deposito
      DEFAULT_DOMINICAN_CLAUSES[1], // Mora
      DEFAULT_DOMINICAN_CLAUSES[2], // Mantenimiento
      DEFAULT_DOMINICAN_CLAUSES[3], // Jurisdiccion
    ],
    rules: [
      {
        id: 'r_show_mantenimiento',
        name: 'Mostrar cláusula de condominio si aplica cuota',
        targetVariableId: 'incluye_mantenimiento',
        operator: 'equals',
        compareValue: true,
        action: 'SHOW_CLAUSE',
        actionPayload: { clauseId: 'clausula_mantenimiento_condominio' },
        isActive: true,
      },
      {
        id: 'r_require_mantenimiento_monto',
        name: 'Requerir monto de mantenimiento si aplica',
        targetVariableId: 'incluye_mantenimiento',
        operator: 'equals',
        compareValue: true,
        action: 'REQUIRE_VARIABLE',
        actionPayload: { variableId: 'mantenimiento_monto' },
        isActive: true,
      },
    ],
    versions: [
      {
        version: '1.0',
        createdAt: '2026-08-10T09:00:00Z',
        createdBy: 'Stephania Montero',
        description: 'Versión inicial importada de Word Notarial',
        content: '',
        variables: [],
        clauses: [],
        rules: [],
      },
      {
        version: '2.0',
        createdAt: '2026-08-15T05:30:00Z',
        createdBy: 'Stephania Montero',
        description: 'Parametrización completa de variables, cláusulas y reglas RD',
        content: '',
        variables: [],
        clauses: [],
        rules: [],
      },
    ],
  },
  {
    id: 'tpl_venta_inmueble_rd',
    name: 'Contrato de Promesa de Venta Inmobiliaria (RD)',
    description: 'Acuerdo de compraventa de inmueble con designación catastral, certificado de título y pago escalonado.',
    category: 'Inmobiliario',
    jurisdiction: 'República Dominicana',
    version: '1.0',
    status: 'PUBLISHED',
    author: 'Dpto. Legal Inmobiliario',
    createdAt: '2026-08-12T14:00:00Z',
    updatedAt: '2026-08-14T11:00:00Z',
    content: `CONTRATO DE PROMESA DE COMPRAVENTA DE INMUEBLE

ENTRE:

De una parte, {{vendedor_nombre}}, dominicano, mayor de edad, Cédula No. {{vendedor_cedula}}, domiciliado en {{vendedor_direccion}}, en lo sucesivo EL VENDEDOR;

Y de la otra parte, {{comprador_nombre}}, dominicano, mayor de edad, Cédula No. {{comprador_cedula}}, domiciliado en {{comprador_direccion}}, en lo sucesivo EL COMPRADOR.

HAN CONVENIDO:

PRIMERO: EL VENDEDOR promete y se obliga a vender a EL COMPRADOR, quien acepta, el siguiente inmueble: {{inmueble_descripcion}}, amparado por el Certificado de Título Matrícula No. {{matricula_titulo}}, Parcela No. {{parcela_numero}}, Distrito Catastral No. {{distrito_catastral}}, {{ciudad_inmueble}}, República Dominicana.

SEGUNDO: El precio total pactado de la venta es de {{precio_venta_monto}} ({{precio_venta_letras}}), el cual será cancelado según el calendario de pagos acordado.

{{#clause:clausula_competencia_tribunales}}
TERCERO: JURISDICCIÓN: Para todo lo relativo a la ejecución del presente contrato, las partes atribuyen competencia a los Tribunales de la República Dominicana correspondientes al {{distrito_judicial}}.
{{/clause:clausula_competencia_tribunales}}

FIRMADO en {{ciudad_firma}}, República Dominicana, a los {{fecha_firma}}.`,
    variables: [
      {
        id: 'v_vendedor_nom',
        tag: 'vendedor_nombre',
        label: 'Nombre del Vendedor',
        category: 'CAT_NAME',
        dataType: 'person',
        required: true,
        defaultValue: 'Inmobiliaria del Caribe SRL',
      },
      {
        id: 'v_vendedor_ced',
        tag: 'vendedor_cedula',
        label: 'Cédula o RNC del Vendedor',
        category: 'CAT_CEDULA',
        dataType: 'cedula',
        required: true,
        defaultValue: '001-1122334-4',
      },
      {
        id: 'v_vendedor_dir',
        tag: 'vendedor_direccion',
        label: 'Dirección del Vendedor',
        category: 'CAT_ADDRESS',
        dataType: 'address',
        required: true,
        defaultValue: 'Av. Abraham Lincoln No. 500, Piantini, Santo Domingo',
      },
      {
        id: 'v_comprador_nom',
        tag: 'comprador_nombre',
        label: 'Nombre del Comprador',
        category: 'CAT_NAME',
        dataType: 'person',
        required: true,
        defaultValue: 'Alejandro Morales Gómez',
      },
      {
        id: 'v_comprador_ced',
        tag: 'comprador_cedula',
        label: 'Cédula del Comprador',
        category: 'CAT_CEDULA',
        dataType: 'cedula',
        required: true,
        defaultValue: '002-3344556-7',
      },
      {
        id: 'v_comprador_dir',
        tag: 'comprador_direccion',
        label: 'Dirección del Comprador',
        category: 'CAT_ADDRESS',
        dataType: 'address',
        required: true,
        defaultValue: 'Calle El Vergel No. 12, Santo Domingo',
      },
      {
        id: 'v_inm_desc',
        tag: 'inmueble_descripcion',
        label: 'Descripción del Inmueble y Metros Cuadrados',
        category: 'CAT_ADDRESS',
        dataType: 'string',
        required: true,
        defaultValue: 'Apartamento Residencial Tipo A con 145 metros cuadrados de construcción',
      },
      {
        id: 'v_titulo',
        tag: 'matricula_titulo',
        label: 'Matrícula del Certificado de Título',
        category: 'CAT_CUSTOM',
        dataType: 'string',
        required: true,
        defaultValue: '0100234589',
      },
      {
        id: 'v_parcela',
        tag: 'parcela_numero',
        label: 'Número de Parcela',
        category: 'CAT_CUSTOM',
        dataType: 'string',
        required: true,
        defaultValue: '104-Ref-B',
      },
      {
        id: 'v_dc',
        tag: 'distrito_catastral',
        label: 'Distrito Catastral',
        category: 'CAT_CUSTOM',
        dataType: 'string',
        required: true,
        defaultValue: '03',
      },
      {
        id: 'v_ciudad_inm',
        tag: 'ciudad_inmueble',
        label: 'Municipio / Ciudad del Inmueble',
        category: 'CAT_ADDRESS',
        dataType: 'string',
        required: true,
        defaultValue: 'Santo Domingo Este',
      },
      {
        id: 'v_precio_monto',
        tag: 'precio_venta_monto',
        label: 'Precio Total de Venta',
        category: 'CAT_AMOUNT',
        dataType: 'currency',
        currency: 'USD',
        required: true,
        defaultValue: 185000,
      },
      {
        id: 'v_precio_letras',
        tag: 'precio_venta_letras',
        label: 'Precio de Venta en Letras',
        category: 'CAT_AMOUNT',
        dataType: 'string',
        required: true,
        derivedConfig: {
          sourceVariableId: 'precio_venta_monto',
          transformType: 'amount_in_words',
        },
      },
      {
        id: 'v_distrito_j',
        tag: 'distrito_judicial',
        label: 'Distrito Judicial',
        category: 'CAT_ROLE',
        dataType: 'legal_role',
        required: true,
        defaultValue: 'Provincia Santo Domingo',
      },
      {
        id: 'v_ciudad_f',
        tag: 'ciudad_firma',
        label: 'Ciudad de Firma',
        category: 'CAT_ADDRESS',
        dataType: 'string',
        required: true,
        defaultValue: 'Santo Domingo',
      },
      {
        id: 'v_ff',
        tag: 'fecha_firma',
        label: 'Fecha de Firma',
        category: 'CAT_DATE',
        dataType: 'date',
        required: true,
        defaultValue: '2026-08-15',
      },
    ],
    clauses: [DEFAULT_DOMINICAN_CLAUSES[3]],
    rules: [],
    versions: [],
  },
  {
    id: 'tpl_poder_especial_rd',
    name: 'Poder Especial Notarial de Representación (RD)',
    description: 'Acto auténtico notarial para representación ante DGII, Registro de Títulos y Bancos bajo la Ley 140-15 del Notariado.',
    category: 'Civil',
    jurisdiction: 'República Dominicana',
    version: '1.0',
    status: 'PUBLISHED',
    author: 'Colegio Dominicano de Notarios',
    createdAt: '2026-08-01T10:00:00Z',
    updatedAt: '2026-08-10T12:00:00Z',
    content: `ACTO NÚMERO: {{numero_acto}}.-

EN LA CIUDAD DE {{ciudad_notario}}, República Dominicana, {{fecha_notarial_solemne}}.

ANTE MÍ, {{notario_nombre}}, Notario Público de los del Número para el {{distrito_judicial}}, matriculado en el Colegio Dominicano de Notarios bajo el No. {{matricula_notario}}, con estudio profesional abierto en {{notario_estudio}};

COMPARECIÓ LIBRE Y VOLUNTARIAMENTE:

El señor {{poderdante_nombre}}, dominicano, mayor de edad, Cédula No. {{poderdante_cedula}}, domiciliado en {{poderdante_direccion}}, en calidad de PODERDANTE;

QUIEN ME HA DECLARADO que por medio del presente acto CONFIERE PODER ESPECIAL, tan amplio y suficiente como en derecho fuere necesario, a favor de {{apoderado_nombre}}, dominicano, mayor de edad, Cédula No. {{apoderado_cedula}}, domiciliado en {{apoderado_direccion}}, para que en su nombre y representación realice los siguientes actos:

PRIMERO: Gestionar, tramitar y firmar ante la Dirección General de Impuestos Internos (DGII), el Registro de Títulos competente y cualquier entidad bancaria, todos los documentos requeridos para: {{facultades_especificas}}.

DE TODO LO CUAL DOY FE Y CONSTANCIA.`,
    variables: [
      {
        id: 'v_num_acto',
        tag: 'numero_acto',
        label: 'Número de Acto Notarial',
        category: 'CAT_CUSTOM',
        dataType: 'string',
        required: true,
        defaultValue: '142-2026',
      },
      {
        id: 'v_ciud_not',
        tag: 'ciudad_notario',
        label: 'Ciudad del Notario',
        category: 'CAT_ADDRESS',
        dataType: 'string',
        required: true,
        defaultValue: 'Santo Domingo de Guzmán, Distrito Nacional',
      },
      {
        id: 'v_fecha_not_solemne',
        tag: 'fecha_notarial_solemne',
        label: 'Fecha Notarial Solemne',
        category: 'CAT_DATE',
        dataType: 'string',
        required: true,
        defaultValue: 'a los quince (15) días del mes de agosto del año dos mil veintiséis (2026)',
      },
      {
        id: 'v_notario_nom',
        tag: 'notario_nombre',
        label: 'Nombre del Notario Público',
        category: 'CAT_NAME',
        dataType: 'person',
        required: true,
        role: 'notario',
        defaultValue: 'Dra. Carmen Rosario Peña',
      },
      {
        id: 'v_not_dist',
        tag: 'distrito_judicial',
        label: 'Distrito Judicial',
        category: 'CAT_ROLE',
        dataType: 'legal_role',
        required: true,
        defaultValue: 'Distrito Nacional',
      },
      {
        id: 'v_mat_not',
        tag: 'matricula_notario',
        label: 'Matrícula del Colegio de Notarios',
        category: 'CAT_CUSTOM',
        dataType: 'string',
        required: true,
        defaultValue: '5420-DN',
      },
      {
        id: 'v_not_est',
        tag: 'notario_estudio',
        label: 'Dirección del Estudio Notarial',
        category: 'CAT_ADDRESS',
        dataType: 'address',
        required: true,
        defaultValue: 'Calle Arzobispo Meriño No. 204, Ciudad Colonial, Santo Domingo',
      },
      {
        id: 'v_pod_nom',
        tag: 'poderdante_nombre',
        label: 'Nombre del Poderdante (Otorgante)',
        category: 'CAT_NAME',
        dataType: 'person',
        required: true,
        defaultValue: 'Fernando Arturo Martínez Soto',
      },
      {
        id: 'v_pod_ced',
        tag: 'poderdante_cedula',
        label: 'Cédula del Poderdante',
        category: 'CAT_CEDULA',
        dataType: 'cedula',
        required: true,
        defaultValue: '001-0987654-3',
      },
      {
        id: 'v_pod_dir',
        tag: 'poderdante_direccion',
        label: 'Dirección del Poderdante',
        category: 'CAT_ADDRESS',
        dataType: 'address',
        required: true,
        defaultValue: 'Calle Las Palmas No. 8, Naco, Santo Domingo',
      },
      {
        id: 'v_apo_nom',
        tag: 'apoderado_nombre',
        label: 'Nombre del Apoderado (Representante)',
        category: 'CAT_NAME',
        dataType: 'person',
        required: true,
        defaultValue: 'Lic. Rafael Emilio Cruz Castillo',
      },
      {
        id: 'v_apo_ced',
        tag: 'apoderado_cedula',
        label: 'Cédula del Apoderado',
        category: 'CAT_CEDULA',
        dataType: 'cedula',
        required: true,
        defaultValue: '001-1239874-5',
      },
      {
        id: 'v_apo_dir',
        tag: 'apoderado_direccion',
        label: 'Dirección del Apoderado',
        category: 'CAT_ADDRESS',
        dataType: 'address',
        required: true,
        defaultValue: 'Av. 27 de Febrero No. 340, Santo Domingo',
      },
      {
        id: 'v_facultades',
        tag: 'facultades_especificas',
        label: 'Facultades Específicas Concedidas',
        category: 'CAT_CUSTOM',
        dataType: 'string',
        required: true,
        defaultValue: 'Solicitar certificaciones de IPI, pagar impuestos de transferencia inmobiliaria, retirar duplicados de títulos de propiedad y suscribir actos de traspaso definitivo.',
      },
    ],
    clauses: [],
    rules: [],
    versions: [],
  },
];

export const INITIAL_GENERATED_DOCUMENTS = [
  {
    id: 'doc_alquiler_bella_vista_2026',
    templateId: 'tpl_alquiler_residencial_rd',
    templateName: 'Contrato de Alquiler Residencial (RD)',
    title: 'Contrato de Alquiler - Apto 402 Bella Vista (Marcos Cabrera / Juan Pérez)',
    createdAt: '2026-08-14T15:30:00Z',
    format: 'DOCX' as const,
    status: 'NOTARIADO' as const,
    author: 'Lic. Stephania Montero (Notaria Pública • CARD 14092)',
    valuesSnapshot: {
      propietario_nombre: 'Marcos Miguel Cabrera Díaz',
      propietario_nacionalidad: 'dominicana',
      propietario_cedula: '001-0894561-2',
      propietario_direccion: 'Calle Los Prados No. 45, Ensanche Bella Vista, Santo Domingo, D.N.',
      inquilino_nombre: 'Ing. Juan Carlos Pérez Almánzar',
      inquilino_nacionalidad: 'dominicana',
      inquilino_cedula: '001-1498321-7',
      inquilino_direccion: 'Av. Sarasota No. 102, Edif. Torre del Parque, Apto 402, Santo Domingo, D.N.',
      inmueble_direccion: 'Calle Las Palmas No. 12, Apto 402, Bella Vista, Distrito Nacional',
      renta_mensual_monto: 'RD$ 45,000.00',
      renta_mensual_letras: 'CUARENTA Y CINCO MIL PESOS DOMINICANOS CON 00/100',
      dias_gracia: 5,
      duracion_meses: 12,
      fecha_inicio: '01 de septiembre de 2026',
      fecha_fin: '31 de agosto de 2027',
      dias_preaviso_terminacion: 60,
      deposito_garantia_monto: 'RD$ 90,000.00',
      deposito_garantia_letras: 'NOVENTA MIL PESOS DOMINICANOS CON 00/100',
      meses_deposito: 2,
      mantenimiento_monto: 'RD$ 4,500.00',
      mantenimiento_letras: 'CUATRO MIL QUINIENTOS PESOS DOMINICANOS CON 00/100',
      porcentaje_mora: 5,
      distrito_judicial: 'Distrito Nacional',
      ciudad_firma: 'Santo Domingo, Distrito Nacional',
      fecha_firma_notarial: 'a los catorce (14) días del mes de agosto del año dos mil veintiséis (2026)',
    },
    renderedContent: `CONTRATO DE ARRENDAMIENTO DE VIVIENDA URBANA

ENTRE:

De una parte, Marcos Miguel Cabrera Díaz, de nacionalidad dominicana, mayor de edad, titular de la Cédula de Identidad y Electoral No. 001-0894561-2, domiciliado y residente en Calle Los Prados No. 45, Ensanche Bella Vista, Santo Domingo, D.N., a quien en lo que sigue del presente contrato se denominará EL PROPIETARIO o LA PRIMERA PARTE;

Y de la otra parte, Ing. Juan Carlos Pérez Almánzar, de nacionalidad dominicana, mayor de edad, titular de la Cédula de Identidad y Electoral No. 001-1498321-7, domiciliado y residente en Av. Sarasota No. 102, Edif. Torre del Parque, Apto 402, Santo Domingo, D.N., a quien en lo sucesivo se denominará EL INQUILINO o LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:

PRIMERO: OBJETO DEL CONTRATO: EL PROPIETARIO concede en calidad de alquiler a EL INQUILINO, quien acepta conforme, el inmueble ubicado en: Calle Las Palmas No. 12, Apto 402, Bella Vista, Distrito Nacional, el cual será destinado exclusivamente para vivienda familiar del inquilino y sus dependientes directos.

SEGUNDO: PRECIO DEL ALQUILER: El precio mensual del arrendamiento pactado libremente entre las partes es de RD$ 45,000.00 (CUARENTA Y CINCO MIL PESOS DOMINICANOS CON 00/100), pagaderos por mensualidades adelantadas dentro de los primeros 5 días de cada mes mediante transferencia bancaria o pago directo.

TERCERO: VIGENCIA Y TÉRMINO: El presente contrato tendrá una duración de 12 meses, iniciando en fecha 01 de septiembre de 2026 y finalizando en fecha 31 de agosto de 2027, renovable por mutuo acuerdo escrito entre las partes con no menos de 60 días de anticipación.

CUARTO: DE LOS DEPÓSITOS DE GARANTÍA: EL INQUILINO entrega en este acto a EL PROPIETARIO la suma de RD$ 90,000.00 (NOVENTA MIL PESOS DOMINICANOS CON 00/100), equivalente a 2 meses de depósito de garantía, el cual será retenido como fianza para responder por daños a la propiedad o incumplimientos de pago de servicios según las disposiciones de la Ley No. 4314 de la República Dominicana. Dicho monto no podrá ser imputado al pago de mensualidades corrientes.

QUINTO: CUOTA DE MANTENIMIENTO: La cuota mensual ordinaria de mantenimiento del condominio asciende a la suma de RD$ 4,500.00 (CUATRO MIL QUINIENTOS PESOS DOMINICANOS CON 00/100), la cual correrá por cuenta de EL INQUILINO y deberá ser cancelada puntualmente junto con la renta mensual para el sostenimiento de las áreas comunes conforme a la Ley No. 5038 de Condominios.

SEXTO: DE LA MORA EN EL PAGO: Las partes convienen expresamente que la falta de pago de la mensualidad convenida dentro de los primeros 5 días de cada mes generará un recargo moratorio mensual del 5% calculado sobre el monto adeudado, sin necesidad de requerimiento o intimación judicial previa.

SÉPTIMO: DE LA JURISDICCIÓN COMPETENTE: Para la ejecución del presente contrato y de todas sus consecuencias legales, las partes eligen domicilio en las direcciones indicadas al encabezado y convienen expresamente someter cualquier diferendo o litis a la jurisdicción y competencia territorial de los Tribunales Ordinarios de la República Dominicana correspondientes al Distrito Nacional, con renuncia expresa a cualquier otro fuero que pudiera corresponderles.

HECHO Y FIRMADO en dos (2) originales de un mismo tenor y efecto, en Santo Domingo, Distrito Nacional, República Dominicana, a los catorce (14) días del mes de agosto del año dos mil veintiséis (2026).


________________________________________
Marcos Miguel Cabrera Díaz
EL PROPIETARIO
Cédula: 001-0894561-2


________________________________________
Ing. Juan Carlos Pérez Almánzar
EL INQUILINO
Cédula: 001-1498321-7


ACTO DE LEGALIZACIÓN DE FIRMAS (LEGALIZACIÓN NOTARIAL)
En la ciudad de Santo Domingo, Distrito Nacional, Capital de la República Dominicana, a los catorce (14) días del mes de agosto del año dos mil veintiséis (2026), por ante mí, LIC. STEPHANIA MONTERO, Notario Público de los del Número del Distrito Nacional, Matrícula del Colegio de Notarios No. 14092, COMPARECIERON libre y voluntariamente los señores MARCOS MIGUEL CABRERA DÍAZ e ING. JUAN CARLOS PÉREZ ALMÁNZAR, de generales constantes precedentemente, a quienes doy fe conocer, y me declararon bajo la fe del juramento que las firmas estampadas en el presente contrato fueron puestas por ellos de sus propios puños y letras, por lo que debe dárseles entera fe y crédito. DOY FE.`,
  },
  {
    id: 'doc_pagare_notarial_2026',
    templateId: 'tpl_pagare_notarial_rd',
    templateName: 'Pagaré Notarial con Garantía Auténtica',
    title: 'Pagaré Notarial - Préstamo Comercial Inversiones Quisqueya SRL (RD$ 2,500,000.00)',
    createdAt: '2026-08-12T10:15:00Z',
    format: 'PDF' as const,
    status: 'EMITIDO' as const,
    author: 'Lic. Stephania Montero (Notaria Pública • CARD 14092)',
    valuesSnapshot: {
      deudor_nombre: 'Inversiones Quisqueya SRL (Rep. por Ing. Roberto Santana)',
      deudor_cedula: '001-0549821-3',
      deudor_direccion: 'Av. Winston Churchill No. 71, Torre Empresarial, Santo Domingo',
      acreedor_nombre: 'Banco Corporativo Dominicano S.A.',
      acreedor_rnc: '1-01-84932-1',
      monto_capital_numero: 'RD$ 2,500,000.00',
      monto_capital_letras: 'DOS MILLONES QUINIENTOS MIL PESOS DOMINICANOS CON 00/100',
      tasa_interes_anual: 14.5,
      plazo_meses: 36,
      cuota_mensual: 'RD$ 86,120.45',
      fecha_primer_pago: '15 de septiembre de 2026',
      garantia_descripcion: 'Hipoteca en primer rango sobre el inmueble matrícula No. 30894812, ubicado en Piantini, D.N.',
      ciudad_notaria: 'Santo Domingo, Distrito Nacional',
    },
    renderedContent: `PAGARÉ NOTARIAL CON FUERZA EJECUTORIA
(Ley No. 140-15 del Notariado Dominicano y Arts. 545 y siguientes del Código de Procedimiento Civil)

ACTO NÚMERO: 184/2026

En la ciudad de Santo Domingo, Distrito Nacional, a los doce (12) días del mes de agosto del año dos mil veintiséis (2026);

POR ANTE MÍ, LIC. STEPHANIA MONTERO, dominicana, mayor de edad, Abogada, Notario Público de los del Número del Distrito Nacional, con estudio profesional abierto en la Av. Abraham Lincoln No. 1002, Torre Ejecutiva, Suite 604, Distrito Nacional, titular de la Cédula de Identidad y Electoral No. 001-1827364-9, colegiada en el Colegio Dominicano de Notarios bajo la Matrícula No. 14092;

COMPARECIÓ LIBRE Y VOLUNTARIAMENTE:

De una parte, la entidad comercial INVERSIONES QUISQUEYA SRL, sociedad organizada y existente de conformidad con las leyes de la República Dominicana, titular del RNC No. 1-31-09876-5, con su domicilio social principal en la Av. Winston Churchill No. 71, Torre Empresarial, debidamente representada por su Gerente General, el ING. ROBERTO SANTANA, dominicano, mayor de edad, titular de la Cédula de Identidad y Electoral No. 001-0549821-3, quien en lo sucesivo se denominará LA PARTE DEUDORA;

Y declara LA PARTE DEUDORA que mediante el presente acto auténtico SE RECONOCE DEUDORA PURA Y SIMPLE, por la vía notarial y con renuncia a toda excepción, a favor de BANCO CORPORATIVO DOMINICANO S.A. (EL ACREEDOR), por la suma líquida, cierta y exigible de RD$ 2,500,000.00 (DOS MILLONES QUINIENTOS MIL PESOS DOMINICANOS CON 00/100), suma que recibió a su entera satisfacción en calidad de préstamo comercial.

CLÁUSULA PRIMERA: OBLIGACIÓN DE PAGO E INTERESES: LA PARTE DEUDORA se obliga a pagar la suma antes indicada en un plazo de treinta y seis (36) meses, devengando un interés anual fijo del catorce punto cinco por ciento (14.5%) sobre saldos insolutos, pagadero en cuotas mensuales y consecutivas de RD$ 86,120.45, pagaderas los días quince (15) de cada mes, iniciando el 15 de septiembre de 2026.

CLÁUSULA SEGUNDA: FUERZA EJECUTORIA NOTARIAL: Por el presente acto, de conformidad con lo establecido en el Artículo 545 del Código de Procedimiento Civil y el Artículo 51 de la Ley 140-15, el presente acto notarial TIENE FUERZA EJECUTORIA PLENA y servirá como título auténtico suficiente para trabar cualquier embargo ejecutivo, inmobiliario o retentivo sin necesidad de previa sentencia judicial.

DOY FE Y CERTIFICO haber leído íntegramente este acto a los comparecientes, quienes lo aprueban y firman conmigo y ante mí, Notario que certifico.`,
  },
  {
    id: 'doc_poder_especial_2026',
    templateId: 'tpl_poder_especial_rd',
    templateName: 'Poder Especial Notarial Inmobiliario',
    title: 'Poder Especial Notarial - Traspaso Título Registro No. 3409 (Carlos Medina a Lic. Rafael Cruz)',
    createdAt: '2026-08-10T11:00:00Z',
    format: 'DOCX' as const,
    status: 'BORRADOR' as const,
    author: 'Lic. Stephania Montero (Notaria Pública • CARD 14092)',
    valuesSnapshot: {
      poderdante_nombre: 'Carlos Manuel Medina Gómez',
      poderdante_cedula: '001-0983214-0',
      poderdante_direccion: 'Calle Restauración No. 88, Santiago de los Caballeros',
      apoderado_nombre: 'Lic. Rafael Emilio Cruz Castillo',
      apoderado_cedula: '001-1239874-5',
      apoderado_direccion: 'Av. 27 de Febrero No. 340, Santo Domingo',
      facultades_especificas: 'Solicitar certificaciones de IPI, pagar impuestos de transferencia inmobiliaria, retirar duplicados de títulos de propiedad y suscribir actos de traspaso definitivo.',
      ciudad_firma: 'Santo Domingo',
      fecha_firma: '10 de agosto de 2026',
    },
    renderedContent: `PODER ESPECIAL DE REPRESENTACIÓN INMOBILIARIA Y TRAMITACIÓN DE TÍTULOS

En la ciudad de Santo Domingo, República Dominicana, a los diez (10) días del mes de agosto del año dos mil veintiséis (2026);

POR CUANTO: El señor CARLOS MANUEL MEDINA GÓMEZ, dominicano, mayor de edad, soltero, portador de la Cédula de Identidad y Electoral No. 001-0983214-0, domiciliado en Calle Restauración No. 88, Santiago de los Caballeros (EL PODERDANTE);

CONFIERE PODER ESPECIAL, TAN AMPLIO, BASTANTE Y SUFICIENTE COMO EN DERECHO SEA MENESTER, a favor del LIC. RAFAEL EMILIO CRUZ CASTILLO, dominicano, mayor de edad, Abogado de los Tribunales de la República Dominicana, portador de la Cédula No. 001-1239874-5, domiciliado en Av. 27 de Febrero No. 340, Santo Domingo (EL APODERADO), para que en su nombre y representación ejecute los siguientes actos:

1. Tramitar ante el Registro de Títulos y la Dirección General de Impuestos Internos (DGII) el traspaso definitivo y liquidación del impuesto de transferencia inmobiliaria relativo al inmueble identificado con la designación catastral No. 3409.
2. Solicitar certificaciones de estado jurídico, certificaciones de IPI y retirar duplicados oficiales del dueño.

HECHO Y FIRMADO en la fecha arriba señalada.

____________________________________
CARLOS MANUEL MEDINA GÓMEZ
Poderdante`,
  },
];

