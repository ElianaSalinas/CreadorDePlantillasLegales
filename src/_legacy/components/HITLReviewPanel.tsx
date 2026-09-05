import React, { useState } from 'react';
import {
  Sparkles,
  CheckCircle2,
  XCircle,
  Merge,
  ArrowRight,
  ShieldCheck,
  Check,
  X,
  Edit2,
  FileText,
  AlertCircle,
} from 'lucide-react';
import { useAppStore } from '../store/useAppStore';
import { DetectedToken, TemplateCategory } from '../types';
import { normalizeVariableTag } from '../core/variableEngine';

export const HITLReviewPanel: React.FC = () => {
  const {
    state,
    acceptHitlToken,
    rejectHitlToken,
    mergeHitlTokens,
    commitHitlToTemplate,
    setView,
  } = useAppStore();

  const [templateName, setTemplateName] = useState('Contrato Parametrizado');
  const [templateCategory, setTemplateCategory] = useState<TemplateCategory>('Inmobiliario');
  const [editingTokenId, setEditingTokenId] = useState<string | null>(null);
  const [editedTag, setEditedTag] = useState('');
  const [selectedForMerge, setSelectedForMerge] = useState<string[]>([]);

  const tokens = state.hitlTokens;
  const originalText = state.hitlOriginalText;

  if (tokens.length === 0 && !originalText) {
    return (
      <div className="max-w-4xl mx-auto py-16 text-center">
        <p className="text-slate-500 dark:text-slate-400">No hay sesiones activas de revisión Human-in-the-Loop.</p>
        <button
          onClick={() => setView('TEMPLATES')}
          className="mt-4 px-4 py-2 bg-[#0D2C24] hover:bg-[#164E3E] text-white text-xs font-semibold rounded-xl cursor-pointer"
        >
          Volver al Catálogo
        </button>
      </div>
    );
  }

  const acceptedCount = tokens.filter((t) => t.status === 'ACEPTADA' || t.status === 'FUSIONADA').length;
  const pendingCount = tokens.filter((t) => t.status === 'PENDIENTE').length;

  const handleAcceptAll = () => {
    tokens.forEach((t) => {
      if (t.status === 'PENDIENTE') {
        acceptHitlToken(t.id);
      }
    });
  };

  const handleRejectAll = () => {
    tokens.forEach((t) => {
      if (t.status === 'PENDIENTE') {
        rejectHitlToken(t.id);
      }
    });
  };

  const handleStartEditTag = (token: DetectedToken) => {
    setEditingTokenId(token.id);
    setEditedTag(token.tag);
  };

  const handleSaveEditTag = (token: DetectedToken) => {
    acceptHitlToken(token.id, normalizeVariableTag(editedTag));
    setEditingTokenId(null);
  };

  const handleToggleMergeSelection = (tokenId: string) => {
    if (selectedForMerge.includes(tokenId)) {
      setSelectedForMerge(selectedForMerge.filter((id) => id !== tokenId));
    } else {
      setSelectedForMerge([...selectedForMerge, tokenId]);
    }
  };

  const handleExecuteMerge = () => {
    if (selectedForMerge.length < 2) {
      alert('Selecciona al menos 2 variables para fusionar.');
      return;
    }
    const [target, ...sources] = selectedForMerge;
    mergeHitlTokens(target, sources);
    setSelectedForMerge([]);
  };

  const handleCommit = () => {
    commitHitlToTemplate(templateName, templateCategory);
  };

  return (
    <div className="h-[calc(100vh-4rem)] flex flex-col bg-[#F5F2ED] dark:bg-slate-950 overflow-hidden">
      {/* Top Action & Status Bar */}
      <div className="bg-white dark:bg-slate-900 border-b border-[#E8E5DF] dark:border-slate-800 px-6 py-3.5 flex flex-wrap items-center justify-between gap-4 shrink-0 shadow-xs">
        <div>
          <div className="flex items-center space-x-2">
            <span className="text-xs font-bold uppercase tracking-wider text-[#0D2C24] dark:text-emerald-400 bg-[#F5F2ED] dark:bg-slate-800 px-2.5 py-0.5 rounded-md border border-[#E8E5DF] dark:border-slate-700 flex items-center space-x-1">
              <Sparkles className="w-3.5 h-3.5 text-[#C5A059]" />
              <span>Revisión Human-in-the-Loop (US-42..US-46)</span>
            </span>
            <span className="text-xs text-slate-500 dark:text-slate-400">
              {acceptedCount} de {tokens.length} variables confirmadas
            </span>
          </div>
          <h2 className="text-lg font-serif font-bold text-slate-900 dark:text-white mt-0.5">
            Verificación y Aprobación de Detección Automática
          </h2>
        </div>

        {/* Global actions */}
        <div className="flex items-center space-x-2">
          {selectedForMerge.length >= 2 && (
            <button
              onClick={handleExecuteMerge}
              className="px-3 py-1.5 rounded-xl text-xs font-bold bg-[#0D2C24] hover:bg-[#164E3E] text-[#FDE8B5] shadow-xs flex items-center space-x-1 cursor-pointer"
            >
              <Merge className="w-3.5 h-3.5" />
              <span>Fusionar Seleccionadas ({selectedForMerge.length})</span>
            </button>
          )}

          <button
            onClick={handleAcceptAll}
            className="px-3 py-1.5 rounded-xl text-xs font-semibold bg-[#F5F2ED] dark:bg-slate-800 hover:bg-[#E8E5DF] dark:hover:bg-slate-700 text-slate-700 dark:text-slate-300 transition-colors cursor-pointer"
          >
            Aceptar Todas
          </button>

          <button
            onClick={handleRejectAll}
            className="px-3 py-1.5 rounded-xl text-xs font-semibold bg-[#F5F2ED] dark:bg-slate-800 hover:bg-[#E8E5DF] dark:hover:bg-slate-700 text-slate-700 dark:text-slate-300 transition-colors cursor-pointer"
          >
            Rechazar Todas
          </button>

          <button
            onClick={handleCommit}
            className="px-4 py-2 rounded-xl text-xs font-bold bg-[#0D2C24] hover:bg-[#164E3E] text-white shadow-sm flex items-center space-x-1.5 transition-all cursor-pointer"
          >
            <Check className="w-4 h-4 text-[#FDE8B5]" />
            <span>Confirmar e Incorporar a Plantilla</span>
          </button>
        </div>
      </div>

      {/* Split Screen Workspace */}
      <div className="flex-1 flex overflow-hidden">
        {/* Left Side: Original Text with Highlights */}
        <div className="w-1/2 h-full flex flex-col bg-white dark:bg-slate-900 border-r border-[#E8E5DF] dark:border-slate-800">
          <div className="p-3 bg-[#F5F2ED]/70 dark:bg-slate-800/80 border-b border-[#E8E5DF] dark:border-slate-800 text-xs font-semibold text-slate-700 dark:text-slate-200 flex items-center justify-between">
            <span className="flex items-center space-x-1.5">
              <FileText className="w-3.5 h-3.5 text-[#0D2C24] dark:text-emerald-400" />
              <span>Documento Original Importado</span>
            </span>
            <span className="text-[11px] text-slate-400 font-mono">{originalText.length} caracteres</span>
          </div>

          <div className="flex-1 p-6 overflow-y-auto font-serif text-sm leading-relaxed text-slate-800 dark:text-slate-200 whitespace-pre-wrap selection:bg-[#FDE8B5] selection:text-[#0D2C24]">
            {originalText}
          </div>
        </div>

        {/* Right Side: Detected Tokens Verification List */}
        <div className="w-1/2 h-full flex flex-col bg-[#FAFAF8] dark:bg-slate-950">
          <div className="p-3 bg-[#F5F2ED] dark:bg-slate-900 border-b border-[#E8E5DF] dark:border-slate-800 text-xs font-semibold text-slate-700 dark:text-slate-200 flex items-center justify-between">
            <span className="flex items-center space-x-1.5">
              <ShieldCheck className="w-3.5 h-3.5 text-[#C5A059]" />
              <span>Variables Detectadas para Aprobación ({tokens.length})</span>
            </span>
            <span className="text-[11px] text-[#0D2C24] dark:text-emerald-400 font-medium">Validadores Dominicanos Activos 🇩🇴</span>
          </div>

          <div className="flex-1 p-4 overflow-y-auto space-y-3">
            {tokens.length === 0 ? (
              <div className="p-8 text-center text-slate-400 text-xs">
                No se detectaron variables en el texto proporcionado.
              </div>
            ) : (
              tokens.map((token) => {
                const isSelectedForMerge = selectedForMerge.includes(token.id);

                return (
                  <div
                    key={token.id}
                    className={`p-4 rounded-xl border transition-all ${
                      token.status === 'ACEPTADA' || token.status === 'MODIFICADA'
                        ? 'bg-emerald-50/40 dark:bg-emerald-950/20 border-emerald-300 dark:border-emerald-800'
                        : token.status === 'RECHAZADA'
                        ? 'bg-slate-100/60 dark:bg-slate-900/60 border-slate-200 dark:border-slate-800 opacity-60'
                        : token.status === 'FUSIONADA'
                        ? 'bg-[#FDE8B5]/30 border-[#C5A059]'
                        : 'bg-white dark:bg-slate-900 border-[#E8E5DF] dark:border-slate-800 shadow-xs'
                    }`}
                  >
                    <div className="flex items-start justify-between gap-3">
                      <div className="space-y-1 flex-1">
                        {/* Token Header */}
                        <div className="flex items-center space-x-2 flex-wrap">
                          {editingTokenId === token.id ? (
                            <div className="flex items-center space-x-1">
                              <input
                                type="text"
                                value={editedTag}
                                onChange={(e) => setEditedTag(e.target.value)}
                                className="font-mono text-xs px-2 py-0.5 border border-[#0D2C24] rounded-lg bg-white dark:bg-slate-800 dark:text-white"
                              />
                              <button
                                onClick={() => handleSaveEditTag(token)}
                                className="p-1 bg-[#0D2C24] text-white rounded-lg hover:bg-[#164E3E]"
                              >
                                <Check className="w-3 h-3 text-[#FDE8B5]" />
                              </button>
                            </div>
                          ) : (
                            <span className="font-mono font-bold text-xs text-[#0D2C24] dark:text-emerald-400 bg-[#F5F2ED] dark:bg-slate-800 px-2 py-0.5 rounded border border-[#E8E5DF] dark:border-slate-700">
                              {`{{${token.tag}}}`}
                            </span>
                          )}

                          <span className="text-[10px] px-2 py-0.5 rounded bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 font-mono">
                            {token.dataType}
                          </span>

                          <span
                            className={`text-[10px] px-2 py-0.5 rounded-full font-bold ${
                              token.confidence >= 0.85
                                ? 'bg-emerald-100 dark:bg-emerald-950 text-emerald-800 dark:text-emerald-300'
                                : token.confidence >= 0.6
                                ? 'bg-amber-100 dark:bg-amber-950 text-amber-800 dark:text-amber-300'
                                : 'bg-rose-100 dark:bg-rose-950 text-rose-800 dark:text-rose-300'
                            }`}
                          >
                            {Math.round(token.confidence * 100)}% confianza
                          </span>

                          <span
                            className={`text-[10px] font-bold uppercase ${
                              token.status === 'ACEPTADA'
                                ? 'text-emerald-600 dark:text-emerald-400'
                                : token.status === 'RECHAZADA'
                                ? 'text-slate-400 line-through'
                                : token.status === 'FUSIONADA'
                                ? 'text-[#C5A059]'
                                : 'text-amber-600'
                            }`}
                          >
                            {token.status}
                          </span>
                        </div>

                        {/* Extracted value preview */}
                        <div className="text-xs text-slate-700 dark:text-slate-300 font-serif bg-[#F5F2ED]/60 dark:bg-slate-800 p-2 rounded-lg border border-[#E8E5DF] dark:border-slate-700">
                          Texto detectado: <strong className="text-slate-900 dark:text-white font-sans">"{token.originalValue}"</strong>
                        </div>
                      </div>

                      {/* Token Actions */}
                      <div className="flex items-center space-x-1 shrink-0">
                        <button
                          onClick={() => handleToggleMergeSelection(token.id)}
                          className={`p-1.5 rounded-md transition-colors ${
                            isSelectedForMerge
                              ? 'bg-[#0D2C24] text-[#FDE8B5]'
                              : 'text-slate-400 hover:text-[#0D2C24] dark:hover:text-emerald-400 hover:bg-[#F5F2ED] dark:hover:bg-slate-800'
                          }`}
                          title="Seleccionar para fusión con otra variable (US-45)"
                        >
                          <Merge className="w-3.5 h-3.5" />
                        </button>

                        <button
                          onClick={() => handleStartEditTag(token)}
                          className="p-1.5 text-slate-400 hover:text-slate-700 dark:hover:text-white hover:bg-[#F5F2ED] dark:hover:bg-slate-800 rounded-md transition-colors"
                          title="Editar Identificador Tag (US-44)"
                        >
                          <Edit2 className="w-3.5 h-3.5" />
                        </button>

                        {token.status !== 'ACEPTADA' && (
                          <button
                            onClick={() => acceptHitlToken(token.id)}
                            className="p-1.5 text-slate-400 hover:text-emerald-600 hover:bg-emerald-50 rounded-md transition-colors"
                            title="Aceptar variable"
                          >
                            <CheckCircle2 className="w-4 h-4" />
                          </button>
                        )}

                        {token.status !== 'RECHAZADA' && (
                          <button
                            onClick={() => rejectHitlToken(token.id)}
                            className="p-1.5 text-slate-400 hover:text-rose-600 hover:bg-rose-50 rounded-md transition-colors"
                            title="Rechazar variable"
                          >
                            <XCircle className="w-4 h-4" />
                          </button>
                        )}
                      </div>
                    </div>
                  </div>
                );
              })
            )}
          </div>
        </div>
      </div>
    </div>
  );
};
