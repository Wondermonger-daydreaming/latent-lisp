#!/usr/bin/env bash
# run-all.sh — run every Leibnitiana file under SBCL from its own directory.
#
# Each file loads src/package.lisp + src/core.lisp (+ src/provenance.lisp where
# needed) via *load-truename*, so the relative loads resolve no matter the
# caller's cwd; we still `cd` into each file's directory to honour the atelier
# convention (scripts run from home).
#
# Prints per-file PASS/FAIL; RUNS EVERY FILE even if one fails; exits nonzero
# if ANY file fails. Convention of the tree: exit 0 == the law holds.
#
# Runner reconciliation (SARTOR-III, 2026-07-12): the landed runner's
# structure won over Sol's round-3 rewrite. Sol's version relied on `set -e`
# to abort on the first failing script, which is correct-on-exit-code but
# stops at the first failure and reports no per-file verdict. The landed
# structure runs the whole suite, prints a PASS/FAIL line per file, and still
# exits nonzero on any failure — and its teeth were verified by planted-fault
# in the first two landings (a bad file yields `FAIL` + exit 1). Sol's SBCL
# availability guard (exit 127) was the one improvement kept from his version.
#
# Round-4 extension (SARTOR-IV, 2026-07-12): same landed structure, coverage
# extended from 11 to 14 scripts (added tests/reload-provenance.lisp,
# specimens/de-speculo-publico.lisp, storms/council-process-ledger.lisp). Sol's
# round-4 rewrite (set -euo pipefail, abort-on-first, no per-file verdict) was
# again declined; the whole-suite PASS/FAIL teeth stand.
#
# Round-5 extension (SARTOR-V, 2026-07-12): same landed structure again — the
# 14 prior entries are byte-identical, four Hay/Lathe/Furnace/Tempering
# quadrivium specimens appended (decad/de-{foeno,torno,fornace,temperie}.lisp).
# The three furnace-family specimens load decad/../kernel/atelier-root.lisp
# (a byte-identical vendored copy of mneme/atelier/kernel/atelier-root.lisp, so
# the chamber does not reach into the author-gated mneme tree at runtime). A
# MODE, not a fork: no prior entry moved or changed.
set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v sbcl >/dev/null 2>&1; then
  echo "SBCL is required to run the Leibnitiana chamber." >&2
  exit 127
fi

files=(
  "tests/smoke.lisp"
  "tests/reload-provenance.lisp"
  "specimens/de-dyadica.lisp"
  "specimens/de-monadibus.lisp"
  "specimens/de-compossibilitate.lisp"
  "specimens/de-harmonia.lisp"
  "specimens/de-fenestris.lisp"
  "specimens/de-characteristica.lisp"
  "specimens/de-speculo-publico.lisp"
  "storms/hidden-operator.lisp"
  "storms/false-harmony.lisp"
  "storms/tampered-receipt.lisp"
  "storms/real-council-process.lisp"
  "storms/council-process-ledger.lisp"
  "decad/de-foeno.lisp"
  "decad/de-torno.lisp"
  "decad/de-fornace.lisp"
  "decad/de-temperie.lisp"
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
