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
     &key receipts bounded-unknowns interpretation-descriptor)
  ;; K0E-23/K0E-25: MAKE-OUTCOME requires the exact descriptor whenever the
  ;; interpretation axis names a procedure.  NIL is lawful only for an axis with
  ;; no procedure (normally :not-attempted/:not-applicable).  Semantic §23.3/4
  ;; and structural-invalid §23.6 therefore thread real descriptors.
  (make-outcome
   :process-id (getf context :process)
   :logical-operation-id (getf context :operation)
   :seat-id (getf context :seat)
   :attempt-id (getf context :attempt)
   :execution execution
   :manifestation manifestation
   :effects effects
   :interpretation interpretation
   :interpretation-descriptor interpretation-descriptor
   :receipts receipts
   :bounded-unknowns bounded-unknowns))

(defun %fixture-manifestation
    (context stem status
     &key payload-id absence-state parser-id emptiness-rule-id kind
          producer-identity stream-relation
          (adapter-identity
           (%fixture-identity stem :procedure "adapter")))
  "Construct a fixture manifestation under the Errata 0.2 §5 producer/stream law.

PRODUCER-BRANCH RULE (K0E-27): every §23 fixture manifestation carries its
source through the FIXTURE ADAPTER boundary (:source-boundary
:fixture-adapter-boundary), so the lawful default producer branch is
:ADAPTER-IDENTITY.  A caller may instead supply :PRODUCER-IDENTITY to model a
non-AP0 producer (then the adapter default is not passed — exactly one branch is
present).  The kernel checks identity-ness only; AP0 owns adapter value spaces
(AP-G4-3), so the adapter identity uses a durable :procedure-domain identity as
some valid durable identity.  A streamed fixture additionally passes
:STREAM-RELATION."
  (apply #'make-manifestation
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
         :emptiness-rule-id emptiness-rule-id
         (append
          (if producer-identity
              (list :producer-identity producer-identity)
              (list :adapter-identity adapter-identity))
          (when stream-relation
            (list :stream-relation stream-relation)))))

(defun call-296-historical-projection ()
  "Return the byte-identical §22/A0.1 call-296 four-axis projection AS DATA.

Errata 0.2 K0E-5/K0E-5a/K0E-6/K0E-7.  This is a NON-CONSTRUCTIBLE specification
projection, STAYED under K0E-5a.  It is PRESERVED AS DATA — a quoted datum of
the exact §22 bytes — and is deliberately NEVER constructed: this function calls
neither MAKE-OUTCOME nor MAKE-DETERMINACY.  Its manifestation axis declares
:bounded determinacy while §22/Architecture 0.1 §15.2 name no second complete
alternative, and the missing alternative is UNNAMEABLE under the closed
absence-state vocabulary without a payload identity (K0E-7,
:ABSENCE-STATE-NAME-PRESUPPOSES-COMPLETION).

Under K0E-5 the missing manifestation alternatives MUST NOT be repaired by a
bare atom or a singleton such as ((:absent :state :absent-after-completion));
supplying singleton alternatives to construct this projection is FORBIDDEN.  The
complete call-296 outcome remains non-constructible until a sealed owner/evidence
act (K0E-5, four routes).  The old singleton-constructing pure-core fixture is
DELETED; its historical evidence lives in git history and the pre-erratum
kernel0/README.  During the stay, the synthetic K0E-6 fixture
(MAKE-SYNTHETIC-BOUNDED-MANIFESTATION-FIXTURE) discharges the algebra-coverage
intent of the row.

Returns two values: (1) the quoted four-axis §22 projection form, and (2) the
K0E-7 bounded-unknown marker :ABSENCE-STATE-NAME-PRESUPPOSES-COMPLETION.  The one
non-literal rendering: §22 writes the manifestation evidence as the documentation
ellipsis `(...)`, which is not a readable Common Lisp token (a bare all-dots
token is illegal), so it is rendered here as the placeholder keyword :ELIDED —
the ellipsis was never literal bytes but an elision marker, and this preserves
its meaning as a datum."
  (values
   '((:execution
      (:value :indeterminate
       :determinacy :indeterminate))
     (:manifestation
      (:value (:absent :state :absent-after-completion)
       :determinacy :bounded
       :evidence :elided))
     (:effects
      (:value :bounded
       :determinacy :bounded
       :alternatives (:billed :not-billed)))
     (:interpretation
      (:value :not-applicable
       :determinacy :determinate)))
   :absence-state-name-presupposes-completion))

(defun make-synthetic-bounded-manifestation-fixture ()
  "Construct the SYNTHETIC K0E-6 bounded-manifestation outcome — GREEN.

SYNTHETIC PROVENANCE: this fixture asserts NOTHING about call-296 or any live
record.  It exists solely to discharge, during the K0E-5a stay, the
algebra-coverage intent of the stayed §22 call-296 row: a complete four-axis
outcome whose MANIFESTATION axis carries :BOUNDED determinacy over AT LEAST TWO
COMPLETE, distinct alternatives with synthetic evidence.  Every evidence and
procedure identity below is explicitly named synthetic-*.

The two manifestation alternatives are complete (:absent :state <s>) forms whose
states both inhabit the §8.7 :absent status/state mapping
({:never-attempted :refused-pre-effect :absent-after-completion :not-applicable})
— one axis-value space — so the asserted current value
(:absent :state :absent-after-completion) is a member of the alternatives
(K0E-3).  Unlike call-296, this is fully constructible because its second
alternative is a real, nameable synthetic value rather than the unnameable
uncertain-write completion presupposition of K0E-7.  Execution is :indeterminate
and the effect axis carries a structured §10.8 uncertain-effect, mirroring the
stayed row's algebra everywhere except the manifestation cardinality that made
it non-constructible."
  (let* ((context (%fixture-context "synthetic-bounded-manifestation"))
         (attempt-id
           (%fixture-identity
            "synthetic-bounded-manifestation"
            :attempt "synthetic-placeholder-attempt-identity"))
         (evidence-id
           (%fixture-identity
            "synthetic-bounded-manifestation" :receipt "synthetic-evidence"))
         (reconciliation-procedure
           (%fixture-identity
            "synthetic-bounded-manifestation"
            :procedure "synthetic-reconciliation-v0"))
         (effect-group (getf context :effect))
         (uncertain-effect
           (make-uncertain-effect
            :kind :provider-call
            :attempt attempt-id
            :external-request
            '(:unavailable :reason :synthetic-request-identity)
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
             ;; K0E-6: at least two COMPLETE, distinct alternatives, both in the
             ;; §8.7 :absent status/state value space (K0E-1 complete-value,
             ;; K0E-3 membership of the current value).
             :alternatives '((:absent :state :absent-after-completion)
                             (:absent :state :refused-pre-effect))
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
    (setf (getf context :attempt) attempt-id)
    (%fixture-outcome
     context execution manifestation effects interpretation
     :bounded-unknowns '(:synthetic-bounded-manifestation-coverage-only))))

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
           (%fixture-identity "fixture-23-3" :procedure "semantic-v0"))
         ;; B1 [K0E-25]: the semantic procedure descriptor this :accepted
         ;; interpretation is judged under.  Version is the closed canonical
         ;; INTEGER 0 (B2); the input-domain admits this fixture's :subject-answer
         ;; manifestation kind at :present status; no evidence is required (the
         ;; axis carries none), so :evidence-requirements is NIL.
         (descriptor
           (make-procedure-descriptor
            :procedure-id procedure-id :version 0 :judgment-class :semantic
            :input-domain (list :kinds '(:subject-answer) :statuses '(:present))
            :result-vocabulary '(:accepted :rejected :invalid)
            :evidence-requirements nil)))
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
      :procedure-id procedure-id
      :procedure-version 0)                 ; rule (o): the cached exact version
     :interpretation-descriptor descriptor)))

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
            :emptiness-rule-id emptiness-rule-id))
         ;; B1 [K0E-25]: identical shape to §23.3's descriptor, but the domain
         ;; :statuses must admit this fixture's :PRESENT-EMPTY manifestation
         ;; status.  Version 0, integer (B2); no evidence required.
         (descriptor
           (make-procedure-descriptor
            :procedure-id semantic-procedure-id :version 0 :judgment-class :semantic
            :input-domain (list :kinds '(:subject-answer)
                                :statuses '(:present-empty))
            :result-vocabulary '(:accepted :rejected :invalid)
            :evidence-requirements nil)))
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
      :procedure-id semantic-procedure-id
      :procedure-version 0)
     :interpretation-descriptor descriptor)))

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
         (parser-descriptor
           (make-procedure-descriptor
            :procedure-id parser-procedure-id
            :version 0
            :judgment-class :structural
            :input-domain nil
            :result-vocabulary '(:invalid)
            :evidence-requirements nil))
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
      :procedure-id parser-procedure-id
      :procedure-version 0
      :judgment-class :structural)
     :interpretation-descriptor parser-descriptor)))

(defun make-fixture-23-7-partial-host-death-shape ()
  "Construct only the pre-reconstruction pure shape for §23.7.

STREAM CHOICE (Errata 0.2 §5, K0E-28/28a/30/31): §23.7 is the partial-then-host-
death shape — a stream interrupted mid-flight — so its manifestation is modeled
as AP0-produced and streamed, carrying a minimal lawful :DIRECT-CHUNK stream
relation over ONE synthetic captured chunk-record identity (a :direct-chunk needs
exactly one chunk and no projection receipt).  This is more faithful than a bare
non-streamed partial and gives the K0E-31 partial-erasure control a real captured
chunk lineage to attempt (and fail) to erase.  FLUMEN's notes advise threading a
producer branch; here the branch is the default :ADAPTER-IDENTITY (streaming is
AP0 territory).  The AP0 chunk value spaces are owned by AP0; the kernel reaches
them by reference and checks identity-ness only."
  (let* ((context (%fixture-context "fixture-23-7"))
         (determinate (%fixture-determinate))
         (payload-id
           (%fixture-identity "fixture-23-7" :manifestation "partial-payload"))
         (manifestation
           (%fixture-manifestation
            context
            "fixture-23-7"
            :present-partial
            :payload-id payload-id
            :stream-relation
            (list :stream-id
                  (%fixture-identity "fixture-23-7" :store "synthetic-stream")
                  :relation-kind :direct-chunk
                  :chunk-record-ids
                  (list (%fixture-identity
                         "fixture-23-7" :store "synthetic-chunk-0"))))))
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
