'use client'

/**
 * Demo interactiva de la portada: prueba el motor real sin registrarse.
 *
 * A propósito usa las mismas funciones que usa el generador de verdad
 * (validateCedula, montoALetras, fechaLarga desde src/lib/engine/dominican.ts)
 * en vez de simular el formateo con texto fijo. Si mañana cambia una regla
 * ahí —por ejemplo cómo se escribe un monto en letras— esta demo cambia
 * sola, sin que alguien tenga que acordarse de mantenerla sincronizada.
 *
 * No guarda nada, no llama a ningún endpoint: todo el cálculo ocurre en
 * el navegador de quien visita la portada.
 */

import { useId, useState } from 'react'
import { CheckCheck, CircleAlert } from 'lucide-react'
import { validateCedula, formatMoney, montoALetras, fechaLarga } from '@/lib/engine/dominican'

export default function DemoInteractiva() {
  const [nombre, setNombre] = useState('')
  const [cedula, setCedula] = useState('')
  const [monto, setMonto] = useState('')
  const [fecha, setFecha] = useState('')

  const cedulaCheck = cedula.trim() ? validateCedula(cedula) : null
  const montoNum = parseFloat(monto)
  const montoValido = Number.isFinite(montoNum) && montoNum > 0

  const nombreTexto = nombre.trim() || null
  const cedulaTexto = cedulaCheck?.isValid ? cedulaCheck.formatted : null
  const montoTexto = montoValido ? montoALetras(montoNum, 'DOP') : null
  const fechaTexto = fecha ? fechaLarga(fecha) : null

  return (
    <div className="mx-auto grid max-w-[900px] items-start gap-5 lg:grid-cols-2">
      {/* Formulario */}
      <div className="flex flex-col gap-2.5">
        <Campo
          label="Nombre del arrendatario"
          value={nombre}
          onChange={setNombre}
          placeholder="Ej. María Fernández"
        />
        <Campo
          label="Cédula"
          value={cedula}
          onChange={setCedula}
          placeholder="000-0000000-0"
          hint={
            cedula.trim() && cedulaCheck
              ? cedulaCheck.isValid
                ? { ok: true, text: 'Dígito verificador correcto' }
                : { ok: false, text: cedulaCheck.error ?? 'Cédula inválida' }
              : undefined
          }
        />
        <Campo
          label="Monto mensual (RD$)"
          value={monto}
          onChange={setMonto}
          placeholder="32000"
          type="number"
        />
        <Campo label="Fecha de inicio" value={fecha} onChange={setFecha} type="date" />

        <p className="text-xs text-slate-500">
          Nada de esto se guarda. Corre aquí mismo, en tu navegador.
        </p>
      </div>

      {/* Vista previa en vivo */}
      <div className="rounded-2xl border border-slate-200 bg-white p-4 shadow-sm md:p-5">
        <span className="mb-2.5 inline-block rounded-full bg-[#FDE8B5] px-2.5 py-0.5 text-[11px] font-bold tracking-wider text-[#7D6024]">
          VISTA PREVIA
        </span>
        <p className="font-serif text-sm leading-relaxed text-[#1A1A1A]">
          En la ciudad de Punta Cana, República Dominicana, comparece{' '}
          <Chip>{nombreTexto ?? '{{ nombre_arrendatario }}'}</Chip>, portador de la cédula de
          identidad y electoral No.{' '}
          <Chip invalid={Boolean(cedula.trim() && cedulaCheck && !cedulaCheck.isValid)}>
            {cedulaTexto ?? (cedula.trim() ? 'cédula inválida' : '{{ cedula }}')}
          </Chip>
          , quien en lo adelante se denominará EL ARRENDATARIO, y declara que pagará la suma de{' '}
          <Chip>{montoTexto ?? '{{ monto_mensual }}'}</Chip>
          {montoValido && (
            <span className="text-slate-400"> ({formatMoney(montoNum, 'DOP')})</span>
          )}{' '}
          mensuales, a partir del <Chip>{fechaTexto ?? '{{ fecha_inicio }}'}</Chip>.
        </p>
      </div>
    </div>
  )
}

function Campo({
  label,
  value,
  onChange,
  placeholder,
  type = 'text',
  hint,
}: {
  label: string
  value: string
  onChange: (v: string) => void
  placeholder?: string
  type?: 'text' | 'number' | 'date'
  hint?: { ok: boolean; text: string }
}) {
  const id = useId()

  return (
    <div>
      <label htmlFor={id} className="mb-1 block text-xs font-semibold text-slate-700">
        {label}
      </label>
      <input
        id={id}
        type={type}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        className="w-full rounded-lg border border-slate-300 bg-white px-3 py-1.5 text-sm text-slate-900 outline-none focus:border-[#0D2C24] focus:ring-2 focus:ring-[#0D2C24]/20"
      />
      {hint && (
        <p
          className={`mt-1 flex items-center gap-1.5 text-xs font-medium ${
            hint.ok ? 'text-emerald-700' : 'text-red-600'
          }`}
        >
          {hint.ok ? <CheckCheck size={13} /> : <CircleAlert size={13} />}
          {hint.text}
        </p>
      )}
    </div>
  )
}

/** Igual que las variables del héroe: gris/punteado sin dato, resaltado con dato real. */
function Chip({ children, invalid = false }: { children: React.ReactNode; invalid?: boolean }) {
  const isPlaceholder = typeof children === 'string' && children.startsWith('{{')

  if (invalid) {
    return (
      <span className="rounded-[5px] bg-red-50 px-1.5 py-0.5 font-mono text-[13px] text-red-600">
        {children}
      </span>
    )
  }

  if (isPlaceholder) {
    return (
      <span className="rounded-[5px] border border-dashed border-slate-300 bg-slate-50 px-1.5 py-0.5 font-mono text-[13px] text-slate-400">
        {children}
      </span>
    )
  }

  return (
    <span className="rounded-[5px] bg-[#c8eadd] px-1.5 py-0.5 font-semibold text-[#0D2C24]">
      {children}
    </span>
  )
}
