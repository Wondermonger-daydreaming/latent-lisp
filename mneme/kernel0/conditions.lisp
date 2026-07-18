(in-package #:lisp-plus-kernel0)

(defun %proper-list-p (value)
  (loop with slow = value
        with fast = value
        do (cond ((null fast) (return t))
                 ((atom fast) (return nil)))
           (setf fast (cdr fast))
           (cond ((null fast) (return t))
                 ((atom fast) (return nil)))
           (setf fast (cdr fast)
                 slow (cdr slow))
           (when (eq fast slow) (return nil))))

(defun %permitted-restart-name-p (name)
  (member name
          '(supply-resolved-identity
            choose-private-staging-channel
            request-lawful-capability-restoration
            begin-reconciliation
            authorize-supersession
            preserve-payload-mark-invalid
            stop-and-export-evidence)
          :test #'eq))

(define-condition kernel0-condition (error)
  ((process-id
    :initarg :process-id
    :initform nil
    :reader kernel0-condition-process-id)
   (attempt-id
    :initarg :attempt-id
    :initform nil
    :reader kernel0-condition-attempt-id)
   (seat-id
    :initarg :seat-id
    :initform nil
    :reader kernel0-condition-seat-id)
   (operation-id
    :initarg :operation-id
    :initform nil
    :reader kernel0-condition-operation-id)
   (failed-invariant
    :initarg :failed-invariant
    :reader kernel0-condition-failed-invariant)
   (evidence-ids
    :initarg :evidence-ids
    :initform nil
    :reader kernel0-condition-evidence-ids)
   (frontier-crossed-p
    :initarg :frontier-crossed-p
    :initform nil
    :reader kernel0-condition-frontier-crossed-p)
   (permitted-restarts
    :initarg :permitted-restarts
    :initform nil
    :reader kernel0-condition-permitted-restarts))
  (:report
   (lambda (condition stream)
     (format stream "~A: ~A"
             (type-of condition)
             (slot-value condition 'failed-invariant))))
  (:documentation
   "Base for every specified Kernel /0 refusal.  The Common Lisp condition
type is the condition type required by section 20.1; the remaining required
diagnostic context is carried by the slots exposed through the readers."))

(defmacro %define-kernel0-condition-family (&rest names)
  `(progn
     ,@(loop for name in names
             collect `(define-condition ,name (kernel0-condition) ()))))

;; Section 20.2 -- identity conditions.
(%define-kernel0-condition-family
 unresolved-identity
 duplicate-process-identity
 duplicate-seat-identity
 duplicate-attempt-identity
 duplicate-external-request-identity
 seat-occupied
 attempt-terminal
 identity-drift)

;; Section 20.3 -- authority conditions.
(%define-kernel0-condition-family
 capability-missing
 capability-revoked
 capability-expired
 capability-scope-mismatch
 capability-budget-exceeded
 capability-count-exceeded
 capability-restoration-denied
 capability-self-restoration-forbidden
 capability-restoration-scope-enlarged
 minting-authority-invalid)

;; Section 20.4 -- effect and retry conditions.
(%define-kernel0-condition-family
 frontier-precondition-failed
 frontier-already-crossed
 unresolved-irreversible-effect
 unsafe-retry
 unstructured-uncertainty
 implicit-fallback-forbidden
 supersession-required
 supersession-unauthorized
 reconciliation-unsupported
 reconciliation-insufficient)

;; Section 20.5 -- manifestation and interpretation conditions.
(%define-kernel0-condition-family
 manifestation-payload-missing
 present-payload-erasure
 invalidity-parser-missing
 partial-manifestation-settlement-inflation
 interpretation-procedure-missing)

;; Section 20.6 -- store and journal conditions.
(%define-kernel0-condition-family
 store-unavailable
 store-append-failed
 store-durability-unknown
 journal-prefix-invalid
 journal-torn-tail
 journal-illegal-transition
 journal-merge-receipt-required
 fold-nondeterministic)

;; Section 20.7 -- standing conditions.
(%define-kernel0-condition-family
 standing-inflation
 witness-separation-violation
 reconstruction-origin-erasure
 bare-visibility-scope
 bare-validation-scope
 exposed-principal-missing)

;; Section 20.8 -- boundary conditions.
(%define-kernel0-condition-family
 noncanonical-durable-value
 machine-configuration-drift
 adapter-version-drift
 channel-policy-missing
 channel-policy-amendment-unauthorized
 publication-authority-missing
 outcome-context-discard
 unsafe-host-escape
 unsupported-reconstruction)

(defun %signal-condition-contract (detail)
  (error
   (make-condition
    'kernel0-condition
    :failed-invariant
    (format nil
            "§20.1 [F: CND-1]: every Kernel /0 condition MUST carry valid required context (~A)"
            detail)
    :evidence-ids nil
    :frontier-crossed-p nil
    :permitted-restarts nil)))

(defmethod initialize-instance :after ((condition kernel0-condition) &key)
  (unless (and (slot-boundp condition 'failed-invariant)
               (stringp (kernel0-condition-failed-invariant condition))
               (plusp (length
                       (kernel0-condition-failed-invariant condition))))
    (%signal-condition-contract "FAILED-INVARIANT must be a non-empty string"))
  (unless (%proper-list-p (kernel0-condition-evidence-ids condition))
    (%signal-condition-contract "EVIDENCE-IDS must be a proper list"))
  (unless (and (%proper-list-p
                (kernel0-condition-permitted-restarts condition))
               (every #'%permitted-restart-name-p
                      (kernel0-condition-permitted-restarts condition)))
    (%signal-condition-contract
     "PERMITTED-RESTARTS must contain only section 20.9 lawful names")))

(defun signal-kernel0
    (condition-type
     &key
       process-id
       attempt-id
       seat-id
       operation-id
       (failed-invariant nil failed-invariant-supplied-p)
       (evidence-ids nil)
       (frontier-crossed-p nil)
       (permitted-restarts nil))
  "Signal CONDITION-TYPE as a Kernel /0 error with section 20.1 context.
FAILED-INVARIANT is a required keyword argument.  CONDITION-TYPE must name a
subtype of KERNEL0-CONDITION, and every listed restart must be one of the
lawful section 20.9 restart names."
  (unless failed-invariant-supplied-p
    (%signal-condition-contract "FAILED-INVARIANT is required"))
  (multiple-value-bind (kernel-subtype-p known-p)
      (and (symbolp condition-type)
           (find-class condition-type nil)
           (subtypep condition-type 'kernel0-condition))
    (unless (and kernel-subtype-p known-p)
      (%signal-condition-contract
       "CONDITION-TYPE must name a KERNEL0-CONDITION subtype")))
  (error
   (make-condition condition-type
                   :process-id process-id
                   :attempt-id attempt-id
                   :seat-id seat-id
                   :operation-id operation-id
                   :failed-invariant failed-invariant
                   :evidence-ids (if (%proper-list-p evidence-ids)
                                     (copy-list evidence-ids)
                                     evidence-ids)
                   :frontier-crossed-p (not (null frontier-crossed-p))
                   :permitted-restarts
                   (if (%proper-list-p permitted-restarts)
                       (copy-list permitted-restarts)
                       permitted-restarts))))

(defmacro with-kernel0-restarts (clauses &body body)
  "Evaluate BODY with explicit lawful Kernel /0 restart CLAUSES.

Each clause has RESTART-CASE syntax.  Only the seven names admitted by section
20.9 are accepted; in particular, none of the prohibited implicit restarts can
be offered through this macro.  A signaling site must list the same offered
names in its condition's PERMITTED-RESTARTS slot."
  (dolist (clause clauses)
    (unless (and (consp clause)
                 (%permitted-restart-name-p (car clause)))
      (%signal-condition-contract
       (format nil "restart clause is not permitted by §20.9: ~S" clause))))
  `(restart-case (progn ,@body)
     ,@clauses))
