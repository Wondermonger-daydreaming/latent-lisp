;;;; conditions.lisp — capability0's OWN typed conditions.
;;;;
;;;; The lane's standing rule (owner's charge): PREFER signaling kernel /0's
;;;; existing exported condition types.  This file defines a condition ONLY
;;;; where reuse would be dishonest; each entry names its WHY inline and the
;;;; full adjudication lives in CAPABILITY-0-RETURN.md.  Never both for one
;;;; meaning: every refusal in this lane has exactly one home.
;;;;
;;;;   kernel0 REUSED (signaled by query.lisp / fold.lisp):
;;;;     capability-missing          — no matching grant in the ledger
;;;;     capability-revoked          — grant present, revocation present
;;;;     capability-scope-mismatch   — a named term of the request differs
;;;;                                   (offending-field carries WHICH term)
;;;;     minting-authority-invalid   — a journaled grant/revocation names an
;;;;                                   issuer the declared bootstrap does not
;;;;                                   ground
;;;;     journal-prefix-invalid      — interior corruption: liveness cannot
;;;;                                   be derived (law 10 choice: REFUSE)
;;;;
;;;;   capability0's OWN (defined below):
;;;;     cap0-bootstrap-missing        — the caller supplied no explicit
;;;;         bootstrap authority.  kernel0's capability-* family is about a
;;;;         CAPABILITY's standing at a check; this is the QUERY PROCEDURE's
;;;;         configuration being absent — reusing capability-missing would
;;;;         let a config omission masquerade as a ledger fact.
;;;;     cap0-bootstrap-store-mismatch — the bootstrap declares a binding to
;;;;         a DIFFERENT store identity.  No kernel0 type says "your declared
;;;;         configuration names another journal"; store-id-mismatch exists
;;;;         in journal0 (pj0-store-id-mismatch) but that condition is about
;;;;         FRAME bytes vs metadata, not about caller configuration.
;;;;     cap0-malformed-authority-event — a committed event of a capability0
;;;;         kind lacks a required field.  kernel0's
;;;;         malformed-constructor-shape is a CONSTRUCTOR-argument refusal;
;;;;         this is a fold refusal over durable bytes.
;;;;     cap0-stale-receipt            — a receipt presented as PRESENT
;;;;         authority whose prefix binding is superseded.  kernel0's
;;;;         capability-expired is wall-clock expiry (banned from this
;;;;         slice); frontier-precondition-failed presumes an effect
;;;;         frontier (this slice executes no effects, law 12).  Staleness
;;;;         of a prefix binding is a fact of its own kind and gets its own
;;;;         name, carrying BOTH prefixes.
;;;;
;;;; — CLAVIGER (Claude Fable 5 subagent), 2026-07-29

(in-package #:lisp-plus-capability0)

(define-condition cap0-condition (error)
  ((detail
    :initarg :detail
    :initform nil
    :reader cap0-condition-detail)
   (requirement-id
    :initarg :requirement-id
    :initform nil
    :reader cap0-condition-requirement-id))
  (:report
   (lambda (condition stream)
     (format stream "~a~@[ [~a]~]~@[: ~a~]"
             (type-of condition)
             (cap0-condition-requirement-id condition)
             (cap0-condition-detail condition))))
  (:documentation
   "Base for every Capability /0 refusal that has no honest kernel /0 home."))

(define-condition cap0-bootstrap-missing (cap0-condition) ()
  (:documentation
   "No explicit bootstrap authority was supplied.  The fold refuses to derive
anything without one: bootstrap authority is a DECLARED configuration value
handed to the procedure by the caller — never package internals, ambient
process identity, operator testimony, or the fact that a constructor ran."))

(define-condition cap0-bootstrap-store-mismatch (cap0-condition)
  ((expected
    :initarg :expected
    :initform nil
    :reader cap0-bootstrap-store-mismatch-expected)
   (actual
    :initarg :actual
    :initform nil
    :reader cap0-bootstrap-store-mismatch-actual))
  (:documentation
   "The supplied bootstrap authority declares a binding to a different store
identity than the journal actually opened.  EXPECTED is the bootstrap's
declared store-id; ACTUAL is the store's derived identity."))

(define-condition cap0-malformed-authority-event (cap0-condition)
  ((ordinal
    :initarg :ordinal
    :initform nil
    :reader cap0-malformed-authority-event-ordinal)
   (missing-field
    :initarg :missing-field
    :initform nil
    :reader cap0-malformed-authority-event-missing-field))
  (:documentation
   "A committed event of a capability0 kind lacks a required field, or
carries a non-identifier where an identifier is required.  The fold refuses
rather than guessing what the event meant."))

(define-condition cap0-stale-receipt (cap0-condition)
  ((receipt-store-id
    :initarg :receipt-store-id :initform nil
    :reader cap0-stale-receipt-receipt-store-id)
   (receipt-terminal-ordinal
    :initarg :receipt-terminal-ordinal :initform nil
    :reader cap0-stale-receipt-receipt-terminal-ordinal)
   (receipt-valid-byte-count
    :initarg :receipt-valid-byte-count :initform nil
    :reader cap0-stale-receipt-receipt-valid-byte-count)
   (receipt-terminal-digest
    :initarg :receipt-terminal-digest :initform nil
    :reader cap0-stale-receipt-receipt-terminal-digest)
   (present-store-id
    :initarg :present-store-id :initform nil
    :reader cap0-stale-receipt-present-store-id)
   (present-terminal-ordinal
    :initarg :present-terminal-ordinal :initform nil
    :reader cap0-stale-receipt-present-terminal-ordinal)
   (present-valid-byte-count
    :initarg :present-valid-byte-count :initform nil
    :reader cap0-stale-receipt-present-valid-byte-count)
   (present-terminal-digest
    :initarg :present-terminal-digest :initform nil
    :reader cap0-stale-receipt-present-terminal-digest))
  (:report
   (lambda (condition stream)
     (format stream "cap0-stale-receipt: receipt binds validated prefix ~
                     [ordinal ~a · ~a bytes · terminal ~a] but the present ~
                     validated prefix is [ordinal ~a · ~a bytes · terminal ~
                     ~a]; a receipt that outlives its prefix is testimony ~
                     about the past, not a key to the present"
             (cap0-stale-receipt-receipt-terminal-ordinal condition)
             (cap0-stale-receipt-receipt-valid-byte-count condition)
             (cap0-stale-receipt-receipt-terminal-digest condition)
             (cap0-stale-receipt-present-terminal-ordinal condition)
             (cap0-stale-receipt-present-valid-byte-count condition)
             (cap0-stale-receipt-present-terminal-digest condition))))
  (:documentation
   "A receipt was presented as PRESENT authority but its validated-prefix
binding names an older (or foreign) prefix.  Carries BOTH bindings so the
refusal names the staleness exactly."))
