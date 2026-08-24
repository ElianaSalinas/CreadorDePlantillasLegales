import React from 'react';
import { FileText, X, CheckCircle2, Clock } from 'lucide-react';

interface WordCountModalProps {
  isOpen: boolean;
  onClose: () => void;
  content: string;
  pagesCount: number;
}

export const WordCountModal: React.FC<WordCountModalProps> = ({
  isOpen,
  onClose,
  content,
  pagesCount,
}) => {
  if (!isOpen) return null;

  const charactersWithSpaces = content.length;
  const charactersNoSpaces = content.replace(/\s/g, '').length;
  const words = content.trim() ? content.trim().split(/\s+/).length : 0;
  const paragraphs = content.split(/\n\s*\n/).filter((p) => p.trim()).length;
  const lines = content.split('\n').length;
  const estimatedReadingTimeMin = Math.ceil(words / 200);

  return (
    <div className="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-xs flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl shadow-2xl border border-slate-200 w-full max-w-md overflow-hidden animate-in fade-in zoom-in-95 duration-150">
        <div className="p-4 bg-slate-50 border-b border-slate-200 flex items-center justify-between">
          <div className="flex items-center space-x-2">
            <FileText className="w-4 h-4 text-emerald-600" />
            <h3 className="font-bold text-sm text-slate-800">Contar Palabras y Estadísticas</h3>
          </div>
          <button onClick={onClose} className="p-1 hover:bg-slate-200 rounded text-slate-400 hover:text-slate-700">
            <X className="w-4 h-4" />
          </button>
        </div>

        <div className="p-6 space-y-4">
          <div className="space-y-2 text-xs divide-y divide-slate-100">
            <div className="flex justify-between py-1.5 font-medium">
              <span className="text-slate-500">Páginas notariales:</span>
              <span className="font-bold text-slate-900">{pagesCount}</span>
            </div>
            <div className="flex justify-between py-1.5 font-medium">
              <span className="text-slate-500">Palabras totales:</span>
              <span className="font-bold text-slate-900">{words.toLocaleString()}</span>
            </div>
            <div className="flex justify-between py-1.5 font-medium">
              <span className="text-slate-500">Caracteres (sin espacios):</span>
              <span className="font-mono font-bold text-slate-900">{charactersNoSpaces.toLocaleString()}</span>
            </div>
            <div className="flex justify-between py-1.5 font-medium">
              <span className="text-slate-500">Caracteres (con espacios):</span>
              <span className="font-mono font-bold text-slate-900">{charactersWithSpaces.toLocaleString()}</span>
            </div>
            <div className="flex justify-between py-1.5 font-medium">
              <span className="text-slate-500">Párrafos / Cláusulas:</span>
              <span className="font-bold text-slate-900">{paragraphs}</span>
            </div>
            <div className="flex justify-between py-1.5 font-medium">
              <span className="text-slate-500">Líneas de texto:</span>
              <span className="font-mono font-bold text-slate-900">{lines}</span>
            </div>
            <div className="flex justify-between py-1.5 font-medium items-center">
              <span className="text-slate-500 flex items-center space-x-1">
                <Clock className="w-3.5 h-3.5 text-slate-400" />
                <span>Tiempo estimado de lectura solemne:</span>
              </span>
              <span className="font-bold text-emerald-600">~{estimatedReadingTimeMin} min</span>
            </div>
          </div>
        </div>

        <div className="p-4 bg-slate-50 border-t border-slate-200 flex justify-end">
          <button
            onClick={onClose}
            className="px-4 py-2 bg-slate-900 hover:bg-slate-800 text-white rounded-xl text-xs font-semibold shadow-xs"
          >
            Cerrar
          </button>
        </div>
      </div>
    </div>
  );
};
