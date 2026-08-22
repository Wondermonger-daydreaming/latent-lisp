;;;; package.lisp — MANY ACTS /0, the program-authoring lane.
;;;;
;;;; STANDING: standing attaches to immutable object identities and explicit
;;;; dispositions, never merely to a filename, a directory, or descent from an
;;;; adopted commit (Owner Ruling 6 §3 B1; the rule and the adopted coordinates
;;;; are in MANY-ACTS-0-STANDING.md).  This file's path confers no standing on
;;;; its bytes in either direction.  Nothing produced here is independent
;;;; verification (AP0 adoption Rider 2, binding; contract §0): the phrases
;;;; "independently verified" and "independently validated" may not appear in
;;;; any artifact of this lane.
;;;;
;;;; WHAT THIS LANE IS (contract §2): the smallest closed authoring surface
;;;; through which a finite Lisp+ program — represented as inspectable data —
;;;; sequences MULTIPLE adopted One Act /0 executions with lexical binding,
;;;; explicit outcome inspection, exact branching, and structured terminal
;;;; results.
;;;;
;;;; NO MACRO IS MINTED HERE OR ANYWHERE IN THIS LANE (contract §6).  No
;;;; Surface /2 construct head is minted, wrapped, renamed, or extended.
;;;;
;;;; ⚠ NO UNEXPORTED SYMBOL OF ANY PREDECESSOR PACKAGE IS REFERENCED ANYWHERE
;;;; IN THIS LANE (contract §3).  The obligation is mechanical: no `::` against
;;;; a predecessor package occurs in this lane's sources, and the selftest
;;;; greps its own files to prove it rather than asserting it in prose.
;;;;
;;;; — FABER (Claude Opus 5, subagent), 2026-08-09

(defpackage #:lisp-plus-many-acts0.program
  (:use)
  (:documentation
   "THE PROGRAM-SYMBOL NAMESPACE.  Program sources are READ with *package*
bound here, so every non-keyword symbol in a lawful source — grammar heads and
program IDENTs alike — is homed HERE and nowhere else.  NOTHING IS EVER BOUND
IN THIS PACKAGE: it holds names, never code.  A source that reaches the
validator carrying a symbol homed anywhere else (`cl:list`, a host package's
internal, a gensym) is refused by V-PKG.

WHY HEADS LIVE HERE TOO.  The validator recognises grammar heads by SYMBOL-NAME
against a closed vocabulary, and separately confirms the symbol's HOME PACKAGE
is one of exactly two: this namespace, or #:lisp-plus-many-acts0.  Recognising
heads by name rather than by identity is what lets one source text be read into
this namespace by the lane's own reader AND be typed literally in a host image
without either copy becoming a different program.  Recognising the home PACKAGE
in the same breath is what keeps that latitude from becoming a hole: a symbol
whose name happens to be \"ACT\" but whose home is some other package is
refused, not honoured."))

(defpackage #:lisp-plus-many-acts0
  (:use #:cl)
  (:documentation
   "Many Acts /0 — the closed program-authoring surface over One Act /0.")
  (:export
   ;; ---- validation: source -> validated-program, or a typed refusal --------
   #:ma0-validate
   #:ma0-validated-program-p
   #:ma0-program-name
   #:ma0-program-source

   ;; ---- environment: the ONLY door through which live state enters a run ---
   #:make-ma0-environment
   #:ma0-environment-p
   #:ma0-environment-store-id

   ;; ---- evaluation ---------------------------------------------------------
   #:ma0-run-program
   #:ma0-complete-act

   ;; ---- the immutable program result --------------------------------------
   #:ma0-result-p
   #:ma0-result-program-name
   #:ma0-result-disposition
   #:ma0-result-value
   #:ma0-result-refusal-code
   #:ma0-result-refusal-detail
   #:ma0-result-act-summaries
   #:ma0-result-store-id

   ;; ---- the immutable per-act summary --------------------------------------
   #:ma0-act-summary-p
   #:ma0-act-summary-arm
   #:ma0-act-summary-act-id-hex
   #:ma0-act-summary-disposition
   #:ma0-act-summary-class
   #:ma0-act-summary-verdict

   ;; ---- conditions (every refusal of this lane is TYPED and carries a
   ;; ---- stable code; never named by message text) --------------------------
   #:ma0-refusal
   #:ma0-refusal-code
   #:ma0-refusal-detail
   #:ma0-source-refused
   #:ma0-environment-refused
   #:ma0-authority-slot-unfilled
   #:ma0-binding-refused
   #:ma0-pattern-refused
   #:ma0-composition-divergence
   ;; R1/D4: a stale environment — one built before a later
   ;; `make-ma0-environment' took over the run-state specials — refused before
   ;; the first consequential act, with zero footprint in either store.
   #:ma0-environment-stale
   #:ma0-environment-stale-store-id

   ;; ---- constants ----------------------------------------------------------
   #:+ma0-grammar-version+
   #:+ma0-arms+
   #:+ma0-axes+

   ;; ---- runner entry -------------------------------------------------------
   #:ma0-selftest))
