;;; readme-specimen.lisp — the front-page specimen. Run from the repository root:
;;;   sbcl --script mneme/readme-specimen.lisp
;;; A fluent "I am 80% sure" offered as a single scalar is refused by Kernel /0,
;;; with the requirement id and the law carried in the condition itself.

(load "mneme/kernel0/load.lisp")
(handler-case
    (lisp-plus-kernel0:make-determinacy :mode :determinate :confidence 0.8)
  (lisp-plus-kernel0:global-uncertainty-scalar-rejected (c)
    (format t "REFUSED ~a = ~a~%  requirement: ~a~%  law: ~a~%"
            (lisp-plus-kernel0:kernel0-condition-offending-field c)
            (lisp-plus-kernel0:kernel0-condition-offending-value c)
            (lisp-plus-kernel0:kernel0-condition-requirement-id c)
            (lisp-plus-kernel0:kernel0-condition-failed-invariant c))))
(print (lisp-plus-kernel0:make-determinacy :mode :determinate))
