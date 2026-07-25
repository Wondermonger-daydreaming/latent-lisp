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
   #:judgment-schema-unique-locals
   #:judgment-schema-admit-kind
   #:register-schema #:resolve-schema #:clear-schema-registry
   ;; refutation
   #:refutation #:refutation-p #:refutation-refutes #:refutation-source
   #:refutation-id
   ;; premise assessment
   #:premise-assessment #:premise-assessment-p
   #:premise-assessment-premise-pattern #:premise-assessment-ground-instance
   ;; SOL DECISION 2 — the SINGLE plural surface addition.  The normative stored
   ;; value is the complete canonical SET; the singular reader above survives only
   ;; as a compatibility projection over it.
   #:premise-assessment-ground-instances
   ;; CHARTER-DELTA-4 (R-GROUNDING-NAME-1): the PRECISE name for the object the
   ;; two readers above actually return — a conclusion-projected premise
   ;; instance, NOT a complete binding environment.  Alias, same implementation.
   #:premise-assessment-projected-premise-instances
   ;; SOL DECISION 1 — the judged-claim roster.  Required by ruling condition 6
   ;; ("the receiving derivation records both the supporting claim identity and
   ;; its judgment basis") and by the misdirection repair ("a claim offered in
   ;; supports must no longer be invisible"): a recorded field with no reader is
   ;; not an inspectable record.
   #:premise-assessment-judged-claims
   #:premise-assessment-matching-accessible-supports
   #:premise-assessment-matching-inaccessible-supports
   #:premise-assessment-mismatched-candidates
   #:premise-assessment-refuting-supports
   ;; CHARTER-DELTA-4 (R-POLARITY-1): the second refuting species — Slice /0
   ;; witnesses whose DECLARED POLARITY is :REFUTES.  A separate reader, because
   ;; the legacy one promises refutation OBJECTS and a live caller reads
   ;; REFUTATION-ID off its elements.
   #:premise-assessment-refuting-witnesses
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
   #:derivation-receipt-complete-binding-environments
   #:derivation-receipt-uniqueness-conflicts
   #:derivation-receipt-multiply-supported-p
   ;; CHARTER-DELTA-3 — the unsupported-support residue.  An element of
   ;; :SUPPORTS that is none of the three recognized species used to be SILENTLY
   ;; DISCARDED: supplying it was indistinguishable, through every public reader,
   ;; from supplying nothing.  It is now recorded AT THE RECEIPT, inert, with the
   ;; caller's own index — visible without becoming admissible.
   #:derivation-receipt-unsupported-supports
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

(defun %quoted-datum-payload-canonical-p (payload)
  "Would PAYLOAD cross the governing Canonical Datum /0 boundary?

D2 (SLICE1-ERRATUM-1 docket E2, owner-determined): (:quoted-datum …) is NOT a
host-language escape hatch.  Slice /1 defines no broader intermediate-data
language of its own, so a quoted payload must belong to CD/0 exactly as every
other proposition part does.

This DELEGATES to the kernel0 codec boundary — LISP-PLUS-KERNEL0:REQUIRE-CANONICAL,
the same function Slice /0's own %REQUIRE-PROPOSITION calls on each proposition
leaf — and encodes NO vocabulary of its own.  It is a DISCARD-RESULT PROBE: the
question asked is 'would this payload cross?', and the converted datum is thrown
away, because a quoted payload is LITERAL DATA and must never be silently
rewritten.  (This is why REQUIRE-CANONICAL is not used as a converter here.)

NB — LISP-PLUS-CD0:DATUM-P is NOT the boundary predicate and must not be used
here: it recognizes constructed CD/0 datum OBJECTS, returning NIL for every host
value a caller can write, INCLUDING (:var :x).  REQUIRE-CANONICAL calls it only
as an already-converted fast path.

The line this draws, verified live: ACCEPTS keywords, integers, non-empty
strings, and proper lists thereof (so (:quoted-datum (:var :x)) — a proper list
of keywords — stays lawful, which is Δ5's actual purpose).  REFUSES floats, bare
host symbols, dotted lists, hash tables, host vectors, the empty string, ordinary
host structs, and other non-canonical host objects.

ONE STRUCT CLASS STILL CROSSES, and it is not an oversight: a kernel0
DURABLE-IDENTITY is a REGISTERED canonicalization subject (boundary.lisp registers
DURABLE-IDENTITY-P → IDENTITY->DATUM), so (:quoted-datum <a durable-identity>) is
LAWFUL — correctly, since an identity is CD/0-crossing by construction.  Its slots
are :READ-ONLY, so no slot can be rewritten through a retained handle.  Do not
state this rule as \"no struct may be a quoted payload\"; the true rule is \"only
what the kernel0 codec boundary admits\", and identities are admitted.

DEFERRED EXPOSURE (owner-deferred, pre-existing, NOT introduced here): a
CIRCULAR or pathologically deep payload diverges inside REQUIRE-CANONICAL's own
recursion rather than refusing.  Slice /1 has no cycle or depth guard anywhere;
this probe inherits that exposure unchanged and does not widen it."
  (handler-case (progn (lisp-plus-kernel0:require-canonical payload) t)
    (lisp-plus-kernel0:noncanonical-durable-value () nil)))

(defun %validate-value (v field allow-vars vars-acc)
  "Validate a proposition value V.  When ALLOW-VARS, (:var KW) is a variable
and is collected into VARS-ACC (an adjustable list cell (list …)); otherwise a
raw (:var …) refuses.  (:quoted-datum FORM) is literal data — its payload is
never INTERPRETED (no var-substitution, no matching, no walking for meaning) —
but since D2 it must still BELONG to Canonical Datum /0: opacity of meaning is
not exemption from the boundary.  Returns nil, signals on violation."
  (cond
    ((%quoted-datum-p v)
     ;; D2: literal escape, NOT a host escape hatch.  The payload is never
     ;; interpreted — var-shaped or not — but it must cross the governing CD/0
     ;; boundary, delegated to the kernel0 codec (see the probe above).
     (unless (%quoted-datum-payload-canonical-p (second v))
       (%malformed field v
                   "a (:quoted-datum FORM) payload must be Canonical Datum /0; ~
~S is not and does not cross the governing kernel0 canonicalization boundary. ~
The quoted escape protects literal data whose SHAPE would otherwise be read as ~
a variable — it is not a host-language escape hatch: floats, bare symbols, ~
dotted lists, hash tables, host vectors, the empty string and other ~
non-canonical host objects are refused behind the tag exactly as in front of it"
                   (second v)))
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

(defun %copy-value (v)
  "Copy a boundary value so that NO MUTABLE NODE is shared with the caller.
COPY-TREE alone is insufficient: it copies conses and shares every atom, but a
Common Lisp STRING is a MUTABLE atom (and may be adjustable, so even its LENGTH
is caller-controlled).  This descends cons structure and copies string leaves
with COPY-SEQ; keywords and integers are genuinely immutable and pass through.

DECLARED CEILING (AUDIT-1 continuation, defect B1 — state it, do not exceed it):
this walks CONS STRUCTURE and STRINGS only.  Because a (:quoted-datum FORM)
payload rides inside the cons tree, string leaves within it ARE detached.  A
payload object that is NEITHER a cons NOR a string is still not detached by this
function — but SINCE D2 almost none can ARRIVE.  %VALIDATE-VALUE now requires
every quoted payload to cross the kernel0 CD/0 codec boundary, and a vector,
hash-table, ordinary struct or adjustable non-string array does not cross it:
such a payload REFUSES AT CONSTRUCTION and never reaches storage.

THE RESIDUAL IS NOT EMPTY — it shrank to EXACTLY ONE CLASS, stated precisely
rather than rounded to zero: a kernel0 DURABLE-IDENTITY is a registered
canonicalization subject, so it may still be a quoted payload, and this function
does not copy it.  That is benign as far as SLOT rewriting goes — every
durable-identity slot is :READ-ONLY — so the case is a declared *undetached
object*, not a declared *mutable escape*.  It is named here so the ceiling stays
honest instead of collapsing into a tidier claim than the code earns.

The guarantee this function provides is therefore exactly: *no caller-held CONS
or STRING is aliased into stored state* — and, for values admitted through the
public constructors, the only undetached payload objects that remain are
read-only kernel0 identities.  (A general deep copy of arbitrary objects would
remain both a contradiction of quoted-datum opacity and impossible in general —
identity-bearing, circular and unreadable objects have no lawful copy — which is
why the cure is REFUSAL AT THE BOUNDARY rather than a deeper copy.)"
  (cond ((consp v) (cons (%copy-value (car v)) (%copy-value (cdr v))))
        ((stringp v) (copy-seq v))
        (t v)))

(defun %normal-form (pred sorted-pairs)
  ;; AUDIT-1 repair 1: structurally copy each value so no caller-held cons is
  ;; aliased into a stored proposition / pattern / schema.  AUDIT-1 continuation
  ;; (defect B1): COPY-TREE was NOT enough — it shares atoms, and a string is a
  ;; mutable atom, so caller-held strings wrote through into stored propositions,
  ;; patterns and granted receipts.  %COPY-VALUE (copy-tree + copy-seq at string
  ;; leaves) replaces it; keywords and integers are immutable and are still
  ;; shared; (:var …) / (:quoted-datum …) are ordinary conses, copied structurally
  ;; with their head keywords preserved by identity — subject to the ceiling
  ;; declared at %COPY-VALUE (non-cons, non-string quoted-datum payloads stay
  ;; caller-owned).  This is the ONE construction chokepoint (proposition,
  ;; proposition-pattern, and refutation all route through here) — it kills
  ;; A7/A7b, the input half of F1, and the ingress half of B1.
  (list* :predicate pred
         (mapcar (lambda (p) (list (car p) (%copy-value (cdr p)))) sorted-pairs)))

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
                                (:conc-name %proposition-pattern-)
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

(defun proposition-pattern-normal-form (p)
  "Public reader: the pattern's normal form, as a fresh structural copy.
Defensive copy per AUDIT-1 repair 2 (adjudication extension, third sitting):
the stored list is registry-reachable state and must not be caller-mutable.
AUDIT-1 continuation (defect B1): the copy is %COPY-VALUE, not COPY-TREE — a
returned string leaf was a live handle on stored state.  Ceiling at %COPY-VALUE."
  (%copy-value (%proposition-pattern-normal-form p)))

(defun proposition-pattern-variables (p)
  "Public reader: the pattern's variables, as a fresh list (AUDIT-1 repair 2)."
  (copy-list (%proposition-pattern-variables p)))

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

(defstruct (judgment-schema (:constructor %make-judgment-schema)
                            (:conc-name %judgment-schema-) (:copier nil))
  (name nil :read-only t)                  ; keyword
  (version nil :read-only t)               ; nonnegative integer
  (identity nil :read-only t)              ; kernel0 durable-identity (:procedure)
  (conclusion nil :read-only t)            ; proposition-pattern (struct; immutable)
  (premises nil :read-only t)              ; list of proposition-pattern
  (locals nil :read-only t)                ; declared schema-local variables
  (unique-locals nil :read-only t)         ; CHARTER-DELTA-2: uniqueness-bearing locals
  (conclusion-variables nil :read-only t)  ; vars in the conclusion (implicit)
  (admit-kind nil :read-only t))           ; the derivation admit keyword

;;; AUDIT-1 repair 2: public readers copy every list-valued field so no caller
;;; can mutate stored / registry state through a returned list (kills F1).
;;; Scalar/struct fields (name, version, identity, conclusion, admit-kind) pass
;;; through unchanged.  Copy depth: PREMISES / LOCALS / CONCLUSION-VARIABLES are
;;; top-level copy-list (elements are immutable structs or keywords).
(defun judgment-schema-name (s) (%judgment-schema-name s))
(defun judgment-schema-version (s) (%judgment-schema-version s))
(defun judgment-schema-identity (s) (%judgment-schema-identity s))
(defun judgment-schema-conclusion (s) (%judgment-schema-conclusion s))
(defun judgment-schema-admit-kind (s) (%judgment-schema-admit-kind s))
(defun judgment-schema-premises (s) (copy-list (%judgment-schema-premises s)))
(defun judgment-schema-locals (s) (copy-list (%judgment-schema-locals s)))
(defun judgment-schema-unique-locals (s)
  ;; CHARTER-DELTA-2 + AUDIT-1 repair 2: the uniqueness declaration is
  ;; immutable and its public reader returns a fresh copy (M9: mutating the
  ;; returned list cannot revise registered schema behavior).
  (copy-list (%judgment-schema-unique-locals s)))
(defun judgment-schema-conclusion-variables (s)
  (copy-list (%judgment-schema-conclusion-variables s)))

(defun %schema-error (field value invariant &rest more)
  (signal-slice1 'schema-construction-error
                 :failed-invariant (apply #'format nil invariant more)
                 :offending-field field
                 :offending-value value))

(defun judgment-schema (&key name version conclusion premises locals unique-locals)
  "Construct a versioned derivation schema.  NAME is a keyword, VERSION a
nonnegative integer.  CONCLUSION and each PREMISES entry are proposition-patterns.
LOCALS declares schema-local variables that may occur ONLY in premise patterns.
UNIQUE-LOCALS (CHARTER-DELTA-2) declares which schema-locals are
uniqueness-bearing — every one must be a declared local (never a conclusion
variable, never unknown), and duplicates refuse.  Schema-locals remain
existential unless listed here.  Conclusion variables are implicitly declared.
An undeclared variable anywhere, or a schema-local appearing in the conclusion,
refuses at construction."
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
  (unless (and (listp unique-locals) (every #'keywordp unique-locals))
    (%schema-error :unique-locals unique-locals
                   ":unique-locals must be a list of keywords; got ~S" unique-locals))
  (let* ((cvars (%proposition-pattern-variables conclusion))
         (declared (union cvars locals)))
    ;; a schema-local may not appear in the conclusion (Δ1)
    (dolist (l locals)
      (when (member l cvars :test #'eq)
        (%schema-error :locals l
                       "schema-local ~S also occurs in the conclusion; ~
schema-locals may occur ONLY in premise patterns" l)))
    ;; CHARTER-DELTA-2 uniqueness declaration validation (all typed refusals):
    ;; duplicates refuse · conclusion variables refuse (already ground-bound) ·
    ;; every unique local must be a declared schema-local (unknown refuses).
    (unless (= (length unique-locals) (length (remove-duplicates unique-locals)))
      (%schema-error :unique-locals unique-locals
                     "duplicate variable in :unique-locals ~S — each declared ~
uniqueness-bearing local must be listed once" unique-locals))
    (dolist (u unique-locals)
      (cond ((member u cvars :test #'eq)
             (%schema-error :unique-locals u
                            "conclusion variable ~S may not be declared unique; ~
it is already ground-bound by the requested conclusion" u))
            ((not (member u locals :test #'eq))
             (%schema-error :unique-locals u
                            "~S is declared unique but is not a schema-local ~
(:locals); a uniqueness-bearing variable must first be a declared local" u))))
    ;; every premise variable must be a conclusion variable or a declared local
    (dolist (p premises)
      (dolist (v (%proposition-pattern-variables p))
        (unless (member v declared :test #'eq)
          (%schema-error :premises v
                         "undeclared variable ~S in a premise pattern — ~
declare it in :locals or bind it through the conclusion" v))))
    ;; AUDIT-1 continuation (defect B2): SNAPSHOT the three caller-supplied list
    ;; SPINES at construction.  `:read-only t` protects the SLOT, not the list
    ;; structure — without this, a post-registration (setf (car …)) on a
    ;; caller-held cons rewrites a REGISTERED schema, up to and including erasing
    ;; a declared uniqueness constraint (an expected AMBIGUOUS refusal silently
    ;; becoming a GRANT).  Shallow COPY-LIST is the right depth here, in both
    ;; cases for a stated reason: :LOCALS / :UNIQUE-LOCALS are validated above as
    ;; lists of KEYWORDS, whose elements are immutable, so the spine copy is
    ;; TOTAL; :PREMISES elements are read-only PROPOSITION-PATTERN structs, so the
    ;; spine copy is total at this level and the remaining element-level path
    ;; (mutable string leaves inside a pattern's normal form) belongs to defect B1
    ;; and is cured at the %NORMAL-FORM chokepoint by %COPY-VALUE — not here.
    (%make-judgment-schema
     :name name :version version
     :identity (lisp-plus-kernel0:make-identity
                :procedure (format nil "schema/~A/~D" (symbol-name name) version))
     :conclusion conclusion
     :premises (copy-list premises)
     :locals (copy-list locals)
     :unique-locals (copy-list unique-locals)
     :conclusion-variables cvars
     :admit-kind (%schema-admit-kind name version))))

;;; ------------------------------------------------------------------
;;; Registry — exact (name, version) resolution; no auto-latest anywhere.

(defvar *schema-registry* (make-hash-table :test #'equal))

(defun %registry-key (name version) (cons name version))

(defun %schema-signature (s)
  "A structural fingerprint for idempotent-vs-conflicting re-registration."
  (list (judgment-schema-name s) (judgment-schema-version s)
        (%proposition-pattern-normal-form (judgment-schema-conclusion s))
        (mapcar #'%proposition-pattern-normal-form (judgment-schema-premises s))
        (sort (copy-list (judgment-schema-locals s)) #'string<
              :key #'symbol-name)
        ;; CHARTER-DELTA-2: the uniqueness declaration is part of schema identity —
        ;; a schema differing only in :unique-locals is a DIFFERENT schema.
        (sort (copy-list (judgment-schema-unique-locals s)) #'string<
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
                               (:conc-name %premise-assessment-) (:copier nil))
  (premise-pattern nil :read-only t)
  ;; SOL DECISION 2: the stored value is PLURAL — a canonical SEQUENCE, never a
  ;; bare instance, including at cardinality one.  The former singular slot is
  ;; gone: it recorded (FIRST ASSESS-ENVS), i.e. a traversal-order accident
  ;; dressed as a fact.
  ;;
  ;; CHARTER-DELTA-4 (R-GROUNDING-NAME-1) — WHAT THIS SLOT HOLDS, precisely.
  ;; Its elements are CONCLUSION-PROJECTED PREMISE INSTANCES: the premise pattern
  ;; with the bindings available ON ENTRY to this premise substituted, one per
  ;; INCOMING environment, deduplicated on byte-identical canonical encodings.
  ;; They are NOT complete binding environments, and this slot's cardinality is
  ;; NOT the number of them: a premise that itself binds a schema-local projects
  ;; that local AS A VARIABLE, so several environments differing only in it encode
  ;; to the same bytes and collapse to ONE projection.  Environment plurality —
  ;; the set SOL DECISION 2's ordering and dedup law is about — lives in
  ;; BINDING-ENVIRONMENTS (per premise) and in the receipt's
  ;; COMPLETE-BINDING-ENVIRONMENTS (across premises).  The name "ground-instances"
  ;; is retained on the public readers as a COMPATIBILITY name only.
  (ground-instances nil :read-only t)
  ;; SOL DECISION 1: every judged CLAIM offered in SUPPORTS and considered for
  ;; this premise, with what became of it — and, for the ones that discharged,
  ;; the inherited judgment basis (ruling condition 6).  A claim is never again
  ;; silently discarded.
  (judged-claims nil :read-only t)
  (matching-accessible-supports nil :read-only t)
  (matching-inaccessible-supports nil :read-only t)
  (mismatched-candidates nil :read-only t)    ; list of (witness . roles)
  (refuting-supports nil :read-only t)        ; Slice /1 REFUTATION objects only
  ;; CHARTER-DELTA-4 (R-POLARITY-1): the SECOND refuting species — matching,
  ;; accessible Slice /0 witnesses whose declared POLARITY is :REFUTES.  Kept in
  ;; its own slot rather than merged into REFUTING-SUPPORTS because that slot's
  ;; published contract is homogeneous ("refutations naming this premise") and
  ;; %REPAIR-FOR reads REFUTATION-ID off its elements: widening it would break a
  ;; live caller and silently change a public reader's value species.
  (refuting-witnesses nil :read-only t)
  (binding-environments nil :read-only t)     ; distinct schema-local deltas
  (ambiguities nil :read-only t)
  (disposition nil :read-only t))             ; one of the six charter terms

;;; AUDIT-1 repair 2: public readers copy every list-valued field so an
;;; assessment carried inside a stored receipt cannot be mutated through a
;;; returned list.  Copy depth: PREMISE-PATTERN / GROUND-INSTANCES (normal-form
;;; role-value lists) / JUDGED-CLAIMS (plists whose only non-cons, non-string
;;; leaves are read-only kernel0 identities and keywords),
;;; MISMATCHED-CANDIDATES ((witness . roles) conses),
;;; BINDING-ENVIRONMENTS / AMBIGUITIES (schema-local alists) are structural
;;; (%copy-value — copy-tree PLUS copy-seq at string leaves, per the AUDIT-1
;;; continuation defect B1: a returned string leaf was a live handle on stored
;;; state; witness/refutation struct leaves remain shared, and the ceiling
;;; declared at %COPY-VALUE applies);
;;; MATCHING-*-SUPPORTS / REFUTING-SUPPORTS / REFUTING-WITNESSES are top-level
;;; copy-list (immutable struct elements).  DISPOSITION (a keyword) passes through.
(defun premise-assessment-disposition (a) (%premise-assessment-disposition a))
(defun premise-assessment-premise-pattern (a)
  (%copy-value (%premise-assessment-premise-pattern a)))
(defun premise-assessment-projected-premise-instances (a)
  "The canonical SEQUENCE of this premise's CONCLUSION-PROJECTED PREMISE
INSTANCES — the PRECISE name (CHARTER-DELTA-4, R-GROUNDING-NAME-1) for what the
legacy reader PREMISE-ASSESSMENT-GROUND-INSTANCES has always returned.  Same
implementation, same value, same copy behaviour; the name is the repair.

An element is the premise pattern with the bindings available ON ENTRY to this
premise substituted — the conclusion bindings, plus any schema-local already bound
by an EARLIER premise.  A schema-local this premise itself binds is left AS A
VARIABLE.  The sequence is deduplicated ONLY on byte-identical canonical
encodings and ordered lexicographically by canonical encoded bytes (SOL DECISION
2's ordering and dedup law, applied to this sequence).  PLURAL IS NORMATIVE: a
one-element sequence is returned when there is exactly one, never a bare instance.

THREE INDEPENDENT AXES — do not read one off another:

  1. PROJECTED-PREMISE MULTIPLICITY — this reader.
  2. COMPLETE-ENVIRONMENT PLURALITY — PREMISE-ASSESSMENT-BINDING-ENVIRONMENTS per
     premise, DERIVATION-RECEIPT-COMPLETE-BINDING-ENVIRONMENTS across premises.
     This is the NORMATIVE complete set.
  3. AMBIGUITY — PREMISE-ASSESSMENT-AMBIGUITIES / the receipt's
     UNIQUENESS-CONFLICTS, from DECLARED :UNIQUE-LOCALS.

(1) IS NOT (2), IN EITHER DIRECTION.  A premise that binds a schema-local
projects that local as a variable, so several complete environments differing only
in it collapse to ONE projection: this reader can answer 1 while three complete
environments exist.  Conversely a LATER premise, entered with that local already
bound, projects it as a value and this reader can answer 3 — at which point
PREMISE-ASSESSMENT-GROUND-INSTANCE refuses.  Neither cardinality is a bound on
the other, and neither is an ambiguity."
  (%copy-value (%premise-assessment-ground-instances a)))

(defun premise-assessment-ground-instances (a)
  "LEGACY PROJECTION READER.  Retained, operational, and unchanged in return
shape and value; the precise name is
PREMISE-ASSESSMENT-PROJECTED-PREMISE-INSTANCES, whose docstring is authoritative
for what an element is and for the three axes it must not be confused with
(CHARTER-DELTA-4, R-GROUNDING-NAME-1).

The name is a COMPATIBILITY name: an element is a conclusion-projected premise
instance, NOT a complete binding environment, and this sequence's cardinality is
NOT the number of complete binding environments.  SOL DECISION 2's normative
complete set is the COMPLETE BINDING ENVIRONMENT set, read from
PREMISE-ASSESSMENT-BINDING-ENVIRONMENTS and
DERIVATION-RECEIPT-COMPLETE-BINDING-ENVIRONMENTS.  Never repurposed to return
those, and never removed."
  (%copy-value (%premise-assessment-ground-instances a)))

(defun premise-assessment-ground-instance (a)
  "LEGACY SINGULAR PROJECTION READER — a compatibility projection over
PREMISE-ASSESSMENT-PROJECTED-PREMISE-INSTANCES (a.k.a. the legacy
PREMISE-ASSESSMENT-GROUND-INSTANCES), and nothing more (SOL DECISION 2).

IT DOES NOT PROTECT COMPLETE-ENVIRONMENT PLURALITY, and must never be read as
evidence of singular grounding (CHARTER-DELTA-4, R-GROUNDING-NAME-1): it answers
with one instance whenever the PROJECTION is singular, which is the ordinary case
for a premise that binds a schema-local — while several complete binding
environments exist and are preserved elsewhere.  Its refusal below guards the
PROJECTION's cardinality only.

Returns the SOLE projection when the sequence has exactly one, and NIL when it is
empty — the pre-ruling behaviour for every premise that ever had a single
projection.  Above cardinality one it REFUSES: there is no 'the' ground instance,
and choosing one by any rule whatsoever would manufacture a singular history that
never existed.  It does NOT sometimes return an instance and sometimes a sequence
— that would relocate the ambiguity into the value shape, which the ruling forbids
explicitly.  THIS REFUSAL IS REACHABLE IN ORDINARY USE: a premise entered with a
schema-local already bound by an earlier premise projects that local as a value,
so its projection sequence is as plural as the environment set that reached it.

The refusal is a typed SLICE1-CONDITION (no new condition family is minted for
it) naming the cardinality and the plural reader that has the evidence."
  (let ((set (%premise-assessment-ground-instances a)))
    (cond ((null set) nil)
          ((null (cdr set)) (%copy-value (first set)))
          (t (signal-slice1
              'slice1-condition
              :failed-invariant
              (format nil "this premise has ~D distinct PROJECTED PREMISE ~
INSTANCES, so it has NO single ground instance; the plurality is evidence and is ~
preserved — read PREMISE-ASSESSMENT-PROJECTED-PREMISE-INSTANCES (legacy name: ~
PREMISE-ASSESSMENT-GROUND-INSTANCES), which returns all ~D in canonical order.  ~
Selecting one here would manufacture a singular history that never existed.  NOTE ~
this count is the PROJECTION's, not the complete-binding-environment set's — those ~
are a separate axis, read at DERIVATION-RECEIPT-COMPLETE-BINDING-ENVIRONMENTS"
                      (length set) (length set))
              :offending-field :ground-instance
              :offending-value (length set))))))

(defun premise-assessment-judged-claims (a)
  "The per-premise JUDGED-CLAIM ROSTER (SOL DECISION 1): one plist per judged
claim offered in SUPPORTS and considered for this premise, in the form

  (:CLAIM-ID id :OUTCOME kw [:ROLES roles] [:JUDGMENT kw]
   [:PROCEDURE-ID id :PROCEDURE-VERSION v :SUPPORT-IDS ids
    :JUDGMENT-RECEIVER r :JUDGMENT-ORDINAL n])

OUTCOME is one of :DISCHARGED · :PROPOSITION-DOES-NOT-MATCH · :ROLE-CONFLICT ·
:UNJUDGED · :JUDGMENT-NOT-VERIFIED · :JUDGMENT-BASIS-UNAVAILABLE ·
:INACCESSIBLE-TO-RECEIVER.  The judgment basis fields are present exactly on the
:DISCHARGED entries — that is ruling condition 6, and it is what makes an
inherited standing auditable instead of restated."
  (%copy-value (%premise-assessment-judged-claims a)))
(defun premise-assessment-mismatched-candidates (a)
  (%copy-value (%premise-assessment-mismatched-candidates a)))
(defun premise-assessment-binding-environments (a)
  (%copy-value (%premise-assessment-binding-environments a)))
(defun premise-assessment-ambiguities (a)
  (%copy-value (%premise-assessment-ambiguities a)))
(defun premise-assessment-matching-accessible-supports (a)
  (copy-list (%premise-assessment-matching-accessible-supports a)))
(defun premise-assessment-matching-inaccessible-supports (a)
  (copy-list (%premise-assessment-matching-inaccessible-supports a)))
(defun premise-assessment-refuting-supports (a)
  "The Slice /1 REFUTATION OBJECTS naming this premise.  Contract UNCHANGED and
deliberately HOMOGENEOUS (CHARTER-DELTA-4): this reader returns refutations, and
only refutations, exactly as it always has — %REPAIR-FOR reads REFUTATION-ID off
its elements, so widening it would break a live caller and silently change a
public reader's value species.

THIS IS NOT THE WHOLE OF THE REFUTING EVIDENCE.  The second refuting species —
matching, accessible Slice /0 witnesses whose declared polarity is :REFUTES — is
returned by PREMISE-ASSESSMENT-REFUTING-WITNESSES.  A premise is :REFUTED on the
UNION; a reader that consults only this one can see an empty list on a premise
that was refused for refutation."
  (copy-list (%premise-assessment-refuting-supports a)))

(defun premise-assessment-refuting-witnesses (a)
  "The matching, receiver-ACCESSIBLE Slice /0 witnesses whose DECLARED POLARITY is
:REFUTES — refuting evidence, never positive support (CHARTER-DELTA-4,
R-POLARITY-1).

Such a witness is classified BEFORE positive matching support is accumulated, so
it NEVER appears in PREMISE-ASSESSMENT-MATCHING-ACCESSIBLE-SUPPORTS, never
discharges the premise, never extends a binding environment, and never reaches the
receipt's COMPLETE-BINDING-ENVIRONMENTS.  It stays fully inspectable HERE — the
refuting evidence is recorded, never erased (charter §5), and positive support
coexisting with it also remains visible in its own roster (CHARTER-DELTA-1 Δ2.4).

Precedence follows the refutation species: a supporting witness plus an accessible
matching :REFUTES witness is :REFUTED, exactly as a supporting witness plus a
Slice /1 refutation object is.

ACCESSIBILITY AND MATCHING COME FIRST, and polarity does not override them: an
INACCESSIBLE :REFUTES witness is :INACCESSIBLE residue (in
MATCHING-INACCESSIBLE-SUPPORTS, not here) and a role-CONFLICTING one is
:MISMATCHED (in MISMATCHED-CANDIDATES, not here).  Neither is applied as a
refutation.

THE EXACT CEILING: this reader reports a DECLARED direction and nothing more.
Polarity is not an admission gate — mode, kind, source, procedure, content,
transmissible and accessible-to remain unconsulted by premise discharge, no
premise-source contract is created, and nothing here binds an assertion to a real
observation or effect."
  (copy-list (%premise-assessment-refuting-witnesses a)))

;;; ==================================================================
;;; Derivation receipt — issued on EVERY attempt; carries the assessments
;;; THEMSELVES, never six name-buckets, never a boolean summary.

(defstruct (derivation-receipt (:constructor %make-derivation-receipt)
                               (:conc-name %derivation-receipt-) (:copier nil))
  (schema-name nil :read-only t)
  (schema-version nil :read-only t)
  (conclusion nil :read-only t)
  (bindings nil :read-only t)                 ; first complete environment, or nil
  (complete-binding-environments nil :read-only t) ; CHARTER-DELTA-2: ALL complete envs
  (uniqueness-conflicts nil :read-only t)     ; CHARTER-DELTA-2: (local values envs)…
  (assessments nil :read-only t)              ; list of premise-assessment
  (decision nil :read-only t)                 ; :granted | :refused
  (strongest-lawful-result nil :read-only t)
  (repair-options nil :read-only t)           ; per unsatisfied premise
  ;; CHARTER-DELTA-3: inert descriptors for the :SUPPORTS elements that were
  ;; none of the three recognized species.  Caller input order, duplicates
  ;; preserved, zero-based index, NO raw object retained.  Diagnostic only.
  (unsupported-supports nil :read-only t)
  (identity nil :read-only t)                 ; fresh :receipt identity per attempt
  (origin-context nil :read-only t)
  (ordinal nil :read-only t))

;;; AUDIT-1 repair 2: public readers copy every list-valued field so a past
;;; receipt can never be silently rewritten by whoever holds it — the "recorded,
;;; never erased" law (kills F2).  Copy depth: CONCLUSION / BINDINGS /
;;; STRONGEST-LAWFUL-RESULT / REPAIR-OPTIONS are structural (%copy-value —
;;; copy-tree PLUS copy-seq at string leaves, per the AUDIT-1 continuation defect
;;; B1: a returned string leaf was a live handle on a granted receipt; struct
;;; leaves shared; ceiling declared at %COPY-VALUE); ASSESSMENTS is
;;; top-level copy-list (elements are immutable premise-assessment structs whose
;;; own list readers already copy).  Scalar/struct fields pass through.
(defun derivation-receipt-schema-name (r) (%derivation-receipt-schema-name r))
(defun derivation-receipt-schema-version (r) (%derivation-receipt-schema-version r))
(defun derivation-receipt-decision (r) (%derivation-receipt-decision r))
(defun derivation-receipt-identity (r) (%derivation-receipt-identity r))
(defun derivation-receipt-origin-context (r) (%derivation-receipt-origin-context r))
(defun derivation-receipt-conclusion (r) (%copy-value (%derivation-receipt-conclusion r)))
(defun derivation-receipt-bindings (r) (%copy-value (%derivation-receipt-bindings r)))
(defun derivation-receipt-strongest-lawful-result (r)
  (%copy-value (%derivation-receipt-strongest-lawful-result r)))
(defun derivation-receipt-repair-options (r)
  (%copy-value (%derivation-receipt-repair-options r)))
(defun derivation-receipt-assessments (r) (copy-list (%derivation-receipt-assessments r)))
;; CHARTER-DELTA-2 receipt refinement.  Both list-valued fields are structural
;; (nested alists / role-value lists; struct leaves shared, immutable) so their
;; public readers %copy-value per AUDIT-1 repair 2 as continued by the B1 repair
;; (copy-tree PLUS copy-seq at string leaves; ceiling declared at %COPY-VALUE) —
;; a past receipt's complete environments and named uniqueness conflicts can
;; never be silently rewritten, not even through a returned string.
(defun derivation-receipt-complete-binding-environments (r)
  (%copy-value (%derivation-receipt-complete-binding-environments r)))
(defun derivation-receipt-uniqueness-conflicts (r)
  (%copy-value (%derivation-receipt-uniqueness-conflicts r)))
(defun derivation-receipt-unsupported-supports (r)
  "CHARTER-DELTA-3.  The inert record of every :SUPPORTS element that was NONE
of the three recognized species (Slice /0 witness · Slice /1 refutation ·
Slice /0 claim).  NIL when there were none; otherwise a proper list of

    (:INDEX N :REASON :UNSUPPORTED-SUPPORT-SPECIES)

with N the ZERO-BASED position of the element in the caller's own :SUPPORTS
list, in caller input order, DUPLICATES PRESERVED (the receipt records what the
caller supplied, not a set).

THE EXACT CEILING, stated rather than implied: this proves an unsupported value
WAS supplied, WHERE it appeared, and that it had NO semantic effect.  It does
NOT preserve or identify the value.  The raw object is deliberately not
retained — not the object, not its TYPE-OF, not its printed form, not its
SXHASH, not any address-like identity, not implementation class metadata, not a
host pointer.  An arbitrary host object may be mutable, circular, unreadable,
noncanonical or identity-bearing, and Slice /1 must not pretend to durably
snapshot one.

VISIBILITY IS NOT ADMISSIBILITY.  Residue cannot discharge a premise, refute
one, bind a variable, create or resolve ambiguity, or authorize a grant, and it
is never silently converted into :MISSING.  Two calls differing only in
unsupported supply reach the SAME decision and the SAME dispositions — and are
no longer indistinguishable through the public readers.

Copy discipline (AUDIT-1 repair 2): the returned list is a defensive structural
copy, so mutating it — or any plist inside it — cannot revise the stored
receipt.  Two reads are structurally EQUAL and need not be EQ."
  (%copy-value (%derivation-receipt-unsupported-supports r)))

(defun derivation-receipt-multiply-supported-p (r)
  "Derived VIEW (CHARTER-DELTA-2): true when MORE THAN ONE complete coherent
binding environment discharges the conclusion.  NOT a premise status, NOT a
scalar strength — a boolean read of the preserved environment count."
  (> (length (%derivation-receipt-complete-binding-environments r)) 1))

;;; ------------------------------------------------------------------
;;; Accessibility — id-based against the acting receiver-context.  Reuses the
;;; frozen receiver-context accessible-supports semantics.

(defun %witness-refutes-p (witness)
  "TRUE when a Slice /0 witness DECLARES its direction as :REFUTES
(CHARTER-DELTA-4, R-POLARITY-1).

The ONE new input the premise-assessment gate reads about a witness, isolated in
its own function so it is (a) named where the decision is made and (b) the single
point a tooth can blind in order to restore the pre-Delta-4 gate exactly — see
T-POLARITY in slice1-selftest.lisp.  Blinding this predicate to NIL reproduces the
inversion verbatim: direction unread, every matching accessible witness routed into
positive matching support.

It reads WITNESS-POLARITY and nothing else.  It is NOT an admissibility test: mode,
kind, source, procedure, content, transmissible and accessible-to are not consulted
here or anywhere in premise discharge."
  (eq (lisp-plus-slice0:witness-polarity witness) :refutes))

(defun %support-accessible-p (witness ctx)
  (or (null ctx)
      (member (lisp-plus-slice0:witness-id witness)
              (lisp-plus-slice0:receiver-context-accessible-supports ctx)
              :test #'lisp-plus-kernel0:identity=)))

(defun %claim-accessible-p (the-claim ctx)
  "Receiver accessibility for a JUDGED CLAIM offered as premise support (ruling
condition 2 — 'accessible under the already-governing accessibility rule').

This is the SAME id-membership test %SUPPORT-ACCESSIBLE-P applies to a witness,
read against the claim's own durable :CLAIM identity.  No new accessibility
regime is introduced: the charter's :SATISFIED definition already says
'a matching, admissible, ACCESSIBLE support/judged claim', and a claim carries an
id, so the existing rule extends without invention."
  (or (null ctx)
      (member (lisp-plus-slice0:claim-id the-claim)
              (lisp-plus-slice0:receiver-context-accessible-supports ctx)
              :test #'lisp-plus-kernel0:identity=)))

;;; ------------------------------------------------------------------
;;; JUDGMENT-IDENTITY CHAINING (SOL DESIGN RULING, DECISION 1).
;;;
;;;   prior governed judgment -> judged claim identity -> judged proposition
;;;      -> current ground premise -> current receipt records the inherited basis
;;;
;;; A previously judged claim may discharge a premise ONLY through an
;;; IDENTITY-BEARING REFERENCE to the actual governed judgment.  All seven
;;; conditions, and where each is enforced:
;;;
;;;   1. the support identifies an existing claim by DURABLE CLAIM IDENTITY
;;;      -- the support IS the claim struct; CLAIM-ID is its durable identity and
;;;         is what the receipt records (never a copy of the claim, never a name).
;;;   2. ACCESSIBLE under the already-governing accessibility rule
;;;      -- %CLAIM-ACCESSIBLE-P, the witness rule read against CLAIM-ID.
;;;   3. positive :VERIFIED judgment
;;;      -- JUDGMENT-RECORD-JUDGMENT must be EQ :VERIFIED.  :REFUTED does not
;;;         discharge; neither does the absence of a judgment.
;;;   4. the NORMALIZED JUDGED PROPOSITION equals the required ground premise
;;;      -- %MATCH-PROPOSITION of the premise pattern against CLAIM-PROPOSITION
;;;         under the incoming bindings: the identical instrument, on the
;;;         identical footing, as a witness's WITNESS-FOR.
;;;   5. the JUDGMENT RECORD IS LINKED TO THAT EXACT CLAIM IDENTITY
;;;      -- STRUCTURALLY, and this is the load-bearing point: the basis is read
;;;         off (CLAIM-JUDGMENT c) of the very claim whose CLAIM-ID is recorded.
;;;         There is no path by which a free-standing judgment record, or one
;;;         belonging to another claim, can be supplied alongside a claim; the
;;;         linkage cannot be forged because it is never transmitted.
;;;   6. the receiving derivation RECORDS BOTH the supporting claim identity and
;;;      its judgment basis
;;;      -- the :DISCHARGED roster entry carries CLAIM-ID plus the record's
;;;         JUDGMENT, PROCEDURE-ID, PROCEDURE-VERSION, SUPPORT-IDS, RECEIVER and
;;;         ORDINAL, into the premise assessment and so into the receipt.
;;;   7. the original judgment REMAINS INSPECTABLE — never converted into a newly
;;;      minted witness
;;;      -- no witness is minted from a claim anywhere in this file; the claim is
;;;         read, referenced by identity, and left exactly as it was.
;;;
;;; WHAT IS DELIBERATELY *NOT* HERE, each because the ruling forbids it by name:
;;;   * NO schema-to-schema relation.  PROCEDURE-ID is never resolved to a
;;;     schema, and no conclusion pattern is compared to a premise pattern.
;;;     PROCEDURE-ID is RECORDED PROVENANCE, NEVER A HIDDEN COMPATIBILITY
;;;     SELECTOR: it is written into the receipt and read by nothing.  A claim
;;;     from another procedure is accepted not because the procedures are assumed
;;;     compatible but because the exact judgment-bearing claim is the offered
;;;     support and its basis travels with it.
;;;   * NO mode/kind relation.  Neither a claim nor a premise carries the fields
;;;     to express one, and none is invented through naming conventions,
;;;     identifier shapes, or heuristics.  There is no restriction beyond the
;;;     identity-bearing verified-judgment rule.  A future slice may add declared
;;;     premise-source restrictions or typed judgment classes; it must be
;;;     explicit in the surface and receipts, never retrofitted invisibly.
;;;   * NO recursion.  The supporting judgment must ALREADY EXIST before the
;;;     receiving derivation begins: this code reads a judgment that is already on
;;;     the claim and invokes no schema, so no rule chaining is introduced.
;;;
;;; DIAGNOSTIC PRECEDENCE (stated because it is a choice, not a law): a claim is
;;; first tested for proposition match, then for judgment standing, then for
;;; receiver accessibility.  Standing precedes accessibility so that a REFUTED
;;; claim is reported as refuted even when it is also unreachable — the stronger
;;; fact about it.  The precedence changes only which reason is named; no ordering
;;; of these tests can make a non-discharging claim discharge.

(defun %judgment-basis (the-claim)
  "The INSPECTABLE judgment basis carried by THE-CLAIM, or NIL when none is.

A basis is inspectable when the claim holds an actual JUDGMENT-RECORD whose
PROCEDURE-ID is a durable identity — i.e. when the judgment can be traced to the
procedure that made it.  A claim with a judgment whose basis cannot be inspected
does not discharge: an untraceable standing is precisely the thing this decision
exists to stop being launderable."
  (let ((jr (lisp-plus-slice0:claim-judgment the-claim)))
    (and (lisp-plus-slice0:judgment-record-p jr)
         (lisp-plus-kernel0:durable-identity-p
          (lisp-plus-slice0:judgment-record-procedure-id jr))
         jr)))

(defun %evaluate-judged-claim (the-claim pattern-nf env ctx)
  "Evaluate one judged CLAIM as candidate support for one premise under ENV.

Returns (values OUTCOME BINDINGS RECORD).  OUTCOME is :DISCHARGED only when all
seven ruling conditions hold; BINDINGS is the extended environment in that case
and ENV unchanged otherwise; RECORD is the roster plist written into the premise
assessment (and so into the receipt) WHATEVER the outcome — a claim offered in
SUPPORTS is never invisible again."
  (multiple-value-bind (status new-bindings roles)
      (%match-proposition pattern-nf
                          (lisp-plus-slice0:claim-proposition the-claim)
                          env)
    (let* ((jr (lisp-plus-slice0:claim-judgment the-claim))
           (basis (%judgment-basis the-claim))
           (judgment (and (lisp-plus-slice0:judgment-record-p jr)
                          (lisp-plus-slice0:judgment-record-judgment jr))))
      (flet ((record (outcome &rest extra)
               (append (list :claim-id (lisp-plus-slice0:claim-id the-claim)
                             :outcome outcome)
                       extra
                       (when judgment (list :judgment judgment)))))
        (cond
          ((member status '(:predicate-mismatch :role-set-mismatch))
           (values :proposition-does-not-match env
                   (record :proposition-does-not-match)))
          ((eq status :conflict)
           (values :role-conflict env (record :role-conflict :roles roles)))
          ((null jr)
           (values :unjudged env (record :unjudged)))
          ((null basis)
           (values :judgment-basis-unavailable env
                   (record :judgment-basis-unavailable)))
          ((not (eq judgment :verified))
           (values :judgment-not-verified env (record :judgment-not-verified)))
          ((not (%claim-accessible-p the-claim ctx))
           (values :inaccessible-to-receiver env
                   (record :inaccessible-to-receiver)))
          (t
           (values :discharged new-bindings
                   (record :discharged
                           :procedure-id
                           (lisp-plus-slice0:judgment-record-procedure-id basis)
                           :procedure-version
                           (lisp-plus-slice0:judgment-record-procedure-version basis)
                           :support-ids
                           (copy-list
                            (lisp-plus-slice0:judgment-record-support-ids basis))
                           :judgment-receiver
                           (lisp-plus-slice0:judgment-record-receiver basis)
                           :judgment-ordinal
                           (lisp-plus-slice0:judgment-record-ordinal basis)))))))))

;;; ------------------------------------------------------------------
;;; Assess one premise under the accumulated bindings.

(defun %binding-delta (before after)
  "The alist entries present in AFTER but not BEFORE (schema-local extension)."
  (remove-if (lambda (pair) (member pair before :test #'equal)) after))

;;; ------------------------------------------------------------------
;;; CANONICAL ENCODING OF EVIDENTIARY SEQUENCES (SOL DESIGN RULING, DECISION 2).
;;;
;;; The ruling fixes the canonical form of an environment in five parts:
;;;   1. bindings arranged by the schema's DECLARED VARIABLE ORDER;
;;;   2. each bound value satisfying the governing CD/0 boundary;
;;;   3. the complete environment encoded through the CANONICAL DATUM CODEC;
;;;   4. distinct environments ordered LEXICOGRAPHICALLY BY CANONICAL ENCODED
;;;      BYTES;
;;;   5. deduplicated ONLY on byte-identical complete canonical encodings.
;;;
;;; and forbids: printed representation · host hash-table iteration · support
;;; traversal order · host symbol order · object identity · implementation-
;;; specific comparison.  The prior %SORT-ENVS keyed on (FORMAT NIL "~S" e) —
;;; exactly the forbidden first item — and the prior %CANONICAL-ENV arranged
;;; bindings by SYMBOL-NAME — exactly the forbidden fifth.  Both are replaced
;;; here.
;;;
;;; NOTHING IS INVENTED AT THE CANONICAL-DATUM LAYER.  The codec entry point is
;;; the one Slice /0's own proposition validation and Slice /1's D2 quoted-payload
;;; probe already route through: LISP-PLUS-KERNEL0:REQUIRE-CANONICAL (host value
;;; -> CD/0 datum, by an IDENTIFIED canonicalization procedure) followed by
;;; LISP-PLUS-CD0:ENCODE-EXACT (CD/0 datum -> canonical octet string).  Byte
;;; order is read off those octets directly (%OCTETS<), never off a hex or
;;; printed rendering, so no host string collation enters the comparison.
;;;
;;; Boundary note (ruling item 2): every bound value reaching here came out of a
;;; constructor-validated ground proposition, so it is already boundary-lawful by
;;; construction; REQUIRE-CANONICAL is nevertheless the live gate — a value that
;;; would not cross signals the kernel0 typed condition rather than being ordered
;;; by some weaker fallback.

(defun %declared-variable-order (schema)
  "The schema's DECLARED variable order: the conclusion variables as RECORDED AT
CONSTRUCTION, then the declared :LOCALS in declaration order.

Both components are fixed by the schema author's own text and are stable for the
life of the schema.  (The conclusion-variable component is whatever
%PARSE-PROPOSITION recorded when the conclusion pattern was constructed; that
recorded order is not re-derived, re-sorted, or otherwise reinterpreted here —
this function reads a declaration, it does not compute one.)  A variable bound in
an environment but absent from this order cannot arise for a registered schema
(schema construction refuses an undeclared premise variable), and %CANONICAL-ENV
below still gives such a residual a deterministic, non-host-symbol placement
rather than leaving it order-dependent."
  (append (%judgment-schema-conclusion-variables schema)
          (%judgment-schema-locals schema)))

(defun %canonical-octets (host-value)
  "The CD/0 canonical encoding of HOST-VALUE as an octet string.

Delegates, in this exact order, to the two already-governing layers:
LISP-PLUS-KERNEL0:REQUIRE-CANONICAL (the boundary Slice /0 proposition
validation and Slice /1's D2 payload probe both use) and
LISP-PLUS-CD0:ENCODE-EXACT (the canonical datum codec).  Slice /1 supplies no
serializer of its own."
  (lisp-plus-cd0:encode-exact
   (lisp-plus-kernel0:require-canonical host-value)))

(defun %octets< (a b)
  "Strict LEXICOGRAPHIC order on two CD/0 octet strings: first differing octet
decides; otherwise the shorter is first.  Reads octets through the codec's own
accessors — never a printed or hex rendering, so no host character collation
participates."
  (let ((la (lisp-plus-cd0:octets-length a))
        (lb (lisp-plus-cd0:octets-length b)))
    (dotimes (i (min la lb))
      (let ((x (lisp-plus-cd0:octets-ref a i))
            (y (lisp-plus-cd0:octets-ref b i)))
        (cond ((< x y) (return-from %octets< t))
              ((> x y) (return-from %octets< nil)))))
    (< la lb)))

(defun %octets= (a b)
  "BYTE-IDENTITY of two CD/0 octet strings — the ONLY licensed deduplication
test (ruling item 5)."
  (let ((la (lisp-plus-cd0:octets-length a)))
    (and (= la (lisp-plus-cd0:octets-length b))
         (dotimes (i la t)
           (unless (= (lisp-plus-cd0:octets-ref a i)
                      (lisp-plus-cd0:octets-ref b i))
             (return nil))))))

(defun %canonical-sequence (values)
  "The complete canonical SEQUENCE of VALUES: deduplicated ONLY on byte-identical
canonical encodings, then ordered lexicographically by canonical encoded bytes.
Nothing is selected and nothing is discarded except an exact byte duplicate."
  (let ((keyed '()))
    (dolist (v values)
      (let ((bytes (%canonical-octets v)))
        (unless (find bytes keyed :key #'car :test #'%octets=)
          (push (cons bytes v) keyed))))
    (mapcar #'cdr (sort (nreverse keyed) #'%octets< :key #'car))))

;;; ------------------------------------------------------------------
;;; Environment set discipline (CHARTER-DELTA-2, completed by SOL DECISION 2).
;;; An environment is an alist VAR -> VALUE.  Canonical form makes the
;;; environment SET order-independent under EQUAL, so support order can change
;;; neither the decision nor the recorded environment set (M3).

(defun %env->encodable (env)
  "An environment rendered as the proper list of (VAR VALUE) pairs that crosses
the CD/0 boundary.  The stored environment is an ALIST (dotted pairs are not
canonical data); this is the encodable projection of it, and the binding ORDER of
the alist is preserved verbatim — the arrangement decision belongs to
%CANONICAL-ENV, not to the encoder."
  (mapcar (lambda (cell) (list (car cell) (cdr cell))) env))

(defun %canonical-sequence-of-cells (cells)
  "Deterministic arrangement of undeclared binding cells (see %CANONICAL-ENV);
ordered by the canonical encoded bytes of each (VAR VALUE) pair."
  (mapcar (lambda (pair) (cons (first pair) (second pair)))
          (%canonical-sequence (mapcar (lambda (c) (list (car c) (cdr c))) cells))))

(defun %canonical-env (alist order)
  "An environment in CANONICAL FORM: bindings arranged by the schema's DECLARED
VARIABLE ORDER (ruling item 1), never by host symbol order.

ORDER is %DECLARED-VARIABLE-ORDER's list.  Each variable is bound at most once,
so the arrangement is total over the declared variables.  A binding whose
variable is not declared cannot arise for a registered schema; if one ever did it
is placed AFTER the declared bindings, ordered by its own canonical encoded bytes
— deterministic, and still not host symbol order."
  (let* ((entries (copy-alist alist))
         (declared (loop for v in order
                         for cell = (assoc v entries)
                         when cell collect cell))
         (residual (remove-if (lambda (cell) (member (car cell) order :test #'eq))
                              entries)))
    (append declared
            (if (cdr residual)
                (%canonical-sequence-of-cells residual)
                residual))))

(defun %env-canonical-octets (env)
  "The canonical encoded bytes of an ALREADY-CANONICAL environment (ruling item 3)."
  (%canonical-octets (%env->encodable env)))

(defun %sort-envs (envs)
  "The complete canonical SEQUENCE of a SET of canonical environments: distinct
environments ordered LEXICOGRAPHICALLY BY CANONICAL ENCODED BYTES (ruling item 4)
and deduplicated ONLY on byte-identical complete canonical encodings (item 5).

This REPLACES the printed-representation key the ruling names as forbidden.  Its
callers pass environments that %CANONICAL-ENV has already arranged, so the bytes
being compared are the bytes of the canonical form, not of an accidental one."
  (let ((keyed '()))
    (dolist (e envs)
      (let ((bytes (%env-canonical-octets e)))
        (unless (find bytes keyed :key #'car :test #'%octets=)
          (push (cons bytes e) keyed))))
    (mapcar #'cdr (sort (nreverse keyed) #'%octets< :key #'car))))

(defun %uniqueness-conflicts (unique-locals complete-envs)
  "Per declared uniqueness-bearing local, the distinct values it takes ACROSS the
COMPLETE coherent environments; a local with >1 surviving value is a conflict.
Returns a list of (LOCAL CANONICAL-VALUES CARRYING-ENVIRONMENTS).  Judged over
COMPLETE environments only (Delta-2), so an incomplete environment's stray value
never manufactures a conflict (M12).

SOL DECISION 2: the surviving-value sequence is ordered by CANONICAL ENCODED
BYTES, not by the printed representation it used before — the same forbidden
mechanism, one field over."
  (loop for u in unique-locals
        for vals = (remove-duplicates
                    (loop for e in complete-envs
                          for cell = (assoc u e)
                          when cell collect (cdr cell))
                    :test #'equal)
        when (> (length vals) 1)
          collect (list u
                        (%canonical-sequence vals)
                        (%sort-envs
                         (remove-if-not (lambda (e) (assoc u e)) complete-envs)))))

;;; Assess every premise AND enumerate complete environments across premises in
;;; one pass.  Two carries advance premise by premise:
;;;   COMPLETE-ENVS — environments that have discharged EVERY premise so far by
;;;     an accessible match (the Delta-2 existential set); empties permanently the
;;;     first time a premise admits no accessible extension of a live complete env.
;;;   ASSESS-ENVS   — the robust context for the per-premise structured view; a
;;;     premise that adds no binding leaves it unchanged (so later premises are
;;;     still assessed, exactly as the pre-Delta-2 single-thread did) — but it
;;;     never re-seeds COMPLETE-ENVS.
;;; A premise-local plurality on a NON-unique local is never a refusal (it simply
;;; multiplies the environment set); ambiguity is decided afterward, from
;;; declared uniqueness over the COMPLETE environments only.

(defun %build-assessment (raw conflicts)
  "Build one premise-assessment from RAW gathered data and the global uniqueness
CONFLICTS.  Disposition order (the SIX charter dispositions preserved — no
seventh status is minted): refuting blocks > declared-uniqueness conflict on a
bound local (:ambiguous) > accessible match, BY WITNESS OR BY DISCHARGING JUDGED
CLAIM (:satisfied) > inaccessible residue > mismatched (predicate matched, role
conflict) > missing.

CHARTER-DELTA-4 (R-POLARITY-1).  \"Refuting blocks\" reads the UNION of the two
recognized refuting species: Slice /1 REFUTATION objects (REFUTING) and matching,
accessible Slice /0 witnesses whose declared polarity is :REFUTES
(REFUTING-WITNESSES).  Both are classified ONCE, both are preserved in their own
roster, and neither is unsupported residue.  No new condition family, no seventh
disposition.

SOL DECISION 1.  A judged claim now participates on the same footing as a
witness at every rung: it can satisfy, it can be inaccessible residue, and its
role conflict is a mismatch.  A claim that MATCHES but is unjudged, refuted, or
basis-less leaves the premise :MISSING — no support discharged it — but the
premise is no longer SILENT about it: the claim, and the exact reason it did not
discharge, are in :JUDGED-CLAIMS and are named in the repair advice.  That is the
misdirection repair: the receipt used to tell the programmer to supply exactly
what the programmer had supplied.

SOL DECISION 2, as corrected for NAME by CHARTER-DELTA-4 (R-GROUNDING-NAME-1).
:GROUND-INSTANCES is the canonical SEQUENCE of CONCLUSION-PROJECTED PREMISE
INSTANCES — one per INCOMING environment, deduplicated on byte-identical canonical
encodings — not (FIRST ASSESS-ENVS), and NOT the complete binding environment set.
The normative complete set is :BINDING-ENVIRONMENTS here and
COMPLETE-BINDING-ENVIRONMENTS at the receipt."
  (destructuring-bind (&key premise pnf incoming-envs accessible inaccessible
                            mismatched refuting refuting-witnesses deltas
                            claims-discharging claims-inaccessible
                            claims-conflicting claim-records)
      raw
    (let* ((pvars (%proposition-pattern-variables premise))
           (this-conflicts (remove-if-not (lambda (c) (member (first c) pvars))
                                          conflicts))
           (satisfied-by (or accessible claims-discharging))
           (disposition
             ;; CHARTER-DELTA-4: the UNION of the two refuting species blocks.
             (cond ((or refuting refuting-witnesses) :refuted)
                   ((and satisfied-by this-conflicts) :ambiguous)
                   (satisfied-by :satisfied)
                   ((or inaccessible claims-inaccessible) :inaccessible)
                   ((or mismatched claims-conflicting) :mismatched)
                   (t :missing))))
      (%make-premise-assessment
       :premise-pattern pnf
       :ground-instances (%canonical-sequence
                          (mapcar (lambda (env) (%instantiate pnf env))
                                  incoming-envs))
       :judged-claims claim-records
       :matching-accessible-supports accessible
       :matching-inaccessible-supports inaccessible
       :mismatched-candidates mismatched
       :refuting-supports refuting
       :refuting-witnesses refuting-witnesses
       :binding-environments (%sort-envs deltas)
       :ambiguities (if (eq disposition :ambiguous)
                        (loop for c in this-conflicts
                              collect (list (first c) (second c)))
                        '())
       :disposition disposition))))

(defun %assess-and-enumerate (premises base-env witnesses refutations claims ctx
                              unique-locals var-order)
  "Return (values ASSESSMENTS COMPLETE-ENVS UNIQUENESS-CONFLICTS).
ASSESSMENTS: one premise-assessment per premise (Δ2 structured view, six
dispositions preserved).  COMPLETE-ENVS: the canonical sequence of environments
discharging every premise.  UNIQUENESS-CONFLICTS: from declared :unique-locals.

CLAIMS are the already-judged claims offered in SUPPORTS (SOL DECISION 1); they
are considered for every premise under every live environment, exactly as
witnesses are, and every one of them is recorded per premise whatever becomes of
it.  VAR-ORDER is the schema's declared variable order (SOL DECISION 2); it is
the arrangement every environment is canonicalized under before it is encoded,
compared, or stored."
  (let ((assess-envs (list (%canonical-env base-env var-order)))
        (complete-envs (list (%canonical-env base-env var-order)))
        (raws '()))
    (dolist (premise premises)
      (let ((pnf (%proposition-pattern-normal-form premise))
            (incoming-envs assess-envs)
            (accessible '()) (inaccessible '()) (mismatched '())
            (refuting '()) (refuting-witnesses '()) (deltas '())
            (claims-discharging '()) (claims-inaccessible '())
            (claims-conflicting '()) (claim-records '())
            (assess-out '()) (complete-out '()))
        (dolist (env assess-envs)
          (let ((env-complete (member env complete-envs :test #'equal)))
            (dolist (w witnesses)
              (multiple-value-bind (status nb conflicts)
                  (%match-proposition pnf (lisp-plus-slice0:witness-for w) env)
                (case status
                  (:match
                   ;; CHARTER-DELTA-4 (R-POLARITY-1).  DIRECTION IS CLASSIFIED
                   ;; HERE, BEFORE POSITIVE MATCHING SUPPORT IS ACCUMULATED —
                   ;; which is the whole repair.  Before this, EVERY matching
                   ;; accessible witness was pushed onto ACCESSIBLE and extended
                   ;; the environment set, so a witness DECLARING :REFUTES
                   ;; discharged the premise it contradicted and was tallied as
                   ;; positive corroboration.  That was not an omission but an
                   ;; INVERSION: counter-evidence on the positive side of the
                   ;; ledger.
                   (cond
                     ;; Matching + INACCESSIBLE is :INACCESSIBLE residue REGARDLESS
                     ;; of polarity — accessibility is decided first and polarity
                     ;; does not override it.  A witness the receiver cannot reach
                     ;; is not applied as refutation any more than as support.
                     ((not (%support-accessible-p w ctx))
                      (pushnew w inaccessible))
                     ;; Matching + accessible + :REFUTES is REFUTING EVIDENCE.  It
                     ;; enters its own roster and NOTHING else: not ACCESSIBLE, not
                     ;; DELTAS, not ASSESS-OUT, not COMPLETE-OUT.  It therefore
                     ;; cannot discharge the premise, cannot raise the positive
                     ;; matching-support count, and cannot contribute a binding
                     ;; environment to the grant path.
                     ((%witness-refutes-p w)
                      (pushnew w refuting-witnesses))
                     ;; Matching + accessible + :SUPPORTS — the pre-Delta-4 path,
                     ;; unchanged.
                     (t
                      (let ((ext (%canonical-env nb var-order))
                            (delta (%canonical-env (%binding-delta env nb)
                                                   var-order)))
                        (pushnew w accessible)
                        (pushnew delta deltas :test #'equal)
                        (pushnew ext assess-out :test #'equal)
                        (when env-complete
                          (pushnew ext complete-out :test #'equal))))))
                  ;; A role CONFLICT is :MISMATCHED regardless of polarity, and is
                  ;; not applied as refutation (CHARTER-DELTA-4).
                  (:conflict (pushnew (cons w conflicts) mismatched :test #'equal))
                  (t nil))))                     ; predicate/role-set mismatch: skip
            ;; SOL DECISION 1 — judgment-identity chaining.  A discharging claim
            ;; extends the environment set exactly as a discharging witness does;
            ;; a non-discharging one extends nothing and is recorded with the
            ;; reason.  No witness is minted from a claim, here or anywhere.
            (dolist (c claims)
              (multiple-value-bind (outcome nb record)
                  (%evaluate-judged-claim c pnf env ctx)
                (pushnew record claim-records :test #'equal)
                (case outcome
                  (:discharged
                   (let ((ext (%canonical-env nb var-order))
                         (delta (%canonical-env (%binding-delta env nb) var-order)))
                     (pushnew c claims-discharging)
                     (pushnew delta deltas :test #'equal)
                     (pushnew ext assess-out :test #'equal)
                     (when env-complete
                       (pushnew ext complete-out :test #'equal))))
                  (:inaccessible-to-receiver (pushnew c claims-inaccessible))
                  (:role-conflict (pushnew c claims-conflicting))
                  (t nil))))
            (dolist (r refutations)
              (multiple-value-bind (status nb cf)
                  (%match-proposition pnf (refutation-refutes r) env)
                (declare (ignore nb cf))
                (when (eq status :match) (pushnew r refuting))))))
        ;; advance the two carries
        (setf complete-envs (remove-duplicates complete-out :test #'equal))
        (setf assess-envs (if assess-out
                              (remove-duplicates assess-out :test #'equal)
                              assess-envs))
        (push (list :premise premise :pnf pnf :incoming-envs incoming-envs
                    :accessible (nreverse accessible)
                    :inaccessible (nreverse inaccessible)
                    :mismatched (nreverse mismatched)
                    :refuting (nreverse refuting)
                    :refuting-witnesses (nreverse refuting-witnesses)
                    :deltas deltas
                    :claims-discharging (nreverse claims-discharging)
                    :claims-inaccessible (nreverse claims-inaccessible)
                    :claims-conflicting (nreverse claims-conflicting)
                    :claim-records (nreverse claim-records))
              raws)))
    (setf raws (nreverse raws)
          complete-envs (%sort-envs complete-envs))
    (let ((conflicts (%uniqueness-conflicts unique-locals complete-envs)))
      (values (mapcar (lambda (raw) (%build-assessment raw conflicts)) raws)
              complete-envs
              conflicts))))

(defun %judged-claims-with-outcome (assessment &rest outcomes)
  "The assessment's judged-claim roster entries whose :OUTCOME is one of OUTCOMES."
  (remove-if-not (lambda (r) (member (getf r :outcome) outcomes))
                 (%premise-assessment-judged-claims assessment)))

(defun %claim-outcome-summary (records)
  "(CLAIM-ID-KEY OUTCOME) per roster entry — the shape repair advice names a
seen-but-not-discharging claim in."
  (mapcar (lambda (r) (list (lisp-plus-kernel0:identity-key (getf r :claim-id))
                            (getf r :outcome)))
          records))

(defun %repair-for (assessment)
  "What would discharge this unsatisfied premise (Δ6 / charter §6).

SOL DECISION 2: the :MISSING advice names the ground instance when the premise
has exactly ONE grounding environment (unchanged), and ALL of them, under a
plural key, when it has several — it never picks one to keep the old key's shape.
The internal plural slot is read directly; the singular public projection refuses
above cardinality one, and repair advice must not be the thing that fires it.

SOL DECISION 1: :MISSING no longer MISDIRECTS.  When judged claims were offered
and seen but did not discharge, the advice names them and the exact reason
alongside the support request, instead of telling the programmer to supply what
the programmer already supplied.  Likewise :INACCESSIBLE and :MISMATCHED name
claim identities beside witness identities."
  (let* ((instances (%premise-assessment-ground-instances assessment))
         (seen (%judged-claims-with-outcome
                assessment :unjudged :judgment-not-verified
                :judgment-basis-unavailable)))
    (case (premise-assessment-disposition assessment)
      (:missing
       (append (if (cdr instances)
                   (list :supply-accessible-support-matching-any-of
                         (%copy-value instances))
                   (list :supply-accessible-support-matching
                         (%copy-value (first instances))))
               (when seen
                 (list :judged-claims-seen-but-not-discharging
                       (%claim-outcome-summary seen)))))
      (:mismatched
       (append
        (list :supply-support-with-corrected-roles
              (mapcar (lambda (mc) (cons (lisp-plus-slice0:witness-id (car mc))
                                         (cdr mc)))
                      (premise-assessment-mismatched-candidates assessment)))
        (let ((cc (%judged-claims-with-outcome assessment :role-conflict)))
          (when cc
            (list :judged-claims-with-conflicting-roles
                  (mapcar (lambda (r)
                            (cons (lisp-plus-kernel0:identity-key (getf r :claim-id))
                                  (getf r :roles)))
                          cc))))))
      (:inaccessible
       (append
        (list :grant-receiver-access-to
              (mapcar #'lisp-plus-slice0:witness-id
                      (premise-assessment-matching-inaccessible-supports assessment)))
        (let ((ic (%judged-claims-with-outcome assessment :inaccessible-to-receiver)))
          (when ic
            (list :grant-receiver-access-to-judged-claims
                  (mapcar (lambda (r) (getf r :claim-id)) ic))))))
      (:refuted
       ;; CHARTER-DELTA-4 (R-POLARITY-1): advice for BOTH refuting species, each
       ;; under its own key and each named ONLY when present.  The refutation-object
       ;; key is emitted exactly as before, so a premise refuted only by refutation
       ;; objects — every :REFUTED premise that existed before this delta — produces
       ;; byte-identical advice.
       (append
        (when (%premise-assessment-refuting-supports assessment)
          (list :withdraw-or-answer-refutation
                (mapcar #'refutation-id
                        (%premise-assessment-refuting-supports assessment))))
        (when (%premise-assessment-refuting-witnesses assessment)
          (list :withdraw-or-answer-refuting-witness
                (mapcar #'lisp-plus-slice0:witness-id
                        (%premise-assessment-refuting-witnesses assessment))))))
      (:ambiguous
       ;; CHARTER-DELTA-2: Slice /1 has NO discriminator mechanism — a declared
       ;; uniqueness conflict is resolved only by removing the competing support
       ;; for the uniqueness-bearing local (named, with its surviving values).
       (list :resolve-declared-uniqueness-conflict-on
             (premise-assessment-ambiguities assessment)))
      (t nil))))

;;; ==================================================================
;;; DERIVE — the governed derived-judgment act.  Resolves the schema, binds the
;;; conclusion, assesses premises, ALWAYS issues a receipt, and on full coherent
;;; discharge mints a derivation witness and drives the frozen RAISE — a real
;;; Slice /0 promotion keyed to (:derivation (:schema NAME VER)).

(defun %bind-conclusion (schema conclusion ctx-id)
  "Bind conclusion variables from the ground CONCLUSION.  Refuses (typed) if any
conclusion variable is left unbound.

D1 (SLICE1-ERRATUM-1 docket, owner-determined threshold): this refusal is
POST-THRESHOLD.  The schema has been RESOLVED and CONCLUSION is already a lawful
normal form, so the invocation has become a CONSTRUCTIBLE DERIVATION ATTEMPT —
the attempted derivation is identifiable — and the refusal MUST therefore carry
a derivation-receipt, exactly as DERIVATION-REFUSED does at its two sites.  The
receipt records ONLY what is actually known here: the resolved schema's name and
version, the lawful conclusion normal form, the acting origin context, a
:REFUSED decision, and EMPTY assessment structure — no premise was assessed, and
none is invented (no bindings, no complete environments, no uniqueness
conflicts, no strongest-lawful-result, no repair options, and — CHARTER-DELTA-3
clause 12 — no unsupported-support residue, because :SUPPORTS is not classified
on this path at all).

The three PRE-threshold exits — PATTERN-USED-AS-GROUND (before schema
resolution), SCHEMA-NOT-FOUND (schema resolution failed), and
MALFORMED-STRUCTURED-PROPOSITION (the conclusion never became a lawful
proposition) — fire before a derivation is constructible; they are lawful typed
pre-derivation failures and MUST NOT manufacture a fictional receipt."
  (let ((cnf (%proposition-pattern-normal-form (judgment-schema-conclusion schema))))
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
                         :offending-value conclusion
                         :receipt
                         (%make-derivation-receipt
                          :schema-name (judgment-schema-name schema)
                          :schema-version (judgment-schema-version schema)
                          :conclusion conclusion
                          :bindings nil
                          :complete-binding-environments nil
                          :uniqueness-conflicts nil
                          :assessments nil
                          :decision :refused
                          :strongest-lawful-result nil
                          :repair-options nil
                          ;; CHARTER-DELTA-3, clause 12: this exit is
                          ;; PRE-ASSESSMENT.  :SUPPORTS was never classified
                          ;; here, so there is no residue to report and none is
                          ;; manufactured — an unsupported value in :SUPPORTS
                          ;; does not give this receipt a field it did not earn,
                          ;; exactly as it does not give it premises.
                          :unsupported-supports nil
                          :identity (lisp-plus-kernel0:make-identity
                                     :receipt (format nil "derivation-receipt-~D"
                                                      (%next-ordinal)))
                          :origin-context ctx-id
                          :ordinal (%next-ordinal))))
        bindings))))

(defun %build-conclusion-procedure (schema)
  "The conclusion's judgment procedure: :semantic, admitting ONLY the schema's
own derivation key.  This is the S3 closure — a generic content witness is
refused by the frozen admissibility gate because it is not a
(:derivation (:schema NAME VER)) support.  NB: a same-image hand-built witness
forging that key WITHOUT a governed DERIVE is the acknowledged stratum-3
host-escape boundary — see CHARTER-DELTA-1.md Δ3 'Acknowledged inherited
boundary' — inherited from Slice /0's closure unchanged; the slice claims
nothing stronger."
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

(defun %classify-supports (supports)
  "CHARTER-DELTA-3.  ONE classification step over :SUPPORTS.  Every element is
visited exactly once, in caller order, and lands in exactly one of four places:

  (values WITNESSES REFUTATIONS CLAIMS UNSUPPORTED-DESCRIPTORS)

This replaces three independent REMOVE-IF-NOT filters whose union was a PROPER
SUBSET of SUPPORTS — everything outside that union fell through all three and
was silently discarded, which is exactly the defect this delta repairs.

EXACTLY-ONCE IS PROVABLE, NOT ASSUMED.  WITNESS, CLAIM and REFUTATION are three
DEFSTRUCTs with no :INCLUDE — three sibling structure classes directly under
STRUCTURE-OBJECT — so the three predicates are pairwise disjoint and the COND's
order is not a silent precedence rule: no object can satisfy two of them, and
the branch an element takes does not depend on the order they are tested in.
(Shown, not claimed: all six SUBTYPEP pairs answer NIL with certainty T.)

ORDER.  The three recognized buckets come back in caller-relative order, which
is precisely what the REMOVE-IF-NOT filters produced — the downstream evaluator
sees the same three lists it saw before, element for element.

NO CORE /0 KNOWLEDGE.  An element is unsupported because it is NOT one of the
three admitted species — never because Slice /1 recognized it as something else.
There is no blacklist here and no dependency on Language Core /0; a core0
effect account is residue for exactly the reason the integer 17 is."
  (let ((witnesses '()) (refutations '()) (claims '()) (unsupported '()))
    (loop for element in supports
          for index from 0
          do (cond ((lisp-plus-slice0:witness-p element) (push element witnesses))
                   ((refutation-p element) (push element refutations))
                   ((lisp-plus-slice0:claim-p element) (push element claims))
                   ;; The residue.  Canonical inert data — an index and a
                   ;; reason.  The object itself is NOT captured, in any form.
                   (t (push (list :index index
                                  :reason :unsupported-support-species)
                            unsupported))))
    (values (nreverse witnesses) (nreverse refutations) (nreverse claims)
            (nreverse unsupported))))

(defun derive (&key schema-name schema-version conclusion supports receiver by)
  "The governed derived-judgment act.  Resolve schema (SCHEMA-NAME,
SCHEMA-VERSION) by exact key; bind conclusion variables from the ground
CONCLUSION; assess each premise over SUPPORTS — whose three RECOGNIZED species
are Slice /0 witnesses, Slice /1 refutations and Slice /0 claims (SOL DECISION
1), any other element being unsupported residue recorded at the receipt and
assessed against nothing (CHARTER-DELTA-3) — relative to the acting RECEIVER
context; ALWAYS issue a derivation receipt.  On full coherent discharge, mint a
derivation witness and drive the
frozen RAISE — returning (values granted-claim receipt).  On refusal, SIGNAL a
typed DERIVATION-REFUSED carrying the receipt (mirroring Slice /0's RAISE)."
  (%require-ground conclusion :conclusion)
  (let* ((schema (resolve-schema schema-name schema-version))
         (conclusion-nf (proposition conclusion))
         (ctx receiver)
         (ctx-id (and ctx (lisp-plus-slice0:receiver-context-context-id ctx)))
         ;; CHARTER-DELTA-3.  ONE classification step replaces the three
         ;; independent REMOVE-IF-NOT filters that stood here.  Their union was
         ;; a PROPER SUBSET of SUPPORTS, so anything outside the three species
         ;; fell through all three and VANISHED — supplying it was, through
         ;; every public reader, indistinguishable from supplying nothing.  It
         ;; is now classified exactly once and, when unrecognized, recorded on
         ;; the receipt as inert residue.  VISIBLE, still NOT ADMISSIBLE.
         (classified (multiple-value-list (%classify-supports supports)))
         (witnesses (first classified))
         (refutations (second classified))
         ;; SOL DECISION 1.  A CLAIM in SUPPORTS used to fall through all three
         ;; filters and be SILENTLY DISCARDED — the premise landed :missing with
         ;; every evidential field empty, and the repair advice told the
         ;; programmer to supply exactly what had been supplied.  Claims are now
         ;; a first-class support kind: considered per premise, recorded per
         ;; premise whatever becomes of them, and able to discharge ONLY through
         ;; an identity-bearing reference to their own governed judgment.
         (claims (third classified))
         ;; The residue itself — descriptors only, never the objects.  It rides
         ;; to the receipt and NOWHERE ELSE: it is passed to no assessment, no
         ;; environment, no disposition, no repair advice, no grant path.
         (unsupported-supports (fourth classified))
         ;; D1: CTX-ID rides in so the post-threshold UNBOUND-CONCLUSION-VARIABLE
         ;; receipt can record the acting origin context truthfully.
         (base-env (%bind-conclusion schema conclusion-nf ctx-id))
         (unique-locals (%judgment-schema-unique-locals schema))
         ;; SOL DECISION 2: the schema's DECLARED variable order, computed once
         ;; and used as the arrangement for every environment canonicalized in
         ;; this derivation.
         (var-order (%declared-variable-order schema)))
    ;; CHARTER-DELTA-2: enumerate complete environments across premises (a
    ;; premise-local plurality on a non-unique local never refuses); ambiguity is
    ;; decided afterward from declared uniqueness over the COMPLETE environments.
    (multiple-value-bind (assessments complete-envs uniqueness-conflicts)
        (%assess-and-enumerate (%judgment-schema-premises schema)
                               base-env witnesses refutations claims ctx
                               unique-locals var-order)
      (let* ((has-premises (%judgment-schema-premises schema))
             ;; refutation still blocks regardless of environments (M11)
             (refuted-p (some (lambda (a)
                                (eq (premise-assessment-disposition a) :refuted))
                              assessments))
             ;; GRANT iff a complete coherent environment exists, no declared
             ;; uniqueness conflict, and no refutation — preserving ALL complete
             ;; environments (a premiseless schema cannot silently grant).
             (granted-p (and has-premises complete-envs
                             (not refuted-p) (null uniqueness-conflicts)))
             (receipt (%make-derivation-receipt
                     :schema-name schema-name :schema-version schema-version
                     :conclusion conclusion-nf
                     :bindings (and granted-p (first complete-envs))
                     :complete-binding-environments complete-envs
                     :uniqueness-conflicts uniqueness-conflicts
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
                     ;; CHARTER-DELTA-3.  Recorded at the INVOCATION level, not
                     ;; per premise: an unrecognized object cannot be
                     ;; meaningfully matched against an individual premise, so
                     ;; attributing it to one would be an invention.  It reaches
                     ;; the receipt AFTER the decision has been computed above
                     ;; from the recognized species alone — the residue changes
                     ;; nothing it can see.
                     :unsupported-supports unsupported-supports
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
                         :receipt receipt))))))

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
;; AUDIT-1 repair 3: idempotent registration.  The predicate is the SYMBOL
;; 'derivation-receipt-p (EQ across reloads, and a lawful funcall designator at
;; the frozen WHY loop) — not #'derivation-receipt-p, which is a fresh function
;; object each load and so member-unstable.  The find-guard makes reloading
;; slice1.lisp install no duplicate: the registry grows by exactly one entry
;; total across any number of loads.
(unless (find 'derivation-receipt-p lisp-plus-slice0::*why-extractors* :key #'car)
  (push (cons 'derivation-receipt-p #'identity) lisp-plus-slice0::*why-extractors*))

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
  ;; CHARTER-DELTA-2: name environment plurality and any declared uniqueness
  ;; conflict — both drawn ONLY from the receipt's own fields.
  (let ((envs (derivation-receipt-complete-binding-environments receipt)))
    (when (> (length envs) 1)
      (format stream "  complete binding environments: ~D (plurality preserved~
~:[~; — multiply supported~])~%"
              (length envs) (derivation-receipt-multiply-supported-p receipt))))
  (dolist (uc (derivation-receipt-uniqueness-conflicts receipt))
    (format stream "  uniqueness conflict on ~S: surviving values ~S~%"
            (first uc) (second uc)))
  ;; CHARTER-DELTA-3.  Receipt-level residue, named at the caller's own index.
  ;; Printed on GRANTED and REFUSED receipts alike, and drawn — like every other
  ;; line here — ONLY from the receipt's own stored field: the prose says a value
  ;; WAS supplied and had NO effect; it never prints the value, never names its
  ;; host type, never calls it absent, mismatched, evaluated, rejected-as-false,
  ;; or admitted.  The structured reader, not this prose, is authoritative.
  (let ((residue (derivation-receipt-unsupported-supports receipt)))
    (when residue
      (format stream "  unsupported supplied values: ~D~%" (length residue))
      (dolist (u residue)
        (format stream "    :supports[~D] — unsupported support species; not ~
assessed; no effect on decision~%" (getf u :index)))))
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
    ;; CHARTER-DELTA-4 (R-POLARITY-1): the second refuting species, printed as
    ;; REFUTING and never as corroboration.  Drawn only from the receipt's own
    ;; field, and worded so the DECLARED direction is what is claimed — the line
    ;; says the witness declares :REFUTES, not that the premise is false.
    (when (premise-assessment-refuting-witnesses a)
      (format stream "    refuted by witness declaring polarity :REFUTES: ~{~A~^, ~} ~
(counter-evidence, NOT positive support; positive support, if any, remains)~%"
              (mapcar (lambda (w) (lisp-plus-kernel0:identity-key
                                   (lisp-plus-slice0:witness-id w)))
                      (premise-assessment-refuting-witnesses a))))
    ;; SOL DECISION 2: the premise's PROJECTION multiplicity, named where it is
    ;; plural.  Disposition and multiplicity are SEPARATE AXES — one disposition
    ;; may rest on many grounds — so this line never implies ambiguity, and the
    ;; uniqueness-conflict lines above never imply a single ground.
    ;;
    ;; CHARTER-DELTA-4 (R-GROUNDING-NAME-1): this line reports the PROJECTED
    ;; PREMISE INSTANCE count, which is NOT the complete-binding-environment count
    ;; printed above and is not a bound on it in either direction.  Its silence
    ;; therefore means "one projection", NEVER "one complete environment" — the
    ;; ordinary case for a premise that binds a schema-local is a single projection
    ;; over several complete environments.
    (let ((gis (premise-assessment-ground-instances a)))
      (when (cdr gis)
        (format stream "    projected premise instances: ~D distinct, all preserved ~
(NOT an ambiguity, and NOT the complete-environment count)~%" (length gis))))
    ;; SOL DECISION 1: every judged claim offered and considered for this
    ;; premise, and what became of it — the discharging ones with the judgment
    ;; basis they carried in.  Drawn only from the receipt's own fields.
    (dolist (jc (premise-assessment-judged-claims a))
      (if (eq (getf jc :outcome) :discharged)
          (format stream "    discharged by judged claim ~A: judgment ~S under ~
procedure ~A v~S (basis preserved, not restated)~%"
                  (lisp-plus-kernel0:identity-key (getf jc :claim-id))
                  (getf jc :judgment)
                  (lisp-plus-kernel0:identity-key (getf jc :procedure-id))
                  (getf jc :procedure-version))
          (format stream "    judged claim ~A did NOT discharge: ~S~@[ on roles ~S~]~%"
                  (lisp-plus-kernel0:identity-key (getf jc :claim-id))
                  (getf jc :outcome)
                  (getf jc :roles))))
    (when (premise-assessment-ambiguities a)
      (format stream "    ambiguous candidates: ~S~%"
              (premise-assessment-ambiguities a))))
  (dolist (ro (derivation-receipt-repair-options receipt))
    (format stream "  repair for ~S: ~S~%" (second (car ro)) (cdr ro)))
  receipt)
