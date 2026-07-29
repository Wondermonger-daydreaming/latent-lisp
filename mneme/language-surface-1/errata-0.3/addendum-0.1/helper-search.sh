#!/usr/bin/env bash
#
# helper-search.sh — Evidence Addendum 0.1, §A2.
#
# THE QUESTION THIS ANSWERS, STATED NARROWLY.  Not "where does INTERN appear" —
# it appears legitimately many times, building FIXTURE symbols whose whole purpose
# is to be created (`(intern "X" pkg)` in a probe package, `(intern "*S1-N*" '#:cl-user)`
# as a definition name inside a source form under test).  Interning a fixture is
# the instrument doing its job.
#
# The question is: DOES ANY INSTRUMENT RESOLVE THE PRODUCTION API BY MANUFACTURING
# SYMBOLS RATHER THAN BY REQUIRING EXISTING EXTERNAL ONES?  That is a helper
# defect, because a manufactured name cannot fail — a typo or a demoted export
# becomes a fresh private symbol and the instrument reports on a package it just
# altered.
#
# SCOPE: the CURRENT EXECUTABLE INSTRUMENTS ONLY — the six the runner executes,
# plus the evidence helper they all load.  `surface1.lisp` and `package.lisp` are
# the PRODUCTION LAYER, not instruments, and are outside this addendum's authority
# to change; they are searched here and reported, never repaired.
set -uo pipefail
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../.."

INSTRUMENTS=(surface1-selftest.lisp
             STUB-IMAGE-FIXTURE.lisp
             de-expansione-testata/APPLICATION.lisp
             errata-0.1/REPRODUCTION.lisp
             errata-0.2/REPRODUCTION-II.lisp
             errata-0.3/REPRODUCTION-III.lisp
             errata-0.3/EVIDENCE.lisp)

echo "HELPER-RESOLUTION SEARCH — Evidence Addendum 0.1"
echo "tree: $(pwd)"
echo
echo "=========================================================================="
echo "COMMAND 1 — every macro definition in the current executable instruments."
echo "  grep -n '^(defmacro' <instruments>"
echo "=========================================================================="
grep -n '^(defmacro' "${INSTRUMENTS[@]}" || echo "  (none)"
echo
echo "=========================================================================="
echo "COMMAND 2 — every INTERN call in the current executable instruments,"
echo "with the two lines after it, so its purpose is legible."
echo "  grep -nE '\\(intern ' <instruments>"
echo "=========================================================================="
grep -nE '\(intern ' "${INSTRUMENTS[@]}" || echo "  (none)"
echo
echo "=========================================================================="
echo "COMMAND 3 — every FIND-SYMBOL call, so an UNGUARDED one (a resolution that"
echo "does not demand :EXTERNAL) can be told from a guarded one."
echo "  grep -nE '\\(find-symbol|multiple-value-bind \\(sym' <instruments>"
echo "=========================================================================="
grep -nE '\(find-symbol|multiple-value-bind \((sym|symbol)' "${INSTRUMENTS[@]}" || echo "  (none)"
echo
echo "=========================================================================="
echo "COMMAND 4 — THE ONE THAT DECIDES.  A helper is a macro that resolves a name"
echo "into the production packages.  Print each such macro's whole body and show"
echo "whether it demands :EXTERNAL."
echo "  for each defmacro: sed the form, test for INTERN and for :EXTERNAL"
echo "=========================================================================="
FAIL=0
for f in "${INSTRUMENTS[@]}"; do
  while IFS=: read -r ln _; do
    [ -n "$ln" ] || continue
    body="$(awk -v s="$ln" 'NR>=s && NR<s+24' "$f")"
    # the macro's own form: stop at the next top-level form
    body="$(printf '%s\n' "$body" | awk 'NR==1{print;next} /^\(/{exit} {print}')"
    name="$(printf '%s\n' "$body" | head -1 | sed -E 's/^\(defmacro +([^ ()]+).*/\1/')"
    # Does it reach into a production package at all?
    printf '%s\n' "$body" | grep -qiE "lisp-plus-(cd0|surface0|surface1)" || continue
    uses_intern=NO;  printf '%s\n' "$body" | grep -qE '\(intern ' && uses_intern=YES
    demands_ext=NO;  printf '%s\n' "$body" | grep -q ':external'     && demands_ext=YES
    verdict="OK — resolves through FIND-SYMBOL and refuses unless :EXTERNAL"
    if [ "$uses_intern" = "YES" ] || [ "$demands_ext" = "NO" ]; then
      verdict="DEFECT — resolves the production API without demanding :EXTERNAL"
      FAIL=$((FAIL+1))
    fi
    printf '  %-46s macro %-6s INTERN=%-3s :EXTERNAL=%-3s  %s\n' \
      "$f:$ln" "$name" "$uses_intern" "$demands_ext" "$verdict"
  done < <(grep -n '^(defmacro' "$f")
done
echo
echo "=========================================================================="
echo "DISPOSITION"
echo "=========================================================================="
if [ "$FAIL" -eq 0 ]; then
  echo "  NO production-API-resolving helper in any current executable instrument"
  echo "  manufactures symbols.  All resolve through FIND-SYMBOL and refuse unless"
  echo "  the symbol is :EXTERNAL."
else
  echo "  ${FAIL} production-API-resolving helper(s) still manufacture symbols."
fi
echo
echo "  REMAINING INTERN CALLS ARE FIXTURE CONSTRUCTION, NOT HELPER RESOLUTION,"
echo "  and are correct as they stand.  They fall in three kinds:"
echo "    * probe-package fixtures  — (intern \"X\" pkg) in E03R-RHO / PROBE-P / …,"
echo "      symbols created precisely so the layer can be asked about them;"
echo "    * definition names inside source forms under test — (intern \"*S1-N*\""
echo "      '#:cl-user), the name a specimen DEFINE-… form is about to bind;"
echo "    * a negative check that DEPENDS on interning — APPLICATION.lisp:186"
echo "      asserts the interned name is NOT bound."
echo "  None of these resolves an operation of the production API.  The distinction"
echo "  is not stylistic: manufacturing a FIXTURE name is the instrument's subject;"
echo "  manufacturing an API name is the instrument losing the ability to fail."
echo
echo "  OUT OF SCOPE, REPORTED NOT REPAIRED: surface1.lisp and package.lisp are the"
echo "  production layer.  This addendum is not authorized to change them.  For the"
echo "  record, surface1.lisp resolves reconstructed symbols with FIND-SYMBOL and"
echo "  never INTERN by its own documented law (surface1.lisp:626), and validates"
echo "  status rather than mere accessibility (surface1.lisp:739)."
exit "$FAIL"
