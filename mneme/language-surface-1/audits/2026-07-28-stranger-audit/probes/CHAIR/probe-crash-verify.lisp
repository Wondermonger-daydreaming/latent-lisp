;;;; probe-crash-verify.lisp — CHAIR verification of PERSCRUTATOR's novel crash
;;;; finding: vector/complex/array arguments crash the PUBLIC API (including the
;;;; non-signalling twin) with an uncaught host TYPE-ERROR instead of the
;;;; designed :SOURCE-TERM-UNREPRESENTABLE refusal.

(handler-bind ((style-warning #'muffle-warning))
  (load (merge-pathnames "../../extract/target/tree/mneme/language-surface-1/surface1.lisp"
                         *load-truename*)))

(defpackage #:chair-crash (:use #:cl #:lisp-plus-surface1))
(in-package #:chair-crash)

(defun say (fmt &rest args) (format t "~&~?~%" fmt args) (finish-output))
(defun tag () (lisp-plus-cd0:make-identifier-datum '("chair") '("crash")))

(dolist (spec (list (list "vector arg"  (list 'f (vector 1 2 3)))
                    (list "complex arg" (list 'f (complex 1 2)))
                    (list "2d array arg" (list 'f (make-array '(2 2))))
                    (list "character arg (control — should refuse cleanly)"
                          (list 'f #\a))))
  (destructuring-bind (label form) spec
    (handler-case
        (multiple-value-bind (req refusal)
            (try-request-expansion form :macroexpand-1 (tag))
          (declare (ignore req))
          (say "~a: DESIGNED REFUSAL code=~s upstream=~s" label
               (and refusal (expansion-refusal-code refusal))
               (and refusal (expansion-refusal-upstream-code refusal))))
      (expansion-refused (c)
        (say "~a: signalling refusal ~s" label
             (expansion-refusal-code (expansion-condition-refusal c))))
      (type-error (c)
        (say "~a: *** UNCAUGHT HOST TYPE-ERROR through TRY-REQUEST-EXPANSION: ~a"
             label c)))))

(sb-ext:exit :code 0)
