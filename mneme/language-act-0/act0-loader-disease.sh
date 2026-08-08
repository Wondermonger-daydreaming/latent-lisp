#!/usr/bin/env bash
#
# act0-loader-disease.sh — One Act /0 LOADER-FINALITY DISEASE COMPARATORS
# (owner ruling R2.2, item 4).  Three mutations, each applied to a DISPOSABLE
# REPLICA of the subject tree (NEVER to the checkout), each required to make a
# named witness check FAIL.  Every disease is preceded by its CONTROL ARM — the
# same witness on an UNMUTATED replica, which must PASS — because a column of
# refusals would otherwise prove only that the witness refuses everything.
#
#   D1  THE OWNER'S DEFECT, RESTORED: the act0 stanza's guard reverted to
#       `(unless (find-package '#:lisp-plus-language-act0) ...)`.
#       -> w1-empty-package FAILS and w2-package-only FAILS, both at the named
#          check "NO FALSE SUCCESS", with the owner's exact signature:
#          ASDF returns normally, RUN-ACT not FBOUNDP.
#
#   D2  THE READINESS CARRIER DELETED from the last form of act0-gates.lisp.
#       -> w5-lawful-fresh FAILS at "the lawful fresh load COMPLETED".
#          This is the tooth that proves the carrier is LOAD-BEARING and not
#          decoration: without it the loader cannot see the end of the lane.
#
#   D3  THE PREDICATE MADE ITERATIVE instead of enumerated — "every external
#       symbol is FBOUNDP", the shape a census-only guard would take.
#       -> w1-empty-package FAILS: an EMPTY package satisfies "every external
#          symbol is fbound" VACUOUSLY, so the guard skips and certifies
#          nothing.  This is why the R2.2 predicate enumerates its 70 names.
#
# The checkout's porcelain is snapshotted before and after and compared
# UNCONDITIONALLY whenever a repository exists (the R4.1 lesson: "no git
# repository" and "clean git repository" are DIFFERENT states, and a guard
# keyed on string-nonemptiness silently skips the promised comparison on a
# clean tree).
#
# Exit 0 iff all three diseases were DETECTED and all three controls PASSED.
# Sentinel: act0-loader-disease: 3 diseases detected, 3 controls clean
#
# — FABER-II (Claude Opus 5, subagent), R2.2, 2026-08-08

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"          # experiments/latent-lisp
LANE="mneme/language-act-0"
PER_CASE_TIMEOUT="${ACT0_WITNESS_TIMEOUT:-900}"

SBCL_VERSION="$(sbcl --noinform --non-interactive \
  --eval '(progn (princ (lisp-implementation-version)) (terpri) (finish-output))' 2>/dev/null | tail -1)"
[ "$SBCL_VERSION" = "2.4.6" ] || { echo "!! FAIL CLOSED: SBCL 2.4.6 only (got $SBCL_VERSION)"; exit 1; }
echo "== act0-loader-disease — SBCL $SBCL_VERSION =="

HAVE_GIT=0
GIT_BEFORE=""
if git -C "$ROOT" rev-parse --git-dir >/dev/null 2>&1; then
  HAVE_GIT=1
  GIT_BEFORE="$(git -C "$ROOT" status --porcelain 2>/dev/null)"
fi

SCRATCH="$(mktemp -d "${TMPDIR:-/tmp}/act0-disease.XXXXXX")"
trap 'rm -rf "$SCRATCH"' EXIT INT TERM
REPLICA="$SCRATCH/tree"

FAILED=0
DETECTED=0
CONTROLS=0

make_replica() {
  rm -rf "$REPLICA"; mkdir -p "$REPLICA"
  rsync -a --exclude '.git/' \
           --exclude 'canonical-datum/evidence/' \
           --exclude 'canonical-datum/generated/' \
           "$ROOT"/ "$REPLICA"/
}

# run one witness case in the replica; echoes its log path, returns its exit code
run_case() {   # $1 = case name, $2 = log path
  ACT0_LOADER_CASE="$1" timeout "$PER_CASE_TIMEOUT" \
    sbcl --script "$REPLICA/$LANE/act0-load-witnesses.lisp" >"$2" 2>&1
}

# ---------------------------------------------------------------------------
# THE THREE MUTATIONS.  Each is a python3 rewrite of exactly one region of one
# file in the replica; each ASSERTS the anchor it expects was present, so a
# mutation that silently no-ops (and would then "detect" nothing) fails loudly.

mutate_d1() {   # restore the FIND-PACKAGE guard in the act0 stanza
  python3 - "$REPLICA" <<'PY'
import sys, pathlib
asd = pathlib.Path(sys.argv[1], "lisp-plus.asd")
s = asd.read_text()
anchor = "             (uiop:symbol-call '#:lisp-plus-system '#:ensure-act0-lane)))"
assert s.count(anchor) == 1, "D1 anchor not found exactly once"
old = """             (unless (find-package '#:lisp-plus-language-act0)
               (uiop:symbol-call '#:lisp-plus-system '#:lane
                                 "mneme/language-act-0/package.lisp")
               (uiop:symbol-call '#:lisp-plus-system '#:lane
                                 "mneme/language-act-0/act0-fixtures.lisp")
               (uiop:symbol-call '#:lisp-plus-system '#:lane
                                 "mneme/language-act-0/act0.lisp")
               (uiop:symbol-call '#:lisp-plus-system '#:lane
                                 "mneme/language-act-0/act0-gates.lisp"))))"""
asd.write_text(s.replace(anchor, old))
PY
}

mutate_d2() {   # delete the readiness carrier (the last form of the last source)
  python3 - "$REPLICA" <<'PY'
import sys, pathlib
g = pathlib.Path(sys.argv[1], "mneme/language-act-0/act0-gates.lisp")
s = g.read_text()
marker = "(defparameter act0-lane-ready-carrier"
assert s.count(marker) == 1, "D2 anchor not found exactly once"
g.write_text(s[:s.index(marker)] + ";;; (carrier deleted by disease D2)\n")
PY
}

mutate_d3() {   # replace the enumerated predicate with a package walk
  python3 - "$REPLICA" <<'PY'
import sys, pathlib
asd = pathlib.Path(sys.argv[1], "lisp-plus.asd")
s = asd.read_text()
anchor = "  (null (act0-api-shortfall)))"
assert s.count(anchor) == 1, "D3 anchor not found exactly once"
census = """  (let ((p (find-package '#:lisp-plus-language-act0)))
    (and p (block census
             (do-external-symbols (s p) (unless (fboundp s) (return-from census nil)))
             t))))"""
asd.write_text(s.replace(anchor, census))
PY
}

# ---------------------------------------------------------------------------

run_disease() {   # $1 name  $2 mutate-fn  $3 case  $4 must-appear-in-a-FAIL-line
  local name="$1" mutate="$2" case="$3" must="$4"
  echo "-- $name / $case --"

  make_replica
  local clog="$SCRATCH/${name}-${case}-control.log"
  run_case "$case" "$clog"
  if [ $? -eq 0 ] && grep -q "0 failures" "$clog"; then
    echo "  [PASS] control: $case is GREEN on an unmutated replica"
    CONTROLS=$((CONTROLS + 1))
  else
    echo "  [FAIL] control: $case did NOT pass on an unmutated replica"
    grep -E "^\[W[0-9]+\] FAIL" "$clog" | sed 's/^/         /'
    FAILED=1
  fi

  make_replica
  if ! "$mutate"; then
    echo "  [FAIL] $name: the mutation itself failed to apply"; FAILED=1; return
  fi
  local dlog="$SCRATCH/${name}-${case}-disease.log"
  run_case "$case" "$dlog"
  local rc=$?
  local hit
  hit="$(grep -E "^\[W[0-9]+\] FAIL" "$dlog" | grep -F "$must" || true)"
  if [ "$rc" -ne 0 ] && [ -n "$hit" ]; then
    echo "  [PASS] $name DETECTED — $case fails by the named check:"
    echo "$hit" | sed 's/^/           /'
    grep -E "^     ASDF outcome" "$dlog" | sed 's/^/           /'
    DETECTED=$((DETECTED + 1))
  else
    echo "  [FAIL] $name NOT detected (exit $rc); expected a FAIL line containing: $must"
    tail -25 "$dlog" | sed 's/^/         /'
    FAILED=1
  fi
}

run_disease D1-find-package-guard-restored mutate_d1 w1-empty-package "NO FALSE SUCCESS"
run_disease D1-find-package-guard-restored mutate_d1 w2-package-only  "NO FALSE SUCCESS"
run_disease D2-readiness-carrier-deleted   mutate_d2 w5-lawful-fresh  "the lawful fresh load COMPLETED"
run_disease D3-predicate-made-iterative    mutate_d3 w1-empty-package "NO FALSE SUCCESS"

# ---------------------------------------------------------------------------
if [ "$HAVE_GIT" -eq 1 ]; then
  GIT_AFTER="$(git -C "$ROOT" status --porcelain 2>/dev/null)"
  if [ "$GIT_BEFORE" = "$GIT_AFTER" ]; then
    echo "  [PASS] the checkout's porcelain is UNCHANGED by this script"
  else
    echo "  [FAIL] the checkout changed during the disease run"
    diff <(printf '%s\n' "$GIT_BEFORE") <(printf '%s\n' "$GIT_AFTER") | sed 's/^/         /'
    FAILED=1
  fi
else
  echo "  [n/a]  not a git repository — the porcelain comparison is NOT APPLICABLE here (it is not being skipped silently)"
fi

# D1 is run against two cases; count it once for the sentinel.
DISEASES=$((DETECTED))
if [ "$FAILED" -eq 0 ] && [ "$DISEASES" -eq 4 ] && [ "$CONTROLS" -eq 4 ]; then
  echo "act0-loader-disease: 3 diseases detected, 3 controls clean"
  echo "  (4 disease/control PAIRS: D1 is exhibited on BOTH of the owner's reproduced states)"
  exit 0
fi
echo "act0-loader-disease: FAILED (detections $DETECTED/4, controls $CONTROLS/4)"
exit 1
