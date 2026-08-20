const fs = require('fs');

let content = fs.readFileSync('src/components/WelcomePage.tsx', 'utf8');

// Add useState
content = content.replace("import React from 'react';", "import React, { useState } from 'react';\nimport { ShieldCheck, BookOpen, SlidersHorizontal, GitFork } from 'lucide-react';");

// Add state for login modal
content = content.replace("const { setView } = useAppStore();", "const { setView } = useAppStore();\n  const [isLoginOpen, setIsLoginOpen] = useState(false);\n  const [email, setEmail] = useState('');\n  const [password, setPassword] = useState('');\n\n  const handleLogin = (e: React.FormEvent) => {\n    e.preventDefault();\n    setIsLoginOpen(false);\n    setView('TEMPLATES');\n  };");

// Change buttons in Nav
content = content.replace(/<button onClick=\{\(\) => setView\('TEMPLATES'\)\} className="font-sans text-sm text-slate-600 dark:text-slate-400 hover:text-\[\#0D2C24\] dark:hover:text-emerald-300 transition-colors duration-200">Catálogo de Plantillas<\/button>/, `<a href="#ejemplos" className="font-sans text-sm text-slate-600 dark:text-slate-400 hover:text-[#0D2C24] dark:hover:text-emerald-400 transition-colors duration-200">Catálogo de Plantillas</a>`);

content = content.replace(/<button onClick=\{\(\) => setView\('TEMPLATES'\)\} className="hidden md:block font-sans font-semibold text-sm text-\[\#0D2C24\] dark:text-emerald-400 hover:text-\[\#0D2C24\] dark:hover:text-emerald-300\/80 transition-colors duration-200 px-4 py-2 cursor-pointer">Login<\/button>/, `<button onClick={() => setIsLoginOpen(true)} className="hidden md:block font-sans font-semibold text-sm text-[#0D2C24] dark:text-emerald-400 hover:text-[#0D2C24]/80 transition-colors duration-200 px-4 py-2 cursor-pointer">Login</button>`);

content = content.replace(/<button onClick=\{\(\) => setView\('TEMPLATES'\)\} className="bg-\[\#0D2C24\] dark:bg-slate-900 hover:bg-\[\#164E3E\] text-white dark:text-slate-900 font-sans font-semibold text-sm px-6 py-2.5 rounded-full transition-all duration-300 shadow-sm hover:shadow-md cursor-pointer">Empezar Ahora<\/button>/, `<button onClick={() => setIsLoginOpen(true)} className="bg-[#0D2C24] dark:bg-emerald-600 hover:bg-[#164E3E] text-white font-sans font-semibold text-sm px-6 py-2.5 rounded-full transition-all duration-300 shadow-sm hover:shadow-md cursor-pointer">Empezar Ahora</button>`);

// Hero buttons
content = content.replace(/<button onClick=\{\(\) => setView\('TEMPLATES'\)\} className="bg-\[\#0D2C24\] dark:bg-slate-900 hover:bg-\[\#164E3E\] text-white dark:text-slate-900 font-sans font-semibold text-sm px-8 py-4 rounded-full transition-all duration-300 shadow-md hover:shadow-lg flex items-center justify-center gap-2 group cursor-pointer">/g, `<a href="#ejemplos" className="bg-[#0D2C24] dark:bg-emerald-600 hover:bg-[#164E3E] dark:hover:bg-emerald-500 text-white font-sans font-semibold text-sm px-8 py-4 rounded-full transition-all duration-300 shadow-md hover:shadow-lg flex items-center justify-center gap-2 group cursor-pointer">`);
content = content.replace(/<\/button>\s*<button onClick=\{\(\) => setView\('PRICING'\)\}/g, `</a>\n              <button onClick={() => setView('PRICING')}`);


// Add Ejemplos section
const ejemplosSection = `
        {/* Ejemplos Section */}
        <section id="ejemplos" className="py-20 bg-slate-50 dark:bg-slate-950 border-t border-slate-200 dark:border-slate-800">
          <div className="max-w-7xl mx-auto px-6 md:px-12">
            <div className="text-center max-w-2xl mx-auto mb-16">
              <h2 className="font-serif text-[#0D2C24] dark:text-emerald-400 text-3xl md:text-4xl font-bold mb-4">Explora nuestras plantillas</h2>
              <p className="font-sans text-slate-600 dark:text-slate-400">Automatiza la redacción con estándares rigurosos. Estas son solo algunas de las plantillas disponibles en la plataforma interna.</p>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              {[
                { name: 'Contrato de Alquiler de Inmueble', cat: 'Inmobiliario', vars: 12, clauses: 8, rules: 3 },
                { name: 'Acuerdo de Confidencialidad (NDA)', cat: 'Corporativo', vars: 5, clauses: 10, rules: 1 },
                { name: 'Poder Especial de Representación', cat: 'Poderes', vars: 8, clauses: 4, rules: 2 }
              ].map((tpl, i) => (
                <article key={i} className="group relative flex flex-col bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 hover:border-[#0D2C24]/30 dark:hover:border-emerald-600/30 hover:shadow-[0_8px_24px_-4px_rgba(13,44,36,0.08)] transition-all duration-300 overflow-hidden">
                  <div className="p-6 flex-grow flex flex-col">
                    <div className="flex justify-between items-start mb-4">
                      <span className="inline-flex items-center px-2.5 py-1 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 font-sans text-[10px] font-semibold uppercase tracking-wider">{tpl.cat}</span>
                    </div>
                    <h3 className="font-serif font-bold text-[20px] leading-tight text-[#0D2C24] dark:text-white mb-2 line-clamp-2">{tpl.name}</h3>
                    <p className="font-sans text-[14px] text-slate-500 dark:text-slate-400 line-clamp-3 mb-6">Plantilla parametrizada lista para diligenciamiento inteligente y validación de variables jurídicas.</p>
                    
                    <div className="mt-auto flex flex-col gap-4 border-t border-slate-200/50 dark:border-slate-800 pt-4">
                      <div className="flex items-center justify-between text-slate-500 dark:text-slate-400 font-sans text-xs">
                        <div className="flex items-center gap-3">
                          <span className="flex items-center gap-1"><SlidersHorizontal className="w-3.5 h-3.5" />{tpl.vars}</span>
                          <span className="flex items-center gap-1"><BookOpen className="w-3.5 h-3.5" />{tpl.clauses}</span>
                          <span className="flex items-center gap-1"><GitFork className="w-3.5 h-3.5" />{tpl.rules}</span>
                        </div>
                        <div className="flex items-center gap-1 text-emerald-600 dark:text-emerald-400">
                          <ShieldCheck className="w-4 h-4" /> <span className="font-semibold">100%</span>
                        </div>
                      </div>
                      <button onClick={() => setIsLoginOpen(true)} className="w-full py-2 mt-2 bg-slate-100 dark:bg-slate-800 text-[#0D2C24] dark:text-emerald-400 font-sans text-xs font-semibold rounded hover:bg-slate-200 dark:hover:bg-slate-700 transition-colors cursor-pointer">Ingresar para Editar</button>
                    </div>
                  </div>
                </article>
              ))}
            </div>
          </div>
        </section>
`;

content = content.replace("</main>", ejemplosSection + "\n      </main>");

// Add Login Modal
const loginModal = `
      {/* Login Modal */}
      {isLoginOpen && (
        <div className="fixed inset-0 z-[100] flex items-center justify-center bg-slate-900/40 backdrop-blur-sm p-4">
          <div className="bg-white dark:bg-slate-900 rounded-2xl shadow-2xl w-full max-w-md overflow-hidden border border-slate-200 dark:border-slate-800 relative transform transition-all">
            <div className="p-8">
              <div className="flex justify-between items-center mb-6">
                <div className="flex items-center gap-2">
                  <div className="w-8 h-8 bg-[#0D2C24] rounded flex items-center justify-center text-white font-serif font-bold text-xs">S</div>
                  <h3 className="font-serif text-2xl text-[#0D2C24] dark:text-white font-bold">Ingresar</h3>
                </div>
                <button onClick={() => setIsLoginOpen(false)} className="text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 transition-colors cursor-pointer">
                  <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" /></svg>
                </button>
              </div>
              <form onSubmit={handleLogin} className="space-y-4">
                <div>
                  <label className="block font-sans text-sm font-semibold text-slate-700 dark:text-slate-300 mb-1.5">Correo Electrónico</label>
                  <input type="email" required value={email} onChange={e => setEmail(e.target.value)} className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white focus:border-[#0D2C24] focus:ring-1 focus:ring-[#0D2C24] outline-none transition-all font-sans" placeholder="abogado@firma.do" />
                </div>
                <div>
                  <label className="block font-sans text-sm font-semibold text-slate-700 dark:text-slate-300 mb-1.5">Contraseña</label>
                  <input type="password" required value={password} onChange={e => setPassword(e.target.value)} className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white focus:border-[#0D2C24] focus:ring-1 focus:ring-[#0D2C24] outline-none transition-all font-sans" placeholder="••••••••" />
                </div>
                <div className="pt-2">
                  <button type="submit" className="w-full py-3 bg-[#0D2C24] hover:bg-[#164E3E] text-white rounded-lg font-sans font-semibold transition-colors cursor-pointer">
                    Iniciar Sesión
                  </button>
                </div>
              </form>
              <div className="mt-6 text-center">
                <p className="font-sans text-sm text-slate-500 dark:text-slate-400">
                  ¿No tienes una cuenta? <a href="#" onClick={(e) => { e.preventDefault(); setIsLoginOpen(false); setView('PRICING'); }} className="text-[#0D2C24] dark:text-emerald-400 font-semibold hover:underline">Ver Planes</a>
                </p>
              </div>
            </div>
          </div>
        </div>
      )}
`;

content = content.replace("    </div>\n  );\n};", loginModal + "    </div>\n  );\n};");

fs.writeFileSync('src/components/WelcomePage.tsx', content);
console.log('Landing logic fixed');
