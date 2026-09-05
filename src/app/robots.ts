import type { MetadataRoute } from 'next'
import { getSiteUrlEstatico } from '@/lib/dominio'

/**
 * robots.txt
 *
 * Hasta ahora savedocumentos.com/robots.txt devolvía 404. Sin él, un
 * rastreador no sabe qué puede mirar ni dónde está el sitemap.
 *
 * Lo que se bloquea y lo que NO, que es la parte que se hace mal:
 *
 * - /app/ se bloquea. Es el área privada: sin sesión redirige al login,
 *   así que a un rastreador no le queda nada que ver ahí.
 *
 * - Las pantallas de login, registro y contraseñas NO se bloquean aquí,
 *   aunque tampoco queremos que se indexen. Llevan meta robots noindex
 *   en su propia página, y para que Google haga caso de ese noindex
 *   tiene que poder ENTRAR a leerlo. Bloquearlas en robots.txt
 *   conseguiría lo contrario de lo que se busca: Google no las
 *   rastrearía, no vería el noindex, y podría dejarlas indexadas para
 *   siempre con el resultado feo de "no hay información disponible".
 *
 * robots.txt controla el rastreo. noindex controla la indexación. No
 * son intercambiables.
 */
export default function robots(): MetadataRoute.Robots {
  const base = getSiteUrlEstatico()

  return {
    rules: [
      {
        userAgent: '*',
        allow: '/',
        disallow: ['/app/', '/auth/'],
      },
    ],
    sitemap: `${base}/sitemap.xml`,
    host: base,
  }
}
