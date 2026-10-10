// Solo servidor: importa next/headers a través del cliente de Supabase,
// que ya falla en tiempo de compilación si alguien lo mete en el navegador.
import { createClient } from '@/utils/supabase/server'
import type { TemplateBundle } from './render'
import type { Clause, TemplateClause, TemplateRule, TemplateSection, TemplateVariable, Variable } from './types'

/**
 * Carga una plantilla con todo lo que necesita para generar: secciones,
 * variables, cláusulas y reglas. Las políticas por fila de Supabase ya
 * filtran lo que el usuario puede ver, así que aquí no se repite el control.
 */
export async function loadTemplateBundle(templateId: string): Promise<TemplateBundle | null> {
  const supabase = await createClient()

  const { data: template, error } = await supabase
    .from('templates')
    .select('id, title, version, description, status, content, org_id, is_master, category')
    .eq('id', templateId)
    .maybeSingle()

  if (error || !template) return null

  const [sectionsRes, tVarsRes, tClausesRes, rulesRes] = await Promise.all([
    supabase.from('template_sections').select('*').eq('template_id', templateId).order('sort_order'),
    supabase.from('template_variables').select('*').eq('template_id', templateId).order('sort_order'),
    supabase.from('template_clauses').select('*').eq('template_id', templateId).order('sort_order'),
    supabase.from('template_rules').select('*').eq('template_id', templateId).order('sort_order'),
  ])

  const templateVariables = (tVarsRes.data ?? []) as TemplateVariable[]
  const templateClauses = (tClausesRes.data ?? []) as TemplateClause[]

  const variableIds = templateVariables.map((tv) => tv.variable_id)
  const clauseIds = templateClauses.map((tc) => tc.clause_id)

  const [varsRes, clausesRes] = await Promise.all([
    variableIds.length
      ? supabase.from('variables').select('*').in('id', variableIds)
      : Promise.resolve({ data: [] as Variable[] }),
    clauseIds.length
      ? supabase.from('clauses').select('*').in('id', clauseIds)
      : Promise.resolve({ data: [] as Clause[] }),
  ])

  // Las variables se devuelven en el orden en que se preguntan, no en el
  // orden en que la base de datos las entregue.
  const varById = new Map(((varsRes.data ?? []) as Variable[]).map((v) => [v.id, v]))
  const orderedVariables = templateVariables
    .map((tv) => varById.get(tv.variable_id))
    .filter(Boolean) as Variable[]

  return {
    template: {
      id: template.id,
      title: template.title,
      version: template.version ?? '1.0',
      content: template.content,
    },
    sections: (sectionsRes.data ?? []) as TemplateSection[],
    variables: orderedVariables,
    templateVariables,
    clauses: (clausesRes.data ?? []) as Clause[],
    templateClauses,
    rules: (rulesRes.data ?? []) as TemplateRule[],
  }
}

/** Plantillas que el usuario puede usar para generar un documento. */
export async function listUsableTemplates() {
  const supabase = await createClient()

  const { data } = await supabase
    .from('templates')
    .select('id, title, description, category, status, is_master, org_id, version')
    .order('title')

  return data ?? []
}

/**
 * La sección a la que pertenece cada variable, para agrupar el formulario.
 *
 * No agrupa por `template_sections` (todas las variables estándar de una
 * plantilla enlazan a la misma sección "Comparecientes" en la base, así
 * que agrupar por ahí las mete todas en un solo cuadro gigante). En vez
 * de eso, agrupa por el PREFIJO del nombre técnico: "primera parte",
 * "segunda parte" y todo lo demás. Es una decisión puramente de cómo se
 * ve el formulario -no toca la base ni el documento generado-, así que
 * cambiarla no exige tocar ninguna plantilla ni volver a correr SQL.
 */
/**
 * Un recuadro dentro de una parte: la empresa, el representante, o cada
 * persona por separado. El título final lo pone el formulario, porque
 * depende de las respuestas (empresa o persona, cuántas personas).
 */
export type SubgrupoFormulario = {
  id:
    | 'general'
    | 'empresa'
    | 'persona1'
    | 'persona2'
    | 'persona3'
    | 'persona4'
    // Cuentas bancarias: un recuadro por cuenta.
    | 'cuenta1'
    | 'cuenta2'
    | 'cuenta3'
    | 'cuenta4'
  variables: Variable[]
}

export type GrupoFormulario = {
  id: string
  title: string
  /** Todas las variables del grupo, en orden. */
  variables: Variable[]
  /** Solo en "Primera parte" y "Segunda parte": la misma lista, repartida por persona. */
  subgrupos?: SubgrupoFormulario[]
}

/**
 * Orden de los datos de cada persona. El tipo de documento va ANTES del
 * número: si se elige pasaporte, el campo siguiente ya pide el pasaporte.
 */
const ORDEN_PERSONA = [
  'representante_cargo',
  'nombre',
  'tipo_documento',
  'cedula',
  'tipo_documento_2',
  'documento_2',
  'genero',
  'nacionalidad',
  'estado_civil',
  'domicilio',
]

function subgrupoDe(resto: string): SubgrupoFormulario['id'] {
  if (resto === 'tipo_parte' || resto === 'cantidad') return 'general'
  if (resto === 'razon_social' || resto === 'rnc') return 'empresa'
  const miembro = /^miembro([2-4])_/.exec(resto)
  if (miembro) return `persona${miembro[1]}` as SubgrupoFormulario['id']
  // Quien firma por la parte: la persona 1, o el representante si es una
  // empresa (su cargo incluido).
  return 'persona1'
}

function campoDe(resto: string): string {
  return resto.replace(/^miembro[2-4]_/, '')
}

export function groupVariablesBySection(bundle: TemplateBundle): GrupoFormulario[] {
  const GRUPOS: { key: string; title: string; prefijo?: string; patron?: RegExp }[] = [
    { key: 'primera', title: 'Primera parte', prefijo: 'parte_primera_' },
    { key: 'segunda', title: 'Segunda parte', prefijo: 'parte_segunda_' },
    // cuenta_cantidad y cuenta1_… cuenta4_… (cuentas bancarias opcionales).
    { key: 'cuentas', title: 'Cuentas bancarias', patron: /^cuenta(_cantidad|[1-4]_)/ },
    { key: 'otros', title: 'Otros datos' },
  ]

  const varById = new Map(bundle.variables.map((v) => [v.id, v]))
  const yaAgregada = new Set<string>()

  const groups: GrupoFormulario[] = GRUPOS.map((g) => ({ id: g.key, title: g.title, variables: [] }))
  const groupByKey = new Map(groups.map((g) => [g.id, g]))

  for (const tv of bundle.templateVariables) {
    const variable = varById.get(tv.variable_id)
    if (!variable || yaAgregada.has(variable.id)) continue

    const grupo =
      GRUPOS.find(
        (g) => (g.prefijo && variable.tag.startsWith(g.prefijo)) || g.patron?.test(variable.tag)
      ) ?? GRUPOS[GRUPOS.length - 1]

    groupByKey.get(grupo.key)!.variables.push(variable)
    yaAgregada.add(variable.id)
  }

  // Cada parte se reparte en recuadros: datos generales, la empresa, y
  // cada persona por separado. Antes iban todas mezcladas en un solo
  // cuadro y no se sabía de quién era cada cédula.
  for (const g of GRUPOS) {
    if (!g.prefijo) continue
    const grupo = groupByKey.get(g.key)!
    const orden: SubgrupoFormulario['id'][] = ['general', 'empresa', 'persona1', 'persona2', 'persona3', 'persona4']
    const porId = new Map(orden.map((id) => [id, [] as Variable[]]))

    for (const v of grupo.variables) {
      porId.get(subgrupoDe(v.tag.slice(g.prefijo.length)))!.push(v)
    }

    for (const lista of porId.values()) {
      lista.sort((a, b) => {
        const ia = ORDEN_PERSONA.indexOf(campoDe(a.tag.slice(g.prefijo!.length)))
        const ib = ORDEN_PERSONA.indexOf(campoDe(b.tag.slice(g.prefijo!.length)))
        // Lo que no está en la lista conserva su orden, al final.
        return (ia === -1 ? 99 : ia) - (ib === -1 ? 99 : ib)
      })
    }

    grupo.subgrupos = orden
      .map((id) => ({ id, variables: porId.get(id)! }))
      .filter((s) => s.variables.length > 0)
    grupo.variables = grupo.subgrupos.flatMap((s) => s.variables)
  }

  // Cuentas bancarias: la pregunta de cuántas va suelta arriba y cada
  // cuenta va en su propio recuadro, para que no se mezclen los datos.
  const cuentas = groupByKey.get('cuentas')!
  if (cuentas.variables.length > 0) {
    const orden: SubgrupoFormulario['id'][] = ['general', 'cuenta1', 'cuenta2', 'cuenta3', 'cuenta4']
    const porId = new Map(orden.map((id) => [id, [] as Variable[]]))
    for (const v of cuentas.variables) {
      const m = /^cuenta([1-4])_/.exec(v.tag)
      porId.get(m ? (`cuenta${m[1]}` as SubgrupoFormulario['id']) : 'general')!.push(v)
    }
    cuentas.subgrupos = orden
      .map((id) => ({ id, variables: porId.get(id)! }))
      .filter((s) => s.variables.length > 0)
    cuentas.variables = cuentas.subgrupos.flatMap((s) => s.variables)
  }

  // Un cuadro vacío (plantilla sin variables de esa parte) no se muestra.
  return groups.filter((g) => g.variables.length > 0)
}
