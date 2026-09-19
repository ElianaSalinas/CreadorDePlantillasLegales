'use client'

/**
 * Revela cada paso al entrar en pantalla, con IntersectionObserver nativo.
 *
 * A propósito NO usa GSAP/ScrollTrigger/Lenis: el plan (Fase 12.1) fija un
 * presupuesto de JavaScript que esas librerías por sí solas ya agotan, y
 * la portada mide 97/100 en PageSpeed hoy gracias a no cargar nada de
 * eso. Esto es ~600 bytes de JS propio, sin dependencias.
 *
 * Si el usuario tiene activado "reducir movimiento" en su sistema, el
 * observer ni se instala: todo se muestra ya visible, sin animación.
 * Igual que la animación del héroe, que ya respeta esa preferencia.
 */

import { useEffect, useRef, useState, type ReactNode } from 'react'

export default function PasoRevelado({
  children,
  delayMs = 0,
}: {
  children: ReactNode
  delayMs?: number
}) {
  const ref = useRef<HTMLDivElement>(null)
  const [visible, setVisible] = useState(false)

  useEffect(() => {
    const prefiereMenosMovimiento = window.matchMedia(
      '(prefers-reduced-motion: reduce)'
    ).matches

    if (prefiereMenosMovimiento) {
      setVisible(true)
      return
    }

    const el = ref.current
    if (!el) return

    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setVisible(true)
          observer.disconnect()
        }
      },
      { threshold: 0.25 }
    )

    observer.observe(el)
    return () => observer.disconnect()
  }, [])

  return (
    <div
      ref={ref}
      className={`transition-all duration-700 ease-out ${
        visible ? 'translate-y-0 opacity-100' : 'translate-y-6 opacity-0'
      }`}
      style={{ transitionDelay: visible ? `${delayMs}ms` : '0ms' }}
    >
      {children}
    </div>
  )
}
