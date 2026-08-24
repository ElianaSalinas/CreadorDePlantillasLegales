import Link from 'next/link'
import { notFound } from 'next/navigation'
import { ArrowLeft } from 'lucide-react'
import PageHeader from '@/components/ui/PageHeader'
import { requireSession, displayName } from '@/lib/session'
import EditorClient from './EditorClient'

export const dynamic = 'force-dynamic'

const STATUS_LABEL: Record<string, string> = {
  DRAFT: 'Borrador',
  IN_REVIEW: 'En revisión',
  APPROVED: 'Aprobado',
  FINAL: 'Final',
}

export default async function DocumentPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params
  const { supabase, org, memberRole, permissions } = await requireSession()

  if (!org) notFound()

  const { data: doc } = await supabase
    .from('documents')
    .select('id, title, status, content, created_at, template_version_id, templates(title, version), profiles:creator_id(first_name, last_name, email)')
    .eq('id', id)
    .eq('org_id', org.id)
    .maybeSingle()

  if (!doc) notFound()

  const template = (doc as any).templates
  const creator = (doc as any).profiles

  return (
    <div className="mx-auto max-w-4xl">
      <Link
        href="/app/documents"
        className="mb-4 inline-flex items-center gap-1.5 text-sm text-slate-500 transition-colors hover:text-emerald-600"
      >
        <ArrowLeft size={15} /> Volver a documentos
      </Link>

      <PageHeader
        title={doc.title}
        subtitle={[
          template ? `${template.title} v${template.version ?? '1.0'}` : null,
          `Creado por ${displayName(creator, creator?.email)}`,
          STATUS_LABEL[doc.status] ?? doc.status,
        ]
          .filter(Boolean)
          .join(' · ')}
      />

      {!doc.template_version_id && (
        <p className="mb-4 rounded-lg bg-amber-50 p-3 text-sm text-amber-800 dark:bg-amber-900/20 dark:text-amber-300">
          Este documento no quedó anclado a una versión concreta de la plantilla. Si la plantilla
          cambia, no podrás reconstruirlo exactamente igual.
        </p>
      )}

      <EditorClient
        documentId={doc.id}
        initialContent={doc.content ?? ''}
        status={doc.status}
        isOwner={memberRole === 'OWNER'}
        canEdit={permissions.documents}
        canDelete={permissions.delete}
      />
    </div>
  )
}
