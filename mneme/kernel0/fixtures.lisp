(in-package #:lisp-plus-kernel0)

;;; Pure, immutable construction fixtures for Kernel /0.  This file is loaded
;;; by KERNEL0-SELFTEST.LISP, not by LOAD.LISP.  Nothing here claims journal
;;; persistence, reconstruction, live authority, adapter behavior, channel
;;; policy enforcement, or publication effects.

(defun %fixture-identity (stem domain suffix)
  (make-identity domain (format nil "~A-~A" stem suffix)))

(defun %fixture-context (stem)
  (list :process (%fixture-identity stem :process "process")
        :operation (%fixture-identity stem :logical-operation "operation")
        :seat (%fixture-identity stem :seat "seat")
        :attempt (%fixture-identity stem :attempt "attempt")
        :effect (%fixture-identity stem :effect "effect-group")))

(defun %fixture-determinate (&optional evidence)
  (make-determinacy :mode :determinate :evidence evidence))

(defun %fixture-outcome
    (context execution manifestation effects interpretation
     &key receipts bounded-unknowns)
  (make-outcome
   :process-id (getf context :process)
   :logical-operation-id (getf context :operation)
   :seat-id (getf context :seat)
   :attempt-id (getf context :attempt)
   :execution execution
   :manifestation manifestation
   :effects effects
   :interpretation interpretation
   :receipts receipts
   :bounded-unknowns bounded-unknowns))

(defun %fixture-manifestation
    (context stem status
     &key payload-id absence-state parser-id emptiness-rule-id kind)
  (make-manifestation
   :manifestation-id
   (%fixture-identity stem :manifestation "manifestation")
   :attempt-id (getf context :attempt)
   :kind (or kind :subject-answer)
   :status status
   :payload-id payload-id
   :absence-state absence-state
   :parser-id parser-id
   :source-boundary :fixture-adapter-boundary
   :visibility nil
   :emptiness-rule-id emptiness-rule-id))

(defun make-call-296-fixture ()
  "Construct the complete lawful §22/R-SYN-1 call-296 outcome.

The architectural four-axis projection is preserved.  The effect axis is
additionally bound to the mandatory §10.8 uncertain-effect record.  Because
§22 omits the alternatives required for its bounded manifestation
determinacy, this pure construction uses the sole named state present in the
projection, :ABSENT-AFTER-COMPLETION, as the minimal non-inventive finite
alternative list."
  (let* ((context (%fixture-context "call-296"))
         (attempt-id
           (%fixture-identity
            "call-296" :attempt "placeholder-attempt-identity"))
         (evidence-id
           (%fixture-identity "call-296" :receipt "bounded-evidence"))
         (reconciliation-procedure
           (%fixture-identity
            "call-296" :procedure "provider-call-reconciliation-v0"))
         (effect-group (getf context :effect))
         (uncertain-effect
           (make-uncertain-effect
            :kind :provider-call
            :attempt attempt-id
            :external-request
            '(:unavailable :reason :request-identity-never-established)
            :possible-effects '(:billed :not-billed)
            :known-facts (list evidence-id)
            :reconciliation-procedure reconciliation-procedure
            :retry-policy :forbidden-without-reconciliation))
         (execution
           (make-execution-axis
            :value :indeterminate
            :determinacy
            (make-determinacy :mode :indeterminate :evidence nil)))
         (manifestation
           (make-manifestation-axis
            :value '(:absent :state :absent-after-completion)
            :determinacy
            (make-determinacy
             :mode :bounded
             :alternatives '(:absent-after-completion)
             :evidence (list evidence-id))
            :evidence (list evidence-id)))
         (effects
           (make-effect-axis
            :value :bounded
            :determinacy
            (make-determinacy
             :mode :bounded
             :alternatives '(:billed :not-billed)
             :evidence (list evidence-id))
            :evidence (list evidence-id)
            :uncertain-effect-ref uncertain-effect
            :effect-group effect-group))
         (interpretation
           (make-interpretation-axis
            :value :not-applicable
            :determinacy (%fixture-determinate))))
    ;; The enclosing outcome uses the fixture attempt identity projected by
    ;; §9.1.  The uncertain-effect carries the deliberately explicit
    ;; placeholder attempt identity requested for the historical call-296
    ;; whose external request identity was never established.
    (setf (getf context :attempt) attempt-id)
    (%fixture-outcome
     context execution manifestation effects interpretation
     :bounded-unknowns '(:external-request-identity-unavailable))))

(defun make-call-296-inline-only-effect-axis ()
  "Plant the unlawful §22 projection-as-complete-effect violation.
This function must signal UNSTRUCTURED-UNCERTAINTY."
  (let ((evidence-id
          (%fixture-identity "call-296-inline" :receipt "evidence")))
    (make-effect-axis
     :value :bounded
     :determinacy
     (make-determinacy
      :mode :bounded
      :alternatives '(:billed :not-billed)
      :evidence (list evidence-id))
     :evidence (list evidence-id)
     :effect-group
     (%fixture-identity "call-296-inline" :effect "effect-group"))))

(defun make-fixture-23-1-untouched-seat ()
  (let* ((context (%fixture-context "fixture-23-1"))
         (determinate (%fixture-determinate)))
    (%fixture-outcome
     context
     (make-execution-axis
      :value :not-attempted :determinacy determinate)
     (make-manifestation-axis
      :value '(:absent :state :never-attempted)
      :determinacy determinate)
     (make-effect-axis
      :value :not-entered
      :determinacy determinate
      :effect-group (getf context :effect))
     (make-interpretation-axis
      :value :not-attempted :determinacy determinate))))

(defun make-fixture-23-2-pre-frontier-refusal ()
  (let* ((context (%fixture-context "fixture-23-2"))
         (determinate (%fixture-determinate)))
    (%fixture-outcome
     context
     (make-execution-axis :value :refused :determinacy determinate)
     (make-manifestation-axis
      :value '(:absent :state :refused-pre-effect)
      :determinacy determinate)
     (make-effect-axis
      :value :not-entered
      :determinacy determinate
      :effect-group (getf context :effect))
     (make-interpretation-axis
      :value :not-applicable :determinacy determinate))))

(defun make-fixture-23-3-completed-present ()
  (let* ((context (%fixture-context "fixture-23-3"))
         (determinate (%fixture-determinate))
         (payload-id
           (%fixture-identity "fixture-23-3" :manifestation "payload"))
         (manifestation
           (%fixture-manifestation
            context "fixture-23-3" :present :payload-id payload-id))
         (procedure-id
           (%fixture-identity "fixture-23-3" :procedure "semantic-v0")))
    (%fixture-outcome
     context
     (make-execution-axis :value :completed :determinacy determinate)
     (make-manifestation-axis
      :value manifestation :determinacy determinate)
     (make-effect-axis
      :value :settled
      :determinacy determinate
      :effect-group (getf context :effect))
     (make-interpretation-axis
      :value :accepted
      :determinacy determinate
      :procedure-id procedure-id))))

(defun make-fixture-23-4-completed-present-empty ()
  (let* ((context (%fixture-context "fixture-23-4"))
         (determinate (%fixture-determinate))
         (payload-id
           (%fixture-identity "fixture-23-4" :manifestation "empty-payload"))
         (emptiness-rule-id
           (%fixture-identity "fixture-23-4" :procedure "emptiness-v0"))
         (semantic-procedure-id
           (%fixture-identity "fixture-23-4" :procedure "semantic-v0"))
         (manifestation
           (%fixture-manifestation
            context
            "fixture-23-4"
            :present-empty
            :payload-id payload-id
            :emptiness-rule-id emptiness-rule-id)))
    (%fixture-outcome
     context
     (make-execution-axis :value :completed :determinacy determinate)
     (make-manifestation-axis
      :value manifestation :determinacy determinate)
     (make-effect-axis
      :value :settled
      :determinacy determinate
      :effect-group (getf context :effect))
     (make-interpretation-axis
      :value :accepted
      :determinacy determinate
      :procedure-id semantic-procedure-id))))

(defun make-fixture-23-5-completed-absent ()
  "Return the outcome and its separate causal claim as two values."
  (let* ((context (%fixture-context "fixture-23-5"))
         (evidence-id
           (%fixture-identity "fixture-23-5" :receipt "cause-evidence"))
         (determinate (%fixture-determinate (list evidence-id)))
         (manifestation
           (%fixture-manifestation
            context
            "fixture-23-5"
            :absent
            :absence-state :absent-after-completion))
         (outcome
           (%fixture-outcome
            context
            (make-execution-axis
             :value :completed :determinacy determinate)
            (make-manifestation-axis
             :value manifestation :determinacy determinate)
            (make-effect-axis
             :value :settled
             :determinacy determinate
             :effect-group (getf context :effect))
            (make-interpretation-axis
             :value :not-applicable :determinacy determinate)))
         (claim
           (make-causal-claim
            :subject (manifestation-manifestation-id manifestation)
            :predicate :unestablished
            :evidence (list evidence-id)
            :origin :asserted
            :validation '(:unchecked :fixture-only))))
    (values outcome claim)))

(defun make-fixture-23-6-present-invalid ()
  (let* ((context (%fixture-context "fixture-23-6"))
         (determinate (%fixture-determinate))
         (payload-id
           (%fixture-identity "fixture-23-6" :manifestation "invalid-payload"))
         (parser-id
           (%fixture-identity "fixture-23-6" :parser "parser-v0"))
         (parser-procedure-id
           (%fixture-identity "fixture-23-6" :procedure "parser-v0"))
         (manifestation
           (%fixture-manifestation
            context
            "fixture-23-6"
            :present-invalid
            :payload-id payload-id
            :parser-id parser-id)))
    (%fixture-outcome
     context
     (make-execution-axis :value :completed :determinacy determinate)
     (make-manifestation-axis
      :value manifestation :determinacy determinate)
     (make-effect-axis
      :value :settled
      :determinacy determinate
      :effect-group (getf context :effect))
     (make-interpretation-axis
      :value :invalid
      :determinacy determinate
      :procedure-id parser-procedure-id))))

(defun make-fixture-23-7-partial-host-death-shape ()
  "Construct only the pre-reconstruction pure shape for §23.7."
  (let* ((context (%fixture-context "fixture-23-7"))
         (determinate (%fixture-determinate))
         (payload-id
           (%fixture-identity "fixture-23-7" :manifestation "partial-payload"))
         (manifestation
           (%fixture-manifestation
            context
            "fixture-23-7"
            :present-partial
            :payload-id payload-id)))
    (%fixture-outcome
     context
     (make-execution-axis
      :value :failed
      :determinacy determinate
      :frontier-qualifier :post-frontier)
     (make-manifestation-axis
      :value manifestation :determinacy determinate)
     (make-effect-axis
      :value :crossed
      :determinacy determinate
      :effect-group (getf context :effect))
     (make-interpretation-axis
      :value :not-applicable :determinacy determinate))))

(defun make-fixture-23-8-authorized-replacement-records ()
  "Return predecessor attempt, replacement attempt, and supersession record."
  (let* ((context (%fixture-context "fixture-23-8"))
         (predecessor-id
           (%fixture-identity "fixture-23-8" :attempt "predecessor"))
         (replacement-id
           (%fixture-identity "fixture-23-8" :attempt "replacement"))
         (supersession
           (make-supersession
            :receipt-id
            (%fixture-identity "fixture-23-8" :receipt "supersession")
            :seat-id (getf context :seat)
            :predecessor-attempt-id predecessor-id
            :superseding-attempt-id replacement-id
            :authorized-by
            (%fixture-identity "fixture-23-8" :claim "authorization")
            :reason :authorized-replacement
            :fresh-exposure-p t
            :precedence-rule :replacement-preferred-when-settled
            :cost-effect-treatment :predecessor-effects-remain-visible
            :residual-unknowns '(:predecessor-standing-preserved)))
         (predecessor
           (make-attempt
            :attempt-id predecessor-id
            :logical-operation-id (getf context :operation)
            :seat-id (getf context :seat)
            :process-id (getf context :process)
            :predecessor-attempts nil
            :machine-configuration-id nil
            :supersession-records nil))
         (replacement
           (make-attempt
            :attempt-id replacement-id
            :logical-operation-id (getf context :operation)
            :seat-id (getf context :seat)
            :process-id (getf context :process)
            :predecessor-attempts (list predecessor-id)
            :machine-configuration-id nil
            :supersession-records (list supersession))))
    (values predecessor replacement supersession)))

(defun make-fixture-23-9-reconstructed-derived-view-claim ()
  "Construct only §23.9's pure claim shape, not journal reconstruction."
  (make-claim
   :claim-id (%fixture-identity "fixture-23-9" :claim "derived-view")
   :content-datum "fixture-23-9 reconstructed derived view"
   :source-ids
   (list (%fixture-identity "fixture-23-9" :receipt "source"))
   :origin :reconstructed
   :validation-records nil
   :integrity-records nil
   :visibility-records nil
   :determinacy (%fixture-determinate)
   :bounded-unknowns nil))

(defun make-fixture-23-11-self-report ()
  (make-claim
   :claim-id (%fixture-identity "fixture-23-11" :claim "self-report")
   :content-datum "fixture process self-report"
   :source-ids nil
   :origin :asserted
   :validation-records nil
   :integrity-records nil
   :visibility-records nil
   :determinacy (%fixture-determinate)
   :bounded-unknowns nil))

(defun make-fixture-23-12-secret-opened-to-invoker ()
  (let ((invoker
          (%fixture-identity "fixture-23-12" :principal "invoker")))
    (values
     (make-exposure-record
      :protected-object-id
      (%fixture-identity "fixture-23-12" :claim "protected-object")
      :exposing-action :secret-open
      :receiving-principals (list invoker)
      :scope '(:fixture :invocation)
      :mode :direct
      :evidence
      (list (%fixture-identity "fixture-23-12" :receipt "evidence"))
      :induced-restrictions '(:not-blind-for-this-object))
     invoker)))
