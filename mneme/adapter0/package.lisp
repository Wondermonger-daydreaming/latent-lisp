;;;; package.lisp — Adapter Protocol /0, independently seeded Common Lisp
;;;; deterministic fake adapter.
;;;;
;;;; Governing texts: LISP-PLUS-ADAPTER-PROTOCOL-0-SPEC.md (the adopted
;;;; reissue, all sections and appendices), the AP0 adoption record and
;;;; riders, Kernel /0 spec (esp. §8, §9, §10, §18), Process Journal /0
;;;; spec, Architecture 0.1.  Written fresh from the normative contract and
;;;; the frozen Class A fixtures under mneme/adapter0/ALLOWED-SOURCES.md
;;;; (commit 41df2330, sealed before any implementation code existed); no
;;;; Class B artifact was opened during this phase.
;;;;
;;;; Substrates are consumed strictly through public package exports:
;;;; #:lisp-plus-journal0 (PJ-S/0 codec, digests, store surface),
;;;; #:lisp-plus-cd0 (the canonical datum domain), #:lisp-plus-kernel0
;;;; (the adopted manifestation status algebra and shared conditions).
;;;; None of their sources are modified by this lane.
;;;;
;;;; — CLAVIGER-IV (Claude Fable 5 subagent), 2026-07-30

(defpackage #:lisp-plus-adapter0
  (:use #:cl)
  (:import-from #:lisp-plus-journal0
                #:decode-pjs0
                #:encode-pjs0
                #:pjs0-canonical-p
                #:record-field
                #:identifier-from-segments
                #:identifier-segments
                #:identifier-segment-string
                #:sha256-hex
                #:sha256-octets
                ;; store surface used by the joint gate (reuse of the
                ;; adopted joint reporting surface — K0E-26).
                #:create-journal
                #:validate-journal
                #:journal-store-store-id
                #:prefix-report-status
                #:prefix-report-frame-count
                #:joint-structural-semantic-report)
  (:import-from #:lisp-plus-cd0
                #:datum-p
                #:unit-datum-p
                #:boolean-datum-p
                #:integer-datum-p
                #:rational-datum-p
                #:string-datum-p
                #:identifier-datum-p
                #:sequence-datum-p
                #:record-datum-p
                #:boolean-datum-value
                #:integer-datum-value
                #:string-datum-value
                #:sequence-datum-length
                #:sequence-datum-ref
                #:sequence-datum-elements
                #:make-unit-datum
                #:make-boolean-datum
                #:make-integer-datum
                #:make-string-datum
                #:make-sequence-datum
                #:make-record-entry
                #:make-record-datum
                #:record-datum-ref)
  (:import-from #:lisp-plus-kernel0
                ;; The adopted Kernel /0 status algebra — reused, never
                ;; re-derived (AP-G4 / §24.3 semantic jurisdiction).
                #:manifestation-status-p
                #:absence-state-p
                #:present-manifestation-status-p
                ;; Shared condition semantics (reused, not twinned).
                #:reconciliation-insufficient
                #:unsafe-retry
                #:kernel0-condition)
  (:export
   ;; conditions.lisp — §22 typed conditions, six groups.
   #:ap0-condition
   #:ap0-condition-requirement-id
   #:ap0-condition-frontier-crossed
   #:ap0-condition-identities
   #:ap0-condition-evidence
   #:ap0-condition-detail
   #:ap0-condition-restarts
   #:signal-ap0
   #:with-ap0-restarts
   ;; group: descriptor and identity
   #:adapter-descriptor-invalid
   #:adapter-identity-missing
   #:adapter-version-drift
   #:adapter-capability-undeclared
   #:adapter-capability-unknown
   #:resolved-model-identity-unavailable
   #:provider-request-identity-conflict
   #:provider-request-id-invented
   #:implicit-provider-fallback
   ;; group: dispatch and acknowledgment
   #:adapter-preparation-refused
   #:adapter-dispatch-failed-pre-frontier
   #:adapter-dispatch-failed-post-frontier
   #:acknowledgment-class-unsupported
   #:acknowledgment-ambiguous
   #:provider-request-id-unavailable
   #:idempotency-unsupported
   #:idempotency-domain-mismatch
   ;; group: streaming
   #:stream-identity-missing
   #:stream-chunk-adapter-identity-missing
   #:stream-sequence-gap
   #:stream-sequence-conflict
   #:stream-chunk-identity-collision
   #:stream-finality-conflict
   #:stream-durability-unknown
   #:stream-persistence-order-invalid
   #:partial-manifestation-erasure
   ;; group: envelope and projection
   #:provider-envelope-missing
   #:provider-envelope-integrity-failed
   #:projection-procedure-missing
   #:projection-failed
   #:projection-output-noncanonical
   #:subject-manifestation-conflated-with-envelope
   #:present-payload-erasure
   #:absence-mapping-table-miss
   #:projection-origin-invalid
   #:provider-envelope-redaction-invalid
   ;; group: usage, cost, cancellation, reconciliation
   #:usage-standing-missing
   #:cost-standing-missing
   #:cost-float-noncanonical
   #:cancellation-unsupported
   #:cancellation-unconfirmed
   #:reconciliation-unsupported
   ;; (reconciliation-insufficient and unsafe-retry are Kernel /0's,
   ;; re-exported — reuse, not twinning)
   #:reconciliation-insufficient
   #:unsafe-retry
   #:reconciliation-identity-missing
   ;; group: exposure and witnessing
   #:exposed-principal-boundary-unknown
   #:exposed-principal-drift
   #:adapter-truth-minting
   #:adapter-witness-boundary-missing

   ;; data.lisp — fixture access helpers.
   #:read-pjs-fixture
   #:case-string
   #:case-integer
   #:case-boolean
   #:case-field
   #:case-field-present-p
   #:case-id-string
   #:+reissue-root+

   ;; descriptor.lisp — descriptors, absence table, live binding.
   #:load-canonical-descriptors
   #:descriptor-by-identity
   #:descriptor-witnessable-classes
   #:descriptor-adapter-version
   #:load-absence-table
   #:absence-row-for-shape
   #:absence-row-status
   #:absence-row-state
   #:+absence-shapes+
   #:live-adapter
   #:live-adapter-p
   #:bind-live-adapter
   #:live-adapter-descriptor
   #:live-adapter-descriptor-identity
   #:live-adapter-descriptor-version
   #:live-adapter-instance-label

   ;; registry.lisp — the frozen fixture registry, folded live.
   #:load-registry
   #:registry-entries
   #:registry-entry-case-id
   #:registry-entry-verdict
   #:registry-entry-family
   #:registry-entry-path
   #:registry-scalar
   #:derive-registry-counts
   #:enumerate-mutants

   ;; rules.lisp — the named-rule validator.
   #:+rules+
   #:rule-ids
   #:validate-case
   #:rule-exists-p
   #:+provider-testimony-sources+
   #:+acknowledgment-classes+
   #:+request-identity-timings+
   #:+cost-standings+
   #:+reconciliation-results+

   ;; script-machine.lisp — the deterministic fake-adapter interpreter.
   #:load-script
   #:script-id-string
   #:script-expected-terminal
   #:script-name
   #:run-script
   #:script-run-terminal
   #:script-run-records
   #:script-run-digest
   #:script-run-crashed-p
   #:load-canonical-scripts
   #:script-by-name

   ;; operations.lisp — the §20 operation surface.
   #:describe-adapter
   #:prepare-invocation
   #:dispatch
   #:observe-acknowledgment
   #:observe-stream
   #:await-terminal
   #:cancel-request
   #:reconcile-request
   #:capture-envelope
   #:project-envelope
   #:extract-usage
   #:extract-cost
   #:dispatch-handle
   #:dispatch-handle-p
   #:invocation-spec
   #:make-invocation-spec
   #:prepared-invocation-record
   #:prepared-invocation-p
   #:prepared-invocation-record-record
   #:prepared-invocation-record-local-request-id
   #:prepared-invocation-record-pre-frontier-records
   #:dispatch-handle-dispatch-record
   #:missing-cost-marker-reason
   #:missing-cost-marker
   #:missing-cost-marker-p

   ;; mutants.lisp — registry mutants + internal planted defects.
   #:run-registry-mutant
   #:+planted-defects+
   #:run-planted-defect

   ;; l17 audit
   #:+operation-surface+
   #:lawful-route-actions
   #:l17-route-audit-lines))
