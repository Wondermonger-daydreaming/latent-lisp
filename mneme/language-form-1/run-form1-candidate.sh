#!/usr/bin/env bash
#
# run-form1-candidate.sh — the LOCAL runner for Language Form /1, Candidate /0.
#
# THIS IS NOT A GOVERNING FLOOR.  verify-all.sh, verify-language-floor.sh and
# verify-form-floor.sh are the floors.  Form /1 is a candidate: it is not
# adopted, not frozen, and it does not join any floor by this file existing.
# Nothing here may be added to a verify-*.sh as a side effect; that is a
# separate, later, owner decision.
#
# What it does, and nothing else:
#   1. runs  form1-selftest.lisp
#   2. runs  de-forma-petente/APPLICATION.lisp
#   3. captures each run's stdout+stderr RAW and UNFILTERED into a tracked file
#   4. retains and reports each exit code separately
#   5. exits nonzero if either run failed
#
# THE CAPTURES ARE NEVER PIPED THROUGH grep OR sed.  A previous artifact in this
# tree lost a real data line because relay assembly filtered the run through a
# grep whose exclusion list contained the word "caught", and a verdict label
# contained that word.  Redirection only, both streams, in order, to disk.
# Reconciliation is a separate step with its own script and its own artifact:
#   bash check-form1-transcript.sh
#
# Run: bash run-form1-candidate.sh      (from any cwd)

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SELFTEST_DIR="$HERE"
SELFTEST_ENTRY="form1-selftest.lisp"
SELFTEST_CAPTURE="$HERE/RUN-SELFTEST.txt"

APP_DIR="$HERE/de-forma-petente"
APP_ENTRY="APPLICATION.lisp"
APP_CAPTURE="$HERE/RUN-APPLICATION.txt"

# The exit codes are retained beside the captures so the reconciler can check
# exit-vs-failures WITHOUT re-running anything and WITHOUT the runner writing a
# verdict into the raw capture (which would stop being raw).
EXITCODES="$HERE/RUN-EXITCODES.txt"

# ── Preflight — fail LOUDLY, never silently, and never half-run ───────────────
MISSING=()
[ -f "$SELFTEST_DIR/$SELFTEST_ENTRY" ] || MISSING+=("$SELFTEST_DIR/$SELFTEST_ENTRY")
[ -f "$APP_DIR/$APP_ENTRY" ]           || MISSING+=("$APP_DIR/$APP_ENTRY")

if [ "${#MISSING[@]}" -ne 0 ]; then
  echo ""
  echo "  ‼‼  run-form1-candidate: REFUSING TO RUN — ${#MISSING[@]} required file(s) absent"
  for m in "${MISSING[@]}"; do
    echo "      MISSING: $m"
  done
  echo ""
  echo "  Nothing was executed and no capture was written or overwritten."
  echo "  This runner has no fallback: a suite that does not exist cannot be"
  echo "  reported as passing, skipped, or 'not applicable'."
  echo ""
  exit 2
fi

if ! command -v sbcl >/dev/null 2>&1; then
  echo ""
  echo "  ‼‼  run-form1-candidate: REFUSING TO RUN — sbcl is not on PATH"
  echo "      Nothing was executed and no capture was written or overwritten."
  echo ""
  exit 3
fi

# ── The two runs ─────────────────────────────────────────────────────────────
# Raw redirection only.  cd into the suite's own directory, because the suites
# load their layer with pathnames relative to themselves.

( cd "$SELFTEST_DIR" && sbcl --non-interactive --load "$SELFTEST_ENTRY" ) >"$SELFTEST_CAPTURE" 2>&1
RC_SELFTEST=$?

( cd "$APP_DIR" && sbcl --non-interactive --load "$APP_ENTRY" ) >"$APP_CAPTURE" 2>&1
RC_APP=$?

{
  echo "form1-selftest $RC_SELFTEST"
  echo "de-forma-petente $RC_APP"
} >"$EXITCODES"

# ── Report — WHAT WAS EXECUTED, and the three stable properties ──────────────
# No verdict, audit status, adoption standing or check count is hard-coded in
# this banner.  Ruling 2 of this lane: a banner that restates governance goes
# stale the moment the standing moves, and a stale declaration is a small false
# witness.  Everything that can change lives in the record, named below.
echo ""
echo "  =================================================================="
echo "  MNEME — run-form1-candidate : Language Form /1, CANDIDATE /0"
echo "  =================================================================="
echo ""
echo "  SBCL: $(sbcl --non-interactive --eval '(princ (lisp-implementation-version))' 2>/dev/null | tail -1)"
echo ""
echo "  EXECUTED (raw stdout+stderr captured, unfiltered):"
printf '    %-22s  exit %-3s  ->  %s\n' "$SELFTEST_ENTRY" "$RC_SELFTEST" "${SELFTEST_CAPTURE#"$HERE"/}"
printf '    %-22s  exit %-3s  ->  %s\n' "de-forma-petente/$APP_ENTRY" "$RC_APP" "${APP_CAPTURE#"$HERE"/}"
echo "    exit codes retained in  ${EXITCODES#"$HERE"/}"
echo ""

# The suites' own footer lines, QUOTED, not adjudicated.  This runner keeps no
# second tally: a count maintained separately from the thing it counts is a
# rumour.  Reconciliation of footer-vs-body is check-form1-transcript.sh's job.
echo "  SUITE FOOTERS (verbatim from the captures — quoted, NOT verified here):"
for cap in "$SELFTEST_CAPTURE" "$APP_CAPTURE"; do
  foot="$(grep -E '[0-9]+[[:space:]]+(checks[[:space:]]+)?(passed|produced)[[:space:]]*/[[:space:]]*[0-9]+[[:space:]]+failed' "$cap" | tail -1)"
  if [ -n "${foot:-}" ]; then
    printf '    %s\n' "$foot"
  else
    printf '    (%s: no footer tally line present)\n' "${cap#"$HERE"/}"
  fi
done
echo ""
echo "  Reconcile with:  bash check-form1-transcript.sh"
echo ""

# The three stable properties of this lane.  These do not change while Form /1
# is a candidate; if one of them changes, the lane has ended and this runner is
# obsolete rather than merely out of date.
echo "  STANDING: this is a CANDIDATE implementation, run for SELF-CONSISTENCY"
echo "  ONLY. It implies no adoption and no specification freeze. Current audit,"
echo "  adoption and freeze standing is recorded in LANGUAGE-FORM-1-RETURN.md,"
echo "  which is the governing record; this banner is not."
echo ""

if [ "$RC_SELFTEST" -ne 0 ] || [ "$RC_APP" -ne 0 ]; then
  echo "  xx  A RUN FAILED — form1-selftest exit $RC_SELFTEST, de-forma-petente exit $RC_APP."
  echo "      The raw captures are on disk and were not filtered. Read them."
  echo ""
  exit 1
fi

exit 0
