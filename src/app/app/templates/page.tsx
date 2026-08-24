import PageHeader from '@/components/ui/PageHeader'
import { requireSession } from '@/lib/session'
import TemplatesClient, { type TemplateRow } from './TemplatesClient'

export const dynamic = 'force-dynamic'

export default async function TemplatesPage() {
  const { supabase, org, permissions } = await requireSession()

  const { data: all } = await supabase
    .from('templates')
    .select('id, title, category, is_master, version, content, created_at, org_id')
    .order('created_at', { ascending: false })

  const rows = (all ?? []) as (TemplateRow & { org_id: string | null })[]
  const master = rows.filter((r) => r.is_master)
  const mine = rows.filter((r) => !r.is_master && r.org_id === org?.id)

  // Quien no tenga el permiso puede consultar, pero no modificar el banco.
  const canEdit = permissions.templates

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader
        title="Plantillas"
        subtitle="Tu banco de modelos y la biblioteca maestra de SA&VE."
      />
      <TemplatesClient mine={mine} master={master} canEdit={canEdit} />
    </div>
  )
}
