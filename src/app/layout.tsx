import type { Metadata } from 'next'
import '../index.css'

export const metadata: Metadata = {
  metadataBase: new URL('https://savedocumentos.com'),
  title: {
    default: 'SAVE Documentos',
    template: '%s · SAVE Documentos',
  },
  description:
    'Creación y automatización de documentos profesionales para abogados, inmobiliarias y empresas en República Dominicana.',
  applicationName: 'SAVE Documentos',
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
