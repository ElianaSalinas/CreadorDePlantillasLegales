'use server'

import { revalidatePath } from 'next/cache'
import { requireSession } from '@/lib/session'
import { cargarEstadoDelPlan } from '@/lib/planes'
import { logAudit } from '@/lib/audit'
import {
  extraerTextoDeDocx,
  detectarCandidatos,
  aplicarElecciones,
  etiquetasDe,
  type Candidato,
} from '@/lib/engine/import'

export type AnalisisResult = {
  ok: boolean
  error?: string
  texto?: string
  candidatos?: Candidato[]
}

export type ImportResult = { ok: boolean; error?: string; templateId?: string }

const SIN_PLAN =
  'Convertir un documento en plantilla está disponible en los planes Pro y Equipo. En el plan gratuito puedes crear plantillas a mano desde cero.'

/** Quien importa necesita el plan y, además, permiso sobre las plantillas. */
async function requireImportador() {
  const session = await requireSession()
  if (!session.org) throw new Error('No tienes un espacio de trabajo asignado.')
  if (!session.permissions.templates) {
    throw new Error('No tienes permiso para gestionar las plantillas del despacho.')
  }

  const estado = await cargarEstadoDelPlan(session.supabase, session.org.id)
  // Si el estado no se pudo leer no se bloquea: un fallo de lectura no
  // debe parecer una restricción de plan, que es lo que más confunde.
  if (estado && !estado.permite_importar) throw new Error(SIN_PLAN)

  return session
}

function wrap(err: unknown, defecto: string) {
  return { ok: false, error: err instanceof Error ? err.message : defecto }
}

/**
 * Un mensaje que una persona pueda leer.
 *
 * Los errores de PostgreSQL llegan en inglés y hablando de columnas y
 * restricciones: 'null value in column "category" of relation
 * "templates" violates not-null constraint'. Eso en pantalla no ayuda a
 * nadie, y encima esconde el problema, porque quien lo lee no sabe si ha
 * hecho algo mal o si el producto está roto. Se traduce lo que se
 * reconoce y lo demás se acompaña de algo que sí orienta.
 */
/**
 * El nombre con el que la variable aparece en el formulario.
 *
 * Antes se usaba el tag con los guiones bajos cambiados por espacios, y
 * en pantalla salía "monto principal" en minúsculas, al lado de
 * etiquetas cuidadas como "¿Quién es la primera parte?". Se nota, y
 * hace que la plantilla importada parezca de segunda.
 */
function etiquetaLegible(tag: string): string {
  const texto = tag.replace(/_/g, ' ').trim()
  return texto.charAt(0).toUpperCase() + texto.slice(1)
}

function enCastellano(mensaje?: string): string {
  if (!mensaje) return 'No se pudo crear la plantilla.'

  if (/duplicate key|already exists/i.test(mensaje)) {
    return 'Ya tienes una variable con ese nombre. Cámbiale el nombre a la que se repite.'
  }
  if (/violates row-level security/i.test(mensaje)) {
    return 'No tienes permiso para crear plantillas en este despacho.'
  }
  if (/not-null constraint/i.test(mensaje)) {
    return `Falta un dato obligatorio para crear la plantilla. Detalle técnico: ${mensaje}`
  }

  return `No se pudo crear la plantilla. Detalle técnico: ${mensaje}`
}

/* ══════════════ PASO 1: LEER Y PROPONER ══════════════ */

export async function analizarDocumento(formData: FormData): Promise<AnalisisResult> {
  try {
    const { supabase, org } = await requireImportador()

    const archivo = formData.get('file') as File | null
    const pegado = String(formData.get('texto') ?? '').trim()

    let texto = pegado

    if (archivo && archivo.size > 0) {
      if (archivo.size > 10 * 1024 * 1024) {
        return { ok: false, error: 'El archivo supera los 10 MB.' }
      }
      texto = await extraerTextoDeDocx(await archivo.arrayBuffer())
    }

    if (texto.length < 80) {
      return {
        ok: false,
        error: 'El documento está casi vacío. Sube un .docx o pega el texto completo del contrato.',
      }
    }

    // El diccionario que ya existe: las variables globales del catálogo y
    // las propias del despacho. Sirve para proponer reutilizar en vez de
    // duplicar; sin esto, cada importación inventa su propio nombre para
    // el mismo concepto y el diccionario deja de servir en un mes.
    const { data: variables } = await supabase
      .from('variables')
      .select('tag')
      .or(`org_id.is.null,org_id.eq.${org!.id}`)

    const diccionario = (variables ?? []).map((v: any) => v.tag as string)

    return { ok: true, texto, candidatos: detectarCandidatos(texto, diccionario) }
  } catch (err) {
    return wrap(err, 'No se pudo leer el documento.')
  }
}

/* ══════════════ PASO 2: CREAR LA PLANTILLA ══════════════ */

export type EleccionConfirmada = {
  valor: string
  etiqueta: string
  tipo: string
  /** Cómo se le pregunta a quien rellene el formulario. */
  pregunta?: string
}

const TIPO_DE_DATO: Record<string, string> = {
  cedula: 'cedula',
  rnc: 'rnc',
  monto: 'currency',
  fecha: 'date',
  nombre: 'person',
  repetido: 'text',
  manual: 'text',
}

export async function crearPlantillaDesdeTexto(
  texto: string,
  elecciones: EleccionConfirmada[],
  meta: { titulo: string; descripcion: string; categoriaId: string | null }
): Promise<ImportResult> {
  try {
    const { supabase, user, org } = await requireImportador()

    // `templates` arrastra dos columnas de categoría: `category_id`, que
    // apunta a la tabla, y `category`, texto libre del esquema original y
    // NOT NULL. Rellenar solo la primera hace que el INSERT falle con un
    // mensaje de PostgreSQL que no dice nada a quien lo lee.
    let categoriaTexto = 'Sin categoría'
    if (meta.categoriaId) {
      const { data: cat } = await supabase
        .from('template_categories')
        .select('name')
        .eq('id', meta.categoriaId)
        .maybeSingle()
      if (cat) categoriaTexto = (cat as any).name
    }

    const titulo = meta.titulo.trim()
    if (!titulo) return { ok: false, error: 'Ponle un nombre a la plantilla.' }
    if (elecciones.length === 0) {
      return {
        ok: false,
        error:
          'No has confirmado ninguna variable. Sin variables esto sería un documento fijo, no una plantilla.',
      }
    }

    const cuerpo = aplicarElecciones(texto, elecciones)
    const etiquetas = etiquetasDe(cuerpo)

    // ── Las variables: se reutilizan las que existan, se crean las que no ──
    const { data: existentes } = await supabase
      .from('variables')
      .select('id, tag')
      .or(`org_id.is.null,org_id.eq.${org!.id}`)
      .in('tag', etiquetas)

    const porTag = new Map((existentes ?? []).map((v: any) => [v.tag as string, v.id as string]))

    const nuevas = elecciones
      .filter((e) => !porTag.has(e.etiqueta))
      .map((e) => ({
        org_id: org!.id,
        tag: e.etiqueta,
        label: etiquetaLegible(e.etiqueta),
        question: e.pregunta?.trim() || null,
        data_type: TIPO_DE_DATO[e.tipo] ?? 'text',
        is_required: true,
        created_by: user.id,
      }))

    if (nuevas.length > 0) {
      const { data: creadas, error: errorVars } = await supabase
        .from('variables')
        .insert(nuevas)
        .select('id, tag')

      if (errorVars) return { ok: false, error: enCastellano(errorVars.message) }
      for (const v of creadas ?? []) porTag.set((v as any).tag, (v as any).id)
    }

    // ── La plantilla ──
    const { data: plantilla, error: errorPlantilla } = await supabase
      .from('templates')
      .insert({
        org_id: org!.id,
        title: titulo,
        description: meta.descripcion.trim() || null,
        category: categoriaTexto,
        category_id: meta.categoriaId,
        is_master: false,
        status: 'DRAFT',
        version: '1.0',
        content: { engine: 'v2' },
        created_by: user.id,
      })
      .select('id')
      .maybeSingle()

    if (errorPlantilla || !plantilla) {
      return { ok: false, error: enCastellano(errorPlantilla?.message) }
    }

    const templateId = (plantilla as any).id as string

    // ── El cuerpo, en una sola sección ──
    // Se deja entero a propósito. Trocearlo solo por "PRIMERO:",
    // "SEGUNDO:" sería adivinar la estructura del documento de otra
    // persona; quien importa puede partirlo en el editor si quiere,
    // viendo lo que hace.
    const { error: errorSeccion } = await supabase.from('template_sections').insert({
      template_id: templateId,
      title: 'Cuerpo del documento',
      body: cuerpo,
      sort_order: 1,
    })

    if (errorSeccion) return { ok: false, error: enCastellano(errorSeccion.message) }

    // ── Enganchar las variables ──
    const enlaces = etiquetas
      .map((tag, i) => ({ template_id: templateId, variable_id: porTag.get(tag), sort_order: i + 1 }))
      .filter((e) => e.variable_id)

    if (enlaces.length > 0) {
      await supabase.from('template_variables').insert(enlaces as any)
    }

    await logAudit(supabase, {
      orgId: org!.id,
      userId: user.id,
      action: 'TEMPLATE_IMPORTED',
      description: `Plantilla creada desde un documento: ${titulo} (${enlaces.length} variables)`,
    })

    revalidatePath('/app/templates')
    return { ok: true, templateId }
  } catch (err) {
    return wrap(err, 'No se pudo crear la plantilla.')
  }
}
