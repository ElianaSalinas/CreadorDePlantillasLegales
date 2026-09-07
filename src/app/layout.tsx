import type { Metadata } from 'next'
import '../index.css'
import { OG_IMAGE } from '@/lib/og'

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
    <html lang="es-DO" className="light" suppressHydrationWarning>
      <head>
        {/* Las fuentes de marca que index.css da por sentadas. Sin esto,
            toda la app cae a Georgia y a la tipografía del sistema. */}
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link
          rel="stylesheet"
          href="https://fonts.googleapis.com/css2?family=Libre+Caslon+Text:ital,wght@0,400;0,700;1,400&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
        />
      </head>
      <body suppressHydrationWarning>{children}</body>
    </html>
  )
}
