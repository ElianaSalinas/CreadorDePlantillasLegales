/**
 * Comprobación del motor documental.
 *
 * Se ejecuta con:  npm run verify:engine
 *
 * No usa ningún marco de pruebas a propósito: TypeScript ya está en el
 * proyecto y Node sabe ejecutar TypeScript directamente, así que esto no
 * añade ninguna dependencia nueva.
 */

import assert from 'node:assert/strict'
import {
  validateCedula,
  validateRNC,
  enteroALetras,
  montoALetras,
  fechaNotarial,
  formatMoney,
} from '../src/lib/engine/dominican'
import { evaluateCondition, evaluateRules, describeCondition } from '../src/lib/engine/rules'
import { substitute, buildSubstitutions, validateAnswers, normalizeTag } from '../src/lib/engine/variables'
import { renderDocument, type TemplateBundle } from '../src/lib/engine/render'
import type { Condition, TemplateRule, Variable } from '../src/lib/engine/types'

let passed = 0
let failed = 0

function test(name: string, fn: () => void) {
  try {
    fn()
    passed++
    console.log(`  ok   ${name}`)
  } catch (err) {
    failed++
    console.log(`  FALLA ${name}`)
    console.log(`        ${err instanceof Error ? err.message.split('\n')[0] : err}`)
  }
}

function group(title: string) {
  console.log(`\n${title}`)
}

/* ══════════════ VALIDADORES DOMINICANOS ══════════════ */

group('Validadores dominicanos')

test('acepta una cédula con verificador correcto', () => {
  assert.equal(validateCedula('402-2456789-7').isValid, true)
})

test('rechaza una cédula con un dígito cambiado', () => {
  assert.equal(validateCedula('402-2456789-4').isValid, false)
})

test('rechaza una cédula con menos de 11 dígitos', () => {
  const r = validateCedula('402-245678')
  assert.equal(r.isValid, false)
  assert.match(r.error!, /11 dígitos/)
})

test('formatea la cédula con guiones', () => {
  assert.equal(validateCedula('40224567897').formatted, '402-2456789-7')
})

test('reconoce un RNC de empresa de 9 dígitos', () => {
  assert.equal(validateRNC('131158155').kind, 'PERSONA_JURIDICA')
})

test('trata un RNC de 11 dígitos como persona física', () => {
  assert.equal(validateRNC('40224567897').kind, 'PERSONA_FISICA')
})

group('Números a letras')

test('convierte un entero simple', () => {
  assert.equal(enteroALetras(30000), 'TREINTA MIL')
})

test('convierte cien exacto', () => {
  assert.equal(enteroALetras(100), 'CIEN')
})

test('convierte ciento uno', () => {
  assert.equal(enteroALetras(101), 'CIENTO UN')
})

test('apocopa veintiún mil, que el legado escribía mal', () => {
  assert.equal(enteroALetras(21000), 'VEINTIÚN MIL')
})

test('escribe un monto completo en forma legal', () => {
  assert.equal(
    montoALetras(32000, 'DOP'),
    'TREINTA Y DOS MIL PESOS DOMINICANOS CON 00/100 (RD$32,000.00)'
  )
})

test('usa el singular con un solo peso', () => {
  assert.match(montoALetras(1, 'DOP'), /^UN PESO DOMINICANO CON 00\/100/)
})

test('conserva los centavos', () => {
  assert.match(montoALetras(1500.5, 'DOP'), /CON 50\/100/)
})

test('formatea moneda con separador de miles', () => {
  assert.equal(formatMoney(32000, 'DOP'), 'RD$32,000.00')
})

group('Fechas notariales')

test('escribe la fecha en forma solemne', () => {
  assert.equal(
    fechaNotarial('2026-08-15'),
    'a los quince (15) días del mes de agosto del año dos mil veintiséis (2026)'
  )
})

test('usa singular el día primero, que el legado escribía mal', () => {
  assert.equal(
    fechaNotarial('2026-08-01'),
    'al primer (1er) día del mes de agosto del año dos mil veintiséis (2026)'
  )
})

/* ══════════════ CONDICIONES ══════════════ */

group('Motor de condiciones')

const answers = {
  mascotas: true,
  amueblado: false,
  tipo_inmueble: 'residencial',
  precio_renta: 32000,
  inquilinos: 'María, José',
}

test('evalúa una comparación simple', () => {
  assert.equal(evaluateCondition({ variable: 'mascotas', operator: 'is_true' }, answers), true)
})

test('evalúa AND con dos hijos', () => {
  const c: Condition = {
    op: 'AND',
    children: [
      { variable: 'mascotas', operator: 'is_true' },
      { variable: 'tipo_inmueble', operator: 'equals', value: 'residencial' },
    ],
  }
  assert.equal(evaluateCondition(c, answers), true)
})

test('AND falla si un hijo no se cumple', () => {
  const c: Condition = {
    op: 'AND',
    children: [
      { variable: 'mascotas', operator: 'is_true' },
      { variable: 'amueblado', operator: 'is_true' },
    ],
  }
  assert.equal(evaluateCondition(c, answers), false)
})

test('evalúa OR', () => {
  const c: Condition = {
    op: 'OR',
    children: [
      { variable: 'amueblado', operator: 'is_true' },
      { variable: 'mascotas', operator: 'is_true' },
    ],
  }
  assert.equal(evaluateCondition(c, answers), true)
})

test('evalúa NOT', () => {
  const c: Condition = {
    op: 'NOT',
    children: [{ variable: 'tipo_inmueble', operator: 'equals', value: 'comercial' }],
  }
  assert.equal(evaluateCondition(c, answers), true)
})

test('anida AND dentro de OR', () => {
  const c: Condition = {
    op: 'OR',
    children: [
      { op: 'AND', children: [
        { variable: 'mascotas', operator: 'is_true' },
        { variable: 'precio_renta', operator: 'greater_than', value: 20000 },
      ]},
      { variable: 'amueblado', operator: 'is_true' },
    ],
  }
  assert.equal(evaluateCondition(c, answers), true)
})

test('compara números escritos como texto', () => {
  assert.equal(
    evaluateCondition({ variable: 'precio_renta', operator: 'greater_or_equal', value: '32000' }, answers),
    true
  )
})

test('ignora acentos y mayúsculas al comparar', () => {
  assert.equal(
    evaluateCondition({ variable: 'tipo_inmueble', operator: 'equals', value: 'RESIDENCIAL' }, answers),
    true
  )
})

test('el operador in acepta una lista', () => {
  assert.equal(
    evaluateCondition({ variable: 'tipo_inmueble', operator: 'in', value: ['comercial', 'residencial'] }, answers),
    true
  )
})

test('un operador inexistente devuelve falso en vez de romper', () => {
  assert.equal(
    evaluateCondition({ variable: 'mascotas', operator: 'no_existe' as never }, answers),
    false
  )
})

test('describe la condición en lenguaje legible', () => {
  const c: Condition = { op: 'AND', children: [
    { variable: 'mascotas', operator: 'is_true' },
    { variable: 'precio_renta', operator: 'greater_than', value: 20000 },
  ]}
  assert.match(describeCondition(c), /mascotas es verdadero y precio_renta es mayor que/)
})

/* ══════════════ REGLAS ══════════════ */

group('Motor de reglas')

const rules: TemplateRule[] = [
  {
    id: 'r1', name: 'Incluir cláusula de mascotas', sort_order: 1, is_active: true,
    conditions: { variable: 'mascotas', operator: 'is_true' },
    action: 'SHOW_CLAUSE', action_payload: { clause_id: 'c-mascotas' },
  },
  {
    id: 'r2', name: 'Exigir inventario si está amueblado', sort_order: 2, is_active: true,
    conditions: { variable: 'amueblado', operator: 'is_true' },
    action: 'SHOW_CLAUSE', action_payload: { clause_id: 'c-inventario' },
  },
  {
    id: 'r3', name: 'Avisar de renta alta', sort_order: 3, is_active: true,
    conditions: { variable: 'precio_renta', operator: 'greater_than', value: 100000 },
    action: 'WARN_USER', action_payload: { message: 'Renta elevada: confirma el monto.' },
  },
]

test('dispara la regla cuya condición se cumple', () => {
  const out = evaluateRules(rules, answers)
  assert.equal(out.forceClauseOn.has('c-mascotas'), true)
})

test('no dispara la regla cuya condición no se cumple', () => {
  const out = evaluateRules(rules, answers)
  assert.equal(out.forceClauseOn.has('c-inventario'), false)
})

test('no emite la advertencia si no procede', () => {
  const out = evaluateRules(rules, answers)
  assert.equal(out.warnings.length, 0)
})

test('emite la advertencia cuando procede', () => {
  const out = evaluateRules(rules, { ...answers, precio_renta: 150000 })
  assert.equal(out.warnings[0], 'Renta elevada: confirma el monto.')
})

test('una regla desactivada no se dispara', () => {
  const out = evaluateRules([{ ...rules[0], is_active: false }], answers)
  assert.equal(out.forceClauseOn.size, 0)
})

/* ══════════════ VARIABLES ══════════════ */

group('Variables')

const variables: Variable[] = [
  { id: 'v1', org_id: null, tag: 'arrendatario_nombre', label: 'Nombre del arrendatario', question: '¿Quién alquila?', help_text: null, data_type: 'person', options: [], default_value: null, validation_regex: null, validation_message: null, is_required: true, derived_config: null },
  { id: 'v2', org_id: null, tag: 'cedula_arrendatario', label: 'Cédula', question: null, help_text: null, data_type: 'cedula', options: [], default_value: null, validation_regex: null, validation_message: null, is_required: true, derived_config: null },
  { id: 'v3', org_id: null, tag: 'precio_renta', label: 'Renta mensual', question: '¿Cuánto se paga al mes?', help_text: null, data_type: 'currency', options: [], default_value: null, validation_regex: null, validation_message: null, is_required: true, derived_config: { transform: 'monto_letras', currency: 'DOP', as: 'precio_renta_letras' } },
  { id: 'v4', org_id: null, tag: 'fecha_inicio', label: 'Inicio', question: null, help_text: null, data_type: 'date', options: [], default_value: null, validation_regex: null, validation_message: null, is_required: false, derived_config: null },
]

const formAnswers = {
  arrendatario_nombre: 'María Fernández Peralta',
  cedula_arrendatario: '40224567897',
  precio_renta: 32000,
  fecha_inicio: '2026-09-01',
}

test('normaliza la etiqueta de una variable', () => {
  assert.equal(normalizeTag('Precio de la Renta (mensual)'), 'precio_de_la_renta_mensual')
})

test('formatea la cédula al sustituirla', () => {
  const subs = buildSubstitutions(variables, formAnswers)
  assert.equal(subs.cedula_arrendatario, '402-2456789-7')
})

test('formatea el monto al sustituirlo', () => {
  const subs = buildSubstitutions(variables, formAnswers)
  assert.equal(subs.precio_renta, 'RD$32,000.00')
})

test('genera la variable derivada del monto en letras', () => {
  const subs = buildSubstitutions(variables, formAnswers)
  assert.match(subs.precio_renta_letras, /TREINTA Y DOS MIL PESOS DOMINICANOS/)
})

test('sustituye las etiquetas del texto', () => {
  const subs = buildSubstitutions(variables, formAnswers)
  const r = substitute('El señor {{arrendatario_nombre}} paga {{precio_renta}}.', subs, { variables })
  assert.equal(r.text, 'El señor María Fernández Peralta paga RD$32,000.00.')
  assert.equal(r.missing.length, 0)
})

test('avisa de las etiquetas sin valor en vez de dejarlas crudas', () => {
  const subs = buildSubstitutions(variables, formAnswers)
  const r = substitute('Domicilio: {{direccion_inmueble}}', subs, { variables })
  assert.equal(r.missing.includes('direccion_inmueble'), true)
  assert.equal(r.text.includes('{{'), false)
})

test('detecta una cédula inválida en el formulario', () => {
  const errs = validateAnswers(variables, { ...formAnswers, cedula_arrendatario: '40224567894' })
  assert.equal(errs.some((e) => e.tag === 'cedula_arrendatario'), true)
})

test('exige los campos obligatorios', () => {
  const errs = validateAnswers(variables, { precio_renta: 32000 })
  assert.equal(errs.some((e) => e.tag === 'arrendatario_nombre'), true)
})

test('una regla puede hacer obligatorio un campo opcional', () => {
  const errs = validateAnswers(variables, formAnswers, { required: new Set(['fecha_inicio']) })
  assert.equal(errs.length, 0, 'fecha_inicio sí tiene valor')

  const errs2 = validateAnswers(variables, { ...formAnswers, fecha_inicio: '' }, { required: new Set(['fecha_inicio']) })
  assert.equal(errs2.some((e) => e.tag === 'fecha_inicio'), true)
})

test('un campo oculto por una regla no se exige', () => {
  const errs = validateAnswers(variables, {}, { hidden: new Set(['arrendatario_nombre', 'cedula_arrendatario', 'precio_renta']) })
  assert.equal(errs.length, 0)
})

/* ══════════════ GENERACIÓN COMPLETA ══════════════ */

group('Generación del documento')

const bundle: TemplateBundle = {
  template: { id: 't1', title: 'Contrato de Alquiler', version: '1.0' },
  variables,
  templateVariables: [],
  sections: [
    { id: 's1', template_id: 't1', title: 'Identificación', body: 'Comparece {{arrendatario_nombre}}, cédula {{cedula_arrendatario}}.', sort_order: 1, is_enabled: true, is_annex: false, condition: null },
    { id: 's2', template_id: 't1', title: 'Precio', body: 'La renta es de {{precio_renta_letras}}.', sort_order: 2, is_enabled: true, is_annex: false, condition: null },
    { id: 's3', template_id: 't1', title: 'Inventario', body: 'Se adjunta el inventario del mobiliario.', sort_order: 3, is_enabled: true, is_annex: true, condition: { variable: 'amueblado', operator: 'is_true' } },
  ],
  clauses: [
    { id: 'c-mascotas', org_id: null, slug: 'mascotas', title: 'Mascotas', family: 'Inmobiliarias', description: null, body: 'El arrendatario podrá mantener animales domésticos en el inmueble.', legal_reference: null, status: 'PUBLISHED' },
    { id: 'c-inventario', org_id: null, slug: 'inventario', title: 'Inventario', family: 'Inmobiliarias', description: null, body: 'El mobiliario se entrega según el inventario anexo.', legal_reference: null, status: 'PUBLISHED' },
    { id: 'c-jurisdiccion', org_id: null, slug: 'jurisdiccion', title: 'Jurisdicción', family: 'Generales', description: null, body: 'Las partes eligen los tribunales de La Altagracia, Punta Cana.', legal_reference: null, status: 'PUBLISHED' },
  ],
  templateClauses: [
    { id: 'tc1', clause_id: 'c-mascotas', section_id: 's2', kind: 'CONDITIONAL', is_default_on: false, sort_order: 1, condition: { variable: 'mascotas', operator: 'is_true' } },
    { id: 'tc2', clause_id: 'c-inventario', section_id: 's2', kind: 'CONDITIONAL', is_default_on: false, sort_order: 2, condition: { variable: 'amueblado', operator: 'is_true' } },
    { id: 'tc3', clause_id: 'c-jurisdiccion', section_id: null, kind: 'MANDATORY', is_default_on: true, sort_order: 3, condition: null },
  ],
  rules: [],
}

const base = { ...formAnswers, mascotas: false, amueblado: false }

test('TEST 2 · con mascotas activadas la cláusula aparece', () => {
  const r = renderDocument(bundle, { ...base, mascotas: true })
  assert.equal(r.text.includes('animales domésticos'), true)
})

test('TEST 3 · con mascotas desactivadas la cláusula desaparece', () => {
  const r = renderDocument(bundle, { ...base, mascotas: false })
  assert.equal(r.text.includes('animales domésticos'), false)
})

test('TEST 4 · con inmueble amueblado aparece el inventario', () => {
  const r = renderDocument(bundle, { ...base, amueblado: true })
  assert.equal(r.text.includes('inventario anexo'), true)
  assert.equal(r.text.includes('ANEXOS'), true)
})

test('sin amueblar no hay anexo de inventario', () => {
  const r = renderDocument(bundle, { ...base, amueblado: false })
  assert.equal(r.text.includes('ANEXOS'), false)
})

test('la cláusula obligatoria entra siempre', () => {
  const r = renderDocument(bundle, base)
  assert.equal(r.text.includes('La Altagracia, Punta Cana'), true)
})

test('TEST 5 · el documento no deja ninguna variable sin sustituir', () => {
  const r = renderDocument(bundle, { ...base, mascotas: true, amueblado: true })
  assert.equal(r.text.includes('{{'), false, 'quedaron llaves crudas en el documento')
  assert.equal(r.missing.length, 0, `faltaron: ${r.missing.join(', ')}`)
})

test('vincular la cláusula basta: no hace falta marcador en el texto', () => {
  // Ninguna sección menciona {{mascotas}} ni un marcador de cláusula.
  const r = renderDocument(bundle, { ...base, mascotas: true })
  assert.equal(r.text.includes('animales domésticos'), true)
})

test('una regla que excluye gana sobre la condición cumplida', () => {
  const withRule: TemplateBundle = {
    ...bundle,
    rules: [{
      id: 'r-x', name: 'Prohibir mascotas en comercial', sort_order: 1, is_active: true,
      conditions: { variable: 'tipo_inmueble', operator: 'equals', value: 'comercial' },
      action: 'HIDE_CLAUSE', action_payload: { clause_id: 'c-mascotas' },
    }],
  }
  const r = renderDocument(withRule, { ...base, mascotas: true, tipo_inmueble: 'comercial' })
  assert.equal(r.text.includes('animales domésticos'), false)
})

test('explica por qué entró o no entró cada cláusula', () => {
  const r = renderDocument(bundle, { ...base, mascotas: true })
  const mascotas = r.clauses.find((c) => c.clauseId === 'c-mascotas')
  assert.equal(mascotas?.reason, 'condicion-cumplida')
  const inventario = r.clauses.find((c) => c.clauseId === 'c-inventario')
  assert.equal(inventario?.reason, 'condicion-no-cumplida')
})

test('el monto sale en letras dentro del documento', () => {
  const r = renderDocument(bundle, base)
  assert.equal(r.text.includes('TREINTA Y DOS MIL PESOS DOMINICANOS'), true)
})

/* ══════════════ RESULTADO ══════════════ */

console.log(`\n${'─'.repeat(50)}`)
console.log(`${passed} pruebas superadas, ${failed} fallidas`)
if (failed > 0) process.exit(1)
