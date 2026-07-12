#!/usr/bin/env bash
#
# verify-all.sh — the single CI floor for Mneme (LispPlus).
#
# ONE command, ONE exit code. Runs every verified runnable under mneme/ in order,
# from its correct working directory, and checks each floor's expected-vs-actual
# check-line counts. Any crack → nonzero exit + a LOUD summary naming which floor
# failed. Target runtime < 2 min against SBCL 2.4.6.
#
# DETERMINISM: this script's own stdout is diffable. It captures each suite's raw
# output (which may contain a pid or path) into a temp file and prints ONLY its own
# expected-vs-actual summary lines — no timestamps, no pids, no randomness. Two clean
# runs produce byte-identical output. On FAILURE it dumps the offending suite's raw
# log so the crack is visible.
#
# Phase 0.1 of experiments/latent-lisp/mneme/ROADMAP.md (Gate G0).
#
set -uo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# ── Expectation table (the ground truth this script asserts against) ──────────
# Edit ONLY here when a floor's legitimate signature changes — never in the suites.
EXPECT_CONFORMANCE_CHECKS=7      # ✓ marks: L1..L7
EXPECT_ADVERSARIAL_PASSED=18     # "=== N passed, 0 failed ==="
EXPECT_BOUNDARY_PASSED=9         # "=== N passed, 0 failed ==="
EXPECT_ATELIER_BANNERS=4         # "...specimens passed." + "...jurisdiction instruments passed." + "All ten decad specimens passed." + "The first post-decad instrument passed." (Sol's de-symmetria-tremenda landed as the first post-decad succession, 2026-07-12)
EXPECT_FIXTURES_PASS=14          # 6 lawful + 8 malformed PASS lines

FAILURES=()

# summary line helper — fixed-width, deterministic
report() {  # $1=verdict  $2=name  $3=detail
  printf '  %-4s  %-28s  %s\n' "$1" "$2" "$3"
}

fail() {  # $1=name  $2=detail  $3=rawlog
  report "FAIL" "$1" "$2"
  FAILURES+=("$1 :: $2 :: $3")
}

echo ""
echo "════════════════════════════════════════════════════════════════════"
echo "  MNEME — verify-all : one floor, one exit code"
echo "════════════════════════════════════════════════════════════════════"
echo ""

# ── 1. conformance-walk (kernel v0, L1–L7) ────────────────────────────────────
LOG="$WORK/conformance.log"
( cd "$ROOT/latent-mvp" && sbcl --script conformance-walk.lisp ) >"$LOG" 2>&1
rc=$?
n=$(grep -c "✓" "$LOG")
if [ "$rc" -eq 0 ] && [ "$n" -eq "$EXPECT_CONFORMANCE_CHECKS" ]; then
  report "PASS" "conformance-walk" "expected $EXPECT_CONFORMANCE_CHECKS ✓, got $n (L1–L7 hold)"
else
  fail "conformance-walk" "expected $EXPECT_CONFORMANCE_CHECKS ✓ / exit 0, got $n ✓ / exit $rc" "$LOG"
fi

# ── 2. adversarial-conformance (hardened client/operator split) ───────────────
LOG="$WORK/adversarial.log"
( cd "$ROOT/latent-mvp" && sbcl --script adversarial-conformance.lisp ) >"$LOG" 2>&1
rc=$?
line=$(grep -E "===[[:space:]]*[0-9]+ passed, [0-9]+ failed" "$LOG" | head -1)
p=$(echo "$line" | sed -E 's/.*=== *([0-9]+) passed, ([0-9]+) failed.*/\1/')
f=$(echo "$line" | sed -E 's/.*=== *([0-9]+) passed, ([0-9]+) failed.*/\2/')
if [ "$rc" -eq 0 ] && [ "${p:-x}" -eq "$EXPECT_ADVERSARIAL_PASSED" ] 2>/dev/null && [ "${f:-x}" -eq 0 ] 2>/dev/null; then
  report "PASS" "adversarial-conformance" "expected $EXPECT_ADVERSARIAL_PASSED passed 0 failed, got $p passed $f failed"
else
  fail "adversarial-conformance" "expected $EXPECT_ADVERSARIAL_PASSED passed/0 failed/exit 0, got ${p:-?} passed/${f:-?} failed/exit $rc" "$LOG"
fi

# ── 3. boundary suite (L5/L6/L7 across a real process gap) ─────────────────────
LOG="$WORK/boundary.log"
bash "$ROOT/latent-mvp/boundary/run-boundary.sh" >"$LOG" 2>&1
rc=$?
line=$(grep -E "===[[:space:]]*[0-9]+ passed, [0-9]+ failed" "$LOG" | head -1)
p=$(echo "$line" | sed -E 's/.*=== *([0-9]+) passed, ([0-9]+) failed.*/\1/')
f=$(echo "$line" | sed -E 's/.*=== *([0-9]+) passed, ([0-9]+) failed.*/\2/')
if [ "$rc" -eq 0 ] && [ "${p:-x}" -eq "$EXPECT_BOUNDARY_PASSED" ] 2>/dev/null && [ "${f:-x}" -eq 0 ] 2>/dev/null; then
  report "PASS" "boundary" "expected $EXPECT_BOUNDARY_PASSED passed 0 failed, got $p passed $f failed"
else
  fail "boundary" "expected $EXPECT_BOUNDARY_PASSED passed/0 failed/exit 0, got ${p:-?} passed/${f:-?} failed/exit $rc" "$LOG"
fi

# ── 4. atelier (six specimens + jurisdiction wing) ────────────────────────────
LOG="$WORK/atelier.log"
bash "$ROOT/atelier/run-all.sh" >"$LOG" 2>&1
rc=$?
b=$(grep -Ec "specimens passed|jurisdiction instruments passed|post-decad instrument passed" "$LOG")
if [ "$rc" -eq 0 ] && [ "$b" -eq "$EXPECT_ATELIER_BANNERS" ]; then
  report "PASS" "atelier" "expected $EXPECT_ATELIER_BANNERS pass-banners, got $b (6 specimens + jurisdiction wing + decad + post-decad)"
else
  fail "atelier" "expected $EXPECT_ATELIER_BANNERS pass-banners / exit 0, got $b / exit $rc" "$LOG"
fi

# ── 5. language-a fixtures (validator teeth) ──────────────────────────────────
LOG="$WORK/fixtures.log"
( cd "$ROOT" && sbcl --script language-a/fixtures.lisp ) >"$LOG" 2>&1
rc=$?
n=$(grep -c "PASS " "$LOG")
suite=$(grep -c "SUITE PASSED" "$LOG")
if [ "$rc" -eq 0 ] && [ "$n" -eq "$EXPECT_FIXTURES_PASS" ] && [ "$suite" -eq 1 ]; then
  report "PASS" "language-a-fixtures" "expected $EXPECT_FIXTURES_PASS PASS + SUITE PASSED, got $n PASS / suite-line $suite"
else
  fail "language-a-fixtures" "expected $EXPECT_FIXTURES_PASS PASS/SUITE PASSED/exit 0, got $n PASS/suite $suite/exit $rc" "$LOG"
fi

echo ""
echo "════════════════════════════════════════════════════════════════════"
if [ "${#FAILURES[@]}" -eq 0 ]; then
  echo "  ALL FLOORS HOLD — 5/5 suites green."
  echo "════════════════════════════════════════════════════════════════════"
  echo ""
  exit 0
else
  echo "  ‼‼‼  FLOOR CRACKED — ${#FAILURES[@]} suite(s) FAILED  ‼‼‼"
  echo "════════════════════════════════════════════════════════════════════"
  for entry in "${FAILURES[@]}"; do
    name="${entry%% :: *}"
    rest="${entry#* :: }"
    detail="${rest%% :: *}"
    rawlog="${rest##* :: }"
    echo ""
    echo "  ── CRACKED: $name"
    echo "     $detail"
    echo "     ── raw suite output (last 20 lines) ──"
    tail -20 "$rawlog" | sed 's/^/       /'
  done
  echo ""
  echo "  DO NOT COMMIT until every floor is green again."
  echo ""
  exit 1
fi
