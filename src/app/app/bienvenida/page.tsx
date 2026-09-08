import { redirect } from 'next/navigation'
import { requireSession, displayName } from '@/lib/session'
import BienvenidaClient from './BienvenidaClient'

export const dynamic = 'force-dynamic'

export const metadata = {
  title: 'Bienvenida',
  robots: { index: false, follow: false },
}

export default async function BienvenidaPage() {
  const { profile, user } = await requireSession()

  // Quien ya contestó no vuelve a pasar por aquí, ni escribiendo la URL
  // a mano. Sin esto, la pantalla seria una trampa para quien la tenga
  // guardada en el historial.
  if ((profile as { perfil_completado?: boolean } | null)?.perfil_completado) {
    redirect('/app/dashboard')
  }

  return <BienvenidaClient nombre={displayName(profile, user.email).split(' ')[0]} />
}
