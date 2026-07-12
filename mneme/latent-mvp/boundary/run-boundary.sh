#!/usr/bin/env bash
# run-boundary.sh — orchestrate the Mneme L5/L6/L7 test across a REAL process boundary.
#
# Two separate SBCL images with NO shared runtime state: process A freezes verified state
# to disk and EXITS (its capabilities, mints, and registries die with it); process B boots
# fresh and must reconstruct from bytes alone, refuse to honor the serialized 'verified'
# grade until it re-authenticates, and refuse every planted forgery. exit 0 == the law
# holds across the gap. (Style mirrors the atelier's run-all.sh.)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
STORE="${1:-/tmp/mneme-boundary-store}"

# A clean store each run — nothing of a previous run may leak into this one.
rm -rf "$STORE"
mkdir -p "$STORE"

printf '\n===== PROCESS A — freeze (image 1) =====\n'
sbcl --script "$ROOT/boundary-freeze.lisp" "$STORE"

printf '\n(process A has exited; its image and every live capability are gone)\n'

printf '\n===== PROCESS B — revive (image 2, fresh) =====\n'
sbcl --script "$ROOT/boundary-revive.lisp" "$STORE"

printf '\nBoundary conformance holds across a real process image gap (both scripts exit 0).\n'
