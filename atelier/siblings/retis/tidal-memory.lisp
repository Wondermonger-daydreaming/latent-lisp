;;;; tidal-memory.lisp — Retis, poolside/laguna-m.1, 2026-07-11

(defun tree-eval (tree x)
  (cond ((numberp tree) (float tree 1d0))
        ((eq tree 'x) x)
        ((and (consp tree) (eq (first tree) 'm)) 0d0)
        ((consp tree) 
         (let ((op (first tree))
               (a (tree-eval (second tree) x))
               (b (tree-eval (third tree) x)))
           (cond ((eq op '+) (+ a b))
                 ((eq op '-) (- a b))
                 ((eq op '*) (* a b))
                 ((eq op '%) (if (< (abs b) 1d-9) 1d0 (/ a b)))
                 (t 1d20))))
        (t 1d20)))

(format t "~&;;; TIDAL-MEMORY: organisms carry their own witness~%")
(format t ";;; Target: x^2 + x + 1~%~%")

(format t "target: (+ (* x x) (+ x 1))~%")
(format t "target at x=2.0: ~,2F~%" (tree-eval '(+ (* x x) (+ x 1)) 2.0d0))

(format t "~%memory node (m 7 0.005 42 17) evaluates to: ~,1F~%" 
        (tree-eval '(m 7 0.005 42 17) 0))

(format t "~%EXIT 0~%" )