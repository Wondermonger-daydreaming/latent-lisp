#!/usr/bin/env bash
#
# semantic-path-diff.sh — Evidence Addendum 0.1, §A3.
#
# THE CLAIM: this addendum changed NO EXECUTABLE SEMANTICS in the production layer
# or in any predecessor it depends on.  A claim of that shape is worth nothing
# unless it names the paths it covers and shows the diff being empty over them.
#
# METHOD: an EXACT PATH-RESTRICTED `git diff` across THIS ADDENDUM'S OWN COMMIT
# WINDOW, per layer.  Restricted BY PATH, never by basename — this lane has a
# scar from excluding by basename (Language Form /1, 2026-07-27).
#
# WHAT WOULD MAKE THIS FAIL HONESTLY: any change under any listed path INSIDE THE
# ADDENDUM'S WINDOW.  The script does NOT whitelist "harmless" edits inside those
# paths.  If a byte moved in `surface1.lisp` between BASE and TARGET, this reports
# it and exits nonzero, and the addendum is a scope violation rather than an
# addendum.
#
# ---------------------------------------------------------------------------
# WINDOW REPAIR — Integration Baseline /0, 2026-08-02 (release engineering only)
# ---------------------------------------------------------------------------
#
# THE DEFECT.  This script originally diffed BASE against THE WORKING TREE.  That
# window has no upper bound, so it grew every time the repository moved, for any
# reason whatsoever.  By 2026-08-02 it reported
#
#     SCOPE VIOLATION — 8 file(s) changed under a restricted path
#
# and exited 1.  All eight files were `language-form-2/de-vadimonio/*` — the
# second-tenant obligation work that landed at `f9762349`, which is a strict
# DESCENDANT of this addendum (`git merge-base --is-ancestor 4a967089 f9762349`
# → true; the reverse → false).  The instrument could no longer distinguish
# "the addendum moved something" from "the repository moved on."
#
# THE REPAIR.  The window now ENDS at the addendum's own landing commit, which is
# a fixed historical fact and can never again be falsified by later work:
#
#     BASE   = 431fee16   the published Errata 0.3 target
#     TARGET = 4a967089   this addendum's landing commit
#
# Over that exact window, across all eight restricted paths, `git diff --name-only`
# returns ZERO files.  The addendum's claim was TRUE the whole time; only the
# measurement was wrong.  NO SEMANTIC VERDICT CHANGED HERE — the production layer
# and every dependency named below were byte-identical to the published target
# before this repair and are byte-identical to it after.
#
# Working-tree drift since the addendum landed is still shown, in its own clearly
# labelled section below, as INFORMATION.  It is exit-neutral by design: later
# authorized repository movement is not this addendum's scope violation, and an
# instrument that says otherwise is auditing a different claim than the one it
# names at the top of this file.
set -uo pipefail

BASE="${1:-431fee16}"
TARGET="${2:-4a967089}"
REPO="$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)"
M="experiments/latent-lisp/mneme"

for ref in "$BASE" "$TARGET"; do
  if ! git -C "$REPO" rev-parse --verify --quiet "${ref}^{commit}" >/dev/null 2>&1; then
    echo "SEMANTIC-PATH DIFF — Evidence Addendum 0.1"
    echo "  UNRESOLVABLE REF: ${ref} is not a commit in this checkout."
    echo "  (A shallow or filtered clone cannot answer this question.  That is a"
    echo "   missing input, not a passing audit — refusing to report either way.)"
    exit 2
  fi
done

echo "SEMANTIC-PATH DIFF — Evidence Addendum 0.1"
echo "base   (published Errata 0.3 target) : ${BASE}"
echo "target (this addendum's own landing) : ${TARGET}"
echo "window                               : ${BASE}..${TARGET}   (bounded — see header)"
echo "restriction                          : EXACT PATHS, never basenames"
echo

# The layers that must not move, each named as an exact path prefix.
declare -a LAYERS=(
  "Canonical Datum /0:${M}/../canonical-datum"
  "Surface /0:${M}/language-surface-0"
  "Form /0:${M}/language-form-0"
  "Form /1:${M}/language-form-1"
  "Form /2:${M}/language-form-2"
  "Slice /1:${M}/language-slice-1"
  "Slice /2:${M}/language-slice-2"
)
# Surface /1's PRODUCTION implementation — the two files that are the layer
# itself, as distinct from the evidence apparatus around them.
declare -a S1_PROD=(
  "${M}/language-surface-1/surface1.lisp"
  "${M}/language-surface-1/package.lisp"
)

VIOL=0

for entry in "${LAYERS[@]}"; do
  name="${entry%%:*}"; path="${entry#*:}"
  path="$(cd "$REPO" && cd "$(dirname "$path")" 2>/dev/null && pwd)/$(basename "$path")"
  rel="${path#$REPO/}"
  out="$(git -C "$REPO" diff --stat "$BASE" "$TARGET" -- "$rel")"
  n="$(git -C "$REPO" diff --name-only "$BASE" "$TARGET" -- "$rel" | wc -l)"
  if [ "$n" -eq 0 ]; then
    printf '  UNCHANGED  %-24s %s\n' "$name" "$rel/"
  else
    VIOL=$((VIOL+n))
    printf '  !! CHANGED %-24s %s   (%d file(s))\n' "$name" "$rel/" "$n"
    printf '%s\n' "$out" | sed 's/^/       /'
  fi
done

echo
echo "  Surface /1 PRODUCTION implementation (the layer, not its apparatus):"
for rel in "${S1_PROD[@]}"; do
  n="$(git -C "$REPO" diff --name-only "$BASE" "$TARGET" -- "$rel" | wc -l)"
  if [ "$n" -eq 0 ]; then
    printf '  UNCHANGED  %s\n' "$rel"
  else
    VIOL=$((VIOL+n))
    printf '  !! CHANGED %s\n' "$rel"
    git -C "$REPO" diff --stat "$BASE" "$TARGET" -- "$rel" | sed 's/^/       /'
  fi
done

echo
echo "  THIS ADDENDUM ALONE — everything it touched under language-surface-1/,"
echo "  over the exact window ${BASE}..${TARGET}:"
git -C "$REPO" diff --name-status "$BASE" "$TARGET" -- "${M}/language-surface-1" | sed 's/^/    /'

echo
echo "  ------------------------------------------------------------------------"
echo "  LATER REPOSITORY MOVEMENT — INFORMATION ONLY, EXIT-NEUTRAL."
echo "  ------------------------------------------------------------------------"
echo "  What has moved under the restricted paths AFTER this addendum landed"
echo "  (${TARGET}..HEAD, plus anything uncommitted).  None of it is this"
echo "  addendum's doing and none of it can make this audit fail: a bounded"
echo "  historical claim is not falsified by subsequent authorized work."
LATER=0
for entry in "${LAYERS[@]}"; do
  name="${entry%%:*}"; path="${entry#*:}"
  path="$(cd "$REPO" && cd "$(dirname "$path")" 2>/dev/null && pwd)/$(basename "$path")"
  rel="${path#$REPO/}"
  n="$(git -C "$REPO" diff --name-only "$TARGET" HEAD -- "$rel" | wc -l)"
  if [ "$n" -ne 0 ]; then
    LATER=$((LATER+n))
    printf '    later: %-22s %s   (%d file(s) since %s)\n' "$name" "$rel/" "$n" "$TARGET"
  fi
done
UNCOMMITTED="$(git -C "$REPO" status --porcelain -- "${M}/language-surface-1" | sed 's/^/    uncommitted: /')"
[ -n "$UNCOMMITTED" ] && printf '%s\n' "$UNCOMMITTED"
[ "$LATER" -eq 0 ] && [ -z "$UNCOMMITTED" ] && echo "    (nothing — the restricted paths have not moved since ${TARGET} either)"

echo
if [ "$VIOL" -eq 0 ]; then
  echo "  NO PRODUCTION OR DEPENDENCY PATH MOVED.  0 files changed across all eight"
  echo "  restricted paths.  The version integers, the grammar, the procedure, the"
  echo "  policy, the public API, the receipts, the occurrences and the macroexpansion"
  echo "  semantics are byte-identical to the published Errata 0.3 target."
  exit 0
else
  echo "  SCOPE VIOLATION — ${VIOL} file(s) changed under a restricted path."
  echo "  STOP.  Do not expand this addendum into a semantic repair."
  exit 1
fi
