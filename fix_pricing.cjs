const fs = require('fs');

let content = fs.readFileSync('src/components/PricingPage.tsx', 'utf8');

content = content.replace("import React from 'react';", "import React, { useState } from 'react';");
content = content.replace("const { setView } = useAppStore();", "const { setView } = useAppStore();\n  const [isLoginOpen, setIsLoginOpen] = useState(false);\n  const [email, setEmail] = useState('');\n  const [password, setPassword] = useState('');\n\n  const handleLogin = (e: React.FormEvent) => {\n    e.preventDefault();\n    setIsLoginOpen(false);\n    setView('TEMPLATES');\n  };");

content = content.replace(/<button onClick=\{\(\) => setView\('TEMPLATES'\)\} className="font-sans text-sm text-slate-600 dark:text-slate-400 hover:text-\[\#0D2C24\] dark:hover:text-emerald-300 transition-colors duration-200">Catálogo de Plantillas<\/button>/, `<button onClick={() => setView('WELCOME')} className="font-sans text-sm text-slate-600 dark:text-slate-400 hover:text-[#0D2C24] dark:hover:text-emerald-400 transition-colors duration-200">Inicio</button>`);

content = content.replace(/<button onClick=\{\(\) => setView\('TEMPLATES'\)\} className="font-sans text-sm font-semibold text-\[\#0D2C24\] dark:text-emerald-400 hover:text-\[\#46645b\] dark:hover:text-emerald-300 transition-colors cursor-pointer">Login<\/button>/, `<button onClick={() => setIsLoginOpen(true)} className="font-sans text-sm font-semibold text-[#0D2C24] dark:text-emerald-400 hover:text-[#46645b] dark:hover:text-emerald-300 transition-colors cursor-pointer">Login</button>`);

content = content.replace(/<button onClick=\{\(\) => setView\('TEMPLATES'\)\} className="bg-\[\#0D2C24\] dark:bg-slate-900 text-white dark:text-slate-900 font-sans text-sm font-semibold px-6 py-2.5 rounded hover:bg-\[\#164E3E\] transition-colors shadow-sm hidden md:block cursor-pointer">Empezar Ahora<\/button>/, `<button onClick={() => setIsLoginOpen(true)} className="bg-[#0D2C24] dark:bg-emerald-600 text-white font-sans text-sm font-semibold px-6 py-2.5 rounded hover:bg-[#164E3E] dark:hover:bg-emerald-500 transition-colors shadow-sm hidden md:block cursor-pointer">Empezar Ahora</button>`);

content = content.replace(/<button className="w-full py-3.5 border border-\[\#0D2C24\] text-\[\#0D2C24\] dark:text-emerald-400 font-sans text-sm font-semibold rounded hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors cursor-pointer">Seleccionar Plan<\/button>/, `<button onClick={() => setIsLoginOpen(true)} className="w-full py-3.5 border border-[#0D2C24] dark:border-emerald-600 text-[#0D2C24] dark:text-emerald-400 font-sans text-sm font-semibold rounded hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors cursor-pointer">Seleccionar Plan</button>`);

content = content.replace(/<button onClick=\{\(\) => setView\('TEMPLATES'\)\} className="w-full py-3.5 bg-\[\#ffdea5\] text-\[\#261900\] font-sans text-sm font-bold rounded hover:bg-\[\#e9c176\] transition-colors shadow-sm cursor-pointer">Iniciar Prueba de 14 Días<\/button>/, `<button onClick={() => setIsLoginOpen(true)} className="w-full py-3.5 bg-[#ffdea5] text-[#261900] font-sans text-sm font-bold rounded hover:bg-[#e9c176] transition-colors shadow-sm cursor-pointer">Iniciar Prueba de 14 Días</button>`);


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
            </div>
          </div>
        </div>
      )}
`;

content = content.replace("    </div>\n  );\n};", loginModal + "    </div>\n  );\n};");

fs.writeFileSync('src/components/PricingPage.tsx', content);
console.log('Pricing logic fixed');
