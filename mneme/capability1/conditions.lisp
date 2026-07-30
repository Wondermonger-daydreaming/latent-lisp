;;;; conditions.lisp — capability1's OWN typed conditions.
;;;;
;;;; The lane's standing rule (inherited from /0): PREFER signaling an
;;;; existing exported condition type — kernel /0's, then capability /0's —
;;;; and mint a new one ONLY where reuse would be dishonest.  Never both for
;;;; one meaning: every refusal in this lane has exactly one home.
;;;;
;;;;   REUSED (signaled by mint.lisp / present.lisp):
;;;;     cap0-bootstrap-missing / cap0-bootstrap-store-mismatch —
;;;;         presentation takes an explicit bootstrap like every /0
;;;;         derivation entry point; the meaning (the caller's declared
;;;;         configuration is absent / binds another store) is IDENTICAL to
;;;;         /0's, so /0's exported conditions are signaled rather than
;;;;         duplicated.  On the mint path they propagate from /0 itself
;;;;         (present-receipt-as-present-authority runs /0's own checks).
;;;;     cap0-stale-receipt — a mint attempt from an authorization receipt
;;;;         whose prefix binding is superseded refuses with /0's OWN
;;;;         condition, propagated from /0's present-receipt discipline:
;;;;         the stale thing there IS a /0 receipt, so /0's name is its
;;;;         one honest home.
;;;;     lisp-plus-kernel0:journal-prefix-invalid — presentation over a
;;;;         store whose validated prefix is :corruption refuses with the
;;;;         kernel's own type, exactly as /0's fold does (package-
;;;;         qualified; the adjudication is /0's, adopted unchanged).
;;;;
;;;;   capability1's OWN (defined below):
;;;;     cap1-context-missing — the caller supplied no explicit minting
;;;;         context.  cap0-bootstrap-missing names a DIFFERENT declared
;;;;         configuration value (the fold's root authority); conflating
;;;;         the two would let "you forgot the recognizer" masquerade as
;;;;         "you forgot the root of authority".
;;;;     cap1-unrecognized-object — the presented object is not one this
;;;;         very context minted (EQ membership).  kernel0's
;;;;         capability-missing is a LEDGER fact (no grant in the validated
;;;;         prefix); this is a PROCESS fact (this recognizer never minted
;;;;         this very object).  Conflating them would let a counterfeit's
;;;;         refusal masquerade as a history refusal — the exact confusion
;;;;         §11.2 exists to forbid.
;;;;     cap1-term-mismatch — the caller's requested terms differ from the
;;;;         terms the capability was minted with.  kernel0's
;;;;         capability-scope-mismatch already has its one home in this
;;;;         family: /0's escalated QUERY refusal (requested terms vs the
;;;;         JOURNALED grant).  This condition is presentation-vs-OBJECT
;;;;         (requested terms vs the terms bound into a process-local key)
;;;;         — a different fact, so a different name, per never-both.
;;;;     cap1-stale-capability — the capability's validated-prefix binding
;;;;         is no longer the current validated prefix.  Deliberately NOT
;;;;         /0's cap0-stale-receipt (owner's charge: do not overload it):
;;;;         a receipt is durable testimony that remains truthful about its
;;;;         prefix; a live capability is present-tense authority whose
;;;;         binding has been superseded — different subjects, each
;;;;         carrying BOTH prefixes so the refusal names the staleness
;;;;         exactly.
;;;;     cap1-mint-refused — the minting OPERATION refuses the authorizing
;;;;         claim on a basis for which no substrate condition is honest:
;;;;         the presented datum is not an authority receipt at all; it is
;;;;         a refusal (not an authorization) claim; or the FRESH /0
;;;;         re-derivation refused where the presented receipt claimed
;;;;         authorization.  kernel0's minting-authority-invalid has its
;;;;         one home in /0 (a journaled issuer the bootstrap does not
;;;;         ground); the fact here is about the CLAIM handed to the
;;;;         bridge, not about journaled history.
;;;;
;;;; — CLAVIGER-II (Claude Fable 5 subagent), 2026-07-29

(in-package #:lisp-plus-capability1)

(define-condition cap1-condition (error)
  ((detail
    :initarg :detail
    :initform nil
    :reader cap1-condition-detail)
   (requirement-id
    :initarg :requirement-id
    :initform nil
    :reader cap1-condition-requirement-id))
  (:report
   (lambda (condition stream)
     (format stream "~a~@[ [~a]~]~@[: ~a~]"
             (type-of condition)
             (cap1-condition-requirement-id condition)
             (cap1-condition-detail condition))))
  (:documentation
   "Base for every Capability /1 refusal that has no honest kernel /0 or
capability /0 home."))

(define-condition cap1-context-missing (cap1-condition) ()
  (:documentation
   "No explicit minting context was supplied.  The minting context is a
DECLARED configuration value handed to mint/present by the caller — never a
package global, ambient process state, or something conjured on demand.  A
procedure that would invent its own recognizer could be talked into
recognizing anything."))

(define-condition cap1-unrecognized-object (cap1-condition)
  ((presented-type
    :initarg :presented-type
    :initform nil
    :reader cap1-unrecognized-object-presented-type)
   (presented-public-id
    :initarg :presented-public-id
    :initform nil
    :reader cap1-unrecognized-object-presented-public-id)
   (context-label
    :initarg :context-label
    :initform nil
    :reader cap1-unrecognized-object-context-label))
  (:report
   (lambda (condition stream)
     (format stream "cap1-unrecognized-object: the minting context~@[ ~
                     (~a)~] did not mint the presented object (type ~a~@[, ~
                     public identity ~a~]); receipts, printed forms, and ~
                     field-copies describe keys — they are not keys"
             (cap1-unrecognized-object-context-label condition)
             (cap1-unrecognized-object-presented-type condition)
             (cap1-unrecognized-object-presented-public-id condition))))
  (:documentation
   "The presented object is not one this very minting context created:
recognition is EQ membership in the context's private table, so a decoded
receipt, a printed-form read-back, a struct mimicking every public field, or
a sibling context's genuine capability all refuse HERE.  PRESENTED-TYPE is
the host type of what was presented; PRESENTED-PUBLIC-ID is its claimed
public identity string when one is legible (a claim, not a credential);
CONTEXT-LABEL is the refusing context's diagnostic label."))

(define-condition cap1-term-mismatch (cap1-condition)
  ((capability-public-id
    :initarg :capability-public-id
    :initform nil
    :reader cap1-term-mismatch-capability-public-id)
   (mismatched-terms
    :initarg :mismatched-terms
    :initform nil
    :reader cap1-term-mismatch-mismatched-terms))
  (:report
   (lambda (condition stream)
     (format stream "cap1-term-mismatch: presentation of ~a requested terms ~
                     that differ from the minted terms in: ~{~a~^, ~} (a ~
                     key opens exactly the door it was cut for)"
             (cap1-term-mismatch-capability-public-id condition)
             (cap1-term-mismatch-mismatched-terms condition))))
  (:documentation
   "The caller's requested subject/action/resource/scope do not exactly
match the terms the capability was minted with (exact canonical CD/0
equality; an omitted term counts as mismatched).  MISMATCHED-TERMS names the
offending term names, declaration order."))

(define-condition cap1-stale-capability (cap1-condition)
  ((capability-store-id
    :initarg :capability-store-id :initform nil
    :reader cap1-stale-capability-capability-store-id)
   (capability-terminal-ordinal
    :initarg :capability-terminal-ordinal :initform nil
    :reader cap1-stale-capability-capability-terminal-ordinal)
   (capability-valid-byte-count
    :initarg :capability-valid-byte-count :initform nil
    :reader cap1-stale-capability-capability-valid-byte-count)
   (capability-terminal-digest
    :initarg :capability-terminal-digest :initform nil
    :reader cap1-stale-capability-capability-terminal-digest)
   (present-store-id
    :initarg :present-store-id :initform nil
    :reader cap1-stale-capability-present-store-id)
   (present-terminal-ordinal
    :initarg :present-terminal-ordinal :initform nil
    :reader cap1-stale-capability-present-terminal-ordinal)
   (present-valid-byte-count
    :initarg :present-valid-byte-count :initform nil
    :reader cap1-stale-capability-present-valid-byte-count)
   (present-terminal-digest
    :initarg :present-terminal-digest :initform nil
    :reader cap1-stale-capability-present-terminal-digest))
  (:report
   (lambda (condition stream)
     (format stream "cap1-stale-capability: the capability binds validated ~
                     prefix [ordinal ~a · ~a bytes · terminal ~a] but the ~
                     present validated prefix is [ordinal ~a · ~a bytes · ~
                     terminal ~a]; a key minted against a prefix that has ~
                     moved must be re-derived and re-minted, never carried ~
                     forward"
             (cap1-stale-capability-capability-terminal-ordinal condition)
             (cap1-stale-capability-capability-valid-byte-count condition)
             (cap1-stale-capability-capability-terminal-digest condition)
             (cap1-stale-capability-present-terminal-ordinal condition)
             (cap1-stale-capability-present-valid-byte-count condition)
             (cap1-stale-capability-present-terminal-digest condition))))
  (:documentation
   "A recognized capability was presented but its validated-prefix binding
(store-id · terminal ordinal · valid byte count · terminal digest) no longer
names the CURRENT validated prefix — because the journal advanced, or
because a foreign store was presented to.  Carries BOTH bindings.  Note the
adjudicated subsumption (CAPABILITY-1-RETURN.md): under exact prefix
binding, ANY journal advance — including the one containing a matching
revocation — refuses here as STALE; revocation distinctly governs MINTING,
where the fresh /0 derivation names it."))

(define-condition cap1-mint-refused (cap1-condition)
  ((basis
    :initarg :basis
    :initform nil
    :reader cap1-mint-refused-basis)
   (fresh-reason
    :initarg :fresh-reason
    :initform nil
    :reader cap1-mint-refused-fresh-reason)
   (fresh-receipt
    :initarg :fresh-receipt
    :initform nil
    :reader cap1-mint-refused-fresh-receipt))
  (:report
   (lambda (condition stream)
     (format stream "cap1-mint-refused (~a)~@[: fresh /0 derivation ~
                     refused with reason ~a~]~@[: ~a~]"
             (cap1-mint-refused-basis condition)
             (cap1-mint-refused-fresh-reason condition)
             (cap1-condition-detail condition))))
  (:documentation
   "The minting bridge refused the authorizing claim.  BASIS is one of:
:not-an-authority-receipt (the presented datum is not a /0 authority
receipt at all — grant events, minting receipts, presentation receipts, and
arbitrary records all land here); :receipt-not-authorized (the presented
receipt is a truthful /0 REFUSAL — a refusal cannot authorize minting);
:fresh-derivation-refused (the receipt CLAIMED authorization at the current
prefix, but the fresh /0 re-derivation refused — the receipt's description
was not honored, because the bridge never trusts a receipt's decision).
For :fresh-derivation-refused, FRESH-REASON carries the /0 reason string
and FRESH-RECEIPT the full fresh refusal receipt, so the refusal names its
evidence (e.g. the revoking event)."))
