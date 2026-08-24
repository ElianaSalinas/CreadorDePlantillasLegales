import React, { useState } from 'react';
import { Plus, X, FileText, Building, Scale, Briefcase } from 'lucide-react';
import { useAppStore } from '../store/useAppStore';
import { TemplateCategory } from '../types';

interface NewTemplateModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export const NewTemplateModal: React.FC<NewTemplateModalProps> = ({ isOpen, onClose }) => {
  const { createTemplate, setView } = useAppStore();

  const [name, setName] = useState('');
  const [description, setDescription] = useState('');
  const [category, setCategory] = useState<TemplateCategory>('Inmobiliario');
  const [preset, setPreset] = useState<'BLANK' | 'ALQUILER' | 'VENTA' | 'PODER'>('BLANK');

  if (!isOpen) return null;

  const handleCreate = (e: React.FormEvent) => {
    e.preventDefault();

    let initialContent = '';
    if (preset === 'ALQUILER') {
      initialContent = `CONTRATO DE ALQUILER RESIDENCIAL\n\nENTRE: {{arrendador_nombre}}, titular de la Cédula No. {{arrendador_cedula}}, por una parte;\nY de la otra parte, {{arrendatario_nombre}}, Cédula No. {{arrendatario_cedula}}.\n\nSE HA CONVENIDO LO SIGUIENTE:\n\nPRIMERO: {{arrendador_nombre}} alquila a {{arrendatario_nombre}} el inmueble ubicado en {{inmueble_direccion}} por un canon mensual de {{renta_mensual_monto}} ({{renta_mensual_letras}}).\n\nHECHO EN Santo Domingo, República Dominicana, a los {{fecha_firma}}.`;
    } else if (preset === 'VENTA') {
      initialContent = `CONTRATO DE PROMESA DE VENTA\n\nENTRE: {{vendedor_nombre}}, Cédula No. {{vendedor_cedula}};\nY {{comprador_nombre}}, Cédula No. {{comprador_cedula}}.\n\nPRIMERO: EL VENDEDOR vende a EL COMPRADOR el inmueble amparado por el Certificado de Título No. {{matricula_titulo}} por la suma de {{precio_venta_monto}} ({{precio_venta_letras}}).\n\nFIRMADO en República Dominicana.`;
    } else if (preset === 'PODER') {
      initialContent = `PODER ESPECIAL NOTARIAL\n\nANTE MÍ, {{notario_nombre}}, Notario Público para el {{distrito_judicial}};\n\nCOMPARECIÓ: {{poderdante_nombre}}, Cédula No. {{poderdante_cedula}}, quien otorga poder especial a favor de {{apoderado_nombre}}, Cédula No. {{apoderado_cedula}} para realizar: {{facultades_especificas}}.\n\nDOY FE.`;
    }

    const newId = createTemplate({
      name: name || 'Nueva Plantilla Legal',
      description,
      category,
      content: initialContent,
    });

    onClose();
    setView('EDITOR');
  };

  return (
    <div className="fixed inset-0 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4 z-50 animate-in fade-in">
      <div className="bg-white dark:bg-slate-900 rounded-2xl max-w-lg w-full p-6 shadow-2xl border border-[#E8E5DF] dark:border-slate-800 space-y-4">
        {/* Header */}
        <div className="flex items-center justify-between pb-3 border-b border-[#E8E5DF] dark:border-slate-800">
          <div className="flex items-center space-x-3">
            <div className="w-9 h-9 rounded-xl bg-[#0D2C24] text-[#FDE8B5] flex items-center justify-center">
              <Plus className="w-5 h-5" />
            </div>
            <div>
              <h3 className="font-serif font-bold text-base text-slate-900 dark:text-white">Crear Nueva Plantilla Legal</h3>
              <p className="text-xs text-slate-500 dark:text-slate-400">Jurisdicción República Dominicana • SAVE</p>
            </div>
          </div>

          <button onClick={onClose} className="text-slate-400 hover:text-slate-600 dark:hover:text-white cursor-pointer">
            <X className="w-5 h-5" />
          </button>
        </div>

        <form onSubmit={handleCreate} className="space-y-4 text-xs">
          <div>
            <label className="block font-semibold text-slate-700 dark:text-slate-300 mb-1">
              Nombre de la Plantilla <span className="text-rose-500">*</span>
            </label>
            <input
              type="text"
              required
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="ej. Contrato de Alquiler Comercial Tipo B"
              className="w-full px-3 py-2 border border-[#D1CCC4] dark:border-slate-700 dark:bg-slate-800 dark:text-white rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0D2C24] text-xs"
            />
          </div>

          <div>
            <label className="block font-semibold text-slate-700 dark:text-slate-300 mb-1">Descripción Jurídica</label>
            <textarea
              rows={2}
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              placeholder="Breve resumen del alcance o propósito del documento..."
              className="w-full px-3 py-2 border border-[#D1CCC4] dark:border-slate-700 dark:bg-slate-800 dark:text-white rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0D2C24] text-xs"
            />
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className="block font-semibold text-slate-700 dark:text-slate-300 mb-1">Categoría</label>
              <select
                value={category}
                onChange={(e) => setCategory(e.target.value as TemplateCategory)}
                className="w-full px-3 py-2 border border-[#D1CCC4] dark:border-slate-700 dark:bg-slate-800 dark:text-white rounded-xl focus:outline-none text-xs"
              >
                <option value="Inmobiliario">Inmobiliario</option>
                <option value="Civil">Civil</option>
                <option value="Comercial">Comercial</option>
                <option value="Corporativo">Corporativo</option>
              </select>
            </div>

            <div>
              <label className="block font-semibold text-slate-700 dark:text-slate-300 mb-1">Estructura Inicial</label>
              <select
                value={preset}
                onChange={(e) => setPreset(e.target.value as any)}
                className="w-full px-3 py-2 border border-[#D1CCC4] dark:border-slate-700 dark:bg-slate-800 dark:text-white rounded-xl focus:outline-none text-xs"
              >
                <option value="BLANK">En blanco (vacía)</option>
                <option value="ALQUILER">Base de Alquiler RD</option>
                <option value="VENTA">Base de Promesa de Venta</option>
                <option value="PODER">Base de Poder Notarial</option>
              </select>
            </div>
          </div>

          <div className="flex justify-end space-x-2 pt-4 border-t border-[#E8E5DF] dark:border-slate-800">
            <button
              type="button"
              onClick={onClose}
              className="px-4 py-2 rounded-xl font-semibold bg-[#F5F2ED] dark:bg-slate-800 hover:bg-[#E8E5DF] dark:hover:bg-slate-700 text-slate-700 dark:text-slate-300 cursor-pointer"
            >
              Cancelar
            </button>
            <button
              type="submit"
              className="px-4 py-2 rounded-xl font-bold bg-[#0D2C24] hover:bg-[#164E3E] text-white shadow-sm cursor-pointer"
            >
              Crear y Abrir Editor
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};
