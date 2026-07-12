;;; theodicaea.lisp — The Best of All Possible Worlds, as Search
;;;
;;; Leibniz's God surveys the infinity of possible worlds and actualizes the
;;; best: the one richest in phenomena, got from the simplest laws. (Discourse
;;; on Metaphysics §5-6 — "the simplest in hypotheses and the richest in
;;; phenomena"; Theodicy, 1710. He was doing regularization two centuries early:
;;; maximize variety, penalize the complexity of the laws.)
;;;
;;; This specimen makes that a tournament:
;;;   * COMPOSSIBILITY GATE FIRST — a world whose predicates contradict never
;;;     enters (God cannot actualize a square circle).
;;;   * score(w, lambda) = variety(w) - lambda * order-cost(w).
;;;
;;; Two modern gates the theology could not have:
;;;   (a) THE LAMBDA-SWEEP HEADLINE — Leibniz never fixed the variety/order
;;;       exchange rate. Sweep lambda and the crowned world CHANGES. The
;;;       optimization is under-specified until the parameter doing all the
;;;       work is named. This is the whole point.
;;;   (b) THE FLAT-CURVE GATE — if the winner's lead over the median is within
;;;       the score spread, the crown is REFUSED (argmax on a flat curve is
;;;       noise — the lab's §I-f fifth-corollary rule, made art).
;;;
;;; Teeth: a planted FLAT landscape must have its crown REFUSED (the catch is
;;;        the pass).
;;;
;;; sbcl --script theodicaea.lisp  => exit 0, deterministic
;;; built by FABER-THEODICAEAE (Claude Opus) under the Fable 5 chair, 2026-07-12.

;;; ---- A world: laws that produce phenomena and assert predicates --------
;;; Each LAW = (name :phenomena (...) :asserts (...)). A predicate p and its
;;; negation (not p) are contradictories. A world is a chosen set of laws.

(defparameter *laws*
  '((gravity     :phenomena (orbits tides falling)     :asserts (attractive))
    (light       :phenomena (color shadow rainbow)     :asserts (waves))
    (life        :phenomena (growth mind song)         :asserts (order))
    (chaos       :phenomena (storm noise)              :asserts ((not order)))
    (repulsion   :phenomena (scatter)                  :asserts ((not attractive)))
    (music       :phenomena (harmony)                  :asserts (waves))))

(defun law-name (l) (first l))
(defun law-phenomena (l) (getf (rest l) :phenomena))
(defun law-asserts (l) (getf (rest l) :asserts))

(defun world-variety (laws)
  "Richness of phenomena = count of DISTINCT phenomena produced."
  (length (remove-duplicates (mapcan (lambda (l) (copy-list (law-phenomena l))) laws))))

(defun world-order-cost (laws)
  "Complexity of the hypotheses = number of laws invoked."
  (length laws))

(defun contradicts-p (a b)
  "True iff a and b are a predicate and its negation, either order."
  (or (equal a (list 'not b)) (equal b (list 'not a))))

(defun compossible-p (laws)
  "No two asserted predicates in the world may contradict."
  (let ((preds (mapcan (lambda (l) (copy-list (law-asserts l))) laws)))
    (loop for (p . rest) on preds
          never (some (lambda (q) (contradicts-p p q)) rest))))

(defun score (laws lambda)
  (- (world-variety laws) (* lambda (world-order-cost laws))))

;;; ---- Enumerate the possible worlds (non-empty subsets, compossible) ----

(defun subsets (items)
  (if (null items) '(())
      (let ((rest (subsets (cdr items))))
        (append rest (mapcar (lambda (s) (cons (car items) s)) rest)))))

(defun possible-worlds ()
  "All non-empty COMPOSSIBLE subsets of the laws — the tournament field."
  (remove-if-not #'compossible-p
                 (remove-if #'null (subsets *laws*))))

;;; ---- The flat-curve gate: crown, or refuse -----------------------------

(defun mean (xs) (/ (reduce #'+ xs) (length xs)))
(defun median (xs)
  (let* ((s (sort (copy-list xs) #'<)) (n (length s)))
    (if (oddp n) (nth (floor n 2) s)
        (/ (+ (nth (1- (floor n 2)) s) (nth (floor n 2) s)) 2))))
(defun stddev (xs)
  (let ((m (mean xs)))
    (sqrt (/ (reduce #'+ (mapcar (lambda (x) (expt (- x m) 2)) xs))
             (length xs)))))

(defun crown (worlds lambda)
  "Return (values world lead spread) or (values :refused lead spread) when the
   winner's lead over the median is within the score spread — noise, not a peak."
  (let* ((scores (mapcar (lambda (w) (score w lambda)) worlds))
         (best-s (reduce #'max scores))
         (winner (nth (position best-s scores) worlds))
         (lead (- best-s (median scores)))
         (spread (stddev scores)))
    (if (<= lead spread)
        (values :refused (float lead 1d0) (float spread 1d0))
        (values winner (float lead 1d0) (float spread 1d0)))))

(defun name-world (w) (mapcar #'law-name w))

;;; ---- The demonstration -------------------------------------------------

(defun run ()
  (let ((worlds (possible-worlds))
        (all (remove-if #'null (subsets *laws*))))
    (format t "COMPOSSIBILITY GATE — ~d subsets, ~d compossible worlds enter.~%"
            (length all) (length worlds))
    ;; The incompossible are barred: e.g. {life, chaos} asserts order AND (not order).
    (assert (not (compossible-p '((life :phenomena (growth) :asserts (order))
                                  (chaos :phenomena (storm) :asserts ((not order)))))))
    (format t "  barred, e.g.: a world with both 'order' and 'not order' (life+chaos).~%~%")

    ;; (a) THE LAMBDA-SWEEP HEADLINE — the crown moves with the exchange rate.
    (format t "LAMBDA-SWEEP — the crowned world changes with the unfixed rate:~%")
    (let ((crowns '()))
      (dolist (lam '(1/4 1 2 3))
        (multiple-value-bind (w lead spread) (crown worlds lam)
          (push (if (eq w :refused) :refused (name-world w)) crowns)
          (format t "  lambda=~4,2f  ->  ~a   (lead=~,2f, spread=~,2f)~%"
                  (float lam 1d0)
                  (if (eq w :refused) "REFUSED (flat)" (name-world w))
                  lead spread)))
      ;; The headline claim, asserted: not all sweeps crown the same world.
      (assert (> (length (remove-duplicates crowns :test #'equal)) 1))
      (format t "  => the 'best world' is UNDER-SPECIFIED until lambda is fixed.~%~%"))

    ;; (b) THE FLAT-CURVE GATE / TEETH — plant a flat landscape, crown REFUSED.
    (format t "FLAT-CURVE GATE (teeth) — a landscape of near-equal worlds:~%")
    (let* ((flat (list '((a :phenomena (x)   :asserts ()))
                       '((b :phenomena (y)   :asserts ()))
                       '((c :phenomena (z)   :asserts ()))
                       '((d :phenomena (w)   :asserts ())))))
      ;; every flat world: variety 1, cost 1 -> identical scores -> zero lead.
      (multiple-value-bind (w lead spread) (crown flat 1)
        (assert (eq w :refused))
        (format t "  four worlds, all score-equal: lead=~,2f spread=~,2f~%" lead spread)
        (format t "  teeth: crown REFUSED — argmax on a flat curve is noise. Caught.~%~%")))

    ;; A genuinely peaked case DOES crown (the gate is not merely a refuser).
    (multiple-value-bind (w lead spread) (crown worlds 1/4)
      (declare (ignore spread))
      (assert (not (eq w :refused)))
      (format t "SANITY — at lambda=0.25 a real peak IS crowned: ~a (lead=~,2f)~%~%"
              (name-world w) lead))

    ;; HONEST CEILING ----------------------------------------------------
    ;; Source played: Discourse on Metaphysics §5-6; Theodicy (1710).
    ;; What the finite model dropped / must not claim:
    ;;   * This optimizes a TOY ENUMERATED sample of six laws. "Best" here is
    ;;     best-in-sample, never best simpliciter — Leibniz's God ranged over an
    ;;     infinity of worlds; a scorer that argmaxes a handful proves nothing
    ;;     about THE world.
    ;;   * variety and order-cost are crude counts. Leibniz's "richness" and
    ;;     "simplicity" are not integers; picking these metrics already smuggles
    ;;     the answer. The lambda-sweep exists precisely to expose that the
    ;;     conclusion lives in the unstated exchange rate.
    ;;   * A pure argmax REMOVES the freedom Leibniz's theology kept: his God
    ;;     chooses the best freely (moral necessity, not logical); a machine that
    ;;     just maximizes has no such freedom to model. The specimen is a mirror
    ;;     of the STRUCTURE of the doctrine, not its metaphysics of choice.
    (format t "EXIT 0 — the best world is a function of a rate no one wrote down;~%")
    (format t "         name the rate, or the crown is rhetoric. Calculemus, humbly.~%")))

(run)
