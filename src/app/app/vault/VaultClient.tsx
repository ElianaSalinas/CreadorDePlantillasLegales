'use client'

import { useRef, useState, useTransition } from 'react'
import { Upload, Download, Trash2, FileText, Loader2, ShieldCheck, Lock, Users } from 'lucide-react'
import EmptyState from '@/components/ui/EmptyState'
import {
  uploadToVault,
  deleteFromVault,
  getVaultDownloadUrl,
  cambiarVisibilidadArchivo,
} from './actions'

export type VaultFile = {
  path: string
  displayName: string
  size: number
  createdAt: string | null
  /** Lo subí yo, así que puedo decidir con quién se comparte. */
  esMio: boolean
  compartido: boolean
  /** Anterior a la bóveda privada: se comporta como siempre. */
  sinFicha: boolean
}

export default function VaultClient({
  files,
  used,
  limit,
  canWrite,
  canDelete,
  soyTitular = false,
}: {
  files: VaultFile[]
  used: number
  limit: number
  canWrite: boolean
  canDelete: boolean
  soyTitular?: boolean
}) {
  const [error, setError] = useState<string | null>(null)
  const [busyPath, setBusyPath] = useState<string | null>(null)
  const [pending, startTransition] = useTransition()
  const inputRef = useRef<HTMLInputElement>(null)

  const full = used >= limit
  const pct = limit > 0 ? Math.min(100, Math.round((used / limit) * 100)) : 0

  function handleCompartir(file: VaultFile) {
    setError(null)
    setBusyPath(file.path)
    startTransition(async () => {
      const r = await cambiarVisibilidadArchivo(file.path, !file.compartido)
      if (!r.ok) setError(r.error ?? 'No se pudo cambiar quién ve el archivo.')
      setBusyPath(null)
    })
  }

  function handleFileChosen(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0]
    if (!file) return
    setError(null)
    const formData = new FormData()
    formData.set('file', file)
    startTransition(async () => {
      const result = await uploadToVault(formData)
      if (!result.ok) setError(result.error ?? 'No se pudo subir el archivo.')
      if (inputRef.current) inputRef.current.value = ''
    })
  }

  function handleDownload(file: VaultFile) {
    setError(null)
    setBusyPath(file.path)
    startTransition(async () => {
      const result = await getVaultDownloadUrl(file.path)
      setBusyPath(null)
      if (result.ok && result.url) window.open(result.url, '_blank', 'noopener')
      else setError(result.error ?? 'No se pudo generar el enlace de descarga.')
    })
  }

  function handleDelete(file: VaultFile) {
    if (!confirm(`¿Eliminar "${file.displayName}" de la bóveda? Esta acción no se puede deshacer.`))
      return
    setError(null)
    setBusyPath(file.path)
    startTransition(async () => {
      const result = await deleteFromVault(file.path)
      setBusyPath(null)
      if (!result.ok) setError(result.error ?? 'No se pudo eliminar el documento.')
    })
  }

  return (
    <div>
      <div className="mb-6 rounded-xl border border-slate-200 bg-white p-5 dark:border-slate-800 dark:bg-slate-900">
        <div className="flex flex-wrap items-center justify-between gap-4">
          <div className="flex items-start gap-3">
            <span className="mt-0.5 rounded-lg bg-emerald-50 p-2 text-emerald-600 dark:bg-emerald-900/20">
              <ShieldCheck size={18} />
            </span>
            <div>
              <p className="font-semibold text-slate-900 dark:text-white">
                {used} de {limit} documentos
              </p>
              <p className="text-sm text-slate-500">
                Almacenamiento cifrado y privado. Solo tu despacho puede abrir estos archivos.
              </p>
            </div>
          </div>

          {canWrite && (
            <div>
              <input
                ref={inputRef}
                id="vault-file"
                type="file"
                accept=".pdf,.doc,.docx,application/pdf,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document"
                onChange={handleFileChosen}
                disabled={pending || full}
                className="sr-only"
              />
              <label
                htmlFor="vault-file"
                aria-disabled={pending || full}
                className={
                  pending || full
                    ? 'inline-flex cursor-not-allowed items-center gap-2 rounded-lg bg-slate-200 px-4 py-2 font-semibold text-slate-500 dark:bg-slate-800'
                    : 'inline-flex cursor-pointer items-center gap-2 rounded-lg bg-emerald-600 px-4 py-2 font-semibold text-white transition-colors hover:bg-emerald-700'
                }
              >
                {pending ? <Loader2 size={18} className="animate-spin" /> : <Upload size={18} />}
                {pending ? 'Subiendo…' : full ? 'Bóveda llena' : 'Subir documento'}
              </label>
            </div>
          )}
        </div>

        <div
          className="mt-4 h-2 w-full overflow-hidden rounded-full bg-slate-100 dark:bg-slate-800"
          role="progressbar"
          aria-valuenow={used}
          aria-valuemin={0}
          aria-valuemax={limit}
          aria-label="Uso de la bóveda"
        >
          <div
            className={pct >= 90 ? 'h-full bg-red-500' : pct >= 70 ? 'h-full bg-amber-500' : 'h-full bg-emerald-500'}
            style={{ width: `${pct}%` }}
          />
        </div>
      </div>

      {error && (
        <p className="mb-4 rounded-lg bg-red-50 p-3 text-sm text-red-600 dark:bg-red-900/20">{error}</p>
      )}

      {files.length === 0 ? (
        <EmptyState
          title="Tu bóveda está vacía"
          description="Sube los PDF o documentos de Word que quieras conservar de forma segura. Solo se aceptan archivos de hasta 25 MB."
        />
      ) : (
        <div className="overflow-hidden rounded-xl border border-slate-200 bg-white dark:border-slate-800 dark:bg-slate-900">
          <table className="w-full text-left text-sm">
            <thead className="border-b border-slate-200 bg-slate-50 text-xs uppercase tracking-wide text-slate-500 dark:border-slate-800 dark:bg-slate-800/50">
              <tr>
                <th className="px-5 py-3 font-semibold">Documento</th>
                <th className="hidden px-5 py-3 font-semibold sm:table-cell">Tamaño</th>
                <th className="hidden px-5 py-3 font-semibold md:table-cell">Subido</th>
                <th className="px-5 py-3 text-right font-semibold">Acciones</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 dark:divide-slate-800">
              {files.map((file) => (
                <tr key={file.path}>
                  <td className="px-5 py-3">
                    <div className="flex items-center gap-3">
                      <FileText size={16} className="shrink-0 text-slate-400" />
                      <span
                        className="truncate font-medium text-slate-900 dark:text-white"
                        title={file.displayName}
                      >
                        {file.displayName}
                      </span>
                      <VisibilidadDelArchivo file={file} soyTitular={soyTitular} />
                    </div>
                  </td>
                  <td className="hidden whitespace-nowrap px-5 py-3 text-slate-500 sm:table-cell">
                    {formatSize(file.size)}
                  </td>
                  <td className="hidden whitespace-nowrap px-5 py-3 text-slate-500 md:table-cell">
                    {formatDate(file.createdAt)}
                  </td>
                  <td className="px-5 py-3">
                    <div className="flex justify-end gap-1">
                      {file.esMio && !file.sinFicha && (
                        <button
                          onClick={() => handleCompartir(file)}
                          disabled={busyPath === file.path}
                          title={
                            file.compartido
                              ? 'Dejar de compartir con el despacho'
                              : 'Compartir con el despacho'
                          }
                          aria-label={
                            file.compartido
                              ? `Dejar de compartir ${file.displayName} con el despacho`
                              : `Compartir ${file.displayName} con el despacho`
                          }
                          className={
                            file.compartido
                              ? 'rounded-md p-2 text-emerald-600 transition-colors hover:bg-emerald-50 disabled:opacity-50 dark:hover:bg-emerald-900/20'
                              : 'rounded-md p-2 text-slate-500 transition-colors hover:bg-slate-100 hover:text-emerald-600 disabled:opacity-50 dark:hover:bg-slate-800'
                          }
                        >
                          {file.compartido ? <Users size={16} /> : <Lock size={16} />}
                        </button>
                      )}
                      <button
                        onClick={() => handleDownload(file)}
                        disabled={busyPath === file.path}
                        title="Descargar"
                        aria-label={`Descargar ${file.displayName}`}
                        className="rounded-md p-2 text-slate-500 transition-colors hover:bg-slate-100 hover:text-emerald-600 disabled:opacity-50 dark:hover:bg-slate-800"
                      >
                        {busyPath === file.path && pending ? (
                          <Loader2 size={16} className="animate-spin" />
                        ) : (
                          <Download size={16} />
                        )}
                      </button>
                      {canDelete && (
                        <button
                          onClick={() => handleDelete(file)}
                          disabled={busyPath === file.path}
                          title="Eliminar"
                          aria-label={`Eliminar ${file.displayName}`}
                          className="rounded-md p-2 text-slate-500 transition-colors hover:bg-red-50 hover:text-red-600 disabled:opacity-50 dark:hover:bg-red-900/20"
                        >
                          <Trash2 size={16} />
                        </button>
                      )}
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}

function formatSize(bytes: number) {
  if (!bytes) return '—'
  if (bytes < 1024) return `${bytes} B`
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(0)} KB`
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`
}

function formatDate(iso: string | null) {
  if (!iso) return '—'
  try {
    return new Date(iso).toLocaleDateString('es-DO', {
      day: '2-digit',
      month: 'short',
      year: 'numeric',
    })
  } catch {
    return '—'
  }
}

/**
 * Con quién se ve este archivo.
 *
 * Nunca pone "Privado" a secas: el titular del despacho es la excepción y
 * sí lo ve, así que decirlo a secas prometería más de lo que el sistema
 * cumple. Quien lo subió lee "Solo tú y el titular", que es exactamente
 * lo que pasa.
 */
function VisibilidadDelArchivo({
  file,
  soyTitular,
}: {
  file: VaultFile
  soyTitular: boolean
}) {
  if (file.sinFicha) return null

  const base =
    'inline-flex shrink-0 items-center gap-1 rounded-full px-2 py-0.5 text-[10px] font-bold uppercase tracking-wide'

  if (file.compartido) {
    return (
      <span className={`${base} bg-emerald-50 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400`}>
        <Users size={11} /> Todo el despacho
      </span>
    )
  }

  return (
    <span className={`${base} bg-slate-100 text-slate-600 dark:bg-slate-800 dark:text-slate-400`}>
      <Lock size={11} />
      {file.esMio ? 'Solo tú y el titular' : soyTitular ? 'Privado de su autor' : 'Privado'}
    </span>
  )
}
