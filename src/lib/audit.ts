import type { SupabaseClient } from '@supabase/supabase-js'

/**
 * Registro de trazabilidad. Nunca lanza: un fallo de auditoría no debe
 * tumbar la operación del usuario, pero sí debe quedar en los logs.
 */
export async function logAudit(
  supabase: SupabaseClient,
  params: {
    orgId: string
    userId: string
    action: string
    description?: string
    documentId?: string | null
  }
) {
  try {
    await supabase.from('audit_logs').insert({
      org_id: params.orgId,
      user_id: params.userId,
      document_id: params.documentId ?? null,
      action: params.action,
      description: params.description ?? null,
    })
  } catch (err) {
    console.error('[audit] no se pudo registrar el evento:', err)
  }
}
