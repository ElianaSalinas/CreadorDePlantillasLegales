import React, { useState } from 'react';
import { History, Shield, Calendar, User, Search, X } from 'lucide-react';
import { useAppStore } from '../store/useAppStore';

interface AuditLogModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export const AuditLogModal: React.FC<AuditLogModalProps> = ({ isOpen, onClose }) => {
  const { state } = useAppStore();
  const [searchQuery, setSearchQuery] = useState('');

  if (!isOpen) return null;

  const logs = state.auditLogs.filter(
    (log) =>
      log.details.toLowerCase().includes(searchQuery.toLowerCase()) ||
      log.action.toLowerCase().includes(searchQuery.toLowerCase()) ||
      log.user.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <div className="fixed inset-0 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4 z-50 animate-in fade-in">
      <div className="bg-white dark:bg-slate-900 rounded-2xl max-w-3xl w-full p-6 shadow-2xl border border-[#E8E5DF] dark:border-slate-800 max-h-[90vh] overflow-y-auto space-y-4">
        <div className="flex items-center justify-between pb-3 border-b border-[#E8E5DF] dark:border-slate-800">
          <div className="flex items-center space-x-3">
            <div className="w-9 h-9 rounded-xl bg-[#0D2C24] text-[#FDE8B5] flex items-center justify-center">
              <Shield className="w-5 h-5" />
            </div>
            <div>
              <h3 className="font-serif font-bold text-base text-slate-900 dark:text-white">
                Pista de Auditoría y Trazabilidad (US-61..US-65)
              </h3>
              <p className="text-xs text-slate-500 dark:text-slate-400">Registro inmutable de operaciones y eventos legales • SAVE</p>
            </div>
          </div>

          <button onClick={onClose} className="text-slate-400 hover:text-slate-600 dark:hover:text-white cursor-pointer">
            <X className="w-5 h-5" />
          </button>
        </div>

        <div className="relative">
          <Search className="w-3.5 h-3.5 absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
          <input
            type="text"
            placeholder="Buscar por acción o detalle..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full pl-8 pr-3 py-2 text-xs rounded-xl border border-[#D1CCC4] dark:border-slate-700 bg-[#FAFAF8] dark:bg-slate-800 dark:text-white focus:outline-none focus:ring-2 focus:ring-[#0D2C24]"
          />
        </div>

        <div className="divide-y divide-[#E8E5DF] dark:divide-slate-800 max-h-[450px] overflow-y-auto">
          {logs.length === 0 ? (
            <p className="text-xs text-slate-400 text-center py-8">No hay registros de auditoría que coincidan.</p>
          ) : (
            logs.map((log) => (
              <div key={log.id} className="py-3 flex items-start justify-between gap-4 text-xs hover:bg-[#FAFAF8] dark:hover:bg-slate-800/40 p-2 rounded-xl transition-colors">
                <div className="space-y-1">
                  <div className="flex items-center space-x-2">
                    <span className="font-mono font-bold text-[10px] px-2 py-0.5 rounded bg-[#F5F2ED] dark:bg-slate-800 text-[#0D2C24] dark:text-emerald-400 border border-[#E8E5DF] dark:border-slate-700">
                      {log.action}
                    </span>
                    <span className="font-medium text-slate-900 dark:text-white">{log.details}</span>
                  </div>
                  <div className="flex items-center space-x-3 text-[11px] text-slate-400">
                    <span className="flex items-center space-x-1">
                      <Calendar className="w-3 h-3" />
                      <span>{new Date(log.timestamp).toLocaleString()}</span>
                    </span>
                    <span className="flex items-center space-x-1">
                      <User className="w-3 h-3" />
                      <span>{log.user}</span>
                    </span>
                  </div>
                </div>
              </div>
            ))
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
