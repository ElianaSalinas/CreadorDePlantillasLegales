import { CheckCheck, Download } from 'lucide-react'

/**
 * El mismo documento animado de la Welcome Page, en el panel lateral de
 * iniciar sesión y crear cuenta. Reutiliza las clases save-* de index.css,
 * así que la animación es una sola y no se duplica.
 *
 * Se oculta por debajo de lg: en un teléfono el formulario manda.
 */
export default function AuthShowcase() {
  return (
    <div className="relative hidden overflow-hidden bg-[#fcf9f8] lg:flex lg:flex-col lg:justify-center">
      <div aria-hidden className="pointer-events-none absolute inset-0">
        <div className="absolute -top-40 -right-24 h-[520px] w-[520px] rounded-full bg-[#c8eadd] opacity-40 blur-[90px]" />
        <div className="absolute -bottom-48 -left-32 h-[460px] w-[460px] rounded-full bg-[#ffdea5] opacity-45 blur-[100px]" />
      </div>

      <div className="relative flex flex-col items-center gap-10 px-12 py-16">
        <div className="relative flex h-[420px] w-full items-center justify-center">
          <div className="save-sheet relative w-[340px] rounded-2xl border border-[#e8e5df] bg-white px-7 pt-6 pb-7 shadow-[0_26px_60px_-20px_rgba(13,44,36,0.28)]">
            <div className="flex items-center justify-between border-b border-[#f1efe9] pb-3.5">
              <span className="font-serif text-sm font-bold text-[#0D2C24]">
                Contrato de Alquiler
              </span>
              <span className="rounded-full bg-[#FDE8B5] px-2.5 py-1 text-[11px] font-bold tracking-wider text-[#8E6D29]">
                PLANTILLA
              </span>
            </div>

            <div className="flex flex-col gap-3 pt-4">
              <Lines widths={['100%', '84%']} />
              <Row placeholder="{{ arrendatario_nombre }}" value="María Fernández Peralta" />
              <Row placeholder="{{ cedula }}" value="001-1847362-8" delay={0.5} check />
              <Lines widths={['96%', '72%']} />
              <Row placeholder="{{ monto_mensual }}" value="RD$ 32,000.00 mensuales" delay={1} />
              <Lines widths={['90%', '58%']} />
            </div>
          </div>

          <div className="save-seal absolute flex flex-col items-center gap-4">
            <div className="flex h-[96px] w-[96px] items-center justify-center rounded-[24px] bg-[#0D2C24] shadow-[0_22px_44px_-14px_rgba(13,44,36,0.5)]">
              <span className="font-serif text-[48px] leading-none font-bold text-white">S</span>
            </div>
            <span className="font-serif text-2xl font-bold tracking-tight text-[#0D2C24]">SAVE</span>
          </div>

          <div className="save-export absolute bottom-2 flex gap-2.5">
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

        <div className="max-w-[380px] text-center">
          <p className="font-serif text-2xl leading-snug font-bold text-[#0D2C24]">
            Crea documentos. Automatiza tu trabajo.
          </p>
          <p className="mt-3 text-sm leading-relaxed text-slate-600">
            Convierte los contratos que ya usas en plantillas que se rellenan solas.
          </p>
        </div>
      </div>
    </div>
  )
}

function Lines({ widths }: { widths: string[] }) {
  return (
    <div className="flex flex-col gap-[7px]" aria-hidden>
      {widths.map((w, i) => (
        <div key={i} className="h-[7px] rounded-full bg-[#eef1ee]" style={{ width: w }} />
      ))}
    </div>
  )
}

function Row({
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
    <div className="relative h-[26px]" aria-hidden>
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
