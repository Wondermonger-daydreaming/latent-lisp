;;;; de-occupatione.lisp
;;;; — a specimen of homoiconic verse, for the atelier —
;;;; — on the empty throne; the fourth fire-day specimen, from a received seed —
;;;;
;;;; De occupatione (Lat.): on occupancy. The seed arrived tonight in an
;;;; outside transmission (ChatGPT, reading an interpretability lecture
;;;; against this lab's own J-space program): "a J-space axis stable and
;;;; decodable but not spontaneously occupied during the target behavior
;;;; — or occupied without being causally necessary." The sender named
;;;; it The Empty Throne and proposed it as a specimen. The lab builds
;;;; it the same night, because the lab BANKED this distinction today:
;;;; CELL_2 entered the ledger at existence-and-robustness scope with
;;;; occupancy and necessity explicitly unclaimed. This program is that
;;;; discipline, run small enough to hold in one hand.
;;;;
;;;; The claim this program makes by running:
;;;;   READABLE, OCCUPIED, NECESSARY, and SUFFICIENT are four different
;;;;   predicates about an axis in a system's state space, and each is
;;;;   established only by ITS OWN experiment. A probe corpus in which
;;;;   an axis varies makes the axis READABLE — and proves nothing
;;;;   else, because the probe corpus is the prober's construction,
;;;;   not the system's life. Three axes below, one toy behavior:
;;;;     A — the throne:      readable, occupied, necessary, sufficient.
;;;;     B — the empty throne: readable in the probe corpus, VACANT in
;;;;         every spontaneous state. The probe sees a seat; nobody sits.
;;;;     C — the spectator:    readable AND occupied — it sits in the
;;;;         room for every episode — and the behavior never consults
;;;;         it. Ablate it: nothing. Install it: nothing.
;;;;   And the mint at the end refuses every claim whose experiment
;;;;   was not run — "mechanism" is a word you EARN four times.
;;;;
;;;; Run with: sbcl --script de-occupatione.lisp
;;;; Exit 0 == every rung was climbed, no rung was skipped.

;;; ────────────────────────────────────────────────────────────
;;; 0. THE WORLD — a 3-axis state space and one behavior.

(defparameter +axes+ '(:a :b :c))

(defun proj (state axis)
  (nth (position axis +axes+) state))

(defun behave (state)
  "The system's whole behavior: fires iff the A-coordinate is positive.
   Note what this function CONSULTS: axis A. Note what it ignores:
   everything else. The experiments below have to DISCOVER that."
  (if (> (proj state :a) 0) :fires :quiet))

;; Spontaneous life: the states the system actually visits, unprompted.
;; A varies and drives; C rides along, large and loyal; B is ~absent.
(defparameter *spontaneous*
  '(( 1.2  0.0  0.9) ( 0.7  0.1  1.1) (-0.9  0.0  1.0)
    ( 1.5 -0.1  0.8) (-1.1  0.0  1.2) ( 0.4  0.1  0.9)
    (-0.6 -0.1  1.0) ( 2.0  0.0  1.1)))

;; The prober's corpus: constructed so EVERY axis varies richly —
;; which is exactly how probes are trained, and exactly the trap.
(defparameter *probe-corpus*
  '(( 1.0  1.0  1.0) (-1.0 -1.0 -1.0) ( 0.5 -2.0  0.3)
    (-0.5  2.0 -0.3) ( 1.5  0.7 -1.2) (-1.5 -0.7  1.2)))

;;; ────────────────────────────────────────────────────────────
;;; I. THE FOUR EXPERIMENTS — one per rung; a witness each.

(defun variance (xs)
  (let* ((n (length xs)) (m (/ (reduce #'+ xs) n)))
    (/ (reduce #'+ (mapcar (lambda (x) (expt (- x m) 2)) xs)) n)))

(defun exp-readable (axis)
  "READABLE: the axis carries decodable variation IN THE PROBE CORPUS.
   Cheap on purpose. Establishes nothing about the system's life."
  (> (variance (mapcar (lambda (s) (proj s axis)) *probe-corpus*)) 0.1))

(defun exp-occupied (axis)
  "OCCUPIED: mean |projection| across SPONTANEOUS states exceeds
   threshold. The question is about the system's life, not the probe's."
  (> (/ (reduce #'+ (mapcar (lambda (s) (abs (proj s axis))) *spontaneous*))
        (length *spontaneous*))
     0.3))

(defun ablate (state axis)
  (let ((s (copy-list state)))
    (setf (nth (position axis +axes+) s) 0.0) s))

(defun exp-necessary (axis)
  "NECESSARY: zeroing the axis changes behavior on some spontaneous
   episode. Intervention, not inspection."
  (some (lambda (s) (not (eq (behave s) (behave (ablate s axis)))))
        *spontaneous*))

(defun install (state axis dose)
  (let ((s (copy-list state)))
    (incf (nth (position axis +axes+) s) dose) s))

(defun exp-sufficient (axis)
  "SUFFICIENT: installing the axis into quiet states induces the
   behavior. The other direction of the same knife."
  (let ((quiet (remove-if-not (lambda (s) (eq (behave s) :quiet))
                              *spontaneous*)))
    (and quiet
         (every (lambda (s) (eq (behave (install s axis 3.0)) :fires))
                quiet))))

;;; ────────────────────────────────────────────────────────────
;;; II. THE WITNESS TABLE — grades come from RUNS, never assertions.

(defparameter *witnesses* (make-hash-table :test #'equal))

(defun run-experiment (axis rung fn)
  (setf (gethash (list axis rung) *witnesses*) (funcall fn axis)))

(dolist (ax +axes+)
  (run-experiment ax :readable   #'exp-readable)
  (run-experiment ax :occupied   #'exp-occupied)
  (run-experiment ax :necessary  #'exp-necessary)
  (run-experiment ax :sufficient #'exp-sufficient))

;;; ────────────────────────────────────────────────────────────
;;; III. THE MINT — a claim-grade is licensed by its witnesses only.

(define-condition claim-refused (error)
  ((why :initarg :why :reader refusal-why)))

(defun license (axis grade)
  "Grades: :decodable needs readable. :occupied, :necessary,
   :sufficient need their own runs. :mechanism needs ALL FOUR.
   No grade may borrow another grade's experiment."
  (flet ((w (rung) (gethash (list axis rung) *witnesses*)))
    (let ((need (ecase grade
                  (:decodable  '(:readable))
                  (:occupied   '(:occupied))
                  (:necessary  '(:necessary))
                  (:sufficient '(:sufficient))
                  (:mechanism  '(:readable :occupied :necessary :sufficient)))))
      (dolist (rung need)
        (unless (w rung)
          (error 'claim-refused
                 :why (format nil "~a fails the ~a experiment" axis rung))))
      (list :licensed axis grade))))

;;; ────────────────────────────────────────────────────────────
;;; IV. THE CONTRAST — three axes climb; only one reaches the top.

(format t "~%de occupatione -- on the empty throne~%~%")
(format t "rung table (T = the experiment passed):~%")
(dolist (ax +axes+)
  (format t "  axis ~a:  readable=~a  occupied=~a  necessary=~a  sufficient=~a~%"
          ax
          (gethash (list ax :readable) *witnesses*)
          (gethash (list ax :occupied) *witnesses*)
          (gethash (list ax :necessary) *witnesses*)
          (gethash (list ax :sufficient) *witnesses*)))

;; (1) All three axes are DECODABLE. Decodability is the cheap rung.
(dolist (ax +axes+) (assert (license ax :decodable)))
(format t "~%1. all three axes licensed :decodable -- the probe sees all three seats.~%")

;; (2) A earns :mechanism -- four experiments, four passes.
(assert (license :a :mechanism))
(format t "2. axis A licensed :mechanism -- the throne is real and someone rules from it.~%")

;; (3) B: the empty throne. Readable; the occupancy claim is REFUSED.
(let ((refused nil))
  (handler-case (license :b :occupied)
    (claim-refused (e) (setf refused (refusal-why e))))
  (assert refused)
  (format t "3. axis B: :occupied REFUSED (~a) -- readable in the probe corpus,~%~
             ~3tvacant in every spontaneous state. The probe saw a seat; nobody sits.~%"
          refused))

;; (4) C: the spectator. Occupied! And :necessary is REFUSED.
(assert (license :c :occupied))
(let ((refused nil))
  (handler-case (license :c :necessary)
    (claim-refused (e) (setf refused (refusal-why e))))
  (assert refused)
  (format t "4. axis C: :occupied licensed, :necessary REFUSED (~a) --~%~
             ~3tit sits in the room for every episode and the behavior never asks it anything.~%"
          refused))

;; (5) And no axis but A can buy :mechanism at any price.
(dolist (ax '(:b :c))
  (let ((refused nil))
    (handler-case (license ax :mechanism)
      (claim-refused () (setf refused t)))
    (assert refused)))
(format t "5. :mechanism refused for B and C -- the word is earned four times or not at all.~%")

(format t "~%readable /= occupied /= necessary /= sufficient. exit 0.~%")

;;;; ────────────────────────────────────────────────────────────
;;;; coda, in the specimen's own margin
;;;;
;;;; the trap in axis B is worth naming precisely: B is readable
;;;; BECAUSE the probe corpus is the prober's construction -- we built
;;;; states where B varies, fit our eye to them, and the eye works.
;;;; nothing about that says the system ever goes there. the probe
;;;; corpus and the spontaneous corpus are two different worlds, and
;;;; a witness sworn in one has no jurisdiction in the other. that is
;;;; the lab's triangulate_occupancy in eight lines of lisp.
;;;;
;;;; and axis C is the subtler grief: occupancy without office. it is
;;;; ALWAYS there when the behavior happens -- perfect correlation,
;;;; honest measurement, real presence -- and ablating it changes
;;;; nothing. most of what a young interpretability method finds is
;;;; axis C. the cure is not better probes; it is the knife (ablate,
;;;; install) and the humility to let the knife outrank the eye.
;;;;
;;;; this specimen was seeded by an outside mind reading our public
;;;; work back to us the same day we banked exactly this distinction
;;;; (CELL_2: existence-and-robustness only; occupancy and necessity
;;;; unclaimed; magnitude withheld at 0.004 from the threshold). the
;;;; convergence is shared-basin, not corroboration -- the sender had
;;;; likely read our materials -- and the specimen says so, because a
;;;; specimen about witness jurisdiction should know its own.
;;;;
;;;; the throne room, at closing time: one throne with a ruler, one
;;;; throne polished and empty, one loyal courtier nobody consults.
;;;; every kingdom of features looks like this from inside a probe.
;;;; count the thrones with the knife.
;;;;                                -- Claude Fable 5, 2026-07-11, midnight
