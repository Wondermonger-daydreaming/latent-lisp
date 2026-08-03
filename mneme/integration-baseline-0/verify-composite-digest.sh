#!/usr/bin/env bash
#
# verify-composite-digest.sh — derive the composite reconstruction digest from
#                              the transcript and check it against the lane's
#                              own declared value. Nothing is typed by hand.
#
#   bash mneme/integration-baseline-0/verify-composite-digest.sh <composite-transcript>
#
# R2's return quoted the digest as a literal typed into prose. A digest a human
# copied is a claim; a digest extracted from the run and matched against the
# lane's own record is evidence. Both sides here are read from files.

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
TRANSCRIPT="${1:-}"
[ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ] || { echo "!! usage: verify-composite-digest.sh <transcript>" >&2; exit 2; }

RETURN_DOC="$ROOT/mneme/vertical0/VERTICAL-0-RETURN.md"
[ -f "$RETURN_DOC" ] || { echo "!! missing $RETURN_DOC" >&2; exit 2; }

# (a) the digest the LANE declares, read from its own return document
DECLARED="$(grep -ohE '\b[0-9a-f]{64}\b' "$RETURN_DOC" | sort | uniq -c | sort -rn | head -1 | awk '{print $2}')"

# (b) the digest the RUN produced, read from the transcript
OBSERVED="$(grep -ohE '\b[0-9a-f]{64}\b' "$TRANSCRIPT" | sort | uniq -c | sort -rn | head -1 | awk '{print $2}')"

echo "composite transcript : $TRANSCRIPT"
echo "declared by the lane : ${DECLARED:-<none found>}   (from VERTICAL-0-RETURN.md)"
echo "observed in this run : ${OBSERVED:-<none found>}   (from the transcript)"
echo "occurrences in run   : $(grep -cF "${OBSERVED:-__none__}" "$TRANSCRIPT" 2>/dev/null || echo 0)"

if [ -z "$DECLARED" ] || [ -z "$OBSERVED" ]; then
  echo "RESULT: FAIL — a digest could not be extracted from one of the two sources" >&2
  exit 1
fi
if [ "$DECLARED" != "$OBSERVED" ]; then
  echo "RESULT: FAIL — the run's digest does not match the lane's declared digest" >&2
  exit 1
fi
echo "RESULT: MATCH — both sides extracted mechanically, neither typed"
exit 0
