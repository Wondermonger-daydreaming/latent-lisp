;;;; probe-escape-unwrapped.lisp — CHAIR probe F: a construct's own grammar
;;;; refusal escapes perform-expansion UNWRAPPED, and nothing is minted.
;;;; (package.lisp: "Surface /0's condition escapes to the caller in Surface
;;;; /0's own voice, unwrapped and unreclassified.")

(defparameter *here* (or *load-truename* *default-pathname-defaults*))
(handler-bind ((style-warning #'muffle-warning))
  (load (merge-pathnames "../../extract/target/tree/mneme/language-surface-1/surface1.lisp" *here*))
  (load (merge-pathnames "../../extract/target/tree/mneme/language-surface-0/surface0.lisp" *here*)))

(defpackage #:chair-escape (:use #:cl #:lisp-plus-surface1))
(in-package #:chair-escape)

(defun say (fmt &rest args) (format t "~&~?~%" fmt args) (finish-output))
(defun tag (n) (lisp-plus-cd0:make-identifier-datum '("chair-audit") (list n)))

;; malformed for Surface /0's grammar (trailing bare 2 is no clause), but
;; perfectly representable for Surface /1's term grammar — so Door 1 accepts it
(defparameter *src* (list (find-symbol "DEFINE-JUDGMENT-SCHEMA" "LISP-PLUS-SURFACE0")
                          (intern "CHAIR-BAD" "CHAIR-ESCAPE")
                          2))

(let ((req (request-expansion *src* :macroexpand-1 (tag "F"))))
  (say "F0: Door 1 accepted the malformed-for-surface0 form (request minted): ~a"
       (expansion-request-p req))
  (handler-case
      (multiple-value-bind (receipt expanded occurrence) (perform-expansion req)
        (declare (ignore expanded occurrence))
        (say "F1 FAIL: a receipt was minted for a form surface0 refuses: ~a" receipt))
    (expansion-refused (c)
      (say "F1 FAIL: surface0's refusal was RECLASSIFIED into a Surface /1 refusal: ~s"
           (expansion-refusal-code (expansion-condition-refusal c))))
    (error (c)
      (say "F1: escaped condition type = ~a" (type-of c))
      (say "F1: is it surface0's own condition class? ~a"
           (typep c (find-symbol "SURFACE-SYNTAX-REFUSED" "LISP-PLUS-SURFACE0")))
      (say "F1 verdict: ESCAPED UNWRAPPED in the neighbour's voice — nothing minted by Surface /1"))))

(sb-ext:exit :code 0)
