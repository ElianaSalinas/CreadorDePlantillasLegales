'use server'

import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
import { cookies } from 'next/headers'
import { createClient } from '@/utils/supabase/server'
import { getSiteUrl } from '@/lib/siteUrl'
import { PROF_ROLE_OPTIONS } from '@/lib/labels'
import { mensajeDeAuth } from '@/lib/mensajes-auth'
import { validateRNC } from '@/lib/engine/dominican'

export async function register(formData: FormData) {
  const supabase = await createClient()

  const siteUrl = await getSiteUrl()
  const perfil = String(formData.get('prof_role') ?? '').trim().toUpperCase()

  const tipoCuenta = String(formData.get('tipo_cuenta') ?? 'PERSONA').toUpperCase()
  const esEmpresa = tipoCuenta === 'EMPRESA'

  // El RNC se valida AQUI y no solo en el navegador. El formulario se
  // puede saltar; esta accion es el unico camino que no.
  let rnc: string | null = null
  let razonSocial: string | null = null
  if (esEmpresa) {
    razonSocial = String(formData.get('razon_social') ?? '').trim()
    if (!razonSocial) {
      redirect('/register?message=' + encodeURIComponent('Falta la razón social de la empresa.'))
    }
    const comprobado = validateRNC(String(formData.get('rnc') ?? ''))
    if (!comprobado.isValid) {
      redirect(
        '/register?message=' +
          encodeURIComponent(comprobado.error ?? 'El RNC no parece válido. Revísalo.'),
      )
    }
    rnc = comprobado.clean
  }

  // Una empresa no tiene cumpleaños. Aunque el campo llegara relleno
  // -formulario manipulado, autocompletado raro- aquí se descarta.
  const fechaNacimiento = esEmpresa
    ? null
    : String(formData.get('fecha_nacimiento') ?? '').trim() || null

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
        tipo_cuenta: esEmpresa ? 'EMPRESA' : 'PERSONA',
        fecha_nacimiento: fechaNacimiento,
        razon_social: razonSocial,
        rnc,
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
