'use client'

import { useMemo, useState, useTransition } from 'react'
import Link from 'next/link'
import {
  Check,
  ChevronDown,
  ChevronRight,
  CircleAlert,
  Loader2,
  Pencil,
  RotateCcw,
  Save,
  Search,
  TriangleAlert,
  X,
} from 'lucide-react'
import {
  aprobarClausulas,
  aprobarPlantillas,
  devolverClausulas,
  devolverPlantillas,
  guardarClausula,
  type RevisionResult,
} from './actions'

export type PendientePlantilla = {
  id: string
  title: string
  description: string | null
  category: string | null
  status: string
  version: string | null
  reviewed_at: string | null
}

export type PendienteClausula = {
  id: string
  title: string
  family: string
  description: string | null
  body: string
  legal_reference: string | null
  status: string
  reviewed_at: string | null
}

type Pestana = 'clausulas' | 'plantillas'

export default function RevisionClient({
  plantillas,
  clausulas,
}: {
  plantillas: PendientePlantilla[]
  clausulas: PendienteClausula[]
}) {
  // Se empieza por las cláusulas a propósito: una plantilla maestra no se
  // deja publicar mientras alguna de sus cláusulas siga en borrador.
  const [pestana, setPestana] = useState<Pestana>(
    clausulas.some((c) => c.status !== 'PUBLISHED') ? 'clausulas' : 'plantillas'
  )
  const [busqueda, setBusqueda] = useState('')
  const [soloPendientes, setSoloPendientes] = useState(true)
  const [marcadas, setMarcadas] = useState<Set<string>>(new Set())
  const [abierta, setAbierta] = useState<string | null>(null)
  const [resultado, setResultado] = useState<RevisionResult | null>(null)
  const [enCurso, empezar] = useTransition()

  const clausulasPendientes = clausulas.filter((c) => c.status !== 'PUBLISHED').length

  /* ── Qué filas se ven ── */

  const visibles = useMemo(() => {
    const q = busqueda.trim().toLowerCase()
    const filas: { id: string; grupo: string; titulo: string; status: string }[] =
      pestana === 'clausulas'
        ? clausulas.map((c) => ({ id: c.id, grupo: c.family, titulo: c.title, status: c.status }))
        : plantillas.map((p) => ({
            id: p.id,
            grupo: p.category ?? 'Sin categoría',
            titulo: p.title,
            status: p.status,
          }))

    return filas.filter((f) => {
      if (soloPendientes && f.status === 'PUBLISHED') return false
      if (!q) return true
      return f.titulo.toLowerCase().includes(q) || f.grupo.toLowerCase().includes(q)
    })
  }, [pestana, clausulas, plantillas, busqueda, soloPendientes])

  const porGrupo = useMemo(() => {
    const mapa = new Map<string, typeof visibles>()
    for (const f of visibles) {
      if (!mapa.has(f.grupo)) mapa.set(f.grupo, [])
      mapa.get(f.grupo)!.push(f)
    }
    return [...mapa.entries()].sort((a, b) => a[0].localeCompare(b[0], 'es'))
  }, [visibles])

  const clausulaPorId = useMemo(() => new Map(clausulas.map((c) => [c.id, c])), [clausulas])
  const plantillaPorId = useMemo(() => new Map(plantillas.map((p) => [p.id, p])), [plantillas])

  /* ── Selección ── */

  function alternar(id: string) {
    setMarcadas((prev) => {
      const s = new Set(prev)
      if (s.has(id)) s.delete(id)
      else s.add(id)
      return s
    })
  }

  function marcarGrupo(ids: string[], marcar: boolean) {
    setMarcadas((prev) => {
      const s = new Set(prev)
      for (const id of ids) (marcar ? s.add(id) : s.delete(id))
      return s
    })
  }

  // Solo se manda lo que está a la vista: así el botón nunca aprueba de
  // más algo que quedó marcado y luego se filtró de la lista.
  const seleccionVisible = visibles.filter((f) => marcadas.has(f.id)).map((f) => f.id)

  function ejecutar(fn: (ids: string[]) => Promise<RevisionResult>) {
    setResultado(null)
    empezar(async () => {
      const r = await fn(seleccionVisible)
      setResultado(r)
      if (r.ok) setMarcadas(new Set())
    })
  }

  const aprobar = () =>
    ejecutar(pestana === 'clausulas' ? aprobarClausulas : aprobarPlantillas)
  const devolver = () =>
    ejecutar(pestana === 'clausulas' ? devolverClausulas : devolverPlantillas)

  /* ── Pintado ── */

  return (
    <div>
      {/* Pestañas */}
      <div className="mb-5 flex flex-wrap items-center gap-3">
        <div className="inline-flex rounded-lg border border-slate-200 bg-white p-1 dark:border-slate-800 dark:bg-slate-900">
          {(
            [
              ['clausulas', `Cláusulas (${clausulas.filter((c) => c.status !== 'PUBLISHED').length} por revisar)`],
              ['plantillas', `Plantillas (${plantillas.filter((p) => p.status !== 'PUBLISHED').length} por revisar)`],
            ] as [Pestana, string][]
          ).map(([clave, texto]) => (
            <button
              key={clave}
              onClick={() => {
                setPestana(clave)
                setMarcadas(new Set())
                setResultado(null)
              }}
              className={
                pestana === clave
                  ? 'rounded-md bg-emerald-600 px-4 py-1.5 text-sm font-semibold text-white'
                  : 'rounded-md px-4 py-1.5 text-sm font-medium text-slate-600 dark:text-slate-400'
              }
            >
              {texto}
            </button>
          ))}
        </div>

        <div className="relative flex-1 min-w-[200px]">
          <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
          <input
            value={busqueda}
            onChange={(e) => setBusqueda(e.target.value)}
            placeholder="Buscar por título o categoría…"
            className="w-full rounded-lg border border-slate-200 bg-white py-2 pl-9 pr-3 text-sm dark:border-slate-800 dark:bg-slate-900 dark:text-slate-200"
          />
        </div>

        <label className="flex items-center gap-2 text-sm text-slate-600 dark:text-slate-400">
          <input
            type="checkbox"
            checked={soloPendientes}
            onChange={(e) => setSoloPendientes(e.target.checked)}
            className="h-4 w-4 rounded border-slate-300 text-emerald-600"
          />
          Solo lo que falta
        </label>
      </div>

      {/* El orden importa, y conviene decirlo antes de que se estrelle */}
      {pestana === 'plantillas' && clausulasPendientes > 0 && (
        <div className="mb-4 flex items-start gap-3 rounded-xl border border-amber-200 bg-amber-50 p-4 text-sm dark:border-amber-800 dark:bg-amber-900/20">
          <TriangleAlert size={18} className="mt-0.5 shrink-0 text-amber-600" />
          <p className="text-amber-800 dark:text-amber-300">
            Quedan <strong>{clausulasPendientes} cláusulas</strong> sin aprobar. Una plantilla que
            use alguna de ellas no se dejará publicar todavía: el sistema no publica un documento
            maestro con texto legal sin revisar. Conviene terminar las cláusulas primero.
          </p>
        </div>
      )}

      {/* Resultado de la última acción */}
      {resultado && (
        <div
          className={
            resultado.ok
              ? 'mb-4 rounded-xl border border-emerald-200 bg-emerald-50 p-4 text-sm text-emerald-800 dark:border-emerald-800 dark:bg-emerald-900/20 dark:text-emerald-300'
              : 'mb-4 rounded-xl border border-red-200 bg-red-50 p-4 text-sm text-red-800 dark:border-red-800 dark:bg-red-900/20 dark:text-red-300'
          }
        >
          <p className="font-semibold">{resultado.notice ?? resultado.error}</p>

          {resultado.fallos && resultado.fallos.length > 0 && (
            <ul className="mt-3 space-y-2">
              {resultado.fallos.map((f) => (
                <li key={f.id} className="flex items-start gap-2">
                  <CircleAlert size={15} className="mt-0.5 shrink-0" />
                  <span>
                    <Link
                      href={`/app/templates/${f.id}/edit`}
                      className="font-semibold underline underline-offset-2"
                    >
                      {f.titulo}
                    </Link>
                    <span className="block text-xs opacity-90">{f.motivo}</span>
                  </span>
                </li>
              ))}
            </ul>
          )}
        </div>
      )}

      {/* Barra de acciones */}
      <div className="mb-4 flex flex-wrap items-center gap-3 rounded-xl border border-slate-200 bg-white p-3 dark:border-slate-800 dark:bg-slate-900">
        <span className="text-sm text-slate-600 dark:text-slate-400">
          {seleccionVisible.length === 0
            ? 'Marca lo que hayas leído y apruébalo.'
            : `${seleccionVisible.length} seleccionada(s).`}
        </span>

        <div className="ml-auto flex gap-2">
          <button
            onClick={devolver}
            disabled={enCurso || seleccionVisible.length === 0}
            className="inline-flex items-center gap-1.5 rounded-lg border border-slate-200 px-3 py-2 text-sm font-medium text-slate-600 transition-colors hover:bg-slate-50 disabled:opacity-40 dark:border-slate-700 dark:text-slate-400 dark:hover:bg-slate-800"
          >
            <RotateCcw size={15} /> Devolver a borrador
          </button>
          <button
            onClick={aprobar}
            disabled={enCurso || seleccionVisible.length === 0}
            className="inline-flex items-center gap-1.5 rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white transition-colors hover:bg-emerald-700 disabled:opacity-40"
          >
            {enCurso ? <Loader2 size={15} className="animate-spin" /> : <Check size={15} />}
            Aprobar y publicar
          </button>
        </div>
      </div>

      {/* Lista */}
      {porGrupo.length === 0 ? (
        <div className="rounded-xl border border-slate-200 bg-white p-10 text-center dark:border-slate-800 dark:bg-slate-900">
          <p className="font-semibold text-slate-700 dark:text-slate-300">
            {soloPendientes ? 'No queda nada por revisar aquí.' : 'No hay resultados.'}
          </p>
          {soloPendientes && (
            <button
              onClick={() => setSoloPendientes(false)}
              className="mt-2 text-sm text-emerald-600 underline underline-offset-2"
            >
              Ver también lo ya aprobado
            </button>
          )}
        </div>
      ) : (
        <div className="space-y-5">
          {porGrupo.map(([grupo, filas]) => {
            const ids = filas.map((f) => f.id)
            const todas = ids.every((id) => marcadas.has(id))

            return (
              <section key={grupo}>
                <div className="mb-2 flex items-center gap-3">
                  <label className="flex items-center gap-2 text-xs font-bold uppercase tracking-wide text-slate-500">
                    <input
                      type="checkbox"
                      checked={todas}
                      onChange={(e) => marcarGrupo(ids, e.target.checked)}
                      className="h-4 w-4 rounded border-slate-300 text-emerald-600"
                    />
                    {grupo}
                  </label>
                  <span className="text-xs text-slate-400">{filas.length}</span>
                </div>

                <ul className="divide-y divide-slate-100 overflow-hidden rounded-xl border border-slate-200 bg-white dark:divide-slate-800 dark:border-slate-800 dark:bg-slate-900">
                  {filas.map((f) => {
                    const c = clausulaPorId.get(f.id)
                    const p = plantillaPorId.get(f.id)
                    const desplegada = abierta === f.id

                    return (
                      <li key={f.id} className="px-4 py-3">
                        <div className="flex items-start gap-3">
                          <input
                            type="checkbox"
                            checked={marcadas.has(f.id)}
                            onChange={() => alternar(f.id)}
                            className="mt-1 h-4 w-4 shrink-0 rounded border-slate-300 text-emerald-600"
                          />

                          <div className="min-w-0 flex-1">
                            <div className="flex flex-wrap items-center gap-2">
                              <span className="font-medium text-slate-800 dark:text-slate-200">
                                {f.titulo}
                              </span>
                              {f.status === 'PUBLISHED' && (
                                <span className="rounded-full bg-emerald-100 px-2 py-0.5 text-[10px] font-bold uppercase text-emerald-700 dark:bg-emerald-900/40 dark:text-emerald-400">
                                  Aprobada
                                </span>
                              )}
                            </div>
                            {(c?.description || p?.description) && (
                              <p className="mt-0.5 text-xs text-slate-500">
                                {c?.description ?? p?.description}
                              </p>
                            )}
                          </div>

                          {pestana === 'clausulas' ? (
                            <button
                              onClick={() => setAbierta(desplegada ? null : f.id)}
                              className="inline-flex shrink-0 items-center gap-1 text-xs font-medium text-slate-500 transition-colors hover:text-emerald-600"
                            >
                              {desplegada ? <ChevronDown size={14} /> : <ChevronRight size={14} />}
                              Leer
                            </button>
                          ) : (
                            <Link
                              href={`/app/templates/${f.id}/edit`}
                              className="inline-flex shrink-0 items-center gap-1 text-xs font-medium text-slate-500 transition-colors hover:text-emerald-600"
                            >
                              <Pencil size={14} /> Abrir y editar
                            </Link>
                          )}
                        </div>

                        {/* El texto de la cláusula: se lee, y si hace falta se corrige aquí mismo */}
                        {desplegada && c && (
                          <div className="mt-3 ml-7 rounded-lg bg-slate-50 p-4 dark:bg-slate-800/50">
                            <EditorDeClausula clausula={c} />
                          </div>
                        )}
                      </li>
                    )
                  })}
                </ul>
              </section>
            )
          })}
        </div>
      )}
    </div>
  )
}

/**
 * Leer y, si hace falta, corregir una cláusula sin salir de la revisión.
 * Se monta solo cuando se despliega, así que el estado del formulario
 * arranca limpio en cada cláusula y no arrastra el texto de la anterior.
 */
function EditorDeClausula({ clausula }: { clausula: PendienteClausula }) {
  const [editando, setEditando] = useState(false)
  const [titulo, setTitulo] = useState(clausula.title)
  const [descripcion, setDescripcion] = useState(clausula.description ?? '')
  const [cuerpo, setCuerpo] = useState(clausula.body)
  const [base, setBase] = useState(clausula.legal_reference ?? '')
  const [aviso, setAviso] = useState<RevisionResult | null>(null)
  const [guardando, empezar] = useTransition()

  function guardar() {
    setAviso(null)
    empezar(async () => {
      const r = await guardarClausula(clausula.id, {
        title: titulo,
        description: descripcion,
        body: cuerpo,
        legal_reference: base,
      })
      setAviso(r)
      if (r.ok) setEditando(false)
    })
  }

  function cancelar() {
    setTitulo(clausula.title)
    setDescripcion(clausula.description ?? '')
    setCuerpo(clausula.body)
    setBase(clausula.legal_reference ?? '')
    setAviso(null)
    setEditando(false)
  }

  const campo =
    'w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm dark:border-slate-700 dark:bg-slate-900 dark:text-slate-200'

  if (!editando) {
    return (
      <>
        <pre className="whitespace-pre-wrap font-serif text-sm leading-relaxed text-slate-700 dark:text-slate-300">
          {cuerpo}
        </pre>
        {base && (
          <p className="mt-3 border-t border-slate-200 pt-2 text-xs text-slate-500 dark:border-slate-700">
            Base legal: {base}
          </p>
        )}
        {aviso?.ok && <p className="mt-2 text-xs font-medium text-emerald-600">{aviso.notice}</p>}
        <button
          onClick={() => setEditando(true)}
          className="mt-3 inline-flex items-center gap-1 text-xs font-medium text-emerald-600 underline underline-offset-2"
        >
          <Pencil size={13} /> Corregir el texto
        </button>
      </>
    )
  }

  return (
    <div className="space-y-3">
      <div>
        <label className="mb-1 block text-xs font-semibold text-slate-500">Título</label>
        <input value={titulo} onChange={(e) => setTitulo(e.target.value)} className={campo} />
      </div>

      <div>
        <label className="mb-1 block text-xs font-semibold text-slate-500">
          Para qué sirve
        </label>
        <input
          value={descripcion}
          onChange={(e) => setDescripcion(e.target.value)}
          placeholder="Una línea que explique cuándo usarla."
          className={campo}
        />
      </div>

      <div>
        <label className="mb-1 block text-xs font-semibold text-slate-500">Texto</label>
        <textarea
          value={cuerpo}
          onChange={(e) => setCuerpo(e.target.value)}
          rows={12}
          className={campo + ' font-serif leading-relaxed'}
        />
        <p className="mt-1 text-xs text-slate-400">
          Lo que va entre llaves dobles, como {'{{nombre_vendedor}}'}, lo rellena el formulario.
          Conviene no cambiarlo salvo que sepas que esa variable existe.
        </p>
      </div>

      <div>
        <label className="mb-1 block text-xs font-semibold text-slate-500">Base legal</label>
        <input
          value={base}
          onChange={(e) => setBase(e.target.value)}
          placeholder="Art. 1134 del Código Civil, Ley 108-05…"
          className={campo}
        />
      </div>

      {aviso && !aviso.ok && (
        <p className="text-xs font-medium text-red-600">{aviso.error}</p>
      )}

      <div className="flex gap-2">
        <button
          onClick={guardar}
          disabled={guardando}
          className="inline-flex items-center gap-1.5 rounded-lg bg-emerald-600 px-3 py-2 text-sm font-semibold text-white transition-colors hover:bg-emerald-700 disabled:opacity-40"
        >
          {guardando ? <Loader2 size={15} className="animate-spin" /> : <Save size={15} />}
          Guardar
        </button>
        <button
          onClick={cancelar}
          disabled={guardando}
          className="inline-flex items-center gap-1.5 rounded-lg border border-slate-200 px-3 py-2 text-sm font-medium text-slate-600 transition-colors hover:bg-slate-50 disabled:opacity-40 dark:border-slate-700 dark:text-slate-400 dark:hover:bg-slate-800"
        >
          <X size={15} /> Cancelar
        </button>
      </div>
    </div>
  )
}
