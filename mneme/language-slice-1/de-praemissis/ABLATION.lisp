;;;; ABLATION.lisp — de-praemissis, ablated back to the S3 species.
;;;;
;;;; ONE change from SPECIMEN, held as similar as possible in everything else:
;;;; the structured, four-premise judgment schema is collapsed to a SINGLE
;;;; OPAQUE atomic proposition — (:predicate :artifact-admissible (:artifact …)) —
;;;; promoted by a GENERIC evidence-content procedure (Slice /0 only, plain
;;;; mode/kind admissibility, no schema, no declared premises).  Digest-match and
;;;; signature-valid ride as opaque :content on generic witnesses whose :for is
;;;; the admissibility token itself.  Signer recognition is never a proposition,
;;;; never a premise, never checked.
;;;;
;;;; This ablation SUCCEEDS at being wrong: it drives the real, frozen Slice /0
;;;; RAISE to a genuine :verified promotion from digest + signature content while
;;;; recognition is nowhere in the machine.  That success IS the point — it
;;;; reproduces the Stranger /1 S3 defect exactly, and shows that the enforcement
;;;; lives in the DECLARED ANATOMY (SPECIMEN), not in having evidence.
;;;;
;;;; FRONT-DOOR DISCIPLINE: single-colon public surfaces only; no internal-symbol
;;;; access anywhere (grep-verified zero at closure).
;;;;
;;;; Run: sbcl --non-interactive --load ABLATION.lisp   (exits 0)

(unless (find-package :lisp-plus-slice0)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "../../language-slice-0/slice0-transmissibility.lisp"
                           *load-truename*))))

(defpackage #:de-praemissis-ablation (:use #:cl))
(in-package #:de-praemissis-ablation)

(defun ln (fmt &rest args) (apply #'format t fmt args) (terpri))

;;; The opaque admissibility token — a single atomic-ish Slice /0 proposition.
;;; No receiver, no purpose, no premise anatomy: just "artifact-1 is admissible".
(defparameter *opaque-admissible*
  '(:predicate :artifact-admissible (:artifact "artifact-1")))

;;; A GENERIC content procedure: admits direct content-witnesses by (mode kind).
;;; It knows nothing about digests, signatures, or signers — only that SOME
;;; admitted content witness was offered.  This is the S3 bypass in miniature.
(defparameter *generic-procedure*
  (lisp-plus-slice0:promotion-procedure
   :descriptor (lisp-plus-kernel0:make-procedure-descriptor
                :procedure-id (lisp-plus-kernel0:make-identity
                               :procedure "admit/artifact/opaque")
                :version 1
                :judgment-class :semantic
                :result-vocabulary '(:verified :refuted))
   :admits (list (list :direct :digest-evidence)
                 (list :direct :signature-evidence))))

(defun content-witness (kind payload)
  "A generic content witness FOR the opaque admissibility token — its evidence
lives entirely in opaque :content, never as a checked proposition."
  (lisp-plus-slice0:witness
   :for *opaque-admissible* :mode :direct :kind kind
   :source :signer :content payload))

(defun main ()
  (ln "== de-praemissis ABLATION — opaque token + generic content procedure ==")
  (ln "opaque proposition : ~S" *opaque-admissible*)
  (ln "procedure admits   : ~S"
      (lisp-plus-slice0:promotion-procedure-admits *generic-procedure*))
  (ln "")
  (let* ((digest-w    (content-witness :digest-evidence
                                       '(:digest "D1" :status :matches)))
         (signature-w (content-witness :signature-evidence
                                       '(:signature "S1" :key "K1" :status :valid)))
         ;; NOTE: no recognition witness exists — recognition is unrepresentable
         ;; here; there is no proposition, role, or premise for a signer.
         (the-claim (lisp-plus-slice0:claim :proposition *opaque-admissible*
                                            :by :deployer)))
    (multiple-value-bind (granted receipt)
        (lisp-plus-slice0:raise the-claim
                                :to :verified :per *generic-procedure*
                                :considering (list digest-w signature-w))
      (declare (ignore receipt))
      (let ((jr (lisp-plus-slice0:claim-judgment granted)))
        (ln "supports considered : digest-evidence + signature-evidence (content only)")
        (ln "recognition support : (none — unrepresentable in the opaque model)")
        (ln "raise decision      : ~S" (lisp-plus-slice0:judgment-record-judgment jr))
        (ln "granted claim prop  : ~S" (lisp-plus-slice0:claim-proposition granted))
        (ln "")
        ;; The honest epitaph — state exactly what happened.
        (ln "ABLATION EPITAPH: admissibility was VERIFIED for artifact-1 from ~
digest-match + signature-valid content-witnesses alone; signer recognition was ~
never represented as a proposition and never checked — the S3 species reproduced ~
exactly.")
        (assert (eq (lisp-plus-slice0:judgment-record-judgment jr) :verified))))))

(main)
(finish-output)
(sb-ext:exit :code 0)
