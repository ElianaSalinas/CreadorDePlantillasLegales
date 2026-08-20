# 08 - Backlog Priorizado (Metodología MoSCoW)
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
