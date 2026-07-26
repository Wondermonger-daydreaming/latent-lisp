;;;; package.lisp — Language Slice /2, Candidate /0: SOURCE-BOUND ADMISSION.
;;;;
;;;; Governed by LANGUAGE-SLICE-2-WORK-ORDER-0.md (owner-issued, 2026-07-25),
;;;; which adopts D2-0.1 … D2-0.10 and lifts the hold recorded in
;;;; LANGUAGE-SLICE-2-DESIGN-RULING-1.md.  Nothing here is frozen:
;;;; `specification-frozen: no` is load-bearing and this is a candidate surface.
;;;;
;;;; CANDIDATE /1 (LANGUAGE-SLICE-2-WORK-ORDER-1.md, owner-issued 2026-07-25)
;;;; adds ONE further support species — a DERIVATION BASIS — and the readers to
;;;; inspect it.  It adds no second consequential act: DERIVE/2 gains an
;;;; ADDITIVE third return value and its first two are unchanged.
;;;;
;;;; The whole export list is small on purpose, and the two increments are
;;;; scoped separately rather than summed into one sentence that is true of
;;;; neither:
;;;;
;;;;   CANDIDATE /0 adds ONE new consequential act (DERIVE/2), ONE new support
;;;;   species (a SOURCE BASIS), TWO first-class values (a contract and a
;;;;   schema), and the readers needed to audit a decision without a resolver.
;;;;
;;;;   CANDIDATE /1 adds ONE further support species (a DERIVATION BASIS) with
;;;;   its readers, one typed condition, an ADDITIVE third return value on
;;;;   DERIVE/2, and contract version 1.  It adds NO consequential act.
;;;;
;;;; `derive` remains Slice /1's and is not re-exported, shadowed, or wrapped in
;;;; a same-named symbol.

(defpackage #:lisp-plus-slice2
  (:use #:cl)
  (:export
   ;; ---- the support-admission contract (D2-0.1): DATA, not a closure ----
   #:support-admission-contract-p
   #:make-support-admission-contract
   #:support-admission-contract-contract-id
   #:support-admission-contract-contract-version
   #:support-admission-contract-accepted-clauses
   #:support-admission-contract-proposition-relation
   #:support-admission-contract-receiver-accessibility
   #:support-admission-contract-retain
   #:support-admission-contract-truth-ceilings
   #:support-admission-contract-admits-species-p
   ;; ---- per-premise attachment (D2-0.2 / D2-0.3) ----
   #:slice2-schema-p
   #:make-slice2-schema
   #:slice2-schema-schema-id
   #:slice2-schema-schema-version
   #:slice2-schema-base-schema
   #:slice2-schema-premise-contracts
   #:slice2-schema-contract-for-premise
   ;; ---- the source basis (D2-0.5) ----
   #:establish-core0-source-basis
   #:source-basis-p
   #:source-basis-established-in-current-image-p
   #:source-basis-identity
   #:source-basis-version
   #:source-basis-species
   #:source-basis-attempt-id
   #:source-basis-request
   #:source-basis-relation-kind
   #:source-basis-relation-version
   #:source-basis-proposition
   #:source-basis-account-status
   #:source-basis-account-outcome
   #:source-basis-truth-ceiling
   #:source-basis-issuance-basis
   #:source-basis-account-snapshot
   ;; ---- the derivation basis (Candidate /1, Work Order /1) ----
   #:derivation-basis-p
   #:derivation-basis-established-in-current-image-p
   #:derivation-basis-identity
   #:derivation-basis-version
   #:derivation-basis-species
   #:derivation-basis-claim
   #:derivation-basis-receipt
   #:derivation-basis-proposition
   #:derivation-basis-schema-id
   #:derivation-basis-schema-version
   #:derivation-basis-origin-context
   #:derivation-basis-truth-ceiling
   ;; ---- the relation vocabulary (D2-0.6): EXACTLY three ----
   #:core0-source-relations
   #:core0-source-relation-p
   ;; ---- the new consequential surface (D2-0.4) ----
   #:derive/2
   ;; ---- the Slice /2 receipt ----
   #:slice2-receipt-p
   #:slice2-receipt-base-receipt
   #:slice2-receipt-schema-id
   #:slice2-receipt-schema-version
   #:slice2-receipt-conclusion
   #:slice2-receipt-decision
   #:slice2-receipt-identity
   #:slice2-receipt-origin-context
   #:slice2-receipt-admissions
   #:slice2-receipt-source-bases-used
   #:slice2-receipt-derivation-bases-used
   #:slice2-receipt-judged-claims-used
   #:slice2-receipt-unsupported-supports
   #:slice2-receipt-complete-binding-environments
   #:slice2-receipt-uniqueness-conflicts
   #:slice2-receipt-strongest-lawful-result
   ;; ---- the per-premise admission record ----
   #:premise-admission-p
   #:premise-admission-index
   #:premise-admission-premise-pattern
   #:premise-admission-contract
   #:premise-admission-disposition
   #:premise-admission-base-disposition
   #:premise-admission-admitted-supports
   #:premise-admission-recognized-not-admitted
   #:premise-admission-source-bases
   #:premise-admission-derivation-bases
   #:premise-admission-judged-claims
   #:premise-admission-refuting-supports
   #:premise-admission-refuting-witnesses
   #:premise-admission-projected-premise-instances
   #:premise-admission-binding-environments
   #:premise-admission-ambiguities
   #:premise-admission-truth-ceilings
   #:premise-admission-reasons
   ;; ---- explanation ----
   #:why #:render-slice2-why
   ;; ---- conditions ----
   #:slice2-condition
   #:slice2-condition-failed-invariant
   #:slice2-condition-offending-field
   #:slice2-condition-offending-value
   #:slice2-condition-receipt
   #:admission-contract-error
   #:unknown-admission-clause
   #:slice2-schema-error
   #:premise-contract-missing
   #:premise-contract-duplicate
   #:premise-contract-unknown-premise
   #:source-basis-refused
   #:unissued-core0-account
   #:derivation-basis-refused
   #:slice2-derivation-refused
   #:signal-slice2))
