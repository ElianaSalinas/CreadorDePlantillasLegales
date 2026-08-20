import React, { useState, useMemo, useRef } from 'react';
import {
  FileText,
  BookOpen,
  ChevronLeft,
  ChevronRight,
  Printer,
  Copy,
  Check,
  ZoomIn,
  ZoomOut,
  Maximize2,
  Minimize2,
  Stamp,
  QrCode,
  Award,
  ShieldCheck,
  ChevronUp,
  ChevronDown,
} from 'lucide-react';
import {
  DocumentStyleState,
  DEFAULT_DOCUMENT_STYLE,
  RibbonTab,
} from '../types/ribbonTypes';
import { LegalRibbon } from './ribbon/LegalRibbon';
import { LegalRuler } from './ribbon/LegalRuler';
import { SearchReplaceBar } from './ribbon/SearchReplaceBar';
import { NavigationPane } from './ribbon/NavigationPane';
import { BackstageModal } from './ribbon/BackstageModal';
import { WordCountModal } from './ribbon/WordCountModal';
import { HelpLegalModal } from './ribbon/HelpLegalModal';
import { DeveloperPanelModal } from './ribbon/DeveloperPanelModal';
import { CommentsDrawer } from './ribbon/CommentsDrawer';
import { useAppStore } from '../store/useAppStore';

interface PaginatedDocumentPreviewProps {
  content: string;
  templateName?: string;
  className?: string;
  onUpdateContent?: (newContent: string) => void;
}

export const PaginatedDocumentPreview: React.FC<PaginatedDocumentPreviewProps> = ({
  content,
  templateName = 'Documento Notarial',
  className = '',
  onUpdateContent,
}) => {
  const { currentUser, activeTemplate, updateTemplate } = useAppStore();

  // Styling & Ribbon State
  const [styleState, setStyleState] = useState<DocumentStyleState>(DEFAULT_DOCUMENT_STYLE);
  const [activeTab, setActiveTab] = useState<RibbonTab>('HOME');

  // Modals & Panels
  const [showBackstage, setShowBackstage] = useState(false);
  const [showSearchReplace, setShowSearchReplace] = useState(false);
  const [showWordCount, setShowWordCount] = useState(false);
  const [showHelp, setShowHelp] = useState(false);
  const [showDeveloper, setShowDeveloper] = useState(false);
  const [showComments, setShowComments] = useState(false);

  // Search & Navigation
  const [searchQuery, setSearchQuery] = useState('');
  const [currentMatchIndex, setCurrentMatchIndex] = useState(0);
  const [copied, setCopied] = useState(false);
  const [selectedPageIndex, setSelectedPageIndex] = useState(0);

  const scrollContainerRef = useRef<HTMLDivElement | null>(null);

  // Divide content into realistic legal pages
  const pages = useMemo(() => {
    if (!content || !content.trim()) {
      return [''];
    }

    // Check if explicit page breaks exist
    if (content.includes('{{PAGE_BREAK}}') || content.includes('=== SALTO DE PÁGINA ===')) {
      return content
        .split(/\{\{PAGE_BREAK\}\}|=== SALTO DE PÁGINA ===/)
        .map((p) => p.trim())
        .filter(Boolean);
    }

    // Dynamic paragraph-based pagination based on font size and line height
    const paragraphs = content.split('\n\n');
    const resultPages: string[] = [];
    let currentPageText = '';
    let currentLength = 0;

    // Approximate character threshold per page based on font size
    const baseCharLimit = styleState.paperSize === 'LEGAL' ? 2600 : 2000;
    const sizeMultiplier = 12 / (styleState.fontSize || 12);
    const maxPageChars = Math.round(baseCharLimit * sizeMultiplier * (1.3 / (styleState.lineHeight || 1.3)));

    for (const para of paragraphs) {
      const trimmed = para.trim();
      if (!trimmed) continue;

      if (currentLength + trimmed.length > maxPageChars && currentPageText.length > 300) {
        resultPages.push(currentPageText.trim());
        currentPageText = trimmed;
        currentLength = trimmed.length;
      } else {
        currentPageText += (currentPageText ? '\n\n' : '') + trimmed;
        currentLength += trimmed.length;
      }
    }

    if (currentPageText.trim()) {
      resultPages.push(currentPageText.trim());
    }

    return resultPages.length > 0 ? resultPages : [''];
  }, [content, styleState.paperSize, styleState.fontSize, styleState.lineHeight]);

  // Search match computation
  const searchMatches = useMemo(() => {
    if (!searchQuery.trim()) return [];
    const matches: { pageIndex: number; index: number }[] = [];
    pages.forEach((pageText, pIdx) => {
      let startIndex = 0;
      const lowerPage = pageText.toLowerCase();
      const lowerQuery = searchQuery.toLowerCase();
      while ((startIndex = lowerPage.indexOf(lowerQuery, startIndex)) !== -1) {
        matches.push({ pageIndex: pIdx, index: startIndex });
        startIndex += lowerQuery.length;
      }
    });
    return matches;
  }, [pages, searchQuery]);

  const handleNextMatch = () => {
    if (searchMatches.length === 0) return;
    const nextIdx = (currentMatchIndex + 1) % searchMatches.length;
    setCurrentMatchIndex(nextIdx);
    scrollToPage(searchMatches[nextIdx].pageIndex);
  };

  const handlePrevMatch = () => {
    if (searchMatches.length === 0) return;
    const prevIdx = (currentMatchIndex - 1 + searchMatches.length) % searchMatches.length;
    setCurrentMatchIndex(prevIdx);
    scrollToPage(searchMatches[prevIdx].pageIndex);
  };

  const handleReplace = (find: string, replaceWith: string, replaceAll: boolean) => {
    if (!activeTemplate || !find) return;
    let newContent = activeTemplate.content;
    if (replaceAll) {
      const regex = new RegExp(find.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'gi');
      newContent = newContent.replace(regex, replaceWith);
    } else {
      newContent = newContent.replace(find, replaceWith);
    }
    updateTemplate(activeTemplate.id, { content: newContent });
    if (onUpdateContent) onUpdateContent(newContent);
  };

  const scrollToPage = (idx: number) => {
    setSelectedPageIndex(idx);
    const element = document.getElementById(`notarial-page-${idx}`);
    if (element) {
      element.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  };

  const handleCopy = () => {
    navigator.clipboard.writeText(content);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  // Helper insertions
  const insertTextInActiveTemplate = (text: string) => {
    if (!activeTemplate) return;
    const newContent = activeTemplate.content + '\n' + text;
    updateTemplate(activeTemplate.id, { content: newContent });
    if (onUpdateContent) onUpdateContent(newContent);
  };

  const handleInsertPageBreak = () => {
    insertTextInActiveTemplate('\n\n{{PAGE_BREAK}}\n\n');
  };

  const handleInsertTable = () => {
    const tableTemplate = `\n\n| COMPARECIENTE / PARTE | CALIDAD JURÍDICA | CÉDULA / RNC | FIRMA |\n| :--- | :--- | :--- | :--- |\n| {{propietario_nombre}} | PARTE PROPIETARIA | {{propietario_cedula}} | __________________ |\n| {{inquilino_nombre}} | PARTE INQUILINA | {{inquilino_cedula}} | __________________ |\n\n`;
    insertTextInActiveTemplate(tableTemplate);
  };

  const handleInsertLegalStamp = () => {
    setStyleState((prev) => ({ ...prev, showNotarialStamp: true }));
    setActiveTab('CTX_STAMP');
  };

  const handleInsertNationalShield = () => {
    setStyleState((prev) => ({ ...prev, showNotarialHeader: true }));
  };

  const handleInsertDigitalSignature = () => {
    setStyleState((prev) => ({ ...prev, showSignatures: true }));
    setActiveTab('CTX_STAMP');
  };

  const handleInsertQRCode = () => {
    setStyleState((prev) => ({ ...prev, showQRCode: true }));
  };

  const handleInsertDominicanSolemnDate = () => {
    const now = new Date();
    const months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    const solemnDate = `A los ${now.getDate()} días del mes de ${months[now.getMonth()]} del año ${now.getFullYear()} (${now.getFullYear()})`;
    insertTextInActiveTemplate(solemnDate);
  };

  const handleInsertCitation = (lawCitation: string) => {
    insertTextInActiveTemplate(`\n(${lawCitation})\n`);
  };

  const handleInsertFootnote = () => {
    insertTextInActiveTemplate(`\n\n¹ Nota al pie: Conforme a lo establecido en la legislación notarial y civil vigente en la República Dominicana.\n`);
  };

  // Compute theme background and borders
  const getThemeBgColor = () => {
    switch (styleState.pageColor) {
      case 'IVORY':
        return '#faf8f5';
      case 'PARCHMENT':
        return '#f6f1e8';
      case 'COLD_GRAY':
        return '#f8fafc';
      case 'WHITE':
      default:
        return '#ffffff';
    }
  };

  const getPageBorderStyle = () => {
    switch (styleState.pageBorder) {
      case 'DOUBLE_NOTARIAL':
        return 'border-4 border-double border-slate-700';
      case 'GOLDEN_BORDER':
        return 'border-2 border-amber-500/80 shadow-amber-500/10';
      case 'SINGLE':
        return 'border border-slate-300';
      case 'NONE':
      default:
        return 'border border-transparent';
    }
  };

  return (
    <div className={`flex flex-col h-full bg-slate-200/80 overflow-hidden w-full ${className}`}>
      {/* 1. Word-style Comprehensive Legal Ribbon Toolbar */}
      <LegalRibbon
        activeTab={activeTab}
        setActiveTab={setActiveTab}
        styleState={styleState}
        setStyleState={setStyleState}
        onOpenBackstage={() => setShowBackstage(true)}
        onOpenSearchReplace={() => setShowSearchReplace(true)}
        onOpenWordCount={() => setShowWordCount(true)}
        onOpenHelp={() => setShowHelp(true)}
        onOpenDeveloper={() => setShowDeveloper(true)}
        onToggleComments={() => setShowComments(!showComments)}
        onToggleNavigation={() =>
          setStyleState((prev) => ({ ...prev, showNavigationPane: !prev.showNavigationPane }))
        }
        onInsertPageBreak={handleInsertPageBreak}
        onInsertTable={handleInsertTable}
        onInsertLegalStamp={handleInsertLegalStamp}
        onInsertNationalShield={handleInsertNationalShield}
        onInsertDigitalSignature={handleInsertDigitalSignature}
        onInsertQRCode={handleInsertQRCode}
        onInsertDominicanSolemnDate={handleInsertDominicanSolemnDate}
        onInsertNotarialClause={(c) => insertTextInActiveTemplate(c)}
        onInsertCitation={handleInsertCitation}
        onInsertFootnote={handleInsertFootnote}
        onInsertMailMergeField={(tag) => insertTextInActiveTemplate(`{{${tag}}}`)}
      />

      {/* 2. Interactive Search & Replace Bar */}
      <SearchReplaceBar
        isOpen={showSearchReplace}
        onClose={() => setShowSearchReplace(false)}
        onSearchChange={(q) => {
          setSearchQuery(q);
          setCurrentMatchIndex(0);
        }}
        onReplace={handleReplace}
        totalMatches={searchMatches.length}
        currentMatchIndex={currentMatchIndex}
        onNextMatch={handleNextMatch}
        onPrevMatch={handlePrevMatch}
      />

      {/* 3. Horizontal Metric Ruler */}
      {styleState.showRuler && <LegalRuler zoom={styleState.zoom} />}

      {/* 4. Main Body: Split between Navigation Pane, Canvas with Strict Vertical Scroll, and Comments */}
      <div className="flex-1 flex overflow-hidden relative">
        {/* Navigation Pane on the Left */}
        {styleState.showNavigationPane && (
          <NavigationPane
            content={content}
            pages={pages}
            onSelectClause={(title) => {
              setSearchQuery(title);
              setShowSearchReplace(true);
            }}
            onSelectPage={(pIdx) => scrollToPage(pIdx)}
            onClose={() => setStyleState((prev) => ({ ...prev, showNavigationPane: false }))}
          />
        )}

        {/* Dedicated Document Canvas Container with VERTICAL SCROLL ONLY */}
        <div
          ref={scrollContainerRef}
          className="flex-1 overflow-y-auto overflow-x-hidden p-4 sm:p-8 flex flex-col items-center space-y-8 scrollbar-thin scrollbar-thumb-slate-400 scrollbar-track-slate-200"
          style={{
            backgroundImage: styleState.showGridlines
              ? 'linear-gradient(to right, #e2e8f0 1px, transparent 1px), linear-gradient(to bottom, #e2e8f0 1px, transparent 1px)'
              : undefined,
            backgroundSize: styleState.showGridlines ? '24px 24px' : undefined,
          }}
        >
          {/* Render Notarial Pages or Continuous Mode */}
          {styleState.viewLayout === 'PAGINATED' || styleState.viewLayout === 'TWO_PAGES' ? (
            <div
              className={`w-full flex flex-col items-center space-y-8 ${
                styleState.viewLayout === 'TWO_PAGES' ? 'sm:flex-row sm:flex-wrap sm:justify-center sm:gap-6 sm:space-y-0' : ''
              }`}
            >
              {pages.map((pageText, idx) => (
                <div
                  key={idx}
                  id={`notarial-page-${idx}`}
                  style={{
                    backgroundColor: getThemeBgColor(),
                    width: `${Math.min(100, Math.max(60, styleState.zoom * 0.85))}%`,
                    maxWidth: styleState.paperSize === 'LEGAL' ? '820px' : '780px',
                    minHeight: styleState.paperSize === 'LEGAL' ? '1080px' : '960px',
                    minWidth: '280px',
                    fontFamily:
                      styleState.fontFamily === 'serif'
                        ? 'Garamond, "Times New Roman", Georgia, serif'
                        : styleState.fontFamily === 'mono'
                        ? '"Courier New", Courier, monospace'
                        : 'ui-sans-serif, system-ui, -apple-system, sans-serif',
                  }}
                  className={`rounded-sm shadow-xl flex flex-col justify-between transition-all duration-150 relative overflow-hidden text-slate-900 ${getPageBorderStyle()}`}
                >
                  {/* WATERMARK LAYER IF ACTIVE */}
                  {styleState.watermark !== 'NONE' && (
                    <div className="absolute inset-0 pointer-events-none flex items-center justify-center select-none overflow-hidden z-0">
                      <span
                        className="text-slate-400/20 font-serif font-black text-6xl sm:text-7xl -rotate-45 tracking-widest uppercase border-4 border-dashed border-slate-400/20 px-8 py-4 text-center"
                      >
                        {styleState.watermark === 'CUSTOM'
                          ? styleState.customWatermarkText
                          : styleState.watermark}
                      </span>
                    </div>
                  )}

                  {/* LEFT NOTARIAL MARGIN SOLEMN STRIP */}
                  <div className="absolute left-0 top-0 bottom-0 w-1.5 bg-gradient-to-b from-emerald-700 via-emerald-800 to-slate-600 opacity-80 z-10" />

                  {/* 1. NOTARIAL TOP HEADER & COAT OF ARMS */}
                  {styleState.showNotarialHeader && (
                    <div className="px-8 sm:px-14 pt-8 pb-3 border-b border-slate-200/80 flex items-center justify-between text-xs text-slate-600 z-10">
                      <div className="flex items-center space-x-2">
                        <div className="w-7 h-7 bg-emerald-900 text-white rounded-full flex items-center justify-center shadow-xs">
                          <Award className="w-4 h-4 text-amber-300" />
                        </div>
                        <div>
                          <p className="font-bold text-[11px] text-slate-900 uppercase tracking-wide">
                            REPÚBLICA DOMINICANA
                          </p>
                          <p className="text-[10px] text-slate-500 font-mono">
                            {currentUser.jurisdiction} • LEY 140-15
                          </p>
                        </div>
                      </div>

                      <div className="text-right">
                        <span className="text-[11px] font-bold text-slate-800 block truncate max-w-[200px]">
                          {templateName}
                        </span>
                        <span className="text-[10px] text-emerald-700 font-mono font-semibold">
                          MATRÍCULA CARD: {currentUser.cardRegistration}
                        </span>
                      </div>
                    </div>
                  )}

                  {/* 2. SHEET BODY WITH LEGAL CONTENT */}
                  <div
                    style={{
                      fontSize: `${styleState.fontSize}pt`,
                      lineHeight: styleState.lineHeight,
                      textAlign: styleState.textAlign,
                      color: styleState.textColor,
                      fontWeight: styleState.isBold ? 700 : 400,
                      fontStyle: styleState.isItalic ? 'italic' : 'normal',
                      textDecoration: [
                        styleState.isUnderline ? 'underline' : '',
                        styleState.isStrikethrough ? 'line-through' : '',
                      ]
                        .filter(Boolean)
                        .join(' ') || 'none',
                    }}
                    className={`flex-1 px-8 sm:px-14 py-6 whitespace-pre-wrap break-words z-10 selection:bg-amber-200 ${
                      styleState.columns === 2 ? 'sm:columns-2 gap-8' : ''
                    }`}
                  >
                    {searchQuery ? (
                      // Search match highlighted renderer
                      pageText.split(new RegExp(`(${searchQuery.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')})`, 'gi')).map((chunk, i) =>
                        chunk.toLowerCase() === searchQuery.toLowerCase() ? (
                          <mark key={i} className="bg-amber-300 text-slate-950 font-bold px-0.5 rounded">
                            {chunk}
                          </mark>
                        ) : (
                          <span key={i}>{chunk}</span>
                        )
                      )
                    ) : (
                      pageText || (
                        <p className="text-slate-400 italic text-center py-20 font-sans">
                          El documento está vacío. Añade contenido o inserta campos desde el ribbon.
                        </p>
                      )
                    )}
                  </div>

                  {/* 3. NOTARIAL SOLEMN STAMP & DIGITAL SIGNATURES ON LAST PAGE */}
                  {idx === pages.length - 1 && (
                    <div className="px-8 sm:px-14 py-6 border-t border-slate-200/60 z-10 space-y-6">
                      {/* Signature Lines */}
                      {styleState.showSignatures && (
                        <div className="grid grid-cols-2 gap-8 pt-4 text-center text-xs text-slate-800">
                          <div className="space-y-1">
                            <div className="border-b border-slate-800 mx-4 h-12 flex items-end justify-center pb-1">
                              <span className="font-serif italic text-emerald-900 font-semibold opacity-70">
                                [Firma Compareciente 1]
                              </span>
                            </div>
                            <p className="font-bold text-slate-900">PARTE PROPIETARIA / ARRENDADORA</p>
                            <p className="text-[10px] text-slate-500">Cédula de Identidad y Electoral</p>
                          </div>

                          <div className="space-y-1">
                            <div className="border-b border-slate-800 mx-4 h-12 flex items-end justify-center pb-1">
                              <span className="font-serif italic text-emerald-900 font-semibold opacity-70">
                                [Firma Compareciente 2]
                              </span>
                            </div>
                            <p className="font-bold text-slate-900">PARTE INQUILINA / ARRENDATARIA</p>
                            <p className="text-[10px] text-slate-500">Cédula de Identidad y Electoral</p>
                          </div>
                        </div>
                      )}

                      {/* Notarial Sello & QR Verification */}
                      {(styleState.showNotarialStamp || styleState.showQRCode) && (
                        <div className="p-4 bg-slate-50 border border-slate-200 rounded-xl flex items-center justify-between gap-4">
                          {styleState.showNotarialStamp && (
                            <div className="flex items-center space-x-3">
                              <div className="w-12 h-12 rounded-full border-2 border-dashed border-emerald-800 flex items-center justify-center bg-emerald-50 text-emerald-900 shadow-inner shrink-0">
                                <Stamp className="w-6 h-6 text-emerald-800" />
                              </div>
                              <div className="text-xs">
                                <span className="font-bold text-emerald-950 block">FE PÚBLICA NOTARIAL</span>
                                <span className="text-[10px] text-slate-600 block">{currentUser.name}</span>
                                <span className="text-[9px] text-slate-400 font-mono">
                                  REG. NOTARIAL: {currentUser.notaryRegistration} • {currentUser.jurisdiction}
                                </span>
                              </div>
                            </div>
                          )}

                          {styleState.showQRCode && (
                            <div className="flex items-center space-x-2 text-right">
                              <div className="text-[10px] text-slate-500">
                                <span className="font-bold text-slate-800 block">Validación Digital RD</span>
                                <span>Verificación Ley 140-15</span>
                              </div>
                              <div className="w-10 h-10 bg-white border border-slate-300 p-1 rounded-lg flex items-center justify-center shadow-xs">
                                <QrCode className="w-full h-full text-slate-900" />
                              </div>
                            </div>
                          )}
                        </div>
                      )}
                    </div>
                  )}

                  {/* 4. NOTARIAL BOTTOM FOOTER */}
                  {styleState.showNotarialFooter && (
                    <div className="px-8 sm:px-14 py-4 border-t border-slate-200/80 flex items-center justify-between text-xs text-slate-500 z-10">
                      <span>Colegio Dominicano de Notarios / CARD</span>
                      <span className="font-semibold text-slate-800 font-mono">
                        Página {idx + 1} de {pages.length}
                      </span>
                    </div>
                  )}
                </div>
              ))}
            </div>
          ) : (
            /* Continuous View Mode */
            <div
              style={{
                backgroundColor: getThemeBgColor(),
                width: `${Math.min(100, Math.max(60, styleState.zoom * 0.85))}%`,
                maxWidth: '840px',
                minWidth: '280px',
                fontFamily:
                  styleState.fontFamily === 'serif'
                    ? 'Garamond, "Times New Roman", Georgia, serif'
                    : styleState.fontFamily === 'mono'
                    ? '"Courier New", Courier, monospace'
                    : 'ui-sans-serif, system-ui, -apple-system, sans-serif',
              }}
              className={`rounded-sm shadow-xl p-8 sm:p-14 text-slate-900 whitespace-pre-wrap break-words leading-relaxed ${getPageBorderStyle()}`}
            >
              <div className="border-b border-slate-200 pb-4 mb-6 text-center text-xs text-slate-500 font-serif uppercase tracking-widest">
                REPÚBLICA DOMINICANA • {templateName}
              </div>

              <div
                style={{
                  fontSize: `${styleState.fontSize}pt`,
                  lineHeight: styleState.lineHeight,
                  textAlign: styleState.textAlign,
                  color: styleState.textColor,
                }}
              >
                {content || (
                  <p className="text-slate-400 italic text-center py-20 font-sans">
                    El documento está vacío. Escribe o selecciona campos para previsualizar.
                  </p>
                )}
              </div>

              <div className="border-t border-slate-200 pt-6 mt-12 text-center text-xs text-slate-400 font-serif">
                *** FIN DEL ACTO JURÍDICO ***
              </div>
            </div>
          )}
        </div>

        {/* Comments Drawer on the Right */}
        {showComments && (
          <CommentsDrawer
            isOpen={showComments}
            onClose={() => setShowComments(false)}
          />
        )}
      </div>

      {/* 5. Bottom Status Bar with Page Indicator and Fast Zoom */}
      <div className="bg-slate-900 text-white px-4 py-1.5 flex items-center justify-between text-xs shrink-0 select-none z-20">
        <div className="flex items-center space-x-3">
          <span className="font-semibold text-slate-300">
            Página {selectedPageIndex + 1} de {pages.length}
          </span>
          <span className="hidden sm:inline text-slate-500">|</span>
          <span className="hidden sm:inline text-slate-400">
            {content.split(/\s+/).filter(Boolean).length} palabras
          </span>
          <span className="hidden md:inline text-slate-500">|</span>
          <span className="hidden md:inline text-emerald-400 font-medium flex items-center space-x-1">
            <ShieldCheck className="w-3.5 h-3.5" />
            <span>Formato Solemne RD</span>
          </span>
        </div>

        <div className="flex items-center space-x-2">
          {/* Quick Page Jump */}
          <div className="flex items-center space-x-1 mr-2">
            <button
              onClick={() => scrollToPage(Math.max(0, selectedPageIndex - 1))}
              disabled={selectedPageIndex === 0}
              className="p-1 hover:bg-slate-800 disabled:opacity-30 rounded text-slate-300"
              title="Página anterior"
            >
              <ChevronUp className="w-3.5 h-3.5" />
            </button>
            <button
              onClick={() => scrollToPage(Math.min(pages.length - 1, selectedPageIndex + 1))}
              disabled={selectedPageIndex >= pages.length - 1}
              className="p-1 hover:bg-slate-800 disabled:opacity-30 rounded text-slate-300"
              title="Página siguiente"
            >
              <ChevronDown className="w-3.5 h-3.5" />
            </button>
          </div>

          {/* Zoom Slider */}
          <button
            onClick={() => setStyleState((prev) => ({ ...prev, zoom: Math.max(prev.zoom - 10, 50) }))}
            className="p-1 hover:bg-slate-800 rounded text-slate-400 hover:text-white"
            title="Reducir zoom"
          >
            <ZoomOut className="w-3.5 h-3.5" />
          </button>
          <input
            type="range"
            min={50}
            max={150}
            step={10}
            value={styleState.zoom}
            onChange={(e) => setStyleState((prev) => ({ ...prev, zoom: Number(e.target.value) }))}
            className="w-16 sm:w-24 accent-emerald-500 h-1 bg-slate-700 rounded-lg cursor-pointer"
          />
          <button
            onClick={() => setStyleState((prev) => ({ ...prev, zoom: Math.min(prev.zoom + 10, 150) }))}
            className="p-1 hover:bg-slate-800 rounded text-slate-400 hover:text-white"
            title="Aumentar zoom"
          >
            <ZoomIn className="w-3.5 h-3.5" />
          </button>
          <span className="font-mono text-[11px] text-slate-300 w-10 text-right">{styleState.zoom}%</span>
        </div>
      </div>

      {/* 6. Backstage Modal */}
      <BackstageModal
        isOpen={showBackstage}
        onClose={() => setShowBackstage(false)}
        renderedText={content}
      />

      {/* 7. Word Count Modal */}
      <WordCountModal
        isOpen={showWordCount}
        onClose={() => setShowWordCount(false)}
        content={content}
        pagesCount={pages.length}
      />

      {/* 8. Help Legal Modal */}
      <HelpLegalModal
        isOpen={showHelp}
        onClose={() => setShowHelp(false)}
      />

      {/* 9. Developer Panel Modal */}
      <DeveloperPanelModal
        isOpen={showDeveloper}
        onClose={() => setShowDeveloper(false)}
      />
    </div>
  );
};
