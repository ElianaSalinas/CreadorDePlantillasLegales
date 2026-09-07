import type { MetadataRoute } from 'next'
import { getSiteUrlEstatico } from '@/lib/dominio'

/**
 * sitemap.xml
 *
 * Solo va lo que es indexable de verdad. Hoy son cinco: la portada, los
 * precios, el contacto y las dos páginas legales. Las de login, registro
 * y contraseñas llevan noindex y no pintan nada aquí; /app es privado.
 *
 * Las prioridades no son adorno: precios es la página que convierte,
 * contacto la que da confianza, y términos y privacidad tienen que estar
 * indexadas para ser encontrables pero no compiten por tráfico.
 *
 * Cuando existan las páginas de categoría y de plantilla, se añaden
 * leyéndolas de la base de datos: solo las plantillas maestras
 * PUBLISHED, que son las únicas que un visitante puede llegar a ver.
 * Mientras tanto, un sitemap corto y cierto vale más que uno largo con
 * URLs que devuelven 404 o que están bloqueadas.
 */
export default function sitemap(): MetadataRoute.Sitemap {
  const base = getSiteUrlEstatico()
  const ahora = new Date()

  return [
    { url: base, lastModified: ahora, changeFrequency: 'weekly', priority: 1 },
    { url: `${base}/precios`, lastModified: ahora, changeFrequency: 'monthly', priority: 0.8 },
    { url: `${base}/contacto`, lastModified: ahora, changeFrequency: 'yearly', priority: 0.5 },
    { url: `${base}/terminos`, lastModified: ahora, changeFrequency: 'yearly', priority: 0.3 },
    { url: `${base}/privacidad`, lastModified: ahora, changeFrequency: 'yearly', priority: 0.3 },
  ]
}
