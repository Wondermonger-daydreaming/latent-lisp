#!/usr/bin/env bash
#
# VERDICT-LIVENESS-SWEEP.sh — is every rendered verdict CONNECTED to the suite's
# failure result?
#
# THE ONE SENTENCE THIS LICENSES:
#     every rendered verdict is connected to the suite's failure result.
#
# IT DOES NOT ESTABLISH that any predicate measures its English label.  Form /1
# had TWO checks that were hollow — structurally incapable of failing — and BOTH
# would have passed a sweep of exactly this shape, because a hollow check whose
# result is inverted still flips the suite red.  Connectedness, never soundness.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; cd "$HERE"

TOTAL=$(sbcl --non-interactive --load form2-selftest.lisp 2>/dev/null \
        | grep -oE '[0-9]+ checks passed' | grep -oE '^[0-9]+' | head -1)
echo "  suite reports ${TOTAL} checks; forcing each one red in turn"
echo

forced=0; survived=0; collateral=0
for i in $(seq 1 "${TOTAL}"); do
  out=$(FORM2_FORCE_RED=$i sbcl --non-interactive --load form2-selftest.lisp 2>&1)
  rc=$?
  fails=$(printf '%s' "$out" | grep -cE '^\s*\[[0-9]+\] FAIL ' || true)
  at=$(printf '%s' "$out" | grep -oE '^\s*\[0*'"$i"'\] FAIL ' | head -1 || true)
  forced=$((forced+1))
  if [ "$rc" -eq 0 ]; then
    survived=$((survived+1)); echo "  [$i] !! SURVIVED — forced red did not fail the suite"
  fi
  if [ -z "$at" ]; then
    echo "  [$i] !! the forced index did not render FAIL"
    survived=$((survived+1))
  fi
  if [ "$fails" -ne 1 ]; then
    collateral=$((collateral+1)); echo "  [$i] !! collateral: ${fails} checks went red"
  fi
done

echo
echo "  forced ${forced}/${TOTAL} · survived ${survived} · collateral ${collateral}"
echo
echo "  LICENSES EXACTLY ONE SENTENCE:"
echo "    every rendered verdict is connected to the suite's failure result."
echo "  It is NOT predicate soundness.  Both of Form /1's known hollow checks"
echo "  would have passed a sweep of this shape."
[ "$survived" -eq 0 ] && [ "$collateral" -eq 0 ]
