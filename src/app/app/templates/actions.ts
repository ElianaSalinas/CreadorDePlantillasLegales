'use server'

import { revalidatePath } from 'next/cache'
import { requireSession } from '@/lib/session'
import { logAudit } from '@/lib/audit'

export type ActionResult = { ok: boolean; error?: string }

const NO_PERMISSION =
  'No tienes permiso para gestionar las plantillas del despacho. Pídeselo al titular.'

function readForm(formData: FormData) {
  return {
    title: String(formData.get('title') ?? '').trim(),
    category: String(formData.get('category') ?? '').trim(),
    body: String(formData.get('body') ?? ''),
  }
}

export async function createTemplate(formData: FormData): Promise<ActionResult> {
  const { supabase, user, org, permissions } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }
  if (!permissions.templates) return { ok: false, error: NO_PERMISSION }

  const { title, category, body } = readForm(formData)
  if (!title) return { ok: false, error: 'El título es obligatorio.' }
  if (!category) return { ok: false, error: 'Selecciona una categoría.' }

  const { error } = await supabase.from('templates').insert({
    org_id: org.id,
    title,
    category,
    is_master: false,
    version: '1.0',
    content: { body },
  })

  if (error) return { ok: false, error: error.message }

  await logAudit(supabase, {
    orgId: org.id,
    userId: user.id,
    action: 'TEMPLATE_CREATED',
    description: `Plantilla creada: ${title}`,
  })

  revalidatePath('/app/templates')
  return { ok: true }
}

export async function updateTemplate(id: string, formData: FormData): Promise<ActionResult> {
  const { supabase, user, org, permissions } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }
  if (!permissions.templates) return { ok: false, error: NO_PERMISSION }

  const { title, category, body } = readForm(formData)
  if (!title) return { ok: false, error: 'El título es obligatorio.' }

  const { error } = await supabase
    .from('templates')
    .update({ title, category, content: { body } })
    .eq('id', id)

  if (error) return { ok: false, error: error.message }

  await logAudit(supabase, {
    orgId: org.id,
    userId: user.id,
    action: 'TEMPLATE_EDITED',
    description: `Plantilla editada: ${title}`,
  })

  revalidatePath('/app/templates')
  return { ok: true }
}

export async function deleteTemplate(id: string): Promise<ActionResult> {
  const { supabase, user, org, permissions } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }
  if (!permissions.templates) return { ok: false, error: NO_PERMISSION }

  const { data: tpl } = await supabase.from('templates').select('title').eq('id', id).maybeSingle()

  const { error } = await supabase.from('templates').delete().eq('id', id)
  if (error) return { ok: false, error: error.message }

  await logAudit(supabase, {
    orgId: org.id,
    userId: user.id,
    action: 'TEMPLATE_DELETED',
    description: `Plantilla eliminada: ${tpl?.title ?? id}`,
  })

  revalidatePath('/app/templates')
  return { ok: true }
}

/** Copia una plantilla maestra de SA&VE al espacio del usuario para poder editarla. */
export async function duplicateTemplate(id: string): Promise<ActionResult> {
  const { supabase, user, org, permissions } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }
  if (!permissions.templates) return { ok: false, error: NO_PERMISSION }

  const { data: source, error: readError } = await supabase
    .from('templates')
    .select('title, category, content')
    .eq('id', id)
    .maybeSingle()

  if (readError) return { ok: false, error: readError.message }
  if (!source) return { ok: false, error: 'No se encontró la plantilla.' }

  const { error } = await supabase.from('templates').insert({
    org_id: org.id,
    title: `${source.title} (copia)`,
    category: source.category,
    is_master: false,
    version: '1.0',
    content: source.content,
  })

  if (error) return { ok: false, error: error.message }

  await logAudit(supabase, {
    orgId: org.id,
    userId: user.id,
    action: 'TEMPLATE_DUPLICATED',
    description: `Copiada a mi despacho: ${source.title}`,
  })

  revalidatePath('/app/templates')
  return { ok: true }
}
