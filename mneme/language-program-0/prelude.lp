;; prelude.lp — PROGRAM /0's library, written IN Lisp+ and evaluated into the
;; root frame before any program runs. Every program can read these names and
;; can shadow them locally; none can redefine them (E-REDEFINE is per frame).
;;
;; These are library functions, not primitives (the commission: "implement
;; those as library functions wherever the language permits"). They recurse,
;; so they are bounded by the run's *depth-limit*: a list longer than the depth
;; ceiling is refused with E-BUDGET, not processed. That is the policy, stated.

;; ---- traversal --------------------------------------------------------------

(define (map f xs)
  (if (null? xs)
      ()
      (cons (f (car xs)) (map f (cdr xs)))))

(define (filter keep? xs)
  (cond ((null? xs) ())
        ((keep? (car xs)) (cons (car xs) (filter keep? (cdr xs))))
        (else (filter keep? (cdr xs)))))

(define (fold f acc xs)
  (if (null? xs)
      acc
      (fold f (f acc (car xs)) (cdr xs))))

(define (fold-right f acc xs)
  (if (null? xs)
      acc
      (f (car xs) (fold-right f acc (cdr xs)))))

(define (for-each f xs)
  (if (null? xs)
      ()
      (begin (f (car xs)) (for-each f (cdr xs)))))

;; ---- construction -----------------------------------------------------------

(define (range from to)
  (if (>= from to)
      ()
      (cons from (range (+ from 1) to))))

(define (iota n) (range 0 n))

(define (repeat n x)
  (if (<= n 0) () (cons x (repeat (- n 1) x))))

;; ---- reductions -------------------------------------------------------------

(define (sum xs) (fold + 0 xs))
(define (product xs) (fold * 1 xs))

(define (any? p xs)
  (cond ((null? xs) false)
        ((p (car xs)) true)
        (else (any? p (cdr xs)))))

(define (all? p xs)
  (cond ((null? xs) true)
        ((p (car xs)) (all? p (cdr xs)))
        (else false)))

(define (count-if p xs)
  (fold (lambda (n x) (if (p x) (+ n 1) n)) 0 xs))

;; ---- combinators ------------------------------------------------------------

(define (compose f g) (lambda (x) (f (g x))))
(define (identity x) x)
(define (constantly x) (lambda (ignored) x))

;; ---- small numerics ---------------------------------------------------------

(define (square x) (* x x))
(define (even? n) (= (mod n 2) 0))
(define (odd? n) (not (even? n)))
(define (zero? n) (= n 0))
(define (positive? n) (> n 0))
(define (negative? n) (< n 0))

;; ---- list utilities ---------------------------------------------------------

(define (nth n xs)
  (if (= n 0) (car xs) (nth (- n 1) (cdr xs))))

(define (take n xs)
  (if (or (<= n 0) (null? xs)) () (cons (car xs) (take (- n 1) (cdr xs)))))

(define (drop n xs)
  (if (or (<= n 0) (null? xs)) xs (drop (- n 1) (cdr xs))))

(define (last xs)
  (if (null? (cdr xs)) (car xs) (last (cdr xs))))

(define (zip xs ys)
  (if (or (null? xs) (null? ys))
      ()
      (cons (list (car xs) (car ys)) (zip (cdr xs) (cdr ys)))))
