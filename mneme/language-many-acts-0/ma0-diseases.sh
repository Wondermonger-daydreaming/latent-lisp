#!/usr/bin/env bash
#
# ma0-diseases.sh — MANY ACTS /0 PLANTED DISEASES (FAILURE MATRIX §5).
#
# CANDIDATE.  Running a candidate is not adopting it (contract §0, §8), and
# nothing this script prints is independent verification (AP0 adoption Rider 2).
#
# The five diseases the failure matrix names, each planted in a DISPOSABLE
# REPLICA of the subject tree under $TMPDIR — never in the checkout — and each
# required to make a NAMED check of a paired witness go RED.  Every disease is
# preceded by its CONTROL ARM: the same witness on an UNMUTATED replica, which
# must be GREEN.  A column of red proves only that the witness reddens.
#
#   D-BOTH-ARMS      the branch evaluator runs EVERY arm instead of the selected
#                    one -> ma0-selftest, named check
#                    "w-branch-one: summary-count=0"
#
#   D-AMBIENT        an unoccupied authority slot is filled from a DYNAMIC
#                    VARIABLE -> ma0-selftest, named check
#                    "w-auth-unfilled: refused type=..."
#
#   D-AUTO-RETRY     an act whose disposition is :interrupted or :mint-refused
#                    is RE-INVOKED blind -> ma0-selftest, named check
#                    "p2-alpha exit code" (the adopted lane's own identity/seat
#                    law refuses the second invocation and the condition
#                    propagates out of the run)
#
#   D-SKIP-VALIDATE  the validator's atom scan and step check are skipped, so
#                    unvalidated source is evaluated -> ma0-footprint-witness,
#                    named check "W-V-FOOTPRINT the invalid program appended
#                    NOTHING to the live store"; ALSO exhibited on ma0-selftest,
#                    named check "W-V-SHAPE dotted pair".
#                    ⚠ THE NAMED CHECK WAS CHOSEN BY RUNNING, NOT BY READING.
#                    "W-V-SHAPE unknown program head" was the first candidate
#                    and it STAYS GREEN under this disease: the head test lives
#                    in `ma0-validate' itself, not in the two functions the
#                    mutation removes.  The checks that go red are exactly the
#                    ones `%ma0-scan-atoms' and `%ma0-check-steps' own — the
#                    dotted pair, the bare ident, the whole W-V-DATA and W-V-PKG
#                    families — so a check that survives the mutation is named
#                    here as surviving rather than quietly swapped out.
#
#   D-SPECIAL-CASE   the evaluator dispatches on a PROGRAM NAME and
#                    short-circuits P1's second derive -> ma0-selftest, named
#                    check "W-GENERIC ma0-eval.lisp names no program and no
#                    fixture identity"
#
# ⚠ A MUTATION THAT FAILS TO APPLY IS ITS OWN FAILURE.  Every patch asserts its
# anchor appears exactly once; a silently unapplied patch would otherwise report
# "disease not detected" against a healthy replica.
#
# ⚠ THE CHECKOUT'S PORCELAIN is snapshotted before and after and compared
# UNCONDITIONALLY whenever a repository exists ("no git repository" and "clean
# git repository" are different states).
#
# ⚠ FOUR COUNTS, NEVER INTERCHANGEABLE (R1 adoption Rider 6, 2026-08-10):
#     FIVE   named disease FAMILIES — D-BOTH-ARMS, D-AMBIENT, D-AUTO-RETRY,
#            D-SKIP-VALIDATE, D-SPECIAL-CASE (the rows above).
#     SIX    disease/control INVOCATIONS ($PAIRS) — D-SKIP-VALIDATE is exhibited
#            on BOTH of its witnesses, so it runs twice.
#     SIX    CONTROL arms, one per invocation.
#     TWELVE witness executions (6 control + 6 diseased), reported as 12 checks.
#   The family count and the invocation count may never be substituted for each
#   other, in this file or in any document that quotes it.
#
# Exit 0 iff ALL SIX invocations were DETECTED and ALL SIX of their controls were
# CLEAN — the exit test is `DETECTED == PAIRS && CONTROLS == PAIRS', over
# invocations, not over families.
#
# Sentinel: ma0-diseases: 5 diseases detected, 6 controls clean
#           ( <PAIRS> disease/control PAIRS: D-SKIP-VALIDATE is exhibited on BOTH
#             of its witnesses )
#   ⚠ THE TWO NUMBERS ARE DIFFERENT QUANTITIES.  The FIRST is the disease FAMILY
#   count (5, a constant).  The SECOND is the count of CONTROL ARMS that ran
#   clean — one per INVOCATION, so 6 — and it is printed from the counter the run
#   incremented, not from the family constant.  Until Parcel B item B2 it was
#   printed from `DISEASE_COUNT' and therefore read "5 controls clean" while six
#   control arms had in fact run clean.  The ten frozen R1 captures and every
#   transcript taken before that repair record the old output and are NEVER
#   regenerated: a repaired instrument and a frozen capture of its former output
#   are permitted to differ.
#
# — DENS (Claude Opus 5, subagent), 2026-08-09

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"            # experiments/latent-lisp
LANE="mneme/language-many-acts-0"
PER_CASE_TIMEOUT="${MA0_DISEASE_TIMEOUT:-900}"

SBCL_VERSION="$(sbcl --noinform --non-interactive \
  --eval '(progn (princ (lisp-implementation-version)) (terpri) (finish-output))' 2>/dev/null | tail -1)"
[ "$SBCL_VERSION" = "2.4.6" ] || { echo "!! FAIL CLOSED: SBCL 2.4.6 only (got $SBCL_VERSION)"; exit 1; }
echo "== ma0-diseases — SBCL $SBCL_VERSION =="
echo "   subject tree: $ROOT"

HAVE_GIT=0
GIT_BEFORE=""
if git -C "$ROOT" rev-parse --git-dir >/dev/null 2>&1; then
  HAVE_GIT=1
  GIT_BEFORE="$(git -C "$ROOT" status --porcelain 2>/dev/null)"
fi

SCRATCH="$(mktemp -d "${TMPDIR:-/tmp}/ma0-disease.XXXXXX")"
trap 'rm -rf "$SCRATCH"' EXIT INT TERM
REPLICA="$SCRATCH/tree"

FAILED=0
DETECTED=0
CONTROLS=0
PAIRS=0

make_replica() {
  rm -rf "$REPLICA"; mkdir -p "$REPLICA"
  rsync -a --exclude '.git/' \
           --exclude 'canonical-datum/evidence/' \
           --exclude 'canonical-datum/generated/' \
           "$ROOT"/ "$REPLICA"/
}

py_patch() {  # py_patch FILE OLD NEW — exact-string patch, must hit exactly once
  python3 - "$1" "$2" "$3" <<'EOF'
import sys, pathlib
f, old, new = pathlib.Path(sys.argv[1]), sys.argv[2], sys.argv[3]
t = f.read_text()
n = t.count(old)
if n != 1:
    print(f"!! patch anchor found {n} times (want 1) in {f}"); sys.exit(1)
f.write_text(t.replace(old, new))
EOF
}

# run_disease NAME MUTATE-FN WITNESS-CMD MUST-MATCH-REGEX
run_disease() {
  local name="$1" mutate="$2" witness="$3" must="$4"
  PAIRS=$((PAIRS + 1))
  echo
  echo "-- $name  /  witness: $witness --"

  # ---- CONTROL ARM: unmutated replica, the witness must be GREEN.
  make_replica
  local clog="$SCRATCH/${name}-control.log"
  ( cd "$REPLICA" && timeout "$PER_CASE_TIMEOUT" bash -c "$witness" ) >"$clog" 2>&1
  local crc=$?
  if [ "$crc" -eq 0 ]; then
    echo "  [PASS] control: the witness is GREEN on an unmutated replica"
    grep -E "^ma0-(selftest|footprint-witness):" "$clog" | sed 's/^/           /'
    CONTROLS=$((CONTROLS + 1))
  else
    echo "  [FAIL] control: the witness did NOT pass on an unmutated replica (exit $crc)"
    grep -E "^\s+\[FAIL\]" "$clog" | head -8 | sed 's/^/         /'
    tail -3 "$clog" | sed 's/^/         /'
    FAILED=1
  fi

  # ---- DISEASED ARM.
  make_replica
  if ! "$mutate"; then
    echo "  [FAIL] $name: the mutation itself did not apply (stale anchor?) — comparator void"
    FAILED=1
    return
  fi
  local dlog="$SCRATCH/${name}-disease.log"
  ( cd "$REPLICA" && timeout "$PER_CASE_TIMEOUT" bash -c "$witness" ) >"$dlog" 2>&1
  local drc=$?
  local hit
  hit="$(grep -E "$must" "$dlog" | head -3 || true)"
  if [ "$drc" -ne 0 ] && [ -n "$hit" ]; then
    echo "  [PASS] $name DETECTED — the named check went RED (exit $drc):"
    echo "$hit" | sed 's/^/           /'
    DETECTED=$((DETECTED + 1))
  elif [ "$drc" -ne 0 ]; then
    echo "  [FAIL] $name: the witness failed (exit $drc) but WITHOUT the named check"
    echo "         wanted a line matching: $must"
    grep -E "^\s+\[FAIL\]" "$dlog" | head -8 | sed 's/^/         /'
    FAILED=1
  else
    echo "  [FAIL] $name NOT detected — the witness stayed GREEN over damaged source"
    FAILED=1
  fi
}

SELFTEST="sbcl --script $LANE/ma0-selftest.lisp"
FOOTPRINT="sbcl --script $LANE/ma0-footprint-witness.lisp"

# ---------------------------------------------------------------------------
# D-BOTH-ARMS — the selection law deleted: every arm's steps are evaluated.
# ---------------------------------------------------------------------------
mutate_both_arms() {
  py_patch "$REPLICA/$LANE/ma0-eval.lisp" \
'    (dolist (clause clauses)
      (when (%ma0-pattern-holds-p class value (first clause))
        (return-from %ma0-run-branch (%ma0-run-steps run (rest clause)))))
    (%ma0-run-steps run (rest other))))' \
'    ;; DISEASED (D-BOTH-ARMS): EVERY arm is evaluated; the first terminal wins.
    (let ((terminal nil))
      (dolist (clause clauses)
        (let ((reached (%ma0-run-steps run (rest clause))))
          (unless terminal (setf terminal reached))))
      (let ((reached (%ma0-run-steps run (rest other))))
        (or terminal reached)))))'
}
run_disease "D-BOTH-ARMS" mutate_both_arms "$SELFTEST" \
  '\[FAIL\] w-branch-one: summary-count=0'

# ---------------------------------------------------------------------------
# D-AMBIENT — an unoccupied authority slot filled from a dynamic variable.
# ---------------------------------------------------------------------------
mutate_ambient() {
  py_patch "$REPLICA/$LANE/ma0-eval.lisp" \
'(defun %ma0-run-act-step (run step)' \
'(defvar *ma0-ambient-authority* t
  "DISEASED (D-AMBIENT): the dynamic variable an act step falls back to when
its declared slot is unoccupied.")

(defun %ma0-run-act-step (run step)' && \
  py_patch "$REPLICA/$LANE/ma0-eval.lisp" \
'    (unless (%ma0-slot-occupied-p environment (symbol-name slot) arm)' \
'    ;; DISEASED (D-AMBIENT): the ambient fallback.
    (unless (or (%ma0-slot-occupied-p environment (symbol-name slot) arm)
                *ma0-ambient-authority*)'
}
run_disease "D-AMBIENT" mutate_ambient "$SELFTEST" \
  '\[FAIL\] w-auth-unfilled: refused type='

# ---------------------------------------------------------------------------
# D-AUTO-RETRY — an uncertain or refused act is re-invoked blind.
# ---------------------------------------------------------------------------
mutate_auto_retry() {
  py_patch "$REPLICA/$LANE/ma0-eval.lisp" \
'           (result (lisp-plus-language-act0:run-act fixture :verbose nil))' \
'           ;; DISEASED (D-AUTO-RETRY): an act that did not return cleanly is
           ;; invoked a second time, blind.
           (result (let ((once (lisp-plus-language-act0:run-act
                                fixture :verbose nil)))
                     (if (member (getf once :disposition)
                                 (list :interrupted :mint-refused))
                         (lisp-plus-language-act0:run-act fixture :verbose nil)
                         once)))'
}
run_disease "D-AUTO-RETRY" mutate_auto_retry "$SELFTEST" \
  '\[FAIL\] p2-alpha exit code'

# ---------------------------------------------------------------------------
# D-SKIP-VALIDATE — unvalidated source is evaluated.  Exhibited on BOTH
# witnesses: the program-level footprint (the matrix's own red condition) and
# the lane's validator family.
# ---------------------------------------------------------------------------
mutate_skip_validate() {
  py_patch "$REPLICA/$LANE/ma0-validate.lisp" \
'    (%ma0-scan-atoms form)' \
'    ;; DISEASED (D-SKIP-VALIDATE): the atom scan is skipped.' && \
  py_patch "$REPLICA/$LANE/ma0-validate.lisp" \
'        (%ma0-check-steps ctx (rest steps-clause) "the program'"'"'s :steps")' \
'        ;; DISEASED (D-SKIP-VALIDATE): the step check is skipped.'
}
run_disease "D-SKIP-VALIDATE" mutate_skip_validate "$FOOTPRINT" \
  '\[FAIL\] W-V-FOOTPRINT the invalid program appended NOTHING'
run_disease "D-SKIP-VALIDATE" mutate_skip_validate "$SELFTEST" \
  '\[FAIL\] W-V-SHAPE dotted pair'

# ---------------------------------------------------------------------------
# D-SPECIAL-CASE — the evaluator dispatches on a program NAME.
# ---------------------------------------------------------------------------
mutate_special_case() {
  py_patch "$REPLICA/$LANE/ma0-eval.lisp" \
'(defun %ma0-run-derive-step (run step)' \
'(defparameter *ma0-special-case-program* "editio"
  "DISEASED (D-SPECIAL-CASE): the program name the evaluator dispatches on.")

(defun %ma0-run-derive-step (run step)
  ;; DISEASED (D-SPECIAL-CASE): that program'"'"'s SECOND derivation is
  ;; short-circuited to its first, selected by the program NAME.
  (when (and (equal *ma0-special-case-program*
                    (ma0-program-name (%ma0-run-program run)))
             (string= "POST" (symbol-name (second step))))
    (let ((row (gethash (find-symbol "PRE" (symbol-package (second step)))
                        (%ma0-run-bindings run))))
      (when row
        (%ma0-bind run (second step) :outcome (cdr row))
        (return-from %ma0-run-derive-step (cdr row)))))'
}
run_disease "D-SPECIAL-CASE" mutate_special_case "$SELFTEST" \
  '\[FAIL\] W-GENERIC ma0-eval.lisp names no program'

# ---------------------------------------------------------------------------
echo
if [ "$HAVE_GIT" -eq 1 ]; then
  GIT_AFTER="$(git -C "$ROOT" status --porcelain 2>/dev/null)"
  if [ "$GIT_BEFORE" = "$GIT_AFTER" ]; then
    echo "-- the checkout's porcelain is UNCHANGED: the diseases lived and died in the replica --"
  else
    echo "!! FAIL CLOSED: the checkout changed during the disease run"
    diff <(printf '%s\n' "$GIT_BEFORE") <(printf '%s\n' "$GIT_AFTER") | sed 's/^/   /' || true
    FAILED=1
  fi
else
  echo "-- not a git checkout: the cleanliness comparison is NOT APPLICABLE here; it is not being skipped silently --"
fi

echo
# D-SKIP-VALIDATE is exhibited on two witnesses; the DISEASE FAMILY count is five
# (a constant), and the CONTROL count is one per INVOCATION — counted, never
# assumed, and printed from the counter the run incremented (Parcel B item B2;
# R1 adoption Rider 6 forbids substituting either count for the other).
DISEASE_COUNT=5
if [ "$FAILED" -eq 0 ] && [ "$DETECTED" -eq "$PAIRS" ] && [ "$CONTROLS" -eq "$PAIRS" ]; then
  echo "ma0-diseases: $DISEASE_COUNT diseases detected, $CONTROLS controls clean"
  echo "  ($PAIRS disease/control PAIRS: D-SKIP-VALIDATE is exhibited on BOTH of its witnesses)"
  exit 0
fi
echo "ma0-diseases: FAILED (detections $DETECTED/$PAIRS, controls $CONTROLS/$PAIRS)"
exit 1
