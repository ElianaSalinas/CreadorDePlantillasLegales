/**
 * Detecta y corrige texto con doble codificación UTF-8 ("mojibake"),
 * el tipo "clÃ¡usula" en vez de "cláusula".
 *
 * Cómo funciona: si un archivo UTF-8 se reinterpretó una vez como
 * Windows-1252/Latin1 y se volvió a guardar como UTF-8, cada carácter
 * acentuado quedó convertido en 2-3 caracteres "Ã..." con sentido. Este
 * script revierte exactamente esa operación: toma el texto tal como se
 * leyó (ya UTF-8 correcto a nivel de archivo), lo reinterpreta como
 * bytes Latin1, y decodifica esos bytes como UTF-8. Si el resultado no
 * tiene caracteres de reemplazo (�), fue una reconstrucción válida.
 *
 * Uso:
 *   node scripts/fix-mojibake.mjs           -> solo lista, no toca nada
 *   node scripts/fix-mojibake.mjs --write   -> aplica el arreglo
 */
import { readFileSync, writeFileSync } from 'fs'
import { readdirSync, statSync } from 'fs'
import { join, extname } from 'path'

const EXTENSIONS = new Set(['.ts', '.tsx', '.js', '.mjs', '.md', '.sql', '.json'])
const SKIP_DIRS = new Set(['node_modules', '.next', '.git', '.tmp-cartas', '.tmp-catalog', '.tmp-verify', '.tmp-import'])
const WRITE = process.argv.includes('--write')

function walk(dir, files = []) {
  for (const entry of readdirSync(dir)) {
    if (SKIP_DIRS.has(entry)) continue
    const full = join(dir, entry)
    const st = statSync(full)
    if (st.isDirectory()) walk(full, files)
    else if (EXTENSIONS.has(extname(entry))) files.push(full)
  }
  return files
}

/** Intenta revertir la doble codificación. Devuelve null si no aplica o no es segura. */
function tryFix(text) {
  if (!/Ã[\x80-\xBF]|â€[\x80-\x9F]/.test(text)) return null // no hay señales de mojibake

  const bytes = Buffer.from(text, 'latin1')
  const fixed = bytes.toString('utf8')

  // Si el resultado tiene caracteres de reemplazo, la reconstrucción no fue válida.
  if (fixed.includes('\uFFFD')) return null

  // Si no cambió nada, no hacía falta.
  if (fixed === text) return null

  return fixed
}

const root = process.cwd()
const files = walk(join(root, 'src')).concat(walk(join(root, 'scripts')))

let candidatos = 0
for (const file of files) {
  const original = readFileSync(file, 'utf8')
  const fixed = tryFix(original)
  if (fixed === null) continue

  candidatos++
  const rel = file.replace(root + '\\', '').replace(root + '/', '')

  if (WRITE) {
    writeFileSync(file, fixed, 'utf8')
    console.log(`ARREGLADO  ${rel}`)
  } else {
    console.log(`DETECTADO  ${rel}`)
  }
}

console.log(`\n${candidatos} archivo(s) ${WRITE ? 'arreglados' : 'con mojibake detectado'}.`)
if (!WRITE && candidatos > 0) {
  console.log('Corré de nuevo con --write para aplicar el arreglo.')
}
