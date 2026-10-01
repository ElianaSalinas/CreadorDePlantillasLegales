# Botón oficial de Google — paso a paso para activarlo

**SAVE Documentos · guardado el 29 de septiembre de 2026 · ESTADO: PENDIENTE**

## Qué se consigue

Tu página muestra el botón oficial de Google. Google habla directamente con
`savedocumentos.com`, no con Supabase, así que su ventana ya no debería enseñar
`fzuojuoopngcqrdozvpw.supabase.co`. Cuando la persona elige su cuenta, el
servidor de SAVE le entrega ese login a Supabase (`signInWithIdToken`) y la
sesión se crea igual que antes. El usuario llega al mismo sitio: la pantalla de
bienvenida, o el panel si ya la completó.

**El código ya está en GitHub** (commit `7a64979`). Lo que falta es solo
configuración.

**Dónde está en el código:**

- `src/components/ui/BotonGoogle.tsx`: elige qué botón se muestra, según la variable `GOOGLE_CLIENT_ID`.
- `src/components/ui/BotonGoogleOficial.tsx`: el botón de Google y el nonce.
- `src/app/auth/google-actions.ts` → `entrarConTokenDeGoogle`: el canje del login en el servidor.

**Red de seguridad.** Sin la variable `GOOGLE_CLIENT_ID` en Railway, o si el
script de Google no carga, sale el botón de siempre y todo sigue funcionando.

---

## Paso 0 · Activar la verificación en 2 pasos en tu cuenta de Google

Desde el 23 de septiembre de 2026, Google Cloud **bloquea la consola** a las
cuentas sin verificación en 2 pasos (2SV). Sin esto no se pueden hacer los
pasos 2 y 3.

1. Entra en **myaccount.google.com** con la cuenta dueña del proyecto `savedocumentos`.
2. Ve a **Seguridad** → **Verificación en 2 pasos** → **Empezar**.
3. Elige el segundo factor. Lo más cómodo es la notificación en el teléfono (**Mensajes de Google**) o una app de códigos (Google Authenticator). El SMS funciona, pero es el más débil.
4. **Descarga los códigos de respaldo** (Seguridad → Verificación en 2 pasos → Códigos de respaldo) y guárdalos fuera del ordenador. Si pierdes el teléfono, son la única forma de volver a entrar.
5. Espera unos minutos y **recarga** `console.cloud.google.com`. Google avisa de que el desbloqueo puede tardar un poco después de activar la verificación.

---

## Paso 1 · Confirmar que Railway está estable

Entra en **status.railway.com**. Si el aviso *"API degradation causing slow or
stuck deployments"* sigue abierto, espera a que diga **Resolved**. El paso 5
dispara un despliegue, y con Railway degradado se quedaría atascado.

Los pasos 2, 3 y 4 **no dependen de Railway**: se pueden hacer antes.

---

## Paso 2 · Publicar la app de Google

1. Abre `console.cloud.google.com/auth/audience?project=savedocumentos` y confirma arriba que el proyecto es **savedocumentos**.
2. En **Estado de publicación** pulsa **Publicar app** y luego **Confirmar**. El estado debe cambiar a **En producción**.
3. **No subas el logo.** Con la app publicada, subir el logo la manda a revisión de Google.

Sin este paso, cualquier persona que no seas tú recibe **"Acceso bloqueado"**,
tanto con el botón nuevo como con el viejo. Como solo se piden `email` y
`profile`, publicar no dispara ninguna revisión. Se revierte con **Volver a prueba**.

---

## Paso 3 · Autorizar savedocumentos.com en el cliente de Google

1. Ve a `console.cloud.google.com/auth/clients?project=savedocumentos`.
2. Abre el **cliente web** cuyo ID empieza por `831677785685-`.
3. En **Orígenes de JavaScript autorizados** pulsa **Agregar URI** y escribe exactamente `https://savedocumentos.com`, sin barra al final y sin `www`.
4. Pulsa **Guardar**.

**No toques los "URI de redireccionamiento autorizados"**: el botón de siempre
los necesita como respaldo. Google avisa de que el cambio puede tardar desde
5 minutos hasta unas horas.

---

## Paso 4 · Comprobar Supabase (no se cambia nada)

En el panel de Supabase ve a **Authentication → Sign In / Providers → Google** y comprueba dos cosas:

- El campo **Client ID** contiene `831677785685-t60h8mb853a0pav4smnm9265rehn1gc9.apps.googleusercontent.com`.
- **Skip nonce checks** está **DESACTIVADO**. El botón nuevo envía el nonce, y esa comprobación es la que impide reutilizar un token robado.

Si todo está así, cierra sin guardar.

---

## Paso 5 · Añadir la variable en Railway

Servicio → **Variables** → **New Variable**:

| Nombre | Valor |
|---|---|
| `GOOGLE_CLIENT_ID` | `831677785685-t60h8mb853a0pav4smnm9265rehn1gc9.apps.googleusercontent.com` |

- **Sin** el prefijo `NEXT_PUBLIC_`: el servidor la lee en cada visita.
- Es el **ID público**, no el secreto. El secreto sigue guardado solo en Supabase y **no se pega en ninguna parte**.
- Guarda y espera a que el despliegue salga en verde (**Deployments → Active**).

---

## Paso 6 · Probar con otra cuenta

1. Abre una ventana de **incógnito** y entra en `savedocumentos.com/register`.
2. El botón debe verse con el diseño oficial de Google, ligeramente distinto del de antes.
3. Púlsalo y elige una cuenta de Google que **no** sea la tuya.
4. **Haz una captura de la ventana de Google**: queremos ver si dice `savedocumentos.com` o "Save Documentos" en lugar del dominio de Supabase. Todavía **NO VERIFICADO** qué texto sale exactamente.
5. Debes llegar a la **pantalla de bienvenida**.
6. Repite en `savedocumentos.com/login` con tu cuenta: como ya completaste la bienvenida, debe llevarte **directo al panel**.

Dos cosas más que mirar: si el botón se ve bien en el móvil, y en modo oscuro.
Google lo dibuja con su propio diseño, que no se adapta al modo oscuro.

---

## Paso 7 · Si algo falla, volver atrás

- En Railway **borra la variable `GOOGLE_CLIENT_ID`**. Al redesplegar vuelve el botón de siempre, sin tocar código.
- Si aparece *"No pudimos entrar con Google"*, apunta la hora y revisa el log de Railway de ese momento. El servidor registra ahí el motivo, sin guardar el token.

---

## Cuando todo funcione

- Actualizar `CONTEXTO-SAVE.txt` (sección 4) y la auditoría: de **PENDIENTE** a **VERIFICADO**, con la captura como prueba.
- Después, si se quiere, subir el logo en la pantalla de marca. Eso **sí** manda la app a verificación de Google, y tarda unos días hábiles.
