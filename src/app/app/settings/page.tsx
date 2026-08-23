import PageHeader from '@/components/ui/PageHeader'
import { requireSession, displayName } from '@/lib/session'
import { hasAdminCredentials } from '@/utils/supabase/admin'
import SettingsClient, { type MemberRow } from './SettingsClient'

export const dynamic = 'force-dynamic'

export default async function SettingsPage() {
  const { supabase, user, profile, org } = await requireSession()

  let members: MemberRow[] = []

  if (org) {
    const { data } = await supabase
      .from('org_members')
      .select('id, user_id, role, profiles(id, email, first_name, last_name, is_active)')
      .eq('org_id', org.id)

    members = (data ?? []).map((m: any) => ({
      id: m.id,
      user_id: m.user_id,
      role: m.role,
      email: m.profiles?.email ?? '—',
      name: displayName(m.profiles, m.profiles?.email),
      is_active: m.profiles?.is_active ?? true,
    }))

    // El titular primero, luego el resto por nombre.
    members.sort((a, b) =>
      a.role === 'OWNER' ? -1 : b.role === 'OWNER' ? 1 : a.name.localeCompare(b.name)
    )
  }

  return (
    <div className="mx-auto max-w-3xl">
      <PageHeader
        title="Mi Despacho"
        subtitle="Tus datos profesionales y la configuración de tu espacio de trabajo."
      />
      <SettingsClient
        profile={profile}
        org={org}
        members={members}
        isOwner={org?.owner_id === user.id}
        hasServiceKey={hasAdminCredentials()}
      />
    </div>
  )
}
