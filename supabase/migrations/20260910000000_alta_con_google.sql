-- ==========================================================
-- SA&VE Comercial, S.R.L.
-- Entrar con Google, y lo que Google no cuenta
--
-- Google devuelve nombre, correo y foto. No devuelve si quien entra es
-- una persona o una empresa, ni su fecha de nacimiento —eso exige
-- permisos aparte y sensibles, que asustan al usuario y obligan a una
-- revisión de Google.
--
-- Así que quien entre por Google llega con la cuenta creada y el perfil
-- a medias. Esta columna es la que distingue "no lo ha contestado" de
-- "lo contestó y dijo que no", que no es lo mismo:
--
--   tipo_cuenta viene con DEFAULT 'PERSONA' y fecha_nacimiento es
--   opcional, así que mirar esas dos columnas NO permite saber si la
--   persona llegó a ver la pregunta. Sin una marca explícita, a quien
--   dejó la fecha en blanco a propósito se le volvería a preguntar en
--   cada visita.
-- ==========================================================

ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS perfil_completado BOOLEAN NOT NULL DEFAULT false;

COMMENT ON COLUMN profiles.perfil_completado IS
  'true cuando la persona ya vio y contesto la pantalla de bienvenida. Quien se registra por el formulario nace en true; quien entra por Google, en false.';

-- Los que ya existen pasaron por el formulario completo: no se les
-- vuelve a preguntar nada.
UPDATE profiles SET perfil_completado = true WHERE perfil_completado = false;

-- ==========================================================
-- El trigger marca completado solo si el alta trajo los datos
-- ==========================================================

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  m        JSONB := COALESCE(NEW.raw_user_meta_data, '{}'::jsonb);
  v_full   TEXT  := COALESCE(m->>'full_name', m->>'name', '');
  v_first  TEXT  := COALESCE(NULLIF(m->>'first_name',''), NULLIF(m->>'given_name',''),
                             NULLIF(split_part(v_full, ' ', 1), ''), '');
  v_last   TEXT  := COALESCE(NULLIF(m->>'last_name',''), NULLIF(m->>'family_name',''),
                             NULLIF(NULLIF(TRIM(SUBSTRING(v_full FROM POSITION(' ' IN v_full))), ''), ''), '');
  v_pedido TEXT  := UPPER(TRIM(COALESCE(m->>'prof_role', '')));
  v_tipo   TEXT  := UPPER(TRIM(COALESCE(m->>'tipo_cuenta', 'PERSONA')));
  -- El formulario de registro manda tipo_cuenta. Google no manda nada
  -- nuestro, y esa ausencia es justo la senal de que falta preguntar.
  v_completo BOOLEAN := (m ? 'tipo_cuenta');
  v_fnac   DATE;
  v_role   professional_role;
  v_cuenta tipo_de_cuenta;
  v_org_id UUID;
  v_name   TEXT;
  v_inv    RECORD;
BEGIN
  IF v_pedido IN ('ABOGADO', 'NOTARIO', 'AMBOS', 'INDEPENDIENTE', 'PARALEGAL') THEN
    v_role := v_pedido::professional_role;
  ELSIF (m->>'is_lawyer')::boolean IS TRUE AND (m->>'is_notary')::boolean IS TRUE THEN
    v_role := 'AMBOS';
  ELSIF (m->>'is_notary')::boolean IS TRUE THEN
    v_role := 'NOTARIO';
  ELSIF (m->>'is_lawyer')::boolean IS TRUE THEN
    v_role := 'ABOGADO';
  ELSE
    v_role := 'INDEPENDIENTE';
  END IF;

  v_cuenta := CASE WHEN v_tipo = 'EMPRESA' THEN 'EMPRESA' ELSE 'PERSONA' END::tipo_de_cuenta;

  IF v_cuenta = 'PERSONA' THEN
    BEGIN
      v_fnac := NULLIF(m->>'fecha_nacimiento', '')::date;
      IF v_fnac IS NOT NULL
         AND (v_fnac <= DATE '1900-01-01' OR v_fnac >= CURRENT_DATE) THEN
        v_fnac := NULL;
      END IF;
    EXCEPTION WHEN others THEN
      v_fnac := NULL;
    END;
  END IF;

  DELETE FROM public.profiles p
   WHERE p.email = NEW.email
     AND p.id <> NEW.id
     AND NOT EXISTS (SELECT 1 FROM auth.users u WHERE u.id = p.id);

  INSERT INTO public.profiles (
    id, email, first_name, last_name, prof_role,
    tipo_cuenta, fecha_nacimiento, razon_social, rnc, perfil_completado
  )
  VALUES (
    NEW.id, NEW.email, NULLIF(v_first, ''), NULLIF(v_last, ''), v_role,
    v_cuenta, v_fnac,
    CASE WHEN v_cuenta = 'EMPRESA' THEN NULLIF(TRIM(COALESCE(m->>'razon_social','')), '') END,
    CASE WHEN v_cuenta = 'EMPRESA' THEN NULLIF(TRIM(COALESCE(m->>'rnc','')), '') END,
    v_completo
  )
  ON CONFLICT (id) DO NOTHING;

  v_name := COALESCE(
    CASE WHEN v_cuenta = 'EMPRESA' THEN NULLIF(TRIM(COALESCE(m->>'razon_social','')), '') END,
    NULLIF(TRIM(v_first || ' ' || v_last), ''),
    split_part(NEW.email, '@', 1)
  );

  IF NOT EXISTS (SELECT 1 FROM public.organizations WHERE owner_id = NEW.id) THEN
    INSERT INTO public.organizations (owner_id, name, is_firm)
    VALUES (NEW.id,
            CASE WHEN v_cuenta = 'EMPRESA' THEN v_name ELSE 'Despacho de ' || v_name END,
            false)
    RETURNING id INTO v_org_id;

    INSERT INTO public.org_members (org_id, user_id, role)
    VALUES (v_org_id, NEW.id, 'OWNER')
    ON CONFLICT (org_id, user_id) DO NOTHING;
  END IF;

  SELECT * INTO v_inv
    FROM public.invitaciones
   WHERE email = LOWER(NEW.email)
     AND estado = 'PENDIENTE'
     AND expires_at > timezone('utc', now())
   ORDER BY created_at DESC
   LIMIT 1;

  IF FOUND THEN
    INSERT INTO public.org_members (org_id, user_id, role, permissions)
    VALUES (v_inv.org_id, NEW.id, v_inv.role, v_inv.permissions)
    ON CONFLICT (org_id, user_id) DO NOTHING;

    UPDATE public.invitaciones
       SET estado = 'ACEPTADA', accepted_at = timezone('utc', now())
     WHERE id = v_inv.id;
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- ---------- Comprobacion ----------
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
     WHERE table_schema='public' AND table_name='profiles' AND column_name='perfil_completado'
  ) THEN
    RAISE EXCEPTION 'falta profiles.perfil_completado';
  END IF;
  RAISE NOTICE 'Perfiles sin completar: %',
    (SELECT count(*) FROM profiles WHERE NOT perfil_completado);
END $$;
