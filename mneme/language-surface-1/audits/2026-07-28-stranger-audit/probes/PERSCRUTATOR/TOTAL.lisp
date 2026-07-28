(load "preamble.lisp")
(in-package #:probe)
(defun tag () (cd0 make-identifier-datum '("audit") '("total")))
(defun try (label form)
  (handler-case
      (multiple-value-bind (rq rf) (s1 try-request-expansion form :macroexpand-1 (tag))
        (if rf
            (format t "~&~A: REFUSED code=~S upstream=~S~%" label
                    (s1 expansion-refusal-code rf) (s1 expansion-refusal-upstream-code rf))
            (format t "~&~A: REQUEST MINTED (no refusal) req-p=~A~%" label (s1 expansion-request-p rq))))
    (error (e) (format t "~&~A: *** UNCAUGHT HOST ERROR: ~A: ~A~%" label (type-of e) e))))

;; head must be a symbol; put weird types as ARGS so encode-term meets them
(try "character-arg"  (list 'cl-user::foo #\A))
(try "float-arg"      (list 'cl-user::foo 3.14))
(try "ratio-arg"      (list 'cl-user::foo 1/3))
(try "complex-arg"    (list 'cl-user::foo #C(1 2)))
(try "vector-arg"     (list 'cl-user::foo #(1 2 3)))
(try "pathname-arg"   (list 'cl-user::foo #p"/tmp/x"))
(try "hashtable-arg"  (list 'cl-user::foo (make-hash-table)))
(try "function-arg"   (list 'cl-user::foo #'car))
(try "dotted-list"    (cons 'cl-user::foo 5))
(try "keyword-arg"    (list 'cl-user::foo :a-keyword))
(try "uninterned-arg" (list 'cl-user::foo (make-symbol "GENSYM")))
;; empty-name symbol as arg
(let ((empty (intern "" '#:audit-empty)))
  (try "empty-name-sym" (list 'cl-user::foo empty)))
;; nested proper list, fine
(try "nested-list"    (list 'cl-user::foo (list 1 "s" 'cl-user::b)))
;; head not a symbol
(try "head-not-symbol" (list 5 6))
;; source not a cons
(try "atom-source"    42)
