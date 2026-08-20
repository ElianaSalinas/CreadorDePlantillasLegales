import { useState, useEffect } from 'react';
import {
  LegalTemplate,
  TemplateStatus,
  TemplateVariable,
  LegalClause,
  ConditionalRule,
  AuditLogEntry,
  GeneratedDocument,
  DetectedToken,
  TemplateCategory,
  UserProfile,
  UserRole,
} from '../types';
import { INITIAL_TEMPLATES, INITIAL_GENERATED_DOCUMENTS } from '../core/sampleData';
import { DEFAULT_DOMINICAN_CLAUSES } from '../core/clauseEngine';
import { normalizeVariableTag } from '../core/variableEngine';
import { runTemplateHealthCheck } from '../core/healthCheck';
import { LAWYER_DEFAULT_PROFILE, AVAILABLE_PROFILES, ROLE_PERMISSIONS } from '../core/userProfiles';

const STORAGE_KEY = 'save_legal_platform_v2_state';

export interface AppState {
  currentUser: UserProfile;
  templates: LegalTemplate[];
  activeTemplateId: string | null;
  currentView:
    | 'WELCOME'
    | 'PRICING'
    | 'TEMPLATES'
    | 'EDITOR'
    | 'VARIABLES'
    | 'CLAUSES'
    | 'RULES'
    | 'HITL_REVIEW'
    | 'FORM_GEN'
    | 'DOCUMENTS'
    | 'AUDIT'
    | 'HEALTH_CHECK';
  globalClauses: LegalClause[];
  auditLogs: AuditLogEntry[];
  generatedDocuments: GeneratedDocument[];
  hitlTokens: DetectedToken[];
  hitlOriginalText: string;
  hitlTemplateId: string | null;
  formValues: Record<string, any>;
  isAnalyzing: boolean;
  isDarkMode: boolean;
}

function loadInitialState(): AppState {
  try {
    const saved = localStorage.getItem(STORAGE_KEY);
    if (saved) {
      const parsed = JSON.parse(saved);
      const isDark = parsed.isDarkMode !== undefined ? parsed.isDarkMode : false;
      if (typeof document !== 'undefined') {
        if (isDark) {
          document.documentElement.classList.add('dark');
        } else {
          document.documentElement.classList.remove('dark');
        }
      }
      return {
        ...parsed,
        currentUser: parsed.currentUser || LAWYER_DEFAULT_PROFILE,
        generatedDocuments: (parsed.generatedDocuments && parsed.generatedDocuments.length > 0)
          ? parsed.generatedDocuments
          : INITIAL_GENERATED_DOCUMENTS,
        isAnalyzing: false,
        isDarkMode: isDark,
      };
    }
  } catch (e) {
    console.error('Error loading state from localStorage:', e);
  }

  return {
    currentUser: LAWYER_DEFAULT_PROFILE,
    templates: INITIAL_TEMPLATES,
    activeTemplateId: INITIAL_TEMPLATES[0].id,
    currentView: 'WELCOME',
    globalClauses: DEFAULT_DOMINICAN_CLAUSES,
    auditLogs: [
      {
        id: 'aud_init_1',
        timestamp: '2026-08-15T05:30:00Z',
        user: `${LAWYER_DEFAULT_PROFILE.name} (${LAWYER_DEFAULT_PROFILE.cardRegistration})`,
        action: 'CREATE_TEMPLATE',
        targetType: 'TEMPLATE',
        targetId: 'tpl_alquiler_residencial_rd',
        details: 'Plantilla de Alquiler Residencial inicializada con validadores dominicanos',
      },
    ],
    generatedDocuments: INITIAL_GENERATED_DOCUMENTS,
    hitlTokens: [],
    hitlOriginalText: '',
    hitlTemplateId: null,
    formValues: {},
    isAnalyzing: false,
    isDarkMode: false,
  };
}

// Global hook & reactive manager
let globalState: AppState = loadInitialState();
const listeners = new Set<() => void>();

function notify() {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(globalState));
  } catch (e) {
    console.error('Failed to save to localStorage:', e);
  }
  listeners.forEach((l) => l());
}

export function useAppStore() {
  const [state, setState] = useState<AppState>(globalState);

  useEffect(() => {
    const listener = () => setState({ ...globalState });
    listeners.add(listener);
    return () => {
      listeners.delete(listener);
    };
  }, []);

  const getActiveTemplate = (): LegalTemplate | undefined => {
    return globalState.templates.find((t) => t.id === globalState.activeTemplateId);
  };

  const recordAudit = (
    action: AuditLogEntry['action'],
    targetType: AuditLogEntry['targetType'],
    targetId: string,
    details: string,
    previousValue?: any,
    newValue?: any
  ) => {
    const userDisplay = `${globalState.currentUser.name} (${globalState.currentUser.cardRegistration || globalState.currentUser.role})`;
    const newEntry: AuditLogEntry = {
      id: `aud_${Date.now()}_${Math.random().toString(36).substr(2, 4)}`,
      timestamp: new Date().toISOString(),
      user: userDisplay,
      action,
      targetType,
      targetId,
      details,
      previousValue,
      newValue,
    };
    globalState.auditLogs = [newEntry, ...globalState.auditLogs].slice(0, 200);
    notify();
  };

  const switchUserRole = (role: UserRole) => {
    const targetProfile = AVAILABLE_PROFILES[role] || {
      ...LAWYER_DEFAULT_PROFILE,
      role,
      permissions: ROLE_PERMISSIONS[role],
    };
    globalState.currentUser = {
      ...targetProfile,
      permissions: ROLE_PERMISSIONS[role],
    };
    recordAudit('UPDATE_TEMPLATE', 'TEMPLATE', 'user_role_switch', `Perfil de usuario cambiado a rol: ${role} (${targetProfile.name})`);
    notify();
  };

  const updateUserProfile = (updates: Partial<UserProfile>) => {
    globalState.currentUser = {
      ...globalState.currentUser,
      ...updates,
      permissions: updates.role ? ROLE_PERMISSIONS[updates.role] : globalState.currentUser.permissions,
    };
    recordAudit('UPDATE_TEMPLATE', 'TEMPLATE', 'user_profile_update', `Credenciales de abogado actualizadas: ${globalState.currentUser.name}`);
    notify();
  };

  const setView = (view: AppState['currentView']) => {
    globalState.currentView = view;
    notify();
  };

  const setActiveTemplateId = (id: string | null) => {
    globalState.activeTemplateId = id;
    if (id) {
      const t = globalState.templates.find((tpl) => tpl.id === id);
      if (t) {
        // Preset default form values
        const initialForm: Record<string, any> = {};
        t.variables.forEach((v) => {
          if (v.defaultValue !== undefined) {
            initialForm[v.tag] = v.defaultValue;
          }
        });
        globalState.formValues = initialForm;
      }
    }
    notify();
  };

  const createTemplate = (data: {
    name: string;
    description: string;
    category: TemplateCategory;
    content?: string;
    variables?: TemplateVariable[];
    clauses?: LegalClause[];
  }): string => {
    const newId = `tpl_${Date.now()}`;
    const authorName = `${globalState.currentUser.name} (${globalState.currentUser.cardRegistration})`;
    const newTemplate: LegalTemplate = {
      id: newId,
      name: data.name || 'Nueva Plantilla Legal',
      description: data.description || '',
      category: data.category || 'Inmobiliario',
      jurisdiction: 'República Dominicana',
      version: '1.0',
      status: 'DRAFT',
      content: data.content || '',
      variables: data.variables || [],
      clauses: data.clauses || [DEFAULT_DOMINICAN_CLAUSES[3]], // default jurisdiction
      rules: [],
      versions: [
        {
          version: '1.0',
          createdAt: new Date().toISOString(),
          createdBy: authorName,
          description: 'Creación inicial de la plantilla',
          content: data.content || '',
          variables: data.variables || [],
          clauses: data.clauses || [],
          rules: [],
        },
      ],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      author: authorName,
    };

    globalState.templates = [newTemplate, ...globalState.templates];
    globalState.activeTemplateId = newId;
    recordAudit('CREATE_TEMPLATE', 'TEMPLATE', newId, `Plantilla creada: ${newTemplate.name}`);
    notify();
    return newId;
  };

  const updateTemplate = (id: string, updates: Partial<LegalTemplate>) => {
    const prev = globalState.templates.find((t) => t.id === id);
    globalState.templates = globalState.templates.map((t) => {
      if (t.id === id) {
        return {
          ...t,
          ...updates,
          updatedAt: new Date().toISOString(),
        };
      }
      return t;
    });
    recordAudit('UPDATE_TEMPLATE', 'TEMPLATE', id, `Plantilla actualizada: ${updates.name || prev?.name || id}`);
    notify();
  };

  const duplicateTemplate = (id: string) => {
    const source = globalState.templates.find((t) => t.id === id);
    if (!source) return;

    const newId = `tpl_${Date.now()}`;
    const duplicated: LegalTemplate = {
      ...source,
      id: newId,
      name: `${source.name} (Copia)`,
      status: 'DRAFT',
      version: '1.0',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };

    globalState.templates = [duplicated, ...globalState.templates];
    globalState.activeTemplateId = newId;
    recordAudit('CREATE_TEMPLATE', 'TEMPLATE', newId, `Plantilla duplicada desde: ${source.name}`);
    notify();
  };

  const changeTemplateStatus = (id: string, newStatus: TemplateStatus): { success: boolean; error?: string } => {
    const tpl = globalState.templates.find((t) => t.id === id);
    if (!tpl) return { success: false, error: 'Plantilla no encontrada' };

    // If publishing, run Health Check first (RN-003, RN-071)
    if (newStatus === 'PUBLISHED') {
      const health = runTemplateHealthCheck(tpl);
      if (!health.canPublish) {
        return {
          success: false,
          error: `No se puede publicar la plantilla debido a errores críticos: ${health.errors.join('; ')}`,
        };
      }
    }

    updateTemplate(id, { status: newStatus });
    recordAudit('PUBLISH_TEMPLATE', 'TEMPLATE', id, `Estado cambiado a ${newStatus}`);
    return { success: true };
  };

  const deleteTemplate = (id: string) => {
    const prev = globalState.templates.find((t) => t.id === id);
    globalState.templates = globalState.templates.filter((t) => t.id !== id);
    if (globalState.activeTemplateId === id) {
      globalState.activeTemplateId = globalState.templates[0]?.id || null;
    }
    recordAudit('UPDATE_TEMPLATE', 'TEMPLATE', id, `Plantilla eliminada: ${prev?.name || id}`);
    notify();
  };

  const addVariable = (templateId: string, variable: TemplateVariable) => {
    const tpl = globalState.templates.find((t) => t.id === templateId);
    if (!tpl) return;

    const normalizedTag = normalizeVariableTag(variable.tag);
    if (tpl.variables.some((v) => v.tag === normalizedTag)) {
      alert(`La variable con identificador "${normalizedTag}" ya existe.`);
      return;
    }

    const newVar = { ...variable, tag: normalizedTag };
    updateTemplate(templateId, {
      variables: [...tpl.variables, newVar],
    });
    recordAudit('UPDATE_TEMPLATE', 'VARIABLE', newVar.id, `Variable agregada: {{${newVar.tag}}}`);
  };

  const updateVariable = (templateId: string, variableId: string, updates: Partial<TemplateVariable>) => {
    const tpl = globalState.templates.find((t) => t.id === templateId);
    if (!tpl) return;

    const oldVar = tpl.variables.find((v) => v.id === variableId);
    if (!oldVar) return;

    let updatedContent = tpl.content;
    // Atomic rename propagation (RN-008)
    if (updates.tag && updates.tag !== oldVar.tag) {
      const newTag = normalizeVariableTag(updates.tag);
      const oldRegex = new RegExp(`\\{\\{${oldVar.tag}\\}\\}`, 'gi');
      updatedContent = updatedContent.replace(oldRegex, `{{${newTag}}}`);
      updates.tag = newTag;
    }

    updateTemplate(templateId, {
      content: updatedContent,
      variables: tpl.variables.map((v) => (v.id === variableId ? { ...v, ...updates } : v)),
    });
    recordAudit('UPDATE_TEMPLATE', 'VARIABLE', variableId, `Variable {{${oldVar.tag}}} actualizada`);
  };

  const deleteVariable = (templateId: string, variableId: string) => {
    const tpl = globalState.templates.find((t) => t.id === templateId);
    if (!tpl) return;

    const targetVar = tpl.variables.find((v) => v.id === variableId);
    updateTemplate(templateId, {
      variables: tpl.variables.filter((v) => v.id !== variableId),
    });
    recordAudit('UPDATE_TEMPLATE', 'VARIABLE', variableId, `Variable eliminada: {{${targetVar?.tag}}}`);
  };

  const addClause = (templateId: string, clause: LegalClause) => {
    const tpl = globalState.templates.find((t) => t.id === templateId);
    if (!tpl) return;

    if (tpl.clauses.some((c) => c.id === clause.id)) {
      alert('Esta cláusula ya está asociada a la plantilla.');
      return;
    }

    updateTemplate(templateId, {
      clauses: [...tpl.clauses, clause],
    });
    recordAudit('ADD_CLAUSE', 'CLAUSE', clause.id, `Cláusula agregada: ${clause.title}`);
  };

  const updateClause = (templateId: string, clauseId: string, updates: Partial<LegalClause>) => {
    const tpl = globalState.templates.find((t) => t.id === templateId);
    if (!tpl) return;

    updateTemplate(templateId, {
      clauses: tpl.clauses.map((c) => (c.id === clauseId ? { ...c, ...updates } : c)),
    });
    recordAudit('UPDATE_TEMPLATE', 'CLAUSE', clauseId, `Cláusula actualizada: ${clauseId}`);
  };

  const deleteClause = (templateId: string, clauseId: string) => {
    const tpl = globalState.templates.find((t) => t.id === templateId);
    if (!tpl) return;

    updateTemplate(templateId, {
      clauses: tpl.clauses.filter((c) => c.id !== clauseId),
    });
    recordAudit('UPDATE_TEMPLATE', 'CLAUSE', clauseId, `Cláusula desvinculada: ${clauseId}`);
  };

  const addRule = (templateId: string, rule: ConditionalRule) => {
    const tpl = globalState.templates.find((t) => t.id === templateId);
    if (!tpl) return;

    updateTemplate(templateId, {
      rules: [...tpl.rules, rule],
    });
    recordAudit('UPDATE_RULE', 'RULE', rule.id, `Regla agregada: ${rule.name}`);
  };

  const updateRule = (templateId: string, ruleId: string, updates: Partial<ConditionalRule>) => {
    const tpl = globalState.templates.find((t) => t.id === templateId);
    if (!tpl) return;

    updateTemplate(templateId, {
      rules: tpl.rules.map((r) => (r.id === ruleId ? { ...r, ...updates } : r)),
    });
    recordAudit('UPDATE_RULE', 'RULE', ruleId, `Regla actualizada: ${ruleId}`);
  };

  const deleteRule = (templateId: string, ruleId: string) => {
    const tpl = globalState.templates.find((t) => t.id === templateId);
    if (!tpl) return;

    updateTemplate(templateId, {
      rules: tpl.rules.filter((r) => r.id !== ruleId),
    });
    recordAudit('UPDATE_RULE', 'RULE', ruleId, `Regla eliminada: ${ruleId}`);
  };

  // Human-in-the-Loop review actions (US-42..US-46)
  const startHitlReview = (originalText: string, tokens: DetectedToken[], targetTemplateId?: string) => {
    globalState.hitlOriginalText = originalText;
    globalState.hitlTokens = tokens;
    globalState.hitlTemplateId = targetTemplateId || null;
    globalState.currentView = 'HITL_REVIEW';
    notify();
  };

  const acceptHitlToken = (tokenId: string, customTag?: string) => {
    globalState.hitlTokens = globalState.hitlTokens.map((t) => {
      if (t.id === tokenId) {
        return {
          ...t,
          status: 'ACEPTADA',
          tag: customTag ? normalizeVariableTag(customTag) : t.tag,
        };
      }
      return t;
    });
    recordAudit('ACCEPT_VARIABLE', 'VARIABLE', tokenId, `Detección aceptada`);
    notify();
  };

  const rejectHitlToken = (tokenId: string) => {
    globalState.hitlTokens = globalState.hitlTokens.map((t) => {
      if (t.id === tokenId) {
        return { ...t, status: 'RECHAZADA' };
      }
      return t;
    });
    recordAudit('REJECT_VARIABLE', 'VARIABLE', tokenId, `Detección rechazada`);
    notify();
  };

  const mergeHitlTokens = (targetTokenId: string, sourceTokenIds: string[]) => {
    const target = globalState.hitlTokens.find((t) => t.id === targetTokenId);
    if (!target) return;

    globalState.hitlTokens = globalState.hitlTokens.map((t) => {
      if (sourceTokenIds.includes(t.id)) {
        return {
          ...t,
          status: 'FUSIONADA',
          tag: target.tag,
        };
      }
      return t;
    });
    recordAudit('MERGE_VARIABLES', 'VARIABLE', targetTokenId, `Variables fusionadas bajo {{${target.tag}}}`);
    notify();
  };

  const commitHitlToTemplate = (name: string, category: TemplateCategory): string => {
    let processedContent = globalState.hitlOriginalText;
    const acceptedTokens = globalState.hitlTokens.filter(
      (t) => t.status === 'ACEPTADA' || t.status === 'MODIFICADA' || t.status === 'FUSIONADA'
    );

    // Sort tokens by length of original value descending so longer phrases match first
    const sortedTokens = [...acceptedTokens].sort((a, b) => b.originalValue.length - a.originalValue.length);

    // Replace occurrences with {{tag}}
    for (const token of sortedTokens) {
      if (!token.originalValue) continue;
      const escaped = token.originalValue.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
      const regex = new RegExp(escaped, 'g');
      processedContent = processedContent.replace(regex, `{{${token.tag}}}`);
    }

    const templateVariables: TemplateVariable[] = [];
    const seenTags = new Set<string>();

    for (const token of acceptedTokens) {
      if (!seenTags.has(token.tag)) {
        seenTags.add(token.tag);
        templateVariables.push({
          id: `v_${Date.now()}_${Math.random().toString(36).substr(2, 4)}`,
          tag: token.tag,
          label: token.label,
          category: token.category,
          dataType: token.dataType,
          required: true,
          gender: token.gender,
          role: token.role,
          originalValue: token.originalValue,
          confidence: token.confidence,
          status: 'CONFIRMED',
          defaultValue: token.originalValue,
        });
      }
    }

    let templateId = globalState.hitlTemplateId;
    if (templateId) {
      updateTemplate(templateId, {
        content: processedContent,
        variables: templateVariables,
      });
    } else {
      templateId = createTemplate({
        name: name || 'Plantilla Importada y Verificada',
        description: 'Plantilla generada mediante importación inteligente y revisión human-in-the-loop',
        category,
        content: processedContent,
        variables: templateVariables,
      });
    }

    globalState.currentView = 'EDITOR';
    notify();
    return templateId;
  };

  const saveVersion = (templateId: string, description: string) => {
    const tpl = globalState.templates.find((t) => t.id === templateId);
    if (!tpl) return;

    const currentVerParts = tpl.version.split('.').map(Number);
    const newVer = `${currentVerParts[0]}.${(currentVerParts[1] || 0) + 1}`;

    const newVersionObj = {
      version: newVer,
      createdAt: new Date().toISOString(),
      createdBy: 'Abogado / Notario',
      description: description || `Actualización a versión ${newVer}`,
      content: tpl.content,
      variables: [...tpl.variables],
      clauses: [...tpl.clauses],
      rules: [...tpl.rules],
    };

    updateTemplate(templateId, {
      version: newVer,
      versions: [newVersionObj, ...(tpl.versions || [])],
    });
    recordAudit('UPDATE_TEMPLATE', 'TEMPLATE', templateId, `Nueva versión guardada: v${newVer}`);
  };

  const restoreVersion = (templateId: string, versionNumber: string) => {
    const tpl = globalState.templates.find((t) => t.id === templateId);
    if (!tpl) return;

    const targetVer = tpl.versions?.find((v) => v.version === versionNumber);
    if (!targetVer) return;

    updateTemplate(templateId, {
      content: targetVer.content,
      variables: targetVer.variables,
      clauses: targetVer.clauses,
      rules: targetVer.rules,
    });
    recordAudit('RESTORE_VERSION', 'TEMPLATE', templateId, `Versión restaurada a v${versionNumber}`);
  };

  const setFormValue = (key: string, value: any) => {
    globalState.formValues = {
      ...globalState.formValues,
      [key]: value,
    };
    notify();
  };

  const setAllFormValues = (values: Record<string, any>) => {
    globalState.formValues = values;
    notify();
  };

  const saveGeneratedDocument = (doc: GeneratedDocument) => {
    const enrichedDoc: GeneratedDocument = {
      ...doc,
      author: doc.author || `${globalState.currentUser.name} (${globalState.currentUser.cardRegistration})`,
    };
    globalState.generatedDocuments = [enrichedDoc, ...globalState.generatedDocuments];
    recordAudit('GENERATE_DOCUMENT', 'DOCUMENT', doc.id, `Documento final guardado: ${doc.title}`);
    notify();
  };

  const updateGeneratedDocument = (id: string, updates: Partial<GeneratedDocument>) => {
    globalState.generatedDocuments = globalState.generatedDocuments.map((d) => {
      if (d.id === id) {
        return { ...d, ...updates };
      }
      return d;
    });
    recordAudit('UPDATE_TEMPLATE', 'DOCUMENT', id, `Documento final actualizado: ${id}`);
    notify();
  };

  const deleteGeneratedDocument = (id: string) => {
    const docToDelete = globalState.generatedDocuments.find((d) => d.id === id);
    globalState.generatedDocuments = globalState.generatedDocuments.filter((d) => d.id !== id);
    recordAudit('UPDATE_TEMPLATE', 'DOCUMENT', id, `Documento final eliminado: ${docToDelete?.title || id}`);
    notify();
  };

  const duplicateGeneratedDocument = (id: string) => {
    const source = globalState.generatedDocuments.find((d) => d.id === id);
    if (!source) return;
    const newDoc: GeneratedDocument = {
      ...source,
      id: `doc_${Date.now()}`,
      title: `${source.title} (Copia)`,
      createdAt: new Date().toISOString(),
      status: 'BORRADOR',
    };
    globalState.generatedDocuments = [newDoc, ...globalState.generatedDocuments];
    recordAudit('GENERATE_DOCUMENT', 'DOCUMENT', newDoc.id, `Documento duplicado: ${newDoc.title}`);
    notify();
  };

  const restoreSampleGeneratedDocuments = () => {
    globalState.generatedDocuments = INITIAL_GENERATED_DOCUMENTS;
    notify();
  };

  const setAnalyzing = (val: boolean) => {
    globalState.isAnalyzing = val;
    notify();
  };

  const toggleDarkMode = () => {
    const next = !globalState.isDarkMode;
    globalState.isDarkMode = next;
    if (typeof document !== 'undefined') {
      if (next) {
        document.documentElement.classList.add('dark');
      } else {
        document.documentElement.classList.remove('dark');
      }
    }
    notify();
  };

  const setDarkMode = (enabled: boolean) => {
    globalState.isDarkMode = enabled;
    if (typeof document !== 'undefined') {
      if (enabled) {
        document.documentElement.classList.add('dark');
      } else {
        document.documentElement.classList.remove('dark');
      }
    }
    notify();
  };

  return {
    state,
    currentUser: globalState.currentUser,
    permissions: globalState.currentUser.permissions,
    activeTemplate: getActiveTemplate(),
    isDarkMode: state.isDarkMode,
    toggleDarkMode,
    setDarkMode,
    setView,
    setActiveTemplateId,
    createTemplate,
    updateTemplate,
    duplicateTemplate,
    changeTemplateStatus,
    deleteTemplate,
    addVariable,
    updateVariable,
    deleteVariable,
    addClause,
    updateClause,
    deleteClause,
    addRule,
    updateRule,
    deleteRule,
    startHitlReview,
    acceptHitlToken,
    rejectHitlToken,
    mergeHitlTokens,
    commitHitlToTemplate,
    saveVersion,
    restoreVersion,
    setFormValue,
    setAllFormValues,
    saveGeneratedDocument,
    updateGeneratedDocument,
    deleteGeneratedDocument,
    duplicateGeneratedDocument,
    restoreSampleGeneratedDocuments,
    setAnalyzing,
    recordAudit,
    switchUserRole,
    updateUserProfile,
  };
}
