/**
 * Ensamblado del documento.
 *
 * Diferencia clave con el legado: vincular una cláusula a una plantilla
 * BASTA para que salga en el documento. El legado exigía además escribir
 * un marcador a mano dentro del texto, y si faltaba —que era lo normal—
 * la cláusula figuraba vinculada y el contrato salía sin ella.
 */

import { evaluateCondition, evaluateRules, type RuleOutcome } from './rules'
import { buildSubstitutions, substitute } from './variables'
import type {
  Answers,
  Clause,
  TemplateClause,
  TemplateRule,
  TemplateSection,
  TemplateVariable,
  Variable,
} from './types'

export type TemplateBundle = {
  template: { id: string; title: string; version: string; content?: unknown }
  sections: TemplateSection[]
  variables: Variable[]
  templateVariables: TemplateVariable[]
  clauses: Clause[]
  templateClauses: TemplateClause[]
  rules: TemplateRule[]
}

export type ClauseDecision = {
  clauseId: string
  title: string
  included: boolean
  /** Por qué entró o no entró. Se muestra en la interfaz. */
  reason: 'obligatoria' | 'opcional-activada' | 'opcional-desactivada' | 'condicion-cumplida' | 'condicion-no-cumplida' | 'regla' | 'regla-excluye'
}

export type RenderResult = {
  text: string
  /** Etiquetas que quedaron sin valor en el documento final. */
  missing: string[]
  clauses: ClauseDecision[]
  warnings: string[]
  outcome: RuleOutcome
}

/**
 * Decide qué cláusulas entran, en este orden de prioridad:
 *   1. Una regla que la excluya gana sobre todo lo demás.
 *   2. Una regla que la incluya gana sobre la condición y sobre el usuario.
 *   3. Si es condicional, manda su condición.
 *   4. Si es opcional, manda lo que haya marcado el usuario.
 *   5. Si es obligatoria, entra siempre.
 */
export function decideClauses(
  bundle: TemplateBundle,
  answers: Answers,
  userSelection: Record<string, boolean>,
  outcome: RuleOutcome
): ClauseDecision[] {
  const byId = new Map(bundle.clauses.map((c) => [c.id, c]))

  return [...bundle.templateClauses]
    .sort((a, b) => (a.sort_order ?? 0) - (b.sort_order ?? 0))
    .map((tc): ClauseDecision => {
      const clause = byId.get(tc.clause_id)
      const title = clause?.title ?? 'Cláusula desconocida'

      if (outcome.forceClauseOff.has(tc.clause_id)) {
        return { clauseId: tc.clause_id, title, included: false, reason: 'regla-excluye' }
      }

      if (outcome.forceClauseOn.has(tc.clause_id)) {
        return { clauseId: tc.clause_id, title, included: true, reason: 'regla' }
      }

      if (tc.kind === 'CONDITIONAL') {
        const ok = evaluateCondition(tc.condition, answers)
        return {
          clauseId: tc.clause_id,
          title,
          included: ok,
          reason: ok ? 'condicion-cumplida' : 'condicion-no-cumplida',
        }
      }

      if (tc.kind === 'OPTIONAL' || tc.kind === 'RECOMMENDED') {
        const chosen = userSelection[tc.clause_id] ?? tc.is_default_on
        return {
          clauseId: tc.clause_id,
          title,
          included: chosen,
          reason: chosen ? 'opcional-activada' : 'opcional-desactivada',
        }
      }

      return { clauseId: tc.clause_id, title, included: true, reason: 'obligatoria' }
    })
}

/**
 * Arma el documento completo: recorre las secciones en orden, sustituye
 * las variables de cada una y detrás coloca las cláusulas que le tocan.
 * Las cláusulas sin sección asignada van al final, antes de los anexos.
 */
export function renderDocument(
  bundle: TemplateBundle,
  answers: Answers,
  userSelection: Record<string, boolean> = {}
): RenderResult {
  const outcome = evaluateRules(bundle.rules ?? [], answers)

  // Las reglas pueden fijar valores; cuentan como respuestas.
  const effective: Answers = { ...answers, ...outcome.setValues }

  const decisions = decideClauses(bundle, effective, userSelection, outcome)
  const included = new Set(decisions.filter((d) => d.included).map((d) => d.clauseId))

  const clauseById = new Map(bundle.clauses.map((c) => [c.id, c]))
  const substitutions = buildSubstitutions(bundle.variables, effective)
  // El valor crudo se guarda aparte para que las transformaciones en línea
  // ({{monto|letras}}) trabajen sobre el número y no sobre el texto ya formateado.
  for (const v of bundle.variables) {
    const raw = effective[v.tag]
    if (raw !== undefined && raw !== null) substitutions[`${v.tag}__raw`] = String(raw)
  }

  const missing = new Set<string>()
  const pieces: string[] = []

  const push = (text: string | null | undefined) => {
    if (!text || !text.trim()) return
    const r = substitute(text, substitutions, { variables: bundle.variables })
    r.missing.forEach((m) => missing.add(m))
    pieces.push(r.text.trim())
  }

  const clausesFor = (sectionId: string | null) =>
    [...bundle.templateClauses]
      .filter((tc) => (tc.section_id ?? null) === sectionId && included.has(tc.clause_id))
      .sort((a, b) => (a.sort_order ?? 0) - (b.sort_order ?? 0))
      .map((tc) => clauseById.get(tc.clause_id))
      .filter(Boolean) as Clause[]

  const sections = [...(bundle.sections ?? [])].sort((a, b) => (a.sort_order ?? 0) - (b.sort_order ?? 0))

  const isSectionOn = (s: TemplateSection) => {
    if (outcome.forceSectionOff.has(s.id)) return false
    if (outcome.forceSectionOn.has(s.id)) return true
    if (s.is_enabled === false) return false
    return evaluateCondition(s.condition, effective)
  }

  // Cuerpo
  for (const section of sections.filter((s) => !s.is_annex)) {
    if (!isSectionOn(section)) continue
    if (section.title?.trim()) pieces.push(section.title.trim().toUpperCase())
    push(section.body)
    for (const clause of clausesFor(section.id)) push(clause.body)
  }

  // Cláusulas que nadie asignó a una sección
  for (const clause of clausesFor(null)) push(clause.body)

  // Anexos, siempre al final
  const annexes = sections.filter((s) => s.is_annex && isSectionOn(s))
  if (annexes.length > 0) {
    pieces.push('ANEXOS')
    for (const annex of annexes) {
      if (annex.title?.trim()) pieces.push(annex.title.trim().toUpperCase())
      push(annex.body)
      for (const clause of clausesFor(annex.id)) push(clause.body)
    }
  }

  return {
    text: pieces.join('\n\n'),
    missing: [...missing],
    clauses: decisions,
    warnings: outcome.warnings,
    outcome,
  }
}

/**
 * Congela la plantilla entera para guardarla como versión. La clave
 * `template` es obligatoria: la base de datos rechaza un snapshot sin ella,
 * justamente para que no se puedan guardar versiones vacías como pasaba
 * en el legado.
 */
export function snapshotTemplate(bundle: TemplateBundle) {
  return {
    template: bundle.template,
    sections: bundle.sections,
    variables: bundle.variables,
    templateVariables: bundle.templateVariables,
    clauses: bundle.clauses,
    templateClauses: bundle.templateClauses,
    rules: bundle.rules,
    snapshotAt: new Date().toISOString(),
  }
}
