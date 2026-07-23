;;;; BASELINE.lisp — de-admissione-datorum baseline: disciplined idiomatic Common
;;;; Lisp with NO Slice /0 and NO Slice /1.  A good-faith attempt to encode dataset
;;;; admissibility (for a receiver and analysis purpose) using nothing but plain
;;;; data and hand-written predicate checks.
;;;;
;;;; The point of the baseline is NOT to fail.  Disciplined CL genuinely CAN encode
;;;; the six premise checks, name the missing ones, and refuse honestly — and the
;;;; first section proves it does.  The point is what the LAST section proves: that
;;;; this discipline is CONVENTION.  A second author, writing a straight-line
;;;; variant that simply never calls the population-suitability check, gets an
;;;; ":admissible" result whose return value is byte-indistinguishable from a grant
;;;; that DID check population-suitability.  Nothing in the data, the types, or the
;;;; return value carries a machine-visible trace that a required premise was
;;;; omitted.  That gap — enforced-by-nobody — is the flattening species waiting to
;;;; happen, and it is exactly what Slice /1's declared anatomy closes (SPECIMEN).
;;;;
;;;; Run: sbcl --non-interactive --load BASELINE.lisp   (exits 0)

(defpackage #:de-admissione-datorum-baseline (:use #:cl))
(in-package #:de-admissione-datorum-baseline)

;;; ==================================================================
;;; Evidence as plain data.  Each item names a predicate and its arguments —
;;; "explicit predicates as plain data", the honest CL way, no schema machinery.

(defun ev (predicate &rest args)
  (list* :predicate predicate args))
(defun ev-predicate (e) (getf e :predicate))
(defun ev-arg (e role) (getf e role))

;;; ------------------------------------------------------------------
;;; Hand-written premise checks.  Each looks through the supplied evidence for a
;;; matching item and confirms the arguments agree with the conclusion's
;;; dataset / instrument / receiver / purpose.  Honest and explicit.

(defun schema-conformance-p (evidence dataset)
  (some (lambda (e) (and (eq (ev-predicate e) :schema-conformance)
                         (equal (ev-arg e :dataset) dataset)))
        evidence))

(defun measured-by (evidence dataset)
  "Return the instrument this dataset declares it was measured by, or NIL."
  (dolist (e evidence)
    (when (and (eq (ev-predicate e) :measured-by)
               (equal (ev-arg e :dataset) dataset))
      (return (ev-arg e :instrument)))))

(defun calibration-valid-p (evidence dataset instrument)
  (some (lambda (e) (and (eq (ev-predicate e) :calibration-valid)
                         (equal (ev-arg e :dataset) dataset)
                         (equal (ev-arg e :instrument) instrument)))
        evidence))

(defun missingness-within-bound-p (evidence dataset)
  (some (lambda (e) (and (eq (ev-predicate e) :missingness-within-bound)
                         (equal (ev-arg e :dataset) dataset)))
        evidence))

(defun population-suitable-p (evidence dataset purpose)
  (some (lambda (e) (and (eq (ev-predicate e) :population-suitable)
                         (equal (ev-arg e :dataset) dataset)
                         (eq (ev-arg e :purpose) purpose)))
        evidence))

(defun purpose-permitted-p (evidence dataset receiver purpose)
  (some (lambda (e) (and (eq (ev-predicate e) :purpose-permitted)
                         (equal (ev-arg e :dataset) dataset)
                         (eq (ev-arg e :receiver) receiver)
                         (eq (ev-arg e :purpose) purpose)))
        evidence))

;;; ------------------------------------------------------------------
;;; The DISCIPLINED admission function.  Checks all six premises, collects the
;;; names of any missing, refuses honestly with the names.  Good-faith code.

(defparameter *required-premises*
  '(:schema-conformance :measured-by :calibration-valid :missingness-within-bound
    :population-suitable :purpose-permitted)
  "The convention: these six must hold.  Nothing enforces that a checker consults
this list — it is documentation a careful author reads.")

(defun admit-dataset (dataset receiver purpose evidence)
  "Disciplined admission: check every required premise, name the missing ones.
Returns (values DECISION MISSING-LIST); DECISION is :admissible or :refused."
  (let ((missing '())
        (instrument (measured-by evidence dataset)))
    (unless (schema-conformance-p evidence dataset)
      (push :schema-conformance missing))
    (unless instrument
      (push :measured-by missing))
    (unless (and instrument (calibration-valid-p evidence dataset instrument))
      (push :calibration-valid missing))
    (unless (missingness-within-bound-p evidence dataset)
      (push :missingness-within-bound missing))
    (unless (population-suitable-p evidence dataset purpose)
      (push :population-suitable missing))
    (unless (purpose-permitted-p evidence dataset receiver purpose)
      (push :purpose-permitted missing))
    (setf missing (nreverse missing))
    (if missing (values :refused missing) (values :admissible '()))))

;;; ------------------------------------------------------------------
;;; The CONVENTION-BREAKING variant.  Written by a second author in a hurry.  It
;;; checks schema, measurement, calibration, missingness, and permission — and
;;; simply never mentions population-suitability.  No bug, no exception, no
;;; warning.  It returns :admissible, its return value identical in shape to a
;;; disciplined grant.  A dataset fit only for DESCRIPTION is pronounced admissible
;;; for CAUSAL analysis, and nothing records that the suitability check was skipped.

(defun admit-dataset-fast (dataset receiver purpose evidence)
  "A straight-line admission that OMITS the population-suitability check.  Returns
:admissible with no trace that a required premise was never consulted."
  (let ((instrument (measured-by evidence dataset)))
    (when (and (schema-conformance-p evidence dataset)
               instrument
               (calibration-valid-p evidence dataset instrument)
               (missingness-within-bound-p evidence dataset)
               ;; population-suitability check absent — nothing here, nothing records it
               (purpose-permitted-p evidence dataset receiver purpose))
      :admissible)))

;;; ==================================================================
;;; Demonstration.

(defun line (fmt &rest args) (apply #'format t fmt args) (terpri))

(defun main ()
  (line "== de-admissione-datorum BASELINE (disciplined idiomatic CL, no Slice /0 or /1) ==")
  (let* ((ds "dataset-1")
         (rcv :receiver-a)
         (pur :causal)
         ;; evidence WITHOUT population-suitability — a dataset fit for description
         ;; whose fitness for CAUSAL analysis is unestablished
         (evidence-no-pop
           (list (ev :schema-conformance :dataset ds :schema "schema-v3")
                 (ev :measured-by :dataset ds :instrument "instrument-a")
                 (ev :calibration-valid :dataset ds :instrument "instrument-a"
                     :certificate "cert-1")
                 (ev :missingness-within-bound :dataset ds :bound 5)
                 (ev :purpose-permitted :dataset ds :receiver rcv :purpose pur)))
         ;; the same, plus a population-suitability fact
         (evidence-full
           (cons (ev :population-suitable :dataset ds :purpose pur)
                 evidence-no-pop)))

    (line "~%-- Section 1: the discipline WORKS --")
    (multiple-value-bind (d missing) (admit-dataset ds rcv pur evidence-full)
      (line "  disciplined, full evidence          => ~S~@[ (missing ~S)~]" d missing))
    (multiple-value-bind (d missing) (admit-dataset ds rcv pur evidence-no-pop)
      (line "  disciplined, population absent      => ~S; NAMED missing: ~S" d missing)
      (assert (eq d :refused))
      (assert (equal missing '(:population-suitable))))
    (line "  ^ disciplined CL genuinely refuses and names the omitted premise.")

    (line "~%-- Section 2: the discipline is only CONVENTION --")
    (let ((fast (admit-dataset-fast ds rcv pur evidence-no-pop)))
      (line "  straight-line variant, SAME evidence => ~S" fast)
      (assert (eq fast :admissible))
      (line "  ^ population-suitability was never represented, never checked, never missed."))

    (line "~%-- Section 3: the gap, shown side by side --")
    (let ((disciplined (multiple-value-list (admit-dataset ds rcv pur evidence-no-pop)))
          (fast (admit-dataset-fast ds rcv pur evidence-no-pop)))
      (line "  disciplined return : ~S" disciplined)
      (line "  fast return        : ~S" (list fast))
      (line "  A grant that CHECKED population-suitability and one that SKIPPED it are")
      (line "  indistinguishable from the return value alone — the ':admissible' keyword")
      (line "  carries no anatomy.  Which premises were consulted is invisible to the")
      (line "  caller, the type system, and any downstream auditor.  The guarantee lives")
      (line "  in a programmer's habit, enforced by nobody.  THIS is the convention-vs-")
      (line "  enforcement gap Slice /1 closes by making the premise set a declared,")
      (line "  receipt-bearing part of the judgment."))

    (line "~%baseline: convention demonstrated (discipline works AND is unenforced)")))

(main)
(finish-output)
(sb-ext:exit :code 0)
