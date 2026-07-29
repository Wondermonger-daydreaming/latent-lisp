#!/usr/bin/env bash
#
# fail-open-witness.sh — PRE-CORRECTION WITNESS for Evidence Addendum 0.1.
#
# WHAT THIS PROVES, AND WHAT IT DOES NOT.
#
# It proves that the runner AS PUBLISHED IN ERRATA 0.3 accepts a canonical
# result line from which the subject digest is ABSENT, for two of its six
# instruments, and that its digest-agreement loop reports agreement=1 in that
# same condition.  It does NOT prove any expansion receipt was false; no route
# of that kind was found by the audit or by this addendum.  The defect is in the
# EVIDENCE HARNESS's account of its own binding, not in the layer.
#
# THE GATE EXPRESSIONS ARE NOT RETYPED HERE.  They are extracted verbatim from
# the published Errata 0.3 commit with `git show`, so this witness measures the
# published artefact rather than a paraphrase of it.  If the extraction fails,
# the witness REFUSES rather than falling back to a hand-written copy.
set -uo pipefail

TARGET_COMMIT="${1:-431fee16}"
RUNNER_PATH="experiments/latent-lisp/mneme/language-surface-1/run-surface1-candidate.sh"
REPO="$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)"

echo "PRE-CORRECTION WITNESS — the optional-subject-binding hole"
echo "subject under witness : ${TARGET_COMMIT}:${RUNNER_PATH}"
echo

PUBLISHED="$(git -C "$REPO" show "${TARGET_COMMIT}:${RUNNER_PATH}" 2>/dev/null)"
if [ -z "$PUBLISHED" ]; then
  echo "REFUSING: could not extract the published runner from ${TARGET_COMMIT}."
  exit 2
fi
echo "published runner sha256: $(printf '%s\n' "$PUBLISHED" | sha256sum | cut -d' ' -f1)"
echo

# A digest value that is DELIBERATELY NOT the real one: the point is that the
# gate never looks, so what it would have compared against does not matter.
SUBJECT_SHORT="0000000000000000"

# Extract the two optional-tailed gates and the binding reader, verbatim.
GATE_SELFTEST_SRC="$(printf '%s\n' "$PUBLISHED" | grep -E '^GATE_SELFTEST=')"
GATE_REPRO3_SRC="$(printf '%s\n'  "$PUBLISHED" | grep -E '^GATE_REPRO3=')"
BINDING_SRC="$(printf '%s\n'      "$PUBLISHED" | sed -n '/^subject_binding()/,/^}/p')"
GATE_SRC="$(printf '%s\n'         "$PUBLISHED" | sed -n '/^gate()/,/^}/p')"
LOOP_SRC="$(printf '%s\n'         "$PUBLISHED" | sed -n '/^SUBJ_AGREE=1$/,/^done$/p')"

for pair in "GATE_SELFTEST_SRC:$GATE_SELFTEST_SRC" "GATE_REPRO3_SRC:$GATE_REPRO3_SRC" \
            "BINDING_SRC:$BINDING_SRC" "GATE_SRC:$GATE_SRC" "LOOP_SRC:$LOOP_SRC"; do
  name="${pair%%:*}"; val="${pair#*:}"
  [ -n "$val" ] || { echo "REFUSING: could not extract ${name} from the published runner."; exit 2; }
done

echo "EXTRACTED VERBATIM FROM THE PUBLISHED RUNNER:"
printf '  %s\n' "$GATE_SELFTEST_SRC"
printf '  %s\n' "$GATE_REPRO3_SRC"
echo "  subject_binding() { ... }   (returns the literal string ABSENT when no ' subject=' tail is found)"
echo "  the digest-agreement loop, whose body begins:"
printf '%s\n' "$LOOP_SRC" | sed -n '2,3p' | sed 's/^/    /'
echo

eval "$GATE_SELFTEST_SRC"
eval "$GATE_REPRO3_SRC"
eval "$BINDING_SRC"
eval "$GATE_SRC"

SCRATCH="$(mktemp -d)"
trap 'rm -rf "$SCRATCH"' EXIT

# The two lines named in the work order, verbatim, with NO subject tail.
printf 'SELFTEST-RESULT checks=139 expected=139 failed=0\n' > "$SCRATCH/NOSUBJ-SELFTEST.txt"
printf 'REPRODUCTION-III-RESULT verdicts=12 expected=12 confirmed=0 refuted=12 classification=4\n' \
  > "$SCRATCH/NOSUBJ-REPRO3.txt"

S_OK="$(gate "$SCRATCH/NOSUBJ-SELFTEST.txt" "$GATE_SELFTEST")"
R_OK="$(gate "$SCRATCH/NOSUBJ-REPRO3.txt"   "$GATE_REPRO3")"
S_SUBJ="$(subject_binding "$SCRATCH/NOSUBJ-SELFTEST.txt")"
R_SUBJ="$(subject_binding "$SCRATCH/NOSUBJ-REPRO3.txt")"

echo "MEASURED, against transcripts carrying NO subject digest:"
echo "  line: SELFTEST-RESULT checks=139 expected=139 failed=0"
echo "        gate matched = ${S_OK}   (1 means the gate ACCEPTED it)"
echo "        subject_binding = ${S_SUBJ}"
echo "  line: REPRODUCTION-III-RESULT verdicts=12 expected=12 confirmed=0 refuted=12 classification=4"
echo "        gate matched = ${R_OK}   (1 means the gate ACCEPTED it)"
echo "        subject_binding = ${R_SUBJ}"
echo

# The digest-agreement loop, run verbatim over the two ABSENT bindings plus four
# bindings that DO agree — the exact shape of a real run of the published runner
# against instruments that had not yet been repaired to emit the tail.
set -- "$S_SUBJ" "$R_SUBJ" "$SUBJECT_SHORT" "$SUBJECT_SHORT" "$SUBJECT_SHORT" "$SUBJECT_SHORT"
SUBJ_AGREE=1
for v in "$@"; do
  [ "$v" = "ABSENT" ] && continue
  [ "$v" = "$SUBJECT_SHORT" ] || SUBJ_AGREE=0
done
echo "  digest-agreement loop over (ABSENT ABSENT ok ok ok ok) -> SUBJ_AGREE=${SUBJ_AGREE}"
echo "        (1 means the run REPORTED AGREEMENT while two instruments bound nothing)"
echo

if [ "$S_OK" = "1" ] && [ "$R_OK" = "1" ] && [ "$S_SUBJ" = "ABSENT" ] \
   && [ "$R_SUBJ" = "ABSENT" ] && [ "$SUBJ_AGREE" = "1" ]; then
  echo "WITNESS ESTABLISHED — the published gate is FAIL-OPEN on subject binding"
  echo "for surface1-selftest.lisp and errata-0.3/REPRODUCTION-III.lisp."
  echo
  echo "HONEST LIMIT, stated so it is not read larger than it is: both instruments"
  echo "DO in fact emit the tail in the published transcripts.  What was open is the"
  echo "GATE, not the emission — a transcript that lost the tail, by truncation,"
  echo "substitution or an instrument regression, would have passed unremarked."
  exit 0
else
  echo "WITNESS NOT ESTABLISHED — the published gate did not behave as described."
  echo "Do not proceed with the addendum on the strength of this file."
  exit 1
fi
