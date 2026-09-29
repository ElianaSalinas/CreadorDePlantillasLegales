# Auditoría de acentos rotos (mojibake) — SAVE Documentos

Fecha: 29 de septiembre de 2026 · Repo auditado: `main` en `1c0b89e` (equipo de la usuaria, solo lectura) · Alcance: todo el árbol de trabajo salvo `node_modules`, `.next`, `.git`, `.tmp-*`, `_to_delete` y `Claude outputs` (estas carpetas se revisaron aparte: 0 hallazgos), y además **todas las versiones de todos los archivos en todo el historial git** (194 commits, incluidas las ramas `origin/sandbox/*` y `refs/original`).

No se modificó ningún archivo del equipo, no se hizo ningún commit y no se creó ningún `.git/*.lock` (comprobado al final). El único cambio en `git status` es `M docs/SAVE-AUDITORIA-INTEGRAL.md`, que ya estaba así antes de empezar.

---

## 1. Resumen ejecutivo

- **Hay 2 archivos realmente rotos** en `main`:
  - `src/app/app/clauses/actions.ts`: 17 líneas, **en producción desde el 14 sep (commit `de11569`)**. Tiene 11 líneas con **mensajes que ve el usuario** (errores y avisos de la pantalla Cláusulas), 3 con **descripciones que se graban en `audit_logs`** y 3 comentarios.
  - `docs/planificacion/12-PLAN-FINAL.md`: 385 de 889 líneas, desde el 16 sep (commit `f8af846`). Es solo documentación.
- **Hay 2 falsos positivos**, que citan el mojibake a propósito para explicarlo y no hay que tocar: `scripts/fix-mojibake.mjs` y `docs/SAVE-AUDITORIA-INTEGRAL.md`.
- **Limpios, comprobado**: `src/lib/engine/*`, que es el motor de los documentos legales, `scripts/catalog/*`, `docs/cartas-para-revision.md`, **todas las migraciones `supabase/migrations/*.sql` en todas sus versiones históricas**, los correos, la metadata y el SEO. También está limpio el resto de `src/`.
- **Riesgo en la base de datos**:
  - El catálogo (plantillas y cláusulas) **no** está afectado, porque ninguna migración tuvo nunca mojibake. No hace falta una migración correctiva.
  - Sí puede haber texto roto en **`audit_logs.description`**. Viene de dos épocas:
    1. Desde el 14 sep hasta hoy: `ClÃ¡usula creada/editada/… eliminada` (acciones `CLAUSE_CREATED`, `CLAUSE_EDITED`, `CLAUSE_DELETED`).
    2. Un episodio anterior, **ya corregido en código** el 1 sep (commit `2c17c14`): entre el 22 ago y el 1 sep se grabaron `bÃ³veda` en `VAULT_UPLOAD`, `VAULT_DELETE` y `ADMIN_LIMITS_UPDATED`.
  - El audit log es inmutable, así que **esas filas no se reescriben**. Se proponen una lectura corregida y una fila de nota (sección 4). El número real de filas afectadas está **NO VERIFICADO**, porque no hay acceso a la base.
- **Copias corregidas preparadas y verificadas**: `actions.ts` y `12-PLAN-FINAL.md`, más un `fix-mojibake.mjs` reescrito que también sirve de `verify:acentos`, un `package.json` con ese script y un `.editorconfig`.
  - La copia de `actions.ts` es **byte a byte idéntica** a "versión limpia `e58b266` + los cambios reales de `de11569`". Esto se verificó con git en el equipo; los sha256 coinciden.
- **Causa raíz (hipótesis)**: ediciones hechas con **Windows PowerShell 5.1** (`Get-Content` sin `-Encoding` → `Set-Content -Encoding UTF8`). La firma es exacta: **mojibake cp1252 + BOM**, y solo aparece en esos commits. Ya pasó una vez (22 ago, corregido el 1 sep) y se ha repetido dos veces.

---

## 2. Tabla por archivo

| Archivo | Líneas afectadas | Commit que lo rompió | Versión anterior | Impacto | Arreglo propuesto | Copia preparada |
|---|---|---|---|---|---|---|
| `src/app/app/clauses/actions.ts` | 17 de 188 (+ BOM) | `de11569` (14 sep 2026 09:19, subido 09:19:55) | `e58b266`: limpia, sin BOM | **(a)** 11 líneas de error/aviso que se ven en la UI (`ClausesClient.tsx:136` muestra `result.error` / `result.notice`) · **(b)** 3 descripciones que van a `audit_logs` · (d) 3 comentarios | Restaurar desde `e58b266` + reaplicar el cambio real de `de11569`. Da exactamente lo mismo que la reversión cp1252 por secuencia; verificado, sha256 idéntico | **Sí** |
| `docs/planificacion/12-PLAN-FINAL.md` | 385 de 889 (+ BOM) | `f8af846` (16 sep 2026 16:06) | `dc36d1b`: limpia, sin BOM | **(c)** solo documentación | Reversión cp1252 por secuencia (2, 3 y 4 bytes, emojis incluidos). El resultado difiere de `dc36d1b` solo en 3 líneas añadidas (`---` y líneas en blanco) + 1 salto final, que es todo el cambio real de `f8af846` en este archivo | **Sí** |
| `scripts/fix-mojibake.mjs` | 1 (comentario de ejemplo) + 1 regex con `Ã` | `1c0b89e` (intencional) | — | (d) falso positivo | No es mojibake accidental. Sí hay que **reescribir el script** porque da falso negativo (sección 5) | **Sí** (versión nueva) |
| `docs/SAVE-AUDITORIA-INTEGRAL.md` | 2 (citas de ejemplo) | cambio sin commit (ya estaba así) | — | (c) falso positivo | No tocar: cita el problema | No aplica |
| `src/app/app/clauses/ClausesClient.tsx` | 18 **en `de11569`**, 0 hoy | `de11569` | limpio en `f59f603` | (a) UI de Cláusulas **durante ~64 min** (09:19:55 → 10:23:47 del 14 sep) | Ya corregido en `26b50f7` (reescritura sin BOM) | No hace falta |
| `src/app/app/admin/actions.ts`, `vault/actions.ts`, `dashboard/page.tsx`, `vault/page.tsx` | 8 / 5 / 5 / 4 entre el 22 ago y el 1 sep, 0 hoy | `df93579` (22 ago) | — (archivos nuevos) | (a) UI + **(b) `audit_logs`** con `bÃ³veda` | Código ya corregido en `2c17c14` (1 sep). Quedan las filas históricas (sección 4) | No hace falta |

Detalle de `actions.ts` (líneas actuales):
- **UI**:
  - l. 11 `NO_PERMISSION`
  - l. 29, 30, 74, 75: "La clÃ¡usula necesita un tÃ­tulo / un texto"
  - l. 52: "Ya tienes una clÃ¡usula con ese tÃ­tulo"
  - l. 65, 99: avisos de creada/actualizada
  - l. 127–128: "ClÃ¡usula eliminada. Se retirÃ³ de…"
  - l. 144: "No se encontrÃ³ la clÃ¡usula"
- **audit_logs**: l. 61, 95, 120 (`ClÃ¡usula creada:` / `ClÃ¡usula editada:` / `ClÃ¡usula <id> eliminada`).
- **Comentarios**: l. 107, 131, 166.
- **Sin cambios**: los valores de familia (`Económicas`, `Tecnología`) se mudaron a `src/lib/engine/clauseFamilies.ts`, que está limpio aunque también tiene BOM. Por eso `clauses.family` no se contaminó.

Observación sobre `f8af846`: el mensaje dice "plan actualizado con Fase 13", pero una vez quitado el mojibake el único cambio de contenido en el plan es un separador `---`. La cadena "Fase 13" no aparece en el plan ni antes ni después. Puede que el texto previsto se perdiera en la edición, o que viva en `docs/planificacion/fase13.md` (NO VERIFICADO).

---

## 3. Verificaciones hechas sobre las copias

- **Sin residuo**: ninguna línea de las copias contiene `Ã`, `Â`, `â€`, `â†`, `U+FFFD` ni la secuencia `Ã`+`U+0081` (una `Á`, que es la línea que fallaba con `encode('cp1252')`, porque 0x81 no existe en cp1252).
- **Diff mínimo**: en ambas copias las líneas cambiadas son exactamente las líneas con mojibake (17 y 385), más la eliminación del BOM en la línea 1. Para cada línea cambiada, volver a "romper" la versión corregida (UTF-8 → cp1252) reproduce **exactamente** la línea original. Así que no se tocó nada más: cero líneas no reversibles.
- **`actions.ts` (.ts)**: el diff son 17 líneas, todas literales de string (14) o comentarios (3). No cambia ningún identificador ni ningún import.
- **Contra git (en el equipo)**:
  - `fix(actions.ts de HEAD)` = `e58b266` + import de `CLAUSE_FAMILIES` − bloque `export const CLAUSE_FAMILIES` + 2 líneas en blanco finales, que es todo el cambio de `de11569`.
  - `fix(12-PLAN de HEAD)` = `fix(blob f8af846)`.
  - Los sha256 del contenedor y del equipo coinciden:
    - `actions.ts`: `de422ed6…d214f6`
    - `12-PLAN-FINAL.md`: `8eada198…854c62`
- **Finales de línea**: las copias conservan los CRLF del disco (con `* text=auto` git los normaliza a LF al hacer commit).
- **Script nuevo**:
  - `node scripts/fix-mojibake.mjs` sobre los originales detecta 2 archivos (17 y 385 líneas) y sale con código 1.
  - Sobre las copias da 0 y sale con código 0.
  - `--write` sobre una copia de prueba produce **los mismos sha256** que las copias preparadas.
- **Barrido completo del repo en el equipo** con el mismo algoritmo: solo cambiarían esos 2 archivos + los 2 falsos positivos (que el script nuevo excluye con una lista `ALLOW`).

---

## 4. SQL borrador para Supabase (NO ejecutado; solo borrador)

Regla: **`audit_logs` es inmutable** (no hay políticas UPDATE/DELETE: "Sin UPDATE ni DELETE a propósito" en `20260822000000_orgs_roles_and_admin_rbac.sql`). Desde el SQL Editor o con service_role técnicamente se podría hacer UPDATE, pero **no debe hacerse**. **No se toca ninguna fila de `audit_logs`**, y en particular ninguna de estas:
- `action IN ('CLAUSE_CREATED','CLAUSE_EDITED','CLAUSE_DELETED')` con `timestamp >= '2026-09-14 13:19:55+00'`
- `action IN ('VAULT_UPLOAD','VAULT_DELETE','ADMIN_LIMITS_UPDATED')` entre `2026-08-23 01:21+00` y `2026-09-01 ~15:00+00`

Las migraciones **no** necesitan corrección: ninguna tuvo mojibake nunca, así que no hace falta una migración nueva para el catálogo.

```sql
-- ============ 1) DIAGNÓSTICO (solo lectura) ============
-- Filas del historial con texto roto, por acción y periodo
SELECT action, count(*) AS filas, min("timestamp") AS primera, max("timestamp") AS ultima
FROM audit_logs
WHERE description ~ '(Ã[\u0080-¿]|Â[ -¿]|â€)'
GROUP BY action ORDER BY filas DESC;

-- Contenido editable que pudiera haberse contaminado (no esperado: el catálogo sale limpio)
SELECT 'clauses' AS tabla, count(*) FROM clauses
 WHERE (title || ' ' || coalesce(description,'') || ' ' || body || ' ' || family) ~ '(Ã[\u0080-¿]|â€)'
UNION ALL
SELECT 'template_sections', count(*) FROM template_sections
 WHERE (title || ' ' || coalesce(body,'')) ~ '(Ã[\u0080-¿]|â€)'
UNION ALL
SELECT 'templates', count(*) FROM templates
 WHERE (title || ' ' || category) ~ '(Ã[\u0080-¿]|â€)';

-- ============ 2) LECTURA CORREGIDA SIN TOCAR LOS DATOS ============
-- Solo reemplaza los tokens fijos que salieron del código, nunca el texto que escribió el usuario
-- (p. ej. el título de la cláusula tras "creada: ", que llegó bien codificado).
-- (Borrador: iría en una migración NUEVA, p. ej. 20260930000000_audit_logs_lectura_acentos.sql)
CREATE OR REPLACE FUNCTION public.audit_description_legible(d text)
RETURNS text LANGUAGE sql IMMUTABLE AS $$
  SELECT replace(replace(d, 'ClÃ¡usula', 'Cláusula'), 'bÃ³veda', 'bóveda')
$$;

CREATE OR REPLACE VIEW public.audit_logs_legible
WITH (security_invoker = true) AS   -- respeta la RLS de audit_logs
SELECT id, org_id, user_id, document_id, action,
       public.audit_description_legible(description) AS description,
       description AS description_original,
       "timestamp"
FROM audit_logs;

-- ============ 3) (Opcional) DEJAR CONSTANCIA EN EL PROPIO HISTORIAL ============
-- Una fila NUEVA por despacho afectado; no modifica ninguna existente.
-- INSERT INTO audit_logs (org_id, user_id, action, description)
-- SELECT DISTINCT org_id, '<uuid-del-admin-SAVE>'::uuid, 'SYSTEM_NOTE',
--        'Nota: entradas anteriores con "ClÃ¡usula"/"bÃ³veda" = "Cláusula"/"bóveda" (error de codificación del código, corregido el <fecha>).'
-- FROM audit_logs WHERE description ~ '(ClÃ¡usula|bÃ³veda)';
```

Hoy ninguna pantalla lee `audit_logs` (solo lo hace `src/_legacy`), así que el texto roto solo se vería en el panel de Supabase o en exportaciones. La vista sirve para cuando se construya la pantalla de historial.

---

## 5. `scripts/fix-mojibake.mjs`: por qué falla y cómo queda

El script actual da **"0 archivo(s) con mojibake detectado"** en el repo real (ejecutado en modo solo lectura), por cuatro motivos:
1. **Solo recorre `src/` y `scripts/`**, así que no ve `docs/`.
2. **Usa `latin1`, no cp1252**. `€`, `”`, `—` y `™` (U+20AC, U+201D…) no caben en latin1: `Buffer.from(text,'latin1')` los trunca a un byte incorrecto, sale `U+FFFD` y se descarta el archivo.
3. **Convierte el archivo entero**. El BOM (U+FEFF → 0xFF) o cualquier carácter sano fuera de latin1 (`—`, emojis, `→`) produce `U+FFFD`, y el archivo mixto se descarta. Por esto mismo `actions.ts` sale como falso negativo.
4. No quita el BOM ni devuelve un código de salida útil para CI.

Versión nueva (copia en `acentos-arreglados/scripts/fix-mojibake.mjs`):
- Recorre todo el repo con las mismas exclusiones y más extensiones (`.txt`, `.css`, `.html`, `.ps1`, `.yml`, `.toml`, `.svg`…).
- Usa la tabla cp1252 explícita, con los 5 huecos tratados como en Windows.
- Corrige **por secuencia** (2, 3 o 4 caracteres que forman UTF-8 válido) línea a línea, sin tocar lo sano.
- Quita el BOM e informa de las líneas afectadas.
- **Sale con código 1** si detecta algo, así que sirve directamente como `npm run verify:acentos`.
- Excluye por lista `ALLOW` los dos documentos que citan el problema.

---

## 6. Causa raíz probable (HIPÓTESIS)

Indicios comprobados:
- Los tres episodios tienen la misma firma: mojibake **cp1252** (no latin1).
- Los dos recientes, además, dejan **BOM UTF-8**. Solo 3 archivos del repo tienen BOM (`12-PLAN-FINAL.md`, `clauses/actions.ts`, `engine/clauseFamilies.ts`), y los tres vienen de `de11569` o `f8af846`.
- En disco, esos 3 archivos tienen CRLF, como los que se editan desde Windows.
- `de11569` y `f8af846` son commits de la usuaria desde su equipo (zona −0400), **sin** trailer `Co-Authored-By`. No coinciden con commits de sesiones de asistente: `dc36d1b`, autor "Claude", dejó el plan limpio.
- El mensaje de `2c17c14` (1 sep) ya atribuía el primer episodio a archivos "escritos desde PowerShell con la codificación equivocada".
- En `de11569`, `ClausesClient.tsx` también quedó con BOM y mojibake. Se reescribió 64 min después en `26b50f7` y quedó bien, pero `actions.ts` no se volvió a tocar.
- No hay `.editorconfig` ni `files.encoding` en `.vscode/settings.json`. `.gitattributes` solo controla los finales de línea, no la codificación. Ningún `.ps1` del repo usa `Set-Content`, `Out-File` ni `Get-Content`, así que la edición se hizo a mano o fuera de los scripts versionados.

Hipótesis: en Windows PowerShell 5.1, un `(Get-Content archivo) -replace … | Set-Content archivo -Encoding UTF8`, o un editor/terminal equivalente:
- `Get-Content` sin `-Encoding` lee un UTF-8 **sin BOM** como ANSI (cp1252). Cada `á` (C3 A1) pasa a ser `Ã¡`.
- `Set-Content -Encoding UTF8` lo vuelve a escribir en UTF-8 **con BOM**.

Eso reproduce exactamente lo observado, incluido que toda línea con acentos del archivo quedó rota y que el cambio "real" era pequeño (mover `CLAUSE_FAMILIES`; añadir un `---`).

---

## 7. Prevención

1. Añadir `"verify:acentos": "node scripts/fix-mojibake.mjs"` (copia de `package.json` preparada; es una sola línea de diff) y ejecutarlo en CI (`.github/workflows`) y/o en un hook `pre-commit`.
2. Añadir `.editorconfig` con `charset = utf-8` (copia preparada) y en `.vscode/settings.json` `"files.encoding": "utf8"`, `"files.autoGuessEncoding": false`.
3. En PowerShell: usar siempre `Get-Content -Raw -Encoding UTF8` y escribir con `[IO.File]::WriteAllText($p, $txt, [Text.UTF8Encoding]::new($false))` (UTF-8 sin BOM), o usar PowerShell 7 (`pwsh`), cuyo valor por defecto es UTF-8 sin BOM.
4. Opcional: en el CI, que falle si algún archivo empieza por BOM (`EF BB BF`).

---

## 8. Cómo aplicar (cuando se decida; NO aplicado)

Copiar desde `/mnt/user-data/outputs/acentos-arreglados/` sobre el repo:
- `src/app/app/clauses/actions.ts`
- `docs/planificacion/12-PLAN-FINAL.md`
- `scripts/fix-mojibake.mjs`
- `package.json`
- `.editorconfig`

Después ejecutar `npx tsc --noEmit`, `npm run verify:acentos` (debe dar 0) y `git diff --stat`. El SQL de la sección 4 es solo un borrador que se revisa antes de nada. `_reparar-mojibake.py` es el reparador en Python usado para generar las copias (equivalente al script Node).

---

## 9. NO VERIFICADO

- Número real de filas con mojibake en `audit_logs` (y si hay alguna en `clauses`, `templates` o `template_sections` por contenido que haya tecleado alguien). No hay acceso a la base; las consultas de diagnóstico están en la sección 4.
- Que Railway desplegara cada push de forma automática. Por eso no está confirmado que la UI rota de `ClausesClient.tsx` llegara a servirse en esos ~64 min, ni que la de `actions.ts` esté hoy en producción, aunque `de11569` está en `origin/main` desde el 14 sep.
- Que la herramienta concreta fuera PowerShell 5.1 (la firma encaja, pero es una hipótesis).
- Que el "plan actualizado con Fase 13" de `f8af846` tuviera contenido que se perdió.
- `tsc --noEmit` con la copia de `actions.ts` no se ejecutó (no se podía hacer `npm install` ni escribir en el repo). El diff son solo strings y comentarios, así que el riesgo es nulo en la práctica.
- No se revisaron `.env` ni `.env.local` (excluidos a propósito), ni los binarios (`.docx`, `.pdf`, imágenes).
