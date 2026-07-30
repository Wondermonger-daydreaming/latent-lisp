;;;; package.lisp — Capability /2, the effect-frontier candidate.
;;;;
;;;; Governing sentence: a recognized, current capability may justify
;;;; attempting one exact protected effect — but neither the capability nor
;;;; its presentation receipt proves that the effect occurred.
;;;;
;;;; Governing texts: LISP-PLUS-KERNEL-0-SPEC.md §10 (effects and frontiers:
;;;; §10.1/§10.2 declaration and classes, §10.3 progression, §10.4 [OP-1]
;;;; pre-frontier closure, §10.8 [UNC-1, UNC-2] the structured
;;;; uncertain-effect record), §11.4 (the frontier capability check — a
;;;; NAMED SUBSET here), §11.6 [CAP-4] (revocation at every consequential
;;;; frontier), §9.2/§9.4 (refusal is pre-frontier; :bounded/:indeterminate
;;;; effect axes reference the §10.8 record), §14 (no blind retry;
;;;; reconciliation; idempotency honesty); AP0 (ADOPTED reissue) AP-CON-1
;;;; (a fake adapter is not a separate weaker species — the world below is
;;;; a controlled effect adapter under a LABELED AP0 SUBSET), AP-ACK-4 (an
;;;; acknowledgment class has no settling force by itself), AP-CRASH-1
;;;; (resolvedness is fold-derived; no stored resolved flag);
;;;; PJ0 fold law PJ-FOLD-1/2/4 and §16 (no stored resolved flag anywhere);
;;;; the two-door law (language-core-0 OWNER-RULING-TWO-DOORS);
;;;; CONSTITUTION.md Clause 5.
;;;;
;;;; This package consumes Capability /1 STRICTLY through the public exports
;;;; of #:lisp-plus-capability1, Capability /0 through
;;;; #:lisp-plus-capability0, Journal /0 through #:lisp-plus-journal0, and
;;;; Kernel /0 through #:lisp-plus-kernel0 (the :import-from lists below,
;;;; plus a small number of package-qualified references to other EXPORTED
;;;; symbols of lisp-plus-cd0 / lisp-plus-kernel0 in the modules and suites
;;;; — itemized in ALLOWED-SOURCES.md).  Every substrate stays unchanged.
;;;;
;;;; The lane's one design center: THE JOIN OF TWO PROVEN HALVES.  core0
;;;; proved no-innocent-retry IN MEMORY; journal0 proved restart WITHOUT
;;;; effects; this lane executes the seam — the §14.1 retry prohibition
;;;; carried across process death by durable bytes alone, against a world
;;;; that survives the process while the process's memory does not.
;;;;
;;;; — CLAVIGER-III (Claude Fable 5 subagent), 2026-07-30

(defpackage #:lisp-plus-capability2
  (:use #:cl)
  (:import-from #:lisp-plus-journal0
                ;; store surface — the only journal access path.
                #:journal-store-p
                #:journal-store-store-id
                #:journal-store-directory
                #:open-store
                #:create-journal
                #:validate-journal
                #:append-event
                #:append-receipt-ordinal
                #:append-receipt-disposition
                ;; strict-reader report accessors (the validated prefix).
                #:prefix-report-status
                #:prefix-report-frame-count
                #:prefix-report-valid-byte-count
                #:prefix-report-terminal-digest
                #:prefix-report-events
                #:prefix-report-event-ids
                #:prefix-report-tail-offset
                #:prefix-report-tail-sha256
                ;; PJ-S/0 codec + identifier/record machinery.
                #:encode-pjs0
                #:decode-pjs0
                #:identifier-from-segments
                #:identifier-segments
                #:identifier-segment-string
                #:record-field
                ;; metadata surface (specimen-side declared-config identity).
                #:store-id-string
                #:validate-metadata-octets
                #:render-metadata-octets
                #:build-metadata-record
                #:journal-store-durability
                ;; digests.
                #:sha256-hex)
  (:import-from #:lisp-plus-capability0
                #:ensure-identifier
                #:datum=
                #:declare-bootstrap-authority
                #:bootstrap-authority-p
                #:bootstrap-authority-store-id
                #:make-grant-event
                #:make-revocation-event
                #:query-live-authority
                #:receipt-decision
                #:receipt-reason
                #:receipt-current-p)
  (:import-from #:lisp-plus-capability1
                #:make-minting-context
                #:mint-from-authorization
                #:present-live-capability
                #:live-capability-p
                #:live-capability-public-id
                #:live-capability-occurrence-id
                #:live-capability-subject
                #:live-capability-action
                #:live-capability-resource
                #:live-capability-scope
                #:live-capability-store-id
                #:live-capability-terminal-ordinal
                #:live-capability-valid-byte-count
                #:live-capability-terminal-digest
                #:cap1-stale-capability
                #:cap1-unrecognized-object
                #:cap1-term-mismatch)
  (:import-from #:lisp-plus-kernel0
                ;; conditions REUSED where the meaning is identical (the
                ;; lane's standing never-both rule; adjudications in
                ;; conditions.lisp).
                #:signal-kernel0
                #:kernel0-condition
                #:unsafe-retry
                #:unstructured-uncertainty
                #:duplicate-attempt-identity
                #:reconciliation-insufficient
                ;; the §10.8 primitive + §14.2 receipt, consumed not re-minted.
                #:make-uncertain-effect
                #:uncertain-effect-p
                #:uncertain-effect-kind
                #:uncertain-effect-attempt
                #:uncertain-effect-external-request
                #:uncertain-effect-possible-effects
                #:uncertain-effect-known-facts
                #:uncertain-effect-reconciliation-procedure
                #:uncertain-effect-retry-policy
                #:make-reconciliation-receipt
                #:reconciliation-receipt-p
                ;; identity + axis machinery for rehydration.
                #:make-identity
                #:identity=
                #:durable-identity-name
                #:make-determinacy
                #:make-effect-axis
                ;; the adopted fold surface (the retry law's one home).
                #:make-kernel0-event
                #:check-retry-safety)
  (:export
   ;; conditions.lisp — capability2's OWN typed conditions (each minted only
   ;; because no substrate export is honest; adjudications inline there).
   #:cap2-condition
   #:cap2-condition-detail
   #:cap2-condition-requirement-id
   #:cap2-world-missing
   #:cap2-authorization-missing
   #:cap2-authorization-mismatch
   #:cap2-authorization-mismatch-facets
   #:cap2-stale-authorization
   #:cap2-stale-authorization-authorization-store-id
   #:cap2-stale-authorization-authorization-terminal-ordinal
   #:cap2-stale-authorization-authorization-valid-byte-count
   #:cap2-stale-authorization-authorization-terminal-digest
   #:cap2-stale-authorization-present-store-id
   #:cap2-stale-authorization-present-terminal-ordinal
   #:cap2-stale-authorization-present-valid-byte-count
   #:cap2-stale-authorization-present-terminal-digest
   #:cap2-effect-not-authorized
   #:cap2-effect-not-authorized-requested-cell
   #:cap2-effect-not-authorized-authorized-cell
   #:cap2-attempt-authorization-refused
   #:cap2-attempt-authorization-refused-basis
   #:cap2-attempt-authorization-refused-fresh-reason
   #:cap2-attempt-authorization-refused-fresh-receipt
   #:cap2-nothing-uncertain

   ;; world.lisp — the controlled effect adapter under a labeled AP0 subset.
   #:make-world
   #:open-world
   #:world-p
   #:world-adapter-id
   #:world-script
   #:world-cell-value
   #:world-cells-sha256
   #:world-ledger-count
   #:world-ledger-lookup
   #:world-ledger-sha256

   ;; events.lisp — standing derived from durable bytes.
   #:derive-effect-standing

   ;; rehydrate.lisp — THE LANE'S NOVEL SEAM: stored PJ0 bytes -> live
   ;; kernel /0 records -> the adopted retry fold.
   #:rehydrate-kernel-events
   #:check-retry-safety-from-store

   ;; authorize.lisp — the §11.4 NAMED-SUBSET authorization (deliberately
   ;; NOT the §19.5 reserved verb check-capability).
   #:authorize-effect-attempt

   ;; attempt.lisp — the explicit invocation (deliberately NOT the §19.3
   ;; reserved verbs prepare-effect / cross-frontier / settle-effect, and
   ;; NOT core0's occupied perform).
   #:attempt-protected-effect

   ;; reconcile.lisp — structuring + evidence-carrying resolution
   ;; (deliberately NOT the §19.3 reserved verbs record-bounded-effect /
   ;; record-indeterminate-effect / compensate-effect and NOT §19.2
   ;; reconcile-attempt).
   #:declare-uncertain-effect
   #:reconcile-uncertain-effect

   ;; mutants.lisp — planted defects + the kill harness.
   #:+planted-defects+
   #:run-mutant-kill))
