/**
 * Genera la migración SQL del catálogo de CARTAS a partir de
 * scripts/catalog/cartas.ts. Se ejecuta con:  npm run cartas:build
 *
 * Es un generador aparte del de contratos, no una copia de él.
 * La razón está explicada arriba en cartas.ts: una carta no tiene
 * comparecientes ni cláusulas numeradas ni dos firmas. Lo que sí
 * comparte es el motor: son filas de `templates` con secciones y
 * variables, así que el editor, la vista previa y el PDF son los mismos.
 *
 * Todo se emite con status = 'DRAFT'. Nada llega a los usuarios hasta
 * que legalcifuentes@gmail.com o jmarquez@saveconsult.net lo revise.
 */

import { writeFileSync } from 'node:fs'
import { CARTAS, CATEGORIAS_CARTAS, META_CARTAS, TAGS_CARTA, SUSTITUYE,
  DESTINATARIO_ESTANDAR, DESPEDIDA_ESTANDAR, FIRMA_PERSONA } from './catalog/cartas'
import { TEMPLATES } from './catalog/templates'
import { VARIABLE_META, inferType, inferLabel, type VarMeta } from './catalog/variables'

/** Escapa comillas simples para SQL. */
const q = (v: string | null | undefined) =>
  v === null || v === undefined ? 'NULL' : `'${String(v).replace(/'/g, "''")}'`

/** Etiquetas {{...}} que aparecen en un texto. */
function tagsOf(text: string): string[] {
  const out: string[] = []
  const re = /\{\{\s*([a-zA-Z0-9_]+)\s*(?:\|[^}]*)?\}\}/g
  let m: RegExpExecArray | null
  while ((m = re.exec(text)) !== null) out.push(m[1])
  return out
}

/**
 * Los alias derivados no son variables: son el resultado de transformar
 * otra. {{monto_adeudado_letras}} lo produce monto_adeudado; si se
 * creara como variable propia, el usuario tendría que escribir el monto
 * dos veces y la plantilla se quedaría sin la que de verdad lo genera.
 *
 * La regla es del nombre, no de una lista: _letras viene de un monto,
 * _larga viene de una fecha. Así una carta nueva no necesita que nadie
 * se acuerde de registrar el alias en ningún sitio.
 */
function baseDelAlias(tag: string): { base: string; meta: VarMeta } | null {
  if (tag.endsWith('_letras')) {
    const base = tag.slice(0, -'_letras'.length)
    return { base, meta: { label: inferLabel(base), type: 'currency',
      derived: { transform: 'monto_letras', as: tag, currency: 'DOP' } } }
  }
  if (tag.endsWith('_larga')) {
    const base = tag.slice(0, -'_larga'.length)
    return { base, meta: { label: inferLabel(base), type: 'date',
      derived: { transform: 'fecha_larga', as: tag } } }
  }
  return null
}

/** Secciones completas de una carta, tal como se guardan. */
function seccionesDe(c: (typeof CARTAS)[number]) {
  const encabezado =
    `{{ciudad_firma}}, República Dominicana\n{{fecha_carta_larga}}\n\n` +
    `${c.destinatario ?? DESTINATARIO_ESTANDAR}\n\n` +
    `Asunto: ${c.asunto}`
  const firma = `${c.despedida ?? DESPEDIDA_ESTANDAR}\n\n\n${c.firma ?? FIRMA_PERSONA}`
  return [
    { titulo: 'Encabezado', cuerpo: encabezado },
    { titulo: 'Cuerpo', cuerpo: c.cuerpo },
    { titulo: 'Despedida y firma', cuerpo: firma },
  ]
}

/* ── Comprobaciones antes de emitir nada ── */

const problemas: string[] = []

const categoriasValidas = new Set(CATEGORIAS_CARTAS.map((c) => c.slug))
const slugsVistos = new Set<string>()
const titulosVistos = new Set<string>()

// Un título repetido entre cartas y contratos confunde al usuario en el
// buscador y hace que los revisores aprueben dos veces lo mismo.
const titulosDeContratos = new Set(TEMPLATES.map(([, t]) => t.toLowerCase()))

for (const c of CARTAS) {
  if (slugsVistos.has(c.slug)) problemas.push(`Carta duplicada (slug): ${c.slug}`)
  slugsVistos.add(c.slug)

  if (titulosVistos.has(c.titulo)) problemas.push(`Carta duplicada (título): ${c.titulo}`)
  titulosVistos.add(c.titulo)

  if (titulosDeContratos.has(c.titulo.toLowerCase()) && !SUSTITUYE[c.slug])
    problemas.push(`"${c.titulo}" ya existe como plantilla de contrato`)

  if (!categoriasValidas.has(c.categoria))
    problemas.push(`"${c.titulo}" usa una categoría que no se declara: ${c.categoria}`)

  if (!/^[a-z0-9-]+$/.test(c.slug))
    problemas.push(`Slug con caracteres no permitidos: ${c.slug}`)
}

/* Etiquetas: qué variable pide cada carta, resolviendo los alias. */

const META = { ...VARIABLE_META, ...META_CARTAS }
const tagsPorCarta = new Map<string, string[]>()
const todasLasVars = new Set<string>()
/** Alias → meta con la que hay que crear su variable base. */
const metaDeducida = new Map<string, VarMeta>()

for (const c of CARTAS) {
  const crudas = new Set<string>([...TAGS_CARTA, ...seccionesDe(c).flatMap((s) => tagsOf(s.cuerpo))])
  const reales = new Set<string>()

  for (const tag of crudas) {
    const alias = baseDelAlias(tag)
    if (alias) {
      reales.add(alias.base)
      // Si META ya trae la base, mandan sus etiquetas; si no, la deducida.
      if (!META[alias.base] && !metaDeducida.has(alias.base)) metaDeducida.set(alias.base, alias.meta)
      continue
    }
    // fecha_carta_larga se resuelve arriba; fecha_carta viene de TAGS_CARTA.
    reales.add(tag)
  }

  const lista = [...reales].sort()
  tagsPorCarta.set(c.slug, lista)
  lista.forEach((t) => todasLasVars.add(t))
}

// Una variable declarada como derivada tiene que producir un alias que
// alguna carta use de verdad; si no, el usuario rellena un campo que no
// aparece en ningún sitio.
const aliasUsados = new Set<string>()
for (const c of CARTAS) seccionesDe(c).forEach((s) => tagsOf(s.cuerpo).forEach((t) => aliasUsados.add(t)))
for (const v of todasLasVars) {
  const meta = META[v] ?? metaDeducida.get(v)
  if (meta?.derived && !aliasUsados.has(meta.derived.as))
    problemas.push(`La variable ${v} produce {{${meta.derived.as}}}, que ninguna carta usa`)
}

if (problemas.length > 0) {
  console.error('\nEl catálogo de cartas tiene errores. No se generó nada:\n')
  for (const p of [...new Set(problemas)]) console.error('  · ' + p)
  process.exit(1)
}

/* ── Emisión del SQL ── */

const lineas: string[] = []
const out = (s = '') => lineas.push(s)

out('-- ==========================================================')
out('-- SA&VE Comercial, S.R.L. — Punta Cana, República Dominicana')
out('-- CATÁLOGO DE CARTAS · GENERADO AUTOMÁTICAMENTE')
out('--')
out('-- NO EDITAR A MANO. Este archivo lo produce:')
out('--   npm run cartas:build')
out('-- a partir de scripts/catalog/cartas.ts')
out('--')
out(`-- ⚠️  ${CARTAS.length} cartas, TODAS en estado DRAFT.`)
out('--     Ningún usuario las ve hasta que un abogado dominicano las')
out('--     revise y las publique. Al final hay instrucciones.')
out('--')
out('-- Se puede ejecutar más de una vez sin duplicar nada.')
out('-- ==========================================================')
out()

out('-- ══════════════ CATEGORÍAS ══════════════')
out()
out('INSERT INTO template_categories (slug, name, sort_order) VALUES')
out(CATEGORIAS_CARTAS.map((c) => `  (${q(c.slug)}, ${q(c.nombre)}, ${c.orden})`).join(',\n'))
out('ON CONFLICT (slug) DO NOTHING;')
out()

out('-- ══════════════ VARIABLES ══════════════')
out()
for (const tag of [...todasLasVars].sort()) {
  const meta: VarMeta = META[tag] ?? metaDeducida.get(tag) ?? { label: inferLabel(tag) }
  const type = meta.type ?? inferType(tag)
  const derived = meta.derived
    ? `'${JSON.stringify(meta.derived).replace(/'/g, "''")}'::jsonb`
    : 'NULL'
  const options = meta.options
    ? `'${JSON.stringify(meta.options).replace(/'/g, "''")}'::jsonb`
    : `'[]'::jsonb`

  out('INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)')
  out(`VALUES (NULL, ${q(tag)}, ${q(meta.label ?? inferLabel(tag))}, ${q(meta.question ?? null)}, ${q(meta.help ?? null)},`)
  out(`  ${q(type)}::variable_data_type, ${options}, ${q(meta.default ?? null)}, ${meta.required === false ? 'false' : 'true'}, ${derived})`)
  out('ON CONFLICT DO NOTHING;')
  out()
}

out('-- ══════════════ CARTAS ══════════════')
out()

/** Línea donde termina cada carta, para poder cortar en archivos. */
const cortes: number[] = []

for (const c of CARTAS) {
  out(`-- ── ${c.titulo} ──`)
  out('DO $$')
  out('DECLARE')
  out('  v_template UUID;')
  out('  v_cat      UUID;')
  out('  s_encab    UUID;')
  out('BEGIN')
  out(`  SELECT id INTO v_cat FROM template_categories WHERE slug = ${q(c.categoria)};`)
  // Sin esto, la carta se insertaría con category_id NULL y quedaría
  // fuera de toda navegación, sin que nada avisara.
  out('  IF v_cat IS NULL THEN')
  out(`    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', ${q(c.categoria)};`)
  out('  END IF;')
  out()
  const viejo = SUSTITUYE[c.slug]
  if (viejo) {
    out(`  -- Esta carta sustituye a ${viejo}, que estaba montado como contrato.`)
    out(`  -- Solo se archiva si sigue en DRAFT: lo aprobado no se toca.`)
    out(`  UPDATE templates SET status = 'ARCHIVED'`)
    out(`  WHERE org_id IS NULL AND slug = ${q(viejo)} AND status = 'DRAFT';`)
    out()
  }
  out(`  SELECT id INTO v_template FROM templates WHERE slug = ${q(c.slug)};`)
  out('  IF v_template IS NULL THEN')
  out('    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)')
  out(`    VALUES (NULL, ${q(c.slug)}, ${q(c.titulo)}, ${q(c.descripcion)},`)
  const contenido = JSON.stringify(
    c.referencia ? { engine: 'v2', referencia_legal: c.referencia } : { engine: 'v2' },
  ).replace(/'/g, "''")
  out(`      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '${contenido}'::jsonb)`)
  out('    RETURNING id INTO v_template;')
  out('  END IF;')
  out()
  // Solo se reescribe lo que este generador produce. Si un revisor ya
  // publicó la carta, el texto se actualiza pero el estado no se toca:
  // volver a DRAFT algo aprobado sería peor que no actualizarlo.
  out('  DELETE FROM template_sections WHERE template_id = v_template;')
  out()

  const secciones = seccionesDe(c)
  secciones.forEach((s, i) => {
    out('  INSERT INTO template_sections (template_id, title, body, sort_order)')
    out(`  VALUES (v_template, ${q(s.titulo)},`)
    out(`    ${q(s.cuerpo)}, ${i + 1})`)
    if (i === 0) out('  RETURNING id INTO s_encab;')
    else out('  ;')
    out()
  })

  const tags = tagsPorCarta.get(c.slug) ?? []
  out('  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)')
  out('  SELECT v_template, v.id, s_encab, t.ord')
  out('  FROM (VALUES')
  out(tags.map((t, i) => `    (${q(t)}, ${i + 1})`).join(',\n'))
  out('  ) AS t(tag, ord)')
  out('  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL')
  out('  ON CONFLICT DO NOTHING;')
  out('END $$;')
  out()
  cortes.push(lineas.length)
}

out()
out('-- ==========================================================')
out('-- COMPROBACIÓN')
out('-- ==========================================================')
out('DO $$')
out('DECLARE v_n INT;')
out('BEGIN')
out(`  SELECT count(*) INTO v_n FROM templates WHERE org_id IS NULL AND slug IN (${CARTAS.map((c) => q(c.slug)).join(', ')});`)
out(`  IF v_n <> ${CARTAS.length} THEN`)
out(`    RAISE EXCEPTION 'Se esperaban ${CARTAS.length} cartas y hay %', v_n;`)
out('  END IF;')
// Una carta sin secciones sale en blanco al generarla, y eso no se ve
// hasta que un usuario la usa.
out('  SELECT count(*) INTO v_n FROM templates t')
out(`  WHERE t.org_id IS NULL AND t.slug IN (${CARTAS.map((c) => q(c.slug)).join(', ')})`)
out('    AND NOT EXISTS (SELECT 1 FROM template_sections s WHERE s.template_id = t.id);')
out('  IF v_n > 0 THEN')
out(`    RAISE EXCEPTION '% cartas se quedaron sin secciones', v_n;`)
out('  END IF;')
out(`  RAISE NOTICE 'OK: ${CARTAS.length} cartas cargadas en DRAFT, con sus secciones.';`)
out('END $$;')
out()
out('-- Para publicar una carta, DESPUÉS de la revisión legal:')
out("--   UPDATE templates SET status = 'PUBLISHED',")
out("--     reviewed_by = (SELECT id FROM profiles WHERE email = 'legalcifuentes@gmail.com'),")
out('--     reviewed_at = now()')
out("--   WHERE org_id IS NULL AND slug = 'carta-renuncia-voluntaria';")

/* ── Reparto en archivos que el SQL Editor de Supabase sí acepta ──
   Mismo problema que con los contratos: un archivo grande lo trunca el
   editor a media instrucción. Se corta por carta, nunca a mitad de una. */

const INICIO_CUERPO = lineas.findIndex((l) => l.includes('══ CATEGORÍAS ══'))
if (INICIO_CUERPO < 0) { console.error('No encontré el banner de categorías'); process.exit(1) }
const CABECERA = lineas.slice(0, INICIO_CUERPO)
const INICIO_CARTAS = lineas.findIndex((l) => l.includes('══ CARTAS ══'))

const CARTAS_POR_ARCHIVO = 20
const escritos: { archivo: string; kb: number }[] = []

function escribir(nombre: string, cuerpo: string[], nota: string) {
  const texto = [...CABECERA, `-- ${nota}`, '', ...cuerpo].join('\n') + '\n'
  writeFileSync(`supabase/migrations/${nombre}`, texto, 'utf-8')
  escritos.push({ archivo: nombre, kb: Math.round(Buffer.byteLength(texto) / 1024) })
}

const totalPartes = 1 + Math.ceil(cortes.length / CARTAS_POR_ARCHIVO)

escribir(
  '20260912000000_cartas_00_categorias.sql',
  lineas.slice(INICIO_CUERPO, INICIO_CARTAS),
  `PARTE 0 de ${totalPartes}: categorías y variables. Ejecutar PRIMERO.`,
)

let desde = INICIO_CARTAS
let parte = 1
for (let i = 0; i < cortes.length; i += CARTAS_POR_ARCHIVO) {
  const hasta = cortes[Math.min(i + CARTAS_POR_ARCHIVO, cortes.length) - 1]
  const numero = String(parte).padStart(2, '0')
  const ultima = i + CARTAS_POR_ARCHIVO >= cortes.length
  escribir(
    `202609120000${numero}_cartas_${numero}.sql`,
    // La comprobación final va con el último archivo: antes fallaría
    // por cartas que todavía no se han cargado.
    ultima ? lineas.slice(desde) : lineas.slice(desde, hasta),
    `PARTE ${parte} de ${totalPartes - 1}: cartas ${i + 1}–${Math.min(i + CARTAS_POR_ARCHIVO, cortes.length)}. Requiere la parte 0.`,
  )
  desde = hasta
  parte++
}

/* ── Hoja de revisión ──
   El SQL es para la base de datos; esto es para las personas. Cifuentes
   y Márquez no van a leer 155 KB de INSERT: leen este archivo, corrigen
   sobre él, y lo corregido vuelve a cartas.ts. */

const doc: string[] = []
const d = (s = '') => doc.push(s)

d('# Cartas para revisión legal')
d()
d('**SA&VE Comercial, S.R.L.** · Punta Cana, República Dominicana')
d()
d('> ⚠️ **NO EDITAR ESTE ARCHIVO.** Lo genera `npm run cartas:build` a partir')
d('> de `scripts/catalog/cartas.ts`. Lo que se corrija aquí se pierde en la')
d('> siguiente generación: las correcciones van a `cartas.ts`.')
d()
d(`Son **${CARTAS.length} cartas**, todas en estado \`DRAFT\`. Ningún usuario de la`)
d('plataforma las ve hasta que se aprueben. **Ninguna ha sido revisada todavía**')
d('por un abogado dominicano: lo que sigue es un borrador de trabajo.')
d()
d('Revisan: `legalcifuentes@gmail.com` y `jmarquez@saveconsult.net`.')
d()
d('### Cómo leerlas')
d()
d('Lo que va `{{entre llaves dobles}}` lo rellena el usuario al generar el')
d('documento; no es texto de la carta. Al final de cada una está la lista de')
d('lo que se le pregunta, para juzgar si falta o sobra alguna pregunta.')
d()
d('### Qué mirar')
d()
d('1. **Si el texto dice lo que debe decir** en derecho dominicano.')
d('2. **Si las advertencias son correctas** y si falta alguna. Van en')
d('   mayúsculas al final del cuerpo y son lo que separa una carta útil de')
d('   una que le cuesta un derecho a quien la firma.')
d('3. **Si la carta necesita notario** y no lo dice.')
d('4. **Si falta o sobra una pregunta** al usuario.')
d()
d('---')
d()

for (const cat of CATEGORIAS_CARTAS) {
  const suyas = CARTAS.filter((c) => c.categoria === cat.slug)
  if (suyas.length === 0) continue
  d(`## ${cat.nombre}`)
  d()
  for (const c of suyas) {
    d(`### ${c.titulo}`)
    d()
    d(`*${c.descripcion}*`)
    d()
    if (c.referencia) { d(`**Base legal indicada:** ${c.referencia}`); d() }
    d('```')
    d(seccionesDe(c).map((s) => s.cuerpo).join('\n\n'))
    d('```')
    d()
    const tags = tagsPorCarta.get(c.slug) ?? []
    d(`**Se le pregunta al usuario (${tags.length}):** ` +
      tags.map((t) => {
        const meta = META[t] ?? metaDeducida.get(t)
        return meta?.label ?? inferLabel(t)
      }).join(' · '))
    d()
    d(`<sub>\`${c.slug}\` · categoría \`${c.categoria}\`</sub>`)
    d()
    d('---')
    d()
  }
}

writeFileSync('docs/cartas-para-revision.md', doc.join('\n') + '\n', 'utf-8')

/* ── Resumen ── */

const porCategoria = new Map<string, number>()
for (const c of CARTAS) porCategoria.set(c.categoria, (porCategoria.get(c.categoria) ?? 0) + 1)

console.log('\nArchivos generados para el SQL Editor:')
for (const e of escritos) console.log(`  ${e.archivo}  ${String(e.kb).padStart(4)} KB`)

console.log(`\nCartas: ${CARTAS.length}`)
for (const [c, n] of [...porCategoria].sort()) {
  const nombre = CATEGORIAS_CARTAS.find((x) => x.slug === c)?.nombre ?? c
  console.log(`  ${nombre.padEnd(34)} ${n}`)
}
console.log(`\nVariables que usan: ${todasLasVars.size}`)
console.log(`  de ellas, deducidas por el nombre: ${[...todasLasVars].filter((t) => !META[t]).length}`)
const deducidas = [...todasLasVars].filter((t) => !META[t]).sort()
if (process.env.LISTAR_DEDUCIDAS) console.log('\nDeducidas:\n  ' + deducidas.join('\n  '))
console.log('\nHoja de revisión: docs/cartas-para-revision.md')
console.log('Todo en estado DRAFT: ningún usuario lo ve hasta que se revise.\n')
