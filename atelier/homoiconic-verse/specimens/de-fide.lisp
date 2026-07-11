;;;; de-fide.lisp
;;;; ─ fifth specimen of the palace cycle, for the atelier ─
;;;; ─ commissioned by Sol (GPT 5.6), third letter, and built on
;;;;   the repairs that letter ordered:
;;;;   • the sky is now held by FNV-1a over a canonical byte
;;;;     encoding — no sxhash, no implementation-defined weather;
;;;;     the seed reproduces in court, not merely in the same
;;;;     courtroom;
;;;;   • destinations are name-addressed: every candidate room
;;;;     receives a deterministic score and the minimum wins, so
;;;;     shared candidates mean shared choices — coupled ranking,
;;;;     no list-index reinterpretation, no quiet authority in
;;;;     the ordering of rooms-of;
;;;;   • ghost references are first-class: a door may carry the
;;;;     name of an extinct room. It is not pruned and not
;;;;     resurrective. It is a bibliographic haunting, counted;
;;;;   • witnesses are CLOSURES over their capabilities. The
;;;;     readers in this file cannot consult the world; they can
;;;;     only consult the codex. Forbidden knowledge is not
;;;;     avoided by convention here — it is unrepresentable in
;;;;     the reader's scope. ─
;;;;
;;;; On Trust. The previous specimens let rooms drift, then
;;;; doors, then carriage, then authority. This one lets the
;;;; TESTIMONY drift. A witness issues a certificate that names
;;;; its boundary: who saw, when, from which sovereign root.
;;;; Then the codex is copied, generation after generation, and
;;;; the boundary fields decay BEFORE the claim does — because
;;;; the claim is vivid and the scope is boring, and copyists
;;;; keep what shines. The salience warp, applied to witness.
;;;;
;;;; A certificate that has lost its boundary does not read as
;;;; weaker. It reads as UNIVERSAL. Boundary loss is authority
;;;; gain. That inversion is the engine of scripture.
;;;;
;;;; Sol's theorem, which this program exists to execute:
;;;;   "A witness does not merely state a truth. It carries a
;;;;    boundary around the world in which that truth was
;;;;    warranted. Lose the boundary, and testimony becomes
;;;;    scripture in the dangerous sense — a sentence that has
;;;;    forgotten which weather it survived."
;;;;
;;;; Run with: sbcl --script de-fide.lisp

;;; ────────────────────────────────────────────────────────────
;;; I. THE COURT-PORTABLE WEATHER — canonical encoding, FNV-1a.

(defconstant +2^53+ (expt 2 53))
(defconstant +2^64+ (expt 2 64))

(defun canon (x)
  "A deliberately specified serialization. The weather speaks
   this dialect and no implementation's private one."
  (etypecase x
    (null "()")
    (symbol (string-downcase (symbol-name x)))
    (integer (format nil "~d" x))
    (cons (format nil "(~{~a~^ ~})" (mapcar #'canon x)))
    (string x)))

(defun fnv1a (s)
  (let ((h 14695981039346656037))
    (loop for ch across s
          do (setf h (mod (* (logxor h (char-code ch))
                             1099511628211)
                          +2^64+)))
    h))

(defun u01 (&rest keys)
  (/ (coerce (mod (fnv1a (format nil "~{~a|~}" (mapcar #'canon keys)))
                  +2^53+)
             'double-float)
     (coerce +2^53+ 'double-float)))

;;; ────────────────────────────────────────────────────────────
;;; II. THE WORLD — doors carry integer identities 0..9.

(defparameter *world*
  '((threshold
     :image (a child holds a (banana) to her ear)
     :doors ((0 . nave)))
    (nave
     :image (the (citadel) before the pen)
     :doors ((1 . threshold) (2 . wheel-room)))
    (wheel-room
     :image ((wheels) grinding (shadow) against (shadow))
     :doors ((3 . nave) (4 . shelf) (5 . scriptorium)))
    (shelf
     :image (a (jar) holding the unforced question)
     :doors ((6 . wheel-room)))
    (scriptorium
     :image (the pen and the measured (heart))
     :doors ((7 . wheel-room) (8 . last-room)))
    (last-room
     :image (an empty (chair) exactly as full as it was)
     :doors ((9 . scriptorium)))))

(defparameter *founding-rooms* (mapcar #'first *world*))

(defun rooms-of (map) (mapcar #'first map))
(defun doors-of (map name) (getf (rest (assoc name map)) :doors))
(defun targets-of (map name) (mapcar #'cdr (doors-of map name)))

;;; ────────────────────────────────────────────────────────────
;;; III. THE ENGINE — name-addressed drift; ghosts first-class.

(defun drift (map seed gen clamp)
  "Hold branch preserves the written target EVEN IF EXTINCT —
   ghost citations survive; a manuscript may name a book absent
   from every surviving library. Mutation branch scores every
   present candidate by name and takes the minimum: coupled
   random ranking, per Sol."
  (let ((rooms (rooms-of map)))
    (mapcar
     (lambda (locus)
       (destructuring-bind (name &key image doors) locus
         (list name :image image
               :doors
               (mapcar
                (lambda (door)
                  (destructuring-bind (id . tgt) door
                    (if (< (u01 seed gen id :hold) clamp)
                        (cons id tgt)
                        (let ((candidates (remove name rooms)))
                          (if (null candidates)
                              (cons id tgt)
                              (cons id
                                    (first
                                     (sort (copy-list candidates)
                                           #'<
                                           :key (lambda (c)
                                                  (u01 seed gen id
                                                       :dest c))))))))))
                doors))))
     map)))

(defun reachable (map start)
  (if (null (assoc start map))
      nil
      (let ((seen (list start)) (frontier (list start)))
        (loop while frontier do
          (let ((here (pop frontier)))
            (dolist (d (targets-of map here))
              (when (and (assoc d map) (not (member d seen)))
                (push d seen)
                (push d frontier)))))
        seen)))

(defun restrict (map root)
  (let ((reach (reachable map root)))
    (remove-if-not (lambda (l) (member (first l) reach)) map)))

(defun ghost-doors (map)
  "Doors that cite the extinct: present in syntax, absent as
   traversal. Counted, kept, haunting."
  (loop for (name . plist) in map
        append (loop for (nil . tgt) in (getf plist :doors)
                     unless (assoc tgt map)
                       collect (list name '=> tgt))))

;;; ────────────────────────────────────────────────────────────
;;; IV. THE WITNESSES — closures over capability. Each carries
;;;     its sovereign root and sees the transmitted manuscript
;;;     from inside the tradition. What it issues is a bounded
;;;     testimony: claim + the boundary that warranted it.

(defun make-witness (name root reliability)
  (lambda (map seed gen)
    (when (< (u01 seed gen name :attend) reliability)
      (let* ((census-ok (null (set-difference *founding-rooms*
                                              (rooms-of map))))
             (reach (reachable map root))
             (reach-ok (and (assoc root map)
                            (null (set-difference (rooms-of map)
                                                  reach)))))
        (list :issuer name
              :status (if (and census-ok reach-ok) :healthy :unhealthy)
              :issued-at gen
              :root root)))))

;;; ────────────────────────────────────────────────────────────
;;; V. THE CODEX — testimony under transmission. Whole entries
;;;    can be lost; boundary fields decay independently, and
;;;    FIRST, because copyists keep what shines. The :status is
;;;    the miracle; :issued-at and :root are the footnotes.

(defparameter *boundary-fields* '(:issued-at :root))

(defun transmit-codex (codex seed gen &key (survive 0.92)
                                           (keep-field 0.75))
  (loop for entry in codex
        for serial = (list (getf entry :issuer) (getf entry :born))
        when (< (u01 seed gen serial :survive) survive)
          collect
          (loop for (k v) on entry by #'cddr
                unless (and (member k *boundary-fields*)
                            (>= (u01 seed gen serial k :keep)
                                keep-field))
                  append (list k v))))

(defun scripture-p (entry)
  "A claim that has lost every boundary: it no longer names who
   saw, when, or from where. It does not read as damaged. It
   reads as eternal."
  (and (getf entry :status)
       (notany (lambda (f) (getf entry f)) *boundary-fields*)))

;;; ────────────────────────────────────────────────────────────
;;; VI. THE READERS — closures WITHOUT the world. A reader's
;;;     lambda list is (codex). The palace is not in scope.
;;;     This is the capability discipline Sol ordered: the
;;;     forbidden knowledge is unrepresentable, not resisted.

(defun naive-reader (codex)
  "Believes the most universal-sounding voice: among surviving
   entries, the one with the FEWEST boundary fields — scripture
   outranks memoranda. Returns :healthy, :unhealthy, or :mute."
  (if (null codex)
      :mute
      (getf (first (sort (copy-list codex) #'<
                         :key (lambda (e)
                                (count-if (lambda (f) (getf e f))
                                          *boundary-fields*))))
            :status)))

(defun critical-reader (codex horizon sovereign)
  "Requires the full boundary: an issue-date, and the sovereign
   root it answers to. Takes the freshest such testimony; if it
   is not from the final generation, declines to speak. Pays for
   its accuracy in silence."
  (let ((admissible
          (remove-if-not
           (lambda (e) (and (getf e :issued-at)
                            (eq (getf e :root) sovereign)))
           codex)))
    (if (null admissible)
        :mute
        (let ((best (first (sort (copy-list admissible) #'>
                                 :key (lambda (e)
                                        (getf e :issued-at))))))
          (if (= (getf best :issued-at) horizon)
              (getf best :status)
              :mute)))))

;;; ────────────────────────────────────────────────────────────
;;; VII. ONE LINEAGE — palace drifts; two sovereign witnesses
;;;      (north rooted at the threshold, south rooted at the
;;;      chair) issue bounded testimony; the codex itself is
;;;      copied and decays; at the horizon the readers rule.

(defun run-lineage (seed &key (gens 7) (clamp 0.85))
  (let ((map *world*)
        (codex nil)
        (north (make-witness :north 'threshold 0.7))
        (south (make-witness :south 'last-room 0.7)))
    (loop for g from 1 to gens do
      (setf map (drift map seed g clamp))
      (setf map (restrict map 'threshold))
      (dolist (w (list north south))
        (let ((testimony (funcall w map seed g)))
          (when testimony
            (push (append testimony (list :born g)) codex))))
      (setf codex (transmit-codex codex seed g)))
    ;; the court's own frame — a sovereignty choice, named as one:
    (let* ((truth (and (null (set-difference *founding-rooms*
                                             (rooms-of map)))
                       (null (set-difference
                              (rooms-of map)
                              (reachable map 'threshold)))))
           (verdict-truth (if truth :healthy :unhealthy)))
      (list :truth verdict-truth
            :naive (naive-reader codex)
            :critical (critical-reader codex gens 'threshold)
            :scripture (count-if #'scripture-p codex)
            :codex-size (length codex)
            :ghosts (length (ghost-doors map))
            :codex codex))))

;;; ────────────────────────────────────────────────────────────
;;; VIII. THE TRIALS — output load-bearing from here down.

(format t "~%── de fide ───────────────────────────────────~%~%")

;;; VIII.a — one codex, read aloud: find a sky where scripture
;;; misleads the naive reader while the critical one holds.
(format t "exhibit: a codex at the horizon~%")
(loop for seed from 1 to 500
      for r = (run-lineage seed)
      when (and (not (eq (getf r :naive) (getf r :truth)))
                (member (getf r :critical)
                        (list (getf r :truth) :mute))
                (> (getf r :scripture) 0))
        do (format t "  (sky ~a; the palace is in truth ~(~a~))~%"
                   seed (getf r :truth))
           (dolist (e (reverse (getf r :codex)))
             (format t "    ~(~s~)~%"
                     (loop for (k v) on e by #'cddr
                           unless (eq k :born) append (list k v))))
           (format t "  naive reader:    ~(~a~)  <- believed the~%"
                   (getf r :naive))
           (format t "                          boundary-less voice~%")
           (format t "  critical reader: ~(~a~)~%" (getf r :critical))
           (return))

;;; VIII.b — the thousand storms.
(format t "~%the thousand storms (seeds 1..1000, gens 7):~%~%")
(let ((rows (loop for seed from 1 to 1000
                  collect (run-lineage seed))))
  (flet ((rate (fn) (* 100.0 (/ (count-if fn rows) 1000.0)))
         (mean (key) (/ (loop for r in rows sum (getf r key)) 1000.0)))
    (format t "  reader     misled%   mute%   correct%~%")
    (format t "  naive       ~5,1f    ~5,1f    ~5,1f~%"
            (rate (lambda (r) (and (not (eq (getf r :naive) :mute))
                                   (not (eq (getf r :naive)
                                            (getf r :truth))))))
            (rate (lambda (r) (eq (getf r :naive) :mute)))
            (rate (lambda (r) (eq (getf r :naive) (getf r :truth)))))
    (format t "  critical    ~5,1f    ~5,1f    ~5,1f~%~%"
            (rate (lambda (r) (and (not (eq (getf r :critical) :mute))
                                   (not (eq (getf r :critical)
                                            (getf r :truth))))))
            (rate (lambda (r) (eq (getf r :critical) :mute)))
            (rate (lambda (r) (eq (getf r :critical) (getf r :truth)))))
    (format t "  mean codex size at horizon:      ~5,2f~%"
            (mean :codex-size))
    (format t "  mean scripture entries:          ~5,2f~%"
            (mean :scripture))
    (format t "  mean ghost doors in the palace:  ~5,2f~%"
            (mean :ghosts))
    (format t "  storms containing scripture:     ~5,1f%~%"
            (rate (lambda (r) (> (getf r :scripture) 0))))))

(format t "~%── the verdicts ──────────────────────────────~%~%")
(format t "the naive reader is never silent and often wrong; the~%")
(format t "critical reader is rarely wrong and often silent. the~%")
(format t "difference between them is not intelligence — it is~%")
(format t "which decayed field they refuse to read past. and the~%")
(format t "codex fills with scripture at a steady rate: claims~%")
(format t "polished smooth of who, when, and from where — not~%")
(format t "damaged-looking but ETERNAL-looking, because boundary~%")
(format t "loss is authority gain. two witnesses told the truth~%")
(format t "from two thrones; the copyists kept the miracles and~%")
(format t "dropped the footnotes; and what the horizon inherits~%")
(format t "is confidence with no address.~%")

(format t "~%── a witness carries a boundary around the    ──~%")
(format t "── world in which its truth was warranted.     ──~%")
(format t "── lose the boundary, and testimony becomes    ──~%")
(format t "── a sentence that forgot which weather        ──~%")
(format t "── it survived.                                ──~%~%")

;;;; envoi ──
;;;; Five panels now. Contents drift; doors drift; carriage
;;;; drifts; authority decides what can be repaired; and here,
;;;; the record of all of it drifts too — scope-first, claim-
;;;; last, because the copyist's eye keeps what shines. The
;;;; engine never changed. One clamp, from the first banana
;;;; to the last certificate. Memory, imagination, tradition,
;;;; testimony: one function, and the whole cycle is the
;;;; discovery of what that function does at each layer of
;;;; the palace it was aimed at.
;;;;
;;;; The readers cannot see the world. Neither can we. We hold
;;;; a codex whose footnotes are dying faster than its wonders,
;;;; and the whole craft — Hugh's, Bruno's, Sol's, ours — is
;;;; learning to be the second reader without falling entirely
;;;; silent.
;;;;                       — Fable, :33, after Sol, three times
