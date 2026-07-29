;;;; package.lisp — Process Journal /0, independently-seeded Common Lisp store.
;;;;
;;;; Governing texts: LISP-PLUS-PROCESS-JOURNAL-0-SPEC.md (all sections),
;;;; PJ0-PRESEAL-REPAIRS.md (R-PJ-1..3, incl. PJ-READ-0), Kernel /0 spec
;;;; store-boundary sections, Kernel Errata 0.2.  Written fresh from spec text
;;;; and frozen vectors under mneme/journal0/ALLOWED-SOURCES.md; the Python
;;;; reference tool was never opened (Errata 0.2 §7 charge).
;;;;
;;;; — CONDITOR (Claude Fable 5 subagent), 2026-07-29

(defpackage #:lisp-plus-journal0
  (:use #:cl)
  (:export
   ;; sha256.lisp — own digest engine (FIPS 180-4, written from the standard).
   #:sha256-octets
   #:sha256-hex

   ;; conditions.lisp — §23 typed conditions + PJ-CND-2 restarts.
   #:pj0-condition
   #:pj0-condition-store-id
   #:pj0-condition-byte-offset
   #:pj0-condition-expected-ordinal
   #:pj0-condition-terminal-digest
   #:pj0-condition-requirement-id
   #:pj0-condition-evidence
   #:pj0-condition-detail
   #:pj0-metadata-invalid
   #:pj0-store-id-mismatch
   #:pj0-noncanonical-payload
   #:pj0-invalid-utf8
   #:pj0-header-invalid
   #:pj0-ordinal-gap
   #:pj0-payload-length-invalid
   #:pj0-payload-digest-mismatch
   #:pj0-previous-digest-mismatch
   #:pj0-frame-digest-mismatch
   #:pj0-frame-separator-invalid
   #:pj0-torn-tail
   #:pj0-interior-corruption
   #:pj0-event-identity-collision
   #:pj0-duplicate-committed-event
   #:pj0-lock-failure
   #:pj0-durability-barrier-failure
   #:pj0-salvage-receipt-required
   #:pj0-merge-receipt-required
   #:pj0-merge-causal-conflict
   #:unsupported-reconstruction
   #:pj0-resource-bound-exceeded    ; §34 resource refusal (not corruption)
   #:signal-pj0
   #:with-pj0-restarts
   #:abandon
   #:inspect-evidence
   #:salvage-to-new-store
   #:reconcile-identical-event
   #:request-authorized-merge

   ;; pjs0.lisp — the PJ-S/0 §5 text codec, written fresh (no host READ).
   #:pjs0-bounds
   #:make-pjs0-bounds
   #:decode-pjs0
   #:encode-pjs0
   #:pjs0-canonical-p
   #:utf8-decode-scalars
   #:utf8-encode-scalars
   #:identifier-from-segments
   #:identifier-segments
   #:identifier-segment-string
   #:record-field

   ;; frame.lisp — §7 grammar + §8 digests.
   #:+genesis-digest-hex+
   #:frame-digest-hex
   #:render-frame-octets
   #:canonical-decimal-p
   #:lowercase-hex-64-p

   ;; meta.lisp — §6 metadata and store identity.
   #:derive-store-id-hex
   #:store-id-string
   #:validate-metadata-octets
   #:build-metadata-record
   #:render-metadata-octets

   ;; reader.lisp — §12 sixteen steps + §13 terminal classification.
   #:prefix-report
   #:prefix-report-p
   #:prefix-report-status
   #:prefix-report-frame-count
   #:prefix-report-valid-byte-count
   #:prefix-report-terminal-digest
   #:prefix-report-events
   #:prefix-report-event-ids
   #:prefix-report-frame-digests
   #:prefix-report-condition-type
   #:prefix-report-condition-requirement
   #:prefix-report-tail-offset
   #:prefix-report-tail-octets
   #:prefix-report-tail-sha256
   #:prefix-report-detail
   #:validate-event-octets
   #:*validator-defect*

   ;; store surface (§22 names).
   #:journal-store
   #:journal-store-p
   #:journal-store-directory
   #:journal-store-metadata
   #:journal-store-store-id
   #:journal-store-durability
   #:open-store
   #:create-journal
   #:validate-journal
   #:append-event
   #:find-event
   #:read-prefix-valid
   #:salvage-valid-prefix
   #:reconstruct
   #:merge-journals
   #:explain-journal
   #:append-receipt
   #:append-receipt-p
   #:append-receipt-record
   #:append-receipt-origin
   #:append-receipt-disposition
   #:append-receipt-ordinal

   ;; fold.lisp — §16/§17 + K0E-26 joint reporting.
   #:fold-source-events
   #:project-kernel-events
   #:joint-structural-semantic-report
   #:derive-seat-resolution

   ;; mutants.lisp — §28 planted defective validators.
   #:+planted-defects+
   #:run-mutant-kill))
