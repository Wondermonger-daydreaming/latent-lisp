;;;; ma0-compose.lisp — THE PUBLIC ACT COMPOSITION (contract §4).
;;;;
;;;; CANDIDATE.  Nothing here is adopted (contract §0).
;;;;
;;;; ---------------------------------------------------------------------------
;;;; WHAT THIS FILE IS, AND WHAT IT IS NOT
;;;; ---------------------------------------------------------------------------
;;;;
;;;; One Act /0 exports the act's FIRST HALF (`run-act', L0..L17) and the
;;;; composer's INGREDIENTS (`build-f1'..`build-f5', `lane-envelope',
;;;; `frame-event-id', `agreement-gate', `correspondence-verdict',
;;;; `classify-act-frames'), but not the composer: `finish-act' is INTERNAL, as
;;;; are `append-lane-frame', `outcome-fields', `agreement-row-for',
;;;; `assert-o5-facets', `namespace-absence-check', `read-act-id-from-store',
;;;; `harvested', `lane-ledger-query', `grant-terms-for' and the
;;;; dispatch-context readers.
;;;;
;;;; So this lane OWNS an act-completion routine built exclusively from
;;;; exported and public operations, honouring `finish-act''s law-chain step for
;;;; step.  IT IS A RE-COMPOSITION, AND THAT IS THE LANE'S LARGEST RISK — the
;;;; contract says so at §4 and the failure matrix pins CONCORDANCE teeth
;;;; against it (a later hand's work; they are NOT in this candidate's
;;;; selftest, and this file may not be read as if they had run).
;;;;
;;;; EVERY LAW BELOW CITES THE act0.lisp LINE IT REPLICATES.  Reading a
;;;; published line and re-expressing its effect through public operations is
;;;; not a use of an internal symbol; calling the internal function would be.
;;;; The distinction is the whole architecture of this file.
;;;;
;;;; ⚠ ONE DELIBERATE DIVERGENCE, DECLARED: the ordering guard.  One Act /0's
;;;; `append-lane-frame' consults a host hash table (`*appended-frames*',
;;;; act0.lisp:712) and calls the store scan the LAW.  This lane has no access
;;;; to that table and does not want one: its guard derives "which frames are
;;;; already appended" from the STORE's validated prefix and from nothing else
;;;; (W-ORDER-STORE).  The J-4c identity-constancy check and the ACT-8a
;;;; disposition check are replicated unchanged.
;;;;
;;;; — FABER (Claude Opus 5, subagent), 2026-08-09

(in-package #:lisp-plus-many-acts0)

;;; ===========================================================================
;;; §1 — frame ordinals and the store-derived frame scan.
;;; ===========================================================================

(defparameter +ma0-frame-ordinals+
  '((:f1 . 1) (:f2 . 2) (:f3 . 3) (:f4 . 4) (:f5 . 5))
  "act0.lisp:546-547 — +frame-ordinals+, re-declared.  F1..F5 = 1..5.")

(defun %ma0-frame-ordinal (frame)
  (or (cdr (assoc frame +ma0-frame-ordinals+))
      (ma0-refuse 'ma0-composition-divergence "MA0-FRAME"
                  "~s is not one of the five lane frames" frame)))

(defun %ma0-lane-frame-events (store)
  "Every frame of One Act /0's five kinds in the VALIDATED PREFIX, as
(ordinal . event), oldest first.  act0.lisp:716-728 — `lane-frame-events',
re-expressed over `validate-journal' + `prefix-report-events' + `record-field'.
The \"act:\" kind prefix is the filter, exactly as in the source."
  (let ((report (lisp-plus-journal0:validate-journal store))
        (out '()))
    (let ((events (lisp-plus-journal0:prefix-report-events report)))
      (loop for i below (fill-pointer events)
            for ev = (aref events i)
            for kind = (let ((k (lisp-plus-journal0:record-field
                                 ev "event" "kind")))
                         (and k (lisp-plus-cd0:identifier-datum-p k)
                              (lisp-plus-journal0:identifier-segment-string k)))
            when (and kind (>= (length kind) 4)
                      (string= "act:" (subseq kind 0 4)))
              do (push (cons (1+ i) ev) out)))
    (nreverse out)))

(defun %ma0-event-id-string (event)
  (let ((id (lisp-plus-journal0:record-field event "event" "event-id")))
    (and id (lisp-plus-cd0:identifier-datum-p id)
         (lisp-plus-journal0:identifier-segment-string id))))

(defun %ma0-frames-present (store attempt-name)
  "The frame keywords already durable for ATTEMPT-NAME, derived from the STORE
and from nothing else.  This is the ordering guard's whole state (W-ORDER-STORE):
no host table is consulted, so a fresh image cannot forget what the store
remembers, and a stale image cannot remember what the store never held."
  (let ((present '())
        (act-frames (%ma0-lane-frame-events store)))
    (dolist (frame '(:f1 :f2 :f3 :f4 :f5) (nreverse present))
      (let ((target (lisp-plus-journal0:identifier-segment-string
                     (lisp-plus-language-act0:frame-event-id
                      frame attempt-name))))
        (when (find target act-frames
                    :key (lambda (row) (%ma0-event-id-string (cdr row)))
                    :test #'equal)
          (push frame present))))))

(defun %ma0-frame-act-id (event-or-datum)
  "act0.lisp:730-732 — `frame-act-id'."
  (let ((body (lisp-plus-journal0:record-field event-or-datum "event" "body")))
    (and body (lisp-plus-journal0:record-field body "act" "act-id"))))

(defun %ma0-act-id-from-store (store attempt-name)
  "J-4c, act0.lisp:767-778 — read this act's act-id BACK OUT of its own
already-durable F1, never from a host variable, so a mutated in-image value
cannot pass."
  (let ((eid (lisp-plus-language-act0:frame-event-id :f1 attempt-name)))
    (multiple-value-bind (ordinal digest payload)
        (lisp-plus-journal0:find-event store eid)
      (declare (ignore digest))
      (unless ordinal
        (ma0-refuse 'ma0-composition-divergence "ACT-ORDER-1"
                    "no F1 is durable for attempt ~a" attempt-name))
      (%ma0-frame-act-id (lisp-plus-journal0:decode-pjs0 payload)))))

(defun %ma0-append-frame (store frame attempt-name datum)
  "The ordering guard (J-4 / ACT-ORDER-1), the identity-constancy guard (J-4c)
and ACT-8a — ALL BEFORE THE APPEND, so the prefix never carries a violation.
act0.lisp:780-825, with the host-table state replaced by the store scan."
  (let* ((present (%ma0-frames-present store attempt-name))
         (ordinal (%ma0-frame-ordinal frame))
         (highest (reduce #'max (mapcar #'%ma0-frame-ordinal present)
                          :initial-value 0)))
    ;; J-4 / ACT-ORDER-1 — enforced in code.  A documented ordering a caller
    ;; can violate is not an ordering.
    (when (<= ordinal highest)
      (ma0-refuse 'ma0-composition-divergence "ACT-ORDER-1"
                  "frame ~s (ordinal ~d) would follow ordinal ~d already ~
durable for attempt ~a" frame ordinal highest attempt-name))
    (when (and (not (eq frame :f1)) (zerop highest))
      (ma0-refuse 'ma0-composition-divergence "ACT-ORDER-1"
                  "frame ~s (ordinal ~d) has no F1 to follow for attempt ~a"
                  frame ordinal attempt-name))
    ;; J-4c — the act-id about to be written is datum= to the one F1 holds.
    (unless (eq frame :f1)
      (let ((from-store (%ma0-act-id-from-store store attempt-name))
            (about-to-write (%ma0-frame-act-id datum)))
        (unless (and from-store about-to-write
                     (lisp-plus-capability0:datum= from-store about-to-write))
          (ma0-refuse 'ma0-composition-divergence "ACT-12"
                      "act identity branch at frame ~s for attempt ~a"
                      frame attempt-name))))
    (let ((receipt (lisp-plus-journal0:append-event store datum)))
      ;; ACT-8a / U-2 — "the append did not error" is NOT evidence that the
      ;; frame was written: a byte-identical duplicate returns
      ;; :already-committed-identical and appends nothing.
      (unless (eq :newly-committed
                  (lisp-plus-journal0:append-receipt-disposition receipt))
        (ma0-refuse 'ma0-composition-divergence "ACT-8a"
                    "the append of frame ~s returned disposition ~s, not ~
:newly-committed" frame
                    (lisp-plus-journal0:append-receipt-disposition receipt)))
      receipt)))

;;; ===========================================================================
;;; §2 — the outcome projection and the typed absence.
;;; ===========================================================================

(defun %ma0-harvested (evidence reader)
  "act0.lisp:1506-1510 — `harvested'.  M-9: on a host fault NO Outcome and NO
evidence exist, and the absence is RECORDED rather than filled in."
  (if evidence
      (lisp-plus-kernel0:durable-identity-name (funcall reader evidence))
      "no-outcome-host-fault"))

(defun %ma0-outcome-fields (outcome)
  "act0.lisp:1512-1521 — `outcome-fields'.  (values view effect-value
effect-determinacy), each a STRING; all three carry the typed absence where
Core /0 produced no Outcome."
  (if (null outcome)
      (values "no-outcome-host-fault" "no-outcome-host-fault"
              "no-outcome-host-fault")
      (let ((eff (lisp-plus-kernel0:outcome-axis outcome :effects)))
        (values (symbol-name (lisp-plus-core0:outcome-kind outcome))
                (symbol-name (lisp-plus-kernel0:axis-value eff))
                (symbol-name (lisp-plus-kernel0:determinacy-mode
                              (lisp-plus-kernel0:axis-determinacy eff)))))))

;;; ===========================================================================
;;; §3 — N-6a, the namespace-absence check, PER ARM.
;;; ===========================================================================

(defun %ma0-namespace-absence-check (store seat)
  "act0.lisp:1523-1540 — `namespace-absence-check'.  `derive-seat-outcome'
probes the \"ap0-event\" namespace UNCONDITIONALLY in addition to its
:namespace argument (surface2.lisp:1127); a hit sets provenance :live and
evidence-class :projection, silently reclassifying every facet.  An absence
that is asserted and not checked is an absence no cold reader can trust."
  (let* ((report (lisp-plus-journal0:validate-journal store))
         (ids (lisp-plus-journal0:prefix-report-event-ids report)))
    (loop for i below (fill-pointer ids)
          for rendered = (lisp-plus-journal0:identifier-segment-string
                          (aref ids i))
          do (dolist (ns '("ap0-event" "vertical-event"))
               (let ((prefix (format nil "~a:e-~a-" ns seat)))
                 (when (and (>= (length rendered) (length prefix))
                            (string= prefix (subseq rendered 0 (length prefix))))
                   (ma0-refuse 'ma0-composition-divergence "N-6a"
                               "a ~a frame for seat ~a stands in the ~
validated prefix: ~a" ns seat rendered))))))
  t)

;;; ===========================================================================
;;; §4 — O-5's six facets.
;;; ===========================================================================

(defparameter +ma0-o5-facets+
  '(:manifestation :no-payload-state :provenance
    :chunks-preserved :refusal :interpretation-class)
  "act0.lisp:674-678 — +o5-facets+, in the contract's own order.  `build-f5'
refuses a record missing any one of them, so this list is load-bearing.")

(defparameter +ma0-o5-standing-key+
  '((:manifestation . :manifestation) (:no-payload-state . :no-payload-state)
    (:provenance . :provenance) (:chunks-preserved . :chunks-preserved)
    (:refusal . :refusal) (:interpretation-class . :interpretation))
  "act0.lisp:1554-1563 — +o5-standing-key+.  O-5 names its facets as the
contract does; Surface /2's field-standings plist keys the interpretation facet
`:interpretation'.  Declared here rather than discovered at the call site,
because a facet the reader cannot name is a facet the record cannot carry.")

(defun %ma0-o5-facets (seat-outcome)
  "act0.lisp:1565-1583 — `assert-o5-facets'.  Returns the plist F5 records:
facet -> \"<value>/<standing>\"."
  (let ((out '()))
    (dolist (facet +ma0-o5-facets+ (nreverse out))
      (let* ((standing (lisp-plus-surface2:seat-outcome-field-standing
                        seat-outcome (cdr (assoc facet +ma0-o5-standing-key+))))
             (value (ecase facet
                      (:manifestation
                       (lisp-plus-surface2:seat-outcome-manifestation
                        seat-outcome))
                      (:no-payload-state
                       (lisp-plus-surface2:seat-outcome-no-payload-state
                        seat-outcome))
                      (:provenance
                       (lisp-plus-surface2:seat-outcome-provenance
                        seat-outcome))
                      (:chunks-preserved
                       (lisp-plus-surface2:seat-outcome-chunks-preserved
                        seat-outcome))
                      (:refusal
                       (lisp-plus-surface2:seat-outcome-refusal seat-outcome))
                      (:interpretation-class
                       (lisp-plus-surface2:seat-outcome-interpretation-class
                        seat-outcome)))))
        (setf out (list* (format nil "~a/~a"
                                 (if (stringp value) value
                                     (string-downcase (princ-to-string value)))
                                 (string-downcase (symbol-name standing)))
                         facet out))))))

;;; ===========================================================================
;;; §5 — the agreement row mapping.
;;; ===========================================================================

(defun %ma0-agreement-row (class phase)
  "act0.lisp:1585-1589 — `agreement-row-for'.  The row vocabulary is the
EXPORTED `agreement-gate''s own table (act0.lisp:1081-1103): \"A\" · \"B\" ·
\"C-i\" · \"C-ii-pre\" · \"C-ii-post\" · \"C-reconciled\" · \"D-pre\" ·
\"D-post\".  The mapping from (class, phase) to a row is what this lane must
re-derive; the TABLE it indexes is One Act /0's and is called, not copied."
  (ecase class
    (:a "A")
    (:b "B")
    (:c-i (ecase phase (:pre "C-i") (:post "C-reconciled")))
    (:c-ii (ecase phase
             (:pre "C-ii-pre") (:declared "C-ii-post") (:post "C-reconciled")))
    (:d "D-pre")))

;;; ===========================================================================
;;; §6 — the language-side ledger read.
;;; ===========================================================================

(defun %ma0-ledger-answer (world attempt-name)
  "act0.lisp:1060-1069 — `lane-ledger-query', re-expressed through the PUBLIC
`world-ledger-lookup' (capability2/world.lisp:190, (values found-p line
line-sha256)).  A witness of LIMITED JURISDICTION: it reports what the ledger
this layer can see holds, and claims nothing about the world the runtime sees.
That asymmetry is the whole point of the §9.3 correspondence table."
  (let ((rid (lisp-plus-journal0:identifier-segment-string
              (%ma0-idf (list "external-request" "cap2" attempt-name)))))
    (multiple-value-bind (found line line-sha)
        (lisp-plus-capability2:world-ledger-lookup world rid)
      (declare (ignore line line-sha))
      (if found "ANSWERED-COMMITTED" "ANSWERED-NOT-COMMITTED"))))

;;; ===========================================================================
;;; §7 — THE COMPOSITION.
;;; ===========================================================================

(defun ma0-complete-act (result environment &key (verbose nil))
  "L18..L22 for an arm that reached `perform', composed from public parts.
RESULT is the plist `run-act' returned (act0.lisp:1476-1478).

The law-chain, in order, each step naming the law it discharges:

  BIND-6   observed-vs-declared language seat, before F2's append
  J-4b     the four-term datum= join between F1's recorded grant terms and the
           capability actually presented at D1
  F2       post-disposition; frontier NOT-CROSSED iff class :b; typed-absence
           sentinels where Core /0 produced no Outcome
  C-arms   on :c-ii, declare-uncertain-effect FIRST; then F3 FROZEN BEFORE the
           runtime reconciliation; then reconcile; then F4 with the §9.3
           three-valued correspondence verdict
  N-6a     the namespace absence check, per arm
  readback Surface /2 derivation over the store
  O-4      the agreement gate, against One Act /0's own exported table
  F5       the readback frame, with O-5's six facets
  O-8      a \"disagree\" verdict REFUSES.  It is a FINDING.  Neither standing
           is promoted, demoted, corrected, or averaged, and the table is not
           adjusted to make it go away."
  ;; ⚠ R1/D4 — THIS DOOR IS EXPORTED AND INDEPENDENTLY CALLABLE, so it carries
  ;; its own staleness gate rather than inheriting the evaluator's.  A stale
  ;; environment here would read one store while the act it is composing was run
  ;; against another — which is exactly the divergence the pre-repair witness
  ;; recorded, arriving too late to prevent the write.
  (%ma0-check-environment-current environment "ma0-complete-act")
  (let* ((record (getf result :record))
         (fixture (lisp-plus-language-act0:act-record-fixture record))
         (arm (lisp-plus-language-act0:act-fixture-arm fixture))
         (seat (lisp-plus-language-act0:act-fixture-runtime-seat fixture))
         (attempt (lisp-plus-language-act0:act-fixture-attempt-name fixture))
         (store (%env-store environment))
         (world (%ma0-world-for-arm environment arm))
         (class (getf result :class))
         (evidence (getf result :evidence))
         (outcome (getf result :outcome))
         (office-r (getf result :office-r))
         (act-id (%ma0-act-id-from-store store attempt)))

    ;; ---- BIND-6 (act0.lisp:1603-1613).  The seat Core /0 OBSERVED must be
    ;; ---- the seat F1 DECLARED.  Both read through exported Core /0 readers.
    (when evidence
      (let ((observed (lisp-plus-kernel0:durable-identity-name
                       (lisp-plus-core0:core0-evidence-seat-id evidence)))
            (declared (lisp-plus-kernel0:durable-identity-name
                       (lisp-plus-core0:process-context-seat-id
                        (getf result :process)))))
        (unless (string= observed declared)
          (ma0-refuse 'ma0-composition-divergence "BIND-6"
                      "the observed language seat ~s diverges from F1's ~
declared ~s" observed declared))))

    ;; ---- J-4b (act0.lisp:1614-1629).  THE JOIN THAT MAKES F1 AND F2 ONE
    ;; ---- BINDING RECORD RATHER THAN TWO UNRELATED FRAMES.  The four terms
    ;; ---- are rebuilt from the EXPORTED fixture readers and this lane's
    ;; ---- re-declared constants; the four presented terms are read through
    ;; ---- Capability /1's exported live-capability readers.
    (when office-r
      (let ((terms (%ma0-grant-terms fixture)))
        (dolist (pair (list (cons :subject
                                  #'lisp-plus-capability1:live-capability-subject)
                            (cons :action
                                  #'lisp-plus-capability1:live-capability-action)
                            (cons :resource
                                  #'lisp-plus-capability1:live-capability-resource)
                            (cons :scope
                                  #'lisp-plus-capability1:live-capability-scope)))
          (unless (lisp-plus-capability0:datum=
                   (funcall (cdr pair) office-r) (getf terms (car pair)))
            (ma0-refuse 'ma0-composition-divergence "J-4b"
                        "the presented capability's ~a is not datum= to F1's ~
recorded grant term" (car pair))))))

    ;; ---- L18: F2.
    (multiple-value-bind (view eff-value eff-det) (%ma0-outcome-fields outcome)
      (%ma0-append-frame
       store :f2 attempt
       (lisp-plus-language-act0:build-f2
        record
        :act-id-from-store act-id
        :language-attempt-id
        (%ma0-harvested evidence #'lisp-plus-core0:core0-evidence-attempt-id)
        :language-process-observed
        (if evidence
            (lisp-plus-kernel0:durable-identity-name
             (lisp-plus-core0:process-context-process-id
              (lisp-plus-core0:core0-evidence-process evidence)))
            "no-outcome-host-fault")
        :language-seat-observed
        (%ma0-harvested evidence #'lisp-plus-core0:core0-evidence-seat-id)
        ;; J-4-OR3: explicit, required, never absent, never NIL-punned.
        ;; NOT-CROSSED iff class :b — on Class B no frontier was crossed.
        :frontier (if (eq class :b) "NOT-CROSSED" "CROSSED")
        :office-r-public-id
        (if office-r
            (lisp-plus-capability1:live-capability-public-id office-r)
            (%ma0-idf '("none" "no-outcome-host-fault")))
        :office-r-occurrence-id
        (if office-r
            (lisp-plus-capability1:live-capability-occurrence-id office-r)
            (%ma0-idf '("none" "no-outcome-host-fault")))
        :outcome-view view :effect-axis-value eff-value
        :effect-axis-determinacy eff-det))
      (when verbose
        (format t "~&    F2 appended (frontier ~a, view ~a)~%"
                (if (eq class :b) "NOT-CROSSED" "CROSSED") view)))

    ;; ---- L19/L20: the Class-C reconciliation pair.
    (let ((phase :pre) (corr-verdict nil) (corr-row nil))
      (when (member class '(:c-i :c-ii))
        ;; C-ii's standing is :crossed-unsettled, so the uncertainty is
        ;; STRUCTURED FIRST; Capability /2 already journaled C-i's.
        (when (eq class :c-ii)
          (lisp-plus-capability2:declare-uncertain-effect
           store attempt
           :process-name lisp-plus-language-act0:+runtime-process-name+)
          (setf phase :declared)
          (when verbose (format t "~&    declare-uncertain-effect ran (C-ii)~%")))
        ;; R-6 / J-4: THE LANGUAGE-SIDE READ IS FROZEN FIRST, and F3 is
        ;; appended BEFORE the runtime reconciliation and never after it.
        (let ((ledger-answer (%ma0-ledger-answer world attempt)))
          (%ma0-append-frame
           store :f3 attempt
           (lisp-plus-language-act0:build-f3
            record :act-id-from-store act-id
                   :continuation-disposition "INDETERMINATE"
                   :required-action "RECONCILE-BEFORE-ANY-RETRY"
                   :ledger-answer ledger-answer))
          (when verbose
            (format t "~&    F3 frozen BEFORE the runtime reconciliation (~a)~%"
                    ledger-answer))
          (let ((resolution
                  (nth-value 0
                             (lisp-plus-capability2:reconcile-uncertain-effect
                              store world attempt
                              :process-name
                              lisp-plus-language-act0:+runtime-process-name+))))
            (multiple-value-setq (corr-verdict corr-row)
              (lisp-plus-language-act0:correspondence-verdict
               ledger-answer resolution))
            (%ma0-append-frame
             store :f4 attempt
             (lisp-plus-language-act0:build-f4
              record :act-id-from-store act-id
                     :runtime-resolution (symbol-name resolution)
                     :correspondence-row corr-row
                     :correspondence-verdict corr-verdict))
            (setf phase :post)
            (when verbose
              (format t "~&    F4: runtime ~s · row ~a · verdict ~a~%"
                      resolution corr-row corr-verdict)))))

      ;; ---- L21: the readback, the agreement gate, F5.
      (%ma0-namespace-absence-check store seat)
      (let* ((events (lisp-plus-surface2:validated-store-events store))
             (so (lisp-plus-surface2:derive-seat-outcome store events seat))
             (standing (lisp-plus-surface2:seat-outcome-execution-standing so))
             (eclass (lisp-plus-surface2:seat-outcome-evidence-class so))
             (row (%ma0-agreement-row class phase)))
        (multiple-value-bind (view eff-value) (%ma0-outcome-fields outcome)
          (let ((verdict (nth-value 0 (lisp-plus-language-act0:agreement-gate
                                       row view eff-value standing eclass))))
            (when verbose
              (format t "~&    readback: standing ~s evidence-class ~s · row ~
~a · verdict ~a~%" standing eclass row verdict))
            (%ma0-append-frame
             store :f5 attempt
             (lisp-plus-language-act0:build-f5
              record :act-id-from-store act-id
                     :execution-standing (symbol-name standing)
                     :evidence-class (symbol-name eclass)
                     :mapping-row row :agreement-verdict verdict
                     :absent-facets (%ma0-o5-facets so)))
            ;; ---- O-8.  A DISAGREE VERDICT IS A FINDING.
            (unless (string= verdict "agree")
              (ma0-refuse 'ma0-composition-divergence "O-8"
                          "arm ~a row ~a: ~a/~a vs ~s/~s — the readback and ~
the account do not agree, and this lane reports the difference rather than ~
adjusting either side" arm row view eff-value standing eclass))
            (list :class class :row row :verdict verdict :standing standing
                  :evidence-class eclass :correspondence corr-verdict
                  :act-id-hex (%ma0-act-id-hex record))))))))

(defun %ma0-act-id-hex (record)
  "The 64-character digest segment of this act's identity, read from the
EXPORTED `act-record-act-id' through `identifier-segments'.  One Act /0's own
hex reader is internal; the identity itself is public and the digest is its
last segment (act0.lisp:474 — (idf (list +lane-stem+ \"act\" digest)))."
  (car (last (lisp-plus-journal0:identifier-segments
              (lisp-plus-language-act0:act-record-act-id record)))))
