import type { Metadata } from 'next'
import Link from 'next/link'
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
  },
}

/* Le dice a Google cómo se llama el sitio, para que al buscar "savedocumentos"
   muestre "SAVE Documentos" y no la URL pelada. */
const SITE_SCHEMA = {
  '@context': 'https://schema.org',
  '@type': 'WebSite',
  name: 'SAVE Documentos',
  alternateName: ['SAVE', 'Save Documentos'],
  url: 'https://savedocumentos.com',
}

const NAV_LINKS = [
  { href: '#como-funciona', label: 'Cómo funciona' },
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

export default function HomePage() {
  return (
    <div className="w-full bg-[#fcf9f8] text-[#1A1A1A]">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(SITE_SCHEMA) }}
      />

      {/* ═══════════ NAVBAR ═══════════ */}
      <header className="sticky top-0 z-50 border-b border-[#e8e5df] bg-[#fcf9f8]/90 backdrop-blur-md">
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
              className="rounded-full bg-[#0D2C24] px-6 py-3 text-sm font-bold text-white shadow-sm transition-colors hover:bg-[#164E3E]"
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
            <div className="flex items-center gap-2.5 rounded-full border border-[#e8e5df] bg-white px-4 py-1.5 shadow-sm">
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
                className="flex items-center justify-center gap-2.5 rounded-full bg-[#0D2C24] px-8 py-4 text-[15px] font-bold text-white shadow-lg shadow-[#0D2C24]/20 transition-colors hover:bg-[#164E3E]"
              >
                Empieza gratis
                <ArrowRight size={17} />
              </Link>
              <a
                href="#como-funciona"
                className="flex items-center justify-center gap-2.5 rounded-full border border-[#e8e5df] bg-white px-7 py-4 text-[15px] font-semibold text-[#0D2C24] transition-colors hover:bg-[#F5F2ED]"
              >
                <PlayCircle size={17} />
                Ver cómo funciona
              </a>
            </div>

            <p className="text-[13px] text-slate-500">Gratis para empezar. Sin tarjeta de crédito.</p>
          </div>

          {/* Escenario de la animación */}
          <div className="relative flex h-[470px] items-center justify-center">
            <div className="save-sheet relative w-[372px] max-w-full rounded-2xl border border-[#e8e5df] bg-white px-8 pt-7 pb-8 shadow-[0_26px_60px_-20px_rgba(13,44,36,0.28)]">
              <div className="flex items-center justify-between border-b border-[#f1efe9] pb-4">
                <span className="font-serif text-sm font-bold text-[#0D2C24]">
                  Contrato de Alquiler
                </span>
                <span className="rounded-full bg-[#FDE8B5] px-2.5 py-1 text-[11px] font-bold tracking-wider text-[#8E6D29]">
                  PLANTILLA
                </span>
              </div>

              <div className="flex flex-col gap-3.5 pt-5">
                <SkeletonLines widths={['100%', '84%']} />

                <VariableRow
                  placeholder="{{ arrendatario_nombre }}"
                  value="María Fernández Peralta"
                />
                <VariableRow placeholder="{{ cedula }}" value="001-1847362-4" delay={0.5} check />

                <SkeletonLines widths={['96%', '72%']} />

                <VariableRow
                  placeholder="{{ monto_mensual }}"
                  value="RD$ 32,000.00 mensuales"
                  delay={1}
                />

                <SkeletonLines widths={['90%', '58%']} />
              </div>
            </div>

            {/* El sello en que se convierte el documento */}
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
                  className="flex items-center gap-1.5 rounded-full border border-[#e8e5df] bg-white px-4 py-2.5 text-xs font-bold text-[#0D2C24] shadow-sm"
                >
                  <Download size={13} />
                  {f}
                </span>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* ═══════════ EL DOLOR ═══════════ */}
      <section className="bg-[#0D2C24]">
        <div className="mx-auto max-w-[900px] px-6 py-20 text-center md:px-12 md:py-24">
          <p className="font-serif text-xl leading-relaxed text-[#c8eadd] md:text-[26px]">
            Abrir el contrato del mes pasado, cambiar los nombres a mano, revisar tres veces que no
            quedó una cédula vieja escondida en la cláusula seis.
          </p>
          <p className="mt-7 font-serif text-2xl leading-snug font-bold text-white md:text-[30px]">
            Así se sigue trabajando en demasiados despachos del país.
          </p>
          <div className="mx-auto mt-9 h-[3px] w-14 rounded-full bg-[#C5A059]" />
        </div>
      </section>

      {/* ═══════════ QUÉ ES SAVE ═══════════ */}
      <section className="bg-[#fcf9f8]">
        <div className="mx-auto max-w-[1200px] px-6 py-24 md:px-12">
          <SectionHead
            eyebrow="QUÉ ES SAVE"
            title="Un documento deja de ser un archivo y pasa a ser un sistema"
            body="En vez de guardar cien versiones de un mismo contrato, guardas una plantilla que sabe qué datos necesita. Cada documento nuevo sale de ahí, completo y consistente."
          />

          <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-4">
            {PIPELINE.map(({ Icon, title, body }) => (
              <article
                key={title}
                className="flex flex-col gap-3.5 rounded-[18px] border border-[#e8e5df] bg-white p-7"
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
      </section>

      {/* ═══════════ CÓMO FUNCIONA ═══════════ */}
      <section
        id="como-funciona"
        className="scroll-mt-20 border-y border-[#e8e5df] bg-[#F5F2ED]"
      >
        <div className="mx-auto max-w-[1200px] px-6 py-24 md:px-12">
          <SectionHead eyebrow="CÓMO FUNCIONA" title="Cuatro pasos. Ninguno técnico." />

          <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
            {STEPS.map(({ n, title, body }) => (
              <div key={n} className="flex flex-col gap-4">
                <span className="font-serif text-[44px] leading-none font-bold text-[#8E6D29]">
                  {n}
                </span>
                <h3 className="font-serif text-[19px] font-bold text-[#0D2C24]">{title}</h3>
                <p className="text-sm leading-relaxed text-slate-600">{body}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ═══════════ AUTOMATIZACIÓN ═══════════ */}
      <section id="automatizacion" className="scroll-mt-20 bg-[#fcf9f8]">
        <div className="mx-auto max-w-[1200px] px-6 py-24 md:px-12">
          <SectionHead
            eyebrow="AUTOMATIZACIÓN"
            title="La diferencia está en lo que no tienes que hacer"
            body="Cualquiera puede venderte plantillas. SAVE se ocupa del trabajo repetitivo que viene después."
          />

          <div className="grid gap-5 md:grid-cols-2 lg:grid-cols-3">
            {AUTOMATION.map(({ Icon, title, body }) => (
              <article
                key={title}
                className="flex flex-col gap-4 rounded-[18px] border border-[#e8e5df] bg-white p-8"
              >
                <span className="flex h-11 w-11 items-center justify-center rounded-xl bg-[#c8eadd] text-[#0D2C24]">
                  <Icon size={22} strokeWidth={1.8} />
                </span>
                <h3 className="font-serif text-[19px] font-bold text-[#0D2C24]">{title}</h3>
                <p className="text-[14.5px] leading-relaxed text-slate-500">{body}</p>
              </article>
            ))}
          </div>
        </div>
      </section>

      {/* ═══════════ PARA QUIÉN ES ═══════════ */}
      <section id="para-quien" className="scroll-mt-20 border-t border-[#e8e5df] bg-[#F5F2ED]">
        <div className="mx-auto max-w-[1200px] px-6 py-24 md:px-12">
          <SectionHead
            eyebrow="PARA QUIÉN ES"
            title="Si redactas lo mismo cada semana, es para ti"
          />

          <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-4">
            {AUDIENCES.map(({ Icon, title, body }) => (
              <article
                key={title}
                className="flex flex-col gap-3 rounded-[18px] border border-[#e8e5df] bg-white p-7"
              >
                <Icon size={24} strokeWidth={1.7} className="text-[#0D2C24]" />
                <h3 className="font-serif text-[17px] font-bold text-[#0D2C24]">{title}</h3>
                <p className="text-sm leading-relaxed text-slate-500">{body}</p>
              </article>
            ))}
          </div>
        </div>
      </section>

      {/* ═══════════ PLANTILLAS ═══════════ */}
      <section id="plantillas" className="scroll-mt-20 bg-[#fcf9f8]">
        <div className="mx-auto max-w-[1200px] px-6 py-24 md:px-12">
          <SectionHead
            eyebrow="PLANTILLAS"
            title="Diez categorías, un mismo motor"
            body="SAVE no está encerrado en lo legal. Cualquier documento que repitas puede volverse una plantilla."
          />

          <div className="mx-auto flex max-w-[860px] flex-wrap justify-center gap-3">
            {CATEGORIES.map((c) => (
              <span
                key={c}
                className="rounded-full border border-[#e8e5df] bg-white px-6 py-3 text-[15px] font-semibold text-[#0D2C24]"
              >
                {c}
              </span>
            ))}
          </div>

          <p className="mt-8 text-center text-sm text-slate-500">
            [NÚMERO] plantillas listas desde el primer día, y las tuyas propias sin límite.
          </p>
        </div>
      </section>

      {/* ═══════════ FAQ ═══════════ */}
      <section className="border-t border-[#e8e5df] bg-[#F5F2ED]">
        <div className="mx-auto max-w-[840px] px-6 py-24 md:px-12">
          <h2 className="mb-12 text-center font-serif text-3xl leading-tight font-bold tracking-tight text-[#0D2C24] md:text-[38px]">
            Antes de que preguntes
          </h2>

          <div className="flex flex-col gap-1">
            {FAQ.map(({ q, a }) => (
              <div
                key={q}
                className="flex flex-col gap-2.5 rounded-2xl border border-[#e8e5df] bg-white px-7 py-6"
              >
                <h3 className="font-serif text-[17px] font-bold text-[#0D2C24]">{q}</h3>
                <p className="text-[15px] leading-relaxed text-slate-600">{a}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ═══════════ CTA FINAL ═══════════ */}
      <section className="relative overflow-hidden bg-[#0D2C24]">
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
            className="mt-2 flex items-center gap-2.5 rounded-full bg-white px-10 py-5 text-base font-bold text-[#0D2C24] shadow-2xl transition-transform hover:scale-[1.02]"
          >
            Empieza gratis
            <ArrowRight size={18} />
          </Link>
          <p className="text-[13px] text-[#c8eadd]/75">
            Sin tarjeta. Sin instalar nada. En español y pensado para RD.
          </p>
        </div>
      </section>

      {/* ═══════════ FOOTER ═══════════ */}
      <footer className="border-t border-[#e8e5df] bg-[#fcf9f8]">
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
              { href: '/register', label: 'Empieza gratis' },
              { href: '/login', label: 'Iniciar sesión' },
            ]}
          />
          <FooterCol
            title="LEGAL"
            links={[
              { href: '/terminos', label: 'Términos' },
              { href: '/privacidad', label: 'Privacidad' },
              { href: '/contacto', label: 'Contacto' },
            ]}
          />
        </div>

        <div className="mx-auto max-w-[1200px] px-6 pb-11 md:px-12">
          <div className="flex flex-col justify-between gap-3 border-t border-[#e8e5df] pt-6 sm:flex-row">
            <p className="text-[12.5px] text-slate-500">
              © 2026 SA&amp;VE Comercial, S.R.L. · RNC 132-28618-9 · savedocumentos.com
            </p>
            <p className="text-[12.5px] text-slate-500">Santo Domingo, República Dominicana</p>
          </div>
        </div>
      </footer>
    </div>
  )
}

/* ─────────────────────── piezas reutilizadas ─────────────────────── */

function SectionHead({
  eyebrow,
  title,
  body,
}: {
  eyebrow: string
  title: string
  body?: string
}) {
  return (
    <div className="mx-auto mb-14 flex max-w-[660px] flex-col gap-4 text-center">
      <span className="text-xs font-extrabold tracking-[0.14em] text-[#8E6D29]">{eyebrow}</span>
      <h2 className="font-serif text-3xl leading-tight font-bold tracking-tight text-balance text-[#0D2C24] md:text-[42px]">
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
