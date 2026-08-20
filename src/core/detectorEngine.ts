import { DetectedToken, VariableCategory, VariableDataType, GenderType, LegalRole } from '../types';
import { normalizeVariableTag } from './variableEngine';
import { validateCedulaDominicana, validateRNC } from './dominicanValidators';

/**
 * Deterministic Dominican Legal Regex & NLP Extraction Engine
 * Local-First, fast, privacy-preserving (PRD & Tech Spec)
 */
export function detectVariablesLocally(text: string): DetectedToken[] {
  if (!text) return [];

  const tokens: DetectedToken[] = [];
  let tokenCounter = 1;

  // 1. Detect Dominican Cédula
  // Matches: 001-0894561-2 or 11 continuous digits near cédula/identidad
  const cedulaRegex = /(?:cédula|identidad|no\.|personal|electoral)?\s*(?:de identidad y electoral)?\s*(?:no\.?)?\s*(\b\d{3}-\d{7}-\d{1}\b|\b\d{11}\b)/gi;
  let match: RegExpExecArray | null;

  while ((match = cedulaRegex.exec(text)) !== null) {
    const rawVal = match[1];
    const check = validateCedulaDominicana(rawVal);
    const confidence = check.isValid ? 0.98 : 0.75;

    // Deduplicate
    if (!tokens.some((t) => t.originalValue === rawVal)) {
      tokens.push({
        id: `det_${tokenCounter++}`,
        tag: `cedula_parte_${tokens.filter((t) => t.category === 'CAT_CEDULA').length + 1}`,
        label: `Cédula de Identidad ${tokens.filter((t) => t.category === 'CAT_CEDULA').length + 1}`,
        originalValue: rawVal,
        category: 'CAT_CEDULA',
        dataType: 'cedula',
        confidence,
        status: 'PENDIENTE',
        startIndex: match.index,
        endIndex: match.index + rawVal.length,
      });
    }
  }

  // 2. Detect RNC (9 digits for corporations)
  const rncRegex = /(?:RNC|Registro Nacional del Contribuyente|R\.N\.C\.)\s*(?:No\.?)?\s*(\b\d{9}\b|\b\d{1}-\d{2}-\d{5}-\d{1}\b)/gi;
  while ((match = rncRegex.exec(text)) !== null) {
    const rawVal = match[1];
    const check = validateRNC(rawVal);
    if (!tokens.some((t) => t.originalValue === rawVal)) {
      tokens.push({
        id: `det_${tokenCounter++}`,
        tag: `rnc_empresa_${tokens.filter((t) => t.category === 'CAT_RNC').length + 1}`,
        label: `RNC Empresarial ${tokens.filter((t) => t.category === 'CAT_RNC').length + 1}`,
        originalValue: rawVal,
        category: 'CAT_RNC',
        dataType: 'rnc',
        confidence: check.isValid ? 0.97 : 0.8,
        status: 'PENDIENTE',
        startIndex: match.index,
        endIndex: match.index + rawVal.length,
      });
    }
  }

  // 3. Detect Dominican Companies (S.R.L., S.A., S.A.S., E.I.R.L.)
  const companyRegex = /\b([A-ZÁÉÍÓÚÑ0-9\s.,&-]+(?:\s+S\.?R\.?L\.?|\s+S\.?A\.?|\s+S\.?A\.?S\.?|\s+E\.?I\.?R\.?L\.?))\b/g;
  while ((match = companyRegex.exec(text)) !== null) {
    const rawVal = match[1].trim();
    if (rawVal.length > 4 && rawVal.length < 60 && !tokens.some((t) => t.originalValue === rawVal)) {
      tokens.push({
        id: `det_${tokenCounter++}`,
        tag: normalizeVariableTag(`empresa_${rawVal.split(' ')[0]}`),
        label: `Razón Social: ${rawVal}`,
        originalValue: rawVal,
        category: 'CAT_COMPANY',
        dataType: 'company',
        confidence: 0.93,
        status: 'PENDIENTE',
        startIndex: match.index,
        endIndex: match.index + rawVal.length,
      });
    }
  }

  // 4. Detect Financial Amounts (RD$, US$, EUR, DOP)
  const amountRegex = /(?:RD\$|US\$|EUR|€|\$)\s*([\d,]+(?:\.\d{2})?)/gi;
  while ((match = amountRegex.exec(text)) !== null) {
    const fullMatch = match[0];
    const numPart = match[1].replace(/,/g, '');
    const num = parseFloat(numPart);
    if (!isNaN(num) && num > 0 && !tokens.some((t) => t.originalValue === fullMatch)) {
      const isDOP = fullMatch.includes('RD') || fullMatch.includes('$');
      tokens.push({
        id: `det_${tokenCounter++}`,
        tag: `monto_${tokens.filter((t) => t.category === 'CAT_AMOUNT').length + 1}`,
        label: `Monto Monetario (${isDOP ? 'DOP' : 'USD'})`,
        originalValue: fullMatch,
        category: 'CAT_AMOUNT',
        dataType: 'currency',
        confidence: 0.94,
        status: 'PENDIENTE',
        startIndex: match.index,
        endIndex: match.index + fullMatch.length,
      });
    }
  }

  // 5. Detect Notarial Solemn Dates & Standard Dates
  const notarialDateRegex = /(?:a los\s+[a-záéíóúñ\(\)\s0-9]+\s+días del mes de\s+[a-záéíóúñ]+\s+del año\s+[a-záéíóúñ\(\)\s0-9]+)/gi;
  while ((match = notarialDateRegex.exec(text)) !== null) {
    const rawVal = match[0];
    if (!tokens.some((t) => t.originalValue === rawVal)) {
      tokens.push({
        id: `det_${tokenCounter++}`,
        tag: 'fecha_contrato_notarial',
        label: 'Fecha Notarial Solemne',
        originalValue: rawVal,
        category: 'CAT_DATE',
        dataType: 'date',
        confidence: 0.96,
        status: 'PENDIENTE',
        startIndex: match.index,
        endIndex: match.index + rawVal.length,
      });
    }
  }

  const standardDateRegex = /\b(\d{1,2}\s+de\s+(?:enero|febrero|marzo|abril|mayo|junio|julio|agosto|septiembre|octubre|noviembre|diciembre)\s+(?:de|del)\s+\d{4}|\d{1,2}\/\d{1,2}\/\d{4})\b/gi;
  while ((match = standardDateRegex.exec(text)) !== null) {
    const rawVal = match[1];
    if (!tokens.some((t) => t.originalValue === rawVal)) {
      tokens.push({
        id: `det_${tokenCounter++}`,
        tag: `fecha_evento_${tokens.filter((t) => t.category === 'CAT_DATE').length + 1}`,
        label: `Fecha ${rawVal}`,
        originalValue: rawVal,
        category: 'CAT_DATE',
        dataType: 'date',
        confidence: 0.91,
        status: 'PENDIENTE',
        startIndex: match.index,
        endIndex: match.index + rawVal.length,
      });
    }
  }

  // 6. Detect Legal Parties (ENTRE: el señor / la señora [NOMBRE])
  const partiesRegex = /(?:el señor|la señora|el ciudadano|la ciudadana|comparece|representada por)\s+([A-ZÁÉÍÓÚÑ][a-záéíóúñA-ZÁÉÍÓÚÑ]+(?:\s+[A-ZÁÉÍÓÚÑ][a-záéíóúñA-ZÁÉÍÓÚÑ]+){1,4})/gi;
  while ((match = partiesRegex.exec(text)) !== null) {
    const fullMatch = match[0];
    const nameOnly = match[1].trim();

    // Avoid false positives with common Dominican legal words
    const banned = ['República Dominicana', 'Código Civil', 'Distrito Nacional', 'Notario Público', 'Santo Domingo'];
    if (!banned.includes(nameOnly) && nameOnly.split(' ').length >= 2) {
      const isFemale = fullMatch.toLowerCase().includes('la señora') || fullMatch.toLowerCase().includes('la ciudadana');
      const gender: GenderType = isFemale ? 'femenino' : 'masculino';

      let role: LegalRole = 'generico';
      const surroundingContext = text.slice(Math.max(0, match.index - 100), Math.min(text.length, match.index + 200)).toLowerCase();
      if (surroundingContext.includes('propietario') || surroundingContext.includes('arrendador')) {
        role = 'arrendador';
      } else if (surroundingContext.includes('inquilino') || surroundingContext.includes('arrendatario')) {
        role = 'arrendatario';
      } else if (surroundingContext.includes('vendedor')) {
        role = 'vendedor';
      } else if (surroundingContext.includes('comprador')) {
        role = 'comprador';
      } else if (surroundingContext.includes('notario')) {
        role = 'notario';
      }

      if (!tokens.some((t) => t.originalValue === nameOnly)) {
        const count = tokens.filter((t) => t.category === 'CAT_NAME').length + 1;
        const tag = role !== 'generico' ? `${role}_nombre` : `persona_${count}_nombre`;

        tokens.push({
          id: `det_${tokenCounter++}`,
          tag: normalizeVariableTag(tag),
          label: `Nombre: ${nameOnly} (${role !== 'generico' ? role : 'Parte ' + count})`,
          originalValue: nameOnly,
          category: 'CAT_NAME',
          dataType: 'person',
          confidence: 0.92,
          gender,
          role,
          status: 'PENDIENTE',
          startIndex: match.index,
          endIndex: match.index + nameOnly.length,
        });
      }
    }
  }

  // 7. Detect Dominican Addresses
  const addressRegex = /(?:calle|avenida|av\.|residencial|urbanización|edificio)\s+([A-ZÁÉÍÓÚÑ0-9\s.,#-]+?(?:No\.?\s*\d+|Sector\s+[\w\s]+|Santo Domingo|Santiago|La Vega|Punta Cana|Bávaro)[^.;\n]*)/gi;
  while ((match = addressRegex.exec(text)) !== null) {
    const rawVal = match[0].trim();
    if (rawVal.length > 10 && rawVal.length < 100 && !tokens.some((t) => t.originalValue === rawVal)) {
      tokens.push({
        id: `det_${tokenCounter++}`,
        tag: `direccion_inmueble_${tokens.filter((t) => t.category === 'CAT_ADDRESS').length + 1}`,
        label: `Dirección de Inmueble / Domicilio`,
        originalValue: rawVal,
        category: 'CAT_ADDRESS',
        dataType: 'address',
        confidence: 0.88,
        status: 'PENDIENTE',
        startIndex: match.index,
        endIndex: match.index + rawVal.length,
      });
    }
  }

  return tokens;
}

/**
 * Call Server-Side Gemini endpoint for Deep AI Extraction
 */
export async function detectVariablesWithAI(text: string): Promise<{
  detectedVariables: DetectedToken[];
  detectedClauses: any[];
  legalNotes: string[];
}> {
  try {
    const res = await fetch('/api/analyze-gemini', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ text }),
    });

    if (!res.ok) {
      throw new Error(`AI extraction failed with HTTP ${res.status}`);
    }

    const json = await res.json();
    if (!json.success || !json.data) {
      throw new Error(json.error || 'Invalid AI response');
    }

    const aiTokens: DetectedToken[] = (json.data.detectedVariables || []).map((item: any, idx: number) => ({
      id: `ai_det_${idx + 1}`,
      tag: normalizeVariableTag(item.tag || `var_${idx + 1}`),
      label: item.label || item.tag,
      originalValue: item.originalValue || '',
      category: item.category || 'CAT_CUSTOM',
      dataType: item.dataType || 'string',
      confidence: item.confidence ?? 0.95,
      gender: item.gender,
      role: item.role,
      status: 'PENDIENTE',
    }));

    return {
      detectedVariables: aiTokens,
      detectedClauses: json.data.detectedClauses || [],
      legalNotes: json.data.legalConsistencyNotes || [],
    };
  } catch (err: any) {
    console.warn('AI Extraction unavailable, fallback to local NLP engine:', err.message);
    const localTokens = detectVariablesLocally(text);
    return {
      detectedVariables: localTokens,
      detectedClauses: [],
      legalNotes: ['Procesamiento local completado (Motor determinista Regex + Reglas jurídicas RD)'],
    };
  }
}
