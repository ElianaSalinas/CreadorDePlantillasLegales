import { redirect } from 'next/navigation'
import PasswordInput from '@/components/ui/PasswordInput'
import { createClient } from '@/utils/supabase/server'
import { updatePassword } from './actions'

// No tiene nada que hacer en Google, y además heredaba la
// descripción del layout raíz, duplicándola en cada pantalla.
export const metadata = {
  title: 'Nueva contraseña',
  robots: { index: false, follow: false },
}
export const dynamic = 'force-dynamic'

export default async function ResetPasswordPage({
  searchParams,
}: {
  searchParams: Promise<{ message?: string }>
}) {
  const params = await searchParams

  // A esta pantalla solo se llega con la sesión temporal que crea el
  // enlace del correo. Sin ella, de vuelta a pedir uno nuevo.
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    redirect(
      '/forgot-password?message=' +
        encodeURIComponent('Abre el enlace desde tu correo para cambiar la contraseña.')
    )
  }

  return (
    <div className="flex min-h-screen items-center justify-center bg-slate-50 p-4 dark:bg-slate-950">
      <div className="w-full max-w-md overflow-hidden rounded-xl border border-slate-200 bg-white shadow-xl dark:border-slate-800 dark:bg-slate-900">
        <div className="p-8">
          <div className="mb-8 text-center">
            <h1 className="text-2xl font-bold text-slate-900 dark:text-white">Nueva contraseña</h1>
            <p className="mt-2 text-sm text-slate-500">
              Estás cambiando la contraseña de <strong>{user.email}</strong>.
            </p>
          </div>

          <form className="space-y-4" action={updatePassword}>
            <PasswordInput
              label="Nueva contraseña"
              autoComplete="new-password"
              hint="Mínimo 6 caracteres."
            />
            <PasswordInput
              name="confirm_password"
              label="Repite la contraseña"
              autoComplete="new-password"
            />

            {params.message && (
              <p className="rounded bg-red-50 p-2 text-center text-sm text-red-500 dark:bg-red-900/20">
                {params.message}
              </p>
            )}

            <button
              type="submit"
              className="mt-6 w-full rounded-lg bg-emerald-600 py-2.5 font-semibold text-white transition-colors hover:bg-emerald-700"
            >
              Guardar y entrar
            </button>
          </form>
        </div>
      </div>
    </div>
  )
}
