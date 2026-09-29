'use client'

import Script from 'next/script'
import { useCallback, useEffect, useRef, useState, useTransition, type ReactNode } from 'react'
import { entrarConTokenDeGoogle } from '@/app/auth/google-actions'

/**
 * Botón oficial de Google ("Sign in with Google", Google Identity Services).
 *
 * POR QUÉ EXISTE. Con el flujo de siempre (signInWithOAuth), Google
 * devuelve al usuario al callback de Supabase y por eso su pantalla dice
 * "Accede a fzuojuoopngcqrdozvpw.supabase.co". Aquí Google habla
 * directamente con savedocumentos.com: nos entrega un ID token firmado y
 * nosotros se lo pasamos a Supabase con signInWithIdToken, EN EL SERVIDOR
 * (ver entrarConTokenDeGoogle). El dominio de Supabase no aparece.
 *
 * EL NONCE. Google recibe el hash SHA-256 (hex) de un valor aleatorio y
 * lo mete dentro del token; Supabase recibe el valor sin hashear y
 * comprueba que coincidan. Así un token robado de otra web no sirve aquí.
 * Es lo que pide la documentación de Supabase.
 *
 * RED DE SEGURIDAD. Mientras el script de Google carga, o si no carga
 * (bloqueador, red), se muestra `respaldo`: el botón de siempre, que
 * sigue funcionando. Nadie se queda sin poder entrar.
 *
 * El ID del cliente llega como prop desde el servidor, leído en tiempo de
 * ejecución. No es NEXT_PUBLIC_: esas se congelan en el build de Docker
 * (la lección de /precios).
 */

type RespuestaGoogle = { credential?: string }

type GoogleId = {
  initialize: (config: Record<string, unknown>) => void
  renderButton: (el: HTMLElement, opciones: Record<string, unknown>) => void
}

declare global {
  interface Window {
    google?: { accounts?: { id?: GoogleId } }
  }
}

function aleatorio(): string {
  const bytes = new Uint8Array(32)
  crypto.getRandomValues(bytes)
  return btoa(String.fromCharCode(...bytes)).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '')
}

async function sha256Hex(texto: string): Promise<string> {
  const hash = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(texto))
  return Array.from(new Uint8Array(hash), (b) => b.toString(16).padStart(2, '0')).join('')
}

export default function BotonGoogleOficial({
  clientId,
  contexto,
  respaldo,
}: {
  clientId: string
  contexto: 'signin' | 'signup'
  respaldo: ReactNode
}) {
  const contenedor = useRef<HTMLDivElement>(null)
  const [estado, setEstado] = useState<'cargando' | 'listo' | 'fallo'>('cargando')
  const [error, setError] = useState<string | null>(null)
  const [pendiente, startTransition] = useTransition()

  const montar = useCallback(async () => {
    const gid = window.google?.accounts?.id
    const el = contenedor.current
    if (!gid || !el) {
      setEstado('fallo')
      return
    }
    try {
      const nonce = aleatorio()
      const nonceHash = await sha256Hex(nonce)

      gid.initialize({
        client_id: clientId,
        nonce: nonceHash,
        ux_mode: 'popup',
        context: contexto,
        itp_support: true,
        callback: (r: RespuestaGoogle) => {
          if (!r.credential) {
            setError('Google no devolvió la cuenta. Inténtalo de nuevo o entra con tu correo.')
            return
          }
          setError(null)
          startTransition(async () => {
            // Si todo va bien, la acción redirige y esto no vuelve.
            const res = await entrarConTokenDeGoogle(r.credential!, nonce)
            if (res?.error) setError(res.error)
          })
        },
      })

      // Google no acepta anchos fuera de 200-400 px. Se mide el padre:
      // el contenedor sigue oculto en este momento y mide 0.
      const disponible = el.parentElement?.getBoundingClientRect().width || 400
      const ancho = Math.max(200, Math.min(400, Math.round(disponible)))
      gid.renderButton(el, {
        type: 'standard',
        theme: 'outline',
        size: 'large',
        shape: 'rectangular',
        text: contexto === 'signup' ? 'signup_with' : 'signin_with',
        logo_alignment: 'center',
        width: ancho,
        locale: 'es',
      })
      setEstado('listo')
    } catch (e) {
      console.error('[google] no se pudo montar el botón oficial:', e)
      setEstado('fallo')
    }
  }, [clientId, contexto])

  // Si el script ya estaba cargado (navegación entre /login y /register),
  // onReady no siempre vuelve a dispararse.
  useEffect(() => {
    if (window.google?.accounts?.id) montar()
  }, [montar])

  return (
    <div>
      <Script
        src="https://accounts.google.com/gsi/client"
        strategy="afterInteractive"
        onReady={montar}
        onError={() => setEstado('fallo')}
      />

      {estado !== 'listo' && respaldo}

      <div
        ref={contenedor}
        aria-busy={pendiente}
        className={estado === 'listo' ? 'flex min-h-[44px] w-full justify-center' : 'hidden'}
      />

      {pendiente && (
        <p className="mt-2 text-center text-sm text-slate-500" role="status">
          Entrando…
        </p>
      )}
      {error && (
        <p className="mt-2 text-center text-sm text-red-600 dark:text-red-400" role="alert">
          {error}
        </p>
      )}
    </div>
  )
}
