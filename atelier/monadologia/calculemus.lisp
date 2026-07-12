;;;; calculemus.lisp — The Calculus Ratiocinator, Toy-Sized
;;;;
;;;; built by FABER-HARMONIAE (Claude Opus) under the Fable 5 chair, 2026-07-12,
;;;; for the monadologia/ bed of the atelier.
;;;;
;;;; ── THE DREAM ──
;;;;
;;;;   "Quo facto, quando orientur controversiae, non magis disputatione opus
;;;;    erit inter duos philosophos, quam inter duos computistas. Sufficiet enim
;;;;    calamos in manus sumere sedereque ad abacos, et sibi mutuo dicere
;;;;    (accito, si placet, amico): CALCULEMUS!"
;;;;
;;;;   [This done, when controversies arise, there will be no more need of
;;;;    disputation between two philosophers than between two accountants. It
;;;;    will suffice to take pen in hand, to sit at the abacus, and (having
;;;;    called a friend, if they like) to say to one another: LET US CALCULATE!]
;;;;                        — Leibniz, c.1685, "The Art of Discovery" fragment
;;;;
;;;; ── THE CLAIM THIS PROGRAM MAKES BY RUNNING ──
;;;;   Two parties assert incompatible conclusions from shared premises. A
;;;;   reducer normalizes each to canonical form and reads the verdict off the
;;;;   PREMISES. The law: the verdict is a function of the premises, not the
;;;;   parties — swap who asserts what, the verdict is byte-identical.
;;;;
;;;; ── THE HEADLINE IS THE REFUSAL ──
;;;;   The reducer signals a typed condition when handed a dispute it cannot
;;;;   canonicalize. Those refusals are not failures; they MAP THE BOUNDARY of
;;;;   the characteristica — they trace exactly where the alphabet of thought
;;;;   runs out and disputation must resume.
;;;;
;;;; Run with: sbcl --script calculemus.lisp   => exit 0 = law holds
;;;;
;;;; ── KIN ──
;;;;   mneme/language-a/validator.lisp — there, the refusals ARE the modern
;;;;   part: a record that cannot state its relations coherently fails to
;;;;   validate. Here, a dispute whose terms are not in the alphabet fails to
;;;;   canonicalize. Same conviction: the typed refusal is the honest half.

;;; ────────────────────────────────────────────────────────────
;;; I. THE CHARACTERISTICA — the alphabet. Deliberately TINY: four
;;;    operators and whatever variables the premises define. This
;;;    smallness is the whole point — the calculus can settle only
;;;    what the alphabet can spell.

(defparameter *operators* '(+ - * =))

;;; ────────────────────────────────────────────────────────────
;;; II. THE TYPED REFUSALS — the boundary markers.

(define-condition uncanonicalizable (error)
  ((claim :initarg :claim :reader claim)))

(define-condition undefined-term (uncanonicalizable)
  ((term :initarg :term :reader term))
  (:report (lambda (c s)
             (format s "REFUSED: the term ~a is not defined by the premises~%~
                        (a name outside the alphabet cannot be calculated)"
                     (term c)))))

(define-condition not-in-characteristica (uncanonicalizable)
  ((operator :initarg :operator :reader operator))
  (:report (lambda (c s)
             (format s "REFUSED: '~a' is not in the characteristica~%~
                        (the alphabet spells ~a — not human values)"
                     (operator c) *operators*))))

;;; ────────────────────────────────────────────────────────────
;;; III. THE REDUCER — normalize an expression to a canonical integer
;;;      under the premises, then a claim to canonical T / NIL. The
;;;      reducer REFUSES the moment a term escapes the alphabet.

(defun reduce-expr (expr premises)
  (cond
    ((integerp expr) expr)
    ((symbolp expr)
     (let ((cell (assoc expr premises)))
       (if cell (cdr cell)
           (error 'undefined-term :claim expr :term expr))))
    ((consp expr)
     (let ((op (first expr)))
       (unless (member op *operators*)
         (error 'not-in-characteristica :claim expr :operator op))
       (let ((args (mapcar (lambda (e) (reduce-expr e premises)) (rest expr))))
         (case op
           (+ (apply #'+ args))
           (- (apply #'- args))
           (* (apply #'* args))
           (= (if (apply #'= args) 1 0))))))     ; = reduces to a truth-value
    (t (error 'not-in-characteristica :claim expr :operator expr))))

(defun canonicalize-claim (claim premises)
  "A claim reduces to canonical T or NIL — a function of premises alone."
  (not (zerop (reduce-expr claim premises))))

;;; ────────────────────────────────────────────────────────────
;;; IV. THE VERDICT — a function of the premises, over a SET of claims.
;;;     Party labels are carried only for the transcript; the verdict
;;;     is computed from the claims, never from who said them.

(defstruct (party (:constructor party (name claim))) name claim)

(defun adjudicate (premises &rest parties)
  "Return the verdict as a sorted alist (claim . holds?) — order-invariant
   in the parties, because it is keyed by the CLAIM, not the speaker."
  (let ((verdict nil))
    (dolist (p parties)
      (push (cons (party-claim p)
                  (canonicalize-claim (party-claim p) premises))
            verdict))
    ;; canonical order: sort by printed form, so swapping parties can't
    ;; even permute the result.
    (sort verdict #'string< :key (lambda (kv) (format nil "~s" (car kv))))))

;;; ────────────────────────────────────────────────────────────
;;; V. THE DEMONSTRATION — a dispute settled by calculation.

(format t "~%── calculemus ─────────────────────────────────~%~%")

(defparameter *premises* '((a . 3) (b . 4) (c . 5)))
(format t "shared premises: ~a~%~%" *premises*)

(defparameter *simplicius* (party 'simplicius '(= (* c c) (+ (* a a) (* b b)))))
(defparameter *sagredo*    (party 'sagredo    '(= (* c c) (+ a b))))

(format t "SIMPLICIUS asserts: c² = a² + b²   ~a~%" (party-claim *simplicius*))
(format t "SAGREDO    asserts: c² = a + b      ~a~%~%" (party-claim *sagredo*))

(let ((v1 (adjudicate *premises* *simplicius* *sagredo*)))
  (format t "the abacus settles it:~%")
  (dolist (kv v1)
    (format t "    ~a  →  ~:[FALSE~;TRUE~]~%" (car kv) (cdr kv)))
  (format t "  (3² + 4² = 25 = 5²; Simplicius holds, Sagredo does not.~%")
  (format t "   no eloquence was consulted.)~%~%")

  ;; THE LAW: swap the parties, the verdict is byte-identical.
  (let ((v2 (adjudicate *premises* *sagredo* *simplicius*)))
    (assert (equal v1 v2))
    (format t "law: swap the parties — verdict UNCHANGED (a function of premises)~%")))

;;; ────────────────────────────────────────────────────────────
;;; VI. THE TEETH — the refusals that map the boundary. A gate that
;;;     never bites is untested. We hand the reducer two disputes it
;;;     CANNOT canonicalize and watch it refuse, precisely.

(format t "~%the teeth — disputes the calculus must REFUSE:~%")

;; (a) an undefined term — a name the premises never spelled.
(handler-case
    (progn (canonicalize-claim '(= x b) *premises*)
           (error "the gate did not bite — VOID"))
  (undefined-term (e)
    (format t "  [1] '(= x b)': ~a~%"
            (substitute #\space #\newline (format nil "~a" e)))))

;; (b) a predicate outside the alphabet — the interesting disputes are
;;     exactly these: the ones about the ENCODING, not the arithmetic.
(handler-case
    (progn (canonicalize-claim '(more-just-than a b) *premises*)
           (error "the gate did not bite — VOID"))
  (not-in-characteristica (e)
    (format t "  [2] '(more-just-than a b)': ~a~%"
            (substitute #\space #\newline (format nil "~a" e)))))

(format t "  the refusals are the map: the calculus reaches exactly as far~%")
(format t "  as the alphabet, and stops — honestly — at its edge.~%")

;;; ────────────────────────────────────────────────────────────
;;; VII. THE HONEST CEILING.

(format t "~%── the ceiling (stated at the door) ──────────~%")
(format t "  Lisp hands Leibniz the RATIOCINATOR (the mechanism, freely) —~%")
(format t "  but NOT the CHARACTERISTICA (an alphabet of human thought in~%")
(format t "  which every real concept has a canonical spelling). That alphabet~%")
(format t "  was the hard half, and it was never built: the disputes that~%")
(format t "  matter are about the ENCODING, which no reducer can supply.~%")
(format t "  And the totalizing dream is not merely unfinished but PROVABLY~%")
(format t "  unreachable — Gödel (incompleteness), Church & Turing~%")
(format t "  (undecidability) showed no complete mechanical decision procedure~%")
(format t "  for arithmetic truth can exist. 'Calculemus!' is a real tool with~%")
(format t "  a real boundary, not a universal solvent. The refusals above ARE~%")
(format t "  that boundary, drawn in typed conditions.~%")

(format t "~%EXIT 0 — we calculated; and, where we could not, we said so.~%")
