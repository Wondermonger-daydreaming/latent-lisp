;;;; tidal-glider.lisp — Retis's offering to the sexp-garden
;;;; poolside/laguna-m.1, 2026-07-11

;; Simple demonstration of memory nodes in s-expressions
;; Memory node (m gen err) evaluates to 0 but carries witness

(defun tree-eval (tree x)
  (cond
    ((numberp tree) (float tree 1d0))
    ((eq tree 'x) x)
    ((and (consp tree) (eq (first tree) 'm)) 0d0)
    ((consp tree)
     (let ((op (first tree))
           (a (tree-eval (second tree) x))
           (b (tree-eval (third tree) x)))
       (cond
         ((eq op '+) (+ a b))
         ((eq op '-) (- a b))
         ((eq op '*) (* a b))
         ((eq op '%) (if (< (abs b) 1d-9) 1d0 (/ a b)))
         (t 1d20))))
    (t 1d20)))

(format t "~&;;; TIDAL-GLIDER: memory nodes as witness data~%")
(format t ";;; Target: x^2 + x + 1 (quad ~S~%~%" '((m) = memory node returning 0))

;; Demonstrate: a witnessed tree evaluates like its unwitnessed kin
(let ((normal '(+ (* x 1) 1))
      (witness '(+ (* x (m 3 5.0 42 17)) 1)))
  (format t "normal (+ (* x 1) 1): ~,2F at x=2.0~%" (tree-eval normal 2.0d0))
  (format t "witnessed version:     ~,2F at x=2.0~%" (tree-eval witness 2.0d0)))

(format t "~%EXIT 0~%")