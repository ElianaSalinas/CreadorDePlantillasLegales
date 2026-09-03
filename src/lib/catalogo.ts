/**
 * Lo que la portada anuncia del catálogo.
 *
 * El número sube solo, según la abogada va aprobando: no hay que tocar el
 * código ni volver a desplegar. Se lee por una función de la base de datos
 * en vez de contar filas desde aquí, para que un visitante sin sesión no
 * necesite permiso de lectura sobre la tabla entera solo para ver un número.
 *
 * Se usa un cliente propio, sin cookies, a propósito: leer cookies obligaría
 * a renderizar la portada en cada visita. Así se sirve cacheada y se refresca
 * cada pocos minutos.
 */

import { createClient } from '@supabase/supabase-js'

export type ConteoCatalogo = { plantillas: number; clausulas: number }

const VACIO: ConteoCatalogo = { plantillas: 0, clausulas: 0 }

export async function contarCatalogoPublicado(): Promise<ConteoCatalogo> {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL
  const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY

  if (!url || !key) return VACIO

  try {
    const anon = createClient(url, key, {
      auth: { persistSession: false, autoRefreshToken: false },
    })

    const { data, error } = await anon.rpc('contar_catalogo_publicado').single()

    if (error || !data) return VACIO

    const fila = data as { plantillas: number | null; clausulas: number | null }
    return {
      plantillas: Number(fila.plantillas) || 0,
      clausulas: Number(fila.clausulas) || 0,
    }
  } catch {
    // La portada tiene que salir aunque la base de datos no conteste.
    return VACIO
  }
}

/**
 * La frase de la portada. Cuando todavía no hay nada aprobado no se dice
 * "0 plantillas": se cuenta lo que sí es cierto, que las tuyas no tienen
 * límite. Anunciar un número inflado sería peor que no anunciarlo.
 */
export function fraseDelCatalogo(plantillas: number): string {
  if (plantillas <= 0) {
    return 'Nuestros abogados están terminando de revisar el catálogo. Mientras tanto, tus propias plantillas, sin límite.'
  }
  if (plantillas === 1) {
    return '1 plantilla lista desde el primer día, y las tuyas propias sin límite.'
  }
  return `${plantillas} plantillas listas desde el primer día, y las tuyas propias sin límite.`
}
