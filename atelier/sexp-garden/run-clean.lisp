;;;; run-clean.lisp — can RECOVERY become DISCOVERY?  (2026-07-12, Opus 4.8, carte blanche)
;;;;
;;;; ==========================================================================
;;;;  THE QUESTION (born from HERBARIUM-fidelity-2026-07-12.md + the basin
;;;;  "Carried and Regenerated"): the garden recovers y = x²+x+1 EXACTLY, but by
;;;;  a GUARD-HACK — `(% X 0)` evaluates to 1 only because protected division was
;;;;  defined total, so the garden smuggles the "+1" through a division-by-zero.
;;;;  Recovery is not cleanliness.  This run adds a fitness pressure that PENALIZES
;;;;  reliance on the guard, and asks: does the garden then find the CLEAN
;;;;  expression (+ (* X X) (+ X 1)) — one that never divides by zero — or does the
;;;;  penalty starve the search?
;;;;
;;;;  THE PENALTY (principled, not arbitrary): instrument protected-div to COUNT
;;;;  how many times its zero-guard actually FIRES across the dataset.  A clean
;;;;  expression triggers the guard 0 times; a guard-hack triggers it constantly.
;;;;  Selection fitness = true-error + λ · guard-fires.  (λ = 1.0; one full-dataset
;;;;  cheat costs 21.)  TRUE error is still reported separately, so "recovery" and
;;;;  "cleanliness" are two distinct measured columns, never conflated.
;;;;
;;;;  ------------------------------------------------------------------------
;;;;  PRE-REGISTERED BANDS (frozen before reading any result; git ts = the proof):
;;;;    CLEAN-DISCOVERY : best recovers target (true-err < 1e-6) AND guard-fires = 0
;;;;                      → the penalty turned recovery into discovery. The win.
;;;;    STILL-CHEATS    : best recovers (true-err < 1e-6) but guard-fires > 0
;;;;                      → penalty insufficient; the hack survived the pressure.
;;;;    STARVED (NULL)  : best does NOT recover (true-err ≥ 1e-6) under the penalty
;;;;                      → the guard was load-bearing scaffolding; pressure broke
;;;;                        search. A publishable null — pressed without apology.
;;;;    (reported per-seed across the same 8 seeds as the fidelity sweep.)
;;;;  Honesty rail inherited from PITCH.md: the boring/failed runs get committed too.
;;;; ==========================================================================

(defvar *run-self-tests* nil)
(load (merge-pathnames "garden.lisp" *load-pathname*))

;;; ---- the world (same recoverable target as run.lisp) ----
(defparameter *data*
  (loop for i from -10 to 10 for x = (/ i 10d0)
        collect (cons x (+ (* x x) x 1d0))))

;;; ---- guard instrumentation: redefine protected-div to count zero-guard fires ----
(defparameter *guard-fires* 0)
(defun protected-div (a b)
  "Total division that COUNTS when the zero-guard actually saves it."
  (if (< (abs b) 1d-9) (progn (incf *guard-fires*) 1d0) (/ a b)))

;; λ defaults to 1.0 (the pre-registered value); optional argv[2] overrides it for the
;; threshold sweep (a MODE, not a fork — a bare `run-clean.lisp <seed>` is BEHAVIORALLY
;; unchanged, i.e. resolves λ=1.0 exactly as before; the script's own bytes did change.
;; [wording corrected per Sol's critique, 2026-07-12: "byte-unchanged" was wrong.])
(defparameter *lambda*
  (let ((arg (third sb-ext:*posix-argv*)))
    (if arg (let ((*read-default-float-format* 'double-float)) (read-from-string arg)) 1.0d0)))

(defun guard-fires-of (tree data)
  "Evaluate TREE across DATA, return how many times the zero-guard fired."
  (setf *guard-fires* 0)
  (dolist (pt data) (tree-eval tree (car pt)))
  *guard-fires*)

(defun clean-fitness (tree data)
  "Selection fitness: true error + λ · guard-fires. Lower is better."
  (+ (raw-error tree data) (* *lambda* (guard-fires-of tree data))))

;;; ---- parameters ----
(defparameter *pop-size* 300)
(defparameter *generations* 40)
(defparameter *tourney* 5)
(defparameter *xover-rate* 0.85d0)
(defparameter *elite* 2)
(defparameter *seed*
  (let ((arg (second sb-ext:*posix-argv*))) (if arg (parse-integer arg) 20260712)))

;;; ---- evolve, selecting on clean-fitness (org-err holds the PENALIZED fitness) ----
(defun evolve-clean ()
  (ledger-reset)
  (rng-seed *seed*)
  (let* ((trees (ramped-population *pop-size*))
         (orgs (mapcar (lambda (tr) (register tr (clean-fitness tr *data*) 0 :seed nil nil)) trees))
         (overall-best nil))
    (dotimes (gen *generations*)
      (let* ((errs (map 'vector #'org-err orgs))
             (best-i (loop with b = 0 for i from 1 below (length orgs)
                           when (< (aref errs i) (aref errs b)) do (setf b i) finally (return b)))
             (best (nth best-i orgs)))
        (when (or (null overall-best) (< (org-err best) (org-err overall-best)))
          (setf overall-best best))
        (unless (= gen (1- *generations*))
          (let ((next '()) (sorted (sort (copy-seq orgs) #'< :key #'org-err)))
            (dotimes (e *elite*)
              (let ((o (nth e sorted)))
                (push (register (org-tree o) (org-err o) (1+ gen) :elite (org-id o) nil) next)))
            (loop while (< (length next) *pop-size*) do
              (let ((ip (tournament orgs errs *tourney*)) (jp (tournament orgs errs *tourney*)))
                (if (< (rand-float) *xover-rate*)
                    (let* ((pa (nth ip orgs)) (pb (nth jp orgs))
                           (child (crossover (org-tree pa) (org-tree pb))))
                      (push (register child (clean-fitness child *data*) (1+ gen)
                                      :crossover (org-id pa) (org-id pb)) next))
                    (let* ((pa (nth ip orgs)) (child (mutate (org-tree pa))))
                      (push (register child (clean-fitness child *data*) (1+ gen)
                                      :mutation (org-id pa) nil) next)))))
            (setf orgs (nreverse next))))))
    overall-best))

(defun main ()
  (let* ((best (evolve-clean))
         (tree (org-tree best))
         (true-err (raw-error tree *data*))
         (fires (guard-fires-of tree *data*))
         (h (hits tree *data*))
         (recovered (< true-err 1d-6))
         (clean (= fires 0))
         (band (cond ((and recovered clean) "CLEAN-DISCOVERY")
                     (recovered            "STILL-CHEATS")
                     (t                    "STARVED (NULL)"))))
    (format t "~&;;;; run-clean seed=~D λ=~,1F pop=~D gens=~D~%"
            *seed* *lambda* *pop-size* *generations*)
    (format t ";;;; best: true-error=~,8F  guard-fires=~D  hits=~D/~D~%"
            true-err fires h (length *data*))
    (format t ";;;; best tree: ~S~%" tree)
    (format t ";;;; BAND: ~A~%" band)
    band))

(main)
