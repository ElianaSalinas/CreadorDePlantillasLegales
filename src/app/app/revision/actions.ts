'use server'

import { revalidatePath } from 'next/cache'
import { requireSession } from '@/lib/session'
import { logAudit } from '@/lib/audit'
import { publishTemplate, unpublishTemplate } from '../templates/[id]/edit/actions'

export type RevisionResult = {
  ok: boolean
  error?: string
  notice?: string
  /** Las que no pasaron, con el motivo, para poder ir a arreglarlas. */
  fallos?: { id: string; titulo: string; motivo: string }[]
}

const SIN_PERMISO =
  'No tienes permiso para revisar el catálogo maestro de SA&VE.'

/** Todas las acciones de esta pantalla pasan por aquí. */
async function requireRevisor() {
  const session = await requireSession()
  if (!session.esRevisor && !session.isAdmin) throw new Error(SIN_PERMISO)
  return session
}

function wrap(err: unknown): RevisionResult {
  return { ok: false, error: err instanceof Error ? err.message : 'Error inesperado.' }
}

function touch() {
  revalidatePath('/app/revision')
  revalidatePath('/app/templates')
  revalidatePath('/app/clauses')
  revalidatePath('/')
}

/* ══════════════ CLÁUSULAS ══════════════ */

/**
 * Se aprueban antes que las plantillas, y no es un capricho del orden:
 * checkTemplateQuality impide publicar una plantilla maestra mientras
 * alguna de sus cláusulas siga en borrador.
 */
export async function aprobarClausulas(ids: string[]): Promise<RevisionResult> {
  try {
    const { supabase, user, org } = await requireRevisor()
    if (ids.length === 0) return { ok: false, error: 'No has seleccionado ninguna cláusula.' }

    const { data, error } = await supabase
      .from('clauses')
      .update({
        status: 'PUBLISHED',
        reviewed_by: user.id,
        reviewed_at: new Date().toISOString(),
      })
      .in('id', ids)
      .is('org_id', null)
      .select('id')

    if (error) return { ok: false, error: error.message }

    const hechas = data?.length ?? 0
    if (org) {
      await logAudit(supabase, {
        orgId: org.id,
        userId: user.id,
        action: 'CLAUSES_APPROVED',
        description: `${hechas} cláusulas del catálogo aprobadas`,
      })
    }

    touch()
    return {
      ok: true,
      notice:
        hechas === 1
          ? 'Cláusula aprobada. Ya está disponible para todos.'
          : `${hechas} cláusulas aprobadas. Ya están disponibles para todos.`,
    }
  } catch (err) {
    return wrap(err)
  }
}

export async function devolverClausulas(ids: string[]): Promise<RevisionResult> {
  try {
    const { supabase } = await requireRevisor()
    if (ids.length === 0) return { ok: false, error: 'No has seleccionado ninguna cláusula.' }

    const { data, error } = await supabase
      .from('clauses')
      .update({ status: 'DRAFT' })
      .in('id', ids)
      .is('org_id', null)
      .select('id')

    if (error) return { ok: false, error: error.message }

    touch()
    return {
      ok: true,
      notice: `${data?.length ?? 0} vuelven a borrador. Dejan de verse.`,
    }
  } catch (err) {
    return wrap(err)
  }
}

/**
 * Corregir el texto de una cláusula global.
 *
 * No se reutiliza updateClause de /app/clauses porque aquella filtra por
 * org_id: está pensada para las cláusulas propias de un despacho y nunca
 * tocaría una global. Esta hace lo contrario y solo eso: exige org_id nulo.
 */
export async function guardarClausula(
  id: string,
  campos: { title: string; description: string; body: string; legal_reference: string }
): Promise<RevisionResult> {
  try {
    const { supabase, user, org } = await requireRevisor()

    const title = campos.title.trim()
    const body = campos.body.trim()

    if (!title) return { ok: false, error: 'La cláusula necesita un título.' }
    if (!body) return { ok: false, error: 'La cláusula no puede quedarse sin texto.' }

    const { data, error } = await supabase
      .from('clauses')
      .update({
        title,
        body,
        description: campos.description.trim() || null,
        legal_reference: campos.legal_reference.trim() || null,
      })
      .eq('id', id)
      .is('org_id', null)
      .select('id')

    if (error) return { ok: false, error: error.message }
    if (!data || data.length === 0) {
      return { ok: false, error: 'Esa cláusula no es del catálogo global.' }
    }

    if (org) {
      await logAudit(supabase, {
        orgId: org.id,
        userId: user.id,
        action: 'CLAUSE_EDITED_IN_REVIEW',
        description: `Cláusula del catálogo corregida en revisión: ${title}`,
      })
    }

    touch()
    return { ok: true, notice: 'Texto guardado.' }
  } catch (err) {
    return wrap(err)
  }
}

/* ══════════════ PLANTILLAS ══════════════ */

/**
 * Reutiliza publishTemplate en vez de escribir aquí un UPDATE: así la
 * revisión pasa por la misma comprobación de calidad y deja la misma
 * versión congelada que cualquier otra publicación. Una plantilla que
 * no está lista no se aprueba por lote sin que nadie se entere; vuelve
 * en `fallos` con el motivo.
 */
export async function aprobarPlantillas(ids: string[]): Promise<RevisionResult> {
  try {
    const { supabase } = await requireRevisor()
    if (ids.length === 0) return { ok: false, error: 'No has seleccionado ninguna plantilla.' }

    const { data: metas } = await supabase
      .from('templates')
      .select('id, title')
      .in('id', ids)

    const titulos = new Map((metas ?? []).map((m: any) => [m.id, m.title as string]))

    const fallos: { id: string; titulo: string; motivo: string }[] = []
    let hechas = 0

    for (const id of ids) {
      const r = await publishTemplate(id, 'Revisión legal del catálogo')
      if (r.ok) hechas++
      else fallos.push({ id, titulo: titulos.get(id) ?? 'Sin título', motivo: r.error ?? 'Error desconocido.' })
    }

    touch()

    if (hechas === 0) {
      return {
        ok: false,
        error: 'Ninguna se pudo aprobar todavía.',
        fallos,
      }
    }

    return {
      ok: true,
      notice:
        fallos.length === 0
          ? hechas === 1
            ? 'Plantilla aprobada. Ya aparece en el catálogo.'
            : `${hechas} plantillas aprobadas. Ya aparecen en el catálogo.`
          : `${hechas} aprobadas. ${fallos.length} necesitan un arreglo antes.`,
      fallos: fallos.length > 0 ? fallos : undefined,
    }
  } catch (err) {
    return wrap(err)
  }
}

export async function devolverPlantillas(ids: string[]): Promise<RevisionResult> {
  try {
    await requireRevisor()
    if (ids.length === 0) return { ok: false, error: 'No has seleccionado ninguna plantilla.' }

    let hechas = 0
    for (const id of ids) {
      const r = await unpublishTemplate(id)
      if (r.ok) hechas++
    }

    touch()
    return { ok: true, notice: `${hechas} vuelven a borrador. Dejan de verse.` }
  } catch (err) {
    return wrap(err)
  }
}
