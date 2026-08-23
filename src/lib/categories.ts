export const TEMPLATE_CATEGORIES = [
  'Inmobiliario',
  'Societario',
  'Cobros',
  'Notarial',
  'Laboral',
  'Familia',
  'Otros',
] as const

export type TemplateCategory = (typeof TEMPLATE_CATEGORIES)[number]
