(in-package #:lisp-plus-kernel0)

;; K0E-23/K0E-25: MAKE-OUTCOME (below) makes descriptor validation MANDATORY
;; on every public path that mints a procedure-relative interpretation.  Semantic
;; :accepted/:rejected additionally bind the descriptor to the actual
;; manifestation.  The validator itself,
;; VALIDATE-INTERPRETATION-AGAINST-DESCRIPTOR, is defined in PROCEDURE.LISP, which
;; loads AFTER this file (it depends on the axis accessors defined here -- a
;; deliberate two-file cycle resolved by CL's call-time function lookup).  This
;; ftype declaration keeps MAKE-OUTCOME's forward reference clean.
(declaim (ftype (function (t t &key (:manifestation t)) t)
                validate-interpretation-against-descriptor))

(defstruct (axis
            (:constructor %make-axis
                (axis-name
                 value
                 determinacy
                 evidence
                 procedure-id
                 frontier-qualifier
                 uncertain-effect-ref
                 effect-group
                 judgment-class
                 procedure-version))
            (:copier nil)
            (:conc-name %axis-))
  ;; AXIS-NAME is an internal discriminator.  Overlapping value enums make it
  ;; necessary for MAKE-OUTCOME to reject a structurally misplaced axis.
  (axis-name nil :read-only t)
  (value nil :read-only t)
  (determinacy nil :read-only t)
  (evidence nil :read-only t)
  (procedure-id nil :read-only t)
  (frontier-qualifier nil :read-only t)
  (uncertain-effect-ref nil :read-only t)
  (effect-group nil :read-only t)
  ;; K0E-23 optional cached judgment class on an interpretation axis: a
  ;; reference-site CACHE (:structural or :semantic), never authority.  NIL on
  ;; every non-interpretation axis and on an uncached interpretation.  Its value
  ;; MUST equal the resolved procedure descriptor's class
  ;; (VALIDATE-INTERPRETATION-AGAINST-DESCRIPTOR enforces the cache-must-match
  ;; law); one identity/version cannot change class by caller.
  (judgment-class nil :read-only t)
  ;; K0E-23 optional cached PROCEDURE VERSION on an interpretation axis: the
  ;; reference-site binding of the exact descriptor version this axis claims to
  ;; be interpreted under (§4.1: "identity/version resolves to ...").  NIL on
  ;; every non-interpretation axis and on a version-uncached interpretation.
  ;; When supplied it MUST be non-nil canonical data and MUST equal the resolved
  ;; descriptor's version (VALIDATE-INTERPRETATION-AGAINST-DESCRIPTOR enforces
  ;; the version-drift refusal); one identity cannot answer under an arbitrary
  ;; descriptor version by caller.
  (procedure-version nil :read-only t))

(defun axis-value (axis)
  (%snapshot-tree (%axis-value axis)))

(defun axis-determinacy (axis)
  (%axis-determinacy axis))

(defun axis-evidence (axis)
  (%snapshot-tree (%axis-evidence axis)))

(defun axis-procedure-id (axis)
  (%axis-procedure-id axis))

(defun axis-frontier-qualifier (axis)
  (%axis-frontier-qualifier axis))

(defun axis-uncertain-effect-ref (axis)
  (%axis-uncertain-effect-ref axis))

(defun axis-effect-group (axis)
  (%axis-effect-group axis))

(defun axis-judgment-class (axis)
  "Return the interpretation axis's cached K0E-23 judgment class, or NIL.
The cache is advisory; authority lives in the procedure descriptor."
  (%axis-judgment-class axis))

(defun axis-procedure-version (axis)
  "Return the interpretation axis's cached K0E-23 procedure version, or NIL.
The cache is advisory; authority lives in the procedure descriptor.  A non-NIL
value MUST equal the descriptor's version (VALIDATE-INTERPRETATION-AGAINST-
DESCRIPTOR enforces the version-drift refusal)."
  (%axis-procedure-version axis))

(defun %execution-value-p (value)
  (member value
          '(:not-attempted :refused :failed :completed :cancelled
            :indeterminate)
          :test #'eq))

(defun %interpretation-value-p (value)
  (member value
          '(:not-attempted :not-applicable :accepted :rejected :invalid
            :refused :indeterminate)
          :test #'eq))

(defun %effect-value-p (value)
  (member value
          '(:not-entered :prepared :crossed :settled :compensated :bounded
            :indeterminate)
          :test #'eq))

(defun %manifestation-alternative-complete-p (alternative)
  "K0E-1 completeness for a MANIFESTATION-axis alternative: a manifestation
record, a durable :manifestation identity, or a complete
(:absent :state <closed absence-state>) form.  A bare absence-state atom is
not a complete value."
  (or (manifestation-p alternative)
      (and (durable-identity-p alternative)
           (eq (durable-identity-domain alternative) :manifestation))
      (%manifestation-axis-absence-form-p alternative)))

(defun %axis-alternative-complete-p (axis-kind alternative)
  (ecase axis-kind
    (:execution (%execution-value-p alternative))
    (:interpretation (%interpretation-value-p alternative))
    (:manifestation (%manifestation-alternative-complete-p alternative))))

(defun %validate-bounded-axis-alternatives (axis-kind value determinacy)
  "Enforce the axis-domain determinacy laws the generic record cannot know:
K0E-1 (every :bounded alternative is a complete value of this axis's domain)
and K0E-3 (a current value under :bounded determinacy is a member of the
alternatives).  The effect axis is exempt and is governed by K0E-4 instead."
  (when (and (determinacy-p determinacy)
             (eq (determinacy-mode determinacy) :bounded))
    (let ((alternatives (determinacy-alternatives determinacy)))
      (dolist (alternative alternatives)
        (unless (%axis-alternative-complete-p axis-kind alternative)
          (signal-kernel0
           'determinacy-alternatives-invalid
           :requirement-id "K0E-1"
           :offending-field :alternatives
           :offending-value alternative
           :failed-invariant
           "§7.3, §9, K0E-1: every :bounded outcome-axis alternative MUST be a complete value in the axis domain; a bare atom or wrong-domain alternative is refused")))
      (unless (member value alternatives :test #'%kernel-name=)
        (signal-kernel0
         'determinacy-alternatives-invalid
         :requirement-id "K0E-3"
         :offending-field :value
         :offending-value value
         :failed-invariant
         "§7.3, K0E-3: when an axis carries a current value under :bounded determinacy, that value MUST be a member of its alternatives")))))

(defun %require-constructor-keys
    (parsed required-keys condition-type failed-invariant &key requirement-id)
  ;; REQUIREMENT-ID is opt-in: when supplied, the missing-key refusal carries
  ;; the errata requirement and names the missing field; when omitted, the
  ;; refusal is byte-identical to the pre-erratum behavior (no regression for
  ;; existing call sites).
  (dolist (key required-keys)
    (unless (assoc key parsed :test #'eq)
      (if requirement-id
          (signal-kernel0 condition-type
                          :failed-invariant failed-invariant
                          :requirement-id requirement-id
                          :offending-field key)
          (signal-kernel0 condition-type
                          :failed-invariant failed-invariant)))))

(defun %parsed-argument (parsed key &optional default)
  (let ((entry (assoc key parsed :test #'eq)))
    (if entry (cdr entry) default)))

(defun %validate-axis-common (determinacy evidence procedure-id)
  (unless (determinacy-p determinacy)
    (signal-kernel0
     'malformed-constructor-shape
     :requirement-id "K0E-33"
     :offending-field :determinacy
     :failed-invariant
     "§7.1, §9, Appendix A.3 [K0E-33]: every outcome axis MUST carry one determinacy record"))
  (let ((evidence-copy
          (%reference-list
           evidence
           "§9 and Appendix A.3: axis evidence MUST be a list of durable evidence references")))
    (when procedure-id
      (require-identity procedure-id :procedure))
    evidence-copy))

(defun make-execution-axis (&rest arguments)
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:value
             :determinacy
             :evidence
             :procedure-id
             :frontier-qualifier)
           'malformed-constructor-shape
           "§9.2, Appendix A.3 [K0E-33]: execution axes MUST use only the closed execution value and qualifier schema without unknown or duplicate fields")))
    (%require-constructor-keys
     parsed
     '(:value :determinacy)
     'malformed-constructor-shape
     "§7.1, §9.2 [K0E-33]: an execution axis MUST bind value and determinacy")
    (let* ((value (%parsed-argument parsed :value))
           (determinacy (%parsed-argument parsed :determinacy))
           (evidence (%parsed-argument parsed :evidence nil))
           (procedure-id (%parsed-argument parsed :procedure-id nil))
           (frontier-qualifier
             (%parsed-argument parsed :frontier-qualifier nil)))
      (unless (%execution-value-p value)
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-33"
         :offending-field :value
         :offending-value value
         :failed-invariant
         "§9.2 [F: OUT-2, K0E-33]: execution value MUST be a member of the closed execution algebra"))
      (when (and (eq value :refused)
                 (eq frontier-qualifier :post-frontier))
        (signal-kernel0
         'frontier-already-crossed
         :failed-invariant
         "§9.2 rule 2: a post-frontier termination MUST NOT be rewritten or constructed as :refused"))
      (when frontier-qualifier
        (unless (and (member frontier-qualifier
                             '(:pre-frontier :post-frontier)
                             :test #'eq)
                     (member value
                             '(:failed :cancelled :completed :indeterminate)
                             :test #'eq))
          (signal-kernel0
           'frontier-precondition-failed
           :failed-invariant
           "§9.2 rule 3: frontier qualifiers are permitted only on :failed, :cancelled, :completed, or :indeterminate execution")))
      (%validate-bounded-axis-alternatives :execution value determinacy)
      (%make-axis
       :execution
       value
       determinacy
       (%validate-axis-common determinacy evidence procedure-id)
       procedure-id
       frontier-qualifier
       nil
       nil
       nil
       nil))))

(defun %manifestation-axis-absence-form-p (value)
  (and (%proper-list-p value)
       (= 3 (length value))
       (eq (first value) :absent)
       (eq (second value) :state)
       (absence-state-p (third value))))

(defun make-manifestation-axis (&rest arguments)
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:value :determinacy :evidence :procedure-id)
           'malformed-constructor-shape
           "§9.3, Appendix A.3 [K0E-33]: manifestation axes MUST carry a manifestation reference or the exact (:absent :state <absence-state>) form")))
    (%require-constructor-keys
     parsed
     '(:value :determinacy)
     'malformed-constructor-shape
     "§7.1, §9.3 [K0E-33]: a manifestation axis MUST bind value and determinacy")
    (let* ((value (%parsed-argument parsed :value))
           (determinacy (%parsed-argument parsed :determinacy))
           (evidence (%parsed-argument parsed :evidence nil))
           (procedure-id (%parsed-argument parsed :procedure-id nil)))
      (cond ((manifestation-p value))
            ((durable-identity-p value)
             (require-identity value :manifestation))
            ((not (%manifestation-axis-absence-form-p value))
             (signal-kernel0
              'malformed-constructor-shape
              :requirement-id "K0E-33"
              :offending-field :value
              :offending-value value
              :failed-invariant
              "§9.3 [K0E-33]: manifestation axis value MUST be a manifestation record/reference or (:absent :state <closed absence-state>)")))
      (%validate-bounded-axis-alternatives :manifestation value determinacy)
      (%make-axis
       :manifestation
       (%snapshot-tree value)
       determinacy
       (%validate-axis-common determinacy evidence procedure-id)
       procedure-id
       nil
       nil
       nil
       nil
       nil))))

(defun make-effect-axis (&rest arguments)
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:value
             :determinacy
             :evidence
             :procedure-id
             :uncertain-effect-ref
             :effect-group)
           'malformed-constructor-shape
           "§9.4, Appendix A.3 [K0E-33]: effect axes MUST use only the closed effect schema without unknown or duplicate fields; structured-uncertainty law (§10.8, R-SYN-1) is enforced separately")))
    (%require-constructor-keys
     parsed
     '(:value :determinacy :effect-group)
     'malformed-constructor-shape
     "§7.1 and §9.4 [K0E-33]: an effect axis MUST bind value, determinacy, and its declared effect group")
    (let* ((value (%parsed-argument parsed :value))
           (determinacy (%parsed-argument parsed :determinacy))
           (evidence (%parsed-argument parsed :evidence nil))
           (procedure-id (%parsed-argument parsed :procedure-id nil))
           (uncertain-effect-ref
             (%parsed-argument parsed :uncertain-effect-ref nil))
           (effect-group (%parsed-argument parsed :effect-group)))
      (unless (%effect-value-p value)
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-33"
         :offending-field :value
         :offending-value value
         :failed-invariant
         "§9.4 [F: OUT-3, K0E-33]: effect value MUST be a member of the closed external-effect algebra"))
      (require-identity effect-group :effect)
      (when (and uncertain-effect-ref
                 (not (uncertain-effect-p uncertain-effect-ref)))
        (signal-kernel0
         'unstructured-uncertainty
         :failed-invariant
         "§9.4 and §10.8: uncertain-effect-ref MUST reference a structured uncertain-effect record"))
      (when (and (member value '(:bounded :indeterminate) :test #'eq)
                 (not (uncertain-effect-p uncertain-effect-ref)))
        (signal-kernel0
         'unstructured-uncertainty
         :failed-invariant
         "§9.4, §10.8, and §22 R-SYN-1: :bounded or :indeterminate effect axes MUST reference a structured uncertain-effect record; inline alternatives/evidence alone are unlawful"))
      ;; K0E-4: a :bounded effect *determinacy* MUST reference a §10.8
      ;; uncertain-effect record whose :possible-effects are set-identical
      ;; (order-insensitive, Kernel equality, duplicate-free) to the
      ;; determinacy alternatives.  The value-based ref requirement above
      ;; already caught an inline-only :bounded/:indeterminate value, so the
      ;; unstructured-uncertainty refusal keeps precedence for that case.
      (when (and (determinacy-p determinacy)
                 (eq (determinacy-mode determinacy) :bounded))
        (unless (uncertain-effect-p uncertain-effect-ref)
          (signal-kernel0
           'determinacy-alternatives-invalid
           :requirement-id "K0E-4"
           :offending-field :uncertain-effect-ref
           :offending-value uncertain-effect-ref
           :failed-invariant
           "§9.4, §10.8, K0E-4: a :bounded effect determinacy MUST reference a structured uncertain-effect record to establish its settlement space"))
        (unless (%set-identical=
                 (determinacy-alternatives determinacy)
                 (uncertain-effect-possible-effects uncertain-effect-ref))
          (signal-kernel0
           'determinacy-alternatives-invalid
           :requirement-id "K0E-4"
           :offending-field :alternatives
           :offending-value (determinacy-alternatives determinacy)
           :failed-invariant
           "§10.8, K0E-4: a :bounded effect axis's determinacy alternatives MUST be set-identical to the referenced uncertain-effect's :possible-effects")))
      (%make-axis
       :effects
       value
       determinacy
       (%validate-axis-common determinacy evidence procedure-id)
       procedure-id
       nil
       uncertain-effect-ref
       effect-group
       nil
       nil))))

(defun make-interpretation-axis (&rest arguments)
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:value :determinacy :evidence :procedure-id :judgment-class
             :procedure-version)
           'malformed-constructor-shape
           "§9.5, Appendix A.3 [K0E-33]: interpretation axes MUST use only the closed interpretation schema without unknown or duplicate fields")))
    (%require-constructor-keys
     parsed
     '(:value :determinacy)
     'malformed-constructor-shape
     "§7.1, §9.5 [K0E-33]: an interpretation axis MUST bind value and determinacy")
    (let* ((value (%parsed-argument parsed :value))
           (determinacy (%parsed-argument parsed :determinacy))
           (evidence (%parsed-argument parsed :evidence nil))
           (procedure-id (%parsed-argument parsed :procedure-id nil))
           (judgment-class (%parsed-argument parsed :judgment-class nil))
           (procedure-version-entry
             (assoc :procedure-version parsed :test #'eq))
           (procedure-version (cdr procedure-version-entry)))
      (unless (%interpretation-value-p value)
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-33"
         :offending-field :value
         :offending-value value
         :failed-invariant
         "§9.5 [F: OUT-4, K0E-33]: interpretation value MUST be a member of the closed interpretation algebra"))
      (when (and (not (member value
                              '(:not-attempted :not-applicable)
                              :test #'eq))
                 (null procedure-id))
        (signal-kernel0
         'interpretation-procedure-missing
         :failed-invariant
         "§9.5 [F: OUT-4]: every ordinary interpretation MUST name its parser, rubric, validator, policy, or procedure"))
      ;; K0E-23: the cached judgment class is a reference-site CACHE, not
      ;; authority.  When supplied it MUST be exactly :structural or :semantic.
      (when judgment-class
        (unless (member judgment-class '(:structural :semantic) :test #'eq)
          (signal-kernel0
           'malformed-constructor-shape
           :requirement-id "K0E-23"
           :offending-field :judgment-class
           :offending-value judgment-class
           :failed-invariant
           "§4.1 [K0E-23]: a cached interpretation judgment class MUST be exactly :structural or :semantic"))
        ;; K0E-25 (construction-time): a structurally-classed procedure cannot
        ;; license :accepted or :rejected.  The descriptor-level authority is in
        ;; VALIDATE-INTERPRETATION-AGAINST-DESCRIPTOR; this cache-consistent
        ;; check refuses the illegal shape at the axis where the cache is set.
        (when (and (eq judgment-class :structural)
                   (member value '(:accepted :rejected) :test #'eq))
          (signal-kernel0
           'interpretation-class-violation
           :requirement-id "K0E-25"
           :offending-field :value
           :offending-value value
           :failed-invariant
           "§9.6, §4.2 [K0E-25]: a structural judgment class MUST NOT license an :accepted or :rejected interpretation")))
      ;; K0E-23: a procedure-relative interpretation binds an EXACT
      ;; identity/version reference.  A procedure identity with no version is not
      ;; a harmless cache omission: it leaves the caller free to choose among
      ;; descriptors after the judgment has been minted.  Therefore every axis
      ;; carrying :procedure-id MUST explicitly carry a nonnegative-integer
      ;; :procedure-version, and version/class fields are forbidden without an
      ;; identity.  Integers are the closed immutable v0 version representation.
      (when (and procedure-id (null procedure-version-entry))
        (signal-kernel0
         'interpretation-class-violation
         :requirement-id "K0E-23"
         :offending-field :procedure-version
         :offending-value nil
         :failed-invariant
         "§4.1 [K0E-23]: every procedure-relative interpretation MUST bind the exact nonnegative-integer procedure version; a procedure-id with no version leaves descriptor resolution caller-selectable"))
      (when (and procedure-version-entry (null procedure-id))
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-23"
         :offending-field :procedure-version
         :offending-value procedure-version
         :failed-invariant
         "§4.1 [K0E-23]: an interpretation :procedure-version is meaningful only together with :procedure-id"))
      (when (and judgment-class (null procedure-id))
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-23"
         :offending-field :judgment-class
         :offending-value judgment-class
         :failed-invariant
         "§4.1 [K0E-23]: a cached judgment class is meaningful only together with a procedure identity/version reference"))
      (when (and procedure-version-entry
                 (not (and (integerp procedure-version)
                           (not (minusp procedure-version)))))
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-23"
         :offending-field :procedure-version
         :offending-value procedure-version
         :failed-invariant
         "§4.1 [K0E-23]: a supplied interpretation :procedure-version MUST be a nonnegative integer; NIL, a string, a list, a negative, or any non-integer host object is refused"))
      (%validate-bounded-axis-alternatives :interpretation value determinacy)
      (%make-axis
       :interpretation
       value
       determinacy
       (%validate-axis-common determinacy evidence procedure-id)
       procedure-id
       nil
       nil
       nil
       judgment-class
       procedure-version))))

(defstruct (outcome
            (:constructor %make-outcome
                (outcome-version
                 process-id
                 logical-operation-id
                 seat-id
                 attempt-id
                 machine-configuration-id
                 execution
                 manifestation
                 effects
                 interpretation
                 interpretation-descriptor
                 receipts
                 bounded-unknowns))
            (:copier nil)
            (:conc-name %outcome-))
  (outcome-version 0 :read-only t)
  (process-id nil :read-only t)
  (logical-operation-id nil :read-only t)
  (seat-id nil :read-only t)
  (attempt-id nil :read-only t)
  (machine-configuration-id nil :read-only t)
  (execution nil :read-only t)
  (manifestation nil :read-only t)
  (effects nil :read-only t)
  (interpretation nil :read-only t)
  ;; The exact immutable K0E-23 descriptor that authorized the procedure-
  ;; relative interpretation.  Retaining it makes descriptor resolution and
  ;; K0E-25 validation inspectable after construction instead of depending on
  ;; forgotten caller state.  NIL only when the interpretation names no
  ;; procedure (normally :not-attempted / :not-applicable).
  (interpretation-descriptor nil :read-only t)
  (receipts nil :read-only t)
  (bounded-unknowns nil :read-only t))

(defun outcome-outcome-version (outcome)
  (%outcome-outcome-version outcome))

(defun outcome-process-id (outcome)
  (%outcome-process-id outcome))

(defun outcome-logical-operation-id (outcome)
  (%outcome-logical-operation-id outcome))

(defun outcome-seat-id (outcome)
  (%outcome-seat-id outcome))

(defun outcome-attempt-id (outcome)
  (%outcome-attempt-id outcome))

(defun outcome-machine-configuration-id (outcome)
  (%outcome-machine-configuration-id outcome))

(defun outcome-interpretation-descriptor (outcome)
  "Return the exact immutable procedure descriptor bound to OUTCOME's
interpretation, or NIL when the interpretation names no procedure."
  (%outcome-interpretation-descriptor outcome))

(defun outcome-receipts (outcome)
  (%snapshot-tree (%outcome-receipts outcome)))

(defun outcome-bounded-unknowns (outcome)
  (%snapshot-tree (%outcome-bounded-unknowns outcome)))

(defun %axis-of-kind-p (value kind)
  (and (axis-p value) (eq (%axis-axis-name value) kind)))

(defun %manifestation-axis-absence-state (manifestation-axis)
  (let ((value (%axis-value manifestation-axis)))
    (cond ((%manifestation-axis-absence-form-p value) (third value))
          ((and (manifestation-p value)
                (member (manifestation-status value)
                        '(:absent :withheld :redacted)
                        :test #'eq))
           (manifestation-absence-state value)))))

(defun %interpretation-present-compatible-p (manifestation-axis)
  (let ((value (%axis-value manifestation-axis)))
    (and (manifestation-p value)
         (member (manifestation-status value)
                 '(:present :present-empty)
                 :test #'eq))))

(defun %validate-outcome-cross-axis
    (execution manifestation effects interpretation
     process-id attempt-id seat-id logical-operation-id)
  (when (eq (%axis-value execution) :not-attempted)
    (unless (and (eq (%axis-value effects) :not-entered)
                 (eq (%manifestation-axis-absence-state manifestation)
                     :never-attempted))
      (signal-kernel0
       'frontier-precondition-failed
       :process-id process-id
       :attempt-id attempt-id
       :seat-id seat-id
       :operation-id logical-operation-id
       :failed-invariant
       "§9.6 [F: OUT-5]: execution :not-attempted requires effects :not-entered and manifestation absence-state :never-attempted")))
  (when (eq (%axis-value execution) :refused)
    (unless (eq (%axis-value effects) :not-entered)
      (signal-kernel0
       'frontier-precondition-failed
       :process-id process-id
       :attempt-id attempt-id
       :seat-id seat-id
       :operation-id logical-operation-id
       :failed-invariant
       "§9.2 rule 1 and §12.6: execution :refused is pre-frontier, emits no frontier-crossed event, and therefore requires effects :not-entered")))
  (let ((manifestation-value (%axis-value manifestation)))
    (when (and (manifestation-p manifestation-value)
               (present-manifestation-status-p
                (manifestation-status manifestation-value))
               (null (manifestation-payload-id manifestation-value)))
      (signal-kernel0
       'manifestation-payload-missing
       :process-id process-id
       :attempt-id attempt-id
       :seat-id seat-id
       :operation-id logical-operation-id
       :failed-invariant
       "§9.6 [F: OUT-5]: an outcome carrying a :present* manifestation MUST preserve its payload identity")))
  (when (member (%axis-value interpretation)
                '(:accepted :rejected)
                :test #'eq)
    ;; §9.6 / K0E-25 present-invalid relabel guard.  %INTERPRETATION-PRESENT-
    ;; COMPATIBLE-P admits ONLY :present and :present-empty, so a :present-invalid
    ;; (or any absent) manifestation is refused here: an :accepted/:rejected label
    ;; over a :present-invalid payload is exactly the relabel K0E-25 forbids
    ;; without a receipt-bearing transformation.  The type stays STANDING-
    ;; INFLATION (this is genuine epistemic promotion; §25 test 45 asserts it);
    ;; only the citation is widened to K0E-25.
    (unless (%interpretation-present-compatible-p manifestation)
      (signal-kernel0
       'standing-inflation
       :process-id process-id
       :attempt-id attempt-id
       :seat-id seat-id
       :operation-id logical-operation-id
       :failed-invariant
       "§9.6 [F: OUT-5, K0E-25]: :accepted or :rejected interpretation requires a referenced manifestation with status :present or :present-empty; a :present-invalid manifestation MUST NOT be relabeled accepted or rejected without a receipt-bearing transformation"))))

(defun make-outcome (&rest arguments)
  "Construct a version-zero outcome and reject every non-schema/global scalar key.

K0E-23/K0E-25 -- the MANDATORY PROCEDURE GATE.  An interpretation AXIS is a
constructible intermediate, but only MAKE-OUTCOME mints an OUTCOME.  Whenever the
axis names a procedure, :INTERPRETATION-DESCRIPTOR is REQUIRED and is validated
against the exact identity/version/class/result vocabulary.  For :accepted or
:rejected, validation additionally binds the descriptor to the outcome's OWN
manifestation, input domain, and required evidence.  The exact immutable
descriptor is retained in the outcome for inspection and reconstruction.
Supplying a descriptor when the interpretation names no procedure is refused."
  ;; §7.5/K0E-33 split: a confidence/uncertainty/probability scalar is refused
  ;; as a global-uncertainty scalar (its own typed refusal) BEFORE the strict
  ;; parse would otherwise re-read it as a merely unknown field.
  (%reject-global-uncertainty-scalar
   arguments
   "K0E-33"
   "§7.5, §9.1, §25.1 test 8: the canonical outcome MUST reject an outcome-level confidence, uncertainty, or probability scalar in place of per-axis determinacy")
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:outcome-version
             :process-id
             :logical-operation-id
             :seat-id
             :attempt-id
             :machine-configuration-id
             :execution
             :manifestation
             :effects
             :interpretation
             :interpretation-descriptor
             :receipts
             :bounded-unknowns)
           'malformed-constructor-shape
           "§9.1, Appendix A.4 [K0E-33]: the canonical outcome constructor accepts only the version-zero schema and rejects any other unknown or duplicate field")))
    (%require-constructor-keys
     parsed
     '(:process-id
       :logical-operation-id
       :seat-id
       :attempt-id
       :execution
       :manifestation
       :effects
       :interpretation)
     'malformed-constructor-shape
     "§9.1, Appendix A.4 [K0E-33]: an outcome MUST bind its four context identities and all four full axes")
    (let* ((outcome-version (%parsed-argument parsed :outcome-version 0))
           (process-id (%parsed-argument parsed :process-id))
           (logical-operation-id
             (%parsed-argument parsed :logical-operation-id))
           (seat-id (%parsed-argument parsed :seat-id))
           (attempt-id (%parsed-argument parsed :attempt-id))
           (machine-configuration-id
             (%parsed-argument parsed :machine-configuration-id nil))
           (execution (%parsed-argument parsed :execution))
           (manifestation (%parsed-argument parsed :manifestation))
           (effects (%parsed-argument parsed :effects))
           (interpretation (%parsed-argument parsed :interpretation))
           (interpretation-descriptor
             (%parsed-argument parsed :interpretation-descriptor nil))
           (receipts (%parsed-argument parsed :receipts nil))
           (bounded-unknowns
             (%parsed-argument parsed :bounded-unknowns nil)))
      (unless (eql outcome-version 0)
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-33"
         :offending-field :outcome-version
         :offending-value outcome-version
         :failed-invariant
         "§9.1, Appendix A.4 [K0E-33]: Kernel /0 outcome-version MUST equal 0"))
      (require-identity process-id :process)
      (require-identity logical-operation-id :logical-operation)
      (require-identity seat-id :seat)
      (require-identity attempt-id :attempt)
      (when machine-configuration-id
        (require-identity machine-configuration-id :machine-configuration))
      (unless (%axis-of-kind-p execution :execution)
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-33"
         :offending-field :execution
         :failed-invariant
         "§9.1, §9.2 [K0E-33]: the execution slot MUST carry an execution axis constructed under the closed execution algebra"))
      (unless (%axis-of-kind-p manifestation :manifestation)
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-33"
         :offending-field :manifestation
         :failed-invariant
         "§9.1, §9.3 [K0E-33]: the manifestation slot MUST carry a manifestation axis"))
      (unless (%axis-of-kind-p effects :effects)
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-33"
         :offending-field :effects
         :failed-invariant
         "§9.1, §9.4 [K0E-33]: the effects slot MUST carry an external-effect axis"))
      (unless (%axis-of-kind-p interpretation :interpretation)
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-33"
         :offending-field :interpretation
         :failed-invariant
         "§9.1, §9.5 [K0E-33]: the interpretation slot MUST carry an interpretation axis"))
      (let ((receipt-copy
              (%reference-list
               receipts
               "§9.1 and Appendix A.4: outcome receipts MUST be a list of receipt identities"
               :expected-domain :receipt)))
        (unless (%proper-list-p bounded-unknowns)
          (signal-kernel0
           'malformed-constructor-shape
           :requirement-id "K0E-33"
           :offending-field :bounded-unknowns
           :offending-value bounded-unknowns
           :failed-invariant
           "§9.1, Appendix A.4 [K0E-33]: bounded-unknowns MUST be represented as a finite proper list"))
        (%validate-outcome-cross-axis
         execution
         manifestation
         effects
         interpretation
         process-id
         attempt-id
         seat-id
         logical-operation-id)
        ;; K0E-23/K0E-25: every procedure-relative interpretation is validated
        ;; on the sole public outcome-construction path and retains the exact
        ;; descriptor used.  This closes two sibling paths: descriptor-bearing
        ;; :invalid judgments were formerly refused despite K0E-25 explicitly
        ;; permitting structural or semantic invalidity, while descriptor-free
        ;; :invalid/:refused/:indeterminate judgments escaped K0E-23 resolution.
        (let* ((interpretation-value (%axis-value interpretation))
               (procedure-id (%axis-procedure-id interpretation))
               (accepted-or-rejected-p
                 (member interpretation-value '(:accepted :rejected) :test #'eq)))
          (cond
            (procedure-id
             (unless interpretation-descriptor
               (signal-kernel0
                'interpretation-class-violation
                :requirement-id (if accepted-or-rejected-p "K0E-25" "K0E-23")
                :offending-field :interpretation-descriptor
                :offending-value nil
                :process-id process-id
                :attempt-id attempt-id
                :seat-id seat-id
                :operation-id logical-operation-id
                :failed-invariant
                "§4.1/§9.6 [K0E-23,K0E-25]: every procedure-relative interpretation MUST supply the exact immutable descriptor it was judged under; semantic acceptance additionally binds that descriptor to the manifestation and required evidence"))
             (validate-interpretation-against-descriptor
              interpretation
              interpretation-descriptor
              :manifestation (%axis-value manifestation)))
            (interpretation-descriptor
             (signal-kernel0
              'interpretation-class-violation
              :requirement-id "K0E-23"
              :offending-field :interpretation-descriptor
              :offending-value interpretation-descriptor
              :process-id process-id
              :attempt-id attempt-id
              :seat-id seat-id
              :operation-id logical-operation-id
              :failed-invariant
              "§4.1 [K0E-23]: an interpretation descriptor may be attached only when the interpretation axis names the procedure identity/version it resolves"))))
        (%make-outcome
         outcome-version
         process-id
         logical-operation-id
         seat-id
         attempt-id
         machine-configuration-id
         execution
         manifestation
         effects
         interpretation
         interpretation-descriptor
         receipt-copy
         (%snapshot-tree bounded-unknowns))))))

(defun outcome-axis (outcome axis-name)
  "Return the complete requested axis; never discard determinacy/effect context."
  (unless (outcome-p outcome)
    (signal-kernel0
     'outcome-context-discard
     :failed-invariant
     "§24.4 [F: OP-3]: outcome-axis requires a structured outcome and MUST NOT manufacture a bare answer"))
  (case axis-name
    (:execution (%outcome-execution outcome))
    (:manifestation (%outcome-manifestation outcome))
    (:effects (%outcome-effects outcome))
    (:interpretation (%outcome-interpretation outcome))
    (otherwise
     (signal-kernel0
      'outcome-context-discard
      :process-id (%outcome-process-id outcome)
      :attempt-id (%outcome-attempt-id outcome)
      :seat-id (%outcome-seat-id outcome)
      :operation-id (%outcome-logical-operation-id outcome)
      :failed-invariant
      "§24.4 [F: OP-3]: outcome-axis accepts only :execution, :manifestation, :effects, or :interpretation and returns the full axis"))))
