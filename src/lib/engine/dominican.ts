/**
 * Validadores y formateadores de la práctica legal dominicana.
 *
 * Portado desde src/_legacy/core/dominicanValidators.ts. La lógica de los
 * dígitos verificadores y la conversión a letras se conserva íntegra; se
 * corrigieron dos errores de gramática que producían texto incorrecto en
 * documentos notariales (ver NOTA en cada sitio).
 *
 * Sin dependencias del navegador: corre igual en servidor y en cliente.
 */

/* ══════════════ CÉDULA ══════════════ */

export type CedulaCheck = {
  isValid: boolean
  clean: string
  formatted: string
  error?: string
}

/**
 * Cédula de la JCE: 11 dígitos con verificador Luhn módulo 10.
 * Formato oficial 000-0000000-0.
 */
export function validateCedula(input: string): CedulaCheck {
  if (!input) {
    return { isValid: false, clean: '', formatted: '', error: 'La cédula es obligatoria.' }
  }

  const clean = input.replace(/\D/g, '')

  if (clean.length !== 11) {
    return {
      isValid: false,
      clean,
      formatted: input,
      error: `Debe tener 11 dígitos. Escribiste ${clean.length}.`,
    }
  }

  if (/^0+$/.test(clean)) {
    return { isValid: false, clean, formatted: input, error: 'Esa cédula no es válida.' }
  }

  const digits = clean.split('').map(Number)
  const checkDigit = digits[10]
  const weights = [1, 2, 1, 2, 1, 2, 1, 2, 1, 2]

  let sum = 0
  for (let i = 0; i < 10; i++) {
    let product = digits[i] * weights[i]
    if (product >= 10) product = Math.floor(product / 10) + (product % 10)
    sum += product
  }

  const expected = (10 - (sum % 10)) % 10
  const isValid = expected === checkDigit

  return {
    isValid,
    clean,
    formatted: formatCedula(clean),
    error: isValid ? undefined : 'El dígito verificador no cuadra. Revisa el número.',
  }
}

export function formatCedula(value: string): string {
  const clean = value.replace(/\D/g, '').slice(0, 11)
  if (clean.length <= 3) return clean
  if (clean.length <= 10) return `${clean.slice(0, 3)}-${clean.slice(3)}`
  return `${clean.slice(0, 3)}-${clean.slice(3, 10)}-${clean.slice(10, 11)}`
}

/* ══════════════ RNC ══════════════ */

export type RncCheck = {
  isValid: boolean
  clean: string
  kind: 'PERSONA_JURIDICA' | 'PERSONA_FISICA' | 'INVALID'
  error?: string
}

/**
 * RNC de la DGII: 9 dígitos para empresas (verificador módulo 11) u 11
 * dígitos cuando el contribuyente es una persona física, en cuyo caso el
 * RNC es su propia cédula.
 */
export function validateRNC(input: string): RncCheck {
  if (!input) {
    return { isValid: false, clean: '', kind: 'INVALID', error: 'El RNC es obligatorio.' }
  }

  const clean = input.replace(/\D/g, '')

  if (clean.length === 11) {
    const cedula = validateCedula(clean)
    return {
      isValid: cedula.isValid,
      clean,
      kind: 'PERSONA_FISICA',
      error: cedula.error,
    }
  }

  if (clean.length === 9) {
    const digits = clean.split('').map(Number)
    const checkDigit = digits[8]
    const weights = [7, 9, 8, 6, 5, 4, 3, 2]

    let sum = 0
    for (let i = 0; i < 8; i++) sum += digits[i] * weights[i]

    const remainder = sum % 11
    const expected = remainder === 0 ? 2 : remainder === 1 ? 1 : 11 - remainder
    const isValid = expected === checkDigit

    return {
      isValid,
      clean,
      kind: 'PERSONA_JURIDICA',
      error: isValid ? undefined : 'El dígito verificador del RNC no cuadra.',
    }
  }

  return {
    isValid: false,
    clean,
    kind: 'INVALID',
    error: 'El RNC lleva 9 dígitos si es empresa, u 11 si es persona física.',
  }
}

export function formatRNC(value: string): string {
  const clean = value.replace(/\D/g, '')
  if (clean.length === 11) return formatCedula(clean)
  if (clean.length !== 9) return clean
  return `${clean.slice(0, 1)}-${clean.slice(1, 3)}-${clean.slice(3, 8)}-${clean.slice(8)}`
}

/* ══════════════ NÚMEROS A LETRAS ══════════════ */

const UNIDADES = ['', 'UN', 'DOS', 'TRES', 'CUATRO', 'CINCO', 'SEIS', 'SIETE', 'OCHO', 'NUEVE']

const ESPECIALES = [
  'DIEZ', 'ONCE', 'DOCE', 'TRECE', 'CATORCE', 'QUINCE',
  'DIECISÉIS', 'DIECISIETE', 'DIECIOCHO', 'DIECINUEVE',
  'VEINTE', 'VEINTIUNO', 'VEINTIDÓS', 'VEINTITRÉS', 'VEINTICUATRO',
  'VEINTICINCO', 'VEINTISÉIS', 'VEINTISIETE', 'VEINTIOCHO', 'VEINTINUEVE',
]

const DECENAS = ['', 'DIEZ', 'VEINTE', 'TREINTA', 'CUARENTA', 'CINCUENTA', 'SESENTA', 'SETENTA', 'OCHENTA', 'NOVENTA']

const CENTENAS = [
  '', 'CIENTO', 'DOSCIENTOS', 'TRESCIENTOS', 'CUATROCIENTOS',
  'QUINIENTOS', 'SEISCIENTOS', 'SETECIENTOS', 'OCHOCIENTOS', 'NOVECIENTOS',
]

function tresCifras(num: number): string {
  if (num === 0) return ''
  if (num === 100) return 'CIEN'

  let out = ''
  const c = Math.floor(num / 100)
  const d = Math.floor((num % 100) / 10)
  const u = num % 10
  const du = num % 100

  if (c > 0) out += CENTENAS[c] + ' '

  if (du >= 10 && du <= 29) {
    out += ESPECIALES[du - 10]
  } else {
    if (d > 0) {
      out += DECENAS[d]
      if (u > 0) out += ' Y '
    }
    if (u > 0) out += UNIDADES[u]
  }

  return out.trim()
}

/**
 * NOTA (corrección respecto al legado): delante de un sustantivo masculino
 * las formas apocopadas son "VEINTIÚN" y "UN", no "VEINTIUNO" ni "UNO".
 * El legado escribía "VEINTIUNO MIL PESOS", que es incorrecto.
 */
function apocopar(texto: string): string {
  return texto.replace(/VEINTIUNO$/, 'VEINTIÚN').replace(/(^|\s)UNO$/, '$1UN')
}

/** Convierte un entero a palabras en español. */
export function enteroALetras(n: number): string {
  if (!Number.isFinite(n)) return ''
  if (n === 0) return 'CERO'
  if (n < 0) return 'MENOS ' + enteroALetras(Math.abs(n))

  const millones = Math.floor(n / 1_000_000)
  const miles = Math.floor((n % 1_000_000) / 1000)
  const resto = n % 1000

  let texto = ''

  if (millones > 0) {
    texto += millones === 1 ? 'UN MILLÓN ' : `${enteroALetras(millones)} MILLONES `
  }

  if (miles > 0) {
    // "UN MIL" es la forma que usa la práctica notarial dominicana en
    // documentos de valor; se conserva a propósito.
    texto += miles === 1 ? 'UN MIL ' : `${apocopar(tresCifras(miles))} MIL `
  }

  if (resto > 0) texto += tresCifras(resto)

  return texto.trim()
}

export type Currency = 'DOP' | 'USD' | 'EUR'

const CURRENCY_SYMBOL: Record<Currency, string> = { DOP: 'RD$', USD: 'US$', EUR: '€' }

function currencyName(currency: Currency, entero: number): string {
  if (currency === 'USD') return entero === 1 ? 'DÓLAR ESTADOUNIDENSE' : 'DÓLARES ESTADOUNIDENSES'
  if (currency === 'EUR') return entero === 1 ? 'EURO' : 'EUROS'
  return entero === 1 ? 'PESO DOMINICANO' : 'PESOS DOMINICANOS'
}

/**
 * Monto en la forma que exige un documento legal:
 * "TREINTA MIL PESOS DOMINICANOS CON 00/100 (RD$30,000.00)"
 */
export function montoALetras(
  amount: number | string,
  currency: Currency = 'DOP',
  includeFigures = true
): string {
  const num = typeof amount === 'string' ? parseFloat(amount.replace(/[^\d.-]/g, '')) : amount
  if (!Number.isFinite(num)) return ''

  const entero = Math.floor(Math.abs(num))
  const centavos = Math.round((Math.abs(num) - entero) * 100)
  const centavosStr = centavos.toString().padStart(2, '0') + '/100'

  const texto = `${apocopar(enteroALetras(entero))} ${currencyName(currency, entero)} CON ${centavosStr}`

  if (!includeFigures) return texto
  return `${texto} (${formatMoney(num, currency)})`
}

export function formatMoney(amount: number | string, currency: Currency = 'DOP'): string {
  const num = typeof amount === 'string' ? parseFloat(amount.replace(/[^\d.-]/g, '')) : amount
  if (!Number.isFinite(num)) return ''

  const formatted = new Intl.NumberFormat('es-DO', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(num)

  return `${CURRENCY_SYMBOL[currency]}${formatted}`
}

/* ══════════════ FECHAS NOTARIALES ══════════════ */

const MESES = [
  'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
  'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
]

/**
 * Fecha en la forma solemne de un acto notarial dominicano:
 * "a los quince (15) días del mes de agosto del año dos mil veintiséis (2026)"
 *
 * NOTA (corrección respecto al legado): para el día 1 la concordancia es
 * singular. El legado producía "a los primer (1er) días", que está mal.
 */
export function fechaNotarial(input: string | Date): string {
  if (!input) return ''

  const date = input instanceof Date ? input : new Date(`${input}T12:00:00`)
  if (Number.isNaN(date.getTime())) return String(input)

  const dia = date.getDate()
  const mes = MESES[date.getMonth()]
  const anio = date.getFullYear()

  const anioTexto = `${enteroALetras(anio).toLowerCase()} (${anio})`

  if (dia === 1) {
    return `al primer (1er) día del mes de ${mes} del año ${anioTexto}`
  }

  return `a los ${enteroALetras(dia).toLowerCase()} (${dia}) días del mes de ${mes} del año ${anioTexto}`
}

/** Fecha corriente: "15 de agosto de 2026". */
export function fechaLarga(input: string | Date): string {
  if (!input) return ''
  const date = input instanceof Date ? input : new Date(`${input}T12:00:00`)
  if (Number.isNaN(date.getTime())) return String(input)
  return `${date.getDate()} de ${MESES[date.getMonth()]} de ${date.getFullYear()}`
}

/* ══════════════ TELÉFONO ══════════════ */

export function formatPhone(input: string): string {
  const clean = input.replace(/\D/g, '').slice(-10)
  if (clean.length !== 10) return input
  return `${clean.slice(0, 3)}-${clean.slice(3, 6)}-${clean.slice(6)}`
}

export function validatePhone(input: string): boolean {
  const clean = input.replace(/\D/g, '')
  // Códigos de área de República Dominicana.
  return /^1?(809|829|849)\d{7}$/.test(clean)
}
