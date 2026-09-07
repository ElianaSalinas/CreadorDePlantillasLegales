-- ============================================================
-- /precios: por que no salen los planes.
--
-- Una sola consulta, un solo resultado. El SQL Editor de Supabase
-- solo ensena la salida de la ultima sentencia, y por eso la vez
-- anterior se perdieron las tres primeras.
-- ============================================================

WITH tabla AS (
  SELECT to_regclass('public.planes') IS NOT NULL AS existe
),
seguridad AS (
  SELECT COALESCE(bool_or(c.relrowsecurity), false) AS rls
    FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
   WHERE n.nspname = 'public' AND c.relname = 'planes'
),
pol AS (
  SELECT count(*) AS n,
         string_agg(policyname || ' [' || cmd || '] roles=' || roles::text
                    || ' using=' || COALESCE(qual,'-'), ' | ') AS detalle
    FROM pg_policies
   WHERE schemaname = 'public' AND tablename = 'planes'
),
filas AS (
  SELECT count(*) AS n,
         string_agg(codigo || '=' || precio_dop::text, ', ' ORDER BY orden) AS lista
    FROM public.planes
)
SELECT 1 AS n, 'tabla existe'     AS dato, tabla.existe::text        AS valor FROM tabla
UNION ALL
SELECT 2, 'RLS activo',            seguridad.rls::text              FROM seguridad
UNION ALL
SELECT 3, 'policies (cuantas)',    pol.n::text                      FROM pol
UNION ALL
SELECT 4, 'policies (cuales)',     COALESCE(pol.detalle, 'NINGUNA') FROM pol
UNION ALL
SELECT 5, 'filas en planes',       filas.n::text                    FROM filas
UNION ALL
SELECT 6, 'planes cargados',       COALESCE(filas.lista, 'TABLA VACIA') FROM filas
ORDER BY n;
