import React, { useState } from 'react';
import { ShieldCheck, BookOpen, SlidersHorizontal, GitFork } from 'lucide-react';
import { useAppStore } from '../store/useAppStore';

export const WelcomePage: React.FC = () => {
  const { setView } = useAppStore();
  const [isLoginOpen, setIsLoginOpen] = useState(false);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const handleLogin = (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoginOpen(false);
    setView('TEMPLATES');
  };

  return (
    <div className="bg-[#fcf9f8] dark:bg-slate-900 dark:bg-slate-900 text-slate-800 dark:text-slate-200 dark:text-slate-200 font-body-md antialiased selection:bg-primary-container selection:text-on-primary-container flex flex-col min-h-screen w-full h-full absolute inset-0 z-50 overflow-y-auto">
      {/* TopNavBar */}
      <nav className="sticky top-0 w-full z-50 bg-[#fcf9f8] dark:bg-slate-900/80 dark:bg-slate-900/80 backdrop-blur-md shadow-sm border-b border-slate-200 dark:border-slate-800/20">
        <div className="flex justify-between items-center px-6 md:px-12 py-4 max-w-7xl mx-auto">
          <a className="flex items-center gap-2 group cursor-pointer" onClick={() => setView('WELCOME')}>
            <div className="w-8 h-8 bg-[#0D2C24] rounded flex items-center justify-center text-white font-serif font-bold text-xs">
              S
            </div>
            <span className="font-serif text-2xl text-[#0D2C24] dark:text-emerald-400 tracking-tight font-bold">SAVE</span>
          </a>
          <div className="hidden md:flex items-center gap-8">
            <a href="#ejemplos" className="font-sans text-sm text-slate-600 dark:text-slate-400 hover:text-[#0D2C24] dark:hover:text-emerald-400 transition-colors duration-200">Catálogo de Plantillas</a>
            <button onClick={() => setView('PRICING')} className="font-sans text-sm text-slate-600 dark:text-slate-400 hover:text-[#0D2C24] dark:hover:text-emerald-400 transition-colors duration-200">Precios</button>
            <button className="font-sans text-sm text-slate-600 dark:text-slate-400 hover:text-[#0D2C24] dark:hover:text-emerald-400 transition-colors duration-200">Cómo Funciona</button>
          </div>
          <div className="flex items-center gap-4">
            <button onClick={() => setIsLoginOpen(true)} className="hidden md:block font-sans font-semibold text-sm text-[#0D2C24] dark:text-emerald-400 hover:text-[#0D2C24]/80 transition-colors duration-200 px-4 py-2 cursor-pointer">Login</button>
            <button onClick={() => setIsLoginOpen(true)} className="bg-[#0D2C24] dark:bg-emerald-600 hover:bg-[#164E3E] text-white font-sans font-semibold text-sm px-6 py-2.5 rounded-full transition-all duration-300 shadow-sm hover:shadow-md cursor-pointer">Empezar Ahora</button>
          </div>
        </div>
      </nav>
      
      <main className="flex-grow">
        {/* Hero Section */}
        <section className="relative px-6 md:px-12 py-20 md:py-32 max-w-7xl mx-auto flex flex-col lg:flex-row items-center gap-12 overflow-hidden">
          {/* Abstract Background Shapes */}
          <div className="absolute inset-0 pointer-events-none -z-10 overflow-hidden">
            <div className="absolute top-[-10%] right-[-5%] w-[600px] h-[600px] rounded-full bg-[#c8eadd]/20 blur-[80px]"></div>
            <div className="absolute bottom-[-10%] left-[-10%] w-[500px] h-[500px] rounded-full bg-[#ffdea5]/30 blur-[100px]"></div>
          </div>
          
          <div className="w-full lg:w-1/2 flex flex-col items-start gap-6 z-10">
            <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-white dark:bg-slate-900/60 border border-slate-200 dark:border-slate-800 text-slate-700 font-sans text-xs font-semibold shadow-sm">
              <span className="w-2 h-2 rounded-full bg-[#0D2C24]"></span>
              Legal Tech para República Dominicana
            </div>
            <h1 className="font-serif text-[#0D2C24] dark:text-emerald-400 max-w-2xl leading-tight text-4xl sm:text-5xl md:text-6xl font-bold">
              Documentos legales, <span className="text-[#ac8944] relative inline-block">
                simplificados.
                <svg className="absolute -bottom-2 left-0 w-full h-3 text-[#e9c176]" preserveAspectRatio="none" viewBox="0 0 100 10">
                  <path d="M0 5 Q 50 10 100 5" fill="none" stroke="currentColor" strokeWidth="3"></path>
                </svg>
              </span>
            </h1>
            <p className="font-sans text-slate-600 dark:text-slate-400 max-w-xl text-lg md:text-xl mt-4 leading-relaxed">
              Plantillas de alta velocidad, revisadas legalmente para el notario y abogado moderno. Redacta, firma y ejecuta con absoluta confianza y sofisticación editorial.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 mt-6 w-full sm:w-auto">
              <a href="#ejemplos" className="bg-[#0D2C24] dark:bg-emerald-600 hover:bg-[#164E3E] dark:hover:bg-emerald-500 text-white font-sans font-semibold text-sm px-8 py-4 rounded-full transition-all duration-300 shadow-md hover:shadow-lg flex items-center justify-center gap-2 group cursor-pointer">
                Explorar Plantillas
                <svg className="w-4 h-4 transition-transform duration-300 group-hover:translate-x-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M14 5l7 7m0 0l-7 7m7-7H3" />
                </svg>
              </a>
              <button onClick={() => setView('PRICING')} className="bg-white dark:bg-slate-900 hover:bg-slate-50 dark:bg-slate-800 text-[#0D2C24] dark:text-emerald-400 font-sans font-semibold text-sm px-8 py-4 rounded-full transition-all duration-300 border border-slate-200 dark:border-slate-800 flex items-center justify-center gap-2 shadow-sm cursor-pointer">
                Ver Planes y Precios
              </button>
            </div>
          </div>
          
          <div className="w-full lg:w-1/2 relative z-10 mt-12 lg:mt-0">
            <div className="relative w-full aspect-[4/3] rounded-2xl overflow-hidden shadow-2xl transition-transform duration-300 hover:-translate-y-1">
              <img className="w-full h-full object-cover" alt="Modern legal office" src="https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&q=80" />
              {/* Floating UI Element */}
              <div className="absolute bottom-6 left-6 right-6 md:right-auto bg-white dark:bg-slate-900/90 backdrop-blur-md border border-white/40 p-4 rounded-xl flex items-center gap-4 shadow-lg">
                <div className="w-10 h-10 rounded-full bg-[#c8eadd] flex items-center justify-center text-[#0D2C24] dark:text-emerald-400">
                  <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>
                <div>
                  <p className="font-sans text-[#0D2C24] dark:text-emerald-400 font-semibold text-sm">Contrato de Alquiler</p>
                  <p className="font-sans text-[13px] text-slate-500 dark:text-slate-400">Verificado &amp; Listo para Firma</p>
                </div>
              </div>
            </div>
          </div>
        </section>
      
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

      </main>
      
      {/* Footer */}
      <footer className="w-full bg-white dark:bg-slate-900 border-t border-slate-200 dark:border-slate-800 mt-auto">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8 px-6 md:px-12 py-16 max-w-7xl mx-auto">
          <div className="flex flex-col gap-4 col-span-1 md:col-span-2">
            <a className="flex items-center gap-2 group cursor-pointer" onClick={() => setView('WELCOME')}>
              <div className="w-8 h-8 bg-[#0D2C24] rounded flex items-center justify-center text-white font-serif font-bold text-xs opacity-90 group-hover:opacity-100 transition-opacity">
                S
              </div>
              <span className="font-serif text-2xl text-[#0D2C24] dark:text-emerald-400 tracking-tight font-bold">SAVE</span>
            </a>
            <p className="font-sans text-sm text-slate-500 dark:text-slate-400 max-w-sm mt-2 leading-relaxed">
              © 2024 SAVE Legal Technologies. Todos los derechos reservados. Brindando soluciones legales modernas con eficiencia de alta velocidad para la República Dominicana.
            </p>
          </div>
          <div className="flex flex-col gap-3">
            <h4 className="font-sans text-sm text-[#0D2C24] dark:text-emerald-400 mb-2 font-bold uppercase tracking-wider">Legal & Cumplimiento</h4>
            <a className="font-sans text-sm text-slate-500 dark:text-slate-400 hover:text-[#0D2C24] dark:hover:text-emerald-300 dark:text-emerald-400 hover:underline transition-all w-fit cursor-pointer">Política de Privacidad</a>
            <a className="font-sans text-sm text-slate-500 dark:text-slate-400 hover:text-[#0D2C24] dark:hover:text-emerald-300 dark:text-emerald-400 hover:underline transition-all w-fit cursor-pointer">Términos de Servicio Notarial</a>
            <a className="font-sans text-sm text-slate-500 dark:text-slate-400 hover:text-[#0D2C24] dark:hover:text-emerald-300 dark:text-emerald-400 hover:underline transition-all w-fit cursor-pointer">Matrícula CARD</a>
          </div>
          <div className="flex flex-col gap-3">
            <h4 className="font-sans text-sm text-[#0D2C24] dark:text-emerald-400 mb-2 font-bold uppercase tracking-wider">Conectar</h4>
            <a className="font-sans text-sm text-slate-500 dark:text-slate-400 hover:text-[#0D2C24] dark:hover:text-emerald-300 dark:text-emerald-400 hover:underline transition-all w-fit cursor-pointer">LinkedIn</a>
            <a className="font-sans text-sm text-slate-500 dark:text-slate-400 hover:text-[#0D2C24] dark:hover:text-emerald-300 dark:text-emerald-400 hover:underline transition-all w-fit cursor-pointer">Twitter</a>
            <a className="font-sans text-sm text-slate-500 dark:text-slate-400 hover:text-[#0D2C24] dark:hover:text-emerald-300 dark:text-emerald-400 hover:underline transition-all w-fit cursor-pointer">Contacto</a>
          </div>
        </div>
      </footer>

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
    </div>
  );
};
