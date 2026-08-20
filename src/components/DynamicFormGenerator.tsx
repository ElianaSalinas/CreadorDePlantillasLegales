import React, { useState, useMemo } from 'react';
import {
  FileCheck2,
  Download,
  Eye,
  CheckCircle2,
  AlertCircle,
  Clock,
  Printer,
  FileText,
  Building,
  CreditCard,
  Calendar,
  Sparkles,
  ShieldCheck,
  ChevronRight,
  Code2,
  BookOpen,
} from 'lucide-react';
import { useAppStore } from '../store/useAppStore';
import {
  calculateDerivedValues,
  substituteVariables,
} from '../core/variableEngine';
import { evaluateAllRules } from '../core/ruleEngine';
import { renderConditionalClauses } from '../core/clauseEngine';
import {
  validateCedulaDominicana,
  validateRNC,
} from '../core/dominicanValidators';
import { generateDocxBlob, generatePdfBlob, generateSchemaJson } from '../core/exportEngine';
import { PaginatedDocumentPreview } from './PaginatedDocumentPreview';

export const DynamicFormGenerator: React.FC = () => {
  const {
    activeTemplate,
    state,
    currentUser,
    setFormValue,
    setAllFormValues,
    saveGeneratedDocument,
    setView,
  } = useAppStore();

  const [documentTitle, setDocumentTitle] = useState('');
  const [isGenerating, setIsGenerating] = useState(false);
  const [downloadSuccess, setDownloadSuccess] = useState<string | null>(null);
  const [mobileTab, setMobileTab] = useState<'FORM' | 'PREVIEW'>('FORM');

  if (!activeTemplate) {
    return (
      <div className="max-w-4xl mx-auto py-16 text-center px-4">
        <p className="text-slate-500 dark:text-slate-400">Selecciona una plantilla para generar el formulario de captura.</p>
        <button
          onClick={() => setView('TEMPLATES')}
          className="mt-4 px-4 py-2 bg-[#0D2C24] hover:bg-[#164E3E] text-white text-xs font-semibold rounded-xl shadow-sm cursor-pointer"
        >
          Ver Plantillas
        </button>
      </div>
    );
  }

  const rawValues = state.formValues;

  // 1. Calculate derived variables (Montos en letras, fecha solemne, etc.)
  const fullValuesWithDerived = useMemo(() => {
    return calculateDerivedValues(activeTemplate.variables, rawValues);
  }, [activeTemplate.variables, rawValues]);

  // 2. Evaluate active conditional rules (show/hide clauses, require fields)
  const ruleEvaluation = useMemo(() => {
    return evaluateAllRules(
      activeTemplate.rules,
      fullValuesWithDerived,
      activeTemplate.variables,
      activeTemplate.clauses
    );
  }, [activeTemplate.rules, fullValuesWithDerived, activeTemplate.variables, activeTemplate.clauses]);

  // 3. Render conditional clauses
  const contentWithClauses = useMemo(() => {
    return renderConditionalClauses(
      activeTemplate.content,
      activeTemplate.clauses,
      fullValuesWithDerived,
      ruleEvaluation.visibleClauseIds
    );
  }, [activeTemplate.content, activeTemplate.clauses, fullValuesWithDerived, ruleEvaluation]);

  // 4. Substitute variables into final text preview
  const finalRenderedText = useMemo(() => {
    return substituteVariables(contentWithClauses, fullValuesWithDerived, true);
  }, [contentWithClauses, fullValuesWithDerived]);

  // 5. Validation pass for form fields
  const validationErrors: Record<string, string> = {};
  for (const v of activeTemplate.variables) {
    // Skip derived variables from manual validation
    if (v.derivedConfig) continue;

    const val = fullValuesWithDerived[v.tag];
    const isRequired = v.required || ruleEvaluation.requiredVariableIds.has(v.tag);

    if (isRequired && (val === undefined || val === '' || val === null)) {
      validationErrors[v.tag] = `El campo "${v.label}" es obligatorio.`;
      continue;
    }

    if (val) {
      if (v.dataType === 'cedula' || v.tag.toLowerCase().includes('cedula')) {
        const cedRes = validateCedulaDominicana(String(val));
        if (!cedRes.isValid) {
          validationErrors[v.tag] = cedRes.error || 'Cédula dominicana inválida (Módulo 10).';
        }
      } else if (v.dataType === 'rnc' || v.tag.toLowerCase().includes('rnc')) {
        const rncRes = validateRNC(String(val));
        if (!rncRes.isValid) {
          validationErrors[v.tag] = rncRes.error || 'RNC DGII inválido.';
        }
      }
    }
  }

  const isValid = Object.keys(validationErrors).length === 0;

  // Handle document generation & downloads
  const handleDownloadDocx = async () => {
    if (!isValid) {
      alert('Por favor corrige los errores de validación antes de generar el documento.');
      return;
    }

    setIsGenerating(true);
    try {
      const title = documentTitle || `${activeTemplate.name} - ${new Date().toLocaleDateString()}`;
      const blob = await generateDocxBlob(title, finalRenderedText);

      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `${title.replace(/[^a-zA-Z0-9_-]/g, '_')}.docx`;
      a.click();
      URL.revokeObjectURL(url);

      saveGeneratedDocument({
        id: `doc_${Date.now()}`,
        templateId: activeTemplate.id,
        templateName: activeTemplate.name,
        title,
        createdAt: new Date().toISOString(),
        format: 'DOCX',
        status: 'EMITIDO',
        valuesSnapshot: fullValuesWithDerived,
        renderedContent: finalRenderedText,
        author: `${currentUser.name} (${currentUser.cardRegistration})`,
      });

      setDownloadSuccess('Documento DOCX generado, descargado y guardado en Contratos Finales.');
      setTimeout(() => setDownloadSuccess(null), 5000);
    } catch (e: any) {
      alert(`Error generando DOCX: ${e.message}`);
    } finally {
      setIsGenerating(false);
    }
  };

  const handleDownloadPdf = () => {
    if (!isValid) {
      alert('Por favor corrige los errores de validación antes de generar el documento.');
      return;
    }

    setIsGenerating(true);
    try {
      const title = documentTitle || `${activeTemplate.name} - ${new Date().toLocaleDateString('es-DO')}`;
      const blob = generatePdfBlob(title, finalRenderedText);

      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `${title.replace(/[^a-zA-Z0-9_-]/g, '_')}.pdf`;
      a.click();
      URL.revokeObjectURL(url);

      saveGeneratedDocument({
        id: `doc_${Date.now()}`,
        templateId: activeTemplate.id,
        templateName: activeTemplate.name,
        title,
        createdAt: new Date().toISOString(),
        format: 'PDF',
        status: 'NOTARIADO',
        valuesSnapshot: fullValuesWithDerived,
        renderedContent: finalRenderedText,
        author: `${currentUser.name} (${currentUser.cardRegistration})`,
      });

      setDownloadSuccess('Documento PDF generado, descargado y guardado en Contratos Finales.');
      setTimeout(() => setDownloadSuccess(null), 5000);
    } catch (e: any) {
      alert(`Error generando PDF: ${e.message}`);
    } finally {
      setIsGenerating(false);
    }
  };

  const handleSaveToVault = (status: 'EMITIDO' | 'NOTARIADO' | 'BORRADOR' = 'EMITIDO') => {
    const title = documentTitle || `${activeTemplate.name} - ${new Date().toLocaleDateString('es-DO')}`;
    saveGeneratedDocument({
      id: `doc_${Date.now()}`,
      templateId: activeTemplate.id,
      templateName: activeTemplate.name,
      title,
      createdAt: new Date().toISOString(),
      format: 'DOCX',
      status,
      valuesSnapshot: fullValuesWithDerived,
      renderedContent: finalRenderedText,
      author: `${currentUser.name} (${currentUser.cardRegistration})`,
    });
    setDownloadSuccess(`Contrato guardado en la Bóveda de Contratos Finales como [${status}].`);
    setTimeout(() => setDownloadSuccess(null), 5000);
  };

  const handleDownloadSchema = () => {
    const jsonStr = generateSchemaJson(activeTemplate);
    const blob = new Blob([jsonStr], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `${activeTemplate.name.replace(/[^a-zA-Z0-9_-]/g, '_')}_schema.json`;
    a.click();
    URL.revokeObjectURL(url);
  };

  // Input field renderer
  const renderField = (v: any) => {
    const error = validationErrors[v.tag];
    const isRequired = v.required || ruleEvaluation.requiredVariableIds.has(v.tag);
    const value = fullValuesWithDerived[v.tag] !== undefined ? fullValuesWithDerived[v.tag] : '';

    if (v.derivedConfig) {
      return (
        <div key={v.id} className="bg-[#F5F2ED] dark:bg-slate-800 p-3.5 rounded-xl border border-[#D1CCC4] dark:border-slate-700 space-y-1.5 shadow-xs">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-[#0D2C24] dark:text-emerald-300 flex items-center space-x-1.5">
              <Sparkles className="w-3.5 h-3.5 text-[#C5A059]" />
              <span>{v.label}</span>
            </span>
            <span className="text-[10px] text-[#0D2C24] bg-[#FDE8B5] px-2 py-0.5 rounded font-mono font-bold">
              Auto-calculado
            </span>
          </div>
          <div className="text-xs font-serif font-bold text-slate-800 dark:text-slate-200 bg-white dark:bg-slate-900 p-2.5 rounded-lg border border-[#E8E5DF] dark:border-slate-700">
            {value || <span className="text-slate-400 font-sans italic font-normal">Calculando automáticamente...</span>}
          </div>
        </div>
      );
    }

    return (
      <div key={v.id} className="bg-white dark:bg-slate-900 p-4 rounded-xl border border-[#E8E5DF] dark:border-slate-800 shadow-xs space-y-2">
        <div className="flex items-center justify-between">
          <label className="block text-xs font-semibold text-slate-800 dark:text-slate-200">
            {v.label} {isRequired && <span className="text-rose-500 font-bold">*</span>}
          </label>
          <span className="font-mono text-[10px] text-[#0D2C24] dark:text-emerald-400 bg-[#F5F2ED] dark:bg-slate-800 px-1.5 py-0.5 rounded border border-[#E8E5DF] dark:border-slate-700">
            {`{{${v.tag}}}`}
          </span>
        </div>

        {v.dataType === 'boolean' ? (
          <div className="flex items-center space-x-4 py-1">
            <label className="inline-flex items-center space-x-2 text-xs font-medium text-slate-700 dark:text-slate-300 cursor-pointer">
              <input
                type="radio"
                name={`radio_${v.tag}`}
                checked={value === true}
                onChange={() => setFormValue(v.tag, true)}
                className="text-[#0D2C24] focus:ring-[#0D2C24] w-4 h-4 cursor-pointer"
              />
              <span>Sí</span>
            </label>
            <label className="inline-flex items-center space-x-2 text-xs font-medium text-slate-700 dark:text-slate-300 cursor-pointer">
              <input
                type="radio"
                name={`radio_${v.tag}`}
                checked={value === false}
                onChange={() => setFormValue(v.tag, false)}
                className="text-[#0D2C24] focus:ring-[#0D2C24] w-4 h-4 cursor-pointer"
              />
              <span>No</span>
            </label>
          </div>
        ) : v.dataType === 'date' ? (
          <input
            type="date"
            value={value}
            onChange={(e) => setFormValue(v.tag, e.target.value)}
            className={`w-full px-3 py-2 text-xs rounded-lg border bg-[#FAFAF8] dark:bg-slate-800 dark:text-white focus:bg-white focus:outline-none transition-colors ${
              error ? 'border-rose-300 focus:ring-2 focus:ring-rose-200' : 'border-[#D1CCC4] dark:border-slate-700 focus:ring-2 focus:ring-[#0D2C24]'
            }`}
          />
        ) : v.dataType === 'currency' || v.dataType === 'integer' || v.dataType === 'percentage' ? (
          <div className="relative">
            {v.dataType === 'currency' && (
              <span className="absolute left-3 top-1/2 -translate-y-1/2 text-xs font-bold text-[#0D2C24] dark:text-emerald-400">
                {v.currency === 'USD' ? 'US$' : v.currency === 'EUR' ? '€' : 'RD$'}
              </span>
            )}
            <input
              type="number"
              value={value}
              onChange={(e) => setFormValue(v.tag, e.target.value === '' ? '' : Number(e.target.value))}
              placeholder="0.00"
              className={`w-full ${v.dataType === 'currency' ? 'pl-11' : 'pl-3'} pr-3 py-2 text-xs rounded-lg border bg-[#FAFAF8] dark:bg-slate-800 dark:text-white focus:bg-white focus:outline-none transition-colors ${
                error ? 'border-rose-300 focus:ring-2 focus:ring-rose-200' : 'border-[#D1CCC4] dark:border-slate-700 focus:ring-2 focus:ring-[#0D2C24]'
              }`}
            />
          </div>
        ) : (
          <input
            type="text"
            value={value}
            onChange={(e) => setFormValue(v.tag, e.target.value)}
            placeholder={`Ingresa ${v.label.toLowerCase()}...`}
            className={`w-full px-3 py-2 text-xs rounded-lg border bg-[#FAFAF8] dark:bg-slate-800 dark:text-white focus:bg-white focus:outline-none transition-colors ${
              error ? 'border-rose-300 focus:ring-2 focus:ring-rose-200' : 'border-[#D1CCC4] dark:border-slate-700 focus:ring-2 focus:ring-[#0D2C24]'
            }`}
          />
        )}

        {error && (
          <p className="text-[11px] text-rose-600 font-medium flex items-center space-x-1">
            <AlertCircle className="w-3.5 h-3.5 shrink-0" />
            <span>{error}</span>
          </p>
        )}
      </div>
    );
  };

  return (
    <div className="h-[calc(100vh-4rem)] flex flex-col bg-[#F5F2ED]/60 dark:bg-slate-950 overflow-hidden w-full max-w-full">
      {/* Top Banner & Generation Trigger with SAVE Theme */}
      <div className="bg-white dark:bg-slate-900 border-b border-[#E8E5DF] dark:border-slate-800 px-4 sm:px-6 py-2.5 flex flex-wrap items-center justify-between gap-3 shrink-0 shadow-xs z-20">
        <div className="flex items-center space-x-3 min-w-0">
          <div className="min-w-0">
            <div className="flex items-center space-x-2">
              <span className="text-xs font-bold text-[#0D2C24] dark:text-emerald-400 uppercase tracking-wider bg-[#F5F2ED] dark:bg-slate-800 px-2 py-0.5 rounded border border-[#E8E5DF] dark:border-slate-700">
                Generador de Documentos
              </span>
              <span className="text-xs text-slate-400 font-mono hidden sm:inline truncate">
                Plantilla: {activeTemplate.name}
              </span>
            </div>
            <input
              type="text"
              value={documentTitle}
              onChange={(e) => setDocumentTitle(e.target.value)}
              placeholder="Título del Contrato (ej. Contrato Alquiler - Juan Pérez vs Marcos Cabrera)..."
              className="text-sm font-semibold font-serif text-slate-900 dark:text-white border-b border-transparent hover:border-[#D1CCC4] focus:border-[#0D2C24] focus:outline-none mt-0.5 w-64 sm:w-80 md:w-96 truncate bg-transparent"
            />
          </div>
        </div>

        {/* Action Buttons & Mobile Tab Switcher */}
        <div className="flex items-center space-x-2">
          {/* Mobile Tab Toggle */}
          <div className="flex lg:hidden items-center bg-[#F5F2ED] dark:bg-slate-800 p-0.5 rounded-lg border border-[#D1CCC4] dark:border-slate-700 text-xs">
            <button
              onClick={() => setMobileTab('FORM')}
              className={`px-2.5 py-1 rounded-md font-medium transition-all ${
                mobileTab === 'FORM' ? 'bg-[#0D2C24] text-white' : 'text-slate-600 dark:text-slate-300'
              }`}
            >
              Formulario
            </button>
            <button
              onClick={() => setMobileTab('PREVIEW')}
              className={`px-2.5 py-1 rounded-md font-medium transition-all ${
                mobileTab === 'PREVIEW' ? 'bg-[#0D2C24] text-white' : 'text-slate-600 dark:text-slate-300'
              }`}
            >
              Hojas Notariales
            </button>
          </div>

          <button
            onClick={handleDownloadSchema}
            className="hidden sm:flex p-2 text-slate-500 hover:text-slate-800 dark:hover:text-white hover:bg-[#F5F2ED] dark:hover:bg-slate-800 rounded-lg transition-colors border border-[#D1CCC4] dark:border-slate-700 cursor-pointer"
            title="Descargar schema.json (Contrato de Datos)"
          >
            <Code2 className="w-4 h-4" />
          </button>

          <button
            onClick={() => handleSaveToVault('EMITIDO')}
            disabled={isGenerating}
            className="flex items-center space-x-1.5 px-3 sm:px-3.5 py-2 rounded-xl text-xs font-bold bg-[#FDE8B5] hover:bg-[#FCE19F] text-[#0D2C24] shadow-sm transition-all disabled:opacity-50 cursor-pointer"
            title="Guardar contrato final en la Bóveda de Contratos"
          >
            <FileCheck2 className="w-3.5 h-3.5 text-[#0D2C24]" />
            <span className="hidden sm:inline">Guardar en Bóveda</span>
            <span className="sm:hidden">Guardar</span>
          </button>

          <button
            onClick={handleDownloadDocx}
            disabled={isGenerating}
            className="flex items-center space-x-1.5 px-3 sm:px-4 py-2 rounded-xl text-xs font-semibold bg-[#0D2C24] hover:bg-[#164E3E] text-white shadow-sm transition-all disabled:opacity-50 cursor-pointer"
          >
            <Download className="w-3.5 h-3.5 text-[#FDE8B5]" />
            <span>DOCX</span>
          </button>

          <button
            onClick={handleDownloadPdf}
            disabled={isGenerating}
            className="flex items-center space-x-1.5 px-3 sm:px-4 py-2 rounded-xl text-xs font-semibold bg-[#F5F2ED] hover:bg-[#E8E5DF] text-[#0D2C24] border border-[#D1CCC4] dark:bg-slate-800 dark:text-white dark:border-slate-700 shadow-sm transition-all disabled:opacity-50 cursor-pointer"
          >
            <Printer className="w-3.5 h-3.5" />
            <span>PDF</span>
          </button>
        </div>
      </div>

      {downloadSuccess && (
        <div className="bg-[#0D2C24] text-white text-xs px-6 py-2.5 flex items-center justify-between shrink-0 shadow-xs border-b border-[#164E3E]">
          <span className="flex items-center space-x-2">
            <CheckCircle2 className="w-4 h-4 text-[#FDE8B5]" />
            <span className="font-medium">{downloadSuccess}</span>
          </span>
          <button
            onClick={() => setView('DOCUMENTS')}
            className="underline font-bold text-[#FDE8B5] hover:text-white flex items-center space-x-1 cursor-pointer"
          >
            <span>Ver en Contratos Finales</span>
            <span>→</span>
          </button>
        </div>
      )}

      {/* Main Split Layout: Form on Left, Paginated Preview on Right */}
      <div className="flex-1 flex overflow-hidden min-w-0 w-full">
        {/* Left: Dynamic Form Questionnaire */}
        <div
          className={`h-full flex flex-col bg-[#FAFAF8] dark:bg-slate-900 border-r border-[#E8E5DF] dark:border-slate-800 min-w-0 overflow-hidden ${
            mobileTab === 'PREVIEW' ? 'hidden lg:flex lg:w-5/12' : 'w-full lg:w-5/12'
          }`}
        >
          <div className="p-3.5 bg-white dark:bg-slate-900 border-b border-[#E8E5DF] dark:border-slate-800 flex items-center justify-between shrink-0">
            <span className="font-semibold text-xs text-slate-800 dark:text-white flex items-center space-x-2">
              <FileCheck2 className="w-4 h-4 text-[#0D2C24] dark:text-emerald-400" />
              <span>Formulario de Datos del Contrato</span>
            </span>
            <span
              className={`text-[11px] font-semibold px-2 py-0.5 rounded-full ${
                isValid
                  ? 'bg-emerald-50 text-emerald-800 border border-emerald-200 dark:bg-emerald-950 dark:text-emerald-300'
                  : 'bg-rose-50 text-rose-800 border border-rose-200 dark:bg-rose-950 dark:text-rose-300'
              }`}
            >
              {isValid ? 'Listo para generar' : `${Object.keys(validationErrors).length} campo(s) pendiente(s)`}
            </span>
          </div>

          <div className="flex-1 p-4 sm:p-6 overflow-y-auto overflow-x-hidden space-y-3.5">
            {activeTemplate.variables.map((v) => renderField(v))}
          </div>
        </div>

        {/* Right: Real-time Synchronized Paginated Document Preview */}
        <div
          className={`h-full flex-col min-w-0 overflow-hidden bg-[#E8E5DF]/50 dark:bg-slate-950 ${
            mobileTab === 'FORM' ? 'hidden lg:flex lg:w-7/12' : 'flex w-full lg:w-7/12'
          }`}
        >
          <PaginatedDocumentPreview
            content={finalRenderedText}
            templateName={activeTemplate.name}
          />
        </div>
      </div>
    </div>
  );
};
