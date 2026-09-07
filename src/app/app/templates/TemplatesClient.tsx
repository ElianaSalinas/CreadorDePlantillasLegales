'use client'

import { useMemo, useState, useTransition } from 'react'
import Link from 'next/link'
import { FileText, Plus, Pencil, Trash2, Copy, Loader2, Wand2, Search, Upload } from 'lucide-react'
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
  description: string | null
  is_master: boolean
  version: string | null
  content: any
  created_at: string
}

type Tab = 'mine' | 'master'

/** Cuántas tarjetas se pintan de una vez. */
const PASO = 24

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
  const [busqueda, setBusqueda] = useState('')
  const [categoria, setCategoria] = useState('')
  const [aLaVista, setALaVista] = useState(PASO)

  const todas = tab === 'mine' ? mine : master

  // Las categorías salen de lo que hay, no de una lista fija: si mañana
  // aparece una nueva en el catálogo, el filtro la recoge sola.
  const categorias = useMemo(
    () => [...new Set(todas.map((t) => t.category).filter(Boolean))].sort((a, b) =>
      a.localeCompare(b, 'es')
    ),
    [todas]
  )

  const filtradas = useMemo(() => {
    const q = busqueda.trim().toLowerCase()
    return todas.filter((t) => {
      if (categoria && t.category !== categoria) return false
      if (!q) return true
      return (
        t.title.toLowerCase().includes(q) ||
        (t.description ?? '').toLowerCase().includes(q) ||
        (t.category ?? '').toLowerCase().includes(q)
      )
    })
  }, [todas, busqueda, categoria])

  // Pintar las 251 de golpe eran siete mil nodos y una espera notable en
  // un teléfono. Se muestran por tandas, y quien busca casi nunca
  // necesita pasar de la primera.
  const list = filtradas.slice(0, aLaVista)

  function cambiarPestana(nueva: Tab) {
    setTab(nueva)
    setBusqueda('')
    setCategoria('')
    setALaVista(PASO)
  }

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
          <TabButton active={tab === 'mine'} onClick={() => cambiarPestana('mine')}>
            Mis plantillas ({mine.length})
          </TabButton>
          <TabButton active={tab === 'master'} onClick={() => cambiarPestana('master')}>
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

        {canEdit && (
          <Link
            href="/app/templates/importar"
            className="inline-flex items-center gap-2 rounded-lg border border-slate-200 px-4 py-2 font-semibold text-slate-700 transition-colors hover:bg-slate-50 dark:border-slate-700 dark:text-slate-300 dark:hover:bg-slate-800"
          >
            <Upload size={18} /> Convertir un documento
          </Link>
        )}
      </div>

      {todas.length > 8 && (
        <div className="mb-5 flex flex-wrap items-center gap-3">
          <div className="relative min-w-[220px] flex-1">
            <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
            <input
              type="search"
              value={busqueda}
              onChange={(e) => {
                setBusqueda(e.target.value)
                setALaVista(PASO)
              }}
              placeholder="Buscar por nombre, categoría o descripción…"
              aria-label="Buscar plantillas"
              className="w-full rounded-lg border border-slate-200 bg-white py-2 pl-9 pr-3 text-sm dark:border-slate-800 dark:bg-slate-900 dark:text-slate-200"
            />
          </div>

          <select
            value={categoria}
            onChange={(e) => {
              setCategoria(e.target.value)
              setALaVista(PASO)
            }}
            aria-label="Filtrar por categoría"
            className="rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm dark:border-slate-800 dark:bg-slate-900 dark:text-slate-200"
          >
            <option value="">Todas las categorías</option>
            {categorias.map((c) => (
              <option key={c} value={c}>
                {c}
              </option>
            ))}
          </select>

          <span className="text-sm text-slate-500">
            {filtradas.length === todas.length
              ? `${todas.length} plantillas`
              : `${filtradas.length} de ${todas.length}`}
          </span>
        </div>
      )}

      {error && (
        <p className="mb-4 rounded-lg bg-red-50 p-3 text-sm text-red-600 dark:bg-red-900/20">
          {error}
        </p>
      )}

      {list.length === 0 && todas.length > 0 ? (
        <div className="rounded-xl border border-slate-200 bg-white p-10 text-center dark:border-slate-800 dark:bg-slate-900">
          <p className="font-semibold text-slate-700 dark:text-slate-300">
            Ninguna plantilla coincide con lo que buscas.
          </p>
          <button
            onClick={() => {
              setBusqueda('')
              setCategoria('')
            }}
            className="mt-2 text-sm text-emerald-600 underline underline-offset-2"
          >
            Quitar los filtros
          </button>
        </div>
      ) : list.length === 0 ? (
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
                {row.description?.trim() || previewOf(row.content) || 'Sin descripción todavía.'}
              </p>

              <div className="flex flex-wrap items-center gap-2 border-t border-slate-100 pt-3 dark:border-slate-800">
                <Link
                  href={`/app/documents/new/${row.id}`}
                  data-analitica="template_start"
                  data-analitica-etiqueta={row.title}
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
                    <Link
                      href={`/app/templates/${row.id}/edit`}
                      className="inline-flex items-center gap-1.5 rounded-md px-2.5 py-1.5 text-sm font-medium text-slate-600 transition-colors hover:bg-slate-100 dark:text-slate-400 dark:hover:bg-slate-800"
                    >
                      <Pencil size={15} /> Editar
                    </Link>
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

      {filtradas.length > list.length && (
        <div className="mt-6 text-center">
          <button
            onClick={() => setALaVista((n) => n + PASO)}
            className="rounded-lg border border-slate-200 px-5 py-2.5 text-sm font-semibold text-slate-700 transition-colors hover:bg-slate-50 dark:border-slate-700 dark:text-slate-300 dark:hover:bg-slate-800"
          >
            Mostrar {Math.min(PASO, filtradas.length - list.length)} más
          </button>
          <p className="mt-2 text-xs text-slate-400">
            Viendo {list.length} de {filtradas.length}
          </p>
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

/**
 * Vista previa del texto de una plantilla.
 *
 * Antes, cuando no había texto que enseñar, esto caía en
 * JSON.stringify(content) y pintaba {"engine":"v2"} en la tarjeta. Las
 * 251 plantillas del catálogo son de motor v2 —su texto vive en las
 * secciones, no en esta columna—, así que ese literal salía 251 veces
 * en pantalla. Si no hay texto de verdad, no se enseña nada.
 */
function previewOf(content: any, full = false): string {
  if (!content) return ''

  const text =
    typeof content === 'string'
      ? content
      : typeof content?.body === 'string'
        ? content.body
        : ''

  if (!text.trim()) return ''
  return full ? text : text.slice(0, 220)
}
