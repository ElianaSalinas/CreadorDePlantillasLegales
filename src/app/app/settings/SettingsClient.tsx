'use client'

import { useMemo, useState, useTransition } from 'react'
import { Loader2, UserPlus, Trash2, Users, User, Building2, Lock } from 'lucide-react'
import {
  updateProfile,
  updateOrganization,
  addMember,
  changeMemberRole,
  updateMemberPermissions,
  removeMember,
  type SettingsResult,
} from './actions'
import { MEMBER_ROLE_LABEL } from '@/lib/labels'
import {
  BUSINESS_BASE_DOP,
  formatDOP,
  seatMath,
  describeMonthlyCost,
  planAllowsTeam,
} from '@/lib/billing'
import { PERMISSION_LIST, type MemberPermissions, type PermissionKey } from '@/lib/permissions'

export type MemberRow = {
  id: string
  user_id: string
  role: 'OWNER' | 'PARALEGAL' | 'ASSISTANT'
  email: string
  name: string
  is_active: boolean
  permissions: MemberPermissions
}

type Props = {
  profile: any
  org: any
  members: MemberRow[]
  isOwner: boolean
  hasServiceKey: boolean
  canLeadTeam: boolean
}

export default function SettingsClient({
  profile,
  org,
  members,
  isOwner,
  hasServiceKey,
  canLeadTeam,
}: Props) {
  const [isFirm, setIsFirm] = useState<boolean>(Boolean(org?.is_firm))
  const hasTeamPlan = planAllowsTeam(org?.sub_status)

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
              ? 'Si ejerces por tu cuenta, deja el trabajo en equipo desactivado.'
              : 'Configuración gestionada por el titular del despacho.'
          }
        >
          <OrgForm
            org={org}
            isOwner={isOwner}
            isFirm={isFirm}
            onFirmChange={setIsFirm}
            canLeadTeam={canLeadTeam}
            hasTeamPlan={hasTeamPlan}
          />
        </Section>
      )}

      {/* El equipo solo tiene sentido para un profesional que encabeza un despacho. */}
      {org && canLeadTeam && (
        <Section
          icon={<Users size={18} />}
          title="Equipo"
          description="Paralegales y asistentes con acceso a este despacho."
        >
          {hasTeamPlan ? (
            <TeamPanel
              members={members}
              isOwner={isOwner}
              hasServiceKey={hasServiceKey}
              org={org}
            />
          ) : (
            <TeamLocked org={org} />
          )}
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

function SaveButton({
  pending,
  children = 'Guardar cambios',
}: {
  pending: boolean
  children?: React.ReactNode
}) {
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
  canLeadTeam,
  hasTeamPlan,
}: {
  org: any
  isOwner: boolean
  isFirm: boolean
  onFirmChange: (v: boolean) => void
  canLeadTeam: boolean
  hasTeamPlan: boolean
}) {
  const [result, setResult] = useState<SettingsResult | null>(null)
  const [pending, startTransition] = useTransition()

  const teamBlocked = !canLeadTeam || !hasTeamPlan

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
          disabled={!isOwner || (teamBlocked && !org.is_firm)}
          onChange={(e) => onFirmChange(e.target.checked)}
          className="mt-1 rounded border-slate-300 text-emerald-600 focus:ring-emerald-500 disabled:opacity-50"
        />
        <span>
          <span className="block font-medium text-slate-900 dark:text-white">
            Trabajo con un equipo
          </span>
          <span className="block text-sm text-slate-500">
            {!canLeadTeam
              ? 'Solo un abogado o notario puede encabezar un despacho con equipo.'
              : !hasTeamPlan
                ? 'Requiere el plan Equipo.'
                : 'Habilita la gestión de paralegales y asistentes.'}
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
        <Stat label="Plan" value={PLAN_NAME[org.sub_status] ?? org.sub_status} />
        <Stat label="Límite de plantillas" value={String(org.free_limit)} />
        <Stat label="Límite de bóveda" value={String(org.vault_limit)} />
      </div>

      <Feedback result={result} />
      {isOwner && <SaveButton pending={pending} />}
    </form>
  )
}

const PLAN_NAME: Record<string, string> = {
  FREE: 'Gratuito',
  PREMIUM: 'Pro',
  BUSINESS: 'Equipo',
  CANCELLED: 'Cancelado',
}

function Stat({ label, value }: { label: string; value: string }) {
  return (
    <div className="rounded-lg bg-slate-50 p-3 dark:bg-slate-800/50">
      <p className="text-xs text-slate-500">{label}</p>
      <p className="font-semibold text-slate-900 dark:text-white">{value}</p>
    </div>
  )
}

/* ---------------- Plan de equipo aún no contratable ---------------- */

function TeamLocked({ org }: { org: any }) {
  const seatPrice = org.seat_price_dop ?? 499
  const included = org.included_members ?? 1

  return (
    <div className="rounded-xl border border-amber-200 bg-amber-50/60 p-6 dark:border-amber-800 dark:bg-amber-900/10">
      <div className="mb-4 flex items-center gap-2 text-amber-800 dark:text-amber-400">
        <Lock size={17} />
        <h3 className="font-bold">Plan Equipo</h3>
      </div>

      <p className="mb-5 text-sm leading-relaxed text-amber-900 dark:text-amber-300">
        Suma paralegales y asistentes a tu despacho, decide qué puede hacer cada uno y mantén el
        control de lo que se redacta en tu nombre.
      </p>

      <div className="mb-5 flex flex-wrap items-end gap-x-3 gap-y-1">
        <span className="text-3xl font-bold text-slate-900 dark:text-white">
          {formatDOP(BUSINESS_BASE_DOP)}
        </span>
        <span className="pb-1 text-sm text-slate-600 dark:text-slate-400">al mes</span>
      </div>

      <ul className="mb-6 space-y-2 text-sm text-slate-700 dark:text-slate-300">
        <li>Incluye al titular y {included === 1 ? 'una persona más' : `${included} personas más`}.</li>
        <li>
          Cada persona adicional: <strong>{formatDOP(seatPrice)} al mes</strong>.
        </li>
        <li>Permisos individuales por miembro y registro de quién hizo cada cambio.</li>
      </ul>

      <button
        type="button"
        disabled
        className="cursor-not-allowed rounded-lg bg-slate-300 px-5 py-2.5 font-semibold text-slate-600 dark:bg-slate-700 dark:text-slate-400"
      >
        Disponible próximamente
      </button>
      <p className="mt-3 text-xs text-slate-500">
        Estamos terminando la integración de pagos. Te avisaremos por correo cuando puedas
        contratarlo.
      </p>
    </div>
  )
}

/* ---------------- Gestión real del equipo ---------------- */

function TeamPanel({
  members,
  isOwner,
  hasServiceKey,
  org,
}: {
  members: MemberRow[]
  isOwner: boolean
  hasServiceKey: boolean
  org: any
}) {
  const [result, setResult] = useState<SettingsResult | null>(null)
  const [pending, startTransition] = useTransition()

  const math = useMemo(
    () => seatMath(members.length, org.included_members ?? 1, org.seat_price_dop ?? 499),
    [members.length, org.included_members, org.seat_price_dop]
  )

  function run(fn: () => Promise<SettingsResult>) {
    setResult(null)
    startTransition(async () => setResult(await fn()))
  }

  return (
    <div className="space-y-5">
      {/* Lo que cuesta el despacho hoy */}
      <div className="rounded-lg border border-slate-200 bg-slate-50 p-4 dark:border-slate-700 dark:bg-slate-800/50">
        <p className="font-semibold text-slate-900 dark:text-white">{describeMonthlyCost(math)}</p>
        <p className="mt-1 text-sm text-slate-500">
          {math.members} {math.members === 1 ? 'persona' : 'personas'} además de ti ·{' '}
          {math.included} sin cargo · {math.billable} con cargo
        </p>
      </div>

      <ul className="space-y-3">
        {members.map((m) => (
          <li
            key={m.id}
            className="rounded-lg border border-slate-200 p-4 dark:border-slate-800"
          >
            <div className="flex flex-wrap items-center justify-between gap-3">
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
            </div>

            {m.role !== 'OWNER' && isOwner && (
              <PermissionEditor member={m} pending={pending} onRun={run} />
            )}
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
            {math.costOfNext === 0
              ? 'Esta persona entra sin cargo adicional.'
              : `Añadir a esta persona sube tu factura en ${formatDOP(math.costOfNext)} al mes.`}{' '}
            Debe tener ya una cuenta en Save Documentos.
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

function PermissionEditor({
  member,
  pending,
  onRun,
}: {
  member: MemberRow
  pending: boolean
  onRun: (fn: () => Promise<SettingsResult>) => void
}) {
  const [perms, setPerms] = useState<MemberPermissions>(member.permissions)

  function toggle(key: PermissionKey, value: boolean) {
    const next = { ...perms, [key]: value }
    setPerms(next)

    const fd = new FormData()
    for (const k of Object.keys(next) as PermissionKey[]) {
      if (next[k]) fd.set(k, 'on')
    }
    onRun(() => updateMemberPermissions(member.id, fd))
  }

  return (
    <div className="mt-4 border-t border-slate-100 pt-4 dark:border-slate-800">
      <p className="mb-3 text-xs font-semibold tracking-wide text-slate-500 uppercase">
        Qué puede hacer
      </p>
      <div className="grid gap-2 sm:grid-cols-2">
        {PERMISSION_LIST.map(({ key, label, hint }) => (
          <label key={key} className="flex items-start gap-2.5">
            <input
              type="checkbox"
              checked={perms[key]}
              disabled={pending}
              onChange={(e) => toggle(key, e.target.checked)}
              className="mt-0.5 rounded border-slate-300 text-emerald-600 focus:ring-emerald-500"
            />
            <span>
              <span className="block text-sm font-medium text-slate-800 dark:text-slate-200">
                {label}
              </span>
              <span className="block text-xs text-slate-500">{hint}</span>
            </span>
          </label>
        ))}
      </div>
    </div>
  )
}
