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
# NOW: SIX instruments, every one of them gated on ALL FIVE of
#     (1) process exit 0,
#     (2) EXACTLY ONE canonical line for that instrument, its field-name set
#         matched exactly and each value's form validated,
#     (3) the counts SELF-CONSISTENT — the live counter equals the count the
#         instrument DECLARED at its own top, so a file truncated at a clean
#         top-level form boundary cannot satisfy it even with its summary
#         re-appended,
#     (4) zero failures / zero confirmed defects, and
#     (5) the measured SUBJECT DIGEST present in the line and equal to the one
#         this runner computed independently.        [EVIDENCE ADDENDUM 0.1]
#
# Conditions (2) and (5) were WEAKER THAN THIS SENTENCE CLAIMED until Evidence
# Addendum 0.1: two instruments were matched with an OPTIONAL digest tail and the
# agreement loop skipped absences.  See the field-parsed contract below, and the
# measured pre-correction witness at
# `errata-0.3/addendum-0.1/pre-correction/FAIL-OPEN-WITNESS.txt`.
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
# this wrapper refuses the run unless EVERY instrument, all six, reports the same
# value it computed itself.  The human label is retained and marked ADVISORY.
# (Errata 0.3 wrote "every digest-bound instrument" here.  That qualifier WAS the
# hole: two instruments were not digest-bound by the gate, and the sentence was
# true only because it excused them.  Evidence Addendum 0.1 removed the excuse.)
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
# THE CANONICAL LINE CONTRACT — FIELD-PARSED, NOT PATTERN-MATCHED.
#                                       [EVIDENCE ADDENDUM 0.1 — A1]
#
# WHAT WAS WRONG WITH THIS SECTION, IN ITS OWN WORDS.  Errata 0.3 wrote here that
# two of the six instruments — `surface1-selftest.lisp` and
# `errata-0.3/REPRODUCTION-III.lisp` — were "owned by other hands at the time of
# writing", so their gates carried an OPTIONAL ` subject=<16 hex>` tail and the
# digest-agreement loop skipped any instrument that bound nothing
# (`[ "$v" = "ABSENT" ] && continue`).  BOTH INSTRUMENTS WERE REPAIRED TO EMIT THE
# TAIL DURING THAT SAME ERRATUM.  The permission outlived its reason: a transcript
# that LOST the tail — by truncation, by splicing, by an instrument regression —
# passed unremarked, and the run still printed `digest agreement 1`.  MEASURED
# against the published runner extracted from its own commit, not asserted:
#     errata-0.3/addendum-0.1/pre-correction/FAIL-OPEN-WITNESS.txt
#
# NOW: ALL SIX instruments must emit exactly one canonical result line CARRYING
# THE MEASURED SUBJECT DIGEST, and each line is validated by PARSING ITS NAMED
# FIELDS rather than by matching a pattern with a back-reference.
#
# WHY THE BACK-REFERENCE WENT.  `expected=\1` was elegant and it was blunt: it
# made a real disagreement ("the counter is 35, the declaration is 139") report
# identically to a syntactic miss ("this does not look like a result line"), so a
# failure could not say what failed.  It also made the gate depend on the local
# grep supporting ERE back-references at all.  The parser below names the field
# that failed and why, and every gate outcome now carries its reason into
# RUN-EXITCODES.txt.
#
# WHAT IS ENFORCED, per instrument — six conditions, all of them:
#   (1) EXACTLY ONE line whose first token is the instrument's label.  Not zero —
#       a crash, an early exit, a truncation.  Not two — a spliced transcript.
#   (2) The field NAME SET is exactly the declared set, checked BOTH ways, so a
#       missing field and an added or renamed field are equally a refusal.
#   (3) Every value has its required FORM: canonical decimal for the counters,
#       exactly 16 lowercase hex digits for `subject`.
#   (4) The LIVE counter equals the count the instrument DECLARED at its own top
#       (`checks`/`verdicts` == `expected`), compared as integers.  No count is
#       hard-coded here; what is enforced is the instrument keeping its own word.
#   (5) The failure counters are zero (`failed`, or `confirmed`), and where the
#       instrument is a standing regression gate, `refuted` equals `verdicts`.
#   (6) `subject` is PRESENT and equals the digest THIS RUNNER computed for
#       itself.  ABSENCE IS NO LONGER LAWFUL FOR ANY INSTRUMENT.
#
# The declared field sets, one per instrument label:
#   SELFTEST-RESULT / STUB-RESULT / APPLICATION-RESULT
#       checks expected failed subject          (checks == expected, failed == 0)
#   REPRODUCTION-RESULT
#       verdicts expected confirmed subject     (verdicts == expected, confirmed == 0)
#   REPRODUCTION-III-RESULT — a standing regression gate: against THIS tree every
#   verdict must come back REFUTED, so verdicts == expected == refuted, confirmed == 0
#       verdicts expected confirmed refuted classification subject

GATE_OK=0
GATE_REASON=""

# validate_result <file> <label> <count-key> <required-fields> <zero-fields> <equals-count-fields>
#
# Sets the globals GATE_OK (1 pass / 0 fail) and GATE_REASON.  CALLED DIRECTLY,
# never inside a command substitution — a subshell would carry the reason to its
# grave, which is the whole failing this rewrite exists to correct.
validate_result() {
  local file="$1" label="$2" countkey="$3"
  local required="$4" zeros="$5" eqcount="$6"
  GATE_OK=0
  GATE_REASON=""

  if [ ! -f "$file" ]; then GATE_REASON="transcript absent"; return; fi

  # (1) exactly one canonical line.
  local n line
  n="$(awk -v L="$label" '$1==L {c++} END {print c+0}' "$file")"
  if [ "$n" -ne 1 ]; then
    GATE_REASON="expected exactly one '${label}' line, found ${n}"
    return
  fi
  line="$(awk -v L="$label" '$1==L {print; exit}' "$file")"

  # Parse the tokens after the label into a name -> value table.
  local -A f=()
  local seen="" tok name value
  for tok in ${line#"$label"}; do
    case "$tok" in
      *=*) name="${tok%%=*}"; value="${tok#*=}" ;;
      *)   GATE_REASON="malformed token '${tok}' (no '=') in the ${label} line"; return ;;
    esac
    if [ -n "${f[$name]+set}" ]; then
      GATE_REASON="field '${name}' appears twice in the ${label} line"; return
    fi
    f[$name]="$value"
    seen="${seen} ${name}"
  done

  # (2) the field-name set, exactly, in both directions.
  local want got
  want="$(printf '%s\n' $required | sort | tr '\n' ' ')"
  got="$(printf '%s\n' $seen | sort | tr '\n' ' ')"
  if [ "$want" != "$got" ]; then
    GATE_REASON="field set mismatch — required [${want% }], found [${got% }]"
    return
  fi

  # (3) the form of every value.
  local k
  for k in $required; do
    if [ "$k" = "subject" ]; then
      if ! [[ "${f[subject]}" =~ ^[0-9a-f]{16}$ ]]; then
        GATE_REASON="subject '${f[subject]}' is not 16 lowercase hex digits"
        return
      fi
    else
      if ! [[ "${f[$k]}" =~ ^(0|[1-9][0-9]*)$ ]]; then
        GATE_REASON="field '${k}' value '${f[$k]}' is not a canonical decimal integer"
        return
      fi
    fi
  done

  # (4) the live counter equals the declared count.
  if [ "${f[$countkey]}" -ne "${f[expected]}" ]; then
    GATE_REASON="${countkey}=${f[$countkey]} != expected=${f[expected]} — the instrument did not execute everything it declared"
    return
  fi

  # (5) failure counters zero; regression gates fully refuted.
  for k in $zeros; do
    if [ "${f[$k]}" -ne 0 ]; then GATE_REASON="${k}=${f[$k]}, must be 0"; return; fi
  done
  for k in $eqcount; do
    if [ "${f[$k]}" -ne "${f[$countkey]}" ]; then
      GATE_REASON="${k}=${f[$k]} != ${countkey}=${f[$countkey]}"
      return
    fi
  done

  # (6) the subject digest, present and equal to the one THIS runner computed.
  if [ "${f[subject]}" != "$SUBJECT_SHORT" ]; then
    GATE_REASON="subject=${f[subject]} != this run's digest ${SUBJECT_SHORT}"
    return
  fi

  GATE_OK=1
  GATE_REASON="ok"
}

# subject_bindings <transcript> -> every DISTINCT 16-hex digest bound ANYWHERE in
# the transcript, comma-joined, or the literal "ABSENT".
#
# Widened past the canonical line ON PURPOSE.  A transcript SPLICED from two runs
# carries its second binding on a line the canonical-line gate never inspects, and
# a comma in this value is the only thing that sees it.  Safe to widen because the
# tail form ` subject=<16 hex>` at end-of-line occurs nowhere else in these
# transcripts: the instrument headers print the FULL 64-hex digest, space-separated
# (`subject-digest  9214b5…`), and match neither the `=` nor the 16-digit length.
subject_bindings() {
  local file="$1"
  [ -f "$file" ] || { echo "ABSENT"; return; }
  local v
  v="$(grep -Eo ' subject=[0-9a-f]{16}$' "$file" 2>/dev/null \
       | sed 's/ subject=//' | sort -u | paste -sd, -)"
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

CHECKS_FIELDS="checks expected failed subject"
VERDICT_FIELDS="verdicts expected confirmed subject"
VERDICT3_FIELDS="verdicts expected confirmed refuted classification subject"

validate_result RUN-SELFTEST.txt       SELFTEST-RESULT        checks   "$CHECKS_FIELDS"   "failed"    ""
SELFTEST_OK=$GATE_OK; SELFTEST_WHY=$GATE_REASON
validate_result RUN-STUB-IMAGE.txt     STUB-RESULT            checks   "$CHECKS_FIELDS"   "failed"    ""
STUB_OK=$GATE_OK;     STUB_WHY=$GATE_REASON
validate_result RUN-APPLICATION.txt    APPLICATION-RESULT     checks   "$CHECKS_FIELDS"   "failed"    ""
APP_OK=$GATE_OK;      APP_WHY=$GATE_REASON
validate_result RUN-REPRODUCTION.txt   REPRODUCTION-RESULT    verdicts "$VERDICT_FIELDS"  "confirmed" ""
REPRO1_OK=$GATE_OK;   REPRO1_WHY=$GATE_REASON
validate_result RUN-REPRODUCTION-II.txt REPRODUCTION-RESULT   verdicts "$VERDICT_FIELDS"  "confirmed" ""
REPRO2_OK=$GATE_OK;   REPRO2_WHY=$GATE_REASON
validate_result RUN-REPRODUCTION-III.txt REPRODUCTION-III-RESULT verdicts "$VERDICT3_FIELDS" "confirmed" "refuted"
REPRO3_OK=$GATE_OK;   REPRO3_WHY=$GATE_REASON

SELFTEST_SUBJ=$(subject_bindings RUN-SELFTEST.txt)
STUB_SUBJ=$(subject_bindings     RUN-STUB-IMAGE.txt)
APP_SUBJ=$(subject_bindings      RUN-APPLICATION.txt)
REPRO1_SUBJ=$(subject_bindings   RUN-REPRODUCTION.txt)
REPRO2_SUBJ=$(subject_bindings   RUN-REPRODUCTION-II.txt)
REPRO3_SUBJ=$(subject_bindings   RUN-REPRODUCTION-III.txt)

# EVERY instrument must bind, and every binding must equal the digest this wrapper
# computed for itself.                          [EVIDENCE ADDENDUM 0.1 — A1]
#
# ABSENCE IS NOW A FAILURE.  It was lawful while two instruments did not yet emit
# the tail; all six emit it, so an ABSENT here means a transcript LOST it, which is
# exactly the condition the old `continue` waved through.  A COMMA in a value means
# one transcript carries two DIFFERENT digests — a splice — and never equals the
# run's digest, so it is caught by the same comparison and reported by value.
SUBJ_AGREE=1
SUBJ_WHY="all six instruments bound the digest and agree with this run's"
for pair in "selftest:$SELFTEST_SUBJ"   "stub:$STUB_SUBJ"       "application:$APP_SUBJ" \
            "repro-I:$REPRO1_SUBJ"      "repro-II:$REPRO2_SUBJ" "repro-III:$REPRO3_SUBJ"; do
  who="${pair%%:*}"; v="${pair#*:}"
  if [ "$v" = "ABSENT" ]; then
    SUBJ_AGREE=0
    SUBJ_WHY="${who} bound NOTHING — absence is not lawful; all six instruments emit the tail"
    break
  elif [ "$v" != "$SUBJECT_SHORT" ]; then
    SUBJ_AGREE=0
    SUBJ_WHY="${who} bound [${v}], this run computed ${SUBJECT_SHORT}"
    break
  fi
done

{
  echo "subject-digest         ${SUBJECT_DIGEST}"
  echo "subject-label          ${SUBJECT_LABEL}   (ADVISORY, not a measurement)"
  echo "surface1-selftest      exit ${SELFTEST_EXIT} · canonical line validated ${SELFTEST_OK} (must be 1) · subject ${SELFTEST_SUBJ} · ${SELFTEST_WHY}"
  echo "stub-image-fixture     exit ${STUB_EXIT} · canonical line validated ${STUB_OK} (must be 1) · subject ${STUB_SUBJ} · ${STUB_WHY}"
  echo "de-expansione-testata  exit ${APP_EXIT} · canonical line validated ${APP_OK} (must be 1) · subject ${APP_SUBJ} · ${APP_WHY}"
  echo "reproduction I         exit ${REPRO1_EXIT} · canonical line validated ${REPRO1_OK} (must be 1) · subject ${REPRO1_SUBJ} · ${REPRO1_WHY}"
  echo "reproduction II        exit ${REPRO2_EXIT} · canonical line validated ${REPRO2_OK} (must be 1) · subject ${REPRO2_SUBJ} · ${REPRO2_WHY}"
  echo "reproduction III       exit ${REPRO3_EXIT} · canonical line validated ${REPRO3_OK} (must be 1) · subject ${REPRO3_SUBJ} · ${REPRO3_WHY}"
  echo "digest agreement       ${SUBJ_AGREE} (must be 1; ABSENT is a FAILURE — Evidence Addendum 0.1) · ${SUBJ_WHY}"
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
    ALL SIX ARE REQUIRED TO BIND.  ABSENT is a FAILURE, not a reported gap
    (Evidence Addendum 0.1): every instrument emits the tail, so an absence means
    a transcript lost it.  A comma-joined value means one transcript carries two
    different digests — a splice — and fails by the same comparison.
    ${SUBJ_WHY}

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
