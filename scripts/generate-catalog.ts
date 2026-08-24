/**
 * Genera la migración SQL del catálogo a partir de los datos en
 * scripts/catalog/. Se ejecuta con:  npm run catalog:build
 *
 * Todo se emite con status = 'DRAFT': nada llega a los usuarios hasta
 * que un abogado lo revise y publique.
 */

import { writeFileSync } from 'node:fs'
import { CLAUSES } from './catalog/clauses'
import { TEMPLATES, CIERRE } from './catalog/templates'
import { VARIABLE_META, inferType, inferLabel, type VarMeta } from './catalog/variables'

/** Escapa comillas simples para SQL. */
const q = (v: string | null | undefined) =>
  v === null || v === undefined ? 'NULL' : `'${String(v).replace(/'/g, "''")}'`

/** Título → slug estable. */
function slugify(text: string): string {
  return text
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .slice(0, 80)
}

/* ── Comprobaciones antes de emitir nada ── */

const clauseSlugs = new Set(CLAUSES.map((c) => c.slug))

// Cláusulas ya cargadas por la migración del arrendamiento.
const EXISTENTES = [
  'objeto-arrendamiento', 'vigencia-arrendamiento', 'terminacion-anticipada',
  'incumplimiento-desalojo', 'notificaciones', 'ley-aplicable-jurisdiccion',
  'integridad-contractual', 'precio-renta', 'deposito-garantia', 'mora-recargo',
  'uso-residencial', 'uso-comercial', 'mascotas', 'inventario-mobiliario',
  'mantenimiento-arrendador', 'reparaciones-menores', 'servicios-incluidos',
  'subarrendamiento-prohibido', 'subarrendamiento-permitido', 'remodelaciones',
  'devolucion-inmueble', 'estacionamiento',
]
EXISTENTES.forEach((s) => clauseSlugs.add(s))

const problemas: string[] = []

// Slugs duplicados dentro del archivo de cláusulas.
const vistos = new Set<string>()
for (const c of CLAUSES) {
  if (vistos.has(c.slug)) problemas.push(`Cláusula duplicada: ${c.slug}`)
  vistos.add(c.slug)
}

// Plantillas que referencian cláusulas inexistentes.
const titulosVistos = new Set<string>()
for (const [, title, , clauses] of TEMPLATES) {
  if (titulosVistos.has(title)) problemas.push(`Plantilla duplicada: ${title}`)
  titulosVistos.add(title)

  for (const slug of clauses) {
    if (!clauseSlugs.has(slug)) problemas.push(`"${title}" usa una cláusula inexistente: ${slug}`)
  }
}

for (const slug of CIERRE) {
  if (!clauseSlugs.has(slug)) problemas.push(`Cláusula de cierre inexistente: ${slug}`)
}

if (problemas.length > 0) {
  console.error('\nEl catálogo tiene errores. No se generó nada:\n')
  for (const p of [...new Set(problemas)]) console.error('  · ' + p)
  process.exit(1)
}

/* ── Emisión del SQL ── */

const lineas: string[] = []
const out = (s = '') => lineas.push(s)

out('-- ==========================================================')
out('-- SA&VE Comercial, S.R.L. — Punta Cana, República Dominicana')
out('-- CATÁLOGO COMPLETO · GENERADO AUTOMÁTICAMENTE')
out('--')
out('-- NO EDITAR A MANO. Este archivo lo produce:')
out('--   npm run catalog:build')
out('-- a partir de scripts/catalog/clauses.ts y templates.ts')
out('--')
out(`-- ⚠️  ${CLAUSES.length} cláusulas y ${TEMPLATES.length} plantillas, TODAS en estado DRAFT.`)
out('--     Ningún usuario las ve hasta que un abogado dominicano las')
out('--     revise y las publique. Al final hay instrucciones.')
out('-- ==========================================================')
out()

out('-- ══════════════ CLÁUSULAS ══════════════')
out()
for (const c of CLAUSES) {
  out('INSERT INTO clauses (org_id, slug, title, family, description, body, legal_reference, status)')
  out(`VALUES (NULL, ${q(c.slug)}, ${q(c.title)}, ${q(c.family)}, ${q(c.description)},`)
  out(`  ${q(c.body)},`)
  out(`  ${q(c.legal_reference ?? null)}, 'DRAFT')`)
  out('ON CONFLICT DO NOTHING;')
  out()
}

/* ── Variables: se derivan de lo que realmente piden las cláusulas ── */

function tagsOf(text: string): string[] {
  const out: string[] = []
  const re = /\{\{\s*([a-zA-Z0-9_]+)\s*(?:\|[^}]*)?\}\}/g
  let m: RegExpExecArray | null
  while ((m = re.exec(text)) !== null) out.push(m[1])
  return out
}

/** Etiquetas que ya existen por la migración del arrendamiento. */
const VARS_EXISTENTES = new Set([
  'arrendador_nombre','arrendador_cedula','arrendador_nacionalidad','arrendador_estado_civil','arrendador_domicilio',
  'arrendatario_nombre','arrendatario_cedula','arrendatario_nacionalidad','arrendatario_estado_civil','arrendatario_domicilio',
  'direccion_inmueble','tipo_inmueble','habitaciones','banos','parqueos','amueblado',
  'precio_renta','deposito_garantia','dia_pago','mora_porcentaje',
  'fecha_inicio','duracion_meses','fecha_finalizacion',
  'mascotas','mantenimiento_incluido','subarriendo_permitido','servicios_incluidos','inventario_descripcion',
  'ciudad_firma','fecha_firma',
])

/** Alias que produce una transformación; no son variables propias. */
const DERIVADAS = new Set([
  'precio_renta_letras','deposito_garantia_letras','fecha_inicio_larga','fecha_finalizacion_larga','fecha_firma_notarial',
])

// Qué etiquetas usa cada cláusula, para poder enlazar solo lo necesario.
const tagsPorClausula = new Map<string, string[]>()
for (const c of CLAUSES) tagsPorClausula.set(c.slug, tagsOf(c.body))

// Etiquetas de las secciones estándar que lleva toda plantilla generada.
const TAGS_SECCIONES = [
  'parte_primera_nombre','parte_primera_nacionalidad','parte_primera_cedula','parte_primera_domicilio',
  'parte_segunda_nombre','parte_segunda_nacionalidad','parte_segunda_cedula','parte_segunda_domicilio',
  'ciudad_firma','fecha_firma_notarial',
]

const todasLasTags = new Set<string>(TAGS_SECCIONES)
for (const tags of tagsPorClausula.values()) tags.forEach((t) => todasLasTags.add(t))

// Se crean solo las que no existen ya y no son alias derivados.
const nuevasVars = [...todasLasTags]
  .filter((t) => !VARS_EXISTENTES.has(t) && !DERIVADAS.has(t))
  .sort()

out('-- ══════════════ VARIABLES ══════════════')
out()
for (const tag of nuevasVars) {
  const meta: VarMeta = VARIABLE_META[tag] ?? { label: inferLabel(tag) }
  const type = meta.type ?? inferType(tag)
  const label = meta.label ?? inferLabel(tag)
  const derived = meta.derived
    ? `'${JSON.stringify(meta.derived).replace(/'/g, "''")}'::jsonb`
    : 'NULL'
  const options = meta.options
    ? `'${JSON.stringify(meta.options).replace(/'/g, "''")}'::jsonb`
    : `'[]'::jsonb`

  out('INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)')
  out(`VALUES (NULL, ${q(tag)}, ${q(label)}, ${q(meta.question ?? null)}, ${q(meta.help ?? null)},`)
  out(`  ${q(type)}::variable_data_type, ${options}, ${q(meta.default ?? null)}, ${meta.required === false ? 'false' : 'true'}, ${derived})`)
  out('ON CONFLICT DO NOTHING;')
  out()
}

out('-- ══════════════ PLANTILLAS ══════════════')
out()
out('DO $$')
out('DECLARE')
out('  v_template UUID;')
out('  v_cat      UUID;')
out('  s_partes   UUID;')
out('  s_cuerpo   UUID;')
out('  s_cierre   UUID;')
out('BEGIN')
out()

for (const [category, title, description, clauses] of TEMPLATES) {
  const slug = slugify(title)
  // El cierre va detrás, sin repetir lo que ya trae la plantilla.
  const todas = [...new Set([...clauses, ...CIERRE])]

  out(`  -- ── ${title} ──`)
  out(`  SELECT id INTO v_cat FROM template_categories WHERE slug = ${q(category)};`)
  out(`  SELECT id INTO v_template FROM templates WHERE slug = ${q(slug)};`)
  out('  IF v_template IS NULL THEN')
  out('    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)')
  out(`    VALUES (NULL, ${q(slug)}, ${q(title)}, ${q(description)},`)
  out(`      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)`)
  out('    RETURNING id INTO v_template;')
  out('  END IF;')
  out()
  out('  DELETE FROM template_clauses  WHERE template_id = v_template;')
  out('  DELETE FROM template_sections WHERE template_id = v_template;')
  out()
  out('  INSERT INTO template_sections (template_id, title, body, sort_order)')
  out(`  VALUES (v_template, 'Comparecientes',`)
  out(`    'ENTRE: {{parte_primera_nombre}}, {{parte_primera_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_primera_cedula}}, domiciliado(a) en {{parte_primera_domicilio}}, quien en lo adelante se denominará LA PRIMERA PARTE;`)
  out('')
  out(`Y DE LA OTRA PARTE: {{parte_segunda_nombre}}, {{parte_segunda_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral número {{parte_segunda_cedula}}, domiciliado(a) en {{parte_segunda_domicilio}}, quien en lo adelante se denominará LA SEGUNDA PARTE.`)
  out('')
  out(`SE HA CONVENIDO Y PACTADO LO SIGUIENTE:', 1)`)
  out('  RETURNING id INTO s_partes;')
  out()
  out('  INSERT INTO template_sections (template_id, title, body, sort_order)')
  out(`  VALUES (v_template, 'Cláusulas', NULL, 2) RETURNING id INTO s_cuerpo;`)
  out()
  out('  INSERT INTO template_sections (template_id, title, body, sort_order)')
  out(`  VALUES (v_template, 'Firmas',`)
  out(`    'Hecho y firmado en {{ciudad_firma}}, República Dominicana, {{fecha_firma_notarial}}, en dos (2) originales de un mismo tenor y efecto.`)
  out('')
  out('')
  out(`_______________________________          _______________________________`)
  out(`      LA PRIMERA PARTE                          LA SEGUNDA PARTE', 3)`)
  out('  RETURNING id INTO s_cierre;')
  out()
  out('  INSERT INTO template_clauses (template_id, clause_id, section_id, kind, sort_order)')
  out('  SELECT v_template, c.id, s_cuerpo, \'MANDATORY\', t.ord')
  out('  FROM (VALUES')
  out(todas.map((s, i) => `    (${q(s)}, ${i + 1})`).join(',\n'))
  out('  ) AS t(slug, ord)')
  out('  JOIN clauses c ON c.slug = t.slug AND c.org_id IS NULL;')
  out()

  // Solo las variables que las cláusulas de ESTA plantilla realmente usan.
  const tagsDeEsta = new Set<string>(TAGS_SECCIONES)
  for (const slug of todas) (tagsPorClausula.get(slug) ?? []).forEach((t) => tagsDeEsta.add(t))
  const tagsFinales = [...tagsDeEsta].filter((t) => !DERIVADAS.has(t)).sort()

  if (tagsFinales.length > 0) {
    out('  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)')
    out('  SELECT v_template, v.id, s_partes, t.ord')
    out('  FROM (VALUES')
    out(tagsFinales.map((t, i) => `    (${q(t)}, ${i + 1})`).join(',\n'))
    out('  ) AS t(tag, ord)')
    out('  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL')
    out('  ON CONFLICT DO NOTHING;')
    out()
  }
  out()
}

out('  RAISE NOTICE \'Catálogo cargado\';')
out('END $$;')
out()
out('-- ==========================================================')
out('-- PARA PUBLICAR, DESPUÉS DE LA REVISIÓN LEGAL')
out('-- ==========================================================')
out('--')
out('-- Publicar una cláusula concreta:')
out('--   UPDATE clauses SET status = \'PUBLISHED\',')
out('--     reviewed_by = (SELECT id FROM profiles WHERE email = \'abogado@ejemplo.do\'),')
out('--     reviewed_at = now()')
out('--   WHERE org_id IS NULL AND slug = \'g-fuerza-mayor\';')
out('--')
out('-- Publicar una plantilla (solo cuando TODAS sus cláusulas lo estén):')
out('--   UPDATE templates SET status = \'PUBLISHED\',')
out('--     reviewed_by = (SELECT id FROM profiles WHERE email = \'abogado@ejemplo.do\'),')
out('--     reviewed_at = now()')
out('--   WHERE slug = \'contrato-de-alquiler-de-local-comercial\';')

const destino = 'supabase/migrations/20260827000000_catalog_completo.sql'
writeFileSync(destino, lineas.join('\n') + '\n', 'utf-8')

/* ── Resumen ── */

const porFamilia = new Map<string, number>()
for (const c of CLAUSES) porFamilia.set(c.family, (porFamilia.get(c.family) ?? 0) + 1)

const porCategoria = new Map<string, number>()
for (const [cat] of TEMPLATES) porCategoria.set(cat, (porCategoria.get(cat) ?? 0) + 1)

console.log(`\nMigración escrita en ${destino}\n`)
console.log(`Cláusulas nuevas: ${CLAUSES.length}  (+22 del arrendamiento = ${CLAUSES.length + 22} en total)`)
for (const [f, n] of [...porFamilia].sort()) console.log(`  ${f.padEnd(16)} ${n}`)
console.log(`\nVariables nuevas: ${nuevasVars.length}  (+30 del arrendamiento)`)
console.log(`\nPlantillas: ${TEMPLATES.length}`)
for (const [c, n] of [...porCategoria].sort()) console.log(`  ${c.padEnd(16)} ${n}`)

const media = TEMPLATES.reduce((sum, [, , , cl]) => sum + new Set([...cl, ...CIERRE]).size, 0) / TEMPLATES.length
console.log(`\nCláusulas por plantilla (media): ${media.toFixed(1)}`)
console.log('Todo en estado DRAFT: ningún usuario lo ve hasta que se revise.\n')
