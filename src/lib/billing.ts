/**
 * Reglas de cobro del plan de equipo.
 *
 * BUSINESS cuesta RD$999/mes e incluye al titular más un miembro.
 * A partir del segundo miembro se cobra RD$499/mes por cada uno.
 *
 * Los valores por defecto viven aquí, pero cada organización guarda los
 * suyos (included_members, seat_price_dop) para que un admin de SA&VE
 * pueda pactar condiciones distintas con un cliente sin redesplegar.
 */

export const BUSINESS_BASE_DOP = 999
export const DEFAULT_INCLUDED_MEMBERS = 1
export const DEFAULT_SEAT_PRICE_DOP = 499

export type PlanCode = 'FREE' | 'PREMIUM' | 'BUSINESS' | 'CANCELLED'

export const PLAN_LABEL: Record<PlanCode, string> = {
  FREE: 'Gratuito',
  PREMIUM: 'Pro',
  BUSINESS: 'Equipo',
  CANCELLED: 'Cancelado',
}

/** El trabajo en equipo solo existe en el plan BUSINESS. */
export function planAllowsTeam(plan: string | null | undefined) {
  return plan === 'BUSINESS'
}

/** Solo un profesional puede encabezar un despacho con equipo. */
export function roleCanLeadTeam(profRole: string | null | undefined) {
  return profRole === 'ABOGADO' || profRole === 'NOTARIO' || profRole === 'AMBOS'
}

export function formatDOP(amount: number) {
  return `RD$${amount.toLocaleString('es-DO')}`
}

export type SeatMath = {
  /** Miembros del despacho sin contar al titular. */
  members: number
  /** Cuántos de ellos cubre el precio base. */
  included: number
  /** Cuántos se cobran aparte. */
  billable: number
  seatPrice: number
  base: number
  /** Coste mensual total del despacho. */
  total: number
  /** Lo que costaría añadir una persona más. */
  costOfNext: number
}

/**
 * @param totalMembers filas de org_members, titular incluido.
 */
export function seatMath(
  totalMembers: number,
  included = DEFAULT_INCLUDED_MEMBERS,
  seatPrice = DEFAULT_SEAT_PRICE_DOP
): SeatMath {
  const members = Math.max(0, totalMembers - 1)
  const billable = Math.max(0, members - included)
  const total = BUSINESS_BASE_DOP + billable * seatPrice
  const costOfNext = members < included ? 0 : seatPrice

  return { members, included, billable, seatPrice, base: BUSINESS_BASE_DOP, total, costOfNext }
}

/** "RD$1,997 al mes" o "RD$999 al mes" según cuántos haya. */
export function describeMonthlyCost(math: SeatMath) {
  if (math.billable === 0) {
    return `${formatDOP(math.total)} al mes`
  }
  return `${formatDOP(math.total)} al mes · ${formatDOP(math.base)} del plan + ${math.billable} × ${formatDOP(math.seatPrice)}`
}
