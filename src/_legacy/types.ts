export type TemplateStatus = 'DRAFT' | 'REVIEW' | 'PUBLISHED' | 'ARCHIVED';

export type VariableCategory =
  | 'CAT_NAME'
  | 'CAT_CEDULA'
  | 'CAT_RNC'
  | 'CAT_AMOUNT'
  | 'CAT_DATE'
  | 'CAT_ADDRESS'
  | 'CAT_COMPANY'
  | 'CAT_ROLE'
  | 'CAT_TERM'
  | 'CAT_CUSTOM';

export type VariableDataType =
  | 'string'
  | 'integer'
  | 'number'
  | 'boolean'
  | 'date'
  | 'currency'
  | 'percentage'
  | 'person'
  | 'company'
  | 'cedula'
  | 'rnc'
  | 'address'
  | 'legal_role';

export type CurrencyCode = 'DOP' | 'USD' | 'EUR';

export type GenderType = 'masculino' | 'femenino' | 'no_especificado';

export type LegalRole =
  | 'arrendador'
  | 'arrendatario'
  | 'comprador'
  | 'vendedor'
  | 'acreedor'
  | 'deudor'
  | 'notario'
  | 'garante'
  | 'representante'
  | 'generico';

export interface PersonData {
  nombre: string;
  cedula: string;
  nacionalidad: string;
  estado_civil: string;
  profesion: string;
  direccion: string;
  genero?: GenderType;
}

export interface CompanyData {
  razon_social: string;
  rnc: string;
  tipo_sociedad: 'SRL' | 'SA' | 'SAS' | 'EIRL' | 'OTRA';
  matricula_mercantil?: string;
  domicilio_social: string;
  representante_legal: string;
}

export interface AddressData {
  calle: string;
  numero: string;
  sector: string;
  ciudad: string;
  provincia: string;
  pais: string;
}

export interface DerivedVariableConfig {
  sourceVariableId: string;
  transformType:
    | 'amount_in_words'
    | 'date_in_words'
    | 'format_currency'
    | 'format_cedula'
    | 'calculate_months'
    | 'multiply'
    | 'percentage_calc';
  params?: Record<string, any>;
}

export interface TemplateVariable {
  id: string; // unique internal id
  tag: string; // snake_case identifier e.g. "inquilino_nombre"
  label: string; // UI label in Spanish
  description?: string;
  category: VariableCategory;
  dataType: VariableDataType;
  required: boolean;
  defaultValue?: any;
  currency?: CurrencyCode;
  gender?: GenderType;
  role?: LegalRole;
  derivedConfig?: DerivedVariableConfig;
  validationRegex?: string;
  validationErrorMessage?: string;
  originalValue?: string;
  confidence?: number;
  status?: 'SUGGESTED' | 'CONFIRMED' | 'REJECTED' | 'MERGED';
}

export interface DetectedToken {
  id: string;
  tag: string;
  label: string;
  originalValue: string;
  category: VariableCategory;
  dataType: VariableDataType;
  confidence: number;
  gender?: GenderType;
  role?: LegalRole;
  status: 'PENDIENTE' | 'ACEPTADA' | 'RECHAZADA' | 'MODIFICADA' | 'FUSIONADA';
  paragraphIndex?: number;
  startIndex?: number;
  endIndex?: number;
}

export type ClauseCategory =
  | 'Garantía'
  | 'Mora y Penalidades'
  | 'Terminación'
  | 'Renovación'
  | 'Mantenimiento'
  | 'Servicios'
  | 'Jurisdicción'
  | 'Confidencialidad'
  | 'Entrega'
  | 'General'
  | 'Inmobiliario'
  | 'Penalidades'
  | 'Garantías'
  | 'Laboral';

export interface LegalClause {
  id: string;
  title: string;
  category: ClauseCategory;
  content: string;
  variablesReferenced: string[];
  conditionVariableId?: string; // e.g. "incluye_mantenimiento"
  conditionExpectedValue?: any; // e.g. true
  version: string;
  isProtected?: boolean;
  isStandard?: boolean;
  isActiveDefault?: boolean;
  description?: string;
}

export type RuleOperator =
  | 'equals'
  | 'not_equals'
  | 'contains'
  | 'greater_than'
  | 'less_than'
  | 'exists'
  | 'is_empty'
  | 'in_list';

export type RuleAction =
  | 'SHOW_CLAUSE'
  | 'HIDE_CLAUSE'
  | 'REQUIRE_VARIABLE'
  | 'OPTIONAL_VARIABLE'
  | 'SET_VALUE'
  | 'WARN_USER';

export interface ConditionalRule {
  id: string;
  name: string;
  targetVariableId: string;
  operator: RuleOperator;
  compareValue: any;
  action: RuleAction;
  actionPayload: {
    clauseId?: string;
    variableId?: string;
    value?: any;
    message?: string;
  };
  isActive: boolean;
}

export interface TemplateVersion {
  version: string;
  createdAt: string;
  createdBy: string;
  description: string;
  content: string;
  variables: TemplateVariable[];
  clauses: LegalClause[];
  rules: ConditionalRule[];
}

export interface AuditLogEntry {
  id: string;
  timestamp: string;
  user: string;
  action:
    | 'CREATE_TEMPLATE'
    | 'UPDATE_TEMPLATE'
    | 'ACCEPT_VARIABLE'
    | 'REJECT_VARIABLE'
    | 'MERGE_VARIABLES'
    | 'ADD_CLAUSE'
    | 'UPDATE_RULE'
    | 'GENERATE_DOCUMENT'
    | 'PUBLISH_TEMPLATE'
    | 'RESTORE_VERSION';
  targetType: 'TEMPLATE' | 'VARIABLE' | 'CLAUSE' | 'RULE' | 'DOCUMENT';
  targetId: string;
  details: string;
  previousValue?: any;
  newValue?: any;
}

export type TemplateCategory = 'Inmobiliario' | 'Civil' | 'Comercial' | 'Corporativo' | 'Laboral';

export interface LegalTemplate {
  id: string;
  name: string;
  description: string;
  category: TemplateCategory;
  jurisdiction: 'República Dominicana';
  version: string;
  status: TemplateStatus;
  content: string;
  variables: TemplateVariable[];
  clauses: LegalClause[];
  rules: ConditionalRule[];
  versions: TemplateVersion[];
  createdAt: string;
  updatedAt: string;
  author: string;
}

export interface HealthCheckResult {
  status: 'HEALTHY' | 'WARNING' | 'ERROR';
  score: number;
  totalVariables: number;
  usedVariables: number;
  orphanVariables: string[];
  missingVariableReferences: string[];
  totalClauses: number;
  missingClauseReferences: string[];
  totalRules: number;
  invalidRules: { ruleId: string; reason: string }[];
  circularDependencies: string[];
  amountConsistencyWarnings: string[];
  canPublish: boolean;
  errors: string[];
  warnings: string[];
}

export interface GeneratedDocument {
  id: string;
  templateId: string;
  templateName: string;
  title: string;
  formData?: Record<string, any>;
  valuesSnapshot?: Record<string, any>;
  finalContent?: string;
  renderedContent?: string;
  generatedAt?: string;
  createdAt?: string;
  author?: string;
  format?: 'DOCX' | 'PDF' | 'JSON';
  status?: 'BORRADOR' | 'EN_REVISION' | 'APROBADO' | 'GENERADO' | 'EMITIDO' | 'NOTARIADO' | 'ARCHIVADO';
  docxUrl?: string;
  pdfUrl?: string;
}

export type UserRole = 'ABOGADO' | 'NOTARIO' | 'ASISTENTE_LEGAL' | 'ADMIN';

export interface UserPermissions {
  canEditTemplates: boolean;
  canPublishTemplates: boolean;
  canDeleteTemplates: boolean;
  canManageClauses: boolean;
  canManageVariables: boolean;
  canManageRules: boolean;
  canRunHealthCheck: boolean;
  canPerformHITL: boolean;
  canGenerateDocuments: boolean;
  canAccessAuditLogs: boolean;
  canManageVersions: boolean;
  canSignNotarial: boolean;
}

export interface UserProfile {
  id: string;
  name: string;
  email: string;
  role: UserRole;
  roleTitle: string;
  cardRegistration: string; // Colegio de Abogados de la República Dominicana (CARD)
  notaryRegistration?: string; // Colegio Dominicano de Notarios
  lawFirm: string;
  jurisdiction: string;
  avatarUrl?: string;
  permissions: UserPermissions;
}

