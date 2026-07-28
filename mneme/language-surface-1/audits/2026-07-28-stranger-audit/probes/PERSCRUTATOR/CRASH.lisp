(load "preamble.lisp")
(in-package #:probe)
(defun tag () (cd0 make-identifier-datum '("audit") '("crash")))
(format t "~&type-of #C(1 2) = ~S  (consp it)=~S~%" (type-of #C(1 2)) (consp (type-of #C(1 2))))
(format t "type-of #(1 2 3) = ~S~%" (type-of #(1 2 3)))

;; Public ENCODE-TERM crashes directly:
(format t "~%-- public ENCODE-TERM on a complex --~%")
(handler-case (s1 encode-term #C(1 2))
  (lisp-plus-surface1:expansion-refused (c) (format t "clean refusal~%"))
  (error (e) (format t "UNCAUGHT ~S: ~A~%" (type-of e) e)))

;; Public request-expansion (Door 1) crashes:
(format t "~%-- Door 1 with a vector arg --~%")
(handler-case (s1 try-request-expansion (list 'cl-user::foo #(1 2 3)) :macroexpand-1 (tag))
  (lisp-plus-surface1:expansion-refused (c) (format t "clean expansion-refused~%"))
  (error (e) (format t "UNCAUGHT ~S: ~A~%" (type-of e) e)))

;; Does the crash happen at ENCODE-TERM level too via a bare adjustable array?
(format t "~%-- Door 1 with a 2D array arg --~%")
(handler-case (s1 try-request-expansion (list 'cl-user::foo (make-array '(2 2))) :macroexpand-1 (tag))
  (error (e) (format t "UNCAUGHT ~S: ~A~%" (type-of e) e)))
