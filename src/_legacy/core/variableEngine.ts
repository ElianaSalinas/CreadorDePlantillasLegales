import { TemplateVariable, DerivedVariableConfig } from '../types';
import {
  montoALetras,
  fechaALetrasNotarial,
  formatCurrencyValue,
  formatCedulaInput,
} from './dominicanValidators';

/**
 * Normalizes string to snake_case complying with RN-005:
 * Lowercase, only [a-z0-9_], no spaces, no accents, no ñ
 */
export function normalizeVariableTag(input: string): string {
  return input
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '') // remove diacritics
    .replace(/ñ/g, 'n')
    .replace(/[^a-z0-9_]/g, '_')
    .replace(/_+/g, '_')
    .replace(/^_|_$/g, '');
}

/**
 * Validates whether a variable tag complies with RN-005
 */
export function isValidVariableTag(tag: string): boolean {
  return /^[a-z0-9_]+$/.test(tag) && !tag.startsWith('_') && !tag.endsWith('_');
}

/**
 * Extracts all variable tags referenced in template content via {{variable_tag}}
 */
export function extractReferencedVariables(content: string): string[] {
  if (!content) return [];
  const regex = /\{\{([a-z0-9_]+)\}\}/gi;
  const matches = new Set<string>();
  let match;
  while ((match = regex.exec(content)) !== null) {
    matches.add(match[1].toLowerCase());
  }
  return Array.from(matches);
}

/**
 * Calculates derived variables based on their configuration and base values
 */
export function calculateDerivedValues(
  variables: TemplateVariable[],
  currentValues: Record<string, any>
): Record<string, any> {
  const result: Record<string, any> = { ...currentValues };

  const derivedVars = variables.filter((v) => v.derivedConfig);

  for (const v of derivedVars) {
    const config = v.derivedConfig!;
    const sourceVal = currentValues[config.sourceVariableId];

    if (sourceVal === undefined || sourceVal === null || sourceVal === '') {
      continue;
    }

    switch (config.transformType) {
      case 'amount_in_words': {
        const currency = v.currency || currentValues[`${config.sourceVariableId}_moneda`] || 'DOP';
        result[v.tag] = montoALetras(sourceVal, currency, true);
        break;
      }
      case 'date_in_words': {
        result[v.tag] = fechaALetrasNotarial(String(sourceVal));
        break;
      }
      case 'format_currency': {
        const currency = v.currency || 'DOP';
        result[v.tag] = formatCurrencyValue(sourceVal, currency);
        break;
      }
      case 'format_cedula': {
        result[v.tag] = formatCedulaInput(String(sourceVal));
        break;
      }
      case 'multiply': {
        const factor = config.params?.factor ?? 1;
        const num = parseFloat(String(sourceVal)) || 0;
        result[v.tag] = num * factor;
        break;
      }
      case 'percentage_calc': {
        const rate = config.params?.rate ?? 0.18; // Default ITBIS in RD is 18%
        const num = parseFloat(String(sourceVal)) || 0;
        result[v.tag] = num * rate;
        break;
      }
      case 'calculate_months': {
        const endDate = currentValues[config.params?.endVariableId || 'fecha_fin'];
        if (sourceVal && endDate) {
          const d1 = new Date(sourceVal);
          const d2 = new Date(endDate);
          if (!isNaN(d1.getTime()) && !isNaN(d2.getTime())) {
            const months = (d2.getFullYear() - d1.getFullYear()) * 12 + (d2.getMonth() - d1.getMonth());
            result[v.tag] = Math.max(1, months);
          }
        }
        break;
      }
      default:
        break;
    }
  }

  return result;
}

/**
 * Replaces {{variable_tag}} in content with calculated/entered values
 */
export function substituteVariables(
  content: string,
  values: Record<string, any>,
  highlightMissing = false
): string {
  if (!content) return '';
  return content.replace(/\{\{([a-z0-9_]+)\}\}/gi, (match, tag) => {
    const lowerTag = tag.toLowerCase();
    const val = values[lowerTag];
    if (val !== undefined && val !== null && val !== '') {
      return String(val);
    }
    if (highlightMissing) {
      return `[FALTA: ${lowerTag}]`;
    }
    return match;
  });
}

/**
 * Group variables by logical categories for UI display
 */
export function groupVariablesByCategory(
  variables: TemplateVariable[]
): Record<string, TemplateVariable[]> {
  const groups: Record<string, TemplateVariable[]> = {
    'Partes y Comparecientes': [],
    'Identificación y Cédulas': [],
    'Montos y Condiciones Económicas': [],
    'Fechas y Plazos': [],
    'Inmuebles y Direcciones': [],
    'Empresas y RNC': [],
    'Variables Derivadas': [],
    'Otros Campos': [],
  };

  for (const v of variables) {
    if (v.derivedConfig) {
      groups['Variables Derivadas'].push(v);
    } else if (v.category === 'CAT_NAME' || v.category === 'CAT_ROLE' || v.dataType === 'person') {
      groups['Partes y Comparecientes'].push(v);
    } else if (v.category === 'CAT_CEDULA' || v.dataType === 'cedula') {
      groups['Identificación y Cédulas'].push(v);
    } else if (v.category === 'CAT_AMOUNT' || v.dataType === 'currency' || v.dataType === 'percentage') {
      groups['Montos y Condiciones Económicas'].push(v);
    } else if (v.category === 'CAT_DATE' || v.category === 'CAT_TERM' || v.dataType === 'date') {
      groups['Fechas y Plazos'].push(v);
    } else if (v.category === 'CAT_ADDRESS' || v.dataType === 'address') {
      groups['Inmuebles y Direcciones'].push(v);
    } else if (v.category === 'CAT_COMPANY' || v.category === 'CAT_RNC' || v.dataType === 'rnc' || v.dataType === 'company') {
      groups['Empresas y RNC'].push(v);
    } else {
      groups['Otros Campos'].push(v);
    }
  }

  // Filter out empty groups
  const filtered: Record<string, TemplateVariable[]> = {};
  for (const [key, list] of Object.entries(groups)) {
    if (list.length > 0) {
      filtered[key] = list;
    }
  }
  return filtered;
}

export const calculateDerivedVariables = calculateDerivedValues;
