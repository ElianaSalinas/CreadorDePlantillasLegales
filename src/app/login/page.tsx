import Link from 'next/link'
import PasswordInput from '@/components/ui/PasswordInput'
import AuthShowcase from '@/components/ui/AuthShowcase'
import { login } from './actions'

export const metadata = { title: 'Iniciar sesión' }

export default async function LoginPage({
  searchParams,
}: {
  searchParams: Promise<{ message?: string }>
}) {
  const params = await searchParams

  return (
    <div className="grid min-h-screen lg:grid-cols-2">
      <div className="flex items-center justify-center bg-white p-6 dark:bg-slate-950">
        <div className="w-full max-w-md">
          <Link href="/" className="mb-10 flex items-center gap-2.5">
            <span className="flex h-8 w-8 items-center justify-center rounded-[7px] bg-[#0D2C24] font-serif text-base font-bold text-white">
              S
            </span>
            <span className="font-serif text-xl font-bold tracking-tight text-[#0D2C24] dark:text-white">
              SAVE
            </span>
          </Link>

          <h1 className="font-serif text-3xl font-bold text-slate-900 dark:text-white">
            Bienvenida de vuelta
          </h1>
          <p className="mt-2 text-sm text-slate-500">
            Entra a tu espacio de trabajo en Save Documentos.
          </p>

          <form className="mt-8 space-y-4" action={login}>
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

            <PasswordInput autoComplete="current-password" />

            <div className="text-right">
              <Link href="/forgot-password" className="text-sm text-emerald-600 hover:underline">
                ¿Olvidaste tu contraseña?
              </Link>
            </div>

            {params?.message && (
              <p className="rounded bg-red-50 p-2 text-center text-sm text-red-500 dark:bg-red-900/20">
                {params.message}
              </p>
            )}

            <button
              type="submit"
              className="mt-6 w-full rounded-lg bg-emerald-600 py-2.5 font-semibold text-white transition-colors hover:bg-emerald-700"
            >
              Ingresar a la Plataforma
            </button>
          </form>

          <p className="mt-6 text-center text-sm text-slate-500">
            ¿No tienes cuenta?{' '}
            <Link href="/register" className="font-semibold text-emerald-600 hover:underline">
              Regístrate como Profesional
            </Link>
          </p>
        </div>
      </div>

      <AuthShowcase />
    </div>
  )
}
