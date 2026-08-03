#!/usr/bin/env bash
#
# load-lisp-plus.sh — the single documented clean-checkout load command.
#
#   bash mneme/load-lisp-plus.sh          (from the subject-tree root)
#   bash <path>/mneme/load-lisp-plus.sh   (from anywhere — cwd does not matter)
#
# Loads the ASDF umbrella system `lisp-plus` into a fresh SBCL image, prints the
# packages that arrived, GATES THE TRANSCRIPT FOR WARNINGS, and exits 0 only if
# the load was actually clean.  Loads nothing into your session, writes nothing
# to the tree, and leaves no fasl cache behind (every component is loaded as
# source in place — see lisp-plus.asd's header for why).
#
# ---------------------------------------------------------------------------
# THE WARNING GATE (added in R1, 2026-08-02)
# ---------------------------------------------------------------------------
#
# The first version of this script printed the load transcript and exited 0.
# That transcript contained 187 Canonical Datum /0 redefinition warnings, the
# exit code said nothing about them, and they were read past.
#
# A command may exit zero and still not be a clean load.  So the transcript is
# now inspected by this script rather than by whoever happens to be looking.
# Any of these makes this command exit NONZERO:
#
#   WARNING: / caught WARNING   a non-style compiler warning reached the transcript
#   undefined variable          a symbol read before it was declared
#   redefining                  something was loaded twice
#   DEFCONSTANT-UNEQL           a constant re-evaluated (the unguarded chain)
#   debugger invoked            an unhandled condition
#   caught N WARNING            a compilation unit finished with warnings
#
# THE ALLOWLIST IS EMPTY AND IS MEANT TO STAY EMPTY.  It exists so that any
# future exception must be written down, named, and justified here in source
# rather than absorbed by a reader's attention.
#
# ---------------------------------------------------------------------------
#
# LOADING IS NOT ADOPTION.  A successful load says that the current construction
# can be brought into one image on SBCL 2.4.6/Linux, cleanly.  It says nothing
# about conformance, validation, or the standing of any lane.  Standing lives in
# the rulings; the current ceiling is
# mneme/integration-baseline-0/CLAIM-CEILING-0.md.
#
# Supported environment: SBCL 2.4.6 on Linux.  No other implementation or
# version has ever been tested.  For the exact supported subsystem load orders,
# see lisp-plus.asd and `bash mneme/load-order-matrix.sh`.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"

# ---------------------------------------------------------------------------
# THE ALLOWLIST.  Empty by intent.  Each entry, if there ever is one, must be a
# fixed substring plus a comment naming who authorized it and why the
# diagnostic cannot be fixed instead.
# ---------------------------------------------------------------------------
ALLOWLIST=()

if ! command -v sbcl >/dev/null 2>&1; then
  echo "!! sbcl not on PATH — this construction requires SBCL 2.4.6/Linux" >&2
  exit 127
fi

# Operation-check the toolchain before trusting any CL run (a standing lab scar:
# the `sbcl` on PATH may be a wrapper script).
SBCL_VERSION="$(sbcl --noinform --non-interactive \
  --eval '(progn (princ (lisp-implementation-version)) (terpri) (finish-output))' 2>/dev/null | tail -1)"
echo "== toolchain: SBCL ${SBCL_VERSION} (supported: 2.4.6/Linux; nothing else tested) =="
if [ "$SBCL_VERSION" != "2.4.6" ]; then
  echo "!! FAIL CLOSED: this load path is authorized for SBCL 2.4.6 only." >&2
  echo "   Observed ${SBCL_VERSION}. No portability is claimed and none may be inferred." >&2
  exit 1
fi

TRANSCRIPT="$(mktemp "${TMPDIR:-/tmp}/lisp-plus-load.XXXXXX")"
trap 'rm -f "$TRANSCRIPT"' EXIT INT TERM

sbcl --noinform --non-interactive \
  --eval '(require :asdf)' \
  --eval '(require :sb-posix)' \
  --eval "(asdf:initialize-source-registry '(:source-registry (:directory \"${ROOT}\") :inherit-configuration))" \
  --eval '(asdf:load-system "lisp-plus")' \
  --eval '(let ((names (sort (mapcar (function package-name)
                                     (remove-if-not
                                       (lambda (p) (and (search "LISP-PLUS-" (package-name p))
                                                        (not (string= (package-name p) "LISP-PLUS-SYSTEM"))))
                                       (list-all-packages)))
                             (function string<))))
             (format t "~%== lisp-plus loaded: ~a principal packages ==~%" (length names))
             (dolist (n names) (format t "   ~a~%" n))
             (format t "~%   (LISP-PLUS-SYSTEM is the ASDF container'"'"'s own helper package,~%")
             (format t "    release-only: it defines no language semantics.)~%"))' \
  2>&1 | tee "$TRANSCRIPT"

LOAD_RC="${PIPESTATUS[0]}"

# ---------------------------------------------------------------------------
# The gate.
# ---------------------------------------------------------------------------
OFFENDERS=""

add_class() {
  local label="$1" pattern="$2"
  local hits n a
  hits="$(grep -nE "$pattern" "$TRANSCRIPT" || true)"
  for a in ${ALLOWLIST+"${ALLOWLIST[@]}"}; do
    [ -n "$hits" ] && hits="$(printf '%s\n' "$hits" | grep -vF -- "$a" || true)"
  done
  [ -z "$hits" ] && return 0
  n="$(printf '%s\n' "$hits" | grep -c . || true)"
  OFFENDERS="${OFFENDERS}
  ${label} — ${n} line(s):
$(printf '%s\n' "$hits" | head -6 | sed 's/^/      /')"
  if [ "$n" -gt 6 ]; then
    OFFENDERS="${OFFENDERS}
      ... and $((n-6)) more"
  fi
}

add_class "non-style compiler WARNING"     '^WARNING:|; caught WARNING'
add_class "undefined variable"             'undefined variable'
add_class "duplicate load (redefining)"    '[Rr]edefining'
add_class "DEFCONSTANT-UNEQL"              'DEFCONSTANT-UNEQL'
add_class "unhandled debugger entry"       'debugger invoked|^Unhandled '
add_class "compilation unit with warnings" 'caught [0-9]+ WARNING'

echo
if [ "$LOAD_RC" -ne 0 ]; then
  echo "== LOAD FAILED — sbcl exited ${LOAD_RC} =="
  exit 1
fi

if [ -n "$OFFENDERS" ]; then
  echo "==========================================================================="
  echo " LOAD-HEALTH GATE FAILED"
  echo "==========================================================================="
  echo " The umbrella loaded and sbcl exited 0, but the transcript is NOT clean."
  echo " The allowlist has ${#ALLOWLIST[@]} entries, so none of these was expected."
  echo "$OFFENDERS"
  echo
  echo " A command that exits zero over a warning storm is not a clean load."
  echo " See lisp-plus.asd — SUPPORTED LOAD ORDERS — and mneme/load-order-matrix.sh."
  echo
  echo "RESULT: FAIL (load-health gate)"
  exit 1
fi

echo "== load transcript is clean: 0 warnings, 0 redefinitions, 0 undefined variables =="
echo "== LOAD OK. Loading is not adoption. =="
exit 0
