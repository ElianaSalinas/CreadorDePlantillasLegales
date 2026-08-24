import { login } from './actions'
import PasswordInput from '@/components/ui/PasswordInput'

export default async function LoginPage({ searchParams }: { searchParams: Promise<{ message?: string }> }) {
  const resolvedSearchParams = await searchParams;
  
  return (
    <div className="flex min-h-screen items-center justify-center bg-slate-50 dark:bg-slate-950 p-4">
      <div className="w-full max-w-md bg-white dark:bg-slate-900 rounded-xl shadow-xl overflow-hidden border border-slate-200 dark:border-slate-800">
        <div className="p-8">
          <div className="text-center mb-8">
            <h1 className="text-2xl font-bold text-slate-900 dark:text-white">Save Documentos</h1>
            <p className="text-sm text-slate-500 mt-2">Inicia sesión en tu cuenta profesional</p>
          </div>
          
          <form className="space-y-4" action={login}>
            <div>
              <label className="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1">Email</label>
              <input name="email" type="email" required className="w-full px-4 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-300 dark:border-slate-700 rounded-lg focus:ring-2 focus:ring-emerald-500 outline-none text-slate-900 dark:text-white" placeholder="tu@despacho.do" />
            </div>
            <PasswordInput autoComplete="current-password" />

            <div className="text-right">
              <a href="/forgot-password" className="text-sm text-emerald-600 hover:underline">
                ¿Olvidaste tu contraseña?
              </a>
            </div>
            {resolvedSearchParams?.message && (
              <p className="text-sm text-red-500 text-center bg-red-50 dark:bg-red-900/20 p-2 rounded">{resolvedSearchParams.message}</p>
            )}
            <button type="submit" className="w-full bg-emerald-600 hover:bg-emerald-700 text-white font-semibold py-2.5 rounded-lg transition-colors mt-6">
              Ingresar a la Plataforma
            </button>
          </form>
          
          <div className="mt-6 text-center text-sm text-slate-500">
            ¿No tienes cuenta? <a href="/register" className="text-emerald-600 font-semibold hover:underline">Regístrate como Profesional</a>
          </div>
        </div>
      </div>
    </div>
  );
}
