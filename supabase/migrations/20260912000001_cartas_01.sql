-- ==========================================================
-- SA&VE Comercial, S.R.L. — Punta Cana, República Dominicana
-- CATÁLOGO DE CARTAS · GENERADO AUTOMÁTICAMENTE
--
-- NO EDITAR A MANO. Este archivo lo produce:
--   npm run cartas:build
-- a partir de scripts/catalog/cartas.ts
--
-- ⚠️  32 cartas, TODAS en estado DRAFT.
--     Ningún usuario las ve hasta que un abogado dominicano las
--     revise y las publique. Al final hay instrucciones.
--
-- Se puede ejecutar más de una vez sin duplicar nada.
-- ==========================================================

-- PARTE 1 de 2: cartas 1–20. Requiere la parte 0.

-- ══════════════ CARTAS ══════════════

-- ── Carta de Autorización para Retirar Documentos ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-tramites';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-tramites';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-autorizacion-retirar-documentos';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-autorizacion-retirar-documentos', 'Carta de Autorización para Retirar Documentos', 'Autoriza a otra persona a retirar documentos personales en una institución cuando uno no puede ir.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_institucion}}
{{destinatario_cargo}}
Ciudad.-

Asunto: Autorización para retirar documentos', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Por medio de la presente, yo, {{firmante_nombre}}, {{firmante_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral núm. {{firmante_cedula}}, domiciliado(a) y residente en {{firmante_domicilio}}, AUTORIZO de manera expresa al señor(a) {{autorizado_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{autorizado_cedula}}, para que en mi nombre y representación retire ante esa institución el (los) siguiente(s) documento(s):

{{documentos_a_retirar}}

Esta autorización se otorga únicamente para el fin antes indicado y tendrá vigencia hasta el {{fecha_vencimiento_larga}}.

Declaro que la persona autorizada actúa por cuenta mía y que reconozco como válida la entrega que se le haga, quedando esa institución liberada de toda responsabilidad frente a mí por dicha entrega.

Anexo copia de mi cédula de identidad y electoral y de la del autorizado.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('autorizado_cedula', 1),
    ('autorizado_nombre', 2),
    ('ciudad_firma', 3),
    ('destinatario_cargo', 4),
    ('destinatario_institucion', 5),
    ('documentos_a_retirar', 6),
    ('fecha_carta', 7),
    ('fecha_vencimiento', 8),
    ('firmante_cedula', 9),
    ('firmante_correo', 10),
    ('firmante_domicilio', 11),
    ('firmante_nacionalidad', 12),
    ('firmante_nombre', 13),
    ('firmante_telefono', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Autorización para Retirar Paquetes o Encomiendas ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-tramites';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-tramites';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-autorizacion-retirar-paquete';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-autorizacion-retirar-paquete', 'Carta de Autorización para Retirar Paquetes o Encomiendas', 'Autoriza a un tercero a recoger un paquete, encomienda o envío a nombre de uno.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_institucion}}
{{destinatario_cargo}}
Ciudad.-

Asunto: Autorización para retirar paquete', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Por medio de la presente, yo, {{firmante_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{firmante_cedula}}, AUTORIZO al señor(a) {{autorizado_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{autorizado_cedula}}, a retirar en mi nombre el envío identificado como sigue:

{{descripcion_envio}}

Número de guía o referencia: {{numero_guia}}

Reconozco como recibida por mí toda entrega hecha a la persona aquí autorizada, y libero a esa empresa de responsabilidad por la misma. Anexo copia de ambas cédulas.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('autorizado_cedula', 1),
    ('autorizado_nombre', 2),
    ('ciudad_firma', 3),
    ('descripcion_envio', 4),
    ('destinatario_cargo', 5),
    ('destinatario_institucion', 6),
    ('fecha_carta', 7),
    ('firmante_cedula', 8),
    ('firmante_correo', 9),
    ('firmante_nombre', 10),
    ('firmante_telefono', 11),
    ('numero_guia', 12)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Poder Simple ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-tramites';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-tramites';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-poder-simple';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-poder-simple', 'Carta de Poder Simple', 'Poder por escrito para que otra persona realice un trámite concreto en nombre de uno. No sustituye un poder notarial cuando la ley lo exige.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

A QUIEN PUEDA INTERESAR:

Asunto: Poder para realizar gestión', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Yo, {{firmante_nombre}}, {{firmante_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral núm. {{firmante_cedula}}, domiciliado(a) y residente en {{firmante_domicilio}}, por medio del presente documento OTORGO PODER al señor(a) {{autorizado_nombre}}, {{autorizado_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral núm. {{autorizado_cedula}}, para que en mi nombre y representación realice la siguiente gestión:

{{gestion_encomendada}}

El apoderado queda facultado para firmar los documentos, recibos y formularios que la gestión requiera, y para recibir lo que en ella me corresponda.

Este poder es especial y se limita estrictamente a la gestión descrita. No comprende la facultad de vender, hipotecar, gravar ni disponer de bien alguno de mi patrimonio, ni de contraer obligaciones a mi cargo.

Vigencia: hasta el {{fecha_vencimiento_larga}}.

ADVERTENCIA: para determinados actos —entre otros la venta o hipoteca de inmuebles y las actuaciones ante el Registro de Títulos— la ley exige poder otorgado ante notario. Si su trámite es de esos, este documento no basta.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('autorizado_cedula', 1),
    ('autorizado_nacionalidad', 2),
    ('autorizado_nombre', 3),
    ('ciudad_firma', 4),
    ('fecha_carta', 5),
    ('fecha_vencimiento', 6),
    ('firmante_cedula', 7),
    ('firmante_correo', 8),
    ('firmante_domicilio', 9),
    ('firmante_nacionalidad', 10),
    ('firmante_nombre', 11),
    ('firmante_telefono', 12),
    ('gestion_encomendada', 13)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Declaración de Dependencia Económica ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-tramites';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-tramites';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-declaracion-dependencia-economica';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-declaracion-dependencia-economica', 'Declaración de Dependencia Económica', 'Declara que una o varias personas dependen económicamente de quien firma. Se pide en trámites de seguro, migración y escuelas.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

A QUIEN PUEDA INTERESAR:

Asunto: Declaración de dependencia económica', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Yo, {{firmante_nombre}}, {{firmante_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral núm. {{firmante_cedula}}, domiciliado(a) y residente en {{firmante_domicilio}}, DECLARO bajo la fe del juramento lo siguiente:

PRIMERO: Que me desempeño como {{firmante_ocupacion}} y percibo un ingreso mensual aproximado de {{ingreso_mensual_letras}}.

SEGUNDO: Que de mis ingresos dependen económicamente, de manera total y para su sustento, alojamiento, salud y educación, las siguientes personas:

{{personas_dependientes}}

TERCERO: Que dichas personas no perciben ingresos propios suficientes para su manutención y conviven conmigo en el domicilio antes indicado.

CUARTO: Que hago esta declaración para los fines legales que correspondan y asumo la responsabilidad de su contenido.

ADVERTENCIA: muchas instituciones exigen que esta declaración se haga ante notario y bajo juramento. Verifique el requisito antes de presentarla.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('fecha_carta', 2),
    ('firmante_cedula', 3),
    ('firmante_correo', 4),
    ('firmante_domicilio', 5),
    ('firmante_nacionalidad', 6),
    ('firmante_nombre', 7),
    ('firmante_ocupacion', 8),
    ('firmante_telefono', 9),
    ('ingreso_mensual', 10),
    ('personas_dependientes', 11)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Solicitud de Certificación ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-tramites';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-tramites';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-solicitud-certificacion';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-solicitud-certificacion', 'Carta de Solicitud de Certificación', 'Solicita a una institución la expedición de una certificación o constancia.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Solicitud de certificación', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Cortésmente le saludo y me dirijo a usted para SOLICITAR la expedición de la siguiente certificación:

{{certificacion_solicitada}}

La requiero para el siguiente fin: {{finalidad_certificacion}}.

Mis datos, para localizar el expediente, son:

Nombre completo: {{firmante_nombre}}
Cédula de identidad y electoral: {{firmante_cedula}}
Número de expediente o referencia: {{numero_referencia}}

Agradeceré me informen el costo, si lo hubiere, y el plazo de entrega. Quedo atento(a) a través del teléfono {{firmante_telefono}} o del correo {{firmante_correo}}.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('certificacion_solicitada', 1),
    ('ciudad_firma', 2),
    ('destinatario_cargo', 3),
    ('destinatario_institucion', 4),
    ('destinatario_nombre', 5),
    ('fecha_carta', 6),
    ('finalidad_certificacion', 7),
    ('firmante_cedula', 8),
    ('firmante_correo', 9),
    ('firmante_nombre', 10),
    ('firmante_telefono', 11),
    ('numero_referencia', 12)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Solicitud de Corrección de Datos ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-tramites';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-tramites';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-solicitud-correccion-datos';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-solicitud-correccion-datos', 'Carta de Solicitud de Corrección de Datos', 'Pide a una institución o empresa que corrija un dato personal equivocado en sus registros.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2","referencia_legal":"Ley núm. 172-13 sobre protección de datos personales"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Solicitud de rectificación de datos personales', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Cortésmente le saludo y me dirijo a usted en ejercicio de mi derecho de rectificación, para SOLICITAR la corrección del siguiente dato que figura de manera errónea en sus registros:

Dato como aparece actualmente: {{dato_incorrecto}}
Dato correcto: {{dato_correcto}}

El error afecta al registro identificado con {{numero_referencia}}, correspondiente a {{firmante_nombre}}, cédula de identidad y electoral núm. {{firmante_cedula}}.

Anexo los documentos que acreditan el dato correcto.

La Ley núm. 172-13 sobre protección de datos personales reconoce al titular el derecho a que sus datos sean exactos y a obtener su rectificación cuando no lo sean. Agradeceré la corrección y que se me confirme por escrito una vez realizada.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('dato_correcto', 2),
    ('dato_incorrecto', 3),
    ('destinatario_cargo', 4),
    ('destinatario_institucion', 5),
    ('destinatario_nombre', 6),
    ('fecha_carta', 7),
    ('firmante_cedula', 8),
    ('firmante_correo', 9),
    ('firmante_nombre', 10),
    ('firmante_telefono', 11),
    ('numero_referencia', 12)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Renuncia Voluntaria ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-laborales';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-laborales';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-renuncia-voluntaria';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-renuncia-voluntaria', 'Carta de Renuncia Voluntaria', 'Comunica al empleador la decisión de dejar el trabajo por voluntad propia.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2","referencia_legal":"Código de Trabajo de la República Dominicana (Ley núm. 16-92)"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Renuncia al cargo de {{cargo_ocupado}}', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Por medio de la presente le comunico mi decisión de RENUNCIAR de manera voluntaria al cargo de {{cargo_ocupado}}, que vengo desempeñando en {{empresa_nombre}} desde el {{fecha_ingreso_larga}}.

Mi último día de labores será el {{fecha_ultimo_dia_larga}}.

Durante el tiempo que resta me pongo a disposición para entregar de manera ordenada las funciones a mi cargo, los bienes de la empresa que tengo asignados y la información necesaria para la continuidad del trabajo.

Agradezco la oportunidad y la experiencia adquirida durante este tiempo.

ADVERTENCIA IMPORTANTE: la renuncia y el desahucio no producen los mismos efectos económicos. Quien renuncia por voluntad propia no genera el auxilio de cesantía que sí genera el desahucio ejercido por el empleador. Si usted está dejando el trabajo por faltas cometidas por su empleador, lo que corresponde no es una renuncia sino una dimisión, que tiene plazos y formalidades propias. Consulte a un abogado laboral antes de firmar.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('cargo_ocupado', 1),
    ('ciudad_firma', 2),
    ('destinatario_cargo', 3),
    ('destinatario_institucion', 4),
    ('destinatario_nombre', 5),
    ('empresa_nombre', 6),
    ('fecha_carta', 7),
    ('fecha_ingreso', 8),
    ('fecha_ultimo_dia', 9),
    ('firmante_cedula', 10),
    ('firmante_correo', 11),
    ('firmante_nombre', 12),
    ('firmante_telefono', 13)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Constancia de Trabajo ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-laborales';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-laborales';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-constancia-de-trabajo';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-constancia-de-trabajo', 'Constancia de Trabajo', 'Documento con el que la empresa certifica que una persona trabaja allí, su cargo y su salario. La piden bancos, embajadas y arrendadores.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

A QUIEN PUEDA INTERESAR:

Asunto: Constancia de trabajo', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Por medio de la presente, {{empresa_nombre}}, RNC {{empresa_rnc}}, con domicilio social en {{empresa_domicilio}}, HACE CONSTAR que:

El señor(a) {{empleado_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{empleado_cedula}}, labora en esta empresa desde el {{fecha_ingreso_larga}}, desempeñando el cargo de {{cargo_ocupado}}, bajo un contrato de trabajo {{tipo_contrato}}.

Devenga un salario mensual de {{salario_mensual_letras}}.

La presente constancia se expide a solicitud de la parte interesada, en {{ciudad_firma}}, para los fines que estime convenientes.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
{{firmante_cargo}}
{{empresa_nombre}}
RNC {{empresa_rnc}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('cargo_ocupado', 1),
    ('ciudad_firma', 2),
    ('empleado_cedula', 3),
    ('empleado_nombre', 4),
    ('empresa_domicilio', 5),
    ('empresa_nombre', 6),
    ('empresa_rnc', 7),
    ('fecha_carta', 8),
    ('fecha_ingreso', 9),
    ('firmante_cargo', 10),
    ('firmante_cedula', 11),
    ('firmante_correo', 12),
    ('firmante_nombre', 13),
    ('firmante_telefono', 14),
    ('salario_mensual', 15),
    ('tipo_contrato', 16)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Recomendación Laboral ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-laborales';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-laborales';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-recomendacion-laboral';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-recomendacion-laboral', 'Carta de Recomendación Laboral', 'Recomienda a un ex empleado o colaborador, describiendo su desempeño.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

A QUIEN PUEDA INTERESAR:

Asunto: Carta de recomendación', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Por medio de la presente me complace recomendar al señor(a) {{empleado_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{empleado_cedula}}, quien laboró en {{empresa_nombre}} desde el {{fecha_ingreso_larga}} hasta el {{fecha_egreso_larga}}, desempeñando el cargo de {{cargo_ocupado}}.

Durante ese tiempo tuvo a su cargo, entre otras, las siguientes funciones:

{{funciones_desempenadas}}

{{valoracion_desempeno}}

Su salida de la empresa se produjo por {{motivo_salida}}, en buenos términos.

Quedo a disposición para ampliar esta referencia a través del teléfono {{firmante_telefono}} o del correo {{firmante_correo}}.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
{{firmante_cargo}}
{{empresa_nombre}}
RNC {{empresa_rnc}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('cargo_ocupado', 1),
    ('ciudad_firma', 2),
    ('empleado_cedula', 3),
    ('empleado_nombre', 4),
    ('empresa_nombre', 5),
    ('empresa_rnc', 6),
    ('fecha_carta', 7),
    ('fecha_egreso', 8),
    ('fecha_ingreso', 9),
    ('firmante_cargo', 10),
    ('firmante_cedula', 11),
    ('firmante_correo', 12),
    ('firmante_nombre', 13),
    ('firmante_telefono', 14),
    ('funciones_desempenadas', 15),
    ('motivo_salida', 16),
    ('valoracion_desempeno', 17)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Solicitud de Empleo ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-laborales';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-laborales';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-solicitud-empleo';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-solicitud-empleo', 'Carta de Solicitud de Empleo', 'Acompaña el currículo al postularse a una vacante.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Solicitud para la vacante de {{cargo_solicitado}}', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Cortésmente le saludo y me dirijo a usted con el interés de postularme a la vacante de {{cargo_solicitado}} en {{empresa_destino}}, de la cual tuve conocimiento por {{fuente_vacante}}.

{{presentacion_candidato}}

{{motivo_interes}}

Anexo mi currículo con el detalle de mi formación y experiencia. Quedo a su disposición para una entrevista en el momento que estimen oportuno, a través del teléfono {{firmante_telefono}} o del correo {{firmante_correo}}.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('cargo_solicitado', 1),
    ('ciudad_firma', 2),
    ('destinatario_cargo', 3),
    ('destinatario_institucion', 4),
    ('destinatario_nombre', 5),
    ('empresa_destino', 6),
    ('fecha_carta', 7),
    ('firmante_cedula', 8),
    ('firmante_correo', 9),
    ('firmante_nombre', 10),
    ('firmante_telefono', 11),
    ('fuente_vacante', 12),
    ('motivo_interes', 13),
    ('presentacion_candidato', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Solicitud de Vacaciones ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-laborales';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-laborales';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-solicitud-vacaciones';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-solicitud-vacaciones', 'Carta de Solicitud de Vacaciones', 'Solicita al empleador el disfrute del período de vacaciones.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2","referencia_legal":"Código de Trabajo de la República Dominicana (Ley núm. 16-92)"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Solicitud de vacaciones', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Cortésmente me dirijo a usted para SOLICITAR el disfrute de mi período de vacaciones correspondiente al año {{ano_vacaciones}}.

Propongo tomarlas desde el {{fecha_desde_larga}} hasta el {{fecha_hasta_larga}}, reintegrándome a mis labores el {{fecha_reintegro_larga}}.

Durante mi ausencia, mis funciones quedarán cubiertas de la siguiente manera:

{{plan_cobertura}}

Agradeceré me confirmen la aprobación para organizar la entrega de pendientes.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('ano_vacaciones', 1),
    ('ciudad_firma', 2),
    ('destinatario_cargo', 3),
    ('destinatario_institucion', 4),
    ('destinatario_nombre', 5),
    ('fecha_carta', 6),
    ('fecha_desde', 7),
    ('fecha_hasta', 8),
    ('fecha_reintegro', 9),
    ('firmante_cedula', 10),
    ('firmante_correo', 11),
    ('firmante_nombre', 12),
    ('firmante_telefono', 13),
    ('plan_cobertura', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Solicitud de Permiso o Licencia ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-laborales';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-laborales';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-solicitud-permiso-laboral';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-solicitud-permiso-laboral', 'Carta de Solicitud de Permiso o Licencia', 'Pide autorización para ausentarse del trabajo por un motivo concreto.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Solicitud de permiso', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Cortésmente me dirijo a usted para SOLICITAR un permiso para ausentarme de mis labores desde el {{fecha_desde_larga}} hasta el {{fecha_hasta_larga}}, por el siguiente motivo:

{{motivo_permiso}}

{{documentos_sustento}}

Me reintegraré a mis funciones el {{fecha_reintegro_larga}}. Durante mi ausencia mis pendientes quedarán al día y coordinados según se me indique.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('destinatario_cargo', 2),
    ('destinatario_institucion', 3),
    ('destinatario_nombre', 4),
    ('documentos_sustento', 5),
    ('fecha_carta', 6),
    ('fecha_desde', 7),
    ('fecha_hasta', 8),
    ('fecha_reintegro', 9),
    ('firmante_cedula', 10),
    ('firmante_correo', 11),
    ('firmante_nombre', 12),
    ('firmante_telefono', 13),
    ('motivo_permiso', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Solicitud de Aumento de Salario ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-laborales';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-laborales';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-solicitud-aumento-salario';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-solicitud-aumento-salario', 'Carta de Solicitud de Aumento de Salario', 'Plantea al empleador una revisión del salario, con argumentos.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Solicitud de revisión salarial', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Cortésmente me dirijo a usted para solicitar la revisión de mi salario actual.

Ingresé a la empresa el {{fecha_ingreso_larga}} en el cargo de {{cargo_ocupado}}, y desde entonces mis responsabilidades han crecido de la siguiente manera:

{{responsabilidades_asumidas}}

{{logros_alcanzados}}

Mi salario mensual actual es de {{salario_actual_letras}} y no ha sido revisado desde el {{fecha_ultima_revision_larga}}. Planteo respetuosamente una revisión a {{salario_propuesto_letras}}.

Quedo a su disposición para conversarlo cuando lo estime oportuno.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('cargo_ocupado', 1),
    ('ciudad_firma', 2),
    ('destinatario_cargo', 3),
    ('destinatario_institucion', 4),
    ('destinatario_nombre', 5),
    ('fecha_carta', 6),
    ('fecha_ingreso', 7),
    ('fecha_ultima_revision', 8),
    ('firmante_cedula', 9),
    ('firmante_correo', 10),
    ('firmante_nombre', 11),
    ('firmante_telefono', 12),
    ('logros_alcanzados', 13),
    ('responsabilidades_asumidas', 14),
    ('salario_actual', 15),
    ('salario_propuesto', 16)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Descargo del Empleado ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-laborales';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-laborales';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-descargo-empleado';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-descargo-empleado', 'Carta de Descargo del Empleado', 'Respuesta escrita del trabajador a una amonestación o a la imputación de una falta.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Descargo respecto de la comunicación de fecha {{fecha_comunicacion_larga}}', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Acuso recibo de su comunicación de fecha {{fecha_comunicacion_larga}}, mediante la cual se me imputa lo siguiente:

{{hecho_imputado}}

Dentro del plazo concedido, presento mi descargo:

{{descargo_hechos}}

{{pruebas_ofrecidas}}

Por lo anterior, solicito respetuosamente que se reconsidere la medida y que esta comunicación se agregue a mi expediente junto a la que la motivó.

Reitero mi compromiso con el buen desempeño de mis funciones.

ADVERTENCIA: si la empresa le ha imputado una falta que pueda dar lugar a despido, presente su descargo por escrito, con acuse de recibo, y consulte a un abogado laboral. Guardar silencio puede interpretarse en su contra.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('descargo_hechos', 2),
    ('destinatario_cargo', 3),
    ('destinatario_institucion', 4),
    ('destinatario_nombre', 5),
    ('fecha_carta', 6),
    ('fecha_comunicacion', 7),
    ('firmante_cedula', 8),
    ('firmante_correo', 9),
    ('firmante_nombre', 10),
    ('firmante_telefono', 11),
    ('hecho_imputado', 12),
    ('pruebas_ofrecidas', 13)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Amonestación al Empleado ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-laborales';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-laborales';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-amonestacion-empleado';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-amonestacion-empleado', 'Carta de Amonestación al Empleado', 'Comunicación del empleador que deja constancia escrita de una falta y de la advertencia.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Amonestación', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Por medio de la presente, {{empresa_nombre}} le comunica formalmente lo siguiente.

En fecha {{fecha_hecho_larga}} se produjo el siguiente hecho:

{{hecho_imputado}}

Dicha conducta contraviene {{norma_incumplida}}.

Por lo anterior se le AMONESTA por escrito y se le advierte que la reincidencia podrá dar lugar a las medidas que el Código de Trabajo y el reglamento interno autorizan.

Usted dispone de {{dias_para_descargo}} días hábiles para presentar por escrito su descargo, el cual se agregará a su expediente junto a esta comunicación.

Recibido conforme por el trabajador:


_______________________________
{{empleado_nombre}}
Cédula núm. {{empleado_cedula}}
Fecha de recepción: ____________', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
{{firmante_cargo}}
{{empresa_nombre}}
RNC {{empresa_rnc}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('destinatario_cargo', 2),
    ('destinatario_institucion', 3),
    ('destinatario_nombre', 4),
    ('dias_para_descargo', 5),
    ('empleado_cedula', 6),
    ('empleado_nombre', 7),
    ('empresa_nombre', 8),
    ('empresa_rnc', 9),
    ('fecha_carta', 10),
    ('fecha_hecho', 11),
    ('firmante_cargo', 12),
    ('firmante_cedula', 13),
    ('firmante_correo', 14),
    ('firmante_nombre', 15),
    ('firmante_telefono', 16),
    ('hecho_imputado', 17),
    ('norma_incumplida', 18)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Solicitud a Institución Pública ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-instituciones';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-instituciones';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-solicitud-institucion-publica';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-solicitud-institucion-publica', 'Carta de Solicitud a Institución Pública', 'Solicitud formal dirigida a una institución del Estado.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Solicitud de {{objeto_solicitud}}', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Cortésmente le saludo y me dirijo a usted, en mi calidad de {{calidad_solicitante}}, para SOLICITAR lo siguiente:

{{objeto_solicitud}}

Fundamento la solicitud en lo siguiente:

{{fundamento_solicitud}}

Anexo la documentación de sustento:

{{documentos_anexos}}

Agradeceré que la respuesta me sea comunicada al domicilio {{firmante_domicilio}}, al teléfono {{firmante_telefono}} o al correo {{firmante_correo}}.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('calidad_solicitante', 1),
    ('ciudad_firma', 2),
    ('destinatario_cargo', 3),
    ('destinatario_institucion', 4),
    ('destinatario_nombre', 5),
    ('documentos_anexos', 6),
    ('fecha_carta', 7),
    ('firmante_cedula', 8),
    ('firmante_correo', 9),
    ('firmante_domicilio', 10),
    ('firmante_nombre', 11),
    ('firmante_telefono', 12),
    ('fundamento_solicitud', 13),
    ('objeto_solicitud', 14)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Respuesta a Requerimiento ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-instituciones';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-instituciones';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-respuesta-requerimiento';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-respuesta-requerimiento', 'Carta de Respuesta a Requerimiento', 'Contesta dentro de plazo un requerimiento de información de una institución.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Respuesta al requerimiento núm. {{numero_referencia}}', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Acuso recibo del requerimiento núm. {{numero_referencia}}, de fecha {{fecha_requerimiento_larga}}, recibido el {{fecha_recepcion_larga}}, y dentro del plazo concedido doy respuesta en los términos siguientes.

Sobre lo requerido:

{{respuesta_requerimiento}}

Documentación que se acompaña:

{{documentos_anexos}}

{{reserva_derechos}}

Quedo a disposición para ampliar cualquier punto a través del teléfono {{firmante_telefono}} o del correo {{firmante_correo}}.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('destinatario_cargo', 2),
    ('destinatario_institucion', 3),
    ('destinatario_nombre', 4),
    ('documentos_anexos', 5),
    ('fecha_carta', 6),
    ('fecha_recepcion', 7),
    ('fecha_requerimiento', 8),
    ('firmante_cedula', 9),
    ('firmante_correo', 10),
    ('firmante_nombre', 11),
    ('firmante_telefono', 12),
    ('numero_referencia', 13),
    ('reserva_derechos', 14),
    ('respuesta_requerimiento', 15)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Reclamación ante Pro Consumidor ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-instituciones';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-instituciones';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-reclamacion-proconsumidor';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-reclamacion-proconsumidor', 'Reclamación ante Pro Consumidor', 'Reclamación por un producto o servicio defectuoso ante el Instituto Nacional de Protección de los Derechos del Consumidor.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2","referencia_legal":"Ley núm. 358-05, General de Protección de los Derechos del Consumidor"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_institucion}}
{{destinatario_cargo}}
Ciudad.-

Asunto: Reclamación contra {{proveedor_nombre}}', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Cortésmente me dirijo a esa institución para presentar formal RECLAMACIÓN contra {{proveedor_nombre}}, RNC {{proveedor_rnc}}, con establecimiento en {{proveedor_domicilio}}, por los hechos que expongo.

PRIMERO — Lo adquirido. En fecha {{fecha_compra_larga}} adquirí {{descripcion_producto}}, por un valor de {{monto_pagado_letras}}, según consta en {{comprobante_compra}}.

SEGUNDO — El problema. {{descripcion_problema}}

TERCERO — Lo gestionado con el proveedor. {{gestiones_previas}}

CUARTO — Lo que solicito. {{pretension}}

Anexo copia de mi cédula, del comprobante de compra y de las comunicaciones sostenidas con el proveedor.

La Ley núm. 358-05, General de Protección de los Derechos del Consumidor, reconoce el derecho a recibir productos y servicios de la calidad ofrecida y a ser resarcido cuando no lo son.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('comprobante_compra', 2),
    ('descripcion_problema', 3),
    ('descripcion_producto', 4),
    ('destinatario_cargo', 5),
    ('destinatario_institucion', 6),
    ('fecha_carta', 7),
    ('fecha_compra', 8),
    ('firmante_cedula', 9),
    ('firmante_correo', 10),
    ('firmante_nombre', 11),
    ('firmante_telefono', 12),
    ('gestiones_previas', 13),
    ('monto_pagado', 14),
    ('pretension', 15),
    ('proveedor_domicilio', 16),
    ('proveedor_nombre', 17),
    ('proveedor_rnc', 18)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Invitación para Visa ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-migracion';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-migracion';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-invitacion-visa';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-invitacion-visa', 'Carta de Invitación para Visa', 'Invita formalmente a una persona extranjera a visitar el país, para acompañar su solicitud de visa.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_institucion}}
{{destinatario_cargo}}
Ciudad.-

Asunto: Carta de invitación a favor de {{invitado_nombre}}', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Por medio de la presente, yo, {{firmante_nombre}}, {{firmante_nacionalidad}}, mayor de edad, portador(a) de {{firmante_documento}} núm. {{firmante_cedula}}, con domicilio en {{firmante_domicilio}}, tengo a bien INVITAR formalmente al señor(a) {{invitado_nombre}}, de nacionalidad {{invitado_nacionalidad}}, portador(a) del pasaporte núm. {{invitado_pasaporte}}, a visitarme.

Motivo de la visita: {{motivo_visita}}.
Vínculo que nos une: {{vinculo_invitado}}.
Fecha prevista de llegada: {{fecha_llegada_larga}}.
Fecha prevista de regreso: {{fecha_regreso_larga}}.
Lugar de alojamiento durante la estadía: {{lugar_alojamiento}}.

{{compromiso_gastos}}

Declaro que la información aquí consignada es cierta y asumo la responsabilidad de su contenido.

ADVERTENCIA: cada consulado fija sus propios requisitos y muchos exigen que esta carta esté legalizada ante notario y, en algunos casos, apostillada. Confirme el requisito con el consulado antes de presentarla.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('ciudad_firma', 1),
    ('compromiso_gastos', 2),
    ('destinatario_cargo', 3),
    ('destinatario_institucion', 4),
    ('fecha_carta', 5),
    ('fecha_llegada', 6),
    ('fecha_regreso', 7),
    ('firmante_cedula', 8),
    ('firmante_correo', 9),
    ('firmante_documento', 10),
    ('firmante_domicilio', 11),
    ('firmante_nacionalidad', 12),
    ('firmante_nombre', 13),
    ('firmante_telefono', 14),
    ('invitado_nacionalidad', 15),
    ('invitado_nombre', 16),
    ('invitado_pasaporte', 17),
    ('lugar_alojamiento', 18),
    ('motivo_visita', 19),
    ('vinculo_invitado', 20)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

-- ── Carta de Sostenimiento Económico ──
DO $$
DECLARE
  v_template UUID;
  v_cat      UUID;
  s_encab    UUID;
BEGIN
  SELECT id INTO v_cat FROM template_categories WHERE slug = 'cartas-migracion';
  IF v_cat IS NULL THEN
    RAISE EXCEPTION 'Falta la categoria %: ejecuta este archivo completo, desde el principio', 'cartas-migracion';
  END IF;

  SELECT id INTO v_template FROM templates WHERE slug = 'carta-sostenimiento-economico';
  IF v_template IS NULL THEN
    INSERT INTO templates (org_id, slug, title, description, category, category_id, jurisdiction_code, is_master, version, status, content)
    VALUES (NULL, 'carta-sostenimiento-economico', 'Carta de Sostenimiento Económico', 'Quien firma se compromete a cubrir los gastos de otra persona durante su estadía o sus estudios.',
      (SELECT name FROM template_categories WHERE id = v_cat), v_cat, 'DO', true, '1.0', 'DRAFT', '{"engine":"v2"}'::jsonb)
    RETURNING id INTO v_template;
  END IF;

  DELETE FROM template_sections WHERE template_id = v_template;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Encabezado',
    '{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

A QUIEN PUEDA INTERESAR:

Asunto: Compromiso de sostenimiento económico a favor de {{beneficiario_nombre}}', 1)
  RETURNING id INTO s_encab;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Cuerpo',
    'Yo, {{firmante_nombre}}, {{firmante_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral núm. {{firmante_cedula}}, domiciliado(a) en {{firmante_domicilio}}, de ocupación {{firmante_ocupacion}}, DECLARO Y ME COMPROMETO a lo siguiente:

PRIMERO: Que percibo un ingreso mensual de {{ingreso_mensual_letras}}, proveniente de {{fuente_ingresos}}.

SEGUNDO: Que asumo de manera voluntaria el sostenimiento económico del señor(a) {{beneficiario_nombre}}, portador(a) de {{beneficiario_documento}} núm. {{beneficiario_documento_numero}}, con quien me une el siguiente vínculo: {{vinculo_beneficiario}}.

TERCERO: Que este compromiso comprende los gastos de {{gastos_cubiertos}}, durante el período comprendido entre el {{fecha_desde_larga}} y el {{fecha_hasta_larga}}.

CUARTO: Que asumo dicho compromiso con mis propios recursos y que la persona beneficiaria no representará carga alguna para el Estado.

Anexo los documentos que acreditan mis ingresos.', 2)
  ;

  INSERT INTO template_sections (template_id, title, body, sort_order)
  VALUES (v_template, 'Despedida y firma',
    'Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}', 3)
  ;

  INSERT INTO template_variables (template_id, variable_id, section_id, sort_order)
  SELECT v_template, v.id, s_encab, t.ord
  FROM (VALUES
    ('beneficiario_documento', 1),
    ('beneficiario_documento_numero', 2),
    ('beneficiario_nombre', 3),
    ('ciudad_firma', 4),
    ('fecha_carta', 5),
    ('fecha_desde', 6),
    ('fecha_hasta', 7),
    ('firmante_cedula', 8),
    ('firmante_correo', 9),
    ('firmante_domicilio', 10),
    ('firmante_nacionalidad', 11),
    ('firmante_nombre', 12),
    ('firmante_ocupacion', 13),
    ('firmante_telefono', 14),
    ('fuente_ingresos', 15),
    ('gastos_cubiertos', 16),
    ('ingreso_mensual', 17),
    ('vinculo_beneficiario', 18)
  ) AS t(tag, ord)
  JOIN variables v ON v.tag = t.tag AND v.org_id IS NULL
  ON CONFLICT DO NOTHING;
END $$;

