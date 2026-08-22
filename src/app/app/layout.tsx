import { redirect } from 'next/navigation'
import { createClient } from '@/utils/supabase/server'
import { LogOut } from 'lucide-react'
import { logout } from './actions'

export default async function AppLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const supabase = await createClient()

  const { data: { user }, error } = await supabase.auth.getUser()

  if (error || !user) {
    redirect('/login')
  }

  // Fetch role
  const { data: profile } = await supabase.from('profiles').select('*').eq('id', user.id).single()
 // const { data: admin } = await supabase.from('save_admins').select('*').eq('id', user.id).maybeSingle()
const admin = null; // Temporalmente deshabilitado para debugging

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 flex flex-col">
      <header className="bg-white dark:bg-slate-900 border-b border-slate-200 dark:border-slate-800 px-6 py-4 flex justify-between items-center">
        <div className="flex items-center space-x-4">
          <div className="w-8 h-8 bg-emerald-600 rounded flex items-center justify-center text-white font-bold">
            S
          </div>
          <span className="font-bold text-slate-900 dark:text-white">Save Documentos</span>
          {admin && <span className="px-2 py-1 text-[10px] uppercase font-bold bg-amber-100 text-amber-800 rounded">Super Admin</span>}
        </div>
        
        <div className="flex items-center space-x-4">
          <span className="text-sm text-slate-600 dark:text-slate-400">{profile?.first_name || user.email}</span>
          <form action={logout}>
            <button className="p-2 text-slate-400 hover:text-red-500 transition-colors" title="Cerrar sesión">
              <LogOut size={18} />
            </button>
          </form>
        </div>
      </header>
      
      <div className="flex-1 flex overflow-hidden">
        {/* Sidebar placeholder */}
        <aside className="w-64 border-r border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 p-4 hidden md:block">
          <nav className="space-y-1">
            <a href="/app/dashboard" className="block px-3 py-2 bg-emerald-50 dark:bg-emerald-900/20 text-emerald-700 dark:text-emerald-400 font-medium rounded-md">
              Dashboard
            </a>
            <a href="/app/templates" className="block px-3 py-2 text-slate-600 dark:text-slate-400 hover:bg-slate-50 dark:hover:bg-slate-800 font-medium rounded-md">
              Plantillas
            </a>
            <a href="/app/vault" className="block px-3 py-2 text-slate-600 dark:text-slate-400 hover:bg-slate-50 dark:hover:bg-slate-800 font-medium rounded-md">
              Bóveda
            </a>
            <a href="/app/settings" className="block px-3 py-2 text-slate-600 dark:text-slate-400 hover:bg-slate-50 dark:hover:bg-slate-800 font-medium rounded-md">
              Mi Despacho
            </a>
          </nav>
        </aside>

        <main className="flex-1 overflow-y-auto p-8">
          {children}
        </main>
      </div>
    </div>
  )
}
