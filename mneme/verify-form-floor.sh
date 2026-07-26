#!/usr/bin/env bash
#
# verify-form-floor.sh — the CANDIDATE floor for Language Form /0.
#
# SEPARATELY NAMED ON PURPOSE.  verify-all.sh is the conformance/atelier floor
# and verify-language-floor.sh is the language floor of the eleven ADOPTED-OR-
# CANDIDATE layers that preceded this one.  Form /0 is neither adopted nor
# frozen, so it does not join either of them by editing a number in their
# expectation tables.  It gets its own command and its own exit code, and the
# decision to fold it into verify-language-floor.sh is a separate, later, owner
# decision — not a side effect of this file existing.
#
# Run: bash verify-form-floor.sh        (exit 0 iff both floors match)

set -uo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
FORM0="$ROOT/language-form-0"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# ── Expectation table — the ONLY place to edit when a floor legitimately moves.
#    Measured live 2026-07-26, SBCL 2.4.6, all green.
EXPECT_TEETH=152         # "== Language Form /0 teeth: N passed / 0 failed =="
EXPECT_DORMIENTE=24      # "== de-forma-dormiente: N checks passed / 0 failed =="
EXPECT_SURFACE=23        # "== Form /0 public surface: N passed / 0 failed ..."

FAILURES=()

report() { printf '  %-4s  %-26s  %s\n' "$1" "$2" "$3"; }

fail() {  # $1=name $2=detail $3=rawlog
  FAILURES+=("$1")
  report "FAIL" "$1" "$2"
  echo "  ── raw output of the failing floor ─────────────────────────────"
  sed 's/^/  │ /' "$3" | tail -25
  echo "  ────────────────────────────────────────────────────────────────"
}

# check_floor NAME DIR ENTRYFILE EXPECTED PASS_REGEX
#   PASS_REGEX must use \K so the match BEGINS at the pass count — the same
#   lesson verify-language-floor.sh records: a bare \d+ extractor applied to
#   "Form /0 teeth: 87" returns the 0 in "/0".
check_floor() {
  local name="$1" dir="$2" entry="$3" expected="$4" regex="$5"
  local log="$WORK/$name.log"
  ( cd "$dir" && sbcl --non-interactive --load "$entry" ) >"$log" 2>&1
  local rc=$?
  local got failed
  got="$(grep -oP "$regex" "$log" | tail -1)"
  failed="$(grep -cE '0 failed' "$log")"

  if [ "$rc" -ne 0 ]; then
    fail "$name" "nonzero exit $rc" "$log"; return
  fi
  if [ -z "${got:-}" ]; then
    fail "$name" "no tally line matched — the suite's banner changed?" "$log"; return
  fi
  if [ "$failed" -eq 0 ]; then
    fail "$name" "no '0 failed' line — something failed inside" "$log"; return
  fi
  if [ "$got" -ne "$expected" ]; then
    fail "$name" "expected $expected passed, got $got — a check was ADDED or LOST" "$log"; return
  fi
  report "PASS" "$name" "$got passed / 0 failed"
}

echo
echo "  ══════════════════════════════════════════════════════════════════"
echo "  MNEME — verify-form-floor : Language Form /0, CANDIDATE /0"
echo "  ══════════════════════════════════════════════════════════════════"
echo
echo "  SBCL: $(sbcl --non-interactive --eval '(princ (lisp-implementation-version))' 2>/dev/null | tail -1)  (expected 2.4.6)"
echo

check_floor "form0-teeth"      "$FORM0" "form0-selftest.lisp" \
            "$EXPECT_TEETH"      'Language Form /0 teeth: \K\d+'
check_floor "de-forma-dormiente" "$FORM0/de-forma-dormiente" "APPLICATION.lisp" \
            "$EXPECT_DORMIENTE"  'de-forma-dormiente: \K\d+'
check_floor "public-surface"   "$FORM0" "PUBLIC-SURFACE-AUDIT.lisp" \
            "$EXPECT_SURFACE"    'Form /0 public surface: \K\d+'

echo
# The banner must not be able to claim a floor the script did not run: this
# asserts the number of PASS/FAIL verdicts actually produced.
VERDICTS=3
if [ ${#FAILURES[@]} -eq 0 ]; then
  total=$((EXPECT_TEETH + EXPECT_DORMIENTE + EXPECT_SURFACE))
  echo "  FORM FLOOR GREEN — $VERDICTS floors, $total checks, 0 failed."
  echo "  SCOPE (S-1): package-controlled operator installation is a PUBLIC-API"
  echo "  enforcement boundary, NOT process isolation. Hostile Common Lisp already"
  echo "  running in this image is outside the declared threat model — see"
  echo "  language-form-0/LANGUAGE-FORM-0-WORK-ORDER.md §0."
  echo
  echo "  STANDING: candidate implementation · specification-frozen: no ·"
  echo "  adopted: no · stranger audit OWED · Slice /3 NOT opened."
  echo
  echo "  These greens are SELF-CONSISTENCY CERTIFICATION, never independent"
  echo "  conformance: one model family wrote the layer, its operators, the"
  echo "  inhabited program and these checks. The latent adapter is a labelled"
  echo "  scripted fake — no model or provider was called, and nothing here is"
  echo "  evidence that any external process emitted a form. Realization"
  echo "  computes over data and returns data: it mints no claim, source basis,"
  echo "  derivation basis, capability, authority or warrant."
  echo
  exit 0
else
  echo "  ✗✗ FORM FLOOR CRACKED — ${#FAILURES[@]} floor(s): ${FAILURES[*]}"
  echo "  DO NOT COMMIT until every floor is green again."
  echo
  exit 1
fi
