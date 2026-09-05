import Link from 'next/link'
import { notFound } from 'next/navigation'
import { ArrowLeft } from 'lucide-react'
import PageHeader from '@/components/ui/PageHeader'
import { requireSession } from '@/lib/session'
import { cargarEstadoDelPlan, documentosRestantes, motivoParaNoCrear } from '@/lib/planes'
import { loadTemplateBundle, groupVariablesBySection } from '@/lib/engine/repository'
import GeneratorClient from './GeneratorClient'
import type { Answers } from '@/lib/engine/types'

export const dynamic = 'force-dynamic'

export default async function NewDocumentPage({
  params,
}: {
  params: Promise<{ templateId: string }>
}) {
  const { templateId } = await params
  const { supabase, org, permissions } = await requireSession()

  const bundle = await loadTemplateBundle(templateId)
  if (!bundle) notFound()

  const groups = groupVariablesBySection(bundle)

  // Los valores por defecto del catálogo entran ya rellenados.
  const defaults: Answers = {}
  for (const v of bundle.variables) {
    if (v.default_value !== null && v.default_value !== undefined && v.default_value !== '') {
      defaults[v.tag] =
        v.data_type === 'number' || v.data_type === 'currency' || v.data_type === 'percentage'
          ? Number(v.default_value)
          : v.default_value
    }
  }
  if (!defaults.fecha_firma) defaults.fecha_firma = new Date().toISOString().slice(0, 10)

  if (!permissions.documents) {
    return (
      <div className="mx-auto max-w-2xl">
        <PageHeader title="Nuevo documento" />
        <p className="rounded-xl border border-amber-200 bg-amber-50 p-6 text-sm text-amber-800 dark:border-amber-800 dark:bg-amber-900/20 dark:text-amber-300">
          No tienes permiso para redactar documentos en este despacho. Pídeselo al titular.
        </p>
      </div>
    )
  }

  // Se avisa ANTES de rellenar dieciocho campos, no después de darle a
  // Generar. Enterarse del tope cuando ya has escrito todo es la peor
  // forma posible de enterarse.
  const estado = org ? await cargarEstadoDelPlan(supabase, org.id) : null
  const bloqueado = motivoParaNoCrear(estado)
  const quedan = estado ? documentosRestantes(estado) : null

  if (bloqueado) {
    return (
      <div className="mx-auto max-w-2xl">
        <Link
          href="/app/templates"
          className="mb-4 inline-flex items-center gap-1.5 text-sm text-slate-500 transition-colors hover:text-emerald-600"
        >
          <ArrowLeft size={15} /> Volver a plantillas
        </Link>
        <PageHeader title={bundle.template.title} />
        <p className="rounded-xl border border-amber-200 bg-amber-50 p-6 text-sm text-amber-800 dark:border-amber-800 dark:bg-amber-900/20 dark:text-amber-300">
          {bloqueado}
        </p>
      </div>
    )
  }

  return (
    <div className="mx-auto max-w-6xl">
      <Link
        href="/app/templates"
        className="mb-4 inline-flex items-center gap-1.5 text-sm text-slate-500 transition-colors hover:text-emerald-600"
      >
        <ArrowLeft size={15} /> Volver a plantillas
      </Link>

      <PageHeader
        title={bundle.template.title}
        subtitle="Responde el formulario. Las cláusulas del contrato se ajustan solas a tus respuestas."
      />

      {quedan !== null && quedan <= 3 && (
        <p className="mb-5 rounded-xl border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-800 dark:border-amber-800 dark:bg-amber-900/20 dark:text-amber-300">
          {quedan === 1
            ? 'Te queda 1 documento este mes.'
            : `Te quedan ${quedan} documentos este mes.`}{' '}
          El contador se reinicia el día 1.
        </p>
      )}

      <GeneratorClient
        templateId={templateId}
        templateTitle={bundle.template.title}
        groups={groups}
        defaults={defaults}
      />
    </div>
  )
}
