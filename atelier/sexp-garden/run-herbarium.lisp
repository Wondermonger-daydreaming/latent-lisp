;;;; run-herbarium.lisp — rerun the synthetic fidelity world, then classify
;;;; every crossover using glider-herbarium.lisp's independent axes.
;;;;
;;;; run.lisp performs the committed evolution and leaves *LEDGER* populated.

(load (merge-pathnames "run.lisp" *load-pathname*))

(defvar *run-herbarium-self-tests* nil)
(load (merge-pathnames "glider-herbarium.lisp" *load-pathname*))

(defun exact-recovery-gate (org)
  (< (org-err org) 1d-6))

(report-glider-herbarium
 *data*
 :gate #'exact-recovery-gate)
