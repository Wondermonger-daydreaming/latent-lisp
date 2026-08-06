#!/usr/bin/env bash
#
# ==========================================================================
# NON-PRODUCTION FEASIBILITY PROBE — Surface Account /0 opening round —
# not a package, not an API, not loadable as part of any system.
# ==========================================================================
#
# THE TRANSCRIPT VERIFIER, under the R2 law (the R1 law plus a closed grammar).
#
# WHAT WAS WRONG WITH THE R0 VERIFIER, kept here because it is why this file
# exists: it read its expectations OUT OF the transcript.  It counted the END
# sentinels the transcript happened to carry and compared them with the CHECKS
# the transcript happened to claim.  A transcript that lost a whole child block
# lost its sentinel AND its claim together, and the two still agreed — so the
# R0 "truncation test" deleted nothing the verifier could see.  A gate that
# cannot fail is not a gate.
#
# WHAT WAS STILL WRONG WITH THE R1 VERIFIER, stated with the same plainness:
#
#   1. CHECKS was still read out of the artifact.  R1 bound CASES externally
#      and then compared the transcript's claimed CHECKS against the
#      transcript's own [PASS] count — two numbers a hollowed-out section moves
#      TOGETHER.  An intact CONTROLS-B shell with its body deleted and its
#      header forged to CHECKS=0 was ACCEPTED.
#   2. Body lines it did not recognize fell through a bare `next`.  Anything
#      could be inserted into a block and be stepped over in silence.
#   3. END-OF-TRANSCRIPT changed nothing.  Arbitrary material could follow it
#      inside the same block.
#   4. [FAIL] and PROBE-SECTION-FAIL were matched only at their usual
#      indentation, so a re-indented verdict line was invisible.
#   5. --tip was any nonempty string that was not the word UNAVAILABLE.  A tip
#      that was not a hex object name, or was a hex object name belonging to no
#      repository at all, sailed through.
#
# WHAT WAS STILL WRONG WITH THE R2 VERIFIER, the four defects the R3 law names:
#
#   1. THE VERDICT TEST HAD A LENGTH FLOOR.  The bracketed-verdict pattern was
#      \[[A-Z][A-Z0-9_-][A-Z0-9_-]+\] — three characters or more.  [X] and [OK]
#      are bracketed uppercase verdict tokens and BOTH FELL THROUGH IT: two
#      characters and one character, matched by nothing, refused by nothing,
#      and then swallowed by the NARRATIVE fallback as prose.  R2 closed the
#      long verdict forms and left the short ones open.
#   2. THE CHILD TERMINATOR WAS READ NUMERICALLY.  `$2 + 0 != 0` accepts
#      CHILD-EXIT 000, CHILD-EXIT 0x0 and CHILD-EXIT 0000000 — every spelling
#      the awk string-to-number coercion sends to zero.  The terminator is a
#      LEXICAL fact, not an arithmetic one.
#   3. THE SECTION FOOTER'S FAILURE COUNT WAS NEVER CHECKED.  The grammar's
#      checks-footer production was ^CHECKS [0-9]+   FAILURES [0-9]+   CASES
#      [0-9]+$ — any failure count at all.  A section could announce
#      FAILURES 999 in its own footer and still be ACCEPTED, because every
#      other clause (the external CHECKS, the [PASS] count, the ID stream) was
#      satisfied and nothing ever looked at the number the section itself
#      reported.
#   4. GIT TIP RESOLUTION RAN THROUGH THE REPLACEMENT LENS.  `git rev-parse
#      --verify <tip>^{commit}` consults refs/replace.  A repository carrying
#      refs/replace/<fabricated-name> -> <a real commit> makes a name that
#      NAMES NO OBJECT AT ALL resolve, cleanly, to a commit.  Measured, not
#      assumed: in a scratch repository the fabricated name
#      beef0beef1…beef7 exits 1 before the replace ref is created and exits 0
#      after it, with no object of that name ever written.  The tip clause was
#      therefore a test of what the repository was WILLING TO SAY, not of what
#      it physically HELD.
#
# THE R2 LAW.  The caller states the EXPECTED PROFILE (ordered sections, exact
# CASES, exact CHECKS), the EXPECTED TIP, and — unless the explicit fixture
# mode is used — the REPOSITORY that tip must resolve in.  Nothing whatever is
# inferred from the artifact under test.  Every line inside a block is consumed
# by a declared grammar production or refused.  Every counted assertion carries
# an externally declared CHECK ID, and the section's ID stream must equal the
# externally declared sequence, in order.
#
# THE R3 LAW ADDS FOUR CLOSURES, each with its own specimen:
#
#   * EVERY bracketed token of one or more characters drawn from [A-Z0-9_-] is
#     a verdict form, and the only verdict form admitted is the exact
#     "  [PASS] <label>" line.  There is no length floor.
#   * The child terminator is the LITERAL STRING "CHILD-EXIT 0".  Nothing is
#     coerced to a number.
#   * An accepted section footer is lexically "CHECKS <n>   FAILURES 0
#     CASES <n>" — the zero is a literal, so FAILURES 000 and FAILURES 999 are
#     both refused, and the refusal is semantic as well as lexical: a section
#     that reports any failure of its own is not an accepted section.
#   * The tip must PHYSICALLY EXIST as a commit in the supplied repository with
#     REPLACEMENT OBJECTS DISABLED (git --no-replace-objects plus
#     GIT_NO_REPLACE_OBJECTS=1, existence by `cat-file -e`, type by
#     `cat-file -t`).  refs/replace can no longer lend a fabricated name a real
#     commit's body.
#
# WHAT WAS STILL WRONG WITH THE R3 VERIFIER, the four defects the R3.1 law
# names.  Each was REPRODUCED against this file at tip d385dde5 before it was
# repaired; the reproductions are specimens 19-33 in run-verifier-specimens.sh
# and each one was ACCEPTED by the R3 verifier.
#
#   1. THE SECTION FOOTER WAS NEVER REQUIRED, NEVER COUNTED AND NEVER READ FOR
#      ITS NUMBERS.  R3 refused a footer that was lexically wrong IF ONE WAS
#      PRESENT, and that was the whole of it: a block with NO footer, a block
#      with TWO footers, and a block whose footer declared CHECKS or CASES
#      contradicting both the external profile and the block's own
#      END-OF-TRANSCRIPT were all accepted.  The one line in which a section
#      states its own totals was structurally optional.
#   2. THE IN-BODY PARCEL_TIP STAMPS WERE FURNITURE, NOT A PAIR.  R3 checked
#      the VALUE of any stamp it happened to see and required none.  The probe
#      prelude emits exactly two — a header stamp before the block's first
#      ID-bearing assertion and a footer stamp after the section footer and
#      before PROBE-SECTION-PASS — and a transcript that lost either, or grew a
#      third, was accepted.
#   3. A TAB-PREFIXED STRUCTURAL TOKEN WAS READ AS NARRATIVE.  Every reserved
#      ERE in the grammar is written with a literal-space prefix class
#      (`^ *CHECKS`, `^ *CHILD-EXIT`, `^ *END-OF-TRANSCRIPT`), and a HORIZONTAL
#      TAB is not a space.  So "\tCHECKS 999   FAILURES 999   CASES 999"
#      matched no production, matched no RESERVED token, and was then consumed
#      by the NARRATIVE fallback ^ {0,3}[^ ].*$ — the tab satisfying [^ ].  A
#      forged footer, a forged END-OF-TRANSCRIPT and a forged CHILD-EXIT could
#      all be carried inside a block as prose.  Carriage returns had the same
#      standing: invisible, and able to change what a line lexically is.
#   4. GIT RAN IN WHATEVER ENVIRONMENT IT INHERITED.  `git -C "$REPO"` does NOT
#      override an ambient GIT_DIR: the environment variable selects the
#      repository and -C only changes the working directory.  So a caller with
#      GIT_DIR, GIT_OBJECT_DIRECTORY or GIT_ALTERNATE_OBJECT_DIRECTORIES set
#      could have the tip resolved in a DIFFERENT repository from the one named
#      by --repo, and a repository carrying a configured
#      objects/info/alternates could borrow the commit from a neighbour.  The
#      R3 clause proved "some object store this process can reach holds it",
#      not "the repository you named holds it".
#
# THE R3.1 LAW ADDS FOUR CLOSURES:
#
#   * EXACTLY ONE section footer per child block, lexically
#     "CHECKS <n>   FAILURES 0   CASES <n>", PARSED, with its CHECKS and CASES
#     equal to BOTH the external profile AND the block's END-OF-TRANSCRIPT.
#   * EXACTLY TWO in-body PARCEL_TIP stamps per child block, both equal to the
#     tested tip: the first BEFORE the block's first ID-bearing assertion, the
#     second AFTER the unique section footer and BEFORE PROBE-SECTION-PASS.
#   * HORIZONTAL TAB and CARRIAGE RETURN are refused BEFORE grammar dispatch,
#     anywhere in the file, inside a block or outside one.  A structural token
#     can therefore never be smuggled past the reserved-token test by its
#     leading whitespace.
#   * EVERY Git invocation runs with the ambient repository- and
#     object-selection variables CLEARED (GIT_DIR, GIT_WORK_TREE,
#     GIT_COMMON_DIR, GIT_OBJECT_DIRECTORY, GIT_ALTERNATE_OBJECT_DIRECTORIES,
#     GIT_INDEX_FILE, GIT_NAMESPACE, and the discovery variables), --repo is
#     canonicalized to an absolute git-dir UNDER that clean environment, every
#     later operation is bound to that git-dir explicitly, and a repository
#     with a configured objects/info/alternates is REFUSED — so the object
#     store consulted is the named repository's OWN.
#
# INVOCATION.
#
#     bash verify-transcript.sh <transcript-file> \
#          --profile <name> --tip <parcel-tip> \
#          [--repo <git-dir> | --fixture-tip] \
#          [--profiles <file>] [--grammar <file>] [--sequences <file>]
#
#   --profile      a name in verify-profiles.txt: the exact ORDERED sections
#                  and their exact CASES and CHECKS counts.
#   --tip          the exact parcel tip this run was made at.  It must be
#                  exactly 40 lowercase hexadecimal digits, it must PHYSICALLY
#                  EXIST as a commit object in the repository named by --repo
#                  WITH REPLACEMENT OBJECTS DISABLED, and every PARCEL_TIP
#                  stamp in the file — opening, closing and the in-body
#                  header/footer stamps — must equal it.
#   --repo         the repository the tip must resolve in.  Required unless
#                  --fixture-tip is given.
#   --fixture-tip  EXPLICIT FIXTURE MODE.  The one and only tip accepted under
#                  it is the all-zero string, which is NOT a Git object, is NOT
#                  a real tested tip, and exists only so that the verifier's own
#                  regression specimens can be run with no probe run at all.
#                  No repository is consulted and none may be inferred.
#   --profiles     override verify-profiles.txt   (defaults: beside this script)
#   --grammar      override verify-grammar.txt
#   --sequences    override verify-sequences.txt
#
# A transcript is a sequence of CHILD BLOCKS, one per throwaway image:
#
#     PARCEL_TIP <tip>                      <- opening stamp
#     ... body ...                          <- every line consumed by a
#                                              declared production; exactly one
#                                              PROBE-SECTION-PASS; exactly one
#                                              END-OF-TRANSCRIPT, and it ends
#                                              the body
#     ==== (the declared separator) ====    <- the ONLY thing permitted between
#                                              END-OF-TRANSCRIPT and the stamp
#     PARCEL_TIP <tip>                      <- closing stamp, identical
#     CHILD-EXIT 0                          <- mandatory, and mandatorily 0
#
# For every expected block, ALL of the following are required:
#
#   1. an opening PARCEL_TIP equal to the tested tip;
#   2. a PROBE-SECTION-PASS name and an END-OF-TRANSCRIPT name that agree with
#      each other AND with the profile's section for this position;
#   3. strictly numeric CHECKS and CASES on the END line;
#   4. CASES exactly as the PROFILE declares;
#   5. CHECKS exactly as the PROFILE declares — not as the transcript claims;
#   6. a [PASS]-line count exactly equal to the profile's CHECKS;
#   7. one CHECK-ID line immediately after every [PASS] line, and no CHECK-ID
#      line anywhere else;
#   8. the section's ID stream exactly equal, in order, to its declared
#      sequence in verify-sequences.txt;
#   9. no [FAIL], no PROBE-SECTION-FAIL and no other bracketed verdict form of
#      ANY LENGTH — [X] and [OK] included — AT ANY INDENTATION;
#  10. every body line consumed by a declared production in verify-grammar.txt;
#  11. nothing after END-OF-TRANSCRIPT but the declared separator, the closing
#      PARCEL_TIP and CHILD-EXIT 0;
#  12. every in-body PARCEL_TIP stamp equal to the tested tip;
#  13. a closing PARCEL_TIP identical to the opening one;
#  14. a mandatory child terminator, and it is the LITERAL STRING
#      "CHILD-EXIT 0" — 000, 0x0 and trailing garbage are refused;
#  15. every section footer lexically "CHECKS <n>   FAILURES 0   CASES <n>";
#  16. no missing, duplicate, extra, reordered or trailing block material — the
#      block count must equal the profile's, in the profile's order, and no
#      line may sit outside a block.
#  17. EXACTLY ONE section footer, whose parsed CHECKS and CASES equal both the
#      profile's and the block's own END-OF-TRANSCRIPT values (R3.1);
#  18. EXACTLY TWO in-body PARCEL_TIP stamps, the first before the block's
#      first ID-bearing assertion and the second after the unique footer and
#      before PROBE-SECTION-PASS (R3.1);
#  19. no horizontal TAB and no carriage return anywhere in the file, refused
#      before any grammar dispatch (R3.1);
#  20. every Git invocation made in a cleared repository/object environment,
#      against the canonicalized --repo git-dir, with configured object
#      alternates refused (R3.1);
#  21. every Git invocation made with LAZY FETCHING DISABLED, so that a tip
#      absent from the named repository cannot be IMPORTED from a promisor
#      remote and then reported as physically present (R3.2).
#
# exits 0 = ACCEPTED, nonzero = REFUSED (with the reason on stderr).
#
# The teeth of this file are exercised by run-verifier-specimens.sh, which
# crafts thirty-four defective artifacts — the fourteen of R2, the four the R3
# law names, the fifteen of the four R3.1 families, and the one R3.2 promisor
# specimen — and requires each one to be refused.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILES="$HERE/verify-profiles.txt"
GRAMMAR="$HERE/verify-grammar.txt"
SEQUENCES="$HERE/verify-sequences.txt"

FIXTURE_TIP_LITERAL="0000000000000000000000000000000000000000"

# --------------------------------------------------------------------------
# THE R3.1 GIT ENVIRONMENT CLAUSE.  `git -C <path>` does NOT override an
# ambient GIT_DIR — the environment variable selects the repository and -C only
# changes the working directory — so under R3 a caller could have --repo name
# one repository while the tip was resolved in ANOTHER.  GIT_OBJECT_DIRECTORY
# and GIT_ALTERNATE_OBJECT_DIRECTORIES did the same thing one level down, at
# the object store rather than the repository.
#
# Every Git invocation in this file therefore goes through git_clean, which
# unsets the whole repository/object/index selection set (and the discovery
# variables, so that a rejected --repo cannot be rescued by walking upward) and
# keeps the R3 replacement-lens removal.  Nothing here consults $PWD.
#
# THE R3.2 LAZY-FETCH CLAUSE, and the defect it closes.  Under R3.1 the four
# steps below still asked a question Git was allowed to answer by GOING AND
# GETTING the object: in a PARTIAL CLONE (a repository with a PROMISOR remote —
# `extensions.partialClone`, `remote.<name>.promisor`) `cat-file -e <sha>` on a
# locally absent object triggers a LAZY FETCH from that remote, IMPORTS the
# object, and then reports success.  The repository named by --repo therefore
# did not hold the tip when it was asked; it held it because it was asked.  A
# WHOLLY LOCAL promisor remote is enough — no network is required — so the R3.1
# clause's own words, "physically present", were false in exactly the case the
# clause existed to police, and the sentence it printed said so out loud.
#
# GIT_NO_LAZY_FETCH=1 is therefore set on EVERY invocation, beside the
# replacement-lens removal and for the same reason: existence must be a
# question about THIS object store as it stands, never a request the store may
# satisfy by fetching.  It is not conditional on the repository looking like a
# partial clone — a check that only fires where it expects the defect is a
# check that can be walked around by not looking like one.  Specimen 34 in
# run-verifier-specimens.sh exhibits the pre-fix acceptance against the
# extracted R3.1-era verifier and the refusal here.
# --------------------------------------------------------------------------
git_clean () {
  env -u GIT_DIR \
      -u GIT_WORK_TREE \
      -u GIT_COMMON_DIR \
      -u GIT_OBJECT_DIRECTORY \
      -u GIT_ALTERNATE_OBJECT_DIRECTORIES \
      -u GIT_INDEX_FILE \
      -u GIT_NAMESPACE \
      -u GIT_CEILING_DIRECTORIES \
      -u GIT_DISCOVERY_ACROSS_FILESYSTEM \
      -u GIT_CONFIG \
      -u GIT_CONFIG_GLOBAL \
      -u GIT_CONFIG_SYSTEM \
      GIT_NO_REPLACE_OBJECTS=1 \
      GIT_NO_LAZY_FETCH=1 \
      git --no-replace-objects "$@"
}

usage () {
  cat >&2 <<'EOF'
usage: bash verify-transcript.sh <transcript-file> --profile <name> --tip <parcel-tip>
                                 [--repo <git-dir> | --fixture-tip]
                                 [--profiles <file>] [--grammar <file>] [--sequences <file>]
EOF
  exit 2
}

[ $# -ge 1 ] || usage
F="$1"; shift
PROFILE=""
TIP=""
REPO=""
FIXTURE=0
while [ $# -gt 0 ]; do
  case "$1" in
    --profile)     [ $# -ge 2 ] || usage; PROFILE="$2"; shift 2 ;;
    --tip)         [ $# -ge 2 ] || usage; TIP="$2"; shift 2 ;;
    --repo)        [ $# -ge 2 ] || usage; REPO="$2"; shift 2 ;;
    --fixture-tip) FIXTURE=1; shift ;;
    --profiles)    [ $# -ge 2 ] || usage; PROFILES="$2"; shift 2 ;;
    --grammar)     [ $# -ge 2 ] || usage; GRAMMAR="$2"; shift 2 ;;
    --sequences)   [ $# -ge 2 ] || usage; SEQUENCES="$2"; shift 2 ;;
    *) usage ;;
  esac
done

[ -r "$F" ]         || { echo "REFUSED: unreadable transcript: $F" >&2; exit 2; }
[ -n "$PROFILE" ]   || { echo "REFUSED: --profile is required; nothing is inferred from the transcript" >&2; exit 2; }
[ -n "$TIP" ]       || { echo "REFUSED: --tip is required; nothing is inferred from the transcript" >&2; exit 2; }
[ -r "$PROFILES" ]  || { echo "REFUSED: unreadable profiles file: $PROFILES" >&2; exit 2; }
[ -r "$GRAMMAR" ]   || { echo "REFUSED: unreadable grammar file: $GRAMMAR" >&2; exit 2; }
[ -r "$SEQUENCES" ] || { echo "REFUSED: unreadable sequences file: $SEQUENCES" >&2; exit 2; }

# --------------------------------------------------------------------------
# --tip VALIDATION.  Three separate requirements, each with its own message,
# because "the tip was wrong" is three different faults.
# --------------------------------------------------------------------------
case "$TIP" in
  UNAVAILABLE|unavailable)
    echo "REFUSED: --tip UNAVAILABLE — a transcript must carry the exact tested tip" >&2; exit 2 ;;
esac

if ! printf '%s' "$TIP" | grep -qE '^[0-9a-f]{40}$'; then
  echo "REFUSED: --tip '$TIP' is not exactly 40 lowercase hexadecimal digits" >&2
  exit 2
fi

if [ "$FIXTURE" -eq 1 ]; then
  [ -z "$REPO" ] || { echo "REFUSED: --fixture-tip and --repo are mutually exclusive" >&2; exit 2; }
  if [ "$TIP" != "$FIXTURE_TIP_LITERAL" ]; then
    echo "REFUSED: --fixture-tip accepts only the all-zero fixture tip, not '$TIP'" >&2
    exit 2
  fi
  TIP_NOTE="FIXTURE TIP (synthetic; not a Git object and not a real tested tip)"
else
  if [ "$TIP" = "$FIXTURE_TIP_LITERAL" ]; then
    echo "REFUSED: the all-zero tip is a synthetic fixture and is accepted only under --fixture-tip" >&2
    exit 2
  fi
  [ -n "$REPO" ] || { echo "REFUSED: --repo is required so that --tip can be resolved to a real commit (or use --fixture-tip)" >&2; exit 2; }
  [ -d "$REPO" ] || { echo "REFUSED: --repo is not a directory: $REPO" >&2; exit 2; }
  # ------------------------------------------------------------------------
  # THE R3.1 REPOSITORY-BINDING CLAUSE, in four steps and in this order.
  #
  #   (a) CANONICALIZE --repo under the CLEAN environment.  Under R3 the
  #       repository was named by a path and re-discovered on every call, so an
  #       ambient GIT_DIR silently answered instead of the path.  Here the
  #       git-dir is resolved once, with the selection variables unset, and
  #       every later operation is bound to that absolute git-dir EXPLICITLY
  #       (--git-dir) as well as positionally (-C).
  #   (b) REFUSE CONFIGURED OBJECT ALTERNATES.  An objects/info/alternates file
  #       lets a repository read another repository's objects, so "the commit
  #       exists here" would again mean "some reachable store holds it".  Both
  #       the git-dir's and the common-dir's alternates files are checked, and
  #       a nonempty one is refused with its contents quoted.
  #   (c) EXISTENCE, with the replacement lens removed twice over (the R3
  #       clause, unchanged in substance).
  #   (d) TYPE.
  # ------------------------------------------------------------------------
  REPO_GITDIR="$(git_clean -C "$REPO" rev-parse --absolute-git-dir 2>/dev/null || true)"
  if [ -z "$REPO_GITDIR" ] || [ ! -d "$REPO_GITDIR" ]; then
    echo "REFUSED: --repo is not inside a Git repository when the ambient GIT_DIR/GIT_WORK_TREE/GIT_OBJECT_DIRECTORY/GIT_ALTERNATE_OBJECT_DIRECTORIES/GIT_INDEX_FILE/GIT_NAMESPACE selection is cleared: $REPO" >&2
    exit 2
  fi
  REPO_COMMONDIR="$(git_clean -C "$REPO" --git-dir "$REPO_GITDIR" rev-parse --path-format=absolute --git-common-dir 2>/dev/null || true)"
  [ -n "$REPO_COMMONDIR" ] || REPO_COMMONDIR="$REPO_GITDIR"

  for _alt in "$REPO_GITDIR/objects/info/alternates" "$REPO_COMMONDIR/objects/info/alternates"; do
    if [ -s "$_alt" ]; then
      echo "REFUSED: the repository named by --repo has a CONFIGURED OBJECT ALTERNATES file ($_alt), so an object found there need not be held by this repository at all:" >&2
      sed -e 's/^/           /' "$_alt" >&2
      exit 2
    fi
  done

  if ! git_clean -C "$REPO" --git-dir "$REPO_GITDIR" \
         cat-file -e "$TIP" >/dev/null 2>&1; then
    echo "REFUSED: --tip $TIP is well formed but no object of that name physically exists in $REPO_GITDIR (ambient repository/object selection cleared; replacement objects disabled; LAZY FETCHING DISABLED: neither a refs/replace mapping, an inherited GIT_DIR/GIT_OBJECT_DIRECTORY, an alternate object directory nor a promisor remote can lend it one)" >&2
    exit 2
  fi
  TIP_TYPE="$(git_clean -C "$REPO" --git-dir "$REPO_GITDIR" \
                cat-file -t "$TIP" 2>/dev/null)"
  if [ "$TIP_TYPE" != "commit" ]; then
    echo "REFUSED: --tip $TIP physically exists in $REPO_GITDIR but is a '${TIP_TYPE:-unreadable object}', not a commit (ambient selection cleared; replacement objects disabled; lazy fetching disabled)" >&2
    exit 2
  fi
  TIP_NOTE="physically present as a commit in $REPO_GITDIR (ambient GIT_DIR/GIT_WORK_TREE/GIT_COMMON_DIR/GIT_OBJECT_DIRECTORY/GIT_ALTERNATE_OBJECT_DIRECTORIES/GIT_INDEX_FILE/GIT_NAMESPACE cleared; no configured object alternates; replacement objects disabled; lazy fetching disabled)"
fi

# --------------------------------------------------------------------------
# THE PROFILE.  <SECTION>:<CASES>:<CHECKS>, ordered.
# --------------------------------------------------------------------------
EXPECT="$(awk -v want="$PROFILE" '
  /^[[:space:]]*(#|$)/ { next }
  { if ($1 == want) { s=""; for (i=2; i<=NF; i++) s = s (i>2 ? " " : "") $i; print s; found=1; exit } }
  END { if (!found) exit 3 }
' "$PROFILES")" || { echo "REFUSED: no profile named '$PROFILE' in $PROFILES" >&2; exit 2; }

[ -n "$EXPECT" ] || { echo "REFUSED: profile '$PROFILE' declares no sections" >&2; exit 2; }

for e in $EXPECT; do
  case "$e" in
    *:*:*)
      _cases="${e#*:}"; _cases="${_cases%%:*}"
      _checks="${e##*:}"
      case "$_cases"  in ''|*[!0-9]*) echo "REFUSED: profile '$PROFILE' entry '$e' has a nonnumeric CASES" >&2; exit 2 ;; esac
      case "$_checks" in ''|*[!0-9]*) echo "REFUSED: profile '$PROFILE' entry '$e' has a nonnumeric CHECKS" >&2; exit 2 ;; esac ;;
    *) echo "REFUSED: profile '$PROFILE' entry '$e' is not <SECTION>:<CASES>:<CHECKS>" >&2; exit 2 ;;
  esac
done

awk -v tip="$TIP" -v expect="$EXPECT" -v file="$F" -v profile="$PROFILE" \
    -v grammarfile="$GRAMMAR" -v seqfile="$SEQUENCES" '
function refuse(msg) { printf("REFUSED: %s\n", msg) > "/dev/stderr"; dead=1; exit 1 }

# The ID of an anchored line: the substring matched by the anchor s id-ERE,
# every run of non-alphanumerics collapsed to one dash, upper-cased.
function norm(s,   i, c, out, prev) {
  out = ""; prev = 0
  for (i = 1; i <= length(s); i++) {
    c = substr(s, i, 1)
    if (c ~ /[A-Za-z0-9]/) { out = out toupper(c); prev = 0 }
    else if (out != "" && !prev) { out = out "-"; prev = 1 }
  }
  sub(/-+$/, "", out)
  return out
}

BEGIN {
  n = split(expect, E, " ")
  for (i = 1; i <= n; i++) {
    split(E[i], t, ":")
    XN[i] = t[1]; XC[i] = t[2] + 0; XK[i] = t[3] + 0
  }

  # ---- the declared grammar ----
  np = 0; nr = 0; nf = 0
  while ((getline gl < grammarfile) > 0) {
    if (gl ~ /^[[:space:]]*(#|$)/) continue
    m = split(gl, G, " ::: ")
    if (m < 3) { printf("REFUSED: malformed grammar line: %s\n", gl) > "/dev/stderr"; dead=1; fatal=2; exit 2 }
    kind = G[1]
    if (kind == "PRODUCTION")   { np++; PK[np]="P"; PN[np]=G[2]; PR[np]=G[3]; PI[np]="" }
    else if (kind == "ANCHOR")  { if (m < 4) { printf("REFUSED: ANCHOR without an id-ERE: %s\n", gl) > "/dev/stderr"; dead=1; fatal=2; exit 2 }
                                  np++; PK[np]="A"; PN[np]=G[2]; PR[np]=G[3]; PI[np]=G[4] }
    else if (kind == "RESERVED"){ nr++; RN[nr]=G[2]; RR[nr]=G[3] }
    else if (kind == "FALLBACK"){ nf++; FN[nf]=G[2]; FR[nf]=G[3] }
    else { printf("REFUSED: unknown grammar declaration kind %s\n", kind) > "/dev/stderr"; dead=1; fatal=2; exit 2 }
  }
  close(grammarfile)
  if (np == 0) { printf("REFUSED: the grammar file declares no productions\n") > "/dev/stderr"; dead=1; fatal=2; exit 2 }

  # ---- the declared ID sequences, keyed <profile>:<SECTION> ----
  while ((getline sl < seqfile) > 0) {
    if (sl ~ /^[[:space:]]*(#|$)/) continue
    if (split(sl, S, " ") < 2) { printf("REFUSED: malformed sequence line: %s\n", sl) > "/dev/stderr"; dead=1; fatal=2; exit 2 }
    key = S[1]
    SEQN[key]++
    SEQ[key, SEQN[key]] = S[2]
  }
  close(seqfile)
  for (i = 1; i <= n; i++) {
    k = profile ":" XN[i]
    if (!(k in SEQN)) { printf("REFUSED: no declared ID sequence for %s in the sequences file\n", k) > "/dev/stderr"; dead=1; fatal=2; exit 2 }
  }

  state = 0; blk = 0; totalchecks = 0
}

{
  line = $0

  # ---- (0) HORIZONTAL-WHITESPACE IMPOSTORS, BEFORE ANY GRAMMAR DISPATCH -----
  # Every RESERVED ERE in the grammar file is written with a LITERAL-SPACE
  # prefix class (^ *CHECKS, ^ *CHILD-EXIT, ^ *END-OF-TRANSCRIPT).  A HORIZONTAL
  # TAB is not a space, so under R3 a tab-prefixed structural token matched no
  # production, matched no reserved token, and was then consumed by the
  # NARRATIVE fallback ^ {0,3}[^ ].*$ — the tab itself satisfying [^ ].  A
  # forged footer, END-OF-TRANSCRIPT or CHILD-EXIT could therefore ride inside a
  # block as prose.  A carriage return is the same fault at the other end of the
  # line: invisible, and able to change what a line lexically is.
  #
  # Neither character is emitted by any probe in this directory, so this is not
  # a normalization — it is a refusal, and it happens BEFORE the block frame,
  # before the verdict test, and before any production is consulted, so no
  # classification of such a line is ever reached.
  if (index(line, "\t") > 0)
    refuse("line " NR " contains a HORIZONTAL TAB, which is refused before any grammar dispatch (a tab-prefixed structural token must never be classified as narrative): \"" line "\"")
  if (index(line, "\r") > 0)
    refuse("line " NR " contains a CARRIAGE RETURN, which is refused before any grammar dispatch: \"" line "\"")

  # ---- (1) BRACKETED VERDICT FORMS, INDEPENDENT OF INDENTATION AND LENGTH ---
  # [FAIL] re-indented by one space was invisible to R1.  So the test is on the
  # SHAPE, not the position: any bracketed all-caps token is a verdict form,
  # and the only verdict form this grammar admits is the exact PASS line.
  #
  # R3 REMOVES THE LENGTH FLOOR.  The R2 pattern was
  # \[[A-Z][A-Z0-9_-][A-Z0-9_-]+\] — a first character plus two more, i.e.
  # THREE OR MORE.  [OK] is two and [X] is one, so both slipped past the
  # verdict test and were then eaten by the NARRATIVE fallback as prose.  The
  # class is now ONE OR MORE, written with `+` and not with an interval, so
  # that the pattern means the same thing in mawk, gawk and busybox awk.
  if (state == 1 || state == 3) {
    if (line ~ /PROBE-SECTION-FAIL/)
      refuse("block " blk ": PROBE-SECTION-FAIL at line " NR " (rejected at any indentation): \"" line "\"")
    if (line ~ /\[FAIL\]/)
      refuse("block " blk ": [FAIL] verdict at line " NR " (rejected at any indentation): \"" line "\"")
    if (line ~ /\[[A-Z0-9_-]+\]/ && line !~ /^  \[PASS\] .+$/)
      refuse("block " blk ": bracketed verdict form at line " NR " is not the exact \"  [PASS] <label>\" form (any length, any indentation): \"" line "\"")
  }

  # ---- the block frame ------------------------------------------------------
  if (state == 0) {
    if (line ~ /^PARCEL_TIP /) {
      blk++
      if (blk > n)
        refuse("extra child block #" blk " at line " NR "; profile \"" profile "\" expects exactly " n)
      if (NF != 2)
        refuse("block " blk ": malformed opening PARCEL_TIP line at " NR ": \"" line "\"")
      if ($2 != tip)
        refuse("block " blk ": opening PARCEL_TIP is \"" $2 "\" but the tested tip is \"" tip "\"")
      pass = 0; ids = 0; secpass = 0; endcount = 0; sep = 0
      secname = ""; endname = ""; checks = -1; cases = -1; awaiting_id = 0
      foot = 0; fchecks = -1; fcases = -1; stamps = 0
      state = 1
      next
    }
    refuse("material outside any child block at line " NR ": \"" line "\"")
  }

  if (state == 1) {
    if (line ~ /^PARCEL_TIP /)
      refuse("block " blk ": a closing PARCEL_TIP at line " NR " with no END-OF-TRANSCRIPT before it")
    if (line ~ /^CHILD-EXIT/)
      refuse("block " blk ": CHILD-EXIT at line " NR " inside the body")

    if (line ~ /^PROBE-SECTION-PASS/) {
      if (line !~ /^PROBE-SECTION-PASS [^ ]+$/)
        refuse("block " blk ": malformed PROBE-SECTION-PASS line at " NR ": \"" line "\"")
      if (awaiting_id)
        refuse("block " blk ": a [PASS] line at " (NR-1) " is not followed by its CHECK-ID line")
      # ---- the in-body stamp PAIR must be complete before the verdict line ---
      if (foot != 1)
        refuse("block " blk ": PROBE-SECTION-PASS at line " NR " is preceded by " foot " section footer line(s); exactly one \"CHECKS <n>   FAILURES 0   CASES <n>\" is required, and it must come before this line")
      if (stamps != 2)
        refuse("block " blk ": PROBE-SECTION-PASS at line " NR " is preceded by " stamps " in-body PARCEL_TIP stamp(s); the pair is mandatory — one before the first ID-bearing assertion of the block and one after the unique section footer")
      secpass++
      secname = $2
      next
    }

    if (line ~ /^END-OF-TRANSCRIPT/) {
      if (awaiting_id)
        refuse("block " blk ": a [PASS] line at " (NR-1) " is not followed by its CHECK-ID line")
      if (line !~ /^END-OF-TRANSCRIPT [^ ]+ CHECKS=[0-9]+ CASES=[0-9]+$/)
        refuse("block " blk ": malformed END-OF-TRANSCRIPT (CHECKS/CASES must be strictly numeric) at " NR ": \"" line "\"")
      endcount++
      endname = $2
      c = $3; sub(/^CHECKS=/, "", c); checks = c + 0
      k = $4; sub(/^CASES=/,  "", k); cases  = k + 0
      state = 3
      next
    }

    # ---- (1b) THE ACCEPTED SECTION FOOTER, LEXICALLY AND SEMANTICALLY -------
    # The R2 grammar checks-footer production admitted FAILURES <any number>.
    # A section could therefore report NINE HUNDRED AND NINETY-NINE FAILURES in
    # its own footer and still be accepted, because every other clause was
    # about counts the profile supplied from OUTSIDE and the one number the
    # section reported about ITSELF was never read.  An accepted section
    # reports no failures, and the zero is a literal: FAILURES 000 is refused
    # too, because a terminator that has to be coerced to a number is not a
    # lexical fact.  This lives in the verifier, not in the grammar file, so
    # that a --grammar override cannot lift it.
    # ---- R3.1: THE FOOTER IS UNIQUE, MANDATORY, AND ITS NUMBERS ARE READ ----
    # R3 refused a footer that was lexically wrong IF ONE WAS PRESENT, and did
    # nothing else with it.  A block with no footer, a block with two, and a
    # block whose footer contradicted both the external profile and its own
    # END-OF-TRANSCRIPT were all accepted — the one line in which a section
    # states its own totals was structurally optional and numerically ignored.
    # It is now counted here, parsed here, and compared in the finalizer against
    # BOTH bindings.
    if (line ~ /^ *CHECKS /) {
      if (line !~ /^CHECKS [0-9]+   FAILURES 0   CASES [0-9]+$/)
        refuse("block " blk ": the section footer at line " NR " is not the exact accepted form \"CHECKS <n>   FAILURES 0   CASES <n>\" — an accepted section reports lexically zero failures: \"" line "\"")
      foot++
      if (foot > 1)
        refuse("block " blk ": a second section footer at line " NR " — exactly one is required per child block: \"" line "\"")
      fchecks = $2 + 0
      fcases  = $6 + 0
    }

    # ---- (2) THE IN-BODY PARCEL_TIP STAMPS ARE A PAIR, NOT FURNITURE -------
    # The probe prelude emits exactly two: probe-header writes one before the
    # first ID-bearing assertion of the section, probe-footer writes one after the
    # section footer and before the PROBE-SECTION-PASS verdict.  R3 checked the
    # VALUE of whichever stamps it happened to see and REQUIRED NONE, so a
    # transcript that lost either stamp, or grew a third, was accepted.  Value,
    # count and POSITION are all enforced here.
    if (line ~ /^ +PARCEL_TIP /) {
      if (line !~ /^ {4}PARCEL_TIP +[0-9a-f]{40}$/)
        refuse("block " blk ": malformed in-body PARCEL_TIP stamp at " NR ": \"" line "\"")
      if ($2 != tip)
        refuse("block " blk ": in-body PARCEL_TIP stamp at " NR " is \"" $2 "\" but the tested tip is \"" tip "\"")
      stamps++
      if (stamps == 1) {
        if (ids > 0)
          refuse("block " blk ": the in-body PARCEL_TIP HEADER stamp at line " NR " comes AFTER " ids " ID-bearing assertion(s); the header stamp of the pair must precede the first one")
        if (foot > 0)
          refuse("block " blk ": the in-body PARCEL_TIP HEADER stamp at line " NR " comes after the section footer; the header stamp of the pair must precede it (the header stamp is missing)")
      } else if (stamps == 2) {
        if (foot != 1)
          refuse("block " blk ": the second in-body PARCEL_TIP stamp at line " NR " does not follow the unique section footer (" foot " footer line(s) seen so far); the footer stamp of the pair belongs after it")
      } else {
        refuse("block " blk ": a third in-body PARCEL_TIP stamp at line " NR " — exactly two are required, a header stamp and a footer stamp")
      }
    }

    # ---- (3) the declared productions and anchors --------------------------
    consumed = 0
    for (i = 1; i <= np; i++) {
      if (line ~ PR[i]) {
        # ---- the one-to-one [PASS] / CHECK-ID pairing, both directions ------
        if (awaiting_id && PN[i] != "check-id")
          refuse("block " blk ": the [PASS] line at " (NR-1) " is not immediately followed by its CHECK-ID line; line " NR " is \"" line "\"")
        if (!awaiting_id && PN[i] == "check-id")
          refuse("block " blk ": CHECK-ID at line " NR " does not immediately follow a [PASS] line")
        if (PN[i] == "verdict-pass") { pass++; awaiting_id = 1 }
        if (PN[i] == "check-id")     { awaiting_id = 0 }
        if (PK[i] == "A") {
          if (match(line, PI[i]) == 0)
            refuse("block " blk ": anchor production \"" PN[i] "\" matched line " NR " but its id-ERE did not: \"" line "\"")
          ids++
          IDS[ids] = norm(substr(line, RSTART, RLENGTH))
        }
        consumed = 1
        break
      }
    }

    if (!consumed) {
      # ---- (4) a reserved structural token that matched nothing -------------
      for (i = 1; i <= nr; i++) {
        if (line ~ RR[i])
          refuse("block " blk ": line " NR " uses the reserved structural token \"" RN[i] "\" but matches no declared production: \"" line "\"")
      }
      if (awaiting_id)
        refuse("block " blk ": a [PASS] line at " (NR-1) " is not followed by its CHECK-ID line")
      # ---- (5) the fallbacks -----------------------------------------------
      for (i = 1; i <= nf; i++) {
        if (line ~ FR[i]) { consumed = 1; break }
      }
    }

    if (!consumed)
      refuse("block " blk ": line " NR " is consumed by NO declared grammar production (nothing is silently ignored): \"" line "\"")
    next
  }

  # ---- (6) AFTER END-OF-TRANSCRIPT: the declared separator, the closing -----
  # stamp, and nothing else.  This is the state R1 did not have.
  if (state == 3) {
    if (line ~ /^={74}$/) { sep++; next }
    if (line ~ /^PARCEL_TIP /) {
      if (NF != 2)
        refuse("block " blk ": malformed closing PARCEL_TIP line at " NR ": \"" line "\"")
      if ($2 != tip)
        refuse("block " blk ": closing PARCEL_TIP is \"" $2 "\" but the tested tip is \"" tip "\"")
      state = 2
      next
    }
    refuse("block " blk " (" XN[blk] "): trailing material after END-OF-TRANSCRIPT at line " NR " — only the declared separator, the closing PARCEL_TIP and CHILD-EXIT 0 are permitted there: \"" line "\"")
  }

  if (state == 2) {
    # ---- THE CHILD TERMINATOR IS A LEXICAL FACT ----------------------------
    # R2 tested it arithmetically: `$2 + 0 != 0`.  the awk string-to-number
    # coercion sends "000", "0x0", "0000000" and " 0 " all to zero, so every
    # one of those spellings was an accepted terminator.  The terminator is now
    # the literal string, compared as a string.  The nonzero case keeps its own
    # message because "a child died" and "a child terminator was misspelled"
    # are different faults and a reader deserves to be told which.
    if (line !~ /^CHILD-EXIT/)
      refuse("block " blk ": expected the child terminator \"CHILD-EXIT 0\" after the closing PARCEL_TIP, got \"" line "\" at line " NR)
    if (line != "CHILD-EXIT 0") {
      if (line ~ /^CHILD-EXIT [1-9][0-9]*$/)
        refuse("block " blk " (" XN[blk] "): " line " — a child exited nonzero")
      refuse("block " blk " (" XN[blk] "): the child terminator at line " NR " is not lexically exactly \"CHILD-EXIT 0\": \"" line "\"")
    }

    # ---- finalize the block, in the order the law lists ----
    if (endcount != 1)
      refuse("block " blk " (" XN[blk] "): " endcount " END-OF-TRANSCRIPT line(s); exactly one is required")
    if (sep != 1)
      refuse("block " blk " (" XN[blk] "): " sep " separator line(s) between END-OF-TRANSCRIPT and the closing PARCEL_TIP; exactly one is required")
    if (secpass != 1)
      refuse("block " blk " (" XN[blk] "): " secpass " PROBE-SECTION-PASS line(s); exactly one is required")
    if (secname != endname)
      refuse("block " blk ": PROBE-SECTION-PASS names \"" secname "\" but END-OF-TRANSCRIPT names \"" endname "\" — they must agree")
    if (secname != XN[blk])
      refuse("block " blk ": section is \"" secname "\" but profile \"" profile "\" expects \"" XN[blk] "\" in that position (missing, reordered or substituted)")

    # ---- R3.1: the section footer, counted, parsed, and doubly bound --------
    if (foot != 1)
      refuse("block " blk " (" XN[blk] "): " foot " section footer line(s); exactly one \"CHECKS <n>   FAILURES 0   CASES <n>\" is required")
    if (fchecks != XK[blk])
      refuse("block " blk " (" XN[blk] "): the section footer declares CHECKS " fchecks " but the PROFILE requires " XK[blk] " (the footer is parsed, not merely shaped)")
    if (fcases != XC[blk])
      refuse("block " blk " (" XN[blk] "): the section footer declares CASES " fcases " but the PROFILE requires " XC[blk])
    if (fchecks != checks)
      refuse("block " blk " (" XN[blk] "): the section footer declares CHECKS " fchecks " but END-OF-TRANSCRIPT declares CHECKS=" checks " — a block must not contradict itself")
    if (fcases != cases)
      refuse("block " blk " (" XN[blk] "): the section footer declares CASES " fcases " but END-OF-TRANSCRIPT declares CASES=" cases " — a block must not contradict itself")

    # ---- R3.1: the in-body stamp pair --------------------------------------
    if (stamps != 2)
      refuse("block " blk " (" XN[blk] "): " stamps " in-body PARCEL_TIP stamp(s); exactly two are required — one before the first ID-bearing assertion, one after the unique section footer")

    if (cases != XC[blk])
      refuse("block " blk " (" XN[blk] "): CASES=" cases " but the profile requires CASES=" XC[blk])
    if (checks != XK[blk])
      refuse("block " blk " (" XN[blk] "): CHECKS=" checks " but the PROFILE requires CHECKS=" XK[blk] " (the count is external; a hollowed section that forges its own header is refused here)")
    if (pass != XK[blk])
      refuse("block " blk " (" XN[blk] "): " pass " [PASS] line(s) but the profile requires " XK[blk])

    # ---- the ordered ID sequence ----
    key = profile ":" XN[blk]
    want = SEQN[key] + 0
    if (ids != want)
      refuse("block " blk " (" XN[blk] "): the block carries " ids " declared ID(s) but its external sequence declares " want)
    for (i = 1; i <= want; i++) {
      if (IDS[i] != SEQ[key, i])
        refuse("block " blk " (" XN[blk] "): ID #" i " is \"" IDS[i] "\" but the external sequence requires \"" SEQ[key, i] "\"")
    }

    totalchecks += checks
    state = 0
    next
  }
}

END {
  if (dead) exit (fatal ? fatal : 1)
  if (state != 0)
    refuse("the transcript ends inside child block " blk " (" XN[blk] "): it was never closed with an END-OF-TRANSCRIPT, a PARCEL_TIP and a CHILD-EXIT")
  if (blk != n) {
    miss = ""
    for (i = blk + 1; i <= n; i++) miss = miss (miss == "" ? "" : ", ") XN[i]
    refuse("missing child block(s): the transcript carries " blk " of the " n " that profile \"" profile "\" requires (absent: " miss ")")
  }
  printf("ACCEPTED: %s  profile=%s blocks=%d checks=%d tip=%s\n", file, profile, blk, totalchecks, tip)
}
' "$F"
RC=$?
[ "$RC" -eq 0 ] && echo "          tip status: $TIP_NOTE"
exit $RC
