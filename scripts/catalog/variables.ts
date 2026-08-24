/**
 * Variables del catálogo general.
 *
 * El generador extrae automáticamente todas las etiquetas {{...}} que
 * usan las cláusulas y las secciones, y crea una variable para cada una.
 * Este archivo aporta la etiqueta legible, la pregunta y el tipo; lo que
 * no esté aquí se deduce del nombre.
 */

export type VarMeta = {
  label: string
  question?: string
  type?: string
  help?: string
  options?: { value: string; label: string }[]
  default?: string
  required?: boolean
  derived?: { transform: string; as: string; currency?: string }
}

export const VARIABLE_META: Record<string, VarMeta> = {
  /* Partes genéricas */
  parte_primera_nombre: { label: 'Nombre de la primera parte', question: '¿Quién es la primera parte?', type: 'person' },
  parte_primera_cedula: { label: 'Cédula de la primera parte', type: 'cedula' },
  parte_primera_nacionalidad: { label: 'Nacionalidad de la primera parte', type: 'text', default: 'dominicana' },
  parte_primera_domicilio: { label: 'Domicilio de la primera parte', type: 'address' },
  parte_segunda_nombre: { label: 'Nombre de la segunda parte', question: '¿Quién es la segunda parte?', type: 'person' },
  parte_segunda_cedula: { label: 'Cédula de la segunda parte', type: 'cedula' },
  parte_segunda_nacionalidad: { label: 'Nacionalidad de la segunda parte', type: 'text', default: 'dominicana' },
  parte_segunda_domicilio: { label: 'Domicilio de la segunda parte', type: 'address' },

  distrito_judicial: { label: 'Distrito Judicial competente', question: '¿Qué Distrito Judicial conoce las controversias?', type: 'text', default: 'La Altagracia' },

  parte_responsable_seguro: { label: 'Parte que contrata el seguro', question: '¿Quién contrata y paga la póliza?', type: 'text', default: 'LA PRIMERA PARTE' },
  destino_uso: { label: 'Destino o uso del bien', question: '¿Para qué se usará el bien?', type: 'text' },
  periodo_alquiler: { label: 'Período de pago del alquiler', question: '¿Cada cuánto se paga?', type: 'text', default: 'mes' },

  descripcion_obra: { label: 'Descripción de la obra', question: '¿Qué trabajos comprende la obra?', type: 'text' },

  /* Económicas */
  monto_total_letras: { label: 'Monto total', question: '¿Cuál es el monto total?', type: 'currency', derived: { transform: 'monto_letras', as: 'monto_total_letras', currency: 'DOP' } },
  monto_penalidad_letras: { label: 'Monto de la penalidad', type: 'currency', derived: { transform: 'monto_letras', as: 'monto_penalidad_letras', currency: 'DOP' } },
  monto_cuota_letras: { label: 'Monto de cada cuota', type: 'currency', derived: { transform: 'monto_letras', as: 'monto_cuota_letras', currency: 'DOP' } },
  deposito_letras: { label: 'Monto del depósito', type: 'currency', derived: { transform: 'monto_letras', as: 'deposito_letras', currency: 'DOP' } },
  precio_venta_letras: { label: 'Precio de venta', type: 'currency', derived: { transform: 'monto_letras', as: 'precio_venta_letras', currency: 'DOP' } },
  capital_letras: { label: 'Capital prestado', type: 'currency', derived: { transform: 'monto_letras', as: 'capital_letras', currency: 'DOP' } },
  precio_alquiler_letras: { label: 'Precio del alquiler', question: '¿Cuánto se paga por período?', type: 'currency', derived: { transform: 'monto_letras', as: 'precio_alquiler_letras', currency: 'DOP' } },
  salario_letras: { label: 'Salario mensual', question: '¿Cuál es el salario?', type: 'currency', derived: { transform: 'monto_letras', as: 'salario_letras', currency: 'DOP' } },
  dias_pago: { label: 'Días para pagar', question: '¿En cuántos días se paga cada factura?', type: 'number', default: '30' },
  anticipo_porcentaje: { label: 'Anticipo', question: '¿Qué porcentaje se paga por adelantado?', type: 'percentage', default: '50' },
  cantidad_cuotas: { label: 'Número de cuotas', type: 'number', default: '12' },
  comision_porcentaje: { label: 'Comisión', type: 'percentage', default: '10' },
  comision_referido_porcentaje: { label: 'Comisión por referido', type: 'percentage', default: '10' },
  interes_mora_porcentaje: { label: 'Interés por mora', type: 'percentage', default: '3' },
  penalidad_diaria_porcentaje: { label: 'Penalidad diaria', type: 'percentage', default: '0.5' },
  retencion_porcentaje: { label: 'Retención en garantía', type: 'percentage', default: '10' },
  moneda_contrato: { label: 'Moneda del contrato', type: 'select', default: 'DOP', options: [{ value: 'DOP', label: 'Pesos dominicanos' }, { value: 'USD', label: 'Dólares' }, { value: 'EUR', label: 'Euros' }] },

  /* Plazos y firma */
  cantidad_ejemplares: { label: 'Número de ejemplares', type: 'text', default: 'dos (2)' },
  fecha_entrega_larga: { label: 'Fecha de entrega', type: 'date', derived: { transform: 'fecha_larga', as: 'fecha_entrega_larga' } },
  lugar_entrega: { label: 'Lugar de entrega', type: 'address' },
  plazo_obra_dias: { label: 'Plazo de la obra en días', type: 'number', default: '90' },
  dias_recepcion_definitiva: { label: 'Días hasta la recepción definitiva', type: 'number', default: '30' },
  dias_aceptacion: { label: 'Días para aceptar entregables', type: 'number', default: '10' },

  /* Empresariales */
  parte_exclusiva: { label: 'Parte con exclusividad', type: 'text' },
  objeto_exclusividad: { label: 'Objeto de la exclusividad', type: 'text' },
  territorio_contrato: { label: 'Territorio', question: '¿En qué territorio aplica?', type: 'text', default: 'la República Dominicana' },
  anios_confidencialidad: { label: 'Años de confidencialidad', type: 'number', default: '3' },
  meses_no_competencia: { label: 'Meses de no competencia', type: 'number', default: '12' },
  titular_propiedad_intelectual: { label: 'Titular de la propiedad intelectual', type: 'text' },
  parte_suministra_materiales: { label: 'Quién suministra los materiales', type: 'text' },
  titular_imagen: { label: 'Titular de los derechos de imagen', type: 'person' },
  anios_uso_imagen: { label: 'Años de uso de la imagen', type: 'number', default: '2' },
  descripcion_entregables: { label: 'Entregables', type: 'textarea' },
  cantidad_revisiones: { label: 'Rondas de revisión incluidas', type: 'number', default: '2' },

  /* Laborales */
  horas_semanales: { label: 'Horas semanales', type: 'number', default: '44' },
  horario_trabajo: { label: 'Horario', question: '¿Cuál es el horario?', type: 'text', default: 'lunes a viernes, de 8:00 a.m. a 5:00 p.m.' },
  dias_presenciales: { label: 'Días presenciales por semana', type: 'number', default: '2' },

  /* Tecnología */
  cantidad_usuarios: { label: 'Usuarios de la licencia', type: 'number', default: '10' },
  horario_soporte: { label: 'Horario de soporte', type: 'text', default: 'lunes a viernes, de 9:00 a.m. a 6:00 p.m.' },
  disponibilidad_porcentaje: { label: 'Disponibilidad garantizada', type: 'percentage', default: '99.5' },
  frecuencia_respaldo: { label: 'Frecuencia de respaldos', type: 'select', default: 'diaria', options: [{ value: 'diaria', label: 'diaria' }, { value: 'semanal', label: 'semanal' }, { value: 'horaria', label: 'cada hora' }] },
  horas_recuperacion: { label: 'Horas para restablecer el servicio', type: 'number', default: '24' },
  horas_perdida_datos: { label: 'Pérdida máxima de datos en horas', type: 'number', default: '4' },

  /* Bienes */
  descripcion_bien: { label: 'Descripción del bien', type: 'textarea' },
  descripcion_garantia: { label: 'Descripción de la garantía', type: 'textarea' },
  descripcion_registral: { label: 'Designación catastral', type: 'text' },
  superficie_metros: { label: 'Superficie en metros cuadrados', type: 'number' },
  certificado_titulo: { label: 'Número de Certificado de Título', type: 'text' },
  parte_paga_transferencia: { label: 'Quién paga la transferencia', type: 'text' },
  parte_paga_traspaso: { label: 'Quién paga el traspaso', type: 'text' },
  vehiculo_marca: { label: 'Marca del vehículo', type: 'text' },
  vehiculo_modelo: { label: 'Modelo', type: 'text' },
  vehiculo_anio: { label: 'Año', type: 'number' },
  vehiculo_color: { label: 'Color', type: 'text' },
  vehiculo_chasis: { label: 'Número de chasis', type: 'text' },
  vehiculo_placa: { label: 'Placa', type: 'text' },
  vehiculo_matricula: { label: 'Número de matrícula', type: 'text' },
}

/** Cuando una etiqueta no está arriba, el tipo se deduce del nombre. */
export function inferType(tag: string): string {
  if (tag.includes('cedula')) return 'cedula'
  if (tag.includes('rnc')) return 'rnc'
  if (tag.endsWith('_letras') || tag.includes('monto') || tag.includes('precio') || tag.includes('salario')) return 'currency'
  if (tag.includes('porcentaje')) return 'percentage'
  if (tag.includes('fecha')) return 'date'
  if (tag.includes('correo') || tag.includes('email')) return 'email'
  if (tag.includes('telefono')) return 'phone'
  if (tag.includes('domicilio') || tag.includes('direccion') || tag.includes('lugar')) return 'address'
  if (tag.includes('nombre')) return 'person'
  if (tag.includes('descripcion') || tag.includes('detalle')) return 'textarea'
  if (tag.startsWith('cantidad') || tag.startsWith('dias') || tag.startsWith('meses') || tag.startsWith('anios') || tag.startsWith('horas') || tag.startsWith('plazo')) return 'number'
  return 'text'
}

/** Etiqueta legible a partir del nombre técnico. */
export function inferLabel(tag: string): string {
  const t = tag.replace(/_/g, ' ').replace(/\bletras\b/, '').trim()
  return t.charAt(0).toUpperCase() + t.slice(1)
}
