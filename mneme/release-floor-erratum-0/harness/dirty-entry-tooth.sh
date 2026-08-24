#!/usr/bin/env bash
# dirty-entry-tooth.sh — RELEASE FLOOR ERRATUM /0 SUCCESSOR, Sol I requirement 4.
#
#   bash dirty-entry-tooth.sh <clone subject root> <out dir>
#
# One tracked subject file is modified; the dirt is left STABLE (nothing writes again);
# the EXACT successor script is run, UNMODIFIED, at its FULL 112-row authorized table --
# no reduced table, because the refusal happens at preflight and costs seconds.
#
# Required exhibits: CHECKOUT-NOT-CLEAN · NO GATE RAN · FLOOR RESULT: FAIL · nonzero exit.
set -uo pipefail
PT="${1:?clone subject root}"; OUT="${2:?out dir}"
mkdir -p "$OUT"
T="$OUT/13-dirty-entry.transcript.txt"
VICTIM="mneme/kernel0/kernel0-selftest.lisp"

{
  echo "==========================================================================="
  echo " ERRATUM /0 SUCCESSOR TOOTH 13 — a checkout that begins dirty and stays"
  echo " identically dirty must be refused, not called unchanged"
  echo "==========================================================================="
  echo " Sol I requirement 4 (disposition of 2026-08-23, 'stable dirt')"
  echo " subject   : the EXACT successor mneme/verify-release.sh, UNMODIFIED,"
  echo "             at its FULL 112-row authorized table (no reduced table: the"
  echo "             refusal is a preflight precondition and costs seconds)"
  echo " venue     : $PT"
  echo " HEAD      : $(git -C "$PT" rev-parse HEAD)"
  echo " script sha: $(sha256sum "$PT/mneme/verify-release.sh" | cut -d' ' -f1)"
  echo " date      : $(date -u +%FT%TZ)"
  echo
  echo "--- entry state, BEFORE the plant ---"
  echo " porcelain : $(git -C "$PT" status --porcelain | wc -l) entr(y|ies)"
  echo
  echo "--- the plant: ONE tracked subject file modified, then left alone ---"
  echo " victim    : $VICTIM"
} > "$T"

printf '\n;; ERRATUM/0 SUCCESSOR TOOTH 13 — planted stable dirt; not executed, never committed.\n' >> "$PT/$VICTIM"

{
  echo " porcelain after the plant:"
  git -C "$PT" status --porcelain | sed 's/^/     /'
  echo " blob now  : $(sha256sum "$PT/$VICTIM" | cut -d' ' -f1)"
  echo
  echo " NOTE: the dirt is STABLE.  Nothing in this tooth writes again; the tree the"
  echo " floor sees at entry is the tree it would see at exit.  Under the PREDECESSOR"
  echo " script this is exactly the shape that satisfied before==after and printed"
  echo " 'unchanged: zero tracked modifications, zero new untracked litter' — see the"
  echo " preserved pre-cure control at teeth/10-synthetic-extra-lane.transcript.txt."
  echo
  echo "=== RUN ==="
} >> "$T"

( cd "$PT" && bash mneme/verify-release.sh ) >> "$T" 2>&1
RC=$?
echo "=== aggregator exit: $RC" >> "$T"

{
  echo
  echo "--- the dirt is still there, unchanged, after the refusal ---"
  git -C "$PT" status --porcelain | sed 's/^/     /'
  echo
  echo "--- VERDICT ---"
  echo " exit code           : $RC   (required: nonzero)"
  echo " CHECKOUT-NOT-CLEAN  : $(grep -c 'CHECKOUT-NOT-CLEAN: the subject tree is not clean at entry' "$T") occurrence(s)"
  echo " NO GATE RAN         : $(grep -c 'NO GATE RAN' "$T") occurrence(s)"
  echo " executed row lines  : $(grep -c '^\[[0-9]\{3\}\]' "$T")   (required: 0)"
  echo " materialization line: $(grep -c 'materializing disposable tree copy' "$T")   (required: 0)"
  echo " terminal            : $(grep -m1 '^FLOOR RESULT' "$T")"
} >> "$T"

# restore
git -C "$PT" checkout -- "experiments/latent-lisp/$VICTIM" 2>/dev/null || git -C "$PT" checkout -- "$VICTIM"
echo "restored; porcelain now $(git -C "$PT" status --porcelain | wc -l) entr(y|ies)"
grep -E '^ (exit code|CHECKOUT-NOT-CLEAN|NO GATE RAN|executed row|materialization|terminal)' "$T"
