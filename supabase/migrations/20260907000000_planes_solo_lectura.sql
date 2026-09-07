-- ============================================================
-- La tabla que define cuanto cobras solo se lee.
--
-- Supabase concede por defecto todos los privilegios sobre las tablas
-- nuevas de public a anon y authenticated. Sobre "planes" eso dejaba a
-- un visitante sin cuenta con INSERT, UPDATE, DELETE y TRUNCATE.
--
-- Hoy no se puede explotar: RLS esta activo y la unica policy es de
-- SELECT, asi que cualquier escritura se cae. Pero eso deja los precios
-- protegidos por una sola capa. El dia que alguien anada una policy
-- amplia para arreglar otra cosa, la tabla queda abierta.
--
-- Los planes los escribe una migracion, es decir el rol postgres, y
-- service_role conserva lo suyo. Ninguno de los dos pasa por aqui.
-- ============================================================

REVOKE INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES
    ON TABLE public.planes
  FROM anon, authenticated;

GRANT SELECT ON TABLE public.planes TO anon, authenticated;

-- Comprobacion: si quedara alguna escritura, la migracion falla en vez
-- de dar por bueno un resultado que nadie mira.
DO $$
DECLARE sobrantes TEXT;
BEGIN
  SELECT string_agg(grantee || ':' || privilege_type, ', ')
    INTO sobrantes
    FROM information_schema.role_table_grants
   WHERE table_schema = 'public'
     AND table_name   = 'planes'
     AND grantee IN ('anon','authenticated')
     AND privilege_type <> 'SELECT';

  IF sobrantes IS NOT NULL THEN
    RAISE EXCEPTION 'planes sigue con permisos de escritura: %', sobrantes;
  END IF;
END $$;
