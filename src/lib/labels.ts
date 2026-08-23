/**
 * Etiquetas legibles compartidas entre servidor y navegador.
 *
 * Viven aparte de lib/session.ts a propósito: ese módulo usa next/headers,
 * que no puede llegar al bundle del cliente.
 */

export const PROF_ROLE_LABEL: Record<string, string> = {
  ABOGADO: 'Abogado',
  NOTARIO: 'Notario',
  AMBOS: 'Abogado y Notario',
}

export const MEMBER_ROLE_LABEL: Record<string, string> = {
  OWNER: 'Titular',
  PARALEGAL: 'Paralegal',
  ASSISTANT: 'Asistente',
}

export const ADMIN_ROLE_LABEL: Record<string, string> = {
  SUPER_ADMIN: 'Super Admin',
  CONTENT: 'Contenido',
  FINANCE: 'Finanzas',
}
