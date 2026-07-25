;;;; chain.lisp — the descent arithmetic, shared by the planter and the verifier.
;;;; Quine Orchard, Planting 11 (witnessed lineage). RADIX, 2026-07-25.
;;;;
;;;; This file is NOT the specimen. The specimen is the generation files
;;;; gen-NN.lisp, each of which carries its own inline copy of the three
;;;; functions below inside the lambda it reproduces. This file exists so the
;;;; PLANTER and the VERIFIER can speak the same arithmetic without either of
;;;; them being the artifact under test. That the inline copy and this copy
;;;; agree is not asserted here — it is what section 3 of verify-descent.lisp
;;;; (descent from the exterior root) measures, by recomputing every carried
;;;; link with THIS arithmetic and requiring it to equal the link the artifact
;;;; computed with ITS OWN.
;;;;
;;;; THE DIGEST IS NOT CRYPTOGRAPHIC. It is a base-31 polynomial rolling hash
;;;; reduced mod 1000000007 (a 30-bit prime) — the same family the orchard's
;;;; integrity-consistency quine already uses, kept deliberately so the two
;;;; specimens are comparable. Its properties:
;;;;   - collisions are cheap to CONSTRUCT deliberately (the map is linear over
;;;;     the prime field; solving for a colliding string is arithmetic, not search);
;;;;   - the output is ~30 bits, so exhaustive search over the whole codomain is
;;;;     ~1e9 trials, i.e. the exterior root is recoverable in principle from any
;;;;     single generation file by brute force (not attempted here);
;;;;   - it offers NO resistance to an adversary. It demonstrates the STRUCTURE of
;;;;     witnessed descent, and nothing about security.
;;;; Anything that needed to resist an adversary would need a wide cryptographic
;;;; digest and a signing key. This specimen has neither and claims neither.

(defparameter *canon-package* "COMMON-LISP-USER")

(defun canon (form)
  "The canonical serialization a link is computed over. Every printer control
that could move a byte is pinned EXPLICITLY: *print-pretty* defaults to T in
SBCL and *print-right-margin* defaults to NIL, so an unpinned PRIN1-TO-STRING of
a long form may insert newlines chosen by the implementation — a cross-machine
break two runs on one machine cannot detect. *print-length* / *print-level* are
pinned for the same reason (a truncating `...` would silently shorten the input),
and *package* is pinned because symbol prefixes depend on it."
  (let ((*package* (find-package *canon-package*)))
    (with-output-to-string (s)
      (write form :stream s :pretty nil :readably nil :escape t
                  :case :upcase :base 10 :radix nil :circle nil
                  :level nil :length nil))))

(defun digest-string (string)
  "Base-31 polynomial hash mod 1000000007. NOT cryptographic — see the header."
  (reduce (lambda (a c) (mod (+ (* a 31) c) 1000000007))
          (map 'list #'char-code string)
          :initial-value 0))

(defun digest-form (form)
  (digest-string (canon form)))

(defun link (prev body-form generation)
  "H_n = H(H_{n-1} | body_n | n). The concatenation `|` is realized as the
canonical printing of the three-element list (PREV BODY-FORM GENERATION), whose
parentheses and spaces are unambiguous delimiters — a bare string concatenation
would admit the classic chain ambiguity where (12,3) and (1,23) collide."
  (digest-form (list prev body-form generation)))

;;; ---------------------------------------------------------------------------
;;; The specimen template. This is the text of every generation; only the
;;; carried link H and the counter N differ between them. `body_n` — the thing
;;; the chain is computed over — is (LIST X BODY): the code form AND the
;;; payload, i.e. everything in the artifact except the link itself (which
;;; cannot hash itself) and the counter (which enters the formula separately).
;;; So the chain covers the whole artifact but for those two scalars.

(defparameter +specimen-lambda+
  '(LAMBDA (X BODY H N)
    (LABELS ((CANON (F)
               (LET ((*PACKAGE* (FIND-PACKAGE "COMMON-LISP-USER")))
                 (WITH-OUTPUT-TO-STRING (S)
                   (WRITE F :STREAM S :PRETTY NIL :READABLY NIL :ESCAPE T
                            :CASE :UPCASE :BASE 10 :RADIX NIL :CIRCLE NIL
                            :LEVEL NIL :LENGTH NIL))))
             (DIGEST (F)
               (REDUCE (LAMBDA (A C) (MOD (+ (* A 31) C) 1000000007))
                       (MAP 'LIST #'CHAR-CODE (CANON F))
                       :INITIAL-VALUE 0))
             (LINK (PREV BODY-FORM GEN)
               (DIGEST (LIST PREV BODY-FORM GEN))))
      (LET ((NEXT-N (1+ N)))
        (WRITE (LIST X (LIST 'QUOTE X) (LIST 'QUOTE BODY)
                     (LINK H (LIST X BODY) NEXT-N)
                     NEXT-N)
               :PRETTY NIL :READABLY NIL :ESCAPE T :CASE :UPCASE
               :BASE 10 :RADIX NIL :CIRCLE NIL :LEVEL NIL :LENGTH NIL)))))

(defparameter +specimen-body+
  '(DESCENT IS RELATIVE TO AN ANCHOR THIS TEXT DOES NOT CONTAIN))

(defun generation-form (lambda-form body h n)
  (list lambda-form (list 'quote lambda-form) (list 'quote body) h n))

(defun emit-generation (path lambda-form body h n)
  "Write one generation to PATH with no trailing newline (orchard discipline:
the last byte of a specimen is #\\) — 0x29)."
  (with-open-file (s path :direction :output :if-exists :supersede
                          :if-does-not-exist :create)
    (write-string (canon (generation-form lambda-form body h n)) s))
  path)

;;; --- reading a generation back as data -------------------------------------

(defun read-generation (path)
  "Return (values lambda-form quoted-copy body h n) for the generation at PATH."
  (let ((*package* (find-package *canon-package*)))
    (with-open-file (s path :direction :input)
      (let ((form (read s)))
        (values (first form)
                (second (second form))
                (second (third form))
                (fourth form)
                (fifth form))))))

(defun body-of (lambda-form body)
  "body_n, the form the chain is computed over."
  (list lambda-form body))
