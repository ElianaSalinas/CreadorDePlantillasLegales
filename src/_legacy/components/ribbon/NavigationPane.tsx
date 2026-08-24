import React, { useState, useMemo } from 'react';
import { BookOpen, Layers, Search, FileText, ChevronRight, X } from 'lucide-react';

interface NavigationPaneProps {
  content: string;
  pages: string[];
  onSelectClause: (clauseTitle: string) => void;
  onSelectPage: (pageIndex: number) => void;
  onClose: () => void;
}

export const NavigationPane: React.FC<NavigationPaneProps> = ({
  content,
  pages,
  onSelectClause,
  onSelectPage,
  onClose,
}) => {
  const [activeTab, setActiveTab] = useState<'HEADINGS' | 'PAGES' | 'SEARCH'>('HEADINGS');
  const [searchQuery, setSearchQuery] = useState('');

  // Extract legal clauses and headings (e.g. PRIMERO, SEGUNDO, CLÁUSULA, ACTO NÚMERO)
  const headings = useMemo(() => {
    const lines = content.split('\n');
    const detected: { line: string; index: number; type: string }[] = [];

    lines.forEach((line, idx) => {
      const trimmed = line.trim();
      if (!trimmed) return;

      if (
        /^(PRIMERO|SEGUNDO|TERCERO|CUARTO|QUINTO|SEXTO|SÉPTIMO|OCTAVO|NOVENO|DÉCIMO|DÉCIMO PRIMERO|DÉCIMO SEGUNDO)/i.test(
          trimmed
        ) ||
        /^(CLÁUSULA|ARTÍCULO|PARÁGRAFO|ACTO|CAPÍTULO)/i.test(trimmed) ||
        trimmed.startsWith('###') ||
        trimmed.startsWith('##')
      ) {
        detected.push({
          line: trimmed.replace(/^#+\s*/, ''),
          index: idx,
          type: trimmed.startsWith('PRIMERO') || trimmed.startsWith('SEGUNDO') ? 'CLÁUSULA' : 'TÍTULO',
        });
      }
    });

    return detected;
  }, [content]);

  return (
    <div className="w-64 sm:w-72 bg-white border-r border-slate-300 flex flex-col h-full shrink-0 shadow-md z-20">
      {/* Pane Header */}
      <div className="p-3 border-b border-slate-200 flex items-center justify-between bg-slate-50">
        <div className="flex items-center space-x-1.5 text-xs font-bold text-slate-800">
          <BookOpen className="w-3.5 h-3.5 text-emerald-600" />
          <span>Panel de Navegación</span>
        </div>
        <button
          onClick={onClose}
          className="p-1 hover:bg-slate-200 rounded text-slate-400 hover:text-slate-700"
          title="Cerrar panel"
        >
          <X className="w-3.5 h-3.5" />
        </button>
      </div>

      {/* Tabs */}
      <div className="flex border-b border-slate-200 bg-slate-100/70 p-1 text-[11px] font-semibold">
        <button
          onClick={() => setActiveTab('HEADINGS')}
          className={`flex-1 py-1 text-center rounded transition-all ${
            activeTab === 'HEADINGS' ? 'bg-white text-emerald-600 shadow-xs' : 'text-slate-600 hover:text-slate-900'
          }`}
        >
          Cláusulas ({headings.length})
        </button>
        <button
          onClick={() => setActiveTab('PAGES')}
          className={`flex-1 py-1 text-center rounded transition-all ${
            activeTab === 'PAGES' ? 'bg-white text-emerald-600 shadow-xs' : 'text-slate-600 hover:text-slate-900'
          }`}
        >
          Páginas ({pages.length})
        </button>
      </div>

      {/* Pane Content */}
      <div className="flex-1 overflow-y-auto overflow-x-hidden p-2 space-y-1">
        {activeTab === 'HEADINGS' && (
          <div className="space-y-1">
            {headings.length === 0 ? (
              <p className="text-xs text-slate-400 p-3 italic">No se detectaron cláusulas o títulos solemnes.</p>
            ) : (
              headings.map((h, i) => (
                <button
                  key={i}
                  onClick={() => onSelectClause(h.line)}
                  className="w-full text-left p-2 rounded-lg hover:bg-emerald-50 text-xs transition-colors border border-transparent hover:border-emerald-200 group flex items-start space-x-1.5"
                >
                  <ChevronRight className="w-3.5 h-3.5 text-slate-400 group-hover:text-emerald-600 shrink-0 mt-0.5" />
                  <div className="min-w-0">
                    <span className="font-semibold text-slate-800 block truncate group-hover:text-emerald-700">
                      {h.line}
                    </span>
                    <span className="text-[10px] text-slate-400 uppercase font-mono">{h.type}</span>
                  </div>
                </button>
              ))
            )}
          </div>
        )}

        {activeTab === 'PAGES' && (
          <div className="grid grid-cols-2 gap-2 p-1">
            {pages.map((p, idx) => (
              <button
                key={idx}
                onClick={() => onSelectPage(idx)}
                className="flex flex-col items-center p-2 bg-slate-50 hover:bg-emerald-50 border border-slate-200 hover:border-emerald-300 rounded-lg text-center transition-all group"
              >
                {/* Mini paper representation */}
                <div className="w-16 h-20 bg-white border border-slate-300 rounded shadow-xs p-1 flex flex-col justify-between overflow-hidden text-[5px] text-slate-300 select-none">
                  <div className="space-y-0.5">
                    <div className="h-1 bg-slate-300 rounded-xs w-3/4" />
                    <div className="h-0.5 bg-slate-200 rounded-xs w-full" />
                    <div className="h-0.5 bg-slate-200 rounded-xs w-5/6" />
                    <div className="h-0.5 bg-slate-200 rounded-xs w-4/6" />
                  </div>
                  <div className="h-0.5 bg-slate-300 rounded-xs w-1/2 self-center" />
                </div>
                <span className="text-[10px] font-semibold text-slate-600 group-hover:text-emerald-700 mt-1.5">
                  Página {idx + 1}
                </span>
              </button>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};
