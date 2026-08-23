'use client'

import { useState, useTransition } from 'react'
import { Loader2, UserPlus, Trash2, Users, User, Building2 } from 'lucide-react'
import {
  updateProfile,
  updateOrganization,
  addMember,
  changeMemberRole,
  removeMember,
  type SettingsResult,
} from './actions'
import { MEMBER_ROLE_LABEL } from '@/lib/labels'

export type MemberRow = {
  id: string
  user_id: string
  role: 'OWNER' | 'PARALEGAL' | 'ASSISTANT'
  email: string
  name: string
  is_active: boolean
}

type Props = {
  profile: any
  org: any
  members: MemberRow[]
  isOwner: boolean
  hasServiceKey: boolean
}

export default function SettingsClient({ profile, org, members, isOwner, hasServiceKey }: Props) {
  const [isFirm, setIsFirm] = useState<boolean>(Boolean(org?.is_firm))

  return (
    <div className="space-y-6">
      <Section
        icon={<User size={18} />}
        title="Mi perfil"
        description="Los datos que aparecen en tus documentos y en tu cuenta."
      >
        <ProfileForm profile={profile} />
      </Section>

      {org && (
        <Section
          icon={<Building2 size={18} />}
          title="Mi despacho"
          description={
            isOwner
              ? 'Actívalo como despacho si trabajas con paralegales o asistentes. Si ejerces por tu cuenta, déjalo desactivado.'
              : 'Configuración gestionada por el titular del despacho.'
          }
        >
          <OrgForm org={org} isOwner={isOwner} isFirm={isFirm} onFirmChange={setIsFirm} />
        </Section>
      )}

      {org && isFirm && (
        <Section
          icon={<Users size={18} />}
          title="Equipo"
          description="Paralegales y asistentes con acceso a este despacho."
        >
          <TeamPanel
            members={members}
            isOwner={isOwner}
            hasServiceKey={hasServiceKey}
            ownerId={org.owner_id}
          />
        </Section>
      )}
    </div>
  )
}

/* ---------------------------------------------------------------- */

function Section({
  icon,
  title,
  description,
  children,
}: {
  icon: React.ReactNode
  title: string
  description?: string
  children: React.ReactNode
}) {
  return (
    <section className="rounded-xl border border-slate-200 bg-white p-6 dark:border-slate-800 dark:bg-slate-900">
      <div className="mb-5 flex items-start gap-3">
        <span className="mt-0.5 rounded-lg bg-emerald-50 p-2 text-emerald-600 dark:bg-emerald-900/20">
          {icon}
        </span>
        <div>
          <h2 className="font-bold text-slate-900 dark:text-white">{title}</h2>
          {description && <p className="mt-0.5 text-sm text-slate-500">{description}</p>}
        </div>
      </div>
      {children}
    </section>
  )
}

function Feedback({ result }: { result: SettingsResult | null }) {
  if (!result) return null
  if (result.ok) {
    return (
      <p className="rounded-lg bg-emerald-50 p-3 text-sm text-emerald-700 dark:bg-emerald-900/20 dark:text-emerald-400">
        {result.notice ?? 'Guardado.'}
      </p>
    )
  }
  return (
    <p className="rounded-lg bg-red-50 p-3 text-sm text-red-600 dark:bg-red-900/20">{result.error}</p>
  )
}

const inputClass =
  'w-full rounded-lg border border-slate-300 bg-slate-50 px-4 py-2 text-slate-900 outline-none focus:ring-2 focus:ring-emerald-500 disabled:opacity-60 dark:border-slate-700 dark:bg-slate-800 dark:text-white'

function Field({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <div>
      <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
        {label}
      </label>
      {children}
    </div>
  )
}

function SaveButton({ pending, children = 'Guardar cambios' }: { pending: boolean; children?: React.ReactNode }) {
  return (
    <button
      type="submit"
      disabled={pending}
      className="inline-flex items-center gap-2 rounded-lg bg-emerald-600 px-5 py-2 font-semibold text-white transition-colors hover:bg-emerald-700 disabled:opacity-60"
    >
      {pending && <Loader2 size={16} className="animate-spin" />}
      {children}
    </button>
  )
}

/* ---------------------------------------------------------------- */

function ProfileForm({ profile }: { profile: any }) {
  const [result, setResult] = useState<SettingsResult | null>(null)
  const [pending, startTransition] = useTransition()

  return (
    <form
      action={(fd) => {
        setResult(null)
        startTransition(async () => setResult(await updateProfile(fd)))
      }}
      className="space-y-4"
    >
      <div className="grid gap-4 sm:grid-cols-2">
        <Field label="Nombre">
          <input name="first_name" required defaultValue={profile?.first_name ?? ''} className={inputClass} />
        </Field>
        <Field label="Apellido">
          <input name="last_name" defaultValue={profile?.last_name ?? ''} className={inputClass} />
        </Field>
        <Field label="Teléfono">
          <input name="phone" type="tel" placeholder="809-000-0000" defaultValue={profile?.phone ?? ''} className={inputClass} />
        </Field>
        <Field label="Perfil profesional">
          <select name="prof_role" defaultValue={profile?.prof_role ?? 'ABOGADO'} className={inputClass}>
            <option value="ABOGADO">Abogado</option>
            <option value="NOTARIO">Notario</option>
            <option value="AMBOS">Abogado y Notario</option>
          </select>
        </Field>
        <Field label="Matrícula CARD">
          <input name="card_number" placeholder="Solo si aplica" defaultValue={profile?.card_number ?? ''} className={inputClass} />
        </Field>
        <Field label="Correo">
          <input value={profile?.email ?? ''} disabled className={inputClass} />
        </Field>
      </div>

      <Feedback result={result} />
      <SaveButton pending={pending} />
    </form>
  )
}

function OrgForm({
  org,
  isOwner,
  isFirm,
  onFirmChange,
}: {
  org: any
  isOwner: boolean
  isFirm: boolean
  onFirmChange: (v: boolean) => void
}) {
  const [result, setResult] = useState<SettingsResult | null>(null)
  const [pending, startTransition] = useTransition()

  return (
    <form
      action={(fd) => {
        setResult(null)
        startTransition(async () => setResult(await updateOrganization(fd)))
      }}
      className="space-y-4"
    >
      <Field label="Nombre del despacho">
        <input name="name" required defaultValue={org.name} disabled={!isOwner} className={inputClass} />
      </Field>

      <label className="flex items-start gap-3 rounded-lg border border-slate-200 p-4 dark:border-slate-700">
        <input
          type="checkbox"
          name="is_firm"
          checked={isFirm}
          disabled={!isOwner}
          onChange={(e) => onFirmChange(e.target.checked)}
          className="mt-1 rounded border-slate-300 text-emerald-600 focus:ring-emerald-500"
        />
        <span>
          <span className="block font-medium text-slate-900 dark:text-white">
            Trabajo con un equipo
          </span>
          <span className="block text-sm text-slate-500">
            Habilita la gestión de paralegales y asistentes. Déjalo desmarcado si ejerces solo.
          </span>
        </span>
      </label>

      <label className="flex items-start gap-3 rounded-lg border border-slate-200 p-4 dark:border-slate-700">
        <input
          type="checkbox"
          name="require_approval"
          defaultChecked={org.require_approval}
          disabled={!isOwner}
          className="mt-1 rounded border-slate-300 text-emerald-600 focus:ring-emerald-500"
        />
        <span>
          <span className="block font-medium text-slate-900 dark:text-white">
            Exigir aprobación del titular
          </span>
          <span className="block text-sm text-slate-500">
            Los documentos redactados por el equipo pasan a revisión antes de darse por finales.
          </span>
        </span>
      </label>

      <div className="grid gap-4 text-sm sm:grid-cols-3">
        <Stat label="Plan" value={org.sub_status === 'PREMIUM' ? 'Premium' : 'Gratuito'} />
        <Stat label="Límite de plantillas" value={String(org.free_limit)} />
        <Stat label="Límite de bóveda" value={String(org.vault_limit)} />
      </div>

      <Feedback result={result} />
      {isOwner && <SaveButton pending={pending} />}
    </form>
  )
}

function Stat({ label, value }: { label: string; value: string }) {
  return (
    <div className="rounded-lg bg-slate-50 p-3 dark:bg-slate-800/50">
      <p className="text-xs text-slate-500">{label}</p>
      <p className="font-semibold text-slate-900 dark:text-white">{value}</p>
    </div>
  )
}

function TeamPanel({
  members,
  isOwner,
  hasServiceKey,
  ownerId,
}: {
  members: MemberRow[]
  isOwner: boolean
  hasServiceKey: boolean
  ownerId: string
}) {
  const [result, setResult] = useState<SettingsResult | null>(null)
  const [pending, startTransition] = useTransition()

  function run(fn: () => Promise<SettingsResult>) {
    setResult(null)
    startTransition(async () => setResult(await fn()))
  }

  return (
    <div className="space-y-5">
      <ul className="divide-y divide-slate-100 rounded-lg border border-slate-200 dark:divide-slate-800 dark:border-slate-800">
        {members.map((m) => (
          <li key={m.id} className="flex flex-wrap items-center justify-between gap-3 px-4 py-3">
            <div className="min-w-0">
              <p className="truncate font-medium text-slate-900 dark:text-white">
                {m.name}
                {!m.is_active && (
                  <span className="ml-2 rounded bg-slate-200 px-1.5 py-0.5 text-[10px] font-bold uppercase text-slate-600 dark:bg-slate-700 dark:text-slate-300">
                    Desactivado
                  </span>
                )}
              </p>
              <p className="truncate text-sm text-slate-500">{m.email}</p>
            </div>

            <div className="flex items-center gap-2">
              {m.role === 'OWNER' || !isOwner ? (
                <span className="rounded-md bg-slate-100 px-3 py-1.5 text-sm font-medium text-slate-600 dark:bg-slate-800 dark:text-slate-300">
                  {MEMBER_ROLE_LABEL[m.role]}
                </span>
              ) : (
                <>
                  <select
                    defaultValue={m.role}
                    disabled={pending}
                    onChange={(e) => run(() => changeMemberRole(m.id, e.target.value))}
                    aria-label={`Rol de ${m.name}`}
                    className="rounded-md border border-slate-300 bg-white px-2 py-1.5 text-sm dark:border-slate-700 dark:bg-slate-800 dark:text-white"
                  >
                    <option value="PARALEGAL">Paralegal</option>
                    <option value="ASSISTANT">Asistente</option>
                  </select>
                  <button
                    onClick={() => {
                      if (confirm(`¿Quitar a ${m.name} del despacho?`)) run(() => removeMember(m.id))
                    }}
                    disabled={pending}
                    title="Quitar del despacho"
                    aria-label={`Quitar a ${m.name}`}
                    className="rounded-md p-2 text-slate-400 transition-colors hover:bg-red-50 hover:text-red-600 disabled:opacity-50 dark:hover:bg-red-900/20"
                  >
                    <Trash2 size={16} />
                  </button>
                </>
              )}
            </div>
          </li>
        ))}
      </ul>

      {isOwner && (
        <form
          action={(fd) => {
            setResult(null)
            startTransition(async () => setResult(await addMember(fd)))
          }}
          className="flex flex-wrap items-end gap-3 rounded-lg bg-slate-50 p-4 dark:bg-slate-800/50"
        >
          <div className="min-w-[220px] flex-1">
            <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
              Correo de la persona
            </label>
            <input
              name="email"
              type="email"
              required
              placeholder="paralegal@despacho.do"
              className={inputClass}
            />
          </div>
          <div>
            <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
              Rol
            </label>
            <select name="role" defaultValue="PARALEGAL" className={inputClass}>
              <option value="PARALEGAL">Paralegal</option>
              <option value="ASSISTANT">Asistente</option>
            </select>
          </div>
          <button
            type="submit"
            disabled={pending}
            className="inline-flex items-center gap-2 rounded-lg bg-emerald-600 px-4 py-2 font-semibold text-white transition-colors hover:bg-emerald-700 disabled:opacity-60"
          >
            {pending ? <Loader2 size={16} className="animate-spin" /> : <UserPlus size={16} />}
            Añadir
          </button>

          <p className="w-full text-xs text-slate-500">
            La persona debe tener ya una cuenta en Save Documentos. Pídele que se registre y luego
            añádela aquí.
          </p>
        </form>
      )}

      {!hasServiceKey && isOwner && (
        <p className="rounded-lg bg-amber-50 p-3 text-sm text-amber-800 dark:bg-amber-900/20 dark:text-amber-300">
          Para añadir miembros falta configurar <code>SUPABASE_SERVICE_ROLE_KEY</code> en las
          Variables de Railway.
        </p>
      )}

      <Feedback result={result} />
    </div>
  )
}
