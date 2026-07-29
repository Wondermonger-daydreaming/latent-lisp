#!/usr/bin/env bash
#
# semantic-path-diff.sh — Evidence Addendum 0.1, §A3.
#
# THE CLAIM: this addendum changed NO EXECUTABLE SEMANTICS in the production layer
# or in any predecessor it depends on.  A claim of that shape is worth nothing
# unless it names the paths it covers and shows the diff being empty over them.
#
# METHOD: an EXACT PATH-RESTRICTED `git diff` from the published Errata 0.3 target
# to the working tree, per layer.  Restricted BY PATH, never by basename — this
# lane has a scar from excluding by basename (Language Form /1, 2026-07-27).
#
# WHAT WOULD MAKE THIS FAIL HONESTLY: any change under any listed path.  The script
# does NOT whitelist "harmless" edits inside those paths.  If a byte moved in
# `surface1.lisp`, this reports it and exits nonzero, and the addendum is a scope
# violation rather than an addendum.
set -uo pipefail

BASE="${1:-431fee16}"
REPO="$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)"
M="experiments/latent-lisp/mneme"

echo "SEMANTIC-PATH DIFF — Evidence Addendum 0.1"
echo "base (published Errata 0.3 target) : ${BASE}"
echo "target                             : the working tree"
echo "restriction                        : EXACT PATHS, never basenames"
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
  out="$(git -C "$REPO" diff --stat "$BASE" -- "$rel")"
  n="$(git -C "$REPO" diff --name-only "$BASE" -- "$rel" | wc -l)"
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
  n="$(git -C "$REPO" diff --name-only "$BASE" -- "$rel" | wc -l)"
  if [ "$n" -eq 0 ]; then
    printf '  UNCHANGED  %s\n' "$rel"
  else
    VIOL=$((VIOL+n))
    printf '  !! CHANGED %s\n' "$rel"
    git -C "$REPO" diff --stat "$BASE" -- "$rel" | sed 's/^/       /'
  fi
done

echo
echo "  EVERYTHING THAT MOVED UNDER language-surface-1/ SINCE ${BASE}, for contrast."
echo "  NB: this window includes the TWO COMMITS THAT FOLLOWED the published target"
echo "  (1ae509eb, which untracked the audit parcel zip, and 9faf9f3d, which added"
echo "  the relay parcel).  Those are NOT this addendum's changes; the second list"
echo "  isolates what this addendum alone did."
git -C "$REPO" diff --name-status "$BASE" -- "${M}/language-surface-1" \
  | grep -vE "surface1\.lisp|package\.lisp" | sed 's/^/    /'
git -C "$REPO" status --porcelain -- "${M}/language-surface-1" | grep '^??' | sed 's/^/    /'

echo
echo "  THIS ADDENDUM ALONE — diffed against HEAD, not against the published target:"
git -C "$REPO" diff --name-status HEAD -- "${M}/language-surface-1" | sed 's/^/    /'
git -C "$REPO" status --porcelain -- "${M}/language-surface-1" | grep '^??' | sed 's/^/    /'
echo "    (three files touched: the runner's gate, the selftest's CD0 helper, and"
echo "     RUN-EXITCODES.txt as a consequence of rerunning.  Plus one new directory.)"

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
