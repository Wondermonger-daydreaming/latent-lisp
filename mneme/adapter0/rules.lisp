;;;; rules.lisp — the AP0 case validator: an ordered table of NAMED,
;;;; individually disableable rules, each derived from an identified spec
;;;; requirement.
;;;;
;;;; Derivation discipline (the independent-seeding charge): every rule
;;;; below cites the AP0 requirement it enforces.  The frozen vectors are
;;;; the TEST of this table, not its source — where the spec leaves a
;;;; family's condition vocabulary open, the adjudication taken is recorded
;;;; in the rule's comment and in ADAPTER-0-RETURN.md.
;;;;
;;;; The mutant gate (§24.2) requires that each planted defect be killed BY
;;;; ITS INTENDED RULE: for each frozen mutant, the full table rejects the
;;;; target case with its declared condition, and the table WITH EXACTLY
;;;; THAT ONE RULE DISABLED accepts it.  That works only if no second rule
;;;; also fires on the target — the table below is arranged to keep each
;;;; adversarial fixture on exactly one rule.
;;;;
;;;; — CLAVIGER-IV (Claude Fable 5 subagent), 2026-07-30

(in-package #:lisp-plus-adapter0)

;;; Closed vocabularies (spec sections cited).

(defparameter +acknowledgment-classes+
  '("transport-accepted" "provider-received" "provider-queued"
    "provider-started" "provider-terminal" "provider-rejected"
    "acknowledgment-ambiguous" "no-acknowledgment")
  "§9 closed acknowledgment vocabulary.")

(defparameter +request-identity-timings+
  '("pre-dispatch" "acknowledgment" "response-header" "terminal-envelope"
    "reconciliation-only" "unavailable" "conditional")
  "§5.3 provider-request-identity timing classes.")

(defparameter +provider-testimony-sources+
  '("pre-dispatch-provider-field" "acknowledgment-field"
    "response-header-field" "terminal-envelope-field"
    "reconciliation-response-field")
  "AP-ID-3 provider-testimony allowlist: the five identified provider
testimony sites.  Anything else (counters, hashes, local identifiers,
route values...) is adapter-minted surrogate.")

(defparameter +cost-standings+
  '("estimated" "bounded" "provider-reported" "dashboard-confirmed")
  "§16 cost standing vocabulary.")

(defparameter +reconciliation-results+
  '("not-found" "in-progress" "completed" "failed" "cancelled" "duplicate"
    "ambiguous" "unsupported" "temporarily-unavailable")
  "§18 initial reconciliation result vocabulary.")

(defparameter +cancellation-classes+
  '("unsupported" "local-interrupt-only" "fire-and-forget" "acknowledged"
    "provider-settled" "conditional" "unknown")
  "§17 declared cancellation vocabulary.")

(defun %exact-amount-p (datum)
  "AP-COST-1's forbidden clause: durable money is exact.  An integer datum
is exact; a string is exact iff it spells an integer or a rational
NUMERATOR/DENOMINATOR in plain decimal digits.  Anything else — notably
any binary-float spelling — is noncanonical.
Adjudication (recorded): the case grammar carries amounts as strings;
this rule enforces EXACTNESS (integer/rational syntax, no floats).
Reduction to lowest terms is a property of the durable CD/0 rational
value, which CD/0's constructor enforces at record-construction time; the
frozen positive fixture CST-01 carries the exact-but-unreduced string
\"1932912/1000000\", so string-level reducedness is NOT part of this
rule."
  (cond ((null datum) nil)
        ((integer-datum-p datum) t)
        ((rational-datum-p datum) t)
        ((string-datum-p datum)
         (let ((text (string-datum-value datum)))
           (and (plusp (length text))
                (let ((start (if (char= (char text 0) #\-) 1 0))
                      (slash (position #\/ text)))
                  (flet ((digits-p (from to)
                           (and (> to from)
                                (loop for index from from below to
                                      always (digit-char-p
                                              (char text index))))))
                    (if slash
                        (and (digits-p start slash)
                             (digits-p (1+ slash) (length text)))
                        (digits-p start (length text))))))))
        (t nil)))

(defun %witness-quadruple-p (case-record prefix)
  "True iff the four L15 witness facets are all present and defined:
PREFIX-evidence-id / -procedure-id / -validation-standing plus the
boundary field, with origin (where present) = \"observed\".  Field names
per the frozen positive fixtures' witness blocks."
  (flet ((has (name) (%field-defined-p case-record name)))
    (ecase prefix
      (:ack (and (has "raw-evidence-id")
                 (has "witness-boundary")
                 (has "witness-procedure-id")
                 (has "validation-standing")))
      (:settlement (and (has "settlement-evidence-id")
                        (has "settlement-witness-boundary")
                        (has "settlement-procedure-id")
                        (has "settlement-validation-standing")
                        (equal "observed"
                               (case-string case-record
                                            "settlement-origin"))))
      (:completeness (and (has "completeness-evidence-id")
                          (has "completeness-witness-boundary")
                          (has "completeness-procedure-id")
                          (has "completeness-validation-standing")
                          (equal "observed"
                                 (case-string case-record
                                              "completeness-origin")))))))

;;; ---------------------------------------------------------------------------
;;; The rule table.

(defstruct (ap0-rule (:constructor %rule (id requirement families check)))
  id            ; string — the disableable name (mutant vocabulary where targeted)
  requirement   ; string — enforced AP0 requirement id(s)
  families      ; list of family leaves, or :all
  check)        ; case-record -> condition-name string, or NIL

(defun %applies-p (rule family)
  (or (eq (ap0-rule-families rule) :all)
      (member family (ap0-rule-families rule) :test #'string=)))

(defmacro %defrule (id requirement families (case-var) &body body)
  `(%rule ,id ,requirement ,families (lambda (,case-var) ,@body)))

(defparameter +rules+
  (list
   ;; ------------------------------------------------------------------ global
   ;; AP-ERG-1: the lawful route may not be longer than any supported
   ;; bypass.  A shorter bypass is an ergonomic incentive to mint truth
   ;; outside custody — the frozen fixture names the condition
   ;; adapter-truth-minting, and this rule follows it.
   (%defrule "ergonomics-bypass" "AP-ERG-1" :all (c)
     (let ((bypass (case-integer c "bypass-route-steps"))
           (lawful (case-integer c "lawful-route-steps")))
       (when (and bypass lawful (< bypass lawful))
         "adapter-truth-minting")))

   ;; ---------------------------------------------------------- acknowledgment
   ;; §9 closed vocabulary.
   (%defrule "ack-class-known" "AP-ACK-1" '("acknowledgment") (c)
     (let ((class (case-string c "ack-class")))
       (when (and class (not (member class +acknowledgment-classes+
                                     :test #'string=)))
         "acknowledgment-class-unsupported")))
   ;; AP-ACK-4 + the §9 non-promotion laws: no acknowledgment class may be
   ;; promoted to a stronger one; the promotion leaves the true standing
   ;; ambiguous (condition per the frozen fixture).
   (%defrule "ack-promotion" "AP-ACK-4" '("acknowledgment") (c)
     (let ((class (case-string c "ack-class"))
           (promoted (case-string c "promoted-to")))
       (when (and class promoted (not (string= class promoted)))
         "acknowledgment-ambiguous")))
   ;; AP-ACK-3: emission outside the bound descriptor's witnessable set.
   (%defrule "ack-outside-witness-set" "AP-ACK-3" '("acknowledgment") (c)
     (let ((class (case-string c "ack-class"))
           (descriptor (descriptor-by-identity
                        (%id-leaf c "adapter-descriptor-id"))))
       (when (and class descriptor
                  (not (member class
                               (descriptor-witnessable-classes descriptor)
                               :test #'string=)))
         "adapter-witness-boundary-missing")))
   ;; §9 record obligations: every acknowledgment record binds raw evidence
   ;; identity, capture boundary, origin/validation standing — except
   ;; :no-acknowledgment, which is the absence of provider word.
   (%defrule "ack-witness-missing" "AP0-§9" '("acknowledgment") (c)
     (let ((class (case-string c "ack-class")))
       (when (and class
                  (not (string= class "no-acknowledgment"))
                  (not (%witness-quadruple-p c :ack)))
         "adapter-witness-boundary-missing")))

   ;; -------------------------------------------------------- request-identity
   ;; AP-ID-4: an unavailable provider request identity remains
   ;; unavailable; a populated identity under the unavailable timing class
   ;; is the violation.
   (%defrule "provider-id-timing-unavailable" "AP-ID-4"
             '("request-identity") (c)
     (when (and (equal "unavailable" (case-string c "provider-request-timing"))
                (%field-defined-p c "provider-request-id"))
       "provider-request-id-unavailable"))
   ;; AP-ID-3: provider testimony allowlist; every other source is an
   ;; adapter-minted surrogate.
   (%defrule "provider-id-invented" "AP-ID-3" '("request-identity") (c)
     (when (and (%field-defined-p c "provider-request-id")
                (not (member (case-string c "provider-request-source")
                             +provider-testimony-sources+
                             :test #'equal)))
       "provider-request-id-invented"))
   ;; AP-ID-5/AP-ID-10: late identity is compared, inequality is a
   ;; conflict, neither record is rewritten.
   (%defrule "provider-id-conflict" "AP-ID-5" '("request-identity") (c)
     (let ((prior (case-string c "prior-provider-request-id"))
           (current (case-string c "provider-request-id")))
       (when (and prior current (not (string= prior current)))
         "provider-request-identity-conflict")))
   ;; §5.3: timing class is a closed declaration.
   (%defrule "provider-id-timing-known" "AP0-§5.3" '("request-identity") (c)
     (let ((timing (case-string c "provider-request-timing")))
       (when (and timing (not (member timing +request-identity-timings+
                                      :test #'string=)))
         "adapter-descriptor-invalid")))

   ;; ---------------------------------------------------------------- capability
   ;; AP-CAP-5: a boolean capability API is nonconforming.
   (%defrule "boolean-capability" "AP-CAP-5" '("capability") (c)
     (when (and (case-field c "capability-standing")
                (boolean-datum-p (case-field c "capability-standing")))
       "adapter-descriptor-invalid"))

   ;; ------------------------------------------------------------- configuration
   ;; AP-ID-9: implicit provider or route fallback is forbidden.
   (%defrule "implicit-fallback" "AP-ID-9" '("configuration") (c)
     (when (eq :true (case-boolean c "fallback"))
       "implicit-provider-fallback"))

   ;; ----------------------------------------------------------------------- cost
   ;; §16: cost standing is a closed vocabulary and must be declared.
   (%defrule "cost-standing-valid" "AP0-§16" '("cost") (c)
     (let ((standing (case-string c "standing")))
       (when (or (null standing)
                 (not (member standing +cost-standings+ :test #'string=)))
         "cost-standing-missing")))
   ;; AP-COST-1: durable money is exact; binary floating-point forbidden.
   (%defrule "float-money" "AP-COST-1" '("cost") (c)
     (unless (%exact-amount-p (case-field c "amount"))
       "cost-float-noncanonical"))

   ;; ------------------------------------------------------------------ projection
   ;; AP-ENV-4 (+ adjudicated repair R2): projection requires
   ;; envelope-captured to be EXPLICITLY true.
   (%defrule "projection-before-capture" "AP-ENV-4" '("projection") (c)
     (unless (eq :true (case-boolean c "envelope-captured"))
       "provider-envelope-missing"))
   ;; AP-PRJ-2: projection establishes structure, never semantic truth.
   (%defrule "projection-truth-minting" "AP-PRJ-2" '("projection") (c)
     (when (%field-defined-p c "semantic-truth")
       "adapter-truth-minting"))
   ;; AP-ABS-1: a shape outside the identified table is a table miss;
   ;; improvised absence verdicts are forbidden.
   (%defrule "absence-table-miss" "AP-ABS-1" '("projection") (c)
     (let ((shape (case-string c "shape")))
       (when (and shape (null (absence-row-for-shape shape)))
         "absence-mapping-table-miss")))
   ;; Kernel /0 status algebra (reused predicates; §24.3: a Kernel algebra
   ;; violation is a semantic rejection, not a parser defect).  The F5
   ;; repair split status from no-payload STATE: a state spelled where a
   ;; status belongs is noncanonical projection output.
   (%defrule "projection-status-legal" "K0-§8/AP0-§14" '("projection") (c)
     (let ((status (case-string c "kernel-manifestation-status")))
       (when (and status
                  (not (manifestation-status-p
                        (intern (string-upcase status) :keyword))))
         "projection-output-noncanonical")))
   ;; §14 required default mappings: the claimed status/state pair must be
   ;; the table row's pair.  Erasing a present-class payload into an
   ;; absence claim is present-payload-erasure (AP-STR-7's projection-side
   ;; twin); any other divergence is noncanonical projection output
   ;; (adjudication recorded).
   (%defrule "absence-mapping-mismatch" "AP0-§14" '("projection") (c)
     (let* ((shape (case-string c "shape"))
            (row (and shape (absence-row-for-shape shape))))
       (when row
         (let ((claimed-status (case-string c "kernel-manifestation-status"))
               (claimed-state (case-string c "no-payload-state"))
               (row-status (absence-row-status row))
               (row-state (absence-row-state row)))
           (when (and claimed-status
                      (or (not (string= claimed-status row-status))
                          (not (equal claimed-state row-state))))
             (if (and (present-manifestation-status-p
                       (intern (string-upcase row-status) :keyword))
                      (string= claimed-status "absent"))
                 "present-payload-erasure"
                 "projection-output-noncanonical"))))))
   ;; AP-PRJ-6: projection output origin is :derived.
   (%defrule "projection-origin-invalid" "AP-PRJ-6" '("projection") (c)
     (let ((origin (case-string c "projection-origin")))
       (when (and origin (not (string= origin "derived")))
         "projection-origin-invalid")))

   ;; ------------------------------------------------------------ envelope-custody
   ;; AP-ENV-3/AP-ENV-5: redaction is a derived transformation with a new
   ;; identity, origin :derived, a transformation receipt, and the raw
   ;; envelope preserved.  All four facets are ONE custody law.
   (%defrule "redaction-custody-invalid" "AP-ENV-5" '("envelope-custody") (c)
     (let ((raw (case-string c "raw-envelope-id"))
           (derived (case-string c "derived-envelope-id")))
       (when (or (and raw derived (string= raw derived))
                 (eq :true (case-boolean c "raw-replaced"))
                 (not (equal "derived" (case-string c "output-origin")))
                 (not (%field-defined-p c "transformation-receipt-id")))
         "provider-envelope-redaction-invalid")))

   ;; ---------------------------------------------------------------------- stream
   ;; AP-G4-1: every chunk carries adapter identity.
   (%defrule "stream-adapter-identity" "AP-G4-1" '("stream") (c)
     (unless (%field-defined-p c "adapter-identity")
       "stream-chunk-adapter-identity-missing"))
   ;; AP-G4-2/AP-STR-4: chunks without their sequence relation cannot
   ;; prove order; the frozen fixture names the resulting condition
   ;; stream-sequence-conflict.
   (%defrule "stream-relation-missing" "AP-G4-2" '("stream") (c)
     (unless (eq :true (case-boolean c "stream-relation"))
       "stream-sequence-conflict"))
   ;; AP-STR-2/AP-STR-3: duplicate chunk identity is idempotent only with
   ;; byte-identical payload.
   (%defrule "duplicate-chunk-altered" "AP-STR-3" '("stream") (c)
     (let ((chunks (%sequence-integers c "chunks")))
       (when (and chunks
                  (/= (length chunks)
                      (length (remove-duplicates chunks)))
                  (not (eq :true (case-boolean c "duplicate-identical"))))
         "stream-chunk-identity-collision")))
   ;; AP-STR-5: gaps remain visible; a hidden gap is the violation.
   (%defrule "gap-hidden" "AP-STR-5" '("stream") (c)
     (let ((chunks (%sequence-integers c "chunks")))
       (when (and chunks
                  (eq :true (case-boolean c "gap-hidden"))
                  (loop for (a b) on (sort (copy-list chunks) #'<)
                        while b thereis (> (- b a) 1)))
         "stream-sequence-gap")))
   ;; §10.5: delivery-before-journal must be declared WITH its loss window
   ;; and reduced standing; anything else is an invalid persistence order.
   ;; A journal-before-delivery claim contradicted by the recorded history
   ;; falls under the same condition.
   (%defrule "stream-persistence-invalid" "AP0-§10.5" '("stream") (c)
     (let ((order (case-string c "persistence-order"))
           (history (%sequence-strings c "history")))
       (flet ((event-position (event)
                (position event history :test #'string=)))
         (cond
           ((null order) nil)
           ((string= order "journal-before-delivery")
            (let ((journaled (event-position "chunk-journaled"))
                  (delivered (event-position "chunk-delivered")))
              (when (or (null journaled)
                        (and delivered (> journaled delivered)))
                "stream-persistence-order-invalid")))
           ((string= order "delivery-before-journal")
            (unless (and (eq :true (case-boolean c "loss-window-declared"))
                         (%field-defined-p c "loss-window-id")
                         (equal "reduced" (case-string c "standing")))
              "stream-persistence-order-invalid"))
           (t "stream-persistence-order-invalid")))))
   ;; AP-STR-6/AP-STR-7: captured chunks with no lawful terminal are
   ;; :present-partial; an absence claim over captured chunks erases them.
   (%defrule "partial-erased" "AP-STR-7" '("stream") (c)
     (let ((chunks (%sequence-integers c "chunks"))
           (status (case-string c "kernel-manifestation-status")))
       (when (and chunks status
                  (eq :false (case-boolean c "terminal"))
                  (string= status "absent"))
         "partial-manifestation-erasure")))
   ;; AP-STR-6 (adjudicated companion): claiming a COMPLETE present
   ;; manifestation from a stream with no terminal settlement conflicts
   ;; with the stream's own finality evidence.
   (%defrule "stream-finality" "AP-STR-6" '("stream") (c)
     (let ((status (case-string c "kernel-manifestation-status")))
       (when (and status
                  (string= status "present")
                  (eq :false (case-boolean c "terminal")))
         "stream-finality-conflict")))

   ;; ---------------------------------------------------------------- crash-window
   ;; AP-CRASH-4 / AP-JRN-4: journal unavailability is governed by W1 —
   ;; the effect remains UNRESOLVED; any stronger fold (above all
   ;; no-effect) translates journal failure into certainty.
   (%defrule "journal-down-misclassified" "AP-JRN-4" '("crash-window") (c)
     (when (and (eq :false (case-boolean c "journal-available"))
                (not (equal "unresolved-effect" (case-string c "expected-fold"))))
       "reconciliation-insufficient"))
   ;; §11: each window's required fold disposition.
   (%defrule "window-fold-match" "AP0-§11" '("crash-window") (c)
     (unless (eq :false (case-boolean c "journal-available"))
       (let* ((window (case-string c "window"))
              (fold (case-string c "expected-fold"))
              (required (cond ((equal window "W1") "unresolved-effect")
                              ((equal window "W2") "present-partial")
                              ((equal window "W3") "captured-unprojected")
                              ((equal window "W4") "projected-unconsumed"))))
         (cond ((null required) "adapter-descriptor-invalid")
               ((not (equal fold required))
                ;; Adjudication (unfixtured negatives): a W1 fold claim
                ;; stronger than unresolved is settlement without
                ;; reconciliation; a W2 mismatch erases the partial; W3/W4
                ;; mismatches misstate the projection evidence.
                (cond ((equal window "W1") "reconciliation-insufficient")
                      ((equal window "W2") "partial-manifestation-erasure")
                      (t "projection-failed")))))))

   ;; ---------------------------------------------------------------- cancellation
   ;; AP-CAN-1: socket closure (or any weaker class) claimed as a stronger
   ;; settlement is unconfirmed cancellation.
   (%defrule "cancellation-claim-exceeds" "AP-CAN-1" '("cancellation") (c)
     (let ((class (case-string c "cancel-class"))
           (claimed (case-string c "claimed")))
       (when (and class claimed (not (string= class claimed)))
         "cancellation-unconfirmed")))
   ;; AP-CAN-6: provider-settled requires a boundary-captured settlement
   ;; witness; self-report is truth-minting.
   (%defrule "cancellation-witness-missing" "AP-CAN-6" '("cancellation") (c)
     (when (and (equal "provider-settled" (case-string c "cancel-class"))
                (not (%witness-quadruple-p c :settlement)))
       "adapter-truth-minting"))
   ;; AP-CAN-3: cancellation never erases partial manifestations.
   (%defrule "cancellation-partial-erased" "AP-CAN-3" '("cancellation") (c)
     (when (eq :false (case-boolean c "partial-preserved"))
       "partial-manifestation-erasure"))

   ;; -------------------------------------------------------------- reconciliation
   ;; §18 result vocabulary.
   (%defrule "reconciliation-result-known" "AP0-§18" '("reconciliation") (c)
     (let ((result (case-string c "result")))
       (when (and result (not (member result +reconciliation-results+
                                      :test #'string=)))
         "reconciliation-unsupported")))
   ;; AP-REC-6 conjunct: only :not-found can settle no-effect at all.
   (%defrule "settle-requires-not-found" "AP-REC-6" '("reconciliation") (c)
     (when (and (eq :true (case-boolean c "settles-no-effect"))
                (not (equal "not-found" (case-string c "result"))))
       "reconciliation-insufficient"))
   ;; AP-REC-1/AP-REC-6: no-effect needs a complete authoritative domain.
   (%defrule "reconciliation-domain-incomplete" "AP-REC-1"
             '("reconciliation") (c)
     (when (and (eq :true (case-boolean c "settles-no-effect"))
                (not (eq :true (case-boolean c "domain-complete"))))
       "reconciliation-insufficient"))
   ;; AP-ID-4/AP-REC-6: no-effect needs the exact provider request
   ;; identity; unavailable identity caps at :ambiguous.
   (%defrule "reconciliation-identity-missing" "AP-ID-4"
             '("reconciliation") (c)
     (when (and (eq :true (case-boolean c "settles-no-effect"))
                (or (not (%field-defined-p c "provider-request-id"))
                    (equal "unavailable"
                           (case-string c "provider-request-timing"))))
       "reconciliation-identity-missing"))
   ;; AP-REC-1: the completeness claim needs a DISTINCT, inspectable
   ;; boundary witness; self-assertion signals witness-boundary-missing.
   (%defrule "reconciliation-witness-missing" "AP-REC-1"
             '("reconciliation") (c)
     (when (and (eq :true (case-boolean c "settles-no-effect"))
                (not (%witness-quadruple-p c :completeness)))
       "adapter-witness-boundary-missing"))

   ;; ----------------------------------------------------------------------- retry
   ;; AP-DSP-3 + Kernel retry law: automatic retry over an unresolved
   ;; predecessor is forbidden; the lawful next act is reconciliation, so
   ;; the frozen fixture names reconciliation-insufficient.
   (%defrule "blind-retry" "AP-DSP-3" '("retry") (c)
     (when (and (eq :true (case-boolean c "automatic-retry"))
                (eq :true (case-boolean c "predecessor-unresolved")))
       "reconciliation-insufficient"))

   ;; ------------------------------------------------------------------ witnessing
   ;; AP-JRN-1 / PJ-WIT-1: a self-report is :asserted; saving it does not
   ;; make it observed.
   (%defrule "self-report-observed" "AP-JRN-1" '("witnessing") (c)
     (when (equal "observed" (case-string c "self-report-origin"))
       "adapter-witness-boundary-missing"))

   ;; -------------------------------------------------------------------- exposure
   ;; AP-EXP-1: the provider is a principal of the exposure event.
   (%defrule "provider-omitted" "AP-EXP-1" '("exposure") (c)
     (unless (eq :true (case-boolean c "provider-principal"))
       "exposed-principal-boundary-unknown"))
   ;; AP-EXP-4: an undeclared intermediary is exposure drift.
   (%defrule "intermediary-drift" "AP-EXP-4" '("exposure") (c)
     (when (eq :true (case-boolean c "undeclared-intermediary"))
       "exposed-principal-drift"))

   ;; -------------------------------------------------------------------- batching
   ;; §10.4 batching statute: batching must be declared with ordering
   ;; preservation and a bounded unjournaled window.
   (%defrule "batching-declared" "AP0-§10.4" '("batching") (c)
     (unless (and (eq :true (case-boolean c "batching-declared"))
                  (eq :true (case-boolean c "ordering-preserved"))
                  (integerp (case-integer c "max-unjournaled-events")))
       "stream-durability-unknown"))

   ;; ------------------------------------------------------------ fake-determinism
   ;; AP-FAKE-1/2: the named script, run twice under the same seed, yields
   ;; byte-identical records and the declared terminal.  This rule RUNS
   ;; the script machine (the validator's only executable rule).
   (%defrule "fake-determinism" "AP-FAKE-2" '("fake-determinism") (c)
     (let* ((name (case-string c "script"))
            (script (script-by-name name)))
       (if (null script)
           "adapter-descriptor-invalid"
           (let ((first-run (run-script script))
                 (second-run (run-script script)))
             (unless (and (string= (script-run-digest first-run)
                                   (script-run-digest second-run))
                          (equal (script-run-terminal first-run)
                                 (script-expected-terminal script)))
               "ap0-script-nondeterministic"))))))
  "The ordered AP0 rule table.  Order is load-bearing where several rules
could fire on one scene; the arrangement keeps every frozen adversarial
fixture on exactly one rule (the mutant gate's precondition).")

(defun rule-ids ()
  (mapcar #'ap0-rule-id +rules+))

(defun rule-exists-p (rule-id)
  (find rule-id +rules+ :key #'ap0-rule-id :test #'string=))

(defun validate-case (case-record &key disabled-rules)
  "Judge one frozen case scene under the AP0 rule table.
Returns (values verdict condition rule-id): verdict :accept or :reject;
on :reject, CONDITION is the typed condition name and RULE-ID the rule
that fired.  DISABLED-RULES (a list of rule-id strings) is the §24.2
mutation seam: a disabled rule is skipped exactly as if its enforcement
had been omitted from the implementation."
  (let ((family (%id-leaf case-record "family")))
    (dolist (rule +rules+ (values :accept nil nil))
      (when (and (%applies-p rule family)
                 (not (member (ap0-rule-id rule) disabled-rules
                              :test #'string=)))
        (let ((condition (funcall (ap0-rule-check rule) case-record)))
          (when condition
            (return (values :reject condition (ap0-rule-id rule)))))))))
