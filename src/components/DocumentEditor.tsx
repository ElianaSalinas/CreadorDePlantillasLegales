import React, { useState, useRef } from 'react';
import {
  FileText,
  Save,
  Sparkles,
  Eye,
  Columns,
  Layers,
  BookOpen,
  Settings,
  ShieldCheck,
  CheckCircle2,
  AlertTriangle,
  History,
  Code2,
  Copy,
  ChevronDown,
  Plus,
  Play,
  LayoutTemplate,
  FileCode2,
  PanelLeftClose,
  PanelRightClose,
} from 'lucide-react';
import { useAppStore } from '../store/useAppStore';
import { substituteVariables } from '../core/variableEngine';
import { renderConditionalClauses } from '../core/clauseEngine';
import { runTemplateHealthCheck } from '../core/healthCheck';
import { detectVariablesWithAI } from '../core/detectorEngine';
import { TemplateStatus } from '../types';
import { PaginatedDocumentPreview } from './PaginatedDocumentPreview';
import { GoogleFormsTemplateEditor } from './GoogleFormsTemplateEditor';

interface DocumentEditorProps {
  onOpenHealthModal: () => void;
  onOpenVersionModal: () => void;
}

export const DocumentEditor: React.FC<DocumentEditorProps> = ({
  onOpenHealthModal,
  onOpenVersionModal,
}) => {
  const {
    activeTemplate,
    updateTemplate,
    changeTemplateStatus,
    setView,
    startHitlReview,
    setAnalyzing,
  } = useAppStore();

  // Mode: Formulario Google Forms vs Editor Notarial Texto
  const [editorStyle, setEditorStyle] = useState<'GOOGLE_FORMS' | 'TEXT_EDITOR'>('GOOGLE_FORMS');
  const [viewMode, setViewMode] = useState<'SPLIT' | 'EDITOR_ONLY' | 'PREVIEW_ONLY'>('SPLIT');
  const [mobileTab, setMobileTab] = useState<'EDITOR' | 'PREVIEW'>('EDITOR');
  const [showVariableDropdown, setShowVariableDropdown] = useState(false);
  const [showClauseDropdown, setShowClauseDropdown] = useState(false);
  const [aiLoading, setAiLoading] = useState(false);

  const textareaRef = useRef<HTMLTextAreaElement | null>(null);

  if (!activeTemplate) {
    return (
      <div className="max-w-4xl mx-auto py-16 text-center px-4">
        <p className="text-slate-500 dark:text-slate-400">Selecciona o crea una plantilla para comenzar a editar.</p>
        <button
          onClick={() => setView('TEMPLATES')}
          className="mt-4 px-4 py-2 bg-[#0D2C24] hover:bg-[#164E3E] text-[#FDE8B5] text-xs font-bold rounded-xl shadow-sm cursor-pointer"
        >
          Ir al catálogo de plantillas
        </button>
      </div>
    );
  }

  const health = runTemplateHealthCheck(activeTemplate);

  // Generate sample filled preview for the split view
  const sampleValues: Record<string, any> = {};
  activeTemplate.variables.forEach((v) => {
    sampleValues[v.tag] = v.defaultValue || `[${v.label.toUpperCase()}]`;
  });

  const previewWithClauses = renderConditionalClauses(
    activeTemplate.content,
    activeTemplate.clauses,
    sampleValues
  );
  const previewFinal = substituteVariables(previewWithClauses, sampleValues, true);

  const insertTextAtCursor = (textToInsert: string) => {
    const textarea = textareaRef.current;
    if (!textarea) {
      // If in Google forms mode or textarea not focused, append to template content
      updateTemplate(activeTemplate.id, {
        content: activeTemplate.content + '\n' + textToInsert,
      });
      return;
    }

    const start = textarea.selectionStart;
    const end = textarea.selectionEnd;
    const current = activeTemplate.content;

    const updated = current.substring(0, start) + textToInsert + current.substring(end);
    updateTemplate(activeTemplate.id, { content: updated });

    setTimeout(() => {
      textarea.focus();
      textarea.setSelectionRange(start + textToInsert.length, start + textToInsert.length);
    }, 50);
  };

  const handleInsertNumbering = (prefix: string) => {
    insertTextAtCursor(`\n\n${prefix}: `);
  };

  const handleTriggerAIAnalysis = async () => {
    setAiLoading(true);
    setAnalyzing(true);
    try {
      const res = await detectVariablesWithAI(activeTemplate.content);
      startHitlReview(activeTemplate.content, res.detectedVariables, activeTemplate.id);
    } catch (e: any) {
      alert(`Error durante análisis: ${e.message}`);
    } finally {
      setAiLoading(false);
      setAnalyzing(false);
    }
  };

  const handleStatusChange = (newStatus: TemplateStatus) => {
    const res = changeTemplateStatus(activeTemplate.id, newStatus);
    if (!res.success) {
      alert(res.error);
    }
  };

  return (
    <div className="h-[calc(100vh-4.5rem)] flex flex-col bg-[#F5F2ED] dark:bg-slate-950 overflow-hidden w-full max-w-full">
      {/* Primary Top Editor Toolbar */}
      <div className="bg-white dark:bg-slate-900 border-b border-[#E8E5DF] dark:border-slate-800 px-4 py-2 flex flex-wrap items-center justify-between gap-2 shadow-xs shrink-0 z-20">
        <div className="flex items-center space-x-2 flex-wrap">
          <input
            type="text"
            value={activeTemplate.name}
            onChange={(e) => updateTemplate(activeTemplate.id, { name: e.target.value })}
            className="font-serif font-bold text-slate-800 dark:text-white text-sm sm:text-base bg-transparent border-b border-transparent hover:border-[#D1CCC4] focus:border-[#0D2C24] dark:focus:border-emerald-400 focus:outline-none px-1 py-0.5 max-w-[240px] sm:max-w-xs truncate"
            placeholder="Título de la plantilla..."
          />

          <span className="text-xs text-slate-400 font-mono hidden sm:inline">v{activeTemplate.version}</span>

          <select
            value={activeTemplate.status}
            onChange={(e) => handleStatusChange(e.target.value as TemplateStatus)}
            className={`text-xs font-bold px-2.5 py-1 rounded-xl border focus:outline-none cursor-pointer ${
              activeTemplate.status === 'PUBLISHED'
                ? 'bg-emerald-50 dark:bg-emerald-950 text-emerald-800 dark:text-emerald-300 border-emerald-200 dark:border-emerald-800'
                : activeTemplate.status === 'REVIEW'
                ? 'bg-amber-50 dark:bg-amber-950 text-amber-800 dark:text-amber-300 border-amber-200 dark:border-amber-800'
                : 'bg-[#F5F2ED] dark:bg-slate-800 text-[#0D2C24] dark:text-slate-300 border-[#E8E5DF] dark:border-slate-700'
            }`}
          >
            <option value="DRAFT">Borrador (DRAFT)</option>
            <option value="REVIEW">En Revisión (REVIEW)</option>
            <option value="PUBLISHED">Publicada (PUBLISHED)</option>
            <option value="ARCHIVED">Archivada (ARCHIVED)</option>
          </select>
        </div>

        {/* Intuitive Mode Switcher (Google Forms vs Text Editor) */}
        <div className="flex items-center space-x-1 bg-[#F5F2ED] dark:bg-slate-800 p-1 rounded-2xl border border-[#E8E5DF] dark:border-slate-700">
          <button
            onClick={() => setEditorStyle('GOOGLE_FORMS')}
            className={`flex items-center space-x-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition-all cursor-pointer ${
              editorStyle === 'GOOGLE_FORMS'
                ? 'bg-[#0D2C24] text-[#FDE8B5] shadow-xs'
                : 'text-slate-600 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white'
            }`}
            title="Modo Formulario Estilo Google Forms (Intuitivo)"
          >
            <LayoutTemplate className="w-3.5 h-3.5" />
            <span>Formulario Asistido</span>
          </button>

          <button
            onClick={() => setEditorStyle('TEXT_EDITOR')}
            className={`flex items-center space-x-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition-all cursor-pointer ${
              editorStyle === 'TEXT_EDITOR'
                ? 'bg-[#0D2C24] text-[#FDE8B5] shadow-xs'
                : 'text-slate-600 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white'
            }`}
            title="Modo Editor Notarial Avanzado (WordprocessingML / Tags)"
          >
            <FileCode2 className="w-3.5 h-3.5" />
            <span>Editor Notarial</span>
          </button>
        </div>

        {/* Quick Insert & AI Actions */}
        <div className="flex items-center space-x-1.5 flex-wrap">
          {/* Insert Variable Dropdown */}
          <div className="relative">
            <button
              onClick={() => {
                setShowVariableDropdown(!showVariableDropdown);
                setShowClauseDropdown(false);
              }}
              className="flex items-center space-x-1 px-3 py-1.5 rounded-xl text-xs font-bold bg-[#F5F2ED] dark:bg-slate-800 hover:bg-[#E8E5DF] text-[#0D2C24] dark:text-emerald-400 border border-[#E8E5DF] dark:border-slate-700 transition-colors cursor-pointer"
            >
              <Layers className="w-3.5 h-3.5 text-[#0D2C24] dark:text-emerald-400" />
              <span className="hidden sm:inline">Variable</span>
              <ChevronDown className="w-3 h-3" />
            </button>

            {showVariableDropdown && (
              <div className="absolute right-0 mt-1 w-64 bg-white dark:bg-slate-900 rounded-2xl shadow-xl border border-[#E8E5DF] dark:border-slate-800 py-1.5 z-50 max-h-80 overflow-y-auto">
                <div className="px-3 py-1 text-[11px] font-bold text-slate-400 uppercase tracking-wider">
                  Variables registradas
                </div>
                {activeTemplate.variables.length === 0 ? (
                  <div className="px-3 py-2 text-xs text-slate-500">No hay variables creadas aún.</div>
                ) : (
                  activeTemplate.variables.map((v) => (
                    <button
                      key={v.id}
                      onClick={() => {
                        insertTextAtCursor(`{{${v.tag}}}`);
                        setShowVariableDropdown(false);
                      }}
                      className="w-full text-left px-3 py-1.5 hover:bg-[#F5F2ED] dark:hover:bg-slate-800 text-xs flex flex-col transition-colors cursor-pointer"
                    >
                      <span className="font-mono font-bold text-[#0D2C24] dark:text-emerald-400">{`{{${v.tag}}}`}</span>
                      <span className="text-[10px] text-slate-500 dark:text-slate-400">{v.label}</span>
                    </button>
                  ))
                )}
                <div className="border-t border-[#E8E5DF] dark:border-slate-800 mt-1 pt-1 px-2">
                  <button
                    onClick={() => {
                      setView('VARIABLES');
                      setShowVariableDropdown(false);
                    }}
                    className="w-full text-left px-2 py-1.5 text-xs text-[#0D2C24] dark:text-emerald-400 hover:bg-[#F5F2ED] dark:hover:bg-slate-800 rounded-xl font-bold flex items-center space-x-1 cursor-pointer"
                  >
                    <Plus className="w-3.5 h-3.5 text-[#C5A059]" />
                    <span>Administrar diccionario</span>
                  </button>
                </div>
              </div>
            )}
          </div>

          {/* Insert Clause Dropdown */}
          <div className="relative">
            <button
              onClick={() => {
                setShowClauseDropdown(!showClauseDropdown);
                setShowVariableDropdown(false);
              }}
              className="flex items-center space-x-1 px-3 py-1.5 rounded-xl text-xs font-bold bg-[#F5F2ED] dark:bg-slate-800 hover:bg-[#E8E5DF] text-[#0D2C24] dark:text-emerald-400 border border-[#E8E5DF] dark:border-slate-700 transition-colors cursor-pointer"
            >
              <BookOpen className="w-3.5 h-3.5 text-[#C5A059]" />
              <span className="hidden sm:inline">Cláusula</span>
              <ChevronDown className="w-3 h-3" />
            </button>

            {showClauseDropdown && (
              <div className="absolute right-0 mt-1 w-72 bg-white dark:bg-slate-900 rounded-2xl shadow-xl border border-[#E8E5DF] dark:border-slate-800 py-1.5 z-50 max-h-80 overflow-y-auto">
                <div className="px-3 py-1 text-[11px] font-bold text-slate-400 uppercase tracking-wider">
                  Biblioteca Notarial
                </div>
                {activeTemplate.clauses.map((c) => (
                  <button
                    key={c.id}
                    onClick={() => {
                      insertTextAtCursor(`\n\n{{#clause:${c.id}}}\n${c.content}\n{{/clause:${c.id}}}\n`);
                      setShowClauseDropdown(false);
                    }}
                    className="w-full text-left px-3 py-1.5 hover:bg-[#F5F2ED] dark:hover:bg-slate-800 text-xs flex flex-col transition-colors cursor-pointer"
                  >
                    <span className="font-bold text-slate-800 dark:text-white">{c.title}</span>
                    <span className="text-[10px] text-[#C5A059] font-medium">{c.category}</span>
                  </button>
                ))}
              </div>
            )}
          </div>

          {/* AI Extraction Trigger */}
          <button
            onClick={handleTriggerAIAnalysis}
            disabled={aiLoading}
            className="flex items-center space-x-1 px-3 py-1.5 rounded-xl text-xs font-bold bg-[#0D2C24] hover:bg-[#164E3E] text-white shadow-xs transition-all disabled:opacity-50 cursor-pointer"
            title="Analizar texto y detectar variables con Regex e IA"
          >
            <Sparkles className="w-3.5 h-3.5 text-[#FDE8B5]" />
            <span className="hidden md:inline">{aiLoading ? 'Analizando...' : 'Detectar con IA'}</span>
          </button>

          {/* Health Badge */}
          <button
            onClick={onOpenHealthModal}
            className={`px-2.5 py-1.5 rounded-xl text-xs font-bold flex items-center space-x-1 border cursor-pointer ${
              health.status === 'HEALTHY'
                ? 'bg-emerald-50 dark:bg-emerald-950 text-emerald-800 dark:text-emerald-300 border-emerald-200 dark:border-emerald-800'
                : health.status === 'WARNING'
                ? 'bg-amber-50 dark:bg-amber-950 text-amber-800 dark:text-amber-300 border-amber-200 dark:border-amber-800'
                : 'bg-rose-50 dark:bg-rose-950 text-rose-800 dark:text-rose-300 border-rose-200 dark:border-rose-800'
            }`}
          >
            {health.status === 'HEALTHY' ? (
              <CheckCircle2 className="w-3.5 h-3.5 text-emerald-600 dark:text-emerald-400" />
            ) : health.status === 'WARNING' ? (
              <AlertTriangle className="w-3.5 h-3.5 text-amber-600 dark:text-amber-400" />
            ) : (
              <AlertTriangle className="w-3.5 h-3.5 text-rose-600 dark:text-rose-400" />
            )}
            <span>{health.score}%</span>
          </button>

          {/* Go to Generate Document */}
          <button
            onClick={() => setView('FORM_GEN')}
            className="flex items-center space-x-1 px-3.5 py-1.5 rounded-xl text-xs font-bold bg-[#C5A059] hover:bg-[#B38F46] text-[#0D2C24] shadow-xs transition-all cursor-pointer"
          >
            <Play className="w-3 h-3 fill-current" />
            <span>Generar</span>
          </button>
        </div>
      </div>

      {/* Secondary Bar: Notarial Numbering & Layout Controls */}
      <div className="bg-[#FAFAF8] dark:bg-slate-900 border-b border-[#E8E5DF] dark:border-slate-800 px-4 py-1.5 flex flex-wrap items-center justify-between gap-2 text-xs text-slate-600 dark:text-slate-300 shrink-0">
        {editorStyle === 'TEXT_EDITOR' ? (
          <div className="flex items-center space-x-1 flex-wrap">
            <span className="text-[11px] text-slate-400 font-bold mr-1">Numeración Notarial:</span>
            {['PRIMERO', 'SEGUNDO', 'TERCERO', 'CUARTO', 'QUINTO', 'SEXTO'].map((num) => (
              <button
                key={num}
                onClick={() => handleInsertNumbering(num)}
                className="px-2 py-0.5 bg-white dark:bg-slate-800 hover:bg-[#E8E5DF] text-slate-700 dark:text-slate-200 rounded-lg border border-[#E8E5DF] dark:border-slate-700 font-mono text-[11px] font-bold cursor-pointer"
              >
                {num}:
              </button>
            ))}
          </div>
        ) : (
          <div className="text-xs text-slate-500 dark:text-slate-400 flex items-center space-x-2">
            <span className="font-bold text-[#0D2C24] dark:text-emerald-400 bg-[#F5F2ED] dark:bg-slate-800 px-2 py-0.5 rounded-full border border-[#E8E5DF] dark:border-slate-700">
              Formulario Estilo Google Forms
            </span>
            <span className="hidden sm:inline text-slate-400">
              Configura los campos y preguntas que alimentan el contrato legal.
            </span>
          </div>
        )}

        {/* View Mode Switcher for Desktop */}
        <div className="hidden lg:flex items-center space-x-1 bg-white dark:bg-slate-800 rounded-xl border border-[#E8E5DF] dark:border-slate-700 p-0.5">
          <button
            onClick={() => setViewMode('EDITOR_ONLY')}
            className={`px-3 py-1 rounded-lg text-xs font-bold transition-all cursor-pointer ${
              viewMode === 'EDITOR_ONLY' ? 'bg-[#0D2C24] text-white shadow-xs' : 'text-slate-600 dark:text-slate-400 hover:bg-[#F5F2ED] dark:hover:bg-slate-700'
            }`}
          >
            {editorStyle === 'GOOGLE_FORMS' ? 'Solo Formulario' : 'Solo Editor'}
          </button>
          <button
            onClick={() => setViewMode('SPLIT')}
            className={`px-3 py-1 rounded-lg text-xs font-bold transition-all cursor-pointer ${
              viewMode === 'SPLIT' ? 'bg-[#0D2C24] text-white shadow-xs' : 'text-slate-600 dark:text-slate-400 hover:bg-[#F5F2ED] dark:hover:bg-slate-700'
            }`}
          >
            Vista Dividida
          </button>
          <button
            onClick={() => setViewMode('PREVIEW_ONLY')}
            className={`px-3 py-1 rounded-lg text-xs font-bold transition-all cursor-pointer ${
              viewMode === 'PREVIEW_ONLY' ? 'bg-[#0D2C24] text-white shadow-xs' : 'text-slate-600 dark:text-slate-400 hover:bg-[#F5F2ED] dark:hover:bg-slate-700'
            }`}
          >
            Hojas Notariales
          </button>
        </div>

        {/* Mobile/Tablet Tab Switcher */}
        <div className="flex lg:hidden items-center space-x-1 bg-white dark:bg-slate-800 rounded-xl border border-[#E8E5DF] dark:border-slate-700 p-0.5">
          <button
            onClick={() => setMobileTab('EDITOR')}
            className={`px-3 py-1 rounded-lg text-xs font-bold cursor-pointer ${
              mobileTab === 'EDITOR' ? 'bg-[#0D2C24] text-white' : 'text-slate-600 dark:text-slate-400'
            }`}
          >
            {editorStyle === 'GOOGLE_FORMS' ? 'Formulario' : 'Editor'}
          </button>
          <button
            onClick={() => setMobileTab('PREVIEW')}
            className={`px-3 py-1 rounded-lg text-xs font-bold cursor-pointer ${
              mobileTab === 'PREVIEW' ? 'bg-[#0D2C24] text-white' : 'text-slate-600 dark:text-slate-400'
            }`}
          >
            Hojas Notariales
          </button>
        </div>
      </div>

      {/* Main Split Layout with Zero Horizontal Overflow and Vertical Scroll */}
      <div className="flex-1 flex overflow-hidden min-w-0 w-full">
        {/* Left Side: Form Editor or Raw Text Editor */}
        <div
          className={`h-full flex flex-col min-w-0 overflow-hidden bg-white dark:bg-slate-900 border-r border-[#E8E5DF] dark:border-slate-800 ${
            viewMode === 'SPLIT'
              ? 'w-full lg:w-1/2'
              : viewMode === 'EDITOR_ONLY'
              ? 'w-full'
              : 'hidden'
          } ${mobileTab === 'PREVIEW' ? 'hidden lg:flex' : 'flex'}`}
        >
          {editorStyle === 'GOOGLE_FORMS' ? (
            <GoogleFormsTemplateEditor onInsertVariableInContent={insertTextAtCursor} />
          ) : (
            <div className="h-full flex flex-col min-w-0 overflow-hidden bg-white dark:bg-slate-900">
              <div className="p-2.5 bg-[#FAFAF8] dark:bg-slate-950 border-b border-[#E8E5DF] dark:border-slate-800 flex items-center justify-between text-xs text-slate-500 dark:text-slate-400 font-mono shrink-0">
                <span>Contenido Documental Notarial (WordprocessingML / Tags)</span>
                <span>{activeTemplate.content.length} caracteres</span>
              </div>
              <textarea
                ref={textareaRef}
                value={activeTemplate.content}
                onChange={(e) => updateTemplate(activeTemplate.id, { content: e.target.value })}
                className="flex-1 p-6 font-mono text-sm leading-relaxed text-slate-800 dark:text-slate-100 bg-white dark:bg-slate-900 resize-none focus:outline-none selection:bg-[#FDE8B5] selection:text-[#0D2C24] overflow-y-auto overflow-x-hidden break-words w-full"
                placeholder="Escribe o pega aquí el contrato legal. Usa {{variable}} para parametrizar..."
                spellCheck={false}
              />
            </div>
          )}
        </div>

        {/* Right Side: Paginated Document Preview with Realistic Page Breaks */}
        <div
          className={`h-full flex flex-col min-w-0 overflow-hidden bg-[#F5F2ED] dark:bg-slate-950 ${
            viewMode === 'SPLIT'
              ? 'hidden lg:flex lg:w-1/2'
              : viewMode === 'PREVIEW_ONLY'
              ? 'w-full flex'
              : 'hidden'
          } ${mobileTab === 'PREVIEW' ? 'flex w-full' : ''}`}
        >
          <PaginatedDocumentPreview
            content={previewFinal}
            templateName={activeTemplate.name}
          />
        </div>
      </div>
    </div>
  );
};
