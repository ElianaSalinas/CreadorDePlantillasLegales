import type { Metadata } from 'next'
import Link from 'next/link'
import { Mail, MapPin, Building2, Phone } from 'lucide-react'
import PieLegal from '@/components/ui/PieLegal'
import { DOMICILIO, EMPRESA } from '@/lib/empresa'

export const metadata: Metadata = {
  title: { absolute: 'Contacto · SAVE Documentos' },
  description:
    'Escríbenos o llámanos. SA&VE Comercial, S.R.L., Verón, Higüey, La Altagracia. Soporte, ventas y ejercicio de derechos sobre tus datos.',
  alternates: { canonical: `${EMPRESA.url}/contacto` },
}

/**
 * Contacto.
 *
 * Un correo de verdad y nada más. Aquí no hay formulario porque no
 * hay nadie detrás de un formulario todavía, y un formulario que no se
 * lee es peor que no tenerlo: la persona cree que ha avisado.
 */
export default function ContactoPage() {
  return (
    <div className="min-h-screen bg-[#fcf9f8] text-[#1A1A1A]">
      <main className="mx-auto max-w-[760px] px-6 py-16 md:px-12 md:py-24">
        <Link href="/" className="text-sm text-[#414845] underline underline-offset-4 hover:text-[#0D2C24]">
          Volver al inicio
        </Link>

        <h1 className="mt-6 font-serif text-4xl font-bold leading-tight tracking-tight text-[#0D2C24] md:text-5xl">
          Hablemos
        </h1>
        <p className="mt-4 max-w-[55ch] text-lg text-[#414845]">
          Escribe a una persona, no a un formulario. Contestamos en horario laboral dominicano.
        </p>

        <div className="mt-10 grid gap-4 sm:grid-cols-2">
          <a
            href={`mailto:${EMPRESA.correo}`}
            className="flex items-center gap-4 rounded-2xl border border-[#e8e5df] bg-white p-6 transition-colors hover:border-[#0D2C24]"
          >
            <span className="rounded-xl bg-[#f5f2ed] p-3 text-[#0D2C24]">
              <Mail size={22} />
            </span>
            <span className="min-w-0">
              <span className="block truncate font-serif text-lg font-bold text-[#0D2C24]">
                {EMPRESA.correo}
              </span>
              <span className="text-sm text-[#414845]">Soporte, ventas y facturación.</span>
            </span>
          </a>

          <a
            href={`tel:${EMPRESA.telefonoE164}`}
            className="flex items-center gap-4 rounded-2xl border border-[#e8e5df] bg-white p-6 transition-colors hover:border-[#0D2C24]"
          >
            <span className="rounded-xl bg-[#f5f2ed] p-3 text-[#0D2C24]">
              <Phone size={22} />
            </span>
            <span className="min-w-0">
              <span className="block font-serif text-lg font-bold text-[#0D2C24]">
                {EMPRESA.telefono}
              </span>
              <span className="text-sm text-[#414845]">En horario laboral dominicano.</span>
            </span>
          </a>
        </div>

        <section className="mt-12 border-t border-[#e8e5df] pt-8">
          <h2 className="font-serif text-2xl font-bold text-[#0D2C24]">Quiénes somos</h2>
          <div className="mt-5 space-y-4 text-[#2c3330]">
            <p className="flex items-start gap-3">
              <Building2 size={18} className="mt-1 shrink-0 text-[#c5a059]" />
              <span>
                <strong>{EMPRESA.nombreLegal}</strong>
                <br />
                RNC {EMPRESA.rnc}
              </span>
            </p>
            <p className="flex items-start gap-3">
              <MapPin size={18} className="mt-1 shrink-0 text-[#c5a059]" />
              <span>{DOMICILIO}</span>
            </p>
            <p className="flex items-start gap-3">
              <Phone size={18} className="mt-1 shrink-0 text-[#c5a059]" />
              <a
                href={`tel:${EMPRESA.telefonoE164}`}
                className="underline decoration-[#c5a059] underline-offset-4"
              >
                {EMPRESA.telefono}
              </a>
            </p>
          </div>
          <p className="mt-6 leading-relaxed text-[#414845]">
            SAVE Documentos nació de una necesidad concreta: en un despacho dominicano se redactan
            los mismos contratos una y otra vez, cambiando cuatro datos cada vez. Todo el catálogo de
            plantillas lo revisa un profesional del derecho dominicano antes de publicarse, y el
            sistema no deja publicar ninguna sin esa firma.
          </p>
        </section>

        <section className="mt-12 border-t border-[#e8e5df] pt-8">
          <h2 className="font-serif text-2xl font-bold text-[#0D2C24]">
            Para ejercer tus derechos sobre tus datos
          </h2>
          <p className="mt-4 leading-relaxed text-[#414845]">
            Acceso, rectificación, cancelación y oposición: escríbenos al mismo correo{' '}
            <strong>desde la dirección de tu cuenta</strong> y dinos qué necesitas. Los plazos y el
            detalle están en la{' '}
            <Link href="/privacidad" className="underline decoration-[#c5a059] underline-offset-4">
              política de privacidad
            </Link>
            .
          </p>
        </section>
      </main>

      <PieLegal />
    </div>
  )
}
