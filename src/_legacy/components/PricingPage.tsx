import React, { useState } from 'react';
import { useAppStore } from '../store/useAppStore';

export const PricingPage: React.FC = () => {
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
    <div className="bg-[#fcf9f8] dark:bg-slate-900 text-[#1c1b1b] min-h-screen flex flex-col font-sans antialiased w-full h-full absolute inset-0 z-50 overflow-y-auto">
      {/* TopNavBar */}
      <header className="sticky top-0 w-full z-50 bg-[#fcf9f8] dark:bg-slate-900/80 backdrop-blur-md shadow-sm border-b border-slate-200 dark:border-slate-800/50">
        <div className="flex justify-between items-center px-6 md:px-12 py-4 max-w-7xl mx-auto">
          <a className="flex items-center gap-2 group cursor-pointer" onClick={() => setView('WELCOME')}>
            <div className="w-8 h-8 bg-[#0D2C24] rounded flex items-center justify-center text-white font-serif font-bold text-xs opacity-90 group-hover:opacity-100 transition-opacity">
              S
            </div>
            <span className="font-serif text-2xl text-[#0D2C24] dark:text-emerald-400 tracking-tight font-bold">SAVE</span>
          </a>
          <nav className="hidden md:flex gap-8 items-center">
            <button onClick={() => setView('TEMPLATES')} className="font-sans text-sm text-slate-600 dark:text-slate-400 hover:text-[#0D2C24] dark:hover:text-emerald-300 dark:text-emerald-400 transition-colors duration-200">Catálogo de Plantillas</button>
            <button className="font-sans text-sm text-[#0D2C24] dark:text-emerald-400 border-b-2 border-[#0D2C24] pb-1 font-bold opacity-80 transition-opacity">Precios</button>
            <button className="font-sans text-sm text-slate-600 dark:text-slate-400 hover:text-[#0D2C24] dark:hover:text-emerald-300 dark:text-emerald-400 transition-colors duration-200">Cómo Funciona</button>
          </nav>
          <div className="flex items-center gap-4">
            <button onClick={() => setView('TEMPLATES')} className="font-sans text-sm font-semibold text-[#0D2C24] dark:text-emerald-400 hover:text-[#46645b] transition-colors cursor-pointer">Login</button>
            <button onClick={() => setView('TEMPLATES')} className="bg-[#0D2C24] text-white font-sans text-sm font-semibold px-6 py-2.5 rounded hover:bg-[#164E3E] transition-colors shadow-sm hidden md:block cursor-pointer">Empezar Ahora</button>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="flex-grow pt-12 pb-24 w-full max-w-7xl mx-auto px-6 md:px-12">
        {/* Header Section */}
        <div className="text-center max-w-3xl mx-auto mb-16 pt-8">
          <h1 className="font-serif text-4xl md:text-5xl text-[#0D2C24] dark:text-emerald-400 font-bold mb-4">
            Precios transparentes para despachos modernos.
          </h1>
          <p className="font-sans text-lg text-slate-600 dark:text-slate-400">
            Elige el plan que se adapte a tu volumen de actos notariales. Sube o baja de plan en cualquier momento con total flexibilidad.
          </p>
        </div>

        {/* Pricing Tiers (Bento-style layout) */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-20 items-end">
          {/* Single Template */}
          <div className="bg-white dark:bg-slate-900 rounded-xl p-8 border border-slate-200 dark:border-slate-800 shadow-sm hover:border-[#adcec1] transition-colors h-full flex flex-col">
            <div className="mb-6">
              <span className="inline-block px-3 py-1 bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 font-sans text-xs font-semibold rounded-full mb-4">Pago por Uso</span>
              <h3 className="font-serif text-2xl text-[#0D2C24] dark:text-emerald-400 font-bold">Plantilla Individual</h3>
              <div className="mt-4 flex items-baseline gap-1">
                <span className="font-serif text-4xl font-bold text-[#0D2C24] dark:text-emerald-400">$19</span>
                <span className="font-sans text-sm text-slate-500 dark:text-slate-400">/documento</span>
              </div>
              <p className="font-sans text-sm text-slate-600 dark:text-slate-400 mt-2">Perfecto para acuerdos únicos y necesidades ocasionales.</p>
            </div>
            <ul className="space-y-4 mb-8 flex-grow">
              <li className="flex items-start gap-3">
                <svg className="w-5 h-5 text-[#C5A059] shrink-0" fill="currentColor" viewBox="0 0 20 20"><path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd"></path></svg>
                <span className="font-sans text-sm text-slate-800 dark:text-slate-200">Acceso a una plantilla notarial a elegir</span>
              </li>
              <li className="flex items-start gap-3">
                <svg className="w-5 h-5 text-[#C5A059] shrink-0" fill="currentColor" viewBox="0 0 20 20"><path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd"></path></svg>
                <span className="font-sans text-sm text-slate-800 dark:text-slate-200">Características básicas del editor</span>
              </li>
              <li className="flex items-start gap-3">
                <svg className="w-5 h-5 text-[#C5A059] shrink-0" fill="currentColor" viewBox="0 0 20 20"><path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd"></path></svg>
                <span className="font-sans text-sm text-slate-800 dark:text-slate-200">Exportación a PDF y Word</span>
              </li>
            </ul>
            <button className="w-full py-3.5 border border-[#0D2C24] text-[#0D2C24] dark:text-emerald-400 font-sans text-sm font-semibold rounded hover:bg-slate-50 dark:bg-slate-800 transition-colors cursor-pointer">Seleccionar Plan</button>
          </div>

          {/* Professional (Highlighted) */}
          <div className="bg-[#0D2C24] rounded-xl p-8 shadow-xl relative h-[105%] flex flex-col transform md:-translate-y-4">
            <div className="absolute top-0 left-1/2 transform -translate-x-1/2 -translate-y-1/2">
              <span className="bg-[#ffdea5] text-[#261900] font-sans text-xs font-bold px-4 py-1.5 rounded-full shadow-sm whitespace-nowrap">Más Popular</span>
            </div>
            <div className="mb-6 mt-2">
              <h3 className="font-serif text-2xl text-white font-bold">Despacho Profesional</h3>
              <div className="mt-4 flex items-baseline gap-1">
                <span className="font-serif text-4xl font-bold text-white">$149</span>
                <span className="font-sans text-sm text-[#adcec1]">/mes</span>
              </div>
              <p className="font-sans text-sm text-[#adcec1] mt-2">Para oficinas y notarios con alto volumen de actos diarios.</p>
            </div>
            <ul className="space-y-4 mb-8 flex-grow">
              <li className="flex items-start gap-3">
                <svg className="w-5 h-5 text-[#ffdea5] shrink-0" fill="currentColor" viewBox="0 0 20 20"><path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd"></path></svg>
                <span className="font-sans text-sm text-white">Acceso ilimitado a todo el catálogo notarial</span>
              </li>
              <li className="flex items-start gap-3">
                <svg className="w-5 h-5 text-[#ffdea5] shrink-0" fill="currentColor" viewBox="0 0 20 20"><path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd"></path></svg>
                <span className="font-sans text-sm text-white">Editor colaborativo con revisión con IA (HITL)</span>
              </li>
              <li className="flex items-start gap-3">
                <svg className="w-5 h-5 text-[#ffdea5] shrink-0" fill="currentColor" viewBox="0 0 20 20"><path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd"></path></svg>
                <span className="font-sans text-sm text-white">Bóveda inmutable de documentos generados</span>
              </li>
              <li className="flex items-start gap-3">
                <svg className="w-5 h-5 text-[#ffdea5] shrink-0" fill="currentColor" viewBox="0 0 20 20"><path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd"></path></svg>
                <span className="font-sans text-sm text-white">Soporte prioritario</span>
              </li>
            </ul>
            <button onClick={() => setIsLoginOpen(true)} className="w-full py-3.5 bg-[#ffdea5] text-[#261900] font-sans text-sm font-bold rounded hover:bg-[#e9c176] transition-colors shadow-sm cursor-pointer">Iniciar Prueba de 14 Días</button>
          </div>

          {/* Enterprise */}
          <div className="bg-white dark:bg-slate-900 rounded-xl p-8 border border-slate-200 dark:border-slate-800 shadow-sm hover:border-[#adcec1] transition-colors h-full flex flex-col">
            <div className="mb-6">
              <h3 className="font-serif text-2xl text-[#0D2C24] dark:text-emerald-400 font-bold">Firma de Abogados</h3>
              <div className="mt-4 flex items-baseline gap-1">
                <span className="font-serif text-4xl font-bold text-[#0D2C24] dark:text-emerald-400">A medida</span>
              </div>
              <p className="font-sans text-sm text-slate-600 dark:text-slate-400 mt-2">Soluciones personalizadas para grandes oficinas y firmas corporativas.</p>
            </div>
            <ul className="space-y-4 mb-8 flex-grow">
              <li className="flex items-start gap-3">
                <svg className="w-5 h-5 text-[#C5A059] shrink-0" fill="currentColor" viewBox="0 0 20 20"><path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd"></path></svg>
                <span className="font-sans text-sm text-slate-800 dark:text-slate-200">Todo lo del plan Profesional</span>
              </li>
              <li className="flex items-start gap-3">
                <svg className="w-5 h-5 text-[#C5A059] shrink-0" fill="currentColor" viewBox="0 0 20 20"><path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd"></path></svg>
                <span className="font-sans text-sm text-slate-800 dark:text-slate-200">Carga e importación de sus propias plantillas en DOCX</span>
              </li>
              <li className="flex items-start gap-3">
                <svg className="w-5 h-5 text-[#C5A059] shrink-0" fill="currentColor" viewBox="0 0 20 20"><path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd"></path></svg>
                <span className="font-sans text-sm text-slate-800 dark:text-slate-200">Gerente de cuenta dedicado</span>
              </li>
              <li className="flex items-start gap-3">
                <svg className="w-5 h-5 text-[#C5A059] shrink-0" fill="currentColor" viewBox="0 0 20 20"><path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd"></path></svg>
                <span className="font-sans text-sm text-slate-800 dark:text-slate-200">SSO y auditoría avanzada</span>
              </li>
            </ul>
            <button className="w-full py-3.5 border border-slate-400 text-slate-800 dark:text-slate-200 font-sans text-sm font-semibold rounded hover:bg-slate-50 dark:bg-slate-800 transition-colors cursor-pointer">Contactar Ventas</button>
          </div>
        </div>
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
              © 2024 SAVE Legal Technologies. Todos los derechos reservados. Brindando soluciones legales modernas con eficiencia de alta velocidad.
            </p>
          </div>
          <div className="flex flex-col gap-3">
            <h4 className="font-sans text-sm text-[#0D2C24] dark:text-emerald-400 mb-2 font-bold uppercase tracking-wider">Legal & Cumplimiento</h4>
            <a className="font-sans text-sm text-slate-500 dark:text-slate-400 hover:text-[#0D2C24] dark:hover:text-emerald-300 dark:text-emerald-400 hover:underline transition-all w-fit cursor-pointer">Política de Privacidad</a>
            <a className="font-sans text-sm text-slate-500 dark:text-slate-400 hover:text-[#0D2C24] dark:hover:text-emerald-300 dark:text-emerald-400 hover:underline transition-all w-fit cursor-pointer">Términos de Servicio Notarial</a>
          </div>
          <div className="flex flex-col gap-3">
            <h4 className="font-sans text-sm text-[#0D2C24] dark:text-emerald-400 mb-2 font-bold uppercase tracking-wider">Conectar</h4>
            <a className="font-sans text-sm text-slate-500 dark:text-slate-400 hover:text-[#0D2C24] dark:hover:text-emerald-300 dark:text-emerald-400 hover:underline transition-all w-fit cursor-pointer">LinkedIn</a>
            <a className="font-sans text-sm text-slate-500 dark:text-slate-400 hover:text-[#0D2C24] dark:hover:text-emerald-300 dark:text-emerald-400 hover:underline transition-all w-fit cursor-pointer">Soporte Técnico</a>
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
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
