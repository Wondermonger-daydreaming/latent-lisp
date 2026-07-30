;;;; adapter0-selftest.lisp — Adapter Protocol /0 unit checks.
;;;;
;;;; Run:  sbcl --script mneme/adapter0/adapter0-selftest.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.
;;;;
;;;; DETERMINISM: no pid, timestamp, absolute path, or random identity is
;;;; printed.
;;;;
;;;; Gate teeth: with ADAPTER0_SELFTEST_PLANT_FAULT=1 this suite plants a
;;;; failing check and must exit 1; the final check spawns exactly that
;;;; child and watches the gate fire.
;;;;
;;;; — CLAVIGER-IV (Claude Fable 5 subagent), 2026-07-30

(load (merge-pathnames "load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-adapter0)

(defvar *checks* 0)
(defvar *failures* 0)

(defun check (description thunk)
  (incf *checks*)
  (let ((description (format nil description))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (if (eq outcome :ok)
        (format t "[~3,'0d] ok   ~a~%" *checks* description)
        (progn (incf *failures*)
               (format t "[~3,'0d] FAIL ~a~@[ (~a)~]~%" *checks* description
                       (when (consp outcome) (second outcome)))))))

(defun note (control &rest arguments)
  (apply #'format t control arguments)
  (terpri))

(note "adapter0-selftest — the membrane candidate's unit checks")
(note "governing refusal: do not translate provider ambiguity into kernel ~
       certainty; preserve the envelope, name the boundary, identify the ~
       witness, record who was exposed, and carry the unknown forward ~
       until evidence — not fluency — narrows it.~%")

;;; ---------------------------------------------------------------------------
(note "== Class A fixtures decode canonical ==")

(check "both canonical descriptors load and are distinct adapter ~
        identities (fake-reference-0, fake-limited-ack-0)"
  (lambda ()
    (load-canonical-descriptors)
    (and (descriptor-by-identity "fake-reference-0")
         (descriptor-by-identity "fake-limited-ack-0")
         (null (descriptor-by-identity "no-such-adapter")))))

(check "the full descriptor witnesses all eight §9 acknowledgment ~
        classes; the limited descriptor witnesses exactly ~
        {transport-accepted, no-acknowledgment}"
  (lambda ()
    (and (= 8 (length (descriptor-witnessable-classes
                       (descriptor-by-identity "fake-reference-0"))))
         (equal '("transport-accepted" "no-acknowledgment")
                (descriptor-witnessable-classes
                 (descriptor-by-identity "fake-limited-ack-0"))))))

(check "the absence table carries exactly the eleven §14/Appendix-C ~
        shapes (derived live from the fixture, not hardcoded counts ~
        elsewhere)"
  (lambda ()
    (load-absence-table)
    (equal '("missing" "explicit-null" "metadata-only" "empty-string"
             "empty-sequence" "invalid-utf8" "parser-rejected" "partial"
             "withheld" "redacted" "nonempty")
           (+absence-shapes+))))

(check "table rows map per the normative minimum: missing→absent+~
        absent-after-completion · empty-string→present-empty ·
        invalid-utf8→present-invalid · partial→present-partial ·
        nonempty→present"
  (lambda ()
    (flet ((row (shape) (absence-row-for-shape shape)))
      (and (equal "absent" (absence-row-status (row "missing")))
           (equal "absent-after-completion"
                  (absence-row-state (row "missing")))
           (equal "present-empty" (absence-row-status (row "empty-string")))
           (null (absence-row-state (row "empty-string")))
           (equal "present-invalid"
                  (absence-row-status (row "invalid-utf8")))
           (equal "present-partial" (absence-row-status (row "partial")))
           (equal "present" (absence-row-status (row "nonempty")))))))

(check "a shape outside the table is a MISS (returns no row — the caller ~
        must refuse, never improvise: AP-ABS-1)"
  (lambda () (null (absence-row-for-shape "provider-invented-shape-xyz"))))

(check "the registry's own scalar counts equal the counts DERIVED by ~
        folding its entries (48 positive, 33 adversarial, 81 entries) ~
        and the on-disk mutant enumeration equals mutant-count (20)"
  (lambda ()
    (multiple-value-bind (positive adversarial total) (derive-registry-counts)
      (and (= positive (registry-scalar "positive-count"))
           (= adversarial (registry-scalar "adversarial-count"))
           (= total (+ (registry-scalar "positive-count")
                       (registry-scalar "adversarial-count")))
           (= (registry-scalar "vector-count")
              (+ total (registry-scalar "mutant-count")))
           (= (registry-scalar "mutant-count")
              (length (enumerate-mutants)))))))

(check "every registry entry's path exists on disk and decodes canonical"
  (lambda ()
    (every (lambda (entry)
             (let ((path (merge-pathnames (registry-entry-path entry)
                                          +reissue-root+)))
               (and (probe-file path) (read-pjs-fixture path))))
           (registry-entries))))

;;; ---------------------------------------------------------------------------
(note "~%== the rule table ==")

(check "rule identities are unique"
  (lambda () (= (length (rule-ids))
                (length (remove-duplicates (rule-ids) :test #'string=)))))

(check "every frozen mutant's disabled-rule names an existing rule ~
        (the §24.2 vocabulary is implemented, not approximated)"
  (lambda ()
    (every (lambda (mutant)
             (rule-exists-p (case-string mutant "disabled-rule")))
           (enumerate-mutants))))

(check "closed vocabularies carry their normative sizes: 8 acknowledgment ~
        classes (§9) · 7 identity timings (§5.3) · 5 provider-testimony ~
        sources (AP-ID-3) · 4 cost standings (§16) · 9 reconciliation ~
        results (§18)"
  (lambda ()
    (and (= 8 (length +acknowledgment-classes+))
         (= 7 (length +request-identity-timings+))
         (= 5 (length +provider-testimony-sources+))
         (= 4 (length +cost-standings+))
         (= 9 (length +reconciliation-results+)))))

(defun synthetic-case (&rest field-specs)
  "Build an in-memory case record: alternating NAME VALUE-DATUM pairs."
  (make-record-datum
   (loop for (name value) on field-specs by #'cddr
         collect (make-record-entry (identifier-from-segments
                                     (list "ap0" name))
                                    value))))

(check "an exact rational amount string passes the money rule; a ~
        binary-float spelling and a decimal-point spelling both refuse ~
        cost-float-noncanonical (AP-COST-1)"
  (lambda ()
    (flet ((verdict-of (amount)
             (nth-value 1 (validate-case
                           (synthetic-case
                            "family" (%id "family" "cost")
                            "standing" (%str "estimated")
                            "amount" (%str amount))))))
      (and (null (verdict-of "249/100"))
           (null (verdict-of "-42"))
           (equal "cost-float-noncanonical" (verdict-of "binary-float:1.23"))
           (equal "cost-float-noncanonical" (verdict-of "1.23"))))))

(check "a synthetic identity-domain collapse — the local request identity ~
        offered as provider request identity (source local-identifier) — ~
        refuses provider-request-id-invented (AP-ID-3)"
  (lambda ()
    (multiple-value-bind (verdict condition)
        (validate-case (synthetic-case
                        "family" (%id "family" "request-identity")
                        "provider-request-id" (%str "lr-001")
                        "provider-request-source" (%str "local-identifier")
                        "provider-request-timing" (%str "pre-dispatch")))
      (and (eq verdict :reject)
           (equal condition "provider-request-id-invented")))))

(check "a duplicate chunk with ALTERED payload (duplicate-identical ~
        false) refuses stream-chunk-identity-collision (AP-STR-3); the ~
        same duplicate declared identical is idempotent (AP-STR-2)"
  (lambda ()
    (flet ((stream-case (identical)
             (synthetic-case
              "family" (%id "family" "stream")
              "adapter-identity" (%str "fake-reference-0")
              "stream-relation" (%bool t)
              "chunks" (make-sequence-datum (list (%int 1) (%int 1)))
              "duplicate-identical" (%bool identical)
              "persistence-order" (%str "journal-before-delivery")
              "history" (make-sequence-datum
                         (list (%str "chunk-captured")
                               (%str "chunk-journaled")
                               (%str "chunk-delivered"))))))
      (multiple-value-bind (bad-verdict bad-condition)
          (validate-case (stream-case nil))
        (and (eq bad-verdict :reject)
             (equal bad-condition "stream-chunk-identity-collision")
             (eq :accept (validate-case (stream-case t))))))))

(check "a stream claiming journal-before-delivery whose recorded history ~
        delivered first refuses stream-persistence-order-invalid (§10.5 ~
        is checked against the history, not the label)"
  (lambda ()
    (multiple-value-bind (verdict condition)
        (validate-case (synthetic-case
                        "family" (%id "family" "stream")
                        "adapter-identity" (%str "fake-reference-0")
                        "stream-relation" (%bool t)
                        "chunks" (make-sequence-datum (list (%int 1)))
                        "persistence-order" (%str "journal-before-delivery")
                        "history" (make-sequence-datum
                                   (list (%str "chunk-captured")
                                         (%str "chunk-delivered")
                                         (%str "chunk-journaled")))))
      (and (eq verdict :reject)
           (equal condition "stream-persistence-order-invalid")))))

(check "an undeclared intermediary refuses exposed-principal-drift ~
        (AP-EXP-4)"
  (lambda ()
    (multiple-value-bind (verdict condition)
        (validate-case (synthetic-case
                        "family" (%id "family" "exposure")
                        "provider-principal" (%bool t)
                        "invoker-exposed" (%bool t)
                        "undeclared-intermediary" (%bool t)))
      (and (eq verdict :reject)
           (equal condition "exposed-principal-drift")))))

(check "a cancellation erasing partials refuses ~
        partial-manifestation-erasure (AP-CAN-3)"
  (lambda ()
    (multiple-value-bind (verdict condition)
        (validate-case (synthetic-case
                        "family" (%id "family" "cancellation")
                        "cancel-class" (%str "local-interrupt-only")
                        "partial-preserved" (%bool nil)))
      (and (eq verdict :reject)
           (equal condition "partial-manifestation-erasure")))))

(check "a W2 fold claim of absent (journal available) refuses ~
        partial-manifestation-erasure; W1 claiming settled-no-effect ~
        refuses reconciliation-insufficient (§11 dispositions)"
  (lambda ()
    (flet ((window-case (window fold)
             (synthetic-case
              "family" (%id "family" "crash-window")
              "window" (%str window)
              "journal-available" (%bool t)
              "frontier-crossed" (%bool t)
              "expected-fold" (%str fold))))
      (multiple-value-bind (v2 c2) (validate-case (window-case "W2" "absent"))
        (multiple-value-bind (v1 c1)
            (validate-case (window-case "W1" "no-effect"))
          (and (eq v2 :reject)
               (equal c2 "partial-manifestation-erasure")
               (eq v1 :reject)
               (equal c1 "reconciliation-insufficient")))))))

;;; ---------------------------------------------------------------------------
(note "~%== the owner's non-equivalences, held mechanically ==")

(defvar *live* (bind-live-adapter (descriptor-by-identity "fake-reference-0")
                                  :instance-label "selftest-live"))

(check "descriptor ≠ live adapter object: binding a live adapter where a ~
        descriptor belongs refuses; describing a descriptor (not a live ~
        object) refuses; the two are distinct host types"
  (lambda ()
    (and (live-adapter-p *live*)
         (record-datum-p (describe-adapter *live*))
         (handler-case (progn (bind-live-adapter *live*) nil)
           (adapter-descriptor-invalid () t))
         (handler-case (progn (describe-adapter
                               (descriptor-by-identity "fake-reference-0"))
                              nil)
           (adapter-descriptor-invalid () t)))))

(defvar *prepared*
  (prepare-invocation *live*
                      (make-invocation-spec
                       :logical-operation-id "op-selftest"
                       :seat-id "seat-selftest"
                       :attempt-id "attempt-selftest"
                       :run-label "selftest")))

(check "prepared ≠ dispatched: preparation yields a prepared record, not ~
        a dispatch handle; local request identity is bound pre-frontier ~
        (AP-ID-1) and the provider idempotency slot is a SEPARATE field ~
        holding #u (local ≠ idempotency ≠ provider identity)"
  (lambda ()
    (let ((record (prepared-invocation-record-record *prepared*)))
      (and (prepared-invocation-p *prepared*)
           (not (dispatch-handle-p *prepared*))
           (equal "lr-selftest-1"
                  (prepared-invocation-record-local-request-id *prepared*))
           (record-datum-p record)
           (equal "lr-selftest-1" (case-string record "local-request-id"))
           (case-field-present-p record "provider-idempotency-id")
           (unit-datum-p (case-field record "provider-idempotency-id"))))))

(check "requested alias ≠ resolved machine identity: the prepared record ~
        binds declared AND resolved configuration as separate fields ~
        (AP-ID-7)"
  (lambda ()
    (let ((record (prepared-invocation-record-record *prepared*)))
      (and (case-field-present-p record "declared-machine-configuration-id")
           (case-field-present-p record
                                 "resolved-machine-configuration-id")))))

(defvar *handle* (dispatch *prepared* :live-adapter *live*))

(check "dispatch ≠ acknowledgment: the dispatch record carries crossing ~
        evidence and NO acknowledgment class; the provider request ~
        identity slot at dispatch is #u under the acknowledgment timing ~
        class — never minted (AP-ID-3)"
  (lambda ()
    (let ((record (dispatch-handle-dispatch-record *handle*)))
      (and (dispatch-handle-p *handle*)
           (case-field-present-p record "crossing-evidence")
           (not (case-field-present-p record "ack-class"))
           (unit-datum-p (case-field record "provider-request-id"))))))

(check "a second dispatch of the SAME preparation refuses with Kernel ~
        /0's unsafe-retry (AP-DSP-3: retry ≠ innocent repetition)"
  (lambda ()
    (handler-case (progn (dispatch *prepared* :live-adapter *live*) nil)
      (unsafe-retry () t))))

(check "acknowledgment ≠ execution ≠ settlement: the acknowledgment ~
        record binds witness facets and a LEARNED provider request ~
        identity, and carries no settlement field at all (AP-ACK-4)"
  (lambda ()
    (let ((ack (observe-acknowledgment *handle*)))
      (and (record-datum-p ack)
           (equal "provider-received" (case-string ack "ack-class"))
           (equal "acknowledgment-field"
                  (case-string ack "provider-request-source"))
           (case-field-present-p ack "raw-evidence-id")
           (not (case-field-present-p ack "settlement"))))))

(check "journal-before-delivery holds on the live stream path: each chunk ~
        is in the durable trail BEFORE the sink sees it (§10.5)"
  (lambda ()
    (let ((delivered '()))
      (observe-stream *handle*
                      (lambda (chunk)
                        ;; At delivery time the chunk must already be the
                        ;; machine's newest trail record.
                        (push (eq chunk (first (%machine-records
                                                (dispatch-handle-machine
                                                 *handle*))))
                              delivered)))
      (and (= 2 (length delivered)) (every #'identity delivered)))))

(check "raw envelope ≠ projected manifestation: capture yields an ~
        envelope record (binary custody, octet count, integrity ~
        evidence); projection yields a SEPARATE receipt-bearing record ~
        with origin derived (AP-PRJ-6)"
  (lambda ()
    (let* ((envelope (await-terminal *handle*))
           (projection (project-envelope *live* *handle* "nonempty")))
      (and (record-datum-p envelope)
           (equal "binary" (case-string envelope "capture-mode"))
           (case-field-present-p envelope "raw-payload-octet-count")
           (record-datum-p projection)
           (not (eq envelope projection))
           (equal "derived" (case-string projection "output-origin"))
           (case-field-present-p projection "projection-receipt-id")
           (equal "present"
                  (case-string projection "kernel-manifestation-status"))))))

(check "projection refuses on a table miss instead of improvising ~
        (AP-ABS-1) — and the refusal names the shape"
  (lambda ()
    (handler-case (progn (project-envelope *live* *handle* "no-such-shape")
                         nil)
      (absence-mapping-table-miss (condition)
        (equal '("no-such-shape")
               (ap0-condition-identities condition))))))

(check "projection before capture refuses provider-envelope-missing ~
        (AP-ENV-4): a fresh handle with no envelope cannot be projected"
  (lambda ()
    (let* ((prepared (prepare-invocation
                      *live* (make-invocation-spec
                              :logical-operation-id "op-nocap"
                              :attempt-id "attempt-nocap"
                              :run-label "nocap")))
           (handle (dispatch prepared :live-adapter *live*)))
      (handler-case (progn (project-envelope *live* handle "nonempty") nil)
        (provider-envelope-missing () t)))))

(check "cancellation request ≠ cancellation settlement: the cancellation ~
        record says unsettled, residual effects possible, partials ~
        preserved (AP-CAN-1/3/4)"
  (lambda ()
    (let ((cancellation (cancel-request *handle* "whole-request")))
      (and (equal "unsettled" (case-string cancellation "settlement"))
           (eq :true (case-boolean cancellation
                                   "residual-effects-possible"))
           (eq :true (case-boolean cancellation "partials-preserved"))))))

(check "usage ≠ cost: extract-usage returns an adapter-measured usage ~
        record; extract-cost WITHOUT a price schedule returns a typed ~
        missing-cost marker — not zero, not free, not a number ~
        (AP-COST-4)"
  (lambda ()
    (let ((usage (extract-usage *live* *handle* "fake-usage-procedure-0"))
          (missing (extract-cost *live* *handle* "fake-cost-procedure-0")))
      (and (record-datum-p usage)
           (equal "adapter-measured" (case-string usage "source"))
           (missing-cost-marker-p missing)
           (not (record-datum-p missing))))))

(check "estimated ≠ billed: with a schedule the cost record is standing ~
        estimated with an exact rational amount; dashboard-confirmed is a ~
        DIFFERENT standing the fake never claims for itself (AP-COST-2/3)"
  (lambda ()
    (let ((cost (extract-cost *live* *handle* "fake-cost-procedure-0"
                              :price-schedule-id "fake-prices-v0")))
      (and (record-datum-p cost)
           (equal "estimated" (case-string cost "standing"))
           (equal "100/1000000" (case-string cost "amount"))))))

(check "reconciliation not-found ≠ proved no effect: not-found without a ~
        distinct completeness witness refuses (adapter-witness-boundary-~
        missing); with the full AP-REC-6 conjunction it settles; without ~
        the identity it refuses reconciliation-identity-missing"
  (lambda ()
    (and (handler-case
             (progn (reconcile-request *live* "st-1" :result "not-found"
                                       :provider-request-id "pr-x"
                                       :domain-complete t)
                    nil)
           (adapter-witness-boundary-missing () t))
         (handler-case
             (progn (reconcile-request *live* "st-2" :result "not-found"
                                       :domain-complete t)
                    nil)
           (reconciliation-identity-missing () t))
         (let ((record (reconcile-request
                        *live* "st-3" :result "not-found"
                        :provider-request-id "pr-x"
                        :domain-complete t
                        :completeness-witness
                        '(:evidence-id "e-1"
                          :boundary "fake-provider-query-boundary"
                          :procedure-id "fake-domain-enumeration-0"
                          :standing "validated"
                          :origin "observed"))))
           (eq :true (case-boolean record "settles-no-effect"))))))

(check "adapter testimony ≠ boundary observation: a self-report filed as ~
        observed refuses (AP-JRN-1/PJ-WIT-1)"
  (lambda ()
    (multiple-value-bind (verdict condition)
        (validate-case (synthetic-case
                        "family" (%id "family" "witnessing")
                        "self-report-origin" (%str "observed")))
      (and (eq verdict :reject)
           (equal condition "adapter-witness-boundary-missing")))))

(check "execution ≠ manifestation: the ABSENT script executes to ~
        completion and manifests NOTHING — terminal ~
        absent-after-completion, distinct from every present-class ~
        terminal (SCRIPT-ABSENT, §14)"
  (lambda ()
    (equal "absent-after-completion"
           (script-run-terminal (run-script (script-by-name
                                             "absent-after-completion"))))))

(check "partial stream ≠ nothing: the mid-stream kill (SCRIPT-W2) folds ~
        to present-partial, never absent (AP-STR-6/7)"
  (lambda ()
    (equal "present-partial"
           (script-run-terminal (run-script (script-by-name "mid-stream"))))))

;;; ---------------------------------------------------------------------------
(note "~%== script machine invariants ==")

(check "the machine's terminal is FOLD-DERIVED (AP-CRASH-1): no emitted ~
        record carries any resolved flag field"
  (lambda ()
    (every (lambda (record)
             (not (case-field-present-p record "resolved")))
           (script-run-records (run-script (script-by-name
                                            "present-terminal"))))))

(check "every emitted chunk record carries adapter identity and stream ~
        relation fields (AP-G4-1/AP-G4-2)"
  (lambda ()
    (let ((chunks (remove-if-not
                   (lambda (record)
                     (equal "stream-chunk" (%id-leaf record "record-kind")))
                   (script-run-records (run-script (script-by-name
                                                    "mid-stream"))))))
      (and (= 2 (length chunks))
           (every (lambda (chunk)
                    (and (case-field-present-p chunk "adapter-identity")
                         (case-field-present-p chunk "stream-id")
                         (case-field-present-p chunk "sequence-number")))
                  chunks)))))

(check "the planted :delivery-before-journal defect is KILLED by the ~
        machine's own custody guard (typed stream-persistence-order-~
        invalid), and the planted :erase-partials fold is KILLED by the ~
        declared-terminal comparison"
  (lambda ()
    (multiple-value-bind (killed-1) (run-planted-defect
                                     :delivery-before-journal)
      (multiple-value-bind (killed-2) (run-planted-defect :erase-partials)
        (and killed-1 killed-2)))))

(check "the crash boundary is honest: W1's surviving trail has dispatch ~
        but NO acknowledgment, envelope, or projection record"
  (lambda ()
    (let ((kinds (mapcar (lambda (record) (%id-leaf record "record-kind"))
                         (script-run-records
                          (run-script (script-by-name
                                       "post-send-pre-response"))))))
      (and (member "dispatch-record" kinds :test #'equal)
           (not (member "acknowledgment" kinds :test #'equal))
           (not (member "provider-envelope" kinds :test #'equal))
           (not (member "projection-receipt" kinds :test #'equal))))))

;;; ---------------------------------------------------------------------------
(note "~%== gate teeth ==")

(when (equal (sb-ext:posix-getenv "ADAPTER0_SELFTEST_PLANT_FAULT") "1")
  (check "PLANTED FAULT — this check must FAIL and the suite must exit 1"
    (lambda () nil)))

(unless (equal (sb-ext:posix-getenv "ADAPTER0_SELFTEST_PLANT_FAULT") "1")
  (check "the planted-fault gate FIRES: a child run with ~
          ADAPTER0_SELFTEST_PLANT_FAULT=1 exits 1 and its transcript ~
          carries FAIL PLANTED FAULT"
    (lambda ()
      (let* ((output (make-string-output-stream))
             (process (sb-ext:run-program
                       "sbcl"
                       (list "--script"
                             "mneme/adapter0/adapter0-selftest.lisp")
                       :search t
                       :output output :error output
                       :environment (cons "ADAPTER0_SELFTEST_PLANT_FAULT=1"
                                          (sb-ext:posix-environ))))
             (text (get-output-stream-string output)))
        (and (eql 1 (sb-ext:process-exit-code process))
             (search "FAIL PLANTED FAULT" text))))))

;;; ---------------------------------------------------------------------------

(format t "~%adapter0-selftest: ~a check~:p, ~a failure~:p~%"
        *checks* *failures*)
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
