#!/usr/bin/env bash
#
# ==========================================================================
# NON-PRODUCTION FEASIBILITY PROBE — Surface Account /0 opening round —
# not a package, not an API, not loadable as part of any system.
# ==========================================================================
#
# THE ONE ENTRY POINT.  Runs the whole bounded pre-code feasibility probe in
# throwaway child SBCL images and writes its transcripts to a directory YOU
# name.  Nothing is written inside the worktree: the worktree holds sources
# only, so that a packer can re-run this at the frozen parcel tip and compare.
#
#   bash run-probe.sh <output-directory>
#   bash run-probe.sh <output-directory> --plant-failure
#
# EMITS, into <output-directory>:
#   probe-transcript.txt         the fourteen positive-matrix cases
#   controls-transcript.txt      the seven fixed controls
#   freshness-transcript.txt     the contract II.3 freshness-mechanism demonstration
#   freshness-peer-image.txt     the second image T3 needs (not a transcript)
#   schema-witness-transcript.txt  the CD/0 inspection-record schema witness (R2)
#   allocator-transcript.txt     the concurrent allocator tooth (R2)
#   init-stale-transcript.txt      the stale-definition overwrite tooth (R3.3)
#   init-recursive-transcript.txt  the genuine recursive-load tooth (R3.3)
#   init-post-election-transcript.txt     the unprotected post-election interval (R3.3.1)
#   init-plist-foreign-transcript.txt     the carrier with unrelated properties (R3.3.1)
#   init-plist-contention-transcript.txt  the plist changed mid-election (R3.3.1)
#   init-publication-finality-transcript.txt  the instant after publication (R3.3.2)
#   init-carrier-slot-transcript.txt      presence versus value in the reserved slot (R3.3.2)
#   init-carrier-total-transcript.txt     the malformed-carrier totality closure (R3.3.3)
#
# EXIT 0 only if every clean arm passed AND every transcript is ACCEPTED by
# verify-transcript.sh UNDER AN EXPLICIT EXPECTED PROFILE — the ordered
# sections, their exact CASES and their exact CHECKS, all declared in
# verify-profiles.txt, together with the exact ordered check-ID sequence
# declared in verify-sequences.txt, and passed on the command line with the
# exact tested tip AND the repository that tip must resolve in.  Nothing about
# what SHOULD be there is read out of the transcript.  --plant-failure deliberately breaks one probe check; the runner
# must then exit NONZERO and emit NO PASS sentinel.  That arm is the proof that
# a green run means something.  The verifier's own teeth are exercised
# separately, by run-verifier-specimens.sh.
#
# THE OUTPUT DIRECTORY MAY NOT BE INSIDE THE WORKTREE, and that is enforced
# here rather than requested in a README: the path is resolved before anything
# is created, and again after the directory is realized.
#
# DETERMINISM: every line that can differ between two runs of these sources at
# one parcel tip is prefixed `VOLATILE` (the wall-clock stamp) so a comparer can
# exclude it with `grep -v VOLATILE`.  PARCEL_TIP is stamped at the TOP and the
# BOTTOM of every transcript.
#
# WHAT THIS PROBE MAY NOT DO, enforced by having no code that does it: define
# the proposed package, export an API, mint an Account /0 object, edit a
# predecessor, load arbitrary paths or modules, evaluate/compile/execute any
# expansion, scan packages beyond the two named providers, scan filesystems or
# git history, or touch the retired census artifacts.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# probes/ -> language-surface-account-0/ -> mneme/ -> subject root
ROOT="$(cd "$HERE/../../.." && pwd)"

usage() {
  echo "usage: bash run-probe.sh <output-directory> [--plant-failure]" >&2
  exit 2
}

[ $# -ge 1 ] || usage
OUTDIR="$1"; shift
PLANT=0
while [ $# -gt 0 ]; do
  case "$1" in
    --plant-failure) PLANT=1 ;;
    *) usage ;;
  esac
  shift
done

# --------------------------------------------------------------------------
# THE OUTPUT-DIRECTORY BOUNDARY IS ENFORCED, NOT REQUESTED.
#
# The worktree holds SOURCES ONLY.  Under R0 that was a sentence in a README —
# a guarantee written as prose the operator was supposed to remember.  It is
# now a gate: an output directory that resolves inside the worktree is
# REFUSED, before anything is created, and again after the directory is
# realized (a symlink can point back in).
# --------------------------------------------------------------------------
WORKTREE="$(git -C "$ROOT" rev-parse --show-toplevel 2>/dev/null || true)"
if [ -z "$WORKTREE" ]; then
  echo "!! FAIL CLOSED: cannot resolve the worktree root from $ROOT; the output-directory" >&2
  echo "   boundary cannot be enforced, so nothing is run." >&2
  exit 2
fi
WT_PHYS="$(cd "$WORKTREE" && pwd -P)"

# The physical absolute path a name WOULD have, WITHOUT CREATING ANYTHING.
#
# R2: nonexistent components and `..` are resolved LOGICALLY before the answer
# is returned.  R1 appended the nonexistent tail to the deepest existing
# prefix as raw text, so a spelling like <somewhere>/nonexistent/../evidence
# was compared with the worktree root as literal text rather than as the path
# it denotes.  The deepest EXISTING prefix is still resolved physically (that
# is what catches a symlink); everything past it is resolved by popping `..`
# and dropping `.`, which is what realpath -m does and what a mkdir -p would
# actually create.
resolve_intended () {
  local p="$1" prefix rest="" comp out
  case "$p" in /*) ;; *) p="$PWD/$p" ;; esac
  prefix="$p"
  while [ ! -d "$prefix" ] && [ "$prefix" != "/" ]; do
    rest="$(basename "$prefix")${rest:+/$rest}"
    prefix="$(dirname "$prefix")"
  done
  out="$(cd "$prefix" && pwd -P)"
  [ "$out" = "/" ] && out=""
  local IFS=/
  for comp in $rest; do
    case "$comp" in
      ''|'.') ;;
      '..')   out="${out%/*}" ;;
      *)      out="$out/$comp" ;;
    esac
  done
  printf '%s\n' "${out:-/}"
}

reject_if_inside_worktree () {
  case "$1" in
    "$WT_PHYS"|"$WT_PHYS"/*)
      echo "!! REFUSED: the output directory" >&2
      echo "     $1" >&2
      echo "   resolves INSIDE the worktree" >&2
      echo "     $WT_PHYS" >&2
      echo "   This probe writes transcripts OUTSIDE the worktree so that a packer can" >&2
      echo "   re-run it at a frozen parcel tip and compare.  Name a directory elsewhere." >&2
      exit 2 ;;
  esac
}

reject_if_inside_worktree "$(resolve_intended "$OUTDIR")"

mkdir -p "$OUTDIR" || { echo "!! cannot create $OUTDIR" >&2; exit 2; }
OUTDIR="$(cd "$OUTDIR" && pwd -P)"
reject_if_inside_worktree "$OUTDIR"

# --------------------------------------------------------------------------
# OPERATION-CHECK FIRST.  A standing lab scar: the `sbcl` on PATH may be a
# wrapper.  Before any long run, a trivial child must print the implementation
# version through the exact invocation the probe will use.
# --------------------------------------------------------------------------
if ! command -v sbcl >/dev/null 2>&1; then
  echo "!! sbcl not on PATH" >&2; exit 127
fi

OPCHECK="$(sbcl --noinform --non-interactive \
  --eval '(progn (princ (lisp-implementation-version)) (terpri) (finish-output))' 2>/dev/null | tail -1)"

if [ "$OPCHECK" != "2.4.6" ]; then
  echo "!! FAIL CLOSED: this probe is authorized for SBCL 2.4.6 only; observed '${OPCHECK}'." >&2
  echo "   No portability is claimed and none may be inferred." >&2
  exit 1
fi

# The parcel tip is load-bearing: the verifier is TOLD the expected tip and
# refuses any stamp that differs, so a run that cannot read one is a run whose
# transcripts could not be tied to a source state.  Fail closed.
export SA0_PROBE_PARCEL_TIP="$(cd "$ROOT" && git rev-parse HEAD 2>/dev/null || true)"
if [ -z "$SA0_PROBE_PARCEL_TIP" ]; then
  echo "!! FAIL CLOSED: no parcel tip is readable at $ROOT." >&2
  echo "   A transcript stamped UNAVAILABLE cannot be tied to any source state." >&2
  exit 1
fi
export SA0_PROBE_UNAME="$(uname -a)"
export SA0_PROBE_STAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
export SA0_PROBE_ROOT="$ROOT"
if [ "$PLANT" -eq 1 ]; then export SA0_PROBE_PLANT_FAILURE=1; else unset SA0_PROBE_PLANT_FAILURE || true; fi

run_child () {
  # run_child <probe-file> <transcript-path>
  local file="$1" out="$2"
  {
    echo "PARCEL_TIP $SA0_PROBE_PARCEL_TIP"
    echo "VOLATILE run-started $SA0_PROBE_STAMP"
    echo "OPERATION-CHECK sbcl $OPCHECK (trivial child through this exact invocation)"
  } > "$out"
  sbcl --noinform --non-interactive \
    --eval '(require :asdf)' \
    --eval '(require :sb-posix)' \
    --eval "(asdf:initialize-source-registry '(:source-registry (:directory \"${ROOT}\") :inherit-configuration))" \
    --eval '(asdf:load-system "lisp-plus")' \
    --load "$HERE/probe-prelude.lisp" \
    --load "$file" \
    >> "$out" 2>&1
  local rc=$?
  {
    echo "PARCEL_TIP $SA0_PROBE_PARCEL_TIP"
    echo "CHILD-EXIT $rc"
  } >> "$out"
  return $rc
}

echo "== Surface Account /0 — bounded pre-code feasibility probe =="
echo "   PARCEL_TIP  $SA0_PROBE_PARCEL_TIP"
echo "   sbcl        $OPCHECK"
echo "   outdir      $OUTDIR"
[ "$PLANT" -eq 1 ] && echo "   MODE        --plant-failure (a deliberate probe failure is armed)"

RC=0

run_child "$HERE/probe-matrix.lisp" "$OUTDIR/probe-transcript.txt"
MATRIX_RC=$?
[ "$MATRIX_RC" -ne 0 ] && RC=1
echo "   matrix      exit $MATRIX_RC"

# The controls run in two children: controls 1-5 and 7 share one image; control
# 6 REDEFINES provider declarations and must therefore have an image of its own,
# entered clean and thrown away afterwards.
run_child "$HERE/probe-controls.lisp" "$OUTDIR/controls-part-a.txt"
CA_RC=$?
[ "$CA_RC" -ne 0 ] && RC=1
echo "   controls A  exit $CA_RC"

run_child "$HERE/probe-control-6.lisp" "$OUTDIR/controls-part-b.txt"
CB_RC=$?
[ "$CB_RC" -ne 0 ] && RC=1
echo "   controls B  exit $CB_RC"

cat "$OUTDIR/controls-part-a.txt" "$OUTDIR/controls-part-b.txt" > "$OUTDIR/controls-transcript.txt"
rm -f "$OUTDIR/controls-part-a.txt" "$OUTDIR/controls-part-b.txt"

# --------------------------------------------------------------------------
# THE FRESHNESS MECHANISM DEMONSTRATION (contract II.3, authorized by the
# adjudication's section D: "specify and test a real freshness mechanism").
#
# T3 requires TWO SEPARATELY STARTED IMAGES.  So this file is run twice: first
# in the WITNESS role, whose entire job is to mint an image epoch, print it and
# exit — its output is kept as freshness-peer-image.txt, evidence that a second
# image really ran — and then in the ordinary role, told the peer's epoch
# through the environment.  The witness output is NOT a transcript and carries
# no section; only the second run is verified.
# --------------------------------------------------------------------------
{
  echo "PEER-IMAGE PARCEL_TIP $SA0_PROBE_PARCEL_TIP"
  echo "VOLATILE peer-image started $(date -u +%Y-%m-%dT%H:%M:%SZ)"
} > "$OUTDIR/freshness-peer-image.txt"
SA0_PROBE_FRESHNESS_ROLE=witness sbcl --noinform --non-interactive \
  --eval '(require :asdf)' \
  --eval '(require :sb-posix)' \
  --eval "(asdf:initialize-source-registry '(:source-registry (:directory \"${ROOT}\") :inherit-configuration))" \
  --eval '(asdf:load-system "lisp-plus")' \
  --load "$HERE/probe-prelude.lisp" \
  --load "$HERE/probe-freshness.lisp" \
  >> "$OUTDIR/freshness-peer-image.txt" 2>&1
WITNESS_RC=$?
echo "PEER-IMAGE-EXIT $WITNESS_RC" >> "$OUTDIR/freshness-peer-image.txt"

# R3.3.1: the peer image's epoch line now carries the VOLATILE marker (it is a
# freshly gathered epoch and it changes every run), so the parser reads the
# marked spelling and takes the THIRD field.  Source and parser moved together.
PEER_EPOCH="$(awk '/^VOLATILE FRESHNESS-WITNESS-EPOCH /{print $3; exit}' "$OUTDIR/freshness-peer-image.txt")"
if [ "$WITNESS_RC" -ne 0 ] || [ -z "$PEER_EPOCH" ]; then
  echo "   !! freshness peer image produced no epoch (exit $WITNESS_RC) — T3 cannot be demonstrated"
  RC=1
fi
export SA0_PROBE_PEER_EPOCH="$PEER_EPOCH"

run_child "$HERE/probe-freshness.lisp" "$OUTDIR/freshness-transcript.txt"
FR_RC=$?
[ "$FR_RC" -ne 0 ] && RC=1
echo "   freshness   exit $FR_RC  (peer image exit $WITNESS_RC)"

# --------------------------------------------------------------------------
# THE CD/0 INSPECTION-RECORD SCHEMA WITNESS (R2 adjudication, section A) and
# THE CONCURRENT ALLOCATOR TOOTH (R2 adjudication, section D).  Each runs in
# its own throwaway child: the witness touches both providers for its native
# datum samples, and the allocator tooth starts eight host threads.
# --------------------------------------------------------------------------
run_child "$HERE/probe-schema-witness.lisp" "$OUTDIR/schema-witness-transcript.txt"
SW_RC=$?
[ "$SW_RC" -ne 0 ] && RC=1
echo "   schema      exit $SW_RC"

run_child "$HERE/probe-allocator.lisp" "$OUTDIR/allocator-transcript.txt"
AL_RC=$?
[ "$AL_RC" -ne 0 ] && RC=1
echo "   allocator   exit $AL_RC"

# --------------------------------------------------------------------------
# THE TWO SCHEDULE-PINNED INITIALIZATION TEETH (R3.3-B).
#
# One source, two roles, TWO SEPARATE FRESH IMAGES — and the two images are the
# point, not an accident of convenience.  Each tooth requires that the candidate
# identity source has NEVER been loaded in its image when the tooth begins,
# because that is the only moment at which a FIRST initialization can be
# scheduled at all.  The first tooth spends that moment; a second tooth sharing
# the image would be racing a decision already taken.
#
# The role is passed through the environment and read once at load time.  It is
# unset again afterwards so that no later child can inherit it.
# --------------------------------------------------------------------------
export SA0_PROBE_SCHEDULE_ROLE=stale
run_child "$HERE/probe-init-schedule.lisp" "$OUTDIR/init-stale-transcript.txt"
IS_RC=$?
[ "$IS_RC" -ne 0 ] && RC=1
echo "   init stale  exit $IS_RC"

export SA0_PROBE_SCHEDULE_ROLE=recursive
run_child "$HERE/probe-init-schedule.lisp" "$OUTDIR/init-recursive-transcript.txt"
IR_RC=$?
[ "$IR_RC" -ne 0 ] && RC=1
echo "   init recurs exit $IR_RC"

# --------------------------------------------------------------------------
# THE THREE EXCEPTIONAL-INITIALIZATION TEETH (R3.3.1).
#
# Same source, three more roles, THREE MORE FRESH IMAGES, for the same reason
# as the two above: each needs an image in which the candidate identity source
# has never been loaded, and each spends that moment.  They cannot share an
# image with each other either — the post-election arm deliberately leaves its
# image TERMINALLY FAILED, and a tooth that ran after it would be measuring a
# corpse rather than an election.
# --------------------------------------------------------------------------
export SA0_PROBE_SCHEDULE_ROLE=post-election-failure
run_child "$HERE/probe-init-schedule.lisp" "$OUTDIR/init-post-election-transcript.txt"
PE_RC=$?
[ "$PE_RC" -ne 0 ] && RC=1
echo "   init postel exit $PE_RC"

export SA0_PROBE_SCHEDULE_ROLE=plist-foreign
run_child "$HERE/probe-init-schedule.lisp" "$OUTDIR/init-plist-foreign-transcript.txt"
PF_RC=$?
[ "$PF_RC" -ne 0 ] && RC=1
echo "   init foreign exit $PF_RC"

export SA0_PROBE_SCHEDULE_ROLE=plist-contention
run_child "$HERE/probe-init-schedule.lisp" "$OUTDIR/init-plist-contention-transcript.txt"
PC_RC=$?
[ "$PC_RC" -ne 0 ] && RC=1
echo "   init conten exit $PC_RC"

# --------------------------------------------------------------------------
# THE PUBLICATION-FINALITY AND CARRIER-SLOT TEETH (R3.3.2).
#
# Same source, two more roles, TWO MORE FRESH IMAGES.  The publication-finality
# role needs an image in which the candidate identity source has never been
# loaded, for the same reason as every role above, and it spends that moment.
# The carrier-slot role needs one too — its lawful arm is a genuine first
# initialization — and it additionally plants four unlawful carriers BEFORE
# that arm, which is possible in one image only because a REJECTED load holds
# no election and therefore spends nothing; the section prints the image-wide
# election count before the lawful arm rather than asserting that.
# --------------------------------------------------------------------------
export SA0_PROBE_SCHEDULE_ROLE=publication-finality
run_child "$HERE/probe-init-schedule.lisp" "$OUTDIR/init-publication-finality-transcript.txt"
PFIN_RC=$?
[ "$PFIN_RC" -ne 0 ] && RC=1
echo "   init pubfin exit $PFIN_RC"

export SA0_PROBE_SCHEDULE_ROLE=carrier-slot
run_child "$HERE/probe-init-schedule.lisp" "$OUTDIR/init-carrier-slot-transcript.txt"
CSLOT_RC=$?
[ "$CSLOT_RC" -ne 0 ] && RC=1
echo "   init carrier exit $CSLOT_RC"

# --------------------------------------------------------------------------
# THE MALFORMED-CARRIER TOTALITY TOOTH (R3.3.3).
#
# One more role, ONE MORE FRESH IMAGE.  Its three arms are ALL refusals — there
# is no lawful arm here at all — so this image never spends the one moment a
# first initialization needs, and the section proves that rather than assuming
# it: after the three arms the carrier is restored to empty and the image-wide
# election and gathering counts are read back through the source's own readers.
# It still gets its own image, because a role that ran after a spent moment
# could not say that.
# --------------------------------------------------------------------------
export SA0_PROBE_SCHEDULE_ROLE=carrier-total
run_child "$HERE/probe-init-schedule.lisp" "$OUTDIR/init-carrier-total-transcript.txt"
CTOT_RC=$?
[ "$CTOT_RC" -ne 0 ] && RC=1
echo "   init total  exit $CTOT_RC"
unset SA0_PROBE_SCHEDULE_ROLE

# --------------------------------------------------------------------------
# The runner's own sentinel.  It is emitted ONLY when every child exited 0 AND
# every transcript is ACCEPTED BY THE VERIFIER UNDER AN EXPLICIT EXPECTED
# PROFILE.  The profile — the exact ordered sections and their exact case
# counts — is named HERE and read from verify-profiles.txt; it is never
# inferred from the artifact under test.  So is the tip.
# --------------------------------------------------------------------------
verify_one () {
  local f="$1" profile="$2"
  local out
  if out="$(bash "$HERE/verify-transcript.sh" "$f" --profile "$profile" \
                 --tip "$SA0_PROBE_PARCEL_TIP" --repo "$ROOT" 2>&1)"; then
    echo "   verified    $profile: ${out#ACCEPTED: }"
  else
    echo "   !! transcript REFUSED under profile '$profile': $f"
    echo "      $out"
    RC=1
  fi
}

verify_one "$OUTDIR/probe-transcript.txt"      matrix
verify_one "$OUTDIR/controls-transcript.txt"   controls
verify_one "$OUTDIR/freshness-transcript.txt"  freshness
verify_one "$OUTDIR/schema-witness-transcript.txt" schema
verify_one "$OUTDIR/allocator-transcript.txt"      allocator
verify_one "$OUTDIR/init-stale-transcript.txt"     init-stale
verify_one "$OUTDIR/init-recursive-transcript.txt" init-recursive
verify_one "$OUTDIR/init-post-election-transcript.txt"    init-post-election
verify_one "$OUTDIR/init-plist-foreign-transcript.txt"    init-plist-foreign
verify_one "$OUTDIR/init-plist-contention-transcript.txt" init-plist-contention
verify_one "$OUTDIR/init-publication-finality-transcript.txt" init-publication-finality
verify_one "$OUTDIR/init-carrier-slot-transcript.txt"         init-carrier-slot
verify_one "$OUTDIR/init-carrier-total-transcript.txt"        init-carrier-total

echo
if [ "$RC" -eq 0 ]; then
  echo "SURFACE-ACCOUNT-0-PROBE-PASS  tip=$SA0_PROBE_PARCEL_TIP"
  exit 0
else
  echo "SURFACE-ACCOUNT-0-PROBE-FAILED  tip=$SA0_PROBE_PARCEL_TIP"
  exit 1
fi
