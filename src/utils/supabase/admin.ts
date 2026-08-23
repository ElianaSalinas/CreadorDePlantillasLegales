import { createClient as createAdminSupabase } from '@supabase/supabase-js'

/**
 * Cliente con privilegios de administrador (bypass de RLS).
 *
 * SOLO puede usarse en Server Actions o Route Handlers.
 * Nunca importar desde un componente 'use client': expondría la llave
 * de servicio en el bundle del navegador.
 */
export function createAdminClient() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL
  const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY

  if (!url || !serviceKey) {
    throw new Error(
      'Falta SUPABASE_SERVICE_ROLE_KEY. Añádela en las Variables de Railway para habilitar las funciones de administración.'
    )
  }

  return createAdminSupabase(url, serviceKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  })
}

export function hasAdminCredentials() {
  return Boolean(process.env.SUPABASE_SERVICE_ROLE_KEY)
}
