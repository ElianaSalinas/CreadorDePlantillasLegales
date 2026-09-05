import { LogOut } from 'lucide-react'
import { logout } from './actions'
import AppNav from '@/components/ui/AppNav'
import MenuMovil from '@/components/ui/MenuMovil'
import { requireSession, displayName } from '@/lib/session'

export default async function AppLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const { profile, user, isAdmin, esRevisor, org } = await requireSession()

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 flex flex-col">
      <header className="bg-white dark:bg-slate-900 border-b border-slate-200 dark:border-slate-800 px-6 py-4 flex justify-between items-center">
        <div className="flex items-center space-x-4">
          <MenuMovil isAdmin={isAdmin} esRevisor={esRevisor} />
          <div className="w-8 h-8 bg-emerald-600 rounded flex items-center justify-center text-white font-bold">
            S
          </div>
          <span className="font-bold text-slate-900 dark:text-white">Save Documentos</span>
          {isAdmin && (
            <span className="px-2 py-1 text-[10px] uppercase font-bold bg-amber-100 text-amber-800 rounded">
              Super Admin
            </span>
          )}
          {org?.is_firm && (
            <span className="hidden sm:inline text-xs text-slate-400 border-l border-slate-200 dark:border-slate-700 pl-4">
              {org.name}
            </span>
          )}
        </div>

        <div className="flex items-center space-x-4">
          <span className="text-sm text-slate-600 dark:text-slate-400">
            {displayName(profile, user.email)}
          </span>
          <form action={logout}>
            <button
              className="p-2 text-slate-400 hover:text-red-500 transition-colors"
              title="Cerrar sesión"
            >
              <LogOut size={18} />
            </button>
          </form>
        </div>
      </header>

      <div className="flex-1 flex overflow-hidden">
        <aside className="w-64 border-r border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 p-4 hidden md:block">
          <AppNav isAdmin={isAdmin} esRevisor={esRevisor} />
        </aside>

        <main className="flex-1 overflow-y-auto p-8">{children}</main>
      </div>
    </div>
  )
}
