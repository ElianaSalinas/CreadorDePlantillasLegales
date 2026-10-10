-- ═══════════════════════════════════════════════════════════════════
-- CUENTAS BANCARIAS OPCIONALES (hasta 4) EN LAS PLANTILLAS CON DINERO
--
-- Aditiva e idempotente: no borra nada y correrla dos veces no duplica
-- nada. Se aplica a toda plantilla maestra que ya tenga alguna variable
-- de tipo "currency" (el mismo criterio de moneda_contrato).
--
-- Mecanismo igual al de varias personas por parte (Fase 13.6): una
-- variable de cantidad, secciones con condición y reglas HIDE_VARIABLE
-- que ocultan los campos de las cuentas que no se pidieron.
-- ═══════════════════════════════════════════════════════════════════
BEGIN;

-- 1) Variables globales (si ya existen, no se tocan).
WITH campos(campo, etiqueta, pregunta, ayuda, tipo, opciones) AS (
  VALUES
  ('titular',        'Titular de la cuenta',      '¿A nombre de quién está la cuenta?',                         NULL::text, 'text',   '[]'),
  ('identificacion', 'Identificación del titular','¿Cuál es la cédula, el RNC o el pasaporte del titular?',     NULL,       'text',   '[]'),
  ('banco',          'Banco',                     '¿En qué banco está la cuenta?',                              'Escribe el nombre completo del banco. Ejemplo: Banco Popular Dominicano.', 'text', '[]'),
  ('moneda',         'Moneda de la cuenta',       '¿En qué moneda está la cuenta?',                             NULL,       'select', '[{"value":"pesos dominicanos (RD$)","label":"Pesos dominicanos"},{"value":"dólares estadounidenses (US$)","label":"Dólares"},{"value":"euros (€)","label":"Euros"}]'),
  ('numero',         'Número de cuenta',          '¿Cuál es el número de cuenta?',                              'Escríbelo completo, sin espacios.', 'text', '[]'),
  ('tipo',           'Tipo de cuenta',            '¿Es una cuenta de ahorros o corriente?',                     NULL,       'select', '[{"value":"cuenta de ahorros","label":"Ahorros"},{"value":"cuenta corriente","label":"Corriente"}]')
),
nuevas AS (
  SELECT 'cuenta_cantidad'::text AS tag,
         'Cantidad de cuentas bancarias'::text AS label,
         '¿Cuántas cuentas bancarias quiere incluir?'::text AS question,
         'Elija "Ninguna" si el documento no necesita cuentas bancarias. Puede incluir hasta 4.'::text AS help_text,
         'select'::text AS tipo,
         '[{"value":"0","label":"Ninguna"},{"value":"1","label":"1 cuenta"},{"value":"2","label":"2 cuentas"},{"value":"3","label":"3 cuentas"},{"value":"4","label":"4 cuentas"}]'::text AS opciones,
         '0'::text AS def
  UNION ALL
  SELECT 'cuenta' || n || '_' || c.campo,
         'Cuenta ' || n || ': ' || c.etiqueta,
         c.pregunta, c.ayuda, c.tipo, c.opciones, NULL::text
  FROM generate_series(1, 4) AS n
  CROSS JOIN campos c
)
INSERT INTO variables (org_id, tag, label, question, help_text, data_type, options, default_value, is_required, derived_config)
SELECT NULL, x.tag, x.label, x.question, x.help_text, x.tipo::variable_data_type, x.opciones::jsonb, x.def, true, NULL
FROM nuevas x
WHERE NOT EXISTS (SELECT 1 FROM variables v WHERE v.tag = x.tag AND v.org_id IS NULL);

-- 2) Plantillas con dinero: variables, secciones y reglas.
DO $$
DECLARE
  t       record;
  f       int;
  n       int;
  campo   text;
  nombre  text;
  base    int;
  r       int;
BEGIN
  FOR t IN
    SELECT DISTINCT tp.id
    FROM templates tp
    JOIN template_variables tv ON tv.template_id = tp.id
    JOIN variables v ON v.id = tv.variable_id
    WHERE tp.is_master = true AND tp.org_id IS NULL AND v.data_type = 'currency'
  LOOP
    -- a) Enlazar las variables al formulario, en orden lógico.
    INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
    SELECT t.id, v.id, NULL,
           (SELECT COALESCE(MAX(sort_order), 0) FROM template_variables WHERE template_id = t.id)
             + row_number() OVER (
                 ORDER BY CASE WHEN v.tag = 'cuenta_cantidad' THEN 0 ELSE 1 END,
                          substring(v.tag from 7 for 1),
                          array_position(ARRAY['titular','identificacion','banco','moneda','numero','tipo'], substring(v.tag from 9))
               )
    FROM variables v
    WHERE v.org_id IS NULL
      AND v.tag ~ '^cuenta([1-4]_(titular|identificacion|banco|moneda|numero|tipo)|_cantidad)$'
      AND NOT EXISTS (
        SELECT 1 FROM template_variables x WHERE x.template_id = t.id AND x.variable_id = v.id
      );

    -- b) Secciones: solo si todavía no tiene la de cuentas. Van justo
    --    antes de "Firmas"; lo que está desde ahí se corre 5 lugares.
    IF NOT EXISTS (
      SELECT 1 FROM template_sections WHERE template_id = t.id AND title = 'Cuentas bancarias'
    ) THEN
      SELECT COALESCE(
               MIN(sort_order),
               (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM template_sections WHERE template_id = t.id)
             )
        INTO f
        FROM template_sections
       WHERE template_id = t.id AND title = 'Firmas';

      -- En dos pasos para no chocar con posiciones ya ocupadas.
      UPDATE template_sections SET sort_order = sort_order + 1000
       WHERE template_id = t.id AND sort_order >= f;
      UPDATE template_sections SET sort_order = sort_order - 995
       WHERE template_id = t.id AND sort_order >= 1000;

      INSERT INTO template_sections (template_id, title, body, sort_order, condition)
      VALUES (
        t.id, 'Cuentas bancarias',
        'Para los pagos derivados de este documento se designan las siguientes cuentas bancarias:',
        f,
        jsonb_build_object('variable', 'cuenta_cantidad', 'operator', 'greater_or_equal', 'value', 1)
      );

      FOR n IN 1..4 LOOP
        INSERT INTO template_sections (template_id, title, body, sort_order, condition)
        VALUES (
          t.id, '',
          format(
            'Cuenta %s: {{cuenta%s_tipo}} número {{cuenta%s_numero}}, abierta en {{cuenta%s_banco}}, en {{cuenta%s_moneda}}, a nombre de {{cuenta%s_titular}}, identificado(a) con el número {{cuenta%s_identificacion}}.',
            n, n, n, n, n, n, n
          ),
          f + n,
          jsonb_build_object('variable', 'cuenta_cantidad', 'operator', 'greater_or_equal', 'value', n)
        );
      END LOOP;
    END IF;

    -- c) Reglas: ocultar los campos de las cuentas que no se pidieron.
    SELECT COALESCE(MAX(sort_order), 0) INTO base FROM template_rules WHERE template_id = t.id;
    r := 0;
    FOR n IN 1..4 LOOP
      FOREACH campo IN ARRAY ARRAY['titular','identificacion','banco','moneda','numero','tipo'] LOOP
        nombre := format('Ocultar cuenta%s_%s si hay menos de %s cuentas', n, campo, n);
        IF NOT EXISTS (SELECT 1 FROM template_rules WHERE template_id = t.id AND name = nombre) THEN
          r := r + 1;
          INSERT INTO template_rules (template_id, name, conditions, action, action_payload, sort_order)
          VALUES (
            t.id, nombre,
            jsonb_build_object('variable', 'cuenta_cantidad', 'operator', 'less_than', 'value', n),
            'HIDE_VARIABLE',
            jsonb_build_object('variable_tag', format('cuenta%s_%s', n, campo)),
            base + r
          );
        END IF;
      END LOOP;
    END LOOP;
  END LOOP;
END $$;

COMMIT;
