;;;; package.lisp — Language Surface /0: MACROEXPANSION AS THE HONEST COMPILER.
;;;;
;;;; Governed by LANGUAGE-SURFACE-0-WORK-ORDER.md (owner-issued, 2026-07-25).
;;;; Nothing here is frozen: `specification-frozen: no`, and this is a candidate.
;;;;
;;;; WHAT THIS LAYER IS.  A small, explicit Common Lisp macro layer over the
;;;; existing PUBLIC APIs of Slice /1 and Slice /2.  MACROEXPAND-1 shows the
;;;; governing substrate: the same public constructors, the same registry
;;;; operation, the same DERIVE or DERIVE/2 call, the same typed refusal, and
;;;; ordinary Common Lisp bindings and control flow.
;;;;
;;;; WHAT THIS LAYER IS NOT.  There is no reader macro, no custom readtable, no
;;;; parser, no interpreter, no evaluator, no source-to-source string
;;;; processing, no hidden policy engine, and no second runtime.  The direct
;;;; constructor API remains public and fully usable; this adds a way to say the
;;;; same thing, never a different thing to say.
;;;;
;;;; THE BOUNDARY LAW, adopted verbatim from the work order:
;;;;
;;;;     Surface syntax may remove repetition.  It may not remove the place
;;;;     where a standing-relevant choice is made.
;;;;
;;;; So the ceremony goes and the choices stay.  Schema identity and version,
;;;; contract identity and version, every premise position, every accepted
;;;; clause, the proposition relation, the receiver-accessibility requirement,
;;;; the retention requirements, the truth ceilings, DERIVE vs DERIVE/2, grant
;;;; vs typed refusal, and claim vs source basis vs derivation basis all remain
;;;; written in the source.  No authority-bearing default is inferred from a
;;;; name, a package, a procedure identity, a predicate, a variable name, or a
;;;; nearby declaration.
;;;;
;;;; SEMANTIC DELTA BELOW THE SURFACE: NONE CLAIMED.  Surface /0 adds no
;;;; judgment, admission, provenance, accessibility, effect or authority
;;;; semantics.  Every green here is self-consistency certification, and the
;;;; stranger audit remains OWED.

(defpackage #:lisp-plus-surface0
  (:use #:cl)
  (:export
   ;; ---- the five principal forms, and no ergonomic aliases ----
   #:define-judgment-schema
   #:define-admission-contract
   #:define-slice2-schema
   #:derive-case
   #:derive/2-case
   ;; ---- surface GRAMMAR refusal (never a semantic taxonomy) ----
   #:surface-syntax-refused
   #:surface-syntax-refused-form
   #:surface-syntax-refused-reason
   #:surface-syntax-refused-offending
   #:surface-syntax-reasons))
