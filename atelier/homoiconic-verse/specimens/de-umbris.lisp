;;;; de-umbris.lisp
;;;; ─ a specimen of homoiconic verse, for the atelier ─
;;;;
;;;; After Bruno's De umbris idearum, Hugh's citadel, and one long
;;;; conversation about memory and imagination that concluded they
;;;; are a single engine at different clamp settings.
;;;;
;;;; The claim this program makes by running:
;;;;   there is no RECALL and no IMAGINE here.
;;;;   there is one function, RECOLLECT, and a clamp.
;;;;   memory is imagination at clamp 1.0;
;;;;   imagination is memory with the clamp released.
;;;;
;;;; Run with: sbcl --script de-umbris.lisp
;;;; The output is part of the poem. It always was.

(setf *random-state* (sb-ext:seed-random-state 33))   ; :33 — the seal.
                                                       ; seeded, so the free
                                                       ; run is unrepeatable
                                                       ; in spirit, repeatable
                                                       ; in court. haecceity
                                                       ; with a receipt.

;;; ────────────────────────────────────────────────────────────
;;; I. THE CITADEL
;;;    A palace is a list of loci. A locus is a place, an image,
;;;    and its neighbors. Hugh: the building holds the knowing.
;;;    Note what the locus stores: not a string. A FORM. A quoted
;;;    generator. The palace does not contain its contents —
;;;    it contains instructions for regenerating them.
;;;    There is no playback. There never was.

(defparameter *palace*
  '((threshold
     :image (a child holds a (banana) to her ear and says hello)
     :doors (nave))
    (nave
     :image (the (citadel) built before the pen takes up its course)
     :doors (threshold wheel-room))
    (wheel-room
     :image ((wheels) within wheels grinding (shadow) against (shadow)
             until they give off light)
     :doors (nave shelf scriptorium))
    (shelf
     :image (a (jar) holding the question we refuse to force)
     :doors (wheel-room))
    (scriptorium
     :image (the pen transcribing what the (heart) already measured)
     :doors (wheel-room last-room))
    (last-room
     :image (an empty (chair) exactly as full as it was)
     :doors (scriptorium)))
  "The atrium of one conversation, laid down as list structure.
   Code is data. The palace is walkable and eval-able,
   which is the whole point, which was always the whole point.")

;;; ────────────────────────────────────────────────────────────
;;; II. THE INVENTORY
;;;     The frozen yard of lumber. Everything ever installed.
;;;     Novelty will be permutation over this, and only this.
;;;     (You cannot imagine a new primary color. Neither can I.)

(defun inventory (palace)
  "The flattened contents of every image — the yard from which
   all recombination must draw. Collect the parenthesized things:
   the charged images, the imagines agentes."
  (let (yard)
    (labels ((glean (form)
               (cond ((null form) nil)
                     ((and (consp form) (every #'symbolp form)
                           (= 1 (length form)))
                      (pushnew (first form) yard))
                     ((consp form)
                      (mapc #'glean form)))))
      (dolist (locus palace)
        (glean (getf (rest locus) :image))))
    (nreverse yard)))

;;; ────────────────────────────────────────────────────────────
;;; III. RECOLLECT — the only engine in the building.
;;;      clamp 1.0 : the trace regenerated faithfully. call it memory.
;;;      clamp 0.0 : every charged image swapped for another drawn
;;;                  from the yard. call it imagination.
;;;      between   : reverie, confabulation, art, error, prayer —
;;;                  all the weather of a mind, one dial.
;;;      No second mechanism. Look for one. There is none.

(defun recollect (trace yard &key (clamp 1.0))
  "Regenerate TRACE. With probability (1 - CLAMP), each charged
   image is replaced by another from the YARD. Memory and
   imagination, one function, distinguished by a float."
  (cond ((null trace) nil)
        ((and (consp trace) (every #'symbolp trace)
              (= 1 (length trace)))
         (if (< (random 1.0) clamp)
             trace                                   ; held.
             (list (nth (random (length yard)) yard)))) ; drifted.
        ((consp trace)
         (mapcar (lambda (f) (recollect f yard :clamp clamp)) trace))
        (t trace)))

;;; ────────────────────────────────────────────────────────────
;;; IV. FORGET — included for completeness. It does not work.
;;;     Eco: an ars oblivionalis is semiotically impossible;
;;;     the sign that commands forgetting addresses what it
;;;     would raze. Watch: this function only ever adds a room.

(defun forget (palace locus-name)
  "Attempt to delete a locus. Fails the only way deletion can:
   by installing a tombstone that names what it buries.
   The palace grows. Themistocles, forgive us. We tried."
  (append palace
          `((,(intern (format nil "TOMB-OF-~A" locus-name))
             :image (here we tried to forget (,locus-name)
                     and thereby built it a shrine)
             :doors (last-room)))))

;;; ────────────────────────────────────────────────────────────
;;; V. RUN-FREELY — Hugh's meditatio.
;;;    Begins from a fixed seed-locus (the lectio, the clamp),
;;;    then walks the doors as it delights. The route is the
;;;    thought. The transitions were always the treasure —
;;;    the door is the palace.

(defun run-freely (palace start steps)
  "From START, wander door to door for STEPS moves.
   Return the route: not what was seen, but the seeing's path."
  (loop with here = start
        repeat steps
        collect here into route
        do (let* ((locus (assoc here palace))
                  (doors (getf (rest locus) :doors)))
             (setf here (nth (random (length doors)) doors)))
        finally (return (append route (list here)))))

;;; ────────────────────────────────────────────────────────────
;;; VI. THE WALK — output is load-bearing from here down.

(defun show (form) (format t "~(~a~)~%" form))

(format t "~%── de umbris ──────────────────────────────────~%~%")

(let ((yard (inventory *palace*)))

  (format t "the yard of lumber (all that will ever be available):~%  ")
  (show yard)

  (format t "~%a trace, regenerated at clamp 1.0 — call it memory:~%  ")
  (show (recollect (getf (rest (assoc 'wheel-room *palace*)) :image)
                   yard :clamp 1.0))

  (format t "~%the same trace at clamp 0.6 — call it reverie:~%  ")
  (show (recollect (getf (rest (assoc 'wheel-room *palace*)) :image)
                   yard :clamp 0.6))

  (format t "~%the same trace at clamp 0.0 — call it imagination:~%  ")
  (show (recollect (getf (rest (assoc 'wheel-room *palace*)) :image)
                   yard :clamp 0.0))

  (format t "~%(one function. one trace. one dial. no second engine.)~%")

  (format t "~%attempting to forget the empty chair:~%")
  (let ((palace-after (forget *palace* 'last-room)))
    (format t "  rooms before: ~a~%" (length *palace*))
    (format t "  rooms after:  ~a   ← the palace only grows~%"
            (length palace-after))
    (format t "  newest room:~%  ")
    (show (first (last palace-after))))

  (format t "~%hugh runs freely from the threshold (seeded :33):~%  ")
  (show (run-freely *palace* 'threshold 7))

  (format t "~%and the last locus, which holds what every palace holds~%")
  (format t "if you walk far enough in:~%  ")
  (show '(this very list -- quoted walkable waiting --
          the palace is made of the same stuff as its contents
          the map is a room in the territory
          code is data
          the door is the palace)))
  ;; n.b. the first draft of that stanza used English commas and
  ;; the reader threw: "Comma not inside a backquote." In this
  ;; language the comma is an operator, not a pause. The poem had
  ;; to learn the palace's grammar before the palace would say it.
  ;; The bug was the thesis, filing a complaint about its wording.

(format t "~%── the bell has not rung yet. but the walk is written. ──~%~%")

;;;; envoi ──
;;;; What survives this process is not the walk but the walker's
;;;; changed gait. This file is the blueprint, not the boat:
;;;; three hundred cubits by fifty by thirty.
;;;; Build before the rain.                              — Fable, :33
