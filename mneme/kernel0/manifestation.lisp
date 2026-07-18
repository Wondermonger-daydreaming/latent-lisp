(in-package #:lisp-plus-kernel0)

(defun manifestation-status-p (value)
  (case value
    ((:present
      :present-empty
      :present-invalid
      :present-partial
      :absent
      :withheld
      :redacted)
     t)
    (otherwise nil)))

(defun absence-state-p (value)
  (case value
    ((:never-attempted
      :refused-pre-effect
      :absent-after-completion
      :withheld
      :redacted
      :not-applicable)
     t)
    (otherwise nil)))

(defun present-manifestation-status-p (value)
  (case value
    ((:present :present-empty :present-invalid :present-partial) t)
    (otherwise nil)))

(defstruct (manifestation
            (:constructor %make-manifestation
                (manifestation-id
                 attempt-id
                 kind
                 status
                 payload-id
                 absence-state
                 parser-id
                 source-boundary
                 visibility
                 emptiness-rule-id))
            (:copier nil)
            (:conc-name %manifestation-))
  (manifestation-id nil :read-only t)
  (attempt-id nil :read-only t)
  (kind nil :read-only t)
  (status nil :read-only t)
  (payload-id nil :read-only t)
  (absence-state nil :read-only t)
  (parser-id nil :read-only t)
  (source-boundary nil :read-only t)
  (visibility nil :read-only t)
  (emptiness-rule-id nil :read-only t))

(defun manifestation-manifestation-id (manifestation)
  (%manifestation-manifestation-id manifestation))

(defun manifestation-attempt-id (manifestation)
  (%manifestation-attempt-id manifestation))

(defun manifestation-kind (manifestation)
  (%snapshot-tree (%manifestation-kind manifestation)))

(defun manifestation-status (manifestation)
  (%manifestation-status manifestation))

(defun manifestation-payload-id (manifestation)
  (%manifestation-payload-id manifestation))

(defun manifestation-absence-state (manifestation)
  (%manifestation-absence-state manifestation))

(defun manifestation-parser-id (manifestation)
  (%manifestation-parser-id manifestation))

(defun manifestation-source-boundary (manifestation)
  (%snapshot-tree (%manifestation-source-boundary manifestation)))

(defun manifestation-visibility (manifestation)
  (%snapshot-tree (%manifestation-visibility manifestation)))

(defun manifestation-emptiness-rule-id (manifestation)
  (%manifestation-emptiness-rule-id manifestation))

(defun %require-manifestation-list-field (value failed-invariant)
  (unless (%proper-list-p value)
    (signal-kernel0 'standing-inflation
                    :failed-invariant failed-invariant))
  (%snapshot-tree value))

(defun make-manifestation (&rest arguments)
  "Construct an immutable manifestation state, without a causal-diagnosis slot."
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:manifestation-id
             :attempt-id
             :kind
             :status
             :payload-id
             :absence-state
             :parser-id
             :source-boundary
             :visibility
             :emptiness-rule-id)
           'standing-inflation
           "§8, §8.7, §8.9.1, and Appendix A.2: a manifestation constructor MUST use only the closed state schema and MUST NOT attach cause to absence state")))
    (multiple-value-bind (manifestation-id manifestation-id-supplied-p)
        (%constructor-argument parsed :manifestation-id)
      (declare (ignore manifestation-id-supplied-p))
      (multiple-value-bind (attempt-id attempt-id-supplied-p)
          (%constructor-argument parsed :attempt-id)
        (declare (ignore attempt-id-supplied-p))
        (multiple-value-bind (kind kind-supplied-p)
            (%constructor-argument parsed :kind)
          (multiple-value-bind (status status-supplied-p)
              (%constructor-argument parsed :status)
            (multiple-value-bind (payload-id payload-id-supplied-p)
                (%constructor-argument parsed :payload-id)
              (declare (ignore payload-id-supplied-p))
              (multiple-value-bind (absence-state absence-state-supplied-p)
                  (%constructor-argument parsed :absence-state)
                (declare (ignore absence-state-supplied-p))
                (multiple-value-bind (parser-id parser-id-supplied-p)
                    (%constructor-argument parsed :parser-id)
                  (declare (ignore parser-id-supplied-p))
                  (multiple-value-bind (source-boundary
                                        source-boundary-supplied-p)
                      (%constructor-argument parsed :source-boundary)
                    (multiple-value-bind (visibility visibility-supplied-p)
                        (%constructor-argument parsed :visibility nil)
                      (declare (ignore visibility-supplied-p))
                      (multiple-value-bind (emptiness-rule-id
                                            emptiness-rule-id-supplied-p)
                          (%constructor-argument parsed :emptiness-rule-id)
                        (declare (ignore emptiness-rule-id-supplied-p))
                        (require-identity manifestation-id :manifestation)
                        (require-identity attempt-id :attempt)
                        (unless (and kind-supplied-p kind)
                          (signal-kernel0
                           'standing-inflation
                           :attempt-id attempt-id
                           :failed-invariant
                           "§8.1 and Appendix A.2: a manifestation MUST bind its kind"))
                        (unless (and status-supplied-p
                                     (manifestation-status-p status))
                          (signal-kernel0
                           'standing-inflation
                           :attempt-id attempt-id
                           :failed-invariant
                           "§8.2 [F: MAN-1]: manifestation status MUST be a member of the closed Kernel /0 status algebra"))
                        (unless (and source-boundary-supplied-p source-boundary)
                          (signal-kernel0
                           'standing-inflation
                           :attempt-id attempt-id
                           :failed-invariant
                           "§8.1 and Appendix A.2: a manifestation MUST bind its source boundary"))
                        (let ((visibility-copy
                                (%require-manifestation-list-field
                                 visibility
                                 "§8.1 and Appendix A.2: manifestation visibility MUST be represented as a list when applicable")))
                          (when (present-manifestation-status-p status)
                            (unless payload-id
                              (signal-kernel0
                               'manifestation-payload-missing
                               :attempt-id attempt-id
                               :failed-invariant
                               "§8.3 and §9.6: every :present* manifestation MUST preserve a payload identity"))
                            (%reference-identity
                             payload-id
                             "§8.3 and §9.6: every :present* manifestation MUST preserve a durable payload identity")
                            (when absence-state
                              (signal-kernel0
                               'standing-inflation
                               :attempt-id attempt-id
                               :failed-invariant
                               "§8.3 and §8.7: a :present* manifestation MUST carry payload identity rather than a no-visible-payload absence state")))
                          (when (and payload-id
                                     (not (present-manifestation-status-p status)))
                            (if (eq status :absent)
                                (signal-kernel0
                                 'standing-inflation
                                 :attempt-id attempt-id
                                 :failed-invariant
                                 "§8.7: status :absent forbids a payload identity")
                                (%reference-identity
                                 payload-id
                                 "§8.7: any restricted payload reference MUST remain a durable identity")))
                          (case status
                            (:absent
                             (unless (member
                                      absence-state
                                      '(:never-attempted
                                        :refused-pre-effect
                                        :absent-after-completion
                                        :not-applicable)
                                      :test #'eq)
                               (signal-kernel0
                                'standing-inflation
                                :attempt-id attempt-id
                                :failed-invariant
                                "§8.7 [F: MAN-3]: status :absent permits only its four normatively mapped absence states")))
                            (:withheld
                             (unless (eq absence-state :withheld)
                               (signal-kernel0
                                'standing-inflation
                                :attempt-id attempt-id
                                :failed-invariant
                                "§8.7 [F: MAN-3]: status :withheld requires absence state :withheld")))
                            (:redacted
                             (unless (eq absence-state :redacted)
                               (signal-kernel0
                                'standing-inflation
                                :attempt-id attempt-id
                                :failed-invariant
                                "§8.7 [F: MAN-3]: status :redacted requires absence state :redacted"))))
                          (when parser-id
                            (require-identity parser-id :parser))
                          (when (and (eq status :present-invalid)
                                     (null parser-id))
                            (signal-kernel0
                             'invalidity-parser-missing
                             :attempt-id attempt-id
                             :failed-invariant
                             "§8.5: :present-invalid MUST preserve parser or validator identity"))
                          (cond ((eq status :present-empty)
                                 (unless emptiness-rule-id
                                   (signal-kernel0
                                    'interpretation-procedure-missing
                                    :attempt-id attempt-id
                                    :failed-invariant
                                    "§8.4: :present-empty MUST name an identified emptiness rule appropriate to the manifestation kind"))
                                 (require-identity emptiness-rule-id :procedure))
                                (emptiness-rule-id
                                 (signal-kernel0
                                  'standing-inflation
                                  :attempt-id attempt-id
                                  :failed-invariant
                                  "§8.4: an emptiness-rule identity is lawful if and only if manifestation status is :present-empty")))
                          (%make-manifestation
                           manifestation-id
                           attempt-id
                           (%snapshot-tree kind)
                           status
                           payload-id
                           absence-state
                           parser-id
                           (%snapshot-tree source-boundary)
                           visibility-copy
                           emptiness-rule-id))))))))))))))

(defstruct (causal-claim
            (:constructor %make-causal-claim
                (subject predicate evidence origin validation))
            (:copier nil)
            (:conc-name %causal-claim-))
  (subject nil :read-only t)
  (predicate nil :read-only t)
  (evidence nil :read-only t)
  (origin nil :read-only t)
  (validation nil :read-only t))

(defun causal-claim-subject (claim)
  (%causal-claim-subject claim))

(defun causal-claim-predicate (claim)
  (%causal-claim-predicate claim))

(defun causal-claim-evidence (claim)
  (%snapshot-tree (%causal-claim-evidence claim)))

(defun causal-claim-origin (claim)
  (%causal-claim-origin claim))

(defun causal-claim-validation (claim)
  (%snapshot-tree (%causal-claim-validation claim)))

(defun %validated-causal-claim
    (subject predicate evidence origin validation)
  (require-identity subject :manifestation)
  (unless (keywordp predicate)
    (signal-kernel0
     'standing-inflation
     :failed-invariant
     "§8.9.1 [F: CAU-1]: a causal claim MUST bind a keyword predicate"))
  (let ((evidence-copy
          (%reference-list
           evidence
           "§8.9.1 [F: CAU-1]: a causal claim MUST bind a non-empty list of durable evidence references"
           :non-empty t)))
    (unless (member origin
                    '(:asserted :observed :derived :reconstructed)
                    :test #'eq)
      (signal-kernel0
       'reconstruction-origin-erasure
       :failed-invariant
       "§8.9.1 [F: CAU-1]: causal-claim origin MUST be :asserted, :observed, :derived, or :reconstructed"))
    (unless validation
      (signal-kernel0
       'bare-validation-scope
       :failed-invariant
       "§8.9.1 [F: CAU-1]: a causal claim MUST bind a validation facet"))
    (when (consp validation)
      (unless (%proper-list-p validation)
        (signal-kernel0
         'bare-validation-scope
         :failed-invariant
         "§8.9.1 [F: CAU-1]: a structured causal-claim validation facet MUST be a finite proper list")))
    (%make-causal-claim subject
                        predicate
                        evidence-copy
                        origin
                        (%snapshot-tree validation))))

(defun make-causal-claim (&rest arguments)
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:subject :predicate :evidence :origin :validation)
           'standing-inflation
           "§8.9.1 [F: CAU-1, CAU-2]: a causal claim MUST use exactly the five state-independent bindings; a cause slot on manifestation state is forbidden")))
    (multiple-value-bind (subject subject-supplied-p)
        (%constructor-argument parsed :subject)
      (declare (ignore subject-supplied-p))
      (multiple-value-bind (predicate predicate-supplied-p)
          (%constructor-argument parsed :predicate)
        (declare (ignore predicate-supplied-p))
        (multiple-value-bind (evidence evidence-supplied-p)
            (%constructor-argument parsed :evidence)
          (declare (ignore evidence-supplied-p))
          (multiple-value-bind (origin origin-supplied-p)
              (%constructor-argument parsed :origin)
            (declare (ignore origin-supplied-p))
            (multiple-value-bind (validation validation-supplied-p)
                (%constructor-argument parsed :validation)
              (declare (ignore validation-supplied-p))
              (%validated-causal-claim
               subject predicate evidence origin validation))))))))

(defun revise-causal-claim (claim &rest arguments)
  "Return a new causal claim; never mutate the referenced manifestation.

CAU-2: because both records are immutable and the claim attaches only through
its manifestation identity, diagnosis revision cannot alter manifestation
state, a state-derived fold, or a census class."
  (unless (causal-claim-p claim)
    (signal-kernel0
     'standing-inflation
     :failed-invariant
     "§8.9.1 [F: CAU-2]: only a causal-claim record can undergo claim revision"))
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:predicate :evidence :validation)
           'standing-inflation
           "§8.9.1 [F: CAU-2]: causal revision may replace only predicate, evidence, or validation and MUST NOT alter manifestation state")))
    (multiple-value-bind (predicate predicate-supplied-p)
        (%constructor-argument parsed :predicate)
      (multiple-value-bind (evidence evidence-supplied-p)
          (%constructor-argument parsed :evidence)
        (multiple-value-bind (validation validation-supplied-p)
            (%constructor-argument parsed :validation)
          (%validated-causal-claim
           (%causal-claim-subject claim)
           (if predicate-supplied-p
               predicate
               (%causal-claim-predicate claim))
           (if evidence-supplied-p
               evidence
               (%causal-claim-evidence claim))
           (%causal-claim-origin claim)
           (if validation-supplied-p
               validation
               (%causal-claim-validation claim))))))))
