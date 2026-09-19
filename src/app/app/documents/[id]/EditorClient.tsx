'use client'

import { useState, useTransition } from 'react'
import { useRouter } from 'next/navigation'
import { Loader2, Save, Download, FileText, Send, CheckCircle2, Trash2, Copy, CheckCheck } from 'lucide-react'
import { saveDocumentContent, updateDocumentStatus, deleteDocument, type SaveResult } from '../actions'
import { computeBoldRanges, type BoldRange } from '@/lib/engine/variables'
import type { Variable } from '@/lib/engine/types'

type Status = 'DRAFT' | 'IN_REVIEW' | 'APPROVED' | 'FINAL'

const STATUS_LABEL: Record<Status, string> = {
  DRAFT: 'Borrador',
  IN_REVIEW: 'En revisión',
  APPROVED: 'Aprobado',
  FINAL: 'Final',
}

export default function EditorClient({
  documentId,
  initialContent,
  status,
  isOwner,
  canEdit,
  canDelete,
  dataPayload,
  templateVariables,
}: {
  documentId: string
  initialContent: string
  status: Status
  isOwner: boolean
  canEdit: boolean
  canDelete: boolean
  /** Las respuestas del formulario, para saber qué poner en negrita al exportar. */
  dataPayload: Record<string, unknown>
  /** Las variables congeladas de la plantilla en el momento de generar. */
  templateVariables: Variable[]
}) {
  const router = useRouter()
  const [content, setContent] = useState(initialContent)
  const [dirty, setDirty] = useState(false)
  const [result, setResult] = useState<SaveResult | null>(null)
  const [pending, startTransition] = useTransition()
  const [downloading, setDownloading] = useState(false)
  const [copied, setCopied] = useState(false)

  function run(fn: () => Promise<SaveResult>, after?: () => void) {
    setResult(null)
    startTransition(async () => {
      const r = await fn()
      setResult(r)
      if (r.ok) after?.()
    })
  }

  async function copiar() {
    try {
      await navigator.clipboard.writeText(content)
      setCopied(true)
      setTimeout(() => setCopied(false), 2000)
    } catch {
      setResult({ ok: false, error: 'No se pudo copiar. Selecciona el texto a mano.' })
    }
  }

  /**
   * Parte una línea de texto en tramos {texto, negrita}, con las mismas
   * coordenadas de negrita que usa el Word (ver src/lib/engine/export.ts).
   * jsPDF no soporta negrita parcial dentro de una sola llamada a
   * `text()`, así que cada tramo se dibuja por separado, avanzando la
   * posición horizontal según el ancho real que ocupó el tramo anterior.
   */
  function partirEnTramos(line: string, rangos: BoldRange[]): { texto: string; negrita: boolean }[] {
    if (rangos.length === 0) return [{ texto: line, negrita: false }]
    const tramos: { texto: string; negrita: boolean }[] = []
    let cursor = 0
    for (const r of rangos) {
      if (r.start > cursor) tramos.push({ texto: line.slice(cursor, r.start), negrita: false })
      tramos.push({ texto: line.slice(r.start, r.end), negrita: true })
      cursor = r.end
    }
    if (cursor < line.length) tramos.push({ texto: line.slice(cursor), negrita: false })
    return tramos.filter((t) => t.texto.length > 0)
  }

  async function downloadPdf() {
    setDownloading(true)
    try {
      // jsPDF se carga solo al pulsar, para no cargarlo en cada visita.
      const { jsPDF } = await import('jspdf')
      const doc = new jsPDF({ unit: 'pt', format: 'letter' })

      const margin = 72
      const width = doc.internal.pageSize.getWidth() - margin * 2
      const height = doc.internal.pageSize.getHeight() - margin
      const lineHeight = 17

      const boldRanges =
        templateVariables.length > 0 ? computeBoldRanges(content, templateVariables, dataPayload) : []

      let y = margin
      let offset = 0

      for (const block of content.split('\n')) {
        const heading = block.trim().length > 0 && block.trim() === block.trim().toUpperCase() && block.trim().length < 90

        const rangosDeEsteBlock = boldRanges
          .map((r) => ({ start: r.start - offset, end: r.end - offset }))
          .filter((r) => r.end > 0 && r.start < block.length)
          .map((r) => ({ start: Math.max(0, r.start), end: Math.min(block.length, r.end) }))

        if (heading) {
          // Los títulos van siempre en negrita y centrados, igual que en
          // el Word: no hace falta partirlos en tramos.
          doc.setFont('times', 'bold')
          const lines = doc.splitTextToSize(block || ' ', width)
          for (const line of lines) {
            if (y > height) {
              doc.addPage()
              y = margin
            }
            doc.text(line, margin, y, { align: 'center', maxWidth: width })
            y += lineHeight
          }
        } else {
          // Envuelve el párrafo palabra por palabra, respetando qué
          // tramos van en negrita, y dibuja cada renglón ya envuelto
          // tramo por tramo, avanzando el cursor horizontal con el
          // ancho real que mide cada uno (negrita y normal no miden
          // igual el mismo texto).
          const tramos = partirEnTramos(block || ' ', rangosDeEsteBlock)
          const renglones: { texto: string; negrita: boolean }[][] = [[]]
          let anchoRenglon = 0

          for (const tramo of tramos) {
            const palabras = tramo.texto.split(/(\s+)/).filter((p) => p.length > 0)
            for (const palabra of palabras) {
              doc.setFont('times', tramo.negrita ? 'bold' : 'normal')
              const anchoPalabra = doc.getTextWidth(palabra)
              const esSoloEspacio = /^\s+$/.test(palabra)

              if (anchoRenglon + anchoPalabra > width && renglones[renglones.length - 1].length > 0) {
                renglones.push([])
                anchoRenglon = 0
                if (esSoloEspacio) continue
              }

              renglones[renglones.length - 1].push({ texto: palabra, negrita: tramo.negrita })
              anchoRenglon += anchoPalabra
            }
          }

          for (const renglon of renglones) {
            if (y > height) {
              doc.addPage()
              y = margin
            }
            let x = margin
            for (const pieza of renglon) {
              doc.setFont('times', pieza.negrita ? 'bold' : 'normal')
              doc.text(pieza.texto, x, y)
              x += doc.getTextWidth(pieza.texto)
            }
            y += lineHeight
          }
        }

        y += 5
        offset += block.length + 1 // +1 por el '\n' que split() ya quitó
      }

      doc.save('documento.pdf')
    } catch (err) {
      setResult({ ok: false, error: 'No se pudo generar el PDF.' })
    } finally {
      setDownloading(false)
    }
  }

  return (
    <div className="space-y-4">
      <div className="flex flex-wrap items-center gap-2">
        {canEdit && (
          <button
            onClick={() => run(() => saveDocumentContent(documentId, content), () => setDirty(false))}
            disabled={pending || !dirty}
            className="inline-flex items-center gap-2 rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white transition-colors hover:bg-emerald-700 disabled:opacity-50"
          >
            {pending ? <Loader2 size={16} className="animate-spin" /> : <Save size={16} />}
            {dirty ? 'Guardar cambios' : 'Guardado'}
          </button>
        )}

        <button
          onClick={copiar}
          className="inline-flex items-center gap-2 rounded-lg border border-slate-300 px-4 py-2 text-sm font-medium text-slate-700 transition-colors hover:bg-slate-50 dark:border-slate-700 dark:text-slate-300 dark:hover:bg-slate-800"
        >
          {copied ? <CheckCheck size={16} className="text-emerald-600" /> : <Copy size={16} />}
          {copied ? 'Copiado' : 'Copiar'}
        </button>

        <a
          href={`/app/documents/${documentId}/export?format=docx`}
          data-analitica="document_download"
          data-analitica-etiqueta="docx"
          className="inline-flex items-center gap-2 rounded-lg border border-slate-300 px-4 py-2 text-sm font-medium text-slate-700 transition-colors hover:bg-slate-50 dark:border-slate-700 dark:text-slate-300 dark:hover:bg-slate-800"
        >
          <FileText size={16} /> Word
        </a>

        <button
          onClick={downloadPdf}
          disabled={downloading}
          data-analitica="document_download"
          data-analitica-etiqueta="pdf"
          className="inline-flex items-center gap-2 rounded-lg border border-slate-300 px-4 py-2 text-sm font-medium text-slate-700 transition-colors hover:bg-slate-50 disabled:opacity-50 dark:border-slate-700 dark:text-slate-300 dark:hover:bg-slate-800"
        >
          {downloading ? <Loader2 size={16} className="animate-spin" /> : <Download size={16} />} PDF
        </button>

        <span className="flex-1" />

        {status === 'DRAFT' && canEdit && (
          <button
            onClick={() => run(() => updateDocumentStatus(documentId, 'IN_REVIEW'), () => router.refresh())}
            disabled={pending}
            className="inline-flex items-center gap-2 rounded-lg border border-amber-300 px-4 py-2 text-sm font-medium text-amber-700 transition-colors hover:bg-amber-50 disabled:opacity-50 dark:border-amber-700 dark:text-amber-400 dark:hover:bg-amber-900/20"
          >
            <Send size={16} /> Enviar a revisión
          </button>
        )}

        {(status === 'IN_REVIEW' || status === 'APPROVED') && isOwner && (
          <button
            onClick={() =>
              run(() => updateDocumentStatus(documentId, status === 'IN_REVIEW' ? 'APPROVED' : 'FINAL'), () => router.refresh())
            }
            disabled={pending}
            className="inline-flex items-center gap-2 rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white transition-colors hover:bg-emerald-700 disabled:opacity-50"
          >
            <CheckCircle2 size={16} />
            {status === 'IN_REVIEW' ? 'Aprobar' : 'Marcar como final'}
          </button>
        )}

        {canDelete && (
          <button
            onClick={() => {
              if (confirm('¿Eliminar este documento? No se puede deshacer.')) {
                run(() => deleteDocument(documentId), () => router.push('/app/documents'))
              }
            }}
            disabled={pending}
            title="Eliminar"
            className="rounded-lg p-2 text-slate-400 transition-colors hover:bg-red-50 hover:text-red-600 disabled:opacity-50 dark:hover:bg-red-900/20"
          >
            <Trash2 size={16} />
          </button>
        )}
      </div>

      {result && (
        <p
          className={
            result.ok
              ? 'rounded-lg bg-emerald-50 p-3 text-sm text-emerald-700 dark:bg-emerald-900/20 dark:text-emerald-400'
              : 'rounded-lg bg-red-50 p-3 text-sm text-red-600 dark:bg-red-900/20'
          }
        >
          {result.ok ? result.notice : result.error}
        </p>
      )}

      {status === 'FINAL' && (
        <p className="rounded-lg bg-slate-100 p-3 text-sm text-slate-600 dark:bg-slate-800 dark:text-slate-300">
          Este documento está marcado como final. Sigue siendo editable, pero cada cambio queda
          registrado en la auditoría del despacho.
        </p>
      )}

      <textarea
        value={content}
        readOnly={!canEdit}
        onChange={(e) => {
          setContent(e.target.value)
          setDirty(true)
        }}
        rows={34}
        spellCheck
        className="w-full resize-y rounded-xl border border-slate-200 bg-white p-8 font-serif text-[15px] leading-relaxed text-slate-800 outline-none focus:ring-2 focus:ring-emerald-500 dark:border-slate-800 dark:bg-slate-900 dark:text-slate-200"
      />
    </div>
  )
}
