import { createServerClient, type CookieOptions } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'

/**
 * Refresca la cookie de sesión de Supabase antes de que la página la lea.
 *
 * SE LLAMA `proxy` Y NO `middleware` porque Next 16 renombró el archivo.
 * No es cosmético: el runtime hace
 *     (isProxy ? mod.proxy : mod.middleware) || mod.default
 * así que en `src/proxy.ts` una función llamada `middleware` no la
 * encuentra nadie y la app arranca sin refrescar ninguna sesión.
 */
export async function proxy(request: NextRequest) {
  let response = NextResponse.next({
    request: {
      headers: request.headers,
    },
  })

  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
  const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY

  // Si faltan las variables, no tumbamos la app: seguimos sin sesión.
  if (!supabaseUrl || !supabaseKey) {
    console.warn('[proxy] Faltan NEXT_PUBLIC_SUPABASE_URL / ANON_KEY')
    return response
  }

  try {
    const supabase = createServerClient(supabaseUrl, supabaseKey, {
      cookies: {
        get(name: string) {
          return request.cookies.get(name)?.value
        },
        set(name: string, value: string, options: CookieOptions) {
          request.cookies.set({ name, value, ...options })
          response = NextResponse.next({
            request: { headers: request.headers },
          })
          response.cookies.set({ name, value, ...options })
        },
        remove(name: string, options: CookieOptions) {
          request.cookies.set({ name, value: '', ...options })
          response = NextResponse.next({
            request: { headers: request.headers },
          })
          response.cookies.set({ name, value: '', ...options })
        },
      },
    })

    await supabase.auth.getUser()
  } catch (err) {
    // Nunca dejar que un fallo de red con Supabase devuelva 500 en TODA la app
    console.error('[proxy] Error refrescando sesión Supabase:', err)
  }

  return response
}

/**
 * DÓNDE corre esto, y por qué importa tanto.
 *
 * Antes el matcher era una exclusión: todo menos los archivos estáticos.
 * Eso significaba que la portada, /precios, /terminos, /quienes-somos,
 * robots.txt y sitemap.xml pagaban una llamada de red a Supabase
 * —`getUser()`— en CADA petición, para preguntar por una sesión que un
 * visitante anónimo no tiene. Latencia pura, cobrada justo en las
 * páginas donde va a aterrizar el tráfico de Google.
 *
 * Ahora es una lista blanca: solo las rutas que leen la sesión en el
 * servidor. Si mañana se añade una zona privada nueva hay que apuntarla
 * aquí, y ese olvido se nota enseguida porque la sesión deja de
 * refrescarse. Al revés, una exclusión que se olvida no avisa nunca:
 * solo cuesta milisegundos en silencio, para siempre.
 */
export const config = {
  matcher: [
    '/app/:path*',
    '/auth/:path*',
    '/login',
    '/register',
    '/register/:path*',
    '/forgot-password',
    '/reset-password',
    '/definir-password',
  ],
}
