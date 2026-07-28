#!/usr/bin/env bash
#
# run-surface1-candidate.sh — execute Language Surface /1 Candidate /0 and CAPTURE.
#
# This runner EXECUTES AND CAPTURES.  It renders no governance verdict of its
# own, keeps exit codes separately, and joins NO verify-*.sh floor.  Its standing
# banner defers to LANGUAGE-SURFACE-1-RETURN.md rather than restating a verdict
# it cannot verify.
#
# ============================================================================
# ERRATA 0.3 / D4 — WHAT WAS WRONG WITH THIS FILE, IN ITS OWN WORDS.
#
# Errata 0.2 wrote here: "Each instrument now emits ONE canonical machine-readable
# line, and this wrapper requires the exact line — so a truncated run, a renamed
# label, an early exit or a crash all fail."  THAT SENTENCE WAS FALSE OF THREE
# INSTRUMENTS OF FIVE.  The 2026-07-28 stranger audit measured it (`FOSSOR.md` §4,
# F4): only the two reproductions emitted a canonical line.  The selftest, the stub
# fixture and the application were gated on EXIT CODE ALONE, and each exits 0 while
# running almost nothing, because each gates on `(when (plusp *failed*) …)` and A
# CHECK THAT NEVER RAN NEVER FAILS.  The audit truncated the selftest to 35 of its
# 115 checks — and then to ZERO checks with no summary line at all — and this runner
# reported peace in the kingdom, over the instrument carrying 115 of the 147 checks.
#
# NOW: SIX instruments, every one of them gated on ALL FOUR of
#     (1) process exit 0,
#     (2) the exact canonical line present, matched whole-line,
#     (3) the counts SELF-CONSISTENT — the live counter equals the count the
#         instrument DECLARED at its own top, so a file truncated at a clean
#         top-level form boundary cannot satisfy it even with its summary
#         re-appended, and
#     (4) zero failures / zero confirmed defects.
#
# ERRATA 0.3 / D6 — WHAT THE EVIDENCE NOW KNOWS ABOUT ITSELF.
#
# The old subject label was `git rev-parse --short HEAD`.  That answers "what was
# last committed in this repository" and never "what is in these files".  The audit
# produced two BYTE-IDENTICAL transcripts, both labelled `ff80b8f`, for two
# materially different subjects — a one-line behavioural change to `surface1.lisp`
# that touched no declared version integer (`FOSSOR.md` §6, F6).  The evidence was
# wearing a nametag that was not its own.
#
# NOW: a deterministic CONTENT-DERIVED subject digest, computed by
# `errata-0.3/subject-digest.sh` over the exact-path manifest
# `errata-0.3/SUBJECT-MANIFEST.txt` (25 traced load-closure members), each file's
# SHA-256 bound to its path with unambiguous framing.  It needs no git, works on a
# dirty tree and outside a checkout, and HARD-FAILS on a missing member.  Every
# instrument computes it INDEPENDENTLY — none is handed it by this wrapper — and
# this wrapper refuses the run unless every digest-bound instrument reports the same
# value it computed itself.  The human label is retained and marked ADVISORY.
#
# ============================================================================
# KNOWN PACKAGING LIMITATION, DECLARED UP FRONT: this runner WRITES tracked
# transcript files, so it cannot execute fully inside a frozen read-only target.
# Form /1's and Form /2's runners hit exactly this; the workaround is a writable
# scratch copy.  It is a packaging limitation, not a semantic defect, and it is
# said here rather than left for an auditor to discover.
#
# WHICH TRACKED FILES THIS RUN REWRITES — named, not left to be discovered.  These
# seven, and no others:
#     RUN-SELFTEST.txt  RUN-STUB-IMAGE.txt  RUN-APPLICATION.txt
#     RUN-REPRODUCTION.txt  RUN-REPRODUCTION-II.txt  RUN-REPRODUCTION-III.txt
#     RUN-EXITCODES.txt
# Before Errata 0.3, TWO of them changed on every re-run even when nothing about
# the subject had changed: the two reproduction transcripts printed the ABSOLUTE
# path of the tree they were pointed at, so a run from the writable scratch copy
# this very paragraph tells an auditor to make produced different bytes from a run
# in place — and the freeze packet's manifest failed on exactly those two files.
# THE FIX WAS TO STOP PRINTING IT.  An absolute path is a property of the machine,
# not of the subject; WHICH BYTES were measured is now answered by the digest, and
# WHERE they sat is not evidence.
#
# MEASURED, not asserted (`errata-0.3/digest-demo/DEMONSTRATIONS.txt`, section D6):
#   * ALL SEVEN are byte-identical across a RE-RUN IN PLACE of an unchanged subject.
#   * SIX of the seven are byte-identical when the same subject is run from a
#     DIFFERENT ABSOLUTE PATH.
#   * ONE IS NOT: `RUN-REPRODUCTION-III.txt`.  `errata-0.3/REPRODUCTION-III.lisp:78`
#     prints `directory   <truename>` — the same absolute path this errata removed
#     from the other two reproductions, reintroduced in the new instrument.  That
#     file is not this runner's to edit; the defect is NAMED here rather than left
#     for the next auditor, and the cure is the one already applied twice: print a
#     two-component place, or nothing, and let the digest say which bytes.
#   * HONEST LIMIT on the six: the reproductions print a two-component PLACE
#     (`.../mneme/language-surface-1/`).  A copy that renamed those two directories
#     would differ there — a description of the layout, not of the machine.
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE"

# ---------------------------------------------------------------------------
# REQUIRED FILES.  A missing file is a REFUSAL TO RUN, never a skipped check.
# The measuring apparatus (EVIDENCE.lisp, subject-digest.sh, SUBJECT-MANIFEST.txt)
# is required exactly as the instruments are: an evidence run that could not say
# what it measured would be the defect D6 was opened for.
REQUIRED=(package.lisp surface1.lisp surface1-selftest.lisp
          STUB-IMAGE-FIXTURE.lisp de-expansione-testata/APPLICATION.lisp
          errata-0.1/REPRODUCTION.lisp errata-0.2/REPRODUCTION-II.lisp
          errata-0.3/REPRODUCTION-III.lisp
          errata-0.3/EVIDENCE.lisp errata-0.3/subject-digest.sh
          errata-0.3/SUBJECT-MANIFEST.txt)
MISSING=()
for f in "${REQUIRED[@]}"; do [ -f "$f" ] || MISSING+=("$f"); done
if [ ${#MISSING[@]} -gt 0 ]; then
  echo "  !!  run-surface1-candidate: REFUSING TO RUN — ${#MISSING[@]} required file(s) absent"
  printf '      %s\n' "${MISSING[@]}"
  exit 2
fi

SBCL_VERSION="$(sbcl --non-interactive --eval '(progn (princ (lisp-implementation-version)) (terpri))' 2>/dev/null | tail -1)"

# ---------------------------------------------------------------------------
# THE SUBJECT DIGEST — computed here, INDEPENDENTLY of the instruments, so that
# "every instrument agrees" is a comparison of two sources rather than an echo.
SUBJECT_DIGEST="$(bash errata-0.3/subject-digest.sh "$HERE")"
DIGEST_RC=$?
if [ $DIGEST_RC -ne 0 ] || [ ${#SUBJECT_DIGEST} -ne 64 ]; then
  echo "  !!  run-surface1-candidate: REFUSING TO RUN — subject digest unavailable (rc=$DIGEST_RC)"
  echo "      A run that cannot say WHICH BYTES it measured is the defect D6 was opened for."
  exit 2
fi
SUBJECT_SHORT="${SUBJECT_DIGEST:0:16}"

# The human label.  ADVISORY, and now SAID to be advisory: the audit showed exactly
# this kind of label surviving a change of subject unaltered.
#
# IT NO LONGER DEFAULTS TO THE GIT SHA.  That default was the mechanism of D6, and
# it had a second cost nobody had named: it wrote a value into SEVEN TRACKED
# TRANSCRIPTS that changes on every unrelated commit, so a re-run of an UNCHANGED
# subject produced different bytes and the freeze packet's manifest failed.  A label
# that changes when the subject does not is worse than no label: it is noise wearing
# the costume of provenance.  An operator who wants one sets SURFACE1_SUBJECT_LABEL
# deliberately, and it then lands in the transcripts BECAUSE THEY ASKED FOR IT.
SUBJECT_LABEL="${SURFACE1_SUBJECT_LABEL:-(none supplied)}"
export SURFACE1_SUBJECT_LABEL="$SUBJECT_LABEL"

# The repository's HEAD is still worth a human's glance, so it is printed in the
# BANNER — which goes to the terminal and is written to no transcript.  It is a
# provenance HINT about the checkout, not a measurement of the subject, and keeping
# it out of the captured files is what makes those files byte-stable.
PROVENANCE_HINT="$(git -C "$HERE" rev-parse --short HEAD 2>/dev/null || echo "not a git checkout")"

# ---------------------------------------------------------------------------
# THE CANONICAL LINE CONTRACTS.  Each is a WHOLE-LINE extended regular expression.
# The `\1` back-references are the teeth: `expected=` is a literal DECLARED at the
# top of each instrument and `checks=`/`verdicts=` comes from the LIVE counter, so
# requiring them EQUAL rejects any run that did not execute everything it declared.
# No count is hard-coded here — a wrapper that hard-coded 115 would have had to be
# edited every time the suite grew, and the number it enforced would drift into
# fiction.  What is enforced is the instrument keeping its own word.
#
# FOUR of the six also bind the content-derived digest into the line, and those four
# are required to carry THIS run's digest, character for character.
#
# TWO do not, and the gap is named rather than papered over: `surface1-selftest.lisp`
# and `errata-0.3/REPRODUCTION-III.lisp` are owned by other hands at the time of
# writing.  Their lines are matched with an OPTIONAL ` subject=<16 hex>` tail: if
# present it MUST equal this run's digest; if absent the run records
# `subject-binding ABSENT` for that instrument and says so in the banner.  Adding it
# is one format directive; until it is added, those two transcripts are gated on
# completeness but not bound to content.
GATE_SELFTEST="^SELFTEST-RESULT checks=([0-9]+) expected=\1 failed=0( subject=${SUBJECT_SHORT})?$"
GATE_STUB="^STUB-RESULT checks=([0-9]+) expected=\1 failed=0 subject=${SUBJECT_SHORT}$"
GATE_APP="^APPLICATION-RESULT checks=([0-9]+) expected=\1 failed=0 subject=${SUBJECT_SHORT}$"
GATE_REPRO1="^REPRODUCTION-RESULT verdicts=([0-9]+) expected=\1 confirmed=0 subject=${SUBJECT_SHORT}$"
GATE_REPRO2="^REPRODUCTION-RESULT verdicts=([0-9]+) expected=\1 confirmed=0 subject=${SUBJECT_SHORT}$"
# REPRODUCTION-III is a standing regression gate: against THIS tree every verdict
# must come back REFUTED, so verdicts == expected == refuted and confirmed == 0.
GATE_REPRO3="^REPRODUCTION-III-RESULT verdicts=([0-9]+) expected=\1 confirmed=0 refuted=\1 classification=[0-9]+( subject=${SUBJECT_SHORT})?$"

# gate <transcript> <regex> -> 1 if the transcript carries exactly one matching line
gate() {
  local file="$1" re="$2"
  [ -f "$file" ] || { echo 0; return; }
  if [ "$(grep -Ecx -- "$re" "$file" 2>/dev/null)" = "1" ]; then echo 1; else echo 0; fi
}
# subject_binding <transcript> -> the 16-hex the instrument printed, or "ABSENT"
subject_binding() {
  local file="$1"
  [ -f "$file" ] || { echo "ABSENT"; return; }
  local v
  v="$(grep -Eo ' subject=[0-9a-f]{16}$' "$file" 2>/dev/null | tail -1 | sed 's/ subject=//')"
  [ -n "$v" ] && echo "$v" || echo "ABSENT"
}

# ---------------------------------------------------------------------------
# EXECUTION.  Every instrument's raw stdout+stderr is captured unfiltered.
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
( sbcl --non-interactive --load errata-0.1/REPRODUCTION.lisp "$HERE/" \
       "$SUBJECT_LABEL" ) > RUN-REPRODUCTION.txt 2>&1
REPRO1_EXIT=$?
( sbcl --non-interactive --load errata-0.2/REPRODUCTION-II.lisp "$HERE/" \
       "$SUBJECT_LABEL" ) > RUN-REPRODUCTION-II.txt 2>&1
REPRO2_EXIT=$?
( cd errata-0.3 && sbcl --non-interactive --load REPRODUCTION-III.lisp \
       "$SUBJECT_LABEL" ) > RUN-REPRODUCTION-III.txt 2>&1
REPRO3_EXIT=$?

SELFTEST_OK=$(gate RUN-SELFTEST.txt        "$GATE_SELFTEST")
STUB_OK=$(gate     RUN-STUB-IMAGE.txt      "$GATE_STUB")
APP_OK=$(gate      RUN-APPLICATION.txt     "$GATE_APP")
REPRO1_OK=$(gate   RUN-REPRODUCTION.txt    "$GATE_REPRO1")
REPRO2_OK=$(gate   RUN-REPRODUCTION-II.txt "$GATE_REPRO2")
REPRO3_OK=$(gate   RUN-REPRODUCTION-III.txt "$GATE_REPRO3")

SELFTEST_SUBJ=$(subject_binding RUN-SELFTEST.txt)
STUB_SUBJ=$(subject_binding     RUN-STUB-IMAGE.txt)
APP_SUBJ=$(subject_binding      RUN-APPLICATION.txt)
REPRO1_SUBJ=$(subject_binding   RUN-REPRODUCTION.txt)
REPRO2_SUBJ=$(subject_binding   RUN-REPRODUCTION-II.txt)
REPRO3_SUBJ=$(subject_binding   RUN-REPRODUCTION-III.txt)

# Every PRESENT binding must equal the digest this wrapper computed for itself.
SUBJ_AGREE=1
for v in "$SELFTEST_SUBJ" "$STUB_SUBJ" "$APP_SUBJ" "$REPRO1_SUBJ" "$REPRO2_SUBJ" "$REPRO3_SUBJ"; do
  [ "$v" = "ABSENT" ] && continue
  [ "$v" = "$SUBJECT_SHORT" ] || SUBJ_AGREE=0
done

{
  echo "subject-digest         ${SUBJECT_DIGEST}"
  echo "subject-label          ${SUBJECT_LABEL}   (ADVISORY, not a measurement)"
  echo "surface1-selftest      exit ${SELFTEST_EXIT} · canonical line matched ${SELFTEST_OK} (must be 1) · subject ${SELFTEST_SUBJ}"
  echo "stub-image-fixture     exit ${STUB_EXIT} · canonical line matched ${STUB_OK} (must be 1) · subject ${STUB_SUBJ}"
  echo "de-expansione-testata  exit ${APP_EXIT} · canonical line matched ${APP_OK} (must be 1) · subject ${APP_SUBJ}"
  echo "reproduction I         exit ${REPRO1_EXIT} · canonical line matched ${REPRO1_OK} (must be 1) · subject ${REPRO1_SUBJ}"
  echo "reproduction II        exit ${REPRO2_EXIT} · canonical line matched ${REPRO2_OK} (must be 1) · subject ${REPRO2_SUBJ}"
  echo "reproduction III       exit ${REPRO3_EXIT} · canonical line matched ${REPRO3_OK} (must be 1) · subject ${REPRO3_SUBJ}"
  echo "digest agreement       ${SUBJ_AGREE} (must be 1; ABSENT bindings are reported, not counted)"
} > RUN-EXITCODES.txt

cat <<BANNER

  LANGUAGE SURFACE /1 — CANDIDATE /0
  SBCL: ${SBCL_VERSION}

  SUBJECT (content-derived, 25 manifest members, no git involved):
    ${SUBJECT_DIGEST}
  SUBJECT LABEL: ${SUBJECT_LABEL}
    ADVISORY ONLY.  A label is not a measurement — the stranger audit put one
    commit id on two different subjects and got byte-identical transcripts.
  REPOSITORY HEAD (banner only, written to no transcript): ${PROVENANCE_HINT}
    A hint about the CHECKOUT, not about the subject.  Kept out of the captured
    files on purpose: a value that changes on every unrelated commit would make
    an unchanged subject produce changed evidence.

  EXECUTED (raw stdout+stderr captured, unfiltered):
    surface1-selftest.lisp                    exit ${SELFTEST_EXIT} · line ${SELFTEST_OK}  ->  RUN-SELFTEST.txt
    STUB-IMAGE-FIXTURE.lisp                   exit ${STUB_EXIT} · line ${STUB_OK}  ->  RUN-STUB-IMAGE.txt
    de-expansione-testata/APPLICATION.lisp    exit ${APP_EXIT} · line ${APP_OK}  ->  RUN-APPLICATION.txt
    errata-0.1/REPRODUCTION.lisp              exit ${REPRO1_EXIT} · line ${REPRO1_OK}  ->  RUN-REPRODUCTION.txt
    errata-0.2/REPRODUCTION-II.lisp           exit ${REPRO2_EXIT} · line ${REPRO2_OK}  ->  RUN-REPRODUCTION-II.txt
    errata-0.3/REPRODUCTION-III.lisp          exit ${REPRO3_EXIT} · line ${REPRO3_OK}  ->  RUN-REPRODUCTION-III.txt

  SUBJECT BINDING PER INSTRUMENT (each computed the digest itself; this wrapper
  computed its own and compares — agreement is two sources, not an echo):
    selftest ${SELFTEST_SUBJ} · stub ${STUB_SUBJ} · application ${APP_SUBJ}
    repro I ${REPRO1_SUBJ} · repro II ${REPRO2_SUBJ} · repro III ${REPRO3_SUBJ}
    ABSENT means that instrument does not yet print the binding.  It is gated on
    completeness, not bound to content.  Naming the gap is the point of saying it.

  THE BEFORE CAPTURES, where these findings were CONFIRMED, are preserved at
    errata-0.1/pre-errata-evidence/REPRODUCTION-OUTPUT-2e21f367.txt
    errata-0.2/pre-errata-evidence/REPRODUCTION-II-OUTPUT-4f5c5982.txt
    errata-0.3/pre-errata-evidence/
    exit codes and digests retained in       RUN-EXITCODES.txt

  THE STUB-IMAGE FIXTURE IS A SEPARATE PROCESS ON PURPOSE.  One refusal code is
  reachable only where Surface /0's package exists WITHOUT its macros.  Producing
  that state inside the selftest's image would mean unbinding a Surface /0 macro
  function — altering the layer under observation — so it gets its own image,
  which never loads surface0.lisp at all.

  WHAT THESE RUNS ESTABLISH: that the checks written in these files executed IN
  FULL — each instrument's live counter matched the count it declared at its own
  top — and reported what the transcripts show, against the subject whose content
  digest is printed above.  WHAT THEY DO NOT ESTABLISH: that any source form and
  its expansion mean the same thing; that any expansion is correct, evaluable,
  compilable, hygienic, or portable to another Common Lisp; that any lexical
  environment was captured (none ever is); or that any later success reaches
  backward to validate an expansion.  A receipt is an ACCOUNT, not an
  AUTHENTICATION — and so is a digest: it says WHICH BYTES, never that those bytes
  are the right ones.

  Every green is SELF-CONSISTENCY CERTIFICATION by the family that wrote the
  layer.  Standing — candidate, unaudited, unadopted, unfrozen, on no governing
  floor — is recorded in LANGUAGE-SURFACE-1-RETURN.md, not here.

BANNER

if [ "${SELFTEST_EXIT}" -eq 0 ] && [ "${SELFTEST_OK}" -eq 1 ] \
   && [ "${STUB_EXIT}"   -eq 0 ] && [ "${STUB_OK}"   -eq 1 ] \
   && [ "${APP_EXIT}"    -eq 0 ] && [ "${APP_OK}"    -eq 1 ] \
   && [ "${REPRO1_EXIT}" -eq 0 ] && [ "${REPRO1_OK}" -eq 1 ] \
   && [ "${REPRO2_EXIT}" -eq 0 ] && [ "${REPRO2_OK}" -eq 1 ] \
   && [ "${REPRO3_EXIT}" -eq 0 ] && [ "${REPRO3_OK}" -eq 1 ] \
   && [ "${SUBJ_AGREE}"  -eq 1 ]; then
  exit 0
else
  exit 1
fi
