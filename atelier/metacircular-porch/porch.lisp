;;;; porch.lisp — The Metacircular Porch: eval/apply written in the language they interpret.
;;;; PITCH №2, Lisp Atelier.  Built 2026-07-10.
;;;;
;;;; A clean metacircular evaluator over a small Scheme-ish core (numbers, symbols,
;;;; quote, if, lambda, define, let, begin, set!, cond, application).  The point of
;;;; movement 1 is CORRECTNESS: the evaluator must pass a fixed suite before any
;;;; instrumentation.  Movement 2 (trace.lisp) adds REAL introspection — every claim
;;;; about "what eval did" checkable against a log.  Movement 3 (amb.lisp) dreams all
;;;; branches.  The object language is deliberately a subset expressive enough to
;;;; write the evaluator ITSELF in (that is what tower-of-selves stress-tests).
;;;;
;;;; Value/boolean convention (kept isomorphic to CL so floor 0 native runs cheaply):
;;;;   - the ONLY false value is CL NIL (also the empty list).
;;;;   - everything else is true (numbers, the symbol T, conses, closures).
;;;;   - predicates return CL T or NIL.
;;;;   - self-evaluating: numbers, strings, T, NIL.  All other symbols are variables.
;;;;
;;;; Load as a library to suppress the demo:  (defvar *porch-library* t) before load.

(defpackage :porch (:use :cl) (:export :mc-eval :global-env :fresh-env :run :*trace-stream*))
(in-package :porch)

;;; ------------------------------------------------------------------------
;;;  Environments — a list of frames; each frame is a one-cons cell whose CAR
;;;  is the binding alist, so DEFINE and SET! can mutate in place.
;;; ------------------------------------------------------------------------

(defun make-frame (alist) (list alist))              ; frame = (alist)
(defun frame-alist (frame) (car frame))
(defun frame-add! (frame sym val) (setf (car frame) (acons sym val (car frame))))

(defun fresh-env (&optional (bindings nil))
  "A new environment with one frame holding BINDINGS (an alist)."
  (list (make-frame bindings)))

(defun env-binding (env sym)
  "Return the mutable (sym . val) cons for SYM, or NIL."
  (dolist (frame env nil)
    (let ((b (assoc sym (frame-alist frame))))
      (when b (return b)))))

(defun env-lookup (env sym)
  (let ((b (env-binding env sym)))
    (if b (cdr b)
        (error "Unbound variable: ~s" sym))))

(defun env-define! (env sym val)
  "Define SYM in the CURRENT (first) frame."
  (let ((b (assoc sym (frame-alist (first env)))))
    (if b (setf (cdr b) val)
        (frame-add! (first env) sym val)))
  sym)

(defun env-set! (env sym val)
  (let ((b (env-binding env sym)))
    (if b (setf (cdr b) val)
        (error "set! on unbound variable: ~s" sym))
    val))

(defun extend-env (params args env)
  "Push a new frame binding PARAMS to ARGS onto ENV."
  (cons (make-frame (pairlis params args)) env))

;;; ------------------------------------------------------------------------
;;;  Closures — a tagged list so the object language can also represent them.
;;; ------------------------------------------------------------------------

(defstruct (closure (:constructor make-closure (params body env)))
  params body env)

;; Compact printing — a closure's captured env is often self-referential
;; (recursion), so never print it in full.
(defmethod print-object ((c closure) stream)
  (format stream "#<closure ~s>" (closure-params c)))

;;; ------------------------------------------------------------------------
;;;  Trace hook.  Movement 2 sets *TRACE-STREAM*; when non-NIL, EVAL emits an
;;;  indented log of what it attended to.  Same evaluator, plain or traced.
;;; ------------------------------------------------------------------------

(defvar *trace-stream* nil)
(defvar *trace-depth* 0)
(defvar *trace-events* nil)   ; when bound to a cons cell (car = list), events accumulate

(defun trace-emit (action form)
  (when *trace-stream*
    (format *trace-stream* "~&~v@t~a ~s~%"
            (* 2 *trace-depth*) action form))
  (when *trace-events*
    (push (list *trace-depth* action form) (car *trace-events*))))

;;; ------------------------------------------------------------------------
;;;  The evaluator.
;;; ------------------------------------------------------------------------

(defun self-evaluating-p (form)
  (or (numberp form) (stringp form) (eq form t) (null form)))

(defun mc-eval (form env)
  (let ((*trace-depth* (1+ *trace-depth*)))
    (trace-emit "EVAL" form)
    (cond
      ((self-evaluating-p form) (trace-emit "SELF" form) form)
      ((symbolp form)
       (let ((v (env-lookup env form)))
         (trace-emit "VAR->" (list form '= v)) v))
      ((atom form) form)
      (t (case (car form)
           (quote (cadr form))
           (if (mc-eval-if form env))
           (lambda (make-closure (cadr form) (cddr form) env))
           (define (mc-eval-define form env))
           (set! (env-set! env (cadr form) (mc-eval (caddr form) env)))
           (begin (mc-eval-seq (cdr form) env))
           (let (mc-eval-let form env))
           (cond (mc-eval-cond (cdr form) env))
           (t (mc-apply
               (mc-eval (car form) env)
               (mapcar (lambda (a) (mc-eval a env)) (cdr form)))))))))

(defun mc-eval-if (form env)
  (trace-emit "IF-TEST" (cadr form))
  (if (mc-eval (cadr form) env)
      (progn (trace-emit "IF-THEN" (caddr form)) (mc-eval (caddr form) env))
      (progn (trace-emit "IF-ELSE" (cadddr form))
             (if (cdddr form) (mc-eval (cadddr form) env) nil))))

(defun mc-eval-define (form env)
  (let ((target (cadr form)))
    (if (consp target)
        ;; (define (name . params) . body)  =>  name = (lambda params . body)
        (env-define! env (car target)
                     (make-closure (cdr target) (cddr form) env))
        (env-define! env target (mc-eval (caddr form) env)))))

(defun mc-eval-seq (forms env)
  (let ((result nil))
    (dolist (f forms result)
      (setf result (mc-eval f env)))))

(defun mc-eval-let (form env)
  ;; (let ((v e) ...) body...)  =>  apply (lambda (v ...) body...) to (e ...)
  (let* ((bindings (cadr form))
         (vars (mapcar #'car bindings))
         (exprs (mapcar #'cadr bindings))
         (args (mapcar (lambda (e) (mc-eval e env)) exprs)))
    (mc-eval-seq (cddr form) (extend-env vars args env))))

(defun mc-eval-cond (clauses env)
  (dolist (clause clauses nil)
    (if (eq (car clause) 'else)
        (return (mc-eval-seq (cdr clause) env))
        (when (mc-eval (car clause) env)
          (return (mc-eval-seq (cdr clause) env))))))

(defun mc-apply (proc args)
  (trace-emit "APPLY" (cons (if (closure-p proc) '<closure> proc) args))
  (cond
    ((functionp proc) (apply proc args))            ; a CL primitive
    ((closure-p proc)
     (mc-eval-seq (closure-body proc)
                  (extend-env (closure-params proc) args (closure-env proc))))
    (t (error "Not applicable: ~s" proc))))

;;; ------------------------------------------------------------------------
;;;  The global environment — primitives are CL functions.
;;; ------------------------------------------------------------------------

(defun boolean->cl (x) (if x t nil))

(defun make-global-env ()
  (fresh-env
   (list
    (cons 'cons #'cons)
    (cons 'car #'car)
    (cons 'cdr #'cdr)
    (cons 'caar #'caar)
    (cons 'cadr #'cadr)
    (cons 'cddr #'cddr)
    (cons 'caddr #'caddr)
    (cons 'list #'list)
    (cons 'set-car! (lambda (p v) (rplaca p v) v))
    (cons 'set-cdr! (lambda (p v) (rplacd p v) v))
    (cons 'pair? (lambda (x) (boolean->cl (consp x))))
    (cons 'null? (lambda (x) (boolean->cl (null x))))
    (cons 'symbol? (lambda (x) (boolean->cl (and x (symbolp x)))))
    (cons 'number? (lambda (x) (boolean->cl (numberp x))))
    (cons 'eq? (lambda (a b) (boolean->cl (eql a b))))
    (cons 'equal? (lambda (a b) (boolean->cl (equal a b))))
    (cons 'not (lambda (x) (boolean->cl (null x))))
    (cons '+ #'+)
    (cons '- #'-)
    (cons '* #'*)
    (cons '= (lambda (a b) (boolean->cl (= a b))))
    (cons '< (lambda (a b) (boolean->cl (< a b))))
    (cons '> (lambda (a b) (boolean->cl (> a b))))
    (cons '<= (lambda (a b) (boolean->cl (<= a b))))
    (cons 'zero? (lambda (x) (boolean->cl (zerop x))))
    (cons 'display (lambda (x) (princ x) x))
    (cons 'newline (lambda () (terpri) nil)))))

(defvar *the-global-env* nil)
(defun global-env ()
  (or *the-global-env* (setf *the-global-env* (make-global-env))))

(defun run (program &optional (env (global-env)))
  "Evaluate a sequence of top-level forms, returning the last value."
  (mc-eval-seq program env))

;;; ------------------------------------------------------------------------
;;;  Demo (suppressed when loaded as a library).
;;; ------------------------------------------------------------------------

(unless (and (boundp 'cl-user::*porch-library*) cl-user::*porch-library*)
  (format t "~&=== The Metacircular Porch — a live evaluation ===~%")
  (let ((env (make-global-env)))
    (run '((define (fact n) (if (= n 0) 1 (* n (fact (- n 1)))))
           (define (fib n) (if (< n 2) n (+ (fib (- n 1)) (fib (- n 2))))))
         env)
    (format t "  (fact 6)  => ~s~%" (mc-eval '(fact 6) env))
    (format t "  (fib 15)  => ~s~%" (mc-eval '(fib 15) env))
    ;; closures / higher order
    (run '((define (compose f g) (lambda (x) (f (g x))))
           (define (inc x) (+ x 1))
           (define (dbl x) (* x 2))) env)
    (format t "  ((compose inc dbl) 10) => ~s~%"
            (mc-eval '((compose inc dbl) 10) env))
    ;; let, cond, list surgery
    (format t "  (let ((a 3) (b 4)) (+ (* a a) (* b b))) => ~s~%"
            (mc-eval '(let ((a 3) (b 4)) (+ (* a a) (* b b))) env))
    (run '((define (len xs) (cond ((null? xs) 0) (else (+ 1 (len (cdr xs))))))) env)
    (format t "  (len (list 10 20 30 40)) => ~s~%"
            (mc-eval '(len (list 10 20 30 40)) env))
    (format t "=== the porch stands ===~%")))
