'use server'

import { redirect } from 'next/navigation'
import { requireSession } from '@/lib/session'
import { validateRNC } from '@/lib/engine/dominican'

export type Resultado = { ok: boolean; error?: string }

/**
 * Completa el perfil de quien entró con Google.
 *
 * Google nos da nombre y correo. No nos dice si quien entra es una
 * persona o una empresa, ni cuándo nació. Esta acción recoge eso una
 * sola vez.
 *
 * Marca `perfil_completado` PASE LO QUE PASE con la fecha: si no se
 * marcara al saltar, a quien decide no dar su cumpleaños se le
 * preguntaría en cada visita, que es como se consigue que alguien
 * abandone una herramienta que por lo demás le gusta.
 */
export async function completarPerfil(formData: FormData): Promise<Resultado> {
  const { supabase, user } = await requireSession()

  const esEmpresa = String(formData.get('tipo_cuenta') ?? 'PERSONA').toUpperCase() === 'EMPRESA'

  const cambios: Record<string, unknown> = {
    tipo_cuenta: esEmpresa ? 'EMPRESA' : 'PERSONA',
    perfil_completado: true,
  }

  if (esEmpresa) {
    const razon = String(formData.get('razon_social') ?? '').trim()
    if (!razon) return { ok: false, error: 'Falta la razón social.' }

    const rnc = validateRNC(String(formData.get('rnc') ?? ''))
    if (!rnc.isValid) return { ok: false, error: rnc.error ?? 'El RNC no parece válido.' }

    cambios.razon_social = razon
    cambios.rnc = rnc.clean
    // Una empresa no tiene cumpleaños, y la base lo impide. Si alguien
    // llega aquí con una fecha guardada de antes, se limpia.
    cambios.fecha_nacimiento = null
  } else {
    const fecha = String(formData.get('fecha_nacimiento') ?? '').trim()
    cambios.fecha_nacimiento = fecha || null
    cambios.razon_social = null
    cambios.rnc = null
  }

  const { error } = await supabase.from('profiles').update(cambios).eq('id', user.id)

  if (error) {
    console.error('[bienvenida] no se pudo completar el perfil:', error.message)
    return { ok: false, error: 'No pudimos guardarlo. Inténtalo otra vez.' }
  }

  redirect('/app/dashboard')
}

/** Saltar: se marca completado igual, para no volver a preguntar. */
export async function saltarPerfil() {
  const { supabase, user } = await requireSession()
  await supabase.from('profiles').update({ perfil_completado: true }).eq('id', user.id)
  redirect('/app/dashboard')
}
