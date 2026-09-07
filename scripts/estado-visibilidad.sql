-- ============================================================
-- Fase 4: en que estado quedo la visibilidad de documentos.
--
-- Una sola consulta, un solo resultado: el SQL Editor de Supabase
-- solo ensena la salida de la ultima sentencia.
-- ============================================================

WITH col AS (
  SELECT EXISTS (
    SELECT 1 FROM information_schema.columns
     WHERE table_schema='public' AND table_name='documents' AND column_name='es_privado'
  ) AS hay
),
pol AS (
  SELECT COALESCE(bool_or(qual LIKE '%es_privado%'), false) AS mira_privado
    FROM pg_policies
   WHERE schemaname='public' AND tablename='documents' AND policyname='documents_select'
),
trg AS (
  SELECT EXISTS (
    SELECT 1 FROM pg_trigger
     WHERE tgname = 'documents_guard_es_privado' AND NOT tgisinternal
  ) AS hay
),
cuenta AS (
  SELECT count(*) FILTER (WHERE es_privado)     AS privados,
         count(*) FILTER (WHERE NOT es_privado) AS visibles,
         count(*)                               AS total
    FROM documents
)
SELECT 1 AS n, 'columna es_privado'                AS dato, col.hay::text            AS valor FROM col
UNION ALL
SELECT 2, 'documents_select mira es_privado',       pol.mira_privado::text          FROM pol
UNION ALL
SELECT 3, 'trigger del candado',                    trg.hay::text                   FROM trg
UNION ALL
SELECT 4, 'documentos privados',                    cuenta.privados::text           FROM cuenta
UNION ALL
SELECT 5, 'documentos visibles para el despacho',   cuenta.visibles::text           FROM cuenta
UNION ALL
SELECT 6, 'total de documentos',                    cuenta.total::text              FROM cuenta
ORDER BY n;
