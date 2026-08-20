import React, { useState } from 'react';
import {
  FileText,
  FileCheck2,
  Files,
  PenTool,
  Sliders,
  BookOpen,
  GitFork,
  Sparkles,
  ShieldCheck,
  History,
  Upload,
  Code2,
  UserCheck,
  ChevronLeft,
  ChevronRight,
  Plus,
  Scale,
  Activity,
  CheckCircle2,
  Briefcase,
  Layers,
  Search,
  Sun,
  Moon,
  Home,
  CreditCard,
  DollarSign,
} from 'lucide-react';
import { useAppStore, AppState } from '../store/useAppStore';

interface SidebarProps {
  onOpenNewTemplateModal: () => void;
  onOpenDocxImportModal: () => void;
  onOpenHealthModal: () => void;
  onOpenSchemaModal: () => void;
  onOpenProfileModal: () => void;
  onOpenAuditModal: () => void;
  isMobileOpen: boolean;
  setIsMobileOpen: (open: boolean) => void;
}

export const Sidebar: React.FC<SidebarProps> = ({
  onOpenNewTemplateModal,
  onOpenDocxImportModal,
  onOpenHealthModal,
  onOpenSchemaModal,
  onOpenProfileModal,
  onOpenAuditModal,
  isMobileOpen,
  setIsMobileOpen,
}) => {
  const { state, setView, currentUser, activeTemplate, isDarkMode, toggleDarkMode } = useAppStore();
  const [isCollapsed, setIsCollapsed] = useState(false);

  const pendingHitlCount = state.hitlTokens.filter((t) => t.status === 'PENDIENTE').length;
  const finalDocsCount = state.generatedDocuments.length;
  const templatesCount = state.templates.length;

  const navigateTo = (view: AppState['currentView']) => {
    setView(view);
    if (window.innerWidth < 1024) {
      setIsMobileOpen(false);
    }
  };

  return (
    <>
      {/* Mobile Backdrop Overlay */}
      {isMobileOpen && (
        <div
          onClick={() => setIsMobileOpen(false)}
          className="fixed inset-0 bg-slate-950/60 backdrop-blur-xs z-40 lg:hidden transition-opacity"
        />
      )}

      {/* Lateral Sidebar Styled with SAVE Brand */}
      <aside
        className={`fixed lg:static top-0 bottom-0 left-0 z-50 flex flex-col bg-[#0D2C24] dark:bg-slate-950 border-r border-[#164E3E] dark:border-slate-800 text-slate-200 transition-all duration-300 ease-in-out shadow-2xl lg:shadow-none ${
          isCollapsed ? 'w-20' : 'w-72'
        } ${isMobileOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0'}`}
      >
        {/* Brand Header */}
        <div className="p-4 border-b border-[#164E3E] dark:border-slate-800 flex items-center justify-between">
          <div
            onClick={() => navigateTo('WELCOME')}
            className="flex items-center space-x-3 overflow-hidden cursor-pointer group"
          >
            <div className="w-9 h-9 rounded-lg bg-white dark:bg-emerald-600 p-0.5 shadow-md shrink-0 flex items-center justify-center text-[#0D2C24] dark:text-white font-serif font-bold text-lg">
              S
            </div>
            {!isCollapsed && (
              <div className="leading-tight truncate">
                <div className="flex items-center space-x-1.5">
                  <span className="font-serif font-bold text-lg text-white tracking-wider">SAVE</span>
                  <span className="text-[9px] bg-[#FDE8B5] text-[#0D2C24] px-1.5 py-0.2 rounded font-mono font-bold">
                    RD 🇩🇴
                  </span>
                </div>
                <span className="text-[10px] text-emerald-200/70 dark:text-slate-400 block truncate">
                  Fe Notarial & Gestión Legal
                </span>
              </div>
            )}
          </div>

          {/* Desktop Collapse Toggle */}
          <button
            onClick={() => setIsCollapsed(!isCollapsed)}
            className="hidden lg:flex p-1.5 rounded-lg text-emerald-200/60 hover:text-white hover:bg-[#164E3E] dark:hover:bg-slate-800 transition-colors cursor-pointer"
            title={isCollapsed ? 'Expandir menú lateral' : 'Contraer menú lateral'}
          >
            {isCollapsed ? <ChevronRight className="w-4 h-4" /> : <ChevronLeft className="w-4 h-4" />}
          </button>
        </div>

        {/* Primary Call to Action */}
        <div className="p-3 border-b border-[#164E3E] dark:border-slate-800 space-y-2">
          <button
            onClick={() => navigateTo('DOCUMENTS')}
            className={`w-full flex items-center justify-center space-x-2 py-2.5 px-3 rounded-xl font-semibold text-xs transition-all shadow-md cursor-pointer ${
              state.currentView === 'DOCUMENTS'
                ? 'bg-[#FDE8B5] text-[#0D2C24] font-bold shadow-md ring-2 ring-[#C5A059]'
                : 'bg-[#164E3E] hover:bg-[#1C604D] text-white border border-[#2D7A64]'
            }`}
            title="Ver Contratos Finales Guardados"
          >
            <FileCheck2 className={`w-4 h-4 shrink-0 ${state.currentView === 'DOCUMENTS' ? 'text-[#0D2C24]' : 'text-[#FDE8B5]'}`} />
            {!isCollapsed && (
              <span className="truncate flex items-center justify-between w-full">
                <span>Contratos Finales</span>
                <span className={`text-[10px] px-1.5 py-0.5 rounded-full font-mono font-bold ${
                  state.currentView === 'DOCUMENTS' ? 'bg-[#0D2C24] text-[#FDE8B5]' : 'bg-[#0D2C24] text-white'
                }`}>
                  {finalDocsCount}
                </span>
              </span>
            )}
          </button>

          {!isCollapsed && (
            <div className="grid grid-cols-2 gap-1.5 pt-1">
              <button
                onClick={() => {
                  if (activeTemplate) {
                    navigateTo('FORM_GEN');
                  } else {
                    navigateTo('TEMPLATES');
                  }
                }}
                className="flex items-center justify-center space-x-1.5 py-1.5 px-2 bg-[#FDE8B5]/20 hover:bg-[#FDE8B5]/30 text-[#FDE8B5] border border-[#FDE8B5]/40 rounded-lg text-[11px] font-medium transition-colors cursor-pointer"
                title="Generar contrato desde plantilla"
              >
                <Sparkles className="w-3 h-3 text-[#FDE8B5]" />
                <span>Emitir Acto</span>
              </button>

              <button
                onClick={onOpenNewTemplateModal}
                className="flex items-center justify-center space-x-1.5 py-1.5 px-2 bg-[#164E3E] hover:bg-[#1C604D] text-white border border-[#2D7A64] rounded-lg text-[11px] font-medium transition-colors cursor-pointer"
                title="Crear nueva plantilla"
              >
                <Plus className="w-3 h-3 text-emerald-200" />
                <span>+ Plantilla</span>
              </button>
            </div>
          )}
        </div>

        {/* Scrollable Navigation Items */}
        <div className="flex-1 overflow-y-auto py-3 px-2 space-y-4 scrollbar-thin scrollbar-thumb-[#164E3E]">
          {/* SECTION 0: PÁGINAS PRINCIPALES */}
          <div>
            {!isCollapsed && (
              <div className="px-3 pb-1.5 text-[10px] font-bold uppercase tracking-wider text-emerald-200/60 dark:text-slate-400">
                General
              </div>
            )}
            <div className="space-y-1">
              <button
                onClick={() => navigateTo('WELCOME')}
                className={`w-full flex items-center space-x-3 px-3 py-2 rounded-xl text-xs font-medium transition-all cursor-pointer ${
                  state.currentView === 'WELCOME'
                    ? 'bg-[#FDE8B5] text-[#0D2C24] font-bold shadow-md'
                    : 'text-slate-200 hover:bg-[#164E3E] hover:text-white'
                }`}
                title="Página de Bienvenida"
              >
                <Home className={`w-4 h-4 shrink-0 ${state.currentView === 'WELCOME' ? 'text-[#0D2C24]' : 'text-emerald-300'}`} />
                {!isCollapsed && <span className="truncate">Bienvenida (Inicio)</span>}
              </button>

              <button
                onClick={() => navigateTo('PRICING')}
                className={`w-full flex items-center space-x-3 px-3 py-2 rounded-xl text-xs font-medium transition-all cursor-pointer ${
                  state.currentView === 'PRICING'
                    ? 'bg-[#FDE8B5] text-[#0D2C24] font-bold shadow-md'
                    : 'text-slate-200 hover:bg-[#164E3E] hover:text-white'
                }`}
                title="Opciones de Planes & Checkout"
              >
                <DollarSign className={`w-4 h-4 shrink-0 ${state.currentView === 'PRICING' ? 'text-[#0D2C24]' : 'text-[#FDE8B5]'}`} />
                {!isCollapsed && (
                  <div className="flex items-center justify-between flex-1 truncate">
                    <span className="truncate">Planes & Precios</span>
                    <span className="text-[10px] bg-[#C5A059]/30 text-[#FDE8B5] px-1.5 py-0.2 rounded font-mono">
                      $49+
                    </span>
                  </div>
                )}
              </button>
            </div>
          </div>

          {/* SECTION 1: CONTRATOS FINALES & EMISIÓN */}
          <div>
            {!isCollapsed && (
              <div className="px-3 pb-1.5 text-[10px] font-bold uppercase tracking-wider text-emerald-200/60 dark:text-slate-400">
                Contratos & Emisión
              </div>
            )}
            <div className="space-y-1">
              <button
                onClick={() => navigateTo('DOCUMENTS')}
                className={`w-full flex items-center space-x-3 px-3 py-2 rounded-xl text-xs font-medium transition-all cursor-pointer ${
                  state.currentView === 'DOCUMENTS'
                    ? 'bg-[#FDE8B5] text-[#0D2C24] font-bold shadow-md'
                    : 'text-slate-200 hover:bg-[#164E3E] hover:text-white'
                }`}
                title="Bóveda de Contratos Finales Guardados"
              >
                <FileCheck2 className={`w-4 h-4 shrink-0 ${state.currentView === 'DOCUMENTS' ? 'text-[#0D2C24]' : 'text-[#FDE8B5]'}`} />
                {!isCollapsed && (
                  <div className="flex items-center justify-between flex-1 truncate">
                    <span className="truncate">Bóveda de Contratos</span>
                    <span
                      className={`text-[10px] px-1.5 py-0.5 rounded-full font-mono font-bold ${
                        state.currentView === 'DOCUMENTS'
                          ? 'bg-[#0D2C24] text-[#FDE8B5]'
                          : 'bg-[#0D2C24] text-white border border-[#2D7A64]'
                      }`}
                    >
                      {finalDocsCount}
                    </span>
                  </div>
                )}
              </button>

              <button
                onClick={() => {
                  if (activeTemplate) {
                    navigateTo('FORM_GEN');
                  } else {
                    navigateTo('TEMPLATES');
                  }
                }}
                className={`w-full flex items-center space-x-3 px-3 py-2 rounded-xl text-xs font-medium transition-all cursor-pointer ${
                  state.currentView === 'FORM_GEN'
                    ? 'bg-[#FDE8B5] text-[#0D2C24] font-bold shadow-md'
                    : 'text-slate-200 hover:bg-[#164E3E] hover:text-white'
                }`}
                title="Generador de Contratos Finales"
              >
                <Sparkles className={`w-4 h-4 shrink-0 ${state.currentView === 'FORM_GEN' ? 'text-[#0D2C24]' : 'text-emerald-300'}`} />
                {!isCollapsed && <span className="truncate">Generador de Contratos</span>}
              </button>
            </div>
          </div>

          {/* SECTION 2: GESTIÓN DE PLANTILLAS */}
          <div>
            {!isCollapsed && (
              <div className="px-3 pb-1.5 text-[10px] font-bold uppercase tracking-wider text-emerald-200/60 dark:text-slate-400">
                Gestión de Plantillas
              </div>
            )}
            <div className="space-y-1">
              <button
                onClick={() => navigateTo('TEMPLATES')}
                className={`w-full flex items-center space-x-3 px-3 py-2 rounded-xl text-xs font-medium transition-all cursor-pointer ${
                  state.currentView === 'TEMPLATES'
                    ? 'bg-[#FDE8B5] text-[#0D2C24] font-bold shadow-md'
                    : 'text-slate-200 hover:bg-[#164E3E] hover:text-white'
                }`}
                title="Catálogo de Plantillas"
              >
                <Files className={`w-4 h-4 shrink-0 ${state.currentView === 'TEMPLATES' ? 'text-[#0D2C24]' : 'text-emerald-300'}`} />
                {!isCollapsed && (
                  <div className="flex items-center justify-between flex-1 truncate">
                    <span className="truncate">Catálogo Plantillas</span>
                    <span
                      className={`text-[10px] px-1.5 py-0.5 rounded-full font-mono ${
                        state.currentView === 'TEMPLATES'
                          ? 'bg-[#0D2C24] text-[#FDE8B5]'
                          : 'bg-[#164E3E] text-slate-300'
                      }`}
                    >
                      {templatesCount}
                    </span>
                  </div>
                )}
              </button>

              <button
                onClick={() => navigateTo('EDITOR')}
                className={`w-full flex items-center space-x-3 px-3 py-2 rounded-xl text-xs font-medium transition-all cursor-pointer ${
                  state.currentView === 'EDITOR'
                    ? 'bg-[#FDE8B5] text-[#0D2C24] font-bold shadow-md'
                    : 'text-slate-200 hover:bg-[#164E3E] hover:text-white'
                }`}
                title="Editor Notarial de Plantilla"
              >
                <PenTool className={`w-4 h-4 shrink-0 ${state.currentView === 'EDITOR' ? 'text-[#0D2C24]' : 'text-emerald-300'}`} />
                {!isCollapsed && <span className="truncate">Editor Notarial</span>}
              </button>

              <button
                onClick={() => navigateTo('VARIABLES')}
                className={`w-full flex items-center space-x-3 px-3 py-2 rounded-xl text-xs font-medium transition-all cursor-pointer ${
                  state.currentView === 'VARIABLES'
                    ? 'bg-[#FDE8B5] text-[#0D2C24] font-bold shadow-md'
                    : 'text-slate-200 hover:bg-[#164E3E] hover:text-white'
                }`}
                title="Variables y Campos"
              >
                <Sliders className={`w-4 h-4 shrink-0 ${state.currentView === 'VARIABLES' ? 'text-[#0D2C24]' : 'text-emerald-300'}`} />
                {!isCollapsed && (
                  <div className="flex items-center justify-between flex-1 truncate">
                    <span className="truncate">Variables & Cédulas</span>
                    {activeTemplate && (
                      <span className="text-[10px] text-emerald-200/70 font-mono">
                        {activeTemplate.variables.length}
                      </span>
                    )}
                  </div>
                )}
              </button>

              <button
                onClick={() => navigateTo('CLAUSES')}
                className={`w-full flex items-center space-x-3 px-3 py-2 rounded-xl text-xs font-medium transition-all cursor-pointer ${
                  state.currentView === 'CLAUSES'
                    ? 'bg-[#FDE8B5] text-[#0D2C24] font-bold shadow-md'
                    : 'text-slate-200 hover:bg-[#164E3E] hover:text-white'
                }`}
                title="Biblioteca de Cláusulas Dominicanas"
              >
                <BookOpen className={`w-4 h-4 shrink-0 ${state.currentView === 'CLAUSES' ? 'text-[#0D2C24]' : 'text-emerald-300'}`} />
                {!isCollapsed && <span className="truncate">Biblioteca Cláusulas</span>}
              </button>

              <button
                onClick={() => navigateTo('RULES')}
                className={`w-full flex items-center space-x-3 px-3 py-2 rounded-xl text-xs font-medium transition-all cursor-pointer ${
                  state.currentView === 'RULES'
                    ? 'bg-[#FDE8B5] text-[#0D2C24] font-bold shadow-md'
                    : 'text-slate-200 hover:bg-[#164E3E] hover:text-white'
                }`}
                title="Reglas Condicionales"
              >
                <GitFork className={`w-4 h-4 shrink-0 ${state.currentView === 'RULES' ? 'text-[#0D2C24]' : 'text-emerald-300'}`} />
                {!isCollapsed && <span className="truncate">Reglas Condicionales</span>}
              </button>

              {pendingHitlCount > 0 && (
                <button
                  onClick={() => navigateTo('HITL_REVIEW')}
                  className="w-full flex items-center space-x-3 px-3 py-2 rounded-xl text-xs font-medium transition-all bg-[#FDE8B5]/20 hover:bg-[#FDE8B5]/30 text-[#FDE8B5] border border-[#FDE8B5]/40 cursor-pointer"
                  title="Revisión Human-In-The-Loop"
                >
                  <Activity className="w-4 h-4 shrink-0 text-[#FDE8B5] animate-pulse" />
                  {!isCollapsed && (
                    <div className="flex items-center justify-between flex-1 truncate">
                      <span className="truncate">Tokens HITL</span>
                      <span className="bg-[#FDE8B5] text-[#0D2C24] text-[10px] px-1.5 py-0.2 rounded-full font-bold">
                        {pendingHitlCount}
                      </span>
                    </div>
                  )}
                </button>
              )}
            </div>
          </div>

          {/* SECTION 3: HERRAMIENTAS NOTARIALES */}
          <div>
            {!isCollapsed && (
              <div className="px-3 pb-1.5 text-[10px] font-bold uppercase tracking-wider text-emerald-200/60 dark:text-slate-400">
                Herramientas Notariales
              </div>
            )}
            <div className="space-y-1">
              <button
                onClick={onOpenHealthModal}
                className="w-full flex items-center space-x-3 px-3 py-2 rounded-xl text-xs font-medium text-slate-200 hover:bg-[#164E3E] hover:text-white transition-colors cursor-pointer"
                title="Diagnóstico de Salud de Plantilla"
              >
                <ShieldCheck className="w-4 h-4 shrink-0 text-emerald-300" />
                {!isCollapsed && <span className="truncate">Diagnóstico Legal</span>}
              </button>

              <button
                onClick={onOpenAuditModal}
                className="w-full flex items-center space-x-3 px-3 py-2 rounded-xl text-xs font-medium text-slate-200 hover:bg-[#164E3E] hover:text-white transition-colors cursor-pointer"
                title="Pistas de Auditoría Inmutable"
              >
                <History className="w-4 h-4 shrink-0 text-emerald-300" />
                {!isCollapsed && <span className="truncate">Pistas de Auditoría</span>}
              </button>

              <button
                onClick={onOpenDocxImportModal}
                className="w-full flex items-center space-x-3 px-3 py-2 rounded-xl text-xs font-medium text-slate-200 hover:bg-[#164E3E] hover:text-white transition-colors cursor-pointer"
                title="Importar Documento Word DOCX"
              >
                <Upload className="w-4 h-4 shrink-0 text-emerald-300" />
                {!isCollapsed && <span className="truncate">Importar DOCX</span>}
              </button>

              <button
                onClick={onOpenSchemaModal}
                className="w-full flex items-center space-x-3 px-3 py-2 rounded-xl text-xs font-medium text-slate-200 hover:bg-[#164E3E] hover:text-white transition-colors cursor-pointer"
                title="Ver Esquema JSON (schema.json)"
              >
                <Code2 className="w-4 h-4 shrink-0 text-emerald-300" />
                {!isCollapsed && <span className="truncate">Esquema JSON</span>}
              </button>
            </div>
          </div>
        </div>

        {/* Active Template Context Card */}
        {!isCollapsed && activeTemplate && (
          <div className="p-3 mx-3 mb-2 bg-[#164E3E]/60 rounded-xl border border-[#2D7A64]/60 text-xs">
            <div className="flex items-center justify-between text-[10px] text-emerald-200/70 mb-1">
              <span className="font-semibold uppercase tracking-wider text-[#FDE8B5]">Plantilla Activa</span>
              <span className="bg-[#0D2C24] text-white px-1.5 py-0.2 rounded font-mono font-medium">
                {activeTemplate.status}
              </span>
            </div>
            <h4 className="font-semibold text-white line-clamp-1 text-xs">
              {activeTemplate.name}
            </h4>
            <div className="flex items-center justify-between mt-2 pt-2 border-t border-[#164E3E] text-[11px]">
              <button
                onClick={() => navigateTo('EDITOR')}
                className="text-emerald-200 hover:text-white font-medium cursor-pointer"
              >
                Editar
              </button>
              <button
                onClick={() => navigateTo('FORM_GEN')}
                className="text-[#FDE8B5] hover:text-white font-bold cursor-pointer"
              >
                Generar Acto →
              </button>
            </div>
          </div>
        )}

        {/* Footer User Profile & Notary Card */}
        <div className="p-3 border-t border-[#164E3E] dark:border-slate-800 bg-[#08201A] dark:bg-slate-950/40 space-y-2">
          {/* Theme Mode Toggle Button */}
          <button
            onClick={toggleDarkMode}
            className="w-full flex items-center space-x-3 p-2 rounded-xl text-xs font-medium text-slate-200 hover:bg-[#164E3E] hover:text-white transition-colors cursor-pointer"
            title={isDarkMode ? 'Cambiar a Modo Claro' : 'Cambiar a Modo Oscuro'}
          >
            {isDarkMode ? (
              <Sun className="w-4 h-4 text-amber-400 shrink-0" />
            ) : (
              <Moon className="w-4 h-4 text-[#FDE8B5] shrink-0" />
            )}
            {!isCollapsed && (
              <span className="truncate">
                {isDarkMode ? 'Tema Claro' : 'Tema Oscuro'}
              </span>
            )}
          </button>

          <button
            onClick={onOpenProfileModal}
            className="w-full flex items-center space-x-3 p-2 rounded-xl hover:bg-[#164E3E] transition-colors text-left group cursor-pointer"
            title="Ver / Editar Perfil y Matrícula Notarial"
          >
            <div className="w-8 h-8 rounded-lg bg-[#FDE8B5] text-[#0D2C24] flex items-center justify-center font-bold text-xs shrink-0 shadow-xs group-hover:ring-2 group-hover:ring-white">
              {currentUser.name
                .split(' ')
                .map((n) => n[0])
                .slice(0, 2)
                .join('')}
            </div>

            {!isCollapsed && (
              <div className="flex-1 min-w-0">
                <div className="flex items-center justify-between">
                  <span className="text-xs font-semibold text-white truncate block">
                    {currentUser.name}
                  </span>
                </div>
                <div className="text-[10px] text-emerald-200/70 truncate flex items-center space-x-1">
                  <span className="text-[#FDE8B5] font-mono">CARD: {currentUser.cardRegistration}</span>
                </div>
              </div>
            )}
          </button>
        </div>
      </aside>
    </>
  );
};
