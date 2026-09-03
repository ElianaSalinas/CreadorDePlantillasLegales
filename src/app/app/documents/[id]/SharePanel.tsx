'use client'

import { useState, useTransition } from 'react'
import { useRouter } from 'next/navigation'
import { Users, Check, Loader2, X } from 'lucide-react'
import { shareDocument, unshareDocument, type ShareResult } from './share-actions'

export type Companero = {
  userId: string
  nombre: string
  rol: string
  compartido: boolean
}

/**
 * Compartir un documento con los compañeros del despacho.
 *
 * Se listan por nombre, no por correo: quien comparte piensa en "Juana
 * Martínez", no en una dirección. El titular del despacho no aparece en la
 * lista porque ya ve todos los documentos, y ofrecérselo sugeriría que
 * necesita permiso cuando no es así.
 */
export default function SharePanel({
  documentId,
  companeros,
  puedeCompartir,
}: {
  documentId: string
  companeros: Companero[]
  puedeCompartir: boolean
}) {
  const router = useRouter()
  const [abierto, setAbierto] = useState(false)
  const [result, setResult] = useState<ShareResult | null>(null)
  const [pending, startTransition] = useTransition()
  const [enCurso, setEnCurso] = useState<string | null>(null)

  const compartidos = companeros.filter((c) => c.compartido)

  if (!puedeCompartir) {
    if (compartidos.length === 0) return null
    return (
      <p className="mb-4 text-sm text-slate-500">
        Compartido con {compartidos.map((c) => c.nombre).join(', ')}.
      </p>
    )
  }

  function alternar(c: Companero) {
    setResult(null)
    setEnCurso(c.userId)
    startTransition(async () => {
      const r = c.compartido
        ? await unshareDocument(documentId, c.userId)
        : await shareDocument(documentId, c.userId)
      setResult(r)
      setEnCurso(null)
      if (r.ok) router.refresh()
    })
  }

  return (
    <div className="mb-4">
      <button
        type="button"
        onClick={() => setAbierto((v) => !v)}
        aria-expanded={abierto}
        className="inline-flex items-center gap-2 rounded-lg border border-slate-300 px-3 py-2 text-sm font-medium text-slate-700 transition-colors hover:border-emerald-500 hover:text-emerald-700 dark:border-slate-700 dark:text-slate-300 dark:hover:text-emerald-400"
      >
        <Users size={16} />
        Compartir
        {compartidos.length > 0 && (
          <span className="rounded-full bg-emerald-100 px-2 py-0.5 text-xs font-semibold text-emerald-700 dark:bg-emerald-900/40 dark:text-emerald-300">
            {compartidos.length}
          </span>
        )}
      </button>

      {abierto && (
        <div className="mt-2 max-w-sm rounded-lg border border-slate-200 bg-white p-2 shadow-lg dark:border-slate-700 dark:bg-slate-900">
          {companeros.length === 0 ? (
            <p className="px-2 py-3 text-sm text-slate-500">
              No hay nadie más en tu despacho con quien compartir.
            </p>
          ) : (
            <ul className="flex flex-col">
              {companeros.map((c) => (
                <li key={c.userId}>
                  <button
                    type="button"
                    disabled={pending}
                    onClick={() => alternar(c)}
                    className="flex w-full items-center justify-between gap-3 rounded px-2 py-2 text-left text-sm transition-colors hover:bg-slate-50 disabled:opacity-50 dark:hover:bg-slate-800"
                  >
                    <span className="min-w-0">
                      <span className="block truncate text-slate-800 dark:text-slate-200">
                        {c.compartido ? 'Dejar de compartir con ' : 'Compartir con '}
                        <strong>{c.nombre}</strong>
                      </span>
                      <span className="block text-xs text-slate-500">{c.rol}</span>
                    </span>
                    {enCurso === c.userId ? (
                      <Loader2 size={16} className="shrink-0 animate-spin text-slate-400" />
                    ) : c.compartido ? (
                      <Check size={16} className="shrink-0 text-emerald-600" />
                    ) : (
                      <span className="shrink-0 text-slate-300 dark:text-slate-600">
                        <X size={16} />
                      </span>
                    )}
                  </button>
                </li>
              ))}
            </ul>
          )}

          {result && (
            <p
              className={`mt-1 rounded px-2 py-1.5 text-xs ${
                result.ok
                  ? 'bg-emerald-50 text-emerald-700 dark:bg-emerald-900/20 dark:text-emerald-300'
                  : 'bg-red-50 text-red-600 dark:bg-red-900/20 dark:text-red-400'
              }`}
            >
              {result.ok ? result.notice : result.error}
            </p>
          )}

          <p className="mt-1 px-2 pb-1 text-xs text-slate-400">
            Quien reciba el documento podrá editarlo, pero no borrarlo ni volver a compartirlo.
          </p>
        </div>
      )}
    </div>
  )
}
