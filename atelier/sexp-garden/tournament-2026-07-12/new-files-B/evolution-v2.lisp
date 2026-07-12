;;;; evolution-v2.lisp -- scoring, selection pressure, and stagnation policy.

(defstruct scored-org org error size selection-key)

;;; Concern 1: scoring.  Only this function meets the dataset.
(defun score-tree (tree data) (raw-error tree data))

;;; Concern 2: selection.  Lambda affects reproduction, never reported error.
(defparameter *parsimony-lambda* 0.001d0)
(defun error-plus-parsimony (error size lambda) (+ error (* lambda size)))
(defparameter *selection-pressure* #'error-plus-parsimony)
(defun selection-key (error size)
  (funcall *selection-pressure* error size *parsimony-lambda*))

(defun score-org (org)
  (let ((size (tree-size (org-tree org))))
    (make-scored-org :org org :error (org-err org) :size size
                     :selection-key (selection-key (org-err org) size))))

(defun tournament-by-pressure (scored k)
  (let ((best (rand-int (length scored))))
    (dotimes (_ (1- k))
      (let ((candidate (rand-int (length scored))))
        (when (< (scored-org-selection-key (nth candidate scored))
                 (scored-org-selection-key (nth best scored)))
          (setf best candidate))))
    best))

;;; Concern 3: restart.  A strategy maps (generation champion population) to
;;; replacement trees.  This one looks only at output vectors, never syntax.
(defparameter *restart-after* 6)
(defparameter *restart-candidate-multiplier* 6)
(defparameter *restart-min-output-distance* 0.03d0)
(defparameter *restart-max-output-distance* 0.35d0)

(defun output-vector (tree data)
  (mapcar (lambda (point) (tree-eval tree (car point))) data))
(defun behavior-distance (left right)
  (/ (loop for a in left for b in right sum (abs (- a b)))
     (float (length left) 1d0)))

(defun behavior-annulus-restart (generation champion population)
  (declare (ignore generation))
  (let* ((wanted (- (length population) *elite*))
         (champion-output (output-vector (org-tree champion) *data*))
         (pool (ramped-population (* wanted *restart-candidate-multiplier*)))
         (ranked
           (sort (mapcar (lambda (tree)
                           (cons (behavior-distance
                                  (output-vector tree *data*) champion-output)
                                 tree)) pool)
                 #'< :key
                 (lambda (item)
                   (let ((d (car item)))
                     (cond ((< d *restart-min-output-distance*)
                            (- *restart-min-output-distance* d))
                           ((> d *restart-max-output-distance*)
                            (- d *restart-max-output-distance*))
                           (t 0d0)))))))
    (mapcar #'cdr (subseq ranked 0 wanted))))

(defparameter *restart-strategy* #'behavior-annulus-restart)

(defun make-org-from-tree (tree gen how &optional p1 p2)
  (register tree (score-tree tree *data*) gen how p1 p2))
(defun best-by-error (orgs)
  (reduce (lambda (a b) (if (< (org-err a) (org-err b)) a b)) orgs))

(defun generation-stat (gen orgs barren restart-p)
  (let* ((best (best-by-error orgs)) (errors (mapcar #'org-err orgs))
         (best-size (tree-size (org-tree best))))
    (list :gen gen :best-err (org-err best)
          :median-err (float (median errors) 1d0)
          :mean-size (/ (reduce #'+ orgs :key
                                (lambda (o) (tree-size (org-tree o))))
                        (float (length orgs) 1d0))
          :best-size best-size
          :best-selection-key (selection-key (org-err best) best-size)
          :best-hits (hits (org-tree best) *data*) :best-tree (org-tree best)
          :best-id (org-id best) :best-how (org-how best)
          :barren barren :restart restart-p)))

(defun breed-generation (orgs gen)
  (let* ((scored (mapcar #'score-org orgs))
         (ranked (sort (copy-list scored) #'< :key #'scored-org-selection-key))
         (next '()))
    (dotimes (e *elite*)
      (let ((parent (scored-org-org (nth e ranked))))
        (push (make-org-from-tree (copy-tree (org-tree parent)) gen :elite
                                  (org-id parent)) next)))
    (loop while (< (length next) *pop-size*) do
      (let* ((pa (scored-org-org
                  (nth (tournament-by-pressure scored *tourney*) scored)))
             (pb (scored-org-org
                  (nth (tournament-by-pressure scored *tourney*) scored))))
        (if (< (rand-float) *xover-rate*)
            (push (make-org-from-tree
                   (crossover (org-tree pa) (org-tree pb)) gen :crossover
                   (org-id pa) (org-id pb)) next)
            (push (make-org-from-tree (mutate (org-tree pa)) gen :mutation
                                      (org-id pa)) next))))
    (nreverse next)))

(defun restart-generation (orgs champion gen)
  (let* ((ranked (sort (mapcar #'score-org orgs) #'<
                       :key #'scored-org-selection-key))
         (elites (loop for e below *elite*
                       for parent = (scored-org-org (nth e ranked))
                       collect (make-org-from-tree (copy-tree (org-tree parent))
                                                   gen :elite (org-id parent))))
         (reseeds (funcall *restart-strategy* gen champion orgs)))
    (nconc elites (mapcar (lambda (tree) (make-org-from-tree tree gen :restart))
                          reseeds))))

(defun evolve-v2 ()
  (ledger-reset) (rng-seed *seed*)
  (let ((orgs (mapcar (lambda (tree) (make-org-from-tree tree 0 :seed))
                      (ramped-population *pop-size*)))
        (stats '()) (events '()) (overall-best nil) (barren 0))
    (dotimes (gen *generations*)
      (let ((best (best-by-error orgs)))
        (if (or (null overall-best) (< (org-err best) (org-err overall-best)))
            (setf overall-best best barren 0)
            (incf barren))
        (let ((restart-p (and (< gen (1- *generations*))
                              (>= barren *restart-after*))))
          (push (generation-stat gen orgs barren restart-p) stats)
          (when restart-p
            (push (list :gen gen :barren barren :champion-id (org-id overall-best)
                        :champion-error (org-err overall-best)
                        :strategy 'behavior-annulus-restart) events))
          (unless (= gen (1- *generations*))
            (if restart-p
                (setf orgs (restart-generation orgs overall-best (1+ gen)) barren 0)
                (setf orgs (breed-generation orgs (1+ gen))))))))
    (values overall-best (nreverse stats) (nreverse events))))
