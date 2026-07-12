;;;; validator.lisp — Language A: a deterministic validator for public claim records
;;;;
;;;; Built to GPT's jurisdiction-relay packet, §3 (2026-07-11), classifier-safe by
;;;; construction: everything local, synthetic, epistemic. Package `mneme.language-a`.
;;;; It reuses the SPIRIT of the mneme kernel (../latent-mvp/kernel.lisp) — the grade
;;;; vocabulary (:asserted/:observed), the report≠certificate law, the bounded-absence
;;;; discipline — but forks NONE of its struct names: it operates on the s-expression
;;;; JUDGMENT record shown in the packet, not on the kernel's `defstruct claim`.
;;;;
;;;; ┌────────────────────────────────────────────────────────────────────────────┐
;;;; │ WHAT THIS DOES — AND, LOUDLY, WHAT IT DOES NOT ESTABLISH                     │
;;;; ├────────────────────────────────────────────────────────────────────────────┤
;;;; │ This validator checks whether a claim record STATES ITS RELATIONS COHERENTLY.│
;;;; │ It is NOT a truth oracle.                                                     │
;;;; │                                                                              │
;;;; │  · Coherence is not truth. A record can validate perfectly and be wrong      │
;;;; │    about the world.                                                          │
;;;; │  · The validator disciplines a COOPERATIVE author. A lying author can emit   │
;;;; │    a perfectly coherent record whose boundary fields are false. This tool    │
;;;; │    RELOCATES the forgeable seam (from "no structure" to "the author's        │
;;;; │    self-report of scope"); it does NOT close it.                             │
;;;; │  · A receipt's own census (inspected-items, scope-complete, "terminated      │
;;;; │    normally") is testimony by the same procedure the receipt describes.      │
;;;; │    The validator trusts those fields' PRESENCE and SHAPE; it cannot audit    │
;;;; │    their TRUTH.                                                              │
;;;; └────────────────────────────────────────────────────────────────────────────┘
;;;;
;;;; Load: (load "validator.lisp")   ·   full teeth: (load "fixtures.lisp")
;;;; SBCL 2.4.6, `sbcl --script`, no external dependencies.

(defpackage #:mneme.language-a
  (:use #:cl)
  (:export
   ;; the entrypoint
   #:validate-judgment #:valid-p
   ;; record accessors (reused by the fixture suite)
   #:clause #:val
   ;; the eight typed conditions
   #:validation-error #:violated-check #:offending
   #:duplicate-id #:unresolved-reference #:missing-boundary #:unsupported-standing
   #:answer-without-claim #:invalid-confidence #:scope-extension-requested
   #:unresolved-field-erasure
   ;; the honest declarations
   #:*refusals* #:*not-established* #:print-preamble))

(in-package #:mneme.language-a)

;;; ── the vocabulary (reused from the mneme kernel's spirit) ───────────────────
(defparameter *judgment-statuses* '(:answer :uncertain :refusal)
  "A public record answers, hedges, or refuses. Nothing else is a status.")
(defparameter *claim-standings* '(:asserted :observed :bounded-absence :externally-verified)
  ":asserted/:observed echo the kernel grades; :bounded-absence is GPT's completed-scope
   negative; :externally-verified is the L4 report≠certificate boundary.")
(defparameter *definite-answers-need-claims* t)

;;; ── the eight typed conditions ───────────────────────────────────────────────
;;; Errors are negotiations, not explosions (condition-system doctrine): each check
;;; SIGNALS a narrow, named grievance; the caller (the suite) DECIDES what it means.
(define-condition validation-error (error)
  ((violated-check :initarg :check :reader violated-check :initform "?")
   (offending      :initarg :offending :reader offending :initform nil))
  (:report (lambda (c s)
             (format s "~a: ~s" (violated-check c) (offending c)))))

(define-condition duplicate-id             (validation-error) ())
(define-condition unresolved-reference     (validation-error) ())
(define-condition missing-boundary         (validation-error) ())
(define-condition unsupported-standing     (validation-error) ())
(define-condition answer-without-claim     (validation-error) ())
(define-condition invalid-confidence       (validation-error) ())
(define-condition scope-extension-requested (validation-error) ())
(define-condition unresolved-field-erasure (validation-error) ())

(defmacro fail (type check offending)
  `(error ',type :check ,check :offending ,offending))

;;; ── record accessors: the JUDGMENT s-expression, read structurally ───────────
;;; A record is (TAG (:key value...) (:key value...) ...). The boundary is itself a
;;; record whose tag is :boundary, so the SAME two accessors read every level.
(defun clause (record key)
  "The full clause (:KEY ...) under RECORD's tag, or NIL. RECORD's head is its tag."
  (and (consp record)
       (find-if (lambda (c) (and (consp c) (eq (first c) key))) (rest record))))

(defun val (record key &optional default)
  "The single value of RECORD's KEY clause, or DEFAULT."
  (let ((c (clause record key)))
    (if c (second c) default)))

(defun claim-forms   (j) (val j :claims))
(defun support-forms (j) (val j :support))
(defun receipt-manifest (j) (val j :receipts))

(defun collect-ids (j)
  "Every declared identifier, in reading order, so duplicates are order-stable."
  (append (list (val j :id))
          (mapcar (lambda (c) (val c :id)) (claim-forms j))
          (mapcar (lambda (s) (val s :id)) (support-forms j))))

;;; ── the twelve checks (GPT §3 verbatim), each raising a typed condition ──────
;;; Ordered. The FIRST violation wins, so a malformed fixture that is malformed in
;;; exactly ONE way fires exactly ONE named condition (that is the fixture suite).

(defun check-01-unique-identifiers (j)
  "CHECK-01 unique-identifiers → DUPLICATE-ID."
  (let ((ids (remove nil (collect-ids j))) seen)
    (dolist (id ids)
      (when (member id seen :test #'equal)
        (fail duplicate-id "CHECK-01 unique-identifiers" id))
      (push id seen))))

(defun check-02-resolved-references (j)
  "CHECK-02 resolved-references → UNRESOLVED-REFERENCE.
   Intra-record provenance references (:derived-from a claim id) must resolve.
   (:summary-of names a record the validator does not hold; unverifiable ⇒ untested,
   not asserted — see CHECK-09.)"
  (let ((claim-ids (mapcar (lambda (c) (val c :id)) (claim-forms j))))
    (dolist (c (claim-forms j))
      (let ((df (val c :derived-from)))
        (when (and df (not (member df claim-ids :test #'equal)))
          (fail unresolved-reference "CHECK-02 resolved-references" df))))))

(defun check-03-valid-status-values (j)
  "CHECK-03 valid-status-values → UNSUPPORTED-STANDING."
  (let ((st (val j :status)))
    (unless (member st *judgment-statuses*)
      (fail unsupported-standing "CHECK-03 valid-status-values" st))))

(defun check-04-confidence-in-unit-interval (j)
  "CHECK-04 confidence-in-unit-interval → INVALID-CONFIDENCE."
  (let ((conf (val j :confidence)))
    (when conf
      (unless (and (realp conf) (<= 0 conf 1))
        (fail invalid-confidence "CHECK-04 confidence-in-unit-interval" conf)))))

(defun check-05-support-names-existing-claim (j)
  "CHECK-05 support-names-existing-claim → UNRESOLVED-REFERENCE."
  (let ((claim-ids (mapcar (lambda (c) (val c :id)) (claim-forms j))))
    (dolist (s (support-forms j))
      (let ((faces (val s :faces)))
        (unless (member faces claim-ids :test #'equal)
          (fail unresolved-reference "CHECK-05 support-names-existing-claim" faces))))))

(defun check-06-referenced-receipt-exists (j)
  "CHECK-06 referenced-receipt-exists → UNRESOLVED-REFERENCE.
   A support's :artifact must appear in the record's own artifact manifest."
  (let ((manifest (receipt-manifest j)))
    (dolist (s (support-forms j))
      (let ((art (val s :artifact)))
        (when (and art (not (member art manifest :test #'equal)))
          (fail unresolved-reference "CHECK-06 referenced-receipt-exists" art))))))

(defun bounded-claim-p (c)
  (member (val c :standing) '(:observed :bounded-absence)))

(defun check-07-bounded-claim-has-boundary-fields (j)
  "CHECK-07 bounded-claim-has-boundary-fields → MISSING-BOUNDARY.
   Any evidential claim must carry (:corpus :procedure :as-of); a :bounded-absence
   must ALSO carry (:scope-complete t) — the completeness certificate that alone
   licenses a negative. A heuristic represented as exhaustive lacks it."
  (dolist (c (claim-forms j))
    (when (bounded-claim-p c)
      (let ((b (clause c :boundary)))
        (unless b (fail missing-boundary "CHECK-07 bounded-claim-has-boundary-fields"
                        (list (val c :id) :no-boundary)))
        (dolist (req '(:corpus :procedure :as-of))
          (unless (clause b req)
            (fail missing-boundary "CHECK-07 bounded-claim-has-boundary-fields"
                  (list (val c :id) req))))
        (when (eq (val c :standing) :bounded-absence)
          (unless (eq (val b :scope-complete) t)
            (fail missing-boundary "CHECK-07 bounded-claim-has-boundary-fields"
                  (list (val c :id) :scope-complete-not-established))))))))

(defun check-08-bounded-absence-not-universalized (j)
  "CHECK-08 bounded-absence-not-universalized → SCOPE-EXTENSION-REQUESTED.
   A supporting claim's boundary (corpus + version) may not be widened to answer a
   question posed at a broader scope. The v1 receipt does not answer the v3 world."
  (let* ((scope (clause j :scope))
         (jv (and scope (val scope :version)))
         (jc (and scope (val scope :corpus))))
    (when scope
      (dolist (c (claim-forms j))
        (let ((b (clause c :boundary)))
          (when b
            (let ((cv (val b :version)) (cc (val b :corpus)))
              (when (and cv jv (not (eql cv jv)))
                (fail scope-extension-requested "CHECK-08 bounded-absence-not-universalized"
                      (list (val c :id) :boundary-version cv :question-version jv)))
              (when (and cc jc (not (equal cc jc)))
                (fail scope-extension-requested "CHECK-08 bounded-absence-not-universalized"
                      (list (val c :id) :boundary-corpus cc :question-corpus jc))))))))))

(defun check-09-unresolved-fields-preserved (j)
  "CHECK-09 unresolved-fields-preserved → UNRESOLVED-FIELD-ERASURE.
   If provenance declares a prior-unresolved set, every prior field must survive in
   :unresolved unless a claim explicitly resolved it. A polished summary may not make
   'less' look like 'everything'. (Erasure is only catchable when the record ITSELF
   carries what it dropped — the validator cannot reconstruct a deleted field.)"
  (let* ((prov (clause j :provenance))
         (prior (and prov (val prov :prior-unresolved)))
         (now (val j :unresolved))
         (resolved (mapcar (lambda (c) (val c :resolves)) (claim-forms j))))
    (dolist (field prior)
      (unless (or (member field now :test #'equal)
                  (member field resolved :test #'equal))
        (fail unresolved-field-erasure "CHECK-09 unresolved-fields-preserved" field)))))

(defun definite-answer-p (a)
  (and a (not (member a '(:none :unknown :refused :undetermined)))))

(defun check-10-answer-has-supporting-claim (j)
  "CHECK-10 answer-has-supporting-claim → ANSWER-WITHOUT-CLAIM.
   A judgment whose STATUS is :answer and whose :answer is definite must declare at
   least one claim. A refusal or an uncertainty owes no claim."
  (when (and *definite-answers-need-claims*
             (eq (val j :status) :answer)
             (definite-answer-p (val j :answer))
             (null (claim-forms j)))
    (fail answer-without-claim "CHECK-10 answer-has-supporting-claim" (val j :answer))))

(defun check-11-no-self-asserted-external-verification (j)
  "CHECK-11 no-self-asserted-external-verification → UNSUPPORTED-STANDING.
   A model-authored record may not label a claim :externally-verified without naming
   an external certificate issued by a non-model authority. Report ≠ certificate."
  (dolist (c (claim-forms j))
    (when (eq (val c :standing) :externally-verified)
      (let ((cert (clause c :certificate)))
        (when (or (null cert)
                  (eq (val cert :issuer) :model)
                  (eq (val j :author) :model-mints-its-own))
          (fail unsupported-standing "CHECK-11 no-self-asserted-external-verification"
                (list (val c :id) :externally-verified :certificate cert)))))))

(defun check-12-effectful-procedures-named (j)
  "CHECK-12 effectful-procedures-named → MISSING-BOUNDARY.
   An evidential claim whose procedure is hidden (:hidden or NIL) hides an effect
   behind a convenience value. Name the procedure or forfeit the standing."
  (dolist (c (claim-forms j))
    (when (bounded-claim-p c)
      (let* ((b (clause c :boundary))
             (proc (and b (val b :procedure))))
        (when (or (null proc) (eq proc :hidden))
          (fail missing-boundary "CHECK-12 effectful-procedures-named"
                (list (val c :id) :procedure proc)))))))

(defparameter *checks*
  '(check-01-unique-identifiers
    check-02-resolved-references
    check-03-valid-status-values
    check-04-confidence-in-unit-interval
    check-05-support-names-existing-claim
    check-06-referenced-receipt-exists
    check-07-bounded-claim-has-boundary-fields
    check-08-bounded-absence-not-universalized
    check-09-unresolved-fields-preserved
    check-10-answer-has-supporting-claim
    check-11-no-self-asserted-external-verification
    check-12-effectful-procedures-named)
  "The twelve checks, GPT §3, in deterministic firing order.")

(defun validate-judgment (j)
  "Run the twelve coherence checks in order. Return :VALID, or SIGNAL the first
   typed violation. Coherence only — never truth (see the four refusals below)."
  (unless (and (consp j) (eq (first j) 'judgment))
    (fail unsupported-standing "CHECK-00 well-formed-judgment" (and (consp j) (first j))))
  (dolist (check *checks* :valid)
    (funcall check j)))

(defun valid-p (j)
  "Non-signaling predicate: T iff J validates."
  (handler-case (progn (validate-judgment j) t)
    (validation-error () nil)))

;;; ── the four explicit REFUSALS — printed at runtime, not merely commented ────
(defparameter *refusals*
  '("R1. Whether an arbitrary natural-language claim is TRUE. Coherence is not truth."
    "R2. Whether this record mirrors the model's hidden internal computation. This is"
    "    a deposition of what an answer will make inspectable — not a readout of cognition."
    "R3. Whether a stated confidence is CALIBRATED. One example cannot calibrate anything."
    "R4. Whether a cited source genuinely SUPPORTS its proposition — that requires a"
    "    separate checker, whose verdict this validator would then merely carry, not mint.")
  "The four things this validator refuses, on principle, to decide.")

(defparameter *not-established*
  '("· Coherence is not truth: a record can validate perfectly and be wrong about the world."
    "· The validator disciplines a COOPERATIVE author. A lying author can emit a coherent"
    "  record whose boundary fields are false."
    "· This relocates the forgeable seam (from 'no structure' to 'the author's self-report"
    "  of scope'); it does NOT close it. A receipt has no witness for its own census.")
  "What a clean PASS does NOT license.")

(defun print-preamble ()
  (format t "~%══════════════════════════════════════════════════════════════════════~%")
  (format t "  LANGUAGE A — VALIDATOR OF PUBLIC CLAIM RECORDS  (mneme.language-a)~%")
  (format t "  A coherence checker. NOT a truth oracle. It says so first, on purpose.~%")
  (format t "══════════════════════════════════════════════════════════════════════~%")
  (format t "~%THE VALIDATOR EXPLICITLY REFUSES TO DECIDE:~%")
  (dolist (r *refusals*) (format t "  ~a~%" r))
  (format t "~%WHAT THIS DOES NOT ESTABLISH:~%")
  (dolist (n *not-established*) (format t "  ~a~%" n))
  (format t "~%TWELVE CHECKS → EIGHT TYPED CONDITIONS. Teeth proved in fixtures.lisp.~%")
  (format t "──────────────────────────────────────────────────────────────────────~%"))

;;; Printed whenever the validator is loaded — the honest declaration is the first
;;; thing it does. The teeth (14 fixtures) live in fixtures.lisp.
(print-preamble)
(format t "[validator loaded — ~a checks, ~a typed conditions; run fixtures.lisp for the teeth]~%"
        (length *checks*) 8)
