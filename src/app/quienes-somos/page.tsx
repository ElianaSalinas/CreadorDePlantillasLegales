import type { Metadata } from 'next'
import Link from 'next/link'
import { ShieldCheck, FileSearch, Lock, Building2 } from 'lucide-react'
import PieLegal from '@/components/ui/PieLegal'
import { DOMICILIO, EMPRESA } from '@/lib/empresa'
import { OG_IMAGE } from '@/lib/og'

export const metadata: Metadata = {
  title: { absolute: 'Quiénes somos · SAVE Documentos' },
  description:
    'SA&VE Comercial, S.R.L., RNC 132-28618-9, Verón, Higüey. Quién está detrás de SAVE Documentos y cómo se revisa el catálogo legal antes de que llegue a nadie.',
  alternates: { canonical: `${EMPRESA.url}/quienes-somos` },
  openGraph: {
    type: 'website',
    siteName: 'SAVE Documentos',
    locale: 'es_DO',
    url: `${EMPRESA.url}/quienes-somos`,
    title: 'Quiénes somos · SAVE Documentos',
    description:
      'Quién está detrás de SAVE Documentos y cómo se revisa el catálogo legal antes de que llegue a nadie.',
    images: OG_IMAGE,
  },
}

/**
 * Quiénes somos.
 *
 * ESTA PÁGINA NO AFIRMA QUE EL CATÁLOGO ESTÉ REVISADO.
 *
 * A día de hoy no lo está: las 251 plantillas y las 123 cláusulas
 * siguen en DRAFT esperando a la revisión de la Fase 2. Decir aquí
 * "revisadas por una abogada" sería mentir, y hacerlo justo en la
 * página cuyo único trabajo es que te crean sería el peor sitio
 * posible para hacerlo.
 *
 * Lo que sí se cuenta es el MECANISMO, que existe y se puede
 * comprobar: el catálogo nace en borrador, el público solo ve lo
 * publicado, la revisora tiene un permiso propio y estrecho, y la
 * base sella quién aprobó y cuándo.
 *
 * TAMPOCO se dice que el sistema "impida" publicar sin revisión. No lo
 * impide: un administrador de SA&VE puede publicar por su cuenta, y la
 * política de `templates_update` lo admite explícitamente. Lo que sí es
 * cierto es que quien no es ni administrador ni revisor no puede tocar
 * el catálogo maestro.
 *
 * Cuando la Fase 2 termine, aquí se añade el nombre de quien revisó y
 * la fecha, leídos de la base y no escritos a mano.
 */

const PIEZAS = [
  {
    icono: FileSearch,
    titulo: 'El catálogo nace en borrador',
    texto:
      'Ninguna plantilla del catálogo es visible por el hecho de existir. Entra en estado borrador y solo se publica cuando alguien con permiso de revisión la aprueba. Mientras tanto, no la ve nadie fuera de SAVE.',
  },
  {
    icono: ShieldCheck,
    titulo: 'Quien revisa no administra',
    texto:
      'La persona que revisa el catálogo tiene un permiso propio y estrecho: leer, corregir y aprobar plantillas y cláusulas. No puede crear catálogo, no puede borrarlo y no puede ver ni un solo documento de un cliente. Revisar textos legales no requiere nada de eso.',
  },
  {
    icono: Lock,
    titulo: 'Queda constancia de quién aprobó',
    texto:
      'La aprobación sella el nombre y la fecha en la propia base de datos, no en un registro aparte que haya que acordarse de escribir. Si una plantilla cambia, se archiva la anterior en vez de borrarla.',
  },
]

export default function QuienesSomosPage() {
  return (
    <div className="min-h-screen bg-slate-50 text-[#1A1A1A]">
      <main className="mx-auto max-w-[760px] px-6 py-16 md:px-12 md:py-24">
        <Link
          href="/"
          className="text-sm text-[#414845] underline underline-offset-4 hover:text-[#0D2C24]"
        >
          Volver al inicio
        </Link>

        <h1 className="mt-6 font-serif text-4xl font-bold leading-tight tracking-tight text-[#0D2C24] md:text-5xl">
          Quiénes somos
        </h1>
        <p className="mt-4 max-w-[58ch] text-lg text-[#414845]">
          SAVE Documentos lo hace <strong>{EMPRESA.nombreLegal}</strong>, una empresa dominicana
          con RNC {EMPRESA.rnc} y domicilio en {EMPRESA.municipio}, {EMPRESA.provincia}.
        </p>

        <section className="mt-12">
          <h2 className="font-serif text-2xl font-bold text-[#0D2C24]">Qué hacemos</h2>
          <p className="mt-3 max-w-[62ch] leading-relaxed text-[#2c3330]">
            Convertimos los contratos, actos y poderes que un despacho ya usa en plantillas que se
            rellenan solas. Escribes una vez las partes, las fechas y las cifras, y el documento
            sale armado y listo para exportar a Word o PDF. Está pensado para el derecho
            dominicano: las fechas notariales, las cédulas y los formatos son los de aquí, no una
            traducción de un producto de fuera.
          </p>
        </section>

        <section className="mt-12">
          <h2 className="font-serif text-2xl font-bold text-[#0D2C24]">
            Cómo se revisa el catálogo
          </h2>
          <p className="mt-3 max-w-[62ch] leading-relaxed text-[#2c3330]">
            Un catálogo de plantillas legales vale lo que valga su revisión. Por eso el proceso no
            es una promesa nuestra sino una restricción del propio sistema:
          </p>

          <div className="mt-6 space-y-4">
            {PIEZAS.map((p) => (
              <div
                key={p.titulo}
                className="flex gap-4 rounded-2xl border border-slate-200 bg-white p-6"
              >
                <span className="h-fit rounded-xl bg-[#f5f2ed] p-3 text-[#0D2C24]">
                  <p.icono size={22} />
                </span>
                <span>
                  <span className="block font-serif text-lg font-bold text-[#0D2C24]">
                    {p.titulo}
                  </span>
                  <span className="mt-1 block leading-relaxed text-[#2c3330]">{p.texto}</span>
                </span>
              </div>
            ))}
          </div>

          {/* La frase que evita que esta página envejezca mintiendo.
              Se quita cuando la Fase 2 termine, y se sustituye por el
              nombre y la fecha reales leídos de la base. */}
          <p className="mt-6 max-w-[62ch] rounded-lg border border-slate-200 bg-white p-4 text-[15px] leading-relaxed text-[#414845]">
            <strong className="text-[#0D2C24]">Dónde estamos ahora mismo:</strong> el catálogo
            está en revisión. Cuando termine, publicaremos aquí quién lo revisó y desde qué fecha.
            Hasta entonces preferimos no decir que está revisado, porque todavía no lo está.
          </p>
        </section>

        <section className="mt-12">
          <h2 className="font-serif text-2xl font-bold text-[#0D2C24]">
            SAVE no presta asesoría jurídica
          </h2>
          <p className="mt-3 max-w-[62ch] leading-relaxed text-[#2c3330]">
            Somos una herramienta, no un despacho. SAVE genera el documento que tú decides
            generar, con los datos que tú introduces. Elegir la figura correcta, comprobar que
            encaja con tu caso y responder por el resultado es trabajo del profesional que firma.
            Si no eres profesional del derecho y el asunto tiene peso, consulta a uno: lo que te
            ahorras en un formulario te lo puede costar un artículo mal elegido.
          </p>
        </section>

        <section className="mt-12 border-t border-slate-200 pt-8">
          <h2 className="font-serif text-2xl font-bold text-[#0D2C24]">Datos de la empresa</h2>
          <div className="mt-4 flex gap-4 rounded-2xl border border-slate-200 bg-white p-6">
            <span className="h-fit rounded-xl bg-[#f5f2ed] p-3 text-[#0D2C24]">
              <Building2 size={22} />
            </span>
            <div className="text-[15px] leading-relaxed text-[#2c3330]">
              <p className="font-serif text-lg font-bold text-[#0D2C24]">
                {EMPRESA.nombreLegal}
              </p>
              <p className="mt-1">RNC {EMPRESA.rnc}</p>
              <p className="mt-1">{DOMICILIO}</p>
              <p className="mt-3">
                <a
                  href={`mailto:${EMPRESA.correo}`}
                  className="font-semibold text-[#0D2C24] underline underline-offset-4"
                >
                  {EMPRESA.correo}
                </a>
                {' · '}
                <a
                  href={`tel:${EMPRESA.telefonoE164}`}
                  className="font-semibold text-[#0D2C24] underline underline-offset-4"
                >
                  {EMPRESA.telefono}
                </a>
              </p>
            </div>
          </div>

          <p className="mt-6 text-[15px] text-[#414845]">
            ¿Preguntas? <Link href="/contacto" className="font-semibold text-[#0D2C24] underline underline-offset-4">Escríbenos</Link>
            . También puedes leer los{' '}
            <Link href="/terminos" className="font-semibold text-[#0D2C24] underline underline-offset-4">términos</Link>{' '}
            y la{' '}
            <Link href="/privacidad" className="font-semibold text-[#0D2C24] underline underline-offset-4">política de privacidad</Link>.
          </p>
        </section>
      </main>

      <PieLegal />
    </div>
  )
}
