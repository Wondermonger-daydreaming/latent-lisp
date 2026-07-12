;;; de-indiscernibilibus.lisp — Concerning the Identity of Indiscernibles
;;;
;;; Leibniz's Principle of the Identity of Indiscernibles (PII): if x and y
;;; share every predicate, they are numerically ONE. (Monadology ~§9; the
;;; principle also in the Discourse and the Leibniz–Clarke correspondence,
;;; Third & Fourth Letters — ref unverified for exact section numbering.)
;;;
;;; Lisp keeps FOUR grades of "the same" — eq / eql / equal / equalp — and so
;;; it is a working laboratory for the principle. Two s-expressions built the
;;; same way are EQUAL (indiscernible by content) yet not EQ (two cells at two
;;; addresses). That is the classic objection made executable: indiscernible
;;; and still two — UNLESS location-in-memory is admitted as a discerning
;;; predicate, which is exactly the scholarly dispute (Clarke's two-drops-of-
;;; water reply against Leibniz's relationalism).
;;;
;;; This specimen holds BOTH horns at once:
;;;   * default CONS is the counter-model — anti-PII: equal, not eq.
;;;   * a HASH-CONSING constructor is the enforcer — pro-PII: it interns cells
;;;     so that EQUAL structure is forced to be the EQ same object. Hash-consing
;;;     IS the Identity of Indiscernibles made a memory policy: it abolishes
;;;     indiscernible-yet-distinct values by construction.
;;;
;;; The law: under hash-consing, (equal x y) => (eq x y), for all built values.
;;; The teeth: the naive claim "equal implies same object" is FALSE under
;;;     default allocation — shown firing and caught (the catch is the pass).
;;;
;;; sbcl --script de-indiscernibilibus.lisp  => exit 0, deterministic
;;; built by FABER-THEODICAEAE (Claude Opus) under the Fable 5 chair, 2026-07-12.

;;; ---- The identity zoo: four grades of indiscernibility ------------------

(defun grade-report (label a b)
  (format t "  ~a~%    eq=~a  eql=~a  equal=~a  equalp=~a~%"
          label (and (eq a b) t) (and (eql a b) t)
          (and (equal a b) t) (and (equalp a b) t)))

;; A special variable the compiler must not constant-fold through, so the two
;; bignums below are separately heap-boxed — else literal coalescing hides the
;; grade by making them EQ.
(defparameter *two* 2)

(defun show-the-zoo ()
  (let ((n1 (expt *two* 100))   ; a fresh bignum
        (n2 (expt *two* 100)))  ; another fresh bignum, same value
    (format t "THE IDENTITY ZOO — four predicates, four grades of 'the same':~%")
    (grade-report "symbols   'foo 'foo:" 'foo 'foo)          ; eq: interned
    (grade-report "bignums  2^100 2^100:" n1 n2)             ; eql, not eq
    (grade-report "lists    (1 2) (1 2):" (list 1 2) (list 1 2)) ; equal, not eq
    (grade-report "strings  \"AB\" \"ab\":" "AB" "ab")        ; equalp only
    (terpri)))

;;; ---- The builder: two indiscernible s-expressions ----------------------
;;; Deterministic, no shared substructure — each call allocates fresh cells.

(defun build-monad ()
  "A small nested structure, freshly consed every call."
  (list 'monad (list 'mirrors 'universe) (list 'from 'its 'view)))

;;; The naive Leibnizian claim, put to code:
;;;   indiscernible (EQUAL) must be identical (EQ).
(defun naive-pii-holds-p (x y)
  (if (equal x y) (eq x y) t))

;;; ---- The enforcer: a hash-consing constructor --------------------------
;;; An EQUAL-keyed table interns cons cells: the FIRST cell of a given shape
;;; is kept, every later request for that shape returns the SAME cell. Build
;;; bottom-up so children are already canonical. Then EQUAL => EQ by policy.

(defvar *cons-table* (make-hash-table :test 'equal))

(defun hcons (a d)
  "Interned cons: structurally-equal (a . d) always yields the one same cell."
  (let ((key (cons a d)))
    (or (gethash key *cons-table*)
        (setf (gethash key *cons-table*) key))))

(defun intern-tree (x)
  "Recursively re-build X out of interned cells (atoms pass through)."
  (if (consp x)
      (hcons (intern-tree (car x)) (intern-tree (cdr x)))
      x))

;;; ---- The demonstration -------------------------------------------------

(defun run ()
  (show-the-zoo)

  (format t "DEFAULT CONS — the counter-model (anti-PII):~%")
  (let ((a (build-monad))
        (b (build-monad)))
    (assert (equal a b))                       ; indiscernible by content
    (assert (not (eq a b)))                    ; yet two objects, two addresses
    (format t "  a and b are EQUAL (indiscernible) but NOT EQ (two cells).~%")
    (format t "  Clarke's objection, executable: content cannot tell them apart;~%")
    (format t "  only their place in memory can. Is place a predicate? Dispute open.~%")
    ;; TEETH: the naive claim must FAIL here, and we catch the failure.
    (if (naive-pii-holds-p a b)
        (error "TEETH FAILED: 'equal implies eq' unexpectedly held under default cons")
        (format t "  teeth: 'equal implies same object' FIRED FALSE, caught.~%")))
  (terpri)

  (format t "HASH-CONS — the enforcer (pro-PII, PII as a memory policy):~%")
  (let ((a (intern-tree (build-monad)))
        (b (intern-tree (build-monad))))
    (assert (equal a b))
    (assert (eq a b))                          ; indiscernibles collapsed to one
    (assert (naive-pii-holds-p a b))
    (format t "  a and b are now EQ: the two cells were interned into one.~%")
    (format t "  Indiscernible-yet-distinct has been abolished by construction.~%"))
  (terpri)

  ;; THE LAW: over a batch of built values, under interning EQUAL => EQ, always.
  (format t "THE LAW — over ~d built values, (equal x y) => (eq x y):~%" 12)
  (let ((canon '()))
    (dotimes (i 12)
      (push (intern-tree (build-monad)) canon))
    (loop for x in canon do
      (loop for y in canon do
        (when (equal x y) (assert (eq x y)))))
    ;; all twelve were the same shape, so all interned to ONE object:
    (assert (= 1 (length (remove-duplicates canon :test #'eq))))
    (format t "  HOLDS — all 12 indiscernibles interned to a single object.~%"))
  (terpri)

  ;; HONEST CEILING ------------------------------------------------------
  ;; Source played: PII (Monadology, ~§9; Leibniz–Clarke letters — ref unverified).
  ;; What the finite model dropped:
  ;;   * Leibniz's PII is about COMPLETE concepts of substances — every predicate,
  ;;     internal and relational, across all time. EQUAL compares a frozen finite
  ;;     tree; it cannot range over infinite predicates, so "indiscernible here"
  ;;     is only "indiscernible under this test," never Leibniz's full discernment.
  ;;   * Whether address-in-memory is a genuine discerning predicate or a mere
  ;;     bookkeeping artifact is the live philosophical question; the code EXHIBITS
  ;;     both readings (default cons says yes, hash-cons says no) but SETTLES
  ;;     neither — it makes the dispute runnable, not decided.
  ;;   * Hash-consing enforces PII only for immutable structure; a mutable slot
  ;;     would let two cells diverge after interning, re-opening the counter-model.
  (format t "EXIT 0 — indiscernibles are two, or one, according to whether~%")
  (format t "         memory-place is a predicate. Lisp lets you choose the world.~%"))

(run)
