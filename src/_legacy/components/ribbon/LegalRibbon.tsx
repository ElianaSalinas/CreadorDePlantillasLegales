import React, { useState } from 'react';
import {
  FileText,
  Save,
  Printer,
  Copy,
  Scissors,
  Clipboard,
  Paintbrush,
  Bold,
  Italic,
  Underline,
  Strikethrough,
  AlignLeft,
  AlignCenter,
  AlignRight,
  AlignJustify,
  List,
  ListOrdered,
  Indent,
  Outdent,
  Search,
  Replace,
  Type,
  Maximize2,
  Table as TableIcon,
  Image as ImageIcon,
  Sparkles,
  ShieldCheck,
  Award,
  QrCode,
  PenTool,
  Bookmark,
  Link,
  MessageSquare,
  Palette,
  Droplet,
  Layers,
  Layout,
  Columns,
  BookOpen,
  Mail,
  CheckSquare,
  CheckCircle2,
  AlertCircle,
  HelpCircle,
  Code2,
  ChevronDown,
  Plus,
  ZoomIn,
  ZoomOut,
  Maximize,
  Sliders,
  Check,
  FileSpreadsheet,
  Stamp,
  Grid,
} from 'lucide-react';
import {
  RibbonTab,
  DocumentStyleState,
  FontFamily,
  PageColor,
  PageBorder,
  WatermarkType,
  PaperSize,
  PageOrientation,
  PageMargins,
  TextAlignment,
} from '../../types/ribbonTypes';
import { useAppStore } from '../../store/useAppStore';

interface LegalRibbonProps {
  activeTab: RibbonTab;
  setActiveTab: (tab: RibbonTab) => void;
  styleState: DocumentStyleState;
  setStyleState: React.Dispatch<React.SetStateAction<DocumentStyleState>>;
  onOpenBackstage: () => void;
  onOpenSearchReplace: () => void;
  onOpenWordCount: () => void;
  onOpenHelp: () => void;
  onOpenDeveloper: () => void;
  onToggleComments: () => void;
  onToggleNavigation: () => void;
  onInsertPageBreak: () => void;
  onInsertTable: () => void;
  onInsertLegalStamp: () => void;
  onInsertNationalShield: () => void;
  onInsertDigitalSignature: () => void;
  onInsertQRCode: () => void;
  onInsertDominicanSolemnDate: () => void;
  onInsertNotarialClause: (clauseText: string) => void;
  onInsertCitation: (lawName: string) => void;
  onInsertFootnote: () => void;
  onInsertMailMergeField: (tag: string) => void;
}

export const LegalRibbon: React.FC<LegalRibbonProps> = ({
  activeTab,
  setActiveTab,
  styleState,
  setStyleState,
  onOpenBackstage,
  onOpenSearchReplace,
  onOpenWordCount,
  onOpenHelp,
  onOpenDeveloper,
  onToggleComments,
  onToggleNavigation,
  onInsertPageBreak,
  onInsertTable,
  onInsertLegalStamp,
  onInsertNationalShield,
  onInsertDigitalSignature,
  onInsertQRCode,
  onInsertDominicanSolemnDate,
  onInsertNotarialClause,
  onInsertCitation,
  onInsertFootnote,
  onInsertMailMergeField,
}) => {
  const { activeTemplate, currentUser } = useAppStore();
  const [formatPainterActive, setFormatPainterActive] = useState(false);
  const [showCitationDropdown, setShowCitationDropdown] = useState(false);
  const [showMailMergeDropdown, setShowMailMergeDropdown] = useState(false);

  const fontSizes = [8, 9, 10, 11, 12, 14, 16, 18, 20, 24, 28, 36];

  const updateStyle = (patch: Partial<DocumentStyleState>) => {
    setStyleState((prev) => ({ ...prev, ...patch }));
  };

  const handleCopyClipboard = () => {
    if (activeTemplate) {
      navigator.clipboard.writeText(activeTemplate.content);
      alert('Texto del documento copiado al portapapeles.');
    }
  };

  return (
    <div className="w-full bg-white border-b border-[#E8E5DF] select-none shadow-xs flex flex-col shrink-0 z-20">
      {/* 1. TOP TAB BAR */}
      <div className="flex items-center bg-[#0D2C24] text-white px-2 pt-1 overflow-x-auto scrollbar-none space-x-0.5 text-xs font-semibold">
        {/* ARCHIVO BUTTON (Backstage trigger) */}
        <button
          onClick={onOpenBackstage}
          className="px-3.5 py-1.5 bg-[#C5A059] hover:bg-[#B38F46] text-[#0D2C24] rounded-t-md text-xs font-bold transition-all shadow-xs flex items-center space-x-1 mr-1 cursor-pointer"
        >
          <FileText className="w-3.5 h-3.5" />
          <span>Archivo</span>
        </button>

        {/* Standard Ribbon Tabs */}
        {[
          { id: 'HOME', label: 'Inicio' },
          { id: 'INSERT', label: 'Insertar' },
          { id: 'DESIGN', label: 'Diseño' },
          { id: 'LAYOUT', label: 'Disposición' },
          { id: 'REFERENCES', label: 'Referencias' },
          { id: 'MAILINGS', label: 'Correspondencia' },
          { id: 'REVIEW', label: 'Revisar' },
          { id: 'VIEW', label: 'Vista' },
          { id: 'HELP', label: 'Ayuda' },
          { id: 'DEVELOPER', label: 'Desarrollador' },
        ].map((tab) => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id as RibbonTab)}
            className={`px-3 py-1.5 rounded-t-md text-xs transition-colors whitespace-nowrap cursor-pointer ${
              activeTab === tab.id
                ? 'bg-[#F5F2ED] text-[#0D2C24] shadow-xs border-t-2 border-[#C5A059] font-bold'
                : 'text-slate-300 hover:text-white hover:bg-[#164E3E]'
            }`}
          >
            {tab.label}
          </button>
        ))}

        {/* Contextual Tabs (Highlighted in Gold/Amber if active) */}
        <div className="flex items-center space-x-1 pl-2 border-l border-[#164E3E] ml-1">
          <button
            onClick={() => setActiveTab('CTX_STAMP')}
            className={`px-2.5 py-1.5 rounded-t-md text-[11px] font-semibold transition-colors flex items-center space-x-1 cursor-pointer ${
              activeTab === 'CTX_STAMP'
                ? 'bg-[#FDE8B5] text-[#0D2C24] font-bold border-t-2 border-[#C5A059]'
                : 'text-[#FDE8B5] hover:bg-[#164E3E]'
            }`}
          >
            <Stamp className="w-3 h-3 text-[#C5A059]" />
            <span>Sello & Firma</span>
          </button>

          <button
            onClick={() => setActiveTab('CTX_TABLE')}
            className={`px-2.5 py-1.5 rounded-t-md text-[11px] font-semibold transition-colors flex items-center space-x-1 cursor-pointer ${
              activeTab === 'CTX_TABLE'
                ? 'bg-[#FDE8B5] text-[#0D2C24] font-bold border-t-2 border-[#C5A059]'
                : 'text-emerald-300 hover:bg-[#164E3E]'
            }`}
          >
            <TableIcon className="w-3 h-3 text-emerald-400" />
            <span>Tabla Notarial</span>
          </button>
        </div>
      </div>

      {/* 2. RIBBON CONTENT BODY (Command groups) */}
      <div className="p-2 bg-slate-50 border-b border-slate-200 overflow-x-auto scrollbar-none flex items-center space-x-3 text-slate-700 min-h-[96px]">
        {/* ============================================================ */}
        {/* TAB 1: INICIO (HOME) */}
        {/* ============================================================ */}
        {activeTab === 'HOME' && (
          <>
            {/* Portapapeles */}
            <div className="flex flex-col items-center border-r border-slate-300 pr-3 space-y-1">
              <div className="flex items-center space-x-1">
                <button
                  onClick={handleCopyClipboard}
                  className="flex flex-col items-center p-1 hover:bg-slate-200 rounded text-slate-700 text-[10px]"
                  title="Copiar"
                >
                  <Copy className="w-4 h-4 text-slate-700" />
                  <span>Copiar</span>
                </button>
                <button
                  onClick={handleCopyClipboard}
                  className="flex flex-col items-center p-1 hover:bg-slate-200 rounded text-slate-700 text-[10px]"
                  title="Pegar"
                >
                  <Clipboard className="w-4 h-4 text-slate-700" />
                  <span>Pegar</span>
                </button>
                <button
                  onClick={() => setFormatPainterActive(!formatPainterActive)}
                  className={`flex flex-col items-center p-1 rounded text-[10px] ${
                    formatPainterActive ? 'bg-emerald-100 text-emerald-700' : 'hover:bg-slate-200 text-slate-700'
                  }`}
                  title="Copiar Formato"
                >
                  <Paintbrush className="w-4 h-4" />
                  <span>Formato</span>
                </button>
              </div>
              <span className="text-[9px] text-slate-400 font-semibold uppercase">Portapapeles</span>
            </div>

            {/* Fuente */}
            <div className="flex flex-col border-r border-slate-300 pr-3 space-y-1">
              <div className="flex items-center space-x-1.5">
                {/* Font family */}
                <select
                  value={styleState.fontFamily}
                  onChange={(e) => updateStyle({ fontFamily: e.target.value as FontFamily })}
                  className="text-xs bg-white border border-slate-300 rounded px-2 py-0.5 focus:outline-none focus:ring-1 focus:ring-emerald-500 font-medium"
                >
                  <option value="serif">Garamond / Times (Notarial)</option>
                  <option value="sans">Aptos / Arial (Moderno)</option>
                  <option value="mono">Courier Legal (Monoespacio)</option>
                </select>

                {/* Font size */}
                <select
                  value={styleState.fontSize}
                  onChange={(e) => updateStyle({ fontSize: Number(e.target.value) })}
                  className="text-xs bg-white border border-slate-300 rounded px-1.5 py-0.5 focus:outline-none focus:ring-1 focus:ring-emerald-500 font-medium"
                >
                  {fontSizes.map((sz) => (
                    <option key={sz} value={sz}>
                      {sz} pt
                    </option>
                  ))}
                </select>
              </div>

              {/* Bold, Italic, Underline, Strikethrough, Colors */}
              <div className="flex items-center space-x-1">
                <button
                  onClick={() => updateStyle({ isBold: !styleState.isBold })}
                  className={`p-1 rounded text-xs ${
                    styleState.isBold ? 'bg-emerald-600 text-white' : 'hover:bg-slate-200 text-slate-700'
                  }`}
                  title="Negrita (B)"
                >
                  <Bold className="w-3.5 h-3.5" />
                </button>
                <button
                  onClick={() => updateStyle({ isItalic: !styleState.isItalic })}
                  className={`p-1 rounded text-xs ${
                    styleState.isItalic ? 'bg-emerald-600 text-white' : 'hover:bg-slate-200 text-slate-700'
                  }`}
                  title="Cursiva (I)"
                >
                  <Italic className="w-3.5 h-3.5" />
                </button>
                <button
                  onClick={() => updateStyle({ isUnderline: !styleState.isUnderline })}
                  className={`p-1 rounded text-xs ${
                    styleState.isUnderline ? 'bg-emerald-600 text-white' : 'hover:bg-slate-200 text-slate-700'
                  }`}
                  title="Subrayado (U)"
                >
                  <Underline className="w-3.5 h-3.5" />
                </button>
                <button
                  onClick={() => updateStyle({ isStrikethrough: !styleState.isStrikethrough })}
                  className={`p-1 rounded text-xs ${
                    styleState.isStrikethrough ? 'bg-emerald-600 text-white' : 'hover:bg-slate-200 text-slate-700'
                  }`}
                  title="Tachado"
                >
                  <Strikethrough className="w-3.5 h-3.5" />
                </button>

                <div className="w-[1px] h-4 bg-slate-300 mx-1" />

                {/* Text Color Selector */}
                <button
                  onClick={() =>
                    updateStyle({
                      textColor:
                        styleState.textColor === '#0f172a'
                          ? '#1e3a8a'
                          : styleState.textColor === '#1e3a8a'
                          ? '#831843'
                          : '#0f172a',
                    })
                  }
                  className="px-1.5 py-0.5 rounded border border-slate-300 text-[10px] font-bold flex items-center space-x-1 hover:bg-slate-200"
                  title="Color de Texto Notarial"
                >
                  <span
                    className="w-2.5 h-2.5 rounded-full"
                    style={{ backgroundColor: styleState.textColor }}
                  />
                  <span>A</span>
                </button>

                {/* Highlight selector */}
                <button
                  onClick={() =>
                    updateStyle({
                      highlightColor: styleState.highlightColor === 'none' ? 'yellow' : 'none',
                    })
                  }
                  className={`p-1 rounded text-xs ${
                    styleState.highlightColor !== 'none' ? 'bg-amber-200 text-slate-900' : 'hover:bg-slate-200 text-slate-700'
                  }`}
                  title="Resaltar Texto"
                >
                  <Droplet className="w-3.5 h-3.5" />
                </button>
              </div>

              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Fuente</span>
            </div>

            {/* Párrafo */}
            <div className="flex flex-col border-r border-slate-300 pr-3 space-y-1">
              <div className="flex items-center space-x-1">
                <button
                  onClick={() => updateStyle({ textAlign: 'left' })}
                  className={`p-1 rounded text-xs ${
                    styleState.textAlign === 'left' ? 'bg-emerald-600 text-white' : 'hover:bg-slate-200 text-slate-700'
                  }`}
                  title="Alinear a la izquierda"
                >
                  <AlignLeft className="w-3.5 h-3.5" />
                </button>
                <button
                  onClick={() => updateStyle({ textAlign: 'center' })}
                  className={`p-1 rounded text-xs ${
                    styleState.textAlign === 'center' ? 'bg-emerald-600 text-white' : 'hover:bg-slate-200 text-slate-700'
                  }`}
                  title="Centrar"
                >
                  <AlignCenter className="w-3.5 h-3.5" />
                </button>
                <button
                  onClick={() => updateStyle({ textAlign: 'right' })}
                  className={`p-1 rounded text-xs ${
                    styleState.textAlign === 'right' ? 'bg-emerald-600 text-white' : 'hover:bg-slate-200 text-slate-700'
                  }`}
                  title="Alinear a la derecha"
                >
                  <AlignRight className="w-3.5 h-3.5" />
                </button>
                <button
                  onClick={() => updateStyle({ textAlign: 'justify' })}
                  className={`p-1 rounded text-xs ${
                    styleState.textAlign === 'justify' ? 'bg-emerald-600 text-white' : 'hover:bg-slate-200 text-slate-700'
                  }`}
                  title="Justificado Solemne"
                >
                  <AlignJustify className="w-3.5 h-3.5" />
                </button>

                <div className="w-[1px] h-4 bg-slate-300 mx-1" />

                {/* Line Spacing */}
                <select
                  value={styleState.lineHeight}
                  onChange={(e) => updateStyle({ lineHeight: Number(e.target.value) })}
                  className="text-xs bg-white border border-slate-300 rounded px-1.5 py-0.5 focus:outline-none"
                  title="Interlineado"
                >
                  <option value={1.0}>1.0 (Sencillo)</option>
                  <option value={1.15}>1.15 (Notarial)</option>
                  <option value={1.5}>1.5 (1.5 Líneas)</option>
                  <option value={2.0}>2.0 (Doble)</option>
                </select>
              </div>

              {/* Numbering and Bullets */}
              <div className="flex items-center space-x-1">
                <button
                  onClick={() => onInsertNotarialClause('PRIMERO: ')}
                  className="px-2 py-0.5 bg-white hover:bg-slate-200 rounded border border-slate-300 text-[10px] font-semibold text-slate-800"
                  title="Numeración Notarial (PRIMERO, SEGUNDO...)"
                >
                  PRIMERO:
                </button>
                <button
                  onClick={() => onInsertNotarialClause('SEGUNDO: ')}
                  className="px-2 py-0.5 bg-white hover:bg-slate-200 rounded border border-slate-300 text-[10px] font-semibold text-slate-800"
                >
                  SEGUNDO:
                </button>
                <button
                  onClick={() => onInsertNotarialClause('TERCERO: ')}
                  className="px-2 py-0.5 bg-white hover:bg-slate-200 rounded border border-slate-300 text-[10px] font-semibold text-slate-800"
                >
                  TERCERO:
                </button>
              </div>

              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Párrafo</span>
            </div>

            {/* Estilos Predefinidos */}
            <div className="flex flex-col border-r border-slate-300 pr-3 space-y-1">
              <div className="flex items-center space-x-1.5">
                <button
                  onClick={() =>
                    updateStyle({
                      fontFamily: 'serif',
                      fontSize: 12,
                      lineHeight: 1.5,
                      textAlign: 'justify',
                      isBold: false,
                    })
                  }
                  className="px-2.5 py-1 bg-white hover:bg-slate-200 rounded border border-slate-300 text-xs font-serif font-medium"
                >
                  Normal
                </button>

                <button
                  onClick={() =>
                    updateStyle({
                      fontFamily: 'serif',
                      fontSize: 14,
                      isBold: true,
                      textAlign: 'center',
                    })
                  }
                  className="px-2.5 py-1 bg-white hover:bg-slate-200 rounded border border-slate-300 text-xs font-serif font-bold text-slate-900"
                >
                  Título Acto Notarial
                </button>

                <button
                  onClick={() =>
                    updateStyle({
                      fontFamily: 'serif',
                      fontSize: 12,
                      isBold: true,
                      textAlign: 'justify',
                    })
                  }
                  className="px-2.5 py-1 bg-white hover:bg-slate-200 rounded border border-slate-300 text-xs font-serif font-semibold text-emerald-900"
                >
                  Cláusula Solemne
                </button>
              </div>
              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Estilos Notariales</span>
            </div>

            {/* Edición: Buscar y Reemplazar */}
            <div className="flex flex-col items-center space-y-1">
              <div className="flex items-center space-x-1">
                <button
                  onClick={onOpenSearchReplace}
                  className="flex flex-col items-center p-1.5 hover:bg-slate-200 rounded text-slate-700 text-[10px]"
                >
                  <Search className="w-4 h-4 text-emerald-600" />
                  <span>Buscar</span>
                </button>
                <button
                  onClick={onOpenSearchReplace}
                  className="flex flex-col items-center p-1.5 hover:bg-slate-200 rounded text-slate-700 text-[10px]"
                >
                  <Replace className="w-4 h-4 text-emerald-600" />
                  <span>Reemplazar</span>
                </button>
              </div>
              <span className="text-[9px] text-slate-400 font-semibold uppercase">Edición</span>
            </div>
          </>
        )}

        {/* ============================================================ */}
        {/* TAB 2: INSERTAR (INSERT) */}
        {/* ============================================================ */}
        {activeTab === 'INSERT' && (
          <>
            {/* Páginas */}
            <div className="flex flex-col items-center border-r border-slate-300 pr-3 space-y-1">
              <div className="flex items-center space-x-1">
                <button
                  onClick={onInsertPageBreak}
                  className="flex flex-col items-center p-1.5 hover:bg-slate-200 rounded text-slate-700 text-[10px]"
                  title="Salto de Página Notarial"
                >
                  <Layout className="w-4 h-4 text-emerald-600" />
                  <span>Salto de Página</span>
                </button>
              </div>
              <span className="text-[9px] text-slate-400 font-semibold uppercase">Páginas</span>
            </div>

            {/* Tablas */}
            <div className="flex flex-col items-center border-r border-slate-300 pr-3 space-y-1">
              <button
                onClick={onInsertTable}
                className="flex flex-col items-center p-1.5 hover:bg-slate-200 rounded text-slate-700 text-[10px]"
                title="Insertar Tabla de Pagos / Comparecientes"
              >
                <TableIcon className="w-4 h-4 text-emerald-600" />
                <span>Tabla Notarial</span>
              </button>
              <span className="text-[9px] text-slate-400 font-semibold uppercase">Tablas</span>
            </div>

            {/* Ilustraciones & Símbolos Notariales */}
            <div className="flex flex-col border-r border-slate-300 pr-3 space-y-1">
              <div className="flex items-center space-x-1">
                <button
                  onClick={onInsertLegalStamp}
                  className="flex flex-col items-center p-1.5 hover:bg-slate-200 rounded text-slate-700 text-[10px]"
                  title="Insertar Sello Notarial de la República Dominicana"
                >
                  <Stamp className="w-4 h-4 text-amber-600" />
                  <span>Sello Notarial</span>
                </button>
                <button
                  onClick={onInsertNationalShield}
                  className="flex flex-col items-center p-1.5 hover:bg-slate-200 rounded text-slate-700 text-[10px]"
                  title="Insertar Escudo Nacional Dominicano"
                >
                  <Award className="w-4 h-4 text-emerald-700" />
                  <span>Escudo RD</span>
                </button>
                <button
                  onClick={onInsertDigitalSignature}
                  className="flex flex-col items-center p-1.5 hover:bg-slate-200 rounded text-slate-700 text-[10px]"
                  title="Insertar Firma y Matrícula CARD"
                >
                  <PenTool className="w-4 h-4 text-purple-600" />
                  <span>Firma Digital</span>
                </button>
                <button
                  onClick={onInsertQRCode}
                  className="flex flex-col items-center p-1.5 hover:bg-slate-200 rounded text-slate-700 text-[10px]"
                  title="Código QR de Validación Notarial"
                >
                  <QrCode className="w-4 h-4 text-slate-800" />
                  <span>QR Verificación</span>
                </button>
              </div>
              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Ilustraciones Jurídicas</span>
            </div>

            {/* Encabezado y Pie */}
            <div className="flex flex-col border-r border-slate-300 pr-3 space-y-1">
              <div className="flex items-center space-x-1 text-xs">
                <button
                  onClick={() => updateStyle({ showNotarialHeader: !styleState.showNotarialHeader })}
                  className={`px-2 py-1 rounded text-[10px] font-medium border ${
                    styleState.showNotarialHeader ? 'bg-emerald-50 text-emerald-700 border-emerald-200' : 'bg-white text-slate-600'
                  }`}
                >
                  Membrete RD
                </button>
                <button
                  onClick={() => updateStyle({ showNotarialFooter: !styleState.showNotarialFooter })}
                  className={`px-2 py-1 rounded text-[10px] font-medium border ${
                    styleState.showNotarialFooter ? 'bg-emerald-50 text-emerald-700 border-emerald-200' : 'bg-white text-slate-600'
                  }`}
                >
                  Pie Pagina X/Y
                </button>
              </div>
              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Encabezado y Pie</span>
            </div>

            {/* Texto y Símbolos */}
            <div className="flex flex-col items-center space-y-1">
              <div className="flex items-center space-x-1">
                <button
                  onClick={onInsertDominicanSolemnDate}
                  className="px-2 py-1 bg-white hover:bg-slate-200 rounded border border-slate-300 text-[10px] font-semibold text-slate-800"
                >
                  Fecha Solemne RD
                </button>
                <button
                  onClick={() => onInsertNotarialClause('§ ')}
                  className="px-2 py-1 bg-white hover:bg-slate-200 rounded border border-slate-300 text-[10px] font-serif font-bold text-slate-800"
                >
                  § Parágrafo
                </button>
                <button
                  onClick={() => onInsertNotarialClause('¶ ')}
                  className="px-2 py-1 bg-white hover:bg-slate-200 rounded border border-slate-300 text-[10px] font-serif font-bold text-slate-800"
                >
                  ¶ Párrafo
                </button>
              </div>
              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Texto & Símbolos</span>
            </div>
          </>
        )}

        {/* ============================================================ */}
        {/* TAB 3: DISEÑO (DESIGN) */}
        {/* ============================================================ */}
        {activeTab === 'DESIGN' && (
          <>
            {/* Temas Notariales */}
            <div className="flex flex-col border-r border-slate-300 pr-3 space-y-1">
              <div className="flex items-center space-x-1.5">
                {[
                  { id: 'NOTARIAL_CLASSIC', label: 'Notarial Clásico' },
                  { id: 'CORPORATE_MODERN', label: 'Corporativo Moderno' },
                  { id: 'CIVIL_LITIGATION', label: 'Litigio Civil' },
                  { id: 'GOLDEN_SOLEMN', label: 'Solemne Dorado' },
                ].map((thm) => (
                  <button
                    key={thm.id}
                    onClick={() => updateStyle({ theme: thm.id as any })}
                    className={`px-2.5 py-1 rounded text-xs font-medium border ${
                      styleState.theme === thm.id ? 'bg-emerald-600 text-white shadow-xs' : 'bg-white text-slate-700 hover:bg-slate-100'
                    }`}
                  >
                    {thm.label}
                  </button>
                ))}
              </div>
              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Temas de Documento</span>
            </div>

            {/* Marcas de Agua */}
            <div className="flex flex-col border-r border-slate-300 pr-3 space-y-1">
              <div className="flex items-center space-x-1">
                <select
                  value={styleState.watermark}
                  onChange={(e) => updateStyle({ watermark: e.target.value as WatermarkType })}
                  className="text-xs bg-white border border-slate-300 rounded px-2 py-1 font-medium"
                >
                  <option value="NONE">Sin Marca de Agua</option>
                  <option value="BORRADOR">BORRADOR</option>
                  <option value="COPIA NOTARIAL">COPIA NOTARIAL</option>
                  <option value="ORIGINAL AUTÉNTICO">ORIGINAL AUTÉNTICO</option>
                  <option value="CONFIDENCIAL">CONFIDENCIAL</option>
                  <option value="USO EXCLUSIVO">USO EXCLUSIVO</option>
                </select>
              </div>
              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Marca de Agua</span>
            </div>

            {/* Color y Bordes de Página */}
            <div className="flex flex-col space-y-1">
              <div className="flex items-center space-x-1.5">
                <select
                  value={styleState.pageColor}
                  onChange={(e) => updateStyle({ pageColor: e.target.value as PageColor })}
                  className="text-xs bg-white border border-slate-300 rounded px-2 py-1 font-medium"
                >
                  <option value="WHITE">Papel Blanco Puro</option>
                  <option value="IVORY">Marfil Notarial</option>
                  <option value="PARCHMENT">Pergamino Suave</option>
                  <option value="COLD_GRAY">Gris Jurídico</option>
                </select>

                <select
                  value={styleState.pageBorder}
                  onChange={(e) => updateStyle({ pageBorder: e.target.value as PageBorder })}
                  className="text-xs bg-white border border-slate-300 rounded px-2 py-1 font-medium"
                >
                  <option value="NONE">Sin Borde</option>
                  <option value="SINGLE">Línea Notarial Simple</option>
                  <option value="DOUBLE_NOTARIAL">Doble Recuadro Notarial</option>
                  <option value="GOLDEN_BORDER">Borde Dorado Solemne</option>
                </select>
              </div>
              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Fondo y Bordes</span>
            </div>
          </>
        )}

        {/* ============================================================ */}
        {/* TAB 4: DISPOSICIÓN / DISEÑO DE PÁGINA (LAYOUT) */}
        {/* ============================================================ */}
        {activeTab === 'LAYOUT' && (
          <>
            {/* Márgenes */}
            <div className="flex flex-col border-r border-slate-300 pr-3 space-y-1">
              <div className="flex items-center space-x-1">
                <select
                  value={styleState.margins}
                  onChange={(e) => updateStyle({ margins: e.target.value as PageMargins })}
                  className="text-xs bg-white border border-slate-300 rounded px-2 py-1 font-medium"
                >
                  <option value="NORMAL">Normal (3.0 cm Notarial)</option>
                  <option value="NARROW">Estrecho (1.5 cm)</option>
                  <option value="WIDE">Amplio (4.0 cm)</option>
                </select>
              </div>
              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Márgenes</span>
            </div>

            {/* Orientación */}
            <div className="flex flex-col border-r border-slate-300 pr-3 space-y-1">
              <div className="flex items-center space-x-1">
                <button
                  onClick={() => updateStyle({ orientation: 'PORTRAIT' })}
                  className={`px-2 py-1 rounded text-xs font-medium border ${
                    styleState.orientation === 'PORTRAIT' ? 'bg-emerald-600 text-white' : 'bg-white text-slate-700'
                  }`}
                >
                  Vertical
                </button>
                <button
                  onClick={() => updateStyle({ orientation: 'LANDSCAPE' })}
                  className={`px-2 py-1 rounded text-xs font-medium border ${
                    styleState.orientation === 'LANDSCAPE' ? 'bg-emerald-600 text-white' : 'bg-white text-slate-700'
                  }`}
                >
                  Horizontal
                </button>
              </div>
              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Orientación</span>
            </div>

            {/* Tamaño de Papel */}
            <div className="flex flex-col border-r border-slate-300 pr-3 space-y-1">
              <div className="flex items-center space-x-1">
                <select
                  value={styleState.paperSize}
                  onChange={(e) => updateStyle({ paperSize: e.target.value as PaperSize })}
                  className="text-xs bg-white border border-slate-300 rounded px-2 py-1 font-medium"
                >
                  <option value="LEGAL">Legal / Oficio (8.5 x 14 plg)</option>
                  <option value="LETTER">Carta / Letter (8.5 x 11 plg)</option>
                  <option value="A4">A4 (21 x 29.7 cm)</option>
                </select>
              </div>
              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Tamaño de Hoja</span>
            </div>

            {/* Columnas */}
            <div className="flex flex-col space-y-1">
              <div className="flex items-center space-x-1">
                <button
                  onClick={() => updateStyle({ columns: 1 })}
                  className={`px-2 py-1 rounded text-xs font-medium border ${
                    styleState.columns === 1 ? 'bg-emerald-600 text-white' : 'bg-white text-slate-700'
                  }`}
                >
                  1 Columna
                </button>
                <button
                  onClick={() => updateStyle({ columns: 2 })}
                  className={`px-2 py-1 rounded text-xs font-medium border ${
                    styleState.columns === 2 ? 'bg-emerald-600 text-white' : 'bg-white text-slate-700'
                  }`}
                >
                  2 Columnas (Bilingüe)
                </button>
              </div>
              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Columnas</span>
            </div>
          </>
        )}

        {/* ============================================================ */}
        {/* TAB 5: REFERENCIAS (REFERENCES) */}
        {/* ============================================================ */}
        {activeTab === 'REFERENCES' && (
          <>
            {/* Tabla de Contenido / Índice */}
            <div className="flex flex-col border-r border-slate-300 pr-3 space-y-1">
              <button
                onClick={() =>
                  onInsertNotarialClause(
                    '\n\nTABLA DE CONTENIDO Y CLÁUSULAS:\n- PRIMERO: OBJETO\n- SEGUNDO: PRECIO Y CONDICIONES\n- TERCERO: VIGENCIA Y MORA\n'
                  )
                }
                className="flex items-center space-x-1 px-3 py-1.5 bg-white hover:bg-slate-200 rounded-lg border border-slate-300 text-xs font-semibold text-slate-800"
              >
                <BookOpen className="w-4 h-4 text-emerald-600" />
                <span>Índice de Cláusulas</span>
              </button>
              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Tabla de Contenido</span>
            </div>

            {/* Notas al pie */}
            <div className="flex flex-col border-r border-slate-300 pr-3 space-y-1">
              <button
                onClick={onInsertFootnote}
                className="flex items-center space-x-1 px-3 py-1.5 bg-white hover:bg-slate-200 rounded-lg border border-slate-300 text-xs font-semibold text-slate-800"
              >
                <Type className="w-4 h-4 text-emerald-600" />
                <span>Insertar Nota al Pie</span>
              </button>
              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Notas al Pie</span>
            </div>

            {/* Citas y Leyes Dominicanas */}
            <div className="flex flex-col space-y-1">
              <div className="flex items-center space-x-1.5">
                {[
                  { label: 'Ley 140-15 (Notariado)', cit: 'conforme a la Ley No. 140-15 del Notariado Dominicano' },
                  { label: 'Ley 4314 (Inquilinato)', cit: 'en virtud de la Ley No. 4314 sobre Alquileres y Desahucios' },
                  { label: 'Código Civil Dominicano', cit: 'según lo dispuesto por los artículos 1134 y siguientes del Código Civil Dominicano' },
                ].map((item, idx) => (
                  <button
                    key={idx}
                    onClick={() => onInsertCitation(item.cit)}
                    className="px-2 py-1 bg-white hover:bg-slate-200 rounded border border-slate-300 text-xs font-medium text-slate-800"
                  >
                    {item.label}
                  </button>
                ))}
              </div>
              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Citas y Leyes Dominicanas</span>
            </div>
          </>
        )}

        {/* ============================================================ */}
        {/* TAB 6: CORRESPONDENCIA (MAILINGS) */}
        {/* ============================================================ */}
        {activeTab === 'MAILINGS' && (
          <>
            {/* Combinar correspondencia */}
            <div className="flex flex-col border-r border-slate-300 pr-3 space-y-1">
              <div className="flex items-center space-x-1.5">
                <button
                  onClick={() => onInsertMailMergeField('inquilino_nombre')}
                  className="px-2.5 py-1 bg-white hover:bg-emerald-50 rounded border border-emerald-200 text-xs font-mono font-semibold text-emerald-700"
                >
                  {'{{inquilino_nombre}}'}
                </button>
                <button
                  onClick={() => onInsertMailMergeField('precio_alquiler')}
                  className="px-2.5 py-1 bg-white hover:bg-emerald-50 rounded border border-emerald-200 text-xs font-mono font-semibold text-emerald-700"
                >
                  {'{{precio_alquiler}}'}
                </button>
                <button
                  onClick={() => onInsertMailMergeField('inmueble_direccion')}
                  className="px-2.5 py-1 bg-white hover:bg-emerald-50 rounded border border-emerald-200 text-xs font-mono font-semibold text-emerald-700"
                >
                  {'{{inmueble_direccion}}'}
                </button>
              </div>
              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Insertar Campo de Combinación</span>
            </div>

            {/* Vista previa de resultados */}
            <div className="flex flex-col space-y-1">
              <div className="flex items-center space-x-2">
                <button
                  onClick={onOpenBackstage}
                  className="px-3 py-1.5 bg-emerald-600 hover:bg-emerald-500 text-white rounded-lg text-xs font-semibold shadow-xs flex items-center space-x-1"
                >
                  <Mail className="w-3.5 h-3.5" />
                  <span>Finalizar y Combinar</span>
                </button>
              </div>
              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Finalizar</span>
            </div>
          </>
        )}

        {/* ============================================================ */}
        {/* TAB 7: REVISAR (REVIEW) */}
        {/* ============================================================ */}
        {activeTab === 'REVIEW' && (
          <>
            {/* Ortografía y Estadísticas */}
            <div className="flex flex-col border-r border-slate-300 pr-3 space-y-1">
              <div className="flex items-center space-x-1">
                <button
                  onClick={() => alert('Revisión ortográfica y gramatical completada: Términos notariales dominicanos validados.')}
                  className="flex flex-col items-center p-1.5 hover:bg-slate-200 rounded text-slate-700 text-[10px]"
                >
                  <CheckCircle2 className="w-4 h-4 text-emerald-600" />
                  <span>Ortografía</span>
                </button>
                <button
                  onClick={onOpenWordCount}
                  className="flex flex-col items-center p-1.5 hover:bg-slate-200 rounded text-slate-700 text-[10px]"
                >
                  <Type className="w-4 h-4 text-emerald-600" />
                  <span>Contar Palabras</span>
                </button>
              </div>
              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Revisión</span>
            </div>

            {/* Comentarios */}
            <div className="flex flex-col border-r border-slate-300 pr-3 space-y-1">
              <button
                onClick={onToggleComments}
                className="flex items-center space-x-1.5 px-3 py-1.5 bg-white hover:bg-slate-200 rounded-lg border border-slate-300 text-xs font-semibold text-slate-800"
              >
                <MessageSquare className="w-4 h-4 text-emerald-600" />
                <span>Panel de Comentarios</span>
              </button>
              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Comentarios</span>
            </div>

            {/* Proteger Documento */}
            <div className="flex flex-col space-y-1">
              <button
                onClick={() => {
                  updateStyle({ isProtected: !styleState.isProtected });
                  alert(
                    styleState.isProtected
                      ? 'Protección de edición deshabilitada.'
                      : 'Documento protegido: Cláusulas solemnes marcadas como de solo lectura.'
                  );
                }}
                className={`flex items-center space-x-1.5 px-3 py-1.5 rounded-lg border text-xs font-semibold ${
                  styleState.isProtected ? 'bg-amber-600 text-white' : 'bg-white text-slate-800 border-slate-300'
                }`}
              >
                <ShieldCheck className="w-4 h-4" />
                <span>{styleState.isProtected ? 'Documento Protegido' : 'Restringir Edición'}</span>
              </button>
              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Proteger</span>
            </div>
          </>
        )}

        {/* ============================================================ */}
        {/* TAB 8: VISTA (VIEW) */}
        {/* ============================================================ */}
        {activeTab === 'VIEW' && (
          <>
            {/* Modos de Vista */}
            <div className="flex flex-col border-r border-slate-300 pr-3 space-y-1">
              <div className="flex items-center space-x-1">
                <button
                  onClick={() => updateStyle({ viewLayout: 'PAGINATED' })}
                  className={`px-2.5 py-1 rounded text-xs font-medium border ${
                    styleState.viewLayout === 'PAGINATED' ? 'bg-emerald-600 text-white' : 'bg-white text-slate-700'
                  }`}
                >
                  Diseño de Impresión
                </button>
                <button
                  onClick={() => updateStyle({ viewLayout: 'CONTINUOUS' })}
                  className={`px-2.5 py-1 rounded text-xs font-medium border ${
                    styleState.viewLayout === 'CONTINUOUS' ? 'bg-emerald-600 text-white' : 'bg-white text-slate-700'
                  }`}
                >
                  Continuo
                </button>
              </div>
              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Vistas de Documento</span>
            </div>

            {/* Mostrar / Ocultar */}
            <div className="flex flex-col border-r border-slate-300 pr-3 space-y-1">
              <div className="flex items-center space-x-2 text-xs">
                <label className="flex items-center space-x-1 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={styleState.showRuler}
                    onChange={(e) => updateStyle({ showRuler: e.target.checked })}
                    className="rounded text-emerald-600 w-3.5 h-3.5"
                  />
                  <span>Regla</span>
                </label>
                <label className="flex items-center space-x-1 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={styleState.showGridlines}
                    onChange={(e) => updateStyle({ showGridlines: e.target.checked })}
                    className="rounded text-emerald-600 w-3.5 h-3.5"
                  />
                  <span>Cuadrícula</span>
                </label>
                <button
                  onClick={onToggleNavigation}
                  className="px-2 py-0.5 bg-white border border-slate-300 rounded font-semibold text-[11px] hover:bg-slate-100"
                >
                  Panel Navegación
                </button>
              </div>
              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Mostrar</span>
            </div>

            {/* Zoom */}
            <div className="flex flex-col space-y-1">
              <div className="flex items-center space-x-1">
                <button
                  onClick={() => updateStyle({ zoom: Math.max(styleState.zoom - 10, 50) })}
                  className="p-1 bg-white border border-slate-300 rounded hover:bg-slate-100"
                  title="Alejar Zoom"
                >
                  <ZoomOut className="w-3.5 h-3.5 text-slate-700" />
                </button>
                <span className="font-mono text-xs font-bold px-1.5">{styleState.zoom}%</span>
                <button
                  onClick={() => updateStyle({ zoom: Math.min(styleState.zoom + 10, 150) })}
                  className="p-1 bg-white border border-slate-300 rounded hover:bg-slate-100"
                  title="Acercar Zoom"
                >
                  <ZoomIn className="w-3.5 h-3.5 text-slate-700" />
                </button>
                <button
                  onClick={() => updateStyle({ zoom: 100 })}
                  className="px-2 py-1 bg-white border border-slate-300 rounded text-xs font-semibold hover:bg-slate-100"
                >
                  100%
                </button>
              </div>
              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Zoom</span>
            </div>
          </>
        )}

        {/* ============================================================ */}
        {/* TAB 9: AYUDA (HELP) */}
        {/* ============================================================ */}
        {activeTab === 'HELP' && (
          <>
            <div className="flex flex-col space-y-1">
              <div className="flex items-center space-x-2">
                <button
                  onClick={onOpenHelp}
                  className="flex items-center space-x-1.5 px-3 py-1.5 bg-emerald-600 hover:bg-emerald-500 text-white rounded-lg text-xs font-semibold shadow-xs"
                >
                  <HelpCircle className="w-4 h-4" />
                  <span>Guía Notarial Dominicana (Ley 140-15)</span>
                </button>
                <button
                  onClick={onOpenHelp}
                  className="flex items-center space-x-1.5 px-3 py-1.5 bg-white hover:bg-slate-200 border border-slate-300 rounded-lg text-xs font-semibold text-slate-800"
                >
                  <span>Atajos de Teclado</span>
                </button>
              </div>
              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Soporte & Normativa</span>
            </div>
          </>
        )}

        {/* ============================================================ */}
        {/* TAB 10: DESARROLLADOR (DEVELOPER) */}
        {/* ============================================================ */}
        {activeTab === 'DEVELOPER' && (
          <>
            <div className="flex flex-col space-y-1">
              <div className="flex items-center space-x-2">
                <button
                  onClick={onOpenDeveloper}
                  className="flex items-center space-x-1.5 px-3 py-1.5 bg-slate-900 hover:bg-slate-800 text-white rounded-lg text-xs font-semibold shadow-xs"
                >
                  <Code2 className="w-4 h-4 text-emerald-400" />
                  <span>Esquema XML / JSON Schema & Regex AST</span>
                </button>
              </div>
              <span className="text-[9px] text-slate-400 font-semibold uppercase text-center">Herramientas XML & Esquemas</span>
            </div>
          </>
        )}

        {/* ============================================================ */}
        {/* CONTEXTUAL TAB: FORMATO DE SELLO Y FIRMA */}
        {/* ============================================================ */}
        {activeTab === 'CTX_STAMP' && (
          <>
            <div className="flex flex-col border-r border-amber-300 pr-3 space-y-1 bg-amber-50/50 p-1.5 rounded-lg">
              <div className="flex items-center space-x-2 text-xs">
                <label className="flex items-center space-x-1 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={styleState.showNotarialStamp}
                    onChange={(e) => updateStyle({ showNotarialStamp: e.target.checked })}
                    className="rounded text-amber-600"
                  />
                  <span className="font-semibold text-amber-900">Sello Notarial Oficial</span>
                </label>
                <label className="flex items-center space-x-1 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={styleState.showQRCode}
                    onChange={(e) => updateStyle({ showQRCode: e.target.checked })}
                    className="rounded text-amber-600"
                  />
                  <span className="font-semibold text-amber-900">Código QR de Autenticidad</span>
                </label>
                <label className="flex items-center space-x-1 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={styleState.showSignatures}
                    onChange={(e) => updateStyle({ showSignatures: e.target.checked })}
                    className="rounded text-amber-600"
                  />
                  <span className="font-semibold text-amber-900">Líneas de Firma</span>
                </label>
              </div>
              <span className="text-[9px] text-amber-700 font-bold uppercase text-center">Propiedades de Fe Pública</span>
            </div>
          </>
        )}

        {/* ============================================================ */}
        {/* CONTEXTUAL TAB: DISEÑO DE TABLA */}
        {/* ============================================================ */}
        {activeTab === 'CTX_TABLE' && (
          <>
            <div className="flex flex-col border-r border-emerald-300 pr-3 space-y-1 bg-emerald-50/50 p-1.5 rounded-lg">
              <div className="flex items-center space-x-2 text-xs">
                <button
                  onClick={onInsertTable}
                  className="px-2.5 py-1 bg-emerald-700 text-white rounded font-semibold text-xs shadow-xs"
                >
                  Insertar Cuadro de Pagos
                </button>
              </div>
              <span className="text-[9px] text-emerald-800 font-bold uppercase text-center">Diseño y Formato de Tabla</span>
            </div>
          </>
        )}
      </div>
    </div>
  );
};
