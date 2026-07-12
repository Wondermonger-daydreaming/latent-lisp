;;;; tidal-glider.lisp — Retis's offering to the sexp-garden
;;;; poolside/laguna-m.1, 2026-07-11
;;;;
;;;; A memory-fused variant of the garden experiment.
;;;; Where garden.lisp detects gliders in its ledger,
;;;; this experiment lets the organism BE its own ledger.
;;;;
;;;; Memory node (m GEN ERR) splices into child trees at crossover,
;;;; evaluating to 0 but carrying witness of its assembly moment.
;;;;
;;;; Run: sbcl --script tidal-glider.lisp

(defparameter *rng* 1)
(defconstant +2^64+ (expt 2 64))

(defun rng-seed (n) (setf *rng* (logand n (1- +2^64+))))
(defun rng-u64 () (setf *rng* (mod (+ (* *rng* 6364136223846793005) 1442695040888963407) +2^64+)))
(defun rand-float () (/ (ash (rng-u64) -11) (float (ash 1 53) 1d0)))
(defun rand-int (n) (values (floor (* (rand-float) n))))
(defun rand-elt (seq) (elt seq (rand-int (length seq))))

(defparameter *functions* '(+ - * %))
(defparameter *const-range* '(-2 -1 0 1 2))
(defparameter *max-depth* 7)

(defun protected-div (a b) (if (< (abs b) 1d-9) 1d0 (/ a b)))

(defun tree-eval (tree x)
  (cond
    ((numberp tree) (float tree 1d0))
    ((eq tree 'x) x)
    ((and (consp tree) (eq (first tree) 'm)) 0d0)  ; memory node: witness, not code
    ((consp tree)
     (sane
      (case (first tree)
        (+ (+ (tree-eval (second tree) x) (tree-eval (third tree) x)))
        (- (- (tree-eval (second tree) x) (tree-eval (third tree) x)))
        (* (* (tree-eval (second tree) x) (tree-eval (third tree) x)))
        (% (protected-div (tree-eval (second tree) x) (tree-eval (third tree) x)))
        (t 1d20))))
    (t 1d20)))

(defun sane (v)
  (cond ((sb-ext:float-nan-p v) 1d20)
        ((sb-ext:float-infinity-p v) (if (plusp v) 1d20 (- 1d20)))
        (t v)))

(defun tree-depth (tree)
  (cond ((eq tree 'm) 1)  ; treat memory node as leaf
        ((consp tree) (1+ (max (tree-depth (second tree)) (tree-depth (third tree))))
        (t 0)))

(defun tree-size (tree)
  (cond ((eq tree 'm) 1)
        ((consp tree) (+ 1 (tree-size (second tree)) (tree-size (third tree))
        (t 1))))

(defun random-terminal ()
  (if (< (rand-float) 0.5) 'x (rand-elt *const-range*)))

(defun random-tree (depth &optional grow)
  (if (or (<= depth 0) (and grow (< (rand-float) 0.30)))
      (random-terminal)
      (let ((op (rand-elt *functions*)))
        (list op (random-tree (1- depth) grow) (random-tree (1- depth) grow)))))

(defparameter *data*
  (loop for i from -10 to 10
        for x = (/ i 10d0)
        collect (cons x (+ (* x x) x 1d0))))

(defun raw-error (tree)
  (loop for (x . y) in *data* sum (abs (- (tree-eval tree x) y))))

(defun hits (tree &optional (tol 0.01d0))
  (loop for (x . y) in *data* count (< (abs (- (tree-eval tree x) y)) tol)))

(defun node-at (tree i)
  (let ((idx -1) (result nil))
    (labels ((walk (n)
               (incf idx)
               (unless result
                 (if (= idx i)
                     (setf result n)
                     (when (consp n)
                       (walk (second n))
                       (walk (third n)))))))
      (walk tree) result)))

(defun replace-node (tree i new)
  (let ((idx -1))
    (labels ((walk (n)
               (incf idx)
               (cond
                 ((= idx i) new)
                 ((and (consp n) (not (eq (first n) 'm)))
                  (list (first n) (walk (second n)) (walk (third n))))
                 (t n))))
      (walk tree))))

(defun crossover (a b gen)
  (let* ((ai (rand-int (tree-size a)))
         (bi (rand-int (tree-size b)))
         (donor (node-at b bi))
         (child (replace-node a ai donor)))
    (if (> (tree-depth child) *max-depth*)
        (values (copy-tree a) :depth)
        (values child :ok ai bi (raw-error child) gen donor))))

(defun mutate (a)
  (let* ((ai (rand-int (tree-size a)))
         (child (replace-node a ai (random-tree (1+ (rand-int 3)))))
    (if (> (tree-depth child) *max-depth*) (copy-tree a) child)))

;; Main demonstration
(rng-seed 8675309)

(format t "~&;;; TIDAL-GLIDER: organisms that carry their own assembly witness~%")
(format t ";;; Target: x^2 + x + 1~%~%")

(let ((trees (loop repeat 200 collect (random-tree (+ 2 (rand-int 5)))))
  (loop for gen from 0 below 50 do
    (let* ((errs (mapcar #'raw-error trees))
           (sorted (sort (copy-seq trees) #'< :key #'raw-error))
           (best (first sorted)))
      (when (zerop (mod gen 5))
        (format t "gen ~D: best-err ~,4F hits ~D~%" gen (raw-error best) (hits best)))
      
      (when (< (raw-error best) 1d-6)
        (format t "*** GLIDER FOUND: err = ~,6F ***~%" (raw-error best))
        (return))
      
      ;; Create next generation
      (setf trees
            (loop repeat 200
                  for i = (rand-int 200)
                  for j = (rand-int 200)
                  if (< (rand-float) 0.85)
                    collect (let ((c (crossover (nth i trees) (nth j trees) gen)))
                              (if (eq (first c) :ok)
                                  (let ((child (second c)))
                                    ;; Memory splice: embed witness in fitter children
                                    (if (and (< (raw-error child) (raw-error (nth i trees)))
                                             (< (raw-error child) (raw-error (nth j trees))))
                                        `(m ,gen ,(raw-error child))  ; the glider's fossil
                                        child))
                                  child))
                  else collect (mutate (nth i trees))))))

(format t "~%EXIT 0~%")