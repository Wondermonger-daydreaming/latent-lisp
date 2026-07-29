;;;; conditions.lisp — Process Journal /0 §23 typed conditions.
;;;;
;;;; §23: "Each condition carries store identity where available, byte offset,
;;;; expected ordinal, terminal digest, requirement ID, and bounded evidence.
;;;; Conditions compose with the Common Lisp condition system; signaling
;;;; remains distinct from choosing a lawful restart."
;;;; PJ-CND-1: "ignore digest and continue" is not a lawful standard restart.
;;;; PJ-CND-2: lawful restarts may include abandon, inspect,
;;;; salvage-to-new-store, reconcile-identical-event, request-authorized-merge.

(in-package #:lisp-plus-journal0)

(define-condition pj0-condition (error)
  ((store-id :initarg :store-id :initform nil
             :reader pj0-condition-store-id)
   (byte-offset :initarg :byte-offset :initform nil
                :reader pj0-condition-byte-offset)
   (expected-ordinal :initarg :expected-ordinal :initform nil
                     :reader pj0-condition-expected-ordinal)
   (terminal-digest :initarg :terminal-digest :initform nil
                    :reader pj0-condition-terminal-digest)
   (requirement-id :initarg :requirement-id :initform nil
                   :reader pj0-condition-requirement-id)
   (evidence :initarg :evidence :initform nil
             :reader pj0-condition-evidence)
   (detail :initarg :detail :initform nil
           :reader pj0-condition-detail))
  (:report
   (lambda (condition stream)
     (format stream "~a~@[ [~a]~]~@[ store ~a~]~@[ at byte ~a~]~@[ expected ordinal ~a~]~@[: ~a~]"
             (type-of condition)
             (pj0-condition-requirement-id condition)
             (pj0-condition-store-id condition)
             (pj0-condition-byte-offset condition)
             (pj0-condition-expected-ordinal condition)
             (pj0-condition-detail condition)))))

(defmacro %define-pj0-conditions (&rest names)
  `(progn
     ,@(loop for name in names
             collect `(define-condition ,name (pj0-condition) ()))))

;; The twenty-one §23 condition types, exactly as listed.
(%define-pj0-conditions
 pj0-metadata-invalid
 pj0-store-id-mismatch
 pj0-noncanonical-payload
 pj0-invalid-utf8
 pj0-header-invalid
 pj0-ordinal-gap
 pj0-payload-length-invalid
 pj0-payload-digest-mismatch
 pj0-previous-digest-mismatch
 pj0-frame-digest-mismatch
 pj0-frame-separator-invalid
 pj0-torn-tail
 pj0-interior-corruption
 pj0-event-identity-collision
 pj0-duplicate-committed-event
 pj0-lock-failure
 pj0-durability-barrier-failure
 pj0-salvage-receipt-required
 pj0-merge-receipt-required
 pj0-merge-causal-conflict
 unsupported-reconstruction)

;; §34: bound refusal is a RESOURCE condition, distinct from any corruption
;; claim.  Additional to the §23 floor ("distinguishes at least").
(define-condition pj0-resource-bound-exceeded (pj0-condition) ())

(defun signal-pj0 (type &rest initargs)
  (error (apply #'make-condition type initargs)))

(defmacro with-pj0-restarts ((&key (abandon t) inspect salvage reconcile merge)
                             &body body)
  "Establish the PJ-CND-2 lawful restarts around BODY.  Each keyword supplies
the restart's return-value thunk (or T for a NIL-returning restart).  No
'ignore digest and continue' restart exists anywhere in this store (PJ-CND-1)."
  (let ((restarts '()))
    (flet ((clause (name form)
             (when form
               (push `(,name ()
                        ,(if (eq form t) nil `(funcall ,form)))
                     restarts))))
      (clause 'abandon abandon)
      (clause 'inspect-evidence inspect)
      (clause 'salvage-to-new-store salvage)
      (clause 'reconcile-identical-event reconcile)
      (clause 'request-authorized-merge merge))
    `(restart-case (progn ,@body)
       ,@(reverse restarts))))
