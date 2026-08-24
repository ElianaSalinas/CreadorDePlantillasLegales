import React, { useState } from 'react';
import {
  Layers,
  Plus,
  Edit2,
  Trash2,
  AlertCircle,
  CheckCircle2,
  Calculator,
  Search,
  Sparkles,
  Shield,
  HelpCircle,
  X,
} from 'lucide-react';
import { useAppStore } from '../store/useAppStore';
import {
  TemplateVariable,
  VariableCategory,
  VariableDataType,
  CurrencyCode,
  GenderType,
  LegalRole,
} from '../types';
import {
  normalizeVariableTag,
  isValidVariableTag,
  groupVariablesByCategory,
  extractReferencedVariables,
} from '../core/variableEngine';

export const VariableManager: React.FC = () => {
  const { activeTemplate, addVariable, updateVariable, deleteVariable, setView } = useAppStore();

  const [searchQuery, setSearchQuery] = useState('');
  const [editingVariable, setEditingVariable] = useState<TemplateVariable | null>(null);
  const [isCreatingNew, setIsCreatingNew] = useState(false);

  // Form fields for create/edit
  const [formTag, setFormTag] = useState('');
  const [formLabel, setFormLabel] = useState('');
  const [formCategory, setFormCategory] = useState<VariableCategory>('CAT_NAME');
  const [formDataType, setFormDataType] = useState<VariableDataType>('string');
  const [formRequired, setFormRequired] = useState(true);
  const [formDefaultValue, setFormDefaultValue] = useState('');
  const [formCurrency, setFormCurrency] = useState<CurrencyCode>('DOP');
  const [formRole, setFormRole] = useState<LegalRole>('generico');
  const [formGender, setFormGender] = useState<GenderType>('no_especificado');

  // Derived config state
  const [isDerived, setIsDerived] = useState(false);
  const [derivedSourceId, setDerivedSourceId] = useState('');
  const [derivedTransformType, setDerivedTransformType] = useState<
    'amount_in_words' | 'date_in_words' | 'format_currency' | 'format_cedula' | 'multiply' | 'calculate_months'
  >('amount_in_words');
  const [derivedFactor, setDerivedFactor] = useState(2);

  if (!activeTemplate) {
    return (
      <div className="max-w-4xl mx-auto py-16 text-center">
        <p className="text-slate-500 dark:text-slate-400">Selecciona una plantilla para administrar sus variables.</p>
        <button
          onClick={() => setView('TEMPLATES')}
          className="mt-4 px-4 py-2 bg-[#0D2C24] hover:bg-[#164E3E] text-white text-xs font-semibold rounded-xl cursor-pointer"
        >
          Ver Plantillas
        </button>
      </div>
    );
  }

  const referencedTags = new Set(extractReferencedVariables(activeTemplate.content));
  const groupedVars = groupVariablesByCategory(activeTemplate.variables);

  const resetForm = () => {
    setFormTag('');
    setFormLabel('');
    setFormCategory('CAT_NAME');
    setFormDataType('string');
    setFormRequired(true);
    setFormDefaultValue('');
    setFormCurrency('DOP');
    setFormRole('generico');
    setFormGender('no_especificado');
    setIsDerived(false);
    setDerivedSourceId(activeTemplate.variables[0]?.tag || '');
    setDerivedTransformType('amount_in_words');
    setDerivedFactor(2);
    setEditingVariable(null);
    setIsCreatingNew(false);
  };

  const handleOpenCreate = () => {
    resetForm();
    setIsCreatingNew(true);
  };

  const handleOpenEdit = (v: TemplateVariable) => {
    setEditingVariable(v);
    setFormTag(v.tag);
    setFormLabel(v.label);
    setFormCategory(v.category);
    setFormDataType(v.dataType);
    setFormRequired(v.required);
    setFormDefaultValue(v.defaultValue !== undefined ? String(v.defaultValue) : '');
    setFormCurrency(v.currency || 'DOP');
    setFormRole(v.role || 'generico');
    setFormGender(v.gender || 'no_especificado');

    if (v.derivedConfig) {
      setIsDerived(true);
      setDerivedSourceId(v.derivedConfig.sourceVariableId);
      setDerivedTransformType(v.derivedConfig.transformType as any);
      setDerivedFactor(v.derivedConfig.params?.factor || 2);
    } else {
      setIsDerived(false);
    }
    setIsCreatingNew(true);
  };

  const handleSaveVariable = (e: React.FormEvent) => {
    e.preventDefault();

    const normalizedTag = normalizeVariableTag(formTag);
    if (!isValidVariableTag(normalizedTag)) {
      alert('El identificador debe estar en snake_case (ej. inquilino_nombre, solo minúsculas y guiones bajos)');
      return;
    }

    const variablePayload: TemplateVariable = {
      id: editingVariable?.id || `v_${Date.now()}_${Math.random().toString(36).substr(2, 4)}`,
      tag: normalizedTag,
      label: formLabel || normalizedTag,
      category: formCategory,
      dataType: formDataType,
      required: formRequired,
      defaultValue: formDefaultValue || undefined,
      currency: formDataType === 'currency' ? formCurrency : undefined,
      role: formRole !== 'generico' ? formRole : undefined,
      gender: formGender !== 'no_especificado' ? formGender : undefined,
      derivedConfig: isDerived
        ? {
            sourceVariableId: derivedSourceId,
            transformType: derivedTransformType,
            params: derivedTransformType === 'multiply' ? { factor: Number(derivedFactor) } : undefined,
          }
        : undefined,
    };

    if (editingVariable) {
      updateVariable(activeTemplate.id, editingVariable.id, variablePayload);
    } else {
      addVariable(activeTemplate.id, variablePayload);
    }

    resetForm();
  };

  const handleDelete = (v: TemplateVariable) => {
    const isUsed = referencedTags.has(v.tag);
    const msg = isUsed
      ? `La variable {{${v.tag}}} está actualmente referenciada en el texto de la plantilla. ¿Seguro que deseas eliminarla? (Provocará una referencia no definida)`
      : `¿Eliminar la variable {{${v.tag}}}?`;

    if (confirm(msg)) {
      deleteVariable(activeTemplate.id, v.id);
    }
  };

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-6">
      {/* Header with SAVE aesthetics */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 bg-white dark:bg-slate-900 p-6 rounded-2xl shadow-xs border border-[#E8E5DF] dark:border-slate-800">
        <div>
          <div className="flex items-center space-x-2">
            <span className="text-xs font-bold text-[#0D2C24] dark:text-emerald-400 uppercase tracking-wider bg-[#F5F2ED] dark:bg-slate-800 px-2.5 py-0.5 rounded-md border border-[#E8E5DF] dark:border-slate-700">
              Motor de Variables Notariales (RN-005, RN-073)
            </span>
            <span className="text-xs text-slate-400 font-mono">Total: {activeTemplate.variables.length}</span>
          </div>
          <h1 className="text-2xl font-bold text-slate-900 dark:text-white font-serif mt-1">
            Diccionario de Variables • {activeTemplate.name}
          </h1>
          <p className="text-slate-500 dark:text-slate-400 text-xs mt-1">
            Toda variable lógica representa un único dato en minúsculas snake_case, reutilizable en múltiples cláusulas con propagación atómica.
          </p>
        </div>

        <button
          onClick={handleOpenCreate}
          className="flex items-center space-x-2 px-4 py-2.5 rounded-xl text-xs font-bold bg-[#0D2C24] hover:bg-[#164E3E] text-white shadow-sm transition-all cursor-pointer"
        >
          <Plus className="w-4 h-4 text-[#FDE8B5]" />
          <span>Nueva Variable</span>
        </button>
      </div>

      {/* Variables List by Categories */}
      <div className="space-y-6">
        {Object.entries(groupedVars).map(([categoryTitle, vars]) => {
          const filteredVars = vars.filter(
            (v) =>
              v.tag.toLowerCase().includes(searchQuery.toLowerCase()) ||
              v.label.toLowerCase().includes(searchQuery.toLowerCase())
          );

          if (filteredVars.length === 0) return null;

          return (
            <div key={categoryTitle} className="bg-white dark:bg-slate-900 rounded-2xl border border-[#E8E5DF] dark:border-slate-800 overflow-hidden shadow-xs">
              <div className="bg-[#F5F2ED]/70 dark:bg-slate-800/80 px-5 py-3 border-b border-[#E8E5DF] dark:border-slate-800 flex items-center justify-between">
                <span className="font-semibold text-xs text-slate-800 dark:text-slate-200 tracking-wide uppercase flex items-center space-x-2">
                  <Layers className="w-3.5 h-3.5 text-[#0D2C24] dark:text-emerald-400" />
                  <span>{categoryTitle}</span>
                  <span className="text-slate-400 text-xs font-normal">({filteredVars.length})</span>
                </span>
              </div>

              <div className="divide-y divide-[#E8E5DF] dark:divide-slate-800">
                {filteredVars.map((v) => {
                  const isReferenced = referencedTags.has(v.tag);

                  return (
                    <div
                      key={v.id}
                      className="p-4 hover:bg-[#FAFAF8] dark:hover:bg-slate-800/40 transition-colors flex flex-col md:flex-row md:items-center justify-between gap-3"
                    >
                      <div className="space-y-1">
                        <div className="flex items-center space-x-2 flex-wrap">
                          <span className="font-mono font-bold text-sm text-[#0D2C24] dark:text-emerald-400 bg-[#F5F2ED] dark:bg-slate-800 px-2 py-0.5 rounded border border-[#E8E5DF] dark:border-slate-700">
                            {`{{${v.tag}}}`}
                          </span>
                          <span className="text-xs font-semibold text-slate-800 dark:text-slate-200">{v.label}</span>

                          <span className="text-[10px] px-2 py-0.5 rounded bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 font-mono">
                            {v.dataType}
                            {v.currency && ` (${v.currency})`}
                          </span>

                          {v.derivedConfig && (
                            <span className="text-[10px] px-2 py-0.5 rounded bg-[#FDE8B5] text-[#0D2C24] font-medium flex items-center space-x-1">
                              <Calculator className="w-3 h-3" />
                              <span>Derivada de {`{{${v.derivedConfig.sourceVariableId}}}`}</span>
                            </span>
                          )}

                          {v.required ? (
                            <span className="text-[10px] text-rose-600 font-semibold">• Obligatoria</span>
                          ) : (
                            <span className="text-[10px] text-slate-400">• Opcional</span>
                          )}
                        </div>

                        <div className="text-xs text-slate-500 dark:text-slate-400 flex items-center space-x-3">
                          {v.defaultValue && (
                            <span>
                              Valor predeterminado: <strong className="text-slate-700 dark:text-slate-300">{v.defaultValue}</strong>
                            </span>
                          )}

                          {isReferenced ? (
                            <span className="text-emerald-600 dark:text-emerald-400 flex items-center space-x-1 text-[11px]">
                              <CheckCircle2 className="w-3 h-3" />
                              <span>Presente en el documento</span>
                            </span>
                          ) : (
                            <span className="text-amber-600 dark:text-amber-400 flex items-center space-x-1 text-[11px]">
                              <AlertCircle className="w-3 h-3" />
                              <span>Variable huérfana (no referenciada en texto)</span>
                            </span>
                          )}
                        </div>
                      </div>

                      <div className="flex items-center space-x-2 self-end md:self-center">
                        <button
                          onClick={() => handleOpenEdit(v)}
                          className="p-1.5 text-slate-400 hover:text-slate-700 dark:hover:text-white hover:bg-[#F5F2ED] dark:hover:bg-slate-800 rounded-md transition-colors cursor-pointer"
                          title="Editar Variable"
                        >
                          <Edit2 className="w-4 h-4" />
                        </button>
                        <button
                          onClick={() => handleDelete(v)}
                          className="p-1.5 text-slate-400 hover:text-rose-600 hover:bg-rose-50 rounded-md transition-colors cursor-pointer"
                          title="Eliminar Variable"
                        >
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          );
        })}
      </div>

      {/* Create / Edit Variable Modal */}
      {isCreatingNew && (
        <div className="fixed inset-0 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4 z-50 animate-in fade-in">
          <div className="bg-white dark:bg-slate-900 rounded-2xl max-w-xl w-full p-6 shadow-2xl border border-[#E8E5DF] dark:border-slate-800 max-h-[90vh] overflow-y-auto">
            <div className="flex items-center justify-between pb-4 border-b border-[#E8E5DF] dark:border-slate-800">
              <h3 className="font-serif font-bold text-lg text-slate-900 dark:text-white">
                {editingVariable ? 'Editar Variable Jurídica' : 'Nueva Variable para la Plantilla'}
              </h3>
              <button onClick={resetForm} className="text-slate-400 hover:text-slate-600 dark:hover:text-white cursor-pointer">
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleSaveVariable} className="space-y-4 pt-4 text-xs">
              <div>
                <label className="block font-semibold text-slate-700 dark:text-slate-300 mb-1">
                  Identificador Interno (snake_case) <span className="text-rose-500">*</span>
                </label>
                <div className="relative">
                  <span className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 font-mono">
                    {`{{`}
                  </span>
                  <input
                    type="text"
                    required
                    value={formTag}
                    onChange={(e) => setFormTag(normalizeVariableTag(e.target.value))}
                    placeholder="inquilino_cedula"
                    className="w-full pl-8 pr-8 py-2 font-mono text-sm bg-[#FAFAF8] dark:bg-slate-800 dark:text-white border border-[#D1CCC4] dark:border-slate-700 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0D2C24]"
                  />
                  <span className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 font-mono">
                    {`}}`}
                  </span>
                </div>
                <p className="text-[11px] text-slate-400 mt-1">
                  Solo minúsculas [a-z0-9_], sin espacios ni acentos. Se propagará automáticamente.
                </p>
              </div>

              <div>
                <label className="block font-semibold text-slate-700 dark:text-slate-300 mb-1">
                  Etiqueta Visible para Formulario <span className="text-rose-500">*</span>
                </label>
                <input
                  type="text"
                  required
                  value={formLabel}
                  onChange={(e) => setFormLabel(e.target.value)}
                  placeholder="ej. Cédula de Identidad del Inquilino"
                  className="w-full px-3 py-2 border border-[#D1CCC4] dark:border-slate-700 dark:bg-slate-800 dark:text-white rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0D2C24]"
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block font-semibold text-slate-700 dark:text-slate-300 mb-1">Categoría</label>
                  <select
                    value={formCategory}
                    onChange={(e) => setFormCategory(e.target.value as VariableCategory)}
                    className="w-full px-3 py-2 border border-[#D1CCC4] dark:border-slate-700 dark:bg-slate-800 dark:text-white rounded-xl focus:outline-none"
                  >
                    <option value="CAT_NAME">Nombre / Compareciente</option>
                    <option value="CAT_CEDULA">Cédula Dominicana</option>
                    <option value="CAT_RNC">RNC Empresarial</option>
                    <option value="CAT_AMOUNT">Monto Monetario</option>
                    <option value="CAT_DATE">Fecha / Notarial</option>
                    <option value="CAT_ADDRESS">Dirección / Inmueble</option>
                    <option value="CAT_COMPANY">Empresa / Sociedad</option>
                    <option value="CAT_TERM">Plazo / Términos</option>
                    <option value="CAT_CUSTOM">Personalizado</option>
                  </select>
                </div>

                <div>
                  <label className="block font-semibold text-slate-700 dark:text-slate-300 mb-1">Tipo de Dato</label>
                  <select
                    value={formDataType}
                    onChange={(e) => setFormDataType(e.target.value as VariableDataType)}
                    className="w-full px-3 py-2 border border-[#D1CCC4] dark:border-slate-700 dark:bg-slate-800 dark:text-white rounded-xl focus:outline-none"
                  >
                    <option value="string">Texto (string)</option>
                    <option value="person">Persona Física (person)</option>
                    <option value="cedula">Cédula JCE (cedula)</option>
                    <option value="rnc">RNC DGII (rnc)</option>
                    <option value="currency">Moneda (currency)</option>
                    <option value="integer">Número Entero (integer)</option>
                    <option value="date">Fecha (date)</option>
                    <option value="address">Dirección (address)</option>
                    <option value="company">Sociedad (company)</option>
                    <option value="boolean">Booleano Si/No (boolean)</option>
                    <option value="percentage">Porcentaje (percentage)</option>
                  </select>
                </div>
              </div>

              {formDataType === 'currency' && (
                <div>
                  <label className="block font-semibold text-slate-700 dark:text-slate-300 mb-1">Moneda</label>
                  <select
                    value={formCurrency}
                    onChange={(e) => setFormCurrency(e.target.value as CurrencyCode)}
                    className="w-full px-3 py-2 border border-[#D1CCC4] dark:border-slate-700 dark:bg-slate-800 dark:text-white rounded-xl focus:outline-none"
                  >
                    <option value="DOP">Pesos Dominicanos (RD$ / DOP)</option>
                    <option value="USD">Dólares Estadounidenses (US$ / USD)</option>
                    <option value="EUR">Euros (€ / EUR)</option>
                  </select>
                </div>
              )}

              <div>
                <label className="block font-semibold text-slate-700 dark:text-slate-300 mb-1">Valor Predeterminado</label>
                <input
                  type="text"
                  value={formDefaultValue}
                  onChange={(e) => setFormDefaultValue(e.target.value)}
                  placeholder="ej. Marcos Miguel Cabrera"
                  className="w-full px-3 py-2 border border-[#D1CCC4] dark:border-slate-700 dark:bg-slate-800 dark:text-white rounded-xl focus:outline-none"
                />
              </div>

              <div className="flex items-center space-x-2 pt-2">
                <input
                  type="checkbox"
                  id="formRequiredCheck"
                  checked={formRequired}
                  onChange={(e) => setFormRequired(e.target.checked)}
                  className="rounded text-[#0D2C24] focus:ring-[#0D2C24] cursor-pointer"
                />
                <label htmlFor="formRequiredCheck" className="font-semibold text-slate-700 dark:text-slate-300 cursor-pointer">
                  Campo obligatorio para generar el contrato definitivo (RN-013)
                </label>
              </div>

              {/* Derived Variable Section */}
              <div className="border-t border-[#E8E5DF] dark:border-slate-800 pt-3 space-y-3">
                <div className="flex items-center space-x-2">
                  <input
                    type="checkbox"
                    id="isDerivedCheck"
                    checked={isDerived}
                    onChange={(e) => setIsDerived(e.target.checked)}
                    className="rounded text-[#0D2C24] focus:ring-[#0D2C24] cursor-pointer"
                  />
                  <label htmlFor="isDerivedCheck" className="font-semibold text-slate-800 dark:text-slate-200 flex items-center space-x-1 cursor-pointer">
                    <Calculator className="w-3.5 h-3.5 text-[#C5A059]" />
                    <span>Es una variable calculada / derivada (RN-019, RN-036)</span>
                  </label>
                </div>

                {isDerived && (
                  <div className="bg-[#F5F2ED] dark:bg-slate-800 p-3.5 rounded-xl border border-[#D1CCC4] dark:border-slate-700 space-y-3">
                    <div>
                      <label className="block font-semibold text-slate-800 dark:text-slate-200 mb-1">Variable de Origen</label>
                      <select
                        value={derivedSourceId}
                        onChange={(e) => setDerivedSourceId(e.target.value)}
                        className="w-full px-3 py-2 bg-white dark:bg-slate-900 border border-[#D1CCC4] dark:border-slate-700 rounded-xl text-xs dark:text-white"
                      >
                        {activeTemplate.variables
                          .filter((v) => v.tag !== formTag)
                          .map((v) => (
                            <option key={v.id} value={v.tag}>
                              {v.label} ({`{{${v.tag}}}`})
                            </option>
                          ))}
                      </select>
                    </div>

                    <div>
                      <label className="block font-semibold text-slate-800 dark:text-slate-200 mb-1">Tipo de Transformación</label>
                      <select
                        value={derivedTransformType}
                        onChange={(e) => setDerivedTransformType(e.target.value as any)}
                        className="w-full px-3 py-2 bg-white dark:bg-slate-900 border border-[#D1CCC4] dark:border-slate-700 rounded-xl text-xs dark:text-white"
                      >
                        <option value="amount_in_words">Monto numérico a letras notariales dominicanas (ej. RD$30,000 → TREINTA MIL PESOS)</option>
                        <option value="date_in_words">Fecha a cláusula notarial solemne (ej. 2026-08-15 → a los quince días del mes...)</option>
                        <option value="format_currency">Formato con símbolo de moneda (RD$30,000.00)</option>
                        <option value="format_cedula">Formato con guiones JCE (000-0000000-0)</option>
                        <option value="multiply">Multiplicar por factor (ej. Fianza de 2 meses)</option>
                      </select>
                    </div>

                    {derivedTransformType === 'multiply' && (
                      <div>
                        <label className="block font-semibold text-slate-800 dark:text-slate-200 mb-1">Factor Multiplicador</label>
                        <input
                          type="number"
                          value={derivedFactor}
                          onChange={(e) => setDerivedFactor(Number(e.target.value))}
                          className="w-full px-3 py-2 bg-white dark:bg-slate-900 border border-[#D1CCC4] dark:border-slate-700 rounded-xl text-xs dark:text-white"
                        />
                      </div>
                    )}
                  </div>
                )}
              </div>

              {/* Action Buttons */}
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
                  className="px-4 py-2 rounded-xl text-xs font-semibold bg-[#0D2C24] hover:bg-[#164E3E] text-white shadow-sm cursor-pointer"
                >
                  {editingVariable ? 'Guardar Cambios' : 'Crear Variable'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
