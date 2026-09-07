import Link from 'next/link'
import { notFound } from 'next/navigation'
import { ArrowLeft } from 'lucide-react'
import PageHeader from '@/components/ui/PageHeader'
import { requireSession, displayName } from '@/lib/session'
import EditorClient from './EditorClient'
import SharePanel, { type Companero } from './SharePanel'
import PrivacidadToggle from './PrivacidadToggle'
import { MEMBER_ROLE_LABEL } from '@/lib/labels'

export const dynamic = 'force-dynamic'

const STATUS_LABEL: Record<string, string> = {
  DRAFT: 'Borrador',
  IN_REVIEW: 'En revisión',
  APPROVED: 'Aprobado',
  FINAL: 'Final',
}

export default async function DocumentPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params
  const { supabase, user, org, memberRole, permissions } = await requireSession()

  if (!org) notFound()

  // No hace falta filtrar por org_id: la política de documents ya decide.
  // Desde la Fase 4 un miembro del despacho ve los documentos de sus
  // compañeros, salvo los marcados privados, que siguen requiriendo ser su
  // autor, el titular, o tenerlo compartido.
  const { data: doc } = await supabase
    .from('documents')
    .select('id, title, status, content, created_at, creator_id, es_privado, template_version_id, templates(title, version), profiles:creator_id(first_name, last_name, email)')
    .eq('id', id)
    .maybeSingle()

  if (!doc) notFound()

  // Con quién se puede compartir: los demás miembros del despacho, sin el
  // titular -que ya lo ve todo- ni uno mismo.
  const puedeCompartir = (doc as any).creator_id === user.id || org.owner_id === user.id
  const esPrivado = Boolean((doc as any).es_privado)

  const { data: miembros } = await supabase
    .from('org_members')
    .select('user_id, role, profiles:user_id(first_name, last_name, email)')
    .eq('org_id', org.id)
    .returns<
      Array<{
        user_id: string
        role: string
        profiles: { first_name: string | null; last_name: string | null; email: string } | null
      }>
    >()

  const { data: repartos } = await supabase
    .from('document_shares')
    .select('user_id')
    .eq('document_id', id)
    .returns<Array<{ user_id: string }>>()

  const yaCompartido = new Set((repartos ?? []).map((r) => r.user_id))

  const companeros: Companero[] = (miembros ?? [])
    .filter((m) => m.user_id !== user.id && m.user_id !== org.owner_id)
    .map((m) => ({
      userId: m.user_id,
      // displayName espera un Profile entero y aquí solo pedimos tres
      // campos, así que se compone a mano.
      nombre:
        [m.profiles?.first_name, m.profiles?.last_name].filter(Boolean).join(' ').trim() ||
        m.profiles?.email ||
        'Miembro del despacho',
      rol: MEMBER_ROLE_LABEL[m.role] ?? m.role,
      compartido: yaCompartido.has(m.user_id),
    }))
    .sort((a, b) => a.nombre.localeCompare(b.nombre, 'es'))

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

      <div className="mb-4 flex flex-wrap items-start gap-3">
        <PrivacidadToggle
          documentId={doc.id}
          esPrivado={esPrivado}
          puedeCambiar={puedeCompartir}
        />

        {/* Compartir solo tiene sentido en un documento privado. En uno
            visible ya lo ve todo el despacho, y ofrecer el botón haría
            creer que hay alguien a quien todavía hay que darle acceso. */}
        {esPrivado && (
          <SharePanel
            documentId={doc.id}
            companeros={companeros}
            puedeCompartir={puedeCompartir}
          />
        )}
      </div>

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
