#!/usr/bin/env bash
#
# ma0-campaign-gates.sh — THE CAMPAIGN'S OWN GATES (FAILURE MATRIX §3, the three
# rows that are about the campaign rather than about the composition).
#
# CANDIDATE.  Running a candidate is not adopting it (contract §0, §8), and
# nothing this script prints is independent verification (AP0 adoption Rider 2).
#
#   W-VF-UNCHANGED     One Act /0's V-F freeze table digests to
#                      2b51b4df26fe0fa1e4a156f9408a92f5a501aba9fa2401eb08e10a123f1264f0
#                      after the whole campaign — the octets the adopted lane
#                      froze are the octets that stand.
#
#   W-ONEACT-GREEN     the adopted lane's own runner still prints
#                      "oneact0-selftest: 173 checks, 0 failures".
#
#   W-FLOOR-UNTOUCHED  since the pre-code seal 9e52b7e1, `mneme/verify-release.sh'
#                      and `mneme/language-act-0/' carry NO diff at all, and
#                      `lisp-plus.asd' carries ADDITIONS ONLY — asserted by
#                      git's own numbers, not by reading the patch.
#
#   THE REDUCED FLOOR  `verify-release.sh --profile ci' still reports
#                      77 attempted / 77 passed / 0 blocked, exit 0.
#
# ⚠ EACH GATE IS SHOWN ABLE TO FIRE.  MA0_GATES_PLANT=<gate> corrupts exactly
# one gate's input and the run must go RED there.  A gate that has never failed
# is untested, not passing.  Plants: vf (a mutated copy of the freeze table),
# oneact (the adopted runner's own ACT0_SELFTEST_PLANT_FAULT tooth), floor
# (an impossible expected line).  Nothing a plant touches is in the checkout.
#
# ⚠ THE FLOOR TAKES MINUTES.  MA0_GATES_SKIP_FLOOR=1 omits it and SAYS SO in
# the sentinel line; it never reports an omitted gate as a passed one.
#
# Exit 0 iff every attempted gate passed.
# Sentinel: ma0-campaign-gates: <N> gates, 0 failures
#
# — DENS (Claude Opus 5, subagent), 2026-08-09

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"            # experiments/latent-lisp
# ⚠ THE CHECKOUT ROOT IS ASKED FOR, NOT COUNTED OUT IN `..'s.  The first draft
# of this file assumed the subject tree sat one level below the checkout; it
# sits two, and every git path the gate built was wrong — which git reported as
# an EMPTY DIFF, i.e. as the gate PASSING.  A path gate that cannot tell "no
# changes" from "no such directory" is a green light wired to nothing, so the
# root comes from git and the guarded paths are asserted to exist below.
REPO="$(git -C "$ROOT" rev-parse --show-toplevel 2>/dev/null || echo "")"
[ -n "$REPO" ] || REPO="$(cd "$ROOT/../.." && pwd)"
REL="${ROOT#"$REPO"/}"
SEAL="9e52b7e1"
VF_DIGEST="2b51b4df26fe0fa1e4a156f9408a92f5a501aba9fa2401eb08e10a123f1264f0"
VF_TABLE="$REPO/_staging/oneact-impl-evidence/r22-v-f-freeze-table.txt"
PLANT="${MA0_GATES_PLANT:-}"

SCRATCH="$(mktemp -d "${TMPDIR:-/tmp}/ma0-gates.XXXXXX")"
trap 'rm -rf "$SCRATCH"' EXIT INT TERM

PASSED=0
FAILED=0

gate() {  # gate NAME OK-BOOL DETAIL...
  local name="$1" ok="$2"; shift 2
  if [ "$ok" = "1" ]; then
    PASSED=$((PASSED + 1)); echo "  [PASS] $name  $*"
  else
    FAILED=$((FAILED + 1)); echo "  [FAIL] $name  $*"
  fi
}

SBCL_VERSION="$(sbcl --noinform --non-interactive \
  --eval '(progn (princ (lisp-implementation-version)) (terpri) (finish-output))' 2>/dev/null | tail -1)"
[ "$SBCL_VERSION" = "2.4.6" ] || { echo "!! FAIL CLOSED: SBCL 2.4.6 only (got $SBCL_VERSION)"; exit 1; }

echo "== ma0-campaign-gates — SBCL $SBCL_VERSION =="
echo "   checkout : $REPO"
echo "   subject  : $REL"
echo "   seal     : $SEAL"
[ -n "$PLANT" ] && echo "   ⚠ PLANT  : $PLANT (a GREEN run on this gate is a FAILURE of the gate)"

# ---------------------------------------------------------------------------
# W-VF-UNCHANGED
# ---------------------------------------------------------------------------
echo
echo "-- W-VF-UNCHANGED --"
VF_READ="$VF_TABLE"
if [ "$PLANT" = "vf" ]; then
  # the plant works on a COPY; the real evidence file is never written to.
  cp "$VF_TABLE" "$SCRATCH/vf-planted.txt"
  printf 'PLANTED\n' >> "$SCRATCH/vf-planted.txt"
  VF_READ="$SCRATCH/vf-planted.txt"
fi
if [ -f "$VF_READ" ]; then
  GOT="$(sha256sum "$VF_READ" | cut -d' ' -f1)"
  [ "$GOT" = "$VF_DIGEST" ] && gate "W-VF-UNCHANGED the V-F freeze table digest" 1 "sha256=$GOT" \
                            || gate "W-VF-UNCHANGED the V-F freeze table digest" 0 "sha256=$GOT expected=$VF_DIGEST"
else
  gate "W-VF-UNCHANGED the V-F freeze table digest" 0 "the freeze table is absent: $VF_READ"
fi

# ---------------------------------------------------------------------------
# W-ONEACT-GREEN
# ---------------------------------------------------------------------------
echo
echo "-- W-ONEACT-GREEN --"
ONEACT_LOG="$SCRATCH/oneact.log"
if [ "$PLANT" = "oneact" ]; then
  ( cd "$ROOT" && ACT0_SELFTEST_PLANT_FAULT=1 sbcl --script mneme/language-act-0/act0-selftest.lisp ) >"$ONEACT_LOG" 2>&1
else
  ( cd "$ROOT" && sbcl --script mneme/language-act-0/act0-selftest.lisp ) >"$ONEACT_LOG" 2>&1
fi
ONEACT_RC=$?
if [ "$ONEACT_RC" -eq 0 ] && grep -qxF "oneact0-selftest: 173 checks, 0 failures" "$ONEACT_LOG"; then
  gate "W-ONEACT-GREEN oneact0-selftest: 173 checks, 0 failures" 1 "exit=$ONEACT_RC"
else
  gate "W-ONEACT-GREEN oneact0-selftest: 173 checks, 0 failures" 0 \
       "exit=$ONEACT_RC last=$(tail -1 "$ONEACT_LOG")"
fi

# ---------------------------------------------------------------------------
# W-FLOOR-UNTOUCHED — git's own numbers.
# ---------------------------------------------------------------------------
echo
echo "-- W-FLOOR-UNTOUCHED --"
if git -C "$REPO" rev-parse --git-dir >/dev/null 2>&1; then
  # ---- the paths this gate guards must EXIST.  An empty diff over a path that
  # ---- is not there reads exactly like an empty diff over a path that is.
  for guarded in "$REL/mneme/verify-release.sh" "$REL/mneme/language-act-0" \
                 "$REL/lisp-plus.asd"; do
    if [ -e "$REPO/$guarded" ]; then
      gate "W-FLOOR-UNTOUCHED the guarded path exists: $guarded" 1
    else
      gate "W-FLOOR-UNTOUCHED the guarded path exists: $guarded" 0 \
           "absent — every diff below would be vacuously empty"
    fi
  done
  UNTOUCHED="$(git -C "$REPO" diff "$SEAL..HEAD" --stat -- \
                 "$REL/mneme/verify-release.sh" "$REL/mneme/language-act-0/")"
  if [ -z "$UNTOUCHED" ]; then
    gate "W-FLOOR-UNTOUCHED verify-release.sh + language-act-0/ carry no diff since $SEAL" 1 "(empty --stat)"
  else
    gate "W-FLOOR-UNTOUCHED verify-release.sh + language-act-0/ carry no diff since $SEAL" 0 \
         "$(printf '%s' "$UNTOUCHED" | tr '\n' ';')"
  fi
  # the working tree too: a gate that only reads committed history cannot see an
  # uncommitted edit sitting in the very files it is guarding.
  DIRTY="$(git -C "$REPO" status --porcelain -- \
             "$REL/mneme/verify-release.sh" "$REL/mneme/language-act-0/")"
  if [ -z "$DIRTY" ]; then
    gate "W-FLOOR-UNTOUCHED and neither is dirty in the working tree" 1 "(empty porcelain)"
  else
    gate "W-FLOOR-UNTOUCHED and neither is dirty in the working tree" 0 \
         "$(printf '%s' "$DIRTY" | tr '\n' ';')"
  fi
  ASD_NUM="$(git -C "$REPO" diff "$SEAL..HEAD" --numstat -- "$REL/lisp-plus.asd")"
  ASD_DEL="$(printf '%s' "$ASD_NUM" | awk '{print $2}')"
  ASD_ADD="$(printf '%s' "$ASD_NUM" | awk '{print $1}')"
  [ -z "$ASD_NUM" ] && { ASD_DEL=0; ASD_ADD=0; }
  if [ "$ASD_DEL" = "0" ]; then
    gate "W-FLOOR-UNTOUCHED lisp-plus.asd shows ADDITIONS ONLY since $SEAL" 1 \
         "+$ASD_ADD -$ASD_DEL"
  else
    gate "W-FLOOR-UNTOUCHED lisp-plus.asd shows ADDITIONS ONLY since $SEAL" 0 \
         "+$ASD_ADD -$ASD_DEL — a deletion is not an addition"
  fi
else
  gate "W-FLOOR-UNTOUCHED (git)" 0 "not a git checkout: this gate cannot run and is NOT being skipped silently"
fi

# ---------------------------------------------------------------------------
# THE REDUCED FLOOR
# ---------------------------------------------------------------------------
echo
if [ "${MA0_GATES_SKIP_FLOOR:-0}" = "1" ]; then
  echo "-- REDUCED FLOOR: OMITTED by MA0_GATES_SKIP_FLOOR=1 (not attempted, not passed) --"
  FLOOR_STATE="omitted"
else
  echo "-- REDUCED FLOOR (profile ci) --"
  FLOOR_STATE="attempted"
  FLOOR_LOG="$SCRATCH/floor-ci.log"
  ( cd "$ROOT" && bash mneme/verify-release.sh --profile ci ) >"$FLOOR_LOG" 2>&1
  FLOOR_RC=$?
  WANT="FLOOR RESULT: PASS (77 executable gates attempted / 77 passed / 0 blocked"
  [ "$PLANT" = "floor" ] && WANT="FLOOR RESULT: PASS (999 executable gates attempted"
  if [ "$FLOOR_RC" -eq 0 ] && grep -qF "$WANT" "$FLOOR_LOG"; then
    gate "REDUCED FLOOR 77 attempted / 77 passed / 0 blocked (profile ci)" 1 "exit=$FLOOR_RC"
  else
    gate "REDUCED FLOOR 77 attempted / 77 passed / 0 blocked (profile ci)" 0 \
         "exit=$FLOOR_RC last=$(grep -F 'FLOOR RESULT' "$FLOOR_LOG" | tail -1)"
  fi
fi

# ---------------------------------------------------------------------------
echo
TOTAL=$((PASSED + FAILED))
if [ "$FAILED" -eq 0 ]; then
  if [ "$FLOOR_STATE" = "omitted" ]; then
    echo "ma0-campaign-gates: $TOTAL gates, 0 failures (THE REDUCED FLOOR WAS OMITTED)"
  else
    echo "ma0-campaign-gates: $TOTAL gates, 0 failures"
  fi
  exit 0
fi
echo "ma0-campaign-gates: FAILED ($PASSED passed / $FAILED failed of $TOTAL gates)"
exit 1
