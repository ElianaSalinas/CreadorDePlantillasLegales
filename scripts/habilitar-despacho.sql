-- ==========================================================
-- Habilitar despacho con equipo para una cuenta.
--
-- Hacen falta DOS cosas a la vez, y por eso este script existe:
--   1. El perfil tiene que ser ABOGADO, NOTARIO o AMBOS
--      (billing.ts → roleCanLeadTeam). Ni INDEPENDIENTE ni PARALEGAL
--      pueden encabezar despacho, por mucho plan que tengan.
--   2. El plan tiene que ser BUSINESS
--      (billing.ts → planAllowsTeam).
--
-- Con una sola de las dos, la sección de Mi Despacho no aparece.
--
-- Se ejecuta desde el SQL Editor a propósito: ahí auth.uid() es NULL,
-- y el trigger guard_org_plan_columns solo bloquea los cambios de plan
-- que vienen con una sesión de usuario detrás. Desde la aplicación,
-- nadie puede regalarse el plan.
--
-- Es repetible: lanzarlo dos veces no cambia nada la segunda.
-- ==========================================================

-- ══════════ EL ÚNICO SITIO QUE HAY QUE TOCAR ══════════
CREATE TEMP TABLE IF NOT EXISTS cuenta_objetivo (email TEXT);
DELETE FROM cuenta_objetivo;
INSERT INTO cuenta_objetivo VALUES

  ('elianastephaniamonterosalinas@gmail.com');

-- Para habilitar varias a la vez, añade líneas:
--   ('otra@correo.com'),
--   ('tercera@correo.com');
-- ══════════════════════════════════════════════════════

-- ---------- 1. El perfil ----------
-- Solo se toca si no es ya uno de los tres válidos: si la cuenta ya
-- era NOTARIO, no se la degrada a ABOGADO por lanzar esto.
UPDATE profiles p
   SET prof_role = 'AMBOS'
  FROM cuenta_objetivo c
 WHERE LOWER(p.email) = LOWER(c.email)
   AND (p.prof_role IS NULL OR p.prof_role NOT IN ('ABOGADO', 'NOTARIO', 'AMBOS'));

-- ---------- 2. El plan del despacho ----------
UPDATE organizations o
   SET sub_status       = 'BUSINESS',
       is_firm          = true,
       included_members = GREATEST(o.included_members, 1),
       seat_price_dop   = CASE WHEN o.seat_price_dop = 0 THEN 499 ELSE o.seat_price_dop END
  FROM profiles p
  JOIN cuenta_objetivo c ON LOWER(p.email) = LOWER(c.email)
 WHERE o.owner_id = p.id;

-- ---------- 3. Comprobación ----------
-- 'puede_liderar_despacho' tiene que salir en true. Si sale false, la
-- columna que esté mal en esta misma fila dice por qué.
SELECT p.email,
       p.prof_role,
       o.name              AS despacho,
       o.sub_status        AS plan,
       o.is_firm,
       o.included_members,
       o.seat_price_dop,
       (p.prof_role IN ('ABOGADO','NOTARIO','AMBOS') AND o.sub_status = 'BUSINESS')
         AS puede_liderar_despacho,
       (SELECT COUNT(*) FROM org_members m WHERE m.org_id = o.id) AS miembros_hoy
  FROM profiles p
  JOIN cuenta_objetivo c ON LOWER(p.email) = LOWER(c.email)
  JOIN organizations o   ON o.owner_id = p.id;
