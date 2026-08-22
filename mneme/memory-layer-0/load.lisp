;;;; load.lisp — Memory Layer /0: the lane's declared load order and its
;;;; COMPLETENESS-CHECKED readiness guard.
;;;;
;;;; Entry point for every consumer:
;;;;
;;;;   (load "mneme/memory-layer-0/load.lisp")
;;;;
;;;; which loads the substrates through their own declared loaders, loads this
;;;; lane's four sources in order, and then ASSERTS the lane is complete.
;;;;
;;;; ⚠ NOT REGISTERED.  `lisp-plus.asd` carries NO `lisp-plus/ml0` system and
;;;; `verify-release.sh` carries NO rows for this lane, by the commission's own
;;;; writ (relay §11).  This file is the canonical door.  If a later chair adds
;;;; an ASDF row, the lane belongs in the COMPLETENESS-CHECKED class and
;;;; `ml0-api-complete-p` is already the predicate for it.
;;;;
;;;; THE ONE SUBSTRATE ENTRY, and why it is the only one:
;;;;   `../language-act-1/load.lisp` — One Act /1's own door, which itself enters
;;;;   the UNGUARDED Stack-A chain once at its deepest point (capability2 ->
;;;;   capability1 -> capability0 -> journal0 -> kernel0 -> canonical-datum) and
;;;;   then loads Core /0.  Entering that chain twice re-evaluates
;;;;   kernel0/identity.lisp and signals SB-EXT:DEFCONSTANT-UNEQL on
;;;;   +IDENTITY-PROCEDURE+, and ANYTHING that loads Canonical Datum /0 BEFORE
;;;;   the chain runs causes the chain to load it a second time
;;;;   (lisp-plus.asd:60-80).  So this lane touches NOTHING above One Act /1's
;;;;   door and lets that door own the order.
;;;;
;;;; ⚠ NO EDGE ON One Act /0, Surface /2, Surface Account /0, or Adapter /0.
;;;; This lane consumes One Act /1 + its chain, and nothing else.  In particular
;;;; it inherits One Act /1's declared NON-EDGE on Surface /2: a consumer that
;;;; needs Surface /2 seat outcomes must reconcile that itself, and nothing in
;;;; this lane may be read as progress toward one.
;;;;
;;;; UNSUPPORTED COMPOSITION, stated as One Act /1's loader states it: CD/0
;;;; pre-loaded bare (without the chain) and then this loader — the chain would
;;;; reload CD/0.  The umbrella fails closed on that order and so should callers
;;;; here.
;;;;
;;;; — TABULARIUS (Claude Opus 5, subagent), 2026-08-20

(defpackage #:lisp-plus-memory-layer0-loader
  (:use #:cl)
  (:export #:ml0-lane-files #:ml0-api-shortfall #:ml0-api-complete-p
           #:load-ml0-lane #:ensure-ml0-lane #:ml0-lane-incomplete))

(in-package #:lisp-plus-memory-layer0-loader)

(defparameter *ml0-directory*
  (make-pathname :name nil :type nil :defaults *load-truename*)
  "This file's own directory.  Checkout- and cwd-independent: no /home/..., no
worktree name, no current directory.")

(defparameter +ml0-lane-sources+
  '("package.lisp" "ml0-fixtures.lisp" "ml0.lisp" "ml0-readiness.lisp")
  "The lane's four sources, in the ONE declared order.  ml0-readiness.lisp is
LAST and must remain last: its final form is the readiness carrier.")

(defparameter +ml0-substrate-sources+
  '("../language-act-1/load.lisp")
  "Loaded through One Act /1's own door, which owns the Stack-A chain order.")

;;; --------------------------------------------------------------------------
;;; The declared external API.  Every name below must be EXTERNAL in the lane's
;;; package and bound as its kind requires before the lane counts as loaded.

(defparameter +ml0-external-functions+
  '(;; harness
    "ML0-NOTE" "ML0-CHECK" "ML0-ENV-PREFLIGHT" "BUILD-ML0-ACCOUNT-STORE"
    ;; condition readers
    "ML0-CONDITION-DETAIL" "ML0-CONDITION-REQUIREMENT-ID"
    ;; the declared observation scope
    "MAKE-ML0-SCOPE" "ML0-SCOPE-P" "ML0-SCOPE-UNIVERSE" "ML0-SCOPE-STATUS"
    "ML0-SCOPE-DETAIL" "ML0-SCOPE-RECORD" "ML0-SCOPE-FROM-RECORD"
    ;; the typed source
    "MAKE-ML0-SOURCE" "ML0-SOURCE-P" "ML0-SOURCE-SPECIES"
    "ML0-SOURCE-ACQUISITION-ROUTE" "ML0-SOURCE-PRODUCER-PRINCIPAL"
    "ML0-SOURCE-RECORDER-PRINCIPAL" "ML0-SOURCE-COORDINATE"
    "ML0-SOURCE-OBSERVATION-SCOPE" "ML0-SOURCE-ORIGIN-AS-READ"
    "ML0-SOURCE-SUBJECT-ACT-ID" "ML0-SOURCE-PAYLOAD-DIGEST"
    "ML0-SOURCE-FRONTIER-RELATION" "ML0-SOURCE-ATTESTS"
    "ML0-SOURCE-OBSERVATION-INTERVAL" "ML0-SOURCE-VALIDATION-STANDING"
    "ML0-SOURCE-DOOR" "ML0-SOURCE-RECORDED-VALIDATION"
    "ML0-SOURCE-WARRANTING-VALIDATION-P"
    ;; the production observation doors (the BLOCK 1 cure)
    "ML0-OBSERVATION-P" "ML0-OBSERVATION-SOURCE" "ML0-OBSERVATION-DOOR"
    "ML0-OBSERVATION-READ-SUMMARY" "ML0-OBSERVATION-SPECIES"
    "ML0-OBSERVATION-ISSUED-P"
    "ML0-OBSERVE-JOURNAL" "ML0-OBSERVE-WORLD" "ML0-OBSERVE-RECONCILIATION"
    "ML0-OBSERVE-ABSENCE" "ML0-OBSERVE-ISSUANCE"
    ;; the record-coverage door (R4) and its reading
    "ML0-OBSERVE-RECORD-COVERAGE" "ML0-RECORD-COVERAGE-OBSERVATION-P"
    "ML0-RECORD-COVERAGE-OBSERVATION-FINDING"
    "ML0-RECORD-COVERAGE-OBSERVATION-SCOPE"
    "ML0-RECORD-COVERAGE-OBSERVATION-READ-SUMMARY"
    "ML0-RECORD-COVERAGE-OBSERVATION-ACCOUNT-HEXES"
    "ML0-SOURCE-RECORD" "ML0-SOURCE-FROM-RECORD"
    ;; the scoped effect observation
    "MAKE-ML0-EFFECT-OBSERVATION" "ML0-EFFECT-OBSERVATION-P"
    "ML0-EFFECT-OBSERVATION-STANDING-AS-READ" "ML0-EFFECT-OBSERVATION-DETERMINACY"
    "ML0-EFFECT-OBSERVATION-WORLD-DIGEST" "ML0-EFFECT-OBSERVATION-SCOPE"
    "ML0-EFFECT-OBSERVATION-PROVENANCE"
    "ML0-EFFECT-OBSERVATION-RECORD" "ML0-EFFECT-OBSERVATION-FROM-RECORD"
    ;; the bundle
    "MAKE-ML0-BUNDLE" "ML0-BUNDLE-P" "ML0-BUNDLE-FIXTURE-ROW"
    "ML0-BUNDLE-CLAIMED-ACT-ID" "ML0-BUNDLE-SUBJECT-PRINCIPAL"
    "ML0-BUNDLE-SOURCES" "ML0-BUNDLE-ISSUANCE-STANDING"
    "ML0-BUNDLE-ISSUANCE-SCOPE" "ML0-BUNDLE-RECORD-COVERAGE"
    "ML0-BUNDLE-RECORD-COVERAGE-SCOPE" "ML0-BUNDLE-EFFECT-OBSERVATION"
    "ML0-BUNDLE-OBSERVATIONS" "ML0-BUNDLE-TESTIMONY"
    "ML0-BUNDLE-ISSUANCE-OBSERVATION" "ML0-BUNDLE-RECORD-COVERAGE-OBSERVATION"
    ;; the semantic object
    "ML0-ACCOUNT-P" "ML0-ACCOUNT-ID" "ML0-ACCOUNT-ID-HEX" "ML0-ACCOUNT-ID-DATUM"
    "ML0-ACCOUNT-ACT-ID" "ML0-ACCOUNT-ACT-ID-HEX" "ML0-ACCOUNT-SUBJECT-SEAT"
    "ML0-ACCOUNT-SUBJECT-ATTEMPT" "ML0-ACCOUNT-OCCURRENCE-STANDING"
    "ML0-ACCOUNT-OCCURRENCE-SCOPE" "ML0-ACCOUNT-ISSUANCE-STANDING"
    "ML0-ACCOUNT-ISSUANCE-SCOPE" "ML0-ACCOUNT-RECORD-COVERAGE"
    "ML0-ACCOUNT-RECORD-COVERAGE-SCOPE" "ML0-ACCOUNT-EFFECT-OBSERVATION"
    "ML0-ACCOUNT-SOURCES" "ML0-ACCOUNT-DERIVATION" "ML0-ACCOUNT-PREDECESSORS"
    "ML0-ACCOUNT-RECORDER-PRINCIPAL" "ML0-ACCOUNT-SUBJECT-PRINCIPAL"
    "ML0-ACCOUNT-RETRIEVAL-ORIGIN" "ML0-ACCOUNT-BODY-RECORD"
    "ML0-ACCOUNT-STANDING-AUTHORITY" "ML0-ACCOUNT-CARRIED-STANDINGS"
    ;; the public readers
    "ML0-ACCOUNT-OCCURRED-P" "ML0-ACCOUNT-ISSUANCE-ONLY-P"
    "ML0-ACCOUNT-CARRIES-NO-CURRENT-IMAGE-EVIDENCE-P" "ML0-ACCOUNT-MAY-CONTINUE-P"
    "ML0-RENDER-ACCOUNT"
    ;; the promotion rule and its neighbours
    "ML0-SPECIES-MAY-WARRANT-OCCURRENCE-P" "ML0-OCCURRENCE-WARRANTED-P"
    "ML0-NONOCCURRENCE-WARRANTED-P" "ML0-DERIVE-OCCURRENCE-STANDING"
    "ML0-OCCURRENCE-CONJUNCTS" "ML0-FAILING-LEG" "ML0-PRINT-CONJUNCTS"
    "ML0-WARRANTS-COMMENSURABLE-P"
    "ML0-ACQUISITION-ROUTE-IDENTIFIER" "ML0-MINT-ACCOUNT-IDENTITY"
    "ML0-EVIDENCE-PROJECTION-DIGEST"
    ;; the host-fault gate and the non-performing identity door
    "ML0-THROUGH" "ML0-REDERIVE-ACT-IDENTITY"
    ;; the three operations
    "ML0-WRITE" "ML0-RETRIEVE" "ML0-CONSOLIDATE" "ML0-FOLD-ISSUANCE"
    "ML0-FOLD-RECORD-COVERAGE"
    ;; R4.1: the consolidation carrier's readers and the materialization route
    "ML0-MATERIALIZE-CONSOLIDATION" "ML0-CONSOLIDATION-P"
    "ML0-CONSOLIDATION-ACT-ID" "ML0-CONSOLIDATION-ACT-ID-HEX"
    "ML0-CONSOLIDATION-SUBJECT-SEAT" "ML0-CONSOLIDATION-SUBJECT-ATTEMPT"
    "ML0-CONSOLIDATION-SUBJECT-PRINCIPAL"
    "ML0-CONSOLIDATION-OCCURRENCE-STANDING" "ML0-CONSOLIDATION-OCCURRENCE-SCOPE"
    "ML0-CONSOLIDATION-ISSUANCE-STANDING" "ML0-CONSOLIDATION-ISSUANCE-SCOPE"
    "ML0-CONSOLIDATION-RECORD-COVERAGE" "ML0-CONSOLIDATION-RECORD-COVERAGE-SCOPE"
    "ML0-CONSOLIDATION-SOURCES" "ML0-CONSOLIDATION-PREDECESSORS"
    "ML0-CONSOLIDATION-INPUTS" "ML0-CONSOLIDATION-CLASH"
    "ML0-ACCOUNT-HEX-OF-EVENT" "ML0-ACCOUNT-FROM-EVENT" "ML0-LIST-ACCOUNT-IDS"
    ;; the store-scope absence instrument
    "ML0-STORE-SCOPE-P" "ML0-STORE-SCOPE-FILES" "ML0-STORE-SCOPE-DIGESTS"
    "ML0-STORE-SCOPE-DIRECTORY" "ML0-TAKE-STORE-SCOPE"
    "ML0-STORE-SCOPE-UNCHANGED-P" "ML0-PRINT-STORE-UNIVERSE"))

(defparameter +ml0-external-variables+
  '("+ML0-ID-DOMAIN+" "+ML0-LANE-STEM+" "+ML0-RUNTIME-PROCESS-NAME+"
    "+ML0-STORE-NONCE+" "+ML0-RENDERING-VERSION+"
    "+ML0-SOURCE-SPECIES+" "+ML0-OCCURRENCE-SPECIES+"
    "+ML0-NONOCCURRENCE-SPECIES+" "+ML0-ACQUISITION-ROUTES+" "+ML0-ATTESTATIONS+"
    "+ML0-RECORD-COVERAGES+" "+ML0-OCCURRED-PROPOSITION+" "+ML0-PROMOTION-LEGS+"
    "+ML0-SOURCE-VALIDATIONS+" "+ML0-OBSERVATION-DOORS+"
    "+ML0-OCCURRENCE-STANDINGS+" "+ML0-ISSUANCE-STANDINGS+"
    "+ML0-EFFECT-DETERMINACIES+" "+ML0-DERIVATIONS+" "+ML0-SCOPE-STATUSES+"
    "+ML0-ENV-CLASS-I+" "+ML0-ENV-CLASS-II+"
    "+ML0-ENV-CLASS-III-DECLARED-OUT-OF-STACK+"
    "*ML0-RUN-ROOT*" "*ML0-ACCOUNT-STORE*"
    "*ML0-CHECKS-PASSED*" "*ML0-CHECKS-FAILED*"))

(defparameter +ml0-external-types+
  '("ML0-CONDITION" "ML0-SOURCE-SPECIES-REFUSED" "ML0-SUBJECT-IDENTITY-MISMATCH"
    "ML0-PROVENANCE-INCOMPLETE" "ML0-SCOPE-UNDECLARED"
    "ML0-STANDING-VOCABULARY-REFUSED" "ML0-ACCOUNT-ENCODING-REFUSED"
    "ML0-ACCOUNT-READBACK-REFUSED" "ML0-CONSOLIDATION-REFUSED"
    "ML0-BRIDGE-CONTRACT-VIOLATED" "ML0-RUN-VOID"
    "ML0-SCOPE" "ML0-SOURCE" "ML0-OBSERVATION" "ML0-EFFECT-OBSERVATION" "ML0-BUNDLE"
    "ML0-ACCOUNT" "ML0-STORE-SCOPE" "ML0-RECORD-COVERAGE-OBSERVATION"
    "ML0-CONSOLIDATION"))

(defparameter +ml0-api-count+ 195
  "The DECLARED total.  Asserted against the sum of the three lists above, so a
name added to a list without touching this number is caught rather than silently
widening the interface.")

(defparameter +ml0-readiness-carrier+ "*ML0-LANE-READY-CARRIER*")
(defparameter +ml0-carrier-value+
  '(:lane "memory-layer-0" :final-source "ml0-readiness.lisp" :position :last-form))

(defun ml0-lane-files ()
  (mapcar #'copy-seq +ml0-lane-sources+))

(defun ml0-api-shortfall ()
  "NIL when the lane is complete; otherwise a list of human-readable shortfall
strings.  ⚠ THE ABSENCE THIS REPORTS CARRIES ITS WARRANT: it enumerates EVERY
declared name and says which one failed and how, so `nothing wrong` can never be
the answer of a check that never looked."
  (let ((package (find-package '#:lisp-plus-memory-layer0))
        (shortfall '()))
    (unless (= +ml0-api-count+
               (+ (length +ml0-external-functions+)
                  (length +ml0-external-variables+)
                  (length +ml0-external-types+)))
      (push (format nil "declared API count ~d does not equal the sum of the ~
declared lists (~d)" +ml0-api-count+
                    (+ (length +ml0-external-functions+)
                       (length +ml0-external-variables+)
                       (length +ml0-external-types+)))
            shortfall))
    (if (null package)
        (push "package LISP-PLUS-MEMORY-LAYER0 does not exist" shortfall)
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
          (dolist (n +ml0-external-functions+) (probe n "function" #'fboundp))
          (dolist (n +ml0-external-variables+) (probe n "variable" #'boundp))
          (dolist (n +ml0-external-types+)
            (probe n "type" (lambda (s) (or (find-class s nil) (subtypep s t)))))
          (let ((carrier (find-symbol +ml0-readiness-carrier+ package)))
            (cond ((null carrier)
                   (push (format nil "readiness carrier ~a absent: the load never ~
reached the final form of ml0-readiness.lisp" +ml0-readiness-carrier+)
                         shortfall))
                  ((not (boundp carrier))
                   (push (format nil "readiness carrier ~a unbound"
                                 +ml0-readiness-carrier+)
                         shortfall))
                  ((not (equal (symbol-value carrier) +ml0-carrier-value+))
                   (push (format nil "readiness carrier ~a holds ~s, not the ~
declared value" +ml0-readiness-carrier+ (symbol-value carrier))
                         shortfall))))))
    (nreverse shortfall)))

(defun ml0-api-complete-p ()
  (null (ml0-api-shortfall)))

(define-condition ml0-lane-incomplete (error)
  ((detail :initarg :detail :reader ml0-lane-incomplete-detail))
  (:report (lambda (c s)
             (format s "~&Memory Layer /0: LANE LOAD DID NOT COMPLETE.~%~%~
The lane's declared external API is not fully present and bound, or the readiness ~
carrier is missing.  A package existing is NOT the lane being ready.~%~%~
Shortfall:~%~{  - ~a~%~}"
                     (ml0-lane-incomplete-detail c)))))

(defun load-ml0-lane ()
  ;; The substrate entry is GUARDED on One Act /1's own terminal package, so an
  ;; image that already loaded that lane is NOT made to enter the Stack-A chain
  ;; twice (kernel0/identity.lisp would signal SB-EXT:DEFCONSTANT-UNEQL).  In a
  ;; fresh `sbcl --script` image the package is absent and the chain runs once.
  (dolist (source +ml0-substrate-sources+)
    (unless (find-package '#:lisp-plus-language-act1)
      (load (merge-pathnames source *ml0-directory*))))
  (dolist (source +ml0-lane-sources+)
    (load (merge-pathnames source *ml0-directory*))))

(defun ensure-ml0-lane ()
  "Idempotent.  package.lisp is loaded FIRST when the predicate is false, so an
existing INCOMPLETE package is REPAIRED rather than skipped."
  (unless (ml0-api-complete-p)
    (load-ml0-lane)
    (let ((shortfall (ml0-api-shortfall)))
      (when shortfall
        (error 'ml0-lane-incomplete :detail shortfall))))
  t)

(ensure-ml0-lane)
