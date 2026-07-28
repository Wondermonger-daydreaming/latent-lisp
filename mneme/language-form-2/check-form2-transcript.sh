#!/usr/bin/env bash
#
# check-form2-transcript.sh — reconcile the captures against themselves.
#
# A PURE FUNCTION OF THE CAPTURES.  It re-executes nothing, so it cannot
# disagree with the run by running a different one.  It recomputes each suite's
# tally FROM THE RENDERED VERDICT LINES and compares that to the footer the
# suite printed — because a footer is a claim and the verdict lines are the
# evidence.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE"

fail=0
report=""

reconcile () {
  local label="$1" file="$2"
  if [ ! -f "$file" ]; then report+="  MISSING  ${file}\n"; fail=1; return; fi
  local ok bad total footer_pass footer_fail
  ok=$(grep -cE '^\s*\[[0-9]+\] ok ' "$file" || true)
  bad=$(grep -cE '^\s*\[[0-9]+\] FAIL ' "$file" || true)
  total=$((ok + bad))
  # Extract the number that PRECEDES "checks passed".  An earlier draft matched
  # the label first and then took the first digit run — which grabbed the "2" in
  # "form2-selftest".  The reconciler caught it by disagreeing with the verdict
  # lines, which is exactly what deriving from verdicts rather than footers is for.
  footer_pass=$(grep -oE '[0-9]+ checks passed' "$file" | grep -oE '^[0-9]+' | head -1 || true)
  footer_fail=$(grep -oE '/ [0-9]+ failed' "$file" | grep -oE '[0-9]+' | head -1 || true)
  report+="  ${label}\n"
  report+="    rendered verdict lines : ${ok} ok · ${bad} FAIL · ${total} total\n"
  report+="    footer claims          : ${footer_pass:-?} passed · ${footer_fail:-?} failed\n"
  if [ "${ok}" != "${footer_pass:-x}" ] || [ "${bad}" != "${footer_fail:-x}" ]; then
    report+="    !! MISMATCH — the footer does not equal the rendered verdicts\n"; fail=1
  else
    report+="    reconciled\n"
  fi
}

reconcile "form2-selftest"  RUN-SELFTEST.txt
reconcile "de-forma-mutata" RUN-APPLICATION.txt

{
  echo
  echo "  FORM /2 TRANSCRIPT RECONCILIATION"
  echo "  counts are derived from RENDERED VERDICT LINES, never from a footer alone"
  echo
  printf "%b" "$report"
  if [ -f RUN-EXITCODES.txt ]; then echo; sed 's/^/    /' RUN-EXITCODES.txt; fi
  echo
  if [ $fail -eq 0 ]; then echo "  RECONCILIATION CLEAN"; else echo "  !! RECONCILIATION FAILED"; fi
  echo
} | tee RUN-TRANSCRIPT-CHECK.txt

exit $fail
