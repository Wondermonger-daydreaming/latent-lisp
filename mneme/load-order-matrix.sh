#!/usr/bin/env bash
#
# load-order-matrix.sh — exhibit the ASDF load plan for every documented order,
#                        against COMPLETE per-row contracts.
#
#   bash mneme/load-order-matrix.sh          # two teeth, then the 16 real rows
#   bash mneme/load-order-matrix.sh --teeth  # only the bounded induced-failure controls
#
# ---------------------------------------------------------------------------
# WHY THIS EXISTS
# ---------------------------------------------------------------------------
#
# The first version of lisp-plus.asd asserted in a comment that the Stack-A
# chain was entered "exactly once" with each predecessor loaded once. The
# canonical load transcript contained 187 Canonical Datum /0 redefinition
# warnings, and the command exited 0 anyway. A comment is not a trace and an
# exit code is not a clean load, so this script observes instead of asserting.
#
# ---------------------------------------------------------------------------
# WHY IT WAS REBUILT — R2 Correction B
# ---------------------------------------------------------------------------
#
# The R1 version printed a reassuring table and had DEMONSTRATED FALSE-GREEN
# PATHS. Four defects, all fixed here:
#
#   1. `$cd0x` — a typo. The mismatch diagnostic interpolated an undefined
#      variable, so the one message meant to report how many times cd0.lisp
#      loaded printed nothing at all.
#
#   2. REFUSAL ROWS NEVER CHECKED cd0. A refusal that exited nonzero and named
#      its reason passed even if Canonical Datum /0 had been loaded twice — the
#      exact defect this matrix exists to detect could occur on a refusal row
#      and be reported PASS.
#
#   3. REFUSAL ROWS NEVER CHECKED undefined-variable or generic warnings.
#
#   4. THE WARNING CLASSIFIER WAS TOO NARROW. It matched only `caught WARNING`.
#      The 187 redefinitions R1 was commissioned to remove are printed by SBCL
#      as `^WARNING: redefining ...` — a form the old classifier did not match
#      at all. A gate blind to the defect it was built for is not a gate.
#
# A row now passes only by satisfying EVERY clause of its contract. Violations
# accumulate rather than being overwritten by whichever test ran last.
#
# ---------------------------------------------------------------------------
# THE CONTRACTS
# ---------------------------------------------------------------------------
#
#   SUPPORTED row must satisfy ALL of:
#       exit code == expected (0)
#       cd0.lisp loaded exactly the expected number of times
#       zero redefinitions
#       zero undefined-variable diagnostics
#       zero generic/compiler warnings
#       no debugger entry and no unhandled condition
#
#   REFUSAL row must satisfy ALL of:
#       exit code nonzero
#       exactly one `lisp-plus: UNSUPPORTED LOAD ORDER.` report line
#       exactly one unhandled condition
#       that unhandled condition IS  LISP-PLUS-SYSTEM:UNSUPPORTED-LOAD-ORDER
#       zero unrelated unhandled conditions
#       zero debugger entry
#       cd0.lisp loaded exactly once
#       zero redefinitions
#       zero undefined-variable diagnostics
#       zero generic/compiler warnings
#
#   A refusal row is NOT required to be free of `Unhandled`: refusing is
#   implemented as a signalled condition, so exactly one unhandled condition is
#   the intended mechanism. That asymmetry is why the two contracts are spelled
#   out separately instead of shared.
#
# ---------------------------------------------------------------------------
# WHY THE REFUSAL CONTRACT WAS REBUILT — R4 Correction D
# ---------------------------------------------------------------------------
#
# The R3 refusal clause was
#
#     grep -c 'UNSUPPORTED LOAD ORDER'
#
# — a check on VOCABULARY, not on the named condition. Any nonzero failure whose
# output merely CONTAINED that phrase satisfied it: a SIMPLE-ERROR quoting the
# phrase in its message, a docstring echoed into a backtrace, a comment printed
# by an unrelated abort. The matrix would then report the row PASS, and the
# refusal it certified would be a refusal in name only.
#
# The comparator now requires the real named-condition signature — the report
# line AND the unhandled condition's identity AND the absence of any other
# unhandled condition AND the absence of debugger entry.
#
# OBSERVED SIGNATURE, read off a real trace rather than assumed:
#
#     Unhandled LISP-PLUS-SYSTEM:UNSUPPORTED-LOAD-ORDER in thread #<SB-THREAD:...
#     lisp-plus: UNSUPPORTED LOAD ORDER.
#
# NOTE ON THE COLON, recorded because it is a place a check could quietly rot:
# SBCL prints the condition with ONE colon — the symbol is EXTERNAL in
# LISP-PLUS-SYSTEM. The commissioning text wrote it with two. Both spellings
# denote the same symbol, so the pattern accepts `:` or `::` rather than
# hard-coding a form this implementation does not emit; what it will not accept
# is any OTHER condition, or the phrase without the condition.
#
# ---------------------------------------------------------------------------
# THE WARNING CLASSIFIER (all seven required patterns)
# ---------------------------------------------------------------------------
#
#     ^WARNING:              ; caught WARNING        caught [0-9]+ WARNING
#     undefined variable     DEFCONSTANT-UNEQL       debugger invoked
#     ^Unhandled
#
# ---------------------------------------------------------------------------
# THE TEETH
# ---------------------------------------------------------------------------
#
# A gate that has never fired is untested. Six bounded controls run FIRST, on
# synthetic traces rather than real loads, so they are cheap and deterministic:
#
#   T1  a refusal trace that is perfect except cd0=2            must FAIL
#   T2  a supported trace whose only blemish is one generic
#       `WARNING: synthetic non-redefinition warning`           must FAIL
#   T3  a clean supported trace                                 must stay silent
#   T4  an unrelated SIMPLE-ERROR whose prose merely MENTIONS
#       "UNSUPPORTED LOAD ORDER"                                must FAIL
#   T5  a proper named reason accompanied by debugger entry     must FAIL
#   T6  the genuine refusal signature                           must stay silent
#
# T4 is the R3 defect held up to the light: it satisfies the old
# `grep -c 'UNSUPPORTED LOAD ORDER'` clause twice over while being no refusal at
# all, and the tooth prints that old count beside its bite so the gap is visible
# rather than asserted. T6 exists because a comparator strict enough that
# NOTHING can satisfy it is not a comparator; the two live refusal rows in the
# real matrix re-prove satisfiability against the running image.
#
# If a tooth does not bite, this script exits nonzero and refuses to run the
# real matrix: a matrix whose contracts cannot fail proves nothing.
#
# Supported environment: SBCL 2.4.6 on Linux.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
cd "$ROOT"

TEETH_ONLY=0
[ "${1:-}" = "--teeth" ] && TEETH_ONLY=1

TMP="$(mktemp -d "${TMPDIR:-/tmp}/lisp-plus-order-matrix.XXXXXX")"
trap 'rm -rf "$TMP"' EXIT INT TERM

# ===========================================================================
# CLASSIFIER + CONTRACT EVALUATOR  (shared by the real rows and the teeth)
# ===========================================================================
C_CD0=0; C_REDEF=0; C_UNDEF=0; C_GENERIC=0; C_DBG=0; C_UNHANDLED=0; C_REASON=0
C_REPORT=0; C_NAMED=0; C_OTHER_UNH=0

# The named-condition signature. `:` or `::` — see the note on the colon above.
NAMED_RE='^Unhandled LISP-PLUS-SYSTEM::?UNSUPPORTED-LOAD-ORDER([[:space:]]|$)'
REPORT_RE='^lisp-plus: UNSUPPORTED LOAD ORDER\.[[:space:]]*$'

classify_trace() {
  local log="$1"
  C_CD0=$(grep -c 'canonical-datum/common-lisp/cd0\.lisp' "$log" || true)
  C_REDEF=$(grep -ci 'redefining'                         "$log" || true)
  C_UNDEF=$(grep -c 'undefined variable'                  "$log" || true)
  C_DBG=$(grep -c 'debugger invoked'                      "$log" || true)
  C_UNHANDLED=$(grep -cE '^Unhandled'                     "$log" || true)
  # C_REASON is the OLD, insufficient measure. It is kept, and printed, purely
  # so a reader can see the gap the R4 comparator closed: a trace can raise
  # C_REASON while C_REPORT and C_NAMED both stay 0.
  C_REASON=$(grep -c 'UNSUPPORTED LOAD ORDER'             "$log" || true)
  C_REPORT=$(grep -cE "$REPORT_RE"                        "$log" || true)
  C_NAMED=$(grep -cE "$NAMED_RE"                          "$log" || true)
  C_OTHER_UNH=$((C_UNHANDLED - C_NAMED))
  C_GENERIC=$(grep -cE '^WARNING:|; caught WARNING|caught [0-9]+ WARNING|DEFCONSTANT-UNEQL' "$log" || true)
}

# evaluate_contract <supported|refusal> <expected_exit> <expected_cd0> <rc> <log>
# echoes every violation; empty output means the contract held.
evaluate_contract() {
  local kind="$1" exp_exit="$2" exp_cd0="$3" rc="$4" log="$5"
  classify_trace "$log"
  local v=""
  add() { v="${v}${v:+; }$1"; }

  if [ "$kind" = "supported" ]; then
    [ "$rc" -ne "$exp_exit" ]   && add "exit ${rc} != expected ${exp_exit}"
    [ "$C_CD0" -ne "$exp_cd0" ] && add "cd0.lisp loaded ${C_CD0}x, expected ${exp_cd0}"
    [ "$C_REDEF" -ne 0 ]        && add "${C_REDEF} redefinition line(s)"
    [ "$C_UNDEF" -ne 0 ]        && add "${C_UNDEF} undefined-variable line(s)"
    [ "$C_GENERIC" -ne 0 ]      && add "${C_GENERIC} generic/compiler warning line(s)"
    [ "$C_DBG" -ne 0 ]          && add "${C_DBG} debugger entry/entries"
    [ "$C_UNHANDLED" -ne 0 ]    && add "${C_UNHANDLED} unhandled condition(s)"
  else
    [ "$rc" -eq 0 ]             && add "expected a clean refusal, got exit 0"
    # The named-condition identity — NOT the mere presence of the phrase.
    [ "$C_REPORT" -ne 1 ]       && add "${C_REPORT} exact 'lisp-plus: UNSUPPORTED LOAD ORDER.' report line(s), expected exactly 1"
    [ "$C_UNHANDLED" -ne 1 ]    && add "${C_UNHANDLED} unhandled condition(s), expected exactly 1"
    [ "$C_NAMED" -ne 1 ]        && add "${C_NAMED} unhandled LISP-PLUS-SYSTEM:UNSUPPORTED-LOAD-ORDER, expected exactly 1"
    [ "$C_OTHER_UNH" -ne 0 ]    && add "${C_OTHER_UNH} unrelated unhandled condition(s)"
    [ "$C_DBG" -ne 0 ]          && add "${C_DBG} debugger entry/entries"
    [ "$C_CD0" -ne 1 ]          && add "cd0.lisp loaded ${C_CD0}x, expected exactly 1"
    [ "$C_REDEF" -ne 0 ]        && add "${C_REDEF} redefinition line(s)"
    [ "$C_UNDEF" -ne 0 ]        && add "${C_UNDEF} undefined-variable line(s)"
    [ "$C_GENERIC" -ne 0 ]      && add "${C_GENERIC} generic/compiler warning line(s)"
  fi
  printf '%s' "$v"
}

# ===========================================================================
# THE TEETH — bounded, synthetic, run before anything real
# ===========================================================================
echo "==========================================================================="
echo " LOAD-ORDER MATRIX — induced-failure controls (bounded, synthetic traces)"
echo "==========================================================================="
echo
TEETH_FAIL=0

cat > "$TMP/t1.log" <<'EOF'
; loading /x/canonical-datum/common-lisp/cd0.lisp
; loading /x/canonical-datum/common-lisp/cd0.lisp
lisp-plus: UNSUPPORTED LOAD ORDER.
  Something loaded Canonical Datum /0 before Stack A in this image.
Unhandled LISP-PLUS-SYSTEM::UNSUPPORTED-LOAD-ORDER in thread
EOF
t1="$(evaluate_contract refusal 1 1 1 "$TMP/t1.log")"; classify_trace "$TMP/t1.log"
if [ -n "$t1" ]; then
  echo "  T1  refusal trace, cd0=2                      BITES    -> $t1"
else
  echo "  T1  refusal trace, cd0=2                      !! DID NOT BITE"; TEETH_FAIL=1
fi

cat > "$TMP/t2.log" <<'EOF'
; loading /x/canonical-datum/common-lisp/cd0.lisp
WARNING: synthetic non-redefinition warning
; loading /x/mneme/kernel0/load.lisp
EOF
t2="$(evaluate_contract supported 0 1 0 "$TMP/t2.log")"; classify_trace "$TMP/t2.log"
if [ -n "$t2" ]; then
  echo "  T2  supported trace, one generic WARNING      BITES    -> $t2"
else
  echo "  T2  supported trace, one generic WARNING      !! DID NOT BITE"; TEETH_FAIL=1
fi

cat > "$TMP/t3.log" <<'EOF'
; loading /x/canonical-datum/common-lisp/cd0.lisp
; loading /x/mneme/kernel0/load.lisp
EOF
t3="$(evaluate_contract supported 0 1 0 "$TMP/t3.log")"
if [ -z "$t3" ]; then
  echo "  T3  clean supported trace                     silent   (the contract is satisfiable)"
else
  echo "  T3  clean supported trace                     !! FALSE POSITIVE -> $t3"; TEETH_FAIL=1
fi

# --- R4 Correction D: the refusal comparator's own teeth --------------------
# T4 is the returned defect itself. This trace satisfies R3's clause exactly —
# `grep -c 'UNSUPPORTED LOAD ORDER'` returns 2 — while being an ordinary
# SIMPLE-ERROR that merely mentions the phrase in prose. R3 called it a refusal.
cat > "$TMP/t4.log" <<'EOF'
; loading /x/canonical-datum/common-lisp/cd0.lisp
Unhandled SIMPLE-ERROR in thread #<SB-THREAD:THREAD tid=1 "main thread" RUNNING
                                    {1000000000}>:
  the manual's section on UNSUPPORTED LOAD ORDER could not be located,
  which has nothing to do with UNSUPPORTED LOAD ORDER detection
EOF
t4="$(evaluate_contract refusal 1 1 1 "$TMP/t4.log")"; classify_trace "$TMP/t4.log"
if [ -n "$t4" ]; then
  echo "  T4  unrelated SIMPLE-ERROR naming the phrase   BITES    -> $t4"
  echo "        (old vocabulary measure would have passed it: C_REASON=${C_REASON})"
else
  echo "  T4  unrelated SIMPLE-ERROR naming the phrase   !! DID NOT BITE"; TEETH_FAIL=1
fi

# T5 — the right condition, but the image entered the debugger. A refusal that
# drops into the debugger is not the clean named refusal being certified.
cat > "$TMP/t5.log" <<'EOF'
; loading /x/canonical-datum/common-lisp/cd0.lisp
Unhandled LISP-PLUS-SYSTEM:UNSUPPORTED-LOAD-ORDER in thread #<SB-THREAD:THREAD tid=1 "main thread" RUNNING
                                                               {1000000000}>:
lisp-plus: UNSUPPORTED LOAD ORDER.
  Something loaded Canonical Datum /0 before Stack A in this image.
debugger invoked on a LISP-PLUS-SYSTEM:UNSUPPORTED-LOAD-ORDER in thread #<THREAD>
EOF
t5="$(evaluate_contract refusal 1 1 1 "$TMP/t5.log")"
if [ -n "$t5" ]; then
  echo "  T5  named reason WITH debugger entry           BITES    -> $t5"
else
  echo "  T5  named reason WITH debugger entry           !! DID NOT BITE"; TEETH_FAIL=1
fi

# T6 — the genuine refusal signature must remain SATISFIABLE. A comparator so
# strict that nothing can pass it is not a comparator. These lines are copied
# from a real trace, and the two live refusal rows below re-prove it against
# the running image rather than a fixture.
cat > "$TMP/t6.log" <<'EOF'
; loading /x/canonical-datum/common-lisp/cd0.lisp
Unhandled LISP-PLUS-SYSTEM:UNSUPPORTED-LOAD-ORDER in thread #<SB-THREAD:THREAD tid=1 "main thread" RUNNING
                                                               {1000000000}>:

lisp-plus: UNSUPPORTED LOAD ORDER.
  Something loaded Canonical Datum /0 before Stack A in this image.
EOF
t6="$(evaluate_contract refusal 1 1 1 "$TMP/t6.log")"
if [ -z "$t6" ]; then
  echo "  T6  genuine refusal signature                  silent   (the contract is satisfiable)"
else
  echo "  T6  genuine refusal signature                  !! FALSE POSITIVE -> $t6"; TEETH_FAIL=1
fi

echo
if [ "$TEETH_FAIL" -ne 0 ]; then
  echo " TEETH FAILED — the contracts cannot detect the defects they exist for."
  echo " Refusing to run the real matrix: a gate that cannot fail proves nothing."
  echo "==========================================================================="
  exit 1
fi
echo " All controls behaved. The contracts can fail, so a PASS below is evidence."
echo "==========================================================================="
[ "$TEETH_ONLY" -eq 1 ] && exit 0
echo

# ===========================================================================
# THE REAL MATRIX
# ===========================================================================
command -v sbcl >/dev/null 2>&1 || { echo "!! sbcl not on PATH"; exit 127; }
SBCL_VERSION="$(sbcl --noinform --non-interactive \
  --eval '(progn (princ (lisp-implementation-version)) (terpri) (finish-output))' 2>/dev/null | tail -1)"
if [ "$SBCL_VERSION" != "2.4.6" ]; then
  echo "!! FAIL CLOSED: authorized for SBCL 2.4.6 only; observed ${SBCL_VERSION}."
  exit 1
fi

echo "==========================================================================="
echo " LISP+ ASDF LOAD-ORDER MATRIX"
echo " Observed traces against complete contracts. SBCL ${SBCL_VERSION}."
echo " HEAD: $(git rev-parse HEAD 2>/dev/null || echo n/a)"
echo "==========================================================================="
echo

PASS=0; FAIL=0

run_case() {
  local label="$1" kind="$2" exp_exit="$3" exp_cd0="$4"; shift 4
  local log="$TMP/$(echo "$label" | tr -cd '[:alnum:]' | cut -c1-40).log"
  sbcl --noinform --non-interactive \
       --eval '(require :asdf)' \
       --eval '(require :sb-posix)' \
       --eval "(asdf:initialize-source-registry '(:source-registry (:directory \"${ROOT}\") :inherit-configuration))" \
       --eval '(setf *load-verbose* t)' \
       "$@" >"$log" 2>&1
  local rc=$?
  local viol
  viol="$(evaluate_contract "$kind" "$exp_exit" "$exp_cd0" "$rc" "$log")"
  # evaluate_contract ran inside a command-substitution SUBSHELL, so the counters
  # it set are invisible here.  Re-classify in THIS shell so the printed columns
  # are the same numbers the contract was judged on.  Without this a row could
  # print `cd0=0 ... PASS` — a reassuring-but-wrong column, which is precisely
  # the defect class this rebuild exists to remove.  Caught by reading the
  # matrix's own first output rather than trusting the PASS.
  classify_trace "$log"

  printf '  %-50s cd0=%-2s redef=%-3s undef=%-2s warn=%-2s unh=%-2s exit=%-3s %s\n' \
         "$label" "$C_CD0" "$C_REDEF" "$C_UNDEF" "$C_GENERIC" "$C_UNHANDLED" "$rc" \
         "$([ -z "$viol" ] && echo PASS || echo FAIL)"
  if [ -z "$viol" ]; then PASS=$((PASS+1)); else
    FAIL=$((FAIL+1))
    echo "        CONTRACT VIOLATED: $viol"
    echo "        ---- last 8 lines ----"
    tail -8 "$log" | sed 's/^/        /'
  fi
}

L='(asdf:load-system'

echo "-- SUPPORTED orders: exit 0 · exact cd0 · zero redef/undef/warn · no debugger --"
run_case "umbrella: lisp-plus"                       supported 0 1 --eval "$L \"lisp-plus\")"
run_case "lisp-plus/stack-a alone"                   supported 0 1 --eval "$L \"lisp-plus/stack-a\")"
run_case "lisp-plus/cd0 alone"                       supported 0 1 --eval "$L \"lisp-plus/cd0\")"
run_case "lisp-plus/surface1 alone (CD/0-only lane)" supported 0 1 --eval "$L \"lisp-plus/surface1\")"
run_case "lisp-plus/form0 alone (CD/0-only lane)"    supported 0 1 --eval "$L \"lisp-plus/form0\")"
run_case "lisp-plus/form2 alone (CD/0-only lane)"    supported 0 1 --eval "$L \"lisp-plus/form2\")"
run_case "lisp-plus/slice2 alone (Stack-B chain)"    supported 0 1 --eval "$L \"lisp-plus/slice2\")"
run_case "lisp-plus/surface2 alone (the seam)"       supported 0 1 --eval "$L \"lisp-plus/surface2\")"
run_case "lisp-plus/vertical0 alone"                 supported 0 1 --eval "$L \"lisp-plus/vertical0\")"
run_case "lisp-plus/surface-account alone (CD/0-only lane)" supported 0 1 --eval "$L \"lisp-plus/surface-account\")"
run_case "stack-a THEN cd0"                          supported 0 1 --eval "$L \"lisp-plus/stack-a\")" --eval "$L \"lisp-plus/cd0\")"
run_case "stack-a THEN umbrella"                     supported 0 1 --eval "$L \"lisp-plus/stack-a\")" --eval "$L \"lisp-plus\")"
run_case "umbrella TWICE in one image"               supported 0 1 --eval "$L \"lisp-plus\")" --eval "$L \"lisp-plus\")"
run_case "umbrella THEN a CD/0-only lane"            supported 0 1 --eval "$L \"lisp-plus\")" --eval "$L \"lisp-plus/form2\")"

echo
echo "-- UNSUPPORTED orders: nonzero · named reason · cd0=1 · zero redef/undef/warn --"
run_case "cd0 FIRST, then stack-a"                   refusal   1 1 --eval "$L \"lisp-plus/cd0\")" --eval "$L \"lisp-plus/stack-a\")"
run_case "form2 FIRST, then umbrella"                refusal   1 1 --eval "$L \"lisp-plus/form2\")" --eval "$L \"lisp-plus\")"

echo
echo "==========================================================================="
echo " rows: $((PASS+FAIL))   passed: $PASS   failed: $FAIL"
echo
echo " Each row satisfied EVERY clause of its contract, not merely the clauses"
echo " that happened to be printed. 'cd0=1' is an observation from a"
echo " *load-verbose* trace, not an inference."
echo "==========================================================================="
[ "$FAIL" -eq 0 ] || { echo; echo "LOAD-ORDER MATRIX: FAIL"; exit 1; }
echo
echo "LOAD-ORDER MATRIX: PASS"
exit 0
