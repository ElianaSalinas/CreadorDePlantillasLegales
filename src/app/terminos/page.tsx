import type { Metadata } from 'next'
import Link from 'next/link'
import PieLegal from '@/components/ui/PieLegal'
import { DOMICILIO, EMPRESA, LEYES, VIGENCIA_LEGAL } from '@/lib/empresa'

export const metadata: Metadata = {
  title: { absolute: 'Términos de servicio · SAVE Documentos' },
  description:
    'Las condiciones de uso de SAVE Documentos: qué hace la herramienta, qué no hace, de quién son tus documentos y qué pasa si dejas de pagar.',
  alternates: { canonical: `${EMPRESA.url}/terminos` },
}

/**
 * Términos de servicio.
 *
 * Dos cláusulas de aquí no aparecen en los términos de otras
 * plataformas parecidas, y son justo las que más falta hacen en un
 * producto legal dominicano:
 *
 *   §2  SAVE no presta asesoría jurídica. Alegra, por ejemplo, no tiene
 *       una cláusula equivalente para lo contable. En un país donde
 *       ejercer la abogacía está reglado, decirlo importa.
 *
 *   §3  SAVE no firma documentos. La Ley 126-02 distingue la firma
 *       electrónica de la firma digital certificada por INDOTEL, y un
 *       usuario podría dar por hecho que el documento que descarga ya
 *       está firmado. No lo está.
 *
 * Y §6 dice en voz alta lo que se decidió el 5 de septiembre: no se
 * borran documentos por falta de pago. Es más generoso que lo que
 * ofrecen otros —Alegra se reserva eliminar la información 15 días
 * después del impago— y por eso conviene que esté escrito, no solo
 * implementado.
 */
export default function TerminosPage() {
  return (
    <div className="min-h-screen bg-slate-50 text-[#1A1A1A]">
      <main className="mx-auto max-w-[760px] px-6 py-16 md:px-12 md:py-24">
        <Link href="/" className="text-sm text-[#414845] underline underline-offset-4 hover:text-[#0D2C24]">
          Volver al inicio
        </Link>

        <h1 className="mt-6 font-serif text-4xl font-bold leading-tight tracking-tight text-[#0D2C24] md:text-5xl">
          Términos de servicio
        </h1>
        <p className="mt-4 text-[#414845]">
          En vigor desde el {VIGENCIA_LEGAL}. Estos términos rigen el uso de {EMPRESA.nombreComercial},
          un servicio de {EMPRESA.nombreLegal} (RNC {EMPRESA.rnc}), con domicilio en {DOMICILIO}.
        </p>

        <Seccion n="1" titulo="Qué es SAVE Documentos">
          <p>
            SAVE es una herramienta para redactar documentos a partir de plantillas. Respondes un
            formulario, el sistema arma el texto y tú lo descargas en Word o PDF. También puedes
            convertir en plantilla un documento que ya usas, y guardar archivos en tu bóveda.
          </p>
          <p>
            Al crear una cuenta aceptas estos términos. Si los usas en nombre de un despacho o una
            empresa, declaras que tienes facultad para obligarla.
          </p>
        </Seccion>

        <Seccion n="2" titulo="SAVE no presta asesoría jurídica">
          <p className="font-semibold text-[#0D2C24]">
            Esta es la cláusula más importante de todo el documento.
          </p>
          <p>
            SAVE es un programa de redacción, no un despacho de abogados. No damos asesoría legal,
            no representamos a nadie, no revisamos tu caso concreto y no opinamos sobre si un
            documento sirve para lo que necesitas.
          </p>
          <p>
            Las plantillas del catálogo las revisa un profesional del derecho dominicano antes de
            publicarse, y ninguna se publica sin esa revisión. Aun así, una plantilla es un punto de
            partida general: no conoce tu situación, ni la otra parte, ni lo que se habló antes.{' '}
            <strong>
              La decisión de usar un documento, y la responsabilidad por lo que ese documento diga,
              son siempre tuyas.
            </strong>
          </p>
          <p>
            Para asuntos con consecuencias serias —y en materia legal casi todos las tienen— consulta
            con un abogado o un notario. Usar SAVE no sustituye esa consulta.
          </p>
        </Seccion>

        <Seccion n="3" titulo="SAVE no firma documentos">
          <p>
            SAVE genera el documento; no lo firma ni le da valor de firma. La{' '}
            <strong>{LEYES.comercioElectronico.numero}</strong> {LEYES.comercioElectronico.titulo}{' '}
            distingue la firma electrónica de la firma digital emitida por una entidad de
            certificación autorizada por INDOTEL. SAVE no es una entidad de certificación y no emite
            ninguna de las dos.
          </p>
          <p>
            El documento que descargas se firma como se firma cualquier otro: a mano, ante notario si
            el acto lo requiere, o con un proveedor de firma digital certificado. Que un documento
            salga de SAVE no lo hace válido por sí solo.
          </p>
        </Seccion>

        <Seccion n="4" titulo="Tu cuenta y tu despacho">
          <p>
            Eres responsable de tu contraseña y de lo que se haga desde tu cuenta. Avísanos en
            cuanto sospeches que alguien más ha entrado.
          </p>
          <p>
            En el plan Equipo, el titular del despacho decide quién entra, con qué permisos y quién
            sale. El titular ve los documentos y los archivos de su despacho, incluidos los que un
            integrante haya marcado como privados; eso se explica en la interfaz allí donde ocurre.
          </p>
          <p>
            Si sales de un despacho, tu cuenta no desaparece: pasa a ser independiente y conservas tu
            espacio propio.
          </p>
        </Seccion>

        <Seccion n="5" titulo="Planes y pagos">
          <p>
            Los planes vigentes, con lo que incluye cada uno y su precio, están en{' '}
            <Link href="/precios" className="underline decoration-[#c5a059] underline-offset-4">
              la página de precios
            </Link>
            . Los precios se expresan en pesos dominicanos.
          </p>
          <p>
            Podemos cambiar los precios avisando con al menos treinta días de antelación al correo de
            tu cuenta. Si no te convienen, puedes bajarte de plan o cerrar la cuenta antes de que el
            cambio entre en vigor.
          </p>
        </Seccion>

        <Seccion n="6" titulo="Si dejas de pagar">
          <p>
            Tienes <strong>siete días de gracia</strong> desde el cobro fallido, durante los cuales
            todo sigue funcionando con normalidad.
          </p>
          <p>
            Pasados esos días la cuenta queda <strong>en solo lectura</strong>: no podrás crear
            documentos nuevos ni subir archivos, pero seguirás pudiendo abrir, consultar y descargar
            todo lo que ya tenías.
          </p>
          <p className="rounded-lg border border-slate-200 bg-white p-4">
            <strong className="text-[#0D2C24]">No borramos tus documentos por falta de pago.</strong>{' '}
            Ni a los siete días, ni a los treinta. Lo que escribiste en SAVE sigue siendo tuyo y
            accesible. Si algún día tuviéramos que cerrar el servicio, te avisaríamos con antelación
            suficiente para que te lleves todo.
          </p>
        </Seccion>

        <Seccion n="7" titulo="De quién son los documentos">
          <p>
            <strong>Tuyos.</strong> El contenido que escribes, subes o generas en SAVE es tuyo y en
            ningún momento pasa a ser nuestro. Puedes descargarlo cuando quieras, en Word o en PDF,
            sin pedirnos permiso ni pagar nada extra por ello.
          </p>
          <p>
            Accedemos a tu contenido únicamente cuando hace falta para prestarte el servicio, para
            resolver un problema técnico que nos reportes, o cuando una autoridad competente nos lo
            requiera conforme a la ley. No lo usamos para ninguna otra cosa.
          </p>
          <p>
            El programa, el catálogo de plantillas y las cláusulas que redactamos son nuestros. Puedes
            usarlos para tu trabajo; no puedes revenderlos ni redistribuirlos como catálogo propio.
          </p>
        </Seccion>

        <Seccion n="8" titulo="Uso aceptable">
          <p>No puedes usar SAVE para:</p>
          <ul>
            <li>Redactar documentos destinados a cometer un fraude o a engañar a alguien.</li>
            <li>Suplantar a una persona o a una empresa.</li>
            <li>
              Tratar datos personales de terceros sin la base legal que exige la{' '}
              {LEYES.datos.numero}.
            </li>
            <li>Intentar acceder a cuentas, documentos o despachos que no son tuyos.</li>
          </ul>
          <p>
            Si detectamos un uso así podemos suspender la cuenta. En ese caso te lo diremos y podrás
            descargar tus documentos.
          </p>
        </Seccion>

        <Seccion n="9" titulo="Disponibilidad y responsabilidad">
          <p>
            Hacemos lo razonable para que el servicio esté disponible, pero no garantizamos que
            funcione sin interrupciones. Puede haber mantenimientos, fallos de nuestros proveedores o
            causas de fuerza mayor.
          </p>
          <p>
            No respondemos por el contenido de los documentos que generas, ni por las consecuencias de
            usarlos, ni por errores en los datos que introduces. Nuestra responsabilidad, en lo que la
            ley permita limitarla, no excederá lo que hayas pagado por el servicio en los doce meses
            anteriores al hecho.
          </p>
        </Seccion>

        <Seccion n="10" titulo="Cambios en estos términos">
          <p>
            Si cambiamos algo importante te avisaremos al correo de tu cuenta con al menos treinta
            días de antelación. Los cambios menores —redacción, aclaraciones— se publican aquí con su
            fecha.
          </p>
        </Seccion>

        <Seccion n="11" titulo="Ley aplicable">
          <p>
            Estos términos se rigen por las leyes de la {EMPRESA.pais}. Para cualquier controversia
            las partes se someten a los tribunales competentes del Distrito Judicial de{' '}
            {EMPRESA.provincia}, sin perjuicio de los derechos que la ley reconozca al usuario
            consumidor.
          </p>
          <p>
            Para cualquier duda sobre estos términos, escríbenos a{' '}
            <a
              href={`mailto:${EMPRESA.correo}`}
              className="underline decoration-[#c5a059] underline-offset-4"
            >
              {EMPRESA.correo}
            </a>
            .
          </p>
        </Seccion>
      </main>

      <PieLegal />
    </div>
  )
}

function Seccion({ n, titulo, children }: { n: string; titulo: string; children: React.ReactNode }) {
  return (
    <section className="mt-12 border-t border-slate-200 pt-8">
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
