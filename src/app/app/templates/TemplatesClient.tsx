'use client'

import { useState, useTransition } from 'react'
import Link from 'next/link'
import { FileText, Plus, Pencil, Trash2, Copy, Loader2, Wand2 } from 'lucide-react'
import Modal from '@/components/ui/Modal'
import EmptyState from '@/components/ui/EmptyState'
import { TEMPLATE_CATEGORIES } from '@/lib/categories'
import {
  createTemplate,
  updateTemplate,
  deleteTemplate,
  duplicateTemplate,
} from './actions'

export type TemplateRow = {
  id: string
  title: string
  category: string
  is_master: boolean
  version: string | null
  content: any
  created_at: string
}

type Tab = 'mine' | 'master'

export default function TemplatesClient({
  mine,
  master,
  canEdit,
}: {
  mine: TemplateRow[]
  master: TemplateRow[]
  canEdit: boolean
}) {
  const [tab, setTab] = useState<Tab>(mine.length === 0 && master.length > 0 ? 'master' : 'mine')
  const [editing, setEditing] = useState<TemplateRow | null>(null)
  const [creating, setCreating] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [pending, startTransition] = useTransition()

  const list = tab === 'mine' ? mine : master

  function handleSubmit(formData: FormData) {
    setError(null)
    startTransition(async () => {
      const result = editing
        ? await updateTemplate(editing.id, formData)
        : await createTemplate(formData)
      if (result.ok) {
        setCreating(false)
        setEditing(null)
      } else {
        setError(result.error ?? 'No se pudo guardar.')
      }
    })
  }

  function handleDelete(row: TemplateRow) {
    if (!confirm(`¿Eliminar "${row.title}"? Esta acción no se puede deshacer.`)) return
    setError(null)
    startTransition(async () => {
      const result = await deleteTemplate(row.id)
      if (!result.ok) setError(result.error ?? 'No se pudo eliminar.')
    })
  }

  function handleDuplicate(row: TemplateRow) {
    setError(null)
    startTransition(async () => {
      const result = await duplicateTemplate(row.id)
      if (result.ok) setTab('mine')
      else setError(result.error ?? 'No se pudo copiar.')
    })
  }

  return (
    <div>
      <div className="mb-6 flex flex-wrap items-center justify-between gap-4">
        <div
          role="tablist"
          className="inline-flex rounded-lg border border-slate-200 bg-white p-1 dark:border-slate-800 dark:bg-slate-900"
        >
          <TabButton active={tab === 'mine'} onClick={() => setTab('mine')}>
            Mis plantillas ({mine.length})
          </TabButton>
          <TabButton active={tab === 'master'} onClick={() => setTab('master')}>
            Biblioteca SA&amp;VE ({master.length})
          </TabButton>
        </div>

        {canEdit && (
          <button
            onClick={() => {
              setEditing(null)
              setCreating(true)
              setError(null)
            }}
            className="inline-flex items-center gap-2 rounded-lg bg-emerald-600 px-4 py-2 font-semibold text-white transition-colors hover:bg-emerald-700"
          >
            <Plus size={18} /> Nueva plantilla
          </button>
        )}
      </div>

      {error && (
        <p className="mb-4 rounded-lg bg-red-50 p-3 text-sm text-red-600 dark:bg-red-900/20">
          {error}
        </p>
      )}

      {list.length === 0 ? (
        <EmptyState
          title={tab === 'mine' ? 'Aún no tienes plantillas propias' : 'La biblioteca está vacía'}
          description={
            tab === 'mine'
              ? 'Crea una desde cero, o copia una de la Biblioteca SA&VE para adaptarla a tu despacho.'
              : 'El equipo de SA&VE todavía no ha publicado plantillas maestras.'
          }
        />
      ) : (
        <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
          {list.map((row) => (
            <article
              key={row.id}
              className="flex flex-col rounded-xl border border-slate-200 bg-white p-5 shadow-sm dark:border-slate-800 dark:bg-slate-900"
            >
              <div className="mb-3 flex items-start gap-3">
                <span className="mt-0.5 rounded-lg bg-emerald-50 p-2 text-emerald-600 dark:bg-emerald-900/20">
                  <FileText size={18} />
                </span>
                <div className="min-w-0 flex-1">
                  <h3 className="truncate font-semibold text-slate-900 dark:text-white" title={row.title}>
                    {row.title}
                  </h3>
                  <p className="text-xs text-slate-500">
                    {row.category} · v{row.version ?? '1.0'}
                  </p>
                </div>
              </div>

              <p className="mb-4 line-clamp-3 flex-1 text-sm text-slate-500">
                {previewOf(row.content) || 'Sin contenido todavía.'}
              </p>

              <div className="flex flex-wrap items-center gap-2 border-t border-slate-100 pt-3 dark:border-slate-800">
                <Link
                  href={`/app/documents/new/${row.id}`}
                  className="inline-flex items-center gap-1.5 rounded-md bg-emerald-600 px-3 py-1.5 text-sm font-semibold text-white transition-colors hover:bg-emerald-700"
                >
                  <Wand2 size={15} /> Usar
                </Link>

                {row.is_master ? (
                  <button
                    onClick={() => handleDuplicate(row)}
                    disabled={pending}
                    className="inline-flex items-center gap-1.5 rounded-md px-2.5 py-1.5 text-sm font-medium text-emerald-700 transition-colors hover:bg-emerald-50 disabled:opacity-50 dark:text-emerald-400 dark:hover:bg-emerald-900/20"
                  >
                    <Copy size={15} /> Copiar a mi despacho
                  </button>
                ) : (
                  <>
                    <button
                      onClick={() => {
                        setEditing(row)
                        setCreating(false)
                        setError(null)
                      }}
                      className="inline-flex items-center gap-1.5 rounded-md px-2.5 py-1.5 text-sm font-medium text-slate-600 transition-colors hover:bg-slate-100 dark:text-slate-400 dark:hover:bg-slate-800"
                    >
                      <Pencil size={15} /> Editar
                    </button>
                    <button
                      onClick={() => handleDelete(row)}
                      disabled={pending}
                      className="inline-flex items-center gap-1.5 rounded-md px-2.5 py-1.5 text-sm font-medium text-red-500 transition-colors hover:bg-red-50 disabled:opacity-50 dark:hover:bg-red-900/20"
                    >
                      <Trash2 size={15} /> Eliminar
                    </button>
                  </>
                )}
              </div>
            </article>
          ))}
        </div>
      )}

      <Modal
        open={creating || editing !== null}
        onClose={() => {
          setCreating(false)
          setEditing(null)
        }}
        title={editing ? 'Editar plantilla' : 'Nueva plantilla'}
        widthClass="max-w-2xl"
      >
        <form action={handleSubmit} className="space-y-4">
          <div>
            <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
              Título
            </label>
            <input
              name="title"
              required
              defaultValue={editing?.title ?? ''}
              placeholder="Ej. Contrato de Alquiler de Vivienda"
              className="w-full rounded-lg border border-slate-300 bg-slate-50 px-4 py-2 text-slate-900 outline-none focus:ring-2 focus:ring-emerald-500 dark:border-slate-700 dark:bg-slate-800 dark:text-white"
            />
          </div>

          <div>
            <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
              Categoría
            </label>
            <select
              name="category"
              required
              defaultValue={editing?.category ?? 'Inmobiliario'}
              className="w-full rounded-lg border border-slate-300 bg-slate-50 px-4 py-2 text-slate-900 outline-none focus:ring-2 focus:ring-emerald-500 dark:border-slate-700 dark:bg-slate-800 dark:text-white"
            >
              {TEMPLATE_CATEGORIES.map((c) => (
                <option key={c} value={c}>
                  {c}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
              Contenido
            </label>
            <textarea
              name="body"
              rows={12}
              defaultValue={editing ? previewOf(editing.content, true) : ''}
              placeholder="Escribe el cuerpo del documento. Usa {{variable}} para los campos que se rellenan al generar."
              className="w-full resize-y rounded-lg border border-slate-300 bg-slate-50 px-4 py-2 font-mono text-sm text-slate-900 outline-none focus:ring-2 focus:ring-emerald-500 dark:border-slate-700 dark:bg-slate-800 dark:text-white"
            />
            <p className="mt-1 text-xs text-slate-500">
              Las variables entre llaves dobles, como <code>{'{{nombre_comprador}}'}</code>, se
              convertirán en campos del formulario.
            </p>
          </div>

          {error && (
            <p className="rounded-lg bg-red-50 p-3 text-sm text-red-600 dark:bg-red-900/20">{error}</p>
          )}

          <div className="flex justify-end gap-3 pt-2">
            <button
              type="button"
              onClick={() => {
                setCreating(false)
                setEditing(null)
              }}
              className="rounded-lg px-4 py-2 font-medium text-slate-600 transition-colors hover:bg-slate-100 dark:text-slate-400 dark:hover:bg-slate-800"
            >
              Cancelar
            </button>
            <button
              type="submit"
              disabled={pending}
              className="inline-flex items-center gap-2 rounded-lg bg-emerald-600 px-5 py-2 font-semibold text-white transition-colors hover:bg-emerald-700 disabled:opacity-60"
            >
              {pending && <Loader2 size={16} className="animate-spin" />}
              {editing ? 'Guardar cambios' : 'Crear plantilla'}
            </button>
          </div>
        </form>
      </Modal>
    </div>
  )
}

function TabButton({
  active,
  onClick,
  children,
}: {
  active: boolean
  onClick: () => void
  children: React.ReactNode
}) {
  return (
    <button
      role="tab"
      aria-selected={active}
      onClick={onClick}
      className={
        active
          ? 'rounded-md bg-emerald-600 px-4 py-1.5 text-sm font-semibold text-white'
          : 'rounded-md px-4 py-1.5 text-sm font-medium text-slate-600 transition-colors hover:text-slate-900 dark:text-slate-400 dark:hover:text-white'
      }
    >
      {children}
    </button>
  )
}

function previewOf(content: any, full = false): string {
  if (!content) return ''
  const text =
    typeof content === 'string'
      ? content
      : typeof content?.body === 'string'
        ? content.body
        : JSON.stringify(content)
  return full ? text : text.slice(0, 220)
}
