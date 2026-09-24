#!/usr/bin/env bash
# lisp-plus-run.sh — THE ONE COMMAND: run a Lisp+ program file.
#
#   bash mneme/language-program-0/lisp-plus-run.sh <program.lp>
#
# Equivalent to `sbcl --script run.lisp <program.lp>` with the host control stack
# raised (64 MB), so that the LANGUAGE's depth ceiling (*depth-limit*, 4000
# user frames) is reached before the HOST's — a runaway recursion is refused
# with E-BUDGET and a location, never a host backtrace. Exit codes are run.lisp's:
# 0 value · 1 host fault · 2 language error · 3 usage.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ $# -ne 1 ]; then
  echo "usage: bash mneme/language-program-0/lisp-plus-run.sh <program.lp>" >&2
  exit 3
fi
command -v sbcl >/dev/null 2>&1 || { echo "lisp-plus: sbcl not found on PATH (declared: SBCL 2.4.6)" >&2; exit 1; }
exec sbcl --control-stack-size 64MB --script "$HERE/run.lisp" "$1"
