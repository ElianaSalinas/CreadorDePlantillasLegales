# Cartas para revisión legal

**SA&VE Comercial, S.R.L.** · Punta Cana, República Dominicana

> ⚠️ **NO EDITAR ESTE ARCHIVO.** Lo genera `npm run cartas:build` a partir
> de `scripts/catalog/cartas.ts`. Lo que se corrija aquí se pierde en la
> siguiente generación: las correcciones van a `cartas.ts`.

Son **32 cartas**, todas en estado `DRAFT`. Ningún usuario de la
plataforma las ve hasta que se aprueben. **Ninguna ha sido revisada todavía**
por un abogado dominicano: lo que sigue es un borrador de trabajo.

Revisan: `legalcifuentes@gmail.com` y `jmarquez@saveconsult.net`.

### Cómo leerlas

Lo que va `{{entre llaves dobles}}` lo rellena el usuario al generar el
documento; no es texto de la carta. Al final de cada una está la lista de
lo que se le pregunta, para juzgar si falta o sobra alguna pregunta.

### Qué mirar

1. **Si el texto dice lo que debe decir** en derecho dominicano.
2. **Si las advertencias son correctas** y si falta alguna. Van en
   mayúsculas al final del cuerpo y son lo que separa una carta útil de
   una que le cuesta un derecho a quien la firma.
3. **Si la carta necesita notario** y no lo dice.
4. **Si falta o sobra una pregunta** al usuario.

---

## Cartas · Trámites personales

### Carta de Autorización para Retirar Documentos

*Autoriza a otra persona a retirar documentos personales en una institución cuando uno no puede ir.*

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_institucion}}
{{destinatario_cargo}}
Ciudad.-

Asunto: Autorización para retirar documentos

Por medio de la presente, yo, {{firmante_nombre}}, {{firmante_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral núm. {{firmante_cedula}}, domiciliado(a) y residente en {{firmante_domicilio}}, AUTORIZO de manera expresa al señor(a) {{autorizado_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{autorizado_cedula}}, para que en mi nombre y representación retire ante esa institución el (los) siguiente(s) documento(s):

{{documentos_a_retirar}}

Esta autorización se otorga únicamente para el fin antes indicado y tendrá vigencia hasta el {{fecha_vencimiento_larga}}.

Declaro que la persona autorizada actúa por cuenta mía y que reconozco como válida la entrega que se le haga, quedando esa institución liberada de toda responsabilidad frente a mí por dicha entrega.

Anexo copia de mi cédula de identidad y electoral y de la del autorizado.

Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (14):** Cédula de la persona autorizada · Nombre de la persona autorizada · Ciudad de firma · Cargo del destinatario · Institución o empresa destinataria · Documentos a retirar · Fecha de la carta · Fecha de vencimiento · Cédula de quien firma · Correo de contacto · Domicilio de quien firma · Nacionalidad de quien firma · Nombre de quien firma · Teléfono de contacto

<sub>`carta-autorizacion-retirar-documentos` · categoría `cartas-tramites`</sub>

---

### Carta de Autorización para Retirar Paquetes o Encomiendas

*Autoriza a un tercero a recoger un paquete, encomienda o envío a nombre de uno.*

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_institucion}}
{{destinatario_cargo}}
Ciudad.-

Asunto: Autorización para retirar paquete

Por medio de la presente, yo, {{firmante_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{firmante_cedula}}, AUTORIZO al señor(a) {{autorizado_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{autorizado_cedula}}, a retirar en mi nombre el envío identificado como sigue:

{{descripcion_envio}}

Número de guía o referencia: {{numero_guia}}

Reconozco como recibida por mí toda entrega hecha a la persona aquí autorizada, y libero a esa empresa de responsabilidad por la misma. Anexo copia de ambas cédulas.

Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (12):** Cédula de la persona autorizada · Nombre de la persona autorizada · Ciudad de firma · Descripción del envío · Cargo del destinatario · Institución o empresa destinataria · Fecha de la carta · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Número de guía o referencia

<sub>`carta-autorizacion-retirar-paquete` · categoría `cartas-tramites`</sub>

---

### Carta de Poder Simple

*Poder por escrito para que otra persona realice un trámite concreto en nombre de uno. No sustituye un poder notarial cuando la ley lo exige.*

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

A QUIEN PUEDA INTERESAR:

Asunto: Poder para realizar gestión

Yo, {{firmante_nombre}}, {{firmante_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral núm. {{firmante_cedula}}, domiciliado(a) y residente en {{firmante_domicilio}}, por medio del presente documento OTORGO PODER al señor(a) {{autorizado_nombre}}, {{autorizado_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral núm. {{autorizado_cedula}}, para que en mi nombre y representación realice la siguiente gestión:

{{gestion_encomendada}}

El apoderado queda facultado para firmar los documentos, recibos y formularios que la gestión requiera, y para recibir lo que en ella me corresponda.

Este poder es especial y se limita estrictamente a la gestión descrita. No comprende la facultad de vender, hipotecar, gravar ni disponer de bien alguno de mi patrimonio, ni de contraer obligaciones a mi cargo.

Vigencia: hasta el {{fecha_vencimiento_larga}}.

ADVERTENCIA: para determinados actos —entre otros la venta o hipoteca de inmuebles y las actuaciones ante el Registro de Títulos— la ley exige poder otorgado ante notario. Si su trámite es de esos, este documento no basta.

Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (13):** Cédula de la persona autorizada · Nacionalidad de la persona autorizada · Nombre de la persona autorizada · Ciudad de firma · Fecha de la carta · Fecha de vencimiento · Cédula de quien firma · Correo de contacto · Domicilio de quien firma · Nacionalidad de quien firma · Nombre de quien firma · Teléfono de contacto · Gestión encomendada

<sub>`carta-poder-simple` · categoría `cartas-tramites`</sub>

---

### Declaración de Dependencia Económica

*Declara que una o varias personas dependen económicamente de quien firma. Se pide en trámites de seguro, migración y escuelas.*

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

A QUIEN PUEDA INTERESAR:

Asunto: Declaración de dependencia económica

Yo, {{firmante_nombre}}, {{firmante_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral núm. {{firmante_cedula}}, domiciliado(a) y residente en {{firmante_domicilio}}, DECLARO bajo la fe del juramento lo siguiente:

PRIMERO: Que me desempeño como {{firmante_ocupacion}} y percibo un ingreso mensual aproximado de {{ingreso_mensual_letras}}.

SEGUNDO: Que de mis ingresos dependen económicamente, de manera total y para su sustento, alojamiento, salud y educación, las siguientes personas:

{{personas_dependientes}}

TERCERO: Que dichas personas no perciben ingresos propios suficientes para su manutención y conviven conmigo en el domicilio antes indicado.

CUARTO: Que hago esta declaración para los fines legales que correspondan y asumo la responsabilidad de su contenido.

ADVERTENCIA: muchas instituciones exigen que esta declaración se haga ante notario y bajo juramento. Verifique el requisito antes de presentarla.

Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (11):** Ciudad de firma · Fecha de la carta · Cédula de quien firma · Correo de contacto · Domicilio de quien firma · Nacionalidad de quien firma · Nombre de quien firma · Ocupación de quien firma · Teléfono de contacto · Ingreso mensual · Personas que dependen económicamente

<sub>`carta-declaracion-dependencia-economica` · categoría `cartas-tramites`</sub>

---

### Carta de Solicitud de Certificación

*Solicita a una institución la expedición de una certificación o constancia.*

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Solicitud de certificación

Cortésmente le saludo y me dirijo a usted para SOLICITAR la expedición de la siguiente certificación:

{{certificacion_solicitada}}

La requiero para el siguiente fin: {{finalidad_certificacion}}.

Mis datos, para localizar el expediente, son:

Nombre completo: {{firmante_nombre}}
Cédula de identidad y electoral: {{firmante_cedula}}
Número de expediente o referencia: {{numero_referencia}}

Agradeceré me informen el costo, si lo hubiere, y el plazo de entrega. Quedo atento(a) a través del teléfono {{firmante_telefono}} o del correo {{firmante_correo}}.

Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (12):** Certificación que se solicita · Ciudad de firma · Cargo del destinatario · Institución o empresa destinataria · Nombre del destinatario · Fecha de la carta · Para qué se necesita · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Número de referencia o expediente

<sub>`carta-solicitud-certificacion` · categoría `cartas-tramites`</sub>

---

### Carta de Solicitud de Corrección de Datos

*Pide a una institución o empresa que corrija un dato personal equivocado en sus registros.*

**Base legal indicada:** Ley núm. 172-13 sobre protección de datos personales

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Solicitud de rectificación de datos personales

Cortésmente le saludo y me dirijo a usted en ejercicio de mi derecho de rectificación, para SOLICITAR la corrección del siguiente dato que figura de manera errónea en sus registros:

Dato como aparece actualmente: {{dato_incorrecto}}
Dato correcto: {{dato_correcto}}

El error afecta al registro identificado con {{numero_referencia}}, correspondiente a {{firmante_nombre}}, cédula de identidad y electoral núm. {{firmante_cedula}}.

Anexo los documentos que acreditan el dato correcto.

La Ley núm. 172-13 sobre protección de datos personales reconoce al titular el derecho a que sus datos sean exactos y a obtener su rectificación cuando no lo sean. Agradeceré la corrección y que se me confirme por escrito una vez realizada.

Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (12):** Ciudad de firma · Dato correcto · Dato como aparece hoy · Cargo del destinatario · Institución o empresa destinataria · Nombre del destinatario · Fecha de la carta · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Número de referencia o expediente

<sub>`carta-solicitud-correccion-datos` · categoría `cartas-tramites`</sub>

---

## Cartas · Laborales

### Carta de Renuncia Voluntaria

*Comunica al empleador la decisión de dejar el trabajo por voluntad propia.*

**Base legal indicada:** Código de Trabajo de la República Dominicana (Ley núm. 16-92)

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Renuncia al cargo de {{cargo_ocupado}}

Por medio de la presente le comunico mi decisión de RENUNCIAR de manera voluntaria al cargo de {{cargo_ocupado}}, que vengo desempeñando en {{empresa_nombre}} desde el {{fecha_ingreso_larga}}.

Mi último día de labores será el {{fecha_ultimo_dia_larga}}.

Durante el tiempo que resta me pongo a disposición para entregar de manera ordenada las funciones a mi cargo, los bienes de la empresa que tengo asignados y la información necesaria para la continuidad del trabajo.

Agradezco la oportunidad y la experiencia adquirida durante este tiempo.

ADVERTENCIA IMPORTANTE: la renuncia y el desahucio no producen los mismos efectos económicos. Quien renuncia por voluntad propia no genera el auxilio de cesantía que sí genera el desahucio ejercido por el empleador. Si usted está dejando el trabajo por faltas cometidas por su empleador, lo que corresponde no es una renuncia sino una dimisión, que tiene plazos y formalidades propias. Consulte a un abogado laboral antes de firmar.

Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (13):** Cargo que ocupa · Ciudad de firma · Cargo del destinatario · Institución o empresa destinataria · Nombre del destinatario · Razón social de la empresa · Fecha de la carta · Fecha de ingreso a la empresa · Último día de labores · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto

<sub>`carta-renuncia-voluntaria` · categoría `cartas-laborales`</sub>

---

### Constancia de Trabajo

*Documento con el que la empresa certifica que una persona trabaja allí, su cargo y su salario. La piden bancos, embajadas y arrendadores.*

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

A QUIEN PUEDA INTERESAR:

Asunto: Constancia de trabajo

Por medio de la presente, {{empresa_nombre}}, RNC {{empresa_rnc}}, con domicilio social en {{empresa_domicilio}}, HACE CONSTAR que:

El señor(a) {{empleado_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{empleado_cedula}}, labora en esta empresa desde el {{fecha_ingreso_larga}}, desempeñando el cargo de {{cargo_ocupado}}, bajo un contrato de trabajo {{tipo_contrato}}.

Devenga un salario mensual de {{salario_mensual_letras}}.

La presente constancia se expide a solicitud de la parte interesada, en {{ciudad_firma}}, para los fines que estime convenientes.

Atentamente,


_______________________________
{{firmante_nombre}}
{{firmante_cargo}}
{{empresa_nombre}}
RNC {{empresa_rnc}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (16):** Cargo que ocupa · Ciudad de firma · Cédula del trabajador · Nombre del trabajador · Domicilio social · Razón social de la empresa · RNC de la empresa · Fecha de la carta · Fecha de ingreso a la empresa · Cargo de quien firma · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Salario mensual · Tipo de contrato

<sub>`carta-constancia-de-trabajo` · categoría `cartas-laborales`</sub>

---

### Carta de Recomendación Laboral

*Recomienda a un ex empleado o colaborador, describiendo su desempeño.*

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

A QUIEN PUEDA INTERESAR:

Asunto: Carta de recomendación

Por medio de la presente me complace recomendar al señor(a) {{empleado_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{empleado_cedula}}, quien laboró en {{empresa_nombre}} desde el {{fecha_ingreso_larga}} hasta el {{fecha_egreso_larga}}, desempeñando el cargo de {{cargo_ocupado}}.

Durante ese tiempo tuvo a su cargo, entre otras, las siguientes funciones:

{{funciones_desempenadas}}

{{valoracion_desempeno}}

Su salida de la empresa se produjo por {{motivo_salida}}, en buenos términos.

Quedo a disposición para ampliar esta referencia a través del teléfono {{firmante_telefono}} o del correo {{firmante_correo}}.

Atentamente,


_______________________________
{{firmante_nombre}}
{{firmante_cargo}}
{{empresa_nombre}}
RNC {{empresa_rnc}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (17):** Cargo que ocupa · Ciudad de firma · Cédula del trabajador · Nombre del trabajador · Razón social de la empresa · RNC de la empresa · Fecha de la carta · Fecha de salida de la empresa · Fecha de ingreso a la empresa · Cargo de quien firma · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Funciones desempeñadas · Motivo de la salida · Valoración del desempeño

<sub>`carta-recomendacion-laboral` · categoría `cartas-laborales`</sub>

---

### Carta de Solicitud de Empleo

*Acompaña el currículo al postularse a una vacante.*

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Solicitud para la vacante de {{cargo_solicitado}}

Cortésmente le saludo y me dirijo a usted con el interés de postularme a la vacante de {{cargo_solicitado}} en {{empresa_destino}}, de la cual tuve conocimiento por {{fuente_vacante}}.

{{presentacion_candidato}}

{{motivo_interes}}

Anexo mi currículo con el detalle de mi formación y experiencia. Quedo a su disposición para una entrevista en el momento que estimen oportuno, a través del teléfono {{firmante_telefono}} o del correo {{firmante_correo}}.

Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (14):** Cargo al que se postula · Ciudad de firma · Cargo del destinatario · Institución o empresa destinataria · Nombre del destinatario · Empresa a la que se postula · Fecha de la carta · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Dónde vio la vacante · Motivo del interés en el puesto · Presentación del candidato

<sub>`carta-solicitud-empleo` · categoría `cartas-laborales`</sub>

---

### Carta de Solicitud de Vacaciones

*Solicita al empleador el disfrute del período de vacaciones.*

**Base legal indicada:** Código de Trabajo de la República Dominicana (Ley núm. 16-92)

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Solicitud de vacaciones

Cortésmente me dirijo a usted para SOLICITAR el disfrute de mi período de vacaciones correspondiente al año {{ano_vacaciones}}.

Propongo tomarlas desde el {{fecha_desde_larga}} hasta el {{fecha_hasta_larga}}, reintegrándome a mis labores el {{fecha_reintegro_larga}}.

Durante mi ausencia, mis funciones quedarán cubiertas de la siguiente manera:

{{plan_cobertura}}

Agradeceré me confirmen la aprobación para organizar la entrega de pendientes.

Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (14):** Año de las vacaciones · Ciudad de firma · Cargo del destinatario · Institución o empresa destinataria · Nombre del destinatario · Fecha de la carta · Fecha de inicio · Fecha de término · Fecha de reintegro · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Cómo quedan cubiertas sus funciones

<sub>`carta-solicitud-vacaciones` · categoría `cartas-laborales`</sub>

---

### Carta de Solicitud de Permiso o Licencia

*Pide autorización para ausentarse del trabajo por un motivo concreto.*

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Solicitud de permiso

Cortésmente me dirijo a usted para SOLICITAR un permiso para ausentarme de mis labores desde el {{fecha_desde_larga}} hasta el {{fecha_hasta_larga}}, por el siguiente motivo:

{{motivo_permiso}}

{{documentos_sustento}}

Me reintegraré a mis funciones el {{fecha_reintegro_larga}}. Durante mi ausencia mis pendientes quedarán al día y coordinados según se me indique.

Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (14):** Ciudad de firma · Cargo del destinatario · Institución o empresa destinataria · Nombre del destinatario · Documentos que sustentan la solicitud · Fecha de la carta · Fecha de inicio · Fecha de término · Fecha de reintegro · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Motivo del permiso

<sub>`carta-solicitud-permiso-laboral` · categoría `cartas-laborales`</sub>

---

### Carta de Solicitud de Aumento de Salario

*Plantea al empleador una revisión del salario, con argumentos.*

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Solicitud de revisión salarial

Cortésmente me dirijo a usted para solicitar la revisión de mi salario actual.

Ingresé a la empresa el {{fecha_ingreso_larga}} en el cargo de {{cargo_ocupado}}, y desde entonces mis responsabilidades han crecido de la siguiente manera:

{{responsabilidades_asumidas}}

{{logros_alcanzados}}

Mi salario mensual actual es de {{salario_actual_letras}} y no ha sido revisado desde el {{fecha_ultima_revision_larga}}. Planteo respetuosamente una revisión a {{salario_propuesto_letras}}.

Quedo a su disposición para conversarlo cuando lo estime oportuno.

Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (16):** Cargo que ocupa · Ciudad de firma · Cargo del destinatario · Institución o empresa destinataria · Nombre del destinatario · Fecha de la carta · Fecha de ingreso a la empresa · Fecha de la última revisión salarial · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Logros alcanzados · Responsabilidades asumidas desde el ingreso · Salario actual · Salario que se propone

<sub>`carta-solicitud-aumento-salario` · categoría `cartas-laborales`</sub>

---

### Carta de Descargo del Empleado

*Respuesta escrita del trabajador a una amonestación o a la imputación de una falta.*

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Descargo respecto de la comunicación de fecha {{fecha_comunicacion_larga}}

Acuso recibo de su comunicación de fecha {{fecha_comunicacion_larga}}, mediante la cual se me imputa lo siguiente:

{{hecho_imputado}}

Dentro del plazo concedido, presento mi descargo:

{{descargo_hechos}}

{{pruebas_ofrecidas}}

Por lo anterior, solicito respetuosamente que se reconsidere la medida y que esta comunicación se agregue a mi expediente junto a la que la motivó.

Reitero mi compromiso con el buen desempeño de mis funciones.

ADVERTENCIA: si la empresa le ha imputado una falta que pueda dar lugar a despido, presente su descargo por escrito, con acuse de recibo, y consulte a un abogado laboral. Guardar silencio puede interpretarse en su contra.

Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (13):** Ciudad de firma · Explicación de los hechos · Cargo del destinatario · Institución o empresa destinataria · Nombre del destinatario · Fecha de la carta · Fecha de la comunicación recibida · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Hecho que se imputa · Pruebas que se acompañan

<sub>`carta-descargo-empleado` · categoría `cartas-laborales`</sub>

---

### Carta de Amonestación al Empleado

*Comunicación del empleador que deja constancia escrita de una falta y de la advertencia.*

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Amonestación

Por medio de la presente, {{empresa_nombre}} le comunica formalmente lo siguiente.

En fecha {{fecha_hecho_larga}} se produjo el siguiente hecho:

{{hecho_imputado}}

Dicha conducta contraviene {{norma_incumplida}}.

Por lo anterior se le AMONESTA por escrito y se le advierte que la reincidencia podrá dar lugar a las medidas que el Código de Trabajo y el reglamento interno autorizan.

Usted dispone de {{dias_para_descargo}} días hábiles para presentar por escrito su descargo, el cual se agregará a su expediente junto a esta comunicación.

Recibido conforme por el trabajador:


_______________________________
{{empleado_nombre}}
Cédula núm. {{empleado_cedula}}
Fecha de recepción: ____________

Atentamente,


_______________________________
{{firmante_nombre}}
{{firmante_cargo}}
{{empresa_nombre}}
RNC {{empresa_rnc}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (18):** Ciudad de firma · Cargo del destinatario · Institución o empresa destinataria · Nombre del destinatario · Días para presentar descargo · Cédula del trabajador · Nombre del trabajador · Razón social de la empresa · RNC de la empresa · Fecha de la carta · Fecha en que ocurrió el hecho · Cargo de quien firma · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Hecho que se imputa · Norma o política incumplida

<sub>`carta-amonestacion-empleado` · categoría `cartas-laborales`</sub>

---

## Cartas · Instituciones públicas

### Carta de Solicitud a Institución Pública

*Solicitud formal dirigida a una institución del Estado.*

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Solicitud de {{objeto_solicitud}}

Cortésmente le saludo y me dirijo a usted, en mi calidad de {{calidad_solicitante}}, para SOLICITAR lo siguiente:

{{objeto_solicitud}}

Fundamento la solicitud en lo siguiente:

{{fundamento_solicitud}}

Anexo la documentación de sustento:

{{documentos_anexos}}

Agradeceré que la respuesta me sea comunicada al domicilio {{firmante_domicilio}}, al teléfono {{firmante_telefono}} o al correo {{firmante_correo}}.

Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (14):** Calidad en que solicita · Ciudad de firma · Cargo del destinatario · Institución o empresa destinataria · Nombre del destinatario · Documentos anexos · Fecha de la carta · Cédula de quien firma · Correo de contacto · Domicilio de quien firma · Nombre de quien firma · Teléfono de contacto · Por qué se solicita · Qué se solicita

<sub>`carta-solicitud-institucion-publica` · categoría `cartas-instituciones`</sub>

---

### Carta de Respuesta a Requerimiento

*Contesta dentro de plazo un requerimiento de información de una institución.*

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Respuesta al requerimiento núm. {{numero_referencia}}

Acuso recibo del requerimiento núm. {{numero_referencia}}, de fecha {{fecha_requerimiento_larga}}, recibido el {{fecha_recepcion_larga}}, y dentro del plazo concedido doy respuesta en los términos siguientes.

Sobre lo requerido:

{{respuesta_requerimiento}}

Documentación que se acompaña:

{{documentos_anexos}}

{{reserva_derechos}}

Quedo a disposición para ampliar cualquier punto a través del teléfono {{firmante_telefono}} o del correo {{firmante_correo}}.

Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (15):** Ciudad de firma · Cargo del destinatario · Institución o empresa destinataria · Nombre del destinatario · Documentos anexos · Fecha de la carta · Fecha en que se recibió · Fecha del requerimiento · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Número de referencia o expediente · Reserva de derechos · Respuesta a lo requerido

<sub>`carta-respuesta-requerimiento` · categoría `cartas-instituciones`</sub>

---

### Reclamación ante Pro Consumidor

*Reclamación por un producto o servicio defectuoso ante el Instituto Nacional de Protección de los Derechos del Consumidor.*

**Base legal indicada:** Ley núm. 358-05, General de Protección de los Derechos del Consumidor

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_institucion}}
{{destinatario_cargo}}
Ciudad.-

Asunto: Reclamación contra {{proveedor_nombre}}

Cortésmente me dirijo a esa institución para presentar formal RECLAMACIÓN contra {{proveedor_nombre}}, RNC {{proveedor_rnc}}, con establecimiento en {{proveedor_domicilio}}, por los hechos que expongo.

PRIMERO — Lo adquirido. En fecha {{fecha_compra_larga}} adquirí {{descripcion_producto}}, por un valor de {{monto_pagado_letras}}, según consta en {{comprobante_compra}}.

SEGUNDO — El problema. {{descripcion_problema}}

TERCERO — Lo gestionado con el proveedor. {{gestiones_previas}}

CUARTO — Lo que solicito. {{pretension}}

Anexo copia de mi cédula, del comprobante de compra y de las comunicaciones sostenidas con el proveedor.

La Ley núm. 358-05, General de Protección de los Derechos del Consumidor, reconoce el derecho a recibir productos y servicios de la calidad ofrecida y a ser resarcido cuando no lo son.

Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (18):** Ciudad de firma · Comprobante de compra · Problema que presenta · Producto o servicio · Cargo del destinatario · Institución o empresa destinataria · Fecha de la carta · Fecha de la compra · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Gestiones ya realizadas · Monto pagado · Qué solicita · Dirección del proveedor · Nombre del proveedor o comercio · RNC del proveedor

<sub>`carta-reclamacion-proconsumidor` · categoría `cartas-instituciones`</sub>

---

## Cartas · Migración y viajes

### Carta de Invitación para Visa

*Invita formalmente a una persona extranjera a visitar el país, para acompañar su solicitud de visa.*

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_institucion}}
{{destinatario_cargo}}
Ciudad.-

Asunto: Carta de invitación a favor de {{invitado_nombre}}

Por medio de la presente, yo, {{firmante_nombre}}, {{firmante_nacionalidad}}, mayor de edad, portador(a) de {{firmante_documento}} núm. {{firmante_cedula}}, con domicilio en {{firmante_domicilio}}, tengo a bien INVITAR formalmente al señor(a) {{invitado_nombre}}, de nacionalidad {{invitado_nacionalidad}}, portador(a) del pasaporte núm. {{invitado_pasaporte}}, a visitarme.

Motivo de la visita: {{motivo_visita}}.
Vínculo que nos une: {{vinculo_invitado}}.
Fecha prevista de llegada: {{fecha_llegada_larga}}.
Fecha prevista de regreso: {{fecha_regreso_larga}}.
Lugar de alojamiento durante la estadía: {{lugar_alojamiento}}.

{{compromiso_gastos}}

Declaro que la información aquí consignada es cierta y asumo la responsabilidad de su contenido.

ADVERTENCIA: cada consulado fija sus propios requisitos y muchos exigen que esta carta esté legalizada ante notario y, en algunos casos, apostillada. Confirme el requisito con el consulado antes de presentarla.

Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (20):** Ciudad de firma · Compromiso sobre los gastos · Cargo del destinatario · Institución o empresa destinataria · Fecha de la carta · Fecha de llegada · Fecha de regreso · Cédula de quien firma · Correo de contacto · Tipo de documento de identidad · Domicilio de quien firma · Nacionalidad de quien firma · Nombre de quien firma · Teléfono de contacto · Nacionalidad de la persona invitada · Nombre de la persona invitada · Pasaporte de la persona invitada · Lugar de alojamiento · Motivo de la visita · Vínculo con la persona invitada

<sub>`carta-invitacion-visa` · categoría `cartas-migracion`</sub>

---

### Carta de Sostenimiento Económico

*Quien firma se compromete a cubrir los gastos de otra persona durante su estadía o sus estudios.*

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

A QUIEN PUEDA INTERESAR:

Asunto: Compromiso de sostenimiento económico a favor de {{beneficiario_nombre}}

Yo, {{firmante_nombre}}, {{firmante_nacionalidad}}, mayor de edad, portador(a) de la cédula de identidad y electoral núm. {{firmante_cedula}}, domiciliado(a) en {{firmante_domicilio}}, de ocupación {{firmante_ocupacion}}, DECLARO Y ME COMPROMETO a lo siguiente:

PRIMERO: Que percibo un ingreso mensual de {{ingreso_mensual_letras}}, proveniente de {{fuente_ingresos}}.

SEGUNDO: Que asumo de manera voluntaria el sostenimiento económico del señor(a) {{beneficiario_nombre}}, portador(a) de {{beneficiario_documento}} núm. {{beneficiario_documento_numero}}, con quien me une el siguiente vínculo: {{vinculo_beneficiario}}.

TERCERO: Que este compromiso comprende los gastos de {{gastos_cubiertos}}, durante el período comprendido entre el {{fecha_desde_larga}} y el {{fecha_hasta_larga}}.

CUARTO: Que asumo dicho compromiso con mis propios recursos y que la persona beneficiaria no representará carga alguna para el Estado.

Anexo los documentos que acreditan mis ingresos.

Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (18):** Tipo de documento de la persona beneficiaria · Número del documento · Nombre de la persona beneficiaria · Ciudad de firma · Fecha de la carta · Fecha de inicio · Fecha de término · Cédula de quien firma · Correo de contacto · Domicilio de quien firma · Nacionalidad de quien firma · Nombre de quien firma · Ocupación de quien firma · Teléfono de contacto · De dónde provienen los ingresos · Gastos que se cubren · Ingreso mensual · Vínculo con la persona beneficiaria

<sub>`carta-sostenimiento-economico` · categoría `cartas-migracion`</sub>

---

### Carta de No Objeción para Viaje

*La empresa o institución declara no tener objeción a que la persona viaje, y confirma su vínculo y su regreso.*

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

A QUIEN PUEDA INTERESAR:

Asunto: No objeción para viaje de {{empleado_nombre}}

Por medio de la presente, {{empresa_nombre}}, RNC {{empresa_rnc}}, con domicilio social en {{empresa_domicilio}}, HACE CONSTAR que:

El señor(a) {{empleado_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{empleado_cedula}}, labora en esta empresa desde el {{fecha_ingreso_larga}} en el cargo de {{cargo_ocupado}}.

Esta empresa NO TIENE OBJECIÓN a que realice un viaje a {{pais_destino}} entre el {{fecha_desde_larga}} y el {{fecha_hasta_larga}}, por motivo de {{motivo_viaje}}.

Se hace constar igualmente que su puesto de trabajo le será conservado y que se espera su reintegro a sus funciones el {{fecha_reintegro_larga}}.

La presente se expide a solicitud de la parte interesada, para los fines que estime convenientes.

Atentamente,


_______________________________
{{firmante_nombre}}
{{firmante_cargo}}
{{empresa_nombre}}
RNC {{empresa_rnc}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (19):** Cargo que ocupa · Ciudad de firma · Cédula del trabajador · Nombre del trabajador · Domicilio social · Razón social de la empresa · RNC de la empresa · Fecha de la carta · Fecha de inicio · Fecha de término · Fecha de ingreso a la empresa · Fecha de reintegro · Cargo de quien firma · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Motivo del viaje · País de destino

<sub>`carta-no-objecion-viaje` · categoría `cartas-migracion`</sub>

---

## Cartas · Familia

### Autorización de Viaje de Menor

*Los padres autorizan a que un menor de edad viaje, solo o acompañado por un tercero.*

**Base legal indicada:** Ley núm. 136-03, Código para el Sistema de Protección y los Derechos Fundamentales de Niños, Niñas y Adolescentes

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_institucion}}
{{destinatario_cargo}}
Ciudad.-

Asunto: Autorización de viaje del menor {{menor_nombre}}

Nosotros, {{padre_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{padre_cedula}}, y {{madre_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{madre_cedula}}, en nuestra calidad de padres del menor {{menor_nombre}}, nacido(a) el {{menor_fecha_nacimiento_larga}}, portador(a) del acta de nacimiento núm. {{menor_acta_nacimiento}} y del pasaporte núm. {{menor_pasaporte}}, por medio de la presente AUTORIZAMOS:

Que nuestro hijo(a) viaje a {{pais_destino}}, saliendo el {{fecha_salida_larga}} y regresando el {{fecha_regreso_larga}}, {{modalidad_viaje}}.

Persona responsable durante el viaje: {{acompanante_nombre}}, portador(a) de {{acompanante_documento}} núm. {{acompanante_documento_numero}}, con quien nos une el siguiente vínculo: {{vinculo_acompanante}}.

Lugar de alojamiento: {{lugar_alojamiento}}.

Autorizamos igualmente a que, en caso de emergencia médica y ante la imposibilidad de contactarnos, se le brinde la atención de urgencia que su salud requiera.

Podemos ser localizados en los teléfonos {{padre_telefono}} y {{madre_telefono}}.

ADVERTENCIA: la salida del país de un menor de edad exige autorización otorgada conforme a la ley y su presentación ante las autoridades migratorias; en la práctica se requiere que esté legalizada ante notario y, con frecuencia, apostillada. Este documento es el borrador del texto: confirme la formalidad exigida antes de viajar.

Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (27):** Tipo de documento del acompañante · Número del documento del acompañante · Nombre del acompañante · Ciudad de firma · Cargo del destinatario · Institución o empresa destinataria · Fecha de la carta · Fecha de regreso · Fecha de salida del país · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Lugar de alojamiento · Cédula de la madre · Nombre de la madre · Teléfono de la madre · Acta de nacimiento del menor · Fecha de nacimiento del menor · Nombre del menor · Pasaporte del menor · Cómo viaja el menor · Cédula del padre · Nombre del padre · Teléfono del padre · País de destino · Vínculo con el acompañante

<sub>`carta-autorizacion-viaje-menor` · categoría `cartas-familia`</sub>

---

### Consentimiento del Otro Progenitor

*Uno de los padres autoriza un trámite del hijo menor: pasaporte, escuela, cambio de centro o atención médica.*

**Base legal indicada:** Ley núm. 136-03, Código para el Sistema de Protección y los Derechos Fundamentales de Niños, Niñas y Adolescentes

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_institucion}}
{{destinatario_cargo}}
Ciudad.-

Asunto: Consentimiento para trámite del menor {{menor_nombre}}

Yo, {{firmante_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{firmante_cedula}}, en mi calidad de {{calidad_progenitor}} del menor {{menor_nombre}}, nacido(a) el {{menor_fecha_nacimiento_larga}}, portador(a) del acta de nacimiento núm. {{menor_acta_nacimiento}}, por medio de la presente doy mi CONSENTIMIENTO expreso para lo siguiente:

{{tramite_autorizado}}

Este consentimiento se otorga en interés superior del menor y podrá ser presentado ante {{destinatario_institucion}} para los fines correspondientes.

Anexo copia de mi cédula de identidad y electoral y del acta de nacimiento del menor.

Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (13):** Calidad en que firma · Ciudad de firma · Cargo del destinatario · Institución o empresa destinataria · Fecha de la carta · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Acta de nacimiento del menor · Fecha de nacimiento del menor · Nombre del menor · Trámite que se autoriza

<sub>`carta-consentimiento-progenitor` · categoría `cartas-familia`</sub>

---

## Cartas · Empresas

### Carta de Referencia Comercial

*Una empresa da referencia sobre el comportamiento comercial de un cliente o suplidor.*

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

A QUIEN PUEDA INTERESAR:

Asunto: Referencia comercial de {{referido_nombre}}

Por medio de la presente, {{empresa_nombre}}, RNC {{empresa_rnc}}, HACE CONSTAR que mantiene relaciones comerciales con {{referido_nombre}}, RNC o cédula núm. {{referido_identificacion}}, desde el {{fecha_inicio_relacion_larga}}.

Durante ese período, la relación se ha desarrollado en los siguientes términos:

Naturaleza de la relación: {{naturaleza_relacion}}
Volumen aproximado de operaciones: {{volumen_operaciones}}
Condiciones de pago pactadas: {{condiciones_pago}}
Comportamiento de pago observado: {{comportamiento_pago}}

{{observaciones_adicionales}}

La presente referencia se expide a solicitud de la parte interesada y refleja únicamente la experiencia de esta empresa. Quedamos a disposición para ampliarla en {{firmante_telefono}} o {{firmante_correo}}.

Atentamente,


_______________________________
{{firmante_nombre}}
{{firmante_cargo}}
{{empresa_nombre}}
RNC {{empresa_rnc}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (17):** Ciudad de firma · Comportamiento de pago observado · Condiciones de pago pactadas · Razón social de la empresa · RNC de la empresa · Fecha de la carta · Inicio de la relación comercial · Cargo de quien firma · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Naturaleza de la relación · Observaciones adicionales · RNC o cédula de quien se refiere · Nombre de quien se refiere · Volumen aproximado de operaciones

<sub>`carta-referencia-comercial` · categoría `cartas-empresas`</sub>

---

### Carta de Autorización de Representante

*La empresa designa a una persona para actuar en su nombre ante un tercero o una institución.*

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_institucion}}
{{destinatario_cargo}}
Ciudad.-

Asunto: Designación de representante

Por medio de la presente, {{empresa_nombre}}, RNC {{empresa_rnc}}, con domicilio social en {{empresa_domicilio}}, debidamente representada por el(la) suscrito(a) en su calidad de {{firmante_cargo}}, AUTORIZA al señor(a) {{autorizado_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{autorizado_cedula}}, quien ocupa el cargo de {{autorizado_cargo}} en esta empresa, para que la represente ante {{destinatario_institucion}} en lo siguiente:

{{gestion_encomendada}}

El representante queda facultado para firmar los formularios y recibos que la gestión requiera y para recibir las comunicaciones que de ella se deriven.

Esta autorización no comprende la facultad de contraer obligaciones a cargo de la empresa, ni de disponer de sus bienes o fondos, salvo lo expresamente indicado más arriba.

Vigencia: hasta el {{fecha_vencimiento_larga}}, o hasta que esta empresa comunique su revocación por escrito.

Atentamente,


_______________________________
{{firmante_nombre}}
{{firmante_cargo}}
{{empresa_nombre}}
RNC {{empresa_rnc}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (17):** Cargo de la persona autorizada · Cédula de la persona autorizada · Nombre de la persona autorizada · Ciudad de firma · Cargo del destinatario · Institución o empresa destinataria · Domicilio social · Razón social de la empresa · RNC de la empresa · Fecha de la carta · Fecha de vencimiento · Cargo de quien firma · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Gestión encomendada

<sub>`carta-autorizacion-representante` · categoría `cartas-empresas`</sub>

---

### Carta de Presentación de Empresa

*Presenta la empresa y sus servicios a un cliente potencial.*

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Presentación de {{empresa_nombre}}

Cortésmente le saludo en nombre de {{empresa_nombre}}, RNC {{empresa_rnc}}, empresa dedicada a {{actividad_empresa}} desde el año {{ano_fundacion}}.

{{presentacion_empresa}}

Los servicios que ofrecemos y que entendemos de interés para {{destinatario_institucion}} son:

{{servicios_ofrecidos}}

{{diferenciales}}

Quedo a su disposición para coordinar una reunión y presentarle una propuesta ajustada a sus necesidades, a través del teléfono {{firmante_telefono}} o del correo {{firmante_correo}}.

Atentamente,


_______________________________
{{firmante_nombre}}
{{firmante_cargo}}
{{empresa_nombre}}
RNC {{empresa_rnc}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (17):** Actividad de la empresa · Año de fundación · Ciudad de firma · Cargo del destinatario · Institución o empresa destinataria · Nombre del destinatario · Qué la diferencia · Razón social de la empresa · RNC de la empresa · Fecha de la carta · Cargo de quien firma · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Presentación de la empresa · Servicios que se ofrecen

<sub>`carta-presentacion-empresa` · categoría `cartas-empresas`</sub>

---

## Cartas · Compras y ventas

### Carta de Reclamación por Producto o Servicio Defectuoso

*Reclama directamente al comercio antes de acudir a Pro Consumidor.*

**Base legal indicada:** Ley núm. 358-05, General de Protección de los Derechos del Consumidor

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Reclamación por {{descripcion_producto}}

Cortésmente me dirijo a ustedes para presentar una RECLAMACIÓN formal.

En fecha {{fecha_compra_larga}} adquirí en su establecimiento {{descripcion_producto}}, por un valor de {{monto_pagado_letras}}, según {{comprobante_compra}}.

El problema que presenta es el siguiente:

{{descripcion_problema}}

{{gestiones_previas}}

En consecuencia, SOLICITO: {{pretension}}

Agradeceré una respuesta dentro de los {{dias_respuesta}} días siguientes al recibo de esta comunicación, al teléfono {{firmante_telefono}} o al correo {{firmante_correo}}.

De no recibir respuesta en dicho plazo, me reservo el derecho de acudir a Pro Consumidor y a las demás vías que la ley me reconoce.

Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (17):** Ciudad de firma · Comprobante de compra · Problema que presenta · Producto o servicio · Cargo del destinatario · Institución o empresa destinataria · Nombre del destinatario · Días para responder · Fecha de la carta · Fecha de la compra · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Gestiones ya realizadas · Monto pagado · Qué solicita

<sub>`carta-reclamacion-producto-defectuoso` · categoría `cartas-comercio`</sub>

---

### Carta de Oferta o Cotización Comercial

*Presenta por escrito el precio y las condiciones de un producto o servicio.*

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Cotización núm. {{numero_referencia}}

Cortésmente le saludo y, atendiendo a su solicitud, tengo a bien presentarle la siguiente oferta.

Objeto: {{objeto_oferta}}

Detalle:

{{detalle_oferta}}

Precio: {{precio_oferta_letras}}, {{itbis_incluido}}.
Forma de pago: {{forma_pago_oferta}}.
Plazo de entrega o ejecución: {{plazo_entrega}}.
Garantía: {{garantia_ofrecida}}.
Validez de esta oferta: {{dias_validez}} días a partir de su fecha.

{{condiciones_adicionales}}

Quedo a su disposición para cualquier aclaración en el teléfono {{firmante_telefono}} o el correo {{firmante_correo}}.

Atentamente,


_______________________________
{{firmante_nombre}}
{{firmante_cargo}}
{{empresa_nombre}}
RNC {{empresa_rnc}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (22):** Ciudad de firma · Condiciones adicionales · Cargo del destinatario · Institución o empresa destinataria · Nombre del destinatario · Detalle de la oferta · Días de validez de la oferta · Razón social de la empresa · RNC de la empresa · Fecha de la carta · Cargo de quien firma · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Forma de pago · Garantía ofrecida · ITBIS · Número de referencia o expediente · Objeto de la oferta · Plazo de entrega o ejecución · Precio ofertado

<sub>`carta-oferta-comercial` · categoría `cartas-comercio`</sub>

---

## Cartas · Legales

### Intimación de Pago

*Requiere formalmente el pago de una deuda vencida y deja constancia de la puesta en mora.*

**Base legal indicada:** Código Civil Dominicano, artículo 1139

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Intimación de pago

Por medio de la presente, y en mi calidad de acreedor(a), le INTIMO formalmente al pago de la suma que se detalla.

ORIGEN DE LA DEUDA: {{origen_deuda}}

MONTO ADEUDADO: {{monto_adeudado_letras}}
FECHA EN QUE SE HIZO EXIGIBLE: {{fecha_vencimiento_larga}}
{{detalle_intereses}}

En consecuencia, le requiero para que dentro del plazo de {{dias_plazo_pago}} días, contados a partir del recibo de esta comunicación, proceda al pago íntegro de dicha suma, mediante {{forma_pago_requerida}}.

Vencido el plazo sin haberse efectuado el pago, quedará usted constituido en mora y me reservo el derecho de accionar por las vías legales correspondientes, con los intereses, costas y honorarios que procedan.

ADVERTENCIA: la puesta en mora produce sus efectos plenos cuando se hace por acto de alguacil. Esta carta deja constancia del requerimiento, pero si la deuda es de importancia, encargue el acto a un abogado antes de que corran los plazos.

Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (15):** Ciudad de firma · Cargo del destinatario · Institución o empresa destinataria · Nombre del destinatario · Intereses o recargos · Días de plazo para pagar · Fecha de la carta · Fecha de vencimiento · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Cómo debe pagarse · Monto adeudado · Origen de la deuda

<sub>`carta-intimacion-de-pago` · categoría `cartas-legales`</sub>

---

### Carta de Descargo y Finiquito

*Quien recibe un pago declara que nada más se le adeuda por ese concepto.*

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_nombre}}
{{destinatario_cargo}}
{{destinatario_institucion}}
Su despacho.-

Asunto: Descargo y finiquito

Yo, {{firmante_nombre}}, portador(a) de la cédula de identidad y electoral núm. {{firmante_cedula}}, por medio de la presente DECLARO:

PRIMERO: Que he recibido de {{deudor_nombre}}, {{deudor_identificacion}}, la suma de {{monto_recibido_letras}}, mediante {{forma_pago_recibida}}, en fecha {{fecha_pago_larga}}.

SEGUNDO: Que dicha suma corresponde íntegramente a {{concepto_pago}}.

TERCERO: Que con el recibo de dicha suma otorgo el más amplio DESCARGO Y FINIQUITO por ese concepto, declarando que nada más se me adeuda por él y que no tengo reclamación alguna que formular al respecto.

ADVERTENCIA: firmar un descargo cierra la posibilidad de reclamar después por ese mismo concepto. Lea con cuidado qué está declarando recibido y por qué concepto. En materia laboral, un descargo firmado no impide reclamar los derechos que la ley declara irrenunciables, pero complica la reclamación: consulte a un abogado antes de firmar.

Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (15):** Ciudad de firma · Concepto del pago · Cargo del destinatario · Institución o empresa destinataria · Nombre del destinatario · Cédula o RNC de quien paga · Nombre de quien paga · Fecha de la carta · Fecha del pago · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Cómo se recibió el pago · Monto recibido

<sub>`carta-descargo-y-finiquito` · categoría `cartas-legales`</sub>

---

## Cartas · Impuestos

### Carta de Solicitud a la DGII

*Solicitud dirigida a la Dirección General de Impuestos Internos: constancias, autorizaciones o actualización de datos.*

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_institucion}}
{{destinatario_cargo}}
Ciudad.-

Asunto: Solicitud de {{objeto_solicitud}}

Cortésmente me dirijo a esa Dirección General para SOLICITAR lo siguiente:

{{objeto_solicitud}}

Datos del contribuyente:

Nombre o razón social: {{contribuyente_nombre}}
RNC o cédula: {{contribuyente_rnc}}
Domicilio fiscal: {{contribuyente_domicilio}}
Actividad económica: {{actividad_economica}}

Motivo de la solicitud:

{{fundamento_solicitud}}

Anexo la documentación de sustento: {{documentos_anexos}}

Agradeceré que la respuesta me sea comunicada al correo {{firmante_correo}} o al teléfono {{firmante_telefono}}.

Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (15):** Actividad económica · Ciudad de firma · Domicilio fiscal · Nombre o razón social del contribuyente · RNC o cédula del contribuyente · Cargo del destinatario · Institución o empresa destinataria · Documentos anexos · Fecha de la carta · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Por qué se solicita · Qué se solicita

<sub>`carta-solicitud-dgii` · categoría `cartas-impuestos`</sub>

---

### Respuesta a Requerimiento de la DGII

*Contesta dentro de plazo un requerimiento de información o una notificación de la DGII.*

```
{{ciudad_firma}}, República Dominicana
{{fecha_carta_larga}}

{{destinatario_institucion}}
{{destinatario_cargo}}
Ciudad.-

Asunto: Respuesta al requerimiento núm. {{numero_referencia}}

Acuso recibo del requerimiento núm. {{numero_referencia}}, de fecha {{fecha_requerimiento_larga}}, notificado el {{fecha_recepcion_larga}}, correspondiente al contribuyente {{contribuyente_nombre}}, RNC {{contribuyente_rnc}}, y dentro del plazo concedido doy respuesta.

Sobre el período fiscal {{periodo_fiscal}} y los puntos requeridos:

{{respuesta_requerimiento}}

Documentación que se acompaña:

{{documentos_anexos}}

{{reserva_derechos}}

Quedo a disposición de esa Dirección General para cualquier aclaración adicional.

ADVERTENCIA: los plazos en materia tributaria son perentorios y su vencimiento tiene consecuencias. Si el requerimiento anuncia una determinación de oficio o una sanción, consulte a un asesor fiscal o a un abogado tributario antes de responder.

Atentamente,


_______________________________
{{firmante_nombre}}
Cédula de identidad y electoral núm. {{firmante_cedula}}
{{firmante_telefono}} · {{firmante_correo}}
```

**Se le pregunta al usuario (17):** Ciudad de firma · Nombre o razón social del contribuyente · RNC o cédula del contribuyente · Cargo del destinatario · Institución o empresa destinataria · Documentos anexos · Fecha de la carta · Fecha en que se recibió · Fecha del requerimiento · Cédula de quien firma · Correo de contacto · Nombre de quien firma · Teléfono de contacto · Número de referencia o expediente · Período fiscal · Reserva de derechos · Respuesta a lo requerido

<sub>`carta-respuesta-requerimiento-dgii` · categoría `cartas-impuestos`</sub>

---

