#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
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
    tail -100 "$WORK/$name.log"
    exit 1
  fi
}

run_floor tranche-b-unit-mutation-replay python3 "$ROOT/tests/test_tranche_b.py"
run_floor inherited-packet-tests python3 "$ROOT/tests/test_packet.py"
run_floor inherited-preauthorship-tests python3 "$ROOT/tests/test_preauthorship.py"
run_floor inherited-preauthorship-mutations python3 "$ROOT/harness/preauthorship.py" verify
run_floor inherited-design-reproduction python3 "$ROOT/harness/design.py" --check
run_floor protected-scope python3 "$ROOT/harness/manifest.py" protected
run_floor construction-manifest python3 "$ROOT/harness/manifest.py" check

printf 'TRANCHE B TARGETED VERIFICATION: PASS 7/7 network-off floors green.\n'
