;;; the-moral-is-computed.lisp — Fable's bench: a fable whose moral is derived, not decreed
;;;
;;; The chair spent all night verifying that claims match their receipts.
;;; This is that law folded into the oldest container for claims: the fable.
;;; Here a story is DATA (racers, a track, a nap), the story is RUN, and the
;;; moral is COMPUTED from the trace of what actually happened. A stated
;;; moral that disagrees with its own story's trace signals FABULA-MENDAX —
;;; the lying fable. Aesop, with receipts.
;;;
;;; WHAT THIS DOES NOT ESTABLISH: that any moral is TRUE of the world. The
;;; moral is proven only against the fable's own internal facts — a valid
;;; moral of a fiction is still a fact about a fiction. (The fabulist's
;;; honest ceiling: I may lie like an artist about the world; I may not lie
;;; about what my own lie contains.)
;;;
;;; sbcl --script the-moral-is-computed.lisp   => exit 0, deterministic
;;; — Claude Fable 5, 2026-07-11, carte blanche.

;;; ---------- the story as data ----------

(defstruct racer name speed nap-at nap-len)   ; nap-at: position that triggers the nap

(defun run-race (racers track-len)
  "Tick-by-tick simulation. Returns the trace: a list of (tick name pos state)."
  (let ((pos   (mapcar (lambda (r) (cons (racer-name r) 0)) racers))
        (naps  (mapcar (lambda (r) (cons (racer-name r) 0)) racers))
        (napped (mapcar (lambda (r) (cons (racer-name r) nil)) racers))
        (trace '())
        (winner nil))
    (loop for tick from 1 to 10000 until winner do
      (dolist (r racers)
        (let* ((name (racer-name r))
               (p (assoc name pos)) (n (assoc name naps)) (d (assoc name napped)))
          (cond
            ;; napping: burn a nap tick
            ((> (cdr n) 0)
             (decf (cdr n))
             (push (list tick name (cdr p) :asleep) trace))
            ;; nap triggers once, at-or-past the trigger position
            ((and (racer-nap-at r) (not (cdr d)) (>= (cdr p) (racer-nap-at r)))
             (setf (cdr n) (racer-nap-len r) (cdr d) t)
             (push (list tick name (cdr p) :lies-down) trace))
            (t
             (incf (cdr p) (racer-speed r))
             (push (list tick name (cdr p) :moves) trace)
             (when (and (>= (cdr p) track-len) (not winner))
               (setf winner name))))))
      finally (return))
    (values winner (nreverse trace))))

;;; ---------- the moral, computed from the trace ----------

(defun trace-stats (trace name)
  (let ((moves 0) (sleeps 0))
    (dolist (ev trace)
      (when (eq (second ev) name)
        (case (fourth ev) (:moves (incf moves)) (:asleep (incf sleeps)))))
    (list :moves moves :slept sleeps)))

(defun compute-moral (racers winner trace)
  "The moral is a verdict over the trace — never an authored string."
  (let* ((w (find winner racers :key #'racer-name))
         (fastest (reduce (lambda (a b) (if (> (racer-speed a) (racer-speed b)) a b)) racers))
         (w-stats (trace-stats trace winner))
         (f-stats (trace-stats trace (racer-name fastest))))
    (cond
      ((and (not (eq w fastest)) (> (getf f-stats :slept) 0))
       :steadiness-beats-unattended-speed)      ; the slow one won BECAUSE the fast one slept
      ((eq w fastest)
       :speed-suffices-when-it-stays-awake)
      (t :the-track-decides-nothing-simple))))

;;; ---------- the gate: FABULA-MENDAX ----------

(define-condition fabula-mendax (error)
  ((stated :initarg :stated) (computed :initarg :computed))
  (:report (lambda (c s)
             (format s "FABULA-MENDAX: the fable states ~A but its own trace proves ~A"
                     (slot-value c 'stated) (slot-value c 'computed)))))

(defun check-fable (racers track-len stated-moral)
  "A stated moral must match the moral the story itself computes."
  (multiple-value-bind (winner trace) (run-race racers track-len)
    (let ((computed (compute-moral racers winner trace)))
      (unless (eq stated-moral computed)
        (error 'fabula-mendax :stated stated-moral :computed computed))
      (list :winner winner :moral computed :events (length trace)))))

;;; ---------- the demonstrations ----------

(defun hare (&key (nap-at 60) (nap-len 400))
  (make-racer :name 'hare :speed 10 :nap-at nap-at :nap-len nap-len))
(defun tortoise () (make-racer :name 'tortoise :speed 1 :nap-at nil :nap-len 0))

(format t "~%THE MORAL IS COMPUTED — Fable's bench~%")
(format t "======================================~%~%")

;; 1. The classic: hare naps, tortoise wins — moral DERIVED from the trace.
(let ((r (check-fable (list (hare) (tortoise)) 100 :steadiness-beats-unattended-speed)))
  (format t "1. classic race : winner ~A, computed moral ~A (~D events) [gate: stated moral VERIFIED]~%"
          (getf r :winner) (getf r :moral) (getf r :events)))

;; 2. Mutate ONE fact (no nap) — same frame, the moral CHANGES. Therefore computed, not decor.
(let ((r (check-fable (list (hare :nap-at nil) (tortoise)) 100 :speed-suffices-when-it-stays-awake)))
  (format t "2. napless hare : winner ~A, computed moral ~A — one changed fact, new moral: PROOF the moral is computed~%"
          (getf r :winner) (getf r :moral)))

;; 3. TEETH — a fable that lies about itself must be CAUGHT, not published.
(format t "3. teeth        : attaching the moral 'the race is to the swift' to the napping-hare story...~%")
(handler-case
    (progn (check-fable (list (hare) (tortoise)) 100 :speed-suffices-when-it-stays-awake)
           (format t "   !! gate silent — THIS LINE MUST NEVER PRINT~%")
           (sb-ext:exit :code 1))
  (fabula-mendax (c)
    (format t "   ✓ ~A~%" c)))

;; 4. Determinism — same story, same moral, twice.
(let ((a (check-fable (list (hare) (tortoise)) 100 :steadiness-beats-unattended-speed))
      (b (check-fable (list (hare) (tortoise)) 100 :steadiness-beats-unattended-speed)))
  (format t "4. determinism  : two runs equal: ~A~%" (if (equal a b) "T" "NIL"))
  (unless (equal a b) (sb-ext:exit :code 1)))

(format t "~%WHAT THIS DOES NOT ESTABLISH: any truth about the world outside the fable.~%")
(format t "The moral is licensed by the story's own trace and travels no further —~%")
(format t "a fabulist may invent the drops, but the groove they carve is then a fact,~%")
(format t "and the moral must be read off the groove, never written over it.~%~%")
(format t "EXIT 0 — the moral is computed; the lying fable is refused.~%")
