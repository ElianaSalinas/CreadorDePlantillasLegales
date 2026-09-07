/**
 * La imagen que se ve al compartir el enlace.
 *
 * Vive aquí y no suelta en cada página por un motivo concreto: Next NO
 * fusiona el objeto `openGraph`. Si una página declara el suyo, sustituye
 * entero al del layout, imagen incluida.
 *
 * Eso ya pasó. La portada declaraba su propio `openGraph` para afinar el
 * texto, y con ello se cargaba la imagen del layout — justo en la única
 * página que la gente comparte. Se veía en el navegador y no en el
 * código, porque en el código las dos partes eran correctas por separado.
 *
 * Regla: cualquier página que declare `openGraph` mete `images: OG_IMAGE`.
 */
export const OG_IMAGE = [
  {
    url: '/og.png',
    width: 1200,
    height: 630,
    alt: 'SAVE Documentos — Crea documentos. Automatiza tu trabajo.',
  },
]
