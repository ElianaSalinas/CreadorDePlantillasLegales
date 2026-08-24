import React, { useState } from 'react';
import {
  FileText,
  Search,
  Filter,
  Plus,
  Upload,
  Copy,
  Trash2,
  CheckCircle2,
  Clock,
  Archive,
  ArrowRight,
  ShieldCheck,
  Building,
  Scale,
  Briefcase,
  Layers,
  Sparkles,
  Play,
  FileCheck,
  SlidersHorizontal,
  BookOpen,
  GitFork,
} from 'lucide-react';
import { useAppStore } from '../store/useAppStore';
import { TemplateCategory, TemplateStatus, LegalTemplate } from '../types';
import { runTemplateHealthCheck } from '../core/healthCheck';

interface TemplateListProps {
  onOpenNewTemplateModal: () => void;
  onOpenDocxImportModal: () => void;
}

export const TemplateList: React.FC<TemplateListProps> = ({
  onOpenNewTemplateModal,
  onOpenDocxImportModal,
}) => {
  const {
    state,
    setActiveTemplateId,
    setView,
    duplicateTemplate,
    deleteTemplate,
    changeTemplateStatus,
  } = useAppStore();

  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<string>('ALL');
  const [selectedStatus, setSelectedStatus] = useState<string>('ALL');

  const filteredTemplates = state.templates.filter((tpl) => {
    const matchesSearch =
      tpl.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      tpl.description.toLowerCase().includes(searchQuery.toLowerCase()) ||
      tpl.variables.some((v) => v.tag.includes(searchQuery.toLowerCase()));

    const matchesCat = selectedCategory === 'ALL' || tpl.category === selectedCategory;
    const matchesStat = selectedStatus === 'ALL' || tpl.status === selectedStatus;

    return matchesSearch && matchesCat && matchesStat;
  });

  const getCategoryIcon = (category: TemplateCategory) => {
    switch (category) {
      case 'Inmobiliario':
        return <Building className="w-4 h-4 text-[#C5A059]" />;
      case 'Civil':
        return <Scale className="w-4 h-4 text-[#0D2C24] dark:text-emerald-400" />;
      case 'Comercial':
        return <Briefcase className="w-4 h-4 text-emerald-600" />;
      default:
        return <FileText className="w-4 h-4 text-[#0D2C24] dark:text-emerald-400" />;
    }
  };

  const handleSelectTemplate = (template: LegalTemplate, targetView: 'EDITOR' | 'FORM_GEN') => {
    setActiveTemplateId(template.id);
    setView(targetView);
  };

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-6">
      {/* Top Header & Metrics Banner with SAVE Branding */}
      <div className="bg-[#0D2C24] dark:bg-slate-900 rounded-2xl p-6 text-white shadow-md border border-[#164E3E] dark:border-slate-800 relative overflow-hidden">
        <div className="relative z-10 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
          <div>
            <div className="flex items-center space-x-2">
              <span className="text-xs font-bold uppercase tracking-wider text-[#0D2C24] bg-[#FDE8B5] px-2.5 py-0.5 rounded-md shadow-2xs">
                Jurisdicción República Dominicana (RD)
              </span>
              <span className="text-xs text-emerald-200/70 dark:text-slate-400">Ley 140-15 • Ley 4314 • Código Civil</span>
            </div>
            <h1 className="text-2xl sm:text-3xl font-bold tracking-tight font-serif mt-2 text-white">
              Catálogo de Plantillas Notariales
            </h1>
            <p className="text-emerald-100/80 dark:text-slate-300 text-xs sm:text-sm max-w-2xl mt-1 leading-relaxed">
              Crea, parametriza y genera documentos legales reutilizables con validación de Cédula JCE, RNC, cifras notariales en letras y reglas condicionales.
            </p>
          </div>

          <div className="flex items-center space-x-3 shrink-0">
            <button
              onClick={onOpenDocxImportModal}
              className="flex items-center space-x-2 px-4 py-2.5 rounded-xl text-xs font-semibold bg-[#164E3E] hover:bg-[#1C604D] text-white border border-[#2D7A64] transition-all shadow-xs cursor-pointer"
            >
              <Upload className="w-4 h-4 text-[#FDE8B5]" />
              <span>Importar DOCX</span>
            </button>

            <button
              onClick={onOpenNewTemplateModal}
              className="flex items-center space-x-2 px-4 py-2.5 rounded-xl text-xs font-bold bg-[#FDE8B5] hover:bg-[#FCE19F] text-[#0D2C24] transition-all shadow-md cursor-pointer"
            >
              <Plus className="w-4 h-4" />
              <span>Nueva Plantilla</span>
            </button>
          </div>
        </div>

        {/* Mini stats */}
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 mt-6 pt-6 border-t border-[#164E3E] dark:border-slate-800 text-xs">
          <div className="bg-[#08201A] dark:bg-slate-800/50 rounded-xl p-3 border border-[#164E3E] dark:border-slate-700/40">
            <div className="text-emerald-200/70 dark:text-slate-400">Plantillas Registradas</div>
            <div className="text-xl font-bold text-white mt-0.5 font-serif">{state.templates.length}</div>
          </div>
          <div className="bg-[#08201A] dark:bg-slate-800/50 rounded-xl p-3 border border-[#164E3E] dark:border-slate-700/40">
            <div className="text-emerald-200/70 dark:text-slate-400">Plantillas Publicadas</div>
            <div className="text-xl font-bold text-[#FDE8B5] mt-0.5 font-serif">
              {state.templates.filter((t) => t.status === 'PUBLISHED').length}
            </div>
          </div>
          <div className="bg-[#08201A] dark:bg-slate-800/50 rounded-xl p-3 border border-[#164E3E] dark:border-slate-700/40">
            <div className="text-emerald-200/70 dark:text-slate-400">Biblioteca de Cláusulas</div>
            <div className="text-xl font-bold text-white mt-0.5 font-serif">{state.globalClauses.length}</div>
          </div>
          <div className="bg-[#08201A] dark:bg-slate-800/50 rounded-xl p-3 border border-[#164E3E] dark:border-slate-700/40">
            <div className="text-emerald-200/70 dark:text-slate-400">Documentos en Bóveda</div>
            <div className="text-xl font-bold text-[#C5A059] mt-0.5 font-serif">{state.generatedDocuments.length}</div>
          </div>
        </div>
      </div>

      {/* Filter & Search Bar */}
      <div className="bg-white dark:bg-slate-900 rounded-xl p-4 shadow-2xs border border-[#E8E5DF] dark:border-slate-800 flex flex-col md:flex-row md:items-center justify-between gap-3">
        {/* Search */}
        <div className="relative flex-1">
          <Search className="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
          <input
            type="text"
            placeholder="Buscar por nombre, descripción o variable (ej. 'inquilino_cedula')..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full pl-9 pr-4 py-2 text-xs rounded-lg border border-[#D1CCC4] dark:border-slate-700 dark:bg-slate-800 dark:text-white focus:outline-none focus:ring-2 focus:ring-[#0D2C24]/20 focus:border-[#0D2C24]"
          />
        </div>

        {/* Filters */}
        <div className="flex items-center space-x-2">
          <select
            value={selectedCategory}
            onChange={(e) => setSelectedCategory(e.target.value)}
            className="text-xs bg-[#F5F2ED] dark:bg-slate-800 border border-[#D1CCC4] dark:border-slate-700 text-[#0D2C24] dark:text-slate-200 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-[#0D2C24] font-medium cursor-pointer"
          >
            <option value="ALL">Todas las Categorías</option>
            <option value="Inmobiliario">Inmobiliario</option>
            <option value="Civil">Civil</option>
            <option value="Comercial">Comercial</option>
            <option value="Corporativo">Corporativo</option>
          </select>

          <select
            value={selectedStatus}
            onChange={(e) => setSelectedStatus(e.target.value)}
            className="text-xs bg-[#F5F2ED] dark:bg-slate-800 border border-[#D1CCC4] dark:border-slate-700 text-[#0D2C24] dark:text-slate-200 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-[#0D2C24] font-medium cursor-pointer"
          >
            <option value="ALL">Todos los Estados</option>
            <option value="PUBLISHED">Publicadas</option>
            <option value="DRAFT">Borrador</option>
            <option value="REVIEW">En Revisión</option>
            <option value="ARCHIVED">Archivadas</option>
          </select>
        </div>
      </div>

      {/* Templates Grid */}
      {filteredTemplates.length === 0 ? (
        <div className="bg-white dark:bg-slate-900 rounded-xl p-12 text-center border border-dashed border-[#D1CCC4] dark:border-slate-800">
          <FileText className="w-12 h-12 text-slate-300 dark:text-slate-600 mx-auto mb-3" />
          <h3 className="text-base font-semibold text-slate-800 dark:text-slate-200 font-serif">No se encontraron plantillas</h3>
          <p className="text-xs text-slate-500 dark:text-slate-400 max-w-sm mx-auto mt-1">
            Intenta cambiar los filtros de búsqueda o crea una nueva plantilla legal desde cero o importando un DOCX.
          </p>
          <div className="mt-4 flex justify-center space-x-2">
            <button
              onClick={onOpenNewTemplateModal}
              className="px-3.5 py-2 rounded-lg text-xs font-semibold bg-[#0D2C24] hover:bg-[#164E3E] text-white cursor-pointer"
            >
              Crear Plantilla
            </button>
            <button
              onClick={onOpenDocxImportModal}
              className="px-3.5 py-2 rounded-lg text-xs font-semibold bg-[#F5F2ED] hover:bg-[#E8E5DF] text-[#0D2C24] cursor-pointer"
            >
              Importar DOCX
            </button>
          </div>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
          {filteredTemplates.map((template) => {
            const health = runTemplateHealthCheck(template);

            
            return (
              <article
                key={template.id}
                className="group relative flex flex-col bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 hover:border-[#0D2C24]/30 dark:hover:border-emerald-600/30 hover:shadow-[0_8px_24px_-4px_rgba(13,44,36,0.08)] transition-all duration-300 overflow-hidden"
              >
                <div className="p-6 flex-grow flex flex-col">
                  <div className="flex justify-between items-start mb-4">
                    <div className="flex gap-2 items-center">
                      <span className="inline-flex items-center px-2.5 py-1 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 font-sans text-[10px] font-semibold uppercase tracking-wider">
                        {template.category}
                      </span>
                      <span className={`inline-flex items-center px-2.5 py-1 rounded-full text-[10px] font-bold uppercase ${template.status === 'PUBLISHED' ? 'bg-emerald-50 text-emerald-800 border border-emerald-200 dark:bg-emerald-950 dark:text-emerald-300' : template.status === 'REVIEW' ? 'bg-amber-50 text-amber-800 border border-amber-200 dark:bg-amber-950 dark:text-amber-300' : 'bg-slate-50 text-slate-700 border border-slate-200 dark:bg-slate-800 dark:text-slate-300'}`}>
                        {template.status === 'PUBLISHED' ? 'Publicada' : template.status === 'REVIEW' ? 'En Revisión' : template.status === 'ARCHIVED' ? 'Archivada' : 'Borrador'}
                      </span>
                    </div>
                  </div>
                  <h3 className="font-serif font-bold text-[20px] leading-tight text-[#0D2C24] dark:text-white mb-2 group-hover:text-[#46645b] dark:group-hover:text-emerald-400 transition-colors line-clamp-2">
                    {template.name}
                  </h3>
                  <p className="font-sans text-[14px] text-slate-500 dark:text-slate-400 line-clamp-3 mb-6">
                    {template.description || 'Sin descripción jurídica proporcionada.'}
                  </p>
                  
                  <div className="mt-auto flex flex-col gap-4 border-t border-slate-200/50 dark:border-slate-800 pt-4">
                    {/* Stats */}
                    <div className="flex items-center justify-between text-slate-500 dark:text-slate-400 font-sans text-xs">
                      <div className="flex items-center gap-3">
                        <span className="flex items-center gap-1" title="Variables">
                          <SlidersHorizontal className="w-3.5 h-3.5" />
                          {template.variables.length}
                        </span>
                        <span className="flex items-center gap-1" title="Cláusulas">
                          <BookOpen className="w-3.5 h-3.5" />
                          {template.clauses.length}
                        </span>
                        <span className="flex items-center gap-1" title="Reglas">
                          <GitFork className="w-3.5 h-3.5" />
                          {template.rules.length}
                        </span>
                      </div>
                      <div className="flex items-center gap-1" title="Salud Estructural">
                         <ShieldCheck className={`w-4 h-4 ${health.status === 'HEALTHY' ? 'text-emerald-600' : health.status === 'WARNING' ? 'text-amber-500' : 'text-rose-600'}`} />
                         <span className={`font-semibold ${health.status === 'HEALTHY' ? 'text-emerald-700 dark:text-emerald-400' : health.status === 'WARNING' ? 'text-amber-700 dark:text-amber-400' : 'text-rose-700 dark:text-rose-400'}`}>{health.score}%</span>
                      </div>
                    </div>

                    {/* Actions */}
                    <div className="flex items-center justify-between">
                       <div className="flex items-center space-x-1">
                          <button onClick={() => duplicateTemplate(template.id)} className="p-1.5 text-slate-400 hover:text-[#0D2C24] dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded transition-colors cursor-pointer" title="Duplicar Plantilla">
                            <Copy className="w-4 h-4" />
                          </button>
                          <button onClick={() => { if (confirm(`¿Estás seguro de eliminar la plantilla "${template.name}"?`)) { deleteTemplate(template.id); } }} className="p-1.5 text-slate-400 hover:text-rose-600 hover:bg-rose-50 rounded transition-colors cursor-pointer" title="Eliminar Plantilla">
                            <Trash2 className="w-4 h-4" />
                          </button>
                       </div>
                       <div className="flex gap-2">
                          <button onClick={() => handleSelectTemplate(template, 'EDITOR')} className="px-3 py-1.5 border border-slate-200 dark:border-slate-700 text-[#0D2C24] dark:text-slate-200 font-sans text-xs font-semibold rounded hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors cursor-pointer">
                            Editar
                          </button>
                          <button onClick={() => handleSelectTemplate(template, 'FORM_GEN')} className="px-3 py-1.5 bg-[#0D2C24] text-white font-sans text-xs font-semibold rounded flex items-center gap-1 hover:bg-[#164E3E] transition-colors cursor-pointer">
                            <Play className="w-3 h-3 fill-current text-[#FDE8B5]" />
                            Generar
                          </button>
                       </div>
                    </div>
                  </div>
                </div>
              </article>
            );
          })}
        </div>
      )}
    </div>
  );
};
