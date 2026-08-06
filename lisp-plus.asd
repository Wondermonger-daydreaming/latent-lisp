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
           #:require-stack-a-precondition #:unsupported-load-order))

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
