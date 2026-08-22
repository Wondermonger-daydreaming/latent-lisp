;;;; act1-readiness.lisp — One Act /1: the LAST-LOADED source, whose LAST FORM
;;;; is the lane's readiness carrier.
;;;;
;;;; PACKAGE EXISTENCE IS NOT IMPLEMENTATION READINESS.  This lane is in the
;;;; COMPLETENESS-CHECKED class (lisp-plus.asd:36-58): a `find-package` guard
;;;; certifies a half-built or empty lane as loaded, at exit 0, and that defect
;;;; was reproduced by the owner on two different lanes three weeks apart.  So
;;;; the lane's guard is a PREDICATE over the whole declared external API plus
;;;; this readiness carrier, exactly as One Act /0's `act0-api-complete-p` and
;;;; Surface Account /0's guard are.
;;;;
;;;; The carrier is the LAST FORM OF THE LAST-LOADED SOURCE.  A load that dies
;;;; anywhere before this line leaves the carrier unbound, and the predicate
;;;; therefore reports the lane INCOMPLETE rather than reporting a package.
;;;;
;;;; ⚠ [TRUE AS WRITTEN 2026-08-19; SUPERSEDED 2026-08-20 — the lane WAS
;;;; registered that day as an UNADOPTED CANDIDATE in `lisp-plus.asd`
;;;; (`lisp-plus/act1`) and `verify-release.sh` (candidate rows, totals
;;;; 97→103/77→79), commit `63959a5b` / record `c2dbe1a4`. Standing:
;;;; REGISTERED AS CANDIDATE — not adopted, not audited, not frozen.]
;;;; Original statement, preserved as history: THIS LANE IS NOT REGISTERED IN
;;;; `lisp-plus.asd` OR `verify-release.sh`. It is a candidate; the additive
;;;; rows are the chair's to add after review.
;;;; Its entry point is `mneme/language-act-1/load.lisp`.
;;;;
;;;; — PONTIFEX (Claude Opus 5, subagent), 2026-08-19

(in-package #:lisp-plus-language-act1)

(defparameter *act1-lane-ready-carrier*
  '(:lane "one-act-1" :final-source "act1-readiness.lisp" :position :last-form)
  "THE READINESS CARRIER.  Its VALUE is checked, not merely its boundness: a
successor that reorders the lane's sources and forgets this file would leave a
carrier naming a source that is no longer last, and the predicate would catch
it.")
