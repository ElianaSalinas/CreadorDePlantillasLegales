'use client'

import { useState, useTransition } from 'react'
import { useRouter } from 'next/navigation'
import { Lock, Users, Loader2 } from 'lucide-react'
import { setDocumentPrivacy, type ShareResult } from './share-actions'

/**
 * El candado del documento.
 *
 * Se enseña siempre, también a quien no puede tocarlo: saber que un
 * documento lo ve todo el despacho importa aunque no puedas cambiarlo.
 * Al que no es su autor ni el titular se le muestra como texto, sin
 * botón, en vez de con un botón que le rebote.
 */
export default function PrivacidadToggle({
  documentId,
  esPrivado,
  puedeCambiar,
}: {
  documentId: string
  esPrivado: boolean
  puedeCambiar: boolean
}) {
  const router = useRouter()
  const [result, setResult] = useState<ShareResult | null>(null)
  const [pending, startTransition] = useTransition()

  const Icono = esPrivado ? Lock : Users
  const etiqueta = esPrivado ? 'Privado' : 'Lo ve tu despacho'

  const base =
    'inline-flex items-center gap-2 rounded-lg border px-3 py-2 text-sm font-medium transition-colors'
  const tono = esPrivado
    ? 'border-amber-300 bg-amber-50 text-amber-800 dark:border-amber-800 dark:bg-amber-900/20 dark:text-amber-300'
    : 'border-slate-300 text-slate-700 dark:border-slate-700 dark:text-slate-300'

  if (!puedeCambiar) {
    return (
      <span className={`${base} ${tono} cursor-default`}>
        <Icono size={16} />
        {etiqueta}
      </span>
    )
  }

  function alternar() {
    setResult(null)
    startTransition(async () => {
      const r = await setDocumentPrivacy(documentId, !esPrivado)
      setResult(r)
      if (r.ok) router.refresh()
    })
  }

  return (
    <div>
      <button
        type="button"
        onClick={alternar}
        disabled={pending}
        aria-pressed={esPrivado}
        className={`${base} ${tono} hover:border-emerald-500 disabled:opacity-50`}
        title={
          esPrivado
            ? 'Ahora solo lo ves tú, el titular y quien tenga acceso. Púlsalo para abrirlo al despacho.'
            : 'Ahora lo ve todo tu despacho. Púlsalo para hacerlo privado.'
        }
      >
        {pending ? <Loader2 size={16} className="animate-spin" /> : <Icono size={16} />}
        {etiqueta}
      </button>

      {result && (
        <p
          className={`mt-1.5 rounded px-2 py-1 text-xs ${
            result.ok
              ? 'bg-emerald-50 text-emerald-700 dark:bg-emerald-900/20 dark:text-emerald-300'
              : 'bg-red-50 text-red-600 dark:bg-red-900/20 dark:text-red-400'
          }`}
        >
          {result.ok ? result.notice : result.error}
        </p>
      )}
    </div>
  )
}
