import React, { useState } from 'react';
import {
  FileCheck2,
  Download,
  Printer,
  FileText,
  Search,
  Trash2,
  Eye,
  Calendar,
  Layers,
  ChevronRight,
  Sparkles,
  Scale,
  ShieldCheck,
  CheckCircle2,
  Copy,
  Edit3,
  Save,
  RotateCcw,
  Plus,
  Filter,
  User,
  Building,
  Info,
  Clock,
  ArrowRight,
} from 'lucide-react';
import { useAppStore } from '../store/useAppStore';
import { GeneratedDocument, LegalTemplate } from '../types';
import { generateDocxBlob, generatePdfBlob } from '../core/exportEngine';

export const DocumentsVault: React.FC = () => {
  const {
    state,
    setView,
    setActiveTemplateId,
    deleteGeneratedDocument,
    updateGeneratedDocument,
    duplicateGeneratedDocument,
    restoreSampleGeneratedDocuments,
  } = useAppStore();

  const [searchQuery, setSearchQuery] = useState('');
  const [statusFilter, setStatusFilter] = useState<'ALL' | 'NOTARIADO' | 'EMITIDO' | 'BORRADOR' | 'ARCHIVADO'>('ALL');
  const [selectedDocId, setSelectedDocId] = useState<string | null>(
    state.generatedDocuments[0]?.id || null
  );
  const [activeTab, setActiveTab] = useState<'PREVIEW' | 'VARIABLES' | 'EDIT_TEXT'>('PREVIEW');
  const [editedText, setEditedText] = useState('');
  const [isEditing, setIsEditing] = useState(false);
  const [isNewModalOpen, setIsNewModalOpen] = useState(false);
  const [copiedKey, setCopiedKey] = useState<string | null>(null);
  const [toastMessage, setToastMessage] = useState<string | null>(null);

  const showToast = (msg: string) => {
    setToastMessage(msg);
    setTimeout(() => setToastMessage(null), 3500);
  };

  const selectedDoc = state.generatedDocuments.find((d) => d.id === selectedDocId) || state.generatedDocuments[0] || null;

  // Filtered documents
  const filteredDocs = state.generatedDocuments.filter((doc) => {
    const matchesSearch =
      doc.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      doc.templateName.toLowerCase().includes(searchQuery.toLowerCase()) ||
      (doc.author && doc.author.toLowerCase().includes(searchQuery.toLowerCase())) ||
      (doc.valuesSnapshot &&
        Object.values(doc.valuesSnapshot).some(
          (val) => typeof val === 'string' && val.toLowerCase().includes(searchQuery.toLowerCase())
        ));

    const matchesStatus =
      statusFilter === 'ALL' ||
      (statusFilter === 'NOTARIADO' && doc.status === 'NOTARIADO') ||
      (statusFilter === 'EMITIDO' && (doc.status === 'EMITIDO' || doc.status === 'APROBADO' || doc.status === 'GENERADO')) ||
      (statusFilter === 'BORRADOR' && (doc.status === 'BORRADOR' || doc.status === 'EN_REVISION')) ||
      (statusFilter === 'ARCHIVADO' && doc.status === 'ARCHIVADO');

    return matchesSearch && matchesStatus;
  });

  // Statistics
  const totalDocs = state.generatedDocuments.length;
  const notariadosCount = state.generatedDocuments.filter((d) => d.status === 'NOTARIADO').length;
  const emitidosCount = state.generatedDocuments.filter(
    (d) => d.status === 'EMITIDO' || d.status === 'APROBADO' || d.status === 'GENERADO'
  ).length;
  const borradoresCount = state.generatedDocuments.filter(
    (d) => d.status === 'BORRADOR' || d.status === 'EN_REVISION' || !d.status
  ).length;

  const handleDownloadDocx = async (doc: GeneratedDocument) => {
    try {
      const blob = await generateDocxBlob(doc.title, doc.renderedContent || doc.finalContent || '');
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `${doc.title.replace(/[^a-zA-Z0-9_-]/g, '_')}.docx`;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
      showToast('Documento Word (.docx) descargado correctamente.');
    } catch (err) {
      console.error('Error generating docx:', err);
      showToast('Error al generar archivo Word.');
    }
  };

  const handleDownloadPdf = async (doc: GeneratedDocument) => {
    try {
      const blob = await generatePdfBlob(doc.title, doc.renderedContent || doc.finalContent || '');
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `${doc.title.replace(/[^a-zA-Z0-9_-]/g, '_')}.pdf`;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
      showToast('Documento PDF descargado correctamente.');
    } catch (err) {
      console.error('Error generating pdf:', err);
      // Fallback: window print
      window.print();
    }
  };

  const handleStartEditing = () => {
    if (!selectedDoc) return;
    setEditedText(selectedDoc.renderedContent || selectedDoc.finalContent || '');
    setIsEditing(true);
    setActiveTab('EDIT_TEXT');
  };

  const handleSaveEditedText = () => {
    if (!selectedDoc) return;
    updateGeneratedDocument(selectedDoc.id, {
      renderedContent: editedText,
      finalContent: editedText,
    });
    setIsEditing(false);
    setActiveTab('PREVIEW');
    showToast('Modificaciones guardadas en el contrato final.');
  };

  const handleStatusChange = (newStatus: any) => {
    if (!selectedDoc) return;
    updateGeneratedDocument(selectedDoc.id, { status: newStatus });
    showToast(`Estado cambiado a: ${newStatus}`);
  };

  const handleDelete = (docId: string) => {
    if (confirm('¿Estás seguro de eliminar este contrato final de la bóveda? Esta acción no se puede deshacer.')) {
      deleteGeneratedDocument(docId);
      if (selectedDocId === docId) {
        setSelectedDocId(state.generatedDocuments.find((d) => d.id !== docId)?.id || null);
      }
      showToast('Contrato final eliminado de la bóveda.');
    }
  };

  const handleDuplicate = (docId: string) => {
    duplicateGeneratedDocument(docId);
    showToast('Copia del contrato creada con éxito.');
  };

  const copyToClipboard = (text: string, key: string) => {
    navigator.clipboard.writeText(text);
    setCopiedKey(key);
    setTimeout(() => setCopiedKey(null), 2000);
  };

  const handleSelectTemplateForNew = (template: LegalTemplate) => {
    setActiveTemplateId(template.id);
    setIsNewModalOpen(false);
    setView('FORM_GEN');
  };

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 space-y-6">
      {/* Toast Notification */}
      {toastMessage && (
        <div className="fixed bottom-6 right-6 z-50 bg-[#0D2C24] text-white px-4 py-3 rounded-xl shadow-2xl border border-[#164E3E] flex items-center space-x-2.5 text-xs animate-bounce">
          <CheckCircle2 className="w-4 h-4 text-[#FDE8B5] shrink-0" />
          <span className="font-medium">{toastMessage}</span>
        </div>
      )}

      {/* Main Header / Explanation Banner with SAVE Theme */}
      <div className="bg-[#0D2C24] dark:bg-slate-900 rounded-2xl border border-[#164E3E] dark:border-slate-800 p-6 text-white shadow-md space-y-4">
        <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
          <div>
            <div className="flex items-center space-x-2.5">
              <span className="inline-flex items-center space-x-1.5 bg-[#FDE8B5] text-[#0D2C24] px-2.5 py-0.5 rounded-md text-xs font-bold uppercase tracking-wider shadow-2xs">
                <FileCheck2 className="w-3.5 h-3.5 text-[#0D2C24]" />
                <span>Bóveda de Contratos Finales</span>
              </span>
              <span className="text-xs bg-[#08201A] dark:bg-slate-800 text-emerald-200/90 px-2 py-0.5 rounded font-mono font-medium border border-[#164E3E]">
                {totalDocs} contratos guardados
              </span>
            </div>
            <h1 className="text-2xl sm:text-3xl font-bold text-white font-serif mt-2">
              Contratos Finales Emitidos & Actos Notariados
            </h1>
            <p className="text-xs sm:text-sm text-emerald-100/80 dark:text-slate-300 mt-1.5 max-w-3xl leading-relaxed">
              Repositorio seguro de contratos terminados, listos para firma o legalizados con fe pública notarial dominicana. 
              Contienen los datos definitivos capturados de las partes, inmuebles y montos en letras.
            </p>
          </div>

          {/* Quick Actions */}
          <div className="flex flex-wrap items-center gap-2.5 shrink-0">
            <button
              onClick={() => setIsNewModalOpen(true)}
              className="flex items-center space-x-2 px-4 py-2.5 bg-[#FDE8B5] hover:bg-[#FCE19F] text-[#0D2C24] font-bold rounded-xl text-xs shadow-md transition-all cursor-pointer"
            >
              <Plus className="w-4 h-4 text-[#0D2C24]" />
              <span>+ Redactar Nuevo Contrato</span>
            </button>

            {state.generatedDocuments.length === 0 && (
              <button
                onClick={restoreSampleGeneratedDocuments}
                className="flex items-center space-x-1.5 px-3 py-2 bg-[#164E3E] hover:bg-[#1C604D] text-white rounded-xl text-xs font-medium border border-[#2D7A64] transition-colors cursor-pointer"
                title="Cargar contratos dominicanos de ejemplo"
              >
                <RotateCcw className="w-3.5 h-3.5 text-[#FDE8B5]" />
                <span>Cargar Ejemplos RD</span>
              </button>
            )}
          </div>
        </div>

        {/* Quick Stats Grid */}
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 pt-2 border-t border-[#164E3E] dark:border-slate-800 text-xs">
          <div className="bg-[#08201A] dark:bg-slate-800/50 p-3 rounded-xl border border-[#164E3E] dark:border-slate-700/40">
            <span className="text-[11px] font-semibold text-emerald-200/70 block">Total en Bóveda</span>
            <span className="text-xl font-bold text-white font-mono mt-0.5 block">{totalDocs}</span>
          </div>

          <div className="bg-[#08201A] dark:bg-slate-800/50 p-3 rounded-xl border border-[#164E3E] dark:border-slate-700/40">
            <span className="text-[11px] font-semibold text-emerald-200/70 block">⚖️ Notariados (Fe Pública)</span>
            <span className="text-xl font-bold text-[#FDE8B5] font-mono mt-0.5 block">{notariadosCount}</span>
          </div>

          <div className="bg-[#08201A] dark:bg-slate-800/50 p-3 rounded-xl border border-[#164E3E] dark:border-slate-700/40">
            <span className="text-[11px] font-semibold text-emerald-200/70 block">📝 Emitidos para Firma</span>
            <span className="text-xl font-bold text-white font-mono mt-0.5 block">{emitidosCount}</span>
          </div>

          <div className="bg-[#08201A] dark:bg-slate-800/50 p-3 rounded-xl border border-[#164E3E] dark:border-slate-700/40">
            <span className="text-[11px] font-semibold text-emerald-200/70 block">📄 Borradores Finales</span>
            <span className="text-xl font-bold text-[#C5A059] font-mono mt-0.5 block">{borradoresCount}</span>
          </div>
        </div>
      </div>

      {/* Main Content Layout: List on Left, Preview/Editor on Right */}
      {state.generatedDocuments.length === 0 ? (
        <div className="bg-white dark:bg-slate-900 rounded-2xl p-12 text-center border border-[#E8E5DF] dark:border-slate-800 shadow-xs space-y-4">
          <div className="w-16 h-16 rounded-full bg-[#F5F2ED] dark:bg-slate-800 border border-[#D1CCC4] dark:border-slate-700 flex items-center justify-center mx-auto text-[#0D2C24] dark:text-emerald-400">
            <FileCheck2 className="w-8 h-8" />
          </div>
          <h3 className="text-lg font-bold text-slate-900 dark:text-white font-serif">No hay contratos finales guardados</h3>
          <p className="text-xs text-slate-500 dark:text-slate-400 max-w-md mx-auto leading-relaxed">
            Puedes generar tu primer contrato legal llenando los datos en una plantilla o cargar los contratos dominicanos de muestra con actos de alquiler y pagarés auténticos.
          </p>
          <div className="flex items-center justify-center space-x-3 pt-2">
            <button
              onClick={() => setIsNewModalOpen(true)}
              className="px-4 py-2 bg-[#0D2C24] hover:bg-[#164E3E] text-white text-xs font-semibold rounded-xl shadow-xs transition-colors cursor-pointer"
            >
              Generar desde Plantilla
            </button>
            <button
              onClick={restoreSampleGeneratedDocuments}
              className="px-4 py-2 bg-[#F5F2ED] hover:bg-[#E8E5DF] text-[#0D2C24] text-xs font-semibold rounded-xl border border-[#D1CCC4] transition-colors cursor-pointer"
            >
              Cargar Muestras Dominicanas
            </button>
          </div>
        </div>
      ) : (
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
          {/* LEFT: Documents List & Search */}
          <div className="lg:col-span-5 bg-white dark:bg-slate-900 rounded-2xl border border-[#E8E5DF] dark:border-slate-800 shadow-xs overflow-hidden flex flex-col">
            {/* Search and Filters Header */}
            <div className="p-3 bg-[#F5F2ED]/60 dark:bg-slate-800/80 border-b border-[#E8E5DF] dark:border-slate-800 space-y-2.5">
              <div className="relative">
                <Search className="w-3.5 h-3.5 absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
                <input
                  type="text"
                  placeholder="Buscar por título, inquilino, deudor, cédula..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="w-full pl-8 pr-3 py-2 text-xs rounded-xl border border-[#D1CCC4] dark:border-slate-700 bg-white dark:bg-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-[#0D2C24]/20 shadow-2xs"
                />
              </div>

              {/* Status Filter Tabs */}
              <div className="flex items-center space-x-1 overflow-x-auto pb-1 text-[11px]">
                <button
                  onClick={() => setStatusFilter('ALL')}
                  className={`px-2.5 py-1 rounded-lg font-medium whitespace-nowrap transition-colors cursor-pointer ${
                    statusFilter === 'ALL'
                      ? 'bg-[#0D2C24] dark:bg-emerald-700 text-white font-bold'
                      : 'bg-white dark:bg-slate-800 text-slate-600 dark:text-slate-300 hover:bg-slate-100 border border-[#D1CCC4] dark:border-slate-700'
                  }`}
                >
                  Todos ({totalDocs})
                </button>
                <button
                  onClick={() => setStatusFilter('NOTARIADO')}
                  className={`px-2.5 py-1 rounded-lg font-medium whitespace-nowrap transition-colors cursor-pointer ${
                    statusFilter === 'NOTARIADO'
                      ? 'bg-[#0D2C24] text-[#FDE8B5] font-bold ring-1 ring-[#C5A059]'
                      : 'bg-white dark:bg-slate-800 text-[#0D2C24] dark:text-emerald-300 hover:bg-[#F5F2ED] border border-[#D1CCC4] dark:border-slate-700'
                  }`}
                >
                  Notariados ({notariadosCount})
                </button>
                <button
                  onClick={() => setStatusFilter('EMITIDO')}
                  className={`px-2.5 py-1 rounded-lg font-medium whitespace-nowrap transition-colors cursor-pointer ${
                    statusFilter === 'EMITIDO'
                      ? 'bg-[#0D2C24] text-white font-bold'
                      : 'bg-white dark:bg-slate-800 text-slate-700 dark:text-slate-300 hover:bg-[#F5F2ED] border border-[#D1CCC4] dark:border-slate-700'
                  }`}
                >
                  Emitidos ({emitidosCount})
                </button>
                <button
                  onClick={() => setStatusFilter('BORRADOR')}
                  className={`px-2.5 py-1 rounded-lg font-medium whitespace-nowrap transition-colors cursor-pointer ${
                    statusFilter === 'BORRADOR'
                      ? 'bg-[#C5A059] text-[#0D2C24] font-bold'
                      : 'bg-white dark:bg-slate-800 text-slate-700 dark:text-slate-300 hover:bg-[#F5F2ED] border border-[#D1CCC4] dark:border-slate-700'
                  }`}
                >
                  Borradores ({borradoresCount})
                </button>
              </div>
            </div>

            {/* List Items */}
            <div className="divide-y divide-[#E8E5DF] dark:divide-slate-800 max-h-[620px] overflow-y-auto">
              {filteredDocs.length === 0 ? (
                <div className="p-8 text-center text-slate-400 text-xs">
                  No se encontraron contratos con los filtros aplicados.
                </div>
              ) : (
                filteredDocs.map((doc) => {
                  const isSelected = selectedDoc?.id === doc.id;
                  const status = doc.status || 'EMITIDO';

                  return (
                    <button
                      key={doc.id}
                      onClick={() => {
                        setSelectedDocId(doc.id);
                        setIsEditing(false);
                        setActiveTab('PREVIEW');
                      }}
                      className={`w-full text-left p-4 transition-all flex items-start justify-between group cursor-pointer ${
                        isSelected
                          ? 'bg-[#F5F2ED] dark:bg-slate-800 border-l-4 border-[#0D2C24] dark:border-emerald-500 shadow-2xs'
                          : 'hover:bg-[#FAFAF8] dark:hover:bg-slate-800/50'
                      }`}
                    >
                      <div className="space-y-1.5 flex-1 pr-2">
                        <div className="flex items-center space-x-2">
                          <span
                            className={`text-[10px] font-bold px-2 py-0.5 rounded-md uppercase font-mono ${
                              status === 'NOTARIADO'
                                ? 'bg-[#0D2C24] text-[#FDE8B5] border border-[#164E3E]'
                                : status === 'EMITIDO' || status === 'APROBADO' || status === 'GENERADO'
                                ? 'bg-emerald-100 text-emerald-900 border border-emerald-300 dark:bg-emerald-950 dark:text-emerald-300'
                                : 'bg-[#FDE8B5] text-[#0D2C24] border border-[#C5A059]'
                            }`}
                          >
                            {status === 'NOTARIADO'
                              ? '⚖️ Notariado'
                              : status === 'EMITIDO'
                              ? '📝 Emitido'
                              : '📄 Borrador'}
                          </span>

                          <span className="text-[10px] text-slate-400 font-mono">
                            {doc.format || 'DOCX'}
                          </span>
                        </div>

                        <h4 className="font-serif font-bold text-xs text-slate-900 dark:text-white line-clamp-2 leading-snug">
                          {doc.title}
                        </h4>

                        <div className="text-[11px] text-slate-500 dark:text-slate-400 flex items-center space-x-1.5">
                          <span className="truncate">Plantilla base: {doc.templateName}</span>
                        </div>

                        <div className="flex items-center space-x-3 text-[10px] text-slate-400 pt-0.5">
                          <span className="flex items-center space-x-1">
                            <Clock className="w-3 h-3 text-slate-400" />
                            <span>
                              {doc.createdAt
                                ? new Date(doc.createdAt).toLocaleDateString('es-DO', {
                                    day: '2-digit',
                                    month: 'short',
                                    year: 'numeric',
                                  })
                                : 'Fecha no disponible'}
                            </span>
                          </span>
                          {doc.valuesSnapshot && (
                            <span>{Object.keys(doc.valuesSnapshot).length} datos capturados</span>
                          )}
                        </div>
                      </div>

                      <ChevronRight
                        className={`w-4 h-4 shrink-0 mt-2 transition-transform ${
                          isSelected ? 'text-[#0D2C24] dark:text-emerald-400 translate-x-0.5' : 'text-slate-300 group-hover:text-slate-500'
                        }`}
                      />
                    </button>
                  );
                })
              )}
            </div>
          </div>

          {/* RIGHT: Document Details & Viewer */}
          <div className="lg:col-span-7 bg-white dark:bg-slate-900 rounded-2xl border border-[#E8E5DF] dark:border-slate-800 shadow-xs overflow-hidden">
            {selectedDoc ? (
              <div>
                {/* Header Action Bar */}
                <div className="p-4 bg-[#F5F2ED]/60 dark:bg-slate-800/90 border-b border-[#E8E5DF] dark:border-slate-800 space-y-3">
                  <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
                    <div>
                      <div className="flex items-center space-x-2">
                        <select
                          value={selectedDoc.status || 'EMITIDO'}
                          onChange={(e) => handleStatusChange(e.target.value)}
                          className="text-[11px] font-bold px-2.5 py-1 rounded-lg border border-[#D1CCC4] dark:border-slate-700 bg-white dark:bg-slate-900 dark:text-white focus:ring-2 focus:ring-[#0D2C24]"
                        >
                          <option value="NOTARIADO">⚖️ Estado: Notariado (Fe Pública)</option>
                          <option value="EMITIDO">📝 Estado: Emitido / Listo para Firma</option>
                          <option value="BORRADOR">📄 Estado: Borrador Final</option>
                          <option value="ARCHIVADO">🗄️ Estado: Archivado</option>
                        </select>

                        <span className="text-[11px] text-slate-500 dark:text-slate-400 font-mono">
                          ID: {selectedDoc.id.slice(-8)}
                        </span>
                      </div>

                      <h3 className="font-serif font-bold text-base text-slate-900 dark:text-white mt-1">
                        {selectedDoc.title}
                      </h3>
                      <p className="text-[11px] text-slate-500 dark:text-slate-400">
                        Autor: {selectedDoc.author || 'Lic. Stephania Montero (CARD 14092)'} •{' '}
                        {selectedDoc.createdAt && new Date(selectedDoc.createdAt).toLocaleString('es-DO')}
                      </p>
                    </div>

                    {/* Export & Print Controls */}
                    <div className="flex items-center space-x-2 shrink-0">
                      <button
                        onClick={() => handleDownloadDocx(selectedDoc)}
                        className="flex items-center space-x-1 px-3 py-1.5 rounded-lg text-xs font-semibold bg-[#0D2C24] hover:bg-[#164E3E] text-white shadow-xs transition-colors cursor-pointer"
                        title="Descargar en formato Word editable (.docx)"
                      >
                        <Download className="w-3.5 h-3.5 text-[#FDE8B5]" />
                        <span>Word .DOCX</span>
                      </button>

                      <button
                        onClick={() => handleDownloadPdf(selectedDoc)}
                        className="flex items-center space-x-1 px-3 py-1.5 rounded-lg text-xs font-semibold bg-[#F5F2ED] hover:bg-[#E8E5DF] text-[#0D2C24] border border-[#D1CCC4] dark:bg-slate-800 dark:text-white dark:border-slate-700 shadow-xs transition-colors cursor-pointer"
                        title="Descargar o imprimir PDF Notarial"
                      >
                        <Printer className="w-3.5 h-3.5" />
                        <span>PDF / Imprimir</span>
                      </button>
                    </div>
                  </div>

                  {/* Secondary Toolbar (Tabs + Actions) */}
                  <div className="flex flex-wrap items-center justify-between gap-2 pt-2 border-t border-[#E8E5DF] dark:border-slate-800">
                    <div className="flex items-center space-x-1 bg-[#E8E5DF]/70 dark:bg-slate-800 p-1 rounded-xl">
                      <button
                        onClick={() => {
                          setIsEditing(false);
                          setActiveTab('PREVIEW');
                        }}
                        className={`px-3 py-1 rounded-lg text-xs font-semibold transition-all cursor-pointer ${
                          activeTab === 'PREVIEW'
                            ? 'bg-white dark:bg-slate-900 text-[#0D2C24] dark:text-white shadow-xs font-bold'
                            : 'text-slate-600 dark:text-slate-400 hover:text-slate-900'
                        }`}
                      >
                        Vista Notarial Formal
                      </button>

                      <button
                        onClick={() => {
                          setIsEditing(false);
                          setActiveTab('VARIABLES');
                        }}
                        className={`px-3 py-1 rounded-lg text-xs font-semibold transition-all cursor-pointer ${
                          activeTab === 'VARIABLES'
                            ? 'bg-white dark:bg-slate-900 text-[#0D2C24] dark:text-white shadow-xs font-bold'
                            : 'text-slate-600 dark:text-slate-400 hover:text-slate-900'
                        }`}
                      >
                        Snapshot de Datos ({selectedDoc.valuesSnapshot ? Object.keys(selectedDoc.valuesSnapshot).length : 0})
                      </button>

                      <button
                        onClick={handleStartEditing}
                        className={`px-3 py-1 rounded-lg text-xs font-semibold transition-all cursor-pointer ${
                          activeTab === 'EDIT_TEXT'
                            ? 'bg-white dark:bg-slate-900 text-[#0D2C24] dark:text-white shadow-xs font-bold'
                            : 'text-slate-600 dark:text-slate-400 hover:text-slate-900'
                        }`}
                      >
                        <span className="flex items-center space-x-1">
                          <Edit3 className="w-3 h-3" />
                          <span>Editar Texto</span>
                        </span>
                      </button>
                    </div>

                    <div className="flex items-center space-x-1.5">
                      <button
                        onClick={() => handleDuplicate(selectedDoc.id)}
                        className="px-2.5 py-1 text-[11px] font-medium text-slate-600 dark:text-slate-300 hover:bg-[#E8E5DF] dark:hover:bg-slate-800 rounded-lg transition-colors flex items-center space-x-1 cursor-pointer"
                        title="Duplicar como nuevo contrato"
                      >
                        <Copy className="w-3 h-3" />
                        <span>Duplicar</span>
                      </button>

                      <button
                        onClick={() => handleDelete(selectedDoc.id)}
                        className="px-2.5 py-1 text-[11px] font-medium text-rose-600 hover:bg-rose-50 rounded-lg transition-colors flex items-center space-x-1 cursor-pointer"
                        title="Eliminar contrato de la bóveda"
                      >
                        <Trash2 className="w-3 h-3" />
                        <span>Eliminar</span>
                      </button>
                    </div>
                  </div>
                </div>

                {/* TAB 1: NOTARIAL PREVIEW */}
                {activeTab === 'PREVIEW' && (
                  <div className="p-6 bg-[#FAFAF8] dark:bg-slate-950/50 max-h-[580px] overflow-y-auto">
                    {/* Clean Document Sheet */}
                    <div className="bg-white dark:bg-slate-900 p-8 sm:p-12 rounded-xl shadow-md border border-[#E8E5DF] dark:border-slate-800 max-w-3xl mx-auto font-serif text-slate-900 dark:text-slate-100 text-xs sm:text-sm leading-relaxed space-y-4 relative">
                      {/* Rendered Contract Text */}
                      <div className="whitespace-pre-wrap selection:bg-[#FDE8B5] dark:selection:bg-emerald-950 font-serif text-slate-800 dark:text-slate-100 text-xs sm:text-[13px] leading-relaxed">
                        {selectedDoc.renderedContent || selectedDoc.finalContent}
                      </div>
                    </div>
                  </div>
                )}

                {/* TAB 2: VARIABLES & CAPTURED DATA SNAPSHOT */}
                {activeTab === 'VARIABLES' && (
                  <div className="p-6 max-h-[580px] overflow-y-auto space-y-4">
                    <div className="bg-[#F5F2ED] dark:bg-slate-800 p-3.5 rounded-xl border border-[#D1CCC4] dark:border-slate-700 text-xs text-[#0D2C24] dark:text-emerald-300 flex items-start space-x-2.5">
                      <Info className="w-4 h-4 text-[#C5A059] shrink-0 mt-0.5" />
                      <div>
                        <span className="font-bold">Snapshot de Datos Capturados:</span>
                        <p className="text-slate-600 dark:text-slate-300 text-[11px] mt-0.5">
                          Estos son los valores y respuestas capturados de los comparecientes al momento de emitir este contrato final.
                        </p>
                      </div>
                    </div>

                    {selectedDoc.valuesSnapshot && Object.keys(selectedDoc.valuesSnapshot).length > 0 ? (
                      <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                        {Object.entries(selectedDoc.valuesSnapshot).map(([key, value]) => (
                          <div
                            key={key}
                            className="bg-white dark:bg-slate-900 p-3 rounded-xl border border-[#E8E5DF] dark:border-slate-800 shadow-2xs space-y-1 relative group hover:border-[#0D2C24] transition-colors"
                          >
                            <div className="flex items-center justify-between">
                              <span className="font-mono text-[10px] text-[#0D2C24] dark:text-emerald-400 bg-[#F5F2ED] dark:bg-slate-800 px-1.5 py-0.5 rounded border border-[#E8E5DF] dark:border-slate-700">
                                {`{{${key}}}`}
                              </span>
                              <button
                                onClick={() => copyToClipboard(String(value), key)}
                                className="text-slate-400 hover:text-slate-600 p-1 rounded cursor-pointer"
                                title="Copiar valor"
                              >
                                {copiedKey === key ? (
                                  <CheckCircle2 className="w-3 h-3 text-emerald-600" />
                                ) : (
                                  <Copy className="w-3 h-3" />
                                )}
                              </button>
                            </div>
                            <div className="text-xs font-semibold text-slate-800 dark:text-slate-200 break-words">
                              {value === true
                                ? 'Sí (Verdadero)'
                                : value === false
                                ? 'No (Falso)'
                                : String(value)}
                            </div>
                          </div>
                        ))}
                      </div>
                    ) : (
                      <div className="p-8 text-center text-slate-400 text-xs">
                        No hay datos adicionales registrados en el snapshot de este contrato.
                      </div>
                    )}
                  </div>
                )}

                {/* TAB 3: INLINE TEXT EDITOR */}
                {activeTab === 'EDIT_TEXT' && (
                  <div className="p-4 space-y-3">
                    <div className="flex items-center justify-between bg-[#F5F2ED] dark:bg-slate-800 p-3 rounded-xl border border-[#D1CCC4] dark:border-slate-700 text-xs text-[#0D2C24] dark:text-emerald-300">
                      <span>Modificando el texto final de este contrato específico en la bóveda:</span>
                      <button
                        onClick={handleSaveEditedText}
                        className="flex items-center space-x-1.5 px-3 py-1.5 bg-[#0D2C24] hover:bg-[#164E3E] text-white font-semibold rounded-lg text-xs shadow-xs cursor-pointer"
                      >
                        <Save className="w-3.5 h-3.5 text-[#FDE8B5]" />
                        <span>Guardar Cambios</span>
                      </button>
                    </div>

                    <textarea
                      value={editedText}
                      onChange={(e) => setEditedText(e.target.value)}
                      rows={20}
                      className="w-full p-4 rounded-xl border border-[#D1CCC4] dark:border-slate-700 font-serif text-xs leading-relaxed focus:ring-2 focus:ring-[#0D2C24] focus:outline-none bg-[#FAFAF8] dark:bg-slate-900 dark:text-white"
                    />
                  </div>
                )}
              </div>
            ) : (
              <div className="p-12 text-center text-slate-400 text-xs">
                Selecciona un contrato de la lista izquierda para previsualizar sus cláusulas y datos.
              </div>
            )}
          </div>
        </div>
      )}

      {/* SELECT TEMPLATE MODAL FOR NEW FINAL CONTRACT */}
      {isNewModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/60 backdrop-blur-xs animate-in fade-in">
          <div className="bg-white dark:bg-slate-900 rounded-2xl max-w-xl w-full p-6 shadow-2xl border border-[#E8E5DF] dark:border-slate-800 space-y-4">
            <div className="flex items-center justify-between pb-3 border-b border-[#E8E5DF] dark:border-slate-800">
              <div className="flex items-center space-x-2">
                <div className="w-8 h-8 rounded-lg bg-[#F5F2ED] dark:bg-slate-800 flex items-center justify-center text-[#0D2C24] dark:text-emerald-400">
                  <Sparkles className="w-4 h-4 text-[#C5A059]" />
                </div>
                <div>
                  <h3 className="font-bold text-slate-900 dark:text-white text-sm font-serif">Emitir Nuevo Contrato Final</h3>
                  <p className="text-xs text-slate-500 dark:text-slate-400">Selecciona la plantilla base para completar los datos de las partes:</p>
                </div>
              </div>
              <button
                onClick={() => setIsNewModalOpen(false)}
                className="text-slate-400 hover:text-slate-600 dark:hover:text-white text-sm font-bold p-1 rounded cursor-pointer"
              >
                ✕
              </button>
            </div>

            <div className="space-y-2 max-h-[380px] overflow-y-auto">
              {state.templates.map((tpl) => (
                <button
                  key={tpl.id}
                  onClick={() => handleSelectTemplateForNew(tpl)}
                  className="w-full text-left p-3.5 rounded-xl border border-[#E8E5DF] dark:border-slate-800 hover:border-[#0D2C24] dark:hover:border-emerald-500 hover:bg-[#F5F2ED]/50 dark:hover:bg-slate-800/50 transition-all flex items-center justify-between group cursor-pointer"
                >
                  <div className="space-y-1">
                    <div className="flex items-center space-x-2">
                      <span className="font-semibold text-xs text-slate-900 dark:text-white group-hover:text-[#0D2C24] dark:group-hover:text-emerald-400">
                        {tpl.name}
                      </span>
                      <span className="text-[10px] bg-[#0D2C24] text-white px-1.5 py-0.2 rounded font-mono">
                        {tpl.category}
                      </span>
                    </div>
                    <p className="text-[11px] text-slate-500 dark:text-slate-400 line-clamp-1">{tpl.description}</p>
                    <span className="text-[10px] text-slate-400 block font-mono">
                      {tpl.variables.length} variables • {tpl.clauses.length} cláusulas
                    </span>
                  </div>

                  <ArrowRight className="w-4 h-4 text-slate-400 group-hover:text-[#0D2C24] dark:group-hover:text-emerald-400 shrink-0 group-hover:translate-x-1 transition-transform" />
                </button>
              ))}
            </div>

            <div className="pt-2 flex justify-end">
              <button
                onClick={() => setIsNewModalOpen(false)}
                className="px-4 py-2 rounded-xl text-xs font-semibold text-slate-600 dark:text-slate-300 hover:bg-[#F5F2ED] dark:hover:bg-slate-800 cursor-pointer"
              >
                Cancelar
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
