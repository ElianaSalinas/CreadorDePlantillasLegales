import { ConditionalRule, RuleOperator, TemplateVariable, LegalClause } from '../types';

/**
 * Evaluates an individual binary condition
 */
export function evaluateCondition(actualValue: any, operator: RuleOperator, compareValue: any): boolean {
  if (actualValue === undefined || actualValue === null) {
    if (operator === 'is_empty') return true;
    if (operator === 'not_equals') return true;
    return false;
  }

  switch (operator) {
    case 'equals':
      // eslint-disable-next-line eqeqeq
      return actualValue == compareValue;
    case 'not_equals':
      // eslint-disable-next-line eqeqeq
      return actualValue != compareValue;
    case 'contains':
      return String(actualValue).toLowerCase().includes(String(compareValue).toLowerCase());
    case 'greater_than':
      return Number(actualValue) > Number(compareValue);
    case 'less_than':
      return Number(actualValue) < Number(compareValue);
    case 'exists':
      return actualValue !== '' && actualValue !== null && actualValue !== undefined;
    case 'is_empty':
      return actualValue === '' || actualValue === null || actualValue === undefined;
    case 'in_list': {
      const list = Array.isArray(compareValue)
        ? compareValue
        : String(compareValue).split(',').map((s) => s.trim().toLowerCase());
      return list.includes(String(actualValue).toLowerCase());
    }
    default:
      return false;
  }
}

export interface RuleEvaluationResult {
  visibleClauseIds: Set<string>;
  hiddenClauseIds: Set<string>;
  requiredVariableIds: Set<string>;
  optionalVariableIds: Set<string>;
  computedValues: Record<string, any>;
  warnings: string[];
  errors: string[];
}

/**
 * Evaluates all conditional rules given current form values
 */
export function evaluateAllRules(
  rules: ConditionalRule[],
  formValues: Record<string, any>,
  variables: TemplateVariable[],
  clauses: LegalClause[]
): RuleEvaluationResult {
  const result: RuleEvaluationResult = {
    visibleClauseIds: new Set(clauses.filter((c) => !c.conditionVariableId).map((c) => c.id)),
    hiddenClauseIds: new Set(),
    requiredVariableIds: new Set(variables.filter((v) => v.required).map((v) => v.tag)),
    optionalVariableIds: new Set(variables.filter((v) => !v.required).map((v) => v.tag)),
    computedValues: {},
    warnings: [],
    errors: [],
  };

  // Add clauses with natural default condition match
  for (const clause of clauses) {
    if (clause.conditionVariableId) {
      const val = formValues[clause.conditionVariableId];
      const match =
        clause.conditionExpectedValue !== undefined
          ? val === clause.conditionExpectedValue
          : Boolean(val);
      if (match) {
        result.visibleClauseIds.add(clause.id);
      } else {
        result.hiddenClauseIds.add(clause.id);
        result.visibleClauseIds.delete(clause.id);
      }
    }
  }

  for (const rule of rules) {
    if (!rule.isActive) continue;

    const actualVal = formValues[rule.targetVariableId];
    const isSatisfied = evaluateCondition(actualVal, rule.operator, rule.compareValue);

    if (isSatisfied) {
      switch (rule.action) {
        case 'SHOW_CLAUSE':
          if (rule.actionPayload.clauseId) {
            result.visibleClauseIds.add(rule.actionPayload.clauseId);
            result.hiddenClauseIds.delete(rule.actionPayload.clauseId);
          }
          break;
        case 'HIDE_CLAUSE':
          if (rule.actionPayload.clauseId) {
            result.hiddenClauseIds.add(rule.actionPayload.clauseId);
            result.visibleClauseIds.delete(rule.actionPayload.clauseId);
          }
          break;
        case 'REQUIRE_VARIABLE':
          if (rule.actionPayload.variableId) {
            result.requiredVariableIds.add(rule.actionPayload.variableId);
            result.optionalVariableIds.delete(rule.actionPayload.variableId);
          }
          break;
        case 'OPTIONAL_VARIABLE':
          if (rule.actionPayload.variableId) {
            result.optionalVariableIds.add(rule.actionPayload.variableId);
            result.requiredVariableIds.delete(rule.actionPayload.variableId);
          }
          break;
        case 'SET_VALUE':
          if (rule.actionPayload.variableId && rule.actionPayload.value !== undefined) {
            result.computedValues[rule.actionPayload.variableId] = rule.actionPayload.value;
          }
          break;
        case 'WARN_USER':
          if (rule.actionPayload.message) {
            result.warnings.push(rule.actionPayload.message);
          }
          break;
        default:
          break;
      }
    }
  }

  return result;
}

/**
 * Detects circular dependencies in rules and derived variables
 * RN-034
 */
export function detectCircularDependencies(
  rules: ConditionalRule[],
  variables: TemplateVariable[]
): string[] {
  const adjList = new Map<string, string[]>();

  // Add derived dependencies
  for (const v of variables) {
    if (v.derivedConfig) {
      const src = v.derivedConfig.sourceVariableId;
      const target = v.tag;
      if (!adjList.has(src)) adjList.set(src, []);
      adjList.get(src)!.push(target);
    }
  }

  // Add rule dependencies (targetVariable -> actionPayload.variableId)
  for (const r of rules) {
    if (r.action === 'SET_VALUE' && r.actionPayload.variableId) {
      const src = r.targetVariableId;
      const target = r.actionPayload.variableId;
      if (!adjList.has(src)) adjList.set(src, []);
      adjList.get(src)!.push(target);
    }
  }

  const visited = new Set<string>();
  const recStack = new Set<string>();
  const cycles: string[] = [];

  function dfs(node: string, path: string[]) {
    visited.add(node);
    recStack.add(node);

    const neighbors = adjList.get(node) || [];
    for (const neighbor of neighbors) {
      if (!visited.has(neighbor)) {
        dfs(neighbor, [...path, neighbor]);
      } else if (recStack.has(neighbor)) {
        cycles.push([...path, neighbor].join(' ➔ '));
      }
    }

    recStack.delete(node);
  }

  for (const node of adjList.keys()) {
    if (!visited.has(node)) {
      dfs(node, [node]);
    }
  }

  return cycles;
}
