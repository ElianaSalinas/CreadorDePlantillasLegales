/**
 * El dominio del sitio, sin depender de la petición.
 *
 * Vive en su propio archivo, y esto NO es una manía de orden.
 *
 * robots.ts y sitemap.ts son rutas estáticas: Next las genera durante el
 * build, cuando todavía no existe ninguna petición. Si importan —aunque
 * sea de rebote— un módulo que hace `import { headers } from 'next/headers'`,
 * el build revienta o las convierte en dinámicas. Y eso fue exactamente lo
 * que pasó: robots.txt y sitemap.xml seguían devolviendo 404 en producción
 * con el código ya subido, porque los dos colgaban de lib/siteUrl.ts, que
 * sí lee cabeceras.
 *
 * Aquí no se importa nada de Next, a propósito. Que siga así.
 */

export const DOMINIO_CANONICO = 'https://savedocumentos.com'

/**
 * Valida que un valor sea una URL http(s) y la devuelve sin barra final.
 *
 * Validar no es paranoia: en producción NEXT_PUBLIC_SITE_URL llegó a
 * contener un correo electrónico, y el registro entero devolvía 500 sin
 * que nada en la interfaz dijera por qué.
 */
export function urlValida(valor: string): string | null {
  try {
    const u = new URL(valor)
    if (u.protocol !== 'http:' && u.protocol !== 'https:') return null
    return `${u.origin}${u.pathname}`.replace(/\/+$/, '')
  } catch {
    return null
  }
}

/**
 * URL del sitio para lo que se genera en el build: robots.txt, sitemap.xml
 * y las URL canónicas. Da igual qué visita lo pida — son ficheros del sitio
 * entero, no de una petición concreta.
 */
export function getSiteUrlEstatico(): string {
  const configurada = process.env.NEXT_PUBLIC_SITE_URL?.trim()
  if (configurada) {
    const limpia = urlValida(configurada)
    if (limpia) return limpia
  }
  return DOMINIO_CANONICO
}
