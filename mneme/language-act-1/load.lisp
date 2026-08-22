;;;; load.lisp — One Act /1: the lane's declared load order and its
;;;; COMPLETENESS-CHECKED readiness guard.
;;;;
;;;; Entry point for every consumer:
;;;;
;;;;   (load "mneme/language-act-1/load.lisp")
;;;;
;;;; which loads the substrates through their own declared loaders, loads this
;;;; lane's four sources in order, and then ASSERTS the lane is complete.
;;;;
;;;; ⚠ REGISTERED 2026-08-20 (chair's additive act, authorized by Sol's
;;;; cold-review disposition relayed by the owner; the lane remains an
;;;; UNADOPTED CANDIDATE — registration moves no standing): `lisp-plus.asd`
;;;; carries a standalone `lisp-plus/act1` system whose :perform calls
;;;; ENSURE-ACT1-LANE below, and `verify-release.sh` carries this lane's six
;;;; gate rows.  This file remains the canonical door either way.
;;;; (The original 2026-08-19 note — "NOT REGISTERED … a candidate does not
;;;; register itself on a floor" — described the pre-registration state and
;;;; was true when written.)
;;;;
;;;; THE TWO SUBSTRATE ENTRIES, and why they are in this order:
;;;;   1. `../capability2/load.lisp` — the UNGUARDED Stack-A chain, entered
;;;;      ONCE at its deepest point (capability2 -> capability1 -> capability0
;;;;      -> journal0 -> kernel0 -> canonical-datum).  Entering that chain twice
;;;;      re-evaluates kernel0/identity.lisp and signals
;;;;      SB-EXT:DEFCONSTANT-UNEQL on +IDENTITY-PROCEDURE+, and ANYTHING that
;;;;      loads Canonical Datum /0 BEFORE the chain runs causes the chain to
;;;;      load it a second time (lisp-plus.asd:60-80).  So the chain goes first
;;;;      and nothing above it touches CD/0.
;;;;   2. `../language-core-0/core0.lisp` — package-guarded, and core0 loads
;;;;      Slice /1 (and through it Slice /0) for itself if absent
;;;;      (core0.lisp:34-36).
;;;;
;;;; ⚠ NO EDGE ON One Act /0, Surface /2, Surface Account /0, or Adapter /0.
;;;; This lane consumes core0 + capability2 + their chain, and nothing else.
;;;;
;;;; — PONTIFEX (Claude Opus 5, subagent), 2026-08-19

(defpackage #:lisp-plus-language-act1-loader
  (:use #:cl)
  (:export #:act1-lane-files #:act1-api-shortfall #:act1-api-complete-p
           #:load-act1-lane #:ensure-act1-lane #:act1-lane-incomplete))

(in-package #:lisp-plus-language-act1-loader)

(defparameter *act1-directory*
  (make-pathname :name nil :type nil :defaults *load-truename*)
  "This file's own directory.  Checkout- and cwd-independent: no /home/..., no
worktree name, no current directory.")

(defparameter +act1-lane-sources+
  '("package.lisp" "act1-fixtures.lisp" "act1.lisp" "act1-readiness.lisp")
  "The lane's four sources, in the ONE declared order.  act1-readiness.lisp is
LAST and must remain last: its final form is the readiness carrier.")

(defparameter +act1-substrate-sources+
  '("../capability2/load.lisp")
  "Loaded unconditionally: the Stack-A chain is unguarded by design and is
entered exactly once, here, at its deepest point.")

;;; --------------------------------------------------------------------------
;;; The declared external API.  Every name below must be EXTERNAL in the lane's
;;; package and bound as its kind requires before the lane counts as loaded.

(defparameter +act1-external-functions+
  '("ACT1-CHECK" "ACT1-NOTE" "ACT1-ENV-PREFLIGHT"
    "BUILD-ACT1-STORE" "BUILD-ACT1-WORLDS" "ACT1-OPENING-AUTHORITY"
    "ACT1-GRANT-TERMS-FOR" "ACT1-CAPABILITY-ID-FOR" "ACT1-REQUEST-FORM"
    "MAKE-ACT1-FIXTURE-ROW" "VALIDATE-ACT1-FIXTURE-TABLE"
    "ACT1-FIXTURE-P" "ACT1-FIXTURE-ARM" "ACT1-FIXTURE-LABEL"
    "ACT1-FIXTURE-LANGUAGE-LABEL" "ACT1-FIXTURE-RUNTIME-SEAT"
    "ACT1-FIXTURE-ATTEMPT-NAME" "ACT1-FIXTURE-CELL-SEGMENTS"
    "ACT1-FIXTURE-ADAPTER-SYMBOL" "ACT1-FIXTURE-WORLD-KEY"
    "ACT1-FIXTURE-FORM" "ACT1-FIXTURE-AUTHORITY-MODE"
    "ACT1-FIXTURE-DURABLE-GUARD" "ACT1-FIXTURE-INTERRUPTION"
    "ACT1-FIXTURE-RUNTIME-DEFECT" "ACT1-FIXTURE-PROJECT-DEFECT"
    "ACT1-FIXTURE-HOST-FAULT-PLANT"
    "ACT1-FIXTURE-LEAK-WRITE" "ACT1-FIXTURE-REVOKE-AFTER-MINT"
    "ACT1-RECORD-P" "ACT1-RECORD-FIXTURE" "ACT1-RECORD-ACT-ID"
    "ACT1-RECORD-ACT-ID-HEX" "ACT1-RECORD-NORMAL-FORM"
    "ACT1-RECORD-REQUEST-REC" "ACT1-RECORD-REQUEST-OCT"
    "CANONICALIZE-ACT1-REQUEST" "ACT1-REQUEST-RECORD" "ACT1-REQUEST-OCTETS"
    "MINT-ACT1-IDENTITY" "MAKE-ACT1-RECORD"
    "CHECK-ACT1-CELL-LEXIS" "CHECK-ACT1-TEXT-LEXIS"
    "ACT1-DURABLE-GUARD-VERDICT" "MAKE-ACT1-BRIDGE" "ACT1-DISPATCH"
    "ACT1-LEDGER-QUERY" "RUN-ACT1" "ACT1-JOURNAL-KINDS"
    "ACT1-RECONCILIATION-CLOSES-SEAT-P"
    "ACT1-RESULT-P" "ACT1-RESULT-RECORD" "ACT1-RESULT-CLASS"
    "ACT1-RESULT-STANDING" "ACT1-RESULT-DISPOSITION" "ACT1-RESULT-OUTCOME"
    "ACT1-RESULT-EVIDENCE" "ACT1-RESULT-REASON" "ACT1-RESULT-GUARD"
    "ACT1-RESULT-REFUSAL-TYPE" "ACT1-RESULT-CONTEXT" "ACT1-RESULT-BRIDGE"
    "WORLD-SCOPE-SNAPSHOT-P" "WORLD-SCOPE-SNAPSHOT-CELLS-SHA"
    "WORLD-SCOPE-SNAPSHOT-LEDGER-SHA" "WORLD-SCOPE-SNAPSHOT-CELLS-OCTETS"
    "WORLD-SCOPE-SNAPSHOT-LEDGER-OCTETS" "WORLD-SCOPE-SNAPSHOT-LEDGER-COUNT"
    "WORLD-SCOPE-SNAPSHOT-KEY" "WORLD-SCOPE-SNAPSHOT-KEY-COUNT"
    "WORLD-SCOPE-SNAPSHOT-FILES"
    "TAKE-WORLD-SCOPE" "WORLD-SCOPE-UNCHANGED-P" "PRINT-WORLD-SCOPE-UNIVERSE"
    "EXTERNAL-REQUEST-KEY"
    "ACT1-CONDITION-DETAIL" "ACT1-CONDITION-REQUIREMENT-ID"))

(defparameter +act1-external-variables+
  '("*ACT1-RUN-ROOT*" "*ACT1-STORE*" "*ACT1-WORLDS*" "*ACT1-WORLD-DIRECTORIES*"
    "*ACT1-BOOTSTRAP*" "*ACT1-MINTING-CONTEXT*" "*ACT1-FIXTURE-TABLE*"
    "*CHECKS-PASSED*" "*CHECKS-FAILED*"
    "+ACT1-ID-DOMAIN+" "+ACT1-LANE-STEM+" "+ACT1-RUNTIME-PROCESS-NAME+"
    "+ACT1-STORE-NONCE+" "+ACT1-REQUEST-RENDERING-VERSION+"))

(defparameter +act1-external-types+
  '("ACT1-CONDITION" "ACT1-FIXTURE-TABLE-INVALID" "ACT1-REQUEST-SHAPE-REFUSED"
    "ACT1-REQUEST-LEXIS-REFUSED" "ACT1-AUTHORITY-BINDING-REFUSED"
    "ACT1-DISPATCHER-BINDING-REFUSED" "ACT1-BRIDGE-CONTRACT-VIOLATED"
    "ACT1-READBACK-DISAGREEMENT" "ACT1-RUN-VOID"
    "ACT1-FIXTURE" "ACT1-RECORD" "ACT1-RESULT" "WORLD-SCOPE-SNAPSHOT"))

(defparameter +act1-api-count+ 104
  "The DECLARED total.  Asserted against the sum of the three lists below, so a
name added to a list without touching this number is caught rather than
silently widening the interface.")

(defparameter +act1-readiness-carrier+ "*ACT1-LANE-READY-CARRIER*")
(defparameter +act1-carrier-value+
  '(:lane "one-act-1" :final-source "act1-readiness.lisp" :position :last-form))

(defun act1-lane-files ()
  (mapcar #'copy-seq +act1-lane-sources+))

(defun act1-api-shortfall ()
  "NIL when the lane is complete; otherwise a list of human-readable shortfall
strings.  ⚠ THE ABSENCE THIS REPORTS CARRIES ITS WARRANT: it enumerates EVERY
declared name and says which one failed and how, so 'nothing wrong' can never
be the answer of a check that never looked."
  (let ((package (find-package '#:lisp-plus-language-act1))
        (shortfall '()))
    (unless (= +act1-api-count+
               (+ (length +act1-external-functions+)
                  (length +act1-external-variables+)
                  (length +act1-external-types+)))
      (push (format nil "declared API count ~d does not equal the sum of the ~
declared lists (~d)" +act1-api-count+
                    (+ (length +act1-external-functions+)
                       (length +act1-external-variables+)
                       (length +act1-external-types+)))
            shortfall))
    (if (null package)
        (push "package LISP-PLUS-LANGUAGE-ACT1 does not exist" shortfall)
        (flet ((probe (name kind test)
                 (multiple-value-bind (symbol status) (find-symbol name package)
                   (cond ((null symbol)
                          (push (format nil "~a ~a: absent" kind name) shortfall))
                         ((not (eq status :external))
                          (push (format nil "~a ~a: present but not external"
                                        kind name)
                                shortfall))
                         ((not (funcall test symbol))
                          (push (format nil "~a ~a: external but not bound as a ~a"
                                        kind name kind)
                                shortfall))))))
          (dolist (n +act1-external-functions+) (probe n "function" #'fboundp))
          (dolist (n +act1-external-variables+) (probe n "variable" #'boundp))
          (dolist (n +act1-external-types+)
            (probe n "type" (lambda (s) (or (find-class s nil)
                                            (subtypep s t)))))
          (let ((carrier (find-symbol +act1-readiness-carrier+ package)))
            (cond ((null carrier)
                   (push (format nil "readiness carrier ~a absent: the load never ~
reached the final form of act1-readiness.lisp" +act1-readiness-carrier+)
                         shortfall))
                  ((not (boundp carrier))
                   (push (format nil "readiness carrier ~a unbound"
                                 +act1-readiness-carrier+)
                         shortfall))
                  ((not (equal (symbol-value carrier) +act1-carrier-value+))
                   (push (format nil "readiness carrier ~a holds ~s, not the ~
declared value" +act1-readiness-carrier+ (symbol-value carrier))
                         shortfall))))))
    (nreverse shortfall)))

(defun act1-api-complete-p ()
  (null (act1-api-shortfall)))

(define-condition act1-lane-incomplete (error)
  ((detail :initarg :detail :reader act1-lane-incomplete-detail))
  (:report (lambda (c s)
             (format s "~&One Act /1: LANE LOAD DID NOT COMPLETE.~%~%~
The lane's declared external API is not fully present and bound, or the ~
readiness carrier is missing.  A package existing is NOT the lane being ~
ready.~%~%Shortfall:~%~{  - ~a~%~}"
                     (act1-lane-incomplete-detail c)))))

(defun load-act1-lane ()
  ;; 2026-08-20 (registration act): the Stack-A chain entry is now GUARDED on
  ;; the chain's own terminal package, exactly as the umbrella's
  ;; `lisp-plus/stack-a` guards it (lane-once on LISP-PLUS-CAPABILITY2) — so an
  ;; image that already ran the chain (e.g. via `lisp-plus` or
  ;; `lisp-plus/stack-a`) is NOT made to enter it twice
  ;; (kernel0/identity.lisp would signal SB-EXT:DEFCONSTANT-UNEQL).  In a
  ;; fresh `sbcl --script` image the behavior is byte-identical to before:
  ;; the package is absent and the chain runs once, deepest point first.
  ;; UNSUPPORTED composition, same as the umbrella's law: CD/0 pre-loaded
  ;; bare (without the chain) and then this loader — the chain would reload
  ;; CD/0; the umbrella fails closed on that order and so should callers here.
  (dolist (source +act1-substrate-sources+)
    (unless (find-package '#:lisp-plus-capability2)
      (load (merge-pathnames source *act1-directory*))))
  (unless (find-package '#:lisp-plus-core0)
    (load (merge-pathnames "../language-core-0/core0.lisp" *act1-directory*)))
  (dolist (source +act1-lane-sources+)
    (load (merge-pathnames source *act1-directory*))))

(defun ensure-act1-lane ()
  "Idempotent.  package.lisp is loaded FIRST when the predicate is false, so an
existing INCOMPLETE package is REPAIRED rather than skipped."
  (unless (act1-api-complete-p)
    (load-act1-lane)
    (let ((shortfall (act1-api-shortfall)))
      (when shortfall
        (error 'act1-lane-incomplete :detail shortfall))))
  t)

(ensure-act1-lane)
