#!/usr/bin/env bash
#
# verify-language-floor.sh — the LANGUAGE floor for Mneme (Lisp+).
#
# Companion to verify-all.sh, which is the conformance/atelier floor. Between
# them they are the CI surface; neither is complete alone.
#
# WHY THIS EXISTS. verify-all.sh describes itself as "the single CI floor for
# Mneme", and it runs the conformance walk, the adversarial and counterexample
# suites, the boundary suite, the atelier and the language-a fixtures. It does
# NOT run Core /0, Core /0 issuance, Slice /1, SMOKE-1, or any of the four
# inhabited applications. Every "no regression" claim about the language layers
# therefore rested on somebody running eight commands by hand and remembering
# eight numbers. This script is those numbers, in code.
#
# ONE command, ONE exit code, a fixed-width diffable summary. Any count that
# moves — up OR down — is reported and fails the run. A suite that grows a
# legitimate new check updates the table below, deliberately, in a commit.
#
# Run: bash verify-language-floor.sh        (exit 0 iff every floor matches)

set -uo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
CORE0="$ROOT/language-core-0"
SLICE1="$ROOT/language-slice-1"
SLICE2="$ROOT/language-slice-2"
SURF0="$ROOT/language-surface-0"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# ── Expectation table — the ONLY place to edit when a floor legitimately moves.
#    Measured live 2026-07-25, SBCL 2.4.6, all green.
#      Candidate /0 raised: issuance 59->73, bibliotheca 97->108, codice 89->101
#      Candidate /1 raised: slice2 75->108, bibliotheca 108->116
#      Surface  /0 raised: bibliotheca 116->123, and ADDED the 11th floor
#    Everything else has not moved and must not. A count that rises is a
#    deliberate line-edit in a commit; a count that falls is a regression.
EXPECT_CORE0=29                 # "== Core /0 substrate teeth: N passed / 0 failed =="
EXPECT_CORE0_ISSUANCE=73        # "== Core /0 issuance teeth: N passed / 0 failed =="
EXPECT_SLICE1=123               # "slice1 selftest: N passed, 0 failed"
EXPECT_SMOKE1=9                 # "slice1 public smoke: N/N, 0 failed"
EXPECT_BIBLIOTHECA=123           # "de-bibliotheca-peregrina: N checks passed / 0 failed"
EXPECT_CODICE=101                # "de-codice-restaurando: N checks passed / 0 failed"
EXPECT_CURSORE=23               # "de-cursore-aereo: N checks passed / 0 failed"
EXPECT_PONTE=17                 # "de-ponte-usto: N checks passed / 0 failed"

EXPECT_SLICE2=108                # "== Language Slice /2 teeth: N passed / 0 failed =="
EXPECT_SMOKE2=10                # "slice2 public smoke: N/N, 0 failed"
EXPECT_SURFACE0=38              # "== Language Surface /0 teeth: N passed / 0 failed ==

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
#   PASS_REGEX must use \K so the match BEGINS at the pass count. Learned the
#   hard way: a regex like 'Core /0 substrate teeth: \d+ passed' piped into a
#   bare '\d+' extractor returns the 0 in "/0", and 'slice1 selftest: \d+'
#   returns the 1 in "slice1". Both read as a cracked floor on a green suite.
check_floor() {
  local name="$1" dir="$2" entry="$3" expected="$4" regex="$5"
  local log="$WORK/$name.log"
  ( cd "$dir" && sbcl --non-interactive --load "$entry" ) >"$log" 2>&1
  local rc=$?
  local got failed
  got="$(grep -oP "$regex" "$log" | tail -1)"
  failed="$(grep -icE '(^|[^0-9])0 failed' "$log")"

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
echo "  MNEME — verify-language-floor : Core /0 · Slice /1 · Slice /2 · Surface /0"
echo "  ══════════════════════════════════════════════════════════════════"
echo
echo "  SBCL: $(sbcl --non-interactive --eval '(princ (lisp-implementation-version))' 2>/dev/null | tail -1)  (expected 2.4.6)"
echo

check_floor "core0-substrate"    "$CORE0"  "core0-selftest.lisp" \
            "$EXPECT_CORE0"           'Core /0 substrate teeth: \K\d+'
check_floor "core0-issuance"     "$CORE0"  "core0-issuance-selftest.lisp" \
            "$EXPECT_CORE0_ISSUANCE"  'Core /0 issuance teeth: \K\d+'
check_floor "slice1-selftest"    "$SLICE1" "slice1-selftest.lisp" \
            "$EXPECT_SLICE1"          'slice1 selftest: \K\d+'
check_floor "slice1-smoke"       "$SLICE1" "SMOKE-1.lisp" \
            "$EXPECT_SMOKE1"          'slice1 public smoke: \K\d+'

check_floor "de-bibliotheca"     "$CORE0/de-bibliotheca-peregrina" "APPLICATION.lisp" \
            "$EXPECT_BIBLIOTHECA"     'de-bibliotheca-peregrina: \K\d+'
check_floor "de-codice"          "$CORE0/de-codice-restaurando"    "APPLICATION.lisp" \
            "$EXPECT_CODICE"          'de-codice-restaurando: \K\d+'
check_floor "de-cursore-aereo"   "$CORE0/de-cursore-aereo"         "SPECIMEN.lisp" \
            "$EXPECT_CURSORE"         'de-cursore-aereo: \K\d+'
check_floor "de-ponte-usto"      "$CORE0/de-ponte-usto"            "SPECIMEN.lisp" \
            "$EXPECT_PONTE"           'de-ponte-usto: \K\d+'

check_floor "slice2-selftest"    "$SLICE2" "slice2-selftest.lisp" \
            "$EXPECT_SLICE2"          'Language Slice /2 teeth: \K\d+'
check_floor "slice2-smoke"       "$SLICE2" "SMOKE-2.lisp" \
            "$EXPECT_SMOKE2"          'slice2 public smoke: \K\d+'

check_floor "surface0-selftest"  "$SURF0"  "surface0-selftest.lisp" \
            "$EXPECT_SURFACE0"        'Language Surface /0 teeth: \K\d+'

echo
if [ ${#FAILURES[@]} -eq 0 ]; then
  total=$((EXPECT_CORE0 + EXPECT_CORE0_ISSUANCE + EXPECT_SLICE1 + EXPECT_SMOKE1 \
          + EXPECT_BIBLIOTHECA + EXPECT_CODICE + EXPECT_CURSORE + EXPECT_PONTE \
          + EXPECT_SLICE2 + EXPECT_SMOKE2 + EXPECT_SURFACE0))
  echo "  LANGUAGE FLOOR GREEN — 11 floors, $total checks, 0 failed."
  echo
  echo "  All greens here are SELF-CONSISTENCY CERTIFICATION, never independent"
  echo "  conformance: one model family wrote the language, the applications and"
  echo "  these checks. The adapters are labelled scripted fakes — a real governed"
  echo "  in-image act, never evidence that an external deed occurred."
  echo
  exit 0
else
  echo "  ✗✗ LANGUAGE FLOOR CRACKED — ${#FAILURES[@]} floor(s): ${FAILURES[*]}"
  echo "  DO NOT COMMIT until every floor is green again."
  echo
  exit 1
fi
