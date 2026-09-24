;; sum-of-squares.lp — program 1: a numerical program built from reusable functions.
;;
;;   bash mneme/language-program-0/lisp-plus-run.sh mneme/language-program-0/programs/sum-of-squares.lp
;;
;; `square`, `range`, `map`, `sum` and `fold` come from the prelude; the two
;; definitions below are this program's own. The last form's value is printed.

(define (sum-of-squares n)
  (sum (map square (range 1 (+ n 1)))))

;; the same quantity by the closed form, so the two can be compared in-language
(define (sum-of-squares-closed n)
  (quotient (* n (+ n 1) (+ (* 2 n) 1)) 6))

(print "sum of squares 1..10  =" (sum-of-squares 10))
(print "closed form           =" (sum-of-squares-closed 10))
(print "agree for 1..50?      =" (all? (lambda (n) (= (sum-of-squares n) (sum-of-squares-closed n)))
                                       (range 1 51)))

;; a fold with an explicit accumulator, no library help
(define (sum-of-squares-by-fold n)
  (fold (lambda (acc k) (+ acc (* k k))) 0 (range 1 (+ n 1))))

(sum-of-squares-by-fold 100)
