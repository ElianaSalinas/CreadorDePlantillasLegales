/**
 * Qué puede hacer cada miembro dentro del despacho.
 *
 * El titular siempre lo puede todo. Para el resto, el titular marca
 * casillas en Mi Despacho; si nunca las ha tocado se aplican los valores
 * por defecto de su rol.
 */

export type PermissionKey = 'documents' | 'templates' | 'vault' | 'delete'

export type MemberPermissions = Record<PermissionKey, boolean>

export const PERMISSION_LIST: {
  key: PermissionKey
  label: string
  hint: string
}[] = [
  {
    key: 'documents',
    label: 'Redactar documentos',
    hint: 'Crear documentos a partir de las plantillas del despacho.',
  },
  {
    key: 'templates',
    label: 'Gestionar plantillas',
    hint: 'Crear, editar y eliminar las plantillas propias del despacho.',
  },
  {
    key: 'vault',
    label: 'Usar la bóveda',
    hint: 'Subir documentos y descargar los que ya están guardados.',
  },
  {
    key: 'delete',
    label: 'Eliminar archivos',
    hint: 'Borrar documentos de la bóveda. Conviene reservarlo.',
  },
]

const ROLE_DEFAULTS: Record<string, MemberPermissions> = {
  OWNER: { documents: true, templates: true, vault: true, delete: true },
  PARALEGAL: { documents: true, templates: true, vault: true, delete: false },
  ASSISTANT: { documents: true, templates: false, vault: true, delete: false },
}

export function defaultsForRole(role: string | null | undefined): MemberPermissions {
  return { ...(ROLE_DEFAULTS[role ?? 'ASSISTANT'] ?? ROLE_DEFAULTS.ASSISTANT) }
}

/**
 * Resuelve los permisos efectivos: el titular lo puede todo; el resto
 * parte de los valores de su rol y encima se aplica lo que el titular
 * haya marcado explícitamente.
 */
export function resolvePermissions(
  role: string | null | undefined,
  stored: unknown
): MemberPermissions {
  if (role === 'OWNER') return defaultsForRole('OWNER')

  const base = defaultsForRole(role)
  if (!stored || typeof stored !== 'object') return base

  const explicit = stored as Record<string, unknown>
  for (const { key } of PERMISSION_LIST) {
    if (typeof explicit[key] === 'boolean') {
      base[key] = explicit[key] as boolean
    }
  }
  return base
}

/** Deja solo las claves conocidas antes de guardar en la base de datos. */
export function sanitizePermissions(input: Record<string, unknown>): MemberPermissions {
  const out = {} as MemberPermissions
  for (const { key } of PERMISSION_LIST) {
    out[key] = input[key] === true || input[key] === 'on' || input[key] === 'true'
  }
  return out
}
