-- ==========================================================
-- SA&VE Comercial, S.R.L. — Verón, Higüey, La Altagracia
-- FASE 4 · Se invierte el modelo de visibilidad
--
-- El 1 de septiembre se construyó lo contrario: cada quien veía lo
-- suyo y lo que le compartieran. En la práctica un despacho no
-- trabaja así — la gente se pasa expedientes todo el día — y se
-- decidió darle la vuelta:
--
--   TODO EL DESPACHO VE TODO, salvo lo que su autor marque privado.
--
-- No se tira nada de lo anterior. `document_shares` y las tres
-- funciones SECURITY DEFINER siguen igual; lo que cambia es su
-- sentido: antes concedían acceso a un documento cerrado, ahora
-- conceden acceso a un documento PRIVADO. La trampa de recursión que
-- resolvieron sigue resuelta.
-- ==========================================================

-- ---------- La columna, y la línea delicada ----------
--
-- El UPDATE tiene que correr UNA sola vez, la primera. Ponerlo suelto
-- convertiría cada re-ejecución de esta migración en una bomba: volvería
-- a marcar privado TODO, incluido lo que sus autores hubieran abierto al
-- despacho después. Por eso va dentro del IF: si la columna ya existe,
-- este bloque no toca un solo dato.
DO $$
DECLARE ya_existia BOOLEAN;
BEGIN
  SELECT EXISTS (
    SELECT 1 FROM information_schema.columns
     WHERE table_schema = 'public'
       AND table_name   = 'documents'
       AND column_name  = 'es_privado'
  ) INTO ya_existia;

  IF NOT ya_existia THEN
    ALTER TABLE documents ADD COLUMN es_privado BOOLEAN NOT NULL DEFAULT false;

    -- Lo que ya existe se escribió bajo la promesa de que solo lo veía
    -- su autor. Sin esta línea, el día del despliegue el despacho entero
    -- vería documentos redactados creyendo que eran privados. De aquí en
    -- adelante lo nuevo nace visible y quien quiera lo cierra.
    UPDATE documents SET es_privado = true;
  END IF;
END $$;

COMMENT ON COLUMN documents.es_privado IS
  'true = solo lo ven su autor, el titular del despacho y aquellos con quienes se compartió. false (por defecto) = lo ve todo el despacho.';

-- La política filtra por org_id y es_privado en cada lectura de la lista.
CREATE INDEX IF NOT EXISTS documents_org_visibles_idx
  ON documents (org_id)
  WHERE NOT es_privado;

-- ---------- Lectura ----------
--
-- Se añade UNA rama a la política que ya había: pertenecer al despacho
-- basta, siempre que el documento no esté marcado privado.
DROP POLICY IF EXISTS "documents_select" ON documents;

CREATE POLICY "documents_select" ON documents FOR SELECT
  USING (
    public.is_save_admin(auth.uid())
    OR creator_id = auth.uid()
    OR public.is_org_owner(auth.uid(), org_id)
    OR public.doc_compartido_con(auth.uid(), id)
    OR (
      NOT es_privado
      AND org_id IN (SELECT public.user_org_ids(auth.uid()))
    )
  );

-- ---------- Escritura: A PROPÓSITO no cambia ----------
--
-- Ver no es editar. Que el despacho pueda leer el contrato que redactó
-- un compañero no significa que pueda modificarlo: en un documento legal
-- eso es justo lo que no se quiere. Editar sigue siendo del autor, del
-- titular y de aquellos con quienes se compartió expresamente — que es
-- para lo que se comparte, para trabajar entre dos.
--
-- `documents_update` y `documents_delete` se quedan como estaban. Si
-- algún día se decide lo contrario, se cambia aquí y en un solo sitio.

-- ---------- Quién puede abrir y cerrar el candado ----------
--
-- `documents_update` deja editar a quien recibió el documento compartido,
-- y eso está bien: para eso se comparte. Pero cambiar es_privado no es
-- editar el documento, es decidir quién lo ve. Si el destinatario de un
-- documento privado pudiera marcarlo visible, la decisión de su autor
-- duraría lo que tardara el otro en pulsar un botón.
--
-- Va como trigger y no como comprobación en el servidor de la aplicación
-- porque la API de PostgREST está expuesta: cualquiera con su propia
-- sesión puede mandar un UPDATE sin pasar por nuestra pantalla.
CREATE OR REPLACE FUNCTION public.guard_es_privado()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NEW.es_privado IS DISTINCT FROM OLD.es_privado THEN
    IF NOT (
      public.is_save_admin(auth.uid())
      OR OLD.creator_id = auth.uid()
      OR public.is_org_owner(auth.uid(), OLD.org_id)
    ) THEN
      RAISE EXCEPTION 'Solo quien creo el documento, o el titular del despacho, puede cambiar si es privado.'
        USING ERRCODE = 'check_violation';
    END IF;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS documents_guard_es_privado ON documents;
CREATE TRIGGER documents_guard_es_privado
  BEFORE UPDATE ON documents
  FOR EACH ROW EXECUTE FUNCTION public.guard_es_privado();

-- ---------- Comprobación ----------
--
-- Falla en vez de dar por buena una migración que nadie mira.
DO $$
DECLARE
  n_publicos INT;
  tiene_rama BOOLEAN;
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
     WHERE table_schema='public' AND table_name='documents' AND column_name='es_privado'
  ) THEN
    RAISE EXCEPTION 'documents.es_privado no existe';
  END IF;

  SELECT EXISTS (
    SELECT 1 FROM pg_policies
     WHERE schemaname='public' AND tablename='documents' AND policyname='documents_select'
       AND qual LIKE '%es_privado%'
  ) INTO tiene_rama;

  IF NOT tiene_rama THEN
    RAISE EXCEPTION 'documents_select no mira es_privado: la visibilidad de despacho no esta aplicada';
  END IF;

  -- Aviso, no error: si al aplicar esto por primera vez quedara algún
  -- documento visible para el despacho, conviene saberlo antes de que se
  -- entere el despacho.
  SELECT count(*) INTO n_publicos FROM documents WHERE NOT es_privado;
  RAISE NOTICE 'Documentos visibles para todo el despacho: %', n_publicos;
END $$;
