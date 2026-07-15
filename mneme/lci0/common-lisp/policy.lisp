(in-package #:lisp-plus-lci0)

;;; Policy-A and Policy-B are finite conformance fixtures.  Decisions are
;;; constructed from their validated inputs; registry decision documents are
;;; verification fixtures, never result oracles.

(defun %fixture-policy-letter (policy)
  ;; Equality with the two frozen policy definitions validates the complete
  ;; closed rule record, including its stable policy identity and rule tables.
  (cond ((equal-datum policy (registry-datum "admissibility-policy.a.0")) "a")
        ((equal-datum policy (registry-datum "admissibility-policy.b.0")) "b")
        (t (%fixture-operation-authorial-gap
            "evaluate-fixture-policy" '("policy")))))

(defun %policy-reference (policy)
  (let ((reference (record-field-named policy "policy")))
    (%validate-stable-ref-domain reference "policy" '("policy" "policy"))
    reference))

(defun %fixture-event-tick (time)
  (let* ((expression (and (record-datum-p time)
                          (record-field-named time "expression")))
         (tick (and (record-datum-p expression)
                    (record-field-named expression "tick"))))
    (and (integer-datum-p tick) (integer-datum-value tick))))

(defun %policy-query-time-from-event (event)
  (let ((query
          (make-fixture-record
           (list "kind" (fixture-id "tag" "evidence-event-time"))
           (list "schema-version" (make-integer-datum 0))
           (list "temporal-model" (record-field-named event "temporal-model"))
           (list "expression" (record-field-named event "expression"))
           (list "temporal-role" (fixture-id "temporal-role"
                                             "policy-query-time")))))
    (%validate-evidence-event-time query "policy-query-time" '("query-time"))
    query))

(defun %target-evidence-event (target kind)
  (let ((boundaries (record-field-named target "boundaries")))
    (record-field-named
     boundaries
     (cdr (assoc kind
                 '(("observed" . "observation-time")
                   ("executed" . "execution-time")
                   ("tested" . "execution-time")
                   ("externally-attested" . "attestation-time")
                   ("replayed" . "replay-time")
                   ("corpus-completion" . "execution-time")
                   ("reported" . "report-time")
                   ("policy-evaluation" . "query-time"))
                 :test #'string=)))))

(defun %policy-query-time (target kind query-time)
  (cond
    (query-time
     (%validate-evidence-event-time query-time "policy-query-time"
                                    '("query-time"))
     (copy-datum-through-cd0 query-time))
    ((%target-evidence-event target kind)
     (%policy-query-time-from-event (%target-evidence-event target kind)))
    (t
     ;; Component fixture constant used where a target kind has no event-time
     ;; boundary.  It is not a decision/result lookup.
     (copy-datum-through-cd0 (registry-datum "event-time.query-124")))))

(defun %freshness-record (mode age threshold passes)
  (make-fixture-record
   (list "kind" (fixture-id "tag" "freshness-evaluation"))
   (list "schema-version" (make-integer-datum 0))
   (list "mode" (fixture-id "freshness-mode" mode))
   (list "age-ticks" (make-integer-datum age))
   (list "threshold-ticks" (make-integer-datum threshold))
   (list "passes" (datum-boolean passes))))

(defun %policy-decision (policy relation target-kind query-time admitted
                         decision reasons testimony-class freshness
                         &key (consulted t))
  (make-fixture-record
   (list "kind" (fixture-id "tag" "admissibility-decision"))
   (list "schema-version" (make-integer-datum 0))
   (list "policy" (%policy-reference policy))
   (list "target-relation" relation)
   (list "target-kind" target-kind)
   (list "query-time" query-time)
   (list "policy-consulted" (datum-boolean consulted))
   (list "admitted" (datum-boolean admitted))
   (list "decision" (fixture-id "admissibility-decision" decision))
   (list "reasons"
         (make-sequence-datum
          (mapcar (lambda (reason)
                    (fixture-id "admissibility-reason" reason))
                  reasons)))
   (list "testimony-class" (fixture-id "testimony-class" testimony-class))
   (list "freshness" freshness)))

(defun %hard-floor-decision (policy relation &key target query-time)
  (%fixture-policy-letter policy)
  (%validate-target-relation-result relation '("target-relation"))
  (let* ((kind (if target
                   (identifier-last (record-field-named target "target-kind"))
                   "observed"))
         (kind-id (if target
                      (record-field-named target "target-kind")
                      (fixture-id "target-kind" "observed")))
         (query (if target
                    (%policy-query-time target kind query-time)
                    (copy-datum-through-cd0
                     (or query-time (registry-datum "event-time.query-124"))))))
    (%policy-decision
     policy relation kind-id query nil "hard-reject-target-relation"
     '("f-valued-target-result" "policy-not-consulted") "rejected"
     (%freshness-record "not-evaluated" 0 0 nil) :consulted nil)))

(defun %fixture-policy-rule (letter kind)
  (let ((entry
          (assoc kind
                 (if (string= letter "a")
                     '(("observed" "direct" "maximum-age" 24)
                       ("executed" "direct" "maximum-age" 24)
                       ("tested" "direct" "maximum-age" 24)
                       ("derived" "direct" "not-applicable" 0)
                       ("externally-attested" "reject" "not-applicable" 0)
                       ("replayed" "direct" "maximum-age" 24)
                       ("corpus-completion" "direct" "maximum-age" 24)
                       ("reported" "reject" "not-applicable" 0)
                       ("inherited" "reject-inherited" "not-applicable" 0)
                       ("translated" "reject" "not-applicable" 0)
                       ("policy-evaluation" "reject" "not-applicable" 0))
                     '(("observed" "direct" "maximum-age" 168)
                       ("executed" "direct" "maximum-age" 168)
                       ("tested" "direct" "maximum-age" 168)
                       ("derived" "direct" "not-applicable" 0)
                       ("externally-attested" "direct-if-trusted-principal"
                        "maximum-age" 168)
                       ("replayed" "direct" "maximum-age" 168)
                       ("corpus-completion" "direct" "maximum-age" 168)
                       ("reported" "limited-testimony" "maximum-age" 168)
                       ("inherited" "limited-testimony" "not-applicable" 0)
                       ("translated" "limited-testimony" "not-applicable" 0)
                       ("policy-evaluation" "limited-meta-testimony"
                        "maximum-age" 168)))
                 :test #'string=)))
    (unless entry
      (internal-integrity-fail "fixture-policy" "UnreachablePolicyTargetKind"
                               "admissibility"
                               :path '("target" "target-kind")))
    (values (second entry) (third entry) (fourth entry))))

(defun %policy-loss-list (target kind represented-loss)
  (let ((raw
          (or represented-loss
              (when (member kind '("inherited" "translated") :test #'string=)
                (record-field-named (record-field-named target "boundaries")
                                    "represented-loss")))))
    (cond
      ((null raw) nil)
      ((sequence-datum-p raw)
       (loop for index below (sequence-datum-length raw)
             collect (sequence-datum-ref raw index)))
      ((and (record-datum-p raw) (exact-kind-p raw "represented-loss"))
       (list raw))
      (t
       (%fixture-operation-authorial-gap
        "evaluate-fixture-policy" '("represented-loss"))))))

(defun %loss-consequence (loss)
  (validate-represented-loss loss :path '("represented-loss"))
  (identifier-last (record-field-named loss "consequence")))

(defun %loss-rejected-p (letter kind losses)
  (some
   (lambda (loss)
     (let ((consequence (%loss-consequence loss)))
       (if (string= letter "a")
           t
           (cond
             ((string= consequence "identity-neutral-loss") nil)
             ((and (string= consequence "authority-or-custody-loss")
                   (string= kind "inherited")) nil)
             ((and (string= consequence "semantic-translation-loss")
                   (string= kind "translated")) nil)
             (t t)))))
   losses))

(defun %loss-requires-limited-testimony-p (letter kind losses)
  (and (string= letter "b")
       (some
        (lambda (loss)
          (let ((consequence (%loss-consequence loss)))
            (or (and (string= consequence "authority-or-custody-loss")
                     (string= kind "inherited"))
                (and (string= consequence "semantic-translation-loss")
                     (string= kind "translated")))))
        losses)))

(defun %trusted-external-principal-p (target)
  (%stable-ref-material-exact-p
   (record-field-named (record-field-named target "boundaries")
                       "external-principal")
   "principal" '("external-trusted") 0))

(defun evaluate-fixture-policy (policy relation
                                &key target query-time represented-loss)
  (let ((letter (%fixture-policy-letter policy)))
    (%validate-target-relation-result relation '("target-relation"))
    (when (%exact-identifier-p (record-field-named relation "status")
                               +fixture-identifier-namespace+
                               '("result-status" "failure"))
      (return-from evaluate-fixture-policy
        (%hard-floor-decision policy relation :target target
                              :query-time query-time)))
    (unless target
      (%fixture-operation-authorial-gap
       "evaluate-fixture-policy" '("target")))
    (validate-warrant-target target)
    (let* ((kind-id (record-field-named target "target-kind"))
           (kind (identifier-last kind-id))
           (relation-name
             (identifier-last (record-field-named relation "relation")))
           (query (%policy-query-time target kind query-time)))
      (multiple-value-bind (disposition freshness-mode threshold)
          (%fixture-policy-rule letter kind)
        ;; Both frozen orderings put the target-kind rule first.  Rejected kinds
        ;; therefore have a determinate outcome without consulting later rules.
        (when (member disposition '("reject" "reject-inherited")
                      :test #'string=)
          (return-from evaluate-fixture-policy
            (%policy-decision
             policy relation kind-id query nil "reject-target-kind"
             '("target-relation-success" "target-kind-rejected-by-policy")
             "rejected" (%freshness-record "not-evaluated" 0 0 nil))))
        (let* ((losses (%policy-loss-list target kind represented-loss))
               (loss-rejected (%loss-rejected-p letter kind losses))
               (trust-rejected
                 (and (string= disposition "direct-if-trusted-principal")
                      (not (%trusted-external-principal-p target))))
               (event (%target-evidence-event target kind))
               (age
                 (if (string= freshness-mode "maximum-age")
                     (let ((event-tick (%fixture-event-tick event))
                           (query-tick (%fixture-event-tick query)))
                       (unless (and event-tick query-tick
                                    (>= query-tick event-tick))
                         (%fixture-operation-authorial-gap
                          "evaluate-fixture-policy" '("query-time")))
                       (- query-tick event-tick))
                     0))
               (stale (and (string= freshness-mode "maximum-age")
                           (> age threshold))))
          ;; LCI0-AC-005: input-sensitive combined evaluation in the ruled
          ;; order — target-relation floor, target kind, boundary coherence,
          ;; represented loss, inherited/external treatment, freshness, scope
          ;; narrowing, final disposition.  An all-at-once failing witness is
          ;; therefore rejected on its represented loss first.
          (when loss-rejected
            (return-from evaluate-fixture-policy
              (%policy-decision
               policy relation kind-id query nil "reject-represented-loss"
               '("target-relation-success" "kind-permitted") "rejected"
               (%freshness-record "not-evaluated" 0 0 nil))))
          ;; LCI0-AC-005: the one authorized external-principal rejection is
          ;; the registered decision spelling reject-external-principal.
          (when trust-rejected
            (return-from evaluate-fixture-policy
              (%policy-decision
               policy relation kind-id query nil "reject-external-principal"
               '("target-relation-success" "kind-permitted") "rejected"
               (%freshness-record "not-evaluated" 0 0 nil))))
          (when stale
            (return-from evaluate-fixture-policy
              (%policy-decision
               policy relation kind-id query nil "reject-stale"
               '("target-relation-success" "kind-permitted"
                 "age-exceeds-threshold")
               "rejected"
               (%freshness-record "maximum-age" age threshold nil))))
          (let* ((narrowing
                   (string= relation-name "supports-by-scope-narrowing"))
                 (proposition
                   (record-field-named (record-field-named target "claim")
                                       "proposition")))
            (when (and narrowing
                       (not (%monotone-declared-p
                             target kind (exact-form-name proposition))))
              (return-from evaluate-fixture-policy
                (%policy-decision
                 policy relation kind-id query nil "reject-scope-narrowing"
                 '("target-relation-success" "kind-permitted") "rejected"
                 (if (string= freshness-mode "maximum-age")
                     (%freshness-record "maximum-age" age threshold t)
                     (%freshness-record "not-applicable" 0 0 t)))))
            (let* ((limited
                     (or (member disposition
                                 '("limited-testimony" "limited-meta-testimony")
                                 :test #'string=)
                         (%loss-requires-limited-testimony-p
                          letter kind losses)))
                   (decision
                     (cond (limited "accept-limited-testimony")
                           (narrowing "accept-scope-narrowed")
                           (t "accept-direct")))
                   (testimony
                     (cond (limited "limited-testimony")
                           (narrowing "scope-narrowed-support")
                           (t "direct-support")))
                   (reasons
                     (cond
                       ((string= kind "inherited")
                        '("target-relation-success" "inherited-remains-inert"
                          "authority-loss-represented"))
                       ((string= kind "externally-attested")
                        '("target-relation-success" "kind-permitted"
                          "trusted-external-principal" "fresh"))
                       ((string= freshness-mode "maximum-age")
                        '("target-relation-success" "kind-permitted" "fresh"))
                       (t '("target-relation-success" "kind-permitted"))))
                   (freshness
                     (if (string= freshness-mode "maximum-age")
                         (%freshness-record "maximum-age" age threshold t)
                         (%freshness-record "not-applicable" 0 0 t))))
              (%policy-decision policy relation kind-id query t decision reasons
                                testimony freshness))))))))
