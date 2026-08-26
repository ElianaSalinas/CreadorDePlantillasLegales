-- Estado de la Fase 0 en esta base. Solo lee, no cambia nada.
SELECT * FROM (

  SELECT 1 AS n, 'D2 · trigger guard_org_plan_columns' AS comprobacion,
    CASE WHEN EXISTS (SELECT 1 FROM pg_trigger WHERE tgname='guard_org_plan_columns' AND NOT tgisinternal)
         THEN 'OK' ELSE 'FALTA — corre 20260828000000_fase0_blindar_plan.sql' END AS estado

  UNION ALL SELECT 2, 'D2 · politica orgs_update con WITH CHECK',
    CASE WHEN EXISTS (SELECT 1 FROM pg_policies WHERE tablename='organizations' AND policyname='orgs_update' AND with_check IS NOT NULL)
         THEN 'OK' ELSE 'FALTA — misma migracion' END

  UNION ALL SELECT 3, 'D2 · privilegios por columna en organizations',
    CASE
      WHEN EXISTS (SELECT 1 FROM information_schema.column_privileges
                    WHERE table_schema='public' AND table_name='organizations'
                      AND column_name='sub_status' AND privilege_type='UPDATE' AND grantee='authenticated')
        THEN 'FALTA — el titular aun puede ascenderse a PREMIUM'
      WHEN EXISTS (SELECT 1 FROM information_schema.column_privileges
                    WHERE table_schema='public' AND table_name='organizations'
                      AND column_name='name' AND privilege_type='UPDATE' AND grantee='authenticated')
        THEN 'OK — puede editar el nombre pero no el plan'
      ELSE 'REVISAR — authenticated no puede editar NADA de organizations'
    END

  UNION ALL SELECT 4, 'Catalogo · clausulas (esperado 123)',
    CASE WHEN (SELECT count(*) FROM clauses) >= 123 THEN 'OK ('||(SELECT count(*) FROM clauses)||')'
         ELSE 'PARCIAL ('||(SELECT count(*) FROM clauses)||' de 123)' END

  UNION ALL SELECT 5, 'Catalogo · plantillas (esperado 251)',
    CASE WHEN (SELECT count(*) FROM templates) >= 251 THEN 'OK ('||(SELECT count(*) FROM templates)||')'
         ELSE 'PARCIAL ('||(SELECT count(*) FROM templates)||' de 251)' END

  UNION ALL SELECT 6, 'Catalogo · variables (esperado 100)',
    CASE WHEN (SELECT count(*) FROM variables) >= 100 THEN 'OK ('||(SELECT count(*) FROM variables)||')'
         ELSE 'PARCIAL ('||(SELECT count(*) FROM variables)||' de 100)' END

  UNION ALL SELECT 7, 'Catalogo · todo sigue en DRAFT',
    CASE WHEN (SELECT count(*) FROM templates WHERE status <> 'DRAFT')
              + (SELECT count(*) FROM clauses WHERE status <> 'DRAFT') = 0
         THEN 'OK — nada publicado sin revision legal'
         ELSE 'OJO — hay contenido publicado' END

  UNION ALL SELECT 8, 'Cuentas registradas',
    (SELECT count(*)::text FROM auth.users)

  UNION ALL SELECT 9, 'Cuentas con el correo verificado',
    (SELECT count(*)::text FROM auth.users WHERE email_confirmed_at IS NOT NULL)

  UNION ALL SELECT 10, 'Cuentas a medias (sin perfil o sin despacho)',
    CASE WHEN (SELECT count(*) FROM auth.users u
                WHERE NOT EXISTS (SELECT 1 FROM profiles p WHERE p.id=u.id)
                   OR NOT EXISTS (SELECT 1 FROM organizations o WHERE o.owner_id=u.id)) = 0
         THEN 'OK — ninguna'
         ELSE 'REVISAR — '||(SELECT count(*) FROM auth.users u
                WHERE NOT EXISTS (SELECT 1 FROM profiles p WHERE p.id=u.id)
                   OR NOT EXISTS (SELECT 1 FROM organizations o WHERE o.owner_id=u.id))::text END

) t ORDER BY n;
