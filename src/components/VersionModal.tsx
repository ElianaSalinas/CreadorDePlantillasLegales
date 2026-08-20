import React, { useState } from 'react';
import { History, RotateCcw, Plus, X, Calendar, User, CheckCircle2 } from 'lucide-react';
import { useAppStore } from '../store/useAppStore';

interface VersionModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export const VersionModal: React.FC<VersionModalProps> = ({ isOpen, onClose }) => {
  const { activeTemplate, saveVersion, restoreVersion } = useAppStore();
  const [description, setDescription] = useState('');
  const [isSavingNew, setIsSavingNew] = useState(false);

  if (!isOpen || !activeTemplate) return null;

  const versions = activeTemplate.versions || [];

  const handleSaveSnapshot = (e: React.FormEvent) => {
    e.preventDefault();
    saveVersion(activeTemplate.id, description);
    setDescription('');
    setIsSavingNew(false);
  };

  const handleRestore = (versionNumber: string) => {
    if (confirm(`¿Restaurar la plantilla al estado de la versión v${versionNumber}?`)) {
      restoreVersion(activeTemplate.id, versionNumber);
      onClose();
    }
  };

  return (
    <div className="fixed inset-0 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4 z-50 animate-in fade-in">
      <div className="bg-white dark:bg-slate-900 rounded-2xl max-w-xl w-full p-6 shadow-2xl border border-[#E8E5DF] dark:border-slate-800 max-h-[90vh] overflow-y-auto space-y-4">
        <div className="flex items-center justify-between pb-3 border-b border-[#E8E5DF] dark:border-slate-800">
          <div className="flex items-center space-x-3">
            <div className="w-9 h-9 rounded-xl bg-[#0D2C24] text-[#FDE8B5] flex items-center justify-center">
              <History className="w-5 h-5" />
            </div>
            <div>
              <h3 className="font-serif font-bold text-base text-slate-900 dark:text-white">Historial de Versiones (US-51)</h3>
              <p className="text-xs text-slate-500 dark:text-slate-400">Versión actual: v{activeTemplate.version} • SAVE</p>
            </div>
          </div>

          <button onClick={onClose} className="text-slate-400 hover:text-slate-600 dark:hover:text-white cursor-pointer">
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Create new snapshot */}
        {!isSavingNew ? (
          <button
            onClick={() => setIsSavingNew(true)}
            className="w-full py-2.5 px-4 rounded-xl border-2 border-dashed border-[#D1CCC4] dark:border-slate-700 hover:border-[#0D2C24] dark:hover:border-emerald-500 text-xs font-bold text-slate-700 dark:text-slate-300 hover:text-[#0D2C24] dark:hover:text-emerald-400 flex items-center justify-center space-x-2 transition-colors cursor-pointer"
          >
            <Plus className="w-4 h-4 text-[#C5A059]" />
            <span>Crear Snapshot de Nueva Versión</span>
          </button>
        ) : (
          <form onSubmit={handleSaveSnapshot} className="bg-[#F5F2ED] dark:bg-slate-800/80 p-4 rounded-xl border border-[#E8E5DF] dark:border-slate-700 space-y-3 text-xs">
            <label className="block font-semibold text-slate-700 dark:text-slate-300">Descripción del Cambio o Novedades</label>
            <input
              type="text"
              required
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              placeholder="ej. Se agregaron cláusulas notariales de mora y fianza"
              className="w-full px-3 py-2 bg-white dark:bg-slate-900 border border-[#D1CCC4] dark:border-slate-700 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0D2C24] dark:text-white"
            />
            <div className="flex justify-end space-x-2">
              <button
                type="button"
                onClick={() => setIsSavingNew(false)}
                className="px-3 py-1.5 rounded-xl bg-[#E8E5DF] dark:bg-slate-700 text-slate-700 dark:text-slate-300 cursor-pointer"
              >
                Cancelar
              </button>
              <button
                type="submit"
                className="px-3 py-1.5 rounded-xl bg-[#0D2C24] hover:bg-[#164E3E] text-[#FDE8B5] font-bold cursor-pointer"
              >
                Guardar Versión
              </button>
            </div>
          </form>
        )}

        {/* Versions list */}
        <div className="divide-y divide-[#E8E5DF] dark:divide-slate-800 max-h-72 overflow-y-auto">
          {versions.length === 0 ? (
            <p className="text-xs text-slate-400 text-center py-6">No hay versiones previas registradas.</p>
          ) : (
            versions.map((ver) => {
              const isCurrent = ver.version === activeTemplate.version;

              return (
                <div key={ver.version} className="py-3 flex items-center justify-between gap-3 hover:bg-[#FAFAF8] dark:hover:bg-slate-800/40 p-2 rounded-xl transition-colors">
                  <div>
                    <div className="flex items-center space-x-2">
                      <span className="font-mono font-bold text-xs text-[#0D2C24] dark:text-emerald-400 bg-[#F5F2ED] dark:bg-slate-800 px-2 py-0.5 rounded border border-[#E8E5DF] dark:border-slate-700">
                        v{ver.version}
                      </span>
                      {isCurrent && (
                        <span className="text-[10px] bg-emerald-50 dark:bg-emerald-950 text-emerald-700 dark:text-emerald-300 border border-emerald-200 dark:border-emerald-800 px-1.5 py-0.5 rounded font-semibold">
                          Actual
                        </span>
                      )}
                      <span className="text-xs font-medium text-slate-800 dark:text-slate-200">{ver.description}</span>
                    </div>

                    <div className="flex items-center space-x-3 text-[11px] text-slate-400 mt-1">
                      <span className="flex items-center space-x-1">
                        <Calendar className="w-3 h-3" />
                        <span>{new Date(ver.createdAt).toLocaleString()}</span>
                      </span>
                      <span className="flex items-center space-x-1">
                        <User className="w-3 h-3" />
                        <span>{ver.createdBy}</span>
                      </span>
                    </div>
                  </div>

                  {!isCurrent && (
                    <button
                      onClick={() => handleRestore(ver.version)}
                      className="px-2.5 py-1 text-xs font-semibold rounded-xl bg-[#F5F2ED] dark:bg-slate-800 hover:bg-[#E8E5DF] text-slate-700 dark:text-slate-300 flex items-center space-x-1 cursor-pointer"
                    >
                      <RotateCcw className="w-3 h-3 text-[#C5A059]" />
                      <span>Restaurar</span>
                    </button>
                  )}
                </div>
              );
            })
          )}
        </div>

        <div className="flex justify-end pt-2 border-t border-[#E8E5DF] dark:border-slate-800">
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
