-- ==========================================================
-- SA&VE Comercial, S.R.L.
-- Migración 5: Plan de equipo (BUSINESS) y permisos por miembro
--
-- Modelo de cobro acordado:
--   BUSINESS ......... RD$999/mes, incluye al titular + 1 miembro
--   Miembro extra .... RD$499/mes cada uno, del segundo en adelante
--
-- Si la primera sentencia falla con "cannot run inside a transaction
-- block", ejecútala sola y luego el resto del archivo.
-- ==========================================================

-- 1. NUEVO NIVEL DE SUSCRIPCIÓN
ALTER TYPE sub_status ADD VALUE IF NOT EXISTS 'BUSINESS';

-- 2. ASIENTOS Y PRECIO POR DESPACHO
--    Se guardan por organización, no en el código, para que un admin
--    de SA&VE pueda negociar condiciones distintas con un cliente
--    concreto sin tocar el despliegue.
ALTER TABLE organizations
  ADD COLUMN IF NOT EXISTS included_members INT NOT NULL DEFAULT 1;

ALTER TABLE organizations
  ADD COLUMN IF NOT EXISTS seat_price_dop INT NOT NULL DEFAULT 499;

COMMENT ON COLUMN organizations.included_members IS
  'Miembros (además del titular) que cubre el precio base del plan.';
COMMENT ON COLUMN organizations.seat_price_dop IS
  'Cargo mensual en RD$ por cada miembro que exceda included_members.';

-- 3. PERMISOS POR MIEMBRO
--    El titular decide qué puede hacer cada paralegal o asistente.
--    Un objeto vacío significa "usa los valores por defecto del rol",
--    que resuelve la aplicación en src/lib/permissions.ts.
ALTER TABLE org_members
  ADD COLUMN IF NOT EXISTS permissions JSONB NOT NULL DEFAULT '{}'::jsonb;

COMMENT ON COLUMN org_members.permissions IS
  'Permisos explícitos del miembro. Vacío = valores por defecto del rol.';
