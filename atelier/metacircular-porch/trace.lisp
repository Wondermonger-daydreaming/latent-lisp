;;;; trace.lisp — Movement 2: the instrumented porch.  Introspection that is REAL.
;;;;
;;;; The evaluator's self-report is a LOG, not a claim.  Every line below was emitted
;;;; by the evaluator while it ran; every summary statistic is computed from the same
;;;; event stream, so "what eval attended to" is checkable, not testified.  No glass.
;;;;
;;;; Run:  ~/.local/bin/sbcl --script trace.lisp

(defvar cl-user::*porch-library* t)
(load (merge-pathnames "porch.lisp" (or *load-pathname* *load-truename*)))
(in-package :porch)

(defun run-traced (program final)
  "Run PROGRAM (defines) silently, then evaluate FINAL with tracing on.
   Returns (values result event-list) where events are (depth action form)."
  (let ((env (make-global-env)))
    (run program env)
    (let ((*trace-events* (list nil)))
      (let ((*trace-stream* *standard-output*))
        (format t "~&--- evaluation transcript: ~s ---~%" final)
        (let ((result (mc-eval final env)))
          (format t "--- result: ~s ---~%" result)
          (values result (nreverse (car *trace-events*))))))))

;;; ---- The weather of evaluation: a small recursion, fully traced ----
(multiple-value-bind (result events)
    (run-traced '((define (fib n) (if (< n 2) n (+ (fib (- n 1)) (fib (- n 2))))))
                '(fib 4))

  ;; Summary statistics — all derived from the SAME event stream printed above.
  (format t "~%=== SUMMARY STATISTICS (computed from the trace, not asserted) ===~%")
  (format t "  result of (fib 4)          : ~s~%" result)
  (format t "  total trace events         : ~:d~%" (length events))

  (let ((max-depth (reduce #'max events :key #'first :initial-value 0)))
    (format t "  deepest evaluation depth   : ~d~%" max-depth))

  ;; how many times each subform-shape was EVAL'd
  (let ((eval-events (remove "EVAL" events :key #'second :test-not #'string=)))
    (format t "  number of EVAL steps       : ~:d~%" (length eval-events)))

  ;; most-visited variable (VAR-> events)
  (let ((var-events (remove "VAR->" events :key #'second :test-not #'string=))
        (counts (make-hash-table)))
    (dolist (e var-events)
      (incf (gethash (first (third e)) counts 0)))
    (let ((ranked (sort (loop for k being the hash-keys of counts using (hash-value v)
                              collect (cons k v))
                        #'> :key #'cdr)))
      (format t "  variable resolutions       : ~:d~%" (length var-events))
      (format t "  most-visited variables     :")
      (dolist (kv (subseq ranked 0 (min 4 (length ranked))))
        (format t " ~a×~d" (car kv) (cdr kv)))
      (terpri)))

  ;; how many times each recursive CALL to fib happened (APPLY of a closure)
  (let ((apply-events (remove "APPLY" events :key #'second :test-not #'string=)))
    (format t "  APPLY steps (calls)        : ~:d~%" (length apply-events))
    (format t "  (fib 4) recomputes overlapping subproblems — the trace SHOWS the~%")
    (format t "   exponential recursion the plain result value hides.~%")))

(format t "~%=== the porch watched itself ===~%")
