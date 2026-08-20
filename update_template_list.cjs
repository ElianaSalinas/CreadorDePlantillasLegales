const fs = require('fs');
let content = fs.readFileSync('src/components/TemplateList.tsx', 'utf8');

const newCardCode = `
            return (
              <article
                key={template.id}
                className="group relative flex flex-col bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 hover:border-[#0D2C24]/30 dark:hover:border-emerald-600/30 hover:shadow-[0_8px_24px_-4px_rgba(13,44,36,0.08)] transition-all duration-300 overflow-hidden"
              >
                <div className="p-6 flex-grow flex flex-col">
                  <div className="flex justify-between items-start mb-4">
                    <div className="flex gap-2 items-center">
                      <span className="inline-flex items-center px-2.5 py-1 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 font-sans text-[10px] font-semibold uppercase tracking-wider">
                        {template.category}
                      </span>
                      <span className={\`inline-flex items-center px-2.5 py-1 rounded-full text-[10px] font-bold uppercase \${template.status === 'PUBLISHED' ? 'bg-emerald-50 text-emerald-800 border border-emerald-200 dark:bg-emerald-950 dark:text-emerald-300' : template.status === 'REVIEW' ? 'bg-amber-50 text-amber-800 border border-amber-200 dark:bg-amber-950 dark:text-amber-300' : 'bg-slate-50 text-slate-700 border border-slate-200 dark:bg-slate-800 dark:text-slate-300'}\`}>
                        {template.status === 'PUBLISHED' ? 'Publicada' : template.status === 'REVIEW' ? 'En Revisión' : template.status === 'ARCHIVED' ? 'Archivada' : 'Borrador'}
                      </span>
                    </div>
                  </div>
                  <h3 className="font-serif font-bold text-[20px] leading-tight text-[#0D2C24] dark:text-white mb-2 group-hover:text-[#46645b] dark:group-hover:text-emerald-400 transition-colors line-clamp-2">
                    {template.name}
                  </h3>
                  <p className="font-sans text-[14px] text-slate-500 dark:text-slate-400 line-clamp-3 mb-6">
                    {template.description || 'Sin descripción jurídica proporcionada.'}
                  </p>
                  
                  <div className="mt-auto flex flex-col gap-4 border-t border-slate-200/50 dark:border-slate-800 pt-4">
                    {/* Stats */}
                    <div className="flex items-center justify-between text-slate-500 dark:text-slate-400 font-sans text-xs">
                      <div className="flex items-center gap-3">
                        <span className="flex items-center gap-1" title="Variables">
                          <SlidersHorizontal className="w-3.5 h-3.5" />
                          {template.variables.length}
                        </span>
                        <span className="flex items-center gap-1" title="Cláusulas">
                          <BookOpen className="w-3.5 h-3.5" />
                          {template.clauses.length}
                        </span>
                        <span className="flex items-center gap-1" title="Reglas">
                          <GitFork className="w-3.5 h-3.5" />
                          {template.rules.length}
                        </span>
                      </div>
                      <div className="flex items-center gap-1" title="Salud Estructural">
                         <ShieldCheck className={\`w-4 h-4 \${health.status === 'HEALTHY' ? 'text-emerald-600' : health.status === 'WARNING' ? 'text-amber-500' : 'text-rose-600'}\`} />
                         <span className={\`font-semibold \${health.status === 'HEALTHY' ? 'text-emerald-700 dark:text-emerald-400' : health.status === 'WARNING' ? 'text-amber-700 dark:text-amber-400' : 'text-rose-700 dark:text-rose-400'}\`}>{health.score}%</span>
                      </div>
                    </div>

                    {/* Actions */}
                    <div className="flex items-center justify-between">
                       <div className="flex items-center space-x-1">
                          <button onClick={() => duplicateTemplate(template.id)} className="p-1.5 text-slate-400 hover:text-[#0D2C24] dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded transition-colors cursor-pointer" title="Duplicar Plantilla">
                            <Copy className="w-4 h-4" />
                          </button>
                          <button onClick={() => { if (confirm(\`¿Estás seguro de eliminar la plantilla "\${template.name}"?\`)) { deleteTemplate(template.id); } }} className="p-1.5 text-slate-400 hover:text-rose-600 hover:bg-rose-50 rounded transition-colors cursor-pointer" title="Eliminar Plantilla">
                            <Trash2 className="w-4 h-4" />
                          </button>
                       </div>
                       <div className="flex gap-2">
                          <button onClick={() => handleSelectTemplate(template, 'EDITOR')} className="px-3 py-1.5 border border-slate-200 dark:border-slate-700 text-[#0D2C24] dark:text-slate-200 font-sans text-xs font-semibold rounded hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors cursor-pointer">
                            Editar
                          </button>
                          <button onClick={() => handleSelectTemplate(template, 'FORM_GEN')} className="px-3 py-1.5 bg-[#0D2C24] text-white font-sans text-xs font-semibold rounded flex items-center gap-1 hover:bg-[#164E3E] transition-colors cursor-pointer">
                            <Play className="w-3 h-3 fill-current text-[#FDE8B5]" />
                            Generar
                          </button>
                       </div>
                    </div>
                  </div>
                </div>
              </article>
            );`;

const regex = /return \(\s*<div\s*key=\{template\.id\}[\s\S]*?\n\s*\);\s*\}\)/m;
if(content.match(regex)) {
  content = content.replace(regex, newCardCode + '\n          })');
  fs.writeFileSync('src/components/TemplateList.tsx', content);
  console.log('Successfully updated the map render in TemplateList.tsx');
} else {
  console.log('Regex did not match.');
}
