;;;; conditions.lisp — the §22 typed condition surface, six groups.
;;;;
;;;; Every AP0 condition carries: whether the frontier was crossed, the
;;;; enforced AP0 requirement ID, involved identities, evidence references,
;;;; and lawful restart names (§22).  No restart may silently retry, invent
;;;; provider identity, enlarge authority, or discard captured partials —
;;;; the restart set below is the §22 closed initial list and each restart
;;;; is inert unless established by WITH-AP0-RESTARTS at a lawful site.
;;;;
;;;; Reuse, not twinning: RECONCILIATION-INSUFFICIENT already exists in the
;;;; adopted Kernel /0 with the same meaning (an insufficient basis for
;;;; settling an uncertain external effect); this lane imports and
;;;; re-exports it and defines NO adapter0 twin.  All other §22 names are
;;;; defined here because no predecessor carries their semantics.
;;;;
;;;; — CLAVIGER-IV (Claude Fable 5 subagent), 2026-07-30

(in-package #:lisp-plus-adapter0)

(define-condition ap0-condition (error)
  ((requirement-id :initarg :requirement-id :initform nil
                   :reader ap0-condition-requirement-id)
   (frontier-crossed :initarg :frontier-crossed :initform :unknown
                     :reader ap0-condition-frontier-crossed)
   (identities :initarg :identities :initform '()
               :reader ap0-condition-identities)
   (evidence :initarg :evidence :initform '()
             :reader ap0-condition-evidence)
   (restarts :initarg :restarts :initform '(:abandon)
             :reader ap0-condition-restarts)
   (detail :initarg :detail :initform nil
           :reader ap0-condition-detail))
  (:report
   (lambda (condition stream)
     (format stream "~a~@[ [~a]~]~@[ — ~a~]"
             (type-of condition)
             (ap0-condition-requirement-id condition)
             (ap0-condition-detail condition)))))

(defmacro %define-ap0-conditions (&rest names)
  `(progn
     ,@(loop for name in names
             collect `(define-condition ,name (ap0-condition) ()))))

;;; Group 1 — descriptor and identity.
(%define-ap0-conditions
 adapter-descriptor-invalid
 adapter-identity-missing
 adapter-version-drift
 adapter-capability-undeclared
 adapter-capability-unknown
 resolved-model-identity-unavailable
 provider-request-identity-conflict
 provider-request-id-invented
 implicit-provider-fallback)

;;; Group 2 — dispatch and acknowledgment.
(%define-ap0-conditions
 adapter-preparation-refused
 adapter-dispatch-failed-pre-frontier
 adapter-dispatch-failed-post-frontier
 acknowledgment-class-unsupported
 acknowledgment-ambiguous
 provider-request-id-unavailable
 idempotency-unsupported
 idempotency-domain-mismatch)

;;; Group 3 — streaming.
(%define-ap0-conditions
 stream-identity-missing
 stream-chunk-adapter-identity-missing
 stream-sequence-gap
 stream-sequence-conflict
 stream-chunk-identity-collision
 stream-finality-conflict
 stream-durability-unknown
 stream-persistence-order-invalid
 partial-manifestation-erasure)

;;; Group 4 — envelope and projection.
(%define-ap0-conditions
 provider-envelope-missing
 provider-envelope-integrity-failed
 projection-procedure-missing
 projection-failed
 projection-output-noncanonical
 subject-manifestation-conflated-with-envelope
 present-payload-erasure
 absence-mapping-table-miss
 projection-origin-invalid
 provider-envelope-redaction-invalid)

;;; Group 5 — usage, cost, cancellation, reconciliation.
;;; RECONCILIATION-INSUFFICIENT is Kernel /0's (imported; no twin here).
(%define-ap0-conditions
 usage-standing-missing
 cost-standing-missing
 cost-float-noncanonical
 ;; Erratum 0.1: malformed (non-float) cost lexeme syntax — the narrow
 ;; grammar's refusal for junk, missing parts, or a zero denominator.
 cost-lexeme-noncanonical
 cancellation-unsupported
 cancellation-unconfirmed
 reconciliation-unsupported
 reconciliation-identity-missing)

;;; Group 6 — exposure and witnessing.
(%define-ap0-conditions
 exposed-principal-boundary-unknown
 exposed-principal-drift
 adapter-truth-minting
 adapter-witness-boundary-missing)

(defun signal-ap0 (name &rest initargs)
  (apply #'error name initargs))

;;; §22 lawful restarts.  Establishing a restart here does nothing by
;;; itself; each is bound only where the surrounding operation can honor it
;;; lawfully.  None retries, mints identity, enlarges authority, or
;;; discards captured partials.
(defmacro with-ap0-restarts ((&rest restart-names) &body body)
  `(restart-case (progn ,@body)
     ,@(loop for name in restart-names
             collect (ecase name
                       (:abandon
                        `(abandon () :report "Abandon the operation." nil))
                       (:reconcile
                        `(reconcile ()
                           :report "Proceed to reconciliation." :reconcile))
                       (:provide-missing-identity
                        `(provide-missing-identity (identity)
                           :report "Supply the missing identity." identity))
                       (:narrow-scope
                        `(narrow-scope (scope)
                           :report "Narrow the operation scope." scope))
                       (:reproject
                        `(reproject ()
                           :report "Re-project from captured evidence."
                           :reproject))
                       (:mark-present-invalid
                        `(mark-present-invalid ()
                           :report "Record the payload as present-invalid."
                           :present-invalid))
                       (:request-supersession
                        `(request-supersession ()
                           :report "Request Kernel supersession."
                           :request-supersession))))))
