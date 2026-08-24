'use server'

import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
import { createClient } from '@/utils/supabase/server'

export async function updatePassword(formData: FormData) {
  const password = String(formData.get('password') ?? '')
  const confirm = String(formData.get('confirm_password') ?? '')

  if (password.length < 6) {
    redirect(
      '/reset-password?message=' +
        encodeURIComponent('La contraseña debe tener al menos 6 caracteres.')
    )
  }

  if (password !== confirm) {
    redirect('/reset-password?message=' + encodeURIComponent('Las contraseñas no coinciden.'))
  }

  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    redirect(
      '/forgot-password?message=' +
        encodeURIComponent('El enlace expiró. Solicita uno nuevo.')
    )
  }

  const { error } = await supabase.auth.updateUser({ password })

  if (error) {
    redirect('/reset-password?message=' + encodeURIComponent(error.message))
  }

  revalidatePath('/', 'layout')
  redirect('/app/dashboard')
}
