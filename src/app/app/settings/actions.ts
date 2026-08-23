'use server'

import { revalidatePath } from 'next/cache'
import { requireSession } from '@/lib/session'
import { createAdminClient, hasAdminCredentials } from '@/utils/supabase/admin'
import { logAudit } from '@/lib/audit'

export type SettingsResult = { ok: boolean; error?: string; notice?: string }

const MISSING_KEY =
  'Falta configurar SUPABASE_SERVICE_ROLE_KEY en Railway. Sin esa llave no se pueden gestionar miembros del despacho.'

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
  const { supabase, user, org } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }
  if (org.owner_id !== user.id) {
    return { ok: false, error: 'Solo el titular del despacho puede cambiar esta configuración.' }
  }

  const name = String(formData.get('name') ?? '').trim()
  const is_firm = formData.get('is_firm') === 'on'
  const require_approval = formData.get('require_approval') === 'on'

  if (!name) return { ok: false, error: 'El nombre del despacho es obligatorio.' }

  const { error } = await supabase
    .from('organizations')
    .update({ name, is_firm, require_approval })
    .eq('id', org.id)

  if (error) return { ok: false, error: error.message }

  await logAudit(supabase, {
    orgId: org.id,
    userId: user.id,
    action: 'ORG_UPDATED',
    description: `Configuración del despacho actualizada (modo despacho: ${is_firm ? 'activo' : 'inactivo'})`,
  })

  revalidatePath('/app/settings')
  revalidatePath('/app', 'layout')
  return { ok: true, notice: 'Configuración guardada.' }
}

export async function addMember(formData: FormData): Promise<SettingsResult> {
  const { supabase, user, org } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }
  if (org.owner_id !== user.id) {
    return { ok: false, error: 'Solo el titular del despacho puede añadir miembros.' }
  }
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
    .select('id, email, first_name, last_name')
    .eq('email', email)
    .maybeSingle()

  if (lookupError) return { ok: false, error: lookupError.message }

  if (!target) {
    return {
      ok: false,
      error: `No existe ninguna cuenta con el correo ${email}. Pídele que se registre primero en savedocumentos.com/register y vuelve a añadirla.`,
    }
  }

  if (target.id === user.id) {
    return { ok: false, error: 'Ya eres el titular de este despacho.' }
  }

  const { data: already } = await admin
    .from('org_members')
    .select('id')
    .eq('user_id', target.id)
    .maybeSingle()

  if (already) {
    return { ok: false, error: 'Esa persona ya pertenece a un despacho.' }
  }

  const { error } = await admin
    .from('org_members')
    .insert({ org_id: org.id, user_id: target.id, role })

  if (error) return { ok: false, error: error.message }

  await logAudit(supabase, {
    orgId: org.id,
    userId: user.id,
    action: 'MEMBER_ADDED',
    description: `${email} añadido como ${role}`,
  })

  revalidatePath('/app/settings')
  return { ok: true, notice: `${email} se añadió al despacho.` }
}

export async function changeMemberRole(memberId: string, role: string): Promise<SettingsResult> {
  const { supabase, user, org } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }
  if (org.owner_id !== user.id) {
    return { ok: false, error: 'Solo el titular del despacho puede cambiar roles.' }
  }
  if (!['PARALEGAL', 'ASSISTANT'].includes(role)) {
    return { ok: false, error: 'Rol no válido.' }
  }

  const { error } = await supabase
    .from('org_members')
    .update({ role })
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
  return { ok: true, notice: 'Rol actualizado.' }
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

  await logAudit(supabase, {
    orgId: org.id,
    userId: user.id,
    action: 'MEMBER_REMOVED',
    description: `Miembro retirado del despacho`,
  })

  revalidatePath('/app/settings')
  return { ok: true, notice: 'Miembro retirado del despacho.' }
}
