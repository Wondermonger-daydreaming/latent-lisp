;;;; package.lisp — One Act /1, the language act across PROCESS DEATH.
;;;;
;;;; Governing sentence (work order §0): the language door survives the
;;;; process's death as a refusal — a genuinely new image, given only durable
;;;; bytes and declared configuration, must refuse the same act at the `perform`
;;;; boundary, and may proceed only through evidence-carried reconciliation at
;;;; the runtime level.
;;;;
;;;; STANDING: CANDIDATE.  Nothing in this lane is adopted, accepted, frozen,
;;;; audited, or on a governing floor.  Nothing produced here is independent
;;;; verification: the phrases "independently verified" and "independently
;;;; validated" may not appear in any artifact of this lane.  This lane is
;;;; capability-DISCIPLINED and never capability-SECURE.
;;;;
;;;; CRASH MODEL: PLANTED DETERMINISTIC DEATH ONLY.  A separate process is
;;;; ended by an env-var-controlled `sb-ext:exit` inside capability /2's world
;;;; adapter (world.lisp:239-244).  NO SIGKILL, no power loss, no
;;;; mid-instruction byte truncation is claimed anywhere in this lane —
;;;; journal0/de-teste-occiso and vertical0 own the real crash windows.
;;;;
;;;; N-1 (the reserved-verb constraint of One Act /0's contract §10, restated
;;;; and unclaimed here): NO symbol below is one of the §19.5 / §19.3 / §19.2 /
;;;; §19.4 reserved Kernel verbs.  This lane mints no `check-capability`,
;;;; `prepare-effect`, `cross-frontier`, `settle-effect`, `record-bounded-effect`,
;;;; `record-indeterminate-effect`, `compensate-effect`, `begin-attempt`,
;;;; `reconcile-attempt`, or `supersede-attempt`.
;;;;
;;;; NO MACRO IS DEFINED HERE OR ANYWHERE IN THIS LANE, no surface head is
;;;; minted, no expansion machinery is touched, and Surface Account /0 is not
;;;; involved.  The act's form is the existing `perform` door.  Surface /3
;;;; stays SHUT.
;;;;
;;;; THE PACKAGE INTERFACE IS AN IMPLEMENTATION CHOICE.  No normative export
;;;; list exists for a language-act lane; the list below is constrained only by
;;;; the reserved-name discipline above and by this lane's own readiness
;;;; predicate (load.lisp), which asserts every name here is external and bound
;;;; as its kind requires before the lane is considered loaded.
;;;;
;;;; — PONTIFEX (Claude Opus 5, subagent), 2026-08-19

(defpackage #:lisp-plus-language-act1
  (:use #:cl)
  (:import-from #:lisp-plus-journal0
                #:create-journal
                #:open-store
                #:validate-journal
                #:append-event
                #:find-event
                #:journal-store-store-id
                #:journal-store-directory
                #:prefix-report-status
                #:prefix-report-frame-count
                #:prefix-report-terminal-digest
                #:prefix-report-events
                #:prefix-report-event-ids
                #:prefix-report-tail-sha256
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
                #:sha256-hex)
  (:import-from #:lisp-plus-capability0
                #:ensure-identifier
                #:datum=
                #:declare-bootstrap-authority
                #:make-grant-event
                #:make-revocation-event
                #:query-live-authority
                #:receipt-decision)
  (:import-from #:lisp-plus-capability1
                #:make-minting-context
                #:mint-from-authorization
                #:live-capability-p
                #:live-capability-resource)
  (:import-from #:lisp-plus-capability2
                #:make-world
                #:open-world
                #:world-cell-value
                #:world-cells-sha256
                #:world-ledger-sha256
                #:world-ledger-count
                #:world-ledger-lookup
                #:derive-effect-standing
                #:authorize-effect-attempt
                #:attempt-protected-effect
                #:declare-uncertain-effect
                #:reconcile-uncertain-effect
                #:check-retry-safety-from-store)
  (:import-from #:lisp-plus-kernel0
                #:durable-identity-name)
  (:export
   ;; ---- typed lane-local refusals (TYPES) ------------------------------
   #:act1-condition
   #:act1-fixture-table-invalid
   #:act1-request-shape-refused
   #:act1-request-lexis-refused
   #:act1-authority-binding-refused
   #:act1-dispatcher-binding-refused
   #:act1-bridge-contract-violated
   #:act1-readback-disagreement
   #:act1-run-void
   ;; ---- structure TYPES -------------------------------------------------
   #:act1-fixture #:act1-record #:act1-result #:world-scope-snapshot
   ;; ---- condition readers ----------------------------------------------
   #:act1-condition-detail #:act1-condition-requirement-id
   ;; ---- the immutable act-fixture row (this lane's OWN table) ----------
   #:act1-fixture-p #:make-act1-fixture-row
   #:act1-fixture-arm #:act1-fixture-label #:act1-fixture-language-label
   #:act1-fixture-runtime-seat #:act1-fixture-attempt-name
   #:act1-fixture-cell-segments #:act1-fixture-adapter-symbol
   #:act1-fixture-world-key #:act1-fixture-form #:act1-fixture-authority-mode
   #:act1-fixture-durable-guard #:act1-fixture-interruption
   #:act1-fixture-runtime-defect #:act1-fixture-project-defect
   #:act1-fixture-host-fault-plant
   #:act1-fixture-leak-write #:act1-fixture-revoke-after-mint
   #:validate-act1-fixture-table
   ;; ---- the act record and its derived identity ------------------------
   #:act1-record-p #:act1-record-fixture #:act1-record-act-id
   #:act1-record-act-id-hex #:act1-record-normal-form
   #:act1-record-request-rec #:act1-record-request-oct
   #:canonicalize-act1-request #:act1-request-record #:act1-request-octets
   #:mint-act1-identity #:make-act1-record
   #:check-act1-cell-lexis #:check-act1-text-lexis
   ;; ---- the doors -------------------------------------------------------
   #:act1-request-form #:act1-grant-terms-for #:act1-capability-id-for
   #:act1-durable-guard-verdict
   #:make-act1-bridge #:act1-dispatch #:act1-ledger-query
   #:run-act1
   #:act1-result-p #:act1-result-record #:act1-result-class
   #:act1-result-standing #:act1-result-disposition #:act1-result-outcome
   #:act1-result-evidence #:act1-result-reason #:act1-result-guard
   #:act1-result-refusal-type #:act1-result-context #:act1-result-bridge
   #:act1-journal-kinds #:act1-reconciliation-closes-seat-p
   ;; ---- the world-scope absence instrument ------------------------------
   #:world-scope-snapshot-p
   #:world-scope-snapshot-cells-sha #:world-scope-snapshot-ledger-sha
   #:world-scope-snapshot-ledger-count #:world-scope-snapshot-key-count
   #:world-scope-snapshot-cells-octets #:world-scope-snapshot-ledger-octets
   #:world-scope-snapshot-key #:world-scope-snapshot-files
   #:take-world-scope #:world-scope-unchanged-p #:print-world-scope-universe
   #:external-request-key
   ;; ---- declared constants ----------------------------------------------
   #:+act1-id-domain+ #:+act1-lane-stem+ #:+act1-runtime-process-name+
   #:+act1-store-nonce+ #:+act1-request-rendering-version+
   ;; ---- the in-process harness ------------------------------------------
   #:*act1-run-root* #:*act1-store* #:*act1-worlds* #:*act1-bootstrap*
   #:*act1-minting-context* #:*act1-world-directories* #:*act1-fixture-table*
   #:*checks-passed* #:*checks-failed*
   #:act1-check #:act1-note #:act1-env-preflight
   #:build-act1-store #:build-act1-worlds #:act1-opening-authority))
