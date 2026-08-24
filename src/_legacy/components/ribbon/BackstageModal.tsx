import React, { useState } from 'react';
import {
  FileText,
  Save,
  Printer,
  Share2,
  Download,
  FolderOpen,
  Plus,
  Info,
  User,
  Settings,
  ArrowLeft,
  CheckCircle2,
  ShieldCheck,
  Building,
  Scale,
  Award,
  BookOpen,
  Copy,
  Check,
} from 'lucide-react';
import { useAppStore } from '../../store/useAppStore';
import { generateDocxBlob, generatePdfBlob, generateSchemaJson } from '../../core/exportEngine';

interface BackstageModalProps {
  isOpen: boolean;
  onClose: () => void;
  renderedText: string;
}

export const BackstageModal: React.FC<BackstageModalProps> = ({
  isOpen,
  onClose,
  renderedText,
}) => {
  const {
    activeTemplate,
    currentUser,
    updateTemplate,
    createTemplate,
    duplicateTemplate,
    saveGeneratedDocument,
    setView,
  } = useAppStore();

  const [activeTab, setActiveTab] = useState<
    'INFO' | 'NEW' | 'OPEN' | 'SAVE' | 'SAVE_AS' | 'PRINT' | 'SHARE' | 'EXPORT' | 'ACCOUNT' | 'OPTIONS'
  >('INFO');

  const [copiedLink, setCopiedLink] = useState(false);
  const [exportMessage, setExportMessage] = useState<string | null>(null);

  if (!isOpen || !activeTemplate) return null;

  const handleDownloadDocx = async () => {
    try {
      const title = activeTemplate.name;
      const blob = await generateDocxBlob(title, renderedText);
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `${title.replace(/[^a-zA-Z0-9_-]/g, '_')}.docx`;
      a.click();
      URL.revokeObjectURL(url);
      setExportMessage('Documento DOCX exportado exitosamente.');
      setTimeout(() => setExportMessage(null), 3000);
    } catch (e: any) {
      alert(`Error exportando DOCX: ${e.message}`);
    }
  };

  const handleDownloadPdf = () => {
    try {
      const title = activeTemplate.name;
      const blob = generatePdfBlob(title, renderedText);
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `${title.replace(/[^a-zA-Z0-9_-]/g, '_')}.pdf`;
      a.click();
      URL.revokeObjectURL(url);
      setExportMessage('Documento PDF generado y descargado.');
      setTimeout(() => setExportMessage(null), 3000);
    } catch (e: any) {
      alert(`Error exportando PDF: ${e.message}`);
    }
  };

  const handleDownloadJson = () => {
    const jsonStr = generateSchemaJson(activeTemplate);
    const blob = new Blob([jsonStr], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `${activeTemplate.name.replace(/[^a-zA-Z0-9_-]/g, '_')}_schema.json`;
    a.click();
    URL.revokeObjectURL(url);
    setExportMessage('Esquema JSON Schema exportado.');
    setTimeout(() => setExportMessage(null), 3000);
  };

  const handlePrint = () => {
    window.print();
  };

  const handleCopyLink = () => {
    navigator.clipboard.writeText(window.location.href);
    setCopiedLink(true);
    setTimeout(() => setCopiedLink(false), 2500);
  };

  return (
    <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-xs flex overflow-hidden animate-in fade-in">
      {/* Backstage Left Navigation Bar with SAVE branding */}
      <div className="w-64 bg-[#0D2C24] text-white flex flex-col shrink-0 border-r border-[#164E3E] shadow-2xl">
        {/* Back Button */}
        <div className="p-4 border-b border-[#164E3E] flex items-center space-x-3">
          <button
            onClick={onClose}
            className="p-2 rounded-xl hover:bg-[#164E3E] text-[#FDE8B5] transition-colors cursor-pointer"
            title="Volver al documento"
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div>
            <h2 className="text-sm font-bold font-serif tracking-tight text-white">Menú Archivo</h2>
            <p className="text-[11px] text-[#FDE8B5]/80">SAVE Legal RD • Backstage</p>
          </div>
        </div>

        {/* Tab Buttons */}
        <div className="flex-1 p-3 space-y-1 overflow-y-auto">
          <button
            onClick={() => setActiveTab('INFO')}
            className={`w-full flex items-center space-x-3 px-3 py-2.5 rounded-xl text-xs font-bold transition-all cursor-pointer ${
              activeTab === 'INFO' ? 'bg-[#FDE8B5] text-[#0D2C24] shadow-md font-bold' : 'text-slate-200 hover:bg-[#164E3E]'
            }`}
          >
            <Info className="w-4 h-4" />
            <span>Información del Documento</span>
          </button>

          <button
            onClick={() => setActiveTab('NEW')}
            className={`w-full flex items-center space-x-3 px-3 py-2.5 rounded-xl text-xs font-bold transition-all cursor-pointer ${
              activeTab === 'NEW' ? 'bg-[#FDE8B5] text-[#0D2C24] shadow-md font-bold' : 'text-slate-200 hover:bg-[#164E3E]'
            }`}
          >
            <Plus className="w-4 h-4" />
            <span>Nuevo</span>
          </button>

          <button
            onClick={() => setActiveTab('OPEN')}
            className={`w-full flex items-center space-x-3 px-3 py-2.5 rounded-xl text-xs font-bold transition-all cursor-pointer ${
              activeTab === 'OPEN' ? 'bg-[#FDE8B5] text-[#0D2C24] shadow-md font-bold' : 'text-slate-200 hover:bg-[#164E3E]'
            }`}
          >
            <FolderOpen className="w-4 h-4" />
            <span>Abrir Plantilla</span>
          </button>

          <button
            onClick={() => setActiveTab('SAVE')}
            className={`w-full flex items-center space-x-3 px-3 py-2.5 rounded-xl text-xs font-bold transition-all cursor-pointer ${
              activeTab === 'SAVE' ? 'bg-[#FDE8B5] text-[#0D2C24] shadow-md font-bold' : 'text-slate-200 hover:bg-[#164E3E]'
            }`}
          >
            <Save className="w-4 h-4" />
            <span>Guardar Cambios</span>
          </button>

          <button
            onClick={() => setActiveTab('SAVE_AS')}
            className={`w-full flex items-center space-x-3 px-3 py-2.5 rounded-xl text-xs font-bold transition-all cursor-pointer ${
              activeTab === 'SAVE_AS' ? 'bg-[#FDE8B5] text-[#0D2C24] shadow-md font-bold' : 'text-slate-200 hover:bg-[#164E3E]'
            }`}
          >
            <Copy className="w-4 h-4" />
            <span>Guardar Como Copia</span>
          </button>

          <div className="border-t border-[#164E3E] my-2 pt-2" />

          <button
            onClick={() => setActiveTab('PRINT')}
            className={`w-full flex items-center space-x-3 px-3 py-2.5 rounded-xl text-xs font-bold transition-all cursor-pointer ${
              activeTab === 'PRINT' ? 'bg-[#FDE8B5] text-[#0D2C24] shadow-md font-bold' : 'text-slate-200 hover:bg-[#164E3E]'
            }`}
          >
            <Printer className="w-4 h-4" />
            <span>Imprimir</span>
          </button>

          <button
            onClick={() => setActiveTab('SHARE')}
            className={`w-full flex items-center space-x-3 px-3 py-2.5 rounded-xl text-xs font-bold transition-all cursor-pointer ${
              activeTab === 'SHARE' ? 'bg-[#FDE8B5] text-[#0D2C24] shadow-md font-bold' : 'text-slate-200 hover:bg-[#164E3E]'
            }`}
          >
            <Share2 className="w-4 h-4" />
            <span>Compartir</span>
          </button>

          <button
            onClick={() => setActiveTab('EXPORT')}
            className={`w-full flex items-center space-x-3 px-3 py-2.5 rounded-xl text-xs font-bold transition-all cursor-pointer ${
              activeTab === 'EXPORT' ? 'bg-[#FDE8B5] text-[#0D2C24] shadow-md font-bold' : 'text-slate-200 hover:bg-[#164E3E]'
            }`}
          >
            <Download className="w-4 h-4" />
            <span>Exportar (DOCX, PDF, JSON)</span>
          </button>

          <div className="border-t border-[#164E3E] my-2 pt-2" />

          <button
            onClick={() => setActiveTab('ACCOUNT')}
            className={`w-full flex items-center space-x-3 px-3 py-2.5 rounded-xl text-xs font-bold transition-all cursor-pointer ${
              activeTab === 'ACCOUNT' ? 'bg-[#FDE8B5] text-[#0D2C24] shadow-md font-bold' : 'text-slate-200 hover:bg-[#164E3E]'
            }`}
          >
            <User className="w-4 h-4" />
            <span>Cuenta y Colegiatura CARD</span>
          </button>

          <button
            onClick={() => setActiveTab('OPTIONS')}
            className={`w-full flex items-center space-x-3 px-3 py-2.5 rounded-xl text-xs font-bold transition-all cursor-pointer ${
              activeTab === 'OPTIONS' ? 'bg-[#FDE8B5] text-[#0D2C24] shadow-md font-bold' : 'text-slate-200 hover:bg-[#164E3E]'
            }`}
          >
            <Settings className="w-4 h-4" />
            <span>Opciones de la Aplicación</span>
          </button>
        </div>
      </div>

      {/* Backstage Content Area */}
      <div className="flex-1 bg-white dark:bg-slate-900 flex flex-col overflow-y-auto overflow-x-hidden p-8 sm:p-12 text-slate-800 dark:text-slate-200">
        {exportMessage && (
          <div className="mb-6 p-4 bg-emerald-50 dark:bg-emerald-950/30 border border-emerald-200 dark:border-emerald-800 text-emerald-800 dark:text-emerald-300 rounded-xl flex items-center space-x-3 shadow-xs">
            <CheckCircle2 className="w-5 h-5 text-emerald-600" />
            <span className="text-sm font-semibold">{exportMessage}</span>
          </div>
        )}

        {/* INFO TAB */}
        {activeTab === 'INFO' && (
          <div className="max-w-3xl space-y-6">
            <div>
              <h1 className="text-2xl font-serif font-bold text-slate-900 dark:text-white">Información del Acto Notarial</h1>
              <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">Propiedades solemnes, autoría y estado regulatorio bajo la Ley 140-15</p>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div className="p-5 bg-[#F5F2ED] dark:bg-slate-800/80 border border-[#E8E5DF] dark:border-slate-700 rounded-2xl space-y-2">
                <span className="text-[11px] font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider">Título del Documento</span>
                <p className="font-serif font-bold text-base text-slate-900 dark:text-white">{activeTemplate.name}</p>
                <p className="text-xs text-slate-500 dark:text-slate-400">{activeTemplate.description || 'Sin descripción adicional.'}</p>
              </div>

              <div className="p-5 bg-[#F5F2ED] dark:bg-slate-800/80 border border-[#E8E5DF] dark:border-slate-700 rounded-2xl space-y-2">
                <span className="text-[11px] font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider">Autor Jurídico & Notaría</span>
                <p className="font-semibold text-sm text-slate-800 dark:text-white">{currentUser.name}</p>
                <p className="text-xs text-[#0D2C24] dark:text-emerald-400 font-mono font-bold">{currentUser.cardRegistration} • {currentUser.notaryRegistration}</p>
                <p className="text-xs text-slate-500 dark:text-slate-400">{currentUser.lawFirm}</p>
              </div>

              <div className="p-5 bg-[#F5F2ED] dark:bg-slate-800/80 border border-[#E8E5DF] dark:border-slate-700 rounded-2xl space-y-2">
                <span className="text-[11px] font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider">Metadatos de Estructura</span>
                <div className="grid grid-cols-2 gap-2 text-xs">
                  <div>
                    <span className="text-slate-400">Versión:</span> <span className="font-mono font-bold text-slate-800 dark:text-white">v{activeTemplate.version}</span>
                  </div>
                  <div>
                    <span className="text-slate-400">Variables:</span> <span className="font-bold text-slate-800 dark:text-white">{activeTemplate.variables.length}</span>
                  </div>
                  <div>
                    <span className="text-slate-400">Cláusulas:</span> <span className="font-bold text-slate-800 dark:text-white">{activeTemplate.clauses.length}</span>
                  </div>
                  <div>
                    <span className="text-slate-400">Reglas:</span> <span className="font-bold text-slate-800 dark:text-white">{activeTemplate.rules.length}</span>
                  </div>
                </div>
              </div>

              <div className="p-5 bg-[#F5F2ED] dark:bg-slate-800/80 border border-[#E8E5DF] dark:border-slate-700 rounded-2xl space-y-2">
                <span className="text-[11px] font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider">Jurisdicción y Vigencia</span>
                <p className="text-xs font-semibold text-slate-800 dark:text-white">República Dominicana 🇩🇴</p>
                <p className="text-xs text-slate-500 dark:text-slate-400">Última modificación: {new Date(activeTemplate.updatedAt).toLocaleString()}</p>
              </div>
            </div>
          </div>
        )}

        {/* NEW TAB */}
        {activeTab === 'NEW' && (
          <div className="max-w-3xl space-y-6">
            <div>
              <h1 className="text-2xl font-serif font-bold text-slate-900 dark:text-white">Crear Nuevo Documento o Plantilla</h1>
              <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">Selecciona una plantilla base o inicia un borrador desde cero</p>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <button
                onClick={() => {
                  createTemplate({
                    name: 'Nuevo Contrato Notarial en Blanco',
                    description: 'Documento en blanco para redacción notarial libre',
                    category: 'Civil',
                    content: 'ACTO NÚMERO ______.- En la ciudad de Santo Domingo, Distrito Nacional, Capital de la República Dominicana...',
                  });
                  onClose();
                  setView('EDITOR');
                }}
                className="p-6 bg-[#F5F2ED] dark:bg-slate-800/80 hover:bg-[#E8E5DF] border-2 border-dashed border-[#D1CCC4] dark:border-slate-700 rounded-2xl text-left transition-all group cursor-pointer"
              >
                <Plus className="w-8 h-8 text-[#0D2C24] dark:text-emerald-400 mb-3 group-hover:scale-110 transition-transform" />
                <h3 className="font-bold text-sm text-slate-900 dark:text-white">Documento en Blanco</h3>
                <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">Inicia con hoja notarial limpia y añade variables o cláusulas a discreción.</p>
              </button>

              <button
                onClick={() => {
                  onClose();
                  setView('TEMPLATES');
                }}
                className="p-6 bg-[#F5F2ED] dark:bg-slate-800/80 hover:bg-[#E8E5DF] border border-[#E8E5DF] dark:border-slate-700 rounded-2xl text-left transition-all cursor-pointer"
              >
                <BookOpen className="w-8 h-8 text-[#C5A059] mb-3" />
                <h3 className="font-bold text-sm text-slate-900 dark:text-white">Desde Catálogo Notarial</h3>
                <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">Elige entre contratos de alquiler, pagarés notariales, poderes y ventas de inmuebles.</p>
              </button>
            </div>
          </div>
        )}

        {/* OPEN TAB */}
        {activeTab === 'OPEN' && (
          <div className="max-w-3xl space-y-6">
            <div>
              <h1 className="text-2xl font-serif font-bold text-slate-900 dark:text-white">Abrir Plantilla Existente</h1>
              <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">Navega por la biblioteca de actos y contratos guardados</p>
            </div>
            <button
              onClick={() => {
                onClose();
                setView('TEMPLATES');
              }}
              className="px-5 py-2.5 bg-[#0D2C24] hover:bg-[#164E3E] text-[#FDE8B5] text-xs font-bold rounded-xl shadow-sm transition-colors cursor-pointer"
            >
              Explorar Catálogo Notarial Completo
            </button>
          </div>
        )}

        {/* SAVE TAB */}
        {activeTab === 'SAVE' && (
          <div className="max-w-3xl space-y-6">
            <div>
              <h1 className="text-2xl font-serif font-bold text-slate-900 dark:text-white">Guardar Cambios</h1>
              <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">Sincroniza todas las modificaciones en el almacenamiento seguro</p>
            </div>
            <div className="p-6 bg-emerald-50 dark:bg-emerald-950/30 border border-emerald-200 dark:border-emerald-800 rounded-2xl flex items-center space-x-3 text-emerald-900 dark:text-emerald-300">
              <CheckCircle2 className="w-6 h-6 text-emerald-600 dark:text-emerald-400" />
              <div>
                <p className="font-bold text-sm">Cambios Guardados Automáticamente</p>
                <p className="text-xs text-emerald-700 dark:text-emerald-400">Todas las modificaciones a variables y texto se persisten en tiempo real.</p>
              </div>
            </div>
          </div>
        )}

        {/* SAVE AS TAB */}
        {activeTab === 'SAVE_AS' && (
          <div className="max-w-3xl space-y-6">
            <div>
              <h1 className="text-2xl font-serif font-bold text-slate-900 dark:text-white">Guardar Como Copia</h1>
              <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">Crea un clon de esta plantilla para utilizarlo como variante</p>
            </div>
            <button
              onClick={() => {
                duplicateTemplate(activeTemplate.id);
                onClose();
              }}
              className="px-5 py-2.5 bg-[#0D2C24] hover:bg-[#164E3E] text-[#FDE8B5] text-xs font-bold rounded-xl shadow-sm cursor-pointer"
            >
              Duplicar esta Plantilla ahora
            </button>
          </div>
        )}

        {/* PRINT TAB */}
        {activeTab === 'PRINT' && (
          <div className="max-w-3xl space-y-6">
            <div>
              <h1 className="text-2xl font-serif font-bold text-slate-900 dark:text-white">Imprimir Documento Notarial</h1>
              <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">Configuración de impresión notarial tamaño Legal / Carta</p>
            </div>
            <button
              onClick={handlePrint}
              className="px-5 py-2.5 bg-[#0D2C24] hover:bg-[#164E3E] text-white text-xs font-bold rounded-xl shadow-sm flex items-center space-x-2 cursor-pointer"
            >
              <Printer className="w-4 h-4 text-[#FDE8B5]" />
              <span>Abrir Cuadro de Diálogo de Impresión</span>
            </button>
          </div>
        )}

        {/* SHARE TAB */}
        {activeTab === 'SHARE' && (
          <div className="max-w-3xl space-y-6">
            <div>
              <h1 className="text-2xl font-serif font-bold text-slate-900 dark:text-white">Compartir Acto Notarial</h1>
              <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">Envía el enlace o documento a partes firmantes o colegas</p>
            </div>
            <div className="flex items-center space-x-2">
              <input
                type="text"
                readOnly
                value={window.location.href}
                className="w-full px-3 py-2 text-xs bg-[#FAFAF8] dark:bg-slate-800 border border-[#D1CCC4] dark:border-slate-700 rounded-xl"
              />
              <button
                onClick={handleCopyLink}
                className="px-4 py-2 bg-[#0D2C24] hover:bg-[#164E3E] text-white text-xs font-bold rounded-xl shrink-0 flex items-center space-x-1 cursor-pointer"
              >
                {copiedLink ? <Check className="w-4 h-4 text-[#FDE8B5]" /> : <Copy className="w-4 h-4 text-[#FDE8B5]" />}
                <span>{copiedLink ? 'Copiado' : 'Copiar Enlace'}</span>
              </button>
            </div>
          </div>
        )}

        {/* EXPORT TAB */}
        {activeTab === 'EXPORT' && (
          <div className="max-w-3xl space-y-6">
            <div>
              <h1 className="text-2xl font-serif font-bold text-slate-900 dark:text-white">Exportar Documento</h1>
              <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">Descarga el acto notarial en formatos estándar de la industria</p>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
              <button
                onClick={handleDownloadDocx}
                className="p-5 bg-[#F5F2ED] dark:bg-slate-800/80 hover:bg-[#E8E5DF] border border-[#E8E5DF] dark:border-slate-700 rounded-2xl text-left transition-all cursor-pointer"
              >
                <FileText className="w-8 h-8 text-[#0D2C24] dark:text-emerald-400 mb-2" />
                <h3 className="font-bold text-sm text-slate-900 dark:text-white">Microsoft Word (.DOCX)</h3>
                <p className="text-[11px] text-slate-500 dark:text-slate-400 mt-1">Formato nativo editable con estilos y numeración notarial.</p>
              </button>

              <button
                onClick={handleDownloadPdf}
                className="p-5 bg-[#F5F2ED] dark:bg-slate-800/80 hover:bg-[#E8E5DF] border border-[#E8E5DF] dark:border-slate-700 rounded-2xl text-left transition-all cursor-pointer"
              >
                <Download className="w-8 h-8 text-[#C5A059] mb-2" />
                <h3 className="font-bold text-sm text-slate-900 dark:text-white">Documento PDF (.PDF)</h3>
                <p className="text-[11px] text-slate-500 dark:text-slate-400 mt-1">Listo para impresión física o firma digital con sellos.</p>
              </button>

              <button
                onClick={handleDownloadJson}
                className="p-5 bg-[#F5F2ED] dark:bg-slate-800/80 hover:bg-[#E8E5DF] border border-[#E8E5DF] dark:border-slate-700 rounded-2xl text-left transition-all cursor-pointer"
              >
                <Scale className="w-8 h-8 text-emerald-600 mb-2" />
                <h3 className="font-bold text-sm text-slate-900 dark:text-white">Contrato schema.json</h3>
                <p className="text-[11px] text-slate-500 dark:text-slate-400 mt-1">JSON Schema Draft-07 para interoperabilidad técnica.</p>
              </button>
            </div>
          </div>
        )}

        {/* ACCOUNT TAB */}
        {activeTab === 'ACCOUNT' && (
          <div className="max-w-3xl space-y-6">
            <div>
              <h1 className="text-2xl font-serif font-bold text-slate-900 dark:text-white">Cuenta y Colegiatura Jurídica</h1>
              <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">Acreditación legal y datos de firma autorizada</p>
            </div>
            <div className="p-6 bg-[#F5F2ED] dark:bg-slate-800/80 border border-[#E8E5DF] dark:border-slate-700 rounded-2xl space-y-3">
              <p className="font-bold text-sm text-slate-900 dark:text-white">{currentUser.name}</p>
              <p className="text-xs text-slate-600 dark:text-slate-300">Rol: <span className="font-bold text-[#0D2C24] dark:text-emerald-400">{currentUser.role}</span></p>
              <p className="text-xs text-slate-600 dark:text-slate-300">Colegio de Abogados CARD: {currentUser.cardRegistration}</p>
              <p className="text-xs text-slate-600 dark:text-slate-300">Matrícula Notarial: {currentUser.notaryRegistration || 'No aplica'}</p>
              <p className="text-xs text-slate-600 dark:text-slate-300">Despacho: {currentUser.lawFirm}</p>
            </div>
          </div>
        )}

        {/* OPTIONS TAB */}
        {activeTab === 'OPTIONS' && (
          <div className="max-w-3xl space-y-6">
            <div>
              <h1 className="text-2xl font-serif font-bold text-slate-900 dark:text-white">Opciones de la Aplicación</h1>
              <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">Preferencias del editor notarial SAVE</p>
            </div>
            <div className="p-6 bg-[#F5F2ED] dark:bg-slate-800/80 border border-[#E8E5DF] dark:border-slate-700 rounded-2xl space-y-3 text-xs text-slate-600 dark:text-slate-300">
              <p className="font-bold text-slate-900 dark:text-white text-sm">Validación Estricta Dominicana</p>
              <p>Módulo 10 para Cédulas JCE activado por defecto.</p>
              <p>Validador de RNC Dirección General de Impuestos Internos (DGII) activado.</p>
              <p>Formateo automático de montos monetarios en letras (Pesos Dominicanos / Dólares).</p>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
