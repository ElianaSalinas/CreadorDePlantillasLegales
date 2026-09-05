import PageHeader from '@/components/ui/PageHeader'
import { requireSession } from '@/lib/session'
import VaultClient, { type VaultFile } from './VaultClient'
import { VAULT_BUCKET } from '@/lib/vault'

export const dynamic = 'force-dynamic'

export default async function VaultPage() {
  const { supabase, user, org, permissions } = await requireSession()

  let files: VaultFile[] = []
  let listError: string | null = null

  if (org) {
    const { data, error } = await supabase.storage
      .from(VAULT_BUCKET)
      .list(org.id, { limit: 1000, sortBy: { column: 'created_at', order: 'desc' } })

    if (error) {
      listError = error.message
    } else {
      // Las fichas dicen de quién es cada archivo y si está compartido.
      // Storage no guarda eso, y las políticas ya se encargan de que aquí
      // solo lleguen los que esta persona puede ver.
      const { data: fichas } = await supabase
        .from('boveda_archivos')
        .select('ruta, subido_por, visible_para_despacho')
        .eq('org_id', org.id)

      const porRuta = new Map(
        (fichas ?? []).map((f: any) => [f.ruta as string, f])
      )

      files = (data ?? [])
        // Supabase devuelve un placeholder con id null para carpetas vacías.
        .filter((f) => f.id !== null)
        .map((f) => {
          const path = `${org.id}/${f.name}`
          const ficha = porRuta.get(path)
          return {
            path,
            displayName: f.name.includes('__') ? f.name.split('__').slice(1).join('__') : f.name,
            size: (f.metadata as any)?.size ?? 0,
            createdAt: f.created_at ?? null,
            esMio: ficha ? ficha.subido_por === user.id : false,
            compartido: ficha ? Boolean(ficha.visible_para_despacho) : true,
            sinFicha: !ficha,
          }
        })
    }
  }

  return (
    <div className="mx-auto max-w-5xl">
      <PageHeader
        title="Bóveda"
        subtitle="Cada archivo que subes es privado. Lo ves tú y el titular del despacho, y tú decides si lo compartes con el resto."
      />

      {listError && (
        <p className="mb-4 rounded-lg bg-amber-50 p-4 text-sm text-amber-800 dark:bg-amber-900/20 dark:text-amber-300">
          No se pudo leer la bóveda: {listError}. Si es la primera vez, verifica que la migración{' '}
          <code>20260822000001_vault_storage_bucket.sql</code> ya se ejecutó en Supabase.
        </p>
      )}

      <VaultClient
        files={files}
        used={files.length}
        limit={org?.vault_limit ?? 30}
        soyTitular={org?.owner_id === user.id}
        canWrite={permissions.vault}
        canDelete={permissions.delete}
      />
    </div>
  )
}
