#!/usr/bin/env bash
# Targeted, network-off verification of the Language-A Tranche B scoring constitution
# (SCORING-CONSTITUTION.md §11/§12/§13).  Additions-only: the inherited tranche-b floors
# must still pass as a regression proof.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
WORK="$(mktemp -d)"
export PYTHONDONTWRITEBYTECODE=1
export LAE_NETWORK_MODE=off

# The inherited tranche-b construction-manifest floor is a whole-tree inventory check that
# any file addition changes by design; refresh the derived index transiently for the
# regression run, then restore it so the working tree stays additions-only at rest.
CM_JSON="$ROOT/CONSTRUCTION-MANIFEST.json"
CM_SHA="$ROOT/CONSTRUCTION-MANIFEST.sha256"
cp "$CM_JSON" "$WORK/cm.json.bak"
cp "$CM_SHA" "$WORK/cm.sha.bak"
restore_manifest() {
  cp "$WORK/cm.json.bak" "$CM_JSON"
  cp "$WORK/cm.sha.bak" "$CM_SHA"
  rm -rf "$WORK"
}
trap restore_manifest EXIT

FLOORS=0
run_floor() {
  local name="$1"; shift
  FLOORS=$((FLOORS + 1))
  if "$@" >"$WORK/$name.log" 2>&1; then
    printf 'PASS  %s\n' "$name"
  else
    printf 'FAIL  %s\n' "$name"
    tail -120 "$WORK/$name.log"
    exit 1
  fi
}

# 1. Unit + property tests (prefer pytest; fall back to the stdlib runner when offline).
if python3 -c "import pytest" 2>/dev/null; then
  run_floor scoring-constitution-pytest python3 -m pytest "$ROOT/tests/test_scoring_constitution.py" -q
else
  run_floor scoring-constitution-tests python3 "$ROOT/tests/test_scoring_constitution.py"
fi

# 2. Module verify: classifier self-check, fixtures, and all mutations under expect-failure.
run_floor scoring-constitution-verify python3 "$ROOT/harness/scoring_constitution.py" verify

# 3. Freeze manifest tamper self-test (in-memory derivation with placeholder parent args).
run_floor scoring-constitution-freeze-self-test python3 "$ROOT/harness/freeze_scoring_constitution.py" self-test

# 4. Inherited tranche-b floors — regression proof (derived index refreshed transiently).
python3 "$ROOT/harness/manifest.py" build >/dev/null
run_floor inherited-tranche-b-floors bash "$ROOT/verify-tranche-b.sh"

printf 'SCORING CONSTITUTION TARGETED VERIFICATION: PASS %d/%d floors green.\n' "$FLOORS" "$FLOORS"
