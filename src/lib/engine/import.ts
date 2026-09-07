/**
 * Convertir un documento que ya existe en una plantilla.
 *
 * La promesa de la portada es "cualquier documento que repitas puede
 * volverse una plantilla". Esto es lo que la hace cierta.
 *
 * EL PRINCIPIO DE DISEÑO, que decide todo lo demás:
 *
 *   La detección PROPONE. La persona decide.
 *
 * Un importador que decide solo produce plantillas que nadie entiende y
 * que nadie se atreve a usar en un acto notarial. Aquí se señalan los
 * candidatos con su motivo, y quien importa confirma uno por uno, les
 * pone nombre y elige si reutiliza una variable del diccionario o crea
 * una nueva. Por eso cada candidato lleva `confianza` y `motivo`: son
 * para que una persona juzgue, no para decidir por ella.
 *
 * Se apoya en el motor dominicano que ya existe —validateCedula,
 * validateRNC— en vez de reconocer formatos a ojo: si un número tiene
 * pinta de cédula pero su dígito verificador no cuadra, probablemente no
 * es una cédula, y proponerlo como variable sería un error caro.
 */

import { validateCedula, validateRNC } from './dominican'

export type TipoCandidato = 'cedula' | 'rnc' | 'monto' | 'fecha' | 'nombre' | 'repetido' | 'manual'

export type Candidato = {
  id: string
  tipo: TipoCandidato
  /** El texto tal como aparece en el documento. */
  valor: string
  ocurrencias: number
  /** Por qué se propone. Se enseña; es lo que permite juzgar. */
  motivo: string
  confianza: 'alta' | 'media' | 'baja'
  /** Nombre de variable propuesto, en el estilo del catálogo. */
  etiquetaSugerida: string
  /** Si encaja con una variable del diccionario, cuál. */
  variableExistente?: string
}

export const ETIQUETA_TIPO: Record<TipoCandidato, string> = {
  cedula: 'Cédula',
  rnc: 'RNC',
  monto: 'Monto',
  fecha: 'Fecha',
  nombre: 'Nombre',
  repetido: 'Texto repetido',
  manual: 'Elegido por ti',
}

/* ══════════════ LEER EL .DOCX ══════════════ */

/**
 * Saca el texto de un .docx.
 *
 * Un .docx es un ZIP con `word/document.xml` dentro. Se usa jszip, que ya
 * está en el proyecto para exportar: leer es el mismo trabajo al revés y
 * no hace falta ninguna dependencia nueva.
 *
 * No se intenta conservar el formato —negritas, tablas, numeración—: lo
 * que importa aquí es el texto y dónde están los datos que cambian. El
 * formato lo pone después el motor de plantillas.
 */
export async function extraerTextoDeDocx(datos: ArrayBuffer): Promise<string> {
  const JSZip = (await import('jszip')).default
  const zip = await JSZip.loadAsync(datos)

  const documento = zip.file('word/document.xml')
  if (!documento) {
    throw new Error('El archivo no parece un documento de Word válido.')
  }

  const xml = await documento.async('string')

  return (
    xml
      // Cada párrafo y cada salto de línea del original se conserva: es
      // lo que hace que el texto siga siendo legible al revisarlo.
      .replace(/<w:p[ >]/g, '\n<w:p ')
      .replace(/<w:br\s*\/?>/g, '\n')
      .replace(/<w:tab\s*\/?>/g, '\t')
      .replace(/<[^>]+>/g, '')
      .replace(/&amp;/g, '&')
      .replace(/&lt;/g, '<')
      .replace(/&gt;/g, '>')
      .replace(/&quot;/g, '"')
      .replace(/&apos;/g, "'")
      .replace(/&#(\d+);/g, (_, n) => String.fromCharCode(Number(n)))
      .replace(/[ \t]+\n/g, '\n')
      .replace(/\n{3,}/g, '\n\n')
      .trim()
  )
}

/* ══════════════ PROPONER VARIABLES ══════════════ */

const RE_CEDULA = /\b\d{3}-?\d{7}-?\d\b/g
const RE_RNC = /\b\d{3}-?\d{5}-?\d\b/g
const RE_MONTO = /(?:RD\$|US\$|\$)\s?\d{1,3}(?:[.,]\d{3})*(?:[.,]\d{2})?/g
const RE_FECHA_CORTA = /\b\d{1,2}[/-]\d{1,2}[/-]\d{4}\b/g
const RE_FECHA_LARGA =
  /\b\d{1,2}\s+de\s+(?:enero|febrero|marzo|abril|mayo|junio|julio|agosto|septiembre|octubre|noviembre|diciembre)\s+(?:de[l]?\s+)?\d{4}\b/gi
/**
 * Dos o más palabras en mayúscula sostenida: así se escriben los
 * comparecientes en los actos dominicanos.
 *
 * El separador es [ ]+ y no \s+ a propósito. Con \s+ la expresión cruzaba
 * saltos de línea y proponía cosas como "LA SEGUNDA PARTE.\n\nSE HA" como
 * si fueran el nombre de una persona.
 *
 * Se admiten palabras de una sola letra dentro del nombre —"MARIA J
 * PEREZ"— pero nunca al principio, para no arrastrar la "Y" de "Y DE LA
 * OTRA PARTE".
 */
const RE_NOMBRE = /\b[A-ZÁÉÍÓÚÑ][A-ZÁÉÍÓÚÑ'.]+(?:[ ]+[A-ZÁÉÍÓÚÑ][A-ZÁÉÍÓÚÑ'.]*){1,5}\b/g

/**
 * Palabras que descartan un candidato a nombre de persona.
 *
 * No están los conectores —DE, LA, LOS, DEL, Y—: en República Dominicana
 * abundan los nombres que los llevan, como JUAN DE LA CRUZ o MARIA DE
 * LOS SANTOS. Descartarlos habría roto justo los nombres más comunes.
 * Lo que descarta es el vocabulario de la estructura del documento, que
 * nunca aparece dentro del nombre de una persona.
 */
const PALABRAS_DE_ESTRUCTURA = new Set([
  'CONTRATO', 'ACTO', 'CLAUSULA', 'CLÁUSULA', 'PARRAFO', 'PÁRRAFO', 'ANEXO',
  'PARTE', 'PARTES', 'PRIMERA', 'SEGUNDA', 'TERCERA', 'OTRA', 'AMBAS',
  'PRIMERO', 'SEGUNDO', 'TERCERO', 'CUARTO', 'QUINTO', 'SEXTO', 'SEPTIMO',
  'SÉPTIMO', 'OCTAVO', 'NOVENO', 'DECIMO', 'DÉCIMO', 'UNICO', 'ÚNICO',
  'CONVENIDO', 'PACTADO', 'SIGUIENTE', 'CUANTO', 'TANTO', 'CONSIDERANDO',
  'ARRENDADOR', 'ARRENDATARIO', 'VENDEDOR', 'COMPRADOR', 'PRESTAMISTA',
  'PRESTATARIO', 'CONTRATISTA', 'CLIENTE', 'PROVEEDOR', 'EMPLEADOR',
  'EMPLEADO', 'DEUDOR', 'ACREEDOR', 'MANDANTE', 'MANDATARIO',
  'ALQUILER', 'VIVIENDA', 'COMPRAVENTA', 'PRESTAMO', 'PRÉSTAMO', 'VENTA',
  'SERVICIOS', 'TRABAJO', 'OBRA', 'INMUEBLE', 'VEHICULO', 'VEHÍCULO',
  'REPUBLICA', 'REPÚBLICA', 'DOMINICANA', 'DIOS', 'PATRIA', 'LIBERTAD',
  'NUMERO', 'NÚMERO', 'CEDULA', 'CÉDULA', 'ELECTORAL', 'IDENTIDAD',
  'DISTRITO', 'JUDICIAL', 'TRIBUNAL', 'TRIBUNALES', 'NOTARIO', 'NOTARIA',
])

/** Palabras en mayúscula que son fórmula jurídica, no nombres de personas. */
const FORMULAS = new Set([
  'ENTRE', 'Y DE LA OTRA PARTE', 'LA PRIMERA PARTE', 'LA SEGUNDA PARTE',
  'EL ARRENDADOR', 'EL ARRENDATARIO', 'EL VENDEDOR', 'EL COMPRADOR',
  'EL PRESTAMISTA', 'EL PRESTATARIO', 'EL CONTRATISTA', 'EL CLIENTE',
  'SE HA CONVENIDO Y PACTADO LO SIGUIENTE', 'POR CUANTO', 'POR TANTO',
  'PRIMERO', 'SEGUNDO', 'TERCERO', 'CUARTO', 'QUINTO', 'SEXTO', 'SEPTIMO',
  'SÉPTIMO', 'OCTAVO', 'NOVENO', 'DECIMO', 'DÉCIMO',
  'REPUBLICA DOMINICANA', 'REPÚBLICA DOMINICANA', 'DIOS PATRIA Y LIBERTAD',
  'ACTO NUMERO', 'ACTO NÚMERO', 'CLAUSULA', 'CLÁUSULA', 'PARRAFO', 'PÁRRAFO',
])

function normaliza(texto: string): string {
  return texto
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '_')
    .replace(/^_+|_+$/g, '')
    .slice(0, 40)
}

export function contarOcurrencias(texto: string, valor: string): number {
  if (!valor) return 0
  let n = 0
  let desde = 0
  for (;;) {
    const i = texto.indexOf(valor, desde)
    if (i === -1) break
    n++
    desde = i + valor.length
  }
  return n
}

/**
 * Qué partes del texto deberían ser variables.
 *
 * @param texto        El documento ya en texto plano.
 * @param diccionario  Etiquetas de las variables que ya existen, para
 *                     proponer reutilizarlas en vez de crear duplicados.
 *                     Sin esto, importar dos contratos parecidos genera
 *                     `nombre_comprador`, `comprador_nombre` y
 *                     `nombre_del_comprador`, y el diccionario deja de
 *                     servir en un mes.
 */
export function detectarCandidatos(texto: string, diccionario: string[] = []): Candidato[] {
  const encontrados = new Map<string, Candidato>()
  const vistos = new Set<string>()

  const añadir = (
    valor: string,
    tipo: TipoCandidato,
    motivo: string,
    confianza: Candidato['confianza'],
    etiqueta: string
  ) => {
    const limpio = valor.trim()
    if (!limpio || vistos.has(limpio)) return
    vistos.add(limpio)

    const ocurrencias = contarOcurrencias(texto, limpio)
    if (ocurrencias === 0) return

    encontrados.set(limpio, {
      id: `${tipo}:${normaliza(limpio)}`,
      tipo,
      valor: limpio,
      ocurrencias,
      motivo,
      confianza,
      etiquetaSugerida: etiqueta,
      variableExistente: diccionario.find((d) => d === etiqueta),
    })
  }

  // ── Cédulas: se validan, no se reconocen por su forma ──
  let n = 0
  for (const m of texto.matchAll(RE_CEDULA)) {
    const chequeo = validateCedula(m[0])
    if (!chequeo.isValid) continue
    n++
    añadir(
      m[0],
      'cedula',
      'Es una cédula válida: el dígito verificador cuadra.',
      'alta',
      n === 1 ? 'parte_primera_cedula' : n === 2 ? 'parte_segunda_cedula' : `cedula_${n}`
    )
  }

  // ── RNC ──
  for (const m of texto.matchAll(RE_RNC)) {
    if (vistos.has(m[0].trim())) continue
    const chequeo = validateRNC(m[0])
    if (!chequeo.isValid) continue
    añadir(m[0], 'rnc', 'Es un RNC válido.', 'alta', 'rnc_empresa')
  }

  // ── Montos ──
  let m1 = 0
  for (const m of texto.matchAll(RE_MONTO)) {
    m1++
    añadir(
      m[0],
      'monto',
      'Lleva símbolo de moneda: casi siempre es un importe que cambia en cada documento.',
      'alta',
      m1 === 1 ? 'monto_principal' : `monto_${m1}`
    )
  }

  // ── Fechas ──
  let f = 0
  for (const re of [RE_FECHA_LARGA, RE_FECHA_CORTA]) {
    for (const m of texto.matchAll(re)) {
      f++
      añadir(
        m[0],
        'fecha',
        'Tiene forma de fecha.',
        'alta',
        f === 1 ? 'fecha_firma' : `fecha_${f}`
      )
    }
  }

  // ── Nombres en mayúscula sostenida ──
  //
  // Quién es la primera y quién la segunda parte NO se decide por orden
  // de aparición. Se decide por el contexto, que en los actos dominicanos
  // es siempre el mismo: "ENTRE: <nombre>," abre la primera parte y
  // "Y DE LA OTRA PARTE: <nombre>," la segunda.
  //
  // Con el orden a secas, el título del documento se llevaba el primer
  // puesto y los comparecientes acababan corridos: la primera parte
  // etiquetada como segunda. En un acto notarial eso no es un detalle.
  const trasEntre = texto.match(/\bENTRE\s*:?\s*([A-ZÁÉÍÓÚÑ][A-ZÁÉÍÓÚÑ'. ]{5,80}?)\s*,/)
  const trasOtraParte = texto.match(/OTRA\s+PARTE\s*:?\s*([A-ZÁÉÍÓÚÑ][A-ZÁÉÍÓÚÑ'. ]{5,80}?)\s*,/)
  const primeraPorContexto = trasEntre?.[1]?.trim()
  const segundaPorContexto = trasOtraParte?.[1]?.trim()

  // La primera línea de un contrato suele ser su título, en mayúsculas.
  // No es el nombre de nadie.
  const titulo = texto.split('\n')[0]?.trim() ?? ''

  let p = 0
  for (const m of texto.matchAll(RE_NOMBRE)) {
    const valor = m[0].trim()
    if (FORMULAS.has(valor)) continue
    if (valor === titulo) continue

    // Si contiene vocabulario de la estructura del documento, no es una
    // persona: es una fórmula o un encabezado.
    const palabras = valor.split(/[ ]+/)
    if (palabras.some((w) => PALABRAS_DE_ESTRUCTURA.has(w))) continue

    // Una fórmula jurídica repetida en todo el documento tampoco lo es.
    if (contarOcurrencias(texto, valor) > 6) continue

    let etiqueta: string
    let motivo = 'Está en mayúscula sostenida, que es como se escriben los comparecientes.'
    let confianza: Candidato['confianza'] = 'media'

    if (valor === primeraPorContexto) {
      etiqueta = 'parte_primera_nombre'
      motivo = 'Va justo después de "ENTRE:", donde se nombra a la primera parte.'
      confianza = 'alta'
    } else if (valor === segundaPorContexto) {
      etiqueta = 'parte_segunda_nombre'
      motivo = 'Va justo después de "DE LA OTRA PARTE:", donde se nombra a la segunda.'
      confianza = 'alta'
    } else {
      p++
      etiqueta = `nombre_${p}`
    }

    añadir(valor, 'nombre', motivo, confianza, etiqueta)
  }

  const lista = [...encontrados.values()]

  // ── Lo que se repite tres veces o más ──
  // Va al final y con confianza baja: es la red que recoge lo que los
  // demás patrones no vieron, y también la que más ruido produce.
  const palabras = texto.match(/\b[\wÁÉÍÓÚÑáéíóúñ][\wÁÉÍÓÚÑáéíóúñ.-]{5,}\b/g) ?? []
  const cuenta = new Map<string, number>()
  for (const w of palabras) cuenta.set(w, (cuenta.get(w) ?? 0) + 1)

  for (const [palabra, veces] of cuenta) {
    if (veces < 3) continue
    if (vistos.has(palabra)) continue
    if (/^\d+$/.test(palabra)) continue
    // Palabras corrientes del castellano jurídico: no son datos.
    if (/^(?:contrato|partes|presente|clausula|cláusula|documento|acuerdo|obligaci|cumplimiento|conforme|establecid|siguiente|mediante|persona)/i.test(palabra)) continue
    lista.push({
      id: `repetido:${normaliza(palabra)}`,
      tipo: 'repetido',
      valor: palabra,
      ocurrencias: veces,
      motivo: `Aparece ${veces} veces. Si cambia de un documento a otro, conviene que sea variable.`,
      confianza: 'baja',
      etiquetaSugerida: normaliza(palabra),
      variableExistente: diccionario.find((d) => d === normaliza(palabra)),
    })
  }

  // Primero lo más fiable, y dentro de cada grupo lo que más se repite.
  const orden: Record<Candidato['confianza'], number> = { alta: 0, media: 1, baja: 2 }
  return lista.sort(
    (a, b) => orden[a.confianza] - orden[b.confianza] || b.ocurrencias - a.ocurrencias
  )
}

/* ══════════════ CONVERTIR ══════════════ */

export type Eleccion = { valor: string; etiqueta: string }

/**
 * Sustituye en el texto lo que la persona confirmó, y devuelve la
 * plantilla.
 *
 * Se reemplaza de lo más largo a lo más corto a propósito: si un nombre
 * es "JUAN PEREZ" y otro candidato es "JUAN", empezar por el corto
 * dejaría "{{nombre}} PEREZ" y rompería el otro. Ordenar por longitud
 * evita esa clase entera de estropicio.
 */
export function aplicarElecciones(texto: string, elecciones: Eleccion[]): string {
  let salida = texto

  for (const { valor, etiqueta } of [...elecciones].sort((a, b) => b.valor.length - a.valor.length)) {
    if (!valor || !etiqueta) continue
    salida = salida.split(valor).join(`{{${etiqueta}}}`)
  }

  return salida
}

/** Etiquetas que quedaron en el texto tras convertir. */
export function etiquetasDe(texto: string): string[] {
  return [...new Set([...texto.matchAll(/\{\{\s*([A-Za-z0-9_]+)\s*\}\}/g)].map((m) => m[1]))]
}
