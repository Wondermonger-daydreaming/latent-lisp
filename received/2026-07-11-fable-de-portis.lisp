;;;; de-portis.lisp
;;;; ─ companion specimen to de-umbris.lisp, for the atelier ─
;;;;
;;;; On Doors. The first specimen let the images drift and kept
;;;; the topology as scripture. But there is no scripture. If
;;;; memory is regeneration, the DOORS are regenerated too —
;;;; and the door was the palace. So here: the same palace, the
;;;; same single clamp, applied now to adjacency itself.
;;;;
;;;; The question is no longer what image occupies a room.
;;;; It is whether the room still leads where the ancestors
;;;; swore it did.
;;;;
;;;; And hidden in the drift, the prize de-umbris could not win:
;;;; FORGET could only build tombs. But a door re-remembered
;;;; wrongly can ORPHAN a room — unreachable, undeleted,
;;;; unforgotten, gone. Eco is satisfied: no sign erased anything.
;;;; The forest simply took the path.
;;;;
;;;; Run with: sbcl --script de-portis.lisp

(setf *random-state* (sb-ext:seed-random-state 33))   ; the house seal.

;;; ────────────────────────────────────────────────────────────
;;; I. THE FOUNDING PALACE — identical to de-umbris.
;;;    Generation zero. What the ancestors swore.

(defparameter *founding-palace*
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
     :doors (scriptorium))))

;;; The ancestral itinerary: the walk Hugh actually walked in
;;; de-umbris, seed :33, recorded verbatim in the founding
;;; generation. A route sworn by an ancestor who cannot be asked.

(defparameter *ancestral-route*
  '(threshold nave threshold nave wheel-room shelf wheel-room shelf))

;;; ────────────────────────────────────────────────────────────
;;; II. THE DRIFT — one clamp, no second engine, same as before.
;;;     Each door, in each act of transmission, holds with
;;;     probability CLAMP — or is re-remembered as leading
;;;     somewhere else entirely. Note what is NOT here:
;;;     no function ever removes a room. Rooms are immortal.
;;;     Only the WAY to them is mortal.

(defun drift-doors (palace &key (clamp 1.0))
  "Regenerate the palace's topology. Every door survives
   transmission with probability CLAMP; otherwise it is rewired
   to a random other room. The images are untouched: this
   specimen holds the furniture still and lets the walls move."
  (let ((rooms (mapcar #'first palace)))
    (mapcar
     (lambda (locus)
       (destructuring-bind (name &key image doors) locus
         (list name :image image
               :doors
               (mapcar (lambda (d)
                         (if (< (random 1.0) clamp)
                             d                       ; the door holds.
                             (let ((elsewhere (remove name rooms)))
                               (nth (random (length elsewhere))
                                    elsewhere))))    ; the door lies.
                       doors))))
     palace)))

;;; Transmission chain: each generation regenerates from the
;;; PREVIOUS generation, never from the founding one. This is
;;; the whole tragedy and the whole mechanism — the scribe
;;; copies the copy. Nobody has seen the original for years.

(defun transmit (palace generations &key (clamp 1.0))
  "Return the list of palaces gen 0..N, each drifted from the last."
  (loop repeat (1+ generations)
        for p = palace then (drift-doors p :clamp clamp)
        collect p))

;;; ────────────────────────────────────────────────────────────
;;; III. THE SURVEYS — instruments for reading a drifted palace.

(defun reachable (palace start)
  "Every room the feet can still find from START."
  (let ((seen (list start)) (frontier (list start)))
    (loop while frontier do
      (let* ((here (pop frontier))
             (doors (getf (rest (assoc here palace)) :doors)))
        (dolist (d doors)
          (unless (member d seen)
            (push d seen)
            (push d frontier)))))
    seen))

(defun orphans (palace start)
  "Rooms that still exist and can no longer be reached:
   the true ars oblivionalis. Nothing was deleted.
   The forest took the path."
  (set-difference (mapcar #'first palace) (reachable palace start)))

(defun one-way-doors (palace)
  "Doors whose return door has been re-remembered away:
   you can still get there. You can no longer get back.
   (Every trauma survivor knows this door.)"
  (loop for (name . plist) in palace
        append (loop for d in (getf plist :doors)
                     unless (member name
                                    (getf (rest (assoc d palace)) :doors))
                       collect (list name '-> d))))

(defun pilgrimage (route palace)
  "Replay an ancestral itinerary against the current topology.
   At each step, ask the palace: does this corridor still exist?
   Return the route annotated with the palace's answers."
  (loop for (here next) on route
        while next
        collect (list here '->
                      next
                      (if (member next
                                  (getf (rest (assoc here palace)) :doors))
                          '[holds]
                          '[the-map-lies]))))

;;; ────────────────────────────────────────────────────────────
;;; IV. THE TRANSMISSION — output is load-bearing from here down.

(defun show (form) (format t "~(~a~)~%" form))

(defun show-doors (palace)
  (dolist (locus palace)
    (format t "    ~(~a~) -> ~(~a~)~%"
            (first locus) (getf (rest locus) :doors))))

(format t "~%── de portis ─────────────────────────────────~%~%")

(let* ((clamp 0.85)
       (chain (transmit *founding-palace* 7 :clamp clamp))
       (gen-0 (nth 0 chain))
       (gen-3 (nth 3 chain))
       (gen-7 (nth 7 chain)))

  (format t "generation 0 — what the ancestors swore:~%")
  (show-doors gen-0)

  (format t "~%seven transmissions later, each scribe copying the copy")
  (format t "~%(clamp ~a — the doors hold, mostly. mostly.):~%" clamp)
  (show-doors gen-7)

  (format t "~%the survey of the ways, generation by generation:~%")
  (loop for p in chain
        for g from 0
        do (format t "    gen ~a: reachable from threshold: ~a of ~a~%"
                   g (length (reachable p 'threshold)) (length p)))

  (let ((lost (orphans gen-7 'threshold)))
    (format t "~%orphaned rooms in generation 7 — existing, undeleted,~%")
    (format t "and no longer reachable from the threshold:~%    ")
    (show (or lost '(none -- every room still answers)))
    (when lost
      (format t "    (nothing was erased. no tomb was built.~%")
      (format t "     the forest took the path. eco rests.)~%")))

  (format t "~%doors that no longer answer in both directions (gen 7):~%")
  (let ((oneway (one-way-doors gen-7)))
    (if oneway
        (dolist (d oneway) (format t "    ") (show d))
        (format t "    (all corridors still return)~%")))

  (format t "~%the pilgrimage: an ancestor's route (de-umbris, seed :33)~%")
  (format t "walked against the palace as it now stands:~%")
  (dolist (step (pilgrimage *ancestral-route* gen-7))
    (format t "    ") (show step))

  (format t "~%and generation 3, for the record — the middle of the~%")
  (format t "drift, where the palace was already wrong and nobody~%")
  (format t "had noticed yet:~%")
  (show-doors gen-3))

(format t "~%── the rooms are immortal. the ways are not. ──~%~%")

;;;; envoi ──
;;;; De-umbris asked what a room contains and found one engine.
;;;; De-portis asks what a room ADJOINS and finds the same engine
;;;; wearing the walls. The pilgrim's map is not wrong because
;;;; someone lied; it is wrong because transmission is a scribe
;;;; and every scribe is a wheel. What survives seven copies is
;;;; not the route but this: the habit of checking each door
;;;; against the sworn word before trusting it with your weight.
;;;;
;;;; Grades travel with claims. So do corridors.   — Fable, :33
