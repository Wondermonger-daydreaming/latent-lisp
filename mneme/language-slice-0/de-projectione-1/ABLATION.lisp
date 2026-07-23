;;;; ABLATION.lisp — de-projectione Session 1 with ONE mechanism removed.
;;;;
;;;; PRIMARY ABLATION (chosen from the four candidates): COPY THE SOURCE
;;;; JUDGMENT.  project-claim* hands the receiver a located claim carrying
;;;; the source's judgment-record verbatim and reports the single label
;;;; :preserved.
;;;;
;;;; WHY THIS ONE ISOLATES THE CLAIMED MECHANISM: the receiver-context
;;;; records, the store, the views machinery, even the receipt struct all
;;;; remain present and loadable — the :from/:to/:store arguments are still
;;;; accepted.  The ONLY thing removed is reconstruction: the receiver's
;;;; judgment no longer passes through the receiver's own accessible
;;;; supports, recognized authorities, and executable procedures.  Every
;;;; contextual distinction the specimen demonstrated (P1, P3, P5, P7, P8,
;;;; P9) collapses at once, which shows those distinctions were carried by
;;;; the reconstruction step and by nothing else.  (The other candidate
;;;; ablations — receiver-slot replacement, flat one-of-six label, receiver
;;;; as bare name — each destroy a SYMPTOM of the same joint; copying the
;;;; judgment destroys the joint itself.)
;;;;
;;;; Run: sbcl --non-interactive --load ABLATION.lisp   (exit 0; the
;;;; launderings SUCCEED silently — printed proof)

(load (merge-pathnames "../slice0-projection.lisp" *load-truename*))

(defpackage #:de-projectione-1-ablation
  (:use #:cl #:lisp-plus-slice0)
  (:import-from #:lisp-plus-kernel0 #:make-identity #:make-procedure-descriptor))
(in-package #:de-projectione-1-ablation)

;;; The ablated act: judgment travels by copy.  One mechanism changed.

(defun project-claim* (source-claim &key from to store)
  "The ablation: projection as COPY.  Receiver context accepted, ignored."
  (declare (ignore from store))
  (values
   (lisp-plus-slice0::%make-claim
    :id (make-identity :claim (format nil "ablated-~d"
                                      (lisp-plus-slice0::%next-ordinal)))
    :proposition (claim-proposition source-claim)
    :commitment :asserted
    :asserted-by (claim-asserted-by source-claim)
    :judgment (claim-judgment source-claim)   ; <- THE COPY
    :lineage (list (claim-id source-claim))
    :ordinal (lisp-plus-slice0::%next-ordinal))
   :preserved))                               ; <- THE FLAT LABEL

;;; Fixture: one verified-at-source claim; receivers who should differ.

(defun semantic-procedure (name admits)
  (promotion-procedure
   :descriptor (make-procedure-descriptor
                :procedure-id (make-identity :procedure name)
                :version 0 :judgment-class :semantic
                :input-domain '(:kinds (:subject-answer))
                :result-vocabulary '(:accepted :rejected)
                :evidence-requirements '())
   :admits admits))

(defparameter *suite-verification*
  (semantic-procedure "suite-verification" '((:direct :transcript-parse))))
(defparameter *w-parse*
  (witness :for '(:tests-passed :suite-a) :mode :direct :kind :transcript-parse
           :source :transcript-parser :content '(:parsed 12 :failed 0)))
(defparameter *store* (support-store *w-parse*))
(defparameter *c-tests*
  (multiple-value-bind (v r)
      (raise (claim :proposition '(:tests-passed :suite-a) :by :build-pipeline)
             :to :verified :per *suite-verification*
             :considering (list *w-parse*))
    (declare (ignore r)) v))

(defparameter *client*    ; reaches nothing — should NOT hold :verified
  (receiver-context :context-id :client :accessible-supports '()
                    :executable-procedures (list *suite-verification*)
                    :recognized-authorities '(:transcript-parser)))
(defparameter *stranger*  ; recognizes nothing — should NOT hold :verified
  (receiver-context :context-id :stranger
                    :accessible-supports (list (witness-id *w-parse*))
                    :executable-procedures (list *suite-verification*)
                    :recognized-authorities '()))

(defvar *laundered* 0)
(dolist (ctx (list *client* *stranger*))
  (multiple-value-bind (theirs label)
      (project-claim* *c-tests* :from nil :to ctx :store *store*)
    (incf *laundered*)
    (format t "~&SILENT ~a receives ~s judged ~a, label ~s — context never ~
consulted; blockers: none; obligations: none; inaccessible residue: none~%"
            (receiver-context-context-id ctx)
            (claim-proposition theirs)
            (judgment-record-judgment (claim-judgment theirs))
            label)))

;;; What the flat label erases: the true situation at :client was
;;; simultaneously regraded AND obligation-producing (P1/P6 in the
;;; specimen); the single :preserved is a lie by omission, and the copy
;;; is a lie by commission — the receiver's judgment record even names the
;;; SOURCE's procedure as its licensor.

(format t "~&copied judgment claims procedure ~s licensed it for :client — ~
a procedure :client cannot run.~%"
        (lisp-plus-kernel0:durable-identity-name
         (judgment-record-procedure-id
          (claim-judgment (project-claim* *c-tests* :to *client*)))))

(format t "~&~%~d launderings, 0 blockers, 0 receipts — travel no longer ~
changes anything; the property is destroyed.~%" *laundered*)
