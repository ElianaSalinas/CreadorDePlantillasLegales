'use client'

import { useEffect, useState } from 'react'
import Link from 'next/link'
import {
  CLAVE_CONSENTIMIENTO,
  EVENTO_CONSENTIMIENTO,
  leerConsentimiento,
  type Consentimiento as Decision,
} from '@/lib/analitica'

/**
 * El aviso de cookies.
 *
 * POR QUÉ EXISTE, QUE NO ES "PORQUE TODOS LO TIENEN"
 *
 * Hasta hoy SAVE no ponía una sola cookie de terceros, así que no hacía
 * falta. Con GA4 sí: Google escribe cookies y los datos salen del país.
 * La política de privacidad que publicamos dice —artículo 80 de la Ley
 * 172-13— que la transferencia internacional se apoya en el
 * consentimiento. Un banner que carga la analítica antes de que la
 * persona diga que sí convertiría esa frase en mentira.
 *
 * Por eso NO hay preseleccionado, ni "seguir navegando implica aceptar",
 * ni un botón de rechazar escondido en gris claro. Las dos opciones
 * pesan lo mismo. Un consentimiento que se obtiene por cansancio no es
 * consentimiento y no protege a nadie, empezando por SAVE.
 */
export default function Consentimiento() {
  const [visible, setVisible] = useState(false)

  useEffect(() => {
    // Solo se enseña a quien no ha decidido. Y se lee en el cliente: si
    // se pintara en el servidor, saldría un instante a quien ya decidió.
    if (leerConsentimiento() === null) setVisible(true)
  }, [])

  function decidir(decision: Decision) {
    try {
      localStorage.setItem(CLAVE_CONSENTIMIENTO, decision)
    } catch {
      // Sin almacenamiento la decisión vale para esta pestaña. Se avisa
      // igual, para que la analítica arranque si dijo que sí.
    }
    window.dispatchEvent(new CustomEvent(EVENTO_CONSENTIMIENTO, { detail: decision }))
    setVisible(false)
  }

  if (!visible) return null

  return (
    <div
      role="dialog"
      aria-live="polite"
      aria-label="Uso de cookies"
      className="fixed inset-x-3 bottom-3 z-50 mx-auto max-w-2xl rounded-2xl border border-slate-200 bg-white p-5 shadow-lg dark:border-slate-700 dark:bg-slate-900"
    >
      <p className="text-sm leading-relaxed text-slate-700 dark:text-slate-300">
        Usamos cookies de <strong className="font-semibold">Google Analytics</strong> para saber qué
        partes de SAVE se usan y cuáles no. Nos ayudan a mejorarlo, y sus servidores están fuera del
        país. Sin ellas la plataforma funciona igual.{' '}
        <Link
          href="/privacidad"
          className="font-semibold text-emerald-700 underline underline-offset-4 dark:text-emerald-400"
        >
          Cómo tratamos tus datos
        </Link>
        .
      </p>

      <div className="mt-4 flex flex-col gap-2 sm:flex-row">
        <button
          type="button"
          onClick={() => decidir('aceptado')}
          className="rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white transition-colors hover:bg-emerald-700"
        >
          Aceptar
        </button>
        <button
          type="button"
          onClick={() => decidir('rechazado')}
          className="rounded-lg border border-slate-300 px-4 py-2 text-sm font-semibold text-slate-700 transition-colors hover:border-slate-400 dark:border-slate-600 dark:text-slate-200"
        >
          Solo lo necesario
        </button>
      </div>
    </div>
  )
}
