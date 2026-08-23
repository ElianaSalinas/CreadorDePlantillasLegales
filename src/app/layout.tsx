import type { Metadata } from 'next'
import '../index.css'

export const metadata: Metadata = {
  title: {
    default: 'Save Documentos',
    template: '%s · Save Documentos',
  },
  description:
    'Plataforma de redacción y gestión documental para abogados y notarios en República Dominicana.',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="es" className="light" suppressHydrationWarning>
      <body suppressHydrationWarning>{children}</body>
    </html>
  )
}
