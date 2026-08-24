'use server'

import { redirect } from 'next/navigation'
import { createClient } from '@/utils/supabase/server'
import { getSiteUrl } from '@/lib/siteUrl'

export async function requestPasswordReset(formData: FormData) {
  const email = String(formData.get('email') ?? '').trim().toLowerCase()

  if (!email) {
    redirect('/forgot-password?message=' + encodeURIComponent('Escribe tu correo.'))
  }

  const supabase = await createClient()
  const siteUrl = await getSiteUrl()

  const { error } = await supabase.auth.resetPasswordForEmail(email, {
    redirectTo: `${siteUrl}/auth/confirm?next=/reset-password`,
  })

  // No se distingue entre "correo enviado" y "ese correo no existe":
  // decirlo permitiría averiguar qué cuentas están registradas.
  if (error && !error.message.toLowerCase().includes('not found')) {
    redirect('/forgot-password?message=' + encodeURIComponent(error.message))
  }

  redirect('/forgot-password?sent=1')
}
