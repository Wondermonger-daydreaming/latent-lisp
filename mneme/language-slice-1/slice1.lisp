;;;; slice1.lisp — Lisp+ Slice /1 substrate: Structured Proposition and
;;;; Derived Judgment /0.
;;;;
;;;; Governed by LANGUAGE-SLICE-1-CHARTER.md + CHARTER-DELTA-1.md (this
;;;; directory; the delta is the one executable reading and supersedes the
;;;; charter where they differ).  Slice /0 is a FROZEN dependency, loaded but
;;;; never edited.  Public working forms (names earned per charter §12):
;;;;   (proposition FORM)            — GROUND structured proposition, normal form
;;;;   (proposition-pattern FORM …)  — PATTERN (may carry declared variables)
;;;;   (judgment-schema …)           — a versioned derivation schema
;;;;   (register-schema S) (resolve-schema NAME VER)
;;;;   (refutation :refutes P …)     — represented counter-evidence
;;;;   (derive …)                    — the governed derived-judgment act
;;;;   (transported-testimony …)     — Δ4 receipt→testimony support
;;;;   (why RECEIPT) (render-derivation-why RECEIPT)
;;;;
;;;; Design decisions forced by the frozen substrate (documented, not hidden):
;;;;   * The derivation admissibility key of Δ3 is (:derivation (:schema NAME
;;;;     VER)).  The frozen WITNESS and PROMOTION-PROCEDURE constructors both
;;;;     require :kind to be a KEYWORD (slice0.lisp:266-267, 356).  So the
;;;;     (:schema NAME VER) triple is encoded, deterministically and
;;;;     canonically, into ONE keyword by %SCHEMA-ADMIT-KIND; the frozen
;;;;     %procedure-admits-p then compares (:derivation <that-keyword>) by
;;;;     EQUAL — exact and versioned (v1's keyword /= v2's keyword).
;;;;   * kernel0 has no :schema identity domain (identity.lisp:12-33, frozen);
;;;;     a schema's durable identity is minted in the :procedure domain — a
;;;;     schema IS a derivation procedure — with a name encoding schema/name/ver.
;;;;   * A :testimony witness's :for MUST be the attribution (:asserted S Q)
;;;;     (frozen gate slice0.lisp:272-281).  Δ4's derivation-report proposition
;;;;     is therefore carried as the inner Q of an (:asserted CONTEXT-A REPORT)
;;;;     attribution — exactly Slice /0's testimony-level discipline.
;;;;
;;;; House style inherited from slice0: typed condition hierarchy, read-only
;;;; defstructs, %-prefixed internals, docstrings, refusal-with-receipt.

(unless (find-package :lisp-plus-slice0)
  (load (merge-pathnames "../language-slice-0/slice0-transmissibility.lisp"
                         *load-truename*)))

(defpackage #:lisp-plus-slice1
  (:use #:cl)
  (:export
   ;; ground / pattern structured propositions
   #:proposition #:structured-proposition= #:normal-form-p
   #:proposition-pattern #:proposition-pattern-p
   #:proposition-pattern-normal-form #:proposition-pattern-variables
   ;; schemas + registry
   #:judgment-schema #:judgment-schema-p
   #:judgment-schema-name #:judgment-schema-version #:judgment-schema-identity
   #:judgment-schema-conclusion #:judgment-schema-premises
   #:judgment-schema-locals #:judgment-schema-conclusion-variables
   #:judgment-schema-admit-kind
   #:register-schema #:resolve-schema #:clear-schema-registry
   ;; refutation
   #:refutation #:refutation-p #:refutation-refutes #:refutation-source
   #:refutation-id
   ;; premise assessment
   #:premise-assessment #:premise-assessment-p
   #:premise-assessment-premise-pattern #:premise-assessment-ground-instance
   #:premise-assessment-matching-accessible-supports
   #:premise-assessment-matching-inaccessible-supports
   #:premise-assessment-mismatched-candidates
   #:premise-assessment-refuting-supports
   #:premise-assessment-binding-environments
   #:premise-assessment-ambiguities #:premise-assessment-disposition
   ;; derivation receipt
   #:derivation-receipt #:derivation-receipt-p
   #:derivation-receipt-schema-name #:derivation-receipt-schema-version
   #:derivation-receipt-conclusion #:derivation-receipt-bindings
   #:derivation-receipt-assessments #:derivation-receipt-decision
   #:derivation-receipt-strongest-lawful-result
   #:derivation-receipt-repair-options #:derivation-receipt-identity
   #:derivation-receipt-origin-context
   ;; the governed act + transport
   #:derive #:transported-testimony
   #:why #:render-derivation-why
   ;; conditions
   #:slice1-condition #:slice1-condition-failed-invariant
   #:slice1-condition-offending-field #:slice1-condition-offending-value
   #:slice1-condition-receipt
   #:malformed-structured-proposition #:pattern-used-as-ground
   #:schema-construction-error #:schema-registration-conflict
   #:schema-not-found #:unbound-conclusion-variable #:derivation-refused
   #:signal-slice1))

(in-package #:lisp-plus-slice1)

;;; ==================================================================
;;; Deterministic ordinal (constitutive order; no wall clock — slice0 §4).

(defvar *slice1-ordinal* 0)
(defun %next-ordinal () (incf *slice1-ordinal*))

;;; ==================================================================
;;; Condition layer — PARALLEL to slice0's (mirrors its style; NOT a subtype,
;;; because slice0-condition's SIGNAL-SLICE0 enforces the frozen §9 restart
;;; whitelist, which is irrelevant to derived judgment).  All refusals are
;;; typed, carry an offending field/value, and — where a governed attempt
;;; produced one — the structured receipt.

(define-condition slice1-condition (error)
  ((failed-invariant :initarg :failed-invariant
                     :reader slice1-condition-failed-invariant)
   (offending-field :initarg :offending-field :initform nil
                    :reader slice1-condition-offending-field)
   (offending-value :initarg :offending-value :initform nil
                    :reader slice1-condition-offending-value)
   (receipt :initarg :receipt :initform nil
            :reader slice1-condition-receipt))
  (:report (lambda (c stream)
             (format stream "~A: ~A"
                     (type-of c) (slice1-condition-failed-invariant c)))))

(macrolet ((families (&rest names)
             `(progn ,@(loop for n in names
                             collect `(define-condition ,n (slice1-condition) ())))))
  (families malformed-structured-proposition
            pattern-used-as-ground
            schema-construction-error
            schema-registration-conflict
            schema-not-found
            unbound-conclusion-variable
            derivation-refused))

(defun signal-slice1 (condition-type &rest initargs
                      &key failed-invariant &allow-other-keys)
  "The one live slice1 signalling path.  FAILED-INVARIANT must be a non-empty
string; CONDITION-TYPE must be a slice1-condition.  (All contract enforcement
lives here, not in an INITIALIZE-INSTANCE guard — such guards are inert under
SBCL 2.4.6's MAKE-CONDITION, as slice0 records.)"
  (unless (and (stringp failed-invariant) (plusp (length failed-invariant)))
    (error "slice1 condition contract: FAILED-INVARIANT must be a non-empty string"))
  (unless (subtypep condition-type 'slice1-condition)
    (error "slice1 condition contract: ~S is not a slice1-condition" condition-type))
  (error (apply #'make-condition condition-type initargs)))

(defun %malformed (field value invariant &rest more)
  (signal-slice1 'malformed-structured-proposition
                 :failed-invariant (apply #'format nil invariant more)
                 :offending-field field
                 :offending-value value))

;;; ==================================================================
;;; Value vocabulary — the boundary Slice /1 admits inside a structured
;;; proposition.  Ground: keywords / non-empty strings / integers / proper
;;; lists thereof, plus the (:quoted-datum FORM) literal escape.  Patterns
;;; additionally admit (:var KW) at any value position.  Raw (:var …) is
;;; refused in ground data (Δ5).

(defun %proper-list-p (x)
  (and (listp x)
       (loop for tail = x then (cdr tail)
             while (consp tail)
             finally (return (null tail)))))

(defun %var-form-p (v)
  (and (consp v) (eq (first v) :var) (consp (cdr v))
       (null (cddr v)) (keywordp (second v))))

(defun %quoted-datum-p (v)
  (and (consp v) (eq (first v) :quoted-datum) (consp (cdr v))
       (null (cddr v))))

(defun %validate-value (v field allow-vars vars-acc)
  "Validate a proposition value V.  When ALLOW-VARS, (:var KW) is a variable
and is collected into VARS-ACC (an adjustable list cell (list …)); otherwise a
raw (:var …) refuses.  (:quoted-datum FORM) is opaque literal data — its
payload is never walked or interpreted.  Returns nil, signals on violation."
  (cond
    ((%quoted-datum-p v)
     ;; literal escape: payload is data, var-shaped or not — never interpreted
     nil)
    ((%var-form-p v)
     (if allow-vars
         (pushnew (second v) (car vars-acc))
         (%malformed field v
                     "raw ~S may not appear in GROUND data; a variable is lawful ~
only inside a schema pattern, and literal var-shaped data must be wrapped as ~
(:quoted-datum ~S)" v v)))
    ((keywordp v) nil)
    ((integerp v) nil)
    ((stringp v)
     (unless (plusp (length v))
       (%malformed field v "a string value must be non-empty; got ~S" v)))
    ((and (consp v) (%proper-list-p v))
     (dolist (e v) (%validate-value e field allow-vars vars-acc)))
    (t (%malformed field v
                   "proposition values must be keywords, non-empty strings, ~
integers, proper lists thereof, (:var KW) [patterns only], or (:quoted-datum ~
FORM); got ~S (bare symbols, floats, and dotted lists do not cross the ~
canonical boundary)" v))))

;;; ------------------------------------------------------------------
;;; Parse + normalize.  A structured proposition is
;;;   (:predicate <pred-keyword> (<role-keyword> <value>) …)
;;; roles unique, sorted at construction by code-point STRING< on SYMBOL-NAME.

(defun %parse-proposition (form allow-vars field)
  "Return (values PRED SORTED-PAIRS VARS).  Refuses duplicate roles BEFORE
normalization completes, non-keyword predicate/roles, and (with ALLOW-VARS nil)
any raw variable."
  (unless (and (consp form) (eq (first form) :predicate))
    (%malformed field form
                "a structured proposition must be (:predicate <keyword> ~
(<role> <value>) …); got ~S" form))
  (unless (keywordp (second form))
    (%malformed field (second form)
                "the predicate must be a keyword; got ~S" (second form)))
  (let ((pred (second form))
        (raw-pairs (cddr form))
        (seen '())
        (vars-acc (list '()))
        (pairs '()))
    (unless (%proper-list-p raw-pairs)
      (%malformed field form "the role/value section must be a proper list of ~
(<role> <value>) pairs; got ~S" raw-pairs))
    (dolist (pair raw-pairs)
      (unless (and (consp pair) (%proper-list-p pair) (= (length pair) 2))
        (%malformed field pair "each role entry must be a (<role> <value>) ~
pair; got ~S" pair))
      (let ((role (first pair)) (val (second pair)))
        (unless (keywordp role)
          (%malformed field role "each role must be a keyword; got ~S" role))
        (when (member role seen :test #'eq)
          (%malformed field role "duplicate role ~S — roles must be unique ~
(refused before normalization completes)" role))
        (push role seen)
        (%validate-value val field allow-vars vars-acc)
        (push (cons role val) pairs)))
    (values pred
            (sort pairs (lambda (a b)
                          (string< (symbol-name (car a)) (symbol-name (car b)))))
            (car vars-acc))))

(defun %normal-form (pred sorted-pairs)
  (list* :predicate pred
         (mapcar (lambda (p) (list (car p) (cdr p))) sorted-pairs)))

(defun proposition (form)
  "Construct a GROUND structured proposition in NORMAL FORM.  FORM is
(:predicate <keyword> (<role> <value>) …).  Validates the boundary vocabulary,
refuses duplicate roles and any raw (:var …), sorts role pairs deterministically,
and is idempotent (its own output is a lawful input).  The result is canonical
Slice /0 data — it flows unchanged through claim / witness :for / testimony /
projection."
  (multiple-value-bind (pred pairs vars) (%parse-proposition form nil :proposition)
    (declare (ignore vars))
    (%normal-form pred pairs)))

(defun normal-form-p (x)
  "True when X is structurally a normal-form ground proposition."
  (ignore-errors (equal x (proposition x))))

(defun structured-proposition= (a b)
  "Equality of structured propositions = EQUAL on normal forms.  (The frozen
PROPOSITION= is not exported by Slice /0; EQUAL over normal forms is the
documented semantics — INVENTORY-1 #3 — and role-order insensitivity reduces to
it because both operands are normalized.)"
  (equal a b))

;;; ------------------------------------------------------------------
;;; Patterns — NOT propositions.  A pattern is its own record; it can never be
;;; a claim proposition or witness target (constructor-level refusal downstream:
;;; the frozen boundary gate refuses a struct, and Slice /1 refuses it earlier
;;; with a typed condition where it controls the call site).

(defstruct (proposition-pattern (:constructor %make-proposition-pattern)
                                (:copier nil))
  (normal-form nil :read-only t)   ; (:predicate pred (role value)…), vars kept
  (variables nil :read-only t))    ; keywords occurring as (:var KW)

(defun proposition-pattern (form)
  "Construct a PATTERN structured proposition.  FORM may carry (:var KW) at any
value position (declared later by a schema).  Validates shape and vocabulary,
collects its variables, normalizes role order.  A pattern is a distinct object,
unusable as a ground claim/support by construction."
  (multiple-value-bind (pred pairs vars)
      (%parse-proposition form t :proposition-pattern)
    (%make-proposition-pattern :normal-form (%normal-form pred pairs)
                               :variables vars)))

(defun %require-ground (x field)
  "Refuse a proposition-pattern where GROUND data is required."
  (when (proposition-pattern-p x)
    (signal-slice1 'pattern-used-as-ground
                   :failed-invariant
                   (format nil "a proposition-pattern cannot stand as ground ~
~A; patterns live only inside schema conclusion/premise slots" field)
                   :offending-field field
                   :offending-value x))
  x)

;;; ==================================================================
;;; The matcher — pattern-against-ground only.  Structural walk, exact
;;; canonical equality at every non-variable position, first-binding-then-
;;; consistency for variables.  No var-var unification, no backtracking.

(defun %match-value (pval gval bindings)
  "Match one pattern value against one ground value under BINDINGS (an alist
KW->value).  Returns (values OK NEW-BINDINGS CONFLICT-P).  A (:var KW) binds or
must agree; (:quoted-datum F) compares literally and is never interpreted."
  (cond
    ((%var-form-p pval)
     (let* ((kw (second pval)) (cell (assoc kw bindings)))
       (cond ((null cell) (values t (acons kw gval bindings) nil))
             ((equal (cdr cell) gval) (values t bindings nil))
             (t (values nil bindings t)))))
    ((%quoted-datum-p pval)
     (if (equal pval gval) (values t bindings nil) (values nil bindings t)))
    ((consp pval)
     (if (and (consp gval) (%proper-list-p pval) (%proper-list-p gval)
              (= (length pval) (length gval)))
         (loop with b = bindings
               for pe in pval for ge in gval
               do (multiple-value-bind (ok nb conflict) (%match-value pe ge b)
                    (when conflict (return (values nil bindings t)))
                    (unless ok (return (values nil bindings t)))
                    (setf b nb))
               finally (return (values t b nil)))
         (values nil bindings t)))
    (t (if (equal pval gval) (values t bindings nil) (values nil bindings t)))))

(defun %match-proposition (pattern-nf ground-nf bindings)
  "Match a normal-form PATTERN against a normal-form GROUND proposition.
Returns (values STATUS BINDINGS CONFLICTING-ROLES) where STATUS is
:predicate-mismatch, :role-set-mismatch, :conflict, or :match.  A :conflict
names every role whose bound/ground value disagreed (mismatched-candidate)."
  (let ((ppred (second pattern-nf)) (gpred (second ground-nf))
        (ppairs (cddr pattern-nf)) (gpairs (cddr ground-nf)))
    (cond
      ((not (eq ppred gpred)) (values :predicate-mismatch bindings nil))
      ((not (equal (sort (mapcar #'first ppairs) #'string< :key #'symbol-name)
                   (sort (mapcar #'first gpairs) #'string< :key #'symbol-name)))
       (values :role-set-mismatch bindings nil))
      (t (let ((b bindings) (conflicts '()))
           (dolist (pp ppairs)
             (let* ((role (first pp)) (pval (second pp))
                    (gval (second (assoc role gpairs))))
               (multiple-value-bind (ok nb conflict) (%match-value pval gval b)
                 (declare (ignore ok))
                 (if conflict
                     (push role conflicts)
                     (setf b nb)))))
           (if conflicts
               (values :conflict bindings (nreverse conflicts))
               (values :match b nil)))))))

(defun %instantiate (pattern-nf bindings)
  "Substitute bound (:var KW) values into a pattern; unbound vars and quoted
data are left as-is.  Used for the assessment's :ground-instance field."
  (labels ((walk (v)
             (cond ((%var-form-p v)
                    (let ((cell (assoc (second v) bindings)))
                      (if cell (cdr cell) v)))
                   ((%quoted-datum-p v) v)
                   ((consp v) (mapcar #'walk v))
                   (t v))))
    (walk pattern-nf)))

;;; ==================================================================
;;; The versioned derivation admissibility key (Δ3).  Encoded into ONE keyword
;;; so it satisfies the frozen witness/procedure :kind = keyword requirement
;;; while remaining canonical and EXACT under the frozen %procedure-admits-p
;;; EQUAL comparison; v1's keyword and v2's keyword differ, so a v1 derivation
;;; can never satisfy a v2-keyed procedure.

(defun %schema-admit-kind (name version)
  (intern (format nil "DERIVATION/~A/~D" (symbol-name name) version) :keyword))

;;; ==================================================================
;;; Judgment schema — identity + version, conclusion pattern, conjunctive
;;; premise patterns, declared schema-local variables.

(defstruct (judgment-schema (:constructor %make-judgment-schema) (:copier nil))
  (name nil :read-only t)                  ; keyword
  (version nil :read-only t)               ; nonnegative integer
  (identity nil :read-only t)              ; kernel0 durable-identity (:procedure)
  (conclusion nil :read-only t)            ; proposition-pattern
  (premises nil :read-only t)              ; list of proposition-pattern
  (locals nil :read-only t)                ; declared schema-local variables
  (conclusion-variables nil :read-only t)  ; vars in the conclusion (implicit)
  (admit-kind nil :read-only t))           ; the derivation admit keyword

(defun %schema-error (field value invariant &rest more)
  (signal-slice1 'schema-construction-error
                 :failed-invariant (apply #'format nil invariant more)
                 :offending-field field
                 :offending-value value))

(defun judgment-schema (&key name version conclusion premises locals)
  "Construct a versioned derivation schema.  NAME is a keyword, VERSION a
nonnegative integer.  CONCLUSION and each PREMISES entry are proposition-patterns.
LOCALS declares schema-local variables that may occur ONLY in premise patterns.
Conclusion variables are implicitly declared.  An undeclared variable anywhere,
or a schema-local appearing in the conclusion, refuses at construction."
  (unless (keywordp name)
    (%schema-error :name name "a schema NAME must be a keyword; got ~S" name))
  (unless (and (integerp version) (not (minusp version)))
    (%schema-error :version version
                   "a schema VERSION must be a nonnegative integer; got ~S" version))
  (unless (proposition-pattern-p conclusion)
    (%schema-error :conclusion conclusion
                   "the CONCLUSION must be a proposition-pattern; got ~S" conclusion))
  (dolist (p premises)
    (unless (proposition-pattern-p p)
      (%schema-error :premises p
                     "each premise must be a proposition-pattern; got ~S" p)))
  (unless (and (listp locals) (every #'keywordp locals))
    (%schema-error :locals locals ":locals must be a list of keywords; got ~S" locals))
  (let* ((cvars (proposition-pattern-variables conclusion))
         (declared (union cvars locals)))
    ;; a schema-local may not appear in the conclusion (Δ1)
    (dolist (l locals)
      (when (member l cvars :test #'eq)
        (%schema-error :locals l
                       "schema-local ~S also occurs in the conclusion; ~
schema-locals may occur ONLY in premise patterns" l)))
    ;; every premise variable must be a conclusion variable or a declared local
    (dolist (p premises)
      (dolist (v (proposition-pattern-variables p))
        (unless (member v declared :test #'eq)
          (%schema-error :premises v
                         "undeclared variable ~S in a premise pattern — ~
declare it in :locals or bind it through the conclusion" v))))
    (%make-judgment-schema
     :name name :version version
     :identity (lisp-plus-kernel0:make-identity
                :procedure (format nil "schema/~A/~D" (symbol-name name) version))
     :conclusion conclusion :premises premises :locals locals
     :conclusion-variables cvars
     :admit-kind (%schema-admit-kind name version))))

;;; ------------------------------------------------------------------
;;; Registry — exact (name, version) resolution; no auto-latest anywhere.

(defvar *schema-registry* (make-hash-table :test #'equal))

(defun %registry-key (name version) (cons name version))

(defun %schema-signature (s)
  "A structural fingerprint for idempotent-vs-conflicting re-registration."
  (list (judgment-schema-name s) (judgment-schema-version s)
        (proposition-pattern-normal-form (judgment-schema-conclusion s))
        (mapcar #'proposition-pattern-normal-form (judgment-schema-premises s))
        (sort (copy-list (judgment-schema-locals s)) #'string<
              :key #'symbol-name)))

(defun register-schema (schema)
  "Register SCHEMA under exact (name, version).  Registering a DIFFERENT schema
under an already-registered key REFUSES (typed); an identical re-registration is
idempotent-OK.  No auto-latest resolution exists."
  (unless (judgment-schema-p schema)
    (%schema-error :schema schema "REGISTER-SCHEMA requires a judgment-schema"))
  (let* ((key (%registry-key (judgment-schema-name schema)
                             (judgment-schema-version schema)))
         (existing (gethash key *schema-registry*)))
    (cond ((null existing)
           (setf (gethash key *schema-registry*) schema))
          ((equal (%schema-signature existing) (%schema-signature schema))
           existing)
          (t (signal-slice1 'schema-registration-conflict
                            :failed-invariant
                            (format nil "a DIFFERENT schema is already registered ~
under (~S ~S); (name,version) is a unique key and is never overwritten"
                                    (judgment-schema-name schema)
                                    (judgment-schema-version schema))
                            :offending-field :name-version
                            :offending-value key)))))

(defun resolve-schema (name version)
  "Resolve a schema by EXACT (name, version).  Refuses (typed) when absent."
  (or (gethash (%registry-key name version) *schema-registry*)
      (signal-slice1 'schema-not-found
                     :failed-invariant
                     (format nil "no schema registered under (~S ~S)" name version)
                     :offending-field :name-version
                     :offending-value (%registry-key name version))))

(defun clear-schema-registry ()
  "Empty the registry (test / image hygiene)."
  (clrhash *schema-registry*))

;;; ==================================================================
;;; Refutation — minimal represented counter-evidence.  Names the exact ground
;;; premise proposition it refutes.  Recorded, never erased.

(defstruct (refutation (:constructor %make-refutation) (:copier nil))
  (id nil :read-only t)
  (refutes nil :read-only t)               ; ground structured proposition
  (source nil :read-only t))

(defun refutation (&key refutes source)
  "Construct a refutation naming the exact GROUND proposition it refutes."
  (%require-ground refutes :refutes)
  (let ((nf (proposition refutes)))          ; normalize + validate as ground
    (%make-refutation
     :id (lisp-plus-kernel0:make-identity
          :receipt (format nil "refutation-~D" (%next-ordinal)))
     :refutes nf :source source)))

;;; ==================================================================
;;; Premise assessment — the structured object carried per premise (Δ2).

(defstruct (premise-assessment (:constructor %make-premise-assessment)
                               (:copier nil))
  (premise-pattern nil :read-only t)
  (ground-instance nil :read-only t)
  (matching-accessible-supports nil :read-only t)
  (matching-inaccessible-supports nil :read-only t)
  (mismatched-candidates nil :read-only t)    ; list of (witness . roles)
  (refuting-supports nil :read-only t)
  (binding-environments nil :read-only t)     ; distinct schema-local deltas
  (ambiguities nil :read-only t)
  (disposition nil :read-only t))             ; one of the six charter terms

;;; ==================================================================
;;; Derivation receipt — issued on EVERY attempt; carries the assessments
;;; THEMSELVES, never six name-buckets, never a boolean summary.

(defstruct (derivation-receipt (:constructor %make-derivation-receipt)
                               (:copier nil))
  (schema-name nil :read-only t)
  (schema-version nil :read-only t)
  (conclusion nil :read-only t)
  (bindings nil :read-only t)                 ; chosen environment, or nil
  (assessments nil :read-only t)              ; list of premise-assessment
  (decision nil :read-only t)                 ; :granted | :refused
  (strongest-lawful-result nil :read-only t)
  (repair-options nil :read-only t)           ; per unsatisfied premise
  (identity nil :read-only t)                 ; fresh :receipt identity per attempt
  (origin-context nil :read-only t)
  (ordinal nil :read-only t))

;;; ------------------------------------------------------------------
;;; Accessibility — id-based against the acting receiver-context.  Reuses the
;;; frozen receiver-context accessible-supports semantics.

(defun %support-accessible-p (witness ctx)
  (or (null ctx)
      (member (lisp-plus-slice0:witness-id witness)
              (lisp-plus-slice0:receiver-context-accessible-supports ctx)
              :test #'lisp-plus-kernel0:identity=)))

;;; ------------------------------------------------------------------
;;; Assess one premise under the accumulated bindings.

(defun %binding-delta (before after)
  "The alist entries present in AFTER but not BEFORE (schema-local extension)."
  (remove-if (lambda (pair) (member pair before :test #'equal)) after))

(defun %assess-premise (pattern bindings witnesses refutations ctx)
  "Return a PREMISE-ASSESSMENT and (as a second value) the accepted binding
extension when :satisfied (else NIL)."
  (let ((pnf (proposition-pattern-normal-form pattern))
        (acc-match '()) (inacc-match '()) (mismatched '())
        (refuting '()) (envs '()))
    ;; positive candidates
    (dolist (w witnesses)
      (multiple-value-bind (status nb conflicts)
          (%match-proposition pnf (lisp-plus-slice0:witness-for w) bindings)
        (case status
          (:match
           (let ((delta (%binding-delta bindings nb)))
             (if (%support-accessible-p w ctx)
                 (progn (push w acc-match)
                        (pushnew delta envs :test #'equal))
                 (push w inacc-match))))
          (:conflict (push (cons w conflicts) mismatched))
          (t nil))))                             ; predicate/role-set mismatch: skip
    ;; refuting candidates
    (dolist (r refutations)
      (multiple-value-bind (status nb conflicts)
          (%match-proposition pnf (refutation-refutes r) bindings)
        (declare (ignore nb conflicts))
        (when (eq status :match) (push r refuting))))
    (setf acc-match (nreverse acc-match)
          inacc-match (nreverse inacc-match)
          mismatched (nreverse mismatched)
          refuting (nreverse refuting)
          envs (nreverse envs))
    ;; disposition — the Δ2 conjunctive law, in code:
    ;; refuting blocks (positive kept) > ambiguity blocks > satisfied requires
    ;; an accessible match > inaccessible is residue (not absent) > mismatched
    ;; (predicate matched, role conflict) > missing (no candidate of any class).
    (let* ((distinct-envs (remove-duplicates envs :test #'equal))
           (disposition
             (cond (refuting :refuted)
                   ((and acc-match (> (length distinct-envs) 1)) :ambiguous)
                   (acc-match :satisfied)
                   (inacc-match :inaccessible)
                   (mismatched :mismatched)
                   (t :missing)))
           (accepted (when (eq disposition :satisfied)
                       (first distinct-envs))))
      (values
       (%make-premise-assessment
        :premise-pattern pnf
        :ground-instance (%instantiate pnf bindings)
        :matching-accessible-supports acc-match
        :matching-inaccessible-supports inacc-match
        :mismatched-candidates mismatched
        :refuting-supports refuting
        :binding-environments distinct-envs
        :ambiguities (if (eq disposition :ambiguous) distinct-envs '())
        :disposition disposition)
       accepted))))

(defun %repair-for (assessment)
  "What would discharge this unsatisfied premise (Δ6 / charter §6)."
  (let ((pnf (premise-assessment-ground-instance assessment)))
    (case (premise-assessment-disposition assessment)
      (:missing
       (list :supply-accessible-support-matching pnf))
      (:mismatched
       (list :supply-support-with-corrected-roles
             (mapcar (lambda (mc) (cons (lisp-plus-slice0:witness-id (car mc))
                                        (cdr mc)))
                     (premise-assessment-mismatched-candidates assessment))))
      (:inaccessible
       (list :grant-receiver-access-to
             (mapcar #'lisp-plus-slice0:witness-id
                     (premise-assessment-matching-inaccessible-supports assessment))))
      (:refuted
       (list :withdraw-or-answer-refutation
             (mapcar #'refutation-id
                     (premise-assessment-refuting-supports assessment))))
      (:ambiguous
       (list :remove-one-competing-support-or-add-discriminator
             (premise-assessment-ambiguities assessment)))
      (t nil))))

;;; ==================================================================
;;; DERIVE — the governed derived-judgment act.  Resolves the schema, binds the
;;; conclusion, assesses premises, ALWAYS issues a receipt, and on full coherent
;;; discharge mints a derivation witness and drives the frozen RAISE — a real
;;; Slice /0 promotion keyed to (:derivation (:schema NAME VER)).

(defun %bind-conclusion (schema conclusion)
  "Bind conclusion variables from the ground CONCLUSION.  Refuses (typed) if any
conclusion variable is left unbound."
  (let ((cnf (proposition-pattern-normal-form (judgment-schema-conclusion schema))))
    (multiple-value-bind (status bindings conflicts)
        (%match-proposition cnf conclusion '())
      (declare (ignore conflicts))
      (let ((unbound (remove-if (lambda (v) (assoc v bindings))
                                (judgment-schema-conclusion-variables schema))))
        (when (or (not (eq status :match)) unbound)
          (signal-slice1 'unbound-conclusion-variable
                         :failed-invariant
                         (format nil "the requested conclusion does not ground ~
every conclusion variable of schema (~S ~S)~@[; unbound: ~S~]~@[; match status: ~S~]"
                                 (judgment-schema-name schema)
                                 (judgment-schema-version schema)
                                 unbound
                                 (unless (eq status :match) status))
                         :offending-field :conclusion
                         :offending-value conclusion))
        bindings))))

(defun %build-conclusion-procedure (schema)
  "The conclusion's judgment procedure: :semantic, admitting ONLY the schema's
own derivation key.  This is the S3 closure — a generic content witness is
refused by the frozen admissibility gate because it is not a
(:derivation (:schema NAME VER)) support."
  (lisp-plus-slice0:promotion-procedure
   :descriptor (lisp-plus-kernel0:make-procedure-descriptor
                :procedure-id (lisp-plus-kernel0:make-identity
                               :procedure
                               (format nil "derive/~A/~D"
                                       (symbol-name (judgment-schema-name schema))
                                       (judgment-schema-version schema)))
                :version (judgment-schema-version schema)
                :judgment-class :semantic
                :result-vocabulary '(:verified :refuted))
   :admits (list (list :derivation (judgment-schema-admit-kind schema)))))

(defun %strongest-lawful (assessments)
  "The strongest lawful result short of grant: name the first blocking premise."
  (let ((blocking (find-if-not
                   (lambda (a) (eq (premise-assessment-disposition a) :satisfied))
                   assessments)))
    (and blocking (list :blocked-on
                        (second (premise-assessment-premise-pattern blocking))
                        (premise-assessment-disposition blocking)))))

(defun %grant-derivation (schema conclusion-nf receipt ctx-id by)
  "Mint the derivation witness and drive the frozen RAISE.  The grant is a real
Slice /0 promotion; the receipt identity + origin context ride in the witness."
  (let* ((procedure (%build-conclusion-procedure schema))
         (dwitness (lisp-plus-slice0:witness
                    :for conclusion-nf
                    :mode :derivation
                    :kind (judgment-schema-admit-kind schema)
                    :source (or by ctx-id :derivation)
                    :procedure (judgment-schema-identity schema)
                    :content (list :derivation-receipt
                                   (lisp-plus-kernel0:identity-key
                                    (derivation-receipt-identity receipt))
                                   :origin-context ctx-id)))
         (the-claim (lisp-plus-slice0:claim
                     :proposition conclusion-nf :by (or by :deriver))))
    (handler-case
        (multiple-value-bind (revision raise-receipt)
            (lisp-plus-slice0:raise the-claim
                                    :to :verified
                                    :per procedure
                                    :considering (list dwitness)
                                    :receiver ctx-id)
          (declare (ignore raise-receipt))
          (values revision receipt))
      (lisp-plus-slice0:slice0-condition (c)
        ;; frozen gate refused a derivation we judged discharged — surface it,
        ;; carrying our receipt (this should not happen for a coherent grant)
        (signal-slice1 'derivation-refused
                       :failed-invariant
                       (format nil "frozen RAISE refused the minted derivation ~
witness: ~A" (type-of c))
                       :offending-field :raise
                       :offending-value (type-of c)
                       :receipt receipt)))))

(defun derive (&key schema-name schema-version conclusion supports receiver by)
  "The governed derived-judgment act.  Resolve schema (SCHEMA-NAME,
SCHEMA-VERSION) by exact key; bind conclusion variables from the ground
CONCLUSION; assess each premise over SUPPORTS (Slice /0 witnesses and Slice /1
refutations) relative to the acting RECEIVER context; ALWAYS issue a derivation
receipt.  On full coherent discharge, mint a derivation witness and drive the
frozen RAISE — returning (values granted-claim receipt).  On refusal, SIGNAL a
typed DERIVATION-REFUSED carrying the receipt (mirroring Slice /0's RAISE)."
  (%require-ground conclusion :conclusion)
  (let* ((schema (resolve-schema schema-name schema-version))
         (conclusion-nf (proposition conclusion))
         (ctx receiver)
         (ctx-id (and ctx (lisp-plus-slice0:receiver-context-context-id ctx)))
         (witnesses (remove-if-not #'lisp-plus-slice0:witness-p supports))
         (refutations (remove-if-not #'refutation-p supports))
         (bindings (%bind-conclusion schema conclusion-nf))
         (assessments '()))
    ;; assess premises in order, threading accepted schema-local extensions
    (dolist (premise (judgment-schema-premises schema))
      (multiple-value-bind (a accepted)
          (%assess-premise premise bindings witnesses refutations ctx)
        (push a assessments)
        (when accepted (setf bindings (append accepted bindings)))))
    (setf assessments (nreverse assessments))
    (let* ((granted-p (and (judgment-schema-premises schema)
                           (every (lambda (a)
                                    (eq (premise-assessment-disposition a) :satisfied))
                                  assessments)))
           ;; a premiseless schema cannot silently grant (defensive)
           (granted-p (and granted-p (judgment-schema-premises schema)))
           (receipt (%make-derivation-receipt
                     :schema-name schema-name :schema-version schema-version
                     :conclusion conclusion-nf
                     :bindings (and granted-p bindings)
                     :assessments assessments
                     :decision (if granted-p :granted :refused)
                     :strongest-lawful-result
                     (if granted-p :verified
                         (%strongest-lawful assessments))
                     :repair-options
                     (loop for a in assessments
                           unless (eq (premise-assessment-disposition a) :satisfied)
                             collect (cons (premise-assessment-premise-pattern a)
                                           (%repair-for a)))
                     :identity (lisp-plus-kernel0:make-identity
                                :receipt (format nil "derivation-receipt-~D"
                                                 (%next-ordinal)))
                     :origin-context ctx-id
                     :ordinal (%next-ordinal))))
      (if granted-p
          (%grant-derivation schema conclusion-nf receipt ctx-id by)
          (signal-slice1 'derivation-refused
                         :failed-invariant
                         (format nil "derivation under schema (~S ~S) refused: ~
~{~A~^, ~}"
                                 schema-name schema-version
                                 (loop for a in assessments
                                       collect (format nil "~A=~A"
                                                       (second (premise-assessment-premise-pattern a))
                                                       (premise-assessment-disposition a))))
                         :offending-field :premises
                         :offending-value (mapcar #'premise-assessment-disposition
                                                  assessments)
                         :receipt receipt)))))

;;; ==================================================================
;;; Transported testimony (Δ4).  A transmitted derivation receipt is EVIDENCE
;;; THAT a derivation was performed — testimony, never a local derivation.  It
;;; is carried as an (:asserted CONTEXT-A REPORT) attribution so it satisfies
;;; the frozen testimony-level gate; the frozen admissibility gate then refuses
;;; it for a (:derivation (:schema …))-keyed conclusion procedure.

(defun transported-testimony (receipt &key context-a)
  "Transform a transmitted derivation RECEIPT into a testimony support witness:
:mode :testimony, :kind :derivation-report, :for the attribution that CONTEXT-A
derived the conclusion under schema NAME/VERSION.  This support cannot masquerade
as a local derivation — it is refused at the frozen gate for derivation-keyed
procedures."
  (unless (derivation-receipt-p receipt)
    (%malformed :receipt receipt "TRANSPORTED-TESTIMONY requires a derivation-receipt"))
  (let* ((report (list :predicate :derived
                       (list :schema (derivation-receipt-schema-name receipt))
                       (list :version (derivation-receipt-schema-version receipt))
                       (list :conclusion (derivation-receipt-conclusion receipt))))
         (attribution (list :asserted (or context-a :context-a) report)))
    (lisp-plus-slice0:witness
     :for attribution
     :mode :testimony
     :kind :derivation-report
     :source (or context-a :context-a)
     :content (list :transported-receipt
                    (lisp-plus-kernel0:identity-key
                     (derivation-receipt-identity receipt))))))

;;; ==================================================================
;;; WHY — one uniform explanation.  Register the derivation-receipt extractor in
;;; the frozen registry, exactly as projection and transmission did.

;; RECEIPTED INTERNAL ACCESS — see SLICE0-DEFECT-RECEIPT-1.md (sole licensed :: in Slice /1)
(push (cons #'derivation-receipt-p #'identity) lisp-plus-slice0::*why-extractors*)

(defun why (object)
  "Slice /1 façade over the uniform WHY: a derivation-receipt explains itself
from its structured fields; anything else is delegated to Slice /0's WHY."
  (if (derivation-receipt-p object)
      object
      (lisp-plus-slice0:why object)))

(defun render-derivation-why (receipt &optional (stream t))
  "Prose derived from the receipt's structured fields ONLY — never a fact absent
from the receipt (Slice /0 discipline, inherited)."
  (unless (derivation-receipt-p receipt)
    (%malformed :receipt receipt "RENDER-DERIVATION-WHY requires a derivation-receipt"))
  (format stream "~&[derivation ~A] schema ~S v~S~%"
          (derivation-receipt-decision receipt)
          (derivation-receipt-schema-name receipt)
          (derivation-receipt-schema-version receipt))
  (when (derivation-receipt-bindings receipt)
    (format stream "  bindings: ~{~A~^, ~}~%"
            (loop for (k . v) in (derivation-receipt-bindings receipt)
                  collect (format nil "~S=~S" k v))))
  (dolist (a (derivation-receipt-assessments receipt))
    (format stream "  premise ~S: ~A~%"
            (second (premise-assessment-premise-pattern a))
            (premise-assessment-disposition a))
    (dolist (mc (premise-assessment-mismatched-candidates a))
      (format stream "    mismatched ~A on roles ~S~%"
              (lisp-plus-kernel0:identity-key (lisp-plus-slice0:witness-id (car mc)))
              (cdr mc)))
    (when (premise-assessment-matching-inaccessible-supports a)
      (format stream "    inaccessible (residue, NOT absent): ~{~A~^, ~}~%"
              (mapcar (lambda (w) (lisp-plus-kernel0:identity-key
                                   (lisp-plus-slice0:witness-id w)))
                      (premise-assessment-matching-inaccessible-supports a))))
    (when (premise-assessment-refuting-supports a)
      (format stream "    refuted by: ~{~A~^, ~} (positive support, if any, remains)~%"
              (mapcar (lambda (r) (lisp-plus-kernel0:identity-key (refutation-id r)))
                      (premise-assessment-refuting-supports a))))
    (when (premise-assessment-ambiguities a)
      (format stream "    ambiguous candidates: ~S~%"
              (premise-assessment-ambiguities a))))
  (dolist (ro (derivation-receipt-repair-options receipt))
    (format stream "  repair for ~S: ~S~%" (second (car ro)) (cdr ro)))
  receipt)
