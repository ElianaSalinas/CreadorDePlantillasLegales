-- ==========================================================
-- SA&VE Comercial, S.R.L. — Punta Cana, República Dominicana
-- FASE 1 · Los tres planes, aplicados de verdad
--
-- POR QUÉ ESTA MIGRACIÓN EXISTE
--
-- Hasta hoy no se aplicaba ningún límite. `free_limit` y `vault_limit`
-- estaban en la tabla y se pintaban en pantalla, pero solo la bóveda
-- comprobaba el suyo: no había tope de documentos de ninguna clase, ni
-- control de qué plantillas ve cada plan. Un despacho pagando RD$1,699
-- tenía exactamente las mismas restricciones que uno gratuito: ninguna.
--
-- DÓNDE VIVEN LOS NÚMEROS
--
-- En una tabla, no repartidos entre el código y la base. La tentación
-- es ponerlos en billing.ts y comprobarlos en las Server Actions, pero
-- entonces el trigger que protege la tabla no los conoce y acaban
-- divergiendo: la aplicación diciendo 30 y la base dejando pasar 40.
-- Aquí manda `planes`, y tanto la aplicación como el trigger la leen.
--
-- QUÉ NO HACE
--
-- No cobra. PayPal es la fase 9. Esto solo hace que los límites
-- signifiquen algo cuando llegue el momento de cobrarlos.
-- ==========================================================

-- ==========================================================
-- 1. LOS PLANES
-- ==========================================================

CREATE TABLE IF NOT EXISTS planes (
  codigo                TEXT PRIMARY KEY,
  nombre                TEXT    NOT NULL,
  precio_dop            INT     NOT NULL DEFAULT 0,

  -- NULL significa "sin límite", no cero. Cero es un límite de verdad.
  plantillas_catalogo   INT,
  documentos_por_mes    INT,

  boveda_base           INT     NOT NULL DEFAULT 0,
  boveda_por_integrante INT     NOT NULL DEFAULT 0,

  integrantes_incluidos INT     NOT NULL DEFAULT 0,  -- además del titular
  precio_asiento_dop    INT     NOT NULL DEFAULT 0,

  permite_equipo        BOOLEAN NOT NULL DEFAULT false,
  permite_importar      BOOLEAN NOT NULL DEFAULT false,
  orden                 INT     NOT NULL DEFAULT 0
);

COMMENT ON TABLE planes IS
  'Única fuente de los límites. La aplicación y los triggers leen de aquí; no se duplican en el código.';
COMMENT ON COLUMN planes.plantillas_catalogo IS
  'Cuántas del catálogo maestro se ven. NULL = todas.';
COMMENT ON COLUMN planes.documentos_por_mes IS
  'Tope mensual de documentos generados. NULL = sin tope. 0 = ninguno (cuenta suspendida).';
COMMENT ON COLUMN planes.boveda_por_integrante IS
  'Cuánto crece la bóveda por cada integrante POR ENCIMA de los incluidos.';

INSERT INTO planes (codigo, nombre, precio_dop, plantillas_catalogo, documentos_por_mes,
                    boveda_base, boveda_por_integrante, integrantes_incluidos,
                    precio_asiento_dop, permite_equipo, permite_importar, orden)
VALUES
  ('FREE',      'Gratis',  0,    50,   5,    10,   0,  0,   0, false, false, 1),
  ('PREMIUM',   'Pro',     999,  NULL, 30,   30,   0,  0,   0, false, true,  2),
  ('BUSINESS',  'Equipo',  1699, NULL, NULL, 100,  30, 2, 399, true,  true,  3),

  -- Cuenta sin pagar pasado el periodo de gracia. No se borra nada: se
  -- deja de poder crear y la bóveda queda en solo lectura. Cero como
  -- tope de bóveda no impide leer ni descargar, solo subir.
  ('CANCELLED', 'Suspendido', 0, 50,   0,    0,    0,  0,   0, false, false, 4)
ON CONFLICT (codigo) DO UPDATE SET
  nombre = EXCLUDED.nombre,
  precio_dop = EXCLUDED.precio_dop,
  plantillas_catalogo = EXCLUDED.plantillas_catalogo,
  documentos_por_mes = EXCLUDED.documentos_por_mes,
  boveda_base = EXCLUDED.boveda_base,
  boveda_por_integrante = EXCLUDED.boveda_por_integrante,
  integrantes_incluidos = EXCLUDED.integrantes_incluidos,
  precio_asiento_dop = EXCLUDED.precio_asiento_dop,
  permite_equipo = EXCLUDED.permite_equipo,
  permite_importar = EXCLUDED.permite_importar,
  orden = EXCLUDED.orden;

ALTER TABLE planes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "planes_select" ON planes;
-- Los planes son públicos: la página de precios los enseña.
CREATE POLICY "planes_select" ON planes FOR SELECT USING (true);

-- ==========================================================
-- 2. EL PERIODO DE GRACIA
-- ==========================================================

ALTER TABLE organizations ADD COLUMN IF NOT EXISTS impago_desde TIMESTAMPTZ;

COMMENT ON COLUMN organizations.impago_desde IS
  'Cuándo falló el cobro. Siete días de gracia desde esta fecha; pasados, la cuenta se suspende. NULL = al día.';

CREATE OR REPLACE FUNCTION public.org_en_gracia(org UUID)
RETURNS BOOLEAN LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT COALESCE(
    (SELECT impago_desde IS NOT NULL
        AND impago_desde > timezone('utc', now()) - INTERVAL '7 days'
       FROM organizations WHERE id = org),
    false);
$$;

CREATE OR REPLACE FUNCTION public.org_suspendida(org UUID)
RETURNS BOOLEAN LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT COALESCE(
    (SELECT impago_desde IS NOT NULL
        AND impago_desde <= timezone('utc', now()) - INTERVAL '7 days'
       FROM organizations WHERE id = org),
    false);
$$;

-- ==========================================================
-- 3. QUÉ PLAN RIGE, Y CUÁNTO DA
-- ==========================================================

/* El plan efectivo: el contratado, salvo que la cuenta esté suspendida
   por impago, en cuyo caso rigen los límites de CANCELLED. Durante los
   siete días de gracia se sigue trabajando con normalidad. */
CREATE OR REPLACE FUNCTION public.plan_efectivo(org UUID)
RETURNS TEXT LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT CASE
    WHEN public.org_suspendida(org) THEN 'CANCELLED'
    ELSE COALESCE((SELECT sub_status::text FROM organizations WHERE id = org), 'FREE')
  END;
$$;

CREATE OR REPLACE FUNCTION public.limite_boveda(org UUID)
RETURNS INT LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT p.boveda_base
       + p.boveda_por_integrante
         * GREATEST(0, (SELECT COUNT(*)::int FROM org_members m WHERE m.org_id = org)
                       - (p.integrantes_incluidos + 1))
    FROM planes p
   WHERE p.codigo = public.plan_efectivo(org);
$$;

COMMENT ON FUNCTION public.limite_boveda(UUID) IS
  'Equipo: los 100 de base ya cubren al titular y a los dos incluidos; del cuarto integrante en adelante suma 30 por cabeza.';

CREATE OR REPLACE FUNCTION public.documentos_este_mes(org UUID)
RETURNS INT LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT COUNT(*)::int FROM documents
   WHERE org_id = org
     AND created_at >= date_trunc('month', timezone('utc', now()));
$$;

COMMENT ON FUNCTION public.documentos_este_mes(UUID) IS
  'Se cuenta, no se guarda. Un contador en una columna se desincroniza en cuanto algo falla a medias; una consulta no puede.';

CREATE OR REPLACE FUNCTION public.limite_documentos_mes(org UUID)
RETURNS INT LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT p.documentos_por_mes FROM planes p WHERE p.codigo = public.plan_efectivo(org);
$$;

-- ==========================================================
-- 4. EL TOPE, DONDE NO SE PUEDE ESQUIVAR
--
--    La Server Action ya comprueba y da un mensaje decente. Esto es la
--    segunda puerta: si alguien llamara a la API con la clave anónima,
--    la fila sigue sin dejarse insertar.
-- ==========================================================

CREATE OR REPLACE FUNCTION public.guard_tope_documentos()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_limite INT;
  v_usados INT;
BEGIN
  -- Sin sesión (migraciones, tareas del servidor) no se aplica el tope.
  IF auth.uid() IS NULL OR public.is_save_admin(auth.uid()) THEN
    RETURN NEW;
  END IF;

  IF public.org_suspendida(NEW.org_id) THEN
    RAISE EXCEPTION 'La cuenta está suspendida por falta de pago. Puedes leer y descargar lo que ya tienes, pero no crear documentos nuevos.'
      USING ERRCODE = '42501';
  END IF;

  v_limite := public.limite_documentos_mes(NEW.org_id);
  IF v_limite IS NULL THEN
    RETURN NEW;
  END IF;

  v_usados := public.documentos_este_mes(NEW.org_id);
  IF v_usados >= v_limite THEN
    RAISE EXCEPTION 'Has llegado al tope de % documentos de este mes. Se renueva el día 1.', v_limite
      USING ERRCODE = '42501';
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS guard_tope_documentos ON documents;
CREATE TRIGGER guard_tope_documentos
  BEFORE INSERT ON documents
  FOR EACH ROW EXECUTE FUNCTION public.guard_tope_documentos();

-- ==========================================================
-- 5. LAS 50 PLANTILLAS DEL PLAN GRATIS
-- ==========================================================

ALTER TABLE templates ADD COLUMN IF NOT EXISTS es_gratuita BOOLEAN NOT NULL DEFAULT false;
CREATE INDEX IF NOT EXISTS templates_gratuitas_idx ON templates(es_gratuita) WHERE is_master;

/* Las más usadas, con una salvedad para el arranque.
   Hoy hay cero documentos generados, así que un ranking por uso saldría
   vacío o al azar. Mientras una plantilla no tenga uso, el desempate es
   por categoría: se toma la mejor de cada una, luego la segunda de cada
   una, y así. El escaparate gratuito cubre las once categorías desde el
   primer día en vez de ser cincuenta contratos de vehículos, y en cuanto
   haya uso real el ranking lo corrige solo. */
CREATE OR REPLACE FUNCTION public.recalcular_plantillas_gratuitas(cuantas INT DEFAULT 50)
RETURNS INT LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_marcadas INT;
BEGIN
  WITH uso AS (
    SELECT t.id,
           t.category_id,
           t.title,
           (SELECT COUNT(*) FROM documents d WHERE d.template_id = t.id) AS veces
      FROM templates t
     WHERE t.is_master = true
       AND t.status = 'PUBLISHED'
  ),
  ordenadas AS (
    SELECT id,
           ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY veces DESC, title) AS puesto_en_categoria,
           veces
      FROM uso
  ),
  elegidas AS (
    SELECT id FROM ordenadas
     ORDER BY puesto_en_categoria, veces DESC
     LIMIT cuantas
  )
  UPDATE templates t
     SET es_gratuita = (t.id IN (SELECT id FROM elegidas))
   WHERE t.is_master = true;

  SELECT COUNT(*) INTO v_marcadas FROM templates WHERE is_master AND es_gratuita;
  RETURN v_marcadas;
END;
$$;

-- Primera pasada. Hoy devuelve 0 porque no hay ninguna publicada todavía;
-- volverá a lanzarse cuando la abogada empiece a aprobar.
SELECT public.recalcular_plantillas_gratuitas();

CREATE OR REPLACE FUNCTION public.ve_catalogo_completo(uid UUID)
RETURNS BOOLEAN LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (
    SELECT 1
      FROM org_members m
      JOIN planes p ON p.codigo = public.plan_efectivo(m.org_id)
     WHERE m.user_id = uid
       AND p.plantillas_catalogo IS NULL
  );
$$;

REVOKE ALL ON FUNCTION public.ve_catalogo_completo(UUID) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.ve_catalogo_completo(UUID) TO authenticated;

-- ---------- Quién ve qué del catálogo ----------
DROP POLICY IF EXISTS "templates_select" ON templates;
CREATE POLICY "templates_select" ON templates FOR SELECT
  USING (
    -- Del catálogo maestro publicado: todo si el plan lo permite; si no,
    -- solo las cincuenta gratuitas.
    (is_master = true AND status = 'PUBLISHED'
      AND (es_gratuita = true OR public.ve_catalogo_completo(auth.uid())))
    -- La revisora ve también lo que está en borrador: es su trabajo.
    OR (is_master = true AND public.es_revisor_contenido(auth.uid()))
    -- Las propias del despacho, siempre.
    OR org_id IN (SELECT public.user_org_ids(auth.uid()))
    OR public.is_save_admin(auth.uid())
  );

-- ==========================================================
-- 6. TODO EL ESTADO DEL PLAN EN UNA CONSULTA
--
--    La aplicación necesita cinco cosas a la vez para pintar una
--    pantalla: qué plan rige, cuánto da, cuánto se lleva usado y si la
--    cuenta está en gracia o suspendida. Cinco llamadas para eso son
--    cinco viajes de red y cinco oportunidades de que una quede
--    desfasada respecto de las otras. Una función, un viaje.
-- ==========================================================

CREATE OR REPLACE FUNCTION public.estado_del_plan(org UUID)
RETURNS TABLE (
  plan                  TEXT,
  nombre                TEXT,
  precio_dop            INT,
  plan_contratado       TEXT,
  en_gracia             BOOLEAN,
  suspendida            BOOLEAN,
  impago_desde          TIMESTAMPTZ,
  documentos_usados     INT,
  documentos_limite     INT,
  boveda_limite         INT,
  integrantes           INT,
  integrantes_incluidos INT,
  precio_asiento_dop    INT,
  permite_equipo        BOOLEAN,
  permite_importar      BOOLEAN,
  catalogo_completo     BOOLEAN
)
LANGUAGE plpgsql STABLE SECURITY DEFINER SET search_path = public AS $estado$
BEGIN
  -- Tiene que ser SECURITY DEFINER para leer `planes` y contar documentos,
  -- y por eso mismo comprueba a quién pregunta: sin esto, cualquiera
  -- podría sondear el plan de cualquier despacho pasando su UUID.
  -- auth.uid() NULL es el SQL Editor, donde el diagnóstico sí interesa.
  IF auth.uid() IS NOT NULL
     AND NOT (org IN (SELECT public.user_org_ids(auth.uid()))
              OR public.is_save_admin(auth.uid())) THEN
    RAISE EXCEPTION 'Ese despacho no es tuyo.' USING ERRCODE = '42501';
  END IF;

  RETURN QUERY
  SELECT
    p.codigo,
    p.nombre,
    p.precio_dop,
    o.sub_status::text,
    public.org_en_gracia(org),
    public.org_suspendida(org),
    o.impago_desde,
    public.documentos_este_mes(org),
    p.documentos_por_mes,
    public.limite_boveda(org),
    (SELECT COUNT(*)::int FROM org_members m WHERE m.org_id = org),
    p.integrantes_incluidos,
    p.precio_asiento_dop,
    p.permite_equipo,
    p.permite_importar,
    p.plantillas_catalogo IS NULL
  FROM organizations o
  JOIN planes p ON p.codigo = public.plan_efectivo(org)
  WHERE o.id = org;
END;
$estado$;

REVOKE ALL ON FUNCTION public.estado_del_plan(UUID) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.limite_boveda(UUID) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.limite_documentos_mes(UUID) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.documentos_este_mes(UUID) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.plan_efectivo(UUID) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.recalcular_plantillas_gratuitas(INT) FROM PUBLIC;

GRANT EXECUTE ON FUNCTION public.estado_del_plan(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.limite_boveda(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.limite_documentos_mes(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.documentos_este_mes(UUID) TO authenticated;
