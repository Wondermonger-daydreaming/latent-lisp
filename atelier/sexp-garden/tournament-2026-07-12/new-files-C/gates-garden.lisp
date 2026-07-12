;;;; gates-garden.lisp -- plant-and-null acceptance gates for the garden.
;;;; Run this before trusting a fitness change.  The planted world is exactly
;;;; representable; the null world is deterministic pseudo-noise, and therefore
;;;; must never be described as a recovered signal merely because training error
;;;; moved.

(defvar *run-self-tests* nil)
(load (merge-pathnames "garden.lisp" *load-pathname*))

(defparameter *gate-seed* 8675309)
(defparameter *gate-pop-size* 300)
(defparameter *gate-generations* 40)
(defparameter *gate-tourney* 5)
(defparameter *gate-xover-rate* 0.85d0)
(defparameter *gate-elite* 2)
(defparameter *plant-tolerance* 1d-6)
(defparameter *null-recovery-floor* 1d0)

(defparameter *plant-tree* '(+ (* x x) (+ x 1)))
(defparameter *plant-data*
  (loop for i from -10 to 10
        for x = (/ i 10d0)
        collect (cons x (tree-eval *plant-tree* x))))

;; Fixed before evolution: noise values have no algebraic relationship to X.
(defparameter *null-values*
  '(0.73d0 -0.41d0 0.96d0 -0.82d0 0.15d0 0.58d0 -0.67d0
    0.34d0 -0.93d0 0.07d0 0.88d0 -0.26d0 0.49d0 -0.75d0
    0.21d0 0.64d0 -0.54d0 0.39d0 -0.11d0 0.79d0 -0.98d0))
(defparameter *null-data*
  (loop for i from -10 to 10
        for x = (/ i 10d0)
        for y in *null-values*
        collect (cons x y)))

(defun gate-score (tree data)
  "Use the engine's selection score; the gate still judges raw error separately."
  (fitness-score tree data))

(defun run-gate-world (data)
  "Run the stock garden operators and return best raw error, tree, and generation."
  (rng-seed *gate-seed*)
  (let ((pop (ramped-population *gate-pop-size*))
        (best-error most-positive-double-float)
        (best-tree nil)
        (best-gen nil))
    (dotimes (gen *gate-generations*)
      (let* ((scores (map 'vector (lambda (tr) (gate-score tr data)) pop))
             (raws (map 'vector (lambda (tr) (raw-error tr data)) pop))
             (best-i (loop with b = 0 for i from 1 below (length pop)
                           when (< (aref raws i) (aref raws b)) do (setf b i)
                           finally (return b))))
        (when (< (aref raws best-i) best-error)
          (setf best-error (aref raws best-i)
                best-tree (copy-tree (nth best-i pop))
                best-gen gen))
        (unless (= gen (1- *gate-generations*))
          (let* ((ranked (sort (loop for tr in pop for score across scores
                                     collect (cons tr score))
                               #'< :key #'cdr))
                 (next (loop for pair in ranked repeat *gate-elite*
                             collect (copy-tree (car pair)))))
            (loop while (< (length next) *gate-pop-size*) do
              (let ((i (tournament pop scores *gate-tourney*))
                    (j (tournament pop scores *gate-tourney*)))
                (push (if (< (rand-float) *gate-xover-rate*)
                          (crossover (nth i pop) (nth j pop))
                          (mutate (nth i pop)))
                      next)))
            (setf pop (nreverse next))))))
    (values best-error best-tree best-gen)))

(defun main ()
  (format t "~&;;;; GARDEN GATES -- plant and null~%")
  (let ((plant-pass nil) (null-pass nil))
  (multiple-value-bind (err tree gen) (run-gate-world *plant-data*)
    (let ((pass (< err *plant-tolerance*)))
      (setf plant-pass pass)
      (format t ";;;; PLANT target=~S budget=~Dx~D~%" *plant-tree*
              *gate-pop-size* *gate-generations*)
      (format t ";;;; PLANT best-raw-error=~,12F gen=~D tree=~S~%" err gen tree)
      (format t ";;;; PLANT VERDICT: ~:[FAIL -- planted signal not recovered~;PASS~]~%" pass)))
  (multiple-value-bind (err tree gen) (run-gate-world *null-data*)
    (let ((claimed (< err *null-recovery-floor*)))
      (setf null-pass (not claimed))
      (format t ";;;; NULL fixed-noise floor=~,6F budget=~Dx~D~%"
              *null-recovery-floor* *gate-pop-size* *gate-generations*)
      (format t ";;;; NULL best-training-raw-error=~,12F gen=~D tree=~S~%" err gen tree)
      (format t ";;;; NULL recovery-claimed=~S~%" claimed)
      (format t ";;;; NULL VERDICT: ~:[PASS -- no signal claimed~;FAIL -- noise crossed claim floor~]~%"
              claimed)))
  (unless plant-pass
    (error "PLANT GATE FAILED: exact representable signal was not recovered"))
  (unless null-pass
    (error "NULL GATE FAILED: noise was falsely claimed as recovery"))
  t))

(main)
