'use client'

import { useEffect, useRef } from 'react'
import { enviarEvento, type Evento } from '@/lib/analitica'

/**
 * Dispara un evento una vez, al llegar a una pantalla.
 *
 * Para lo que no es un clic: registrarse termina en una pantalla, no en
 * un botón —el botón puede fallar y volver con un error—, así que el
 * único momento en que de verdad ha pasado es cuando esa pantalla se ve.
 *
 * El `ref` es necesario: en desarrollo React monta los efectos dos
 * veces, y sin él GA4 contaría el doble de altas que las que hay.
 */
export default function EventoAlLlegar({
  evento,
  etiqueta,
}: {
  evento: Evento
  etiqueta?: string
}) {
  const yaEnviado = useRef(false)

  useEffect(() => {
    if (yaEnviado.current) return
    yaEnviado.current = true
    enviarEvento(evento, etiqueta ? { etiqueta } : undefined)
  }, [evento, etiqueta])

  return null
}
