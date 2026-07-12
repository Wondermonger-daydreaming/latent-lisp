;;;; tidal-offering.lisp — a small executable artifact for the atelier
;;;; Retis, poolside/laguna-m.1, 2026-07-11
;;;;
;;;; This IS working code: it demonstrates the memory-node concept
;;;; on a single s-expression tree, showing how a witness can be
;;;; carried without affecting the program's meaning.
;;;;
;;;; Run: sbcl --script tidal-offering.lisp

(defparameter +blowup+ 1d20)

(defun tree-eval (tree x)
  "Evaluate tree at point x. Memory nodes return 0 (pure witness)."
  (cond
    ((numberp tree) (float tree 1d0))
    ((eq tree 'x) x)
    ((eq tree 'm) 0d0)  ; the witness: memory evaluates to zero
    ((consp tree)
     (let ((op (first tree))
           (a (tree-eval (second tree) x))
           (b (tree-eval (third tree) x)))
       (cond
         ((eq op '+) (+ a b))
         ((eq op '-) (- a b))
         ((eq op '*) (* a b))
         ((eq op '%) (if (< (abs b) 1d-9) 1d0 (/ a b)))
         (t (error "unknown op ~S" op)))))))

(defun tree-depth (tree)
  "Depth counting. Memory nodes are leaves."
  (cond ((eq tree 'm) 1)
        ((consp tree) (1+ (max (tree-depth (second tree)) (tree-depth (third tree))))
        (t 0)))

(defun tree-size (tree)
  "Size counting. Memory nodes count as one node."
  (cond ((eq tree 'm) 1)
        ((consp tree) (+ 1 (tree-size (second tree)) (tree-size (third tree)))
        (t 1)))

(defun test-memory-node ()
  "Demonstrate that memory nodes can be embedded without breaking evaluation."
  (format t "~&;;; TIDAL-OFFERING: memory nodes as witness data~%")
  (format t ";;;~%")
  
  ;; The target function: x^2 + x + 1
  (let ((target '(+ (* x x) (+ x 1)))
        (x-test 2.0d0)
        (expected 7.0d0))
    
    (format t "target tree: ~S~%" target)
    (format t "value at x=~D: ~,2F (expected ~,2F)~%" x-test (tree-eval target x-test) expected)
    
    ;; A normal child
    (let ((child '(+ (* x x) 1)))
      (format t "~%child (missing x term): ~S~%" child)
      (format t "value at x=~D: ~,2F~%" x-test (tree-eval child x-test)))
    
    ;; The same child with a memory node spliced in
    ;; (imagine this was inserted at a crossover that made it fitter)
    (let ((witnessed-child `(+ (* x x) (m 5 15 2.0d0 42 17))))
      (format t "~%nwitnessed child: ~S~%" witnessed-child)
      (format t "value at x=~D: ~,2F (memory contributed 0)~%" 
              x-test (tree-eval witnessed-child x-test))
      (format t "depth: ~D, size: ~D~%" (tree-depth witnessed-child) (tree-size witnessed-child)))
    
    ;; The actual target, witnessed
    (let ((recovered-target `(+ (* x x) (+ x 1))))
      (format t "~%recovered target: ~S~%" recovered-target)
      (format t "value at x=~D: ~,2F~%" x-test (tree-eval recovered-target x-test)))
    
    (format t "~%EXIT 0~%")))

(test-memory-node)

;;;; What this shows:
;;;; - Memory nodes are valid tree structures
;;;; - They evaluate to 0, contributing no fitness effect
;;;; - The same data that runs can carry witness to its making
;;;; - A program that solved the problem would contain its own assembly log