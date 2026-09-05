'use server'

import { revalidatePath } from 'next/cache'
import { requireSession } from '@/lib/session'
import { cargarEstadoDelPlan, motivoParaNoCrear } from '@/lib/planes'
import { logAudit } from '@/lib/audit'
import { loadTemplateBundle } from '@/lib/engine/repository'
import { renderDocument, snapshotTemplate } from '@/lib/engine/render'
import { validateAnswers } from '@/lib/engine/variables'
import { evaluateRules } from '@/lib/engine/rules'
import type { Answers } from '@/lib/engine/types'

export type PreviewResult = {
  ok: boolean
  error?: string
  text?: string
  missing?: string[]
  warnings?: string[]
  clauses?: { clauseId: string; title: string; included: boolean; reason: string }[]
  hiddenVariables?: string[]
  requiredVariables?: string[]
  fieldErrors?: { tag: string; label: string; message: string }[]
}

/**
 * Genera el documento en memoria mientras el usuario rellena el formulario.
 * No guarda nada: sirve para que vea en vivo qué cláusulas entran y salen.
 */
export async function previewDocument(templateId: string, answers: Answers): Promise<PreviewResult> {
  const { org } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }

  const bundle = await loadTemplateBundle(templateId)
  if (!bundle) return { ok: false, error: 'No se encontró la plantilla.' }

  const outcome = evaluateRules(bundle.rules, answers)
  const result = renderDocument(bundle, answers)

  const fieldErrors = validateAnswers(bundle.variables, answers, {
    required: outcome.requiredVariables,
    optional: outcome.optionalVariables,
    hidden: outcome.hiddenVariables,
  })

  return {
    ok: true,
    text: result.text,
    missing: result.missing,
    warnings: result.warnings,
    clauses: result.clauses,
    hiddenVariables: [...outcome.hiddenVariables],
    requiredVariables: [...outcome.requiredVariables],
    fieldErrors,
  }
}

export type GenerateResult = { ok: boolean; error?: string; documentId?: string; fieldErrors?: { tag: string; label: string; message: string }[] }

/**
 * Genera el documento de verdad y lo guarda.
 *
 * Congela la plantilla en una versión y deja el documento apuntando a ella,
 * de modo que editar la plantilla más adelante nunca altera este contrato.
 */
export async function generateDocument(
  templateId: string,
  answers: Answers,
  title: string
): Promise<GenerateResult> {
  const { supabase, user, org, permissions } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }
  if (!permissions.documents) {
    return { ok: false, error: 'No tienes permiso para redactar documentos. Pídeselo al titular.' }
  }

  const bundle = await loadTemplateBundle(templateId)
  if (!bundle) return { ok: false, error: 'No se encontró la plantilla.' }

  const outcome = evaluateRules(bundle.rules, answers)
  const fieldErrors = validateAnswers(bundle.variables, answers, {
    required: outcome.requiredVariables,
    optional: outcome.optionalVariables,
    hidden: outcome.hiddenVariables,
  })

  if (fieldErrors.length > 0) {
    return { ok: false, error: 'Faltan datos por completar.', fieldErrors }
  }

  const result = renderDocument(bundle, answers)

  // Se reutiliza la versión si ya existe una con el mismo número; si no,
  // se congela la plantilla tal como está en este momento.
  const version = bundle.template.version || '1.0'

  let versionId: string | null = null

  const { data: existing } = await supabase
    .from('template_versions')
    .select('id')
    .eq('template_id', templateId)
    .eq('version', version)
    .maybeSingle()

  if (existing) {
    versionId = existing.id
  } else {
    const { data: created, error: versionError } = await supabase
      .from('template_versions')
      .insert({
        template_id: templateId,
        version,
        snapshot: snapshotTemplate(bundle),
        status: 'PUBLISHED',
        published_at: new Date().toISOString(),
        created_by: user.id,
      })
      .select('id')
      .maybeSingle()

    // Que no se pueda versionar una plantilla maestra no debe impedir
    // generar el documento; se guarda sin referencia de versión.
    if (versionError) {
      console.warn('[documentos] no se pudo congelar la versión:', versionError.message)
    }
    versionId = created?.id ?? null
  }

  // El tope del plan, justo antes de escribir. Se comprueba aquí y no al
  // abrir el formulario porque la vista previa no consume cupo: solo
  // cuenta el documento que se guarda. Hay además un trigger en la base
  // que vuelve a comprobarlo, pero ese solo puede lanzar una excepción;
  // aquí se puede decir qué pasa y qué hacer.
  const estado = await cargarEstadoDelPlan(supabase, org.id)
  const impedimento = motivoParaNoCrear(estado)
  if (impedimento) return { ok: false, error: impedimento }

  const { data: doc, error } = await supabase
    .from('documents')
    .insert({
      org_id: org.id,
      creator_id: user.id,
      template_id: templateId,
      template_version_id: versionId,
      title: title.trim() || bundle.template.title,
      status: 'DRAFT',
      data_payload: answers,
      content: result.text,
      clause_selection: Object.fromEntries(result.clauses.map((c) => [c.clauseId, c.included])),
      generated_at: new Date().toISOString(),
    })
    .select('id')
    .maybeSingle()

  if (error || !doc) return { ok: false, error: error?.message ?? 'No se pudo guardar el documento.' }

  await logAudit(supabase, {
    orgId: org.id,
    userId: user.id,
    documentId: doc.id,
    action: 'DOCUMENT_CREATED',
    description: `Documento generado desde ${bundle.template.title} v${version}`,
  })

  revalidatePath('/app/documents')
  return { ok: true, documentId: doc.id }
}

export type SaveResult = { ok: boolean; error?: string; notice?: string }

/** Guarda el texto que el usuario editó a mano. */
export async function saveDocumentContent(documentId: string, content: string): Promise<SaveResult> {
  const { supabase, user, org, permissions } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }
  if (!permissions.documents) return { ok: false, error: 'No tienes permiso para editar documentos.' }

  const { error } = await supabase
    .from('documents')
    .update({ content, updated_at: new Date().toISOString() })
    .eq('id', documentId)
    .eq('org_id', org.id)

  if (error) return { ok: false, error: error.message }

  await logAudit(supabase, {
    orgId: org.id,
    userId: user.id,
    documentId,
    action: 'DOCUMENT_EDITED',
    description: 'Contenido editado a mano',
  })

  revalidatePath(`/app/documents/${documentId}`)
  return { ok: true, notice: 'Cambios guardados.' }
}

export async function updateDocumentStatus(
  documentId: string,
  status: 'DRAFT' | 'IN_REVIEW' | 'APPROVED' | 'FINAL'
): Promise<SaveResult> {
  const { supabase, user, org, memberRole } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }

  // Aprobar y finalizar es cosa del titular: el equipo redacta y envía a revisión.
  if ((status === 'APPROVED' || status === 'FINAL') && memberRole !== 'OWNER') {
    return { ok: false, error: 'Solo el titular del despacho puede aprobar un documento.' }
  }

  const { error } = await supabase
    .from('documents')
    .update({ status, updated_at: new Date().toISOString() })
    .eq('id', documentId)
    .eq('org_id', org.id)

  if (error) return { ok: false, error: error.message }

  await logAudit(supabase, {
    orgId: org.id,
    userId: user.id,
    documentId,
    action: `DOCUMENT_${status}`,
    description: `Estado cambiado a ${status}`,
  })

  revalidatePath(`/app/documents/${documentId}`)
  revalidatePath('/app/documents')
  return { ok: true, notice: 'Estado actualizado.' }
}

export async function deleteDocument(documentId: string): Promise<SaveResult> {
  const { supabase, user, org, permissions } = await requireSession()
  if (!org) return { ok: false, error: 'No tienes un espacio de trabajo asignado.' }
  if (!permissions.delete) return { ok: false, error: 'No tienes permiso para eliminar documentos.' }

  const { error } = await supabase.from('documents').delete().eq('id', documentId).eq('org_id', org.id)
  if (error) return { ok: false, error: error.message }

  await logAudit(supabase, {
    orgId: org.id,
    userId: user.id,
    action: 'DOCUMENT_DELETED',
    description: `Documento ${documentId} eliminado`,
  })

  revalidatePath('/app/documents')
  return { ok: true, notice: 'Documento eliminado.' }
}
