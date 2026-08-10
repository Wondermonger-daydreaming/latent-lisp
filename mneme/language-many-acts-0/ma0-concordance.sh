#!/usr/bin/env bash
#
# ma0-concordance.sh — the concordance teeth, one command.
#
# CANDIDATE.  Running a candidate is not adopting it (contract §0, §8), and
# nothing this script prints is independent verification (AP0 adoption Rider 2).
#
#   ./ma0-concordance.sh                       # the comparison
#   ./ma0-concordance.sh --tooth <arm>:<facet> # plant one divergence; must go RED
#
# The comparator spawns its own sub-images (one canonical, one per arm, plus the
# adopted lane's own runner for the setup audit).  This file only chooses the
# image and carries the tooth through.
#
# Sentinel on the green path: ma0-concordance: 4 arms, 72 facets, 0 divergences
#
# — DENS (Claude Opus 5, subagent), 2026-08-09

set -u
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "${1:-}" = "--tooth" ]; then
  [ $# -ge 2 ] || { echo "ma0-concordance.sh: --tooth needs <arm>:<facet>" >&2; exit 2; }
  export MA0_CONCORD_PLANT_DIVERGENCE="$2"
  echo "-- tooth planted: $MA0_CONCORD_PLANT_DIVERGENCE (a GREEN run here is a FAILURE of the comparator) --"
fi

exec sbcl --script "$here/ma0-concordance.lisp"
