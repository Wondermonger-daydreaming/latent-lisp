#!/usr/bin/env bash
#
# surface-account-disease.sh — Surface Account /0 production DISEASE
# COMPARATORS (R4 Phase 4).  Eight mutations, each attacking one named risk,
# each applied to a DISPOSABLE REPLICA of the tree (never to the checkout),
# each required to make the corresponding PRODUCTION gate FAIL — this is
# what proves the new suite tests the product rather than admiring the
# oracle.  The frozen probe lane is byte-verified untouched in every
# replica (the mutation damages production only).
#
#   D1  production ASDF component omitted        -> graph gate GG-4 FAILS
#   D2  disposition finality regressed           -> post-publication role FAILS
#       (the cleanup's CAS-from-NIL replaced by an unconditional overwrite:
#        publication is no longer final)
#   D3  reserved-slot presence reduced to a      -> carrier role FAILS
#       VALUE test (a NIL-valued indicator reads as absence — the R3.3.1
#       GETF revenant)
#   D4  carrier walk made NON-TOTAL              -> carrier role FAILS
#       (a dotted terminal tail read as a lawful end — the R3.3.2 revenant;
#        the circular arm is backstopped by the process timeout)
#   D5  Surface /2 inhabitance DISCONNECTED      -> inhabited gate FAILS
#       (the runtime /0 mint replaced by a fixed literal tag; the
#        SA0-S2-EPOCH-LINKAGE check is the named check that must fire)
#   D6  readiness guard REVERTED to package       -> post-election role FAILS
#       existence (R4.1; the half-load-certifying guard STRANGER
#       convicted — the fixed H-checks must catch its return)
#   D7  the R4.2 defect RESTORED (R4.3): the      -> loader-witness case
#       status-blind FBOUNDP-only predicate          internal-dummies FAILS
#       (FIND-SYMBOL's second value discarded,       by named check (the
#       carrier clause dropped) in BOTH homes        export-census check)
#       (load.lisp + lisp-plus.asd) AND the
#       absent-only package.lisp skip — the owner's
#       R4-READINESS-GUARD-ACCEPTS-NONEXTERNAL-API
#       counterexample must be CAUGHT again
#   D8  an export's defun REMOVED from the        -> loader-witness case
#       implementation (renamed away) — the          empty-package FAILS with
#       loader's R4.3 POST-LOAD ASSERTION must       the assertion's named
#       fire (a load path that completes with an     refusal text
#       incomplete API must refuse to certify)
#
# For every disease: the SAME gate is first shown PASSING on an unmutated
# replica copy of the current tree (the control arm — a column of refusals
# would otherwise prove only that the gate refuses everything), except
# where the clean gate already ran green in this session's floor evidence
# and the replica is byte-identical; here the control arm is always run,
# per replica, so this script is self-contained.
#
# NEVER commits, never touches the checkout: replicas live under a scratch
# root OUTSIDE the tree.  When run against a git checkout, the checkout's
# porcelain is snapshotted before and after and compared UNCONDITIONALLY
# (R4.1); when run from a non-git disposable copy the comparison is not
# applicable and says so — it is never silently skipped as if it had run.
#
# Exit 0 iff all eight diseases were DETECTED and all eight controls PASSED.
# Sentinel: surface-account-disease: 8 diseases detected, 8 controls clean
#
# — FABER (Claude Fable 5), R4, 2026-08-06; D7/D8 FABER-II, R4.3

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../../.." && pwd)"           # experiments/latent-lisp
PROD="mneme/language-surface-account-0/production"

SBCL_VERSION="$(sbcl --noinform --non-interactive \
  --eval '(progn (princ (lisp-implementation-version)) (terpri) (finish-output))' 2>/dev/null | tail -1)"
[ "$SBCL_VERSION" = "2.4.6" ] || { echo "!! FAIL CLOSED: SBCL 2.4.6 only (got $SBCL_VERSION)"; exit 1; }

# R4.1 (LECTOR Finding 2): "no git repository" and "clean git repository"
# are DIFFERENT states — a clean tree's porcelain is the empty string, so a
# guard keyed on string-nonemptiness skipped the promised comparison in
# exactly the modes this round runs in.  HAVE_GIT now carries the mode and
# the comparison runs UNCONDITIONALLY whenever a repository exists.
# Tooth: SA0_DISEASE_PLANT_DIRT=1 plants a stray file before the final
# comparison, which must then FAIL CLOSED (run this tooth only against a
# scratch checkout — the planted file is left for the failure to exhibit).
HAVE_GIT=0
GIT_BEFORE=""
if git -C "$ROOT" rev-parse --git-dir >/dev/null 2>&1; then
  HAVE_GIT=1
  GIT_BEFORE="$(git -C "$ROOT" status --porcelain 2>/dev/null)"
fi

SCRATCH="$(mktemp -d "${TMPDIR:-/tmp}/sa0-disease.XXXXXX")"
trap 'rm -rf "$SCRATCH"' EXIT INT TERM
REPLICA="$SCRATCH/tree"

FAILED=0
DETECTED=0
CONTROLS=0

probes_digest() {  # digest of the frozen probe lane in a given tree
  (cd "$1/mneme/language-surface-account-0/probes" && \
   find . -type f | LC_ALL=C sort | xargs sha256sum | sha256sum | cut -d' ' -f1)
}
REAL_PROBES="$(probes_digest "$ROOT")"

make_replica() {
  rm -rf "$REPLICA"; mkdir -p "$REPLICA"
  rsync -a --exclude '.git/' \
           --exclude 'canonical-datum/evidence/' \
           --exclude 'canonical-datum/generated/' \
           "$ROOT"/ "$REPLICA"/
}

verify_probes_untouched() {
  local got; got="$(probes_digest "$REPLICA")"
  if [ "$got" = "$REAL_PROBES" ]; then
    echo "     probes/ byte-verified untouched in the replica"
  else
    echo "  [FAIL] the mutation reached the frozen probe lane"; FAILED=1
  fi
}

run_disease() {
  local name="$1" mutate="$2" gate="$3" must_name="$4" tmo="${5:-300}"
  echo "-- $name --"
  # control arm: unmutated replica, gate must PASS
  make_replica
  local clog="$SCRATCH/${name}-control.log"
  ( cd "$REPLICA" && timeout "$tmo" bash -c "$gate" ) >"$clog" 2>&1
  if [ $? -eq 0 ]; then
    echo "  [PASS] control: the gate is GREEN on the unmutated replica"
    CONTROLS=$((CONTROLS+1))
  else
    echo "  [FAIL] control: gate failed on the UNMUTATED replica (gate broken, not disease)"
    tail -5 "$clog" | sed 's/^/     /'
    FAILED=1
  fi
  # diseased arm.  A mutation that fails to apply (e.g. a stale patch
  # anchor) is ITS OWN failure — without this, a silently unapplied patch
  # reports "disease not detected" against a healthy replica (lived, R4.1:
  # the D1 anchor went stale against the new umbrella row shape and the
  # mutation failed without a word).
  if ! "$mutate"; then
    echo "  [FAIL] the mutation itself did not apply (stale anchor?) — comparator void"
    FAILED=1
    return
  fi
  verify_probes_untouched
  local dlog="$SCRATCH/${name}-diseased.log"
  ( cd "$REPLICA" && timeout "$tmo" bash -c "$gate" ) >"$dlog" 2>&1
  local rc=$?
  if [ $rc -ne 0 ] && { [ -z "$must_name" ] || grep -Eq "$must_name" "$dlog"; }; then
    echo "  [PASS] disease DETECTED (exit $rc${must_name:+; named check '$must_name' present})"
    DETECTED=$((DETECTED+1))
  elif [ $rc -ne 0 ]; then
    echo "  [FAIL] gate failed but WITHOUT the named check '$must_name' (exit $rc)"
    tail -8 "$dlog" | sed 's/^/     /'
    FAILED=1
  else
    echo "  [FAIL] disease NOT detected — the gate stayed green over damaged production source"
    FAILED=1
  fi
}

py_patch() {  # py_patch FILE OLD NEW  — exact-string patch, must hit exactly once
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

# ---------------------------------------------------------------------------
mutate_d1() {  # remove the lane's umbrella row (R4.1 row shape)
  py_patch "$REPLICA/lisp-plus.asd" \
"    ((:predicate surface-account-api-complete-p)
     . \"mneme/language-surface-account-0/production/load.lisp\"))" \
"    )"
}
run_disease "D1 ASDF component omitted" mutate_d1 \
  "bash $PROD/surface-account-graph-gate.sh" \
  "\[FAIL\] GG-4" 600

# ---------------------------------------------------------------------------
mutate_d2() {  # finality regression: cleanup overwrites the disposition slot
  py_patch "$REPLICA/$PROD/surface-account.lisp" \
"      (when claimed
        (sb-ext:cas (svref candidate 4)
                    nil
                    (sa0-make-init-failure" \
"      (when claimed
        (setf (svref candidate 4)
              (sa0-make-init-failure"
}
run_disease "D2 disposition finality regressed" mutate_d2 \
  "SA0_PROD_ROLE=post-publication sbcl --script $PROD/surface-account-hostile.lisp" \
  "FAIL .*(STATE is present|NO failure marker)" 300

# ---------------------------------------------------------------------------
mutate_d3() {  # presence reduced to a value test (the GETF revenant)
  py_patch "$REPLICA/$PROD/surface-account.lisp" \
"                     (when (eq 'sa0-identity-cell (car tail))
                       (when (zerop count) (setf value (car rest)))
                       (incf count))" \
"                     (when (and (eq 'sa0-identity-cell (car tail))
                                (car rest))
                       (when (zerop count) (setf value (car rest)))
                       (incf count))"
}
run_disease "D3 reserved-slot presence reduced to a value test" mutate_d3 \
  "SA0_PROD_ROLE=carrier sbcl --script $PROD/surface-account-hostile.lisp" \
  "FAIL .*NIL-valued indicator" 300

# ---------------------------------------------------------------------------
mutate_d4() {  # non-total walk: dotted terminal tail read as a lawful end
  py_patch "$REPLICA/$PROD/surface-account.lisp" \
"               ;; (1) AN IMPROPER (DOTTED) TERMINAL TAIL.
               ((not (consp tail))
                (sa0-reject-carrier
                 \"the carrier's property list is MALFORMED — after ~D complete ~
                  pair(s) its tail is the non-NIL atom ~S rather than NIL, so ~
                  it is not a property list and no reader can say what any ~
                  indicator on it is worth\"
                 pairs tail))" \
"               ;; (1) DISEASED: the dotted tail read as a lawful end.
               ((not (consp tail)) (return))"
}
run_disease "D4 carrier walk made non-total" mutate_d4 \
  "SA0_PROD_ROLE=carrier sbcl --script $PROD/surface-account-hostile.lisp" \
  "FAIL .*dotted" 300

# ---------------------------------------------------------------------------
mutate_d5() {  # inhabitance disconnected: the FIRST runtime mint replaced by a literal
  py_patch "$REPLICA/$PROD/surface-account-inhabited.lisp" \
"(multiple-value-bind (d1 c1)
    (lisp-plus-surface-account:mint-performance-identifier)" \
"(multiple-value-bind (d1 c1)
    (values (lisp-plus-cd0:make-identifier-datum
             '(\"lisp-plus-surface-account\")
             (list \"performance\"
                   \"00000000000000000000000000000000\" \"1\"))
            1)"
}
run_disease "D5 inhabitance disconnected (literal tag)" mutate_d5 \
  "sbcl --script $PROD/surface-account-inhabited.lisp" \
  "SA0-S2-EPOCH-LINKAGE\] FAIL" 600

# ---------------------------------------------------------------------------
# The loader's guarded tail, verbatim (the D6/D7 mutations rewrite it, so
# they anchor on the exact current text; a stale anchor is its own failure).
LOADER_TAIL='  (unless (funcall api-complete-p)
    ;; REPAIR, not absent-only (R4.3): package.lisp is applied whether the
    ;; package is absent or present-but-incomplete.  DEFPACKAGE on an
    ;; existing package finds/creates the nine symbols (identity preserved)
    ;; and exports them; any genuine name conflict (a package USING this one
    ;; with a clashing symbol) signals and propagates — fail closed.
    (load (merge-pathnames "package.lisp" here))
    (load (merge-pathnames "surface-account.lisp" here))
    ;; The post-load assertion (R4.3): the backstop.  Leaving this load path
    ;; normally with an incomplete public API or an absent carrier must be
    ;; impossible.  Loading the implementation rebinds every export
    ;; unconditionally (all nine are top-level DEFUNs there), so the one way
    ;; to reach this point incomplete is a damaged implementation — refuse.
    (unless (funcall api-complete-p)
      (error "SURFACE-ACCOUNT/0: the production loader completed its load ~
              path but the post-load completeness assertion FAILED — the ~
              public API is not nine external fbound symbols with the ~
              identity carrier present.  The lane is NOT loaded; refusing ~
              to certify it."))))'

mutate_d6() {  # revert the loader's guard to bare package existence (R4.0)
  py_patch "$REPLICA/$PROD/load.lisp" \
"$LOADER_TAIL" \
"  (unless (find-package '#:lisp-plus-surface-account)
    (load (merge-pathnames \"package.lisp\" here))
    (load (merge-pathnames \"surface-account.lisp\" here))))"
}
run_disease "D6 readiness guard reverted to package existence (the half-load certifier)" mutate_d6 \
  "SA0_PROD_ROLE=post-election sbcl --script $PROD/surface-account-hostile.lisp" \
  "FAIL .*a later LOADER is refused" 300

# ---------------------------------------------------------------------------
# The shared predicate core's per-name clause, verbatim, at each home's
# indentation (GG-5 keeps the two homes token-identical, so these anchors
# are the same tokens twice).
CORE_CLAUSE_LOAD='                  (every (lambda (name)
                           (multiple-value-bind (symbol status)
                               (find-symbol name package)
                             (and symbol
                                  (eq status :external)
                                  (fboundp symbol))))'
CORE_CLAUSE_ASD='         (every (lambda (name)
                  (multiple-value-bind (symbol status)
                      (find-symbol name package)
                    (and symbol
                         (eq status :external)
                         (fboundp symbol))))'
CARRIER_CLAUSE_LOAD='                  (not (null (find-symbol "SA0-IDENTITY-CARRIER" package)))
'
CARRIER_CLAUSE_ASD='         (not (null (find-symbol "SA0-IDENTITY-CARRIER" package)))
'

mutate_d7() {  # restore the R4.2 defect: status-blind predicate (both homes)
               # + absent-only package.lisp skip + no post-load assertion
  py_patch "$REPLICA/$PROD/load.lisp" "$CARRIER_CLAUSE_LOAD" "" && \
  py_patch "$REPLICA/$PROD/load.lisp" \
"$CORE_CLAUSE_LOAD" \
'                  (every (lambda (name)
                           (let ((symbol (find-symbol name package)))
                             (and symbol (fboundp symbol))))' && \
  py_patch "$REPLICA/$PROD/load.lisp" \
"$LOADER_TAIL" \
"  (unless (funcall api-complete-p)
    (unless (find-package '#:lisp-plus-surface-account)
      (load (merge-pathnames \"package.lisp\" here)))
    (load (merge-pathnames \"surface-account.lisp\" here))))" && \
  py_patch "$REPLICA/lisp-plus.asd" "$CARRIER_CLAUSE_ASD" "" && \
  py_patch "$REPLICA/lisp-plus.asd" \
"$CORE_CLAUSE_ASD" \
'         (every (lambda (name)
                  (let ((symbol (find-symbol name package)))
                    (and symbol (fboundp symbol))))'
}
run_disease "D7 status-blind predicate + package-existence skip restored (the owner's R4.3 counterexample)" mutate_d7 \
  "SA0_LOADER_CASE=internal-dummies sbcl --script $PROD/surface-account-loader-witness.lisp" \
  "FAIL .*the export census is EXACTLY the nine declared names" 600

# ---------------------------------------------------------------------------
mutate_d8() {  # remove one export's defun: the post-load assertion must fire
  py_patch "$REPLICA/$PROD/surface-account.lisp" \
"(defun lawful-counter-text-p (c)" \
"(defun lawful-counter-text-p-diseased (c)"
}
run_disease "D8 an export's defun removed — the loader's post-load completeness assertion must fire" mutate_d8 \
  "SA0_LOADER_CASE=empty-package sbcl --script $PROD/surface-account-loader-witness.lisp" \
  "post-load completeness assertion FAILED" 300

# ---------------------------------------------------------------------------
if [ "${SA0_DISEASE_PLANT_DIRT:-0}" = "1" ]; then
  # the cleanliness tooth: dirty the checkout on purpose; the comparison
  # below must fire.  Scratch-checkout use only.
  touch "$ROOT/sa0-disease-dirt-tooth"
fi
if [ "$HAVE_GIT" -eq 1 ]; then
  GIT_AFTER="$(git -C "$ROOT" status --porcelain 2>/dev/null)"
  if [ "$GIT_BEFORE" != "$GIT_AFTER" ]; then
    echo "!! FAIL CLOSED: the checkout changed during the disease run"
    diff <(printf '%s\n' "$GIT_BEFORE") <(printf '%s\n' "$GIT_AFTER") | sed 's/^/   /' || true
    FAILED=1
  else
    echo "-- checkout byte-clean: the diseases lived and died in the replica --"
  fi
else
  echo "-- not a git checkout: the cleanliness comparison is NOT APPLICABLE here (disposable-copy mode); it is enforced when this gate runs against a checkout --"
fi

echo
if [ "$FAILED" -ne 0 ] || [ "$DETECTED" -ne 8 ] || [ "$CONTROLS" -ne 8 ]; then
  echo "surface-account-disease: FAIL (detected=$DETECTED/8 controls=$CONTROLS/8)"
  exit 1
fi
echo "surface-account-disease: 8 diseases detected, 8 controls clean"
exit 0
