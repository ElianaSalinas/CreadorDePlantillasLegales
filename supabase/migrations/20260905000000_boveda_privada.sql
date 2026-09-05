-- ==========================================================
-- SA&VE Comercial, S.R.L. — Punta Cana, República Dominicana
-- FASE 1 · La bóveda deja de ser de todos
--
-- Hasta ahora las políticas del bucket aislaban por `org_id` y nada más:
-- todos los miembros del despacho veían todo lo que subiera cualquiera.
-- No se notaba porque la bóveda está vacía; en cuanto se suba el primer
-- archivo, sí.
--
-- LA REGLA
--
-- Cada archivo nace privado. Lo ven su dueño y el titular del despacho,
-- que es la excepción explícita. El dueño puede hacerlo visible para el
-- resto del despacho cuando quiera.
--
-- El titular es excepción a propósito, y eso obliga a cuidar el lenguaje
-- de la interfaz: llamar "Privado" a secas a un archivo que su jefa sí
-- ve sería prometer de más. En pantalla dice "Solo tú y el titular".
--
-- POR QUÉ NO SE TOCAN LAS RUTAS
--
-- La tentación es pasar a {org_id}/{user_id}/archivo. No hace falta: el
-- cupo se cuenta por despacho, no por persona, y quién subió qué se
-- guarda en esta tabla. Cambiar la convención obligaría a mover lo ya
-- subido y a reescribir cada comprobación de prefijo que hay en el
-- código, a cambio de nada.
-- ==========================================================

CREATE TABLE IF NOT EXISTS boveda_archivos (
  ruta                  TEXT PRIMARY KEY,
  org_id                UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  subido_por            UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  visible_para_despacho BOOLEAN NOT NULL DEFAULT false,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now())
);

COMMENT ON TABLE boveda_archivos IS
  'Quién subió cada archivo de la bóveda y si lo comparte con su despacho. La ruta es la del objeto en Storage: {org_id}/{uuid}__nombre.';
COMMENT ON COLUMN boveda_archivos.visible_para_despacho IS
  'false = solo su dueño y el titular. true = todo el despacho.';

CREATE INDEX IF NOT EXISTS boveda_archivos_org_idx ON boveda_archivos (org_id);
CREATE INDEX IF NOT EXISTS boveda_archivos_duenio_idx ON boveda_archivos (subido_por);

ALTER TABLE boveda_archivos ENABLE ROW LEVEL SECURITY;

-- ==========================================================
-- QUIÉN VE QUÉ
-- ==========================================================

CREATE OR REPLACE FUNCTION public.boveda_puedo_ver(ruta TEXT, uid UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_org  UUID;
  v_fila RECORD;
BEGIN
  IF uid IS NULL THEN
    RETURN false;
  END IF;

  IF public.is_save_admin(uid) THEN
    RETURN true;
  END IF;

  -- La primera carpeta de la ruta es el despacho.
  BEGIN
    v_org := split_part(ruta, '/', 1)::uuid;
  EXCEPTION WHEN OTHERS THEN
    RETURN false;
  END;

  IF NOT EXISTS (SELECT 1 FROM org_members m WHERE m.org_id = v_org AND m.user_id = uid) THEN
    RETURN false;
  END IF;

  -- El titular del despacho es la excepción: ve todo lo suyo y lo de su gente.
  IF public.is_org_owner(uid, v_org) THEN
    RETURN true;
  END IF;

  SELECT * INTO v_fila FROM boveda_archivos WHERE boveda_archivos.ruta = boveda_puedo_ver.ruta;

  -- Sin ficha es un archivo anterior a esta migración: se subió cuando la
  -- bóveda era de todo el despacho, y se respeta esa promesa. Cambiarla
  -- por sorpresa escondería archivos que su gente ya usaba.
  IF NOT FOUND THEN
    RETURN true;
  END IF;

  RETURN v_fila.subido_por = uid OR v_fila.visible_para_despacho;
END;
$$;

REVOKE ALL ON FUNCTION public.boveda_puedo_ver(TEXT, UUID) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.boveda_puedo_ver(TEXT, UUID) TO authenticated;

-- ---------- La ficha del archivo ----------
DROP POLICY IF EXISTS "boveda_archivos_select" ON boveda_archivos;
DROP POLICY IF EXISTS "boveda_archivos_insert" ON boveda_archivos;
DROP POLICY IF EXISTS "boveda_archivos_update" ON boveda_archivos;
DROP POLICY IF EXISTS "boveda_archivos_delete" ON boveda_archivos;

CREATE POLICY "boveda_archivos_select" ON boveda_archivos FOR SELECT
  USING (public.boveda_puedo_ver(ruta, auth.uid()));

CREATE POLICY "boveda_archivos_insert" ON boveda_archivos FOR INSERT
  WITH CHECK (
    subido_por = auth.uid()
    AND org_id IN (SELECT public.user_org_ids(auth.uid()))
  );

-- Solo el dueño cambia la visibilidad de lo suyo. El titular ve todo,
-- pero no decide por otro si su archivo se comparte.
CREATE POLICY "boveda_archivos_update" ON boveda_archivos FOR UPDATE
  USING (subido_por = auth.uid() OR public.is_save_admin(auth.uid()))
  WITH CHECK (subido_por = auth.uid() OR public.is_save_admin(auth.uid()));

CREATE POLICY "boveda_archivos_delete" ON boveda_archivos FOR DELETE
  USING (
    subido_por = auth.uid()
    OR public.is_org_owner(auth.uid(), org_id)
    OR public.is_save_admin(auth.uid())
  );

-- ==========================================================
-- LAS POLÍTICAS DEL BUCKET
-- ==========================================================

DROP POLICY IF EXISTS "vault_select" ON storage.objects;
DROP POLICY IF EXISTS "vault_insert" ON storage.objects;
DROP POLICY IF EXISTS "vault_update" ON storage.objects;
DROP POLICY IF EXISTS "vault_delete" ON storage.objects;

CREATE POLICY "vault_select" ON storage.objects FOR SELECT
  USING (bucket_id = 'vault' AND public.boveda_puedo_ver(name, auth.uid()));

CREATE POLICY "vault_insert" ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'vault'
    AND (storage.foldername(name))[1]::uuid IN (SELECT public.user_org_ids(auth.uid()))
  );

CREATE POLICY "vault_update" ON storage.objects FOR UPDATE
  USING (bucket_id = 'vault' AND public.boveda_puedo_ver(name, auth.uid()));

-- Borrar es del dueño del archivo y del titular del despacho. Un
-- compañero que ve un archivo compartido no puede eliminarlo, igual que
-- pasa con los documentos.
CREATE POLICY "vault_delete" ON storage.objects FOR DELETE
  USING (
    bucket_id = 'vault'
    AND (
      public.is_save_admin(auth.uid())
      OR public.is_org_owner(auth.uid(), (storage.foldername(name))[1]::uuid)
      OR EXISTS (
           SELECT 1 FROM boveda_archivos b
            WHERE b.ruta = name AND b.subido_por = auth.uid())
    )
  );
