#!/usr/bin/env bash
# precure.sh — Phase 0: show the laundering BEFORE it is cured.
#   bash precure.sh <plant-tree-subject-root> <out-dir>
# Uses the UNREPAIRED verify-release.sh as it stands in the plant tree, reduced to a
# 5-row REAL subset of its own authorized table by mkvariant.sh (confinement proven).
set -uo pipefail
PT="${1:?plant tree subject root}"; OUT="${2:?out dir}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$OUT"
ORIG="$OUT/verify-release.ORIGINAL.sh"
cp "$PT/mneme/verify-release.sh" "$ORIG"

run_case() {
  local name="$1" desc="$2" plant="$3" unplant="$4"
  local t="$OUT/$name.transcript.txt"
  bash "$HERE/mkvariant.sh" "$ORIG" "$HERE/rows-reduced.txt" "$PT/mneme/verify-release.sh" > "$OUT/$name.variant.txt" 2>&1
  {
    echo "=== PRE-CURE CONTROL: $name"
    echo "=== $desc"
    echo "=== aggregator : the UNREPAIRED verify-release.sh, reduced to a 5-row REAL subset"
    echo "===              of its own table (mkvariant confinement proof below); the classifier,"
    echo "===              materializer, cleanliness probes and terminal gate are byte-identical"
    echo "===              to the unrepaired full-table script."
    echo "=== plant      : $plant"
    echo "=== venue      : $PT  (history-complete clone)"
    echo "=== date       : $(date -u +%FT%TZ)"
    echo
    cat "$OUT/$name.variant.txt"
    echo
    echo "=== RUN ==="
  } > "$t"
  eval "$plant"
  ( cd "$PT" && bash mneme/verify-release.sh ) >> "$t" 2>&1
  echo "=== aggregator exit: $?" >> "$t"
  eval "$unplant"
  cp "$ORIG" "$PT/mneme/verify-release.sh"
  echo "--- $name -> $(grep -m1 '^FLOOR RESULT' "$t")"
}

run_case "A-missing-python-gate" \
  "a floor row's python3 script is absent from the subject tree" \
  "mv '$PT/mneme/atelier/static-check.py' '$OUT/static-check.py.parked'" \
  "mv '$OUT/static-check.py.parked' '$PT/mneme/atelier/static-check.py'"

run_case "B-subject-digest-absent-manifest" \
  "subject-digest.sh HARD FAILs over an absent manifest (its EXPECT is a literal sha256 that is NOT in the log)" \
  "mv '$PT/mneme/language-surface-1/errata-0.3/SUBJECT-MANIFEST.txt' '$OUT/SUBJECT-MANIFEST.txt.parked'" \
  "mv '$OUT/SUBJECT-MANIFEST.txt.parked' '$PT/mneme/language-surface-1/errata-0.3/SUBJECT-MANIFEST.txt'"
