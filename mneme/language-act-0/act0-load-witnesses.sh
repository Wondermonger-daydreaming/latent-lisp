#!/usr/bin/env bash
#
# act0-load-witnesses.sh — One Act /0 LOADER-FINALITY witness battery
# (owner ruling R2.2, item 3).  Six cases, EACH IN ITS OWN FRESH SBCL
# PROCESS, because each constructs a hostile package-state that only an
# untouched image can hold.
#
#   w1-empty-package     the owner's first reproduced false-success state
#   w2-package-only      the owner's second reproduced false-success state
#   w3-package-fixtures  two of four sources
#   w4-gates-absent      three of four — 69/70; the carrier's reason to exist
#   w5-lawful-fresh      the clean load
#   w6-repeat-forced     forced/repeated load of a complete lane
#
# R2.3 (owner ruling item 1) adds the case-invariant SYSTEM-EXPORT battery
# SE-1..SE-7 to the head of EVERY case — ACT0-LANE-FILES bound and honest, and
# every LISP-PLUS-SYSTEM external bound as its kind requires.  Authorized
# per-case counts move from 9/11/10/12/11/15 to 16/18/17/19/18/22.
#
# Plus LW-T, the harness tooth: ACT0_LOADER_PLANT_FAULT=1 plants one failing
# check, which must make the witness exit 1.  A BATTERY THAT HAS NEVER FAILED
# IS UNTESTED, NOT PASSING.
#
# Reads only; creates no file in the tree; never commits.
# Exit 0 iff all six cases pass AT THEIR AUTHORIZED CHECK COUNT and the planted
# fault is caught.
# Sentinel: act0-load-witnesses: 6/6 cases green, tooth caught
#
# — FABER-II (Claude Opus 5, subagent), R2.2, 2026-08-08

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PER_CASE_TIMEOUT="${ACT0_WITNESS_TIMEOUT:-900}"

SBCL_VERSION="$(sbcl --noinform --non-interactive \
  --eval '(progn (princ (lisp-implementation-version)) (terpri) (finish-output))' 2>/dev/null | tail -1)"
[ "$SBCL_VERSION" = "2.4.6" ] || { echo "!! FAIL CLOSED: SBCL 2.4.6 only (got $SBCL_VERSION)"; exit 1; }
echo "== act0-load-witnesses — SBCL $SBCL_VERSION =="

LOGDIR="$(mktemp -d "${TMPDIR:-/tmp}/act0-witness.XXXXXX")"
trap 'rm -rf "$LOGDIR"' EXIT INT TERM

CASES="w1-empty-package w2-package-only w3-package-fixtures w4-gates-absent w5-lawful-fresh w6-repeat-forced"

# THE AUTHORIZED PER-CASE CHECK COUNTS (R2.2 count + the seven SE checks R2.3
# adds).  A case that runs FEWER checks than authorized has silently lost a
# witness, and "0 failures" would report that loss as health; a case that runs
# MORE has grown one nobody authorized.  Both FAIL CLOSED here.
AUTHORIZED_w1_empty_package=16
AUTHORIZED_w2_package_only=18
AUTHORIZED_w3_package_fixtures=17
AUTHORIZED_w4_gates_absent=19
AUTHORIZED_w5_lawful_fresh=18
AUTHORIZED_w6_repeat_forced=22

FAILED=0
GREEN=0

for c in $CASES; do
  LOG="$LOGDIR/$c.log"
  ACT0_LOADER_CASE="$c" timeout "$PER_CASE_TIMEOUT" \
    sbcl --script "$HERE/act0-load-witnesses.lisp" >"$LOG" 2>&1
  rc=$?
  sentinel="$(grep -E "^act0-load-witnesses\[$c\]: [0-9]+ checks, [0-9]+ failures$" "$LOG" || true)"
  var="AUTHORIZED_${c//-/_}"
  want="${!var:-}"
  got="$(printf '%s' "$sentinel" | sed -n 's/.*: \([0-9]*\) checks.*/\1/p')"
  if [ "$rc" -eq 0 ] && [ -n "$sentinel" ] && [[ "$sentinel" == *"0 failures" ]] \
     && [ -n "$want" ] && [ "$got" = "$want" ]; then
    echo "  [PASS] $c — ${sentinel#*: }  (authorized count $want, observed $got)"
    GREEN=$((GREEN + 1))
  else
    [ -n "$want" ] && [ "$got" != "$want" ] && \
      echo "  !! COUNT DRIFT: $c ran ${got:-?} checks, authorized $want"
    echo "  [FAIL] $c (exit $rc)"
    grep -E "^\[W[0-9]+\] FAIL" "$LOG" | sed 's/^/         /'
    tail -20 "$LOG" | sed 's/^/         /'
    FAILED=1
  fi
  # every case's check-lines are echoed, so the battery is readable, not trusted
  grep -E '^(\[W[0-9]+\]|     ASDF outcome|     SYSTEM-EXPORTS|     export )' "$LOG" | sed 's/^/    | /'
done

echo "-- LW-T: the harness tooth --"
TOOTH="$LOGDIR/tooth.log"
ACT0_LOADER_CASE=w5-lawful-fresh ACT0_LOADER_PLANT_FAULT=1 \
  timeout "$PER_CASE_TIMEOUT" sbcl --script "$HERE/act0-load-witnesses.lisp" >"$TOOTH" 2>&1
if [ $? -ne 0 ] && grep -q "PLANTED FAULT" "$TOOTH"; then
  echo "  [PASS] LW-T: a planted fault makes the witness exit nonzero"
else
  echo "  [FAIL] LW-T: the planted fault did NOT fail the witness"
  FAILED=1
fi

if [ "$FAILED" -eq 0 ] && [ "$GREEN" -eq 6 ]; then
  echo "act0-load-witnesses: 6/6 cases green, tooth caught"
  exit 0
fi
echo "act0-load-witnesses: FAILED ($GREEN/6 green)"
exit 1
