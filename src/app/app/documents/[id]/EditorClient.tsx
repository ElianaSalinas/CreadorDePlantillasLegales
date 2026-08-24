'use client'

import { useState, useTransition } from 'react'
import { useRouter } from 'next/navigation'
import { Loader2, Save, Download, FileText, Send, CheckCircle2, Trash2 } from 'lucide-react'
import { saveDocumentContent, updateDocumentStatus, deleteDocument, type SaveResult } from '../actions'

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
}: {
  documentId: string
  initialContent: string
  status: Status
  isOwner: boolean
  canEdit: boolean
  canDelete: boolean
}) {
  const router = useRouter()
  const [content, setContent] = useState(initialContent)
  const [dirty, setDirty] = useState(false)
  const [result, setResult] = useState<SaveResult | null>(null)
  const [pending, startTransition] = useTransition()
  const [downloading, setDownloading] = useState(false)

  function run(fn: () => Promise<SaveResult>, after?: () => void) {
    setResult(null)
    startTransition(async () => {
      const r = await fn()
      setResult(r)
      if (r.ok) after?.()
    })
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

      doc.setFont('times', 'normal')
      doc.setFontSize(12)

      let y = margin
      for (const block of content.split('\n')) {
        const heading = block.trim().length > 0 && block.trim() === block.trim().toUpperCase() && block.trim().length < 90
        doc.setFont('times', heading ? 'bold' : 'normal')

        const lines = doc.splitTextToSize(block || ' ', width)
        for (const line of lines) {
          if (y > height) {
            doc.addPage()
            y = margin
          }
          doc.text(line, margin, y, heading ? { align: 'center', maxWidth: width } : undefined)
          y += 17
        }
        y += 5
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

        <a
          href={`/app/documents/${documentId}/export?format=docx`}
          className="inline-flex items-center gap-2 rounded-lg border border-slate-300 px-4 py-2 text-sm font-medium text-slate-700 transition-colors hover:bg-slate-50 dark:border-slate-700 dark:text-slate-300 dark:hover:bg-slate-800"
        >
          <FileText size={16} /> Word
        </a>

        <button
          onClick={downloadPdf}
          disabled={downloading}
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
