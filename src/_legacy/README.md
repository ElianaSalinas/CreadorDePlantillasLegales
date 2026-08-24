# Código apartado

Todo lo que hay en esta carpeta viene de la aplicación React/Vite anterior a
la migración a Next.js. **No está conectado a nada**: ninguna ruta bajo
`src/app` lo importa, y `tsconfig.json` lo excluye de la compilación.

Se conserva como referencia mientras se construye el motor documental nuevo
sobre Supabase. Cada pieza se irá retirando cuando su sustituta esté lista.

## Qué hay aquí

| Carpeta | Qué contiene | Estado |
|---|---|---|
| `core/` | Motores de variables, cláusulas, reglas, detección y exportación | Referencia para la Fase 2 |
| `store/` | Estado global artesanal sobre `localStorage` | Se descarta; ahora manda Supabase |
| `components/` | Interfaz completa de la app anterior | Referencia visual |
| `types.ts` | Modelo de datos en memoria | Sustituido por el esquema relacional |

## Advertencias

No copies nada de aquí sin leer la auditoría primero. Hay tres cosas que
aparentan funcionar y no funcionan:

1. La biblioteca de cláusulas copia la cláusula dentro de cada plantilla en
   vez de referenciarla, así que editarla no propaga a ninguna otra.
2. El constructor de reglas ofrece dos opciones que no existen en el código
   y nunca se disparan.
3. Las versiones de ejemplo guardan copias vacías: restaurar una borra la
   plantilla.

Lo que sí vale la pena portar: los validadores dominicanos de cédula y RNC,
los montos a letras, las fechas notariales, los generadores de Word y PDF,
y la revisión de calidad que bloquea publicar una plantilla incompleta.
