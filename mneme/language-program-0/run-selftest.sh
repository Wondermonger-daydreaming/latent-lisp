#!/usr/bin/env bash
# run-selftest.sh — PROGRAM /0's focused tests, with the host stack the runner uses.
#   bash mneme/language-program-0/run-selftest.sh      (exit 0 iff every check passed)
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE" && exec sbcl --noinform --control-stack-size 64MB --non-interactive --load program0-selftest.lisp
