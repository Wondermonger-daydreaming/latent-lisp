;;;; run.lisp — one seeded evolution in the S-Expression Garden
;;;; FABER-LISPI, 2026-07-11.
;;;;
;;;; ==========================================================================
;;;;  Runs ONE full GP run on a declared-synthetic symbolic-regression world,
;;;;  with the organism ledger on (§6 of garden.lisp), so the run's history is
;;;;  auditable.  Writes census.jsonl (one line per generation) and, if the run
;;;;  contained a GLIDER MOMENT (a crossover child strictly fitter than both its
;;;;  parents), prints and files that event's full lineage.
;;;;
;;;;  The SEED is committed below.  Same seed -> identical run: the reproducibility
;;;;  claim garden.lisp's self-tests enforce, exercised here in the large.
;;;;
;;;;  THE WORLD (declared synthetic — NOT lab data).  Target y = x^2 + x + 1 on
;;;;  21 points x in [-1,1].  A clean, recoverable Koza-class target used as the
;;;;  garden's fidelity world.  The pitch's separatrix world (J_cross* ~ 0.3485)
;;;;  is DEFERRED to session two: it needs the actual measured dataset, which
;;;;  this hand will not fabricate (data-integrity).  See NOTES.md.
;;;; ==========================================================================

(defvar *run-self-tests* nil)          ; load garden.lisp as a library, quietly
(load (merge-pathnames "garden.lisp" *load-pathname*))

;;; ---- world ----
(defparameter *data*
  (loop for i from -10 to 10
        for x = (/ i 10d0)
        collect (cons x (+ (* x x) x 1d0))))

;;; ---- parameters (committed) ----
(defparameter *pop-size* 300)
(defparameter *generations* 40)
(defparameter *tourney* 5)
(defparameter *xover-rate* 0.85d0)
(defparameter *elite* 2)
(defparameter *seed*
  (let ((arg (second sb-ext:*posix-argv*)))
    (if arg (parse-integer arg) 8675309)))   ; committed seed; override via argv

;;; ------------------------------------------------------------------------
;;;  Evolution, with the ledger recording provenance of every organism.
;;;  Returns (values best-org gen-stats), where gen-stats is a list of plists.
;;; ------------------------------------------------------------------------
(defun evolve ()
  (ledger-reset)
  (rng-seed *seed*)
  (let* ((trees (ramped-population *pop-size*))
         (orgs (mapcar (lambda (tr) (register tr (raw-error tr *data*) 0 :seed nil nil))
                       trees))
         (stats '())
         (overall-best nil))
    (dotimes (gen *generations*)
      (let* ((errs (map 'vector #'org-err orgs))
             (best-i (loop with b = 0 for i from 1 below (length orgs)
                           when (< (aref errs i) (aref errs b)) do (setf b i)
                           finally (return b)))
             (best (nth best-i orgs)))
        (when (or (null overall-best) (< (org-err best) (org-err overall-best)))
          (setf overall-best best))
        (push (list :gen gen
                    :best-err (org-err best)
                    :median-err (float (median (coerce errs 'list)) 1d0)
                    :mean-size (/ (reduce #'+ (mapcar (lambda (o) (tree-size (org-tree o))) orgs))
                                  (float (length orgs) 1d0))
                    :best-hits (hits (org-tree best) *data*)
                    :best-tree (org-tree best)
                    :best-id (org-id best)
                    :best-how (org-how best))
              stats)
        ;; -- build next generation --
        (unless (= gen (1- *generations*))
          (let ((next '())
                (sorted (sort (copy-seq orgs) #'< :key #'org-err)))
            ;; elitism: carry the *elite* best, re-registered as :elite this gen
            (dotimes (e *elite*)
              (let ((o (nth e sorted)))
                (push (register (org-tree o) (org-err o) (1+ gen) :elite (org-id o) nil)
                      next)))
            (loop while (< (length next) *pop-size*) do
              (let ((ip (tournament orgs errs *tourney*))
                    (jp (tournament orgs errs *tourney*)))
                (if (< (rand-float) *xover-rate*)
                    (let* ((pa (nth ip orgs)) (pb (nth jp orgs))
                           (child (crossover (org-tree pa) (org-tree pb))))
                      (push (register child (raw-error child *data*) (1+ gen)
                                      :crossover (org-id pa) (org-id pb))
                            next))
                    (let* ((pa (nth ip orgs))
                           (child (mutate (org-tree pa))))
                      (push (register child (raw-error child *data*) (1+ gen)
                                      :mutation (org-id pa) nil)
                            next)))))
            (setf orgs (nreverse next))))))
    (values overall-best (nreverse stats))))

;;; ------------------------------------------------------------------------
;;;  Census — one JSONL line per generation.
;;; ------------------------------------------------------------------------
(defun jstr (tree) (format nil "~S" tree))   ; the tree, printed as itself

(defun write-census (stats path)
  (with-open-file (s path :direction :output :if-exists :supersede
                          :if-does-not-exist :create)
    (dolist (st stats)
      (format s "{\"gen\":~D,\"best_error\":~,6F,\"median_error\":~,6F,~
                 \"mean_size\":~,3F,\"best_hits\":~D,\"best_how\":\"~(~A~)\",~
                 \"best_tree\":~S}~%"
              (getf st :gen) (getf st :best-err) (getf st :median-err)
              (getf st :mean-size) (getf st :best-hits) (getf st :best-how)
              (jstr (getf st :best-tree))))))

;;; ------------------------------------------------------------------------
;;;  §6 realised: find the GLIDER MOMENT.  Over every crossover organism in the
;;;  ledger, keep those strictly fitter than BOTH parents.  The glider of the
;;;  run is the one with the largest gap to its WORSE parent (the biggest leap
;;;  assembled from material neither parent could match).  Returns the org, or
;;;  nil if the run had no such event.
;;; ------------------------------------------------------------------------
(defun find-glider ()
  (let ((best nil) (best-gap -1d0))
    (loop for k from 0 below (fill-pointer *ledger*)
          for o = (org-by-id k)
          when (eq (org-how o) :crossover) do
            (let ((e1 (org-err (org-by-id (org-p1 o))))
                  (e2 (org-err (org-by-id (org-p2 o))))
                  (ec (org-err o)))
              (when (and (< ec e1) (< ec e2))
                (let ((gap (- (min e1 e2) ec)))    ; leap past the BETTER parent
                  (when (> gap best-gap)
                    (setf best o best-gap gap))))))
    best))

;;; ------------------------------------------------------------------------
;;;  First recovery: the EARLIEST organism to fit the target (err < 1e-6).
;;;  This is the pitch's true money-shot — the generation and the crossover
;;;  event that first ASSEMBLED the working expression.  We trace its lineage.
;;; ------------------------------------------------------------------------
(defun find-first-recovery (&optional (tol 1d-6))
  (let ((best nil))
    (loop for k from 0 below (fill-pointer *ledger*)
          for o = (org-by-id k)
          when (< (org-err o) tol) do
            (when (or (null best) (< (org-gen o) (org-gen best))) (setf best o)))
    best))

;;; ------------------------------------------------------------------------
;;;  Report.
;;; ------------------------------------------------------------------------
(defun main ()
  (format t "~&;;;; sexp-garden — seeded run, seed=~D, pop=~D, gens=~D~%"
          *seed* *pop-size* *generations*)
  (multiple-value-bind (best stats) (evolve)
    (write-census stats (merge-pathnames "census.jsonl" *load-pathname*))
    (let ((first (first stats)) (last (car (last stats))))
      (format t ";;;; gen 0   : best-error ~,4F  (~D/~D hits)~%"
              (getf first :best-err) (getf first :best-hits) (length *data*))
      (format t ";;;; gen ~D  : best-error ~,4F  (~D/~D hits)~%"
              (getf last :gen) (getf last :best-err)
              (getf last :best-hits) (length *data*)))
    (format t ";;;; overall best (id ~D, born by ~(~A~) at gen ~D):~%    ~S~%"
            (org-id best) (org-how best) (org-gen best) (org-tree best))
    (format t ";;;; overall best error = ~,8F   hits = ~D/~D~%"
            (org-err best) (hits (org-tree best) *data*) (length *data*))
    ;; -- the glider --
    (let ((g (find-glider)))
      (if g
          (let ((p1 (org-by-id (org-p1 g))) (p2 (org-by-id (org-p2 g))))
            (format t "~%;;;; ================  GLIDER MOMENT  ================~%")
            (format t ";;;; gen ~D: a crossover child STRICTLY fitter than both parents.~%"
                    (org-gen g))
            (format t ";;;;   parent A (id ~D, err ~,4F): ~S~%"
                    (org-id p1) (org-err p1) (org-tree p1))
            (format t ";;;;   parent B (id ~D, err ~,4F): ~S~%"
                    (org-id p2) (org-err p2) (org-tree p2))
            (format t ";;;;   child    (id ~D, err ~,4F): ~S~%"
                    (org-id g) (org-err g) (org-tree g))
            (format t ";;;;   leap past the BETTER parent: ~,4F~%"
                    (- (min (org-err p1) (org-err p2)) (org-err g)))
            (format t ";;;; A capability assembled by one crossover, on record.~%"))
          (format t "~%;;;; no glider moment this run (no crossover child beat both~%~
                       ;;;; its parents).  Honest null; the boring runs get committed too.~%")))
    ;; -- the first recovery and its assembly lineage --
    (let ((r (find-first-recovery)))
      (when r
        (format t "~%;;;; ----------  FIRST RECOVERY (the target assembled)  ----------~%")
        (format t ";;;; gen ~D, born by ~(~A~):  ~S   (err ~,2E)~%"
                (org-gen r) (org-how r) (org-tree r) (org-err r))
        (when (eq (org-how r) :crossover)
          (let ((p1 (org-by-id (org-p1 r))) (p2 (org-by-id (org-p2 r))))
            (format t ";;;;   from parent A (id ~D, err ~,4F): ~S~%"
                    (org-id p1) (org-err p1) (org-tree p1))
            (format t ";;;;   from parent B (id ~D, err ~,4F): ~S~%"
                    (org-id p2) (org-err p2) (org-tree p2))
            (format t ";;;;   NEITHER parent fit the target; one crossover assembled it.~%")))))
    ;; -- graduation gate: did the run RECOVER the target? --
    (let ((solved (< (org-err best) 1d-6)))
      (format t "~%;;;; graduation: target ~A (best error ~,2E)~%"
              (if solved "RECOVERED" "not recovered") (org-err best))
      (unless (= (fill-pointer *ledger*) 0)
        (format t ";;;; ledger held ~D organisms across the run.~%"
                (fill-pointer *ledger*)))
      (values best solved))))

(main)
