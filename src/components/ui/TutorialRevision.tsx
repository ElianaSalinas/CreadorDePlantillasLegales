'use client'

import { useEffect, useRef, useState, useTransition } from 'react'
import Link from 'next/link'
import { BadgeCheck, Loader2 } from 'lucide-react'
import { ocultarTutorialRevision } from '@/app/app/actions'

/**
 * Mensaje de bienvenida para quien revisa el catálogo (Cifuentes,
 * Márquez): cómo se aprueba y cómo se corrige.
 *
 * Sale cada vez que abre la app, hasta que pulse "No ver otra vez".
 *
 *  - "Ver más tarde": se cierra hasta la próxima vez que abra la app
 *    (sessionStorage: dura lo que dura la pestaña). Navegar dentro de la
 *    app no lo vuelve a sacar.
 *  - "No ver otra vez": se guarda en SU CUENTA (user_metadata de Supabase),
 *    no en el navegador, así que tampoco le sale en el móvil ni en otro
 *    ordenador. Sin migración: es un campo que el propio usuario puede
 *    escribir de su cuenta.
 *
 * Es un <dialog> nativo con showModal(): el foco queda dentro, Escape lo
 * cierra (cuenta como "Ver más tarde") y el lector de pantalla lo anuncia
 * como diálogo.
 */
const CLAVE_SESION = 'save.tutorialRevision.masTarde'

export default function TutorialRevision() {
  const dialogo = useRef<HTMLDialogElement>(null)
  const [guardando, empezar] = useTransition()
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    let yaVisto = false
    try {
      yaVisto = window.sessionStorage.getItem(CLAVE_SESION) === '1'
    } catch {}
    if (!yaVisto && dialogo.current && !dialogo.current.open) dialogo.current.showModal()
  }, [])

  function verMasTarde() {
    try {
      window.sessionStorage.setItem(CLAVE_SESION, '1')
    } catch {}
    dialogo.current?.close()
  }

  function noVerOtraVez() {
    setError(null)
    empezar(async () => {
      const r = await ocultarTutorialRevision()
      if (r.ok) {
        dialogo.current?.close()
      } else {
        setError('No se pudo guardar. Inténtalo otra vez o pulsa «Ver más tarde».')
      }
    })
  }

  return (
    <dialog
      ref={dialogo}
      aria-labelledby="tutorial-revision-titulo"
      onCancel={(e) => {
        // Escape: igual que "Ver más tarde".
        e.preventDefault()
        verMasTarde()
      }}
      className="m-auto w-[calc(100%-2rem)] max-w-lg rounded-2xl border border-slate-200 bg-white p-0 text-slate-800 shadow-xl backdrop:bg-slate-900/50 dark:border-slate-700 dark:bg-slate-900 dark:text-slate-200"
    >
      <div className="p-6">
        <h2 id="tutorial-revision-titulo" className="flex items-center gap-2 text-lg font-bold text-slate-900 dark:text-white">
          <BadgeCheck size={20} className="text-emerald-600" />
          Cómo revisar el catálogo
        </h2>
        <p className="mt-2 text-sm text-slate-600 dark:text-slate-400">
          Nada del catálogo lo ve un usuario hasta que tú lo apruebas. Todo se hace desde{' '}
          <Link href="/app/revision" onClick={verMasTarde} className="font-semibold text-emerald-700 underline underline-offset-2 dark:text-emerald-400">
            Revisión
          </Link>
          , en el menú de la izquierda.
        </p>

        <ol className="mt-4 space-y-3 text-sm">
          <li className="flex gap-3">
            <span className="flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-emerald-100 text-xs font-bold text-emerald-700 dark:bg-emerald-900/40 dark:text-emerald-400">1</span>
            <span>
              <strong>Primero las cláusulas.</strong> Pulsa <em>Leer</em> para ver el texto y{' '}
              <em>Corregir el texto</em> si hay que cambiar algo. Una plantilla no se puede publicar
              mientras alguna de sus cláusulas siga sin aprobar.
            </span>
          </li>
          <li className="flex gap-3">
            <span className="flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-emerald-100 text-xs font-bold text-emerald-700 dark:bg-emerald-900/40 dark:text-emerald-400">2</span>
            <span>
              <strong>Para aprobar,</strong> marca la casilla de lo que ya leíste y pulsa{' '}
              <em>Aprobar y publicar</em> en la barra de arriba. Puedes marcar varias a la vez.
            </span>
          </li>
          <li className="flex gap-3">
            <span className="flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-emerald-100 text-xs font-bold text-emerald-700 dark:bg-emerald-900/40 dark:text-emerald-400">3</span>
            <span>
              <strong>Luego las plantillas.</strong> En la pestaña <em>Plantillas</em>,{' '}
              <em>Leer y aprobar</em> muestra el documento completo y el botón para aprobar esa
              plantilla. <em>Modificar</em> abre el editor para cambiar su texto o sus cláusulas.
            </span>
          </li>
          <li className="flex gap-3">
            <span className="flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-emerald-100 text-xs font-bold text-emerald-700 dark:bg-emerald-900/40 dark:text-emerald-400">4</span>
            <span>
              <strong>¿Se aprobó algo por error?</strong> Márcalo y pulsa <em>Devolver a borrador</em>:
              deja de verse al momento.
            </span>
          </li>
        </ol>

        {error && (
          <p role="alert" className="mt-4 text-sm text-red-600 dark:text-red-400">
            {error}
          </p>
        )}
      </div>

      <div className="flex flex-col-reverse gap-2 border-t border-slate-200 bg-slate-50 px-6 py-4 sm:flex-row sm:justify-end dark:border-slate-700 dark:bg-slate-800/50">
        <button
          onClick={noVerOtraVez}
          disabled={guardando}
          className="inline-flex items-center justify-center gap-1.5 rounded-lg border border-slate-300 px-4 py-2 text-sm font-medium text-slate-700 transition-colors hover:bg-white disabled:opacity-50 dark:border-slate-600 dark:text-slate-300 dark:hover:bg-slate-800"
        >
          {guardando && <Loader2 size={14} className="animate-spin" />}
          No ver otra vez
        </button>
        <button
          autoFocus
          onClick={verMasTarde}
          className="rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white transition-colors hover:bg-emerald-700"
        >
          Ver más tarde
        </button>
      </div>
    </dialog>
  )
}
