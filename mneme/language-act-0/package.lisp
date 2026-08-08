;;;; package.lisp — One Act /0, the language-act accounting lane.
;;;;
;;;; Governing sentence (contract §1): one Lisp+ form gives rise to one
;;;; witnessed, capability-mediated act — and the language keeps the account
;;;; of what it did while the process keeps the record of what happened.
;;;;
;;;; STANDING: CANDIDATE.  Nothing in this lane is adopted, accepted, frozen,
;;;; audited, or on a governing floor.  Nothing produced here is independent
;;;; verification (AP0 adoption Rider 2, binding; contract §0.3): the phrases
;;;; "independently verified" and "independently validated" may not appear in
;;;; any artifact of this lane.
;;;;
;;;; LABELLED DUAL AUTHORITY (contract §2.3).  This lane runs two named
;;;; offices related by one binding.  Office L is Core /0's fixture capability
;;;; — TEST INFRASTRUCTURE ONLY, under Core /0 disposition D2 as re-adjudicated
;;;; lane-locally by owner ruling R0.1 §2.  It is not production authority, not
;;;; a canonical authority, and this lane may not be cited as progress toward
;;;; naming one.  Surface /3 remains SHUT.
;;;;
;;;; CRASH MODEL: ONE PROCESS LIFE.  No SIGKILL, no process death, no
;;;; cross-death continuation (contract §0.4, §7.1).
;;;;
;;;; THE PACKAGE INTERFACE IS AN IMPLEMENTATION CHOICE.  Contract §13 is headed
;;;; "Examples (NON-NORMATIVE ILLUSTRATION)" and no normative export list exists
;;;; in the bundle; the list below is constrained only by (i) the reserved-name
;;;; discipline of contract §10 / N-1..N-6 and (ii) the seal-time name census.
;;;; In particular NO symbol below is one of the §19.5 / §19.3 / §19.2 / §19.4
;;;; reserved Kernel verbs (N-1): this lane mints no `check-capability`,
;;;; `prepare-effect`, `cross-frontier`, `settle-effect`, `record-bounded-effect`,
;;;; `record-indeterminate-effect`, `compensate-effect`, `begin-attempt`,
;;;; `reconcile-attempt`, or `supersede-attempt`.
;;;;
;;;; NO MACRO IS DEFINED HERE OR ANYWHERE IN THIS LANE (contract S-1), no
;;;; surface head is minted (S-2), no expansion machinery is touched (S-3), and
;;;; Surface Account /0 is not involved (S-4).  The act's form is the existing
;;;; `perform` door.
;;;;
;;;; — FABER-I (Claude Opus 5, subagent), 2026-08-07

(defpackage #:lisp-plus-language-act0
  (:use #:cl)
  (:import-from #:lisp-plus-journal0
                #:create-journal
                #:validate-journal
                #:append-event
                #:append-receipt-ordinal
                #:append-receipt-disposition
                #:find-event
                #:journal-store-store-id
                #:prefix-report-status
                #:prefix-report-frame-count
                #:prefix-report-terminal-digest
                #:prefix-report-events
                #:prefix-report-event-ids
                #:encode-pjs0
                #:decode-pjs0
                #:identifier-from-segments
                #:identifier-segments
                #:identifier-segment-string
                #:record-field
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
                #:live-capability-public-id
                #:live-capability-occurrence-id
                #:live-capability-subject
                #:live-capability-action
                #:live-capability-resource
                #:live-capability-scope)
  (:import-from #:lisp-plus-capability2
                #:make-world
                #:world-cells-sha256
                #:world-ledger-sha256
                #:world-ledger-count
                #:world-cell-value
                #:derive-effect-standing
                #:authorize-effect-attempt
                #:attempt-protected-effect
                #:declare-uncertain-effect
                #:reconcile-uncertain-effect)
  (:import-from #:lisp-plus-kernel0
                #:durable-identity-name)
  (:export
   ;; ---- conditions (contract's lane-local typed refusals) ----
   #:act0-condition #:act0-condition-detail #:act0-condition-requirement-id
   #:act-fixture-table-invalid
   #:act-request-lexis-refused
   #:act-request-shape-refused
   #:act-identity-taken
   #:act-identity-branch
   #:act-authority-binding-refused
   #:act-dispatcher-binding-refused
   #:act-binding-consumed
   #:act-frame-ordering-violated
   #:act-office-r-term-divergence
   #:act-process-identity-divergence
   #:act-bridge-contract-violated
   #:act-readback-disagreement
   ;; ---- the immutable fixture table and the act record ----
   #:act-fixture #:act-fixture-p
   #:act-fixture-label #:act-fixture-language-label #:act-fixture-runtime-seat
   #:act-fixture-attempt-name #:act-fixture-cell-segments
   #:act-fixture-adapter-symbol #:act-fixture-arm #:act-fixture-form
   #:act-record #:act-record-p #:act-record-fixture #:act-record-act-id
   #:*act-fixture-table* #:validate-act-fixture-table
   ;; ---- the numbered trace, step by step ----
   #:canonicalize-request          ; L1b
   #:request-record #:request-sha256-octets
   #:check-cell-lexis #:check-text-lexis
   #:mint-act-identity             ; L1c
   #:bind-offices                  ; L2
   #:run-act                       ; L0..L22, one arm
   #:run-all-arms
   ;; ---- the journal projection ----
   #:frame-event-id #:frame-kind #:lane-envelope
   #:build-f1 #:build-f2 #:build-f3 #:build-f4 #:build-f5
   #:classify-act-frames           ; J-6 cold readback
   ;; ---- the readback and the agreement gate ----
   #:agreement-gate #:correspondence-verdict
   ;; ---- constants ----
   #:+act-id-domain+ #:+runtime-process-name+ #:+lane-event-namespace+
   #:+act-store-nonce+ #:+lane-stem+
   ;; ---- the run harness (gates live in act0-gates.lisp) ----
   #:*run-root* #:*store* #:*worlds* #:*bootstrap* #:*minting-context*
   #:check #:check-eq #:note #:*checks-passed* #:*checks-failed*
   #:w-env-preflight #:build-fixture-worlds #:build-store))
