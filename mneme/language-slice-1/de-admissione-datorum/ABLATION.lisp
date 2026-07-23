;;;; ABLATION.lisp — de-admissione-datorum, ablated back to the flattened species.
;;;;
;;;; ONE change from SPECIMEN, held as similar as possible in everything else: the
;;;; structured, six-premise judgment schema is collapsed to a SINGLE OPAQUE atomic
;;;; proposition — (:predicate :dataset-valid (:dataset "dataset-1")) — promoted by
;;;; a GENERIC evidence-content procedure (Slice /0 only, plain mode/kind
;;;; admissibility, no schema, no declared premises).  Schema-conformance and
;;;; low-missingness ride as opaque :content on generic witnesses whose :for is the
;;;; validity token itself.  Calibration (measurement-validity), population-
;;;; suitability, and permitted-purpose are never propositions, never premises,
;;;; never checked.
;;;;
;;;; This ablation SUCCEEDS at being wrong: it drives the real, frozen Slice /0
;;;; RAISE to a genuine :verified promotion from schema + missingness content while
;;;; calibration, population-suitability, and purpose-permission are nowhere in the
;;;; machine.  That success IS the point — it reproduces the flattening species
;;;; exactly (the scientific-data cousin of the supply-chain S3 defect), and shows
;;;; the enforcement lives in the DECLARED ANATOMY (SPECIMEN), not in having
;;;; evidence.  A dataset that merely conforms and is not-too-empty is pronounced
;;;; "valid for analysis" with no notion that its instrument was uncalibrated, its
;;;; population unfit for causal inference, or its use unpermitted.
;;;;
;;;; FRONT-DOOR DISCIPLINE: single-colon public surfaces only.
;;;;
;;;; Run: sbcl --non-interactive --load ABLATION.lisp   (exits 0)

(unless (find-package :lisp-plus-slice0)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "../../language-slice-0/slice0-transmissibility.lisp"
                           *load-truename*))))

(defpackage #:de-admissione-datorum-ablation (:use #:cl))
(in-package #:de-admissione-datorum-ablation)

(defun ln (fmt &rest args) (apply #'format t fmt args) (terpri))

;;; The opaque validity token — a single atomic-ish Slice /0 proposition.
;;; No receiver, no purpose, no instrument, no premise anatomy: just
;;; "dataset-1 is valid".
(defparameter *opaque-valid*
  '(:predicate :dataset-valid (:dataset "dataset-1")))

;;; A GENERIC content procedure: admits direct content-witnesses by (mode kind).
;;; It knows nothing about calibration, populations, purposes, or consent — only
;;; that SOME admitted content witness was offered.  This is the flattening bypass.
(defparameter *generic-procedure*
  (lisp-plus-slice0:promotion-procedure
   :descriptor (lisp-plus-kernel0:make-procedure-descriptor
                :procedure-id (lisp-plus-kernel0:make-identity
                               :procedure "admit/dataset/opaque")
                :version 1
                :judgment-class :semantic
                :result-vocabulary '(:verified :refuted))
   :admits (list (list :direct :schema-evidence)
                 (list :direct :missingness-evidence))))

(defun content-witness (kind payload)
  "A generic content witness FOR the opaque validity token — its evidence lives
entirely in opaque :content, never as a checked proposition."
  (lisp-plus-slice0:witness
   :for *opaque-valid* :mode :direct :kind kind
   :source :data-steward :content payload))

(defun main ()
  (ln "== de-admissione-datorum ABLATION — opaque token + generic content procedure ==")
  (ln "opaque proposition : ~S" *opaque-valid*)
  (ln "procedure admits   : ~S"
      (lisp-plus-slice0:promotion-procedure-admits *generic-procedure*))
  (ln "")
  (let* ((schema-w     (content-witness :schema-evidence
                                        '(:schema "schema-v3" :status :conforms)))
         (missingness-w (content-witness :missingness-evidence
                                         '(:missing-fraction 0.02 :bound 0.05 :status :within)))
         ;; NOTE: no calibration, population, or permission witness exists — each
         ;; is unrepresentable here; there is no proposition, role, or premise for
         ;; measurement-validity, population-suitability, or permitted-purpose.
         (the-claim (lisp-plus-slice0:claim :proposition *opaque-valid*
                                            :by :analyst)))
    (multiple-value-bind (granted receipt)
        (lisp-plus-slice0:raise the-claim
                                :to :verified :per *generic-procedure*
                                :considering (list schema-w missingness-w))
      (declare (ignore receipt))
      (let ((jr (lisp-plus-slice0:claim-judgment granted)))
        (ln "supports considered : schema-evidence + missingness-evidence (content only)")
        (ln "calibration support : (none — measurement-validity unrepresentable)")
        (ln "population support  : (none — population-suitability unrepresentable)")
        (ln "permission support  : (none — permitted-purpose unrepresentable)")
        (ln "raise decision      : ~S" (lisp-plus-slice0:judgment-record-judgment jr))
        (ln "granted claim prop  : ~S" (lisp-plus-slice0:claim-proposition granted))
        (ln "")
        ;; The honest epitaph — state exactly what happened.
        (ln "ABLATION EPITAPH: admissibility was VERIFIED for dataset-1 from ~
schema-conformance + low-missingness content-witnesses alone; calibration, ~
population-suitability, and permitted-purpose were never represented as ~
propositions and never checked — the flattening species reproduced exactly.")
        (assert (eq (lisp-plus-slice0:judgment-record-judgment jr) :verified))))))

(main)
(finish-output)
(sb-ext:exit :code 0)
