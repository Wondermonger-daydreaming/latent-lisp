#!/usr/bin/env bash
# lisp-plus-repl.sh — THE ONE COMMAND for REPL /0 (candidate).
#
#   bash mneme/language-repl-0/lisp-plus-repl.sh                  command-line REPL
#   bash mneme/language-repl-0/lisp-plus-repl.sh --web [--port N]  browser workbench on
#                                                                  http://127.0.0.1:N/ (default 4917)
#
# Paths are relative to the latent-lisp root (the public repository root, or
# experiments/latent-lisp/ in the lab). Same host stack as the file runner
# (lisp-plus-run.sh): 64 MB, so the LANGUAGE's depth ceiling speaks before the host's.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
command -v sbcl >/dev/null 2>&1 || { echo "lisp-plus-repl: sbcl not found on PATH (declared: SBCL 2.4.6)" >&2; exit 1; }
exec sbcl --control-stack-size 64MB --script "$HERE/main.lisp" "$@"
