// scripts/audit-dark-mode.mjs  (v3 — corrige bug de dual-duty + excluye patrones
// ya establecidos como intencionales en el propio código: botones de acción
// (bg-{emerald,red}-600 + text-white), texto de color sólido sobre {600,700,800}
// para emerald/red/amber (usado igual en los dos modos en todo el proyecto),
// ring- de foco, y overlays bg-slate-900/50).
//
// Uso: node scripts/audit-dark-mode.mjs [--scope=app|all] > reporte-dark-mode.txt

import { readFileSync } from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'
import fg from 'fast-glob'

const RAIZ = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..')
const SCOPE = (process.argv.find((a) => a.startsWith('--scope=')) || '--scope=app').split('=')[1]

const PREFIJOS = ['bg', 'text', 'border', 'divide', 'placeholder', 'from', 'via', 'to']

const COLORES = new Set([
  'slate', 'gray', 'zinc', 'neutral', 'stone', 'red', 'orange', 'amber',
  'yellow', 'lime', 'green', 'emerald', 'teal', 'cyan', 'sky', 'blue',
  'indigo', 'violet', 'purple', 'fuchsia', 'pink', 'rose', 'white', 'black',
])

const DUAL_DUTY_EXACTO = new Set(['slate-300', 'slate-400', 'emerald-300', 'emerald-400'])
function esDualDutyPorPatron(prefijo, colorBase) {
  if (DUAL_DUTY_EXACTO.has(colorBase)) return true
  if (prefijo !== 'text') return false
  const [familia, escala] = colorBase.split('-')
  if (!['emerald', 'red', 'amber'].includes(familia)) return false
  return ['600', '700', '800'].includes(escala)
}

function esOverlayONoNecesitaPorContexto(prefijo, colorBase, claseCompleta) {
  if (prefijo === 'bg' && colorBase === 'slate-900') return true
  if (prefijo === 'bg' && (colorBase === 'emerald-600' || colorBase === 'red-600')) {
    return /\btext-white\b/.test(claseCompleta)
  }
  return false
}

function extraerClases(contenido) {
  const resultados = []
  const regexAttr = /className\s*=\s*(\{[^}]*\}|"[^"]*"|'[^']*'|`[^`]*`)/g
  let m
  while ((m = regexAttr.exec(contenido))) {
    const bloque = m[1]
    const regexStr = /["'`]([^"'`]*)["'`]/g
    let s
    while ((s = regexStr.exec(bloque))) {
      const clase = s[1].trim()
      if (clase) {
        const linea = contenido.slice(0, m.index).split('\n').length
        resultados.push({ linea, clase })
      }
    }
  }
  return resultados
}

function esColorReal(resto) {
  if (resto === 'white' || resto === 'black') return true
  if (resto === 'transparent' || resto === 'current' || resto === 'inherit') return false
  const partes = resto.split('-')
  const familia = partes[0]
  if (!COLORES.has(familia)) return false
  const escala = partes[partes.length - 1].replace(/\/\d+$/, '')
  return /^(50|100|200|300|400|500|600|700|800|900|950)$/.test(escala)
}

function analizarClase(clase) {
  const tokens = clase.split(/\s+/).filter(Boolean)
  const claras = new Map()
  const oscuras = new Set()

  for (const t of tokens) {
    const esDark = /(^|:)dark:/.test(t)
    const sinDark = t.replace(/(^|:)dark:/, '$1')

    for (const p of PREFIJOS) {
      const re = new RegExp(`(^|:)${p}-(.+)$`)
      const mm = sinDark.match(re)
      if (!mm) continue
      const resto = mm[2]
      if (!esColorReal(resto)) continue
      const colorBase = resto.replace(/\/\d+$/, '')

      const modificador = sinDark.slice(0, sinDark.indexOf(mm[0]))
      const clave = `${modificador}${p}`

      if (esDark) {
        oscuras.add(clave)
        continue
      }

      if (esDualDutyPorPatron(p, colorBase)) continue
      if (esOverlayONoNecesitaPorContexto(p, colorBase, clase)) continue

      claras.set(clave, t)
    }
  }

  const faltantes = []
  for (const [clave, token] of claras) {
    if (!oscuras.has(clave)) faltantes.push(token)
  }
  return faltantes
}

async function main() {
  const patrones =
    SCOPE === 'app'
      ? ['src/app/app/**/*.tsx', 'src/app/app/**/*.ts', 'src/components/ui/**/*.tsx']
      : ['src/**/*.tsx', 'src/**/*.ts']

  const archivos = await fg(patrones, {
    cwd: RAIZ,
    ignore: ['**/_legacy/**', '**/node_modules/**'],
  })

  let totalHuecos = 0
  const porArchivo = []

  for (const rel of archivos) {
    const abs = path.join(RAIZ, rel)
    const contenido = readFileSync(abs, 'utf8')
    const clases = extraerClases(contenido)
    const huecos = []
    for (const { linea, clase } of clases) {
      const faltantes = analizarClase(clase)
      if (faltantes.length > 0) {
        huecos.push({ linea, clase, faltantes })
      }
    }
    if (huecos.length > 0) {
      porArchivo.push({ rel, huecos })
      totalHuecos += huecos.length
    }
  }

  porArchivo.sort((a, b) => b.huecos.length - a.huecos.length)

  console.log(`# Auditoría modo oscuro (scope=${SCOPE}) — ${archivos.length} archivos revisados, ${porArchivo.length} con huecos, ${totalHuecos} clases sin pareja dark:\n`)

  for (const { rel, huecos } of porArchivo) {
    console.log(`## ${rel}  (${huecos.length})`)
    for (const { linea, clase, faltantes } of huecos) {
      console.log(`  L${linea}: falta dark: para [${faltantes.join(', ')}]`)
      console.log(`      clase completa: ${clase}`)
    }
    console.log('')
  }
}

main()