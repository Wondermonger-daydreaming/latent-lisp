(in-package #:lisp-plus-kernel0)

;;;; PROCEDURE.LISP -- Errata 0.2 §4: structural versus semantic validation.
;;;;
;;;; Three walls between structural and semantic judgment:
;;;;
;;;;   K0E-23  the PROCEDURE DESCRIPTOR -- the durable meaning of a ProcedureId.
;;;;           A descriptor is DATA resolved by the caller.  This file keeps NO
;;;;           registry and NO global table: a descriptor is constructed, held,
;;;;           and passed by whoever owns the interpretation, never looked up
;;;;           behind the caller's back.  One identity/version resolves to
;;;;           exactly one judgment class; a reference site MAY cache that class,
;;;;           but the cache MUST equal the descriptor (the cache-must-match law).
;;;;           A tool performing both classes exposes separate procedure
;;;;           identities or versions -- never one descriptor that changes class.
;;;;
;;;;   K0E-25  descriptor-level judgment law: :accepted / :rejected require a
;;;;           SEMANTIC descriptor; a structural procedure may not license them.
;;;;           :invalid is lawful under either class.
;;;;
;;;;   K0E-26  the JOINT VERDICT -- a two-verdict report that keeps structural
;;;;           and semantic standing apart.  Structural PASS with semantic FAIL
;;;;           is lawful and survives.  There is deliberately no single-boolean
;;;;           collapse: see the prohibition on JOINT-VERDICT-PASS-P below.
;;;;
;;;; Refusal-first, immutable, typed, defensively copied -- house style.

;;; ---------------------------------------------------------------------------
;;; K0E-23  procedure descriptor
;;; ---------------------------------------------------------------------------

(defstruct (procedure-descriptor
            (:constructor %make-procedure-descriptor
                (procedure-id
                 version
                 judgment-class
                 input-domain
                 result-vocabulary
                 evidence-requirements
                 bounded-unknowns))
            (:copier nil)
            (:conc-name %procedure-descriptor-))
  (procedure-id nil :read-only t)
  (version nil :read-only t)
  (judgment-class nil :read-only t)
  (input-domain nil :read-only t)
  (result-vocabulary nil :read-only t)
  (evidence-requirements nil :read-only t)
  (bounded-unknowns nil :read-only t))

(defun procedure-descriptor-procedure-id (descriptor)
  (%procedure-descriptor-procedure-id descriptor))

(defun procedure-descriptor-version (descriptor)
  (%procedure-descriptor-version descriptor))

(defun procedure-descriptor-judgment-class (descriptor)
  (%procedure-descriptor-judgment-class descriptor))

(defun procedure-descriptor-input-domain (descriptor)
  (%snapshot-tree (%procedure-descriptor-input-domain descriptor)))

(defun procedure-descriptor-result-vocabulary (descriptor)
  (%snapshot-tree (%procedure-descriptor-result-vocabulary descriptor)))

(defun procedure-descriptor-evidence-requirements (descriptor)
  (%snapshot-tree (%procedure-descriptor-evidence-requirements descriptor)))

(defun procedure-descriptor-bounded-unknowns (descriptor)
  (%snapshot-tree (%procedure-descriptor-bounded-unknowns descriptor)))

(defun %validate-descriptor-input-domain (input-domain)
  "R3 [K0E-23]: refusal-first schema for a descriptor :input-domain.  A domain is
NIL (unconstrained) or a STRICT plist over EXACTLY the keys :kinds and :statuses
-- even length, each key at most once, no unknown keys -- and each PRESENT
dimension value MUST be a proper list.  Every violation is a
MALFORMED-CONSTRUCTOR-SHAPE (K0E-23), so a malformed input-domain can never reach
the validator's GETF as a host error (the R2 hostile review's §8 escape route)."
  (when input-domain
    (unless (and (%proper-list-p input-domain) (evenp (length input-domain)))
      (signal-kernel0
       'malformed-constructor-shape
       :requirement-id "K0E-23"
       :offending-field :input-domain
       :offending-value input-domain
       :failed-invariant
       "§4.1 [K0E-23]: a descriptor :input-domain MUST be NIL or an even-length plist over the keys :kinds and :statuses; an atom or an odd-length plist is refused"))
    (let ((seen nil))
      (loop for (key value) on input-domain by #'cddr
            do (unless (member key '(:kinds :statuses) :test #'eq)
                 (signal-kernel0
                  'malformed-constructor-shape
                  :requirement-id "K0E-23"
                  :offending-field :input-domain
                  :offending-value key
                  :failed-invariant
                  "§4.1 [K0E-23]: a descriptor :input-domain admits ONLY the dimension keys :kinds and :statuses; an unknown key is refused"))
               (when (member key seen :test #'eq)
                 (signal-kernel0
                  'malformed-constructor-shape
                  :requirement-id "K0E-23"
                  :offending-field :input-domain
                  :offending-value key
                  :failed-invariant
                  "§4.1 [K0E-23]: a descriptor :input-domain MUST NOT repeat a dimension key"))
               (push key seen)
               (unless (%proper-list-p value)
                 (signal-kernel0
                  'malformed-constructor-shape
                  :requirement-id "K0E-23"
                  :offending-field :input-domain
                  :offending-value value
                  :failed-invariant
                  "§4.1 [K0E-23]: each present :input-domain dimension (:kinds / :statuses) MUST be a proper list")))))
  input-domain)

(defun make-procedure-descriptor (&rest arguments)
  "Construct one immutable K0E-23 interpretation procedure descriptor.

The descriptor is the DURABLE MEANING of a ProcedureId/version: its judgment
class is fixed here, never by a caller.  :VERSION MUST be a NONNEGATIVE INTEGER
-- the closed canonical, immutable version representation (B2, R2 hostile review
§4: an integer cannot be aliased or mutated post hoc, so the exact version
binding a descriptor and an interpretation share is durable).  :JUDGMENT-CLASS
MUST be exactly :structural or :semantic; :RESULT-VOCABULARY MUST be a
duplicate-free proper list; :INPUT-DOMAIN MUST be NIL or a strict :kinds/:statuses
plist; every :EVIDENCE-REQUIREMENTS entry MUST be a durable identity and the set
MUST be duplicate-free (R3, review §8).  All tree and string fields are
snapshotted, so the record is immutable."
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:procedure-id
             :version
             :judgment-class
             :input-domain
             :result-vocabulary
             :evidence-requirements
             :bounded-unknowns)
           'malformed-constructor-shape
           "§4.1 [K0E-23]: a procedure descriptor MUST use only the closed descriptor schema without unknown or duplicate fields")))
    (%require-constructor-keys
     parsed
     '(:procedure-id :version :judgment-class)
     'malformed-constructor-shape
     "§4.1 [K0E-23]: a procedure descriptor MUST bind its durable procedure-id, version, and judgment class"
     :requirement-id "K0E-23")
    (let* ((procedure-id (%parsed-argument parsed :procedure-id))
           (version (%parsed-argument parsed :version))
           (judgment-class (%parsed-argument parsed :judgment-class))
           (input-domain (%parsed-argument parsed :input-domain nil))
           (result-vocabulary
             (%parsed-argument parsed :result-vocabulary nil))
           (evidence-requirements
             (%parsed-argument parsed :evidence-requirements nil))
           (bounded-unknowns
             (%parsed-argument parsed :bounded-unknowns nil)))
      (require-identity procedure-id :procedure)
      ;; B2 [K0E-23]: the closed canonical version representation is a NONNEGATIVE
      ;; INTEGER.  NIL, a string, a list, a negative, or any non-integer host
      ;; object is refused here (review §4: a mutable version is an aliasable
      ;; seal; an integer is immutable, so the exact version binding cannot be
      ;; rewritten after construction).
      (unless (and (integerp version) (not (minusp version)))
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-23"
         :offending-field :version
         :offending-value version
         :failed-invariant
         "§4.1 [K0E-23]: a procedure descriptor :version MUST be a nonnegative integer -- the closed canonical, immutable version representation; NIL, a string, a list, a negative, or any non-integer host object is refused"))
      (unless (member judgment-class '(:structural :semantic) :test #'eq)
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-23"
         :offending-field :judgment-class
         :offending-value judgment-class
         :failed-invariant
         "§4.1 [K0E-23]: a procedure descriptor's :judgment-class MUST be exactly :structural or :semantic"))
      (unless (%proper-list-p result-vocabulary)
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-23"
         :offending-field :result-vocabulary
         :offending-value result-vocabulary
         :failed-invariant
         "§4.1 [K0E-23]: a procedure descriptor's :result-vocabulary MUST be a finite proper list"))
      (unless (%proper-list-p evidence-requirements)
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-23"
         :offending-field :evidence-requirements
         :offending-value evidence-requirements
         :failed-invariant
         "§4.1 [K0E-23]: a procedure descriptor's :evidence-requirements MUST be a finite proper list"))
      (unless (%proper-list-p bounded-unknowns)
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-23"
         :offending-field :bounded-unknowns
         :offending-value bounded-unknowns
         :failed-invariant
         "§4.1 [K0E-23]: a procedure descriptor's :bounded-unknowns MUST be a finite proper list"))
      ;; R3 [K0E-23]: nested-schema is refusal-safe AT CONSTRUCTION, so the
      ;; validator may trust these shapes (a malformed descriptor can no longer
      ;; exist).  (1) :input-domain is NIL or a strict :kinds/:statuses plist;
      ;; (2) every :evidence-requirements entry is a durable identity -- a
      ;; malformed requirement is a descriptor-shape defect here, NOT a deferred
      ;; "unsatisfied evidence" at validation time; (3) :result-vocabulary and
      ;; :evidence-requirements are duplicate-free under Kernel equality.
      (%validate-descriptor-input-domain input-domain)
      (dolist (requirement evidence-requirements)
        (unless (durable-identity-p requirement)
          (signal-kernel0
           'malformed-constructor-shape
           :requirement-id "K0E-23"
           :offending-field :evidence-requirements
           :offending-value requirement
           :failed-invariant
           "§4.1 [K0E-23]: every descriptor :evidence-requirements entry MUST be a durable identity; a non-identity requirement is a malformed descriptor shape, not a deferred unsatisfied-evidence result")))
      (unless (%duplicate-free-p result-vocabulary)
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-23"
         :offending-field :result-vocabulary
         :offending-value result-vocabulary
         :failed-invariant
         "§4.1 [K0E-23]: a descriptor :result-vocabulary MUST be duplicate-free under Kernel equality"))
      (unless (%duplicate-free-p evidence-requirements)
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-23"
         :offending-field :evidence-requirements
         :offending-value evidence-requirements
         :failed-invariant
         "§4.1 [K0E-23]: a descriptor :evidence-requirements MUST be duplicate-free under Kernel equality"))
      (%make-procedure-descriptor
       procedure-id
       version
       judgment-class
       (%snapshot-tree input-domain)
       (%snapshot-tree result-vocabulary)
       (%snapshot-tree evidence-requirements)
       (%snapshot-tree bounded-unknowns)))))

;;; ---------------------------------------------------------------------------
;;; K0E-23 / K0E-25  validate one interpretation axis against its descriptor
;;; ---------------------------------------------------------------------------

(defun %input-domain-member-ok-p (allowed value)
  "K0E-25 domain membership for ONE dimension of an :input-domain.  ALLOWED NIL
means the dimension is UNCONSTRAINED (returns T); otherwise VALUE MUST appear in
ALLOWED under Kernel equality (identity= for durable identities, EQUAL
otherwise).  ALLOWED is guaranteed a proper list: R3 refuses any non-proper-list
dimension at MAKE-PROCEDURE-DESCRIPTOR, so the former improper-list
fail-closed guard is now redundant and removed (the validator trusts the shape)."
  (or (null allowed)
      (member value allowed :test #'%kernel-name=)))

(defun %evidence-requirement-satisfied-p (required-identity evidence-list)
  "K0E-25 evidence-requirement satisfaction: REQUIRED-IDENTITY (a durable
identity) MUST appear in EVIDENCE-LIST under the Kernel identity-equality.  A
non-durable requirement, or a requirement absent from the interpretation axis's
evidence, is UNSATISFIED."
  (and (durable-identity-p required-identity)
       (some (lambda (entry)
               (and (durable-identity-p entry)
                    (identity= required-identity entry)))
             evidence-list)))

(defun validate-interpretation-against-descriptor
    (interpretation-axis descriptor &key manifestation)
  "Check one interpretation axis against the descriptor that gives its
ProcedureId meaning, plus -- for a semantic acceptance/rejection -- against the
manifestation it judges.  Returns T on success; otherwise refuses:

  (a) the axis procedure-id MUST equal the descriptor's procedure-id
      (else IDENTITY-DRIFT, K0E-23);
  (v) a cached procedure version, if present, MUST EQUAL the descriptor's
      version (the version-drift law; else INTERPRETATION-CLASS-VIOLATION,
      K0E-23) -- so one identity cannot answer under an arbitrary descriptor
      version by caller;
  (o) every procedure-relative interpretation MUST bind a cached PROCEDURE
      VERSION (INTERPRETATION-CLASS-VIOLATION, K0E-23, when absent).  A procedure
      identity or cached class alone does not pin the descriptor version.  The
      version binding, checked against the descriptor by rule (v), binds the
      reference site to the exact identity/version it claims;
  (b) a cached judgment class, if present, MUST EQUAL the descriptor's class
      (the cache-must-match law; else INTERPRETATION-CLASS-VIOLATION, K0E-23);
  (c) an :accepted or :rejected value REQUIRES a :semantic descriptor
      (else INTERPRETATION-CLASS-VIOLATION, K0E-25);
  (d) the axis value MUST be a member of the descriptor's result-vocabulary
      when that vocabulary is non-nil (else INTERPRETATION-CLASS-VIOLATION,
      K0E-23);
  (m) an :accepted or :rejected value REQUIRES the :MANIFESTATION argument (a
      manifestation record); its KIND and STATUS MUST satisfy the descriptor's
      :input-domain, and every entry of the descriptor's :evidence-requirements
      MUST appear in the axis's evidence (else INTERPRETATION-CLASS-VIOLATION,
      K0E-25);
  (e) :invalid is lawful under either class, and needs no manifestation.

The :input-domain is a plist `(:kinds (...) :statuses (...))`; a NIL domain, or
a NIL :kinds/:statuses dimension, is UNCONSTRAINED.  Authority lives in the
descriptor, never in the cache: this is where the structural/semantic wall and
the domain/evidence law are enforced against real data.

For :invalid, :refused, or :indeterminate, the :MANIFESTATION argument is
unnecessary; identity/version/class/result-vocabulary validation still applies.
For :accepted/:rejected the manifestation/domain/evidence checks additionally
apply."
  (unless (%axis-of-kind-p interpretation-axis :interpretation)
    (signal-kernel0
     'malformed-constructor-shape
     :requirement-id "K0E-23"
     :offending-field :interpretation-axis
     :offending-value interpretation-axis
     :failed-invariant
     "§4.1 [K0E-23]: validate-interpretation-against-descriptor requires an interpretation axis"))
  (unless (procedure-descriptor-p descriptor)
    (signal-kernel0
     'malformed-constructor-shape
     :requirement-id "K0E-23"
     :offending-field :descriptor
     :offending-value descriptor
     :failed-invariant
     "§4.1 [K0E-23]: validate-interpretation-against-descriptor requires a procedure descriptor"))
  (let ((axis-procedure-id (axis-procedure-id interpretation-axis))
        (axis-version (axis-procedure-version interpretation-axis))
        (cached-class (axis-judgment-class interpretation-axis))
        (value (axis-value interpretation-axis))
        (descriptor-class (procedure-descriptor-judgment-class descriptor))
        (descriptor-version (procedure-descriptor-version descriptor))
        (descriptor-procedure-id
          (procedure-descriptor-procedure-id descriptor))
        (vocabulary (procedure-descriptor-result-vocabulary descriptor))
        (input-domain (procedure-descriptor-input-domain descriptor))
        (evidence-requirements
          (procedure-descriptor-evidence-requirements descriptor))
        (accepted-or-rejected-p
          (member (axis-value interpretation-axis) '(:accepted :rejected)
                  :test #'eq)))
    ;; (a) identity match: an axis is validated only against its own procedure.
    (unless (and (durable-identity-p axis-procedure-id)
                 (identity= axis-procedure-id descriptor-procedure-id))
      (signal-kernel0
       'identity-drift
       :requirement-id "K0E-23"
       :offending-field :procedure-id
       :offending-value axis-procedure-id
       :failed-invariant
       "§4.1 [K0E-23]: an interpretation axis MUST be validated only against the descriptor of its own procedure-id"))
    ;; (v) version-drift: a cached version MUST equal the descriptor's version.
    (when (and axis-version
               (not (%kernel-name= axis-version descriptor-version)))
      (signal-kernel0
       'interpretation-class-violation
       :requirement-id "K0E-23"
       :offending-field :procedure-version
       :offending-value axis-version
       :failed-invariant
       "§4.1 [K0E-23]: a cached procedure version MUST equal the descriptor's version; one identity cannot be validated against an arbitrary descriptor version by caller"))
    ;; (o) every procedure-relative reference MUST bind the procedure VERSION.
    ;; Without it, invalid/refused/indeterminate standing is just as caller-
    ;; selectable among descriptor versions as semantic acceptance was.
    (when (and axis-procedure-id (null axis-version))
      (signal-kernel0
       'interpretation-class-violation
       :requirement-id "K0E-23"
       :offending-field :procedure-version
       :offending-value value
       :failed-invariant
       "§4.1 [K0E-23]: every procedure-relative interpretation MUST bind the exact descriptor version it claims; a procedure identity or class cache alone leaves descriptor resolution caller-selectable"))
    ;; (b) cache-must-match: one identity/version cannot change class by caller.
    (when (and cached-class (not (eq cached-class descriptor-class)))
      (signal-kernel0
       'interpretation-class-violation
       :requirement-id "K0E-23"
       :offending-field :judgment-class
       :offending-value cached-class
       :failed-invariant
       "§4.1 [K0E-23]: a cached judgment class MUST equal the descriptor's class; one identity/version cannot change class by caller"))
    ;; (c) accepted/rejected require a semantic descriptor.
    (when (and accepted-or-rejected-p
               (not (eq descriptor-class :semantic)))
      (signal-kernel0
       'interpretation-class-violation
       :requirement-id "K0E-25"
       :offending-field :value
       :offending-value value
       :failed-invariant
       "§9.6 [K0E-25]: :accepted or :rejected requires a semantic procedure descriptor; a structural procedure MUST NOT license acceptance or rejection"))
    ;; (d) result-vocabulary membership, when the descriptor declares one.
    (when (and vocabulary
               (not (member value vocabulary :test #'%kernel-name=)))
      (signal-kernel0
       'interpretation-class-violation
       :requirement-id "K0E-23"
       :offending-field :value
       :offending-value value
       :failed-invariant
       "§4.1 [K0E-23]: an interpretation value MUST be a member of the descriptor's declared result vocabulary"))
    ;; (m) domain + evidence law: an accepted/rejected semantic judgment MUST be
    ;; bound to the manifestation it judges, that manifestation's kind/status
    ;; MUST fall inside the descriptor's input-domain, and every declared
    ;; evidence requirement MUST appear in the axis's evidence.
    (when accepted-or-rejected-p
      (unless manifestation
        (signal-kernel0
         'interpretation-class-violation
         :requirement-id "K0E-25"
         :offending-field :manifestation
         :offending-value nil
         :failed-invariant
         "§9.6 [K0E-25]: an :accepted or :rejected semantic judgment REQUIRES the manifestation it judges; validation without a manifestation cannot establish domain or evidence legality"))
      (unless (manifestation-p manifestation)
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-25"
         :offending-field :manifestation
         :offending-value manifestation
         :failed-invariant
         "§9.6 [K0E-25]: the :manifestation argument MUST be a manifestation record so its kind and status can be checked against the descriptor's input-domain"))
      (let ((kind (manifestation-kind manifestation))
            (status (manifestation-status manifestation))
            (allowed-kinds (getf input-domain :kinds))
            (allowed-statuses (getf input-domain :statuses)))
        ;; input-domain kind legality (NIL domain / NIL dimension = unconstrained).
        (unless (%input-domain-member-ok-p allowed-kinds kind)
          (signal-kernel0
           'interpretation-class-violation
           :requirement-id "K0E-25"
           :offending-field :kind
           :offending-value kind
           :failed-invariant
           "§9.6 [K0E-25]: the manifestation KIND MUST fall inside the semantic descriptor's :input-domain :kinds; a descriptor whose domain excludes the manifestation kind MUST NOT accept or reject it"))
        ;; input-domain status legality.
        (unless (%input-domain-member-ok-p allowed-statuses status)
          (signal-kernel0
           'interpretation-class-violation
           :requirement-id "K0E-25"
           :offending-field :status
           :offending-value status
           :failed-invariant
           "§9.6 [K0E-25]: the manifestation STATUS MUST fall inside the semantic descriptor's :input-domain :statuses; a descriptor whose domain excludes the manifestation status MUST NOT accept or reject it")))
      ;; evidence-requirements: each required durable identity MUST appear in the
      ;; axis's evidence under Kernel identity-equality.
      (let ((evidence (axis-evidence interpretation-axis)))
        (dolist (required evidence-requirements)
          (unless (%evidence-requirement-satisfied-p required evidence)
            (signal-kernel0
             'interpretation-class-violation
             :requirement-id "K0E-25"
             :offending-field :evidence-requirements
             :offending-value required
             :failed-invariant
             "§9.6 [K0E-25]: every entry in the semantic descriptor's :evidence-requirements MUST appear in the interpretation axis's evidence; an accepted/rejected judgment with unsatisfied required evidence is refused")))))
    ;; (e) :invalid is lawful under either class -- no further check.
    t))

;;; ---------------------------------------------------------------------------
;;; K0E-26  joint verdict -- two verdicts, never one boolean
;;; ---------------------------------------------------------------------------

(defstruct (verdict
            (:constructor %make-verdict
                (value procedure-id condition-ids requirement-ids))
            (:copier nil)
            (:conc-name %verdict-))
  (value nil :read-only t)
  (procedure-id nil :read-only t)
  (condition-ids nil :read-only t)
  (requirement-ids nil :read-only t))

(defun verdict-value (verdict)
  (%verdict-value verdict))

(defun verdict-procedure-id (verdict)
  (%verdict-procedure-id verdict))

(defun verdict-condition-ids (verdict)
  (%snapshot-tree (%verdict-condition-ids verdict)))

(defun verdict-requirement-ids (verdict)
  (%snapshot-tree (%verdict-requirement-ids verdict)))

(defun make-verdict (&rest arguments)
  "Construct one K0E-26 single-axis verdict sub-record -- the :structural or
:semantic half of a joint verdict.  :VALUE MUST be exactly :pass, :fail, or
:not-run; a bare boolean or a numeric aggregate counter is not a lawful
verdict.  :CONDITION-IDS and :REQUIREMENT-IDS MUST be proper lists and are
snapshotted.

Verdict IDENTITY law (K0E-26): a :PASS or a :FAIL verdict MUST name its
:PROCEDURE-ID -- an anonymous pass/fail is an uninspectable standing.  A
:NOT-RUN verdict MAY omit the procedure-id (there is legitimately no procedure
that ran).  Verdict REASON law (K0E-26): a :FAIL verdict MUST carry at least one
condition-id or requirement-id -- a reasonless failure is uninspectable and is
refused."
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:value :procedure-id :condition-ids :requirement-ids)
           'malformed-constructor-shape
           "§4.4 [K0E-26]: a verdict MUST use only the closed :value/:procedure-id/:condition-ids/:requirement-ids schema")))
    (%require-constructor-keys
     parsed
     '(:value)
     'malformed-constructor-shape
     "§4.4 [K0E-26]: a verdict MUST bind its tri-state :value"
     :requirement-id "K0E-26")
    (let ((value (%parsed-argument parsed :value))
          (procedure-id (%parsed-argument parsed :procedure-id nil))
          (condition-ids (%parsed-argument parsed :condition-ids nil))
          (requirement-ids (%parsed-argument parsed :requirement-ids nil)))
      (unless (member value '(:pass :fail :not-run) :test #'eq)
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-26"
         :offending-field :value
         :offending-value value
         :failed-invariant
         "§4.4 [K0E-26]: a verdict :value MUST be exactly :pass, :fail, or :not-run; a single boolean or aggregate counter is not a lawful verdict"))
      ;; K0E-26 verdict IDENTITY: :pass and :fail MUST name a procedure; only
      ;; :not-run MAY be procedure-less.  An anonymous pass/fail is uninspectable
      ;; standing and is refused here.
      (when (and (member value '(:pass :fail) :test #'eq)
                 (null procedure-id))
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-26"
         :offending-field :procedure-id
         :offending-value procedure-id
         :failed-invariant
         "§4.4 [K0E-26]: a :pass or :fail verdict MUST name its :procedure-id; only a :not-run verdict MAY omit it, since no procedure ran"))
      (when procedure-id
        (require-identity procedure-id :procedure))
      (unless (%proper-list-p condition-ids)
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-26"
         :offending-field :condition-ids
         :offending-value condition-ids
         :failed-invariant
         "§4.4 [K0E-26]: a verdict's :condition-ids MUST be a finite proper list"))
      (unless (%proper-list-p requirement-ids)
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-26"
         :offending-field :requirement-ids
         :offending-value requirement-ids
         :failed-invariant
         "§4.4 [K0E-26]: a verdict's :requirement-ids MUST be a finite proper list"))
      ;; K0E-26 verdict REASON: a :fail with no condition-id AND no
      ;; requirement-id is a reasonless, uninspectable failure and is refused.
      ;; (:pass and :not-run legitimately carry no reason list.)
      (when (and (eq value :fail)
                 (null condition-ids)
                 (null requirement-ids))
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-26"
         :offending-field :requirement-ids
         :offending-value nil
         :failed-invariant
         "§4.4 [K0E-26]: a :fail verdict MUST carry at least one condition-id or requirement-id; a reasonless failure is uninspectable"))
      (%make-verdict value
                     procedure-id
                     (%snapshot-tree condition-ids)
                     (%snapshot-tree requirement-ids)))))

(defstruct (joint-verdict
            (:constructor %make-joint-verdict (structural semantic))
            (:copier nil)
            (:conc-name %joint-verdict-))
  (structural nil :read-only t)
  (semantic nil :read-only t))

(defun joint-verdict-structural (joint-verdict)
  "Return the structural half of the joint verdict -- the full verdict
sub-record, never a boolean."
  (%joint-verdict-structural joint-verdict))

(defun joint-verdict-semantic (joint-verdict)
  "Return the semantic half of the joint verdict -- the full verdict
sub-record, never a boolean."
  (%joint-verdict-semantic joint-verdict))

;; K0E-26 PROHIBITION -- there is deliberately NO JOINT-VERDICT-PASS-P accessor,
;; and none may ever be added.  A joint verdict MUST NOT collapse into a single
;; boolean: structural PASS with semantic FAIL is lawful and survives
;; aggregation, so a single green counter is nonconforming evidence.  Every
;; consumer reads BOTH halves through JOINT-VERDICT-STRUCTURAL and
;; JOINT-VERDICT-SEMANTIC; divergence is surfaced, not flattened.
(defun joint-verdict-divergent-p (joint-verdict)
  "True iff the structural and semantic verdict VALUES differ.  This exposes
the divergence the two-verdict form exists to preserve.  It is NOT a pass
predicate: a NIL result means the two halves AGREE (both pass, both fail, or
both not-run), not that the report passed."
  (not (eq (verdict-value (%joint-verdict-structural joint-verdict))
           (verdict-value (%joint-verdict-semantic joint-verdict)))))

(defun make-joint-verdict (&rest arguments)
  "Construct a K0E-26 joint AP0+Kernel report carrying BOTH a structural and a
semantic verdict.  Each half MUST be a VERDICT sub-record.  Missing either
half, or a single-boolean / aggregate-counter shape in place of a verdict, is
refused as MALFORMED-CONSTRUCTOR-SHAPE.  Structural PASS with semantic FAIL is
lawful and constructs."
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:structural-verdict :semantic-verdict)
           'malformed-constructor-shape
           "§4.4 [K0E-26]: a joint verdict MUST use exactly the closed :structural-verdict/:semantic-verdict schema")))
    (%require-constructor-keys
     parsed
     '(:structural-verdict :semantic-verdict)
     'malformed-constructor-shape
     "§4.4 [K0E-26]: a joint verdict MUST carry BOTH a structural verdict and a semantic verdict; a single collapsed verdict is nonconforming"
     :requirement-id "K0E-26")
    (let ((structural (%parsed-argument parsed :structural-verdict))
          (semantic (%parsed-argument parsed :semantic-verdict)))
      (unless (verdict-p structural)
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-26"
         :offending-field :structural-verdict
         :offending-value structural
         :failed-invariant
         "§4.4 [K0E-26]: :structural-verdict MUST be a verdict sub-record, never a bare boolean or aggregate counter"))
      (unless (verdict-p semantic)
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-26"
         :offending-field :semantic-verdict
         :offending-value semantic
         :failed-invariant
         "§4.4 [K0E-26]: :semantic-verdict MUST be a verdict sub-record, never a bare boolean or aggregate counter"))
      (%make-joint-verdict structural semantic))))
