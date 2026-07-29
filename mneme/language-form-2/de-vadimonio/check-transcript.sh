#!/usr/bin/env bash
#
# check-transcript.sh — reconcile de-vadimonio's SPECIMEN-RUN.txt against itself.
#
# A PURE FUNCTION OF THE CAPTURES.  It re-executes nothing, so it cannot
# disagree with the run by running a different one.  Every number it reports is
# recomputed FROM THE RENDERED VERDICT LINES, because a footer is a CLAIM and
# the verdict lines are the EVIDENCE.
#
# NO EXPECTED N IS HARD-CODED ANYWHERE IN THIS FILE.  A reconciler that knows
# the answer in advance is checking its own memory, not the transcript.  The
# de-pignore precedent exists because a relay once piped a run through a grep
# whose exclusion list contained a word appearing in a verdict label; the footer
# and the visible verdicts then disagreed by one, and nothing noticed.
#
# What it checks:
#   1. footer count          == number of rendered verdict lines
#   2. verdict numbering     is contiguous 1..N, no gap, no repeat, no reorder
#   3. every numbered line   in the verdict region reads exactly "ok" or "FAIL"
#   4. footer failure count  == number of rendered FAIL lines
#   5. ok + FAIL             == rendered
#   6. recorded process exit agrees with the failure count (0 iff none)
#   7. the capture           shows no sign of having been filtered
#
# What it does NOT check: whether the checks were the right checks.  That is a
# reader's job and a stranger's, not a reconciler's.

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE"

RUN=SPECIMEN-RUN.txt
EXITFILE=SPECIMEN-RUN-EXITCODE.txt
OUT=RUN-TRANSCRIPT-CHECK.txt

fail=0
report=""
add () { report+="$1"$'\n'; }
judge () {   # judge <label> <PASS|FAIL> [detail]
  add "$(printf '  %-28s %-4s %s' "$1" "$2" "${3:-}")"
  [ "$2" = "PASS" ] || fail=1
}

if [ ! -f "$RUN" ]; then
  printf '  !! MISSING %s\n' "$RUN" | tee "$OUT"
  exit 1
fi

# ---------------------------------------------------------------------------
# ONE AWK PASS.  The "verdict region" ends at the footer line, so the
# footer's own FAILED: listing — which repeats bracketed numbers WITHOUT an
# ok/FAIL word — cannot be miscounted as a malformed verdict.
# ---------------------------------------------------------------------------
eval "$(awk '
  BEGIN { region = 1; rendered = 0; ok = 0; bad = 0; numbered = 0; outoforder = 0 }
  region && /checks produced \/ [0-9]+ failed/ { region = 0 }
  region && /^[[:space:]]*\[[0-9]+\][[:space:]]/ {
    numbered++
    n = $0
    sub(/^[[:space:]]*\[/, "", n); sub(/\].*$/, "", n)
    if ($0 ~ /^[[:space:]]*\[[0-9]+\] ok /)   { rendered++; ok++;  seen = 1 }
    else if ($0 ~ /^[[:space:]]*\[[0-9]+\] FAIL /) { rendered++; bad++; seen = 1 }
    else { seen = 0 }
    if (seen) { if (n + 0 != rendered) outoforder++ }
  }
  /checks produced \/ [0-9]+ failed/ {
    line = $0
    sub(/^.*== *[^:]*: */, "", line)
    split(line, a, " ")
    fcount = a[1]
    for (i = 1; i <= 8; i++) if (a[i] == "/") ffail = a[i+1]
  }
  END {
    printf "RENDERED=%d\nRENDERED_OK=%d\nRENDERED_FAIL=%d\nNUMBERED=%d\nOUTOFORDER=%d\nFOOTER_COUNT=%s\nFOOTER_FAIL=%s\n",
           rendered, ok, bad, numbered, outoforder,
           (fcount == "" ? "NONE" : fcount), (ffail == "" ? "NONE" : ffail)
  }
' "$RUN")"

if [ -f "$EXITFILE" ]; then
  EXIT_CODE=$(grep -oE 'process exit code[[:space:]]+[0-9]+' "$EXITFILE" | grep -oE '[0-9]+$' || true)
  CAPTURE=$(grep -E '^capture method' "$EXITFILE" | sed 's/^capture method[[:space:]]*//' || true)
else
  EXIT_CODE=""
  CAPTURE=""
fi

add ""
add "RUN-TRANSCRIPT-CHECK — de-vadimonio SPECIMEN-RUN.txt"
add "mechanical reconciliation of the RAW capture; no expected N is hard-coded"
add ""
add "  capture method             ${CAPTURE:-UNRECORDED}"
add "  recorded process exit      ${EXIT_CODE:-UNRECORDED}"
add ""
add "  footer count               ${FOOTER_COUNT}"
add "  rendered verdict lines     ${RENDERED}"
add "  rendered ok                ${RENDERED_OK}"
add "  rendered FAIL              ${RENDERED_FAIL}"
add "  footer failures            ${FOOTER_FAIL}"
add "  numbered lines in region   ${NUMBERED}"
add ""

if [ "$FOOTER_COUNT" != "NONE" ] && [ "$FOOTER_COUNT" = "$RENDERED" ]; then
  judge "footer == rendered" PASS "($RENDERED)"
else
  judge "footer == rendered" FAIL "footer=$FOOTER_COUNT rendered=$RENDERED"
fi

if [ "$RENDERED" -gt 0 ] && [ "$OUTOFORDER" -eq 0 ]; then
  judge "numbering contiguous 1..N" PASS "(1..$RENDERED)"
else
  judge "numbering contiguous 1..N" FAIL "out-of-sequence entries: $OUTOFORDER"
fi

if [ "$NUMBERED" -eq "$RENDERED" ]; then
  judge "every verdict ok|FAIL" PASS
else
  judge "every verdict ok|FAIL" FAIL "$((NUMBERED - RENDERED)) numbered line(s) carry neither word"
fi

if [ "$FOOTER_FAIL" != "NONE" ] && [ "$FOOTER_FAIL" = "$RENDERED_FAIL" ]; then
  judge "failures agree" PASS "($RENDERED_FAIL)"
else
  judge "failures agree" FAIL "footer=$FOOTER_FAIL rendered=$RENDERED_FAIL"
fi

if [ "$RENDERED" -eq $((RENDERED_OK + RENDERED_FAIL)) ]; then
  judge "ok + FAIL == rendered" PASS
else
  judge "ok + FAIL == rendered" FAIL
fi

if [ -z "${EXIT_CODE:-}" ]; then
  judge "exit agrees with failures" FAIL "no exit code recorded by the runner"
elif { [ "$RENDERED_FAIL" -eq 0 ] && [ "$EXIT_CODE" -eq 0 ]; } \
  || { [ "$RENDERED_FAIL" -gt 0 ] && [ "$EXIT_CODE" -ne 0 ]; }; then
  judge "exit agrees with failures" PASS "(exit $EXIT_CODE, $RENDERED_FAIL failures)"
else
  judge "exit agrees with failures" FAIL "(exit $EXIT_CODE, $RENDERED_FAIL failures)"
fi

# An UNFILTERED capture keeps the SBCL banner and the program's own header.
# Their absence would mean something stood between the process and this file.
if grep -q 'This is SBCL' "$RUN" && grep -q 'DE VADIMONIO' "$RUN"; then
  judge "capture unfiltered" PASS "(SBCL banner and program header both present)"
else
  judge "capture unfiltered" FAIL "(SBCL banner or program header missing)"
fi

add ""
if [ $fail -eq 0 ]; then
  add "  RECONCILIATION CLEAN"
else
  add "  !! RECONCILIATION FAILED"
fi
add ""
add "  This reconciler certifies ONLY that the transcript agrees with itself."
add "  It certifies nothing about whether the checks were the right checks."
add ""

printf '%s' "$report" | tee "$OUT"
exit $fail
