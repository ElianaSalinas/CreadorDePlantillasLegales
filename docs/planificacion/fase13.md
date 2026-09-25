
> **Actualización del 15 de septiembre de 2026.** Las seis tareas de 10.4 se
> completaron: los tres commits subidos, `npm install` corrido, las tres
> migraciones aplicadas, las variables de Railway puestas, el secreto
> `TAREAS_CLAVE` en GitHub, y `.github/workflows/cumpleanos.yml` creado
> (nunca había existido, pese a que 10.2 lo daba por decidido) y probado con
> éxito (código 200).
>
> **Incidente encontrado y resuelto el mismo día, que merece quedar
> escrito:** Railway llevaba **4 días desplegando sin éxito** sin que nadie
> se diera cuenta, porque cada commit nuevo fallaba en el build y el
> deployment activo seguía siendo uno de 4 días atrás. La causa: `sharp` se
> actualizó (arreglando una vulnerabilidad) y trajo como dependencia
> opcional `@emnapi/core` y `@emnapi/runtime`, necesarios para el fallback
> WASM en Linux/Alpine (el `Dockerfile` usa `node:22-alpine`). El
> `package-lock.json` se había regenerado en Windows, que no necesita esas
> dependencias, así que Railway con `npm ci` fallaba con
> `Missing: @emnapi/runtime from lock file`. **Se resuelve borrando
> `node_modules` y `package-lock.json` y corriendo `npm install` de nuevo**,
> lo que recalcula el lock file para todas las plataformas, no solo la
> que lo generó. **Lección:** un `npm install`/`npm audit fix` corrido en
> Windows no garantiza que el lock file sirva para el contenedor Linux de
> producción. Conviene, tras tocar dependencias, confirmar el deploy en
> Railway explícitamente y no asumir que "compiló local" es lo mismo que
> "desplegó".

---

# FASE 13 · UI del área privada y del formulario de documentos

**Añadida el 15 de septiembre de 2026**, a partir de lo reportado directamente
por Eliana y por los abogados usando la aplicación real. A diferencia de la
Fase 12, que es sobre la portada pública, esta fase es sobre `/app/*`: la
interfaz que usan clientes, revisores y administradores todos los días.

> **Nota del 23 de septiembre de 2026.** 13.1, 13.3, 13.4, 13.5 y 13.6
> quedaron verificados como completos esta fecha — comprobando
> directamente en el código y en Supabase que cada pieza existe y
> funciona. La verificación de 13.2 ese mismo día resultó incompleta:
> confirmó que las seis variables existían en el catálogo, pero no
> comprobó que estuvieran conectadas de verdad al formulario ni al
> render — ver la nota del 24 de septiembre, en esa sección, con lo
> que en realidad estaba roto y cómo se corrigió.

### 13.1 Header fijo al hacer scroll · P1

**Qué.** El header de `/app/*` desaparecía al hacer scroll en vez de quedarse
visible arriba.

**Por qué.** El diseño anterior dependía de que `main` tuviera scroll interno
(`overflow-y-auto`) mientras el resto de la página se ajustaba exacto a
`min-h-screen`. En móvil, la barra de direcciones del navegador aparece y
desaparece y cambia la altura real disponible, lo que rompía ese cálculo y
hacía que la página entera scrolleara en vez de solo el contenido.

**Dónde.** `src/app/app/layout.tsx`

**Hecho cuando:** al hacer scroll en una página larga (`/app/clauses`), el
header se queda visible arriba siempre, sin importar el dispositivo.

**✅ Hecho el 15 de septiembre.** `header` con `sticky top-0 z-20`; el menú
lateral (`aside`) también pasó a `sticky`, con su propio límite de altura,
para que no quedara tapado detrás del header al hacer scroll en pantallas
donde el contenido es más largo que el menú.

### 13.2 Datos nuevos en el formulario de generación · P1

**Qué.** Agregar como variables reutilizables del motor:

- Tipo de identificación: cédula dominicana, pasaporte, licencia, otros
- Estado civil
- Tipo de moneda explícito: pesos, dólares, euros
- Nacionalidad, con una lista de opciones
- Género de las partes
- Cantidad de originales en que se firma el documento

**✅ Hecho** (corregido el 24 de septiembre de 2026 — el ✅ del 23 de
septiembre daba por buenas dos piezas que en la práctica no funcionaban;
ver la nota abajo). Las seis variables existen en el catálogo
(`scripts/catalog/variables.ts`) y están cargadas en Supabase, vinculadas a
las plantillas correspondientes. El género quedó resuelto de forma más
completa de lo planteado originalmente: una sola variable de género produce
**dos** pares de alias derivados a la vez (`portador`/`portadora` y
`domiciliado`/`domiciliada`) mediante el nuevo campo `DerivedConfig.extra`
en `src/lib/engine/types.ts` y `src/lib/engine/variables.ts` — antes el
motor solo permitía un alias derivado por variable. La cantidad de
ejemplares (`cantidad_ejemplares`) además alimenta dinámicamente la sección
de Firmas (ver 13.4).

> **Nota del 24 de septiembre de 2026 — lo que realmente estaba roto.**
> Una abogada reportó que el formulario no le mostraba la moneda del
> contrato. Al investigar aparecieron dos problemas reales, más un
> tercero que salió de paso al revisar el resto de 13.2:
>
> 1. **`moneda_contrato` casi nunca se vinculaba.** La variable existía,
>    pero `generate-catalog.ts` nunca la agregaba a ninguna plantilla de
>    forma automática — solo llegaba a una plantilla si alguna de sus
>    cláusulas la mencionaba por casualidad (3 de 249). Corregido: ahora
>    se vincula automáticamente a toda plantilla que ya tenga alguna
>    variable de tipo `currency` (158 de 249).
> 2. **Aunque apareciera, no hacía nada.** `currencyOf()`, en
>    `src/lib/engine/variables.ts`, leía un valor fijo grabado en el
>    catálogo (`derived_config.currency`, siempre `'DOP'`) en vez de la
>    respuesta real del usuario. Elegir Dólares no cambiaba ni el monto
>    en letras ni el formato del número — el selector, si aparecía, era
>    decorativo. Corregido de forma aditiva: `currencyOf()` ahora prioriza
>    la respuesta a `moneda_contrato` sobre el valor del catálogo, y solo
>    cae al valor fijo cuando la plantilla no tiene esa pregunta — ninguna
>    plantilla existente cambió de comportamiento por este cambio.
> 3. **`estado_civil` nunca se había insertado en Supabase, ni una
>    sola vez.** Las variables `parte_primera_estado_civil` y
>    `parte_segunda_estado_civil` estaban definidas en el catálogo desde
>    hace tiempo, pero el texto de la sección Comparecientes nunca las
>    mencionaba — y como `generate-catalog.ts` solo inserta en Supabase
>    las variables que de verdad aparecen escritas en algún texto, esas
>    dos nunca llegaron a existir en la base de datos. No es un caso de
>    poca cobertura: no estaba vinculada a ninguna plantilla. Corregido:
>    el texto de Comparecientes ahora menciona el estado civil de cada
>    parte, y las variables quedaron insertadas y vinculadas a las 249
>    plantillas.
>
> Los tres arreglos, con una migración nueva que no reescribe ninguna
> de las que ya corrieron en producción, están en el commit `aaa004e`.
> Verificado en Supabase después de correrla: 249/249 plantillas con
> estado civil en ambas partes, 158/249 con moneda.
>
> **Lección:** un ✅ en este documento debería significar que se probó
> de punta a punta, incluido si el dato cambia algo en el documento
> final — no solo que el código para eso existe. La verificación del
> día anterior confirmó que las variables estaban en el catálogo, pero
> no llegó a comprobar que un abogado pudiera usarlas de verdad ni que
> tuvieran efecto real en el texto generado.

### 13.3 Reglas de plantilla · P2

- La cláusula de mora o recargo debe poder marcarse **siempre opcional**.
- Una casilla para describir la propiedad, en los documentos donde aplique.

**✅ Hecho.** La cláusula de mora quedó marcada opcional en el catálogo; la
cláusula de descripción de propiedad se agregó y está vinculada a 21
plantillas inmobiliarias. Ambas verificadas en Supabase (conteos de
`template_clauses` y `rules` coinciden con lo esperado).

### 13.4 Presentación del documento generado · P2

- Botón de copiar el documento una vez generado.
- Los datos del formulario en **negrita** en el documento final.
- Fuente por defecto del documento: **Times New Roman**.

**✅ Hecho.**
- Botón de copiar: `src/app/app/documents/[id]/EditorClient.tsx`.
- Negrita: se calcula en el momento de exportar, no se guarda en la base de
  datos — `computeBoldRanges()` en
  `src/app/app/documents/[id]/export/route.ts` compara el texto final
  contra `data_payload` y el snapshot de la versión de plantilla, y
  `buildDocx()` (`src/lib/engine/export.ts`) recibe esos rangos y los
  renderiza en negrita dentro del `.docx`.
- Times New Roman: fuente por defecto del documento exportado.
- Además, la sección de Firmas ahora puede llevar una coletilla notarial
  personalizada por documento (ver 13.5), vía `firmasOverride` en
  `src/lib/engine/render.ts`.

### 13.5 Coletillas notariales guardables · P3 · esfuerzo mayor

**Qué.** Que un abogado pueda guardar una coletilla notarial como plantilla
reutilizable, y elegirla desde el formulario de generación.

**✅ Hecho.** CRUD completo:
- Tabla nueva `notary_snippets` (con RLS: cualquier miembro del despacho
  puede leer, solo el titular puede crear/editar/borrar).
- Gestión en "Mi Despacho" — `src/app/app/settings/SettingsClient.tsx`
  (`NotarySnippetsPanel`, `SnippetForm`) y `src/app/app/settings/actions.ts`.
- Selector en el formulario de generación —
  `src/app/app/documents/new/[templateId]/GeneratorClient.tsx` — que pasa
  la coletilla elegida hasta `renderDocument()` vía `firmasOverride`.

### 13.6 Varias personas en una misma parte · P1 · cambio estructural mayor

**Qué.** Que la primera o la segunda parte de un contrato puedan estar
compuestas por más de una persona, y que cada parte pueda ser una persona
física o una empresa (con representante).

**✅ Hecho**, en dos mitades:

**Mitad 1 — multi-persona (hasta 4 por parte, tope fijo por decisión de
alcance).** Se resolvió sin tocar el motor de render: cada plantilla tiene
ahora secciones condicionales de "miembro adicional" (`template_sections.condition`,
mecanismo ya existente, reutilizado) que aparecen o no según
`parte_X_cantidad`, más reglas `HIDE_VARIABLE` que ocultan los campos de
miembros que no aplican. 18 variables nuevas de miembro (nombre/cédula/domicilio
× miembro 2/3/4 × parte primera/segunda).

**Mitad 2 — persona o empresa por parte, con representante.** Los campos
"quién firma" se renombraron a lenguaje neutral; se agregaron 8 variables
nuevas (`razon_social`, `rnc`, `representante_cargo` × 2 partes) y 4
variantes condicionales de la sección Comparecientes (persona/empresa ×
primera/segunda parte), todo vía `template_sections.condition` y reglas de
tipo `HIDE_VARIABLE`/`SET_VALUE` — de nuevo, sin cambios en `render.ts`.

**Bug encontrado y corregido de paso:** `generate-catalog.ts` no borraba
`template_rules` antes de reinsertar (sí lo hacía para secciones y
cláusulas), así que correr `catalog:build` dos veces habría duplicado
reglas indefinidamente. Se agregó el `DELETE` que faltaba.

**Verificado en Supabase:** 249 plantillas reales × secciones/reglas/variables
en los conteos esperados, tras limpiar 2 filas de plantillas huérfanas
encontradas de paso ("Contrato de Alquiler de Vivienda" en su versión vieja,
y "Intimación de Pago" — movida a `cartas.ts` el 10 de septiembre pero nunca
archivada como debía) — ambas en estado DRAFT, invisibles para usuarios,
borradas con confirmación del conteo antes y después.

**UI del formulario:** además, el formulario de generación ahora separa
visualmente los campos en tres cuadros — "Primera parte", "Segunda parte" y
"Otros datos" — agrupando por prefijo de tag de variable en vez de por
`section_id` de la base de datos (`groupVariablesBySection()` en
`src/lib/engine/repository.ts`). Cambio puramente de presentación, no toca
la base de datos ni el contenido generado.

---

## Trabajo relacionado, completado el 23 de septiembre de 2026

No es parte de esta fase (pertenece a la Decisión D3 de `12-PLAN-FINAL.md`),
pero se hizo en la misma sesión que terminó de verificar 13.1–13.6, así que
queda anotado aquí también:

**Modo oscuro — terminado, no retirado.** El mecanismo ya funcionaba
correctamente desde antes: script inline en `src/app/layout.tsx` que decide
`.dark`/`.light` antes del primer pixel, `SelectorDeTema.tsx` con las tres
opciones (claro/oscuro/sistema), y tokens de color en `src/index.css`
calibrados con contraste WCAG verificado. Por decisión explícita, el
selector queda **solo dentro de `/app`** (no en las páginas públicas, que
igual reaccionan al tema del sistema operativo del visitante, solo que sin
control manual ahí).

Se auditaron las 57 archivos con clases `dark:` mediante un script propio
(`scripts/audit-dark-mode.mjs`, que se conserva en el repo para futuras
auditorías). De ~340 supuestos huecos que arrojó un primer intento, casi
todos resultaron ser un patrón intencional ya establecido en el código
(botones de acción y acentos de color que funcionan igual en los dos temas)
o errores del propio script de auditoría, corregidos en el camino. El único
hueco real de contraste era la insignia "Super Admin"
(`src/app/app/layout.tsx`), sin variante oscura — corregido en el commit
`a941aa9`.

**Nota de proceso:** en el camino se escribió un segundo script
(`fix-dark-mode.mjs`) para aplicar arreglos automáticos, pero tenía un bug
que apilaba clases `dark:` contradictorias sobre elementos que ya tenían una
variante oscura elegida a propósito (ej. `dark:border-slate-700` +
`dark:border-slate-800` a la vez). Se detectó antes de subir nada — el
`git diff` completo (no solo `--stat`) lo dejó claro — y se revirtió por
completo, reaplicando a mano solo el arreglo real de la insignia. El script
se borró del repo; no se debe reusar sin corregir antes ese bug.