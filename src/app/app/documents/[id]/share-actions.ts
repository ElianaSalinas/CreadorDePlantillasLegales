'use server'

import { revalidatePath } from 'next/cache'
import { requireSession } from '@/lib/session'
import { logAudit } from '@/lib/audit'

export type ShareResult = { ok: boolean; error?: string; notice?: string }

const NO_PUEDE =
  'Solo quien creó el documento, o el titular del despacho, puede compartirlo.'

/**
 * Comparte un documento con otro miembro del despacho.
 *
 * Quién puede: el creador y el titular. Quien recibió un documento
 * compartido NO puede repartirlo a su vez; si pudiera, quien lo creó
 * perdería el control de quién lo ve. Eso lo impone también la política
 * de la base de datos, no solo esta comprobación.
 */
export async function shareDocument(documentId: string, userId: string): Promise<ShareResult> {
  const { supabase, user, org } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }

  const { data: doc } = await supabase
    .from('documents')
    .select('id, title, creator_id, org_id')
    .eq('id', documentId)
    .maybeSingle()

  if (!doc) return { ok: false, error: 'No se encontró el documento.' }
  if (doc.creator_id !== user.id && org.owner_id !== user.id) {
    return { ok: false, error: NO_PUEDE }
  }
  if (userId === user.id) return { ok: false, error: 'Ese documento ya es tuyo.' }

  // Solo con gente del mismo despacho.
  const { data: companero } = await supabase
    .from('org_members')
    .select('user_id, profiles:user_id(first_name, last_name, email)')
    .eq('org_id', doc.org_id)
    .eq('user_id', userId)
    .maybeSingle<{
      user_id: string
      profiles: { first_name: string | null; last_name: string | null; email: string } | null
    }>()

  if (!companero) return { ok: false, error: 'Esa persona no pertenece a tu despacho.' }

  const nombre =
    [companero.profiles?.first_name, companero.profiles?.last_name].filter(Boolean).join(' ').trim() ||
    companero.profiles?.email ||
    'esa persona'

  const { error } = await supabase
    .from('document_shares')
    .insert({ document_id: documentId, user_id: userId, shared_by: user.id })

  // Compartir dos veces con la misma persona no es un error que merezca
  // asustar a nadie: el resultado ya es el que se buscaba.
  if (error && !error.message.toLowerCase().includes('duplicate')) {
    return { ok: false, error: error.message }
  }

  await logAudit(supabase, {
    orgId: doc.org_id,
    userId: user.id,
    documentId,
    action: 'DOCUMENT_SHARED',
    description: `"${doc.title}" compartido con ${nombre}.`,
  })

  revalidatePath(`/app/documents/${documentId}`)
  return { ok: true, notice: `Compartido con ${nombre}.` }
}

/** Retira el acceso de alguien a un documento. */
export async function unshareDocument(documentId: string, userId: string): Promise<ShareResult> {
  const { supabase, user, org } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }

  const { data: doc } = await supabase
    .from('documents')
    .select('id, title, creator_id, org_id')
    .eq('id', documentId)
    .maybeSingle()

  if (!doc) return { ok: false, error: 'No se encontró el documento.' }
  if (doc.creator_id !== user.id && org.owner_id !== user.id) {
    return { ok: false, error: NO_PUEDE }
  }

  const { error } = await supabase
    .from('document_shares')
    .delete()
    .eq('document_id', documentId)
    .eq('user_id', userId)

  if (error) return { ok: false, error: error.message }

  await logAudit(supabase, {
    orgId: doc.org_id,
    userId: user.id,
    documentId,
    action: 'DOCUMENT_UNSHARED',
    description: `Acceso retirado a "${doc.title}".`,
  })

  revalidatePath(`/app/documents/${documentId}`)
  return { ok: true, notice: 'Acceso retirado.' }
}
