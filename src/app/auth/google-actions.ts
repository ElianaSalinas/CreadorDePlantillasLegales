'use server'

import { redirect } from 'next/navigation'
import { createClient } from '@/utils/supabase/server'
import { getSiteUrl } from '@/lib/siteUrl'

/**
 * Entrar con Google.
 *
 * El identificador y el secreto de Google NO aparecen por ninguna parte
 * de este código: los guarda Supabase. Aquí solo se dice "google" y
 * Supabase construye la URL con lo suyo. Es lo que hace que el secreto
 * no pueda filtrarse por el repositorio.
 *
 * `redirectTo` apunta a /auth/confirm, que es la ruta que ya sabe
 * canjear un código por una sesión desde la Fase 0 —con su manejo de
 * enlaces caducados y su comprobación de que `next` es una ruta interna.
 * No se escribe una ruta nueva para lo mismo.
 *
 * `next=/app/bienvenida` porque quien llega por Google trae nombre y
 * correo, pero no si es persona o empresa. Esa pantalla lo pregunta una
 * sola vez.
 */
export async function entrarConGoogle() {
  const supabase = await createClient()
  const siteUrl = await getSiteUrl()

  const { data, error } = await supabase.auth.signInWithOAuth({
    provider: 'google',
    options: {
      redirectTo: `${siteUrl}/auth/confirm?next=/app/bienvenida`,
      queryParams: {
        // Para que Google vuelva a ofrecer el selector de cuenta en vez
        // de entrar con la última usada: en un ordenador compartido de
        // un despacho, entrar sin querer con la cuenta del compañero es
        // un problema de verdad.
        prompt: 'select_account',
      },
    },
  })

  if (error || !data?.url) {
    console.error('[google] no se pudo iniciar el flujo:', error?.message)
    redirect(
      '/login?message=' +
        encodeURIComponent('No pudimos conectar con Google. Inténtalo de nuevo o entra con tu correo.'),
    )
  }

  redirect(data.url)
}
