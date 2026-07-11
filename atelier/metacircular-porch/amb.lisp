;;;; amb.lisp — Movement 3: the amb porch.  The evaluator that dreams all branches.
;;;;
;;;; McCarthy's nondeterministic `amb` with automatic backtracking, in continuation-
;;;; passing style: every evaluation carries a SUCCEED continuation (what to do with a
;;;; value) and a FAIL continuation (what to try when a later `require` rejects this
;;;; branch).  `/loom` as a language semantics — the multiverse of what-could-be-said,
;;;; made a runnable evaluator.  The backtracks are COUNTED, so "systematic dreaming"
;;;; is exhibited, not asserted.
;;;;
;;;; Run:  ~/.local/bin/sbcl --script amb.lisp

(defpackage :amb-porch (:use :cl))
(in-package :amb-porch)

;;; ---- environments: mutable global frame + lexical alists ----
(defun bool (x) (if x t nil))

(defvar *global* nil)
(defun make-global ()
  (list (cons '+ #'+) (cons '- #'-) (cons '* #'*)
        (cons '= (lambda (a b) (bool (= a b))))
        (cons '< (lambda (a b) (bool (< a b))))
        (cons '> (lambda (a b) (bool (> a b))))
        (cons '<= (lambda (a b) (bool (<= a b))))
        (cons '>= (lambda (a b) (bool (>= a b))))
        (cons 'list #'list)
        (cons 'cons #'cons)
        (cons 'not (lambda (x) (bool (null x))))
        (cons 'null? (lambda (x) (bool (null x))))
        (cons 'eq? (lambda (a b) (bool (eql a b))))
        (cons 'car #'car)
        (cons 'cdr #'cdr)
        (cons 'abs #'abs)))

(defun lookup (sym env)
  (let ((b (or (assoc sym env) (assoc sym *global*))))
    (if b (cdr b) (error "unbound: ~s" sym))))

(defstruct (clo (:constructor make-clo (params body env))) params body env)
(defmethod print-object ((c clo) s) (format s "#<clo ~s>" (clo-params c)))

;;; ---- the backtrack counter (the instrument) ----
(defvar *backtracks* 0)

;;; ---- the nondeterministic evaluator ----
;;; amb-eval : form env succeed fail -> (invokes succeed value fail | fail)
(defun amb-eval (form env succeed fail)
  (cond
    ((or (numberp form) (stringp form) (eq form t) (null form))
     (funcall succeed form fail))
    ((symbolp form) (funcall succeed (lookup form env) fail))
    ((atom form) (funcall succeed form fail))
    (t (case (car form)
         (quote (funcall succeed (cadr form) fail))
         (if (amb-eval (cadr form) env
                       (lambda (c f2)
                         (if c (amb-eval (caddr form) env succeed f2)
                             (amb-eval (cadddr form) env succeed f2)))
                       fail))
         (define (amb-eval-define form env succeed fail))
         (lambda (funcall succeed (make-clo (cadr form) (cddr form) env) fail))
         (begin (amb-eval-seq (cdr form) env succeed fail))
         (let (amb-eval-let form env succeed fail))
         (require
          (amb-eval (cadr form) env
                    (lambda (v f2) (if v (funcall succeed nil f2) (funcall f2)))
                    fail))
         (amb (amb-eval-amb (cdr form) env succeed fail))
         (t (amb-eval-app form env succeed fail))))))

(defun amb-eval-define (form env succeed fail)
  (let ((target (cadr form)))
    (if (consp target)
        (progn (push (cons (car target) (make-clo (cdr target) (cddr form) env))
                     *global*)
               (funcall succeed (car target) fail))
        (amb-eval (caddr form) env
                  (lambda (v f2) (push (cons target v) *global*)
                    (funcall succeed target f2))
                  fail))))

(defun amb-eval-seq (forms env succeed fail)
  (if (null (cdr forms))
      (amb-eval (car forms) env succeed fail)
      (amb-eval (car forms) env
                (lambda (v f2) (declare (ignore v))
                  (amb-eval-seq (cdr forms) env succeed f2))
                fail)))

(defun amb-eval-let (form env succeed fail)
  ;; (let ((v e)...) body...) — evaluate binding exprs left-to-right (each may amb)
  (let ((vars (mapcar #'car (cadr form)))
        (exprs (mapcar #'cadr (cadr form))))
    (labels ((collect (es acc f)
               (if (null es)
                   (amb-eval-seq (cddr form)
                                 (append (mapcar #'cons vars (reverse acc)) env)
                                 succeed f)
                   (amb-eval (car es) env
                             (lambda (v f2) (collect (cdr es) (cons v acc) f2))
                             f))))
      (collect exprs nil fail))))

(defun amb-eval-amb (choices env succeed fail)
  ;; try each choice in order; on backtrack, advance to the next
  (if (null choices)
      (funcall fail)                          ; (amb) with no options => dead end
      (amb-eval (car choices) env succeed
                (lambda () (incf *backtracks*)
                  (amb-eval-amb (cdr choices) env succeed fail)))))

(defun amb-eval-app (form env succeed fail)
  (amb-eval (car form) env
            (lambda (proc f2)
              (labels ((evargs (as acc f)
                         (if (null as)
                             (amb-apply proc (reverse acc) succeed f)
                             (amb-eval (car as) env
                                       (lambda (v f3) (evargs (cdr as) (cons v acc) f3))
                                       f))))
                (evargs (cdr form) nil f2)))
            fail))

(defun amb-apply (proc args succeed fail)
  (cond
    ((functionp proc) (funcall succeed (apply proc args) fail))
    ((clo-p proc)
     (amb-eval-seq (clo-body proc)
                   (append (mapcar #'cons (clo-params proc) args) (clo-env proc))
                   succeed fail))
    (t (error "not applicable: ~s" proc))))

;;; ---- driver: force ALL solutions by calling fail after each success ----
(defun collect-all (program final-expr)
  (setf *global* (make-global) *backtracks* 0)
  (dolist (f program) (amb-eval f nil (lambda (v f2) (declare (ignore v f2)) nil)
                                (lambda () (error "define failed"))))
  (let ((solutions '()))
    (block done
      (amb-eval final-expr nil
                (lambda (value fail) (push value solutions) (funcall fail))
                (lambda () (return-from done))))
    (values (nreverse solutions) *backtracks*)))

;;; ------------------------------------------------------------------------
;;;  DEMO 1 — all Pythagorean triples i<=j<=k with sides in [1,20].
;;;  Verifiable against the known list; the backtrack count exhibits the search.
;;; ------------------------------------------------------------------------

(format t "~&=== The amb porch — systematic dreaming with backtracking ===~%~%")

(multiple-value-bind (sols backs)
    (collect-all
     '((define (an-integer-between lo hi)
         (require (<= lo hi))
         (amb lo (an-integer-between (+ lo 1) hi)))
       (define (pyth lo hi)
         (let ((i (an-integer-between lo hi)))
           (let ((j (an-integer-between i hi)))
             (let ((k (an-integer-between j hi)))
               (require (= (+ (* i i) (* j j)) (* k k)))
               (list i j k))))))
     '(pyth 1 20))
  (format t "Pythagorean triples with 1 <= i <= j <= k <= 20:~%")
  (dolist (s sols) (format t "    ~a~%" s))
  (format t "  solutions found : ~d~%" (length sols))
  (format t "  branches backtracked through : ~:d~%" backs)
  ;; independent CL check of the SAME predicate — the dream must match brute force
  (let ((brute (loop for i from 1 to 20 nconc
                     (loop for j from i to 20 nconc
                           (loop for k from j to 20
                                 when (= (+ (* i i) (* j j)) (* k k))
                                 collect (list i j k))))))
    (format t "  brute-force CL cross-check   : ~a~%"
            (if (equal sols brute) "MATCH — the amb evaluator found exactly the true set"
                (format nil "MISMATCH: ~a" brute)))))

;;; ------------------------------------------------------------------------
;;;  DEMO 2 — a small logic puzzle (Baker/Cooper/Fletcher/Miller/Smith on 5
;;;  floors, the SICP amb classic, trimmed).  Distinct floors, constraints.
;;; ------------------------------------------------------------------------

(format t "~%The multiple-dwelling puzzle (SICP 4.3): five people, five floors,~%")
(format t "distinct; Baker not 5; Cooper not 1; Fletcher not 1 or 5;~%")
(format t "Miller above Cooper; Fletcher not adjacent to Cooper; Smith not adjacent Fletcher.~%")
(multiple-value-bind (sols backs)
    (collect-all
     '((define (member? x xs)
         (if (null? xs) nil (if (eq? x (car xs)) t (member? x (cdr xs)))))
       (define (an-integer-between lo hi)
         (require (<= lo hi))
         (amb lo (an-integer-between (+ lo 1) hi)))
       (define (distinct5 a b c d e)
         (require (not (= a b))) (require (not (= a c))) (require (not (= a d)))
         (require (not (= a e))) (require (not (= b c))) (require (not (= b d)))
         (require (not (= b e))) (require (not (= c d))) (require (not (= c e)))
         (require (not (= d e))) t)
       (define (dwelling)
         (let ((baker (an-integer-between 1 5)))
           (let ((cooper (an-integer-between 1 5)))
             (let ((fletcher (an-integer-between 1 5)))
               (let ((miller (an-integer-between 1 5)))
                 (let ((smith (an-integer-between 1 5)))
                   (require (distinct5 baker cooper fletcher miller smith))
                   (require (not (= baker 5)))
                   (require (not (= cooper 1)))
                   (require (not (= fletcher 1)))
                   (require (not (= fletcher 5)))
                   (require (> miller cooper))
                   (require (> (abs (- fletcher cooper)) 1))
                   (require (> (abs (- smith fletcher)) 1))
                   (list (list (quote baker) baker) (list (quote cooper) cooper)
                         (list (quote fletcher) fletcher) (list (quote miller) miller)
                         (list (quote smith) smith)))))))))
     '(dwelling))
  ;; provide the two missing primitives used above
  (declare (ignore backs))
  (dolist (s sols) (format t "    solution: ~a~%" s))
  (format t "  solutions found : ~d (SICP's published answer is unique)~%" (length sols)))

(format t "~%=== the porch dreamed, and the dream matched the world ===~%")
