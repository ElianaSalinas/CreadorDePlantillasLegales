import Link from 'next/link'
import { cookies } from 'next/headers'
import { MailCheck } from 'lucide-react'
import AuthShowcase from '@/components/ui/AuthShowcase'
import { EMPRESA } from '@/lib/empresa'
import EventoAlLlegar from '@/components/analitica/EventoAlLlegar'

export const metadata = {
  title: 'Revisa tu correo',
  robots: { index: false, follow: false },
}

// Lee una cookie que escribe la acción de registro, así que no puede
// prerenderizarse.
export const dynamic = 'force-dynamic'

export default async function RevisaTuCorreoPage() {
  // El correo NO viaja en la URL. Un query param acaba en los logs del
  // servidor, en el historial del navegador y en la cabecera Referer
  // de cualquier recurso externo de la página. Va en una cookie de un
  // cuarto de hora que solo lee el servidor.
  const cookieStore = await cookies()
  const destino = cookieStore.get('save_registro_correo')?.value ?? null

  return (
    <div className="grid min-h-screen lg:grid-cols-2">
      <div className="flex items-center justify-center bg-slate-50 p-6 dark:bg-slate-950">
        <div className="w-full max-w-md py-10">
        {/* El alta se cuenta AQUI y no en el boton de registro: el boton
            puede volver con un error, y esta pantalla solo se ve cuando
            la cuenta existe de verdad. */}
        <EventoAlLlegar evento="sign_up" />
          <Link href="/" className="mb-10 flex items-center gap-2.5">
            <span className="flex h-8 w-8 items-center justify-center rounded-[7px] bg-[#0D2C24] font-serif text-base font-bold text-white">
              S
            </span>
            <span className="font-serif text-xl font-bold tracking-tight text-[#0D2C24] dark:text-white">
              SAVE
            </span>
          </Link>

          <div className="mb-6 flex h-12 w-12 items-center justify-center rounded-full bg-emerald-50 dark:bg-emerald-900/25">
            <MailCheck className="h-6 w-6 text-emerald-600" aria-hidden="true" />
          </div>

          <h1 className="font-serif text-3xl font-bold text-slate-900 dark:text-white">
            Tu cuenta está creada
          </h1>

          <p className="mt-3 text-[15px] leading-relaxed text-slate-600 dark:text-slate-300">
            Te acabamos de enviar un correo
            {destino ? (
              <>
                {' '}a <strong className="font-semibold text-slate-900 dark:text-white">{destino}</strong>
              </>
            ) : null}{' '}
            con un enlace para confirmar que esa dirección es tuya.{' '}
            <strong className="font-semibold text-slate-900 dark:text-white">
              Ábrelo y ya podrás entrar.
            </strong>
          </p>

          <div className="mt-7 rounded-xl border border-slate-200 bg-slate-50 p-5 dark:border-slate-800 dark:bg-slate-900">
            <p className="text-sm font-semibold text-slate-800 dark:text-slate-100">
              ¿No lo ves?
            </p>
            <ul className="mt-2.5 space-y-2 text-sm leading-relaxed text-slate-600 dark:text-slate-400">
              <li>
                Puede tardar un par de minutos en llegar.
              </li>
              <li>
                Mira en <strong className="font-medium text-slate-700 dark:text-slate-300">Spam</strong> o
                en <strong className="font-medium text-slate-700 dark:text-slate-300">Promociones</strong>.
                Es la razón número uno.
              </li>
              {destino ? (
                <li>
                  Comprueba que <strong className="font-medium text-slate-700 dark:text-slate-300">{destino}</strong>{' '}
                  esté bien escrito. Si te equivocaste,{' '}
                  <Link href="/register" className="font-semibold text-emerald-600 hover:underline">
                    vuelve a registrarte
                  </Link>{' '}
                  con la dirección correcta.
                </li>
              ) : (
                <li>
                  Comprueba que escribiste bien tu correo. Si no,{' '}
                  <Link href="/register" className="font-semibold text-emerald-600 hover:underline">
                    vuelve a registrarte
                  </Link>.
                </li>
              )}
              <li>
                Si sigue sin aparecer, escríbenos a{' '}
                <a
                  href={`mailto:${EMPRESA.correo}`}
                  className="font-semibold text-emerald-600 hover:underline"
                >
                  {EMPRESA.correo}
                </a>{' '}
                y lo activamos a mano.
              </li>
            </ul>
          </div>

          <Link
            href="/login"
            className="mt-7 block w-full rounded-lg bg-emerald-600 py-2.5 text-center font-semibold text-white transition-colors hover:bg-emerald-700"
          >
            Ya lo confirmé, quiero entrar
          </Link>

          <p className="mt-5 text-center text-sm text-slate-500">
            Puedes cerrar esta pestaña. El enlace sigue funcionando.
          </p>
        </div>
      </div>

      <AuthShowcase />
    </div>
  )
}
