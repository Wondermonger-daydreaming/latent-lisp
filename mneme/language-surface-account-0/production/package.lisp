;;;; package.lisp — Surface Account /0 production package definition.
;;;;
;;;; Loaded BEFORE the implementation (by production/load.lisp and by the
;;;; ASDF system).  The complete public surface is these NINE exports; each
;;;; is traced to an accepted contract clause in
;;;; ../R4/R4-PRODUCTION-DESIGN-LEDGER.md §3.  No condition type is exported
;;;; and none is defined: every refusal is a plain error with an exact
;;;; greppable text (the accepted DEFINE-CONDITION decision — the concurrent
;;;; layout-redefinition scar — is preserved, not tidied).
;;;;
;;;; THIS FILE IS ALSO THE REPAIR INSTRUMENT (R4.3): when the loader's
;;;; completeness predicate finds the package present but INCOMPLETE (a
;;;; half-load, a pre-created namesake with internal or partial dummies, an
;;;; empty namesake package), production/load.lisp re-applies this
;;;; DEFPACKAGE before loading the implementation.  DEFPACKAGE against an
;;;; existing package finds the existing namesake symbols — PRESERVING
;;;; their identity — and exports them; the implementation's DEFUNs then
;;;; rebind every export to the real mechanism.  A genuine name conflict
;;;; (some package USING this one with a clashing accessible symbol)
;;;; signals and propagates: fail closed, never silent acceptance.
;;;;
;;;; Internal symbols keep the oracle's sa0- names so the probe->production
;;;; correspondence stays line-auditable.  The carrier symbol
;;;; (SA0-IDENTITY-CARRIER), the test-gate symbol (SA0-IDENTITY-TEST-GATE)
;;;; and the election-log symbol (SA0-IDENTITY-ELECTION-LOG) are interned in
;;;; THIS package — distinct from the frozen probe's CL-USER carriers, so
;;;; the oracle and the product never share state in one image.

(defpackage #:lisp-plus-surface-account
  (:use #:common-lisp)
  (:export
   ;; the once-only image identity (one process-wide state; bounded owner
   ;; re-entry; contention; post-election failure closure)
   #:initialize-image-identity
   #:identity-ready-p
   ;; the image epoch (exactly one gathering; the one textual projection)
   #:image-epoch-hex
   #:image-epoch-datum
   #:epoch-gatherings
   #:election-count
   ;; monotonic account allocation + the one performance-identifier
   ;; constructor
   #:mint-performance-identifier
   ;; the canonical ASCII decimal counter law (R3.3-C) as admission
   ;; instruments
   #:performance-identifier-shape-p
   #:lawful-counter-text-p))
