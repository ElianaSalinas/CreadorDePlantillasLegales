import Link from 'next/link'
import { FileText, Archive, Users, ArrowRight } from 'lucide-react'
import { requireSession, displayName } from '@/lib/session'
import { VAULT_BUCKET } from '@/lib/vault'

export const dynamic = 'force-dynamic'

export default async function DashboardPage() {
  const { supabase, profile, org, isAdmin, user } = await requireSession()

  let templateCount = 0
  let vaultCount = 0
  let memberCount = 1

  if (org) {
    const [{ count: tpl }, { count: members }, vaultList] = await Promise.all([
      supabase
        .from('templates')
        .select('id', { count: 'exact', head: true })
        .eq('org_id', org.id),
      supabase
        .from('org_members')
        .select('id', { count: 'exact', head: true })
        .eq('org_id', org.id),
      supabase.storage.from(VAULT_BUCKET).list(org.id, { limit: 1000 }),
    ])

    templateCount = tpl ?? 0
    memberCount = members ?? 1
    vaultCount = (vaultList.data ?? []).filter((f) => f.id !== null).length
  }

  return (
    <div className="mx-auto max-w-5xl">
      <h1 className="mb-2 text-3xl font-bold text-slate-900 dark:text-white">
        Bienvenido, {displayName(profile, user.email).split(' ')[0]}
      </h1>
      <p className="mb-8 text-slate-600 dark:text-slate-400">
        Este es tu espacio de trabajo seguro en Save Documentos.
      </p>

      {isAdmin && (
        <div className="mb-8 rounded-xl border border-amber-200 bg-amber-50 p-4 dark:border-amber-800 dark:bg-amber-900/20">
          <h2 className="mb-1 text-lg font-bold text-amber-800 dark:text-amber-500">
            Privilegios de Super Administrador
          </h2>
          <p className="mb-3 text-sm text-amber-700 dark:text-amber-400">
            Puedes gestionar las cuentas de toda la plataforma, ajustar los límites de cada despacho
            y publicar plantillas maestras.
          </p>
          <Link
            href="/app/admin"
            className="inline-flex items-center gap-1.5 text-sm font-semibold text-amber-800 hover:underline dark:text-amber-400"
          >
            Ir al panel de administración <ArrowRight size={15} />
          </Link>
        </div>
      )}

      <div className="grid grid-cols-1 gap-6 md:grid-cols-3">
        <StatCard
          href="/app/templates"
          icon={<FileText size={18} />}
          label="Plantillas del despacho"
          value={`${templateCount}`}
          detail={`Límite gratuito: ${org?.free_limit ?? 10}`}
        />
        <StatCard
          href="/app/vault"
          icon={<Archive size={18} />}
          label="Tu bóveda"
          value={`${vaultCount} / ${org?.vault_limit ?? 30}`}
          detail="Documentos almacenados"
        />
        <StatCard
          href="/app/settings"
          icon={<Users size={18} />}
          label={org?.is_firm ? 'Miembros del despacho' : 'Modo de trabajo'}
          value={org?.is_firm ? `${memberCount}` : 'Individual'}
          detail={org?.is_firm ? 'Usuarios activos' : 'Actívalo si trabajas con equipo'}
        />
      </div>
    </div>
  )
}

function StatCard({
  href,
  icon,
  label,
  value,
  detail,
}: {
  href: string
  icon: React.ReactNode
  label: string
  value: string
  detail: string
}) {
  return (
    <Link
      href={href}
      className="group rounded-xl border border-slate-200 bg-white p-6 shadow-sm transition-colors hover:border-emerald-300 dark:border-slate-800 dark:bg-slate-900 dark:hover:border-emerald-700"
    >
      <div className="mb-3 flex items-center gap-2 text-sm font-medium text-slate-500">
        <span className="text-emerald-600">{icon}</span>
        {label}
      </div>
      <div className="text-3xl font-bold text-slate-900 dark:text-white">{value}</div>
      <div className="mt-2 text-xs text-slate-400">{detail}</div>
    </Link>
  )
}
