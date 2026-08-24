import React, { useState } from 'react';
import { Code2, Copy, Download, Check, X } from 'lucide-react';
import { useAppStore } from '../store/useAppStore';
import { generateSchemaJson } from '../core/exportEngine';

interface SchemaModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export const SchemaModal: React.FC<SchemaModalProps> = ({ isOpen, onClose }) => {
  const { activeTemplate } = useAppStore();
  const [copied, setCopied] = useState(false);

  if (!isOpen || !activeTemplate) return null;

  const jsonStr = generateSchemaJson(activeTemplate);

  const handleCopy = () => {
    navigator.clipboard.writeText(jsonStr);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const handleDownload = () => {
    const blob = new Blob([jsonStr], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `${activeTemplate.name.replace(/[^a-zA-Z0-9_-]/g, '_')}_schema.json`;
    a.click();
    URL.revokeObjectURL(url);
  };

  return (
    <div className="fixed inset-0 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4 z-50 animate-in fade-in">
      <div className="bg-white dark:bg-slate-900 rounded-2xl max-w-2xl w-full p-6 shadow-2xl border border-[#E8E5DF] dark:border-slate-800 max-h-[90vh] overflow-y-auto space-y-4">
        <div className="flex items-center justify-between pb-3 border-b border-[#E8E5DF] dark:border-slate-800">
          <div className="flex items-center space-x-3">
            <div className="w-9 h-9 rounded-xl bg-[#0D2C24] text-[#FDE8B5] flex items-center justify-center">
              <Code2 className="w-5 h-5" />
            </div>
            <div>
              <h3 className="font-serif font-bold text-base text-slate-900 dark:text-white">
                Contrato de Datos schema.json
              </h3>
              <p className="text-xs text-slate-500 dark:text-slate-400">
                Especificación Técnica Sección 5 • JSON Schema Draft-07 • SAVE
              </p>
            </div>
          </div>

          <button onClick={onClose} className="text-slate-400 hover:text-slate-600 dark:hover:text-white cursor-pointer">
            <X className="w-5 h-5" />
          </button>
        </div>

        <div className="relative">
          <pre className="bg-[#0B1A15] text-[#F5F2ED] p-4 rounded-xl text-xs font-mono max-h-[400px] overflow-y-auto leading-relaxed border border-[#164E3E]/60 selection:bg-[#FDE8B5] selection:text-[#0D2C24]">
            {jsonStr}
          </pre>

          <div className="absolute top-3 right-3 flex items-center space-x-2">
            <button
              onClick={handleCopy}
              className="px-2.5 py-1 rounded-lg bg-[#0D2C24] hover:bg-[#164E3E] text-white text-xs font-medium flex items-center space-x-1 border border-[#164E3E] cursor-pointer"
            >
              {copied ? <Check className="w-3.5 h-3.5 text-emerald-400" /> : <Copy className="w-3.5 h-3.5 text-[#FDE8B5]" />}
              <span>{copied ? 'Copiado' : 'Copiar'}</span>
            </button>

            <button
              onClick={handleDownload}
              className="px-2.5 py-1 rounded-lg bg-[#C5A059] hover:bg-[#B38F46] text-[#0D2C24] font-bold text-xs flex items-center space-x-1 cursor-pointer"
            >
              <Download className="w-3.5 h-3.5" />
              <span>Descargar .json</span>
            </button>
          </div>
        </div>

        <div className="flex justify-end pt-2">
          <button
            onClick={onClose}
            className="px-4 py-2 rounded-xl text-xs font-semibold bg-[#F5F2ED] dark:bg-slate-800 hover:bg-[#E8E5DF] dark:hover:bg-slate-700 text-slate-700 dark:text-slate-300 cursor-pointer"
          >
            Cerrar
          </button>
        </div>
      </div>
    </div>
  );
};
