#!/usr/bin/env bash
#
# run-helper-control.sh — driver for the §A2 helper-resolution negative control.
#
# WHERE THE MUTATION GOES.  Arm 3 of the control DELIBERATELY interns a name into
# LISP-PLUS-CD0 — that is the defect being exhibited.  The mutation happens in a
# THROWAWAY SBCL IMAGE launched from a scratch directory and dies with it; the
# control file opens the tree for READING only and writes nothing.  This driver
# proves the containment by checking the tree is byte-unchanged afterwards, rather
# than asserting it.
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
S1="$(cd "$HERE/../../.." && pwd)"
SCRATCH="$(mktemp -d)"
trap 'rm -rf "$SCRATCH"' EXIT

echo "driver        : $0"
echo "subject tree  : $S1"
echo "scratch cwd   : (a throwaway directory; the SBCL image dies with it)"
echo "SBCL          : $(sbcl --non-interactive --eval '(progn (princ (lisp-implementation-version)) (terpri))' 2>/dev/null | tail -1)"

BEFORE="$(cd "$S1" && find . -name '*.lisp' -type f -print0 | sort -z | xargs -0 sha256sum | sha256sum | cut -d' ' -f1)"

( cd "$SCRATCH" && sbcl --non-interactive --load "$HERE/helper-resolution-control.lisp" "$S1/" )
RC=$?

AFTER="$(cd "$S1" && find . -name '*.lisp' -type f -print0 | sort -z | xargs -0 sha256sum | sha256sum | cut -d' ' -f1)"

echo
echo "CONTAINMENT — the tree's .lisp files, rolled to one digest, before and after:"
echo "  before ${BEFORE}"
echo "  after  ${AFTER}"
if [ "$BEFORE" = "$AFTER" ]; then
  echo "  UNCHANGED — the control mutated only its own image."
else
  echo "  !! CHANGED — the control wrote to the tree.  Treat this run as void."
  exit 1
fi
exit "$RC"
