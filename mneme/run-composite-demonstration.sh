#!/usr/bin/env bash
#
# run-composite-demonstration.sh — the strongest demonstration this tree
# actually supports, in one command.
#
#   bash mneme/run-composite-demonstration.sh
#
# ---------------------------------------------------------------------------
# THIS IS A COMPOSITE RELEASE DEMONSTRATION.
# IT IS NOT A COMPLETE SEMANTIC END-TO-END LANGUAGE PATH.
# ---------------------------------------------------------------------------
#
# It runs two things that are real, in order, and then says plainly what sits
# between them that is not:
#
#   PART I  — the Vertical Specimen /0 durable process path: canonical datum,
#             process identity, journal-backed durability, capability minting
#             and revocation, the effect frontier, the deterministic fake
#             adapter, process death, reconstruction, and inspection.
#
#   PART II — Language Surface /2's read-only re-expression of the completed
#             result of that run.
#
# What is NOT here, and what this runner will say so out loud at the end:
#
#   A derive/perform language operation executing against the journal-backed
#   process substrate.  Part II reads a FINISHED result; it does not drive the
#   process.  The language's derive/perform doors have never opened onto the
#   durable substrate.  That is the first missing semantic seam, and this
#   milestone names it rather than building it.
#
# ---------------------------------------------------------------------------
# WHICH DEATHS ARE LIVE AND WHICH ARE REPLAYED — stated, not blurred
# ---------------------------------------------------------------------------
#
#   LIVE, in this run:      journal0's de-teste-occiso specimen kills real
#                           writer processes with real SIGKILL and restarts
#                           them, with negative controls.
#
#   PRESERVED, verified:    Vertical /0's four-death campaign is NOT
#                           regenerated here.  Its two campaigns are preserved
#                           artifacts; this run byte-compares them and
#                           re-derives the census from campaign-2's exec tree.
#                           VERIFYING A PRESERVED CAMPAIGN IS NOT REPRODUCING
#                           IT, and this runner does not pretend otherwise.
#
#   CRASH MODEL:            SIGKILL only, one SBCL 2.4.6/Linux host.  No
#                           power-loss model, no torn-media model, no second
#                           host, no other implementation.  Nothing beyond
#                           SIGKILL on this host has ever been tested.
#
# ---------------------------------------------------------------------------
# HYGIENE
# ---------------------------------------------------------------------------
#
# Everything runs inside a disposable copy of the tree under $TMPDIR.  The
# Vertical /0 gates deposit ~70 scratch directories per run; here they land in
# the copy and die with it.  The copy is removed on success AND on failure.
# Your checkout is snapshotted before and after and this runner FAILS CLOSED if
# a byte moved.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"

# The reconstruction digest Vertical /0 declares in VERTICAL-0-RETURN.md.
# Reproducing it is a required exit condition of this demonstration.
EXPECTED_DIGEST="706f7e1e582e06cce14ba44428b7c0705bd6480a8dcbd5ebf5a9a85874cdd05a"

echo "==========================================================================="
echo " LISP+ COMPOSITE RELEASE DEMONSTRATION"
echo " Not a complete semantic end-to-end language path. See the boundary"
echo " statement printed at the end of this run."
echo "==========================================================================="
echo

command -v sbcl >/dev/null 2>&1 || { echo "!! sbcl not on PATH"; exit 127; }
SBCL_VERSION="$(sbcl --noinform --non-interactive \
  --eval '(progn (princ (lisp-implementation-version)) (terpri) (finish-output))' 2>/dev/null | tail -1)"
echo "toolchain : SBCL ${SBCL_VERSION}   (supported: 2.4.6/Linux — nothing else tested)"
if [ "$SBCL_VERSION" != "2.4.6" ]; then
  echo "!! FAIL CLOSED: authorized for SBCL 2.4.6 only; observed ${SBCL_VERSION}."
  exit 1
fi

IN_GIT=0; GIT_BEFORE=""
if git -C "$ROOT" rev-parse --git-dir >/dev/null 2>&1; then
  IN_GIT=1
  GIT_BEFORE="$(git -C "$ROOT" status --porcelain -- "$ROOT" 2>/dev/null)"
fi

RUNDIR="$(mktemp -d "${TMPDIR:-/tmp}/lisp-plus-composite-demo.XXXXXX")"
COPY="$RUNDIR/tree"
cleanup() { rm -rf "$RUNDIR" "/tmp/vertical0-reconstruction-gate" 2>/dev/null || true; }
trap cleanup EXIT INT TERM
echo "scratch   : $RUNDIR   (removed on success AND on failure)"
echo

mkdir -p "$COPY"
if command -v rsync >/dev/null 2>&1; then
  rsync -a --exclude '.git/' --exclude 'canonical-datum/evidence/' \
           --exclude 'canonical-datum/generated/' "$ROOT"/ "$COPY"/
else
  ( cd "$ROOT" && tar -cf - --exclude=.git --exclude=canonical-datum/evidence \
      --exclude=canonical-datum/generated . ) | ( cd "$COPY" && tar -xf - )
fi
ln -sfn "$ROOT/canonical-datum/evidence"  "$COPY/canonical-datum/evidence"
ln -sfn "$ROOT/canonical-datum/generated" "$COPY/canonical-datum/generated"

FAILED=0
step() {
  local title="$1" expect="$2"; shift 2
  echo
  echo "---------------------------------------------------------------------------"
  echo ">> $title"
  echo "   \$ $*"
  echo "---------------------------------------------------------------------------"
  local log="$RUNDIR/$(echo "$title" | tr -cd '[:alnum:]' | cut -c1-40).log"
  ( cd "$COPY" && "$@" ) >"$log" 2>&1
  local rc=$?
  tail -14 "$log" | sed 's/^/   | /'
  if [ "$rc" -ne 0 ]; then
    echo "   -> FAILED (exit $rc)"; FAILED=$((FAILED+1)); return 1
  fi
  if [ "$expect" != "-" ] && ! grep -qF -- "$expect" "$log"; then
    echo "   -> FAILED (exit 0 but the required line is absent: $expect)"
    FAILED=$((FAILED+1)); return 1
  fi
  echo "   -> OK (exit 0)"
  return 0
}

echo "==========================================================================="
echo " PART I — the durable process path"
echo "==========================================================================="

step "I.1  journal0 de-teste-occiso — LIVE SIGKILL of real writer processes" \
     "RESULT: PASS" \
     sbcl --script mneme/journal0/de-teste-occiso/run-specimen.lisp

step "I.2  Vertical /0 integration controls — identity, capabilities, effect frontier, fake adapter" \
     "vertical0 integration controls: 37 checks, 0 failures" \
     sbcl --script mneme/vertical0/controls/run-integration-controls.lisp

step "I.3  Vertical /0 reconstruction gate — reconstruction and inspection after death" \
     "run-reconstruction-gate: 31 checks, 0 failures" \
     sbcl --script mneme/vertical0/reconstruction/run-reconstruction-gate.lisp

step "I.4  Vertical /0 repeatability — byte-compare the two PRESERVED four-death campaigns" \
     "-" \
     bash mneme/vertical0/harness/repeatability.sh

echo
echo "---------------------------------------------------------------------------"
echo ">> I.5  reconstruction digest check"
echo "---------------------------------------------------------------------------"
DIGEST_HITS="$(grep -rlF "$EXPECTED_DIGEST" "$RUNDIR"/*.log 2>/dev/null | wc -l)"
if [ "$DIGEST_HITS" -gt 0 ]; then
  echo "   required digest REPRODUCED by this run:"
  echo "     $EXPECTED_DIGEST"
  echo "   (found in $DIGEST_HITS of this run's transcripts)"
else
  echo "   !! required digest NOT reproduced: $EXPECTED_DIGEST"
  FAILED=$((FAILED+1))
fi

echo
echo "==========================================================================="
echo " PART II — the read-only re-expression"
echo "==========================================================================="

step "II.1 Surface /2 inhabited — re-expresses the COMPLETED census through the surface layer" \
     "surface2-inhabited: 18 checks, 0 failures" \
     sbcl --script mneme/language-surface-2/surface2-inhabited.lisp

step "II.2 Surface /2 selftest" \
     "surface2-selftest: 29 checks, 0 failures" \
     sbcl --script mneme/language-surface-2/surface2-selftest.lisp

# --- cleanliness, fail closed ---------------------------------------------
echo
echo "---------------------------------------------------------------------------"
echo ">> checkout cleanliness"
echo "---------------------------------------------------------------------------"
if [ "$IN_GIT" -eq 1 ]; then
  GIT_AFTER="$(git -C "$ROOT" status --porcelain -- "$ROOT" 2>/dev/null)"
  if [ "$GIT_BEFORE" != "$GIT_AFTER" ]; then
    echo "   !! FAIL CLOSED — the caller's checkout changed during this run:"
    diff <(printf '%s\n' "$GIT_BEFORE") <(printf '%s\n' "$GIT_AFTER") | sed 's/^/      /' || true
    FAILED=$((FAILED+1))
  else
    echo "   unchanged: zero tracked modifications, zero new untracked litter."
    echo "   (every scratch directory this run produced died with the disposable copy)"
  fi
else
  echo "   not a git checkout — every write was absorbed by the disposable copy."
fi

# --- the boundary statement -----------------------------------------------
echo
echo "==========================================================================="
echo " BOUNDARY STATEMENT"
echo "==========================================================================="
cat <<'BOUNDARY'

  The durable process/reconstruction path passes.
  The Surface /2 re-expression passes.
  A derive/perform language operation executing against the journal-backed
  process substrate is not present in Integration Baseline /0.

  Read the three sentences above as one sentence. Part II did not drive Part I;
  it read Part I's finished result. Between them is the first missing semantic
  seam of this project, and this milestone names it rather than building it.

  Further limits carried by this demonstration, none of them repaired here:
    · crash model is SIGKILL only, on one SBCL 2.4.6/Linux host;
    · the four-death campaign was VERIFIED as a preserved artifact, not
      regenerated — verifying an archive is not reproducing a campaign;
    · the adapter boundary is the deterministic fake; no live provider exists;
    · this is self-consistency certification, never independent conformance;
    · nothing here adopts any implementation or raises any lane's standing.

  The current claim ceiling is mneme/integration-baseline-0/CLAIM-CEILING-0.md.

BOUNDARY

echo "==========================================================================="
if [ "$FAILED" -ne 0 ]; then
  echo " COMPOSITE DEMONSTRATION: FAIL ($FAILED step(s))"
  echo "==========================================================================="
  exit 1
fi
echo " COMPOSITE DEMONSTRATION: PASS"
echo " (a packaging result, not a semantic one)"
echo "==========================================================================="
exit 0
