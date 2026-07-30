;;;; load.lisp — Vertical Specimen /0, explicit dependency order.
;;;;
;;;; Substrates: Capability /2 (which loads /1, /0, Journal /0, CD/0, and
;;;; the smoke-checked Kernel /0 partner) and Adapter /0 (guarded against
;;;; a second journal0 load).  Then this lane's LIBRARY modules only —
;;;; campaign.lisp (the orchestration entry) is deliberately NOT loaded
;;;; here, so the census procedure remains loadable without the
;;;; orchestration module (contract §11).
;;;;
;;;; — FABER-MORTIS (Claude Fable 5 subagent), 2026-07-30

(let ((vertical0-directory
        (make-pathname :name nil :type nil :defaults *load-truename*)))
  (unless (find-package '#:lisp-plus-capability2)
    (load (merge-pathnames "../../capability2/load.lisp"
                           vertical0-directory)))
  (unless (find-package '#:lisp-plus-adapter0)
    (load (merge-pathnames "../../adapter0/load.lisp" vertical0-directory)))
  (dolist (source '("package.lisp"
                    "config-reader.lisp"
                    "records.lisp"
                    "evidence.lisp"
                    "budget.lisp"
                    "recovery-projection.lisp"
                    "interpretation.lisp"
                    "census.lisp"))
    (load (merge-pathnames source vertical0-directory))))
