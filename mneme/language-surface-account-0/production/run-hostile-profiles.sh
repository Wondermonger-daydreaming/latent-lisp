#!/usr/bin/env bash
#
# run-hostile-profiles.sh — Surface Account /0 production hostile profiles.
#
# Runs surface-account-hostile.lisp once per role, EACH IN A FRESH IMAGE
# (every role needs an image that has never loaded the production identity
# source; the post-election role additionally leaves its image terminally
# failed on purpose).  A per-role process timeout is the backstop: AN EXPIRY
# IS A FAILURE, NEVER A PASS.
#
# Also runs the static once-only-law checks on the production source itself
# (the delayed-defining-write scar, checked mechanically), each with its own
# planted-fault tooth (R4.1):
#   ST-1   exactly ONE form writes the carrier place: one CAS on
#          (symbol-plist 'sa0-identity-carrier), and no SETF of it
#   ST-2   the source's COMPLETE defining-form census (defvar/defparameter/
#          defconstant/defglobal, any name) matches an exact whitelist of
#          the eight documented constant-bearing forms; DEFGLOBAL never
#   ST-1T  tooth: a planted second carrier CAS must be flagged
#   ST-2T  tooth: a planted (defvar *sa0-cell* nil) must be flagged
#
# R4.1 evidence rule: each role's FULL child transcript (every named [Hnnn]
# check line) is echoed into this runner's stdout, so the per-check detail
# reaches any evidence file that captures the runner (QUARTERMASTER F1).
#
# R4.3: the four LOADER-FINALITY witness cases (the owner's
# R4-READINESS-GUARD-ACCEPTS-NONEXTERNAL-API counterexample made permanent)
# run after the roles, each in a fresh image, driven the same way:
#   internal-dummies / partial-external / empty-package / repeat-after-repair
# (surface-account-loader-witness.lisp; full [Lnnn] transcripts echoed), plus
# the witness harness's own planted-fault tooth (must exit 1).
#
# Exit 0 iff every role and loader case passed its exact check count and all
# static checks and teeth hold.  Final sentinel:
#   surface-account-hostile-profiles: <roles> roles + <cases> loader cases, <checks> checks, 0 failures
#
# — FABER (Claude Fable 5), R4, 2026-08-06; loader cases FABER-II, R4.3

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SBCL_VERSION="$(sbcl --noinform --non-interactive \
  --eval '(progn (princ (lisp-implementation-version)) (terpri) (finish-output))' 2>/dev/null | tail -1)"
if [ "$SBCL_VERSION" != "2.4.6" ]; then
  echo "!! FAIL CLOSED: authorized for SBCL 2.4.6 only; observed ${SBCL_VERSION}."
  exit 1
fi

ROLES="contention recursive post-election post-publication carrier stale plist-contention"
PER_ROLE_TIMEOUT="${SA0_HOSTILE_TIMEOUT:-180}"

FAIL=0
TOTAL_CHECKS=0
N_ROLES=0

echo "== surface-account production hostile profiles =="

# ---- static once-only-law checks -----------------------------------------
SRC="$HERE/surface-account.lisp"
# R4.1: both checks are now FUNCTIONS over a file argument, their laws are
# exact (ST-2 compares the complete defining-form census against an explicit
# whitelist instead of three name prefixes — the old regex could not see a
# new `(defvar *sa0-cell* nil)`, which is the very scar it guards), and both
# are TEETH-CHECKED below against planted faults in disposable copies before
# their PASS on the real source is trusted.

st1_carrier_writers() {  # st1_carrier_writers FILE -> "cas setf"
  local code; code="$(grep -v '^[[:space:]]*;' "$1")"
  printf '%s %s' \
    "$(printf '%s\n' "$code" | grep -c "sb-ext:cas (symbol-plist 'sa0-identity-carrier)" || true)" \
    "$(printf '%s\n' "$code" | grep -cE "setf[[:space:]]+\(symbol-plist 'sa0-identity-carrier\)" || true)"
}

# The complete lawful defining-form census of the production source: the one
# DEFVAR (a constant namespace list, not once-only state) and the seven
# documented DEFPARAMETERs.  DEFGLOBAL is never lawful.  Any defining form
# not on this list — any name, any operator — is a FAIL.
ST2_WHITELIST="defvar:*account-identity-namespace*
defparameter:*epoch-octets*
defparameter:*epoch-hex-length*
defparameter:*epoch-entropy-source*
defparameter:*sa0-init-wait-seconds*
defparameter:*sa0-identity-source*
defparameter:*ascii-decimal-digits*
defparameter:*ascii-decimal-nonzero-digits*"

st2_unlawful_defining_forms() {  # st2_unlawful_defining_forms FILE -> offending lines (empty = lawful)
  local code census
  code="$(grep -v '^[[:space:]]*;' "$1")"
  census="$(printf '%s\n' "$code" \
    | grep -oE '\((sb-ext:)?(defglobal|defvar|defparameter|defconstant)[[:space:]]+[^[:space:])]+' \
    | sed -E 's/^\((sb-ext:)?//; s/[[:space:]]+/:/')"
  while IFS= read -r form; do
    [ -z "$form" ] && continue
    if ! printf '%s\n' "$ST2_WHITELIST" | grep -qxF "$form"; then
      printf '%s\n' "$form"
    fi
  done <<< "$census"
}

RW="$(st1_carrier_writers "$SRC")"
if [ "$RW" = "1 0" ]; then
  echo "  [PASS] ST-1 exactly one CAS writes the carrier place; no SETF of it"
  TOTAL_CHECKS=$((TOTAL_CHECKS+1))
else
  echo "  [FAIL] ST-1 carrier writers (cas setf): $RW (want '1 0')"
  FAIL=1
fi
ST2_BAD="$(st2_unlawful_defining_forms "$SRC")"
if [ -z "$ST2_BAD" ]; then
  echo "  [PASS] ST-2 defining-form census matches the exact whitelist (no once-only state behind a defining form)"
  TOTAL_CHECKS=$((TOTAL_CHECKS+1))
else
  echo "  [FAIL] ST-2 unlawful defining form(s): $(echo $ST2_BAD)"
  FAIL=1
fi

# ---- the static checks' own teeth (a gate that has never fired is untested)
TOOTH_DIR="$(mktemp -d "${TMPDIR:-/tmp}/sa0-static-teeth.XXXXXX")"
cp "$SRC" "$TOOTH_DIR/st1-diseased.lisp"
printf '\n(sb-ext:cas (symbol-plist %s) nil nil)\n' "'sa0-identity-carrier" >> "$TOOTH_DIR/st1-diseased.lisp"
if [ "$(st1_carrier_writers "$TOOTH_DIR/st1-diseased.lisp")" != "1 0" ]; then
  echo "  [PASS] ST-1T tooth: a planted second carrier CAS is FLAGGED"
  TOTAL_CHECKS=$((TOTAL_CHECKS+1))
else
  echo "  [FAIL] ST-1T tooth: the planted second carrier CAS was NOT flagged"
  FAIL=1
fi
cp "$SRC" "$TOOTH_DIR/st2-diseased.lisp"
printf '\n(defvar *sa0-cell* nil)\n' >> "$TOOTH_DIR/st2-diseased.lisp"
if [ -n "$(st2_unlawful_defining_forms "$TOOTH_DIR/st2-diseased.lisp")" ]; then
  echo "  [PASS] ST-2T tooth: a planted (defvar *sa0-cell* nil) is FLAGGED"
  TOTAL_CHECKS=$((TOTAL_CHECKS+1))
else
  echo "  [FAIL] ST-2T tooth: the planted defining form was NOT flagged"
  FAIL=1
fi
rm -rf "$TOOTH_DIR"

# ---- the roles, one fresh image each -------------------------------------
for role in $ROLES; do
  N_ROLES=$((N_ROLES+1))
  LOG="$(mktemp "${TMPDIR:-/tmp}/sa0-hostile-${role}.XXXXXX.log")"
  echo "-- role: $role (fresh image, timeout ${PER_ROLE_TIMEOUT}s) --"
  SA0_PROD_ROLE="$role" timeout "$PER_ROLE_TIMEOUT" \
    sbcl --script "$HERE/surface-account-hostile.lisp" >"$LOG" 2>&1
  rc=$?
  sentinel="$(grep -E "^surface-account-hostile\[$role\]: [0-9]+ checks, [0-9]+ failures$" "$LOG" || true)"
  checks="$(printf '%s' "$sentinel" | grep -oE '[0-9]+ checks' | grep -oE '[0-9]+' || echo 0)"
  # R4.1: the full child transcript — every named [Hnnn] check line — is
  # preserved in this runner's own output, PASS or FAIL, so the 60+ role
  # checks are named in evidence rather than only counted.
  sed 's/^/      | /' "$LOG"
  if [ "$rc" -eq 124 ]; then
    echo "   -> FAIL (TIMEOUT after ${PER_ROLE_TIMEOUT}s — a hang proves nothing)"
    FAIL=1
  elif [ "$rc" -ne 0 ] || [ -z "$sentinel" ] || ! printf '%s' "$sentinel" | grep -q ", 0 failures"; then
    echo "   -> FAIL (exit $rc; sentinel: ${sentinel:-absent})"
    FAIL=1
  else
    echo "   -> PASS ($sentinel)"
    TOTAL_CHECKS=$((TOTAL_CHECKS+checks))
  fi
  rm -f "$LOG"
done

# ---- the loader-finality witness cases (R4.3), one fresh image each -------
CASES="internal-dummies partial-external empty-package repeat-after-repair"
N_CASES=0
for lcase in $CASES; do
  N_CASES=$((N_CASES+1))
  LOG="$(mktemp "${TMPDIR:-/tmp}/sa0-loader-${lcase}.XXXXXX.log")"
  echo "-- loader case: $lcase (fresh image, timeout ${PER_ROLE_TIMEOUT}s) --"
  SA0_LOADER_CASE="$lcase" timeout "$PER_ROLE_TIMEOUT" \
    sbcl --script "$HERE/surface-account-loader-witness.lisp" >"$LOG" 2>&1
  rc=$?
  sentinel="$(grep -E "^surface-account-loader-witness\[$lcase\]: [0-9]+ checks, [0-9]+ failures$" "$LOG" || true)"
  checks="$(printf '%s' "$sentinel" | grep -oE '[0-9]+ checks' | grep -oE '[0-9]+' || echo 0)"
  sed 's/^/      | /' "$LOG"
  if [ "$rc" -eq 124 ]; then
    echo "   -> FAIL (TIMEOUT after ${PER_ROLE_TIMEOUT}s — a hang proves nothing)"
    FAIL=1
  elif [ "$rc" -ne 0 ] || [ -z "$sentinel" ] || ! printf '%s' "$sentinel" | grep -q ", 0 failures"; then
    echo "   -> FAIL (exit $rc; sentinel: ${sentinel:-absent})"
    FAIL=1
  else
    echo "   -> PASS ($sentinel)"
    TOTAL_CHECKS=$((TOTAL_CHECKS+checks))
  fi
  rm -f "$LOG"
done

# the witness harness's own tooth: a planted fault must make it exit 1
TOOTH_LOG="$(mktemp "${TMPDIR:-/tmp}/sa0-loader-tooth.XXXXXX.log")"
SA0_LOADER_CASE=empty-package SA0_LOADER_PLANT_FAULT=1 timeout "$PER_ROLE_TIMEOUT" \
  sbcl --script "$HERE/surface-account-loader-witness.lisp" >"$TOOTH_LOG" 2>&1
if [ $? -eq 1 ] && grep -q "PLANTED FAULT" "$TOOTH_LOG"; then
  echo "  [PASS] LW-T loader-witness tooth: a planted fault makes the witness exit 1"
  TOTAL_CHECKS=$((TOTAL_CHECKS+1))
else
  echo "  [FAIL] LW-T loader-witness tooth: the planted fault did NOT fail the witness"
  FAIL=1
fi
rm -f "$TOOTH_LOG"

echo
if [ "$FAIL" -ne 0 ]; then
  echo "surface-account-hostile-profiles: FAIL"
  exit 1
fi
echo "surface-account-hostile-profiles: ${N_ROLES} roles + ${N_CASES} loader cases, ${TOTAL_CHECKS} checks, 0 failures"
exit 0
