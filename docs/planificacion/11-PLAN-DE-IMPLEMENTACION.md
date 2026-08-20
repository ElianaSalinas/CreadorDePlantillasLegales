# 11 - Plan de Implementación Estratégico (Roadmap V2)
**Empresa:** SA&VE Comercial, S.R.L.

Este plan reemplaza la iteración anterior e integra las plataformas **Next.js, Supabase, Railway y PayPal**, garantizando la construcción real de los flujos del sistema.

## Fase 1: Arquitectura Base y Backend Cloud (Semanas 1-2)
- **Supabase Setup:** Configurar instancia de Supabase. Escribir migraciones SQL para Esquema Multi-tenant (Organizaciones, Usuarios, Roles, Audit Logs). Configurar RLS Policies.
- **Next.js Init:** Inicializar Next.js App Router (TypeScript, Tailwind, Shadcn). Configurar Supabase SSR Auth.
- **Hostinger Mail:** Integrar API SMTP para flujos transaccionales (Magic Links/OTP).
- **Railway:** Configurar el pipeline CI/CD enlazado al repositorio de GitHub para despliegues continuos del proyecto Next.js.

## Fase 2: Auth, Roles y Organización (Semanas 3-4)
- **Portal de Autenticación:** Registro diferenciado (Profesionales vs Asistentes).
- **Gestión de Organización:** Pantalla de configuración donde el Abogado/Notario invita a sus Paralegales y Asistentes al sistema.
- **Implementación del Audit Log:** Interceptor de base de datos o Server Actions que registren cada evento (CREATE, REVIEW, APPROVE) inmutablemente.

## Fase 3: Core Legal Engine y Flujos (Semanas 5-6)
- **Migración del Editor:** Portar la lógica actual de React (Zustand + Split-View) hacia componentes Next.js Server/Client.
- **Carga de Contenido (30-40 Core Templates):** Modelar las plantillas prioritarias del sector Inmobiliario indicadas, implementando el sistema de versionado en DB.
- **Flujo de Aprobación:** Habilitar estados `DRAFT`, `IN_REVIEW` y `FINAL`, notificaciones de campana y bloqueos lógicos por rol.
- **Integración Gemini:** Conectar los Server Actions a la API de Gemini para procesamiento inteligente.

## Fase 4: Bóveda, Pagos y Backoffice Administrativo (Semanas 7-8)
- **Bóveda (Vault):** Subida y enrutamiento seguro de PDFs/DOCXs hacia Supabase Storage Bucket Privado. Implementar limitadores (30 max).
- **PayPal Checkout:** Integrar SDK de PayPal. Webhooks para conmutar estado Freemium (10 plantillas) a Premium.
- **Backoffice Interno:** Construir el panel SA&VE Admin con RBAC separado. Habilitar control para editar plantillas maestras y flexibilizar límites de bóveda a clientes.
