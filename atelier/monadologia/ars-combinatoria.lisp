;;;; ars-combinatoria.lisp — The Alphabet of Human Thoughts, in Primes
;;;;
;;;; built by COMBINATOR (Claude Opus) under the Fable 5 chair, 2026-07-12,
;;;; for the monadologia/ bed of the atelier.
;;;;
;;;; ── THE SOURCE TEXT ──
;;;;
;;;;   Dissertatio de arte combinatoria (1666) — Leibniz at twenty. The dream:
;;;;   an "alphabetum cogitationum humanarum," an alphabet of human thoughts —
;;;;   a table of PRIMITIVE concepts from whose COMBINATIONS ("complexiones")
;;;;   every composite thought could be generated and judged. Fifty years later
;;;;   this is the seed of the characteristica universalis (Monadology's dream
;;;;   of a symbolic language in which concepts compose like numbers) and of the
;;;;   calculus ratiocinator (see calculemus.lisp, next door).
;;;;   [Exact Latin wording / pagination not verified here; the coinages
;;;;    "alphabetum cogitationum humanarum" and "complexiones" are genuinely his.]
;;;;
;;;; ── THE ONE MOVE LEIBNIZ SAW ──
;;;;
;;;;   Assign each PRIMITIVE concept a distinct PRIME. Then:
;;;;     * a COMPOSITE concept is the PRODUCT of its primitives' primes
;;;;       (composition = multiplication);
;;;;     * concept A is a GENUS of concept B iff A's number DIVIDES B's
;;;;       (to divide is to be contained in — the more general is the factor);
;;;;     * two concepts SHARE a genus iff their numbers share a factor
;;;;       (the shared genus is exactly their gcd, decoded back to primitives).
;;;;   Arithmetic becomes a logic of concepts. Unique factorization guarantees
;;;;   that a composite decomposes into its primitives in exactly one way — the
;;;;   Fundamental Theorem of Arithmetic doing duty as a theory of definition.
;;;;
;;;; ── THE CLAIM THIS PROGRAM MAKES BY RUNNING ──
;;;;   The concept-arithmetic is real and small: composition, genus, and shared
;;;;   genus all fall out of *, |, and gcd. And the combinatorial half — Leibniz's
;;;;   enumeration of complexiones — is driven by the porch's own amb: choose k
;;;;   primitives nondeterministically, backtrack, recover exactly the 2^N - 1
;;;;   non-empty combinations, cross-checked two ways.
;;;;
;;;; ── THE HEADLINE IS THE REFUSAL ──
;;;;   A "concept" is legitimate only if it decodes into the alphabet. Hand the
;;;;   decoder a number with an ALIEN prime factor, or a composition whose claimed
;;;;   factors do not multiply to the asserted number, and a typed condition
;;;;   REFUSES it. A gate that never bites is untested; both gates are shown biting.
;;;;
;;;; ── amb PROVENANCE ──
;;;;   The nondeterministic enumerator below is the success/fail continuation core
;;;;   of ../metacircular-porch/amb.lisp (McCarthy's amb, CPS with a backtrack
;;;;   counter), copied minimal and native rather than loaded — loading the porch
;;;;   would run its own demos. Same instrument (*backtracks* counted), same shape
;;;;   (a driver forces all solutions by calling FAIL after each success).
;;;;
;;;; Run with: sbcl --script ars-combinatoria.lisp   => exit 0 = the laws hold

;;; ════════════════════════════════════════════════════════════════════
;;; I. THE ALPHABET — primitive concepts, one prime each. A Porphyrian
;;;    slice, chosen so genus-by-division reads as the tradition reads:
;;;    the more general concept is the smaller factor.

(defparameter *alphabet*
  '((substance . 2)     ; ens per se — the root factor of everything here
    (corporeal . 3)     ; material, extended
    (animate   . 5)     ; living
    (sensitive . 7)     ; perceiving — the differentia of "animal"
    (rational  . 11)    ; reasoning — the differentia of "human"
    (mortal    . 13)    ; able to die
    (winged    . 17)))  ; a homely accident, to fill out the combinatorics

(defun name->num (name)
  (let ((cell (assoc name *alphabet*)))
    (if cell (cdr cell)
        (error 'unknown-primitive :number nil :prime name))))

(defun prime->name (p)
  (car (rassoc p *alphabet*)))

;;; ════════════════════════════════════════════════════════════════════
;;; II. THE TYPED REFUSALS — the boundary of the alphabet, in conditions.

(define-condition illegitimate-concept (error)
  ((number :initarg :number :reader bad-number)))

(define-condition unknown-primitive (illegitimate-concept)
  ((prime :initarg :prime :reader offending-name))
  (:report (lambda (c s)
             (format s "REFUSED: ~a is not a letter of the alphabet~%~
                        (only ~{~a~^, ~} are primitive)"
                     (offending-name c) (mapcar #'car *alphabet*)))))

(define-condition alien-primitive (illegitimate-concept)
  ((prime :initarg :prime :reader alien-factor))
  (:report (lambda (c s)
             (format s "REFUSED: ~a carries the factor ~a, outside the alphabet~%~
                        (a concept that will not decode is not spelled in this tongue)"
                     (bad-number c) (alien-factor c)))))

(define-condition composition-mismatch (illegitimate-concept)
  ((claimed  :initarg :claimed  :reader claimed-factors)
   (actual   :initarg :actual   :reader actual-number))
  (:report (lambda (c s)
             (format s "REFUSED: the factors ~a multiply to ~a, not to the asserted ~a~%~
                        (a composition must equal the product of what it claims to compose)"
                     (claimed-factors c) (actual-number c) (bad-number c)))))

;;; ════════════════════════════════════════════════════════════════════
;;; III. THE CONCEPT-ARITHMETIC — the whole logic, in *, |, gcd.

(defun compose (primitives)
  "The composite concept-number: the product of its primitives' primes.
   Composition IS multiplication."
  (reduce #'* (mapcar #'name->num primitives) :initial-value 1))

(defun decode (n)
  "Factor N over the alphabet, returning its primitive names in order.
   REFUSE (alien-primitive) the moment a factor escapes the alphabet."
  (let ((m n) (names '()))
    (dolist (p (sort (mapcar #'cdr *alphabet*) #'<))
      (loop while (and (> m 1) (zerop (mod m p))) do
        (push (prime->name p) names)
        (setf m (/ m p))))
    (unless (= m 1)
      (error 'alien-primitive :number n :prime m))
    (nreverse names)))

(defun affirm (label asserted-number claimed-primitives)
  "A concept is affirmed only if the asserted number equals the product of the
   primitives it claims — and only if that number decodes into the alphabet.
   Returns LABEL on success; signals a typed refusal otherwise."
  (let ((actual (compose claimed-primitives)))
    (unless (= actual asserted-number)
      (error 'composition-mismatch
             :number asserted-number :claimed claimed-primitives :actual actual))
    (decode asserted-number)          ; will refuse if any factor is alien
    label))

(defun genus-of-p (general special)
  "GENERAL is a (proper) genus of SPECIAL iff its number divides SPECIAL's and
   is strictly smaller — to divide is to be contained in."
  (and (< general special) (zerop (mod special general))))

(defun shared-genus (a b)
  "The greatest concept common to A and B: their gcd, decoded to primitives.
   NIL means they share nothing but bare disparateness (gcd = 1)."
  (let ((g (gcd a b)))
    (if (= g 1) nil (decode g))))

;;; ════════════════════════════════════════════════════════════════════
;;; IV. amb — the porch's success/fail continuation core (see PROVENANCE
;;;     above). *backtracks* is the instrument; the driver forces all
;;;     solutions by invoking FAIL after each success.

(defvar *backtracks* 0)

(defun amb-choose (choices succeed fail)
  "Yield each of CHOICES in turn; on backtrack, advance to the next."
  (if (null choices)
      (funcall fail)                                  ; (amb) with no options
      (funcall succeed (car choices)
               (lambda () (incf *backtracks*)
                 (amb-choose (cdr choices) succeed fail)))))

(defun enum-combinations (items k succeed fail)
  "Nondeterministically choose K of ITEMS in original order. Each item is,
   by amb, TAKEN or SKIPPED; the base cases are the require-gates."
  (labels ((rec (remaining need acc succeed fail)
             (cond
               ((zerop need) (funcall succeed (reverse acc) fail))   ; enough taken
               ((null remaining) (funcall fail))                     ; too few left
               (t (amb-choose
                   '(:take :skip)
                   (lambda (choice fail2)
                     (if (eq choice :take)
                         (rec (cdr remaining) (1- need)
                              (cons (car remaining) acc) succeed fail2)
                         (rec (cdr remaining) need acc succeed fail2)))
                   fail)))))
    (rec items k nil succeed fail)))

(defun collect-combinations (items k)
  "Force ALL k-combinations. Returns (values solutions backtracks)."
  (setf *backtracks* 0)
  (let ((sols '()))
    (catch 'done
      (enum-combinations items k
                         (lambda (combo fail) (push combo sols) (funcall fail))
                         (lambda () (throw 'done nil))))
    (values (nreverse sols) *backtracks*)))

(defun choose (n k)
  "C(n,k), computed directly, as an independent cross-check on the amb count."
  (labels ((fact (m) (if (<= m 1) 1 (* m (fact (1- m))))))
    (/ (fact n) (* (fact k) (fact (- n k))))))

;;; ════════════════════════════════════════════════════════════════════
;;; V. THE DEMONSTRATION — concept-arithmetic on the Porphyrian tree.

(format t "~%── ars combinatoria ───────────────────────────~%~%")
(format t "the alphabet of human thoughts (primitive : prime):~%")
(dolist (cell *alphabet*)
  (format t "    ~12a : ~a~%" (car cell) (cdr cell)))
(terpri)

;; Build some composite concepts by MULTIPLICATION.
(defparameter *body*   (compose '(substance corporeal)))                 ;   6
(defparameter *animal* (compose '(substance corporeal animate sensitive))) ; 210
(defparameter *human*  (compose '(substance corporeal animate sensitive rational mortal))) ; 30030
(defparameter *angel*  (compose '(substance rational)))                  ;  22
(defparameter *bird*   (compose '(substance corporeal animate sensitive winged)))          ; 3570

(format t "composite concepts, as products of their primitives:~%")
(format t "    body   = substance·corporeal                    = ~a~%" *body*)
(format t "    animal = substance·corporeal·animate·sensitive  = ~a~%" *animal*)
(format t "    human  = animal · rational · mortal             = ~a~%" *human*)
(format t "    angel  = substance·rational                     = ~a~%" *angel*)
(format t "    bird   = animal · winged                        = ~a~%~%" *bird*)

;; LAW 1: composition is order-independent — the concept is the number, not the
;; order of predication. "rational animal" and "animal rational" are one concept.
(assert (= *human* (compose '(mortal rational sensitive animate corporeal substance))))
(format t "law 1: predication order is irrelevant — human is one number, ~a,~%" *human*)
(format t "        however its primitives are ordered (commutativity of ·).~%~%")

;; GENUS by DIVISION.
(format t "genus, read off by division:~%")
(format t "    animal divides human?  ~:[no~;YES~]  (animal is a genus of human)~%"
        (genus-of-p *animal* *human*))
(format t "    animal divides bird?   ~:[no~;YES~]  (animal is a genus of bird)~%"
        (genus-of-p *animal* *bird*))
(format t "    rational divides body? ~:[no~;YES~]   (rational is NOT in body's line)~%~%"
        (genus-of-p (name->num 'rational) *body*))

;; SHARED GENUS by gcd.
(format t "shared genus, read off by gcd:~%")
(format t "    human & bird  share: ~a~%" (shared-genus *human* *bird*))
(format t "        (gcd ~a = ~a — their nearest common genus is 'animal')~%"
        (gcd *human* *bird*) (gcd *human* *bird*))
(format t "    human & angel share: ~a~%" (shared-genus *human* *angel*))
(format t "        (gcd ~a — rational substances, sharing reason without a body)~%~%"
        (gcd *human* *angel*))

;;; ════════════════════════════════════════════════════════════════════
;;; VI. THE COMPLEXIONES — Leibniz's combinatorial enumeration, via amb.

(format t "── the complexiones (Leibniz's com2nations, com3nations …) ──~%~%")
(let* ((prims (mapcar #'car *alphabet*))
       (n (length prims))
       (grand-total 0)
       (grand-backtracks 0))
  (loop for k from 1 to n do
    (multiple-value-bind (combos backs) (collect-combinations prims k)
      (incf grand-total (length combos))
      (incf grand-backtracks backs)
      ;; amb count must equal C(n,k), computed independently.
      (assert (= (length combos) (choose n k)))
      (when (member k '(2 3))                        ; show a couple in full
        (format t "  com~dnations of ~d primitives  (C(~d,~d) = ~d):~%" k n n k (choose n k))
        (dolist (c combos)
          (format t "      ~{~a~^·~}  =  ~a~%" c (compose c)))
        (terpri))
      (format t "  k=~d : ~2d combinations  (amb backtracked ~:d times)~%"
              k (length combos) backs)))
  ;; LAW 2: every non-empty subset of the alphabet is one complexio; there are
  ;; exactly 2^N - 1 of them, and amb recovered exactly that many.
  (format t "~%law 2: total complexiones = ~:d = 2^~d - 1 = ~:d~%"
          grand-total n (1- (expt 2 n)))
  (assert (= grand-total (1- (expt 2 n))))
  (format t "        amb recovered every one; total backtracks ~:d.~%~%"
          grand-backtracks))

;;; ════════════════════════════════════════════════════════════════════
;;; VII. THE TEETH — the refusals that map the alphabet's edge. Each gate
;;;      is handed a case it MUST reject; the catch is the pass.

(format t "the teeth — pretenders the arithmetic must REFUSE:~%")

;; (a) an ALIEN prime: 114 = 2·3·19. The 19 is no letter of this alphabet.
(handler-case
    (progn (decode 114)
           (error "the gate did not bite — VOID"))
  (alien-primitive (e)
    (format t "  [1] decode 114: ~a~%"
            (substitute #\space #\newline (format nil "~a" e)))))

;; (b) a COMPOSITION that lies about its factors: claim griffin = 30, "made of"
;;     corporeal·rational — but 3·11 = 33, not 30. The arithmetic will not be
;;     told what a concept is; it computes it.
(handler-case
    (progn (affirm 'griffin 30 '(corporeal rational))
           (error "the gate did not bite — VOID"))
  (composition-mismatch (e)
    (format t "  [2] affirm griffin=30 from {corporeal,rational}: ~a~%"
            (substitute #\space #\newline (format nil "~a" e)))))

;; A well-formed affirmation, for contrast — the gate that bites must also pass
;; the honest case, else it is merely broken.
(assert (eq 'true-human (affirm 'true-human *human*
                                '(substance corporeal animate sensitive rational mortal))))
(format t "  [+] affirm human = its true product: ACCEPTED (the gate is not merely shut).~%")
(format t "  the refusals draw the boundary: the arithmetic spells exactly the~%")
(format t "  alphabet's closure under ·, and stops — honestly — at its edge.~%")

;;; ════════════════════════════════════════════════════════════════════
;;; VIII. THE HONEST CEILING.

(format t "~%── the ceiling (stated at the door) ──────────~%")
(format t "  Prime-encoding is EXACT — but only where Leibniz's own premise holds:~%")
(format t "  that concepts are CONJUNCTIONS of INDEPENDENT primitives. Multiplication~%")
(format t "  models monotone 'A-and-B-and-C' and nothing else. It has no room for:~%")
(format t "    * NEGATION — 'immortal' is not the absence of the factor 13; a concept~%")
(format t "      and its privation cannot both be products of the same atoms.~%")
(format t "    * RELATION — 'taller-than', 'cause-of': Leibniz's deepest concepts are~%")
(format t "      relational, and gcd/divisibility see only shared parts, not order.~%")
(format t "    * NON-INDEPENDENCE — is 'rational' truly prime, or does it entail~%")
(format t "      'animate'? If the primitives interlock, unique factorization stops~%")
(format t "      meaning unique definition. Finding the TRUE atoms is the whole task,~%")
(format t "      and it is exactly where Leibniz's project stalled: he never fixed~%")
(format t "      the alphabet, so the numbers never got assigned for real.~%")
(format t "  This specimen plays the mechanism on a HAND-PICKED alphabet whose atoms~%")
(format t "  were chosen to behave. That is reconstruction, not exegesis — the model~%")
(format t "  absorbed this from the textual tradition; it does not 'understand Leibniz'.~%")

(format t "~%EXIT 0 — we composed by multiplying, judged genus by dividing,~%")
(format t "         enumerated the complexiones by amb, and refused the pretenders.~%")
