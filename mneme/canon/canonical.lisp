;;;; canonical.lisp — a prototype CANONICAL printer + reader for the Language-A
;;;; `judgment` record grammar.  Phase P3a of mneme/ROADMAP.md (S4: canonicalization
;;;; promoted BEFORE P2b — measurement depends on a byte-stable representation).
;;;;
;;;; ┌──────────────────────────────────────────────────────────────────────────┐
;;;; │ WHAT THIS DOES — AND, LOUDLY, WHAT IT DOES NOT ESTABLISH                    │
;;;; ├──────────────────────────────────────────────────────────────────────────┤
;;;; │ It fixes, once and versioned (mneme-canon/0), exactly which BYTES a         │
;;;; │ Language-A judgment record IS: a single deterministic string, independent  │
;;;; │ of every ambient printer dynamic-variable.                                 │
;;;; │                                                                            │
;;;; │  · Scope: the Language-A `judgment` record grammar ONLY — NOT arbitrary    │
;;;; │    Lisp objects. Cyclic / unreadable / out-of-grammar → TYPED REFUSAL      │
;;;; │    (condition NON-CANONICAL-OBJECT), never an improvised print.            │
;;;; │  · Canonicalization is NOT integrity. These bytes carry no MAC; a bit-flip │
;;;; │    is undetectable here. Tamper-evidence is P3b (canonical bytes + HMAC).  │
;;;; │  · Canonicalization is NOT truth, and NOT coherence. It is representation.  │
;;;; │    The validator (../language-a/validator.lisp) owns coherence; neither    │
;;;; │    owns truth.                                                             │
;;;; │  · Float canonicality is SBCL-2.4.6-pinned (shortest round-tripping        │
;;;; │    single-float print). A printer change in a future SBCL is, by design,   │
;;;; │    a NEW canon version — that is the whole point of versioning.            │
;;;; └──────────────────────────────────────────────────────────────────────────┘
;;;;
;;;; Sol's versioning formula, governing (ROADMAP S4, verbatim):
;;;;   "each canonical byte encoding is explicitly versioned and immutable once
;;;;    published."
;;;;
;;;; SBCL 2.4.6, `sbcl --script canonical.lisp`, no external dependencies
;;;; (sb-md5 is a bundled SBCL contrib, not a quicklisp/network import).

;;; ── load the validator (for the mneme.language-a package + accessors) silently ──
;;; The validator prints a preamble on load; we swallow it so this script's own
;;; stdout stays deterministic and clean.
(let ((*standard-output* (make-broadcast-stream))
      (*error-output* (make-broadcast-stream)))
  (load (merge-pathnames "../language-a/validator.lisp" *load-truename*)))

(in-package #:mneme.language-a)

(defparameter *canon-version* "mneme-canon/0"
  "The grammar/schema version identifier of THIS byte encoding. Immutable once
   published; a change to any rule below mints a new version string, never a silent
   re-meaning of an old one.")

;;; ── pull the 14 fixtures WITHOUT running the suite (it calls sb-ext:exit) ──────
;;; We read fixtures.lisp form-by-form and eval ONLY the defstruct + the two
;;; fixture defparameters, skipping the runner and its exit.
(let ((path (merge-pathnames "../language-a/fixtures.lisp" *load-truename*)))
  (with-open-file (in path :direction :input)
    (loop for form = (read in nil :eof)
          until (eq form :eof)
          do (when (and (consp form)
                        (or (eq (first form) 'defstruct)
                            (and (eq (first form) 'defparameter)
                                 (member (second form) '(*lawful* *malformed*)))))
               (eval form)))))

(defparameter *all-fixtures* (append *lawful* *malformed*)
  "All 14 fixtures (6 lawful + 8 malformed). Canonicalization is defined over the
   record SHAPE and is indifferent to whether the record would pass VALIDATION.")

;;; ══════════════════════════════════════════════════════════════════════════════
;;;  THE TYPED REFUSAL — out-of-grammar / cyclic / unreadable objects
;;; ══════════════════════════════════════════════════════════════════════════════
(define-condition non-canonical-object (error)
  ((kind   :initarg :kind   :reader nc-kind)
   (object :initarg :object :reader nc-object))
  (:report (lambda (c s)
             (format s "NON-CANONICAL-OBJECT (~a): outside the canonicalizable ~
                        Language-A grammar — ~s"
                     (nc-kind c) (nc-object c)))))

(defun refuse (kind obj) (error 'non-canonical-object :kind kind :object obj))

;;; ══════════════════════════════════════════════════════════════════════════════
;;;  ATOM CANONICALIZATION — every leaf, independent of ambient print state
;;; ══════════════════════════════════════════════════════════════════════════════

(defparameter *safe-rest* "abcdefghijklmnopqrstuvwxyz0123456789-_./*+?!<>=&%$@^~"
  "Characters permitted (after downcasing) in a bare canonical symbol/keyword token.
   A downcased symbol name that is non-empty, letter-initial, and drawn wholly from
   this set reads back as the same symbol under the canonical reader. Anything else
   is out-of-grammar and REFUSED — the Language-A grammar never needs escaping.")

(defun safe-token-p (name)
  (and (plusp (length name))
       (alpha-char-p (char name 0))
       (every (lambda (ch) (find ch *safe-rest*)) name)))

(defun safe-sym-name (sym)
  "Downcased symbol name, or a typed refusal if the name would not round-trip bare."
  (let ((d (string-downcase (symbol-name sym))))
    (unless (safe-token-p d) (refuse :non-canonical-symbol sym))
    d))

(defun canon-string (s)
  "Double-quoted, backslash-escaping only #\\\" and #\\\\ (standard Lisp string syntax).
   Content bytes are the UTF-8 encoding of the string."
  (with-output-to-string (o)
    (write-char #\" o)
    (loop for ch across s do
      (when (or (char= ch #\") (char= ch #\\)) (write-char #\\ o))
      (write-char ch o))
    (write-char #\" o)))

(defun canon-float (x)
  "Shortest round-tripping decimal, single-float format pinned so no exponent
   marker appears. SBCL-2.4.6-deterministic; version-bound."
  (let ((*read-default-float-format* 'single-float)
        (*print-readably* nil))
    (prin1-to-string x)))

(defun canon-atom (x)
  (cond
    ((null x)       "nil")                          ; () and NIL both → nil
    ((eq x t)       "t")
    ((keywordp x)   (concatenate 'string ":" (safe-sym-name x)))
    ((symbolp x)    (safe-sym-name x))              ; bare, downcased, package-stripped
    ((integerp x)   (format nil "~D" x))            ; base 10, no radix prefix, ambient-immune
    ((floatp x)     (canon-float x))
    ((stringp x)    (canon-string x))
    (t              (refuse :unreadable x))))       ; hash-table, struct, fn, char, ...

;;; ══════════════════════════════════════════════════════════════════════════════
;;;  STRUCTURE CANONICALIZATION — records sort their clauses; data lists preserve order
;;; ══════════════════════════════════════════════════════════════════════════════
;;;
;;; A cons is a RECORD iff its cdr is non-empty AND every cdr element is a CLAUSE
;;; (a cons whose car is a keyword). A record's clauses are keyed and order-
;;; irrelevant (the validator's CLAUSE/VAL accessors look up by key, never by
;;; position), so we SORT them by key-name — the canonical order. Everything else
;;; is a DATA list (a proposition like (listed-in "..." catalog); a receipt list
;;; like (receipt-17); the claims list) whose order IS semantic and is PRESERVED.
;;;
;;; Soundness note (a ceiling, stated): this structural test is sound over the
;;; Language-A grammar because no DATA payload there is a list whose every element
;;; is a keyword-headed clause. A grammar extension that violated this must bump
;;; the canon version.

(defun clause-p (x) (and (consp x) (keywordp (car x))))
(defun clause-key (c) (symbol-name (car c)))

(defun list-elements (x)
  "Walk the spine of the proper list X, returning its elements. A circular or
   improper spine is REFUSED (typed), never walked forever — this is what stops a
   cyclic structure from exhausting the heap before the vertical cycle-check fires."
  (let ((seen '()) (acc '()))
    (loop for node = x then (cdr node) do
      (cond ((null node)               (return (nreverse acc)))
            ((not (consp node))        (refuse :improper x))
            ((member node seen :test #'eq) (refuse :cyclic x))
            (t (push node seen) (push (car node) acc))))))

(defun join-canon (items)
  (with-output-to-string (o)
    (loop for i in items
          for first = t then nil
          unless first do (write-char #\Space o)
          do (write-string i o))))

(defun canon (x &optional (seen '()))
  (cond
    ((atom x) (canon-atom x))
    ((member x seen :test #'eq) (refuse :cyclic x))          ; vertical (ancestor) cycle
    (t
     (let* ((seen2   (cons x seen))
            (elts    (list-elements x))                       ; spine-safe
            (head    (first elts))
            (clauses (rest elts)))
       (if (and clauses (every #'clause-p clauses))
           ;; RECORD — head tag + clauses SORTED by key (order is not semantic)
           (let* ((sorted (stable-sort (copy-list clauses) #'string< :key #'clause-key))
                  (parts  (cons (canon-atom head)
                                (mapcar (lambda (c) (canon c seen2)) sorted))))
             (concatenate 'string "(" (join-canon parts) ")"))
           ;; DATA list — order PRESERVED (proposition, receipt list, claims list …)
           (concatenate 'string "("
                        (join-canon (mapcar (lambda (e) (canon e seen2)) elts))
                        ")"))))))

(defun canonical-bytes (record)
  "RECORD → its canonical string (mneme-canon/0). The UTF-8 encoding of this string
   is the content-addressed byte sequence."
  (canon record '()))

;;; ══════════════════════════════════════════════════════════════════════════════
;;;  THE CANONICAL READER — deterministic, injection-safe
;;; ══════════════════════════════════════════════════════════════════════════════
(defun canonical-read (string)
  "Read a canonical string back into a record. Standard readtable (:upcase case),
   base-10, *read-eval* NIL (no #. injection), single-float default, interning into
   the mneme.language-a package so bare symbols land where they belong."
  (with-standard-io-syntax
    (let ((*package* (find-package '#:mneme.language-a))
          (*read-eval* nil)
          (*read-default-float-format* 'single-float))
      (values (read-from-string string)))))

;;; ── the NAIVE (vulnerable) printer, for the ambient-attack contrast ────────────
(defun naive-bytes (x)
  "A naive printer: whatever the ambient dynamic printer state says. Present ONLY to
   demonstrate the defect the canonical printer cures — never a canonical path."
  (prin1-to-string x))

;;; ── md5 content-address (sb-md5: a bundled SBCL contrib, NOT an external dep) ───
(require :sb-md5)
(defun md5-hex (string)
  (let ((octets (sb-ext:string-to-octets string :external-format :utf-8)))
    (string-downcase
     (with-output-to-string (o)
       (loop for b across (sb-md5:md5sum-sequence octets)
             do (format o "~2,'0X" b))))))

;;; ══════════════════════════════════════════════════════════════════════════════
;;;  RUN — fixpoint proof · ambient-attack teeth · manifest
;;; ══════════════════════════════════════════════════════════════════════════════
(defvar *failures* 0)

(format t "~%══════════════════════════════════════════════════════════════════════~%")
(format t "  CANONICAL PRINTER/READER — ~a~%" *canon-version*)
(format t "  Language-A `judgment` grammar only. Not integrity. Not truth.~%")
(format t "══════════════════════════════════════════════════════════════════════~%")

;;; ── (1) FIXPOINT over all 14 fixtures: print₂ = print₁ ─────────────────────────
(format t "~%(1) FIXPOINT  read → canonical-print → read → canonical-print = byte-identical~%")
(format t "    ------------------------------------------------------------------~%")
(dolist (f *all-fixtures*)
  (let* ((rec (fixture-record f))
         (b1  (canonical-bytes rec))
         (r2  (canonical-read b1))
         (b2  (canonical-bytes r2)))
    (if (string= b1 b2)
        (format t "    PASS  ~a~40t(~a bytes)~%" (fixture-name f) (length b1))
        (progn (incf *failures*)
               (format t "    FAIL  ~a~40t print2 /= print1~%" (fixture-name f))))))

;;; ── (2) AMBIENT-ATTACK TEETH — the planted non-canonical print ─────────────────
;;; A naive print is a FUNCTION OF AMBIENT DYNAMIC STATE. Simulate leaked state
;;; between two prints (a hostile *print-case* / *print-base*). The naive fixpoint
;;; FAILS (print2 /= print1); the canonical printer binds everything and is IMMUNE.
(format t "~%(2) AMBIENT ATTACK  (the teeth: a non-canonical print, shown failing)~%")
(format t "    ------------------------------------------------------------------~%")
(flet ((clean (fn rec) (let ((*print-case* :downcase) (*print-base* 10)) (funcall fn rec)))
       (hostile (fn rec) (let ((*print-case* :upcase) (*print-base* 16)) (funcall fn rec))))
 (let* ((rec (fixture-record (first *lawful*)))     ; L1 supported-answer
        ;; two prints of the SAME record, under two ambient dynamic states
        (naive-clean   (clean   #'naive-bytes rec))
        (naive-hostile (hostile #'naive-bytes rec))
        (canon-clean   (clean   #'canonical-bytes rec))
        (canon-hostile (hostile #'canonical-bytes rec)))
  (format t "    Two prints of one record; state leaked between them (case :downcase→:upcase, base 10→16):~%")
  (format t "      NAIVE print1 (head): ~a~%" (subseq naive-clean   0 (min 42 (length naive-clean))))
  (format t "      NAIVE print2 (head): ~a~%" (subseq naive-hostile 0 (min 42 (length naive-hostile))))
  (if (string= naive-clean naive-hostile)
      (progn (incf *failures*)
             (format t "      *** naive did NOT swing — attack demonstration BROKEN ***~%"))
      (format t "      => NAIVE FIXPOINT FAILS: print2 /= print1 (bytes are a function of ambient state).~%"))
  (format t "    CANONICAL print of the SAME record under the SAME two ambient states:~%")
  (format t "      CANON print1 (head): ~a~%" (subseq canon-clean   0 (min 42 (length canon-clean))))
  (format t "      CANON print2 (head): ~a~%" (subseq canon-hostile 0 (min 42 (length canon-hostile))))
  (if (string= canon-clean canon-hostile)
      (format t "      => CANONICAL IMMUNE: byte-identical (binds every printer variable itself).~%")
      (progn (incf *failures*)
             (format t "      *** CANONICAL swung under ambient state — INVARIANT BROKEN ***~%"))))
  ;; a second, numeric attack lens: base makes 255 lie; canonical never does
  (format t "    Numeric lens:  (prin1-to-string 255) under *print-base* 16 = ~s ~
                 vs canonical ~s~%"
          (let ((*print-base* 16)) (prin1-to-string 255))
          (let ((*print-base* 16)) (format nil "~D" 255))))

;;; ── (3) REFUSAL TEETH — cyclic + unreadable → typed condition, not a hang/crash ─
(format t "~%(3) REFUSAL  out-of-grammar objects raise NON-CANONICAL-OBJECT (typed)~%")
(format t "    ------------------------------------------------------------------~%")
(let ((cyclic (list 1 2 3)))
  (setf (cddr cyclic) cyclic)                        ; a real structural cycle
  (handler-case (progn (canonical-bytes cyclic) (incf *failures*)
                       (format t "    FAIL  cyclic structure was NOT refused~%"))
    (non-canonical-object (c)
      (format t "    PASS  cyclic       → refused (~a)~%" (nc-kind c)))))
(handler-case (progn (canon-atom (make-hash-table)) (incf *failures*)
                     (format t "    FAIL  hash-table was NOT refused~%"))
  (non-canonical-object (c)
    (format t "    PASS  hash-table   → refused (~a)~%" (nc-kind c))))

;;; ── (4) MANIFEST — md5 of every fixture's canonical bytes (the content-address) ─
(let ((manifest-path (merge-pathnames "md5-manifest.txt" *load-truename*))
      (rows '()))
  (dolist (f *all-fixtures*)
    (push (list (md5-hex (canonical-bytes (fixture-record f))) (fixture-name f)) rows))
  (setf rows (nreverse rows))
  (with-open-file (out manifest-path :direction :output :if-exists :supersede
                                     :if-does-not-exist :create)
    (format out "# md5-manifest.txt — content-address of each fixture's canonical bytes~%")
    (format out "# encoding: ~a ; md5 over UTF-8 octets of canonical-bytes~%" *canon-version*)
    (format out "# A hash change here = a canonicalization change = a new canon version is owed.~%")
    (format out "# This is content-addressing, NOT integrity: md5 has no key; see canonical.lisp ceiling.~%")
    (dolist (r rows)
      (format out "~a  ~a~%" (first r) (second r))))
  (format t "~%(4) MANIFEST  wrote md5-manifest.txt  (~a fixtures)~%" (length rows))
  (format t "    first: ~a  ~a~%" (first (first rows))  (second (first rows)))
  (format t "    last:  ~a  ~a~%" (first (car (last rows))) (second (car (last rows)))))

;;; ── verdict ────────────────────────────────────────────────────────────────────
(format t "~%──────────────────────────────────────────────────────────────────────~%")
(if (zerop *failures*)
    (progn
      (format t "  PASSED — 14/14 fixpoint · naive-attack demonstrated · canonical immune ·~%")
      (format t "           cyclic+unreadable refused · manifest written.~%")
      (format t "  Ceiling restated: this is REPRESENTATION, versioned (~a). Not integrity~%" *canon-version*)
      (format t "  (no MAC — that is P3b), not coherence (the validator), not truth.~%")
      (format t "──────────────────────────────────────────────────────────────────────~%")
      (sb-ext:exit :code 0))
    (progn
      (format t "  FAILED — ~a unmet expectation(s).~%" *failures*)
      (format t "──────────────────────────────────────────────────────────────────────~%")
      (sb-ext:exit :code 1)))
