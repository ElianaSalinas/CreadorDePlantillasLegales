import Link from 'next/link'
import { redirect } from 'next/navigation'
import { ArrowLeft, Lock } from 'lucide-react'
import PageHeader from '@/components/ui/PageHeader'
import { requireSession } from '@/lib/session'
import { cargarEstadoDelPlan } from '@/lib/planes'
import ImportarClient from './ImportarClient'

export const dynamic = 'force-dynamic'

export const metadata = { title: 'Convertir un documento en plantilla' }

export default async function ImportarPage() {
  const { supabase, org, permissions } = await requireSession()

  if (!permissions.templates) redirect('/app/templates')

  const [estado, { data: categorias }] = await Promise.all([
    org ? cargarEstadoDelPlan(supabase, org.id) : Promise.resolve(null),
    supabase.from('template_categories').select('id, name').is('parent_id', null).order('sort_order'),
  ])

  const volver = (
    <Link
      href="/app/templates"
      className="mb-4 inline-flex items-center gap-1.5 text-sm text-slate-500 transition-colors hover:text-emerald-600"
    >
      <ArrowLeft size={15} /> Volver a plantillas
    </Link>
  )

  // El plan gratuito no lo tiene. Se explica qué se pierde y qué sí puede
  // hacer, en vez de esconder la pantalla sin decir nada.
  if (estado && !estado.permite_importar) {
    return (
      <div className="mx-auto max-w-2xl">
        {volver}
        <PageHeader title="Convertir un documento en plantilla" />
        <div className="rounded-xl border border-slate-200 bg-white p-8 dark:border-slate-800 dark:bg-slate-900">
          <span className="inline-flex rounded-lg bg-slate-100 p-2.5 text-slate-500 dark:bg-slate-800">
            <Lock size={20} />
          </span>
          <h2 className="mt-4 text-lg font-bold text-slate-900 dark:text-white">
            Esto viene con el plan Pro
          </h2>
          <p className="mt-2 text-sm text-slate-600 dark:text-slate-400">
            Subes un contrato que ya usas, SAVE te señala qué partes cambian de un caso a otro, y
            lo conviertes en una plantilla con su formulario. Está en <strong>Pro</strong> y en{' '}
            <strong>Equipo</strong>.
          </p>
          <p className="mt-4 text-sm text-slate-600 dark:text-slate-400">
            Con el plan {estado.nombre} puedes seguir creando plantillas a mano desde cero, sin
            límite.
          </p>
          <Link
            href="/app/templates"
            className="mt-6 inline-flex rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white transition-colors hover:bg-emerald-700"
          >
            Crear una plantilla a mano
          </Link>
        </div>
      </div>
    )
  }

  return (
    <div className="mx-auto max-w-5xl">
      {volver}
      <PageHeader
        title="Convertir un documento en plantilla"
        subtitle="Sube el contrato que ya usas. SAVE te propone qué partes deberían ser variables, y tú decides una por una."
      />
      <ImportarClient categorias={categorias ?? []} />
    </div>
  )
}
