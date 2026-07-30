;;;; conditions.lisp — capability2's OWN typed conditions.
;;;;
;;;; The lane's standing rule (inherited from /0 and /1): PREFER signaling
;;;; an existing exported condition type — kernel /0's first, then a prior
;;;; capability lane's — and mint a new one ONLY where reuse would be
;;;; dishonest.  Never both for one meaning: every refusal in this lane has
;;;; exactly one home.
;;;;
;;;;   REUSED (signaled by the modules; each meaning identical to its home):
;;;;     lisp-plus-kernel0:unsafe-retry — §14.1 [UNC-1]: dispatch into a
;;;;         seat holding an unresolved uncertain effect.  Signaled by
;;;;         kernel0's own CHECK-RETRY-SAFETY fold, fed by this lane's
;;;;         rehydration (rehydrate.lisp) — the retry law has ONE home and
;;;;         this lane consumes it rather than re-minting it.
;;;;     lisp-plus-kernel0:duplicate-attempt-identity — §6.6/:408: a second
;;;;         attempt under an identity the validated prefix already binds;
;;;;         refused BEFORE any frontier.
;;;;     lisp-plus-kernel0:unstructured-uncertainty — §10.8 [UNC-1]:
;;;;         uncertainty carried inline (or reconciliation attempted)
;;;;         without a structured uncertain-effect record; also signaled by
;;;;         kernel0's own MAKE-UNCERTAIN-EFFECT constructor.
;;;;     lisp-plus-kernel0:reconciliation-insufficient — §14.2 [UNC-2]:
;;;;         reconciliation without admissible evidence (the surviving world
;;;;         cannot answer, or the receipt shape lacks its MUST-carry
;;;;         fields; kernel0's own constructor enforces the latter).
;;;;     capability1's cap1-* refusals and capability0's cap0-* refusals
;;;;         propagate unwrapped from presentation / the fresh /0 fold.
;;;;
;;;;   capability2's OWN (defined below):
;;;;     cap2-world-missing — no explicit world (the controlled effect
;;;;         adapter's per-run durable fixture) was supplied.  Kernel §0.4's
;;;;         carve-out makes the world a DECLARED per-run fixture, never a
;;;;         standing service; like cap1-context-missing (a different
;;;;         declared configuration value than the bootstrap), the missing
;;;;         thing here is a third, distinct configuration value — the
;;;;         outside.  No substrate condition names it.
;;;;     cap2-authorization-missing — invocation was handed no
;;;;         authorization-to-attempt receipt (or a datum that is not one).
;;;;         cap1-mint-refused's home is the MINTING claim; kernel0's
;;;;         capability-missing is a ledger fact; this is an invocation
;;;;         handed nothing that even claims to license it.
;;;;     cap2-authorization-mismatch — a current authorization receipt that
;;;;         does not license THIS invocation: it names a different
;;;;         capability, or its effect declaration differs from the
;;;;         presented request.  Distinct from cap1-term-mismatch
;;;;         (presentation-vs-object terms) — this is receipt-vs-invocation.
;;;;     cap2-stale-authorization — the authorization receipt's validated-
;;;;         prefix binding no longer names the CURRENT validated prefix.
;;;;         Deliberately NOT cap0-stale-receipt (that names a /0 authority
;;;;         receipt) and NOT cap1-stale-capability (that names the live
;;;;         object): the stale thing here is this lane's own
;;;;         authorization-to-attempt receipt.  Carries BOTH prefixes,
;;;;         the /1 idiom.
;;;;     cap2-effect-not-authorized — the requested effect is not the one
;;;;         the capability's exact terms authorize (the requested cell is
;;;;         not the capability's resource).  kernel0's
;;;;         capability-scope-mismatch has its one home in /0's escalated
;;;;         query refusal (requested terms vs the JOURNALED grant); this is
;;;;         requested-EFFECT-vs-capability-terms — a different fact.
;;;;     cap2-attempt-authorization-refused — the authorization operation
;;;;         itself refuses: the fresh /0 derivation at the current prefix
;;;;         refused (naming the fold's reason and receipt — e.g. the
;;;;         revoking event).  Mirrors cap1-mint-refused's
;;;;         :fresh-derivation-refused idiom for a DIFFERENT operation
;;;;         (authorizing an attempt, not minting a key), so reusing
;;;;         cap1-mint-refused would misname the refusing operation.
;;;;     cap2-nothing-uncertain — a declaration or reconciliation was asked
;;;;         for where the fold shows no crossed-and-unsettled attempt under
;;;;         the given identity.  No kernel condition names "you asked to
;;;;         structure or resolve uncertainty where the fold derives none";
;;;;         PJ-FOLD-1's spirit (nothing resolves by default) cuts both
;;;;         ways — nothing becomes uncertain by request either.
;;;;
;;;; — CLAVIGER-III (Claude Fable 5 subagent), 2026-07-30

(in-package #:lisp-plus-capability2)

(define-condition cap2-condition (error)
  ((detail
    :initarg :detail
    :initform nil
    :reader cap2-condition-detail)
   (requirement-id
    :initarg :requirement-id
    :initform nil
    :reader cap2-condition-requirement-id))
  (:report
   (lambda (condition stream)
     (format stream "~a~@[ [~a]~]~@[: ~a~]"
             (type-of condition)
             (cap2-condition-requirement-id condition)
             (cap2-condition-detail condition))))
  (:documentation
   "Base for every Capability /2 refusal that has no honest kernel /0,
capability /0, or capability /1 home."))

(define-condition cap2-world-missing (cap2-condition) ()
  (:documentation
   "No explicit world (the controlled effect adapter's per-run durable
fixture) was supplied, or the supplied value is not one.  The world is a
DECLARED configuration value handed to invocation and reconciliation by the
caller — never ambient state, never a standing service (Kernel §0.4
carve-out)."))

(define-condition cap2-authorization-missing (cap2-condition)
  ((presented-type
    :initarg :presented-type
    :initform nil
    :reader cap2-authorization-missing-presented-type))
  (:report
   (lambda (condition stream)
     (format stream "cap2-authorization-missing: invocation was handed ~
                     no authorization-to-attempt receipt (presented type ~
                     ~a); an effect attempt licensed by nothing is refused ~
                     before anything else is examined"
             (cap2-authorization-missing-presented-type condition))))
  (:documentation
   "The invocation was handed no authorization-to-attempt receipt, or a
datum that is not one (wrong kind field, not a canonical record)."))

(define-condition cap2-authorization-mismatch (cap2-condition)
  ((facets
    :initarg :facets
    :initform nil
    :reader cap2-authorization-mismatch-facets))
  (:report
   (lambda (condition stream)
     (format stream "cap2-authorization-mismatch: the authorization ~
                     receipt does not license this invocation; mismatched ~
                     facets: ~{~a~^, ~} (an authorization licenses exactly ~
                     the attempt it names)"
             (cap2-authorization-mismatch-facets condition))))
  (:documentation
   "A structurally valid, prefix-current authorization receipt that does not
license THIS invocation: it names a different capability public identity, or
its effect declaration (cell, value, effect kind) differs from the presented
request.  FACETS names the offending fields, declaration order."))

(define-condition cap2-stale-authorization (cap2-condition)
  ((authorization-store-id
    :initarg :authorization-store-id :initform nil
    :reader cap2-stale-authorization-authorization-store-id)
   (authorization-terminal-ordinal
    :initarg :authorization-terminal-ordinal :initform nil
    :reader cap2-stale-authorization-authorization-terminal-ordinal)
   (authorization-valid-byte-count
    :initarg :authorization-valid-byte-count :initform nil
    :reader cap2-stale-authorization-authorization-valid-byte-count)
   (authorization-terminal-digest
    :initarg :authorization-terminal-digest :initform nil
    :reader cap2-stale-authorization-authorization-terminal-digest)
   (present-store-id
    :initarg :present-store-id :initform nil
    :reader cap2-stale-authorization-present-store-id)
   (present-terminal-ordinal
    :initarg :present-terminal-ordinal :initform nil
    :reader cap2-stale-authorization-present-terminal-ordinal)
   (present-valid-byte-count
    :initarg :present-valid-byte-count :initform nil
    :reader cap2-stale-authorization-present-valid-byte-count)
   (present-terminal-digest
    :initarg :present-terminal-digest :initform nil
    :reader cap2-stale-authorization-present-terminal-digest))
  (:report
   (lambda (condition stream)
     (format stream "cap2-stale-authorization: the authorization-to-attempt ~
                     receipt binds validated prefix [ordinal ~a · ~a bytes ~
                     · terminal ~a] but the present validated prefix is ~
                     [ordinal ~a · ~a bytes · terminal ~a]; an ~
                     authorization is an answer about one exact prefix — ~
                     when the journal moves, the question must be asked ~
                     again"
             (cap2-stale-authorization-authorization-terminal-ordinal
              condition)
             (cap2-stale-authorization-authorization-valid-byte-count
              condition)
             (cap2-stale-authorization-authorization-terminal-digest
              condition)
             (cap2-stale-authorization-present-terminal-ordinal condition)
             (cap2-stale-authorization-present-valid-byte-count condition)
             (cap2-stale-authorization-present-terminal-digest condition))))
  (:documentation
   "The authorization-to-attempt receipt's validated-prefix binding
(store-id · terminal ordinal · valid byte count · terminal digest) no longer
names the CURRENT validated prefix.  Carries BOTH bindings.  This staleness
check, re-run at invocation, is the mechanism that closes the
check-then-effect gap in this slice: any commit between authorization and
invocation — including a matching revocation — refuses here (or at the
capability's own staleness check) before the frontier.  The Constitution's
E6 atomic-authority-ledger property is NOT claimed."))

(define-condition cap2-effect-not-authorized (cap2-condition)
  ((requested-cell
    :initarg :requested-cell :initform nil
    :reader cap2-effect-not-authorized-requested-cell)
   (authorized-cell
    :initarg :authorized-cell :initform nil
    :reader cap2-effect-not-authorized-authorized-cell))
  (:report
   (lambda (condition stream)
     (format stream "cap2-effect-not-authorized: the capability's exact ~
                     terms authorize cell ~a; the requested effect targets ~
                     ~a (a key opens exactly the door it was cut for, and ~
                     licenses exactly the effect it names)"
             (cap2-effect-not-authorized-authorized-cell condition)
             (cap2-effect-not-authorized-requested-cell condition))))
  (:documentation
   "The requested effect is not the effect the capability's exact terms
authorize: the requested cell differs from the capability's resource (exact
canonical equality; no pattern language, no scope predicates in this
slice)."))

(define-condition cap2-attempt-authorization-refused (cap2-condition)
  ((basis
    :initarg :basis
    :initform nil
    :reader cap2-attempt-authorization-refused-basis)
   (fresh-reason
    :initarg :fresh-reason
    :initform nil
    :reader cap2-attempt-authorization-refused-fresh-reason)
   (fresh-receipt
    :initarg :fresh-receipt
    :initform nil
    :reader cap2-attempt-authorization-refused-fresh-receipt))
  (:report
   (lambda (condition stream)
     (format stream "cap2-attempt-authorization-refused (~a)~@[: fresh /0 ~
                     derivation refused with reason ~a~]~@[: ~a~]"
             (cap2-attempt-authorization-refused-basis condition)
             (cap2-attempt-authorization-refused-fresh-reason condition)
             (cap2-condition-detail condition))))
  (:documentation
   "The authorization-to-attempt operation refused.  BASIS is
:fresh-derivation-refused (the fresh /0 fold at the current validated
prefix refused the capability's terms — FRESH-REASON carries the /0 reason,
FRESH-RECEIPT the full refusal receipt, so the refusal names its evidence,
e.g. the revoking event)."))

(define-condition cap2-nothing-uncertain (cap2-condition)
  ((attempt-name
    :initarg :attempt-name
    :initform nil
    :reader cap2-nothing-uncertain-attempt-name))
  (:report
   (lambda (condition stream)
     (format stream "cap2-nothing-uncertain: the fold over the validated ~
                     prefix shows no crossed-and-unsettled attempt under ~
                     identity ~a; nothing becomes uncertain by request, ~
                     just as nothing resolves by default"
             (cap2-nothing-uncertain-attempt-name condition))))
  (:documentation
   "A declaration or reconciliation was requested for an attempt the fold
does not show as crossed-and-unsettled (never prepared, never crossed, or
already settled).  The fold decides what is uncertain; the caller does
not."))
