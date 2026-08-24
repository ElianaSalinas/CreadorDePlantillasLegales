import { UserProfile, UserRole, UserPermissions } from '../types';

const FULL_PERMISSIONS: UserPermissions = {
  canEditTemplates: true,
  canPublishTemplates: true,
  canDeleteTemplates: true,
  canManageClauses: true,
  canManageVariables: true,
  canManageRules: true,
  canRunHealthCheck: true,
  canPerformHITL: true,
  canGenerateDocuments: true,
  canAccessAuditLogs: true,
  canManageVersions: true,
  canSignNotarial: true,
};

export const ROLE_PERMISSIONS: Record<UserRole, UserPermissions> = {
  ABOGADO: { ...FULL_PERMISSIONS },
  NOTARIO: { ...FULL_PERMISSIONS },
  ASISTENTE_LEGAL: { ...FULL_PERMISSIONS },
  ADMIN: { ...FULL_PERMISSIONS },
};

export const LAWYER_DEFAULT_PROFILE: UserProfile = {
  id: 'usr_stephanie_montero',
  name: 'Licda. Stephanie Montero',
  email: 'stephaniamontero84@gmail.com',
  role: 'ABOGADO',
  roleTitle: 'Abogada en Ejercicio • Especialista en Derecho Notarial e Inmobiliario',
  cardRegistration: 'CARD No. 48291-DR',
  notaryRegistration: 'Colegio Dominicano de Notarios No. 7412',
  lawFirm: 'Montero & Asociados • Consultores Jurídicos',
  jurisdiction: 'Distrito Nacional, Santo Domingo, Rep. Dom.',
  permissions: ROLE_PERMISSIONS.ABOGADO,
};

export const AVAILABLE_PROFILES: Record<UserRole, UserProfile> = {
  ABOGADO: {
    id: 'usr_stephanie_montero',
    name: 'Licda. Stephanie Montero',
    email: 'stephaniamontero84@gmail.com',
    role: 'ABOGADO',
    roleTitle: 'Abogada en Ejercicio • Especialista en Derecho Notarial e Inmobiliario',
    cardRegistration: 'CARD No. 48291-DR',
    notaryRegistration: 'Colegio Dominicano de Notarios No. 7412',
    lawFirm: 'Montero & Asociados • Consultores Jurídicos',
    jurisdiction: 'Distrito Nacional, Santo Domingo, Rep. Dom.',
    permissions: ROLE_PERMISSIONS.ABOGADO,
  },
  NOTARIO: {
    id: 'usr_notario_santana',
    name: 'Dr. Alejandro Santana R.',
    email: 'asantana@notaria-santana.do',
    role: 'NOTARIO',
    roleTitle: 'Notario Público de los del Número del Distrito Nacional',
    cardRegistration: 'CARD No. 31054-DR',
    notaryRegistration: 'Colegio Dominicano de Notarios Matrícula No. 2981',
    lawFirm: 'Notaría Pública Santana & Peña',
    jurisdiction: 'Distrito Nacional, Santo Domingo, Rep. Dom.',
    permissions: ROLE_PERMISSIONS.NOTARIO,
  },
  ASISTENTE_LEGAL: {
    id: 'usr_asistente_carlos',
    name: 'Carlos Mendez, Paralegal',
    email: 'cmendez@monterolegal.do',
    role: 'ASISTENTE_LEGAL',
    roleTitle: 'Paralegal / Asistente de Redacción Contractual',
    cardRegistration: 'En proceso de colegiatura CARD',
    lawFirm: 'Montero & Asociados • Consultores Jurídicos',
    jurisdiction: 'Distrito Nacional, Santo Domingo, Rep. Dom.',
    permissions: ROLE_PERMISSIONS.ASISTENTE_LEGAL,
  },
  ADMIN: {
    id: 'usr_admin_legal',
    name: 'Administrador del Sistema Legal',
    email: 'admin@save-legal.do',
    role: 'ADMIN',
    roleTitle: 'Administrador de Plataforma y Cumplimiento Regulatorio',
    cardRegistration: 'CARD No. 10001-DR (Honorario)',
    lawFirm: 'SAVE Legal Platform RD',
    jurisdiction: 'Nacional (República Dominicana)',
    permissions: ROLE_PERMISSIONS.ADMIN,
  },
};

