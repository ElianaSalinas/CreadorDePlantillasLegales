import localFont from 'next/font/local'

/**
 * Las fuentes de marca, servidas desde nuestro propio dominio.
 *
 * Antes venían de una hoja de Google Fonts en el <head>. Eso costaba
 * dos cosas: la hoja BLOQUEA el renderizado —la página no pinta nada
 * hasta que responde un servidor ajeno— y añade DNS y TLS a
 * fonts.googleapis.com y fonts.gstatic.com antes de poder ni empezar
 * a descargar la letra.
 *
 * POR QUÉ `next/font/local` Y NO `next/font/google`
 *
 * next/font/google descarga las fuentes DURANTE EL BUILD. En Railway el
 * build corre dentro de un contenedor sin caché, así que cada
 * despliegue depende de que Google conteste. En este proyecto ya nos
 * mordió una vez que el contenedor de build no tenía algo que el código
 * daba por hecho —las variables de Supabase en /precios—, y no me
 * apetece repetirlo con las letras. Los archivos están en el repo: el
 * build no toca la red.
 *
 * De Plus Jakarta Sans se usa la versión VARIABLE: un solo archivo de
 * 27 KB cubre de 200 a 800, en vez de cinco archivos para los cinco
 * pesos que la interfaz usa.
 *
 * `display: swap` enseña el texto en la tipografía del sistema y la
 * cambia al cargar. La alternativa es una página en blanco: preferimos
 * un salto de letra a que no se lea nada.
 *
 * OJO CON EL NOMBRE DE ESTAS CONSTANTES. next/font bautiza la familia
 * con el nombre de la variable exportada. Llamarlas `serif` y `sans`
 * generaba `font-family: "serif"` y `font-family: "sans"`, que son
 * palabras reservadas de CSS puestas entre comillas: funcionaba, y era
 * una trampa esperando a que alguien cambiara algo cerca.
 */

export const fuenteSerif = localFont({
  src: [
    { path: '../fuentes/libre-caslon-text-400.woff2', weight: '400', style: 'normal' },
    { path: '../fuentes/libre-caslon-text-700.woff2', weight: '700', style: 'normal' },
  ],
  variable: '--fuente-serif',
  display: 'swap',
  // La de reserva no es un adorno: mientras carga, el navegador pinta con
  // ella, y next/font le ajusta las métricas para que el salto no mueva
  // la página entera.
  fallback: ['Georgia', 'Cambria', 'Times New Roman', 'serif'],
})

export const fuenteSans = localFont({
  src: [
    { path: '../fuentes/plus-jakarta-sans-variable.woff2', weight: '200 800', style: 'normal' },
  ],
  variable: '--fuente-sans',
  display: 'swap',
  fallback: ['-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Roboto', 'sans-serif'],
})
