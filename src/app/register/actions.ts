'use server'

import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
import { cookies } from 'next/headers'
import { createClient } from '@/utils/supabase/server'
import { getSiteUrl } from '@/lib/siteUrl'
import { PROF_ROLE_OPTIONS } from '@/lib/labels'
import { mensajeDeAuth } from '@/lib/mensajes-auth'

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
    // El texto de Supabase va al log, no a la cara del usuario.
    console.error('[register] signUp fallo:', error.message)
    redirect('/register?message=' + encodeURIComponent(mensajeDeAuth(error.message)))
  }

  // La pantalla siguiente enseña a que direccion salio el correo, que es
  // lo que resuelve el 90% de los "no me llego": una erratita al teclear.
  // Va en cookie y no en la URL: un query param acaba en los logs, en el
  // historial y en la cabecera Referer.
  const cookieStore = await cookies()
  cookieStore.set('save_registro_correo', data.email, {
    httpOnly: true,
    sameSite: 'lax',
    secure: process.env.NODE_ENV === 'production',
    path: '/register',
    maxAge: 60 * 15,
  })

  revalidatePath('/', 'layout')
  redirect('/register/revisa-tu-correo')
}
