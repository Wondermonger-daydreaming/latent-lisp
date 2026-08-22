;;;; ml0-readiness.lisp — Memory Layer /0: the LAST-LOADED source, whose LAST
;;;; FORM is the lane's readiness carrier.
;;;;
;;;; PACKAGE EXISTENCE IS NOT IMPLEMENTATION READINESS.  This lane is in the
;;;; COMPLETENESS-CHECKED class (lisp-plus.asd:36-58): a `find-package` guard
;;;; certifies a half-built or empty lane as loaded, at exit 0, and that defect
;;;; was reproduced by the owner on two different lanes three weeks apart.  So
;;;; the lane's guard is a PREDICATE over the whole declared external API plus
;;;; this readiness carrier, exactly as One Act /0's `act0-api-complete-p`, One
;;;; Act /1's `act1-api-complete-p`, and Surface Account /0's guard are.
;;;;
;;;; The carrier is the LAST FORM OF THE LAST-LOADED SOURCE.  A load that dies
;;;; anywhere before this line leaves the carrier unbound, and the predicate
;;;; therefore reports the lane INCOMPLETE rather than reporting a package.
;;;;
;;;; ⚠ THIS LANE IS NOT REGISTERED IN `lisp-plus.asd` OR `verify-release.sh`, and
;;;; that is a statement about 2026-08-20 and about this commission's writ (relay
;;;; §11: "You are not authorized to adopt, freeze, publish, sync, or register it
;;;; on the release floor in this commission").  It is a CANDIDATE; the additive
;;;; rows are a later chair's to add after review, and a chair who adds them
;;;; should DATE-CAP this paragraph rather than delete it — One Act /1's
;;;; act1-readiness.lisp:16-24 is the precedent, and the housekeeping cost of
;;;; that hand-maintained cap is a known one.
;;;;
;;;; Its entry point is `mneme/memory-layer-0/load.lisp`.
;;;;
;;;; — TABULARIUS (Claude Opus 5, subagent), 2026-08-20

(in-package #:lisp-plus-memory-layer0)

(defparameter *ml0-lane-ready-carrier*
  '(:lane "memory-layer-0" :final-source "ml0-readiness.lisp" :position :last-form)
  "THE READINESS CARRIER.  Its VALUE is checked, not merely its boundness: a
successor that reorders the lane's sources and forgets this file would leave a
carrier naming a source that is no longer last, and the predicate would catch
it.")
