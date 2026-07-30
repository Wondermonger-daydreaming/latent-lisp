;;;; adapter0-controls.lisp — the permanent negative controls.
;;;;
;;;; Run:  sbcl --script mneme/adapter0/adapter0-controls.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.
;;;;
;;;; Each control proves ONE exact predicate: that a named forbidden
;;;; design, when presented, is refused BY THE IDENTIFIED LAW — a typed
;;;; condition or a rule-exact rejection, never a generic error.  A
;;;; control that has never fired is untested; every one of these fires
;;;; here, permanently.
;;;;
;;;; DETERMINISM: nothing time-, pid-, or path-dependent is printed.
;;;; Gate teeth: ADAPTER0_CONTROLS_PLANT_FAULT=1 exits 1 with a planted
;;;; FAIL; ADAPTER0_CONTROLS_DIE=1 exits 3 mid-run with no RESULT
;;;; sentinel.
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
        (format t "[C~3,'0d] ok   ~a~%" *checks* description)
        (progn (incf *failures*)
               (format t "[C~3,'0d] FAIL ~a~@[ (~a)~]~%" *checks* description
                       (when (consp outcome) (second outcome)))))))

(defun note (control &rest arguments)
  (apply #'format t control arguments)
  (terpri))

(defun frozen-case (relative-path)
  (read-pjs-fixture (merge-pathnames relative-path +reissue-root+)))

(defun rejects-with (case-record condition-name)
  (multiple-value-bind (verdict condition) (validate-case case-record)
    (and (eq verdict :reject) (equal condition condition-name))))

(note "adapter0-controls — every forbidden design, presented and refused")

(defvar *live* (bind-live-adapter (descriptor-by-identity "fake-reference-0")
                                  :instance-label "controls-live"))

;;; ---------------------------------------------------------------------------
(note "~%== identity and configuration ==")

(check "1 descriptor/live-object collapse: preparing against a bare ~
        descriptor record refuses adapter-descriptor-invalid (AP-DESC-1)"
  (lambda ()
    (handler-case
        (progn (prepare-invocation
                (descriptor-by-identity "fake-reference-0")
                (make-invocation-spec :logical-operation-id "op-c1"
                                      :attempt-id "a-c1" :run-label "c1"))
               nil)
      (adapter-descriptor-invalid () t))))

(check "2 identity-domain collapse: a local identifier offered as ~
        provider request identity refuses provider-request-id-invented ~
        (AP-ID-3), and the prepared record keeps local / idempotency / ~
        provider identities in three separate fields"
  (lambda ()
    (let ((prepared (prepare-invocation
                     *live* (make-invocation-spec
                             :logical-operation-id "op-c2"
                             :attempt-id "a-c2" :run-label "c2"))))
      (and (rejects-with
            (%rec '("ap0" "family") (%id "family" "request-identity")
                  '("ap0" "provider-request-id") (%str "lr-c2-1")
                  '("ap0" "provider-request-source") (%str "local-identifier")
                  '("ap0" "provider-request-timing") (%str "pre-dispatch"))
            "provider-request-id-invented")
           (let ((record (prepared-invocation-record-record prepared)))
             (and (case-field-present-p record "local-request-id")
                  (case-field-present-p record "provider-idempotency-id")
                  (not (case-field-present-p record
                                             "provider-request-id"))))))))

(check "3 implicit fallback: the frozen fallback fixture refuses ~
        implicit-provider-fallback, and a dispatch under a DIFFERENT ~
        resolved configuration than prepared refuses the same way ~
        (AP-ID-9: fallback ≠ continuation)"
  (lambda ()
    (and (rejects-with (frozen-case "vectors/adversarial/BAD-CFG-01.pjs")
                       "implicit-provider-fallback")
         (let ((prepared (prepare-invocation
                          *live* (make-invocation-spec
                                  :logical-operation-id "op-c3"
                                  :attempt-id "a-c3" :run-label "c3"))))
           (handler-case
               (progn (dispatch prepared :live-adapter *live*
                                :resolved-configuration-id
                                "some-other-configuration")
                      nil)
             (implicit-provider-fallback () t))))))

(check "4 blind retry: the frozen retry fixture refuses (AP-DSP-3), and ~
        re-dispatching an already-dispatched preparation signals Kernel ~
        /0's unsafe-retry"
  (lambda ()
    (and (rejects-with (frozen-case "vectors/adversarial/BAD-RETRY-01.pjs")
                       "reconciliation-insufficient")
         (let* ((prepared (prepare-invocation
                           *live* (make-invocation-spec
                                   :logical-operation-id "op-c4"
                                   :attempt-id "a-c4" :run-label "c4"))))
           (dispatch prepared :live-adapter *live*)
           (handler-case (progn (dispatch prepared :live-adapter *live*) nil)
             (unsafe-retry () t))))))

(check "21 adapter-version drift: a descriptor version change between ~
        preparation and dispatch refuses adapter-version-drift ~
        (AP-DESC-3) — drift is never accepted silently"
  (lambda ()
    (let ((prepared (prepare-invocation
                     *live* (make-invocation-spec
                             :logical-operation-id "op-c21"
                             :attempt-id "a-c21" :run-label "c21")))
          (drifted (bind-live-adapter
                    (descriptor-by-identity "fake-reference-0")
                    :instance-label "drifted")))
      (setf (live-adapter-descriptor-version drifted) "0.3.0-drifted")
      (handler-case (progn (dispatch prepared :live-adapter drifted) nil)
        (adapter-version-drift () t)))))

(check "22 alias/route drift: the resolved machine identity is bound at ~
        preparation (AP-ID-7); dispatch under a drifted resolution ~
        refuses rather than silently re-resolving (AP-ID-8)"
  (lambda ()
    (let ((prepared (prepare-invocation
                     *live* (make-invocation-spec
                             :logical-operation-id "op-c22"
                             :attempt-id "a-c22" :run-label "c22"
                             :resolved-configuration-id
                             "fake-model-configuration-0"))))
      (handler-case
          (progn (dispatch prepared :live-adapter *live*
                           :resolved-configuration-id
                           "fake-model-configuration-1-drifted")
                 nil)
        (implicit-provider-fallback () t)))))

;;; ---------------------------------------------------------------------------
(note "~%== acknowledgment and witnessing ==")

(check "5 acknowledgment promotion: the frozen promoted fixture refuses ~
        acknowledgment-ambiguous (AP-ACK-4), and a synthetic ~
        transport→terminal promotion refuses identically"
  (lambda ()
    (and (rejects-with (frozen-case "vectors/adversarial/BAD-ACK-01.pjs")
                       "acknowledgment-ambiguous")
         (rejects-with
          (%rec '("ap0" "family") (%id "family" "acknowledgment")
                '("ap0" "ack-class") (%str "transport-accepted")
                '("ap0" "promoted-to") (%str "provider-received")
                '("ap0" "adapter-descriptor-id")
                (%id "adapter" "fake-reference-0")
                '("ap0" "raw-evidence-id") (%str "e")
                '("ap0" "witness-boundary") (%str "fake-provider-boundary")
                '("ap0" "witness-procedure-id") (%str "p")
                '("ap0" "validation-standing") (%str "validated"))
          "acknowledgment-ambiguous"))))

(check "6 unwitnessable acknowledgment class: provider-terminal emitted ~
        under the limited descriptor (witnessable set = ~
        {transport-accepted, no-acknowledgment}) refuses ~
        adapter-witness-boundary-missing (AP-ACK-3)"
  (lambda ()
    (rejects-with (frozen-case "vectors/adversarial/BAD-ACK-RELABELLED.pjs")
                  "adapter-witness-boundary-missing")))

(check "16 self-certified reconciliation completeness: the frozen ~
        relabelled fixture refuses adapter-witness-boundary-missing ~
        (AP-REC-1), and the reconcile-request operation refuses the same ~
        conjunction gap live"
  (lambda ()
    (and (rejects-with (frozen-case
                        "vectors/adversarial/BAD-REC-RELABELLED.pjs")
                       "adapter-witness-boundary-missing")
         (handler-case
             (progn (reconcile-request *live* "c16" :result "not-found"
                                       :provider-request-id "pr-c16"
                                       :domain-complete t
                                       :completeness-witness
                                       '(:evidence-id "e"
                                         :boundary "b"
                                         :procedure-id "p"
                                         :standing "validated"
                                         :origin "asserted"))
                    nil)
           (adapter-witness-boundary-missing () t)))))

(check "15 cancellation promoted to no effect: socket closure claimed as ~
        provider settlement refuses cancellation-unconfirmed (AP-CAN-1), ~
        and provider-settled without a boundary witness refuses ~
        adapter-truth-minting (AP-CAN-6)"
  (lambda ()
    (and (rejects-with (frozen-case "vectors/adversarial/BAD-CAN-01.pjs")
                       "cancellation-unconfirmed")
         (rejects-with (frozen-case
                        "vectors/adversarial/BAD-CAN-RELABELLED.pjs")
                       "adapter-truth-minting"))))

;;; ---------------------------------------------------------------------------
(note "~%== stream custody ==")

(check "7 delivery before journal: the frozen undeclared-DBJ fixture ~
        refuses stream-persistence-order-invalid (§10.5), and the ~
        machine's planted :delivery-before-journal defect is killed by ~
        its own custody guard"
  (lambda ()
    (and (rejects-with (frozen-case "vectors/adversarial/BAD-STR-DBJ.pjs")
                       "stream-persistence-order-invalid")
         (nth-value 0 (run-planted-defect :delivery-before-journal)))))

(check "8 duplicate chunk with altered payload refuses ~
        stream-chunk-identity-collision (AP-STR-3)"
  (lambda ()
    (rejects-with
     (%rec '("ap0" "family") (%id "family" "stream")
           '("ap0" "adapter-identity") (%str "fake-reference-0")
           '("ap0" "stream-relation") (%bool t)
           '("ap0" "chunks") (make-sequence-datum (list (%int 2) (%int 2)))
           '("ap0" "duplicate-identical") (%bool nil)
           '("ap0" "persistence-order") (%str "journal-before-delivery")
           '("ap0" "history")
           (make-sequence-datum (list (%str "chunk-captured")
                                      (%str "chunk-journaled")
                                      (%str "chunk-delivered"))))
     "stream-chunk-identity-collision")))

(check "9 sequence conflict: chunks without their sequence relation ~
        refuse stream-sequence-conflict (AP-G4-2/AP-STR-4)"
  (lambda ()
    (rejects-with (frozen-case "vectors/adversarial/BAD-STR-02.pjs")
                  "stream-sequence-conflict")))

(check "10 gap silently normalized: a hidden gap refuses ~
        stream-sequence-gap (AP-STR-5 — visibility is the law; ~
        normalization requires a receipt)"
  (lambda ()
    (rejects-with (frozen-case "vectors/adversarial/BAD-STR-03.pjs")
                  "stream-sequence-gap")))

(check "11 partial chunks erased by missing terminal: the frozen erasure ~
        fixture refuses partial-manifestation-erasure (AP-STR-7), and ~
        the planted :erase-partials fold is killed by the declared ~
        terminal"
  (lambda ()
    (and (rejects-with (frozen-case "vectors/adversarial/BAD-PART-01.pjs")
                       "partial-manifestation-erasure")
         (nth-value 0 (run-planted-defect :erase-partials)))))

;;; ---------------------------------------------------------------------------
(note "~%== envelope, projection, truth ==")

(check "12 projection before envelope custody: the frozen missing-capture ~
        fixture refuses provider-envelope-missing (AP-ENV-4/R2), and the ~
        live operation refuses the same way on an uncaptured handle"
  (lambda ()
    (and (rejects-with (frozen-case
                        "vectors/adversarial/BAD-ENV-MISSING-CAPTURE.pjs")
                       "provider-envelope-missing")
         (let* ((prepared (prepare-invocation
                           *live* (make-invocation-spec
                                   :logical-operation-id "op-c12"
                                   :attempt-id "a-c12" :run-label "c12")))
                (handle (dispatch prepared :live-adapter *live*)))
           (handler-case (progn (project-envelope *live* handle "nonempty")
                                nil)
             (provider-envelope-missing () t))))))

(check "13 absence-table improvisation: the frozen invented-shape fixture ~
        refuses absence-mapping-table-miss (AP-ABS-1), and the live ~
        projection refuses the same shape instead of improvising"
  (lambda ()
    (and (rejects-with (frozen-case "vectors/adversarial/BAD-PRJ-01.pjs")
                       "absence-mapping-table-miss")
         (let* ((prepared (prepare-invocation
                           *live* (make-invocation-spec
                                   :logical-operation-id "op-c13"
                                   :attempt-id "a-c13" :run-label "c13")))
                (handle (dispatch prepared :live-adapter *live*)))
           (await-terminal handle)
           (handler-case
               (progn (project-envelope *live* handle
                                        "provider-invented-shape-xyz")
                      nil)
             (absence-mapping-table-miss () t))))))

(check "14 projection promoted to semantic truth: a verified-semantics ~
        claim on a projection refuses adapter-truth-minting (AP-PRJ-2)"
  (lambda ()
    (rejects-with (frozen-case "vectors/adversarial/BAD-TRUTH-01.pjs")
                  "adapter-truth-minting")))

(check "20 exposed intermediary omitted: the frozen provider-omitted ~
        fixture refuses exposed-principal-boundary-unknown (AP-EXP-1), ~
        and an undeclared intermediary refuses exposed-principal-drift ~
        (AP-EXP-4)"
  (lambda ()
    (and (rejects-with (frozen-case "vectors/adversarial/BAD-EXP-01.pjs")
                       "exposed-principal-boundary-unknown")
         (rejects-with
          (%rec '("ap0" "family") (%id "family" "exposure")
                '("ap0" "provider-principal") (%bool t)
                '("ap0" "invoker-exposed") (%bool t)
                '("ap0" "undeclared-intermediary") (%bool t))
          "exposed-principal-drift"))))

;;; ---------------------------------------------------------------------------
(note "~%== money ==")

(check "17 usage promoted to cost: extract-usage yields a usage record ~
        with units and NO monetary field; extract-cost without a price ~
        schedule yields the typed missing-cost marker — usage never ~
        becomes money by relabelling"
  (lambda ()
    (let* ((prepared (prepare-invocation
                      *live* (make-invocation-spec
                              :logical-operation-id "op-c17"
                              :attempt-id "a-c17" :run-label "c17")))
           (handle (dispatch prepared :live-adapter *live*)))
      (await-terminal handle)
      (let ((usage (extract-usage *live* handle "fake-usage-procedure-0"))
            (missing (extract-cost *live* handle "fake-cost-procedure-1")))
        (and (record-datum-p usage)
             (not (case-field-present-p usage "amount"))
             (not (case-field-present-p usage "currency"))
             (missing-cost-marker-p missing))))))

(check "18 estimated promoted to billed: a stronger-than-evidence ~
        standing (\"billed\" is not in the §16 vocabulary) refuses ~
        cost-standing-missing, and the fake's own cost records only ever ~
        claim estimated (AP-COST-2/3)"
  (lambda ()
    (and (rejects-with
          (%rec '("ap0" "family") (%id "family" "cost")
                '("ap0" "standing") (%str "billed")
                '("ap0" "amount") (%str "249/100"))
          "cost-standing-missing")
         (let* ((prepared (prepare-invocation
                           *live* (make-invocation-spec
                                   :logical-operation-id "op-c18"
                                   :attempt-id "a-c18" :run-label "c18")))
                (handle (dispatch prepared :live-adapter *live*)))
           (await-terminal handle)
           (equal "estimated"
                  (case-string (extract-cost *live* handle
                                             "fake-cost-procedure-1"
                                             :price-schedule-id
                                             "fake-prices-v0")
                               "standing"))))))

(check "19 missing cost as zero: the missing-cost marker is not a record, ~
        not a number, and carries its reason — missing ≠ free ~
        (AP-COST-4); the frozen float fixture refuses ~
        cost-float-noncanonical (AP-COST-1)"
  (lambda ()
    (let* ((prepared (prepare-invocation
                      *live* (make-invocation-spec
                              :logical-operation-id "op-c19"
                              :attempt-id "a-c19" :run-label "c19")))
           (handle (dispatch prepared :live-adapter *live*))
           (missing (extract-cost *live* handle "fake-cost-procedure-1")))
      (and (missing-cost-marker-p missing)
           (not (numberp missing))
           (stringp (missing-cost-marker-reason missing))
           (rejects-with (frozen-case "vectors/adversarial/BAD-CST-01.pjs")
                         "cost-float-noncanonical")))))

;;; ---------------------------------------------------------------------------
(note "~%== gate teeth ==")

(when (equal (sb-ext:posix-getenv "ADAPTER0_CONTROLS_PLANT_FAULT") "1")
  (check "PLANTED FAULT — this check must FAIL and the suite must exit 1"
    (lambda () nil)))

(when (equal (sb-ext:posix-getenv "ADAPTER0_CONTROLS_DIE") "1")
  (note "ADAPTER0_CONTROLS_DIE=1 — dying mid-run WITHOUT a RESULT ~
         sentinel (planted truncation)")
  (sb-ext:exit :code 3))

(unless (equal (sb-ext:posix-getenv "ADAPTER0_CONTROLS_PLANT_FAULT") "1")
  (check "the planted-fault gate FIRES: a child with ~
          ADAPTER0_CONTROLS_PLANT_FAULT=1 exits 1 carrying FAIL PLANTED ~
          FAULT"
    (lambda ()
      (let* ((output (make-string-output-stream))
             (process (sb-ext:run-program
                       "sbcl"
                       (list "--script"
                             "mneme/adapter0/adapter0-controls.lisp")
                       :search t
                       :output output :error output
                       :environment (cons "ADAPTER0_CONTROLS_PLANT_FAULT=1"
                                          (sb-ext:posix-environ))))
             (text (get-output-stream-string output)))
        (and (eql 1 (sb-ext:process-exit-code process))
             (search "FAIL PLANTED FAULT" text)))))

  (check "23 runner truncation before canonical result: a child with ~
          ADAPTER0_CONTROLS_DIE=1 exits 3 with NO RESULT sentinel — ~
          truncation is detectable as exactly that pair"
    (lambda ()
      (let* ((output (make-string-output-stream))
             (process (sb-ext:run-program
                       "sbcl"
                       (list "--script"
                             "mneme/adapter0/adapter0-controls.lisp")
                       :search t
                       :output output :error output
                       :environment (cons "ADAPTER0_CONTROLS_DIE=1"
                                          (sb-ext:posix-environ))))
             (text (get-output-stream-string output)))
        (and (eql 3 (sb-ext:process-exit-code process))
             (not (search "RESULT:" text)))))))

;;; ---------------------------------------------------------------------------

(format t "~%adapter0-controls: ~a check~:p, ~a failure~:p~%"
        *checks* *failures*)
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
