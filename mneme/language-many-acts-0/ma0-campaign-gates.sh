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
#                      and the TEN ENUMERATED pre-Parcel-1 citizens of
#                      `mneme/language-act-0/' (named in CITIZENS below; the
#                      directory as a whole is NOT the guard — owner-accepted
#                      documentary additions such as rulings/ are lawful,
#                      TD-5 owner disposition 2026-08-12) carry NO diff at
#                      all, and `lisp-plus.asd' carries ADDITIONS ONLY —
#                      asserted by git's own numbers, not by reading the patch.
#
#   THE REDUCED FLOOR  `verify-release.sh --profile ci' still reports
#                      77 attempted / 77 passed / 0 blocked, exit 0.
#
# ⚠ EACH GATE IS SHOWN ABLE TO FIRE.  MA0_GATES_PLANT=<gate> corrupts exactly
# one gate's input and the run must go RED there.  A gate that has never failed
# is untested, not passing.  Plants: vf (a mutated copy of the freeze table),
# oneact (the adopted runner's own ACT0_SELFTEST_PLANT_FAULT tooth), floor
# (an impossible expected line), seal (a nonexistent seal commit — the run must
# report UNAVAILABLE and exit nonzero, never PASS; this is TD-1's tooth),
# citizen (appends a file known to carry a post-seal diff to the guarded set —
# the no-diff gate must go RED; this is TD-5's tooth).
# Nothing a plant touches is in the checkout.
#
# ⚠ THE FLOOR TAKES MINUTES.  MA0_GATES_SKIP_FLOOR=1 omits it and SAYS SO in
# the sentinel line; it never reports an omitted gate as a passed one.
#
# ⚠ THREE STATES, THREE EXITS (Tooling Repair /0, 2026-08-12, TD-1..TD-4):
# a gate is PASS, FAIL, or UNAVAILABLE.  UNAVAILABLE means this checkout
# cannot attempt the gate (the seal commit is not in its history, or the
# lab-side evidence file is not in its tree — both true of every public-mirror
# checkout) and is NEVER folded into PASS: an errored git diff is not an empty
# diff, and an absent input is not an unchanged input.
#   exit 0 — every gate attempted and passed
#   exit 2 — no failures, but ≥1 gate UNAVAILABLE (partial verdict, says so)
#   exit 1 — ≥1 gate failed
# Sentinel: ma0-campaign-gates: <N> gates, 0 failures            (exit 0)
#        or ma0-campaign-gates: PARTIAL — ...                    (exit 2)
#        or ma0-campaign-gates: FAILED (...)                     (exit 1)
#
# — DENS (Claude Opus 5, subagent), 2026-08-09
# — Tooling Repair /0 (TD-1 rc-checked diffs + seal-existence; TD-2 explicit
#   UNAVAILABLE for lab-side evidence; TD-3 mirror-root REL normalization),
#   Claude Fable 5, 2026-08-12.  CANDIDATE tooling; running it adopts nothing.

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
# TD-3: on a public-mirror checkout the repo root IS the subject tree, so the
# prefix-strip above is a no-op and REL would stay ABSOLUTE — every guarded
# pathspec built from it would name a path that is not there, and the
# existence gates would fail for the wrong reason.  Normalize to ".".
[ "$ROOT" = "$REPO" ] && REL="."
sub() {  # sub RELATIVE-PATH -> pathspec valid from $REPO in either shape
  if [ "$REL" = "." ]; then printf '%s' "$1"; else printf '%s/%s' "$REL" "$1"; fi
}
SEAL="9e52b7e1"
PLANT="${MA0_GATES_PLANT:-}"
# TD-1 tooth: a planted nonexistent seal must surface as UNAVAILABLE + exit 2,
# never as an empty-diff PASS.
[ "$PLANT" = "seal" ] && SEAL="d15ab1edd15ab1ed"
VF_DIGEST="2b51b4df26fe0fa1e4a156f9408a92f5a501aba9fa2401eb08e10a123f1264f0"
VF_TABLE="$REPO/_staging/oneact-impl-evidence/r22-v-f-freeze-table.txt"
# TD-5 (owner disposition, 2026-08-12): the floor guard names the TEN
# pre-Parcel-1 citizens of language-act-0/ BY NAME — permission by
# enumeration, never by description.  Owner-accepted documentary additions
# elsewhere in the directory (e.g. rulings/) are lawful; ANY diff to a
# citizen stays RED.  Tooth: MA0_GATES_PLANT=citizen appends a file known
# to carry a post-seal diff — the no-diff gate must go RED there.
CITIZENS=(ADOPTION-RECORD-2026-08-08.md CLOSURE-TRANSCRIPT-2026-08-08.txt
  act0-fixtures.lisp act0-gates.lisp act0-load-witnesses.lisp
  act0-load-witnesses.sh act0-loader-disease.sh act0-selftest.lisp
  act0.lisp package.lisp)

SCRATCH="$(mktemp -d "${TMPDIR:-/tmp}/ma0-gates.XXXXXX")"
trap 'rm -rf "$SCRATCH"' EXIT INT TERM

PASSED=0
FAILED=0
UNAVAIL=0

gate() {  # gate NAME STATUS DETAIL...   STATUS: 1=pass, 0=fail, una=unavailable
  local name="$1" ok="$2"; shift 2
  case "$ok" in
    1)   PASSED=$((PASSED + 1));  echo "  [PASS] $name  $*" ;;
    una) UNAVAIL=$((UNAVAIL + 1)); echo "  [UNAVAILABLE] $name  $*" ;;
    *)   FAILED=$((FAILED + 1));  echo "  [FAIL] $name  $*" ;;
  esac
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
  # TD-2: the freeze table is LAB-SIDE staging evidence and is not part of the
  # published subject tree — on a public-mirror checkout it is structurally
  # absent.  That is unavailability, not an unchanged table and not a defect
  # of the checkout; it is still never a pass.
  gate "W-VF-UNCHANGED the V-F freeze table digest" una \
       "the freeze table is absent: $VF_READ — lab-side evidence, not in the published tree; this checkout cannot attempt the gate (TD-2)"
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
  for guarded in "$(sub mneme/verify-release.sh)" "$(sub mneme/language-act-0)" \
                 "$(sub lisp-plus.asd)"; do
    if [ -e "$REPO/$guarded" ]; then
      gate "W-FLOOR-UNTOUCHED the guarded path exists: $guarded" 1
    else
      gate "W-FLOOR-UNTOUCHED the guarded path exists: $guarded" 0 \
           "absent — every diff below would be vacuously empty"
    fi
  done
  # TD-5: build the guarded pathspec from the enumerated citizens.
  CITIZEN_PATHS=()
  MISSING=""
  for c in "${CITIZENS[@]}"; do
    CITIZEN_PATHS+=("$(sub "mneme/language-act-0/$c")")
    [ -e "$REPO/$(sub "mneme/language-act-0/$c")" ] || MISSING="$MISSING $c"
  done
  if [ -z "$MISSING" ]; then
    gate "W-FLOOR-UNTOUCHED all ten language-act-0 citizens exist" 1 "(${#CITIZENS[@]} named files)"
  else
    gate "W-FLOOR-UNTOUCHED all ten language-act-0 citizens exist" 0 "missing:$MISSING — every diff below would be vacuously empty for them"
  fi
  [ "$PLANT" = "citizen" ] && CITIZEN_PATHS+=("$(sub mneme/language-many-acts-0/MANY-ACTS-0-GRAMMAR.md)")
  # TD-1: the seal must EXIST in this checkout's history before any diff
  # against it means anything.  git reports a missing seal as rc=128 on
  # stderr with EMPTY stdout — which is exactly the shape of "no changes".
  # An errored diff is not an empty diff.
  if git -C "$REPO" cat-file -e "$SEAL^{commit}" 2>/dev/null; then
    UNTOUCHED="$(git -C "$REPO" diff "$SEAL..HEAD" --stat -- \
                   "$(sub mneme/verify-release.sh)" "${CITIZEN_PATHS[@]}" \
                   2>"$SCRATCH/diff.err")"; DIFF_RC=$?
    if [ "$DIFF_RC" -ne 0 ]; then
      gate "W-FLOOR-UNTOUCHED verify-release.sh + the ten citizens carry no diff since $SEAL" 0 \
           "git diff FAILED rc=$DIFF_RC: $(tail -1 "$SCRATCH/diff.err") — an errored diff is NOT an empty diff (TD-1)"
    elif [ -z "$UNTOUCHED" ]; then
      gate "W-FLOOR-UNTOUCHED verify-release.sh + the ten citizens carry no diff since $SEAL" 1 "(empty --stat, rc=0)"
    else
      gate "W-FLOOR-UNTOUCHED verify-release.sh + the ten citizens carry no diff since $SEAL" 0 \
           "$(printf '%s' "$UNTOUCHED" | tr '\n' ';')"
    fi
    ASD_NUM="$(git -C "$REPO" diff "$SEAL..HEAD" --numstat -- "$(sub lisp-plus.asd)" \
                 2>"$SCRATCH/asd.err")"; ASD_RC=$?
    if [ "$ASD_RC" -ne 0 ]; then
      gate "W-FLOOR-UNTOUCHED lisp-plus.asd shows ADDITIONS ONLY since $SEAL" 0 \
           "git diff FAILED rc=$ASD_RC: $(tail -1 "$SCRATCH/asd.err") — an errored diff is NOT a zero-deletion diff (TD-1)"
    else
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
    fi
  else
    gate "W-FLOOR-UNTOUCHED verify-release.sh + the ten citizens carry no diff since $SEAL" una \
         "seal $SEAL is not a commit in this checkout's history — public-mirror checkouts carry no lab history; the history gates cannot run here and are NOT reported as passes (TD-1)"
    gate "W-FLOOR-UNTOUCHED lisp-plus.asd shows ADDITIONS ONLY since $SEAL" una \
         "same: no seal in history, no diff to assert (TD-1)"
  fi
  # the working tree too: a gate that only reads committed history cannot see an
  # uncommitted edit sitting in the very files it is guarding.  (Runs in either
  # checkout shape; needs no seal.)
  DIRTY="$(git -C "$REPO" status --porcelain -- \
             "$(sub mneme/verify-release.sh)" "${CITIZEN_PATHS[@]}")"
  if [ -z "$DIRTY" ]; then
    gate "W-FLOOR-UNTOUCHED and neither is dirty in the working tree" 1 "(empty porcelain)"
  else
    gate "W-FLOOR-UNTOUCHED and neither is dirty in the working tree" 0 \
         "$(printf '%s' "$DIRTY" | tr '\n' ';')"
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
TOTAL=$((PASSED + FAILED + UNAVAIL))
FLOOR_NOTE=""
[ "$FLOOR_STATE" = "omitted" ] && FLOOR_NOTE=" (THE REDUCED FLOOR WAS OMITTED)"
if [ "$FAILED" -eq 0 ] && [ "$UNAVAIL" -eq 0 ]; then
  echo "ma0-campaign-gates: $TOTAL gates, 0 failures$FLOOR_NOTE"
  exit 0
elif [ "$FAILED" -eq 0 ]; then
  echo "ma0-campaign-gates: PARTIAL — $PASSED passed / $UNAVAIL unavailable of $TOTAL gates$FLOOR_NOTE (an unavailable gate is not a passed gate)"
  exit 2
fi
echo "ma0-campaign-gates: FAILED ($PASSED passed / $FAILED failed / $UNAVAIL unavailable of $TOTAL gates)$FLOOR_NOTE"
exit 1
