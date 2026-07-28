;;;; package.lisp — Language Surface /1, Candidate /0.
;;;;
;;;; "The expansion leaves a receipt."
;;;;
;;;;   An expansion receipt says what form became what other form.
;;;;   It is silent about whether the transformation preserves meaning.
;;;;
;;;; ==================================================================
;;;; WHAT THIS LAYER IS
;;;;
;;;; Surface /1 makes ONE Common Lisp macro expansion an inspectable structural
;;;; occurrence.  It takes a host source form, encodes it as an inert CD/0 datum
;;;; under an explicit term grammar, performs a NAMED host macroexpansion
;;;; operation, encodes the result the same way, and mints an account of what
;;;; happened.  Both sides of the account are inert canonical data.
;;;;
;;;; WHAT AN EXPANSION RECEIPT ESTABLISHES, EXHAUSTIVELY:
;;;;
;;;;   this exact source form, presented to this exact named operation,
;;;;   produced this exact expanded form, in this image, at this moment.
;;;;
;;;; WHAT IT DOES NOT ESTABLISH.  Read this list before the code, because it is
;;;; the part a reader is most likely to supply for himself if nobody says it.
;;;; Form /2's work order left this frontier a written warning — "macroexpansion
;;;; is where the intuition 'the meaning is obviously the same' is strongest, and
;;;; it is therefore the place where a receipt is most likely to be read as a
;;;; preservation claim it never made.  A future expansion receipt must state its
;;;; limits more loudly than this one does, not less."  So:
;;;;
;;;;   NOT that the source and the expansion mean the same thing.
;;;;   NOT that the expansion is correct, well-formed, or sensible.
;;;;   NOT that evaluating the expansion would succeed.
;;;;   NOT that compiling it would behave as evaluating it does.
;;;;   NOT that the macro is hygienic, or that any capture did or did not occur.
;;;;   NOT that the expansion is portable to another Common Lisp.
;;;;   NOT that the expansion is reproducible in another image, another version
;;;;       of this implementation, or after any redefinition.
;;;;   NOT that a lexical environment was captured — NO ENVIRONMENT OBJECT IS
;;;;       EVER CAPTURED, ENCODED, OR REPRESENTED BY THIS LAYER.
;;;;   NOT that the construct behaved as its documentation says.
;;;;   NOT that later evaluation, admission, or judgment of the expanded form
;;;;       reaches backward and validates the expansion.  Nothing flows backward.
;;;;
;;;; A receipt is an ACCOUNT, not an AUTHENTICATION.  It establishes no
;;;; completeness, no ordering, no unique lineage, and no authenticity of any
;;;; receipt set; nothing here prevents a fabricated edge between two forms.
;;;;
;;;; ==================================================================
;;;; SURFACE /1 LOADS CD/0 ONLY.
;;;;
;;;; It does not load, :use, or name Surface /0, Slice /0/1/2, Core /0, Kernel /0,
;;;; Form /0, Form /1 or Form /2.  There is no `lisp-plus-surface0::` and no
;;;; `lisp-plus-form2::` anywhere in surface1.lisp, and there must never be.
;;;; The five known constructs are named by PACKAGE-NAME and SYMBOL-NAME STRINGS
;;;; in a closed table, resolved by FIND-SYMBOL at expansion time.  If the
;;;; Surface /0 package is absent from the image, a request naming one of its
;;;; constructs refuses honestly — it does not fail to load.
;;;;
;;;; The reason is the repository's own law: no host symbol is ever a durable
;;;; name.  A construct's durable identity is a CD/0 identifier datum in THIS
;;;; layer's namespace, and the host symbol is only the transient thing looked up
;;;; to find a macro function in this image.
;;;;
;;;; ==================================================================
;;;; SURFACE /1 NEVER CONVERTS ANOTHER LAYER'S REFUSAL INTO AN EXPANSION.
;;;;
;;;; A source form that Surface /0's own grammar refuses produces NO Surface /1
;;;; outcome at all: no occurrence, no receipt, no refusal object.  Surface /0's
;;;; condition escapes to the caller in Surface /0's own voice, unwrapped and
;;;; unreclassified.  Catching it would make "your syntax is malformed" a fact
;;;; this layer reported, when it is a fact the layer below owns — the same rule
;;;; Form /2 states as "a lawful replacement producing a datum Form /1 will refuse
;;;; is a Form /2 SUCCESS followed by a Form /1 REFUSAL, and the two must remain
;;;; two events."
;;;;
;;;; This layer catches NOTHING from a macro function.  Not ERROR, not
;;;; SERIOUS-CONDITION, not CONDITION.  A genuine host bug inside an expander
;;;; escapes, which is correct: a surface that swallowed a real bug as a refusal
;;;; would be lying about the language.
;;;;
;;;; ==================================================================
;;;; TWO DOORS, and the split means something different here than in Form /2.
;;;;
;;;;   DOOR 1  REQUEST-EXPANSION accepts a source form, an operation keyword and
;;;;           a host-supplied occurrence tag.  It encodes the source form,
;;;;           snapshots it, and mints an immutable request object.  IT DOES NOT
;;;;           EXPAND, does not look up a macro function, and does not require
;;;;           the named construct to exist.  A request that can never be
;;;;           performed is still a lawful request.
;;;;
;;;;   DOOR 2  PERFORM-EXPANSION accepts that request object and meets the actual
;;;;           image: it resolves the construct, calls the named host operation,
;;;;           encodes what came back, and mints an occurrence and a receipt.
;;;;
;;;; WHERE THIS DIFFERS FROM FORM /2, AND IT IS THE DEEPEST FACT ABOUT THE LAYER:
;;;;
;;;;   Form /2's Door 1 receives a COMPLETE description — the caller supplies the
;;;;   replacement — so the output identity is DERIVABLE from the request, and
;;;;   Form /2 may omit it from the occurrence identity as a derived projection.
;;;;
;;;;   HERE THE CALLER CANNOT DECLARE THE OUTPUT.  That is what a macro IS: the
;;;;   expansion is computed by a procedure this layer does not own and cannot
;;;;   predict.  So the EXPANDED-FORM IDENTITY IS COMMITTED INTO THE OCCURRENCE
;;;;   IDENTITY, never omitted, and there is no derivability theorem here and
;;;;   cannot be one.  Door 1 validates strictly less than Form /2's does, and it
;;;;   must not pretend to more.
;;;;
;;;; Consequently there is NO expected-old field, NO observed-old field, NO path,
;;;; and NO :REPLACED-AT-PATH disposition.  Reusing any of them would represent a
;;;; computed rewrite as a declared substitution at a caller-named address.  The
;;;; caller named a CALL SITE, not a path, and supplied no replacement.
;;;;
;;;; ==================================================================
;;;; THE TERM GRAMMAR — the explicit boundary representation.
;;;;
;;;; CD/0 has NO symbol family, NO cons family, NO character or float family.  A
;;;; host form therefore does not "go into" CD/0; it is REPRESENTED there, under
;;;; a grammar stated once and enforced in code.  Every term is a CD/0 record of
;;;; exactly two fields:
;;;;
;;;;     TERM/KIND   -> identifier TERMKIND/<kind>
;;;;     TERM/VALUE  -> the payload
;;;;
;;;;     SYMBOL   value = identifier <package-name>/<symbol-name>
;;;;     INTEGER  value = integer datum
;;;;     STRING   value = string datum
;;;;     LIST     value = sequence datum of terms
;;;;
;;;; AND NOTHING ELSE IS REPRESENTABLE.  Refused, each with its own code:
;;;;
;;;;   an UNINTERNED SYMBOL — it has no package, so it has no namespace, and two
;;;;     distinct gensyms bearing one name would collapse to one datum because
;;;;     CD/0 compares identifier segments BYTEWISE.  Encoding them would destroy
;;;;     exactly the binding structure that makes them meaningful.  This is the
;;;;     single largest representational obstruction in the layer and it is
;;;;     refused, not worked around.
;;;;   a SYMBOL WITH AN EMPTY NAME — CD/0 refuses a zero-octet segment.
;;;;   an IMPROPER LIST — CD/0 refuses a dotted tail.
;;;;   a CIRCULAR OR SHARED structure — refused; the grammar has no DAG.
;;;;   ANY OTHER HOST TYPE — character, float, ratio, complex, array, pathname,
;;;;     structure, function, hash table, package, readtable, stream, restart,
;;;;     condition, source-location object, or an implementation's private
;;;;     objects.  There is no printed-representation escape hatch and there must
;;;;     never be: a string of a printed object is not the object, and a receipt
;;;;     that stored one would be accounting for a rendering.
;;;;
;;;; NIL IS ENCODED AS THE SYMBOL COMMON-LISP:NIL, ALWAYS.  In Common Lisp the
;;;; empty list and the symbol NIL are one object; the grammar cannot distinguish
;;;; them because the host does not.  This is a declared property of the host,
;;;; not a loss introduced here, and it is stated rather than hidden.
;;;;
;;;; ==================================================================
;;;; THE DEPTH CEILING IS MEASURED, NOT COPIED.
;;;;
;;;; CD/0 enforces max-depth on its DECODE path, not at construction.  A term
;;;; datum can therefore be BUILT deeper than it can be READ BACK — measured: a
;;;; host form nested 201 levels encodes without complaint and refuses on decode
;;;; at 64, because this grammar costs ~2.03 CD/0 depth units per host list
;;;; level.  A layer that minted such a receipt would be issuing an account whose
;;;; own canonical octets cannot be decoded.  So Surface /1 declares its own
;;;; source-form depth ceiling, enforces it in code at BOTH doors, and the number
;;;; comes from bisecting the real edge rather than from copying CD/0's 128 and
;;;; assuming it counted host levels.
;;;;
;;;; ==================================================================
;;;; FORBIDDEN VOCABULARY.  Form /2's list is inherited verbatim —
;;;;
;;;;   repair · repaired · preserved · preserving · equivalent · equivalence
;;;;   normalized · normalization · corrected · correct · improved · valid
;;;;
;;;; — and, because this layer stands where the preservation intuition is
;;;; strongest, extended by:
;;;;
;;;;   hygienic · hygiene · capture-free · same-meaning · behaviour-preserving
;;;;   semantically-equivalent · faithful · portable · verified · sound
;;;;
;;;; None may appear in any disposition, receipt field, refusal code or fixture
;;;; title.  THE LAYER MAY SAY WHAT FORM BECAME WHAT OTHER FORM.  IT MAY NEVER
;;;; SAY BETTER, SAME, OR RIGHT.
;;;;
;;;; ==================================================================
;;;; NO CALLER-SUPPLIED PROCEDURE reaches this public surface: no callback, no
;;;; predicate, no visitor, no transformer, no handler.  The only procedure this
;;;; layer invokes is a macro function it did NOT receive as an argument — it
;;;; resolved it from a CLOSED, EXHAUSTIVE table of five constructs, by name, in
;;;; a package it does not load.  Form /2 could say "the API takes DATA only, and
;;;; a CD/0 datum cannot be a function."  THIS LAYER CANNOT SAY THAT, and the
;;;; closed table is the gate that replaces it.  That gate is NEW LAW, declared
;;;; here, and it is not inherited from any predecessor.
;;;;
;;;; NO PUBLIC CONSTRUCTOR mints a request object, an occurrence, a receipt or a
;;;; refusal.  Every such object is immutable, with read-only slots, no copier,
;;;; and an unexported constructor.
;;;;
;;;; ==================================================================
;;;; STANDING.  Candidate.  Not audited.  Not adopted.  Not frozen.  On no
;;;; governing floor.  Every green in this layer is SELF-CONSISTENCY
;;;; CERTIFICATION by the family that wrote it; the stranger audit is OWED and is
;;;; not discharged by Form /0's, Form /1's or Form /2's.
;;;;
;;;; SEMANTIC DELTA BELOW THIS LAYER: NONE CLAIMED.  Surface /0 is not modified,
;;;; not extended, not wrapped, and not re-implemented.  No macro's behaviour is
;;;; altered to make receipt construction convenient: the observer accounts for
;;;; the expansion that exists, and never manufactures a friendlier one and then
;;;; certifies its own handiwork.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (unless (find-package '#:lisp-plus-cd0)
    (error "Surface /1 requires CD/0 to be loaded first.")))

(defpackage #:lisp-plus-surface1
  (:use #:cl)
  (:export
   ;; ---- layer identity: THIS layer's, never a predecessor's ----
   #:expansion-grammar-identity
   #:expansion-grammar-version
   #:expansion-procedure-identity
   #:expansion-procedure-version
   #:expansion-policy-identity
   #:expansion-policy-version

   ;; ---- the closed construct table ----
   #:known-surface-constructs
   #:construct-identity-for
   #:surface-construct-entry-namespace
   #:surface-construct-entry-name
   #:surface-construct-entry-identity

   ;; ---- the declared operations ----
   #:expansion-operations

   ;; ---- policy ceilings ----
   #:expansion-policy-max-source-depth
   #:expansion-policy-max-source-nodes
   #:expansion-policy-max-term-octets

   ;; ---- DOOR 1: describe ----
   #:request-expansion
   #:try-request-expansion
   #:expansion-request-p
   #:expansion-request-identity
   #:expansion-request-source-form-datum
   #:expansion-request-source-form-identity
   #:expansion-request-operation
   #:expansion-request-construct-identity
   #:expansion-request-occurrence-tag

   ;; ---- DOOR 2: perform ----
   #:perform-expansion
   #:try-perform-expansion

   ;; ---- the receipt ----
   #:expansion-receipt-p
   #:expansion-receipt-identity
   #:expansion-receipt-request-identity
   #:expansion-receipt-occurrence-identity
   #:expansion-receipt-source-form-datum
   #:expansion-receipt-source-form-identity
   #:expansion-receipt-expanded-form-datum
   #:expansion-receipt-expanded-form-identity
   #:expansion-receipt-operation
   #:expansion-receipt-construct-identity
   #:expansion-receipt-expansion-context
   #:expansion-receipt-disposition
   #:expansion-receipt-procedure-identity
   #:expansion-receipt-procedure-version
   #:expansion-receipt-policy-identity
   #:expansion-receipt-policy-version

   ;; ---- refusal: retained objects, never printed conditions ----
   #:expansion-refused
   #:expansion-condition-refusal
   #:expansion-refusal-p
   #:expansion-refusal-identity
   #:expansion-refusal-phase
   #:expansion-refusal-category
   #:expansion-refusal-code
   #:expansion-refusal-detail
   #:expansion-refusal-occurrence-tag
   #:expansion-refusal-upstream-category
   #:expansion-refusal-upstream-code
   #:expansion-refusal-upstream-stage

   ;; ---- the refusal catalogue, split and never flattened ----
   #:expansion-refusal-code-catalog
   #:expansion-protocol-refusal-codes
   #:expansion-integrity-alarm-codes
   #:refusal-catalog-entry-code
   #:refusal-catalog-entry-class
   #:refusal-catalog-entry-phase
   #:refusal-catalog-entry-note

   ;; ---- the term grammar, public because a reader must be able to check it ----
   #:encode-term
   #:term-kinds
   #:identity-octets
   #:render-identity-hex))
