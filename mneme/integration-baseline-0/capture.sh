#!/usr/bin/env bash
#
# capture.sh — run a command and write an identity-bound transcript.
#
#   bash mneme/integration-baseline-0/capture.sh <outfile> <command...>
#
# Every final transcript must begin with the exact full HEAD and the exact
# command being captured. The accepted runners (lisp-plus.asd,
# load-lisp-plus.sh, load-order-matrix.sh) are FROZEN and may not be edited to
# print a header, so the header is added here, around them.
#
# R2's parcel shipped transcripts that could not be tied to a commit without
# trusting the surrounding prose. A transcript that does not name its own HEAD
# is an anecdote.
#
# The wrapper's own exit status is the wrapped command's exit status.

set -uo pipefail
[ $# -ge 2 ] || { echo "usage: capture.sh <outfile> <command...>" >&2; exit 2; }

OUT="$1"; shift
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
mkdir -p "$(dirname "$OUT")"

HEAD_FULL="$(git -C "$ROOT" rev-parse HEAD 2>/dev/null || echo 'NOT-A-GIT-CHECKOUT')"
SUBTREE="$(git -C "$ROOT" rev-parse HEAD:experiments/latent-lisp 2>/dev/null \
           || git -C "$ROOT" rev-parse 'HEAD^{tree}' 2>/dev/null || echo 'n/a')"

{
  echo "=========================================================================="
  echo "TRANSCRIPT-HEAD      : $HEAD_FULL"
  echo "TRANSCRIPT-SUBTREE   : $SUBTREE"
  echo "TRANSCRIPT-COMMAND   : $*"
  echo "TRANSCRIPT-CWD       : $ROOT"
  echo "TRANSCRIPT-DATE      : $(date -Iseconds)"
  echo "TRANSCRIPT-SBCL      : $(sbcl --noinform --non-interactive \
        --eval '(progn (princ (lisp-implementation-version)) (terpri) (finish-output))' 2>/dev/null | tail -1)"
  echo "=========================================================================="
  echo
} > "$OUT"

( cd "$ROOT" && "$@" ) >> "$OUT" 2>&1
rc=$?

{
  echo
  echo "=========================================================================="
  echo "TRANSCRIPT-EXIT      : $rc"
  echo "TRANSCRIPT-HEAD-END  : $(git -C "$ROOT" rev-parse HEAD 2>/dev/null || echo n/a)"
  echo "=========================================================================="
} >> "$OUT"

exit $rc
