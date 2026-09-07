import type { Metadata } from 'next'
import Link from 'next/link'
import { createClient } from '@supabase/supabase-js'
import { Check, Minus } from 'lucide-react'
import PieLegal from '@/components/ui/PieLegal'
import { EMPRESA } from '@/lib/empresa'

export const metadata: Metadata = {
  title: { absolute: 'Precios · SAVE Documentos' },
  description:
    'Qué incluye cada plan de SAVE Documentos y cuánto cuesta, en pesos dominicanos. Empieza gratis, sin tarjeta.',
  alternates: { canonical: `${EMPRESA.url}/precios` },
}

/**
 * Se renderiza en cada visita, NO durante el build.
 *
 * Con `revalidate` esta pagina se prerenderizaba dentro del contenedor
 * de Docker, donde no existen las variables de Supabase, asi que el
 * HTML salia del build con el mensaje de error ya escrito y el primer
 * visitante de cada despliegue lo veia. Los planes son cuatro filas:
 * consultarlas en cada visita cuesta menos que anunciar un precio que
 * no es el que cobra la base de datos.
 */
export const dynamic = 'force-dynamic'

type Plan = {
  codigo: string
  nombre: string
  precio_dop: number
  plantillas_catalogo: number | null
  documentos_por_mes: number | null
  boveda_base: number
  boveda_por_integrante: number
  integrantes_incluidos: number
  precio_asiento_dop: number
  permite_equipo: boolean
  permite_importar: boolean
  orden: number
}

/**
 * Los planes NO están escritos en esta página.
 *
 * Se leen de la misma tabla que aplica los límites en la base de datos.
 * Escribirlos a mano aquí sería garantizar que algún día la página
 * anuncie treinta documentos y el sistema deje pasar cinco, y entonces
 * el cliente tendría razón y nosotros un problema.
 */
async function cargarPlanes(): Promise<Plan[]> {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL
  const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
  if (!url || !key) {
    console.error('[precios] faltan NEXT_PUBLIC_SUPABASE_URL o NEXT_PUBLIC_SUPABASE_ANON_KEY')
    return []
  }

  try {
    const anon = createClient(url, key, { auth: { persistSession: false } })
    const { data, error } = await anon
      .from('planes')
      .select('*')
      .neq('codigo', 'CANCELLED')
      .order('orden')
    if (error) {
      console.error('[precios] no se pudieron leer los planes:', error.message)
      return []
    }
    return (data ?? []) as Plan[]
  } catch (e) {
    console.error('[precios] fallo al consultar los planes:', e)
    return []
  }
}

const dop = (n: number) => `RD$${n.toLocaleString('es-DO')}`

export default async function PreciosPage() {
  const planes = await cargarPlanes()

  return (
    <div className="min-h-screen bg-slate-50 text-[#1A1A1A]">
      <main className="mx-auto max-w-[1100px] px-6 py-16 md:px-12 md:py-24">
        <Link href="/" className="text-sm text-[#414845] underline underline-offset-4 hover:text-[#0D2C24]">
          Volver al inicio
        </Link>

        <h1 className="mt-6 max-w-[16ch] font-serif text-4xl font-bold leading-tight tracking-tight text-[#0D2C24] md:text-5xl">
          Empieza gratis. Paga cuando te haga falta.
        </h1>
        <p className="mt-4 max-w-[60ch] text-lg text-[#414845]">
          Sin tarjeta para empezar y sin permanencia. Los precios están en pesos dominicanos e
          incluyen los impuestos que apliquen.
        </p>

        {planes.length === 0 ? (
          <p className="mt-12 rounded-xl border border-slate-200 bg-white p-6 text-[#414845]">
            No pudimos cargar los planes en este momento. Escríbenos a{' '}
            <a href={`mailto:${EMPRESA.correo}`} className="underline decoration-[#c5a059] underline-offset-4">
              {EMPRESA.correo}
            </a>{' '}
            y te los contamos.
          </p>
        ) : (
          <div className="mt-12 grid gap-6 md:grid-cols-3">
            {planes.map((p) => (
              <article
                key={p.codigo}
                className={
                  p.codigo === 'PREMIUM'
                    ? 'flex flex-col rounded-2xl border-2 border-[#0D2C24] bg-white p-7'
                    : 'flex flex-col rounded-2xl border border-slate-200 bg-white p-7'
                }
              >
                {p.codigo === 'PREMIUM' && (
                  <span className="mb-3 self-start rounded-full bg-[#0D2C24] px-3 py-1 text-[11px] font-bold uppercase tracking-wide text-white">
                    El más elegido
                  </span>
                )}

                <h2 className="font-serif text-2xl font-bold text-[#0D2C24]">{p.nombre}</h2>

                <p className="mt-3 flex items-baseline gap-1.5">
                  <span className="font-serif text-4xl font-bold text-[#0D2C24]">
                    {p.precio_dop === 0 ? 'Gratis' : dop(p.precio_dop)}
                  </span>
                  {p.precio_dop > 0 && <span className="text-sm text-[#6b7570]">al mes</span>}
                </p>

                <ul className="mt-6 flex-1 space-y-3 text-sm text-[#2c3330]">
                  <Linea si>
                    {p.plantillas_catalogo === null
                      ? 'Todas las plantillas del catálogo'
                      : `${p.plantillas_catalogo} plantillas del catálogo`}
                  </Linea>
                  <Linea si>
                    {p.documentos_por_mes === null
                      ? 'Documentos sin límite'
                      : `${p.documentos_por_mes} documentos al mes`}
                  </Linea>
                  <Linea si>
                    {p.boveda_por_integrante > 0
                      ? `${p.boveda_base} archivos en la bóveda, y ${p.boveda_por_integrante} más por cada integrante adicional`
                      : `${p.boveda_base} archivos en la bóveda`}
                  </Linea>
                  <Linea si>Tus propias plantillas, sin límite</Linea>
                  <Linea si={p.permite_importar}>Convertir un documento tuyo en plantilla</Linea>
                  <Linea si={p.permite_equipo}>
                    {p.permite_equipo
                      ? `Despacho con equipo · ${p.integrantes_incluidos + 1} personas incluidas`
                      : 'Trabajo en equipo'}
                  </Linea>
                  {p.permite_equipo && p.precio_asiento_dop > 0 && (
                    <Linea si>
                      Cada persona de más, {dop(p.precio_asiento_dop)} al mes
                    </Linea>
                  )}
                </ul>

                <Link
                  href="/register"
                  className={
                    p.codigo === 'PREMIUM'
                      ? 'mt-7 rounded-lg bg-[#0D2C24] px-5 py-3 text-center font-semibold text-white transition-opacity hover:opacity-90'
                      : 'mt-7 rounded-lg border border-[#0D2C24] px-5 py-3 text-center font-semibold text-[#0D2C24] transition-colors hover:bg-[#f5f2ed]'
                  }
                >
                  {p.precio_dop === 0 ? 'Crear mi cuenta gratis' : `Empezar con ${p.nombre}`}
                </Link>
              </article>
            ))}
          </div>
        )}

        <section className="mt-16 border-t border-slate-200 pt-10">
          <h2 className="font-serif text-2xl font-bold text-[#0D2C24]">Lo que conviene saber</h2>
          <dl className="mt-6 grid gap-6 md:grid-cols-2">
            <Pregunta q="¿Qué pasa si dejo de pagar?">
              Tienes siete días de gracia con todo funcionando. Después la cuenta queda en solo
              lectura: no puedes crear documentos nuevos, pero sigues abriendo y descargando todo lo
              que ya tenías. <strong>No borramos tus documentos.</strong>
            </Pregunta>
            <Pregunta q="¿Puedo cambiar de plan?">
              Sí, cuando quieras y sin permanencia. Al bajar de plan conservas todo lo que ya
              generaste; lo que cambia son los límites de ahí en adelante.
            </Pregunta>
            <Pregunta q="¿Los documentos son míos?">
              Siempre. Puedes descargarlos en Word o PDF cuando quieras, sin pedir permiso ni pagar
              nada extra.
            </Pregunta>
            <Pregunta q="¿SAVE me da asesoría legal?">
              No. SAVE redacta documentos; no sustituye a un abogado ni a un notario. Las plantillas
              del catálogo las revisa un profesional dominicano antes de publicarse, pero la decisión
              de usar un documento es tuya.
            </Pregunta>
          </dl>
        </section>
      </main>

      <PieLegal />
    </div>
  )
}

function Linea({ si, children }: { si: boolean; children: React.ReactNode }) {
  return (
    <li className={si ? 'flex gap-2.5' : 'flex gap-2.5 text-[#9aa39f]'}>
      {si ? (
        <Check size={17} className="mt-0.5 shrink-0 text-[#0D2C24]" />
      ) : (
        <Minus size={17} className="mt-0.5 shrink-0" />
      )}
      <span>{children}</span>
    </li>
  )
}

function Pregunta({ q, children }: { q: string; children: React.ReactNode }) {
  return (
    <div>
      <dt className="font-semibold text-[#0D2C24]">{q}</dt>
      <dd className="mt-1.5 text-[#414845]">{children}</dd>
    </div>
  )
}
