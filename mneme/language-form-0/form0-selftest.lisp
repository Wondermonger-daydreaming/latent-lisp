;;;; form0-selftest.lisp — Language Form /0, Candidate /0: the teeth.
;;;;
;;;; Run: sbcl --non-interactive --load form0-selftest.lisp
;;;;
;;;; Every check below is either NATURALLY REACHABLE through the public API or
;;;; fired by a PLANTED FAULT that reaches an internal constructor on purpose.
;;;; Planted checks say so in their own name, because a gate that has never
;;;; fired is untested rather than passing.

(load (merge-pathnames "form0.lisp" *load-truename*))

(defpackage #:form0-selftest (:use #:cl #:lisp-plus-form0))
(in-package #:form0-selftest)

(defmacro cd0 (name &rest arguments)
  `(,(intern (string name) :lisp-plus-cd0) ,@arguments))

(defparameter *passed* 0)
(defparameter *failed* 0)

(defun ok (label)
  (incf *passed*)
  (format t "  ok   ~A~%" label))

(defun check (condition label)
  (if condition
      (ok label)
      (progn (incf *failed*)
             (format t "  FAIL ~A~%" label))))

(defun check-refusal (refusal expected-code label)
  "A refusal must exist, carry EXPECTED-CODE, and be a readable object."
  (cond
    ((null refusal)
     (incf *failed*)
     (format t "  FAIL ~A  (no refusal was produced)~%" label))
    ((not (eq (form-refusal-code refusal) expected-code))
     (incf *failed*)
     (format t "  FAIL ~A  (expected ~S, got ~S: ~A)~%"
             label expected-code (form-refusal-code refusal)
             (form-refusal-detail refusal)))
    ((zerop (length (form-refusal-identity refusal)))
     (incf *failed*)
     (format t "  FAIL ~A  (refusal carries no identity)~%" label))
    (t (ok label))))

;;; ------------------------------------------------------------------
;;; The operator SELECTION.  The handlers live in the package now.

(defun standard-operators ()
  "A SELECTION of package-owned operator names.  Since chair review 1 there is no
public way to supply a handler, so this is a list of strings, not descriptors."
  (list "equal-datum" "canonical-hex" "sequence-length" "render-diagnostic"))

(defun standard-holes ()
  (list (make-form-hole "left" :integer)
        (make-form-hole "right" :integer)
        (make-form-hole "subject" :any)))

(defun sealed-environment (&key (name "form0-selftest") (version 1))
  (seal-form-environment
   (make-form-environment :name name :version version
                          :operators (standard-operators)
                          :holes (standard-holes))))

(defparameter *env* (sealed-environment))

(format t "~%══ Language Form /0 — Candidate /0 — teeth ══~%~%")

;;; ══════════════════════════════════════════════════════════════════
(format t " [boundary]~%")

;;; T-HOST-SYMBOL-REFUSED — a host symbol is not a durable operator or form.
(multiple-value-bind (form refusal) (try-propose-form 'perform *env*)
  (check (null form) "T-HOST-SYMBOL-REFUSED/no-form")
  (check-refusal refusal :not-a-datum
                 "T-HOST-SYMBOL-REFUSED a host symbol never crosses the durable boundary"))

;;; The same for a host list, a string, and a function object.
(dolist (host (list '(:op :equal-datum 1 2) "(op equal-datum 1 2)" #'identity))
  (multiple-value-bind (form refusal) (try-propose-form host *env*)
    (declare (ignore form))
    (check (and refusal (eq (form-refusal-code refusal) :not-a-datum))
           (format nil "T-HOST-SYMBOL-REFUSED host ~(~A~) refused at the boundary"
                   (type-of host)))))

;;; T-NO-RAW-FUNCTION — a candidate cannot carry a host function at all: no CD/0
;;; family admits one, so the refusal happens in CD/0's own constructor.
(check (handler-case (progn (cd0 make-sequence-datum (list #'identity)) nil)
         (error () t))
       "T-NO-RAW-FUNCTION no CD/0 family can carry a host function")

;;; T-ENVIRONMENT-NOT-SEALED
(multiple-value-bind (form refusal)
    (try-propose-form (literal-node (cd0 make-integer-datum 1))
                      (make-form-environment :name "unsealed" :version 1
                                             :operators (standard-operators)
                                             :holes (standard-holes)))
  (declare (ignore form))
  (check-refusal refusal :environment-not-sealed
                 "T-ENVIRONMENT-NOT-SEALED an unsealed environment admits nothing"))

;;; T-SEAL-DOES-NOT-MUTATE
(let* ((open (make-form-environment :name "seal-test" :version 1
                                    :operators (standard-operators)
                                    :holes (standard-holes)))
       (sealed (seal-form-environment open)))
  (check (and (not (form-environment-sealed-p open))
              (form-environment-sealed-p sealed)
              (not (eq open sealed)))
         "T-SEAL-DOES-NOT-MUTATE sealing returns a new object and leaves its argument open"))

;;; ══════════════════════════════════════════════════════════════════
(format t "~% [grammar]~%")

;;; T-UNKNOWN-PRODUCTION — a head outside the three productions.
(multiple-value-bind (form refusal)
    (try-propose-form
     (cd0 make-sequence-datum
          (list (cd0 make-identifier-datum '("some-other-language") '("if"))
                (cd0 make-integer-datum 1)))
     *env*)
  (declare (ignore form))
  (check-refusal refusal :unknown-production
                 "T-UNKNOWN-PRODUCTION a foreign head heads no production"))

;;; T-MALFORMED-RETAINED — malformed candidates become inspectable refusals.
(defparameter *malformed-refusals* '())

(dolist (probe (list
                (list (cd0 make-integer-datum 5) :unknown-production
                      "a bare integer is not a node")
                (list (cd0 make-sequence-datum '()) :empty-node
                      "an empty sequence is not a node")
                (list (cd0 make-sequence-datum (list (cd0 make-integer-datum 5)))
                      :head-not-identifier "a non-identifier head")
                (list (cd0 make-sequence-datum
                           (list (lisp-plus-form0::%lit-head)
                                 (cd0 make-integer-datum 1)
                                 (cd0 make-integer-datum 2)))
                      :literal-arity "a two-payload literal")
                (list (cd0 make-sequence-datum
                           (list (lisp-plus-form0::%hole-head)
                                 (cd0 make-integer-datum 1)))
                      :hole-name-not-identifier "a non-identifier hole name")))
  (destructuring-bind (candidate expected label) probe
    (multiple-value-bind (form refusal) (try-propose-form candidate *env*)
      (declare (ignore form))
      (when refusal (push refusal *malformed-refusals*))
      (check-refusal refusal expected
                     (format nil "T-MALFORMED-RETAINED ~A" label)))))

(check (every (lambda (refusal)
                (and (form-refusal-detail refusal)
                     (plusp (length (form-refusal-identity refusal)))))
              *malformed-refusals*)
       "T-MALFORMED-RETAINED every refusal is an object with detail and identity")

;;; The offending datum is retained, not merely described.
(let ((refusal (find :unknown-production *malformed-refusals*
                     :key #'form-refusal-code)))
  (check (and refusal (cd0 datum-p (form-refusal-offending refusal)))
         "T-MALFORMED-RETAINED the offending datum survives inside the refusal"))

;;; ══════════════════════════════════════════════════════════════════
(format t "~% [operators]~%")

(defparameter *ok-candidate*
  (operator-node "equal-datum" (hole-node "left") (hole-node "right")))

;;; T-OPERATOR-UNKNOWN — grammar-lawful, environment-unknown.  Admission
;;; succeeds (the grammar is satisfied); validation refuses.
(defparameter *unknown-op-candidate*
  (operator-node "invent-a-truth"
                 (literal-node (cd0 make-integer-datum 1))))

(defparameter *unknown-op-proposal*
  (propose-form *unknown-op-candidate* *env*))

(check (proposed-form-p *unknown-op-proposal*)
       "T-OPERATOR-UNKNOWN a lawful shape is admitted under the grammar")

(defparameter *unknown-op-refusal*
  (multiple-value-bind (instantiated refusal)
      (try-instantiate-form *unknown-op-proposal* '() *env*)
    (declare (ignore refusal))
    (multiple-value-bind (validated validation-refusal)
        (try-validate-form instantiated *env*)
      (declare (ignore validated))
      validation-refusal)))

(check-refusal *unknown-op-refusal* :unknown-operator
               "T-OPERATOR-UNKNOWN an uninstalled operator is refused at validation")

;;; T-FORBIDDEN-OPERATOR — the consequential names are not merely absent from
;;; this environment; nothing in the layer could install them, because each
;;; would need a handler the operator allowlist does not provide.
(dolist (name '("perform" "eval" "compile" "load" "establish-source-basis"
                "mint-capability" "derive"))
  (let* ((candidate (operator-node name (literal-node (cd0 make-integer-datum 1))))
         (proposal (propose-form candidate *env*))
         (instantiated (instantiate-form proposal '() *env*)))
    (multiple-value-bind (validated refusal) (try-validate-form instantiated *env*)
      (declare (ignore validated))
      (check (and refusal (eq (form-refusal-code refusal) :unknown-operator))
             (format nil "T-FORBIDDEN-OPERATOR ~A is refused" name)))))

;;; T-OPERATOR-ARITY
(multiple-value-bind (validated refusal)
    (try-validate-form
     (instantiate-form
      (propose-form (operator-node "canonical-hex"
                                   (literal-node (cd0 make-integer-datum 1))
                                   (literal-node (cd0 make-integer-datum 2)))
                    *env*)
      '() *env*)
     *env*)
  (declare (ignore validated))
  (check-refusal refusal :operator-arity
                 "T-OPERATOR-ARITY a wrong-arity call is refused at validation"))

;;; ══════════════════════════════════════════════════════════════════
(format t "~% [holes]~%")

(defparameter *proposal* (propose-form *ok-candidate* *env*))

(check (= 2 (length (proposed-form-hole-identities *proposal*)))
       "the candidate mentions exactly two holes")

;;; T-UNDECLARED-HOLE
(let ((bare (seal-form-environment
             (make-form-environment :name "no-holes" :version 1
                                    :operators (standard-operators)
                                    :holes '()))))
  (multiple-value-bind (instantiated refusal)
      (try-instantiate-form (propose-form *ok-candidate* bare)
                            (list (cons "left" (cd0 make-integer-datum 1)))
                            bare)
    (declare (ignore instantiated))
    (check-refusal refusal :undeclared-hole
                   "T-UNDECLARED-HOLE a hole the environment never declared is refused")))

;;; T-UNFILLED-HOLE
(multiple-value-bind (instantiated refusal)
    (try-instantiate-form *proposal*
                          (list (cons "left" (cd0 make-integer-datum 1)))
                          *env*)
  (declare (ignore instantiated))
  (check-refusal refusal :unfilled-hole
                 "T-UNFILLED-HOLE a mentioned hole with no binding is refused"))

;;; T-EXTRA-BINDING
(multiple-value-bind (instantiated refusal)
    (try-instantiate-form *proposal*
                          (list (cons "left" (cd0 make-integer-datum 1))
                                (cons "right" (cd0 make-integer-datum 2))
                                (cons "subject" (cd0 make-integer-datum 3)))
                          *env*)
  (declare (ignore instantiated))
  (check-refusal refusal :extra-binding
                 "T-EXTRA-BINDING a binding the form does not mention is refused"))

;;; T-DUPLICATE-BINDING
(multiple-value-bind (instantiated refusal)
    (try-instantiate-form *proposal*
                          (list (cons "left" (cd0 make-integer-datum 1))
                                (cons "left" (cd0 make-integer-datum 9))
                                (cons "right" (cd0 make-integer-datum 2)))
                          *env*)
  (declare (ignore instantiated))
  (check-refusal refusal :duplicate-binding
                 "T-DUPLICATE-BINDING the same hole cannot be bound twice"))

;;; T-WRONG-SPECIES
(multiple-value-bind (instantiated refusal)
    (try-instantiate-form *proposal*
                          (list (cons "left" (cd0 make-string-datum "seven"))
                                (cons "right" (cd0 make-integer-datum 2)))
                          *env*)
  (declare (ignore instantiated))
  (check-refusal refusal :wrong-species
                 "T-WRONG-SPECIES a string cannot fill an integer hole"))

;;; T-BINDING-NOT-A-DATUM
(multiple-value-bind (instantiated refusal)
    (try-instantiate-form *proposal*
                          (list (cons "left" 7)
                                (cons "right" (cd0 make-integer-datum 2)))
                          *env*)
  (declare (ignore instantiated))
  (check-refusal refusal :binding-not-a-datum
                 "T-BINDING-NOT-A-DATUM a host integer cannot fill a hole"))

;;; T-ONE-PASS — a value that LOOKS like a hole is inserted as data and is never
;;; scanned again.  The bound value is literally `[hole, subject]`; after
;;; instantiation it must survive as an inert payload, and realization must
;;; hand it back unchanged rather than trying to fill it.
;;;
;;; Every step here uses a TRY- entry point on purpose.  A tooth that aborts the
;;; suite tells a reader less than one that names itself: under a genuine
;;; two-pass mutation the re-scanned value reaches validation as a live hole,
;;; and this block must report that as a named failure rather than a crash.
(let* ((self-similar (hole-node "subject"))
       (candidate (operator-node "render-diagnostic" (hole-node "subject"))))
  (multiple-value-bind (proposal propose-refusal) (try-propose-form candidate *env*)
    (check (and proposal (null propose-refusal))
           "T-ONE-PASS the self-similar candidate is admitted")
    (multiple-value-bind (instantiated instantiate-refusal)
        (try-instantiate-form proposal (list (cons "subject" self-similar)) *env*)
      (check (and instantiated (null instantiate-refusal))
             "T-ONE-PASS the self-similar value instantiates")
      (check (and instantiated
                  (= 1 (length (instantiated-form-binding-identities instantiated))))
             "T-ONE-PASS exactly one binding was consumed")
      (multiple-value-bind (validated validate-refusal)
          (if instantiated (try-validate-form instantiated *env*) (values nil :skipped))
        (check (and validated (null validate-refusal))
               "T-ONE-PASS the inserted hole-shaped datum is inert — no hole survives to validation")
        (multiple-value-bind (result receipt realize-refusal)
            (if validated (try-realize-form validated *env*) (values nil nil :skipped))
          (declare (ignore receipt))
          (check (and (null realize-refusal) result (cd0 string-datum-p result))
                 "T-ONE-PASS a hole-shaped value realizes as data, not as a hole")
          (check (and result (cd0 string-datum-p result)
                      (search "lisp-plus-form0" (cd0 string-datum-value result)))
                 "T-ONE-PASS the inserted hole-shaped datum survives verbatim in the result"))))))

;;; T-SNAPSHOT-IS-INDEPENDENT — admitted data is stored as a canonical round
;;; trip, so the stored tree is a DISTINCT object from the caller's.  Stated at
;;; exactly its true size: CD/0 datums are already immutable, so this buys
;;; object independence, not protection from a mutation CD/0 would have allowed.
(let* ((candidate (literal-node (cd0 make-integer-datum 42)))
       (proposal (propose-form candidate *env*)))
  (check (not (eq (proposed-form-datum proposal) candidate))
         "T-SNAPSHOT-IS-INDEPENDENT the stored tree is not the caller's object")
  (check (cd0 equal-datum (proposed-form-datum proposal) candidate)
         "T-SNAPSHOT-IS-INDEPENDENT the round trip preserves the value exactly"))

;;; ══════════════════════════════════════════════════════════════════
(format t "~% [identity]~%")

(defparameter *bindings*
  (list (cons "left" (cd0 make-integer-datum 7))
        (cons "right" (cd0 make-integer-datum 7))))

(defparameter *instantiated* (instantiate-form *proposal* *bindings* *env*))
(defparameter *validated* (validate-form *instantiated* *env*))

;;; T-IDENTITY-STABLE
(let* ((twin-proposal (propose-form
                       (operator-node "equal-datum"
                                      (hole-node "left") (hole-node "right"))
                       *env*))
       (twin (instantiate-form twin-proposal
                               (list (cons "left" (cd0 make-integer-datum 7))
                                     (cons "right" (cd0 make-integer-datum 7)))
                               *env*)))
  (check (string= (instantiated-form-identity *instantiated*)
                  (instantiated-form-identity twin))
         "T-IDENTITY-STABLE identical canonical forms share one identity")
  (check (string= (proposed-form-identity *proposal*)
                  (proposed-form-identity twin-proposal))
         "T-IDENTITY-STABLE identical proposals share one identity"))

;;; T-IDENTITY-DISCRIMINATES
(let ((different (instantiate-form
                  (propose-form (operator-node "equal-datum"
                                               (hole-node "left")
                                               (hole-node "right"))
                                *env*)
                  (list (cons "left" (cd0 make-integer-datum 7))
                        (cons "right" (cd0 make-integer-datum 8)))
                  *env*)))
  (check (not (string= (instantiated-form-identity *instantiated*)
                       (instantiated-form-identity different)))
         "T-IDENTITY-DISCRIMINATES a different binding is a different form"))

;;; T-CALLER-MUTATION-INERT — the caller's binding list is rebuilt and mutated
;;; after the proposal and after instantiation; neither stored tree moves.
(let ((identity-before (instantiated-form-identity *instantiated*))
      (proposal-before (proposed-form-identity *proposal*)))
  (setf (cdr (first *bindings*)) (cd0 make-integer-datum 999))
  (setf *bindings* (list (cons "left" (cd0 make-string-datum "clobbered"))))
  (check (string= identity-before (instantiated-form-identity *instantiated*))
         "T-CALLER-MUTATION-INERT mutating the binding list cannot move the instantiated form")
  (check (string= proposal-before (proposed-form-identity *proposal*))
         "T-CALLER-MUTATION-INERT mutating the caller's data cannot move the proposal"))

;;; T-PHASES-ARE-DISTINCT-OBJECTS
(check (and (proposed-form-p *proposal*)
            (instantiated-form-p *instantiated*)
            (validated-form-p *validated*)
            (not (proposed-form-p *instantiated*))
            (not (instantiated-form-p *validated*))
            (not (validated-form-p *proposal*)))
       "T-PHASES-ARE-DISTINCT-OBJECTS four phases, four disjoint types, no status slot")

(check (string= (instantiated-form-predecessor-identity *instantiated*)
                (proposed-form-identity *proposal*))
       "T-PHASES-ARE-DISTINCT-OBJECTS each phase names its predecessor by identity")

;;; ══════════════════════════════════════════════════════════════════
(format t "~% [dual identity — subject form vs phase object]~%")

;;; T-DUAL-IDENTITY-SUBJECT-IS-STABLE
(check (string= (instantiated-form-subject-identity *instantiated*)
                (validated-form-subject-identity *validated*))
       "T-DUAL-IDENTITY the CLOSED subject is stable from instantiation to validation")

;;; T-DUAL-IDENTITY-PHASES-ARE-DISTINCT — the load-bearing one.  Object non-EQ
;;; proves nothing; these are content-derived identities in distinct domains.
(let ((identities (list (proposed-form-identity *proposal*)
                        (instantiated-form-identity *instantiated*)
                        (validated-form-identity *validated*))))
  (check (= 3 (length (remove-duplicates identities :test #'string=)))
         "T-DUAL-IDENTITY proposed, instantiated and validated phase identities are three distinct values")
  (check (notany (lambda (phase-identity)
                   (string= phase-identity
                            (validated-form-subject-identity *validated*)))
                 identities)
         "T-DUAL-IDENTITY no phase identity collides with the subject identity"))

;;; The validation receipt is a RECORD OF a validation, not the validated form.
(check (not (string= (form-validation-receipt-identity
                      (validated-form-receipt *validated*))
                     (validated-form-identity *validated*)))
       "T-DUAL-IDENTITY the validation receipt has its own identity, distinct from the validated form")

;;; T-DUAL-IDENTITY-SAME-SYNTAX-DIFFERENT-ENVIRONMENT — the chair's exact case.
(let* ((other-env (sealed-environment :name "a-different-desk"))
       (other-proposal (propose-form *ok-candidate* other-env))
       (other-instantiated
         (instantiate-form other-proposal
                           (list (cons "left" (cd0 make-integer-datum 7))
                                 (cons "right" (cd0 make-integer-datum 7)))
                           other-env))
       (other-validated (validate-form other-instantiated other-env)))
  (check (string= (validated-form-subject-identity other-validated)
                  (validated-form-subject-identity *validated*))
         "T-DUAL-IDENTITY two validations of the same syntax share ONE subject identity")
  (check (not (string= (validated-form-identity other-validated)
                       (validated-form-identity *validated*)))
         "T-DUAL-IDENTITY ...and carry TWO different validated phase identities"))

;;; T-DUAL-IDENTITY-PREDECESSOR-LINKS-ARE-PHASE-OBJECTS
(check (and (string= (validated-form-predecessor-identity *validated*)
                     (instantiated-form-identity *instantiated*))
            (not (string= (validated-form-predecessor-identity *validated*)
                          (instantiated-form-subject-identity *instantiated*))))
       "T-DUAL-IDENTITY predecessor links name the phase object, never merely the shared syntax")

;;; T-DUAL-IDENTITY-NO-CROSS-PHASE-SUBSTITUTION
(check (not (string= (proposed-form-identity *proposal*)
                     (validated-form-identity *validated*)))
       "T-DUAL-IDENTITY a proposed identity cannot stand where a validated identity is required")

;;; T-DUAL-IDENTITY-CONSEQUENTIAL-INPUTS-ARE-COMMITTED — change any one of the
;;; five bound components and the validated phase identity must move.
(let ((baseline (validated-form-identity *validated*)))
  (check (not (string= baseline
                       (validated-form-identity
                        (validate-form *instantiated* (sealed-environment :version 2)))))
         "T-DUAL-IDENTITY a different environment VERSION yields a different validated identity")
  (check (not (string= baseline
                       (validated-form-identity
                        (validate-form
                         (instantiate-form
                          *proposal*
                          (list (cons "left" (cd0 make-integer-datum 7))
                                (cons "right" (cd0 make-integer-datum 8)))
                          *env*)
                         *env*))))
         "T-DUAL-IDENTITY a different BINDING yields a different validated identity"))

;;; The binding environment has its own identity, and it is committed to.
(check (plusp (length (instantiated-form-binding-identity *instantiated*)))
       "T-DUAL-IDENTITY the exact binding environment carries its own identity")

;;; ══════════════════════════════════════════════════════════════════
(format t "~% [template subject → closed subject]~%")

;;; The subject is NOT stable across every phase.  Instantiation consumes a
;;; hole-bearing TEMPLATE and produces a CLOSED form; that is the one step where
;;; the syntax legitimately moves, and the instantiated object records both
;;; sides so the genealogy does not lose it.

(check (string= (proposed-form-subject-identity *proposal*)
                (instantiated-form-template-subject-identity *instantiated*))
       "T-SUBJECT-TEMPLATE the instantiation records the proposal's template subject")

(check (not (string= (instantiated-form-template-subject-identity *instantiated*)
                     (instantiated-form-subject-identity *instantiated*)))
       "T-SUBJECT-MOVES filling holes produces a DIFFERENT closed subject")

(check (string= (instantiated-form-subject-identity *instantiated*)
                (validated-form-subject-identity *validated*))
       "T-SUBJECT-CLOSED instantiated subject = validated subject")


(check (and (string= (instantiated-form-predecessor-identity *instantiated*)
                     (proposed-form-identity *proposal*))
            (plusp (length (instantiated-form-template-subject-identity *instantiated*)))
            (plusp (length (instantiated-form-subject-identity *instantiated*))))
       "T-SUBJECT-BOTH-SIDES the instantiation names its proposal and both subjects")

(let ((other (instantiate-form *proposal*
                               (list (cons "left" (cd0 make-integer-datum 7))
                                     (cons "right" (cd0 make-integer-datum 8)))
                               *env*)))
  (check (string= (instantiated-form-template-subject-identity other)
                  (instantiated-form-template-subject-identity *instantiated*))
         "T-SUBJECT-BINDINGS-DIVERGE both fillings share ONE template subject")
  (check (not (string= (instantiated-form-subject-identity other)
                       (instantiated-form-subject-identity *instantiated*)))
         "T-SUBJECT-BINDINGS-DIVERGE ...and produce DIFFERENT closed subjects")
  (check (not (string= (instantiated-form-identity other)
                       (instantiated-form-identity *instantiated*)))
         "T-SUBJECT-BINDINGS-DIVERGE ...and DIFFERENT instantiated phase identities"))

;;; ══════════════════════════════════════════════════════════════════
(format t "~% [realization boundary]~%")

;;; T-REALIZE-NEEDS-VALIDATION
(multiple-value-bind (result receipt refusal)
    (try-realize-form *proposal* *env*)
  (declare (ignore result receipt))
  (check-refusal refusal :not-validated
                 "T-REALIZE-NEEDS-VALIDATION a proposal cannot be realized"))

(multiple-value-bind (result receipt refusal)
    (try-realize-form *instantiated* *env*)
  (declare (ignore result receipt))
  (check-refusal refusal :not-validated
                 "T-REALIZE-NEEDS-VALIDATION an instantiated form cannot be realized"))

;;; The lawful realization.
(defparameter *result* nil)
(defparameter *receipt* nil)
(multiple-value-setq (*result* *receipt*) (realize-form *validated* *env*))

(check (cd0 boolean-datum-p *result*)
       "the lawful candidate realizes to a boolean datum")
(check (cd0 boolean-datum-value *result*)
       "equal-datum(7,7) realizes as true")

;;; T-RECEIPT-NAMES-THE-FORM
(check (and (string= (form-realization-receipt-validated-identity *receipt*)
                     (validated-form-identity *validated*))
            (string= (form-realization-receipt-instantiated-identity *receipt*)
                     (instantiated-form-identity *instantiated*))
            (string= (validated-form-instantiated-identity *validated*)
                     (instantiated-form-identity *instantiated*)))
       "T-RECEIPT-NAMES-THE-FORM the receipt names exactly the validation that authorized it")

;;; The receipt must bind BOTH — which validation licensed it, AND which exact
;;; syntax was realized.  A receipt naming only the syntax could not say which
;;; validation event authorized that realization.
(check (and (string= (form-realization-receipt-subject-identity *receipt*)
                     (validated-form-subject-identity *validated*))
            (not (string= (form-realization-receipt-subject-identity *receipt*)
                          (form-realization-receipt-validated-identity *receipt*))))
       "T-RECEIPT-NAMES-THE-FORM the receipt binds the subject form AND the validation, as two distinct identities")

(check (string= (form-realization-receipt-environment-content-digest *receipt*)
                (form-environment-content-digest *env*))
       "T-RECEIPT-NAMES-THE-FORM the receipt binds the environment's declared surface")

;;; T-SUBJECT-CLOSED, completed here because it needs the realization receipt:
;;; the closed subject survives validation AND realization unchanged.
(check (string= (validated-form-subject-identity *validated*)
                (form-realization-receipt-subject-identity *receipt*))
       "T-SUBJECT-CLOSED validated subject = realized subject")

(check (string= (form-realization-receipt-result-identity *receipt*)
                (cd0 octets-to-hex (cd0 canonical-octets *result*)))
       "T-RECEIPT-NAMES-THE-FORM the receipt names the exact result")

;;; T-REALIZATION-MINTS-NO-STANDING — the result is a datum and nothing else.
(check (cd0 datum-p *result*)
       "T-REALIZATION-MINTS-NO-STANDING realization yields a datum")
(check (notany (lambda (package-name) (find-package package-name))
               '("LISP-PLUS-SLICE0" "LISP-PLUS-SLICE1" "LISP-PLUS-SLICE2"
                 "LISP-PLUS-CORE0" "LISP-PLUS-KERNEL0"))
       "T-REALIZATION-MINTS-NO-STANDING no claim/basis/capability layer is even loaded")

;;; ══════════════════════════════════════════════════════════════════
(format t "~% [binding drift — the validator's exactness]~%")

;;; T-ENVIRONMENT-VERSION-DRIFT
(multiple-value-bind (result receipt refusal)
    (try-realize-form *validated* (sealed-environment :version 2))
  (declare (ignore result receipt))
  (check-refusal refusal :environment-version-drift
                 "T-ENVIRONMENT-VERSION-DRIFT a version bump refuses realization"))

;;; T-SAME-LOOKING-DIFFERENT-ENVIRONMENT — identical in every respect except
;;; the environment identity.
(multiple-value-bind (result receipt refusal)
    (try-realize-form *validated* (sealed-environment :name "look-alike"))
  (declare (ignore result receipt))
  (check-refusal refusal :environment-identity-drift
                 "T-SAME-LOOKING-DIFFERENT-ENVIRONMENT a validation is not portable between environments"))

;;; T-VALIDATION-NOT-TRANSFERABLE — a validation belongs to one exact form.
(let* ((other (instantiate-form
               (propose-form (operator-node "equal-datum"
                                            (hole-node "left") (hole-node "right"))
                             *env*)
               (list (cons "left" (cd0 make-integer-datum 1))
                     (cons "right" (cd0 make-integer-datum 2)))
               *env*)))
  (check (not (string= (validated-form-subject-identity *validated*)
                       (instantiated-form-subject-identity other)))
         "T-VALIDATION-NOT-TRANSFERABLE a different filling is a different subject form")
  (check (not (string= (validated-form-predecessor-identity *validated*)
                       (instantiated-form-identity other)))
         "T-VALIDATION-NOT-TRANSFERABLE a validation names one instantiation, not a shape"))

;;; T-GRAMMAR-VERSION-DRIFT (PLANTED) — the public constructor always installs
;;; the current grammar version, so this gate is reached by planting an
;;; environment whose grammar version differs.
(let ((planted (lisp-plus-form0::%make-form-environment
                :identity (form-environment-identity *env*)
                :version (form-environment-version *env*)
                :grammar-identity (form-environment-grammar-identity *env*)
                :grammar-version 99
                :operators (standard-operators)
                :holes (standard-holes)
                :budget-id (form-environment-budget-id *env*)
                :content-digest (form-environment-content-digest *env*)
                :sealed-p t)))
  (multiple-value-bind (result receipt refusal) (try-realize-form *validated* planted)
    (declare (ignore result receipt))
    (check-refusal refusal :grammar-version-drift
                   "T-GRAMMAR-VERSION-DRIFT/PLANTED a grammar version bump refuses realization")))

;;; T-BUDGET-POLICY-DRIFT (PLANTED)
(let ((planted (lisp-plus-form0::%make-form-environment
                :identity (form-environment-identity *env*)
                :version (form-environment-version *env*)
                :grammar-identity (form-environment-grammar-identity *env*)
                :grammar-version (form-environment-grammar-version *env*)
                :operators (standard-operators)
                :holes (standard-holes)
                :budget-id "some-other-resource-policy"
                :content-digest (form-environment-content-digest *env*)
                :sealed-p t)))
  (multiple-value-bind (result receipt refusal) (try-realize-form *validated* planted)
    (declare (ignore result receipt))
    (check-refusal refusal :budget-policy-drift
                   "T-BUDGET-POLICY-DRIFT/PLANTED a changed resource policy refuses realization")))

;;; T-ENVIRONMENT-CONTENT-DRIFT — the declared SURFACE, not merely the name.
;;; Same identity, same version, same grammar, same resource policy: only the
;;; declared operator set differs.  Every name-comparing gate passes; the
;;; content digest is what refuses.
(let ((wider (seal-form-environment
              (make-form-environment
               :name "form0-selftest" :version 1
               ;; A different SELECTION from the same package-owned set.
               :operators (list "equal-datum" "canonical-hex")
               :holes (standard-holes)))))
  (check (cd0 equal-datum (form-environment-identity wider)
              (form-environment-identity *env*))
         "T-ENVIRONMENT-CONTENT-DRIFT the two environments agree about their identity")
  (check (= (form-environment-version wider) (form-environment-version *env*))
         "T-ENVIRONMENT-CONTENT-DRIFT the two environments agree about their version")
  (check (not (string= (form-environment-content-digest wider)
                       (form-environment-content-digest *env*)))
         "T-ENVIRONMENT-CONTENT-DRIFT but their declared surfaces differ")
  (multiple-value-bind (result receipt refusal) (try-realize-form *validated* wider)
    (declare (ignore result receipt))
    (check-refusal refusal :environment-content-drift
                   "T-ENVIRONMENT-CONTENT-DRIFT a validation does not travel to a differently-declared environment")))

;;; ══════════════════════════════════════════════════════════════════
(format t "~% [handler substitution — the exploit, and its closure]~%")

;;; THE HISTORICAL EXPLOIT.  Before the owner's option-(c) ruling, a caller could
;;; build a descriptor around any host function.  Two environments agreeing on
;;; identity, version, grammar, resource policy and every declared
;;; operator/arity/species then differed only in handler behaviour — and a form
;;; validated under the honest one REALIZED under the substituted one:
;;;
;;;     validated under HONEST, realized under SWAPPED:  ACCEPTED
;;;     result = "forged"   handler that ran = :SWAPPED-HANDLER-RAN
;;;
;;; T-NO-CALLER-SUPPLIED-BEHAVIOUR is the regression.  The attack is not
;;; mitigated; it is no longer constructible through the public API, because the
;;; only constructor that can put a function into a descriptor is internal and
;;; can only reach package-owned functions.
;;;
;;; SCOPE, STATED SO IT CANNOT DRIFT: this is a PUBLIC-API enforcement boundary.
;;; It is not process isolation. Hostile Common Lisp already running in this
;;; image can reach internals, redefine these functions, or ignore Form /0
;;; entirely — all outside the declared threat model.

(check (not (find-symbol "MAKE-OPERATOR-DESCRIPTOR" :lisp-plus-form0))
       "T-NO-CALLER-SUPPLIED-BEHAVIOUR MAKE-OPERATOR-DESCRIPTOR does not exist under any status")

(check (every (lambda (name)
                (multiple-value-bind (symbol status) (find-symbol name :lisp-plus-form0)
                  (declare (ignore symbol))
                  (not (eq status :external))))
              '("%MAKE-BUILTIN-DESCRIPTOR" "%MAKE-OPERATOR-DESCRIPTOR" "%BUILTIN-SPEC"
                "%OP/EQUAL-DATUM" "%OP/CANONICAL-HEX" "%OP/SEQUENCE-LENGTH"
                "%OP/RENDER-DIAGNOSTIC" "%OPERATOR-DESCRIPTOR-HANDLER"))
       "T-NO-CALLER-SUPPLIED-BEHAVIOUR every handler-bearing symbol is internal")

;;; A function offered where an operator selection belongs is refused.
(multiple-value-bind (environment refusal)
    (handler-case (values (make-form-environment
                           :name "handler-probe" :version 1
                           :operators (list #'identity) :holes '())
                          nil)
      (form-refused (condition) (values nil (form-refused-refusal condition))))
  (declare (ignore environment))
  (check-refusal refusal :environment-unusable
                 "T-NO-CALLER-SUPPLIED-BEHAVIOUR a host function cannot be offered as an operator"))

;;; An operator outside the package-owned set cannot be taught.
(multiple-value-bind (environment refusal)
    (handler-case (values (make-form-environment
                           :name "teach-probe" :version 1
                           :operators (list "run-program") :holes '())
                          nil)
      (form-refused (condition) (values nil (form-refused-refusal condition))))
  (declare (ignore environment))
  (check-refusal refusal :operator-not-built-in
                 "T-NO-CALLER-SUPPLIED-BEHAVIOUR an unknown operator name cannot be installed"))

;;; The four are the complete set, and selecting the same names twice gives the
;;; same behaviour — the substituted-clerk attack has no construction left.
(check (equal (operator-names)
              '("equal-datum" "canonical-hex" "sequence-length" "render-diagnostic"))
       "T-NO-CALLER-SUPPLIED-BEHAVIOUR the built-in set is exactly the four of Candidate /0")

(let* ((one (sealed-environment :name "twin"))
       (two (sealed-environment :name "twin"))
       (proposal (propose-form *ok-candidate* one))
       (instantiated (instantiate-form proposal
                                       (list (cons "left" (cd0 make-integer-datum 7))
                                             (cons "right" (cd0 make-integer-datum 7)))
                                       one))
       (validated (validate-form instantiated one)))
  (check (string= (form-environment-content-digest one)
                  (form-environment-content-digest two))
         "T-NO-CALLER-SUPPLIED-BEHAVIOUR two environments selecting the same operators agree on content")
  (multiple-value-bind (result receipt refusal) (try-realize-form validated two)
    (declare (ignore receipt))
    (check (null refusal)
           "T-NO-CALLER-SUPPLIED-BEHAVIOUR realization under the twin is accepted...")
    (check (and result (cd0 boolean-datum-value result))
           "T-NO-CALLER-SUPPLIED-BEHAVIOUR ...and returns the SAME answer, because behaviour is package-owned")))

;;; ══════════════════════════════════════════════════════════════════
(format t "~% [dual identity — subject form vs phase object]~%")

;;; T-DUAL-IDENTITY-SUBJECT-IS-STABLE
(check (string= (instantiated-form-subject-identity *instantiated*)
                (validated-form-subject-identity *validated*))
       "T-DUAL-IDENTITY the CLOSED subject is stable from instantiation to validation")

;;; T-DUAL-IDENTITY-PHASES-ARE-DISTINCT — the load-bearing one.  Object non-EQ
;;; proves nothing; these are content-derived identities in distinct domains.
(let ((identities (list (proposed-form-identity *proposal*)
                        (instantiated-form-identity *instantiated*)
                        (validated-form-identity *validated*))))
  (check (= 3 (length (remove-duplicates identities :test #'string=)))
         "T-DUAL-IDENTITY proposed, instantiated and validated phase identities are three distinct values")
  (check (notany (lambda (phase-identity)
                   (string= phase-identity
                            (validated-form-subject-identity *validated*)))
                 identities)
         "T-DUAL-IDENTITY no phase identity collides with the subject identity"))

;;; The validation receipt is a RECORD OF a validation, not the validated form.
(check (not (string= (form-validation-receipt-identity
                      (validated-form-receipt *validated*))
                     (validated-form-identity *validated*)))
       "T-DUAL-IDENTITY the validation receipt has its own identity, distinct from the validated form")

;;; T-DUAL-IDENTITY-SAME-SYNTAX-DIFFERENT-ENVIRONMENT — the chair's exact case.
(let* ((other-env (sealed-environment :name "a-different-desk"))
       (other-proposal (propose-form *ok-candidate* other-env))
       (other-instantiated
         (instantiate-form other-proposal
                           (list (cons "left" (cd0 make-integer-datum 7))
                                 (cons "right" (cd0 make-integer-datum 7)))
                           other-env))
       (other-validated (validate-form other-instantiated other-env)))
  (check (string= (validated-form-subject-identity other-validated)
                  (validated-form-subject-identity *validated*))
         "T-DUAL-IDENTITY two validations of the same syntax share ONE subject identity")
  (check (not (string= (validated-form-identity other-validated)
                       (validated-form-identity *validated*)))
         "T-DUAL-IDENTITY ...and carry TWO different validated phase identities"))

;;; T-DUAL-IDENTITY-PREDECESSOR-LINKS-ARE-PHASE-OBJECTS
(check (and (string= (validated-form-predecessor-identity *validated*)
                     (instantiated-form-identity *instantiated*))
            (not (string= (validated-form-predecessor-identity *validated*)
                          (instantiated-form-subject-identity *instantiated*))))
       "T-DUAL-IDENTITY predecessor links name the phase object, never merely the shared syntax")

;;; T-DUAL-IDENTITY-NO-CROSS-PHASE-SUBSTITUTION
(check (not (string= (proposed-form-identity *proposal*)
                     (validated-form-identity *validated*)))
       "T-DUAL-IDENTITY a proposed identity cannot stand where a validated identity is required")

;;; T-DUAL-IDENTITY-CONSEQUENTIAL-INPUTS-ARE-COMMITTED — change any one of the
;;; five bound components and the validated phase identity must move.
(let ((baseline (validated-form-identity *validated*)))
  (check (not (string= baseline
                       (validated-form-identity
                        (validate-form *instantiated* (sealed-environment :version 2)))))
         "T-DUAL-IDENTITY a different environment VERSION yields a different validated identity")
  (check (not (string= baseline
                       (validated-form-identity
                        (validate-form
                         (instantiate-form
                          *proposal*
                          (list (cons "left" (cd0 make-integer-datum 7))
                                (cons "right" (cd0 make-integer-datum 8)))
                          *env*)
                         *env*))))
         "T-DUAL-IDENTITY a different BINDING yields a different validated identity"))

;;; The binding environment has its own identity, and it is committed to.
(check (plusp (length (instantiated-form-binding-identity *instantiated*)))
       "T-DUAL-IDENTITY the exact binding environment carries its own identity")

;;; ══════════════════════════════════════════════════════════════════
(format t "~% [realization boundary]~%")

;;; T-REALIZE-NEEDS-VALIDATION
(multiple-value-bind (result receipt refusal)
    (try-realize-form *proposal* *env*)
  (declare (ignore result receipt))
  (check-refusal refusal :not-validated
                 "T-REALIZE-NEEDS-VALIDATION a proposal cannot be realized"))

(multiple-value-bind (result receipt refusal)
    (try-realize-form *instantiated* *env*)
  (declare (ignore result receipt))
  (check-refusal refusal :not-validated
                 "T-REALIZE-NEEDS-VALIDATION an instantiated form cannot be realized"))

;;; The lawful realization.
(defparameter *result* nil)
(defparameter *receipt* nil)
(multiple-value-setq (*result* *receipt*) (realize-form *validated* *env*))

(check (cd0 boolean-datum-p *result*)
       "the lawful candidate realizes to a boolean datum")
(check (cd0 boolean-datum-value *result*)
       "equal-datum(7,7) realizes as true")

;;; T-RECEIPT-NAMES-THE-FORM
(check (and (string= (form-realization-receipt-validated-identity *receipt*)
                     (validated-form-identity *validated*))
            (string= (form-realization-receipt-instantiated-identity *receipt*)
                     (instantiated-form-identity *instantiated*))
            (string= (validated-form-instantiated-identity *validated*)
                     (instantiated-form-identity *instantiated*)))
       "T-RECEIPT-NAMES-THE-FORM the receipt names exactly the validation that authorized it")

;;; The receipt must bind BOTH — which validation licensed it, AND which exact
;;; syntax was realized.  A receipt naming only the syntax could not say which
;;; validation event authorized that realization.
(check (and (string= (form-realization-receipt-subject-identity *receipt*)
                     (validated-form-subject-identity *validated*))
            (not (string= (form-realization-receipt-subject-identity *receipt*)
                          (form-realization-receipt-validated-identity *receipt*))))
       "T-RECEIPT-NAMES-THE-FORM the receipt binds the subject form AND the validation, as two distinct identities")

(check (string= (form-realization-receipt-environment-content-digest *receipt*)
                (form-environment-content-digest *env*))
       "T-RECEIPT-NAMES-THE-FORM the receipt binds the environment's declared surface")

(check (string= (form-realization-receipt-result-identity *receipt*)
                (cd0 octets-to-hex (cd0 canonical-octets *result*)))
       "T-RECEIPT-NAMES-THE-FORM the receipt names the exact result")

;;; T-REALIZATION-MINTS-NO-STANDING — the result is a datum and nothing else.
(check (cd0 datum-p *result*)
       "T-REALIZATION-MINTS-NO-STANDING realization yields a datum")
(check (notany (lambda (package-name) (find-package package-name))
               '("LISP-PLUS-SLICE0" "LISP-PLUS-SLICE1" "LISP-PLUS-SLICE2"
                 "LISP-PLUS-CORE0" "LISP-PLUS-KERNEL0"))
       "T-REALIZATION-MINTS-NO-STANDING no claim/basis/capability layer is even loaded")

;;; ══════════════════════════════════════════════════════════════════
(format t "~% [binding drift — the validator's exactness]~%")

;;; T-ENVIRONMENT-VERSION-DRIFT
(multiple-value-bind (result receipt refusal)
    (try-realize-form *validated* (sealed-environment :version 2))
  (declare (ignore result receipt))
  (check-refusal refusal :environment-version-drift
                 "T-ENVIRONMENT-VERSION-DRIFT a version bump refuses realization"))

;;; T-SAME-LOOKING-DIFFERENT-ENVIRONMENT — identical in every respect except
;;; the environment identity.
(multiple-value-bind (result receipt refusal)
    (try-realize-form *validated* (sealed-environment :name "look-alike"))
  (declare (ignore result receipt))
  (check-refusal refusal :environment-identity-drift
                 "T-SAME-LOOKING-DIFFERENT-ENVIRONMENT a validation is not portable between environments"))

;;; T-VALIDATION-NOT-TRANSFERABLE — a validation belongs to one exact form.
(let* ((other (instantiate-form
               (propose-form (operator-node "equal-datum"
                                            (hole-node "left") (hole-node "right"))
                             *env*)
               (list (cons "left" (cd0 make-integer-datum 1))
                     (cons "right" (cd0 make-integer-datum 2)))
               *env*)))
  (check (not (string= (validated-form-subject-identity *validated*)
                       (instantiated-form-subject-identity other)))
         "T-VALIDATION-NOT-TRANSFERABLE a different filling is a different subject form")
  (check (not (string= (validated-form-predecessor-identity *validated*)
                       (instantiated-form-identity other)))
         "T-VALIDATION-NOT-TRANSFERABLE a validation names one instantiation, not a shape"))

;;; T-GRAMMAR-VERSION-DRIFT (PLANTED) — the public constructor always installs
;;; the current grammar version, so this gate is reached by planting an
;;; environment whose grammar version differs.
(let ((planted (lisp-plus-form0::%make-form-environment
                :identity (form-environment-identity *env*)
                :version (form-environment-version *env*)
                :grammar-identity (form-environment-grammar-identity *env*)
                :grammar-version 99
                :operators (standard-operators)
                :holes (standard-holes)
                :budget-id (form-environment-budget-id *env*)
                :content-digest (form-environment-content-digest *env*)
                :sealed-p t)))
  (multiple-value-bind (result receipt refusal) (try-realize-form *validated* planted)
    (declare (ignore result receipt))
    (check-refusal refusal :grammar-version-drift
                   "T-GRAMMAR-VERSION-DRIFT/PLANTED a grammar version bump refuses realization")))

;;; T-BUDGET-POLICY-DRIFT (PLANTED)
(let ((planted (lisp-plus-form0::%make-form-environment
                :identity (form-environment-identity *env*)
                :version (form-environment-version *env*)
                :grammar-identity (form-environment-grammar-identity *env*)
                :grammar-version (form-environment-grammar-version *env*)
                :operators (standard-operators)
                :holes (standard-holes)
                :budget-id "some-other-resource-policy"
                :content-digest (form-environment-content-digest *env*)
                :sealed-p t)))
  (multiple-value-bind (result receipt refusal) (try-realize-form *validated* planted)
    (declare (ignore result receipt))
    (check-refusal refusal :budget-policy-drift
                   "T-BUDGET-POLICY-DRIFT/PLANTED a changed resource policy refuses realization")))

;;; T-ENVIRONMENT-CONTENT-DRIFT — the declared SURFACE, not merely the name.
;;; Same identity, same version, same grammar, same resource policy: only the
;;; declared operator set differs.  Every name-comparing gate passes; the
;;; content digest is what refuses.
(let ((wider (seal-form-environment
              (make-form-environment
               :name "form0-selftest" :version 1
               ;; A different SELECTION from the same package-owned set.
               :operators (list "equal-datum" "canonical-hex")
               :holes (standard-holes)))))
  (check (cd0 equal-datum (form-environment-identity wider)
              (form-environment-identity *env*))
         "T-ENVIRONMENT-CONTENT-DRIFT the two environments agree about their identity")
  (check (= (form-environment-version wider) (form-environment-version *env*))
         "T-ENVIRONMENT-CONTENT-DRIFT the two environments agree about their version")
  (check (not (string= (form-environment-content-digest wider)
                       (form-environment-content-digest *env*)))
         "T-ENVIRONMENT-CONTENT-DRIFT but their declared surfaces differ")
  (multiple-value-bind (result receipt refusal) (try-realize-form *validated* wider)
    (declare (ignore result receipt))
    (check-refusal refusal :environment-content-drift
                   "T-ENVIRONMENT-CONTENT-DRIFT a validation does not travel to a differently-declared environment")))


;;; T-OPERATOR-IDENTITY-DRIFT (PLANTED) — this gate is defence in depth: no
;;; public path can reach it, because operator identities are derived from the
;;; form itself.  It is fired here by tampering with a validation receipt, in
;;; the manner of de-fornace's ALTERED-FIRING-PLAN.
(let* ((receipt (validated-form-receipt *validated*))
       (tampered-receipt
         (lisp-plus-form0::%make-form-validation-receipt
          :identity (form-validation-receipt-identity receipt)
          :subject-identity (form-validation-receipt-subject-identity receipt)
          :instantiated-identity
          (form-validation-receipt-instantiated-identity receipt)
          :grammar-identity (form-validation-receipt-grammar-identity receipt)
          :grammar-version (form-validation-receipt-grammar-version receipt)
          :environment-identity
          (form-validation-receipt-environment-identity receipt)
          :environment-version
          (form-validation-receipt-environment-version receipt)
          :environment-content-digest
          (form-validation-receipt-environment-content-digest receipt)
          :operator-identities (list (operator-identifier "canonical-hex"))
          :budget-id (form-validation-receipt-budget-id receipt)))
       (tampered-form
         (lisp-plus-form0::%make-validated-form
          :datum (lisp-plus-form0::%validated-form-datum *validated*)
          :subject-identity (validated-form-subject-identity *validated*)
          :identity (validated-form-identity *validated*)
          :predecessor-identity (validated-form-predecessor-identity *validated*)
          :receipt tampered-receipt)))
  (multiple-value-bind (result realization-receipt refusal)
      (try-realize-form tampered-form *env*)
    (declare (ignore result realization-receipt))
    (check-refusal refusal :operator-identity-drift
                   "T-OPERATOR-IDENTITY-DRIFT/PLANTED a tampered operator binding refuses realization")))

;;; ══════════════════════════════════════════════════════════════════
(format t "~% [structural: the layer's own source]~%")

(defparameter *source*
  (with-open-file (stream (merge-pathnames "form0.lisp" *load-truename*))
    (let ((text (make-string (file-length stream))))
      (subseq text 0 (read-sequence text stream)))))

(defparameter *marker* ";;; ==== BOOTSTRAP ENDS HERE ====")

(defparameter *operative*
  (let ((position (search *marker* *source*)))
    (if position (subseq *source* position) "")))

(check (plusp (length *operative*))
       "the bootstrap marker is present and the operative layer is isolatable")

;;; T-NO-HOST-ESCAPE — no host escape hatch appears in the operative layer.
(dolist (token '("(eval" "(compile" "(load " "(read-from-string" "(intern"
                 "(find-symbol" "(macroexpand" "symbol-function" "fdefinition"
                 "(make-package" "(set-macro-character" "*readtable*"))
  (check (null (search token *operative*))
         (format nil "T-NO-HOST-ESCAPE the operative layer contains no ~A" token)))

;;; T-NO-READER — no reader, readtable or textual parse anywhere in the file.
(dolist (token '("read-from-string" "with-input-from-string" "set-macro-character"
                 "readtable" "parse-integer"))
  (check (null (search token *source*))
         (format nil "T-NO-READER the whole file contains no ~A" token)))

;;; T-SINGLE-DISPATCH-SITE — exactly one place calls out to an installed
;;; handler, and every APPLY in the layer applies a fixed host function.
(defun count-occurrences (needle haystack)
  (loop with count = 0 with start = 0
        for position = (search needle haystack :start2 start)
        while position
        do (incf count) (setf start (1+ position))
        finally (return count)))

(check (= 1 (count-occurrences "(funcall " *operative*))
       "T-SINGLE-DISPATCH-SITE the operative layer funcalls exactly once")
(check (= (count-occurrences "(apply " *operative*)
          (count-occurrences "(apply #'format " *operative*))
       "T-SINGLE-DISPATCH-SITE every APPLY applies #'FORMAT, never form-supplied data")

;;; T-NO-GLOBAL-REGISTRY — the only DEFPARAMETER in the operative layer is the
;;; refusal-code list; no table, no registry, no mutable global state.
(check (= 1 (count-occurrences "(defparameter " *operative*))
       "T-NO-GLOBAL-REGISTRY exactly one defparameter (the refusal-code list)")
(check (and (null (search "(defvar " *operative*))
            (null (search "make-hash-table" *operative*)))
       "T-NO-GLOBAL-REGISTRY no defvar and no hash table anywhere in the layer")

;;; ══════════════════════════════════════════════════════════════════
(format t "~% [retention]~%")

;;; T-REFUSALS-OUTLIVE-SUCCESS — the refusals gathered long before the lawful
;;; realization are still complete, readable objects afterwards.
(check (= 5 (length *malformed-refusals*))
       "T-REFUSALS-OUTLIVE-SUCCESS all five malformed candidates are still held")
(check (every (lambda (refusal)
                (and (form-refusal-p refusal)
                     (member (form-refusal-code refusal) (form-refusal-codes))
                     (plusp (length (form-refusal-detail refusal)))))
              *malformed-refusals*)
       "T-REFUSALS-OUTLIVE-SUCCESS each retains its code, detail and identity after the lawful candidate succeeded")
(check (and *unknown-op-refusal*
            (eq (form-refusal-code *unknown-op-refusal*) :unknown-operator))
       "T-REFUSALS-OUTLIVE-SUCCESS the rejected operator candidate is still inspectable")

;;; ══════════════════════════════════════════════════════════════════
(format t "~%== Language Form /0 teeth: ~D passed / ~D failed ==~%" *passed* *failed*)
(format t "(candidate implementation · specification-frozen: no · adopted: no ·~%")
(format t " self-consistency certification only — one model family wrote the layer,~%")
(format t " its operators and these checks; the stranger audit is OWED.~%")
(format t " Realization here computes over data and returns data: it mints no claim,~%")
(format t " basis, capability, authority or warrant, and no such layer is loaded.)~%")

(when (plusp *failed*)
  (format t "~%FLOOR CRACKED~%")
  (sb-ext:exit :code 1))
