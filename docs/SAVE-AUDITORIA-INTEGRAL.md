# SAVE Documentos — Auditoría integral

**SA&VE Comercial, S.R.L. · Punta Cana, República Dominicana**
Dominio auditado: `https://savedocumentos.com` · Fecha: 4 de septiembre de 2026

---

## Cómo leer este informe

Cada hallazgo lleva un estado y una prioridad. El estado dice **cómo se comprobó**, no cómo de bien suena en la documentación:

| Código | Significa |
|---|---|
| ✅ **VERIFICADO** | Comprobado contra producción o ejecutando el código. No deducido |
| 🟡 **INCOMPLETO** | Existe y funciona a medias |
| ⚠️ **INCORRECTO** | Existe pero hace algo distinto de lo que debería |
| 🔴 **NO IMPLEMENTADO** | No existe. Comprobado, no supuesto |
| 🔍 **NO VERIFICADO** | No se pudo comprobar desde aquí |
| 🌐 **REQUIERE ACCESO EXTERNO** | Necesita una cuenta o herramienta de terceros |
| 👤 **REQUIERE ACCIÓN MANUAL** | Solo lo puede hacer una persona |

Prioridades: **P0** seguridad, datos o funcionalidad principal · **P1** conversión, indexación o negocio · **P2** UX, accesibilidad, arquitectura · **P3** optimización futura.

Buena parte de esta auditoría se hizo **con sesión iniciada en producción**, recorriendo la aplicación con dos cuentas distintas —la titular y una paralegal— y generando un documento real de principio a fin. Lo que no se pudo comprobar así está marcado, y no se ha rellenado con suposiciones.

---

# 1. Resumen ejecutivo

**¿Está SAVE preparado para empezar una etapa seria de adquisición orgánica y comercial?**

El producto sí. El canal, no todavía.

El motor documental **funciona de verdad**: se generó un contrato completo en producción, con las cláusulas condicionales resueltas, los montos en letras, la cédula validada con su dígito verificador y la fecha redactada en forma notarial. Se descargó en Word y en texto plano, los dos correctos. El modelo de despacho, los permisos del paralegal y el compartir documentos también funcionan y se probaron con dos cuentas reales. La seguridad no presenta ningún hallazgo P0: el bucket es privado, las rutas privadas redirigen al login y el aislamiento por despacho se sostiene.

Lo que no está listo es todo lo que hay **alrededor** del producto:

1. **El catálogo está al 0 %.** 251 plantillas y 123 cláusulas, ninguna aprobada. Ningún usuario ve ni una. Hasta esta auditoría, además, **era imposible aprobarlas**: un fallo en el enganche de una variable bloqueaba las 250 del catálogo general. Ya está corregido y verificado, pero la revisión legal no ha empezado.
2. **El sitio público es una sola página.** No hay páginas de categoría, ni de plantilla, ni contenido informativo. La arquitectura de clusters que pide el encargo no está incompleta: no existe, porque no hay sobre qué construirla. Ese es el trabajo grande.
3. **No hay analítica.** `gtag` es `undefined` en producción. Arrancar adquisición sin medirla es gastar sin saber en qué.
4. **No hay páginas de confianza.** Ni términos, ni privacidad, ni contacto, ni precios. Para un producto legal que guarda documentos ajenos, eso es un problema de credibilidad antes que de SEO.
5. **El plan de pago no da capacidad.** Un despacho en BUSINESS a RD$999/mes tiene los mismos límites que uno gratuito.

**Recomendación:** no lanzar adquisición hasta cerrar los bloques 1 a 3 del roadmap. El bloque 2 —aprobar el catálogo— es el que más tiempo de persona consume y el que no se puede acelerar con código.

---

# 2. Arquitectura actual

```
Navegador
   │
   ▼
Railway ── Next.js 16.3.1 (App Router, Turbopack)
   │          ├── Componentes de servidor + Server Actions
   │          ├── middleware.ts  → refresca la sesión en CADA petición
   │          └── Route Handlers → /auth/confirm, /app/documents/[id]/export
   │
   ▼
Supabase (proyecto fzuojuoopngcqrdozvpw)
   ├── PostgreSQL 16 + Row Level Security en todas las tablas
   ├── Auth (PKCE + OTP), SMTP propio vía Hostinger
   └── Storage · bucket privado `vault`
```

**Separación de responsabilidades**, verificada leyendo el código:

- La autorización vive en **dos capas**: las Server Actions comprueban permisos y, por debajo, las políticas RLS vuelven a comprobarlos. Saltarse la aplicación no basta.
- La llave `SUPABASE_SERVICE_ROLE_KEY` solo se usa en tres archivos de servidor y nunca se importa desde un componente `'use client'`. ✅ VERIFICADO
- El motor documental está aislado en `src/lib/engine/` y es independiente de la interfaz.

**Deuda arquitectónica conocida:** `src/middleware.ts` sigue con el nombre que Next 16 deprecó (`proxy.ts`). Aplazado a propósito por decisión tuya.

---

# 3. Stack detectado

| Capa | Tecnología | Nota |
|---|---|---|
| Framework | Next.js 16.3.1, React 19 | App Router, Turbopack |
| Lenguaje | TypeScript | `tsc --noEmit` limpio |
| Estilos | Tailwind v4 (`@import "tailwindcss"`) | Variante `dark` personalizada, ver §23 |
| Base de datos | PostgreSQL 16 (Supabase) | RLS en todas las tablas |
| Auth | Supabase Auth | PKCE + OTP |
| Almacenamiento | Supabase Storage | Bucket `vault`, privado |
| Exportación | `jszip` (Word), `jspdf` (PDF en navegador) | Sin dependencias pesadas de servidor |
| Iconos | `lucide-react` | |
| Animación | `motion` | |
| Hosting | Railway | `NEXT_PUBLIC_*` se congelan en el build |
| Correo | Hostinger SMTP vía Supabase | Funcionando |

**No hay** framework de tests, ni linter en CI, ni analítica, ni gestor de errores. `npm run lint` existe pero nada lo ejecuta automáticamente.

---

# 4. Diferencias entre la documentación y la realidad

Hay once documentos de planificación en `docs/planificacion/`. La regla del encargo —no dar por implementado lo que aparece escrito— resultó estar bien puesta.

| Lo que dice la documentación o la interfaz | La realidad | Estado |
|---|---|---|
| El catálogo se describe como listo para usar | 0 de 251 plantillas aprobadas; ningún usuario ve ninguna | ⚠️ |
| Mi Despacho: *"Debe tener ya una cuenta en Save Documentos"* | Desde la Fase 1 se invita a quien no tiene cuenta y la crea él | ⚠️ El texto contradice al producto |
| La portada anuncia **"Diez categorías"** | La base tiene **once**, y con nombres distintos | ⚠️ |
| 47 archivos usan clases `dark:` | El modo oscuro no se puede activar. Código muerto | ⚠️ |
| `VARS_EXISTENTES` da por hecho que 30 variables ya existen | Suposición heredada; provocó el bloqueo del catálogo entero | ⚠️ Corregido |

**Una corrección que me corresponde a mí.** Durante el proyecto informé en varias ocasiones de "123 cláusulas, 100 variables y 251 plantillas"; después me desdije y dije "101, 70 y 250". Los buenos son **los primeros**: la pantalla de Revisión en producción muestra literalmente *"0 de 251 plantillas y 0 de 123 cláusulas"*. La diferencia son el seed del contrato de arrendamiento (1 plantilla, 22 cláusulas, 30 variables) más el catálogo generado (250, 101, 70). Conté sobre los archivos en vez de sobre la base y di un dato peor del que ya había.

---

# 5. Auditoría funcional

Recorrido real en producción, con sesión iniciada.

| Función | Estado | Evidencia |
|---|---|---|
| Portada | ✅ | 200, un solo H1, canonical correcto |
| Registro | ✅ | Formulario con los cinco perfiles profesionales |
| Login | ✅ | Entra y crea sesión |
| Recuperar contraseña | 🔍 | Existe; el envío no se probó en esta sesión |
| Confirmación por correo | ✅ | Resuelto en fases anteriores; llega y el enlace funciona |
| Rutas privadas sin sesión | ✅ | `/app/dashboard` redirige a `/login` |
| Dashboard | ✅ | Carga con contadores |
| Selección de plantilla | ✅ | 251 en la biblioteca |
| Formulario de variables | ✅ | 18 campos, valores por defecto correctos |
| Validación de cédula | ✅ | Dígito verificador comprobado y formato aplicado |
| Generación del documento | ✅ | Sin un solo hueco `{{...}}` sin resolver |
| Fecha notarial | ✅ | *"a los cuatro (4) días del mes de septiembre del año dos mil veintiséis (2026)"* |
| Guardado | ✅ | Documento persistido con su UUID |
| Descarga Word | ✅ | 200, MIME correcto, firma `PK`, 4.121 bytes |
| Descarga texto | ✅ | 200, contenido íntegro |
| Descarga PDF | 🔍 | Botón presente; se genera en el navegador, no se probó |
| Compartir | ✅ | Lista al compañero, comparte, y el receptor lo ve |
| Despacho con dos cuentas | ✅ | Cerrada la prueba pendiente de la Fase 0 |
| Estado vacío de Documentos | ✅ | Mensaje claro y CTA a plantillas |
| 404 | ✅ | Devuelve **404 real**, no un 200 disfrazado |
| Versiones | 🔍 | `template_versions` existe; sin interfaz visible |
| Enviar a revisión | 🔍 | Botón presente, flujo no recorrido |

**Permisos del paralegal**, probados con la segunda cuenta:

| Comprobación | Resultado |
|---|---|
| Ve el despacho del titular, no su espacio vacío | ✅ |
| Sin insignia de administrador ni enlaces a Revisión/Administración | ✅ |
| **Cero referencias a cobros, facturación o planes** | ✅ Tal como se pidió |
| Nombre del despacho y ajustes del equipo: deshabilitados | ✅ |
| Edita sus propios datos | ✅ |
| Abre y trabaja el documento compartido | ✅ |
| **No puede volver a compartirlo** | ✅ Sin botón |
| **No puede borrarlo** | ✅ Sin botón |

---

# 6. Auditoría de plantillas

Es la sección de máxima prioridad según el encargo, y donde apareció el hallazgo más grave.

## 6.1 El estado real del catálogo

| | Total | Aprobadas | Pendientes |
|---|---|---|---|
| Plantillas maestras | 251 | **0** | 251 |
| Cláusulas globales | 123 | **0** | 123 |
| Variables | 100 | — | — |

**Ningún usuario ve ni una sola plantilla.** Es el comportamiento correcto —nada se publica sin revisión legal— pero significa que el producto que ve un cliente nuevo hoy está vacío.

## 6.2 El bloqueo que impedía aprobar nada · P0 · ✅ CORREGIDO

**Síntoma:** las 250 plantillas del catálogo general daban el bloqueante *"La variable `{{fecha_firma_notarial}}` no existe"*. La abogada se habría sentado a revisar y le habrían rebotado las 250, una por una.

**Causa, en tres capas:**

1. `{{fecha_firma_notarial}}` **no es una variable**: es el alias derivado de `fecha_firma`, que lleva `{"transform":"fecha_notarial","as":"fecha_firma_notarial"}`. El diseño es correcto y produce la redacción notarial dominicana.
2. El generador (`scripts/generate-catalog.ts`, `TAGS_SECCIONES`) enganchaba a cada plantilla **el alias en vez de la variable**. El filtro de `DERIVADAS`, tres líneas más abajo, eliminaba el alias de la lista. Resultado: no se enganchaba nada, sin error y sin fila.
3. `quality.ts` solo reconoce los alias de las variables **que esa plantilla tiene enganchadas**. Sin `fecha_firma`, el alias no existía para ella.

**Debajo había una segunda causa:** `VARS_EXISTENTES` daba por hecho que `ciudad_firma`, `fecha_firma`, `dia_pago` y `direccion_inmueble` "ya existen por la migración del arrendamiento". Si ese seed no se hubiera ejecutado, no existirían en ninguna parte.

**Solución aplicada:** `supabase/migrations/20260903000000_variables_de_firma.sql` asegura las cuatro variables y **engancha a cada plantilla maestra todas las que su texto usa de verdad**, resolviendo los alias hasta la variable que los produce. Cierra la clase de fallo, no el caso concreto. El generador quedó corregido para que no reaparezca.

**Verificación:** en producción, el formulario ya pregunta *"¿Cuándo se firma?"*, el control de calidad no reporta ninguna variable inexistente, y el documento generado sale con la fecha en forma notarial.

## 6.3 El orden de la revisión importa

`quality.ts` impide publicar una plantilla maestra si **alguna de sus cláusulas sigue en borrador**. Esa regla es correcta y se conserva. La consecuencia práctica:

> **Primero las 123 cláusulas. Después las 251 plantillas.** Al revés, las plantillas rebotan.

La pantalla de Revisión abre por cláusulas y avisa de cuántas faltan, precisamente por esto.

Quedan dos bloqueantes por plantilla, y los dos se resuelven solos: las cláusulas en borrador (al aprobarlas) y la firma de revisión (en el momento de publicar, por el arreglo en `publishTemplate`).

## 6.4 Sistema de estados

🟡 **INCOMPLETO.** El enum `content_status` tiene `DRAFT · REVIEW · APPROVED · PUBLISHED · ARCHIVED`. En la práctica solo se usan **DRAFT** y **PUBLISHED**. No hay estado RECHAZADA: si la abogada encuentra una plantilla mala, no tiene dónde decir que la rechazó ni por qué. Hoy la deja en borrador, indistinguible de una que nadie ha mirado todavía.

**P2 · Recomendación:** usar `ARCHIVED` para lo rechazado y añadir un campo de motivo, o aceptar explícitamente que la revisión es binaria.

## 6.5 Diccionario de variables

✅ Existe y es consistente. 100 variables globales, con etiqueta legible, pregunta, tipo de dato y transformaciones derivadas. **Cero variables declaradas sin usar** y —tras el arreglo— cero usadas sin declarar.

🟡 **Nombres que invitan al error:** existen `dias_pago` ("Días para pagar", un número de días) y `dia_pago` ("Día de pago", día del mes). Son conceptos distintos y ambos legítimos, pero a un nombre de distancia. Conviene renombrar uno.

🟡 **Cláusulas casi gemelas:** *"Depósito de garantía"* y *"Depósito en garantía"*. Revisar si son de verdad dos o una duplicada.

## 6.6 Saltos de línea mezclados · P3

El texto guardado mezcla `\n` y `\r\n`: 8 retornos de carro en un documento de 38 líneas. Se coló el CRLF de Windows al generar el catálogo. En Word puede producir algún salto de más.

---

# 7. Auditoría SMTP

✅ **FUNCIONANDO.** Resuelto en fases anteriores de este proyecto. La causa raíz era una credencial obsoleta guardada en Supabase, agravada por un comportamiento del propio Supabase: **un PATCH parcial a `/config/auth` borra el campo en vez de actualizarlo**, que es por lo que el formulario del panel nunca guardaba.

| Elemento | Estado |
|---|---|
| Host, puerto, cifrado | ✅ Hostinger, verificado con las cuatro combinaciones de autenticación |
| Remitente y nombre visible | ✅ Dominio propio |
| Llegada del correo | ✅ Llega |
| Enlace de confirmación | ✅ Funciona, apunta al dominio propio |
| ¿Llega a spam? | 🔍 NO VERIFICADO — depende de SPF/DKIM/DMARC |
| SPF, DKIM, DMARC | 🌐 **REQUIERE ACCESO EXTERNO** — hay que consultar el DNS del dominio |
| Reply-To | 🔍 No configurado explícitamente |

**👤 ACCIÓN MANUAL PENDIENTE, y es la más urgente de todo el informe:** dos credenciales quedaron expuestas en texto plano durante el proyecto —la contraseña del buzón y la contraseña de aplicación de Hostinger—. **Siguen sin rotar.**

**Comprobar SPF/DKIM/DMARC:** en [mxtoolbox.com](https://mxtoolbox.com) consultar `savedocumentos.com` para los tres registros. Sin DKIM y DMARC, Gmail marcará los correos como sospechosos en cuanto el volumen suba.

---

# 8. Auditoría SEO

## 8.1 El hallazgo estructural

⚠️ **El sitio público de SAVE es UNA página.**

No es que el SEO esté mal hecho: es que no hay superficie sobre la que hacerlo. Un inventario completo de URLs indexables cabe en una línea:

| URL | Estado | Indexable | Title único | H1 |
|---|---|---|---|---|
| `/` | 200 | Sí | ✅ | ✅ uno |

Todo lo demás es `/login`, `/register`, `/forgot-password`, `/reset-password`, `/definir-password` —que **no deben** indexarse y ahora llevan `noindex`— y `/app/*`, que es privado.

**Las diez categorías de la portada son `<span>`, no enlaces.** Son diez páginas potenciales convertidas en texto inerte. Y ni siquiera coinciden con las once categorías reales de la base de datos (§13).

## 8.2 Lo que sí está bien en la portada

| Elemento | Estado |
|---|---|
| Un solo H1 | ✅ |
| Title propio, distinto del H1 | ✅ |
| Meta description propia | ✅ |
| Canonical | ✅ `https://savedocumentos.com` |
| `metadataBase` | ✅ |
| `lang="es-DO"` | ✅ |
| Open Graph (título, descripción, locale) | ✅ |
| Jerarquía H1 → H2 sin saltos | ✅ Siete H2, ningún H4 huérfano |
| FAQ visible con cinco preguntas reales | ✅ |
| Intención de búsqueda | 🟡 Comercial/transaccional, pero sin keyword trabajada |

## 8.3 Lo que falta

| Hallazgo | Prioridad |
|---|---|
| Sin imagen Open Graph → al compartir el enlace por WhatsApp sale en blanco. `public/` está **vacía** | P1 |
| Sin Twitter Card | P3 |
| Schema solo `WebSite`; falta `Organization` y `FAQPage` | P2 |
| Sin breadcrumbs (no hay jerarquía que migar todavía) | P2 |
| `www.savedocumentos.com` **no resuelve en DNS** | P2 |

---

# 9. Auditoría de URLs

✅ Las URLs existentes son cortas, legibles y en español: `/login`, `/register`, `/definir-password`, `/app/documents/[id]`.

🚫 **NO DEBE IMPLEMENTARSE: la desindexación de `/page/`.** El encargo pide sacar `/page/` del índice. **En este proyecto no existe ninguna ruta bajo `/page/`** — se comprobó el árbol completo de `src/app`. Es un requisito heredado de otra plantilla de auditoría. Aplicar un `noindex` a un patrón inexistente no haría nada, y aplicarlo por si acaso es exactamente el riesgo que el propio encargo advierte.

**Nomenclatura recomendada para lo que hay que crear** (§13):

```
/plantillas                              ← pilar
/plantillas/inmobiliario                 ← cluster
/plantillas/contrato-alquiler-vivienda   ← hoja
```

Sin `/page/`, sin identificadores numéricos y sin conectores innecesarios.

---

# 10. Auditoría de indexación

| Mecanismo | Antes | Ahora |
|---|---|---|
| `robots.txt` | 🔴 **404** | ✅ Creado |
| `sitemap.xml` | 🔴 **404** | ✅ Creado |
| `noindex` en pantallas de autenticación | 🔴 Indexables | ✅ Con `noindex` |
| Canonical en la portada | ✅ | ✅ |
| `X-Robots-Tag` | 🔴 No se usa | No hace falta |

**Una decisión que conviene entender**, porque es el error clásico: las pantallas de login y registro **no** se bloquean en `robots.txt`, aunque no queramos que se indexen. Llevan `noindex` propio, y para que Google obedezca un `noindex` tiene que poder **entrar a leerlo**. Bloquearlas en `robots.txt` conseguiría lo contrario: no las rastrea, no ve el `noindex`, y podrían quedarse indexadas con el resultado feo de *"no hay información disponible para esta página"*.

> `robots.txt` controla el **rastreo**. `noindex` controla la **indexación**. No son intercambiables.

En `robots.txt` solo se bloquea `/app/` y `/auth/`, que son área privada y no tienen nada que un buscador deba ver.

🔍 **Pendiente de verificar tras el despliegue:** los dos archivos se generan en el build, así que no se dan por buenos hasta comprobar que `savedocumentos.com/robots.txt` y `/sitemap.xml` responden 200.

---

# 11. Auditoría de metadata

| Página | Title | Description | Robots |
|---|---|---|---|
| `/` | ✅ Propio | ✅ Propia | index |
| `/login` | ✅ | ⚠️→✅ Heredaba la del layout raíz | ✅ noindex |
| `/register` | ✅ | ⚠️→✅ Idem | ✅ noindex |
| `/forgot-password` | ✅ | ⚠️→✅ Idem | ✅ noindex |
| `/reset-password` | ✅ | ⚠️→✅ Idem | ✅ noindex |
| `/definir-password` | ✅ | ⚠️→✅ Idem | ✅ noindex |

Las cinco pantallas de autenticación repetían **idéntica** la meta description del layout raíz. Corregido junto con el `noindex`.

---

# 12. Auditoría de headings

✅ La portada tiene **un solo H1** y siete H2 en jerarquía correcta. No hay saltos del tipo H1 → H4.

En la aplicación, cada pantalla tiene su H1 (`Plantillas`, `Documentos`, `Revisión del catálogo`, `Mi Despacho`). Correcto, aunque no importa para SEO: `/app/*` no se indexa.

🟡 El H1 de la portada (*"Crea documentos. Automatiza tu trabajo."*) es una promesa de marca, no una respuesta a una intención de búsqueda. Funciona como cabecera comercial; no captará tráfico. Eso lo tendrán que hacer las páginas de §13.

---

# 13. Arquitectura de clusters

🔴 **NO IMPLEMENTADA.** No hay ninguna página de categoría ni de plantilla. Esta sección es diseño, no auditoría.

## 13.1 El problema de partida

La portada anuncia **diez categorías**; la base de datos tiene **once**, con nombres distintos:

| Portada (texto fijo) | Base de datos (`template_categories`) |
|---|---|
| Legal | `legal-general` — Legal / General |
| Inmobiliario | `inmobiliario` — Inmobiliario |
| Empresarial | `empresarial` — Empresarial / Corporativo |
| Laboral | `laboral` — Laboral / RR. HH. |
| Financiero | `financiamiento` — Préstamos / Financiamiento |
| Comercial | `comercio` — Compraventa / Comercio |
| Vehículos | `vehiculos` — Vehículos |
| Construcción | `construccion` — Construcción |
| **Administrativo** | *no existe* |
| **Personal** | *no existe* |
| *no aparece* | `servicios` — Servicios Profesionales |
| *no aparece* | `tecnologia` — Tecnología / Software |
| *no aparece* | `marketing` — Marketing / Creativo |

Dos categorías anunciadas no existen en el producto, y tres que sí existen no se anuncian. **La taxonomía real es la de la base de datos** —tiene slugs y 251 plantillas colgando— y es sobre ella sobre la que hay que construir.

## 13.2 Estructura propuesta

```
/plantillas                                    PILAR
│
├── /plantillas/inmobiliario                   CLUSTER
│   ├── /plantillas/contrato-alquiler-vivienda        HOJA
│   ├── /plantillas/contrato-alquiler-local-comercial
│   └── …
│
├── /plantillas/vehiculos                      CLUSTER
│   ├── /plantillas/contrato-compraventa-vehiculo
│   └── …
│
└── … nueve clusters más
```

**Once páginas de cluster** (una por categoría real) y **una hoja por plantilla publicada**. Las hojas se generan solas desde la base: `title`, `description`, categoría y lista de variables ya existen. **No hay que escribir 251 páginas a mano.**

**Regla dura, y es la que protege el proyecto:** una hoja solo se publica cuando su plantilla está `PUBLISHED`. Publicar 251 páginas de borradores sin revisión legal sería exponer texto jurídico sin revisar y, además, tenderle a Google 251 páginas casi vacías.

## 13.3 Qué lleva cada tipo de página

**Cluster** (`/plantillas/inmobiliario`) — intención comercial:
1. H1 con el nombre de la categoría
2. Un párrafo de qué cubre y para quién
3. **CTA contextual** justo después
4. Rejilla de plantillas publicadas de esa categoría
5. "Lo más importante": cinco puntos clave
6. FAQ de tres a cinco preguntas reales
7. Enlaces al pilar y a dos o tres clusters hermanos

**Hoja** (`/plantillas/contrato-alquiler-vivienda`) — intención transaccional:
1. H1 con el nombre del documento
2. Qué es y cuándo se usa, en dos frases
3. **CTA: "Crear este documento"**
4. Qué datos te va a pedir (las variables reales, en lenguaje llano)
5. Qué cláusulas incluye
6. Base legal dominicana, si la cláusula la declara
7. Migas: Inicio → Plantillas → Categoría → Documento
8. Tres plantillas relacionadas de la misma categoría

---

# 14. Arquitectura de interlinking

🔴 **NO IMPLEMENTADA.** Hoy la portada enlaza a `/register` (tres veces), `/login` y un ancla interno. Eso es todo.

## 14.1 Mapa propuesto

| Origen | Destino | Anchor | Motivo |
|---|---|---|---|
| Portada · sección Plantillas | `/plantillas` | "Ver las plantillas" | Abre el pilar; hoy no lleva a ninguna parte |
| Portada · cada categoría | `/plantillas/{slug}` | Nombre de la categoría | Convierte diez `<span>` muertos en once enlaces |
| Pilar | Cada cluster | Nombre de la categoría | Reparte autoridad hacia abajo |
| Cluster | Cada hoja publicada | Nombre del documento | Que ninguna hoja quede huérfana |
| Cluster | 2–3 clusters hermanos | Nombre de la categoría | Enlaza el nivel medio entre sí |
| Hoja | Su cluster (migas) | Nombre de la categoría | Devuelve autoridad hacia arriba |
| Hoja | 3 hojas de la misma categoría | Nombre del documento | Mantiene al visitante dentro |
| Hoja | `/register` | "Crear este documento" | El paso transaccional |
| Pie de página (global) | Términos, Privacidad, Contacto | Su nombre | Confianza y E-E-A-T (§21) |

**Qué evitar:** anchors repetidos como "clic aquí"; enlazar las 251 hojas desde la portada; cadenas de más de tres saltos desde la portada a cualquier hoja.

---

# 15. Auditoría de imágenes

✅ **Sin hallazgos, porque no hay imágenes.** La aplicación en producción tiene **cero** elementos `<img>` y `public/` está vacía. Toda la interfaz se construye con iconos SVG en línea (`lucide-react`), que no necesitan `alt`.

Consecuencias:

- No hay problemas de `alt`, ni de nombres de archivo, ni de texto incrustado. Los hallazgos que pedía el encargo no aplican.
- ✅ Ventaja de rendimiento: nada de imágenes que optimizar.
- 🔴 **Pero falta la imagen Open Graph** (P1): al compartir `savedocumentos.com` por WhatsApp o LinkedIn sale una tarjeta en blanco. Para un producto que se recomienda de boca en boca entre profesionales, eso cuesta clics.

**Cuando se añadan imágenes:** nombres en minúsculas y con guiones (`contrato-alquiler-vivienda-save.png`), `alt` descriptivo en las informativas, `alt=""` en las decorativas, y usar `next/image`.

---

# 16. Auditoría de schema

**Hoy:** solo `WebSite` en la portada, válido pero mínimo.

**Estrategia recomendada**, únicamente con entidades que existen de verdad:

| Página | Schema | Justificación |
|---|---|---|
| Portada | `WebSite` + `Organization` | SA&VE Comercial, S.R.L. es una entidad real |
| Portada | `FAQPage` | Las cinco preguntas **están visibles** en la página. Legítimo |
| Pilar y clusters | `CollectionPage` + `BreadcrumbList` | Son colecciones de verdad |
| Hojas | `WebPage` + `BreadcrumbList` | |
| Producto | `SoftwareApplication` | Solo cuando haya precios públicos |

## 🚫 Local SEO: NO DEBE IMPLEMENTARSE

El encargo pide evaluarlo. **La respuesta es no.** `LocalBusiness` sirve para negocios donde un cliente se presenta físicamente. SAVE es un SaaS: nadie va a Punta Cana a recoger un contrato. Poner `LocalBusiness` con horarios y dirección sería describir un negocio que no funciona así.

`Organization` sí corresponde, con el nombre legal, el dominio y —cuando exista— la página de contacto. **Sin inventar** teléfonos, horarios, valoraciones ni precios.

---

# 17. Auditoría de robots.txt

**Antes:** 🔴 404. **Ahora:** ✅ `src/app/robots.ts`.

```
User-agent: *
Allow: /
Disallow: /app/
Disallow: /auth/

Host: https://savedocumentos.com
Sitemap: https://savedocumentos.com/sitemap.xml
```

El razonamiento sobre qué NO se bloquea está en §10.

**Verificación:** `curl -I https://savedocumentos.com/robots.txt` debe devolver 200 y el cuerpo mencionar el sitemap.

---

# 18. Auditoría de sitemap

**Antes:** 🔴 404. **Ahora:** ✅ `src/app/sitemap.ts`, con **una URL**: la portada.

Eso no es un descuido del archivo: **es el diagnóstico**. Hoy el sitio público consta de una página. Un sitemap corto y cierto vale más que uno largo lleno de URLs bloqueadas o inexistentes.

**Cuando existan las páginas de §13**, el sitemap pasa a leerse de la base:

```ts
// Solo plantillas maestras PUBLISHED: son las únicas que un visitante puede ver.
const { data } = await supabase
  .from('templates')
  .select('slug, updated_at')
  .eq('is_master', true)
  .eq('status', 'PUBLISHED')
```

Así el sitemap crece **solo**, al mismo ritmo que la abogada aprueba, sin volver a desplegar.

---

# 19. Auditoría de llms.txt

🔴 **NO IMPLEMENTADO.** `savedocumentos.com/llms.txt` devuelve 404.

**P3.** No es un estándar reconocido por ningún buscador y no sustituye a nada. Cuesta poco y no estorba, pero **no antes** que el sitemap y las páginas reales: describir en `llms.txt` una estructura que todavía no existe no ayuda a nadie.

Cuando se haga, debe explicar qué es SAVE, para quién, las once categorías reales, el enlace al pilar y la información pública de la empresa. **Sin** datos internos, credenciales ni información de usuarios.

---

# 20. Google Analytics

🔴 **NO IMPLEMENTADO.** Verificado en producción con sesión iniciada: `typeof window.gtag === "undefined"` y `window.dataLayer` no existe. Cero referencias a `gtag`, `googletagmanager` o cualquier medición en todo el código.

**No es que esté mal configurado. No está.**

**P1.** Arrancar adquisición orgánica sin medirla es gastar sin saber en qué.

**Esquema mínimo de eventos propuesto** —ocho, no cuarenta—:

| Evento | Cuándo | Por qué importa |
|---|---|---|
| `sign_up` | Registro completado | La conversión principal |
| `login` | Sesión iniciada | Retención |
| `template_view` | Se abre una hoja | Qué documentos interesan |
| `template_start` | Se pulsa "Usar" | Intención real |
| `document_created` | Documento generado | **La métrica de valor entregado** |
| `document_download` | Descarga Word o PDF | Cierre del ciclo |
| `document_shared` | Se comparte | Uso en equipo |
| `cta_click` | CTA de la portada o cluster | Qué mensaje funciona |

**👤 ACCIÓN MANUAL:** crear la propiedad GA4 en [analytics.google.com](https://analytics.google.com), copiar el *Measurement ID* (`G-XXXXXXXXXX`) y añadirlo en Railway como `NEXT_PUBLIC_GA_ID`. Recordar que las `NEXT_PUBLIC_*` se congelan en el build: **hay que redesplegar**.

**Consentimiento:** SAVE atiende a clientes que pueden estar en la UE. Si se instala GA4, conviene un banner de consentimiento previo. Hoy no hay ninguno, porque tampoco hay cookies de terceros.

---

# 21. Google Search Console

🌐 **REQUIERE ACCESO EXTERNO** y 👤 **ACCIÓN MANUAL.** No se puede verificar ni configurar desde aquí, y no voy a afirmar que quedó hecho.

**Pasos exactos:**

1. Entrar en [search.google.com/search-console](https://search.google.com/search-console)
2. Añadir propiedad → **Prefijo de URL** → `https://savedocumentos.com`
   *(No "Dominio": esa exige un registro DNS y `www` ni siquiera resuelve.)*
3. Verificar con la **etiqueta HTML**. Google da algo así como `<meta name="google-site-verification" content="AbC123...">`. Pásame ese valor y lo añado al `metadata` del layout raíz; se despliega y se pulsa Verificar.
4. Una vez verificada: **Sitemaps** → escribir `sitemap.xml` → Enviar.
5. **Comprobar que funcionó:** a las 48 h, en *Páginas*, la portada debe aparecer como "Indexada". En *Sitemaps*, estado "Correcto" con 1 URL descubierta.

Hasta que existan las páginas de §13, no hay mucho más que mirar: una sola URL indexable da muy pocos datos.

---

# 22. Mobile UX

Comprobado en producción a **606 px de ancho**, un viewport de teléfono grande.

| Comprobación | Resultado |
|---|---|
| Meta viewport | ✅ `width=device-width, initial-scale=1` |
| Scroll horizontal | ✅ Ninguno. `scrollWidth === clientWidth` |
| Formulario de generación | ✅ Los 18 campos se usan sin zoom |
| Estados vacíos | ✅ Legibles |
| Menú lateral | ⚠️ `hidden md:block` — **en móvil desaparece y no hay sustituto** |
| Pantalla de Plantillas | ⚠️ 251 tarjetas de golpe: 7.147 nodos, sin buscador ni paginación |

## 22.1 El menú desaparece en móvil · P1

El `<aside>` del área privada es `hidden md:block`: por debajo de 768 px **no se renderiza**, y no hay menú hamburguesa que lo reemplace. En un teléfono, quien entre a `/app/documents` no tiene forma de llegar a Plantillas, Bóveda ni Mi Despacho salvo escribiendo la URL.

## 22.2 CTA fijo en móvil

🚫 **NO en la aplicación.** Un CTA fijo por encima de un editor de documentos estorba.

🟡 **Quizá en la portada.** Y **no de llamada**: SAVE no convierte por teléfono, y el encargo prohíbe inventarse un número. Si se pone, que sea **"Crear mi primer documento"** hacia `/register`, respetando el área segura del teléfono (`env(safe-area-inset-bottom)`).

## 22.3 Botón compartir

✅ El de **documentos** existe y funciona (§5).

🟡 El de **páginas públicas** —Web Share API con copia de enlace de reserva— tiene sentido en las hojas de plantilla de §13, cuando existan. Antes no hay nada que compartir. **Nunca** debe exponer datos de un documento privado.

---

# 23. Dark Mode

⚠️ **IMPLEMENTADO INCORRECTAMENTE**, que es peor que no estarlo: parece hecho y no lo está.

**Lo verificado en producción:**

```js
document.documentElement.className  // → "light"
// botones de tema en toda la interfaz: 0
```

**Por qué no funciona.** `src/index.css` declara:

```css
@custom-variant dark (&:where(.dark, .dark *));
```

La variante `dark:` solo se activa si un ancestro tiene la clase `dark`. Y `src/app/layout.tsx` fija:

```html
<html lang="es-DO" className="light">
```

Fijo, sin lógica que lo cambie. **Nada en todo el proyecto añade o quita la clase `dark`.** No hay botón, ni `localStorage`, ni lectura de `prefers-color-scheme`.

**El coste:** **47 archivos** llenos de clases `dark:*`. Son código muerto que se mantiene, se lee y se copia al escribir componentes nuevos. Cada pantalla nueva nace con clases que no hacen nada.

**Dos salidas honestas, P2:**

- **Terminarlo:** botón en la cabecera, clase en `<html>`, persistencia en `localStorage`, valor inicial desde `prefers-color-scheme` y un script en línea que evite el parpadeo blanco. Las 47 archivos ya están escritos: el trabajo real es pequeño.
- **Retirarlo:** quitar las clases `dark:` y dejar de fingir. Menos CSS y menos ruido.

Lo que no conviene es dejarlo como está.

---

# 24. Accesibilidad

Comprobado sobre el formulario de generación en producción.

| Comprobación | Resultado |
|---|---|
| Etiquetas asociadas a los campos | ⚠️ **Ninguna.** Ni `label[for]`, ni `aria-label`, ni `<label>` envolvente |
| `lang` del documento | ✅ `es-DO` |
| Textos de ayuda visibles | ✅ *"Un número del 1 al 28"* |
| Marca de obligatorio | 🟡 Solo un `*` visual; sin `aria-required` ni `required` |
| Botones sin nombre accesible | 🟡 Uno |
| Alternativas textuales de imágenes | ✅ No aplica: no hay imágenes |
| Navegación por teclado y foco | 🔍 NO VERIFICADO |
| Contraste WCAG | 🔍 NO VERIFICADO — 🌐 requiere una herramienta de contraste |

**El hallazgo principal es el de las etiquetas · P2.** Los campos se ven bien, pero un lector de pantalla no relaciona el texto con el campo: quien lo use oirá "campo de edición" dieciocho veces seguidas. Se arregla poniendo `id` en cada campo y `htmlFor` en su etiqueta. Es una tarde de trabajo en `GeneratorClient.tsx`.

---

# 25. Rendimiento

🌐 **Core Web Vitals: REQUIERE ACCESO EXTERNO.** LCP, INP y CLS reales necesitan PageSpeed Insights o los datos de campo de Search Console. **No los invento.**

Lo que sí se puede afirmar por observación directa:

| Hallazgo | Prioridad |
|---|---|
| **La hoja de estilos de Google Fonts bloquea el renderizado.** `<link rel="stylesheet">` en el `<head>`, con dos familias y muchos pesos. Los `preconnect` ayudan, pero sigue bloqueando. `next/font` la incrustaría y quitaría el salto | P2 |
| **El middleware se ejecuta en TODAS las rutas**, portada incluida, y llama a `supabase.auth.getUser()` en cada petición. Un visitante anónimo paga una llamada de red a Supabase para ver una página estática | P2 |
| **251 tarjetas de plantilla a la vez**: 7.147 nodos, sin buscador ni paginación | P2 |
| Sin imágenes que optimizar | ✅ |
| Dependencias ligeras: sin librerías de gráficas ni UI pesadas | ✅ |
| Portada con `revalidate = 300`: se sirve cacheada | ✅ |

**El middleware es el arreglo con mejor relación esfuerzo/beneficio:** ajustar el `matcher` para que solo cubra `/app/*`, `/auth/*` y las pantallas de sesión. La portada dejaría de pagar una llamada de red por visita — y es justo la página a la que va a llegar todo el tráfico orgánico.

---

# 26. Seguridad

**Sin hallazgos P0.** Es la sección que mejor sale, y no por poco.

| Comprobación | Resultado |
|---|---|
| Rutas privadas sin sesión | ✅ `/app/dashboard` redirige a `/login` |
| RLS activo en todas las tablas | ✅ |
| Bucket `vault` privado (`public = false`) | ✅ |
| Aislamiento del Storage por despacho | ✅ La primera carpeta es el `org_id` |
| `SUPABASE_SERVICE_ROLE_KEY` solo en servidor | ✅ Tres archivos, ninguno `'use client'` |
| Variables expuestas al navegador | ✅ Solo `NEXT_PUBLIC_SUPABASE_URL`, `ANON_KEY` y `SITE_URL` |
| Autorización en dos capas | ✅ Server Actions **y** políticas RLS |
| El paralegal no puede reenviar ni borrar lo compartido | ✅ Verificado en producción |
| El paralegal no puede tocar los ajustes del despacho | ✅ Campos deshabilitados **y** RLS por debajo |
| Escalada de plan desde la aplicación | ✅ Bloqueada por `guard_org_plan_columns` |
| Recursión en las políticas de compartir | ✅ Evitada con funciones `SECURITY DEFINER` |

**Prueba pendiente · P1.** No se pudo demostrar que un paralegal **no** ve los documentos que no le compartieron: en producción solo existe un documento y está compartido. La lógica está verificada sobre PostgreSQL 16 con un despacho de tres personas, pero no en producción. Se cierra en dos clics: quitar el compartir y recargar como paralegal.

**👤 Las dos credenciales expuestas siguen sin rotar.** Es el único punto de seguridad realmente abierto de todo el informe.

---

# 27. Problemas críticos

| # | Problema | Estado |
|---|---|---|
| C1 | **Las 251 plantillas eran imposibles de aprobar.** Un alias derivado que nunca se enganchaba bloqueaba el catálogo entero | ✅ **CORREGIDO Y VERIFICADO** |
| C2 | **Dos credenciales expuestas en texto plano y sin rotar** | 👤 **ABIERTO — lo más urgente del informe** |

No hay ningún otro P0. La seguridad, que era el riesgo mayor de un producto que guarda documentos ajenos, sale limpia.

---

# 28. Problemas importantes

| # | Problema | Prio | Dónde |
|---|---|---|---|
| I1 | El catálogo está al 0 %: ningún usuario ve ninguna plantilla | P1 | Revisión legal |
| I2 | **Sitio público de una sola página.** Sin clusters no hay adquisición orgánica posible | P1 | Producto + SEO |
| I3 | **Sin Google Analytics.** `gtag` es `undefined` en producción | P1 | Frontend |
| I4 | **Sin términos, privacidad, contacto ni precios** | P1 | Contenido + legal |
| I5 | **El plan Equipo no sube ningún límite.** BUSINESS a RD$999/mes tiene el mismo cupo que gratis: 10 plantillas, 30 archivos | P1 | Negocio + BD |
| I6 | **El menú lateral desaparece en móvil** y no hay hamburguesa | P1 | `src/app/app/layout.tsx` |
| I7 | Sin imagen Open Graph: la tarjeta al compartir sale en blanco | P1 | `public/` + metadata |
| I8 | No demostrado en producción que un paralegal no vea lo no compartido | P1 | Prueba |
| I9 | **La bóveda es de todo el despacho**, a diferencia de los documentos | P1 | Decisión de producto |
| I10 | Modo oscuro: 47 archivos de código muerto | P2 | CSS + layout |
| I11 | Campos del formulario sin etiqueta asociada | P2 | `GeneratorClient.tsx` |
| I12 | 251 tarjetas de golpe, sin buscador ni paginación | P2 | `TemplatesClient.tsx` |
| I13 | El middleware corre en la portada y llama a Supabase por visita | P2 | `middleware.ts` |
| I14 | Google Fonts bloquea el renderizado | P2 | `layout.tsx` |
| I15 | La portada anuncia 10 categorías; la base tiene 11 distintas | P2 | `page.tsx` + BD |
| I16 | *"Debe tener ya una cuenta"*: el texto contradice al producto | P2 | `SettingsClient.tsx` |
| I17 | Sin estado RECHAZADA para la revisión | P2 | BD + Revisión |
| I18 | `www.savedocumentos.com` no resuelve | P2 | DNS |
| I19 | Quien recibe un documento no ve que se lo compartieron | P3 | `SharePanel.tsx` |
| I20 | `dias_pago` y `dia_pago`; *"Depósito de/en garantía"* | P3 | Catálogo |
| I21 | Saltos de línea mezclados en el texto guardado | P3 | Catálogo |
| I22 | Sin `llms.txt` | P3 | — |

---

# 29. Quick wins

Mucho efecto, poco esfuerzo. Por orden de rentabilidad:

| # | Qué | Esfuerzo | Efecto |
|---|---|---|---|
| Q1 | **Rotar las dos credenciales** | 10 min | Cierra el único riesgo abierto |
| Q2 | **Enlazar las categorías de la portada** en vez de dejarlas como `<span>` | 1 h | Once páginas potenciales dejan de ser texto muerto |
| Q3 | **Imagen Open Graph** | 1 h | Cada enlace compartido deja de salir en blanco |
| Q4 | **Restringir el `matcher` del middleware** a `/app` y `/auth` | 15 min | La portada deja de llamar a Supabase por visita |
| Q5 | **Menú hamburguesa en móvil** | 2 h | La app deja de ser inutilizable en teléfono |
| Q6 | **Instalar GA4** | 1 h + acción manual | Se empieza a medir |
| Q7 | **Subir los límites de BUSINESS** | 30 min | Que el plan de pago valga lo que cuesta |
| Q8 | **Corregir el texto de la invitación** | 5 min | Deja de mentir sobre el producto |
| Q9 | **Buscador en Plantillas** | 2 h | 251 tarjetas se vuelven usables |
| Q10 | **Etiquetas del formulario** | 2 h | Accesibilidad básica |

Ya resueltos durante esta auditoría: `robots.txt`, `sitemap.xml`, `noindex` y descripciones propias en las pantallas de autenticación, y el `{"engine":"v2"}` que salía impreso 251 veces.

---

# 30. Roadmap recomendado

## BLOQUE 0 — Hoy mismo

- [ ] **Rotar las dos credenciales expuestas**
- [ ] Desplegar y **verificar** que `robots.txt` y `sitemap.xml` responden 200
- [ ] Cerrar la prueba de privacidad: quitar el compartir y recargar como paralegal

## BLOQUE 1 — Seguridad y funcionamiento

Sin hallazgos P0 abiertos aparte de las credenciales. Este bloque está prácticamente cerrado.

- [ ] Decidir la **bóveda**: ¿por despacho o por persona? (§26, I9)
- [ ] Menú móvil (I6)

## BLOQUE 2 — Plantillas · el bloque más largo

**No se puede acelerar con código.** Es tiempo de abogada.

- [x] Desbloquear la aprobación (C1) ✅
- [ ] **Aprobar las 123 cláusulas** ← empezar por aquí, sin excepción
- [ ] Aprobar las 251 plantillas
- [ ] Añadir el estado RECHAZADA (I17)
- [ ] Renombrar las variables y cláusulas confundibles (I20)

> **Hito:** el día que la primera plantilla se publique, el número de la portada dejará de decir "estamos terminando de revisar el catálogo" y pasará a contar. Ese contador ya está puesto y sube solo.

## BLOQUE 2b — Cambio de modelo de visibilidad ⚠️ NUEVO

**Decisión tomada el 4 de septiembre**, y **invierte** el modelo construido y verificado el 1 de septiembre.

- **Ahora:** un documento lo ve su autor, el titular del despacho y aquel con quien se comparta.
- **Se quiere:** que **todo el despacho vea todo**, salvo que el autor marque el documento como **privado**.

Lo que implica:

- [ ] Nueva columna `documents.es_privado`, por defecto `false`
- [ ] `documents_select` vuelve a permitir a los miembros del despacho, **excepto** cuando `es_privado = true` y no eres el autor ni el titular
- [ ] `document_shares` cambia de sentido: pasa de "conceder acceso" a "dar acceso a un documento privado". La tabla y las funciones `SECURITY DEFINER` se aprovechan tal cual
- [ ] Interruptor "Privado" en la vista del documento
- [ ] El botón Compartir solo aparece en los documentos privados
- [ ] Rehacer la prueba de los tres perfiles sobre el modelo nuevo

**Decidido el 4 de septiembre: los documentos que ya existen nacen privados.**

Es la opción correcta y conviene entender por qué. La migración que active el modelo nuevo tiene que poner `es_privado = true` en todo lo anterior, no dejarlo al valor por defecto:

```sql
ALTER TABLE documents ADD COLUMN es_privado BOOLEAN NOT NULL DEFAULT false;

-- Lo que ya existía se creó bajo la promesa de que solo lo veía su autor.
-- Cambiar esa promesa por sorpresa, con el despliegue, sería enseñar a
-- todo el despacho documentos que nadie decidió compartir.
UPDATE documents SET es_privado = true;
```

Es una línea, y sin ella el día del despliegue todo el despacho vería documentos que se escribieron creyendo que eran privados. De ahí en adelante, lo nuevo nace visible para el despacho y quien quiera lo marca como privado.

Los dos modelos son defendibles; lo que no conviene es alternar entre ellos.

## BLOQUE 3 — SEO técnico

- [x] `robots.txt` ✅
- [x] `sitemap.xml` ✅
- [x] `noindex` y descripciones propias en autenticación ✅
- [ ] Imagen Open Graph (Q3)
- [ ] Schema `Organization` y `FAQPage` (§16)
- [ ] Decidir el `www` (I18)
- [ ] Verificar Search Console y enviar el sitemap (§21)

## BLOQUE 4 — Arquitectura SEO · el bloque más grande

Solo tiene sentido **después** del bloque 2: sin plantillas aprobadas no hay hojas que publicar.

- [ ] Alinear las categorías de la portada con las once reales (I15)
- [ ] Página pilar `/plantillas`
- [ ] Once páginas de cluster
- [ ] Hojas generadas desde la base, **solo de plantillas `PUBLISHED`**
- [ ] Migas de pan e interlinking (§14)
- [ ] Sitemap dinámico (§18)

## BLOQUE 5 — Conversión

- [ ] CTA contextual tras el primer párrafo de cada cluster
- [ ] "Lo más importante" y FAQ en los clusters
- [ ] **Términos, privacidad y contacto** (I4) — también E-E-A-T
- [ ] Página de precios
- [ ] Evaluar el CTA fijo en móvil (§22.2)

## BLOQUE 6 — Analítica

- [ ] GA4 con los ocho eventos de §20
- [ ] Search Console operativo
- [ ] Banner de consentimiento si hay tráfico europeo

## BLOQUE 7 — Rendimiento

- [ ] Restringir el `matcher` del middleware (Q4)
- [ ] `next/font` en vez del `<link>` de Google Fonts (I14)
- [ ] Buscador y paginación en Plantillas (I12)
- [ ] Medir Core Web Vitals **de verdad** con PageSpeed Insights

## BLOQUE 8 — Accesibilidad

- [ ] Etiquetas asociadas en los formularios (I11)
- [ ] Terminar **o retirar** el modo oscuro (I10)
- [ ] Comprobar contraste WCAG y navegación por teclado

---

# 21b. E-E-A-T y confianza

Va aparte porque, para un producto legal, pesa más que casi todo lo anterior.

| Elemento | Estado |
|---|---|
| Quién está detrás de SAVE | 🔴 No aparece en ninguna parte del sitio público |
| Información empresarial (SA&VE Comercial, S.R.L.) | 🔴 Ni el nombre legal |
| Página de contacto | 🔴 No existe |
| Términos de servicio | 🔴 No existen |
| Política de privacidad | 🔴 **No existe** — y el producto guarda documentos con cédulas y domicilios |
| Aviso de que no es asesoría jurídica | 🟡 Solo en el FAQ de la portada |
| Revisión legal de las plantillas | ✅ El sistema **la exige**: nada se publica sin firma |

**Lo que ya está bien resuelto, y conviene contarlo.** El FAQ responde *"¿SAVE reemplaza a mi abogado?"* de frente, sin venderse como sustituto de asesoría. Y el producto lo respalda de verdad: `quality.ts` **impide publicar** una plantilla maestra sin la firma de un profesional. Eso es exactamente la señal de E-E-A-T que Google busca en el sector legal, y hoy no se está contando en ninguna parte.

**Recomendación · P1:** una página "Quiénes somos" con el nombre legal, la sede en Punta Cana y —cuando el catálogo esté aprobado— quién lo revisó. Más términos, privacidad y contacto enlazados desde el pie en todas las páginas.

---

# Anexo · Matriz de auditoría

| Área | Estado | Problema | Impacto | Prio | Solución | Archivo | Cómo verificar |
|---|---|---|---|---|---|---|---|
| Plantillas | ✅ Corregido | Alias derivado sin enganchar bloqueaba 250 | Catálogo inaprobable | P0 | Migración de enganche | `20260903000000_variables_de_firma.sql` | El formulario pregunta "¿Cuándo se firma?" |
| SMTP | 👤 Abierto | Dos credenciales expuestas | Acceso al buzón | P0 | Rotarlas | Hostinger | Que el envío siga funcionando tras rotar |
| Plantillas | ⚠️ | 0 de 251 aprobadas | Producto vacío | P1 | Revisión legal | `/app/revision` | El contador de la portada sube |
| SEO | 🔴 | Una sola página indexable | Sin adquisición | P1 | Clusters (§13) | Rutas nuevas | Sitemap con más de una URL |
| Analítica | 🔴 | GA4 ausente | Se gasta a ciegas | P1 | Instalar GA4 | `layout.tsx` | `window.gtag` definido |
| Confianza | 🔴 | Sin términos ni privacidad | Legal y credibilidad | P1 | Crear páginas | Rutas nuevas | Enlazadas desde el pie |
| Negocio | ⚠️ | BUSINESS no sube límites | Se cobra sin dar más | P1 | Límites por plan | `organizations` | Un despacho BUSINESS ve cupo mayor |
| Móvil | ⚠️ | Menú ausente bajo 768 px | App inusable | P1 | Hamburguesa | `app/layout.tsx` | Navegar a 375 px |
| Privacidad | 🔍 | No probado en producción | Riesgo de fuga | P1 | Quitar el compartir y recargar | — | El documento desaparece |
| Bóveda | ⚠️ | Visible a todo el despacho | Incoherente | P1 | Decisión de producto | `20260822000001` | Según se decida |
| OG | 🔴 | Sin imagen | Tarjetas en blanco | P1 | Crear `og.png` | `public/` | Probar en WhatsApp |
| Modo oscuro | ⚠️ | 47 archivos muertos | Deuda | P2 | Terminar o retirar | `layout.tsx` | La clase `dark` cambia |
| Accesibilidad | ⚠️ | Campos sin etiqueta | Lector de pantalla | P2 | `id` + `htmlFor` | `GeneratorClient.tsx` | Auditoría de accesibilidad |
| Rendimiento | ⚠️ | Middleware en la portada | Latencia | P2 | Restringir `matcher` | `middleware.ts` | Sin llamada a Supabase en `/` |
| Rendimiento | ⚠️ | 251 tarjetas de golpe | Lento en móvil | P2 | Buscador + paginación | `TemplatesClient.tsx` | Menos nodos |
| Contenido | ⚠️ | 10 categorías vs 11 reales | Incoherencia | P2 | Leer de la base | `page.tsx` | Coinciden |
| Copia | ⚠️ | "Debe tener ya una cuenta" | Texto falso | P2 | Reescribir | `SettingsClient.tsx` | Refleja el producto |
| Revisión | 🟡 | Sin estado RECHAZADA | No se registra el rechazo | P2 | Usar ARCHIVED + motivo | BD | Se puede rechazar |
| DNS | 🟡 | `www` no resuelve | Visitas perdidas | P2 | CNAME + 301 | DNS | `www` redirige |
| Compartir | 🟡 | El receptor no sabe que le compartieron | UX | P3 | Mostrar quién y cuándo | `SharePanel.tsx` | Aparece la línea |
| Catálogo | 🟡 | Nombres confundibles | Errores futuros | P3 | Renombrar | `catalog/` | Sin pares ambiguos |
| Catálogo | 🟡 | CRLF mezclado | Saltos en Word | P3 | Normalizar | Migración | Cero `\r` |
| SEO | 🔴 | Sin `llms.txt` | Bajo | P3 | Crear | `app/llms.txt` | Responde 200 |

---

## Criterio de éxito

> *"¿Está SAVE Documentos técnicamente preparado para comenzar una etapa seria de adquisición orgánica y comercial, y qué debemos corregir antes de hacerlo?"*

**El producto está más listo que el canal.** El motor genera contratos correctos, la seguridad aguanta, el trabajo en equipo funciona con sus permisos bien repartidos, y el correo llega. Nada de eso es poco.

Lo que falta antes de gastar un peso en adquisición son tres cosas, en este orden:

1. **Que haya algo que enseñar.** Hoy un cliente nuevo entra y ve un catálogo vacío. Es tiempo de abogada, no de código.
2. **Que haya dónde aterrizar.** Una sola página indexable no sostiene una estrategia orgánica.
3. **Que se pueda medir.** Sin GA4 no se sabrá qué funcionó.

Los tres son trabajo conocido y acotado. Ninguno es un rescate.
