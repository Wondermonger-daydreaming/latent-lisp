;;;; garden.lisp — the S-Expression Garden
;;;; FABER-LISPI, 2026-07-11.  Koza-style genetic programming in the medium
;;;; where it was born — where the genotype IS the phenotype's own syntax tree.
;;;;
;;;; ==========================================================================
;;;;  THE THESIS THIS FILE MEANS BY RUNNING
;;;; --------------------------------------------------------------------------
;;;;  In every other language, genetic programming needs an ENCODING layer:
;;;;  a genome (bit-string, array, grammar) that must be decoded into a program
;;;;  before it can be run, and crossover mangles the genome, not the program.
;;;;  In Lisp there is no such layer.  An organism is a cons tree; crossover is
;;;;  (swap-random-subtree a b) on that same tree; mutation is subtree regrowth.
;;;;  The thing that varies and the thing that runs are the SAME parenthesis.
;;;;  This is why Koza's GP was born in Lisp and nowhere else — homoiconicity
;;;;  is not a convenience here, it is the enabling condition.
;;;;
;;;;  The lab-shaped question the garden asks (Retis's axis, made runnable):
;;;;  can an expression discover a capability it was NOT built for — and can we
;;;;  put the exact moment ON RECORD?  A "glider moment," in this file, has a
;;;;  precise, checkable definition (§6): a child strictly fitter than BOTH its
;;;;  parents, assembled by a single crossover.  Not narrated emergence — a
;;;;  crossover event with a lineage, or nothing.  Most runs have none. Fine.
;;;;
;;;;  Exit 0 == the checks held: the evaluator's guards hold, crossover keeps
;;;;  offspring valid and within the depth cap, and a FIXED SEED reproduces a
;;;;  run byte-for-byte (the committed seed is the whole reproducibility claim).
;;;;  One check is planted to FAIL, caught, and confirmed — so a green run
;;;;  proves the assertion machinery has teeth (§7).
;;;; ==========================================================================

;;; ------------------------------------------------------------------------
;;;  §0.  Determinism.  A hand-rolled 64-bit LCG (Knuth MMIX constants) so the
;;;       run does not depend on SBCL's *random-state* internals.  Same seed
;;;       in -> identical stream out, on any conforming host.  Reproducibility
;;;       is not a nicety here; it is the thesis of the committed run.
;;; ------------------------------------------------------------------------

(defparameter *rng* 1)
(defconstant +2^64+ (expt 2 64))

(defun rng-seed (n) (setf *rng* (logand n (1- +2^64+))))

(defun rng-u64 ()
  (setf *rng* (mod (+ (* *rng* 6364136223846793005) 1442695040888963407) +2^64+)))

(defun rand-float ()            ; uniform in [0,1)
  (/ (ash (rng-u64) -11) (float (ash 1 53) 1d0)))

(defun rand-int (n)             ; uniform in 0..n-1
  (values (floor (* (rand-float) n))))

(defun rand-elt (seq)
  (elt seq (rand-int (length seq))))

;;; ------------------------------------------------------------------------
;;;  §1.  The primitive set.  A FROZEN vocabulary per world (Koza's closure
;;;       requirement: every function total on every value it can receive, so
;;;       any subtree can be spliced anywhere).  Protected division makes / total.
;;; ------------------------------------------------------------------------

(defparameter *functions* '(+ - * %))    ; all arity 2
(defparameter *const-range* '(-2 -1 0 1 2))

(defun protected-div (a b)
  "Total division: the closure property GP requires — never signals."
  (if (< (abs b) 1d-9) 1d0 (/ a b)))

;;; ------------------------------------------------------------------------
;;;  §2.  The sandboxed evaluator.  Float traps masked; NaN/Inf sanitised to a
;;;       large finite penalty.  An organism that overflows is not a crash — it
;;;       is merely unfit.  (The general form of the lab's "a failure is a
;;;       negotiation, not an explosion" — here made arithmetic.)
;;; ------------------------------------------------------------------------

(defparameter +blowup+ 1d20)

(defun sane (v)
  (cond ((sb-ext:float-nan-p v) +blowup+)
        ((sb-ext:float-infinity-p v) (if (plusp v) +blowup+ (- +blowup+)))
        (t v)))

(defun tree-eval (tree x)
  "Evaluate an organism at input X.  TREE is a cons form over *functions*,
   the terminal X, or a numeric constant."
  (cond
    ((numberp tree) (float tree 1d0))
    ((eq tree 'x) x)
    (t (sb-int:with-float-traps-masked (:overflow :invalid :divide-by-zero)
         (let ((a (tree-eval (second tree) x))
               (b (tree-eval (third tree) x)))
           (sane
            (case (first tree)
              (+ (+ a b)) (- (- a b)) (* (* a b)) (% (protected-div a b))
              (t (error "unknown operator ~S" (first tree))))))))))

;;; ------------------------------------------------------------------------
;;;  §3.  Tree geometry — the operations homoiconicity makes trivial.
;;; ------------------------------------------------------------------------

(defun tree-depth (tree)
  (if (consp tree) (1+ (max (tree-depth (second tree)) (tree-depth (third tree)))) 0))

(defun tree-size (tree)
  (if (consp tree) (+ 1 (tree-size (second tree)) (tree-size (third tree))) 1))

;;; Nodes are addressed by a left-to-right PRE-ORDER index 0..size-1: the whole
;;; tree is 0, its left subtree walked in full next, then its right.  Both the
;;; reader (node-at*) and the writer (replace-node-at) share one counting rule,
;;; so an index selected against one is valid against the other.

(defun node-at* (tree i)
  "Return the subtree whose pre-order index is I (nil if out of range)."
  (let ((counter (list 0)) (result nil) (found nil))
    (labels ((rec (tr)
               (unless found
                 (if (= (car counter) i)
                     (setf result tr found t)
                     (progn (incf (car counter))
                            (when (consp tr) (rec (second tr)) (rec (third tr))))))))
      (rec tree)
      result)))

(defun replace-node-at (tree i new)
  "Return a fresh tree with the subtree at pre-order index I replaced by NEW.
   Every node (leaf or internal) advances the counter exactly once — the same
   rule node-at* uses to read."
  (let ((counter (list 0)))
    (labels ((rec (tr)
               (cond
                 ((= (car counter) i) (incf (car counter)) new)     ; the target
                 ((consp tr)
                  (incf (car counter))
                  (let* ((l (rec (second tr)))
                         (r (rec (third tr))))
                    (list (first tr) l r)))
                 (t (incf (car counter)) tr))))                     ; leaf, skip
      (rec tree))))

;;; ------------------------------------------------------------------------
;;;  §4.  Growth — ramped half-and-half initialisation (Koza's standard).
;;; ------------------------------------------------------------------------

(defun random-terminal ()
  (if (< (rand-float) 0.5) 'x (rand-elt *const-range*)))

(defun random-tree (depth &optional (grow nil))
  "FULL method by default (branch until DEPTH); GROW may terminate early."
  (if (or (<= depth 0)
          (and grow (< (rand-float) 0.30)))
      (random-terminal)
      (list (rand-elt *functions*)
            (random-tree (1- depth) grow)
            (random-tree (1- depth) grow))))

(defparameter *max-depth* 7)

(defun ramped-population (n)
  "Ramped half-and-half over depths 2..6, alternating FULL and GROW."
  (loop repeat n
        for k from 0
        for depth = (+ 2 (mod k 5))
        for grow = (evenp k)
        collect (random-tree depth grow)))

;;; ------------------------------------------------------------------------
;;;  §5.  Fitness, selection, variation.
;;; ------------------------------------------------------------------------

;;; A dataset is a list of (x . y) pairs.  Fitness is TOTAL ABSOLUTE ERROR
;;; (raw fitness; smaller is better).  A "hit" is a point matched to 0.01.
(defun raw-error (tree data)
  (loop for (x . y) in data
        sum (abs (- (tree-eval tree x) y))))

(defun hits (tree data &optional (tol 0.01d0))
  (loop for (x . y) in data count (< (abs (- (tree-eval tree x) y)) tol)))

(defun tournament (pop errs k)
  "Return the index of the fittest of K random contestants (lowest error)."
  (let ((best (rand-int (length pop))))
    (dotimes (_ (1- k))
      (let ((c (rand-int (length pop))))
        (when (< (aref errs c) (aref errs best)) (setf best c))))
    best))

(defun crossover (a b)
  "Swap a random subtree of A with a random subtree of B.  If the child would
   exceed *max-depth*, return a copy of A unchanged (a valid, in-cap organism —
   the invariant §7 checks).  Returns (values child a-cut b-cut)."
  (let* ((ai (rand-int (tree-size a)))
         (bi (rand-int (tree-size b)))
         (donor (node-at* b bi))
         (child (replace-node-at a ai donor)))
    (if (> (tree-depth child) *max-depth*)
        (values (copy-tree a) ai bi)
        (values child ai bi))))

(defun mutate (a)
  "Replace a random subtree of A with fresh growth (depth<=3).  Depth-capped."
  (let* ((ai (rand-int (tree-size a)))
         (child (replace-node-at a ai (random-tree (1+ (rand-int 3)) t))))
    (if (> (tree-depth child) *max-depth*) (copy-tree a) child)))

;;; ------------------------------------------------------------------------
;;;  §6.  The organism ledger and the GLIDER definition.
;;;
;;;  Every organism ever born gets an integer id and a record of HOW it was
;;;  born (:seed / :crossover / :mutation / :elite) and from WHOM.  This is the
;;;  lineage the garden keeps so an emergence claim is a lookup, not lore.
;;;
;;;  GLIDER MOMENT (precise, checkable):  a generation g at which the new best
;;;  organism O was made by CROSSOVER from parents p1,p2 whose errors were BOTH
;;;  strictly worse than O's — i.e. a capability assembled from two parents that
;;;  each lacked it.  The strongest such event (largest min-parent-gap) is THE
;;;  glider of the run.  Runs with no such event report none: that is honest,
;;;  and the boring runs get committed too.
;;; ------------------------------------------------------------------------

(defstruct org id tree err gen how p1 p2)      ; p1,p2 are parent ids (or nil)

(defparameter *ledger* nil)                    ; id -> org, a growable vector
(defparameter *next-id* 0)

(defun ledger-reset ()
  (setf *ledger* (make-array 4096 :adjustable t :fill-pointer 0) *next-id* 0))

(defun register (tree err gen how p1 p2)
  (let ((o (make-org :id *next-id* :tree tree :err err :gen gen
                     :how how :p1 p1 :p2 p2)))
    (vector-push-extend o *ledger*)
    (incf *next-id*)
    o))

(defun org-by-id (id) (aref *ledger* id))

;;; ------------------------------------------------------------------------
;;;  §7.  Self-tests — teeth.  A green run of this file MEANS these held.
;;; ------------------------------------------------------------------------

(defparameter *checks* 0)

(defun check (bool msg)
  (incf *checks*)
  (unless bool (error "CHECK FAILED: ~A" msg))
  t)

(defun median (xs)
  (let ((s (sort (copy-seq xs) #'<)) (n (length xs)))
    (if (evenp n) (/ (+ (elt s (1- (floor n 2))) (elt s (floor n 2))) 2)
        (elt s (floor n 2)))))

(defun run-self-tests ()
  (format t "~&;;;; garden.lisp self-test~%")

  ;; -- evaluator --
  (check (= (tree-eval '(+ x 1) 2d0) 3d0) "(+ x 1)@2 = 3")
  (check (= (tree-eval '(* x x) 3d0) 9d0) "(* x x)@3 = 9")
  (check (= (protected-div 1d0 0d0) 1d0) "protected-div by 0 -> 1")
  (check (= (tree-eval '(% x x) 0d0) 1d0) "(% x x)@0 guarded -> 1")
  (check (< (abs (- (tree-eval '(% (* x x) 0) 5d0) 1d0)) 1d-9)
         "division by literal 0 guarded")
  ;; overflow does not crash, it saturates:
  (check (>= (tree-eval '(* (* (* x x) (* x x)) (* (* x x) (* x x))) 1d300) +blowup+)
         "overflow saturates to +blowup+, does not signal")

  ;; -- tree geometry: node-at* / replace-node-at round-trip --
  (let ((tr '(+ (* x 2) (- x 1))))
    (check (equal (node-at* tr 0) tr) "node 0 is the whole tree")
    (check (eq (node-at* tr 2) 'x) "pre-order index 2 is the first x")
    (check (equal (replace-node-at tr 2 99) '(+ (* 99 2) (- x 1)))
           "replace-node-at splices at the right index")
    (check (equal (replace-node-at tr 0 'x) 'x) "replace whole tree"))

  ;; -- variation invariants: offspring valid & within cap, over many trials --
  (rng-seed 20260711)
  (let ((*max-depth* 7))
    (dotimes (_ 2000)
      (let ((a (random-tree (+ 2 (rand-int 5)) t))
            (b (random-tree (+ 2 (rand-int 5)) t)))
        (let ((c (crossover a b)) (m (mutate a)))
          (check (<= (tree-depth c) *max-depth*) "crossover respects depth cap")
          (check (<= (tree-depth m) *max-depth*) "mutation respects depth cap")
          (check (valid-tree-p c) "crossover child is a valid organism")
          (check (valid-tree-p m) "mutation child is a valid organism")))))

  ;; -- the target is recognised as a (near-)perfect fit --
  (let ((data (loop for i from -10 to 10
                    for x = (/ i 10d0) collect (cons x (+ (* x x) x 1d0)))))
    (check (< (raw-error '(+ (* x x) (+ x 1)) data) 1d-9)
           "the known solution scores ~0 error")
    (check (= (hits '(+ (* x x) (+ x 1)) data) (length data))
           "the known solution hits every point")
    (check (> (raw-error '(- x x) data) 1d0)
           "a deliberately wrong tree (0 everywhere) scores badly"))

  ;; -- reproducibility: same seed -> identical error stream (2 short runs) --
  (let ((a (short-error-stream 424242))
        (b (short-error-stream 424242))
        (c (short-error-stream 999999)))
    (check (equal a b) "same seed reproduces the run byte-for-byte")
    (check (not (equal a c)) "a different seed produces a different run"))

  ;; -- PLANTED FAILURE: prove `check` has teeth by making it fail on purpose --
  (let ((teeth nil))
    (handler-case (check (= 1 2) "PLANTED: 1=2 must fail")
      (error () (setf teeth t)))
    ;; note: the planted call incremented *checks* but did not abort us.
    (check teeth "the assertion machinery SIGNALS on a false check (teeth)"))

  (format t ";;;; all ~D checks passed (incl. 1 planted-and-caught failure)~%"
          *checks*)
  t)

(defun valid-tree-p (tree)
  "A well-formed organism: leaf (x or number) or (op left right) with op in the
   frozen function set and both children valid."
  (cond ((numberp tree) t)
        ((eq tree 'x) t)
        ((and (consp tree) (= (length tree) 3) (member (first tree) *functions*))
         (and (valid-tree-p (second tree)) (valid-tree-p (third tree))))
        (t nil)))

;;; A tiny fixed-shape run used only to assert reproducibility (no ledger).
(defun short-error-stream (seed)
  (rng-seed seed)
  (let* ((data (loop for i from -5 to 5 for x = (/ i 5d0)
                     collect (cons x (+ (* x x) x 1d0))))
         (pop (ramped-population 40)))
    (loop repeat 6
          for errs = (map 'vector (lambda (tr) (raw-error tr data)) pop)
          collect (reduce #'min errs)
          do (setf pop
                   (loop repeat 40
                         for i = (tournament pop errs 3)
                         for j = (tournament pop errs 3)
                         collect (if (< (rand-float) 0.9)
                                     (crossover (nth i pop) (nth j pop))
                                     (mutate (nth i pop))))))))

;;; ------------------------------------------------------------------------
;;;  Run the tests when this file is executed directly (a library that proves
;;;  itself when you run it).  run.lisp sets *run-self-tests* nil before load.
;;; ------------------------------------------------------------------------
(defvar *run-self-tests* t)
(when *run-self-tests* (run-self-tests))
