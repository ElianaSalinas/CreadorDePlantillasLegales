import React, { useState } from 'react';
import {
  BookOpen,
  Plus,
  Edit2,
  Trash2,
  CheckCircle2,
  Layers,
  Search,
  Scale,
  ShieldAlert,
  HelpCircle,
  X,
  FileCheck,
} from 'lucide-react';
import { useAppStore } from '../store/useAppStore';
import { LegalClause, ClauseCategory } from '../types';
import { extractReferencedVariables } from '../core/variableEngine';
import { DEFAULT_DOMINICAN_CLAUSES } from '../core/clauseEngine';

export const ClauseLibrary: React.FC = () => {
  const { activeTemplate, addClause, updateClause, deleteClause, setView } = useAppStore();

  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<string>('ALL');
  const [isCreatingNew, setIsCreatingNew] = useState(false);
  const [editingClause, setEditingClause] = useState<LegalClause | null>(null);

  // Form
  const [formId, setFormId] = useState('');
  const [formTitle, setFormTitle] = useState('');
  const [formCategory, setFormCategory] = useState<ClauseCategory>('Inmobiliario');
  const [formContent, setFormContent] = useState('');
  const [formDescription, setFormDescription] = useState('');

  if (!activeTemplate) {
    return (
      <div className="max-w-4xl mx-auto py-16 text-center">
        <p className="text-slate-500 dark:text-slate-400">Selecciona una plantilla para gestionar sus cláusulas jurídicas.</p>
        <button
          onClick={() => setView('TEMPLATES')}
          className="mt-4 px-4 py-2 bg-[#0D2C24] hover:bg-[#164E3E] text-white text-xs font-semibold rounded-xl cursor-pointer"
        >
          Ver Plantillas
        </button>
      </div>
    );
  }

  const resetForm = () => {
    setFormId('');
    setFormTitle('');
    setFormCategory('Inmobiliario');
    setFormContent('');
    setFormDescription('');
    setEditingClause(null);
    setIsCreatingNew(false);
  };

  const handleOpenCreate = () => {
    resetForm();
    setFormId(`clausula_${Date.now()}`);
    setIsCreatingNew(true);
  };

  const handleOpenEdit = (clause: LegalClause) => {
    setEditingClause(clause);
    setFormId(clause.id);
    setFormTitle(clause.title);
    setFormCategory(clause.category);
    setFormContent(clause.content);
    setFormDescription(clause.description || '');
    setIsCreatingNew(true);
  };

  const handleSave = (e: React.FormEvent) => {
    e.preventDefault();

    const referencedVars = extractReferencedVariables(formContent);

    const payload: LegalClause = {
      id: formId.trim().toLowerCase().replace(/[^a-z0-9_]/g, '_'),
      title: formTitle,
      category: formCategory,
      content: formContent,
      description: formDescription,
      variablesReferenced: referencedVars,
      version: editingClause ? `${Number(editingClause.version || 1) + 1}.0` : '1.0',
      isStandard: false,
    };

    if (editingClause) {
      updateClause(activeTemplate.id, editingClause.id, payload);
    } else {
      addClause(activeTemplate.id, payload);
    }

    resetForm();
  };

  const handleAttachStandard = (stdClause: LegalClause) => {
    addClause(activeTemplate.id, stdClause);
  };

  const attachedClauseIds = new Set(activeTemplate.clauses.map((c) => c.id));

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-6">
      {/* Top Banner with SAVE Theme */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 bg-white dark:bg-slate-900 p-6 rounded-2xl shadow-xs border border-[#E8E5DF] dark:border-slate-800">
        <div>
          <div className="flex items-center space-x-2">
            <span className="text-xs font-bold text-[#0D2C24] dark:text-emerald-400 uppercase tracking-wider bg-[#F5F2ED] dark:bg-slate-800 px-2.5 py-0.5 rounded-md border border-[#E8E5DF] dark:border-slate-700">
              Biblioteca Jurídica Modular (RN-025, RN-029)
            </span>
            <span className="text-xs text-slate-400 font-mono">
              Cláusulas vinculadas: {activeTemplate.clauses.length}
            </span>
          </div>
          <h1 className="text-2xl font-bold text-slate-900 dark:text-white font-serif mt-1">
            Gestión de Cláusulas • {activeTemplate.name}
          </h1>
          <p className="text-slate-500 dark:text-slate-400 text-xs mt-1">
            Las cláusulas son bloques reutilizables de redacción legal con control condicional y numeración adaptativa.
          </p>
        </div>

        <button
          onClick={handleOpenCreate}
          className="flex items-center space-x-2 px-4 py-2.5 rounded-xl text-xs font-bold bg-[#0D2C24] hover:bg-[#164E3E] text-white shadow-sm transition-all cursor-pointer"
        >
          <Plus className="w-4 h-4 text-[#FDE8B5]" />
          <span>Crear Cláusula</span>
        </button>
      </div>

      {/* Cláusulas Vinculadas a la Plantilla Activa */}
      <div className="bg-white dark:bg-slate-900 rounded-2xl border border-[#E8E5DF] dark:border-slate-800 shadow-xs overflow-hidden">
        <div className="bg-[#F5F2ED]/70 dark:bg-slate-800/80 px-5 py-3 border-b border-[#E8E5DF] dark:border-slate-800 flex items-center justify-between">
          <span className="font-semibold text-xs text-slate-800 dark:text-slate-200 tracking-wide uppercase flex items-center space-x-2">
            <BookOpen className="w-3.5 h-3.5 text-[#0D2C24] dark:text-emerald-400" />
            <span>Cláusulas en esta plantilla ({activeTemplate.clauses.length})</span>
          </span>
        </div>

        <div className="divide-y divide-[#E8E5DF] dark:divide-slate-800">
          {activeTemplate.clauses.length === 0 ? (
            <div className="p-8 text-center text-slate-400 text-xs">
              No hay cláusulas asociadas. Agrega una cláusula estándar o crea una personalizada.
            </div>
          ) : (
            activeTemplate.clauses.map((clause) => (
              <div key={clause.id} className="p-5 hover:bg-[#FAFAF8] dark:hover:bg-slate-800/40 transition-colors space-y-3">
                <div className="flex items-start justify-between gap-4">
                  <div>
                    <div className="flex items-center space-x-2 flex-wrap">
                      <h4 className="font-serif font-bold text-sm text-slate-900 dark:text-white">{clause.title}</h4>
                      <span className="text-[10px] px-2 py-0.5 rounded bg-[#F5F2ED] dark:bg-slate-800 text-[#0D2C24] dark:text-emerald-400 border border-[#E8E5DF] dark:border-slate-700 font-medium">
                        {clause.category}
                      </span>
                      <span className="text-[10px] font-mono text-slate-400">ID: {clause.id}</span>
                    </div>
                    {clause.description && (
                      <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">{clause.description}</p>
                    )}
                  </div>

                  <div className="flex items-center space-x-2">
                    <button
                      onClick={() => handleOpenEdit(clause)}
                      className="p-1.5 text-slate-400 hover:text-slate-700 dark:hover:text-white hover:bg-[#F5F2ED] dark:hover:bg-slate-800 rounded-md transition-colors cursor-pointer"
                      title="Editar Cláusula"
                    >
                      <Edit2 className="w-4 h-4" />
                    </button>
                    <button
                      onClick={() => {
                        if (confirm(`¿Desvincular la cláusula "${clause.title}" de la plantilla?`)) {
                          deleteClause(activeTemplate.id, clause.id);
                        }
                      }}
                      className="p-1.5 text-slate-400 hover:text-rose-600 hover:bg-rose-50 rounded-md transition-colors cursor-pointer"
                      title="Desvincular Cláusula"
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </div>
                </div>

                {/* Content preview */}
                <div className="bg-[#FAFAF8] dark:bg-slate-800/60 p-3.5 rounded-xl border border-[#E8E5DF] dark:border-slate-700 text-xs font-serif leading-relaxed text-slate-800 dark:text-slate-200 whitespace-pre-wrap">
                  {clause.content}
                </div>

                {/* Referenced variables chips */}
                {clause.variablesReferenced && clause.variablesReferenced.length > 0 && (
                  <div className="flex items-center space-x-2 text-[11px] text-slate-500 dark:text-slate-400">
                    <span>Variables requeridas:</span>
                    <div className="flex flex-wrap gap-1">
                      {clause.variablesReferenced.map((v) => (
                        <span key={v} className="bg-[#F5F2ED] dark:bg-slate-800 text-[#0D2C24] dark:text-emerald-400 px-1.5 py-0.5 rounded font-mono text-[10px] border border-[#E8E5DF] dark:border-slate-700">
                          {`{{${v}}}`}
                        </span>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            ))
          )}
        </div>
      </div>

      {/* Repositorio de Cláusulas Estándar de República Dominicana */}
      <div className="bg-white dark:bg-slate-900 rounded-2xl border border-[#E8E5DF] dark:border-slate-800 shadow-xs overflow-hidden">
        <div className="bg-[#F5F2ED]/70 dark:bg-slate-800/80 px-5 py-3 border-b border-[#E8E5DF] dark:border-slate-800 flex items-center justify-between">
          <span className="font-semibold text-xs text-slate-800 dark:text-slate-200 tracking-wide uppercase flex items-center space-x-2">
            <Scale className="w-3.5 h-3.5 text-[#0D2C24] dark:text-emerald-400" />
            <span>Biblioteca Estándar de Cláusulas Notariales Dominicanas</span>
          </span>
          <span className="text-[11px] text-slate-500 dark:text-slate-400 font-mono">Leyes 4314, 5038, 140-15</span>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 p-5">
          {DEFAULT_DOMINICAN_CLAUSES.map((std) => {
            const isAttached = attachedClauseIds.has(std.id);

            return (
              <div
                key={std.id}
                className={`p-4 rounded-xl border transition-all ${
                  isAttached
                    ? 'bg-[#F5F2ED]/50 dark:bg-slate-800/60 border-[#C5A059]'
                    : 'bg-white dark:bg-slate-900 border-[#E8E5DF] dark:border-slate-800 hover:border-[#D1CCC4]'
                }`}
              >
                <div className="flex items-start justify-between gap-2">
                  <div>
                    <h5 className="font-serif font-bold text-xs text-slate-900 dark:text-white">{std.title}</h5>
                    <span className="text-[10px] text-[#C5A059] font-semibold">{std.category}</span>
                  </div>

                  {isAttached ? (
                    <span className="text-[10px] font-semibold text-emerald-700 dark:text-emerald-400 bg-emerald-50 dark:bg-emerald-950 px-2 py-0.5 rounded border border-emerald-200 dark:border-emerald-800 flex items-center space-x-1">
                      <CheckCircle2 className="w-3 h-3" />
                      <span>Vinculada</span>
                    </span>
                  ) : (
                    <button
                      onClick={() => handleAttachStandard(std)}
                      className="px-2.5 py-1 text-xs font-bold bg-[#0D2C24] hover:bg-[#164E3E] text-white rounded-xl transition-colors flex items-center space-x-1 cursor-pointer"
                    >
                      <Plus className="w-3 h-3 text-[#FDE8B5]" />
                      <span>Vincular</span>
                    </button>
                  )}
                </div>

                <p className="text-xs text-slate-600 dark:text-slate-300 mt-2 line-clamp-3 leading-relaxed font-serif">
                  {std.content}
                </p>
              </div>
            );
          })}
        </div>
      </div>

      {/* Create / Edit Modal */}
      {isCreatingNew && (
        <div className="fixed inset-0 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4 z-50 animate-in fade-in">
          <div className="bg-white dark:bg-slate-900 rounded-2xl max-w-2xl w-full p-6 shadow-2xl border border-[#E8E5DF] dark:border-slate-800 max-h-[90vh] overflow-y-auto">
            <div className="flex items-center justify-between pb-4 border-b border-[#E8E5DF] dark:border-slate-800">
              <h3 className="font-serif font-bold text-lg text-slate-900 dark:text-white">
                {editingClause ? 'Editar Cláusula Jurídica' : 'Nueva Cláusula Legal'}
              </h3>
              <button onClick={resetForm} className="text-slate-400 hover:text-slate-600 dark:hover:text-white cursor-pointer">
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleSave} className="space-y-4 pt-4 text-xs">
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block font-semibold text-slate-700 dark:text-slate-300 mb-1">
                    Identificador de Cláusula <span className="text-rose-500">*</span>
                  </label>
                  <input
                    type="text"
                    required
                    value={formId}
                    onChange={(e) => setFormId(e.target.value)}
                    placeholder="clausula_confidencialidad"
                    className="w-full px-3 py-2 font-mono bg-[#FAFAF8] dark:bg-slate-800 dark:text-white border border-[#D1CCC4] dark:border-slate-700 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0D2C24]"
                  />
                </div>

                <div>
                  <label className="block font-semibold text-slate-700 dark:text-slate-300 mb-1">Categoría</label>
                  <select
                    value={formCategory}
                    onChange={(e) => setFormCategory(e.target.value as ClauseCategory)}
                    className="w-full px-3 py-2 border border-[#D1CCC4] dark:border-slate-700 dark:bg-slate-800 dark:text-white rounded-xl focus:outline-none"
                  >
                    <option value="Inmobiliario">Inmobiliario</option>
                    <option value="Penalidades">Penalidades y Mora</option>
                    <option value="Jurisdicción">Jurisdicción y Tribunales</option>
                    <option value="Garantías">Garantías y Depósitos</option>
                    <option value="Laboral">Laboral</option>
                    <option value="Confidencialidad">Confidencialidad / NDA</option>
                    <option value="General">General</option>
                  </select>
                </div>
              </div>

              <div>
                <label className="block font-semibold text-slate-700 dark:text-slate-300 mb-1">
                  Título de la Cláusula <span className="text-rose-500">*</span>
                </label>
                <input
                  type="text"
                  required
                  value={formTitle}
                  onChange={(e) => setFormTitle(e.target.value)}
                  placeholder="ej. CLÁUSULA DE CONFIDENCIALIDAD Y NO DIVULGACIÓN"
                  className="w-full px-3 py-2 border border-[#D1CCC4] dark:border-slate-700 dark:bg-slate-800 dark:text-white rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0D2C24]"
                />
              </div>

              <div>
                <label className="block font-semibold text-slate-700 dark:text-slate-300 mb-1">Descripción Jurídica</label>
                <input
                  type="text"
                  value={formDescription}
                  onChange={(e) => setFormDescription(e.target.value)}
                  placeholder="ej. Regula el secreto profesional y penalidades por revelación de secretos comerciales"
                  className="w-full px-3 py-2 border border-[#D1CCC4] dark:border-slate-700 dark:bg-slate-800 dark:text-white rounded-xl focus:outline-none"
                />
              </div>

              <div>
                <label className="block font-semibold text-slate-700 dark:text-slate-300 mb-1">
                  Texto de la Cláusula <span className="text-rose-500">*</span>
                </label>
                <textarea
                  required
                  rows={6}
                  value={formContent}
                  onChange={(e) => setFormContent(e.target.value)}
                  placeholder="Escribe el texto de la cláusula. Puedes incluir {{variables}}..."
                  className="w-full p-3 font-serif text-sm border border-[#D1CCC4] dark:border-slate-700 dark:bg-slate-800 dark:text-white rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0D2C24]"
                />
              </div>

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
                  Guardar Cláusula
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
