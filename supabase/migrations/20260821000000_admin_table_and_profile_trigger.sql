-- ==========================================
-- SA&VE Comercial, S.R.L. - Cierra brechas de la migración inicial
-- 1) Crea save_admins (definida en docs/planificacion/06-DISENO-DE-BASE-DE-DATOS.md
--    pero nunca migrada; src/app/app/layout.tsx y dashboard/page.tsx ya la consultan)
-- 2) Sincroniza auth.users -> public.profiles automáticamente al registrarse
--    (hoy src/app/register/actions.ts guarda first_name/last_name/is_lawyer/is_notary
--    en auth.users.raw_user_meta_data, pero nada lo copiaba a la tabla profiles)
-- ==========================================

-- 1. TABLA DE ADMINISTRADORES DE SA&VE
CREATE TABLE IF NOT EXISTS save_admins (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  admin_role VARCHAR NOT NULL DEFAULT 'SUPER_ADMIN', -- 'SUPER_ADMIN', 'CONTENT', 'FINANCE'
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE save_admins ENABLE ROW LEVEL SECURITY;

-- Solo el propio admin puede leer su fila (ajusta si necesitas que otros admins se vean entre sí)
CREATE POLICY "Admins can view own admin row"
  ON save_admins FOR SELECT
  USING (auth.uid() = id);

-- 2. TRIGGER: crea automáticamente la fila en profiles cuando alguien se registra
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, first_name, last_name, prof_role)
  VALUES (
    NEW.id,
    NEW.email,
    NEW.raw_user_meta_data->>'first_name',
    NEW.raw_user_meta_data->>'last_name',
    CASE
      WHEN (NEW.raw_user_meta_data->>'is_lawyer')::boolean IS TRUE
       AND (NEW.raw_user_meta_data->>'is_notary')::boolean IS TRUE THEN 'AMBOS'::professional_role
      WHEN (NEW.raw_user_meta_data->>'is_notary')::boolean IS TRUE THEN 'NOTARIO'::professional_role
      ELSE 'ABOGADO'::professional_role
    END
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
