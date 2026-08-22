;;;; lisp-plus.asd — Lisp+ Integration Baseline /0 build/load container
;;;;
;;;; WHAT THIS IS
;;;;
;;;;   A build/load container for the current Lisp+ construction.  It is NOT a
;;;;   semantic authority.  It defines no packages of the language, exports no
;;;;   symbol of the language, and changes no lane's meaning.  Every system
;;;;   below delegates to a load entrypoint that already exists in the tree and
;;;;   was already the lane's declared way in.
;;;;
;;;;   The language is Lisp+.  Mneme is its memory-and-continuity layer (see
;;;;   mneme/architecture/ARCHITECTURE-0-STATUS.md:23).  The `mneme/` directory
;;;;   currently holds the whole construction; the memory layer itself is not
;;;;   implemented.
;;;;
;;;;   Loading this system does NOT adopt any implementation.  Every lane
;;;;   remains exactly the candidate or accepted-candidate its own ruling says
;;;;   it is.
;;;;
;;;; WHY THE COMPONENTS ARE LOAD-ENTRYPOINTS AND NOT FILE LISTS
;;;;
;;;;   Every source file in this tree resolves its dependencies relative to
;;;;   `*load-truename*` — the directory of the SOURCE file being loaded.  If
;;;;   ASDF compiled these files, `*load-truename*` at fasl-load time would be
;;;;   the ASDF output cache, and every `"../<lane>/..."` reference in the tree
;;;;   would resolve into that cache and fail.  So these systems load SOURCE, in
;;;;   place, exactly as `sbcl --script` does today.  Nothing is compiled and no
;;;;   fasl cache is used.
;;;;
;;;;   Re-declaring each lane's ~100 files as ASDF components would create a
;;;;   SECOND authority on load order, free to drift from the `load.lisp` the
;;;;   lane actually ships.  This container defers to the lane's own declared
;;;;   order instead.  That is the whole design.
;;;;
;;;; ==========================================================================
;;;; THE TWO LOAD DISCIPLINES, AND WHY ORDER IS LOAD-BEARING  (R1, 2026-08-02)
;;;; ==========================================================================
;;;;
;;;;   (a) GUARDED lanes open with `(unless (find-package ...) (load ...))`.
;;;;       They are idempotent and may be loaded in any order.  Every Stack-B
;;;;       lane is guarded, and each guard-loads Canonical Datum /0 (or its own
;;;;       predecessor) for itself.
;;;;
;;;;       ⚠ TWO LANES ARE **NOT** IN THIS CLASS, and must never be returned
;;;;       to it: Surface Account /0 (R4.1/R4.3) and One Act /0 (R2.2) are
;;;;       COMPLETENESS-CHECKED — their guard is a predicate over the whole
;;;;       declared external API plus a readiness carrier, because for them
;;;;       PACKAGE EXISTENCE IS NOT IMPLEMENTATION READINESS.  A `find-package`
;;;;       guard on either certifies a half-built or empty lane as loaded, at
;;;;       ASDF exit 0.  Both defects were reproduced by the owner, on two
;;;;       different lanes, three weeks apart.
;;;;
;;;;   (b) The Stack-A core chain is UNGUARDED:
;;;;         capability2/load.lisp -> capability1 -> capability0
;;;;                               -> journal0 -> kernel0 -> canonical-datum
;;;;       Every link loads its predecessor UNCONDITIONALLY.
;;;;
;;;;   Two consequences follow, and R1 exists because the first version of this
;;;;   file respected only one of them:
;;;;
;;;;   1. Entering the chain twice re-evaluates `kernel0/identity.lisp` and
;;;;      signals `SB-EXT:DEFCONSTANT-UNEQL` on `+IDENTITY-PROCEDURE+`.
;;;;      (Known and handled since the first version: the chain is ONE system,
;;;;      entered once at its deepest point.)
;;;;
;;;;   2. ANYTHING THAT LOADS CANONICAL DATUM /0 BEFORE THE CHAIN RUNS CAUSES
;;;;      THE CHAIN TO LOAD IT A SECOND TIME.  The chain does not ask whether
;;;;      CD/0 is present; it loads it.  The first version of this file declared
;;;;      `lisp-plus/stack-a` as depending on `lisp-plus/cd0`, so CD/0 was
;;;;      loaded, and then loaded again by the chain — **187 redefinition
;;;;      warnings on the canonical front-door path**, which exited 0 and were
;;;;      read past.  A command may exit zero and still not be a clean load.
;;;;
;;;;   THE REPAIR IS ORDERING, NOT SUPPRESSION.  No warning is muffled anywhere
;;;;   in this file.  Instead:
;;;;
;;;;     * `*lane-order*` below is the single ordered table of lanes, and
;;;;       STACK A IS FIRST.  The chain that must load CD/0 for itself gets to
;;;;       be the one that loads it.  Every later lane is guarded and finds it
;;;;       already present.
;;;;
;;;;     * The umbrella walks that table itself rather than relying on a
;;;;       `:depends-on` list.  ASDF's planner is free to order independent
;;;;       systems as it sees fit; a list printed in the desired order is not a
;;;;       guarantee that it executes in that order.  Here the order is code.
;;;;
;;;;     * No CD/0-only lane declares a dependency on `lisp-plus/cd0` any more.
;;;;       Those lanes (surface1, form0, form2) guard-load CD/0 themselves, so
;;;;       the dependency was never real — it was a false edge that existed only
;;;;       to coerce order, and it is exactly what produced the duplicate.
;;;;
;;;;     * `lisp-plus/stack-a` FAILS CLOSED on the one composition that cannot
;;;;       be made clean by ordering alone: CD/0 already loaded while Kernel /0
;;;;       is not.  See SUPPORTED LOAD ORDERS below.
;;;;
;;;; ==========================================================================
;;;; SUPPORTED LOAD ORDERS (all tested; results in the R1 return)
;;;; ==========================================================================
;;;;
;;;;   SUPPORTED, warning-free from a fresh image:
;;;;     * `lisp-plus` (the umbrella)          — the canonical front door
;;;;     * `lisp-plus/stack-a` alone
;;;;     * `lisp-plus/cd0` alone
;;;;     * any single CD/0-only lane alone (surface1, form0, form2)
;;;;     * any Stack-B lane alone
;;;;     * `lisp-plus/stack-a` then `lisp-plus/cd0`  (cd0 finds CD/0 present)
;;;;     * loading the umbrella twice in one image   (second load is a no-op)
;;;;
;;;;   UNSUPPORTED, and it FAILS CLEANLY rather than redefining:
;;;;     * `lisp-plus/cd0` (or any CD/0-only lane) FIRST, then
;;;;       `lisp-plus/stack-a` in the same image.
;;;;       The unguarded chain would reload CD/0.  `lisp-plus/stack-a` detects
;;;;       this precondition and signals a named error instead.  Repairing it
;;;;       properly requires adding a guard to `kernel0/load.lisp`, which is a
;;;;       semantic-lane source edit this milestone is forbidden to make.  It is
;;;;       recorded as a load-discipline debt, not silently worked around.
;;;;
;;;; SUPPORTED ENVIRONMENT
;;;;
;;;;   SBCL 2.4.6 on Linux.  No other implementation or version has ever been
;;;;   tested.  Portability is not claimed.

(defpackage #:lisp-plus-system
  (:use #:common-lisp)
  (:export #:*root* #:*lane-order* #:lane #:lane-once #:lane-once-complete
           #:surface-account-api-complete-p #:load-lanes-in-order
           #:require-stack-a-precondition #:unsupported-load-order
           ;; One Act /0 loader finality (R2.2)
           #:act0-api-complete-p #:act0-api-shortfall #:act0-lane-files
           #:load-act0-lane #:ensure-act0-lane #:act0-lane-incomplete))

(in-package #:lisp-plus-system)

;;; The subject-tree root, taken from this file's own location.  Checkout- and
;;; cwd-independent: no `/home/...`, no worktree name, no current directory.
(defparameter *root*
  (make-pathname :name nil :type nil
                 :defaults (or *load-truename* *compile-file-truename*
                               *default-pathname-defaults*)))

(defun lane (relative-path)
  "Load RELATIVE-PATH (a string, relative to the subject-tree root) as source."
  (load (merge-pathnames relative-path *root*)))

(defun lane-once (package-designator relative-path)
  "Load RELATIVE-PATH unless PACKAGE-DESIGNATOR already names a live package.
Mirrors the guard idiom the tree's own sources use."
  (unless (find-package package-designator)
    (lane relative-path)))

;;; Surface Account /0 readiness (R4.1, sharpened R4.3).  PACKAGE EXISTENCE
;;; IS NOT LANE COMPLETENESS for this lane: its implementation runs the
;;; once-only initialization MID-FILE (oracle-faithful placement), so a
;;; first load that fails at initialization leaves the package present with
;;; five of the nine declared exports unbound — and a package-keyed guard
;;; would certify that half-loaded lane as loaded (STRANGER's R4 finding
;;; R4-PRODUCTION-HALF-LOAD-CERTIFIED-BY-THE-PACKAGE-GUARD).  AND FBOUNDP
;;; ALONE IS NOT API COMPLETENESS EITHER (R4.3, the owner's
;;; R4-READINESS-GUARD-ACCEPTS-NONEXTERNAL-API counterexample): the R4.1
;;; predicate discarded FIND-SYMBOL's second value, so nine INTERNAL fbound
;;; dummies in a pre-created namesake package satisfied it and the umbrella
;;; certified a lane with zero public exports and no identity carrier.  The
;;; predicate therefore requires, for every declared name, FIND-SYMBOL
;;; status :EXTERNAL **and** FBOUNDP (all nine exports are functions; none
;;; is a variable, so no BOUNDP clause is needed), plus the presence of the
;;; identity carrier symbol (interned only by actually reading the
;;; implementation).  The body between the SA0-COMPLETENESS-PREDICATE-CORE
;;; markers is kept token-identical to the copy in production/load.lisp —
;;; one predicate in substance, two forced textual homes — enforced by the
;;; lane's static agreement gate (surface-account-graph-gate.sh GG-5/GG-6);
;;; the selftest's export census keeps the nine-name list honest.  A lawful
;;; complete load satisfies it exactly as before; an incomplete lane fails
;;; it, so the lane loader runs and REPAIRS (package.lisp re-applied first,
;;; then the implementation), asserting the same predicate after the load
;;; and failing closed if it still does not hold.
(defun surface-account-api-complete-p ()
  ;; SA0-COMPLETENESS-PREDICATE-CORE-BEGIN (GG-5: this region is
  ;; token-identical to the copy in production/load.lisp — one predicate
  ;; in substance, two forced textual homes)
  (let ((package (find-package '#:lisp-plus-surface-account)))
    (and package
         (not (null (find-symbol "SA0-IDENTITY-CARRIER" package)))
         (every (lambda (name)
                  (multiple-value-bind (symbol status)
                      (find-symbol name package)
                    (and symbol
                         (eq status :external)
                         (fboundp symbol))))
                '("INITIALIZE-IMAGE-IDENTITY" "IDENTITY-READY-P"
                  "IMAGE-EPOCH-HEX" "IMAGE-EPOCH-DATUM"
                  "EPOCH-GATHERINGS" "ELECTION-COUNT"
                  "MINT-PERFORMANCE-IDENTIFIER"
                  "PERFORMANCE-IDENTIFIER-SHAPE-P"
                  "LAWFUL-COUNTER-TEXT-P"))))
  ;; SA0-COMPLETENESS-PREDICATE-CORE-END
  )

(defun lane-once-complete (completeness-predicate relative-path)
  "Load RELATIVE-PATH unless COMPLETENESS-PREDICATE (a function designator)
returns true.  The predicate-guarded sibling of LANE-ONCE, for lanes whose
loaded-ness is not equivalent to their package's existence."
  (unless (funcall completeness-predicate)
    (lane relative-path)))

;;; ==========================================================================
;;; One Act /0 readiness (R2.2).  PACKAGE EXISTENCE IS NOT IMPLEMENTATION
;;; READINESS — the second terminal of the species Surface Account R4.3
;;; permanently outlawed.
;;;
;;; The stanza this replaces opened `(unless (find-package
;;; '#:lisp-plus-language-act0) ...)`, and the owner reproduced two
;;; false-success states against it (ruling R2.2, "Blocking defect"):
;;;
;;;   EMPTY NAMESAKE PACKAGE      ASDF exit 0 · exports 0  · RUN-ACT absent
;;;   PACKAGE.LISP LOADED ALONE   ASDF exit 0 · exports 70 · RUN-ACT :EXTERNAL
;;;                                                          but not FBOUNDP
;;;
;;; Either an empty package collision, or merely loading `package.lisp` to
;;; read the interface, made `asdf:load-system "lisp-plus/act0"` report
;;; success over an unusable lane.  Note the second state especially: the
;;; export census was already CORRECT (70 of 70, every name :EXTERNAL) and
;;; the lane was still empty — which is why a census-only predicate would
;;; be no cure, and why every name below is checked for the BINDING its
;;; kind requires.
;;;
;;; THE API IS ENUMERATED, NEVER ITERATED.  A predicate that walked
;;; DO-EXTERNAL-SYMBOLS would be satisfied by whatever the package happens
;;; to contain — an empty package trivially satisfies "every external
;;; symbol is fbound".  The three lists below are the declared external
;;; interface of `mneme/language-act-0/package.lisp`, written out:
;;;
;;;   41 functions   (FBOUNDP)
;;;   13 variables and lane constants  (BOUNDP)
;;;   16 types — 14 conditions + 2 structure classes  (FIND-CLASS)
;;;   --
;;;   70 declared exports, asserted by +ACT0-API-COUNT+ so that editing a
;;;      list without editing the count fails closed rather than silently
;;;      shrinking the guard;
;;;   + 1 final-source readiness carrier (below), which no census can supply.
;;;
;;; Every name is additionally required to have FIND-SYMBOL status
;;; :EXTERNAL — the R4.3 clause, carried here whole: a status-blind check is
;;; satisfied by internal fbound dummies in a pre-created package.
;;;
;;; THE CARRIER IS WHY THE FOURTH SOURCE CANNOT BE SKIPPED.  Bindings alone
;;; cannot prove a load reached the END of the LAST file: 40 of the 41
;;; functions are defined in act0.lisp, so a lane loaded through
;;; act0.lisp and stopped before act0-gates.lisp is 69/70 complete.
;;; ACT0-LANE-READY-CARRIER is established by the LAST form of
;;; act0-gates.lisp, the last-loaded source; its presence, boundness and
;;; exact value are the evidence that the final form of the final source
;;; was evaluated.  (Idiom taken from Surface Account /0's
;;; SA0-IDENTITY-CARRIER, strengthened from presence-only to
;;; presence + BOUNDP + EQUAL value, since a bare interned name can be
;;; forged by any hand that can pre-create a package.)
;;;
;;; The carrier is INTERNAL to the act0 package, exactly as SA0's is — so
;;; `mneme/language-act-0/package.lisp` is UNCHANGED by this repair.
;;; ==========================================================================

(defparameter +act0-external-functions+
  '("ACT-FIXTURE-ADAPTER-SYMBOL" "ACT-FIXTURE-ARM" "ACT-FIXTURE-ATTEMPT-NAME"
    "ACT-FIXTURE-CELL-SEGMENTS" "ACT-FIXTURE-FORM" "ACT-FIXTURE-LABEL"
    "ACT-FIXTURE-LANGUAGE-LABEL" "ACT-FIXTURE-P" "ACT-FIXTURE-RUNTIME-SEAT"
    "ACT-RECORD-ACT-ID" "ACT-RECORD-FIXTURE" "ACT-RECORD-P"
    "ACT0-CONDITION-DETAIL" "ACT0-CONDITION-REQUIREMENT-ID"
    "AGREEMENT-GATE" "BIND-OFFICES"
    "BUILD-F1" "BUILD-F2" "BUILD-F3" "BUILD-F4" "BUILD-F5"
    "BUILD-FIXTURE-WORLDS" "BUILD-STORE" "CANONICALIZE-REQUEST"
    "CHECK" "CHECK-CELL-LEXIS" "CHECK-EQ" "CHECK-TEXT-LEXIS"
    "CLASSIFY-ACT-FRAMES" "CORRESPONDENCE-VERDICT"
    "FRAME-EVENT-ID" "FRAME-KIND" "LANE-ENVELOPE"
    "MINT-ACT-IDENTITY" "NOTE" "REQUEST-RECORD" "REQUEST-SHA256-OCTETS"
    "RUN-ACT" "RUN-ALL-ARMS" "VALIDATE-ACT-FIXTURE-TABLE" "W-ENV-PREFLIGHT")
  "The 41 declared external FUNCTIONS of One Act /0.  RUN-ALL-ARMS is the only
one defined in act0-gates.lisp; the other 40 come from act0.lisp.")

(defparameter +act0-external-variables+
  '("*ACT-FIXTURE-TABLE*" "*BOOTSTRAP*" "*CHECKS-FAILED*" "*CHECKS-PASSED*"
    "*MINTING-CONTEXT*" "*RUN-ROOT*" "*STORE*" "*WORLDS*"
    "+ACT-ID-DOMAIN+" "+ACT-STORE-NONCE+" "+LANE-EVENT-NAMESPACE+"
    "+LANE-STEM+" "+RUNTIME-PROCESS-NAME+")
  "The 13 declared external VARIABLES and lane constants (all BOUNDP once the
lane is loaded; the five +NAME+ forms are DEFPARAMETERs, not DEFCONSTANTs,
which is why re-loading a source is lawful rather than DEFCONSTANT-UNEQL).")

(defparameter +act0-external-types+
  '("ACT0-CONDITION" "ACT-AUTHORITY-BINDING-REFUSED" "ACT-BINDING-CONSUMED"
    "ACT-BRIDGE-CONTRACT-VIOLATED" "ACT-DISPATCHER-BINDING-REFUSED"
    "ACT-FIXTURE" "ACT-FIXTURE-TABLE-INVALID" "ACT-FRAME-ORDERING-VIOLATED"
    "ACT-IDENTITY-BRANCH" "ACT-IDENTITY-TAKEN" "ACT-OFFICE-R-TERM-DIVERGENCE"
    "ACT-PROCESS-IDENTITY-DIVERGENCE" "ACT-READBACK-DISAGREEMENT" "ACT-RECORD"
    "ACT-REQUEST-LEXIS-REFUSED" "ACT-REQUEST-SHAPE-REFUSED")
  "The 16 declared external TYPES — 14 lane-local condition types and the two
structure classes ACT-FIXTURE and ACT-RECORD.  Each names a class once
defined, so FIND-CLASS is the recognizability test for all sixteen.")

(defparameter +act0-api-count+ 70
  "41 functions + 13 variables + 16 types.  Asserted, so that shortening a list
without shortening the guard is a failure and not a quiet weakening.")

(defparameter +act0-readiness-carrier+ "ACT0-LANE-READY-CARRIER"
  "The final-source readiness carrier: established by the LAST form of
act0-gates.lisp, the last source the lane loads.")

(defparameter +act0-carrier-value+
  '(:lane "one-act-0" :final-source "act0-gates.lisp" :position :last-form)
  "The carrier's exact value.  Presence of an interned name proves only that
some hand interned it; EQUAL to this proves the lane's own final form ran.")

(defparameter +act0-lane-sources+
  '("mneme/language-act-0/package.lisp"
    "mneme/language-act-0/act0-fixtures.lisp"
    "mneme/language-act-0/act0.lisp"
    "mneme/language-act-0/act0-gates.lisp")
  "One Act /0's four sources IN THEIR DECLARED ORDER.  package.lisp is FIRST
and is re-applied on every repair — the R4.2 'skip package.lisp if the package
exists' shortcut is precisely what made an incomplete package unrepairable.")

;;; R2.3 item 1 — THE PHANTOM EXPORT, CLOSED.
;;;
;;; R2.2 exported #:ACT0-LANE-FILES from LISP-PLUS-SYSTEM and never gave it a
;;; function, variable or class binding: a name in the package's public
;;; interface that answers to nothing.  A phantom export is not cosmetic — it
;;; is a published door with no room behind it, and any reader who trusts the
;;; export list is misled about the system's surface.
;;;
;;; The reader is a FUNCTION, not the DEFPARAMETER itself, for one reason: the
;;; defparameter's value is a mutable quoted list, and handing a caller that
;;; list would let any hand rearrange, shorten or lengthen the lane's declared
;;; LOAD ORDER in place — the ordering the readiness carrier exists to prove
;;; was reached.  Each call therefore re-conses the list AND copies each path
;;; string, so nothing a caller can mutate is shared with the guard.
;;;
;;; ONE ENUMERATION, TWO READERS: this function and LOAD-ACT0-LANE both read
;;; +ACT0-LANE-SOURCES+, so the published list and the loaded list cannot
;;; drift apart.  Witnesses (act0-load-witnesses.lisp, case-invariant battery
;;; SE-1..SE-7) assert :EXTERNAL + FBOUNDP, the exact four paths in order,
;;; EQUAL-but-non-EQ across two calls, and that EVERY LISP-PLUS-SYSTEM
;;; external has a binding of its kind — so no phantom can ship again.
(defun act0-lane-files ()
  "One Act /0's four lane sources, in their declared load order, as a FRESH
list of FRESH strings.  Never returns +ACT0-LANE-SOURCES+ itself, and never
returns a list that shares structure with it: two calls are EQUAL and never EQ."
  (mapcar #'copy-seq +act0-lane-sources+))

(defun act0-api-shortfall ()
  "Return a list of human-readable reasons One Act /0 is NOT ready, or NIL.
One enumeration, two readers: ACT0-API-COMPLETE-P is (NULL (ACT0-API-SHORTFALL))
so the predicate and the failure report can never drift apart."
  (let ((package (find-package '#:lisp-plus-language-act0))
        (missing '()))
    (unless (= +act0-api-count+
               (+ (length +act0-external-functions+)
                  (length +act0-external-variables+)
                  (length +act0-external-types+)))
      (push "the enumerated API lists disagree with +ACT0-API-COUNT+" missing))
    (if (null package)
        (push "the package LISP-PLUS-LANGUAGE-ACT0 does not exist" missing)
        (flet ((probe (name kind test)
                 (multiple-value-bind (symbol status) (find-symbol name package)
                   (cond ((null symbol)
                          (push (format nil "~a ~a: not interned" kind name) missing))
                         ((not (eq status :external))
                          (push (format nil "~a ~a: status ~s, not :EXTERNAL"
                                        kind name status)
                                missing))
                         ((not (funcall test symbol))
                          (push (format nil "~a ~a: external but ~a" kind name
                                        (ecase kind
                                          (:function "not FBOUNDP")
                                          (:variable "not BOUNDP")
                                          (:type "names no class")))
                                missing))))))
          (dolist (n +act0-external-functions+) (probe n :function #'fboundp))
          (dolist (n +act0-external-variables+) (probe n :variable #'boundp))
          (dolist (n +act0-external-types+)
            (probe n :type (lambda (s) (and (find-class s nil) t)))))
        )
    (when package
      (let ((carrier (find-symbol +act0-readiness-carrier+ package)))
        (cond ((null carrier)
               (push (format nil "readiness carrier ~a absent: the load never reached the final form of act0-gates.lisp"
                             +act0-readiness-carrier+)
                     missing))
              ((not (boundp carrier))
               (push (format nil "readiness carrier ~a interned but UNBOUND"
                             +act0-readiness-carrier+)
                     missing))
              ((not (equal (symbol-value carrier) +act0-carrier-value+))
               (push (format nil "readiness carrier ~a holds ~s, not the lane's declared value"
                             +act0-readiness-carrier+ (symbol-value carrier))
                     missing)))))
    (nreverse missing)))

(defun act0-api-complete-p ()
  "True iff One Act /0's whole declared external API is present with the binding
its kind requires, every name :EXTERNAL, and the final-source readiness carrier
established.  Package existence alone NEVER satisfies this."
  (null (act0-api-shortfall)))

(define-condition act0-lane-incomplete (error)
  ((detail :initarg :detail :reader act0-lane-incomplete-detail))
  (:report
   (lambda (c s)
     (format s "~&lisp-plus/act0: LANE LOAD DID NOT COMPLETE.~%~%~
                All four One Act /0 sources were loaded in their declared~%~
                order, and ACT0-API-COMPLETE-P is STILL false afterwards.~%~
                This system therefore refuses to report success: an ASDF~%~
                load that exits 0 over an unusable lane is the R2.2 defect~%~
                (package existence is not implementation readiness), and~%~
                failing closed is the whole repair.~%~%~
                Shortfall:~%~{  * ~a~%~}"
             (act0-lane-incomplete-detail c)))))

(defun load-act0-lane ()
  "Load One Act /0's four sources in their declared order, package.lisp FIRST.
Unconditional by design: this is the REPAIR arm, entered only when the lane is
not already complete."
  (dolist (source +act0-lane-sources+) (lane source)))

(defun ensure-act0-lane ()
  "The One Act /0 load guard.  Load-or-repair, then ASSERT, then fail closed.
The ruling's disjunction — namesake package missing OR the API incomplete — is
one test here: ACT0-API-COMPLETE-P is false whenever the package is absent, by
its first clause, so an absent package and a half-built package take the same
repair path instead of the absent-only skip R4.2 was convicted for."
  (unless (act0-api-complete-p)
    (load-act0-lane)
    (let ((shortfall (act0-api-shortfall)))
      (when shortfall
        (error 'act0-lane-incomplete :detail shortfall))))
  t)

(define-condition unsupported-load-order (error)
  ((detail :initarg :detail :reader unsupported-load-order-detail))
  (:report
   (lambda (c s)
     (format s "~&lisp-plus: UNSUPPORTED LOAD ORDER.~%~a~%~%~
                Canonical Datum /0 is already loaded in this image, but Kernel /0~%~
                is not.  Entering the Stack-A chain now would load Canonical~%~
                Datum /0 a SECOND time, because that chain loads its predecessors~%~
                unconditionally.  That is the exact defect R1 exists to remove, so~%~
                this refuses instead of producing ~~187 redefinition warnings.~%~%~
                Supported instead:~%~
                  * load `lisp-plus' (the umbrella) in a fresh image; or~%~
                  * load `lisp-plus/stack-a' FIRST, then anything else; or~%~
                  * load `lisp-plus/cd0' alone in an image that never loads Stack A.~%~%~
                Root cause, recorded not worked around: mneme/kernel0/load.lisp~%~
                loads Canonical Datum /0 with no `unless (find-package ...)' guard.~%~
                Adding that guard is a semantic-lane source edit, which the~%~
                Integration Baseline milestone is forbidden to make.~%"
             (unsupported-load-order-detail c)))))

(defun require-stack-a-precondition ()
  "Refuse the one composition ordering cannot make clean.
Loading the Stack-A chain while CD/0 is present but Kernel /0 is not would
reload CD/0.  Fail closed, loudly, with the reason."
  (when (and (find-package '#:lisp-plus-cd0)
             (not (find-package '#:lisp-plus-kernel0)))
    (error 'unsupported-load-order
           :detail "  Something loaded Canonical Datum /0 before Stack A in this image.")))

;;; THE SINGLE ORDERED LANE TABLE.
;;;
;;; (guard-package . load-entrypoint).  Order is load-bearing and STACK A IS
;;; FIRST — see the header.  The umbrella walks this list; each subsystem below
;;; loads its own row.  One table, two readers, no chance of them disagreeing.
(defparameter *lane-order*
  '((#:lisp-plus-capability2  . "mneme/capability2/load.lisp")
    (#:lisp-plus-adapter0     . "mneme/adapter0/load.lisp")
    (#:lisp-plus-slice0       . "mneme/language-slice-0/slice0-transmissibility.lisp")
    (#:lisp-plus-slice1       . "mneme/language-slice-1/slice1.lisp")
    (#:lisp-plus-core0        . "mneme/language-core-0/core0.lisp")
    (#:lisp-plus-fake-courier . "mneme/language-core-0/fake-courier.lisp")
    (#:lisp-plus-slice2       . "mneme/language-slice-2/slice2.lisp")
    (#:lisp-plus-surface0     . "mneme/language-surface-0/surface0.lisp")
    (#:lisp-plus-surface1     . "mneme/language-surface-1/surface1.lisp")
    (#:lisp-plus-form0        . "mneme/language-form-0/form0.lisp")
    (#:lisp-plus-form1        . "mneme/language-form-1/form1.lisp")
    (#:lisp-plus-form2        . "mneme/language-form-2/form2.lisp")
    (#:lisp-plus-surface2     . "mneme/language-surface-2/surface2.lisp")
    (#:lisp-plus-vertical0    . "mneme/vertical0/program/load.lisp")
    ;; R4.1/R4.3: the guard for this row is a COMPLETENESS PREDICATE — every
    ;; declared export :EXTERNAL and FBOUNDP, carrier present — not a
    ;; package (see SURFACE-ACCOUNT-API-COMPLETE-P above).  The walker
    ;; dispatches on the :predicate marker; every other row is untouched.
    ((:predicate surface-account-api-complete-p)
     . "mneme/language-surface-account-0/production/load.lisp"))
  "The canonical umbrella load order.  Stack A first; everything after it is
guarded and finds its predecessors already present.")

(defun load-lanes-in-order ()
  "Load every lane of *LANE-ORDER*, in order, each guarded on its own package —
except rows whose guard is a (:PREDICATE fn) marker, which are guarded by the
named completeness predicate instead (R4.1; currently one row, Surface
Account /0).  This is the umbrella's whole implementation."
  (require-stack-a-precondition)
  (dolist (row *lane-order*)
    (let ((guard (car row)))
      (if (and (consp guard) (eq :predicate (first guard)))
          (lane-once-complete (second guard) (cdr row))
          (lane-once guard (cdr row))))))

(in-package #:asdf-user)

;;; --------------------------------------------------------------------------
;;; Canonical Datum /0 — the shared root of both stacks.
;;;
;;; Standalone only.  NOTHING declares a dependency on this system: every lane
;;; that needs CD/0 guard-loads it for itself, and the Stack-A chain loads it
;;; unconditionally.  A `:depends-on` edge here is what caused the duplicate
;;; load this milestone was returned to repair.
;;; --------------------------------------------------------------------------

(defsystem "lisp-plus/cd0"
  :description "Canonical Datum /0 — canonical value and wire substrate (standalone entry)."
  :version "0"
  :perform (load-op (o c)
             (declare (ignore o c))
             (unless (find-package '#:lisp-plus-cd0)
               (uiop:symbol-call '#:lisp-plus-system '#:lane
                                 "canonical-datum/common-lisp/package.lisp")
               (uiop:symbol-call '#:lisp-plus-system '#:lane
                                 "canonical-datum/common-lisp/cd0.lisp"))))

;;; --------------------------------------------------------------------------
;;; Stack A — process / authority.
;;;
;;; ONE system by necessity, not by preference (header note (b)).  Entering at
;;; capability2 loads, in this order and exactly once each:
;;;   canonical-datum -> kernel0 -> journal0 -> capability0
;;;                   -> capability1 -> capability2
;;; kernel0/load.lisp and journal0/load.lisp run their own smoke checks during
;;; this load and exit nonzero on failure; a green partner load is part of the
;;; lanes' own declared floor, and that behaviour is preserved unchanged.
;;;
;;; NO `:depends-on` ON cd0 — the chain loads CD/0 itself.  Declaring the edge
;;; is what produced 187 redefinition warnings before R1.
;;; --------------------------------------------------------------------------

(defsystem "lisp-plus/stack-a"
  :description "Stack A core: kernel0 -> journal0 -> capability0/1/2 (one indivisible load chain)."
  :version "0"
  :perform (load-op (o c)
             (declare (ignore o c))
             (uiop:symbol-call '#:lisp-plus-system '#:require-stack-a-precondition)
             (uiop:symbol-call '#:lisp-plus-system '#:lane-once
                               '#:lisp-plus-capability2
                               "mneme/capability2/load.lisp")))

(defsystem "lisp-plus/adapter0"
  :description "Adapter Protocol /0 — the membrane (deterministic fake boundary only)."
  :version "0"
  :depends-on ("lisp-plus/stack-a")
  :perform (load-op (o c)
             (declare (ignore o c))
             (uiop:symbol-call '#:lisp-plus-system '#:lane-once
                               '#:lisp-plus-adapter0
                               "mneme/adapter0/load.lisp")))

;;; --------------------------------------------------------------------------
;;; Stack B — evidence / claims / syntax.
;;;
;;; Every lane here is guarded and guard-loads its own predecessors, so each
;;; gets a real standalone system.  `:depends-on` edges below are kept ONLY
;;; where the lane genuinely builds on the one below it; none of them is an
;;; ordering trick, and none of them names cd0.
;;; --------------------------------------------------------------------------

(defsystem "lisp-plus/slice0"
  :description "Language Slice /0 — projection and transmissibility."
  :version "0"
  :perform (load-op (o c)
             (declare (ignore o c))
             (uiop:symbol-call '#:lisp-plus-system '#:lane-once
                               '#:lisp-plus-slice0
                               "mneme/language-slice-0/slice0-transmissibility.lisp")))

(defsystem "lisp-plus/slice1"
  :description "Language Slice /1 — extraction seam."
  :version "0"
  :depends-on ("lisp-plus/slice0")
  :perform (load-op (o c)
             (declare (ignore o c))
             (uiop:symbol-call '#:lisp-plus-system '#:lane-once
                               '#:lisp-plus-slice1
                               "mneme/language-slice-1/slice1.lisp")))

(defsystem "lisp-plus/core0"
  :description "Language Core /0 — the derive/perform doors."
  :version "0"
  :depends-on ("lisp-plus/slice1")
  :perform (load-op (o c)
             (declare (ignore o c))
             (uiop:symbol-call '#:lisp-plus-system '#:lane-once
                               '#:lisp-plus-core0
                               "mneme/language-core-0/core0.lisp")
             (uiop:symbol-call '#:lisp-plus-system '#:lane-once
                               '#:lisp-plus-fake-courier
                               "mneme/language-core-0/fake-courier.lisp")))

(defsystem "lisp-plus/slice2"
  :description "Language Slice /2 — evidential promotion."
  :version "0"
  :depends-on ("lisp-plus/core0")
  :perform (load-op (o c)
             (declare (ignore o c))
             (uiop:symbol-call '#:lisp-plus-system '#:lane-once
                               '#:lisp-plus-slice2
                               "mneme/language-slice-2/slice2.lisp")))

(defsystem "lisp-plus/surface0"
  :description "Language Surface /0 — macroexpansion honesty."
  :version "0"
  :depends-on ("lisp-plus/slice2")
  :perform (load-op (o c)
             (declare (ignore o c))
             (uiop:symbol-call '#:lisp-plus-system '#:lane-once
                               '#:lisp-plus-surface0
                               "mneme/language-surface-0/surface0.lisp")))

;;; surface1, form0 and form2 load Canonical Datum /0 AND NOTHING ELSE, by their
;;; own design, and each guard-loads it itself.  They therefore declare no
;;; dependency at all: the `lisp-plus/cd0` edge they used to carry was a false
;;; edge whose only effect was to load CD/0 before Stack A could.

(defsystem "lisp-plus/surface1"
  :description "Language Surface /1 — expansion receipts (guard-loads CD/0 only, by design)."
  :version "0"
  :perform (load-op (o c)
             (declare (ignore o c))
             (uiop:symbol-call '#:lisp-plus-system '#:lane-once
                               '#:lisp-plus-surface1
                               "mneme/language-surface-1/surface1.lisp")))

(defsystem "lisp-plus/form0"
  :description "Language Form /0 — program-holding (guard-loads CD/0 only, by design)."
  :version "0"
  :perform (load-op (o c)
             (declare (ignore o c))
             (uiop:symbol-call '#:lisp-plus-system '#:lane-once
                               '#:lisp-plus-form0
                               "mneme/language-form-0/form0.lisp")))

(defsystem "lisp-plus/form1"
  :description "Language Form /1 — form with supports."
  :version "0"
  :depends-on ("lisp-plus/slice2")
  :perform (load-op (o c)
             (declare (ignore o c))
             (uiop:symbol-call '#:lisp-plus-system '#:lane-once
                               '#:lisp-plus-form1
                               "mneme/language-form-1/form1.lisp")))

(defsystem "lisp-plus/form2"
  :description "Language Form /2 — obligation-bearing form (guard-loads CD/0 only, by design)."
  :version "0"
  :perform (load-op (o c)
             (declare (ignore o c))
             (uiop:symbol-call '#:lisp-plus-system '#:lane-once
                               '#:lisp-plus-form2
                               "mneme/language-form-2/form2.lisp")))

;;; --------------------------------------------------------------------------
;;; The seam and the specimen.
;;;
;;; Surface /2 is the ONLY package that imports from both stacks.  Its contact
;;; with Stack A is a read-only re-expression of a COMPLETED run: seven journal0
;;; symbols and one capability2 symbol.  No derive/perform language operation
;;; executes against the journal-backed process substrate here or anywhere.
;;; --------------------------------------------------------------------------

(defsystem "lisp-plus/surface2"
  :description "Language Surface /2 — read-only re-expression of a completed process result."
  :version "0"
  :depends-on ("lisp-plus/stack-a" "lisp-plus/surface1")
  :perform (load-op (o c)
             (declare (ignore o c))
             (uiop:symbol-call '#:lisp-plus-system '#:lane-once
                               '#:lisp-plus-surface2
                               "mneme/language-surface-2/surface2.lisp")))

;;; --------------------------------------------------------------------------
;;; One Act /0 — one Lisp+ form, one witnessed, capability-mediated act.
;;;
;;; CANDIDATE.  Loading is not adoption, and nothing in this lane is
;;; independent verification (AP0 adoption Rider 2).
;;;
;;; THREE EDGES, and exactly three: stack-a (the journal-backed process and the
;;; two capability offices), core0 (the `perform` door — and, transitively, its
;;; own `lisp-plus/slice1` edge, which is the lane's request canonicalizer and
;;; is NOT in the Stack-A chain), and surface2 (the read-side closing bracket,
;;; consumed through its public exports only, with ZERO edits).
;;;
;;; ⚠ NO EDGE ON `lisp-plus/adapter0`, and its absence is mechanical rather than
;;; declared: Adapter /0 is not in this lane's stack and no artifact of this lane
;;; may claim adapter0 conformance, AP0 conformance, or any membrane property
;;; beyond what Capability /2 itself claims (contract M-2, M-3).
;;; ⚠ NO EDGE ON `lisp-plus/surface-account` — this lane performs; it does not
;;; macroexpand, mints no head, and must not route anything through the
;;; composite (contract S-3, S-4; GATE-12's non-contact instrument).
;;; --------------------------------------------------------------------------

(defsystem "lisp-plus/act0"
  :description "One Act /0 — one governed act, its lane-local journal account, and the read-side agreement gate (candidate)."
  :version "0"
  :depends-on ("lisp-plus/stack-a" "lisp-plus/core0" "lisp-plus/surface2")
  ;; R2.2: PREDICATE-GUARDED, never package-guarded.  ENSURE-ACT0-LANE tests
  ;; ACT0-API-COMPLETE-P (70 declared exports, each :EXTERNAL and bound as its
  ;; kind requires, plus the final-source readiness carrier), loads all four
  ;; sources in declared order when it is false — package.lisp FIRST, so an
  ;; existing incomplete package is REPAIRED rather than skipped — re-asserts
  ;; the predicate, and signals ACT0-LANE-INCOMPLETE if it still does not hold.
  ;; See the One Act /0 readiness block above.  Witnesses:
  ;; mneme/language-act-0/act0-load-witnesses.{lisp,sh}; disease comparator:
  ;; mneme/language-act-0/act0-loader-disease.sh.
  :perform (load-op (o c)
             (declare (ignore o c))
             (uiop:symbol-call '#:lisp-plus-system '#:ensure-act0-lane)))

;;; --------------------------------------------------------------------------
;;; Many Acts /0 — a finite Lisp+ program, as inspectable data, sequencing
;;; MULTIPLE adopted One Act /0 executions.
;;;
;;; CANDIDATE.  Loading is not adoption, and nothing in this lane is
;;; independent verification (AP0 adoption Rider 2).
;;;
;;; ⚠ THIS STANZA IS PURELY ADDITIVE.  It does not enter `*lane-order*', does
;;; not enter the umbrella, and does not enter `verify-release.sh''s executed
;;; gate table or its authorized counts.  Nothing above or below it changed.
;;;
;;; ONE EDGE, and exactly one: `lisp-plus/act0'.  Everything else this lane
;;; touches — journal0, capability0/1/2, core0, kernel0, cd0, surface2 — it
;;; reaches THROUGH One Act /0's own declared stack, through PUBLIC exports
;;; only, with zero edits anywhere.
;;;
;;; GUARD CLASS.  Package-guarded (`lane-once'), which is the guarded class the
;;; header describes — NOT the completeness-checked class One Act /0 and
;;; Surface Account /0 occupy.  That is a deliberate limit of a candidate and
;;; is stated rather than glossed: a load that dies mid-file would leave the
;;; package present and the lane half-built, and this guard would not catch it.
;;; A lane that ever asks for a floor must earn the stronger guard first.
;;; --------------------------------------------------------------------------

(defsystem "lisp-plus/many-acts-0"
  :description "Many Acts /0 — a closed program-authoring surface over the adopted One Act /0 operation (candidate)."
  :version "0"
  :depends-on ("lisp-plus/act0")
  :perform (load-op (o c)
             (declare (ignore o c))
             (uiop:symbol-call '#:lisp-plus-system '#:lane-once
                               '#:lisp-plus-many-acts0
                               "mneme/language-many-acts-0/load.lisp")))

;;; --------------------------------------------------------------------------
;;; One Act /1 — perform across process death (UNADOPTED CANDIDATE).
;;;
;;; Registered 2026-08-20 as the chair's additive act, authorized by Sol's
;;; cold-parcel-review disposition relayed by the owner ("add its
;;; completeness-checked candidate registration rows in the same bounded
;;; session").  Registration moves NO standing: the lane is a candidate —
;;; not audited, not adopted, not frozen — and a loadable system is not a
;;; ruling.
;;;
;;; COMPLETENESS-CHECKED class (the R2.2/R4.1 lesson: package existence is
;;; not implementation readiness) — but unlike act0, the predicate machinery
;;; lives in the LANE'S OWN loader (mneme/language-act-1/load.lisp, package
;;; LISP-PLUS-LANGUAGE-ACT1-LOADER: 104 declared exports each :EXTERNAL and
;;; bound as its kind requires, plus the final-source readiness carrier),
;;; so this stanza carries no duplicate constant tables.  ENSURE-ACT1-LANE
;;; is idempotent and predicate-first; the lane's Stack-A entry is guarded
;;; on LISP-PLUS-CAPABILITY2 exactly as `lisp-plus/stack-a` guards it, so
;;; loading this system after the umbrella does not re-enter the chain.
;;; Deliberately NO edge on lisp-plus/act0 (the lane re-implements four
;;; lexis predicates locally to avoid act0's Surface /2 pull — RETURN §6
;;; fork F-6) and NO *lane-order* row (the act0 precedent: the standalone
;;; door stays canonical; the umbrella's composed load is not widened by a
;;; candidate).
;;; --------------------------------------------------------------------------

(defsystem "lisp-plus/act1"
  :description "One Act /1 — perform across process death: durable refusal, runtime reconciliation, fresh act (candidate)."
  :version "0"
  :depends-on ("lisp-plus/stack-a" "lisp-plus/core0")
  :perform (load-op (o c)
             (declare (ignore o c))
             (unless (find-package '#:lisp-plus-language-act1-loader)
               (uiop:symbol-call '#:lisp-plus-system '#:lane
                                 "mneme/language-act-1/load.lisp"))
             (uiop:symbol-call '#:lisp-plus-language-act1-loader
                               '#:ensure-act1-lane)))

;;; --------------------------------------------------------------------------
;;; MEMORY LAYER /0 — registered 2026-08-21 as the chair's integration-only act,
;;; authorized by Sol's R5 REGISTRATION RULING (archived verbatim at
;;; corpus/voices/received/2026-08-21-sol-ml0-r5-registration-ruling.md):
;;; "R5 is ACCEPTABLE FOR REGISTRATION AS A CANDIDATE … Registration is
;;; authorized.  Adoption and freeze are not."  Registration moves NO standing:
;;; CANDIDATE-NOT-ADOPTED · REGISTERED · stranger audit owed · no independent
;;; verification.  Sol did not independently rerun SBCL; a loadable system is
;;; not a ruling.  This stanza is the exact lane whose bytes equal the accepted
;;; R5 parcel (sha 5742b4f8…); it makes no Memory Layer /0 semantic, source,
;;; specification, specimen or artifact change.
;;;
;;; COMPLETENESS-CHECKED class, the act1 shape exactly: the predicate machinery
;;; lives in the LANE'S OWN loader (mneme/memory-layer-0/load.lisp, package
;;; LISP-PLUS-MEMORY-LAYER0-LOADER: 195 declared exports — 148 functions,
;;; 27 variables, 20 types — each :EXTERNAL and bound as its kind requires, plus
;;; the final-source readiness carrier; the loader asserts the declared total
;;; against the sum of its lists at load).  ENSURE-ML0-LANE is idempotent and
;;; predicate-first.  The lane's substrate entry is One Act /1's own door,
;;; guarded on LISP-PLUS-LANGUAGE-ACT1, so loading this system after
;;; lisp-plus/act1 does not re-enter the Stack-A chain.  NO *lane-order* row
;;; (the act0/act1 precedent: the standalone door stays canonical; the
;;; umbrella's composed load is not widened by a candidate).
;;; --------------------------------------------------------------------------

(defsystem "lisp-plus/ml0"
  :description "Memory Layer /0 — the language's durable account of its own act: write / retrieve / consolidate under ISSUED(evidence, act) does not imply OCCURRED(act) (candidate; registered, not adopted)."
  :version "0"
  :depends-on ("lisp-plus/act1")
  :perform (load-op (o c)
             (declare (ignore o c))
             (unless (find-package '#:lisp-plus-memory-layer0-loader)
               (uiop:symbol-call '#:lisp-plus-system '#:lane
                                 "mneme/memory-layer-0/load.lisp"))
             (uiop:symbol-call '#:lisp-plus-memory-layer0-loader
                               '#:ensure-ml0-lane)))

(defsystem "lisp-plus/vertical0"
  :description "Vertical Specimen /0 program — the durable process path (SIGKILL crash model only)."
  :version "0"
  :depends-on ("lisp-plus/stack-a" "lisp-plus/adapter0")
  :perform (load-op (o c)
             (declare (ignore o c))
             (uiop:symbol-call '#:lisp-plus-system '#:lane-once
                               '#:lisp-plus-vertical0
                               "mneme/vertical0/program/load.lisp")))

;;; --------------------------------------------------------------------------
;;; Surface Account /0 — the accepted R3.3.3 identity mechanism, production
;;; form (R4 candidate).
;;;
;;; CD/0-only by design: its loader guard-loads Canonical Datum /0 for
;;; itself, so — per the false-edge law in the header — it declares NO
;;; `:depends-on`.  Under the umbrella it is the LAST lane-order row, so
;;; Stack A has already loaded CD/0 exactly once and the guard finds it
;;; present.  Loading gathers the image's once-only identity state (sixteen
;;; OS-random epoch octets); a repeated load observes the established state.
;;; --------------------------------------------------------------------------

(defsystem "lisp-plus/surface-account"
  :description "Surface Account /0 — once-only image identity, epoch, and performance-identifier allocator (guard-loads CD/0 only, by design)."
  :version "0"
  :perform (load-op (o c)
             (declare (ignore o c))
             ;; R4.1/R4.3: predicate-guarded (nine exports each :EXTERNAL
             ;; and FBOUNDP, identity carrier present), never
             ;; package-guarded — see the header note on this lane.
             (uiop:symbol-call '#:lisp-plus-system '#:lane-once-complete
                               (uiop:find-symbol* '#:surface-account-api-complete-p
                                                  '#:lisp-plus-system)
                               "mneme/language-surface-account-0/production/load.lisp")))

;;; --------------------------------------------------------------------------
;;; The umbrella.
;;;
;;; It walks `*lane-order*` ITSELF and declares no `:depends-on`.  ASDF's
;;; planner may order independent systems freely; a dependency list printed in
;;; the desired order is not a guarantee that it executes in that order, and on
;;; this tree the wrong order is not a cosmetic problem — it is either 187
;;; redefinition warnings or a hard DEFCONSTANT-UNEQL error.  Here the order is
;;; code, in one table, exhibited rather than hoped for.
;;; --------------------------------------------------------------------------

(defsystem "lisp-plus"
  :description "Lisp+ — the current construction, loadable as one thing. A load container, not an adoption."
  :long-description "Loads the twenty principal Lisp+ packages into one image on
SBCL 2.4.6/Linux, in one explicit order, with Canonical Datum /0 loaded exactly
once.  Loading is not adoption, not conformance, and not validation of any kind.
See mneme/integration-baseline-0/CLAIM-CEILING-0.md."
  :version "0"
  :perform (load-op (o c)
             (declare (ignore o c))
             (uiop:symbol-call '#:lisp-plus-system '#:load-lanes-in-order))
  :in-order-to ((test-op (test-op "lisp-plus/test"))))

;;; --------------------------------------------------------------------------
;;; The test system: an ASDF door onto the canonical release floor.
;;;
;;; `(asdf:test-system "lisp-plus")` runs mneme/verify-release.sh, which is the
;;; authority.  This system adds no gate, changes no count, and asserts nothing
;;; the floor does not print itself.
;;; --------------------------------------------------------------------------

(defsystem "lisp-plus/test"
  :description "Runs the canonical aggregate release floor (mneme/verify-release.sh)."
  :version "0"
  :perform (test-op (o c)
             (declare (ignore o c))
             (let* ((root (symbol-value
                           (uiop:find-symbol* '#:*root* '#:lisp-plus-system)))
                    (floor (merge-pathnames "mneme/verify-release.sh" root)))
               (uiop:run-program (list "bash" (namestring floor))
                                 :directory root
                                 :output t :error-output t))))
