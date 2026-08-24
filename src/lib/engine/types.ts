/**
 * Tipos del motor documental. Reflejan el esquema de la migración
 * 20260825000000_document_engine_core.sql.
 */

export type VariableDataType =
  | 'text' | 'textarea' | 'number' | 'currency' | 'percentage' | 'date'
  | 'email' | 'phone' | 'boolean' | 'select' | 'multiselect'
  | 'address' | 'person' | 'company' | 'cedula' | 'rnc'

export type ClauseKind = 'MANDATORY' | 'OPTIONAL' | 'CONDITIONAL' | 'RECOMMENDED'

export type ContentStatus = 'DRAFT' | 'REVIEW' | 'APPROVED' | 'PUBLISHED' | 'ARCHIVED'

export type SelectOption = { value: string; label: string }

/** Transformación automática aplicada al valor antes de sustituirlo. */
export type DerivedConfig = {
  /** montoALetras, fechaNotarial, fechaLarga, mayusculas, cedulaFormato */
  transform?: string
  currency?: 'DOP' | 'USD' | 'EUR'
  /** Etiqueta con la que se expone la versión transformada: {{monto_letras}} */
  as?: string
}

export type Variable = {
  id: string
  org_id: string | null
  tag: string
  label: string
  question: string | null
  help_text: string | null
  data_type: VariableDataType
  options: SelectOption[]
  default_value: string | null
  validation_regex: string | null
  validation_message: string | null
  is_required: boolean
  derived_config: DerivedConfig | null
}

export type Clause = {
  id: string
  org_id: string | null
  slug: string
  title: string
  family: string
  description: string | null
  body: string
  legal_reference: string | null
  status: ContentStatus
}

export type TemplateSection = {
  id: string
  template_id: string
  title: string
  body: string | null
  sort_order: number
  is_enabled: boolean
  is_annex: boolean
  condition: Condition | null
}

export type TemplateVariable = {
  id: string
  variable_id: string
  section_id: string | null
  sort_order: number
  is_required: boolean | null
}

export type TemplateClause = {
  id: string
  clause_id: string
  section_id: string | null
  kind: ClauseKind
  is_default_on: boolean
  sort_order: number
  condition: Condition | null
}

/* ══════════════ CONDICIONES ══════════════ */

export type ConditionOperator =
  | 'equals' | 'not_equals'
  | 'contains' | 'not_contains'
  | 'greater_than' | 'less_than'
  | 'greater_or_equal' | 'less_or_equal'
  | 'is_true' | 'is_false'
  | 'exists' | 'not_exists'
  | 'is_empty' | 'not_empty'
  | 'in' | 'not_in'

/** Hoja del árbol: una comparación sobre una variable. */
export type ConditionLeaf = {
  variable: string
  operator: ConditionOperator
  value?: unknown
}

/** Nodo del árbol: agrupa otras condiciones. */
export type ConditionGroup = {
  op: 'AND' | 'OR' | 'NOT'
  children: Condition[]
}

export type Condition = ConditionLeaf | ConditionGroup

export function isGroup(c: Condition): c is ConditionGroup {
  return typeof (c as ConditionGroup).op === 'string'
}

/* ══════════════ REGLAS ══════════════ */

export type RuleAction =
  | 'SHOW_CLAUSE' | 'HIDE_CLAUSE'
  | 'SHOW_SECTION' | 'HIDE_SECTION'
  | 'SHOW_VARIABLE' | 'HIDE_VARIABLE'
  | 'REQUIRE_VARIABLE' | 'OPTIONAL_VARIABLE'
  | 'SET_VALUE'
  | 'WARN_USER'

export const RULE_ACTIONS: { value: RuleAction; label: string; target: 'clause' | 'section' | 'variable' | 'none' }[] = [
  { value: 'SHOW_CLAUSE', label: 'Incluir cláusula', target: 'clause' },
  { value: 'HIDE_CLAUSE', label: 'Excluir cláusula', target: 'clause' },
  { value: 'SHOW_SECTION', label: 'Incluir sección', target: 'section' },
  { value: 'HIDE_SECTION', label: 'Excluir sección', target: 'section' },
  { value: 'SHOW_VARIABLE', label: 'Mostrar campo', target: 'variable' },
  { value: 'HIDE_VARIABLE', label: 'Ocultar campo', target: 'variable' },
  { value: 'REQUIRE_VARIABLE', label: 'Hacer obligatorio', target: 'variable' },
  { value: 'OPTIONAL_VARIABLE', label: 'Hacer opcional', target: 'variable' },
  { value: 'SET_VALUE', label: 'Fijar un valor', target: 'variable' },
  { value: 'WARN_USER', label: 'Mostrar una advertencia', target: 'none' },
]

export type TemplateRule = {
  id: string
  name: string
  conditions: Condition
  action: RuleAction
  action_payload: {
    clause_id?: string
    section_id?: string
    variable_tag?: string
    value?: unknown
    message?: string
  }
  is_active: boolean
  sort_order: number
}

/** Respuestas del formulario: etiqueta de variable → valor. */
export type Answers = Record<string, unknown>
