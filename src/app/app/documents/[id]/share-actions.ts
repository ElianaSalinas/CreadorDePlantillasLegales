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

const NO_PUEDE_PRIVACIDAD =
  'Solo quien creó el documento, o el titular del despacho, puede cambiar quién lo ve.'

/**
 * Abre o cierra el candado de un documento.
 *
 * Privado significa: lo ven su autor, el titular del despacho y aquellos
 * con quienes se haya compartido. Visible significa: lo ve todo el
 * despacho, que es como nacen los documentos nuevos.
 *
 * Los repartos NO se borran al abrir el candado. Si mañana vuelve a
 * cerrarse, quien ya lo tenía sigue teniéndolo; borrarlos aquí haría que
 * un clic de más deshiciera en silencio un trabajo de reparto que quizá
 * costó explicar por teléfono.
 */
export async function setDocumentPrivacy(
  documentId: string,
  esPrivado: boolean,
): Promise<ShareResult> {
  const { supabase, user, org } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }

  const { data: doc } = await supabase
    .from('documents')
    .select('id, title, creator_id, org_id, es_privado')
    .eq('id', documentId)
    .maybeSingle()

  if (!doc) return { ok: false, error: 'No se encontró el documento.' }
  if (doc.creator_id !== user.id && org.owner_id !== user.id) {
    return { ok: false, error: NO_PUEDE_PRIVACIDAD }
  }
  if (doc.es_privado === esPrivado) {
    return { ok: true, notice: esPrivado ? 'Ya era privado.' : 'Ya lo veía el despacho.' }
  }

  const { error } = await supabase
    .from('documents')
    .update({ es_privado: esPrivado })
    .eq('id', documentId)

  if (error) {
    console.error('[privacidad] no se pudo cambiar es_privado:', error.message)
    return { ok: false, error: 'No se pudo cambiar quién ve el documento. Inténtalo otra vez.' }
  }

  await logAudit(supabase, {
    orgId: doc.org_id,
    userId: user.id,
    documentId,
    action: esPrivado ? 'DOCUMENT_SET_PRIVATE' : 'DOCUMENT_SET_VISIBLE',
    description: esPrivado
      ? `"${doc.title}" pasa a privado.`
      : `"${doc.title}" pasa a visible para el despacho.`,
  })

  revalidatePath(`/app/documents/${documentId}`)
  revalidatePath('/app/documents')

  return {
    ok: true,
    notice: esPrivado
      ? 'Ahora es privado. Solo lo ves tú, el titular y quien tenga acceso.'
      : 'Ahora lo ve todo tu despacho.',
  }
}
