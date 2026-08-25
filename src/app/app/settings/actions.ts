'use server'

import { revalidatePath } from 'next/cache'
import { requireSession } from '@/lib/session'
import { createAdminClient, hasAdminCredentials } from '@/utils/supabase/admin'
import { logAudit } from '@/lib/audit'
import { planAllowsTeam, roleCanLeadTeam, seatMath, formatDOP } from '@/lib/billing'
import { sanitizePermissions, PERMISSION_LIST } from '@/lib/permissions'

export type SettingsResult = { ok: boolean; error?: string; notice?: string }

const MISSING_KEY =
  'Falta configurar SUPABASE_SERVICE_ROLE_KEY en Railway. Sin esa llave no se pueden gestionar miembros del despacho.'

const NO_TEAM_PLAN =
  'El trabajo en equipo pertenece al plan Equipo, que todavía no está disponible para contratar.'

export async function updateProfile(formData: FormData): Promise<SettingsResult> {
  const { supabase, user } = await requireSession()

  const first_name = String(formData.get('first_name') ?? '').trim()
  const last_name = String(formData.get('last_name') ?? '').trim()
  const phone = String(formData.get('phone') ?? '').trim()
  const card_number = String(formData.get('card_number') ?? '').trim()
  const prof_role = String(formData.get('prof_role') ?? '').trim()

  if (!first_name) return { ok: false, error: 'El nombre es obligatorio.' }

  const { error } = await supabase
    .from('profiles')
    .update({
      first_name,
      last_name: last_name || null,
      phone: phone || null,
      card_number: card_number || null,
      prof_role: prof_role || null,
    })
    .eq('id', user.id)

  if (error) return { ok: false, error: error.message }

  revalidatePath('/app/settings')
  revalidatePath('/app', 'layout')
  return { ok: true, notice: 'Perfil actualizado.' }
}

export async function updateOrganization(formData: FormData): Promise<SettingsResult> {
  const { supabase, user, org, profile } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }
  if (org.owner_id !== user.id) {
    return { ok: false, error: 'Solo el titular del despacho puede cambiar esta configuración.' }
  }

  const name = String(formData.get('name') ?? '').trim()
  const wantsFirm = formData.get('is_firm') === 'on'
  const require_approval = formData.get('require_approval') === 'on'

  if (!name) return { ok: false, error: 'El nombre del despacho es obligatorio.' }

  // El modo despacho depende del plan y del perfil profesional.
  let is_firm = wantsFirm
  if (wantsFirm && !org.is_firm) {
    if (!roleCanLeadTeam(profile?.prof_role)) {
      return {
        ok: false,
        error: 'Solo un abogado o notario puede encabezar un despacho con equipo.',
      }
    }
    if (!planAllowsTeam(org.sub_status)) {
      return { ok: false, error: NO_TEAM_PLAN }
    }
  }

  // Apagar el modo despacho teniendo gente dentro dejaría a esas personas
  // sin sitio, así que se bloquea hasta que el titular las retire.
  if (!wantsFirm && org.is_firm) {
    const { count } = await supabase
      .from('org_members')
      .select('id', { count: 'exact', head: true })
      .eq('org_id', org.id)

    if ((count ?? 1) > 1) {
      return {
        ok: false,
        error: 'Primero retira a los miembros del despacho y luego desactiva el trabajo en equipo.',
      }
    }
    is_firm = false
  }

  const { error } = await supabase
    .from('organizations')
    .update({ name, is_firm, require_approval })
    .eq('id', org.id)

  if (error) return { ok: false, error: error.message }

  await logAudit(supabase, {
    orgId: org.id,
    userId: user.id,
    action: 'ORG_UPDATED',
    description: `Configuración del despacho actualizada (equipo: ${is_firm ? 'activo' : 'inactivo'})`,
  })

  revalidatePath('/app/settings')
  revalidatePath('/app', 'layout')
  return { ok: true, notice: 'Configuración guardada.' }
}

export async function addMember(formData: FormData): Promise<SettingsResult> {
  const { supabase, user, org, profile } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }
  if (org.owner_id !== user.id) {
    return { ok: false, error: 'Solo el titular del despacho puede añadir miembros.' }
  }
  if (!roleCanLeadTeam(profile?.prof_role)) {
    return { ok: false, error: 'Solo un abogado o notario puede añadir miembros a su despacho.' }
  }
  if (!planAllowsTeam(org.sub_status)) return { ok: false, error: NO_TEAM_PLAN }
  if (!hasAdminCredentials()) return { ok: false, error: MISSING_KEY }

  const email = String(formData.get('email') ?? '').trim().toLowerCase()
  const role = String(formData.get('role') ?? 'PARALEGAL')

  if (!email) return { ok: false, error: 'Escribe el correo de la persona.' }
  if (!['PARALEGAL', 'ASSISTANT'].includes(role)) {
    return { ok: false, error: 'Rol no válido.' }
  }

  const admin = createAdminClient()

  const { data: target, error: lookupError } = await admin
    .from('profiles')
    .select('id, email')
    .eq('email', email)
    .maybeSingle()

  if (lookupError) return { ok: false, error: lookupError.message }

  if (!target) {
    return {
      ok: false,
      error: `No existe ninguna cuenta con el correo ${email}. Pídele que se registre primero en savedocumentos.com/register y vuelve a añadirla.`,
    }
  }

  if (target.id === user.id) return { ok: false, error: 'Ya eres el titular de este despacho.' }

  // El trigger handle_new_user le crea un espacio propio a TODO el que se
  // registra. La comprobación anterior rechazaba a cualquiera que tuviera
  // ALGUNA fila en org_members, así que se cumplía siempre y no se podía
  // añadir a nadie, nunca. Ahora hay que distinguir tres casos.
  const { data: memberships } = await admin
    .from('org_members')
    .select('id, org_id, organizations(id, owner_id, is_firm, name)')
    .eq('user_id', target.id)
    .returns<
      Array<{
        id: string
        org_id: string
        organizations: { id: string; owner_id: string; is_firm: boolean; name: string } | null
      }>
    >()

  const filas = memberships ?? []

  // 1. Ya está en este despacho.
  if (filas.some((m) => m.org_id === org.id)) {
    return { ok: false, error: `${email} ya forma parte de tu despacho.` }
  }

  // 2. Pertenece al despacho de otra persona, o dirige uno propio.
  //    Eso sí es motivo para no dejar añadirla.
  const ajeno = filas.find(
    (m) => m.organizations && m.organizations.owner_id !== target.id
  )
  if (ajeno) {
    return {
      ok: false,
      error: `${email} ya pertenece a otro despacho. Debe salir de él antes de unirse al tuyo.`,
    }
  }

  const despachoPropio = filas.find(
    (m) => m.organizations && m.organizations.owner_id === target.id && m.organizations.is_firm
  )
  if (despachoPropio) {
    return {
      ok: false,
      error: `${email} dirige su propio despacho («${despachoPropio.organizations!.name}»). No puede ser miembro del tuyo.`,
    }
  }

  // 3. Solo tiene el espacio personal que el sistema le creó al
  //    registrarse. Ese no estorba: se queda donde está y, a partir de
  //    ahora, al entrar verá tu despacho (ver la regla de despacho activo
  //    en src/lib/session.ts).

  const { count: before } = await admin
    .from('org_members')
    .select('id', { count: 'exact', head: true })
    .eq('org_id', org.id)

  const { error } = await admin
    .from('org_members')
    .insert({ org_id: org.id, user_id: target.id, role, permissions: {} })

  if (error) return { ok: false, error: error.message }

  const math = seatMath((before ?? 1) + 1, org.included_members, org.seat_price_dop)

  await logAudit(supabase, {
    orgId: org.id,
    userId: user.id,
    action: 'MEMBER_ADDED',
    description: `${email} añadido como ${role}. Coste mensual del despacho: ${formatDOP(math.total)}`,
  })

  revalidatePath('/app/settings')
  return {
    ok: true,
    notice: `${email} se añadió al despacho. Tu factura mensual pasa a ${formatDOP(math.total)}.`,
  }
}

export async function changeMemberRole(memberId: string, role: string): Promise<SettingsResult> {
  const { supabase, user, org } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }
  if (org.owner_id !== user.id) {
    return { ok: false, error: 'Solo el titular del despacho puede cambiar roles.' }
  }
  if (!['PARALEGAL', 'ASSISTANT'].includes(role)) return { ok: false, error: 'Rol no válido.' }

  // Al cambiar de rol se vuelve a los permisos por defecto del rol nuevo,
  // para no arrastrar permisos que ya no encajan.
  const { error } = await supabase
    .from('org_members')
    .update({ role, permissions: {} })
    .eq('id', memberId)
    .eq('org_id', org.id)

  if (error) return { ok: false, error: error.message }

  await logAudit(supabase, {
    orgId: org.id,
    userId: user.id,
    action: 'MEMBER_ROLE_CHANGED',
    description: `Rol cambiado a ${role}`,
  })

  revalidatePath('/app/settings')
  return { ok: true, notice: 'Rol actualizado. Los permisos volvieron a los de ese rol.' }
}

export async function updateMemberPermissions(
  memberId: string,
  formData: FormData
): Promise<SettingsResult> {
  const { supabase, user, org } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }
  if (org.owner_id !== user.id) {
    return { ok: false, error: 'Solo el titular del despacho puede cambiar permisos.' }
  }
  if (!planAllowsTeam(org.sub_status)) return { ok: false, error: NO_TEAM_PLAN }

  const raw: Record<string, unknown> = {}
  for (const { key } of PERMISSION_LIST) raw[key] = formData.get(key) === 'on'

  const { data: member } = await supabase
    .from('org_members')
    .select('role')
    .eq('id', memberId)
    .eq('org_id', org.id)
    .maybeSingle()

  if (member?.role === 'OWNER') {
    return { ok: false, error: 'El titular siempre conserva todos los permisos.' }
  }

  const { error } = await supabase
    .from('org_members')
    .update({ permissions: sanitizePermissions(raw) })
    .eq('id', memberId)
    .eq('org_id', org.id)

  if (error) return { ok: false, error: error.message }

  await logAudit(supabase, {
    orgId: org.id,
    userId: user.id,
    action: 'MEMBER_PERMISSIONS_CHANGED',
    description: `Permisos actualizados para el miembro ${memberId}`,
  })

  revalidatePath('/app/settings')
  return { ok: true, notice: 'Permisos actualizados.' }
}

export async function removeMember(memberId: string): Promise<SettingsResult> {
  const { supabase, user, org } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }
  if (org.owner_id !== user.id) {
    return { ok: false, error: 'Solo el titular del despacho puede quitar miembros.' }
  }

  const { data: member } = await supabase
    .from('org_members')
    .select('user_id, role')
    .eq('id', memberId)
    .eq('org_id', org.id)
    .maybeSingle()

  if (member?.role === 'OWNER') {
    return { ok: false, error: 'No puedes quitar al titular del despacho.' }
  }

  const { error } = await supabase
    .from('org_members')
    .delete()
    .eq('id', memberId)
    .eq('org_id', org.id)

  if (error) return { ok: false, error: error.message }

  const { count } = await supabase
    .from('org_members')
    .select('id', { count: 'exact', head: true })
    .eq('org_id', org.id)

  const math = seatMath(count ?? 1, org.included_members, org.seat_price_dop)

  await logAudit(supabase, {
    orgId: org.id,
    userId: user.id,
    action: 'MEMBER_REMOVED',
    description: `Miembro retirado. Coste mensual del despacho: ${formatDOP(math.total)}`,
  })

  revalidatePath('/app/settings')
  return {
    ok: true,
    notice: `Miembro retirado. Tu factura mensual baja a ${formatDOP(math.total)}.`,
  }
}
