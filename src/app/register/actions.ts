'use server'

import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
import { createClient } from '@/utils/supabase/server'
import { getSiteUrl } from '@/lib/siteUrl'
import { PROF_ROLE_OPTIONS } from '@/lib/labels'

export async function register(formData: FormData) {
  const supabase = await createClient()

  const siteUrl = await getSiteUrl()
  const perfil = String(formData.get('prof_role') ?? '').trim().toUpperCase()

  const data = {
    email: formData.get('email') as string,
    password: formData.get('password') as string,
    options: {
      // Dónde aterriza el enlace del correo de verificación.
      emailRedirectTo: `${siteUrl}/auth/confirm`,
      data: {
        first_name: formData.get('first_name'),
        last_name: formData.get('last_name'),
        // El trigger handle_new_user lee esto. Si llegara algo que no
        // está en la lista, el trigger cae a INDEPENDIENTE, que es el
        // perfil sin facultades: nadie gana permisos por accidente.
        prof_role: PROF_ROLE_OPTIONS.some((o) => o.value === perfil) ? perfil : 'INDEPENDIENTE',
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
