'use client'

import { useState } from 'react'
import { User, Building2 } from 'lucide-react'

const inputClass =
  'w-full rounded-lg border border-slate-300 bg-slate-50 px-4 py-2 text-slate-900 outline-none focus:ring-2 focus:ring-emerald-500 dark:border-slate-700 dark:bg-slate-800 dark:text-white'

const labelClass =
  'mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300'

/**
 * Persona o empresa, y lo que cambia según cuál.
 *
 * No es una pregunta de adorno: a una persona se le pide fecha de
 * nacimiento —para felicitarla— y a una empresa razón social y RNC, que
 * es lo que hará falta para emitir el comprobante fiscal cuando entre
 * el cobro con tarjeta. Una empresa no tiene cumpleaños y una persona
 * no tiene razón social; preguntar las dos cosas a todos sería pedir
 * datos que no se van a usar.
 *
 * Los campos que no aplican se DESMONTAN en vez de esconderse con CSS.
 * Un campo oculto sigue enviándose con el formulario, y acabaríamos
 * guardando la fecha de nacimiento de una empresa.
 */
export default function TipoDeCuenta() {
  const [tipo, setTipo] = useState<'PERSONA' | 'EMPRESA'>('PERSONA')

  return (
    <>
      <input type="hidden" name="tipo_cuenta" value={tipo} />

      <div className="grid grid-cols-2 gap-3">
        {[
          { valor: 'PERSONA' as const, icono: User, texto: 'Soy una persona' },
          { valor: 'EMPRESA' as const, icono: Building2, texto: 'Soy una empresa' },
        ].map((o) => {
          const activo = tipo === o.valor
          return (
            <button
              key={o.valor}
              type="button"
              onClick={() => setTipo(o.valor)}
              aria-pressed={activo}
              className={`flex items-center gap-2.5 rounded-lg border p-3 text-left text-sm font-medium transition-colors ${
                activo
                  ? 'border-emerald-500 bg-emerald-50 text-emerald-800 dark:bg-emerald-900/20 dark:text-emerald-300'
                  : 'border-slate-300 text-slate-600 hover:border-slate-400 dark:border-slate-700 dark:text-slate-400'
              }`}
            >
              <o.icono size={17} aria-hidden="true" />
              {o.texto}
            </button>
          )
        })}
      </div>

      {tipo === 'EMPRESA' ? (
        <>
          <div>
            <label htmlFor="razon_social" className={labelClass}>
              Razón social
            </label>
            <input
              id="razon_social"
              name="razon_social"
              type="text"
              required
              placeholder="Ej. Inmobiliaria del Este, S.R.L."
              className={inputClass}
            />
          </div>

          <div>
            <label htmlFor="rnc" className={labelClass}>
              RNC
            </label>
            <input
              id="rnc"
              name="rnc"
              type="text"
              required
              inputMode="numeric"
              placeholder="000000000"
              aria-describedby="rnc-ayuda"
              className={inputClass}
            />
            <p id="rnc-ayuda" className="mt-1 text-xs text-slate-500">
              Nueve dígitos. Lo necesitaremos para tu factura.
            </p>
          </div>
        </>
      ) : (
        <div>
          <label htmlFor="fecha_nacimiento" className={labelClass}>
            Fecha de nacimiento{' '}
            <span className="font-normal text-slate-400">(opcional)</span>
          </label>
          <input
            id="fecha_nacimiento"
            name="fecha_nacimiento"
            type="date"
            max={new Date().toISOString().slice(0, 10)}
            aria-describedby="fecha-ayuda"
            className={inputClass}
          />
          <p id="fecha-ayuda" className="mt-1 text-xs text-slate-500">
            Solo la usamos para felicitarte. Puedes dejarla en blanco.
          </p>
        </div>
      )}
    </>
  )
}
