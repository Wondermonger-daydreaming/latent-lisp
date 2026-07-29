#!/usr/bin/env bash
#
# subject-binding-controls.sh — Evidence Addendum 0.1, §A1 negative controls.
#
# A GATE THAT HAS NEVER FIRED IS UNTESTED, NOT PASSING.  The corrected runner
# reports GREEN against this tree; that is evidence only once the same gate has
# been shown able to REFUSE.  Each control below plants one fault and requires the
# refusal, and one control (C0) plants NOTHING and requires acceptance — without
# it, a harness that refused everything for a trivial reason would score perfect.
#
# THE LOGIC UNDER TEST IS NOT RETYPED.  `validate_result`, `subject_bindings` and
# the field-set declarations are extracted VERBATIM from the live runner with sed,
# so these controls exercise the shipped code.  Extraction failure is a REFUSAL to
# report, never a fallback to a hand-written copy.
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUNNER="$HERE/../../../run-surface1-candidate.sh"

echo "SUBJECT-BINDING NEGATIVE CONTROLS — Evidence Addendum 0.1"
echo "logic under test: $(cd "$(dirname "$RUNNER")" && pwd)/$(basename "$RUNNER")"
echo "runner sha256   : $(sha256sum "$RUNNER" | cut -d' ' -f1)"
echo

VR_SRC="$(sed -n '/^validate_result() {/,/^}/p'  "$RUNNER")"
SB_SRC="$(sed -n '/^subject_bindings() {/,/^}/p' "$RUNNER")"
FS_SRC="$(grep -E '^(CHECKS_FIELDS|VERDICT_FIELDS|VERDICT3_FIELDS)=' "$RUNNER")"
for pair in "validate_result:$VR_SRC" "subject_bindings:$SB_SRC" "field-sets:$FS_SRC"; do
  [ -n "${pair#*:}" ] || { echo "REFUSING: could not extract ${pair%%:*} from the runner."; exit 2; }
done
eval "$VR_SRC"; eval "$SB_SRC"; eval "$FS_SRC"

# A digest that stands in for "the value this run computed for itself".
SUBJECT_SHORT="9214b59bda190327"
WRONG_DIGEST="deadbeefcafe0123"     # well-formed, 16 lowercase hex, and NOT ours

SCRATCH="$(mktemp -d)"; trap 'rm -rf "$SCRATCH"' EXIT
PASS=0; FAIL=0

# expect <want:PASS|REFUSE> <name> <file> <label> <countkey> <fields> <zeros> <eq>
#
# NB: the two wrappers below pass the field-set as ONE quoted argument.  An
# earlier draft held the whole argument tail in a single string and let word
# splitting deal it out; `required` then received only its first word and EVERY
# case refused, for the wrong reason.  THE POSITIVE CONTROL C0 IS WHAT CAUGHT IT —
# a harness that refuses everything scores perfect on refusals alone.  The bug is
# left recorded here rather than quietly fixed.
expect() {
  local want="$1" name="$2" file="$3"; shift 3
  validate_result "$file" "$@"
  local got="REFUSE"; [ "$GATE_OK" = "1" ] && got="PASS"
  local bind; bind="$(subject_bindings "$file")"
  if [ "$got" = "$want" ]; then
    PASS=$((PASS+1))
    printf '  %-4s %-46s %-6s  bindings=%-34s %s\n' "OK" "$name" "$got" "$bind" "$GATE_REASON"
  else
    FAIL=$((FAIL+1))
    printf '  %-4s %-46s %-6s (wanted %s)  bindings=%-20s %s\n' "!!" "$name" "$got" "$want" "$bind" "$GATE_REASON"
  fi
}

as_selftest() { expect "$1" "$2" "$3" SELFTEST-RESULT         checks   "$CHECKS_FIELDS"   "failed"    ""; }
as_repro3()   { expect "$1" "$2" "$3" REPRODUCTION-III-RESULT verdicts "$VERDICT3_FIELDS" "confirmed" "refuted"; }

echo "CONTROLS — each plants ONE fault; the gate must REFUSE.  C0 plants none."
echo

# ---- C0  POSITIVE CONTROL: the gate must still accept a correct transcript. ---
printf 'preamble line, not a result\nSELFTEST-RESULT checks=139 expected=139 failed=0 subject=%s\n' \
  "$SUBJECT_SHORT" > "$SCRATCH/c0-self.txt"
printf 'REPRODUCTION-III-RESULT verdicts=12 expected=12 confirmed=0 refuted=12 classification=3 subject=%s\n' \
  "$SUBJECT_SHORT" > "$SCRATCH/c0-r3.txt"
as_selftest PASS "C0a positive control — correct selftest line"  "$SCRATCH/c0-self.txt"
as_repro3   PASS "C0b positive control — correct repro-III line" "$SCRATCH/c0-r3.txt"

# ---- C1  the selftest subject field is ABSENT -------------------------------
# The exact line named in the work order, and the exact line the pre-correction
# witness proved the published gate ACCEPTED.
printf 'SELFTEST-RESULT checks=139 expected=139 failed=0\n' > "$SCRATCH/c1.txt"
as_selftest REFUSE "C1 selftest subject field ABSENT" "$SCRATCH/c1.txt"

# ---- C2  the Reproduction III subject field is ABSENT ------------------------
printf 'REPRODUCTION-III-RESULT verdicts=12 expected=12 confirmed=0 refuted=12 classification=4\n' \
  > "$SCRATCH/c2.txt"
as_repro3   REFUSE "C2 repro-III subject field ABSENT" "$SCRATCH/c2.txt"

# ---- C3  a WRONG BUT WELL-FORMED digest, each instrument --------------------
printf 'SELFTEST-RESULT checks=139 expected=139 failed=0 subject=%s\n' "$WRONG_DIGEST" > "$SCRATCH/c3a.txt"
printf 'REPRODUCTION-III-RESULT verdicts=12 expected=12 confirmed=0 refuted=12 classification=3 subject=%s\n' \
  "$WRONG_DIGEST" > "$SCRATCH/c3b.txt"
as_selftest REFUSE "C3a selftest digest well-formed but WRONG"  "$SCRATCH/c3a.txt"
as_repro3   REFUSE "C3b repro-III digest well-formed but WRONG" "$SCRATCH/c3b.txt"

# ---- C4  ZERO canonical result lines ----------------------------------------
# A transcript with real content that never reaches its summary.
printf 'loading surface1.lisp\n  A1 ok\n  A2 ok\n; compilation finished\n' > "$SCRATCH/c4.txt"
as_selftest REFUSE "C4 transcript carries ZERO canonical lines" "$SCRATCH/c4.txt"

# ---- C5  TWO canonical result lines -----------------------------------------
# Both correct in isolation.  Two runs concatenated; neither is a lie, and the
# transcript is still not evidence of one run.
printf 'SELFTEST-RESULT checks=139 expected=139 failed=0 subject=%s\nSELFTEST-RESULT checks=139 expected=139 failed=0 subject=%s\n' \
  "$SUBJECT_SHORT" "$SUBJECT_SHORT" > "$SCRATCH/c5.txt"
as_selftest REFUSE "C5 transcript carries TWO canonical lines" "$SCRATCH/c5.txt"

# ---- C6  TWO CONFLICTING subject digests ------------------------------------
# DISTINCT FROM C5 ON PURPOSE.  One canonical line, correct, plus a SPLICED tail
# from another run on a NON-canonical line.  The canonical-line gate cannot see
# it — only the widened binding scan can, which is why the scan was widened.
printf 'SELFTEST-RESULT checks=139 expected=139 failed=0 subject=%s\n--- appended from an earlier run --- subject=%s\n' \
  "$SUBJECT_SHORT" "$WRONG_DIGEST" > "$SCRATCH/c6.txt"
validate_result "$SCRATCH/c6.txt" SELFTEST-RESULT checks "$CHECKS_FIELDS" "failed" ""
C6_LINE_OK="$GATE_OK"; C6_LINE_WHY="$GATE_REASON"
C6_BIND="$(subject_bindings "$SCRATCH/c6.txt")"
# Run the runner's own agreement rule over that binding value.
C6_AGREE=1; C6_WHY="bindings agree"
if   [ "$C6_BIND" = "ABSENT" ];        then C6_AGREE=0; C6_WHY="bound NOTHING"
elif [ "$C6_BIND" != "$SUBJECT_SHORT" ]; then C6_AGREE=0; C6_WHY="bound [${C6_BIND}], this run computed ${SUBJECT_SHORT}"
fi
if [ "$C6_LINE_OK" = "1" ] && [ "$C6_AGREE" = "0" ]; then
  PASS=$((PASS+1))
  printf '  %-4s %-46s %-6s  bindings=%-34s %s\n' "OK" \
    "C6 TWO CONFLICTING digests (spliced tail)" "REFUSE" "$C6_BIND" "$C6_WHY"
  printf '       %s\n' "note: the canonical LINE passed (${C6_LINE_WHY}); only the widened"
  printf '       %s\n' "binding scan caught it.  This is the control that justifies widening."
else
  FAIL=$((FAIL+1))
  printf '  %-4s %-46s line_ok=%s agree=%s bindings=%s\n' "!!" \
    "C6 TWO CONFLICTING digests (spliced tail)" "$C6_LINE_OK" "$C6_AGREE" "$C6_BIND"
fi

# ---- C7  the process EXITS BEFORE EMITTING ITS RESULT ------------------------
# Truncated mid-line, the realistic shape of a crash or an early exit: output
# stops partway through, so there is no canonical line to find.
printf 'loading surface1.lisp\n  A1 ok\n  A2 ok\nSELFTEST-RESULT checks=35 expec' > "$SCRATCH/c7.txt"
as_selftest REFUSE "C7 process exited BEFORE emitting its result" "$SCRATCH/c7.txt"
# And the count-consistency tooth, in case a truncated run's summary is re-appended:
printf 'SELFTEST-RESULT checks=35 expected=139 failed=0 subject=%s\n' "$SUBJECT_SHORT" > "$SCRATCH/c7b.txt"
as_selftest REFUSE "C7b truncated run, summary re-appended" "$SCRATCH/c7b.txt"

# ---- C8  form and field-set teeth, since the back-reference is gone ----------
printf 'SELFTEST-RESULT checks=139 expected=139 failed=0 subject=%s\n' "9214B59BDA190327" > "$SCRATCH/c8a.txt"
as_selftest REFUSE "C8a subject UPPERCASE hex — not canonical form" "$SCRATCH/c8a.txt"
printf 'SELFTEST-RESULT checks=139 expected=139 failed=0 subject=%s\n' "9214b59bda19032" > "$SCRATCH/c8b.txt"
as_selftest REFUSE "C8b subject 15 hex digits, not 16" "$SCRATCH/c8b.txt"
printf 'SELFTEST-RESULT checks=139 expected=139 failed=1 subject=%s\n' "$SUBJECT_SHORT" > "$SCRATCH/c8c.txt"
as_selftest REFUSE "C8c failed=1 must refuse" "$SCRATCH/c8c.txt"
printf 'SELFTEST-RESULT checks=139 expected=139 failed=0 skipped=4 subject=%s\n' "$SUBJECT_SHORT" > "$SCRATCH/c8d.txt"
as_selftest REFUSE "C8d an UNKNOWN field added to the line" "$SCRATCH/c8d.txt"
printf 'REPRODUCTION-III-RESULT verdicts=12 expected=12 confirmed=0 refuted=11 classification=3 subject=%s\n' \
  "$SUBJECT_SHORT" > "$SCRATCH/c8e.txt"
as_repro3   REFUSE "C8e repro-III refuted != verdicts" "$SCRATCH/c8e.txt"

echo
echo "  passed ${PASS} · failed ${FAIL}"
if [ "$FAIL" -eq 0 ]; then
  echo "  ALL CONTROLS BEHAVED AS REQUIRED — the gate accepts a correct transcript"
  echo "  and refuses each planted fault.  The green on this tree is now evidence"
  echo "  that something was checked, not evidence that nothing was."
  exit 0
else
  echo "  CONTROL FAILURE — do not report the gate as corrected."
  exit 1
fi
