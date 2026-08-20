# 09 - Plan de Pruebas (QA Plan)
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
