-- Activa el plan de equipo para una cuenta concreta.
-- Se ejecuta desde el SQL Editor, donde auth.uid() es NULL y por tanto
-- el trigger guard_org_plan_columns deja pasar el cambio de plan.

UPDATE organizations o
   SET sub_status       = 'BUSINESS',
       is_firm          = true,
       included_members = GREATEST(o.included_members, 1),
       seat_price_dop   = CASE WHEN o.seat_price_dop = 0 THEN 499 ELSE o.seat_price_dop END
  FROM profiles p
 WHERE p.id = o.owner_id
   AND p.email = 'stephaniamontero84+abogado@gmail.com';

-- Solo un abogado o notario puede liderar despacho. Si la cuenta quedó
-- con otro perfil, se corrige; si ya era uno válido, no se toca.
UPDATE profiles
   SET prof_role = 'ABOGADO'
 WHERE email = 'stephaniamontero84+abogado@gmail.com'
   AND (prof_role IS NULL OR prof_role NOT IN ('ABOGADO','NOTARIO','AMBOS'));

-- Comprobación
SELECT p.email, p.prof_role, o.name, o.sub_status, o.is_firm,
       o.included_members, o.seat_price_dop
  FROM profiles p JOIN organizations o ON o.owner_id = p.id
 WHERE p.email = 'stephaniamontero84+abogado@gmail.com';
