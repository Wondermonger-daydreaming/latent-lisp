;;;; package.lisp — Vertical Specimen /0, the four-death latent machine.
;;;;
;;;; Governing artifacts: mneme/vertical0/LISP-PLUS-VERTICAL-SPECIMEN-0.md
;;;; (the sealed pre-code contract), VERTICAL-PROGRAM-CONFIG.sexp (the
;;;; program-lawful input), the ruling
;;;; mneme/RULING-adapter0-closure-ap-cost-1-vertical0-2026-07-30.md.
;;;;
;;;; JURISDICTION: this package is the PROGRAM side of the specimen's
;;;; mechanical partition (contract §2).  It lawfully knows the program
;;;; config and the durable evidence in its execution directory — never
;;;; life numbers, W labels, the kill schedule, expected folds, expected
;;;; outcomes, the oracle pathname, or private fake-world truth.  The
;;;; harness (mneme/vertical0/harness/) is a different program and never
;;;; shares this package's process.
;;;;
;;;; Every predecessor is consumed strictly through its public package
;;;; exports (integration lane; contract preamble).  No predecessor
;;;; source is modified.
;;;;
;;;; — FABER-MORTIS (Claude Fable 5 subagent), 2026-07-30

(defpackage #:lisp-plus-vertical0
  (:use #:cl)
  (:import-from #:lisp-plus-journal0
                #:open-store
                #:create-journal
                #:validate-journal
                #:append-event
                #:encode-pjs0
                #:decode-pjs0
                #:identifier-from-segments
                #:identifier-segments
                #:identifier-segment-string
                #:record-field
                #:store-id-string
                #:validate-metadata-octets
                #:render-metadata-octets
                #:build-metadata-record
                #:journal-store-store-id
                #:prefix-report-status
                #:prefix-report-frame-count
                #:prefix-report-events
                #:prefix-report-terminal-digest
                #:sha256-hex)
  (:import-from #:lisp-plus-capability0
                #:declare-bootstrap-authority
                #:make-grant-event
                #:make-revocation-event
                #:query-live-authority
                #:receipt-decision
                #:receipt-reason)
  (:import-from #:lisp-plus-capability1
                #:make-minting-context
                #:mint-from-authorization
                #:live-capability-p)
  (:import-from #:lisp-plus-capability2
                #:make-world
                #:open-world
                #:world-cell-value
                #:world-ledger-count
                #:world-ledger-lookup
                #:world-cells-sha256
                #:world-ledger-sha256
                #:derive-effect-standing
                #:check-retry-safety-from-store
                #:authorize-effect-attempt
                #:attempt-protected-effect
                #:declare-uncertain-effect
                #:reconcile-uncertain-effect)
  (:import-from #:lisp-plus-adapter0
                #:descriptor-by-identity
                #:bind-live-adapter
                #:make-invocation-spec
                #:prepare-invocation
                #:prepared-invocation-record-pre-frontier-records
                #:prepared-invocation-record-local-request-id
                #:dispatch
                #:dispatch-handle-dispatch-record
                #:observe-acknowledgment
                #:observe-stream
                #:await-terminal
                #:capture-envelope
                #:project-envelope
                #:extract-usage
                #:extract-cost
                #:parse-cost-lexeme
                #:missing-cost-marker-p
                #:reconcile-request
                #:load-absence-table
                #:absence-row-for-shape
                #:absence-row-status
                #:absence-row-state)
  (:export
   ;; config-reader.lisp
   #:read-vertical-config
   #:config-field
   #:config-bank
   #:config-policy
   #:config-seat-order
   #:config-route-pauses
   #:config-nonce-octets
   #:config-durability
   #:seat-field
   ;; records.lisp
   #:vertical-condition
   #:budget-ceiling-exceeded
   #:stream-resume-would-duplicate
   #:vertical-unresumable-seat
   ;; evidence.lisp
   #:write-evidence-file
   #:read-octet-file
   ;; budget.lisp
   #:fold-durable-costs
   #:check-budget-before-frontier
   ;; recovery-projection.lisp
   #:vertical-recovery-projection-0
   ;; interpretation.lisp
   #:vertical-interpretation-0
   ;; census.lisp
   #:derive-census
   #:census-outcomes))
