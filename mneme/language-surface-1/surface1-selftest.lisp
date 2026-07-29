;;;; surface1-selftest.lisp — Language Surface /1, Candidate /0: the teeth.
;;;;
;;;; Run: sbcl --non-interactive --load surface1-selftest.lisp
;;;;
;;;; This suite loads Surface /1 (which loads CD/0 ONLY) and then loads
;;;; Surface /0 SEPARATELY, as a client would, so that the layer's own load
;;;; graph is observable rather than asserted: check A1 records that Surface /1
;;;; came up with Surface /0 absent.
;;;;
;;;; Every green here is SELF-CONSISTENCY CERTIFICATION by the family that wrote
;;;; the layer.  The stranger audit is OWED.

(defparameter *here* (or *load-truename* *default-pathname-defaults*))

;;; --- A1 is measured BEFORE anything else can perturb it. -------------
(handler-bind ((style-warning #'muffle-warning))
  (load (merge-pathnames "surface1.lisp" *here*)))
(defparameter *surface0-absent-after-surface1-load*
  (not (find-package '#:lisp-plus-surface0)))

;;; Now Surface /0, as a client.
(handler-bind ((style-warning #'muffle-warning))
  (load (merge-pathnames "../language-surface-0/surface0.lisp" *here*)))

(defpackage #:surface1-selftest (:use #:common-lisp))
(in-package #:surface1-selftest)

(defmacro s1 (name &rest args)
  "ERRATA 0.1 — finding 4, second half.  Candidate /0's version used INTERN,
which cannot tell an internal symbol from an external one, so the suite reached
a NON-EXPORTED accessor without noticing.  This one resolves through
FIND-SYMBOL and refuses at macroexpansion time unless the symbol is EXTERNAL —
so a suite can no longer silently depend on a private name."
  (multiple-value-bind (sym status) (find-symbol (string name) '#:lisp-plus-surface1)
    (unless (eq status :external)
      (error "S1: ~A is ~:[absent~;~:*~A~] in LISP-PLUS-SURFACE1, not :EXTERNAL"
             (string name) status))
    `(,sym ,@args)))
(defmacro cd0 (name &rest args)
  "EVIDENCE ADDENDUM 0.1 — the last surviving bare-INTERN helper.

Errata 0.1 repaired the S1 helper directly above; Errata 0.3 / D8 F-16 repaired
BOTH helpers in the stub fixture, the application and all three reproductions.
This one was missed — five instruments of six.  Bare INTERN cannot tell a private
name from a public one and MANUFACTURES a name it fails to find, so a typo or a
demoted export became a fresh internal symbol in LISP-PLUS-CD0 and the error
surfaced far from its cause, as an undefined function rather than as a refusal to
resolve.  Worse for an evidence instrument: interning MUTATES the image the suite
claims to be observing.

Now resolved EXTERNAL-ONLY, refusing at macroexpansion time — the same contract
S1 has carried since Errata 0.1, and the same one the other five instruments
carry since Errata 0.3."
  (multiple-value-bind (symbol status)
      (find-symbol (string name) '#:lisp-plus-cd0)
    (unless (eq status :external)
      (error "CD0: ~A is ~:[absent~;~:*~A~] in LISP-PLUS-CD0, not :EXTERNAL"
             (string name) status))
    `(,symbol ,@args)))

(defparameter *checks* 0)
(defparameter *failed* 0)

;;; ------------------------------------------------------------------
;;; THE EXPECTED CHECK COUNT.                       [ERRATA 0.3 — D4]
;;; ------------------------------------------------------------------
;;;
;;; The stranger audit's teeth controls (FOSSOR §4, T5-T11) truncated this file
;;; at a clean form boundary and the evidence runner reported SUCCESS, because
;;; the runner's only success condition was the process exit code and a
;;; truncated run exits 0 without ever reaching the summary.  A count printed
;;; from a live counter alone cannot detect that: a run that executed half its
;;; checks prints half a count, in the same shape, and nothing compares it to
;;; anything.
;;;
;;; So the file DECLARES, here at the top, how many checks it intends to
;;; execute, and the canonical result line at the foot prints the DECLARED
;;; number beside the LIVE one.  A truncated run never reaches the line at all;
;;; a run that reaches it having executed a different number of checks prints a
;;; line the runner will not accept.  The literal is not decoration — it is the
;;; only part of the count a partial execution cannot forge.
(defparameter *expected-checks* 139)

(defun ok (label condition &optional detail)
  (incf *checks*)
  (if condition
      (format t "  [~3,'0D] ok   ~A~%" *checks* label)
      (progn (incf *failed*)
             (format t "  [~3,'0D] FAIL ~A~@[  ~A~]~%" *checks* label detail))))
(defun section (title) (format t "~%── ~A~%" title))

(defun tag (&rest path) (cd0 make-identifier-datum '("surface1-selftest") path))
(defun same (a b) (cd0 equal-datum a b))

;;; ------------------------------------------------------------------
;;; THE LIVE REFUSAL-CODE REGISTRY.              [ERRATA 0.3 — D8/F-6]
;;; ------------------------------------------------------------------
;;;
;;; Candidate /0 through Errata 0.2 measured refusal-code coverage against
;;; `*EXERCISED*`, a HAND-WRITTEN list of codes the suite was BELIEVED to drive.
;;; Nothing checked the belief.  The stranger audit found the list naming
;;; :SOURCE-TERM-SHARED-STRUCTURE, which no check in any instrument ever
;;; produced, and the coverage claim built on the list was therefore false while
;;; the check reading the list stayed green — the falsehood lived inside the
;;; thing the check consulted.
;;;
;;; A hand-written list cannot measure coverage.  This registry can: every
;;; refusal object this suite obtains passes through OBSERVE, which records the
;;; code that was ACTUALLY PRODUCED.  The coverage section at the foot of this
;;; file then compares the OBSERVED set against the catalogue, in both
;;; directions.  A check that stops driving a code drops it from the set.
(defparameter *observed-codes* '())

(defun observe (refusal)
  "Record the code of a refusal object this suite actually obtained, and return
the object unchanged so OBSERVE can be wrapped around any acquisition site."
  (when refusal
    (pushnew (lisp-plus-surface1:expansion-refusal-code refusal) *observed-codes*))
  refusal)

(defun refusal-of (thunk)
  "Run THUNK; return the Surface /1 refusal object it produced, or NIL.
Every refusal that passes through here is recorded in *OBSERVED-CODES*."
  (observe
   (handler-case (progn (funcall thunk) nil)
     (lisp-plus-surface1:expansion-refused (c)
       (lisp-plus-surface1:expansion-condition-refusal c)))))

;;; The internal condition classes the RAW public term functions signal.  They
;;; are not exported — ENCODE-TERM and DECODE-TERM are checking surfaces, not
;;; refusal-minting doors — so a check that wants to name the exact reason must
;;; reach them by an explicit internal reference, exactly as the planted-fault
;;; checks in section K already do.  ERRATA 0.3 (F-11): five checks used to
;;; accept "some error was signalled" as proof of a specific refusal.
(defun term-unrepresentable-reason (thunk)
  "Return the REASON keyword of the %TERM-UNREPRESENTABLE that THUNK signals,
:NO-CONDITION if it returns, or a list naming whatever else was signalled."
  (handler-case (progn (funcall thunk) :no-condition)
    (lisp-plus-surface1::%term-unrepresentable (c)
      (lisp-plus-surface1::%tu-reason c))
    (condition (c) (list :other-condition (type-of c)))))

(defun term-irreconstructible-reason (thunk)
  "Return the REASON keyword of the %TERM-IRRECONSTRUCTIBLE that THUNK signals,
:NO-CONDITION if it returns, or a list naming whatever else was signalled."
  (handler-case (progn (funcall thunk) :no-condition)
    (lisp-plus-surface1::%term-irreconstructible (c)
      (lisp-plus-surface1::%ti-reason c))
    (condition (c) (list :other-condition (type-of c)))))

;;; The one specimen, chosen because EVERY field of it is literal syntax:
;;; nothing in the source is evaluated, so the expansion is a pure function of
;;; the source text.
(defparameter *specimen*
  '(lisp-plus-surface0:define-admission-contract cl-user::*s1-contract*
    :contract-id :surface1/selftest
    :contract-version 1
    :accepted-clauses ((:verified-judged-claim))
    :proposition-relation :exact-normalized-equality
    :receiver-accessibility :required
    :retain (:contract-snapshot :support-identity :support-basis :source-basis)))

(format t "~&LANGUAGE SURFACE /1 — CANDIDATE /0 — SELFTEST~%")
(format t "SBCL ~A · grammar v~D · procedure v~D · policy v~D~%"
        (lisp-implementation-version)
        (s1 expansion-grammar-version)
        (s1 expansion-procedure-version)
        (s1 expansion-policy-version))

;;; ==================================================================
(section "A. LOAD GRAPH AND LAYER IDENTITY")

(ok "A1 Surface /1 loaded with Surface /0 ABSENT — it loads CD/0 only"
    cl-user::*surface0-absent-after-surface1-load*)
(ok "A2 Surface /0 is present now, loaded separately as a client"
    (and (find-package '#:lisp-plus-surface0) t))
(ok "A3 grammar, procedure and policy identities are three DISTINCT identifiers"
    (and (not (same (s1 expansion-grammar-identity) (s1 expansion-procedure-identity)))
         (not (same (s1 expansion-procedure-identity) (s1 expansion-policy-identity)))
         (not (same (s1 expansion-grammar-identity) (s1 expansion-policy-identity)))))
(ok "A4 every layer identity is a CD/0 IDENTIFIER datum, never a host symbol"
    (every (lambda (d) (cd0 identifier-datum-p d))
           (list (s1 expansion-grammar-identity)
                 (s1 expansion-procedure-identity)
                 (s1 expansion-policy-identity))))
;;; ERRATA 0.3 (F-7).  The label states an EQUALITY; Candidate /0's code stated
;;; non-nil-ness of a plausible shape — `(and (integerp n) (plusp n))` — which
;;; an implementation returning 1 for every input passes.  The equality is now
;;; asserted against a length computed WITHOUT calling IDENTITY-OCTETS, over
;;; three data of visibly different sizes so a constant cannot satisfy it.
(ok "A5 IDENTITY-OCTETS reports the encoded octet length of the identity it is
        given — the unit every ceiling in this layer is denominated in"
    (let ((data (list (cd0 make-bytes-datum (cd0 canonical-octets (tag "x")))
                      (cd0 make-bytes-datum (cd0 canonical-octets (tag "x" "yy" "zzz")))
                      (cd0 make-bytes-datum
                           (cd0 canonical-octets (s1 encode-term *specimen*))))))
      (and (every (lambda (d) (= (s1 identity-octets d)
                                 (cd0 octets-length (cd0 canonical-octets d))))
                  data)
           ;; and the three answers are genuinely different numbers, so no
           ;; constant-returning implementation could have passed the above
           (= 3 (length (remove-duplicates (mapcar (lambda (d) (s1 identity-octets d))
                                                   data)))))))
(defparameter *probe-tag* (tag "identity" "probe"))
(defparameter *probe-req*
  (s1 request-expansion *specimen* :macroexpand-1 *probe-tag*))
(ok "A5b a minted request identity is a CD/0 BYTES datum, not a string"
    (cd0 bytes-datum-p (s1 expansion-request-identity *probe-req*)))
(ok "A6 there is NO surface-0-version anywhere in the exported surface"
    (null (remove-if-not
           (lambda (s) (search "SURFACE0" (symbol-name s)))
           (let (acc) (do-external-symbols (s '#:lisp-plus-surface1) (push s acc)) acc)))
    "Surface /0 declares no version; this layer must not mint one for it")

;;; ==================================================================
(section "B. THE REFUSAL CATALOGUE — one table, two derived lists, no flat list")

(defparameter *catalog* (s1 expansion-refusal-code-catalog))
(defparameter *protocol* (s1 expansion-protocol-refusal-codes))
(defparameter *integrity* (s1 expansion-integrity-alarm-codes))

(ok "B1 the two derived lists partition the catalogue exactly"
    (and (= (length *catalog*) (+ (length *protocol*) (length *integrity*)))
         (null (intersection *protocol* *integrity*))))
(ok "B2 every catalogue code is unique"
    (= (length *catalog*)
       (length (remove-duplicates (mapcar (lambda (e) (s1 refusal-catalog-entry-code e))
                                          *catalog*)))))
(ok "B3 every entry declares a class, a phase and a reachability"
    (every (lambda (e) (and (member (s1 refusal-catalog-entry-class e)
                                    '(:protocol-refusal :integrity-alarm))
                            (member (s1 refusal-catalog-entry-phase e)
                                    '(:request :perform :receipt))
                            (member (s1 refusal-catalog-entry-reachability e)
                                    '(:public-api :public-api-in-a-stub-image
                                      :unreachable-under-this-policy
                                      :internal-planted-fault-only))))
           *catalog*))
(ok "B4 the two deleted false affordances are ABSENT and stay absent"
    (and (null (assoc :construct-package-absent *catalog*))
         (null (assoc :construct-symbol-absent *catalog*)))
    "no caller can reach a package lookup that already matched on that package's name")
(ok "B5 no FORBIDDEN VOCABULARY word appears in any code, class or phase name"
    (notany (lambda (e)
              (let ((s (string-upcase (format nil "~S" e))))
                (some (lambda (w) (search w s))
                      '("REPAIR" "PRESERV" "EQUIVALEN" "NORMALIZ" "CORRECT"
                        "IMPROVE" "HYGIEN" "SAME-MEANING" "FAITHFUL" "PORTABLE"
                        "VERIFIED" "SOUND"))))
            (mapcar (lambda (e) (list (s1 refusal-catalog-entry-code e)
                                      (s1 refusal-catalog-entry-class e)
                                      (s1 refusal-catalog-entry-phase e)))
                    *catalog*)))
(ok "B6 the DISPOSITIONS name the operation that ran, with no adverb"
    (let ((d (mapcar (lambda (op)
                       (s1 expansion-receipt-disposition
                           (s1 perform-expansion
                               (s1 request-expansion *specimen* op (tag "disp" (string op))))))
                     (s1 expansion-operations))))
      (equal d '(:macroexpanded-one-step :macroexpanded-repeatedly))))

;;; ==================================================================
(section "C. THE TERM GRAMMAR — what it represents, and what it refuses")

(ok "C1 the term inventory is exactly four kinds"
    (equal (s1 term-kinds) '("SYMBOL" "INTEGER" "STRING" "LIST")))
(ok "C2 a symbol encodes as an identifier of package-name / symbol-name"
    (let ((d (s1 encode-term 'cl:car)))
      (and (cd0 record-datum-p d)
           (same (cd0 record-datum-ref d (cd0 make-identifier-datum '("TERM") '("VALUE")))
                 (cd0 make-identifier-datum '("COMMON-LISP") '("CAR"))))))
;;; ERRATA 0.3 (F-3).  Candidate /0 wrote `(same (encode-term 'nil)
;;; (encode-term '()))`.  In Common Lisp 'NIL and '() READ TO THE SAME OBJECT,
;;; so that compared a pure function's output with itself: it could not fail and
;;; it tested nothing the label claimed.  The claim is true, and the way to
;;; assert it is to BUILD the datum the label names and compare.
(ok "C3 NIL encodes as the SYMBOL COMMON-LISP:NIL — the host does not separate
        the empty list from the symbol, and the grammar does not pretend to"
    (let ((expected (cd0 make-record-datum
                         (list (cd0 make-record-entry
                                    (cd0 make-identifier-datum '("TERM") '("KIND"))
                                    (cd0 make-identifier-datum '("TERMKIND") '("SYMBOL")))
                               (cd0 make-record-entry
                                    (cd0 make-identifier-datum '("TERM") '("VALUE"))
                                    (cd0 make-identifier-datum '("COMMON-LISP") '("NIL")))))))
      (and (same (s1 encode-term 'nil) expected)
           ;; and the empty list, which the host does not distinguish, lands on
           ;; the SAME datum — stated as a consequence, not as the evidence
           (same (s1 encode-term '()) expected))))
(ok "C4 integers, strings and lists each encode"
    (and (cd0 record-datum-p (s1 encode-term 42))
         (cd0 record-datum-p (s1 encode-term "text"))
         (cd0 record-datum-p (s1 encode-term '(1 "two" three)))))
(ok "C5 case is preserved exactly — |lower| and LOWER are different terms"
    (not (same (s1 encode-term (intern "lower" '#:cl-user))
               (s1 encode-term (intern "LOWER" '#:cl-user)))))
;;; ERRATA 0.3 (F-13) — LABEL NARROWED.  Candidate /0 said "every encoded
;;; specimen term", and checked ONE: *SPECIMEN*.  The label now names the one.
(ok "C6 the encoding of *SPECIMEN*, the one control term this suite carries
        throughout, DECODES — construction is not enough, because CD/0 enforces
        max-depth on decode and not at construction"
    (let ((d (s1 encode-term *specimen*)))
      (same d (cd0 decode-exact (cd0 canonical-octets d)))))

;;; ==================================================================
(section "D. DOOR 1 — describes; does not expand")

(ok "D1 a request mints an identity, a source datum and a source identity"
    (and (s1 expansion-request-p *probe-req*)
         (cd0 bytes-datum-p (s1 expansion-request-identity *probe-req*))
         (cd0 record-datum-p (s1 expansion-request-source-form-datum *probe-req*))
         (cd0 bytes-datum-p (s1 expansion-request-source-form-identity *probe-req*))))
(ok "D2 the source-form identity is the identity OF the stored source datum"
    (same (s1 expansion-request-source-form-identity *probe-req*)
          (cd0 make-bytes-datum
               (cd0 canonical-octets (s1 expansion-request-source-form-datum *probe-req*)))))
(ok "D3 DOOR 1 ACCEPTS a head that names no known construct —
        a request that can never be performed is still a lawful request"
    (s1 expansion-request-p
        (s1 request-expansion '(cl:list 1 2) :macroexpand-1 (tag "d3"))))
(ok "D4 ... and its construct identity is ABSENT rather than invented"
    (null (s1 expansion-request-construct-identity
              (s1 request-expansion '(cl:list 1 2) :macroexpand-1 (tag "d4")))))
(ok "D5 a non-cons source form refuses :SOURCE-FORM-NOT-A-CALL"
    (eq :source-form-not-a-call
        (s1 expansion-refusal-code
            (refusal-of (lambda () (s1 request-expansion 7 :macroexpand-1 (tag "d5")))))))
(ok "D6 a non-symbol head refuses :SOURCE-FORM-HEAD-NOT-A-SYMBOL"
    (eq :source-form-head-not-a-symbol
        (s1 expansion-refusal-code
            (refusal-of (lambda () (s1 request-expansion '((1) 2) :macroexpand-1 (tag "d6")))))))
(ok "D7 an undeclared operation refuses :OPERATION-NOT-DECLARED
        — there is no :MACROEXPAND-ALL and this layer offers no code walker"
    (eq :operation-not-declared
        (s1 expansion-refusal-code
            (refusal-of (lambda () (s1 request-expansion *specimen* :macroexpand-all (tag "d7")))))))
(ok "D8 a non-identifier occurrence tag refuses — there is NO default tag"
    (eq :occurrence-tag-not-identifier
        (s1 expansion-refusal-code
            (refusal-of (lambda () (s1 request-expansion *specimen* :macroexpand-1 "a string"))))))
(ok "D9 a gensym in the SOURCE refuses at DOOR 1, upstream reason preserved"
    (let ((r (refusal-of (lambda ()
                           (s1 request-expansion (list 'cl:quote (gensym "G"))
                               :macroexpand-1 (tag "d9"))))))
      (and (eq :source-term-unrepresentable (s1 expansion-refusal-code r))
           (string= "UNINTERNED-SYMBOL" (s1 expansion-refusal-upstream-code r))
           (string= "term-encode" (s1 expansion-refusal-upstream-stage r)))))
(ok "D10 an improper list in the source refuses, upstream reason preserved"
    (let ((r (refusal-of (lambda ()
                           (s1 request-expansion (cons 'cl:car (cons 1 2))
                               :macroexpand-1 (tag "d10"))))))
      (and (eq :source-term-unrepresentable (s1 expansion-refusal-code r))
           (string= "IMPROPER-LIST" (s1 expansion-refusal-upstream-code r)))))
(ok "D11 a host object with no term kind refuses (a character)"
    (let ((r (refusal-of (lambda ()
                           (s1 request-expansion (list 'cl:quote #\x)
                               :macroexpand-1 (tag "d11"))))))
      (and (eq :source-term-unrepresentable (s1 expansion-refusal-code r))
           (string= "NO-TERM-KIND" (s1 expansion-refusal-upstream-code r)))))
(ok "D12 a float refuses too — no printed-representation escape hatch exists"
    (eq :source-term-unrepresentable
        (s1 expansion-refusal-code
            (refusal-of (lambda () (s1 request-expansion (list 'cl:quote 1.5)
                                       :macroexpand-1 (tag "d12")))))))
(ok "D13 a source form deeper than the declared ceiling refuses"
    (let ((deep (let ((f 'cl:t))
                  (dotimes (i (+ 2 (s1 expansion-policy-max-source-depth))) (setf f (list f)))
                  (cons 'cl:quote (list f)))))
      (eq :source-depth-exceeded
          (s1 expansion-refusal-code
              (refusal-of (lambda () (s1 request-expansion deep :macroexpand-1 (tag "d13"))))))))
(ok "D14 a source form with more nodes than the ceiling refuses"
    (let ((wide (cons 'cl:quote (list (make-list (+ 2 (s1 expansion-policy-max-source-nodes))
                                                 :initial-element 'cl:t)))))
      (eq :source-nodes-exceeded
          (s1 expansion-refusal-code
              (refusal-of (lambda () (s1 request-expansion wide :macroexpand-1 (tag "d14"))))))))
(ok "D15 an encoded source term over the octet ceiling refuses"
    (let ((big (list 'cl:quote (make-string (1+ (s1 expansion-policy-max-term-octets))
                                            :initial-element #\a))))
      (eq :source-term-octets-exceeded
          (s1 expansion-refusal-code
              (refusal-of (lambda () (s1 request-expansion big :macroexpand-1 (tag "d15"))))))))
(ok "D16 the OPERATION is committed into the request identity, not inferred"
    (not (same (s1 expansion-request-identity
                   (s1 request-expansion *specimen* :macroexpand-1 (tag "same")))
               (s1 expansion-request-identity
                   (s1 request-expansion *specimen* :macroexpand (tag "same"))))))

;;; ==================================================================
(section "E. DOOR 2 — meets the image, and accounts for what it found")

(defparameter *r1* (s1 request-expansion *specimen* :macroexpand-1 (tag "e" "one")))
(defparameter *receipt* nil)
(defparameter *expanded* nil)
(defparameter *occ-id* nil)
(defparameter *occurrence* nil)
(multiple-value-setq (*receipt* *expanded* *occurrence*) (s1 perform-expansion *r1*))
(setf *occ-id* (s1 expansion-occurrence-identity *occurrence*))

(ok "E1 a completed expansion mints a receipt, an expanded form and a
        FIRST-CLASS OCCURRENCE OBJECT (errata 0.1, finding 3)"
    (and (s1 expansion-receipt-p *receipt*) (consp *expanded*)
         (s1 expansion-occurrence-p *occurrence*)
         (cd0 bytes-datum-p *occ-id*)))
(ok "E2 the expanded host form is EXACTLY what MACROEXPAND-1 returns"
    (equal *expanded* (macroexpand-1 *specimen* nil)))
(ok "E3 the receipt's expanded datum is the encoding of that exact form"
    (same (s1 expansion-receipt-expanded-form-datum *receipt*)
          (cd0 decode-exact (cd0 canonical-octets (s1 encode-term *expanded*)))))
(ok "E4 the receipt's source datum is the encoding of the exact source form"
    (same (s1 expansion-receipt-source-form-datum *receipt*)
          (cd0 decode-exact (cd0 canonical-octets (s1 encode-term *specimen*)))))
(ok "E5 both stored identities equal the identities of their stored data"
    (and (same (s1 expansion-receipt-source-form-identity *receipt*)
               (cd0 make-bytes-datum
                    (cd0 canonical-octets (s1 expansion-receipt-source-form-datum *receipt*))))
         (same (s1 expansion-receipt-expanded-form-identity *receipt*)
               (cd0 make-bytes-datum
                    (cd0 canonical-octets (s1 expansion-receipt-expanded-form-datum *receipt*))))))
(ok "E6 the receipt records the operation and the construct identity"
    (and (eq :macroexpand-1 (s1 expansion-receipt-operation *receipt*))
         (same (s1 expansion-receipt-construct-identity *receipt*)
               (s1 construct-identity-for "LISP-PLUS-SURFACE0" "DEFINE-ADMISSION-CONTRACT"))))
(ok "E7 the receipt carries the request and occurrence identities it was minted from"
    (and (same (s1 expansion-receipt-request-identity *receipt*)
               (s1 expansion-request-identity *r1*))
         (same (s1 expansion-receipt-occurrence-identity *receipt*) *occ-id*)))
;;; ERRATA 0.3 (D7) — THIS LABEL IS RETRACTED AND REPLACED.  It read: "procedure
;;; and policy versions come from the PACKAGE, not from a slot — a receipt
;;; cannot disagree with the package that minted it."  That was the DEFECT
;;; described as a virtue.  The accessors were constant functions that ignored
;;; the receipt entirely, so the receipt could not disagree only because it had
;;; nothing to disagree WITH; the stranger audit redefined the live version and
;;; watched an OLD receipt's reported version move beneath it.  The versions are
;;; now STORED at mint.  In an unchanged image they equal the package's — which
;;; is what this check asserts — and section P proves the two are no longer the
;;; same number by moving one of them.
(ok "E8 a receipt reports the grammar, procedure and policy versions STORED at
        mint; in an image that has not moved, those equal the package's"
    (and (eql (s1 expansion-receipt-grammar-version *receipt*) (s1 expansion-grammar-version))
         (eql (s1 expansion-receipt-procedure-version *receipt*) (s1 expansion-procedure-version))
         (eql (s1 expansion-receipt-policy-version *receipt*) (s1 expansion-policy-version))))
(ok "E9 the expansion CONTEXT records only what was SUPPLIED, and denies capture"
    (let ((ctx (s1 expansion-receipt-expansion-context *receipt*)))
      (and (same (cd0 record-datum-ref ctx (cd0 make-identifier-datum
                                            '("CONTEXT") '("SUPPLIED-LEXICAL-ENVIRONMENT")))
                 (cd0 make-identifier-datum '("lisp-plus-surface1" "environment") '("null")))
           (same (cd0 record-datum-ref ctx (cd0 make-identifier-datum
                                            '("CONTEXT") '("ENVIRONMENT-OBJECT-CAPTURED")))
                 (cd0 make-boolean-datum nil)))))
;;; ERRATA 0.3 (F-5) — LABEL NARROWED, SECOND CONJUNCT DELETED.  Candidate /0
;;; claimed the receipt identity was "stable" and demonstrated it by reading one
;;; READ-ONLY slot of one object twice and comparing the results — EQUAL-DATUM
;;; on a datum and itself, which cannot fail.  "Stable across what" was never
;;; stated.  The real stability work is in section I (I2/I3), across an
;;; intervening downstream evaluation, and it is done properly there.
(ok "E10 the whole receipt's own identity is a bytes datum"
    (cd0 bytes-datum-p (s1 expansion-receipt-identity *receipt*)))
(ok "E11 two SEPARATE requests with equal inputs give the SAME occurrence
        identity.  NOTE THE WORDING: Candidate /0 labelled this 'the same
        request performed twice', which it never was — it built a fresh
        equivalent request.  The same-object claim is E11b."
    (let ((again (s1 expansion-occurrence-identity
                     (nth-value 2 (s1 perform-expansion
                                      (s1 request-expansion *specimen* :macroexpand-1
                                          (tag "e" "one")))))))
      (same again *occ-id*)))
(ok "E11b the SAME REQUEST OBJECT performed twice gives the same occurrence
        identity — the claim E11 was mislabelled as making"
    (let ((a (s1 expansion-occurrence-identity (nth-value 2 (s1 perform-expansion *r1*))))
          (b (s1 expansion-occurrence-identity (nth-value 2 (s1 perform-expansion *r1*)))))
      (and (same a b) (same a *occ-id*))))
(ok "E12 a DIFFERENT occurrence tag gives a DIFFERENT occurrence identity"
    (let ((other (s1 expansion-occurrence-identity
                     (nth-value 2 (s1 perform-expansion
                                      (s1 request-expansion *specimen* :macroexpand-1
                                          (tag "e" "other")))))))
      (not (same other *occ-id*))))
(ok "E13 an unknown head reaches DOOR 2 and refuses there, minting NOTHING"
    (let ((r (refusal-of (lambda ()
                           (s1 perform-expansion
                               (s1 request-expansion '(cl:list 1 2) :macroexpand-1 (tag "e13")))))))
      (and (eq :not-a-known-surface-construct (s1 expansion-refusal-code r))
           (eq :perform (s1 expansion-refusal-phase r)))))
(ok "E14 TRY-PERFORM returns THREE values on BOTH branches, so a refusal
        cannot be destructured as a success"
    (and (= 3 (length (multiple-value-list (s1 try-perform-expansion *r1*))))
         (= 3 (length (multiple-value-list
                       (s1 try-perform-expansion
                           (s1 request-expansion '(cl:list 1) :macroexpand-1 (tag "e14"))))))))

;;; ==================================================================
(section "F. THE OPERATION DISTINCTION — one step vs repeated")

(defparameter *full-receipt*
  (s1 perform-expansion (s1 request-expansion *specimen* :macroexpand (tag "f" "full"))))

(ok "F1 for this specimen the two operations produce the SAME expanded form,
        because the expansion's head is PROGN, a special operator"
    (same (s1 expansion-receipt-expanded-form-identity *receipt*)
          (s1 expansion-receipt-expanded-form-identity *full-receipt*)))
(ok "F2 ... and the receipts are NEVERTHELESS DIFFERENT, because the operation
        is part of the account rather than derived from the result"
    (and (not (same (s1 expansion-receipt-identity *receipt*)
                    (s1 expansion-receipt-identity *full-receipt*)))
         (not (eq (s1 expansion-receipt-disposition *receipt*)
                  (s1 expansion-receipt-disposition *full-receipt*)))))
(ok "F3 the mechanism is checkable: the expansion's head is not a macro"
    (and (eq 'cl:progn (car (macroexpand-1 *specimen* nil)))
         (null (macro-function 'cl:progn))))

;;; The control forms DO differ, because HANDLER-CASE is itself a macro.
(defparameter *control-form*
  '(lisp-plus-surface0:derive-case (cl-user::c cl-user::r)
    (lisp-plus-slice1:derive :schema-name :x)
    (:granted cl-user::c) (:refused (cl-user::e) cl-user::e)))

(ok "F4 DERIVE-CASE's one-step expansion is accounted for cleanly"
    (s1 expansion-receipt-p
        (s1 perform-expansion
            (s1 request-expansion *control-form* :macroexpand-1 (tag "f4")))))
(ok "F5 ... and its FULL expansion is REFUSED, because HANDLER-CASE is a host
        macro.  ERRATA 0.1 CORRECTS THE CODE THIS CHECK USED TO ASSERT:
        Candidate /0 claimed :EXPANDED-TERM-UNREPRESENTABLE / UNINTERNED-SYMBOL.
        MEASURED, that expansion carries BOTH disqualifying properties — 3 conses
        reachable by more than one path AND 13 uninterned symbols — and since
        the global sharing check now runs first, the reported code is the
        SHARING one.  Reporting the first check that fires is correct; claiming
        the other code was not."
    (let ((r (refusal-of (lambda ()
                           (s1 perform-expansion
                               (s1 request-expansion *control-form* :macroexpand (tag "f5")))))))
      (and (eq :expanded-term-shared-structure (s1 expansion-refusal-code r))
           (string= "SHARED-OR-CIRCULAR-STRUCTURE" (s1 expansion-refusal-upstream-code r)))))
(ok "F5b ... and BOTH disqualifying properties are exhibited, not merely the one
        the refusal happened to name first"
    (let* ((full (macroexpand *control-form* nil))
           (atoms (labels ((a (f) (if (consp f) (append (a (car f)) (a (cdr f))) (list f))))
                    (a full)))
           (gensyms (remove-if #'symbol-package (remove-if-not #'symbolp atoms))))
      (and (plusp (length gensyms))
           ;; and a gensym-bearing expansion with NO sharing lands on the OTHER
           ;; code, so the two are genuinely distinguished rather than merged
           (let ((r (refusal-of
                     (lambda ()
                       (s1 perform-expansion
                           (s1 request-expansion
                               '(lisp-plus-surface0:derive-case (cl-user::c cl-user::r)
                                 (lisp-plus-slice1:derive :schema-name :x)
                                 (:granted cl-user::c) (:refused (nil) 1))
                               :macroexpand-1 (tag "f5b")))))))
             (eq :expanded-term-unrepresentable (s1 expansion-refusal-code r))))))
(ok "F6 the two operations genuinely differ for that form at the host level"
    (not (equal (macroexpand-1 *control-form* nil) (macroexpand *control-form* nil))))

;;; ==================================================================
(section "G. THE NON-DETERMINISM REFUSAL — the reason the boundary exists")
;;;
;;; Surface /0's %PARSE-ARMS accepts `(:refused (nil) ...)`: its guard omits the
;;; non-NIL conjunct that its sibling guard for the claim/receipt variables has.
;;; The dormant `(or refused-var (gensym "COND"))` therefore fires, and the SAME
;;; SOURCE FORM EXPANDS DIFFERENTLY EACH TIME.
;;;
;;; SURFACE /1 DOES NOT REPAIR THIS.  The observer accounts for the expansion
;;; that exists; it must never manufacture a friendlier one and then certify its
;;; own handiwork.
;;;
;;; ERRATA 0.3 (F-17) — A RETRACTED SENTENCE STOOD HERE AND IS DELETED.  It read:
;;; "It refuses, and the refusal is the point: a receipt for a non-deterministic
;;; expansion would be an account that could not be true twice."  ERRATA 0.1 §5
;;; declares that sentence WRONG and states the replacement rationale — the
;;; refusal is about REPRESENTABILITY, not determinism; a gensym-bearing
;;; expansion refuses because the term grammar does not name uninterned symbols,
;;; and it would refuse a perfectly deterministic expansion carrying one.  N8
;;; below executes the replacement rationale.  The stranger audit found the
;;; retracted sentence still live in this file, twenty lines above the check
;;; that contradicts it.

(defparameter *nondet-form*
  '(lisp-plus-surface0:derive-case (cl-user::c cl-user::r)
    (lisp-plus-slice1:derive :schema-name :x)
    (:granted cl-user::c) (:refused (nil) 1)))

;;; ERRATA 0.3 (F-4) — G4 IS DELETED, MERGED INTO G1.  The two checks carried
;;; BYTE-IDENTICAL expressions and two different labels; a mechanical scan of
;;; every OK form in the file found exactly one such pair, and this was it.  G4's
;;; label — "Surface /0 IS UNMODIFIED BY THIS SUITE" — is a claim about the
;;; SUITE'S CONDUCT, and the expression under it re-ran G1.
;;;
;;; The suite-conduct fact is TRUE and is stated here as PROSE, at its real
;;; size: this file loads Surface /0 as a client and never redefines anything in
;;; it, and the surviving check below is the evidence that bears on it —
;;; if the suite HAD made the expansion deterministic, G1 would go red.  One
;;; datum, counted once, with the label it can carry.
(ok "G1 the host really does expand that form differently twice — the defect is
        reported, not repaired, and this same datum is what would go red if the
        suite had quietly made Surface /0 deterministic"
    (not (equal (macroexpand-1 *nondet-form* nil) (macroexpand-1 *nondet-form* nil))))
(ok "G2 Surface /1 REFUSES it at ONE-STEP expansion, not merely at full expansion"
    (let ((r (refusal-of (lambda ()
                           (s1 perform-expansion
                               (s1 request-expansion *nondet-form* :macroexpand-1 (tag "g2")))))))
      (and (eq :expanded-term-unrepresentable (s1 expansion-refusal-code r))
           (string= "UNINTERNED-SYMBOL" (s1 expansion-refusal-upstream-code r)))))
(ok "G3 the refusal mints NO occurrence and NO receipt — the objects do not come
        into existence, they are not nil-valued"
    (multiple-value-bind (rc ex rf)
        (s1 try-perform-expansion
            (s1 request-expansion *nondet-form* :macroexpand-1 (tag "g3")))
      (and (null rc) (null ex) (s1 expansion-refusal-p (observe rf)))))

;;; ==================================================================
(section "H. DISCRIMINATION — a changed source changes the account")

(defparameter *specimen-v2*
  '(lisp-plus-surface0:define-admission-contract cl-user::*s1-contract*
    :contract-id :surface1/selftest
    :contract-version 2
    :accepted-clauses ((:verified-judged-claim))
    :proposition-relation :exact-normalized-equality
    :receiver-accessibility :required
    :retain (:contract-snapshot :support-identity :support-basis :source-basis)))

(defparameter *receipt-v2*
  (s1 perform-expansion (s1 request-expansion *specimen-v2* :macroexpand-1 (tag "e" "one"))))

(ok "H1 a changed source form changes the SOURCE identity"
    (not (same (s1 expansion-receipt-source-form-identity *receipt*)
               (s1 expansion-receipt-source-form-identity *receipt-v2*))))
(ok "H2 ... and changes the EXPANDED identity"
    (not (same (s1 expansion-receipt-expanded-form-identity *receipt*)
               (s1 expansion-receipt-expanded-form-identity *receipt-v2*))))
(ok "H3 ... and therefore changes the OCCURRENCE identity, even with the SAME tag"
    (not (same (s1 expansion-receipt-occurrence-identity *receipt*)
               (s1 expansion-receipt-occurrence-identity *receipt-v2*))))
(ok "H4 ... and the RECEIPT identity"
    (not (same (s1 expansion-receipt-identity *receipt*)
               (s1 expansion-receipt-identity *receipt-v2*))))
(ok "H5 a one-character difference in a symbol NAME is discriminated"
    (not (same (s1 encode-term '(cl-user::abc)) (s1 encode-term '(cl-user::abd)))))

;;; ==================================================================
(section "I. NON-PROMOTION — later handling flows nowhere backward")
;;;
;;; The expanded form is EVALUATED here, producing a REAL Slice /2 admission
;;; contract through Slice /2's own public constructor.  That is a genuine
;;; downstream success.  The receipt must be byte-identical afterwards and must
;;; still claim exactly what it claimed before: what form became what other form.

(defparameter *receipt-octets-before*
  (cd0 octets-to-hex (cd0 canonical-octets (s1 expansion-receipt-identity *receipt*))))
(defparameter *expanded-octets-before*
  (cd0 octets-to-hex (cd0 canonical-octets (s1 expansion-receipt-expanded-form-datum *receipt*))))

(defparameter *evaluated* (eval *expanded*))
(defparameter *made-contract* (symbol-value 'cl-user::*s1-contract*))

(ok "I1 evaluating the expansion really does produce a Slice /2 contract object"
    (and *evaluated* (lisp-plus-slice2:support-admission-contract-p *made-contract*)))
(ok "I2 the receipt identity is byte-identical after that downstream success"
    (string= *receipt-octets-before*
             (cd0 octets-to-hex (cd0 canonical-octets (s1 expansion-receipt-identity *receipt*)))))
(ok "I3 the stored expanded datum is byte-identical after it"
    (string= *expanded-octets-before*
             (cd0 octets-to-hex
                  (cd0 canonical-octets (s1 expansion-receipt-expanded-form-datum *receipt*)))))
;;; ERRATA 0.3 (F-2) — THE SLOT LIST IS NOW MEASURED, NOT WRITTEN.
;;;
;;; Candidate /0 ran NOTANY over a QUOTED LIST OF TEN UNINTERNED SYMBOLS the
;;; author had typed by hand.  It asked whether a constant contained the
;;; substring "CONTRACT"; it could not fail unless someone edited the constant,
;;; and it could not notice a new receipt slot however named.  It was also
;;; already STALE by two fields — it omitted OCCURRENCE, the slot ERRATA 0.1
;;; ADDED, and CONSTRUCT-IDENTITY — so a check written to prove a negative about
;;; the receipt's fields did not enumerate two of them.
;;;
;;; The census is now read off the LIVE CLASS.  Two assertions ride it: the
;;; negative the label states, and the full slot census, so that a slot added by
;;; a later erratum turns this check red instead of sailing past it.
(defparameter *receipt-slots*
  (mapcar #'sb-mop:slot-definition-name
          (sb-mop:class-slots (find-class 'lisp-plus-surface1::expansion-receipt))))

(ok "I4 the receipt gained NO field naming the object that evaluation produced
        — asserted over the LIVE slot census, and the census itself is pinned so
        a new slot cannot arrive unseen"
    (and (notany (lambda (slot) (search "CONTRACT" (symbol-name slot))) *receipt-slots*)
         (equal (mapcar #'symbol-name *receipt-slots*)
                '("IDENTITY" "REQUEST-IDENTITY" "OCCURRENCE" "OCCURRENCE-IDENTITY"
                  "SOURCE-FORM-DATUM" "SOURCE-FORM-IDENTITY"
                  "EXPANDED-FORM-DATUM" "EXPANDED-FORM-IDENTITY"
                  "OPERATION" "CONSTRUCT-IDENTITY" "EXPANSION-CONTEXT" "DISPOSITION"
                  ;; ERRATA 0.3 (D7) — the three the version repair added
                  "GRAMMAR-VERSION" "PROCEDURE-VERSION" "POLICY-VERSION")))
    (format nil "live receipt slots: ~S" (mapcar #'symbol-name *receipt-slots*)))
(ok "I5 the disposition is unchanged by downstream success"
    (eq :macroexpanded-one-step (s1 expansion-receipt-disposition *receipt*)))
;;; ERRATA 0.3 (F-12) — TWO DEFECTS REPAIRED IN ONE CHECK.
;;;
;;; (1) The label says "a FAILING downstream evaluation", and Candidate /0
;;;     wrapped the evaluation in `(handler-case … (error () nil))` while
;;;     ASSERTING NOTHING ABOUT THE FAILURE.  If Slice /2 had silently ACCEPTED
;;;     the form, the check still passed — the very hypothesis it names would
;;;     have been false with no effect on the verdict.  The specific Slice /2
;;;     condition is now caught by type and its arrival is asserted.
;;; (2) The receipt whose octets were compared was minted from the request
;;;     tagged `i6`, while the form actually evaluated came from a SECOND,
;;;     DISTINCT request tagged `i6b`.  The comparison was between a receipt and
;;;     itself across an event that never touched it.  ONE receipt is minted
;;;     here now, and the form evaluated is ITS expansion.
(ok "I6 a FAILING downstream evaluation leaves THE RECEIPT WHOSE FORM FAILED
        equally unchanged — and the failure is asserted, by condition type, not
        assumed"
    (multiple-value-bind (bad-receipt bad-expanded)
        (s1 perform-expansion
            (s1 request-expansion
                '(lisp-plus-surface0:define-admission-contract cl-user::*s1-bad*
                  :contract-id :surface1/bad :contract-version 99
                  :accepted-clauses ((:no-such-clause-family))
                  :proposition-relation :exact-normalized-equality
                  :receiver-accessibility :required
                  :retain (:contract-snapshot :support-identity :support-basis :source-basis))
                :macroexpand-1 (tag "i6")))
      (let* ((id-before (cd0 octets-to-hex
                             (cd0 canonical-octets (s1 expansion-receipt-identity bad-receipt))))
             (datum-before (cd0 octets-to-hex
                                (cd0 canonical-octets
                                     (s1 expansion-receipt-expanded-form-datum bad-receipt))))
             ;; the ONE evaluation, of THIS receipt's own expansion
             (slice2-refused (handler-case (progn (eval bad-expanded) nil)
                               (lisp-plus-slice2:admission-contract-error () t))))
        (and slice2-refused
             (string= id-before
                      (cd0 octets-to-hex
                           (cd0 canonical-octets (s1 expansion-receipt-identity bad-receipt))))
             (string= datum-before
                      (cd0 octets-to-hex
                           (cd0 canonical-octets
                                (s1 expansion-receipt-expanded-form-datum bad-receipt))))
             (eq :macroexpanded-one-step (s1 expansion-receipt-disposition bad-receipt)))))
    "an unknown clause family is Slice /2's refusal to make; the receipt is untouched either way")

;;; ==================================================================
(section "J. SURFACE /0'S OWN REFUSAL ESCAPES, AND MINTS NOTHING HERE")

(defparameter *malformed*
  '(lisp-plus-surface0:define-admission-contract cl-user::*s1-x* :contract-id :only))

(ok "J1 a malformed construct signals SURFACE /0's condition, not Surface /1's"
    (handler-case (progn (s1 perform-expansion
                             (s1 request-expansion *malformed* :macroexpand-1 (tag "j1")))
                         nil)
      (lisp-plus-surface1:expansion-refused () nil)
      (lisp-plus-surface0:surface-syntax-refused () t)))
(ok "J2 ... carrying Surface /0's OWN reason keyword, unwrapped and unreclassified"
    (handler-case (progn (s1 perform-expansion
                             (s1 request-expansion *malformed* :macroexpand-1 (tag "j2")))
                         nil)
      (lisp-plus-surface0:surface-syntax-refused (c)
        (eq :missing-field (lisp-plus-surface0:surface-syntax-refused-reason c)))))
(ok "J3 TRY-PERFORM does NOT convert it either — the twin catches only this
        layer's refusals, never another layer's verdict"
    (handler-case (progn (s1 try-perform-expansion
                             (s1 request-expansion *malformed* :macroexpand-1 (tag "j3")))
                         nil)
      (lisp-plus-surface0:surface-syntax-refused () t)))

;;; ==================================================================
(section "K. PLANTED FAULTS — a gate that has never fired is untested")

(ok "K1 with no fault bound, the same expansion is green (the teeth are not stuck on)"
    (s1 expansion-receipt-p
        (s1 perform-expansion (s1 request-expansion *specimen* :macroexpand-1 (tag "k1")))))
(ok "K2 a wrong stored SOURCE identity produces NO receipt"
    (let ((r (let ((lisp-plus-surface1::*%fault-source-identity*
                     (cd0 make-bytes-datum (cd0 canonical-octets (tag "wrong")))))
               (refusal-of (lambda () (s1 perform-expansion
                                          (s1 request-expansion *specimen* :macroexpand-1
                                              (tag "k2"))))))))
      (eq :source-identity-projection-mismatch (s1 expansion-refusal-code r))))
(ok "K3 a wrong stored EXPANDED identity produces NO receipt"
    (let ((r (let ((lisp-plus-surface1::*%fault-expanded-identity*
                     (cd0 make-bytes-datum (cd0 canonical-octets (tag "wrong")))))
               (refusal-of (lambda () (s1 perform-expansion
                                          (s1 request-expansion *specimen* :macroexpand-1
                                              (tag "k3"))))))))
      (eq :expanded-identity-projection-mismatch (s1 expansion-refusal-code r))))
(ok "K4 an altered procedure version produces NO receipt"
    (let ((r (let ((lisp-plus-surface1::*%fault-procedure-version* 99))
               (refusal-of (lambda () (s1 perform-expansion
                                          (s1 request-expansion *specimen* :macroexpand-1
                                              (tag "k4"))))))))
      (eq :procedure-version-mismatch (s1 expansion-refusal-code r))))
(ok "K5 after the faults unwind, the layer is green again"
    (s1 expansion-receipt-p
        (s1 perform-expansion (s1 request-expansion *specimen* :macroexpand-1 (tag "k5")))))

;;; ==================================================================
(section "L. IMMUTABILITY AND THE ABSENT CONSTRUCTORS")

(ok "L1 no public constructor mints a request, a receipt or a refusal"
    (notany (lambda (n) (eq :external (nth-value 1 (find-symbol n '#:lisp-plus-surface1))))
            '("MAKE-EXPANSION-REQUEST" "MAKE-EXPANSION-RECEIPT" "MAKE-EXPANSION-REFUSAL"
              "%MAKE-REQUEST" "%MAKE-RECEIPT" "%MAKE-REFUSAL")))
;;; ERRATA 0.3 (F-9) — THE FOURTH MINTED OBJECT JOINS THE ENUMERATION.  The
;;; label said "any minted object" and named three: request, receipt, refusal.
;;; The OCCURRENCE — the fourth, introduced by ERRATA 0.1 finding 3 — was not
;;; enumerated.  It carries `(:copier nil)` like its siblings, so the claim held;
;;; the CHECK simply did not cover the object the label promised.
(ok "L2 no copier is exported for any minted object — request, receipt, refusal
        AND occurrence, which is all four of them"
    (notany (lambda (n) (find-symbol n '#:lisp-plus-surface1))
            '("COPY-EXPANSION-REQUEST" "COPY-EXPANSION-RECEIPT" "COPY-EXPANSION-REFUSAL"
              "COPY-EXPANSION-OCCURRENCE")))

;;; ERRATA 0.3 (F-10) — LABEL NARROWED TO WHAT THE INSTRUMENT MEASURES.
;;; Candidate /0 claimed "no setter OF ANY KIND" and measured a SUBSTRING SCAN
;;; over external symbol NAMES.  A `(setf foo)` function, a DEFSETF or a setf
;;; expander carries no such name and would be invisible to it, so the
;;; instrument could not establish the "of any kind".
;;;
;;; PROSE, carrying the wider claim at its real source: every slot of every
;;; minted structure in surface1.lisp is declared `:read-only t`, and SBCL
;;; defines no setf expander for a read-only structure slot.  That is where the
;;; immutability actually lives.  It is a property of the DEFSTRUCT forms, read
;;; from the source, not something this scan measures — and saying so is the
;;; difference between a claim with an owner and a claim with a proxy.
(ok "L3 no EXTERNAL SYMBOL NAME in the exported surface names a SET-style
        mutator — a name scan, and only a name scan"
    (let (acc) (do-external-symbols (s '#:lisp-plus-surface1) (push (symbol-name s) acc))
         (notany (lambda (n) (or (search "SET-" n) (search "-SET" n))) acc)))

;;; EXPORT CENSUS, reconciled BOTH WAYS.  A declared export that names nothing is
;;; a false affordance; a live definition nobody declared is an accidental
;;; surface.  NOTE the third predicate: a CONDITION CLASS is neither FBOUNDP nor
;;; BOUNDP, and a census that checked only those two would report the layer's
;;; own condition type as dead.  The first draft of this check did exactly that.
(defparameter *declared* '())
(defparameter *dead* '())
(do-external-symbols (s '#:lisp-plus-surface1)
  (push s *declared*)
  (unless (or (fboundp s) (boundp s) (find-class s nil))
    (push s *dead*)))

(ok "L5 EXPORT CENSUS — every declared export names a live function, variable
        or condition class; nothing is a false affordance"
    (null *dead*) (format nil "~S" *dead*))
;;; ERRATA 0.3 — THE EXPORT COUNT IS RECONCILED AGAINST THE SOURCE, NOT TYPED.
;;;
;;; Candidate /0 wrote `(= 75 (length *declared*))`: a literal beside a
;;; measurement, which is a real check but a brittle one — it says nothing about
;;; WHERE the number should come from, and its only failure mode is "someone
;;; changed the package and did not edit this line."  ERRATA 0.3 moved the count
;;; to 80 and this check went red, correctly.
;;;
;;; The repair reads the `:export` clause out of package.lisp WITH THE HOST
;;; READER and compares the number of names DECLARED IN THE SOURCE TEXT against
;;; the number LIVE IN THE IMAGE.  Two independently sourced counts: a symbol
;;; exported by some later `export` call the defpackage never mentioned, or a
;;; declared name that failed to land, breaks the equality.  The live number is
;;; also printed, so the evidence carries the figure instead of hiding it.
(defparameter *source-export-count*
  (with-open-file (in (merge-pathnames "package.lisp" cl-user::*here*))
    (loop for form = (read in nil :eof)
          until (eq form :eof)
          when (and (consp form)
                    (string= (string (first form)) "DEFPACKAGE")
                    (string-equal (string (second form)) "LISP-PLUS-SURFACE1"))
            do (return (length (rest (find :export (cddr form)
                                           :key (lambda (c) (and (consp c) (first c))))))))))

(ok "L6 ... and the count is RECONCILED: the number of names package.lisp
        declares in its :EXPORT clause equals the number live in the image"
    (and (integerp *source-export-count*)
         (= *source-export-count* (length *declared*)))
    (format nil "source declares ~S · live ~D" *source-export-count* (length *declared*)))
(ok "L6b ... and the live export count is STATED, not left implicit"
    (= 80 (length *declared*))
    (format nil "declared ~D" (length *declared*)))
(ok "L7 ERRATA 0.1 — the catalogue accessor that was live-but-internal is now
        EXPORTED, and its four siblings still are"
    (every (lambda (n) (eq :external (nth-value 1 (find-symbol n '#:lisp-plus-surface1))))
           '("REFUSAL-CATALOG-ENTRY-CODE" "REFUSAL-CATALOG-ENTRY-CLASS"
             "REFUSAL-CATALOG-ENTRY-PHASE" "REFUSAL-CATALOG-ENTRY-NOTE"
             "REFUSAL-CATALOG-ENTRY-REACHABILITY")))
;;; ERRATA 0.3 (F-8) — L4 IS DELETED, MERGED HERE.  L4 asserted that
;;; EXPANSION-REQUEST-%HOST-FORM is not :EXTERNAL; this check asserts the symbol
;;; DOES NOT EXIST.  A symbol that does not exist cannot be external, so L4 was a
;;; logical consequence of this one — two counted checks over one fact.  L4's
;;; label also claimed "it never reaches a receipt", which neither expression
;;; tested; the accurate form of that claim is the ABSENCE below, and it is
;;; stated here where the predicate can carry it: there is no accessor to reach
;;; a receipt with, because there is no slot and no name.
(ok "L8 ... and the request no longer carries a caller-owned host form at all —
        the slot is GONE, not guarded, and no name for it exists to be exported,
        reached, or carried into a receipt"
    (null (find-symbol "EXPANSION-REQUEST-%HOST-FORM" '#:lisp-plus-surface1)))

;;; ERRATA 0.3 — SECTION M HAS MOVED TO THE FOOT OF THIS FILE.
;;;
;;; It measured refusal-code coverage HERE, before sections N and O had run —
;;; which is to say, before roughly a third of this suite's refusals had been
;;; produced at all.  That ordering was harmless only because the old check read
;;; a hand-written list instead of measuring anything.  A coverage measurement
;;; taken from live observation has to be taken LAST, and it now is.

;;; ==================================================================
(section "N. ERRATA 0.1 — THE SIX PROOF OBLIGATIONS, EACH EXECUTED")
;;;
;;; Candidate /0 retained the caller's own cons tree and handed it to the
;;; macroexpander.  The repair makes the IMMUTABLE CANONICAL SOURCE DATUM THE
;;; SINGLE AUTHORITY: Door 2 reconstructs a fresh private host form from that
;;; datum on every performance.  These six checks are the obligations that
;;; design must discharge, and they are executed rather than argued.

(defun mutable-source (version)
  (copy-tree
   (list (find-symbol "DEFINE-ADMISSION-CONTRACT" '#:lisp-plus-surface0)
         (intern "*S1-N*" '#:cl-user)
         :contract-id :surface1/n :contract-version version
         :accepted-clauses (list (list :verified-judged-claim))
         :proposition-relation :exact-normalized-equality
         :receiver-accessibility :required
         :retain (list :contract-snapshot))))

(ok "N1 CALLER MUTATION AFTER DOOR 1 CANNOT CHANGE WHAT DOOR 2 EXPANDS"
    (let* ((live (mutable-source 1))
           (pristine (copy-tree live))
           (req (s1 request-expansion live :macroexpand-1 (tag "n1"))))
      (setf (getf (cddr live) :contract-version) 999)
      (let ((rc (s1 perform-expansion req)))
        (and (same (s1 expansion-receipt-expanded-form-datum rc)
                   (s1 encode-term (macroexpand-1 pristine nil)))
             (not (same (s1 expansion-receipt-expanded-form-datum rc)
                        (s1 encode-term (macroexpand-1 live nil))))))))

(ok "N2 MUTATION BY ONE MACROEXPANSION CANNOT CHANGE A LATER PERFORMANCE of the
        same request — each performance gets its own freshly reconstructed form"
    (let* ((req (s1 request-expansion (mutable-source 1) :macroexpand-1 (tag "n2")))
           (a (nth-value 1 (s1 perform-expansion req)))
           (b (nth-value 1 (s1 perform-expansion req))))
      ;; destructively wreck the form the FIRST performance returned
      (setf (second a) :wrecked)
      (let ((c (nth-value 1 (s1 perform-expansion req))))
        (and (not (eq a b)) (not (eq b c))
             (equal b c)
             (not (equal a c))))))

(ok "N3 MUTABLE STRING LEAVES ARE ISOLATED"
    (let* ((str (copy-seq "alpha"))
           (src (list (find-symbol "DEFINE-ADMISSION-CONTRACT" '#:lisp-plus-surface0)
                      (intern "*S1-STR*" '#:cl-user)
                      :contract-id str :contract-version 1
                      :accepted-clauses (list (list :verified-judged-claim))
                      :proposition-relation :exact-normalized-equality
                      :receiver-accessibility :required
                      :retain (list :contract-snapshot)))
           (req (s1 request-expansion src :macroexpand-1 (tag "n3"))))
      (setf (char str 0) #\Z)
      (let* ((rc (s1 perform-expansion req))
             (back (s1 decode-term (s1 expansion-receipt-expanded-form-datum rc)))
             (rendered (format nil "~S" back)))
        ;; ERRATA 0.3 (F-14) — BOTH DIRECTIONS, the REPRODUCTION.lisp model.
        ;; Candidate /0 asserted only that the accounted expansion still CONTAINS
        ;; "alpha".  A leak that APPENDED rather than replaced — or one that left
        ;; both strings in the tree — would have passed.  The mutated text must
        ;; be ABSENT as well, and its absence is the half that bites.
        (and (search "alpha" rendered)
             (null (search "Zlpha" rendered))))))

(ok "N3b ... and the reconstructed string is a FRESH object each time, so a
        caller who mutates what it received cannot reach the next performance"
    (let* ((req (s1 request-expansion
                    (list (find-symbol "DEFINE-ADMISSION-CONTRACT" '#:lisp-plus-surface0)
                          (intern "*S1-STR2*" '#:cl-user)
                          :contract-id (copy-seq "beta") :contract-version 1
                          :accepted-clauses (list (list :verified-judged-claim))
                          :proposition-relation :exact-normalized-equality
                          :receiver-accessibility :required
                          :retain (list :contract-snapshot))
                    :macroexpand-1 (tag "n3b")))
           (a (s1 decode-term (s1 expansion-request-source-form-datum req)))
           (b (s1 decode-term (s1 expansion-request-source-form-datum req))))
      (and (equal a b) (not (eq (getf (cddr a) :contract-id)
                                (getf (cddr b) :contract-id))))))

(ok "N4 SHARED STRUCTURE IS REFUSED GLOBALLY — a shared subtree and two distinct
        equal copies no longer encode identically; the shared one refuses"
    (let* ((sub (list :verified-judged-claim))
           (shared (list sub sub))
           (copies (list (list :verified-judged-claim) (list :verified-judged-claim))))
      (and (handler-case (progn (s1 encode-term shared) nil) (error () t))
           (handler-case (progn (s1 encode-term copies) t) (error () nil)))))

;;; ERRATA 0.3 (F-11) — "SOME ERROR WAS SIGNALLED" IS NOT A REFUSAL.
;;; N4b, N4c, N7, O1 and O3 all accepted ANY error as proof of the specific
;;; refusal their labels named.  Each now asserts the CONDITION CLASS and the
;;; exact REASON, on the model N7b and O2 already set.  N4b keeps its
;;; STORAGE-CONDITION exclusion, which was the point of that check and was well
;;; made: the reason it must not be is that the refusal is designed, not that the
;;; image survived.
(ok "N4b ... and a CAR-POSITION CYCLE handed to the PUBLIC encoder REFUSES with
        the SHARED-OR-CIRCULAR-STRUCTURE reason, not with a control-stack death"
    (let ((x (list :a)))
      (setf (car x) x)
      (and (eq :shared-or-circular-structure
               (term-unrepresentable-reason (lambda () (s1 encode-term x))))
           ;; and the refusal is designed, not an exhausted image
           (handler-case (progn (s1 encode-term x) nil)
             (storage-condition () nil)
             (error () t)))))

(ok "N4c ... and a spine cycle refuses with the SAME reason — one measurement
        covers sharing and cycles alike"
    (let ((x (list :a)))
      (setf (cdr x) x)
      (eq :shared-or-circular-structure
          (term-unrepresentable-reason (lambda () (s1 encode-term x))))))

(ok "N5 THE STORED SOURCE DATUM IS EXACTLY THE SOURCE HANDED TO THE
        MACROEXPANDER — re-encoding the reconstruction reproduces the datum"
    (let* ((req (s1 request-expansion (mutable-source 3) :macroexpand-1 (tag "n5")))
           (d (s1 expansion-request-source-form-datum req))
           (round (s1 encode-term (s1 decode-term d))))
      (same d round)))

(ok "N5b ... and the expansion the receipt accounts for is the expansion OF THAT
        RECONSTRUCTION, computed independently here"
    (let* ((req (s1 request-expansion (mutable-source 4) :macroexpand-1 (tag "n5b")))
           (rc (s1 perform-expansion req))
           (independent (macroexpand-1
                         (s1 decode-term (s1 expansion-request-source-form-datum req))
                         nil)))
      (same (s1 expansion-receipt-expanded-form-datum rc)
            (s1 encode-term independent))))

(ok "N6 THE SAME REQUEST OBJECT CAN BE PERFORMED REPEATEDLY WITHOUT DRIFT"
    (let* ((req (s1 request-expansion (mutable-source 5) :macroexpand-1 (tag "n6")))
           (ids (loop repeat 5 collect
                      (s1 expansion-occurrence-identity
                          (nth-value 2 (s1 perform-expansion req))))))
      (every (lambda (i) (same i (first ids))) ids)))

(ok "N7 DECODE-TERM NEVER INTERNS — a symbol absent from the image refuses
        rather than being silently re-created"
    (let* ((pkg (or (find-package "S1-N7") (make-package "S1-N7" :use '())))
           (sym (intern "TRANSIENT" pkg))
           (d (s1 encode-term (list sym 1))))
      (unintern sym pkg)
      (and (null (find-symbol "TRANSIENT" pkg))
           ;; ERRATA 0.3 (F-11) — the reason is named, not merely "an error"
           (eq :symbol-absent-in-image
               (term-irreconstructible-reason (lambda () (s1 decode-term d))))
           ;; and it did NOT create the symbol on the way out
           (null (find-symbol "TRANSIENT" pkg)))))

(ok "N7b ... and the same absence reaches DOOR 2 as its own typed refusal"
    (let* ((pkg (or (find-package "S1-N7B") (make-package "S1-N7B" :use '())))
           (sym (intern "GONE" pkg))
           (req (s1 request-expansion (list sym 1) :macroexpand-1 (tag "n7b"))))
      (unintern sym pkg)
      (let ((r (refusal-of (lambda () (s1 perform-expansion req)))))
        (and r (eq :source-not-reconstructible (s1 expansion-refusal-code r))
             (string= "SYMBOL-ABSENT-IN-IMAGE" (s1 expansion-refusal-upstream-code r))))))

(ok "N8 THE NONDETERMINISM RATIONALE IS ABOUT REPRESENTABILITY, and the code
        says so: the refusal a gensym-bearing expansion lands under names the
        TERM GRAMMAR, not determinism"
    (let ((r (refusal-of
              (lambda ()
                (s1 perform-expansion
                    (s1 request-expansion
                        '(lisp-plus-surface0:derive-case (cl-user::c cl-user::r)
                          (lisp-plus-slice1:derive :schema-name :x)
                          (:granted cl-user::c) (:refused (nil) 1))
                        :macroexpand-1 (tag "n8")))))))
      (and (eq :expanded-term-unrepresentable (s1 expansion-refusal-code r))
           (string= "TermGrammar" (s1 expansion-refusal-upstream-category r))
           (string= "UNINTERNED-SYMBOL" (s1 expansion-refusal-upstream-code r)))))

;;; ==================================================================
(section "O. ERRATA 0.2 — HOME-PACKAGE IDENTITY AND THE EXECUTED ROUND TRIP")
;;;
;;; Errata 0.1 resolved reconstructed symbols with FIND-SYMBOL and required only
;;; that the symbol be FOUND.  FIND-SYMBOL answers ACCESSIBILITY; the grammar
;;; records HOME-PACKAGE IDENTITY.  Those are different questions, and asking
;;; the wrong one re-opened the false edge one layer down: a datum naming P/X
;;; reconstructed as Q:X, and a receipt was minted for it.

(ok "O1 an INHERITED symbol no longer substitutes for the one the datum names"
    (let* ((q (or (find-package "S1-O-Q")
                  (eval '(defpackage #:s1-o-q (:use) (:export #:x)))))
           (p (or (find-package "S1-O-P")
                  (eval '(defpackage #:s1-o-p (:use #:s1-o-q) (:shadow #:x)))))
           (px (find-symbol "X" p))
           (d (s1 encode-term (list px 1))))
      (declare (ignorable q))
      (unintern px p)
      ;; X is now reachable in P only by INHERITANCE from Q
      (and (eq :inherited (nth-value 1 (find-symbol "X" p)))
           ;; ERRATA 0.3 (F-11) — the reason is named.  "An error happened" would
           ;; be satisfied by a decoder that died for any other cause entirely.
           (eq :symbol-not-home-in-namespace
               (term-irreconstructible-reason (lambda () (s1 decode-term d)))))))

(ok "O2 ... and that refusal reaches DOOR 2 with its own upstream reason,
        minting nothing"
    (let* ((q (or (find-package "S1-O2-Q")
                  (eval '(defpackage #:s1-o2-q (:use) (:export #:x)))))
           (p (or (find-package "S1-O2-P")
                  (eval '(defpackage #:s1-o2-p (:use #:s1-o2-q) (:shadow #:x)))))
           (px (find-symbol "X" p))
           (req (s1 request-expansion
                    (list (find-symbol "DEFINE-ADMISSION-CONTRACT" '#:lisp-plus-surface0)
                          px :contract-id :s1/o2 :contract-version 1
                          :accepted-clauses (list (list :verified-judged-claim))
                          :proposition-relation :exact-normalized-equality
                          :receiver-accessibility :required
                          :retain (list :contract-snapshot))
                    :macroexpand-1 (tag "o2"))))
      (declare (ignorable q))
      (unintern px p)
      (multiple-value-bind (rc ex rf) (s1 try-perform-expansion req)
        (declare (ignore ex))
        (and (null rc)
             (eq :source-not-reconstructible (s1 expansion-refusal-code rf))
             (string= "SYMBOL-NOT-HOME-IN-NAMESPACE"
                      (s1 expansion-refusal-upstream-code rf))))))

(ok "O3 the HOME-PACKAGE conjunct does work the STATUS conjunct cannot: an
        IMPORTED symbol is :INTERNAL in the importing package while its home
        package is elsewhere, so a status-only guard would pass it"
    (let* ((q (or (find-package "S1-O3-Q")
                  (eval '(defpackage #:s1-o3-q (:use) (:export #:y)))))
           (p (or (find-package "S1-O3-P") (eval '(defpackage #:s1-o3-p (:use))))))
      (import (find-symbol "Y" q) p)
      (multiple-value-bind (sym status) (find-symbol "Y" p)
        (and (eq :internal status)
             (not (eq (symbol-package sym) p))
             ;; a hand-built datum naming P/Y must refuse — no encode path
             ;; produces it, because the ENCODER writes the HOME package
             (let ((hand (cd0 make-record-datum
                              (list (cd0 make-record-entry
                                         (cd0 make-identifier-datum '("TERM") '("KIND"))
                                         (cd0 make-identifier-datum '("TERMKIND") '("SYMBOL")))
                                    (cd0 make-record-entry
                                         (cd0 make-identifier-datum '("TERM") '("VALUE"))
                                         (cd0 make-identifier-datum
                                              (list (package-name p)) '("Y")))))))
               ;; ERRATA 0.3 (F-11) — THIS IS THE LOAD-BEARING ONE.  The whole
               ;; point of O3 is that the HOME-PACKAGE conjunct catches what the
               ;; STATUS conjunct cannot; a status-only guard would pass this
               ;; datum, and it would pass it WITHOUT ERROR.  Settling for "an
               ;; error happened" left the one claim that distinguishes the two
               ;; conjuncts resting on a predicate that any failure satisfies.
               (eq :symbol-not-home-in-namespace
                   (term-irreconstructible-reason (lambda () (s1 decode-term hand)))))))))

(ok "O3b ... and the ENCODER writes the HOME package, which is why an imported
        symbol has no hole on the encode side"
    (let* ((q (or (find-package "S1-O3B-Q")
                  (eval '(defpackage #:s1-o3b-q (:use) (:export #:z)))))
           (p (or (find-package "S1-O3B-P") (eval '(defpackage #:s1-o3b-p (:use))))))
      (import (find-symbol "Z" q) p)
      (let* ((imported (find-symbol "Z" p))
             (d (s1 encode-term imported))
             (ns (cd0 identifier-datum-namespace
                      (cd0 record-datum-ref d (cd0 make-identifier-datum '("TERM") '("VALUE"))))))
        (string= (aref ns 0) (package-name q)))))

(ok "O4 THE ROUND TRIP IS AN EXECUTED GATE, not a tested property — with a
        DEFECTIVE decoder planted, Door 2 refuses ROUND-TRIP-MISMATCH before
        any expansion"
    (let ((req (s1 request-expansion *specimen* :macroexpand-1 (tag "o4"))))
      (let ((lisp-plus-surface1::*%fault-decode-substitution*
              (lambda (form)
                (let ((copy (copy-tree form)))
                  (setf (getf (cddr copy) :contract-version) 424242)
                  copy))))
        (multiple-value-bind (rc ex rf) (s1 try-perform-expansion req)
          (declare (ignore ex))
          (and (null rc)
               (eq :source-not-reconstructible (s1 expansion-refusal-code rf))
               (string= "ROUND-TRIP-MISMATCH" (s1 expansion-refusal-upstream-code rf)))))))

(ok "O4b ... and the gate is NOT stuck on: with no fault bound the same request
        performs cleanly"
    (s1 expansion-receipt-p
        (s1 perform-expansion (s1 request-expansion *specimen* :macroexpand-1 (tag "o4b")))))

;;; ERRATA 0.3 (D3) — O5'S LABEL IS RETRACTED AND NARROWED TO WHAT IT MEASURES.
;;;
;;; It read: "NO PUBLIC INPUT CAN REACH THE ROUND-TRIP MISMATCH, and saying so is
;;; the honest classification: with the home-package guard in place decode is
;;; injective, so the earlier and more precise guard always fires first.  The
;;; gate is DEFENCE IN DEPTH, proved live only by planted fault."
;;;
;;; EVERY CLAUSE OF THAT IS FALSE except the ordering it actually exhibits.  The
;;; stranger audit reached ROUND-TRIP-MISMATCH from the public API by two
;;; standard-Common-Lisp routes, one of which mutates nothing at all; and decode
;;; is not injective — the audit built two distinct admissible data that decoded
;;; to one symbol.  Both mechanisms are executed in section P below.
;;;
;;; What this fixture actually establishes is an ORDERING, on ONE input: for a
;;; datum whose symbol has gone inherited between the doors, the symbol guard
;;; fires and the round-trip guard is never reached.  That is worth keeping and
;;; it is all this check ever showed.  An ordering on one input is not a
;;; statement about every input, and treating it as one is how the false claim
;;; got published.
(ok "O5 for the INHERITED-SYMBOL datum the EARLIER and more precise SYMBOL guard
        fires and the round-trip guard is never reached — an ordering exhibited
        on ONE input, which is exactly as much as this fixture can say"
    (let* ((q (or (find-package "S1-O5-Q")
                  (eval '(defpackage #:s1-o5-q (:use) (:export #:x)))))
           (p (or (find-package "S1-O5-P")
                  (eval '(defpackage #:s1-o5-p (:use #:s1-o5-q) (:shadow #:x)))))
           (px (find-symbol "X" p))
           (req (s1 request-expansion (list px 1) :macroexpand-1 (tag "o5"))))
      (declare (ignorable q))
      (unintern px p)
      (multiple-value-bind (rc ex rf) (s1 try-perform-expansion req)
        (declare (ignore rc ex))
        (observe rf)
        ;; the SYMBOL guard fires, never the round-trip guard
        (and (eq :source-not-reconstructible (s1 expansion-refusal-code rf))
             (string= "SYMBOL-NOT-HOME-IN-NAMESPACE" (s1 expansion-refusal-upstream-code rf))))))

;;; ERRATA 0.3 — THE VERSION CHECK, WITH THE REASONS THIS ERRATA GIVES.
(ok "O6 grammar 4, procedure 4, policy 1.  GRAMMAR moved 3->4 because the
        correspondence narrowed twice — surplus identifier segments are refused
        instead of truncated, and the raw term functions declare a depth ceiling
        — and because its published description was corrected.  PROCEDURE moved
        3->4 because requests and receipts now CAPTURE the governing versions
        and the version alarm compares two independently sourced values.  POLICY
        stays 1 because no ceiling value moved: 48 / 20000 / 262144 are untouched"
    (and (= 4 (s1 expansion-grammar-version))
         (= 4 (s1 expansion-procedure-version))
         (= 1 (s1 expansion-policy-version))
         ;; the policy numbers the ruling says did not move
         (= 48 (s1 expansion-policy-max-source-depth))
         (= 20000 (s1 expansion-policy-max-source-nodes))
         (= 262144 (s1 expansion-policy-max-term-octets))))

;;; ==================================================================
(section "P. ERRATA 0.3 — THE STRANGER AUDIT'S DEFECTS, EACH WITH A REGRESSION")
;;;
;;; Every check in this section FAILS if its repair is reverted.  That is the
;;; standard the audit set for this suite and the standard it did not previously
;;; meet: a check whose predicate cannot distinguish the repaired layer from the
;;; broken one certifies nothing, however true its label.
;;;
;;; Each subsection names the defect, states what the layer did BEFORE, and
;;; drives the public surface to the behaviour that is now required.

;;; ------------------------------------------------------------------
;;; P/D2 — THE UNCAUGHT HOST TYPE-ERROR ON COMPOUND TYPE-OF SPECIFIERS.
;;; ------------------------------------------------------------------
;;;
;;; TYPE-OF lawfully returns a COMPOUND SPECIFIER — a cons — for exactly the
;;; host types the boundary law refuses: `(COMPLEX (INTEGER 1 2))`,
;;; `(SIMPLE-VECTOR 3)`, `(SIMPLE-ARRAY T (2 2))`.  %DESCRIBE-HOST-OBJECT read
;;; `(string (type-of object))`, so building the DETAIL of the designed refusal
;;; signalled a host TYPE-ERROR and the refusal was never minted.  It escaped
;;; REQUEST-EXPANSION, and — the worse half — it escaped TRY-REQUEST-EXPANSION,
;;; whose entire contract is that it RETURNS refusals instead of signalling.
;;; The stranger audit measured all three types through both doors.

(defparameter *compound-type-objects*
  (list (cons "COMPLEX"       #C(1 2))
        (cons "SIMPLE-VECTOR" (vector 1 2 3))
        (cons "SIMPLE-ARRAY"  (make-array '(2 2) :initial-element 0))))

(ok "P1 the three COMPOUND-TYPE-OF objects each yield the DESIGNED
        :SOURCE-TERM-UNREPRESENTABLE refusal through the SIGNALLING door, with
        the NO-TERM-KIND upstream reason — never a host condition"
    (every (lambda (pair)
             (let ((r (refusal-of (lambda ()
                                    (s1 request-expansion (list 'cl:quote (cdr pair))
                                        :macroexpand-1 (tag "p1"))))))
               (and r
                    (eq :source-term-unrepresentable (s1 expansion-refusal-code r))
                    (string= "NO-TERM-KIND" (s1 expansion-refusal-upstream-code r))
                    (string= "term-encode" (s1 expansion-refusal-upstream-stage r)))))
           *compound-type-objects*)
    "these signalled a raw host TYPE-ERROR before ERRATA 0.3")

(ok "P2 ... and through the NON-SIGNALLING door they are RETURNED as refusal
        objects, which is that door's whole contract and the half the crash
        broke worst"
    (every (lambda (pair)
             (multiple-value-bind (req rf)
                 ;; a host condition escaping here is a failure, not a pass:
                 ;; TRY- must not signal, so nothing is caught around it
                 (s1 try-request-expansion (list 'cl:quote (cdr pair))
                     :macroexpand-1 (tag "p2"))
               (observe rf)
               (and (null req)
                    (s1 expansion-refusal-p rf)
                    (eq :source-term-unrepresentable (s1 expansion-refusal-code rf))
                    (string= "NO-TERM-KIND" (s1 expansion-refusal-upstream-code rf)))))
           *compound-type-objects*))

(ok "P3 ... and the refusal DETAIL names the type family and is BOUNDED — the
        repair lives in the description helper, so it must produce a short name
        rather than a rendering of the rejected object"
    (every (lambda (pair)
             (let* ((r (refusal-of (lambda ()
                                     (s1 request-expansion (list 'cl:quote (cdr pair))
                                         :macroexpand-1 (tag "p3")))))
                    (detail (s1 expansion-refusal-detail r)))
               (and (stringp detail)
                    (string= (car pair) detail)
                    (<= (length detail) 40))))
           *compound-type-objects*)
    "the head symbol of the compound specifier is the only part that names the family")

;;; ------------------------------------------------------------------
;;; P/D5 — THE RAW PUBLIC TERM FUNCTIONS DIED ON DEEP ACYCLIC INPUT.
;;; ------------------------------------------------------------------
;;;
;;; ENCODE-TERM exhausted the control stack (catchable); DECODE-TERM aborted the
;;; PROCESS ("Control stack exhausted while pseudo-atomic"), which no
;;; HANDLER-CASE could reach.  Both are public on purpose — DECODE-TERM was
;;; published by ERRATA 0.1 precisely so a reader could perform the
;;; reconstruction independently — so a reader exercising them could lose an
;;; image.  The repair is a declared, introspectable, iteratively-measured
;;; ceiling checked BEFORE recursion on both sides.
;;;
;;; THE EDGE IS TESTED ON BOTH SIDES, AT THE SAME BOUND.
;;;
;;; ERRATA 0.3, SECOND PASS — THIS PARAGRAPH ONCE TAUGHT THE OPPOSITE AND IS
;;; REWRITTEN.  It read: "those units are NOT the same object … encoding a host
;;; form of depth D produces a datum of depth D+1 … Checks P6/P7 record that
;;; asymmetry as measured fact rather than asserting a symmetry the numbers do
;;; not have."  That was a true report of a DEFECTIVE repair, not a property of
;;; the design: %DATUM-TERM-DEPTH-EXCEEDS-P began its walk one level in, so the
;;; datum measure ran one ahead of the host measure and the deepest encodable
;;; term decoded to nothing.  The chair repaired the off-by-one in
;;; surface1.lisp; the two measures now count from the same place and the same
;;; bound governs both, which is what the ledger claimed all along.
;;;
;;; THE PARAGRAPH IS CORRECTED RATHER THAN DELETED because the sequence is the
;;; evidence: a check written to record a measurement honestly is what exposed
;;; the defect, and a reader who finds only the repaired claim cannot tell that
;;; anything was ever wrong here.  What must NOT survive is the retracted
;;; sentence stated as current fact — that is the F-17 defect class, and this
;;; file has now committed it once itself.

(defun nest-host-term (k)
  "A host form of exactly K cons levels: K=1 is (T), K=2 is ((T)), and so on."
  (let ((f 'cl:t)) (dotimes (i k) (setf f (list f))) f))

(defun nest-term-datum (k)
  "A term DATUM of exactly K LIST levels, built with CD/0 constructors alone.
Needed because a datum ONE PAST the ceiling cannot be obtained from ENCODE-TERM
— the encoder refuses to build it, which is the point — so the decoder's
refusal at ceiling+1 has to be driven by a datum made by hand."
  (let ((d (s1 encode-term 'cl:t)))
    (dotimes (i k d)
      (setf d (cd0 make-record-datum
                   (list (cd0 make-record-entry
                              (cd0 make-identifier-datum '("TERM") '("KIND"))
                              (cd0 make-identifier-datum '("TERMKIND") '("LIST")))
                         (cd0 make-record-entry
                              (cd0 make-identifier-datum '("TERM") '("VALUE"))
                              (cd0 make-sequence-datum (list d)))))))))

(ok "P4 TERM-DEPTH-CEILING is EXPORTED and returns the declared bound — a
        checking surface offered to a reader publishes the bound at which it
        refuses, instead of letting the reader find it by killing an image"
    (and (eq :external (nth-value 1 (find-symbol "TERM-DEPTH-CEILING"
                                                 '#:lisp-plus-surface1)))
         (integerp (s1 term-depth-ceiling))
         (= 2000 (s1 term-depth-ceiling))))

(ok "P5 ENCODE-TERM works at EXACTLY the ceiling and REFUSES at ceiling+1, with
        the declared TERM-DEPTH-EXCEEDED reason"
    (let ((c (s1 term-depth-ceiling)))
      (and (cd0 record-datum-p (s1 encode-term (nest-host-term c)))
           (eq :term-depth-exceeded
               (term-unrepresentable-reason
                (lambda () (s1 encode-term (nest-host-term (1+ c)))))))))

(ok "P6 DECODE-TERM reconstructs a datum at EXACTLY the ceiling and REFUSES one
        past it — the same bound as the encoder, counted from the same place"
    (let* ((c (s1 term-depth-ceiling))
           (at-ceiling (s1 encode-term (nest-host-term c))))
      (and (consp (s1 decode-term at-ceiling))
           ;; one level past the ceiling cannot be reached through ENCODE-TERM
           ;; (the encoder refuses it), so the over-deep datum is built by hand
           (eq :term-depth-exceeded
               (term-irreconstructible-reason
                (lambda () (s1 decode-term (nest-term-datum (1+ c)))))))))

;;; ERRATA 0.3, SECOND PASS.  This check used to assert the OPPOSITE — that the
;;; two ceilings, being one number over two different units, did NOT compose,
;;; and that the deepest host term the encoder accepted produced a datum the
;;; decoder refused.  That was a true measurement of a defective repair, and
;;; recording it honestly is what surfaced it: the chair repaired the off-by-one
;;; (the datum walk counted the leaf term as a level the host walk does not) and
;;; this check now asserts the property the ledger had claimed all along.
;;; A suite that records a defect as a passing check is telling the truth about
;;; the world and a lie about the design; the record stays, the assertion moves.
(ok "P7 ... and the two measures COMPOSE: the deepest host term ENCODE-TERM
        accepts encodes to a datum DECODE-TERM reads back.  An encodable term
        that could not be read back is exactly what this layer's depth ceiling
        exists to prevent"
    (let* ((c (s1 term-depth-ceiling))
           (deepest (s1 encode-term (nest-host-term c))))
      (consp (s1 decode-term deepest)))
    "the asymmetry this check once recorded was repaired in surface1.lisp, not smoothed over here")

(ok "P8 ... and the sharing and cycle refusals are UNCHANGED by the depth
        repair — the iterative rewrite of the sharing counter kept its verdicts"
    (let ((car-cycle (list :a))
          (spine-cycle (list :a))
          (shared (let ((sub (list :s))) (list sub sub))))
      (setf (car car-cycle) car-cycle)
      (setf (cdr spine-cycle) spine-cycle)
      (every (lambda (form)
               (eq :shared-or-circular-structure
                   (term-unrepresentable-reason (lambda () (s1 encode-term form)))))
             (list car-cycle spine-cycle shared))))

;;; ------------------------------------------------------------------
;;; P/D3 — SURPLUS IDENTIFIER SEGMENTS, AND THE TWO PUBLIC ROUTES TO
;;;        ROUND-TRIP-MISMATCH.
;;; ------------------------------------------------------------------
;;;
;;; The decoder read segment 0 of a namespace and of a path and IGNORED the
;;; rest, so SYMBOL{ns ("P"), path ("W")} and SYMBOL{ns ("P" "SURPLUS"), path
;;; ("W" "X")} — two DISTINCT admissible data — decoded to ONE symbol, beneath a
;;; published claim that decode was injective.
;;;
;;; And ROUND-TRIP-MISMATCH, published as unreachable defence-in-depth, is
;;; reachable from the public API by two routes the audit exhibited.  Both are
;;; executed below.  Each restores the image it perturbed, so no later check
;;; inherits a renamed package or a lingering nickname.

(ok "P9 a datum carrying SURPLUS namespace and path segments is REFUSED with the
        SYMBOL-IDENTIFIER-SHAPE reason — it was never encoder output, and
        reading segment 0 of it made two distinct data decode to one symbol"
    (let ((surplus (cd0 make-record-datum
                        (list (cd0 make-record-entry
                                   (cd0 make-identifier-datum '("TERM") '("KIND"))
                                   (cd0 make-identifier-datum '("TERMKIND") '("SYMBOL")))
                              (cd0 make-record-entry
                                   (cd0 make-identifier-datum '("TERM") '("VALUE"))
                                   (cd0 make-identifier-datum
                                        '("COMMON-LISP" "SURPLUS") '("CAR" "EXTRA")))))))
      (eq :symbol-identifier-shape
          (term-irreconstructible-reason (lambda () (s1 decode-term surplus))))))

(ok "P9b ... and the one-segment datum it shadowed still decodes, so the
        narrowing removed the surplus shape and nothing else"
    (eq 'cl:car (s1 decode-term (s1 encode-term 'cl:car))))

(ok "P10 ROUND-TRIP-MISMATCH IS PUBLICLY REACHABLE, mechanism 1: RENAME-PACKAGE
        between the doors, keeping the old name as a NICKNAME.  FIND-PACKAGE
        still resolves the stored namespace to the same package object, so the
        home-package guard passes; re-encoding writes the package's new PRIMARY
        name, which is not the stored one.  It refuses BEFORE macroexpansion and
        MINTS NOTHING"
    (let* ((pkg (or (find-package "S1-P-RHO") (make-package "S1-P-RHO" :use '())))
           (x (intern "X" pkg))
           (req (s1 request-expansion (list x 1) :macroexpand-1 (tag "p10"))))
      (rename-package pkg "S1-P-RHO-PRIME" '("S1-P-RHO"))
      (unwind-protect
           (multiple-value-bind (rc ex rf) (s1 try-perform-expansion req)
             (observe rf)
             (and (null rc) (null ex)
                  (s1 expansion-refusal-p rf)
                  (eq :source-not-reconstructible (s1 expansion-refusal-code rf))
                  (string= "ROUND-TRIP-MISMATCH" (s1 expansion-refusal-upstream-code rf))
                  (eq :perform (s1 expansion-refusal-phase rf))))
        (rename-package (find-package "S1-P-RHO-PRIME") "S1-P-RHO"))))

(ok "P11 ROUND-TRIP-MISMATCH IS PUBLICLY REACHABLE, mechanism 2: a PACKAGE-LOCAL
        NICKNAME in the caller's ambient *PACKAGE* at Door 2.  NOTHING is
        mutated — no unintern, no rename, no deletion — so Door 2's
        reconstruction is a function of (datum, image, DYNAMIC CONTEXT), which no
        document before ERRATA 0.3 stated"
    (let* ((delta (or (find-package "S1-P-DELTA") (make-package "S1-P-DELTA" :use '())))
           (else (or (find-package "S1-P-ELSEWHERE")
                     (make-package "S1-P-ELSEWHERE" :use '())))
           (caller (or (find-package "S1-P-CALLER") (make-package "S1-P-CALLER" :use '())))
           (x-delta (intern "X" delta))
           (req (s1 request-expansion (list x-delta 1) :macroexpand-1 (tag "p11"))))
      (intern "X" else)
      (sb-ext:add-package-local-nickname "S1-P-DELTA" "S1-P-ELSEWHERE" caller)
      (unwind-protect
           (let ((*package* caller))
             (multiple-value-bind (rc ex rf) (s1 try-perform-expansion req)
               (observe rf)
               (and (null rc) (null ex)
                    (eq :source-not-reconstructible (s1 expansion-refusal-code rf))
                    (string= "ROUND-TRIP-MISMATCH" (s1 expansion-refusal-upstream-code rf)))))
        (sb-ext:remove-package-local-nickname "S1-P-DELTA" caller))))

(ok "P11b ... and the SAME request, performed from a package with no local
        nickname, crosses the gate — so the refusal above is caused by the
        DYNAMIC CONTEXT and by nothing else about the request"
    (let* ((delta (find-package "S1-P-DELTA"))
           (req (s1 request-expansion (list (find-symbol "X" delta) 1)
                    :macroexpand-1 (tag "p11b"))))
      (multiple-value-bind (rc ex rf) (s1 try-perform-expansion req)
        (declare (ignore rc ex))
        (observe rf)
        ;; the gate is crossed; the LATER refusal is the construct-table one
        (eq :not-a-known-surface-construct (s1 expansion-refusal-code rf)))))

;;; ------------------------------------------------------------------
;;; P/D1 — :EXPANDED-NODES-EXCEEDED WAS DECLARED UNREACHABLE.  IT IS NOT.
;;; ------------------------------------------------------------------
;;;
;;; The catalogue declared this code `:unreachable-under-this-policy` and
;;; annotated it "MEASURED UNREACHABLE UNDER THIS POLICY", arguing that each
;;; term costs roughly 120 octets so the octet ceiling always fires first.  The
;;; order argument was BACKWARDS — %ENCODE-CHECKED runs depth -> nodes -> encode
;;; -> octets, so on the expanded side the NODE check runs before anything is
;;; encoded and no octet count can pre-empt it — and the arithmetic was wrong
;;; too.  The old M4/M6 pair CERTIFIED the false claim: M4 read the catalogue
;;; field back to itself, and M6 "exhibited the arithmetic" of an argument that
;;; did not hold.
;;;
;;; Both are replaced by an EXECUTABLE PUBLIC WITNESS.  A witness is not an
;;; opinion about a field: Door 1 accepts an ordinary admissible source form and
;;; Door 2 refuses it with exactly this code.

(defun judgment-schema-with-premises (n)
  "A DEFINE-JUDGMENT-SCHEMA source form carrying N atomic premises.  Every field
is literal syntax, as that construct requires."
  `(lisp-plus-surface0:define-judgment-schema cl-user::*s1-p-schema*
     :name :z :version 0 :conclusion (:predicate :z (:v (:var :v)))
     :premises ,(make-list n :initial-element :a)
     :locals () :unique-locals ()))

(defparameter *nodes-witness-source* (judgment-schema-with-premises 2491))

(ok "P12 DOOR 1 ACCEPTS the witness: 2491 atomic premises pass every SOURCE
        ceiling — the form is admissible, not a hostile construction"
    (let ((req (s1 request-expansion *nodes-witness-source* :macroexpand-1
                   (tag "p12"))))
      (and (s1 expansion-request-p req)
           (<= (funcall (find-symbol "%HOST-DEPTH" '#:lisp-plus-surface1)
                        *nodes-witness-source*)
               (s1 expansion-policy-max-source-depth))
           (<= (funcall (find-symbol "%HOST-NODES" '#:lisp-plus-surface1)
                        *nodes-witness-source*)
               (s1 expansion-policy-max-source-nodes)))))

(ok "P13 ... and DOOR 2 REFUSES IT WITH EXACTLY :EXPANDED-NODES-EXCEEDED.  This
        is the code the catalogue called MEASURED UNREACHABLE"
    (let ((r (refusal-of (lambda ()
                           (s1 perform-expansion
                               (s1 request-expansion *nodes-witness-source*
                                   :macroexpand-1 (tag "p13")))))))
      (and r
           (eq :expanded-nodes-exceeded (s1 expansion-refusal-code r))
           (eq :perform (s1 expansion-refusal-phase r)))))

(ok "P14 ... and the CATALOGUE now says so: the reachability field for that code
        reads :PUBLIC-API, and NO code anywhere in the catalogue is declared
        :UNREACHABLE-UNDER-THIS-POLICY"
    (and (eq :public-api
             (s1 refusal-catalog-entry-reachability
                 (assoc :expanded-nodes-exceeded *catalog*)))
         (null (remove-if-not
                (lambda (e) (eq :unreachable-under-this-policy
                                (s1 refusal-catalog-entry-reachability e)))
                *catalog*))))

(ok "P15 ... and the retracted 'octets always fire first' order is refuted by
        one premise: at 2490 premises the OCTET ceiling fires, at 2491 the NODE
        ceiling fires.  Neither dominates; the threshold is construct-dependent"
    (let ((at-2490 (refusal-of (lambda ()
                                 (s1 perform-expansion
                                     (s1 request-expansion
                                         (judgment-schema-with-premises 2490)
                                         :macroexpand-1 (tag "p15"))))))
          (at-2491 (refusal-of (lambda ()
                                 (s1 perform-expansion
                                     (s1 request-expansion *nodes-witness-source*
                                         :macroexpand-1 (tag "p15b")))))))
      (and (eq :expanded-term-octets-exceeded (s1 expansion-refusal-code at-2490))
           (eq :expanded-nodes-exceeded (s1 expansion-refusal-code at-2491)))))

(ok "P16 ... and the third expanded-side ceiling is driven from the public API
        too: a source 45 levels deep (ceiling 48) expands to 49 and refuses
        :EXPANDED-DEPTH-EXCEEDED, so no expanded-side ceiling is left standing
        on an argument instead of a witness"
    (let* ((deep-conclusion (let ((f :zz)) (dotimes (i 44) (setf f (list f))) f))
           (src `(lisp-plus-surface0:define-judgment-schema cl-user::*s1-p-deep*
                   :name :z :version 0 :conclusion ,deep-conclusion
                   :premises (:a) :locals () :unique-locals ()))
           (r (refusal-of (lambda ()
                            (s1 perform-expansion
                                (s1 request-expansion src :macroexpand-1 (tag "p16")))))))
      (and (<= (funcall (find-symbol "%HOST-DEPTH" '#:lisp-plus-surface1) src)
               (s1 expansion-policy-max-source-depth))
           (eq :expanded-depth-exceeded (s1 expansion-refusal-code r)))))

(ok "P17 ... and a DOOR-1 SHARED-STRUCTURE refusal is produced rather than
        merely listed: a source whose :ACCEPTED-CLAUSES holds ONE cons in TWO
        positions refuses :SOURCE-TERM-SHARED-STRUCTURE.  ERRATA 0.2's coverage
        list named this code as exercised; nothing in any instrument produced it"
    (let* ((sub (list :verified-judged-claim))
           (src (list (find-symbol "DEFINE-ADMISSION-CONTRACT" '#:lisp-plus-surface0)
                      (intern "*S1-P-SHARED*" '#:cl-user)
                      :contract-id :s1/p17 :contract-version 1
                      :accepted-clauses (list sub sub)
                      :proposition-relation :exact-normalized-equality
                      :receiver-accessibility :required
                      :retain (list :contract-snapshot)))
           (r (refusal-of (lambda ()
                            (s1 request-expansion src :macroexpand-1 (tag "p17"))))))
      (and r
           (eq :source-term-shared-structure (s1 expansion-refusal-code r))
           (eq :request (s1 expansion-refusal-phase r))
           (string= "SHARED-OR-CIRCULAR-STRUCTURE" (s1 expansion-refusal-upstream-code r)))))

;;; ------------------------------------------------------------------
;;; P/D7 — THE VACUOUS VERSION ALARM AND THE ACCESSORS THAT READ THE
;;;        LIVE PACKAGE.
;;; ------------------------------------------------------------------
;;;
;;; EXPANSION-RECEIPT-PROCEDURE-VERSION was a constant function that ignored its
;;; receipt.  The stranger audit redefined the live version and watched an OLD
;;; receipt's reported version MOVE from 3 to 4 while its identity octets stayed
;;; frozen at the v3 value — a receipt that could not report the version under
;;; which it was minted.  The same absence made :PROCEDURE-VERSION-MISMATCH a
;;; comparison of the package with itself.
;;;
;;; The checks below MOVE THE LIVE VERSION and require the old receipt not to
;;; move with it.  The redefinition is undone by UNWIND-PROTECT so nothing
;;; downstream — in this file or in any instrument that loads after it —
;;; inherits a bumped image.

(ok "P18 a REQUEST carries the grammar, procedure and policy versions Door 1
        captured, as READABLE VALUES.  They were composed into the request
        identity's octets, where they are frozen but unreadable: an identity can
        be COMPARED, never READ"
    (let ((req (s1 request-expansion *specimen* :macroexpand-1 (tag "p18"))))
      (and (eql 4 (s1 expansion-request-grammar-version req))
           (eql 4 (s1 expansion-request-procedure-version req))
           (eql 1 (s1 expansion-request-policy-version req)))))

(defparameter *d7-receipt*
  (s1 perform-expansion (s1 request-expansion *specimen* :macroexpand-1 (tag "p" "d7"))))
(defparameter *d7-identity-before*
  (cd0 octets-to-hex (cd0 canonical-octets (s1 expansion-receipt-identity *d7-receipt*))))

(defparameter *d7-observations*
  (let ((saved (symbol-function 'lisp-plus-surface1::expansion-procedure-version)))
    (unwind-protect
         (progn
           (setf (symbol-function 'lisp-plus-surface1::expansion-procedure-version)
                 (lambda () 99))
           (list :live-version (s1 expansion-procedure-version)
                 :receipt-version (s1 expansion-receipt-procedure-version *d7-receipt*)
                 :receipt-identity (cd0 octets-to-hex
                                        (cd0 canonical-octets
                                             (s1 expansion-receipt-identity *d7-receipt*)))))
      (setf (symbol-function 'lisp-plus-surface1::expansion-procedure-version) saved))))

(ok "P19 an OLD receipt keeps reporting the version that MINTED it after the
        live version moves beneath it — 4, in an image now answering 99"
    (and (eql 99 (getf *d7-observations* :live-version))
         (eql 4 (getf *d7-observations* :receipt-version))
         ;; and the image is restored: nothing downstream inherits the bump
         (eql 4 (s1 expansion-procedure-version))
         (eql 4 (s1 expansion-receipt-procedure-version *d7-receipt*))))

(ok "P20 ... and the old receipt's IDENTITY did not move either, so the stored
        version and the frozen octets agree instead of drifting apart"
    (string= *d7-identity-before* (getf *d7-observations* :receipt-identity)))

(ok "P21 :PROCEDURE-VERSION-MISMATCH now compares TWO INDEPENDENTLY SOURCED
        VALUES — the version Door 1 captured against the version live at mint —
        so a request minted before a version move and performed after it
        REFUSES.  Before ERRATA 0.3 the alarm compared the package with itself
        and no state of the world could violate it"
    (let ((saved (symbol-function 'lisp-plus-surface1::expansion-procedure-version))
          (req (s1 request-expansion *specimen* :macroexpand-1 (tag "p21"))))
      (unwind-protect
           (progn
             (setf (symbol-function 'lisp-plus-surface1::expansion-procedure-version)
                   (lambda () 99))
             (let ((r (refusal-of (lambda () (s1 perform-expansion req)))))
               (and r
                    (eq :procedure-version-mismatch (s1 expansion-refusal-code r))
                    (eq :receipt (s1 expansion-refusal-phase r))
                    ;; ERRATA 0.3, SECOND PASS — AND THE CATALOGUE NOW AGREES.
                    ;; This detail line used to read "an image mutation, NOT a
                    ;; public call", hedging the classification while the
                    ;; catalogue still called the code
                    ;; :INTERNAL-PLANTED-FAULT-ONLY.  The hedge was wrong in the
                    ;; direction that matters: this fixture touches no internal
                    ;; symbol and binds no fault hook — it redefines an EXPORTED
                    ;; function, which any client can do — so the code was
                    ;; publicly reachable and the catalogue said otherwise.  The
                    ;; chair reclassified it to :PUBLIC-API.  The check asserts
                    ;; that classification here, at the one place in this suite
                    ;; that reaches the code by the public route.
                    (eq :public-api
                        (s1 refusal-catalog-entry-reachability
                            (assoc :procedure-version-mismatch *catalog*))))))
        (setf (symbol-function 'lisp-plus-surface1::expansion-procedure-version) saved)))
    "reached with no internal symbol and no fault hook — only a redefinition of an EXPORTED function")

(ok "P22 ... and with the image restored the same request performs cleanly, so
        the alarm above is a real comparison and not a stuck gate"
    (and (eql 4 (s1 expansion-procedure-version))
         (s1 expansion-receipt-p
             (s1 perform-expansion
                 (s1 request-expansion *specimen* :macroexpand-1 (tag "p22"))))))

;;; ==================================================================
(section "M. REFUSAL-CODE COVERAGE — MEASURED FROM WHAT ACTUALLY FIRED")
;;;
;;; ERRATA 0.3 (F-6).  This section used to sit in the middle of the file and
;;; read `*EXERCISED*`, a hand-written list of codes the suite was BELIEVED to
;;; drive.  Nothing checked the belief, and the belief was wrong: the list named
;;; :SOURCE-TERM-SHARED-STRUCTURE, which appeared in the entire tree three times
;;; — its catalogue entry, its argument position in REQUEST-EXPANSION, and the
;;; list itself — and which no check in any instrument ever produced.  The
;;; coverage claim built on it ("Nothing else is left uncovered") was therefore
;;; false while the check reading it stayed green, because the falsehood lived
;;; inside the thing the check consulted.
;;;
;;; Coverage is now MEASURED.  *OBSERVED-CODES* holds the code of every refusal
;;; object this run actually obtained, recorded at the moment of acquisition.
;;; This section runs LAST, after every other check has had its chance to
;;; produce one.
;;;
;;; WHAT THIS MEASURES AND WHAT IT DOES NOT.  That a code FIRED is not that the
;;; guard behind it is correct; coverage is a statement about this suite's
;;; reach, never about the layer's soundness.

(defun codes-with-reachability (r)
  (mapcar (lambda (e) (s1 refusal-catalog-entry-code e))
          (remove-if-not (lambda (e) (eq r (s1 refusal-catalog-entry-reachability e)))
                         *catalog*)))

(defparameter *public-api-codes* (codes-with-reachability :public-api))
(defparameter *all-catalog-codes*
  (mapcar (lambda (e) (s1 refusal-catalog-entry-code e)) *catalog*))
(defparameter *uncovered*
  (sort (copy-list (set-difference *public-api-codes* *observed-codes*)) #'string<))

(format t "  observed refusal codes this run: ~D~%" (length *observed-codes*))
(format t "  :PUBLIC-API codes declared: ~D · uncovered by this suite: ~S~%"
        (length *public-api-codes*) *uncovered*)

(ok "M1 every code this run ACTUALLY PRODUCED is DECLARED in the catalogue —
        no refusal escapes with a code the table does not name"
    (null (set-difference *observed-codes* *all-catalog-codes*))
    (format nil "undeclared: ~S" (set-difference *observed-codes* *all-catalog-codes*)))

(ok "M2 the :PUBLIC-API codes this suite leaves uncovered are EXACTLY NONE —
        measured from the codes observed, not read off a list.  Every code the
        catalogue declares publicly reachable was reached, in this process, by
        this file"
    (null *uncovered*)
    (format nil "uncovered: ~S" *uncovered*))

(ok "M2b ... and the measurement is not vacuous in the other direction either:
        the observed set is a SUBSET of the catalogue and covers more than the
        public codes alone, since the planted-fault alarms fire here too"
    (and (>= (length *observed-codes*) (length *public-api-codes*))
         (subsetp *observed-codes* *all-catalog-codes*)))

(ok "M3 exactly one code is declared reachable only in a stub image, and this
        suite does NOT observe it — manufacturing that state here would mean
        altering Surface /0, which is forbidden; STUB-IMAGE-FIXTURE.lisp proves
        it in a separate process"
    (and (equal '(:construct-not-a-macro) (codes-with-reachability :public-api-in-a-stub-image))
         (not (member :construct-not-a-macro *observed-codes*))))

(ok "M4 NO code is declared UNREACHABLE UNDER THIS POLICY.  The one that was —
        :EXPANDED-NODES-EXCEEDED — is now :PUBLIC-API and was OBSERVED by this
        run, at P13.  The claim is retired by a witness, not by an edit"
    (and (null (codes-with-reachability :unreachable-under-this-policy))
         (member :expanded-nodes-exceeded *observed-codes*)
         (eq :public-api (s1 refusal-catalog-entry-reachability
                             (assoc :expanded-nodes-exceeded *catalog*)))))

;;; ERRATA 0.3, SECOND PASS — THE NUMERAL IS GONE FROM THIS LABEL.
;;; It read "…and all three fired here."  There were three
;;; :INTERNAL-PLANTED-FAULT-ONLY codes when it was written; the chair's
;;; reclassification of :PROCEDURE-VERSION-MISMATCH to :PUBLIC-API left two, and
;;; the label went false while the predicate — which derives its set from the
;;; catalogue — stayed correct and green.  A hand-typed count beside a derived
;;; set is the same defect as a hand-written coverage list beside a live one,
;;; one size smaller.  The count is now DERIVED and printed as detail.
(ok "M5 every :INTERNAL-PLANTED-FAULT-ONLY alarm was OBSERVED — a gate that has
        never fired is untested, not passing, and every one the catalogue still
        classifies that way fired here"
    (null (set-difference (codes-with-reachability :internal-planted-fault-only)
                          *observed-codes*))
    (format nil "declared ~D · unfired: ~S"
            (length (codes-with-reachability :internal-planted-fault-only))
            (set-difference (codes-with-reachability :internal-planted-fault-only)
                            *observed-codes*)))

(ok "M6 ... and the source-side node ceiling is genuinely reached too, so the
        source/expanded pair is covered on both sides by observation rather than
        by an argument about which check runs first"
    (and (member :source-nodes-exceeded *observed-codes*)
         (member :expanded-nodes-exceeded *observed-codes*)))

;;; ==================================================================
(format t "~%")
(format t "  WHAT THESE GREENS DO NOT ESTABLISH~%")
(format t "  Not that any source and its expansion mean the same thing.~%")
(format t "  Not that any expansion is correct, evaluable, compilable, hygienic~%")
(format t "    or portable to another Common Lisp.~%")
(format t "  Not that any lexical environment was captured: none ever is.~%")
(format t "  Not that later evaluation reaches backward and validates anything.~%")
(format t "  A receipt is an ACCOUNT, not an AUTHENTICATION.~%")
(format t "  Every green above is SELF-CONSISTENCY CERTIFICATION by the family~%")
(format t "    that wrote the layer.  The stranger audit is OWED.~%~%")
(format t "== surface1-selftest: ~D checks passed / ~D failed ==~%"
        (- *checks* *failed*) *failed*)

;;; ------------------------------------------------------------------
;;; THE CANONICAL RESULT LINE.                      [ERRATA 0.3 — D4]
;;; ------------------------------------------------------------------
;;;
;;; ONE machine-readable line, emitted here and nowhere else — after every
;;; intended check has executed, and only here, so a run that died earlier
;;; cannot have produced it.
;;;
;;; It carries THREE numbers and the runner requires all three:
;;;   checks=   the LIVE counter, which a truncated run cannot inflate
;;;   expected= the literal DECLARED at the top of this file, which a truncated
;;;             run cannot reach and a partial run cannot match
;;;   failed=   the LIVE failure counter, so a red run prints a line the runner
;;;             will not accept rather than a green one it will
;;;
;;; The stranger audit's teeth control T6 truncated this file at a clean form
;;; boundary and the evidence runner reported SUCCESS, because a truncated
;;; --load exits 0.  Exit code alone is not a result; this line is.
;;; ERRATA 0.3 / D6 — and the result line says WHAT IT MEASURED.  A canonical
;;; line that reports counts but not the subject is a gate on the run's shape
;;; and not on its subject: the audit produced byte-identical transcripts for
;;; two different subjects.  The digest is computed BY THIS INSTRUMENT, never
;;; accepted from the wrapper, and it fails closed — if it cannot be computed,
;;; this file dies before printing a result at all.
;;; NB: `*HERE*` is defined in CL-USER, above this file's own IN-PACKAGE, so it
;;; must be named with its home package here — an unqualified reference reads as
;;; SURFACE1-SELFTEST::*HERE*, which is unbound.  The gate caught exactly that
;;; when this was first written, and reported it as a run with no result line,
;;; which is precisely what it should do.
(handler-bind ((style-warning #'muffle-warning))
  (load (merge-pathnames "errata-0.3/EVIDENCE.lisp" cl-user::*here*)))
(format t "SELFTEST-RESULT checks=~D expected=~D failed=~D subject=~A~%"
        *checks* *expected-checks* *failed*
        (funcall (find-symbol "SUBJECT-SHORT" "SURFACE1-EVIDENCE")
                 (make-pathname :name nil :type nil :defaults cl-user::*here*)))
(finish-output)

(when (or (plusp *failed*) (/= *checks* *expected-checks*))
  (sb-ext:exit :code 1))
