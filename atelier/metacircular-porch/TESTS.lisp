;;;; TESTS.lisp — the fixed suite every porch must pass before instrumentation.
;;;; Shared with tower-of-selves (pitch №8): the same programs are run at each floor.
;;;; Run:  ~/.local/bin/sbcl --script TESTS.lisp   (exit 0 iff all pass)

(defvar cl-user::*porch-library* t)
(load (merge-pathnames "porch.lisp" (or *load-pathname* *load-truename*)))
(in-package :porch)

(defvar *pass* 0)
(defvar *fail* 0)

(defmacro check (name expr expected)
  `(let ((env (make-global-env)))
     (let ((got (mc-eval ',expr env)))
       (if (equal got ,expected)
           (progn (incf *pass*)
                  (format t "  ok   ~a~30t=> ~s~%" ,name got))
           (progn (incf *fail*)
                  (format t "  FAIL ~a~30t=> ~s (expected ~s)~%"
                          ,name got ,expected))))))

;;; A suite is a program (list of defines) plus a final expression.  We wrap each
;;; as a single (let () (begin ...)) so a fresh env is used per check.
(defmacro check-prog (name expected &rest program)
  `(let ((env (make-global-env)))
     (let ((got (run ',(butlast program) env))
           (final (mc-eval ',(car (last program)) env)))
       (declare (ignore got))
       (if (equal final ,expected)
           (progn (incf *pass*)
                  (format t "  ok   ~a~30t=> ~s~%" ,name final))
           (progn (incf *fail*)
                  (format t "  FAIL ~a~30t=> ~s (expected ~s)~%"
                          ,name final ,expected))))))

(format t "~&=== PORCH TEST SUITE ===~%")

;; --- arithmetic & self-evaluation ---
(check "int literal"        42                     42)
(check "arithmetic"         (+ (* 3 4) (- 10 2))   20)
(check "nested compare"     (if (< 3 5) 111 222)   111)
(check "quote"              (quote (a b c))        '(a b c))

;; --- recursion ---
(check-prog "factorial" 3628800
  (define (fact n) (if (= n 0) 1 (* n (fact (- n 1)))))
  (fact 10))

(check-prog "fibonacci" 55
  (define (fib n) (if (< n 2) n (+ (fib (- n 1)) (fib (- n 2)))))
  (fib 10))

(check-prog "mutual recursion" t
  (define (even? n) (if (= n 0) t (odd? (- n 1))))
  (define (odd? n)  (if (= n 0) nil (even? (- n 1))))
  (even? 10))

;; --- higher-order functions & closures ---
(check-prog "closures/counter-adder" 15
  (define (adder n) (lambda (x) (+ x n)))
  (define add5 (adder 5))
  (add5 10))

(check-prog "compose" 21
  (define (compose f g) (lambda (x) (f (g x))))
  (define (inc x) (+ x 1))
  (define (dbl x) (* x 2))
  ((compose inc dbl) 10))

(check-prog "map (defined in the object language)" '(1 4 9 16)
  (define (map f xs) (if (null? xs) nil (cons (f (car xs)) (map f (cdr xs)))))
  (define (sq x) (* x x))
  (map sq (list 1 2 3 4)))

;; --- list structure surgery ---
(check-prog "list length via cond" 4
  (define (len xs) (cond ((null? xs) 0) (else (+ 1 (len (cdr xs))))))
  (len (list 10 20 30 40)))

(check-prog "reverse via accumulator" '(4 3 2 1)
  (define (rev xs acc) (if (null? xs) acc (rev (cdr xs) (cons (car xs) acc))))
  (rev (list 1 2 3 4) nil))

(check-prog "assoc built in object lang" 99
  (define (my-assoc k al)
    (cond ((null? al) nil)
          ((eq? (car (car al)) k) (car al))
          (else (my-assoc k (cdr al)))))
  (cdr (my-assoc (quote b) (list (cons (quote a) 1) (cons (quote b) 99)))))

;; --- let & set! (mutation) ---
(check-prog "let" 25
  (let ((a 3) (b 4)) (+ (* a a) (* b b))))

(check-prog "set! mutation" 7
  (define x 3)
  (define (bump) (set! x (+ x 1)))
  (bump) (bump) (bump) (bump)
  x)

(check-prog "set-car! on a pair" '(99 . 2)
  (define p (cons 1 2))
  (set-car! p 99)
  p)

(format t "~%=== ~d passed, ~d failed ===~%" *pass* *fail*)
(sb-ext:exit :code (if (zerop *fail*) 0 1))
