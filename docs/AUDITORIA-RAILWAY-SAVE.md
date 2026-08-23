# Auditoría de Despliegue en Railway — SAVE (Plataforma Documental Legal)
Fecha: 2026-08-21

Metodología: no me limité a leer el código — reproduje exactamente lo que Railway hace. Copié el árbol de archivos (respetando `.dockerignore`), corrí `npm ci` tal como lo hace el `Dockerfile`, corrí `next build`, generé el output `standalone`, y arranqué `node server.js` con y sin variables de entorno, haciendo requests reales a `/`, `/login` y `/app/dashboard`. Los hallazgos marcados **[VERIFICADO EMPÍRICAMENTE]** no son teoría: los reproduje y capturé el error real.

---

## 0. EN QUÉ ETAPA ESTÁN (según `docs/planificacion/11-PLAN-DE-IMPLEMENTACION.md`)

El roadmap define 4 fases. Comparando el plan contra el código real:

- **Fase 1 (Arquitectura base + Backend cloud) — ~85% hecha.** Next.js App Router inicializado, Supabase Auth conectado (login/registro/logout con Server Actions), `railway.toml` + `Dockerfile` presentes, migración SQL inicial existe. Falta: el trigger que sincroniza `auth.users` → `profiles` (no existe, ver hallazgo #9), la tabla `save_admins` que el propio diseño de BD pide pero la migración nunca creó (ver hallazgo #10), y — crítico — **el pipeline de deploy en sí está roto** (hallazgos #1 y #2).
- **Fase 2 (Auth, roles y organización) — apenas iniciada.** Hay pantallas de login/registro, pero no hay UI de invitación de miembros, el dashboard muestra datos estáticos hardcodeados (`0/10`, `0/30`, `1`) en lugar de leer `organizations`/`org_members`, y no hay Server Actions para gestión de organización.
- **Fase 3 (Migración del editor legal: Cláusulas, Reglas, Variables, Editor, Bóveda) — 0% integrada.** Existe un volumen enorme de código (`src/components/*.tsx`, `src/core/*.ts`, `src/store/useAppStore.ts`, ~26 archivos, cientos de KB) que implementa toda esta funcionalidad, pero **ningún archivo bajo `src/app/` los importa**. Es código huérfano: probablemente proviene de una versión anterior (SPA tipo Vite/AI Studio) y nunca se conectó al App Router nuevo.
- **Fase 4 (Bóveda, PayPal, Backoffice) — 0%.** No hay integración de Supabase Storage, PayPal, ni backoffice real (solo el check de `save_admins`, que apunta a una tabla inexistente).

**Qué falta para pasar a la siguiente etapa:** primero estabilizar el despliegue (Sección 1 de hallazgos), luego cerrar el gap de esquema de BD (`save_admins`, trigger de `profiles`), y después decidir conscientemente si el código de `src/components`/`src/core` se va a portar a Server/Client Components de Next.js (tal como dice ADR/Plan Fase 3) o se descarta — hoy es peso muerto que confunde el build.

---

## 1. HALLAZGOS DETALLADOS

### 🔴 CRÍTICO — #1: `npm ci` falla porque `package-lock.json` está desincronizado del `package.json`
**Severidad:** CRÍTICO
**Archivo:** `package-lock.json` (raíz del proyecto)
**Ubicación:** todo el archivo — falta la resolución de `@emnapi/core@1.11.3` y `@emnapi/wasi-threads@1.2.3`
**Problema:** Ejecuté literalmente el comando del `Dockerfile` (`npm ci`) sobre tu código tal cual está, y falla de inmediato:
```
npm error `npm ci` can only install packages when your package.json and package-lock.json ... are in sync.
npm error Missing: @emnapi/core@1.11.3 from lock file
npm error Missing: @emnapi/wasi-threads@1.2.3 from lock file
```
**Por qué falla en Railway:** el `Dockerfile` (etapa `deps`, línea 7) ejecuta exactamente `RUN npm ci`. Con el lockfile actual, esa instrucción termina el build con código de salida distinto de 0. Railway marca el build como fallido — nunca llega a arrancar el contenedor. Esto explicaría un error tipo `Exited with code 1` **durante el build**, no en runtime.
**Causa probable:** el lockfile se generó/editó en Windows en un momento distinto al último cambio del `package.json` (o con una resolución de dependencias opcionales — `lightningcss`/`@tailwindcss/oxide` tienen binarios nativos por plataforma — distinta a la que se necesita). El resultado es que el lockfile no es un reflejo fiel y determinista del árbol de dependencias.
**Solución exacta:** corre `npm install` (no `npm ci`) localmente para regenerar el lockfile, verifica que el build pase (`npm run build`), y commitea el `package-lock.json` actualizado. Ya hice esto por ti y verifiqué que el build pasa — te adjunto el `package-lock.json` corregido en esta respuesta.
**Prioridad:** **arreglar primero.** Sin esto, nada más importa: el build ni siquiera termina.

---

### 🔴 CRÍTICO — #2: Faltan las variables de entorno de Supabase en Railway → 500 en TODAS las rutas, incluido el healthcheck
**Severidad:** CRÍTICO
**Archivo:** `src/middleware.ts` (líneas 12-13), `src/utils/supabase/server.ts` (líneas 8-9), `src/utils/supabase/client.ts` (líneas 5-6)
**Ubicación:** `process.env.NEXT_PUBLIC_SUPABASE_URL!` y `process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!` (non-null assertion — TypeScript no protege esto en runtime)
**Problema [VERIFICADO EMPÍRICAMENTE]:** Construí el build `standalone` exactamente como lo arma el `Dockerfile`, lo arranqué con `node server.js` **sin** esas dos variables de entorno, y pedí `/`:
```
$ curl http://127.0.0.1:3060/
HTTP_STATUS:500

Error: Your project's URL and Key are required to create a Supabase client!
    at .next/server/edge/chunks/[root-of-the-server]__...js:54:5598
```
Esto ocurre porque el `middleware.ts` corre en **todas** las rutas (su `matcher` solo excluye `_next/static`, `_next/image`, `favicon.ico` e imágenes) — incluida la raíz `/`. Al setear las mismas variables, `/` responde `200` normalmente.
**Por qué falla en Railway:** `railway.toml` define `healthcheckPath = "/"`. Si `NEXT_PUBLIC_SUPABASE_URL` / `NEXT_PUBLIC_SUPABASE_ANON_KEY` no están configuradas como variables en el servicio de Railway (el Dockerfile las excluye de la imagen vía `.dockerignore`, así que **no hay ningún archivo `.env` dentro del contenedor** — deben venir del panel "Variables" de Railway), cada request al healthcheck devuelve 500. Railway reintenta según `restartPolicyMaxRetries = 3`, falla, y el deploy queda marcado como no saludable / en loop de reinicios (`Application failed to respond` / `CrashLoopBackOff`).
**Detalle importante:** el `.env.example` del repo **no menciona estas variables** — solo lista `GEMINI_API_KEY` y `APP_URL` (residuo de un scaffold anterior de AI Studio). Cualquiera que configure Railway guiándose por `.env.example` se saltará exactamente las variables que la app necesita para no crashear.
**Solución exacta:**
1. En Railway → tu servicio → pestaña **Variables**, agrega: `NEXT_PUBLIC_SUPABASE_URL` y `NEXT_PUBLIC_SUPABASE_ANON_KEY` (los valores están en tu Supabase Dashboard → Project Settings → API; ya existen en tu `.env.local` local, no los repito aquí porque son secretos).
2. Corrige `.env.example` para que documente las variables reales que la app usa (ver hallazgo #4).
3. Opcional pero recomendado: envuelve las llamadas a `createServerClient`/`createBrowserClient` con una validación explícita que lance un error legible ("Falta NEXT_PUBLIC_SUPABASE_URL") en vez de depender del mensaje genérico de la librería.
**Prioridad:** **arreglar segundo** (justo después del lockfile) — es, junto con el hallazgo #1, la causa más probable de que el deploy no responda.

---

### 🟠 ALTO — #3: `@supabase/supabase-js@2.112.3` requiere Node ≥22, pero el `Dockerfile` usa `node:20-alpine`
**Severidad:** ALTO
**Archivo:** `Dockerfile` (línea 1: `FROM node:20-alpine AS base`)
**Ubicación:** `node_modules/@supabase/supabase-js/package.json` → `"engines": { "node": ">=22.0.0" }`
**Problema:** confirmé el `engines` field directamente en el paquete instalado. npm no bloquea la instalación por esto (no hay `engine-strict` configurado), así que el build no fallará por esta causa — pero estás corriendo una librería en una versión de Node menor a la que declara soportar oficialmente.
**Por qué puede fallar en Railway:** riesgo de comportamientos no garantizados en runtime (APIs de `fetch`/`undici`, streams, etc. que difieren entre Node 20 y 22) al hacer llamadas a Supabase Auth/DB. No es una falla garantizada, pero es una fuente típica de bugs intermitentes difíciles de reproducir localmente si tu máquina de desarrollo usa una versión distinta de Node que el contenedor.
**Solución exacta:** cambia la primera línea del `Dockerfile` a `FROM node:22-alpine AS base`. Ya verifiqué que `next@16.3.1` solo exige `node >=20.9.0`, así que Node 22 es compatible con el resto del stack.
**Prioridad:** corregir junto con el lockfile, antes del próximo deploy — es un cambio de una línea.

---

### 🟠 ALTO — #4: `.env.example` no refleja las variables que la aplicación realmente usa
**Severidad:** ALTO
**Archivo:** `.env.example`
**Ubicación:** todo el archivo
**Problema:** el archivo actual documenta `GEMINI_API_KEY` y `APP_URL` (con comentarios que dicen "AI Studio automatically injects this" — es un residuo de un scaffold de Google AI Studio, no de este proyecto Next.js/Supabase). No menciona `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY` ni `SUPABASE_SERVICE_ROLE_KEY`, que sí son las que el código realmente lee (`middleware.ts`, `utils/supabase/*`).
**Por qué puede fallar en Railway:** es la fuente directa del hallazgo #2 — si configuras Railway siguiendo este archivo, te faltarán las variables críticas.
**Solución exacta:** reescribe `.env.example` con las variables reales:
```
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=
```
(Si `GEMINI_API_KEY` sigue siendo necesaria para una futura ruta `/api/analyze-gemini`, agrégala también — ver hallazgo #7.)
**Prioridad:** alta, rápida de corregir, previene errores humanos futuros.

---

### 🟠 ALTO — #5: Secretos reales versionados en disco en `.env` y `.env.local`
**Severidad:** ALTO (posible CRÍTICO si llegaron a subirse a git alguna vez)
**Archivo:** `.env`, `.env.local`
**Ubicación:** ambos archivos, en la raíz
**Problema:** ambos archivos contienen valores reales (no placeholders) — una clave de API de un proveedor de IA y credenciales de un proyecto de Supabase (URL, anon key y **service role key**, esta última con privilegios de administrador que se salta Row Level Security). No voy a citar los valores aquí.
**Por qué puede fallar en Railway:** no es una causa de fallo de despliegue en sí, pero es un riesgo de seguridad real, y si algún día estos archivos se copiaran al contexto de build por error (p. ej. si alguien edita `.dockerignore` y rompe la exclusión), la `service role key` terminaría horneada dentro de la imagen Docker.
**Verificación que hice:** confirmé que `.dockerignore` y `.gitignore` sí excluyen `.env*` (con excepción de `.env.example`), así que **hoy** no se filtran al build ni deberían estar en git. Pero no puedo verificar desde aquí si en algún commit anterior se subieron sin querer.
**Solución exacta:**
1. Corre `git log --all --full-history -- .env .env.local` en tu máquina para confirmar que nunca se commitearon.
2. Si aparecen en el historial, rota esas credenciales (nueva `service role key` en Supabase, nueva API key del proveedor de IA) y purga el historial (`git filter-repo` o similar).
3. Mantén `SUPABASE_SERVICE_ROLE_KEY` fuera del código del cliente siempre — hoy no se usa en ningún lado del código (ver hallazgo #10), así que si la necesitas para una futura ruta de servidor, que solo se lea en un Server Action o Route Handler, nunca en un componente `'use client'`.
**Prioridad:** media-alta, no bloquea el deploy pero sí es higiene de seguridad pendiente antes de ir a producción real.

---

### 🟡 MEDIO — #6: `middleware.ts` está deprecado en Next.js 16
**Severidad:** MEDIO
**Archivo:** `src/middleware.ts`
**Ubicación:** archivo completo
**Problema [VERIFICADO EMPÍRICAMENTE]:** al correr `next build` con Next 16.3.1 (la versión que declara tu `package.json`), la consola muestra:
```
⚠ The "middleware" file convention is deprecated. Please use "proxy" instead.
To migrate automatically, run: npx @next/codemod@canary middleware-to-proxy .
```
Hoy sigue funcionando (hay una capa de compatibilidad — el build lo etiqueta como "Proxy (Middleware)"), pero es una convención que Next.js está retirando.
**Por qué puede fallar en Railway:** no falla hoy, pero una futura actualización de Next.js (incluso un patch dentro del rango `^16.3.1` que tu `package.json` permite) podría eliminar el soporte legacy y romper el build sin previo aviso.
**Solución exacta:** corre `npx @next/codemod@canary middleware-to-proxy .` para migrar a la nueva convención `proxy.ts`, o al menos fija la versión de `next` sin `^` para evitar que un `npm install` futuro te suba a una versión que rompa esto sin que lo notes.
**Prioridad:** no bloquea el próximo deploy, pero prográmalo pronto.

---

### 🟡 MEDIO — #7: `fetch('/api/analyze-gemini')` apunta a una ruta que no existe
**Severidad:** MEDIO
**Archivo:** `src/core/detectorEngine.ts`, línea 225
**Ubicación:** función `detectVariablesWithAI`
**Problema:** el código llama a `POST /api/analyze-gemini`, pero no existe ningún `src/app/api/analyze-gemini/route.ts` (ni ninguna carpeta `api/` bajo `src/app`) en todo el proyecto. Tampoco hay ningún SDK de Gemini/Google AI (`@google/genai`, `@google/generative-ai`, etc.) declarado en `package.json`.
**Por qué puede fallar en Railway:** no rompe el arranque ni el build — la propia función tiene un `try/catch` que hace fallback silencioso al motor de detección local (`console.warn('AI Extraction unavailable, fallback to local NLP engine')`). Pero es una funcionalidad completa (extracción de variables vía IA) que está rota en producción y en local por igual.
**Nota:** esto es consistente con el hallazgo de la sección 0 — este componente pertenece al bloque de código huérfano que aún no se integró al App Router. Hoy además nada lo importa desde `src/app`, así que ni siquiera es alcanzable.
**Solución exacta:** cuando llegues a la Fase 3 del roadmap (integración del motor de IA), crea `src/app/api/analyze-gemini/route.ts` como Route Handler que use `GEMINI_API_KEY` (server-side, nunca `NEXT_PUBLIC_`) para llamar a la API de Gemini.
**Prioridad:** baja para el deploy actual — solo relevante cuando decidas activar esta feature.

---

### 🟡 MEDIO — #8: Gran volumen de código (`src/components`, `src/core`, `src/store`) no está conectado al App Router
**Severidad:** MEDIO (arquitectónico, no bloquea el deploy)
**Archivo:** 26+ archivos bajo `src/components/**` y `src/store/useAppStore.ts`
**Ubicación:** ninguno de estos archivos tiene la directiva `'use client'`, y ningún archivo bajo `src/app/**` los importa (lo confirmé con grep sobre todo `src/app`).
**Problema:** este código (editor de documentos, biblioteca de cláusulas, motor de reglas, bóveda, ribbon estilo Word, etc. — claramente el "motor legal" mencionado en el PRD) es una app aparte, probablemente heredada de una versión previa (Vite/AI Studio), que nunca se migró a Server/Client Components de Next.js como indica la Fase 3 del plan y el ADR-003.
**Por qué no rompe el deploy:** verifiqué que `next build` **no falla** por esto — Next.js solo tipa/empaqueta lo que es alcanzable desde `src/app`, así que este código muerto no afecta el build actual. Si en el futuro alguien lo importa desde una página sin agregar `'use client'` a cada componente que usa `useState`/`localStorage`, el build sí fallará ese día con el error clásico de Next.js "You're importing a component that needs useState. It only works in a Client Component".
**Solución exacta:** decisión de producto/arquitectura, no un bug puntual — o se retoma la Fase 3 y se porta este código agregando `'use client'` donde corresponda y conectándolo a Server Actions reales, o se elimina del repo si va a reescribirse desde cero, para no confundir a quien mantenga el proyecto.
**Prioridad:** no bloquea el próximo deploy — es la definición de "qué falta para la siguiente etapa" (Fase 3).

---

### 🟡 MEDIO — #9: No existe un trigger que sincronice `auth.users` → `profiles`
**Severidad:** MEDIO
**Archivo:** `supabase/migrations/20260819000000_initial_schema.sql`
**Ubicación:** falta un `CREATE TRIGGER ... AFTER INSERT ON auth.users`
**Problema:** `src/app/register/actions.ts` guarda `first_name`, `last_name`, `is_lawyer`, `is_notary` en `options.data` de `supabase.auth.signUp()` — eso solo llega a `auth.users.raw_user_meta_data`, **no** a la tabla `public.profiles`. La migración crea `profiles` con políticas RLS que permiten `INSERT` solo cuando `auth.uid() = id`, pero nada ejecuta ese `INSERT` tras el registro.
**Por qué puede fallar en Railway:** no causa un 500 — `src/app/app/layout.tsx` y `dashboard/page.tsx` usan `profile?.first_name || user.email` con optional chaining, así que degradan silenciosamente mostrando el email. Pero significa que la tabla `profiles` queda vacía para siempre, y cualquier feature que dependa de ella (nombre, rol profesional, matrícula CARD) no funcionará nunca en producción hasta que se agregue este trigger.
**Solución exacta:** agrega una función + trigger de Postgres estándar de Supabase:
```sql
CREATE FUNCTION public.handle_new_user() RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, email, first_name, last_name, prof_role)
  VALUES (
    NEW.id, NEW.email,
    NEW.raw_user_meta_data->>'first_name',
    NEW.raw_user_meta_data->>'last_name',
    CASE
      WHEN (NEW.raw_user_meta_data->>'is_lawyer')::boolean AND (NEW.raw_user_meta_data->>'is_notary')::boolean THEN 'AMBOS'
      WHEN (NEW.raw_user_meta_data->>'is_notary')::boolean THEN 'NOTARIO'
      ELSE 'ABOGADO'
    END
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
```
**Prioridad:** antes de cerrar Fase 2 del roadmap; no bloquea el deploy de Railway.

---

### 🟢 BAJO — #10: La tabla `save_admins` está en el diseño de BD pero nunca se migró
**Severidad:** BAJO (no rompe nada, pero es una feature fantasma)
**Archivo:** comparando `docs/planificacion/06-DISENO-DE-BASE-DE-DATOS.md` (sí la define) contra `supabase/migrations/20260819000000_initial_schema.sql` (no la crea)
**Ubicación:** `src/app/app/layout.tsx` línea 21 y `src/app/app/dashboard/page.tsx` línea 10: `supabase.from('save_admins').select('*')...maybeSingle()`
**Problema:** el cliente de Supabase-js no lanza excepción cuando una tabla no existe — devuelve `{ data: null, error: {...} }`. El código descarta `error` y solo usa `data: admin`, así que `admin` queda `null` y el badge "Super Admin" simplemente nunca se muestra. No crashea, pero es una tabla que tu propio diseño pide y que falta en la migración real.
**Solución exacta:** agrega una migración nueva:
```sql
CREATE TABLE save_admins (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  admin_role VARCHAR
);
ALTER TABLE save_admins ENABLE ROW LEVEL SECURITY;
```
**Prioridad:** baja, cuando retomes el backoffice (Fase 4).

---

### 🟢 BAJO — #11: Dependencia `motion` declarada pero nunca importada
**Severidad:** BAJO
**Archivo:** `package.json`, línea 18 (`"motion": "^12.23.24"`)
**Problema:** hice grep de `from ['"]motion` en todo `src/` y no hay ni un solo import.
**Por qué importa:** no rompe nada, solo agranda el `node_modules` innecesariamente (peso de imagen/build más lento).
**Solución exacta:** si no la vas a usar pronto, quítala de `dependencies`.
**Prioridad:** cosmética.

---

### 🟢 BAJO / INFORMATIVO — #12: `railway.toml` y `Dockerfile` — lo que SÍ está bien
Para que quede claro qué no toqué porque ya está correcto:
- `railway.toml` usa `builder = "dockerfile"` + `startCommand = "node server.js"`, coherente con `CMD ["node", "server.js"]` del Dockerfile y con `output: 'standalone'` en `next.config.ts`. Correcto.
- El Dockerfile **no** setea `NODE_ENV=production` antes de `npm ci`/`npm run build` (lo hace recién en la etapa `runner`) — esto es lo correcto, porque `typescript` y `@tailwindcss/postcss` son `devDependencies` necesarias para el build. Ponerlo antes es un error clásico que rompe builds de Next.js; aquí no lo cometieron.
- `ENV HOSTNAME="0.0.0.0"` y `EXPOSE 3000` / `ENV PORT=3000` están bien — el servidor standalone de Next.js escucha en `0.0.0.0` respetando `PORT`/`HOSTNAME`, que es exactamente lo que Railway necesita (Railway inyecta su propio `PORT` en runtime; como el `Dockerfile` no lo hardcodea con `ENV PORT=3000` de forma que sobreescriba lo que Railway inyecta como variable de entorno del contenedor — la variable de entorno real en runtime gana sobre el `ENV` del Dockerfile solo si Railway la inyecta explícitamente, cosa que Railway sí hace). No encontré ningún `localhost` hardcodeado ni puerto fijo en el código de la app.
- `.dockerignore` excluye correctamente `node_modules/`, `.next/`, `.env*` y — importante — `save-web/` (la carpeta con el proyecto Next.js duplicado/legacy que vive junto a este, con su propio `package.json` y `node_modules`). Si no estuviera excluida, el build de Docker copiaría ese árbol duplicado sin necesidad, aunque no rompería el build ya que no se referencia desde el `Dockerfile` actual.
- Los binarios nativos de Tailwind v4 (`lightningcss-linux-x64-musl`, `@tailwindcss/oxide-linux-x64-musl`) sí quedan resueltos correctamente para Alpine (musl) tras `npm install` — este es un error clásico en Railway/Docker (usar una imagen glibc y que falte el binario musl, o viceversa) y aquí no ocurre.

---

## CAUSA MÁS PROBABLE DEL FALLO

Basado en lo que reproduje empíricamente, en orden de probabilidad:

1. **`npm ci` está fallando en la etapa de build** (hallazgo #1). Este es el candidato más fuerte: lo reproduje ejecutando el comando exacto del `Dockerfile` sobre tu repo tal cual está, y falla con `EUSAGE` antes de instalar un solo paquete. Si esto es lo que está pasando, Railway ni siquiera llega a construir la imagen — verías el fallo en los **Build Logs**, no en los Deploy Logs, con algo como "Missing: @emnapi/... from lock file".
2. **Si el build llegara a pasar (por ejemplo si alguien ya corrigió el lockfile localmente pero no aquí), el contenedor arrancaría pero respondería 500 en absolutamente todas las rutas**, incluida `/` (el healthcheck), por falta de `NEXT_PUBLIC_SUPABASE_URL` / `NEXT_PUBLIC_SUPABASE_ANON_KEY` en las Variables de Railway (hallazgo #2). Esto es indistinguible, desde el panel de Railway, de un "Application failed to respond" — el proceso arranca, el puerto está escuchando, pero cada request truena.
3. **Menos probable como causa de un fallo total, pero real**: el desfase de `engines` de `@supabase/supabase-js` (Node ≥22) contra `node:20-alpine` (hallazgo #3) podría producir errores intermitentes en llamadas a Supabase que sean difíciles de diagnosticar si los dos primeros puntos ya están resueltos.

---

## CHECKLIST ANTES DE VOLVER A DESPLEGAR

1. Reemplaza `package-lock.json` por la versión corregida (adjunta en esta respuesta) o corre `npm install` localmente y confirma que `npm run build` termine sin errores.
2. En Railway → Variables del servicio, confirma que existen `NEXT_PUBLIC_SUPABASE_URL` y `NEXT_PUBLIC_SUPABASE_ANON_KEY` con los valores de tu proyecto Supabase real (no los de `.env.local` de otro entorno si usas proyectos distintos por ambiente).
3. Cambia `FROM node:20-alpine` a `FROM node:22-alpine` en el `Dockerfile`.
4. Corre localmente, con Docker si lo tienes disponible: `docker build -t save-test . && docker run -e NEXT_PUBLIC_SUPABASE_URL=... -e NEXT_PUBLIC_SUPABASE_ANON_KEY=... -p 3000:3000 save-test` y verifica `curl localhost:3000/` devuelve 200 antes de hacer push.
5. Verifica en el SQL Editor de tu proyecto Supabase que la migración `20260819000000_initial_schema.sql` ya se aplicó (tablas `profiles`, `organizations`, `org_members`, `templates`, `documents`, `audit_logs` existen).
6. Actualiza `.env.example` con las variables reales del proyecto.
7. Confirma con `git log --all -- .env .env.local` que esos archivos nunca se subieron al repositorio; si aparecen, rota las credenciales.
8. Haz commit y push de: `package-lock.json` corregido, `Dockerfile` (Node 22), `.env.example` actualizado.
9. Deploy en Railway y revisa **ambos** logs: Build Logs (para confirmar que `npm ci` ya no falla) y Deploy Logs (para confirmar que no aparece el error de Supabase al hacer el primer healthcheck a `/`).

---

## SECUENCIA EXACTA DE PASOS PARA CORREGIR Y VOLVER A DESPLEGAR

1. **(Bloqueante #1 — build)** En tu máquina, dentro de la carpeta del proyecto: borra `package-lock.json` actual (o usa el que te adjunto), corre `npm install`, y luego `npm run build` para confirmar localmente que compila. Commitea el nuevo `package-lock.json`.
2. **(Bloqueante #2 — runtime)** Entra al panel de Railway → tu servicio → **Variables**, y agrega `NEXT_PUBLIC_SUPABASE_URL` y `NEXT_PUBLIC_SUPABASE_ANON_KEY` con los valores de tu proyecto Supabase (Supabase Dashboard → Settings → API).
3. Edita `Dockerfile` línea 1: `FROM node:20-alpine AS base` → `FROM node:22-alpine AS base`.
4. Edita `.env.example` para reflejar las variables reales (ver hallazgo #4).
5. Commit + push de estos tres cambios (`package-lock.json`, `Dockerfile`, `.env.example`) a la rama que Railway despliega.
6. En Railway, dispara un nuevo deploy (o déjalo disparar automáticamente si tienes CI/CD desde GitHub) y observa los **Build Logs** en vivo — confirma que la línea `npm ci` termina con `added N packages` y no con `npm error EUSAGE`.
7. Una vez que el build pase, observa los **Deploy Logs** — confirma que no aparece `Error: Your project's URL and Key are required to create a Supabase client!` y que el healthcheck a `/` pasa (Railway lo marca como "Healthy").
8. Prueba manualmente `/`, `/login`, `/register` en la URL pública de Railway.
9. Con el deploy ya estable, agrega el trigger de `profiles` (hallazgo #9) y la tabla `save_admins` (hallazgo #10) como una migración nueva de Supabase — esto no bloquea el deploy pero cierra el gap de Fase 1/2 del roadmap.
10. Decide y documenta qué pasa con el código huérfano de `src/components`/`src/core`/`src/store` (hallazgo #8) antes de que alguien lo importe sin querer y rompa un build futuro.

---

## Lo que necesitaría para profundizar más
No tengo acceso a: los **Build/Deploy Logs reales de Railway** (para confirmar cuál de los hallazgos #1/#2 es el que efectivamente estás viendo ahora mismo), ni al **dashboard de Supabase** (para confirmar si la migración ya se aplicó). Si me compartes el log de la última corrida fallida en Railway, puedo decirte con certeza cuál de los dos hallazgos críticos es el que te está bloqueando ahora mismo — pero con la evidencia que reproduje, mi apuesta es el #1 (lockfile) primero, y el #2 apareciendo justo después de arreglar el #1.
