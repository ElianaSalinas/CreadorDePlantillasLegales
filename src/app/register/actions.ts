'use server'

import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
import { createClient } from '@/utils/supabase/server'
import { getSiteUrl } from '@/lib/siteUrl'

export async function register(formData: FormData) {
  const supabase = await createClient()

  const siteUrl = await getSiteUrl()

  const data = {
    email: formData.get('email') as string,
    password: formData.get('password') as string,
    options: {
      // Dónde aterriza el enlace del correo de verificación.
      emailRedirectTo: `${siteUrl}/auth/confirm`,
      data: {
        first_name: formData.get('first_name'),
        last_name: formData.get('last_name'),
        is_lawyer: formData.get('is_lawyer') === 'on',
        is_notary: formData.get('is_notary') === 'on',
      }
    }
  }

  const { error } = await supabase.auth.signUp(data)

  if (error) {
    redirect('/register?message=' + encodeURIComponent(error.message))
  }

  revalidatePath('/', 'layout')
  redirect('/login?message=Revisa tu correo para verificar tu cuenta')
}
