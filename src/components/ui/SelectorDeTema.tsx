'use client'

import { useEffect, useState } from 'react'
import { Sun, Moon, Monitor } from 'lucide-react'

export type Tema = 'claro' | 'oscuro' | 'sistema'

export const CLAVE_TEMA = 'save-tema'

/**
 * Aplica el tema al <html>.
 *
 * Se exporta porque la usan dos sitios que no se hablan: este componente
 * y el script en línea del layout, que corre antes de que React exista.
 * La lógica tiene que ser LA MISMA en los dos o el usuario ve un
 * parpadeo justo al cargar.
 */
export function aplicarTema(tema: Tema) {
  const oscuro =
    tema === 'oscuro' ||
    (tema === 'sistema' && window.matchMedia('(prefers-color-scheme: dark)').matches)

  const clases = document.documentElement.classList
  clases.toggle('dark', oscuro)
  clases.toggle('light', !oscuro)
}

const OPCIONES: Array<{ valor: Tema; icono: typeof Sun; etiqueta: string }> = [
  { valor: 'claro', icono: Sun, etiqueta: 'Tema claro' },
  { valor: 'oscuro', icono: Moon, etiqueta: 'Tema oscuro' },
  { valor: 'sistema', icono: Monitor, etiqueta: 'Seguir al sistema' },
]

/**
 * Claro / Oscuro / Sistema.
 *
 * Son tres opciones y no un interruptor de dos porque "seguir al
 * sistema" no es lo mismo que "claro": quien tiene el móvil en
 * automático espera que la aplicación cambie sola al anochecer, y con
 * un interruptor de dos posiciones esa preferencia no se puede
 * expresar. Es también el valor por defecto.
 *
 * Mientras esté en `sistema` se escucha el cambio del sistema operativo
 * en vivo: si no, la aplicación se quedaría en el tema que tenía al
 * abrirse hasta que alguien recargara.
 */
export default function SelectorDeTema() {
  const [tema, setTema] = useState<Tema>('sistema')
  // Hasta que no monta no sabemos qué hay en localStorage. Pintar un
  // estado adivinado y corregirlo después es justo el parpadeo que
  // estamos evitando.
  const [montado, setMontado] = useState(false)

  useEffect(() => {
    let guardado: Tema = 'sistema'
    try {
      const v = localStorage.getItem(CLAVE_TEMA)
      if (v === 'claro' || v === 'oscuro' || v === 'sistema') guardado = v
    } catch {
      // Navegador con el almacenamiento bloqueado. Se sigue con 'sistema'.
    }
    setTema(guardado)
    setMontado(true)
  }, [])

  useEffect(() => {
    if (!montado) return
    aplicarTema(tema)
    try {
      localStorage.setItem(CLAVE_TEMA, tema)
    } catch {
      // Si no se puede guardar, el tema vale para esta pestaña y ya.
    }

    if (tema !== 'sistema') return
    const mq = window.matchMedia('(prefers-color-scheme: dark)')
    const alCambiar = () => aplicarTema('sistema')
    mq.addEventListener('change', alCambiar)
    return () => mq.removeEventListener('change', alCambiar)
  }, [tema, montado])

  return (
    <div
      role="group"
      aria-label="Tema de la interfaz"
      className="flex items-center gap-0.5 rounded-lg border border-slate-200 p-0.5 dark:border-slate-700"
    >
      {OPCIONES.map((o) => {
        const activa = montado && tema === o.valor
        return (
          <button
            key={o.valor}
            type="button"
            onClick={() => setTema(o.valor)}
            aria-pressed={activa}
            title={o.etiqueta}
            className={
              activa
                ? 'rounded-md bg-emerald-600 p-1.5 text-white'
                : 'rounded-md p-1.5 text-slate-400 transition-colors hover:text-slate-700 dark:hover:text-slate-200'
            }
          >
            <o.icono size={15} aria-hidden="true" />
            <span className="sr-only">{o.etiqueta}</span>
          </button>
        )
      })}
    </div>
  )
}
