import { redirect } from 'next/navigation'
import { createClient } from '@/utils/supabase/server'
import { resolvePermissions, type MemberPermissions } from './permissions'

export type Profile = {
  id: string
  email: string
  first_name: string | null
  last_name: string | null
  phone: string | null
  prof_role: 'ABOGADO' | 'NOTARIO' | 'AMBOS' | 'INDEPENDIENTE' | 'PARALEGAL' | null
  card_number: string | null
  is_verified: boolean
  is_active: boolean
  created_at: string
}

export type Organization = {
  id: string
  owner_id: string
  name: string
  sub_status: 'FREE' | 'PREMIUM' | 'BUSINESS' | 'CANCELLED'
  docs_generated_count: number
  free_limit: number
  vault_limit: number
  vault_used_count: number
  require_approval: boolean
  is_firm: boolean
  included_members: number
  seat_price_dop: number
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

  // Qué despacho es el activo.
  //
  // El trigger handle_new_user le crea un espacio propio a TODO el que
  // se registra, así que un paralegal siempre tendrá uno. Si además lo
  // invitaron a un despacho ajeno, es ese el que tiene que ver: de lo
  // contrario entraría a su espacio vacío y no vería ni un caso del
  // despacho al que pertenece.
  //
  // Regla: gana el despacho del que NO eres dueño. El titular de un
  // despacho solo es miembro del suyo, así que para él no cambia nada.
  //
  // Pendiente de la Fase 1: un selector para quien pertenezca a más de
  // un despacho. Hasta entonces se elige el más antiguo, que es estable
  // entre peticiones.
  const { data: memberships } = await supabase
    .from('org_members')
    .select('role, permissions, created_at, organizations(*)')
    .eq('user_id', user.id)
    .order('created_at', { ascending: true })
    .returns<
      Array<{
        role: 'OWNER' | 'PARALEGAL' | 'ASSISTANT'
        permissions: unknown
        created_at: string
        organizations: Organization | null
      }>
    >()

  const conOrg = (memberships ?? []).filter((m) => m.organizations)
  const elegida =
    conOrg.find((m) => m.organizations!.owner_id !== user.id) ?? conOrg[0] ?? null

  let org: Organization | null = elegida?.organizations ?? null
  let memberRole: 'OWNER' | 'PARALEGAL' | 'ASSISTANT' | null = elegida?.role ?? null
  let storedPermissions: unknown = elegida?.permissions ?? null

  // Red de seguridad: si por lo que sea no hay fila en org_members pero
  // sí es dueño de un despacho, no lo dejamos sin espacio de trabajo.
  if (!org) {
    const { data: ownedOrg } = await supabase
      .from('organizations')
      .select('*')
      .eq('owner_id', user.id)
      .maybeSingle<Organization>()

    if (ownedOrg) {
      org = ownedOrg
      memberRole = 'OWNER'
    }
  }

  // Dos permisos que no dependen del despacho: administrar la plataforma
  // y revisar el catálogo maestro. Son cosas distintas a propósito —
  // revisar textos legales no debe traer consigo el panel de cuentas—
  // así que se consultan por separado.
  const [{ data: admin }, { data: revisor }] = await Promise.all([
    supabase
      .from('save_admins')
      .select('id, admin_role')
      .eq('id', user.id)
      .maybeSingle<{ id: string; admin_role: string }>(),
    supabase
      .from('revisores_contenido')
      .select('email')
      .eq('user_id', user.id)
      .eq('activo', true)
      .maybeSingle<{ email: string }>(),
  ])

  // El titular lo puede todo; el resto parte de su rol y encima se
  // aplica lo que el titular haya marcado a mano.
  const permissions: MemberPermissions = resolvePermissions(memberRole, storedPermissions)

  return {
    supabase,
    user,
    profile: profile ?? null,
    org,
    memberRole,
    permissions,
    isAdmin: Boolean(admin),
    adminRole: admin?.admin_role ?? null,
    esRevisor: Boolean(revisor),
  }
}

export function displayName(profile: Profile | null, fallback?: string | null) {
  if (!profile) return fallback ?? 'Usuario'
  const full = [profile.first_name, profile.last_name].filter(Boolean).join(' ').trim()
  return full || profile.email || fallback || 'Usuario'
}

export { PROF_ROLE_LABEL, MEMBER_ROLE_LABEL } from './labels'
