;;;; package.lisp — Language Form /2, Candidate /0.
;;;;
;;;; "The form may be rewritten."
;;;;
;;;;   A rewrite remembers what changed.
;;;;   It does not decide what the change means.
;;;;
;;;; Form /2 is the PRIMITIVE, GRAMMAR-INDEPENDENT transformation layer.  It
;;;; takes an inert CD/0 datum and returns an inert CD/0 datum.  It knows
;;;; nothing about Form /0, Form /1, Slice /2 or any grammar, and it never
;;;; loads them.  The successor it produces INHERITS NOTHING — no validation,
;;;; no execution standing, no authority, no evidentiary standing — and must
;;;; re-enter whatever proposal pipeline a host cares about as a new candidate,
;;;; on its own merits, as though no predecessor existed.
;;;;
;;;; WHAT A TRANSFORMATION RECEIPT ESTABLISHES, EXHAUSTIVELY:
;;;;
;;;;   this exact input datum was changed by this exact declared transformation
;;;;   into this exact output datum.
;;;;
;;;; WHAT IT DOES NOT ESTABLISH: semantic preservation, equivalence,
;;;; correctness, validity, admissibility, authorization, successful
;;;; realization, or successful petition submission.  A receipt is an ACCOUNT,
;;;; not an AUTHENTICATION (work order §8.2).
;;;;
;;;; TWO DOORS, and the split is load-bearing (work order §5).  Door 1 accepts
;;;; a raw CD/0 proposal datum and mints an immutable proposal object WITHOUT
;;;; looking inside the input.  Door 2 accepts that object and meets the actual
;;;; datum.  A proposal that can never apply is still a lawful proposal: the
;;;; proposal is a description a caller wrote; the application is an encounter
;;;; with a real datum.  Collapsing them would make "your description is
;;;; malformed" and "your description does not match the world" one refusal.
;;;;
;;;; NO PUBLIC CONSTRUCTOR mints a proposal object, a receipt or a refusal.
;;;; NO CALLER-SUPPLIED PROCEDURE reaches this surface: no callback, predicate,
;;;; visitor, transformer or handler.  The API takes DATA only, and a CD/0
;;;; datum cannot be a function.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (unless (find-package '#:lisp-plus-cd0)
    (load (merge-pathnames "../../canonical-datum/common-lisp/package.lisp"
                           (or *load-truename* *default-pathname-defaults*)))))

(defpackage #:lisp-plus-form2
  (:use #:common-lisp)
  (:export

   ;; ---- grammar constructors: a program writes a proposal BY HAND ----
   ;; These mint NOTHING.  They assemble inert CD/0 data that Door 1 may still
   ;; refuse.  A caller may build the identical datum with raw CD/0
   ;; constructors; these are ergonomics, never authority.
   #:replacement-proposal-datum
   #:path-datum
   #:index-step
   #:key-step

   ;; ---- DOOR 1 — propose.  Grammar only; the input's interior is untouched.
   #:try-propose-replacement
   #:propose-replacement

   ;; ---- DOOR 2 — apply.  The encounter with the actual datum.
   ;; TRY- returns THREE values on BOTH branches, so a caller destructuring the
   ;; result cannot read a refusal as a successor:
   ;;    success  (values successor receipt nil)
   ;;    refusal  (values nil       nil     refusal)
   ;; No convenience wrapper returns the successor alone.  A receipt a caller
   ;; can decline to take is a receipt this layer does not really produce.
   #:try-apply-replacement
   #:apply-replacement

   ;; ---- readers: the proposal ----
   #:replacement-proposal-p
   #:replacement-proposal-identity
   #:replacement-proposal-input-datum-identity
   #:replacement-proposal-path
   #:replacement-proposal-expected-old
   #:replacement-proposal-replacement
   #:replacement-proposal-occurrence-tag
   #:replacement-proposal-procedure-identity
   #:replacement-proposal-procedure-version
   #:replacement-proposal-policy-identity
   #:replacement-proposal-policy-version

   ;; ---- readers: the receipt ----
   ;; OBSERVED-OLD and OUTPUT-DATUM-IDENTITY are DERIVED PROJECTIONS (§6.2c):
   ;; readable fields, RECOMPUTED AND VERIFIED at construction, deliberately
   ;; NOT committed in the receipt identity.  See the narrow theorem in
   ;; form2.lisp and its five named non-establishments.
   #:form-transformation-receipt-p
   #:form-transformation-receipt-identity
   #:form-transformation-receipt-occurrence-identity
   #:form-transformation-receipt-proposal-identity
   #:form-transformation-receipt-input-datum-identity
   #:form-transformation-receipt-output-datum-identity
   #:form-transformation-receipt-path
   #:form-transformation-receipt-expected-old
   #:form-transformation-receipt-observed-old
   #:form-transformation-receipt-replacement
   #:form-transformation-receipt-procedure-identity
   #:form-transformation-receipt-procedure-version
   #:form-transformation-receipt-disposition
   #:form-transformation-receipt-policy-identity
   #:form-transformation-receipt-policy-version

   ;; ---- retained refusals: inspectable objects, never only printed ----
   #:form-transformation-refusal-p
   #:form-transformation-refusal-phase
   #:form-transformation-refusal-category
   #:form-transformation-refusal-code
   #:form-transformation-refusal-path
   #:form-transformation-refusal-offending
   #:form-transformation-refusal-detail
   #:form-transformation-refusal-identity
   ;; CD/0 passthrough (§10.4).  A rebuild can drive CD/0 past its record-key
   ;; work budget, and CD/0 labels that stage "host-import" — true of its own
   ;; constructor and misleading to a Form /2 caller who imported nothing.  The
   ;; Form /2 code corrects the classification FOR THE CALLER while these
   ;; readers PRESERVE what CD/0 actually said.  Both facts are true; the
   ;; reclassification is an added reading, never an overwrite.
   #:form-transformation-refusal-upstream-category
   #:form-transformation-refusal-upstream-code
   #:form-transformation-refusal-upstream-stage
   #:form-transformation-refusal-upstream-detail
   #:form-transformation-refusal-upstream-budget-id
   #:form-transformation-refused
   #:form-transformation-refused-refusal

   ;; ---- the refusal-code catalogue, SPLIT BY EVIDENTIARY CLASS ----
   ;; Both lists are DERIVED from one catalogue; their union is the complete
   ;; implementation code set by construction.  There is deliberately NO flat
   ;; FORM2-REFUSAL-CODES: a single list publishes a count that travels without
   ;; the distinction it flattens — codes a public caller can provoke, and
   ;; package-internal integrity guards that no public call can reach.  A host
   ;; writing a handler for one of the latter is writing dead code with no way
   ;; to tell, so the classification lives in the catalogue the host reads.
   #:transformation-refusal-code-catalog
   #:transformation-protocol-refusal-codes
   #:transformation-integrity-alarm-codes
   #:transformation-refusal-code-entry-p
   #:transformation-refusal-code-entry-code
   #:transformation-refusal-code-entry-class
   #:transformation-refusal-code-entry-reachability
   #:transformation-refusal-code-entry-note

   ;; ---- grammar, policy and procedure identity ----
   #:transformation-grammar-identity
   #:transformation-grammar-version
   #:transformation-policy-identity
   #:transformation-policy-version
   #:transformation-policy-max-input-octets
   #:transformation-policy-max-output-octets
   #:transformation-policy-max-path-depth
   #:transformation-policy-max-path-octets
   #:transformation-policy-max-occurrence-tag-octets
   #:transformation-policy-max-identity-octets
   #:transformation-policy-identity-tail-reserve-octets
   #:transformation-procedure-identity
   #:transformation-procedure-version
   #:identity-octets
   #:render-identity-hex))

;;;; DELIBERATELY NOT EXPORTED, each a decision rather than an omission:
;;;;
;;;;   MAKE-* for proposals, receipts, refusals or dispositions
;;;;     — the only way a proposal exists is Door 1; the only way a receipt
;;;;       exists is a fully-gated Door 2.
;;;;
;;;;   REPLACEMENT-PROPOSAL-DATUM-P
;;;;     — TRY-PROPOSE-REPLACEMENT is the authoritative classifier and returns
;;;;       an inspectable refusal.  A second boolean opinion has no inhabited
;;;;       need and could disagree with the entry point.
;;;;
;;;;   any path resolver (RESOLVE-PATH / DATUM-AT-PATH)
;;;;     — Form /2 resolves paths internally because it must.  Exporting the
;;;;       resolver would make Form /2 the de-facto owner of CD/0 addressing:
;;;;       a capability grab wearing a convenience.  If CD/0 wants a path
;;;;       facility, CD/0 should have one.
