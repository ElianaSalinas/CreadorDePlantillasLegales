'use server'

import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
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

  const volver = (mensaje: string) =>
    redirect('/definir-password?message=' + encodeURIComponent(mensaje))

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

  if (error) volver(error.message)

  revalidatePath('/', 'layout')
  redirect('/app/dashboard')
}
