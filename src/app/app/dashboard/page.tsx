import { createClient } from '@/utils/supabase/server'

export default async function DashboardPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  
  if (!user) return null

  const { data: profile } = await supabase.from('profiles').select('*').eq('id', user.id).single()
  const { data: admin } = await supabase.from('save_admins').select('*').eq('id', user.id).maybeSingle()

  return (
    <div className="max-w-4xl mx-auto">
      <h1 className="text-3xl font-bold text-slate-900 dark:text-white mb-2">
        Bienvenido, {profile?.first_name || 'Profesional'}
      </h1>
      <p className="text-slate-600 dark:text-slate-400 mb-8">
        Este es tu espacio de trabajo seguro en Save Documentos.
      </p>

      {admin && (
        <div className="mb-8 p-4 bg-amber-50 dark:bg-amber-900/20 border border-amber-200 dark:border-amber-800 rounded-xl">
          <h2 className="text-lg font-bold text-amber-800 dark:text-amber-500 mb-1">👑 Privilegios de Super Administrador</h2>
          <p className="text-sm text-amber-700 dark:text-amber-400">
            Tu cuenta tiene acceso sin restricciones a la plataforma. Tienes los poderes para modificar los límites de las bóvedas de los despachos y editar las plantillas maestras globales del sistema.
          </p>
        </div>
      )}

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white dark:bg-slate-900 p-6 rounded-xl border border-slate-200 dark:border-slate-800 shadow-sm">
          <div className="text-sm font-medium text-slate-500 mb-1">Límite Freemium</div>
          <div className="text-3xl font-bold text-emerald-600">0 / 10</div>
          <div className="text-xs text-slate-400 mt-2">Plantillas generadas este mes</div>
        </div>
        
        <div className="bg-white dark:bg-slate-900 p-6 rounded-xl border border-slate-200 dark:border-slate-800 shadow-sm">
          <div className="text-sm font-medium text-slate-500 mb-1">Tu Bóveda</div>
          <div className="text-3xl font-bold text-slate-900 dark:text-white">0 / 30</div>
          <div className="text-xs text-slate-400 mt-2">Documentos almacenados</div>
        </div>

        <div className="bg-white dark:bg-slate-900 p-6 rounded-xl border border-slate-200 dark:border-slate-800 shadow-sm">
          <div className="text-sm font-medium text-slate-500 mb-1">Miembros del Despacho</div>
          <div className="text-3xl font-bold text-slate-900 dark:text-white">1</div>
          <div className="text-xs text-slate-400 mt-2">Usuarios activos</div>
        </div>
      </div>
    </div>
  )
}
