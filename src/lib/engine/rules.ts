/**
 * Motor de condiciones y reglas.
 *
 * Reemplaza a src/_legacy/core/ruleEngine.ts, que solo evaluaba una
 * comparación suelta —sin AND, OR ni NOT— y ofrecía dos operadores que
 * nunca llegaron a existir en el código.
 *
 * Aquí las condiciones son un árbol, así que se puede expresar:
 *   AND( mascotas es verdadero, NOT( tipo_inmueble = "comercial" ) )
 */

import {
  isGroup,
  type Answers,
  type Condition,
  type ConditionLeaf,
  type ConditionOperator,
  type TemplateRule,
} from './types'

/* ══════════════ COMPARACIONES ══════════════ */

function isBlank(v: unknown): boolean {
  if (v === null || v === undefined) return true
  if (typeof v === 'string') return v.trim() === ''
  if (Array.isArray(v)) return v.length === 0
  return false
}

function asNumber(v: unknown): number {
  if (typeof v === 'number') return v
  if (typeof v === 'string') {
    const n = parseFloat(v.replace(/[^\d.-]/g, ''))
    return Number.isFinite(n) ? n : NaN
  }
  if (typeof v === 'boolean') return v ? 1 : 0
  return NaN
}

/** Compara sin distinguir mayúsculas ni acentos: "Sí" y "si" son lo mismo. */
function normalize(v: unknown): string {
  return String(v ?? '')
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .trim()
    .toLowerCase()
}

function looseEquals(a: unknown, b: unknown): boolean {
  if (typeof a === 'boolean' || typeof b === 'boolean') {
    return toBool(a) === toBool(b)
  }
  const na = asNumber(a)
  const nb = asNumber(b)
  if (Number.isFinite(na) && Number.isFinite(nb)) return na === nb
  return normalize(a) === normalize(b)
}

function toBool(v: unknown): boolean {
  if (typeof v === 'boolean') return v
  if (typeof v === 'number') return v !== 0
  const s = normalize(v)
  return s === 'true' || s === 'si' || s === 'sí' || s === '1' || s === 'on'
}

function toList(v: unknown): unknown[] {
  if (Array.isArray(v)) return v
  if (typeof v === 'string') return v.split(',').map((s) => s.trim())
  return v === undefined || v === null ? [] : [v]
}

const COMPARATORS: Record<ConditionOperator, (actual: unknown, expected: unknown) => boolean> = {
  equals: (a, b) => looseEquals(a, b),
  not_equals: (a, b) => !looseEquals(a, b),

  contains: (a, b) => normalize(a).includes(normalize(b)),
  not_contains: (a, b) => !normalize(a).includes(normalize(b)),

  greater_than: (a, b) => asNumber(a) > asNumber(b),
  less_than: (a, b) => asNumber(a) < asNumber(b),
  greater_or_equal: (a, b) => asNumber(a) >= asNumber(b),
  less_or_equal: (a, b) => asNumber(a) <= asNumber(b),

  is_true: (a) => toBool(a),
  is_false: (a) => !toBool(a),

  exists: (a) => a !== undefined && a !== null,
  not_exists: (a) => a === undefined || a === null,

  is_empty: (a) => isBlank(a),
  not_empty: (a) => !isBlank(a),

  in: (a, b) => toList(b).some((item) => looseEquals(a, item)),
  not_in: (a, b) => !toList(b).some((item) => looseEquals(a, item)),
}

export const CONDITION_OPERATORS: { value: ConditionOperator; label: string; needsValue: boolean }[] = [
  { value: 'equals', label: 'es igual a', needsValue: true },
  { value: 'not_equals', label: 'no es igual a', needsValue: true },
  { value: 'contains', label: 'contiene', needsValue: true },
  { value: 'not_contains', label: 'no contiene', needsValue: true },
  { value: 'greater_than', label: 'es mayor que', needsValue: true },
  { value: 'less_than', label: 'es menor que', needsValue: true },
  { value: 'greater_or_equal', label: 'es mayor o igual que', needsValue: true },
  { value: 'less_or_equal', label: 'es menor o igual que', needsValue: true },
  { value: 'in', label: 'está entre', needsValue: true },
  { value: 'not_in', label: 'no está entre', needsValue: true },
  { value: 'is_true', label: 'es verdadero', needsValue: false },
  { value: 'is_false', label: 'es falso', needsValue: false },
  { value: 'exists', label: 'tiene respuesta', needsValue: false },
  { value: 'not_exists', label: 'no tiene respuesta', needsValue: false },
  { value: 'is_empty', label: 'está vacío', needsValue: false },
  { value: 'not_empty', label: 'no está vacío', needsValue: false },
]

/* ══════════════ EVALUACIÓN DEL ÁRBOL ══════════════ */

const MAX_DEPTH = 12

/**
 * Evalúa una condición contra las respuestas del formulario.
 * Una condición mal formada devuelve false y no rompe la generación.
 */
export function evaluateCondition(condition: Condition | null | undefined, answers: Answers, depth = 0): boolean {
  if (!condition) return true
  if (depth > MAX_DEPTH) {
    console.warn('[reglas] condición demasiado anidada; se ignora')
    return false
  }

  if (isGroup(condition)) {
    const children = Array.isArray(condition.children) ? condition.children : []

    if (condition.op === 'NOT') {
      // NOT sobre varios hijos equivale a NOT(AND(...)).
      if (children.length === 0) return false
      return !children.every((c) => evaluateCondition(c, answers, depth + 1))
    }

    if (children.length === 0) return true

    return condition.op === 'OR'
      ? children.some((c) => evaluateCondition(c, answers, depth + 1))
      : children.every((c) => evaluateCondition(c, answers, depth + 1))
  }

  const leaf = condition as ConditionLeaf
  const comparator = COMPARATORS[leaf.operator]

  if (!comparator) {
    console.warn(`[reglas] operador desconocido: ${leaf.operator}`)
    return false
  }

  return comparator(answers[leaf.variable], leaf.value)
}

/** Texto legible de una condición, para mostrarla en la interfaz. */
export function describeCondition(condition: Condition | null | undefined): string {
  if (!condition) return 'siempre'

  if (isGroup(condition)) {
    const children = (condition.children ?? []).map(describeCondition)
    if (condition.op === 'NOT') return `no (${children.join(' y ')})`
    const joiner = condition.op === 'OR' ? ' o ' : ' y '
    return children.length > 1 ? `(${children.join(joiner)})` : children[0] ?? 'siempre'
  }

  const leaf = condition as ConditionLeaf
  const op = CONDITION_OPERATORS.find((o) => o.value === leaf.operator)
  const label = op?.label ?? leaf.operator
  return op?.needsValue ? `${leaf.variable} ${label} "${String(leaf.value)}"` : `${leaf.variable} ${label}`
}

/* ══════════════ REGLAS ══════════════ */

export type RuleOutcome = {
  /** Cláusulas que una regla fuerza a incluir o excluir. */
  forceClauseOn: Set<string>
  forceClauseOff: Set<string>
  forceSectionOn: Set<string>
  forceSectionOff: Set<string>
  hiddenVariables: Set<string>
  shownVariables: Set<string>
  requiredVariables: Set<string>
  optionalVariables: Set<string>
  /** Valores que las reglas fijan automáticamente. */
  setValues: Record<string, unknown>
  warnings: string[]
  /** Reglas que se dispararon, para poder explicar el resultado. */
  fired: string[]
}

function emptyOutcome(): RuleOutcome {
  return {
    forceClauseOn: new Set(),
    forceClauseOff: new Set(),
    forceSectionOn: new Set(),
    forceSectionOff: new Set(),
    hiddenVariables: new Set(),
    shownVariables: new Set(),
    requiredVariables: new Set(),
    optionalVariables: new Set(),
    setValues: {},
    warnings: [],
    fired: [],
  }
}

/**
 * Aplica todas las reglas activas en orden. Las últimas ganan sobre las
 * primeras cuando se contradicen, igual que en una hoja de cálculo.
 */
export function evaluateRules(rules: TemplateRule[], answers: Answers): RuleOutcome {
  const out = emptyOutcome()

  const active = [...(rules ?? [])]
    .filter((r) => r.is_active !== false)
    .sort((a, b) => (a.sort_order ?? 0) - (b.sort_order ?? 0))

  for (const rule of active) {
    if (!evaluateCondition(rule.conditions, answers)) continue

    out.fired.push(rule.name)
    const p = rule.action_payload ?? {}

    switch (rule.action) {
      case 'SHOW_CLAUSE':
        if (p.clause_id) { out.forceClauseOn.add(p.clause_id); out.forceClauseOff.delete(p.clause_id) }
        break
      case 'HIDE_CLAUSE':
        if (p.clause_id) { out.forceClauseOff.add(p.clause_id); out.forceClauseOn.delete(p.clause_id) }
        break
      case 'SHOW_SECTION':
        if (p.section_id) { out.forceSectionOn.add(p.section_id); out.forceSectionOff.delete(p.section_id) }
        break
      case 'HIDE_SECTION':
        if (p.section_id) { out.forceSectionOff.add(p.section_id); out.forceSectionOn.delete(p.section_id) }
        break
      case 'SHOW_VARIABLE':
        if (p.variable_tag) { out.shownVariables.add(p.variable_tag); out.hiddenVariables.delete(p.variable_tag) }
        break
      case 'HIDE_VARIABLE':
        if (p.variable_tag) { out.hiddenVariables.add(p.variable_tag); out.shownVariables.delete(p.variable_tag) }
        break
      case 'REQUIRE_VARIABLE':
        if (p.variable_tag) { out.requiredVariables.add(p.variable_tag); out.optionalVariables.delete(p.variable_tag) }
        break
      case 'OPTIONAL_VARIABLE':
        if (p.variable_tag) { out.optionalVariables.add(p.variable_tag); out.requiredVariables.delete(p.variable_tag) }
        break
      case 'SET_VALUE':
        if (p.variable_tag) out.setValues[p.variable_tag] = p.value
        break
      case 'WARN_USER':
        if (p.message) out.warnings.push(p.message)
        break
      default:
        console.warn(`[reglas] acción desconocida: ${rule.action}`)
    }
  }

  return out
}
