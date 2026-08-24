'use client'

import { useEffect, useMemo, useRef, useState, useTransition } from 'react'
import { useRouter } from 'next/navigation'
import { Loader2, AlertTriangle, Check, X, FileText, Eye } from 'lucide-react'
import { previewDocument, generateDocument, type PreviewResult } from '../../actions'
import { questionFor } from '@/lib/engine/variables'
import type { Answers, Variable } from '@/lib/engine/types'

type Group = { id: string; title: string; variables: Variable[] }

const REASON_LABEL: Record<string, string> = {
  obligatoria: 'siempre se incluye',
  'opcional-activada': 'la activaste',
  'opcional-desactivada': 'la desactivaste',
  'condicion-cumplida': 'por tus respuestas',
  'condicion-no-cumplida': 'no aplica según tus respuestas',
  regla: 'una regla la exige',
  'regla-excluye': 'una regla la excluye',
}

export default function GeneratorClient({
  templateId,
  templateTitle,
  groups,
  defaults,
}: {
  templateId: string
  templateTitle: string
  groups: Group[]
  defaults: Answers
}) {
  const router = useRouter()
  const [answers, setAnswers] = useState<Answers>(defaults)
  const [title, setTitle] = useState(templateTitle)
  const [preview, setPreview] = useState<PreviewResult | null>(null)
  const [showPreview, setShowPreview] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [pending, startTransition] = useTransition()
  const [saving, startSaving] = useTransition()
  const timer = useRef<ReturnType<typeof setTimeout> | null>(null)

  // La vista previa se recalcula sola, con una pausa para no pedirla
  // en cada tecla.
  useEffect(() => {
    if (timer.current) clearTimeout(timer.current)
    timer.current = setTimeout(() => {
      startTransition(async () => {
        const r = await previewDocument(templateId, answers)
        if (r.ok) setPreview(r)
      })
    }, 450)
    return () => {
      if (timer.current) clearTimeout(timer.current)
    }
  }, [answers, templateId])

  const hidden = useMemo(() => new Set(preview?.hiddenVariables ?? []), [preview])
  const required = useMemo(() => new Set(preview?.requiredVariables ?? []), [preview])
  const errorByTag = useMemo(
    () => new Map((preview?.fieldErrors ?? []).map((e) => [e.tag, e.message])),
    [preview]
  )

  function set(tag: string, value: unknown) {
    setAnswers((prev) => ({ ...prev, [tag]: value }))
  }

  function handleGenerate() {
    setError(null)
    startSaving(async () => {
      const r = await generateDocument(templateId, answers, title)
      if (r.ok && r.documentId) {
        router.push(`/app/documents/${r.documentId}`)
      } else {
        setError(r.error ?? 'No se pudo generar el documento.')
      }
    })
  }

  const included = preview?.clauses?.filter((c) => c.included) ?? []
  const excluded = preview?.clauses?.filter((c) => !c.included) ?? []

  return (
    <div className="grid gap-6 lg:grid-cols-[minmax(0,1fr)_380px]">
      {/* ── Formulario ── */}
      <div className="space-y-6">
        <div className="rounded-xl border border-slate-200 bg-white p-6 dark:border-slate-800 dark:bg-slate-900">
          <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
            Nombre del documento
          </label>
          <input
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            className="w-full rounded-lg border border-slate-300 bg-slate-50 px-4 py-2 text-slate-900 outline-none focus:ring-2 focus:ring-emerald-500 dark:border-slate-700 dark:bg-slate-800 dark:text-white"
          />
          <p className="mt-1 text-xs text-slate-500">Solo para encontrarlo después en tu bóveda.</p>
        </div>

        {groups.map((group) => {
          const visible = group.variables.filter((v) => !hidden.has(v.tag))
          if (visible.length === 0) return null

          return (
            <section
              key={group.id}
              className="rounded-xl border border-slate-200 bg-white p-6 dark:border-slate-800 dark:bg-slate-900"
            >
              <h2 className="mb-5 font-bold text-slate-900 dark:text-white">{group.title}</h2>
              <div className="grid gap-4 sm:grid-cols-2">
                {visible.map((v) => (
                  <Field
                    key={v.id}
                    variable={v}
                    value={answers[v.tag]}
                    onChange={(val) => set(v.tag, val)}
                    error={errorByTag.get(v.tag)}
                    forcedRequired={required.has(v.tag)}
                  />
                ))}
              </div>
            </section>
          )
        })}

        {error && (
          <p className="rounded-lg bg-red-50 p-3 text-sm text-red-600 dark:bg-red-900/20">{error}</p>
        )}

        <div className="flex flex-wrap items-center gap-3">
          <button
            onClick={handleGenerate}
            disabled={saving}
            className="inline-flex items-center gap-2 rounded-lg bg-emerald-600 px-6 py-3 font-semibold text-white transition-colors hover:bg-emerald-700 disabled:opacity-60"
          >
            {saving ? <Loader2 size={18} className="animate-spin" /> : <FileText size={18} />}
            Generar documento
          </button>
          <button
            onClick={() => setShowPreview((s) => !s)}
            className="inline-flex items-center gap-2 rounded-lg border border-slate-300 px-5 py-3 font-medium text-slate-700 transition-colors hover:bg-slate-50 dark:border-slate-700 dark:text-slate-300 dark:hover:bg-slate-800"
          >
            <Eye size={17} />
            {showPreview ? 'Ocultar' : 'Ver'} el texto
          </button>
        </div>

        {showPreview && (
          <pre className="max-h-[600px] overflow-auto rounded-xl border border-slate-200 bg-white p-6 font-serif text-sm leading-relaxed whitespace-pre-wrap text-slate-800 dark:border-slate-800 dark:bg-slate-900 dark:text-slate-200">
            {preview?.text || 'Rellena el formulario para ver el documento.'}
          </pre>
        )}
      </div>

      {/* ── Panel lateral ── */}
      <aside className="space-y-4 lg:sticky lg:top-6 lg:self-start">
        {pending && (
          <p className="flex items-center gap-2 text-sm text-slate-500">
            <Loader2 size={14} className="animate-spin" /> Actualizando…
          </p>
        )}

        {(preview?.warnings?.length ?? 0) > 0 && (
          <div className="rounded-xl border border-amber-200 bg-amber-50 p-4 dark:border-amber-800 dark:bg-amber-900/20">
            <p className="mb-2 flex items-center gap-2 text-sm font-bold text-amber-800 dark:text-amber-400">
              <AlertTriangle size={15} /> Revisa esto
            </p>
            <ul className="space-y-1.5 text-sm text-amber-800 dark:text-amber-300">
              {preview!.warnings!.map((w, i) => (
                <li key={i}>{w}</li>
              ))}
            </ul>
          </div>
        )}

        <div className="rounded-xl border border-slate-200 bg-white p-5 dark:border-slate-800 dark:bg-slate-900">
          <h3 className="mb-1 font-bold text-slate-900 dark:text-white">Cláusulas del documento</h3>
          <p className="mb-4 text-xs text-slate-500">
            Cambian solas según lo que respondas.
          </p>

          <ul className="space-y-2">
            {included.map((c) => (
              <li key={c.clauseId} className="flex items-start gap-2.5">
                <Check size={15} className="mt-0.5 shrink-0 text-emerald-600" />
                <span>
                  <span className="block text-sm font-medium text-slate-800 dark:text-slate-200">
                    {c.title}
                  </span>
                  <span className="block text-xs text-slate-500">{REASON_LABEL[c.reason] ?? c.reason}</span>
                </span>
              </li>
            ))}

            {excluded.map((c) => (
              <li key={c.clauseId} className="flex items-start gap-2.5 opacity-55">
                <X size={15} className="mt-0.5 shrink-0 text-slate-400" />
                <span>
                  <span className="block text-sm text-slate-600 line-through dark:text-slate-400">
                    {c.title}
                  </span>
                  <span className="block text-xs text-slate-500">{REASON_LABEL[c.reason] ?? c.reason}</span>
                </span>
              </li>
            ))}
          </ul>

          {included.length === 0 && excluded.length === 0 && (
            <p className="text-sm text-slate-500">Empieza a rellenar el formulario.</p>
          )}
        </div>

        {(preview?.missing?.length ?? 0) > 0 && (
          <div className="rounded-xl border border-slate-200 bg-slate-50 p-4 dark:border-slate-800 dark:bg-slate-800/50">
            <p className="mb-2 text-sm font-semibold text-slate-700 dark:text-slate-300">
              Faltan {preview!.missing!.length} datos
            </p>
            <p className="text-xs text-slate-500">
              El documento se puede generar igual, pero saldrán marcados como pendientes.
            </p>
          </div>
        )}
      </aside>
    </div>
  )
}

/* ---------------------------------------------------------------- */

const inputClass =
  'w-full rounded-lg border border-slate-300 bg-slate-50 px-3 py-2 text-slate-900 outline-none focus:ring-2 focus:ring-emerald-500 dark:border-slate-700 dark:bg-slate-800 dark:text-white'

function Field({
  variable,
  value,
  onChange,
  error,
  forcedRequired,
}: {
  variable: Variable
  value: unknown
  onChange: (v: unknown) => void
  error?: string
  forcedRequired: boolean
}) {
  const required = forcedRequired || variable.is_required
  const wide = variable.data_type === 'textarea' || variable.data_type === 'address' || variable.data_type === 'multiselect'

  return (
    <div className={wide ? 'sm:col-span-2' : undefined}>
      <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
        {questionFor(variable)}
        {required && <span className="ml-1 text-red-500">*</span>}
      </label>

      <Control variable={variable} value={value} onChange={onChange} />

      {variable.help_text && !error && (
        <p className="mt-1 text-xs text-slate-500">{variable.help_text}</p>
      )}
      {error && <p className="mt-1 text-xs text-red-500">{error}</p>}
    </div>
  )
}

function Control({
  variable,
  value,
  onChange,
}: {
  variable: Variable
  value: unknown
  onChange: (v: unknown) => void
}) {
  const t = variable.data_type

  if (t === 'boolean') {
    return (
      <label className="flex items-center gap-2.5 rounded-lg border border-slate-300 px-3 py-2 dark:border-slate-700">
        <input
          type="checkbox"
          checked={value === true}
          onChange={(e) => onChange(e.target.checked)}
          className="rounded border-slate-300 text-emerald-600 focus:ring-emerald-500"
        />
        <span className="text-sm text-slate-700 dark:text-slate-300">Sí</span>
      </label>
    )
  }

  if (t === 'select') {
    return (
      <select value={String(value ?? '')} onChange={(e) => onChange(e.target.value)} className={inputClass}>
        <option value="">Selecciona…</option>
        {variable.options.map((o) => (
          <option key={o.value} value={o.value}>
            {o.label}
          </option>
        ))}
      </select>
    )
  }

  if (t === 'multiselect') {
    const selected = Array.isArray(value) ? (value as string[]) : []
    return (
      <div className="flex flex-wrap gap-2">
        {variable.options.map((o) => {
          const on = selected.includes(o.value)
          return (
            <button
              key={o.value}
              type="button"
              onClick={() =>
                onChange(on ? selected.filter((s) => s !== o.value) : [...selected, o.value])
              }
              className={
                on
                  ? 'rounded-full bg-emerald-600 px-3.5 py-1.5 text-sm font-medium text-white'
                  : 'rounded-full border border-slate-300 px-3.5 py-1.5 text-sm text-slate-600 transition-colors hover:border-emerald-400 dark:border-slate-700 dark:text-slate-400'
              }
            >
              {o.label}
            </button>
          )
        })}
      </div>
    )
  }

  if (t === 'textarea') {
    return (
      <textarea
        rows={5}
        value={String(value ?? '')}
        onChange={(e) => onChange(e.target.value)}
        className={`${inputClass} resize-y`}
      />
    )
  }

  const inputType =
    t === 'date' ? 'date'
    : t === 'email' ? 'email'
    : t === 'number' || t === 'currency' || t === 'percentage' ? 'number'
    : t === 'phone' ? 'tel'
    : 'text'

  const placeholder =
    t === 'cedula' ? '000-0000000-0'
    : t === 'rnc' ? '000000000'
    : t === 'phone' ? '809-000-0000'
    : t === 'currency' ? '0.00'
    : undefined

  return (
    <input
      type={inputType}
      inputMode={t === 'cedula' || t === 'rnc' ? 'numeric' : undefined}
      step={t === 'currency' ? '0.01' : undefined}
      value={String(value ?? '')}
      placeholder={placeholder}
      onChange={(e) => {
        const raw = e.target.value
        onChange(inputType === 'number' && raw !== '' ? Number(raw) : raw)
      }}
      className={inputClass}
    />
  )
}
