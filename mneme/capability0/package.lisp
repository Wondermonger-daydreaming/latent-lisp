;;;; package.lisp — Capability /0, the live-authority candidate.
;;;;
;;;; Governing sentence: history may prove that authority once existed; only
;;;; the validated present prefix can say whether it remains live.
;;;;
;;;; Governing texts: LISP-PLUS-KERNEL-0-SPEC.md §11 (capability-authority
;;;; law; §11.2 "these records do not grant authority", §11.4 check, §11.6
;;;; revocation distinctions), §19.5 (reserved verbs — NOT claimed here);
;;;; LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md §19 laws L5, L8, L10, L13,
;;;; L15; CONSTITUTION.md Clause 5 (authority ontology);
;;;; IMPLEMENTATION-PHASE-BOARD-2026-07-18.md:89 ("A durable record that
;;;; authority existed is evidence about the past; it is not live authority
;;;; in the present.").
;;;;
;;;; This package consumes Journal /0 STRICTLY through the public exports of
;;;; #:lisp-plus-journal0 (the :import-from list below is the exact consumed
;;;; surface).  journal0 stays capability-ignorant.  Typed refusals PREFER
;;;; kernel /0's existing exported condition types (capability-missing,
;;;; capability-revoked, capability-scope-mismatch, minting-authority-invalid,
;;;; journal-prefix-invalid); capability0 mints its OWN conditions only where
;;;; kernel0 has no honest match (bootstrap configuration, stale receipt
;;;; binding, malformed authority event) — the WHY is itemized in
;;;; CAPABILITY-0-RETURN.md.
;;;;
;;;; — CLAVIGER (Claude Fable 5 subagent), 2026-07-29

(defpackage #:lisp-plus-capability0
  (:use #:cl)
  (:import-from #:lisp-plus-journal0
                ;; store surface (§22 names) — the ONLY journal access path.
                #:journal-store-p
                #:journal-store-store-id
                #:open-store
                #:create-journal
                #:validate-journal
                #:append-event
                #:find-event
                #:append-receipt-ordinal
                #:append-receipt-disposition
                ;; strict-reader report accessors (the validated prefix).
                #:prefix-report-status
                #:prefix-report-frame-count
                #:prefix-report-valid-byte-count
                #:prefix-report-terminal-digest
                #:prefix-report-events
                #:prefix-report-event-ids
                #:prefix-report-frame-digests
                #:prefix-report-condition-type
                #:prefix-report-tail-offset
                #:prefix-report-tail-sha256
                ;; PJ-S/0 codec + identifier/record machinery (CD/0 equality
                ;; is byte-equality of canonical encodings).
                #:encode-pjs0
                #:decode-pjs0
                #:identifier-from-segments
                #:identifier-segments
                #:identifier-segment-string
                #:record-field
                ;; digests + the genesis constant (used ONLY by the planted
                ;; receipt-unbound-to-prefix mutant, as the plausible-looking
                ;; wrong binding).
                #:sha256-hex
                #:+genesis-digest-hex+)
  (:export
   ;; conditions.lisp — capability0's OWN typed conditions (each minted only
   ;; because kernel0 exports no honest match; see CAPABILITY-0-RETURN.md).
   #:cap0-condition
   #:cap0-condition-detail
   #:cap0-condition-requirement-id
   #:cap0-bootstrap-missing
   #:cap0-bootstrap-store-mismatch
   #:cap0-bootstrap-store-mismatch-expected
   #:cap0-bootstrap-store-mismatch-actual
   #:cap0-malformed-authority-event
   #:cap0-malformed-authority-event-ordinal
   #:cap0-malformed-authority-event-missing-field
   #:cap0-stale-receipt
   #:cap0-stale-receipt-receipt-store-id
   #:cap0-stale-receipt-receipt-terminal-ordinal
   #:cap0-stale-receipt-receipt-valid-byte-count
   #:cap0-stale-receipt-receipt-terminal-digest
   #:cap0-stale-receipt-present-store-id
   #:cap0-stale-receipt-present-terminal-ordinal
   #:cap0-stale-receipt-present-valid-byte-count
   #:cap0-stale-receipt-present-terminal-digest

   ;; schema.lisp — explicit bootstrap authority + event constructors +
   ;; exact canonical equality.
   #:bootstrap-authority
   #:bootstrap-authority-p
   #:make-bootstrap-authority
   #:bootstrap-authority-issuer
   #:bootstrap-authority-store-id
   #:declare-bootstrap-authority
   #:ensure-identifier
   #:datum=
   #:make-grant-event
   #:make-revocation-event

   ;; fold.lisp — live authority is FOLD-DERIVED from the validated prefix.
   #:authority-ledger
   #:authority-ledger-p
   #:authority-ledger-store-id
   #:authority-ledger-records
   #:authority-ledger-report
   #:capability-record
   #:capability-record-p
   #:capability-record-capability-id
   #:capability-record-grant-ordinal
   #:capability-record-grant-event-id
   #:capability-record-subject
   #:capability-record-action
   #:capability-record-resource
   #:capability-record-scope
   #:capability-record-issuer
   #:capability-record-revocation-ordinal
   #:capability-record-revocation-event-id
   #:capability-record-dispositions
   #:derive-authority-ledger
   #:capability-history

   ;; receipts.lisp — receipts bound to the exact validated prefix.
   #:make-authority-receipt
   #:receipt-decision
   #:receipt-reason
   #:receipt-mismatched-terms
   #:receipt-current-p

   ;; query.lisp — the live-authority question, answered fold-first.
   #:query-live-authority
   #:require-live-authority
   #:present-receipt-as-present-authority

   ;; mutants.lisp — planted defects + the kill harness.
   #:+planted-defects+
   #:run-mutant-kill
   #:*mutant-ledger-cache*))
