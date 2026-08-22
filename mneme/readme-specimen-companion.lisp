;;; readme-specimen-companion.lisp — GPT Sol asked (2026-08-21) for the companion that
;;; rules out the float as the cause of the refusal. Run from the repository root:
;;;   sbcl --script mneme/readme-specimen-companion.lisp

(load "mneme/kernel0/load.lisp")
(defun try (&rest args)
  (handler-case (progn (apply #'lisp-plus-kernel0:make-determinacy args) (format t "ACCEPTED ~s~%" args))
    (lisp-plus-kernel0:global-uncertainty-scalar-rejected (c)
      (format t "REFUSED ~a = ~s  [~a]~%" (lisp-plus-kernel0:kernel0-condition-offending-field c)
              (lisp-plus-kernel0:kernel0-condition-offending-value c) (lisp-plus-kernel0:kernel0-condition-requirement-id c)))
    (lisp-plus-kernel0:kernel0-condition (c)
      (format t "OTHER ~a [~a]~%" (type-of c) (lisp-plus-kernel0:kernel0-condition-requirement-id c)))))
(try :mode :determinate :confidence 4/5)
(try :mode :determinate :confidence 0.8)
(try :mode :determinate :probability 1)
(try :mode :determinate :uncertainty "low")
(try :mode :exact)
(try :mode :determinate)
