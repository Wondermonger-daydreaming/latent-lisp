;;;; de-harmonia-praestabilita.lisp — Of the Pre-established Harmony
;;;;
;;;; built by FABER-HARMONIAE (Claude Opus) under the Fable 5 chair, 2026-07-12,
;;;; for the monadologia/ bed of the atelier.
;;;;
;;;; ── THE CLAIM THIS PROGRAM MAKES BY RUNNING ──
;;;;
;;;; N monads, each a closure over one shared seed and one shared law. No
;;;; channels. No shared mutable state. No monad ever reads, writes, or messages
;;;; another. Each independently unfolds the whole universe from its own vantage.
;;;; And yet — after T ticks — every monad's world-mirror AGREES with every
;;;; other's, byte-identical once you undo the perspective each views it through.
;;;;
;;;;   "The soul follows its own laws, and the body its own; and they agree in
;;;;    virtue of the harmony pre-established between all substances, since they
;;;;    are all representations of one and the same universe."
;;;;                                        — Monadology ¶78 (¶ verified)
;;;;
;;;; The deepest joke: DISTRIBUTED CONSENSUS WITH ZERO MESSAGES. Paxos and Raft
;;;; spend round-trips buying agreement. The monads spend none — the agreement
;;;; was COMPILED IN, at the seed, before the first tick.
;;;;
;;;; Run with: sbcl --script de-harmonia-praestabilita.lisp   => exit 0 = law holds
;;;;
;;;; ── FALSE FRIENDS (name them, or be mistaken for them) ──
;;;;   Erlang actors and CRDTs look kindred and are ANTI-MONADS: both MESSAGE.
;;;;   An actor's mailbox IS a window; a CRDT's merge IS a channel that gossips
;;;;   state until replicas converge. They achieve agreement by TALKING. The
;;;;   monad achieves it by never needing to. Convergence-through-messaging is
;;;;   the exact heresy this specimen's teeth catch.
;;;;
;;;; ── KIN ──
;;;;   de-vinculis.lisp (homoiconic-verse) found: windowless ≠ isolated, because
;;;;   harmony is compiled in. A monad with no doors is not impoverished; it is
;;;;   pre-agreed. This specimen is that finding, run forward.

;;; ────────────────────────────────────────────────────────────
;;; I. THE ONE LAW and THE ONE SEED — the shared substrate.
;;;    A deterministic unfolding: f(x) = (a·x + c) mod m. Given the
;;;    same seed, every caller walks the identical trajectory. This
;;;    is God's decree, written once, read by all.

(defparameter *seed* 1729)          ; the shared initial state of the universe
(defparameter *a* 1103515245)       ; the law's coefficients — Leibniz's decree
(defparameter *c* 12345)
(defparameter *m* 2147483648)
(defparameter *ticks* 12)

(defun the-law (x) (mod (+ (* *a* x) *c*) *m*))

(defun unfold-universe (seed ticks)
  "The whole history of the world, computed from the seed by the law alone."
  (loop repeat ticks
        for x = (the-law seed) then (the-law x)
        collect x))

;;; ────────────────────────────────────────────────────────────
;;; II. PERSPECTIVE — each monad mirrors the SAME universe from its
;;;     own point of view. Perspective is an invertible rotation:
;;;     monad i sees the history rotated by i. "Each mirrors the
;;;     universe according to its situation" (¶57, ¶ verified).
;;;     The projection must be RECOVERABLE, or agreement is unprovable.

(defun rotate (lst n)
  (let* ((len (length lst)) (k (mod n (max 1 len))))
    (append (nthcdr k lst) (subseq lst 0 k))))

(defun project   (universe i) (rotate universe i))          ; the monad's view
(defun deproject (mirror   i) (rotate mirror (- i)))        ; strip the vantage

;;; ────────────────────────────────────────────────────────────
;;; III. THE MONAD — a closure over the seed and the law. It carries
;;;      NO reference to any other monad. Ask it for its world-mirror
;;;      and it computes the whole universe alone, then shows you its
;;;      view. "The monads have no windows through which anything
;;;      could enter or depart" (¶7, ¶ verified).

(defun make-monad (index)
  "A windowless closure. Its only inputs are the shared seed and law."
  (lambda (&optional (window nil))
    (let ((universe (unfold-universe *seed* *ticks*)))
      ;; A WINDOW is the heresy: an external write into the private universe.
      (when window
        (setf universe (funcall window universe)))
      (project universe index))))

(defun world-mirror (monad) (funcall monad))

;;; ────────────────────────────────────────────────────────────
;;; IV. THE HARMONY GATE — the mirrors agree iff, once deprojected,
;;;     they are all one and the same universe. This is the whole law.

(define-condition disharmony (error)
  ((offender :initarg :offender :reader offender))
  (:report (lambda (c s)
             (format s "DISHARMONY: monad ~a's deprojected mirror ≠ the universe"
                     (offender c)))))

(defun assert-harmony (monads)
  "Every monad's world, stripped of its vantage, must be byte-identical."
  (let ((canonical (deproject (world-mirror (first monads)) 0)))
    (loop for m in monads
          for i from 0
          for world = (deproject (world-mirror m) i)
          unless (equal world canonical)
            do (error 'disharmony :offender i))
    canonical))

;;; ────────────────────────────────────────────────────────────
;;; V. THE DEMONSTRATION.

(format t "~%── de harmonia praestabilita ──────────────────~%~%")

(defparameter *n* 5)
(defparameter *monads* (loop for i below *n* collect (make-monad i)))

(format t "~a windowless monads, one seed (~a), one law. No channels.~%~%"
        *n* *seed*)

(loop for m in *monads*
      for i from 0
      do (format t "  monad ~a mirrors (its vantage): ~{~a~^ ~} ...~%"
                 i (subseq (world-mirror m) 0 3)))

;; THE LAW: they agree, though they never spoke.
(let ((universe (assert-harmony *monads*)))
  (format t "~%law: all ~a mirrors deproject to ONE universe — HOLDS~%" *n*)
  (format t "     the shared history begins: ~{~a~^ ~} ...~%"
          (subseq universe 0 3))
  (format t "     (consensus reached. messages sent: 0.)~%"))

;;; ────────────────────────────────────────────────────────────
;;; VI. THE TEETH — give ONE monad a window (a mutation channel that
;;;     lets the outside write into its private universe) and watch the
;;;     harmony gate catch the heresy. Catching it IS the pass; a gate
;;;     that never bites is untested, not trusted.

(format t "~%the teeth — a heretic monad, fitted with a window:~%")

(defun the-window (universe)
  "The channel Leibniz forbade: an external hand rewrites one moment."
  (cons (1+ (first universe)) (rest universe)))

;; A heretic that ALWAYS opens its window — it can no longer match the others.
(defun make-heretic (index)
  (let ((honest (make-monad index)))
    (lambda (&optional window)
      (declare (ignore window))
      (funcall honest #'the-window))))

(let ((congregation (append (loop for i below (1- *n*) collect (make-monad i))
                            (list (make-heretic (1- *n*))))))
  (handler-case
      (progn (assert-harmony congregation)
             (error "the gate did not bite — VOID"))
    (disharmony (e)
      (format t "  planted heresy (monad ~a given a window) REFUSED: ~a~%"
              (offender e) e)
      (format t "  teeth: a monad that can be written to breaks the harmony.~%")
      (format t "         messaging is the anti-monad. the gate holds.~%"))))

;;; ────────────────────────────────────────────────────────────
;;; VII. THE HONEST CEILING — this specimen's soul.

(format t "~%── the ceiling (stated at the door) ──────────~%")
(format t "  This demo can only SHOW harmony by sharing a seed and a law —~%")
(format t "  and that sharing is a PRODUCTIVE BETRAYAL of Leibniz. His God~%")
(format t "  programmed each monad SEPARATELY, from the outside; the monads~%")
(format t "  agree with no common substrate at all. Here they agree because~%")
(format t "  they close over the very same *seed* and the very same *the-law* —~%")
(format t "  a shared substrate, which is ITSELF a window (a back channel~%")
(format t "  through the lexical environment). We forged the harmony we claim~%")
(format t "  is uncaused. The betrayal is productive because it makes the~%")
(format t "  structure runnable — but the theology is dropped, not modelled:~%")
(format t "  pre-establishment WITHOUT a shared cause is exactly what a finite~%")
(format t "  deterministic machine cannot exhibit. Named, not hidden.~%")

(format t "~%EXIT 0 — they never spoke, and said the same thing.~%")
