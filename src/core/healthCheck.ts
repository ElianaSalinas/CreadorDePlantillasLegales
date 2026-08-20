import { LegalTemplate, HealthCheckResult } from '../types';
import { extractReferencedVariables } from './variableEngine';
import { detectCircularDependencies } from './ruleEngine';

/**
 * Executes comprehensive Template Health Check
 * Complies with US-56..US-60 and RN-067..RN-071
 */
export function runTemplateHealthCheck(template: LegalTemplate): HealthCheckResult {
  const referencedInBody = extractReferencedVariables(template.content);

  // Also extract referenced variables inside included clauses
  const referencedInClauses = new Set<string>();
  for (const clause of template.clauses) {
    for (const v of clause.variablesReferenced || []) {
      referencedInClauses.add(v.toLowerCase());
    }
  }

  const allReferencedTags = new Set([...referencedInBody, ...referencedInClauses]);
  const declaredTags = new Set(template.variables.map((v) => v.tag.toLowerCase()));

  // 1. Detect Orphan Variables (Declared but never referenced)
  const orphanVariables: string[] = [];
  for (const v of template.variables) {
    if (!allReferencedTags.has(v.tag.toLowerCase())) {
      orphanVariables.push(v.tag);
    }
  }

  // 2. Detect Missing Variables (Referenced in content/clauses but not declared in template.variables)
  const missingVariableReferences: string[] = [];
  for (const ref of allReferencedTags) {
    if (!declaredTags.has(ref)) {
      missingVariableReferences.push(ref);
    }
  }

  // 3. Detect Missing Clause References
  const missingClauseReferences: string[] = [];
  const clauseRegex = /\{\{#clause:([a-z0-9_]+)\}\}/gi;
  let match;
  while ((match = clauseRegex.exec(template.content)) !== null) {
    const clauseId = match[1];
    if (!template.clauses.some((c) => c.id === clauseId)) {
      missingClauseReferences.push(clauseId);
    }
  }

  // 4. Validate Rules (check targetVariableId and payload references exist)
  const invalidRules: { ruleId: string; reason: string }[] = [];
  for (const rule of template.rules) {
    if (!declaredTags.has(rule.targetVariableId.toLowerCase())) {
      invalidRules.push({
        ruleId: rule.id,
        reason: `La regla "${rule.name}" hace referencia a la variable inexistente "${rule.targetVariableId}"`,
      });
    }

    if (rule.action === 'SHOW_CLAUSE' || rule.action === 'HIDE_CLAUSE') {
      const cId = rule.actionPayload.clauseId;
      if (cId && !template.clauses.some((c) => c.id === cId)) {
        invalidRules.push({
          ruleId: rule.id,
          reason: `La regla "${rule.name}" hace referencia a la cláusula inexistente "${cId}"`,
        });
      }
    }
  }

  // 5. Detect Circular Dependencies (RN-034)
  const circularDependencies = detectCircularDependencies(template.rules, template.variables);

  // Compile Errors & Warnings
  const errors: string[] = [];
  const warnings: string[] = [];

  if (missingVariableReferences.length > 0) {
    errors.push(
      `Variables no declaradas en la plantilla (${missingVariableReferences.length}): ${missingVariableReferences.join(', ')}`
    );
  }

  if (missingClauseReferences.length > 0) {
    errors.push(
      `Cláusulas referenciadas pero inexistentes (${missingClauseReferences.length}): ${missingClauseReferences.join(', ')}`
    );
  }

  if (invalidRules.length > 0) {
    for (const ir of invalidRules) {
      errors.push(`Error en regla: ${ir.reason}`);
    }
  }

  if (circularDependencies.length > 0) {
    errors.push(`Dependencia circular detectada: ${circularDependencies.join('; ')}`);
  }

  if (orphanVariables.length > 0) {
    warnings.push(
      `Variables declaradas pero no utilizadas en el documento (${orphanVariables.length}): ${orphanVariables.join(', ')}`
    );
  }

  const status = errors.length > 0 ? 'ERROR' : warnings.length > 0 ? 'WARNING' : 'HEALTHY';
  const canPublish = errors.length === 0;

  // Compute overall health score
  let score = 100;
  score -= errors.length * 25;
  score -= warnings.length * 10;
  score = Math.max(0, Math.min(100, score));

  return {
    status,
    score,
    totalVariables: template.variables.length,
    usedVariables: allReferencedTags.size,
    orphanVariables,
    missingVariableReferences,
    totalClauses: template.clauses.length,
    missingClauseReferences,
    totalRules: template.rules.length,
    invalidRules,
    circularDependencies,
    amountConsistencyWarnings: [],
    canPublish,
    errors,
    warnings,
  };
}
