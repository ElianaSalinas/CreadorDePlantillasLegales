'use client'

import { useEffect, useRef, useState } from 'react'
import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { Menu, X } from 'lucide-react'
import { enlacesDeNavegacion } from './AppNav'

/**
 * El menú del área privada en móvil.
 *
 * El `<aside>` de la izquierda es `hidden md:block`: por debajo de 768 px
 * no se renderiza, y hasta ahora no había nada en su lugar. En un teléfono,
 * quien entraba a /app/documents no tenía forma de llegar a Plantillas, a
 * la Bóveda ni a Mi Despacho salvo escribiendo la URL a mano. La app era
 * inservible en el aparato donde más gente la va a abrir.
 */
export default function MenuMovil({
  isAdmin = false,
  esRevisor = false,
}: {
  isAdmin?: boolean
  esRevisor?: boolean
}) {
  const [abierto, setAbierto] = useState(false)
  const pathname = usePathname()
  const panel = useRef<HTMLDivElement>(null)
  const boton = useRef<HTMLButtonElement>(null)

  const enlaces = enlacesDeNavegacion(isAdmin, esRevisor)

  // Al cambiar de pantalla se cierra solo. Sin esto, tocar un enlace deja
  // el panel abierto encima de la página a la que acabas de llegar.
  useEffect(() => {
    setAbierto(false)
  }, [pathname])

  // Escape cierra, y el foco vuelve al botón: si no, quien navega con
  // teclado se queda perdido en medio del documento.
  useEffect(() => {
    if (!abierto) return

    function alPulsar(e: KeyboardEvent) {
      if (e.key === 'Escape') {
        setAbierto(false)
        boton.current?.focus()
      }
    }

    document.addEventListener('keydown', alPulsar)
    const overflowPrevio = document.body.style.overflow
    document.body.style.overflow = 'hidden'
    panel.current?.querySelector<HTMLElement>('a')?.focus()

    return () => {
      document.removeEventListener('keydown', alPulsar)
      document.body.style.overflow = overflowPrevio
    }
  }, [abierto])

  return (
    <div className="md:hidden">
      <button
        ref={boton}
        onClick={() => setAbierto(true)}
        aria-label="Abrir el menú"
        aria-expanded={abierto}
        aria-controls="menu-movil"
        className="rounded-md p-2 text-slate-600 transition-colors hover:bg-slate-100 dark:text-slate-300 dark:hover:bg-slate-800"
      >
        <Menu size={20} />
      </button>

      {abierto && (
        <div className="fixed inset-0 z-50 flex">
          <div
            onClick={() => setAbierto(false)}
            className="absolute inset-0 bg-slate-900/50"
            aria-hidden="true"
          />

          <div
            ref={panel}
            id="menu-movil"
            role="dialog"
            aria-modal="true"
            aria-label="Menú de navegación"
            className="relative flex h-full w-72 max-w-[85vw] flex-col border-r border-slate-200 bg-white p-4 shadow-xl dark:border-slate-800 dark:bg-slate-900"
          >
            <div className="mb-4 flex items-center justify-between">
              <span className="font-bold text-slate-900 dark:text-white">Save Documentos</span>
              <button
                onClick={() => {
                  setAbierto(false)
                  boton.current?.focus()
                }}
                aria-label="Cerrar el menú"
                className="rounded-md p-2 text-slate-500 transition-colors hover:bg-slate-100 dark:hover:bg-slate-800"
              >
                <X size={18} />
              </button>
            </div>

            <nav className="flex flex-col gap-1">
              {enlaces.map(({ href, label, Icon }) => {
                const activo = pathname === href || pathname.startsWith(href + '/')
                return (
                  <Link
                    key={href}
                    href={href}
                    aria-current={activo ? 'page' : undefined}
                    className={
                      activo
                        ? 'flex items-center gap-3 rounded-md bg-emerald-50 px-3 py-3 font-medium text-emerald-700 dark:bg-emerald-900/20 dark:text-emerald-400'
                        : 'flex items-center gap-3 rounded-md px-3 py-3 font-medium text-slate-600 transition-colors hover:bg-slate-50 dark:text-slate-400 dark:hover:bg-slate-800'
                    }
                  >
                    <Icon size={18} />
                    <span>{label}</span>
                  </Link>
                )
              })}
            </nav>
          </div>
        </div>
      )}
    </div>
  )
}
