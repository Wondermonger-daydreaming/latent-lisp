(let ((kernel0-directory
        (make-pathname :name nil :type nil :defaults *load-truename*)))
  (load (merge-pathnames "load.lisp" kernel0-directory))
  (load (merge-pathnames "fixtures.lisp" kernel0-directory)))

(defpackage #:lisp-plus-kernel0-selftest
  (:use #:cl #:lisp-plus-kernel0))

(in-package #:lisp-plus-kernel0-selftest)

(defparameter *implemented-test-numbers*
  ;; Errata 0.2: 43, 44, 47, 48 are now EXECUTABLE (K0E-18..22 claim-standing
  ;; records + scoped queries) and move from excluded to implemented.
  '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 23 26 27 29 31 32 33 34 39
    41 42 43 44 45 46 47 48 49 55))

(defparameter *excluded-tests*
  '((15 . "provider-alias drift is a machine-configuration/live preflight check")
    (16 . "missing capability requires live capability machinery (arc 2)")
    (17 . "revocation requires a live capability and revocation registry (arc 2)")
    (18 . "expiry requires live capability validation (arc 2)")
    (19 . "scope mismatch requires live authority/preflight machinery (arc 2)")
    (20 . "defensive live capability-scope copying belongs to arc 2")
    (21 . "self-restoration is a live-authority operation (arc 2)")
    (22 . "restorer authorization requires live-authority machinery (arc 2)")
    (24 . "restoration-scope enforcement requires live-authority machinery (arc 2)")
    (25 . "blocking live restoration past a frontier requires arc-2/preflight state")
    (28 . "implicit fallback is an adapter/configuration preflight behavior")
    (30 . "provider-enforced idempotency requires the adapter protocol")
    (35 . "torn-tail representation awaits Process-Journal-/0 bytes/framing")
    (36 . "settled-prefix recovery from a torn tail awaits Process-Journal-/0")
    (37 . "durability standing requires a journal store and durability protocol")
    (38 . "cache-versus-prefix precedence requires the journal store/prefix model")
    (40 . "finalizer loss and reconstruction require the journal store")
    (50 . "adapter-version drift requires an adapter/configuration preflight")
    (51 . "mirror-bound channel-policy enforcement is out of scope")
    (52 . "channel-policy amendment authority is out of scope")
    (53 . "publication capability enforcement requires live authority and publication")
    (54 . "private-staging publication-effect behavior requires channel policy/publication")
    (56 . "no adapter/raw-host escape API exists in this pure-core arc")))

;;; Errata 0.2 named exclusions (K0E-5a and the journal/AP0-runtime controls).
;;; Every entry MUST appear, with its requirement id, in the conformance report
;;; (K0E-5a): a report that omits an exclusion or counts a stayed row as passed
;;; is nonconforming evidence.
(defparameter *named-exclusions*
  '(("K0E-5a"
     "call-296 row STAYED pending sealed evidentiary act (K0E-5/K0E-5a); the complete call-296 outcome is NON-CONSTRUCTIBLE under the closed vocabulary (K0E-7, absence-state-name-presupposes-completion); the synthetic K0E-6 fixture discharges the algebra-coverage intent during the stay")
    ("K0E-8/K0E-26"
     "control 10 dual-standing (a semantic-illegal event inside a structurally VALID PJ0 byte prefix reported as dual standing): the PJ0 structural-validity verdict requires Process-Journal-/0 bytes/framing; the Kernel semantic-refusal half is exercised by the identity/fold tests")
    ("K0E-11"
     "control 11 reconstruction-skipping-corruption refused: requires a live journal store, maximal-valid-prefix selection, and reconstruction (Process-Journal-/0)")
    ("K0E-9"
     "control 12 derived-artifact deletion attestation required: requires journal reconstruction and finalizer-product exclusion attestation (Process-Journal-/0)")
    ("K0E-15"
     "control 13 torn tail preserved and capable of bounded standing: requires Process-Journal-/0 torn-tail bytes/framing")
    ("K0E-16"
     "control 14 salvage changes frame identity but preserves abstract events/replay: requires Process-Journal-/0 salvage/merge bytes")
    ("K0E-24/K0E-32"
     "control 24 REMAINDER (streamed-missing-relation): a manifestation that SHOULD have streamed but omitted its relation is NOT kernel-record-detectable (FLUMEN) — it needs AP0 chunk evidence at the AP0/joint layer or validate-stream-relation-coherence fed the attempt's chunk records; the kernel-side constructor refusals (husk/empty-chunk) ARE checked and FIRE (control 24)")
    ;; R4 (hostile review §8): K0E-28a reclassified SCOPED -> NAMED EXCLUSION.
    ("K0E-28a"
     "traversal from manifestation to chunk records requires the AP0 chunk store/joint resolver — ID accessors are reference exposure, not traversal")
    ;; R2 (hostile review 2 §7): the B2 validation-transfer protocol is REPORTED
    ;; as a named exclusion, not merely refused in prose.  The refusal-first
    ;; disposition (any non-NIL license is refused, K0E-21) is sound, so the
    ;; absent typed transfer protocol MUST travel as its own exclusion identity;
    ;; the transfer-license-refused mutant exercises the refusal and is NEVER
    ;; counted as implementing the transfer protocol it refuses.
    ("K0E-21/validation-transfer"
     "typed per-record transfer protocol outside the pure-core sitting; non-NIL license refuses")
    ;; GPT hostile pass 3: an outcome now binds and retains the exact descriptor
    ;; used for its procedure-relative interpretation, but this pure-data arc has
    ;; no journal-backed resolver capable of proving that two independent
    ;; construction acts did not assign divergent descriptor bodies to the same
    ;; procedure-id/version.  Do not mistake local cache-match for global
    ;; uniqueness; the successor fold/journal lane must refuse such divergence.
    ;; [2026-07-19 ARGUS-IV widening]: the residual is BROADER than the original
    ;; per-id/VERSION wording — the kernel also carries procedure-relative
    ;; surfaces whose closed schemas bind NO version and resolve NO descriptor:
    ;; verdicts (K0E-26, a report that grants nothing, version-free by the
    ;; erratum's own text), manifestation parser/emptiness-rule identities
    ;; (value spaces delegated to AP0), and causal-claim predicates (open cause
    ;; level, §8.9.1).  Each is LAWFUL as written; none is descriptor-resolved
    ;; here.  The successor resolver's jurisdiction covers these surfaces too.
    ("K0E-23/global-descriptor-resolution"
     "the exact descriptor is bound and inspectable per outcome; enforcing one globally unique descriptor body per procedure-id/version — and descriptor resolution for the version-free procedure-relative surfaces (K0E-26 verdicts; AP0-delegated parser/emptiness identities; §8.9.1 causal predicates) — requires the successor fold/journal resolver")))

(defvar *passed-tests* nil)
(defvar *failed-tests* nil)
(defvar *negative-controls-fired* nil)
(defvar *negative-controls-failed* nil)
;;; Errata 0.2 §8 controls, planted mutants, and named-exclusion reporting.
(defvar *controls-fired* nil)
(defvar *controls-excluded* nil)
(defvar *controls-failed* nil)
(defvar *mutants-killed* nil)
(defvar *mutants-survived* nil)
(defvar *report-bites-fired* nil)
(defvar *report-bites-failed* nil)

(defun ensure-test (truth control &rest arguments)
  (unless truth
    (error (apply #'format nil control arguments)))
  t)

(defun expect-condition (expected-type thunk &optional invariant-fragment)
  (block expected
    (handler-bind
        ((kernel0-condition
           (lambda (condition)
             (when (typep condition expected-type)
               (when invariant-fragment
                 (ensure-test
                  (search invariant-fragment
                          (kernel0-condition-failed-invariant condition)
                          :test #'char-equal)
                  "~A did not mention expected invariant fragment ~S: ~A"
                  expected-type
                  invariant-fragment
                  (kernel0-condition-failed-invariant condition)))
               (return-from expected condition)))))
      (funcall thunk))
    (error "planted violation did not signal ~A" expected-type)))

(defun expect-condition-req (expected-type expected-req thunk &optional invariant-fragment)
  "Like EXPECT-CONDITION, but ALSO assert the fired condition's REQUIREMENT-ID
equals EXPECTED-REQ.  A planted defect counts as caught for the INTENDED
requirement only when both the condition type and the errata requirement id
match (Errata 0.2 §8 control 29).  Returns the condition."
  (let ((condition (expect-condition expected-type thunk invariant-fragment)))
    (ensure-test
     (equal expected-req (kernel0-condition-requirement-id condition))
     "~A fired but requirement-id was ~S, not the intended ~S"
     expected-type (kernel0-condition-requirement-id condition) expected-req)
    condition))

(defmacro run-test ((number description) &body body)
  `(handler-case
       (progn
         ,@body
         (push ,number *passed-tests*)
         (format t "TEST ~2,'0D ~A: PASS~%" ,number ,description))
     (condition (condition)
       (push (cons ,number condition) *failed-tests*)
       (format t "TEST ~2,'0D ~A: FAIL (~A)~%"
               ,number ,description condition))))

(defun fixture-axis (outcome name)
  (outcome-axis outcome name))

(defun fixture-manifestation (outcome)
  (axis-value (fixture-axis outcome :manifestation)))

(defun make-test-context (stem)
  (list :process (make-identity :process (format nil "~A-process" stem))
        :operation
        (make-identity :logical-operation (format nil "~A-operation" stem))
        :seat (make-identity :seat (format nil "~A-seat" stem))
        :attempt (make-identity :attempt (format nil "~A-attempt" stem))
        :effect (make-identity :effect (format nil "~A-effect" stem))))

(defun make-test-attempt (context attempt-id &key predecessors supersessions)
  (make-attempt
   :attempt-id attempt-id
   :logical-operation-id (getf context :operation)
   :seat-id (getf context :seat)
   :process-id (getf context :process)
   :predecessor-attempts predecessors
   :machine-configuration-id nil
   :supersession-records supersessions))

(defun make-reconciliation-scenario ()
  (let* ((context (make-test-context "reconciliation"))
         (attempt-id (getf context :attempt))
         (retry-attempt-id
           (make-identity :attempt "reconciliation-retry-attempt"))
         (effect-id (getf context :effect))
         (evidence-id
           (make-identity :receipt "reconciliation-new-evidence"))
         (procedure-id
           (make-identity :procedure "reconciliation-procedure-v0"))
         (uncertain-effect
           (make-uncertain-effect
            :kind :provider-call
            :attempt attempt-id
            :external-request '(:unavailable :reason :fixture-no-request-id)
            :possible-effects '(:billed :not-billed)
            :known-facts (list evidence-id)
            :reconciliation-procedure procedure-id
            :retry-policy :forbidden-without-reconciliation))
         (bounded-axis
           (make-effect-axis
            :value :bounded
            :determinacy
            (make-determinacy
             :mode :bounded
             :alternatives '(:billed :not-billed)
             :evidence (list evidence-id))
            :evidence (list evidence-id)
            :uncertain-effect-ref uncertain-effect
            :effect-group effect-id))
         (settled-axis
           (make-effect-axis
            :value :settled
            :determinacy
            (make-determinacy
             :mode :determinate :evidence (list evidence-id))
            :evidence (list evidence-id)
            :effect-group effect-id))
         (receipt
           (make-reconciliation-receipt
            :target-attempt-id attempt-id
            :procedure-id procedure-id
            :procedure-version 0
            :new-evidence (list evidence-id)
            :previous-axis-values+determinacy (list :effects bounded-axis)
            :resulting-axis-values+determinacy (list :effects settled-axis)
            :unresolved-residue nil))
         (base-events
           (list
            (make-kernel0-event
             :event-type :seat-reserved
             :process-id (getf context :process)
             :logical-operation-id (getf context :operation)
             :seat-id (getf context :seat))
            (make-kernel0-event
             :event-type :attempt-begun
             :process-id (getf context :process)
             :logical-operation-id (getf context :operation)
             :seat-id (getf context :seat)
             :attempt-id attempt-id)
            (make-kernel0-event
             :event-type :effect-prepared
             :process-id (getf context :process)
             :seat-id (getf context :seat)
             :attempt-id attempt-id
             :effect-id effect-id)
            (make-kernel0-event
             :event-type :frontier-crossed
             :process-id (getf context :process)
             :seat-id (getf context :seat)
             :attempt-id attempt-id
             :effect-id effect-id)
            (make-kernel0-event
             :event-type :effect-bounded
             :process-id (getf context :process)
             :seat-id (getf context :seat)
             :attempt-id attempt-id
             :effect-id effect-id
             :payload
             (list :uncertain-effect uncertain-effect
                   :axis-values+determinacy (list :effects bounded-axis)))
            (make-kernel0-event
             :event-type :attempt-failed
             :process-id (getf context :process)
             :seat-id (getf context :seat)
             :attempt-id attempt-id)))
         (reconciliation-event
           (make-kernel0-event
            :event-type :attempt-reconciled
            :process-id (getf context :process)
            :seat-id (getf context :seat)
            :attempt-id attempt-id
            :payload (list :reconciliation-receipt receipt)))
         (retry-event
           (make-kernel0-event
            :event-type :attempt-begun
            :process-id (getf context :process)
            :logical-operation-id (getf context :operation)
            :seat-id (getf context :seat)
            :attempt-id retry-attempt-id)))
    (list :context context
          :attempt-id attempt-id
          :retry-attempt-id retry-attempt-id
          :bounded-axis bounded-axis
          :settled-axis settled-axis
          :receipt receipt
          :base-events base-events
          :reconciliation-event reconciliation-event
          :retry-event retry-event)))

(defun make-test-claim (stem origin)
  (make-claim
   :claim-id (make-identity :claim (format nil "~A-claim" stem))
   :content-datum (format nil "~A content" stem)
   :source-ids nil
   :origin origin
   :validation-records nil
   :integrity-records nil
   :visibility-records nil
   :determinacy (make-determinacy :mode :determinate :evidence nil)
   :bounded-unknowns nil))

(defun make-empty-exposure-violation ()
  (make-exposure-record
   :protected-object-id (make-identity :claim "empty-exposure-object")
   :exposing-action :secret-open
   :receiving-principals nil
   :scope '(:selftest)
   :mode :direct
   :evidence nil
   :induced-restrictions nil))

(defun make-global-uncertainty-violation ()
  (let ((outcome (lisp-plus-kernel0::make-fixture-23-1-untouched-seat)))
    (make-outcome
     :process-id (outcome-process-id outcome)
     :logical-operation-id (outcome-logical-operation-id outcome)
     :seat-id (outcome-seat-id outcome)
     :attempt-id (outcome-attempt-id outcome)
     :execution (outcome-axis outcome :execution)
     :manifestation (outcome-axis outcome :manifestation)
     :effects (outcome-axis outcome :effects)
     :interpretation (outcome-axis outcome :interpretation)
     :confidence :collapsed)))

(defun run-fixture-tests ()
  (run-test (1 "completed execution with absent manifestation")
    (multiple-value-bind (outcome causal-claim)
        (lisp-plus-kernel0::make-fixture-23-5-completed-absent)
      (let ((manifestation (fixture-manifestation outcome)))
        (ensure-test (eq :completed
                         (axis-value (fixture-axis outcome :execution)))
                     "execution was not completed")
        (ensure-test (and (manifestation-p manifestation)
                          (eq :absent (manifestation-status manifestation))
                          (eq :absent-after-completion
                              (manifestation-absence-state manifestation)))
                     "completed-absent manifestation shape was lost")
        (ensure-test (causal-claim-p causal-claim)
                     "absence explanation was not a separate causal claim"))))

  (run-test (2 "present envelope distinct from absent subject")
    (let* ((context (make-test-context "envelope-subject"))
           (envelope
             (make-manifestation
              :manifestation-id
              (make-identity :manifestation "envelope-manifestation")
              :attempt-id (getf context :attempt)
              :kind :provider-envelope
              :status :present
              :payload-id
              (make-identity :manifestation "envelope-payload")
              ;; K0E-27: source is the fixture adapter boundary → :adapter-identity.
              :adapter-identity (make-identity :procedure "test-2-adapter")
              :source-boundary :fixture-adapter-boundary))
           (subject
             (make-manifestation
              :manifestation-id
              (make-identity :manifestation "subject-manifestation")
              :attempt-id (getf context :attempt)
              :kind :subject-answer
              :status :absent
              :absence-state :absent-after-completion
              :adapter-identity (make-identity :procedure "test-2-adapter")
              :source-boundary :fixture-adapter-boundary)))
      (ensure-test (and (eq :present (manifestation-status envelope))
                        (eq :absent (manifestation-status subject))
                        (not (identity=
                              (manifestation-manifestation-id envelope)
                              (manifestation-manifestation-id subject))))
                   "envelope and subject manifestation records collapsed")))

  (run-test (3 "present-empty payload identity preserved")
    (let* ((outcome
             (lisp-plus-kernel0::make-fixture-23-4-completed-present-empty))
           (manifestation (fixture-manifestation outcome)))
      (ensure-test
       (and (eq :present-empty (manifestation-status manifestation))
            (durable-identity-p (manifestation-payload-id manifestation))
            (durable-identity-p
             (manifestation-emptiness-rule-id manifestation)))
       "present-empty lost payload or emptiness-rule identity")))

  (run-test (4 "present-invalid payload and parser identity preserved")
    (let* ((outcome
             (lisp-plus-kernel0::make-fixture-23-6-present-invalid))
           (manifestation (fixture-manifestation outcome)))
      (ensure-test
       (and (eq :present-invalid (manifestation-status manifestation))
            (durable-identity-p (manifestation-payload-id manifestation))
            (eq :parser
                (durable-identity-domain
                 (manifestation-parser-id manifestation))))
       "present-invalid lost payload or parser identity")))

  (run-test (5 "present-partial retained in interruption shape")
    (let* ((outcome
             (lisp-plus-kernel0::make-fixture-23-7-partial-host-death-shape))
           (manifestation (fixture-manifestation outcome)))
      (ensure-test
       (and (eq :failed (axis-value (fixture-axis outcome :execution)))
            (eq :post-frontier
                (axis-frontier-qualifier
                 (fixture-axis outcome :execution)))
            (eq :present-partial (manifestation-status manifestation))
            (durable-identity-p (manifestation-payload-id manifestation)))
       "pure post-interruption shape erased the partial manifestation")))

  (run-test (6 "four axes vary independently")
    ;; K0E-5a: the call-296 row is STAYED, so the synthetic K0E-6
    ;; bounded-manifestation fixture stands in for its algebra coverage.
    (let ((untouched
            (lisp-plus-kernel0::make-fixture-23-1-untouched-seat))
          (present
            (lisp-plus-kernel0::make-fixture-23-3-completed-present))
          (partial
            (lisp-plus-kernel0::make-fixture-23-7-partial-host-death-shape))
          (synthetic
            (lisp-plus-kernel0::make-synthetic-bounded-manifestation-fixture)))
      (ensure-test
       (and (eq :not-attempted
                (axis-value (fixture-axis untouched :execution)))
            (eq :accepted
                (axis-value (fixture-axis present :interpretation)))
            (eq :present-partial
                (manifestation-status (fixture-manifestation partial)))
            (eq :indeterminate
                (axis-value (fixture-axis synthetic :execution)))
            (eq :bounded (axis-value (fixture-axis synthetic :effects)))
            (eq :bounded
                (determinacy-mode
                 (axis-determinacy (fixture-axis synthetic :manifestation))))
            (eq :not-applicable
                (axis-value (fixture-axis synthetic :interpretation))))
       "lawful independent combinations did not remain distinct (K0E-6 synthetic fixture)")))

  (run-test (7 "bounded effect requires structured uncertain-effect")
    ;; K0E-5a/K0E-6: the synthetic bounded-manifestation fixture carries the
    ;; stayed row's algebra — a :bounded manifestation with ≥2 complete
    ;; alternatives AND a structured §10.8 uncertain-effect on the bounded
    ;; effect axis.  The R-SYN-1 inline-only twin still fires
    ;; unstructured-uncertainty.
    (let* ((outcome
             (lisp-plus-kernel0::make-synthetic-bounded-manifestation-fixture))
           (execution (fixture-axis outcome :execution))
           (manifestation (fixture-axis outcome :manifestation))
           (effects (fixture-axis outcome :effects))
           (interpretation (fixture-axis outcome :interpretation))
           (uncertainty (axis-uncertain-effect-ref effects)))
      (ensure-test
       (and (outcome-p outcome)
            (eq :indeterminate (axis-value execution))
            (eq :indeterminate
                (determinacy-mode (axis-determinacy execution)))
            (equal '(:absent :state :absent-after-completion)
                   (axis-value manifestation))
            (eq :bounded
                (determinacy-mode (axis-determinacy manifestation)))
            ;; K0E-6: at least two complete alternatives on the bounded
            ;; manifestation determinacy.
            (= 2 (length
                  (determinacy-alternatives
                   (axis-determinacy manifestation))))
            (consp (axis-evidence manifestation))
            (eq :bounded (axis-value effects))
            (equal '(:billed :not-billed)
                   (determinacy-alternatives (axis-determinacy effects)))
            (uncertain-effect-p uncertainty)
            (eq :provider-call (uncertain-effect-kind uncertainty))
            (equal '(:billed :not-billed)
                   (uncertain-effect-possible-effects uncertainty))
            (consp (uncertain-effect-known-facts uncertainty))
            (eq :forbidden-without-reconciliation
                (uncertain-effect-retry-policy uncertainty))
            (eq :not-applicable (axis-value interpretation))
            (eq :determinate
                (determinacy-mode (axis-determinacy interpretation))))
       "synthetic bounded-manifestation fixture did not match the lawful §10.8/K0E-6 construction")
      (expect-condition
       'unstructured-uncertainty
       #'lisp-plus-kernel0::make-call-296-inline-only-effect-axis
       "inline alternatives/evidence alone are unlawful")))

  (run-test (8 "global uncertainty field rejected")
    ;; FERRUM retype (K0E-33): the outcome-level :confidence scalar now signals
    ;; the dedicated GLOBAL-UNCERTAINTY-SCALAR-REJECTED, not the generic
    ;; STANDING-INFLATION.
    (expect-condition-req
     'global-uncertainty-scalar-rejected
     "K0E-33"
     #'make-global-uncertainty-violation
     "confidence, uncertainty, or probability scalar")))

(defun run-identity-tests ()
  (run-test (9 "duplicate process identity refused")
    (let ((process-id (make-identity :process "test-9-process")))
      (expect-condition
       'duplicate-process-identity
       (lambda ()
         (validate-event-sequence
          (list
           (make-kernel0-event
            :event-type :process-created :process-id process-id)
           (make-kernel0-event
            :event-type :process-created :process-id process-id)))))))

  (run-test (10 "duplicate attempt identity refused")
    (let* ((context (make-test-context "test-10"))
           (reserve
             (make-kernel0-event
              :event-type :seat-reserved
              :seat-id (getf context :seat))))
      (expect-condition
       'duplicate-attempt-identity
       (lambda ()
         (validate-event-sequence
          (list
           reserve
           (make-kernel0-event
            :event-type :attempt-begun
            :seat-id (getf context :seat)
            :attempt-id (getf context :attempt))
           (make-kernel0-event
            :event-type :attempt-begun
            :seat-id (getf context :seat)
            :attempt-id (getf context :attempt))))))))

  (run-test (11 "occupied seat detected")
    (let* ((context (make-test-context "test-11"))
           (second-attempt
             (make-identity :attempt "test-11-second-attempt")))
      (expect-condition
       'seat-occupied
       (lambda ()
         (validate-event-sequence
          (list
           (make-kernel0-event
            :event-type :seat-reserved :seat-id (getf context :seat))
           (make-kernel0-event
            :event-type :attempt-begun
            :seat-id (getf context :seat)
            :attempt-id (getf context :attempt))
           (make-kernel0-event
            :event-type :attempt-completed
            :seat-id (getf context :seat)
            :attempt-id (getf context :attempt))
           (make-kernel0-event
            :event-type :attempt-begun
            :seat-id (getf context :seat)
            :attempt-id second-attempt)))))))

  (run-test (12 "external request identity collision detected")
    (let* ((context (make-test-context "test-12"))
           (seat-b (make-identity :seat "test-12-seat-b"))
           (attempt-b (make-identity :attempt "test-12-attempt-b"))
           (request
             (make-identity :external-request "test-12-shared-request")))
      (expect-condition
       'duplicate-external-request-identity
       (lambda ()
         (validate-event-sequence
          (list
           (make-kernel0-event
            :event-type :seat-reserved :seat-id (getf context :seat))
           (make-kernel0-event
            :event-type :seat-reserved :seat-id seat-b)
           (make-kernel0-event
            :event-type :attempt-begun
            :seat-id (getf context :seat)
            :attempt-id (getf context :attempt)
            :external-request-id request)
           (make-kernel0-event
            :event-type :attempt-begun
            :seat-id seat-b
            :attempt-id attempt-b
            :external-request-id request)))))))

  (run-test (13 "supersession requires new attempt identity")
    (let* ((context (make-test-context "test-13"))
           (attempt-id (getf context :attempt)))
      (expect-condition
       'duplicate-attempt-identity
       (lambda ()
         (make-supersession
          :receipt-id (make-identity :receipt "test-13-receipt")
          :seat-id (getf context :seat)
          :predecessor-attempt-id attempt-id
          :superseding-attempt-id attempt-id
          :authorized-by (make-identity :claim "test-13-authority")
          :reason :planted-duplicate
          :fresh-exposure-p t
          :precedence-rule :newer-if-lawful
          :cost-effect-treatment :preserve-both
          :residual-unknowns nil)))))

  (run-test (14 "supersession cannot erase predecessor")
    (multiple-value-bind (predecessor replacement supersession)
        (lisp-plus-kernel0::make-fixture-23-8-authorized-replacement-records)
      (let* ((predecessor-id (attempt-attempt-id predecessor))
             (replacement-id (attempt-attempt-id replacement))
             (seat-id (attempt-seat-id predecessor))
             (events
               (list
                (make-kernel0-event
                 :event-type :seat-reserved :seat-id seat-id)
                (make-kernel0-event
                 :event-type :attempt-begun
                 :seat-id seat-id
                 :attempt-id predecessor-id
                 :payload (list :attempt predecessor))
                (make-kernel0-event
                 :event-type :attempt-superseded
                 :seat-id seat-id
                 :attempt-id predecessor-id
                 :payload (list :supersession supersession))))
             (standing (fold-attempt-outcome events predecessor-id)))
        (ensure-test
         (and (eq :superseded
                  (attempt-outcome-standing-terminal-class standing))
              (equalp (list predecessor-id replacement-id)
                      (attempt-outcome-standing-supersession-lineage
                       standing))
              (identity=
               predecessor-id
               (supersession-predecessor-attempt-id supersession)))
         "supersession fold failed to retain predecessor lineage")))))

(defun run-authority-data-test ()
  (run-test (23 "restoration creates new identity (pure-data half)")
    (let* ((old (make-identity :capability "test-23-old-capability"))
           (new (make-identity :capability "test-23-new-capability"))
           (receipt
             (make-capability-restoration-receipt
              :receipt-id (make-identity :receipt "test-23-receipt")
              :predecessor-capability-id old
              :new-capability-id new
              :restored-by (make-identity :principal "test-23-restorer")
              :authority-basis (make-identity :claim "test-23-authority")
              :revocation-check '(:checked :not-revoked)
              :unresolved-effect-check '(:checked :none)
              :old-scope '(:effect :provider-call)
              :new-scope '(:effect :provider-call))))
      (ensure-test
       (and (capability-restoration-receipt-p receipt)
            (not (identity= old new))
            (identity=
             new
             (capability-restoration-receipt-new-capability-id receipt)))
       "restoration receipt did not retain the distinct new identity")
      (expect-condition
       'capability-restoration-denied
       (lambda ()
         (make-capability-restoration-receipt
          :receipt-id (make-identity :receipt "test-23-bad-receipt")
          :predecessor-capability-id old
          :new-capability-id old
          :restored-by (make-identity :principal "test-23-restorer")
          :authority-basis (make-identity :claim "test-23-authority")
          :revocation-check '(:checked :not-revoked)
          :unresolved-effect-check '(:checked :none)
          :old-scope '(:effect :provider-call)
          :new-scope '(:effect :provider-call)))))))

(defun run-effect-tests ()
  (run-test (26 "refusal is pre-frontier with zero effect")
    (let ((outcome
            (lisp-plus-kernel0::make-fixture-23-2-pre-frontier-refusal)))
      (ensure-test
       (and (eq :refused (axis-value (fixture-axis outcome :execution)))
            (eq :not-entered (axis-value (fixture-axis outcome :effects))))
       "lawful refusal did not retain zero effect")
      (expect-condition
       'frontier-precondition-failed
       (lambda ()
         (make-outcome
          :process-id (outcome-process-id outcome)
          :logical-operation-id (outcome-logical-operation-id outcome)
          :seat-id (outcome-seat-id outcome)
          :attempt-id (outcome-attempt-id outcome)
          :execution (outcome-axis outcome :execution)
          :manifestation (outcome-axis outcome :manifestation)
          :effects
          (make-effect-axis
           :value :crossed
           :determinacy
           (make-determinacy :mode :determinate :evidence nil)
           :effect-group (make-identity :effect "test-26-crossed-effect"))
          :interpretation (outcome-axis outcome :interpretation))))
      (expect-condition
       'frontier-already-crossed
       (lambda ()
         (make-execution-axis
          :value :refused
          :determinacy
          (make-determinacy :mode :determinate :evidence nil)
          :frontier-qualifier :post-frontier)))))

  (run-test (27 "post-frontier failure is not refusal")
    (let ((outcome
            (lisp-plus-kernel0::make-fixture-23-7-partial-host-death-shape)))
      (ensure-test
       (and (eq :failed (axis-value (fixture-axis outcome :execution)))
            (eq :post-frontier
                (axis-frontier-qualifier
                 (fixture-axis outcome :execution))))
       "lawful post-frontier failure was not constructible")
      (expect-condition
       'frontier-already-crossed
       (lambda ()
         (make-execution-axis
          :value :refused
          :determinacy
          (make-determinacy :mode :determinate :evidence nil)
          :frontier-qualifier :post-frontier)))))

  (run-test (29 "blind retry across bounded effect refused")
    (let* ((scenario (make-reconciliation-scenario))
           (events
             (append (getf scenario :base-events)
                     (list (getf scenario :retry-event)))))
      (expect-condition
       'unsafe-retry
       (lambda ()
         (check-retry-safety events
                             (getf (getf scenario :context) :seat)))
       "new attempt MUST NOT begin")))

  (run-test (31 "reconciliation narrows without rewriting")
    (let* ((scenario (make-reconciliation-scenario))
           (events
             (append
              (getf scenario :base-events)
              (list (getf scenario :reconciliation-event))))
           (standing
             (fold-attempt-outcome events (getf scenario :attempt-id)))
           (original
             (getf
              (attempt-outcome-standing-original-axis-values+determinacy
               standing)
              :effects))
           (current
             (getf
              (attempt-outcome-standing-current-axis-values+determinacy
               standing)
              :effects)))
      (ensure-test
       (and (eq :bounded (axis-value original))
            (eq :settled (axis-value current))
            (eq :bounded (axis-value (getf scenario :bounded-axis)))
            (= 1
               (length
                (attempt-outcome-standing-reconciliation-receipts
                 standing)))
            (not
             (attempt-outcome-standing-unresolved-effect-p standing)))
       "reconciliation rewrote history or failed to narrow current standing")))

  (run-test (32 "secret-open missing principal refused")
    (expect-condition
     'exposed-principal-missing
     #'make-empty-exposure-violation
     "without at least one named receiving principal"))

  (run-test (33 "self-invocation marks invoker exposed")
    (multiple-value-bind (record invoker)
        (lisp-plus-kernel0::make-fixture-23-12-secret-opened-to-invoker)
      (let* ((event
               (make-kernel0-event
                :event-type :manifestation-recorded
                :payload (list :exposure-record record)))
             (principals (fold-exposure-principals (list event))))
        (ensure-test
         (and (= 1 (length principals))
              (identity= invoker (first principals)))
         "invoker was omitted from exposed-principal fold")))))

(defun run-store-fold-tests ()
  (run-test (34 "deterministic fold over valid prefix")
    (let* ((scenario (make-reconciliation-scenario))
           (events (getf scenario :base-events))
           (seat-id (getf (getf scenario :context) :seat))
           (first-result (fold-seat-occupancy events seat-id))
           (hash-a (make-hash-table :test #'equal))
           (hash-b (make-hash-table :test #'equal)))
      (setf (gethash "a" hash-a) 1
            (gethash "b" hash-a) 2
            (gethash "b" hash-b) 2
            (gethash "a" hash-b) 1)
      (ensure-test
       (= (hash-table-count hash-a) (hash-table-count hash-b))
       "unrelated hash fixtures were not comparable")
      (let ((second-result (fold-seat-occupancy events seat-id)))
        (ensure-test
         (and (equalp first-result second-result)
              (eq :unresolved (first first-result)))
         "same immutable event prefix produced different fold results"))))

  (run-test (39 "cross-sequence merge without receipt refused")
    (expect-condition
     'journal-merge-receipt-required
     (lambda () (merge-event-sequences nil nil))
     "without an explicit transformation receipt"))

  (run-test (41 "reconstruction preserves origin")
    ;; K0E-18: revalidation now appends a CONSTRUCTED validation record, not an
    ;; opaque list (which the typed-record invariant rejects).
    (let* ((claim
             (lisp-plus-kernel0::make-fixture-23-9-reconstructed-derived-view-claim))
           (validation
             (make-validation-record
              :status :checked
              :subject-id (claim-claim-id claim)
              :validator-principal-id
              (make-identity :principal "fixture-validator")
              :procedure-id (make-identity :procedure "fixture-validation-v0")
              :procedure-version 0
              :scope '(:fixture :reconstruction)))
           (revalidated (revalidate-claim claim validation)))
      (ensure-test
       (and (eq :reconstructed (claim-origin claim))
            (eq :reconstructed (claim-origin revalidated))
            (= 1 (length (claim-validation-records revalidated))))
       "revalidation erased reconstructed origin"))))

(defun run-claim-standing-tests ()
  (run-test (42 "asserted self-report cannot become observed")
    (let ((claim (lisp-plus-kernel0::make-fixture-23-11-self-report)))
      (ensure-test (eq :asserted (claim-origin claim))
                   "self-report did not begin asserted")
      (expect-condition
       'standing-inflation
       (lambda () (promote-origin claim :observed))
       "asserted→observed")))

  (run-test (45 "parser validity does not imply semantic acceptance")
    (let* ((invalid-outcome
             (lisp-plus-kernel0::make-fixture-23-6-present-invalid))
           (invalid-manifestation
             (fixture-manifestation invalid-outcome)))
      (ensure-test
       (and (eq :present-invalid
                (manifestation-status invalid-manifestation))
            (eq :invalid
                (axis-value
                 (fixture-axis invalid-outcome :interpretation)))
            (durable-identity-p
             (axis-procedure-id
              (fixture-axis invalid-outcome :interpretation)))
            (eql 0
                 (axis-procedure-version
                  (fixture-axis invalid-outcome :interpretation)))
            (procedure-descriptor-p
             (outcome-interpretation-descriptor invalid-outcome))
            (eq :structural
                (procedure-descriptor-judgment-class
                 (outcome-interpretation-descriptor invalid-outcome))))
       "invalidity was not payload-preserving and bound to its exact structural descriptor")
      (expect-condition
       'standing-inflation
       (lambda ()
         (make-outcome
          :process-id (outcome-process-id invalid-outcome)
          :logical-operation-id
          (outcome-logical-operation-id invalid-outcome)
          :seat-id (outcome-seat-id invalid-outcome)
          :attempt-id (outcome-attempt-id invalid-outcome)
          :execution (outcome-axis invalid-outcome :execution)
          :manifestation (outcome-axis invalid-outcome :manifestation)
          :effects (outcome-axis invalid-outcome :effects)
          :interpretation
          (make-interpretation-axis
           :value :accepted
           :determinacy
           (make-determinacy :mode :determinate :evidence nil)
           :procedure-id
           (make-identity :procedure "test-45-semantic-procedure")
           :procedure-version 0)))
       ":accepted or :rejected interpretation requires")))

  (run-test (46 "verified reconstruction remains reconstructed")
    ;; K0E-18: a :verified validation record binds all five id/scope fields plus
    ;; non-empty evidence; verification strengthens validation without rewriting
    ;; the historical :reconstructed origin.
    (let* ((claim (make-test-claim "test-46" :reconstructed))
           (verified
             (revalidate-claim
              claim
              (make-validation-record
               :status :verified
               :subject-id (claim-claim-id claim)
               :validator-principal-id
               (make-identity :principal "test-46-validator")
               :procedure-id (make-identity :procedure "test-46-procedure")
               :procedure-version 0
               :scope '(:test-46)
               :evidence (list (make-identity :receipt "test-46-evidence"))))))
      (ensure-test
       (and (eq :reconstructed (claim-origin verified))
            (= 1 (length (claim-validation-records verified))))
       "verification rewrote reconstructed origin"))))

(defun run-standing-record-tests ()
  ;; Errata 0.2 §3 (K0E-18..22): validation / integrity / visibility standing.
  (run-test (43 "seal does not imply verification")
    (let* ((content "test-43 sealed representation")
           (claim-id (make-identity :claim "test-43-claim"))
           (integrity
             (make-integrity-record
              :status :sealed
              :subject-id claim-id
              :representation-id content
              :method-id (make-identity :procedure "test-43-seal-method-v0")
              :method-version 0
              :sealing-principal-id (make-identity :principal "test-43-sealer")
              :evidence (list (make-identity :receipt "test-43-seal-evidence"))))
           (claim
             (make-claim
              :claim-id claim-id
              :content-datum content
              :source-ids nil
              :origin :asserted
              :validation-records nil
              :integrity-records (list integrity)
              :visibility-records nil
              :determinacy (make-determinacy :mode :determinate :evidence nil)
              :bounded-unknowns nil)))
      (ensure-test
       (and (integrity-record-p integrity)
            (eq :sealed (integrity-record-status integrity))
            ;; A seal establishes bytes/chain integrity ONLY; it grants no
            ;; validation standing under any procedure/scope (K0E-19/K0E-21).
            (not (claim-validated-under-p
                  claim
                  (make-identity :procedure "test-43-any-procedure")
                  '(:any-scope))))
       "a sealed integrity record was allowed to imply validation standing")
      ;; Planted sealed→verified promotion mutant: smuggle the seal into the
      ;; validation slot; the K0E-18 type wall kills it.
      (expect-condition-req
       'malformed-constructor-shape "K0E-18"
       (lambda ()
         (make-claim
          :claim-id (make-identity :claim "test-43-mutant-claim")
          :content-datum content
          :source-ids nil
          :origin :asserted
          :validation-records (list integrity)
          :integrity-records nil
          :visibility-records nil
          :determinacy (make-determinacy :mode :determinate :evidence nil)
          :bounded-unknowns nil))
       "constructed validation record")))

  (run-test (44 "publication does not imply truth")
    (let* ((content "test-44 published representation")
           (claim-id (make-identity :claim "test-44-claim"))
           (scope '(:audience :test-44-readers))
           (visibility
             (make-visibility-record
              :status :published
              :subject-id claim-id
              :representation-id content
              :scope-id scope))
           (claim
             (make-claim
              :claim-id claim-id
              :content-datum content
              :source-ids nil
              :origin :asserted
              :validation-records nil
              :integrity-records nil
              :visibility-records (list visibility)
              :determinacy (make-determinacy :mode :determinate :evidence nil)
              :bounded-unknowns nil)))
      (ensure-test
       (and (visibility-record-p visibility)
            (claim-published-to-p claim scope)
            ;; Published ≠ verified / true / accepted / observed: no validation
            ;; standing appears and the origin is unchanged (K0E-20/K0E-21).
            (not (claim-validated-under-p
                  claim
                  (make-identity :procedure "test-44-any-procedure")
                  '(:any-scope)))
            (eq :asserted (claim-origin claim)))
       "publication was allowed to imply truth or validation standing")
      ;; Planted published→truth promotion mutant: smuggle the visibility record
      ;; into the validation slot; the K0E-18 type wall kills it.
      (expect-condition-req
       'malformed-constructor-shape "K0E-18"
       (lambda ()
         (make-claim
          :claim-id (make-identity :claim "test-44-mutant-claim")
          :content-datum content
          :source-ids nil
          :origin :asserted
          :validation-records (list visibility)
          :integrity-records nil
          :visibility-records nil
          :determinacy (make-determinacy :mode :determinate :evidence nil)
          :bounded-unknowns nil))
       "constructed validation record")))

  (run-test (47 "bare :published without scope refused")
    (expect-condition-req
     'bare-visibility-scope "K0E-20"
     (lambda ()
       (make-visibility-record
        :status :published
        :subject-id (make-identity :claim "test-47-subject")
        :representation-id "test-47 representation"))
     "non-empty relational scope"))

  (run-test (48 "bare :verified without procedure/scope refused")
    (expect-condition-req
     'bare-validation-scope "K0E-18"
     (lambda ()
       (make-validation-record
        :status :verified
        :subject-id (make-identity :claim "test-48-subject")
        :validator-principal-id (make-identity :principal "test-48-validator")
        :evidence (list (make-identity :receipt "test-48-evidence"))))
     "subject, validator, procedure, version, and scope")))

(defun outcome-accessor-surface-violations ()
  (let ((allowed
          '("OUTCOME-P"
            "OUTCOME-OUTCOME-VERSION"
            "OUTCOME-PROCESS-ID"
            "OUTCOME-LOGICAL-OPERATION-ID"
            "OUTCOME-SEAT-ID"
            "OUTCOME-ATTEMPT-ID"
            "OUTCOME-MACHINE-CONFIGURATION-ID"
            ;; [2026-07-19 chair, R3.1 overlay integration]: the K0E-23
            ;; descriptor-retention accessor is context-PRESERVING, not
            ;; context-discarding — it returns the exact immutable procedure
            ;; descriptor (a rich record, never a bare answer), added by the
            ;; GPT hostile-pass-3 repair so post-construction inspection can
            ;; recover the authority a procedure-relative interpretation was
            ;; judged under.  Registering it here is the lawful complement of
            ;; test 55, not a weakening of it.
            "OUTCOME-INTERPRETATION-DESCRIPTOR"
            "OUTCOME-RECEIPTS"
            "OUTCOME-BOUNDED-UNKNOWNS"
            "OUTCOME-AXIS"))
        (violations nil))
    (do-external-symbols
        (symbol (find-package '#:lisp-plus-kernel0) (nreverse violations))
      (let ((name (symbol-name symbol)))
        (when (and (fboundp symbol)
                   (> (length name) 8)
                   (string= "OUTCOME-" name :end2 8)
                   (not (member name allowed :test #'string=)))
          (push name violations))))))

(defun run-boundary-tests ()
  (run-test (49 "noncanonical host value refused")
    (expect-condition
     'noncanonical-durable-value
     (lambda () (require-canonical 1.5d0))
     "before crossing a durable boundary"))

  (run-test (55 "outcome context discard detected")
    (let* ((outcome
             (lisp-plus-kernel0::make-fixture-23-3-completed-present))
           (axis (outcome-axis outcome :manifestation)))
      (ensure-test
       (and (axis-p axis)
            (determinacy-p (axis-determinacy axis))
            (null (outcome-accessor-surface-violations)))
       "OUTCOME-AXIS lost context or an exported raw outcome accessor exists"))))

(defun run-negative-condition-control
    (tag description expected-type thunk invariant-fragment)
  (handler-case
      (let ((condition
              (expect-condition expected-type thunk invariant-fragment)))
        (push tag *negative-controls-fired*)
        (format t "NC-~A ~A: FIRED (~A)~%"
                tag description (type-of condition)))
    (condition (condition)
      (push (cons tag condition) *negative-controls-failed*)
      (format t "NC-~A ~A: FAILED (~A)~%" tag description condition))))

(defun run-negative-controls ()
  (run-negative-condition-control
   "a" "blind-retry" 'unsafe-retry
   (lambda ()
     (let* ((scenario (make-reconciliation-scenario))
            (events
              (append (getf scenario :base-events)
                      (list (getf scenario :retry-event)))))
       (check-retry-safety events
                           (getf (getf scenario :context) :seat))))
   "new attempt MUST NOT begin")

  (run-negative-condition-control
   "b" "payload-erasure" 'manifestation-payload-missing
   (lambda ()
     (make-manifestation
      :manifestation-id
      (make-identity :manifestation "nc-b-manifestation")
      :attempt-id (make-identity :attempt "nc-b-attempt")
      :kind :subject-answer
      :status :present
      ;; K0E-27: supply a lawful producer branch so the payload-missing refusal
      ;; is what this control reaches (not the producer-branch shape gate).  The
      ;; :negative-control boundary is not an adapter boundary → :producer-identity.
      :producer-identity (make-identity :principal "nc-b-producer")
      :source-boundary :negative-control))
   "MUST preserve a payload identity")
  (handler-case
      (ensure-test
       (and (not (fboundp '(setf manifestation-payload-id)))
            (not (find-symbol "SET-MANIFESTATION-PAYLOAD-ID"
                              '#:lisp-plus-kernel0)))
       "an exported manifestation payload mutation surface exists")
    (condition (condition)
      (push (cons "b-immutability" condition) *negative-controls-failed*)
      (format t "NC-b payload-erasure immutability: FAILED (~A)~%"
              condition)))
  (unless (assoc "b-immutability" *negative-controls-failed* :test #'string=)
    (format t "NC-b payload-erasure immutability: FIRED (no mutation surface)~%"))

  (run-negative-condition-control
   "c" "forged-observed-origin" 'standing-inflation
   (lambda () (promote-origin (make-test-claim "nc-c" :asserted) :observed))
   "asserted→observed")

  (format t "NC-h mutable-capability-scope-alias: EXCLUDED (live capability machinery, arc 2)~%")

  (run-negative-condition-control
   "d" "missing-exposed-principal" 'exposed-principal-missing
   #'make-empty-exposure-violation
   "without at least one named receiving principal")

  (run-negative-condition-control
   "e" "timestamp-only-journal-merge" 'journal-merge-receipt-required
   (lambda () (merge-event-sequences nil nil))
   "without an explicit transformation receipt")

  (run-negative-condition-control
   "f" "global-uncertainty-collapse" 'global-uncertainty-scalar-rejected
   #'make-global-uncertainty-violation
   "confidence, uncertainty, or probability scalar")

  (run-negative-condition-control
   "g" "seat-attempt-conflation" 'identity-drift
   (lambda ()
     (require-identity (make-identity :seat "nc-g-seat") :attempt))
   "accepting one identity domain")

  (format t "NC-i finalizer-only-primary-fact: EXCLUDED (journal/finalizer machinery awaits Process-Journal-/0)~%")

  (handler-case
      (let* ((outcome
               (lisp-plus-kernel0::make-fixture-23-3-completed-present))
             (planted-shortcut
               (lambda (value)
                 (axis-value (outcome-axis value :manifestation))))
             (result (funcall planted-shortcut outcome)))
        (ensure-test (not (axis-p result))
                     "planted bare-value shortcut unexpectedly retained an axis")
        (ensure-test (null (outcome-accessor-surface-violations))
                     "the exported surface contains an unapproved outcome shortcut")
        (push "j" *negative-controls-fired*)
        (format t "NC-j shorter-unsafe-convenience-accessor: FIRED (test-55 structural detector rejected bare value)~%"))
    (condition (condition)
      (push (cons "j" condition) *negative-controls-failed*)
      (format t "NC-j shorter-unsafe-convenience-accessor: FAILED (~A)~%"
              condition))))

(defun report-exclusions ()
  (dolist (entry *excluded-tests*)
    (format t "TEST ~2,'0D: EXCLUDED (~A)~%" (car entry) (cdr entry))))

;;; ---------------------------------------------------------------------------
;;; Errata 0.2 §8: the 29 required controls, named exclusions, planted mutants.
;;; ---------------------------------------------------------------------------

(defun report-named-exclusions ()
  "K0E-5a: print every named exclusion with its requirement id.  A conformance
report that omits an exclusion is nonconforming evidence."
  (dolist (entry *named-exclusions*)
    (format t "NAMED EXCLUSION [~A]: ~A~%" (first entry) (second entry))))

;;; -- The report-bites control (control 6, K0E-5a). ---------------------------
;;; The named-exclusion reporting MUST detect a report that either OMITS the
;;; call-296 row or COUNTS the stayed row as PASS.

(defun call-296-report-conforming-p (rows)
  "K0E-5a: a conforming report MUST carry the call-296 row as a NAMED EXCLUSION
with requirement id \"K0E-5a\" and status :STAYED, and MUST NOT count it :PASS."
  (and (some (lambda (row)
               (and (string= (getf row :row) "call-296")
                    (eq (getf row :status) :stayed)
                    (string= (getf row :requirement-id) "K0E-5a")))
             rows)
       (notany (lambda (row)
                 (and (string= (getf row :row) "call-296")
                      (eq (getf row :status) :pass)))
               rows)))

(defun run-report-bites-control ()
  "Control 6 (K0E-5a): the reporting BITES — it rejects both the omit mutant and
the count-as-pass mutant, and accepts the true stayed report."
  (let ((conforming
          (list (list :row "call-296" :status :stayed :requirement-id "K0E-5a")))
        (mutant-omitted nil)
        (mutant-counted-pass
          (list (list :row "call-296" :status :pass :requirement-id "K0E-5a"))))
    (handler-case
        (progn
          (ensure-test (call-296-report-conforming-p conforming)
                       "the conforming call-296 named-exclusion report was wrongly rejected")
          (ensure-test (not (call-296-report-conforming-p mutant-omitted))
                       "a report OMITTING the call-296 named exclusion was not detected as nonconforming")
          (ensure-test (not (call-296-report-conforming-p mutant-counted-pass))
                       "a report COUNTING the stayed call-296 row as PASS was not detected as nonconforming")
          (push 6 *controls-fired*)
          (format t "CONTROL 06 [K0E-5a]: FIRED (named-exclusion reporting rejects both the omit and the count-as-pass mutants; call-296 singleton is NOT counted as complete conformance)~%"))
      (condition (condition)
        (push (cons 6 condition) *controls-failed*)
        (format t "CONTROL 06 [K0E-5a]: FAILED (~A)~%" condition)))))

;;; -- Control primitives. -----------------------------------------------------

(defun control-refusal
    (number k0e expected-type expected-req thunk &optional fragment)
  "Run a refusal control: assert THUNK signals EXPECTED-TYPE with EXPECTED-REQ."
  (handler-case
      (progn
        (expect-condition-req expected-type expected-req thunk fragment)
        (push number *controls-fired*)
        (format t "CONTROL ~2,'0D [~A]: FIRED (~A req ~A)~%"
                number k0e expected-type expected-req))
    (condition (condition)
      (push (cons number condition) *controls-failed*)
      (format t "CONTROL ~2,'0D [~A]: FAILED (~A)~%" number k0e condition))))

(defun control-positive (number k0e description thunk)
  "Run a positive control: assert THUNK returns non-NIL."
  (handler-case
      (progn
        (ensure-test (funcall thunk)
                     "control ~D positive assertion failed" number)
        (push number *controls-fired*)
        (format t "CONTROL ~2,'0D [~A]: FIRED (positive: ~A)~%"
                number k0e description))
    (condition (condition)
      (push (cons number condition) *controls-failed*)
      (format t "CONTROL ~2,'0D [~A]: FAILED (~A)~%" number k0e condition))))

(defun control-excluded (number k0e reason)
  "Record a control that requires the journal store / AP0 runtime as a NAMED
exclusion — never silent, never counted as pass."
  (push number *controls-excluded*)
  (format t "CONTROL ~2,'0D [~A]: EXCLUDED (~A)~%" number k0e reason))

(defun %ctrl-uncertain-effect (stem possible-effects)
  (make-uncertain-effect
   :kind :provider-call
   :attempt (make-identity :attempt (format nil "~A-attempt" stem))
   :external-request (list :unavailable :reason
                           (intern (string-upcase stem) :keyword))
   :possible-effects possible-effects
   :known-facts nil
   :reconciliation-procedure
   (make-identity :procedure (format nil "~A-recon" stem))))

(defun run-erratum-controls ()
  "The 29 required controls of Errata 0.2 §8, each mapped to its requirement id."
  ;; 1 singleton outcome-axis bounded set refused.
  (control-refusal 1 "K0E-2" 'determinacy-alternatives-invalid "K0E-2"
    (lambda ()
      (make-determinacy :mode :bounded :alternatives '(:only-one) :evidence nil))
    "at least two distinct alternatives")
  ;; 2 bare-atom alternative refused (manifestation axis domain).
  (control-refusal 2 "K0E-1" 'determinacy-alternatives-invalid "K0E-1"
    (lambda ()
      (make-manifestation-axis
       :value '(:absent :state :absent-after-completion)
       :determinacy
       (make-determinacy
        :mode :bounded
        :alternatives (list '(:absent :state :absent-after-completion)
                            :bare-atom)
        :evidence nil)))
    "complete value in the axis domain")
  ;; 3 wrong-domain alternative refused (a manifestation state on an execution axis).
  (control-refusal 3 "K0E-1" 'determinacy-alternatives-invalid "K0E-1"
    (lambda ()
      (make-execution-axis
       :value :completed
       :determinacy
       (make-determinacy :mode :bounded
                         :alternatives '(:completed :absent-after-completion)
                         :evidence nil)))
    "complete value in the axis domain")
  ;; 4 current value outside alternatives refused.
  (control-refusal 4 "K0E-3" 'determinacy-alternatives-invalid "K0E-3"
    (lambda ()
      (make-execution-axis
       :value :completed
       :determinacy (make-determinacy :mode :bounded
                                      :alternatives '(:failed :cancelled)
                                      :evidence nil)))
    "member of its alternatives")
  ;; 5 effect alternatives differing from :possible-effects refused.
  (control-refusal 5 "K0E-4" 'determinacy-alternatives-invalid "K0E-4"
    (lambda ()
      (make-effect-axis
       :value :bounded
       :determinacy (make-determinacy :mode :bounded
                                      :alternatives '(:billed :refunded)
                                      :evidence nil)
       :uncertain-effect-ref (%ctrl-uncertain-effect "ctrl-5" '(:billed :not-billed))
       :effect-group (make-identity :effect "ctrl-5-effect")))
    "set-identical to the referenced uncertain-effect")
  ;; 6 call-296 singleton not counted as complete conformance (report-bites).
  (run-report-bites-control)
  ;; 7 synthetic two-alternative bounded manifestation accepted.
  (control-positive 7 "K0E-6"
    "synthetic two-alternative bounded manifestation constructs"
    (lambda ()
      (let* ((outcome
               (lisp-plus-kernel0::make-synthetic-bounded-manifestation-fixture))
             (m (outcome-axis outcome :manifestation)))
        (and (outcome-p outcome)
             (eq :bounded (determinacy-mode (axis-determinacy m)))
             (= 2 (length (determinacy-alternatives (axis-determinacy m))))))))
  ;; 8 unauthorized effect narrowing refused (subset of :possible-effects).
  (control-refusal 8 "K0E-4" 'determinacy-alternatives-invalid "K0E-4"
    (lambda ()
      (make-effect-axis
       :value :bounded
       :determinacy (make-determinacy :mode :bounded
                                      :alternatives '(:billed :not-billed)
                                      :evidence nil)
       :uncertain-effect-ref
       (%ctrl-uncertain-effect "ctrl-8" '(:billed :not-billed :refunded))
       :effect-group (make-identity :effect "ctrl-8-effect")))
    "set-identical to the referenced uncertain-effect")
  ;; 9 :attempt-indeterminate transition-order violation refused.
  (control-refusal 9 "K0E-17" 'journal-illegal-transition "K0E-17"
    (lambda ()
      (let ((seat (make-identity :seat "ctrl-9-seat"))
            (attempt (make-identity :attempt "ctrl-9-attempt"))
            (evidence (make-identity :receipt "ctrl-9-evidence")))
        (validate-event-sequence
         (list
          (make-kernel0-event :event-type :seat-reserved :seat-id seat)
          (make-kernel0-event
           :event-type :attempt-indeterminate
           :seat-id seat :attempt-id attempt
           :payload (list :indeterminacy-evidence (list evidence)))))))
    "may occur only after")
  ;; 10-14 journal / PJ0-dependent controls: NAMED EXCLUSIONS.
  (control-excluded 10 "K0E-8/K0E-26"
    "dual standing over a structurally valid PJ0 byte prefix requires Process-Journal-/0 bytes/framing; the Kernel semantic-refusal half is exercised by the identity/fold tests")
  (control-excluded 11 "K0E-11"
    "reconstruction skipping corruption requires a live journal store and maximal-valid-prefix selection (Process-Journal-/0)")
  (control-excluded 12 "K0E-9"
    "derived-artifact deletion attestation requires journal reconstruction and finalizer-product exclusion (Process-Journal-/0)")
  (control-excluded 13 "K0E-15"
    "torn tail yielding bounded standing requires Process-Journal-/0 torn-tail bytes/framing")
  (control-excluded 14 "K0E-16"
    "salvage preserving abstract events/replay while frame identity changes requires Process-Journal-/0 salvage/merge bytes")
  ;; 15 sealed→verified mutant killed (the K0E-18 type wall enforces K0E-21).
  (control-refusal 15 "K0E-18/K0E-21" 'malformed-constructor-shape "K0E-18"
    (lambda ()
      (let* ((content "ctrl-15 sealed representation")
             (claim-id (make-identity :claim "ctrl-15-claim"))
             (integrity
               (make-integrity-record
                :status :sealed :subject-id claim-id
                :representation-id content
                :method-id (make-identity :procedure "ctrl-15-method")
                :method-version 0
                :sealing-principal-id (make-identity :principal "ctrl-15-sealer")
                :evidence (list (make-identity :receipt "ctrl-15-evidence")))))
        (make-claim :claim-id claim-id :content-datum content :source-ids nil
                    :origin :asserted :validation-records (list integrity)
                    :integrity-records nil :visibility-records nil
                    :determinacy (make-determinacy :mode :determinate :evidence nil)
                    :bounded-unknowns nil)))
    "constructed validation record")
  ;; 16 published→true/accepted/observed mutant killed.
  (control-refusal 16 "K0E-18/K0E-21" 'malformed-constructor-shape "K0E-18"
    (lambda ()
      (let* ((content "ctrl-16 published representation")
             (claim-id (make-identity :claim "ctrl-16-claim"))
             (visibility
               (make-visibility-record
                :status :published :subject-id claim-id
                :representation-id content
                :scope-id '(:audience :ctrl-16))))
        (make-claim :claim-id claim-id :content-datum content :source-ids nil
                    :origin :asserted :validation-records (list visibility)
                    :integrity-records nil :visibility-records nil
                    :determinacy (make-determinacy :mode :determinate :evidence nil)
                    :bounded-unknowns nil)))
    "constructed validation record")
  ;; 17 bare verified/published refused.
  (control-refusal 17 "K0E-18" 'bare-validation-scope "K0E-18"
    (lambda ()
      (make-validation-record
       :status :verified
       :subject-id (make-identity :claim "ctrl-17-subject")
       :validator-principal-id (make-identity :principal "ctrl-17-validator")
       :evidence (list (make-identity :receipt "ctrl-17-evidence"))))
    "subject, validator, procedure, version, and scope")
  ;; 18 integrity copied to a mismatched representation refused.
  (control-refusal 18 "K0E-21" 'standing-inflation "K0E-21"
    (lambda ()
      (let* ((content "ctrl-18 claim content")
             (other "ctrl-18 DIFFERENT representation")
             (claim-id (make-identity :claim "ctrl-18-claim"))
             (integrity
               (make-integrity-record
                :status :sealed :subject-id claim-id
                :representation-id other
                :method-id (make-identity :procedure "ctrl-18-method")
                :method-version 0
                :sealing-principal-id (make-identity :principal "ctrl-18-sealer")
                :evidence (list (make-identity :receipt "ctrl-18-evidence")))))
        (make-claim :claim-id claim-id :content-datum content :source-ids nil
                    :origin :asserted :validation-records nil
                    :integrity-records (list integrity) :visibility-records nil
                    :determinacy (make-determinacy :mode :determinate :evidence nil)
                    :bounded-unknowns nil)))
    "a copy cannot inherit a seal")
  ;; 19 context-free standing accessor rejected (absence of verified-p/published-p).
  (control-positive 19 "K0E-22"
    "no context-free verified-p/published-p standing accessor exists"
    (lambda ()
      (and (not (find-symbol "VERIFIED-P" '#:lisp-plus-kernel0))
           (not (find-symbol "PUBLISHED-P" '#:lisp-plus-kernel0))
           (not (find-symbol "CLAIM-VERIFIED-P" '#:lisp-plus-kernel0))
           (not (find-symbol "CLAIM-PUBLISHED-P" '#:lisp-plus-kernel0)))))
  ;; 20 structural procedure licensing accepted/rejected refused.
  (control-refusal 20 "K0E-25" 'interpretation-class-violation "K0E-25"
    (lambda ()
      (make-interpretation-axis
       :value :accepted
       :determinacy (make-determinacy :mode :determinate :evidence nil)
       :procedure-id (make-identity :procedure "ctrl-20-structural-proc")
       :judgment-class :structural))
    "structural judgment class MUST NOT license")
  ;; 21 joint verdict flattening rejected (+ positive: PASS/FAIL survives).
  (handler-case
      (let* ((sv (make-verdict :value :pass
                               :procedure-id (make-identity :procedure "ctrl-21-structural")))
             (mv (make-verdict :value :fail
                               :procedure-id (make-identity :procedure "ctrl-21-semantic")
                               ;; R3 (K0E-26): a :fail verdict MUST carry a reason
                               ;; (a condition-id or requirement-id) or it is
                               ;; uninspectable.  Control 21's semantic-FAIL half
                               ;; names the requirement it diverged on.
                               :requirement-ids (list "K0E-26")))
             (joint (make-joint-verdict :structural-verdict sv :semantic-verdict mv)))
        (ensure-test (joint-verdict-divergent-p joint)
                     "structural PASS + semantic FAIL joint verdict did not report divergence")
        (ensure-test (and (verdict-p (joint-verdict-structural joint))
                          (verdict-p (joint-verdict-semantic joint)))
                     "joint verdict halves were not independently readable verdict records")
        (expect-condition-req 'malformed-constructor-shape "K0E-26"
          (lambda () (make-joint-verdict :structural-verdict sv :semantic-verdict t))
          "MUST be a verdict sub-record")
        (push 21 *controls-fired*)
        (format t "CONTROL 21 [K0E-26]: FIRED (structural PASS + semantic FAIL survives, divergent-p T; single-boolean flatten refused)~%"))
    (condition (condition)
      (push (cons 21 condition) *controls-failed*)
      (format t "CONTROL 21 [K0E-26]: FAILED (~A)~%" condition)))
  ;; 22 AP0-produced manifestation missing adapter identity refused (both-branch ambiguity).
  (control-refusal 22 "K0E-27" 'malformed-constructor-shape "K0E-27"
    (lambda ()
      (make-manifestation
       :manifestation-id (make-identity :manifestation "ctrl-22-m")
       :attempt-id (make-identity :attempt "ctrl-22-a")
       :kind :subject-answer :status :absent
       :absence-state :absent-after-completion
       :source-boundary :fixture-adapter-boundary
       :adapter-identity (make-identity :procedure "ctrl-22-adapter")
       :producer-identity (make-identity :principal "ctrl-22-producer")))
    "exactly one producer branch")
  ;; 23 non-AP0 manifestation missing producer identity refused (neither branch).
  (control-refusal 23 "K0E-27" 'malformed-constructor-shape "K0E-27"
    (lambda ()
      (make-manifestation
       :manifestation-id (make-identity :manifestation "ctrl-23-m")
       :attempt-id (make-identity :attempt "ctrl-23-a")
       :kind :subject-answer :status :absent
       :absence-state :absent-after-completion
       :source-boundary :fixture-adapter-boundary))
    "MUST bind exactly one producer branch")
  ;; 24 streamed manifestation missing chunk relation: the checkable husk refusal
  ;; FIRES; the "should-have-streamed" remainder is a named exclusion.
  (control-refusal 24 "K0E-32" 'malformed-constructor-shape "K0E-32"
    (lambda ()
      (make-manifestation
       :manifestation-id (make-identity :manifestation "ctrl-24-m")
       :attempt-id (make-identity :attempt "ctrl-24-a")
       :kind :subject-answer :status :present-partial
       :payload-id (make-identity :manifestation "ctrl-24-payload")
       :source-boundary :fixture-adapter-boundary
       :adapter-identity (make-identity :procedure "ctrl-24-adapter")
       :stream-relation nil))
    "insufficient stream marker")
  ;; 25 aggregate without receipt refused.
  (control-refusal 25 "K0E-30" 'malformed-constructor-shape "K0E-30"
    (lambda ()
      (make-manifestation
       :manifestation-id (make-identity :manifestation "ctrl-25-m")
       :attempt-id (make-identity :attempt "ctrl-25-a")
       :kind :subject-answer :status :present
       :payload-id (make-identity :manifestation "ctrl-25-payload")
       :source-boundary :fixture-adapter-boundary
       :adapter-identity (make-identity :procedure "ctrl-25-adapter")
       :stream-relation
       (list :stream-id (make-identity :store "ctrl-25-stream")
             :relation-kind :aggregate
             :chunk-record-ids (list (make-identity :store "ctrl-25-c0")
                                     (make-identity :store "ctrl-25-c1")))))
    "MUST bind a projection-receipt-id")
  ;; 26 partial-erasure mutant killed: the captured lineage is a read-only
  ;; surface — no mutation function exists to erase a payload or chunk lineage.
  (control-positive 26 "K0E-31"
    "captured partial lineage has no mutation surface (read-only, no copier)"
    (lambda ()
      (and (not (fboundp '(setf manifestation-payload-id)))
           (not (fboundp '(setf manifestation-stream-relation)))
           (not (fboundp '(setf manifestation-chunk-record-ids)))
           (not (fboundp '(setf stream-relation-chunk-record-ids)))
           (not (fboundp 'copy-manifestation))
           (not (fboundp 'copy-stream-relation)))))
  ;; 27 missing emptiness rule for present-empty refused (base spec §8.4).
  (control-refusal 27 "§8.4" 'interpretation-procedure-missing nil
    (lambda ()
      (make-manifestation
       :manifestation-id (make-identity :manifestation "ctrl-27-m")
       :attempt-id (make-identity :attempt "ctrl-27-a")
       :kind :subject-answer :status :present-empty
       :payload-id (make-identity :manifestation "ctrl-27-payload")
       :source-boundary :fixture-adapter-boundary
       :adapter-identity (make-identity :procedure "ctrl-27-adapter")))
    "identified emptiness rule")
  ;; 28 global scalar refused.
  (control-refusal 28 "K0E-33" 'global-uncertainty-scalar-rejected "K0E-33"
    (lambda ()
      (make-determinacy :mode :determinate :confidence :high :evidence nil))
    "global confidence, uncertainty, or probability scalar"))

(defun expect-mutant-killed (label expected-type expected-req thunk &optional fragment)
  "Assert the planted mutant THUNK is killed by EXPECTED-TYPE/EXPECTED-REQ."
  (handler-case
      (progn
        (expect-condition-req expected-type expected-req thunk fragment)
        (push (list label expected-type expected-req) *mutants-killed*)
        (format t "MUTANT ~A: KILLED (~A req ~A)~%" label expected-type expected-req))
    (condition (condition)
      (push (cons label condition) *mutants-survived*)
      (format t "MUTANT ~A: SURVIVED-OR-WRONG-REASON (~A)~%" label condition))))

;;; -- IANUS-II R1/R2/R3 semantic-validator mutant builders. -------------------
;;; Transcribed verbatim (values, not variable names) from
;;; _staging/kernel0-impl/wr2-ianus2-probe.lisp so the suite exercises the exact
;;; constructions the repair probe proved.
(defparameter *ianus-proc-id* (make-identity :procedure "wr2-semantic-proc"))
(defparameter *ianus-version* 1)                     ; canonical integer version
(defparameter *ianus-ev-a* (make-identity :receipt "wr2-evidence-a"))
(defparameter *ianus-ev-b* (make-identity :receipt "wr2-evidence-b"))

(defun ianus-semantic-descriptor
    (&key (kinds '(:subject-answer)) (statuses '(:present :present-empty))
          (evidence-requirements nil) (version *ianus-version*))
  "A semantic procedure descriptor with a constrained input-domain."
  (make-procedure-descriptor
   :procedure-id *ianus-proc-id*
   :version version
   :judgment-class :semantic
   :input-domain (list :kinds kinds :statuses statuses)
   :result-vocabulary '(:accepted :rejected :invalid)
   :evidence-requirements evidence-requirements))

(defun ianus-accepted-axis
    (&key (judgment-class :semantic) (procedure-version *ianus-version*)
          (evidence (list *ianus-ev-a*)))
  "An :accepted interpretation axis that binds a class and version cache."
  (let ((args (list :value :accepted
                    :determinacy (make-determinacy :mode :determinate
                                                   :evidence nil)
                    :procedure-id *ianus-proc-id*
                    :evidence evidence)))
    (when judgment-class
      (setf args (append args (list :judgment-class judgment-class))))
    (when procedure-version
      (setf args (append args (list :procedure-version procedure-version))))
    (apply #'make-interpretation-axis args)))

(defun ianus-present-manifestation (&key (kind :subject-answer) (status :present))
  (make-manifestation
   :manifestation-id (make-identity :manifestation "wr2-m")
   :attempt-id (make-identity :attempt "wr2-a")
   :kind kind
   :status status
   :payload-id (make-identity :manifestation "wr2-payload")
   :adapter-identity (make-identity :procedure "wr2-adapter")
   :source-boundary :wr2-boundary))

;;; -- CLAUSTRUM B1/B2/R3 mutant builders (hostile review 2 §3/§4/§8). ----------
;;; Transcribed verbatim (values, not variable names) from
;;; _staging/kernel0-impl/wr5-claustrum-probe.lisp.  Review theme: "a validator
;;; correct WHEN INVOKED does not enforce a law if the public constructor can
;;; create the governed standing WITHOUT invoking it."  So every B1 mutant runs
;;; through the PUBLIC OUTCOME PATH (MAKE-OUTCOME), never a direct
;;; VALIDATE-INTERPRETATION-AGAINST-DESCRIPTOR call — the shorter walk-around is
;;; the thing being closed.
(defparameter *claustrum-proc-id* (make-identity :procedure "wr5-semantic-proc"))
(defparameter *claustrum-version* 1)                 ; canonical integer version
(defparameter *claustrum-ev-a* (make-identity :receipt "wr5-evidence-a"))
(defparameter *claustrum-ev-b* (make-identity :receipt "wr5-evidence-b"))

(defun claustrum-semantic-descriptor
    (&key (kinds '(:subject-answer)) (statuses '(:present :present-empty))
          (evidence-requirements nil) (version *claustrum-version*))
  (make-procedure-descriptor
   :procedure-id *claustrum-proc-id*
   :version version
   :judgment-class :semantic
   :input-domain (list :kinds kinds :statuses statuses)
   :result-vocabulary '(:accepted :rejected :invalid)
   :evidence-requirements evidence-requirements))

(defun claustrum-interp-axis
    (value &key (judgment-class :semantic) (procedure-version *claustrum-version*)
                (evidence (list *claustrum-ev-a*)))
  "An interpretation axis binding class + integer version cache."
  (let ((args (list :value value
                    :determinacy (make-determinacy :mode :determinate
                                                   :evidence nil)
                    :procedure-id *claustrum-proc-id*
                    :evidence evidence)))
    (when judgment-class
      (setf args (append args (list :judgment-class judgment-class))))
    (when procedure-version
      (setf args (append args (list :procedure-version procedure-version))))
    (apply #'make-interpretation-axis args)))

(defun claustrum-present-manifestation (&key (kind :subject-answer) (status :present))
  (make-manifestation
   :manifestation-id (make-identity :manifestation "wr5-m")
   :attempt-id (make-identity :attempt "wr5-a")
   :kind kind
   :status status
   :payload-id (make-identity :manifestation "wr5-payload")
   :adapter-identity (make-identity :procedure "wr5-adapter")
   :source-boundary :wr5-boundary))

(defun claustrum-build-outcome
    (interpretation
     &key (descriptor nil descriptor-supplied-p)
          (manifestation-kind :subject-answer)
          (manifestation-status :present))
  "Mint an outcome THROUGH THE PUBLIC PATH.  :DESCRIPTOR, when supplied (even as
NIL), is threaded to MAKE-OUTCOME's :INTERPRETATION-DESCRIPTOR; omitting the key
models a caller that supplies no descriptor at all."
  (let ((determinate (make-determinacy :mode :determinate :evidence nil))
        (effect (make-identity :effect "wr5-effect")))
    (apply #'make-outcome
           :process-id (make-identity :process "wr5-process")
           :logical-operation-id (make-identity :logical-operation "wr5-operation")
           :seat-id (make-identity :seat "wr5-seat")
           :attempt-id (make-identity :attempt "wr5-attempt")
           :execution (make-execution-axis :value :completed
                                           :determinacy determinate)
           :manifestation (make-manifestation-axis
                           :value (claustrum-present-manifestation
                                   :kind manifestation-kind
                                   :status manifestation-status)
                           :determinacy determinate)
           :effects (make-effect-axis :value :settled
                                      :determinacy determinate
                                      :effect-group effect)
           :interpretation interpretation
           (when descriptor-supplied-p
             (list :interpretation-descriptor descriptor)))))

;;; -- GPT hostile-pass-3 procedure-binding probes. --------------------------
(defun gpt3-invalid-axis ()
  (make-interpretation-axis
   :value :invalid
   :determinacy (make-determinacy :mode :determinate :evidence nil)
   :procedure-id (make-identity :procedure "gpt3-invalid-procedure")
   :procedure-version 0
   :judgment-class :structural))

;;; -- NEXUS B3/R1/N2 mutant builders (hostile review 2 §5/§6/§10). ------------
;;; Transcribed from _staging/kernel0-impl/wr6-nexus-probe.lisp.  Claim S is the
;;; home claim whose content is the full/private representation S; R is a
;;; DIFFERENT (redacted/public) representation.
(defparameter *nexus-rep-s* "nexus full private representation S")
(defparameter *nexus-rep-r* "nexus redacted public representation R")
(defparameter *nexus-claim-s-id* (make-identity :claim "nexus-claim-S"))
(defparameter *nexus-scope* '(:audience :nexus-readers))

(defun nexus-det ()
  (make-determinacy :mode :determinate :evidence nil))

(defun nexus-home-claim (&key visibility (content *nexus-rep-s*))
  (make-claim
   :claim-id *nexus-claim-s-id*
   :content-datum content
   :source-ids nil
   :origin :asserted
   :validation-records nil
   :integrity-records nil
   :visibility-records visibility
   :determinacy (nexus-det)
   :bounded-unknowns nil))

(defun expect-query-mutant-killed (label expected-req thunk)
  "Record an INDEPENDENT mutant kill whose defense is a QUERY REFUSAL rather than
a signaled condition: THUNK returns non-NIL iff the query correctly refused the
planted (constructor-bypassed) record.  The QUERY-RECHECK marker is not one of the
control re-attribution markers, so this counts as an INDEPENDENT mutant."
  (handler-case
      (if (funcall thunk)
          (progn
            (push (list label :query-recheck expected-req) *mutants-killed*)
            (format t "MUTANT ~A: KILLED (defensive query recheck refuses the mismatched-representation record; req ~A)~%"
                    label expected-req))
          (progn
            (push (cons label "query did not refuse the planted record")
                  *mutants-survived*)
            (format t "MUTANT ~A: SURVIVED (query accepted a mismatched-representation record)~%"
                    label)))
    (condition (condition)
      (push (cons label condition) *mutants-survived*)
      (format t "MUTANT ~A: SURVIVED-OR-ERROR (~A)~%" label condition))))

(defun run-planted-mutants ()
  "The planted-mutant kill list.  A mutant counts as KILLED only when it fails
for the INTENDED requirement — checked by condition TYPE and requirement id."
  ;; singleton-bounded acceptance.
  (expect-mutant-killed "singleton-bounded"
    'determinacy-alternatives-invalid "K0E-2"
    (lambda ()
      (make-determinacy :mode :bounded :alternatives '(:sole) :evidence nil))
    "at least two distinct alternatives")
  ;; incomplete alternatives (bare-atom on a manifestation axis).
  (expect-mutant-killed "incomplete-alternatives"
    'determinacy-alternatives-invalid "K0E-1"
    (lambda ()
      (make-manifestation-axis
       :value '(:absent :state :absent-after-completion)
       :determinacy
       (make-determinacy :mode :bounded
                         :alternatives (list '(:absent :state :absent-after-completion)
                                             :incomplete)
                         :evidence nil)))
    "complete value in the axis domain")
  ;; value-outside-alternatives.
  (expect-mutant-killed "value-outside-alternatives"
    'determinacy-alternatives-invalid "K0E-3"
    (lambda ()
      (make-execution-axis
       :value :completed
       :determinacy (make-determinacy :mode :bounded
                                      :alternatives '(:failed :cancelled)
                                      :evidence nil)))
    "member of its alternatives")
  ;; effect-set drift.
  (expect-mutant-killed "effect-set-drift"
    'determinacy-alternatives-invalid "K0E-4"
    (lambda ()
      (make-effect-axis
       :value :bounded
       :determinacy (make-determinacy :mode :bounded
                                      :alternatives '(:billed :refunded)
                                      :evidence nil)
       :uncertain-effect-ref (%ctrl-uncertain-effect "mut-drift" '(:billed :not-billed))
       :effect-group (make-identity :effect "mut-drift-effect")))
    "set-identical to the referenced uncertain-effect")
  ;; illegal :attempt-indeterminate transition — before begun.
  (expect-mutant-killed "attempt-indeterminate-before-begun"
    'journal-illegal-transition "K0E-17"
    (lambda ()
      (let ((seat (make-identity :seat "mut-ai1-seat"))
            (attempt (make-identity :attempt "mut-ai1-attempt")))
        (validate-event-sequence
         (list (make-kernel0-event :event-type :seat-reserved :seat-id seat)
               (make-kernel0-event
                :event-type :attempt-indeterminate :seat-id seat :attempt-id attempt
                :payload (list :indeterminacy-evidence
                               (list (make-identity :receipt "mut-ai1-ev"))))))))
    "may occur only after")
  ;; illegal :attempt-indeterminate transition — missing evidence.
  (expect-mutant-killed "attempt-indeterminate-no-evidence"
    'journal-illegal-transition "K0E-17"
    (lambda ()
      (let ((seat (make-identity :seat "mut-ai2-seat"))
            (attempt (make-identity :attempt "mut-ai2-attempt")))
        (validate-event-sequence
         (list (make-kernel0-event :event-type :seat-reserved :seat-id seat)
               (make-kernel0-event :event-type :attempt-begun
                                   :seat-id seat :attempt-id attempt)
               (make-kernel0-event
                :event-type :attempt-indeterminate :seat-id seat :attempt-id attempt
                :payload (list :indeterminacy-evidence nil))))))
    "non-empty :INDETERMINACY-EVIDENCE")
  ;; sealed→verified mutant (seal in the validation slot).
  (expect-mutant-killed "sealed-to-verified"
    'malformed-constructor-shape "K0E-18"
    (lambda ()
      (let* ((content "mut-sv content")
             (claim-id (make-identity :claim "mut-sv-claim"))
             (integrity
               (make-integrity-record
                :status :sealed :subject-id claim-id :representation-id content
                :method-id (make-identity :procedure "mut-sv-method")
                :method-version 0
                :sealing-principal-id (make-identity :principal "mut-sv-sealer")
                :evidence (list (make-identity :receipt "mut-sv-ev")))))
        (make-claim :claim-id claim-id :content-datum content :source-ids nil
                    :origin :asserted :validation-records (list integrity)
                    :integrity-records nil :visibility-records nil
                    :determinacy (make-determinacy :mode :determinate :evidence nil)
                    :bounded-unknowns nil)))
    "constructed validation record")
  ;; published→truth mutant (visibility in the validation slot).
  (expect-mutant-killed "published-to-truth"
    'malformed-constructor-shape "K0E-18"
    (lambda ()
      (let* ((content "mut-pt content")
             (claim-id (make-identity :claim "mut-pt-claim"))
             (visibility
               (make-visibility-record
                :status :published :subject-id claim-id :representation-id content
                :scope-id '(:audience :mut-pt))))
        (make-claim :claim-id claim-id :content-datum content :source-ids nil
                    :origin :asserted :validation-records (list visibility)
                    :integrity-records nil :visibility-records nil
                    :determinacy (make-determinacy :mode :determinate :evidence nil)
                    :bounded-unknowns nil)))
    "constructed validation record")
  ;; integrity copied to mismatched representation.
  (expect-mutant-killed "seal-over-other-representation"
    'standing-inflation "K0E-21"
    (lambda ()
      (let* ((content "mut-so content")
             (other "mut-so OTHER representation")
             (claim-id (make-identity :claim "mut-so-claim"))
             (integrity
               (make-integrity-record
                :status :sealed :subject-id claim-id :representation-id other
                :method-id (make-identity :procedure "mut-so-method")
                :method-version 0
                :sealing-principal-id (make-identity :principal "mut-so-sealer")
                :evidence (list (make-identity :receipt "mut-so-ev")))))
        (make-claim :claim-id claim-id :content-datum content :source-ids nil
                    :origin :asserted :validation-records nil
                    :integrity-records (list integrity) :visibility-records nil
                    :determinacy (make-determinacy :mode :determinate :evidence nil)
                    :bounded-unknowns nil)))
    "a copy cannot inherit a seal")
  ;; structural-procedure-licensing-acceptance.
  (expect-mutant-killed "structural-licenses-accepted"
    'interpretation-class-violation "K0E-25"
    (lambda ()
      (make-interpretation-axis
       :value :rejected
       :determinacy (make-determinacy :mode :determinate :evidence nil)
       :procedure-id (make-identity :procedure "mut-struct-proc")
       :judgment-class :structural))
    "structural judgment class MUST NOT license")
  ;; flattened joint verdict — bare boolean half (IANUS design 1).
  (expect-mutant-killed "flattened-boolean-verdict"
    'malformed-constructor-shape "K0E-26"
    (lambda ()
      ;; The structural half is a LAWFUL verdict (R3: :pass names its
      ;; :procedure-id); the PLANTED flaw is the bare boolean semantic half,
      ;; which the joint-verdict "MUST be a verdict sub-record" law refuses —
      ;; proving the joint report cannot collapse to a single boolean.
      (make-joint-verdict
       :structural-verdict (make-verdict :value :pass
                                         :procedure-id (make-identity :procedure "mut-flat-bool"))
       :semantic-verdict t))
    "MUST be a verdict sub-record")
  ;; flattened joint verdict — aggregate counter half (IANUS design 2).
  (expect-mutant-killed "flattened-counter-verdict"
    'malformed-constructor-shape "K0E-26"
    (lambda ()
      ;; Lawful structural half; the PLANTED flaw is the aggregate-counter
      ;; semantic half (a bare integer), refused by the same sub-record law.
      (make-joint-verdict
       :structural-verdict (make-verdict :value :pass
                                         :procedure-id (make-identity :procedure "mut-flat-counter"))
       :semantic-verdict 7))
    "MUST be a verdict sub-record")
  ;; missing adapter/producer identity.
  (expect-mutant-killed "missing-producer-branch"
    'malformed-constructor-shape "K0E-27"
    (lambda ()
      (make-manifestation
       :manifestation-id (make-identity :manifestation "mut-mp-m")
       :attempt-id (make-identity :attempt "mut-mp-a")
       :kind :subject-answer :status :absent
       :absence-state :absent-after-completion
       :source-boundary :fixture-adapter-boundary))
    "MUST bind exactly one producer branch")
  ;; missing stream lineage — empty chunk id list.
  (expect-mutant-killed "missing-stream-lineage"
    'malformed-constructor-shape "K0E-28"
    (lambda ()
      (make-manifestation
       :manifestation-id (make-identity :manifestation "mut-ms-m")
       :attempt-id (make-identity :attempt "mut-ms-a")
       :kind :subject-answer :status :present
       :payload-id (make-identity :manifestation "mut-ms-payload")
       :source-boundary :fixture-adapter-boundary
       :adapter-identity (make-identity :procedure "mut-ms-adapter")
       :stream-relation
       (list :stream-id (make-identity :store "mut-ms-stream")
             :relation-kind :direct-chunk
             :chunk-record-ids nil)))
    "non-empty ordered list")
  ;; aggregate-without-receipt.
  (expect-mutant-killed "aggregate-without-receipt"
    'malformed-constructor-shape "K0E-30"
    (lambda ()
      (make-manifestation
       :manifestation-id (make-identity :manifestation "mut-ar-m")
       :attempt-id (make-identity :attempt "mut-ar-a")
       :kind :subject-answer :status :present
       :payload-id (make-identity :manifestation "mut-ar-payload")
       :source-boundary :fixture-adapter-boundary
       :adapter-identity (make-identity :procedure "mut-ar-adapter")
       :stream-relation
       (list :stream-id (make-identity :store "mut-ar-stream")
             :relation-kind :projection
             :chunk-record-ids (list (make-identity :store "mut-ar-c0")))))
    "MUST bind a projection-receipt-id")
  ;; missing emptiness rule.
  (expect-mutant-killed "missing-emptiness-rule"
    'interpretation-procedure-missing nil
    (lambda ()
      (make-manifestation
       :manifestation-id (make-identity :manifestation "mut-me-m")
       :attempt-id (make-identity :attempt "mut-me-a")
       :kind :subject-answer :status :present-empty
       :payload-id (make-identity :manifestation "mut-me-payload")
       :source-boundary :fixture-adapter-boundary
       :adapter-identity (make-identity :procedure "mut-me-adapter")))
    "identified emptiness rule")
  ;; global scalar.
  (expect-mutant-killed "global-scalar"
    'global-uncertainty-scalar-rejected "K0E-33"
    (lambda ()
      (make-outcome :confidence :high))
    "confidence, uncertainty, or probability scalar")
  ;; effect-axis unknown key (ARGUS R1 repair teeth, 2026-07-19): the effect
  ;; axis must refuse unknown/duplicate fields with MALFORMED-CONSTRUCTOR-SHAPE
  ;; exactly like every sibling axis (K0E-33 cited in the invariant; the
  ;; strict-parse layer carries no requirement-id slot, uniformly).
  (expect-mutant-killed "effect-axis-unknown-key"
    'malformed-constructor-shape nil
    (lambda ()
      (make-effect-axis
       :value :not-entered
       :determinacy (make-determinacy :mode :determinate :evidence nil)
       :effect-group (make-identity :effect "mut-eak-group")
       :streamed-p t))
    "[K0E-33]")
  ;; -------------------------------------------------------------------------
  ;; Hostile-review repair mutants — VINCULUM (records.lisp: B1 subject
  ;; binding, B2 refusal-first transfer, N1 typed authorizing-basis).
  ;; Transcribed from _staging/kernel0-impl/wr1-vinculum-probe.lisp.
  ;; -------------------------------------------------------------------------
  ;; B1: a validation record whose :subject-id names a FOREIGN claim (B) is
  ;; standing laundered onto the home claim (A) — refused K0E-18.
  (expect-mutant-killed "foreign-subject-validation"
    'standing-inflation "K0E-18"
    (lambda ()
      (make-claim
       :claim-id (make-identity :claim "vinc-mut-a")
       :content-datum "vinculum mutant content"
       :source-ids nil
       :origin :asserted
       :validation-records
       (list (make-validation-record
              :status :verified
              :subject-id (make-identity :claim "vinc-mut-b") ; FOREIGN subject
              :validator-principal-id (make-identity :principal "vinc-mut-validator")
              :procedure-id (make-identity :procedure "vinc-mut-proc")
              :procedure-version 0
              :scope '(:vinc :scope)
              :evidence (list (make-identity :receipt "vinc-mut-val-evidence"))))
       :integrity-records nil
       :visibility-records nil
       :determinacy (make-determinacy :mode :determinate :evidence nil)
       :bounded-unknowns nil)))
  ;; B1: a visibility record subject-bound to a FOREIGN claim — refused K0E-20.
  (expect-mutant-killed "foreign-subject-visibility"
    'standing-inflation "K0E-20"
    (lambda ()
      (make-claim
       :claim-id (make-identity :claim "vinc-mut-a")
       :content-datum "vinculum mutant content"
       :source-ids nil
       :origin :asserted
       :validation-records nil
       :integrity-records nil
       :visibility-records
       (list (make-visibility-record
              :status :published
              :subject-id (make-identity :claim "vinc-mut-b") ; FOREIGN subject
              :representation-id "vinculum mutant content"
              :scope-id '(:audience :vinc-readers)))
       :determinacy (make-determinacy :mode :determinate :evidence nil)
       :bounded-unknowns nil)))
  ;; B1: an integrity seal subject-bound to a FOREIGN claim over the SAME
  ;; representation as the home claim's content — the representation check
  ;; passes, so only the subject check (ordered first) catches it: K0E-19.
  (expect-mutant-killed "foreign-subject-integrity-same-representation"
    'standing-inflation "K0E-19"
    (lambda ()
      (make-claim
       :claim-id (make-identity :claim "vinc-mut-a")
       :content-datum "vinculum mutant content"
       :source-ids nil
       :origin :asserted
       :validation-records nil
       :integrity-records
       (list (make-integrity-record
              :status :sealed
              :subject-id (make-identity :claim "vinc-mut-b") ; FOREIGN subject
              :representation-id "vinculum mutant content"     ; SAME representation
              :method-id (make-identity :procedure "vinc-mut-seal-method")
              :method-version 0
              :sealing-principal-id (make-identity :principal "vinc-mut-sealer")
              :evidence (list (make-identity :receipt "vinc-mut-seal-evidence"))))
       :visibility-records nil
       :determinacy (make-determinacy :mode :determinate :evidence nil)
       :bounded-unknowns nil)))
  ;; B2 (refusal-first disposition): any non-NIL validation-transfer-license is
  ;; REFUSED (K0E-21) as a named exclusion — the wholesale-copy path is retired.
  ;; This mutant REPLACES the review's four behavioral transfer mutants
  ;; (transfer-license-p-copies-q, -wrong-scope, -unbound-to-receipt,
  ;; transferred-validation-keeps-source-subject): under refusal-first the typed
  ;; transfer path does not exist, so those four are non-constructible and moot
  ;; until the transfer protocol is built (VINCULUM WR1 §3).
  (expect-mutant-killed "transfer-license-refused"
    'standing-inflation "K0E-21"
    (lambda ()
      (let ((source
              (make-claim
               :claim-id (make-identity :claim "vinc-mut-src")
               :content-datum "vinculum source content"
               :source-ids nil
               :origin :asserted
               :validation-records nil
               :integrity-records nil
               :visibility-records nil
               :determinacy (make-determinacy :mode :determinate :evidence nil)
               :bounded-unknowns nil)))
        (derive-claim source
                      (make-identity :claim "vinc-mut-derived")
                      "vinculum derived content"
                      (make-identity :receipt "vinc-mut-transform-receipt")
                      (make-determinacy :mode :determinate :evidence nil)
                      :validation-transfer-license
                      (make-identity :procedure "vinc-mut-any-proc")))))
  ;; N1: an authorizing-basis that is not a durable identity (arbitrary string)
  ;; is a shape fault — refused MALFORMED-CONSTRUCTOR-SHAPE K0E-20.
  (expect-mutant-killed "authorizing-basis-arbitrary-object"
    'malformed-constructor-shape "K0E-20"
    (lambda ()
      (make-visibility-record
       :status :withheld
       :subject-id (make-identity :claim "vinc-mut-a")
       :representation-id "vinculum mutant content"
       :scope-id '(:audience :vinc-readers)
       :authorizing-basis "an arbitrary string is not a durable identity")))
  ;; -------------------------------------------------------------------------
  ;; Hostile-review repair mutants — IANUS-II (procedure.lisp/outcome.lisp:
  ;; R1 K0E-25 domain+evidence, R2 K0E-23 version binding, R3 K0E-26 verdict
  ;; identity/reason).  Transcribed from wr2-ianus2-probe.lisp.
  ;; -------------------------------------------------------------------------
  ;; R1: manifestation KIND outside the descriptor's :kinds domain.
  (expect-mutant-killed "semantic-domain-rejects-kind"
    'interpretation-class-violation "K0E-25"
    (lambda ()
      (validate-interpretation-against-descriptor
       (ianus-accepted-axis)
       (ianus-semantic-descriptor :kinds '(:tool-result)) ; excludes :subject-answer
       :manifestation (ianus-present-manifestation :kind :subject-answer))))
  ;; R1: manifestation STATUS outside the descriptor's :statuses domain.
  (expect-mutant-killed "semantic-domain-rejects-status"
    'interpretation-class-violation "K0E-25"
    (lambda ()
      (validate-interpretation-against-descriptor
       (ianus-accepted-axis)
       (ianus-semantic-descriptor :statuses '(:present-empty)) ; excludes :present
       :manifestation (ianus-present-manifestation :status :present))))
  ;; R1: a required evidence identity absent from the axis evidence.
  (expect-mutant-killed "semantic-required-evidence-missing"
    'interpretation-class-violation "K0E-25"
    (lambda ()
      (validate-interpretation-against-descriptor
       (ianus-accepted-axis :evidence (list *ianus-ev-a*))       ; lacks ev-b
       (ianus-semantic-descriptor :evidence-requirements (list *ianus-ev-b*))
       :manifestation (ianus-present-manifestation))))
  ;; R1: the axis carries evidence, but the WRONG identity for the requirement.
  (expect-mutant-killed "semantic-required-evidence-wrong"
    'interpretation-class-violation "K0E-25"
    (lambda ()
      (validate-interpretation-against-descriptor
       (ianus-accepted-axis :evidence (list *ianus-ev-a*))       ; has A, needs B
       (ianus-semantic-descriptor :evidence-requirements (list *ianus-ev-b*))
       :manifestation (ianus-present-manifestation))))
  ;; R2: axis binds version 2; descriptor is version 1 — version drift.
  (expect-mutant-killed "procedure-version-drift"
    'interpretation-class-violation "K0E-23"
    (lambda ()
      (validate-interpretation-against-descriptor
       (ianus-accepted-axis :procedure-version 2)
       (ianus-semantic-descriptor :version 1)
       :manifestation (ianus-present-manifestation))))
  ;; R2: same id/version, but the axis caches a conflicting :structural class.
  ;; (Construction forbids :structural + :accepted, so the conflict rides an
  ;;  :invalid-valued axis whose cache disagrees with the semantic descriptor.)
  (expect-mutant-killed "same-id-version-conflicting-class"
    'interpretation-class-violation "K0E-23"
    (lambda ()
      (validate-interpretation-against-descriptor
       (make-interpretation-axis
        :value :invalid
        :determinacy (make-determinacy :mode :determinate :evidence nil)
        :procedure-id *ianus-proc-id*
        :judgment-class :structural
        :procedure-version *ianus-version*)
       (ianus-semantic-descriptor))))              ; descriptor class is :semantic
  ;; R2: an :accepted axis with NEITHER a version NOR a class cache — the
  ;; omitted cache would let the caller select any semantic descriptor.
  (expect-mutant-killed "cache-omitted-descriptor-substitution"
    'interpretation-class-violation "K0E-23"
    (lambda ()
      (validate-interpretation-against-descriptor
       (ianus-accepted-axis :judgment-class nil :procedure-version nil)
       (ianus-semantic-descriptor)
       :manifestation (ianus-present-manifestation))))
  ;; ARGUS-II F1 (2026-07-19): a CLASS-ONLY :accepted axis must refuse — class
  ;; does not pin the descriptor version, so a class-only reference validated
  ;; against v5 AND v99 of one procedure identity before the rule-(o) repair.
  ;; This plants that exact reproduction forever.
  (expect-mutant-killed "class-only-version-substitution"
    'interpretation-class-violation "K0E-23"
    (lambda ()
      (validate-interpretation-against-descriptor
       (ianus-accepted-axis :judgment-class :semantic :procedure-version nil)
       (ianus-semantic-descriptor)
       :manifestation (ianus-present-manifestation))))
  ;; R3: a :pass verdict with no procedure identity — anonymous standing.
  (expect-mutant-killed "anonymous-structural-pass"
    'malformed-constructor-shape "K0E-26"
    (lambda () (make-verdict :value :pass)))
  ;; R3: a :fail verdict with a reason but NO procedure identity.
  (expect-mutant-killed "anonymous-semantic-fail"
    'malformed-constructor-shape "K0E-26"
    (lambda () (make-verdict :value :fail :requirement-ids (list "K0E-25"))))
  ;; R3: a :fail that names a procedure but carries NO condition-id and NO
  ;; requirement-id — a reasonless, uninspectable failure.
  (expect-mutant-killed "reasonless-fail"
    'malformed-constructor-shape "K0E-26"
    (lambda () (make-verdict :value :fail
                             :procedure-id (make-identity :procedure "wr2-fail-proc"))))
  ;; -------------------------------------------------------------------------
  ;; Hostile-review-2 repair mutants — CLAUSTRUM (outcome.lisp/procedure.lisp:
  ;; B1 K0E-25 mandatory semantic gate on the PUBLIC outcome path, B2 K0E-23
  ;; immutable integer version, R3 K0E-23 refusal-safe nested descriptor schema).
  ;; Transcribed from wr5-claustrum-probe.lisp.  EVERY B1 mutant runs through
  ;; MAKE-OUTCOME, never a direct validator call.
  ;; -------------------------------------------------------------------------
  ;; B1: no descriptor supplied to the public outcome constructor for an
  ;; :accepted interpretation — the walk-around the review named.
  (expect-mutant-killed "accepted-outcome-without-descriptor"
    'interpretation-class-violation "K0E-25"
    (lambda () (claustrum-build-outcome (claustrum-interp-axis :accepted))))
  (expect-mutant-killed "rejected-outcome-without-descriptor"
    'interpretation-class-violation "K0E-25"
    (lambda () (claustrum-build-outcome (claustrum-interp-axis :rejected))))
  ;; B1: descriptor IS supplied, but its :input-domain excludes the outcome's own
  ;; manifestation kind — the validator now fires ON THE PRODUCTION PATH.
  (expect-mutant-killed "accepted-outcome-domain-bypass"
    'interpretation-class-violation "K0E-25"
    (lambda ()
      (claustrum-build-outcome
       (claustrum-interp-axis :accepted)
       :descriptor (claustrum-semantic-descriptor :kinds '(:tool-result)))))
  ;; B1: descriptor requires evidence the axis does not carry — caught in MAKE-OUTCOME.
  (expect-mutant-killed "accepted-outcome-evidence-bypass"
    'interpretation-class-violation "K0E-25"
    (lambda ()
      (claustrum-build-outcome
       (claustrum-interp-axis :accepted :evidence (list *claustrum-ev-a*))
       :descriptor (claustrum-semantic-descriptor
                    :evidence-requirements (list *claustrum-ev-b*)))))
  ;; B2: a NIL descriptor version — the closed canonical version is a nonnegative
  ;; integer, so NIL is refused.
  (expect-mutant-killed "descriptor-nil-version"
    'malformed-constructor-shape "K0E-23"
    (lambda () (claustrum-semantic-descriptor :version nil)))
  ;; B2: a non-integer host object supplied as an axis version cache.
  (expect-mutant-killed "axis-noncanonical-version-object"
    'malformed-constructor-shape "K0E-23"
    (lambda () (claustrum-interp-axis :accepted :procedure-version "1")))
  ;; B2 IMPOSSIBLE-BY-REPRESENTATION: the review's mutable-shared-version-alias
  ;; AND descriptor-version-accessor-alias both depend on ONE MUTABLE object (a
  ;; list/string) stored raw in the descriptor AND the axis, so `(setf (car v) 99)`
  ;; would rewrite both while the comparison keeps passing.  Under B2 the
  ;; canonical version is a NONNEGATIVE INTEGER: immutable, un-aliasable, and a
  ;; mutable object is REFUSED at the door — so neither alias mutant has any
  ;; reachable constructed state to mutate.  This type-refusal IS their execution:
  ;; a list version never reaches storage.  (Two review mutants, one impossibility.)
  (expect-mutant-killed "descriptor-list-version-refused"
    'malformed-constructor-shape "K0E-23"
    (lambda () (claustrum-semantic-descriptor :version (list 1))))
  ;; R3: :input-domain is an atom, not a plist.
  (expect-mutant-killed "descriptor-input-domain-atom"
    'malformed-constructor-shape "K0E-23"
    (lambda ()
      (make-procedure-descriptor
       :procedure-id *claustrum-proc-id* :version *claustrum-version*
       :judgment-class :semantic
       :input-domain :not-a-plist
       :result-vocabulary '(:accepted) :evidence-requirements nil)))
  ;; R3: :input-domain is an odd-length plist.
  (expect-mutant-killed "descriptor-input-domain-odd-plist"
    'malformed-constructor-shape "K0E-23"
    (lambda ()
      (make-procedure-descriptor
       :procedure-id *claustrum-proc-id* :version *claustrum-version*
       :judgment-class :semantic
       :input-domain '(:kinds)
       :result-vocabulary '(:accepted) :evidence-requirements nil)))
  ;; R3: :input-domain repeats a key.
  (expect-mutant-killed "descriptor-input-domain-duplicate-key"
    'malformed-constructor-shape "K0E-23"
    (lambda ()
      (make-procedure-descriptor
       :procedure-id *claustrum-proc-id* :version *claustrum-version*
       :judgment-class :semantic
       :input-domain '(:kinds (:subject-answer) :kinds (:tool-result))
       :result-vocabulary '(:accepted) :evidence-requirements nil)))
  ;; R3: :input-domain carries a key outside {:kinds,:statuses}.
  (expect-mutant-killed "descriptor-input-domain-unknown-key"
    'malformed-constructor-shape "K0E-23"
    (lambda ()
      (make-procedure-descriptor
       :procedure-id *claustrum-proc-id* :version *claustrum-version*
       :judgment-class :semantic
       :input-domain '(:kinds (:subject-answer) :flavors (:vanilla))
       :result-vocabulary '(:accepted) :evidence-requirements nil)))
  ;; R3: an :evidence-requirements entry that is not a durable identity — a
  ;; descriptor-shape defect at construction, NOT a deferred unsatisfied-evidence.
  (expect-mutant-killed "descriptor-evidence-requirement-nonidentity"
    'malformed-constructor-shape "K0E-23"
    (lambda ()
      (make-procedure-descriptor
       :procedure-id *claustrum-proc-id* :version *claustrum-version*
       :judgment-class :semantic
       :input-domain nil
       :result-vocabulary '(:accepted)
       :evidence-requirements (list :not-a-durable-identity))))
  ;; -------------------------------------------------------------------------
  ;; Hostile-review-2 repair mutants — NEXUS (records.lisp/manifestation.lisp:
  ;; B3 K0E-20 visibility representation binding, R1 K0E-20 authorizing-basis
  ;; domain restriction, N2 K0E-28 streamed⇒adapter).  Transcribed from
  ;; wr6-nexus-probe.lisp.
  ;; -------------------------------------------------------------------------
  ;; B3: a published visibility record naming THIS claim as subject but a FOREIGN
  ;; representation (R).  Subject check passes; only the new representation check
  ;; catches it -> STANDING-INFLATION K0E-20.
  (expect-mutant-killed "foreign-representation-visibility-same-subject"
    'standing-inflation "K0E-20"
    (lambda ()
      (nexus-home-claim
       :visibility
       (list (make-visibility-record
              :status :published
              :subject-id *nexus-claim-s-id*      ; SAME subject as the home claim
              :representation-id *nexus-rep-r*      ; FOREIGN representation
              :scope-id *nexus-scope*)))))
  ;; B3 redaction collapse: a published record over the redacted/public R attached
  ;; to a claim whose canonical content is the full/private S -> STANDING-INFLATION K0E-20.
  (expect-mutant-killed "redacted-representation-publishes-full-claim"
    'standing-inflation "K0E-20"
    (lambda ()
      (nexus-home-claim
       :content *nexus-rep-s*
       :visibility
       (list (make-visibility-record
              :status :published
              :subject-id *nexus-claim-s-id*
              :representation-id *nexus-rep-r*      ; publishes R, not S
              :scope-id *nexus-scope*)))))
  ;; B3 defensive recheck: %VALIDATED-CLAIM now refuses a mismatched-representation
  ;; record at construction, so the query defense is unreachable through
  ;; MAKE-CLAIM.  Simulate "a constructor bug that let one through" via the
  ;; low-level %MAKE-CLAIM and assert CLAIM-PUBLISHED-TO-P independently refuses it
  ;; (subject matches, isolating the representation defense).
  (expect-query-mutant-killed "publication-query-ignores-representation" "K0E-20"
    (lambda ()
      (let* ((content-s (require-canonical *nexus-rep-s*))
             (published-over-r
               (make-visibility-record
                :status :published
                :subject-id *nexus-claim-s-id*        ; SAME subject
                :representation-id *nexus-rep-r*        ; DIFFERENT representation
                :scope-id *nexus-scope*))
             (bugged-claim
               (lisp-plus-kernel0::%make-claim
                *nexus-claim-s-id* content-s nil :asserted
                nil nil (list published-over-r) (nexus-det) nil)))
        (not (claim-published-to-p bugged-claim *nexus-scope*)))))
  ;; R1: a present :authorizing-basis in the :store domain is a durable identity
  ;; but outside the {:claim,:capability} schema domains -> MALFORMED-CONSTRUCTOR-SHAPE K0E-20.
  (expect-mutant-killed "authorizing-basis-store-identity"
    'malformed-constructor-shape "K0E-20"
    (lambda ()
      (make-visibility-record
       :status :published
       :subject-id *nexus-claim-s-id*
       :representation-id *nexus-rep-s*
       :scope-id *nexus-scope*
       :authorizing-basis (make-identity :store "nexus-store-basis"))))
  (expect-mutant-killed "authorizing-basis-effect-identity"
    'malformed-constructor-shape "K0E-20"
    (lambda ()
      (make-visibility-record
       :status :published
       :subject-id *nexus-claim-s-id*
       :representation-id *nexus-rep-s*
       :scope-id *nexus-scope*
       :authorizing-basis (make-identity :effect "nexus-effect-basis"))))
  ;; N2: a streamed manifestation on the non-AP0 :producer-identity branch is
  ;; refused -> MALFORMED-CONSTRUCTOR-SHAPE K0E-28.  The stream relation itself is
  ;; a valid :direct-chunk (one chunk, no receipt), so ONLY the N2 producer/stream
  ;; gate can be what catches it.
  (expect-mutant-killed "streamed-on-producer-branch"
    'malformed-constructor-shape "K0E-28"
    (lambda ()
      (make-manifestation
       :manifestation-id (make-identity :manifestation "nexus-sop-m")
       :attempt-id (make-identity :attempt "nexus-sop-a")
       :kind :subject-answer
       :status :present-partial
       :payload-id (make-identity :manifestation "nexus-sop-payload")
       :source-boundary :negative-control
       :producer-identity (make-identity :principal "nexus-sop-producer")
       :stream-relation
       (list :stream-id (make-identity :store "nexus-sop-stream")
             :relation-kind :direct-chunk
             :chunk-record-ids (list (make-identity :store "nexus-sop-c0"))))))
  ;; -------------------------------------------------------------------------
  ;; GPT hostile pass 3: exact descriptor binding for every procedure-relative
  ;; interpretation, including :invalid (K0E-23/K0E-25).
  ;; -------------------------------------------------------------------------
  (expect-mutant-killed "invalid-outcome-without-descriptor"
    'interpretation-class-violation "K0E-23"
    (lambda ()
      (let* ((base (lisp-plus-kernel0::make-fixture-23-6-present-invalid)))
        (make-outcome
         :process-id (outcome-process-id base)
         :logical-operation-id (outcome-logical-operation-id base)
         :seat-id (outcome-seat-id base)
         :attempt-id (outcome-attempt-id base)
         :execution (outcome-axis base :execution)
         :manifestation (outcome-axis base :manifestation)
         :effects (outcome-axis base :effects)
         :interpretation (gpt3-invalid-axis)))))
  (expect-mutant-killed "unversioned-invalid-interpretation"
    'interpretation-class-violation "K0E-23"
    (lambda ()
      (make-interpretation-axis
       :value :invalid
       :determinacy (make-determinacy :mode :determinate :evidence nil)
       :procedure-id (make-identity :procedure "gpt3-unversioned-invalid"))))
  (expect-mutant-killed "unversioned-refused-interpretation"
    'interpretation-class-violation "K0E-23"
    (lambda ()
      (make-interpretation-axis
       :value :refused
       :determinacy (make-determinacy :mode :determinate :evidence nil)
       :procedure-id (make-identity :procedure "gpt3-unversioned-refused"))))
  (handler-case
      (let* ((base (lisp-plus-kernel0::make-fixture-23-6-present-invalid))
             (descriptor (outcome-interpretation-descriptor base)))
        (if (and (procedure-descriptor-p descriptor)
                 (identity=
                  (procedure-descriptor-procedure-id descriptor)
                  (axis-procedure-id (outcome-axis base :interpretation)))
                 (eql (procedure-descriptor-version descriptor)
                      (axis-procedure-version
                       (outcome-axis base :interpretation))))
            (progn
              (push (list "descriptor-erasure-after-validation"
                          :inspection "K0E-23")
                    *mutants-killed*)
              (format t "MUTANT descriptor-erasure-after-validation: KILLED (outcome retains exact descriptor / K0E-23)~%"))
            (error "outcome did not retain its exact interpretation descriptor")))
    (condition (condition)
      (push (cons "descriptor-erasure-after-validation" condition)
            *mutants-survived*)
      (format t "MUTANT descriptor-erasure-after-validation: SURVIVED-OR-WRONG-REASON (~A)~%"
              condition)))
  ;; Non-signaling mutants killed by structural/absence checks (see controls):
  (format t "MUTANT call-296-counted-complete: KILLED (named-exclusion reporting, control 6 / K0E-5a)~%")
  (push (list "call-296-counted-complete" :report-bites "K0E-5a") *mutants-killed*)
  (format t "MUTANT context-free-standing-accessor: KILLED (no verified-p/published-p symbol, control 19 / K0E-22)~%")
  (push (list "context-free-standing-accessor" :absence "K0E-22") *mutants-killed*)
  (format t "MUTANT partial-erasure: KILLED (read-only surface, no mutation function, control 26 / K0E-31)~%")
  (push (list "partial-erasure" :read-only "K0E-31") *mutants-killed*))

(defun complete-numbering-p ()
  (let ((all
          (sort
           (append (copy-list *implemented-test-numbers*)
                   (mapcar #'car *excluded-tests*))
           #'<)))
    (equal all (loop for number from 1 to 56 collect number))))

(defun run-selftest ()
  (setf *passed-tests* nil
        *failed-tests* nil
        *negative-controls-fired* nil
        *negative-controls-failed* nil
        *controls-fired* nil
        *controls-excluded* nil
        *controls-failed* nil
        *mutants-killed* nil
        *mutants-survived* nil
        *report-bites-fired* nil
        *report-bites-failed* nil)
  (format t "kernel0 selftest: Kernel /0 pure core + Errata 0.2, 2026-07-19~%")
  (run-fixture-tests)
  (run-identity-tests)
  (run-authority-data-test)
  (run-effect-tests)
  (run-store-fold-tests)
  (run-claim-standing-tests)
  (run-standing-record-tests)
  (run-boundary-tests)
  (report-exclusions)
  (run-negative-controls)
  (format t "~%--- Errata 0.2 §8 named exclusions (K0E-5a) ---~%")
  (report-named-exclusions)
  (format t "~%--- Errata 0.2 §8 controls ---~%")
  (run-erratum-controls)
  (format t "~%--- Errata 0.2 §8 planted mutants ---~%")
  (run-planted-mutants)
  ;; Control 29 (meta): every planted defect fails for the INTENDED requirement.
  (if (and (null *controls-failed*) (null *mutants-survived*))
      (progn
        (push 29 *controls-fired*)
        (format t "CONTROL 29 [K0E-33]: FIRED (all planted defects failed for the intended requirement — zero controls failed, zero mutants survived)~%"))
      (progn
        (push (cons 29 "planted defects did not all fail for the intended requirement")
              *controls-failed*)
        (format t "CONTROL 29 [K0E-33]: FAILED (a control failed or a mutant survived)~%")))
  (unless (complete-numbering-p)
    (push (cons :numbering
                "implemented/excluded test sets do not partition 1..56")
          *failed-tests*))
  (let* ((passed (sort (copy-list *passed-tests*) #'<))
         (failed
           (sort (remove-if-not #'integerp
                                (mapcar #'car *failed-tests*))
                 #'<))
         (excluded (mapcar #'car *excluded-tests*))
         (controls-fired (sort (copy-list *controls-fired*) #'<))
         (controls-excluded (sort (copy-list *controls-excluded*) #'<))
         ;; N2 (hostile review §10): a "mutant kill" backed by a control rather
         ;; than an independently executed mutation path is a RE-ATTRIBUTION,
         ;; and every summary that prints the total MUST print the split.
         ;; Re-attributions are the non-signaling entries whose expected-type
         ;; is a control marker (:report-bites / :absence / :read-only); every
         ;; independent mutant carries a condition type (or NIL) instead.
         (mutants-killed-count (length *mutants-killed*))
         (mutant-reattributions
           (count-if (lambda (entry)
                       (member (second entry)
                               '(:report-bites :absence :read-only)))
                     *mutants-killed*))
         (mutant-independent (- mutants-killed-count mutant-reattributions))
         (failure-count
           (+ (length *failed-tests*)
              (length *negative-controls-failed*)
              (length *controls-failed*)
              (length *mutants-survived*)
              (length *report-bites-failed*)))
         (expected-controls '("a" "b" "c" "d" "e" "f" "g" "j"))
         (controls-complete-p
           (null
            (set-exclusive-or
             (copy-list expected-controls)
             (copy-list *negative-controls-fired*)
             :test #'string=))))
    (unless controls-complete-p
      (incf failure-count)
      (format t "negative-control coverage: FAILED (expected a,b,c,d,e,f,g,j)~%"))
    (format t "~%=== Kernel /0 Errata 0.2 conformance summary ===~%")
    (format t "implemented test numbers: ~{~D~^, ~}~%" passed)
    (format t "excluded test numbers: ~{~D~^, ~}~%" excluded)
    (format t "failing test numbers: ~:[none~;~:*~{~D~^, ~}~]~%" failed)
    (format t "negative controls: ~D fired, 2 excluded, ~D failed~%"
            (length *negative-controls-fired*)
            (length *negative-controls-failed*))
    (format t "named exclusions: ~{~A~^, ~}~%"
            (mapcar #'first *named-exclusions*))
    (format t "controls fired: ~{~D~^, ~}~%" controls-fired)
    (format t "controls excluded (named): ~{~D~^, ~}~%" controls-excluded)
    (format t "controls failed: ~:[none~;~:*~{~A~^, ~}~]~%"
            (mapcar (lambda (entry)
                      (if (consp entry) (car entry) entry))
                    *controls-failed*))
    (format t "planted mutants: ~D killed (~D independent + ~D re-attributions), ~D survived~%"
            mutants-killed-count mutant-independent mutant-reattributions
            (length *mutants-survived*))
    (format t "mutant kill list: ~{~A~^, ~}~%"
            (mapcar (lambda (entry)
                      (format nil "~A[~A]"
                              (first entry)
                              ;; NIL requirement-id = the kill law predates the
                              ;; errata (base-spec law, e.g. §8.4) or lives in
                              ;; the uniform strict-parse layer; print honestly
                              ;; instead of a bare NIL (ARGUS note, 2026-07-19).
                              (or (third entry) "base-spec")))
                    (reverse *mutants-killed*)))
    (format t "kernel0 selftest: ~D passed, ~D excluded (out-of-scope), ~D controls fired, ~D controls named-excluded, ~D mutants killed (~D independent + ~D re-attributions), ~D failed~%"
            (length passed) (length excluded)
            (length controls-fired) (length controls-excluded)
            mutants-killed-count mutant-independent mutant-reattributions
            failure-count)
    (sb-ext:exit :code (if (zerop failure-count) 0 1))))

(run-selftest)
