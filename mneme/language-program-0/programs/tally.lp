;; tally.lp — program 4: a frequency counter. Count things, rank them, draw them.
;;
;;   bash mneme/language-program-0/lisp-plus-run.sh mneme/language-program-0/programs/tally.lp
;;
;; Everything here is PROGRAM /0 as documented: lists of (item count) pairs, fold and map from
;; the prelude, a sort that takes its ordering as a function, and closures that keep a tally.
;; In REPL /0, paste the definitions once per session (a second paste is E-REDEFINE; ,reset
;; starts a new session).

;; ---- counting ---------------------------------------------------------------------------
;; A tally is a list of (item count) pairs, in the order items were first seen.

(define (count-of pair) (nth 1 pair))

(define (bump counts x)
  (cond ((null? counts) (list (list x 1)))
        ((equal? (car (car counts)) x)
         (cons (list x (+ 1 (count-of (car counts)))) (cdr counts)))
        (else (cons (car counts) (bump (cdr counts) x)))))

(define (tally xs) (fold bump () xs))

;; count by a derived key: any one-argument function
(define (tally-by key xs) (tally (map key xs)))

;; ---- ranking ----------------------------------------------------------------------------
;; Insertion sort; the caller says what "comes first" means. Ties keep first-seen order.

(define (insert-by before? x sorted)
  (cond ((null? sorted) (list x))
        ((before? x (car sorted)) (cons x sorted))
        (else (cons (car sorted) (insert-by before? x (cdr sorted))))))

(define (sort-by before? xs)
  (fold (lambda (acc x) (insert-by before? x acc)) () xs))

(define (more-often? a b) (> (count-of a) (count-of b)))

(define (ranked xs) (sort-by more-often? (tally xs)))
(define (top n xs) (take n (ranked xs)))

;; ---- asking -----------------------------------------------------------------------------
;; counter-for counts once and returns a closure that answers "how many?" from that count.

(define (lookup counts x)
  (cond ((null? counts) 0)
        ((equal? (car (car counts)) x) (count-of (car counts)))
        (else (lookup (cdr counts) x))))

(define (counter-for xs)
  (let ((counts (tally xs)))
    (lambda (x) (lookup counts x))))

;; ---- drawing ----------------------------------------------------------------------------

(define (bar n) (fold string-append "" (repeat n "#")))
(define (show pair) (print (count-of pair) (bar (count-of pair)) (car pair)))
(define (histogram xs) (for-each show (ranked xs)))

(define (mean xs) (/ (sum xs) (length xs)))

;; ---- use --------------------------------------------------------------------------------

;; Gertrude Stein, "Sacred Emily" (1913), one line of it, as symbols
(define stein '(rose is a rose is a rose is a rose))
(print "words:" (length stein) "distinct:" (length (tally stein)))
(histogram stein)
(define how-many (counter-for stein))
(print "how many rose?" (how-many 'rose) "how many tulip?" (how-many 'tulip))

;; twenty rolls of a die, written down in advance (PROGRAM /0 has no randomness and no input)
(define rolls '(3 6 1 6 2 5 6 4 3 6 1 2 6 5 3 4 6 2 1 6))
(histogram rolls)
(print "mean roll:" (mean rolls) "most common:" (top 1 rolls))
(print "even?:" (tally-by even? rolls))
(print "low (1-3) vs high (4-6):" (tally-by (lambda (r) (if (<= r 3) 'low 'high)) rolls))

(top 3 stein)
