import { type NextRequest, NextResponse } from 'next/server'
import { type EmailOtpType } from '@supabase/supabase-js'
import { createClient } from '@/utils/supabase/server'
import { getSiteUrl } from '@/lib/siteUrl'

/**
 * Aterrizaje de los enlaces que Supabase envía por correo.
 *
 * Las plantillas de correo deben apuntar aquí con el token:
 *   {{ .SiteURL }}/auth/confirm?token_hash={{ .TokenHash }}&type=signup
 *
 * Aquí se canjea ese token por una sesión real y se redirige a destino.
 */

/**
 * Lee un parámetro tolerando que el enlace llegue con las entidades HTML
 * sin decodificar.
 *
 * Cuando un cliente de correo no decodifica el &amp; del href, la URL
 * acaba con "?token_hash=X&amp;type=signup" y entonces el parámetro no se
 * llama "type" sino "amp;type". El usuario ve "el enlace no es válido" y
 * no hay forma de que adivine por qué. Aceptar las dos grafías cuesta una
 * línea y evita ese callejón.
 */
function leerParam(sp: URLSearchParams, nombre: string): string | null {
  return sp.get(nombre) ?? sp.get(`amp;${nombre}`)
}

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url)

  // El origin de request.url es la dirección interna del contenedor
  // (0.0.0.0:3000) cuando se está detrás del proxy de Railway, así que
  // los redirects acababan en una dirección a la que no se puede llegar.
  const base = await getSiteUrl()

  const token_hash = leerParam(searchParams, 'token_hash')
  const type = leerParam(searchParams, 'type') as EmailOtpType | null
  const next = leerParam(searchParams, 'next')

  // Solo se permiten rutas internas: evita que un enlace manipulado
  // rebote al usuario hacia un dominio ajeno.
  const safeNext = next && next.startsWith('/') && !next.startsWith('//') ? next : null

  if (!token_hash || !type) {
    // Sin el token no hay nada que canjear. Se deja constancia de qué
    // llegó -sin el valor del token- para poder diagnosticarlo desde los
    // logs en vez de adivinando.
    console.error(
      '[auth/confirm] enlace incompleto. Parámetros recibidos:',
      [...searchParams.keys()].join(', ') || '(ninguno)',
      '| token_hash presente:', Boolean(token_hash),
      '| type:', type ?? '(ausente)'
    )
    return NextResponse.redirect(
      `${base}/login?message=${encodeURIComponent('El enlace del correo no es válido.')}`
    )
  }

  const supabase = await createClient()
  const { error } = await supabase.auth.verifyOtp({ type, token_hash })

  if (error) {
    console.error('[auth/confirm] verifyOtp falló:', error.message)
    const reason =
      error.message.toLowerCase().includes('expired') || error.message.includes('403')
        ? 'El enlace expiró o ya fue usado. Solicita uno nuevo.'
        : 'No se pudo validar el enlace del correo.'
    return NextResponse.redirect(`${base}/login?message=${encodeURIComponent(reason)}`)
  }

  if (safeNext) {
    return NextResponse.redirect(`${base}${safeNext}`)
  }

  if (type === 'recovery') {
    return NextResponse.redirect(`${base}/reset-password`)
  }

  return NextResponse.redirect(`${base}/app/dashboard`)
}
