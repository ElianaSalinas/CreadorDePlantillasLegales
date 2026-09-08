'use client'

import { useState, useTransition } from 'react'
import { User, Building2, Loader2 } from 'lucide-react'
import { completarPerfil, saltarPerfil } from './actions'

const inputClass =
  'w-full rounded-lg border border-slate-300 bg-slate-50 px-4 py-2 text-slate-900 outline-none focus:ring-2 focus:ring-emerald-500 dark:border-slate-700 dark:bg-slate-800 dark:text-white'
const labelClass = 'mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300'

export default function BienvenidaClient({ nombre }: { nombre: string }) {
  const [tipo, setTipo] = useState<'PERSONA' | 'EMPRESA'>('PERSONA')
  const [error, setError] = useState<string | null>(null)
  const [pendiente, startTransition] = useTransition()

  function enviar(formData: FormData) {
    setError(null)
    startTransition(async () => {
      const r = await completarPerfil(formData)
      if (r && !r.ok) setError(r.error ?? 'No pudimos guardarlo.')
    })
  }

  return (
    <div className="mx-auto max-w-lg">
      <h1 className="font-serif text-3xl font-bold text-slate-900 dark:text-white">
        Hola, {nombre}
      </h1>
      <p className="mt-2 text-slate-600 dark:text-slate-400">
        Nos faltan dos datos que Google no nos da. Es la única vez que te lo preguntamos.
      </p>

      <form action={enviar} className="mt-8 space-y-5">
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

        {/* Se desmonta lo que no aplica: un campo oculto se enviaria igual. */}
        {tipo === 'EMPRESA' ? (
          <>
            <div>
              <label htmlFor="razon_social" className={labelClass}>Razón social</label>
              <input id="razon_social" name="razon_social" required
                placeholder="Ej. Inmobiliaria del Este, S.R.L." className={inputClass} />
            </div>
            <div>
              <label htmlFor="rnc" className={labelClass}>RNC</label>
              <input id="rnc" name="rnc" required inputMode="numeric"
                placeholder="000000000" aria-describedby="rnc-ayuda" className={inputClass} />
              <p id="rnc-ayuda" className="mt-1 text-xs text-slate-500">
                Nueve dígitos. Lo necesitaremos para tu factura.
              </p>
            </div>
          </>
        ) : (
          <div>
            <label htmlFor="fecha_nacimiento" className={labelClass}>
              Fecha de nacimiento <span className="font-normal text-slate-400">(opcional)</span>
            </label>
            <input id="fecha_nacimiento" name="fecha_nacimiento" type="date"
              max={new Date().toISOString().slice(0, 10)}
              aria-describedby="fecha-ayuda" className={inputClass} />
            <p id="fecha-ayuda" className="mt-1 text-xs text-slate-500">
              Solo la usamos para felicitarte. Puedes dejarla en blanco.
            </p>
          </div>
        )}

        {error && (
          <p role="alert" className="rounded-lg bg-red-50 p-3 text-sm text-red-600 dark:bg-red-900/20 dark:text-red-400">
            {error}
          </p>
        )}

        <div className="flex items-center gap-3 pt-2">
          <button type="submit" disabled={pendiente}
            className="inline-flex items-center gap-2 rounded-lg bg-emerald-600 px-5 py-2.5 font-semibold text-white transition-colors hover:bg-emerald-700 disabled:opacity-50">
            {pendiente && <Loader2 size={16} className="animate-spin" />}
            Guardar y entrar
          </button>

          {/* Saltar existe a proposito. Obligar a dar la fecha de
              nacimiento para usar la herramienta seria pedir un dato que
              no necesitamos para prestarte el servicio.

              Va con `formAction` y NO envuelto en su propio <form>: un
              formulario dentro de otro no es HTML valido, y el navegador
              lo resuelve rompiendo el de fuera. TypeScript no lo ve. */}
          <button
            type="submit"
            formAction={saltarPerfil}
            disabled={pendiente}
            className="text-sm font-medium text-slate-500 hover:text-slate-800 disabled:opacity-50 dark:hover:text-slate-200"
          >
            Ahora no
          </button>
        </div>
      </form>
    </div>
  )
}
