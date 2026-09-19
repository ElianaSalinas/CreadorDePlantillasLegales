import type { Metadata } from 'next'
import Link from 'next/link'
import { contarCatalogoPublicado, fraseDelCatalogo } from '@/lib/catalogo'
import { DOMICILIO, EMPRESA } from '@/lib/empresa'
import { OG_IMAGE } from '@/lib/og'
import DemoInteractiva from '@/components/site/DemoInteractiva'
import PasoRevelado from '@/components/site/PasoRevelado'
import {
  FileText,
  Braces,
  ClipboardList,
  CheckCheck,
  Upload,
  BadgeCheck,
  ListPlus,
  Users,
  ShieldCheck,
  Scale,
  Home,
  Building2,
  User,
  ArrowRight,
  PlayCircle,
  Download,
  Zap,
  ChevronDown,
} from 'lucide-react'

export const metadata: Metadata = {
  title: { absolute: 'SAVE Documentos — Crea documentos. Automatiza tu trabajo.' },
  description:
    'SAVE convierte los contratos que ya usas en plantillas inteligentes. Rellenas un formulario, ajustas en el editor y exportas en Word o PDF. Hecho para República Dominicana.',
  alternates: { canonical: 'https://savedocumentos.com' },
  openGraph: {
    type: 'website',
    locale: 'es_DO',
    url: 'https://savedocumentos.com',
    siteName: 'SAVE Documentos',
    title: 'SAVE Documentos — Crea documentos. Automatiza tu trabajo.',
    description:
      'Convierte los contratos que ya usas en plantillas inteligentes. Sin volver a empezar de cero.',
    images: OG_IMAGE,
  },
}

const FAQ = [
  {
    q: '¿De verdad puedo empezar gratis?',
    a: 'Sí. Creas tu cuenta y generas tus primeros documentos sin poner una tarjeta. Cuando el volumen crezca, ahí hablamos de un plan.',
  },
  {
    q: '¿Tengo que usar sus plantillas?',
    a: 'No. Puedes subir los documentos que ya usas y convertirlos en plantillas tuyas. La biblioteca es un punto de partida, no una obligación.',
  },
  {
    q: '¿Los documentos salen con marca de SAVE?',
    a: 'Nunca. Salen limpios, sin marcas de agua ni logotipos. El documento es tuyo y se ve como tuyo.',
  },
  {
    q: '¿Quién puede ver lo que guardo?',
    a: 'Solo tú y las personas que invites a tu despacho. Tu bóveda es privada y cada acceso queda registrado.',
  },
  {
    q: '¿SAVE reemplaza a mi abogado?',
    a: 'No, y no pretende hacerlo. SAVE es la herramienta con la que un profesional trabaja más rápido, no un sustituto del criterio jurídico.',
  },
]

const SITE_SCHEMA = {
  '@context': 'https://schema.org',
  '@graph': [
    {
      '@type': 'WebSite',
      '@id': `${EMPRESA.url}/#sitio`,
      name: EMPRESA.nombreComercial,
      alternateName: ['SAVE', 'Save Documentos'],
      url: EMPRESA.url,
      inLanguage: 'es-DO',
      publisher: { '@id': `${EMPRESA.url}/#empresa` },
    },
    {
      '@type': 'Organization',
      '@id': `${EMPRESA.url}/#empresa`,
      name: EMPRESA.nombreComercial,
      legalName: EMPRESA.nombreLegal,
      taxID: EMPRESA.rnc,
      url: EMPRESA.url,
      email: EMPRESA.correo,
      telephone: EMPRESA.telefonoE164,
      address: {
        '@type': 'PostalAddress',
        streetAddress: EMPRESA.calle,
        addressLocality: `${EMPRESA.sector}, ${EMPRESA.municipio}`,
        addressRegion: EMPRESA.provincia,
        addressCountry: 'DO',
      },
      contactPoint: {
        '@type': 'ContactPoint',
        contactType: 'customer support',
        email: EMPRESA.correo,
        telephone: EMPRESA.telefonoE164,
        areaServed: 'DO',
        availableLanguage: ['es'],
      },
    },
    {
      '@type': 'FAQPage',
      '@id': `${EMPRESA.url}/#faq`,
      mainEntity: FAQ.map((f) => ({
        '@type': 'Question',
        name: f.q,
        acceptedAnswer: { '@type': 'Answer', text: f.a },
      })),
    },
  ],
}

const NAV_LINKS = [
  { href: '#como-funciona', label: 'Cómo funciona' },
  { href: '#pruebalo', label: 'Pruébalo' },
  { href: '#automatizacion', label: 'Automatización' },
  { href: '#para-quien', label: 'Para quién es' },
  { href: '#plantillas', label: 'Plantillas' },
]

const PIPELINE = [
  {
    Icon: FileText,
    title: 'Plantilla',
    body: 'Tu contrato de siempre, o uno de la biblioteca. También puedes subir un Word que ya usas.',
  },
  {
    Icon: Braces,
    title: 'Variables',
    body: 'Nombres, cédulas, montos y fechas dejan de ser texto suelto y pasan a ser campos.',
  },
  {
    Icon: ClipboardList,
    title: 'Formulario',
    body: 'Rellenas los datos una vez. El documento se arma solo, sin buscar ni reemplazar.',
  },
]

const STEPS = [
  {
    n: '01',
    title: 'Elige o importa',
    body: 'Toma una plantilla de la biblioteca o sube el Word que llevas años usando. SAVE lo lee y te propone las variables.',
  },
  {
    n: '02',
    title: 'Rellena el formulario',
    body: 'Un campo por dato. Si el cliente ya está guardado, sus datos entran solos y no los escribes otra vez.',
  },
  {
    n: '03',
    title: 'Ajusta en el editor',
    body: 'Ningún caso es idéntico. Cambias lo que haga falta, añades una cláusula, y el resto queda intacto.',
  },
  {
    n: '04',
    title: 'Exporta y guarda',
    body: 'Word o PDF, con el formato limpio y sin marcas de agua. Queda archivado en tu bóveda privada.',
  },
]

const AUTOMATION = [
  {
    Icon: Upload,
    title: 'Sube tu Word y listo',
    body: 'No empiezas desde una plantilla ajena. Importas tus propios documentos y SAVE los convierte en plantillas editables.',
  },
  {
    Icon: BadgeCheck,
    title: 'Detecta lo dominicano',
    body: 'Reconoce y valida cédulas y RNC, entiende montos en RD$ y lee las fechas notariales escritas en letras.',
  },
  {
    Icon: ListPlus,
    title: 'Cláusulas reutilizables',
    body: 'Guarda la cláusula que siempre añades y colócala en cualquier documento sin buscarla en otro archivo.',
  },
  {
    Icon: User,
    title: 'Clientes y propiedades',
    body: 'Los datos que ya registraste se rellenan solos la próxima vez. El mismo inquilino no se escribe dos veces.',
  },
  {
    Icon: Users,
    title: 'Tu equipo, con control',
    body: 'El paralegal redacta, el titular aprueba. Cada cambio queda registrado con nombre y fecha.',
  },
  {
    Icon: ShieldCheck,
    title: 'Bóveda privada',
    body: 'Todo lo que generas queda guardado y cifrado, accesible solo para ti y las personas de tu despacho.',
  },
]

const AUDIENCES = [
  {
    Icon: Scale,
    title: 'Abogados y notarías',
    body: 'Poderes, actos, contratos y demandas con la formalidad que exige la práctica dominicana.',
  },
  {
    Icon: Home,
    title: 'Inmobiliarias',
    body: 'Alquileres, promesas de venta y recibos. La propiedad se guarda una vez y se reutiliza siempre.',
  },
  {
    Icon: Building2,
    title: 'Empresas',
    body: 'Contratos laborales, acuerdos comerciales y NDA sin pasar por el departamento legal cada vez.',
  },
  {
    Icon: User,
    title: 'Profesionales independientes',
    body: 'Propuestas, contratos de servicio y facturas con aspecto profesional, sin rehacerlos desde cero cada vez.',
  },
]

const CATEGORIES = [
  'Legal',
  'Inmobiliario',
  'Empresarial',
  'Laboral',
  'Financiero',
  'Comercial',
  'Administrativo',
  'Personal',
  'Vehículos',
  'Construcción',
]

export const revalidate = 300

export default async function HomePage() {
  const { plantillas } = await contarCatalogoPublicado()

  return (
    <div className="w-full bg-slate-50 text-[#1A1A1A]">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(SITE_SCHEMA) }}
      />

      {/* ═══════════ NAVBAR ═══════════ */}
      <header className="sticky top-0 z-50 border-b border-slate-200 bg-slate-50/90 backdrop-blur-md">
        <div className="mx-auto flex max-w-[1200px] items-center justify-between gap-8 px-6 py-4 md:px-12">
          <Link href="/" className="flex items-center gap-2.5">
            <span className="flex h-8 w-8 items-center justify-center rounded-[7px] bg-[#0D2C24] font-serif text-base font-bold text-white">
              S
            </span>
            <span className="font-serif text-[23px] font-bold tracking-tight text-[#0D2C24]">
              SAVE
            </span>
          </Link>

          <nav className="hidden items-center gap-8 lg:flex">
            {NAV_LINKS.map((l) => (
              <a
                key={l.href}
                href={l.href}
                className="text-sm font-medium text-slate-600 transition-colors hover:text-[#0D2C24]"
              >
                {l.label}
              </a>
            ))}
          </nav>

          <div className="flex items-center gap-2">
            <Link
              href="/login"
              className="hidden px-4 py-2.5 text-sm font-semibold text-[#0D2C24] transition-colors hover:text-[#164E3E] sm:block"
            >
              Iniciar sesión
            </Link>
            <Link
              href="/register"
              data-analitica="cta_click"
              data-analitica-etiqueta="cabecera"
              className="rounded-full bg-[#0D2C24] px-6 py-3 text-sm font-bold text-white shadow-sm transition-colors hover:bg-[#164E3E] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[#C5A059]"
            >
              Empieza gratis
            </Link>
          </div>
        </div>
      </header>

      {/* ═══════════ HÉROE ═══════════ */}
      <section className="relative overflow-hidden">
        <div aria-hidden className="pointer-events-none absolute inset-0">
          <div className="absolute -top-44 -right-28 h-[620px] w-[620px] rounded-full bg-[#c8eadd] opacity-35 blur-[90px]" />
          <div className="absolute -bottom-52 -left-40 h-[520px] w-[520px] rounded-full bg-[#ffdea5] opacity-40 blur-[100px]" />
        </div>

        <div className="relative mx-auto grid max-w-[1200px] items-center gap-16 px-6 py-20 md:px-12 lg:grid-cols-2 lg:py-24">
          <div className="flex flex-col items-start gap-6">
            <div className="flex items-center gap-2.5 rounded-full border border-slate-200 bg-white px-4 py-1.5 shadow-sm">
              <span className="h-[7px] w-[7px] rounded-full bg-[#C5A059]" />
              <span className="text-xs font-bold tracking-wide text-slate-600">
                Hecho para República Dominicana
              </span>
            </div>

            <h1 className="font-serif text-[42px] leading-[1.06] font-bold tracking-tight text-balance text-[#0D2C24] sm:text-[52px] lg:text-[62px]">
              Crea documentos.
              <br />
              <span className="relative inline-block">
                Automatiza tu trabajo.
                <svg
                  viewBox="0 0 100 10"
                  preserveAspectRatio="none"
                  aria-hidden
                  className="absolute -bottom-1.5 left-0 h-[11px] w-full text-[#C5A059]"
                >
                  <path
                    d="M0 6 Q 50 11 100 5"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="3"
                    strokeLinecap="round"
                  />
                </svg>
              </span>
            </h1>

            <p className="max-w-[520px] text-lg leading-relaxed text-slate-600 md:text-[19px]">
              Convierte los contratos que ya usas en plantillas inteligentes. Rellenas un
              formulario, ajustas lo que haga falta en el editor y exportas en Word o PDF. Sin
              volver a empezar de cero.
            </p>

            <div className="mt-1 flex flex-col gap-3.5 sm:flex-row sm:items-center">
              <Link
                href="/register"
                data-analitica="cta_click"
                data-analitica-etiqueta="heroe"
                className="flex items-center justify-center gap-2.5 rounded-full bg-[#0D2C24] px-8 py-4 text-[15px] font-bold text-white shadow-lg shadow-[#0D2C24]/20 transition-colors hover:bg-[#164E3E] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[#C5A059]"
              >
                Empieza gratis
                <ArrowRight size={17} />
              </Link>
              <a
                href="#como-funciona"
                className="flex items-center justify-center gap-2.5 rounded-full border border-slate-200 bg-white px-7 py-4 text-[15px] font-semibold text-[#0D2C24] transition-colors hover:bg-[#F5F2ED] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[#0D2C24]"
              >
                <PlayCircle size={17} />
                Ver cómo funciona
              </a>
            </div>

            <p className="text-[13px] text-slate-500">Gratis para empezar. Sin tarjeta de crédito.</p>
          </div>

          <div className="relative flex h-[470px] items-center justify-center">
            <div className="save-sheet relative w-[372px] max-w-full rounded-2xl border border-slate-200 bg-white px-8 pt-7 pb-8 shadow-[0_26px_60px_-20px_rgba(13,44,36,0.28)]">
              <div className="flex items-center justify-between border-b border-[#f1efe9] pb-4">
                <span className="font-serif text-sm font-bold text-[#0D2C24]">
                  Contrato de Alquiler
                </span>
                <span className="rounded-full bg-[#FDE8B5] px-2.5 py-1 text-[11px] font-bold tracking-wider text-[#7D6024]">
                  PLANTILLA
                </span>
              </div>

              <div className="flex flex-col gap-3.5 pt-5">
                <SkeletonLines widths={['100%', '84%']} />

                <VariableRow
                  placeholder="{{ arrendatario_nombre }}"
                  value="María Fernández Peralta"
                />
                <VariableRow placeholder="{{ cedula }}" value="001-1847362-8" delay={0.5} check />

                <SkeletonLines widths={['96%', '72%']} />

                <VariableRow
                  placeholder="{{ monto_mensual }}"
                  value="RD$ 32,000.00 mensuales"
                  delay={1}
                />

                <SkeletonLines widths={['90%', '58%']} />
              </div>
            </div>

            <div className="save-seal absolute flex flex-col items-center gap-4">
              <div className="flex h-[106px] w-[106px] items-center justify-center rounded-[26px] bg-[#0D2C24] shadow-[0_22px_44px_-14px_rgba(13,44,36,0.5)]">
                <span className="font-serif text-[54px] leading-none font-bold text-white">S</span>
              </div>
              <span className="font-serif text-[27px] font-bold tracking-tight text-[#0D2C24]">
                SAVE
              </span>
            </div>

            <div className="save-export absolute bottom-6 flex gap-2.5">
              {['Word', 'PDF'].map((f) => (
                <span
                  key={f}
                  className="flex items-center gap-1.5 rounded-full border border-slate-200 bg-white px-4 py-2.5 text-xs font-bold text-[#0D2C24] shadow-sm"
                >
                  <Download size={13} />
                  {f}
                </span>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* ═══════════ ANTES / CON SAVE ═══════════ */}
      {/*
        Reemplaza a "El dolor": mismo mensaje, con una comparación visual
        de dos tarjetas en vez de solo texto. Tamaños y padding (py-24,
        rounded-[18px], texto sm/base) a propósito iguales a los que ya
        usa "Qué es SAVE" más abajo, para que combine en proporción con
        el resto de la página — sin min-h-screen ni scroll-snap: en flujo
        normal, como todo lo demás.

        Los tiempos (30-45 min / 3-5 min) y el 85% son una ESTIMACIÓN
        razonable del proceso típico, no una medición sobre documentos
        reales: hoy no hay histórico de uso en producción para medirlo de
        verdad (ver D13 del plan, que por la misma razón descarta cifras y
        testimonios inventados). Por eso todo dice "aprox."
      */}
      <section className="relative z-10 -mt-8 rounded-t-[36px] shadow-[0_-14px_30px_-24px_rgba(13,44,36,0.18)] md:-mt-12 md:rounded-t-[52px] bg-[#0D2C24]">
        <PasoRevelado>
        <div className="mx-auto max-w-[1200px] px-6 py-20 md:px-12 md:py-24">
          <div className="mx-auto mb-14 flex max-w-[660px] flex-col items-center gap-4 text-center">
            <h2 className="font-serif text-[32px] leading-[1.12] font-bold tracking-tight text-balance text-white md:text-[44px]">
              Mucho menos trabajo para llegar a él
            </h2>
            <p className="text-[17px] leading-relaxed text-[#c8eadd]">
              Abrir el contrato del mes pasado, cambiar los nombres a mano y revisar tres veces que
              no quedó una cédula vieja en la cláusula seis. Con SAVE, esos mismos datos se
              rellenan una vez.
            </p>
          </div>

          <div className="mx-auto grid max-w-[1000px] items-center gap-5 lg:grid-cols-[1fr_auto_1fr]">
            {/* A mano */}
            <div className="flex flex-col gap-4 rounded-[18px] border border-white/10 bg-white/[0.04] p-7">
              <div className="flex items-center justify-between">
                <span className="flex items-center gap-2 text-xs font-bold tracking-[0.14em] text-white/50">
                  <FileText size={16} />A MANO
                </span>
                <span className="rounded-full bg-white/10 px-3 py-1 text-xs font-bold text-white/80">
                  30–45 min
                </span>
              </div>

              <ul className="flex flex-col gap-2.5 text-sm leading-relaxed text-[#c8eadd]">
                {[
                  'Buscar el contrato del mes pasado',
                  'Cambiar nombres, cédulas y montos a mano',
                  'Revisar que no quedó nada del cliente anterior',
                  'Dar formato de nuevo si algo se corrió',
                ].map((item) => (
                  <li key={item} className="flex gap-2.5">
                    <span
                      aria-hidden
                      className="mt-1.5 h-3 w-3 shrink-0 rounded-full border border-white/25"
                    />
                    {item}
                  </li>
                ))}
              </ul>

              <p className="mt-2 text-xs text-white/40">
                Mismo documento, mucho más trabajo manual.
              </p>
            </div>

            {/* Separador con el ahorro estimado */}
            <div className="flex items-center justify-center gap-3 lg:flex-col lg:gap-4">
              <ArrowRight size={20} className="hidden text-[#C5A059] lg:block" />
              <div className="flex h-[100px] w-[100px] shrink-0 flex-col items-center justify-center rounded-full border-2 border-[#C5A059] bg-[#0D2C24]">
                <span className="font-serif text-xl font-bold text-[#FDE8B5]">85%</span>
                <span className="px-2 text-center text-[10px] leading-tight text-white/60">
                  menos tiempo, aprox.
                </span>
              </div>
              <div aria-hidden className="h-6 w-[2px] rounded-full bg-[#C5A059]/40 lg:hidden" />
            </div>

            {/* Con SAVE */}
            <div className="flex flex-col gap-4 rounded-[18px] border border-[#C5A059]/30 bg-[#F5F2ED] p-7">
              <div className="flex items-center justify-between">
                <span className="flex items-center gap-2 text-xs font-bold tracking-[0.14em] text-[#7D6024]">
                  <span className="flex h-4 w-4 items-center justify-center rounded-[4px] bg-[#0D2C24] font-serif text-[10px] font-bold text-white">
                    S
                  </span>
                  CON SAVE
                </span>
                <span className="rounded-full bg-[#FDE8B5] px-3 py-1 text-xs font-bold text-[#7D6024]">
                  3–5 min
                </span>
              </div>

              <ul className="flex flex-col gap-2.5 text-sm leading-relaxed text-[#3a3a38]">
                {[
                  'Elegir la plantilla del contrato',
                  'Rellenar el formulario una sola vez',
                  'Exportar en Word o PDF, ya limpio',
                ].map((item) => (
                  <li key={item} className="flex gap-2.5">
                    <CheckCheck size={16} className="mt-0.5 shrink-0 text-[#0D2C24]" />
                    {item}
                  </li>
                ))}
              </ul>

              <p className="mt-2 text-xs text-slate-500">
                Más tiempo para lo que sí requiere tu criterio.
              </p>
            </div>
          </div>

          <div className="mx-auto mt-10 flex max-w-[700px] flex-wrap items-center justify-center gap-x-8 gap-y-3">
            {[
              { Icon: Zap, label: 'Más rápido' },
              { Icon: ShieldCheck, label: 'Menos errores' },
              { Icon: BadgeCheck, label: 'Documentos profesionales' },
            ].map(({ Icon, label }) => (
              <span key={label} className="flex items-center gap-2 text-sm font-semibold text-[#c8eadd]">
                <Icon size={16} className="text-[#C5A059]" />
                {label}
              </span>
            ))}
          </div>
        </div>
        </PasoRevelado>
      </section>

      {/* ═══════════ QUÉ ES SAVE ═══════════ */}
      <section className="relative z-10 -mt-8 rounded-t-[36px] shadow-[0_-14px_30px_-24px_rgba(13,44,36,0.18)] md:-mt-12 md:rounded-t-[52px] bg-white">
        <PasoRevelado>
        <div className="mx-auto max-w-[1200px] px-6 py-24 md:px-12">
          <SectionHead
            title="Un documento deja de ser un archivo y pasa a ser un sistema"
            body="En vez de guardar cien versiones de un mismo contrato, guardas una plantilla que sabe qué datos necesita. Cada documento nuevo sale de ahí, completo y consistente."
          />

          <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-4">
            {PIPELINE.map(({ Icon, title, body }) => (
              <article
                key={title}
                className="flex flex-col gap-3.5 rounded-[18px] border border-slate-200 bg-white p-7"
              >
                <span className="flex h-[42px] w-[42px] items-center justify-center rounded-xl bg-[#F5F2ED] text-[#0D2C24]">
                  <Icon size={21} strokeWidth={1.8} />
                </span>
                <h3 className="font-serif text-lg font-bold text-[#0D2C24]">{title}</h3>
                <p className="text-sm leading-relaxed text-slate-500">{body}</p>
              </article>
            ))}

            <article className="flex flex-col gap-3.5 rounded-[18px] border border-[#0D2C24] bg-[#0D2C24] p-7">
              <span className="flex h-[42px] w-[42px] items-center justify-center rounded-xl bg-white/10 text-[#FDE8B5]">
                <CheckCheck size={21} strokeWidth={1.8} />
              </span>
              <h3 className="font-serif text-lg font-bold text-white">Documento</h3>
              <p className="text-sm leading-relaxed text-[#c8eadd]">
                Listo para revisar, firmar y archivar. En Word o en PDF, como lo necesites.
              </p>
            </article>
          </div>
        </div>
        </PasoRevelado>
      </section>

      {/* ═══════════ CÓMO FUNCIONA ═══════════ */}
      <section id="como-funciona" className="relative z-10 -mt-8 rounded-t-[36px] shadow-[0_-14px_30px_-24px_rgba(13,44,36,0.18)] md:-mt-12 md:rounded-t-[52px] scroll-mt-20 bg-[#EAF3EC]">
        <div className="mx-auto max-w-[1200px] px-6 py-24 md:px-12">
          <SectionHead title="Cuatro pasos. Ninguno técnico." />

          <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
            {STEPS.map(({ n, title, body }, i) => (
              <PasoRevelado key={n} delayMs={i * 100}>
                <div className="flex flex-col gap-4">
                  <span className="font-serif text-[44px] leading-none font-bold text-[#7D6024]">
                    {n}
                  </span>
                  <h3 className="font-serif text-[19px] font-bold text-[#0D2C24]">{title}</h3>
                  <p className="text-sm leading-relaxed text-slate-600">{body}</p>
                </div>
              </PasoRevelado>
            ))}
          </div>
        </div>
      </section>

      {/* ═══════════ PRUÉBALO TÚ MISMO ═══════════ */}
      {/*
        Única pieza nueva que se conserva de la ronda de cambios de hoy: la
        demo interactiva (punto 4 de la Fase 12 del plan). Usa el mismo
        estilo simple de las demás secciones originales de esta página
        —sin min-h-screen ni scroll-snap—, para no desentonar con el resto,
        que volvió a como estaba antes.
      */}
      <section id="pruebalo" className="relative z-10 -mt-8 rounded-t-[36px] shadow-[0_-14px_30px_-24px_rgba(13,44,36,0.18)] md:-mt-12 md:rounded-t-[52px] scroll-mt-20 bg-white">
        <PasoRevelado>
        <div className="mx-auto max-w-[1000px] px-6 py-24 md:px-12">
          <SectionHead
            title="Sin registrarte. Con el motor real."
            body="Escribe unos datos y mira cómo se arma el texto, con la misma validación de cédula que usa SAVE de verdad."
          />
          <DemoInteractiva />
        </div>
        </PasoRevelado>
      </section>

      {/* ═══════════ AUTOMATIZACIÓN ═══════════ */}
      {/*
        A propósito NO son tarjetas como el resto del sitio: seis cajas
        blancas idénticas en fila no dejan nada memorable. Una lista con
        divisores rompe ese patrón sin inventar jerarquía donde no la hay
        (nada de números 01-06: estas seis funciones no son una secuencia,
        y la guía de diseño pide reservar los marcadores numerados para
        cuando sí lo son, como en "Cómo funciona").
      */}
      <section id="automatizacion" className="relative z-10 -mt-8 rounded-t-[36px] shadow-[0_-14px_30px_-24px_rgba(13,44,36,0.18)] md:-mt-12 md:rounded-t-[52px] scroll-mt-20 bg-slate-50">
        <PasoRevelado>
        <div className="mx-auto max-w-[1200px] px-6 py-24 md:px-12">
          <SectionHead
            title="La diferencia está en lo que no tienes que hacer"
            body="Cualquiera puede venderte plantillas. SAVE se ocupa del trabajo repetitivo que viene después."
          />

          <div className="mx-auto grid max-w-[880px] gap-x-12 md:grid-cols-2">
            {AUTOMATION.map(({ Icon, title, body }, i) => (
              <div
                key={title}
                className={`group flex gap-5 py-7 transition-colors ${
                  i < AUTOMATION.length - 2 ? 'border-b border-slate-200' : ''
                }`}
              >
                <Icon
                  size={26}
                  strokeWidth={1.6}
                  className="mt-0.5 shrink-0 text-[#0D2C24] transition-colors group-hover:text-[#C5A059]"
                />
                <div className="transition-transform duration-300 group-hover:translate-x-1">
                  <h3 className="font-serif text-[19px] font-bold text-[#0D2C24]">{title}</h3>
                  <p className="mt-1.5 text-[14.5px] leading-relaxed text-slate-500">{body}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
        </PasoRevelado>
      </section>

      {/* ═══════════ PARA QUIÉN ES ═══════════ */}
      {/*
        Cuatro tintes de marca distintos en vez de cuatro tarjetas blancas
        iguales: además de romper el patrón repetido, es una forma
        honesta de usar los colores de la marca como superficie real, no
        solo como acento decorativo en un ícono.
      */}
      <section id="para-quien" className="relative z-10 -mt-8 rounded-t-[36px] shadow-[0_-14px_30px_-24px_rgba(13,44,36,0.18)] md:-mt-12 md:rounded-t-[52px] scroll-mt-20 bg-white">
        <PasoRevelado>
        <div className="mx-auto max-w-[1200px] px-6 py-24 md:px-12">
          <SectionHead title="Si redactas lo mismo cada semana, es para ti" />

          <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-4">
            {AUDIENCES.map(({ Icon, title, body }, i) => {
              const estilos = [
                { bg: 'bg-[#0D2C24]', icon: 'text-[#FDE8B5]', h: 'text-white', p: 'text-[#c8eadd]' },
                { bg: 'bg-[#c8eadd]', icon: 'text-[#0D2C24]', h: 'text-[#0D2C24]', p: 'text-[#164E3E]' },
                { bg: 'bg-[#FDE8B5]', icon: 'text-[#7D6024]', h: 'text-[#0D2C24]', p: 'text-[#7D6024]' },
                { bg: 'bg-[#F5F2ED]', icon: 'text-[#0D2C24]', h: 'text-[#0D2C24]', p: 'text-slate-600' },
              ][i]
              return (
                <article
                  key={title}
                  className={`flex flex-col gap-3 rounded-[18px] ${estilos.bg} p-7 transition-transform duration-300 hover:-translate-y-1.5`}
                >
                  <Icon size={24} strokeWidth={1.7} className={estilos.icon} />
                  <h3 className={`font-serif text-[17px] font-bold ${estilos.h}`}>{title}</h3>
                  <p className={`text-sm leading-relaxed ${estilos.p}`}>{body}</p>
                </article>
              )
            })}
          </div>
        </div>
        </PasoRevelado>
      </section>

      {/* ═══════════ PLANTILLAS ═══════════ */}
      <section id="plantillas" className="relative z-10 -mt-8 rounded-t-[36px] shadow-[0_-14px_30px_-24px_rgba(13,44,36,0.18)] md:-mt-12 md:rounded-t-[52px] scroll-mt-20 bg-[#EAF3EC]">
        <PasoRevelado>
        <div className="mx-auto max-w-[1200px] px-6 py-24 md:px-12">
          <SectionHead
            title="Diez categorías, un mismo motor"
            body="SAVE no está encerrado en lo legal. Cualquier documento que repitas puede volverse una plantilla."
          />

          <div className="mx-auto flex max-w-[860px] flex-wrap justify-center gap-3">
            {CATEGORIES.map((c) => (
              <span
                key={c}
                className="rounded-full border border-slate-200 bg-white px-6 py-3 text-[15px] font-semibold text-[#0D2C24] transition-colors hover:border-[#0D2C24] hover:bg-[#0D2C24] hover:text-white"
              >
                {c}
              </span>
            ))}
          </div>

          <p className="mt-8 text-center text-sm text-slate-500">
            {fraseDelCatalogo(plantillas)}
          </p>
        </div>
        </PasoRevelado>
      </section>

      {/* ═══════════ FAQ ═══════════ */}
      <section className="relative z-10 -mt-8 rounded-t-[36px] shadow-[0_-14px_30px_-24px_rgba(13,44,36,0.18)] md:-mt-12 md:rounded-t-[52px] bg-slate-50">
        <PasoRevelado>
        <div className="mx-auto max-w-[840px] px-6 py-24 md:px-12">
          <h2 className="mb-12 text-center font-serif text-3xl leading-tight font-bold tracking-tight text-[#0D2C24] md:text-[38px]">
            Antes de que preguntes
          </h2>

          <div className="flex flex-col gap-3">
            {FAQ.map(({ q, a }) => (
              <details
                key={q}
                className="group rounded-2xl border border-slate-200 bg-white px-7 py-6 open:border-[#0D2C24]/20 transition-colors hover:border-slate-300"
              >
                <summary className="flex cursor-pointer list-none items-center justify-between gap-4 font-serif text-[17px] font-bold text-[#0D2C24] marker:content-none [&::-webkit-details-marker]:hidden">
                  {q}
                  <ChevronDown
                    size={18}
                    strokeWidth={2}
                    aria-hidden
                    className="shrink-0 text-slate-400 transition-transform duration-300 group-open:rotate-180 group-open:text-[#0D2C24]"
                  />
                </summary>
                <p className="mt-3 text-[15px] leading-relaxed text-slate-600">{a}</p>
              </details>
            ))}
          </div>
        </div>
        </PasoRevelado>
      </section>

      {/* ═══════════ CTA FINAL ═══════════ */}
      <section className="relative z-10 -mt-8 rounded-t-[36px] shadow-[0_-14px_30px_-24px_rgba(13,44,36,0.18)] md:-mt-12 md:rounded-t-[52px] relative overflow-hidden bg-[#0D2C24]">
        <PasoRevelado>
        <div
          aria-hidden
          className="pointer-events-none absolute -top-36 -right-20 h-[460px] w-[460px] rounded-full bg-[#C5A059] opacity-15 blur-[90px]"
        />

        <div className="relative mx-auto flex max-w-[800px] flex-col items-center gap-6 px-6 py-24 text-center md:px-12 md:py-28">
          <h2 className="font-serif text-4xl leading-[1.12] font-bold tracking-tight text-balance text-white md:text-[50px]">
            Tu tiempo vale más que redactar papeles
          </h2>
          <p className="max-w-[560px] text-lg leading-relaxed text-[#c8eadd]">
            Por eso existe SAVE. Empieza gratis hoy y recupera las horas que se te van escribiendo lo
            mismo de siempre.
          </p>
          <Link
            href="/register"
            data-analitica="cta_click"
            data-analitica-etiqueta="cierre"
            className="mt-2 flex items-center gap-2.5 rounded-full bg-white px-10 py-5 text-base font-bold text-[#0D2C24] shadow-2xl transition-transform hover:scale-[1.02] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[#C5A059]"
          >
            Empieza gratis
            <ArrowRight size={18} />
          </Link>
          <p className="text-[13px] text-[#c8eadd]/75">
            Sin tarjeta. Sin instalar nada. En español y pensado para RD.
          </p>
        </div>
        </PasoRevelado>
      </section>

      {/* ═══════════ FOOTER ═══════════ */}
      <footer className="relative z-10 -mt-8 rounded-t-[36px] bg-slate-50 shadow-[0_-14px_30px_-24px_rgba(13,44,36,0.18)] md:-mt-12 md:rounded-t-[52px]">
        <div className="mx-auto grid max-w-[1200px] gap-10 px-6 pt-14 pb-10 md:px-12 lg:grid-cols-[2fr_1fr_1fr_1fr]">
          <div className="flex flex-col gap-3.5">
            <div className="flex items-center gap-2.5">
              <span className="flex h-7 w-7 items-center justify-center rounded-[7px] bg-[#0D2C24] font-serif text-sm font-bold text-white">
                S
              </span>
              <span className="font-serif text-xl font-bold text-[#0D2C24]">SAVE</span>
            </div>
            <p className="max-w-[280px] text-[13.5px] leading-relaxed text-slate-500">
              Creación y automatización de documentos profesionales. Hecho en República Dominicana.
            </p>
          </div>

          <FooterCol
            title="PRODUCTO"
            links={[
              { href: '#como-funciona', label: 'Cómo funciona' },
              { href: '#automatizacion', label: 'Automatización' },
              { href: '#plantillas', label: 'Plantillas' },
            ]}
          />
          <FooterCol
            title="CUENTA"
            links={[
              { href: '/precios', label: 'Precios' },
              { href: '/register', label: 'Empieza gratis' },
              { href: '/login', label: 'Iniciar sesión' },
            ]}
          />
          <FooterCol
            title="LEGAL"
            links={[
              { href: '/quienes-somos', label: 'Quiénes somos' },
              { href: '/terminos', label: 'Términos' },
              { href: '/privacidad', label: 'Privacidad' },
              { href: '/contacto', label: 'Contacto' },
            ]}
          />
        </div>

        <div className="mx-auto max-w-[1200px] px-6 pb-11 md:px-12">
          <div className="flex flex-col justify-between gap-3 border-t border-slate-200 pt-6 sm:flex-row">
            <p className="text-[12.5px] text-slate-500">
              © {new Date().getFullYear()} {EMPRESA.nombreLegal} · RNC {EMPRESA.rnc} ·{' '}
              {EMPRESA.dominio}
            </p>
            <p className="text-[12.5px] text-slate-500">{DOMICILIO}</p>
          </div>
        </div>
      </footer>
    </div>
  )
}

/* ──────────────────────────── piezas reutilizadas ──────────────────────────── */

function SectionHead({
  title,
  body,
}: {
  title: string
  body?: string
}) {
  return (
    <div className="mx-auto mb-12 flex max-w-[620px] flex-col gap-4 text-center">
      <h2 className="font-serif text-[32px] leading-[1.12] font-bold tracking-tight text-balance text-[#0D2C24] md:text-[44px]">
        {title}
      </h2>
      {body && <p className="text-[17px] leading-relaxed text-slate-600">{body}</p>}
    </div>
  )
}

function FooterCol({
  title,
  links,
}: {
  title: string
  links: { href: string; label: string }[]
}) {
  return (
    <div className="flex flex-col gap-3">
      <span className="text-xs font-extrabold tracking-wider text-[#0D2C24]">{title}</span>
      {links.map((l) =>
        l.href.startsWith('#') ? (
          <a
            key={l.href}
            href={l.href}
            className="text-[13.5px] text-slate-500 transition-colors hover:text-[#0D2C24]"
          >
            {l.label}
          </a>
        ) : (
          <Link
            key={l.href}
            href={l.href}
            className="text-[13.5px] text-slate-500 transition-colors hover:text-[#0D2C24]"
          >
            {l.label}
          </Link>
        )
      )}
    </div>
  )
}

function SkeletonLines({ widths }: { widths: string[] }) {
  return (
    <div className="flex flex-col gap-[7px]">
      {widths.map((w, i) => (
        <div
          key={i}
          className="h-[7px] rounded-full bg-[#eef1ee]"
          style={{ width: w }}
          aria-hidden
        />
      ))}
    </div>
  )
}

/** Una línea del contrato: primero la variable sin rellenar, luego el dato real. */
function VariableRow({
  placeholder,
  value,
  delay = 0,
  check = false,
}: {
  placeholder: string
  value: string
  delay?: number
  check?: boolean
}) {
  const style = delay ? { animationDelay: `${delay}s` } : undefined

  return (
    <div className="relative h-[26px]">
      <span
        className="save-ghost absolute inset-0 flex items-center rounded-[7px] border border-dashed border-slate-300 bg-slate-50 px-2.5 font-mono text-xs text-slate-500"
        style={style}
      >
        {placeholder}
      </span>
      <span
        className="save-chip absolute inset-0 flex items-center gap-1.5 rounded-[7px] bg-[#c8eadd] px-2.5 text-[13px] font-semibold text-[#0D2C24]"
        style={style}
      >
        {value}
        {check && <CheckCheck size={12} strokeWidth={2.4} />}
      </span>
    </div>
  )
}
