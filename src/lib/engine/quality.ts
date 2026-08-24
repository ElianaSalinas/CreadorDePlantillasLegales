/**
 * Revisión de calidad de una plantilla.
 *
 * Lo mejor que tenía el legado era que impedía publicar una plantilla
 * incompleta. Eso se conserva y se amplía: aquí además se exige que un
 * profesional haya revisado el contenido legal antes de publicarlo.
 */

import { extractTags } from './variables'
import type { TemplateBundle } from './render'

export type IssueLevel = 'blocker' | 'warning' | 'hint'

export type QualityIssue = {
  level: IssueLevel
  title: string
  detail: string
  /** Dónde hay que ir a arreglarlo. */
  area: 'general' | 'secciones' | 'variables' | 'clausulas' | 'reglas' | 'revision'
}

export type QualityReport = {
  issues: QualityIssue[]
  blockers: number
  warnings: number
  /** Se puede publicar solo si no queda ningún bloqueante. */
  canPublish: boolean
  score: number
}

type ReviewInfo = {
  title?: string | null
  description?: string | null
  category_id?: string | null
  reviewed_by?: string | null
  reviewed_at?: string | null
  is_master?: boolean
}

export function checkTemplateQuality(bundle: TemplateBundle, meta: ReviewInfo = {}): QualityReport {
  const issues: QualityIssue[] = []

  const add = (level: IssueLevel, area: QualityIssue['area'], title: string, detail: string) =>
    issues.push({ level, area, title, detail })

  /* ── Datos generales ── */

  if (!meta.title?.trim()) {
    add('blocker', 'general', 'Falta el título', 'Una plantilla sin título no se puede encontrar.')
  }

  if (!meta.description?.trim()) {
    add('warning', 'general', 'Falta la descripción',
      'Sin descripción, quien la use no sabe para qué sirve ni cuándo usarla.')
  }

  if (!meta.category_id) {
    add('warning', 'general', 'Sin categoría',
      'La plantilla no aparecerá al filtrar por categoría.')
  }

  /* ── Secciones ── */

  const sections = bundle.sections ?? []

  if (sections.length === 0) {
    add('blocker', 'secciones', 'La plantilla no tiene secciones',
      'Sin al menos una sección, el documento generado sale vacío.')
  }

  const bodySections = sections.filter((s) => !s.is_annex)
  if (sections.length > 0 && bodySections.length === 0) {
    add('blocker', 'secciones', 'Solo hay anexos',
      'Todas las secciones están marcadas como anexo. Falta el cuerpo del documento.')
  }

  const emptySections = sections.filter(
    (s) => !s.body?.trim() && !bundle.templateClauses.some((tc) => tc.section_id === s.id)
  )
  for (const s of emptySections) {
    add('warning', 'secciones', `La sección "${s.title}" está vacía`,
      'No tiene texto ni cláusulas asignadas, así que no aportará nada al documento.')
  }

  /* ── Variables ── */

  const declaredTags = new Set(bundle.variables.map((v) => v.tag))

  // Etiquetas usadas en el texto que nadie declaró como variable.
  const usedTags = new Set<string>()
  for (const s of sections) extractTags(s.body ?? '').forEach((t) => usedTags.add(t))
  for (const c of bundle.clauses) extractTags(c.body ?? '').forEach((t) => usedTags.add(t))

  // Las derivadas ({{precio_letras}}) existen aunque no sean variables.
  const derivedAliases = new Set(
    bundle.variables
      .map((v) => v.derived_config?.as || (v.derived_config?.transform ? `${v.tag}_${v.derived_config.transform}` : null))
      .filter(Boolean) as string[]
  )

  const undeclared = [...usedTags].filter((t) => !declaredTags.has(t) && !derivedAliases.has(t))
  for (const tag of undeclared) {
    add('blocker', 'variables', `La variable {{${tag}}} no existe`,
      'Aparece en el texto pero no está en el formulario, así que el documento saldrá con ese hueco sin rellenar.')
  }

  const unused = [...declaredTags].filter((t) => !usedTags.has(t))
  for (const tag of unused) {
    add('hint', 'variables', `La variable {{${tag}}} no se usa`,
      'Se le pide al usuario pero no aparece en ningún texto. Quizá sobra.')
  }

  const noQuestion = bundle.variables.filter((v) => !v.question?.trim())
  if (noQuestion.length > 0) {
    add('hint', 'variables', `${noQuestion.length} variables sin pregunta`,
      'Sin pregunta, el formulario muestra el nombre técnico en vez de algo que una persona entienda.')
  }

  /* ── Cláusulas ── */

  if (bundle.templateClauses.length === 0) {
    add('warning', 'clausulas', 'La plantilla no usa ninguna cláusula',
      'Todo el texto está escrito dentro de las secciones. Funciona, pero no podrás reutilizar nada.')
  }

  const conditionalsWithoutCondition = bundle.templateClauses.filter(
    (tc) => tc.kind === 'CONDITIONAL' && !tc.condition
  )
  for (const tc of conditionalsWithoutCondition) {
    const clause = bundle.clauses.find((c) => c.id === tc.clause_id)
    add('blocker', 'clausulas', `"${clause?.title ?? 'Una cláusula'}" es condicional pero no tiene condición`,
      'Sin condición no se sabe cuándo debe aparecer, así que nunca aparecerá.')
  }

  const draftClauses = bundle.clauses.filter((c) => c.status === 'DRAFT' && c.org_id === null)
  if (draftClauses.length > 0 && meta.is_master) {
    add('blocker', 'revision', `${draftClauses.length} cláusulas siguen en borrador`,
      'Una plantilla maestra no puede publicarse si su contenido legal no ha sido revisado.')
  }

  /* ── Reglas ── */

  const clauseIds = new Set(bundle.templateClauses.map((tc) => tc.clause_id))
  const sectionIds = new Set(sections.map((s) => s.id))

  for (const rule of bundle.rules ?? []) {
    const p = rule.action_payload ?? {}

    if (p.clause_id && !clauseIds.has(p.clause_id)) {
      add('warning', 'reglas', `La regla "${rule.name}" apunta a una cláusula que no está en la plantilla`,
        'No hará nada mientras esa cláusula no se añada.')
    }
    if (p.section_id && !sectionIds.has(p.section_id)) {
      add('warning', 'reglas', `La regla "${rule.name}" apunta a una sección inexistente`,
        'No hará nada.')
    }
    if (p.variable_tag && !declaredTags.has(p.variable_tag)) {
      add('warning', 'reglas', `La regla "${rule.name}" apunta a la variable {{${p.variable_tag}}}, que no existe`,
        'No hará nada.')
    }
  }

  /* ── Revisión legal ── */

  if (meta.is_master && !meta.reviewed_by) {
    add('blocker', 'revision', 'Falta la revisión legal',
      'Una plantilla maestra de SA&VE no puede publicarse sin que un profesional la haya revisado y quedado registrado.')
  }

  const blockers = issues.filter((i) => i.level === 'blocker').length
  const warnings = issues.filter((i) => i.level === 'warning').length

  const score = Math.max(0, 100 - blockers * 25 - warnings * 8 - issues.filter((i) => i.level === 'hint').length * 2)

  return { issues, blockers, warnings, canPublish: blockers === 0, score }
}

export const ISSUE_LEVEL_LABEL: Record<IssueLevel, string> = {
  blocker: 'Impide publicar',
  warning: 'Conviene revisar',
  hint: 'Sugerencia',
}
