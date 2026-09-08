/**
 * Cuándo es el cumpleaños de alguien, visto desde República Dominicana.
 *
 * Dos cosas que parecen tonterías y no lo son:
 *
 * 1. EL HUSO. El servidor corre en UTC; el usuario vive en UTC-4. Entre
 *    las 20:00 y la medianoche dominicana, en UTC ya es el día
 *    siguiente. Si se compara contra `new Date()` a secas, a media
 *    España de la gente se le felicita un día antes —o se le pasa por
 *    alto— y nadie entiende por qué. RD no aplica horario de verano,
 *    así que el desfase es siempre de cuatro horas.
 *
 * 2. EL 29 DE FEBRERO. Quien nace ese día no tiene cumpleaños tres años
 *    de cada cuatro. Se le felicita el 28. La alternativa —el 1 de
 *    marzo— también vale, pero hay que elegir una y dejarla escrita, o
 *    el día que alguien mire el código pensará que es un olvido.
 */

/** Año, mes y día de HOY en República Dominicana. */
export function hoyEnRD(ahora: Date = new Date()): { anio: number; mes: number; dia: number } {
  // UTC-4 fijo, todo el año.
  const local = new Date(ahora.getTime() - 4 * 60 * 60 * 1000)
  return {
    anio: local.getUTCFullYear(),
    mes: local.getUTCMonth() + 1,
    dia: local.getUTCDate(),
  }
}

const esBisiesto = (a: number) => (a % 4 === 0 && a % 100 !== 0) || a % 400 === 0

/**
 * ¿Toca felicitar hoy a quien nació en `fechaISO` ("1990-03-14")?
 *
 * La fecha se parte a mano en vez de con `new Date(iso)`: ese
 * constructor interpreta "1990-03-14" como medianoche UTC y, al leerlo
 * con getDate() en un servidor en otro huso, devuelve el día 13. Es el
 * error clásico de los cumpleaños.
 */
export function toca(fechaISO: string, ahora: Date = new Date()): boolean {
  const m = /^(\d{4})-(\d{2})-(\d{2})/.exec(fechaISO)
  if (!m) return false
  const mesNac = Number(m[2])
  const diaNac = Number(m[3])

  const hoy = hoyEnRD(ahora)

  if (mesNac === hoy.mes && diaNac === hoy.dia) return true

  // Nació un 29 de febrero y este año no existe: se felicita el 28.
  if (mesNac === 2 && diaNac === 29 && !esBisiesto(hoy.anio)) {
    return hoy.mes === 2 && hoy.dia === 28
  }

  return false
}

/** Los años que cumple hoy. Null si la fecha no se puede leer. */
export function anosQueCumple(fechaISO: string, ahora: Date = new Date()): number | null {
  const m = /^(\d{4})-/.exec(fechaISO)
  if (!m) return null
  return hoyEnRD(ahora).anio - Number(m[1])
}
