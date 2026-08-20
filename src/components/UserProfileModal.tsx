import React, { useState } from 'react';
import {
  X,
  Scale,
  ShieldCheck,
  CheckCircle2,
  XCircle,
  Building,
  MapPin,
  Mail,
  Award,
  BookOpen,
  UserCheck,
  FileCheck2,
  FileText,
  History,
  Lock,
  Sparkles,
  Edit3,
  Save,
} from 'lucide-react';
import { useAppStore } from '../store/useAppStore';
import { UserRole } from '../types';

interface UserProfileModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export const UserProfileModal: React.FC<UserProfileModalProps> = ({ isOpen, onClose }) => {
  const { currentUser, permissions, switchUserRole, updateUserProfile, state } = useAppStore();
  const [isEditing, setIsEditing] = useState(false);
  const [formData, setFormData] = useState({
    name: currentUser.name,
    email: currentUser.email,
    roleTitle: currentUser.roleTitle,
    cardRegistration: currentUser.cardRegistration,
    notaryRegistration: currentUser.notaryRegistration || '',
    lawFirm: currentUser.lawFirm,
    jurisdiction: currentUser.jurisdiction,
  });

  if (!isOpen) return null;

  const handleSave = (e: React.FormEvent) => {
    e.preventDefault();
    updateUserProfile({
      name: formData.name,
      email: formData.email,
      roleTitle: formData.roleTitle,
      cardRegistration: formData.cardRegistration,
      notaryRegistration: formData.notaryRegistration,
      lawFirm: formData.lawFirm,
      jurisdiction: formData.jurisdiction,
    });
    setIsEditing(false);
  };

  const handleRoleChange = (role: UserRole) => {
    switchUserRole(role);
    setFormData((prev) => ({
      ...prev,
      roleTitle: role === 'ABOGADO'
        ? 'Abogada en Ejercicio • Especialista en Derecho Notarial e Inmobiliario'
        : role === 'NOTARIO'
        ? 'Notario Público del Distrito Nacional'
        : role === 'ASISTENTE_LEGAL'
        ? 'Paralegal / Asistente de Redacción Contractual'
        : 'Administrador del Sistema Legal',
    }));
  };

  const permissionItems = [
    {
      key: 'canEditTemplates',
      label: 'Creación y Edición de Plantillas Legales',
      desc: 'Capacidad para redactar, modificar y estructurar contenido de contratos',
      allowed: permissions.canEditTemplates,
    },
    {
      key: 'canPublishTemplates',
      label: 'Publicación Oficial de Plantillas',
      desc: 'Habilitar plantillas para producción tras superar el Health Check',
      allowed: permissions.canPublishTemplates,
    },
    {
      key: 'canManageClauses',
      label: 'Biblioteca de Cláusulas Notariales Protegidas',
      desc: 'Insertar, modificar y parametrizar cláusulas jurídicas estándar de RD',
      allowed: permissions.canManageClauses,
    },
    {
      key: 'canManageVariables',
      label: 'Diccionario de Variables & Validadores JCE / DGII',
      desc: 'Gestionar tipos de datos, validación Cédula Mod 10, RNC y montos en letras',
      allowed: permissions.canManageVariables,
    },
    {
      key: 'canManageRules',
      label: 'Motor de Reglas Condicionales y Dependencias',
      desc: 'Configurar condiciones de cláusulas y validación de grafos acíclicos',
      allowed: permissions.canManageRules,
    },
    {
      key: 'canPerformHITL',
      label: 'Revisión Human-in-the-Loop (HITL)',
      desc: 'Aprobar, rechazar, corregir y fusionar tokens detectados de contratos importados',
      allowed: permissions.canPerformHITL,
    },
    {
      key: 'canGenerateDocuments',
      label: 'Generación y Emisión de Contratos (DOCX / PDF)',
      desc: 'Llenar formularios notariales y emitir documentos listos para firma',
      allowed: permissions.canGenerateDocuments,
    },
    {
      key: 'canRunHealthCheck',
      label: 'Diagnóstico Estructural & Health Check',
      desc: 'Auditar variables huérfanas, referencias rotas y consistencia jurídica',
      allowed: permissions.canRunHealthCheck,
    },
    {
      key: 'canAccessAuditLogs',
      label: 'Pista de Auditoría Legal e Inmutable',
      desc: 'Visualizar registros cronológicos de cambios en plantillas y variables',
      allowed: permissions.canAccessAuditLogs,
    },
    {
      key: 'canManageVersions',
      label: 'Control de Versiones y Restauración',
      desc: 'Crear snapshots de versión (v1.0, v1.1) y revertir estados anteriores',
      allowed: permissions.canManageVersions,
    },
  ];

  return (
    <div className="fixed inset-0 z-50 overflow-y-auto bg-slate-950/70 backdrop-blur-xs flex items-center justify-center p-4">
      <div className="bg-white dark:bg-slate-900 rounded-2xl max-w-3xl w-full shadow-2xl border border-[#E8E5DF] dark:border-slate-800 overflow-hidden animate-in fade-in zoom-in-95 duration-150 max-h-[92vh] flex flex-col">
        {/* Modal Header with SAVE Theme */}
        <div className="bg-[#0D2C24] px-6 py-5 text-white flex items-center justify-between border-b border-[#164E3E]">
          <div className="flex items-center space-x-3">
            <div className="w-12 h-12 rounded-xl bg-[#FDE8B5] text-[#0D2C24] flex items-center justify-center shadow-inner font-bold">
              <Scale className="w-6 h-6" />
            </div>
            <div>
              <div className="flex items-center space-x-2">
                <h2 className="text-xl font-bold font-serif">{currentUser.name}</h2>
                <span className="px-2 py-0.5 rounded-full text-xs font-bold bg-[#FDE8B5]/20 text-[#FDE8B5] border border-[#FDE8B5]/30 uppercase tracking-wider">
                  ⚖️ {currentUser.role}
                </span>
              </div>
              <p className="text-xs text-slate-300 mt-0.5">{currentUser.roleTitle}</p>
            </div>
          </div>

          <button
            onClick={onClose}
            className="p-1.5 rounded-xl text-slate-300 hover:text-white hover:bg-[#164E3E] transition-colors cursor-pointer"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Modal Body */}
        <div className="p-6 overflow-y-auto space-y-6 flex-1 text-slate-800 dark:text-slate-200 text-sm">
          {/* Quick Lawyer Credentials Bar */}
          <div className="bg-[#F5F2ED] dark:bg-slate-800/80 rounded-2xl p-4 border border-[#E8E5DF] dark:border-slate-700 grid grid-cols-1 sm:grid-cols-3 gap-3 text-xs">
            <div className="flex items-start space-x-2.5">
              <Award className="w-4 h-4 text-[#C5A059] shrink-0 mt-0.5" />
              <div>
                <span className="text-slate-500 dark:text-slate-400 block text-[10px] uppercase font-bold tracking-wider">Colegiatura Oficial</span>
                <span className="font-semibold text-slate-800 dark:text-white">{currentUser.cardRegistration}</span>
                <span className="block text-[10px] text-slate-500 dark:text-slate-400">Colegio de Abogados (CARD)</span>
              </div>
            </div>

            <div className="flex items-start space-x-2.5">
              <Building className="w-4 h-4 text-[#0D2C24] dark:text-emerald-400 shrink-0 mt-0.5" />
              <div>
                <span className="text-slate-500 dark:text-slate-400 block text-[10px] uppercase font-bold tracking-wider">Firma Jurídica</span>
                <span className="font-semibold text-slate-800 dark:text-white">{currentUser.lawFirm}</span>
                <span className="block text-[10px] text-slate-500 dark:text-slate-400">Matrícula: {currentUser.notaryRegistration || 'No aplica'}</span>
              </div>
            </div>

            <div className="flex items-start space-x-2.5">
              <MapPin className="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" />
              <div>
                <span className="text-slate-500 dark:text-slate-400 block text-[10px] uppercase font-bold tracking-wider">Jurisdicción Legal</span>
                <span className="font-semibold text-slate-800 dark:text-white">{currentUser.jurisdiction}</span>
                <span className="block text-[10px] text-slate-500 dark:text-slate-400">República Dominicana 🇩🇴</span>
              </div>
            </div>
          </div>

          {/* Role Selector & State */}
          <div className="border border-[#E8E5DF] dark:border-slate-800 rounded-2xl p-4 space-y-3 bg-white dark:bg-slate-900">
            <div className="flex items-center justify-between">
              <div>
                <h3 className="font-bold text-slate-900 dark:text-white text-sm flex items-center space-x-2 font-serif">
                  <UserCheck className="w-4 h-4 text-[#0D2C24] dark:text-emerald-400" />
                  <span>Perfil y Rol del Operador Jurídico</span>
                </h3>
                <p className="text-xs text-slate-500 dark:text-slate-400">Selecciona tu perfil activo para verificar los permisos de la plataforma</p>
              </div>

              {!isEditing && (
                <button
                  onClick={() => setIsEditing(true)}
                  className="px-3 py-1 text-xs font-bold text-[#0D2C24] dark:text-emerald-400 bg-[#F5F2ED] dark:bg-slate-800 hover:bg-[#E8E5DF] rounded-xl flex items-center space-x-1 transition-colors cursor-pointer border border-[#E8E5DF] dark:border-slate-700"
                >
                  <Edit3 className="w-3.5 h-3.5" />
                  <span>Editar Credenciales</span>
                </button>
              )}
            </div>

            {/* Role Pills */}
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-2 pt-1">
              {(['ABOGADO', 'NOTARIO', 'ASISTENTE_LEGAL', 'ADMIN'] as UserRole[]).map((r) => {
                const isCurrent = currentUser.role === r;
                return (
                  <button
                    key={r}
                    onClick={() => handleRoleChange(r)}
                    className={`px-3 py-2.5 rounded-xl text-left border transition-all text-xs flex flex-col justify-between cursor-pointer ${
                      isCurrent
                        ? 'border-[#0D2C24] bg-[#F5F2ED] dark:bg-slate-800 text-[#0D2C24] dark:text-white ring-2 ring-[#0D2C24]/20 font-bold'
                        : 'border-[#E8E5DF] dark:border-slate-800 bg-[#FAFAF8] dark:bg-slate-900 hover:bg-[#F5F2ED] text-slate-700 dark:text-slate-300'
                    }`}
                  >
                    <div className="flex items-center justify-between">
                      <span className="font-bold">
                        {r === 'ABOGADO' && '⚖️ Abogado'}
                        {r === 'NOTARIO' && '📜 Notario'}
                        {r === 'ASISTENTE_LEGAL' && '📝 Asistente'}
                        {r === 'ADMIN' && '🛡️ Admin'}
                      </span>
                      {isCurrent && <CheckCircle2 className="w-3.5 h-3.5 text-[#0D2C24] dark:text-emerald-400" />}
                    </div>
                    <span className="text-[10px] text-slate-500 dark:text-slate-400 mt-1">
                      {r === 'ABOGADO' && 'Permisos Plenos'}
                      {r === 'NOTARIO' && 'Firma y Protocolo'}
                      {r === 'ASISTENTE_LEGAL' && 'Redacción / Captura'}
                      {r === 'ADMIN' && 'Control Total'}
                    </span>
                  </button>
                );
              })}
            </div>
          </div>

          {/* Edit Form if in editing mode */}
          {isEditing && (
            <form onSubmit={handleSave} className="bg-[#F5F2ED] dark:bg-slate-800/60 p-4 rounded-2xl border border-[#E8E5DF] dark:border-slate-700 space-y-3">
              <h4 className="font-semibold text-xs text-slate-700 dark:text-slate-300 uppercase tracking-wider">Actualizar Datos de Colegiatura</h4>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 text-xs">
                <div>
                  <label className="block text-slate-600 dark:text-slate-300 font-medium mb-1">Nombre Completo del Abogado(a):</label>
                  <input
                    type="text"
                    value={formData.name}
                    onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                    className="w-full px-3 py-1.5 rounded-xl border border-[#D1CCC4] dark:border-slate-700 dark:bg-slate-900 focus:outline-none focus:ring-2 focus:ring-[#0D2C24]"
                    required
                  />
                </div>

                <div>
                  <label className="block text-slate-600 dark:text-slate-300 font-medium mb-1">Correo Electrónico:</label>
                  <input
                    type="email"
                    value={formData.email}
                    onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                    className="w-full px-3 py-1.5 rounded-xl border border-[#D1CCC4] dark:border-slate-700 dark:bg-slate-900 focus:outline-none focus:ring-2 focus:ring-[#0D2C24]"
                    required
                  />
                </div>

                <div>
                  <label className="block text-slate-600 dark:text-slate-300 font-medium mb-1">No. Carnet CARD (Colegio de Abogados):</label>
                  <input
                    type="text"
                    value={formData.cardRegistration}
                    onChange={(e) => setFormData({ ...formData, cardRegistration: e.target.value })}
                    className="w-full px-3 py-1.5 rounded-xl border border-[#D1CCC4] dark:border-slate-700 dark:bg-slate-900 focus:outline-none focus:ring-2 focus:ring-[#0D2C24]"
                    required
                  />
                </div>

                <div>
                  <label className="block text-slate-600 dark:text-slate-300 font-medium mb-1">Matrícula Notarial (Opcional):</label>
                  <input
                    type="text"
                    value={formData.notaryRegistration}
                    onChange={(e) => setFormData({ ...formData, notaryRegistration: e.target.value })}
                    className="w-full px-3 py-1.5 rounded-xl border border-[#D1CCC4] dark:border-slate-700 dark:bg-slate-900 focus:outline-none focus:ring-2 focus:ring-[#0D2C24]"
                  />
                </div>

                <div>
                  <label className="block text-slate-600 dark:text-slate-300 font-medium mb-1">Bufete / Despacho Jurídico:</label>
                  <input
                    type="text"
                    value={formData.lawFirm}
                    onChange={(e) => setFormData({ ...formData, lawFirm: e.target.value })}
                    className="w-full px-3 py-1.5 rounded-xl border border-[#D1CCC4] dark:border-slate-700 dark:bg-slate-900 focus:outline-none focus:ring-2 focus:ring-[#0D2C24]"
                  />
                </div>

                <div>
                  <label className="block text-slate-600 dark:text-slate-300 font-medium mb-1">Jurisdicción Notarial / Territorial:</label>
                  <input
                    type="text"
                    value={formData.jurisdiction}
                    onChange={(e) => setFormData({ ...formData, jurisdiction: e.target.value })}
                    className="w-full px-3 py-1.5 rounded-xl border border-[#D1CCC4] dark:border-slate-700 dark:bg-slate-900 focus:outline-none focus:ring-2 focus:ring-[#0D2C24]"
                  />
                </div>
              </div>

              <div className="flex justify-end space-x-2 pt-2">
                <button
                  type="button"
                  onClick={() => setIsEditing(false)}
                  className="px-3 py-1.5 text-xs text-slate-600 dark:text-slate-300 hover:bg-[#E8E5DF] rounded-xl cursor-pointer"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="px-4 py-1.5 text-xs font-bold text-white bg-[#0D2C24] hover:bg-[#164E3E] rounded-xl flex items-center space-x-1 shadow-sm cursor-pointer"
                >
                  <Save className="w-3.5 h-3.5 text-[#FDE8B5]" />
                  <span>Guardar Cambios</span>
                </button>
              </div>
            </form>
          )}

          {/* Detailed Permissions Matrix */}
          <div className="space-y-3">
            <div className="flex items-center justify-between">
              <h3 className="font-bold text-slate-900 dark:text-white text-sm flex items-center space-x-2 font-serif">
                <ShieldCheck className="w-4 h-4 text-emerald-600 dark:text-emerald-400" />
                <span>Matriz de Permisos y Atribuciones Notariales</span>
              </h3>
              <span className="text-xs text-slate-500 dark:text-slate-400">
                {Object.values(permissions).filter(Boolean).length} de {Object.keys(permissions).length} facultades habilitadas
              </span>
            </div>

            <div className="bg-white dark:bg-slate-900 rounded-2xl border border-[#E8E5DF] dark:border-slate-800 divide-y divide-[#E8E5DF] dark:divide-slate-800">
              {permissionItems.map((item) => (
                <div key={item.key} className="p-3.5 flex items-start justify-between space-x-3 hover:bg-[#FAFAF8] dark:hover:bg-slate-800/40 transition-colors">
                  <div className="space-y-0.5">
                    <div className="font-semibold text-xs text-slate-900 dark:text-white flex items-center space-x-2">
                      <span>{item.label}</span>
                    </div>
                    <p className="text-[11px] text-slate-500 dark:text-slate-400">{item.desc}</p>
                  </div>

                  <div>
                    {item.allowed ? (
                      <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-emerald-50 dark:bg-emerald-950 text-emerald-800 dark:text-emerald-300 border border-emerald-200 dark:border-emerald-800">
                        <CheckCircle2 className="w-3 h-3 mr-1 text-emerald-600" />
                        Habilitado
                      </span>
                    ) : (
                      <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 border border-[#E8E5DF] dark:border-slate-700">
                        <Lock className="w-3 h-3 mr-1 text-slate-400" />
                        Restringido
                      </span>
                    )}
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Modal Footer */}
        <div className="bg-[#F5F2ED] dark:bg-slate-950 px-6 py-4 border-t border-[#E8E5DF] dark:border-slate-800 flex items-center justify-between">
          <div className="text-xs text-slate-600 dark:text-slate-400 flex items-center space-x-1.5 font-medium">
            <Scale className="w-3.5 h-3.5 text-[#0D2C24] dark:text-emerald-400" />
            <span>Perfil Abogado Activo • Certificación Notarial Dominicana</span>
          </div>

          <button
            onClick={onClose}
            className="px-4 py-2 rounded-xl text-xs font-bold bg-[#0D2C24] hover:bg-[#164E3E] text-white shadow-sm transition-colors cursor-pointer"
          >
            Aceptar y Continuar
          </button>
        </div>
      </div>
    </div>
  );
};
