;; higher-order.lp — program 2: list processing that passes functions as
;; arguments and exercises lexical capture.
;;
;;   bash mneme/language-program-0/lisp-plus-run.sh mneme/language-program-0/programs/higher-order.lp

;; A function that returns a function. `n` is captured by the returned lambda
;; and stays bound after make-adder's frame is gone.
(define (make-adder n)
  (lambda (x) (+ x n)))

(define add5 (make-adder 5))
(define add10 (make-adder 10))

(print "add5 3            =" (add5 3))
(print "add10 3           =" (add10 3))
(print "both adders       =" (map (lambda (f) (f 1)) (list add5 add10)))

;; Shadowing: the inner `n` hides the outer one only inside its own frame.
(define n 100)
(define (shadow-test n) (+ n 1))
(print "shadowed n        =" (shadow-test 1))
(print "outer n intact    =" n)

;; Capture is by the DEFINING environment, not the calling one: `scale` sees
;; the `k` of make-scaler, not any `k` at the call site.
(define (make-scaler k) (lambda (x) (* k x)))
(define (apply-with-k f)
  (let ((k 1000))        ; a different k, in the caller's frame
    (f 2)))
(print "lexical, not dynamic =" (apply-with-k (make-scaler 3)))   ; 6, not 2000

;; Higher-order pipeline over a list: keep the evens, square them, sum them.
(define numbers (range 1 11))
(define (pipeline xs)
  (sum (map square (filter even? xs))))
(print "evens squared sum =" (pipeline numbers))

;; Composition as a value; a local helper defined inside a body.
(define (twice f) (compose f f))
(define (describe xs)
  (define (fmt x) (list x (if (even? x) (quote even) (quote odd))))
  (map fmt xs))

(print "twice add5 on 0   =" ((twice add5) 0))
(print "described         =" (describe (take 4 numbers)))

;; The final value: fold-right builds a list back up with a captured separator.
(define (intersperse sep xs)
  (fold-right (lambda (x acc) (if (null? acc) (list x) (cons x (cons sep acc)))) () xs))

(intersperse "-" (map (twice square) (list 1 2 3)))
