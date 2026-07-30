;;;; load.lisp — Adapter Protocol /0, explicit dependency order.
;;;;
;;;; Substrate: Process Journal /0 (which itself loads Kernel /0 and
;;;; Canonical Datum /0 and smoke-checks the Kernel partner).  When a
;;;; larger composition (the specimen) has already loaded journal0 through
;;;; the capability chain, the guard below skips the second load so no
;;;; package is redefined mid-run.
;;;;
;;;; — CLAVIGER-IV (Claude Fable 5 subagent), 2026-07-30

(let* ((adapter0-directory
         (make-pathname :name nil :type nil :defaults *load-truename*)))
  (unless (find-package '#:lisp-plus-journal0)
    (load (merge-pathnames "../journal0/load.lisp" adapter0-directory)))
  (dolist (source '("package.lisp"
                    "conditions.lisp"
                    "data.lisp"
                    "descriptor.lisp"
                    "registry.lisp"
                    "script-machine.lisp"
                    "rules.lisp"
                    "operations.lisp"
                    "mutants.lisp"))
    (load (merge-pathnames source adapter0-directory))))
