'use server'

import { revalidatePath } from 'next/cache'
import { requireSession } from '@/lib/session'
import { cargarEstadoDelPlan, motivoParaNoSubir } from '@/lib/planes'
import { logAudit } from '@/lib/audit'

import { VAULT_BUCKET } from '@/lib/vault'
const MAX_BYTES = 25 * 1024 * 1024

const ALLOWED = new Set([
  'application/pdf',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'application/msword',
])

export type VaultResult = { ok: boolean; error?: string; url?: string }

const NO_UPLOAD = 'No tienes permiso para subir documentos a la bóveda.'
const NO_DELETE = 'No tienes permiso para eliminar documentos de la bóveda.'

/** Quita acentos y caracteres que Supabase Storage rechaza en las rutas. */
function sanitizeFileName(name: string) {
  const normalized = name
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-zA-Z0-9._-]+/g, '_')
    .replace(/_+/g, '_')
    .replace(/^_|_$/g, '')
  return normalized.slice(0, 120) || 'documento'
}

export async function uploadToVault(formData: FormData): Promise<VaultResult> {
  const { supabase, user, org, permissions } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }
  if (!permissions.vault) return { ok: false, error: NO_UPLOAD }

  const file = formData.get('file')
  if (!(file instanceof File) || file.size === 0) {
    return { ok: false, error: 'Selecciona un archivo.' }
  }

  if (file.size > MAX_BYTES) {
    return { ok: false, error: 'El archivo supera el límite de 25 MB.' }
  }

  if (file.type && !ALLOWED.has(file.type)) {
    return { ok: false, error: 'Solo se aceptan archivos PDF o Word (.doc, .docx).' }
  }

  // El cupo sale del plan, no de la columna de la tabla: en Equipo crece
  // con cada integrante por encima de los incluidos, así que no es un
  // número fijo que se pueda guardar y olvidar.
  const { data: existing, error: listError } = await supabase.storage
    .from(VAULT_BUCKET)
    .list(org.id, { limit: 1000 })

  if (listError) return { ok: false, error: listError.message }

  const used = (existing ?? []).filter((f) => f.id !== null).length

  const estado = await cargarEstadoDelPlan(supabase, org.id)
  const impedimento = motivoParaNoSubir(estado, used)
  if (impedimento) return { ok: false, error: impedimento }

  // Red de seguridad si el estado del plan no se pudo leer: se aplica el
  // límite guardado, que es el comportamiento anterior.
  if (!estado && used >= org.vault_limit) {
    return {
      ok: false,
      error: `Tu bóveda está llena (${used}/${org.vault_limit}). Elimina un documento o solicita ampliar el límite.`,
    }
  }

  const path = `${org.id}/${crypto.randomUUID()}__${sanitizeFileName(file.name)}`

  const { error } = await supabase.storage
    .from(VAULT_BUCKET)
    .upload(path, file, { contentType: file.type || 'application/octet-stream', upsert: false })

  if (error) return { ok: false, error: error.message }

  // La ficha del archivo: quién lo subió y si lo comparte. Nace privado.
  // Si esto fallara, el archivo ya está subido y sin ficha se comportaría
  // como los anteriores a la migración —visible para el despacho—, que es
  // justo lo contrario de lo prometido. Por eso se deshace la subida.
  const { error: errorFicha } = await supabase.from('boveda_archivos').insert({
    ruta: path,
    org_id: org.id,
    subido_por: user.id,
    visible_para_despacho: false,
  })

  if (errorFicha) {
    await supabase.storage.from(VAULT_BUCKET).remove([path])
    return {
      ok: false,
      error:
        'No se pudo registrar el archivo como privado, así que no se subió. Vuelve a intentarlo.',
    }
  }

  await supabase
    .from('organizations')
    .update({ vault_used_count: used + 1 })
    .eq('id', org.id)

  await logAudit(supabase, {
    orgId: org.id,
    userId: user.id,
    action: 'VAULT_UPLOAD',
    description: `Documento subido a la bóveda: ${file.name}`,
  })

  revalidatePath('/app/vault')
  return { ok: true }
}

export async function getVaultDownloadUrl(path: string): Promise<VaultResult> {
  const { supabase, org, permissions } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }
  if (!permissions.vault) return { ok: false, error: 'No tienes acceso a la bóveda.' }
  if (!path.startsWith(`${org.id}/`)) {
    return { ok: false, error: 'No tienes acceso a ese documento.' }
  }

  const { data, error } = await supabase.storage
    .from(VAULT_BUCKET)
    .createSignedUrl(path, 60, { download: true })

  if (error || !data) return { ok: false, error: error?.message ?? 'No se pudo generar el enlace.' }
  return { ok: true, url: data.signedUrl }
}

export async function deleteFromVault(path: string): Promise<VaultResult> {
  const { supabase, user, org, permissions } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }
  if (!permissions.delete) return { ok: false, error: NO_DELETE }
  if (!path.startsWith(`${org.id}/`)) {
    return { ok: false, error: 'No tienes acceso a ese documento.' }
  }

  const { error } = await supabase.storage.from(VAULT_BUCKET).remove([path])
  if (error) return { ok: false, error: error.message }

  // Sin esto quedaría una ficha huérfana que reclamaría la ruta si algún
  // día se subiera otro archivo con el mismo nombre.
  await supabase.from('boveda_archivos').delete().eq('ruta', path)

  const { data: remaining } = await supabase.storage
    .from(VAULT_BUCKET)
    .list(org.id, { limit: 1000 })

  await supabase
    .from('organizations')
    .update({ vault_used_count: (remaining ?? []).filter((f) => f.id !== null).length })
    .eq('id', org.id)

  await logAudit(supabase, {
    orgId: org.id,
    userId: user.id,
    action: 'VAULT_DELETE',
    description: `Documento eliminado de la bóveda: ${path.split('__').slice(1).join('__')}`,
  })

  revalidatePath('/app/vault')
  return { ok: true }
}

/**
 * Compartir un archivo de la bóveda con el despacho, o dejar de hacerlo.
 *
 * Solo su dueño. El titular ve todo lo de su despacho, pero no decide por
 * otro si un archivo suyo se comparte: eso lo impone también la política
 * de la base, no solo esta comprobación.
 */
export async function cambiarVisibilidadArchivo(
  path: string,
  visible: boolean
): Promise<VaultResult> {
  const { supabase, user, org, permissions } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }
  if (!permissions.vault) return { ok: false, error: 'No tienes acceso a la bóveda.' }

  const { data, error } = await supabase
    .from('boveda_archivos')
    .update({ visible_para_despacho: visible })
    .eq('ruta', path)
    .eq('subido_por', user.id)
    .select('ruta')

  if (error) return { ok: false, error: error.message }
  if (!data || data.length === 0) {
    return { ok: false, error: 'Solo quien subió un archivo puede decidir con quién se comparte.' }
  }

  await logAudit(supabase, {
    orgId: org.id,
    userId: user.id,
    action: visible ? 'VAULT_SHARED' : 'VAULT_UNSHARED',
    description: `${visible ? 'Compartido con' : 'Retirado de'} el despacho: ${path.split('__').slice(1).join('__')}`,
  })

  revalidatePath('/app/vault')
  return { ok: true }
}
