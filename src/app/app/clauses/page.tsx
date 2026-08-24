import PageHeader from '@/components/ui/PageHeader'
import { requireSession } from '@/lib/session'
import ClausesClient, { type ClauseRow } from './ClausesClient'

export const dynamic = 'force-dynamic'

export default async function ClausesPage() {
  const { supabase, org, permissions } = await requireSession()

  const { data } = await supabase
    .from('clauses')
    .select('id, org_id, title, family, description, body, legal_reference, status')
    .order('family')
    .order('title')

  const rows = (data ?? []) as ClauseRow[]
  const mine = rows.filter((c) => c.org_id === org?.id)
  const library = rows.filter((c) => c.org_id === null)

  // Para avisar en la interfaz si una cláusula usa una variable inexistente.
  const { data: vars } = await supabase.from('variables').select('tag, derived_config')
  const knownTags = new Set<string>()
  for (const v of (vars ?? []) as { tag: string; derived_config: any }[]) {
    knownTags.add(v.tag)
    const d = v.derived_config
    if (d?.transform) knownTags.add(d.as || `${v.tag}_${d.transform}`)
  }

  return (
    <div className="mx-auto max-w-4xl">
      <PageHeader
        title="Cláusulas"
        subtitle="Escríbelas una vez y reutilízalas en todas tus plantillas. Corregir el texto aquí lo corrige en todas."
      />
      <ClausesClient
        mine={mine}
        library={library}
        knownTags={[...knownTags]}
        canEdit={permissions.templates}
      />
    </div>
  )
}
