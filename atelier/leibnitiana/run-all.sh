#!/usr/bin/env bash
# run-all.sh — run every Leibnitiana file under SBCL from its own directory.
#
# Each file loads src/package.lisp + src/core.lisp via *load-truename*, so the
# relative loads resolve no matter the caller's cwd; we still `cd` into each
# file's directory to honour the atelier convention (scripts run from home).
#
# Prints per-file PASS/FAIL; exits nonzero if ANY file fails.
# Convention of the tree: exit 0 == the law holds.
set -uo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"

files=(
  "tests/smoke.lisp"
  "specimens/de-dyadica.lisp"
  "specimens/de-monadibus.lisp"
  "specimens/de-compossibilitate.lisp"
  "specimens/de-harmonia.lisp"
  "specimens/de-fenestris.lisp"
  "storms/hidden-operator.lisp"
  "storms/false-harmony.lisp"
)

fail=0
for rel in "${files[@]}"; do
  dir="$ROOT/$(dirname "$rel")"
  base="$(basename "$rel")"
  if ( cd "$dir" && sbcl --script "$base" ) >/dev/null 2>&1; then
    printf 'PASS  %s\n' "$rel"
  else
    printf 'FAIL  %s\n' "$rel"
    fail=1
  fi
done

if [ "$fail" -eq 0 ]; then
  printf '\nAll %d Leibnitiana files passed.\n' "${#files[@]}"
else
  printf '\nLeibnitiana: one or more files FAILED.\n'
fi
exit "$fail"
