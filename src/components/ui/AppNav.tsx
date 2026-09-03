'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { LayoutDashboard, FileText, FileSignature, Scale, Archive, Building2, ShieldCheck, BadgeCheck } from 'lucide-react'

const BASE_LINKS = [
  { href: '/app/dashboard', label: 'Dashboard', Icon: LayoutDashboard },
  { href: '/app/templates', label: 'Plantillas', Icon: FileText },
  { href: '/app/documents', label: 'Documentos', Icon: FileSignature },
  { href: '/app/clauses', label: 'Cláusulas', Icon: Scale },
  { href: '/app/vault', label: 'Bóveda', Icon: Archive },
  { href: '/app/settings', label: 'Mi Despacho', Icon: Building2 },
]

export default function AppNav({
  isAdmin = false,
  esRevisor = false,
}: {
  isAdmin?: boolean
  esRevisor?: boolean
}) {
  const pathname = usePathname()

  // Revisar el catálogo y administrar la plataforma son permisos distintos.
  // La abogada que revisa no tiene por qué ver el panel de cuentas.
  const links = [
    ...BASE_LINKS,
    ...(esRevisor || isAdmin
      ? [{ href: '/app/revision', label: 'Revisión', Icon: BadgeCheck }]
      : []),
    ...(isAdmin ? [{ href: '/app/admin', label: 'Administración', Icon: ShieldCheck }] : []),
  ]

  return (
    <nav className="space-y-1">
      {links.map(({ href, label, Icon }) => {
        const active = pathname === href || pathname.startsWith(href + '/')
        return (
          <Link
            key={href}
            href={href}
            aria-current={active ? 'page' : undefined}
            className={
              active
                ? 'flex items-center gap-3 px-3 py-2 rounded-md font-medium bg-emerald-50 dark:bg-emerald-900/20 text-emerald-700 dark:text-emerald-400'
                : 'flex items-center gap-3 px-3 py-2 rounded-md font-medium text-slate-600 dark:text-slate-400 hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors'
            }
          >
            <Icon size={18} />
            <span>{label}</span>
          </Link>
        )
      })}
    </nav>
  )
}
