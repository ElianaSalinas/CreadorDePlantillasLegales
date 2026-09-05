#!/usr/bin/env bash
#
# Devuelve a Eliana la autoría de sus propios commits.
#
# QUÉ PASÓ
#
# Del 22 de agosto en adelante, 40 commits quedaron firmados con
# eliana@example.com, una dirección de relleno que no existe. GitHub
# atribuye las contribuciones por el correo del autor, comparándolo con
# los correos verificados de la cuenta: al no encontrar ninguno, esos
# commits no cuentan y la gráfica de actividad sale vacía.
#
# QUÉ HACE ESTE GUION
#
# Cambia el autor de esos 40 commits al correo bueno, CONSERVANDO las
# fechas originales —de autoría y de commit, con su hora y su zona—,
# que es lo que hace que la gráfica se rellene en los días correctos y
# no todos hoy.
#
# ANTES DE NADA guarda el estado actual en refs/respaldo/, que queda
# fuera de refs/heads y refs/tags y por eso el filtro no lo toca. Si
# algo sale mal, se vuelve con:
#
#   git reset --hard refs/respaldo/antes-de-reescribir
#
# CÓMO SE LANZA
#
#   Abre Git Bash en la carpeta del proyecto y escribe:
#     bash scripts/reescribir-autor.sh
#
set -euo pipefail

VIEJO="eliana@example.com"
NOMBRE="Eliana Stephania Montero Salinas"
NUEVO="stephaniamontero84@gmail.com"

cd "$(git rev-parse --show-toplevel)"

echo "== Commits con el correo de relleno: $(git log --author="$VIEJO" --oneline | wc -l)"

# filter-branch se niega a trabajar con cambios sin guardar. Los que hay
# son ruido de finales de línea más next-env.d.ts, que Next regenera,
# pero se guardan igual en vez de descartarlos.
GUARDADO=0
if [ -n "$(git status --porcelain --untracked-files=no)" ]; then
  echo "== Guardando los cambios del árbol de trabajo"
  git stash push -m "antes de reescribir el autor"
  GUARDADO=1
fi

echo "== Respaldo del estado actual"
git update-ref refs/respaldo/antes-de-reescribir HEAD
echo "   refs/respaldo/antes-de-reescribir -> $(git rev-parse --short HEAD)"

echo "== Reescribiendo"
FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f --env-filter "
if [ \"\$GIT_AUTHOR_EMAIL\" = \"$VIEJO\" ]; then
  export GIT_AUTHOR_NAME=\"$NOMBRE\"
  export GIT_AUTHOR_EMAIL=\"$NUEVO\"
fi
if [ \"\$GIT_COMMITTER_EMAIL\" = \"$VIEJO\" ]; then
  export GIT_COMMITTER_NAME=\"$NOMBRE\"
  export GIT_COMMITTER_EMAIL=\"$NUEVO\"
fi
" --tag-name-filter cat -- --branches --tags

if [ "$GUARDADO" = "1" ]; then
  echo "== Devolviendo los cambios del árbol de trabajo"
  git stash pop || echo "   (revísalos con: git stash list)"
fi

echo
echo "== Cómo queda el reparto de autores"
git log --pretty=format:'%ae' | sort | uniq -c | sort -rn
echo
echo "== Quedan con el correo de relleno: $(git log --author="$VIEJO" --oneline | wc -l)  (tiene que ser 0)"
echo
echo "Si te convence, sube la corrección con:"
echo "    git push --force-with-lease origin main"
echo
echo "Si algo no cuadra, se deshace con:"
echo "    git reset --hard refs/respaldo/antes-de-reescribir"
