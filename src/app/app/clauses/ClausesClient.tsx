'use client'

import { useMemo, useState, useTransition } from 'react'
import { Plus, Pencil, Trash2, Copy, Loader2, Search, Scale, Info } from 'lucide-react'
import Modal from '@/components/ui/Modal'
import EmptyState from '@/components/ui/EmptyState'
import { createClause, updateClause, deleteClause, forkClause, CLAUSE_FAMILIES, type ClauseResult } from './actions'
import { extractTags } from '@/lib/engine/variables'

export type ClauseRow = {
  id: string
  org_id: string | null
  title: string
  family: string
  description: string | null
  body: string
  legal_reference: string | null
  status: string
}

export default function ClausesClient({
  mine,
  library,
  knownTags,
  canEdit,
}: {
  mine: ClauseRow[]
  library: ClauseRow[]
  knownTags: string[]
  canEdit: boolean
}) {
  const [tab, setTab] = useState<'mine' | 'library'>(mine.length === 0 && library.length > 0 ? 'library' : 'mine')
  const [query, setQuery] = useState('')
  const [editing, setEditing] = useState<ClauseRow | null>(null)
  const [creating, setCreating] = useState(false)
  const [result, setResult] = useState<ClauseResult | null>(null)
  const [pending, startTransition] = useTransition()

  const rows = tab === 'mine' ? mine : library
  const visible = useMemo(() => {
    const q = query.trim().toLowerCase()
    if (!q) return rows
    return rows.filter(
      (c) =>
        c.title.toLowerCase().includes(q) ||
        c.family.toLowerCase().includes(q) ||
        (c.description ?? '').toLowerCase().includes(q)
    )
  }, [rows, query])

  const byFamily = useMemo(() => {
    const map = new Map<string, ClauseRow[]>()
    for (const c of visible) {
      if (!map.has(c.family)) map.set(c.family, [])
      map.get(c.family)!.push(c)
    }
    return [...map.entries()].sort((a, b) => a[0].localeCompare(b[0]))
  }, [visible])

  function run(fn: () => Promise<ClauseResult>, after?: () => void) {
    setResult(null)
    startTransition(async () => {
      const r = await fn()
      setResult(r)
      if (r.ok) after?.()
    })
  }

  return (
    <div>
      <div className="mb-5 flex flex-wrap items-center gap-3">
        <div className="inline-flex rounded-lg border border-slate-200 bg-white p-1 dark:border-slate-800 dark:bg-slate-900">
          <button
            onClick={() => setTab('mine')}
            className={tab === 'mine'
              ? 'rounded-md bg-emerald-600 px-4 py-1.5 text-sm font-semibold text-white'
              : 'rounded-md px-4 py-1.5 text-sm font-medium text-slate-600 dark:text-slate-400'}
          >
            Mis cláusulas ({mine.length})
          </button>
          <button
            onClick={() => setTab('library')}
            className={tab === 'library'
              ? 'rounded-md bg-emerald-600 px-4 py-1.5 text-sm font-semibold text-white'
              : 'rounded-md px-4 py-1.5 text-sm font-medium text-slate-600 dark:text-slate-400'}
          >
            Biblioteca SA&amp;VE ({library.length})
          </button>
        </div>

        <div className="relative min-w-[200px] flex-1">
          <Search size={16} className="absolute top-1/2 left-3 -translate-y-1/2 text-slate-400" />
          <input
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="Buscar cláusula…"
            className="w-full rounded-lg border border-slate-300 bg-white py-2 pr-4 pl-9 text-slate-900 outline-none focus:ring-2 focus:ring-emerald-500 dark:border-slate-700 dark:bg-slate-900 dark:text-white"
          />
        </div>

        {canEdit && (
          <button
            onClick={() => { setEditing(null); setCreating(true); setResult(null) }}
            className="inline-flex items-center gap-2 rounded-lg bg-emerald-600 px-4 py-2 font-semibold text-white transition-colors hover:bg-emerald-700"
          >
            <Plus size={18} /> Nueva cláusula
          </button>
        )}
      </div>

      {result && (
        <p className={result.ok
          ? 'mb-4 rounded-lg bg-emerald-50 p-3 text-sm text-emerald-700 dark:bg-emerald-900/20 dark:text-emerald-400'
          : 'mb-4 rounded-lg bg-red-50 p-3 text-sm text-red-600 dark:bg-red-900/20'}>
          {result.ok ? result.notice : result.error}
        </p>
      )}

      {visible.length === 0 ? (
        <EmptyState
          title={tab === 'mine' ? 'Aún no tienes cláusulas propias' : 'La biblioteca está vacía'}
          description={tab === 'mine'
            ? 'Crea las cláusulas que siempre añades a mano, o adapta una de la biblioteca de SA&VE.'
            : 'El equipo de SA&VE todavía no ha publicado cláusulas revisadas.'}
        />
      ) : (
        <div className="space-y-8">
          {byFamily.map(([family, items]) => (
            <section key={family}>
              <h2 className="mb-3 text-xs font-extrabold tracking-wider text-slate-500 uppercase">
                {family}
              </h2>
              <div className="space-y-2">
                {items.map((c) => (
                  <article
                    key={c.id}
                    className="rounded-xl border border-slate-200 bg-white p-5 dark:border-slate-800 dark:bg-slate-900"
                  >
                    <div className="flex flex-wrap items-start justify-between gap-3">
                      <div className="min-w-0 flex-1">
                        <h3 className="font-semibold text-slate-900 dark:text-white">{c.title}</h3>
                        {c.description && (
                          <p className="mt-0.5 text-sm text-slate-500">{c.description}</p>
                        )}
                      </div>

                      <div className="flex shrink-0 gap-1">
                        {tab === 'library' ? (
                          canEdit && (
                            <button
                              onClick={() => run(() => forkClause(c.id), () => setTab('mine'))}
                              disabled={pending}
                              className="inline-flex items-center gap-1.5 rounded-md px-2.5 py-1.5 text-sm font-medium text-emerald-700 transition-colors hover:bg-emerald-50 disabled:opacity-50 dark:text-emerald-400 dark:hover:bg-emerald-900/20"
                            >
                              <Copy size={15} /> Adaptar
                            </button>
                          )
                        ) : canEdit && (
                          <>
                            <button
                              onClick={() => { setEditing(c); setCreating(false); setResult(null) }}
                              className="rounded-md p-2 text-slate-500 transition-colors hover:bg-slate-100 dark:hover:bg-slate-800"
                              title="Editar"
                            >
                              <Pencil size={15} />
                            </button>
                            <button
                              onClick={() => {
                                if (confirm(`¿Eliminar "${c.title}"? Se quitará de todas las plantillas que la usan.`)) {
                                  run(() => deleteClause(c.id))
                                }
                              }}
                              disabled={pending}
                              className="rounded-md p-2 text-slate-500 transition-colors hover:bg-red-50 hover:text-red-600 disabled:opacity-50 dark:hover:bg-red-900/20"
                              title="Eliminar"
                            >
                              <Trash2 size={15} />
                            </button>
                          </>
                        )}
                      </div>
                    </div>

                    <p className="mt-3 line-clamp-2 text-sm leading-relaxed text-slate-600 dark:text-slate-400">
                      {c.body}
                    </p>

                    <div className="mt-3 flex flex-wrap items-center gap-2">
                      {extractTags(c.body).slice(0, 6).map((t) => (
                        <code
                          key={t}
                          className={knownTags.includes(t)
                            ? 'rounded bg-slate-100 px-1.5 py-0.5 font-mono text-[11px] text-slate-600 dark:bg-slate-800 dark:text-slate-300'
                            : 'rounded bg-red-50 px-1.5 py-0.5 font-mono text-[11px] text-red-600 dark:bg-red-900/20'}
                          title={knownTags.includes(t) ? 'Variable existente' : 'Esta variable no existe todavía'}
                        >
                          {t}
                        </code>
                      ))}
                      {c.legal_reference && (
                        <span className="inline-flex items-center gap-1 text-[11px] text-slate-500">
                          <Scale size={11} /> {c.legal_reference}
                        </span>
                      )}
                    </div>
                  </article>
                ))}
              </div>
            </section>
          ))}
        </div>
      )}

      <ClauseModal
        open={creating || editing !== null}
        clause={editing}
        knownTags={knownTags}
        pending={pending}
        onClose={() => { setCreating(false); setEditing(null) }}
        onSubmit={(fd) => {
          const action = editing ? () => updateClause(editing.id, fd) : () => createClause(fd)
          run(action, () => { setCreating(false); setEditing(null) })
        }}
      />
    </div>
  )
}

/* ---------------------------------------------------------------- */

const inputClass =
  'w-full rounded-lg border border-slate-300 bg-slate-50 px-4 py-2 text-slate-900 outline-none focus:ring-2 focus:ring-emerald-500 dark:border-slate-700 dark:bg-slate-800 dark:text-white'

function ClauseModal({
  open,
  clause,
  knownTags,
  pending,
  onClose,
  onSubmit,
}: {
  open: boolean
  clause: ClauseRow | null
  knownTags: string[]
  pending: boolean
  onClose: () => void
  onSubmit: (fd: FormData) => void
}) {
  const [body, setBody] = useState(clause?.body ?? '')
  const tags = useMemo(() => extractTags(body), [body])
  const unknown = tags.filter((t) => !knownTags.includes(t))

  return (
    <Modal
      open={open}
      onClose={onClose}
      title={clause ? 'Editar cláusula' : 'Nueva cláusula'}
      widthClass="max-w-2xl"
    >
      <form action={onSubmit} className="space-y-4" key={clause?.id ?? 'new'}>
        <div className="grid gap-4 sm:grid-cols-[2fr_1fr]">
          <div>
            <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">Título</label>
            <input name="title" required defaultValue={clause?.title ?? ''} placeholder="Ej. Mascotas" className={inputClass} />
          </div>
          <div>
            <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">Familia</label>
            <select name="family" defaultValue={clause?.family ?? 'Generales'} className={inputClass}>
              {CLAUSE_FAMILIES.map((f) => <option key={f} value={f}>{f}</option>)}
            </select>
          </div>
        </div>

        <div>
          <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
            Para qué sirve
          </label>
          <input
            name="description"
            defaultValue={clause?.description ?? ''}
            placeholder="Una línea que explique cuándo usarla."
            className={inputClass}
          />
        </div>

        <div>
          <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">Texto</label>
          <textarea
            name="body"
            required
            rows={10}
            defaultValue={clause?.body ?? ''}
            onChange={(e) => setBody(e.target.value)}
            placeholder="Escribe la cláusula. Usa {{variable}} donde vaya un dato del formulario."
            className={`${inputClass} resize-y font-serif text-[15px] leading-relaxed`}
          />
        </div>

        {tags.length > 0 && (
          <div className="rounded-lg bg-slate-50 p-3 dark:bg-slate-800/50">
            <p className="mb-2 flex items-center gap-1.5 text-xs font-semibold text-slate-600 dark:text-slate-400">
              <Info size={13} /> Variables que usa esta cláusula
            </p>
            <div className="flex flex-wrap gap-1.5">
              {tags.map((t) => (
                <code
                  key={t}
                  className={knownTags.includes(t)
                    ? 'rounded bg-emerald-50 px-1.5 py-0.5 font-mono text-[11px] text-emerald-700 dark:bg-emerald-900/20 dark:text-emerald-400'
                    : 'rounded bg-red-50 px-1.5 py-0.5 font-mono text-[11px] text-red-600 dark:bg-red-900/20'}
                >
                  {t}
                </code>
              ))}
            </div>
            {unknown.length > 0 && (
              <p className="mt-2 text-xs text-red-600">
                {unknown.length === 1 ? 'Esa variable no existe' : 'Esas variables no existen'} todavía.
                Si no la creas, el documento saldrá con el hueco sin rellenar.
              </p>
            )}
          </div>
        )}

        <div>
          <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
            Referencia legal
          </label>
          <input
            name="legal_reference"
            defaultValue={clause?.legal_reference ?? ''}
            placeholder="Ej. Código Civil Dominicano, artículo 1708"
            className={inputClass}
          />
        </div>

        <div className="flex justify-end gap-3 pt-2">
          <button type="button" onClick={onClose} className="rounded-lg px-4 py-2 font-medium text-slate-600 hover:bg-slate-100 dark:text-slate-400 dark:hover:bg-slate-800">
            Cancelar
          </button>
          <button
            type="submit"
            disabled={pending}
            className="inline-flex items-center gap-2 rounded-lg bg-emerald-600 px-5 py-2 font-semibold text-white hover:bg-emerald-700 disabled:opacity-60"
          >
            {pending && <Loader2 size={16} className="animate-spin" />}
            {clause ? 'Guardar cambios' : 'Crear cláusula'}
          </button>
        </div>
      </form>
    </Modal>
  )
}
