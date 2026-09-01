'use server'

import { revalidatePath } from 'next/cache'
import { requireSession } from '@/lib/session'
import { createAdminClient, hasAdminCredentials } from '@/utils/supabase/admin'
import { logAudit } from '@/lib/audit'

export type AdminResult = { ok: boolean; error?: string; notice?: string }

const ADMIN_ROLES = ['SUPER_ADMIN', 'CONTENT', 'FINANCE'] as const

const MISSING_KEY =
  'Falta configurar SUPABASE_SERVICE_ROLE_KEY en las Variables de Railway. Sin esa llave el panel no puede modificar cuentas.'

/** Toda acción de este panel pasa por aquí: verifica que quien llama es admin de SA&VE. */
async function requireAdmin() {
  const session = await requireSession()
  if (!session.isAdmin) {
    throw new Error('No tienes permisos de administrador.')
  }
  if (!hasAdminCredentials()) {
    throw new Error(MISSING_KEY)
  }
  return session
}

function wrap(err: unknown): AdminResult {
  return { ok: false, error: err instanceof Error ? err.message : 'Error inesperado.' }
}

/* ---------------- Estado de la cuenta (borrado suave) ---------------- */

export async function setUserActive(userId: string, active: boolean): Promise<AdminResult> {
  try {
    const { user, org, supabase } = await requireAdmin()
    if (userId === user.id) {
      return { ok: false, error: 'No puedes desactivar tu propia cuenta.' }
    }

    const admin = createAdminClient()
    const { error } = await admin.from('profiles').update({ is_active: active }).eq('id', userId)
    if (error) return { ok: false, error: error.message }

    // Al desactivar, se invalidan las sesiones abiertas de esa persona.
    if (!active) {
      await admin.auth.admin.signOut(userId, 'global').catch(() => {})
    }

    if (org) {
      await logAudit(supabase, {
        orgId: org.id,
        userId: user.id,
        action: active ? 'ADMIN_USER_ENABLED' : 'ADMIN_USER_DISABLED',
        description: `Cuenta ${userId} ${active ? 'reactivada' : 'desactivada'}`,
      })
    }

    revalidatePath('/app/admin')
    return { ok: true, notice: active ? 'Cuenta reactivada.' : 'Cuenta desactivada.' }
  } catch (err) {
    return wrap(err)
  }
}

/* ---------------- Borrado permanente ---------------- */

export async function deleteUserPermanently(
  userId: string,
  confirmation: string
): Promise<AdminResult> {
  try {
    const { user, org, supabase } = await requireAdmin()
    if (userId === user.id) {
      return { ok: false, error: 'No puedes eliminar tu propia cuenta.' }
    }
    if (confirmation !== 'ELIMINAR') {
      return { ok: false, error: 'Escribe ELIMINAR para confirmar.' }
    }

    const admin = createAdminClient()

    const { data: target } = await admin
      .from('profiles')
      .select('email')
      .eq('id', userId)
      .maybeSingle()

    const { error } = await admin.auth.admin.deleteUser(userId)
    if (error) return { ok: false, error: error.message }

    if (org) {
      await logAudit(supabase, {
        orgId: org.id,
        userId: user.id,
        action: 'ADMIN_USER_DELETED',
        description: `Cuenta eliminada permanentemente: ${target?.email ?? userId}`,
      })
    }

    revalidatePath('/app/admin')
    return { ok: true, notice: 'Cuenta eliminada permanentemente.' }
  } catch (err) {
    return wrap(err)
  }
}

/* ---------------- Permisos de administrador ---------------- */

export async function setAdminRole(userId: string, role: string | null): Promise<AdminResult> {
  try {
    const { user, org, supabase } = await requireAdmin()
    const admin = createAdminClient()

    if (role === null) {
      if (userId === user.id) {
        return { ok: false, error: 'No puedes quitarte a ti mismo los permisos de administrador.' }
      }
      const { count } = await admin
        .from('save_admins')
        .select('id', { count: 'exact', head: true })
      if ((count ?? 0) <= 1) {
        return { ok: false, error: 'Debe quedar al menos un administrador en el sistema.' }
      }

      const { error } = await admin.from('save_admins').delete().eq('id', userId)
      if (error) return { ok: false, error: error.message }
    } else {
      if (!ADMIN_ROLES.includes(role as any)) {
        return { ok: false, error: 'Rol de administrador no válido.' }
      }
      const { error } = await admin
        .from('save_admins')
        .upsert({ id: userId, admin_role: role }, { onConflict: 'id' })
      if (error) return { ok: false, error: error.message }
    }

    if (org) {
      await logAudit(supabase, {
        orgId: org.id,
        userId: user.id,
        action: role ? 'ADMIN_GRANTED' : 'ADMIN_REVOKED',
        description: `Permisos de ${userId}: ${role ?? 'usuario normal'}`,
      })
    }

    revalidatePath('/app/admin')
    return { ok: true, notice: role ? `Permisos actualizados a ${role}.` : 'Permisos de administrador retirados.' }
  } catch (err) {
    return wrap(err)
  }
}

/* ---------------- Límites de la organización ---------------- */

export async function updateOrgLimits(
  orgId: string,
  formData: FormData
): Promise<AdminResult> {
  try {
    const { user, org, supabase } = await requireAdmin()
    const admin = createAdminClient()

    const free_limit = Number(formData.get('free_limit'))
    const vault_limit = Number(formData.get('vault_limit'))
    const sub_status = String(formData.get('sub_status') ?? 'FREE')
    const included_members = Number(formData.get('included_members'))
    const seat_price_dop = Number(formData.get('seat_price_dop'))

    if (!Number.isFinite(free_limit) || free_limit < 0) {
      return { ok: false, error: 'El límite de plantillas debe ser un número válido.' }
    }
    if (!Number.isFinite(vault_limit) || vault_limit < 0) {
      return { ok: false, error: 'El límite de bóveda debe ser un número válido.' }
    }
    if (!Number.isFinite(included_members) || included_members < 0) {
      return { ok: false, error: 'Los miembros incluidos deben ser un número válido.' }
    }
    if (!Number.isFinite(seat_price_dop) || seat_price_dop < 0) {
      return { ok: false, error: 'El precio por miembro debe ser un número válido.' }
    }
    if (!['FREE', 'PREMIUM', 'BUSINESS', 'CANCELLED'].includes(sub_status)) {
      return { ok: false, error: 'Estado de suscripción no válido.' }
    }

    const { error } = await admin
      .from('organizations')
      .update({ free_limit, vault_limit, sub_status, included_members, seat_price_dop })
      .eq('id', orgId)

    if (error) return { ok: false, error: error.message }

    if (org) {
      await logAudit(supabase, {
        orgId: org.id,
        userId: user.id,
        action: 'ADMIN_LIMITS_UPDATED',
        description: `Despacho ${orgId}: ${sub_status}, plantillas ${free_limit}, bóveda ${vault_limit}`,
      })
    }

    revalidatePath('/app/admin')
    return { ok: true, notice: 'Límites actualizados.' }
  } catch (err) {
    return wrap(err)
  }
}
