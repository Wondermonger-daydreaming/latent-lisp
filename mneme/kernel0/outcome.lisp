(in-package #:lisp-plus-kernel0)

(defstruct (axis
            (:constructor %make-axis
                (axis-name
                 value
                 determinacy
                 evidence
                 procedure-id
                 frontier-qualifier
                 uncertain-effect-ref
                 effect-group))
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
  (effect-group nil :read-only t))

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

(defun %require-constructor-keys
    (parsed required-keys condition-type failed-invariant)
  (dolist (key required-keys)
    (unless (assoc key parsed :test #'eq)
      (signal-kernel0 condition-type :failed-invariant failed-invariant))))

(defun %parsed-argument (parsed key &optional default)
  (let ((entry (assoc key parsed :test #'eq)))
    (if entry (cdr entry) default)))

(defun %validate-axis-common (determinacy evidence procedure-id)
  (unless (determinacy-p determinacy)
    (signal-kernel0
     'standing-inflation
     :failed-invariant
     "§7.1, §9, and Appendix A.3: every outcome axis MUST carry one determinacy record"))
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
           'standing-inflation
           "§9.2 and Appendix A.3: execution axes MUST use only the closed execution value and qualifier schema")))
    (%require-constructor-keys
     parsed
     '(:value :determinacy)
     'standing-inflation
     "§7.1 and §9.2: an execution axis MUST bind value and determinacy")
    (let* ((value (%parsed-argument parsed :value))
           (determinacy (%parsed-argument parsed :determinacy))
           (evidence (%parsed-argument parsed :evidence nil))
           (procedure-id (%parsed-argument parsed :procedure-id nil))
           (frontier-qualifier
             (%parsed-argument parsed :frontier-qualifier nil)))
      (unless (member value
                      '(:not-attempted
                        :refused
                        :failed
                        :completed
                        :cancelled
                        :indeterminate)
                      :test #'eq)
        (signal-kernel0
         'standing-inflation
         :failed-invariant
         "§9.2 [F: OUT-2]: execution value MUST be a member of the closed execution algebra"))
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
      (%make-axis
       :execution
       value
       determinacy
       (%validate-axis-common determinacy evidence procedure-id)
       procedure-id
       frontier-qualifier
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
           'standing-inflation
           "§9.3 and Appendix A.3: manifestation axes MUST carry a manifestation reference or the exact (:absent :state <absence-state>) form")))
    (%require-constructor-keys
     parsed
     '(:value :determinacy)
     'standing-inflation
     "§7.1 and §9.3: a manifestation axis MUST bind value and determinacy")
    (let* ((value (%parsed-argument parsed :value))
           (determinacy (%parsed-argument parsed :determinacy))
           (evidence (%parsed-argument parsed :evidence nil))
           (procedure-id (%parsed-argument parsed :procedure-id nil)))
      (cond ((manifestation-p value))
            ((durable-identity-p value)
             (require-identity value :manifestation))
            ((not (%manifestation-axis-absence-form-p value))
             (signal-kernel0
              'standing-inflation
              :failed-invariant
              "§9.3: manifestation axis value MUST be a manifestation record/reference or (:absent :state <closed absence-state>)")))
      (%make-axis
       :manifestation
       (%snapshot-tree value)
       determinacy
       (%validate-axis-common determinacy evidence procedure-id)
       procedure-id
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
           'unstructured-uncertainty
           "§9.4, §10.8, R-SYN-1, and Appendix A.3: effect axes MUST use the closed value schema and structured uncertainty reference")))
    (%require-constructor-keys
     parsed
     '(:value :determinacy :effect-group)
     'unstructured-uncertainty
     "§7.1 and §9.4: an effect axis MUST bind value, determinacy, and its declared effect group")
    (let* ((value (%parsed-argument parsed :value))
           (determinacy (%parsed-argument parsed :determinacy))
           (evidence (%parsed-argument parsed :evidence nil))
           (procedure-id (%parsed-argument parsed :procedure-id nil))
           (uncertain-effect-ref
             (%parsed-argument parsed :uncertain-effect-ref nil))
           (effect-group (%parsed-argument parsed :effect-group)))
      (unless (member value
                      '(:not-entered
                        :prepared
                        :crossed
                        :settled
                        :compensated
                        :bounded
                        :indeterminate)
                      :test #'eq)
        (signal-kernel0
         'standing-inflation
         :failed-invariant
         "§9.4 [F: OUT-3]: effect value MUST be a member of the closed external-effect algebra"))
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
      (%make-axis
       :effects
       value
       determinacy
       (%validate-axis-common determinacy evidence procedure-id)
       procedure-id
       nil
       uncertain-effect-ref
       effect-group))))

(defun make-interpretation-axis (&rest arguments)
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:value :determinacy :evidence :procedure-id)
           'standing-inflation
           "§9.5 and Appendix A.3: interpretation axes MUST use only the closed interpretation schema")))
    (%require-constructor-keys
     parsed
     '(:value :determinacy)
     'standing-inflation
     "§7.1 and §9.5: an interpretation axis MUST bind value and determinacy")
    (let* ((value (%parsed-argument parsed :value))
           (determinacy (%parsed-argument parsed :determinacy))
           (evidence (%parsed-argument parsed :evidence nil))
           (procedure-id (%parsed-argument parsed :procedure-id nil)))
      (unless (member value
                      '(:not-attempted
                        :not-applicable
                        :accepted
                        :rejected
                        :invalid
                        :refused
                        :indeterminate)
                      :test #'eq)
        (signal-kernel0
         'standing-inflation
         :failed-invariant
         "§9.5 [F: OUT-4]: interpretation value MUST be a member of the closed interpretation algebra"))
      (when (and (not (member value
                              '(:not-attempted :not-applicable)
                              :test #'eq))
                 (null procedure-id))
        (signal-kernel0
         'interpretation-procedure-missing
         :failed-invariant
         "§9.5 [F: OUT-4]: every ordinary interpretation MUST name its parser, rubric, validator, policy, or procedure"))
      (%make-axis
       :interpretation
       value
       determinacy
       (%validate-axis-common determinacy evidence procedure-id)
       procedure-id
       nil
       nil
       nil))))

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
    (unless (%interpretation-present-compatible-p manifestation)
      (signal-kernel0
       'standing-inflation
       :process-id process-id
       :attempt-id attempt-id
       :seat-id seat-id
       :operation-id logical-operation-id
       :failed-invariant
       "§9.6 [F: OUT-5]: :accepted or :rejected interpretation requires a referenced manifestation with status :present or :present-empty"))))

(defun make-outcome (&rest arguments)
  "Construct a version-zero outcome and reject every non-schema/global scalar key."
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
             :receipts
             :bounded-unknowns)
           'standing-inflation
           "§7.5, §9.1, and §25.1 test 8: the canonical outcome constructor accepts only the version-zero schema and MUST reject confidence, uncertainty, probability, or any unknown field")))
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
     'standing-inflation
     "§9.1 and Appendix A.4: an outcome MUST bind its four context identities and all four full axes")
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
           (receipts (%parsed-argument parsed :receipts nil))
           (bounded-unknowns
             (%parsed-argument parsed :bounded-unknowns nil)))
      (unless (eql outcome-version 0)
        (signal-kernel0
         'standing-inflation
         :failed-invariant
         "§9.1 and Appendix A.4: Kernel /0 outcome-version MUST equal 0"))
      (require-identity process-id :process)
      (require-identity logical-operation-id :logical-operation)
      (require-identity seat-id :seat)
      (require-identity attempt-id :attempt)
      (when machine-configuration-id
        (require-identity machine-configuration-id :machine-configuration))
      (unless (%axis-of-kind-p execution :execution)
        (signal-kernel0
         'standing-inflation
         :failed-invariant
         "§9.1 and §9.2: the execution slot MUST carry an execution axis constructed under the closed execution algebra"))
      (unless (%axis-of-kind-p manifestation :manifestation)
        (signal-kernel0
         'standing-inflation
         :failed-invariant
         "§9.1 and §9.3: the manifestation slot MUST carry a manifestation axis"))
      (unless (%axis-of-kind-p effects :effects)
        (signal-kernel0
         'standing-inflation
         :failed-invariant
         "§9.1 and §9.4: the effects slot MUST carry an external-effect axis"))
      (unless (%axis-of-kind-p interpretation :interpretation)
        (signal-kernel0
         'standing-inflation
         :failed-invariant
         "§9.1 and §9.5: the interpretation slot MUST carry an interpretation axis"))
      (let ((receipt-copy
              (%reference-list
               receipts
               "§9.1 and Appendix A.4: outcome receipts MUST be a list of receipt identities"
               :expected-domain :receipt)))
        (unless (%proper-list-p bounded-unknowns)
          (signal-kernel0
           'standing-inflation
           :failed-invariant
           "§9.1 and Appendix A.4: bounded-unknowns MUST be represented as a finite proper list"))
        (%validate-outcome-cross-axis
         execution
         manifestation
         effects
         interpretation
         process-id
         attempt-id
         seat-id
         logical-operation-id)
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
