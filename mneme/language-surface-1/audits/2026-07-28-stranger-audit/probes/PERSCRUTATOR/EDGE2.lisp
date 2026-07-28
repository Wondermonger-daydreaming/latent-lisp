(load "preamble.lisp")
(in-package #:probe)
(defun tag (&rest p) (cd0 make-identifier-datum '("audit") (or p '("e"))))

;; surface0 grammar refusal: valid arg count but malformed content (odd keyword plist / bad clause)
(format t "~&-- surface0 grammar refusal escape --~%")
(let ((bad '(lisp-plus-surface0:define-admission-contract cl-user::*bad*
             :contract-id 42 :contract-version 1
             :accepted-clauses ((:verified-judged-claim))
             :proposition-relation :exact-normalized-equality
             :receiver-accessibility :required
             :retain (:contract-snapshot))))
  (handler-case
      (let ((rq (s1 request-expansion bad :macroexpand-1 (tag "s0"))))
        (handler-case (progn (s1 perform-expansion rq) (format t "minted (unexpected)~%"))
          (lisp-plus-surface0:surface-syntax-refused (c)
            (format t "GOOD: surface0 condition escaped unwrapped: reason=~S~%"
                    (lisp-plus-surface0:surface-syntax-refused-reason c)))
          (lisp-plus-surface1:expansion-refused (c)
            (format t "BAD: surface1 swallowed it as ~S~%"
                    (s1 expansion-refusal-code (s1 expansion-condition-refusal c))))
          (error (e) (format t "other escape ~S~%" (type-of e)))))
    (error (e) (format t "door1 err ~S~%" (type-of e)))))

;; integer round-trip injectivity: bignums, negatives, zero
(format t "~%-- integer round-trip --~%")
(dolist (n (list 0 -1 (expt 2 300) (- (expt 10 100)) most-positive-fixnum))
  (let* ((d (s1 encode-term n)) (back (s1 decode-term d)))
    (format t "int ~A: back=~A eq=~A reencode-eq=~A~%" n back (eql n back)
            (cd0 equal-datum d (s1 encode-term back)))))

;; string with fill pointer: what gets stored vs what the receipt names
(format t "~%-- fill-pointer string --~%")
(let* ((fp (make-array 5 :element-type 'character :fill-pointer 3 :initial-contents '(#\a #\b #\c #\d #\e)))
       (d (s1 encode-term fp)) (back (s1 decode-term d)))
  (format t "fp-string active=~S stored-decodes-to=~S reencode-eq=~A~%"
          fp back (cd0 equal-datum d (s1 encode-term back))))
