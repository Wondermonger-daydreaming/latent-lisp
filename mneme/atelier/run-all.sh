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

# ── Jurisdiction wing (GPT's relay packet §1–§2, received 2026-07-11) ──
# Added as a MODE, not a fork: the six-specimen loop above is untouched and
# resolves byte-for-byte as before. These two instruments run afterward.
instruments=(
  "$ROOT/instruments/receipt-of-search.lisp"
  "$ROOT/instruments/de-limine.lisp"
)
for file in "${instruments[@]}"; do
  printf '\n===== %s =====\n' "$(basename "$file")"
  sbcl --script "$file"
done
printf '\nBoth jurisdiction instruments passed.\n'
