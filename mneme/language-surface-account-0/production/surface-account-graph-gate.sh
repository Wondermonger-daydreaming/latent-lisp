#!/usr/bin/env bash
#
# surface-account-graph-gate.sh — the static ASDF-graph / source-confinement
# gate for the Surface Account /0 production lane (R4).
#
# Proves, with named checks, that the production component is wired into the
# real system structure AND that its dependency graph excludes the laboratory
# tree.  Each check prints GG-N PASS/FAIL; exit 0 only if all pass.
#
#   GG-1  production sources reference no probes/ path (static)
#   GG-2  lisp-plus.asd declares the lane system with NO :depends-on
#         (CD/0-only false-edge law) and the lane-order row is LAST
#   GG-3  a fresh image loading ONLY the lane arrives with the package
#         present, ready, and with NO probe artifact loaded (the frozen
#         probe's CL-USER carrier symbols are absent)
#   GG-4  a fresh image loading the UMBRELLA arrives with the package
#         present and ready (this is the named check the ASDF-omission
#         disease comparator must make fail)
#   GG-5  the completeness-predicate CORE is TOKEN-IDENTICAL between
#         production/load.lisp and lisp-plus.asd (one predicate in
#         substance, two forced textual homes — R4.3; extracted between the
#         SA0-COMPLETENESS-PREDICATE-CORE markers, comments stripped,
#         whitespace normalized)
#   GG-5T tooth: a planted divergence (dropping the :EXTERNAL clause from a
#         disposable copy of one home) must be FLAGGED
#   GG-6  the shared core actually REQUIRES the three R4.3 facts:
#         (eq status :external), (fboundp symbol), and the
#         SA0-IDENTITY-CARRIER presence clause
#   GG-6T tooth: the doctored copy (no :EXTERNAL clause) must FAIL the
#         GG-6 fact test
#
# Supported: SBCL 2.4.6/Linux, nothing else tested.

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../../.." && pwd)"   # experiments/latent-lisp/

FAIL=0
N_PASS=0
pass() { echo "  [PASS] $1"; N_PASS=$((N_PASS+1)); }
fail() { echo "  [FAIL] $1"; FAIL=1; }

SBCL_VERSION="$(sbcl --noinform --non-interactive \
  --eval '(progn (princ (lisp-implementation-version)) (terpri) (finish-output))' 2>/dev/null | tail -1)"
if [ "$SBCL_VERSION" != "2.4.6" ]; then
  echo "!! FAIL CLOSED: authorized for SBCL 2.4.6 only; observed ${SBCL_VERSION}."
  exit 1
fi

echo "== surface-account graph gate =="

# ---- GG-1: static confinement -------------------------------------------
# Comment lines (leading ';') are prose and may cite the oracle; CODE lines
# may not name a probes/ path.
if grep -hn "probes/" "$HERE/package.lisp" "$HERE/surface-account.lisp" "$HERE/load.lisp" 2>/dev/null \
     | grep -vE '^[0-9]+:[[:space:]]*;' | grep -q .; then
  fail "GG-1 a production source CODE line references a probes/ path"
else
  pass "GG-1 no production source code line references a probes/ path"
fi

# ---- GG-2: system declaration shape -------------------------------------
ASD="$ROOT/lisp-plus.asd"
# the system block, from its defsystem line to the next defsystem
BLOCK="$(awk '/defsystem "lisp-plus\/surface-account"/{f=1} f{print} f&&/^\(defsystem/&&!/surface-account/{exit}' "$ASD")"
if [ -z "$BLOCK" ]; then
  fail "GG-2 lisp-plus.asd declares no lisp-plus/surface-account system"
elif printf '%s' "$BLOCK" | grep -v '^[[:space:]]*;' | grep -q ":depends-on"; then
  fail "GG-2 the lane system declares :depends-on (false-edge law violated)"
else
  pass "GG-2 lisp-plus/surface-account declared with no :depends-on"
fi
# R4.1 (LECTOR finding 8): the check now tests what its name says — the
# lane's row is the genuinely LAST row of *lane-order* (by the table's own
# path column), not merely "adjacent to vertical0".
LAST_LANE_PATH="$(awk '/defparameter \*lane-order\*/,/^  "The canonical/' "$ASD" \
                   | grep -oE '"mneme/[^"]+"' | tail -1)"
if [ "$LAST_LANE_PATH" = '"mneme/language-surface-account-0/production/load.lisp"' ]; then
  pass "GG-2b lane-order row present and genuinely LAST (last path in the table)"
else
  fail "GG-2b lane-order last path is ${LAST_LANE_PATH:-<none>} (want the surface-account loader)"
fi

# ---- GG-3: lane-only load is confined -----------------------------------
GG3="$(sbcl --noinform --non-interactive \
  --eval "(load \"$HERE/load.lisp\")" \
  --eval '(format t "GG3 package=~a ready=~a probe-carrier=~a probe-state-fn=~a~%"
            (and (find-package :lisp-plus-surface-account) t)
            (funcall (intern "IDENTITY-READY-P" :lisp-plus-surface-account))
            (and (find-symbol "SA0-IDENTITY-CARRIER" "COMMON-LISP-USER") t)
            (and (find-symbol "SA0-CARRIER-CELL" "COMMON-LISP-USER") t))' 2>&1 | grep '^GG3 ' || true)"
if [ "$GG3" = "GG3 package=T ready=T probe-carrier=NIL probe-state-fn=NIL" ]; then
  pass "GG-3 lane-only load: package present, ready, no probe artifact in CL-USER"
else
  fail "GG-3 lane-only load unexpected: ${GG3:-<no output>}"
fi

# ---- GG-4: umbrella reaches the lane ------------------------------------
GG4="$(sbcl --noinform --non-interactive \
  --eval '(require :asdf)' --eval '(require :sb-posix)' \
  --eval "(asdf:initialize-source-registry '(:source-registry (:directory \"${ROOT}\") :inherit-configuration))" \
  --eval '(asdf:load-system "lisp-plus")' \
  --eval '(format t "GG4 package=~a ready=~a~%"
            (and (find-package :lisp-plus-surface-account) t)
            (and (find-package :lisp-plus-surface-account)
                 (funcall (intern "IDENTITY-READY-P" :lisp-plus-surface-account))))' 2>&1 | grep '^GG4 ' || true)"
if [ "$GG4" = "GG4 package=T ready=T" ]; then
  pass "GG-4 umbrella load reaches Surface Account /0 (package present, ready)"
else
  fail "GG-4 umbrella did NOT deliver a ready Surface Account /0: ${GG4:-<no output>}"
fi

# ---- GG-5/GG-6: the one-predicate-in-substance agreement gate (R4.3) ------
# The completeness predicate is forced to live twice (load.lisp must be
# loadable with no ASDF present; the umbrella row needs the predicate before
# load.lisp runs).  These checks keep the two homes ONE predicate: extract
# the region between the SA0-COMPLETENESS-PREDICATE-CORE markers, strip
# comments, normalize all whitespace, and require byte-identical token
# streams — then require the shared core to state the three R4.3 facts.

core_extract() {  # core_extract FILE -> normalized token stream (stdout)
  awk '/SA0-COMPLETENESS-PREDICATE-CORE-BEGIN/{f=1;next}
       /SA0-COMPLETENESS-PREDICATE-CORE-END/{f=0}
       f{print}' "$1" \
    | sed 's/;.*$//' \
    | tr -s '[:space:]' ' ' \
    | sed 's/^ //; s/ $//'
}

LOADER_FILE="$HERE/load.lisp"
CORE_A="$(core_extract "$LOADER_FILE")"
CORE_B="$(core_extract "$ASD")"
MARKS_A="$(grep -c "SA0-COMPLETENESS-PREDICATE-CORE-BEGIN" "$LOADER_FILE")-$(grep -c "SA0-COMPLETENESS-PREDICATE-CORE-END" "$LOADER_FILE")"
MARKS_B="$(grep -c "SA0-COMPLETENESS-PREDICATE-CORE-BEGIN" "$ASD")-$(grep -c "SA0-COMPLETENESS-PREDICATE-CORE-END" "$ASD")"
if [ "$MARKS_A" = "1-1" ] && [ "$MARKS_B" = "1-1" ] \
   && [ -n "$CORE_A" ] && [ "$CORE_A" = "$CORE_B" ]; then
  pass "GG-5 completeness-predicate core token-identical in load.lisp and lisp-plus.asd (markers 1-1 in each, region non-empty)"
else
  fail "GG-5 predicate cores DIVERGE (markers load.lisp=$MARKS_A asd=$MARKS_B; the two homes are no longer one predicate)"
fi

core_facts_ok() {  # core_facts_ok CORE-STRING -> 0 iff the three facts present
  printf '%s' "$1" | grep -qF "(eq status :external)" \
    && printf '%s' "$1" | grep -qF "(fboundp symbol)" \
    && printf '%s' "$1" | grep -qF "SA0-IDENTITY-CARRIER"
}
if core_facts_ok "$CORE_A"; then
  pass "GG-6 the shared core requires :EXTERNAL status, FBOUNDP, and the SA0-IDENTITY-CARRIER presence clause"
else
  fail "GG-6 the shared core is missing a required clause (:EXTERNAL / FBOUNDP / carrier presence)"
fi

# ---- the agreement gate's own teeth (a gate that has never fired is untested)
TOOTH_DIR="$(mktemp -d "${TMPDIR:-/tmp}/sa0-gg-teeth.XXXXXX")"
sed 's/(eq status :external)//' "$LOADER_FILE" > "$TOOTH_DIR/load-doctored.lisp"
DOCTORED="$(core_extract "$TOOTH_DIR/load-doctored.lisp")"
if [ -n "$DOCTORED" ] && [ "$DOCTORED" != "$CORE_B" ]; then
  pass "GG-5T tooth: a planted divergence (dropped :EXTERNAL clause) is FLAGGED by the comparison"
else
  fail "GG-5T tooth: the planted divergence was NOT flagged"
fi
if ! core_facts_ok "$DOCTORED"; then
  pass "GG-6T tooth: the doctored core FAILS the required-clause test"
else
  fail "GG-6T tooth: the doctored core still passed the required-clause test"
fi
rm -rf "$TOOTH_DIR"

echo
if [ "$FAIL" -ne 0 ]; then
  echo "surface-account-graph-gate: FAIL"
  exit 1
fi
echo "surface-account-graph-gate: ${N_PASS} checks passed, 0 failed"
exit 0
