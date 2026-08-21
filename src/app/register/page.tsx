import { register } from './actions'

export default async function RegisterPage({ searchParams }: { searchParams: Promise<{ message?: string }> }) {
  const resolvedSearchParams = await searchParams;

  return (
    <div className="flex min-h-screen items-center justify-center bg-slate-50 dark:bg-slate-950 p-4">
      <div className="w-full max-w-md bg-white dark:bg-slate-900 rounded-xl shadow-xl overflow-hidden border border-slate-200 dark:border-slate-800">
        <div className="p-8">
          <div className="text-center mb-8">
            <h1 className="text-2xl font-bold text-slate-900 dark:text-white">Crear Cuenta</h1>
            <p className="text-sm text-slate-500 mt-2">Únete a Save Documentos</p>
          </div>
          
          <form className="space-y-4" action={register}>
            <div className="flex space-x-4">
              <div className="w-1/2">
                <label className="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1">Nombre</label>
                <input name="first_name" type="text" required className="w-full px-4 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-300 dark:border-slate-700 rounded-lg focus:ring-2 focus:ring-emerald-500 outline-none text-slate-900 dark:text-white" placeholder="Ej. Laura" />
              </div>
              <div className="w-1/2">
                <label className="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1">Apellido</label>
                <input name="last_name" type="text" required className="w-full px-4 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-300 dark:border-slate-700 rounded-lg focus:ring-2 focus:ring-emerald-500 outline-none text-slate-900 dark:text-white" placeholder="Ej. Cifuentes" />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1">Email Profesional</label>
              <input name="email" type="email" required className="w-full px-4 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-300 dark:border-slate-700 rounded-lg focus:ring-2 focus:ring-emerald-500 outline-none text-slate-900 dark:text-white" placeholder="tu@despacho.do" />
            </div>

            <div>
              <label className="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1">Contraseña</label>
              <input name="password" type="password" required className="w-full px-4 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-300 dark:border-slate-700 rounded-lg focus:ring-2 focus:ring-emerald-500 outline-none text-slate-900 dark:text-white" placeholder="••••••••" />
            </div>

            <div className="pt-2 border-t border-slate-200 dark:border-slate-700">
              <p className="text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Perfil Profesional</p>
              <div className="flex items-center space-x-4">
                <label className="flex items-center space-x-2">
                  <input type="checkbox" name="is_lawyer" className="rounded text-emerald-600 focus:ring-emerald-500 bg-slate-100 border-slate-300 dark:bg-slate-800 dark:border-slate-600" />
                  <span className="text-sm text-slate-700 dark:text-slate-300">Abogado</span>
                </label>
                <label className="flex items-center space-x-2">
                  <input type="checkbox" name="is_notary" className="rounded text-emerald-600 focus:ring-emerald-500 bg-slate-100 border-slate-300 dark:bg-slate-800 dark:border-slate-600" />
                  <span className="text-sm text-slate-700 dark:text-slate-300">Notario</span>
                </label>
              </div>
            </div>

            {resolvedSearchParams?.message && (
              <p className="text-sm text-red-500 text-center bg-red-50 dark:bg-red-900/20 p-2 rounded">{resolvedSearchParams.message}</p>
            )}

            <button type="submit" className="w-full bg-emerald-600 hover:bg-emerald-700 text-white font-semibold py-2.5 rounded-lg transition-colors mt-6">
              Completar Registro
            </button>
          </form>
          
          <div className="mt-6 text-center text-sm text-slate-500">
            ¿Ya tienes cuenta? <a href="/login" className="text-emerald-600 font-semibold hover:underline">Inicia Sesión</a>
          </div>
        </div>
      </div>
    </div>
  );
}
