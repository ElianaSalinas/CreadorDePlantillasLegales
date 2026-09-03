import { redirect } from 'next/navigation'
import PageHeader from '@/components/ui/PageHeader'
import { requireSession } from '@/lib/session'
import RevisionClient, { type PendienteClausula, type PendientePlantilla } from './RevisionClient'

export const dynamic = 'force-dynamic'

export default async function RevisionPage() {
  const { supabase, esRevisor, isAdmin } = await requireSession()

  if (!esRevisor && !isAdmin) redirect('/app/dashboard')

  const [{ data: plantillas }, { data: clausulas }] = await Promise.all([
    supabase
      .from('templates')
      .select('id, title, description, category, status, version, reviewed_at')
      .eq('is_master', true)
      .order('category')
      .order('title'),
    supabase
      .from('clauses')
      .select('id, title, family, description, body, legal_reference, status, reviewed_at')
      .is('org_id', null)
      .order('family')
      .order('title'),
  ])

  const p = (plantillas ?? []) as PendientePlantilla[]
  const c = (clausulas ?? []) as PendienteClausula[]

  const publicadas = p.filter((x) => x.status === 'PUBLISHED').length
  const clausulasPublicadas = c.filter((x) => x.status === 'PUBLISHED').length

  return (
    <div className="mx-auto max-w-5xl">
      <PageHeader
        title="Revisión del catálogo"
        subtitle={`${publicadas} de ${p.length} plantillas y ${clausulasPublicadas} de ${c.length} cláusulas ya están aprobadas y a la vista de todos.`}
      />
      <RevisionClient plantillas={p} clausulas={c} />
    </div>
  )
}
