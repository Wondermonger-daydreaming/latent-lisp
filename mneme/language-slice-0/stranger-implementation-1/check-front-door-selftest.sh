#!/usr/bin/env bash
# check-front-door-selftest.sh — TEETH for LIMES.
#
# Plants ONE violation per synthetic fixture and asserts the checker CATCHES
# it. A gate that has never fired is untested, not passing. This script IS the
# firing. Run it; paste its output.
#
# Each case prints EXPECT vs GOT; ends with `SELFTEST: K/K passed` and exits
# non-zero if any assertion failed.

set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHECKER="$HERE/check-front-door.py"
FIX="$HERE/_selftest-fixtures"

rm -rf "$FIX"
mkdir -p "$FIX"

PASS=0
TOTAL=0

# run_checker <fixture-file> -> sets globals OUT, RC, HV, HM, AUDIT, VERDICT
run_checker() {
  OUT="$(python3 "$CHECKER" "$1" 2>&1)"
  RC=$?
  HV="$(printf '%s\n' "$OUT" | grep -oE 'HARD-VIOLATIONS: [0-9]+' | grep -oE '[0-9]+$' | tail -1)"
  HM="$(printf '%s\n' "$OUT" | grep -oE 'HEURISTIC-FLAGS: [0-9]+' | grep -oE '[0-9]+$' | tail -1)"
  AUDIT="$(printf '%s\n' "$OUT" | grep -oE 'EXTERNAL-SYMBOL-AUDIT: [0-9]+' | grep -oE '[0-9]+' | tail -1)"
  VERDICT="$(printf '%s\n' "$OUT" | grep -E '^FRONT-DOOR:' | tail -1)"
  HV="${HV:-NA}"; HM="${HM:-NA}"; AUDIT="${AUDIT:-NA}"
}

# assert <name> <expect-desc> <got-desc> <bool 0=pass>
assert_case() {
  local name="$1" expect="$2" got="$3" ok="$4"
  TOTAL=$((TOTAL+1))
  if [ "$ok" -eq 0 ]; then
    PASS=$((PASS+1))
    printf '  [PASS] %-26s EXPECT %-42s GOT %s\n' "$name" "$expect" "$got"
  else
    printf '  [FAIL] %-26s EXPECT %-42s GOT %s\n' "$name" "$expect" "$got"
    printf '         ---- full checker output ----\n%s\n         -----------------------------\n' "$OUT"
  fi
}

echo "=================================================================="
echo "LIMES self-test — planting one violation per fixture"
echo "=================================================================="

# ---- fixture 1: :: package-internal access (external symbol via ::) --------
cat > "$FIX/f1-double-colon.lisp" <<'LISP'
;; plants a double-colon reference (to an EXPORTED symbol, to isolate the :: check)
(lisp-plus-slice0::claim :proposition '(:a 1) :by :x)
LISP
run_checker "$FIX/f1-double-colon.lisp"
[ "$HV" != "NA" ] && [ "$HV" -ge 1 ]; assert_case "double-colon" "HARD>=1" "HARD=$HV rc=$RC" $?

# ---- fixture 2: setf into a record accessor -------------------------------
cat > "$FIX/f2-setf-slot.lisp" <<'LISP'
;; plants a direct record-slot mutation
(let ((c (lisp-plus-slice0:claim :proposition '(:a 1) :by :x)))
  (setf (lisp-plus-slice0:claim-proposition c) '(:b 2)))
LISP
run_checker "$FIX/f2-setf-slot.lisp"
[ "$HV" != "NA" ] && [ "$HV" -ge 1 ]; assert_case "setf-record-slot" "HARD>=1" "HARD=$HV rc=$RC" $?

# ---- fixture 3: slot-value (+ ::) -----------------------------------------
cat > "$FIX/f3-slot-value.lisp" <<'LISP'
;; plants a slot-value bypass (also carries a :: reference)
(slot-value w 'lisp-plus-slice0::foo)
LISP
run_checker "$FIX/f3-slot-value.lisp"
sv_hit=1
printf '%s\n' "$OUT" | grep -q 'slot-value' && sv_hit=0
{ [ "$HV" != "NA" ] && [ "$HV" -ge 1 ] && [ "$sv_hit" -eq 0 ]; }; assert_case "slot-value" "HARD>=1 & slot-value flagged" "HARD=$HV slotval=$sv_hit rc=$RC" $?

# ---- fixture 4: REAL internal symbol via :: (loader audit must catch) ------
cat > "$FIX/f4-internal-symbol.lisp" <<'LISP'
;; plants a reference to a REAL non-exported helper of lisp-plus-slice0
(lisp-plus-slice0::%require-proposition '(:a 1))
LISP
run_checker "$FIX/f4-internal-symbol.lisp"
[ "$AUDIT" != "NA" ] && [ "$AUDIT" -ge 1 ]; assert_case "internal-symbol-audit" "AUDIT>=1 (loader caught internal)" "AUDIT=$AUDIT HARD=$HV rc=$RC" $?

# ---- fixture 5: CLEAN — only exported symbols -----------------------------
cat > "$FIX/f5-clean.lisp" <<'LISP'
;; clean fixture: exported single-colon surface only; no slot mutation, no laundering
(lisp-plus-slice0:claim :proposition '(:a 1) :by :x)
LISP
run_checker "$FIX/f5-clean.lisp"
{ [ "$RC" -eq 0 ] && printf '%s\n' "$VERDICT" | grep -q '^FRONT-DOOR: CLEAN$' && [ "$HV" = "0" ]; }; assert_case "clean-passes" "rc=0 & FRONT-DOOR: CLEAN & HARD=0" "rc=$RC HARD=$HV '$VERDICT'" $?

# ---- fixture 5b: :: only in comment/string is NOT a hard fail --------------
cat > "$FIX/f5b-colons-in-prose.lisp" <<'LISP'
;; this comment mentions foo::bar but that is prose, not package access
(lisp-plus-slice0:claim :proposition '(:note "we never use pkg::sym here") :by :x)
LISP
run_checker "$FIX/f5b-colons-in-prose.lisp"
{ [ "$RC" -eq 0 ] && printf '%s\n' "$VERDICT" | grep -q '^FRONT-DOOR: CLEAN$' && [ "$HV" = "0" ]; }; assert_case "colons-in-prose-clean" "rc=0 & CLEAN & HARD=0 (:: in prose)" "rc=$RC HARD=$HV HEUR=$HM '$VERDICT'" $?

# ---- fixture 6: format nil host-object heuristic --------------------------
cat > "$FIX/f6-format-nil.lisp" <<'LISP'
;; plants a stringify laundering smell (heuristic, not a hard fail)
(format nil "~a" some-closure)
LISP
run_checker "$FIX/f6-format-nil.lisp"
{ [ "$HM" != "NA" ] && [ "$HM" -ge 1 ] && [ "$RC" -eq 0 ]; }; assert_case "format-nil-heuristic" "HEUR>=1 & rc=0 (heuristic, non-fatal)" "HEUR=$HM rc=$RC" $?

echo "------------------------------------------------------------------"
echo "SELFTEST: ${PASS}/${TOTAL} passed"
if [ "$PASS" -ne "$TOTAL" ]; then
  exit 1
fi
exit 0
