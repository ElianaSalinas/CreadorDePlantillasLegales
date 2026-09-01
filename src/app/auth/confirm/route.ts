import { type NextRequest, NextResponse } from 'next/server'
import { type EmailOtpType } from '@supabase/supabase-js'
import { createClient } from '@/utils/supabase/server'
import { getSiteUrl } from '@/lib/siteUrl'

/**
 * Aterrizaje de los enlaces que Supabase envía por correo.
 *
 * Acepta las DOS formas que puede tomar un enlace, a propósito:
 *
 *   1. ?code=...                        cuando la plantilla usa
 *                                       {{ .ConfirmationURL }}, que es lo
 *                                       recomendado: Supabase verifica en
 *                                       su servidor y nos manda aquí con
 *                                       un código que se canjea.
 *
 *   2. ?token_hash=...&type=signup      cuando la plantilla arma la URL a
 *                                       mano con {{ .TokenHash }}.
 *
 * Soportar las dos evita que un cambio de plantilla rompa el registro, y
 * cubre los correos que ya estén en el buzón de alguien cuando se cambie.
 */

/**
 * Lee un parámetro tolerando que el enlace llegue con las entidades HTML
 * sin decodificar. Si un cliente de correo no convierte el &amp; del href,
 * la URL acaba con "?code=X&amp;type=signup" y el parámetro pasa a
 * llamarse "amp;type". Aceptar las dos grafías cuesta una línea.
 */
function leerParam(sp: URLSearchParams, nombre: string): string | null {
  return sp.get(nombre) ?? sp.get(`amp;${nombre}`)
}

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url)

  // El origin de request.url es la dirección interna del contenedor
  // (0.0.0.0:3000) detrás del proxy de Railway, así que los redirects
  // acababan en una dirección inalcanzable.
  const base = await getSiteUrl()

  const irALogin = (mensaje: string) =>
    NextResponse.redirect(`${base}/login?message=${encodeURIComponent(mensaje)}`)

  // Supabase puede devolver el error en la propia URL, por ejemplo cuando
  // el enlace caducó antes de abrirlo.
  const errorUrl = leerParam(searchParams, 'error_description') ?? leerParam(searchParams, 'error')
  if (errorUrl) {
    console.error('[auth/confirm] Supabase devolvió error en la URL:', errorUrl)
    const caducado = /expired|invalid/i.test(errorUrl)
    return irALogin(
      caducado
        ? 'El enlace expiró o ya fue usado. Solicita uno nuevo.'
        : 'No se pudo validar el enlace del correo.'
    )
  }

  const code = leerParam(searchParams, 'code')
  const token_hash = leerParam(searchParams, 'token_hash')
  const type = leerParam(searchParams, 'type') as EmailOtpType | null
  const next = leerParam(searchParams, 'next')

  // Solo se permiten rutas internas: evita que un enlace manipulado
  // rebote al usuario hacia un dominio ajeno.
  const safeNext = next && next.startsWith('/') && !next.startsWith('//') ? next : null

  const supabase = await createClient()
  let fallo: string | null = null

  if (code) {
    const { error } = await supabase.auth.exchangeCodeForSession(code)
    fallo = error?.message ?? null
  } else if (token_hash && type) {
    const { error } = await supabase.auth.verifyOtp({ type, token_hash })
    fallo = error?.message ?? null
  } else {
    // Sin código ni token no hay nada que canjear. Se deja constancia de
    // qué llegó -sin valores- para poder diagnosticarlo desde los logs.
    console.error(
      '[auth/confirm] enlace incompleto. Parámetros recibidos:',
      [...searchParams.keys()].join(', ') || '(ninguno)'
    )
    return irALogin('El enlace del correo no es válido.')
  }

  if (fallo) {
    console.error('[auth/confirm] no se pudo canjear el enlace:', fallo)
    const caducado =
      fallo.toLowerCase().includes('expired') ||
      fallo.toLowerCase().includes('invalid') ||
      fallo.includes('403')
    return irALogin(
      caducado
        ? 'El enlace expiró o ya fue usado. Solicita uno nuevo.'
        : 'No se pudo validar el enlace del correo.'
    )
  }

  if (safeNext) {
    return NextResponse.redirect(`${base}${safeNext}`)
  }

  if (type === 'recovery') {
    return NextResponse.redirect(`${base}/reset-password`)
  }

  return NextResponse.redirect(`${base}/app/dashboard`)
}
