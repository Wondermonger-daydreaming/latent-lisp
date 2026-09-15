#!/usr/bin/env bash
# identity-after.sh <root> <pinned-sha256-list> — the "restore" check, factored out per Astra's R2 (2026-09-15).
# Verifies every pinned file under <root> with `sha256sum -c`, prints the verifier's own output, and EXITS WITH THE VERIFIER'S STATUS:
#   0 = every pinned file present and byte-equal · 1 = sha256sum reported a mismatch or a missing file · 2 = an input of this script is
#   missing/unreadable (the check could not be made — an absence without a warrant, never a pass). The caller (p10-runner.sh) must consume
#   this status; a string search of the output is not a check.
set -u
ROOT="${1:-}"; PINNED="${2:-}"
[ -n "$ROOT" ] && [ -n "$PINNED" ] || { echo "identity-after: usage: identity-after.sh <root> <pinned-list>"; exit 2; }
[ -d "$ROOT" ] || { echo "identity-after: root absent: $ROOT"; exit 2; }
[ -r "$PINNED" ] || { echo "identity-after: pinned list absent/unreadable: $PINNED"; exit 2; }
PINNED="$(cd "$(dirname "$PINNED")" && pwd)/$(basename "$PINNED")"   # absolute: the check runs inside <root>
ROWS="$(grep -cE '^[0-9a-f]{64}  ' "$PINNED" || true)"
[ "$ROWS" -gt 0 ] || { echo "identity-after: pinned list has 0 rows — refusing (a vacuous check is not a check)"; exit 2; }
echo "identity-after: root=$ROOT list=$PINNED rows=$ROWS date=$(date --iso-8601=seconds)"
( cd "$ROOT" && sha256sum -c "$PINNED" ); rc=$?
echo "identity-after: sha256sum -c exit $rc"
exit $rc
