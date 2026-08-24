import { type NextRequest, NextResponse } from 'next/server'
import { type EmailOtpType } from '@supabase/supabase-js'
import { createClient } from '@/utils/supabase/server'

/**
 * Aterrizaje de los enlaces que Supabase envía por correo.
 *
 * Las plantillas de correo deben apuntar aquí con el token:
 *   {{ .SiteURL }}/auth/confirm?token_hash={{ .TokenHash }}&type=signup
 *
 * Aquí se canjea ese token por una sesión real y se redirige a destino.
 */
export async function GET(request: NextRequest) {
  const { searchParams, origin } = new URL(request.url)

  const token_hash = searchParams.get('token_hash')
  const type = searchParams.get('type') as EmailOtpType | null
  const next = searchParams.get('next')

  // Solo se permiten rutas internas: evita que un enlace manipulado
  // rebote al usuario hacia un dominio ajeno.
  const safeNext = next && next.startsWith('/') && !next.startsWith('//') ? next : null

  if (!token_hash || !type) {
    return NextResponse.redirect(
      `${origin}/login?message=${encodeURIComponent('El enlace del correo no es válido.')}`
    )
  }

  const supabase = await createClient()
  const { error } = await supabase.auth.verifyOtp({ type, token_hash })

  if (error) {
    const reason =
      error.message.toLowerCase().includes('expired') || error.message.includes('403')
        ? 'El enlace expiró o ya fue usado. Solicita uno nuevo.'
        : 'No se pudo validar el enlace del correo.'
    return NextResponse.redirect(`${origin}/login?message=${encodeURIComponent(reason)}`)
  }

  if (safeNext) {
    return NextResponse.redirect(`${origin}${safeNext}`)
  }

  if (type === 'recovery') {
    return NextResponse.redirect(`${origin}/reset-password`)
  }

  return NextResponse.redirect(`${origin}/app/dashboard`)
}
