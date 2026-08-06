;;;; load.lisp — Surface Account /0 production loader (the lane's direct
;;;; entry, house shape of the other governed lanes).
;;;;
;;;; Loads exactly three things, in order, each relative to THIS file's own
;;;; location (checkout- and cwd-independent; no absolute path anywhere):
;;;;
;;;;   1. Canonical Datum /0     — guard-loaded (the lane is CD/0-only; no
;;;;                               other provider is touched);
;;;;   2. production/package.lisp        — the package, before the code;
;;;;   3. production/surface-account.lisp — the implementation, whose
;;;;                               once-only initialization runs at load
;;;;                               time, MID-FILE (oracle-faithful placement;
;;;;                               see the guard note below).
;;;;
;;;; THE READINESS GUARD IS EXTERNAL-API COMPLETENESS: EVERY DECLARED NAME
;;;; MUST BE PRESENT WITH FIND-SYMBOL STATUS :EXTERNAL **AND** FBOUNDP, AND
;;;; THE IDENTITY CARRIER SYMBOL MUST BE PRESENT (R4.3, closing the owner's
;;;; R4-READINESS-GUARD-ACCEPTS-NONEXTERNAL-API counterexample; R4.1 had
;;;; closed the package-existence half, STRANGER's
;;;; R4-PRODUCTION-HALF-LOAD-CERTIFIED-BY-THE-PACKAGE-GUARD, but its
;;;; predicate discarded FIND-SYMBOL's second value, so nine INTERNAL fbound
;;;; dummies in a pre-created namesake package satisfied it: the umbrella
;;;; reported success with zero public exports, no identity carrier, and the
;;;; implementation never loaded).  All nine exports are functions, so
;;;; FBOUNDP is the right boundness test for every name; no export is a
;;;; variable, so no BOUNDP clause is needed (the design ledger §2 census).
;;;;
;;;; The initialization form sits mid-file in the implementation — line 1059
;;;; of 1217, column-0 top-level form 43 of 57 at the R4.3 freeze; the
;;;; ALWAYS-CURRENT coordinate is machine-derived and printed in the
;;;; implementation's own header by R4/extract-production.py, which is the
;;;; authority (a hand-written coordinate here went stale once, R4.2) —
;;;; carried verbatim from the accepted oracle, so a first load that fails
;;;; AT initialization leaves the package present with the five
;;;; later-defined exports unbound.  The guard below therefore has three
;;;; jobs, and the load path fails CLOSED on all of them:
;;;;
;;;;   * a lawful COMPLETE load passes it exactly as before (fresh image:
;;;;     package absent -> both files load; repeated lawful load: all nine
;;;;     external and bound, carrier present -> no-op, no redefinition);
;;;;   * an INCOMPLETE lane — half-loaded, pre-created with internal or
;;;;     partial namesakes, or an empty namesake package — fails it, and the
;;;;     loader REPAIRS rather than skips: package.lisp is applied FIRST
;;;;     (whether the package is absent OR already present — DEFPACKAGE
;;;;     against an existing package finds the existing namesake symbols,
;;;;     PRESERVING their identity, and exports them; re-applying package.lisp
;;;;     to an incomplete package is the repair instrument, and the R4.2
;;;;     absent-only skip is exactly what made an incomplete package
;;;;     unrepairable), then the implementation is loaded, whose DEFUNs
;;;;     rebind every export to the real mechanism — in a terminally-failed
;;;;     image this re-signals the mechanism's own definitive
;;;;     SURFACE-ACCOUNT/0: failure (never a silent success);
;;;;   * AFTER the repair loads, the SAME predicate is asserted again and
;;;;     the loader signals if it still does not hold — exiting this load
;;;;     path normally while any export is missing/non-external/unbound or
;;;;     the carrier symbol is absent is impossible (the owner's R4.3
;;;;     backstop requirement).
;;;;
;;;; The umbrella row applies the same completeness predicate
;;;; (LISP-PLUS-SYSTEM:SURFACE-ACCOUNT-API-COMPLETE-P in lisp-plus.asd).
;;;; The two are ONE predicate in substance: their bodies are kept
;;;; token-identical between the SA0-COMPLETENESS-PREDICATE-CORE markers,
;;;; enforced by the static agreement gate GG-5 in
;;;; production/surface-account-graph-gate.sh (GG-6 further asserts the
;;;; shared core requires :EXTERNAL, FBOUNDP, and the carrier); the
;;;; selftest's export census keeps the nine-name list honest.
;;;;
;;;; Nothing here reaches probes/, transcripts, or any adjudication file —
;;;; enforced by production/surface-account-graph-gate.sh.

(let* ((here (make-pathname :name nil :type nil
                            :defaults (or *load-truename* *load-pathname*)))
       (lane-root (merge-pathnames "../../../" here)) ; -> experiments/latent-lisp/
       (api-complete-p
         (lambda ()
           ;; SA0-COMPLETENESS-PREDICATE-CORE-BEGIN (GG-5: this region is
           ;; token-identical to the copy in lisp-plus.asd — one predicate
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
           )))
  (unless (find-package '#:lisp-plus-cd0)
    (load (merge-pathnames "canonical-datum/common-lisp/package.lisp" lane-root))
    (load (merge-pathnames "canonical-datum/common-lisp/cd0.lisp" lane-root)))
  (unless (funcall api-complete-p)
    ;; REPAIR, not absent-only (R4.3): package.lisp is applied whether the
    ;; package is absent or present-but-incomplete.  DEFPACKAGE on an
    ;; existing package finds/creates the nine symbols (identity preserved)
    ;; and exports them; any genuine name conflict (a package USING this one
    ;; with a clashing symbol) signals and propagates — fail closed.
    (load (merge-pathnames "package.lisp" here))
    (load (merge-pathnames "surface-account.lisp" here))
    ;; The post-load assertion (R4.3): the backstop.  Leaving this load path
    ;; normally with an incomplete public API or an absent carrier must be
    ;; impossible.  Loading the implementation rebinds every export
    ;; unconditionally (all nine are top-level DEFUNs there), so the one way
    ;; to reach this point incomplete is a damaged implementation — refuse.
    (unless (funcall api-complete-p)
      (error "SURFACE-ACCOUNT/0: the production loader completed its load ~
              path but the post-load completeness assertion FAILED — the ~
              public API is not nine external fbound symbols with the ~
              identity carrier present.  The lane is NOT loaded; refusing ~
              to certify it."))))
