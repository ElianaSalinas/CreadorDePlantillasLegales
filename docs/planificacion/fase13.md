
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
- Tipo de moneda explícito: pesos, dólares, euros — hoy el motor asume DOP
  salvo que la plantilla lo fije de otra forma
- Nacionalidad, con una lista de opciones
- Género de las partes
- Cantidad de originales en que se firma el documento — hoy asumido en 2 en
  algún punto del motor; hay que localizar exactamente dónde antes de
  cambiarlo

**Por qué.** Las 251 plantillas y las 32 cartas asumen implícitamente varios
de estos datos, o directamente no los piden nunca, y son datos que cambian
el contenido legal real del documento.

**Dónde.** Tabla `variables`, `src/lib/engine/variables.ts`,
`src/lib/engine/dominican.ts` (si alguna necesita validación propia, como ya
existe para cédula y RNC).

**Estado:** ⬜ Sin empezar.

### 13.3 Reglas de plantilla · P2

- La cláusula de mora o recargo debe poder marcarse **siempre opcional**, sin
  excepción, en cualquier plantilla que la use.
- Una casilla para describir la propiedad, en los documentos donde aplique
  (principalmente inmobiliarias).

**Dónde.** `src/lib/engine/quality.ts` y las plantillas que usan esa cláusula.

**Estado:** ⬜ Sin empezar.

### 13.4 Presentación del documento generado · P2

- Botón de copiar el documento una vez generado.
- Los datos que vinieron del formulario (no el texto fijo de la plantilla)
  deben verse en **negrita** en el documento final, para distinguirlos del
  texto estándar a simple vista.
- Fuente por defecto del documento: **Times New Roman**.

**Dónde.** El motor de render y el export a PDF.

**Estado:** ⬜ Sin empezar.

### 13.5 Coletillas notariales guardables · P3 · esfuerzo mayor

**Qué.** Que un abogado pueda guardar una coletilla notarial (o los datos de
un notario) como plantilla reutilizable, y que el formulario de generación
ofrezca elegir una ya guardada en vez de escribirla cada vez.

**Por qué es distinta de las demás de esta fase.** No es un campo nuevo: es
una funcionalidad completa (su propio CRUD, más un selector nuevo en el
formulario).

**Estado:** ⬜ Sin empezar. Falta diseñar cómo se guarda y se selecciona
antes de escribir nada.

### 13.6 Varias personas en una misma parte · P1 · cambio estructural mayor

**Qué.** Que la primera o la segunda parte de un contrato puedan estar
compuestas por más de una persona (varios vendedores, varios herederos,
etc.).

**Por qué.** Hoy el motor asume una persona por parte. Este cambio toca cómo
se arman los comparecientes, cómo el texto de las cláusulas los menciona, y
probablemente el PDF final.

**Riesgo.** Es el cambio más grande de todos los de esta fase. Antes de
tocar código hace falta mapear qué archivos asumen "una persona = una
parte" (candidatos a revisar: el motor de variables, `generate-catalog.ts`,
`quality.ts`, y el render de comparecientes).

**Estado:** ⬜ Sin empezar. Se aborda por separado, no junto con 13.2–13.5.

