const fs = require('fs');
const path = require('path');

const docsDir = path.join(__dirname, 'docs', 'planificacion');
if (!fs.existsSync(docsDir)) {
  fs.mkdirSync(docsDir, { recursive: true });
}

const files = {
  '01-PRD.md': `# 01 - Product Requirements Document (PRD)
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
`,

  '02-HISTORIAS-DE-USUARIO.md': `# 02 - Historias de Usuario
**Empresa:** SA&VE Comercial, S.R.L.

## Épica 1: Autenticación, Organizaciones y Perfiles
- **HU-1.1:** Como usuario Profesional, quiero registrarme indicando si soy "Abogado", "Notario" o "Ambos", para habilitar funciones específicas (ej. matrícula CARD).
- **HU-1.2:** Como Profesional, quiero crear una "Organización" e invitar a Paralegales y Asistentes con cuentas y credenciales independientes para mantener trazabilidad.
- **HU-1.3:** Como Paralegal, quiero iniciar sesión en mi propia cuenta y ver los casos asignados a mi Organización.

## Épica 2: Flujo de Aprobación y Trazabilidad (Audit Log)
- **HU-2.1:** Como Paralegal, quiero completar las variables de un contrato y marcarlo como "En Revisión" para que mi Abogado supervisor lo evalúe.
- **HU-2.2:** Como Abogado, quiero recibir una notificación de campana (in-app) cuando un Paralegal envíe un documento a revisión.
- **HU-2.3:** Como Abogado, quiero poder "Aprobar", "Devolver a corrección" o "Finalizar" un documento en revisión.
- **HU-2.4:** Como Administrador de la Organización, quiero ver un Historial de Actividad (Audit Log) detallado que muestre quién y cuándo se creó, editó o aprobó un documento.

## Épica 3: Plantillas y Bóveda (Gestión Documental)
- **HU-3.1:** Como Profesional, quiero modificar una plantilla maestra de SA&VE para que el sistema me genere una copia privada exclusiva para mi organización.
- **HU-3.2:** Como Usuario, quiero importar un archivo propio para que la IA lo convierta en una plantilla inteligente privada.
- **HU-3.3:** Como Administrador SA&VE, quiero crear nuevas versiones de plantillas (Versionado V1.0, V1.1) sin romper los documentos generados previamente con versiones anteriores.
- **HU-3.4:** Como Usuario, quiero una Bóveda (Vault) para guardar hasta 30 documentos (límite base), consultables a futuro.

## Épica 4: Panel de Administración SA&VE (Backoffice)
- **HU-4.1:** Como Super Admin SA&VE, quiero extender el límite de 10 plantillas gratuitas o el límite de bóveda de 30 documentos para un usuario específico.
- **HU-4.2:** Como Administrador Financiero, quiero ver un dashboard con usuarios gratuitos, premium, MRR e ingresos por PayPal.
`,

  '03-REGLAS-DE-NEGOCIO.md': `# 03 - Reglas de Negocio
**Empresa:** SA&VE Comercial, S.R.L.

1. **Aislamiento Organizacional:** Un usuario Paralegal o Asistente solo puede ver y editar los documentos de la Organización a la que pertenece. Las credenciales no se comparten.
2. **Independencia de Rol y Función Legal:** Ser "Notario" es un atributo profesional, no un rol de sistema. Otorga campos adicionales (Matrícula, Notaría) pero opera bajo los mismos privilegios de "Profesional" en cuanto a la organización.
3. **Restricción de Aprobación Paralegal:** Por defecto, los perfiles Paralegales y Asistentes NO pueden marcar un documento como "Aprobado" ni "Finalizado" (a menos que el abogado ajuste la configuración de despacho explícitamente).
4. **Límites Freemium (Hard Limits):** 
   - Límite de generación: 10 documentos derivados de plantillas maestras en el nivel gratuito.
   - Límite de bóveda (Vault): 30 documentos almacenados por cuenta/organización.
   - Ambos límites pueden ser ignorados o alterados por el Super Admin.
5. **Inmutabilidad del Historial (Audit Log):** Los registros del Audit Log son de solo lectura y apéndice continuo. Ni siquiera un administrador de la organización puede borrar un registro de auditoría.
6. **Versionado de Plantillas Maestras:** Una plantilla maestra publicada nunca se sobrescribe. Cualquier modificación administrativa generará una nueva versión (v1.x, v2.x). Los documentos ya creados mantendrán un vínculo con la versión original que usaron.
7. **Marca Blanca Absoluta:** No se permiten marcas de agua de SAVE ni logotipos subidos por usuarios en los documentos exportados finales.
`,

  '04-ESPECIFICACION-TECNICA.md': `# 04 - Especificación Técnica
**Empresa:** SA&VE Comercial, S.R.L.

## Arquitectura de Aplicación
- **Core Framework:** Next.js (App Router, Server Actions) para Frontend y Backend integrado.
- **Lenguaje:** TypeScript estricto.
- **Estilos:** Tailwind CSS v4 con componentes shadcn/ui o diseño propietario. Lucide-React para iconos.

## Infraestructura y Despliegue
- **Hosting Principal:** Railway (Despliegue del servidor Node.js/Next.js con CI/CD automático desde GitHub).
- **Base de Datos:** Supabase (PostgreSQL 15+). Gestión de relaciones, vistas y RLS (Row Level Security).
- **Almacenamiento de Archivos (Storage):** Supabase Storage para alojar PDFs y DOCXs generados de forma segura (Buckets privados).
- **Comunicaciones y Correos:** Hostinger Mail (vía SMTP en Next.js usando librerías como \`nodemailer\` o servicios de envío).
- **Procesador de Pagos:** PayPal Checkout REST SDK / Webhooks.

## IA y Procesamiento
- **LLM:** Google Gemini API (existente).
- **Generación de Archivos:** Librerías JS nativas o microservicios para convertir JSON/HTML a PDF y DOCX en el backend.

## Seguridad y Autenticación
- **Auth Provider:** Supabase Auth (o NextAuth.js apoyado en Supabase) manejando validación por correo y sesiones seguras mediante cookies HttpOnly.
- **RBAC (Role-Based Access Control):** Control de acceso manejado a nivel de base de datos usando Supabase RLS policies (ej. \`auth.uid() = organization.owner_id\`).
`,

  '05-MAPA-DE-NAVEGACION.md': `# 05 - Mapa de Navegación
**Empresa:** SA&VE Comercial, S.R.L.

## 1. Espacio Público (Sitio Web)
- \`/\` -> Landing Page
- \`/#ejemplos\` -> Catálogo público estático
- \`/pricing\` -> Planes y Precios (Botones conectados a PayPal)
- \`/terms\` -> Términos y Condiciones
- \`/privacy\` -> Política de Privacidad

## 2. Portal de Autenticación
- \`/login\` -> Ingresar
- \`/register\` -> Registro multi-paso (Roles: Abogado/Notario)
- \`/verify\` -> Validación de Email (Hostinger SMTP)

## 3. Espacio de Trabajo Profesional (Next.js App)
- \`/app/dashboard\` -> Métricas personales, Notificaciones de Campana
- \`/app/templates\` -> Catálogo de Plantillas con versiones
- \`/app/templates/:id\` -> Editor Documental Inteligente
- \`/app/documents\` -> Bóveda (Vault) y Estado de Documentos
- \`/app/documents/:id/review\` -> Interfaz de Aprobación para Abogados
- \`/app/settings/organization\` -> Gestión de Paralegales e invitaciones
- \`/app/settings/billing\` -> Estado de suscripción, límites (10/30)
- \`/app/audit-log\` -> Trazabilidad y logs del despacho

## 4. Backoffice Administrativo SA&VE
- \`/admin/dashboard\` -> Métricas globales (SaaS)
- \`/admin/users\` -> Modificación de límites (Gracia, Vault), bloqueos
- \`/admin/templates\` -> CMS de plantillas, versionado, publicación
- \`/admin/finance\` -> Visor de ingresos PayPal, MRR (Solo rol Finanzas/Super Admin)
`,

  '06-DISENO-DE-BASE-DE-DATOS.md': `# 06 - Diseño de Base de Datos (Esquema Supabase / PostgreSQL)
**Empresa:** SA&VE Comercial, S.R.L.

## 1. Módulo de Autenticación y Usuarios
\`\`\`sql
-- Extiende auth.users de Supabase
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  email VARCHAR UNIQUE NOT NULL,
  first_name VARCHAR,
  last_name VARCHAR,
  is_lawyer BOOLEAN DEFAULT false,
  is_notary BOOLEAN DEFAULT false,
  card_number VARCHAR, -- Si es notario
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE organizations (
  id UUID PRIMARY KEY,
  owner_id UUID REFERENCES profiles(id),
  name VARCHAR,
  subscription_status VARCHAR, -- FREE, PREMIUM
  documents_generated_count INT DEFAULT 0, -- Para límite de 10
  vault_limit INT DEFAULT 30
);

CREATE TABLE org_members (
  id UUID PRIMARY KEY,
  org_id UUID REFERENCES organizations(id),
  user_id UUID REFERENCES profiles(id),
  role VARCHAR -- 'OWNER', 'PARALEGAL', 'ASSISTANT'
);
\`\`\`

## 2. Módulo Documental
\`\`\`sql
CREATE TABLE master_templates (
  id UUID PRIMARY KEY,
  title VARCHAR,
  category VARCHAR,
  is_premium BOOLEAN,
  current_version UUID
);

CREATE TABLE template_versions (
  id UUID PRIMARY KEY,
  master_id UUID REFERENCES master_templates(id),
  version_number VARCHAR, -- '1.0', '1.1'
  content JSONB,
  created_at TIMESTAMP
);

CREATE TABLE custom_templates (
  -- Para cuando el usuario copia/modifica o crea desde cero
  id UUID PRIMARY KEY,
  org_id UUID REFERENCES organizations(id),
  title VARCHAR,
  content JSONB
);

CREATE TABLE documents (
  id UUID PRIMARY KEY,
  org_id UUID REFERENCES organizations(id),
  creator_id UUID REFERENCES profiles(id),
  template_version_id UUID, -- NULL si es custom
  custom_template_id UUID,
  title VARCHAR,
  status VARCHAR, -- 'DRAFT', 'IN_REVIEW', 'APPROVED', 'FINAL'
  data_payload JSONB,
  storage_path VARCHAR, -- Ruta en Supabase Storage
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
\`\`\`

## 3. Módulo de Trazabilidad y Backoffice
\`\`\`sql
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY,
  org_id UUID REFERENCES organizations(id),
  user_id UUID REFERENCES profiles(id),
  document_id UUID REFERENCES documents(id),
  action VARCHAR, -- 'CREATED', 'EDITED', 'SENT_TO_REVIEW', 'APPROVED'
  timestamp TIMESTAMP DEFAULT NOW()
);

CREATE TABLE save_admins (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  admin_role VARCHAR -- 'SUPER_ADMIN', 'CONTENT', 'FINANCE'
);
\`\`\`
`,

  '07-GUIA-UI-UX.md': `# 07 - Guía de Interfaz (UI) y Experiencia de Usuario (UX)
**Empresa:** SA&VE Comercial, S.R.L.

## Principios Centrales
1. **Verde como Acento Estratégico:** 
   - **Light Mode:** Dominancia de grises y blancos perlados. Verde (\`emerald\`) se reserva para botones de acción principal y Badges de éxito.
   - **Dark Mode:** Fondos \`slate-900\`, acentos en verde \`emerald\`. Cero uso de color azul/índigo para garantizar identidad legal.
2. **Minimalismo Legal (No-Branding):**
   - El visualizador de documentos y las exportaciones (PDF/DOCX) son lienzos completamente limpios. No se incorporan logotipos del usuario ni de SA&VE.

## Interacciones Específicas del MVP
- **Campana de Notificaciones:** En el navbar principal. Recibirá pings asíncronos cuando: 
  - Paralegal -> Envía documento a revisión.
  - Abogado -> Aprueba documento.
- **Modo Editor (Split-View):** Panel izquierdo colapsable para formularios, panel derecho para visualización de renderizado en tiempo real.
- **Panel de Flujo de Trabajo (Workflow):** Un documento mostrará insignias de estado (Borrador, En Revisión, Aprobado). Los abogados verán botones prominentes de "Aprobar" y "Rechazar" en el Header del editor.
`,

  '08-BACKLOG-MOSCOW.md': `# 08 - Backlog Priorizado (Metodología MoSCoW)
**Empresa:** SA&VE Comercial, S.R.L.

## MUST HAVE (Indispensable para Producción MVP)
1. **Migración Arquitectónica:** Portar Frontend a Next.js App Router.
2. **Infraestructura Base:** Configurar Supabase (DB + Storage + Auth) y Despliegue en Railway.
3. **Flujo de Autenticación:** Registro de Profesionales (Abogado/Notario) con validación SMTP vía Hostinger.
4. **Organizaciones y Roles:** Estructura Multi-tenant para soportar Paralegales con credenciales propias.
5. **Generador Documental:** Banco inicial de 30-40 plantillas críticas (Enfoque Real Estate: Compraventa, Alquileres, Poderes, etc.). Versionado de plantillas.
6. **Flujo de Aprobaciones y Audit Log:** Estados del documento (DRAFT a FINAL) y bitácora inmutable de acciones.
7. **Bóveda (Vault):** Almacenamiento seguro en Supabase Storage con límite de 30 documentos.
8. **Monetización Freemium:** Implementación de PayPal Checkout y control estricto de cuota (10 plantillas free).
9. **Backoffice Admin:** Panel RBAC para equipo interno de SA&VE (modificar límites, ver métricas, cargar plantillas).

## SHOULD HAVE (Importante pero postergable unos sprints)
1. Panel Financiero profundo en el Backoffice (MRR tracking directo, etc).
2. Configuraciones de despacho avanzadas (ej. permitir a ciertos asistentes aprobar).

## COULD HAVE (Deseable)
1. Asistente Chatbot LLM integrado en el editor para redacción libre de cláusulas.
2. Reconocimiento óptico (OCR) para importar documentos estáticos y volverlos plantillas.

## WON'T HAVE (Excluido explícitamente de Fase 1)
1. Firma Electrónica Cualificada / DocuSign integrada. (Se exportará para firma externa).
2. White-labeling de documentos (logos custom).
`
};

// Also inject the specific Priority Templates provided by the user into the PRD or Technical spec?
// Added a summary of them in PRD/Backlog. Now creating ADR, QA and Implementation plan

files['09-PLAN-DE-PRUEBAS.md'] = `# 09 - Plan de Pruebas (QA Plan)
**Empresa:** SA&VE Comercial, S.R.L.

## 1. Pruebas de Autorización y Flujo RBAC
- **Caso A (Aprobaciones):** Iniciar sesión como Paralegal, crear un documento y confirmar que el botón "Aprobar/Finalizar" está deshabilitado o invisible. Enviar a revisión. Iniciar sesión como Abogado propietario y aprobar el documento.
- **Caso B (Aislamiento Multi-Tenant):** Obtener el UUID de un documento de la Organización X. Intentar cargarlo (GET) estando autenticado como Paralegal de la Organización Y mediante manipulación de la URL. Esperado: Error 404/403 gestionado por Row Level Security (RLS) de Supabase.

## 2. Pruebas de Límites Comerciales
- **Validación Freemium:** Generar 10 documentos con una cuenta gratuita. Intentar generar el 11vo. Esperado: Modal de Paywall dirigido a PayPal.
- **Bypass de Admin:** Como Super Admin, aumentar el límite de generación a 100 de la cuenta anterior. Verificar que el usuario puede seguir operando.
- **Límite Vault:** Cargar 30 documentos en la bóveda, validar bloqueo de nuevas inserciones sin eliminación previa o actualización de plan.

## 3. Pruebas de Sistema e Integración
- **Correo (Hostinger):** Validación de token único al registrarse. Prueba de expiración de token.
- **Despliegue (Railway):** Pruebas de stress y conexión a Supabase Pooler (PgBouncer) para evitar agotamiento de conexiones de DB.
`;

files['10-ADR.md'] = `# 10 - Architecture Decision Records (ADR)
**Empresa:** SA&VE Comercial, S.R.L.

## ADR-003: Migración de React/Express a Next.js Fullstack
**Decisión:** Abandonar el enfoque de frontend aislado con API Express independiente, unificando todo en Next.js (App Router).
**Contexto:** El requerimiento de máxima seguridad, SSR (Server-Side Rendering) y facilidad de orquestación de APIs demanda un framework maduro.
**Consecuencias:** Simplificación del despliegue en Railway (un solo servicio web en lugar de dos).

## ADR-004: Supabase como Base de Datos y Storage Principal
**Decisión:** Utilizar Supabase (PostgreSQL + S3 compatible Storage) en lugar del provisionamiento nativo de PostgreSQL dentro de Railway.
**Contexto:** Se requiere Row Level Security estricto para las Organizaciones, autenticación out-of-the-box (Auth) y un bucket seguro para los PDFs finales. Supabase ofrece este ecosistema integrado acelerando el MVP.
**Consecuencias:** La app dependerá del API de Supabase, requiriendo su cliente SSR en Next.js.

## ADR-005: Exclusión de Firmas Electrónicas Integradas
**Decisión:** Los documentos se exportarán para firma externa en el MVP.
**Contexto:** La integración de firmas digitales complejas retrasa el go-to-market y excede el scope comercial del MVP priorizado (Freemium + PayPal).
**Consecuencias:** Menor carga técnica en fase 1.

## ADR-006: Versionado Inmutable de Plantillas
**Decisión:** Implementar \`master_templates\` y \`template_versions\`.
**Contexto:** Si un administrador SA&VE actualiza el "Contrato de Alquiler", los contratos viejos generados por clientes podrían corromperse si la estructura de JSON/variables cambia.
**Consecuencias:** Mayor carga en base de datos al mantener histórico de JSONs, pero garantía absoluta de trazabilidad legal.
`;

files['11-PLAN-DE-IMPLEMENTACION.md'] = `# 11 - Plan de Implementación Estratégico (Roadmap V2)
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
- **Flujo de Aprobación:** Habilitar estados \`DRAFT\`, \`IN_REVIEW\` y \`FINAL\`, notificaciones de campana y bloqueos lógicos por rol.
- **Integración Gemini:** Conectar los Server Actions a la API de Gemini para procesamiento inteligente.

## Fase 4: Bóveda, Pagos y Backoffice Administrativo (Semanas 7-8)
- **Bóveda (Vault):** Subida y enrutamiento seguro de PDFs/DOCXs hacia Supabase Storage Bucket Privado. Implementar limitadores (30 max).
- **PayPal Checkout:** Integrar SDK de PayPal. Webhooks para conmutar estado Freemium (10 plantillas) a Premium.
- **Backoffice Interno:** Construir el panel SA&VE Admin con RBAC separado. Habilitar control para editar plantillas maestras y flexibilizar límites de bóveda a clientes.
`;

for (const [filename, content] of Object.entries(files)) {
  fs.writeFileSync(path.join(docsDir, filename), content, 'utf8');
}
console.log('11 detailed planning documents recreated successfully in docs/planificacion');
