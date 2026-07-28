#!/usr/bin/env bash
#
# run-form2-candidate.sh — execute Language Form /2 Candidate /0 and CAPTURE.
#
# This runner EXECUTES AND CAPTURES.  It renders no governance verdict of its
# own, keeps exit codes separately, and does not join any verify-*.sh floor.
# Its standing banner defers to LANGUAGE-FORM-2-RETURN.md rather than restating
# a verdict it cannot verify.
#
# KNOWN PACKAGING LIMITATION, DECLARED UP FRONT: this runner WRITES tracked
# transcript files, so it cannot execute fully inside a frozen read-only target.
# Form /1's stranger audit hit exactly this and worked around it with a writable
# scratch copy.  It is a packaging limitation, not a semantic defect, and it is
# said here rather than left for an auditor to discover.
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE"

REQUIRED=(package.lisp form2.lisp form2-selftest.lisp de-forma-mutata/APPLICATION.lisp)
MISSING=()
for f in "${REQUIRED[@]}"; do [ -f "$f" ] || MISSING+=("$f"); done
if [ ${#MISSING[@]} -gt 0 ]; then
  echo "  !!  run-form2-candidate: REFUSING TO RUN — ${#MISSING[@]} required file(s) absent"
  printf '      %s\n' "${MISSING[@]}"
  exit 2
fi

SBCL_VERSION="$(sbcl --non-interactive --eval '(progn (princ (lisp-implementation-version)) (terpri))' 2>/dev/null | tail -1)"

( sbcl --non-interactive --load form2-selftest.lisp ) > RUN-SELFTEST.txt 2>&1
SELFTEST_EXIT=$?
( cd de-forma-mutata && sbcl --non-interactive --load APPLICATION.lisp ) > RUN-APPLICATION.txt 2>&1
APP_EXIT=$?

{
  echo "form2-selftest        exit ${SELFTEST_EXIT}"
  echo "de-forma-mutata       exit ${APP_EXIT}"
} > RUN-EXITCODES.txt

cat <<BANNER

  LANGUAGE FORM /2 — CANDIDATE /0
  SBCL: ${SBCL_VERSION}

  EXECUTED (raw stdout+stderr captured, unfiltered):
    form2-selftest.lisp                 exit ${SELFTEST_EXIT}    ->  RUN-SELFTEST.txt
    de-forma-mutata/APPLICATION.lisp    exit ${APP_EXIT}    ->  RUN-APPLICATION.txt
    exit codes retained in              RUN-EXITCODES.txt

  SUITE FOOTERS (verbatim from the captures — quoted, NOT verified here):
$(grep -h '== form2-selftest:' RUN-SELFTEST.txt 2>/dev/null | sed 's/^/    /')
$(grep -h '== de-forma-mutata:' RUN-APPLICATION.txt 2>/dev/null | sed 's/^/    /')

  Reconcile with:  bash check-form2-transcript.sh

  STANDING: this is a CANDIDATE implementation, run for SELF-CONSISTENCY ONLY.
  It implies no adoption and no specification freeze, and Form /2 joins no
  governing floor.  Current audit, adoption and freeze standing is recorded in
  LANGUAGE-FORM-2-RETURN.md, which is the governing record; this banner is not.

BANNER

[ ${SELFTEST_EXIT} -eq 0 ] && [ ${APP_EXIT} -eq 0 ]
