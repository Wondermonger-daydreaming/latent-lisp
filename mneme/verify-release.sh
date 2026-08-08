#!/usr/bin/env bash
#
# verify-release.sh — the canonical aggregate release floor for Lisp+.
#
#   bash mneme/verify-release.sh                  # full floor (long: ~90 min)
#   bash mneme/verify-release.sh --profile ci     # reduced CI profile
#   bash mneme/verify-release.sh --list           # print the gate table, run nothing
#
# ---------------------------------------------------------------------------
# WHAT A ZERO EXIT MEANS — AND WHAT IT DOES NOT
# ---------------------------------------------------------------------------
#
# Exit 0 means exactly three things, jointly:
#
#   (1) every gate this floor could execute passed, at its authorized count;
#   (2) every KNOWN-UNRESOLVED finding is unchanged and reported below by name;
#   (3) every ARCHIVED-NOT-RERUN item passed its integrity check.
#
# Exit 0 does NOT mean that all semantic questions are resolved.  It does not
# adopt any implementation, does not raise any lane's standing, and is not
# conformance, verification, or validation of any kind.  This floor runs one
# model family's code against the same family's checks: SELF-CONSISTENCY
# CERTIFICATION, NEVER INDEPENDENT CONFORMANCE.  The stranger primitive-
# minimization audit is OWED and has never been commissioned.
#
# The current claim ceiling is mneme/integration-baseline-0/CLAIM-CEILING-0.md.
# Read it before quoting any number this floor prints.
#
# ---------------------------------------------------------------------------
# STATUS VOCABULARY (fixed; nothing else may be printed in the status column)
# ---------------------------------------------------------------------------
#
#   PASS                   the gate executed from current sources and met its
#                          authorized count and verdict
#   KNOWN-UNRESOLVED       a named, preserved failure carried forward unchanged;
#                          it is NOT green and is NOT repaired here
#   ARCHIVED-NOT-RERUN     committed evidence integrity-checked, NOT reproduced.
#                          Verifying an archive is not reproducing a campaign.
#   BLOCKED-EXTERNAL-INPUT the gate cannot run on this host because a required
#                          input is external to the repository and absent
#   FAIL                   anything else, including a count or verdict that
#                          moved away from its authorized value
#
# The DECLARED table below (carried status rows, never executed here) uses one
# further status of its own:
#
#   CANDIDATE-NOT-ADOPTED  an executable exists and runs green, and it is a
#                          CANDIDATE: running it raises no lane's standing.
#                          Distinct from ABSENT (nothing is built) and from
#                          PASS (which would read as settled).
#   ADOPTED                the owner adopted the exact verified candidate by
#                          ruling; the row cites the adoption record, which
#                          discloses any owner variance (e.g. a waived gate).
#
# A gate whose observed count differs from its authorized count FAILS CLOSED,
# even upward.  This floor detects drift; it does not absorb it.
#
# ---------------------------------------------------------------------------
# HYGIENE
# ---------------------------------------------------------------------------
#
# Every transcript-writing and scratch-producing gate runs inside a disposable
# copy of the tree under $TMPDIR, never in your checkout.  The copy is removed
# on success AND on failure.  The floor snapshots your checkout's git state
# before and after and FAILS CLOSED if a single byte moved.
#
# Supported environment: SBCL 2.4.6 on Linux.  Nothing else has ever been
# tested and no portability is claimed.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"

PROFILE="full"
LIST_ONLY=0
while [ $# -gt 0 ]; do
  case "$1" in
    --profile) PROFILE="${2:-full}"; shift 2 ;;
    --list)    LIST_ONLY=1; shift ;;
    -h|--help) sed -n '2,60p' "${BASH_SOURCE[0]}"; exit 0 ;;
    *) echo "!! unknown argument: $1" >&2; exit 2 ;;
  esac
done
case "$PROFILE" in full|ci) ;; *) echo "!! --profile must be full or ci" >&2; exit 2 ;; esac

# ===========================================================================
# THE GATE TABLE
#
# Fields, '|'-separated:
#   PROFILE  both = runs in every profile; full = full profile only
#   LANE     the principal lane this gate accounts for
#   CWD      subject-tree-relative working directory the gate declares
#   CMD      the exact command, run through `bash -c`
#   EXPECT   a fixed string that MUST appear in stdout+stderr (the authorized
#            count/verdict).  '-' means: exit code alone is the verdict.
#   WRITES   yes = transcript-writing or scratch-producing; runs in the
#            disposable copy.  no = read-only; runs in place.
#
# Every count below is the authorized count carried from the lane's own
# committed RUN-EXITCODES.txt / RETURN gate table.  Changing one here without
# a ruling is a defect, not a fix.
#
# ONE ACT /0 (lane `act0`, three rows, registered by owner ruling R2.3 item 3)
# IS AN UNADOPTED CANDIDATE.  Its rows are here because the floor should be
# able to RUN it, not because its standing has moved: adoption, merge and
# publication are not authorized for that lane, and a green row is not a
# ruling.  It acquires no umbrella row this round — the standalone
# `lisp-plus/act0` door stays canonical.  (This file has no per-row adoption
# marker and none is invented here: several other lanes in this table are
# candidates too, and marking only one would silently imply the rest are
# adopted.  The carried status row `seam` below states it in words instead.)
# ===========================================================================

read -r -d '' GATES <<'TABLE' || true
both|aggregate|mneme|bash verify-all.sh|ALL FLOORS HOLD|yes
both|aggregate|.|bash mneme/verify-language-floor.sh|LANGUAGE FLOOR GREEN — 11 floors, 654 checks, 0 failed|yes
both|aggregate|.|bash mneme/verify-form-floor.sh|FORM FLOOR GREEN — 3 floors, 199 checks, 0 failed|yes
both|kernel0|.|sbcl --script mneme/kernel0/kernel0-selftest.lisp|33 passed|no
both|kernel0|.|sbcl --script mneme/kernel0/load.lisp|records+folds smoke: PASS|no
both|journal0|.|sbcl --script mneme/journal0/journal0-selftest.lisp|journal0-selftest: 66 checks, 0 failures|no
both|journal0|.|sbcl --script mneme/journal0/journal0-vectors.lisp|journal0-vectors: 89 checks, 0 failures|no
full|journal0|.|sbcl --script mneme/journal0/de-teste-occiso/run-specimen.lisp|RESULT: PASS|yes
both|capability0|.|sbcl --script mneme/capability0/capability0-selftest.lisp|capability0-selftest: 28 checks, 0 failures|no
both|capability0|.|sbcl --script mneme/capability0/capability0-controls.lisp|capability0-controls: 36 checks, 0 failures|no
both|capability0|.|sbcl --script mneme/capability0/de-potestate-revocata/run-specimen.lisp|de-potestate-revocata: 24 checks, 0 failures|yes
both|capability1|.|sbcl --script mneme/capability1/capability1-selftest.lisp|capability1-selftest: 30 checks, 0 failures|no
both|capability1|.|sbcl --script mneme/capability1/capability1-controls.lisp|capability1-controls: 27 checks, 0 failures|no
both|capability1|.|sbcl --script mneme/capability1/de-clave-mortua/run-specimen.lisp|de-clave-mortua: 29 checks, 0 failures|yes
both|capability2|.|sbcl --script mneme/capability2/capability2-selftest.lisp|capability2-selftest: 29 checks, 0 failures|no
both|capability2|.|sbcl --script mneme/capability2/capability2-controls.lisp|capability2-controls: 27 checks, 0 failures|no
both|capability2|.|sbcl --script mneme/capability2/de-effectu-incerto/run-specimen.lisp|de-effectu-incerto: 29 checks, 0 failures|yes
both|adapter0|.|sbcl --script mneme/adapter0/adapter0-selftest.lisp|adapter0-selftest: 39 checks, 0 failures|no
both|adapter0|.|sbcl --script mneme/adapter0/adapter0-vectors.lisp|adapter0-vectors: 107 checks, 0 failures|no
both|adapter0|.|sbcl --script mneme/adapter0/adapter0-scripts.lisp|adapter0-scripts: 21 checks, 0 failures|no
both|adapter0|.|sbcl --script mneme/adapter0/adapter0-joint.lisp|adapter0-joint: 24 checks, 0 failures|no
both|adapter0|.|sbcl --script mneme/adapter0/adapter0-l17.lisp|adapter0-l17: 4 checks, 0 failures|yes
both|adapter0|.|sbcl --script mneme/adapter0/adapter0-controls.lisp|adapter0-controls: 24 checks, 0 failures|no
both|adapter0|.|sbcl --script mneme/adapter0/adapter0-erratum-cost.lisp|adapter0-erratum-cost: 18 checks, 0 failures|no
both|adapter0|.|sbcl --script mneme/adapter0/de-membrana-loquente/run-specimen.lisp|de-membrana-loquente: 12 checks, 0 failures|yes
both|core0|.|sbcl --script mneme/language-core-0/core0-selftest.lisp|29 passed / 0 failed|no
both|core0|.|sbcl --script mneme/language-core-0/core0-issuance-selftest.lisp|73 passed / 0 failed|no
both|core0|.|sbcl --script mneme/language-core-0/de-abaco/SPECIMEN.lisp|de-abaco: 9 checks passed / 0 failed|no
both|core0|.|sbcl --script mneme/language-core-0/de-cursore-aereo/SPECIMEN.lisp|de-cursore-aereo: 23 checks passed / 0 failed|no
both|core0|.|sbcl --script mneme/language-core-0/de-ponte-usto/SPECIMEN.lisp|de-ponte-usto: 17 checks passed / 0 failed|no
both|core0|.|sbcl --script mneme/language-core-0/de-bibliotheca-peregrina/APPLICATION.lisp|de-bibliotheca-peregrina: 123 checks passed / 0 failed|no
both|core0|.|sbcl --script mneme/language-core-0/de-codice-restaurando/APPLICATION.lisp|de-codice-restaurando: 101 checks passed / 0 failed|no
both|slice0|.|sbcl --script mneme/language-slice-0/SMOKE.lisp|6 ok, 0 failed|no
both|slice0|.|sbcl --script mneme/language-slice-0/de-infando/SPECIMEN.lisp|30 passed, 0 failed|no
both|slice0|.|bash mneme/language-slice-0/stranger-implementation-0/check-front-door-selftest.sh|SELFTEST: 7/7 passed|no
both|slice0|.|bash mneme/language-slice-0/stranger-implementation-1/check-front-door-selftest.sh|SELFTEST: 7/7 passed|no
both|slice1|.|sbcl --script mneme/language-slice-1/slice1-selftest.lisp|slice1 selftest: 123 passed, 0 failed|no
both|slice1|.|sbcl --script mneme/language-slice-1/SMOKE-1.lisp|slice1 public smoke: 9/9, 0 failed|no
both|slice1|.|sbcl --script mneme/language-slice-1/GUIDE-WALK-1.lisp|walk-the-recipe: 0 of 20 check(s) FAILED|no
both|slice2|.|sbcl --script mneme/language-slice-2/slice2-selftest.lisp|108 passed / 0 failed|no
both|slice2|.|sbcl --script mneme/language-slice-2/SMOKE-2.lisp|slice2 public smoke: 10/10, 0 failed|no
both|slice2|.|sbcl --script mneme/language-slice-2/de-pignore/APPLICATION.lisp|de-pignore: 52 checks produced / 0 failed|no
both|form0|.|sbcl --script mneme/language-form-0/form0-selftest.lisp|152 passed / 0 failed|no
both|form0|.|sbcl --script mneme/language-form-0/PUBLIC-SURFACE-AUDIT.lisp|23 passed / 0 failed|no
both|form0|.|sbcl --script mneme/language-form-0/de-forma-dormiente/APPLICATION.lisp|de-forma-dormiente: 24 checks passed / 0 failed|no
full|form0|.|bash mneme/language-form-0/MUTATION-LEDGER.sh|killed=10  survived=0|yes
both|form1|.|sbcl --script mneme/language-form-1/form1-selftest.lisp|form1-selftest: 210 checks passed / 0 failed|no
both|form1|.|sbcl --script mneme/language-form-1/EXPORT-CENSUS.lisp|-|no
full|form1|.|bash mneme/language-form-1/run-form1-candidate.sh|-|yes
full|form1|.|bash mneme/language-form-1/check-form1-transcript.sh|RECONCILIATION CLEAN|yes
full|form1|mneme/language-form-1|bash VERDICT-LIVENESS-SWEEP.sh|-|yes
both|form1|.|sbcl --script mneme/language-form-1/de-forma-petente/APPLICATION.lisp|de-forma-petente: 68 checks passed / 0 failed|no
both|form2|.|sbcl --script mneme/language-form-2/form2-selftest.lisp|form2-selftest: 86 checks passed / 0 failed|no
both|form2|.|sbcl --script mneme/language-form-2/SOURCE-HYGIENE-GATE.lisp|Form /2 source hygiene: 23 passed / 0 failed|no
full|form2|.|bash mneme/language-form-2/run-form2-candidate.sh|-|yes
full|form2|.|bash mneme/language-form-2/check-form2-transcript.sh|RECONCILIATION CLEAN|yes
full|form2|mneme/language-form-2|bash VERDICT-LIVENESS-SWEEP.sh|-|yes
both|form2|.|sbcl --script mneme/language-form-2/de-forma-mutata/APPLICATION.lisp|de-forma-mutata: 43 checks passed / 0 failed|no
both|form2|.|sbcl --script mneme/language-form-2/de-vadimonio/APPLICATION.lisp|de-vadimonio: 117 checks produced / 0 failed|no
full|form2|.|bash mneme/language-form-2/de-vadimonio/check-transcript.sh|-|yes
both|surface0|.|sbcl --script mneme/language-surface-0/surface0-selftest.lisp|38 passed / 0 failed|no
full|surface0|.|bash mneme/language-surface-0/PLANTED-FAULTS.sh|both faults fired; both restorations hash-verified|yes
both|surface1|.|sbcl --script mneme/language-surface-1/surface1-selftest.lisp|SELFTEST-RESULT checks=139 expected=139 failed=0|no
both|surface1|.|sbcl --script mneme/language-surface-1/STUB-IMAGE-FIXTURE.lisp|STUB-RESULT checks=8 expected=8 failed=0|no
both|surface1|.|sbcl --script mneme/language-surface-1/de-expansione-testata/APPLICATION.lisp|APPLICATION-RESULT checks=26 expected=26 failed=0|no
full|surface1|.|bash mneme/language-surface-1/run-surface1-candidate.sh|-|yes
both|surface1|mneme/language-surface-1/errata-0.3|bash subject-digest.sh|9214b59bda190327dc879186bd6d567eae8d2e7d0d162f869148fad1ad6aaf99|no
both|surface1|mneme/language-surface-1/errata-0.3/addendum-0.1|bash helper-search.sh|-|no
both|surface1|mneme/language-surface-1/errata-0.3/addendum-0.1/negative-controls|bash run-helper-control.sh|UNCHANGED|yes
both|surface1|mneme/language-surface-1/errata-0.3/addendum-0.1/negative-controls|bash subject-binding-controls.sh|passed 16 · failed 0|yes
both|surface1|mneme/language-surface-1/errata-0.3/addendum-0.1/pre-correction|bash fail-open-witness.sh|-|no
both|surface1|mneme/language-surface-1/errata-0.3/addendum-0.1|bash semantic-path-diff.sh|-|no
full|surface1|.|bash mneme/language-surface-1/errata-0.3/teeth/teeth.sh|every planted fault was refused|yes
both|surface2|.|sbcl --script mneme/language-surface-2/surface2-selftest.lisp|surface2-selftest: 29 checks, 0 failures|no
both|surface2|.|sbcl --script mneme/language-surface-2/surface2-controls.lisp|surface2-controls: 38 checks, 0 failures|no
both|surface2|.|sbcl --script mneme/language-surface-2/surface2-inhabited.lisp|surface2-inhabited: 18 checks, 0 failures|no
both|surface2|.|sbcl --script mneme/language-surface-2/surface2-erratum-binder.lisp|surface2-erratum-binder: 15 checks, 0 failures|no
both|surface-account|.|sbcl --script mneme/language-surface-account-0/production/surface-account-selftest.lisp|surface-account-selftest: 38 checks, 0 failures|no
both|surface-account|.|sbcl --script mneme/language-surface-account-0/production/surface-account-inhabited.lisp|surface-account-inhabited: 12 checks, 0 failures|no
both|surface-account|.|bash mneme/language-surface-account-0/production/surface-account-graph-gate.sh|surface-account-graph-gate: 9 checks passed, 0 failed|no
full|surface-account|.|bash mneme/language-surface-account-0/production/run-hostile-profiles.sh|surface-account-hostile-profiles: 7 roles + 4 loader cases, 110 checks, 0 failures|no
full|surface-account|.|bash mneme/language-surface-account-0/production/surface-account-disease.sh|surface-account-disease: 8 diseases detected, 8 controls clean|yes
both|act0|.|sbcl --script mneme/language-act-0/act0-selftest.lisp|oneact0-selftest: 173 checks, 0 failures|no
full|act0|.|bash mneme/language-act-0/act0-load-witnesses.sh|act0-load-witnesses: 6/6 cases green, tooth caught|no
full|act0|.|bash mneme/language-act-0/act0-loader-disease.sh|act0-loader-disease: 3 diseases detected, 3 controls clean|no
full|vertical0|.|bash mneme/vertical0/harness/repeatability.sh|-|yes
full|vertical0|.|sbcl --script mneme/vertical0/controls/run-integration-controls.lisp|vertical0 integration controls: 37 checks, 0 failures|yes
full|vertical0|.|sbcl --script mneme/vertical0/mutants/run-mutation-gate.lisp|vertical0 mutation gate: 71 checks, 0 failures|yes
both|vertical0|.|sbcl --script mneme/vertical0/reconstruction/run-reconstruction-gate.lisp|run-reconstruction-gate: 31 checks, 0 failures|yes
both|cd0|.|sbcl --script canonical-datum/common-lisp/run-tests.lisp|total assertions: 2633|no
both|cd0|.|python3 canonical-datum/tools/verify_phase0.py|0 failures|no
both|cd0|.|python3 canonical-datum/integration/run_differential.py --json|"status": "PASS"|no
both|lci0|.|python3 mneme/lci0/shared/fixture_package.py verify|-|no
both|lci0|.|sbcl --script mneme/architecture/pj0-errata/erratum-1-d2-examples.lisp|RESULT: 13 checks, 0 failures|no
both|release|.|bash mneme/load-lisp-plus.sh|load transcript is clean: 0 warnings, 0 redefinitions, 0 undefined variables|no
full|release|.|bash mneme/load-order-matrix.sh|LOAD-ORDER MATRIX: PASS|no
both|atelier|.|python3 mneme/atelier/static-check.py|Static relay check passed for 22 Lisp files.|no
TABLE

# ===========================================================================
# DECLARED, NOT EXECUTED — carried honestly, never turned green
# ===========================================================================
#
# Each entry is: LANE|STATUS|HEADLINE|WHY
read -r -d '' DECLARED <<'TABLE' || true
lci0|KNOWN-UNRESOLVED|LCI/0 algebraic-law audit: 84 laws PASS, 4 laws preserved FAIL|LCI0-CROSS-004, LCI0-SCOPE-015, LCI0-TEMP-022, LCI0-TEMP-028 remain preserved failures with six minimized witnesses; the lane's own evidence reads "AUDIT COMPLETE — MINIMIZED LAW VIOLATIONS PRESERVED; AUTHORIAL RULING REQUIRED". No authorial disposition exists. This milestone does not repair, adjudicate, or rebuild them.
lci0|BLOCKED-EXTERNAL-INPUT|LCI/0 law-audit harness cannot execute on this host|audit/README.md requires an external checksum-bound packet ZIP passed by path (LCI0-ALGEBRAIC-LAW-AUDIT-PACKET-ERRATA-0.1.zip). It is absent from this host and is not in the tree, so law_audit.py and 5 of its 12 harness self-tests cannot run here at all. The committed evidence is archived, not re-derivable.
lci0|ARCHIVED-NOT-RERUN|LCI/0 cross-implementation differential: 2,295 requests/impl, 0 mismatches|Requires a materialized fixture overlay and three environment variables; not re-derived by this floor. The lane's own evidence records "cross_language_agreement_is_independent_corroboration": false — cross-language agreement here is NOT independent corroboration, because both implementations were seeded under shared normative infrastructure.
vertical0|ARCHIVED-NOT-RERUN|Vertical /0 five-life SIGKILL campaign|A strace-controlled process-death generation campaign writing new runs/campaign-* trees. Not re-run. The repeatability gate above byte-compares the two preserved campaigns and re-derives the census from campaign-2; that is verification of an archive, NOT reproduction of the campaign.
language-a|ARCHIVED-NOT-RERUN|Language-A tranche-B (706 files, emission BANKED 295/312)|Exists only on unmerged mirror branches; deliberately not merged during this milestone per the owner ruling (archive now, adopt later). Scoring is owner-locked pending the null-semantics ruling. The lab tree holds three language-a files, exercised inside verify-all.sh.
latent-mvp|PASS|latent-mvp historical floor (6/6 suites)|FOSSIL-MARKED. Retained intact as a historical stratum with its historical floor, exercised inside verify-all.sh above. It has zero edges with the kernel0-era stack and is no longer the front door.
mneme-memory|ABSENT|Mneme memory layer|Not implemented. No lane exists. "Mneme" currently names a directory, not a working memory-and-continuity layer. Nothing here can be run because nothing here has been built.
seam|ADOPTED|derive/perform over a journal-backed process: One Act /0 — ADOPTED|ADOPTED 2026-08-08 by owner terminal ruling (One Act /0 R2.3 terminal adoption). The exact verified candidate commit 461f2013d1a6feca2b13819ff6ae3f60617e8e82 (tree 1123c3c3326664f54d1d96547ba872a876cbd495) was merged unmodified; its 173 checks, the 97-gate floor, the loader witnesses and the disease/control pairs all ran green pre-adoption and once post-adoption. DISCLOSURE, VERBATIM FROM THE ADOPTION RECORD: the stranger primitive-minimization audit prescribed as a promotion gate was NOT performed; the owner waived that gate for One Act /0 because its resource cost was disproportionate to the remaining design risk. This variance does not constitute independent validation and does not prevent later primitive reduction or architectural revision. Full record: mneme/language-act-0/ADOPTION-RECORD-2026-08-08.md.
TABLE

# ===========================================================================
# THE AUTHORIZED ENUMERATION — recomputed from the table above on EVERY run,
# and compared against the authorized totals.  Registering a gate without
# amending these numbers, or amending these numbers without registering a
# gate, FAILS CLOSED before a single gate executes.
#
# The floor's own doctrine, applied to the floor itself: a count that differs
# from its authorized value fails closed EVEN UPWARD.  Until R2.3 the floor
# counted its gates dynamically and would have absorbed a silently vanished
# row as good news.
#
#   94 -> 97 full   (+3: One Act /0's selftest, load witnesses, loader disease)
#   76 -> 77 light  (+1: the selftest alone; the other two are full-profile)
# ===========================================================================
AUTHORIZED_GATES_FULL=97
AUTHORIZED_GATES_CI=77

COUNT_CI="$(printf '%s\n' "$GATES" | grep -c '^both|')"
COUNT_FULL_ONLY="$(printf '%s\n' "$GATES" | grep -c '^full|')"
COUNT_FULL=$((COUNT_CI + COUNT_FULL_ONLY))

ENUM_BAD=0
[ "$COUNT_FULL" -ne "$AUTHORIZED_GATES_FULL" ] && ENUM_BAD=1
[ "$COUNT_CI"   -ne "$AUTHORIZED_GATES_CI"   ] && ENUM_BAD=1
if [ "$ENUM_BAD" -ne 0 ]; then
  echo "!! FAIL CLOSED: gate enumeration drift."
  echo "   full profile : expected $AUTHORIZED_GATES_FULL, table enumerates $COUNT_FULL"
  echo "   ci profile   : expected $AUTHORIZED_GATES_CI, table enumerates $COUNT_CI"
  echo "   The table and its authorized totals must be amended together, under a ruling."
  exit 1
fi

# ===========================================================================
if [ "$LIST_ONLY" -eq 1 ]; then
  printf '%-6s %-12s %s\n' PROFILE LANE COMMAND
  while IFS='|' read -r prof lane cwd cmd expect writes; do
    [ -z "${prof:-}" ] && continue
    printf '%-6s %-12s (cwd %s) %s\n' "$prof" "$lane" "$cwd" "$cmd"
  done <<< "$GATES"
  echo
  echo "-- declared, not executed --"
  while IFS='|' read -r lane status head why; do
    [ -z "${lane:-}" ] && continue
    printf '%-22s %-12s %s\n' "$status" "$lane" "$head"
  done <<< "$DECLARED"
  exit 0
fi

# --- preflight -------------------------------------------------------------
echo "==========================================================================="
echo " LISP+ AGGREGATE RELEASE FLOOR — profile: $PROFILE"
echo " Self-consistency certification, never independent conformance."
echo " The stranger primitive-minimization audit is OWED."
echo "==========================================================================="
echo

command -v sbcl >/dev/null 2>&1 || { echo "!! sbcl not on PATH"; exit 127; }
SBCL_VERSION="$(sbcl --noinform --non-interactive \
  --eval '(progn (princ (lisp-implementation-version)) (terpri) (finish-output))' 2>/dev/null | tail -1)"
echo "toolchain    : SBCL ${SBCL_VERSION}  (supported: 2.4.6/Linux — nothing else tested)"
if [ "$SBCL_VERSION" != "2.4.6" ]; then
  echo "!! FAIL CLOSED: this floor is authorized for SBCL 2.4.6 only."
  echo "   Observed ${SBCL_VERSION}. No portability is claimed and none may be inferred."
  exit 1
fi
echo "subject root : $ROOT"
echo "caller cwd   : $(pwd)"
echo "profile      : $PROFILE"
echo "enumeration  : full $COUNT_FULL/$AUTHORIZED_GATES_FULL · light $COUNT_CI/$AUTHORIZED_GATES_CI  (authorized == actual, recomputed from the table)"

# Snapshot the caller's checkout so we can prove we left it alone.
GIT_BEFORE=""
IN_GIT=0
if git -C "$ROOT" rev-parse --git-dir >/dev/null 2>&1; then
  IN_GIT=1
  GIT_BEFORE="$(git -C "$ROOT" status --porcelain -- "$ROOT" 2>/dev/null)"
  echo "git before   : $(printf '%s' "$GIT_BEFORE" | grep -c . || true) entr(y|ies) under the subject tree"
else
  echo "git before   : not a git checkout — cleanliness check limited to the disposable copy"
fi

RUNDIR="$(mktemp -d "${TMPDIR:-/tmp}/lisp-plus-release-run.XXXXXX")"
COPY="$RUNDIR/tree"
LOGS="$RUNDIR/logs"
mkdir -p "$LOGS"
cleanup() { rm -rf "$RUNDIR"; }
trap cleanup EXIT INT TERM
echo "run scratch  : $RUNDIR  (removed on success AND on failure)"
echo

# --- the disposable copy ---------------------------------------------------
# Writing gates run here so the caller's checkout stays byte-clean by
# construction rather than by discipline.  The two large read-only corpora are
# symlinked rather than copied (458 MB + 101 MB); nothing writes into them.
echo "-- materializing disposable tree copy for writing gates --"
mkdir -p "$COPY"
if command -v rsync >/dev/null 2>&1; then
  rsync -a --exclude '.git/' \
           --exclude 'canonical-datum/evidence/' \
           --exclude 'canonical-datum/generated/' \
           "$ROOT"/ "$COPY"/
else
  ( cd "$ROOT" && tar -cf - --exclude=.git --exclude=canonical-datum/evidence \
      --exclude=canonical-datum/generated . ) | ( cd "$COPY" && tar -xf - )
fi
ln -sfn "$ROOT/canonical-datum/evidence"  "$COPY/canonical-datum/evidence"
ln -sfn "$ROOT/canonical-datum/generated" "$COPY/canonical-datum/generated"
echo "   copy ready: $(du -sh "$COPY" 2>/dev/null | cut -f1)"
echo

# --- run ------------------------------------------------------------------
N=0; N_PASS=0; N_FAIL=0; N_BLOCKED=0
declare -a ROWS=()
FAILED_DETAIL=""

run_gate() {
  local lane="$1" cwd="$2" cmd="$3" expect="$4" writes="$5"
  local base tree_for_run log rc out status
  N=$((N+1))
  if [ "$writes" = "yes" ]; then tree_for_run="$COPY"; else tree_for_run="$ROOT"; fi
  log="$LOGS/$(printf '%03d' "$N").log"
  printf '[%03d] %-11s %-4s %s\n' "$N" "$lane" "$([ "$writes" = yes ] && echo COPY || echo INPL)" "$cmd"
  ( cd "$tree_for_run/$cwd" 2>/dev/null && eval "$cmd" ) >"$log" 2>&1
  rc=$?
  # Exit 2 is the reserved "required input absent" code.  A gate that cannot
  # obtain its input has not failed; it has not run.  Calling that FAIL would be
  # a lie in one direction, and calling it PASS a lie in the other.
  if [ "$rc" -eq 2 ]; then
    status="BLOCKED-EXTERNAL-INPUT"
  elif [ "$rc" -ne 0 ]; then
    status="FAIL"
  elif [ "$expect" != "-" ] && ! grep -qF -- "$expect" "$log"; then
    status="FAIL"
  else
    status="PASS"
  fi
  if [ "$status" = "BLOCKED-EXTERNAL-INPUT" ]; then
    N_BLOCKED=$((N_BLOCKED+1))
    echo "      -> BLOCKED-EXTERNAL-INPUT (exit 2 — required input absent, gate did not run)"
    echo "         $(head -3 "$log" | tail -2 | tr '\n' ' ')"
  elif [ "$status" = "PASS" ]; then
    N_PASS=$((N_PASS+1))
    echo "      -> PASS (exit $rc)"
  else
    N_FAIL=$((N_FAIL+1))
    echo "      -> FAIL (exit $rc)"
    FAILED_DETAIL="${FAILED_DETAIL}
--- FAILED GATE #$N  lane=$lane
    command : $cmd
    cwd     : $cwd   (tree: $([ "$writes" = yes ] && echo 'disposable copy' || echo 'caller checkout'))
    exit    : $rc
    expected: $expect
    last 25 lines of output:
$(tail -25 "$log" | sed 's/^/      /')
"
  fi
  ROWS+=("$status|$lane|$cwd|$cmd|$expect|$rc|$([ "$writes" = yes ] && echo copy || echo in-place)")
}

while IFS='|' read -r prof lane cwd cmd expect writes; do
  [ -z "${prof:-}" ] && continue
  if [ "$PROFILE" = "ci" ] && [ "$prof" != "both" ]; then continue; fi
  run_gate "$lane" "$cwd" "$cmd" "$expect" "$writes"
done <<< "$GATES"

# --- the attempted count IS the authorized count ---------------------------
# The enumeration was checked before the run; this checks that the run actually
# attempted every enumerated row (a `continue` bug, a mangled line, a partial
# read would all show up here rather than in nobody's arithmetic).
EXPECTED_ATTEMPTS=$([ "$PROFILE" = "ci" ] && echo "$AUTHORIZED_GATES_CI" || echo "$AUTHORIZED_GATES_FULL")
ATTEMPT_BAD=0
if [ "$N" -ne "$EXPECTED_ATTEMPTS" ]; then
  ATTEMPT_BAD=1
  echo
  echo "!! FAIL CLOSED: this run attempted $N gate(s); profile $PROFILE authorizes $EXPECTED_ATTEMPTS."
fi

# --- cleanliness, fail closed ---------------------------------------------
echo
echo "-- checkout cleanliness --"
DIRTY=0
if [ "$IN_GIT" -eq 1 ]; then
  GIT_AFTER="$(git -C "$ROOT" status --porcelain -- "$ROOT" 2>/dev/null)"
  if [ "$GIT_BEFORE" != "$GIT_AFTER" ]; then
    DIRTY=1
    echo "!! FAIL CLOSED: the caller's checkout changed during this run."
    diff <(printf '%s\n' "$GIT_BEFORE") <(printf '%s\n' "$GIT_AFTER") | sed 's/^/   /' || true
  else
    echo "   unchanged: zero tracked modifications, zero new untracked litter."
  fi
else
  echo "   not a git checkout — skipped (the disposable copy absorbed every write)."
fi

# --- report ----------------------------------------------------------------
echo
echo "==========================================================================="
echo " LANE TABLE"
echo "==========================================================================="
printf '%-22s %-12s %s\n' STATUS LANE 'GATES (executed this run)'
for lane in aggregate kernel0 journal0 capability0 capability1 capability2 \
            adapter0 core0 slice0 slice1 slice2 form0 form1 form2 \
            surface0 surface1 surface2 surface-account act0 vertical0 cd0 lci0 \
            atelier release; do
  p=0; f=0; b=0
  for row in "${ROWS[@]:-}"; do
    [ -z "$row" ] && continue
    IFS='|' read -r st ln _ <<< "$row"
    if [ "$ln" = "$lane" ]; then
      case "$st" in
        PASS) p=$((p+1)) ;;
        BLOCKED-EXTERNAL-INPUT) b=$((b+1)) ;;
        *) f=$((f+1)) ;;
      esac
    fi
  done
  [ $((p+f+b)) -eq 0 ] && continue
  suffix=""
  [ "$b" -ne 0 ] && suffix=", $b BLOCKED-EXTERNAL-INPUT"
  if [ "$f" -eq 0 ]; then
    printf '%-22s %-12s %d gate(s), %d passed%s\n' PASS "$lane" "$((p+f+b))" "$p" "$suffix"
  else
    printf '%-22s %-12s %d gate(s), %d passed, %d FAILED%s\n' FAIL "$lane" "$((p+f+b))" "$p" "$f" "$suffix"
  fi
done

echo
N_DECLARED=0; N_D_UNRESOLVED=0; N_D_BLOCKED=0; N_D_ARCHIVED=0; N_D_ABSENT=0; N_D_PASS=0
N_D_CANDIDATE=0; N_D_ADOPTED=0
while IFS='|' read -r lane status head why; do
  [ -z "${lane:-}" ] && continue
  N_DECLARED=$((N_DECLARED+1))
  case "$status" in
    KNOWN-UNRESOLVED)       N_D_UNRESOLVED=$((N_D_UNRESOLVED+1)) ;;
    BLOCKED-EXTERNAL-INPUT) N_D_BLOCKED=$((N_D_BLOCKED+1)) ;;
    ARCHIVED-NOT-RERUN)     N_D_ARCHIVED=$((N_D_ARCHIVED+1)) ;;
    ABSENT)                 N_D_ABSENT=$((N_D_ABSENT+1)) ;;
    PASS)                   N_D_PASS=$((N_D_PASS+1)) ;;
    CANDIDATE-NOT-ADOPTED)  N_D_CANDIDATE=$((N_D_CANDIDATE+1)) ;;
    ADOPTED)                N_D_ADOPTED=$((N_D_ADOPTED+1)) ;;
  esac
done <<< "$DECLARED"

echo "-- declared, not executed (carried forward unchanged, never turned green) --"
while IFS='|' read -r lane status head why; do
  [ -z "${lane:-}" ] && continue
  printf '\n%-22s %-12s %s\n' "$status" "$lane" "$head"
  printf '%s\n' "$why" | fold -s -w 74 | sed 's/^/                                   /'
done <<< "$DECLARED"

if [ -n "$FAILED_DETAIL" ]; then
  echo
  echo "==========================================================================="
  echo " FAILURES"
  echo "==========================================================================="
  printf '%s\n' "$FAILED_DETAIL"
fi

echo
echo "==========================================================================="
echo " EXECUTABLE GATES (this floor ran them)"
echo "   attempted                : $N"
echo "   passed                   : $N_PASS"
echo "   failed                   : $N_FAIL"
echo "   blocked-external-input   : $N_BLOCKED"
echo
echo " CARRIED STATUS ROWS (declared, NOT executed by this floor)"
echo "   rows carried             : $N_DECLARED"
echo "   of which KNOWN-UNRESOLVED     : $N_D_UNRESOLVED"
echo "   of which BLOCKED-EXTERNAL-INPUT: $N_D_BLOCKED"
echo "   of which ARCHIVED-NOT-RERUN   : $N_D_ARCHIVED"
echo "   of which ABSENT               : $N_D_ABSENT"
echo "   of which PASS (elsewhere)     : $N_D_PASS"
echo "   of which CANDIDATE-NOT-ADOPTED: $N_D_CANDIDATE"
echo "   of which ADOPTED              : $N_D_ADOPTED"
echo
echo " THE TWO GROUPS ARE NEVER SUMMED. An executable gate is something this"
echo " floor ran in this process; a carried status row is a standing fact this"
echo " floor reports without running anything. 'blocked-external-input: 0' above"
echo " means ZERO EXECUTABLE GATES were blocked; it does not contradict the"
echo " $N_D_BLOCKED carried BLOCKED-EXTERNAL-INPUT row(s), which are a different"
echo " denominator entirely."
if [ "$PROFILE" = "ci" ]; then
  echo
  echo " THIS IS THE REDUCED CI PROFILE — NOT THE FULL FLOOR."
  echo " It omits, exactly and by name, every gate marked 'full' in the table:"
  while IFS='|' read -r prof lane cwd cmd expect writes; do
    [ -z "${prof:-}" ] && continue
    [ "$prof" = "full" ] && echo "   omitted: [$lane] (cwd $cwd) $cmd"
  done <<< "$GATES"
  echo
  echo " The full authoritative release floor is the local closure gate:"
  echo "   bash mneme/verify-release.sh"
fi
echo
echo " Exit 0 here means: every executable gate passed at its authorized count,"
echo " every known unresolved finding is unchanged and named above, and every"
echo " archived-only item passed its integrity check. It does NOT mean that all"
echo " semantic questions are resolved, and it adopts nothing."
echo "==========================================================================="

if [ "$N_FAIL" -ne 0 ] || [ "$DIRTY" -ne 0 ] || [ "$ATTEMPT_BAD" -ne 0 ]; then
  echo
  echo "FLOOR RESULT: FAIL"
  exit 1
fi
echo
echo "FLOOR RESULT: PASS ($N executable gates attempted / $N_PASS passed / $N_BLOCKED blocked; $N_DECLARED carried status rows; profile $PROFILE)"
exit 0
