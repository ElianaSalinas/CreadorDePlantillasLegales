/**
 * Ensamblado del documento.
 *
 * Diferencia clave con el legado: vincular una cláusula a una plantilla
 * BASTA para que salga en el documento. El legado exigía además escribir
 * un marcador a mano dentro del texto, y si faltaba —que era lo normal—
 * la cláusula figuraba vinculada y el contrato salía sin ella.
 */

import { evaluateCondition, evaluateRules, type RuleOutcome } from './rules'
import { buildSubstitutions, substitute, monedaDeRespuestas } from './variables'
import { numerarClausula, type FormatoArticulo } from './articulos'
import type {
  Answers,
  Clause,
  TemplateClause,
  TemplateRule,
  TemplateSection,
  TemplateVariable,
  Variable,
} from './types'

// Se re-exportan para quien ya los importaba desde aquí (verify-engine).
export { numerarClausula, formatoArticulo } from './articulos'

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
 *
 * `options.formatoArticulos`: cómo se numeran las cláusulas del cuerpo
 * ("ARTÍCULO PRIMERO:", "Artículo 1:", "ARTÍCULO I:"…). Ver articulos.ts.
 *
 * `options.firmasOverride`: si viene, reemplaza el TEXTO de la sección
 * "Firmas" (una coletilla notarial guardada, ver Fase 13.5). El título de
 * la sección se sigue mostrando igual; solo cambia el cuerpo, que es
 * donde vive el "Hecho y firmado en..." que cada notario redacta a su
 * manera.
 */
export function renderDocument(
  bundle: TemplateBundle,
  answers: Answers,
  userSelection: Record<string, boolean> = {},
  options: { firmasOverride?: string | null; formatoArticulos?: FormatoArticulo } = {}
): RenderResult {
  const outcome = evaluateRules(bundle.rules ?? [], answers)

  // Las reglas pueden fijar valores; cuentan como respuestas.
  const effective: Answers = { ...answers, ...outcome.setValues }

  // Una empresa comparece con UN representante. Si alguien eligió
  // "persona", puso 2 o más y después cambió a "empresa", la pregunta de
  // cuántas se oculta pero su respuesta seguía ahí, y el contrato metía a
  // esas personas como comparecientes junto a la empresa.
  for (const parte of ['primera', 'segunda']) {
    if (effective[`parte_${parte}_tipo_parte`] === 'empresa' && `parte_${parte}_cantidad` in effective) {
      effective[`parte_${parte}_cantidad`] = '1'
    }
  }
  const moneda = monedaDeRespuestas(effective)

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
    const r = substitute(text, substitutions, { variables: bundle.variables, moneda })
    r.missing.forEach((m) => missing.add(m))
    pieces.push(r.text.trim())
  }

  // Las cláusulas del cuerpo se numeran en el orden en que salen: la
  // numeración depende de cuáles entraron, así que no puede vivir en el
  // texto guardado. Las de los anexos no se numeran.
  let articulo = 0
  const pushArticulo = (clause: Clause) => {
    if (!clause.body || !clause.body.trim()) return
    articulo += 1
    push(numerarClausula(articulo, clause.title, clause.body.trim(), options.formatoArticulos))
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

    const body =
      section.title === 'Firmas' && options.firmasOverride ? options.firmasOverride : section.body
    push(section.title === 'Firmas' ? conFirmasDeLasPartes(body, bundle, effective) : body)

    for (const clause of clausesFor(section.id)) pushArticulo(clause)
  }

  // Cláusulas que nadie asignó a una sección
  for (const clause of clausesFor(null)) pushArticulo(clause)

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
    // "portador de {{tipo_documento}}" con "el pasaporte" daba "portador de
    // el pasaporte". Solo en minúscula: "de El Seibo" (provincia) no se toca.
    text: pieces.join('\n\n').replace(/ de el /g, ' del '),
    missing: [...missing],
    clauses: decisions,
    warnings: outcome.warnings,
    outcome,
  }
}

/* ─────────────── Bloque de firmas ─────────────── */

const LINEA_FIRMA = '_______________________________'

/**
 * Una firma por cada persona que comparece, en lugar de las dos líneas
 * fijas "LA PRIMERA PARTE / LA SEGUNDA PARTE":
 *
 *   persona(s)   _______________________________
 *                LA PRIMERA PARTE
 *                Juan Pérez                 ← una firma por persona (1 a 4)
 *
 *   empresa      _______________________________
 *                LA PRIMERA PARTE
 *                Inmobiliaria del Este, S.R.L.
 *                María Gómez                ← su representante
 *
 * Los nombres van como {{variables}}, así que pasan por la sustitución
 * normal: salen en negrita en Word y, si faltan, se marcan como dato
 * pendiente.
 */
function firmasDeLaParte(parte: 'primera' | 'segunda', answers: Answers): string[] {
  const p = `parte_${parte}`
  const rotulo = `LA ${parte.toUpperCase()} PARTE`

  if (answers[`${p}_tipo_parte`] === 'empresa') {
    return [[LINEA_FIRMA, rotulo, `{{${p}_razon_social}}`, `{{${p}_nombre}}`].join('\n')]
  }

  const cantidad = Math.min(4, Math.max(1, Math.trunc(Number(answers[`${p}_cantidad`] ?? 1)) || 1))
  const firmas: string[] = []
  for (let n = 1; n <= cantidad; n++) {
    const nombre = n === 1 ? `{{${p}_nombre}}` : `{{${p}_miembro${n}_nombre}}`
    firmas.push([LINEA_FIRMA, rotulo, nombre].join('\n'))
  }
  return firmas
}

/**
 * Sustituye las líneas de firma de la sección "Firmas" por una firma por
 * persona. Solo en plantillas con partes (las del catálogo de contratos):
 * las demás no saben quién firma y se dejan como están.
 *
 * - Texto estándar: lo que va desde la primera línea de "____" hasta el
 *   final se reemplaza; el "Hecho y firmado en…" de arriba se conserva.
 * - Coletilla notarial (texto propio del notario): si ya trae sus líneas
 *   de firma, no se toca; si no las trae, las firmas van ANTES de ella,
 *   que es donde van en un acto notarial (el notario certifica las firmas
 *   que anteceden).
 */
export function conFirmasDeLasPartes(cuerpo: string | null | undefined, bundle: TemplateBundle, answers: Answers): string | null | undefined {
  const tags = new Set(bundle.variables.map((v) => v.tag))
  const partes = (['primera', 'segunda'] as const).filter((parte) => tags.has(`parte_${parte}_nombre`))
  if (partes.length === 0 || !cuerpo) return cuerpo

  const bloque = partes.flatMap((parte) => firmasDeLaParte(parte, answers)).join('\n\n\n')

  const lineas = cuerpo.split(/\r?\n/)
  const primeraFirma = lineas.findIndex((l) => /_{5,}/.test(l))

  if (primeraFirma >= 0) {
    // La zona de firmas: desde la primera línea de "____" hasta la última
    // línea que sea de firma o diga "LA PRIMERA/SEGUNDA PARTE". Lo que
    // venga detrás (la certificación de un notario) se conserva.
    const esLineaDeFirma = (l: string) => /_{5,}|LA (PRIMERA|SEGUNDA) PARTE/.test(l)
    let ultima = primeraFirma
    for (let i = primeraFirma; i < lineas.length; i++) if (esLineaDeFirma(lineas[i])) ultima = i

    const esEstandar = lineas.slice(primeraFirma, ultima + 1).some((l) => /LA (PRIMERA|SEGUNDA) PARTE/.test(l))
    if (!esEstandar) return cuerpo // líneas de firma propias (coletilla): no se tocan

    const antes = lineas.slice(0, primeraFirma).join('\n').trimEnd()
    const despues = lineas.slice(ultima + 1).join('\n').trim()
    return [antes, bloque, despues].filter(Boolean).join('\n\n\n')
  }

  // Sin líneas de firma (una coletilla que solo trae la certificación).
  return `${bloque}\n\n\n${cuerpo}`
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
