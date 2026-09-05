/**
 * El plan de un despacho y lo que le permite.
 *
 * Los números NO están aquí. Viven en la tabla `planes` de la base, y la
 * razón es que el trigger que protege `documents` también tiene que
 * conocerlos: si los duplicáramos en TypeScript acabarían divergiendo —la
 * aplicación diciendo 30 y la base dejando pasar 40— y el día que pase
 * nadie sabría cuál de los dos es el bueno.
 *
 * Aquí solo está cómo se leen y cómo se cuentan al usuario.
 */

import type { SupabaseClient } from '@supabase/supabase-js'

export type EstadoDelPlan = {
  /** El que rige AHORA. Si hay impago pasado el plazo, es CANCELLED. */
  plan: string
  nombre: string
  precio_dop: number
  /** El contratado, que puede no ser el que rige. */
  plan_contratado: string
  en_gracia: boolean
  suspendida: boolean
  impago_desde: string | null
  documentos_usados: number
  /** null = sin tope. */
  documentos_limite: number | null
  boveda_limite: number
  integrantes: number
  integrantes_incluidos: number
  precio_asiento_dop: number
  permite_equipo: boolean
  permite_importar: boolean
  catalogo_completo: boolean
}

/**
 * Todo el estado en un viaje. Devuelve null si la consulta falla —por
 * ejemplo si la migración de planes todavía no se ha ejecutado— y quien
 * llama decide qué hacer. Nunca revienta la pantalla por esto.
 */
export async function cargarEstadoDelPlan(
  supabase: SupabaseClient,
  orgId: string
): Promise<EstadoDelPlan | null> {
  const { data, error } = await supabase.rpc('estado_del_plan', { org: orgId })

  if (error || !data || (Array.isArray(data) && data.length === 0)) {
    if (error) console.warn('[planes] no se pudo leer el estado del plan:', error.message)
    return null
  }

  return (Array.isArray(data) ? data[0] : data) as EstadoDelPlan
}

/** Cuántos documentos quedan este mes. null = sin tope. */
export function documentosRestantes(e: EstadoDelPlan): number | null {
  if (e.documentos_limite === null) return null
  return Math.max(0, e.documentos_limite - e.documentos_usados)
}

/**
 * Por qué no se puede crear un documento ahora mismo, en palabras que
 * digan qué hacer. null si sí se puede.
 */
export function motivoParaNoCrear(e: EstadoDelPlan | null): string | null {
  if (!e) return null

  if (e.suspendida) {
    return 'La cuenta está suspendida por falta de pago. Puedes leer y descargar todo lo que ya tienes; para volver a crear documentos hay que regularizar el pago.'
  }

  const quedan = documentosRestantes(e)
  if (quedan !== null && quedan <= 0) {
    return `Has llegado a los ${e.documentos_limite} documentos de este mes del plan ${e.nombre}. El contador se reinicia el día 1; si necesitas más antes, tendrás que cambiar de plan.`
  }

  return null
}

/** Por qué no se puede subir a la bóveda. null si sí se puede. */
export function motivoParaNoSubir(e: EstadoDelPlan | null, usados: number): string | null {
  if (!e) return null

  if (e.suspendida) {
    return 'La cuenta está suspendida por falta de pago. La bóveda queda en solo lectura: puedes abrir y descargar lo que hay, pero no subir más.'
  }

  if (usados >= e.boveda_limite) {
    return `Tu bóveda está llena (${usados} de ${e.boveda_limite}). Elimina algún archivo o pasa a un plan con más espacio.`
  }

  return null
}

/** "RD$1,699 al mes" o, con gente de más, el desglose. */
export function costeMensual(e: EstadoDelPlan): string {
  const dop = (n: number) => `RD$${n.toLocaleString('es-DO')}`

  if (!e.permite_equipo || e.precio_asiento_dop === 0) {
    return e.precio_dop === 0 ? 'Gratis' : `${dop(e.precio_dop)} al mes`
  }

  // El titular no ocupa asiento: los incluidos se cuentan sobre el resto.
  const deMas = Math.max(0, e.integrantes - (e.integrantes_incluidos + 1))
  const total = e.precio_dop + deMas * e.precio_asiento_dop

  if (deMas === 0) return `${dop(total)} al mes`
  return `${dop(total)} al mes · ${dop(e.precio_dop)} del plan + ${deMas} × ${dop(e.precio_asiento_dop)}`
}
