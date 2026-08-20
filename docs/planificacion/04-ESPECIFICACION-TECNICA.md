# 04 - Especificación Técnica
**Empresa:** SA&VE Comercial, S.R.L.

## Arquitectura de Aplicación
- **Core Framework:** Next.js (App Router, Server Actions) para Frontend y Backend integrado.
- **Lenguaje:** TypeScript estricto.
- **Estilos:** Tailwind CSS v4 con componentes shadcn/ui o diseño propietario. Lucide-React para iconos.

## Infraestructura y Despliegue
- **Hosting Principal:** Railway (Despliegue del servidor Node.js/Next.js con CI/CD automático desde GitHub).
- **Base de Datos:** Supabase (PostgreSQL 15+). Gestión de relaciones, vistas y RLS (Row Level Security).
- **Almacenamiento de Archivos (Storage):** Supabase Storage para alojar PDFs y DOCXs generados de forma segura (Buckets privados).
- **Comunicaciones y Correos:** Hostinger Mail (vía SMTP en Next.js usando librerías como `nodemailer` o servicios de envío).
- **Procesador de Pagos:** PayPal Checkout REST SDK / Webhooks.

## IA y Procesamiento
- **LLM:** Google Gemini API (existente).
- **Generación de Archivos:** Librerías JS nativas o microservicios para convertir JSON/HTML a PDF y DOCX en el backend.

## Seguridad y Autenticación
- **Auth Provider:** Supabase Auth (o NextAuth.js apoyado en Supabase) manejando validación por correo y sesiones seguras mediante cookies HttpOnly.
- **RBAC (Role-Based Access Control):** Control de acceso manejado a nivel de base de datos usando Supabase RLS policies (ej. `auth.uid() = organization.owner_id`).
