#!/usr/bin/env bash
#
# ma0-teeth.sh — MANY ACTS /0: THE ADVERSARIAL HALF, one entry.
#
# CANDIDATE.  Running a candidate is not adopting it (contract §0, §8), and
# nothing this script prints is independent verification (AP0 adoption Rider 2).
#
# The lane's builder shipped the suite and DECLARED what it had not built
# (ma0-selftest-suite.lisp's header): the concordance teeth, the planted
# diseases, W-VF-UNCHANGED, W-ONEACT-GREEN, W-FLOOR-UNTOUCHED,
# W-NO-BLIND-REPLAY, and the program-level footprint.  This file runs that half
# and reports a mechanical tally of it.
#
#   0  LANE SUITE        the lane's own 159 checks, so the teeth are never
#                        reported green over a red lane
#   1  NO-INTERNALS      the contract §3 grep, EXTENDED to these files, with a
#                        planted violation shown firing first
#   2  W-NO-BLIND-REPLAY a consumed arm re-invoked by hand; the ADOPTED lane's
#                        identity/seat law witnessed firing
#   3  W-V-FOOTPRINT     an invalid program against a LIVE store
#   4  CONCORDANCE       the re-composition against the adopted composer, four
#                        arms, plus the comparator's own planted-divergence tooth
#   5  DISEASES          the five planted diseases and their controls
#   6  CAMPAIGN GATES    V-F digest, One Act /0 green, the floor untouched, and
#                        the reduced floor
#   7  W-RES-NOT-AUTH    a result object forced into authority position: MA0's
#                        typed refusals where its surface can see it, and
#                        CAPABILITY /1's unrecognized-object law where the
#                        driver goes around MA0 to the recognition seam
#
# ⚠ AN OMITTED SECTION IS REPORTED AS OMITTED AND NEVER COUNTED AS PASSED.
#   MA0_TEETH_SKIP_DISEASES=1   omit section 5 (it costs several minutes)
#   MA0_GATES_SKIP_FLOOR=1      omit the reduced floor inside section 6
#
# Exit 0 iff every ATTEMPTED section was green.
# Sentinel: ma0-teeth: <N> sections attempted, 0 red
#
# — DENS (Claude Opus 5, subagent), 2026-08-09

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"            # experiments/latent-lisp
LANE="mneme/language-many-acts-0"

ATTEMPTED=0
GREEN=0
RED=0
OMITTED=0
declare -a RESULTS=()

section() {  # section NAME COMMAND EXPECTED-SENTINEL-REGEX
  local name="$1" cmd="$2" want="$3"
  ATTEMPTED=$((ATTEMPTED + 1))
  echo
  echo "==========================================================================="
  echo " SECTION: $name"
  echo "==========================================================================="
  local log; log="$(mktemp "${TMPDIR:-/tmp}/ma0-teeth.XXXXXX")"
  ( cd "$ROOT" && bash -c "$cmd" ) 2>&1 | tee "$log"
  local rc=${PIPESTATUS[0]}
  local sentinel; sentinel="$(grep -E "$want" "$log" | tail -1 || true)"
  if [ "$rc" -eq 0 ] && [ -n "$sentinel" ]; then
    GREEN=$((GREEN + 1))
    RESULTS+=("GREEN   $name  ::  $sentinel")
  else
    RED=$((RED + 1))
    RESULTS+=("RED     $name  ::  exit=$rc sentinel=${sentinel:-<absent>}")
  fi
  rm -f "$log"
}

omit() {  # omit NAME WHY
  OMITTED=$((OMITTED + 1))
  RESULTS+=("OMITTED $1  ::  $2")
  echo
  echo "-- SECTION OMITTED: $1 ($2) — not attempted, not passed --"
}

SBCL_VERSION="$(sbcl --noinform --non-interactive \
  --eval '(progn (princ (lisp-implementation-version)) (terpri) (finish-output))' 2>/dev/null | tail -1)"
[ "$SBCL_VERSION" = "2.4.6" ] || { echo "!! FAIL CLOSED: SBCL 2.4.6 only (got $SBCL_VERSION)"; exit 1; }
echo "== ma0-teeth — SBCL $SBCL_VERSION — $(date -u '+%Y-%m-%dT%H:%M:%SZ') =="
echo "   subject tree: $ROOT"

# ---------------------------------------------------------------------------
# 0 — the lane's own suite.
# ---------------------------------------------------------------------------
section "0 LANE SUITE" \
  "sbcl --script $LANE/ma0-selftest.lisp" \
  '^ma0-selftest: [0-9]+ checks, 0 failures$'

# ---------------------------------------------------------------------------
# 1 — NO-INTERNALS, extended to DENS's files, with its tooth.
#
# ⚠ THE NEEDLE IS ASSEMBLED, NEVER SPELLED.  Writing `<package>' followed by two
# colons literally anywhere in this file would put the violation inside a file
# the gate greps, and the gate would fail on its own tooth.
# ---------------------------------------------------------------------------
echo
echo "==========================================================================="
echo " SECTION: 1 NO-INTERNALS (contract §3, extended to the teeth's own files)"
echo "==========================================================================="
ATTEMPTED=$((ATTEMPTED + 1))
NI_FAILED=0
SEP="::"
PACKAGES=(lisp-plus-language-act0 lisp-plus-journal0 lisp-plus-capability0
          lisp-plus-capability1 lisp-plus-capability2 lisp-plus-core0
          lisp-plus-kernel0 lisp-plus-cd0 lisp-plus-surface2 lisp-plus-surface1
          lisp-plus-surface0 lisp-plus-slice1 lisp-plus-system)
DENS_FILES=(ma0-concordance.lisp ma0-concordance-canonical.lisp
            ma0-concordance-ma0.lisp ma0-no-blind-replay.lisp
            ma0-footprint-witness.lisp ma0-res-not-auth.lisp
            ma0-concordance.sh ma0-diseases.sh
            ma0-campaign-gates.sh ma0-teeth.sh)

ni_hits() {  # ni_hits FILE -> prints every "<predecessor>::" package name found
  local file="$1" pkg
  for pkg in "${PACKAGES[@]}"; do
    if grep -qF "${pkg}${SEP}" "$file"; then echo "$pkg"; fi
  done
}

TOOTH_DIR="$(mktemp -d "${TMPDIR:-/tmp}/ma0-ni-tooth.XXXXXX")"
printf '(%s%s%%internal-thing store)\n' "lisp-plus-journal0" "$SEP" > "$TOOTH_DIR/dirty.lisp"
printf '(%s:append-event store datum)\n' "lisp-plus-journal0" > "$TOOTH_DIR/clean.lisp"
if [ "$(ni_hits "$TOOTH_DIR/dirty.lisp")" = "lisp-plus-journal0" ]; then
  echo "  [PASS] TOOTH the no-internals grep FIRES on a planted violation"
else
  echo "  [FAIL] TOOTH the no-internals grep did NOT fire on a planted violation"; NI_FAILED=1
fi
if [ -z "$(ni_hits "$TOOTH_DIR/clean.lisp")" ]; then
  echo "  [PASS] TOOTH it does NOT fire on a lawful single colon"
else
  echo "  [FAIL] TOOTH it fired on a lawful single colon"; NI_FAILED=1
fi
rm -rf "$TOOTH_DIR"

for f in "${DENS_FILES[@]}"; do
  if [ ! -f "$ROOT/$LANE/$f" ]; then
    echo "  [FAIL] NO-INTERNALS $f  the file is ABSENT — a gate over a missing file passes vacuously"
    NI_FAILED=1
    continue
  fi
  hits="$(ni_hits "$ROOT/$LANE/$f")"
  if [ -z "$hits" ]; then
    echo "  [PASS] NO-INTERNALS $f"
  else
    echo "  [FAIL] NO-INTERNALS $f  hits=$(printf '%s ' $hits)"
    NI_FAILED=1
  fi
done
if [ "$NI_FAILED" -eq 0 ]; then
  echo "ma0-teeth-no-internals: ${#DENS_FILES[@]} files, 0 hits"
  GREEN=$((GREEN + 1))
  RESULTS+=("GREEN   1 NO-INTERNALS  ::  ma0-teeth-no-internals: ${#DENS_FILES[@]} files, 0 hits")
else
  RED=$((RED + 1))
  RESULTS+=("RED     1 NO-INTERNALS  ::  at least one file references a predecessor internal")
fi

# ---------------------------------------------------------------------------
section "2 W-NO-BLIND-REPLAY" \
  "sbcl --script $LANE/ma0-no-blind-replay.lisp" \
  '^ma0-no-blind-replay: [0-9]+ checks, 0 failures$'

# ---------------------------------------------------------------------------
section "3 W-V-FOOTPRINT (program level)" \
  "sbcl --script $LANE/ma0-footprint-witness.lisp" \
  '^ma0-footprint-witness: [0-9]+ checks, 0 failures$'

# ---------------------------------------------------------------------------
section "4 CONCORDANCE" \
  "sbcl --script $LANE/ma0-concordance.lisp" \
  '^ma0-concordance: [0-9]+ arms, [0-9]+ facets, 0 divergences$'

# 4b — the comparator's own tooth: a planted divergence must make it REFUSE.
echo
echo "==========================================================================="
echo " SECTION: 4b CONCORDANCE TOOTH (a planted divergence must go RED)"
echo "==========================================================================="
ATTEMPTED=$((ATTEMPTED + 1))
TOOTH_LOG="$(mktemp "${TMPDIR:-/tmp}/ma0-concord-tooth.XXXXXX")"
( cd "$ROOT" && MA0_CONCORD_PLANT_DIVERGENCE="C-ii:correspondence-verdict" \
    sbcl --script "$LANE/ma0-concordance.lisp" ) >"$TOOTH_LOG" 2>&1
TOOTH_RC=$?
TOOTH_HIT="$(grep -F '[FAIL] W-CONCORD C-ii correspondence-verdict' "$TOOTH_LOG" | tail -1 || true)"
if [ "$TOOTH_RC" -ne 0 ] && [ -n "$TOOTH_HIT" ]; then
  echo "  [PASS] the comparator REFUSED the planted divergence (exit $TOOTH_RC):"
  echo "         $TOOTH_HIT"
  echo "ma0-concordance-tooth: 1 planted divergence, 1 detected"
  GREEN=$((GREEN + 1))
  RESULTS+=("GREEN   4b CONCORDANCE TOOTH  ::  ma0-concordance-tooth: 1 planted divergence, 1 detected")
else
  echo "  [FAIL] the comparator did NOT report the planted divergence (exit $TOOTH_RC)"
  tail -5 "$TOOTH_LOG" | sed 's/^/         /'
  RED=$((RED + 1))
  RESULTS+=("RED     4b CONCORDANCE TOOTH  ::  exit=$TOOTH_RC")
fi
rm -f "$TOOTH_LOG"

# ---------------------------------------------------------------------------
if [ "${MA0_TEETH_SKIP_DISEASES:-0}" = "1" ]; then
  omit "5 DISEASES" "MA0_TEETH_SKIP_DISEASES=1"
else
  section "5 DISEASES" \
    "bash $LANE/ma0-diseases.sh" \
    '^ma0-diseases: [0-9]+ diseases detected, [0-9]+ controls clean$'
fi

# ---------------------------------------------------------------------------
section "6 CAMPAIGN GATES" \
  "bash $LANE/ma0-campaign-gates.sh" \
  '^ma0-campaign-gates: [0-9]+ gates, 0 failures'

# ---------------------------------------------------------------------------
section "7 W-RES-NOT-AUTH" \
  "sbcl --script $LANE/ma0-res-not-auth.lisp" \
  '^ma0-res-not-auth: [0-9]+ checks, 0 failures$'

# ---------------------------------------------------------------------------
# R1 (2026-08-10) — THE FOUR REPAIRED DEFECTS, each witnessed by the SAME
# script that produced its pre-repair red transcript in r1/pre-repair/.  Only
# the exit code moved; the reds are kept as evidence and are never regenerated.
#
# ⚠ D3 KEEPS ITS EXTERNAL WATCHDOG even though the validator now terminates on
# its own.  The watchdog is not there to make the section pass — it is there so
# that a regression which reintroduces the non-termination goes RED in sixty
# seconds instead of hanging the whole teeth run forever.
section "8 R1/D1 OWNERSHIP" \
  "sbcl --script $LANE/r1/D1-ownership.lisp" \
  '^ma0-D1-ownership: [0-9]+ owned, 0 defect\(s\) present$'

section "9 R1/D2 BRANCH BINDING" \
  "sbcl --script $LANE/r1/D2-branch-binding.lisp" \
  '^ma0-D2-branch-binding: [0-9]+ closed, 0 defect\(s\) present$'

section "10 R1/D3 CIRCULAR SOURCE (external watchdog)" \
  "timeout 60 sbcl --script $LANE/r1/D3-circular-source.lisp" \
  '^ma0-D3-circular-source: [0-9]+ closed, 0 defect\(s\) present$'

section "11 R1/D4 ENVIRONMENT CROSSWIRE" \
  "sbcl --script $LANE/r1/D4-env-crosswire.lisp" \
  '^ma0-D4-env-crosswire: [0-9]+ closed, 0 defect\(s\) present$'

# ---------------------------------------------------------------------------
# R1 §7 — the seven-arm end-to-end traversal table.  HARVESTED from real runs,
# never declared: an arm counts because an act summary naming it came back.
section "12 R1 SEVEN-ARM COVERAGE" \
  "bash $LANE/r1/ma0-coverage.sh" \
  '^ma0-coverage: 7 arms, 7 traversed, 0 uncovered$'

# ---------------------------------------------------------------------------
# R1/D5 — the owner's pre-freeze gate on the generation seam: construction-
# failure semantics, no exposure, and both entry points refusing a stale
# environment before any act construction, capability activity, journal
# mutation or world mutation.
section "13 R1/D5 GENERATION SEAM" \
  "sbcl --script $LANE/r1/D5-generation-seam.lisp" \
  '^ma0-D5-generation-seam: [0-9]+ closed, 0 defect\(s\) present$'

# ---------------------------------------------------------------------------
echo
echo "==========================================================================="
echo " MANY ACTS /0 — TEETH TALLY"
echo "==========================================================================="
for line in "${RESULTS[@]}"; do echo "  $line"; done
echo
echo "  sections attempted : $ATTEMPTED"
echo "  green              : $GREEN"
echo "  red                : $RED"
echo "  omitted            : $OMITTED"
echo

if [ "$RED" -eq 0 ] && [ "$GREEN" -eq "$ATTEMPTED" ]; then
  if [ "$OMITTED" -gt 0 ]; then
    echo "ma0-teeth: $ATTEMPTED sections attempted, 0 red ($OMITTED OMITTED, not passed)"
  else
    echo "ma0-teeth: $ATTEMPTED sections attempted, 0 red"
  fi
  exit 0
fi
echo "ma0-teeth: REFUSED — $RED red of $ATTEMPTED attempted section(s); $OMITTED omitted."
exit 1
