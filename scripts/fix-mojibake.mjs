/**
 * Detecta y corrige texto con doble codificación UTF-8 ("mojibake"):
 * "clÃ¡usula" en vez de "cláusula", "â€”" en vez de "—".
 *
 * Qué pasa: un archivo UTF-8 se leyó como Windows-1252 (lo que hace
 * Windows PowerShell 5.1 con Get-Content sin -Encoding) y se volvió a
 * guardar como UTF-8 (con BOM, si fue Set-Content -Encoding UTF8).
 * Cada letra acentuada queda en 2-4 caracteres raros.
 *
 * Cómo lo arregla, y por qué así:
 *  - Recorre TODO el repo (docs/ incluido), no solo src/ y scripts/.
 *  - Usa la tabla Windows-1252 (no latin1): "€", "”", "™"...
 *    son bytes 0x80-0x9F en cp1252, y latin1 los trataría mal.
 *  - Corrige secuencia a secuencia (cada grupo de 2-4 caracteres que
 *    forma un UTF-8 válido), no el archivo entero: así los archivos que
 *    mezclan texto sano y roto se arreglan sin estropear lo sano.
 *  - Quita el BOM que deja PowerShell.
 *
 * Uso:
 *   node scripts/fix-mojibake.mjs          -> lista, sale con código 1 si encuentra algo (sirve de verify:acentos)
 *   node scripts/fix-mojibake.mjs --write  -> aplica el arreglo
 */
import { readFileSync, writeFileSync, readdirSync, statSync } from 'fs'
import { join, extname, relative, sep } from 'path'

const EXTENSIONS = new Set(['.ts', '.tsx', '.js', '.mjs', '.cjs', '.jsx', '.md', '.sql', '.json',
  '.txt', '.css', '.html', '.ps1', '.yml', '.yaml', '.toml', '.svg', '.env.example'])
const SKIP_DIRS = new Set(['node_modules', '.next', '.git', '_to_delete', 'Claude outputs'])
// Archivos que citan mojibake a propósito (explican el problema).
const ALLOW = new Set([
  'scripts/fix-mojibake.mjs',
  'docs/SAVE-AUDITORIA-INTEGRAL.md',
  'docs/auditoria-acentos.md',
  'CONTEXTO-SAVE.txt',
])
const WRITE = process.argv.includes('--write')

// Tabla cp1252: byte -> carácter. Los 5 huecos (81, 8D, 8F, 90, 9D) quedan como U+0081..., igual que en Windows.
const CP1252_80_9F = [0x20ac, 0x81, 0x201a, 0x192, 0x201e, 0x2026, 0x2020, 0x2021, 0x2c6, 0x2030, 0x160, 0x2039, 0x152, 0x8d, 0x17d, 0x8f,
  0x90, 0x2018, 0x2019, 0x201c, 0x201d, 0x2022, 0x2013, 0x2014, 0x2dc, 0x2122, 0x161, 0x203a, 0x153, 0x9d, 0x17e, 0x178]
const byteToChar = (b) => String.fromCharCode(b >= 0x80 && b <= 0x9f ? CP1252_80_9F[b - 0x80] : b)
const charToByte = new Map()
for (let b = 0; b < 256; b++) charToByte.set(byteToChar(b), b)

const esc = (s) => s.replace(/[\\\]^-]/g, '\\$&')
const range = (a, z) => Array.from({ length: z - a + 1 }, (_, i) => byteToChar(a + i)).join('')
const CONT = `[${esc(range(0x80, 0xbf))}]`
const RE = new RegExp(`[${esc(range(0xf0, 0xf4))}]${CONT}{3}|[${esc(range(0xe0, 0xef))}]${CONT}{2}|[${esc(range(0xc2, 0xdf))}]${CONT}`, 'g')

function fixToken(tok) {
  const bytes = Buffer.from([...tok].map((c) => charToByte.get(c)))
  const s = bytes.toString('utf8')
  return s.includes('�') ? tok : s // si no es UTF-8 válido, no se toca
}

/** Devuelve { fixed, lines } o null si no hay nada que arreglar. */
function tryFix(text) {
  const hadBom = text.charCodeAt(0) === 0xfeff
  const body = hadBom ? text.slice(1) : text
  const lines = []
  const fixed = body.split('\n').map((line, i) => {
    const out = line.replace(RE, fixToken)
    if (out !== line) lines.push(i + 1)
    return out
  }).join('\n')
  if (lines.length === 0) return null
  return { fixed, lines, hadBom }
}

function walk(dir, files = []) {
  for (const entry of readdirSync(dir)) {
    if (SKIP_DIRS.has(entry) || entry.startsWith('.tmp-')) continue
    const full = join(dir, entry)
    const st = statSync(full)
    if (st.isDirectory()) walk(full, files)
    else if (EXTENSIONS.has(extname(entry)) || entry === 'CONTEXTO-SAVE.txt') files.push(full)
  }
  return files
}

const root = process.cwd()
let found = 0
for (const file of walk(root)) {
  const rel = relative(root, file).split(sep).join('/')
  if (ALLOW.has(rel)) continue
  const r = tryFix(readFileSync(file, 'utf8'))
  if (!r) continue
  found++
  if (WRITE) {
    writeFileSync(file, r.fixed, 'utf8') // UTF-8 sin BOM
    console.log(`ARREGLADO  ${rel}  (${r.lines.length} líneas${r.hadBom ? ', BOM quitado' : ''})`)
  } else {
    console.log(`DETECTADO  ${rel}  ${r.lines.length} líneas: ${r.lines.slice(0, 12).join(', ')}${r.lines.length > 12 ? '…' : ''}`)
  }
}

console.log(`\n${found} archivo(s) ${WRITE ? 'arreglados' : 'con mojibake'}.`)
if (!WRITE && found > 0) {
  console.log('Revisa el diff y corre de nuevo con --write para aplicar el arreglo.')
  process.exitCode = 1
}
