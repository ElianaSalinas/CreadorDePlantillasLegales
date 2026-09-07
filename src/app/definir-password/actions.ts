'use server'

import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
import { mensajeDeAuth } from '@/lib/mensajes-auth'
import { createClient } from '@/utils/supabase/server'

/**
 * Contraseña de quien llega invitado a un despacho.
 *
 * Es casi igual que el restablecimiento, pero vive aparte para que los
 * errores vuelvan a ESTA pantalla y no a la de recuperar contraseña, que
 * confundiría a alguien que está entrando por primera vez.
 */
export async function definirPassword(formData: FormData) {
  const password = String(formData.get('password') ?? '')
  const confirm = String(formData.get('confirm_password') ?? '')
  const nombre = String(formData.get('first_name') ?? '').trim()
  const apellido = String(formData.get('last_name') ?? '').trim()

  const volver = (mensaje: string) =>
    redirect('/definir-password?message=' + encodeURIComponent(mensaje))

  if (!nombre || !apellido) volver('Escribe tu nombre y tu apellido.')
  if (password.length < 6) volver('La contraseña debe tener al menos 6 caracteres.')
  if (password !== confirm) volver('Las contraseñas no coinciden.')

  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    redirect(
      '/login?message=' +
        encodeURIComponent('El enlace de la invitación expiró. Pide a tu despacho que te invite de nuevo.')
    )
  }

  const { error } = await supabase.auth.updateUser({ password })

  if (error) {
    console.error('[definir-password] updateUser fallo:', error.message)
    volver(mensajeDeAuth(error.message))
  }

  // El nombre va después de la contraseña, no antes: si esto fallara, la
  // persona ya puede entrar y lo arregla desde Mi Despacho. Al revés,
  // un fallo aquí la dejaría sin poder acceder por un dato cosmético.
  const { error: errorPerfil } = await supabase
    .from('profiles')
    .update({ first_name: nombre, last_name: apellido })
    .eq('id', user.id)

  if (errorPerfil) {
    console.warn('[definir-password] no se pudo guardar el nombre:', errorPerfil.message)
  }

  revalidatePath('/', 'layout')
  redirect('/app/dashboard')
}
