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

/**
 * Quita de la ruta los identificadores antes de mandarla a Google.
 *
 * POR QUE, QUE ES LA PARTE QUE IMPORTA
 *
 * GA4 envia la URL completa de cada pagina. Dentro de la aplicacion las
 * URLs son /app/documents/<id-del-documento>, asi que sin esto cada
 * visita mandaria a Google el identificador de un expediente de un
 * cliente de un despacho. No es un nombre ni una cedula, pero es rastro
 * del trabajo de un abogado saliendo del pais, y la Ley 172-13 llama a
 * eso secreto profesional en su articulo 5.6.
 *
 * Para lo que sirve la analitica -saber cuanta gente edita documentos-
 * "/app/documents/[id]" vale exactamente lo mismo que el identificador
 * real. Se pierde cero informacion util y se deja de filtrar la que no
 * nos toca.
 */
const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i

export function rutaSinIdentificadores(ruta: string): string {
  return ruta
    .split('/')
    .map((trozo) => {
      if (UUID.test(trozo)) return '[id]'
      // Por si algun dia se usan ids que no sean UUID. La regla es
      // ESTRECHA a proposito: sin guiones y solo hexadecimal.
      //
      // La primera version decia "trozo largo con digitos", y al probarla
      // se comia los slugs: /plantillas/contrato-de-alquiler-2024 habria
      // llegado a GA4 como /plantillas/[id], borrando justo la pagina
      // cuyo rendimiento queremos medir en la Fase 6. Un filtro de
      // privacidad que tapa de mas es un filtro roto, solo que se nota
      // seis meses despues y en forma de informe vacio.
      if (trozo.length >= 20 && /^[0-9a-f]+$/i.test(trozo)) return '[id]'
      return trozo
    })
    .join('/')
}
