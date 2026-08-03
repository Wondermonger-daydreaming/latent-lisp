#!/usr/bin/env bash
#
# zero-lisp-proof.sh — prove the Integration Baseline carries zero .lisp changes
#                      above the ACCEPTED Form /2 erratum tip.
#
#   bash mneme/integration-baseline-0/zero-lisp-proof.sh [<base>] [<tip>] [<outdir>]
#   bash mneme/integration-baseline-0/zero-lisp-proof.sh --controls [<outdir>]
#
#   defaults: base = 5057ec11 (accepted erratum tip), tip = HEAD, out = this dir
#
# ---------------------------------------------------------------------------
# THREE STATES, MUTUALLY EXCLUSIVE — R3 Correction B
# ---------------------------------------------------------------------------
#
#   git diff FAILED                  -> nonzero exit, and NO "ZERO" prose is
#                                       written. A proof whose measurement did
#                                       not run must never read as a pass.
#   git diff OK, capture NONEMPTY    -> "NON-EMPTY" prose, nonzero exit
#   git diff OK, capture EMPTY       -> "ZERO" prose, exit 0
#
# R1's version could say both ZERO and NON-EMPTY in one file. R2 fixed that but
# still conflated "empty output" with "success": a `git diff` that died with
# exit 128 produces empty stdout, and an emptiness test alone would have called
# that ZERO. R3 checks the EXIT STATUS FIRST and only then the bytes.
#
# ORDER OF OPERATIONS, and it is the whole point:
#   1. run git diff into a TEMPORARY file, capturing its exit status
#   2. if that status is nonzero -> refuse; publish nothing as a proof
#   3. only now publish the temp file as the raw capture
#   4. test the published capture for emptiness
#   5. write prose GENERATED FROM the outcome
#
# The parcel builder must propagate this script's exit status.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"

# --- control mode ----------------------------------------------------------
if [ "${1:-}" = "--controls" ]; then
  OUT="${2:-${TMPDIR:-/tmp}}"
  echo "==========================================================================="
  echo " ZERO-.LISP PROOF — BOUNDED CONTROLS"
  echo " Each control must land in the state named, and no other."
  echo "==========================================================================="
  echo
  fails=0
  work="$(mktemp -d "${TMPDIR:-/tmp}/zlp-controls.XXXXXX")"
  trap 'rm -rf "$work"' EXIT INT TERM

  # C1 — a real .lisp delta must be REJECTED.
  bash "$HERE/zero-lisp-proof.sh" e3c7d436 HEAD "$work/c1" >"$work/c1.log" 2>&1
  rc=$?
  if [ "$rc" -ne 0 ] && grep -q "THE ZERO CLAIM IS FALSE" "$work/c1/ZERO-LISP-PROOF.md" 2>/dev/null \
     && ! grep -q "^## RESULT: ZERO" "$work/c1/ZERO-LISP-PROOF.md" 2>/dev/null; then
    echo "  C1 real .lisp delta                     REJECTED (exit $rc, NON-EMPTY prose)"
  else
    echo "  C1 real .lisp delta                     !! NOT REJECTED (exit $rc)"; fails=$((fails+1))
  fi

  # C2 — git diff exit 128 with EMPTY stdout must be REJECTED, not read as ZERO.
  #      A fake `git` earlier on PATH returns 128 and prints nothing.
  mkdir -p "$work/fakebin"
  cat > "$work/fakebin/git" <<'FAKE'
#!/bin/sh
case "$*" in
  *"rev-parse"*) echo "0000000000000000000000000000000000000000"; exit 0 ;;
  *"diff"*)      exit 128 ;;                # empty stdout, failure status
  *)             exit 0 ;;
esac
FAKE
  chmod +x "$work/fakebin/git"
  PATH="$work/fakebin:$PATH" bash "$HERE/zero-lisp-proof.sh" AAA BBB "$work/c2" >"$work/c2.log" 2>&1
  rc=$?
  if [ "$rc" -ne 0 ] && ! grep -q "RESULT: ZERO" "$work/c2/ZERO-LISP-PROOF.md" 2>/dev/null; then
    echo "  C2 git diff exit 128, empty stdout      REJECTED (exit $rc, no ZERO prose)"
    grep -m1 "DIFF FAILED\|RESULT:" "$work/c2/ZERO-LISP-PROOF.md" 2>/dev/null | sed 's/^/       /'
  else
    echo "  C2 git diff exit 128, empty stdout      !! NOT REJECTED (exit $rc)"; fails=$((fails+1))
  fi

  # C3 — a genuine empty diff must be ACCEPTED.
  bash "$HERE/zero-lisp-proof.sh" 5057ec11 HEAD "$work/c3" >"$work/c3.log" 2>&1
  rc=$?
  if [ "$rc" -eq 0 ] && grep -q "^## RESULT: ZERO" "$work/c3/ZERO-LISP-PROOF.md" 2>/dev/null; then
    echo "  C3 genuine empty diff                   ACCEPTED (exit 0, ZERO prose)"
  else
    echo "  C3 genuine empty diff                   !! NOT ACCEPTED (exit $rc)"; fails=$((fails+1))
  fi

  echo
  if [ "$fails" -eq 0 ]; then
    echo " All three controls behaved. The proof can fail, so its ZERO is evidence."
    exit 0
  fi
  echo " CONTROLS FAILED: $fails"
  exit 1
fi

# --- normal mode -----------------------------------------------------------
BASE="${1:-5057ec11ea892ea4400a06525a2f1c91ead5eea3}"
TIP="${2:-HEAD}"
OUT="${3:-$HERE}"
mkdir -p "$OUT"
RAW="$OUT/ZERO-LISP-DIFF-RAW.patch"
PROSE="$OUT/ZERO-LISP-PROOF.md"
rm -f "$RAW" "$PROSE"

cd "$ROOT"
BASE_FULL="$(git rev-parse --verify "${BASE}^{commit}" 2>/dev/null)" || BASE_FULL="$BASE"
TIP_FULL="$(git rev-parse --verify "${TIP}^{commit}" 2>/dev/null)"   || TIP_FULL="$TIP"

TMPRAW="$(mktemp "${TMPDIR:-/tmp}/zlp-raw.XXXXXX")"
git diff --binary "$BASE_FULL" "$TIP_FULL" -- '*.lisp' > "$TMPRAW" 2>"$TMPRAW.err"
GIT_RC=$?

# STATE 1 — the measurement itself failed.
if [ "$GIT_RC" -ne 0 ]; then
  {
    echo "# Zero-\`.lisp\` proof — MEASUREMENT FAILED"
    echo
    echo "## RESULT: DIFF FAILED — NO CLAIM IS MADE"
    echo
    echo '```'
    echo "base    : $BASE_FULL"
    echo "tip     : $TIP_FULL"
    echo "command : git diff --binary <base> <tip> -- '*.lisp'"
    echo "exit    : $GIT_RC"
    echo "stderr  : $(head -3 "$TMPRAW.err" 2>/dev/null | tr '\n' ' ')"
    echo '```'
    echo
    echo "\`git diff\` did not succeed, so **no raw capture was published and no ZERO"
    echo "claim is made.** An empty stdout from a failed command is not an empty diff —"
    echo "conflating the two is exactly the defect this contract exists to prevent."
  } > "$PROSE"
  rm -f "$TMPRAW" "$TMPRAW.err"
  echo "base : $BASE_FULL"
  echo "tip  : $TIP_FULL"
  echo "RESULT: DIFF FAILED (git exit $GIT_RC) — refusing" >&2
  exit 1
fi

# The measurement succeeded: only NOW publish the capture.
mv "$TMPRAW" "$RAW"
rm -f "$TMPRAW.err"

RAW_BYTES=$(wc -c < "$RAW" | tr -d ' ')
RAW_LINES=$(wc -l < "$RAW" | tr -d ' ')

{
  echo "# Zero-\`.lisp\` proof — Integration Baseline above the accepted erratum"
  echo
  echo "Generated by \`mneme/integration-baseline-0/zero-lisp-proof.sh\`."
  echo "The wording below is chosen by the measurement, not written beside it."
  echo
  echo '```'
  echo "base (accepted Form /2 erratum) : $BASE_FULL"
  echo "tip  (Integration Baseline)     : $TIP_FULL"
  echo "command                         : git diff --binary <base> <tip> -- '*.lisp'"
  echo "git exit status                 : 0 (the measurement ran)"
  echo "raw capture                     : ZERO-LISP-DIFF-RAW.patch"
  echo "raw capture size                : ${RAW_BYTES} bytes, ${RAW_LINES} lines"
  echo '```'
  echo
  if [ "$RAW_BYTES" -eq 0 ]; then
    echo "## RESULT: ZERO"
    echo
    echo "\`git diff\` succeeded **and** its raw capture is **empty — 0 bytes**. The"
    echo "Integration Baseline changes **no \`.lisp\` file whatsoever** above the accepted"
    echo "Form /2 erratum tip."
    echo
    echo "Both conditions are required. Either alone would be worthless."
  else
    echo "## RESULT: NON-EMPTY — THE ZERO CLAIM IS FALSE"
    echo
    echo "The raw capture is **${RAW_BYTES} bytes over ${RAW_LINES} lines**. The"
    echo "Integration Baseline DOES change \`.lisp\` files above the accepted erratum tip."
    echo
    echo "Files touched:"
    echo
    echo '```'
    git diff --name-only "$BASE_FULL" "$TIP_FULL" -- '*.lisp'
    echo '```'
    echo
    echo "This document does not claim zero. The parcel build must refuse."
  fi
  echo
  echo "---"
  echo
  echo "*Three states are kept mutually exclusive: a failed measurement, a nonempty"
  echo "capture, and an empty capture. R1's proof could assert both ZERO and NON-EMPTY"
  echo "in one file. R2's fixed that but still treated empty output as success — and a"
  echo "\`git diff\` that dies with exit 128 also produces empty output. The exit status"
  echo "is now checked FIRST, and the capture is published only after it succeeds.*"
} > "$PROSE"

echo "base : $BASE_FULL"
echo "tip  : $TIP_FULL"
echo "raw  : $RAW (${RAW_BYTES} bytes)"
echo "prose: $PROSE"
if [ "$RAW_BYTES" -eq 0 ]; then
  echo "RESULT: ZERO (git succeeded, raw capture empty)"
  exit 0
fi
echo "RESULT: NON-EMPTY — refusing" >&2
exit 1
