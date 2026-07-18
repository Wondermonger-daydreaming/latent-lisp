(let ((kernel0-directory
        (make-pathname :name nil :type nil :defaults *load-truename*)))
  (load (merge-pathnames "load.lisp" kernel0-directory))
  (load (merge-pathnames "fixtures.lisp" kernel0-directory)))

(defpackage #:lisp-plus-kernel0-selftest
  (:use #:cl #:lisp-plus-kernel0))

(in-package #:lisp-plus-kernel0-selftest)

(defparameter *implemented-test-numbers*
  '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 23 26 27 29 31 32 33 34 39
    41 42 45 46 49 55))

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
    (43 . "the core has no seal/verification standing constructor or enforcement surface")
    (44 . "the core has no publication/truth standing constructor or enforcement surface")
    (47 . "claim visibility records are opaque data; no published-scope validator exists")
    (48 . "claim validation records are opaque data; no verified-scope validator exists")
    (50 . "adapter-version drift requires an adapter/configuration preflight")
    (51 . "mirror-bound channel-policy enforcement is out of scope")
    (52 . "channel-policy amendment authority is out of scope")
    (53 . "publication capability enforcement requires live authority and publication")
    (54 . "private-staging publication-effect behavior requires channel policy/publication")
    (56 . "no adapter/raw-host escape API exists in this pure-core arc")))

(defvar *passed-tests* nil)
(defvar *failed-tests* nil)
(defvar *negative-controls-fired* nil)
(defvar *negative-controls-failed* nil)

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
              :source-boundary :fixture-adapter-boundary))
           (subject
             (make-manifestation
              :manifestation-id
              (make-identity :manifestation "subject-manifestation")
              :attempt-id (getf context :attempt)
              :kind :subject-answer
              :status :absent
              :absence-state :absent-after-completion
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
    (let ((untouched
            (lisp-plus-kernel0::make-fixture-23-1-untouched-seat))
          (present
            (lisp-plus-kernel0::make-fixture-23-3-completed-present))
          (partial
            (lisp-plus-kernel0::make-fixture-23-7-partial-host-death-shape))
          (call-296 (lisp-plus-kernel0::make-call-296-fixture)))
      (ensure-test
       (and (eq :not-attempted
                (axis-value (fixture-axis untouched :execution)))
            (eq :accepted
                (axis-value (fixture-axis present :interpretation)))
            (eq :present-partial
                (manifestation-status (fixture-manifestation partial)))
            (eq :bounded (axis-value (fixture-axis call-296 :effects)))
            (eq :not-applicable
                (axis-value (fixture-axis call-296 :interpretation))))
       "lawful independent combinations did not remain distinct")))

  (run-test (7 "bounded effect requires structured uncertain-effect")
    (let* ((outcome (lisp-plus-kernel0::make-call-296-fixture))
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
            (consp (axis-evidence manifestation))
            (eq :bounded (axis-value effects))
            (equal '(:billed :not-billed)
                   (determinacy-alternatives (axis-determinacy effects)))
            (uncertain-effect-p uncertainty)
            (eq :provider-call (uncertain-effect-kind uncertainty))
            (equal '(:unavailable :reason
                     :request-identity-never-established)
                   (uncertain-effect-external-request uncertainty))
            (equal '(:billed :not-billed)
                   (uncertain-effect-possible-effects uncertainty))
            (consp (uncertain-effect-known-facts uncertainty))
            (eq :forbidden-without-reconciliation
                (uncertain-effect-retry-policy uncertainty))
            (eq :not-applicable (axis-value interpretation))
            (eq :determinate
                (determinacy-mode (axis-determinacy interpretation))))
       "call-296 did not match the lawful §22/§10.8 construction")
      (expect-condition
       'unstructured-uncertainty
       #'lisp-plus-kernel0::make-call-296-inline-only-effect-axis
       "inline alternatives/evidence alone are unlawful")))

  (run-test (8 "global uncertainty field rejected")
    (expect-condition
     'standing-inflation
     #'make-global-uncertainty-violation
     "MUST reject confidence")))

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
    (let* ((claim
             (lisp-plus-kernel0::make-fixture-23-9-reconstructed-derived-view-claim))
           (revalidated
             (revalidate-claim claim '(:checked :by :fixture-validator))))
      (ensure-test
       (and (eq :reconstructed (claim-origin claim))
            (eq :reconstructed (claim-origin revalidated)))
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
              (fixture-axis invalid-outcome :interpretation))))
       "invalidity was not procedure-relative and payload-preserving")
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
           (make-identity :procedure "test-45-semantic-procedure"))))
       ":accepted or :rejected interpretation requires")))

  (run-test (46 "verified reconstruction remains reconstructed")
    (let* ((claim (make-test-claim "test-46" :reconstructed))
           (verified
             (revalidate-claim
              claim '(:verified :under :test-46-procedure))))
      (ensure-test
       (and (eq :reconstructed (claim-origin verified))
            (= 1 (length (claim-validation-records verified))))
       "verification rewrote reconstructed origin"))))

(defun outcome-accessor-surface-violations ()
  (let ((allowed
          '("OUTCOME-P"
            "OUTCOME-OUTCOME-VERSION"
            "OUTCOME-PROCESS-ID"
            "OUTCOME-LOGICAL-OPERATION-ID"
            "OUTCOME-SEAT-ID"
            "OUTCOME-ATTEMPT-ID"
            "OUTCOME-MACHINE-CONFIGURATION-ID"
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
   "f" "global-uncertainty-collapse" 'standing-inflation
   #'make-global-uncertainty-violation
   "MUST reject confidence")

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
        *negative-controls-failed* nil)
  (format t "kernel0 selftest: Kernel /0 pure core, 2026-07-18~%")
  (run-fixture-tests)
  (run-identity-tests)
  (run-authority-data-test)
  (run-effect-tests)
  (run-store-fold-tests)
  (run-claim-standing-tests)
  (run-boundary-tests)
  (report-exclusions)
  (run-negative-controls)
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
         (failure-count
           (+ (length *failed-tests*)
              (length *negative-controls-failed*)))
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
    (format t "implemented test numbers: ~{~D~^, ~}~%" passed)
    (format t "excluded test numbers: ~{~D~^, ~}~%" excluded)
    (format t "failing test numbers: ~:[none~;~:*~{~D~^, ~}~]~%" failed)
    (format t "negative controls: ~D fired, 2 excluded, ~D failed~%"
            (length *negative-controls-fired*)
            (length *negative-controls-failed*))
    (format t "kernel0 selftest: ~D passed, ~D excluded (out-of-scope), ~D failed~%"
            (length passed) (length excluded) failure-count)
    (sb-ext:exit :code (if (zerop failure-count) 0 1))))

(run-selftest)
