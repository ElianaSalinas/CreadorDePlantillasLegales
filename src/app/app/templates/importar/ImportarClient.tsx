'use client'

import { useMemo, useRef, useState, useTransition } from 'react'
import { useRouter } from 'next/navigation'
import { Upload, Loader2, Wand2, FileText, ArrowRight, Check } from 'lucide-react'
import {
  analizarDocumento,
  crearPlantillaDesdeTexto,
  type EleccionConfirmada,
} from './actions'
import { ETIQUETA_TIPO, type Candidato } from '@/lib/engine/import'

type Paso = 'subir' | 'revisar'

/** Lo que la persona decide sobre cada candidato. */
type Decision = {
  confirmado: boolean
  etiqueta: string
  pregunta: string
}

const COLOR_CONFIANZA: Record<Candidato['confianza'], string> = {
  alta: 'bg-emerald-50 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400',
  media: 'bg-amber-50 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400',
  baja: 'bg-slate-100 text-slate-600 dark:bg-slate-800 dark:text-slate-400',
}

const TEXTO_CONFIANZA: Record<Candidato['confianza'], string> = {
  alta: 'Muy probable',
  media: 'Probable',
  baja: 'Quizá',
}

export default function ImportarClient({
  categorias,
}: {
  categorias: { id: string; name: string }[]
}) {
  const router = useRouter()
  const [paso, setPaso] = useState<Paso>('subir')
  const [error, setError] = useState<string | null>(null)
  const [pendiente, empezar] = useTransition()

  const [texto, setTexto] = useState('')
  const [pegado, setPegado] = useState('')
  const [candidatos, setCandidatos] = useState<Candidato[]>([])
  const [decisiones, setDecisiones] = useState<Record<string, Decision>>({})

  const [titulo, setTitulo] = useState('')
  const [descripcion, setDescripcion] = useState('')
  const [categoriaId, setCategoriaId] = useState('')

  const archivoRef = useRef<HTMLInputElement>(null)

  const confirmadas = useMemo(
    () => candidatos.filter((c) => decisiones[c.id]?.confirmado),
    [candidatos, decisiones]
  )

  /* ── Paso 1 ── */

  function analizar(formData: FormData) {
    setError(null)
    empezar(async () => {
      const r = await analizarDocumento(formData)
      if (!r.ok || !r.texto) {
        setError(r.error ?? 'No se pudo leer el documento.')
        return
      }
      setTexto(r.texto)
      setCandidatos(r.candidatos ?? [])

      // Las de confianza alta vienen marcadas; las demás no. Marcar todo
      // sería decidir por la persona, que es justo lo que no queremos.
      const iniciales: Record<string, Decision> = {}
      for (const c of r.candidatos ?? []) {
        iniciales[c.id] = {
          confirmado: c.confianza === 'alta',
          etiqueta: c.variableExistente ?? c.etiquetaSugerida,
          pregunta: '',
        }
      }
      setDecisiones(iniciales)
      setPaso('revisar')
    })
  }

  function alElegirArchivo(e: React.ChangeEvent<HTMLInputElement>) {
    const f = e.target.files?.[0]
    if (!f) return
    const fd = new FormData()
    fd.set('file', f)
    analizar(fd)
    if (archivoRef.current) archivoRef.current.value = ''
  }

  /* ── Paso 2 ── */

  function cambiar(id: string, cambio: Partial<Decision>) {
    setDecisiones((d) => ({ ...d, [id]: { ...d[id], ...cambio } }))
  }

  function crear() {
    setError(null)

    const elecciones: EleccionConfirmada[] = confirmadas.map((c) => ({
      valor: c.valor,
      etiqueta: decisiones[c.id].etiqueta.trim(),
      tipo: c.tipo,
      pregunta: decisiones[c.id].pregunta,
    }))

    const sinNombre = elecciones.find((e) => !/^[a-z][a-z0-9_]*$/.test(e.etiqueta))
    if (sinNombre) {
      setError(
        `"${sinNombre.etiqueta}" no vale como nombre de variable. Usa minúsculas, números y guiones bajos, empezando por letra.`
      )
      return
    }

    empezar(async () => {
      const r = await crearPlantillaDesdeTexto(texto, elecciones, {
        titulo,
        descripcion,
        categoriaId: categoriaId || null,
      })
      if (!r.ok) {
        setError(r.error ?? 'No se pudo crear la plantilla.')
        return
      }
      router.push(`/app/templates/${r.templateId}/edit`)
    })
  }

  const campo =
    'w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm dark:border-slate-800 dark:bg-slate-900 dark:text-slate-200'

  /* ══════════════ PASO 1 ══════════════ */

  if (paso === 'subir') {
    return (
      <div className="space-y-6">
        {error && (
          <p className="rounded-lg border border-red-200 bg-red-50 p-3 text-sm text-red-700 dark:border-red-800 dark:bg-red-900/20 dark:text-red-300">
            {error}
          </p>
        )}

        <div className="rounded-xl border border-slate-200 bg-white p-8 text-center dark:border-slate-800 dark:bg-slate-900">
          <span className="inline-flex rounded-xl bg-emerald-50 p-3 text-emerald-600 dark:bg-emerald-900/20">
            <Upload size={22} />
          </span>
          <h2 className="mt-4 font-bold text-slate-900 dark:text-white">Sube el documento</h2>
          <p className="mx-auto mt-1 max-w-md text-sm text-slate-500">
            Un archivo de Word (.docx) con el contrato que ya usas. No se guarda: solo se lee para
            proponerte las variables.
          </p>

          <input
            ref={archivoRef}
            type="file"
            accept=".docx,application/vnd.openxmlformats-officedocument.wordprocessingml.document"
            onChange={alElegirArchivo}
            className="hidden"
            id="archivo"
          />
          <label
            htmlFor="archivo"
            className="mt-5 inline-flex cursor-pointer items-center gap-2 rounded-lg bg-emerald-600 px-5 py-2.5 text-sm font-semibold text-white transition-colors hover:bg-emerald-700"
          >
            {pendiente ? <Loader2 size={16} className="animate-spin" /> : <Upload size={16} />}
            Elegir archivo
          </label>
        </div>

        <div className="rounded-xl border border-slate-200 bg-white p-6 dark:border-slate-800 dark:bg-slate-900">
          <h2 className="font-bold text-slate-900 dark:text-white">O pega el texto</h2>
          <p className="mt-1 text-sm text-slate-500">
            Si tu contrato está en PDF o en otro sitio, cópialo y pégalo aquí.
          </p>
          <textarea
            value={pegado}
            onChange={(e) => setPegado(e.target.value)}
            rows={8}
            placeholder="Pega aquí el texto completo del contrato…"
            className={campo + ' mt-3 font-serif leading-relaxed'}
          />
          <button
            onClick={() => {
              const fd = new FormData()
              fd.set('texto', pegado)
              analizar(fd)
            }}
            disabled={pendiente || pegado.trim().length < 80}
            className="mt-3 inline-flex items-center gap-2 rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white transition-colors hover:bg-emerald-700 disabled:opacity-40"
          >
            {pendiente ? <Loader2 size={16} className="animate-spin" /> : <Wand2 size={16} />}
            Analizar el texto
          </button>
        </div>
      </div>
    )
  }

  /* ══════════════ PASO 2 ══════════════ */

  return (
    <div className="space-y-6">
      {error && (
        <p className="rounded-lg border border-red-200 bg-red-50 p-3 text-sm text-red-700 dark:border-red-800 dark:bg-red-900/20 dark:text-red-300">
          {error}
        </p>
      )}

      <div className="rounded-xl border border-slate-200 bg-white p-5 dark:border-slate-800 dark:bg-slate-900">
        <h2 className="font-bold text-slate-900 dark:text-white">
          {candidatos.length === 0
            ? 'No encontré nada que proponerte'
            : `Encontré ${candidatos.length} cosas que podrían ser variables`}
        </h2>
        <p className="mt-1 text-sm text-slate-500">
          Marca las que de verdad cambian de un caso a otro. Lo que no marques se queda como texto
          fijo en la plantilla.
        </p>
      </div>

      {candidatos.length > 0 && (
        <ul className="divide-y divide-slate-100 overflow-hidden rounded-xl border border-slate-200 bg-white dark:divide-slate-800 dark:border-slate-800 dark:bg-slate-900">
          {candidatos.map((c) => {
            const d = decisiones[c.id]
            return (
              <li key={c.id} className="p-4">
                <div className="flex items-start gap-3">
                  <input
                    type="checkbox"
                    checked={d?.confirmado ?? false}
                    onChange={(e) => cambiar(c.id, { confirmado: e.target.checked })}
                    aria-label={`Convertir "${c.valor}" en variable`}
                    className="mt-1 h-4 w-4 shrink-0 rounded border-slate-300 text-emerald-600"
                  />

                  <div className="min-w-0 flex-1">
                    <div className="flex flex-wrap items-center gap-2">
                      <code className="rounded bg-slate-100 px-1.5 py-0.5 text-sm text-slate-800 dark:bg-slate-800 dark:text-slate-200">
                        {c.valor}
                      </code>
                      <span className="text-xs text-slate-400">
                        {ETIQUETA_TIPO[c.tipo]} · {c.ocurrencias === 1 ? '1 vez' : `${c.ocurrencias} veces`}
                      </span>
                      <span
                        className={`rounded-full px-2 py-0.5 text-[10px] font-bold uppercase ${COLOR_CONFIANZA[c.confianza]}`}
                      >
                        {TEXTO_CONFIANZA[c.confianza]}
                      </span>
                    </div>

                    <p className="mt-1 text-xs text-slate-500">{c.motivo}</p>

                    {d?.confirmado && (
                      <div className="mt-3 grid gap-2 sm:grid-cols-2">
                        <div>
                          <label className="mb-1 block text-xs font-semibold text-slate-500">
                            Nombre de la variable
                          </label>
                          <input
                            value={d.etiqueta}
                            onChange={(e) => cambiar(c.id, { etiqueta: e.target.value })}
                            className={campo + ' font-mono text-xs'}
                          />
                          {c.variableExistente && d.etiqueta === c.variableExistente && (
                            <p className="mt-1 text-[11px] text-emerald-600">
                              Reutiliza una variable que ya existe. Mejor así: el diccionario no se
                              llena de nombres distintos para lo mismo.
                            </p>
                          )}
                        </div>
                        <div>
                          <label className="mb-1 block text-xs font-semibold text-slate-500">
                            Qué se le pregunta a quien rellene
                          </label>
                          <input
                            value={d.pregunta}
                            onChange={(e) => cambiar(c.id, { pregunta: e.target.value })}
                            placeholder="¿Quién es el arrendatario?"
                            className={campo + ' text-xs'}
                          />
                        </div>
                      </div>
                    )}
                  </div>
                </div>
              </li>
            )
          })}
        </ul>
      )}

      <div className="rounded-xl border border-slate-200 bg-white p-5 dark:border-slate-800 dark:bg-slate-900">
        <h2 className="mb-4 font-bold text-slate-900 dark:text-white">Datos de la plantilla</h2>
        <div className="grid gap-4 sm:grid-cols-2">
          <div>
            <label htmlFor="titulo" className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
              Nombre
            </label>
            <input
              id="titulo"
              value={titulo}
              onChange={(e) => setTitulo(e.target.value)}
              placeholder="Contrato de alquiler de vivienda"
              className={campo}
            />
          </div>
          <div>
            <label htmlFor="categoria" className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
              Categoría
            </label>
            <select
              id="categoria"
              value={categoriaId}
              onChange={(e) => setCategoriaId(e.target.value)}
              className={campo}
            >
              <option value="">Sin categoría</option>
              {categorias.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.name}
                </option>
              ))}
            </select>
          </div>
          <div className="sm:col-span-2">
            <label htmlFor="descripcion" className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
              Para qué sirve
            </label>
            <input
              id="descripcion"
              value={descripcion}
              onChange={(e) => setDescripcion(e.target.value)}
              placeholder="Una línea que explique cuándo usarla."
              className={campo}
            />
          </div>
        </div>
      </div>

      <div className="flex flex-wrap items-center gap-3">
        <button
          onClick={crear}
          disabled={pendiente || confirmadas.length === 0 || !titulo.trim()}
          className="inline-flex items-center gap-2 rounded-lg bg-emerald-600 px-5 py-2.5 text-sm font-semibold text-white transition-colors hover:bg-emerald-700 disabled:opacity-40"
        >
          {pendiente ? <Loader2 size={16} className="animate-spin" /> : <Check size={16} />}
          Crear la plantilla con {confirmadas.length}{' '}
          {confirmadas.length === 1 ? 'variable' : 'variables'}
        </button>

        <button
          onClick={() => {
            setPaso('subir')
            setError(null)
          }}
          className="text-sm text-slate-500 underline underline-offset-2"
        >
          Empezar de nuevo con otro documento
        </button>
      </div>

      <details className="rounded-xl border border-slate-200 bg-white p-5 dark:border-slate-800 dark:bg-slate-900">
        <summary className="cursor-pointer text-sm font-semibold text-slate-700 dark:text-slate-300">
          <FileText size={15} className="mr-1.5 inline" />
          Ver el texto que se leyó
        </summary>
        <pre className="mt-4 max-h-96 overflow-auto whitespace-pre-wrap rounded-lg bg-slate-50 p-4 font-serif text-sm leading-relaxed text-slate-700 dark:bg-slate-800/50 dark:text-slate-300">
          {texto}
        </pre>
      </details>
    </div>
  )
}
