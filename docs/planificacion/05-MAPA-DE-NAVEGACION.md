# 05 - Mapa de Navegación
**Empresa:** SA&VE Comercial, S.R.L.

## 1. Espacio Público (Sitio Web)
- `/` -> Landing Page
- `/#ejemplos` -> Catálogo público estático
- `/pricing` -> Planes y Precios (Botones conectados a PayPal)
- `/terms` -> Términos y Condiciones
- `/privacy` -> Política de Privacidad

## 2. Portal de Autenticación
- `/login` -> Ingresar
- `/register` -> Registro multi-paso (Roles: Abogado/Notario)
- `/verify` -> Validación de Email (Hostinger SMTP)

## 3. Espacio de Trabajo Profesional (Next.js App)
- `/app/dashboard` -> Métricas personales, Notificaciones de Campana
- `/app/templates` -> Catálogo de Plantillas con versiones
- `/app/templates/:id` -> Editor Documental Inteligente
- `/app/documents` -> Bóveda (Vault) y Estado de Documentos
- `/app/documents/:id/review` -> Interfaz de Aprobación para Abogados
- `/app/settings/organization` -> Gestión de Paralegales e invitaciones
- `/app/settings/billing` -> Estado de suscripción, límites (10/30)
- `/app/audit-log` -> Trazabilidad y logs del despacho

## 4. Backoffice Administrativo SA&VE
- `/admin/dashboard` -> Métricas globales (SaaS)
- `/admin/users` -> Modificación de límites (Gracia, Vault), bloqueos
- `/admin/templates` -> CMS de plantillas, versionado, publicación
- `/admin/finance` -> Visor de ingresos PayPal, MRR (Solo rol Finanzas/Super Admin)
