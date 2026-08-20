import React, { useState } from 'react';
import { useAppStore } from './store/useAppStore';
import { Sidebar } from './components/Sidebar';
import { TemplateList } from './components/TemplateList';
import { DocumentEditor } from './components/DocumentEditor';
import { VariableManager } from './components/VariableManager';
import { ClauseLibrary } from './components/ClauseLibrary';
import { RuleBuilder } from './components/RuleBuilder';
import { HITLReviewPanel } from './components/HITLReviewPanel';
import { DynamicFormGenerator } from './components/DynamicFormGenerator';
import { DocumentsVault } from './components/DocumentsVault';
import { WelcomePage } from './components/WelcomePage';
import { PricingPage } from './components/PricingPage';
import { HealthCheckModal } from './components/HealthCheckModal';
import { SchemaModal } from './components/SchemaModal';
import { DocxImportModal } from './components/DocxImportModal';
import { NewTemplateModal } from './components/NewTemplateModal';
import { VersionModal } from './components/VersionModal';
import { AuditLogModal } from './components/AuditLogModal';
import { UserProfileModal } from './components/UserProfileModal';
import {
  Menu,
  FileCheck2,
  Files,
  PenTool,
  Sliders,
  BookOpen,
  GitFork,
  Sparkles,
  ShieldCheck,
  User,
  ChevronRight,
  Plus,
  Scale,
  Sun,
  Moon,
} from 'lucide-react';

export function App() {
  const { state, setView, activeTemplate, currentUser, isDarkMode, toggleDarkMode } = useAppStore();

  // Modals state
  const [isNewTemplateOpen, setIsNewTemplateOpen] = useState(false);
  const [isDocxImportOpen, setIsDocxImportOpen] = useState(false);
  const [isHealthCheckOpen, setIsHealthCheckOpen] = useState(false);
  const [isSchemaOpen, setIsSchemaOpen] = useState(false);
  const [isVersionOpen, setIsVersionOpen] = useState(false);
  const [isAuditOpen, setIsAuditOpen] = useState(false);
  const [isProfileOpen, setIsProfileOpen] = useState(false);
  const [isMobileSidebarOpen, setIsMobileSidebarOpen] = useState(false);

  const getViewTitle = () => {
    switch (state.currentView) {
      case 'WELCOME':
        return {
          title: 'Bienvenido a SAVE',
          subtitle: 'Automatización Notarial y Legal de Alto Nivel para República Dominicana',
          icon: <Scale className="w-5 h-5 text-[#C5A059]" />,
        };
      case 'PRICING':
        return {
          title: 'Planes y Opciones de Suscripción',
          subtitle: 'Precios transparentes para equipos legales modernos',
          icon: <Scale className="w-5 h-5 text-[#0D2C24]" />,
        };
      case 'DOCUMENTS':
        return {
          title: 'Contratos Finales Guardados',
          subtitle: 'Bóveda inmutable de contratos y actos legales emitidos',
          icon: <FileCheck2 className="w-5 h-5 text-[#C5A059]" />,
        };
      case 'TEMPLATES':
        return {
          title: 'Catálogo de Plantillas',
          subtitle: 'Gestión y parametrización de plantillas notariales dominicanas',
          icon: <Files className="w-5 h-5 text-[#0D2C24] dark:text-emerald-400" />,
        };
      case 'EDITOR':
        return {
          title: activeTemplate ? activeTemplate.name : 'Editor de Plantillas',
          subtitle: 'Editor notarial estilo Word con previsualización formal',
          icon: <PenTool className="w-5 h-5 text-emerald-600" />,
        };
      case 'VARIABLES':
        return {
          title: 'Variables & Campos de Datos',
          subtitle: 'Validación de cédulas, montos en letras y datos de partes',
          icon: <Sliders className="w-5 h-5 text-[#0D2C24] dark:text-emerald-400" />,
        };
      case 'CLAUSES':
        return {
          title: 'Biblioteca de Cláusulas Dominicanas',
          subtitle: 'Depósitos, mora, jurisdicción y cláusulas estándar',
          icon: <BookOpen className="w-5 h-5 text-[#C5A059]" />,
        };
      case 'RULES':
        return {
          title: 'Reglas Condicionales',
          subtitle: 'Automatización lógica de inclusión y exclusión de cláusulas',
          icon: <GitFork className="w-5 h-5 text-[#0D2C24] dark:text-emerald-400" />,
        };
      case 'FORM_GEN':
        return {
          title: 'Generador de Contratos Finales',
          subtitle: 'Diligenciamiento de datos y emisión de documento final',
          icon: <Sparkles className="w-5 h-5 text-[#C5A059]" />,
        };
      case 'HITL_REVIEW':
        return {
          title: 'Revisión Human-In-The-Loop',
          subtitle: 'Aprobación y fusión de tokens detectados con IA',
          icon: <ShieldCheck className="w-5 h-5 text-[#0D2C24] dark:text-emerald-400" />,
        };
      default:
        return {
          title: 'Plataforma Legal Notarial',
          subtitle: 'República Dominicana',
          icon: <Scale className="w-5 h-5 text-[#0D2C24]" />,
        };
    }
  };

  const currentViewInfo = getViewTitle();

  const isFullPageView = state.currentView === 'WELCOME' || state.currentView === 'PRICING';

  return (
    <div className="min-h-screen bg-slate-100 dark:bg-slate-950 flex font-sans text-slate-900 dark:text-slate-100 selection:bg-emerald-200 dark:selection:bg-emerald-900">
      {/* LATERAL SIDEBAR MENU */}
      {!isFullPageView && (
        <Sidebar
          onOpenNewTemplateModal={() => setIsNewTemplateOpen(true)}
          onOpenDocxImportModal={() => setIsDocxImportOpen(true)}
          onOpenHealthModal={() => setIsHealthCheckOpen(true)}
          onOpenSchemaModal={() => setIsSchemaOpen(true)}
          onOpenProfileModal={() => setIsProfileOpen(true)}
          onOpenAuditModal={() => setIsAuditOpen(true)}
          isMobileOpen={isMobileSidebarOpen}
          setIsMobileOpen={setIsMobileSidebarOpen}
        />
      )}

      {/* MAIN CONTENT WRAPPER */}
      <div className={`flex-1 flex flex-col min-w-0 min-h-screen ${isFullPageView ? '' : ''}`}>
        {/* Compact Top App Bar */}
        {!isFullPageView && (
          <header className="sticky top-0 z-30 bg-white/95 dark:bg-slate-900/95 backdrop-blur-md border-b border-slate-200/80 dark:border-slate-800 px-4 sm:px-6 py-2.5 flex items-center justify-between shadow-2xs">
          <div className="flex items-center space-x-3 min-w-0">
            {/* Mobile Sidebar Toggle Button */}
            <button
              onClick={() => setIsMobileSidebarOpen(true)}
              className="lg:hidden p-2 rounded-xl text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 hover:text-slate-900 dark:hover:text-white transition-colors"
              title="Abrir menú lateral"
            >
              <Menu className="w-5 h-5" />
            </button>

            {/* Breadcrumb / Current View Info */}
            <div className="flex items-center space-x-2.5 min-w-0">
              <div className="p-1.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-lg hidden sm:flex items-center justify-center shrink-0">
                {currentViewInfo.icon}
              </div>
              <div className="min-w-0">
                <h2 className="text-sm sm:text-base font-bold text-slate-900 dark:text-white font-serif truncate leading-tight">
                  {currentViewInfo.title}
                </h2>
                <p className="text-[11px] text-slate-500 dark:text-slate-400 truncate hidden md:block">
                  {currentViewInfo.subtitle}
                </p>
              </div>
            </div>
          </div>

          {/* Top Right Quick Actions */}
          <div className="flex items-center space-x-2 sm:space-x-2.5 shrink-0">
            {/* Dark / Light Mode Switch Button */}
            <button
              onClick={toggleDarkMode}
              className="flex items-center space-x-1.5 px-2.5 sm:px-3 py-1.5 rounded-xl text-xs font-semibold bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 border border-slate-200 dark:border-slate-700 shadow-2xs transition-all"
              title={isDarkMode ? 'Cambiar a Modo Claro' : 'Cambiar a Modo Oscuro'}
            >
              {isDarkMode ? (
                <>
                  <Sun className="w-4 h-4 text-amber-400 shrink-0" />
                  <span className="hidden sm:inline">Modo Claro</span>
                </>
              ) : (
                <>
                  <Moon className="w-4 h-4 text-slate-600 dark:text-slate-300 shrink-0" />
                  <span className="hidden sm:inline">Modo Oscuro</span>
                </>
              )}
            </button>

            {/* Direct Shortcut to Final Contracts Vault */}
            <button
              onClick={() => setView('DOCUMENTS')}
              className={`flex items-center space-x-1.5 px-3 py-1.5 rounded-xl text-xs font-semibold transition-all cursor-pointer ${
                state.currentView === 'DOCUMENTS'
                  ? 'bg-[#0D2C24] dark:bg-emerald-600 text-white font-bold shadow-xs'
                  : 'bg-[#F5F2ED] dark:bg-slate-800 hover:bg-[#E8E5DF] dark:hover:bg-slate-700 text-[#0D2C24] dark:text-emerald-400 border border-[#D1CCC4] dark:border-slate-700'
              }`}
              title="Ver Bóveda de Contratos Finales"
            >
              <FileCheck2 className="w-4 h-4 text-[#C5A059]" />
              <span className="hidden sm:inline">Contratos Finales</span>
              <span className="bg-[#0D2C24]/10 dark:bg-emerald-950 text-[#0D2C24] dark:text-emerald-300 text-[10px] px-1.5 py-0.2 rounded-full font-mono font-bold">
                {state.generatedDocuments.length}
              </span>
            </button>

            {/* Active Template Badge (if any) */}
            {activeTemplate && state.currentView !== 'DOCUMENTS' && (
              <button
                onClick={() => setView('EDITOR')}
                className="hidden lg:flex items-center space-x-1.5 px-2.5 py-1 bg-[#F5F2ED] dark:bg-slate-800 hover:bg-[#E8E5DF] dark:hover:bg-slate-700 border border-[#D1CCC4] dark:border-slate-700 rounded-xl text-xs font-medium text-[#0D2C24] dark:text-emerald-400 transition-colors"
                title={`Plantilla activa: ${activeTemplate.name}`}
              >
                <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse" />
                <span className="truncate max-w-[150px] font-semibold">{activeTemplate.name}</span>
              </button>
            )}

            {/* User Profile Quick Trigger */}
            <button
              onClick={() => setIsProfileOpen(true)}
              className="flex items-center space-x-2 p-1 sm:px-2.5 sm:py-1 rounded-xl bg-[#F5F2ED] dark:bg-slate-800 hover:bg-[#E8E5DF] dark:hover:bg-slate-700 text-[#0D2C24] dark:text-slate-200 transition-colors text-xs font-medium border border-[#D1CCC4] dark:border-slate-700 cursor-pointer"
              title="Gestionar perfil de Notario / Abogado"
            >
              <div className="w-6 h-6 rounded-md bg-[#0D2C24] dark:bg-emerald-600 flex items-center justify-center text-white text-[11px] font-bold">
                {currentUser.name
                  .split(' ')
                  .map((n) => n[0])
                  .slice(0, 2)
                  .join('')}
              </div>
              <span className="hidden md:inline font-semibold text-[#0D2C24] dark:text-slate-200">{currentUser.name}</span>
            </button>
          </div>
        </header>
        )}

        {/* Main View Router */}
        <main className="flex-1 flex flex-col overflow-y-auto">
          {state.currentView === 'WELCOME' && <WelcomePage />}

          {state.currentView === 'PRICING' && <PricingPage />}

          {state.currentView === 'DOCUMENTS' && <DocumentsVault />}

          {state.currentView === 'TEMPLATES' && (
            <TemplateList
              onOpenNewTemplateModal={() => setIsNewTemplateOpen(true)}
              onOpenDocxImportModal={() => setIsDocxImportOpen(true)}
            />
          )}

          {state.currentView === 'EDITOR' && (
            <DocumentEditor
              onOpenHealthModal={() => setIsHealthCheckOpen(true)}
              onOpenVersionModal={() => setIsVersionOpen(true)}
            />
          )}

          {state.currentView === 'VARIABLES' && <VariableManager />}

          {state.currentView === 'CLAUSES' && <ClauseLibrary />}

          {state.currentView === 'RULES' && <RuleBuilder />}

          {state.currentView === 'HITL_REVIEW' && <HITLReviewPanel />}

          {state.currentView === 'FORM_GEN' && <DynamicFormGenerator />}
        </main>
      </div>

      {/* Modals */}
      <UserProfileModal
        isOpen={isProfileOpen}
        onClose={() => setIsProfileOpen(false)}
      />

      <NewTemplateModal
        isOpen={isNewTemplateOpen}
        onClose={() => setIsNewTemplateOpen(false)}
      />

      <DocxImportModal
        isOpen={isDocxImportOpen}
        onClose={() => setIsDocxImportOpen(false)}
      />

      <HealthCheckModal
        isOpen={isHealthCheckOpen}
        onClose={() => setIsHealthCheckOpen(false)}
      />

      <SchemaModal
        isOpen={isSchemaOpen}
        onClose={() => setIsSchemaOpen(false)}
      />

      <VersionModal
        isOpen={isVersionOpen}
        onClose={() => setIsVersionOpen(false)}
      />

      <AuditLogModal
        isOpen={isAuditOpen}
        onClose={() => setIsAuditOpen(false)}
      />
    </div>
  );
}

export default App;
