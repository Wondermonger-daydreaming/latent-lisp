#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$ROOT/../.." && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
export PYTHONDONTWRITEBYTECODE=1
export LAE_NETWORK_MODE=off

run_floor() {
  local name="$1"
  shift
  if "$@" >"$WORK/$name.log" 2>&1; then
    printf 'PASS  %s\n' "$name"
  else
    printf 'FAIL  %s\n' "$name"
    tail -80 "$WORK/$name.log"
    exit 1
  fi
}

run_floor mneme-existing-floor bash "$REPO/mneme/verify-all.sh"
run_floor design-reproduction python3 "$ROOT/harness/design.py" --check
run_floor packet-unit-and-mutation-tests python3 "$ROOT/tests/test_packet.py"
run_floor preauthorship-unit-tests python3 "$ROOT/tests/test_preauthorship.py"
run_floor preauthorship-schema-lineage-mutations python3 "$ROOT/harness/preauthorship.py" verify
run_floor synthetic-precision-replay python3 "$ROOT/harness/precision.py" --check
run_floor claim-ceiling-lint python3 "$ROOT/harness/claim_lint.py" "$ROOT/README.md" "$ROOT/evidence/README.md" "$ROOT/evidence/analysis/SYNTHETIC-PRECISION-REPORT.json" "$ROOT"/evidence/branch/*.json
run_floor manifest-lineage-protected python3 "$ROOT/harness/manifest.py" check
run_floor key-open-denial python3 "$ROOT/harness/run.py" --output "$WORK/unused" --prove-key-denial

if python3 "$ROOT/harness/manifest.py" exposure-readiness >"$WORK/exposure-readiness.log" 2>&1; then
  printf 'FAIL  unresolved-owner-exposure-refusal\n'
  exit 1
elif grep -q 'OwnerResolutionRequired' "$WORK/exposure-readiness.log"; then
  printf 'PASS  unresolved-owner-exposure-refusal\n'
else
  printf 'FAIL  unresolved-owner-exposure-refusal\n'
  tail -40 "$WORK/exposure-readiness.log"
  exit 1
fi

if [ -e "$REPO/experiments/mneme-enforcement-prototype" ]; then
  printf 'FAIL  p2a-absent\n'
  exit 1
fi
printf 'PASS  p2a-absent\n'

python3 - "$ROOT/evidence/NETWORK-CALL-CENSUS.json" >"$WORK/census.log" <<'PY'
import json, sys
record = json.load(open(sys.argv[1], encoding="utf-8"))
assert record["network_calls"] == 0
assert record["live_provider_calls"] == 0
assert record["real_item_model_exposures"] == 0
assert record["real_item_grader_exposures"] == 0
assert record["pilot_verdicts"] == 0
PY
printf 'PASS  zero-network-and-exposure-census\n'

printf 'ALL PILOT PACKET FLOORS HOLD — 12/12 network-off checks green.\n'
