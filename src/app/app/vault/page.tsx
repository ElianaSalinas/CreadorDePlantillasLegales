import PageHeader from '@/components/ui/PageHeader'
import { requireSession } from '@/lib/session'
import VaultClient, { type VaultFile } from './VaultClient'
import { VAULT_BUCKET } from '@/lib/vault'

export const dynamic = 'force-dynamic'

export default async function VaultPage() {
  const { supabase, org, permissions } = await requireSession()

  let files: VaultFile[] = []
  let listError: string | null = null

  if (org) {
    const { data, error } = await supabase.storage
      .from(VAULT_BUCKET)
      .list(org.id, { limit: 1000, sortBy: { column: 'created_at', order: 'desc' } })

    if (error) {
      listError = error.message
    } else {
      files = (data ?? [])
        // Supabase devuelve un placeholder con id null para carpetas vacÃ­as.
        .filter((f) => f.id !== null)
        .map((f) => ({
          path: `${org.id}/${f.name}`,
          displayName: f.name.includes('__') ? f.name.split('__').slice(1).join('__') : f.name,
          size: (f.metadata as any)?.size ?? 0,
          createdAt: f.created_at ?? null,
        }))
    }
  }

  return (
    <div className="mx-auto max-w-5xl">
      <PageHeader
        title="BÃ³veda"
        subtitle="Tus documentos finales, guardados de forma privada y accesibles solo para tu despacho."
      />

      {listError && (
        <p className="mb-4 rounded-lg bg-amber-50 p-4 text-sm text-amber-800 dark:bg-amber-900/20 dark:text-amber-300">
          No se pudo leer la bÃ³veda: {listError}. Si es la primera vez, verifica que la migraciÃ³n{' '}
          <code>20260822000001_vault_storage_bucket.sql</code> ya se ejecutÃ³ en Supabase.
        </p>
      )}

      <VaultClient
        files={files}
        used={files.length}
        limit={org?.vault_limit ?? 30}
        canWrite={permissions.vault}
        canDelete={permissions.delete}
      />
    </div>
  )
}
