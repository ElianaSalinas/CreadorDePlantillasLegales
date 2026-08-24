'use client'

import { useMemo, useState, useTransition } from 'react'
import {
  Loader2, Plus, Trash2, ChevronUp, ChevronDown, AlertTriangle, AlertCircle,
  Lightbulb, CheckCircle2, Rocket, Undo2, Paperclip,
} from 'lucide-react'
import Modal from '@/components/ui/Modal'
import {
  updateTemplateMeta, saveSection, deleteSection, moveSection,
  attachVariable, detachVariable,
  attachClause, updateClauseLink, detachClause,
  saveRule, deleteRule, toggleRule,
  publishTemplate, unpublishTemplate,
  type EditorResult,
} from './actions'
import { CONDITION_OPERATORS, describeCondition } from '@/lib/engine/rules'
import { RULE_ACTIONS, type Condition, type ConditionOperator } from '@/lib/engine/types'
import { ISSUE_LEVEL_LABEL, type QualityReport } from '@/lib/engine/quality'

type Tab = 'general' | 'secciones' | 'variables' | 'clausulas' | 'reglas' | 'revision'

const TABS: { id: Tab; label: string }[] = [
  { id: 'general', label: 'General' },
  { id: 'secciones', label: 'Secciones' },
  { id: 'variables', label: 'Formulario' },
  { id: 'clausulas', label: 'Cláusulas' },
  { id: 'reglas', label: 'Reglas' },
  { id: 'revision', label: 'Revisión' },
]

const KIND_LABEL: Record<string, string> = {
  MANDATORY: 'Siempre',
  OPTIONAL: 'Opcional',
  CONDITIONAL: 'Condicional',
  RECOMMENDED: 'Recomendada',
}

export default function TemplateEditorClient(props: {
  templateId: string
  meta: any
  categories: { id: string; name: string }[]
  sections: any[]
  variables: any[]
  attachedVariables: any[]
  clauses: any[]
  attachedClauses: any[]
  rules: any[]
  report: QualityReport
}) {
  const [tab, setTab] = useState<Tab>('general')
  const [result, setResult] = useState<EditorResult | null>(null)
  const [pending, startTransition] = useTransition()

  function run(fn: () => Promise<EditorResult>, after?: () => void) {
    setResult(null)
    startTransition(async () => {
      const r = await fn()
      setResult(r)
      if (r.ok) after?.()
    })
  }

  const { report } = props

  return (
    <div>
      {/* Estado y publicación */}
      <div className="mb-6 flex flex-wrap items-center gap-3 rounded-xl border border-slate-200 bg-white p-4 dark:border-slate-800 dark:bg-slate-900">
        <span className={
          props.meta.status === 'PUBLISHED'
            ? 'rounded-full bg-emerald-50 px-3 py-1 text-xs font-bold text-emerald-700 dark:bg-emerald-900/20 dark:text-emerald-400'
            : 'rounded-full bg-slate-100 px-3 py-1 text-xs font-bold text-slate-600 dark:bg-slate-800 dark:text-slate-300'
        }>
          {props.meta.status === 'PUBLISHED' ? `Publicada · v${props.meta.version}` : 'Borrador'}
        </span>

        <span className="text-sm text-slate-500">
          {report.blockers > 0
            ? `${report.blockers} problema(s) impiden publicar`
            : report.warnings > 0
              ? `Lista para publicar · ${report.warnings} aviso(s)`
              : 'Todo en orden'}
        </span>

        <span className="flex-1" />

        {props.meta.status === 'PUBLISHED' ? (
          <button
            onClick={() => run(() => unpublishTemplate(props.templateId))}
            disabled={pending}
            className="inline-flex items-center gap-2 rounded-lg border border-slate-300 px-4 py-2 text-sm font-medium text-slate-600 hover:bg-slate-50 disabled:opacity-50 dark:border-slate-700 dark:text-slate-400 dark:hover:bg-slate-800"
          >
            <Undo2 size={16} /> Volver a borrador
          </button>
        ) : (
          <PublishButton
            disabled={!report.canPublish || pending}
            pending={pending}
            blockers={report.blockers}
            onPublish={(note) => { run(() => publishTemplate(props.templateId, note)); }}
          />
        )}
      </div>

      {/* Pestañas */}
      <div className="mb-6 flex flex-wrap gap-1 border-b border-slate-200 dark:border-slate-800">
        {TABS.map((t) => (
          <button
            key={t.id}
            onClick={() => setTab(t.id)}
            className={
              tab === t.id
                ? 'border-b-2 border-emerald-600 px-4 py-2.5 text-sm font-semibold text-emerald-700 dark:text-emerald-400'
                : 'border-b-2 border-transparent px-4 py-2.5 text-sm font-medium text-slate-500 hover:text-slate-800 dark:hover:text-slate-300'
            }
          >
            {t.label}
            {t.id === 'revision' && report.blockers > 0 && (
              <span className="ml-1.5 rounded-full bg-red-100 px-1.5 text-[10px] font-bold text-red-600 dark:bg-red-900/30">
                {report.blockers}
              </span>
            )}
          </button>
        ))}
      </div>

      {result && (
        <p className={result.ok
          ? 'mb-4 rounded-lg bg-emerald-50 p-3 text-sm text-emerald-700 dark:bg-emerald-900/20 dark:text-emerald-400'
          : 'mb-4 rounded-lg bg-red-50 p-3 text-sm text-red-600 dark:bg-red-900/20'}>
          {result.ok ? result.notice : result.error}
        </p>
      )}

      {tab === 'general' && <GeneralTab {...props} run={run} pending={pending} />}
      {tab === 'secciones' && <SectionsTab {...props} run={run} pending={pending} />}
      {tab === 'variables' && <VariablesTab {...props} run={run} pending={pending} />}
      {tab === 'clausulas' && <ClausesTab {...props} run={run} pending={pending} />}
      {tab === 'reglas' && <RulesTab {...props} run={run} pending={pending} />}
      {tab === 'revision' && <ReviewTab report={report} onGo={setTab} />}
    </div>
  )
}

/* ---------------------------------------------------------------- */

const inputClass =
  'w-full rounded-lg border border-slate-300 bg-slate-50 px-4 py-2 text-slate-900 outline-none focus:ring-2 focus:ring-emerald-500 dark:border-slate-700 dark:bg-slate-800 dark:text-white'

const card = 'rounded-xl border border-slate-200 bg-white p-5 dark:border-slate-800 dark:bg-slate-900'

type Runner = (fn: () => Promise<EditorResult>, after?: () => void) => void

function PublishButton({ disabled, pending, blockers, onPublish }: {
  disabled: boolean; pending: boolean; blockers: number; onPublish: (note: string) => void
}) {
  const [open, setOpen] = useState(false)
  const [note, setNote] = useState('')

  return (
    <>
      <button
        onClick={() => setOpen(true)}
        disabled={disabled}
        title={blockers > 0 ? 'Resuelve los problemas de la pestaña Revisión' : undefined}
        className="inline-flex items-center gap-2 rounded-lg bg-emerald-600 px-5 py-2 text-sm font-semibold text-white hover:bg-emerald-700 disabled:cursor-not-allowed disabled:opacity-40"
      >
        {pending ? <Loader2 size={16} className="animate-spin" /> : <Rocket size={16} />} Publicar
      </button>

      <Modal open={open} onClose={() => setOpen(false)} title="Publicar plantilla">
        <div className="space-y-4">
          <p className="text-sm text-slate-600 dark:text-slate-400">
            Se congelará una versión con el contenido actual. Los documentos que ya existen no
            cambian: siguen apuntando a la versión con la que se generaron.
          </p>
          <div>
            <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
              Qué cambió (opcional)
            </label>
            <input
              value={note}
              onChange={(e) => setNote(e.target.value)}
              placeholder="Ej. Se añadió la cláusula de mascotas"
              className={inputClass}
            />
          </div>
          <div className="flex justify-end gap-3">
            <button onClick={() => setOpen(false)} className="rounded-lg px-4 py-2 font-medium text-slate-600 hover:bg-slate-100 dark:text-slate-400 dark:hover:bg-slate-800">
              Cancelar
            </button>
            <button
              onClick={() => { onPublish(note); setOpen(false) }}
              className="rounded-lg bg-emerald-600 px-5 py-2 font-semibold text-white hover:bg-emerald-700"
            >
              Publicar
            </button>
          </div>
        </div>
      </Modal>
    </>
  )
}

/* ── General ── */

function GeneralTab({ templateId, meta, categories, run, pending }: any & { run: Runner; pending: boolean }) {
  return (
    <form action={(fd: FormData) => run(() => updateTemplateMeta(templateId, fd))} className={`${card} space-y-4`}>
      <div>
        <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">Título</label>
        <input name="title" required defaultValue={meta.title} className={inputClass} />
      </div>
      <div>
        <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">Descripción</label>
        <textarea name="description" rows={3} defaultValue={meta.description ?? ''}
          placeholder="Para qué sirve y cuándo usarla." className={`${inputClass} resize-y`} />
      </div>
      <div>
        <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">Categoría</label>
        <select name="category_id" defaultValue={meta.category_id ?? ''} className={inputClass}>
          <option value="">Sin categoría</option>
          {categories.map((c: any) => <option key={c.id} value={c.id}>{c.name}</option>)}
        </select>
      </div>
      <button type="submit" disabled={pending}
        className="inline-flex items-center gap-2 rounded-lg bg-emerald-600 px-5 py-2 font-semibold text-white hover:bg-emerald-700 disabled:opacity-60">
        {pending && <Loader2 size={16} className="animate-spin" />} Guardar
      </button>
    </form>
  )
}

/* ── Secciones ── */

function SectionsTab({ templateId, sections, run, pending }: any & { run: Runner; pending: boolean }) {
  const [editing, setEditing] = useState<any | null>(null)
  const [creating, setCreating] = useState(false)

  return (
    <div className="space-y-3">
      <p className="text-sm text-slate-500">
        El documento se arma recorriendo las secciones en orden. Cada una lleva su texto y las
        cláusulas que le asignes.
      </p>

      {sections.map((s: any, i: number) => (
        <div key={s.id} className={card}>
          <div className="flex flex-wrap items-start justify-between gap-3">
            <div className="min-w-0 flex-1">
              <p className="flex items-center gap-2 font-semibold text-slate-900 dark:text-white">
                {s.title}
                {s.is_annex && (
                  <span className="inline-flex items-center gap-1 rounded bg-slate-100 px-1.5 py-0.5 text-[10px] font-bold text-slate-600 dark:bg-slate-800 dark:text-slate-300">
                    <Paperclip size={10} /> ANEXO
                  </span>
                )}
              </p>
              {s.body ? (
                <p className="mt-1 line-clamp-2 text-sm text-slate-500">{s.body}</p>
              ) : (
                <p className="mt-1 text-sm text-slate-400 italic">Sin texto propio</p>
              )}
              {s.condition && (
                <p className="mt-1.5 text-xs text-slate-500">
                  Aparece si: {describeCondition(s.condition)}
                </p>
              )}
            </div>

            <div className="flex shrink-0 gap-1">
              <button onClick={() => run(() => moveSection(templateId, s.id, -1))} disabled={pending || i === 0}
                className="rounded p-1.5 text-slate-400 hover:bg-slate-100 disabled:opacity-30 dark:hover:bg-slate-800" title="Subir">
                <ChevronUp size={16} />
              </button>
              <button onClick={() => run(() => moveSection(templateId, s.id, 1))} disabled={pending || i === sections.length - 1}
                className="rounded p-1.5 text-slate-400 hover:bg-slate-100 disabled:opacity-30 dark:hover:bg-slate-800" title="Bajar">
                <ChevronDown size={16} />
              </button>
              <button onClick={() => setEditing(s)}
                className="rounded px-2.5 py-1.5 text-sm font-medium text-slate-600 hover:bg-slate-100 dark:text-slate-400 dark:hover:bg-slate-800">
                Editar
              </button>
              <button onClick={() => { if (confirm(`¿Eliminar la sección "${s.title}"?`)) run(() => deleteSection(templateId, s.id)) }}
                disabled={pending} className="rounded p-1.5 text-slate-400 hover:bg-red-50 hover:text-red-600 disabled:opacity-50 dark:hover:bg-red-900/20">
                <Trash2 size={15} />
              </button>
            </div>
          </div>
        </div>
      ))}

      <button onClick={() => { setCreating(true); setEditing(null) }}
        className="inline-flex items-center gap-2 rounded-lg border border-dashed border-slate-300 px-4 py-2.5 text-sm font-medium text-slate-600 hover:border-emerald-400 hover:text-emerald-700 dark:border-slate-700 dark:text-slate-400">
        <Plus size={16} /> Añadir sección
      </button>

      <Modal open={creating || editing !== null} onClose={() => { setCreating(false); setEditing(null) }}
        title={editing ? 'Editar sección' : 'Nueva sección'} widthClass="max-w-2xl">
        <form key={editing?.id ?? 'new'}
          action={(fd: FormData) => run(() => saveSection(templateId, editing?.id ?? null, fd), () => { setCreating(false); setEditing(null) })}
          className="space-y-4">
          <input type="hidden" name="sort_order" defaultValue={editing?.sort_order ?? sections.length + 1} />
          <div>
            <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">Título</label>
            <input name="title" required defaultValue={editing?.title ?? ''} className={inputClass} />
          </div>
          <div>
            <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">Texto</label>
            <textarea name="body" rows={10} defaultValue={editing?.body ?? ''}
              placeholder="Usa {{variable}} donde vaya un dato del formulario. Puedes dejarlo vacío si la sección solo agrupa cláusulas."
              className={`${inputClass} resize-y font-serif text-[15px] leading-relaxed`} />
          </div>
          <label className="flex items-center gap-2.5">
            <input type="checkbox" name="is_annex" defaultChecked={editing?.is_annex}
              className="rounded border-slate-300 text-emerald-600 focus:ring-emerald-500" />
            <span className="text-sm text-slate-700 dark:text-slate-300">Es un anexo (va al final del documento)</span>
          </label>
          <div className="flex justify-end gap-3 pt-2">
            <button type="button" onClick={() => { setCreating(false); setEditing(null) }}
              className="rounded-lg px-4 py-2 font-medium text-slate-600 hover:bg-slate-100 dark:text-slate-400 dark:hover:bg-slate-800">Cancelar</button>
            <button type="submit" disabled={pending}
              className="inline-flex items-center gap-2 rounded-lg bg-emerald-600 px-5 py-2 font-semibold text-white hover:bg-emerald-700 disabled:opacity-60">
              {pending && <Loader2 size={16} className="animate-spin" />} Guardar
            </button>
          </div>
        </form>
      </Modal>
    </div>
  )
}

/* ── Variables ── */

function VariablesTab({ templateId, variables, attachedVariables, sections, run, pending }: any & { run: Runner; pending: boolean }) {
  const attachedIds = new Set(attachedVariables.map((a: any) => a.variable_id))
  const available = variables.filter((v: any) => !attachedIds.has(v.id))
  const [picking, setPicking] = useState(false)
  const [query, setQuery] = useState('')

  const filtered = available.filter((v: any) =>
    !query || v.label.toLowerCase().includes(query.toLowerCase()) || v.tag.includes(query.toLowerCase())
  )

  return (
    <div className="space-y-3">
      <p className="text-sm text-slate-500">
        Estas son las preguntas del formulario, en el orden en que se hacen.
      </p>

      {attachedVariables.length === 0 && (
        <p className="rounded-lg bg-slate-50 p-4 text-sm text-slate-500 dark:bg-slate-800/50">
          Todavía no hay campos. El formulario saldría vacío.
        </p>
      )}

      {attachedVariables.map((a: any) => {
        const v = variables.find((x: any) => x.id === a.variable_id)
        if (!v) return null
        const section = sections.find((s: any) => s.id === a.section_id)
        return (
          <div key={a.id} className={`${card} flex flex-wrap items-center justify-between gap-3`}>
            <div className="min-w-0 flex-1">
              <p className="font-medium text-slate-900 dark:text-white">{v.question || v.label}</p>
              <p className="text-xs text-slate-500">
                <code className="font-mono">{v.tag}</code> · {v.data_type}
                {v.is_required ? ' · obligatorio' : ' · opcional'}
                {section ? ` · ${section.title}` : ''}
              </p>
            </div>
            <button onClick={() => run(() => detachVariable(templateId, a.id))} disabled={pending}
              className="rounded p-2 text-slate-400 hover:bg-red-50 hover:text-red-600 disabled:opacity-50 dark:hover:bg-red-900/20">
              <Trash2 size={15} />
            </button>
          </div>
        )
      })}

      <button onClick={() => setPicking(true)}
        className="inline-flex items-center gap-2 rounded-lg border border-dashed border-slate-300 px-4 py-2.5 text-sm font-medium text-slate-600 hover:border-emerald-400 hover:text-emerald-700 dark:border-slate-700 dark:text-slate-400">
        <Plus size={16} /> Añadir campo al formulario
      </button>

      <Modal open={picking} onClose={() => setPicking(false)} title="Añadir campo" widthClass="max-w-lg">
        <input value={query} onChange={(e) => setQuery(e.target.value)} placeholder="Buscar variable…" className={`${inputClass} mb-4`} />
        <div className="max-h-[400px] space-y-1 overflow-y-auto">
          {filtered.length === 0 && <p className="py-6 text-center text-sm text-slate-500">No queda ninguna variable por añadir.</p>}
          {filtered.map((v: any) => (
            <button key={v.id} onClick={() => run(() => attachVariable(templateId, v.id, null), () => setPicking(false))}
              disabled={pending}
              className="w-full rounded-lg px-3 py-2.5 text-left transition-colors hover:bg-slate-50 disabled:opacity-50 dark:hover:bg-slate-800">
              <p className="text-sm font-medium text-slate-900 dark:text-white">{v.question || v.label}</p>
              <p className="text-xs text-slate-500"><code className="font-mono">{v.tag}</code> · {v.data_type}</p>
            </button>
          ))}
        </div>
      </Modal>
    </div>
  )
}

/* ── Cláusulas ── */

function ClausesTab({ templateId, clauses, attachedClauses, sections, run, pending }: any & { run: Runner; pending: boolean }) {
  const attachedIds = new Set(attachedClauses.map((a: any) => a.clause_id))
  const available = clauses.filter((c: any) => !attachedIds.has(c.id))
  const [picking, setPicking] = useState(false)
  const [conditionFor, setConditionFor] = useState<any | null>(null)

  return (
    <div className="space-y-3">
      <p className="rounded-lg bg-emerald-50 p-3 text-sm text-emerald-800 dark:bg-emerald-900/20 dark:text-emerald-300">
        Añadir una cláusula aquí es suficiente para que salga en el documento. No hace falta
        escribir nada en el texto de las secciones.
      </p>

      {attachedClauses.map((a: any) => {
        const c = clauses.find((x: any) => x.id === a.clause_id)
        if (!c) return null
        const section = sections.find((s: any) => s.id === a.section_id)
        const needsCondition = a.kind === 'CONDITIONAL' && !a.condition

        return (
          <div key={a.id} className={card}>
            <div className="flex flex-wrap items-start justify-between gap-3">
              <div className="min-w-0 flex-1">
                <p className="font-semibold text-slate-900 dark:text-white">{c.title}</p>
                <p className="text-xs text-slate-500">
                  {c.family}{section ? ` · ${section.title}` : ' · sin sección'}
                </p>
                {a.condition && (
                  <p className="mt-1.5 text-xs text-slate-600 dark:text-slate-400">
                    Aparece si: {describeCondition(a.condition)}
                  </p>
                )}
                {needsCondition && (
                  <p className="mt-1.5 flex items-center gap-1.5 text-xs font-medium text-red-600">
                    <AlertCircle size={12} /> Es condicional pero no tiene condición: nunca aparecerá.
                  </p>
                )}
              </div>

              <div className="flex shrink-0 items-center gap-2">
                <select
                  defaultValue={a.kind}
                  disabled={pending}
                  onChange={(e) => run(() => updateClauseLink(templateId, a.id, { kind: e.target.value }))}
                  className="rounded-md border border-slate-300 bg-white px-2 py-1.5 text-sm dark:border-slate-700 dark:bg-slate-800 dark:text-white"
                >
                  {Object.entries(KIND_LABEL).map(([k, label]) => <option key={k} value={k}>{label}</option>)}
                </select>

                {(a.kind === 'CONDITIONAL') && (
                  <button onClick={() => setConditionFor(a)}
                    className="rounded-md px-2.5 py-1.5 text-sm font-medium text-emerald-700 hover:bg-emerald-50 dark:text-emerald-400 dark:hover:bg-emerald-900/20">
                    Condición
                  </button>
                )}

                <button onClick={() => run(() => detachClause(templateId, a.id))} disabled={pending}
                  className="rounded p-1.5 text-slate-400 hover:bg-red-50 hover:text-red-600 disabled:opacity-50 dark:hover:bg-red-900/20">
                  <Trash2 size={15} />
                </button>
              </div>
            </div>
          </div>
        )
      })}

      <button onClick={() => setPicking(true)}
        className="inline-flex items-center gap-2 rounded-lg border border-dashed border-slate-300 px-4 py-2.5 text-sm font-medium text-slate-600 hover:border-emerald-400 hover:text-emerald-700 dark:border-slate-700 dark:text-slate-400">
        <Plus size={16} /> Añadir cláusula
      </button>

      <Modal open={picking} onClose={() => setPicking(false)} title="Añadir cláusula" widthClass="max-w-lg">
        <div className="max-h-[420px] space-y-1 overflow-y-auto">
          {available.length === 0 && <p className="py-6 text-center text-sm text-slate-500">Ya usaste todas las cláusulas disponibles.</p>}
          {available.map((c: any) => (
            <button key={c.id} onClick={() => run(() => attachClause(templateId, c.id, 'MANDATORY', null), () => setPicking(false))}
              disabled={pending}
              className="w-full rounded-lg px-3 py-2.5 text-left transition-colors hover:bg-slate-50 disabled:opacity-50 dark:hover:bg-slate-800">
              <p className="text-sm font-medium text-slate-900 dark:text-white">{c.title}</p>
              <p className="text-xs text-slate-500">{c.family}{c.org_id ? ' · propia' : ' · SA&VE'}</p>
            </button>
          ))}
        </div>
      </Modal>

      <ConditionModal
        open={conditionFor !== null}
        current={conditionFor?.condition ?? null}
        onClose={() => setConditionFor(null)}
        onSave={(cond) => {
          const link = conditionFor
          setConditionFor(null)
          if (link) run(() => updateClauseLink(templateId, link.id, { condition: cond }))
        }}
      />
    </div>
  )
}

/* ── Constructor de condición ── */

function ConditionModal({ open, current, onClose, onSave }: {
  open: boolean
  current: Condition | null
  onClose: () => void
  onSave: (c: Condition) => void
}) {
  const leaf = current && !('op' in (current as any)) ? (current as any) : null
  const [variable, setVariable] = useState(leaf?.variable ?? '')
  const [operator, setOperator] = useState<ConditionOperator>(leaf?.operator ?? 'is_true')
  const [value, setValue] = useState(String(leaf?.value ?? ''))

  const needsValue = CONDITION_OPERATORS.find((o) => o.value === operator)?.needsValue ?? false

  return (
    <Modal open={open} onClose={onClose} title="Cuándo aparece esta cláusula">
      <div className="space-y-4">
        <div>
          <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">Variable</label>
          <input value={variable} onChange={(e) => setVariable(e.target.value)}
            placeholder="Ej. mascotas" className={inputClass} />
          <p className="mt-1 text-xs text-slate-500">El nombre técnico, tal como aparece entre llaves.</p>
        </div>
        <div>
          <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">Condición</label>
          <select value={operator} onChange={(e) => setOperator(e.target.value as ConditionOperator)} className={inputClass}>
            {CONDITION_OPERATORS.map((o) => <option key={o.value} value={o.value}>{o.label}</option>)}
          </select>
        </div>
        {needsValue && (
          <div>
            <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">Valor</label>
            <input value={value} onChange={(e) => setValue(e.target.value)} className={inputClass} />
          </div>
        )}

        <div className="flex justify-end gap-3 pt-2">
          <button onClick={onClose} className="rounded-lg px-4 py-2 font-medium text-slate-600 hover:bg-slate-100 dark:text-slate-400 dark:hover:bg-slate-800">Cancelar</button>
          <button
            onClick={() => {
              if (!variable.trim()) return
              onSave({ variable: variable.trim(), operator, ...(needsValue ? { value } : {}) } as Condition)
            }}
            className="rounded-lg bg-emerald-600 px-5 py-2 font-semibold text-white hover:bg-emerald-700"
          >
            Guardar condición
          </button>
        </div>
      </div>
    </Modal>
  )
}

/* ── Reglas ── */

function RulesTab({ templateId, rules, clauses, attachedClauses, variables, run, pending }: any & { run: Runner; pending: boolean }) {
  const [open, setOpen] = useState(false)
  const [name, setName] = useState('')
  const [variable, setVariable] = useState('')
  const [operator, setOperator] = useState<ConditionOperator>('is_true')
  const [value, setValue] = useState('')
  const [action, setAction] = useState('WARN_USER')
  const [message, setMessage] = useState('')
  const [targetClause, setTargetClause] = useState('')
  const [targetVariable, setTargetVariable] = useState('')

  const needsValue = CONDITION_OPERATORS.find((o) => o.value === operator)?.needsValue ?? false
  const target = RULE_ACTIONS.find((a) => a.value === action)?.target ?? 'none'

  return (
    <div className="space-y-3">
      <p className="text-sm text-slate-500">
        Las reglas hacen cosas cuando se cumple una condición: incluir o excluir una cláusula,
        ocultar un campo, o avisar al usuario.
      </p>

      {rules.map((r: any) => (
        <div key={r.id} className={card}>
          <div className="flex flex-wrap items-start justify-between gap-3">
            <div className="min-w-0 flex-1">
              <p className="font-semibold text-slate-900 dark:text-white">{r.name}</p>
              <p className="mt-1 text-xs text-slate-500">
                Si {describeCondition(r.conditions)} → {RULE_ACTIONS.find((a) => a.value === r.action)?.label ?? r.action}
              </p>
              {r.action_payload?.message && (
                <p className="mt-1 text-xs text-slate-600 italic dark:text-slate-400">"{r.action_payload.message}"</p>
              )}
            </div>
            <div className="flex shrink-0 items-center gap-2">
              <label className="flex items-center gap-1.5 text-xs text-slate-500">
                <input type="checkbox" defaultChecked={r.is_active} disabled={pending}
                  onChange={(e) => run(() => toggleRule(templateId, r.id, e.target.checked))}
                  className="rounded border-slate-300 text-emerald-600 focus:ring-emerald-500" />
                Activa
              </label>
              <button onClick={() => { if (confirm(`¿Eliminar la regla "${r.name}"?`)) run(() => deleteRule(templateId, r.id)) }}
                disabled={pending} className="rounded p-1.5 text-slate-400 hover:bg-red-50 hover:text-red-600 disabled:opacity-50 dark:hover:bg-red-900/20">
                <Trash2 size={15} />
              </button>
            </div>
          </div>
        </div>
      ))}

      <button onClick={() => setOpen(true)}
        className="inline-flex items-center gap-2 rounded-lg border border-dashed border-slate-300 px-4 py-2.5 text-sm font-medium text-slate-600 hover:border-emerald-400 hover:text-emerald-700 dark:border-slate-700 dark:text-slate-400">
        <Plus size={16} /> Nueva regla
      </button>

      <Modal open={open} onClose={() => setOpen(false)} title="Nueva regla" widthClass="max-w-xl">
        <div className="space-y-4">
          <div>
            <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">Nombre</label>
            <input value={name} onChange={(e) => setName(e.target.value)}
              placeholder="Ej. Avisar si el depósito es muy bajo" className={inputClass} />
          </div>

          <fieldset className="rounded-lg border border-slate-200 p-4 dark:border-slate-700">
            <legend className="px-2 text-xs font-bold tracking-wide text-slate-500 uppercase">Si</legend>
            <div className="grid gap-3 sm:grid-cols-3">
              <input value={variable} onChange={(e) => setVariable(e.target.value)} placeholder="variable" className={inputClass} />
              <select value={operator} onChange={(e) => setOperator(e.target.value as ConditionOperator)} className={inputClass}>
                {CONDITION_OPERATORS.map((o) => <option key={o.value} value={o.value}>{o.label}</option>)}
              </select>
              {needsValue && <input value={value} onChange={(e) => setValue(e.target.value)} placeholder="valor" className={inputClass} />}
            </div>
          </fieldset>

          <fieldset className="rounded-lg border border-slate-200 p-4 dark:border-slate-700">
            <legend className="px-2 text-xs font-bold tracking-wide text-slate-500 uppercase">Entonces</legend>
            <select value={action} onChange={(e) => setAction(e.target.value)} className={`${inputClass} mb-3`}>
              {RULE_ACTIONS.map((a) => <option key={a.value} value={a.value}>{a.label}</option>)}
            </select>

            {target === 'clause' && (
              <select value={targetClause} onChange={(e) => setTargetClause(e.target.value)} className={inputClass}>
                <option value="">Elige la cláusula…</option>
                {attachedClauses.map((a: any) => {
                  const c = clauses.find((x: any) => x.id === a.clause_id)
                  return c ? <option key={a.clause_id} value={a.clause_id}>{c.title}</option> : null
                })}
              </select>
            )}

            {target === 'variable' && (
              <input value={targetVariable} onChange={(e) => setTargetVariable(e.target.value)}
                placeholder="nombre de la variable" className={inputClass} />
            )}

            {action === 'WARN_USER' && (
              <input value={message} onChange={(e) => setMessage(e.target.value)}
                placeholder="El aviso que verá el usuario" className={inputClass} />
            )}
          </fieldset>

          <div className="flex justify-end gap-3">
            <button onClick={() => setOpen(false)} className="rounded-lg px-4 py-2 font-medium text-slate-600 hover:bg-slate-100 dark:text-slate-400 dark:hover:bg-slate-800">Cancelar</button>
            <button
              disabled={pending || !name.trim() || !variable.trim()}
              onClick={() => {
                const payload: Record<string, unknown> = {}
                if (target === 'clause' && targetClause) payload.clause_id = targetClause
                if (target === 'variable' && targetVariable) payload.variable_tag = targetVariable.trim()
                if (action === 'WARN_USER') payload.message = message

                run(
                  () => saveRule(templateId, null, {
                    name,
                    conditions: { variable: variable.trim(), operator, ...(needsValue ? { value } : {}) } as Condition,
                    action,
                    action_payload: payload,
                  }),
                  () => { setOpen(false); setName(''); setVariable(''); setMessage('') }
                )
              }}
              className="rounded-lg bg-emerald-600 px-5 py-2 font-semibold text-white hover:bg-emerald-700 disabled:opacity-50"
            >
              Crear regla
            </button>
          </div>
        </div>
      </Modal>
    </div>
  )
}

/* ── Revisión ── */

const ISSUE_ICON = {
  blocker: <AlertCircle size={16} className="text-red-600" />,
  warning: <AlertTriangle size={16} className="text-amber-600" />,
  hint: <Lightbulb size={16} className="text-slate-400" />,
}

const AREA_TAB: Record<string, Tab> = {
  general: 'general', secciones: 'secciones', variables: 'variables',
  clausulas: 'clausulas', reglas: 'reglas', revision: 'revision',
}

function ReviewTab({ report, onGo }: { report: QualityReport; onGo: (t: Tab) => void }) {
  if (report.issues.length === 0) {
    return (
      <div className={`${card} flex items-center gap-3`}>
        <CheckCircle2 size={20} className="text-emerald-600" />
        <p className="text-slate-700 dark:text-slate-300">
          La plantilla está completa. Puedes publicarla.
        </p>
      </div>
    )
  }

  return (
    <div className="space-y-2">
      {(['blocker', 'warning', 'hint'] as const).map((level) => {
        const items = report.issues.filter((i) => i.level === level)
        if (items.length === 0) return null

        return (
          <section key={level} className="space-y-2">
            <h3 className="mt-4 text-xs font-extrabold tracking-wider text-slate-500 uppercase">
              {ISSUE_LEVEL_LABEL[level]} ({items.length})
            </h3>
            {items.map((issue, i) => (
              <div key={i} className={`${card} flex items-start gap-3`}>
                <span className="mt-0.5 shrink-0">{ISSUE_ICON[level]}</span>
                <div className="min-w-0 flex-1">
                  <p className="font-medium text-slate-900 dark:text-white">{issue.title}</p>
                  <p className="mt-0.5 text-sm text-slate-500">{issue.detail}</p>
                </div>
                <button onClick={() => onGo(AREA_TAB[issue.area] ?? 'general')}
                  className="shrink-0 rounded-md px-2.5 py-1.5 text-sm font-medium text-emerald-700 hover:bg-emerald-50 dark:text-emerald-400 dark:hover:bg-emerald-900/20">
                  Ir
                </button>
              </div>
            ))}
          </section>
        )
      })}
    </div>
  )
}
