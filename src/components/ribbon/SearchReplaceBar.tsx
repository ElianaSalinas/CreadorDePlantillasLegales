import React, { useState } from 'react';
import { Search, Replace, ChevronUp, ChevronDown, X, Check } from 'lucide-react';

interface SearchReplaceBarProps {
  isOpen: boolean;
  onClose: () => void;
  onSearchChange: (query: string) => void;
  onReplace?: (find: string, replaceWith: string, replaceAll: boolean) => void;
  totalMatches: number;
  currentMatchIndex: number;
  onNextMatch: () => void;
  onPrevMatch: () => void;
}

export const SearchReplaceBar: React.FC<SearchReplaceBarProps> = ({
  isOpen,
  onClose,
  onSearchChange,
  onReplace,
  totalMatches,
  currentMatchIndex,
  onNextMatch,
  onPrevMatch,
}) => {
  const [findText, setFindText] = useState('');
  const [replaceText, setReplaceText] = useState('');
  const [showReplace, setShowReplace] = useState(false);

  if (!isOpen) return null;

  const handleQueryChange = (val: string) => {
    setFindText(val);
    onSearchChange(val);
  };

  return (
    <div className="bg-white border-b border-slate-300 p-2.5 shadow-md flex flex-wrap items-center justify-between gap-2 text-xs z-30 shrink-0">
      <div className="flex items-center space-x-2 flex-wrap">
        {/* Search Input */}
        <div className="relative flex items-center">
          <Search className="w-3.5 h-3.5 text-slate-400 absolute left-2.5" />
          <input
            type="text"
            value={findText}
            onChange={(e) => handleQueryChange(e.target.value)}
            placeholder="Buscar en el documento notarial..."
            className="pl-8 pr-3 py-1.5 w-60 sm:w-72 bg-slate-50 border border-slate-300 rounded-lg text-xs focus:bg-white focus:outline-none focus:ring-2 focus:ring-emerald-500"
            autoFocus
          />
        </div>

        {/* Matches Indicator */}
        <span className="text-[11px] font-mono text-slate-600 bg-slate-100 px-2 py-1 rounded-md border border-slate-200">
          {totalMatches > 0 ? `${currentMatchIndex + 1} de ${totalMatches}` : '0 resultados'}
        </span>

        {/* Previous / Next */}
        <div className="flex items-center space-x-1">
          <button
            onClick={onPrevMatch}
            disabled={totalMatches === 0}
            className="p-1 hover:bg-slate-100 disabled:opacity-30 rounded text-slate-700 border border-slate-200"
            title="Coincidencia anterior"
          >
            <ChevronUp className="w-3.5 h-3.5" />
          </button>
          <button
            onClick={onNextMatch}
            disabled={totalMatches === 0}
            className="p-1 hover:bg-slate-100 disabled:opacity-30 rounded text-slate-700 border border-slate-200"
            title="Siguiente coincidencia"
          >
            <ChevronDown className="w-3.5 h-3.5" />
          </button>
        </div>

        {/* Toggle Replace */}
        <button
          onClick={() => setShowReplace(!showReplace)}
          className={`px-2.5 py-1 rounded-md font-medium border text-xs transition-colors ${
            showReplace
              ? 'bg-emerald-50 text-emerald-700 border-emerald-200'
              : 'bg-white text-slate-700 border-slate-300 hover:bg-slate-50'
          }`}
        >
          <Replace className="w-3 h-3 inline mr-1" />
          <span>Reemplazar</span>
        </button>
      </div>

      {/* Replace Controls if active */}
      {showReplace && onReplace && (
        <div className="flex items-center space-x-2 w-full sm:w-auto pt-2 sm:pt-0">
          <input
            type="text"
            value={replaceText}
            onChange={(e) => setReplaceText(e.target.value)}
            placeholder="Reemplazar con..."
            className="px-3 py-1.5 w-48 sm:w-56 bg-slate-50 border border-slate-300 rounded-lg text-xs focus:bg-white focus:outline-none focus:ring-2 focus:ring-emerald-500"
          />
          <button
            onClick={() => onReplace(findText, replaceText, false)}
            disabled={!findText || totalMatches === 0}
            className="px-2.5 py-1.5 bg-slate-100 hover:bg-slate-200 disabled:opacity-40 text-slate-800 rounded-md font-semibold text-xs border border-slate-300"
          >
            Reemplazar
          </button>
          <button
            onClick={() => onReplace(findText, replaceText, true)}
            disabled={!findText || totalMatches === 0}
            className="px-2.5 py-1.5 bg-emerald-600 hover:bg-emerald-500 disabled:opacity-40 text-white rounded-md font-semibold text-xs shadow-xs"
          >
            Reemplazar Todo
          </button>
        </div>
      )}

      {/* Close button */}
      <button
        onClick={onClose}
        className="p-1 hover:bg-slate-100 text-slate-400 hover:text-slate-700 rounded-lg"
      >
        <X className="w-4 h-4" />
      </button>
    </div>
  );
};
