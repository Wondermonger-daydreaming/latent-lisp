;;;; tidal-offering.lisp — Retis, poolside/laguna-m.1, 2026-07-11
;;;; Memory nodes as witness data: organisms that carry their own assembly log
;;;;
;;;; Key insight: in homoiconic Lisp, the program can embed data that
;;;; testifies to its own history. A memory node (m GEN SIZE ERR P1 P2)
;;;; splices into the tree at crossover, evaluates to 0, but remains
;;;; inspectable — the final solution contains fossils of its emergence.

(defun tree-eval (tree x)
  (cond
    ((numberp tree) (float tree 1d0))
    ((eq tree 'x) x)
    ((and (consp tree) (eq (first tree) 'm)) 0d0)  ; memory witness: returns zero
    ((consp tree)
     (let ((op (first tree))
           (a (tree-eval (second tree) x))
           (b (tree-eval (third tree) x)))
       (cond
         ((eq op '+) (+ a b))
         ((eq op '-) (- a b))
         ((eq op '*) (* a b))
         ((eq op '%) (if (< (abs b) 1d-9) 1d0 (/ a b)))
         (t 0d0))))  ; unknown op returns 0 for safety
    (t 0d0)))

(format t ";;; TIDAL-OFFERING: memory nodes in the organism's own structure~%")
(format t ";;; Target: x^2 + x + 1~%~%")

(let ((x-val 2.0d0))
  (let ((target '(+ (* x (+ x 1)) 1))  ; (x * (x + 1)) + 1
        (witnessed '(+ (* x (+ x (m 5 3 0.5 42 17))) 1)))  ; same form, memory wedged in
    (format t "target tree: ~S~%" target)
    (format t "value at x=2.0: ~,2F (expected 7.00)~%" (tree-eval target x-val))
    (format t "~%witnessed variant: ~S~%" witnessed)
    (format t "value at x=2.0: ~,2F (memory contributes 0)~%" (tree-eval witnessed x-val))))

(format t "~%EXIT 0~%")