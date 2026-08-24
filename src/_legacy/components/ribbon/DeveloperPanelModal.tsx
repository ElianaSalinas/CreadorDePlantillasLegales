import React, { useState } from 'react';
import { Code2, FileCode, CheckCircle, Copy, Check, X, Download, Braces } from 'lucide-react';
import { useAppStore } from '../../store/useAppStore';
import { generateSchemaJson } from '../../core/exportEngine';

interface DeveloperPanelModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export const DeveloperPanelModal: React.FC<DeveloperPanelModalProps> = ({ isOpen, onClose }) => {
  const { activeTemplate } = useAppStore();
  const [copied, setCopied] = useState(false);
  const [activeTab, setActiveTab] = useState<'SCHEMA' | 'XML_TAGS' | 'REGEX'>('SCHEMA');

  if (!isOpen || !activeTemplate) return null;

  const schemaJson = generateSchemaJson(activeTemplate);

  const xmlTagsRepresentation = `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>
    <w:p>
      <w:pPr>
        <w:jc w:val="both"/>
        <w:spacing w:line="360" w:lineRule="auto"/>
      </w:pPr>
      <w:r>
        <w:rPr>
          <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman"/>
          <w:b/>
          <w:sz w:val="24"/>
        </w:rPr>
        <w:t>${activeTemplate.name.toUpperCase()}</w:t>
      </w:r>
    </w:p>
    ${activeTemplate.variables
      .map(
        (v) => `    <w:sdt>
      <w:sdtPr>
        <w:alias w:val="${v.label}"/>
        <w:tag w:val="${v.tag}"/>
      </w:sdtPr>
      <w:sdtContent>
        <w:r><w:t>{{${v.tag}}}</w:t></w:r>
      </w:sdtContent>
    </w:sdt>`
      )
      .join('\n')}
  </w:body>
</w:document>`;

  const handleCopy = (text: string) => {
    navigator.clipboard.writeText(text);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const handleDownload = (filename: string, content: string) => {
    const blob = new Blob([content], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    a.click();
    URL.revokeObjectURL(url);
  };

  return (
    <div className="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-xs flex items-center justify-center p-4">
      <div className="bg-slate-900 text-white rounded-2xl shadow-2xl border border-slate-700 w-full max-w-3xl max-h-[85vh] flex flex-col overflow-hidden animate-in fade-in zoom-in-95 duration-150">
        {/* Header */}
        <div className="p-4 border-b border-slate-800 flex items-center justify-between bg-slate-950">
          <div className="flex items-center space-x-2">
            <Code2 className="w-5 h-5 text-emerald-400" />
            <div>
              <h3 className="font-bold text-sm text-white">Herramientas de Desarrollador & XML</h3>
              <p className="text-[11px] text-slate-400">Esquemas interoperables WordprocessingML, JSON Schema y Regex AST</p>
            </div>
          </div>
          <button onClick={onClose} className="p-1 hover:bg-slate-800 rounded text-slate-400 hover:text-white">
            <X className="w-4 h-4" />
          </button>
        </div>

        {/* Tab switcher */}
        <div className="flex border-b border-slate-800 bg-slate-900 px-4 pt-2 space-x-2 text-xs">
          <button
            onClick={() => setActiveTab('SCHEMA')}
            className={`px-3 py-2 font-semibold border-b-2 transition-all ${
              activeTab === 'SCHEMA'
                ? 'border-emerald-500 text-emerald-400'
                : 'border-transparent text-slate-400 hover:text-slate-200'
            }`}
          >
            JSON Schema (Contrato)
          </button>
          <button
            onClick={() => setActiveTab('XML_TAGS')}
            className={`px-3 py-2 font-semibold border-b-2 transition-all ${
              activeTab === 'XML_TAGS'
                ? 'border-emerald-500 text-emerald-400'
                : 'border-transparent text-slate-400 hover:text-slate-200'
            }`}
          >
            WordprocessingML (OOXML)
          </button>
          <button
            onClick={() => setActiveTab('REGEX')}
            className={`px-3 py-2 font-semibold border-b-2 transition-all ${
              activeTab === 'REGEX'
                ? 'border-emerald-500 text-emerald-400'
                : 'border-transparent text-slate-400 hover:text-slate-200'
            }`}
          >
            Mapeo Regex & AST
          </button>
        </div>

        {/* Code Content */}
        <div className="flex-1 p-4 overflow-y-auto font-mono text-xs bg-slate-950 text-emerald-200">
          {activeTab === 'SCHEMA' && (
            <pre className="whitespace-pre-wrap leading-relaxed">{schemaJson}</pre>
          )}

          {activeTab === 'XML_TAGS' && (
            <pre className="whitespace-pre-wrap leading-relaxed text-emerald-300">{xmlTagsRepresentation}</pre>
          )}

          {activeTab === 'REGEX' && (
            <div className="space-y-4 font-sans text-slate-300 text-xs">
              <p className="font-mono text-emerald-300">
                Sintaxis de tokens: <code className="bg-slate-800 px-2 py-0.5 rounded text-amber-300">{'\\{\\{([a-zA-Z0-9_]+)\\}\\}'}</code>
              </p>
              <div className="p-3 bg-slate-900 border border-slate-800 rounded-xl space-y-2">
                <h4 className="font-bold text-white font-mono">Variables registradas para compilación AST:</h4>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 font-mono text-[11px]">
                  {activeTemplate.variables.map((v) => (
                    <div key={v.id} className="p-2 bg-slate-950 rounded border border-slate-800 flex justify-between">
                      <span className="text-emerald-400">{`{{${v.tag}}}`}</span>
                      <span className="text-slate-500">{v.dataType}</span>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          )}
        </div>

        {/* Footer */}
        <div className="p-3 bg-slate-950 border-t border-slate-800 flex items-center justify-between text-xs">
          <button
            onClick={() =>
              handleCopy(
                activeTab === 'SCHEMA'
                  ? schemaJson
                  : activeTab === 'XML_TAGS'
                  ? xmlTagsRepresentation
                  : JSON.stringify(activeTemplate.variables, null, 2)
              )
            }
            className="px-3 py-1.5 bg-slate-800 hover:bg-slate-700 text-white rounded-lg inline-flex items-center space-x-1.5 transition-colors"
          >
            {copied ? <Check className="w-3.5 h-3.5 text-emerald-400" /> : <Copy className="w-3.5 h-3.5" />}
            <span>{copied ? 'Copiado al Portapapeles' : 'Copiar'}</span>
          </button>

          <button
            onClick={() =>
              handleDownload(
                activeTab === 'SCHEMA'
                  ? `${activeTemplate.name}_schema.json`
                  : `${activeTemplate.name}_document.xml`,
                activeTab === 'SCHEMA' ? schemaJson : xmlTagsRepresentation
              )
            }
            className="px-3 py-1.5 bg-emerald-600 hover:bg-emerald-500 text-white rounded-lg inline-flex items-center space-x-1.5 shadow-sm font-semibold transition-colors"
          >
            <Download className="w-3.5 h-3.5" />
            <span>Descargar Archivo</span>
          </button>
        </div>
      </div>
    </div>
  );
};
