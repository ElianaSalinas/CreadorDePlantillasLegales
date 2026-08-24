import Link from 'next/link'

export default function NotFound() {
  return (
    <>
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Libre+Caslon+Text:ital,wght@0,400;0,700;1,400&family=Plus+Jakarta+Sans:ital,wght@0,200..800;1,200..800&display=swap');

        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
          font-family: 'Plus Jakarta Sans', sans-serif;
          background: #fcf9f8;
          color: #1c1b1b;
          min-height: 100vh;
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: center;
          -webkit-font-smoothing: antialiased;
        }

        .not-found-container {
          text-align: center;
          padding: 40px 20px;
          max-width: 600px;
        }

        .title-404 {
          font-family: 'Libre Caslon Text', serif;
          font-size: clamp(80px, 15vw, 160px);
          font-weight: 700;
          color: #001610;
          line-height: 1;
          margin-bottom: 16px;
          letter-spacing: -0.02em;
        }

        .subtitle {
          font-size: 20px;
          color: #414845;
          margin-bottom: 40px;
          line-height: 1.5;
        }

        .btn-home {
          background: #001610;
          color: #ffffff;
          font-family: 'Plus Jakarta Sans', sans-serif;
          font-size: 16px; font-weight: 600;
          padding: 14px 32px; border-radius: 9999px;
          text-decoration: none;
          transition: all 0.3s;
          display: inline-block;
        }
        .btn-home:hover {
          background: #0d2c24;
          box-shadow: 0 4px 16px rgba(0,22,16,0.25);
        }
      `}</style>
      <div className="not-found-container">
        <h1 className="title-404">404</h1>
        <p className="subtitle">Lo sentimos, la página que buscas no existe o ha sido movida.</p>
        <Link href="/" className="btn-home">
          Volver al Inicio
        </Link>
      </div>
    </>
  )
}
