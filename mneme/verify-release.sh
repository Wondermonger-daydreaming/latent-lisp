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
# Exit 0 means exactly these things, jointly (the terminal conjunction is printed
# line by line at the end of every run, so no reader has to infer which one carried
# the result):
#
#   (1) the disposable copy was materialized from the committed subject object and
#       its path/mode/byte identity against that object was proven;
#   (2) the run attempted exactly the authorized number of gates;
#   (3) EVERY authorized executable gate PASSED -- there is no longer any executable
#       status that is neither pass nor failure;
#   (4) the lane accounting closed: every executed row fell in exactly one printed
#       lane and the lane totals summed to the attempt total;
#   (5) the subject-tree porcelain was OBSERVED EMPTY at both endpoints -- before the
#       run and after it, both probes succeeding -- and the two observations agree.
#       Two snapshots cannot establish the continuous absence of a transient write;
#       this floor claims only the endpoints it observed;
#   (6) every KNOWN-UNRESOLVED finding is unchanged and reported below by name;
#   (7) every ARCHIVED-NOT-RERUN item passed its integrity check.
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
#   BLOCKED-EXTERNAL-INPUT RETIRED FOR EXECUTABLE GATES by RELEASE FLOOR ERRATUM
#                          /0 (2026-08-23).  No executable row can be given this
#                          status any more.  See the erratum block below.
#   GATE-CWD-ABSENT        the gate's declared working directory does not exist,
#                          so the command never started.  Non-pass.
#   GATE-CWD-UNREADABLE    the declared working directory exists but could not be
#                          entered.  Non-pass.
#   FAIL                   anything else, including a nonzero exit of ANY value and
#                          a count or verdict that moved away from its authorized
#                          value
#
# Two further states belong to the FLOOR, not to a row:
#
#   CLEANLINESS-UNKNOWN    a `git status` probe of the caller's checkout failed, so
#                          the state could be neither confirmed nor denied.  Fails
#                          closed; it is never printed as clean.
#   CHECKOUT-NOT-CLEAN     the probe SUCCEEDED and the subject-tree porcelain is not
#                          empty.  Distinct from CLEANLINESS-UNKNOWN in exactly the way
#                          that matters: here we looked, and we saw dirt.  At entry this
#                          is a PRECONDITION FAILURE -- nothing is materialized and no
#                          gate runs.  (Equality of two dirty snapshots is not
#                          cleanliness, and a dirty entry admits two subjects into one
#                          run: read-only rows would read the working tree while writing
#                          rows read the committed object.)
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
# RELEASE FLOOR ERRATUM /0 (2026-08-23) — executable refusal classification
# ---------------------------------------------------------------------------
#
# Until this erratum, `exit 2` from an executable gate was read as the semantic
# value Blocked(external-input) and did NOT increment the failure count.  But
# `exit 2` is a transport-level integer, not a semantic value: bash returns it for
# a syntax error, python3 for a missing or unreadable script and for an argparse
# refusal, and ten of this floor's own leaf gates return it as their LOUDEST
# refusal ("REFUSING TO RUN — required file(s) absent", "HARD FAIL — manifest
# absent").  The reader projected all of those onto one non-failing state, so a
# broken executable gate could be reported as blocked and the aggregate could
# still read PASS.  Sol I's ruling of 2026-08-23, in one line:
#
#   exit(2) is a transport-level integer, not the semantic value Blocked(external-input).
#
# The governing rule installed here:
#
#   AN AGGREGATE EXECUTABLE-FLOOR PASS MEANS EVERY AUTHORIZED EXECUTABLE GATE PASSED.
#
#   rc == 0 plus the exact expected witness  -> PASS
#   rc == 0 without its expected witness     -> FAIL
#   ANY nonzero executable exit              -> non-pass, and it increments the
#                                               terminal failure obligation
#
# The ten honest leaf refusers were NOT edited.  Their loud `exit 2` refusals are
# correct; only their reader was wrong.  Once the exemption is removed they
# correctly redden this floor.
#
# No replacement external-input protocol is invented here.  If a future executable
# gate genuinely requires an external input, Sol I's ruling requires a separately
# commissioned protocol carrying a declared gate identity and external-input
# identity, an exact sentinel emitted by the leaf, a matching distinct exit, and an
# aggregate terminal state such as INCOMPLETE — never PASS.  No current executable
# row has demonstrated a lawful need for one.
#
# The carried DECLARED table below keeps its own BLOCKED-EXTERNAL-INPUT row.  That
# is a different denominator: a standing fact this floor reports without running
# anything.  It is untouched by this erratum.
#
# ---------------------------------------------------------------------------
# HYGIENE
# ---------------------------------------------------------------------------
#
# Every transcript-writing and scratch-producing gate runs inside a disposable
# copy of the tree under $TMPDIR, never in your checkout.  The copy is removed
# on success AND on failure.  The floor snapshots your checkout's git state
# before and after and FAILS CLOSED if a single byte moved -- and, since ERRATUM
# /0, fails closed just as hard if it could not take that snapshot at all.  It also
# REFUSES TO START if the subject tree is dirty when it begins: a floor entered dirty
# would read the working tree for its read-only rows and the committed object for its
# writing rows, and would then mistake stable dirt for an unchanged checkout.
#
# The disposable copy is materialized from the EXACT COMMITTED SUBJECT OBJECT
# (`git archive HEAD:<subject prefix>`), never from working-tree or ignored
# litter, and its path/mode/byte identity against that object is PROVEN before a
# single gate runs.  Two large read-only corpora (canonical-datum/evidence and
# canonical-datum/generated, 458 MB + 101 MB) are DECLARED exclusions: symlinked
# to the caller's checkout, excluded from both the archive and the expected
# manifest, and named in the transcript.  Consequence, stated so nobody has to
# discover it: this floor now REQUIRES a git checkout in which the subject is
# committed.  A history-free `git archive` export is no longer a venue it will
# run in.
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
    -h|--help) awk 'NR>1 && /^#/ {print; next} NR>1 {exit}' "${BASH_SOURCE[0]}"; exit 0 ;;
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
# — standing: ADOPTED 2026-08-08 (owner act; record
# mneme/language-act-0/ADOPTION-RECORD-2026-08-08.md; carried row `seam`
# below).  [Comment corrected 2026-08-22 under census correction C11, Sol I's
# ruling: this paragraph previously read "IS AN UNADOPTED CANDIDATE" — true at
# registration, false since 08-08.]  Its rows are here because the floor
# should be able to RUN it; a green row is not a ruling.  It acquires no
# umbrella row — the standalone `lisp-plus/act0` door stays canonical.  (This
# file has no per-row adoption marker and none is invented here; the carried
# status rows below state standing in words.)
#
# ONE ACT /1 (lane `act1`, six rows, registered 2026-08-20 as the chair's
# additive act, authorized by Sol's cold-parcel-review disposition relayed by
# the owner: "add its completeness-checked candidate registration rows in the
# same bounded session") — standing: ADOPTED 2026-08-22 at lab commit
# aeeefa40 (owner act, ceilings verbatim; record
# mneme/language-act-1/ADOPTION-RECORD-2026-08-22.md; carried row `act1`
# below).  [Comment corrected 2026-08-22 under C11: previously "IS AN
# UNADOPTED CANDIDATE".]  Same discipline as act0: its rows are here so the
# floor can RUN it; a green row is not a ruling; publication is a separate act.
# Counts are the POST-REPAIR authorized counts from the lane's committed
# RUN-EXITCODES.txt (Sol's 2026-08-20 blocking finding repaired: controls
# 11 -> 14, host-fault proof added).  The standalone door
# mneme/language-act-1/load.lisp stays canonical; `lisp-plus/act1` exists as
# a standalone system only (no umbrella lane-order row).
#
# MEMORY LAYER /0 (lane `ml0`, nine rows, registered 2026-08-21 as the chair's
# integration-only act, authorized by Sol's R5 REGISTRATION RULING — archived
# verbatim at corpus/voices/received/2026-08-21-sol-ml0-r5-registration-
# ruling.md — "R5 is ACCEPTABLE FOR REGISTRATION AS A CANDIDATE … Registration
# is authorized.  Adoption and freeze are not.") WAS REGISTERED AS AN UNADOPTED
# CANDIDATE and on 2026-08-22 was ADOPTED AND PUBLISHED by Sol I's terminal
# standing ruling, owner-countersigned (archived verbatim at corpus/voices/
# received/2026-08-22-sol-i-terminal-standing-ruling-ml0-adopted-and-
# published.md).  Its standing, in Sol's words made the floor's: ADOPTED AND
# PUBLISHED · stranger audit owed · no independent verification.  Executed
# rows may read PASS; the lane's governance standing is not thereby audited
# or frozen (the carried status row `ml0` below says so in words; the 61-file
# R5 object itself is unchanged by adoption).  Counts are
# the R5 authorized counts from the lane's committed RUN-EXITCODES.txt / RETURN
# (controls 13 after Sol's disposition B; consolidation proof 35; specimen 45).
# The standalone door mneme/memory-layer-0/load.lisp stays canonical;
# `lisp-plus/ml0` exists as a standalone system only (no umbrella lane-order
# row).  The lane's bytes at registration equal the accepted R5 parcel
# (sha 5742b4f8…); this act made no Memory Layer /0 semantic, source,
# specification, specimen or artifact change.
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
both|act1|.|sbcl --script mneme/language-act-1/act1-selftest.lisp|oneact1-selftest: 37 checks, 0 failures|no
both|act1|.|sbcl --script mneme/language-act-1/act1-host-fault-proof.lisp|oneact1-host-fault-proof: PASS|no
full|act1|.|sbcl --script mneme/language-act-1/act1-controls.lisp|oneact1-controls: 14 controls, 14 caught, 0 missed|no
full|act1|.|sbcl --script mneme/language-act-1/act1-mutants.lisp|oneact1-mutants: 3 defects, 3 killed, 0 survivors|no
full|act1|.|sbcl --script mneme/language-act-1/act1-red-proof.lisp|oneact1-red-proof: cured PASS, uncured FAIL — the tooth bites|no
full|act1|.|sbcl --script mneme/language-act-1/de-actu-resurgente/run-specimen.lisp|de-actu-resurgente: 49 checks, 0 failures|yes
both|ml0|.|sbcl --script mneme/memory-layer-0/load.lisp|kernel0 records+folds smoke: PASS|no
both|ml0|.|sbcl --script mneme/memory-layer-0/ml0-selftest.lisp|ml0-selftest: 81 checks, 0 failures|no
both|ml0|.|sbcl --script mneme/memory-layer-0/ml0-host-fault-proof.lisp|ml0-host-fault-proof: PASS|no
full|ml0|.|sbcl --script mneme/memory-layer-0/ml0-controls.lisp|ml0-controls: 13 controls, 13 caught, 0 missed|no
full|ml0|.|sbcl --script mneme/memory-layer-0/ml0-mutants.lisp|ml0-mutants: 6 defects, 6 killed, 0 survivors|no
full|ml0|.|sbcl --script mneme/memory-layer-0/ml0-block-proof.lisp|ml0-block-proof: 20 probes, 20 closed, 0 open|no
full|ml0|.|sbcl --script mneme/memory-layer-0/ml0-consolidation-proof.lisp|ml0-consolidation-proof: 35 checks, 0 failures|no
full|ml0|.|sbcl --script mneme/memory-layer-0/ml0-red-proof.lisp|ml0-red-proof: cured PASS, uncured FAIL — the tooth bites|no
full|ml0|.|sbcl --script mneme/memory-layer-0/de-actu-memorato/run-specimen.lisp|de-actu-memorato: 45 checks, 0 failures|yes
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
ml0|ADOPTED|Memory Layer /0 — the language's durable account of its own act: ADOPTED AND PUBLISHED · stranger audit owed · no independent verification|ADOPTED AND PUBLISHED 2026-08-22 by Sol I's terminal standing ruling, owner-countersigned (corpus/voices/received/2026-08-22-sol-i-terminal-standing-ruling-ml0-adopted-and-published.md): publication = exact-bound transport of lab commit 71d94fc2… to public target 9a56eabd…, far-side Git tree c7a3820e… = bound subject minus _staging; adoption = the owner's and Sol's governance act over the object REGISTERED 2026-08-21 by Sol's R5 registration ruling (corpus/voices/received/2026-08-21-sol-ml0-r5-registration-ruling.md), lane bytes equal to the accepted R5 parcel sha 5742b4f8…, the 61-file object UNCHANGED. Nine executable rows above may read PASS; adoption and publication do NOT make this standing PASS, audited or frozen, and neither word discharges the stranger audit. Sol did not independently rerun SBCL. Ceilings carried verbatim: durable account survives its writer · occurrence requires its full admitted conjunction · warrant issuance cannot manufacture the warranted event · inadmissible evidence yields :unresolved · §5.A append-only failure semantics + mandatory pre-append dry decode · /0 same-store only · receipt-bearing foreign lineage reserved to Memory Layer /1 · D6 PARTIAL · D4 SHOWN-AS-AMENDED · package privacy is defense in depth · same-family execution is not independent audit. Publication return accepted WITH RECEIPT ERRATUM (far-side manifest measured mid-floor; the witness is the Git tree). Former row here read CANDIDATE-NOT-ADOPTED (2026-08-21→22).
act1|ADOPTED|perform ACROSS process death: One Act /1 — ADOPTED|ADOPTED 2026-08-22 by owner ruling (interview, "Adopt at aeeefa40, ceilings verbatim") on Sol's combined-record ruling ADOPTION-ELIGIBLE. Adopted object: lane mneme/language-act-1 at lab commit aeeefa40ffc51466dba09cfc0cc14e0055e69b6d, 38 files, specimen sha256 bf5751a6…, unchanged by the act. Evidence: a cold stranger audit (fresh Codex session, sealed cold order; terminal BLOCK on the VENUE — ptrace denied, history-free checkout — preserved unrevised) + a §VII execution supplement in a capable venue (112/112, 0 blocked, exit 0, HEAD stable, porcelain empty, PJ0-METADATA-INVALID absent). CEILINGS TRAVEL VERBATIM (record: mneme/language-act-1/ADOPTION-RECORD-2026-08-22.md): SBCL 2.4.6/Linux only · frozen implementation, finite paths · deterministic planted death, no general SIGKILL/power-loss/mid-write guarantee · fake world, scripted adapter subset, one seat/effect family · no alternative Act1/Core implementation · heterogeneous observer shares the semantic implementation · audit-defined inherited certificate, no public evidence (de)serializer · package privacy is defense in depth, not a security boundary · the 104-name export surface is an implementation choice, not a normative interface · ML0's 27-symbol consumption is version-bound verification debt · DO NOT SAY "independently verified". Adoption removes ML0's dependency-standing blocker only; it adopts nothing else, freezes no publication commit, lifts no sentinel.
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
#   97 -> 103 full  (+6: One Act /1's selftest, host-fault proof, controls,
#                    mutants, red-proof, specimen — registered 2026-08-20 with
#                    the rows above, under Sol's cold-review disposition
#                    relayed by the owner; the first run after adding the rows
#                    WITHOUT these totals failed closed here, as designed)
#   77 -> 79 light  (+2: the selftest and the host-fault proof; the other
#                    four are full-profile)
#   103 -> 112 full (+9: Memory Layer /0's canonical load, selftest, host-fault
#                    proof, controls, mutants, block proof, consolidation proof,
#                    combined red proof, specimen — registered 2026-08-21 under
#                    Sol's R5 registration ruling; the totals below were
#                    RECOMPUTED MECHANICALLY from the table by the same grep the
#                    floor itself runs, not predicted or hand-entered)
#   79 -> 82 light  (+3: canonical load, selftest, host-fault proof; the other
#                    six are full-profile)
# ===========================================================================
AUTHORIZED_GATES_FULL=112
AUTHORIZED_GATES_CI=82

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

# --- the subject must be a COMMITTED object (ERRATUM /0, cure 3) -------------
# The disposable copy is produced from the committed subject object.  A tree with
# no repository has no committed object to copy and no identity to prove, so this
# floor can no longer certify one.
if ! git -C "$ROOT" rev-parse --git-dir >/dev/null 2>&1; then
  echo "!! FAIL CLOSED: $ROOT is not inside a git checkout."
  echo "   Since RELEASE FLOOR ERRATUM /0 this floor materializes its disposable copy from"
  echo "   the COMMITTED subject object.  Without a repository there is no such object."
  echo "   No gate ran."
  echo
  echo "FLOOR RESULT: FAIL"
  exit 1
fi
IN_GIT=1
SUBJECT_PREFIX="$(git -C "$ROOT" rev-parse --show-prefix 2>/dev/null)"
# Pathspecs are resolved relative to git's working directory, so archive/ls-tree are
# driven from the repository TOPLEVEL while the tree-ish is the subject subtree: the
# pathspecs are then relative to the subject, in both topologies.  With an empty
# prefix (the public-mirror topology) toplevel and subject root are the same place.
REPO_TOP="$(git -C "$ROOT" rev-parse --show-toplevel 2>/dev/null)"
SUBJECT_COMMIT="$(git -C "$ROOT" rev-parse --verify --quiet HEAD || true)"
SUBJECT_TREE="$(git -C "$ROOT" rev-parse --verify --quiet "HEAD:${SUBJECT_PREFIX%/}" || true)"
if [ -z "${SUBJECT_TREE:-}" ] || [ "$(git -C "$ROOT" cat-file -t "$SUBJECT_TREE" 2>/dev/null)" != "tree" ]; then
  echo "!! FAIL CLOSED: cannot resolve the committed subject tree HEAD:${SUBJECT_PREFIX%/}"
  echo "   (prefix resolved from git rev-parse --show-prefix; empty prefix means the subject"
  echo "    IS the repository root, which is the public-mirror topology)."
  echo "   No gate ran."
  echo
  echo "FLOOR RESULT: FAIL"
  exit 1
fi
echo "subject commit: ${SUBJECT_COMMIT:-<none>}"
echo "subject tree : $SUBJECT_TREE   (HEAD:${SUBJECT_PREFIX:-<repository root>})"

# Snapshot the caller's checkout so we can prove we left it alone.  The probe's own
# exit status is carried: a probe that FAILED is CLEANLINESS-UNKNOWN, never the empty
# string meaning clean (ERRATUM /0, cure 5).
CLEAN_UNKNOWN=0
NOT_CLEAN=0
GIT_BEFORE="$(git -C "$ROOT" status --porcelain -- "$ROOT" 2>/dev/null)"
GIT_BEFORE_RC=$?
if [ "$GIT_BEFORE_RC" -ne 0 ]; then
  CLEAN_UNKNOWN=1
  echo "git before   : CLEANLINESS-UNKNOWN — the probe itself failed (exit $GIT_BEFORE_RC)"
  git -C "$ROOT" status --porcelain -- "$ROOT" 2>&1 >/dev/null | head -5 | sed 's/^/               /'
else
  GIT_BEFORE_N="$(printf '%s' "$GIT_BEFORE" | grep -c . || true)"
  echo "git before   : $GIT_BEFORE_N entr(y|ies) under the subject tree"
  # ERRATUM /0 SUCCESSOR (Sol I, 2026-08-23): a checkout that begins DIRTY and stays
  # IDENTICALLY dirty used to satisfy the before/after comparison and print "unchanged".
  # Equality is not cleanliness.  Worse, a dirty entry admits TWO SUBJECTS into one run:
  # the read-only rows consume the working tree while the writing rows consume the
  # committed copy.  A successful initial probe must therefore be EMPTY, and this is a
  # PRECONDITION -- it fails before materialization and before any gate runs.
  if [ "$GIT_BEFORE_N" -ne 0 ]; then
    NOT_CLEAN=1
    echo "!! CHECKOUT-NOT-CLEAN: the subject tree is not clean at entry."
    printf '%s\n' "$GIT_BEFORE" | head -20 | sed 's/^/     /'
    [ "$GIT_BEFORE_N" -gt 20 ] && echo "     … and $((GIT_BEFORE_N - 20)) more"
    echo "   This is DISTINCT from CLEANLINESS-UNKNOWN: the probe worked, and it says the"
    echo "   tree is dirty.  A dirty entry would let this floor consume two subjects in one"
    echo "   run -- read-only rows read these working-tree bytes while writing rows read the"
    echo "   committed object -- and would let stable dirt be reported as an unchanged"
    echo "   checkout.  Commit or stash the subject tree, or run the floor in a clean clone."
    echo "   NO GATE RAN.  Nothing was materialized."
    echo
    echo "FLOOR RESULT: FAIL"
    exit 1
  fi
fi

RUNDIR="$(mktemp -d "${TMPDIR:-/tmp}/lisp-plus-release-run.XXXXXX")"
COPY="$RUNDIR/tree"
LOGS="$RUNDIR/logs"
mkdir -p "$LOGS"
cleanup() { rm -rf "$RUNDIR"; }
trap cleanup EXIT INT TERM
echo "run scratch  : $RUNDIR  (removed on success AND on failure)"
echo

# --- the disposable copy: the EXACT COMMITTED SUBJECT OBJECT ----------------
# ERRATUM /0, cures 3 and 4.  Writing gates run here so the caller's checkout stays
# byte-clean by construction rather than by discipline -- and the copy is now the
# committed object rather than whatever happens to be lying in the working tree.
# Any archive, extraction or identity failure stops this floor BEFORE a gate runs.
#
# DECLARED EXCLUSIONS: the two large read-only corpora are symlinked rather than
# materialized (458 MB + 101 MB; nothing writes into them).  The exclusion is applied
# to the archive AND to the expected manifest AND printed here -- it is a named
# exclusion, not a silent gap.
MAT_EXCLUDE_1='canonical-datum/evidence'
MAT_EXCLUDE_2='canonical-datum/generated'
MAT_OK=0
echo "-- materializing disposable tree copy from the COMMITTED subject object --"
mkdir -p "$COPY"
echo "   source       : $SUBJECT_TREE  (HEAD:${SUBJECT_PREFIX:-<repository root>})"
echo "   exclusions   : $MAT_EXCLUDE_1, $MAT_EXCLUDE_2  (symlinked, not materialized, and excluded from the manifest)"

git -C "$REPO_TOP" archive --format=tar "$SUBJECT_TREE" -- . \
      ":(exclude)$MAT_EXCLUDE_1" ":(exclude)$MAT_EXCLUDE_2" 2>"$RUNDIR/archive.err" \
  | tar -xf - -C "$COPY" 2>"$RUNDIR/extract.err"
MAT_PIPE=("${PIPESTATUS[@]}")
if [ "${MAT_PIPE[0]}" -ne 0 ] || [ "${MAT_PIPE[1]}" -ne 0 ]; then
  echo "!! FAIL CLOSED: could not materialize the committed subject object."
  echo "   git archive exit : ${MAT_PIPE[0]}"
  sed 's/^/     /' "$RUNDIR/archive.err" 2>/dev/null | head -10
  echo "   tar extract exit : ${MAT_PIPE[1]}"
  sed 's/^/     /' "$RUNDIR/extract.err" 2>/dev/null | head -10
  echo "   NO GATE RAN.  A floor that cannot say which bytes it measured measures nothing."
  echo
  echo "FLOOR RESULT: FAIL"
  exit 1
fi

# --- identity of the materialized object, proven BEFORE any mutation --------
# Path, mode and byte, against the committed tree.  Not a file count: a count is
# equal for a copy in which every byte is wrong.  The byte comparison is by git blob
# object id, which IS the sha1 of the content.
EXPECTED_MANIFEST="$RUNDIR/manifest.expected"
OBSERVED_MANIFEST="$RUNDIR/manifest.observed"
IDENT_BAD=0
IDENT_WHY=""

git -C "$REPO_TOP" ls-tree -r -z "$SUBJECT_TREE" \
  | tr '\0' '\n' \
  | awk -F'\t' 'NF==2 { split($1,a," "); print $2 "\t" a[1] "\t" a[3] }' \
  | grep -v -E "^($MAT_EXCLUDE_1|$MAT_EXCLUDE_2)/" \
  | LC_ALL=C sort > "$EXPECTED_MANIFEST"

# a path that could impersonate a line break would corrupt the comparison silently
NUL_COUNT="$( ( cd "$COPY" && find . -type f -print0 ) | tr -cd '\0' | wc -c )"
( cd "$COPY" && find . -type f -printf '%P\n' | LC_ALL=C sort ) > "$RUNDIR/paths.txt"
LINE_COUNT="$(wc -l < "$RUNDIR/paths.txt")"
if [ "$NUL_COUNT" -ne "$LINE_COUNT" ]; then
  IDENT_BAD=1
  IDENT_WHY="${IDENT_WHY}   a path in the copy contains a newline: $NUL_COUNT file(s), $LINE_COUNT line(s)
"
fi
( cd "$COPY" && find . -mindepth 1 ! -type d ! -type f -print ) > "$RUNDIR/nonregular.txt" 2>/dev/null
if [ -s "$RUNDIR/nonregular.txt" ]; then
  IDENT_BAD=1
  IDENT_WHY="${IDENT_WHY}   the copy contains $(grep -c . "$RUNDIR/nonregular.txt") non-regular file(s); the committed tree has none
"
fi
( cd "$COPY" && git hash-object --stdin-paths < "$RUNDIR/paths.txt" ) > "$RUNDIR/oids.txt" 2>"$RUNDIR/hash.err"
HASH_RC=$?
if [ "$HASH_RC" -ne 0 ]; then
  IDENT_BAD=1
  IDENT_WHY="${IDENT_WHY}   could not hash the copy (git hash-object exit $HASH_RC): $(head -1 "$RUNDIR/hash.err" 2>/dev/null)
"
fi
while IFS= read -r mpath; do
  if [ -x "$COPY/$mpath" ]; then echo 100755; else echo 100644; fi
done < "$RUNDIR/paths.txt" > "$RUNDIR/modes.txt"
paste "$RUNDIR/paths.txt" "$RUNDIR/modes.txt" "$RUNDIR/oids.txt" > "$OBSERVED_MANIFEST"

if ! diff "$EXPECTED_MANIFEST" "$OBSERVED_MANIFEST" > "$RUNDIR/manifest.diff" 2>&1; then
  IDENT_BAD=1
  IDENT_WHY="${IDENT_WHY}   the copy does not match the committed tree in path, mode or byte
"
fi
if [ "$IDENT_BAD" -ne 0 ]; then
  echo "!! FAIL CLOSED: the materialized copy is not the committed subject object."
  printf '%s' "$IDENT_WHY"
  echo "   expected entries : $(grep -c . "$EXPECTED_MANIFEST" 2>/dev/null || echo 0)"
  echo "   observed entries : $(grep -c . "$OBSERVED_MANIFEST" 2>/dev/null || echo 0)"
  echo "   first differences (expected < / observed >):"
  head -20 "$RUNDIR/manifest.diff" 2>/dev/null | sed 's/^/     /'
  echo "   NO GATE RAN."
  echo
  echo "FLOOR RESULT: FAIL"
  exit 1
fi
MAT_ENTRIES="$(grep -c . "$EXPECTED_MANIFEST")"
MAT_OK=1
echo "   identity     : VERIFIED — $MAT_ENTRIES entries match the committed tree in path, mode and byte"

# Only now, with identity proven, is the copy mutated with the two corpus symlinks.
ln -sfn "$ROOT/canonical-datum/evidence"  "$COPY/canonical-datum/evidence"
ln -sfn "$ROOT/canonical-datum/generated" "$COPY/canonical-datum/generated"
echo "   copy ready   : $(du -sh "$COPY" 2>/dev/null | cut -f1)  (the two corpora are symlinks, not counted)"
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
  # --- the declared working directory speaks for itself (ERRATUM /0, cure 2) --
  # The old form was `( cd "$dir" 2>/dev/null && eval "$cmd" )`: a gate that never
  # started and a gate that ran and disagreed both printed `FAIL (exit 1)` over an
  # EMPTY log, because the cd's own diagnostic was discarded.  The two silences are
  # now two strings, and the diagnosis is kept.
  local rundir cd_diag cd_rc
  rundir="$tree_for_run/$cwd"
  cd_diag="$( cd "$rundir" 2>&1 >/dev/null )"
  cd_rc=$?
  if [ "$cd_rc" -ne 0 ]; then
    rc=$cd_rc
    if [ -e "$rundir" ]; then status="GATE-CWD-UNREADABLE"; else status="GATE-CWD-ABSENT"; fi
    {
      printf '%s: the declared working directory could not be entered.\n' "$status"
      printf '  declared cwd : %s\n' "$cwd"
      printf '  resolved to  : %s\n' "$rundir"
      printf '  tree         : %s\n' "$([ "$writes" = yes ] && echo 'disposable copy' || echo 'caller checkout')"
      printf '  cd exit      : %s\n' "$cd_rc"
      printf '  shell said   : %s\n' "${cd_diag:-<the shell printed nothing; the directory test itself refused>}"
      printf '  The command was NEVER STARTED.  This is not the same event as a gate that\n'
      printf '  ran and disagreed, and this floor no longer prints it as if it were.\n'
    } > "$log"
  else
    ( cd "$rundir" && eval "$cmd" ) >"$log" 2>&1
    rc=$?
    # ERRATUM /0, cure 1: the generic `rc == 2 -> BLOCKED-EXTERNAL-INPUT` exemption is
    # GONE.  exit 2 is a transport integer, not a semantic value.  ANY nonzero exit is
    # non-pass and increments the terminal failure obligation.
    if [ "$rc" -ne 0 ]; then
      status="FAIL"
    elif [ "$expect" != "-" ] && ! grep -qF -- "$expect" "$log"; then
      status="FAIL"
    else
      status="PASS"
    fi
  fi
  if [ "$status" = "BLOCKED-EXTERNAL-INPUT" ]; then
    # Structurally unreachable since ERRATUM /0: no branch above can set this status.
    # The counter and this arm are kept so that a future edit which reintroduces a
    # blocking path is caught by the terminal conjunction instead of quietly passing.
    N_BLOCKED=$((N_BLOCKED+1))
    echo "      -> BLOCKED-EXTERNAL-INPUT (exit $rc)"
  elif [ "$status" = "PASS" ]; then
    N_PASS=$((N_PASS+1))
    echo "      -> PASS (exit $rc)"
  else
    N_FAIL=$((N_FAIL+1))
    echo "      -> $status (exit $rc)"
    FAILED_DETAIL="${FAILED_DETAIL}
--- NON-PASSING GATE #$N  lane=$lane  status=$status
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
# ERRATUM /0, cure 5: each probe carries its own exit status.  A probe that FAILED is
# CLEANLINESS-UNKNOWN and fails closed.  It is never the empty string meaning clean.
# ERRATUM /0 SUCCESSOR: the final probe must ALSO be EMPTY, not merely equal to the first.
DIRTY=0
GIT_AFTER="$(git -C "$ROOT" status --porcelain -- "$ROOT" 2>/dev/null)"
GIT_AFTER_RC=$?
if [ "$GIT_AFTER_RC" -ne 0 ]; then
  CLEAN_UNKNOWN=1
  echo "!! CLEANLINESS-UNKNOWN: the final git status probe failed (exit $GIT_AFTER_RC)."
  git -C "$ROOT" status --porcelain -- "$ROOT" 2>&1 >/dev/null | head -5 | sed 's/^/   /'
  echo "   A floor that cannot check quiescence must not print that it holds."
elif [ "$CLEAN_UNKNOWN" -ne 0 ]; then
  echo "!! CLEANLINESS-UNKNOWN: the INITIAL git status probe failed, so the entry state was"
  echo "   never established.  The final probe succeeded; that is not enough."
else
  GIT_AFTER_N="$(printf '%s' "$GIT_AFTER" | grep -c . || true)"
  if [ "$GIT_BEFORE" != "$GIT_AFTER" ]; then
    DIRTY=1
    echo "!! FAIL CLOSED: the caller's checkout changed during this run."
    diff <(printf '%s\n' "$GIT_BEFORE") <(printf '%s\n' "$GIT_AFTER") | sed 's/^/   /' || true
  fi
  if [ "$GIT_AFTER_N" -ne 0 ]; then
    NOT_CLEAN=1
    echo "!! CHECKOUT-NOT-CLEAN: the subject tree is not clean at the final endpoint."
    printf '%s\n' "$GIT_AFTER" | head -20 | sed 's/^/     /'
  fi
  if [ "$DIRTY" -eq 0 ] && [ "$NOT_CLEAN" -eq 0 ]; then
    echo "   clean at both observed endpoints: the subject-tree porcelain was EMPTY before"
    echo "   this run and EMPTY after it, and both probes succeeded.  Two snapshots cannot"
    echo "   prove that nothing was written and reverted in between; this floor claims the"
    echo "   two endpoints it actually observed, and claims nothing about the interval."
  fi
fi

# --- report ----------------------------------------------------------------
echo
echo "==========================================================================="
echo " LANE TABLE"
echo "==========================================================================="
# ERRATUM /0, cure 6: the lane list is DERIVED from the selected gate table, in the
# table's own order of first appearance.  There is no second hardcoded census to drift
# out of step with the first -- the previous hardcoded list had silently dropped `act1`
# and `ml0`, so 15 executed rows, in the two ADOPTED lanes, appeared in no printed lane.
# The derivation is then ASSERTED: every executed row must fall in exactly one printed
# lane, and the printed lane totals must sum to the executable attempt total.
LANES_PRINTED="$(printf '%s\n' "$GATES" | awk -F'|' -v prof="$PROFILE" '
  NF>=6 && $1 != "" { if (prof == "ci" && $1 != "both") next; if (!seen[$2]++) print $2 }')"
LANES_SP=" $(printf '%s ' $LANES_PRINTED)"
LANE_SUM=0
LANE_COUNT=0
LANE_BAD=0
printf '%-22s %-12s %s\n' STATUS LANE 'GATES (executed this run)'
for lane in $LANES_PRINTED; do
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
  LANE_COUNT=$((LANE_COUNT+1))
  LANE_SUM=$((LANE_SUM+p+f+b))
  suffix=""
  [ "$b" -ne 0 ] && suffix=", $b BLOCKED-EXTERNAL-INPUT"
  if [ "$f" -eq 0 ] && [ "$b" -eq 0 ]; then
    printf '%-22s %-12s %d gate(s), %d passed%s\n' PASS "$lane" "$((p+f+b))" "$p" "$suffix"
  else
    printf '%-22s %-12s %d gate(s), %d passed, %d NON-PASSING%s\n' FAIL "$lane" "$((p+f+b))" "$p" "$((f+b))" "$suffix"
  fi
done

# --- the lane accounting invariant, asserted -------------------------------
for row in "${ROWS[@]:-}"; do
  [ -z "$row" ] && continue
  IFS='|' read -r st ln _ <<< "$row"
  case "$LANES_SP" in
    *" $ln "*) ;;
    *) LANE_BAD=1
       echo "!! LANE ACCOUNTING VIOLATED: an executed row declares lane '$ln', which no printed lane covers." ;;
  esac
done
if [ "$LANE_SUM" -ne "$N" ]; then
  LANE_BAD=1
  echo "!! LANE ACCOUNTING VIOLATED: printed lanes sum to $LANE_SUM row(s); $N executable row(s) were attempted."
fi
if [ "$LANE_BAD" -eq 0 ]; then
  printf '\nlane accounting : %d lane(s) derived from the selected table; %d + 0 unaccounted == %d attempted.\n' \
    "$LANE_COUNT" "$LANE_SUM" "$N"
else
  printf '\nlane accounting : %d lane(s) printed, %d row(s) accounted, %d attempted — INVARIANT VIOLATED, FAILS CLOSED.\n' \
    "$LANE_COUNT" "$LANE_SUM" "$N"
fi

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
echo " floor reports without running anything. 'blocked-external-input: $N_BLOCKED' above"
echo " counts EXECUTABLE GATES blocked in this run and is STRUCTURALLY ZERO since"
echo " RELEASE FLOOR ERRATUM /0 — no branch can set that status on an executable row,"
echo " and a nonzero value there fails this floor closed. It does not contradict the"
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
echo " Exit 0 here means: every executable gate PASSED at its authorized count — no"
echo " executable row can be neither pass nor failure since RELEASE FLOOR ERRATUM /0 —"
echo " the copy was the committed subject object, the lane accounting closed, the"
echo " subject tree was observed empty at both endpoints, every known unresolved"
echo " finding is unchanged and named above, and every archived-only item passed its"
echo " integrity check. It does NOT mean that all semantic questions are resolved,"
echo " and it adopts nothing."
echo "==========================================================================="

MAT_OK_BAD=$([ "${MAT_OK:-0}" -eq 1 ] && echo 0 || echo 1)

# ---------------------------------------------------------------------------
# THE TERMINAL CONJUNCTION (ERRATUM /0, cure 7)
# ---------------------------------------------------------------------------
# PASS is granted only if EVERY one of these holds.  Each is printed with its own
# verdict, so a reader never has to infer which one carried the result.
FLOOR_BAD=0
conj() {  # conj <ok?> <label>
  if [ "$1" -eq 0 ]; then printf '   [ok ] %s\n' "$2"; else FLOOR_BAD=1; printf '   [BAD] %s\n' "$2"; fi
}
echo
echo " TERMINAL CONJUNCTION — every line must read [ok] for PASS"
conj "$MAT_OK_BAD"        "committed-tree materialization succeeded and its identity was proven"
conj "$ATTEMPT_BAD"       "exact authorized attempt count: attempted $N, profile $PROFILE authorizes $EXPECTED_ATTEMPTS"
conj "$([ "$N_PASS" -eq "$EXPECTED_ATTEMPTS" ] && echo 0 || echo 1)" \
                          "every executable gate passed: $N_PASS passed of $EXPECTED_ATTEMPTS authorized"
conj "$([ "$N_FAIL" -eq 0 ] && echo 0 || echo 1)" \
                          "zero non-passing executable gates: $N_FAIL"
conj "$([ "$N_BLOCKED" -eq 0 ] && echo 0 || echo 1)" \
                          "zero executable blocks: $N_BLOCKED  (no branch can set this status since ERRATUM /0)"
conj "$LANE_BAD"          "lane accounting: every executed row in exactly one printed lane, totals exact"
conj "$CLEAN_UNKNOWN"     "cleanliness was actually OBSERVABLE (both git status probes succeeded)"
conj "$NOT_CLEAN"         "subject-tree porcelain EMPTY at both observed endpoints (entry is a precondition)"
conj "$DIRTY"             "the two observed endpoints agree — nothing moved between them"

if [ "$FLOOR_BAD" -ne 0 ]; then
  echo
  echo "FLOOR RESULT: FAIL"
  exit 1
fi
echo
echo "FLOOR RESULT: PASS ($N executable gates attempted / $N_PASS passed / $N_BLOCKED blocked; $N_DECLARED carried status rows; profile $PROFILE)"
exit 0
