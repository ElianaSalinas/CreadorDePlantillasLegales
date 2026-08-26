import { headers } from 'next/headers'

/**
 * URL pública del sitio, para construir los enlaces que viajan por correo.
 *
 * Prioriza NEXT_PUBLIC_SITE_URL (dominio real en producción). Si no está,
 * o si lo que trae no es una URL http(s) válida, cae a las cabeceras de la
 * petición, que sirven en local y en las previsualizaciones de Railway.
 *
 * Lo de validar no es paranoia: en producción esta variable llegó a tener
 * un correo electrónico, y emailRedirectTo acabó siendo
 * "savedocumentos@gmail.com/auth/confirm". El registro entero devolvía 500
 * y nada en la interfaz decía por qué. Ahora un valor mal puesto degrada a
 * las cabeceras y deja un aviso en los logs, en vez de romper el alta.
 */
function urlValida(valor: string): string | null {
  try {
    const u = new URL(valor)
    if (u.protocol !== 'http:' && u.protocol !== 'https:') return null
    // Sin barra final, para poder concatenar rutas sin duplicarla.
    return `${u.origin}${u.pathname}`.replace(/\/+$/, '')
  } catch {
    return null
  }
}

export async function getSiteUrl(): Promise<string> {
  const configured = process.env.NEXT_PUBLIC_SITE_URL?.trim()

  if (configured) {
    const limpia = urlValida(configured)
    if (limpia) return limpia

    console.error(
      `[siteUrl] NEXT_PUBLIC_SITE_URL no es una URL http(s) válida: ${JSON.stringify(configured)}. ` +
        'Se usarán las cabeceras de la petición. Corrígela en Railway, por ejemplo https://savedocumentos.com'
    )
  }

  const h = await headers()
  const host = h.get('x-forwarded-host') ?? h.get('host')
  const proto = h.get('x-forwarded-proto') ?? (host?.startsWith('localhost') ? 'http' : 'https')

  if (host) return `${proto}://${host}`

  return 'http://localhost:3000'
}
