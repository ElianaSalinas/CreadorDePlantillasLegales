import React, { useState } from 'react';
import {
  Settings,
  Plus,
  Trash2,
  AlertTriangle,
  CheckCircle2,
  ArrowRight,
  GitBranch,
  ShieldAlert,
  Play,
  X,
} from 'lucide-react';
import { useAppStore } from '../store/useAppStore';
import { ConditionalRule, RuleAction, RuleOperator } from '../types';
import { detectCircularDependencies } from '../core/ruleEngine';

export const RuleBuilder: React.FC = () => {
  const { activeTemplate, addRule, updateRule, deleteRule, setView } = useAppStore();

  const [isCreatingNew, setIsCreatingNew] = useState(false);
  const [editingRule, setEditingRule] = useState<ConditionalRule | null>(null);

  // Form states
  const [formName, setFormName] = useState('');
  const [formTargetVar, setFormTargetVar] = useState('');
  const [formOperator, setFormOperator] = useState<RuleOperator>('equals');
  const [formCompareVal, setFormCompareVal] = useState('true');
  const [formAction, setFormAction] = useState<RuleAction>('SHOW_CLAUSE');
  const [formPayloadTarget, setFormPayloadTarget] = useState('');

  if (!activeTemplate) {
    return (
      <div className="max-w-4xl mx-auto py-16 text-center">
        <p className="text-slate-500 dark:text-slate-400">Selecciona una plantilla para configurar sus reglas condicionales.</p>
        <button
          onClick={() => setView('TEMPLATES')}
          className="mt-4 px-4 py-2 bg-[#0D2C24] hover:bg-[#164E3E] text-white text-xs font-semibold rounded-xl cursor-pointer"
        >
          Ver Plantillas
        </button>
      </div>
    );
  }

  const circularWarnings = detectCircularDependencies(activeTemplate.rules, activeTemplate.variables);

  const resetForm = () => {
    setFormName('');
    setFormTargetVar(activeTemplate.variables[0]?.tag || '');
    setFormOperator('equals');
    setFormCompareVal('true');
    setFormAction('SHOW_CLAUSE');
    setFormPayloadTarget(activeTemplate.clauses[0]?.id || '');
    setEditingRule(null);
    setIsCreatingNew(false);
  };

  const handleOpenCreate = () => {
    resetForm();
    setIsCreatingNew(true);
  };

  const handleSave = (e: React.FormEvent) => {
    e.preventDefault();

    let compVal: any = formCompareVal;
    if (formCompareVal === 'true') compVal = true;
    if (formCompareVal === 'false') compVal = false;
    if (!isNaN(Number(formCompareVal)) && formCompareVal.trim() !== '') {
      compVal = Number(formCompareVal);
    }

    const payload: ConditionalRule = {
      id: editingRule?.id || `rule_${Date.now()}`,
      name: formName || `Regla sobre ${formTargetVar}`,
      targetVariableId: formTargetVar,
      operator: formOperator,
      compareValue: compVal,
      action: formAction,
      actionPayload:
        formAction === 'SHOW_CLAUSE' || formAction === 'HIDE_CLAUSE'
          ? { clauseId: formPayloadTarget }
          : { variableId: formPayloadTarget },
      isActive: true,
    };

    if (editingRule) {
      updateRule(activeTemplate.id, editingRule.id, payload);
    } else {
      addRule(activeTemplate.id, payload);
    }

    resetForm();
  };

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-6">
      {/* Top Banner with SAVE Theme */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 bg-white dark:bg-slate-900 p-6 rounded-2xl shadow-xs border border-[#E8E5DF] dark:border-slate-800">
        <div>
          <div className="flex items-center space-x-2">
            <span className="text-xs font-bold text-[#0D2C24] dark:text-emerald-400 uppercase tracking-wider bg-[#F5F2ED] dark:bg-slate-800 px-2.5 py-0.5 rounded-md border border-[#E8E5DF] dark:border-slate-700">
              Motor de Reglas Condicionales (RN-030..RN-035)
            </span>
            <span className="text-xs text-slate-400 font-mono">Reglas activas: {activeTemplate.rules.length}</span>
          </div>
          <h1 className="text-2xl font-bold text-slate-900 dark:text-white font-serif mt-1">
            Lógica Condicional • {activeTemplate.name}
          </h1>
          <p className="text-slate-500 dark:text-slate-400 text-xs mt-1">
            Define comportamientos dinámicos: muestra cláusulas o requiere campos basándote en las respuestas del compareciente.
          </p>
        </div>

        <button
          onClick={handleOpenCreate}
          className="flex items-center space-x-2 px-4 py-2.5 rounded-xl text-xs font-bold bg-[#0D2C24] hover:bg-[#164E3E] text-white shadow-sm transition-all cursor-pointer"
        >
          <Plus className="w-4 h-4 text-[#FDE8B5]" />
          <span>Nueva Regla Condicional</span>
        </button>
      </div>

      {/* Circular Dependency Alert (RN-034) */}
      {circularWarnings.length > 0 && (
        <div className="bg-rose-50 dark:bg-rose-950/40 border border-rose-200 dark:border-rose-800 rounded-xl p-4 flex items-start space-x-3">
          <ShieldAlert className="w-5 h-5 text-rose-600 shrink-0 mt-0.5" />
          <div>
            <h4 className="font-bold text-rose-800 dark:text-rose-300 text-sm">Bloqueo de Dependencia Circular Detectado (RN-034)</h4>
            <p className="text-xs text-rose-700 dark:text-rose-400 mt-1">
              Las siguientes reglas generan un ciclo infinito de evaluación y deben corregirse antes de publicar:
            </p>
            <ul className="list-disc list-inside text-xs text-rose-600 dark:text-rose-300 mt-2 space-y-1">
              {circularWarnings.map((warn, i) => (
                <li key={i}>{warn}</li>
              ))}
            </ul>
          </div>
        </div>
      )}

      {/* Rules List */}
      <div className="bg-white dark:bg-slate-900 rounded-2xl border border-[#E8E5DF] dark:border-slate-800 shadow-xs overflow-hidden">
        <div className="bg-[#F5F2ED]/70 dark:bg-slate-800/80 px-5 py-3 border-b border-[#E8E5DF] dark:border-slate-800 flex items-center justify-between">
          <span className="font-semibold text-xs text-slate-800 dark:text-slate-200 tracking-wide uppercase flex items-center space-x-2">
            <GitBranch className="w-3.5 h-3.5 text-[#0D2C24] dark:text-emerald-400" />
            <span>Reglas Configuradas ({activeTemplate.rules.length})</span>
          </span>
        </div>

        <div className="divide-y divide-[#E8E5DF] dark:divide-slate-800">
          {activeTemplate.rules.length === 0 ? (
            <div className="p-12 text-center text-slate-400 text-xs">
              No hay reglas condicionales configuradas en esta plantilla. Haz clic en "Nueva Regla Condicional" para crear una.
            </div>
          ) : (
            activeTemplate.rules.map((rule) => (
              <div
                key={rule.id}
                className="p-5 hover:bg-[#FAFAF8] dark:hover:bg-slate-800/40 transition-colors flex flex-col md:flex-row md:items-center justify-between gap-4"
              >
                <div className="space-y-2">
                  <div className="flex items-center space-x-2">
                    <span className="font-bold text-sm text-slate-900 dark:text-white font-serif">{rule.name}</span>
                    <span
                      className={`text-[10px] px-2 py-0.5 rounded-full font-semibold ${
                        rule.isActive ? 'bg-emerald-50 text-emerald-800 dark:bg-emerald-950 dark:text-emerald-300' : 'bg-slate-100 dark:bg-slate-800 text-slate-500'
                      }`}
                    >
                      {rule.isActive ? 'Activa' : 'Inactiva'}
                    </span>
                  </div>

                  {/* Visual IF-THEN diagram with SAVE colors */}
                  <div className="flex items-center space-x-2 flex-wrap text-xs">
                    <span className="font-bold text-[#0D2C24] dark:text-emerald-400 bg-[#F5F2ED] dark:bg-slate-800 px-2 py-0.5 rounded border border-[#E8E5DF] dark:border-slate-700">
                      SI
                    </span>
                    <span className="font-mono text-slate-800 dark:text-slate-200 font-semibold">{`{{${rule.targetVariableId}}}`}</span>
                    <span className="text-slate-500 dark:text-slate-400 font-serif italic">
                      {rule.operator === 'equals'
                        ? 'es igual a'
                        : rule.operator === 'not_equals'
                        ? 'no es igual a'
                        : rule.operator === 'greater_than'
                        ? 'es mayor que'
                        : rule.operator === 'less_than'
                        ? 'es menor que'
                        : rule.operator}
                    </span>
                    <span className="font-mono bg-[#F5F2ED] dark:bg-slate-800 px-1.5 py-0.5 rounded text-slate-800 dark:text-slate-200 border border-[#E8E5DF] dark:border-slate-700">
                      {String(rule.compareValue)}
                    </span>

                    <ArrowRight className="w-3.5 h-3.5 text-slate-400" />

                    <span className="font-bold text-[#0D2C24] dark:text-emerald-400 bg-[#FDE8B5] px-2 py-0.5 rounded">
                      ENTONCES
                    </span>
                    <span className="font-semibold text-slate-800 dark:text-slate-200">
                      {rule.action === 'SHOW_CLAUSE'
                        ? `Mostrar cláusula [${rule.actionPayload.clauseId}]`
                        : rule.action === 'HIDE_CLAUSE'
                        ? `Ocultar cláusula [${rule.actionPayload.clauseId}]`
                        : rule.action === 'REQUIRE_VARIABLE'
                        ? `Requerir campo obligatorio [${rule.actionPayload.variableId}]`
                        : rule.action}
                    </span>
                  </div>
                </div>

                <div className="flex items-center space-x-2 self-end md:self-center">
                  <button
                    onClick={() => updateRule(activeTemplate.id, rule.id, { isActive: !rule.isActive })}
                    className="text-xs px-2.5 py-1 rounded-xl border border-[#D1CCC4] dark:border-slate-700 hover:bg-[#F5F2ED] dark:hover:bg-slate-800 font-medium text-slate-700 dark:text-slate-300 cursor-pointer"
                  >
                    {rule.isActive ? 'Desactivar' : 'Activar'}
                  </button>

                  <button
                    onClick={() => {
                      if (confirm(`¿Eliminar la regla "${rule.name}"?`)) {
                        deleteRule(activeTemplate.id, rule.id);
                      }
                    }}
                    className="p-1.5 text-slate-400 hover:text-rose-600 hover:bg-rose-50 rounded-md transition-colors cursor-pointer"
                  >
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>
              </div>
            ))
          )}
        </div>
      </div>

      {/* Create / Edit Rule Modal */}
      {isCreatingNew && (
        <div className="fixed inset-0 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4 z-50 animate-in fade-in">
          <div className="bg-white dark:bg-slate-900 rounded-2xl max-w-lg w-full p-6 shadow-2xl border border-[#E8E5DF] dark:border-slate-800 max-h-[90vh] overflow-y-auto">
            <div className="flex items-center justify-between pb-4 border-b border-[#E8E5DF] dark:border-slate-800">
              <h3 className="font-serif font-bold text-lg text-slate-900 dark:text-white">
                {editingRule ? 'Editar Regla Condicional' : 'Nueva Regla Condicional (IF-THEN)'}
              </h3>
              <button onClick={resetForm} className="text-slate-400 hover:text-slate-600 dark:hover:text-white cursor-pointer">
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleSave} className="space-y-4 pt-4 text-xs">
              <div>
                <label className="block font-semibold text-slate-700 dark:text-slate-300 mb-1">Nombre Descriptivo de la Regla</label>
                <input
                  type="text"
                  required
                  value={formName}
                  onChange={(e) => setFormName(e.target.value)}
                  placeholder="ej. Mostrar cuota de mantenimiento si aplica condominio"
                  className="w-full px-3 py-2 border border-[#D1CCC4] dark:border-slate-700 dark:bg-slate-800 dark:text-white rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0D2C24]"
                />
              </div>

              {/* Condición (IF) */}
              <div className="bg-[#F5F2ED]/70 dark:bg-slate-800/80 p-3.5 rounded-xl border border-[#D1CCC4] dark:border-slate-700 space-y-3">
                <span className="font-bold text-[#0D2C24] dark:text-emerald-400 uppercase tracking-wider text-[11px] block">
                  Condición (SI...)
                </span>

                <div>
                  <label className="block font-medium text-slate-700 dark:text-slate-300 mb-1">Variable Evaluada</label>
                  <select
                    value={formTargetVar}
                    onChange={(e) => setFormTargetVar(e.target.value)}
                    className="w-full px-3 py-2 bg-white dark:bg-slate-900 border border-[#D1CCC4] dark:border-slate-700 rounded-xl text-xs dark:text-white"
                  >
                    {activeTemplate.variables.map((v) => (
                      <option key={v.id} value={v.tag}>
                        {v.label} ({`{{${v.tag}}}`})
                      </option>
                    ))}
                  </select>
                </div>

                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <label className="block font-medium text-slate-700 dark:text-slate-300 mb-1">Operador</label>
                    <select
                      value={formOperator}
                      onChange={(e) => setFormOperator(e.target.value as RuleOperator)}
                      className="w-full px-3 py-2 bg-white dark:bg-slate-900 border border-[#D1CCC4] dark:border-slate-700 rounded-xl text-xs dark:text-white"
                    >
                      <option value="equals">Es igual a (=)</option>
                      <option value="not_equals">No es igual a (!=)</option>
                      <option value="greater_than">Es mayor que (&gt;)</option>
                      <option value="less_than">Es menor que (&lt;)</option>
                      <option value="is_empty">Está vacío</option>
                      <option value="is_not_empty">No está vacío</option>
                    </select>
                  </div>

                  <div>
                    <label className="block font-medium text-slate-700 dark:text-slate-300 mb-1">Valor de Comparación</label>
                    <input
                      type="text"
                      value={formCompareVal}
                      onChange={(e) => setFormCompareVal(e.target.value)}
                      placeholder="true, false o número"
                      className="w-full px-3 py-2 bg-white dark:bg-slate-900 border border-[#D1CCC4] dark:border-slate-700 rounded-xl text-xs dark:text-white"
                    />
                  </div>
                </div>
              </div>

              {/* Acción (THEN) */}
              <div className="bg-[#F5F2ED]/70 dark:bg-slate-800/80 p-3.5 rounded-xl border border-[#D1CCC4] dark:border-slate-700 space-y-3">
                <span className="font-bold text-[#0D2C24] dark:text-emerald-400 uppercase tracking-wider text-[11px] block">
                  Acción a Ejecutar (ENTONCES...)
                </span>

                <div>
                  <label className="block font-medium text-slate-700 dark:text-slate-300 mb-1">Acción</label>
                  <select
                    value={formAction}
                    onChange={(e) => {
                      const act = e.target.value as RuleAction;
                      setFormAction(act);
                      if (act === 'SHOW_CLAUSE' || act === 'HIDE_CLAUSE') {
                        setFormPayloadTarget(activeTemplate.clauses[0]?.id || '');
                      } else {
                        setFormPayloadTarget(activeTemplate.variables[0]?.tag || '');
                      }
                    }}
                    className="w-full px-3 py-2 bg-white dark:bg-slate-900 border border-[#D1CCC4] dark:border-slate-700 rounded-xl text-xs dark:text-white"
                  >
                    <option value="SHOW_CLAUSE">Mostrar Cláusula Jurídica</option>
                    <option value="HIDE_CLAUSE">Ocultar Cláusula Jurídica</option>
                    <option value="REQUIRE_VARIABLE">Marcar Variable como Obligatoria</option>
                    <option value="HIDE_VARIABLE">Ocultar Campo en Formulario</option>
                  </select>
                </div>

                <div>
                  <label className="block font-medium text-slate-700 dark:text-slate-300 mb-1">
                    {formAction === 'SHOW_CLAUSE' || formAction === 'HIDE_CLAUSE'
                      ? 'Cláusula Destino'
                      : 'Variable Destino'}
                  </label>
                  {formAction === 'SHOW_CLAUSE' || formAction === 'HIDE_CLAUSE' ? (
                    <select
                      value={formPayloadTarget}
                      onChange={(e) => setFormPayloadTarget(e.target.value)}
                      className="w-full px-3 py-2 bg-white dark:bg-slate-900 border border-[#D1CCC4] dark:border-slate-700 rounded-xl text-xs dark:text-white"
                    >
                      {activeTemplate.clauses.map((c) => (
                        <option key={c.id} value={c.id}>
                          {c.title} ({c.id})
                        </option>
                      ))}
                    </select>
                  ) : (
                    <select
                      value={formPayloadTarget}
                      onChange={(e) => setFormPayloadTarget(e.target.value)}
                      className="w-full px-3 py-2 bg-white dark:bg-slate-900 border border-[#D1CCC4] dark:border-slate-700 rounded-xl text-xs dark:text-white"
                    >
                      {activeTemplate.variables.map((v) => (
                        <option key={v.id} value={v.tag}>
                          {v.label} ({`{{${v.tag}}}`})
                        </option>
                      ))}
                    </select>
                  )}
                </div>
              </div>

              {/* Buttons */}
              <div className="flex justify-end space-x-2 pt-4 border-t border-[#E8E5DF] dark:border-slate-800">
                <button
                  type="button"
                  onClick={resetForm}
                  className="px-4 py-2 rounded-xl text-xs font-semibold bg-[#F5F2ED] dark:bg-slate-800 hover:bg-[#E8E5DF] text-slate-700 dark:text-slate-300 cursor-pointer"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 rounded-xl text-xs font-bold bg-[#0D2C24] hover:bg-[#164E3E] text-white shadow-sm cursor-pointer"
                >
                  Guardar Regla
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
