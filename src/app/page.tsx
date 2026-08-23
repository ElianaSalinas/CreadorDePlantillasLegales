import Link from 'next/link'

export default function HomePage() {
  return (
    <>
      {/* Fonts */}
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Libre+Caslon+Text:ital,wght@0,400;0,700;1,400&family=Plus+Jakarta+Sans:ital,wght@0,200..800;1,200..800&display=swap');
        @import url('https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap');

        :root {
          --color-primary: #001610;
          --color-primary-container: #0d2c24;
          --color-on-primary: #ffffff;
          --color-primary-fixed: #c8eadd;
          --color-primary-fixed-dim: #adcec1;
          --color-surface: #fcf9f8;
          --color-surface-container: #f0eded;
          --color-surface-container-high: #eae7e7;
          --color-surface-container-lowest: #ffffff;
          --color-on-surface: #1c1b1b;
          --color-on-surface-variant: #414845;
          --color-outline-variant: #c1c8c4;
          --color-tertiary-container: #352400;
          --color-on-tertiary-container: #ac8944;
          --color-tertiary-fixed-dim: #e9c176;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        html { scroll-behavior: smooth; }
        body {
          font-family: 'Plus Jakarta Sans', sans-serif;
          background: var(--color-surface);
          color: var(--color-on-surface);
          min-height: 100vh;
          display: flex;
          flex-direction: column;
          -webkit-font-smoothing: antialiased;
        }

        /* NAV */
        nav.topbar {
          position: fixed; top: 0; left: 0; right: 0; z-index: 50;
          background: rgba(252,249,248,0.85);
          backdrop-filter: blur(12px);
          -webkit-backdrop-filter: blur(12px);
          border-bottom: 1px solid rgba(193,200,196,0.3);
          box-shadow: 0 1px 8px rgba(0,0,0,0.05);
        }
        .nav-inner {
          display: flex; align-items: center; justify-content: space-between;
          max-width: 1280px; margin: 0 auto;
          padding: 16px 48px;
        }
        @media (max-width: 768px) { .nav-inner { padding: 16px; } }

        .logo-link {
          display: flex; align-items: center; gap: 10px;
          text-decoration: none;
        }
        .logo-icon {
          width: 36px; height: 36px;
          background: var(--color-primary);
          border-radius: 8px;
          display: flex; align-items: center; justify-content: center;
          color: #ffffff;
          font-family: 'Libre Caslon Text', serif;
          font-weight: 700; font-size: 18px;
          transition: transform 0.2s;
        }
        .logo-icon:hover { transform: scale(1.05); }
        .logo-text {
          font-family: 'Libre Caslon Text', serif;
          font-size: 22px; font-weight: 700;
          color: var(--color-primary);
          letter-spacing: -0.02em;
        }

        .nav-links {
          display: flex; gap: 32px; list-style: none;
        }
        @media (max-width: 768px) { .nav-links { display: none; } }
        .nav-links a {
          font-size: 16px; font-weight: 400;
          color: var(--color-on-surface-variant);
          text-decoration: none;
          transition: color 0.2s;
        }
        .nav-links a:hover { color: var(--color-primary); }

        .nav-actions { display: flex; align-items: center; gap: 16px; }
        .btn-ghost {
          background: none; border: none; cursor: pointer;
          font-family: 'Plus Jakarta Sans', sans-serif;
          font-size: 14px; font-weight: 600;
          color: var(--color-primary);
          padding: 8px 16px; border-radius: 9999px;
          transition: background 0.2s; text-decoration: none;
          display: none;
        }
        @media (min-width: 768px) { .btn-ghost { display: block; } }
        .btn-ghost:hover { background: var(--color-surface-container); }

        .btn-primary {
          background: var(--color-primary);
          color: var(--color-on-primary);
          font-family: 'Plus Jakarta Sans', sans-serif;
          font-size: 14px; font-weight: 600;
          padding: 10px 24px; border-radius: 9999px;
          border: none; cursor: pointer;
          transition: all 0.3s;
          box-shadow: 0 2px 8px rgba(0,22,16,0.2);
          text-decoration: none; display: inline-block;
        }
        .btn-primary:hover {
          background: var(--color-primary-container);
          box-shadow: 0 4px 16px rgba(0,22,16,0.25);
        }

        /* HERO */
        main { flex: 1; padding-top: 80px; }
        .hero {
          position: relative; overflow: hidden;
          padding: 80px 48px;
          max-width: 1280px; margin: 0 auto;
          display: flex; align-items: center; gap: 48px;
        }
        @media (max-width: 1024px) {
          .hero { flex-direction: column; padding: 60px 16px; gap: 40px; }
        }

        .blob {
          position: absolute; border-radius: 9999px;
          filter: blur(80px); pointer-events: none; z-index: 0;
        }
        .blob-1 {
          top: -10%; right: -5%;
          width: 500px; height: 500px;
          background: rgba(200,234,221,0.25);
        }
        .blob-2 {
          bottom: -10%; left: -10%;
          width: 400px; height: 400px;
          background: rgba(233,193,118,0.2);
          filter: blur(100px);
        }

        .hero-content {
          flex: 1; z-index: 1;
          display: flex; flex-direction: column; gap: 24px;
        }

        .badge {
          display: inline-flex; align-items: center; gap: 8px;
          padding: 6px 14px; border-radius: 9999px;
          background: var(--color-surface-container-high);
          border: 1px solid rgba(193,200,196,0.5);
          font-size: 12px; font-weight: 500;
          color: var(--color-on-surface-variant);
          width: fit-content;
        }
        .badge-dot {
          width: 8px; height: 8px;
          border-radius: 50%;
          background: var(--color-primary);
        }

        .hero-title {
          font-family: 'Libre Caslon Text', serif;
          font-size: clamp(36px, 5vw, 52px);
          font-weight: 700; line-height: 1.1;
          letter-spacing: -0.02em;
          color: var(--color-primary);
          max-width: 560px;
        }
        .hero-title .accent {
          color: var(--color-tertiary-container);
          position: relative;
        }

        .hero-body {
          font-size: 18px; line-height: 1.7; font-weight: 400;
          color: var(--color-on-surface-variant);
          max-width: 480px;
        }

        .hero-cta {
          display: flex; flex-wrap: wrap; gap: 16px; margin-top: 8px;
        }

        .btn-secondary {
          background: #ffffff;
          color: var(--color-primary);
          font-family: 'Plus Jakarta Sans', sans-serif;
          font-size: 14px; font-weight: 600;
          padding: 14px 32px; border-radius: 9999px;
          border: 1px solid var(--color-outline-variant);
          cursor: pointer; transition: all 0.3s;
          text-decoration: none; display: inline-block;
        }
        .btn-secondary:hover { background: var(--color-surface-container); }

        .btn-hero {
          padding: 14px 32px;
          font-size: 14px; font-weight: 600;
          display: inline-flex; align-items: center; gap: 8px;
        }

        /* HERO IMAGE */
        .hero-image-wrap {
          flex: 1; z-index: 1; position: relative;
          border-radius: 20px; overflow: hidden;
          aspect-ratio: 4/3;
          box-shadow: 0 20px 50px -10px rgba(13,44,36,0.15), 0 8px 16px -8px rgba(13,44,36,0.1);
          transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .hero-image-wrap:hover {
          transform: translateY(-4px);
          box-shadow: 0 30px 60px -10px rgba(13,44,36,0.2), 0 12px 24px -8px rgba(13,44,36,0.12);
        }
        .hero-image-wrap img {
          width: 100%; height: 100%; object-fit: cover; display: block;
        }

        .floating-card {
          position: absolute; bottom: 24px; left: 24px; right: 24px;
          max-width: 280px;
          background: rgba(255,255,255,0.9);
          backdrop-filter: blur(12px); -webkit-backdrop-filter: blur(12px);
          border: 1px solid rgba(255,255,255,0.5);
          border-radius: 14px; padding: 16px;
          display: flex; align-items: center; gap: 16px;
          box-shadow: 0 8px 24px rgba(0,22,16,0.12);
        }
        .floating-card-icon {
          width: 44px; height: 44px; border-radius: 50%;
          background: var(--color-primary-fixed);
          display: flex; align-items: center; justify-content: center;
          color: var(--color-primary); flex-shrink: 0;
          font-size: 22px;
        }
        .floating-card-title {
          font-size: 14px; font-weight: 600;
          color: var(--color-on-surface);
        }
        .floating-card-sub {
          font-size: 13px; font-weight: 400;
          color: var(--color-on-surface-variant);
          margin-top: 2px;
        }

        /* FOOTER */
        footer {
          background: var(--color-surface-container-lowest);
          border-top: 1px solid var(--color-outline-variant);
          margin-top: auto;
        }
        .footer-inner {
          max-width: 1280px; margin: 0 auto;
          padding: 48px;
          display: grid;
          grid-template-columns: 2fr 1fr 1fr;
          gap: 32px;
        }
        @media (max-width: 768px) {
          .footer-inner {
            grid-template-columns: 1fr; padding: 32px 16px;
          }
        }
        .footer-brand { display: flex; flex-direction: column; gap: 16px; }
        .footer-tagline {
          font-size: 14px; line-height: 1.6;
          color: var(--color-on-surface-variant);
          max-width: 320px; margin-top: 8px;
        }
        .footer-col { display: flex; flex-direction: column; gap: 12px; }
        .footer-col-title {
          font-size: 14px; font-weight: 600;
          color: var(--color-primary); margin-bottom: 4px;
        }
        .footer-col a {
          font-size: 14px; color: var(--color-on-surface-variant);
          text-decoration: none; transition: color 0.2s;
          width: fit-content;
        }
        .footer-col a:hover { color: var(--color-primary); text-decoration: underline; }
      `}</style>

      {/* NAV */}
      <nav className="topbar">
        <div className="nav-inner">
          <Link href="/" className="logo-link">
            <div className="logo-icon">S</div>
            <span className="logo-text">Save Documentos</span>
          </Link>

          <ul className="nav-links">
            <li><a href="#plantillas">Plantillas</a></li>
            <li><a href="#precios">Precios</a></li>
            <li><a href="#como-funciona">Cómo funciona</a></li>
          </ul>

          <div className="nav-actions">
            <Link href="/login" className="btn-ghost">Iniciar sesión</Link>
            <Link href="/register" className="btn-primary">Comenzar</Link>
          </div>
        </div>
      </nav>

      {/* MAIN */}
      <main>
        <section className="hero">
          {/* Background blobs */}
          <div className="blob blob-1" aria-hidden="true" />
          <div className="blob blob-2" aria-hidden="true" />

          {/* Left content */}
          <div className="hero-content">
            <div className="badge">
              <span className="badge-dot" />
              Tecnología Legal Moderna
            </div>

            <h1 className="hero-title">
              Documentos legales,{' '}
              <span className="accent">
                simplificados.
                <svg
                  style={{ position: 'absolute', bottom: '-8px', left: 0, width: '100%', height: '12px', color: '#e9c176' }}
                  viewBox="0 0 100 10"
                  preserveAspectRatio="none"
                  aria-hidden="true"
                >
                  <path d="M0 5 Q 50 10 100 5" fill="none" stroke="currentColor" strokeWidth="3" />
                </svg>
              </span>
            </h1>

            <p className="hero-body">
              Plantillas legales de alta calidad, revisadas por expertos, diseñadas para el profesional dominicano moderno. Redacta, firma y ejecuta con total confianza y precisión.
            </p>

            <div className="hero-cta">
              <Link href="/register" className="btn-primary btn-hero">
                Explorar Plantillas
                <span style={{ fontSize: '18px', fontFamily: 'Material Symbols Outlined', fontWeight: '300' }}>arrow_forward</span>
              </Link>
              <Link href="/register" className="btn-secondary">
                Ver Precios
              </Link>
            </div>
          </div>

          {/* Right image */}
          <div className="hero-image-wrap">
            <img
              src="https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?w=900&q=80"
              alt="Oficina moderna con laptop mostrando Save Documentos"
            />
            {/* Floating card */}
            <div className="floating-card">
              <div className="floating-card-icon">
                <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                  <polyline points="22 4 12 14.01 9 11.01"/>
                </svg>
              </div>
              <div>
                <p className="floating-card-title">Plantilla de Contrato</p>
                <p className="floating-card-sub">Revisada y Lista para Firmar</p>
              </div>
            </div>
          </div>
        </section>
      </main>

      {/* FOOTER */}
      <footer>
        <div className="footer-inner">
          <div className="footer-brand">
            <Link href="/" className="logo-link">
              <div className="logo-icon" style={{ filter: 'grayscale(0.3)', opacity: 0.85 }}>S</div>
              <span className="logo-text">Save Documentos</span>
            </Link>
            <p className="footer-tagline">
              © 2026 Save Documentos. Todos los derechos reservados.<br />
              Soluciones legales modernas para profesionales dominicanos.
            </p>
          </div>

          <div className="footer-col">
            <span className="footer-col-title">Legal</span>
            <a href="#">Política de Privacidad</a>
            <a href="#">Términos de Servicio</a>
            <a href="#">Política de Cookies</a>
          </div>

          <div className="footer-col">
            <span className="footer-col-title">Contacto</span>
            <a href="#">LinkedIn</a>
            <a href="#">Twitter</a>
            <a href="#">Facebook</a>
          </div>
        </div>
      </footer>
    </>
  )
}
