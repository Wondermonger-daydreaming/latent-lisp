#!/usr/bin/env bash
#
# run-surface1-candidate.sh — execute Language Surface /1 Candidate /0 and CAPTURE.
#
# This runner EXECUTES AND CAPTURES.  It renders no governance verdict of its
# own, keeps exit codes separately, and joins NO verify-*.sh floor.  Its standing
# banner defers to LANGUAGE-SURFACE-1-RETURN.md rather than restating a verdict
# it cannot verify.
#
# KNOWN PACKAGING LIMITATION, DECLARED UP FRONT: this runner WRITES tracked
# transcript files, so it cannot execute fully inside a frozen read-only target.
# Form /1's and Form /2's runners hit exactly this; the workaround is a writable
# scratch copy.  It is a packaging limitation, not a semantic defect, and it is
# said here rather than left for an auditor to discover.
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE"

REQUIRED=(package.lisp surface1.lisp surface1-selftest.lisp
          STUB-IMAGE-FIXTURE.lisp de-expansione-testata/APPLICATION.lisp
          errata-0.1/REPRODUCTION.lisp errata-0.2/REPRODUCTION-II.lisp)
MISSING=()
for f in "${REQUIRED[@]}"; do [ -f "$f" ] || MISSING+=("$f"); done
if [ ${#MISSING[@]} -gt 0 ]; then
  echo "  !!  run-surface1-candidate: REFUSING TO RUN — ${#MISSING[@]} required file(s) absent"
  printf '      %s\n' "${MISSING[@]}"
  exit 2
fi

SBCL_VERSION="$(sbcl --non-interactive --eval '(progn (princ (lisp-implementation-version)) (terpri))' 2>/dev/null | tail -1)"

# The subject label the instruments print.  Derived from the tree under test,
# never hard-coded to a past subject: an earlier revision baked "candidate
# 2e21f367, unpatched" into the instrument itself, so the AFTER capture
# identified itself as the tree it had been used to convict.
SUBJECT_LABEL="${SURFACE1_SUBJECT_LABEL:-$(git -C "$HERE" rev-parse --short HEAD 2>/dev/null || echo "working tree")}"

( sbcl --non-interactive --load surface1-selftest.lisp ) > RUN-SELFTEST.txt 2>&1
SELFTEST_EXIT=$?
( sbcl --non-interactive --load STUB-IMAGE-FIXTURE.lisp ) > RUN-STUB-IMAGE.txt 2>&1
STUB_EXIT=$?
( cd de-expansione-testata && sbcl --non-interactive --load APPLICATION.lisp ) > RUN-APPLICATION.txt 2>&1
APP_EXIT=$?
# THE REPRODUCTION INSTRUMENTS, kept as standing regression gates.  Against THIS
# tree every finding must come back REFUTED; the captures against the earlier
# subjects, where they were CONFIRMED, are preserved beside each errata document
# (see the paths printed in the banner below).
#
# ERRATA 0.2 — THE GATE WAS FAIL-OPEN AND IS NOW FAIL-CLOSED.  It recorded the
# instrument's exit code and then omitted it from the success condition, so a
# reproduction that CRASHED before printing anything scored zero CONFIRMED lines
# and the wrapper reported peace.  Counting zero of a string is not evidence that
# the string was ever going to be printed.  Each instrument now emits ONE
# canonical machine-readable line, and this wrapper requires the exact line —
# so a truncated run, a renamed label, an early exit or a crash all fail.
( sbcl --non-interactive --load errata-0.1/REPRODUCTION.lisp "$HERE/" \
       "$SUBJECT_LABEL" ) > RUN-REPRODUCTION.txt 2>&1
REPRO1_RAN=$?
( sbcl --non-interactive --load errata-0.2/REPRODUCTION-II.lisp "$HERE/" \
       "$SUBJECT_LABEL" ) > RUN-REPRODUCTION-II.txt 2>&1
REPRO2_RAN=$?

# The exact completed summaries.  Not a count of CONFIRMED lines — the count of a
# thing that never ran is also zero.
REPRO1_OK=0
grep -qxF "REPRODUCTION-RESULT verdicts=6 expected=6 confirmed=0" RUN-REPRODUCTION.txt \
  && REPRO1_OK=1
REPRO2_OK=0
grep -qxF "REPRODUCTION-RESULT verdicts=4 expected=4 confirmed=0" RUN-REPRODUCTION-II.txt \
  && REPRO2_OK=1

{
  echo "surface1-selftest      exit ${SELFTEST_EXIT}"
  echo "stub-image-fixture     exit ${STUB_EXIT}"
  echo "de-expansione-testata  exit ${APP_EXIT}"
  echo "reproduction I         exit ${REPRO1_RAN} · canonical summary matched ${REPRO1_OK} (must be 1)"
  echo "reproduction II        exit ${REPRO2_RAN} · canonical summary matched ${REPRO2_OK} (must be 1)"
} > RUN-EXITCODES.txt

cat <<BANNER

  LANGUAGE SURFACE /1 — CANDIDATE /0
  SBCL: ${SBCL_VERSION}

  EXECUTED (raw stdout+stderr captured, unfiltered):
    surface1-selftest.lisp                    exit ${SELFTEST_EXIT}    ->  RUN-SELFTEST.txt
    STUB-IMAGE-FIXTURE.lisp                   exit ${STUB_EXIT}    ->  RUN-STUB-IMAGE.txt
    de-expansione-testata/APPLICATION.lisp    exit ${APP_EXIT}    ->  RUN-APPLICATION.txt
    errata-0.1/REPRODUCTION.lisp               exit ${REPRO1_RAN} · summary matched ${REPRO1_OK}
                                              ->  RUN-REPRODUCTION.txt
    errata-0.2/REPRODUCTION-II.lisp           exit ${REPRO2_RAN} · summary matched ${REPRO2_OK}
                                              ->  RUN-REPRODUCTION-II.txt

  THE BEFORE CAPTURES, where these findings were CONFIRMED, are preserved at
    errata-0.1/pre-errata-evidence/REPRODUCTION-OUTPUT-2e21f367.txt
    errata-0.2/pre-errata-evidence/REPRODUCTION-II-OUTPUT-4f5c5982.txt
    exit codes retained in                    RUN-EXITCODES.txt

  THE STUB-IMAGE FIXTURE IS A SEPARATE PROCESS ON PURPOSE.  One refusal code is
  reachable only where Surface /0's package exists WITHOUT its macros.  Producing
  that state inside the selftest's image would mean unbinding a Surface /0 macro
  function — altering the layer under observation — so it gets its own image,
  which never loads surface0.lisp at all.

  WHAT THESE RUNS ESTABLISH: that the checks written in these files executed and
  reported what the transcripts show.  WHAT THEY DO NOT ESTABLISH: that any
  source form and its expansion mean the same thing; that any expansion is
  correct, evaluable, compilable, hygienic, or portable to another Common Lisp;
  that any lexical environment was captured (none ever is); or that any later
  success reaches backward to validate an expansion.  A receipt is an ACCOUNT,
  not an AUTHENTICATION.

  Every green is SELF-CONSISTENCY CERTIFICATION by the family that wrote the
  layer.  Standing — candidate, unaudited, unadopted, unfrozen, on no governing
  floor — is recorded in LANGUAGE-SURFACE-1-RETURN.md, not here.

BANNER

if [ "${SELFTEST_EXIT}" -eq 0 ] && [ "${STUB_EXIT}" -eq 0 ] && [ "${APP_EXIT}" -eq 0 ] \
   && [ "${REPRO1_RAN}" -eq 0 ] && [ "${REPRO1_OK}" -eq 1 ] \
   && [ "${REPRO2_RAN}" -eq 0 ] && [ "${REPRO2_OK}" -eq 1 ]; then
  exit 0
else
  exit 1
fi
