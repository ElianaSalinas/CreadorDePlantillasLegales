import { redirect } from 'next/navigation'
import PasswordInput from '@/components/ui/PasswordInput'
import { createClient } from '@/utils/supabase/server'
import { definirPassword } from './actions'

// No tiene nada que hacer en Google, y además heredaba la
// descripción del layout raíz, duplicándola en cada pantalla.
export const metadata = {
  title: 'Crea tu contraseña',
  robots: { index: false, follow: false },
}
export const dynamic = 'force-dynamic'

/**
 * Donde aterriza quien acepta una invitación a un despacho.
 *
 * A esta pantalla solo se llega con la sesión temporal que crea el enlace
 * del correo. La membresía en el despacho ya la creó el trigger al
 * registrarse: aquí solo falta que la persona elija su contraseña.
 */
export default async function DefinirPasswordPage({
  searchParams,
}: {
  searchParams: Promise<{ message?: string }>
}) {
  const params = await searchParams

  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    redirect(
      '/login?message=' +
        encodeURIComponent('Abre el enlace desde tu correo para crear tu contraseña.')
    )
  }

  // Con qué despacho se ha encontrado, para saludarle por su nombre.
  const { data: membresia } = await supabase
    .from('org_members')
    .select('role, organizations(name, owner_id)')
    .eq('user_id', user.id)
    .returns<Array<{ role: string; organizations: { name: string; owner_id: string } | null }>>()

  const despacho = (membresia ?? []).find((m) => m.organizations && m.organizations.owner_id !== user.id)

  // Si quien invitó ya escribió un nombre, se muestra relleno en vez de
  // pedirlo otra vez.
  const { data: perfil } = await supabase
    .from('profiles')
    .select('first_name, last_name')
    .eq('id', user.id)
    .maybeSingle<{ first_name: string | null; last_name: string | null }>()

  return (
    <div className="flex min-h-screen items-center justify-center bg-slate-50 p-4 dark:bg-slate-950">
      <div className="w-full max-w-md overflow-hidden rounded-xl border border-slate-200 bg-white shadow-xl dark:border-slate-800 dark:bg-slate-900">
        <div className="p-8">
          <div className="mb-8 text-center">
            <h1 className="text-2xl font-bold text-slate-900 dark:text-white">
              Crea tu contraseña
            </h1>
            <p className="mt-2 text-sm text-slate-500">
              {despacho?.organizations
                ? <>Te han sumado a <strong>{despacho.organizations.name}</strong>. Elige una contraseña y entras.</>
                : <>Elige una contraseña para tu cuenta <strong>{user.email}</strong>.</>}
            </p>
          </div>

          <form action={definirPassword} className="space-y-4">
            {/* Se pide el nombre aquí y no después porque es el único
                momento en que esta persona está obligada a pasar por una
                pantalla. Sin nombre, sus compañeros la ven como un correo:
                el botón de compartir dice "Compartir con
                juana+prueba@gmail.com" en vez de "Compartir con Juana". */}
            <div className="grid grid-cols-2 gap-3">
              <div>
                <label
                  htmlFor="first_name"
                  className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300"
                >
                  Nombre
                </label>
                <input
                  id="first_name"
                  name="first_name"
                  type="text"
                  required
                  defaultValue={perfil?.first_name ?? ''}
                  autoComplete="given-name"
                  className="w-full rounded-lg border border-slate-300 bg-slate-50 px-3 py-2 text-slate-900 outline-none focus:border-emerald-500 focus:ring-1 focus:ring-emerald-500 dark:border-slate-700 dark:bg-slate-800 dark:text-white"
                />
              </div>
              <div>
                <label
                  htmlFor="last_name"
                  className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300"
                >
                  Apellido
                </label>
                <input
                  id="last_name"
                  name="last_name"
                  type="text"
                  required
                  defaultValue={perfil?.last_name ?? ''}
                  autoComplete="family-name"
                  className="w-full rounded-lg border border-slate-300 bg-slate-50 px-3 py-2 text-slate-900 outline-none focus:border-emerald-500 focus:ring-1 focus:ring-emerald-500 dark:border-slate-700 dark:bg-slate-800 dark:text-white"
                />
              </div>
            </div>

            <PasswordInput autoComplete="new-password" hint="Mínimo 6 caracteres." />

            <div>
              <label
                htmlFor="confirm_password"
                className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300"
              >
                Repite la contraseña
              </label>
              <input
                id="confirm_password"
                name="confirm_password"
                type="password"
                required
                autoComplete="new-password"
                className="w-full rounded-lg border border-slate-300 bg-slate-50 px-3 py-2 text-slate-900 outline-none focus:border-emerald-500 focus:ring-1 focus:ring-emerald-500 dark:border-slate-700 dark:bg-slate-800 dark:text-white"
              />
            </div>

            {params?.message && (
              <p className="rounded bg-red-50 p-2 text-center text-sm text-red-500 dark:bg-red-900/20">
                {params.message}
              </p>
            )}

            <button
              type="submit"
              className="mt-2 w-full rounded-lg bg-emerald-600 py-2.5 font-semibold text-white transition-colors hover:bg-emerald-700"
            >
              Crear mi contraseña y entrar
            </button>
          </form>
        </div>
      </div>
    </div>
  )
}
