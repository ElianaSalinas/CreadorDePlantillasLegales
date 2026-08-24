import React, { useState } from 'react';
import {
  Plus,
  Trash2,
  Copy,
  ChevronUp,
  ChevronDown,
  Sparkles,
  Layers,
  FileText,
  CreditCard,
  Building,
  Calendar,
  ToggleLeft,
  ToggleRight,
  HelpCircle,
  FolderPlus,
  CheckCircle2,
  BookOpen,
  Settings,
  Scale,
} from 'lucide-react';
import { useAppStore } from '../store/useAppStore';
import { TemplateVariable, VariableCategory, VariableDataType } from '../types';

interface GoogleFormsTemplateEditorProps {
  onInsertVariableInContent?: (tag: string) => void;
}

export const GoogleFormsTemplateEditor: React.FC<GoogleFormsTemplateEditorProps> = ({
  onInsertVariableInContent,
}) => {
  const { activeTemplate, updateTemplate, addVariable, deleteVariable, updateVariable, state } =
    useAppStore();

  const [activeQuestionId, setActiveQuestionId] = useState<string | null>(null);

  if (!activeTemplate) return null;

  const variables = activeTemplate.variables || [];

  // Helper to determine category for a new variable
  const inferCategory = (tag: string, dataType: VariableDataType): VariableCategory => {
    if (dataType === 'currency' || tag.includes('monto') || tag.includes('precio') || tag.includes('alquiler') || tag.includes('fianza')) return 'CAT_AMOUNT';
    if (tag.includes('cedula')) return 'CAT_CEDULA';
    if (tag.includes('rnc')) return 'CAT_RNC';
    if (tag.includes('direccion') || tag.includes('inmueble') || tag.includes('catastral')) return 'CAT_ADDRESS';
    if (dataType === 'date' || tag.includes('fecha') || tag.includes('plazo') || tag.includes('duracion')) return 'CAT_DATE';
    if (tag.includes('nombre') || tag.includes('arrendador') || tag.includes('inquilino')) return 'CAT_NAME';
    return 'CAT_CUSTOM';
  };

  // Helper to create a new variable in Google Forms format
  const handleAddQuestion = (dataType: VariableDataType = 'string') => {
    const count = variables.length + 1;
    const baseTag = `nuevo_campo_${count}`;
    const newVar: TemplateVariable = {
      id: `var_${Date.now()}`,
      tag: baseTag,
      label: `Nuevo Campo ${count}`,
      category: inferCategory(baseTag, dataType),
      dataType,
      required: true,
      defaultValue: '',
      currency: dataType === 'currency' ? 'DOP' : undefined,
    };
    addVariable(activeTemplate.id, newVar);
    setActiveQuestionId(newVar.id);
  };

  const handleDuplicateQuestion = (v: TemplateVariable) => {
    const newVar: TemplateVariable = {
      ...v,
      id: `var_${Date.now()}`,
      tag: `${v.tag}_copia`,
      label: `${v.label} (Copia)`,
    };
    addVariable(activeTemplate.id, newVar);
    setActiveQuestionId(newVar.id);
  };

  const handleTypeChange = (id: string, newType: VariableDataType) => {
    updateVariable(activeTemplate.id, id, {
      dataType: newType,
      currency: newType === 'currency' ? 'DOP' : undefined,
    });
  };

  return (
    <div className="flex-1 overflow-y-auto overflow-x-hidden p-4 sm:p-6 bg-[#F5F2ED] dark:bg-slate-950 max-w-4xl mx-auto w-full space-y-6">
      {/* Google Forms-Style Header Banner in SAVE styling */}
      <div className="bg-white dark:bg-slate-900 rounded-2xl shadow-sm border border-[#E8E5DF] dark:border-slate-800 overflow-hidden relative border-t-8 border-t-[#0D2C24]">
        <div className="p-6 sm:p-8 space-y-4">
          <div>
            <div className="flex items-center space-x-2 text-xs font-bold text-[#0D2C24] dark:text-emerald-400 uppercase tracking-wider">
              <Scale className="w-4 h-4 text-[#C5A059]" />
              <span>Plantilla Jurídica Asistida • República Dominicana • SAVE</span>
            </div>
            <input
              type="text"
              value={activeTemplate.name}
              onChange={(e) => updateTemplate(activeTemplate.id, { name: e.target.value })}
              className="text-2xl sm:text-3xl font-serif font-bold text-slate-900 dark:text-white border-b border-transparent hover:border-[#D1CCC4] dark:hover:border-slate-700 focus:border-[#0D2C24] dark:focus:border-emerald-400 focus:outline-none w-full mt-2 pb-1"
              placeholder="Título del Formulario Legal..."
            />
          </div>

          <textarea
            value={activeTemplate.description || ''}
            onChange={(e) => updateTemplate(activeTemplate.id, { description: e.target.value })}
            placeholder="Descripción e instrucciones para paralegales, abogados y operadores que llenarán este formulario..."
            rows={2}
            className="w-full text-xs sm:text-sm text-slate-600 dark:text-slate-300 border-b border-transparent hover:border-[#D1CCC4] dark:hover:border-slate-700 focus:border-[#0D2C24] dark:focus:border-emerald-400 focus:outline-none resize-none bg-transparent"
          />

          <div className="pt-2 flex flex-wrap items-center gap-3 text-xs text-slate-500 dark:text-slate-400 border-t border-[#E8E5DF] dark:border-slate-800">
            <span className="flex items-center space-x-1 font-semibold text-slate-700 dark:text-slate-300">
              <Layers className="w-3.5 h-3.5 text-[#0D2C24] dark:text-emerald-400" />
              <span>{variables.length} Campos Definidos</span>
            </span>
            <span>•</span>
            <span className="flex items-center space-x-1 font-semibold text-slate-700 dark:text-slate-300">
              <BookOpen className="w-3.5 h-3.5 text-[#C5A059]" />
              <span>{activeTemplate.clauses.length} Cláusulas Vinculadas</span>
            </span>
            <span>•</span>
            <span className="text-emerald-800 dark:text-emerald-300 bg-emerald-50 dark:bg-emerald-950 px-2.5 py-0.5 rounded-full font-bold border border-emerald-200 dark:border-emerald-800">
              Validación JCE / DGII Activa
            </span>
          </div>
        </div>
      </div>

      {/* Floating Add Question Quick Bar */}
      <div className="bg-white dark:bg-slate-900 rounded-2xl p-3 shadow-xs border border-[#E8E5DF] dark:border-slate-800 flex flex-wrap items-center justify-between gap-2">
        <span className="text-xs font-bold text-slate-800 dark:text-slate-200 flex items-center space-x-1.5 pl-2">
          <Plus className="w-4 h-4 text-[#0D2C24] dark:text-emerald-400" />
          <span>Añadir Nuevo Campo al Formulario:</span>
        </span>

        <div className="flex items-center space-x-1.5 flex-wrap">
          <button
            onClick={() => handleAddQuestion('string')}
            className="px-3 py-1.5 text-xs bg-[#F5F2ED] dark:bg-slate-800 hover:bg-[#E8E5DF] text-[#0D2C24] dark:text-emerald-300 rounded-xl border border-[#E8E5DF] dark:border-slate-700 font-bold transition-colors cursor-pointer"
          >
            + Texto Corto
          </button>
          <button
            onClick={() => handleAddQuestion('currency')}
            className="px-3 py-1.5 text-xs bg-[#F5F2ED] dark:bg-slate-800 hover:bg-[#E8E5DF] text-emerald-800 dark:text-emerald-400 rounded-xl border border-[#E8E5DF] dark:border-slate-700 font-bold transition-colors cursor-pointer"
          >
            + Monto (RD$)
          </button>
          <button
            onClick={() => handleAddQuestion('date')}
            className="px-3 py-1.5 text-xs bg-[#F5F2ED] dark:bg-slate-800 hover:bg-[#E8E5DF] text-[#C5A059] rounded-xl border border-[#E8E5DF] dark:border-slate-700 font-bold transition-colors cursor-pointer"
          >
            + Fecha
          </button>
          <button
            onClick={() => handleAddQuestion('boolean')}
            className="px-3 py-1.5 text-xs bg-[#F5F2ED] dark:bg-slate-800 hover:bg-[#E8E5DF] text-amber-800 dark:text-amber-400 rounded-xl border border-[#E8E5DF] dark:border-slate-700 font-bold transition-colors cursor-pointer"
          >
            + Opción Sí/No
          </button>
        </div>
      </div>

      {/* Question Cards (Google Forms Style) */}
      <div className="space-y-4">
        {variables.length === 0 ? (
          <div className="bg-white dark:bg-slate-900 rounded-2xl p-12 text-center border border-dashed border-[#D1CCC4] dark:border-slate-700">
            <Layers className="w-12 h-12 text-slate-300 dark:text-slate-600 mx-auto mb-3" />
            <h3 className="text-sm font-bold text-slate-800 dark:text-slate-200">No hay campos en el formulario</h3>
            <p className="text-xs text-slate-500 dark:text-slate-400 mt-1 max-w-md mx-auto">
              Comienza agregando las preguntas y campos requeridos para estructurar este contrato legal.
            </p>
            <button
              onClick={() => handleAddQuestion('string')}
              className="mt-4 px-4 py-2 bg-[#0D2C24] hover:bg-[#164E3E] text-white text-xs font-bold rounded-xl shadow-sm transition-colors cursor-pointer"
            >
              + Agregar primer campo
            </button>
          </div>
        ) : (
          variables.map((v, index) => {
            const isActive = activeQuestionId === v.id;

            return (
              <div
                key={v.id}
                onClick={() => setActiveQuestionId(v.id)}
                className={`bg-white dark:bg-slate-900 rounded-2xl shadow-xs border transition-all duration-150 overflow-hidden relative cursor-pointer ${
                  isActive
                    ? 'border-[#0D2C24] dark:border-emerald-500 ring-2 ring-[#0D2C24]/10 dark:ring-emerald-500/20 shadow-md'
                    : 'border-[#E8E5DF] dark:border-slate-800 hover:border-[#D1CCC4]'
                }`}
              >
                {/* Active Indicator on Left */}
                {isActive && <div className="absolute left-0 top-0 bottom-0 w-1.5 bg-[#0D2C24] dark:bg-emerald-500" />}

                <div className="p-5 sm:p-6 space-y-4">
                  {/* Top Row: Question Title + Type Dropdown */}
                  <div className="grid grid-cols-1 sm:grid-cols-12 gap-3 items-start">
                    <div className="sm:col-span-8">
                      <div className="flex items-center space-x-2">
                        <span className="text-xs font-mono font-bold text-slate-400">#{index + 1}</span>
                        <input
                          type="text"
                          value={v.label}
                          onChange={(e) => updateVariable(activeTemplate.id, v.id, { label: e.target.value })}
                          placeholder="Título del Campo / Pregunta (ej. Nombre del Arrendador)..."
                          className="w-full text-sm font-semibold text-slate-800 dark:text-white bg-[#FAFAF8] dark:bg-slate-800/50 hover:bg-[#F5F2ED] dark:hover:bg-slate-800 focus:bg-white dark:focus:bg-slate-900 border-b-2 border-[#D1CCC4] dark:border-slate-700 focus:border-[#0D2C24] dark:focus:border-emerald-400 focus:outline-none p-2 rounded-t transition-colors"
                        />
                      </div>
                    </div>

                    <div className="sm:col-span-4">
                      <select
                        value={v.dataType}
                        onChange={(e) => handleTypeChange(v.id, e.target.value as VariableDataType)}
                        className="w-full text-xs font-semibold text-slate-700 dark:text-slate-200 bg-[#FAFAF8] dark:bg-slate-800 border border-[#D1CCC4] dark:border-slate-700 rounded-xl p-2.5 focus:outline-none focus:ring-2 focus:ring-[#0D2C24]"
                      >
                        <option value="string">📝 Texto Corto / Nombre</option>
                        <option value="currency">💰 Monto Monetario (RD$/USD)</option>
                        <option value="date">📅 Fecha Notarial</option>
                        <option value="boolean">🔘 Casilla de Opción (Sí / No)</option>
                        <option value="integer">🔢 Número Entero</option>
                        <option value="percentage">📊 Porcentaje (%)</option>
                      </select>
                    </div>
                  </div>

                  {/* Tag & Technical Settings */}
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-2 bg-[#F5F2ED] dark:bg-slate-800/60 p-3 rounded-xl border border-[#E8E5DF] dark:border-slate-700">
                    <div>
                      <label className="block text-[11px] font-bold text-slate-600 dark:text-slate-400 uppercase tracking-wider mb-1">
                        Etiqueta en Contrato:
                      </label>
                      <div className="flex items-center space-x-1.5">
                        <span className="text-xs font-mono text-[#0D2C24] dark:text-emerald-400 bg-white dark:bg-slate-900 px-2.5 py-1.5 rounded-xl border border-[#D1CCC4] dark:border-slate-700 font-bold">
                          {`{{${v.tag}}}`}
                        </span>
                        <input
                          type="text"
                          value={v.tag}
                          onChange={(e) => updateVariable(activeTemplate.id, v.id, { tag: e.target.value })}
                          className="text-xs font-mono text-slate-700 dark:text-slate-200 bg-white dark:bg-slate-900 border border-[#D1CCC4] dark:border-slate-700 rounded-xl px-2 py-1.5 focus:outline-none focus:border-[#0D2C24] flex-1"
                          placeholder="tag_snake_case"
                        />
                      </div>
                    </div>

                    <div>
                      <label className="block text-[11px] font-bold text-slate-600 dark:text-slate-400 uppercase tracking-wider mb-1">
                        Valor Sugerido / Ejemplo:
                      </label>
                      <input
                        type="text"
                        value={v.defaultValue || ''}
                        onChange={(e) =>
                          updateVariable(activeTemplate.id, v.id, { defaultValue: e.target.value })
                        }
                        placeholder="Ej. Juan Carlos Pérez..."
                        className="w-full text-xs text-slate-700 dark:text-slate-200 bg-white dark:bg-slate-900 border border-[#D1CCC4] dark:border-slate-700 rounded-xl px-2 py-1.5 focus:outline-none focus:border-[#0D2C24]"
                      />
                    </div>
                  </div>

                  {/* Derived Configuration */}
                  {v.derivedConfig && (
                    <div className="p-2.5 bg-[#F5F2ED] dark:bg-slate-800 rounded-xl border border-[#C5A059]/40 flex items-center justify-between text-xs text-[#0D2C24] dark:text-emerald-300">
                      <span className="flex items-center space-x-1.5 font-bold">
                        <Sparkles className="w-3.5 h-3.5 text-[#C5A059]" />
                        <span>Fórmula Automática: {v.derivedConfig.transformType}</span>
                      </span>
                      <span className="text-[10px] bg-[#FDE8B5] text-[#0D2C24] px-2 py-0.5 rounded font-mono font-bold">
                        Fuente: {v.derivedConfig.sourceVariableId}
                      </span>
                    </div>
                  )}

                  {/* Bottom Actions Row */}
                  <div className="pt-3 border-t border-[#E8E5DF] dark:border-slate-800 flex flex-wrap items-center justify-between gap-3">
                    <div className="flex items-center space-x-3 text-xs text-slate-500">
                      {v.dataType === 'currency' && (
                        <select
                          value={v.currency || 'DOP'}
                          onChange={(e) =>
                            updateVariable(activeTemplate.id, v.id, {
                              currency: e.target.value as 'DOP' | 'USD' | 'EUR',
                            })
                          }
                          className="text-xs border border-[#D1CCC4] dark:border-slate-700 rounded-xl px-2 py-1 bg-white dark:bg-slate-800 font-bold text-slate-700 dark:text-slate-200"
                        >
                          <option value="DOP">Pesos Dominicanos (RD$)</option>
                          <option value="USD">Dólares Estadounidenses (US$)</option>
                          <option value="EUR">Euros (€)</option>
                        </select>
                      )}

                      {v.tag.toLowerCase().includes('cedula') && (
                        <span className="text-[11px] text-emerald-800 dark:text-emerald-300 font-bold bg-emerald-50 dark:bg-emerald-950 px-2 py-0.5 rounded-full border border-emerald-200 dark:border-emerald-800">
                          ✓ Validador JCE Módulo 10 Activo
                        </span>
                      )}
                      {v.tag.toLowerCase().includes('rnc') && (
                        <span className="text-[11px] text-[#0D2C24] dark:text-emerald-300 font-bold bg-[#F5F2ED] dark:bg-slate-800 px-2 py-0.5 rounded-full border border-[#E8E5DF] dark:border-slate-700">
                          ✓ Validador RNC DGII Activo
                        </span>
                      )}
                    </div>

                    <div className="flex items-center space-x-4">
                      {/* Duplicate */}
                      <button
                        onClick={() => handleDuplicateQuestion(v)}
                        className="p-1.5 text-slate-400 hover:text-[#0D2C24] dark:hover:text-white hover:bg-[#F5F2ED] dark:hover:bg-slate-800 rounded-xl transition-colors cursor-pointer"
                        title="Duplicar Campo"
                      >
                        <Copy className="w-4 h-4" />
                      </button>

                      {/* Delete */}
                      <button
                        onClick={() => deleteVariable(activeTemplate.id, v.id)}
                        className="p-1.5 text-slate-400 hover:text-rose-600 hover:bg-rose-50 rounded-xl transition-colors cursor-pointer"
                        title="Eliminar Campo"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>

                      <div className="h-4 w-px bg-[#E8E5DF] dark:bg-slate-700" />

                      {/* Required Toggle */}
                      <label className="flex items-center space-x-2 text-xs font-bold text-slate-700 dark:text-slate-300 cursor-pointer select-none">
                        <span>Obligatorio</span>
                        <input
                          type="checkbox"
                          checked={v.required}
                          onChange={(e) =>
                            updateVariable(activeTemplate.id, v.id, { required: e.target.checked })
                          }
                          className="w-4 h-4 text-[#0D2C24] rounded border-[#D1CCC4] focus:ring-[#0D2C24] cursor-pointer"
                        />
                      </label>
                    </div>
                  </div>
                </div>
              </div>
            );
          })
        )}
      </div>

      {/* Floating Bottom Add Button */}
      <div className="sticky bottom-4 flex justify-center z-10">
        <button
          onClick={() => handleAddQuestion('string')}
          className="flex items-center space-x-2 px-6 py-3 bg-[#0D2C24] hover:bg-[#164E3E] text-white rounded-full shadow-lg hover:shadow-xl font-bold text-xs transition-all transform hover:scale-105 cursor-pointer"
        >
          <Plus className="w-4 h-4 text-[#FDE8B5]" />
          <span>Añadir Nuevo Campo al Formulario</span>
        </button>
      </div>
    </div>
  );
};
