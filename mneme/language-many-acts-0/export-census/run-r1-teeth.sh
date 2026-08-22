#!/usr/bin/env bash
# run-r1-teeth.sh — MA0 EXPORT CENSUS /0 (R1): the whole tooth suite, in order.
#
# CANDIDATE.  Nothing this script produces is independent verification,
# independent validation, a portability claim, or a conformance claim
# (AP0 adoption Rider 2, binding; Many Acts /0 contract §0).
#
# Ordered exactly as Owner Ruling 6A items 5-7 require, and PLANTED-FAULT-FIRST:
#
#   00  EXPECTATION-INJECTION (new in R1) — the ruling's own scenario: a live
#       package with `ma0-selftest' replaced by the bound internal `ma0-refuse',
#       paired with a correspondingly substituted, COUNT-PRESERVING roll.
#       Four legs, including a CONTROL leg that runs the PRE-REPAIR Lisp half
#       from commit 1e8e03d8 to show the cheat genuinely succeeded before the
#       repair.  A tooth that cannot be shown to bite something is not a tooth.
#   01  unexpected export                            -> exit 1
#   02  missing + substituted, cardinality still 38   -> exit 1
#   03  unbound expected export, roll byte-untouched  -> exit 1
#   04  clean, both subject files restored            -> exit 0
#
# Every plant is made IN PLACE in the real subject source and run against the
# UNMODIFIED production invocation — no test-only parameter, no injection hook.
# After every plant the subject files are restored and their blob identities
# are printed into the transcript (Ruling 6A item 7).
#
# Exit codes are captured DIRECTLY from the gate process ($? on the line after
# the call), never through PIPESTATUS after an intervening command — the defect
# that produced a false "OBSERVED EXIT: 0" in the R0 capture attempt.
#
# — Claude Opus (agent CENSOR-II), 2026-08-10, under Owner Ruling 6A

set -uo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
lane="$(cd "$here/.." && pwd)"
root="$(cd "$here/../../../../.." && pwd)"
out="$here/transcripts-r1"
mkdir -p "$out"

PKG="$lane/package.lisp"
STRUCT="$lane/ma0-structures.lisp"
BASE_PKG='a97d3c3e2f6baa21f21c52ae0c4986140eb1fa5c'
BASE_STRUCT='7a2c093e62e260136bbd6c9dde04dd2df29b2848'
SENTINEL='ma0-export-census: exact set equality,'
COORD='231873c7be8ba275cd5756c929efba2f9c807157'
OLD_GATE_COMMIT='1e8e03d899c9b515b41b0c21ac87a9b0bb76c17e'
LANE_REL='experiments/latent-lisp/mneme/language-many-acts-0'

work="$(mktemp -d)"
restore_subject() {
  git -C "$lane" checkout -- package.lisp ma0-structures.lisp 2>/dev/null || true
  rm -f "$here/.r1-control-old-census.lisp"
}
trap 'restore_subject; rm -rf "$work"' EXIT

hashes() {  # -> two lines of blob ids
  printf '  package.lisp       %s\n' "$(git hash-object "$PKG")"
  printf '  ma0-structures.lisp %s\n' "$(git hash-object "$STRUCT")"
}

assert_baseline() {
  local p s
  p="$(git hash-object "$PKG")"; s="$(git hash-object "$STRUCT")"
  if [ "$p" != "$BASE_PKG" ] || [ "$s" != "$BASE_STRUCT" ]; then
    echo "run-r1-teeth.sh: FAIL CLOSED — subject not at baseline before planting." >&2
    hashes >&2
    exit 9
  fi
}

# run_leg <transcript> <label> <cmd...>  — captures $? directly from the process.
run_leg() {
  local t="$1" label="$2"; shift 2
  local body; body="$(mktemp)"
  "$@" > "$body" 2>&1
  local rc=$?
  {
    echo "----------------------------------------------------------------------"
    echo "LEG: $label"
    echo "CMD: $*"
    echo "----------------------------------------------------------------------"
    cat "$body"
    echo
    echo "OBSERVED EXIT: $rc   (captured directly from the process)"
    # The report line must NOT contain the sentinel string itself, or a reader
    # who greps the whole transcript counts this bookkeeping as an emission.
    # Reported here: grep -cF <the normative success sentinel> over THIS LEG'S
    # captured output only.
    if grep -qF "$SENTINEL" "$body"; then
      echo "SENTINEL IN THIS LEG'S OUTPUT: PRESENT ($(grep -cF "$SENTINEL" "$body") matching line(s))"
    else
      echo "SENTINEL IN THIS LEG'S OUTPUT: ABSENT (0 matching lines)"
    fi
    echo
  } >> "$t"
  rm -f "$body"
  echo "$rc"
}

echo "== R1 tooth suite =="
assert_baseline

# =====================================================================
# 00 — EXPECTATION-INJECTION TOOTH (Owner Ruling 6A item 5)
# =====================================================================
T="$out/00-tooth-expectation-injection.txt"
cat > "$T" <<EOF
MA0 EXPORT CENSUS /0 — R1 TOOTH 00: EXPECTATION INJECTION
=========================================================
CANDIDATE.  Not independent verification, not independent validation, not a
portability claim, not a conformance claim.  Branch-local, same-author.

THE ATTACK, in the owner's own words (Owner Ruling 6A):

  "The R1 defect is precise: \`ma0-export-census.sh --table P\` and the Lisp
   half's arbitrary table argument permit expectation substitution.  A live
   package with \`ma0-selftest\` replaced by the bound internal \`ma0-refuse\`
   can be paired with a correspondingly substituted table and obtain the
   success sentinel."

Reproduced exactly.  The plant is COUNT-PRESERVING on both sides: the live
package still exports 38 names and the substituted roll still carries 38 rows.

SENTINEL-DECLARATION — this line is the ONLY occurrence in this file of the
normative success sentinel that is not an actual gate emission.  The string is:
  $SENTINEL
So \`grep -cF\` of that string over this whole transcript must be exactly 2: this
declaration, plus LEG A's emission by the PRE-REPAIR gate.  Legs B, C and D emit
it zero times.  The other four R1 transcripts do not declare it at all, so a
whole-file grep over each of them is a direct count of emissions: 0, 0, 0, and 1.

Baseline blob identities BEFORE the plant:
$(hashes)
EOF

# --- the plant: package.lisp exports ma0-refuse instead of ma0-selftest -----
perl -0pi -e 's/#:ma0-selftest\)\)/#:ma0-refuse))/' "$PKG"
if ! grep -q '#:ma0-refuse))' "$PKG"; then
  echo "run-r1-teeth.sh: FAIL CLOSED — the package plant did not apply." >&2; exit 9
fi

# --- the correspondingly substituted roll, count preserved -----------------
sub="$work/SUBSTITUTED-EXPECTED-EXPORTS.txt"
grep '^#' "$here/EXPECTED-EXPORTS.txt" > "$sub"
{
  grep -v '^#' "$here/EXPECTED-EXPORTS.txt" | grep -v '^ma0-selftest[[:space:]]'
  printf 'ma0-refuse\tfunction\tma0-structures.lisp:71\tdefun\n'
} | grep -v '^$' | LC_ALL=C sort >> "$sub"

{
  echo
  echo "PLANT (in place, real subject source):"
  echo "  package.lisp:  #:ma0-selftest))  ->  #:ma0-refuse))"
  git -C "$lane" --no-pager diff -- package.lisp | sed 's/^/    /'
  echo
  echo "Planted blob identities:"
  hashes
  echo
  echo "SUBSTITUTED ROLL (built to match the planted package):"
  echo "  path            : $sub"
  echo "  blob            : $(git hash-object "$sub")"
  echo "  bound blob      : 78592073905450ff9afcd22dea53afbf53764fa1"
  echo "  data rows       : $(grep -cv '^#' "$sub" | tr -d ' ')   (bound roll: $(grep -cv '^#' "$here/EXPECTED-EXPORTS.txt" | tr -d ' '))"
  echo "  diff vs bound roll (data rows only):"
  diff <(grep -v '^#' "$here/EXPECTED-EXPORTS.txt") <(grep -v '^#' "$sub") | sed 's/^/    /'
  echo
} >> "$T"

# LEG A — CONTROL: the PRE-REPAIR Lisp half, at commit 1e8e03d8.
git -C "$root" show "$OLD_GATE_COMMIT:$LANE_REL/export-census/ma0-export-census.lisp" \
    > "$here/.r1-control-old-census.lisp"
{
  echo "LEG A is a CONTROL, not a test of the repair.  It runs the PRE-REPAIR"
  echo "Lisp half materialized from commit $OLD_GATE_COMMIT"
  echo "(blob $(git hash-object "$here/.r1-control-old-census.lisp")) against the substituted roll,"
  echo "to show the cheat SUCCEEDED before this repair.  A tooth that has never"
  echo "been shown to bite is untested, not passing.  EXPECTED HERE: exit 0 and"
  echo "the sentinel PRESENT -- that is the defect, demonstrated."
  echo
} >> "$T"
rcA="$(run_leg "$T" "A (CONTROL, pre-repair Lisp half + substituted roll) — expect exit 0, sentinel PRESENT" \
        sbcl --script "$here/.r1-control-old-census.lisp" "$sub")"
rm -f "$here/.r1-control-old-census.lisp"

# LEG B — the repaired driver, --table offered.
rcB="$(run_leg "$T" "B (repaired driver, --table offered) — expect exit 2, sentinel ABSENT" \
        "$here/ma0-export-census.sh" --table "$sub")"

# LEG C — DIRECT invocation of the repaired Lisp half with the substituted roll.
rcC="$(run_leg "$T" "C (DIRECT repaired Lisp half + substituted roll) — expect exit 2, sentinel ABSENT" \
        sbcl --script "$here/ma0-export-census.lisp" "$sub")"

# LEG D — the repaired normative driver against the planted package.
rcD="$(run_leg "$T" "D (repaired normative driver, planted package) — expect exit 1, sentinel ABSENT" \
        "$here/ma0-export-census.sh")"

restore_subject
{
  echo "======================================================================"
  echo "RESTORATION (Owner Ruling 6A item 7)"
  echo "======================================================================"
  hashes
  echo "  baseline package.lisp        $BASE_PKG"
  echo "  baseline ma0-structures.lisp $BASE_STRUCT"
  echo "  git status for both paths:"
  git -C "$lane" status --porcelain -- package.lisp ma0-structures.lisp | sed 's/^/    /'
  echo "    (no lines above = both files clean)"
  echo
  echo "======================================================================"
  echo "TOOTH 00 SUMMARY"
  echo "======================================================================"
  echo "  LEG A  control, pre-repair Lisp half : exit $rcA   (the defect, demonstrated)"
  echo "  LEG B  repaired driver --table        : exit $rcB"
  echo "  LEG C  repaired Lisp half, direct     : exit $rcC"
  echo "  LEG D  repaired driver, planted pkg   : exit $rcD"
} >> "$T"
echo "wrote $T  (A=$rcA B=$rcB C=$rcC D=$rcD)"

# =====================================================================
# 01 — unexpected export
# =====================================================================
assert_baseline
T="$out/01-fault-unexpected.txt"
cat > "$T" <<EOF
MA0 EXPORT CENSUS /0 — R1 RE-RUN OF TOOTH 01: UNEXPECTED EXPORT
===============================================================
CANDIDATE.  Same fault as the accepted R0 tooth, re-run against the REPAIRED
instrument (Owner Ruling 6A item 6).  \`ma0-refuse\` is a genuinely fbound
internal (defun at ma0-structures.lisp:71), so a boundness-only gate would pass
it clean; only exact set equality catches it.  Expected: exit 1.

Baseline blob identities BEFORE the plant:
$(hashes)
EOF
perl -0pi -e 's/#:ma0-selftest\)\)/#:ma0-selftest\n   #:ma0-refuse))/' "$PKG"
{ echo; echo "PLANT:"; git -C "$lane" --no-pager diff -- package.lisp | sed 's/^/    /'
  echo; echo "Planted blob identities:"; hashes; echo; } >> "$T"
rc01="$(run_leg "$T" "repaired normative driver — expect exit 1, sentinel ABSENT" \
         "$here/ma0-export-census.sh")"
restore_subject
{ echo "RESTORATION:"; hashes
  echo "  baseline package.lisp        $BASE_PKG"
  echo "  baseline ma0-structures.lisp $BASE_STRUCT"
  echo "OBSERVED GATE EXIT: $rc01"; } >> "$T"
echo "wrote $T  (exit $rc01)"

# =====================================================================
# 02 — missing + substituted, cardinality still 38
# =====================================================================
assert_baseline
T="$out/02-fault-missing-substituted.txt"
cat > "$T" <<EOF
MA0 EXPORT CENSUS /0 — R1 RE-RUN OF TOOTH 02: MISSING + SUBSTITUTED, COUNT 38
=============================================================================
CANDIDATE.  Same fault as the accepted R0 tooth, re-run against the REPAIRED
instrument (Owner Ruling 6A item 6).  The planted source still carries exactly
38 export names; both the removed and the added name are fbound.  The BOUND
roll is used — this is the substitution WITHOUT a substituted expectation, which
is what tooth 00 adds.  Expected: exit 1, both directions named.

Baseline blob identities BEFORE the plant:
$(hashes)
EOF
perl -0pi -e 's/#:ma0-selftest\)\)/#:ma0-refuse))/' "$PKG"
{ echo; echo "PLANT:"; git -C "$lane" --no-pager diff -- package.lisp | sed 's/^/    /'
  echo; echo "Planted blob identities:"; hashes; echo; } >> "$T"
rc02="$(run_leg "$T" "repaired normative driver — expect exit 1, sentinel ABSENT" \
         "$here/ma0-export-census.sh")"
restore_subject
{ echo "RESTORATION:"; hashes
  echo "  baseline package.lisp        $BASE_PKG"
  echo "  baseline ma0-structures.lisp $BASE_STRUCT"
  echo "OBSERVED GATE EXIT: $rc02"; } >> "$T"
echo "wrote $T  (exit $rc02)"

# =====================================================================
# 03 — unbound expected export, export list byte-untouched
# =====================================================================
assert_baseline
T="$out/03-fault-unbound.txt"
cat > "$T" <<EOF
MA0 EXPORT CENSUS /0 — R1 RE-RUN OF TOOTH 03: UNBOUND EXPECTED EXPORT
=====================================================================
CANDIDATE.  Same fault as the accepted R0 tooth, re-run against the REPAIRED
instrument (Owner Ruling 6A item 6).  \`defun ma0-act-summary-verdict\` is
commented out in ma0-structures.lisp; package.lisp is left BYTE-UNTOUCHED at
$BASE_PKG, so set equality still HOLDS on this run and only
the boundness check refuses.  Expected: exit 1.

Baseline blob identities BEFORE the plant:
$(hashes)
EOF
perl -0pi -e 's/^\(defun ma0-act-summary-verdict /;; R1-TOOTH-03 PLANT: (defun ma0-act-summary-verdict /m' "$STRUCT"
{ echo; echo "PLANT:"; git -C "$lane" --no-pager diff -- ma0-structures.lisp | sed 's/^/    /'
  echo; echo "Planted blob identities:"; hashes; echo; } >> "$T"
rc03="$(run_leg "$T" "repaired normative driver — expect exit 1, sentinel ABSENT" \
         "$here/ma0-export-census.sh")"
restore_subject
{ echo "RESTORATION:"; hashes
  echo "  baseline package.lisp        $BASE_PKG"
  echo "  baseline ma0-structures.lisp $BASE_STRUCT"
  echo "OBSERVED GATE EXIT: $rc03"; } >> "$T"
echo "wrote $T  (exit $rc03)"

# =====================================================================
# 04 — clean, after every plant has been reverted
# =====================================================================
assert_baseline
T="$out/04-clean.txt"
cat > "$T" <<EOF
MA0 EXPORT CENSUS /0 — R1 CLEAN RUN
===================================
CANDIDATE.  Run LAST, after every planted fault above was reverted and its blob
identity proven restored.  Nothing here is independent verification, independent
validation, a portability claim, or a conformance claim.

Subject blob identities at the start of this run (both at baseline):
$(hashes)
  baseline package.lisp        $BASE_PKG
  baseline ma0-structures.lisp $BASE_STRUCT
EOF
rc04="$(run_leg "$T" "repaired normative driver, clean subject — expect exit 0, sentinel PRESENT" \
         "$here/ma0-export-census.sh")"
{ echo "Subject blob identities after the clean run:"; hashes
  echo "OBSERVED GATE EXIT: $rc04"; } >> "$T"
echo "wrote $T  (exit $rc04)"

echo
echo "== R1 tooth suite complete =="
echo "  00 injection : A=$rcA (control) B=$rcB C=$rcC D=$rcD"
echo "  01 unexpected: $rc01"
echo "  02 substituted (count 38): $rc02"
echo "  03 unbound   : $rc03"
echo "  04 clean     : $rc04"
hashes
