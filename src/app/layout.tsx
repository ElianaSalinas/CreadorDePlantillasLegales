import type { Metadata } from 'next'
import Script from 'next/script'
import '../index.css'
import { OG_IMAGE } from '@/lib/og'
import { fuenteSerif, fuenteSans } from '@/lib/fuentes'
import Analitica from '@/components/analitica/Analitica'
import Consentimiento from '@/components/analitica/Consentimiento'

export const metadata: Metadata = {
  metadataBase: new URL('https://savedocumentos.com'),
  title: {
    default: 'SAVE Documentos',
    template: '%s · SAVE Documentos',
  },
  description:
    'Creación y automatización de documentos profesionales para abogados, inmobiliarias y empresas en República Dominicana.',
  applicationName: 'SAVE Documentos',

  /**
   * Verificacion de Google Search Console.
   *
   * Next lo convierte en la etiqueta <meta name="google-site-verification">
   * que pide Google. Va aqui y no escrito a mano en el <head> para que
   * viva con el resto de la metadata y nadie lo borre por accidente al
   * tocar el layout.
   *
   * NO se quita nunca despues de verificar: Google revisa la propiedad
   * cada cierto tiempo y si la etiqueta desaparecio, retira el acceso.
   */
  verification: {
    google: 'rdzIGn9z7OY4tu1Ju6CClLSTS8KGVwtsHNNFye3d-vk',
  },

  /**
   * La tarjeta que se ve al compartir el enlace.
   *
   * Sin esto, WhatsApp y LinkedIn ensenaban el enlace pelado. En
   * Republica Dominicana casi todo lo que se comparte pasa por
   * WhatsApp, asi que era la primera impresion de la marca en el sitio
   * donde mas se da, y no habia ninguna.
   *
   * Es un PNG estatico y no una imagen generada en cada peticion: la
   * tarjeta no cambia nunca, y los rastreadores de WhatsApp y X se
   * rinden en un par de segundos. Generarla al vuelo seria pagar ese
   * riesgo a cambio de nada.
   *
   * La URL va absoluta porque los rastreadores no resuelven rutas
   * relativas. `metadataBase` ya esta arriba, que es quien la completa.
   */
  openGraph: {
    type: 'website',
    siteName: 'SAVE Documentos',
    locale: 'es_DO',
    url: 'https://savedocumentos.com',
    title: 'SAVE Documentos — Crea documentos. Automatiza tu trabajo.',
    description:
      'Contratos, actos y poderes listos en minutos. Plantillas inteligentes para abogados, inmobiliarias y empresas en Republica Dominicana.',
    images: OG_IMAGE,
  },

  twitter: {
    card: 'summary_large_image',
    title: 'SAVE Documentos — Crea documentos. Automatiza tu trabajo.',
    description:
      'Contratos, actos y poderes listos en minutos. Hecho para Republica Dominicana.',
    images: ['/og.png'],
  },
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    // `light` es solo el punto de partida del HTML servido: el script de
    // abajo lo corrige antes de que se pinte nada. Sin una clase inicial,
    // el servidor y el cliente renderizarían distinto.
    <html
      lang="es-DO"
      className={`light ${fuenteSerif.variable} ${fuenteSans.variable}`}
      suppressHydrationWarning
    >
      <head>
        {/*
          El tema, antes del primer pixel.

          Va EN LÍNEA y SÍNCRONO a propósito. Si esto se hiciera en un
          efecto de React, el navegador ya habría pintado la página en
          claro y el usuario vería un fogonazo blanco antes de que
          apareciera su tema oscuro. Es un parpadeo pequeño y molesto que
          delata que el tema es un añadido.

          Va con `next/script` y `beforeInteractive` en vez de un <script>
          suelto: un <script> dentro de un componente funciona al servir
          la página, pero React avisa por consola de que nunca se ejecuta
          al renderizar en cliente. Deuda en la consola es deuda.

          La lógica está duplicada con `aplicarTema` en SelectorDeTema, y
          eso es deliberado: aquí no puede haber un import, porque esto
          corre antes de que exista un solo módulo de la aplicación. Si
          se cambia una, hay que cambiar la otra.
        */}
        <Script id="save-tema-inicial" strategy="beforeInteractive">
          {`(function(){try{var v=localStorage.getItem('save-tema');var o=v==='oscuro'||(v!=='claro'&&window.matchMedia('(prefers-color-scheme: dark)').matches);var c=document.documentElement.classList;c.toggle('dark',o);c.toggle('light',!o);}catch(e){}})();`}
        </Script>
      </head>
      <body suppressHydrationWarning>
        {children}
        {/*
          El identificador se lee AQUI, en el servidor, y baja como prop.

          `NEXT_PUBLIC_GA_ID` es una variable de build: Next la sustituye
          por su valor al compilar. Como el Dockerfile no declaraba
          ningun ARG, en el contenedor de build valia `undefined` — es
          exactamente lo que dejo /precios roto en cada despliegue. El
          Dockerfile ya la declara; si algun dia falta, esto vale
          undefined y la analitica sencillamente no se monta, en vez de
          romper la pagina.

          Cambiar el ID exige REDESPLEGAR, no basta con tocar la
          variable en Railway: el valor viaja dentro del bundle.
        */}
        <Analitica id={process.env.NEXT_PUBLIC_GA_ID} />
        <Consentimiento />
      </body>
    </html>
  )
}
