import { LegalClause } from '../types';

export const DEFAULT_DOMINICAN_CLAUSES: LegalClause[] = [
  {
    id: 'clausula_deposito_garantia',
    title: 'Cláusula de Depósito de Garantía Notarial',
    category: 'Garantía',
    version: '1.2',
    isProtected: true,
    isActiveDefault: true,
    description: 'Establece la fianza de depósito retenida según la Ley 4314 de Alquileres de RD',
    variablesReferenced: ['deposito_garantia_monto', 'deposito_garantia_letras', 'meses_deposito'],
    content: `DE LOS DEPÓSITOS DE GARANTÍA: EL INQUILINO entrega en este acto a EL PROPIETARIO la suma de {{deposito_garantia_monto}} ({{deposito_garantia_letras}}), equivalente a {{meses_deposito}} meses de depósito de garantía, el cual será retenido como fianza para responder por daños a la propiedad o incumplimientos de pago de servicios según las disposiciones de la Ley No. 4314 de la República Dominicana. Dicho monto no podrá ser imputado al pago de mensualidades corrientes.`,
  },
  {
    id: 'clausula_mora_penalidades',
    title: 'Cláusula de Intereses Moratorios y Penalidad',
    category: 'Mora y Penalidades',
    version: '2.0',
    isProtected: true,
    isActiveDefault: true,
    description: 'Penalidad porcentual por retraso en el pago mensual',
    variablesReferenced: ['porcentaje_mora', 'dias_gracia'],
    content: `DE LA MORA EN EL PAGO: Las partes convienen expresamente que la falta de pago de la mensualidad convenida dentro de los primeros {{dias_gracia}} días de cada mes generará un recargo moratorio mensual del {{porcentaje_mora}}% calculado sobre el monto adeudado, sin necesidad de requerimiento o intimación judicial previa.`,
  },
  {
    id: 'clausula_mantenimiento_condominio',
    title: 'Cláusula de Cuota de Mantenimiento y Condominio',
    category: 'Mantenimiento',
    version: '1.0',
    isProtected: false,
    isActiveDefault: false,
    conditionVariableId: 'incluye_mantenimiento',
    conditionExpectedValue: true,
    description: 'Obligaciones del régimen de condominio bajo Ley 5038',
    variablesReferenced: ['mantenimiento_monto', 'mantenimiento_letras'],
    content: `DEL MANTENIMIENTO DEL CONDOMINIO: La cuota mensual ordinaria de mantenimiento del condominio asciende a la suma de {{mantenimiento_monto}} ({{mantenimiento_letras}}), la cual correrá por cuenta de EL INQUILINO y deberá ser cancelada puntualmente junto con la renta mensual para el sostenimiento de las áreas comunes conforme a la Ley No. 5038 de Condominios.`,
  },
  {
    id: 'clausula_competencia_tribunales',
    title: 'Cláusula de Elección de Domicilio y Jurisdicción (RD)',
    category: 'Jurisdicción',
    version: '1.1',
    isProtected: true,
    isActiveDefault: true,
    description: 'Atribución de competencia a los tribunales del Distrito Judicial dominicano',
    variablesReferenced: ['distrito_judicial'],
    content: `DE LA JURISDICCIÓN COMPETENTE: Para la ejecución del presente contrato y de todas sus consecuencias legales, las partes eligen domicilio en las direcciones indicadas al encabezado y convienen expresamente someter cualquier diferendo o litis a la jurisdicción y competencia territorial de los Tribunales Ordinarios de la República Dominicana correspondientes al {{distrito_judicial}}, con renuncia expresa a cualquier otro fuero que pudiera corresponderles.`,
  },
  {
    id: 'clausula_terminacion_anticipada',
    title: 'Cláusula de Rescisión y Terminación Anticipada',
    category: 'Terminación',
    version: '1.0',
    isProtected: true,
    isActiveDefault: true,
    description: 'Plazos de preaviso y penalidad por desalojo voluntario anticipado',
    variablesReferenced: ['dias_preaviso_terminacion', 'penalidad_meses_rescisión'],
    content: `DE LA TERMINACIÓN ANTICIPADA: Si cualquiera de las partes decidiese rescindir el presente acuerdo antes del vencimiento del término estipulado, deberá notificar a la otra parte por escrito con una antelación no menor de {{dias_preaviso_terminacion}} días y pagar como indemnización compensatoria una suma equivalente a {{penalidad_meses_rescisión}} mensualidades de renta.`,
  },
  {
    id: 'clausula_confidencialidad',
    title: 'Cláusula de Confidencialidad y Secreto Profesional',
    category: 'Confidencialidad',
    version: '1.0',
    isProtected: false,
    isActiveDefault: false,
    conditionVariableId: 'requiere_confidencialidad',
    conditionExpectedValue: true,
    description: 'Protección de secretos comerciales y datos protegidos bajo Ley 172-13 de RD',
    variablesReferenced: ['plazo_confidencialidad_anos'],
    content: `DE LA CONFIDENCIALIDAD: Toda la información técnica, jurídica, comercial y financiera intercambiada con motivo del presente contrato tiene carácter estrictamente confidencial. Las partes se comprometen a no divulgarla a terceros durante la vigencia del acuerdo y por un período de {{plazo_confidencialidad_anos}} años posteriores a su terminación, bajo pena de resarcimiento de daños y perjuicios conforme a la Ley No. 172-13 sobre Protección de Datos de la República Dominicana.`,
  },
];

/**
 * Process conditional clauses in a template text
 * Block syntax:
 * {{#clause:clause_id}}
 * ... clause content ...
 * {{/clause:clause_id}}
 */
export function renderConditionalClauses(
  content: string,
  clauses: LegalClause[],
  formValues: Record<string, any>,
  visibleClauseIds?: Set<string>
): string {
  if (!content) return '';

  let processed = content;

  for (const clause of clauses) {
    const clauseTagRegex = new RegExp(
      `\\{\\{#clause:${clause.id}\\}\\}([\\s\\S]*?)\\{\\{/clause:${clause.id}\\}\\}`,
      'g'
    );

    let isIncluded = true;

    if (visibleClauseIds) {
      isIncluded = visibleClauseIds.has(clause.id);
    } else if (clause.conditionVariableId) {
      const actualVal = formValues[clause.conditionVariableId];
      if (clause.conditionExpectedValue !== undefined) {
        isIncluded = actualVal === clause.conditionExpectedValue;
      } else {
        isIncluded = Boolean(actualVal);
      }
    }

    if (isIncluded) {
      // Keep clause inner content
      processed = processed.replace(clauseTagRegex, (_match, inner) => inner.trim());
    } else {
      // Strip out the conditional clause
      processed = processed.replace(clauseTagRegex, '');
    }
  }

  // Also support generic {{#if variable}}...{{/if}}
  processed = processed.replace(/\{\{#if\s+([a-z0-9_]+)\}\}([\s\S]*?)\{\{\/if\}\}/gi, (match, varName, inner) => {
    const val = formValues[varName.toLowerCase()];
    if (val && val !== 'false' && val !== 0 && val !== '0') {
      return inner.trim();
    }
    return '';
  });

  return processed;
}
