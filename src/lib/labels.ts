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
  INDEPENDIENTE: 'Independiente',
  PARALEGAL: 'Paralegal o asistente',
}

/**
 * Las opciones tal y como se ofrecen al registrarse y en Mi Despacho.
 * Viven aquí, en un solo sitio, para que las dos pantallas no se
 * desincronicen: ya pasó que el registro ofreciera menos de lo que
 * la base de datos admitía.
 *
 * Solo ABOGADO, NOTARIO y AMBOS pueden liderar despacho. Eso NO se
 * decide aquí sino en roleCanLeadTeam(), que es una lista blanca:
 * añadir un perfil a esta lista no le regala facultades.
 */
export const PROF_ROLE_OPTIONS: Array<{ value: string; label: string; hint: string }> = [
  {
    value: 'ABOGADO',
    label: 'Abogado',
    hint: 'Ejerzo la abogacía. Puedo formar despacho y sumar paralegales.',
  },
  {
    value: 'NOTARIO',
    label: 'Notario',
    hint: 'Ejerzo el notariado. Puedo formar despacho y sumar paralegales.',
  },
  {
    value: 'AMBOS',
    label: 'Abogado y notario',
    hint: 'Ejerzo las dos funciones.',
  },
  {
    value: 'INDEPENDIENTE',
    label: 'Independiente',
    hint: 'No soy abogado ni notario. Uso SAVE para mis propios documentos.',
  },
  {
    value: 'PARALEGAL',
    label: 'Paralegal o asistente',
    hint: 'Apoyo a un abogado o notario. Si me añaden a su despacho, veré sus casos.',
  },
]

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
