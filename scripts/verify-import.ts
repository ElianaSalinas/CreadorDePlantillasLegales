/**
 * Comprobación del importador sobre un contrato dominicano realista.
 *
 *   npm run verify:import
 */
import { detectarCandidatos, aplicarElecciones, etiquetasDe } from '../src/lib/engine/import'

const CONTRATO = `CONTRATO DE ALQUILER DE VIVIENDA

ENTRE: JUAN ANTONIO PEREZ MARTINEZ, dominicano, mayor de edad, portador de la
cedula de identidad y electoral numero 001-1234567-3, domiciliado en Calle Duarte
No. 45, Punta Cana, quien en lo adelante se denominara LA PRIMERA PARTE;

Y DE LA OTRA PARTE: MARIA ALTAGRACIA GOMEZ SANTANA, dominicana, mayor de edad,
portadora de la cedula de identidad y electoral numero 402-1234567-8, domiciliada
en Avenida Espana No. 12, Higuey, quien en lo adelante se denominara LA SEGUNDA PARTE.

SE HA CONVENIDO Y PACTADO LO SIGUIENTE:

PRIMERO: LA PRIMERA PARTE da en alquiler a LA SEGUNDA PARTE el inmueble ubicado en
Calle Duarte No. 45, Punta Cana, por un precio mensual de RD$25,000.00, pagadero
el dia 5 de cada mes.

SEGUNDO: LA SEGUNDA PARTE entrega en este acto la suma de RD$50,000.00 como
deposito de garantia, que le sera devuelta al terminar el contrato.

TERCERO: El presente contrato tiene una vigencia de un ano, a partir del
15 de septiembre de 2026, renovable por periodos iguales.

CUARTO: Para todo lo no previsto, las partes se someten a los tribunales del
Distrito Judicial de La Altagracia.

Hecho y firmado en Punta Cana, Republica Dominicana, el 12 de septiembre de 2026,
en dos originales de un mismo tenor y efecto.`

const DICCIONARIO = [
  'parte_primera_nombre', 'parte_primera_cedula', 'parte_segunda_nombre',
  'parte_segunda_cedula', 'fecha_firma', 'direccion_inmueble', 'dia_pago',
]

console.log('══════════ CANDIDATOS PROPUESTOS ══════════\n')

const candidatos = detectarCandidatos(CONTRATO, DICCIONARIO)

for (const c of candidatos) {
  const reutiliza = c.variableExistente ? `  ← reutiliza {{${c.variableExistente}}}` : ''
  console.log(
    `[${c.confianza.padEnd(5)}] ${c.tipo.padEnd(9)} ${JSON.stringify(c.valor).padEnd(42)} ` +
      `x${c.ocurrencias}  → {{${c.etiquetaSugerida}}}${reutiliza}`
  )
}

console.log(`\nTotal: ${candidatos.length} candidatos`)
console.log(`  alta:  ${candidatos.filter((c) => c.confianza === 'alta').length}`)
console.log(`  media: ${candidatos.filter((c) => c.confianza === 'media').length}`)
console.log(`  baja:  ${candidatos.filter((c) => c.confianza === 'baja').length}`)
console.log(`  reutilizan una variable existente: ${candidatos.filter((c) => c.variableExistente).length}`)

console.log('\n══════════ COMPROBACIONES ══════════\n')

const debeEncontrar: Array<[string, string]> = [
  ['001-1234567-3', 'la cédula de la primera parte'],
  ['402-1234567-8', 'la cédula de la segunda parte'],
  ['RD$25,000.00', 'el precio del alquiler'],
  ['RD$50,000.00', 'el depósito'],
  ['JUAN ANTONIO PEREZ MARTINEZ', 'el nombre de la primera parte'],
  ['MARIA ALTAGRACIA GOMEZ SANTANA', 'el nombre de la segunda parte'],
  ['15 de septiembre de 2026', 'la fecha de inicio'],
  ['12 de septiembre de 2026', 'la fecha de firma'],
]

let fallos = 0
for (const [valor, que] of debeEncontrar) {
  const ok = candidatos.some((c) => c.valor === valor)
  console.log(`${ok ? '  OK  ' : '  FALLO'}  encuentra ${que}: ${valor}`)
  if (!ok) fallos++
}

const noDebeEncontrar = [
  'LA PRIMERA PARTE',
  'LA SEGUNDA PARTE',
  'SE HA CONVENIDO Y PACTADO LO SIGUIENTE',
  'DE LA OTRA PARTE',
  'CONTRATO DE ALQUILER DE VIVIENDA',
]
for (const formula of noDebeEncontrar) {
  const propuesto = candidatos.some((c) => c.valor === formula)
  console.log(`${!propuesto ? '  OK  ' : '  FALLO'}  NO propone "${formula}"`)
  if (propuesto) fallos++
}

// Encontrar el dato no basta: hay que ETIQUETARLO bien. La primera
// versión encontraba los dos nombres, pero colaba el título del
// documento por delante y los corría de puesto: la primera parte
// quedaba etiquetada como segunda. En un acto notarial eso no es un
// detalle, y una prueba que solo comprueba "lo encuentra" no lo ve.
console.log('')
const etiquetasEsperadas: Array<[string, string]> = [
  ['JUAN ANTONIO PEREZ MARTINEZ', 'parte_primera_nombre'],
  ['MARIA ALTAGRACIA GOMEZ SANTANA', 'parte_segunda_nombre'],
  ['001-1234567-3', 'parte_primera_cedula'],
  ['402-1234567-8', 'parte_segunda_cedula'],
]
for (const [valor, esperada] of etiquetasEsperadas) {
  const c = candidatos.find((x) => x.valor === valor)
  const real = c?.variableExistente ?? c?.etiquetaSugerida ?? '(no encontrado)'
  const ok = real === esperada
  console.log(`${ok ? '  OK  ' : '  FALLO'}  ${valor} → {{${real}}}${ok ? '' : `  (esperaba {{${esperada}}})`}`)
  if (!ok) fallos++
}

console.log('\n══════════ LA PLANTILLA RESULTANTE ══════════\n')

const elecciones = candidatos
  .filter((c) => c.confianza === 'alta' || c.tipo === 'nombre')
  .map((c) => ({ valor: c.valor, etiqueta: c.variableExistente ?? c.etiquetaSugerida }))

const plantilla = aplicarElecciones(CONTRATO, elecciones)
console.log(plantilla.split('\n').slice(0, 14).join('\n'))
console.log('...\n')
console.log('Variables de la plantilla:', etiquetasDe(plantilla).join(', '))

const restos = plantilla.match(/001-1234567-3|402-1234567-8|RD\$25,000\.00/g)
console.log(`\n${restos ? '  FALLO  quedaron datos sin sustituir: ' + restos.join(', ') : '  OK    no queda ningún dato del original sin sustituir'}`)
if (restos) fallos++

console.log(`\n${fallos === 0 ? '✅ TODO CORRECTO' : `❌ ${fallos} fallos`}`)
process.exit(fallos === 0 ? 0 : 1)
