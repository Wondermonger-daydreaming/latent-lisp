#!/usr/bin/env bash
#
# PLANTED-FAULTS.sh — Surface /0's two required planted-fault demonstrations.
#
# A control that has never failed is untested, not passing.  This script edits
# surface0.lisp on disk, shows the relevant controls FIRE, restores the file
# from a pristine copy, and VERIFIES THE RESTORATION BY HASH rather than
# assuming it.
#
#   FAULT A  the contract macro silently adds (:VERIFIED-JUDGED-CLAUSE)
#            → the differential clause comparison and the naked-claim refusal
#              must both break
#
#   FAULT B  the derivation control form rewrites the caller's :RECEIVER into a
#            permissive one built from :SUPPORTS — "ergonomics" that erases a
#            live semantic refusal
#            → the inaccessibility control must break
#
# Run: bash PLANTED-FAULTS.sh    (exit 0 iff both faults fired and both
#                                 restorations hash-match)

set -uo pipefail
cd "$(dirname "$0")"
SRC=surface0.lisp
PRISTINE=$(mktemp)
cp "$SRC" "$PRISTINE"
BASE_HASH=$(sha256sum "$SRC" | cut -d' ' -f1)
RC=0

run_suite() { sbcl --non-interactive --load surface0-selftest.lisp 2>&1 | grep -E "^  FAIL|teeth:"; }

restore_and_verify() {  # $1 = label
  cp "$PRISTINE" "$SRC"
  local h; h=$(sha256sum "$SRC" | cut -d' ' -f1)
  if [ "$h" = "$BASE_HASH" ]; then
    echo "   RESTORED and hash-verified after $1  (${h:0:16}…)"
  else
    echo "   !! RESTORATION FAILED after $1"; RC=1
  fi
}

echo
echo "== Surface /0 planted faults =="
echo "   pristine surface0.lisp  ${BASE_HASH:0:16}…"

# ── FAULT A ──────────────────────────────────────────────────────────────────
echo
echo "-- FAULT A: the contract macro silently adds (:verified-judged-claim) --"
python3 - <<'PY'
p='surface0.lisp'; s=open(p).read()
a="            :accepted-clauses ',clauses"
b="            :accepted-clauses ',(cons '(:verified-judged-claim) clauses) ; PLANTED FAULT A"
assert s.count(a)==1, s.count(a)
open(p,'w').write(s.replace(a,b))
PY
echo "   controls that FIRED:"
run_suite | sed 's/^/     /'
restore_and_verify "FAULT A"

# ── FAULT B ──────────────────────────────────────────────────────────────────
echo
echo "-- FAULT B: the control form rewrites :receiver into a permissive one --"
python3 - <<'PY'
p='surface0.lisp'; s=open(p).read()
a = """    (%check-operation form operation 'lisp-plus-slice2:derive/2)
    (multiple-value-bind (granted refused-var refused) (%parse-arms form arms)
      (let ((c (or refused-var (gensym "COND"))))
        `(handler-case
             (multiple-value-bind (,claim ,receipt ,derivation-basis) ,operation"""
b = """    (%check-operation form operation 'lisp-plus-slice2:derive/2)
    ;; PLANTED FAULT B — rewrite the caller's :RECEIVER into one that reaches
    ;; every offered support.  Presented as ergonomics; erases a live refusal.
    (let* ((%p (copy-list (rest operation)))
           (%sup (getf %p :supports)))
      (setf (getf %p :receiver)
            `(lisp-plus-slice0:receiver-context
              :context-id :surface-desk
              :accessible-supports
              (mapcan (lambda (s)
                        (cond ((lisp-plus-slice2:source-basis-p s)
                               (list (lisp-plus-slice2:source-basis-identity s)))
                              ((lisp-plus-slice2:derivation-basis-p s)
                               (list (lisp-plus-slice2:derivation-basis-identity s)))
                              ((lisp-plus-slice0:witness-p s)
                               (list (lisp-plus-slice0:witness-id s)))
                              ((lisp-plus-slice0:claim-p s)
                               (list (lisp-plus-slice0:claim-id s)))))
                      ,%sup)))
      (setf operation (cons (first operation) %p)))
    (multiple-value-bind (granted refused-var refused) (%parse-arms form arms)
      (let ((c (or refused-var (gensym "COND"))))
        `(handler-case
             (multiple-value-bind (,claim ,receipt ,derivation-basis) ,operation"""
assert s.count(a)==1, s.count(a)
open(p,'w').write(s.replace(a,b))
PY
echo "   controls that FIRED:"
run_suite | sed 's/^/     /'
restore_and_verify "FAULT B"

# ── clean ────────────────────────────────────────────────────────────────────
echo
echo "-- restored: the suite is green again --"
run_suite | sed 's/^/     /'
rm -f "$PRISTINE"
echo
if [ "$RC" -eq 0 ]; then
  echo "== both faults fired; both restorations hash-verified =="
else
  echo "== RESTORATION PROBLEM — do not commit =="
fi
exit "$RC"
