#!/usr/bin/env bash
# run-selftest.sh — REPL /0's focused checks, with the host stack the REPL uses.
#   bash mneme/language-repl-0/run-selftest.sh      (exit 0 iff every check passed)
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE" && exec sbcl --noinform --control-stack-size 64MB --non-interactive --load repl0-selftest.lisp
