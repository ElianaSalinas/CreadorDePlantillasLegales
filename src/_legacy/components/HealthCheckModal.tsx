import React from 'react';
import {
  ShieldCheck,
  CheckCircle2,
  AlertTriangle,
  XCircle,
  X,
  Layers,
  BookOpen,
  GitBranch,
  ArrowRight,
  Sparkles,
} from 'lucide-react';
import { useAppStore } from '../store/useAppStore';
import { runTemplateHealthCheck } from '../core/healthCheck';

interface HealthCheckModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export const HealthCheckModal: React.FC<HealthCheckModalProps> = ({ isOpen, onClose }) => {
  const { activeTemplate, setView, changeTemplateStatus } = useAppStore();

  if (!isOpen || !activeTemplate) return null;

  const health = runTemplateHealthCheck(activeTemplate);

  return (
    <div className="fixed inset-0 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4 z-50 animate-in fade-in">
      <div className="bg-white dark:bg-slate-900 rounded-2xl max-w-2xl w-full p-6 shadow-2xl border border-[#E8E5DF] dark:border-slate-800 max-h-[90vh] overflow-y-auto space-y-5">
        {/* Header */}
        <div className="flex items-center justify-between pb-4 border-b border-[#E8E5DF] dark:border-slate-800">
          <div className="flex items-center space-x-3">
            <div
              className={`w-10 h-10 rounded-xl flex items-center justify-center font-bold ${
                health.status === 'HEALTHY'
                  ? 'bg-emerald-50 text-emerald-700 dark:bg-emerald-950 dark:text-emerald-300'
                  : health.status === 'WARNING'
                  ? 'bg-amber-50 text-amber-700 dark:bg-amber-950 dark:text-amber-300'
                  : 'bg-rose-50 text-rose-700 dark:bg-rose-950 dark:text-rose-300'
              }`}
            >
              <ShieldCheck className="w-6 h-6" />
            </div>
            <div>
              <h3 className="font-serif font-bold text-lg text-slate-900 dark:text-white">
                Diagnóstico de Salud de Plantilla (Health Check)
              </h3>
              <p className="text-xs text-slate-500 dark:text-slate-400">
                Auditoría estructural estricta bajo US-56..US-60 y Reglas de Negocio RN-067..RN-071
              </p>
            </div>
          </div>

          <button onClick={onClose} className="text-slate-400 hover:text-slate-600 dark:hover:text-white cursor-pointer">
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Score & Publication Readiness Card */}
        <div
          className={`p-5 rounded-2xl border flex items-center justify-between ${
            health.status === 'HEALTHY'
              ? 'bg-[#F5F2ED] dark:bg-slate-800/80 border-[#C5A059]'
              : health.status === 'WARNING'
              ? 'bg-amber-50/50 dark:bg-amber-950/20 border-amber-300 dark:border-amber-800'
              : 'bg-rose-50/50 dark:bg-rose-950/20 border-rose-300 dark:border-rose-800'
          }`}
        >
          <div>
            <div className="flex items-center space-x-2">
              <span className="text-2xl font-bold font-serif text-slate-900 dark:text-white">{health.score} / 100</span>
              <span
                className={`text-xs px-2.5 py-0.5 rounded-full font-bold uppercase ${
                  health.status === 'HEALTHY'
                    ? 'bg-emerald-100 text-emerald-800 dark:bg-emerald-900 dark:text-emerald-200'
                    : health.status === 'WARNING'
                    ? 'bg-amber-100 text-amber-800 dark:bg-amber-900 dark:text-amber-200'
                    : 'bg-rose-100 text-rose-800 dark:bg-rose-900 dark:text-rose-200'
                }`}
              >
                {health.status}
              </span>
            </div>
            <p className="text-xs text-slate-600 dark:text-slate-300 mt-1">
              {health.canPublish
                ? 'La plantilla cumple con todos los requisitos estructurales para publicación.'
                : 'La publicación está bloqueada hasta resolver todos los errores críticos.'}
            </p>
          </div>

          {health.canPublish && activeTemplate.status !== 'PUBLISHED' && (
            <button
              onClick={() => {
                changeTemplateStatus(activeTemplate.id, 'PUBLISHED');
                onClose();
              }}
              className="px-4 py-2 rounded-xl text-xs font-bold bg-[#0D2C24] hover:bg-[#164E3E] text-[#FDE8B5] shadow-sm cursor-pointer"
            >
              Publicar Plantilla
            </button>
          )}
        </div>

        {/* Breakdown Items */}
        <div className="space-y-3 text-xs">
          {/* 1. Missing Variable References (Errors) */}
          {health.missingVariableReferences.length > 0 && (
            <div className="p-3.5 bg-rose-50 dark:bg-rose-950/30 border border-rose-200 dark:border-rose-800 rounded-xl space-y-1.5">
              <div className="flex items-center space-x-2 text-rose-800 dark:text-rose-300 font-bold">
                <XCircle className="w-4 h-4 text-rose-600" />
                <span>Variables no declaradas en el diccionario ({health.missingVariableReferences.length})</span>
              </div>
              <p className="text-rose-700 dark:text-rose-300 text-[11px]">
                Aparecen etiquetas {`{{tag}}`} en el texto pero no están registradas en la lista de variables:
              </p>
              <div className="flex flex-wrap gap-1 pt-1">
                {health.missingVariableReferences.map((tag) => (
                  <span key={tag} className="font-mono bg-white dark:bg-slate-900 text-rose-700 dark:text-rose-300 px-2 py-0.5 rounded border border-rose-200 dark:border-rose-800 font-medium">
                    {`{{${tag}}}`}
                  </span>
                ))}
              </div>
            </div>
          )}

          {/* 2. Missing Clause References (Errors) */}
          {health.missingClauseReferences.length > 0 && (
            <div className="p-3.5 bg-rose-50 dark:bg-rose-950/30 border border-rose-200 dark:border-rose-800 rounded-xl space-y-1.5">
              <div className="flex items-center space-x-2 text-rose-800 dark:text-rose-300 font-bold">
                <XCircle className="w-4 h-4 text-rose-600" />
                <span>Cláusulas inexistentes referenciadas ({health.missingClauseReferences.length})</span>
              </div>
              <div className="flex flex-wrap gap-1">
                {health.missingClauseReferences.map((cId) => (
                  <span key={cId} className="font-mono bg-white dark:bg-slate-900 text-rose-700 dark:text-rose-300 px-2 py-0.5 rounded border border-rose-200 dark:border-rose-800">
                    {cId}
                  </span>
                ))}
              </div>
            </div>
          )}

          {/* 3. Circular Dependencies (Errors) */}
          {health.circularDependencies.length > 0 && (
            <div className="p-3.5 bg-rose-50 dark:bg-rose-950/30 border border-rose-200 dark:border-rose-800 rounded-xl space-y-1.5">
              <div className="flex items-center space-x-2 text-rose-800 dark:text-rose-300 font-bold">
                <XCircle className="w-4 h-4 text-rose-600" />
                <span>Dependencias Circulares Detectadas</span>
              </div>
              <ul className="list-disc list-inside text-rose-700 dark:text-rose-300 text-[11px] space-y-1">
                {health.circularDependencies.map((dep, i) => (
                  <li key={i}>{dep}</li>
                ))}
              </ul>
            </div>
          )}

          {/* 4. Orphan Variables (Warnings) */}
          {health.orphanVariables.length > 0 && (
            <div className="p-3.5 bg-amber-50 dark:bg-amber-950/30 border border-amber-200 dark:border-amber-800 rounded-xl space-y-1.5">
              <div className="flex items-center space-x-2 text-amber-800 dark:text-amber-300 font-bold">
                <AlertTriangle className="w-4 h-4 text-amber-600" />
                <span>Variables huérfanas ({health.orphanVariables.length})</span>
              </div>
              <p className="text-amber-700 dark:text-amber-300 text-[11px]">
                Están declaradas en el diccionario pero nunca se invocan en el texto del contrato:
              </p>
              <div className="flex flex-wrap gap-1 pt-1">
                {health.orphanVariables.map((tag) => (
                  <span key={tag} className="font-mono bg-white dark:bg-slate-900 text-amber-700 dark:text-amber-300 px-2 py-0.5 rounded border border-amber-200 dark:border-amber-800 font-medium">
                    {`{{${tag}}}`}
                  </span>
                ))}
              </div>
            </div>
          )}

          {/* All Good */}
          {health.status === 'HEALTHY' && (
            <div className="p-4 bg-emerald-50 dark:bg-emerald-950/30 border border-emerald-200 dark:border-emerald-800 rounded-xl text-emerald-800 dark:text-emerald-300 flex items-center space-x-3">
              <CheckCircle2 className="w-5 h-5 text-emerald-600 dark:text-emerald-400 shrink-0" />
              <div>
                <div className="font-bold">Estructura Impecable</div>
                <div className="text-[11px] text-emerald-700 dark:text-emerald-400">
                  Todas las variables, cláusulas y reglas condicionales están sincronizadas correctamente.
                </div>
              </div>
            </div>
          )}
        </div>

        {/* Footer */}
        <div className="flex justify-end pt-4 border-t border-[#E8E5DF] dark:border-slate-800">
          <button
            onClick={onClose}
            className="px-4 py-2 rounded-xl text-xs font-semibold bg-[#F5F2ED] dark:bg-slate-800 hover:bg-[#E8E5DF] dark:hover:bg-slate-700 text-slate-700 dark:text-slate-300 cursor-pointer"
          >
            Cerrar Diagnóstico
          </button>
        </div>
      </div>
    </div>
  );
};
