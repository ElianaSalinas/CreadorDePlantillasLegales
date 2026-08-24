import React, { useState } from 'react';
import {
  Upload,
  FileText,
  Sparkles,
  X,
  CheckCircle2,
  AlertTriangle,
  FileUp,
} from 'lucide-react';
import { useAppStore } from '../store/useAppStore';
import { parseDocxFile } from '../core/docxParser';
import { detectVariablesLocally, detectVariablesWithAI } from '../core/detectorEngine';
import { TemplateCategory } from '../types';

interface DocxImportModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export const DocxImportModal: React.FC<DocxImportModalProps> = ({ isOpen, onClose }) => {
  const { startHitlReview, setAnalyzing } = useAppStore();

  const [activeTab, setActiveTab] = useState<'DOCX' | 'PASTE'>('DOCX');
  const [pastedText, setPastedText] = useState('');
  const [selectedFile, setSelectedFile] = useState<File | null>(null);
  const [templateName, setTemplateName] = useState('');
  const [category, setCategory] = useState<TemplateCategory>('Inmobiliario');
  const [isLoading, setIsLoading] = useState(false);
  const [useAI, setUseAI] = useState(true);

  if (!isOpen) return null;

  const handleFileDrop = (e: React.DragEvent<HTMLDivElement>) => {
    e.preventDefault();
    if (e.dataTransfer.files && e.dataTransfer.files[0]) {
      const file = e.dataTransfer.files[0];
      if (file.name.endsWith('.docx')) {
        setSelectedFile(file);
        if (!templateName) {
          setTemplateName(file.name.replace('.docx', ''));
        }
      } else {
        alert('Por favor selecciona un archivo .docx válido');
      }
    }
  };

  const handleFileInput = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      const file = e.target.files[0];
      setSelectedFile(file);
      if (!templateName) {
        setTemplateName(file.name.replace('.docx', ''));
      }
    }
  };

  const handleStartImportAndAnalysis = async () => {
    setIsLoading(true);
    setAnalyzing(true);

    try {
      let rawText = '';
      if (activeTab === 'DOCX') {
        if (!selectedFile) {
          alert('Por favor selecciona un archivo .docx');
          return;
        }
        const parsed = await parseDocxFile(selectedFile);
        rawText = parsed.text;
      } else {
        if (!pastedText.trim()) {
          alert('Por favor pega el texto del contrato');
          return;
        }
        rawText = pastedText;
      }

      // Execute detection
      let detectedVars = [];
      if (useAI) {
        const aiRes = await detectVariablesWithAI(rawText);
        detectedVars = aiRes.detectedVariables;
      } else {
        detectedVars = detectVariablesLocally(rawText);
      }

      onClose();
      startHitlReview(rawText, detectedVars);
    } catch (e: any) {
      alert(`Error procesando documento: ${e.message}`);
    } finally {
      setIsLoading(false);
      setAnalyzing(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4 z-50 animate-in fade-in">
      <div className="bg-white dark:bg-slate-900 rounded-2xl max-w-xl w-full p-6 shadow-2xl border border-[#E8E5DF] dark:border-slate-800 space-y-4">
        {/* Header */}
        <div className="flex items-center justify-between pb-3 border-b border-[#E8E5DF] dark:border-slate-800">
          <div className="flex items-center space-x-3">
            <div className="w-9 h-9 rounded-xl bg-[#0D2C24] text-[#FDE8B5] flex items-center justify-center">
              <Upload className="w-5 h-5" />
            </div>
            <div>
              <h3 className="font-serif font-bold text-base text-slate-900 dark:text-white">
                Importación y Detección Inteligente
              </h3>
              <p className="text-xs text-slate-500 dark:text-slate-400">Módulo de Ingesta DOCX (US-36..US-41) • SAVE</p>
            </div>
          </div>

          <button onClick={onClose} className="text-slate-400 hover:text-slate-600 dark:hover:text-white cursor-pointer">
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Tab switch */}
        <div className="flex space-x-2 border-b border-[#E8E5DF] dark:border-slate-800 pb-2 text-xs">
          <button
            onClick={() => setActiveTab('DOCX')}
            className={`px-3.5 py-1.5 rounded-xl font-bold transition-colors cursor-pointer ${
              activeTab === 'DOCX'
                ? 'bg-[#0D2C24] text-white shadow-xs'
                : 'text-slate-600 dark:text-slate-400 hover:bg-[#F5F2ED] dark:hover:bg-slate-800'
            }`}
          >
            Subir Archivo .DOCX
          </button>
          <button
            onClick={() => setActiveTab('PASTE')}
            className={`px-3.5 py-1.5 rounded-xl font-bold transition-colors cursor-pointer ${
              activeTab === 'PASTE'
                ? 'bg-[#0D2C24] text-white shadow-xs'
                : 'text-slate-600 dark:text-slate-400 hover:bg-[#F5F2ED] dark:hover:bg-slate-800'
            }`}
          >
            Pegar Texto Jurídico
          </button>
        </div>

        {/* Content area */}
        {activeTab === 'DOCX' ? (
          <div
            onDragOver={(e) => e.preventDefault()}
            onDrop={handleFileDrop}
            className="border-2 border-dashed border-[#D1CCC4] dark:border-slate-700 hover:border-[#0D2C24] dark:hover:border-emerald-500 rounded-2xl p-8 text-center cursor-pointer transition-colors bg-[#FAFAF8] dark:bg-slate-800/40"
            onClick={() => document.getElementById('docxInput')?.click()}
          >
            <input
              type="file"
              id="docxInput"
              accept=".docx"
              onChange={handleFileInput}
              className="hidden"
            />
            <FileUp className="w-10 h-10 text-[#0D2C24] dark:text-emerald-400 mx-auto mb-2 opacity-80" />
            {selectedFile ? (
              <div>
                <p className="text-xs font-bold text-[#0D2C24] dark:text-emerald-400 font-mono">{selectedFile.name}</p>
                <p className="text-[11px] text-slate-400">{(selectedFile.size / 1024).toFixed(1)} KB</p>
              </div>
            ) : (
              <div>
                <p className="text-xs font-bold text-slate-800 dark:text-slate-200">Arrastra tu archivo .docx aquí</p>
                <p className="text-[11px] text-slate-400 mt-0.5">O haz clic para seleccionar desde tu equipo</p>
              </div>
            )}
          </div>
        ) : (
          <div>
            <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">
              Texto del Contrato Dominicano
            </label>
            <textarea
              rows={6}
              value={pastedText}
              onChange={(e) => setPastedText(e.target.value)}
              placeholder="Pega aquí el texto completo del contrato..."
              className="w-full p-3 font-serif text-xs border border-[#D1CCC4] dark:border-slate-700 dark:bg-slate-800 dark:text-white rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0D2C24]"
            />
          </div>
        )}

        {/* Options */}
        <div className="space-y-3 pt-2 text-xs">
          <div>
            <label className="block font-semibold text-slate-700 dark:text-slate-300 mb-1">Nombre de la Plantilla</label>
            <input
              type="text"
              value={templateName}
              onChange={(e) => setTemplateName(e.target.value)}
              placeholder="ej. Contrato de Alquiler de Local Comercial"
              className="w-full px-3 py-2 border border-[#D1CCC4] dark:border-slate-700 dark:bg-slate-800 dark:text-white rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0D2C24]"
            />
          </div>

          <div className="flex items-center space-x-2 pt-1">
            <input
              type="checkbox"
              id="useAiCheckbox"
              checked={useAI}
              onChange={(e) => setUseAI(e.target.checked)}
              className="rounded text-[#0D2C24] focus:ring-[#0D2C24] cursor-pointer"
            />
            <label htmlFor="useAiCheckbox" className="font-semibold text-slate-800 dark:text-slate-200 flex items-center space-x-1 cursor-pointer">
              <Sparkles className="w-3.5 h-3.5 text-[#C5A059]" />
              <span>Detección profunda con IA + Validadores Dominicanos de Cédula/RNC</span>
            </label>
          </div>
        </div>

        {/* Actions */}
        <div className="flex justify-end space-x-2 pt-4 border-t border-[#E8E5DF] dark:border-slate-800 text-xs">
          <button
            onClick={onClose}
            className="px-4 py-2 rounded-xl font-semibold bg-[#F5F2ED] dark:bg-slate-800 hover:bg-[#E8E5DF] dark:hover:bg-slate-700 text-slate-700 dark:text-slate-300 cursor-pointer"
          >
            Cancelar
          </button>

          <button
            onClick={handleStartImportAndAnalysis}
            disabled={isLoading || (activeTab === 'DOCX' && !selectedFile) || (activeTab === 'PASTE' && !pastedText.trim())}
            className="px-4 py-2 rounded-xl font-bold bg-[#0D2C24] hover:bg-[#164E3E] text-white shadow-sm flex items-center space-x-1.5 disabled:opacity-50 cursor-pointer"
          >
            <Sparkles className="w-3.5 h-3.5 text-[#FDE8B5]" />
            <span>{isLoading ? 'Analizando documento...' : 'Iniciar Detección y Revisión'}</span>
          </button>
        </div>
      </div>
    </div>
  );
};
