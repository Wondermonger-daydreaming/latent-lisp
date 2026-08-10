#!/usr/bin/env bash
# ma0-run.sh — MANY ACTS /0: run one program in one image, or run the suite.
#
# CANDIDATE.  Running a candidate is not adopting it (contract §0, §8), and
# nothing this script prints is independent verification (AP0 adoption Rider 2).
#
#   ./ma0-run.sh                     # the whole suite (spawns one image per scenario)
#   ./ma0-run.sh <scenario>          # ONE scenario, in ONE image
#   ./ma0-run.sh --list              # the scenarios this lane ships
#
# THE RUNNER LAW IS ONE PROGRAM PER IMAGE (contract §5).  Every invocation
# below starts a fresh SBCL; nothing is reused between programs, and the run
# root each image creates lives under $TMPDIR — outside the subject tree — and
# is removed on success AND on failure.
#
# EXIT CODE: whatever the underlying image returned.  0 means the scenario (or
# the suite) reached its declared green end; a lawful program REFUSAL is part
# of that green end, because a refusal is an outcome and not a fault.
#
# — FABER (Claude Opus 5, subagent), 2026-08-09

set -u

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

scenarios=(
  p1
  p2-alpha
  p2-beta
  w-branch-one
  w-branch-exact
  w-derive-ne-perform
  w-auth-unfilled
  w-order-store
  w-no-erase
  w-error-propagates
  w-error-uncaught
)

case "${1:-}" in
  --list)
    printf '%s\n' "${scenarios[@]}"
    exit 0
    ;;
  "")
    exec sbcl --script "$here/ma0-selftest.lisp"
    ;;
  *)
    want="$1"
    for s in "${scenarios[@]}"; do
      if [ "$s" = "$want" ]; then
        exec sbcl --script "$here/ma0-driver.lisp" "$want"
      fi
    done
    echo "ma0-run.sh: unknown scenario '$want'" >&2
    echo "known scenarios:" >&2
    printf '  %s\n' "${scenarios[@]}" >&2
    exit 1
    ;;
esac
