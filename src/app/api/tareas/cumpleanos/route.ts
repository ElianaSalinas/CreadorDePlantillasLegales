import { NextResponse, type NextRequest } from 'next/server'
import { createClient } from '@supabase/supabase-js'
import { toca, hoyEnRD, anosQueCumple } from '@/lib/cumpleanos'
import { enviarCorreo } from '@/lib/correo'
import { EMPRESA } from '@/lib/empresa'

export const dynamic = 'force-dynamic'

/** Tope por ejecución. Hostinger limita los envíos por hora, y un día
 *  con muchos cumpleaños no puede convertirse en un bloqueo del buzón
 *  que deje sin correo de confirmación a quien se está registrando. */
const TOPE = 40

export async function POST(request: NextRequest) {
  // Sin esto, cualquiera que descubra la URL puede disparar envíos.
  const clave = process.env.TAREAS_CLAVE
  if (!clave || request.headers.get('x-tarea-clave') !== clave) {
    console.error('[cumpleanos] llamada sin clave valida')
    return NextResponse.json({ error: 'no autorizado' }, { status: 401 })
  }

  const url = process.env.NEXT_PUBLIC_SUPABASE_URL
  const service = process.env.SUPABASE_SERVICE_ROLE_KEY
  if (!url || !service) {
    return NextResponse.json({ error: 'faltan credenciales de servidor' }, { status: 500 })
  }

  // Llave de servicio: hay que leer perfiles de TODOS los despachos, y
  // ninguna sesión de usuario puede -ni debe- hacer eso.
  const db = createClient(url, service, { auth: { persistSession: false } })
  const hoy = hoyEnRD()

  // Se traen los que tienen fecha y aun no han sido felicitados ESTE
  // ano, y el dia se decide en JavaScript con la funcion que esta
  // probada -huso de RD y 29 de febrero incluidos-. Con miles de
  // usuarios habria que filtrar el mes y el dia en SQL; con los de hoy,
  // traer la lista es mas simple y mucho mas facil de razonar.
  const { data, error } = await db
    .from('profiles')
    .select('id, email, first_name, fecha_nacimiento, cumple_felicitado_en')
    .eq('tipo_cuenta', 'PERSONA')
    .not('fecha_nacimiento', 'is', null)
    .or(`cumple_felicitado_en.is.null,cumple_felicitado_en.neq.${hoy.anio}`)

  if (error) {
    console.error('[cumpleanos] no se pudo leer la lista:', error.message)
    return NextResponse.json({ error: 'consulta fallida' }, { status: 500 })
  }

  const hoyCumplen = (data ?? []).filter((p) => toca(String(p.fecha_nacimiento)))
  let enviados = 0
  const fallos: string[] = []

  for (const p of hoyCumplen.slice(0, TOPE)) {
    const nombre = (p.first_name ?? '').trim() || 'Hola'
    const anos = anosQueCumple(String(p.fecha_nacimiento))

    const r = await enviarCorreo({
      para: p.email as string,
      asunto: `¡Feliz cumpleaños, ${nombre}!`,
      html: `<h2>¡Feliz cumpleaños, ${nombre}!</h2>
<p>Que tengas un año excelente. Gracias por confiar en SAVE Documentos para tu trabajo.</p>
<p style="color:#6b7280;font-size:13px">Si prefieres no recibir esto, puedes borrar tu fecha de nacimiento desde Mi Despacho.</p>`,
    })

    if (!r.ok) {
      fallos.push(p.email as string)
      continue
    }

    // Se marca INMEDIATAMENTE despues de cada envio, uno a uno, y no al
    // final en bloque: si el proceso se cae a la mitad, los ya enviados
    // quedan marcados y nadie recibe dos felicitaciones.
    const { error: errMarca } = await db
      .from('profiles')
      .update({ cumple_felicitado_en: hoy.anio })
      .eq('id', p.id)

    if (errMarca) {
      // Se avisa fuerte: quedo enviado pero sin marcar, y la proxima
      // ejecucion de hoy lo repetiria.
      console.error('[cumpleanos] ENVIADO PERO NO MARCADO:', p.id, errMarca.message)
    }
    enviados++
  }

  const resumen = {
    fecha: `${hoy.anio}-${String(hoy.mes).padStart(2, '0')}-${String(hoy.dia).padStart(2, '0')}`,
    candidatos: hoyCumplen.length,
    enviados,
    fallos: fallos.length,
    pendientes: Math.max(0, hoyCumplen.length - TOPE),
  }
  console.log('[cumpleanos]', JSON.stringify(resumen))
  return NextResponse.json(resumen)
}

/** GET solo para comprobar que la ruta existe, sin enviar nada. */
export async function GET() {
  return NextResponse.json({
    tarea: 'cumpleanos',
    uso: 'POST con la cabecera x-tarea-clave',
    zona: `${EMPRESA.pais}, UTC-4`,
  })
}
