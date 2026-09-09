// El digito verificador del RNC, probado contra un numero real.
//
// Algoritmo de la DGII: pesos 7 9 8 6 5 4 3 2 sobre los ocho primeros
// digitos, modulo 11, y entonces:
//     resto 0 -> digito 2
//     resto 1 -> digito 1
//     resto n -> digito 11 - n
//
// El caso que da confianza no son los inventados: es 132-28618-9, el
// RNC real de SA&VE Comercial. Si una implementacion lo rechaza, esta
// mal por definicion.

const PESOS = [7, 9, 8, 6, 5, 4, 3, 2]

function digitoEsperado(ocho) {
  const suma = [...ocho].reduce((a, d, i) => a + Number(d) * PESOS[i], 0)
  const resto = suma % 11
  return resto === 0 ? 2 : resto === 1 ? 1 : 11 - resto
}

function valida(entrada) {
  const c = String(entrada).replace(/\D/g, '')
  if (c.length !== 9) return { ok: false, motivo: `${c.length} digitos, no 9` }
  const esperado = digitoEsperado(c.slice(0, 8))
  return { ok: esperado === Number(c[8]), esperado, tiene: Number(c[8]) }
}

const CASOS = [
  ['132-28618-9', true,  'RNC REAL de SA&VE Comercial'],
  ['132286189',   true,  'el mismo sin guiones'],
  ['  132286189 ', true, 'con espacios alrededor'],
  ['132286188',   false, 'verificador cambiado a 8'],
  ['132286180',   false, 'verificador cambiado a 0'],
  ['132286181',   false, 'verificador cambiado a 1'],
  ['13228618',    false, 'le falta un digito'],
  ['1322861899',  false, 'le sobra un digito'],
  ['',            false, 'vacio'],
  ['abcdefghi',   false, 'letras'],
]

let fallos = 0
for (const [entrada, esperado, por] of CASOS) {
  const r = valida(entrada)
  const ok = r.ok === esperado
  if (!ok) fallos++
  const det = r.esperado !== undefined ? `esperaba ${r.esperado}, tiene ${r.tiene}` : r.motivo
  console.log(`${ok ? 'OK  ' : 'MAL '} ${String(entrada).padEnd(14)} ${r.ok ? 'valido  ' : 'invalido'} · ${por}${ok ? '' : `  (${det})`}`)
}

// Propiedad del algoritmo que conviene tener escrita: NINGUN RNC
// valido termina en 0, porque el resto 0 se mapea a 2 y no a 0.
const terminadosEn0 = []
for (let n = 10000000; n < 10001000; n++) {
  if (digitoEsperado(String(n)) === 0) terminadosEn0.push(n)
}
if (terminadosEn0.length > 0) {
  console.log(`\nMAL  el algoritmo genero ${terminadosEn0.length} verificadores 0`)
  fallos++
} else {
  console.log('\nOK   ningun verificador vale 0, como debe ser')
}

console.log(fallos === 0 ? '\nTODO CORRECTO' : `\n${fallos} FALLOS`)
process.exit(fallos === 0 ? 0 : 1)
