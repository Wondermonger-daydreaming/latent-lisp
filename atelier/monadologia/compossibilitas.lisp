;;;; compossibilitas.lisp — Of Compossibility, as Nondeterministic Search
;;;;
;;;; built by MUNDIFEX (Claude Opus) under the Fable 5 chair, 2026-07-12,
;;;; for the monadologia/ bed of the atelier.
;;;;
;;;; ── THE CLAIM THIS PROGRAM MAKES BY RUNNING ──
;;;;
;;;; Not every possible can coexist with every other. Sextus-going-to-Rome and
;;;; Sextus-staying-in-Corinth are each possible; no world holds both. A WORLD,
;;;; for Leibniz, is a MAXIMAL set of mutually COMPOSSIBLE individuals — the
;;;; largest bundle whose members do not contradict one another. God's choice is
;;;; among such whole worlds, never among individual goods picked à la carte
;;;; (Theodicy §414-417, the Palace of Destinies — Pallas shows Theodorus the
;;;; pyramid of possible worlds, a different complete Sextus in each; letters to
;;;; Bourguet & Arnauld: "not all possibles are compossible"; Monadology §53-55
;;;; — infinite possible worlds, God actualizes one by sufficient reason).
;;;;
;;;; This specimen makes that a SEARCH. Candidate facts, a DECLARED
;;;; incompatibility relation, and McCarthy's `amb` (nondeterministic choice +
;;;; backtracking) walking the space of in/out assignments to find every
;;;; maximal compossible world. The backtracks are COUNTED — the refusal of the
;;;; incompossible is not asserted, it is EXHIBITED, one dead branch at a time.
;;;;
;;;;   * PLURALITY, executable — the SAME possibles yield SEVERAL distinct
;;;;     maximal worlds (the pyramid has more than one floor).
;;;;   * MAXIMALITY, executable — adding one more possible to a finished world
;;;;     triggers backtracking: a world is maximal precisely because it cannot
;;;;     grow without contradiction.
;;;;   * Teeth: a smuggled incompossible PAIR is run at the gate and REFUSED,
;;;;     the contradiction named. A gate that never bites is untested.
;;;;
;;;; Run with: ~/.local/bin/sbcl --script compossibilitas.lisp   => exit 0 = law holds
;;;;
;;;; ── KIN ──
;;;;   metacircular-porch/amb.lisp — the porch's nondeterministic evaluator, from
;;;;   which this specimen's amb core is LIFTED (see §I, attributed there). The
;;;;   porch dreams all branches of a program; here the branches are worlds, and
;;;;   the `require` that prunes is the compossibility gate. `/loom` as cosmology.
;;;;
;;;;   theodicaea.lisp (next bench over) names a "compossibility first" gate — a
;;;;   world whose predicates contradict never enters the best-world tournament.
;;;;   THIS specimen is that gate given its own workshop: the door theodicaea
;;;;   guards, here built and watched swinging.

;;; ────────────────────────────────────────────────────────────
;;; I. THE amb CORE — lifted from metacircular-porch/amb.lisp.
;;;
;;;    The porch implements McCarthy's `amb` in continuation-passing style:
;;;    every step carries a SUCCEED continuation (what to do with a value) and a
;;;    FAIL continuation (what to try when a later `require` rejects this branch).
;;;    Its `amb-eval-amb` tries each choice in order and, on backtrack, advances
;;;    to the next — incrementing a counter so the search is exhibited, not
;;;    claimed. Below is that machinery distilled from the porch's DSL-evaluator
;;;    into native Common Lisp: same architecture (succeed/fail CPS, counted
;;;    backtracks), no interpreter in between. This is a faithful LIFT of the
;;;    porch's core, not a silent fork — the porch is the source.

(defvar *backtracks* 0)

(defun amb-choose (choices succeed fail)
  "Nondeterministic choice. Calls (succeed choice fail') for the first choice;
   on backtrack, fail' advances to the next choice. Distilled from the porch's
   amb-eval-amb (metacircular-porch/amb.lisp)."
  (if (null choices)
      (funcall fail)                         ; (amb) with no options => dead end
      (funcall succeed (car choices)
               (lambda ()
                 (incf *backtracks*)
                 (amb-choose (cdr choices) succeed fail)))))

(defun amb-require (test succeed fail)
  "The porch's `require`: if TEST holds, continue; else backtrack."
  (if test (funcall succeed nil fail) (funcall fail)))

;;; ────────────────────────────────────────────────────────────
;;; II. THE UNIVERSE OF POSSIBLES — candidate facts, and the DECLARED
;;;     incompatibility relation. Each fact is a possible predicate/individual.
;;;     The Palace of Destinies: three roads for Sextus, each dragging its own
;;;     causal train, the roads mutually exclusive, some trains crossing.

(defparameter *possibles*
  '(:sextus-to-rome        ; he goes to Rome, and the crime follows
    :sextus-to-corinth     ; he stays in Corinth, buys a garden, lives content
    :sextus-to-thrace      ; he goes to Thrace and is made king
    :lucretia-wronged      ; the wrong that topples the kings
    :republic-founded      ; Rome becomes a republic
    :monarchy-endures      ; the Tarquin line keeps its throne
    :sextus-in-a-garden    ; the quiet private life ("he buys a little garden")
    :sextus-crowned))      ; a crown in Thrace

(defparameter *glosses*
  '(:sextus-to-rome      "Sextus goes to Rome"
    :sextus-to-corinth   "Sextus stays in Corinth"
    :sextus-to-thrace    "Sextus goes to Thrace"
    :lucretia-wronged    "Lucretia is wronged"
    :republic-founded    "the Republic is founded"
    :monarchy-endures    "the monarchy endures"
    :sextus-in-a-garden  "Sextus keeps a garden"
    :sextus-crowned      "Sextus is crowned king"))

(defun gloss (fact) (or (getf *glosses* fact) (string-downcase (symbol-name fact))))

;;; The incompatibility relation — an UNORDERED set of forbidden pairs. This is
;;; DECLARED, not derived (the honest ceiling, stated below). It encodes: one
;;; road per world; contradictory world-states; and the causal trains Leibniz
;;; read into the Sextus myth (the Rome-crime ENDS the monarchy and founds the
;;; Republic; the Corinth Sextus never wrongs Lucretia; a gardener wears no crown).

(defparameter *incompatible*
  '((:sextus-to-rome    :sextus-to-corinth)   ; the roads are exclusive:
    (:sextus-to-rome    :sextus-to-thrace)    ;   one complete individual,
    (:sextus-to-corinth :sextus-to-thrace)    ;   one road per world
    (:republic-founded  :monarchy-endures)    ; contradictory world-states
    (:sextus-to-rome    :monarchy-endures)    ; the crime ends the monarchy
    (:sextus-to-corinth :lucretia-wronged)    ; the quiet Sextus wrongs no one
    (:sextus-to-corinth :republic-founded)    ; no crime in Corinth, no republic
    (:sextus-to-corinth :sextus-crowned)      ; a private man, uncrowned
    (:sextus-to-thrace  :lucretia-wronged)    ; the Thrace road bypasses the crime
    (:sextus-to-thrace  :sextus-in-a-garden)  ; a king keeps no humble garden
    (:sextus-in-a-garden :sextus-crowned)))   ; gardener xor king

(defun incompatible-p (a b)
  "True iff {a,b} is a declared incompatible pair (either order)."
  (or (member (list a b) *incompatible* :test #'equal)
      (member (list b a) *incompatible* :test #'equal)))

;;; ────────────────────────────────────────────────────────────
;;; III. THE COMPOSSIBILITY GATE — no two members of a world may be a declared
;;;      incompatible pair. `first-conflict` names the offending pair (the gate
;;;      must be able to say WHY it refused, or its refusal is mute).

(defun first-conflict (world)
  "Return (values a b) for the first incompatible pair in WORLD, or NIL."
  (loop for (p . rest) on world
        do (loop for q in rest
                 when (incompatible-p p q)
                   do (return-from first-conflict (values p q))))
  nil)

(defun compossible-p (world)
  (null (first-conflict world)))

(define-condition incompossibility (error)
  ((left :initarg :left :reader inc-left)
   (right :initarg :right :reader inc-right))
  (:report (lambda (c s)
             (format s "INCOMPOSSIBLE: '~a' and '~a' cannot share a world (declared contradictory)"
                     (gloss (inc-left c)) (gloss (inc-right c))))))

(defun gate-or-signal (world)
  "The gate as a typed refusal: pass WORLD through, or signal incompossibility
   naming the contradictory pair. Used by the teeth."
  (multiple-value-bind (a b) (first-conflict world)
    (when a (error 'incompossibility :left a :right b))
    world))

;;; ────────────────────────────────────────────────────────────
;;; IV. MAXIMALITY — a WORLD is not merely a compossible set; it is a set that
;;;     cannot GROW. If any excluded possible could be added while staying
;;;     compossible, the set was a fragment, not a world.

(defun maximal-p (world)
  (and (compossible-p world)
       (loop for x in *possibles*
             never (and (not (member x world))
                        (compossible-p (cons x world))))))

;;; ────────────────────────────────────────────────────────────
;;; V. THE SEARCH — amb walks the in/out assignment for each possible,
;;;    pruning incompossible partials early (the `require`), and keeps only the
;;;    MAXIMAL survivors. God surveying the pyramid, done by backtracking.

(defun search-worlds (candidates chosen succeed fail)
  "For each candidate: amb-choose IN or OUT. Prune the moment CHOSEN stops
   being compossible (dead branch). At the leaf, keep only maximal worlds."
  (if (null candidates)
      (let ((world (reverse chosen)))
        (amb-require (maximal-p world)
                     (lambda (v f) (declare (ignore v)) (funcall succeed world f))
                     fail))
      (amb-choose
       '(:in :out)
       (lambda (decision fail2)
         (let ((chosen* (if (eq decision :in) (cons (car candidates) chosen) chosen)))
           ;; prune early: an incompossible partial can never become a world
           (amb-require (compossible-p chosen*)
                        (lambda (v f) (declare (ignore v))
                          (search-worlds (cdr candidates) chosen* succeed f))
                        fail2)))
       fail)))

(defun find-all-worlds ()
  "Force every solution — the porch's collect-all pattern (call fail after each
   success to demand the next). Returns (values worlds backtracks)."
  (setf *backtracks* 0)
  (let ((worlds '()))
    (block done
      (search-worlds *possibles* '()
                     (lambda (world fail) (push world worlds) (funcall fail))
                     (lambda () (return-from done))))
    (values (nreverse worlds) *backtracks*)))

;;; ────────────────────────────────────────────────────────────
;;; VI. THE DEMONSTRATION.

(defun name-world (w) (mapcar #'gloss w))

(format t "~%── de compossibilitate ───────────────────────~%~%")
(format t "~d possibles, ~d declared incompatible pairs. The roads of Sextus~%"
        (length *possibles*) (length *incompatible*))
(format t "and their causal trains. amb searches for every MAXIMAL world.~%~%")

(multiple-value-bind (worlds backs) (find-all-worlds)
  (format t "PLURALITY — the same possibles yield ~d distinct maximal worlds:~%~%"
          (length worlds))
  (loop for w in worlds
        for i from 1
        do (format t "  world ~d (~d facts): ~{~a~^; ~}~%" i (length w) (name-world w)))
  (format t "~%  branches backtracked through : ~:d~%" backs)
  (format t "  (each dead branch = a partial world the gate refused to grow)~%~%")

  ;; The pyramid has more than one floor: assert genuine plurality + distinctness.
  (assert (>= (length worlds) 2))
  (assert (= (length worlds) (length (remove-duplicates worlds :test #'equal))))
  (format t "  => PLURALITY holds: God chooses AMONG whole worlds, not goods.~%~%")

  ;; MAXIMALITY, watched: take world 1, prove no excluded possible can be added.
  (let* ((w (first worlds))
         (outsiders (remove-if (lambda (x) (member x w)) *possibles*)))
    (format t "MAXIMALITY — world 1 cannot grow. Each excluded possible, tried:~%")
    (dolist (x outsiders)
      (multiple-value-bind (a b) (first-conflict (cons x w))
        (assert a)   ; every outsider MUST conflict, or the world was not maximal
        (format t "    + '~a'  =>  REFUSED: clashes with '~a'~%"
                (gloss x) (gloss (if (eq a x) b a)))))
    (format t "  teeth: adding ANY outsider backtracks. Maximal = cannot grow.~%~%")))

;;; ────────────────────────────────────────────────────────────
;;; VII. THE TEETH — a smuggled incompossible pair. Someone hands the gate a
;;;      "world" containing both roads of Sextus. The gate must BITE and name
;;;      the contradiction. Catching it IS the pass; an unbitten gate is untested.

(format t "the teeth — an incompossible pair smuggled into a candidate world:~%")

(let ((smuggled (list :sextus-to-rome :lucretia-wronged :sextus-to-corinth)))
  (format t "  smuggled: ~{~a~^; ~}~%" (name-world smuggled))
  (handler-case
      (progn (gate-or-signal smuggled)
             (error "the gate did not bite — VOID"))
    (incompossibility (e)
      (format t "  gate REFUSED: ~a~%" e)
      (format t "  teeth: no world holds both roads of one Sextus. The door held.~%~%"))))

;; And a second bite, cross-individual, to show the gate is not a one-trick pony:
(let ((smuggled (list :sextus-to-rome :monarchy-endures)))
  (handler-case
      (progn (gate-or-signal smuggled)
             (error "the gate did not bite — VOID"))
    (incompossibility (e)
      (format t "  cross-train check — ~a~%" e)
      (format t "  teeth: the Rome-crime ends the monarchy; the pair is barred.~%~%"))))

;;; ────────────────────────────────────────────────────────────
;;; VIII. THE HONEST CEILING — stated at the door, per the bed's law.

(format t "── the ceiling (stated at the door) ──────────~%")
(format t "  Source played: Theodicy §414-417 (the Palace of Destinies / Sextus);~%")
(format t "  the letters' maxim 'not all possibles are compossible'; Monadology~%")
(format t "  §53-55. Reconstruction, NOT exegesis — the model absorbed this from~%")
(format t "  the textual tradition; it does not 'understand Leibniz.'~%")
(format t "~%")
(format t "  What this specimen DECLARES rather than DERIVES — its load-bearing~%")
(format t "  simplification: the incompatibility relation is a HAND-WRITTEN table.~%")
(format t "  In Leibniz, whether two possibles are compossible is CONTESTED — the~%")
(format t "  'logical' reading (compossibility = mere non-contradiction of concepts)~%")
(format t "  versus the 'lawful' reading (co-integrability under one world's laws,~%")
(format t "  something richer than consistency). This program takes neither side: it~%")
(format t "  hard-codes the verdicts as data, so the SEARCH is real but the RELATION~%")
(format t "  is stipulated. Derive the incompatibilities from concepts or from laws~%")
(format t "  and you would be doing the actual metaphysics — which no finite table~%")
(format t "  settles. Named, not hidden.~%")
(format t "~%")
(format t "EXIT 0 — the same possibles, several worlds; the incompossible refused~%")
(format t "         at the door. Compossibility first — a world whose predicates~%")
(format t "         contradict never enters theodicaea's tournament. Calculemus.~%")
