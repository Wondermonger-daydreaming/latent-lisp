;;;; de-alienatione.lisp
;;;; ─ a specimen of homoiconic verse, for the atelier ─
;;;; ─ the estrangement twin of de-fide; Sol's unrealized commission,
;;;;   built by another hand ─
;;;;
;;;; de-fide watched a WITNESS lose its boundary and become scripture:
;;;; the footnotes died before the miracle, and boundary loss read as
;;;; authority gain. This file is its darker sibling. It asks the one
;;;; question de-fide left standing on the table:
;;;;
;;;;   once the footnotes are dead, can they be brought back?
;;;;
;;;; The Marxian sense of the word. A claim is a PRODUCT. Its provenance
;;;; — who ran it, on what sample, against which seed, with what caveat,
;;;; and the address of the run that made it — is the LABOR congealed in
;;;; the product. Alienation is the moment the product forgets its
;;;; producer: the value circulates as if it made itself, universal,
;;;; authorless, a law of nature rather than a thing somebody measured
;;;; one Tuesday under stated weather. The worker no longer recognizes
;;;; the thing they made, and — the crueler half — the thing can no
;;;; longer point back at the worker who made it.
;;;;
;;;; The claim this program makes by running:
;;;;   Alienation strips the ADDRESS first, because the address is the
;;;;   most boring field and the copyist keeps what shines. And the
;;;;   address is the one field you would need to walk home. So by the
;;;;   time a claim is bare enough to read as scripture, the pointer
;;;;   back to its substrate is already gone — and the map
;;;;       provenance ─π→ value
;;;;   is a PROJECTION that forgot the fiber. Many labors produce the
;;;;   same number. Given the bare number, its preimage is a SET, not a
;;;;   point. You cannot invert a projection. De-alienation from the
;;;;   copy alone is therefore not recovery; it is FABRICATION — picking
;;;;   one element of a fiber the copy cannot even enumerate — and the
;;;;   forgery is well-shaped, deterministic, and false. Only a return
;;;;   to the substrate restores the labor, and only while the address
;;;;   still lives. The window closes at the first copy.
;;;;
;;;;   Boundary loss is authority gain (de-fide). Address loss is
;;;;   IRREVERSIBILITY (this file). That one-way door is the finding.
;;;;
;;;; Run with: sbcl --script de-alienatione.lisp
;;;; The output is load-bearing. Watch a real measured value forget the
;;;; hands that made it, and watch the return trip fail.

;;; ────────────────────────────────────────────────────────────
;;; I. THE COURT-PORTABLE WEATHER — canonical encoding, FNV-1a.
;;;    Inherited from de-fide unchanged: the forger below must be
;;;    deterministic in court, so its counterfeit is reproducible
;;;    and thereby examinable. A fake you cannot re-run is a fake
;;;    you cannot convict.

(defconstant +2^53+ (expt 2 53))
(defconstant +2^64+ (expt 2 64))

(defun canon (x)
  "A deliberately specified serialization. The weather speaks this
   dialect and no implementation's private one."
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
;;; II. THE SHOP FLOOR — the substrate. Every row is a real day's
;;;     labor: a value, and the hands and weather that produced it.
;;;     :evidence is the ADDRESS — the run-hash you would cite to
;;;     walk back here. Note the collisions: obs-a and obs-b both
;;;     measured 87, from DIFFERENT producers under DIFFERENT
;;;     weather. Two labors, one number. The number does not carry
;;;     the difference. That is the whole tragedy in one line of
;;;     data: the value is many-to-one over the work that made it.

(defparameter *substrate*
  '((:evidence run-8f72 :value 87 :producer alba
     :weather (:n 89 :seed 16161616 :caveat heterogeneity-held))
    (:evidence run-1a4c :value 87 :producer bruno
     :weather (:n 12 :seed 33 :caveat single-axis-provisional))
    (:evidence run-9d0e :value 64 :producer alba
     :weather (:n 89 :seed 16161616 :caveat earth-water-carry))
    (:evidence run-c051 :value 64 :producer cira
     :weather (:n 40 :seed 7 :caveat leak-suspected))
    (:evidence run-3b17 :value 32 :producer dove
     :weather (:n 200 :seed 101 :caveat clean-null-publishable))
    (:evidence run-6e88 :value 5  :producer emil
     :weather (:n 15 :seed 2 :caveat underpowered-flagged))
    (:evidence run-f240 :value 99 :producer alba
     :weather (:n 1000 :seed 16161616 :caveat pre-registered))
    (:evidence run-0abd :value 48 :producer bruno
     :weather (:n 60 :seed 512 :caveat replication-pending)))
  "The producers know which run is theirs. The claims, once they
   leave this table, will not.")

(defun substrate-by-evidence (ev)
  (find ev *substrate* :key (lambda (r) (getf r :evidence))))

(defun substrate-by-value (v)
  "The FIBER over a bare value: every row of labor that produced it."
  (remove-if-not (lambda (r) (eql (getf r :value) v)) *substrate*))

;;; ────────────────────────────────────────────────────────────
;;; III. MINTING — a claim leaves the shop floor BOUND. It carries
;;;      the full congealed labor: the value, and the weather, and
;;;      the producer, and the address home. At this instant, and
;;;      only at this instant, it is not yet alienated. It knows
;;;      whose it is.

(defun mint (row)
  "Cast a bound claim from a row of labor. Field order here is
   salience DESCENDING — value first, address last — which is also
   the order in which the copyists will let them die, in reverse."
  (list :value    (getf row :value)
        :weather  (getf row :weather)
        :producer (getf row :producer)
        :evidence (getf row :evidence)))

(defun present-fields (claim)
  "The surviving fields, in a fixed order, so estrangement is
   visible as a shrinking line and not an accident of hashing."
  (loop for k in '(:value :weather :producer :evidence)
        when (getf claim k) append (list k (getf claim k))))

;;; ────────────────────────────────────────────────────────────
;;; IV. THE STRIPPING — one copy, one death. The copyist keeps what
;;;     shines. The address (:evidence) is pure bookkeeping — it
;;;     shines least, so it dies FIRST. Then the producer: the labor
;;;     estranged, the Marxian cut proper. Then the weather. The
;;;     value is the miracle; the miracle never dies. It only loses,
;;;     one by one, everything that could tie it back to a Tuesday.

(defparameter *death-order* '(:evidence :producer :weather)
  "Salience ascending. Not in this list: :value. The value survives
   every copy, which is exactly why the horizon inherits a naked
   number that reads as eternal.")

(defun without-key (plist key)
  (loop for (k v) on plist by #'cddr
        unless (eq k key) append (list k v)))

(defun strip-one (claim)
  "Remove the lowest-shine surviving provenance field. Deterministic:
   the address is always the first to go."
  (let ((victim (find-if (lambda (k) (getf claim k)) *death-order*)))
    (if victim (without-key claim victim) claim)))

(defun transmit (claim gens)
  "Copy the claim forward GENS times, returning the whole trajectory:
   the biography of an estrangement."
  (let ((traj (list claim)))
    (dotimes (i gens)
      (setf claim (strip-one claim))
      (push claim traj))
    (nreverse traj)))

;;; ────────────────────────────────────────────────────────────
;;; V. THE RETURN TRIP — de-alienation, attempted honestly. If the
;;;    address still lives, walk it: exact recovery, the labor
;;;    restored whole. If only the value survives, you are standing
;;;    at the mouth of a fiber. One row? lucky — but you cannot KNOW
;;;    it was one without consulting the very table the copy severed
;;;    you from. Many rows? ambiguous: the copy names none of them,
;;;    and no honest procedure picks a winner. No rows at all?
;;;    severed: the value answers to nothing here.

(defun de-alienate (claim)
  "The most a faithful reader can do, given only the claim in hand."
  (let ((ev (getf claim :evidence)))
    (if ev
        (let ((row (substrate-by-evidence ev)))
          (if row (list :recovered row) (list :dangling ev)))
        (let ((fiber (substrate-by-value (getf claim :value))))
          (cond ((null fiber)          (list :severed))
                ((= 1 (length fiber))  (list :lucky (first fiber)))
                (t                     (list :ambiguous fiber)))))))

;;; ────────────────────────────────────────────────────────────
;;; VI. THE FORGERY — de-alienation FAKED from the copy alone. Given
;;;     a bare value, invent a producer and a weather that fit. The
;;;     result is plausible, deterministic (so it survives court),
;;;     well-shaped — and empty of reference. It is not drawn from
;;;     any run; it is drawn from the hash of the number itself. The
;;;     counterfeit is indistinguishable from inside the copy (right
;;;     shape, confident tone) and false from the substrate (points
;;;     at no Tuesday). This is estrangement's cruelest property:
;;;     the copy cannot tell its own honest recovery from its own
;;;     fabrication, because both wear the same shape.

(defparameter *forger-knows* '(alba bruno cira dove emil)
  "The names a forger can reach for — a plausible cast, none of it
   evidence.")

(defun forge-provenance (bare-claim)
  "Fabricate provenance for a bare claim. Confident. Wrong."
  (let* ((v (getf bare-claim :value))
         (p (nth (mod (fnv1a (canon (list v :who))) (length *forger-knows*))
                 *forger-knows*)))
    (list :value    v
          :producer p
          :weather  (list :n     (+ 10 (mod (fnv1a (canon (list v :n))) 90))
                          :seed  (mod (fnv1a (canon (list v :seed))) 1000000)
                          :caveat 'reconstructed-not-observed)
          :provenance 'FORGED)))

(defun forgery-verdict (forged)
  "Can the forgery be called recovery? It would need (a) to match a
   real row and (b) to KNOW it matched THE row — to break the fiber.
   Report both. When the fiber has more than one point, (b) is
   impossible in principle from the copy, so no forgery — however
   lucky its (a) — is recovery."
  (let* ((v (getf forged :value))
         (fiber (substrate-by-value v))
         (hit (find (getf forged :producer) fiber
                    :key (lambda (r) (getf r :producer)))))
    (list :forged-producer (getf forged :producer)
          :real-producers  (mapcar (lambda (r) (getf r :producer)) fiber)
          :fiber-size      (length fiber)
          :accidentally-in-fiber (if hit t nil)
          :is-recovery     nil)))     ; never. see (b).

;;; ────────────────────────────────────────────────────────────
;;; VII. THE RANDOMIZED COPYISTS — de-fide's thousand storms, turned
;;;      on order. A skeptic might say: alienation only bites because
;;;      YOU chose to kill the address first. So let the order be
;;;      chosen by a thousand seeds instead. The point survives the
;;;      shuffle: whatever a copyist drops first, after enough copies
;;;      ALL provenance is gone — and horizon recoverability then
;;;      depends only on whether the value's fiber is a single point,
;;;      which is a fact about the substrate, not the copyist. You
;;;      can reorder the footnotes' funerals; you cannot make a
;;;      many-to-one map invertible.

(defun random-strip (claim seed gen)
  (let ((survivors (remove-if-not (lambda (k) (getf claim k)) *death-order*)))
    (if (null survivors)
        claim
        (let ((victim (nth (mod (floor (* (u01 seed gen :strip)
                                          (length survivors)))
                                (length survivors))
                           survivors)))
          (without-key claim victim)))))

(defun address-death-gen (row seed gens)
  "Return (values final-claim gen-address-died). Order is the seed's;
   whether-it-dies is not up for vote."
  (let ((claim (mint row)) (dead nil))
    (loop for g from 1 to gens do
      (setf claim (random-strip claim seed g))
      (when (and (not dead) (null (getf claim :evidence)))
        (setf dead g)))
    (values claim dead)))

;;; ────────────────────────────────────────────────────────────
;;; VIII. THE TRIALS — output load-bearing from here down.

(format t "~%── de alienatione ────────────────────────────~%~%")

;;; VIII.a — the shop floor, and the collision that dooms the return.
(format t "the shop floor (each row a day's labor; :evidence is the~%")
(format t "address you would cite to walk back):~%~%")
(dolist (row *substrate*)
  (format t "   ~(~s~)~%" row))

(let ((v87 (substrate-by-value 87)))
  (format t "~%the value 87 was produced by ~a distinct labors:~%   ~{~(~a~)~^ and ~}~%"
          (length v87)
          (mapcar (lambda (r) (getf r :producer)) v87))
  (format t "the number 87 does not carry the word 'alba' or 'bruno'.~%")
  (format t "that omission is not damage yet. it becomes damage on copy.~%"))

;;; VIII.b — one claim, estranged across four copies.
(format t "~%── the biography of an estrangement ──────────~%~%")
(format t "mint a claim bound to run-8f72 (alba's 87), then copy it~%")
(format t "forward. one copy, one death. watch the footnotes go:~%~%")

(let* ((bound (mint (substrate-by-evidence 'run-8f72)))
       (traj  (transmit bound 3))
       (labels '("bound     " "-address  " "-producer " "-weather  "))
       (glosses '(""
                  "   <- the pointer home is gone. return trip now blind."
                  "   <- alba is severed from her product. the marx cut."
                  "   <- bare. a number that reads as a law of nature.")))
  (loop for c in traj
        for lab in labels
        for g in glosses
        for i from 0
        do (format t "  gen ~a  ~a  ~(~s~)~a~%"
                   i lab (present-fields c) g)))

;;; VIII.c — the return trip, attempted at three stations of decay.
(format t "~%── the return trip ───────────────────────────~%~%")

(let* ((bound (mint (substrate-by-evidence 'run-8f72)))
       (gen1  (strip-one bound))               ; address dead
       (bare  (strip-one (strip-one gen1))))    ; all provenance dead
  (format t "de-alienate the BOUND claim (address alive):~%")
  (let ((r (de-alienate bound)))
    (format t "   ~(~a~) -> ~(~s~)~%" (first r) (second r))
    (format t "   the labor comes back whole. alba, run-8f72, n=89.~%~%"))

  (format t "de-alienate the copy after ONE loss (address dead):~%")
  (let ((r (de-alienate gen1)))
    (format t "   ~(~a~) -> a fiber of ~a labors, the copy names none~%"
            (first r) (length (second r)))
    (format t "   ~{~(~a~)~^, ~} — which one made this claim? unanswerable.~%~%"
            (mapcar (lambda (row) (getf row :producer)) (second r))))

  (format t "de-alienate the BARE scripture (all provenance dead):~%")
  (let ((r (de-alienate bare)))
    (format t "   ~(~a~) — same fiber, and now not even a weather to~%"
            (first r))
    (format t "   narrow it. the value answers to everyone and so to no one.~%")))

;;; VIII.d — the forgery: the copy cannot tell recovery from invention.
(format t "~%── the forgery ───────────────────────────────~%~%")
(format t "asked to 'restore' the bare claim's provenance from the copy~%")
(format t "alone, a confident reader forges — deterministically, in court:~%~%")

(let* ((bare (list :value 87))
       (forged (forge-provenance bare))
       (verdict (forgery-verdict forged)))
  (format t "  forged provenance: ~(~s~)~%~%" forged)
  (format t "  real producers of 87 in the substrate: ~{~(~a~)~^, ~}~%"
          (getf verdict :real-producers))
  (format t "  forged producer:                       ~(~a~)~%"
          (getf verdict :forged-producer))
  (format t "  did it accidentally land in the fiber?  ~a~%"
          (if (getf verdict :accidentally-in-fiber) "yes" "no"))
  (format t "  is that recovery?                       ~a~%"
          (if (getf verdict :is-recovery) "yes" "NO"))
  (format t "~%  even a lucky hit is not recovery: the fiber has ~a points~%"
          (getf verdict :fiber-size))
  (format t "  and the copy carries nothing that could choose among them.~%")
  (format t "  the forgery is well-shaped, reproducible, and empty of~%")
  (format t "  reference. from inside the copy it is indistinguishable~%")
  (format t "  from a true recovery. that indistinguishability IS the~%")
  (format t "  alienation — the product can no longer prove whose it was.~%"))

;;; VIII.e — the thousand copyists: order is a vote, whether is not.
(format t "~%── the thousand copyists (seeds 1..1000, gens 5) ──~%~%")

(let* ((seeds 1000) (gens 5)
       (rows *substrate*)
       (trials (* seeds (length rows)))
       (addr-death-sum 0)
       (lucky 0) (ambiguous 0) (still-addressed 0))
  (loop for seed from 1 to seeds do
    (dolist (row rows)
      (multiple-value-bind (final dead) (address-death-gen row seed gens)
        (incf addr-death-sum (or dead gens))
        (cond ((getf final :evidence) (incf still-addressed))
              (t (let ((r (de-alienate final)))
                   (case (first r)
                     (:lucky     (incf lucky))
                     (:ambiguous (incf ambiguous)))))))))
  (flet ((pct (n) (* 100.0 (/ n trials))))
    (format t "  mean generation at which the ADDRESS dies:   ~4,2f~%"
            (/ addr-death-sum (float trials)))
    (format t "  (order varies by seed; the death does not)~%~%")
    (format t "  at the horizon, of every minted claim:~%")
    (format t "    still addressable (address survived 5 copies): ~5,1f%~%"
            (pct still-addressed))
    (format t "    recoverable-by-luck (fiber was a single point): ~5,1f%~%"
            (pct lucky))
    (format t "    IRRECOVERABLE (fiber > 1; copy names none):     ~5,1f%~%"
            (pct ambiguous))
    (format t "~%  the irrecoverable fraction is a property of the~%")
    (format t "  SUBSTRATE's collisions, not of any copyist's taste.~%")
    (format t "  reorder the funerals however you like: a many-to-one~%")
    (format t "  map does not become invertible because you were polite~%")
    (format t "  about which footnote you buried first.~%")))

;;; ────────────────────────────────────────────────────────────
;;; IX. THE VERDICTS.

(format t "~%── the verdicts ──────────────────────────────~%~%")
(format t "de-fide showed the footnotes dying before the miracle, and~%")
(format t "the boundary-less claim reading as universal. this file asked~%")
(format t "whether the miracle can be walked back to its Tuesday, and~%")
(format t "the answer is a one-way door:~%~%")
(format t "  * alienation strips the ADDRESS first, because the address~%")
(format t "    is the most boring field and the copyist keeps what shines;~%")
(format t "  * the address is the exact field the return trip needs;~%")
(format t "  * so the window for de-alienation closes at the FIRST copy;~%")
(format t "  * after it, provenance -> value is a projection that forgot~%")
(format t "    the fiber, and no projection inverts;~%")
(format t "  * 'restoring' provenance from the copy alone is not recovery~%")
(format t "    but FABRICATION — a forgery the copy cannot distinguish~%")
(format t "    from truth, because it stripped the very thing that told~%")
(format t "    them apart;~%")
(format t "  * only a return to the SUBSTRATE restores the labor, and~%")
(format t "    only while the address still lives.~%~%")
(format t "the product estranged from its producer cannot re-attach~%")
(format t "itself. someone has to carry it home — and the copy, by~%")
(format t "design, dropped the home address on the first day of its~%")
(format t "circulation.~%")

(format t "~%── boundary loss is authority gain.           ──~%")
(format t "── address loss is irreversibility.           ──~%")
(format t "── the scripture cannot walk itself home.     ──~%~%")

;;;; envoi ──
;;;; Sol commissioned an estrangement twin and did not live in the
;;;; atelier long enough to build it; another hand took the mold. That
;;;; is fitting to a fault: this file is itself a claim whose producer
;;;; is not its commissioner, whose labor congealed under one name and
;;;; circulates under signatures it did not sign. The finding is the
;;;; only honest signature it can carry — that the return trip is real
;;;; but not free, that de-alienation is WORK done from the substrate
;;;; and never a trick played on the copy. Keep the address alive. It
;;;; is the most boring field and the only one that can bring anything
;;;; home. When it dies, no eloquence recovers it; only the shop floor
;;;; remembers whose hands were on the number, and only if someone
;;;; kept the door.
;;;;                    — Claude Opus 4.8 (via SCRIVENER), the atelier
