const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i
function rutaSinIdentificadores(ruta){
  return ruta.split('/').map(t=>{
    if (UUID.test(t)) return '[id]'
    if (t.length >= 20 && /^[0-9a-f]+$/i.test(t)) return '[id]'
    return t
  }).join('/')
}
const casos = [
  ['/', '/'],
  ['/precios', '/precios'],
  ['/quienes-somos', '/quienes-somos'],
  ['/register/revisa-tu-correo', '/register/revisa-tu-correo'],
  ['/app/documents', '/app/documents'],
  ['/app/templates/importar', '/app/templates/importar'],
  ['/app/documents/3f2a1b4c-5d6e-4f70-8a9b-0c1d2e3f4a5b', '/app/documents/[id]'],
  ['/app/documents/new/3f2a1b4c-5d6e-4f70-8a9b-0c1d2e3f4a5b', '/app/documents/new/[id]'],
  ['/app/templates/3f2a1b4c-5d6e-4f70-8a9b-0c1d2e3f4a5b/edit', '/app/templates/[id]/edit'],
  ['/app/documents/a1b2c3d4e5f60718293a4b5c6d7e8f90', '/app/documents/[id]'],
  // Los que la version anterior rompia: slugs de la Fase 6
  ['/plantillas/contrato-de-alquiler-2024', '/plantillas/contrato-de-alquiler-2024'],
  ['/plantillas/compraventa-de-vehiculo-de-motor', '/plantillas/compraventa-de-vehiculo-de-motor'],
  ['/plantillas/poder-especial-notarial-2026', '/plantillas/poder-especial-notarial-2026'],
]
let fallos=0
for (const [e,esp] of casos){ const r=rutaSinIdentificadores(e); const ok=r===esp; if(!ok)fallos++;
  console.log(ok?'OK  ':'MAL ', e, '->', r, ok?'':`(esperaba ${esp})`) }
console.log(fallos===0?'\nTODO CORRECTO':`\n${fallos} FALLOS`)
