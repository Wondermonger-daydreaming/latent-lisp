;;;; package.lisp — Capability /1, the minting-bridge candidate.
;;;;
;;;; Governing sentence: a receipt may explain why a key was minted; it is
;;;; not the key, and its description cannot forge one.
;;;;
;;;; Governing texts: LISP-PLUS-KERNEL-0-SPEC.md §11.2 (the MUST this slice
;;;; exists to satisfy: "A capability MUST NOT be reconstructible from
;;;; serialized public fields" — "These records do not grant authority"),
;;;; §11.3 [CAP-2] (the minting bridge: an authorizing claim MAY authorize
;;;; minting; it is not itself a capability), §11.1 [CAP-1] (field subset
;;;; carried; divergences named in CAPABILITY-1-RETURN.md), §11.5 (defensive
;;;; scope handling), §19.5 (reserved verbs — NOT claimed here);
;;;; LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md §19 laws L9, L10, L13,
;;;; L15; CONSTITUTION.md Clause 5.
;;;;
;;;; This package consumes Capability /0 STRICTLY through the public exports
;;;; of #:lisp-plus-capability0 and Journal /0 strictly through the public
;;;; exports of #:lisp-plus-journal0 (the :import-from lists below, plus a
;;;; small number of package-qualified references to other EXPORTED symbols
;;;; of lisp-plus-cd0 / lisp-plus-kernel0 / lisp-plus-journal0 /
;;;; lisp-plus-capability0 in the suites and the specimen — itemized in
;;;; ALLOWED-SOURCES.md).  Neither substrate learns anything about live
;;;; capability objects; both stay unchanged.
;;;;
;;;; The lane's one design center: AUTHORITY LIVES IN PROCESS-LOCAL
;;;; RECOGNITION, NEVER IN COPYABLE FIELDS.  A minting context recognizes
;;;; exactly the objects it minted (EQ membership); every public artifact —
;;;; the authorization receipt, the minting receipt, the object's printed
;;;; form — is truthful testimony that confers nothing.  And the context is
;;;; a RECOGNIZER, never a liveness cache: every presentation re-validates
;;;; the journal fresh; the context recognizes, the journal decides.
;;;;
;;;; — CLAVIGER-II (Claude Fable 5 subagent), 2026-07-29

(defpackage #:lisp-plus-capability1
  (:use #:cl)
  (:import-from #:lisp-plus-journal0
                ;; store surface — the only journal access path.
                #:journal-store-p
                #:journal-store-store-id
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
                #:prefix-report-frame-digests
                #:prefix-report-condition-type
                #:prefix-report-tail-offset
                #:prefix-report-tail-sha256
                ;; PJ-S/0 codec + identifier/record machinery.
                #:encode-pjs0
                #:decode-pjs0
                #:identifier-from-segments
                #:identifier-segments
                #:identifier-segment-string
                #:record-field
                ;; digests (occurrence-identity derivation + transcripts).
                #:sha256-hex)
  (:import-from #:lisp-plus-capability0
                ;; conditions REUSED where the meaning is identical
                ;; (bootstrap discipline; stale authorization receipt at the
                ;; mint step — /0's own present-receipt refusal propagates).
                #:cap0-stale-receipt
                #:cap0-bootstrap-missing
                #:cap0-bootstrap-store-mismatch
                ;; schema surface.
                #:declare-bootstrap-authority
                #:bootstrap-authority-p
                #:bootstrap-authority-issuer
                #:bootstrap-authority-store-id
                #:ensure-identifier
                #:datum=
                #:make-grant-event
                #:make-revocation-event
                ;; receipt surface.
                #:make-authority-receipt
                #:receipt-decision
                #:receipt-reason
                #:receipt-current-p
                ;; the live-authority question + the present-receipt
                ;; discipline this bridge builds on.
                #:query-live-authority
                #:present-receipt-as-present-authority)
  (:export
   ;; conditions.lisp — capability1's OWN typed conditions (each minted only
   ;; because neither kernel0 nor capability0 exports an honest match; the
   ;; adjudications are inline in conditions.lisp and in
   ;; CAPABILITY-1-RETURN.md).
   #:cap1-condition
   #:cap1-condition-detail
   #:cap1-condition-requirement-id
   #:cap1-context-missing
   #:cap1-unrecognized-object
   #:cap1-unrecognized-object-presented-type
   #:cap1-unrecognized-object-presented-public-id
   #:cap1-unrecognized-object-context-label
   #:cap1-term-mismatch
   #:cap1-term-mismatch-capability-public-id
   #:cap1-term-mismatch-mismatched-terms
   #:cap1-stale-capability
   #:cap1-stale-capability-capability-store-id
   #:cap1-stale-capability-capability-terminal-ordinal
   #:cap1-stale-capability-capability-valid-byte-count
   #:cap1-stale-capability-capability-terminal-digest
   #:cap1-stale-capability-present-store-id
   #:cap1-stale-capability-present-terminal-ordinal
   #:cap1-stale-capability-present-valid-byte-count
   #:cap1-stale-capability-present-terminal-digest
   #:cap1-mint-refused
   #:cap1-mint-refused-basis
   #:cap1-mint-refused-fresh-reason
   #:cap1-mint-refused-fresh-receipt

   ;; context.lisp — the explicit minting context (recognizer, never cache).
   #:minting-context
   #:minting-context-p
   #:make-minting-context
   #:minting-context-label
   #:minting-context-minted-count
   #:context-recognizes-p

   ;; object.lisp — the opaque live capability.  READERS ONLY; every reader
   ;; is defensive (§11.5).  There is NO exported constructor and NO copier:
   ;; the only way a recognized object comes to exist is
   ;; MINT-FROM-AUTHORIZATION registering what it created.
   #:live-capability-p
   #:live-capability-public-id
   #:live-capability-occurrence-id
   #:live-capability-subject
   #:live-capability-action
   #:live-capability-resource
   #:live-capability-scope
   #:live-capability-minter
   #:live-capability-store-id
   #:live-capability-terminal-ordinal
   #:live-capability-valid-byte-count
   #:live-capability-terminal-digest

   ;; mint.lisp — the §11.3 bridge (deliberately NOT the §19.5 reserved verb
   ;; mint-capability; see CAPABILITY-1-RETURN.md).
   #:mint-from-authorization

   ;; present.lisp — presentation (deliberately NOT the §19.5 reserved verb
   ;; check-capability).
   #:present-live-capability

   ;; mutants.lisp — planted defects + the kill harness.
   #:+planted-defects+
   #:run-mutant-kill))
