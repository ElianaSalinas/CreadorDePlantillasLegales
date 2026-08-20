# 10 - Architecture Decision Records (ADR)
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
**Decisión:** Implementar `master_templates` y `template_versions`.
**Contexto:** Si un administrador SA&VE actualiza el "Contrato de Alquiler", los contratos viejos generados por clientes podrían corromperse si la estructura de JSON/variables cambia.
**Consecuencias:** Mayor carga en base de datos al mantener histórico de JSONs, pero garantía absoluta de trazabilidad legal.
