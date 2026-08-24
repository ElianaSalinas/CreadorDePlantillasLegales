/**
 * Formateo y sustitución de variables.
 *
 * La sustitución acepta {{tag}}, {{ tag }} y {{tag|transformacion}}.
 * Nunca deja una variable sin resolver en silencio: lo que falta se
 * devuelve en `missing` para que la interfaz pueda avisar.
 */

import {
  fechaLarga,
  fechaNotarial,
  formatCedula,
  formatMoney,
  formatPhone,
  formatRNC,
  montoALetras,
  validateCedula,
  validateRNC,
  validatePhone,
  type Currency,
} from './dominican'
import type { Answers, Variable, VariableDataType } from './types'

/* ══════════════ ETIQUETAS ══════════════ */

/** Normaliza el nombre de una variable: minúsculas, sin acentos, con guion bajo. */
export function normalizeTag(input: string): string {
  return input
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '_')
    .replace(/^_+|_+$/g, '')
    .slice(0, 60)
}

/** Extrae todas las etiquetas que aparecen en un texto. */
export function extractTags(text: string): string[] {
  if (!text) return []
  const found = new Set<string>()
  const re = /\{\{\s*([a-zA-Z0-9_]+)\s*(?:\|[^}]*)?\}\}/g
  let m: RegExpExecArray | null
  while ((m = re.exec(text)) !== null) found.add(m[1])
  return [...found]
}

/* ══════════════ FORMATEO POR TIPO ══════════════ */

const CURRENCIES: Currency[] = ['DOP', 'USD', 'EUR']

function currencyOf(variable?: Variable): Currency {
  const c = variable?.derived_config?.currency
  return c && CURRENCIES.includes(c) ? c : 'DOP'
}

/** Convierte el valor crudo del formulario al texto que va al documento. */
export function formatValue(value: unknown, type: VariableDataType, variable?: Variable): string {
  if (value === null || value === undefined || value === '') return ''

  switch (type) {
    case 'currency':
      return formatMoney(value as number, currencyOf(variable))

    case 'percentage': {
      const n = typeof value === 'number' ? value : parseFloat(String(value))
      return Number.isFinite(n) ? `${n}%` : String(value)
    }

    case 'number': {
      const n = typeof value === 'number' ? value : parseFloat(String(value))
      return Number.isFinite(n) ? new Intl.NumberFormat('es-DO').format(n) : String(value)
    }

    case 'date':
      return fechaLarga(String(value))

    case 'cedula':
      return formatCedula(String(value))

    case 'rnc':
      return formatRNC(String(value))

    case 'phone':
      return formatPhone(String(value))

    case 'boolean':
      return value === true || value === 'true' || value === 'on' ? 'Sí' : 'No'

    case 'multiselect': {
      const list = Array.isArray(value) ? value : String(value).split(',')
      const labels = list.map((v) => labelForOption(String(v).trim(), variable))
      if (labels.length <= 1) return labels[0] ?? ''
      return `${labels.slice(0, -1).join(', ')} y ${labels[labels.length - 1]}`
    }

    case 'select':
      return labelForOption(String(value), variable)

    default:
      return String(value)
  }
}

function labelForOption(value: string, variable?: Variable): string {
  const opt = variable?.options?.find((o) => o.value === value)
  return opt?.label ?? value
}

/* ══════════════ TRANSFORMACIONES ══════════════ */

export const TRANSFORMS: Record<string, (raw: unknown, variable?: Variable) => string> = {
  letras: (raw, v) => montoALetras(raw as number, currencyOf(v)),
  monto_letras: (raw, v) => montoALetras(raw as number, currencyOf(v)),
  letras_sin_cifra: (raw, v) => montoALetras(raw as number, currencyOf(v), false),
  fecha_notarial: (raw) => fechaNotarial(String(raw)),
  fecha_larga: (raw) => fechaLarga(String(raw)),
  mayusculas: (raw) => String(raw ?? '').toUpperCase(),
  minusculas: (raw) => String(raw ?? '').toLowerCase(),
  capital: (raw) =>
    String(raw ?? '')
      .toLowerCase()
      .replace(/(^|\s)([a-záéíóúñ])/g, (_, sp, ch) => sp + ch.toUpperCase()),
}

/**
 * Construye el diccionario final que se sustituye en el texto: cada
 * variable formateada, más las derivadas que declare `derived_config`.
 */
export function buildSubstitutions(variables: Variable[], answers: Answers): Record<string, string> {
  const out: Record<string, string> = {}

  for (const v of variables) {
    const raw = answers[v.tag]
    out[v.tag] = formatValue(raw, v.data_type, v)

    const derived = v.derived_config
    if (derived?.transform) {
      const fn = TRANSFORMS[derived.transform]
      if (fn) {
        const alias = derived.as || `${v.tag}_${derived.transform}`
        out[alias] = raw === undefined || raw === null || raw === '' ? '' : fn(raw, v)
      }
    }
  }

  return out
}

/* ══════════════ SUSTITUCIÓN ══════════════ */

export type SubstitutionResult = {
  text: string
  /** Etiquetas que aparecían en el texto y no tenían valor. */
  missing: string[]
}

/**
 * Sustituye {{etiqueta}} y {{etiqueta|transformacion}} en el texto.
 *
 * Lo que no tenga valor se sustituye por un hueco visible en vez de dejar
 * la llave cruda: un contrato que sale con {{precio_renta}} impreso es peor
 * que uno que dice claramente que falta el dato.
 */
export function substitute(
  text: string,
  substitutions: Record<string, string>,
  options: { placeholder?: (tag: string) => string; variables?: Variable[] } = {}
): SubstitutionResult {
  if (!text) return { text: '', missing: [] }

  const missing = new Set<string>()
  const byTag = new Map((options.variables ?? []).map((v) => [v.tag, v]))
  const placeholder = options.placeholder ?? ((tag: string) => `[falta: ${tag}]`)

  const result = text.replace(
    /\{\{\s*([a-zA-Z0-9_]+)\s*(?:\|\s*([a-zA-Z0-9_]+)\s*)?\}\}/g,
    (_match, tag: string, transform?: string) => {
      let value = substitutions[tag]

      if (transform) {
        const fn = TRANSFORMS[transform]
        if (fn) {
          const variable = byTag.get(tag)
          // La transformación necesita el valor crudo, no el ya formateado.
          const raw = substitutions[`${tag}__raw`] ?? value
          value = raw === '' || raw === undefined ? '' : fn(raw, variable)
        }
      }

      if (value === undefined || value === '') {
        missing.add(tag)
        return placeholder(tag)
      }

      return value
    }
  )

  return { text: result, missing: [...missing] }
}

/* ══════════════ VALIDACIÓN DEL FORMULARIO ══════════════ */

export type FieldError = { tag: string; label: string; message: string }

/**
 * Comprueba las respuestas contra el tipo y las reglas de cada variable.
 * `required` permite que una regla haga obligatorio un campo que en el
 * catálogo es opcional, y al revés.
 */
export function validateAnswers(
  variables: Variable[],
  answers: Answers,
  overrides: { required?: Set<string>; optional?: Set<string>; hidden?: Set<string> } = {}
): FieldError[] {
  const errors: FieldError[] = []

  for (const v of variables) {
    if (overrides.hidden?.has(v.tag)) continue

    const raw = answers[v.tag]
    const empty = raw === undefined || raw === null || raw === '' || (Array.isArray(raw) && raw.length === 0)

    const required = overrides.required?.has(v.tag)
      ? true
      : overrides.optional?.has(v.tag)
        ? false
        : v.is_required

    if (empty) {
      if (required) {
        errors.push({ tag: v.tag, label: v.label, message: 'Este dato es obligatorio.' })
      }
      continue
    }

    const value = String(raw)

    if (v.data_type === 'cedula') {
      const check = validateCedula(value)
      if (!check.isValid) errors.push({ tag: v.tag, label: v.label, message: check.error ?? 'Cédula inválida.' })
    }

    if (v.data_type === 'rnc') {
      const check = validateRNC(value)
      if (!check.isValid) errors.push({ tag: v.tag, label: v.label, message: check.error ?? 'RNC inválido.' })
    }

    if (v.data_type === 'email' && !/^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(value)) {
      errors.push({ tag: v.tag, label: v.label, message: 'Ese correo no parece válido.' })
    }

    if (v.data_type === 'phone' && !validatePhone(value)) {
      errors.push({ tag: v.tag, label: v.label, message: 'Usa un teléfono dominicano: 809, 829 u 849.' })
    }

    if ((v.data_type === 'number' || v.data_type === 'currency' || v.data_type === 'percentage')) {
      const n = parseFloat(value.replace(/[^\d.-]/g, ''))
      if (!Number.isFinite(n)) {
        errors.push({ tag: v.tag, label: v.label, message: 'Escribe un número.' })
      } else if (v.data_type === 'percentage' && (n < 0 || n > 100)) {
        errors.push({ tag: v.tag, label: v.label, message: 'El porcentaje va entre 0 y 100.' })
      }
    }

    if (v.data_type === 'date' && Number.isNaN(new Date(`${value}T12:00:00`).getTime())) {
      errors.push({ tag: v.tag, label: v.label, message: 'Esa fecha no es válida.' })
    }

    if (v.validation_regex) {
      try {
        if (!new RegExp(v.validation_regex).test(value)) {
          errors.push({
            tag: v.tag,
            label: v.label,
            message: v.validation_message || 'El formato no es el esperado.',
          })
        }
      } catch {
        console.warn(`[variables] expresión regular inválida en ${v.tag}`)
      }
    }
  }

  return errors
}

/** La pregunta que se le muestra a la persona, no el nombre técnico. */
export function questionFor(v: Variable): string {
  return v.question?.trim() || v.label
}
