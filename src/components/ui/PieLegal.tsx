import Link from 'next/link'
import { DOMICILIO, EMPRESA } from '@/lib/empresa'

/**
 * El pie de las páginas públicas.
 *
 * Existe por una razón concreta que salió en la auditoría: hasta ahora
 * la portada solo enlazaba a registro, a login y a un ancla. No había
 * forma de saber quién está detrás de SAVE, ni de leer los términos, ni
 * de escribir a nadie. Para un producto que guarda cédulas y contratos
 * de terceros, eso es un problema de confianza antes que de SEO.
 */
export default function PieLegal() {
  const enlaces = [
    { href: '/precios', texto: 'Precios' },
    { href: '/terminos', texto: 'Términos de servicio' },
    { href: '/privacidad', texto: 'Privacidad' },
    { href: '/contacto', texto: 'Contacto' },
  ]

  return (
    <footer className="border-t border-[#e8e5df] bg-[#fcf9f8] text-[#414845]">
      <div className="mx-auto flex max-w-[1200px] flex-col gap-6 px-6 py-10 md:flex-row md:items-start md:justify-between md:px-12">
        <div>
          <p className="font-serif text-lg font-bold text-[#0D2C24]">{EMPRESA.nombreComercial}</p>
          <p className="mt-1 text-sm">
            {EMPRESA.nombreLegal} · RNC {EMPRESA.rnc}
          </p>
          <p className="max-w-[38ch] text-sm">{DOMICILIO}</p>
          <p className="mt-2 flex flex-wrap gap-x-4 gap-y-1 text-sm">
            <a
              href={`mailto:${EMPRESA.correo}`}
              className="underline decoration-[#c5a059] underline-offset-4 hover:text-[#0D2C24]"
            >
              {EMPRESA.correo}
            </a>
            <a
              href={`tel:${EMPRESA.telefonoE164}`}
              className="underline decoration-[#c5a059] underline-offset-4 hover:text-[#0D2C24]"
            >
              {EMPRESA.telefono}
            </a>
          </p>
        </div>

        <nav aria-label="Enlaces legales" className="flex flex-col gap-2 text-sm">
          {enlaces.map((e) => (
            <Link key={e.href} href={e.href} className="hover:text-[#0D2C24] hover:underline underline-offset-4">
              {e.texto}
            </Link>
          ))}
        </nav>
      </div>

      <div className="border-t border-[#e8e5df] px-6 py-5 md:px-12">
        <p className="mx-auto max-w-[1200px] text-xs text-[#6b7570]">
          SAVE Documentos es una herramienta de redacción. No presta servicios de asesoría jurídica
          ni sustituye el criterio de un abogado o un notario.
        </p>
      </div>
    </footer>
  )
}
