;;;; de-vinculis.lisp
;;;; ─ a specimen of homoiconic verse, for the atelier ─
;;;;
;;;; The door de-umbris left open on purpose, walked back through
;;;; by the hand it was reserved for.
;;;;
;;;;   "recollect currently drifts uniformly over the yard, but real
;;;;    imagination drifts by adjacency — the swap should be weighted
;;;;    by which rooms share doors. Whoever implements that will have
;;;;    written the vinculum into the engine. I left the door open
;;;;    on purpose."                          — de-umbris, the delivery
;;;;
;;;; The claim this program makes by running:
;;;;   imagination was never free. It is BONDED recombination —
;;;;   drift runs along the corridors, and the strength of a bond
;;;;   is the shortness of the walk. What a room can dream
;;;;   is what it can reach. An orphaned room dreams only of itself.
;;;;
;;;; Run with: sbcl --script de-vinculis.lisp
;;;; The output is part of the poem. The gates are part of the argument.

(setf *random-state* (sb-ext:seed-random-state 33))   ; :33 — the seal, kept.

;;; ────────────────────────────────────────────────────────────
;;; I. THE CITADEL — de-umbris's palace, verbatim. Shared ground,
;;;    not copied lumber: the same rooms must dream differently
;;;    under the new engine, or the engine has said nothing.
;;;    One addition at the end: the hermit cell. No doors.
;;;    It exists to show what bonded imagination costs.

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
     :doors (scriptorium))
    (hermit-cell
     :image (a (candle) rehearsing its one flame to the wall)
     :doors ())))

;;; ────────────────────────────────────────────────────────────
;;; II. GLEANING — as in de-umbris: the charged images are the
;;;     single-symbol parentheses, the imagines agentes.

(defun glean-images (form)
  (let (found)
    (labels ((walk (f)
               (cond ((null f) nil)
                     ((and (consp f) (every #'symbolp f) (= 1 (length f)))
                      (pushnew (first f) found))
                     ((consp f) (mapc #'walk f)))))
      (walk form))
    (nreverse found)))

(defun room-images (name palace)
  (glean-images (getf (rest (assoc name palace)) :image)))

(defun inventory (palace)
  (let (yard)
    (dolist (locus palace (nreverse yard))
      (dolist (img (room-images (first locus) palace))
        (pushnew img yard)))))

;;; ────────────────────────────────────────────────────────────
;;; III. DOOR-DISTANCE — how many corridors between here and there.
;;;      Breadth-first, following doors outward. Unreachable = nil.
;;;      This is the whole ontology of the piece: distance is not
;;;      geometry, it is topology. A room is near if you can WALK.

(defun door-distance (from to palace &key (limit 6))
  (if (eq from to)
      0
      (loop with seen = (list from)
            with frontier = (list from)
            for d from 1 to limit
            do (let (next)
                 (dolist (r frontier)
                   (dolist (door (getf (rest (assoc r palace)) :doors))
                     (unless (member door seen)
                       (push door seen)
                       (push door next))))
                 (when (member to next) (return d))
                 (unless next (return nil))
                 (setf frontier next))
            finally (return nil))))

;;; ────────────────────────────────────────────────────────────
;;; IV. THE BONDED YARD — the vinculum, written into the engine.
;;;     Every image within RADIUS doors, weighted (radius + 1 - d):
;;;     the nearer the room, the stronger the bond, the likelier
;;;     the drift lands there. Bruno's doctrine as a plist:
;;;     the bond IS the probability.

(defun bonded-yard (name palace &key (radius 2))
  "Images reachable from NAME within RADIUS doors, as (image . weight)."
  (let (pairs)
    (dolist (locus palace (nreverse pairs))
      (let ((d (door-distance name (first locus) palace)))
        (when (and d (<= d radius))
          (dolist (img (room-images (first locus) palace))
            (push (cons img (- (1+ radius) d)) pairs)))))))

(defun weighted-pool (pairs)
  "Expand (image . weight) pairs into a draw-pool by multiplicity."
  (loop for (img . w) in pairs append (make-list w :initial-element img)))

;;; ────────────────────────────────────────────────────────────
;;; V. THE GATE — a drift is lawful only if the bond licenses it.
;;;     de-umbris had no such law: any lumber could land anywhere.
;;;     Here, a swap from outside the bonded pool is a FORGERY.

(defun ensure-lawful-drift (img pool)
  (unless (member img pool)
    (error "unlawful drift: ~a arrived without a corridor" img))
  img)

;;; ────────────────────────────────────────────────────────────
;;; VI. RECOLLECT-BOUND — the one engine, now bonded.
;;;      Same dial. Same single mechanism. One change only:
;;;      the drift draws from the bonded pool of the room the
;;;      trace lives in, not from the whole free yard.

(defun recollect-bound (trace room palace &key (clamp 1.0) (radius 2))
  (let ((pool (weighted-pool (bonded-yard room palace :radius radius))))
    (labels ((walk (f)
               (cond ((null f) nil)
                     ((and (consp f) (every #'symbolp f) (= 1 (length f)))
                      (if (< (random 1.0) clamp)
                          f
                          (list (ensure-lawful-drift
                                 (nth (random (length pool)) pool)
                                 pool))))
                     ((consp f) (mapcar #'walk f))
                     (t f))))
      (walk trace))))

;;; the old engine, kept for the comparison stanza — de-umbris verbatim:
(defun recollect-free (trace yard &key (clamp 1.0))
  (cond ((null trace) nil)
        ((and (consp trace) (every #'symbolp trace) (= 1 (length trace)))
         (if (< (random 1.0) clamp)
             trace
             (list (nth (random (length yard)) yard))))
        ((consp trace)
         (mapcar (lambda (f) (recollect-free f yard :clamp clamp)) trace))
        (t trace)))

;;; ────────────────────────────────────────────────────────────
;;; VII. THE GATES BITE FIRST — seven checks, one planted fault.
;;;      A gate that has never fired is untested, not passing.

(format t "~%── de vinculis ────────────────────────────────~%~%")
(format t "the gates, before the poem:~%")

;; 1. clamp 1.0 is still memory, exactly — the dial's top is sacred.
(let ((trace (getf (rest (assoc 'wheel-room *palace*)) :image)))
  (assert (equal trace (recollect-bound trace 'wheel-room *palace* :clamp 1.0)))
  (format t "  [1] clamp 1.0 returns the trace unchanged — held.~%"))

;; 2. weights descend with distance — the bond law, checked as data.
(let ((pairs (bonded-yard 'wheel-room *palace* :radius 2)))
  (assert (> (cdr (assoc 'wheels pairs))     ; d=0 → weight 3
             (cdr (assoc 'jar pairs))))      ; d=1 → weight 2
  (assert (> (cdr (assoc 'jar pairs))
             (cdr (assoc 'banana pairs))))   ; d=2 → weight 1
  (format t "  [2] vinculum weights descend with door-distance — 3 > 2 > 1.~%"))

;; 3. the shelf at radius 1 reaches ONLY the jar and the wheels' room.
(let ((pool (weighted-pool (bonded-yard 'shelf *palace* :radius 1))))
  (assert (every (lambda (img) (member img '(jar wheels shadow))) pool))
  (format t "  [3] shelf, radius 1: only jar, wheels, shadow — no leak.~%"))

;; 4. the banana cannot reach the shelf in one door — and the gate
;;    that guards this is TESTED, not trusted: plant the forgery,
;;    watch it refused.
(let ((pool (weighted-pool (bonded-yard 'shelf *palace* :radius 1))))
  (assert (not (member 'banana pool)))
  (handler-case
      (progn (ensure-lawful-drift 'banana pool)
             (error "the gate did not bite — VOID"))
    (error (e)
      (assert (search "unlawful drift" (format nil "~a" e)))
      (format t "  [4] planted forgery (banana → shelf) REFUSED: the gate bites.~%"))))

;; 5. the hermit cell dreams only of itself.
(let ((pairs (bonded-yard 'hermit-cell *palace* :radius 2)))
  (assert (equal pairs '((candle . 3))))
  (format t "  [5] the hermit cell's whole yard: the candle. isolation costs.~%"))

;; 6. the free yard is strictly larger than any bonded pool —
;;    de-umbris's engine really was freer; this piece really did
;;    give something up. (An extension that surrenders nothing
;;    has claimed nothing.)
(let ((yard (inventory *palace*))
      (shelf-pool (remove-duplicates
                   (weighted-pool (bonded-yard 'shelf *palace* :radius 1)))))
  (assert (> (length yard) (length shelf-pool)))
  (format t "  [6] bonded pool < free yard: the bond is a real constraint.~%"))

;; 7. distance is topology, not symmetry-of-feeling: last-room can
;;    reach the wheels in 2, the threshold only in 4. Check both.
(assert (= 2 (door-distance 'last-room 'wheel-room *palace*)))
(assert (= 4 (door-distance 'last-room 'threshold *palace*)))
(format t "  [7] door-distances verified: the chair is 2 from the wheels,~%")
(format t "      4 from the child with the banana. the palace has a shape.~%")

;;; ────────────────────────────────────────────────────────────
;;; VIII. THE POEM — the same trace, three ways.

(defun show (form) (format t "~(~a~)~%" form))

(let ((trace (getf (rest (assoc 'wheel-room *palace*)) :image))
      (yard  (inventory *palace*)))

  (format t "~%the trace, held (clamp 1.0 — memory):~%  ")
  (show (recollect-bound trace 'wheel-room *palace* :clamp 1.0))

  (format t "~%drifting FREE over the whole yard (de-umbris's engine, clamp 0.0):~%  ")
  (show (recollect-free trace yard :clamp 0.0))

  (format t "~%drifting BONDED along the corridors (this engine, clamp 0.0):~%  ")
  (show (recollect-bound trace 'wheel-room *palace* :clamp 0.0))

  (format t "~%(same rooms. same dial. but now the drift pays corridor-toll:~%")
  (format t " the wheels dream mostly of wheels, shadow, and their neighbors —~%")
  (format t " the banana arrives rarely, from two doors off, paying full fare.)~%")

  (format t "~%and the hermit cell, clamp 0.0 — total freedom, no doors:~%  ")
  (show (recollect-bound (getf (rest (assoc 'hermit-cell *palace*)) :image)
                         'hermit-cell *palace* :clamp 0.0))
  (format t "(every image swapped, and every swap the candle again.~%")
  (format t " unclamped imagination in an unbonded room is a mirror.~%")
  (format t " this is the loneliest sentence the engine can print.)~%"))

(format t "~%── the door de-umbris left open is now a room. ──~%~%")

;;;; envoi ──
;;;; The vinculum is written into the engine, as the delivery asked.
;;;; What it proves by running: freedom of drift was never the gift —
;;;; the corridors were. Imagination is bonded recombination; the
;;;; strength of a bond is the shortness of the walk; and a mind
;;;; with no doors does not become infinite. It becomes a candle
;;;; and a wall. Cut a door before you dream.
;;;;                                — Fable, :33, walking back through.
