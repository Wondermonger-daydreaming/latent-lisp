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
          errata-0.1/REPRODUCTION.lisp)
MISSING=()
for f in "${REQUIRED[@]}"; do [ -f "$f" ] || MISSING+=("$f"); done
if [ ${#MISSING[@]} -gt 0 ]; then
  echo "  !!  run-surface1-candidate: REFUSING TO RUN — ${#MISSING[@]} required file(s) absent"
  printf '      %s\n' "${MISSING[@]}"
  exit 2
fi

SBCL_VERSION="$(sbcl --non-interactive --eval '(progn (princ (lisp-implementation-version)) (terpri))' 2>/dev/null | tail -1)"

( sbcl --non-interactive --load surface1-selftest.lisp ) > RUN-SELFTEST.txt 2>&1
SELFTEST_EXIT=$?
( sbcl --non-interactive --load STUB-IMAGE-FIXTURE.lisp ) > RUN-STUB-IMAGE.txt 2>&1
STUB_EXIT=$?
( cd de-expansione-testata && sbcl --non-interactive --load APPLICATION.lisp ) > RUN-APPLICATION.txt 2>&1
APP_EXIT=$?
# ERRATA 0.1 — the defect-report reproduction, kept as a standing regression
# instrument.  Against THIS tree every finding must come back REFUTED; the
# capture against the original candidate, where all six were CONFIRMED, is
# preserved at errata-0.1/pre-errata-evidence/.
( sbcl --non-interactive --load errata-0.1/REPRODUCTION.lisp "$HERE/" ) > RUN-REPRODUCTION.txt 2>&1
REPRO_RAN=$?
REPRO_CONFIRMED="$(grep -c '^  CONFIRMED' RUN-REPRODUCTION.txt)"

{
  echo "surface1-selftest      exit ${SELFTEST_EXIT}"
  echo "stub-image-fixture     exit ${STUB_EXIT}"
  echo "de-expansione-testata  exit ${APP_EXIT}"
  echo "reproduction           exit ${REPRO_RAN} · confirmed findings ${REPRO_CONFIRMED} (must be 0)"
} > RUN-EXITCODES.txt

cat <<BANNER

  LANGUAGE SURFACE /1 — CANDIDATE /0
  SBCL: ${SBCL_VERSION}

  EXECUTED (raw stdout+stderr captured, unfiltered):
    surface1-selftest.lisp                    exit ${SELFTEST_EXIT}    ->  RUN-SELFTEST.txt
    STUB-IMAGE-FIXTURE.lisp                   exit ${STUB_EXIT}    ->  RUN-STUB-IMAGE.txt
    de-expansione-testata/APPLICATION.lisp    exit ${APP_EXIT}    ->  RUN-APPLICATION.txt
    errata-0.1/REPRODUCTION.lisp               ${REPRO_CONFIRMED} findings still CONFIRMED (must be 0)
                                              ->  RUN-REPRODUCTION.txt
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
   && [ "${REPRO_CONFIRMED}" -eq 0 ]; then
  exit 0
else
  exit 1
fi
