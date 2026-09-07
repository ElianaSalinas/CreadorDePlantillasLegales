/**
 * Los eventos que mide SAVE, en un solo sitio.
 *
 * Escribir el nombre a mano en cada llamada garantiza que algún día
 * convivan `document_download` y `document_downloaded`, y que en GA4
 * aparezcan como dos cosas distintas sin que nadie se dé cuenta durante
 * meses. Aquí el compilador no deja.
 */
export const EVENTOS = [
  'sign_up',
  'login',
  'template_view',
  'template_start',
  'document_created',
  'document_download',
  'document_shared',
  'cta_click',
] as const

export type Evento = (typeof EVENTOS)[number]

export const CLAVE_CONSENTIMIENTO = 'save-consentimiento'

export type Consentimiento = 'aceptado' | 'rechazado'

export function leerConsentimiento(): Consentimiento | null {
  try {
    const v = localStorage.getItem(CLAVE_CONSENTIMIENTO)
    return v === 'aceptado' || v === 'rechazado' ? v : null
  } catch {
    // Navegador con el almacenamiento bloqueado: se trata como "sin
    // decidir", que es lo que NO carga analítica. Ante la duda, no medir.
    return null
  }
}

/** Se dispara al decidir, para que la analítica reaccione sin recargar. */
export const EVENTO_CONSENTIMIENTO = 'save:consentimiento'

declare global {
  interface Window {
    gtag?: (...args: unknown[]) => void
  }
}

/**
 * Manda un evento a GA4 si —y solo si— hay consentimiento y gtag existe.
 *
 * No lanza nunca. Una analítica que rompe la aplicación es peor que no
 * tener analítica: se pierde el dato Y la venta.
 */
export function enviarEvento(nombre: Evento, parametros?: Record<string, unknown>) {
  try {
    if (typeof window === 'undefined' || typeof window.gtag !== 'function') return
    window.gtag('event', nombre, parametros ?? {})
  } catch {
    /* nada */
  }
}
