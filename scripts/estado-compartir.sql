-- Verifica que las migraciones de invitaciones y de documentos privados
-- quedaron aplicadas. Pegar completo en el SQL Editor de Supabase.

SELECT
  'tabla invitaciones'                             AS comprobacion,
  to_regclass('public.invitaciones') IS NOT NULL   AS ok
UNION ALL SELECT
  'tabla document_shares',
  to_regclass('public.document_shares') IS NOT NULL
UNION ALL SELECT
  'funcion doc_compartido_con',
  EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'doc_compartido_con')
UNION ALL SELECT
  'funcion puede_compartir_documento',
  EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'puede_compartir_documento')
UNION ALL SELECT
  'funcion mismo_despacho',
  EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'mismo_despacho')
UNION ALL SELECT
  'perfil PARALEGAL en el enum',
  EXISTS (SELECT 1 FROM pg_enum e JOIN pg_type t ON t.oid = e.enumtypid
          WHERE t.typname = 'professional_role' AND e.enumlabel = 'PARALEGAL')
UNION ALL SELECT
  'perfil INDEPENDIENTE en el enum',
  EXISTS (SELECT 1 FROM pg_enum e JOIN pg_type t ON t.oid = e.enumtypid
          WHERE t.typname = 'professional_role' AND e.enumlabel = 'INDEPENDIENTE')
UNION ALL SELECT
  'documents: 4 politicas (select/insert/update/delete)',
  (SELECT count(*) FROM pg_policies
   WHERE schemaname = 'public' AND tablename = 'documents') = 4
UNION ALL SELECT
  'documents_select ya NO deja ver todo el despacho',
  (SELECT qual::text NOT LIKE '%is_org_member%' FROM pg_policies
   WHERE schemaname = 'public' AND tablename = 'documents' AND policyname = 'documents_select')
UNION ALL SELECT
  'borrar documento: solo autor u owner',
  (SELECT qual::text NOT LIKE '%doc_compartido_con%' FROM pg_policies
   WHERE schemaname = 'public' AND tablename = 'documents' AND policyname = 'documents_delete');

-- Detalle, por si algo sale en false:
SELECT tablename, policyname, cmd, qual::text AS usando, with_check::text AS con_check
FROM pg_policies
WHERE schemaname = 'public' AND tablename IN ('documents','document_shares','invitaciones')
ORDER BY tablename, cmd, policyname;
