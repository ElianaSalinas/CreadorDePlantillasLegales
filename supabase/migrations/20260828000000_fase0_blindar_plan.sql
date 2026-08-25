-- ==========================================================
-- SA&VE Comercial, S.R.L. — Punta Cana, República Dominicana
-- FASE 0 · D2: cerrar el auto-ascenso a PREMIUM
--
-- La política orgs_update tenía USING pero no WITH CHECK ni
-- restricción de columnas. Como la clave anónima viaja en el
-- bundle del navegador, el titular de un despacho podía hacer
-- un PATCH directo a PostgREST y ponerse:
--
--   sub_status = 'PREMIUM', free_limit = 999999, vault_limit = 999999
--
-- Reproducido contra PostgreSQL 16 antes de escribir esto.
--
-- Se cierra por dos vías independientes, a propósito: si algún
-- día alguien vuelve a conceder privilegios amplios sobre la
-- tabla, el trigger sigue de pie.
-- ==========================================================

-- ---------- 1. Privilegios por columna ----------
-- authenticated solo puede tocar lo que es del despacho, no lo
-- que es del plan. vault_used_count entra porque es un contador
-- de uso que la propia app escribe con el cliente del usuario, y
-- porque el límite real se calcula listando el bucket, no leyendo
-- esta columna: inflarla no da acceso a nada.
REVOKE UPDATE ON public.organizations FROM authenticated;
GRANT  UPDATE (name, is_firm, require_approval, vault_used_count)
  ON public.organizations TO authenticated;

-- ---------- 2. Trigger de respaldo ----------
-- Las columnas de plan y de cuota solo las mueve el rol de
-- servicio (auth.uid() es NULL con la service key) o un admin
-- de SA&VE. docs_generated_count entra aquí porque en la Fase 5
-- será el contador de la cuota gratuita: si el usuario pudiera
-- escribirlo, el límite no valdría nada.
CREATE OR REPLACE FUNCTION public.guard_org_plan_columns()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_uid UUID := auth.uid();
BEGIN
  -- Rol de servicio (sin uid) o admin de SA&VE: pasa sin más.
  IF v_uid IS NULL OR public.is_save_admin(v_uid) THEN
    RETURN NEW;
  END IF;

  IF NEW.owner_id            IS DISTINCT FROM OLD.owner_id
  OR NEW.sub_status          IS DISTINCT FROM OLD.sub_status
  OR NEW.free_limit          IS DISTINCT FROM OLD.free_limit
  OR NEW.vault_limit         IS DISTINCT FROM OLD.vault_limit
  OR NEW.included_members    IS DISTINCT FROM OLD.included_members
  OR NEW.seat_price_dop      IS DISTINCT FROM OLD.seat_price_dop
  OR NEW.docs_generated_count IS DISTINCT FROM OLD.docs_generated_count
  THEN
    RAISE EXCEPTION
      'El plan y los límites de un despacho solo los cambia SA&VE.'
      USING ERRCODE = '42501';
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS guard_org_plan_columns ON public.organizations;

CREATE TRIGGER guard_org_plan_columns
  BEFORE UPDATE ON public.organizations
  FOR EACH ROW
  EXECUTE FUNCTION public.guard_org_plan_columns();

-- ---------- 3. WITH CHECK en la política ----------
-- Impide además reasignar la fila a otro dueño en el propio UPDATE.
DROP POLICY IF EXISTS "orgs_update" ON public.organizations;

CREATE POLICY "orgs_update" ON public.organizations FOR UPDATE
  USING      (auth.uid() = owner_id OR public.is_save_admin(auth.uid()))
  WITH CHECK (auth.uid() = owner_id OR public.is_save_admin(auth.uid()));

COMMENT ON FUNCTION public.guard_org_plan_columns() IS
  'Fase 0 / D2: impide que el titular de un despacho se cambie el plan o los límites por su cuenta.';
