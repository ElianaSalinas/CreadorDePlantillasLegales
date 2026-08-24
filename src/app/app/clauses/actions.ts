'use server'

import { revalidatePath } from 'next/cache'
import { requireSession } from '@/lib/session'
import { logAudit } from '@/lib/audit'
import { normalizeTag, extractTags } from '@/lib/engine/variables'

export type ClauseResult = { ok: boolean; error?: string; notice?: string; clauseId?: string }

export const CLAUSE_FAMILIES = [
  'Generales',
  'Económicas',
  'Inmobiliarias',
  'Empresariales',
  'Laborales',
  'Tecnología',
  'Otras',
] as const

const NO_PERMISSION = 'No tienes permiso para gestionar las cláusulas del despacho.'

function readForm(formData: FormData) {
  return {
    title: String(formData.get('title') ?? '').trim(),
    family: String(formData.get('family') ?? 'Generales').trim(),
    description: String(formData.get('description') ?? '').trim(),
    body: String(formData.get('body') ?? '').trim(),
    legal_reference: String(formData.get('legal_reference') ?? '').trim(),
  }
}

export async function createClause(formData: FormData): Promise<ClauseResult> {
  const { supabase, user, org, permissions } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }
  if (!permissions.templates) return { ok: false, error: NO_PERMISSION }

  const data = readForm(formData)
  if (!data.title) return { ok: false, error: 'La cláusula necesita un título.' }
  if (!data.body) return { ok: false, error: 'La cláusula necesita un texto.' }

  const slug = normalizeTag(data.title).replace(/_/g, '-')

  const { data: created, error } = await supabase
    .from('clauses')
    .insert({
      org_id: org.id,
      slug,
      title: data.title,
      family: data.family,
      description: data.description || null,
      body: data.body,
      legal_reference: data.legal_reference || null,
      status: 'APPROVED', // las del despacho las aprueba el propio despacho
      created_by: user.id,
    })
    .select('id')
    .maybeSingle()

  if (error) {
    if (error.code === '23505') {
      return { ok: false, error: 'Ya tienes una cláusula con ese título.' }
    }
    return { ok: false, error: error.message }
  }

  await logAudit(supabase, {
    orgId: org.id,
    userId: user.id,
    action: 'CLAUSE_CREATED',
    description: `Cláusula creada: ${data.title}`,
  })

  revalidatePath('/app/clauses')
  return { ok: true, notice: 'Cláusula creada.', clauseId: created?.id }
}

export async function updateClause(id: string, formData: FormData): Promise<ClauseResult> {
  const { supabase, user, org, permissions } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }
  if (!permissions.templates) return { ok: false, error: NO_PERMISSION }

  const data = readForm(formData)
  if (!data.title) return { ok: false, error: 'La cláusula necesita un título.' }
  if (!data.body) return { ok: false, error: 'La cláusula necesita un texto.' }

  const { error } = await supabase
    .from('clauses')
    .update({
      title: data.title,
      family: data.family,
      description: data.description || null,
      body: data.body,
      legal_reference: data.legal_reference || null,
    })
    .eq('id', id)
    .eq('org_id', org.id)

  if (error) return { ok: false, error: error.message }

  await logAudit(supabase, {
    orgId: org.id,
    userId: user.id,
    action: 'CLAUSE_EDITED',
    description: `Cláusula editada: ${data.title}`,
  })

  revalidatePath('/app/clauses')
  return { ok: true, notice: 'Cláusula actualizada en todas las plantillas que la usan.' }
}

export async function deleteClause(id: string): Promise<ClauseResult> {
  const { supabase, user, org, permissions } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }
  if (!permissions.templates) return { ok: false, error: NO_PERMISSION }

  // Avisar si está en uso: borrarla la quita de esas plantillas.
  const { count } = await supabase
    .from('template_clauses')
    .select('id', { count: 'exact', head: true })
    .eq('clause_id', id)

  const { error } = await supabase.from('clauses').delete().eq('id', id).eq('org_id', org.id)
  if (error) return { ok: false, error: error.message }

  await logAudit(supabase, {
    orgId: org.id,
    userId: user.id,
    action: 'CLAUSE_DELETED',
    description: `Cláusula ${id} eliminada`,
  })

  revalidatePath('/app/clauses')
  return {
    ok: true,
    notice: (count ?? 0) > 0
      ? `Cláusula eliminada. Se retiró de ${count} plantilla(s) que la usaban.`
      : 'Cláusula eliminada.',
  }
}

/** Copia una cláusula de SA&VE al despacho para poder adaptarla. */
export async function forkClause(id: string): Promise<ClauseResult> {
  const { supabase, user, org, permissions } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }
  if (!permissions.templates) return { ok: false, error: NO_PERMISSION }

  const { data: source } = await supabase
    .from('clauses')
    .select('title, family, description, body, legal_reference')
    .eq('id', id)
    .maybeSingle()

  if (!source) return { ok: false, error: 'No se encontró la cláusula.' }

  const title = `${source.title} (adaptada)`

  const { error } = await supabase.from('clauses').insert({
    org_id: org.id,
    slug: normalizeTag(title).replace(/_/g, '-'),
    title,
    family: source.family,
    description: source.description,
    body: source.body,
    legal_reference: source.legal_reference,
    status: 'APPROVED',
    created_by: user.id,
  })

  if (error) return { ok: false, error: error.message }

  revalidatePath('/app/clauses')
  return { ok: true, notice: 'Copiada a tu despacho. Ahora puedes editarla sin afectar la original.' }
}

/** Las variables que usa el texto de una cláusula, para avisar al autor. */
export async function inspectClauseTags(body: string) {
  const tags = extractTags(body)
  if (tags.length === 0) return { tags: [], known: [], unknown: [] }

  const { supabase, org } = await requireSession()

  const { data } = await supabase
    .from('variables')
    .select('tag')
    .in('tag', tags)
    .or(org ? `org_id.is.null,org_id.eq.${org.id}` : 'org_id.is.null')

  const known = new Set((data ?? []).map((v: { tag: string }) => v.tag))
  return {
    tags,
    known: tags.filter((t) => known.has(t)),
    unknown: tags.filter((t) => !known.has(t)),
  }
}
