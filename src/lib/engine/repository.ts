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
export function groupVariablesBySection(bundle: TemplateBundle) {
  const GRUPOS: { key: string; title: string; prefijo?: string }[] = [
    { key: 'primera', title: 'Primera parte', prefijo: 'parte_primera_' },
    { key: 'segunda', title: 'Segunda parte', prefijo: 'parte_segunda_' },
    { key: 'otros', title: 'Otros datos' },
  ]

  const varById = new Map(bundle.variables.map((v) => [v.id, v]))
  const yaAgregada = new Set<string>()

  const groups: { id: string; title: string; variables: Variable[] }[] = GRUPOS.map((g) => ({
    id: g.key,
    title: g.title,
    variables: [],
  }))
  const groupByKey = new Map(groups.map((g) => [g.id, g]))

  for (const tv of bundle.templateVariables) {
    const variable = varById.get(tv.variable_id)
    if (!variable || yaAgregada.has(variable.id)) continue

    const grupo =
      GRUPOS.find((g) => g.prefijo && variable.tag.startsWith(g.prefijo)) ?? GRUPOS[GRUPOS.length - 1]

    groupByKey.get(grupo.key)!.variables.push(variable)
    yaAgregada.add(variable.id)
  }

  // Un cuadro vacío (plantilla sin variables de esa parte) no se muestra.
  return groups.filter((g) => g.variables.length > 0)
}
