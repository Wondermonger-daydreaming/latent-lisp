;;;; package.lisp — Language Form /1, Candidate /0: THE FORM MAY PETITION.
;;;;
;;;; Governed by LANGUAGE-FORM-1-WORK-ORDER.md (owner-directed 2026-07-27,
;;;; amended the same day under the owner ruling AMEND AND IMPLEMENT).
;;;; Nothing here is frozen: `specification-frozen: no`, `adopted: no`, and a
;;;; stranger audit is OWED and is NOT pre-satisfied by Form /0's.
;;;;
;;;; THE PRIMARY LAW.
;;;;
;;;;     A form may produce a request for a governed operation.  It may not
;;;;     perform, authorize or certify that operation merely by naming it.
;;;;
;;;; WHAT THIS LAYER IS.  One closed production over already-decoded Canonical
;;;; Datum /0 trees, whose head IS the governed operation; three immutable
;;;; phases between a candidate datum and an inert DERIVATION-PETITION; an
;;;; explicit, local, sealed resolution context that maps durable references to
;;;; live objects; and one loudly-named submission that invokes the existing
;;;; public LISP-PLUS-SLICE2:DERIVE/2 and retains exactly what it returns or
;;;; signals.
;;;;
;;;; WHAT THIS LAYER IS NOT.  No reader, no readtable, no textual parser, no
;;;; evaluator, no macroexpander, no global registry, no capability, no
;;;; authority.  Form /1 constructs no claim, no source basis, no derivation
;;;; basis and no warrant.  A petition is not a claim, not a basis, not a
;;;; capability, not an authority object, not a successful derivation, not an
;;;; executable closure and not an operator extension.
;;;;
;;;; A VALID PETITION IS A WELL-FORMED QUESTION, NOT A GRANTED ANSWER.
;;;;
;;;; THE TWO DOORS.  MATERIALIZE-PETITION takes no resolution context and is
;;;; therefore STRUCTURALLY INCAPABLE of submitting — the socket is removed, not
;;;; guarded.  SUBMIT-PETITION must be called explicitly by the host.
;;;;
;;;; REFERENCE RESOLUTION IS NOT EVIDENCE ADMISSION.  Resolving a reference
;;;; yields the bound object and nothing else: no evidence, standing, claim,
;;;; basis, capability or authority is produced by resolution.  Form /1 performs
;;;; no duplicate schema-liveness check and no support classification; DERIVE/2
;;;; owns both.  Form /1 performs no ambient lookup OF ITS OWN — but DERIVE/2
;;;; may and does consult the governing Slice /1 schema registry, and no claim
;;;; is made that no global lookup occurs anywhere in the full path.
;;;;
;;;; NO PUBLIC CONSTRUCTOR EXISTS FOR ANY PHASE OBJECT, RECEIPT OR OUTCOME.
;;;; Each is the output of exactly one operation.  There is no operator table,
;;;; no handler constructor, and no caller-supplied procedure anywhere in the
;;;; public surface — an unsupported governed operation is an unsupported
;;;; production head, and there is no table for a second operation to enter.
;;;;
;;;; NOTHING HERE DEPENDS ON LISP-PLUS-FORM0.  Not one symbol, single- or
;;;; double-colon.  Form /1 is a sibling, not a successor wrapper: Form /0
;;;; refuses a petition datum with (:GRAMMAR . :UNKNOWN-PRODUCTION), and Form /1
;;;; refuses an ordinary form with (:GRAMMAR . :NOT-A-DERIVATION-PETITION).
;;;; Two doors, each refusing the other's traffic, neither borrowing the other's
;;;; vocabulary.
;;;;
;;;; ON IDENTITIES.  These are LOSSLESS CANONICAL ENCODINGS, not digests — CD/0
;;;; supplies no hash.  They are never to be described as digests.  Identities
;;;; minted here are content-derived; every Slice /2 identity they name is an
;;;; IMAGE-LOCAL ORDINAL, and the field names say so.

(defpackage #:lisp-plus-form1
  (:use #:cl)
  (:export
   ;; ---- grammar constructors: a program writes a petition by hand ----
   ;; PETITION-DATUM returns a CD/0 DATUM.  A datum is not a proposal.
   #:petition-head-identifier
   #:schema-reference
   #:conclusion-reference
   #:support-reference
   #:receiver-reference
   #:reference-role
   #:petition-datum

   ;; ---- the three phase transitions, in order, plus materialization ----
   #:propose-petition
   #:validate-petition
   #:materialize-petition
   #:submit-petition

   ;; ---- non-signalling twins: every refusal is RETURNED, not just raised ----
   ;; TRY-PROPOSE-PETITION is the authoritative classifier.  No boolean twin is
   ;; exported: a predicate that could disagree with the entry point is a second
   ;; representation of the same question.
   #:try-propose-petition
   #:try-validate-petition
   #:try-materialize-petition
   #:try-submit-petition

   ;; ---- phase objects, each immutable and independently readable ----
   #:proposed-petition-form-p
   #:proposed-petition-form-datum
   #:proposed-petition-form-subject-identity
   #:proposed-petition-form-identity
   #:proposed-petition-form-grammar-identity
   #:proposed-petition-form-grammar-version

   #:validated-petition-form-p
   #:validated-petition-form-subject-identity
   #:validated-petition-form-identity
   #:validated-petition-form-predecessor-identity
   #:validated-petition-form-grammar-identity
   #:validated-petition-form-grammar-version
   #:validated-petition-form-policy-identity
   #:validated-petition-form-policy-version
   #:validated-petition-form-budget-id
   #:validated-petition-form-receipt

   #:petition-validation-receipt-p
   #:petition-validation-receipt-identity
   #:petition-validation-receipt-subject-identity
   #:petition-validation-receipt-proposed-identity
   #:petition-validation-receipt-grammar-identity
   #:petition-validation-receipt-grammar-version
   #:petition-validation-receipt-policy-identity
   #:petition-validation-receipt-policy-version
   #:petition-validation-receipt-budget-id

   ;; ---- the inert petition ----
   #:derivation-petition-p
   #:derivation-petition-content-identity
   #:derivation-petition-occurrence-identity
   #:derivation-petition-occurrence-tag
   #:derivation-petition-validated-identity
   #:derivation-petition-subject-identity
   #:derivation-petition-schema-reference
   #:derivation-petition-conclusion-reference
   #:derivation-petition-support-references
   #:derivation-petition-receiver-reference
   #:derivation-petition-policy-identity
   #:derivation-petition-policy-version

   #:petition-materialization-receipt-p
   #:petition-materialization-receipt-identity
   #:petition-materialization-receipt-validated-identity
   #:petition-materialization-receipt-content-identity
   #:petition-materialization-receipt-occurrence-identity
   #:petition-materialization-receipt-policy-identity
   #:petition-materialization-receipt-policy-version

   ;; ---- the sealed, local, explicitly-built resolution context ----
   ;; Role-specific binders only.  There is deliberately NO generic public
   ;; BIND-REFERENCE: the role is structural in the identifier AND in the
   ;; operation, so cross-role satisfaction is impossible by construction.
   ;;
   ;; POLICY v3 — EVERY BINDER REQUIRES A DENOTATION DECLARATION EXPLICITLY.
   ;; Each binding carries two distinct facts: a DENOTATION DECLARATION (an
   ;; immutable CD/0 datum the host supplies, naming what the reference is
   ;; intended to denote) and a LIVE ANCHOR (the exact image-local object handed
   ;; to DERIVE/2).  The declaration is durable and enters identity; the anchor
   ;; is neither.  No declaration is ever derived from an anchor.
   #:make-derivation-resolution-context
   #:receiver-absence-declaration
   #:bind-schema-reference
   #:bind-conclusion-reference
   #:bind-support-reference
   #:bind-receiver-reference
   #:seal-resolution-context
   #:derivation-resolution-context-p
   #:derivation-resolution-context-sealed-p
   ;; The TAG is what the host supplied.  The two IDENTITIES are content-derived.
   ;; The tag alone is not the context identity.
   #:derivation-resolution-context-occurrence-tag
   #:derivation-resolution-context-declaration-identity
   #:derivation-resolution-context-occurrence-identity

   ;; ---- the two inspection surfaces ----
   ;;   Reference resolution is not evidence admission.
   ;;   A denotation declaration is not certification of its live anchor.
   ;; A: durable declarations, safe as an aggregate.
   ;; B: image-local anchors, exact role/reference lookup only.
   #:derivation-resolution-context-declarations
   #:derivation-resolution-context-live-anchor
   #:context-binding-declaration-p
   #:context-binding-declaration-role
   #:context-binding-declaration-reference
   #:context-binding-declaration-denotation

   ;; ---- submission transport: NOT a receipt, claim, basis or standing ----
   #:petition-submission-outcome-p
   #:petition-submission-outcome-kind
   #:petition-submission-outcome-claim
   #:petition-submission-outcome-slice2-receipt
   #:petition-submission-outcome-derivation-basis
   #:petition-submission-outcome-condition
   #:petition-submission-outcome-receipt

   ;; ---- the submission receipt: the LATER ACCOUNT of an earlier ACT ----
   #:petition-submission-receipt-p
   #:petition-submission-receipt-identity
   #:petition-submission-receipt-occurrence-identity
   #:petition-submission-receipt-petition-occurrence-identity
   #:petition-submission-receipt-context-occurrence-identity
   #:petition-submission-receipt-context-declaration-identity
   #:petition-submission-receipt-context-occurrence-tag
   #:petition-submission-receipt-context
   #:petition-submission-receipt-act-id
   #:petition-submission-receipt-by-id
   #:petition-submission-receipt-by
   #:petition-submission-receipt-procedure-identity
   #:petition-submission-receipt-procedure-version
   #:petition-submission-receipt-outcome-kind
   #:petition-submission-receipt-slice2-receipt-identity-datum
   #:petition-submission-receipt-slice2-condition-class

   ;; ---- retained refusals: inspectable objects, never only printed ----
   #:petition-refusal-p
   #:petition-refusal-phase
   #:petition-refusal-category
   #:petition-refusal-code
   #:petition-refusal-path
   #:petition-refusal-offending
   #:petition-refusal-reference
   #:petition-refusal-expected-role
   #:petition-refusal-host-type
   #:petition-refusal-detail
   #:petition-refusal-identity
   #:petition-refused
   #:petition-refused-refusal

   ;; ---- the refusal-code catalogue, SPLIT BY EVIDENTIARY CLASS ----
   ;; There is deliberately NO flat PETITION-REFUSAL-CODES.  A single list
   ;; publishes a count that can travel without the distinction it flattens:
   ;; codes a public caller can provoke, and package-internal integrity guards
   ;; that CD/0's copy-on-access makes unreachable from outside.  A host writing
   ;; a handler for one of the latter is writing dead code with no way to tell,
   ;; so the classification lives in the catalogue the host reads.
   ;; Both lists are DERIVED from one catalogue; their union is the complete
   ;; implementation code set by construction.
   #:petition-protocol-refusal-codes
   #:petition-integrity-alarm-codes
   #:petition-refusal-code-catalog
   #:petition-refusal-code-entry-p
   #:petition-refusal-code-entry-code
   #:petition-refusal-code-entry-class
   #:petition-refusal-code-entry-reachability
   #:petition-refusal-code-entry-note

   ;; ---- grammar and policy identity, so a receipt's ceilings are readable ----
   #:petition-grammar-identity
   #:petition-grammar-version
   #:petition-policy-identity
   #:petition-policy-version
   #:petition-policy-max-support-references
   #:petition-policy-max-canonical-octets
   #:petition-policy-max-identity-octets
   #:petition-policy-outcome-tail-reserve-octets
   #:identity-octets
   #:render-identity-hex
   #:petition-submission-procedure-identity
   #:petition-submission-procedure-version))
