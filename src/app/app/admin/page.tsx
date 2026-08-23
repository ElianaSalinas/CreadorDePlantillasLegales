import { redirect } from 'next/navigation'
import PageHeader from '@/components/ui/PageHeader'
import { requireSession, displayName } from '@/lib/session'
import { createAdminClient, hasAdminCredentials } from '@/utils/supabase/admin'
import AdminClient, { type AdminUserRow } from './AdminClient'

export const dynamic = 'force-dynamic'

export default async function AdminPage() {
  const { user, isAdmin } = await requireSession()

  if (!isAdmin) {
    redirect('/app/dashboard')
  }

  if (!hasAdminCredentials()) {
    return (
      <div className="mx-auto max-w-3xl">
        <PageHeader title="Administración" subtitle="Gestión de usuarios y despachos de la plataforma." />
        <div className="rounded-xl border border-amber-200 bg-amber-50 p-6 dark:border-amber-800 dark:bg-amber-900/20">
          <h2 className="font-bold text-amber-900 dark:text-amber-300">Falta una variable de entorno</h2>
          <p className="mt-2 text-sm text-amber-800 dark:text-amber-400">
            Este panel necesita <code>SUPABASE_SERVICE_ROLE_KEY</code> para poder leer y modificar
            cuentas saltándose las políticas de seguridad por fila.
          </p>
          <ol className="mt-4 list-decimal space-y-1 pl-5 text-sm text-amber-800 dark:text-amber-400">
            <li>Supabase → Project Settings → API → copia la llave <strong>service_role</strong>.</li>
            <li>Railway → tu proyecto → Variables → New Variable.</li>
            <li>
              Nombre: <code>SUPABASE_SERVICE_ROLE_KEY</code> · Valor: la llave copiada.
            </li>
            <li>Guarda. Railway hará el redespliegue solo.</li>
          </ol>
          <p className="mt-4 text-xs text-amber-700 dark:text-amber-500">
            Esa llave nunca llega al navegador: solo se usa en el servidor.
          </p>
        </div>
      </div>
    )
  }

  const admin = createAdminClient()

  const [{ data: profiles }, { data: admins }, { data: orgs }, { data: memberships }] =
    await Promise.all([
      admin.from('profiles').select('*').order('created_at', { ascending: false }),
      admin.from('save_admins').select('id, admin_role'),
      admin.from('organizations').select('id, owner_id, name, sub_status, free_limit, vault_limit'),
      admin.from('org_members').select('user_id, org_id'),
    ])

  const adminMap = new Map((admins ?? []).map((a: any) => [a.id, a.admin_role]))
  const orgMap = new Map((orgs ?? []).map((o: any) => [o.id, o]))
  const orgByUser = new Map<string, any>()

  for (const o of orgs ?? []) orgByUser.set((o as any).owner_id, o)
  for (const m of memberships ?? []) {
    const uid = (m as any).user_id
    if (!orgByUser.has(uid)) {
      const o = orgMap.get((m as any).org_id)
      if (o) orgByUser.set(uid, o)
    }
  }

  const users: AdminUserRow[] = (profiles ?? []).map((p: any) => ({
    id: p.id,
    email: p.email,
    name: displayName(p, p.email),
    prof_role: p.prof_role ?? null,
    is_active: p.is_active ?? true,
    created_at: p.created_at,
    admin_role: adminMap.get(p.id) ?? null,
    org: orgByUser.get(p.id)
      ? {
          id: orgByUser.get(p.id).id,
          name: orgByUser.get(p.id).name,
          sub_status: orgByUser.get(p.id).sub_status,
          free_limit: orgByUser.get(p.id).free_limit,
          vault_limit: orgByUser.get(p.id).vault_limit,
        }
      : null,
  }))

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader
        title="Administración"
        subtitle={`${users.length} cuentas registradas en la plataforma.`}
      />
      <AdminClient users={users} currentUserId={user.id} />
    </div>
  )
}
