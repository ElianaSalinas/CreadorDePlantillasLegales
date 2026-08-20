import React, { useState } from 'react';
import {
  FileText,
  Layers,
  Settings,
  ShieldCheck,
  History,
  FolderOpen,
  Sparkles,
  CheckCircle2,
  AlertTriangle,
  XCircle,
  Plus,
  Upload,
  BookOpen,
  Code2,
  FileCheck2,
  Scale,
  User,
  ShieldAlert,
} from 'lucide-react';
import { useAppStore } from '../store/useAppStore';
import { runTemplateHealthCheck } from '../core/healthCheck';

interface NavbarProps {
  onOpenNewTemplateModal: () => void;
  onOpenDocxImportModal: () => void;
  onOpenHealthModal: () => void;
  onOpenSchemaModal: () => void;
  onOpenProfileModal: () => void;
  onOpenAuditModal: () => void;
}

export const Navbar: React.FC<NavbarProps> = ({
  onOpenNewTemplateModal,
  onOpenDocxImportModal,
  onOpenHealthModal,
  onOpenSchemaModal,
  onOpenProfileModal,
  onOpenAuditModal,
}) => {
  const { state, setView, activeTemplate, currentUser } = useAppStore();

  const health = activeTemplate ? runTemplateHealthCheck(activeTemplate) : null;

  return (
    <header className="bg-slate-900 border-b border-slate-800 text-slate-100 sticky top-0 z-40 shadow-sm">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Brand & Jurisdiction */}
          <div className="flex items-center space-x-4">
            <button
              onClick={() => setView('TEMPLATES')}
              className="flex items-center space-x-2 text-left focus:outline-none group"
            >
              <div className="w-9 h-9 rounded-lg bg-gradient-to-br from-emerald-600 to-emerald-700 flex items-center justify-center shadow-inner group-hover:scale-105 transition-transform">
                <FileText className="w-5 h-5 text-white" />
              </div>
              <div>
                <div className="flex items-center space-x-2">
                  <span className="font-bold text-lg tracking-tight text-white font-serif">SAVE</span>
                  <span className="text-xs px-1.5 py-0.5 rounded bg-emerald-500/20 text-emerald-300 font-mono font-medium border border-emerald-400/30">
                    v2.0
                  </span>
                </div>
                <div className="text-[11px] text-slate-400 flex items-center space-x-1">
                  <span>República Dominicana</span>
                  <span>🇩🇴</span>
                </div>
              </div>
            </button>

            {/* Breadcrumb if template selected */}
            {activeTemplate && state.currentView !== 'TEMPLATES' && (
              <div className="hidden md:flex items-center space-x-2 pl-4 border-l border-slate-800 text-sm">
                <span className="text-slate-500">/</span>
                <span className="text-slate-300 font-medium truncate max-w-xs">{activeTemplate.name}</span>
                <span
                  className={`text-[10px] px-2 py-0.5 rounded-full font-semibold ${
                    activeTemplate.status === 'PUBLISHED'
                      ? 'bg-emerald-500/20 text-emerald-300 border border-emerald-500/30'
                      : activeTemplate.status === 'REVIEW'
                      ? 'bg-amber-500/20 text-amber-300 border border-amber-500/30'
                      : 'bg-slate-700 text-slate-300'
                  }`}
                >
                  {activeTemplate.status}
                </span>
              </div>
            )}
          </div>

          {/* Navigation Tabs */}
          <nav className="hidden lg:flex items-center space-x-1">
            <button
              onClick={() => setView('TEMPLATES')}
              className={`px-3 py-1.5 rounded-md text-xs font-medium transition-colors flex items-center space-x-1.5 ${
                state.currentView === 'TEMPLATES'
                  ? 'bg-slate-800 text-white shadow-sm'
                  : 'text-slate-400 hover:text-slate-200 hover:bg-slate-800/50'
              }`}
            >
              <FolderOpen className="w-3.5 h-3.5" />
              <span>Plantillas</span>
            </button>

            {activeTemplate && (
              <>
                <button
                  onClick={() => setView('EDITOR')}
                  className={`px-3 py-1.5 rounded-md text-xs font-medium transition-colors flex items-center space-x-1.5 ${
                    state.currentView === 'EDITOR'
                      ? 'bg-slate-800 text-white shadow-sm'
                      : 'text-slate-400 hover:text-slate-200 hover:bg-slate-800/50'
                  }`}
                >
                  <FileText className="w-3.5 h-3.5" />
                  <span>Editor</span>
                </button>

                <button
                  onClick={() => setView('VARIABLES')}
                  className={`px-3 py-1.5 rounded-md text-xs font-medium transition-colors flex items-center space-x-1.5 ${
                    state.currentView === 'VARIABLES'
                      ? 'bg-slate-800 text-white shadow-sm'
                      : 'text-slate-400 hover:text-slate-200 hover:bg-slate-800/50'
                  }`}
                >
                  <Layers className="w-3.5 h-3.5" />
                  <span>Variables ({activeTemplate.variables.length})</span>
                </button>

                <button
                  onClick={() => setView('CLAUSES')}
                  className={`px-3 py-1.5 rounded-md text-xs font-medium transition-colors flex items-center space-x-1.5 ${
                    state.currentView === 'CLAUSES'
                      ? 'bg-slate-800 text-white shadow-sm'
                      : 'text-slate-400 hover:text-slate-200 hover:bg-slate-800/50'
                  }`}
                >
                  <BookOpen className="w-3.5 h-3.5" />
                  <span>Cláusulas ({activeTemplate.clauses.length})</span>
                </button>

                <button
                  onClick={() => setView('RULES')}
                  className={`px-3 py-1.5 rounded-md text-xs font-medium transition-colors flex items-center space-x-1.5 ${
                    state.currentView === 'RULES'
                      ? 'bg-slate-800 text-white shadow-sm'
                      : 'text-slate-400 hover:text-slate-200 hover:bg-slate-800/50'
                  }`}
                >
                  <Settings className="w-3.5 h-3.5" />
                  <span>Reglas ({activeTemplate.rules.length})</span>
                </button>

                <button
                  onClick={() => setView('FORM_GEN')}
                  className={`px-3 py-1.5 rounded-md text-xs font-semibold transition-all flex items-center space-x-1.5 ${
                    state.currentView === 'FORM_GEN'
                      ? 'bg-emerald-600 text-white shadow-md shadow-emerald-900/30'
                      : 'text-emerald-400 bg-emerald-950/40 border border-emerald-800/50 hover:bg-emerald-900/50'
                  }`}
                >
                  <FileCheck2 className="w-3.5 h-3.5" />
                  <span>Generar Documento</span>
                </button>
              </>
            )}

            <button
              onClick={() => setView('DOCUMENTS')}
              className={`px-3 py-1.5 rounded-md text-xs font-medium transition-colors flex items-center space-x-1.5 ${
                state.currentView === 'DOCUMENTS'
                  ? 'bg-slate-800 text-white shadow-sm'
                  : 'text-slate-400 hover:text-slate-200 hover:bg-slate-800/50'
              }`}
            >
              <History className="w-3.5 h-3.5" />
              <span>Historial ({state.generatedDocuments.length})</span>
            </button>
          </nav>

          {/* Action Buttons & Profile */}
          <div className="flex items-center space-x-2.5">
            {activeTemplate && health && (
              <button
                onClick={onOpenHealthModal}
                className={`px-2.5 py-1 rounded-md text-xs font-medium flex items-center space-x-1.5 transition-colors border ${
                  health.status === 'HEALTHY'
                    ? 'bg-emerald-950/50 text-emerald-400 border-emerald-800/50 hover:bg-emerald-900/50'
                    : health.status === 'WARNING'
                    ? 'bg-amber-950/50 text-amber-300 border-amber-800/50 hover:bg-amber-900/50'
                    : 'bg-rose-950/50 text-rose-300 border-rose-800/50 hover:bg-rose-900/50'
                }`}
                title="Diagnóstico de Salud de Plantilla (Health Check)"
              >
                {health.status === 'HEALTHY' && <CheckCircle2 className="w-3.5 h-3.5 text-emerald-400" />}
                {health.status === 'WARNING' && <AlertTriangle className="w-3.5 h-3.5 text-amber-400" />}
                {health.status === 'ERROR' && <XCircle className="w-3.5 h-3.5 text-rose-400" />}
                <span>Salud: {health.score}%</span>
              </button>
            )}

            <button
              onClick={onOpenAuditModal}
              className="p-1.5 text-slate-400 hover:text-slate-200 hover:bg-slate-800 rounded-md transition-colors"
              title="Pistas de Auditoría Legal"
            >
              <History className="w-4 h-4" />
            </button>

            {activeTemplate && (
              <button
                onClick={onOpenSchemaModal}
                className="p-1.5 text-slate-400 hover:text-slate-200 hover:bg-slate-800 rounded-md transition-colors"
                title="Ver Contrato schema.json"
              >
                <Code2 className="w-4 h-4" />
              </button>
            )}

            <button
              onClick={onOpenDocxImportModal}
              className="hidden sm:flex items-center space-x-1.5 px-3 py-1.5 rounded-md text-xs font-medium bg-slate-800 hover:bg-slate-700 text-slate-200 border border-slate-700 transition-colors"
            >
              <Upload className="w-3.5 h-3.5" />
              <span>Importar DOCX</span>
            </button>

            <button
              onClick={onOpenNewTemplateModal}
              className="hidden md:flex items-center space-x-1 px-3 py-1.5 rounded-md text-xs font-medium bg-emerald-600 hover:bg-emerald-500 text-white shadow-sm transition-colors"
            >
              <Plus className="w-3.5 h-3.5" />
              <span>Nueva</span>
            </button>

            {/* Official Lawyer Profile Badge / Trigger */}
            <button
              onClick={onOpenProfileModal}
              className="flex items-center space-x-2 pl-2 pr-3 py-1 bg-slate-800/90 hover:bg-slate-800 rounded-full border border-slate-700/80 transition-all group shadow-inner"
              title="Ver Perfil y Permisos de Abogado"
            >
              <div className="w-7 h-7 rounded-full bg-gradient-to-br from-amber-500 to-amber-700 flex items-center justify-center text-white text-xs font-bold shadow-sm ring-2 ring-amber-400/30 group-hover:scale-105 transition-transform">
                <Scale className="w-3.5 h-3.5" />
              </div>
              <div className="text-left hidden sm:block">
                <div className="text-xs font-semibold text-white leading-none group-hover:text-amber-300 transition-colors flex items-center space-x-1">
                  <span>{currentUser.name}</span>
                </div>
                <div className="text-[10px] text-amber-400/90 leading-tight flex items-center space-x-1 mt-0.5">
                  <span>⚖️ Abogada • {currentUser.cardRegistration.split(' ')[1] || 'CARD'}</span>
                </div>
              </div>
            </button>
          </div>
        </div>
      </div>
    </header>
  );
};

