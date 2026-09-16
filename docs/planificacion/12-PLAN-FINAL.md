# Plan de implementaciÃ³n final

**SAVE Documentos Â· SA&VE Comercial, S.R.L. â€” Punta Cana**
Consolida el plan anterior y los hallazgos de `SAVE-AUDITORIA-INTEGRAL.md`.
5 de septiembre de 2026 Â· Sustituye a `11-PLAN-DE-IMPLEMENTACION.md`

---

## La idea que ordena todo el plan

El producto funciona. Lo que falta estÃ¡ alrededor. Y hay **dos relojes distintos** que conviene no confundir:

- **Tiempo de abogada:** revisar 123 clÃ¡usulas y 251 plantillas. No se acelera escribiendo cÃ³digo, no se puede delegar y es lo mÃ¡s largo de todo el plan.
- **Tiempo de desarrollo:** todo lo demÃ¡s.

**Corren en paralelo.** El error caro serÃ­a tratarlos como una secuencia y quedarse esperando. Mientras la revisiÃ³n legal avanza, el desarrollo tiene semanas de trabajo Ãºtil por delante â€” y una de esas piezas, la importaciÃ³n de documentos, es precisamente la que hace que el producto sirva **mientras** el catÃ¡logo sigue sin aprobarse.

```mermaid
flowchart LR
  F0["F0 Â· Cerrar lo abierto"] --> F1["F1 Â· Bloqueos de uso"]
  F0 --> F2["F2 Â· REVISIÃ“N LEGAL<br/>123 clÃ¡usulas â†’ 251 plantillas"]
  F1 --> F3["F3 Â· Importar y convertir<br/>en plantilla"]
  F1 --> F4["F4 Â· Visibilidad nueva"]
  F1 --> F5["F5 Â· Confianza y conversiÃ³n"]
  F2 --> F6["F6 Â· Arquitectura SEO"]
  F5 --> F6
  F6 --> F7["F7 Â· AnalÃ­tica"]
  F3 --> F8["F8 Â· Rendimiento y accesibilidad"]
  F4 --> F8
  F7 --> F9["F9 Â· Cobros CardNET"]
  F8 --> F9
```

**El camino crÃ­tico hacia la adquisiciÃ³n orgÃ¡nica es F2 â†’ F6 â†’ F7.** Todo lo demÃ¡s puede adelantarse o retrasarse sin mover esa fecha.

---

## Los tres planes

Decidido el 5 de septiembre. Cierra D1, D2 y D4.

| | **Gratis** | **Pro** Â· RD$999/mes | **Equipo** Â· RD$1,699/mes |
|---|---|---|---|
| Plantillas del catÃ¡logo | 50 | Las 251 | Las 251 |
| Documentos al mes | 5 | 30 | Sin tope |
| BÃ³veda | 10 | 30 | 100, y +30 por integrante adicional |
| Crear plantilla desde un documento | â€” | SÃ­ | SÃ­ |
| Despacho con equipo | â€” | â€” | SÃ­ |
| Usuarios | 1 | 1 | Titular + 2 incluidos |
| Usuario adicional | â€” | â€” | RD$399/mes |

**CÃ³mo se cuenta la bÃ³veda de Equipo.** Los 100 ya cubren al titular y a los dos
incluidos. El cuarto integrante sube el tope a 130, el quinto a 160, y asÃ­.
La bÃ³veda se cuenta **por despacho, no por persona** â€” y eso ahorra trabajo real:
los archivos ya se guardan en `{org_id}/`, asÃ­ que no hay que cambiar la
convenciÃ³n de rutas ni mover nada de lo subido.

**Las 50 plantillas del plan gratis** se calculan solas: las mÃ¡s usadas por nÃºmero
de documentos generados, recalculadas cada semana. **Con una salvedad para el
arranque**, porque hoy hay cero documentos generados y un ranking sin datos sale
vacÃ­o: mientras una plantilla no tenga uso, el desempate es por categorÃ­a, las
mejores de cada una de las once en rotaciÃ³n. AsÃ­ el escaparate gratuito cubre
todas las categorÃ­as desde el primer dÃ­a en vez de ser cincuenta contratos de
vehÃ­culos, y en cuanto haya uso real el ranking lo corrige solo.

**La asimetrÃ­a de los dos defaults, que es deliberada:**

- **Documentos:** todo el despacho los ve, salvo que el autor los marque privados.
- **BÃ³veda:** nadie los ve, salvo que el autor los marque visibles para el despacho.

Son defaults opuestos a propÃ³sito. La bÃ³veda es el archivo de originales
sensibles â€”cÃ©dulas, tÃ­tulos, poderes firmadosâ€”; los documentos son el trabajo en
curso del despacho. Hay que **contÃ¡rselo asÃ­ al usuario** en la interfaz: si no,
alguien subirÃ¡ algo dando por hecho que se comporta como lo otro.

**Y lo que hay que saber antes de estimar nada:** hoy **ningÃºn lÃ­mite se aplica**.
`free_limit` y `vault_limit` existen en la tabla y se pintan en pantalla, pero
solo la bÃ³veda comprueba el suyo. No hay tope de documentos de ninguna clase, ni
control de quÃ© plantillas ve cada plan. Los tres planes se implementan desde
cero; no es ajustar nÃºmeros existentes.

---

## CÃ³mo se lee cada tarea

Cada una lleva **quÃ©**, **por quÃ©**, **dÃ³nde** y **cuÃ¡ndo estÃ¡ hecha**. Ese Ãºltimo campo es el que importa: una tarea no estÃ¡ hecha porque exista el cÃ³digo, sino porque se comprobÃ³ que hace lo que decÃ­a. Los tiempos son estimaciones gruesas de una persona desarrollando.

---

# FASE 0 Â· Cerrar lo abierto

> ## âœ… CERRADA Â· 5 de septiembre de 2026
>
> Las tres tareas hechas y comprobadas. Con esto **no queda ningÃºn problema
> crÃ­tico abierto** en el proyecto.

**Lo que costÃ³ de verdad:** una hora, mÃ¡s un fallo que apareciÃ³ por el camino
y que merece quedar escrito (ver 0.2).

### 0.1 Rotar las dos credenciales expuestas Â· P0 Â· ðŸ‘¤

**QuÃ©.** Cambiar la contraseÃ±a del buzÃ³n de Hostinger y la contraseÃ±a de aplicaciÃ³n, y reescribir la configuraciÃ³n SMTP completa en Supabase.

**Por quÃ©.** Las dos quedaron en texto plano durante el proyecto. Es el Ãºnico riesgo de seguridad realmente abierto.

**Ojo con esto:** un PATCH parcial a `/config/auth` de Supabase **borra** el campo en vez de actualizarlo. Hay que reenviar el bloque entero. `scripts/configurar-smtp-supabase.ps1` ya lo hace bien.

**Hecho cuando:** un registro de prueba recibe su correo de confirmaciÃ³n con las credenciales nuevas.

**âœ… Hecho el 5 de septiembre.** Credenciales rotadas y SMTP funcionando.

### 0.2 Verificar robots.txt y sitemap.xml en el dominio

**QuÃ©.** Comprobar que los dos responden 200 en producciÃ³n.

**Por quÃ©.** Se generan en el build. Existen en el repositorio, pero eso no es lo mismo que existir en el dominio.

**Hecho cuando:** `savedocumentos.com/robots.txt` menciona el sitemap y `savedocumentos.com/sitemap.xml` contiene la portada.

**âœ… Hecho el 5 de septiembre â€” y aquÃ­ apareciÃ³ un fallo que valida la tarea.**

Los dos seguÃ­an devolviendo 404 **con el cÃ³digo ya subido a origin**. No era
falta de despliegue: `/login` tampoco traÃ­a el `noindex` del mismo commit, lo
que descartaba a Railway y seÃ±alaba al build.

La causa: `robots.ts` y `sitemap.ts` importaban `getSiteUrlEstatico` desde
`lib/siteUrl.ts`, y ese archivo empieza con `import { headers } from 'next/headers'`.
Los dos son **rutas estÃ¡ticas** â€”Next las genera en el build, cuando no existe
ninguna peticiÃ³n que tenga cabecerasâ€”, asÃ­ que arrastrar `next/headers`, aunque
sea de rebote, las rompe. La versiÃ³n sin cabeceras se mudÃ³ a `lib/dominio.ts`,
que no importa nada de Next.

**La lecciÃ³n, que es el motivo de que esta tarea exista:** el cÃ³digo estaba
escrito, revisado y subido, y no estaba hecho. Sin comprobarlo contra el dominio
habrÃ­amos dado por buenos dos archivos que no existÃ­an.

### 0.3 Cerrar la prueba de privacidad de documentos

**QuÃ©.** Quitar el compartir del documento de prueba y recargar como paralegal.

**Por quÃ©.** Es lo Ãºnico del modelo de privacidad que estÃ¡ verificado sobre PostgreSQL pero no en producciÃ³n. Con un solo documento compartido, ver uno no demuestra nada.

**Hecho cuando:** el documento desaparece de la lista del paralegal.

**âœ… Hecho el 5 de septiembre.** Quitado el compartir, el paralegal â€”dentro del
mismo despacho, con la cabecera diciendo "Despacho de elianastephaniaâ€¦"â€” pasÃ³ a
ver **cero documentos**. El documento existe y es del despacho; no lo ve porque
nadie se lo compartiÃ³. Privacidad probada por los dos lados.

> Esta prueba pierde sentido cuando entre F4, que invierte el modelo. **Hacerla antes.**

---

# FASE 1 Â· Bloqueos de uso

> ## âœ… CERRADA Â· 5 de septiembre de 2026
>
> Las seis tareas hechas. Queda solo 1.7, que es P3 y se harÃ¡ junto con 8.1
> porque tocan el mismo archivo.
>
> **Verificado en producciÃ³n con sesiÃ³n iniciada:** el menÃº mÃ³vil se abre a
> 606 px, atrapa el foco, bloquea el scroll de fondo y muestra solo las seis
> secciones que le tocan a un paralegal. El panel ya lee del plan:
> *"Plan Equipo: sin tope"* y bÃ³veda *"0 / 100"*, que es la fÃ³rmula
> funcionando con un despacho de dos integrantes.

### 1.1 MenÃº de navegaciÃ³n en mÃ³vil Â· P1

**QuÃ©.** MenÃº hamburguesa para el Ã¡rea privada por debajo de 768 px.

**Por quÃ©.** El `<aside>` es `hidden md:block`: en un telÃ©fono **desaparece y no hay sustituto**. Quien entre a `/app/documents` no puede llegar a Plantillas, BÃ³veda ni Mi Despacho salvo escribiendo la URL a mano.

**DÃ³nde.** `src/app/app/layout.tsx`, `src/components/ui/AppNav.tsx`

**Hecho cuando:** a 375 px se puede llegar a las seis secciones sin tocar la barra de direcciones.

**âœ… Hecho.** `AppNav` pasa a exportar la lista de enlaces y el menÃº mÃ³vil usa esa misma: si cada uno tuviera la suya, una secciÃ³n nueva aparecerÃ­a en uno y no en el otro.

### 1.2 Buscador y paginaciÃ³n en Plantillas Â· P2

**QuÃ©.** Campo de bÃºsqueda por tÃ­tulo y categorÃ­a, y paginaciÃ³n o carga progresiva.

**Por quÃ©.** 251 tarjetas de golpe son 7.147 nodos en el Ã¡rbol. En un telÃ©fono pesa, y encontrar una plantilla concreta obliga a recorrerlas todas. `ClausesClient` ya tiene un buscador que sirve de modelo.

**DÃ³nde.** `src/app/app/templates/TemplatesClient.tsx`

**Hecho cuando:** escribir "alquiler" deja a la vista solo las de alquiler, y la pÃ¡gina monta menos de 2.000 nodos.

**âœ… Hecho.** BÃºsqueda por nombre, categorÃ­a y descripciÃ³n, filtro por categorÃ­a y tandas de 24. Las categorÃ­as del filtro salen de lo que hay en la lista, no de una escrita a mano â€” una fija se habrÃ­a quedado desfasada, como ya pasÃ³ con las diez de la portada frente a las once de la base.

### 1.3 Aplicar los tres planes Â· P1

**QuÃ©.** Que los lÃ­mites de la tabla de arriba se cumplan de verdad.

**Por quÃ©.** Hoy no se aplica ninguno salvo el de la bÃ³veda. Un despacho en
Equipo pagando RD$1,699 tiene exactamente las mismas restricciones que uno
gratuito: ninguna.

**Las cuatro piezas:**

1. **Tope mensual de documentos.** No hace falta columna nueva ni contador que
   mantener: se cuenta `documents` con `created_at >= date_trunc('month', now())`
   para ese despacho. Un contador guardado se desincroniza; una consulta, no.
2. **Cupo de bÃ³veda por plan**, con la fÃ³rmula de Equipo: `100 + 30 Ã— (integrantes âˆ’ 3)`,
   con suelo en 100.
3. **Las 50 plantillas del gratis.** Columna `es_gratuita` en `templates`, mantenida
   por una funciÃ³n que se recalcula cada semana, y la polÃ­tica de lectura del
   catÃ¡logo la respeta.
4. **Importar solo desde Pro** (ver Fase 3).

**DÃ³nde.** `src/lib/billing.ts`, migraciÃ³n sobre `organizations`, polÃ­ticas de
`templates`, `src/app/app/documents/new/`, `src/app/app/vault/actions.ts`

**Hecho cuando:** una cuenta gratuita genera cinco documentos y el sexto se
detiene con un mensaje que explica por quÃ© y quÃ© hacer; y un despacho de cuatro
personas ve 130 de cupo en la bÃ³veda, no 100.

**âœ… Hecho.** Los nÃºmeros viven en la tabla `planes`, que leen tanto la aplicaciÃ³n como el trigger. El periodo de gracia se modela como *plan efectivo*: pasados los siete dÃ­as rige `CANCELLED`, con 0 documentos y 0 de bÃ³veda â€” y cero de bÃ³veda no impide leer ni descargar, solo subir, que es exactamente "solo lectura" sin una lÃ­nea de lÃ³gica especial.

### 1.4 La bÃ³veda: privada por defecto Â· P1 Â· âœ… decidido

**QuÃ©.** Cada archivo nace privado. Su dueÃ±o decide si lo hace visible para el
despacho.

**Por quÃ©.** Hoy las polÃ­ticas del bucket aÃ­slan por `org_id` y nada mÃ¡s: **todos
los miembros ven todo lo que suba cualquiera**. No se nota porque estÃ¡ vacÃ­a; en
cuanto se suban archivos, sÃ­.

**Lo que NO hay que hacer, y conviene dejarlo escrito:** no hay que cambiar la
convenciÃ³n de rutas. Al contarse por despacho y no por persona, `{org_id}/archivo`
sigue sirviendo. Se aÃ±ade una columna de propiedad y visibilidad, y las polÃ­ticas
la consultan. Media jornada menos de la que estaba estimada.

**DÃ³nde.** `supabase/migrations/20260822000001_vault_storage_bucket.sql`,
`src/app/app/vault/`

**Hecho cuando:** un paralegal sube un archivo, su compaÃ±ero no lo ve, y al
marcarlo visible aparece.

**âœ… Hecho.** Con el titular como excepciÃ³n, que obliga a cuidar el lenguaje: llamar "Privado" a secas a un archivo que su jefa sÃ­ ve serÃ­a prometer de mÃ¡s, asÃ­ que en pantalla dice **"Solo tÃº y el titular"**.

### 1.5 Textos que contradicen al producto Â· P2

**QuÃ©.** Corregir *"Debe tener ya una cuenta en Save Documentos"* en Mi Despacho.

**Por quÃ©.** Desde la Fase 1 se puede invitar a alguien sin cuenta y la crea Ã©l. El texto dice lo contrario y hace que no se use una funciÃ³n que ya existe.

**DÃ³nde.** `src/app/app/settings/SettingsClient.tsx`

**Hecho cuando:** el texto describe el comportamiento real.

**âœ… Hecho.**

### 1.6 Pedir el nombre a quien llega invitado Â· P3

**QuÃ©.** Que `/definir-password` pida nombre y apellido junto con la contraseÃ±a.

**Por quÃ©.** Sin nombre, el botÃ³n de compartir dice *"Compartir con stephaniamontero84+prueba2@gmail.com"* en vez de *"Compartir con Juana MartÃ­nez"*, que es como se pidiÃ³.

**DÃ³nde.** `src/app/definir-password/`

**Hecho cuando:** el panel de compartir muestra nombres.

**âœ… Hecho.** Se pide al crear la contraseÃ±a, el Ãºnico momento en que esa persona estÃ¡ obligada a pasar por una pantalla. Y se guarda *despuÃ©s* de la contraseÃ±a: si el nombre fallara ya puede entrar y lo arregla luego; al revÃ©s, un fallo la dejarÃ­a fuera de su cuenta por un dato cosmÃ©tico.

### 1.7 `middleware.ts` â†’ `proxy.ts` Â· P3

**QuÃ©.** La migraciÃ³n de nombre que Next 16 pide. Aplazada desde la Fase 0 por decisiÃ³n propia.

**Se hace junto con 8.1**, que toca el mismo archivo.

---

# FASE 2 Â· RevisiÃ³n legal del catÃ¡logo

**El camino crÃ­tico. Tiempo de abogada, no de desarrollo. Estimado: 3 a 6 semanas.**

> **El orden no es negociable: primero las 123 clÃ¡usulas, despuÃ©s las 251 plantillas.** `quality.ts` impide publicar una plantilla maestra si alguna de sus clÃ¡usulas sigue en borrador. Al revÃ©s, las plantillas rebotan una por una.

### 2.1 Dar de alta a la abogada

**QuÃ©.** Que `legalcifuentes@gmail.com` se registre.

**Por quÃ©.** La migraciÃ³n `20260902000000` ya dejÃ³ su permiso apuntado por correo. El trigger enlaza la cuenta sola al registrarse.

**Hecho cuando:** entra y ve "RevisiÃ³n" en el menÃº, con el contador en 0 de 251 y 0 de 123.

### 2.2 Aprobar las 123 clÃ¡usulas

**QuÃ©.** Leer, corregir donde haga falta y aprobar. La pantalla permite editar el texto sin salir.

**Ritmo realista:** entre 15 y 30 al dÃ­a sin que la calidad se resienta. Entre cinco y ocho jornadas.

**Hecho cuando:** el contador de clÃ¡usulas llega a 123.

### 2.3 Aprobar las 251 plantillas

**QuÃ©.** Igual, ya sin bloqueantes de variables ni de clÃ¡usulas.

**Por quÃ© importa el orden:** solo cuando 2.2 estÃ© cerrada desaparece el bloqueante *"N clÃ¡usulas siguen en borrador"*.

**Hecho cuando:** el nÃºmero de la portada deja de decir "estamos terminando de revisar el catÃ¡logo" y empieza a contar. Ese contador ya estÃ¡ puesto y sube solo.

### 2.4 Estado RECHAZADA Â· P2

**QuÃ©.** Un estado para lo que la abogada descarta, con motivo.

**Por quÃ©.** Hoy solo se usan DRAFT y PUBLISHED. Una plantilla mala se queda en borrador, **indistinguible de una que nadie ha mirado todavÃ­a**. Con 251 por revisar, esa diferencia se pierde enseguida.

**CÃ³mo.** Usar `ARCHIVED`, que ya estÃ¡ en el enum, mÃ¡s una columna de motivo.

**Hecho cuando:** se puede rechazar con motivo y el rechazado no vuelve a aparecer en la cola.

### 2.5 Limpieza del catÃ¡logo Â· P3

- Renombrar `dia_pago` o `dias_pago`: significan cosas distintas y estÃ¡n a un carÃ¡cter.
- Revisar *"DepÃ³sito de garantÃ­a"* y *"DepÃ³sito en garantÃ­a"*.
- Normalizar los saltos de lÃ­nea: 8 retornos de carro por documento, herencia del CRLF de Windows.

---

# FASE 3 Â· Importar documentos y convertirlos en plantillas

**Estimado: 2 a 3 semanas. Va aquÃ­ por una razÃ³n concreta.**

Mientras la abogada revisa, un cliente nuevo entra y **ve un catÃ¡logo vacÃ­o**. Son semanas de producto inservible. Pero si puede subir el contrato que ya usa y convertirlo en plantilla, SAVE le sirve desde el primer dÃ­a **sin depender de la revisiÃ³n legal** â€” y ademÃ¡s es la propuesta de valor que la propia portada anuncia: *"Cualquier documento que repitas puede volverse una plantilla."*

Hoy esa frase no es cierta. Esta fase la hace cierta.

### 3.1 Subir e interpretar el documento

**QuÃ©.** Aceptar `.docx` y pegado de texto plano, y extraer el contenido.

**CÃ³mo.** Un `.docx` es un ZIP con `word/document.xml` dentro. `jszip` ya estÃ¡ en el proyecto para exportar; sirve igual para leer. **Sin dependencias nuevas.**

**DÃ³nde.** `src/lib/engine/import.ts` (nuevo)

**Hecho cuando:** se sube un contrato real y sale su texto con los pÃ¡rrafos separados.

### 3.2 Detectar candidatos a variable

**QuÃ©.** Proponer quÃ© partes del texto deberÃ­an ser variables.

**QuÃ© buscar**, y aquÃ­ el motor dominicano que ya existe hace casi todo:
- CÃ©dulas con el formato `000-0000000-0` â†’ `validateCedula` ya las valida
- RNC â†’ `validateRNC`
- Montos en RD$ o US$ â†’ `montoALetras` ya sabe convertirlos
- Fechas
- Nombres en mayÃºsculas sostenidas, tÃ­picos de los comparecientes
- Cualquier texto que se repita idÃ©ntico tres veces o mÃ¡s

**El diseÃ±o que importa:** la detecciÃ³n **propone**, no decide. La persona confirma cada una, le pone nombre y elige si reutiliza una variable del diccionario de 100 que ya existe o crea una nueva. Un importador que decide solo produce plantillas que nadie entiende.

**DÃ³nde.** `src/lib/engine/import.ts`, `src/lib/engine/dominican.ts` (reutilizar)

**Hecho cuando:** sobre un contrato de alquiler real, propone al menos las cÃ©dulas, el precio y las fechas, y ninguna propuesta falsa evidente.

### 3.3 Pantalla de conversiÃ³n

**QuÃ©.** El texto a la izquierda, las variables propuestas a la derecha, y confirmar una por una.

**DÃ³nde.** `src/app/app/templates/importar/` (nuevo)

**Hecho cuando:** de un `.docx` sale una plantilla del despacho, con su formulario, y genera un documento correcto.

### 3.4 Enganchar con el diccionario existente

**QuÃ©.** Que al confirmar una variable ofrezca primero las 100 que ya existen.

**Por quÃ©.** Si cada importaciÃ³n crea `nombre_comprador`, `comprador_nombre` y `nombre_del_comprador`, el diccionario se vuelve inÃºtil en un mes. Es exactamente el problema que la auditorÃ­a pedÃ­a evitar.

**Hecho cuando:** importar dos contratos parecidos reutiliza variables en vez de duplicarlas.

### 3.5 Restringir a Pro y Equipo

**QuÃ©.** La importaciÃ³n es de pago. Crear plantillas **a mano**, desde cero, sigue
disponible en el plan gratuito.

**Por quÃ©.** Es lo que separa Pro del gratis en la tabla de planes, junto con el
catÃ¡logo completo. Y la distinciÃ³n es limpia de explicar: gratis puedes escribir
una plantilla; pagando, conviertes la que ya tienes.

---

# FASE 4 Â· El modelo de visibilidad nuevo

**Estimado: 3 a 4 dÃ­as. Decidido el 4 de septiembre.**

**Invierte** el modelo construido el 1 de septiembre. Antes: cada uno ve lo suyo, mÃ¡s lo que le compartan. Ahora: **todo el despacho ve todo, salvo lo que su autor marque como privado.**

### 4.1 La migraciÃ³n, con su lÃ­nea delicada

```sql
ALTER TABLE documents ADD COLUMN es_privado BOOLEAN NOT NULL DEFAULT false;

-- Lo que ya existe se creÃ³ bajo la promesa de que solo lo veÃ­a su autor.
UPDATE documents SET es_privado = true;
```

**Ese `UPDATE` es una lÃ­nea y sin Ã©l, el dÃ­a del despliegue, todo el despacho verÃ­a documentos escritos creyendo que eran privados.** De ahÃ­ en adelante, lo nuevo nace visible y quien quiera lo marca.

### 4.2 PolÃ­tica de lectura

`documents_select` vuelve a admitir a los miembros del despacho, **excepto** cuando `es_privado = true` y quien mira no es ni el autor, ni el titular, ni alguien con quien se compartiÃ³ expresamente.

**Se aprovecha lo que ya estÃ¡ construido:** `document_shares` y las tres funciones `SECURITY DEFINER` no se tiran. Cambian de sentido â€” de "conceder acceso" a "dar acceso a un documento privado" â€” y la trampa de recursiÃ³n que resolvieron sigue resuelta.

**DÃ³nde.** MigraciÃ³n nueva, apoyada en `20260901000000_documentos_privados_y_compartir.sql`

### 4.3 Interfaz

- Interruptor **Privado** en la vista del documento, solo para el autor y el titular
- El botÃ³n Compartir aparece **solo** en los documentos privados: en los demÃ¡s no hay nada que compartir
- Indicador visible de que un documento es privado, en la lista y en el detalle

### 4.4 Volver a probarlo entero

**QuÃ©.** Rehacer sobre el modelo nuevo la prueba de los tres perfiles: titular, y dos paralegales.

**Hecho cuando:** un paralegal ve los documentos normales de su compaÃ±ero, **no** ve los privados, y sÃ­ ve el privado que le compartieron.

---

# FASE 5 Â· Confianza y conversiÃ³n

**Estimado: 1 a 2 semanas, la mayor parte redacciÃ³n.**

Para un producto legal que guarda cÃ©dulas y domicilios ajenos, esto pesa mÃ¡s que cualquier optimizaciÃ³n tÃ©cnica. Hoy **no existe ninguna de estas pÃ¡ginas** y la portada solo enlaza a registro, login y un ancla.

### 5.1 Las cuatro pÃ¡ginas que faltan Â· P1

| PÃ¡gina | Por quÃ© |
|---|---|
| **TÃ©rminos de servicio** | Ninguna empresa contrata un SaaS sin ellos |
| **PolÃ­tica de privacidad** | El producto almacena datos personales de terceros. No es opcional |
| **Contacto** | Sin forma de contactar no hay confianza ni soporte |
| **Precios** | Hoy no se puede saber lo que cuesta sin registrarse |

**Hecho cuando:** las cuatro estÃ¡n enlazadas desde un pie de pÃ¡gina global.

### 5.2 QuiÃ©nes somos Â· P1

**QuÃ©.** Nombre legal â€”SA&VE Comercial, S.R.L.â€”, sede en Punta Cana y, cuando el catÃ¡logo estÃ© aprobado, quiÃ©n lo revisÃ³.

**Por quÃ©.** Lo mejor que tiene SAVE en credibilidad **no se estÃ¡ contando**: el sistema **impide** publicar una plantilla maestra sin la firma de un profesional. Eso es exactamente la seÃ±al que Google busca en el sector legal, y hoy no aparece en ninguna parte del sitio.

### 5.3 Imagen Open Graph Â· P1

**QuÃ©.** Una imagen de 1200Ã—630 y su metadata.

**Por quÃ©.** `public/` estÃ¡ vacÃ­a: al compartir el enlace por WhatsApp sale una tarjeta en blanco. Para un producto que se recomienda entre profesionales, eso cuesta clics todos los dÃ­as.

**Nombre del archivo:** `save-documentos-og.png`, en minÃºsculas y con guiones.

### 5.4 Schema de la portada Â· P2

AÃ±adir `Organization` â€”con datos realesâ€” y `FAQPage`, que es legÃ­timo porque las cinco preguntas **estÃ¡n visibles** en la pÃ¡gina.

**No se implementa `LocalBusiness`.** SAVE es un SaaS: nadie va a Punta Cana a recoger un contrato. Poner horarios y direcciÃ³n serÃ­a describir un negocio que no funciona asÃ­.

### 5.5 El `www` Â· P2

`www.savedocumentos.com` no resuelve en DNS. Mucha gente lo teclea. Un CNAME y un 301 hacia el dominio sin `www`.

---

# FASE 6 Â· Arquitectura SEO

**Estimado: 3 a 4 semanas. Depende de F2: sin plantillas aprobadas no hay pÃ¡ginas que publicar.**

Hoy el sitio pÃºblico es **una pÃ¡gina**. Esta es la fase que convierte SAVE en algo que se puede encontrar.

### 6.1 Alinear las categorÃ­as Â· P2

**QuÃ©.** Que la portada lea las categorÃ­as de la base en vez de tener diez escritas a mano.

**Por quÃ©.** La portada anuncia diez; la base tiene **once**, con nombres distintos. *Administrativo* y *Personal* no existen en el producto; *Servicios Profesionales*, *TecnologÃ­a* y *Marketing* sÃ­ existen y no se anuncian.

### 6.2 PÃ¡gina pilar `/plantillas`

QuÃ© es el catÃ¡logo, para quiÃ©n, y las once categorÃ­as enlazadas.

### 6.3 Once pÃ¡ginas de cluster `/plantillas/{slug}`

Una por categorÃ­a real. Cada una con: H1, un pÃ¡rrafo de quÃ© cubre, **CTA justo despuÃ©s**, la rejilla de plantillas publicadas, "Lo mÃ¡s importante" en cinco puntos, FAQ de tres a cinco preguntas reales, y enlaces al pilar y a dos clusters hermanos.

### 6.4 Hojas de plantilla `/plantillas/{slug-plantilla}`

**Generadas desde la base.** `title`, `description`, categorÃ­a y variables ya existen: **no hay que escribir 251 pÃ¡ginas a mano.**

**La regla que protege el proyecto:** una hoja se publica **solo** si su plantilla estÃ¡ `PUBLISHED`. Publicar borradores serÃ­a exponer texto jurÃ­dico sin revisar y tenderle a Google 251 pÃ¡ginas casi vacÃ­as.

### 6.5 Enlazado interno

Migas de pan en las hojas, enlaces a tres plantillas hermanas, y desde cada hoja el CTA transaccional a registro. Ninguna pÃ¡gina huÃ©rfana, y de la portada a cualquier hoja, tres saltos como mucho.

### 6.6 Sitemap dinÃ¡mico

```ts
const { data } = await supabase
  .from('templates')
  .select('slug, updated_at')
  .eq('is_master', true)
  .eq('status', 'PUBLISHED')
```

AsÃ­ **crece solo**, al ritmo que la abogada aprueba, sin volver a desplegar.

---

# FASE 7 Â· AnalÃ­tica

**Estimado: 2 dÃ­as mÃ¡s una acciÃ³n manual. Depende de F6: medir una sola pÃ¡gina da poco.**

### 7.1 GA4 Â· P1

**QuÃ©.** Instalar GA4 con ocho eventos: `sign_up`, `login`, `template_view`, `template_start`, `document_created`, `document_download`, `document_shared`, `cta_click`.

**Por quÃ©.** `gtag` es `undefined` en producciÃ³n. No estÃ¡ mal configurado: **no estÃ¡**. Arrancar adquisiciÃ³n sin medirla es gastar sin saber en quÃ©.

**Ojo:** `NEXT_PUBLIC_GA_ID` se congela en el build. **Hay que redesplegar.**

### 7.2 Search Console Â· ðŸ‘¤

Propiedad por **prefijo de URL** â€”no por dominio, que exige DNS y el `www` ni resuelveâ€”, verificaciÃ³n por etiqueta HTML, y enviar `sitemap.xml`.

**Hecho cuando:** a las 48 horas la portada aparece como "Indexada" y el sitemap en estado "Correcto".

### 7.3 Consentimiento de cookies

Si hay trÃ¡fico europeo, banner previo a GA4. Hoy no hace falta porque no hay cookies de terceros; en cuanto entre GA4, sÃ­.

---

# FASE 8 Â· Rendimiento y accesibilidad

**Estimado: 1 semana.**

### 8.1 Restringir el `matcher` del middleware Â· P2 Â· el mejor cambio por esfuerzo

**QuÃ©.** Que el middleware cubra solo `/app/*`, `/auth/*` y las pantallas de sesiÃ³n.

**Por quÃ©.** Hoy corre en **todas** las rutas y llama a `supabase.auth.getUser()` en cada peticiÃ³n. Un visitante anÃ³nimo paga una llamada de red a Supabase para ver una pÃ¡gina estÃ¡tica â€” y la portada es justo donde va a aterrizar todo el trÃ¡fico orgÃ¡nico de F6.

**Se aprovecha para hacer 1.7**, el cambio de nombre a `proxy.ts`.

### 8.2 Fuentes con `next/font` Â· P2

La hoja de Google Fonts bloquea el renderizado. `next/font` la incrusta y quita el salto de tipografÃ­a.

### 8.3 Etiquetas de formulario Â· P2

**QuÃ©.** `id` en cada campo y `htmlFor` en su etiqueta.

**Por quÃ©.** NingÃºn campo del generador tiene etiqueta asociada. Se ven bien, pero un lector de pantalla dice "campo de ediciÃ³n" dieciocho veces seguidas.

**DÃ³nde.** `src/app/app/documents/new/[templateId]/GeneratorClient.tsx`

### 8.4 Modo oscuro: terminarlo o retirarlo Â· P2

**Hay que elegir.** Hoy `<html class="light">` estÃ¡ fijo, no hay botÃ³n, y **47 archivos** llevan clases `dark:` que no se activan nunca. Es cÃ³digo muerto que se lee, se mantiene y se copia cada vez que se escribe una pantalla nueva.

- **Terminarlo:** botÃ³n, clase en `<html>`, `localStorage`, valor inicial desde `prefers-color-scheme` y un script en lÃ­nea contra el parpadeo. Los 47 archivos ya estÃ¡n escritos: el trabajo real es pequeÃ±o.
- **Retirarlo:** quitar las clases y dejar de fingir.

Lo que no conviene es dejarlo como estÃ¡.

### 8.5 Medir de verdad

Core Web Vitals con PageSpeed Insights **despuÃ©s** de 8.1 y 8.2, no antes. Optimizar sin medir es adivinar.

---

# FASE 9 Â· Cobros con CardNET

**Estimado: 1 a 2 semanas de cÃ³digo, mÃ¡s el trÃ¡mite de afiliaciÃ³n. Decidido el 8 de septiembre.**

**PayPal queda descartado.** No por capricho: en RepÃºblica Dominicana solo se retira a travÃ©s de Banco Popular, **en dÃ³lares**, y **Banco Popular cobra USD $10 fijos por cada retiro** sin importar el monto, con cinco dÃ­as laborables de espera. Con suscripciones de RD$999 â€”unos 16 dÃ³laresâ€” ese peaje se come la mitad de un cliente cada vez que sacas dinero. Y encima obliga a cobrarle en dÃ³lares a un dominicano un producto anunciado en pesos.

**Stripe tampoco es una opciÃ³n:** RepÃºblica Dominicana no estÃ¡ en su lista de paÃ­ses soportados.

**CardNET** cobra 3,75â€“4,25%, en pesos, deposita en tu cuenta local en 48â€“72 horas y admite cobros recurrentes. Requiere afiliaciÃ³n comercial con RNC, que SAVE ya tiene.

## LA DIFERENCIA QUE CAMBIA LA ARQUITECTURA

El plan anterior decÃ­a *"webhook de pago que actualice `sub_status`"*. **Eso era pensar en PayPal, y con CardNET no funciona asÃ­.**

PayPal es un modelo pasivo: PayPal cobra todos los meses por su cuenta y te avisa por webhook. CardNET es al revÃ©s: se guarda una **ficha de la tarjeta** (*Card on File*) y **es SAVE quien inicia el cobro cada mes**.

Consecuencias, y ninguna es menor:

- Hace falta un **proceso programado mensual** que recorra los despachos con suscripciÃ³n activa y les cobre. No existe hoy.
- **El resultado del cobro llega en la misma respuesta**, no por webhook. Es mÃ¡s simple de razonar, pero significa que si el proceso se cae a medias hay que saber por dÃ³nde iba.
- Los **reintentos son nuestros**. Si una tarjeta falla, decidimos nosotros cuÃ¡ndo volver a intentarlo antes de mandar el despacho al periodo de gracia.

### 9.0 AfiliaciÃ³n comercial Â· ðŸ‘¤ Â· EMPIEZA YA

**QuÃ©.** Solicitar la afiliaciÃ³n a CardNET con el RNC 132-28618-9.

**Por quÃ© va primero y separado.** Es el Ãºnico punto del que depende cobrar, y no depende de escribir cÃ³digo: son semanas de trÃ¡mite. Todo lo demÃ¡s de esta fase se puede construir contra el entorno de pruebas mientras el papeleo avanza.

**Hecho cuando:** CardNET entrega `PublicAccountKey` y `PrivateAccountKey` de producciÃ³n.

### 9.1 Cerrar el modelo de cobro

Los precios ya estÃ¡n decididos y viven en la tabla `planes`: RD$999 Pro, RD$1,699 Equipo, RD$399 por integrante adicional. Lo que **falta decidir**, y no es cÃ³digo:

- **El comprobante fiscal.** El endpoint de compra de CardNET exige un campo `DataDo` con **nÃºmero de factura**. En RepÃºblica Dominicana vender a empresas obliga a emitir NCF. Hay que hablarlo con tu contador **antes** de escribir la integraciÃ³n, porque determina si SAVE tiene que generar y numerar comprobantes.
- **El ITBIS.** `/precios` dice hoy que los precios "incluyen los impuestos que apliquen". Hay que saber si el servicio lo lleva y si el precio anunciado es con impuesto incluido o sin Ã©l. Es una decisiÃ³n de tu contador, no mÃ­a ni tuya.
- **El prorrateo** al aÃ±adir un integrante a mitad de mes: se cobra completo, proporcional, o entra en el ciclo siguiente.

### 9.2 IntegraciÃ³n con CardNET

**TokenizaciÃ³n.** La tarjeta se captura en un **iframe de CardNET** mediante su librerÃ­a `PWCheckout.js`, cargada con la `PublicAccountKey`. **Los datos de la tarjeta no pasan nunca por nuestro servidor ni por nuestro HTML**, que es lo que mantiene a SAVE fuera del alcance mÃ¡s caro de PCI. Devuelve un token de un solo uso, vÃ¡lido diez minutos, en un campo oculto `PWToken`.

**Ficha permanente.** Ese token de un uso se convierte en un token de comercio (*Card on File*), que sÃ­ se guarda y permite cobrar en meses sucesivos sin que el titular estÃ© delante.

**El cobro.** `POST {URLBASE}/v1/api/purchase` con `TrxToken`, `Order`, `Amount`, `Currency: "DOP"` y `DataDo`.

**Entornos.** Pruebas en `labservicios.cardnet.com.do`, producciÃ³n en `servicios.cardnet.com.do`. Se construye entero contra pruebas mientras llega la afiliaciÃ³n.

**DÃ³nde va la clave privada.** `PrivateAccountKey` es de servidor y **solo** de servidor. En Railway como variable de entorno normal, **nunca** con prefijo `NEXT_PUBLIC_`: eso la incrustarÃ­a en el JavaScript que descarga cualquier visitante. La `PublicAccountKey` sÃ­ es pÃºblica y va al cliente.

**Lo que NO se guarda nunca en nuestra base:** nÃºmero de tarjeta, CVV, fecha de vencimiento. Solo el identificador del token y los cuatro Ãºltimos dÃ­gitos para que el usuario reconozca su tarjeta.

### 9.3 El proceso mensual de cobro

**QuÃ©.** Una tarea programada que recorre los despachos con suscripciÃ³n activa y vencida, cobra con el token guardado, y registra el resultado.

**Cuidado con esto:** tiene que ser **idempotente**. Si se ejecuta dos veces el mismo dÃ­a â€”porque fallÃ³ a medias, porque alguien lo relanzÃ³â€” no puede cobrar dos veces al mismo despacho. Se resuelve con un identificador de ciclo Ãºnico por despacho y mes, y una restricciÃ³n en la base que impida repetirlo.

**Los reintentos.** Una tarjeta puede fallar por saldo y funcionar tres dÃ­as despuÃ©s. Antes de mandar a nadie al periodo de gracia, reintentar; y avisar por correo al primer fallo, no al Ãºltimo.

### 9.4 Estados del ciclo Â· ya construido

**Esto ya estÃ¡ hecho desde la Fase 1** y no depende de quiÃ©n cobre: `plan_efectivo()`, `sub_status`, `impago_desde` y el periodo de gracia de siete dÃ­as. Pasada la gracia rige `CANCELLED`, con 0 documentos nuevos y 0 de bÃ³veda â€” y cero de bÃ³veda no impide leer ni descargar, solo subir.

**Nunca se borran documentos por falta de pago.** Se bloquea crear nuevos; lo que ya se pagÃ³ se sigue viendo y descargando. EstÃ¡ implementado asÃ­ a propÃ³sito.

Lo que falta es **la interfaz**: una pantalla de estado de la suscripciÃ³n, el aviso al entrar en gracia, y probar de verdad que un despacho vencido conserva el acceso a lo suyo.

### 9.5 Probarlo con dinero de mentira

Con el entorno de pruebas de CardNET: alta de tarjeta, primer cobro, cobro del mes siguiente con el token guardado, tarjeta rechazada, reintento, entrada en gracia, cancelaciÃ³n y reactivaciÃ³n.

**Hecho cuando:** un despacho recorre el ciclo entero sin que nadie toque la base a mano.

---

# FASE 10 Â· Entrar con Google y trato personal

**AÃ±adida el 8 de septiembre, fuera del plan original.**

El cÃ³digo estÃ¡ escrito y subido. Lo que queda aquÃ­ es casi todo tuyo.

## Lo que ya estÃ¡ hecho

- BotÃ³n de Google en acceso y registro. El identificador y el secreto los guarda Supabase; no aparecen en el repositorio.
- Pantalla de bienvenida para quien entra por Google, que pregunta **una sola vez** si es persona o empresa â€”y la fecha de nacimiento si es personaâ€”, con un "Ahora no" bien visible.
- Persona o empresa en el registro normal, con razÃ³n social y RNC validado.
- Saludo neutro. **El gÃ©nero no se pregunta**: Google no lo devuelve â€”exige un permiso sensibleâ€” asÃ­ que habrÃ­a que preguntÃ¡rselo a todo el mundo para conjugar un adjetivo.
- FelicitaciÃ³n de cumpleaÃ±os, por correo y dentro de la aplicaciÃ³n, con las fechas probadas (huso de RD y 29 de febrero).
- `/privacidad` declara los datos nuevos, como obliga la Ley 172-13.

### 10.1 Arreglar la pantalla de permisos de Google Â· P1 Â· ðŸ‘¤ Â· GRATIS

**QuÃ©.** Hoy Google enseÃ±a *"Accede a fzuojuoopngcqrdozvpw.supabase.co"*. Con el nombre de la aplicaciÃ³n, el logotipo y las URLs de privacidad y tÃ©rminos configurados â€”y la aplicaciÃ³n **publicada**, no en modo *Testing*â€” pasa a decir *"Acceder a SAVE Documentos"* con el logo.

**No requiere revisiÃ³n de Google.** Esa espera de semanas de la que habla todo el mundo aplica solo a permisos sensibles, y nosotros pedimos Ãºnicamente `email` y `profile`. El logotipo estÃ¡ generado y entregado.

**Esto es lo que quita el texto feo. Es gratis y es lo primero.**

### 10.2 QuiÃ©n llama a la tarea de cumpleaÃ±os Â· âœ… decidido: GitHub Actions

La ruta `/api/tareas/cumpleanos` existe y estÃ¡ protegida por clave, pero **nadie la llama todavÃ­a**. Sin esto, el correo no sale nunca; el mensaje dentro de la aplicaciÃ³n sÃ­ funciona ya.

**Decidido: GitHub Actions**, en `.github/workflows/cumpleanos.yml`. Se descartaron `pg_cron` â€”la clave acabarÃ­a guardada en la propia base y los errores solo se ven consultando una tabla interna de `pg_net`â€” y el cron de Railway, que obliga a un servicio aparte.

Lo que decidiÃ³: **quÃ© pasa el dÃ­a que falle**. AquÃ­ el horario estÃ¡ versionado, los registros estÃ¡n en la pestaÃ±a Actions, y hay un botÃ³n para dispararlo a mano. AdemÃ¡s el paso comprueba el cÃ³digo HTTP y **falla si no es 200**: sin eso, una clave mal puesta devolverÃ­a 401, el trabajo saldrÃ­a en verde, y estarÃ­amos meses sin enviar nada.

**Falta:** poner el secreto `TAREAS_CLAVE` en GitHub â†’ Settings â†’ Secrets and variables â†’ Actions, con el mismo valor que en Railway.

### 10.3 Variables de correo en Railway Â· ðŸ‘¤

`SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS` y `TAREAS_CLAVE`.

**`SMTP_PASS` no puede llevar el prefijo `NEXT_PUBLIC_`**: eso la meterÃ­a en el JavaScript que descarga cualquier visitante.

### 10.4 Lo que falta hacer a mano Â· ðŸ‘¤ Â· TODO ESTO ESTÃ PENDIENTE

Sin esto, el cÃ³digo estÃ¡ subido y no funciona nada de lo nuevo.

1. `npm install` â€” falta `nodemailer`. Hasta entonces el proyecto **no compila**.
2. Las tres migraciones en el SQL Editor, **en orden**: `20260909 persona_o_empresa`, `20260910 alta_con_google`, `20260911 revisor_marquez`.
3. En Railway: `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS` y `TAREAS_CLAVE`.
4. En GitHub â†’ Settings â†’ Secrets and variables â†’ Actions: el secreto `TAREAS_CLAVE`, **con el mismo valor** que en Railway. Si no coinciden, el trabajo diario devuelve 401.
5. `npm run build` y `git push origin main`.
6. La pantalla de consentimiento de Google (10.1).

### 10.5 Probarlo de punta a punta

Ponerse una fecha de nacimiento de hoy, llamar a la tarea a mano con la clave, y comprobar que llega **un solo** correo aunque se llame dos veces. Esa segunda llamada es la prueba que importa: es la que verifica que `cumple_felicitado_en` hace su trabajo.

---

# FASE 11 Â· CatÃ¡logo de cartas

**AÃ±adida el 9 de septiembre. 219 cartas, no 227.**

Cartas para trÃ¡mites: autorizaciones, constancias, solicitudes, reclamaciones. Es un producto distinto del catÃ¡logo actual â€”contratos y actos notarialesâ€” y probablemente el que mÃ¡s gente busca en Google.

### 11.0 Lo primero: NO son 227

Se contaron: **227 entradas, 219 tÃ­tulos Ãºnicos, 8 duplicados** entre categorÃ­as.

| Repetida | Aparece en |
|---|---|
| DeclaraciÃ³n de dependencia econÃ³mica | TrÃ¡mites personales, MigraciÃ³n, Familia |
| Solicitud de certificaciÃ³n | TrÃ¡mites personales, Instituciones pÃºblicas |
| Solicitud de correcciÃ³n de datos | TrÃ¡mites personales, Instituciones pÃºblicas |
| Carta de descargo | Laborales, Legales |
| AutorizaciÃ³n de representante | Empresas, Instituciones pÃºblicas |
| Referencia comercial | Empresas, Compras y ventas |
| Respuesta a requerimiento | Impuestos, Instituciones pÃºblicas |

**Resuelto el 10 de septiembre.** Cada carta se carga **una sola vez**, en la categorÃ­a donde el usuario la busca primero. Que aparezca en varias categorÃ­as es un problema de navegaciÃ³n, no de catÃ¡logo: se resuelve en la Fase 6 con etiquetas. Cargarla tres veces habrÃ­a hecho que los revisores aprobaran el mismo texto tres veces y que el usuario lo encontrara repetido.

### 11.1 El problema de secuencia, y es serio

Hoy hay **251 plantillas y 123 clÃ¡usulas esperando revisiÃ³n desde el 2 de septiembre, y cero aprobadas**. AÃ±adir 219 cartas mÃ¡s al montÃ³n antes de que se apruebe la primera es la forma mÃ¡s segura de que no se apruebe ninguna.

**Empezar por las 30 que la dueÃ±a marcÃ³ como mÃ¡s usadas.** Son el 14% del catÃ¡logo de cartas y probablemente el 80% de la demanda. Y son revisables en una sesiÃ³n.

### 11.2 La observaciÃ³n tÃ©cnica que cambia el esfuerzo

**Las cartas no son como los contratos.** Un contrato de alquiler y uno de compraventa no se parecen en nada. Pero *"Carta de autorizaciÃ³n para retirar documentos"* y *"Carta de autorizaciÃ³n para retirar paquetes"* son **la misma carta con una palabra distinta**.

Casi todas comparten el mismo esqueleto: lugar y fecha, destinatario, quien la firma con su cÃ©dula, el objeto, la fÃ³rmula de cierre, la firma.

Eso significa que **219 cartas salen probablemente de 12 a 15 moldes**, no de 219 redacciones. Antes de encargar nada, hay que agrupar por estructura. La diferencia es entre semanas de trabajo y meses.

### 11.3 Lo construido el 10 de septiembre

**32 cartas generadas y listas para revisar.** Con su propio generador, porque una carta no es un contrato: no tiene comparecientes, ni clÃ¡usulas numeradas, ni dos firmas. Tiene lugar y fecha, destinatario, asunto, cuerpo y **una** firma. Pasarlas por el generador de contratos las habrÃ­a encabezado a todas con un *"SE HA CONVENIDO Y PACTADO LO SIGUIENTE"* que no viene a cuento.

Lo que comparten con los contratos es el motor: son filas de `templates` con secciones y variables. El editor, la vista previa, el PDF y el paso DRAFT â†’ PUBLISHED son los mismos. **No hay un segundo motor.**

| Archivo | QuÃ© es |
|---|---|
| `scripts/catalog/cartas.ts` | Las 32 cartas y sus 160 variables. **AquÃ­ se corrige.** |
| `scripts/generate-cartas.ts` | `npm run cartas:build` |
| `docs/cartas-para-revision.md` | **Lo que leen Cifuentes y MÃ¡rquez.** Las 32 completas, con su base legal y las preguntas que se le hacen al usuario. |
| `supabase/migrations/20260912*_cartas_*.sql` | Tres archivos para el SQL Editor. El 00 primero. |

Reparto: 9 laborales, 6 de trÃ¡mites personales, 3 de instituciones pÃºblicas, 3 de migraciÃ³n, 3 de empresas, 2 de familia, 2 de compras y ventas, 2 legales, 2 de impuestos.

**Las advertencias son parte del producto.** Varias cartas llevan un aviso en mayÃºsculas al final: que la renuncia no genera cesantÃ­a y la dimisiÃ³n es otra cosa; que un poder simple no sirve para vender un inmueble; que la puesta en mora surte efecto pleno por acto de alguacil; que firmar un descargo cierra la reclamaciÃ³n; que la salida de un menor del paÃ­s exige la formalidad que exige. Una carta que no las lleve le puede costar un derecho a quien la firma.

**Una plantilla se moviÃ³ de sitio.** *IntimaciÃ³n de Pago* estaba en el catÃ¡logo de contratos, montada con comparecientes y dos firmas. Una intimaciÃ³n es una carta. Se pasÃ³ a `cartas.ts` y el SQL archiva la fila antigua, **solo si sigue en DRAFT**: si un revisor ya la aprobÃ³, no se toca.

**Lo que falta:** las 187 cartas restantes, cuando estas 32 estÃ©n aprobadas.

**NO VERIFICADO:** ninguna de las 32 ha sido revisada por un abogado dominicano. Las redactÃ© yo. Las bases legales citadas â€”Ley 16-92, Ley 358-05, Ley 172-13, Ley 136-03, artÃ­culo 1139 del CÃ³digo Civilâ€” hay que comprobarlas una por una.

### 11.4 QuiÃ©n las revisa

`legalcifuentes@gmail.com` y `jmarquez@saveconsult.net`, que ya tienen el permiso. Ambos pueden ver, corregir y aprobar el catÃ¡logo maestro; ninguno puede ver un documento de cliente.

Para revisar, leen `docs/cartas-para-revision.md`. Las correcciones vuelven a `cartas.ts`, se vuelve a ejecutar `npm run cartas:build` y se corre el SQL: reescribe el texto de la carta **sin tocar su estado**, asÃ­ que lo ya aprobado sigue aprobado.

**Hecho cuando:** las 32 estÃ¡n aprobadas y publicadas.

---

# FASE 12 Â· Animaciones y UX de la portada

**AÃ±adida el 9 de septiembre, a partir de un plan externo. Recogida con reservas, y las digo.**

El plan propone microinteracciones, scroll storytelling en los 4 pasos, bento grid, tabs por segmento, FAQ acordeÃ³n, CTA con gradiente animado y una **demo interactiva embebida**.

### 12.0 Lo que NO se va a construir

**Los trust signals inventados.** El plan pide logos de clientes, un contador de *"15,000+ documentos"* y testimonios con foto, nombre y cargo.

**SAVE no tiene clientes todavÃ­a, y hasta esta semana tenÃ­a cero documentos generados en producciÃ³n.** Poner eso serÃ­a fabricar prueba social: inventar cifras y personas que no existen para que alguien confÃ­e. En cualquier producto estÃ¡ mal; en uno legal, que vende confianza y cuyo argumento entero es *"nosotros no inventamos, lo revisa una abogada"*, es suicida.

**No lo voy a construir.** Cuando haya clientes reales con permiso para citarlos, y documentos de verdad que contar, esa secciÃ³n se hace en una tarde y valdrÃ¡ diez veces mÃ¡s.

Lo mismo con el *A/B testing* de la Fase 4 del plan externo: con el trÃ¡fico de hoy, comparar dos versiones no da un resultado, da ruido.

### 12.1 El conflicto con el rendimiento

El plan propone **GSAP + ScrollTrigger + Lenis + Lottie**, y fija un presupuesto de 50 kB de JavaScript. Solo GSAP con ScrollTrigger ya se acerca a ese tope, y Lenis y Lottie van encima.

Ayer la portada sacÃ³ **97 en mÃ³vil y 100 en escritorio**, con 193 kB en total y 12 peticiones. Ese nÃºmero se consiguiÃ³ quitando cosas: la hoja de Google Fonts que bloqueaba el renderizado y una llamada a Supabase en cada visita.

**No se meten cuatro librerÃ­as para volver a perderlo.** El orden correcto es: hacer con CSS todo lo que se pueda â€”que es casi todo lo de la listaâ€” y traer una librerÃ­a solo cuando haya algo que CSS no pueda, midiendo antes y despuÃ©s.

### 12.2 Lo que sÃ­ vale la pena, por orden

1. **Microinteracciones en CSS.** Hover, focus, el subrayado que se dibuja, el acordeÃ³n del FAQ con `grid-template-rows`. Cero JavaScript. Es el 70% de la sensaciÃ³n que busca el plan.
2. **`prefers-reduced-motion` desde la primera lÃ­nea**, no al final. El plan lo pone en la Fase 4; va en la primera.
3. **La secciÃ³n Antes / Con SAVE.** No necesita animaciÃ³n para funcionar y es el argumento mÃ¡s fuerte de la pÃ¡gina: 30-45 minutos contra 3-5.
4. **La demo interactiva.** Es lo mejor del plan externo: probar sin registrarse, con un contrato real y variables que se rellenan. Merece su propia semana.
5. **El scroll storytelling de los 4 pasos.** Lo Ãºltimo, y solo si mide bien. Es lo que mÃ¡s JavaScript pide y lo que peor se comporta en mÃ³vil.

### 12.3 Antes y despuÃ©s, medido

PageSpeed antes de tocar nada y despuÃ©s de cada entrega. **Si el mÃ³vil baja de 90, se revierte.** Los nÃºmeros de hoy â€”97 mÃ³vil, 100 escritorio, LCP 2,3 s, CLS 0â€” son la lÃ­nea que no se cruza.

---


---

# Resumen de esfuerzo

| Fase | QuÃ© | Estimado | Bloquea a |
|---|---|---|---|
| **F0** | Cerrar lo abierto | âœ… **Cerrada** | â€” |
| **F1** | Bloqueos de uso | âœ… **Cerrada** | â€” |
| **F2** | RevisiÃ³n legal | **3â€“6 semanas Â· abogada** | **F6** |
| **F3** | Importar y convertir | 2â€“3 semanas | â€” |
| **F4** | Visibilidad nueva | 3â€“4 dÃ­as | â€” |
| **F5** | Confianza y conversiÃ³n | 1â€“2 semanas | F6 |
| **F6** | Arquitectura SEO | 3â€“4 semanas | F7 |
| **F7** | AnalÃ­tica | 2 dÃ­as + manual | F9 |
| **F8** | Rendimiento y accesibilidad | 1 semana | F9 |
| **F9** | Cobros con CardNET | 1â€“2 semanas + afiliaciÃ³n | â€” |
| **F10** | Google y trato personal | âœ… **cÃ³digo hecho** Â· falta configuraciÃ³n | â€” |
| **F11** | CatÃ¡logo de cartas (219) | 30 primero Â· resto por moldes | â€” |
| **F12** | Animaciones y UX de la portada | 4â€“6 semanas | â€” |

**Camino crÃ­tico hasta poder hacer adquisiciÃ³n orgÃ¡nica en serio: F0 â†’ F2 â†’ F6 â†’ F7.** Entre siete y once semanas, y la mitad son de la abogada.

Si F3 y F5 se hacen **en paralelo** con la revisiÃ³n legal, para cuando el catÃ¡logo estÃ© aprobado el producto ya serÃ¡ Ãºtil por sÃ­ solo y las pÃ¡ginas de confianza ya estarÃ¡n publicadas. Esa es toda la diferencia entre un plan de tres meses y uno de seis.

---

# Las decisiones

| # | DecisiÃ³n | Estado |
|---|---|---|
| D1 | Cupos de cada plan | âœ… **Decidido el 5 de septiembre** â€” ver la tabla de planes |
| D2 | La bÃ³veda, Â¿por despacho o por persona? | âœ… **Por despacho**, y privada por defecto |
| D4 | Precios pÃºblicos | âœ… **RD$999 Pro Â· RD$1,699 Equipo Â· RD$399 por usuario** |
| D3 | Modo oscuro, Â¿terminarlo o retirarlo? | â¬œ Abierta Â· bloquea 8.4 Â· sin decidir, 47 archivos de cÃ³digo muerto siguen creciendo |
| D5 | Al cancelar, Â¿quÃ© pasa con lo guardado? | âœ… **Decidido y construido** â€” gracia de 7 dÃ­as, luego bloqueo de creaciÃ³n y bÃ³veda de solo lectura. Nunca se borra |
| D6 | Pasarela de pago | âœ… **Decidido el 8 de septiembre** â€” CardNET. PayPal descartado por el retiro de USD$10; Stripe no opera en RD |
| D7 | Comprobante fiscal (NCF) e ITBIS | â¬œ **Abierta Â· bloquea 9.2** Â· el endpoint de CardNET exige nÃºmero de factura. Es consulta para tu contador |
| D8 | Prorrateo al aÃ±adir integrante a mitad de mes | â¬œ Abierta Â· bloquea 9.1 |
| D9 | Saludo con gÃ©nero | âœ… **Descartado el 8 de septiembre** â€” Google no devuelve el gÃ©nero sin un permiso sensible. Saludo neutro |
| D12 | Las 8 cartas duplicadas, Â¿una en varias categorÃ­as o cartas distintas? | âœ… **Resuelta el 10 de septiembre** â€” una sola carta, una sola categorÃ­a. La navegaciÃ³n cruzada se resuelve con etiquetas en la Fase 6 |
| D13 | Prueba social inventada en la portada | ðŸš« **Descartado el 9 de septiembre** â€” no hay clientes ni documentos que contar. Se harÃ¡ cuando los haya y con permiso |
| D10 | QuiÃ©n programa la tarea de cumpleaÃ±os | âœ… **GitHub Actions**, decidido el 9 de septiembre. Se ve cuando falla, que es lo que decide estas cosas |

**Sobre D7**, que es la que ahora bloquea: el campo `DataDo` del endpoint de compra de
CardNET exige un nÃºmero de factura. En RepÃºblica Dominicana vender a empresas obliga
a emitir NCF. Antes de escribir la integraciÃ³n hay que saber si SAVE tiene que
generar y numerar comprobantes, y si el precio anunciado lleva el ITBIS incluido.
Eso lo contesta un contador, no el cÃ³digo.

# Lo que ya estÃ¡ hecho

No para lucirlo, sino para que no se vuelva a planificar.

| | |
|---|---|
| âœ… | SMTP funcionando y correo de confirmaciÃ³n llegando |
| âœ… | Invitar a un paralegal que todavÃ­a no tiene cuenta |
| âœ… | Perfiles Independiente y Paralegal, con lista blanca para liderar despacho |
| âœ… | Blindaje del plan: nadie se lo regala desde la aplicaciÃ³n |
| âœ… | Compartir documentos, con recursiÃ³n de polÃ­ticas resuelta |
| âœ… | Pantalla de revisiÃ³n del catÃ¡logo, con permiso propio y estrecho |
| âœ… | El bloqueo que impedÃ­a aprobar las 251 plantillas |
| âœ… | `robots.txt`, `sitemap.xml` y `noindex` en las pantallas de autenticaciÃ³n |
| âœ… | El `{"engine":"v2"}` que salÃ­a impreso 251 veces |
| âœ… | Contador de la portada que sube solo segÃºn se aprueba |
| âœ… | Prueba de dos cuentas del despacho, cerrada en producciÃ³n |
| âœ… | `robots.txt` y `sitemap.xml` **verificados en el dominio**, no solo escritos |
| âœ… | Credenciales expuestas rotadas: sin problemas crÃ­ticos abiertos |
| âœ… | Privacidad de documentos probada en producciÃ³n por los dos lados |
| âœ… | Los tres planes, aplicados de verdad: topes, gracia de 7 dÃ­as y catÃ¡logo por plan |
| âœ… | La app deja de ser inservible en un telÃ©fono |
| âœ… | La bÃ³veda deja de ser de todo el despacho |
| âœ… | Buscador y filtro entre las 251 plantillas |
| âœ… | AutorÃ­a de 40 commits devuelta, y fin del ruido de finales de lÃ­nea |

