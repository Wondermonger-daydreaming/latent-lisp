;;;; form2-selftest.lisp — Language Form /2, Candidate /0.
;;;;
;;;; Run: sbcl --non-interactive --load form2-selftest.lisp
;;;;
;;;; SELF-CONSISTENCY CERTIFICATION ONLY.  Every green here was produced by the
;;;; family that wrote the layer.  A stranger audit is OWED and is not
;;;; pre-satisfied by Form /0's or Form /1's, each of which binds one exact
;;;; subject tree.
;;;;
;;;; ON THE DOUBLE COLON BELOW.  This suite reaches LISP-PLUS-FORM2:: for three
;;;; internal planted-fault hooks.  That is a package reaching into ITSELF to
;;;; make its own integrity alarms fire, which is the only way an alarm
;;;; unreachable from the public API can have a fixture — and a gate that has
;;;; never fired is untested, not passing.  It is NOT a reach into another
;;;; layer: there is no LISP-PLUS-FORM0:: and no LISP-PLUS-FORM1:: anywhere in
;;;; this file or in form2.lisp, and there must never be.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (let ((*error-output* (make-broadcast-stream)))
    (handler-bind ((style-warning #'muffle-warning))
      (load (merge-pathnames "form2.lisp"
                             (or *load-truename* *default-pathname-defaults*))))))

(defpackage #:form2-selftest (:use #:common-lisp))
(in-package #:form2-selftest)

(defmacro f2 (name &rest args)
  `(,(intern (string name) '#:lisp-plus-form2) ,@args))
(defmacro cd0 (name &rest args)
  `(,(intern (string name) '#:lisp-plus-cd0) ,@args))

;;; ------------------------------------------------------------------
;;; Reporting.  CHECKS ARE NUMBERED BY SIDE EFFECT, so the count is a fact of
;;; the run and never a literal in the source.
;;; ------------------------------------------------------------------

(defparameter *checks* 0)
(defparameter *failed* 0)
(defparameter *codes-produced* '())

(defun section (title) (format t "~%── ~A~%" title))
(defun desk (control &rest arguments)
  (format t "  ~A~%" (apply #'format nil control arguments)))
;;; THE FORCED-RED HOOK, used only by VERDICT-LIVENESS-SWEEP.sh.  It exists so
;;; the sweep can establish CONNECTEDNESS: that every rendered verdict is wired
;;; to the suite's failure result.  It establishes NOTHING about whether any
;;; predicate measures its English label — both of Form /1's historically hollow
;;; checks would have passed its equivalent sweep.
(defparameter *force-red*
  (let ((v (sb-ext:posix-getenv "FORM2_FORCE_RED")))
    (and v (parse-integer v :junk-allowed t))))

(defun check (condition label)
  (incf *checks*)
  (when (and *force-red* (= *checks* *force-red*))
    (setf condition (not condition)))
  (if condition
      (format t "  [~3,'0D] ok   ~A~%" *checks* label)
      (progn (incf *failed*)
             (format t "  [~3,'0D] FAIL ~A~%" *checks* label))))

(defun note-code (refusal)
  (when refusal
    (pushnew (f2 form-transformation-refusal-code refusal) *codes-produced*))
  refusal)

;;; ------------------------------------------------------------------
;;; Fixture helpers
;;; ------------------------------------------------------------------

(defun txt (s) (cd0 make-string-datum s))
(defun num (n) (cd0 make-integer-datum n))
(defun sq (l) (cd0 make-sequence-datum l))
(defun idr (ns p) (cd0 make-identifier-datum ns p))
(defun rec (pairs)
  (cd0 make-record-datum
       (mapcar (lambda (p) (cd0 make-record-entry (car p) (cdr p))) pairs)))
(defun same (a b) (cd0 equal-datum a b))
(defun hex (d) (cd0 octets-to-hex (cd0 canonical-octets d)))

(defun tree ()
  "[ id(demo/root), \"alpha\", { k1: \"one\", k2: \"two\" } ]"
  (sq (list (idr '("demo") '("root"))
            (txt "alpha")
            (rec (list (cons (idr '("demo") '("k1")) (txt "one"))
                       (cons (idr '("demo") '("k2")) (txt "two")))))))

(defun pd (&key (input (tree)) (path (f2 path-datum (f2 index-step 1)))
                (expected (txt "alpha")) (replacement (txt "GAMMA"))
                (tag (txt "tag-0001")))
  (f2 replacement-proposal-datum
      :input input :path path :expected-old expected
      :replacement replacement :occurrence-tag tag))

(defun propose (&rest args)
  (multiple-value-bind (p r) (f2 try-propose-replacement (apply #'pd args))
    (values p (note-code r))))

(defun apply-ok (&rest args)
  (multiple-value-bind (p r) (apply #'propose args)
    (if r (values nil nil r)
        (multiple-value-bind (s rc r2) (f2 try-apply-replacement p)
          (values s rc (note-code r2))))))

(defun refusal-code-of (r) (and r (f2 form-transformation-refusal-code r)))

(defun pathd (steps)
  "PATH-DATUM over a computed list.  F2 is a macro, so APPLY needs the real
function object."
  (apply (symbol-function (intern "PATH-DATUM" '#:lisp-plus-form2)) steps))

(format t "~&LANGUAGE FORM /2 — CANDIDATE /0 — SELFTEST~%")
(format t "SBCL ~A~%" (lisp-implementation-version))
(format t "grammar ~A v~D · policy ~A v~D~%"
        (f2 render-identity-hex (f2 transformation-grammar-identity))
        (f2 transformation-grammar-version)
        (f2 render-identity-hex (f2 transformation-policy-identity))
        (f2 transformation-policy-version))

;;; ==================================================================
(section "I. THE TWO DOORS — a proposal is a description, not a promise")
;;; ==================================================================

(multiple-value-bind (p r) (propose)
  (check (and p (null r)) "door 1 admits a well-formed proposal")
  (check (f2 replacement-proposal-p p) "door 1 returns a proposal object")
  (multiple-value-bind (s rc r2) (f2 try-apply-replacement p)
    (check (and s rc (null r2)) "door 2 applies it")
    (check (eq :replaced-at-path (f2 form-transformation-receipt-disposition rc))
           "disposition is :REPLACED-AT-PATH — names the operation, not its character")
    (check (string= "GAMMA" (cd0 string-datum-value (cd0 sequence-datum-ref s 1)))
           "the successor carries the replacement at the declared path")))

;; NC-36 — a proposal that can NEVER apply is still a lawful proposal.
(multiple-value-bind (p r) (propose :path (f2 path-datum (f2 index-step 99)))
  (check (and p (null r)) "NC-36 door 1 admits a proposal whose path cannot resolve")
  (multiple-value-bind (s rc r2) (f2 try-apply-replacement p)
    (check (and (null s) (null rc) r2) "NC-36 door 2 refuses it")
    (check (eq :path-index-out-of-range (refusal-code-of (note-code r2)))
           "NC-36 the refusal is a PATH refusal, not a grammar one")))

;; NC-35 — three values on both branches.
(multiple-value-bind (p) (propose)
  (check (= 3 (length (multiple-value-list (f2 try-apply-replacement p))))
         "NC-35 successful application returns exactly three values"))
(multiple-value-bind (p) (propose :expected (txt "WRONG"))
  (check (= 3 (length (multiple-value-list (f2 try-apply-replacement p))))
         "NC-35 refused application returns exactly three values"))

;; NC-37 — door 2 will not take a raw datum.
(multiple-value-bind (s rc r) (f2 try-apply-replacement (tree))
  (check (and (null s) (null rc) r) "NC-37 door 2 refuses a raw datum")
  (check (eq :not-a-replacement-proposal-object (refusal-code-of (note-code r)))
         "NC-37 with the species code"))

;; NC-34 — the loud twins carry the same refusal object.
(check (handler-case (progn (f2 propose-replacement (txt "not a proposal")) nil)
         (#.(intern "FORM-TRANSFORMATION-REFUSED" '#:lisp-plus-form2) (c)
           (eq :proposal-node-not-a-sequence
               (refusal-code-of (f2 form-transformation-refused-refusal c)))))
       "NC-34 PROPOSE-REPLACEMENT signals, carrying the same refusal object")
(check (handler-case
           (multiple-value-bind (p) (propose :expected (txt "WRONG"))
             (f2 apply-replacement p) nil)
         (#.(intern "FORM-TRANSFORMATION-REFUSED" '#:lisp-plus-form2) (c)
           (eq :expected-old-mismatch
               (refusal-code-of (f2 form-transformation-refused-refusal c)))))
       "NC-34 APPLY-REPLACEMENT signals, carrying the same refusal object")

;;; ==================================================================
(section "II. THE PRECONDITION, AND WHY IT PRECEDES THE NO-OP TEST")
;;; ==================================================================

(multiple-value-bind (s rc r) (apply-ok :expected (txt "WRONG"))
  (declare (ignore s rc))
  (check (eq :expected-old-mismatch (refusal-code-of r)) "NC-2 expected-old mismatch refuses"))

(multiple-value-bind (s rc r) (apply-ok :replacement (txt "alpha"))
  (declare (ignore s rc))
  (check (eq :replacement-equals-observed-old (refusal-code-of r))
         "NC-29 a true no-op refuses, named for what was OBSERVED"))

;; NC-44 — THE ORDERING TEST.  A stale proposal whose declared expected value
;; happens to equal its replacement is FIRST a mismatch.  Refusing it as a no-op
;; would report a fact about a datum the layer never looked at.
(multiple-value-bind (s rc r) (apply-ok :expected (txt "STALE") :replacement (txt "STALE"))
  (declare (ignore s rc))
  (check (eq :expected-old-mismatch (refusal-code-of r))
         "NC-44 stale proposal with expected==replacement refuses MISMATCH, not no-op"))

;;; ==================================================================
(section "III. THE INPUT IS NEVER TOUCHED — true by substrate, tested anyway")
;;; ==================================================================

(let* ((input (tree))
       (before (hex input)))
  (multiple-value-bind (s rc r) (apply-ok :input input)
    (declare (ignore rc r))
    (check (string= before (hex input))
           "NC-5 the input datum is byte-identical after a successful replacement")
    (check (not (same s input)) "NC-6 the successor differs from the input")
    (check (same (cd0 sequence-datum-ref s 0) (cd0 sequence-datum-ref input 0))
           "NC-6 element 0 is untouched")
    (check (same (cd0 sequence-datum-ref s 2) (cd0 sequence-datum-ref input 2))
           "NC-6 element 2 is untouched — the output differs ONLY at the declared path")))

;; NC-3 / NC-4 — a caller mutating its own host objects afterwards cannot reach
;; the retained transformation.  CD/0 data is immutable and door 1 snapshots.
(let* ((s (make-string 5 :initial-element #\a))
       (host-tag (txt s)))
  (multiple-value-bind (p r) (propose :tag host-tag)
    (declare (ignore r))
    (let ((tag-before (hex (f2 replacement-proposal-occurrence-tag p))))
      (fill s #\z)
      (check (string= tag-before
                      (hex (f2 replacement-proposal-occurrence-tag p)))
             "NC-3/4 mutating the caller's host string cannot alter the retained proposal"))))

;;; ==================================================================
(section "IV. PATHS — tagged steps, identifier keys, and the empty root")
;;; ==================================================================

;; NC-23 — the empty path is legal and denotes the root.
(multiple-value-bind (s rc r) (apply-ok :path (f2 path-datum)
                                        :expected (tree) :replacement (txt "WHOLE"))
  (check (and s rc (null r)) "NC-23 empty path (root) replacement succeeds")
  (check (same s (txt "WHOLE")) "NC-23 the successor IS the replacement"))

;; key steps
(multiple-value-bind (s rc r)
    (apply-ok :path (f2 path-datum (f2 index-step 2) (f2 key-step (idr '("demo") '("k2"))))
              :expected (txt "two") :replacement (txt "TWO!"))
  (declare (ignore rc))
  (check (and s (null r)) "a key step descends a record")
  (check (string= "TWO!" (cd0 string-datum-value
                              (cd0 record-datum-ref (cd0 sequence-datum-ref s 2)
                                   (idr '("demo") '("k2")))))
         "the keyed field carries the replacement"))

;; NC-31 — an index step applied to a record refuses; records are NEVER
;; positionally addressed, because CD/0 derives field order from key bytes.
(multiple-value-bind (s rc r)
    (apply-ok :path (f2 path-datum (f2 index-step 2) (f2 index-step 0))
              :expected (txt "one"))
  (declare (ignore s rc))
  (check (eq :path-step-family-mismatch (refusal-code-of r))
         "NC-31 an index step meeting a record refuses — no positional record access"))

;; a key step meeting a sequence
(multiple-value-bind (s rc r)
    (apply-ok :path (f2 path-datum (f2 key-step (idr '("demo") '("k1")))))
  (declare (ignore s rc))
  (check (eq :path-step-family-mismatch (refusal-code-of r))
         "a key step meeting a sequence refuses with the same family code"))

;; absent key
(multiple-value-bind (s rc r)
    (apply-ok :path (f2 path-datum (f2 index-step 2) (f2 key-step (idr '("demo") '("nope"))))
              :expected (txt "one"))
  (declare (ignore s rc))
  (check (eq :path-key-absent (refusal-code-of r)) "NC-1 an absent key refuses"))

;; NC-30 — a record step carrying a non-identifier operand.
(multiple-value-bind (p r)
    (propose :path (sq (list (sq (list (idr '("lisp-plus-form2") '("step" "key"))
                                       (txt "not-an-identifier"))))))
  (declare (ignore p))
  (check (eq :path-step-key-not-an-identifier (refusal-code-of r))
         "NC-30 a key step operand that is not an identifier refuses"))

;; NC-24 — an integer datum used where a key is required is discriminated by the
;; TAG, not guessed from the node.  The tags are what make a path independently
;; well-formed.
(multiple-value-bind (p r)
    (propose :path (sq (list (sq (list (idr '("lisp-plus-form2") '("step" "key"))
                                       (num 3))))))
  (declare (ignore p))
  (check (eq :path-step-key-not-an-identifier (refusal-code-of r))
         "NC-24 an INTEGER in a key step refuses — tags discriminate, nothing is inferred"))

(multiple-value-bind (p r)
    (propose :path (sq (list (sq (list (idr '("lisp-plus-form2") '("step" "index"))
                                       (txt "three"))))))
  (declare (ignore p))
  (check (eq :path-index-not-a-nonnegative-integer (refusal-code-of r))
         "an index step operand that is not an integer refuses"))

(multiple-value-bind (p r)
    (propose :path (sq (list (sq (list (idr '("lisp-plus-form2") '("step" "index"))
                                       (num -1))))))
  (declare (ignore p))
  (check (eq :path-index-not-a-nonnegative-integer (refusal-code-of r))
         "a negative index refuses"))

(multiple-value-bind (p r)
    (propose :path (sq (list (sq (list (idr '("demo") '("bogus" "tag")) (num 0))))))
  (declare (ignore p))
  (check (eq :path-step-kind-unknown (refusal-code-of r)) "an unknown step tag refuses"))

(multiple-value-bind (p r) (propose :path (sq (list (txt "not-a-step"))))
  (declare (ignore p))
  (check (eq :path-step-not-a-sequence (refusal-code-of r)) "a non-sequence step refuses"))

(multiple-value-bind (p r) (propose :path (sq (list (sq (list (num 1))))))
  (declare (ignore p))
  (check (eq :path-step-arity (refusal-code-of r)) "a step that is not [kind, operand] refuses"))

(multiple-value-bind (p r) (propose :path (txt "not-a-path"))
  (declare (ignore p))
  (check (eq :path-not-a-sequence (refusal-code-of r)) "a non-sequence path refuses"))

(multiple-value-bind (p r)
    (propose :path (pathd (loop repeat 33 collect (f2 index-step 0))))
  (declare (ignore p))
  (check (eq :path-depth-exceeded (refusal-code-of r)) "a path deeper than 32 refuses"))

;;; ==================================================================
(section "V. THE PROPOSAL GRAMMAR")
;;; ==================================================================

(multiple-value-bind (p r) (f2 try-propose-replacement 17)
  (declare (ignore p))
  (check (eq :proposal-not-a-datum (refusal-code-of (note-code r)))
         "a non-datum argument refuses at the boundary"))
(multiple-value-bind (p r) (f2 try-propose-replacement (txt "flat"))
  (declare (ignore p))
  (check (eq :proposal-node-not-a-sequence (refusal-code-of (note-code r)))
         "a non-sequence proposal node refuses"))
(multiple-value-bind (p r) (f2 try-propose-replacement (sq (list (txt "one-element"))))
  (declare (ignore p))
  (check (eq :proposal-node-arity (refusal-code-of (note-code r)))
         "a proposal node that is not [head, body] refuses"))
(multiple-value-bind (p r)
    (f2 try-propose-replacement (sq (list (txt "head-not-id") (rec '()))))
  (declare (ignore p))
  (check (eq :head-not-identifier (refusal-code-of (note-code r)))
         "a non-identifier head refuses"))
(multiple-value-bind (p r)
    (f2 try-propose-replacement (sq (list (idr '("other") '("production")) (rec '()))))
  (declare (ignore p))
  (check (eq :not-a-replacement-proposal (refusal-code-of (note-code r)))
         "a head naming no Form /2 production refuses"))
(multiple-value-bind (p r)
    (f2 try-propose-replacement
        (sq (list (idr '("lisp-plus-form2") '("replace" "at-path")) (txt "not-a-record"))))
  (declare (ignore p))
  (check (eq :proposal-body-not-a-record (refusal-code-of (note-code r)))
         "a non-record body refuses"))
(multiple-value-bind (p r)
    (f2 try-propose-replacement
        (sq (list (idr '("lisp-plus-form2") '("replace" "at-path"))
                  (rec (list (cons (idr '("lisp-plus-form2") '("field" "input")) (tree)))))))
  (declare (ignore p))
  (check (eq :proposal-field-missing (refusal-code-of (note-code r)))
         "a missing required field refuses — INCLUDING the occurrence tag"))
(multiple-value-bind (p r)
    (f2 try-propose-replacement
        (sq (list (idr '("lisp-plus-form2") '("replace" "at-path"))
                  (rec (list (cons (idr '("lisp-plus-form2") '("field" "bogus")) (tree)))))))
  (declare (ignore p))
  (check (eq :proposal-field-unknown (refusal-code-of (note-code r)))
         "an unknown field refuses"))

;;; ==================================================================
(section "VI. POLICY CEILINGS — and why the two non-datum ones exist")
;;; ==================================================================

(desk "input ~D · output ~D · path ~D · tag ~D · depth ~D · envelope ~D · reserve ~D"
      (f2 transformation-policy-max-input-octets)
      (f2 transformation-policy-max-output-octets)
      (f2 transformation-policy-max-path-octets)
      (f2 transformation-policy-max-occurrence-tag-octets)
      (f2 transformation-policy-max-path-depth)
      (f2 transformation-policy-max-identity-octets)
      (f2 transformation-policy-identity-tail-reserve-octets))

(multiple-value-bind (p r)
    (propose :input (sq (list (txt (make-string 17000 :initial-element #\x)))))
  (declare (ignore p))
  (check (eq :input-octets-exceeded (refusal-code-of r)) "an over-ceiling input refuses"))

;; NC-46 — the two non-datum ceilings.  Without them the envelope relation is
;; UNFALSIFIABLE: an unbounded tag or path can consume any margin.
(multiple-value-bind (p r) (propose :tag (txt (make-string 2000 :initial-element #\t)))
  (declare (ignore p))
  (check (eq :occurrence-tag-octets-exceeded (refusal-code-of r))
         "NC-46 an over-ceiling occurrence tag refuses"))
(multiple-value-bind (p r)
    (propose :path (pathd (loop repeat 30 collect
                                (f2 key-step (idr (list (make-string 120 :initial-element #\k))
                                                  (list (make-string 120 :initial-element #\p)))))))
  (declare (ignore p))
  (check (eq :path-octets-exceeded (refusal-code-of r))
         "NC-46 an over-ceiling encoded path refuses"))

;; NC-28 — output ceiling checked before the successor is observable.
(let ((big (txt (make-string 17000 :initial-element #\y))))
  (multiple-value-bind (s rc r) (apply-ok :replacement big)
    (declare (ignore rc))
    (check (and (null s) (eq :output-octets-exceeded (refusal-code-of r)))
           "NC-28 an over-ceiling successor refuses and is never returned")))

;; :IDENTITY-OCTETS-EXCEEDED — reachable because EXPECTED-OLD and REPLACEMENT
;; carry no octet ceiling of their own; only the INPUT does.  The identity
;; ceiling is what bounds them, which is worth knowing rather than assuming.
(multiple-value-bind (p r)
    (propose :expected (txt (make-string 40000 :initial-element #\e))
             :replacement (txt (make-string 40000 :initial-element #\r)))
  (declare (ignore p))
  (check (eq :identity-octets-exceeded (refusal-code-of r))
         "an over-envelope proposal identity refuses at door 1"))

;; :REBUILD-RECORD-KEY-WORK-EXCEEDED — UNREACHABLE from the public API under
;; these ceilings (CD/0's record-key budget is 1,048,576; the input ceiling is
;; 16,384), so the reclassification path is exercised by a planted fault.  The
;; handler is kept because the ceilings are POLICY and may change.
(let ((lisp-plus-form2::*%fault-rebuild-cd0-failure* t))
  (multiple-value-bind (s rc r) (apply-ok)
    (check (and (null s) (null rc) r) "a CD/0 rebuild budget failure produces no successor")
    (check (eq :rebuild-record-key-work-exceeded (refusal-code-of (note-code r)))
           "it is reclassified under a Form /2 code, not left as a raw CD/0 failure")
    (check (equal "host-import" (f2 form-transformation-refusal-upstream-stage r))
           "and CD/0's own stage label 'host-import' is PRESERVED, not corrected away")
    (check (equal "ResourceRefusal" (f2 form-transformation-refusal-upstream-category r))
           "the upstream category is retained")
    (check (equal "RecordKeyWorkBudgetExceeded" (f2 form-transformation-refusal-upstream-code r))
           "the upstream code is retained")))

;;; ==================================================================
(section "VII. THREE IDENTITIES — a tag is not an occurrence")
;;; ==================================================================

(multiple-value-bind (p1) (propose :tag (txt "tag-A"))
  (multiple-value-bind (p2) (propose :tag (txt "tag-B"))
    (check (not (same (f2 replacement-proposal-identity p1)
                      (f2 replacement-proposal-identity p2)))
           "NC-39 two identical proposals with distinct tags have distinct proposal identities")))

(multiple-value-bind (p1) (propose :tag (txt "same-tag"))
  (multiple-value-bind (p2) (propose :tag (txt "same-tag"))
    (check (same (f2 replacement-proposal-identity p1)
                 (f2 replacement-proposal-identity p2))
           "NC-40 identical tags give identical identities — an UNDETECTED HOST ERROR, declared")))

;; NC-38 — a refused application mints NO occurrence identity.  Not null, not
;; absent-marked: the object does not come into existence.
(multiple-value-bind (s rc r) (apply-ok :expected (txt "WRONG"))
  (check (and (null s) (null rc) r)
         "NC-38 a refused application produces no receipt, hence no occurrence identity"))

(multiple-value-bind (s rc r) (apply-ok)
  (declare (ignore s r))
  (check (not (same (f2 form-transformation-receipt-occurrence-identity rc)
                    (f2 form-transformation-receipt-identity rc)))
         "occurrence identity and receipt identity are distinct")
  (check (not (same (f2 form-transformation-receipt-proposal-identity rc)
                    (f2 form-transformation-receipt-occurrence-identity rc)))
         "proposal identity and occurrence identity are distinct")
  (check (not (same (f2 form-transformation-receipt-input-datum-identity rc)
                    (f2 form-transformation-receipt-output-datum-identity rc)))
         "input and output datum identities are distinct"))

;;; ==================================================================
(section "VIII. THE DERIVED PROJECTIONS — and their three planted faults")
;;; ==================================================================

(multiple-value-bind (s rc r) (apply-ok)
  (declare (ignore r))
  (check (string= (hex (f2 form-transformation-receipt-output-datum-identity rc))
                  (hex (cd0 make-bytes-datum (cd0 canonical-octets s))))
         "the stored output identity IS the identity of the returned successor")
  (check (same (f2 form-transformation-receipt-observed-old rc)
               (f2 form-transformation-receipt-expected-old rc))
         "on a lawful transition observed-old equals expected-old, by precondition"))

;; NC-41 / NC-42 / NC-43 — the three integrity alarms.  Each is reachable ONLY
;; from inside this package.  A verification with no failure path is not a
;; verification.
(let ((lisp-plus-form2::*%fault-observed-old* (txt "PLANTED-WRONG-OBSERVED")))
  (multiple-value-bind (s rc r) (apply-ok)
    (check (and (null s) (null rc) r) "NC-41 planted wrong observed-old produces NO receipt")
    (check (eq :observed-old-projection-mismatch (refusal-code-of (note-code r)))
           "NC-41 with the integrity code")))

(let ((lisp-plus-form2::*%fault-output-identity*
        (cd0 make-bytes-datum (cd0 canonical-octets (txt "PLANTED-WRONG-OUTPUT")))))
  (multiple-value-bind (s rc r) (apply-ok)
    (check (and (null s) (null rc) r) "NC-42 planted wrong output identity produces NO receipt")
    (check (eq :output-identity-projection-mismatch (refusal-code-of (note-code r)))
           "NC-42 with the integrity code")))

(let ((lisp-plus-form2::*%fault-procedure-version* 99))
  (multiple-value-bind (s rc r) (apply-ok)
    (check (and (null s) (null rc) r) "NC-43 a misversioned procedure produces NO receipt")
    (check (eq :procedure-version-mismatch (refusal-code-of (note-code r)))
           "NC-43 with the integrity code")))

;; and the teeth are not stuck on: with the faults unbound, the same call is green
(multiple-value-bind (s rc r) (apply-ok)
  (check (and s rc (null r)) "with no planted fault the same transformation is green"))

;;; ==================================================================
(section "IX. IDENTITY CENSUS — MULTI-AXIS, with a merged-field boundary fault")
;;; ==================================================================

;; NC-45 — THE MERGED-FIELD BOUNDARY.  A one-axis-at-a-time sensitivity suite
;; returns a clean sheet on a broken layer: "a"‖"bc" = "abc" = "ab"‖"c".  These
;; two proposals differ ONLY by where the boundary between two ADJACENT
;; committed fields falls.  If the identity composition merged them, they would
;; collide.
(let ((a (nth-value 0 (propose :expected (txt "a") :replacement (txt "bc"))))
      (b (nth-value 0 (propose :expected (txt "ab") :replacement (txt "c")))))
  (check (and a b) "merged-field fixtures both propose")
  (check (not (same (f2 replacement-proposal-identity a)
                    (f2 replacement-proposal-identity b)))
         "NC-45 adjacent-field boundary shift changes the identity — fields are NOT merged"))

;; A finite multi-axis census: tag × path × expected × replacement.
(let ((identities (make-hash-table :test #'equalp))
      (population 0))
  (dolist (tag (list (txt "t1") (txt "t2") (txt "t3")))
    (dolist (path (list (f2 path-datum (f2 index-step 1))
                        (f2 path-datum (f2 index-step 2) (f2 key-step (idr '("demo") '("k1"))))
                        (f2 path-datum (f2 index-step 2) (f2 key-step (idr '("demo") '("k2"))))))
      (dolist (expected (list (txt "a") (txt "ab") (txt "abc")))
        (dolist (replacement (list (txt "z") (txt "yz") (txt "xyz")))
          (incf population)
          (multiple-value-bind (p r) (propose :tag tag :path path
                                              :expected expected :replacement replacement)
            (declare (ignore r))
            (when p
              (setf (gethash (cd0 canonical-octets (f2 replacement-proposal-identity p))
                             identities)
                    t)))))))
  (desk "census population ~D · distinct proposal identities ~D · collisions ~D"
        population (hash-table-count identities) (- population (hash-table-count identities)))
  (check (= population (hash-table-count identities))
         "multi-axis census: 0 collisions over the enumerated domain"))

;; identity round trip
(multiple-value-bind (s rc r) (apply-ok)
  (declare (ignore s r))
  (let ((id (f2 form-transformation-receipt-identity rc)))
    (check (same id (cd0 decode-exact (cd0 canonical-octets id)))
           "an identity value survives a CD/0 encode/decode round trip")))

;;; ==================================================================
(section "X. READER ALIASING AND MUTABILITY")
;;; ==================================================================

(multiple-value-bind (s rc r) (apply-ok)
  (declare (ignore s r))
  (let ((d1 (f2 form-transformation-receipt-path rc)))
    (check (same d1 (f2 form-transformation-receipt-path rc))
           "NC-17 repeated reads of an aggregate reader agree")))

(multiple-value-bind (s rc r) (apply-ok :expected (txt "WRONG"))
  (declare (ignore s rc))
  (let* ((d1 (f2 form-transformation-refusal-detail r))
         (d2 (f2 form-transformation-refusal-detail r)))
    (check (and (string= d1 d2) (not (eq d1 d2)))
           "NC-17 the refusal detail reader returns a FRESH string each time")
    (fill d1 #\!)
    (check (string/= d1 (f2 form-transformation-refusal-detail r))
           "NC-17 mutating a returned detail cannot edit the retained refusal")))

(let ((n1 (f2 transformation-refusal-code-entry-note
               (first (f2 transformation-refusal-code-catalog))))
      (n2 (f2 transformation-refusal-code-entry-note
               (first (f2 transformation-refusal-code-catalog)))))
  (check (not (eq n1 n2)) "NC-17 catalogue notes are fresh copies"))

;;; ==================================================================
(section "XI. THE CATALOGUE — every advertised code has a fixture")
;;; ==================================================================

(let* ((catalog (f2 transformation-refusal-code-catalog))
       (protocol (f2 transformation-protocol-refusal-codes))
       (alarms (f2 transformation-integrity-alarm-codes))
       (declared (append protocol alarms)))
  (desk "catalogue ~D · protocol ~D · integrity alarms ~D"
        (length catalog) (length protocol) (length alarms))
  (check (= (length catalog) (length declared))
         "the two derived lists partition the catalogue exactly")
  (check (null (intersection protocol alarms))
         "the two classes are disjoint")
  (check (plusp (length alarms))
         "the integrity-alarm class is POPULATED — not promised and left empty")
  ;; NC-19 — set difference empty BOTH ways.
  (let ((missing (set-difference declared *codes-produced*))
        (extra (set-difference *codes-produced* declared)))
    (when missing (desk "declared but NOT produced: ~{~A~^ ~}" missing))
    (when extra (desk "produced but NOT declared: ~{~A~^ ~}" extra))
    (check (null missing) "NC-19 every declared code was produced by a fixture")
    (check (null extra) "NC-19 every produced code is declared")))

;;; ==================================================================
(section "XII. THE ESCAPE — an unexpected condition is NOT a refusal")
;;; ==================================================================

;; NC-18 — Form /2 catches exactly one documented CD/0 class.  Anything else
;; escapes rather than being laundered into a transformation refusal.  Here a
;; caller hands a proposal built with a deliberately unencodable host object;
;; CD/0 signals, and the condition reaches the caller as itself.
(check (handler-case
           (progn (f2 replacement-proposal-datum
                      :input (tree) :path (f2 path-datum)
                      :expected-old (tree) :replacement 'not-a-datum
                      :occurrence-tag (txt "t"))
                  nil)
         (#.(intern "CD0-FAILURE" '#:lisp-plus-cd0) (c)
           (declare (ignore c)) t))
       "NC-18 a CD/0 host failure ESCAPES as itself; it does not become a Form /2 refusal")

;;; ==================================================================
(section "XIII. RESOURCE MEASUREMENT — reported, never rolled up")
;;; ==================================================================

(defun measure (label &key input path expected replacement occurrence-tag)
  (multiple-value-bind (p r) (f2 try-propose-replacement
                                 (f2 replacement-proposal-datum
                                     :input input :path path :expected-old expected
                                     :replacement replacement :occurrence-tag occurrence-tag))
    (if r
        (progn (desk "~24A REFUSED ~A" label (refusal-code-of r)) nil)
        (multiple-value-bind (s rc r2) (f2 try-apply-replacement p)
          (if r2
              (progn (desk "~24A REFUSED ~A" label (refusal-code-of r2)) nil)
              (progn
                (desk "~24A datum ~6D  path ~5D  tag ~5D | prop ~6D  occ ~6D  receipt ~6D"
                      label
                      (cd0 octets-length (cd0 canonical-octets input))
                      (cd0 octets-length (cd0 canonical-octets path))
                      (cd0 octets-length (cd0 canonical-octets occurrence-tag))
                      (f2 identity-octets (f2 replacement-proposal-identity p))
                      (f2 identity-octets (f2 form-transformation-receipt-occurrence-identity rc))
                      (f2 identity-octets (f2 form-transformation-receipt-identity rc)))
                (list (f2 identity-octets (f2 form-transformation-receipt-identity rc))
                      s)))))))

(desk "all octet counts are of the identity VALUE, never of a hex rendering")
(defparameter *measurements* '())

(macrolet ((m (&rest args) `(let ((r (measure ,@args))) (when r (push (first r) *measurements*)))))
  ;; smallest lawful
  (m "smallest lawful"
     :input (sq (list (txt "a") (txt "b"))) :path (f2 path-datum (f2 index-step 0))
     :expected (txt "a") :replacement (txt "c") :occurrence-tag (txt "t"))
  ;; the inhabited shape
  (m "inhabited-ish"
     :input (tree) :path (f2 path-datum (f2 index-step 1))
     :expected (txt "alpha") :replacement (txt "GAMMA") :occurrence-tag (txt "tag-0001"))
  ;; EMPTY ROOT PATH at the largest lawful input, with DIFFERENT but equal-size
  ;; expected and replacement — a LAWFUL event, unlike the pre-amendment probe
  ;; which measured a no-op this layer now refuses.
  ;; DRIVEN TO THE ACTUAL ADMITTED CEILING, not to a comfortable fixture.  An
  ;; earlier draft of this very suite used 8,100 and reported a 2.50x margin —
  ;; the same fixture-maximum error the Form /1 stranger auditor found, made a
  ;; third time, in the file whose job is to catch it.
  (let* ((big-a (sq (list (txt (make-string 16360 :initial-element #\a)))))
         (big-b (sq (list (txt (make-string 16360 :initial-element #\b))))))
    (m "root path, max lawful"
       :input big-a :path (f2 path-datum)
       :expected big-a :replacement big-b :occurrence-tag (txt "t"))
    ;; root-child comparison at the same size
    (m "root child, max lawful"
       :input (sq (list (txt (make-string 16360 :initial-element #\a))))
       :path (f2 path-datum (f2 index-step 0))
       :expected (txt (make-string 16360 :initial-element #\a))
       :replacement (txt (make-string 16360 :initial-element #\b))
       :occurrence-tag (txt "t")))
  ;; maximum tag
  (m "max lawful tag"
     :input (tree) :path (f2 path-datum (f2 index-step 1))
     :expected (txt "alpha") :replacement (txt "GAMMA")
     :occurrence-tag (txt (make-string 900 :initial-element #\t)))
  ;; maximum depth
  (let* ((leaf (txt "L"))
         (deep leaf))
    (dotimes (i 30) (setf deep (sq (list deep))))
    (let ((steps (loop repeat 30 collect (f2 index-step 0))))
      (m "max depth (30)"
         :input deep :path (pathd steps)
         :expected leaf :replacement (txt "M") :occurrence-tag (txt "t"))))
  ;; replacement LARGER than the removed subtree
  (m "replacement > removed"
     :input (tree) :path (f2 path-datum (f2 index-step 1))
     :expected (txt "alpha") :replacement (txt (make-string 4000 :initial-element #\g))
     :occurrence-tag (txt "t"))
  ;; wide record spine
  (let ((wide (rec (loop for i below 200
                         collect (cons (idr '("w") (list (format nil "k~3,'0D" i)))
                                       (txt (format nil "v~D" i)))))))
    (m "wide record (200)"
       :input (sq (list wide)) :path (f2 path-datum (f2 index-step 0)
                                          (f2 key-step (idr '("w") '("k000"))))
       :expected (txt "v0") :replacement (txt "V0!") :occurrence-tag (txt "t")))
  ;; deep record spine
  (let* ((leaf (txt "deep"))
         (node leaf))
    (dotimes (i 20) (setf node (rec (list (cons (idr '("d") '("next")) node)))))
    (let ((steps (loop repeat 20 collect (f2 key-step (idr '("d") '("next"))))))
      (m "deep record (20)"
         :input node :path (pathd steps)
         :expected leaf :replacement (txt "DEEP") :occurrence-tag (txt "t")))))

(let ((worst (if *measurements* (reduce #'max *measurements*) 0))
      (ceiling (- (f2 transformation-policy-max-identity-octets)
                  (f2 transformation-policy-identity-tail-reserve-octets))))
  (desk "LARGEST RECEIPT IDENTITY MEASURED over the enumerated fixtures: ~:D octets" worst)
  (desk "envelope ~:D · reserve ~:D · ceiling ~:D · margin ~,2Fx"
        (f2 transformation-policy-max-identity-octets)
        (f2 transformation-policy-identity-tail-reserve-octets)
        ceiling (if (plusp worst) (/ ceiling worst) 0))
  (desk "NOT a global maximum: the admissible domain has not been bounded and searched.")
  (check (<= worst ceiling)
         "every measured receipt identity fits envelope minus reserve"))

;;; ==================================================================
(section "XIV. WHAT THIS SUITE DOES NOT ESTABLISH")
;;; ==================================================================

(desk "It does not establish semantic preservation, equivalence or correctness.")
(desk "It does not establish that any predicate here measures its English label.")
(desk "It does not establish completeness, order, unique lineage or authenticity")
(desk "  of any receipt SET — a receipt is an edge, and an account, not an")
(desk "  authentication (work order §8.2).")
(desk "It does not establish that a global maximum was found (§9.4c).")
(desk "Every green above is SELF-CONSISTENCY CERTIFICATION by the family that")
(desk "  wrote the layer.  The stranger audit is OWED.")

(format t "~%== form2-selftest: ~D checks passed / ~D failed ==~%"
        (- *checks* *failed*) *failed*)
(when (plusp *failed*) (sb-ext:exit :code 1))
