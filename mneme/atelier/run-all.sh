#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
files=(
  "$ROOT/reliquaries/de-testimonio-postumo.lisp"
  "$ROOT/toys/notarius-mustela.lisp"
  "$ROOT/instruments/speculum-bifrons.lisp"
  "$ROOT/toys/ambulatorium-himma.lisp"
  "$ROOT/reliquaries/museum-nocturnum.lisp"
  "$ROOT/toys/oraculum-quinque-oris.lisp"
)
for file in "${files[@]}"; do
  printf '\n===== %s =====\n' "$(basename "$file")"
  sbcl --script "$file"
done
printf '\nAll six Atelier specimens passed.\n'
