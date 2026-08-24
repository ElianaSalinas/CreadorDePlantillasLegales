'use server'

import { revalidatePath } from 'next/cache'
import { requireSession } from '@/lib/session'
import { logAudit } from '@/lib/audit'
import { loadTemplateBundle } from '@/lib/engine/repository'
import { checkTemplateQuality } from '@/lib/engine/quality'
import { snapshotTemplate } from '@/lib/engine/render'
import type { Condition } from '@/lib/engine/types'

export type EditorResult = { ok: boolean; error?: string; notice?: string; id?: string }

const NO_PERMISSION = 'No tienes permiso para editar plantillas.'

/** Solo el dueño de la plantilla —o un admin de SA&VE— puede tocarla. */
async function guard(templateId: string) {
  const session = await requireSession()
  if (!session.org) throw new Error('No tienes un espacio de trabajo asignado.')
  if (!session.permissions.templates) throw new Error(NO_PERMISSION)

  const { data: template } = await session.supabase
    .from('templates')
    .select('id, org_id, is_master, status')
    .eq('id', templateId)
    .maybeSingle()

  if (!template) throw new Error('No se encontró la plantilla.')

  const owned = template.org_id === session.org.id
  if (!owned && !session.isAdmin) throw new Error('Esta plantilla no es de tu despacho.')

  return { ...session, template }
}

function wrap(err: unknown): EditorResult {
  return { ok: false, error: err instanceof Error ? err.message : 'Error inesperado.' }
}

function touch(templateId: string) {
  revalidatePath(`/app/templates/${templateId}/edit`)
  revalidatePath('/app/templates')
}

/* ══════════════ DATOS GENERALES ══════════════ */

export async function updateTemplateMeta(templateId: string, formData: FormData): Promise<EditorResult> {
  try {
    const { supabase, user, org } = await guard(templateId)

    const title = String(formData.get('title') ?? '').trim()
    const description = String(formData.get('description') ?? '').trim()
    const category_id = String(formData.get('category_id') ?? '').trim()

    if (!title) return { ok: false, error: 'La plantilla necesita un título.' }

    const { error } = await supabase
      .from('templates')
      .update({ title, description: description || null, category_id: category_id || null })
      .eq('id', templateId)

    if (error) return { ok: false, error: error.message }

    await logAudit(supabase, { orgId: org!.id, userId: user.id, action: 'TEMPLATE_EDITED', description: `Datos generales: ${title}` })
    touch(templateId)
    return { ok: true, notice: 'Guardado.' }
  } catch (err) { return wrap(err) }
}

/* ══════════════ SECCIONES ══════════════ */

export async function saveSection(templateId: string, sectionId: string | null, formData: FormData): Promise<EditorResult> {
  try {
    const { supabase } = await guard(templateId)

    const payload = {
      template_id: templateId,
      title: String(formData.get('title') ?? '').trim(),
      body: String(formData.get('body') ?? ''),
      is_annex: formData.get('is_annex') === 'on',
      sort_order: Number(formData.get('sort_order') ?? 0),
    }

    if (!payload.title) return { ok: false, error: 'La sección necesita un título.' }

    const { data, error } = sectionId
      ? await supabase.from('template_sections').update(payload).eq('id', sectionId).select('id').maybeSingle()
      : await supabase.from('template_sections').insert(payload).select('id').maybeSingle()

    if (error) return { ok: false, error: error.message }

    touch(templateId)
    return { ok: true, notice: sectionId ? 'Sección actualizada.' : 'Sección creada.', id: data?.id }
  } catch (err) { return wrap(err) }
}

export async function deleteSection(templateId: string, sectionId: string): Promise<EditorResult> {
  try {
    const { supabase } = await guard(templateId)
    const { error } = await supabase.from('template_sections').delete().eq('id', sectionId).eq('template_id', templateId)
    if (error) return { ok: false, error: error.message }
    touch(templateId)
    return { ok: true, notice: 'Sección eliminada.' }
  } catch (err) { return wrap(err) }
}

export async function moveSection(templateId: string, sectionId: string, direction: -1 | 1): Promise<EditorResult> {
  try {
    const { supabase } = await guard(templateId)

    const { data: sections } = await supabase
      .from('template_sections')
      .select('id, sort_order')
      .eq('template_id', templateId)
      .order('sort_order')

    const list = sections ?? []
    const index = list.findIndex((s) => s.id === sectionId)
    const target = index + direction

    if (index < 0 || target < 0 || target >= list.length) return { ok: true }

    await Promise.all([
      supabase.from('template_sections').update({ sort_order: list[target].sort_order }).eq('id', list[index].id),
      supabase.from('template_sections').update({ sort_order: list[index].sort_order }).eq('id', list[target].id),
    ])

    touch(templateId)
    return { ok: true }
  } catch (err) { return wrap(err) }
}

/* ══════════════ VARIABLES ══════════════ */

export async function attachVariable(templateId: string, variableId: string, sectionId: string | null): Promise<EditorResult> {
  try {
    const { supabase } = await guard(templateId)

    const { count } = await supabase
      .from('template_variables')
      .select('id', { count: 'exact', head: true })
      .eq('template_id', templateId)

    const { error } = await supabase.from('template_variables').insert({
      template_id: templateId,
      variable_id: variableId,
      section_id: sectionId,
      sort_order: (count ?? 0) + 1,
    })

    if (error) {
      if (error.code === '23505') return { ok: false, error: 'Esa variable ya está en la plantilla.' }
      return { ok: false, error: error.message }
    }

    touch(templateId)
    return { ok: true, notice: 'Variable añadida al formulario.' }
  } catch (err) { return wrap(err) }
}

export async function detachVariable(templateId: string, linkId: string): Promise<EditorResult> {
  try {
    const { supabase } = await guard(templateId)
    const { error } = await supabase.from('template_variables').delete().eq('id', linkId).eq('template_id', templateId)
    if (error) return { ok: false, error: error.message }
    touch(templateId)
    return { ok: true, notice: 'Variable retirada.' }
  } catch (err) { return wrap(err) }
}

/* ══════════════ CLÁUSULAS ══════════════ */

export async function attachClause(
  templateId: string,
  clauseId: string,
  kind: 'MANDATORY' | 'OPTIONAL' | 'CONDITIONAL' | 'RECOMMENDED',
  sectionId: string | null
): Promise<EditorResult> {
  try {
    const { supabase } = await guard(templateId)

    const { count } = await supabase
      .from('template_clauses')
      .select('id', { count: 'exact', head: true })
      .eq('template_id', templateId)

    const { error } = await supabase.from('template_clauses').insert({
      template_id: templateId,
      clause_id: clauseId,
      kind,
      section_id: sectionId,
      sort_order: (count ?? 0) + 1,
      is_default_on: kind !== 'OPTIONAL',
    })

    if (error) {
      if (error.code === '23505') return { ok: false, error: 'Esa cláusula ya está en la plantilla.' }
      return { ok: false, error: error.message }
    }

    touch(templateId)
    return { ok: true, notice: 'Cláusula añadida. Con esto ya sale en el documento.' }
  } catch (err) { return wrap(err) }
}

export async function updateClauseLink(
  templateId: string,
  linkId: string,
  changes: { kind?: string; is_default_on?: boolean; condition?: Condition | null; section_id?: string | null }
): Promise<EditorResult> {
  try {
    const { supabase } = await guard(templateId)

    // Una condicional sin condición nunca aparecería: se avisa aquí.
    if (changes.kind === 'CONDITIONAL' && changes.condition === undefined) {
      const { data: existing } = await supabase
        .from('template_clauses').select('condition').eq('id', linkId).maybeSingle()
      if (!existing?.condition) {
        return { ok: false, error: 'Una cláusula condicional necesita una condición. Añádela antes de cambiar el tipo.' }
      }
    }

    const { error } = await supabase.from('template_clauses').update(changes).eq('id', linkId).eq('template_id', templateId)
    if (error) return { ok: false, error: error.message }

    touch(templateId)
    return { ok: true, notice: 'Actualizado.' }
  } catch (err) { return wrap(err) }
}

export async function detachClause(templateId: string, linkId: string): Promise<EditorResult> {
  try {
    const { supabase } = await guard(templateId)
    const { error } = await supabase.from('template_clauses').delete().eq('id', linkId).eq('template_id', templateId)
    if (error) return { ok: false, error: error.message }
    touch(templateId)
    return { ok: true, notice: 'Cláusula retirada de la plantilla.' }
  } catch (err) { return wrap(err) }
}

/* ══════════════ REGLAS ══════════════ */

export async function saveRule(templateId: string, ruleId: string | null, rule: {
  name: string
  conditions: Condition
  action: string
  action_payload: Record<string, unknown>
}): Promise<EditorResult> {
  try {
    const { supabase } = await guard(templateId)

    if (!rule.name?.trim()) return { ok: false, error: 'La regla necesita un nombre.' }

    const { count } = await supabase
      .from('template_rules').select('id', { count: 'exact', head: true }).eq('template_id', templateId)

    const payload = {
      template_id: templateId,
      name: rule.name.trim(),
      conditions: rule.conditions,
      action: rule.action,
      action_payload: rule.action_payload,
      sort_order: ruleId ? undefined : (count ?? 0) + 1,
    }

    const { error } = ruleId
      ? await supabase.from('template_rules').update({ ...payload, sort_order: undefined }).eq('id', ruleId).eq('template_id', templateId)
      : await supabase.from('template_rules').insert(payload)

    if (error) return { ok: false, error: error.message }

    touch(templateId)
    return { ok: true, notice: ruleId ? 'Regla actualizada.' : 'Regla creada.' }
  } catch (err) { return wrap(err) }
}

export async function deleteRule(templateId: string, ruleId: string): Promise<EditorResult> {
  try {
    const { supabase } = await guard(templateId)
    const { error } = await supabase.from('template_rules').delete().eq('id', ruleId).eq('template_id', templateId)
    if (error) return { ok: false, error: error.message }
    touch(templateId)
    return { ok: true, notice: 'Regla eliminada.' }
  } catch (err) { return wrap(err) }
}

export async function toggleRule(templateId: string, ruleId: string, isActive: boolean): Promise<EditorResult> {
  try {
    const { supabase } = await guard(templateId)
    const { error } = await supabase.from('template_rules').update({ is_active: isActive }).eq('id', ruleId).eq('template_id', templateId)
    if (error) return { ok: false, error: error.message }
    touch(templateId)
    return { ok: true }
  } catch (err) { return wrap(err) }
}

/* ══════════════ PUBLICAR ══════════════ */

/**
 * Publica la plantilla, pero solo si pasa la revisión de calidad.
 * Antes de publicar congela una versión, para que los documentos que se
 * generen a partir de ahora queden anclados a este contenido exacto.
 */
export async function publishTemplate(templateId: string, versionNote: string): Promise<EditorResult> {
  try {
    const { supabase, user, org, template } = await guard(templateId)

    const bundle = await loadTemplateBundle(templateId)
    if (!bundle) return { ok: false, error: 'No se pudo leer la plantilla.' }

    const { data: meta } = await supabase
      .from('templates')
      .select('title, description, category_id, reviewed_by, reviewed_at, is_master, version')
      .eq('id', templateId)
      .maybeSingle()

    const report = checkTemplateQuality(bundle, meta ?? {})

    if (!report.canPublish) {
      const first = report.issues.find((i) => i.level === 'blocker')
      return {
        ok: false,
        error: `No se puede publicar: ${report.blockers} problema(s) por resolver. El primero: ${first?.title}`,
      }
    }

    const current = meta?.version ?? '1.0'
    const [major, minor] = current.split('.').map((n) => parseInt(n, 10) || 0)
    const nextVersion = `${major}.${minor + 1}`

    await supabase.from('template_versions').insert({
      template_id: templateId,
      version: nextVersion,
      snapshot: snapshotTemplate(bundle),
      status: 'PUBLISHED',
      note: versionNote?.trim() || null,
      published_at: new Date().toISOString(),
      created_by: user.id,
    })

    const { error } = await supabase
      .from('templates')
      .update({ status: 'PUBLISHED', version: nextVersion })
      .eq('id', templateId)

    if (error) return { ok: false, error: error.message }

    await logAudit(supabase, {
      orgId: org!.id,
      userId: user.id,
      action: 'TEMPLATE_PUBLISHED',
      description: `${meta?.title} publicada como v${nextVersion}`,
    })

    touch(templateId)
    return { ok: true, notice: `Publicada como versión ${nextVersion}.` }
  } catch (err) { return wrap(err) }
}

export async function unpublishTemplate(templateId: string): Promise<EditorResult> {
  try {
    const { supabase } = await guard(templateId)
    const { error } = await supabase.from('templates').update({ status: 'DRAFT' }).eq('id', templateId)
    if (error) return { ok: false, error: error.message }
    touch(templateId)
    return { ok: true, notice: 'Vuelve a borrador. Ya no aparece para los usuarios.' }
  } catch (err) { return wrap(err) }
}
