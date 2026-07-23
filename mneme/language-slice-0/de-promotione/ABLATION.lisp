;;;; ABLATION.lisp — de-promotione with ONE mechanism removed.
;;;;
;;;; The altered mechanism (WORK-ORDER-0 §144-150, HYPOTHESIS §3): checked
;;;; RAISE is replaced by DIRECT STANDING ASSIGNMENT through an ordinary
;;;; constructor keyword.  This file plays the role of a language variant in
;;;; which the public claim constructor accepts :JUDGMENT.  Everything else —
;;;; witness objects, procedures, receipts, conditions, restarts — is left
;;;; standing and available.  Nothing else is changed.
;;;;
;;;; Constructing the variant requires reaching through the package boundary
;;;; (lisp-plus-slice0::%make-claim).  THAT IS ITSELF A MEASUREMENT: the
;;;; distance between the lawful surface and the laundering surface is
;;;; exactly one :: — the width of CL package discipline.  See
;;;; EXPECTED-FAILURES.md §ablation and §verdict.
;;;;
;;;; Run: sbcl --non-interactive --load ABLATION.lisp   (exit 0; every
;;;; laundering the specimen refused now SUCCEEDS SILENTLY — printed proof)

(load (merge-pathnames "../slice0.lisp" *load-truename*))

(defpackage #:de-promotione-ablation
  (:use #:cl #:lisp-plus-slice0)
  (:import-from #:lisp-plus-kernel0 #:make-identity))
(in-package #:de-promotione-ablation)

;;; The ablated surface: claim* — an ordinary constructor keyword mints
;;; judgment directly.  One mechanism changed; the checked relation of
;;; charter §7 is consulted nowhere.

(defun claim* (&key proposition by judgment judged-by)
  "The ablation: CLAIM with a :JUDGMENT keyword.  No witness is examined,
no procedure class is checked, no receipt is issued, no condition can fire."
  (lisp-plus-slice0::%make-claim
   :id (make-identity :claim (format nil "ablated-~d"
                                     (lisp-plus-slice0::%next-ordinal)))
   :proposition proposition
   :commitment :asserted
   :asserted-by by
   :judgment (when judgment
               (lisp-plus-slice0::%make-judgment-record
                :judgment judgment
                :procedure-id (make-identity :procedure
                                             (or judged-by "unconsulted"))
                :procedure-version 0
                :support-ids '()
                :receiver nil
                :ordinal (lisp-plus-slice0::%next-ordinal)))
   :lineage nil
   :ordinal (lisp-plus-slice0::%next-ordinal)))

(defvar *laundered* 0)

(defun launder (name c)
  (incf *laundered*)
  (format t "~&SILENT ~a — ~s judged ~a; conditions signaled: none; ~
receipt issued: none~%"
          name (claim-proposition c)
          (judgment-record-judgment (claim-judgment c))))

;;; A1 — exit status alone becomes release verification (specimen T3/T6
;;; refused this; here it is one keyword).
(launder "A1 exit-status -> release :verified"
         (claim* :proposition '(:release-ok :build-7) :by :build-pipeline
                 :judgment :verified))

;;; A2 — testimony becomes verification (specimen T1/T2 made this
;;; unrepresentable/refused; here nothing asks what supported it).
(launder "A2 colleague's word -> tests :verified"
         (claim* :proposition '(:tests-passed :suite-a) :by :colleague
                 :judgment :verified))

;;; A3 — the wrong suite's transcript, never examined, "verifies" this one.
(launder "A3 unmatched transcript -> suite :verified"
         (claim* :proposition '(:expected-suite-matched :suite-a) :by :me
                 :judgment :verified))

;;; A4 — a structural procedure's name is stamped onto a semantic judgment;
;;; the judgment-class wall (specimen T4) is never consulted.
(launder "A4 structural procedure stamped as verifier"
         (claim* :proposition '(:tests-passed :suite-a) :by :me
                 :judgment :verified :judged-by "launch-audit"))

;;; The destroyed property, stated exactly: an ablated claim is
;;; INDISTINGUISHABLE by every public accessor from a lawfully raised one.
(let ((ablated (claim* :proposition '(:tests-passed :suite-a) :by :me
                       :judgment :verified :judged-by "suite-verification")))
  (format t "~&~%indistinguishability: claim-p=~a judgment=~a procedure=~a ~
support-ids=~s lineage=~s~%"
          (claim-p ablated)
          (judgment-record-judgment (claim-judgment ablated))
          (lisp-plus-kernel0:durable-identity-name
           (judgment-record-procedure-id (claim-judgment ablated)))
          (judgment-record-support-ids (claim-judgment ablated))
          (claim-lineage ablated))
  (format t "The empty :support-ids and nil :lineage are the ONLY forensic ~
trace — and nothing checks them.~%"))

(format t "~&~%~d launderings, 0 conditions, 0 receipts — the property is ~
destroyed.~%" *laundered*)
