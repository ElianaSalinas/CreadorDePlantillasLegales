import { headers } from 'next/headers'

/**
 * URL pública del sitio, para construir los enlaces que viajan por correo.
 *
 * Prioriza NEXT_PUBLIC_SITE_URL (dominio real en producción). Si no está,
 * cae a las cabeceras de la petición, que sirven en local y en las
 * previsualizaciones de Railway.
 */
export async function getSiteUrl(): Promise<string> {
  const configured = process.env.NEXT_PUBLIC_SITE_URL?.trim()
  if (configured) return configured.replace(/\/+$/, '')

  const h = await headers()
  const host = h.get('x-forwarded-host') ?? h.get('host')
  const proto = h.get('x-forwarded-proto') ?? (host?.startsWith('localhost') ? 'http' : 'https')

  if (host) return `${proto}://${host}`

  return 'http://localhost:3000'
}
