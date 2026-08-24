import Link from 'next/link'
import { FileText, Plus } from 'lucide-react'
import PageHeader from '@/components/ui/PageHeader'
import EmptyState from '@/components/ui/EmptyState'
import { requireSession, displayName } from '@/lib/session'

export const dynamic = 'force-dynamic'

const STATUS_LABEL: Record<string, string> = {
  DRAFT: 'Borrador',
  IN_REVIEW: 'En revisión',
  APPROVED: 'Aprobado',
  FINAL: 'Final',
}

const STATUS_STYLE: Record<string, string> = {
  DRAFT: 'bg-slate-100 text-slate-600 dark:bg-slate-800 dark:text-slate-300',
  IN_REVIEW: 'bg-amber-50 text-amber-700 dark:bg-amber-900/20 dark:text-amber-400',
  APPROVED: 'bg-emerald-50 text-emerald-700 dark:bg-emerald-900/20 dark:text-emerald-400',
  FINAL: 'bg-emerald-600 text-white',
}

export default async function DocumentsPage() {
  const { supabase, org } = await requireSession()

  const { data } = org
    ? await supabase
        .from('documents')
        .select('id, title, status, created_at, updated_at, creator_id, profiles:creator_id(first_name, last_name, email)')
        .eq('org_id', org.id)
        .order('created_at', { ascending: false })
        .limit(100)
    : { data: [] }

  const documents = data ?? []

  return (
    <div className="mx-auto max-w-5xl">
      <PageHeader
        title="Documentos"
        subtitle="Todo lo que has generado en este despacho."
        action={
          <Link
            href="/app/templates"
            className="inline-flex items-center gap-2 rounded-lg bg-emerald-600 px-4 py-2 font-semibold text-white transition-colors hover:bg-emerald-700"
          >
            <Plus size={18} /> Nuevo documento
          </Link>
        }
      />

      {documents.length === 0 ? (
        <EmptyState
          title="Todavía no has generado ningún documento"
          description="Elige una plantilla, responde el formulario y SAVE arma el contrato por ti."
          action={
            <Link
              href="/app/templates"
              className="inline-flex items-center gap-2 rounded-lg bg-emerald-600 px-5 py-2.5 font-semibold text-white transition-colors hover:bg-emerald-700"
            >
              Ver plantillas
            </Link>
          }
        />
      ) : (
        <ul className="divide-y divide-slate-100 overflow-hidden rounded-xl border border-slate-200 bg-white dark:divide-slate-800 dark:border-slate-800 dark:bg-slate-900">
          {documents.map((d: any) => (
            <li key={d.id}>
              <Link
                href={`/app/documents/${d.id}`}
                className="flex items-center gap-4 px-5 py-4 transition-colors hover:bg-slate-50 dark:hover:bg-slate-800/50"
              >
                <FileText size={18} className="shrink-0 text-slate-400" />
                <div className="min-w-0 flex-1">
                  <p className="truncate font-medium text-slate-900 dark:text-white">{d.title}</p>
                  <p className="truncate text-sm text-slate-500">
                    {displayName(d.profiles, d.profiles?.email)} ·{' '}
                    {new Date(d.created_at).toLocaleDateString('es-DO', {
                      day: '2-digit',
                      month: 'short',
                      year: 'numeric',
                    })}
                  </p>
                </div>
                <span
                  className={`shrink-0 rounded-full px-2.5 py-1 text-xs font-semibold ${STATUS_STYLE[d.status] ?? STATUS_STYLE.DRAFT}`}
                >
                  {STATUS_LABEL[d.status] ?? d.status}
                </span>
              </Link>
            </li>
          ))}
        </ul>
      )}
    </div>
  )
}
