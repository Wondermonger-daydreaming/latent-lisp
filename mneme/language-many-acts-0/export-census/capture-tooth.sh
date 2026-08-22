#!/usr/bin/env bash
# capture-tooth.sh — MA0 EXPORT CENSUS /0: transcript capture harness.
#
# Runs the census and writes a transcript with a truthful, DIRECTLY CAPTURED
# exit code.  Written after the first capture attempt reported "OBSERVED EXIT:
# 0" for a run that had plainly refused: the exit code had been read with
# ${PIPESTATUS[0]} after an intervening `echo', so it described the echo and
# not the gate.  The gate was right and the transcript was wrong, which is the
# more dangerous of the two failures — a transcript is evidence, and evidence
# that misreports an exit code is worse than no transcript at all.
#
#   ./capture-tooth.sh <out-file> <header-file>
#
# — Claude Opus (agent CENSOR), 2026-08-10

set -uo pipefail

out="${1:?usage: capture-tooth.sh <out-file> <header-file>}"
hdr="${2:?usage: capture-tooth.sh <out-file> <header-file>}"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

body="$(mktemp)"; trap 'rm -f "$body"' EXIT
"$here/ma0-export-census.sh" > "$body" 2>&1
rc=$?

{
  cat "$hdr"
  echo
  cat "$body"
  echo
  echo "=========================================================="
  echo "OBSERVED EXIT: $rc   (captured directly from the gate process)"
} > "$out"

echo "wrote $out (gate exit $rc)"
exit 0
