#!/usr/bin/env bash
#
# MUTATION-LEDGER.sh — the valid mutation battery for Language Form /0, with a
# ledger that records WHERE each mutant died.
#
# The distinction this script exists to preserve: a mutant that aborts the suite
# before reaching the invariant it was planted against is NOT evidence that the
# invariant is tested.  The run still fails, which is correct; but the ledger
# must say so rather than let an abort masquerade as a targeted kill.
#
# Mutants live at mneme/_mut-<name>/ so that ../../canonical-datum/ resolves.
#
# Run: bash MUTATION-LEDGER.sh     (exit 0 iff every mutant is killed)

set -uo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SRC/.." && pwd)"
LEDGER="$SRC/MUTATION-LEDGER.md"

KILLED=0; SURVIVED=0; ROWS=()

run_mutant () {
  local name="$1" tooth="$2" suite="${SUITE:-form0-selftest.lisp}"; shift 2
  local dir="$ROOT/_mut-$name"
  rm -rf "$dir"; mkdir -p "$dir"
  cp "$SRC"/form0.lisp "$SRC"/package.lisp "$SRC"/form0-selftest.lisp \
     "$SRC"/PUBLIC-SURFACE-AUDIT.lisp "$dir/"
  ( cd "$dir" && "$@" >/dev/null 2>&1 )

  if diff -q "$SRC/form0.lisp" "$dir/form0.lisp" >/dev/null 2>&1 \
     && diff -q "$SRC/package.lisp" "$dir/package.lisp" >/dev/null 2>&1; then
    printf '  %-24s  !! MUTATION DID NOT APPLY — battery invalid\n' "$name"
    ROWS+=("| \`$name\` | *(did not apply)* | $tooth | — | **BATTERY INVALID** |")
    SURVIVED=$((SURVIVED+1)); rm -rf "$dir"; return
  fi

  local out rc marker reached verdict
  out=$(cd "$dir" && sbcl --non-interactive --load "$suite" 2>&1)
  rc=$?

  # Did the intended tooth actually report a failure?
  if printf '%s' "$out" | grep -q "^  FAIL .*$tooth"; then
    reached="yes"
    marker="named FAIL at $tooth"
  elif printf '%s' "$out" | grep -q "$tooth"; then
    reached="reached, other marker"
    marker=$(printf '%s' "$out" | grep -m1 "^  FAIL" | sed 's/^  FAIL //' | cut -c1-60)
    [ -z "$marker" ] && marker="suite aborted after reaching the tooth"
  else
    reached="NO — died earlier"
    marker=$(printf '%s' "$out" | grep -m1 -E "Unhandled|form refused" | cut -c1-60)
    [ -z "$marker" ] && marker="suite aborted before the tooth"
  fi

  if [ "$rc" -ne 0 ]; then
    KILLED=$((KILLED+1)); verdict="KILLED"
  else
    SURVIVED=$((SURVIVED+1)); verdict="**SURVIVED**"
  fi

  printf '  %-24s  %-10s intended=%-34s reached=%s\n' "$name" "$verdict" "$tooth" "$reached"
  ROWS+=("| \`$name\` | see script | \`$tooth\` | $marker | $verdict / reached: $reached |")
  rm -rf "$dir"
}

echo
echo "  ══ Language Form /0 — MUTATION BATTERY ══"
echo

run_mutant no-species-check T-WRONG-SPECIES \
  sed -i 's|(unless (%species-match-p (form-hole-expected-species hole) value)|(unless (or t (%species-match-p (form-hole-expected-species hole) value))|' form0.lisp

run_mutant two-pass-substitute T-ONE-PASS \
  perl -0777 -pi -e 's/\(literal-node \(cdr pair\)\)\)\)/(cdr pair)))/' form0.lisp

run_mutant no-env-identity-gate T-SAME-LOOKING-DIFFERENT-ENVIRONMENT \
  perl -0777 -pi -e 's/\(unless \(%same \(form-validation-receipt-environment-identity receipt\)\s*\n\s*\(%form-environment-identity environment\)\)/(unless t/' form0.lisp

run_mutant no-content-digest-gate T-ENVIRONMENT-CONTENT-DRIFT \
  perl -0777 -pi -e 's/\(unless \(equal \(form-validation-receipt-environment-content-digest receipt\)\s*\n\s*\(%form-environment-content-digest environment\)\)/(unless t/' form0.lisp

run_mutant boundary-accepts-host T-HOST-SYMBOL-REFUSED \
  sed -i 's|(unless (lisp-plus-cd0:datum-p candidate)|(unless (or t (lisp-plus-cd0:datum-p candidate))|' form0.lisp

run_mutant unfilled-hole-allowed T-UNFILLED-HOLE \
  perl -0777 -pi -e "s/\(unless \(assoc identifier pairs :test #'%same\)/(unless t/" form0.lisp

run_mutant no-arity-gate T-OPERATOR-ARITY \
  perl -0777 -pi -e 's/\(unless \(= \(operator-descriptor-arity descriptor\) \(1- size\)\)/(unless t/' form0.lisp

run_mutant literal-descends T-ONE-PASS \
  perl -0777 -pi -e 's/\(:literal node\)/(:literal (lisp-plus-cd0:make-sequence-datum (list (%lit-head) (%substitute (lisp-plus-cd0:sequence-datum-ref node 1) bindings))))/' form0.lisp

run_mutant no-snapshot T-SNAPSHOT-IS-INDEPENDENT \
  perl -0777 -pi -e 's/\(defun %snapshot \(datum\)\n  \(lisp-plus-cd0:decode-exact \(lisp-plus-cd0:canonical-octets datum\)\)\)/(defun %snapshot (datum) datum)/' form0.lisp

# ── The option-(c) regression mutant.  Restores the public constructor that
#    let a caller supply a handler — the exploit the owner ruled must become
#    unconstructible.  It is checked against the PUBLIC-SURFACE suite, which is
#    the suite that owns that boundary.
SUITE=PUBLIC-SURFACE-AUDIT.lisp run_mutant restore-arbitrary-handler \
  "5. MAKE-OPERATOR-DESCRIPTOR does not exist" \
  bash -c 'printf "\n(in-package #:lisp-plus-form0)\n(defun make-operator-descriptor (name arity species handler)\n  (%%make-operator-descriptor :identity (operator-identifier name) :arity arity\n                             :result-species species :handler handler))\n(export (list (quote make-operator-descriptor)) :lisp-plus-form0)\n" >> form0.lisp'

{
  echo "# LANGUAGE FORM /0 — MUTATION LEDGER"
  echo
  echo "*Machine-generated by \`MUTATION-LEDGER.sh\`. Do not hand-edit.*"
  echo
  echo "A mutant is **not** counted as evidentially killed merely because the suite"
  echo "aborted. The \`reached\` column records whether the invariant the mutant was"
  echo "planted against actually reported the failure."
  echo
  echo "| mutant | mutation | intended tooth | observed failure marker | verdict |"
  echo "|---|---|---|---|---|"
  for row in "${ROWS[@]}"; do echo "$row"; done
  echo
  echo "**killed: $KILLED · survived: $SURVIVED**"
  echo
  echo "## The invalid first battery, preserved"
  echo
  echo "The first battery run against Candidate /0 was **invalid**: mutants were copied"
  echo "to \`/tmp\`, where CD/0's \`../../\` path cannot resolve, so all five reported"
  echo "\"killed\" while really dying of a missing file. It was caught only because one"
  echo "mutant that provably had **not** been applied still reported KILLED — a green"
  echo "that was structurally impossible. This script therefore checks that each"
  echo "mutation actually changed the file before trusting its verdict."
} > "$LEDGER"

echo
echo "  ledger written: $LEDGER"
echo "  killed=$KILLED  survived=$SURVIVED"
[ "$SURVIVED" -eq 0 ] || exit 1
