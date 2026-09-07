import type { Metadata } from 'next'
import '../index.css'
import { OG_IMAGE } from '@/lib/og'
import { fuenteSerif, fuenteSans } from '@/lib/fuentes'

export const metadata: Metadata = {
  metadataBase: new URL('https://savedocumentos.com'),
  title: {
    default: 'SAVE Documentos',
    template: '%s · SAVE Documentos',
  },
  description:
    'Creación y automatización de documentos profesionales para abogados, inmobiliarias y empresas en República Dominicana.',
  applicationName: 'SAVE Documentos',

  /**
   * La tarjeta que se ve al compartir el enlace.
   *
   * Sin esto, WhatsApp y LinkedIn ensenaban el enlace pelado. En
   * Republica Dominicana casi todo lo que se comparte pasa por
   * WhatsApp, asi que era la primera impresion de la marca en el sitio
   * donde mas se da, y no habia ninguna.
   *
   * Es un PNG estatico y no una imagen generada en cada peticion: la
   * tarjeta no cambia nunca, y los rastreadores de WhatsApp y X se
   * rinden en un par de segundos. Generarla al vuelo seria pagar ese
   * riesgo a cambio de nada.
   *
   * La URL va absoluta porque los rastreadores no resuelven rutas
   * relativas. `metadataBase` ya esta arriba, que es quien la completa.
   */
  openGraph: {
    type: 'website',
    siteName: 'SAVE Documentos',
    locale: 'es_DO',
    url: 'https://savedocumentos.com',
    title: 'SAVE Documentos — Crea documentos. Automatiza tu trabajo.',
    description:
      'Contratos, actos y poderes listos en minutos. Plantillas inteligentes para abogados, inmobiliarias y empresas en Republica Dominicana.',
    images: OG_IMAGE,
  },

  twitter: {
    card: 'summary_large_image',
    title: 'SAVE Documentos — Crea documentos. Automatiza tu trabajo.',
    description:
      'Contratos, actos y poderes listos en minutos. Hecho para Republica Dominicana.',
    images: ['/og.png'],
  },
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    // Las dos variables CSS que index.css consume. Ya no hay <head> con
    // hojas de terceros: las letras salen del mismo dominio que la página.
    <html
      lang="es-DO"
      className={`light ${fuenteSerif.variable} ${fuenteSans.variable}`}
      suppressHydrationWarning
    >
      <body suppressHydrationWarning>{children}</body>
    </html>
  )
}
