'use client'

import { useEffect, useState } from 'react'
import { usePathname } from 'next/navigation'
import Script from 'next/script'
import {
  EVENTO_CONSENTIMIENTO,
  EVENTOS,
  enviarEvento,
  leerConsentimiento,
  rutaSinIdentificadores,
  type Evento,
} from '@/lib/analitica'

/**
 * GA4, y solo si la persona ha dicho que sí.
 *
 * El script NI SIQUIERA SE DESCARGA sin consentimiento. La alternativa
 * habitual —cargar gtag y luego pedirle que no mida— ya ha contactado
 * con Google, ya ha revelado la IP del visitante y ya ha podido escribir
 * una cookie. Prometer una cosa en /privacidad y hacer otra en el
 * <head> es el tipo de detalle por el que se pierde justo lo que esta
 * página pretende ganar.
 *
 * `id` llega como prop desde el layout, que es un componente de
 * servidor. No se lee process.env aquí porque este archivo es de
 * cliente y ahí no hay variables de entorno.
 *
 * `send_page_view: false` en la configuración es deliberado: la vista
 * automática de GA4 usa la URL real del navegador, con el identificador
 * del documento dentro. Se apaga la suya y se manda la nuestra, ya
 * limpia.
 */
export default function Analitica({ id }: { id?: string }) {
  const [permitido, setPermitido] = useState(false)
  const ruta = usePathname()

  useEffect(() => {
    setPermitido(leerConsentimiento() === 'aceptado')
    const alDecidir = (e: Event) => {
      setPermitido((e as CustomEvent).detail === 'aceptado')
    }
    window.addEventListener(EVENTO_CONSENTIMIENTO, alDecidir)
    return () => window.removeEventListener(EVENTO_CONSENTIMIENTO, alDecidir)
  }, [])

  /**
   * Clics medidos por delegación, con un solo oyente.
   *
   * Cualquier elemento del proyecto —también los renderizados en el
   * servidor— se mide poniéndole data-analitica="cta_click". La
   * alternativa era convertir en componente de cliente cada botón que
   * quisiéramos medir, y eso es pagar interactividad en el navegador a
   * cambio de una estadística.
   */
  useEffect(() => {
    if (!permitido) return
    function alHacerClic(e: MouseEvent) {
      const el = (e.target as HTMLElement | null)?.closest?.('[data-analitica]')
      if (!el) return
      const nombre = el.getAttribute('data-analitica') as Evento | null
      if (!nombre || !EVENTOS.includes(nombre)) return
      enviarEvento(nombre, {
        etiqueta: el.getAttribute('data-analitica-etiqueta') ?? undefined,
        ruta: rutaSinIdentificadores(ruta),
      })
    }
    document.addEventListener('click', alHacerClic)
    return () => document.removeEventListener('click', alHacerClic)
  }, [permitido, ruta])

  /**
   * Cada cambio de ruta, con la ruta ya limpia de identificadores.
   *
   * El `gtag('set', ...)` no es un adorno: fija la ruta por defecto para
   * TODO lo que GA4 mande después, incluidos los eventos automáticos de
   * la "medición mejorada" —desplazamientos, clics salientes— que no
   * pasan por nuestro código y que, si no, adjuntarían la URL real con
   * el identificador del documento dentro.
   */
  useEffect(() => {
    if (!permitido || !id || typeof window.gtag !== 'function') return
    const limpia = rutaSinIdentificadores(ruta)
    window.gtag('set', {
      page_path: limpia,
      page_location: window.location.origin + limpia,
    })
    window.gtag('event', 'page_view')
  }, [ruta, permitido, id])

  if (!id || !permitido) return null

  return (
    <>
      <Script src={`https://www.googletagmanager.com/gtag/js?id=${id}`} strategy="afterInteractive" />
      <Script id="ga4-init" strategy="afterInteractive">
        {`window.dataLayer=window.dataLayer||[];function gtag(){dataLayer.push(arguments);}window.gtag=gtag;gtag('js',new Date());gtag('config','${id}',{anonymize_ip:true,send_page_view:false});`}
      </Script>
    </>
  )
}
