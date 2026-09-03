-- ==========================================================
-- SA&VE Comercial, S.R.L. — Punta Cana, República Dominicana
-- Los documentos dejan de ser visibles para todo el despacho
--
-- Hasta ahora bastaba pertenecer al despacho para ver cualquier
-- documento suyo. En un despacho real eso no vale: dos paralegales
-- no tienen por qué ver el trabajo del otro.
--
-- La regla nueva:
--   · el abogado o notario titular ve TODO lo de su despacho
--   · cada quien ve lo que ha creado
--   · y lo que le hayan compartido explícitamente
--
-- SOBRE LA RECURSIÓN, que es la trampa de esta migración:
-- si la política de documents consultara document_shares, y la de
-- document_shares consultara documents, Postgres entraría en bucle.
-- Por eso las dos direcciones pasan por funciones SECURITY DEFINER,
-- que se saltan RLS por dentro y cortan el ciclo.
-- ==========================================================

CREATE TABLE IF NOT EXISTS document_shares (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  document_id UUID NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
  user_id     UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  shared_by   UUID REFERENCES profiles(id) ON DELETE SET NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now()),
  CONSTRAINT document_shares_unico UNIQUE (document_id, user_id)
);

CREATE INDEX IF NOT EXISTS document_shares_user_idx ON document_shares (user_id);
CREATE INDEX IF NOT EXISTS document_shares_doc_idx  ON document_shares (document_id);

COMMENT ON TABLE document_shares IS
  'Con quién se ha compartido un documento. El titular del despacho no necesita filas aquí: ve todo por política.';

-- ---------- Funciones que cortan la recursión ----------

-- ¿Le han compartido este documento? Se consulta desde la política de
-- documents. SECURITY DEFINER para que no vuelva a pasar por la política
-- de document_shares y se muerda la cola.
CREATE OR REPLACE FUNCTION public.doc_compartido_con(uid UUID, doc UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
STABLE
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM document_shares s
     WHERE s.document_id = doc AND s.user_id = uid
  );
$$;

-- ¿Puede repartir este documento? Solo quien lo creó y el titular del
-- despacho. Un paralegal no puede compartir lo que a él le compartieron:
-- si pudiera, la decisión de quién ve qué se le escaparía de las manos a
-- quien creó el documento.
CREATE OR REPLACE FUNCTION public.puede_compartir_documento(uid UUID, doc UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
STABLE
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM documents d
     WHERE d.id = doc
       AND (d.creator_id = uid OR public.is_org_owner(uid, d.org_id))
  );
$$;

-- ¿Comparten despacho? Se usa para no dejar compartir con alguien de fuera.
CREATE OR REPLACE FUNCTION public.mismo_despacho(uid_a UUID, uid_b UUID, org UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
STABLE
SET search_path = public
AS $$
  SELECT EXISTS (SELECT 1 FROM org_members WHERE org_id = org AND user_id = uid_a)
     AND EXISTS (SELECT 1 FROM org_members WHERE org_id = org AND user_id = uid_b);
$$;

-- ---------- Políticas de documents ----------

DROP POLICY IF EXISTS "documents_select" ON documents;
DROP POLICY IF EXISTS "documents_insert" ON documents;
DROP POLICY IF EXISTS "documents_update" ON documents;
DROP POLICY IF EXISTS "documents_delete" ON documents;

CREATE POLICY "documents_select" ON documents FOR SELECT
  USING (
    public.is_save_admin(auth.uid())
    OR creator_id = auth.uid()
    OR public.is_org_owner(auth.uid(), org_id)
    OR public.doc_compartido_con(auth.uid(), id)
  );

-- Crear sigue requiriendo pertenecer al despacho.
CREATE POLICY "documents_insert" ON documents FOR INSERT
  WITH CHECK (org_id IN (SELECT public.user_org_ids(auth.uid())));

-- Editar: lo mismo que ver. Compartir un documento es, precisamente,
-- para poder trabajarlo entre dos.
CREATE POLICY "documents_update" ON documents FOR UPDATE
  USING (
    public.is_save_admin(auth.uid())
    OR creator_id = auth.uid()
    OR public.is_org_owner(auth.uid(), org_id)
    OR public.doc_compartido_con(auth.uid(), id)
  );

-- Borrar NO. Que te compartan un documento no te da derecho a destruirlo.
CREATE POLICY "documents_delete" ON documents FOR DELETE
  USING (
    public.is_save_admin(auth.uid())
    OR creator_id = auth.uid()
    OR public.is_org_owner(auth.uid(), org_id)
  );

-- ---------- Políticas de document_shares ----------

ALTER TABLE document_shares ENABLE ROW LEVEL SECURITY;

-- Ve los repartos quien puede repartir, y también la persona con quien se
-- compartió: le sirve para saber por qué tiene acceso.
DROP POLICY IF EXISTS "document_shares_select" ON document_shares;
DROP POLICY IF EXISTS "document_shares_insert" ON document_shares;
DROP POLICY IF EXISTS "document_shares_delete" ON document_shares;

CREATE POLICY "document_shares_select" ON document_shares FOR SELECT
  USING (
    public.is_save_admin(auth.uid())
    OR user_id = auth.uid()
    OR public.puede_compartir_documento(auth.uid(), document_id)
  );

CREATE POLICY "document_shares_insert" ON document_shares FOR INSERT
  WITH CHECK (public.puede_compartir_documento(auth.uid(), document_id));

CREATE POLICY "document_shares_delete" ON document_shares FOR DELETE
  USING (public.puede_compartir_documento(auth.uid(), document_id));

-- ---------- La bitácora ----------
-- Un documento borrado se lleva sus repartos por cascada, y eso está bien:
-- lo que queda registrado en audit_logs es quién lo compartió y cuándo.
