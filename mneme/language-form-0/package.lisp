;;;; package.lisp — Language Form /0, Candidate /0: THE PROGRAM CAN BE HELD.
;;;;
;;;; Governed by LANGUAGE-FORM-0-WORK-ORDER.md (owner-issued, 2026-07-26).
;;;; Nothing here is frozen: `specification-frozen: no`, `adopted: no`, and the
;;;; stranger audit is OWED.
;;;;
;;;; THE PRIMARY LAW.
;;;;
;;;;     In Lisp+, code may be data before it becomes authority.
;;;;
;;;; WHAT THIS LAYER IS.  A closed, three-production grammar over already-decoded
;;;; Canonical Datum /0 trees, and four immutable phases between a candidate
;;;; datum and a realized result.  A program can be held — proposed, inspected,
;;;; instantiated, validated and refused — without ever being run, and the thing
;;;; that runs it is one loudly-named operation that re-checks every binding.
;;;;
;;;; WHAT THIS LAYER IS NOT.  There is no reader, no readtable, no reader macro,
;;;; no textual parser, no evaluator for host code, no macroexpander, no global
;;;; registry, no capability, and no authority.  Form /0 constructs no claim, no
;;;; source basis, no derivation basis, no capability and no warrant, and it
;;;; contains no reference to any Slice /0, /1, /2, Core /0 or Kernel /0 object.
;;;;
;;;; THE REPRESENTATION BOUNDARY.  The durable input is a CD/0 datum, never text
;;;; and never a host form.  A CD/0 datum cannot be dotted or circular, so the
;;;; defensive tree-walk every Atelier instrument opens with is not needed here:
;;;; this layer lives on the far side of that boundary rather than guarding it.
;;;;
;;;; A model-emitted or adapter-emitted form remains A PROPOSAL.  It is never
;;;; thereby a claim, source basis, derivation basis, capability, authority
;;;; object or warrant.
;;;;
;;;; PUBLIC NAMES REMAIN CANDIDATE UNTIL CLOSURE.  `PROPOSE-FORM` is deliberately
;;;; not called `DECODE-FORM`: "decode" is already occupied by
;;;; `LISP-PLUS-CD0:DECODE-EXACT` (octets → datum), and reusing it here would
;;;; falsely suggest that Form /0 parses something. It admits; it does not decode.

(defpackage #:lisp-plus-form0
  (:use #:cl)
  (:export
   ;; ---- the four phase transitions, in order ----
   #:propose-form
   #:instantiate-form
   #:validate-form
   #:realize-form

   ;; ---- non-signalling twins: every refusal is returned, not just raised ----
   #:try-propose-form
   #:try-instantiate-form
   #:try-validate-form
   #:try-realize-form

   ;; ---- the sealed, local, program-built environment ----
   #:make-form-environment
   #:seal-form-environment
   #:form-environment-p
   #:form-environment-identity
   #:form-environment-version
   #:form-environment-grammar-identity
   #:form-environment-grammar-version
   #:form-environment-sealed-p
   #:form-environment-operator-identities
   #:form-environment-hole-identities
   #:form-environment-budget-id
   #:form-environment-content-digest

   ;; ---- operators: PACKAGE-OWNED, selected by name, never supplied ----
   ;; There is deliberately NO public constructor taking a handler. See the
   ;; threat model in LANGUAGE-FORM-0-WORK-ORDER.md §0.
   #:operator-names
   #:operator-descriptor
   #:operator-descriptor-p
   #:operator-descriptor-identity
   #:operator-descriptor-arity
   #:operator-descriptor-result-species

   ;; ---- declared holes ----
   #:make-form-hole
   #:form-hole-p
   #:form-hole-identity
   #:form-hole-expected-species

   ;; ---- phase objects, each immutable and independently readable ----
   ;;
   ;; THE DUAL IDENTITY MODEL.  `-identity` is the DISTINCT identity of this
   ;; phase object under its exact phase context; `-predecessor-identity` names
   ;; the previous PHASE OBJECT, never merely the shared syntax.
   ;;
   ;; `-subject-identity` is the identity of the SYNTAX. It is NOT stable across
   ;; every phase: instantiation consumes a hole-bearing TEMPLATE and produces a
   ;; CLOSED form, so the instantiated object records both sides. The closed
   ;; subject is then preserved through validation and realization.
   #:proposed-form-p
   #:proposed-form-datum
   #:proposed-form-subject-identity
   #:proposed-form-identity
   #:proposed-form-hole-identities
   #:proposed-form-operator-identities
   #:proposed-form-grammar-identity
   #:proposed-form-grammar-version

   #:instantiated-form-p
   #:instantiated-form-datum
   #:instantiated-form-template-subject-identity
   #:instantiated-form-subject-identity
   #:instantiated-form-identity
   #:instantiated-form-predecessor-identity
   #:instantiated-form-binding-identity
   #:instantiated-form-binding-identities

   #:validated-form-p
   #:validated-form-subject-identity
   #:validated-form-identity
   #:validated-form-predecessor-identity
   #:validated-form-instantiated-identity
   #:validated-form-grammar-identity
   #:validated-form-grammar-version
   #:validated-form-environment-identity
   #:validated-form-environment-version
   #:validated-form-environment-content-digest
   #:validated-form-operator-identities
   #:validated-form-budget-id
   #:validated-form-receipt

   ;; ---- receipts ----
   #:form-validation-receipt-p
   #:form-validation-receipt-identity
   #:form-validation-receipt-subject-identity
   #:form-validation-receipt-environment-content-digest
   #:form-validation-receipt-instantiated-identity
   #:form-validation-receipt-grammar-identity
   #:form-validation-receipt-grammar-version
   #:form-validation-receipt-environment-identity
   #:form-validation-receipt-environment-version
   #:form-validation-receipt-operator-identities
   #:form-validation-receipt-budget-id

   #:form-realization-receipt-p
   #:form-realization-receipt-identity
   #:form-realization-receipt-validated-identity
   #:form-realization-receipt-subject-identity
   #:form-realization-receipt-environment-content-digest
   #:form-realization-receipt-instantiated-identity
   #:form-realization-receipt-environment-identity
   #:form-realization-receipt-environment-version
   #:form-realization-receipt-grammar-identity
   #:form-realization-receipt-grammar-version
   #:form-realization-receipt-operator-identities
   #:form-realization-receipt-result-identity

   ;; ---- retained refusals: inspectable objects, never only printed ----
   #:form-refusal-p
   #:form-refusal-category
   #:form-refusal-code
   #:form-refusal-path
   #:form-refusal-offending
   #:form-refusal-detail
   #:form-refusal-identity
   #:form-refused
   #:form-refused-refusal
   #:form-refusal-codes

   ;; ---- grammar constructors, so a program can write a candidate by hand ----
   #:literal-node
   #:hole-node
   #:operator-node
   #:hole-identifier
   #:operator-identifier
   #:grammar-identity
   #:grammar-version))
