import Link from 'next/link'
import { MailCheck } from 'lucide-react'
import { requestPasswordReset } from './actions'

export const metadata = { title: 'Recuperar contraseña' }

export default async function ForgotPasswordPage({
  searchParams,
}: {
  searchParams: Promise<{ message?: string; sent?: string }>
}) {
  const params = await searchParams

  return (
    <div className="flex min-h-screen items-center justify-center bg-slate-50 p-4 dark:bg-slate-950">
      <div className="w-full max-w-md overflow-hidden rounded-xl border border-slate-200 bg-white shadow-xl dark:border-slate-800 dark:bg-slate-900">
        <div className="p-8">
          {params.sent ? (
            <div className="text-center">
              <span className="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-full bg-emerald-50 text-emerald-600 dark:bg-emerald-900/20">
                <MailCheck size={22} />
              </span>
              <h1 className="text-2xl font-bold text-slate-900 dark:text-white">Revisa tu correo</h1>
              <p className="mt-3 text-sm text-slate-500">
                Si existe una cuenta con ese correo, te enviamos un enlace para crear una contraseña
                nueva. El enlace vence en una hora.
              </p>
              <p className="mt-3 text-sm text-slate-500">
                ¿No lo ves? Revisa la carpeta de spam antes de volver a intentarlo.
              </p>
              <Link
                href="/login"
                className="mt-6 inline-block font-semibold text-emerald-600 hover:underline"
              >
                Volver a iniciar sesión
              </Link>
            </div>
          ) : (
            <>
              <div className="mb-8 text-center">
                <h1 className="text-2xl font-bold text-slate-900 dark:text-white">
                  Recuperar contraseña
                </h1>
                <p className="mt-2 text-sm text-slate-500">
                  Te enviaremos un enlace para crear una nueva.
                </p>
              </div>

              <form className="space-y-4" action={requestPasswordReset}>
                <div>
                  <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
                    Email
                  </label>
                  <input
                    name="email"
                    type="email"
                    required
                    autoComplete="email"
                    placeholder="tu@despacho.do"
                    className="w-full rounded-lg border border-slate-300 bg-slate-50 px-4 py-2 text-slate-900 outline-none focus:ring-2 focus:ring-emerald-500 dark:border-slate-700 dark:bg-slate-800 dark:text-white"
                  />
                </div>

                {params.message && (
                  <p className="rounded bg-red-50 p-2 text-center text-sm text-red-500 dark:bg-red-900/20">
                    {params.message}
                  </p>
                )}

                <button
                  type="submit"
                  className="mt-6 w-full rounded-lg bg-emerald-600 py-2.5 font-semibold text-white transition-colors hover:bg-emerald-700"
                >
                  Enviar enlace
                </button>
              </form>

              <div className="mt-6 text-center text-sm text-slate-500">
                <Link href="/login" className="font-semibold text-emerald-600 hover:underline">
                  Volver a iniciar sesión
                </Link>
              </div>
            </>
          )}
        </div>
      </div>
    </div>
  )
}
