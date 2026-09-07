-- ============================================================
-- La tabla que define cuanto cobras solo se lee.
--
-- Supabase concede por defecto todos los privilegios sobre las tablas
-- nuevas de public a anon y authenticated. Sobre "planes" eso dejaba a
-- un visitante sin cuenta con INSERT, UPDATE, DELETE, TRUNCATE y
-- TRIGGER.
--
-- Las escrituras hoy no se pueden explotar, porque RLS esta activo y la
-- unica policy es de SELECT. TRIGGER es otra cosa: es el permiso para
-- colgar un trigger de la tabla, y un trigger sobre "planes" reescribe
-- precios en cada operacion.
--
-- Los planes los escribe una migracion, es decir el rol postgres, y
-- service_role conserva lo suyo. Ninguno de los dos pasa por aqui.
--
-- Se revoca TODO y se vuelve a conceder solo SELECT, en vez de ir
-- nombrando privilegios uno a uno: enumerarlos es como se cuela el que
-- falta. Aqui ya se colo TRIGGER una vez.
-- ============================================================

REVOKE ALL ON TABLE public.planes FROM anon, authenticated;

GRANT SELECT ON TABLE public.planes TO anon, authenticated;

-- Comprobacion: si quedara cualquier privilegio que no sea SELECT, la
-- migracion falla en vez de dar por bueno un resultado que nadie mira.
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
    RAISE EXCEPTION 'planes sigue con permisos de mas: %', sobrantes;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.role_table_grants
     WHERE table_schema = 'public' AND table_name = 'planes'
       AND grantee = 'anon' AND privilege_type = 'SELECT'
  ) THEN
    RAISE EXCEPTION 'anon se quedo sin SELECT: /precios dejaria de mostrar los planes';
  END IF;
END $$;
