const fs = require('fs');
const path = require('path');

const docsDir = path.join(__dirname, 'docs', 'planificacion');

const files = {
  '01-PRD.md': `# 01 - Product Requirements Document (PRD)
**Producto:** SAVE (Sistema Avanzado de Validación y Emisión Documental)
**Empresa:** SA&VE Comercial, S.R.L. (RNC: 132-28618-9)

## 1. Visión del Producto
Transformar la práctica notarial y legal en la República Dominicana mediante una plataforma SaaS que automatice la redacción, validación y gestión de documentos legales, garantizando seguridad jurídica, eficiencia y trazabilidad.

## 2. Objetivos
- **Reducir** el tiempo de redacción de contratos en un 80%.
- **Estandarizar** el formato de actos notariales bajo las leyes de República Dominicana.
- **Minimizar** errores humanos (typos, inconsistencias legales) mediante validaciones asistidas por IA.

## 3. Público Objetivo
- **Abogados Independientes**: Requieren agilidad y acceso remoto.
- **Notarios Públicos**: Necesitan cumplimiento estricto (matrícula CARD) y formatos notariales exactos.
- **Personal Paralegal**: Asistentes que rellenan datos (borradores) pero requieren aprobación final del Abogado.

## 4. Alcance del MVP (Mínimo Producto Viable)
- Autenticación y registro seguro con validación de correo.
- Catálogo de plantillas maestras inmutables.
- Editor de variables estilo "Google Forms".
- Generador de documentos PDF/DOCX con validación en tiempo real.
- Bóveda de almacenamiento seguro (Vault).
`,

  '02-HISTORIAS-DE-USUARIO.md': `# 02 - Historias de Usuario
**Empresa:** SA&VE Comercial, S.R.L.

## Épica 1: Autenticación y Seguridad
- **HU-1.1**: Como abogado, quiero registrarme usando mi correo y contraseña para tener mi cuenta privada.
- **HU-1.2**: Como sistema, quiero verificar el email del usuario mediante un link único para evitar cuentas falsas.
- **HU-1.3**: Como notario, quiero registrar mi número de colegiatura (CARD) para validación de firma.

## Épica 2: Gestión de Plantillas
- **HU-2.1**: Como usuario, quiero ver un catálogo de plantillas predefinidas para no empezar desde cero.
- **HU-2.2**: Como abogado, quiero duplicar una plantilla maestra y personalizarla para guardarla como "Mi Plantilla".

## Épica 3: Edición y Generación
- **HU-3.1**: Como paralegal, quiero ver un formulario simplificado de preguntas (Google Forms style) para generar un contrato sin alterar su estructura.
- **HU-3.2**: Como abogado, quiero una vista dividida (Split View) para ver las variables a la izquierda y el documento a la derecha.

## Épica 4: Almacenamiento (Bóveda)
- **HU-4.1**: Como usuario, quiero guardar mis contratos finalizados en una bóveda segura para consultarlos después.
`,

  '03-REGLAS-DE-NEGOCIO.md': `# 03 - Reglas de Negocio
**Empresa:** SA&VE Comercial, S.R.L.

1. **Unicidad de Cuenta**: Un correo electrónico = Un usuario.
2. **Propiedad (Ownership)**: Un usuario no puede ver, editar ni eliminar los documentos ni plantillas de otro usuario bajo ninguna circunstancia (Multi-tenant isolation).
3. **Roles y Permisos**:
   - *Admin*: Acceso a todo el sistema, gestión de plantillas maestras globales.
   - *Abogado/Notario*: Puede crear, editar, generar y guardar documentos.
   - *Paralegal*: Puede rellenar variables y generar borradores, pero no modificar la estructura de las plantillas del abogado al que está asociado.
4. **Verificación de Email**: Ningún usuario puede exportar un documento final (PDF/DOCX) si no ha verificado su cuenta de correo electrónico.
5. **Inmutabilidad Maestra**: Las plantillas base proveídas por SA&VE Comercial, S.R.L. son inmutables. Si un usuario desea alterarlas, el sistema debe crear una "copia local" en la cuenta del usuario.
`,

  '04-ESPECIFICACION-TECNICA.md': `# 04 - Especificación Técnica
**Empresa:** SA&VE Comercial, S.R.L.

## Arquitectura (Propuesta Post-Auditoría)
- **Frontend**: React (Vite), Tailwind CSS v4, Zustand (State Management), Lucide-React (Icons).
- **Backend / API**: Node.js con Express o NestJS.
- **Base de Datos**: PostgreSQL (Relacional) administrada vía Prisma ORM o Drizzle.
- **Almacenamiento de Archivos (S3)**: AWS S3 o Cloudflare R2 para guardar los PDFs y DOCXs generados.
- **Autenticación**: JWT (JSON Web Tokens) vía cookies \`HttpOnly\`, o plataforma Auth0/Supabase.
- **Servicio de Correos**: SendGrid o AWS SES para links de verificación y recuperación.
- **IA**: Google Gemini API (existente) para análisis de texto y extracción de entidades.

## Flujo de Datos (Data Flow)
1. Cliente interactúa con el Frontend (React).
2. Frontend hace llamada REST a la API (Backend).
3. Backend valida \`Authorization\` y CSRF.
4. Backend verifica ownership de la fila (ej. \`WHERE user_id = req.user.id\`).
5. Backend devuelve JSON o PDF buffer.
`,

  '05-MAPA-DE-NAVEGACION.md': `# 05 - Mapa de Navegación
**Empresa:** SA&VE Comercial, S.R.L.

## 1. Espacio Público (Visitantes)
- \`/\` -> Landing Page (WelcomePage)
- \`/#ejemplos\` -> Muestra estática de plantillas
- \`/pricing\` -> Planes y Precios
- \`/terms\` -> Términos y Condiciones
- \`/privacy\` -> Política de Privacidad

## 2. Autenticación (Modales / Páginas)
- \`/login\` -> Ingresar
- \`/register\` -> Crear Cuenta
- \`/verify-email\` -> Verificación de correo
- \`/forgot-password\` -> Recuperar clave

## 3. Espacio Privado (Dashboard / App)
- \`/app/dashboard\` -> Resumen, Actividad reciente
- \`/app/templates\` -> Catálogo de Plantillas (Grid)
- \`/app/templates/:id\` -> Editor Split-View (Formulario + Preview)
- \`/app/vault\` -> Bóveda de Documentos Finales
- \`/app/settings\` -> Configuración de Perfil y Preferencias
`,

  '06-DISENO-DE-BASE-DE-DATOS.md': `# 06 - Diseño de Base de Datos (Esquema Conceptual)
**Empresa:** SA&VE Comercial, S.R.L.

*Base de Datos Recomendada: PostgreSQL*

## Tablas Principales

### 1. \`users\`
- \`id\` (UUID, PK)
- \`email\` (VARCHAR, UNIQUE)
- \`password_hash\` (VARCHAR)
- \`first_name\` (VARCHAR)
- \`last_name\` (VARCHAR)
- \`phone\` (VARCHAR)
- \`role\` (ENUM: 'ADMIN', 'LAWYER', 'NOTARY', 'PARALEGAL')
- \`email_verified\` (BOOLEAN)
- \`created_at\` (TIMESTAMP)

### 2. \`templates\`
- \`id\` (UUID, PK)
- \`user_id\` (UUID, FK -> users.id, NULL = Plantilla Global de SAVE)
- \`title\` (VARCHAR)
- \`category\` (VARCHAR)
- \`content\` (TEXT o JSONB con estructura de editor)
- \`is_master\` (BOOLEAN)

### 3. \`documents\` (La Bóveda / Vault)
- \`id\` (UUID, PK)
- \`user_id\` (UUID, FK -> users.id)
- \`template_id\` (UUID, FK -> templates.id)
- \`title\` (VARCHAR)
- \`status\` (ENUM: 'DRAFT', 'FINAL')
- \`pdf_url\` (VARCHAR) - Ruta en S3/R2
- \`created_at\` (TIMESTAMP)

### 4. \`sessions\` / \`tokens\`
- Para manejo de recuperación de cuenta y verificación de email.
`,

  '07-GUIA-UI-UX.md': `# 07 - Guía de Interfaz (UI) y Experiencia de Usuario (UX)
**Empresa:** SA&VE Comercial, S.R.L.

## Identidad de Marca y Colores
- **Color Primario (Light Mode)**: Blanco y grises claros perlados (\`#fcf9f8\`, \`bg-slate-50\`).
- **Color Secundario / Acento (Light Mode)**: Verde Botánico (\`#0D2C24\`) y Oro (\`#C5A059\`). *No debe dominar los fondos masivos.*
- **Modo Oscuro (Dark Mode)**: Fondos oscuros (\`slate-900\`) con acentos en \`emerald-400/500/600\`. *Estrictamente prohibido usar azul.*

## Jerarquía Visual
1. **Acciones Primarias**: Botón sólido (\`bg-[#0D2C24]\` en claro, \`bg-emerald-600\` en oscuro).
2. **Acciones Secundarias**: Botón outline o fantasma.
3. **Lectura**: Fuentes *Plus Jakarta Sans* para interfaz y menús. *Libre Caslon Text* para títulos, logotipos y texto legal del documento.

## Responsividad
- En dispositivos móviles (< 768px), la "Vista Dividida" (Split View) colapsa a pestañas (Tabs: "Formulario" y "Documento").
- El Sidebar de navegación colapsa en un menú hamburguesa lateral.
`,

  '08-BACKLOG-MOSCOW.md': `# 08 - Backlog Priorizado (Metodología MoSCoW)
**Empresa:** SA&VE Comercial, S.R.L.

## MUST HAVE (Debe tener para salir a Producción)
- Refactor de la arquitectura a Backend Real (PostgreSQL + API).
- Sistema de Autenticación (JWT, Encriptación de claves).
- Verificación de correo electrónico.
- Aislamiento de datos por usuario (Multi-tenant security).
- Términos y Condiciones, y Aceptación en Registro.
- Catálogo de Plantillas y Bóveda.
- Editor de Variables con Live Preview.

## SHOULD HAVE (Debería tener)
- Integración con pasarela de pago (Stripe/Azul) para los planes de precios.
- Soporte para perfiles Paralegales asociados a un Abogado.
- Generación de DOCX nativo (actualmente hay PDF, se debe pulir exportación a Word).

## COULD HAVE (Podría tener)
- Asistente LLM (Gemini) conversacional para sugerir cláusulas.
- Firma Electrónica Integrada.

## WON'T HAVE (No tendrá por ahora)
- Aplicación Móvil Nativa (iOS/Android). Se usará la web responsive.
`,

  '09-PLAN-DE-PRUEBAS.md': `# 09 - Plan de Pruebas (QA Plan)
**Empresa:** SA&VE Comercial, S.R.L.

## 1. Pruebas Funcionales (E2E)
- **Flujo de Registro**: Crear usuario -> Ver DB -> Entrar link email -> Verificar -> Login exitoso.
- **Flujo Documental**: Crear documento -> Llenar 10 variables -> Exportar PDF -> Verificar guardado en Bóveda.

## 2. Pruebas de Seguridad (PenTest Interno)
- **Autorización Horizontal**: Loguearse como Usuario A. Intentar hacer petición HTTP GET \`/api/documents/{ID_USUARIO_B}\`. Debe retornar 403 o 404.
- **Protección de Rutas**: Acceder a \`/app/templates\` sin token. Debe redirigir a \`/login\`.
- **Inyección SQL / XSS**: Intentar ingresar \`<script>alert(1)</script>\` en el nombre de una variable del contrato.

## 3. Pruebas UI/UX
- Alternar modo claro/oscuro repetidamente para comprobar que no destelle azul.
- Cargar aplicación en resolución de 320px (iPhone SE) y validar que no exista scroll horizontal.
`,

  '10-ADR.md': `# 10 - Architecture Decision Records (ADR)
**Empresa:** SA&VE Comercial, S.R.L.

## ADR-001: Migración de Estado Local a Backend Centralizado
**Contexto**: El MVP almacenaba contratos y plantillas en el \`localStorage\` usando Zustand, lo cual representa un riesgo masivo de pérdida de datos y seguridad.
**Decisión**: Adoptar un Backend en Node.js (Express) con PostgreSQL. Zustand se limitará a manejar el estado temporal de la sesión y UI.
**Consecuencias**: Aumenta el tiempo de desarrollo en 3-4 semanas, pero se garantiza la integridad comercial y el cumplimiento de la Ley 172-13.

## ADR-002: Sustitución de Azul por Emerald en Modo Oscuro
**Contexto**: La plantilla original contenía residuos estéticos genéricos (Azul/Indigo).
**Decisión**: Se purgó globalmente el azul. Se adoptó el \`emerald\` para conservar la identidad verde de la marca SA&VE en ambientes oscuros.
**Consecuencias**: Mejor coherencia de marca, mayor elegancia jurídica.
`,

  '11-PLAN-DE-IMPLEMENTACION.md': `# 11 - Plan de Implementación (Roadmap)
**Empresa:** SA&VE Comercial, S.R.L.

## Fase 1: Backend Foundation (Semanas 1-2)
1. Levantar servidor Express y base de datos PostgreSQL.
2. Definir esquemas (Prisma/Drizzle) según Documento 06.
3. Implementar registro, login, hashing de contraseñas y envío de correos (Verificación).

## Fase 2: Refactor Frontend & Integración API (Semanas 3-4)
1. Modificar Zustand \`useAppStore\` para que consuma endpoints HTTP en lugar de localStorage.
2. Implementar \`LoginModal\` y \`RegisterModal\` reales conectados a la API.
3. Proteger rutas con React Router \`PrivateRoutes\`.

## Fase 3: Core Legal Engine (Semanas 5-6)
1. Conectar guardado de Plantillas y Variables a la DB.
2. Construir la vista real de la "Bóveda" (Vault) listando documentos desde la DB.
3. Integrar guardado de PDF en AWS S3.

## Fase 4: QA, Seguridad y Despliegue (Semanas 7-8)
1. Ejecutar el Plan de Pruebas (Documento 09).
2. Realizar auditoría final de roles y permisos.
3. Despliegue en producción (AWS o Vercel/Render).
`
};

for (const [filename, content] of Object.entries(files)) {
  fs.writeFileSync(path.join(docsDir, filename), content, 'utf8');
}
console.log('11 planning documents created successfully in docs/planificacion');
