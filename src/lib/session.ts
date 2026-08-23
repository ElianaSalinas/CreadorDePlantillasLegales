import { redirect } from 'next/navigation'
import { createClient } from '@/utils/supabase/server'

export type Profile = {
  id: string
  email: string
  first_name: string | null
  last_name: string | null
  phone: string | null
  prof_role: 'ABOGADO' | 'NOTARIO' | 'AMBOS' | null
  card_number: string | null
  is_verified: boolean
  is_active: boolean
  created_at: string
}

export type Organization = {
  id: string
  owner_id: string
  name: string
  sub_status: 'FREE' | 'PREMIUM' | 'CANCELLED'
  docs_generated_count: number
  free_limit: number
  vault_limit: number
  vault_used_count: number
  require_approval: boolean
  is_firm: boolean
  created_at: string
}

export type AdminRow = { id: string; admin_role: string } | null

/**
 * Contexto que casi toda pantalla de /app necesita.
 * Redirige a /login si no hay sesión, y expulsa a los usuarios desactivados.
 */
export async function requireSession() {
  const supabase = await createClient()

  const {
    data: { user },
    error,
  } = await supabase.auth.getUser()

  if (error || !user) {
    redirect('/login')
  }

  const { data: profile } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', user.id)
    .maybeSingle<Profile>()

  if (profile && profile.is_active === false) {
    await supabase.auth.signOut()
    redirect('/login?message=' + encodeURIComponent('Tu cuenta está desactivada. Contacta al administrador.'))
  }

  // Organización propia (owner) o aquella en la que es miembro.
  const { data: ownedOrg } = await supabase
    .from('organizations')
    .select('*')
    .eq('owner_id', user.id)
    .maybeSingle<Organization>()

  let org: Organization | null = ownedOrg ?? null
  let memberRole: 'OWNER' | 'PARALEGAL' | 'ASSISTANT' | null = ownedOrg ? 'OWNER' : null

  if (!org) {
    const { data: membership } = await supabase
      .from('org_members')
      .select('role, organizations(*)')
      .eq('user_id', user.id)
      .limit(1)
      .maybeSingle<{ role: 'OWNER' | 'PARALEGAL' | 'ASSISTANT'; organizations: Organization }>()

    if (membership?.organizations) {
      org = membership.organizations
      memberRole = membership.role
    }
  }

  const { data: admin } = await supabase
    .from('save_admins')
    .select('id, admin_role')
    .eq('id', user.id)
    .maybeSingle<{ id: string; admin_role: string }>()

  return {
    supabase,
    user,
    profile: profile ?? null,
    org,
    memberRole,
    isAdmin: Boolean(admin),
    adminRole: admin?.admin_role ?? null,
  }
}

export function displayName(profile: Profile | null, fallback?: string | null) {
  if (!profile) return fallback ?? 'Usuario'
  const full = [profile.first_name, profile.last_name].filter(Boolean).join(' ').trim()
  return full || profile.email || fallback || 'Usuario'
}

export { PROF_ROLE_LABEL, MEMBER_ROLE_LABEL } from './labels'
