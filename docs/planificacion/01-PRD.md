# 01 - Product Requirements Document (PRD)
**Producto:** SAVE (Sistema Avanzado de Validación y Emisión Documental)
**Empresa:** SA&VE Comercial, S.R.L. (RNC: 132-28618-9)

## 1. Visión del Producto
Transformar la práctica legal y notarial en República Dominicana mediante una plataforma SaaS (Software as a Service) especializada en redacción automatizada. El sistema reducirá los tiempos operativos de abogados y notarías integrando Inteligencia Artificial, flujos de aprobación internos (Paralegal -> Abogado) y gestión documental segura, comenzando con un enfoque profundo en el sector Inmobiliario (SAVE DL Real Estate).

## 2. Modelo de Negocio (MVP)
- **Monetización:** Modelo Freemium.
  - **Capa Gratuita:** 10 plantillas gratuitas por usuario.
  - **Suscripción Premium:** Pagos procesados a través de **PayPal**.
  - **Administración:** El equipo interno de SA&VE puede extender el límite gratuito, volverlo indefinido o gestionar la cuenta de forma granular desde el panel de Super Admin.
- **Personalización:** Marca blanca estandarizada. Los documentos se generan limpios, sin marcas de agua de SAVE y sin logotipos personalizados del abogado.

## 3. Alcance Funcional del MVP
- **Migración Arquitectónica:** Transición del stack actual (React SPA + Express) a **Next.js Fullstack**.
- **Perfiles Modulares:** Separación arquitectónica entre Profesionales (Abogado/Notario) y Asistentes (Paralegales).
- **Flujos de Aprobación:** Ciclo de vida estricto del documento (Borrador -> En Revisión -> Aprobado -> Finalizado).
- **Plantillas Prioritarias:** Lanzamiento inicial con un banco de 30-40 plantillas críticas enfocadas en Derecho Inmobiliario, Societario y Cobros.
- **Firmas:** En esta fase (V1), NO se incluirá integración nativa con firma electrónica. El usuario descargará el documento (PDF/DOCX) para firma externa.
