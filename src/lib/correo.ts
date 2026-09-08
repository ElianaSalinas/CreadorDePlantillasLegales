import nodemailer from 'nodemailer'
import { EMPRESA, DOMICILIO } from '@/lib/empresa'

/**
 * El correo que manda la APLICACIÓN, no Supabase.
 *
 * Hasta ahora todos los correos de SAVE los enviaba Supabase Auth:
 * confirmación, invitación, recuperar contraseña. Este es el primero
 * que sale de nuestro propio código, y por eso hay transporte aquí.
 *
 * Va por el mismo buzón, `info@savedocumentos.com` en Hostinger, a
 * propósito: es el remitente cuyo DKIM y SPF ya están verificados y
 * entregando en cuatro segundos. Estrenar un remitente distinto sería
 * volver a empezar la reputación desde cero y acabar en Spam.
 *
 * SMTP_PASS no lleva prefijo NEXT_PUBLIC_ y no puede llevarlo: eso la
 * incrustaría en el JavaScript que descarga cualquier visitante.
 */
export function hayCorreoConfigurado(): boolean {
  return Boolean(process.env.SMTP_HOST && process.env.SMTP_USER && process.env.SMTP_PASS)
}

function transporte() {
  return nodemailer.createTransport({
    host: process.env.SMTP_HOST,
    port: Number(process.env.SMTP_PORT ?? 587),
    secure: Number(process.env.SMTP_PORT ?? 587) === 465,
    auth: { user: process.env.SMTP_USER, pass: process.env.SMTP_PASS },
  })
}

/** Envuelve el contenido en la firma de la empresa, igual que las de Supabase. */
export function plantilla(cuerpo: string): string {
  return `${cuerpo}
<p style="color:#6b7280;font-size:13px;margin-top:28px">
SAVE Documentos &middot; ${EMPRESA.nombreLegal} &middot; RNC ${EMPRESA.rnc}<br>
${DOMICILIO}
</p>`
}

export async function enviarCorreo(opciones: {
  para: string
  asunto: string
  html: string
}): Promise<{ ok: boolean; error?: string }> {
  if (!hayCorreoConfigurado()) {
    console.error('[correo] faltan SMTP_HOST / SMTP_USER / SMTP_PASS')
    return { ok: false, error: 'correo no configurado' }
  }
  try {
    await transporte().sendMail({
      from: `"SAVE Documentos" <${EMPRESA.correo}>`,
      to: opciones.para,
      subject: opciones.asunto,
      html: plantilla(opciones.html),
    })
    return { ok: true }
  } catch (e) {
    console.error('[correo] no se pudo enviar:', e)
    return { ok: false, error: e instanceof Error ? e.message : 'error desconocido' }
  }
}
