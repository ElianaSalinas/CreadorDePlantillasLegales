// Contraste WCAG de los colores de marca sobre los fondos donde se usan.
// Se comprueba con numeros y no de vista: "se lee bien" no es un criterio.
const L = ([r,g,b]) => { const f=c=>{c/=255;return c<=0.03928?c/12.92:((c+0.055)/1.055)**2.4}
  return 0.2126*f(r)+0.7152*f(g)+0.0722*f(b) }
const H = h => [1,3,5].map(i=>parseInt(h.slice(i,i+2),16))
const R = (a,b) => { const l1=L(H(a)), l2=L(H(b)); const hi=Math.max(l1,l2), lo=Math.min(l1,l2)
  return (hi+0.05)/(lo+0.05) }

const FONDOS = { 'blanco':'#FFFFFF', 'crema-50':'#FAF8F5', 'crema-100':'#F5F2ED', 'dorado-claro':'#FDE8B5' }
const CASOS = [
  ['dorado oscuro (texto)', '#7D6024', ['blanco','crema-50','crema-100','dorado-claro'], 4.5],
  ['verde de marca (texto)', '#0D2C24', ['blanco','crema-50','crema-100'], 4.5],
  ['gris secundario',        '#414845', ['blanco','crema-50','crema-100'], 4.5],
  ['blanco sobre verde 600',      '#FFFFFF', [], 4.5],
]
let fallos = 0
for (const [nombre, color, fondos, min] of CASOS) {
  for (const f of fondos) {
    const r = R(color, FONDOS[f])
    const ok = r >= min
    if (!ok) fallos++
    console.log(`${ok?'OK  ':'MAL '} ${nombre.padEnd(24)} sobre ${f.padEnd(13)} ${r.toFixed(2)}:1  (min ${min})`)
  }
}
// El boton principal, al reves: texto claro sobre verde
const btn = R('#FFFFFF', '#2A5A4A')
console.log(`${btn>=4.5?'OK  ':'MAL '} blanco sobre boton verde 600      ${btn.toFixed(2)}:1  (min 4.5)`)
if (btn < 4.5) fallos++
console.log(fallos===0 ? '\nTODO PASA AA' : `\n${fallos} COMBINACIONES POR DEBAJO DEL MINIMO`)
process.exit(fallos===0?0:1)
