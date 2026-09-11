-- Permite que un revisor de contenido activo (tabla revisores_contenido)
-- pueda editar/aprobar templates del catálogo MAESTRO (is_master = true).
--
-- Antes, can_edit_template solo devolvía true para:
--   1. usuarios de la organización dueña del template (is_master = false), o
--   2. is_save_admin(uid)
-- Los revisores del catálogo (Cifuentes, Márquez) no caían en ninguno de
-- los dos casos, así que el RLS de template_versions_write bloqueaba el
-- INSERT al intentar congelar una versión al aprobar. Esta es la causa del
-- error visto en producción el 2026-09-11:
--   "new row violates row-level security policy for table
--    'template_versions'"
--
-- No se toca la rama de organizaciones ni la de is_save_admin: se añade
-- una tercera condición con OR. Principio de mínimo cambio.

CREATE OR REPLACE FUNCTION public.can_edit_template(uid uuid, tid uuid)
RETURNS boolean
LANGUAGE sql
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 FROM templates t
    WHERE t.id = tid
      AND (
        (t.is_master = false AND t.org_id IN (SELECT public.user_org_ids(uid)))
        OR public.is_save_admin(uid)
        OR (t.is_master = true AND public.es_revisor_contenido(uid))
      )
  );
$$;