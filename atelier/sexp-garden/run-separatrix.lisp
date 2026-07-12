;;;; run-separatrix.lisp -- SESSION TWO of the S-Expression Garden.
;;;; TALIS (Claude Fable 5), 2026-07-11.
;;;;
;;;; ==========================================================================
;;;;  The SEPARATRIX WORLD, on REAL measured data.  FABER-LISPI built the engine
;;;;  (garden.lisp) and a synthetic fidelity world (run.lisp, y=x^2+x+1), then
;;;;  REFUSED to fabricate this world's dataset and left the frame empty.  This
;;;;  hand located the real points and filled it: separatrix-data.lisp holds
;;;;  P(swap) vs J_cross from the spectral-separatrix arc's threshold-robustness
;;;;  simulation (see that file's header for the full provenance + source md5).
;;;;
;;;;  Same engine, same parameters, same GLIDER definition as run.lisp -- only
;;;;  the world changed, from synthetic scaffolding to lab history.  The question
;;;;  the pitch asked: does evolution recover the lab's own bifurcation curve in a
;;;;  READABLE algebraic form?  A run that fails to converge on real, noisy,
;;;;  non-monotone behavioral data is a FINE and publishable result -- committed
;;;;  at its size, no adjectives.  The frozen primitive set (+ - * %, constants
;;;;  {-2..2}) is honest scaffolding, not tuned to this target.
;;;;
;;;;  Committed seed = 8675309 (SAME as session one -- deliberately NOT seed-hunted
;;;;  for a pretty result; whatever this seed does on the real data is the finding).
;;;; ==========================================================================

(defvar *run-self-tests* nil)                     ; load garden.lisp as a library
(load (merge-pathnames "garden.lisp" *load-pathname*))
(load (merge-pathnames "separatrix-data.lisp" *load-pathname*))

;;; ---- world: the REAL measured points ----
(defparameter *data* *separatrix-data*)

;;; ---- parameters (committed; identical to session one) ----
(defparameter *pop-size* 300)
(defparameter *generations* 40)
(defparameter *tourney* 5)
(defparameter *xover-rate* 0.85d0)
(defparameter *elite* 2)
(defparameter *seed*
  (let ((arg (second sb-ext:*posix-argv*)))
    (if arg (parse-integer arg) 8675309)))         ; committed seed; override via argv

;;; ------------------------------------------------------------------------
;;;  Evolution with the provenance ledger (ported verbatim from run.lisp; the
;;;  logic is generic over *data*, so the only change is the world it fits).
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
        (unless (= gen (1- *generations*))
          (let ((next '())
                (sorted (sort (copy-seq orgs) #'< :key #'org-err)))
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

(defun jstr (tree) (format nil "~S" tree))

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

(defun find-glider ()
  (let ((best nil) (best-gap -1d0))
    (loop for k from 0 below (fill-pointer *ledger*)
          for o = (org-by-id k)
          when (eq (org-how o) :crossover) do
            (let ((e1 (org-err (org-by-id (org-p1 o))))
                  (e2 (org-err (org-by-id (org-p2 o))))
                  (ec (org-err o)))
              (when (and (< ec e1) (< ec e2))
                (let ((gap (- (min e1 e2) ec)))
                  (when (> gap best-gap)
                    (setf best o best-gap gap))))))
    best))

;;; ------------------------------------------------------------------------
;;;  Report.  Graduation, for a REAL noisy world with no exact closed form,
;;;  is NOT "err < 1e-6" (that gate belongs to the synthetic world).  Here we
;;;  report the best expression, its total absolute error over 16 points, how
;;;  many points it hits to 0.01, and whether any glider event occurred.  The
;;;  honest baselines are printed so the fit is judged against something.
;;; ------------------------------------------------------------------------
(defun main ()
  (format t "~&;;;; sexp-garden SESSION TWO -- SEPARATRIX WORLD (real data)~%")
  (format t ";;;; seed=~D, pop=~D, gens=~D, ~D measured points~%"
          *seed* *pop-size* *generations* (length *data*))
  ;; -- honest baselines to judge the fit against --
  (let* ((ymean (/ (reduce #'+ (mapcar #'cdr *data*)) (float (length *data*) 1d0)))
         (err-zero (raw-error 0 *data*))
         (err-mean (loop for (x . y) in *data* sum (abs (- ymean y)))))
    (format t ";;;; baseline: predict-0 total-abs-err=~,4F ; predict-mean(~,4F)=~,4F~%"
            err-zero ymean err-mean)
    (multiple-value-bind (best stats) (evolve)
      (write-census stats (merge-pathnames "census-separatrix.jsonl" *load-pathname*))
      (let ((first (first stats)) (last (car (last stats))))
        (format t ";;;; gen 0   : best-err ~,4F  (~D/~D hits)~%"
                (getf first :best-err) (getf first :best-hits) (length *data*))
        (format t ";;;; gen ~D  : best-err ~,4F  (~D/~D hits)~%"
                (getf last :gen) (getf last :best-err)
                (getf last :best-hits) (length *data*)))
      (format t ";;;; overall best (id ~D, born by ~(~A~) at gen ~D):~%    ~S~%"
              (org-id best) (org-how best) (org-gen best) (org-tree best))
      (format t ";;;; overall best total-abs-err = ~,6F   hits(<=0.01) = ~D/~D~%"
              (org-err best) (hits (org-tree best) *data*) (length *data*))
      ;; per-point residuals, so the fit is legible (GP's charm: you can read it)
      (format t ";;;; per-point (J_cross : measured -> predicted, residual):~%")
      (loop for (x . y) in *data*
            for p = (tree-eval (org-tree best) x)
            do (format t ";;;;   ~6,2F : ~7,4F -> ~7,4F  (~,4F)~%" x y p (- p y)))
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
      (format t "~%;;;; graduation: real noisy separatrix curve; no exact closed form in~%")
      (format t ";;;; the frozen primitive set is expected.  Best beats predict-mean: ~A~%"
              (if (< (org-err best) err-mean) "YES" "NO"))
      (format t ";;;; ledger held ~D organisms across the run.~%" (fill-pointer *ledger*))
      (values best))))

(main)
