// Las fechas de cumpleaños, probadas contra los casos que rompen.
const hoyEnRD = (ahora) => {
  const l = new Date(ahora.getTime() - 4*60*60*1000)
  return { anio: l.getUTCFullYear(), mes: l.getUTCMonth()+1, dia: l.getUTCDate() }
}
const esBisiesto = a => (a%4===0 && a%100!==0) || a%400===0
const toca = (iso, ahora) => {
  const m = /^(\d{4})-(\d{2})-(\d{2})/.exec(iso); if(!m) return false
  const mn=+m[2], dn=+m[3]; const h=hoyEnRD(ahora)
  if (mn===h.mes && dn===h.dia) return true
  if (mn===2 && dn===29 && !esBisiesto(h.anio)) return h.mes===2 && h.dia===28
  return false
}
const U = s => new Date(s)
const casos = [
  // [nacimiento, momento UTC, esperado, por que]
  ['1990-03-14', U('2026-03-14T12:00:00Z'), true,  'mediodia, caso normal'],
  ['1990-03-14', U('2026-03-15T02:00:00Z'), true,  'las 22:00 en RD del dia 14: en UTC ya es 15'],
  ['1990-03-14', U('2026-03-14T03:00:00Z'), false, 'las 23:00 en RD del dia 13: todavia no'],
  ['1990-03-15', U('2026-03-15T03:59:00Z'), false, 'las 23:59 del 14 en RD: aun no le toca'],
  ['1990-03-15', U('2026-03-15T04:01:00Z'), true,  'las 00:01 del 15 en RD: ahora si'],
  ['2000-02-29', U('2026-02-28T15:00:00Z'), true,  '2026 no es bisiesto: se felicita el 28'],
  ['2000-02-29', U('2026-03-01T15:00:00Z'), false, 'no se repite el 1 de marzo'],
  ['2000-02-29', U('2028-02-29T15:00:00Z'), true,  '2028 si es bisiesto: su dia real'],
  ['2000-02-29', U('2028-02-28T15:00:00Z'), false, 'en bisiesto NO se adelanta al 28'],
  ['1990-01-01', U('2026-01-01T05:00:00Z'), true,  'ano nuevo'],
  ['1990-12-31', U('2027-01-01T02:00:00Z'), true,  '31 de dic a las 22:00 RD, en UTC ya es enero'],
  ['no-es-fecha', U('2026-03-14T12:00:00Z'), false, 'basura'],
]
let fallos=0
for (const [nac, ahora, esperado, por] of casos) {
  const r = toca(nac, ahora)
  const ok = r === esperado
  if (!ok) fallos++
  console.log(`${ok?'OK  ':'MAL '} ${nac}  ${ahora.toISOString()}  -> ${r}  · ${por}`)
}
console.log(fallos===0 ? '\nTODO CORRECTO' : `\n${fallos} FALLOS`)
process.exit(fallos===0?0:1)
