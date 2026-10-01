'use server'

import { createClient } from '@/utils/supabase/server'
import { redirect } from 'next/navigation'

export async function logout() {
  const supabase = await createClient()
  await supabase.auth.signOut()
  redirect('/login')
}

/**
 * "No ver otra vez" del tutorial de revisión. Se guarda en los metadatos
 * de la propia cuenta (auth.users.raw_user_meta_data), que el usuario
 * puede escribir de sí mismo: sirve en cualquier dispositivo y no hace
 * falta columna ni migración. No da ningún permiso: solo apaga un aviso.
 */
export async function ocultarTutorialRevision(): Promise<{ ok: boolean }> {
  const supabase = await createClient()
  const { error } = await supabase.auth.updateUser({ data: { tutorial_revision_oculto: true } })
  if (error) {
    console.error('[tutorial] no se pudo guardar la preferencia:', error.message)
    return { ok: false }
  }
  return { ok: true }
}
