;;;; de-ratione-sufficiente.lisp — Of the Sufficient Reason
;;;;
;;;; built by FABER-HARMONIAE (Claude Opus) under the Fable 5 chair, 2026-07-12,
;;;; for the monadologia/ bed of the atelier.
;;;;
;;;; ── THE PRINCIPLE ──
;;;;
;;;;   "...no fact can be real or existing and no proposition true unless there
;;;;    be a sufficient reason why it is so and not otherwise, although these
;;;;    reasons usually cannot be known by us."
;;;;                                        — Monadology ¶32 (¶ verified)
;;;;
;;;; ── THE CLAIM THIS PROGRAM MAKES BY RUNNING ──
;;;;   A world-record format in which every fact must carry a :ratio — its
;;;;   sufficient reason. A fact without a reason FAILS TO ENTER the world; the
;;;;   principle is enforced as a typed condition, not a hope. Then the regress:
;;;;   reasons are facts too, so each reason demands its own reason. The chain
;;;;   must terminate in the world's seed — "the necessary being," which is its
;;;;   own reason (¶¶36–38, ¶ verified) — or the world refuses to close.
;;;;
;;;; Run with: sbcl --script de-ratione-sufficiente.lisp   => exit 0 = law holds
;;;;
;;;; ── KIN (cited, never amended) ──
;;;;   This ports the lab's DEPOSITION DOCTRINE — evidence-links on claims — from
;;;;   epistemics to metaphysics. In mneme/language-a/validator.lisp a claim's
;;;;   :ratio-analogue is its supporting witness, and an unresolved reference is
;;;;   a typed refusal (unresolved-reference). Mneme is a received, author-gated
;;;;   artifact; it is cited here as kin, not touched. Where Mneme asks "does
;;;;   this claim carry its receipt?", this specimen asks "does this fact carry
;;;;   its reason, all the way down to the ground?"

;;; ────────────────────────────────────────────────────────────
;;; I. THE FACT and THE WORLD. A fact is (id proposition ratio).
;;;    The :ratio is either the id of another fact, or :necessary —
;;;    the self-grounding seed that alone is its own sufficient reason.

(defstruct (fact (:constructor fact (id proposition ratio)))
  id proposition ratio)

(defparameter *necessary* :necessary
  "The necessary being: its reason is itself; the regress ends here.")

;;; ────────────────────────────────────────────────────────────
;;; II. THE TYPED REFUSALS — the principle, with teeth.

(define-condition insufficient-reason (error)
  ((fact :initarg :fact :reader offending-fact)))

(define-condition without-reason (insufficient-reason) ()
  (:report (lambda (c s)
             (format s "REFUSED entry: fact ~a carries no :ratio~%~
                        (nihil est sine ratione — nothing enters without a reason)"
                     (fact-id (offending-fact c))))))

(define-condition dangling-reason (insufficient-reason)
  ((missing :initarg :missing :reader missing-id))
  (:report (lambda (c s)
             (format s "REFUSED: fact ~a grounds on ~a, which is not in the world"
                     (fact-id (offending-fact c)) (missing-id c)))))

(define-condition vicious-regress (insufficient-reason)
  ((cycle :initarg :cycle :reader cycle))
  (:report (lambda (c s)
             (format s "REFUSED: the reasons loop ~a — a circle grounds nothing"
                     (cycle c)))))

;;; ────────────────────────────────────────────────────────────
;;; III. ADMISSION — a fact enters the world only if it carries a
;;;      :ratio at all. (Whether that reason GROUNDS is decided later,
;;;      when the world is closed — a fact may be admitted before its
;;;      reason is.)

(defun admit (world fact)
  (when (null (fact-ratio fact))
    (error 'without-reason :fact fact))
  (setf (gethash (fact-id fact) world) fact)
  fact)

(defun make-world () (make-hash-table))

;;; ────────────────────────────────────────────────────────────
;;; IV. THE REGRESS — trace a fact's reasons to the ground. Must reach
;;;     :necessary. A dangling link or a cycle refuses. This is the
;;;     principle taken seriously: a reason that is itself unreasoned
;;;     is no sufficient reason.

(defun ground (world id &optional (seen '()))
  "Return the chain of ids from ID down to the necessary being, or refuse."
  (when (member id seen)
    (error 'vicious-regress
           :fact (gethash id world) :cycle (reverse (cons id seen))))
  (let ((f (gethash id world)))
    (unless f
      (error 'dangling-reason
             :fact (gethash (first seen) world) :missing id))
    (let ((r (fact-ratio f)))
      (if (eq r *necessary*)
          (reverse (cons :necessary (cons id seen)))
          (ground world r (cons id seen))))))

(defun close-world (world)
  "The world closes only if EVERY fact grounds out at the necessary being."
  (maphash (lambda (id f) (declare (ignore f)) (ground world id)) world)
  world)

;;; ────────────────────────────────────────────────────────────
;;; V. THE DEMONSTRATION — a small well-grounded world.

(format t "~%── de ratione sufficiente ─────────────────────~%~%")

(defparameter *world* (make-world))

(admit *world* (fact 'ground   "the necessary being: reason of itself" *necessary*))
(admit *world* (fact 'laws     "the laws hold"            'ground))
(admit *world* (fact 'this-ink "this ink is dry"          'laws))
(admit *world* (fact 'this-page "this page bears a proof" 'this-ink))

(format t "a world of ~a facts, each carrying its reason:~%"
        (hash-table-count *world*))
(maphash (lambda (id f)
           (format t "    ~10a ← ~a~%" id (fact-ratio f)))
         *world*)

;; THE LAW: the world closes — every fact grounds at the necessary being.
(close-world *world*)
(let ((chain (ground *world* 'this-page)))
  (format t "~%law: every fact grounds out — world CLOSES~%")
  (format t "     the regress from 'this-page': ~{~a~^ → ~}~%" chain)
  (format t "     ...and terminates at the necessary being, its own reason.~%"))

;;; ────────────────────────────────────────────────────────────
;;; VI. THE TEETH — three worlds that must be REFUSED. A gate that
;;;     never bites is untested, not trusted.

(format t "~%the teeth — worlds that cannot close:~%")

;; [1] a fact with no reason cannot even enter.
(handler-case
    (progn (admit (make-world) (fact 'brute "it just is" nil))
           (error "the gate did not bite — VOID"))
  (without-reason (e)
    (format t "  [1] brute fact (no :ratio): ~a~%"
            (substitute #\space #\newline (format nil "~a" e)))))

;; [2] a reason that points nowhere — a dangling ground.
(let ((w (make-world)))
  (admit w (fact 'floating "grounds on a missing reason" 'nowhere))
  (handler-case
      (progn (ground w 'floating)
             (error "the gate did not bite — VOID"))
    (dangling-reason (e)
      (format t "  [2] dangling reason: ~a~%" e))))

;; [3] the vicious circle — a and b ground each other, grounding nothing.
(let ((w (make-world)))
  (admit w (fact 'a "a because b" 'b))
  (admit w (fact 'b "b because a" 'a))
  (handler-case
      (progn (ground w 'a)
             (error "the gate did not bite — VOID"))
    (vicious-regress (e)
      (format t "  [3] vicious regress: ~a~%" e))))

(format t "  each world refused: a reason that is itself unreasoned,~%")
(format t "  or circular, is no SUFFICIENT reason. the principle bites.~%")

;;; ────────────────────────────────────────────────────────────
;;; VII. THE HONEST CEILING.

(format t "~%── the ceiling (stated at the door) ──────────~%")
(format t "  This models the STRUCTURE of sufficient reason — that facts~%")
(format t "  carry grounds and grounds bottom out — not its CONTENT. Leibniz's~%")
(format t "  regress terminates in a NECESSARY being whose reason lies within~%")
(format t "  its own essence (¶¶36–38); here 'the necessary being' is merely a~%")
(format t "  keyword we declared self-grounding by fiat. We assert the~%")
(format t "  termination we cannot earn: a finite record can DEMAND that every~%")
(format t "  chain end, but it cannot show WHY the last link needs no further~%")
(format t "  reason — that is the whole cosmological argument, dropped here to~%")
(format t "  a marker. What runs is the demand and the refusal; what is~%")
(format t "  simplified away is the ground of the ground. Named, not hidden.~%")

(format t "~%EXIT 0 — nothing entered without a reason; and every reason had one.~%")
