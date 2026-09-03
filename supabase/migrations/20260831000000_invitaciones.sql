-- ==========================================================
-- SA&VE Comercial, S.R.L. — Punta Cana, República Dominicana
-- FASE 1 · Invitaciones al despacho
--
-- Hasta ahora, para sumar a un paralegal había que pedirle que se
-- registrara por su cuenta y luego añadirlo a mano. No se enviaba
-- ningún correo. Ahora el titular invita por correo a alguien que
-- todavía no tiene cuenta, esa persona elige su propia contraseña
-- y entra directamente al despacho.
--
-- SEGURIDAD, que es lo delicado aquí:
--
-- La tentación es que el trigger lea el despacho de destino desde
-- los metadatos del usuario. NO se hace, y a propósito: cualquiera
-- puede llamar a la API de registro con la clave anónima y meter
-- los metadatos que quiera, así que podría colarse en el despacho
-- ajeno que eligiera.
--
-- En su lugar el trigger consulta ESTA tabla, en la que solo el
-- titular de un despacho puede insertar. Quien se registre por su
-- cuenta sin haber sido invitado no encontrará ninguna fila y se
-- quedará en su propio espacio.
-- ==========================================================

-- Repetible a proposito: si esta migracion ya se aplico a medias, volver a
-- lanzarla no debe estrellarse en la primera linea.
DO $crear_tipo$
BEGIN
  CREATE TYPE invitacion_estado AS ENUM ('PENDIENTE', 'ACEPTADA', 'CANCELADA');
EXCEPTION WHEN duplicate_object THEN
  NULL;
END
$crear_tipo$;

CREATE TABLE IF NOT EXISTS invitaciones (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id      UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  email       VARCHAR NOT NULL,
  role        member_role NOT NULL DEFAULT 'PARALEGAL',
  permissions JSONB NOT NULL DEFAULT '{}'::jsonb,
  invited_by  UUID REFERENCES profiles(id) ON DELETE SET NULL,
  estado      invitacion_estado NOT NULL DEFAULT 'PENDIENTE',
  expires_at  TIMESTAMPTZ NOT NULL DEFAULT (timezone('utc', now()) + INTERVAL '14 days'),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now()),
  accepted_at TIMESTAMPTZ,
  CONSTRAINT invitacion_rol_valido CHECK (role IN ('PARALEGAL', 'ASSISTANT'))
);

-- El correo siempre en minúsculas, para que la búsqueda del trigger
-- no falle por una mayúscula al teclear.
CREATE OR REPLACE FUNCTION public.invitacion_normaliza_email()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.email := LOWER(TRIM(NEW.email));
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS invitacion_normaliza_email ON invitaciones;
CREATE TRIGGER invitacion_normaliza_email
  BEFORE INSERT OR UPDATE ON invitaciones
  FOR EACH ROW EXECUTE FUNCTION public.invitacion_normaliza_email();

-- Una sola invitación pendiente por persona y despacho.
CREATE UNIQUE INDEX IF NOT EXISTS invitaciones_pendiente_unica
  ON invitaciones (org_id, email) WHERE estado = 'PENDIENTE';

CREATE INDEX IF NOT EXISTS invitaciones_email_idx ON invitaciones (email, estado);

ALTER TABLE invitaciones ENABLE ROW LEVEL SECURITY;

-- Solo el titular del despacho gestiona sus invitaciones. Nadie más
-- puede insertar, que es lo que hace segura la consulta del trigger.
DROP POLICY IF EXISTS "invitaciones_select" ON invitaciones;
DROP POLICY IF EXISTS "invitaciones_insert" ON invitaciones;
DROP POLICY IF EXISTS "invitaciones_update" ON invitaciones;
DROP POLICY IF EXISTS "invitaciones_delete" ON invitaciones;

CREATE POLICY "invitaciones_select" ON invitaciones FOR SELECT
  USING (
    public.is_save_admin(auth.uid())
    OR org_id IN (SELECT id FROM organizations WHERE owner_id = auth.uid())
  );

CREATE POLICY "invitaciones_insert" ON invitaciones FOR INSERT
  WITH CHECK (org_id IN (SELECT id FROM organizations WHERE owner_id = auth.uid()));

CREATE POLICY "invitaciones_update" ON invitaciones FOR UPDATE
  USING (org_id IN (SELECT id FROM organizations WHERE owner_id = auth.uid()))
  WITH CHECK (org_id IN (SELECT id FROM organizations WHERE owner_id = auth.uid()));

CREATE POLICY "invitaciones_delete" ON invitaciones FOR DELETE
  USING (org_id IN (SELECT id FROM organizations WHERE owner_id = auth.uid()));

COMMENT ON TABLE invitaciones IS
  'Fase 1: invitaciones a un despacho. El trigger handle_new_user las consume al registrarse.';

-- ---------- El trigger consume la invitación al crearse la cuenta ----------
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_first  TEXT := COALESCE(NEW.raw_user_meta_data->>'first_name', '');
  v_last   TEXT := COALESCE(NEW.raw_user_meta_data->>'last_name', '');
  v_pedido TEXT := UPPER(TRIM(COALESCE(NEW.raw_user_meta_data->>'prof_role', '')));
  v_role   professional_role;
  v_org_id UUID;
  v_name   TEXT;
  v_inv    RECORD;
BEGIN
  IF v_pedido IN ('ABOGADO', 'NOTARIO', 'AMBOS', 'INDEPENDIENTE', 'PARALEGAL') THEN
    v_role := v_pedido::professional_role;
  ELSIF (NEW.raw_user_meta_data->>'is_lawyer')::boolean IS TRUE
        AND (NEW.raw_user_meta_data->>'is_notary')::boolean IS TRUE THEN
    v_role := 'AMBOS';
  ELSIF (NEW.raw_user_meta_data->>'is_notary')::boolean IS TRUE THEN
    v_role := 'NOTARIO';
  ELSIF (NEW.raw_user_meta_data->>'is_lawyer')::boolean IS TRUE THEN
    v_role := 'ABOGADO';
  ELSE
    v_role := 'INDEPENDIENTE';
  END IF;

  DELETE FROM public.profiles p
   WHERE p.email = NEW.email
     AND p.id <> NEW.id
     AND NOT EXISTS (SELECT 1 FROM auth.users u WHERE u.id = p.id);

  INSERT INTO public.profiles (id, email, first_name, last_name, prof_role)
  VALUES (NEW.id, NEW.email, NULLIF(v_first, ''), NULLIF(v_last, ''), v_role)
  ON CONFLICT (id) DO NOTHING;

  -- Espacio propio SIEMPRE, incluso para quien llega invitado. Es lo que
  -- hace que salir de un despacho no deje a nadie sin cuenta: al quitarle
  -- la membresía, su espacio sigue ahí esperándolo.
  v_name := TRIM(v_first || ' ' || v_last);
  IF v_name = '' THEN
    v_name := split_part(NEW.email, '@', 1);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM public.organizations WHERE owner_id = NEW.id) THEN
    INSERT INTO public.organizations (owner_id, name, is_firm)
    VALUES (NEW.id, 'Despacho de ' || v_name, false)
    RETURNING id INTO v_org_id;

    INSERT INTO public.org_members (org_id, user_id, role)
    VALUES (v_org_id, NEW.id, 'OWNER')
    ON CONFLICT (org_id, user_id) DO NOTHING;
  END IF;

  -- ¿Le habían invitado a un despacho? Se busca por correo en la tabla de
  -- invitaciones, NO en los metadatos del usuario: esos los controla quien
  -- llama a la API y serían una puerta abierta a colarse en un despacho.
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

EXCEPTION WHEN OTHERS THEN
  RAISE WARNING '[handle_new_user] no se pudo preparar el espacio de %: % (SQLSTATE %)',
    NEW.email, SQLERRM, SQLSTATE;
  RETURN NEW;
END;
$$;
