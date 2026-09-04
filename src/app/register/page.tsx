import Link from 'next/link'
import PasswordInput from '@/components/ui/PasswordInput'
import AuthShowcase from '@/components/ui/AuthShowcase'
import { register } from './actions'
import { PROF_ROLE_OPTIONS } from '@/lib/labels'

// No tiene nada que hacer en Google, y además heredaba la
// descripción del layout raíz, duplicándola en cada pantalla.
export const metadata = {
  title: 'Crear cuenta',
  robots: { index: false, follow: false },
}

const inputClass =
  'w-full rounded-lg border border-slate-300 bg-slate-50 px-4 py-2 text-slate-900 outline-none focus:ring-2 focus:ring-emerald-500 dark:border-slate-700 dark:bg-slate-800 dark:text-white'

export default async function RegisterPage({
  searchParams,
}: {
  searchParams: Promise<{ message?: string }>
}) {
  const params = await searchParams

  return (
    <div className="grid min-h-screen lg:grid-cols-2">
      <div className="flex items-center justify-center bg-white p-6 dark:bg-slate-950">
        <div className="w-full max-w-md py-10">
          <Link href="/" className="mb-10 flex items-center gap-2.5">
            <span className="flex h-8 w-8 items-center justify-center rounded-[7px] bg-[#0D2C24] font-serif text-base font-bold text-white">
              S
            </span>
            <span className="font-serif text-xl font-bold tracking-tight text-[#0D2C24] dark:text-white">
              SAVE
            </span>
          </Link>

          <h1 className="font-serif text-3xl font-bold text-slate-900 dark:text-white">
            Crear cuenta
          </h1>
          <p className="mt-2 text-sm text-slate-500">
            Gratis para empezar. Sin tarjeta de crédito.
          </p>

          <form className="mt-8 space-y-4" action={register}>
            <div className="flex gap-4">
              <div className="w-1/2">
                <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
                  Nombre
                </label>
                <input name="first_name" type="text" required placeholder="Ej. Laura" className={inputClass} />
              </div>
              <div className="w-1/2">
                <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
                  Apellido
                </label>
                <input name="last_name" type="text" required placeholder="Ej. Cifuentes" className={inputClass} />
              </div>
            </div>

            <div>
              <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
                Email Profesional
              </label>
              <input
                name="email"
                type="email"
                required
                autoComplete="email"
                placeholder="tu@despacho.do"
                className={inputClass}
              />
            </div>

            <PasswordInput autoComplete="new-password" hint="Mínimo 6 caracteres." />

            <div className="border-t border-slate-200 pt-4 dark:border-slate-700">
              <p className="mb-1 text-sm font-medium text-slate-700 dark:text-slate-300">
                ¿Cómo trabajas?
              </p>
              <p className="mb-3 text-xs text-slate-500">
                Puedes cambiarlo después en Mi Despacho.
              </p>
              <div className="flex flex-col gap-1">
                {PROF_ROLE_OPTIONS.map((o, i) => (
                  <label
                    key={o.value}
                    className="flex cursor-pointer items-start gap-3 rounded-lg border border-transparent p-2.5 transition-colors hover:border-slate-200 hover:bg-slate-50 has-[:checked]:border-emerald-500 has-[:checked]:bg-emerald-50 dark:hover:border-slate-700 dark:hover:bg-slate-800/50 dark:has-[:checked]:border-emerald-500 dark:has-[:checked]:bg-emerald-900/20"
                  >
                    <input
                      type="radio"
                      name="prof_role"
                      value={o.value}
                      defaultChecked={i === 0}
                      className="mt-0.5 border-slate-300 bg-slate-100 text-emerald-600 focus:ring-emerald-500 dark:border-slate-600 dark:bg-slate-800"
                    />
                    <span className="min-w-0">
                      <span className="block text-sm font-medium text-slate-700 dark:text-slate-200">
                        {o.label}
                      </span>
                      <span className="block text-xs text-slate-500 dark:text-slate-400">
                        {o.hint}
                      </span>
                    </span>
                  </label>
                ))}
              </div>
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
              Completar Registro
            </button>
          </form>

          <p className="mt-6 text-center text-sm text-slate-500">
            ¿Ya tienes cuenta?{' '}
            <Link href="/login" className="font-semibold text-emerald-600 hover:underline">
              Inicia Sesión
            </Link>
          </p>
        </div>
      </div>

      <AuthShowcase />
    </div>
  )
}
