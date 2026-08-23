-- ==========================================================
-- SA&VE Comercial, S.R.L.
-- Migración 4: Bucket privado de la Bóveda (Supabase Storage)
--
-- Convención de rutas: {org_id}/{uuid}-{nombre-archivo}
-- La primera carpeta ES el org_id, y de ahí sale el aislamiento
-- entre despachos.
-- ==========================================================

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'vault',
  'vault',
  false,
  26214400, -- 25 MB por archivo
  ARRAY[
    'application/pdf',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/msword'
  ]
)
ON CONFLICT (id) DO UPDATE
  SET public = false,
      file_size_limit = EXCLUDED.file_size_limit,
      allowed_mime_types = EXCLUDED.allowed_mime_types;

DROP POLICY IF EXISTS "vault_select" ON storage.objects;
DROP POLICY IF EXISTS "vault_insert" ON storage.objects;
DROP POLICY IF EXISTS "vault_update" ON storage.objects;
DROP POLICY IF EXISTS "vault_delete" ON storage.objects;

CREATE POLICY "vault_select" ON storage.objects FOR SELECT
  USING (
    bucket_id = 'vault'
    AND (
      public.is_save_admin(auth.uid())
      OR (storage.foldername(name))[1]::uuid IN (SELECT public.user_org_ids(auth.uid()))
    )
  );

CREATE POLICY "vault_insert" ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'vault'
    AND (storage.foldername(name))[1]::uuid IN (SELECT public.user_org_ids(auth.uid()))
  );

CREATE POLICY "vault_update" ON storage.objects FOR UPDATE
  USING (
    bucket_id = 'vault'
    AND (storage.foldername(name))[1]::uuid IN (SELECT public.user_org_ids(auth.uid()))
  );

CREATE POLICY "vault_delete" ON storage.objects FOR DELETE
  USING (
    bucket_id = 'vault'
    AND (
      public.is_save_admin(auth.uid())
      OR (storage.foldername(name))[1]::uuid IN (SELECT public.user_org_ids(auth.uid()))
    )
  );
