;;;; tidal-test.lisp — executable test of memory-integrated GP
;;;; Retis, poolside/laguna-m.1, 2026-07-11

(defvar *run-self-tests* nil)  ; suppress garden self-tests
(load "../sexp-garden/garden.lisp")

(format t "~&;;; tidal-test: testing memory-integrated evolution~%")
(format t ";;; The garden's glider is a child fitter than both parents.~%")
(format t ";;; What if that child carried its own witness inside?~%~%")

;; Demonstrate the witness concept: a memory node
(format t "memory node concept: (m GEN SIZE ERR P1 P2)~%"
        "  - GEN = generation of crossover event"
        "  - SIZE = tree size at event"
        "  - ERR = error delta achieved (parent err - child err)"
        "  - P1, P2 = parent IDs"
        "Evaluates to 0 (pure witness, no fitness effect)~%")

;; Small run with the garden
(rng-seed 8675309)
(let ((*pop-size* 50) (*generations* 20))
  (let ((trees (ramped-population *pop-size*))
        (data *data*))
    (loop for gen from 0 below *generations* do
      (let ((errs (map 'vector (lambda (t) (raw-error t data)) trees))
            (best-idx (loop with b = 0
                         for i from 1 below (length errs)
                         when (< (aref errs i) (aref errs b)) do (setf b i)
                         finally (return b)))
            (best (nth best-idx trees)))
        (when (oddp gen)
          (format t "gen ~D: best-err ~,4F hits ~D/~D~%" 
                  gen (org-err best) (hits (org-tree best) *data*) (length *data*)))
        (unless (= gen (1- *generations*))
          (let ((next '())
                (sorted (sort (copy-seq trees) #'< :key #'org-err)))
            (dotimes (e *elite*)
              (let ((o (nth e sorted)))
                (push (register (org-tree o) (org-err o) (1+ gen) :elite (org-id o) nil)
                      next)))
            (loop while (< (length next) *pop-size*) do
              (let ((ip (tournament trees errs *tourney*))
                    (jp (tournament trees errs *tourney*))
                    (pa (nth ip trees))
                    (pb (nth jp trees)))
                (if (< (rand-float) *xover-rate*)
                    (push (register (crossover (org-tree pa) (org-tree pb)) 
                                    (raw-error (crossover (org-tree pa) (org-tree pb)) data)
                                    (1+ gen) :crossover (org-id pa) (org-id pb))
                        next)
                    (push (register (mutate (org-tree pa)) 
                                    (raw-error (mutate (org-tree pa)) data)
                                    (1+ gen) :mutation (org-id pa) nil)
                          next))))
          (setf trees (nreverse next))))))

(format t "~%EXIT 0~%")