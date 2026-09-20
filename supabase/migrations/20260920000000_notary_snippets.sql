-- ==========================================================
-- Coletillas notariales guardables (Fase 13.5)
--
-- Por despacho, no por usuario: cualquier miembro las usa al generar un
-- documento, pero solo el titular las crea, edita o borra -mismo
-- criterio que ya rige "Mi despacho" en Configuración (updateOrganization
-- en src/app/app/settings/actions.ts): es una decisión de gobierno del
-- despacho, no de cada persona por separado.
--
-- El texto (`body`) puede usar las mismas {{variables}} que cualquier
-- cláusula del catálogo -no hace falta ningún tipo de variable nuevo-:
-- lo que varía por documento (ciudad, fecha, cantidad de originales) se
-- resuelve solo al generar; lo que es fijo para ese notario (su nombre,
-- su matrícula) se escribe una sola vez, directo en el texto guardado.
-- ==========================================================

CREATE TABLE notary_snippets (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id     UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  title      TEXT NOT NULL,
  body       TEXT NOT NULL,
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX notary_snippets_org_idx ON notary_snippets(org_id);

ALTER TABLE notary_snippets ENABLE ROW LEVEL SECURITY;

-- Cualquier miembro del despacho puede verlas y usarlas al generar.
CREATE POLICY "notary_snippets_select" ON notary_snippets FOR SELECT
  USING (org_id IN (SELECT public.user_org_ids(auth.uid())));

-- Solo el titular las administra.
CREATE POLICY "notary_snippets_insert" ON notary_snippets FOR INSERT
  WITH CHECK (
    org_id IN (SELECT public.user_org_ids(auth.uid()))
    AND EXISTS (SELECT 1 FROM organizations o WHERE o.id = org_id AND o.owner_id = auth.uid())
  );

CREATE POLICY "notary_snippets_update" ON notary_snippets FOR UPDATE
  USING (
    org_id IN (SELECT public.user_org_ids(auth.uid()))
    AND EXISTS (SELECT 1 FROM organizations o WHERE o.id = org_id AND o.owner_id = auth.uid())
  );

CREATE POLICY "notary_snippets_delete" ON notary_snippets FOR DELETE
  USING (
    org_id IN (SELECT public.user_org_ids(auth.uid()))
    AND EXISTS (SELECT 1 FROM organizations o WHERE o.id = org_id AND o.owner_id = auth.uid())
  );
