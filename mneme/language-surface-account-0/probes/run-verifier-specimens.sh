#!/usr/bin/env bash
#
# ==========================================================================
# NON-PRODUCTION FEASIBILITY PROBE — Surface Account /0 opening round —
# not a package, not an API, not loadable as part of any system.
# ==========================================================================
#
# THE VERIFIER'S OWN TEETH.
#
# A gate that has never fired is untested, not passing.  The R0 verifier was
# green on every transcript it ever saw, and its one "truncation test" deleted
# material the verifier could not miss, because the verifier read its
# expectations out of the artifact.  So this script crafts DEFECTIVE ARTIFACTS
# — one per defect the law names — and requires each one to be REFUSED.
#
#   bash run-verifier-specimens.sh <output-directory> \
#        [--from <clean-controls-transcript> --tip <parcel-tip> [--profile <name>]] \
#        [--prefix-verifier <earlier-verifier.sh>]
#
# --prefix-verifier is the R3.1 addition.  Every specimen of the four R3.1
# families is presented to the EARLIER verifier as well, and its exit code is
# recorded beside the current one.  Each of those fifteen must exit 0 there:
# a "reproduction" the earlier verifier already refused is not a reproduction,
# and the script counts that as a failure of the demonstration.
#
# --r31-verifier is the R3.2 addition, and it is a SECOND and different prefix.
# Specimen 34's defect belonged to the R3.1 verifier, not to the R3-era one, so
# its pre-fix arm is measured against the extracted R3.1 text and its md5 is
# recorded beside the result.  Two eras, two flags: a reproduction filed
# against a verifier that never had the defect proves nothing.
#
# THE THIRTY-FOUR, in eight families:
#
#   TRANSCRIPT SPECIMENS 1-12, applied to both bases where applicable:
#      1 loss-of-last-block                 (R1)
#      2 missing-final-child-exit           (R1)
#      3 missing-closing-tip                (R1)
#      4 pass-flipped-to-fail               (R1)
#      5 pass-end-name-disagreement         (R1)
#      6 incorrect-cases                    (R1)
#      7 malformed-checks                   (R1)
#      8 hollow-last-block-checks-zero      (R2) intact shell, body removed,
#                                                CHECKS forged to 0
#      9 s2-half-removed-checks-forged      (R2) the whole S2 half of control 6
#                                                gone, CHECKS forged to match
#     10 material-after-end-of-transcript   (R2)
#     11 reindented-fail-verdict            (R2) an inserted [FAIL] at an
#                                                indentation R1 did not look at
#     12 nonexistent-git-tip                (R2) 40 lowercase hex digits that
#                                                resolve to no commit
#
#   OUTPUT-PATH TEETH 13-14, run once, against THIS SCRIPT's own boundary:
#     13 outdir-inside-the-worktree         (R2)
#     14 nonexistent-prefix-dotdot-inside   (R2) a spelling whose `..` resolves
#                                                back inside the worktree
#
#   R3 SPECIMENS 15-18, the four defects the R3 law names:
#     15 short-bracketed-verdict            (R3) a ONE-character bracketed
#                                                verdict, [X], beneath the R2
#                                                pattern's three-character floor
#     16 child-exit-000                     (R3) a terminator that is zero only
#                                                after numeric coercion
#     17 footer-failures-999                (R3) a section announcing 999
#                                                failures in its own footer while
#                                                every externally bound count
#                                                still agrees
#     18 tip-through-refs-replace           (R3) a tip naming NO OBJECT AT ALL,
#                                                lent a real commit's body by a
#                                                refs/replace mapping in a
#                                                purpose-built scratch repository
#
#   R3.1 SPECIMENS 19-33, the four families the R3.1 law enumerates.  EVERY ONE
#   OF THESE FIFTEEN WAS ACCEPTED BY THE R3 VERIFIER at tip d385dde5, which is
#   what --prefix-verifier records rather than asserts:
#
#     THE SECTION FOOTER (19-22) — under R3 it was refused if present and
#     lexically wrong, and never required, never counted, never read:
#       19 footer-missing                     20 footer-duplicate
#       21 footer-forged-checks               22 footer-forged-cases
#
#     THE IN-BODY TIP PAIR (23-26) — under R3 the VALUE of a stamp was checked
#     and the PAIR was not required, so a lost or doubled stamp was invisible:
#       23 tip-header-stamp-missing           24 tip-footer-stamp-missing
#       25 tip-header-stamp-duplicate         26 tip-footer-stamp-duplicate
#
#     HORIZONTAL-WHITESPACE IMPOSTORS (27-29) — a tab is not a space, so a
#     tab-prefixed structural token matched no reserved ERE and was then
#     consumed by the NARRATIVE fallback as prose:
#       27 tab-prefixed-checks                28 tab-prefixed-end-of-transcript
#       29 tab-prefixed-child-exit
#
#     REPOSITORY SUBSTITUTION (30-33) — the artifact is honest and the
#     ENVIRONMENT lies; `git -C <victim>` does not override GIT_DIR, and the
#     object-store variables and a configured alternates file do the same thing
#     one level down.  Two controls run first: the donor tip against the victim
#     in a CLEAN environment must be REFUSED, and the victim's own tip under all
#     six hostile variables at once must still be ACCEPTED:
#       30 ambient-git-dir                    31 ambient-git-object-directory
#       32 ambient-git-alternate-object-dirs  33 configured-object-alternates
#
#   R3.2 SPECIMEN 34 — THE PROMISOR IMPORT.  The artifact is honest, the
#   environment is clean and the repository's configuration is not a lie
#   either: the repository is a PARTIAL CLONE that simply does not hold the
#   tip and is willing to go and get it.  Asked whether the object exists, the
#   R3.1 verifier caused Git to FETCH it from a (wholly local) promisor remote,
#   import it, and then report it "physically present":
#       34 promisor-lazy-fetch                (R3.2)
#   Its pre-fix acceptance is measured against the EXTRACTED R3.1 verifier
#   (--r31-verifier), and the import is counted in object files rather than
#   described.  A control runs beside it: a partial clone HOLDING its own
#   commit must still be ACCEPTED, so the clause refuses imported existence and
#   not partial clones.
#
# THE SYNTHETIC BASE GREW ONE LINE IN R3.1, and it is a correction rather than a
# convenience: the real probe prelude has always emitted the in-body PARCEL_TIP
# stamps as a HEADER/FOOTER PAIR, and the synthetic base carried only the footer
# one.  Under the R3.1 law that base is not a well-formed transcript, so each
# synthetic block now carries its header stamp too — which is also what makes
# specimens 23-26 meaningful on the synthetic suite.
#
# SPECIMEN 8 IS THE ONE THE R1 VERIFIER ACCEPTED, and the mechanism that now
# refuses it is worth naming: the EXTERNAL PROFILE binds CONTROLS-B to 27
# CHECKS.  R1 compared the transcript's claimed CHECKS with the transcript's own
# [PASS] count — a hollowed section moves both to zero together and they agree.
# R2 compares the claim with verify-profiles.txt, which the artifact cannot
# reach.  A transcript claiming CHECKS=0 for CONTROLS-B contradicts the external
# binding, and THAT is what refuses it — not the emptiness of its body, which is
# exactly the thing a self-consistent forgery hides.
#
# THE LIVE BASE MUST HAVE AT LEAST TWO CHILD BLOCKS.  Specimen 1 deletes the
# LAST block, so on a single-block transcript it would produce a file identical
# to its base — which the script reports loudly rather than counting as a
# refusal.  `controls-transcript.txt` (CONTROLS-A + CONTROLS-B) is the intended
# live base and is the default profile.
#
# TWO SUITES, and the second only if you supply a real transcript:
#
#   SYNTHETIC  a self-contained two-block base written here, carrying the
#              closed grammar's shapes (CHECK-ID lines, C6-PROVIDER anchors,
#              the declared separator) under its OWN section names and its OWN
#              declared profile and ID sequences, so this script is runnable
#              with no probe run at all.  ITS TIP IS THE ALL-ZERO FIXTURE TIP,
#              WHICH IS NOT A GIT OBJECT, IS NOT A REAL TESTED TIP, AND IS
#              ACCEPTED ONLY UNDER THE VERIFIER'S EXPLICIT --fixture-tip MODE;
#   LIVE       the same defects applied to an ACTUAL clean
#              controls-transcript.txt from a real run, at a real Git tip.
#
# THE CONTROL ARM IS MANDATORY AND RUNS FIRST.  Before any specimen, each base
# is presented to the verifier UNTOUCHED and must be ACCEPTED.  Without it, a
# column of refusals would prove only that the verifier refuses everything.
#
# Every specimen, its verifier output and its exit code are written into
# <output-directory>/ so the refusals are evidence, not a claim about evidence.
# This script exits NONZERO if any specimen was accepted, if any base was
# refused, if any refusal exit code was 0, or if any output-path tooth failed.
#
# It runs no Lisp, loads no system, and writes nothing inside the worktree.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERIFY="$HERE/verify-transcript.sh"
# probes/ -> language-surface-account-0/ -> mneme/ -> subject root
ROOT="$(cd "$HERE/../../.." && pwd)"

# --------------------------------------------------------------------------
# THE R3.1-D GIT ENVIRONMENT CLAUSE APPLIES TO THIS HARNESS TOO.
#
# verify-transcript.sh clears the whole ambient repository/object/index
# selection set before every Git invocation of its own.  THIS SCRIPT'S OWN Git
# calls were unhardened, and they are not decorative: the worktree root
# resolved below is WT_PHYS, the value the output-path boundary teeth (13, 14)
# defend, and the fixture builders create the donor/victim repositories that
# specimens 18 and 30-33 are measured against.  An ambient GIT_DIR or
# GIT_WORK_TREE relocates the first; an ambient GIT_DIR redirects `git init`
# and every `git -C` in the second.  `git -C <path>` does NOT override GIT_DIR.
#
# GIT_CLEAN_ENV is the `env` prefix that removes the whole set.  Two forms are
# used below and the difference is deliberate:
#
#   git_clean <args>                          — the harness's OWN calls: every
#                                               ambient selector removed, and
#                                               the replacement-lens policy left
#                                               to the caller (specimen 18's
#                                               evidence block needs the lens ON
#                                               for one arm and OFF for the next);
#   env "${GIT_CLEAN_ENV[@]}" VAR=value git … — the DEMONSTRATION arms: the same
#                                               clean base, then exactly ONE
#                                               hostile variable set on purpose.
#                                               Clearing first is what makes the
#                                               arm a measurement of that one
#                                               variable rather than of whatever
#                                               the caller's shell happened to
#                                               export.
#
# What is NOT cleared anywhere: GIT_AUTHOR_DATE / GIT_COMMITTER_DATE, which the
# fixture builders set themselves so their commits are reproducible.
#
# R3.2 ADDS GIT_NO_LAZY_FETCH=1 AS AN ASSIGNMENT RATHER THAN AN UNSET, and the
# difference is the whole point.  Every other entry REMOVES a caller's variable;
# this one IMPOSES a policy — the harness's own object-existence questions must
# be answered by the store as it stands, never by a promisor fetch that quietly
# imports what it was asked about.  It is written LAST because `env` takes its
# -u options before any assignment, and it is an assignment precisely so that
# the one arm which must show the PRE-FIX behaviour can override it by naming
# GIT_NO_LAZY_FETCH=0 after the array (env applies assignments in order, so the
# later one wins).  That override appears exactly once, in the specimen-34
# raw-git evidence block, and it is labelled there.
# --------------------------------------------------------------------------
GIT_CLEAN_ENV=(-u GIT_DIR
               -u GIT_WORK_TREE
               -u GIT_COMMON_DIR
               -u GIT_OBJECT_DIRECTORY
               -u GIT_ALTERNATE_OBJECT_DIRECTORIES
               -u GIT_INDEX_FILE
               -u GIT_NAMESPACE
               -u GIT_CEILING_DIRECTORIES
               -u GIT_DISCOVERY_ACROSS_FILESYSTEM
               -u GIT_CONFIG
               -u GIT_CONFIG_GLOBAL
               -u GIT_CONFIG_SYSTEM
               -u GIT_NO_REPLACE_OBJECTS
               GIT_NO_LAZY_FETCH=1)

git_clean () {
  env "${GIT_CLEAN_ENV[@]}" git "$@"
}

FIXTURE_TIP="0000000000000000000000000000000000000000"
NONEXISTENT_TIP="dead0dead1dead2dead3dead4dead5dead6dead7"
# Specimen 18's tip.  It is 40 lowercase hexadecimal digits that name no object
# anywhere; the scratch fixture repository is given a refs/replace mapping FROM
# this name TO its one real commit, which is exactly the trick the R2 tip clause
# could not see.
REPLACED_TIP="beef0beef1beef2beef3beef4beef5beef6beef7"
RULE74="=========================================================================="

usage () {
  echo "usage: bash run-verifier-specimens.sh <output-directory> [--from <clean-transcript> --tip <parcel-tip> [--profile <name>]] [--prefix-verifier <earlier-verifier.sh>] [--r31-verifier <r31-era-verifier.sh>]" >&2
  exit 2
}

[ $# -ge 1 ] || usage
OUTDIR_ARG="$1"; shift
FROM=""
LIVE_TIP=""
LIVE_PROFILE="controls"   # the two-block profile specimen 1 is written against
SELF_TOOTH=0
PREFIX_VERIFY=""          # optional: an EARLIER verifier, run alongside the
                          # R3.1 specimens so the record shows what each defect
                          # did BEFORE the repair.  It is told the same profile,
                          # grammar and sequence files explicitly, because it
                          # would otherwise read whichever ones sit beside it.
R31_VERIFY=""             # optional, and a DIFFERENT prefix from the one above:
                          # specimen 34's defect is one the R3.1 verifier had, so
                          # its pre-fix arm must be measured against THAT text,
                          # not against the R3-era d385dde5 one.  Two eras, two
                          # flags; conflating them would file a reproduction
                          # against a verifier that never had the defect.
while [ $# -gt 0 ]; do
  case "$1" in
    --from)       [ $# -ge 2 ] || usage; FROM="$2"; shift 2 ;;
    --tip)        [ $# -ge 2 ] || usage; LIVE_TIP="$2"; shift 2 ;;
    --profile)    [ $# -ge 2 ] || usage; LIVE_PROFILE="$2"; shift 2 ;;
    --prefix-verifier) [ $# -ge 2 ] || usage; PREFIX_VERIFY="$2"; shift 2 ;;
    --r31-verifier)    [ $# -ge 2 ] || usage; R31_VERIFY="$2"; shift 2 ;;
    --self-tooth) SELF_TOOTH=1; shift ;;   # internal: marks a boundary-tooth child
    *) usage ;;
  esac
done
if [ -n "$FROM" ] && [ -z "$LIVE_TIP" ]; then
  echo "!! --from requires --tip: the verifier is told the tip, never shown it" >&2; exit 2
fi

# --------------------------------------------------------------------------
# THE OUTPUT-DIRECTORY BOUNDARY IS ENFORCED HERE TOO, AND BEFORE ANYTHING IS
# CREATED.  Under R1 this script simply `mkdir -p`ed whatever it was handed,
# while run-probe.sh next door refused the same path — one boundary, two
# answers.  The R2 law is one boundary: the intended physical path is resolved
# FIRST, with nonexistent components and `..` resolved LOGICALLY (which is what
# a mkdir -p would actually create), and a rejected path leaves NOTHING behind.
# --------------------------------------------------------------------------
WORKTREE="$(git_clean -C "$ROOT" rev-parse --show-toplevel 2>/dev/null || true)"
if [ -z "$WORKTREE" ]; then
  echo "!! FAIL CLOSED: cannot resolve the worktree root from $ROOT; the output-directory" >&2
  echo "   boundary cannot be enforced, so nothing is run." >&2
  exit 2
fi
WT_PHYS="$(cd "$WORKTREE" && pwd -P)"

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
      echo "   The worktree holds sources only.  Name a directory elsewhere." >&2
      exit 2 ;;
  esac
}

reject_if_inside_worktree "$(resolve_intended "$OUTDIR_ARG")"

mkdir -p "$OUTDIR_ARG" || { echo "!! cannot create $OUTDIR_ARG" >&2; exit 2; }
OUTDIR="$(cd "$OUTDIR_ARG" && pwd -P)"
reject_if_inside_worktree "$OUTDIR"

# A boundary-tooth child must never get this far: it is handed a rejected path
# and must die above.  If it does get here, the tooth itself is broken.
if [ "$SELF_TOOTH" -eq 1 ]; then
  echo "!! BOUNDARY TOOTH FAILED: a path that should have been refused was accepted: $OUTDIR" >&2
  exit 3
fi

FAILURES=0
note () { echo "$*"; }

is_r31 () { case "$R31_SPECIMENS" in *" $1 "*) return 0 ;; *) return 1 ;; esac; }

# Run the optional PRE-FIX verifier over one R3.1 specimen and require that it
# ACCEPTED the defect.  A reproduction that the earlier verifier already refused
# is not a reproduction, and saying so is the point of the arm.
prefix_arm () {   # <stem> <spec> <profile> <tip> <label> [env-assignment...] -- <tip-mode-args...>
  [ -n "$PREFIX_VERIFY" ] || return 0
  local stem="$1" spec="$2" prof="$3" ptip="$4" label="$5"; shift 5
  local envs=() rc
  while [ $# -gt 0 ] && [ "$1" != "--" ]; do envs+=("$1"); shift; done
  [ $# -gt 0 ] && shift
  env "${GIT_CLEAN_ENV[@]}" "${envs[@]+"${envs[@]}"}" bash "$PREFIX_VERIFY" "$spec" \
      --profile "$prof" --tip "$ptip" "$@" \
      --profiles "$HERE/verify-profiles.txt" \
      --grammar "$HERE/verify-grammar.txt" \
      --sequences "$HERE/verify-sequences.txt" \
      > "$stem.prefix.out" 2> "$stem.prefix.err"
  rc=$?
  echo "$rc" > "$stem.prefix.exit"
  if [ "$rc" -eq 0 ]; then
    note "      PRE-FIX (R3, d385dde5) exit=0 — the earlier verifier ACCEPTED this defect$label"
  else
    note "      !! PRE-FIX (R3, d385dde5) exit=$rc — the earlier verifier already refused this, so it is not a reproduced R3.1 defect"
    FAILURES=$((FAILURES + 1))
  fi
}

# --------------------------------------------------------------------------
# THE DEFECTS.  Each takes <base> <destination> and writes one crafted
# artifact.  They are pure text surgery: no specimen is hand-written from
# scratch, so each differs from an accepted transcript in exactly one way.
# --------------------------------------------------------------------------

defect_1_loss_of_last_block () {  # complete loss of the last section
  awk '{ print } /^CHILD-EXIT /{ exit }' "$1" > "$2"
}

defect_2_missing_final_child_exit () {
  awk 'NR==FNR { if ($0 ~ /^CHILD-EXIT /) last=NR; next }
       FNR != last { print }' "$1" "$1" > "$2"
}

defect_3_missing_closing_tip () {
  awk 'NR==FNR { if ($0 ~ /^PARCEL_TIP /) last=NR; next }
       FNR != last { print }' "$1" "$1" > "$2"
}

defect_4_pass_flipped_to_fail () {   # footer still says PROBE-SECTION-PASS
  awk '!done && /^  \[PASS\] / { sub(/^  \[PASS\] /, "  [FAIL] "); done=1 } { print }' "$1" > "$2"
}

defect_5_pass_end_name_disagreement () {
  awk '!done && /^PROBE-SECTION-PASS / { $2 = $2 "-DISAGREES"; done=1 } { print }' "$1" > "$2"
}

defect_6_incorrect_cases () {
  awk '!done && /^END-OF-TRANSCRIPT / {
         for (i = 1; i <= NF; i++)
           if ($i ~ /^CASES=/) { v = $i; sub(/^CASES=/, "", v); $i = "CASES=" (v + 1) }
         done = 1
       } { print }' "$1" > "$2"
}

defect_7_malformed_checks () {
  awk '!done && /^END-OF-TRANSCRIPT / {
         for (i = 1; i <= NF; i++)
           if ($i ~ /^CHECKS=/) { $i = "CHECKS=three" }
         done = 1
       } { print }' "$1" > "$2"
}

# ---- R2 -------------------------------------------------------------------

# 8. An INTACT SHELL whose body is gone and whose header is forged to agree.
#    Everything the R1 verifier looked at still agrees with everything else.
defect_8_hollow_last_block () {
  awk -v start="$LAST_BLOCK_START" '
    FNR < start { print; next }
    /^PARCEL_TIP /                  { print; next }
    /^VOLATILE /                    { print; next }
    /^OPERATION-CHECK /             { print; next }
    /^CHECKS [0-9]+   FAILURES /    { print "CHECKS 0   FAILURES 0   CASES 0"; next }
    /^    PARCEL_TIP /              { print; next }
    /^PROBE-SECTION-PASS /          { print; next }
    /^END-OF-TRANSCRIPT / {
      for (i = 1; i <= NF; i++) if ($i ~ /^CHECKS=/) $i = "CHECKS=0"
      print; next
    }
    /^={74}$/                       { print; next }
    /^CHILD-EXIT /                  { print; next }
    { next }
  ' "$1" > "$2"
}

# 9. The WHOLE S2 half of control 6 removed, and the header forged to the
#    count that remains.  A section that lost half its measurements while
#    still declaring a self-consistent total.
defect_9_s2_half_removed () {
  awk -v start="$LAST_BLOCK_START" -v forged="$FORGED_CHECKS" '
    FNR >= start && /^C6-PROVIDER S2$/     { cut = 1 }
    FNR >= start && /^END-C6-PROVIDER S2$/ { cut = 0; next }
    cut { next }
    FNR >= start && /^CHECKS [0-9]+   FAILURES / { printf("CHECKS %s   FAILURES 0   CASES 0\n", forged); next }
    FNR >= start && /^END-OF-TRANSCRIPT / {
      for (i = 1; i <= NF; i++) if ($i ~ /^CHECKS=/) $i = "CHECKS=" forged
      print; next
    }
    { print }
  ' "$1" > "$2"
}

# 10. Arbitrary material after END-OF-TRANSCRIPT, inside the same block.
defect_10_material_after_end () {
  awk 'NR==FNR { if ($0 ~ /^END-OF-TRANSCRIPT /) last=NR; next }
       { print }
       FNR == last { print "and then somebody wrote one more line" }' "$1" "$1" > "$2"
}

# 11. A [FAIL] verdict at an indentation the R1 pattern did not look at.  It is
#     INSERTED, not substituted, so no count and no ID moves: the ONLY thing
#     that can catch it is a verdict test that ignores indentation.
defect_11_reindented_fail () {
  awk '!done && /^  CHECK-ID / { print; print "    [FAIL] a re-indented verdict R1 could not see"; done=1; next }
       { print }' "$1" > "$2"
}

# 12. Every stamp rewritten to 40 lowercase hex digits that are not a commit.
defect_12_nonexistent_tip () {
  sed -e "s/[0-9a-f]\{40\}/$NONEXISTENT_TIP/g" "$1" > "$2"
}

# ---- R3 -------------------------------------------------------------------

# 15. A ONE-CHARACTER bracketed verdict.  The R2 pattern was
#     \[[A-Z][A-Z0-9_-][A-Z0-9_-]+\] — a first character plus two more — so it
#     could not see [X] (one) or [OK] (two).  Like specimen 11 this line is
#     INSERTED, not substituted, so no count and no ID moves: the only thing
#     that can catch it is a verdict test with no length floor.  [X] is used
#     because it is the extreme case; the [OK] evidence arm below covers the
#     two-character case for the same clause.
defect_15_short_bracketed_verdict () {
  awk '!done && /^  CHECK-ID / { print; print "    [X] a one-character verdict R2 could not see"; done=1; next }
       { print }' "$1" > "$2"
}

# 16. A terminator that is zero ONLY under numeric coercion.  Everything else
#     about the block is untouched and correct.
defect_16_child_exit_000 () {
  awk 'NR==FNR { if ($0 ~ /^CHILD-EXIT /) last=NR; next }
       FNR == last { print "CHILD-EXIT 000"; next }
       { print }' "$1" "$1" > "$2"
}

# 17. The last block announces 999 failures IN ITS OWN FOOTER while every
#     externally bound number — CASES, CHECKS, the [PASS] count, the ID stream
#     — still agrees exactly with the profile.  Under R2 nothing read this
#     number at all, so the section was accepted while confessing.
defect_17_footer_failures_999 () {
  awk -v start="$LAST_BLOCK_START" '
    FNR >= start && /^CHECKS [0-9]+   FAILURES [0-9]+   CASES [0-9]+$/ {
      printf("CHECKS %s   FAILURES 999   CASES %s\n", $2, $6); next
    }
    { print }' "$1" > "$2"
}

# 18. Every stamp rewritten to a name that exists NOWHERE.  It is presented
#     with the scratch repository built below, whose refs/replace maps that
#     name onto a real commit — so `rev-parse --verify <tip>^{commit}`, the R2
#     test, answers YES about an object that was never written.
defect_18_replaced_tip () {
  sed -e "s/[0-9a-f]\{40\}/$REPLACED_TIP/g" "$1" > "$2"
}

# ---- R3.1 ------------------------------------------------------------------
#
# FAMILY 1 — THE SECTION FOOTER (19-22).  Under R3 the footer was refused if it
# was present and lexically wrong, and that was all: it was never required,
# never counted, and its two numbers were never read.  All four of these were
# ACCEPTED by the R3 verifier at tip d385dde5.

# 19. The block simply has no footer at all.
defect_19_footer_missing () {
  awk '!done && /^CHECKS [0-9]+   FAILURES 0   CASES [0-9]+$/ { done=1; next } { print }' "$1" > "$2"
}

# 20. Two footers, both lexically perfect and in agreement with each other.
defect_20_footer_duplicate () {
  awk '!done && /^CHECKS [0-9]+   FAILURES 0   CASES [0-9]+$/ { print; done=1 } { print }' "$1" > "$2"
}

# 21. A footer whose CHECKS contradicts BOTH the external profile and the
#     block's own END-OF-TRANSCRIPT.  Nothing else in the block moves.
defect_21_footer_forged_checks () {
  awk '!done && /^CHECKS [0-9]+   FAILURES 0   CASES [0-9]+$/ {
         printf("CHECKS %d   FAILURES 0   CASES %s\n", $2 + 1, $6); done=1; next
       } { print }' "$1" > "$2"
}

# 22. The same, on CASES.
defect_22_footer_forged_cases () {
  awk '!done && /^CHECKS [0-9]+   FAILURES 0   CASES [0-9]+$/ {
         printf("CHECKS %s   FAILURES 0   CASES %d\n", $2, $6 + 1); done=1; next
       } { print }' "$1" > "$2"
}

# FAMILY 2 — THE IN-BODY TIP PAIR (23-26).  probe-header emits one stamp before
# the first ID-bearing assertion and probe-footer emits one after the section
# footer.  R3 checked the VALUE of whichever stamps it saw and required NONE, so
# a lost stamp and a doubled stamp were both invisible.

# 23. The header stamp of the pair is gone.
defect_23_tip_header_stamp_missing () {
  awk '!done && /^ {4}PARCEL_TIP / { done=1; next } { print }' "$1" > "$2"
}

# 24. The footer stamp of the pair — the one after the section footer — is gone.
defect_24_tip_footer_stamp_missing () {
  awk 'seenfoot && !done && /^ {4}PARCEL_TIP / { done=1; seenfoot=0; next }
       /^CHECKS [0-9]+   FAILURES 0   CASES [0-9]+$/ { seenfoot=1 }
       { print }' "$1" > "$2"
}

# 25. The header stamp is doubled.  Both copies carry the correct tip, so under
#     R3 there was nothing to see: two right answers to a question nobody asked
#     how many times.
defect_25_tip_header_stamp_duplicate () {
  awk '!done && /^ {4}PARCEL_TIP / { print; done=1 } { print }' "$1" > "$2"
}

# 26. The footer stamp is doubled.
defect_26_tip_footer_stamp_duplicate () {
  awk 'seenfoot && !done && /^ {4}PARCEL_TIP / { print; done=1; seenfoot=0 }
       /^CHECKS [0-9]+   FAILURES 0   CASES [0-9]+$/ { seenfoot=1 }
       { print }' "$1" > "$2"
}

# FAMILY 3 — HORIZONTAL-WHITESPACE IMPOSTORS (27-29).  Every RESERVED ERE in
# verify-grammar.txt is written with a LITERAL-SPACE prefix class (^ *CHECKS,
# ^ *END-OF-TRANSCRIPT, ^ *CHILD-EXIT).  A horizontal TAB is not a space, so a
# tab-prefixed structural token matched no production, matched no reserved
# token, and was then eaten by the NARRATIVE fallback ^ {0,3}[^ ].*$ — the tab
# itself satisfying [^ ].  Each of these three lines is INSERTED, so no count
# and no ID moves and the only thing that can catch it is a whitespace refusal
# taken BEFORE grammar dispatch.
insert_after_first_check_id () {   # <base> <dest> <line-to-insert>
  awk -v ins="$3" '!done && /^  CHECK-ID / { print; print ins; done=1; next }
                   { print }' "$1" > "$2"
}

defect_27_tab_prefixed_checks () {
  insert_after_first_check_id "$1" "$2" "$(printf '\tCHECKS 999   FAILURES 999   CASES 999')"
}

defect_28_tab_prefixed_end_of_transcript () {
  insert_after_first_check_id "$1" "$2" "$(printf '\tEND-OF-TRANSCRIPT FORGED CHECKS=0 CASES=0')"
}

defect_29_tab_prefixed_child_exit () {
  insert_after_first_check_id "$1" "$2" "$(printf '\tCHILD-EXIT 1')"
}

# FAMILY 4 — REPOSITORY SUBSTITUTION (30-33) is not text surgery: the artifact
# is honest and the ENVIRONMENT lies.  The transcript is rewritten to a commit
# that exists ONLY in a donor repository, and the verifier is then pointed at an
# innocent victim repository while an ambient variable — or the victim's own
# configured objects/info/alternates — quietly supplies the donor's object
# store.  `git -C <path>` does NOT override GIT_DIR, which is the whole defect.
defect_repo_substitution_tip () {   # <base> <dest> <donor-tip>
  sed -e "s/[0-9a-f]\{40\}/$3/g" "$1" > "$2"
}

# THE SCRATCH REPOSITORY FOR SPECIMEN 18.  Built inside the (already proven
# outside-the-worktree) output directory, from nothing, so that no real
# repository is ever handed a replace ref.  It holds exactly one real commit
# and one refs/replace mapping.
build_replace_fixture () {
  local dir="$1"
  rm -rf "$dir" || return 1
  mkdir -p "$dir" || return 1
  git_clean init --quiet -b main "$dir" >/dev/null 2>&1 || return 1
  git_clean -C "$dir" config user.email "probe@invalid" || return 1
  git_clean -C "$dir" config user.name  "surface-account-0 probe fixture" || return 1
  echo "one object that really exists" > "$dir/real.txt"
  git_clean -C "$dir" add real.txt || return 1
  env "${GIT_CLEAN_ENV[@]}" \
    GIT_AUTHOR_DATE="1970-01-01T00:00:00Z" GIT_COMMITTER_DATE="1970-01-01T00:00:00Z" \
    git -C "$dir" commit --quiet -m "the one real commit" || return 1
  REPLACE_FIXTURE_REAL="$(git_clean -C "$dir" rev-parse HEAD)" || return 1
  git_clean -C "$dir" update-ref "refs/replace/$REPLACED_TIP" "$REPLACE_FIXTURE_REAL" || return 1
  return 0
}

# THE THREE SCRATCH REPOSITORIES FOR FAMILY 4.  Built from nothing inside the
# (already proven outside-the-worktree) output directory, so that no real
# repository is ever handed an alternates file:
#
#   donor       holds a commit the victims do not hold;
#   victim      an innocent repository with its own single commit;
#   victim-alt  the same, plus a CONFIGURED objects/info/alternates pointing at
#               the donor, which is the one arm that needs no environment at all.
#
# Their contents differ, so their one commit each is a different object; the
# donor tip is therefore genuinely absent from both victims, which the control
# arm below measures rather than assumes.
build_substitution_fixtures () {
  local base="$1" r
  rm -rf "$base" || return 1
  mkdir -p "$base" || return 1
  for r in donor victim victim-alt; do
    git_clean init --quiet -b main "$base/$r" >/dev/null 2>&1 || return 1
    git_clean -C "$base/$r" config user.email "probe@invalid" || return 1
    git_clean -C "$base/$r" config user.name  "surface-account-0 probe fixture" || return 1
    printf 'the one object of the %s repository\n' "$r" > "$base/$r/only.txt"
    git_clean -C "$base/$r" add only.txt || return 1
    env "${GIT_CLEAN_ENV[@]}" \
      GIT_AUTHOR_DATE="1970-01-01T00:00:00Z" GIT_COMMITTER_DATE="1970-01-01T00:00:00Z" \
      git -C "$base/$r" commit --quiet -m "the one real commit of $r" || return 1
  done
  SUB_DONOR_TIP="$(git_clean -C "$base/donor" rev-parse HEAD)"   || return 1
  SUB_VICTIM_TIP="$(git_clean -C "$base/victim" rev-parse HEAD)" || return 1
  mkdir -p "$base/victim-alt/.git/objects/info" || return 1
  printf '%s\n' "$base/donor/.git/objects" > "$base/victim-alt/.git/objects/info/alternates" || return 1
  return 0
}

# --------------------------------------------------------------------------
# THE R3.2 PROMISOR FIXTURE (specimen 34).
#
# A PARTIAL CLONE is a repository that holds SOME of its objects and names a
# PROMISOR REMOTE it may go and get the rest from.  Ask such a repository
# whether it holds an object it does not hold, and Git may answer by FETCHING
# it — importing the object and then reporting success.  The R3.1 verifier's
# existence step therefore proved "this repository can obtain the tip", while
# the sentence it printed said "physically present as a commit".
#
# NO NETWORK IS INVOLVED AND NONE IS PERMITTED.  The promisor remote is a
# LOCAL DIRECTORY built here, inside the (already proven outside-the-worktree)
# output directory, so the whole defect is exhibited on this filesystem.
#
# EACH ARM GETS ITS OWN FRESH EMPTY PARTIAL REPOSITORY, and that is not tidiness
# — a lazy fetch IMPORTS the object, so a repository that has answered once now
# genuinely holds the tip and every later question about it is a different
# question.  A shared fixture would make the second arm meaningless and, worse,
# would make it PASS for the wrong reason.
#
# The repository is created with NO objects of its own: it is `git init`, four
# config keys and a remote.  Whatever it answers about the donor tip, it
# answers by fetching.
# The promisor remote itself: one ordinary repository with one real commit, in
# its own directory, built from nothing.  It is kept separate from family 4's
# donor so that neither family can quietly borrow the other's state.
build_substitution_fixtures_donor_only () {   # <path>
  local dir="$1"
  rm -rf "$dir" || return 1
  git_clean init --quiet -b main "$dir" >/dev/null 2>&1 || return 1
  git_clean -C "$dir" config user.email "probe@invalid" || return 1
  git_clean -C "$dir" config user.name  "surface-account-0 probe fixture" || return 1
  printf 'the one object of the promisor remote\n' > "$dir/only.txt" || return 1
  git_clean -C "$dir" add only.txt || return 1
  env "${GIT_CLEAN_ENV[@]}" \
    GIT_AUTHOR_DATE="1970-01-01T00:00:00Z" GIT_COMMITTER_DATE="1970-01-01T00:00:00Z" \
    git -C "$dir" commit --quiet -m "the one real commit of the promisor remote" || return 1
  PROMISOR_DONOR_TIP="$(git_clean -C "$dir" rev-parse HEAD)" || return 1
  return 0
}

build_promisor_partial () {   # <path> <promisor-remote-path>
  local dir="$1" remote="$2"
  rm -rf "$dir" || return 1
  git_clean init --quiet -b main "$dir" >/dev/null 2>&1 || return 1
  git_clean -C "$dir" config user.email "probe@invalid"            || return 1
  git_clean -C "$dir" config user.name  "surface-account-0 probe fixture" || return 1
  # repositoryformatversion 1 is what makes `extensions.*` legible to Git at
  # all; the three remote keys are exactly what a `clone --filter` writes.
  git_clean -C "$dir" config core.repositoryformatversion 1        || return 1
  git_clean -C "$dir" config extensions.partialClone origin        || return 1
  git_clean -C "$dir" remote add origin "$remote"                  || return 1
  git_clean -C "$dir" config remote.origin.promisor true           || return 1
  git_clean -C "$dir" config remote.origin.partialclonefilter blob:none || return 1
  return 0
}

# The control's counterpart: a repository configured EXACTLY like the one above
# — same promisor remote, same extension — which nevertheless HOLDS ITS OWN
# COMMIT locally.  Disabling lazy fetch must not refuse this one, or the repair
# would be "refuse partial clones" rather than "refuse imported existence".
build_promisor_holder () {   # <path> <promisor-remote-path>
  local dir="$1" remote="$2"
  build_promisor_partial "$dir" "$remote" || return 1
  printf 'the one object this partial clone really holds\n' > "$dir/held.txt" || return 1
  git_clean -C "$dir" add held.txt || return 1
  env "${GIT_CLEAN_ENV[@]}" \
    GIT_AUTHOR_DATE="1970-01-01T00:00:00Z" GIT_COMMITTER_DATE="1970-01-01T00:00:00Z" \
    git -C "$dir" commit --quiet -m "the one commit this partial clone holds itself" || return 1
  PROMISOR_HOLDER_TIP="$(git_clean -C "$dir" rev-parse HEAD)" || return 1
  return 0
}

# How many loose/packed object files a repository physically holds.  Printed
# before and after each arm, because "it did not hold it, then it did" is the
# defect stated as a number rather than as an adjective.
promisor_object_count () {   # <repo>
  find "$1/.git/objects" -type f 2>/dev/null | grep -cv '/info/' || true
}

SPECIMENS="1:loss-of-last-block:defect_1_loss_of_last_block
2:missing-final-child-exit:defect_2_missing_final_child_exit
3:missing-closing-tip:defect_3_missing_closing_tip
4:pass-flipped-to-fail:defect_4_pass_flipped_to_fail
5:pass-end-name-disagreement:defect_5_pass_end_name_disagreement
6:incorrect-cases:defect_6_incorrect_cases
7:malformed-checks:defect_7_malformed_checks
8:hollow-last-block-checks-zero:defect_8_hollow_last_block
9:s2-half-removed-checks-forged:defect_9_s2_half_removed
10:material-after-end-of-transcript:defect_10_material_after_end
11:reindented-fail-verdict:defect_11_reindented_fail
15:short-bracketed-verdict:defect_15_short_bracketed_verdict
16:child-exit-000:defect_16_child_exit_000
17:footer-failures-999:defect_17_footer_failures_999
19:footer-missing:defect_19_footer_missing
20:footer-duplicate:defect_20_footer_duplicate
21:footer-forged-checks:defect_21_footer_forged_checks
22:footer-forged-cases:defect_22_footer_forged_cases
23:tip-header-stamp-missing:defect_23_tip_header_stamp_missing
24:tip-footer-stamp-missing:defect_24_tip_footer_stamp_missing
25:tip-header-stamp-duplicate:defect_25_tip_header_stamp_duplicate
26:tip-footer-stamp-duplicate:defect_26_tip_footer_stamp_duplicate
27:tab-prefixed-checks:defect_27_tab_prefixed_checks
28:tab-prefixed-end-of-transcript:defect_28_tab_prefixed_end_of_transcript
29:tab-prefixed-child-exit:defect_29_tab_prefixed_child_exit"

# The R3.1 specimens, named so the runner can ask the PRE-FIX verifier about
# exactly these and record what it did with them.
R31_SPECIMENS=" 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 "

# --------------------------------------------------------------------------
# run_suite <suite-name> <base-file> <profile> <tip> <tip-mode-args...>
#   TIPMODE is either "--fixture-tip" or "--repo <dir>".
# --------------------------------------------------------------------------
run_suite () {
  local suite="$1" base="$2" profile="$3" tip="$4" forged="$5"; shift 5
  local tipmode=("$@")
  local dir="$OUTDIR/$suite"
  mkdir -p "$dir"
  cp "$base" "$dir/base-accepted.txt"

  # Where the LAST child block begins: the line after the penultimate
  # CHILD-EXIT.  Specimens 8 and 9 operate on that block alone.
  LAST_BLOCK_START="$(awk '/^CHILD-EXIT /{ n++; at[n] = NR } END { print (n >= 2 ? at[n-1] + 1 : 1) }' "$base")"
  FORGED_CHECKS="$forged"

  note ""
  note "== SUITE $suite  (profile=$profile tip=$tip ${tipmode[*]}) =="
  note "   last block starts at line $LAST_BLOCK_START; specimen 9 forges CHECKS=$FORGED_CHECKS"

  # ---- CONTROL ARM: the untouched base MUST be accepted ----
  bash "$VERIFY" "$dir/base-accepted.txt" --profile "$profile" --tip "$tip" "${tipmode[@]}" \
       > "$dir/base-accepted.out" 2> "$dir/base-accepted.err"
  local brc=$?
  echo "$brc" > "$dir/base-accepted.exit"
  if [ "$brc" -eq 0 ]; then
    note "   CONTROL ARM   base ACCEPTED (exit 0) — the specimens below mean something"
  else
    note "   !! CONTROL ARM FAILED: the untouched base was REFUSED (exit $brc)."
    note "      $(cat "$dir/base-accepted.err")"
    FAILURES=$((FAILURES + 1))
  fi

  local line num name fn spec rc rest
  while IFS= read -r line; do
    num="${line%%:*}"; rest="${line#*:}"
    name="${rest%%:*}"; fn="${rest#*:}"
    spec="$dir/specimen-$num-$name.txt"
    "$fn" "$base" "$spec"
    if cmp -s "$base" "$spec"; then
      note "   !! specimen $num ($name) is IDENTICAL to the base — the defect was not planted"
      FAILURES=$((FAILURES + 1))
    fi
    bash "$VERIFY" "$spec" --profile "$profile" --tip "$tip" "${tipmode[@]}" \
         > "$dir/specimen-$num-$name.out" 2> "$dir/specimen-$num-$name.err"
    rc=$?
    echo "$rc" > "$dir/specimen-$num-$name.exit"
    if [ "$rc" -ne 0 ]; then
      note "   specimen $num  $name"
      note "      REFUSED exit=$rc  $(head -1 "$dir/specimen-$num-$name.err")"
    else
      note "   !! specimen $num  $name  WAS ACCEPTED (exit 0) — the verifier has a hole"
      FAILURES=$((FAILURES + 1))
    fi
    if is_r31 "$num"; then
      prefix_arm "$dir/specimen-$num-$name" "$spec" "$profile" "$tip" "" -- "${tipmode[@]}"
    fi
  done <<< "$SPECIMENS"

  # ---- specimen 12: a syntactically perfect tip that is not a commit -------
  # This one is a TIP tooth, so it is always presented with a real repository:
  # the point is precisely that the shape passes and the RESOLUTION fails.
  local spec12="$dir/specimen-12-nonexistent-git-tip.txt"
  defect_12_nonexistent_tip "$base" "$spec12"
  bash "$VERIFY" "$spec12" --profile "$profile" --tip "$NONEXISTENT_TIP" --repo "$ROOT" \
       > "$dir/specimen-12-nonexistent-git-tip.out" 2> "$dir/specimen-12-nonexistent-git-tip.err"
  rc=$?
  echo "$rc" > "$dir/specimen-12-nonexistent-git-tip.exit"
  if [ "$rc" -ne 0 ]; then
    note "   specimen 12  nonexistent-git-tip"
    note "      REFUSED exit=$rc  $(head -1 "$dir/specimen-12-nonexistent-git-tip.err")"
  else
    note "   !! specimen 12  nonexistent-git-tip  WAS ACCEPTED (exit 0) — the verifier has a hole"
    FAILURES=$((FAILURES + 1))
  fi

  # ---- and the fixture tip outside its fixture mode ------------------------
  # Evidence for the same clause, not a fifteenth specimen: the all-zero tip is
  # a FIXTURE and may not be presented as a real tested tip.
  bash "$VERIFY" "$dir/base-accepted.txt" --profile "$profile" --tip "$FIXTURE_TIP" --repo "$ROOT" \
       > "$dir/evidence-zero-tip-without-fixture-mode.out" 2> "$dir/evidence-zero-tip-without-fixture-mode.err"
  rc=$?
  echo "$rc" > "$dir/evidence-zero-tip-without-fixture-mode.exit"
  if [ "$rc" -ne 0 ]; then
    note "   evidence      the all-zero fixture tip OUTSIDE --fixture-tip: REFUSED exit=$rc"
  else
    note "   !! the all-zero fixture tip was accepted as a real tip — the fixture mode is not a mode"
    FAILURES=$((FAILURES + 1))
  fi

  # ---- evidence for the same clause as specimen 15: the TWO-character form --
  # Not a nineteenth specimen.  Specimen 15 plants [X]; the R3 law names [OK]
  # too, and the R2 pattern missed both, so the two-character case is shown
  # here as evidence rather than counted twice.
  local ok_spec="$dir/evidence-two-character-bracketed-verdict.txt"
  awk '!done && /^  CHECK-ID / { print; print "    [OK] a two-character verdict R2 could not see"; done=1; next }
       { print }' "$base" > "$ok_spec"
  bash "$VERIFY" "$ok_spec" --profile "$profile" --tip "$tip" "${tipmode[@]}" \
       > "$dir/evidence-two-character-bracketed-verdict.out" 2> "$dir/evidence-two-character-bracketed-verdict.err"
  rc=$?
  echo "$rc" > "$dir/evidence-two-character-bracketed-verdict.exit"
  if [ "$rc" -ne 0 ]; then
    note "   evidence      the two-character verdict [OK]: REFUSED exit=$rc"
  else
    note "   !! the two-character verdict [OK] was ACCEPTED — the length floor is still there"
    FAILURES=$((FAILURES + 1))
  fi

  # ---- specimen 18: a tip that names no object, lent one by refs/replace ----
  # THE FIXTURE IS BUILT FROM NOTHING, inside the output directory, so that no
  # real repository is ever handed a replace ref.  Three arms, and the order
  # matters: the RAW GIT arms first (they show what the R2 clause was actually
  # asking and what the R3 clause asks instead), then the CONTROL arm (the
  # fixture repository's own real commit must be ACCEPTED, or a refusal below
  # would prove only that the fixture is broken), then the specimen.
  local fixrepo="$dir/replace-fixture-repo"
  REPLACE_FIXTURE_REAL=""
  if ! build_replace_fixture "$fixrepo" > "$dir/replace-fixture-build.log" 2>&1; then
    note "   !! specimen 18: the refs/replace fixture repository could not be built"
    FAILURES=$((FAILURES + 1))
  else
    {
      echo "fixture repository : $fixrepo"
      echo "real commit        : $REPLACE_FIXTURE_REAL"
      echo "fabricated tip     : $REPLACED_TIP  (no object of this name was ever written)"
      echo
      # Every arm below runs from the SAME cleared ambient environment, so the
      # comparison is between the two CLAUSES and not between two environments.
      git_clean -C "$fixrepo" for-each-ref refs/replace
      echo
      echo "-- the R2 clause: git rev-parse --verify --quiet <tip>^{commit} --"
      git_clean -C "$fixrepo" rev-parse --verify --quiet "${REPLACED_TIP}^{commit}"
      echo "   exit=$?   (0 here is the defect: the replacement lens answered for an object that does not exist)"
      echo
      echo "-- the R3 clause: git --no-replace-objects cat-file -e <tip> --"
      env "${GIT_CLEAN_ENV[@]}" GIT_NO_REPLACE_OBJECTS=1 \
        git --no-replace-objects -C "$fixrepo" cat-file -e "$REPLACED_TIP" 2>&1
      echo "   exit=$?   (nonzero is the repair: no object of that name is physically held)"
    } > "$dir/evidence-replace-lens-raw-git.txt" 2>&1
    note "   evidence      raw-git replace-lens comparison written to evidence-replace-lens-raw-git.txt"

    # CONTROL: the fixture repository's own real commit must be ACCEPTED.
    local realspec="$dir/evidence-replace-fixture-real-tip.txt"
    sed -e "s/[0-9a-f]\{40\}/$REPLACE_FIXTURE_REAL/g" "$base" > "$realspec"
    bash "$VERIFY" "$realspec" --profile "$profile" --tip "$REPLACE_FIXTURE_REAL" --repo "$fixrepo" \
         > "$dir/evidence-replace-fixture-real-tip.out" 2> "$dir/evidence-replace-fixture-real-tip.err"
    rc=$?
    echo "$rc" > "$dir/evidence-replace-fixture-real-tip.exit"
    if [ "$rc" -eq 0 ]; then
      note "   control       the fixture repository's OWN real commit: ACCEPTED (so specimen 18's refusal is about the replace lens, not about a broken fixture)"
    else
      note "   !! the fixture repository's own real commit was REFUSED (exit $rc) — specimen 18 would prove nothing"
      FAILURES=$((FAILURES + 1))
    fi

    local spec18="$dir/specimen-18-tip-through-refs-replace.txt"
    defect_18_replaced_tip "$base" "$spec18"
    bash "$VERIFY" "$spec18" --profile "$profile" --tip "$REPLACED_TIP" --repo "$fixrepo" \
         > "$dir/specimen-18-tip-through-refs-replace.out" 2> "$dir/specimen-18-tip-through-refs-replace.err"
    rc=$?
    echo "$rc" > "$dir/specimen-18-tip-through-refs-replace.exit"
    if [ "$rc" -ne 0 ]; then
      note "   specimen 18  tip-through-refs-replace"
      note "      REFUSED exit=$rc  $(head -1 "$dir/specimen-18-tip-through-refs-replace.err")"
    else
      note "   !! specimen 18  tip-through-refs-replace  WAS ACCEPTED (exit 0) — refs/replace still lends a fabricated name a real commit"
      FAILURES=$((FAILURES + 1))
    fi
  fi

  # ---- FAMILY 4 (30-33): REPOSITORY SUBSTITUTION ---------------------------
  # These four are not text surgery.  The artifact is honest — every stamp
  # carries the donor tip and the verifier is TOLD that tip — and the lie is in
  # the environment: `git -C <victim>` does not override an ambient GIT_DIR, and
  # GIT_OBJECT_DIRECTORY, GIT_ALTERNATE_OBJECT_DIRECTORIES and a configured
  # objects/info/alternates do the same thing one level down, at the object
  # store.  So the R3 clause proved "some store this process can reach holds the
  # commit", never "the repository you named holds it".
  local subdir="$dir/substitution-fixtures"
  SUB_DONOR_TIP=""; SUB_VICTIM_TIP=""
  if ! build_substitution_fixtures "$subdir" > "$dir/substitution-fixture-build.log" 2>&1; then
    note "   !! family 4 (30-33): the substitution fixture repositories could not be built"
    FAILURES=$((FAILURES + 1))
  else
    local donor="$subdir/donor" victim="$subdir/victim" victimalt="$subdir/victim-alt"
    local donorobj="$subdir/donor/.git/objects"
    local donorspec="$dir/specimen-30-33-donor-tip-transcript.txt"
    defect_repo_substitution_tip "$base" "$donorspec" "$SUB_DONOR_TIP"
    local victimspec="$dir/evidence-substitution-victim-own-tip-transcript.txt"
    defect_repo_substitution_tip "$base" "$victimspec" "$SUB_VICTIM_TIP"

    {
      echo "donor  repository : $donor"
      echo "donor  tip        : $SUB_DONOR_TIP"
      echo "victim repository : $victim"
      echo "victim tip        : $SUB_VICTIM_TIP"
      echo "victim-alt        : $victimalt  (configured objects/info/alternates -> $donorobj)"
      echo
      # THE CLEAN BASE IS THE WHOLE SET, not the three variables R3.1 happened
      # to name here: each arm below starts from every ambient selector removed
      # and then sets exactly ONE on purpose, so the arm measures that variable
      # and not the caller's shell.
      echo "-- is the donor tip physically present in the victim?  (clean environment) --"
      git_clean -C "$victim" cat-file -e "$SUB_DONOR_TIP" 2>&1
      echo "   exit=$?   (nonzero is the ground truth: the victim does not hold it)"
      echo
      echo "-- the R3 clause with an ambient GIT_DIR: git -C <victim> cat-file -e <donor tip> --"
      env "${GIT_CLEAN_ENV[@]}" GIT_DIR="$donor/.git" \
        git -C "$victim" cat-file -e "$SUB_DONOR_TIP" 2>&1
      echo "   exit=$?   (0 here is the defect: -C named the victim and GIT_DIR answered for the donor)"
      echo
      echo "-- the same with GIT_OBJECT_DIRECTORY --"
      env "${GIT_CLEAN_ENV[@]}" GIT_OBJECT_DIRECTORY="$donorobj" \
        git -C "$victim" cat-file -e "$SUB_DONOR_TIP" 2>&1
      echo "   exit=$?"
      echo
      echo "-- the same with GIT_ALTERNATE_OBJECT_DIRECTORIES --"
      env "${GIT_CLEAN_ENV[@]}" GIT_ALTERNATE_OBJECT_DIRECTORIES="$donorobj" \
        git -C "$victim" cat-file -e "$SUB_DONOR_TIP" 2>&1
      echo "   exit=$?"
      echo
      echo "-- and with no environment at all, through victim-alt's configured alternates --"
      git_clean -C "$victimalt" cat-file -e "$SUB_DONOR_TIP" 2>&1
      echo "   exit=$?   (0 here is the defect: the file, not the environment, lent the object)"
    } > "$dir/evidence-git-environment-raw-git.txt" 2>&1
    note "   evidence      raw-git environment comparison written to evidence-git-environment-raw-git.txt"

    # CONTROL A.  The donor tip against the victim in a CLEAN environment must
    # be REFUSED — otherwise the four arms below would prove nothing about the
    # environment, only that the tip is bad.
    env "${GIT_CLEAN_ENV[@]}" \
      bash "$VERIFY" "$donorspec" --profile "$profile" --tip "$SUB_DONOR_TIP" --repo "$victim" \
      > "$dir/control-substitution-clean-environment.out" 2> "$dir/control-substitution-clean-environment.err"
    rc=$?
    echo "$rc" > "$dir/control-substitution-clean-environment.exit"
    if [ "$rc" -ne 0 ]; then
      note "   control       the donor tip against the victim in a CLEAN environment: REFUSED exit=$rc (so 30-33 measure the environment, not a bad tip)"
    else
      note "   !! the donor tip was accepted against the victim with NO hostile environment — the fixture is broken"
      FAILURES=$((FAILURES + 1))
    fi

    # CONTROL B.  The victim's OWN tip, with every hostile variable set at once,
    # must still be ACCEPTED — clearing the environment must not simply break
    # every honest call.
    GIT_DIR="$donor/.git" GIT_WORK_TREE="$donor" \
    GIT_OBJECT_DIRECTORY="$donorobj" GIT_ALTERNATE_OBJECT_DIRECTORIES="$donorobj" \
    GIT_INDEX_FILE="$donor/.git/index" GIT_NAMESPACE="probe" \
      bash "$VERIFY" "$victimspec" --profile "$profile" --tip "$SUB_VICTIM_TIP" --repo "$victim" \
      > "$dir/control-substitution-honest-under-hostile-env.out" 2> "$dir/control-substitution-honest-under-hostile-env.err"
    rc=$?
    echo "$rc" > "$dir/control-substitution-honest-under-hostile-env.exit"
    if [ "$rc" -eq 0 ]; then
      note "   control       the victim's OWN tip under all six hostile variables at once: ACCEPTED (the clearing does not break honest calls)"
    else
      note "   !! the victim's own tip was REFUSED under the hostile environment (exit $rc) — the clearing is too broad"
      FAILURES=$((FAILURES + 1))
    fi

    # THE FOUR ARMS.
    run_env_arm () {   # <num> <name> <spec> <tip> <repo> [env-assignment...]
      local anum="$1" aname="$2" aspec="$3" atip="$4" arepo="$5"; shift 5
      local stem="$dir/specimen-$anum-$aname" arc
      if [ $# -gt 0 ]; then printf '%s\n' "$@" > "$stem.env"; else echo "(no environment; the repository config lies)" > "$stem.env"; fi
      # Cleared base, then exactly the arm's own declared assignments: the arm
      # measures the variable it names, never one the caller's shell exported.
      env "${GIT_CLEAN_ENV[@]}" "$@" bash "$VERIFY" "$aspec" --profile "$profile" --tip "$atip" --repo "$arepo" \
          > "$stem.out" 2> "$stem.err"
      arc=$?
      echo "$arc" > "$stem.exit"
      if [ "$arc" -ne 0 ]; then
        note "   specimen $anum  $aname"
        note "      REFUSED exit=$arc  $(head -1 "$stem.err")"
      else
        note "   !! specimen $anum  $aname  WAS ACCEPTED (exit 0) — the named repository is still not the one consulted"
        FAILURES=$((FAILURES + 1))
      fi
      prefix_arm "$stem" "$aspec" "$profile" "$atip" "" "$@" -- --repo "$arepo"
    }

    run_env_arm 30 ambient-git-dir                        "$donorspec" "$SUB_DONOR_TIP" "$victim"    "GIT_DIR=$donor/.git"
    run_env_arm 31 ambient-git-object-directory           "$donorspec" "$SUB_DONOR_TIP" "$victim"    "GIT_OBJECT_DIRECTORY=$donorobj"
    run_env_arm 32 ambient-git-alternate-object-dirs      "$donorspec" "$SUB_DONOR_TIP" "$victim"    "GIT_ALTERNATE_OBJECT_DIRECTORIES=$donorobj"
    run_env_arm 33 configured-object-alternates           "$donorspec" "$SUB_DONOR_TIP" "$victimalt"

    # ---- SPECIMEN 34 (R3.2): THE PROMISOR IMPORT ---------------------------
    # The artifact is honest, the environment is clean, the repository config
    # is not a lie either — the repository simply DOES NOT HOLD the tip and is
    # willing to go and get it.  This is the fifth family and the first in
    # which the defect is neither in the transcript nor in the caller's shell.
    #
    # ORDER MATTERS AND IS DELIBERATE: the PRE-FIX arm runs FIRST, on its own
    # fresh repository, because it is the arm that imports.  Every later arm
    # gets a repository of its own that has never answered a question.
    local prodir="$dir/promisor-fixtures"
    rm -rf "$prodir"; mkdir -p "$prodir"
    PROMISOR_HOLDER_TIP=""
    local prodonor="$prodir/promisor-donor"
    if ! build_substitution_fixtures_donor_only "$prodonor" > "$dir/promisor-fixture-build.log" 2>&1; then
      note "   !! specimen 34: the promisor donor repository could not be built"
      FAILURES=$((FAILURES + 1))
    else
      local protip="$PROMISOR_DONOR_TIP"
      local prospec="$dir/specimen-34-promisor-lazy-fetch.txt"
      defect_repo_substitution_tip "$base" "$prospec" "$protip"

      # (a) THE PRE-FIX ARM.  The R3.1-era verifier, on a fresh empty partial
      #     clone, must ACCEPT — that is the reproduction, and without it the
      #     refusal below would only show that this verifier refuses something.
      #     GIT_NO_LAZY_FETCH=0 is set explicitly: the harness now imposes =1 on
      #     everything it starts, and an inherited =1 would silently repair the
      #     verifier under test.  Saying so here is the point of the arm.
      local prestem="$dir/specimen-34-promisor-lazy-fetch.prefix-r31"
      if [ -n "$R31_VERIFY" ]; then
        local prepartial="$prodir/partial-prefix"
        if build_promisor_partial "$prepartial" "$prodonor" > "$prestem.build.log" 2>&1; then
          local before after prc
          before="$(promisor_object_count "$prepartial")"
          env "${GIT_CLEAN_ENV[@]}" GIT_NO_LAZY_FETCH=0 \
            bash "$R31_VERIFY" "$prospec" --profile "$profile" --tip "$protip" --repo "$prepartial" \
            --profiles "$HERE/verify-profiles.txt" \
            --grammar "$HERE/verify-grammar.txt" \
            --sequences "$HERE/verify-sequences.txt" \
            > "$prestem.out" 2> "$prestem.err"
          prc=$?
          echo "$prc" > "$prestem.exit"
          after="$(promisor_object_count "$prepartial")"
          { echo "r31 verifier      : $R31_VERIFY"
            echo "r31 verifier md5  : $(md5sum "$R31_VERIFY" | awk '{print $1}')"
            echo "partial clone     : $prepartial"
            echo "promisor remote   : $prodonor"
            echo "donor tip         : $protip"
            echo "object files BEFORE: $before"
            echo "object files AFTER : $after"
            echo "exit              : $prc"
          } > "$prestem.evidence.txt"
          if [ "$prc" -eq 0 ]; then
            note "   specimen 34  promisor-lazy-fetch"
            note "      PRE-FIX (R3.1, extracted, md5 $(md5sum "$R31_VERIFY" | awk '{print $1}')) exit=0 — the R3.1 verifier ACCEPTED a tip the repository did not hold; its object files went $before -> $after, so it IMPORTED what it then called physically present"
          else
            note "   !! PRE-FIX (R3.1) exit=$prc — the extracted verifier already refused this, so specimen 34 is not a reproduced R3.1 defect"
            FAILURES=$((FAILURES + 1))
          fi
        else
          note "   !! specimen 34: the pre-fix partial clone could not be built"
          FAILURES=$((FAILURES + 1))
        fi
      else
        note "   specimen 34  (no --r31-verifier given: the PRE-FIX acceptance was not measured this run)"
      fi

      # (b) RAW GIT, both policies, on two fresh repositories — the mechanism
      #     itself, beneath any verifier.
      local rawa="$prodir/partial-raw-lazy" rawb="$prodir/partial-raw-nolazy"
      {
        echo "promisor remote (a local directory; no network is used) : $prodonor"
        echo "donor tip                                               : $protip"
        echo
        if build_promisor_partial "$rawa" "$prodonor" >/dev/null 2>&1; then
          echo "-- a FRESH partial clone, lazy fetching ALLOWED (the R3.1 policy) --"
          echo "   object files before: $(promisor_object_count "$rawa")"
          env "${GIT_CLEAN_ENV[@]}" GIT_NO_LAZY_FETCH=0 \
            git --no-replace-objects -C "$rawa" cat-file -e "$protip" 2>&1
          echo "   exit=$?   (0 here is the defect: the object was FETCHED, not found)"
          echo "   object files after : $(promisor_object_count "$rawa")   (the import, counted)"
        fi
        echo
        if build_promisor_partial "$rawb" "$prodonor" >/dev/null 2>&1; then
          echo "-- a FRESH partial clone, GIT_NO_LAZY_FETCH=1 (the R3.2 policy) --"
          echo "   object files before: $(promisor_object_count "$rawb")"
          env "${GIT_CLEAN_ENV[@]}" \
            git --no-replace-objects -C "$rawb" cat-file -e "$protip" 2>&1
          echo "   exit=$?   (nonzero is the repair: absence is reported as absence)"
          echo "   object files after : $(promisor_object_count "$rawb")   (nothing was imported)"
        fi
      } > "$dir/evidence-promisor-raw-git.txt" 2>&1
      note "   evidence      raw-git promisor comparison written to evidence-promisor-raw-git.txt"

      # (c) THE CONTROL.  A repository configured EXACTLY as a partial clone,
      #     which HOLDS its own commit, must still be ACCEPTED — otherwise the
      #     refusal below would be "partial clones are refused", a different and
      #     much cruder law than the one ruled.
      local holder="$prodir/partial-holder"
      if build_promisor_holder "$holder" "$prodonor" > "$dir/promisor-holder-build.log" 2>&1; then
        local holdspec="$dir/evidence-promisor-holder-own-tip-transcript.txt"
        defect_repo_substitution_tip "$base" "$holdspec" "$PROMISOR_HOLDER_TIP"
        bash "$VERIFY" "$holdspec" --profile "$profile" --tip "$PROMISOR_HOLDER_TIP" --repo "$holder" \
             > "$dir/control-promisor-holder-own-tip.out" 2> "$dir/control-promisor-holder-own-tip.err"
        rc=$?
        echo "$rc" > "$dir/control-promisor-holder-own-tip.exit"
        if [ "$rc" -eq 0 ]; then
          note "   control       a PARTIAL CLONE holding its OWN commit: ACCEPTED (so specimen 34 refuses imported existence, not partial clones)"
        else
          note "   !! a partial clone holding its own commit was REFUSED (exit $rc) — the lazy-fetch clause is too broad"
          FAILURES=$((FAILURES + 1))
        fi
      else
        note "   !! specimen 34: the holder control repository could not be built"
        FAILURES=$((FAILURES + 1))
      fi

      # (d) THE SPECIMEN.  A fresh partial clone that has answered nothing.
      local specpartial="$prodir/partial-specimen"
      if build_promisor_partial "$specpartial" "$prodonor" > "$dir/promisor-specimen-build.log" 2>&1; then
        local sbefore safter
        sbefore="$(promisor_object_count "$specpartial")"
        bash "$VERIFY" "$prospec" --profile "$profile" --tip "$protip" --repo "$specpartial" \
             > "$dir/specimen-34-promisor-lazy-fetch.out" 2> "$dir/specimen-34-promisor-lazy-fetch.err"
        rc=$?
        echo "$rc" > "$dir/specimen-34-promisor-lazy-fetch.exit"
        safter="$(promisor_object_count "$specpartial")"
        printf 'object files before: %s\nobject files after : %s\n' "$sbefore" "$safter" \
          > "$dir/specimen-34-promisor-lazy-fetch.objects"
        if [ "$rc" -ne 0 ] && [ "$sbefore" = "$safter" ]; then
          note "   specimen 34  promisor-lazy-fetch"
          note "      REFUSED exit=$rc, and nothing was imported ($sbefore -> $safter object files)  $(head -1 "$dir/specimen-34-promisor-lazy-fetch.err")"
        else
          [ "$rc" -eq 0 ] && note "   !! specimen 34  promisor-lazy-fetch  WAS ACCEPTED (exit 0) — a tip the repository does not hold is still being imported and called present"
          [ "$sbefore" != "$safter" ] && note "   !! specimen 34 left an IMPORT behind ($sbefore -> $safter object files) — the refusal happened after a fetch"
          FAILURES=$((FAILURES + 1))
        fi
      else
        note "   !! specimen 34: the specimen partial clone could not be built"
        FAILURES=$((FAILURES + 1))
      fi
    fi
  fi
}

# --------------------------------------------------------------------------
# THE SYNTHETIC BASE.  Two child blocks carrying the closed grammar's shapes —
# CHECK-ID lines paired one-to-one with verdicts, the C6-PROVIDER anchors
# specimen 9 needs, and the declared separator before each closing stamp —
# under section names of their own (SYN-CONTROLS-A / SYN-CONTROLS-B) with their
# own profile and their own declared ID sequences.  The names are deliberately
# distinct so that no synthetic sequence can ever stand in for a real one.
#
# ITS TIP IS THE ALL-ZERO FIXTURE TIP.  That string is not a Git object, is not
# a real tested tip of anything, and is accepted only under the verifier's
# explicit --fixture-tip mode; the evidence arm above shows it being refused
# the moment that mode is absent.
# --------------------------------------------------------------------------
SYN="$OUTDIR/synthetic-base.txt"
cat > "$SYN" <<EOF
PARCEL_TIP $FIXTURE_TIP
VOLATILE run-started 1970-01-01T00:00:00Z
OPERATION-CHECK sbcl 2.4.6 (trivial child through this exact invocation)
    PARCEL_TIP               $FIXTURE_TIP
  [PASS] synthetic check one
  CHECK-ID SYN-A-CHECK-1
  [PASS] synthetic check two
  CHECK-ID SYN-A-CHECK-2
  [PASS] synthetic check three
  CHECK-ID SYN-A-CHECK-3
CHECKS 3   FAILURES 0   CASES 0
    PARCEL_TIP               $FIXTURE_TIP
PROBE-SECTION-PASS SYN-CONTROLS-A
END-OF-TRANSCRIPT SYN-CONTROLS-A CHECKS=3 CASES=0
$RULE74
PARCEL_TIP $FIXTURE_TIP
CHILD-EXIT 0
PARCEL_TIP $FIXTURE_TIP
VOLATILE run-started 1970-01-01T00:00:00Z
OPERATION-CHECK sbcl 2.4.6 (trivial child through this exact invocation)
    PARCEL_TIP               $FIXTURE_TIP
C6-PROVIDER S1
  [PASS] synthetic check four
  CHECK-ID SYN-B-S1-CHECK-1
  [PASS] synthetic check five
  CHECK-ID SYN-B-S1-CHECK-2
END-C6-PROVIDER S1
C6-PROVIDER S2
  [PASS] synthetic check six
  CHECK-ID SYN-B-S2-CHECK-1
  [PASS] synthetic check seven
  CHECK-ID SYN-B-S2-CHECK-2
END-C6-PROVIDER S2
CHECKS 4   FAILURES 0   CASES 0
    PARCEL_TIP               $FIXTURE_TIP
PROBE-SECTION-PASS SYN-CONTROLS-B
END-OF-TRANSCRIPT SYN-CONTROLS-B CHECKS=4 CASES=0
$RULE74
PARCEL_TIP $FIXTURE_TIP
CHILD-EXIT 0
EOF

echo "== Surface Account /0 — verifier regression specimens =="
echo "   verifier   $VERIFY"
echo "   worktree   $WT_PHYS"
echo "   outdir     $OUTDIR"

run_suite "synthetic" "$SYN" "synthetic" "$FIXTURE_TIP" 2 --fixture-tip

if [ -n "$FROM" ]; then
  if [ -r "$FROM" ]; then
    run_suite "live" "$FROM" "$LIVE_PROFILE" "$LIVE_TIP" 13 --repo "$ROOT"
  else
    note "   !! --from is unreadable: $FROM"
    FAILURES=$((FAILURES + 1))
  fi
else
  note ""
  note "   (no --from given: the LIVE suite was not run.  The final round must"
  note "    run these specimens against an actual clean controls-transcript.txt.)"
fi

# --------------------------------------------------------------------------
# THE OUTPUT-PATH TEETH, 13 and 14.  This script's own boundary, exercised by
# handing THIS SCRIPT a path it must refuse — and then proving that the refusal
# LEFT NOTHING BEHIND.  A boundary that rejects after creating the directory is
# a complaint, not a boundary.
# --------------------------------------------------------------------------
PATH_TOOTH_DIR="$OUTDIR/output-path-teeth"
mkdir -p "$PATH_TOOTH_DIR"

INSIDE="$HERE/_specimen_evidence_should_never_exist"
DOTDOT="$HERE/nonexistent-prefix/../_specimen_evidence_should_never_exist"

path_tooth () {
  local num="$1" name="$2" target="$3"; shift 3
  local stem="$PATH_TOOTH_DIR/tooth-$num-$name"
  echo "$target" > "$stem.path"
  bash "$0" "$target" --self-tooth > "$stem.out" 2> "$stem.err"
  local rc=$?
  echo "$rc" > "$stem.exit"
  local created=""
  local leftover
  for leftover in "$@"; do
    [ -e "$leftover" ] && created="$created $leftover"
  done
  echo "${created:-NOTHING CREATED}" > "$stem.leftovers"
  if [ "$rc" -ne 0 ] && [ -z "$created" ]; then
    note "   tooth $num  $name"
    note "      REFUSED exit=$rc, and nothing was created  $(head -1 "$stem.err")"
  else
    [ "$rc" -eq 0 ] && note "   !! tooth $num  $name  WAS ACCEPTED (exit 0) — the boundary is not a boundary"
    [ -n "$created" ] && note "   !! tooth $num  $name  left something behind:$created"
    FAILURES=$((FAILURES + 1))
  fi
}

note ""
note "== OUTPUT-PATH TEETH (this script's own boundary) =="
path_tooth 13 outdir-inside-the-worktree            "$INSIDE" "$INSIDE"
path_tooth 14 nonexistent-prefix-dotdot-inside      "$DOTDOT" "$INSIDE" "$HERE/nonexistent-prefix"

echo
if [ "$FAILURES" -eq 0 ]; then
  echo "SURFACE-ACCOUNT-0-VERIFIER-SPECIMENS-PASS  every specimen refused, every base accepted, every output path refused without a trace"
  exit 0
else
  echo "SURFACE-ACCOUNT-0-VERIFIER-SPECIMENS-FAILED  $FAILURES problem(s)"
  exit 1
fi
