import type { MetadataRoute } from 'next'
import { getSiteUrlEstatico } from '@/lib/siteUrl'

/**
 * sitemap.xml
 *
 * Solo va lo que es indexable de verdad. Hoy eso es una sola URL: la
 * portada. No es un descuido de este archivo — es que el sitio público
 * consta de una página. Las de login, registro y contraseñas llevan
 * noindex y no pintan nada aquí; /app es privado.
 *
 * Cuando existan las páginas de categoría y de plantilla, se añaden
 * leyéndolas de la base de datos: solo las plantillas maestras
 * PUBLISHED, que son las únicas que un visitante puede llegar a ver.
 * Mientras tanto, un sitemap corto y cierto vale más que uno largo con
 * URLs que devuelven 404 o que están bloqueadas.
 */
export default function sitemap(): MetadataRoute.Sitemap {
  const base = getSiteUrlEstatico()

  return [
    {
      url: base,
      lastModified: new Date(),
      changeFrequency: 'weekly',
      priority: 1,
    },
  ]
}
