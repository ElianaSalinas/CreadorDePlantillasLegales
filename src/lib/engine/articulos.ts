/**
 * Numeración de los artículos de un contrato.
 *
 * Módulo aparte y sin dependencias a propósito: lo importa también el
 * formulario (GeneratorClient, en el navegador) para pintar el selector,
 * y no debe arrastrar el motor entero al JavaScript de esa página.
 *
 * La numeración se calcula al generar, nunca se guarda en el texto de la
 * cláusula: depende de qué cláusulas entraron y del formato que eligió
 * quien redacta.
 */

export type FormatoArticulo =
  | 'MAYUS_ORDINAL'
  | 'TITULO_ORDINAL'
  | 'TITULO_NUMERO'
  | 'MAYUS_NUMERO'
  | 'MAYUS_ROMANO'
  | 'TITULO_ROMANO'

export const FORMATO_ARTICULO_POR_DEFECTO: FormatoArticulo = 'MAYUS_NUMERO'

/** En el orden en que se ofrecen en el formulario. */
export const FORMATOS_ARTICULO: { id: FormatoArticulo; ejemplo: string }[] = [
  { id: 'MAYUS_ORDINAL', ejemplo: 'ARTÍCULO PRIMERO:' },
  { id: 'TITULO_ORDINAL', ejemplo: 'Artículo Primero:' },
  { id: 'TITULO_NUMERO', ejemplo: 'Artículo 1:' },
  { id: 'MAYUS_NUMERO', ejemplo: 'ARTÍCULO 1:' },
  { id: 'MAYUS_ROMANO', ejemplo: 'ARTÍCULO I:' },
  { id: 'TITULO_ROMANO', ejemplo: 'Artículo I:' },
]

/** Para validar en el servidor lo que manda el navegador. */
export function esFormatoArticulo(valor: unknown): valor is FormatoArticulo {
  return typeof valor === 'string' && FORMATOS_ARTICULO.some((f) => f.id === valor)
}

const UNIDADES = ['', 'Primero', 'Segundo', 'Tercero', 'Cuarto', 'Quinto', 'Sexto', 'Séptimo', 'Octavo', 'Noveno']
const DECENAS = ['', 'Décimo', 'Vigésimo', 'Trigésimo', 'Cuadragésimo', 'Quincuagésimo', 'Sexagésimo', 'Septuagésimo', 'Octogésimo', 'Nonagésimo']

/**
 * 1 → "Primero", 11 → "Décimo Primero", 21 → "Vigésimo Primero".
 * Es la forma habitual en los contratos dominicanos. Por encima de 99
 * (no hay contratos así en el catálogo) se deja la cifra.
 */
export function ordinalEnLetras(n: number): string {
  if (!Number.isInteger(n) || n < 1 || n > 99) return String(n)
  const d = Math.floor(n / 10)
  const u = n % 10
  return [DECENAS[d], UNIDADES[u]].filter(Boolean).join(' ')
}

export function romano(n: number): string {
  if (!Number.isInteger(n) || n < 1 || n > 3999) return String(n)
  const tabla: [number, string][] = [
    [1000, 'M'], [900, 'CM'], [500, 'D'], [400, 'CD'], [100, 'C'], [90, 'XC'],
    [50, 'L'], [40, 'XL'], [10, 'X'], [9, 'IX'], [5, 'V'], [4, 'IV'], [1, 'I'],
  ]
  let resto = n
  let out = ''
  for (const [valor, letra] of tabla) {
    while (resto >= valor) {
      out += letra
      resto -= valor
    }
  }
  return out
}

/** El encabezado de un artículo: "ARTÍCULO PRIMERO:", "Artículo 1:", "ARTÍCULO I:"… */
export function formatoArticulo(n: number, formato: FormatoArticulo = FORMATO_ARTICULO_POR_DEFECTO): string {
  switch (formato) {
    case 'MAYUS_ORDINAL':
      return `ARTÍCULO ${ordinalEnLetras(n).toUpperCase()}:`
    case 'TITULO_ORDINAL':
      return `Artículo ${ordinalEnLetras(n)}:`
    case 'TITULO_NUMERO':
      return `Artículo ${n}:`
    case 'MAYUS_ROMANO':
      return `ARTÍCULO ${romano(n)}:`
    case 'TITULO_ROMANO':
      return `Artículo ${romano(n)}:`
    case 'MAYUS_NUMERO':
    default:
      return `ARTÍCULO ${n}:`
  }
}

const ORDINAL =
  '(?:PRIMER[OA]|SEGUND[OA]|TERCER[OA]|CUART[OA]|QUINT[OA]|SEXT[OA]|S[EÉ]PTIM[OA]|OCTAV[OA]|NOVEN[OA]|' +
  'D[EÉ]CIM[OA](?:\\s+(?:PRIMER[OA]|SEGUND[OA]|TERCER[OA]|CUART[OA]|QUINT[OA]|SEXT[OA]|S[EÉ]PTIM[OA]|OCTAV[OA]|NOVEN[OA]))?|' +
  'UND[EÉ]CIM[OA]|DUOD[EÉ]CIM[OA])'

/**
 * Numeración que ya traiga el texto de una cláusula: "SEGUNDO:",
 * "ARTÍCULO 3.-", "CLÁUSULA QUINTA:", "4.". Se quita AL MOSTRAR, sin
 * tocar la base: las cláusulas son reutilizables, y un número escrito a
 * mano sale fuera de orden en cualquier otra plantilla (el seed del
 * arrendamiento traía "PRIMERO:", "SEGUNDO:" y "TERCERO:", y "SEGUNDO:
 * DURACIÓN" salía cuarta en el alquiler de terreno y primera en el
 * usufructo).
 *
 * "CLÁUSULA PENAL." NO es numeración —PENAL no es número ni ordinal— y
 * se respeta.
 */
const NUMERACION_PREVIA = new RegExp(
  `^\\s*(?:(?:ART[IÍ]CULO|CL[AÁ]USULA)\\s+(?:\\d+|${ORDINAL})|${ORDINAL}|\\d{1,3})\\s*(?:\\.-|[:.)\\-–])\\s+`,
  'i',
)

/** "PRECIO DEL ALQUILER. El inquilino…": rótulo en mayúsculas hasta el primer punto. */
const ROTULO = /^[A-ZÁÉÍÓÚÑÜ0-9][A-ZÁÉÍÓÚÑÜ0-9 ,;/()"\-–]*?\.\s/

/**
 * "ARTÍCULO 1: PRECIO DEL ALQUILER. El inquilino pagará…"
 *
 * Las 101 cláusulas del catálogo empiezan con su rótulo en mayúsculas.
 * Una cláusula propia de un despacho puede no traerlo: entonces se usa su
 * título, que es obligatorio al crearla.
 */
export function numerarClausula(
  n: number,
  titulo: string | null | undefined,
  cuerpo: string,
  formato: FormatoArticulo = FORMATO_ARTICULO_POR_DEFECTO,
): string {
  const encabezado = formatoArticulo(n, formato)
  const sinNumero = cuerpo.replace(NUMERACION_PREVIA, '')
  if (ROTULO.test(sinNumero)) return `${encabezado} ${sinNumero}`
  const rotulo = (titulo ?? '').trim().toUpperCase()
  return rotulo ? `${encabezado} ${rotulo}. ${sinNumero}` : `${encabezado} ${sinNumero}`
}
