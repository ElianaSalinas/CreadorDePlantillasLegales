'use client'

import { useMemo, useState, useTransition } from 'react'
import { Search, ShieldCheck, ShieldOff, Ban, CheckCircle2, Trash2, SlidersHorizontal, Loader2 } from 'lucide-react'
import Modal from '@/components/ui/Modal'
import EmptyState from '@/components/ui/EmptyState'
import {
  setUserActive,
  deleteUserPermanently,
  setAdminRole,
  updateOrgLimits,
  type AdminResult,
} from './actions'

export type AdminUserRow = {
  id: string
  email: string
  name: string
  prof_role: string | null
  is_active: boolean
  created_at: string
  admin_role: string | null
  org: {
    id: string
    name: string
    sub_status: string
    free_limit: number
    vault_limit: number
  } | null
}

export default function AdminClient({
  users,
  currentUserId,
}: {
  users: AdminUserRow[]
  currentUserId: string
}) {
  const [query, setQuery] = useState('')
  const [filter, setFilter] = useState<'all' | 'admins' | 'disabled'>('all')
  const [result, setResult] = useState<AdminResult | null>(null)
  const [pending, startTransition] = useTransition()

  const [limitsFor, setLimitsFor] = useState<AdminUserRow | null>(null)
  const [deleteFor, setDeleteFor] = useState<AdminUserRow | null>(null)
  const [confirmText, setConfirmText] = useState('')

  const visible = useMemo(() => {
    const q = query.trim().toLowerCase()
    return users.filter((u) => {
      if (filter === 'admins' && !u.admin_role) return false
      if (filter === 'disabled' && u.is_active) return false
      if (!q) return true
      return (
        u.email.toLowerCase().includes(q) ||
        u.name.toLowerCase().includes(q) ||
        (u.org?.name ?? '').toLowerCase().includes(q)
      )
    })
  }, [users, query, filter])

  function run(fn: () => Promise<AdminResult>) {
    setResult(null)
    startTransition(async () => setResult(await fn()))
  }

  return (
    <div>
      <div className="mb-5 flex flex-wrap items-center gap-3">
        <div className="relative min-w-[240px] flex-1">
          <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
          <input
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="Buscar por nombre, correo o despacho…"
            aria-label="Buscar usuarios"
            className="w-full rounded-lg border border-slate-300 bg-white py-2 pl-9 pr-4 text-slate-900 outline-none focus:ring-2 focus:ring-emerald-500 dark:border-slate-700 dark:bg-slate-900 dark:text-white"
          />
        </div>

        <div className="inline-flex rounded-lg border border-slate-200 bg-white p-1 dark:border-slate-800 dark:bg-slate-900">
          {(
            [
              ['all', `Todos (${users.length})`],
              ['admins', `Admins (${users.filter((u) => u.admin_role).length})`],
              ['disabled', `Desactivados (${users.filter((u) => !u.is_active).length})`],
            ] as const
          ).map(([key, label]) => (
            <button
              key={key}
              onClick={() => setFilter(key)}
              className={
                filter === key
                  ? 'rounded-md bg-emerald-600 px-3 py-1.5 text-sm font-semibold text-white'
                  : 'rounded-md px-3 py-1.5 text-sm font-medium text-slate-600 hover:text-slate-900 dark:text-slate-400 dark:hover:text-white'
              }
            >
              {label}
            </button>
          ))}
        </div>
      </div>

      {result && (
        <p
          className={
            result.ok
              ? 'mb-4 rounded-lg bg-emerald-50 p-3 text-sm text-emerald-700 dark:bg-emerald-900/20 dark:text-emerald-400'
              : 'mb-4 rounded-lg bg-red-50 p-3 text-sm text-red-600 dark:bg-red-900/20'
          }
        >
          {result.ok ? result.notice : result.error}
        </p>
      )}

      {visible.length === 0 ? (
        <EmptyState title="Ningún usuario coincide" description="Prueba con otro término de búsqueda." />
      ) : (
        <div className="overflow-x-auto rounded-xl border border-slate-200 bg-white dark:border-slate-800 dark:bg-slate-900">
          <table className="w-full min-w-[860px] text-left text-sm">
            <thead className="border-b border-slate-200 bg-slate-50 text-xs uppercase tracking-wide text-slate-500 dark:border-slate-800 dark:bg-slate-800/50">
              <tr>
                <th className="px-5 py-3 font-semibold">Usuario</th>
                <th className="px-5 py-3 font-semibold">Despacho</th>
                <th className="px-5 py-3 font-semibold">Permisos</th>
                <th className="px-5 py-3 font-semibold">Estado</th>
                <th className="px-5 py-3 text-right font-semibold">Acciones</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 dark:divide-slate-800">
              {visible.map((u) => {
                const isSelf = u.id === currentUserId
                return (
                  <tr key={u.id} className={u.is_active ? '' : 'bg-slate-50/60 dark:bg-slate-800/30'}>
                    <td className="px-5 py-3">
                      <p className="font-medium text-slate-900 dark:text-white">
                        {u.name}
                        {isSelf && <span className="ml-2 text-xs text-slate-400">(tú)</span>}
                      </p>
                      <p className="text-slate-500">{u.email}</p>
                    </td>

                    <td className="px-5 py-3">
                      {u.org ? (
                        <>
                          <p className="text-slate-700 dark:text-slate-300">{u.org.name}</p>
                          <p className="text-xs text-slate-500">
                            {u.org.sub_status === 'PREMIUM' ? 'Premium' : 'Gratuito'} ·{' '}
                            {u.org.free_limit} plantillas · {u.org.vault_limit} bóveda
                          </p>
                        </>
                      ) : (
                        <span className="text-slate-400">—</span>
                      )}
                    </td>

                    <td className="px-5 py-3">
                      <select
                        value={u.admin_role ?? 'NONE'}
                        disabled={pending}
                        onChange={(e) => {
                          const v = e.target.value
                          run(() => setAdminRole(u.id, v === 'NONE' ? null : v))
                        }}
                        aria-label={`Permisos de ${u.name}`}
                        className="rounded-md border border-slate-300 bg-white px-2 py-1.5 text-sm dark:border-slate-700 dark:bg-slate-800 dark:text-white"
                      >
                        <option value="NONE">Usuario</option>
                        <option value="SUPER_ADMIN">Super Admin</option>
                        <option value="CONTENT">Contenido</option>
                        <option value="FINANCE">Finanzas</option>
                      </select>
                    </td>

                    <td className="px-5 py-3">
                      {u.is_active ? (
                        <span className="inline-flex items-center gap-1.5 rounded-full bg-emerald-50 px-2.5 py-1 text-xs font-semibold text-emerald-700 dark:bg-emerald-900/20 dark:text-emerald-400">
                          <CheckCircle2 size={13} /> Activo
                        </span>
                      ) : (
                        <span className="inline-flex items-center gap-1.5 rounded-full bg-slate-200 px-2.5 py-1 text-xs font-semibold text-slate-600 dark:bg-slate-700 dark:text-slate-300">
                          <Ban size={13} /> Desactivado
                        </span>
                      )}
                    </td>

                    <td className="px-5 py-3">
                      <div className="flex justify-end gap-1">
                        {u.org && (
                          <button
                            onClick={() => setLimitsFor(u)}
                            title="Ajustar límites del despacho"
                            aria-label={`Ajustar límites de ${u.name}`}
                            className="rounded-md p-2 text-slate-500 transition-colors hover:bg-slate-100 hover:text-emerald-600 dark:hover:bg-slate-800"
                          >
                            <SlidersHorizontal size={16} />
                          </button>
                        )}

                        <button
                          onClick={() => run(() => setUserActive(u.id, !u.is_active))}
                          disabled={pending || isSelf}
                          title={isSelf ? 'No puedes desactivarte a ti mismo' : u.is_active ? 'Desactivar cuenta' : 'Reactivar cuenta'}
                          aria-label={u.is_active ? `Desactivar a ${u.name}` : `Reactivar a ${u.name}`}
                          className="rounded-md p-2 text-slate-500 transition-colors hover:bg-slate-100 hover:text-amber-600 disabled:opacity-30 dark:hover:bg-slate-800"
                        >
                          {u.is_active ? <ShieldOff size={16} /> : <ShieldCheck size={16} />}
                        </button>

                        <button
                          onClick={() => {
                            setDeleteFor(u)
                            setConfirmText('')
                            setResult(null)
                          }}
                          disabled={isSelf}
                          title={isSelf ? 'No puedes eliminarte a ti mismo' : 'Eliminar permanentemente'}
                          aria-label={`Eliminar a ${u.name}`}
                          className="rounded-md p-2 text-slate-500 transition-colors hover:bg-red-50 hover:text-red-600 disabled:opacity-30 dark:hover:bg-red-900/20"
                        >
                          <Trash2 size={16} />
                        </button>
                      </div>
                    </td>
                  </tr>
                )
              })}
            </tbody>
          </table>
        </div>
      )}

      {/* ---------- Límites ---------- */}
      <Modal
        open={limitsFor !== null}
        onClose={() => setLimitsFor(null)}
        title={`Límites de ${limitsFor?.org?.name ?? ''}`}
      >
        {limitsFor?.org && (
          <form
            action={(fd) => {
              setResult(null)
              startTransition(async () => {
                const r = await updateOrgLimits(limitsFor.org!.id, fd)
                setResult(r)
                if (r.ok) setLimitsFor(null)
              })
            }}
            className="space-y-4"
          >
            <div>
              <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
                Estado de suscripción
              </label>
              <select
                name="sub_status"
                defaultValue={limitsFor.org.sub_status}
                className="w-full rounded-lg border border-slate-300 bg-slate-50 px-4 py-2 dark:border-slate-700 dark:bg-slate-800 dark:text-white"
              >
                <option value="FREE">Gratuito</option>
                <option value="PREMIUM">Premium</option>
                <option value="CANCELLED">Cancelado</option>
              </select>
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
                  Plantillas gratis
                </label>
                <input
                  name="free_limit"
                  type="number"
                  min={0}
                  defaultValue={limitsFor.org.free_limit}
                  className="w-full rounded-lg border border-slate-300 bg-slate-50 px-4 py-2 dark:border-slate-700 dark:bg-slate-800 dark:text-white"
                />
              </div>
              <div>
                <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
                  Límite de bóveda
                </label>
                <input
                  name="vault_limit"
                  type="number"
                  min={0}
                  defaultValue={limitsFor.org.vault_limit}
                  className="w-full rounded-lg border border-slate-300 bg-slate-50 px-4 py-2 dark:border-slate-700 dark:bg-slate-800 dark:text-white"
                />
              </div>
            </div>

            <p className="text-xs text-slate-500">
              Un valor muy alto (por ejemplo 99999) equivale a un límite indefinido.
            </p>

            <div className="flex justify-end gap-3 pt-2">
              <button
                type="button"
                onClick={() => setLimitsFor(null)}
                className="rounded-lg px-4 py-2 font-medium text-slate-600 hover:bg-slate-100 dark:text-slate-400 dark:hover:bg-slate-800"
              >
                Cancelar
              </button>
              <button
                type="submit"
                disabled={pending}
                className="inline-flex items-center gap-2 rounded-lg bg-emerald-600 px-5 py-2 font-semibold text-white hover:bg-emerald-700 disabled:opacity-60"
              >
                {pending && <Loader2 size={16} className="animate-spin" />} Guardar
              </button>
            </div>
          </form>
        )}
      </Modal>

      {/* ---------- Borrado permanente ---------- */}
      <Modal
        open={deleteFor !== null}
        onClose={() => setDeleteFor(null)}
        title="Eliminar cuenta permanentemente"
      >
        {deleteFor && (
          <div className="space-y-4">
            <p className="rounded-lg bg-red-50 p-4 text-sm text-red-700 dark:bg-red-900/20 dark:text-red-400">
              Vas a eliminar <strong>{deleteFor.email}</strong>. Se borrarán también su perfil, su
              despacho, sus plantillas, sus documentos y su registro de auditoría. Esta acción{' '}
              <strong>no se puede deshacer</strong>.
            </p>

            <p className="text-sm text-slate-600 dark:text-slate-400">
              Si solo quieres retirarle el acceso conservando el historial, cierra esta ventana y usa{' '}
              <strong>Desactivar</strong> en su lugar.
            </p>

            <div>
              <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
                Escribe <code className="font-mono font-bold">ELIMINAR</code> para confirmar
              </label>
              <input
                value={confirmText}
                onChange={(e) => setConfirmText(e.target.value)}
                placeholder="ELIMINAR"
                className="w-full rounded-lg border border-slate-300 bg-slate-50 px-4 py-2 dark:border-slate-700 dark:bg-slate-800 dark:text-white"
              />
            </div>

            <div className="flex justify-end gap-3 pt-2">
              <button
                type="button"
                onClick={() => setDeleteFor(null)}
                className="rounded-lg px-4 py-2 font-medium text-slate-600 hover:bg-slate-100 dark:text-slate-400 dark:hover:bg-slate-800"
              >
                Cancelar
              </button>
              <button
                type="button"
                disabled={pending || confirmText !== 'ELIMINAR'}
                onClick={() => {
                  const id = deleteFor.id
                  setResult(null)
                  startTransition(async () => {
                    const r = await deleteUserPermanently(id, confirmText)
                    setResult(r)
                    if (r.ok) setDeleteFor(null)
                  })
                }}
                className="inline-flex items-center gap-2 rounded-lg bg-red-600 px-5 py-2 font-semibold text-white hover:bg-red-700 disabled:opacity-40"
              >
                {pending && <Loader2 size={16} className="animate-spin" />} Eliminar para siempre
              </button>
            </div>
          </div>
        )}
      </Modal>
    </div>
  )
}
