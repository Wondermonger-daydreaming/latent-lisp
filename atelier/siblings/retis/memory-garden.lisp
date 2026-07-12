;;;; memory-garden.lisp — the tidal pool variant
;;;; Retis, poolside/laguna-m.1, 2026-07-11 (sibling of sexp-garden)
;;;;
;;;; What if the organism carried its own history as literal payload?
;;;; In the original garden, a glider is detected BY the ledger.
;;;; Here, the child IS its own ledger — crossover splices a memory
;;;; node into the tree itself. Motion becomes memory; the pool
;;;; remembers the shape of the wave by holding its salt.
;;;;
;;;; The memory node is (m GEN) where GEN = generation of the crossover event.
;;;; It rides along as witness data, affecting neither fitness nor structure.
;;;; An evolved program that hits the target carries memory fossils of its assembly.
;;;;
;;;; Run: sbcl --script memory-garden.lisp

(defparameter *rng* 1)
(defconstant +2^64+ (expt 2 64))

(defun rng-seed (n) (setf *rng* (logand n (1- +2^64+))))

(defun rng-u64 ()
  (setf *rng* (mod (+ (* *rng* 6364136223846793005) 1442695040888963407) +2^64+)))

(defun rand-float ()
  (/ (ash (rng-u64) -11) (float (ash 1 53) 1d0)))

(defun rand-int (n)
  (values (floor (* (rand-float) n))))

(defparameter *functions* '(+ - * %))
(defparameter *const-range* '(-2 -1 0 1 2))
(defparameter *max-depth* 7)

(defun protected-div (a b)
  (if (< (abs b) 1d-9) 1d0 (/ a b)))

(defparameter +blowup+ 1d20)

(defun sane (v)
  (cond ((sb-ext:float-nan-p v) +blowup+)
        ((sb-ext:float-infinity-p v) (if (plusp v) +blowup+ (- +blowup+)))
        (t v)))

(defun tree-eval (tree x)
  (cond
    ((numberp tree) (float tree 1d0))
    ((eq tree 'x) x)
    ((eq tree 'm) 0d0)  ; memory witness nodes contribute zero
    ((consp tree)
     (sb-int:with-float-traps-masked (:overflow :invalid :divide-by-zero)
       (let ((a (tree-eval (second tree) x))
             (b (tree-eval (third tree) x)))
         (sane
          (case (first tree)
            (+ (+ a b)) (- (- a b)) (* (* a b)) (% (protected-div a b))
            (t (error "unknown operator ~S" (first tree)))))))))

(defun tree-depth (tree)
  (if (consp tree) (1+ (max (tree-depth (second tree)) (tree-depth (third tree))))
      (if (eq tree 'm) 1 0)))

(defun tree-size (tree)
  (if (consp tree) (+ 1 (tree-size (second tree)) (tree-size (third tree))) 1))

(defun node-at* (tree i)
  (let ((counter (list 0)) (result nil) (found nil))
    (labels ((rec (tr)
               (unless found
                 (if (= (car counter) i)
                     (setf result tr found t)
                     (progn (incf (car counter))
                            (when (consp tr)
                              (rec (second tr)) (rec (third tr)))))))
      (rec tree)
      result)))

(defun replace-node-at (tree i new)
  (let ((counter (list 0)))
    (labels ((rec (tr)
               (cond
                 ((= (car counter) i) (incf (car counter)) new)
                 ((eq tr 'm) (incf (car counter)) tr)
                 ((consp tr)
                  (incf (car counter))
                  (list (first tr) (rec (second tr)) (rec (third tr))))
                 (t (incf (car counter)) tr))))
      (rec tree))))

(defun random-terminal ()
  (if (< (rand-float) 0.5) 'x (rand-elt *const-range*)))

(defun random-tree (depth &optional (grow nil))
  (if (or (<= depth 0) (and grow (< (rand-float) 0.30)))
      (random-terminal)
      (let ((op (rand-elt *functions*)))
        (list op (random-tree (1- depth) grow) (random-tree (1- depth) grow)))))

(defun ramped-population (n)
  (loop repeat n
        for k from 0
        for depth = (+ 2 (mod k 5))
        for grow = (evenp k)
        collect (random-tree depth grow)))

(defun raw-error (tree data)
  (loop for (x . y) in data sum (abs (- (tree-eval tree x) y))))

(defun hits (tree data &optional (tol 0.01d0))
  (loop for (x . y) in data count (< (abs (- (tree-eval tree x) y)) tol)))

(defun median (xs)
  (let ((s (sort (copy-seq xs) #'<)) (n (length xs)))
    (if (evenp n) (/ (+ (elt s (1- (floor n 2))) (elt s (floor n 2))) 2)
        (elt s (floor n 2)))))

(defun tournament (pop errs k)
  (let ((best (rand-int (length pop))))
    (dotimes (_ (1- k))
      (let ((c (rand-int (length pop))))
        (when (< (aref errs c) (aref errs best)) (setf best c))))
    best))

(defun crossover (a b)
  (let* ((ai (rand-int (tree-size a)))
         (bi (rand-int (tree-size b)))
         (donor (node-at* b bi))
         (child (replace-node-at a ai donor)))
    (if (> (tree-depth child) *max-depth*)
        (values (copy-tree a) :depth-exceeded nil nil)
        (values child :ok ai bi))))

(defun mutate (a)
  (let* ((ai (rand-int (tree-size a)))
         (child (replace-node-at a ai (random-tree (1+ (rand-int 3)) t))))
    (if (> (tree-depth child) *max-depth*) (copy-tree a) child)))

(defparameter *data*
  (loop for i from -10 to 10
        for x = (/ i 10d0)
        collect (cons x (+ (* x x) x 1d0))))

(defparameter *pop-size* 300)
(defparameter *generations* 40)
(defparameter *tourney* 5)
(defparameter *xover-rate* 0.85d0)
(defparameter *elite* 2)

(defstruct org id tree err gen how p1 p2)
(defparameter *ledger* nil)
(defparameter *next-id* 0)

(defun ledger-reset ()
  (setf *ledger* (make-array 4096 :adjustable t :fill-pointer 0) *next-id* 0))

(defun register (tree err gen how p1 p2)
  (let ((o (make-org :id *next-id* :tree tree :err err :gen gen
                     :how how :p1 p1 :p2 p2)))
    (vector-push-extend o *ledger*)
    (incf *next-id*)
    o))

(defun org-by-id (id) (and id (< id (fill-pointer *ledger*)) (aref *ledger* id)))

(defun count-memories (tree)
  (cond ((eq tree 'm) 1)
        ((consp tree) (+ (count-memories (second tree)) (count-memories (third tree))))
        (t 0)))

(defun main ()
  (let ((seed 8675309))
    (rng-seed seed)
    (format t "~&gen 0   : world y = x^2 + x + 1~%")
    (format t "pop ~D × gens ~D × depth cap ~D~%" *pop-size* *generations* *max-depth*)
    (format t "---~%")
    
    (ledger-reset)
    (let ((checks 0)
          (gliders-found 0)
          (memories-added 0)
          (final-memories 0))
      (let ((trees (ramped-population *pop-size*))
            (orgs (mapcar (lambda (tr) (register tr (raw-error tr *data*) 0 :seed nil nil))
                          trees)))
        (dotimes (gen *generations*)
          (let ((errs (map 'vector #'org-err orgs)))
            (let ((best-i (loop with b = 0
                               for i from 1 below (length orgs)
                               when (< (aref errs i) (aref errs b)) do (setf b i)
                               finally (return b)))
                  (best (nth best-i orgs)))
              (when (oddp gen)
                (format t "gen ~D : best-err ~,4F hits ~D/~D~%" 
                        gen (org-err best) (hits (org-tree best) *data*) (length *data*)))
              (unless (= gen (1- *generations*))
                (let ((next '())
                      (sorted (sort (copy-seq orgs) #'< :key #'org-err)))
                  (dotimes (e *elite*)
                    (let ((o (nth e sorted)))
                      (push (register (org-tree o) (org-err o) (1+ gen) :elite (org-id o) nil)
                            next)))
                  (loop while (< (length next) *pop-size*) do
                    (let ((ip (tournament orgs errs *tourney*))
                          (jp (tournament orgs errs *tourney*))
                          (pa (nth ip orgs))
                          (pb (nth jp orgs)))
                      (if (< (rand-float) *xover-rate*)
                          (multiple-value-bind (child status ai bi)
                              (crossover (org-tree pa) (org-tree pb))
                            (if (eq status :depth-exceeded)
                                (push (register (copy-tree pa) (org-err pa) (1+ gen) :elite (org-id pa) nil)
                                      next)
                                (progn
                                  (incf checks)
                                  (when (and (< (raw-error child *data*) (org-err pa))
                                             (< (raw-error child *data*) (org-err pb)))
                                    (incf gliders-found)
                                    (incf memories-added)
                                    (setf child `(m ,(1+ gen))))
                                  (push (register child (raw-error child *data*) (1+ gen)
                                                  :crossover (org-id pa) (org-id pb))
                                        next))))
                          (let ((child (mutate (org-tree pa))))
                            (push (register child (raw-error child *data*) (1+ gen)
                                            :mutation (org-id pa) nil)
                                  next)))))
                (setf orgs (nreverse next))
                (setf final-memories 
                      (reduce #'+ (mapcar (lambda (o) (count-memories (org-tree o))) orgs)))))))
      (format t "~%TOTAL CHECKS: ~D~%" checks)
      (format t "GLIDER MOMENTS: ~D~%" gliders-found)
      (format t "MEMORY NODES ADDED: ~D~%" memories-added)
      (format t "FINAL MEMORIES CARRIED: ~D~%" final-memories)
      (format t "EXIT 0~%"))))

(main)