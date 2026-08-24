import Link from 'next/link'
import { notFound, redirect } from 'next/navigation'
import { ArrowLeft } from 'lucide-react'
import PageHeader from '@/components/ui/PageHeader'
import { requireSession } from '@/lib/session'
import { loadTemplateBundle } from '@/lib/engine/repository'
import { checkTemplateQuality } from '@/lib/engine/quality'
import TemplateEditorClient from './EditorClient'

export const dynamic = 'force-dynamic'

export default async function EditTemplatePage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params
  const { supabase, org, isAdmin, permissions } = await requireSession()

  if (!permissions.templates) redirect('/app/templates')

  const { data: meta } = await supabase
    .from('templates')
    .select('id, org_id, title, description, category_id, status, version, is_master, reviewed_by, reviewed_at')
    .eq('id', id)
    .maybeSingle()

  if (!meta) notFound()

  // Una plantilla maestra solo la edita SA&VE; la del despacho, su despacho.
  const owned = meta.org_id === org?.id
  if (!owned && !isAdmin) redirect('/app/templates')

  const bundle = await loadTemplateBundle(id)
  if (!bundle) notFound()

  const [{ data: categories }, { data: allVariables }, { data: allClauses }] = await Promise.all([
    supabase.from('template_categories').select('id, name').is('parent_id', null).order('sort_order'),
    supabase.from('variables').select('*').order('label'),
    supabase.from('clauses').select('id, org_id, title, family, description').order('family').order('title'),
  ])

  const report = checkTemplateQuality(bundle, meta)

  return (
    <div className="mx-auto max-w-4xl">
      <Link
        href="/app/templates"
        className="mb-4 inline-flex items-center gap-1.5 text-sm text-slate-500 transition-colors hover:text-emerald-600"
      >
        <ArrowLeft size={15} /> Volver a plantillas
      </Link>

      <PageHeader
        title={meta.title}
        subtitle="Define el formulario, las cláusulas y las reglas que arman el documento."
      />

      <TemplateEditorClient
        templateId={id}
        meta={meta}
        categories={categories ?? []}
        sections={bundle.sections}
        variables={allVariables ?? []}
        attachedVariables={bundle.templateVariables}
        clauses={allClauses ?? []}
        attachedClauses={bundle.templateClauses}
        rules={bundle.rules}
        report={report}
      />
    </div>
  )
}
