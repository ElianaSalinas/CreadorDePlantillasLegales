import type { Metadata } from 'next'
import Link from 'next/link'
import PieLegal from '@/components/ui/PieLegal'
import { EMPRESA, LEYES, VIGENCIA_LEGAL } from '@/lib/empresa'

export const metadata: Metadata = {
  title: { absolute: 'Política de privacidad · SAVE Documentos' },
  description:
    'Qué datos guarda SAVE Documentos, para qué, dónde están alojados y cómo ejercer tus derechos conforme a la Ley 172-13 de República Dominicana.',
  alternates: { canonical: `${EMPRESA.url}/privacidad` },
}

/**
 * Política de privacidad, escrita contra la Ley 172-13.
 *
 * Está ordenada según lo que el artículo 5 exige informar «de forma
 * expresa y clara»: quién es el responsable, con qué finalidad, a
 * quiénes se ceden los datos y qué derechos tiene el titular.
 *
 * Dos cosas que casi ningún SaaS dominicano dice y aquí sí:
 *
 *   §3  La distinción entre TUS datos y los datos de TUS CLIENTES. Un
 *       contrato lleva la cédula y el domicilio de terceros que nunca
 *       han oído hablar de SAVE. Frente a ellos el responsable eres tú;
 *       nosotros solo guardamos lo que tú escribes. Confundir esto hace
 *       que nadie asuma la obligación que la ley sí impone a alguien.
 *
 *   §5  Que los servidores están fuera del país. El artículo 80 regula
 *       la transferencia internacional, y omitirlo es probablemente el
 *       incumplimiento más extendido del sector.
 */
export default function PrivacidadPage() {
  return (
    <div className="min-h-screen bg-[#fcf9f8] text-[#1A1A1A]">
      <main className="mx-auto max-w-[760px] px-6 py-16 md:px-12 md:py-24">
        <Link href="/" className="text-sm text-[#414845] underline underline-offset-4 hover:text-[#0D2C24]">
          Volver al inicio
        </Link>

        <h1 className="mt-6 font-serif text-4xl font-bold leading-tight tracking-tight text-[#0D2C24] md:text-5xl">
          Política de privacidad
        </h1>
        <p className="mt-4 text-[#414845]">
          En vigor desde el {VIGENCIA_LEGAL}. Redactada conforme a la {LEYES.datos.numero}{' '}
          {LEYES.datos.titulo}, del {LEYES.datos.fecha}.
        </p>

        <Seccion n="1" titulo="Quién responde por tus datos">
          <p>
            {EMPRESA.nombreLegal}, RNC {EMPRESA.rnc}, con domicilio en {EMPRESA.ciudad},{' '}
            {EMPRESA.pais}. Puedes escribirnos a{' '}
            <a href={`mailto:${EMPRESA.correo}`} className="underline decoration-[#c5a059] underline-offset-4">
              {EMPRESA.correo}
            </a>
            .
          </p>
        </Seccion>

        <Seccion n="2" titulo="Qué datos tuyos guardamos">
          <ul>
            <li>
              <strong>De tu cuenta:</strong> nombre, apellido, correo, teléfono si lo escribes, perfil
              profesional y matrícula del Colegio de Abogados si la aportas.
            </li>
            <li>
              <strong>De tu despacho:</strong> nombre, plan contratado y quiénes son sus integrantes.
            </li>
            <li>
              <strong>De tu actividad:</strong> qué documentos generas y cuándo, para llevar la cuenta
              de tu plan y para el registro de auditoría del despacho.
            </li>
            <li>
              <strong>Técnicos:</strong> los datos mínimos que deja cualquier visita a un sitio web
              —dirección IP, tipo de navegador— para que el servicio funcione y sea seguro.
            </li>
          </ul>
          <p>
            No usamos cookies de publicidad ni de seguimiento de terceros. Las únicas cookies que
            ponemos son las que mantienen tu sesión abierta.
          </p>
        </Seccion>

        <Seccion n="3" titulo="Los datos de tus clientes son otra cosa">
          <p>
            Cuando redactas un contrato escribes la cédula, el domicilio y el nombre de personas que
            no tienen cuenta en SAVE ni han oído hablar de nosotros. Conviene ser claros sobre quién
            responde por esos datos:
          </p>
          <p className="rounded-lg border border-[#e8e5df] bg-white p-4">
            <strong className="text-[#0D2C24]">Frente a tus clientes, el responsable eres tú.</strong>{' '}
            Nosotros solo almacenamos y procesamos lo que tú escribes, siguiendo tus instrucciones, y
            no lo usamos para ninguna finalidad propia. Eres tú quien debe tener la base legal para
            tratar esos datos, informar a esas personas y atender sus derechos, conforme a la{' '}
            {LEYES.datos.numero}.
          </p>
          <p>
            Nosotros nos comprometemos a guardarlos con las medidas de seguridad que se describen más
            abajo, a no cederlos a nadie salvo lo dicho en el punto 5, y a mantener sobre ellos el
            deber de secreto del artículo 5.6 de la ley, que sigue vigente aunque cierres tu cuenta.
          </p>
        </Seccion>

        <Seccion n="4" titulo="Para qué los usamos">
          <ul>
            <li>Prestarte el servicio: crear tu cuenta, generar tus documentos, guardar tu bóveda.</li>
            <li>Cobrarte el plan que hayas contratado y llevar la cuenta de sus límites.</li>
            <li>Escribirte cuando hace falta: confirmar tu correo, restablecer tu contraseña, avisarte de un pago pendiente o de un cambio en estos términos.</li>
            <li>Mantener el registro de auditoría de tu despacho, para que el titular pueda saber quién hizo qué.</li>
            <li>Proteger el servicio frente a usos indebidos.</li>
          </ul>
          <p>
            No vendemos tus datos. No los cedemos a anunciantes. No entrenamos modelos con el
            contenido de tus documentos.
          </p>
        </Seccion>

        <Seccion n="5" titulo="Con quién los compartimos, y dónde están alojados">
          <p>
            Para funcionar, SAVE se apoya en tres proveedores. Ninguno usa tus datos para fines
            propios:
          </p>
          <ul>
            <li>
              <strong>Supabase</strong> — base de datos, autenticación y almacenamiento de la bóveda.
            </li>
            <li>
              <strong>Railway</strong> — servidores donde se ejecuta la aplicación.
            </li>
            <li>
              <strong>Hostinger</strong> — envío de los correos del servicio.
            </li>
          </ul>
          <p className="rounded-lg border border-[#e8e5df] bg-white p-4">
            <strong className="text-[#0D2C24]">
              Esos servidores están fuera de la {EMPRESA.pais}.
            </strong>{' '}
            Eso significa que usar SAVE implica una transferencia internacional de datos, de las que
            regula el artículo 80 de la {LEYES.datos.numero}. La base de esa transferencia es tu
            consentimiento y la necesidad de ejecutar el contrato de servicio que tienes con nosotros.
            Al crear una cuenta lo aceptas; si no estás de acuerdo, no podemos prestarte el servicio.
          </p>
          <p>
            Además, podemos entregar información cuando una autoridad competente lo requiera conforme
            a la ley. Si eso ocurriera y la ley nos permitiera avisarte, te avisaríamos.
          </p>
        </Seccion>

        <Seccion n="6" titulo="Cuánto tiempo los guardamos">
          <p>
            Mientras tengas cuenta. Si dejas de pagar, tu cuenta pasa a solo lectura pero{' '}
            <strong>no borramos tus documentos</strong>.
          </p>
          <p>
            Si pides que se elimine tu cuenta, borramos tus datos y tus documentos en un plazo máximo
            de treinta días, salvo lo que tengamos obligación legal de conservar —por ejemplo, los
            registros de facturación—.
          </p>
        </Seccion>

        <Seccion n="7" titulo="Tus derechos">
          <p>
            La {LEYES.datos.numero} te reconoce cuatro derechos sobre tus datos, y puedes ejercerlos
            escribiéndonos a{' '}
            <a href={`mailto:${EMPRESA.correo}`} className="underline decoration-[#c5a059] underline-offset-4">
              {EMPRESA.correo}
            </a>{' '}
            desde el correo de tu cuenta:
          </p>
          <ul>
            <li>
              <strong>Acceso</strong> (art. 10): saber qué datos tuyos tenemos y para qué los usamos.
            </li>
            <li>
              <strong>Rectificación</strong> (art. 8): corregir lo que esté mal o incompleto. La ley
              nos da un máximo de diez días hábiles; casi todo puedes corregirlo tú mismo en Mi
              Despacho.
            </li>
            <li>
              <strong>Cancelación</strong> (art. 14): pedir que borremos tus datos.
            </li>
            <li>
              <strong>Oposición</strong> (art. 9): oponerte a un tratamiento concreto.
            </li>
          </ul>
          <p>
            Te responderemos dentro de los plazos que marca la ley. Si consideras que no hemos
            atendido bien tu solicitud, la propia ley prevé la acción de <em>habeas data</em> ante los
            tribunales.
          </p>
        </Seccion>

        <Seccion n="8" titulo="Cómo los protegemos">
          <p>
            El artículo 5.5 de la {LEYES.datos.numero} exige medidas técnicas, organizativas y de
            seguridad. Estas son las nuestras, en concreto:
          </p>
          <ul>
            <li>Todo el tráfico viaja cifrado por HTTPS.</li>
            <li>
              Cada despacho está aislado de los demás por reglas aplicadas en la propia base de datos,
              no solo en la aplicación. Aunque alguien esquivara la interfaz, las filas de otro
              despacho seguirían sin poder leerse.
            </li>
            <li>
              Los archivos de la bóveda se guardan en un almacenamiento privado, nunca en direcciones
              públicas, y nacen visibles solo para quien los sube y el titular del despacho.
            </li>
            <li>Las contraseñas se guardan cifradas; nadie de SAVE puede leerlas.</li>
            <li>El acceso a los sistemas de producción está limitado a quien lo necesita.</li>
          </ul>
          <p>
            Ningún sistema es infalible. Si ocurriera una brecha que afectara a tus datos, te lo
            comunicaríamos y explicaríamos qué pasó y qué hicimos.
          </p>
        </Seccion>

        <Seccion n="9" titulo="Menores">
          <p>
            SAVE está dirigido a profesionales y empresas. No creamos cuentas a personas menores de
            edad ni recogemos datos suyos a sabiendas.
          </p>
        </Seccion>

        <Seccion n="10" titulo="Cambios en esta política">
          <p>
            Si cambiamos algo relevante te avisaremos al correo de tu cuenta antes de que entre en
            vigor. La fecha de arriba indica la última revisión.
          </p>
          <p className="text-sm text-[#6b7570]">
            Nota: en el Congreso dominicano hay en trámite un proyecto de reforma de la{' '}
            {LEYES.datos.numero}. Si se aprueba, revisaremos esta política para ajustarla y te lo
            comunicaremos.
          </p>
        </Seccion>
      </main>

      <PieLegal />
    </div>
  )
}

function Seccion({ n, titulo, children }: { n: string; titulo: string; children: React.ReactNode }) {
  return (
    <section className="mt-12 border-t border-[#e8e5df] pt-8">
      <h2 className="font-serif text-2xl font-bold leading-snug text-[#0D2C24]">
        <span className="mr-2 text-[#c5a059]">{n}.</span>
        {titulo}
      </h2>
      <div className="mt-4 space-y-4 leading-relaxed text-[#2c3330] [&_li]:mb-1.5 [&_ul]:list-disc [&_ul]:space-y-1 [&_ul]:pl-6">
        {children}
      </div>
    </section>
  )
}
