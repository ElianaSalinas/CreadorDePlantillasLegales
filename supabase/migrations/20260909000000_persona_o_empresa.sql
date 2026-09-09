-- ==========================================================
-- SA&VE Comercial, S.R.L.
-- Quién es el titular: una persona o una empresa
--
-- Se pregunta en el registro porque cambia dos cosas:
--   · a una persona se le pide fecha de nacimiento, para felicitarla
--   · a una empresa se le pide razón social y RNC, que además hará
--     falta para emitir el comprobante fiscal cuando entre CardNET
--
-- NO se pregunta el género. Se evaluó y se descartó: Google no lo
-- devuelve en el registro con su cuenta -exige un permiso aparte y
-- sensible-, así que habría que preguntárselo a todo el mundo para
-- conjugar un adjetivo. El saludo pasa a ser neutro y no hace falta
-- guardar un dato personal más.
-- ==========================================================

DO $$ BEGIN
  CREATE TYPE tipo_de_cuenta AS ENUM ('PERSONA', 'EMPRESA');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS tipo_cuenta       tipo_de_cuenta NOT NULL DEFAULT 'PERSONA',
  ADD COLUMN IF NOT EXISTS fecha_nacimiento  DATE,
  ADD COLUMN IF NOT EXISTS razon_social      VARCHAR,
  ADD COLUMN IF NOT EXISTS rnc               VARCHAR,
  -- El año en que ya se felicitó. Es lo que impide que el proceso
  -- mande cinco felicitaciones si se ejecuta cinco veces el mismo día.
  ADD COLUMN IF NOT EXISTS cumple_felicitado_en SMALLINT;

COMMENT ON COLUMN profiles.tipo_cuenta IS
  'PERSONA o EMPRESA. Decide qué se le pide en el registro y si recibe felicitación de cumpleaños.';
COMMENT ON COLUMN profiles.fecha_nacimiento IS
  'Solo para PERSONA. Se usa unicamente para felicitar el cumpleanos; declarado asi en /privacidad.';
COMMENT ON COLUMN profiles.cumple_felicitado_en IS
  'Ultimo ano en que se envio la felicitacion. Hace idempotente el proceso diario.';

-- ---------- Que los datos no se contradigan ----------
--
-- Una empresa no tiene fecha de nacimiento. Sin esta regla, el dia que
-- alguien cambie su cuenta a EMPRESA se quedaria la fecha vieja
-- guardada y el proceso de cumpleanos le escribiria a una razon social
-- felicitandola por su cumple.
DO $$ BEGIN
  ALTER TABLE profiles ADD CONSTRAINT empresa_sin_fecha_nacimiento
    CHECK (tipo_cuenta = 'PERSONA' OR fecha_nacimiento IS NULL);
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- Una fecha de nacimiento imposible es un dedazo, no un dato. Se
-- rechaza en la base y no solo en el formulario, porque el formulario
-- no es el unico camino hasta esta columna.
DO $$ BEGIN
  ALTER TABLE profiles ADD CONSTRAINT fecha_nacimiento_verosimil
    CHECK (
      fecha_nacimiento IS NULL
      OR (fecha_nacimiento > DATE '1900-01-01' AND fecha_nacimiento < CURRENT_DATE)
    );
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

CREATE INDEX IF NOT EXISTS profiles_cumple_idx
  ON profiles (fecha_nacimiento)
  WHERE fecha_nacimiento IS NOT NULL;

-- ==========================================================
-- El trigger de alta, ampliado
--
-- OJO: esta version NO lleva el enlace del revisor de catalogo ni el
-- EXCEPTION WHEN OTHERS. Se perdieron aqui por escribirla partiendo de
-- una version anterior a la del 2 de septiembre. La migracion
-- 20260910, que corre justo despues, ya deja la funcion completa; y la
-- 20260911 la comprueba y falla si volvieran a faltar. Se deja tal
-- cual y no se retoca para no reescribir una migracion que puede haber
-- corrido ya en produccion.
--
-- Dos cosas nuevas:
--   1. lee tipo de cuenta, fecha de nacimiento, razon social y RNC
--   2. entiende los nombres que manda GOOGLE, que no son los nuestros:
--      Google envia given_name / family_name / full_name / name, no
--      first_name / last_name. Sin esto, quien entrara con Google se
--      quedaria sin nombre y su espacio se llamaria "Despacho de
--      juanperez83" en vez de "Despacho de Juan Perez".
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

  -- Una fecha que no se puede interpretar se descarta en silencio en
  -- vez de tumbar el alta. Perder una felicitacion es molesto; no poder
  -- crear la cuenta es perder al cliente.
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
    tipo_cuenta, fecha_nacimiento, razon_social, rnc
  )
  VALUES (
    NEW.id, NEW.email, NULLIF(v_first, ''), NULLIF(v_last, ''), v_role,
    v_cuenta, v_fnac,
    CASE WHEN v_cuenta = 'EMPRESA' THEN NULLIF(TRIM(COALESCE(m->>'razon_social','')), '') END,
    CASE WHEN v_cuenta = 'EMPRESA' THEN NULLIF(TRIM(COALESCE(m->>'rnc','')), '') END
  )
  ON CONFLICT (id) DO NOTHING;

  -- El nombre del espacio: la razon social si es empresa, el nombre si
  -- es persona, y el correo como ultimo recurso.
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
DECLARE faltan TEXT;
BEGIN
  SELECT string_agg(c, ', ') INTO faltan FROM unnest(ARRAY[
    'tipo_cuenta','fecha_nacimiento','razon_social','rnc','cumple_felicitado_en'
  ]) AS c
  WHERE NOT EXISTS (
    SELECT 1 FROM information_schema.columns
     WHERE table_schema='public' AND table_name='profiles' AND column_name=c
  );
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'faltan columnas en profiles: %', faltan;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='empresa_sin_fecha_nacimiento') THEN
    RAISE EXCEPTION 'falta la regla que impide fecha de nacimiento en una EMPRESA';
  END IF;

  RAISE NOTICE 'Perfiles: % persona, % empresa',
    (SELECT count(*) FROM profiles WHERE tipo_cuenta='PERSONA'),
    (SELECT count(*) FROM profiles WHERE tipo_cuenta='EMPRESA');
END $$;
