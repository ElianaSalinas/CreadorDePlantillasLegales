import React from 'react';
import { HelpCircle, BookOpen, ShieldCheck, Scale, Keyboard, X, ExternalLink } from 'lucide-react';

interface HelpLegalModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export const HelpLegalModal: React.FC<HelpLegalModalProps> = ({ isOpen, onClose }) => {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-xs flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl shadow-2xl border border-slate-200 w-full max-w-2xl max-h-[85vh] flex flex-col overflow-hidden animate-in fade-in zoom-in-95 duration-150">
        <div className="p-4 bg-slate-50 border-b border-slate-200 flex items-center justify-between">
          <div className="flex items-center space-x-2">
            <HelpCircle className="w-5 h-5 text-emerald-600" />
            <div>
              <h3 className="font-bold text-sm text-slate-900">Centro de Ayuda y Normativa Jurídica</h3>
              <p className="text-[11px] text-slate-500">República Dominicana • Ley 140-15 del Notariado</p>
            </div>
          </div>
          <button onClick={onClose} className="p-1 hover:bg-slate-200 rounded text-slate-400 hover:text-slate-700">
            <X className="w-4 h-4" />
          </button>
        </div>

        <div className="flex-1 overflow-y-auto p-6 space-y-6 text-xs text-slate-700">
          {/* Section 1: Ley 140-15 */}
          <div className="p-4 bg-emerald-50/70 border border-emerald-200 rounded-xl space-y-2">
            <div className="flex items-center space-x-2 text-emerald-900 font-bold text-sm">
              <Scale className="w-4 h-4 text-emerald-700" />
              <span>Marco Legal: Ley del Notariado 140-15</span>
            </div>
            <p className="leading-relaxed">
              Los actos auténticos y bajo firma privada legalizados deben cumplir con los requisitos solemnes: comparecencia completa de partes (nombres, cédulas JCE, estado civil, ocupación y domicilio), fe de conocimiento, lectura íntegra en alta voz, y firma de notario con su número de colegiatura y sello oficial.
            </p>
          </div>

          {/* Section 2: Shortcuts */}
          <div className="space-y-3">
            <div className="flex items-center space-x-2 text-slate-900 font-bold text-sm">
              <Keyboard className="w-4 h-4 text-slate-600" />
              <span>Atajos de Teclado del Ribbon Jurídico</span>
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 text-xs">
              <div className="p-2.5 bg-slate-50 border border-slate-200 rounded-lg flex justify-between">
                <span>Guardar documento</span>
                <kbd className="px-1.5 py-0.5 bg-white border border-slate-300 rounded font-mono font-bold text-[10px]">Ctrl + S</kbd>
              </div>
              <div className="p-2.5 bg-slate-50 border border-slate-200 rounded-lg flex justify-between">
                <span>Imprimir / Exportar PDF</span>
                <kbd className="px-1.5 py-0.5 bg-white border border-slate-300 rounded font-mono font-bold text-[10px]">Ctrl + P</kbd>
              </div>
              <div className="p-2.5 bg-slate-50 border border-slate-200 rounded-lg flex justify-between">
                <span>Buscar en texto</span>
                <kbd className="px-1.5 py-0.5 bg-white border border-slate-300 rounded font-mono font-bold text-[10px]">Ctrl + F</kbd>
              </div>
              <div className="p-2.5 bg-slate-50 border border-slate-200 rounded-lg flex justify-between">
                <span>Copiar todo</span>
                <kbd className="px-1.5 py-0.5 bg-white border border-slate-300 rounded font-mono font-bold text-[10px]">Ctrl + C</kbd>
              </div>
            </div>
          </div>

          {/* Section 3: Dominican Validations */}
          <div className="space-y-2">
            <h4 className="font-bold text-slate-900">Validaciones Automáticas Integradas:</h4>
            <ul className="list-disc list-inside space-y-1 text-slate-600">
              <li><strong>Cédulas JCE:</strong> Verificación de 11 dígitos con algoritmo Módulo 10 y detección de prefijos dominicanos válidos.</li>
              <li><strong>RNC DGII:</strong> Verificación de 9 u 11 dígitos para personas jurídicas y físicas.</li>
              <li><strong>Montos en Letras:</strong> Conversión gramatical estricta a moneda dominicana (Pesos Dominicanos con centavos).</li>
              <li><strong>Fechas Solemnes:</strong> Redacción notarial formal ("A los quince (15) días del mes de...").</li>
            </ul>
          </div>
        </div>

        <div className="p-4 bg-slate-50 border-t border-slate-200 flex justify-end">
          <button
            onClick={onClose}
            className="px-4 py-2 bg-slate-900 hover:bg-slate-800 text-white rounded-xl text-xs font-semibold"
          >
            Entendido
          </button>
        </div>
      </div>
    </div>
  );
};
