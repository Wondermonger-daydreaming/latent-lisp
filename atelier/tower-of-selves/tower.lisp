;;;; tower.lisp — The Tower of Selves.  Bootstrapping degradation, MEASURED.
;;;; PITCH №8, Lisp Atelier.  Built 2026-07-10 by LUTHIER (Opus 4.8).
;;;;
;;;; Floor 0 = SBCL native.
;;;; Floor 1 = the metacircular-porch evaluator (mc-eval) interpreting a benchmark.
;;;; Floor 2 = mc-eval interpreting S-EVAL (the porch evaluator written IN the object
;;;;           language) interpreting the benchmark.
;;;; Floor 3 = mc-eval interpreting S-EVAL interpreting S-EVAL interpreting the benchmark.
;;;;
;;;; The question: how much of a language survives self-interpretation, N levels deep?
;;;; The answer is a TABLE, not a metaphor.  Every claim below is executed.
;;;;
;;;; Run:  ~/.local/bin/sbcl --script tower.lisp

(defvar cl-user::*porch-library* t)
(load (merge-pathnames "../metacircular-porch/porch.lisp"
                       (or *load-pathname* *load-truename*)))
(in-package :porch)

(declaim (optimize (debug 0) (speed 2)))

(defparameter *self* (or *load-truename* *load-pathname*))
(defparameter *loop-defs*
  '((define (loop n) (if (= n 0) (quote done) (loop (- n 1))))))

;;; ------------------------------------------------------------------------
;;;  S-EVAL — the porch evaluator, written IN the object language it evaluates.
;;;  This is the metacircular fixed point: mc-eval (CL) can run it, and it can
;;;  run itself.  Single-expression bodies throughout (no `begin`); sequencing
;;;  where needed is done by SEQ2 (evaluate a for effect, return b).
;;;  Primitives are hand-dispatched by APPLY-PRIM so the evaluator is closed:
;;;  it depends on no host `apply`.
;;; ------------------------------------------------------------------------

(defparameter *evaluator-src*
  '(
    (define (seq2 a b) b)

    ;; tagged compound procedure:  (proc params body env)
    (define (make-proc params body env) (list (quote proc) params body env))
    (define (proc? p) (if (pair? p) (eq? (car p) (quote proc)) nil))
    (define (proc-params p) (cadr p))
    (define (proc-body p) (caddr p))
    (define (proc-env p) (car (cdr (cdr (cdr p)))))

    ;; tagged primitive:  (prim name)
    (define (make-prim name) (list (quote prim) name))
    (define (prim? p) (if (pair? p) (eq? (car p) (quote prim)) nil))
    (define (prim-name p) (cadr p))

    ;; environment = list of frames; frame = (alist); binding = (sym . val)
    (define (assq k al)
      (cond ((null? al) nil)
            ((eq? (car (car al)) k) (car al))
            (else (assq k (cdr al)))))
    (define (env-binding env sym)
      (cond ((null? env) nil)
            (else (let ((b (assq sym (car (car env)))))
                    (if b b (env-binding (cdr env) sym))))))
    (define (env-lookup sym env)
      (let ((b (env-binding env sym)))
        (if b (cdr b) (quote *UNBOUND*))))
    (define (env-define! env sym val)
      (seq2 (set-car! (car env)
                      (cons (cons sym val) (car (car env))))
            sym))
    (define (zip ks vs)
      (cond ((null? ks) nil)
            (else (cons (cons (car ks) (car vs)) (zip (cdr ks) (cdr vs))))))
    (define (extend params args env)
      (cons (list (zip params args)) env))

    ;; self-evaluating: numbers, T, the empty list
    (define (self? e)
      (cond ((number? e) t)
            ((eq? e t) t)
            ((null? e) t)
            (else nil)))

    (define (s-eval exp env)
      (cond ((self? exp) exp)
            ((symbol? exp) (env-lookup exp env))
            ((eq? (car exp) (quote quote)) (cadr exp))
            ((eq? (car exp) (quote if))
             (if (s-eval (cadr exp) env)
                 (s-eval (caddr exp) env)
                 (s-eval (car (cdr (cdr (cdr exp)))) env)))
            ((eq? (car exp) (quote lambda))
             (make-proc (cadr exp) (caddr exp) env))
            ((eq? (car exp) (quote define)) (s-eval-define exp env))
            ((eq? (car exp) (quote let)) (s-eval-let exp env))
            ((eq? (car exp) (quote cond)) (s-eval-cond (cdr exp) env))
            (else (s-apply (s-eval (car exp) env)
                           (s-eval-args (cdr exp) env)))))

    (define (s-eval-args exps env)
      (cond ((null? exps) nil)
            (else (cons (s-eval (car exps) env)
                        (s-eval-args (cdr exps) env)))))

    (define (s-eval-define exp env)
      (let ((target (cadr exp)))
        (cond ((pair? target)
               (env-define! env (car target)
                            (make-proc (cdr target) (caddr exp) env)))
              (else (env-define! env target (s-eval (caddr exp) env))))))

    (define (let-vars bs)
      (cond ((null? bs) nil) (else (cons (car (car bs)) (let-vars (cdr bs))))))
    (define (let-exprs bs)
      (cond ((null? bs) nil) (else (cons (cadr (car bs)) (let-exprs (cdr bs))))))
    (define (s-eval-let exp env)
      (s-eval (caddr exp)
              (extend (let-vars (cadr exp))
                      (s-eval-args (let-exprs (cadr exp)) env)
                      env)))

    (define (s-eval-cond clauses env)
      (cond ((null? clauses) nil)
            ((eq? (car (car clauses)) (quote else))
             (s-eval (cadr (car clauses)) env))
            ((s-eval (car (car clauses)) env)
             (s-eval (cadr (car clauses)) env))
            (else (s-eval-cond (cdr clauses) env))))

    (define (s-apply proc args)
      (cond ((prim? proc) (apply-prim (prim-name proc) args))
            ((proc? proc)
             (s-eval (proc-body proc)
                     (extend (proc-params proc) args (proc-env proc))))
            (else (quote *NOT-APPLICABLE*))))

    (define (apply-prim name args)
      (cond ((eq? name (quote car)) (car (car args)))
            ((eq? name (quote cdr)) (cdr (car args)))
            ((eq? name (quote cons)) (cons (car args) (cadr args)))
            ((eq? name (quote caar)) (caar (car args)))
            ((eq? name (quote cadr)) (cadr (car args)))
            ((eq? name (quote caddr)) (caddr (car args)))
            ((eq? name (quote null?)) (null? (car args)))
            ((eq? name (quote pair?)) (pair? (car args)))
            ((eq? name (quote eq?)) (eq? (car args) (cadr args)))
            ((eq? name (quote not)) (not (car args)))
            ((eq? name (quote number?)) (number? (car args)))
            ((eq? name (quote symbol?)) (symbol? (car args)))
            ((eq? name (quote set-car!)) (set-car! (car args) (cadr args)))
            ((eq? name (quote +)) (+ (car args) (cadr args)))
            ((eq? name (quote -)) (- (car args) (cadr args)))
            ((eq? name (quote *)) (* (car args) (cadr args)))
            ((eq? name (quote =)) (= (car args) (cadr args)))
            ((eq? name (quote <)) (< (car args) (cadr args)))
            ((eq? name (quote >)) (> (car args) (cadr args)))
            ((eq? name (quote <=)) (<= (car args) (cadr args)))
            ((eq? name (quote list)) args)
            (else (quote *BAD-PRIM*))))

    (define (prim-binding name) (cons name (make-prim name)))
    (define (base-alist)
      (list (prim-binding (quote car)) (prim-binding (quote cdr))
            (prim-binding (quote cons)) (prim-binding (quote caar))
            (prim-binding (quote cadr)) (prim-binding (quote caddr))
            (prim-binding (quote null?)) (prim-binding (quote pair?))
            (prim-binding (quote eq?)) (prim-binding (quote not))
            (prim-binding (quote number?)) (prim-binding (quote symbol?))
            (prim-binding (quote set-car!))
            (prim-binding (quote +)) (prim-binding (quote -))
            (prim-binding (quote *)) (prim-binding (quote =))
            (prim-binding (quote <)) (prim-binding (quote >))
            (prim-binding (quote <=)) (prim-binding (quote list))))
    (define (base-env) (list (list (base-alist))))

    (define (eval-defs defs env)
      (cond ((null? defs) nil)
            (else (seq2 (s-eval (car defs) env)
                        (eval-defs (cdr defs) env)))))
    (define (s-run program final)
      (let ((env (base-env)))
        (seq2 (eval-defs program env) (s-eval final env))))
    ))

;;; ------------------------------------------------------------------------
;;;  Floor runners.
;;; ------------------------------------------------------------------------

(defun load-evaluator (env)
  "Load *evaluator-src* into a porch env so s-run / s-eval become callable."
  (run *evaluator-src* env)
  env)

;; floor 0 — native CL
(defun native-fib (n) (if (< n 2) n (+ (native-fib (- n 1)) (native-fib (- n 2)))))

;; floor 1 — porch mc-eval interpreting the benchmark
(defun floor1 (bench-defs bench-call)
  (let ((env (make-global-env)))
    (run bench-defs env)
    (mc-eval bench-call env)))

;; floor 2 — mc-eval interpreting s-run interpreting the benchmark
(defun floor2 (bench-defs bench-call)
  (let ((env (make-global-env)))
    (load-evaluator env)
    (mc-eval (list 's-run (list 'quote bench-defs) (list 'quote bench-call)) env)))

;; floor 3 — mc-eval / s-run / s-run / benchmark
(defun floor3 (bench-defs bench-call)
  (let ((env (make-global-env)))
    (load-evaluator env)
    (mc-eval (list 's-run
                   (list 'quote *evaluator-src*)
                   (list 'quote (list 's-run (list 'quote bench-defs)
                                      (list 'quote bench-call))))
             env)))

;;; ------------------------------------------------------------------------
;;;  Stack-probe child mode.  When invoked as `... --stack-probe FLOOR DEPTH`,
;;;  attempt (loop DEPTH) at that floor with NO handler and exit 0 iff it
;;;  completes.  A control-stack exhaustion is fatal (non-zero exit) — which is
;;;  precisely the casualty we are measuring, isolated in its own process so it
;;;  cannot abort the parent run.
;;; ------------------------------------------------------------------------

(let ((args (rest sb-ext:*posix-argv*)))
  (when (and args (string= (first args) "--stack-probe"))
    (let ((fl (parse-integer (second args)))
          (k  (parse-integer (third args))))
      (ecase fl
        (0 (labels ((lp (n) (if (= n 0) 'done (lp (- n 1))))) (lp k)))
        (1 (floor1 *loop-defs* (list 'loop k)))
        (2 (floor2 *loop-defs* (list 'loop k))))
      (sb-ext:exit :code 0))))

(defun stack-survives (floor depth)
  "Run (loop DEPTH) at FLOOR in a fresh SBCL child; T iff it exits 0."
  (let ((proc (sb-ext:run-program
               (sb-ext:native-namestring sb-ext:*runtime-pathname*)
               (list "--dynamic-space-size" "4096" "--script"
                     (sb-ext:native-namestring *self*)
                     "--stack-probe" (princ-to-string floor) (princ-to-string depth))
               :output nil :error nil :wait t)))
    (zerop (sb-ext:process-exit-code proc))))

;;; ------------------------------------------------------------------------
;;;  Utility: time a thunk in seconds (internal-run-time).
;;; ------------------------------------------------------------------------

(defmacro timed (&body body)
  `(let ((start (get-internal-run-time)))
     (let ((val (progn ,@body)))
       (values val (/ (- (get-internal-run-time) start)
                      (float internal-time-units-per-second))))))

(defun banner (s)
  (format t "~%~a~%~a~%" s (make-string (length s) :initial-element #\=)))

;;; ------------------------------------------------------------------------
;;;  PROBE A — correctness across floors (does the value survive?)
;;; ------------------------------------------------------------------------

(defparameter *fib-defs*
  '((define (fib n) (if (< n 2) n (+ (fib (- n 1)) (fib (- n 2)))))))

(banner "PROBE A — correctness: is the computed value identical at every floor?")
(let* ((call '(fib 10))
       (f0 (native-fib 10))
       (f1 (floor1 *fib-defs* call))
       (f2 (floor2 *fib-defs* call))
       (f3 (floor3 *fib-defs* call)))
  (format t "  benchmark: (fib 10)~%")
  (format t "  floor 0 (native)      : ~s~%" f0)
  (format t "  floor 1 (mc-eval)     : ~s~%" f1)
  (format t "  floor 2 (mc/s-eval)   : ~s~%" f2)
  (format t "  floor 3 (mc/s/s-eval) : ~s~%" f3)
  (format t "  ALL EQUAL: ~a~%"
          (if (= f0 f1 f2 f3) "YES — correctness survives 3 self-interpretations"
              "NO — a floor diverged")))

;; also confirm a richer program (closures + list surgery + let + cond) survives
(let* ((defs '((define (map f xs)
                 (if (null? xs) nil (cons (f (car xs)) (map f (cdr xs)))))
               (define (adder n) (lambda (x) (+ x n)))
               (define (add5) (adder 5))))
       (call '(map (add5) (list 10 20 30)))
       (f1 (floor1 defs call))
       (f2 (floor2 defs call)))
  (format t "~%  richer program (map + closure): floor1 => ~s  floor2 => ~s  ~a~%"
          f1 f2 (if (equal f1 f2) "MATCH" "DIVERGE")))

;;; ------------------------------------------------------------------------
;;;  PROBE B — the interpretation constant (folklore: 10-100x per level)
;;; ------------------------------------------------------------------------

(banner "PROBE B — the interpretation constant (measured, this machine, this build)")
(let ((call '(fib 20)))
  (multiple-value-bind (v0 t0) (timed (native-fib 20)) (declare (ignore v0))
    (multiple-value-bind (v1 t1) (timed (floor1 *fib-defs* call)) (declare (ignore v1))
      (multiple-value-bind (v2 t2) (timed (floor2 *fib-defs* call)) (declare (ignore v2))
        (format t "  benchmark: (fib 20) = 6765~%")
        (format t "  floor 0 (native)    : ~,4f s~%" t0)
        (format t "  floor 1 (mc-eval)   : ~,4f s     (~,1fx over floor 0)~%"
                t1 (if (zerop t0) 0 (/ t1 (max t0 1e-6))))
        (format t "  floor 2 (mc/s-eval) : ~,4f s     (~,1fx over floor 1)~%"
                t2 (if (zerop t1) 0 (/ t2 (max t1 1e-6))))
        (format t "  --- floor 3 priced separately below (fib 20 is too dear) ---~%")))))

;; floor 3 timing on a smaller input (documented size change — honest, not silent)
(let ((call '(fib 12)))
  (multiple-value-bind (v1 t1) (timed (floor1 *fib-defs* call)) (declare (ignore v1))
    (multiple-value-bind (v2 t2) (timed (floor2 *fib-defs* call)) (declare (ignore v2))
      (multiple-value-bind (v3 t3) (timed (floor3 *fib-defs* call)) (declare (ignore v3))
        (format t "~%  smaller benchmark (fib 12) = 144, to reach floor 3:~%")
        (format t "  floor 1 : ~,4f s~%" t1)
        (format t "  floor 2 : ~,4f s     (~,1fx over floor 1)~%"
                t2 (if (zerop t1) 0 (/ t2 (max t1 1e-6))))
        (format t "  floor 3 : ~,4f s     (~,1fx over floor 2)~%"
                t3 (if (zerop t2) 0 (/ t3 (max t2 1e-6))))
        (format t "  Is the constant STABLE across floors (does 3/2 ~~ 2/1)? ~%")
        (format t "    ratio 2/1 = ~,1fx , ratio 3/2 = ~,1fx~%"
                (if (zerop t1) 0 (/ t2 (max t1 1e-6)))
                (if (zerop t2) 0 (/ t3 (max t2 1e-6))))))))

;;; ------------------------------------------------------------------------
;;;  PROBE C — the tail-call casualty (a semantic invisible that erodes)
;;;  A tail-recursive countdown; find the depth each floor tolerates.
;;; ------------------------------------------------------------------------

(banner "PROBE C — tail calls: which floor blows the stack, and at what depth?")
(format t "  (each cell runs in a fresh SBCL child; a crash = OVERFLOW by exit code)~%")
(format t "  floor 0 (native, SBCL does TCO in compiled code):~%")
(dolist (k '(1000 100000 1000000 10000000))
  (format t "    (loop ~10:d) : ~a~%" k
          (if (stack-survives 0 k) "survives" "STACK OVERFLOW")))
(format t "  floor 1 (mc-eval — NO tail-call optimization):~%")
(dolist (k '(8000 9000 10000 12000))
  (format t "    (loop ~10:d) : ~a~%" k
          (if (stack-survives 1 k) "survives" "STACK OVERFLOW")))
(format t "  floor 2 (mc/s-eval — two non-TCO interpreters stacked):~%")
(dolist (k '(1000 1500 2000 2500))
  (format t "    (loop ~10:d) : ~a~%" k
          (if (stack-survives 2 k) "survives" "STACK OVERFLOW")))

;;; ------------------------------------------------------------------------
;;;  PROBE D — error behaviour degrades from structured to stringly.
;;; ------------------------------------------------------------------------

(banner "PROBE D — error semantics: a structured condition becomes a sentinel value")
(format t "  Evaluate an UNBOUND variable at each floor:~%")
;; floor 1: mc-eval signals a real CL condition
(format t "  floor 1 (mc-eval)   : ~a~%"
        (handler-case (progn (floor1 '() 'nonesuch) "returned a value(!)")
          (error (e) (format nil "signalled a structured CL error: ~a"
                             (type-of e)))))
;; floor 2: the object-language s-eval has no condition system — returns a sentinel
(format t "  floor 2 (mc/s-eval) : returned sentinel ~s (no condition system inside)~%"
        (floor2 '() 'nonesuch))
(format t "  => the casualty: floor 1 error is a CONDITION you can handle by type;~%")
(format t "     floor 2 error is a SYMBOL you must test for.  Structure lost.~%")

(format t "~%DONE.~%")
