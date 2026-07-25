;;;; slice2.lisp — Language Slice /2, CANDIDATE /0: SOURCE-BOUND ADMISSION.
;;;;
;;;; Governed by LANGUAGE-SLICE-2-WORK-ORDER-0.md (owner-issued, 2026-07-25).
;;;; Four design movements preceded this one and each ended in a negative
;;;; result; their laws are carried here as code rather than as prose:
;;;;
;;;;   R-ADMISSION-0.1  species is not provenance
;;;;   R-ADMISSION-0.2  standing is not origin
;;;;   R-ADMISSION-0.5  procedure allowlisting does not cure laundering
;;;;   R-ADMISSION-0.8  binding is not implication
;;;;   R-SOURCE-1.1     coherence is not authenticity
;;;;   R-SOURCE-1.4     successful execution is not automatic domain truth
;;;;   R-SOURCE-1.6     authenticity cannot be inferred from type membership
;;;;   R-SOURCE-1.10    the canonical request stays unreadable
;;;;   R-ISSUANCE-0.10  the issuance ceiling, restated at every citation
;;;;
;;;; THE GOAL, verbatim from the work order:
;;;;
;;;;   A premise may explicitly require a source-bound basis.  Such a basis can
;;;;   be created only from current-image-issued Core /0 evidence bound to the
;;;;   exact request and interpreted through a mechanically defined source
;;;;   relation.  Raw witnesses and ordinarily raised claims cannot impersonate
;;;;   it.
;;;;
;;;; WHAT SLICE /2 IS NOT.  It is not an authenticity mechanism for the outside
;;;; world.  Every ceiling below is image-local and account-report-shaped: the
;;;; strongest thing a source basis ever says is "the Core /0 runtime minted
;;;; this exact account content in this image, for this request, and the
;;;; account reports X."  Whether X happened is not a question this file can
;;;; ask, and no relation here pretends otherwise (D2-0.6).
;;;;
;;;; Run: sbcl --non-interactive --load slice2.lisp   (loads its dependencies)

(unless (find-package :lisp-plus-core0)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "../language-core-0/core0.lisp" *load-truename*))))

(unless (find-package :lisp-plus-slice2)
  (load (merge-pathnames "package.lisp" *load-truename*)))

(in-package #:lisp-plus-slice2)

;;; ==================================================================
;;; Deterministic ordinal — constitutive order, no wall clock (slice0 §4,
;;; mirrored by slice1 and core0).

(defvar *slice2-ordinal* 0)
(defun %next-ordinal () (incf *slice2-ordinal*))

;;; ==================================================================
;;; Condition layer — PARALLEL to slice0 / slice1 / core0, mirroring their
;;; style.  All contract enforcement lives in SIGNAL-SLICE2, never in a
;;; condition initializer (the kernel0 defect-receipt lesson: initializers are
;;; inert under SBCL 2.4.6's MAKE-CONDITION).  Every refusal is typed, carries
;;; the offending field and value, and — for a derivation refusal — the Slice /2
;;; receipt, exactly as DERIVATION-REFUSED carries the Slice /1 one.

(define-condition slice2-condition (error)
  ((failed-invariant :initarg :failed-invariant
                     :reader slice2-condition-failed-invariant)
   (offending-field :initarg :offending-field :initform nil
                    :reader slice2-condition-offending-field)
   (offending-value :initarg :offending-value :initform nil
                    :reader slice2-condition-offending-value)
   (receipt :initarg :receipt :initform nil
            :reader slice2-condition-receipt))
  (:report (lambda (c stream)
             (format stream "~A: ~A"
                     (type-of c) (slice2-condition-failed-invariant c)))))

(macrolet ((families (base &rest names)
             `(progn ,@(loop for n in names
                             collect `(define-condition ,n (,base) ())))))
  (families slice2-condition
            admission-contract-error slice2-schema-error
            source-basis-refused slice2-derivation-refused)
  ;; A clause the contract vocabulary does not define.  Refused AT CONSTRUCTION
  ;; (D2-0.1): a contract that cannot be evaluated must not exist, so there is
  ;; no path by which an unevaluable clause reaches a premise.
  (families admission-contract-error unknown-admission-clause)
  (families slice2-schema-error
            premise-contract-missing premise-contract-duplicate
            premise-contract-unknown-premise)
  ;; The account was not issued by Core /0 in this image FOR THIS REQUEST.  Its
  ;; meaning is EXACTLY that, after Core /0's own UNISSUED-EVIDENCE: it says
  ;; nothing about how the value was produced and makes no accusation about the
  ;; caller (R-ISSUANCE-0.5's wording, carried up one layer).
  (families source-basis-refused unissued-core0-account)
  ;; CANDIDATE /1.  A derivation basis could not be established, or a value of
  ;; its shape could not be used.  Like UNISSUED-CORE0-ACCOUNT it says exactly
  ;; what it says and makes no claim about how the value was produced.
  (families slice2-condition derivation-basis-refused))

(defun signal-slice2 (condition-type &rest initargs
                      &key failed-invariant offending-field offending-value
                           receipt)
  (declare (ignore offending-field offending-value receipt))
  (unless (stringp failed-invariant)
    (error "signal-slice2 requires a :failed-invariant string"))
  (apply #'error condition-type initargs))

(defun %refuse (type field value invariant &rest args)
  (signal-slice2 type
                 :failed-invariant (apply #'format nil invariant args)
                 :offending-field field :offending-value value))

;;; ==================================================================
;;; Copy discipline.  Slice /1's %COPY-VALUE, re-derived here rather than
;;; borrowed across the package boundary (it is internal to Slice /1): descend
;;; cons structure, COPY-SEQ string leaves, pass immutable atoms through.
;;;
;;; DECLARED CEILING, the same one Slice /1 declares and no larger: this walks
;;; CONSES and STRINGS.  A struct leaf — a kernel0 durable identity, a Slice /0
;;; witness, a Core /0 account — is NOT copied by it.  Those leaves are
;;; read-only structures, so this is a declared *undetached object*, never a
;;; declared *mutable escape*.  The guarantee is exactly: no caller-held cons or
;;; string is aliased into stored Slice /2 state.

(defun %copy-value (v)
  (cond ((consp v) (cons (%copy-value (car v)) (%copy-value (cdr v))))
        ((stringp v) (copy-seq v))
        (t v)))

(defun %key (identity)
  "An identity's stable printable key, or NIL.  Used only for rendering and for
proposition role values — never as an admission credential (R-ADMISSION-0.4:
an identity-shaped value is not a binding)."
  (and (lisp-plus-kernel0:durable-identity-p identity)
       (lisp-plus-kernel0:identity-key identity)))

;;; ==================================================================
;;; THE RELATION VOCABULARY (D2-0.6) — EXACTLY THREE, no more.
;;;
;;;   :CORE0-ACCOUNT-ISSUED-FOR-REQUEST
;;;   :CORE0-ACCOUNT-REPORTS-ACKNOWLEDGMENT
;;;   :CORE0-ACCOUNT-REPORTS-OUTCOME
;;;
;;; Each produces a GENERIC PROPOSITION ABOUT THE ACCOUNT.  None produces
;;; :TREATMENT-COMPLETED, :SAFE-TO-EXHIBIT, :DISPATCH-DELIVERED or
;;; :LOAN-SETTLED, and none is named merely :ESTABLISHES.  Applications derive
;;; domain conclusions SEPARATELY, through explicit schemas, and that separation
;;; is R-ADMISSION-0.8 and R-SOURCE-1.3/1.4 carried into code:
;;;
;;;   without it, "source-bound" becomes the next impressive adjective whose
;;;   reader always returns yes.
;;;
;;; WHERE EACH FIELD CHECK COMES FROM — every one is a LIVE public reader, and
;;; no account field is invented:
;;;
;;;   issued-for-request    LISP-PLUS-CORE0:CORE0-EVIDENCE-CURRENT-IMAGE-ISSUED-
;;;                         FOR-REQUEST-P (the conjunction itself)
;;;   reports-acknowledgment  a :REQUEST-ACKNOWLEDGED event for this account's
;;;                         own attempt, read off CORE0-EVIDENCE-EVENTS through
;;;                         KERNEL0:KERNEL0-EVENT-EVENT-TYPE
;;;   reports-outcome       KERNEL0:FOLD-ATTEMPT-OUTCOME over this account's own
;;;                         events and attempt identity, read through
;;;                         ATTEMPT-OUTCOME-STANDING-TERMINAL-CLASS
;;;
;;; The acknowledgment reader deserves a note, because it is the one a reader
;;; will want to over-read.  A :REQUEST-ACKNOWLEDGED event is present in BOTH a
;;; clean commit AND an interrupted, ledger-withholding crossing — measured, not
;;; assumed.  So "acknowledged" means the provider took the request, and NOTHING
;;; about whether the effect settled.  That is exactly why acknowledgment and
;;; outcome are two relations and not one.

(defparameter +core0-source-relations+
  '(:core0-account-issued-for-request
    :core0-account-reports-acknowledgment
    :core0-account-reports-outcome))

(defparameter +relation-version+ 0)

(defun core0-source-relations ()
  "The three relations, as a fresh list.  Fresh so that a caller holding the
result cannot edit the vocabulary."
  (copy-list +core0-source-relations+))

(defun core0-source-relation-p (x)
  (and (member x +core0-source-relations+ :test #'eq) t))

;;; ==================================================================
;;; THE SUPPORT-ADMISSION CONTRACT (D2-0.1).
;;;
;;; A canonical VALUE.  Not a closure, not a predicate function, not a name to
;;; be resolved later.  The reason is the whole lane's reason: a receipt that
;;; retains a closure retains something nobody downstream can read, and "the
;;; contract that applied" would become a promise instead of a record.  This
;;; struct is retained BY VALUE in the receiving receipt (D2-0.1), and identity
;;; and version accompany the snapshot rather than replacing it.
;;;
;;; EXACTLY THREE CLAUSE FAMILIES exist in Candidate /0:
;;;
;;;   (:verified-judged-claim)
;;;   (:source-basis :relations (<one or more of the three relations>))
;;;   (:asserted-witness :mode M :kind K :truth-ceiling :asserted)
;;;
;;; and a fourth is not a configuration change but a language change.

(defparameter +contract-version+ 0
  "The DEFAULT contract version, unchanged by Candidate /1.  A contract written
before Candidate /1 existed keeps exactly the behaviour it had: this is why the
new clause family arrives behind a VERSION rather than by widening version 0.")

(defparameter +known-contract-versions+ '(0 1)
  "The contract versions this implementation can evaluate.  An unknown version
refuses AT CONSTRUCTION, for the same reason an unknown clause does: a contract
whose meaning this image cannot compute must not exist, rather than be
discovered unevaluable at a premise.")

(defparameter +clause-species-v0+
  '(:verified-judged-claim :source-basis :asserted-witness)
  "Candidate /0's three families.  A version-0 contract accepts exactly these,
and REFUSES (:DERIVATION-BASIS) — not by ignoring it, but by refusing to be
constructed.")

(defparameter +clause-species-v1+
  '(:verified-judged-claim :source-basis :asserted-witness :derivation-basis)
  "Candidate /1 adds EXACTLY ONE family.  It has no caller-selectable options:
there is nothing to configure, because the only question a derivation-basis
clause asks is whether this premise accepts the route at all.")

(defun %clause-species-for-version (version)
  (ecase version (0 +clause-species-v0+) (1 +clause-species-v1+)))

(defparameter +known-clause-species+ +clause-species-v1+
  "Every species any supported version defines.  Kept for readers; the
version-specific list is what a contract is validated against.")

(defparameter +known-proposition-relations+ '(:exact-normalized-equality))

(defparameter +known-receiver-accessibility+ '(:required :optional))

(defparameter +known-retention-items+
  '(:contract-snapshot :support-identity :support-basis :source-basis))

;;; The truth ceiling of each clause family.  TWO of the three are FIXED by the
;;; mechanism and are NOT caller-selectable: a caller must not be able to
;;; declare a stronger ceiling than the mechanism earns, which is precisely the
;;; move R-ADMISSION-0.2 and R-SOURCE-1.2 exist to stop.  The asserted-witness
;;; ceiling IS written by the caller — and must be written as :ASSERTED
;;; (D2-0.10), so writing it is an acknowledgement, never a choice.

(defparameter +source-basis-truth-ceiling+
  :current-image-issued-account-report
  "The R-ISSUANCE-0.10 ceiling, named.  It reads: this exact canonical account
content was minted by the Core /0 runtime in THIS Lisp image, for THIS request,
and the account REPORTS the stated field.  It does not read: the deed occurred.")

(defparameter +derivation-basis-truth-ceiling+ :prior-explicit-admission-judgment
  "CANDIDATE /1's fixed ceiling, and it is FIXED — not caller-selectable.

It reads, exactly: this exact claim was granted by DERIVE/2 under explicit
per-premise admission contracts whose resulting admission record is retained in
the attached receipt.

It does NOT read: that every premise was source-bound; that every premise was
externally verified; that an admitted asserted witness became source evidence;
that the conclusion inherits :CURRENT-IMAGE-ISSUED-ACCOUNT-REPORT; that the
conclusion is externally true; or that an effect occurred or settled.

An effect-sensitive premise that requires an actual Core /0 account report must
still require a SOURCE BASIS.  A derivation basis must never impersonate one,
and the two ceilings are distinct keywords so that no reader can confuse them.")

(defparameter +judged-claim-truth-ceiling+ :prior-governed-judgment
  "A positively judged claim establishes that a governed judgment was made and
is inspectable.  It does not establish that the judgment's basis was bound to a
real observation, effect, attempt, acknowledgment or authority act
(R-ADMISSION-0.2), which is why an effect-sensitive premise should not use this
clause (D2-0.9).")

(defstruct (support-admission-contract
            (:constructor %make-support-admission-contract)
            (:conc-name %support-admission-contract-)
            (:copier nil))
  (contract-id nil :read-only t)
  (contract-version 0 :read-only t)
  (accepted-clauses nil :read-only t)       ; normalized, defensively copied
  (proposition-relation nil :read-only t)
  (receiver-accessibility nil :read-only t)
  (retain nil :read-only t)
  (truth-ceilings nil :read-only t))        ; ((SPECIES . CEILING) …), derived

(defun %clause-species (clause) (and (consp clause) (first clause)))

(defun %normalize-clause (clause &optional (version +contract-version+))
  "Validate ONE clause and return it in canonical form.  Refuses AT
CONSTRUCTION — an unknown species, a species this CONTRACT VERSION does not
define, an unknown option, a missing required option, an unknown relation, or a
ceiling the mechanism does not earn."
  (unless (and (consp clause) (keywordp (first clause))
               (evenp (length (rest clause))))
    (%refuse 'unknown-admission-clause :accepted-clauses clause
             "an admission clause must be (SPECIES-KEYWORD [OPTION VALUE]…); got ~S"
             clause))
  (let ((species (first clause))
        (options (rest clause)))
    (unless (member species (%clause-species-for-version version) :test #'eq)
      (%refuse 'unknown-admission-clause :accepted-clauses species
               "~S is not an admission clause species a version-~D contract ~
defines.  Version ~D accepts ~{~S~^, ~} — and a further family is a language ~
change, not a configuration change, so it is refused here rather than ignored ~
at evaluation time.  (:DERIVATION-BASIS arrived in Candidate /1 behind ~
contract version 1 precisely so that a version-0 contract written before it ~
existed keeps exactly the behaviour it had.)"
               species version version (%clause-species-for-version version)))
    (flet ((opt (k) (getf options k))
           (only (&rest allowed)
             (loop for (k nil) on options by #'cddr
                   unless (member k allowed :test #'eq)
                     do (%refuse 'unknown-admission-clause :accepted-clauses k
                                 "~S is not an option of the ~S clause; the ~
options are ~{~S~^, ~}" k species allowed))))
      (ecase species
        (:verified-judged-claim
         (only)
         (list :verified-judged-claim))
        (:source-basis
         (only :relations)
         (let ((relations (opt :relations)))
           (unless (and (consp relations)
                        (every #'core0-source-relation-p relations))
             (%refuse 'unknown-admission-clause :relations relations
                      "a (:source-basis :relations …) clause must name a ~
non-empty list drawn from ~{~S~^, ~}; got ~S.  There is no relation named ~
merely :ESTABLISHES, and there is no wildcard (D2-0.6)"
                      (core0-source-relations) relations))
           (list :source-basis :relations
                 (remove-duplicates (copy-list relations) :from-end t))))
        (:derivation-basis
         ;; NO caller-selectable options in Candidate /1, and no ceiling to
         ;; write: the ceiling is fixed by the mechanism (Work Order /1 §5).
         ;; A clause with nothing to configure is not an oversight — it is the
         ;; statement that the only question is whether this premise accepts
         ;; the route.
         (only)
         (list :derivation-basis))
        (:asserted-witness
         (only :mode :kind :truth-ceiling)
         (let ((mode (opt :mode)) (kind (opt :kind))
               (ceiling (opt :truth-ceiling)))
           (unless (member mode '(:direct :testimony) :test #'eq)
             (%refuse 'unknown-admission-clause :mode mode
                      "an (:asserted-witness …) clause must name :MODE :DIRECT ~
or :TESTIMONY; got ~S.  :DERIVATION is refused deliberately — it is the mode ~
Slice /1 grants wear and the mode a source basis's carrier wears, and a clause ~
that admitted it would let a bare witness stand where a governed basis is ~
required" mode))
           (unless (keywordp kind)
             (%refuse 'unknown-admission-clause :kind kind
                      "an (:asserted-witness …) clause must name a :KIND ~
keyword explicitly; got ~S.  The accepted kind is named so that reading the ~
contract tells you what assertion the premise accepts (D2-0.10)" kind))
           (unless (eq ceiling :asserted)
             (%refuse 'unknown-admission-clause :truth-ceiling ceiling
                      "an (:asserted-witness …) clause must declare ~
:TRUTH-CEILING :ASSERTED; got ~S.  The ceiling is written out so the contract ~
cannot pretend the assertion is source-bound or externally verified — this is ~
not a complete authenticity mechanism and is not to be cited as one (D2-0.10)"
                      ceiling))
           (list :asserted-witness :mode mode :kind kind
                 :truth-ceiling :asserted)))))))

(defun %clause-ceiling (clause)
  (ecase (%clause-species clause)
    (:verified-judged-claim +judged-claim-truth-ceiling+)
    (:source-basis +source-basis-truth-ceiling+)
    (:derivation-basis +derivation-basis-truth-ceiling+)
    (:asserted-witness (getf (rest clause) :truth-ceiling))))

(defun make-support-admission-contract
    (&key contract-id (contract-version +contract-version+)
          accepted-clauses (proposition-relation :exact-normalized-equality)
          (receiver-accessibility :required)
          (retain (copy-list +known-retention-items+)))
  "Construct a support-admission contract — a canonical VALUE (D2-0.1).

Every field is validated here, so an unevaluable contract cannot exist.  The
clause list is normalized and DEFENSIVELY COPIED on ingress; every reader
copies on egress; every slot is read-only.  A caller that mutates the list it
passed cannot revise the contract, and a caller that mutates a returned list
cannot revise it either.

ACCEPTED-CLAUSES is a non-empty list drawn from exactly three families:

  (:verified-judged-claim)
  (:source-basis :relations (…))
  (:asserted-witness :mode M :kind K :truth-ceiling :asserted)

There are NO arbitrary predicate functions.  A clause is data a reader can
inspect, not a closure a reader must trust.

RECEIVER-ACCESSIBILITY :REQUIRED means a premise under this contract cannot be
satisfied when DERIVE/2 was given no receiver context — Slice /1 treats a null
receiver as universal reach, and a source-bound premise should not inherit
that by omission."
  (unless (and (consp accepted-clauses) (listp accepted-clauses))
    (%refuse 'admission-contract-error :accepted-clauses accepted-clauses
             "a contract must accept at least one clause; a contract accepting ~
nothing is a premise nothing can discharge, which is a schema decision and not ~
a contract (got ~S)" accepted-clauses))
  (unless (member proposition-relation +known-proposition-relations+ :test #'eq)
    (%refuse 'admission-contract-error :proposition-relation proposition-relation
             "the only proposition relation Candidate /0 defines is ~
:EXACT-NORMALIZED-EQUALITY (Slice /1 normal-form matching, unchanged); got ~S"
             proposition-relation))
  (unless (member receiver-accessibility +known-receiver-accessibility+ :test #'eq)
    (%refuse 'admission-contract-error :receiver-accessibility receiver-accessibility
             ":RECEIVER-ACCESSIBILITY must be ~{~S~^ or ~}; got ~S"
             +known-receiver-accessibility+ receiver-accessibility))
  (unless (and (listp retain)
               (every (lambda (r) (member r +known-retention-items+ :test #'eq))
                      retain))
    (%refuse 'admission-contract-error :retain retain
             ":RETAIN must be a list drawn from ~{~S~^, ~}; got ~S"
             +known-retention-items+ retain))
  (unless (and contract-id (or (keywordp contract-id) (stringp contract-id)))
    (%refuse 'admission-contract-error :contract-id contract-id
             "a contract MUST carry an explicit :CONTRACT-ID (a keyword or a ~
string) so a receipt can name which contract applied; got ~S" contract-id))
  (unless (integerp contract-version)
    (%refuse 'admission-contract-error :contract-version contract-version
             "a contract version must be an integer; got ~S" contract-version))
  (unless (member contract-version +known-contract-versions+ :test #'eql)
    (%refuse 'admission-contract-error :contract-version contract-version
             "~S is not a contract version this implementation can evaluate; ~
the known versions are ~{~D~^, ~}.  An unknown version refuses AT ~
CONSTRUCTION rather than at a premise: a contract whose meaning cannot be ~
computed must not exist" contract-version +known-contract-versions+))
  (let ((normalized (mapcar (lambda (c) (%normalize-clause c contract-version))
                            accepted-clauses)))
    ;; One clause per species: two :SOURCE-BASIS clauses would make "which
    ;; relations does this premise accept" a question with two answers.
    (let ((species (mapcar #'%clause-species normalized)))
      (unless (= (length species) (length (remove-duplicates species)))
        (%refuse 'admission-contract-error :accepted-clauses species
                 "a contract names each clause species AT MOST ONCE; ~S repeats ~
one, and a premise whose accepted set has two answers has none" species)))
    (%make-support-admission-contract
     :contract-id contract-id
     :contract-version contract-version
     :accepted-clauses (%copy-value normalized)
     :proposition-relation proposition-relation
     :receiver-accessibility receiver-accessibility
     :retain (%copy-value retain)
     :truth-ceilings (mapcar (lambda (c) (cons (%clause-species c)
                                               (%clause-ceiling c)))
                             normalized))))

(defun support-admission-contract-contract-id (c)
  (%support-admission-contract-contract-id c))
(defun support-admission-contract-contract-version (c)
  (%support-admission-contract-contract-version c))
(defun support-admission-contract-proposition-relation (c)
  (%support-admission-contract-proposition-relation c))
(defun support-admission-contract-receiver-accessibility (c)
  (%support-admission-contract-receiver-accessibility c))
(defun support-admission-contract-accepted-clauses (c)
  "The normalized accepted clauses, as a DEFENSIVE STRUCTURAL COPY.  Mutating
the returned list — or any clause inside it — cannot revise the contract."
  (%copy-value (%support-admission-contract-accepted-clauses c)))
(defun support-admission-contract-retain (c)
  (%copy-value (%support-admission-contract-retain c)))
(defun support-admission-contract-truth-ceilings (c)
  "((CLAUSE-SPECIES . TRUTH-CEILING) …) for every clause this contract accepts.
The ceiling is what a support of that species can establish AT MOST, and it is
recorded so a reader never has to infer it from the species name."
  (%copy-value (%support-admission-contract-truth-ceilings c)))

(defun %contract-clause (contract species)
  (find species (%support-admission-contract-accepted-clauses contract)
        :key #'%clause-species))

(defun support-admission-contract-admits-species-p (contract species)
  "Does CONTRACT name a clause of SPECIES?  A species test only — it is NOT the
admission decision, which additionally consults the clause's own options and,
for a source basis, this image's established-basis registry."
  (and (%contract-clause contract species) t))

;;; ==================================================================
;;; PER-PREMISE ATTACHMENT (D2-0.2 / D2-0.3).
;;;
;;; Contracts attach to PREMISE POSITIONS.  Schema-wide uniform policy is
;;; rejected because `de-codice-restaurando` needs one premise demanding
;;; source-bound treatment evidence and another legitimately accepting a direct
;;; condition survey — in the SAME schema, at the same time.
;;;
;;; There is no implicit default, no inheritance by predicate name, procedure
;;; ID, package or convention, no hidden registry, no procedure-ID heuristic,
;;; and no inference from witness mode or kind.  The schema NAMES the contract
;;; for each premise, or the schema does not exist.

(defstruct (slice2-schema (:constructor %make-slice2-schema)
                          (:conc-name %slice2-schema-) (:copier nil))
  (schema-id nil :read-only t)
  (schema-version 0 :read-only t)
  (base-schema nil :read-only t)          ; a Slice /1 judgment-schema
  (premise-contracts nil :read-only t))   ; ((INDEX . CONTRACT-SNAPSHOT) …), sorted

(defun %snapshot-contract (contract)
  "A fresh contract carrying deep-copied clause data.  Registration takes a
SNAPSHOT rather than the caller's object, so nothing a caller keeps a handle on
is reachable from the registered schema.  (The contract's own slots are already
read-only; this closes the remaining path — a shared cons or string leaf.)"
  (%make-support-admission-contract
   :contract-id (%support-admission-contract-contract-id contract)
   :contract-version (%support-admission-contract-contract-version contract)
   :accepted-clauses (%copy-value
                      (%support-admission-contract-accepted-clauses contract))
   :proposition-relation
   (%support-admission-contract-proposition-relation contract)
   :receiver-accessibility
   (%support-admission-contract-receiver-accessibility contract)
   :retain (%copy-value (%support-admission-contract-retain contract))
   :truth-ceilings (%copy-value
                    (%support-admission-contract-truth-ceilings contract))))

(defun make-slice2-schema (&key schema-id (schema-version 0)
                                base-schema premise-contracts)
  "Attach one contract to each premise position of BASE-SCHEMA.

PREMISE-CONTRACTS is a list of (INDEX CONTRACT) or (INDEX . CONTRACT) entries,
zero-based against the base schema's own premise order.  EVERY premise position
gets EXACTLY ONE contract: a missing index, a duplicate index and an index the
base schema does not have each REFUSE with a typed Slice /2 condition.

Contracts are SNAPSHOT at registration.  Caller mutation after registration —
of the alist, of a clause list, of a string inside one — cannot revise the
registered schema, and the snapshots remain fully inspectable through
SLICE2-SCHEMA-PREMISE-CONTRACTS."
  (unless (lisp-plus-slice1:judgment-schema-p base-schema)
    (%refuse 'slice2-schema-error :base-schema base-schema
             "a Slice /2 schema is an ATTACHMENT to a Slice /1 judgment-schema; ~
:BASE-SCHEMA must be one (got ~S).  Slice /2 declares no premises of its own — ~
the anatomy stays where it was declared" (type-of base-schema)))
  (unless (and schema-id (or (keywordp schema-id) (stringp schema-id)))
    (%refuse 'slice2-schema-error :schema-id schema-id
             "a Slice /2 schema MUST carry an explicit :SCHEMA-ID; got ~S"
             schema-id))
  (let* ((premises (lisp-plus-slice1:judgment-schema-premises base-schema))
         (n (length premises))
         (seen (make-hash-table :test #'eql))
         (pairs '()))
    (when (zerop n)
      (%refuse 'slice2-schema-error :base-schema schema-id
               "the base schema declares no premises, so there is nothing for a ~
contract to attach to; Slice /1 already refuses to grant a premiseless schema"))
    (dolist (entry premise-contracts)
      (let (index contract)
        (cond ((and (consp entry) (consp (cdr entry)) (null (cddr entry)))
               (setf index (first entry) contract (second entry)))
              ((and (consp entry) (not (consp (cdr entry))))
               (setf index (car entry) contract (cdr entry)))
              (t (%refuse 'slice2-schema-error :premise-contracts entry
                          "each :PREMISE-CONTRACTS entry must be (INDEX ~
CONTRACT) or (INDEX . CONTRACT); got ~S" entry)))
        (unless (and (integerp index) (<= 0 index) (< index n))
          (%refuse 'premise-contract-unknown-premise :premise-contracts index
                   "premise index ~S does not exist: the base schema declares ~D ~
premise~:P, so the lawful indices are 0..~D" index n (1- n)))
        (unless (support-admission-contract-p contract)
          (%refuse 'slice2-schema-error :premise-contracts contract
                   "premise ~D must name a SUPPORT-ADMISSION-CONTRACT value; got ~
~S.  A contract is data (D2-0.1) — a function, a name to be resolved, or a ~
keyword standing for a policy is refused here" index (type-of contract)))
        (when (gethash index seen)
          (%refuse 'premise-contract-duplicate :premise-contracts index
                   "premise ~D is named twice; a premise with two contracts has ~
no contract" index))
        (setf (gethash index seen) t)
        (push (cons index (%snapshot-contract contract)) pairs)))
    (loop for i below n
          unless (gethash i seen)
            do (%refuse 'premise-contract-missing :premise-contracts i
                        "premise ~D of ~D has no admission contract.  There is ~
NO implicit default and no inheritance by predicate name, procedure ID, ~
package or convention (D2-0.2/D2-0.3): the premise pattern is ~S"
                        i n
                        (lisp-plus-slice1:proposition-pattern-normal-form
                         (nth i premises))))
    (%make-slice2-schema
     :schema-id schema-id :schema-version schema-version
     :base-schema base-schema
     :premise-contracts (sort pairs #'< :key #'car))))

(defun slice2-schema-schema-id (s) (%slice2-schema-schema-id s))
(defun slice2-schema-schema-version (s) (%slice2-schema-schema-version s))
(defun slice2-schema-base-schema (s) (%slice2-schema-base-schema s))
(defun slice2-schema-premise-contracts (s)
  "((INDEX . CONTRACT) …) in premise order.  The list spine is fresh; the
contract values are the registered SNAPSHOTS, which are immutable structures
whose own readers copy.  Inspectable without being revisable."
  (mapcar (lambda (p) (cons (car p) (cdr p)))
          (%slice2-schema-premise-contracts s)))

(defun slice2-schema-contract-for-premise (s index)
  "The contract attached to premise INDEX, or a typed refusal.  Never NIL and
never a default: a premise without a contract cannot be inside a Slice /2
schema, because MAKE-SLICE2-SCHEMA refused to build one."
  (let ((cell (assoc index (%slice2-schema-premise-contracts s))))
    (unless cell
      (%refuse 'premise-contract-missing :index index
               "no admission contract is attached to premise ~S" index))
    (cdr cell)))

(defun %account-acknowledgment (evidence)
  "The acknowledgment status this account REPORTS: :ACKNOWLEDGED when its own
event sequence records a :REQUEST-ACKNOWLEDGED event for its own attempt,
:NOT-REPORTED otherwise.  A status about the ACCOUNT's testimony — never about
the world."
  (let ((attempt (lisp-plus-core0:core0-evidence-attempt-id evidence)))
    (if (some (lambda (e)
                (and (eq (lisp-plus-kernel0:kernel0-event-event-type e)
                         :request-acknowledged)
                     (let ((a (lisp-plus-kernel0:kernel0-event-attempt-id e)))
                       (and a (lisp-plus-kernel0:identity= a attempt)))))
              (lisp-plus-core0:core0-evidence-events evidence))
        :acknowledged
        :not-reported)))

(defun %account-outcome (evidence)
  "The terminal class this account's own event fold reports for its own
attempt, or :NOT-REPORTED when the fold names none.  Fold-derived, exactly as
Core /0 requires standing to be — never read off a self-reported field."
  (handler-case
      (let ((standing (lisp-plus-kernel0:fold-attempt-outcome
                       (lisp-plus-core0:core0-evidence-events evidence)
                       (lisp-plus-core0:core0-evidence-attempt-id evidence))))
        (values (or (lisp-plus-kernel0:attempt-outcome-standing-terminal-class
                     standing)
                    :not-reported)
                (lisp-plus-kernel0:attempt-outcome-standing-unresolved-effect-p
                 standing)))
    (error () (values :not-reported nil))))

;;; ==================================================================
;;; THE SOURCE BASIS (D2-0.5) — a DISTINCT support species.
;;;
;;; A source basis is NOT a witness, NOT a claim, NOT a judgment standing, NOT a
;;; copied identifier, NOT a copied payload, and NOT a procedure-allowlist
;;; result.  It is a governed record binding five things:
;;;
;;;   an actual current-image-issued Core /0 account
;;;   the exact canonical request it belongs to
;;;   one mechanically defined source relation
;;;   one mechanically derived proposition
;;;   one explicit truth ceiling
;;;
;;; THE CARRIER, stated plainly because it is the one place a reader could be
;;; misled.  A source basis holds an internal Slice /0 witness whose :FOR is the
;;; produced proposition.  That witness is a TRANSPORT — it is how the derived
;;; proposition reaches Slice /1's matcher, which Slice /2 does not reimplement.
;;; It is NOT the authority.  Admission is decided by the ESTABLISHED-BASIS
;;; REGISTRY below, never by the carrier's mode, kind, source, procedure or
;;; content — so a caller who mints a witness with byte-identical attributes
;;; gets a witness, not a basis, and a caller who obtains a genuine carrier and
;;; offers it BARE gets an unadmitted witness at a source-bound premise.  The
;;; carrier is deliberately not exposed by any reader.
;;;
;;; This is R-ADMISSION-0.5 honoured rather than evaded: the promotion procedure
;;; is NOT the discriminator, because a promotion procedure is publicly
;;; constructible and would separate nothing.

(defstruct (source-basis (:constructor %make-source-basis)
                         (:conc-name %source-basis-) (:copier nil))
  (identity nil :read-only t)
  (version 0 :read-only t)
  (species nil :read-only t)               ; :core0-account
  (attempt-id nil :read-only t)            ; the SOURCE ATTEMPT identity
  (request nil :read-only t)               ; canonical request snapshot
  (relation-kind nil :read-only t)
  (relation-version 0 :read-only t)
  (proposition nil :read-only t)           ; the produced proposition
  (account-status nil :read-only t)        ; reported acknowledgment status
  (account-outcome nil :read-only t)       ; reported outcome kind
  (truth-ceiling nil :read-only t)
  (issuance-basis nil :read-only t)
  (account-snapshot nil :read-only t)      ; defensive copy, inspection only
  (carrier nil :read-only t))              ; INTERNAL transport; no public reader

;;; The PRIVATE, IMAGE-LOCAL registry of source bases this image established.
;;; It exists for the reason Core /0's issuance registry exists (R-SOURCE-1.6):
;;; a structure class is not an authenticity mechanism, and a value built
;;; through the host object model satisfies every type predicate.  There is no
;;; public reader, no public writer, and no id-to-object lookup — the only
;;; question it answers is "is THIS object one I established?", asked about an
;;; object the caller already holds.  That is not a resolver.
;;;
;;; It is an EQ table, and that is a deliberate difference from Core /0's
;;; exact-content registry.  Core /0 had to let a defensive COPY of an account
;;; survive, because copying an account is a lawful thing for a client to do.
;;; A source basis is a token this image hands out and takes back; there is no
;;; reason a reconstruction of one should be admitted, so none is.  Said
;;; plainly rather than dressed up: a structural copy of a source basis is NOT
;;; admitted, and Slice /2 does not pretend copies are safe.

(defvar *established-source-bases* (make-hash-table :test #'eq)
  "Source-basis objects established by ESTABLISH-CORE0-SOURCE-BASIS in THIS
image.  Image-local by construction: nothing here earns crash survival,
durability, cross-image standing or serialization authenticity.")

(defun %register-source-basis (basis)
  (setf (gethash basis *established-source-bases*) t)
  basis)

(defun source-basis-established-in-current-image-p (basis)
  "Was BASIS established by ESTABLISH-CORE0-SOURCE-BASIS in this Lisp image?

EXACT CEILING.  A true answer establishes AT MOST that this object came out of
this image's source-basis constructor, which in turn checked current-image
issuance for an exact request.  It does not establish that the external-world
deed occurred, that the provider told the truth, that the adapter is honest, or
that the account's semantic interpretation is correct.  Answers false — never
signals — for anything that is not a source basis, including a value built
through the host object model (R-SOURCE-1.6: type membership is not
authenticity)."
  (and (source-basis-p basis)
       (gethash basis *established-source-bases*)
       t))

(defvar *established-derivation-bases* (make-hash-table :test #'eq)
  "Derivation-basis objects minted by the successful DERIVE/2 path in THIS
image.  Parallel in shape to *ESTABLISHED-SOURCE-BASES*, EQ for the same stated
reason: a basis is a token this image hands out and takes back, so a structural
reconstruction of one is NOT admitted and Slice /2 does not pretend copies are
safe.  Nothing here earns durability, cross-image standing or serialization
authenticity.")

(defun %register-derivation-basis (basis)
  (setf (gethash basis *established-derivation-bases*) t)
  basis)

(defun %clear-slice2-registries ()
  "Image hygiene / test isolation, after Slice /1's CLEAR-SCHEMA-REGISTRY and
Core /0's %CLEAR-CORE0-ISSUANCE-REGISTRY — and INTERNAL for the same reason: no
public registry access is authorised."
  (clrhash *established-source-bases*)
  (clrhash *established-derivation-bases*)
  (values))

(defun %relation-procedure (relation)
  (lisp-plus-kernel0:make-identity
   :procedure (format nil "lisp-plus-slice2/core0-source-basis/~(~A~)" relation)))

(defun %source-proposition (relation attempt-key request-nf status outcome)
  "Build the GENERIC proposition this relation produces — about the ACCOUNT.

Every one is constructed through the PUBLIC Slice /1 PROPOSITION constructor,
so it is in normal form with roles sorted, and can therefore actually match a
premise pattern.  The request rides as a (:QUOTED-DATUM …) because it is
LITERAL DATA whose shape must never be read as a variable."
  (let ((request-value (list :quoted-datum request-nf)))
    (lisp-plus-slice1:proposition
     (ecase relation
       (:core0-account-issued-for-request
        `(:predicate :core0-account-issued-for-request
          (:attempt ,attempt-key) (:request ,request-value)))
       (:core0-account-reports-acknowledgment
        `(:predicate :core0-account-reports-acknowledgment
          (:attempt ,attempt-key) (:request ,request-value)
          (:acknowledgment ,status)))
       (:core0-account-reports-outcome
        `(:predicate :core0-account-reports-outcome
          (:attempt ,attempt-key) (:request ,request-value)
          (:outcome ,outcome)))))))

(defun establish-core0-source-basis (&key evidence request relation expected-outcome)
  "Establish a source basis from a Core /0 account, or refuse with a typed
Slice /2 condition.

The order is fixed and each step is a gate the next one depends on:

  1. Core /0 current-image issued-FOR-REQUEST check    (D2-0.7)
  2. relation-specific account-field check
  3. generic proposition construction                  (D2-0.6)
  4. truth-ceiling assignment
  5. defensive source snapshot
  6. durable source-basis identity creation
  7. registration in this image's established-basis registry

EXPECTED-OUTCOME is optional.  When supplied, the relation's reported value must
equal it or this refuses — so an application that needs a completed account says
so, and gets a refusal instead of a basis whose proposition quietly will not
match.  When omitted, the basis reports whatever the account truthfully reports,
including :NOT-REPORTED, and an indeterminate account therefore produces ONLY
the exact generic proposition it truthfully reports.  It never produces
completion, acknowledgment or settlement standing the account does not report.

THE CEILING, restated here because this is where a caller reads it: a source
basis establishes at most that this exact canonical account content was minted
by the Core /0 runtime in this Lisp image, for this request, and that the
account REPORTS the stated field.  It does not establish that the deed occurred,
that the provider told the truth, that the adapter is honest, or that any domain
proposition holds.  It claims NOTHING across image death."
  (unless (core0-source-relation-p relation)
    (%refuse 'source-basis-refused :relation relation
             "~S is not a Core /0 source relation; the three are ~{~S~^, ~}.  ~
There is no relation named merely :ESTABLISHES, and none of the three produces ~
a domain conclusion (D2-0.6)" relation (core0-source-relations)))
  (unless (lisp-plus-core0:core0-evidence-p evidence)
    (%refuse 'source-basis-refused :evidence (type-of evidence)
             "a source basis is established FROM A CORE /0 ACCOUNT; got ~S"
             (type-of evidence)))
  ;; --- 1. issuance FOR THE EXACT REQUEST -----------------------------
  ;; The conjunction, not either half.  A coherent caller-built account fails
  ;; here; an account reusing a genuine attempt identity fails here; an exact
  ;; content copy of a genuine issued account passes here.
  (let ((request-nf (handler-case (lisp-plus-slice1:proposition request)
                      (error ()
                        (%refuse 'source-basis-refused :request request
                                 "the :REQUEST must be a Slice /1 ground ~
structured proposition — the same vocabulary PERFORM's own :REQUEST is stated ~
in; got ~S" request)))))
    (unless (lisp-plus-core0:core0-evidence-current-image-issued-for-request-p
             evidence request-nf)
      (%refuse 'unissued-core0-account :evidence request-nf
               "this account's exact canonical content is not registered as ~
issued by Core /0 in this image for this request.  That is the whole of the ~
finding: it says nothing about how the value was produced and makes no ~
accusation about the caller.  A structurally coherent account is not issued ~
merely because it is coherent, because its attempt fold validates, or because ~
its attempt identity resembles a real one (R-ISSUANCE-0.1)"))
    ;; --- 2. the relation's own account-field check -------------------
    (let* ((status (%account-acknowledgment evidence))
           (outcome (multiple-value-list (%account-outcome evidence)))
           (outcome-kind (first outcome))
           (unresolved (second outcome))
           (attempt (lisp-plus-core0:core0-evidence-attempt-id evidence))
           (attempt-key (%key attempt))
           (reported (ecase relation
                       (:core0-account-issued-for-request :issued)
                       (:core0-account-reports-acknowledgment status)
                       (:core0-account-reports-outcome outcome-kind))))
      (when (and expected-outcome (not (eq expected-outcome reported)))
        (%refuse 'source-basis-refused :expected-outcome reported
                 "the account reports ~S for ~S, and ~S was required.  The ~
relation may produce ONLY the generic proposition the account truthfully ~
reports; it cannot be asked to report something else (R-SOURCE-1.4)"
                 reported relation expected-outcome))
      ;; --- 3/4. proposition + ceiling --------------------------------
      (let* ((proposition (%source-proposition relation attempt-key request-nf
                                               status outcome-kind))
             ;; --- 5. the defensive source snapshot: EXACTLY the account
             ;; fields this relation consulted, and nothing more.  Inspection
             ;; inside the current image; no persistence is claimed.
             (snapshot
               (%copy-value
                (list* :attempt attempt-key
                       :adapter-identity
                       (%key (lisp-plus-core0:core0-evidence-adapter-identity
                              evidence))
                       :event-types
                       (mapcar #'lisp-plus-kernel0:kernel0-event-event-type
                               (lisp-plus-core0:core0-evidence-events evidence))
                       (ecase relation
                         (:core0-account-issued-for-request
                          (list :consulted :issuance-conjunction-only))
                         (:core0-account-reports-acknowledgment
                          (list :consulted :request-acknowledged-event
                                :acknowledgment status))
                         (:core0-account-reports-outcome
                          (list :consulted :attempt-outcome-fold
                                :terminal-class outcome-kind
                                :unresolved-effect-p unresolved))))))
             ;; --- 6. the durable identity.  ONE identity: the carrier's
             ;; witness id IS the source-basis identity, so a receiver context
             ;; that reaches the basis reaches it under one name, and the
             ;; accessibility rule already in force applies unchanged.
             (carrier (lisp-plus-slice0:witness
                       :for proposition
                       :mode :derivation
                       :kind relation
                       :source :lisp-plus-slice2/core0-source-basis
                       :procedure (%relation-procedure relation)
                       :content (list :source-basis-relation relation
                                      :relation-version +relation-version+
                                      :basis-ordinal (%next-ordinal)))))
        ;; --- 7. establish + register ---------------------------------
        (%register-source-basis
         (%make-source-basis
          :identity (lisp-plus-slice0:witness-id carrier)
          :version 0
          :species :core0-account
          :attempt-id attempt
          :request (%copy-value request-nf)
          :relation-kind relation
          :relation-version +relation-version+
          :proposition proposition
          :account-status status
          :account-outcome outcome-kind
          :truth-ceiling +source-basis-truth-ceiling+
          :issuance-basis (list :core0-current-image-issued-for-request t
                                :checked-by
                                :core0-evidence-current-image-issued-for-request-p
                                :image-local t :persistence nil)
          :account-snapshot snapshot
          :carrier carrier))))))

(defun source-basis-identity (b) (%source-basis-identity b))
(defun source-basis-version (b) (%source-basis-version b))
(defun source-basis-species (b) (%source-basis-species b))
(defun source-basis-attempt-id (b) (%source-basis-attempt-id b))
(defun source-basis-relation-kind (b) (%source-basis-relation-kind b))
(defun source-basis-relation-version (b) (%source-basis-relation-version b))
(defun source-basis-account-status (b) (%source-basis-account-status b))
(defun source-basis-account-outcome (b) (%source-basis-account-outcome b))
(defun source-basis-truth-ceiling (b) (%source-basis-truth-ceiling b))
(defun source-basis-request (b)
  "The exact canonical request this basis is bound to, as a defensive copy."
  (%copy-value (%source-basis-request b)))
(defun source-basis-proposition (b)
  "The generic proposition this basis produces — ABOUT THE ACCOUNT.  It is
never a domain conclusion: applications derive those separately through explicit
schemas (D2-0.6)."
  (%copy-value (%source-basis-proposition b)))
(defun source-basis-issuance-basis (b)
  (%copy-value (%source-basis-issuance-basis b)))
(defun source-basis-account-snapshot (b)
  "A DEFENSIVE COPY of exactly the account fields this basis's relation
consulted.  For inspection inside the current image.  NO persistence is claimed:
after image death these bytes retain no standing whatever, and this snapshot is
not evidence that any external deed occurred."
  (%copy-value (%source-basis-account-snapshot b)))

;;; ==================================================================
;;; THE SLICE /2 RECEIPT.
;;;
;;; A NEW receipt that WRAPS the Slice /1 one.  No existing Slice /1 public
;;; return shape changes: DERIVATION-RECEIPT is exactly what it was, and it is
;;; reachable here through SLICE2-RECEIPT-BASE-RECEIPT.
;;;
;;; THE APPLIED CONTRACT IS RETAINED BY VALUE (D2-0.1) and the source basis by
;;; defensive snapshot.  NO GLOBAL RESOLVER MAY BE REQUIRED to understand why a
;;; premise discharged: everything the question needs is reachable from the
;;; receipt in hand.

(defstruct (premise-admission (:constructor %make-premise-admission)
                              (:conc-name %premise-admission-) (:copier nil))
  (index nil :read-only t)
  (premise-pattern nil :read-only t)
  (contract nil :read-only t)                    ; BY VALUE
  (disposition nil :read-only t)
  (base-disposition nil :read-only t)            ; Slice /1's own, unaltered
  (admitted-supports nil :read-only t)
  (recognized-not-admitted nil :read-only t)
  (source-bases nil :read-only t)
  (derivation-bases nil :read-only t)
  (judged-claims nil :read-only t)
  (refuting-supports nil :read-only t)
  (refuting-witnesses nil :read-only t)
  (projected-premise-instances nil :read-only t)
  (binding-environments nil :read-only t)
  (ambiguities nil :read-only t)
  (truth-ceilings nil :read-only t)
  (reasons nil :read-only t))

(defun premise-admission-index (a) (%premise-admission-index a))
(defun premise-admission-contract (a) (%premise-admission-contract a))
(defun premise-admission-disposition (a) (%premise-admission-disposition a))
(defun premise-admission-base-disposition (a) (%premise-admission-base-disposition a))
(defun premise-admission-premise-pattern (a)
  (%copy-value (%premise-admission-premise-pattern a)))
(defun premise-admission-admitted-supports (a)
  "The supports that BOTH participated positively at this premise in the base
Slice /1 assessment AND are admitted by this premise's contract.  Elements are
the caller's own objects: a Slice /0 witness, a Slice /0 claim, or a Slice /2
source basis."
  (copy-list (%premise-admission-admitted-supports a)))
(defun premise-admission-recognized-not-admitted (a)
  "The supports Slice /1 RECOGNIZED and would have counted, which this premise's
contract does NOT admit.  This is the roster that makes a narrowing visible:
without it, refusing a laundered support would be indistinguishable from never
having been offered one."
  (copy-list (%premise-admission-recognized-not-admitted a)))
(defun premise-admission-derivation-bases (a)
  "The derivation bases ADMITTED at this premise, in caller order."
  (copy-list (%premise-admission-derivation-bases a)))
(defun premise-admission-source-bases (a)
  (copy-list (%premise-admission-source-bases a)))
(defun premise-admission-judged-claims (a)
  (%copy-value (%premise-admission-judged-claims a)))
(defun premise-admission-refuting-supports (a)
  (copy-list (%premise-admission-refuting-supports a)))
(defun premise-admission-refuting-witnesses (a)
  (copy-list (%premise-admission-refuting-witnesses a)))
(defun premise-admission-projected-premise-instances (a)
  (%copy-value (%premise-admission-projected-premise-instances a)))
(defun premise-admission-binding-environments (a)
  (%copy-value (%premise-admission-binding-environments a)))
(defun premise-admission-ambiguities (a)
  (%copy-value (%premise-admission-ambiguities a)))
(defun premise-admission-truth-ceilings (a)
  "((SPECIES . CEILING) …) for the species that ACTUALLY discharged here — not
the contract's whole table.  A premise discharged by an asserted witness carries
:ASSERTED and says so."
  (%copy-value (%premise-admission-truth-ceilings a)))
(defun premise-admission-reasons (a)
  (%copy-value (%premise-admission-reasons a)))

(defstruct (slice2-receipt (:constructor %make-slice2-receipt)
                           (:conc-name %slice2-receipt-) (:copier nil))
  (base-receipt nil :read-only t)
  (schema-id nil :read-only t)
  (schema-version nil :read-only t)
  (conclusion nil :read-only t)
  (decision nil :read-only t)
  (admissions nil :read-only t)
  (unsupported-supports nil :read-only t)
  (identity nil :read-only t)
  (origin-context nil :read-only t)
  (ordinal nil :read-only t))

(defun slice2-receipt-base-receipt (r)
  "The Slice /1 derivation receipt this decision NARROWED.  Slice /1's public
return shapes are unchanged and its receipt is reachable whole — the Slice /2
decision is a conjunct on top of it, never a rewriting of it."
  (%slice2-receipt-base-receipt r))
(defun slice2-receipt-schema-id (r) (%slice2-receipt-schema-id r))
(defun slice2-receipt-schema-version (r) (%slice2-receipt-schema-version r))
(defun slice2-receipt-decision (r) (%slice2-receipt-decision r))
(defun slice2-receipt-identity (r) (%slice2-receipt-identity r))
(defun slice2-receipt-origin-context (r) (%slice2-receipt-origin-context r))
(defun slice2-receipt-conclusion (r) (%copy-value (%slice2-receipt-conclusion r)))
(defun slice2-receipt-admissions (r) (copy-list (%slice2-receipt-admissions r)))
(defun slice2-receipt-unsupported-supports (r)
  "The inert record of every :SUPPORTS element that was none of the FOUR species
Slice /2 recognizes (Slice /2 source basis · Slice /0 witness · Slice /1
refutation · Slice /0 claim), with the CALLER's own zero-based index — not the
index it would have had in the narrowed list Slice /1 was given.  Visibility is
not admissibility, exactly as in CHARTER-DELTA-3: the raw object is not
retained, in any form."
  (%copy-value (%slice2-receipt-unsupported-supports r)))
(defun slice2-receipt-source-bases-used (r)
  "Every source basis that was ADMITTED at some premise, in premise order."
  (remove-duplicates
   (loop for a in (%slice2-receipt-admissions r)
         append (copy-list (%premise-admission-source-bases a)))
   :from-end t))
(defun slice2-receipt-derivation-bases-used (r)
  "Every derivation basis ADMITTED anywhere in this derivation, in premise
order.  The basis objects themselves — so a reader reaches the prior claim, the
prior Slice /2 receipt and its whole admission record WITHOUT a resolver."
  (loop for a in (%slice2-receipt-admissions r)
        append (copy-list (%premise-admission-derivation-bases a))))

(defun slice2-receipt-judged-claims-used (r)
  (remove-duplicates
   (loop for a in (%slice2-receipt-admissions r)
         append (remove-if-not #'lisp-plus-slice0:claim-p
                               (%premise-admission-admitted-supports a)))
   :from-end t))
(defun slice2-receipt-complete-binding-environments (r)
  (lisp-plus-slice1:derivation-receipt-complete-binding-environments
   (%slice2-receipt-base-receipt r)))
(defun slice2-receipt-uniqueness-conflicts (r)
  (lisp-plus-slice1:derivation-receipt-uniqueness-conflicts
   (%slice2-receipt-base-receipt r)))
(defun slice2-receipt-strongest-lawful-result (r)
  "The strongest lawful result SLICE /2 reached — computed over the Slice /2
dispositions, so a premise Slice /1 satisfied and Slice /2 did not admit is
named here as the blocker it actually was."
  (if (eq (%slice2-receipt-decision r) :granted)
      :verified
      (let ((blocking (find-if-not
                       (lambda (a) (eq (%premise-admission-disposition a) :satisfied))
                       (%slice2-receipt-admissions r))))
        (and blocking
             (list :blocked-on
                   (second (%premise-admission-premise-pattern blocking))
                   (%premise-admission-disposition blocking))))))

;;; ==================================================================
;;; THE DERIVATION BASIS (Candidate /1, Work Order /1).
;;;
;;; The downstream half of the frontier.  Candidate /0 let an EFFECT ACCOUNT
;;; reach a premise through a governed source basis; it left open what
;;; [IX-10] recorded one layer down — that a claim granted under admission
;;; contracts travelled onward as an ORDINARY Slice /1 claim, with the account
;;; of its own admission gone by the time it chained.  A later premise could
;;; not tell "this was granted under explicit per-premise contracts" from
;;; "somebody raised an assertion."
;;;
;;; A derivation basis is NOT a claim, a witness, a refutation, a source basis,
;;; a judgment standing, or a second promotion.  It is a governed record that
;;; binds a granted claim to the exact receipt that granted it.
;;;
;;; THE CONSTRUCTOR IS INTERNAL, and that is the whole mechanism.  There is no
;;; public operation that pairs an arbitrary claim with an arbitrary receipt,
;;; because such an operation would let a caller assemble a coherent basis for
;;; a grant that never happened — the Candidate /0 lesson (R-SOURCE-1.7),
;;; applied before it could be repeated: coherence is a property of the object,
;;; and the only defence is that this image minted it.
;;;
;;; ONE DURABLE IDENTITY, not two.  The basis takes the underlying claim's
;;; identity, mirroring the source-basis/carrier arrangement.  A second name
;;; for one support act would be a second thing to keep in agreement, and the
;;; accessibility path already reads claim identities.

(defstruct (derivation-basis (:constructor %make-derivation-basis)
                             (:conc-name %derivation-basis-) (:copier nil))
  (identity nil :read-only t)          ; = the underlying claim's identity
  (version 0 :read-only t)
  (species nil :read-only t)           ; :slice2-derivation
  (claim nil :read-only t)             ; the EXACT granted claim object
  (receipt nil :read-only t)           ; the EXACT slice2-receipt from that act
  (proposition nil :read-only t)       ; the claim proposition
  (schema-id nil :read-only t)
  (schema-version nil :read-only t)
  (origin-context nil :read-only t)
  (truth-ceiling nil :read-only t))

(defun %derivation-basis-coherent-p (b)
  "Is B's own claim/receipt conjunction internally consistent?

Checked SEPARATELY from registry membership, and both are required.  A basis
minted by DERIVE/2 satisfies this by construction — so this predicate exists
for the case the work order names explicitly: a basis whose internal
conjunction is inconsistent must answer FALSE even if it somehow reached the
registry.  Registry membership alone would make the registry the only
authority; this makes the object answerable for itself as well."
  (let ((claim (%derivation-basis-claim b))
        (receipt (%derivation-basis-receipt b)))
    (and (lisp-plus-slice0:claim-p claim)
         (slice2-receipt-p receipt)
         (eq (%slice2-receipt-decision receipt) :granted)
         (eq (%derivation-basis-truth-ceiling b) +derivation-basis-truth-ceiling+)
         (eq (%derivation-basis-species b) :slice2-derivation)
         (lisp-plus-slice1:structured-proposition=
          (lisp-plus-slice0:claim-proposition claim)
          (%slice2-receipt-conclusion receipt))
         (equal (%derivation-basis-schema-id b) (%slice2-receipt-schema-id receipt))
         (eql (%derivation-basis-schema-version b)
              (%slice2-receipt-schema-version receipt))
         t)))

(defun derivation-basis-established-in-current-image-p (basis)
  "Was BASIS minted by the successful DERIVE/2 path in this Lisp image, and is
it internally consistent?

EXACT CEILING.  A true answer establishes AT MOST that this exact
derivation-basis object was minted in this image for this exact claim and this
exact granted Slice /2 receipt.  It does not establish domain truth,
external-world occurrence, adapter honesty, provider honesty, cross-image
standing, durability, serialization authenticity, or cryptographic
authenticity.

ANSWERS FALSE — NEVER SIGNALS — for a non-basis value, a basis-shaped value
built through the host object model, a structural reconstruction or copy, a
basis not minted by the successful DERIVE/2 path, and a basis whose internal
claim/receipt conjunction is inconsistent."
  (and (derivation-basis-p basis)
       (gethash basis *established-derivation-bases*)
       (%derivation-basis-coherent-p basis)
       t))

(defun derivation-basis-identity (b) (%derivation-basis-identity b))
(defun derivation-basis-version (b) (%derivation-basis-version b))
(defun derivation-basis-species (b) (%derivation-basis-species b))
(defun derivation-basis-claim (b)
  "The EXACT granted claim object.  Not a copy: a claim is a read-only Slice /0
structure, and returning a reconstruction would break the identity comparison
the admission conjunct depends on.  This is the already-declared
undetached-object ceiling, not a new one."
  (%derivation-basis-claim b))
(defun derivation-basis-receipt (b)
  "The EXACT prior Slice /2 receipt.  Returned directly, so a downstream reader
reaches the whole prior admission record — applied contracts, source bases,
per-premise truth ceilings — WITHOUT a resolver, which is the requirement this
species exists to meet."
  (%derivation-basis-receipt b))
(defun derivation-basis-proposition (b) (%copy-value (%derivation-basis-proposition b)))
(defun derivation-basis-schema-id (b) (%derivation-basis-schema-id b))
(defun derivation-basis-schema-version (b) (%derivation-basis-schema-version b))
(defun derivation-basis-origin-context (b) (%derivation-basis-origin-context b))
(defun derivation-basis-truth-ceiling (b) (%derivation-basis-truth-ceiling b))

(defun %mint-derivation-basis (claim receipt)
  "Mint and register a derivation basis.  INTERNAL, and called from exactly one
place: DERIVE/2, after it has reached a genuine Slice /2 grant."
  (%register-derivation-basis
   (%make-derivation-basis
    :identity (lisp-plus-slice0:claim-id claim)
    :version 0
    :species :slice2-derivation
    :claim claim
    :receipt receipt
    :proposition (%copy-value (lisp-plus-slice0:claim-proposition claim))
    :schema-id (%slice2-receipt-schema-id receipt)
    :schema-version (%slice2-receipt-schema-version receipt)
    :origin-context (%slice2-receipt-origin-context receipt)
    :truth-ceiling +derivation-basis-truth-ceiling+)))

;;; ==================================================================
;;; DERIVE/2 — the new consequential surface (D2-0.4).
;;;
;;; `derive` REMAINS SLICE /1's and does not change, silently or otherwise.
;;; This act calls it; it does not replace, shadow or reimplement it.
;;;
;;; THE FIXED EVALUATION ORDER (work order §4), and where each step happens:
;;;
;;;    1 classify recognized support species        %CLASSIFY-SUPPORTS/2, here
;;;    2 preserve unsupported residue               %CLASSIFY-SUPPORTS/2, here
;;;    3 proposition match / mismatch               Slice /1, in the base derive
;;;    4 receiver-relative accessibility            Slice /1, in the base derive
;;;    5 direction / refutation semantics           Slice /1, in the base derive
;;;    6 apply the explicit premise admission contract    %ADMIT, here
;;;    7 judged-claim standing and identity rules   Slice /1 (CATENA), consulted
;;;    8 source-basis relation requirements         %ADMIT, here
;;;    9 ordinary binding and ambiguity logic       Slice /1, in the base derive
;;;   10 record the exact contract and basis        the Slice /2 receipt, here
;;;
;;; ADMISSION IS A NARROWING CONJUNCT.  It may refuse positive support.  It may
;;; NOT readmit a mismatch, override inaccessibility, suppress refutation,
;;; convert unsupported evidence into an admitted species, replace CATENA's
;;; claim-identity rules, or select policy through metadata.  The narrowing is
;;; STRUCTURAL rather than promised: steps 3, 4, 5, 7 and 9 are Slice /1's
;;; answers, read and never rewritten, so DERIVE/2 grants only where `derive`
;;; already granted.
;;;
;;; A MISSING CONTRACT IS A TYPED REFUSAL WITH NO PERMISSIVE FALLBACK.  Slice
;;; /1's open admission behaviour is not inherited silently: it cannot be
;;; inherited at all, because MAKE-SLICE2-SCHEMA refuses to build a schema with
;;; an uncontracted premise and DERIVE/2 re-checks the count it was handed.

(defparameter +slice2-dispositions+
  '(:satisfied :not-admitted :refuted :inaccessible :mismatched :ambiguous :missing)
  "Slice /1's six charter dispositions, plus EXACTLY ONE new term:
:NOT-ADMITTED — the premise had recognized, matching, accessible support that
its contract does not accept.  It is a seventh term rather than a reuse of
:MISSING because 'nothing was offered' and 'what was offered is not the kind
this premise takes' are different facts, and collapsing them would reproduce
the misdirection repair Slice /1 already paid for.")

(defun %classify-supports/2 (supports)
  "ONE classification pass over :SUPPORTS, in caller order, every element
visited exactly once.  Returns

  (values SOURCE-BASES DERIVATION-BASES WITNESSES REFUTATIONS CLAIMS
          UNSUPPORTED-DESCRIPTORS)

The five recognized species are pairwise disjoint structure classes with no
:INCLUDE, so the COND's order is not a silent precedence rule.  An element is
unsupported because it is NOT one of the five — never because Slice /2
recognized it as something else; a Core /0 account handed straight across is
residue for exactly the reason the integer 17 is."
  (let ((bases '()) (dbases '()) (witnesses '()) (refutations '())
        (claims '()) (residue '()))
    (loop for element in supports
          for index from 0
          do (cond ((source-basis-p element)
                    ;; A value of the source-basis SHAPE with no usable carrier
                    ;; cannot reach a premise at all, so it is residue rather
                    ;; than a recognized species — recorded at the CALLER's own
                    ;; index, with its own reason, never silently dropped.
                    ;; (R-SOURCE-1.6: the shape is not the thing, and a value
                    ;; built through the host object model has the shape.)
                    (if (lisp-plus-slice0:witness-p (%source-basis-carrier element))
                        (push element bases)
                        (push (list :index index
                                    :reason :source-basis-without-carrier)
                              residue)))
                   ((derivation-basis-p element)
                    ;; A derivation basis whose CLAIM slot does not hold a
                    ;; claim has no usable carrier and cannot reach a premise
                    ;; at all — residue at the caller's own index, with its own
                    ;; reason, never silently dropped.  Same treatment as a
                    ;; carrier-less source basis, same reason: the shape is not
                    ;; the thing.
                    (if (lisp-plus-slice0:claim-p (%derivation-basis-claim element))
                        (push element dbases)
                        (push (list :index index
                                    :reason :derivation-basis-without-carrier)
                              residue)))
                   ((lisp-plus-slice0:witness-p element) (push element witnesses))
                   ((lisp-plus-slice1:refutation-p element) (push element refutations))
                   ((lisp-plus-slice0:claim-p element) (push element claims))
                   (t (push (list :index index
                                  :reason :unsupported-support-species)
                            residue))))
    (values (nreverse bases) (nreverse dbases) (nreverse witnesses)
            (nreverse refutations) (nreverse claims) (nreverse residue))))

(defun %admits-source-basis-p (contract basis)
  "Does CONTRACT admit BASIS?  THREE conjuncts, and the third is the one that
matters: the object must be one THIS IMAGE ESTABLISHED.  Species membership and
relation membership are necessary; neither is provenance (R-ADMISSION-0.1)."
  (let ((clause (%contract-clause contract :source-basis)))
    (and clause
         (member (%source-basis-relation-kind basis) (getf (rest clause) :relations)
                 :test #'eq)
         (source-basis-established-in-current-image-p basis)
         t)))

(defun %admits-derivation-basis-p (contract basis claim)
  "Does CONTRACT admit BASIS as the derivation-basis route for CLAIM?

Slice /2 owns four of the ten conjuncts the work order lists; the other six
arrived already decided and are read rather than recomputed.

  1  the contract is version 1 AND explicitly names (:DERIVATION-BASIS)
  2  the basis is established in THIS image
  3  its underlying claim is the EXACT claim projected into Slice /1
  7  receiver reachability — applied by the caller, not here

  4  Slice /1 discharged that claim under CATENA
  5  the proposition matched through the existing normalized machinery
  6  Slice /1's accessibility, refutation, binding and ambiguity answers
     permitted the positive support
        ↑ all three are what CLAIM's presence in the participating set MEANS

  8  the receipt decision is :GRANTED
  9  receipt conclusion and claim proposition agree
 10  the fixed truth ceiling is intact
        ↑ all three live in %DERIVATION-BASIS-COHERENT-P, which conjunct 2 calls

Conjunct 1 checks the version explicitly even though a version-0 contract
CANNOT hold the clause (it refuses at construction).  The redundancy is
deliberate: the conjunct is a stated law, and a law that is only enforced as a
side effect of another mechanism is one silent refactor from being gone."
  (let ((clause (%contract-clause contract :derivation-basis)))
    (and clause
         (eql (%support-admission-contract-contract-version contract) 1)
         (eq (%derivation-basis-claim basis) claim)
         (derivation-basis-established-in-current-image-p basis)
         t)))

(defun %admits-witness-p (contract witness)
  "Does CONTRACT admit WITNESS as an asserted witness?  The clause's declared
:MODE and :KIND must both match.  This reads witness attributes, which is
lawful HERE and only here: it is an explicit declared acceptance of an
assertion (D2-0.10), never a provenance claim about one."
  (let ((clause (%contract-clause contract :asserted-witness)))
    (and clause
         (eq (lisp-plus-slice0:witness-mode witness) (getf (rest clause) :mode))
         (eq (lisp-plus-slice0:witness-kind witness) (getf (rest clause) :kind))
         t)))

(defun %admits-claim-p (contract claim)
  "Does CONTRACT admit CLAIM as a verified judged claim?  Slice /1 has ALREADY
established the seven CATENA conditions for any claim it reports as
:DISCHARGED — exact claim identity, positive :VERIFIED judgment, matching
proposition, receiver accessibility, inspectable judgment basis.  Slice /2 does
not restate them and MUST NOT replace them; it asks only whether this premise's
contract accepts the species at all."
  (declare (ignore claim))
  (and (%contract-clause contract :verified-judged-claim) t))

(defun %discharging-claims (assessment claims)
  "The claim OBJECTS from CLAIMS that this base assessment reports as
:DISCHARGED, matched back by durable CLAIM IDENTITY — the identity CATENA
records, never a copy and never a name."
  (let ((ids (loop for record in (lisp-plus-slice1:premise-assessment-judged-claims
                                  assessment)
                   when (eq (getf record :outcome) :discharged)
                     collect (getf record :claim-id))))
    (remove-if-not
     (lambda (c) (member (lisp-plus-slice0:claim-id c) ids
                         :test #'lisp-plus-kernel0:identity=))
     claims)))

(defun %admit (index premise-pattern contract assessment
               bases witnesses claims all-claims carrier->basis dbases receiver)
  "Apply ONE premise's admission contract over ONE base premise assessment.
Returns a PREMISE-ADMISSION.  This is steps 6 and 8 of the evaluation order;
steps 3, 4, 5, 7 and 9 arrived already decided inside ASSESSMENT and are read
rather than recomputed."
  (declare (ignore bases witnesses))
  (let* ((base-disposition (lisp-plus-slice1:premise-assessment-disposition assessment))
         (refuting (lisp-plus-slice1:premise-assessment-refuting-supports assessment))
         (refuting-witnesses
           (lisp-plus-slice1:premise-assessment-refuting-witnesses assessment))
         ;; The positive participants Slice /1 actually counted at this premise.
         (participating-witnesses
           (lisp-plus-slice1:premise-assessment-matching-accessible-supports assessment))
         ;; Discharge is asked over ALL-CLAIMS — the naked ones plus every
         ;; derivation basis's underlying claim — because a claim that reached
         ;; Slice /1 only through a basis is still a claim Slice /1 judged.
         (participating-claims (%discharging-claims assessment all-claims))
         (admitted '()) (not-admitted '()) (admitted-bases '())
         (admitted-dbases '()) (ceilings '()) (reasons '()))
    (flet ((note (r) (pushnew r reasons :test #'equal)))
      ;; RECEIVER ACCESSIBILITY as a contract requirement.  Slice /1 treats a
      ;; NULL receiver context as universal reach; a premise whose contract
      ;; declares :REQUIRED does not inherit that by omission.
      (let ((receiver-ok
              (or (eq (%support-admission-contract-receiver-accessibility contract)
                      :optional)
                  (not (null receiver)))))
        (unless receiver-ok
          (note (list :receiver-context-required
                      :contract (%support-admission-contract-contract-id contract))))
        (dolist (w participating-witnesses)
          ;; A carrier of a source basis SUPPLIED IN THIS CALL is classified as
          ;; that basis, never as a witness.  A carrier offered BARE — without
          ;; its basis — is not in this map and is therefore an ordinary
          ;; witness, which a source-bound contract does not admit.
          (let ((basis (cdr (assoc w carrier->basis :test #'eq))))
            (cond
              (basis
               (cond ((and receiver-ok (%admits-source-basis-p contract basis))
                      (push basis admitted-bases)
                      (push basis admitted)
                      (pushnew (cons :source-basis
                                     (%source-basis-truth-ceiling basis))
                               ceilings :test #'equal))
                     (t
                      (push basis not-admitted)
                      (note (list :source-basis-not-admitted
                                  :relation (%source-basis-relation-kind basis)
                                  :established
                                  (source-basis-established-in-current-image-p basis))))))
              ((and receiver-ok (%admits-witness-p contract w))
               (push w admitted)
               (pushnew (cons :asserted-witness :asserted) ceilings :test #'equal))
              (t
               (push w not-admitted)
               (note (list :witness-not-admitted
                           :mode (lisp-plus-slice0:witness-mode w)
                           :kind (lisp-plus-slice0:witness-kind w)))))))
        ;; ROUTES, NOT OBJECTS.  One claim may arrive by two roads: offered
        ;; NAKED, and offered THROUGH an established derivation basis.  The
        ;; work order forbids collapsing them, and the reason is exact — a
        ;; contract that accepts only (:DERIVATION-BASIS) must refuse the naked
        ;; road and admit the governed one IN THE SAME DERIVATION, and a
        ;; receipt that recorded one verdict per claim could not say so.
        ;;
        ;; So each road is evaluated on its own terms and both are recorded.
        ;; The PROJECTION into Slice /1 is deduplicated (a claim object handed
        ;; twice would be counted twice and could manufacture an ambiguity that
        ;; the caller never created); the ADMISSION RECORD is not.
        (dolist (c participating-claims)
          (let ((offered-naked (member c claims :test #'eq))
                (routes (remove-if-not
                         (lambda (b) (eq (%derivation-basis-claim b) c))
                         dbases)))
            ;; ROAD 1 — the naked claim, judged on the :VERIFIED-JUDGED-CLAIM
            ;; clause exactly as in Candidate /0.
            (when offered-naked
              (cond ((and receiver-ok (%admits-claim-p contract c))
                     (push c admitted)
                     (pushnew (cons :verified-judged-claim
                                    +judged-claim-truth-ceiling+)
                              ceilings :test #'equal))
                    (t
                     (push c not-admitted)
                     (note (list :judged-claim-not-admitted
                                 :claim (%key (lisp-plus-slice0:claim-id c))
                                 :route :naked)))))
            ;; ROAD 2 — one road per established basis over this same claim.
            (dolist (b routes)
              (cond ((and receiver-ok (%admits-derivation-basis-p contract b c))
                     (push b admitted-dbases)
                     (push b admitted)
                     (pushnew (cons :derivation-basis
                                    +derivation-basis-truth-ceiling+)
                              ceilings :test #'equal))
                    (t
                     (push b not-admitted)
                     (note (list :derivation-basis-not-admitted
                                 :claim (%key (%derivation-basis-identity b))
                                 :established
                                 (derivation-basis-established-in-current-image-p b)
                                 :contract-version
                                 (%support-admission-contract-contract-version
                                  contract))))))))))
    (setf admitted (nreverse admitted)
          not-admitted (nreverse not-admitted)
          admitted-bases (nreverse admitted-bases)
          admitted-dbases (nreverse admitted-dbases))
    (let ((disposition
            (cond
              ;; REFUTATION PRECEDENCE IS NEVER NARROWED.  Refuting evidence
              ;; remains refuting regardless of the admission contract — a
              ;; contract can refuse to let something HELP, never let something
              ;; stop HURTING.
              ((eq base-disposition :refuted) :refuted)
              ((or refuting refuting-witnesses) :refuted)
              ;; An admission contract cannot resolve a declared uniqueness
              ;; conflict either; ambiguity is Slice /1's answer and stands.
              ((and admitted (eq base-disposition :ambiguous)) :ambiguous)
              (admitted :satisfied)
              (not-admitted :not-admitted)
              ;; Nothing was admitted and nothing was recognized-but-refused:
              ;; Slice /1's own answer is the true one and is passed through
              ;; unchanged.  :SATISFIED cannot reach here (it implies a
              ;; participant, which would be in one of the two rosters).
              (t base-disposition))))
      (%make-premise-admission
       :index index
       :premise-pattern premise-pattern
       :contract contract                            ; BY VALUE (D2-0.1)
       :disposition disposition
       :base-disposition base-disposition
       :admitted-supports admitted
       :recognized-not-admitted not-admitted
       :source-bases admitted-bases
       :derivation-bases admitted-dbases
       :judged-claims (lisp-plus-slice1:premise-assessment-judged-claims assessment)
       :refuting-supports refuting
       :refuting-witnesses refuting-witnesses
       :projected-premise-instances
       (lisp-plus-slice1:premise-assessment-projected-premise-instances assessment)
       :binding-environments
       (lisp-plus-slice1:premise-assessment-binding-environments assessment)
       :ambiguities (lisp-plus-slice1:premise-assessment-ambiguities assessment)
       :truth-ceilings (nreverse ceilings)
       :reasons (nreverse reasons)))))

(defun derive/2 (&key schema conclusion supports receiver by)
  "The admission-aware derived-judgment act.

SCHEMA is a SLICE2-SCHEMA value — the object itself, not a name to be resolved:
Slice /2 keeps no schema registry, so there is no global table a reader would
have to consult to learn what governed a decision.  The base Slice /1 schema
must still be registered under its own name and version, because `derive`
resolves it there; DERIVE/2 checks that the registered schema is the very one
the Slice /2 schema was built over and refuses otherwise.

Returns (values GRANTED-CLAIM SLICE2-RECEIPT DERIVATION-BASIS) on a grant —
the third value ADDITIVE as of Candidate /1, the first two unchanged.  On
refusal it
SIGNALS a typed SLICE2-DERIVATION-REFUSED carrying the Slice /2 receipt — the
same shape Slice /1's DERIVATION-REFUSED has, so a caller that already wrote a
`consider`-style wrapper writes the same one here.

NARROWING, structurally: the base Slice /1 derivation decides matching,
accessibility, refutation, CATENA standing, binding and ambiguity; Slice /2
reads those answers and may only REMOVE positive support.  DERIVE/2 therefore
grants only where `derive` granted, and the granted claim IS the Slice /1
grant — Slice /2 does not mint a second, competing promotion for one act."
  (unless (slice2-schema-p schema)
    (%refuse 'slice2-schema-error :schema (type-of schema)
             "DERIVE/2 requires a SLICE2-SCHEMA value as :SCHEMA; got ~S"
             (type-of schema)))
  (let* ((base (%slice2-schema-base-schema schema))
         (name (lisp-plus-slice1:judgment-schema-name base))
         (version (lisp-plus-slice1:judgment-schema-version base))
         (premises (lisp-plus-slice1:judgment-schema-premises base))
         (registered (handler-case (lisp-plus-slice1:resolve-schema name version)
                       (error () nil))))
    ;; The check is EQ against the registered object, and that is deliberate.
    ;; JUDGMENT-SCHEMA-IDENTITY is derived from (name, version) ALONE — measured,
    ;; not assumed: two schemas with different premises and the same key carry
    ;; identical identities — so comparing identities here would be VACUOUS and
    ;; would wave through a registry that had been cleared and repopulated with a
    ;; different anatomy under the same key.  RESOLVE-SCHEMA returns the stored
    ;; object itself, so EQ asks the exact question: is the schema now registered
    ;; under this key the very one these contracts were attached to?
    (unless (and registered (eq registered base))
      (%refuse 'slice2-schema-error :base-schema (list name version)
               "the schema currently registered under (~S ~S) is not the one ~
these contracts were attached to.  DERIVE/2 will not derive against a schema ~
whose anatomy it cannot confirm: a contract attached to premise 2 of one ~
anatomy governs nothing in another" name version))
    ;; Step 1/2 — classify, in caller order, and keep the residue at the
    ;; CALLER's indices.
    (multiple-value-bind (bases dbases witnesses refutations claims residue)
        (%classify-supports/2 supports)
      ;; Every premise must have a contract.  MAKE-SLICE2-SCHEMA already
      ;; guarantees it; this re-checks against the schema in hand rather than
      ;; trusting a past invariant — a missing contract is a typed refusal with
      ;; NO permissive fallback.
      (let ((contracts
              (loop for i below (length premises)
                    collect (slice2-schema-contract-for-premise schema i))))
        ;; EVERY RECOGNIZED SUPPORT REACHES THE BASE DERIVATION, and the
        ;; narrowing happens afterwards.  This is a deliberate choice and the
        ;; alternative was tried first: pre-filtering the unadmitted supports
        ;; out of the base call makes an unadmitted support VANISH — the
        ;; premise reports :MISSING and the receipt cannot tell "nothing was
        ;; offered" from "what was offered is not the kind this premise takes."
        ;; That is exactly the defect CHARTER-DELTA-3 paid to fix one layer
        ;; down, and reproducing it here would have been a silent regression.
        ;;
        ;; The cost is stated rather than hidden: when the base derivation
        ;; grants and Slice /2 then refuses, a Slice /1 grant was computed and
        ;; is DISCARDED.  `raise` writes no registry and no store — Slice /0's
        ;; only mutable global is its ordinal counter — so the discarded grant
        ;; is a pure value no reader can reach, and it is not hidden either:
        ;; the base receipt rides in the Slice /2 receipt, so a reader can see
        ;; precisely what Slice /1 would have done and what admission took away.
        (let* ((carrier->basis
                 (mapcar (lambda (b) (cons (%source-basis-carrier b) b)) bases))
               ;; A derivation basis carries its own claim into Slice /1.  The
               ;; claim object is projected EXACTLY — not a copy — because the
               ;; admission conjunct that matters compares it by EQ against
               ;; what Slice /1 judged.
               ;;
               ;; The projection is DEDUPLICATED and the admission record is
               ;; not, and the asymmetry is deliberate: handing Slice /1 one
               ;; claim object twice would let it count twice and could
               ;; manufacture an ambiguity the caller never created, while
               ;; collapsing the two ROADS would erase the distinction the
               ;; whole species exists to draw.
               (dbasis-claims
                 (remove-duplicates (mapcar #'%derivation-basis-claim dbases)
                                    :test #'eq :from-end t))
               (all-claims
                 (append claims (remove-if (lambda (c) (member c claims :test #'eq))
                                           dbasis-claims)))
               ;; Refutations pass through UNNARROWED: admission may refuse
               ;; positive support, never suppress refutation.
               (effective (append refutations (mapcar #'car carrier->basis)
                                  witnesses all-claims))
               (granted-claim nil)
               (base-receipt nil))
          (handler-case
              (multiple-value-bind (claim receipt)
                  (lisp-plus-slice1:derive
                   :schema-name name :schema-version version
                   :conclusion conclusion :supports effective
                   :receiver receiver :by by)
                (setf granted-claim claim base-receipt receipt))
            (lisp-plus-slice1:derivation-refused (c)
              (setf base-receipt (lisp-plus-slice1:slice1-condition-receipt c))))
          (let* ((assessments (lisp-plus-slice1:derivation-receipt-assessments
                               base-receipt))
                 (admissions
                   (loop for i from 0
                         for assessment in assessments
                         for contract in contracts
                         for premise in premises
                         collect (%admit i
                                         (lisp-plus-slice1:proposition-pattern-normal-form
                                          premise)
                                         contract assessment
                                         bases witnesses claims all-claims
                                         carrier->basis dbases receiver)))
                 (granted-p
                   (and granted-claim
                        admissions
                        (every (lambda (a)
                                 (eq (%premise-admission-disposition a) :satisfied))
                               admissions)))
                 (receipt
                   (%make-slice2-receipt
                    :base-receipt base-receipt
                    :schema-id (%slice2-schema-schema-id schema)
                    :schema-version (%slice2-schema-schema-version schema)
                    :conclusion (lisp-plus-slice1:derivation-receipt-conclusion
                                 base-receipt)
                    :decision (if granted-p :granted :refused)
                    :admissions admissions
                    :unsupported-supports residue
                    :identity (lisp-plus-kernel0:make-identity
                               :receipt (format nil "slice2-receipt-~D"
                                                (%next-ordinal)))
                    :origin-context
                    (lisp-plus-slice1:derivation-receipt-origin-context base-receipt)
                    :ordinal (%next-ordinal))))
            (if granted-p
                ;; THE THIRD VALUE IS ADDITIVE.  The first two are exactly what
                ;; Candidate /0 returned, so a caller written against that
                ;; surface — taking one value or two — behaves unchanged; a
                ;; caller that wants the admission account to travel takes the
                ;; third.  No second claim is minted: the granted claim remains
                ;; the Slice /1 grant, and the basis is a distinct support
                ;; object carrying the account of how it was admitted.
                ;;
                ;; Minted only HERE, only after a genuine Slice /2 grant.  On
                ;; refusal the function signals below and this line is never
                ;; reached, so nothing is minted and nothing is registered.
                (values granted-claim receipt
                        (%mint-derivation-basis granted-claim receipt))
                (signal-slice2
                 'slice2-derivation-refused
                 :failed-invariant
                 (format nil "admission-aware derivation under Slice /2 schema ~
~S v~S refused: ~{~A~^, ~}"
                         (%slice2-schema-schema-id schema)
                         (%slice2-schema-schema-version schema)
                         (loop for a in admissions
                               collect (format nil "~A=~A"
                                               (second (%premise-admission-premise-pattern a))
                                               (%premise-admission-disposition a))))
                 :offending-field :premises
                 :offending-value (mapcar #'%premise-admission-disposition admissions)
                 :receipt receipt))))))))

;;; ==================================================================
;;; EXPLANATION.  The uniform door, after Slice /0 / Slice /1 / Core /0.

(defun why (object)
  "A structured explanation of a Slice /2 value.  Never a string, never a
boolean."
  (typecase object
    (slice2-receipt
     (list :slice2-receipt
           :schema (list (%slice2-receipt-schema-id object)
                         (%slice2-receipt-schema-version object))
           :decision (%slice2-receipt-decision object)
           :premises (mapcar #'why (%slice2-receipt-admissions object))))
    (premise-admission
     (list :premise-admission
           :index (%premise-admission-index object)
           :predicate (second (%premise-admission-premise-pattern object))
           :contract (%support-admission-contract-contract-id
                      (%premise-admission-contract object))
           :disposition (%premise-admission-disposition object)
           :base-disposition (%premise-admission-base-disposition object)
           :truth-ceilings (%premise-admission-truth-ceilings object)
           :reasons (%premise-admission-reasons object)))
    (source-basis
     (list :source-basis
           :identity (%key (%source-basis-identity object))
           :attempt (%key (%source-basis-attempt-id object))
           :relation (%source-basis-relation-kind object)
           :relation-version (%source-basis-relation-version object)
           :request (%source-basis-request object)
           :account-status (%source-basis-account-status object)
           :account-outcome (%source-basis-account-outcome object)
           :truth-ceiling (%source-basis-truth-ceiling object)))
    (derivation-basis
     (list :derivation-basis
           :identity (%key (%derivation-basis-identity object))
           :species (%derivation-basis-species object)
           :schema (list (%derivation-basis-schema-id object)
                         (%derivation-basis-schema-version object))
           :prior-receipt (%key (%slice2-receipt-identity
                                 (%derivation-basis-receipt object)))
           :proposition (derivation-basis-proposition object)
           :established (derivation-basis-established-in-current-image-p object)
           :truth-ceiling (%derivation-basis-truth-ceiling object)))
    (support-admission-contract
     (list :support-admission-contract
           :contract-id (%support-admission-contract-contract-id object)
           :contract-version (%support-admission-contract-contract-version object)
           :accepted-clauses (support-admission-contract-accepted-clauses object)
           :truth-ceilings (support-admission-contract-truth-ceilings object)))
    (t (list :unknown-slice2-object (type-of object)))))

(defun %render-source-basis (b stream)
  (format stream "          source basis   ~A~%" (%key (%source-basis-identity b)))
  (format stream "            attempt      ~A~%" (%key (%source-basis-attempt-id b)))
  (format stream "            request      ~S~%" (%source-basis-request b))
  (format stream "            relation     ~S v~D~%"
          (%source-basis-relation-kind b) (%source-basis-relation-version b))
  (format stream "            reports      ~S~%"
          (ecase (%source-basis-relation-kind b)
            (:core0-account-issued-for-request :issued-for-this-request)
            (:core0-account-reports-acknowledgment (%source-basis-account-status b))
            (:core0-account-reports-outcome (%source-basis-account-outcome b))))
  (format stream "            ceiling      ~S~%" (%source-basis-truth-ceiling b)))

(defun %slice2-receipt-derivation-bases-used-p (r)
  (some (lambda (a) (%premise-admission-derivation-bases a))
        (%slice2-receipt-admissions r)))

(defun %render-derivation-basis (b stream)
  (format stream "          derivation basis ~A~%" (%key (%derivation-basis-identity b)))
  (format stream "            prior receipt  ~A  (reachable directly — no resolver)~%"
          (%key (%slice2-receipt-identity (%derivation-basis-receipt b))))
  (format stream "            prior schema   ~S v~S~%"
          (%derivation-basis-schema-id b) (%derivation-basis-schema-version b))
  (format stream "            proposition    ~S~%" (%derivation-basis-proposition b))
  (format stream "            ceiling        ~S~%" (%derivation-basis-truth-ceiling b))
  (format stream "            reads          a PRIOR EXPLICIT ADMISSION ~
JUDGMENT — this exact claim~%")
  (format stream "                           was granted by DERIVE/2 under ~
explicit per-premise~%")
  (format stream "                           admission contracts, whose record ~
is in that receipt.~%")
  ;; The disclaimer is worded to avoid the exact phrases the renderer is
  ;; forbidden to print.  That is not squeamishness: the selftest checks this
  ;; by BLUNT SUBSTRING SEARCH, which cannot tell an assertion from its denial,
  ;; and a check that cannot be gamed is worth more than one clever enough to
  ;; parse the difference.
  (format stream "            does NOT read  that every premise was ~
source-bound, that anything was~%")
  (format stream "                           checked outside this image, or ~
that a deed took place.~%"))

(defun render-slice2-why (receipt &optional (stream t))
  "Render a Slice /2 receipt as text.

IT NEVER PRINTS 'effect occurred'.  A source-bound premise is rendered as what
it is — an ISSUED ACCOUNT REPORTING a field — and the distinction between the
eight cases below is the whole point of the rendering:

  unsupported species · recognized species not admitted by contract ·
  admitted asserted witness · admitted judged claim · admitted source basis ·
  admitted derivation basis · a derivation basis recognized but not admitted ·
  a basis-shaped value with no usable carrier · a basis this image did not
  establish · refuting evidence · inaccessible support · proposition mismatch

AND IT NEVER PRINTS 'proved', 'externally verified' or 'settled' because a
derivation basis was admitted.  A derivation basis is rendered as what it is —
a PRIOR EXPLICIT ADMISSION JUDGMENT — and the distance between that and 'the
conclusion is true' is the entire reason the species has a fixed ceiling."
  (format stream "~&slice /2 receipt ~A~%" (%key (%slice2-receipt-identity receipt)))
  (format stream "  schema     ~S v~S~%"
          (%slice2-receipt-schema-id receipt) (%slice2-receipt-schema-version receipt))
  (format stream "  conclusion ~S~%" (%slice2-receipt-conclusion receipt))
  (format stream "  decision   ~S~%" (%slice2-receipt-decision receipt))
  (dolist (a (%slice2-receipt-admissions receipt))
    (let ((contract (%premise-admission-contract a)))
      (format stream "~%  premise ~D  ~S~%" (%premise-admission-index a)
              (second (%premise-admission-premise-pattern a)))
      (format stream "    contract      ~S v~D  ~S~%"
              (%support-admission-contract-contract-id contract)
              (%support-admission-contract-contract-version contract)
              (mapcar #'%clause-species
                      (%support-admission-contract-accepted-clauses contract)))
      (format stream "    slice /1 says ~S ; slice /2 says ~S~%"
              (%premise-admission-base-disposition a)
              (%premise-admission-disposition a))
      (dolist (b (%premise-admission-source-bases a))
        (format stream "    ADMITTED — a source basis:~%")
        (%render-source-basis b stream))
      (dolist (b (%premise-admission-derivation-bases a))
        (format stream "    ADMITTED — a derivation basis:~%")
        (%render-derivation-basis b stream))
      (dolist (s (%premise-admission-admitted-supports a))
        (cond ((source-basis-p s))              ; already rendered above
              ((derivation-basis-p s))          ; already rendered above
              ((lisp-plus-slice0:claim-p s)
               (format stream "    ADMITTED — a judged claim ~A (ceiling ~S)~%"
                       (%key (lisp-plus-slice0:claim-id s))
                       +judged-claim-truth-ceiling+))
              (t
               (format stream "    ADMITTED — an ASSERTED witness (~S ~S), ~
ceiling :ASSERTED~%"
                       (lisp-plus-slice0:witness-mode s)
                       (lisp-plus-slice0:witness-kind s)))))
      (dolist (s (%premise-admission-recognized-not-admitted a))
        (cond ((source-basis-p s)
               (format stream "    RECOGNIZED, NOT ADMITTED — a source basis on ~
relation ~S~%" (%source-basis-relation-kind s)))
              ((derivation-basis-p s)
               ;; TWO DISTINCT REASONS, never collapsed: a basis this image did
               ;; not establish is a different fact from a basis this contract
               ;; does not accept, and a reader deciding what to fix needs to
               ;; know which one happened.
               (if (derivation-basis-established-in-current-image-p s)
                   (format stream "    RECOGNIZED, NOT ADMITTED — an ESTABLISHED ~
derivation basis ~A;~%                          this contract (v~D) does not ~
accept the derivation-basis route~%"
                           (%key (%derivation-basis-identity s))
                           (%support-admission-contract-contract-version contract))
                   (format stream "    RECOGNIZED, NOT ADMITTED — a derivation ~
basis this image did NOT~%                          establish (shape is not ~
provenance)~%")))
              ((lisp-plus-slice0:claim-p s)
               (format stream "    RECOGNIZED, NOT ADMITTED — a judged claim ~A~%"
                       (%key (lisp-plus-slice0:claim-id s))))
              (t
               (format stream "    RECOGNIZED, NOT ADMITTED — a witness (~S ~S)~%"
                       (lisp-plus-slice0:witness-mode s)
                       (lisp-plus-slice0:witness-kind s)))))
      (dolist (r (%premise-admission-refuting-supports a))
        (format stream "    REFUTING — refutation ~A~%"
                (%key (lisp-plus-slice1:refutation-id r))))
      (dolist (w (%premise-admission-refuting-witnesses a))
        (format stream "    REFUTING — a witness declaring :REFUTES (~S ~S)~%"
                (lisp-plus-slice0:witness-mode w)
                (lisp-plus-slice0:witness-kind w)))
      (let ((base (%premise-admission-base-disposition a)))
        (case base
          (:inaccessible
           (format stream "    INACCESSIBLE — matching support the receiver ~
cannot reach~%"))
          (:mismatched
           (format stream "    MISMATCH — the predicate matched and a role ~
conflicted~%"))
          (:missing
           (format stream "    NOTHING MATCHING was offered for this premise~%"))))
      (dolist (r (%premise-admission-reasons a))
        (format stream "    reason        ~S~%" r))))
  (let ((residue (%slice2-receipt-unsupported-supports receipt)))
    (when residue
      (format stream "~%  unsupported supply (visible, never admissible): ~S~%"
              residue)
      (when (find :derivation-basis-without-carrier residue
                  :key (lambda (r) (getf r :reason)))
        (format stream "    — one entry is a DERIVATION-BASIS-SHAPED value whose ~
claim slot holds no~%      claim: it has no usable carrier, so it could not ~
reach a premise at all.~%"))))
  (format stream "~%  ceiling: every source basis above establishes AT MOST that ~
the Core /0 runtime~%           minted that exact account content in THIS image ~
for THAT request, and~%           that the account REPORTS the stated field.  ~
Not that the deed occurred.~%")
  (when (%slice2-receipt-derivation-bases-used-p receipt)
    (format stream "           every derivation basis above establishes AT MOST ~
that this image~%           granted that exact claim under explicit per-premise ~
admission~%           contracts.  Not that any premise was source-bound, not ~
that anything~%           was checked outside this image, and not that a deed ~
took place or a~%           matter closed.~%"))
  receipt)
