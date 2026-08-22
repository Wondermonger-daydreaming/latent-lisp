;;;; package.lisp — Memory Layer /0: the LANGUAGE's durable account of its own
;;;; act.
;;;;
;;;; Governing sentence (the commission's own words): "The language can remember
;;;; what its account is entitled to say — and can durably remember that it is
;;;; not entitled to say more."
;;;;
;;;; THE LAW THIS LANE MAKES EXECUTABLE, and nothing wider:
;;;;
;;;;   ISSUED(evidence, act)     ⇏ OCCURRED(act)
;;;;   DURABLE(evidence)         ⇏ OCCURRED(act)
;;;;   RETRIEVED(account)        ⇏ CURRENT-IMAGE-EVIDENCE(account)
;;;;   RETRIEVED(account)        ⇏ AUTHORIZED-TO-CONTINUE(act)
;;;;
;;;; The RED disease in one sentence: EVIDENCE-PRESENT IS TREATED AS
;;;; OCCURRENCE-PRESENT.  The certificate must never eat the event.
;;;;
;;;; STANDING: CANDIDATE.  Nothing in this lane is adopted, accepted, frozen,
;;;; audited, or registered on a governing floor.  Nothing produced here is
;;;; independent verification: the phrases "independently verified" and
;;;; "independently validated" may not appear in any artifact of this lane.
;;;; This lane is capability-DISCIPLINED and never capability-SECURE.
;;;;
;;;; CRASH MODEL: PLANTED DETERMINISTIC PROCESS DEATH ONLY.  Separate
;;;; `sbcl --script` processes, ended by an env-var-controlled `sb-ext:exit`
;;;; inside capability /2's world adapter (world.lisp:239-244).  NO SIGKILL, no
;;;; power loss, no mid-instruction byte truncation is claimed anywhere in this
;;;; lane.  journal0/de-teste-occiso owns SIGKILL at the STORE level and may be
;;;; cited; it is never annexed.
;;;;
;;;; DURABILITY CEILING, quoted and never widened: canonical bytes are carried
;;;; across a fresh process by an ADOPTED-spec, CANDIDATE-implementation journal
;;;; store whose durability is a declared fsync-barrier host-contract belief on
;;;; Linux ext4, demonstrated against a real SIGKILL at one governed progress
;;;; point in a separate specimen — never power loss, never adversarial
;;;; tampering, never a storage-stack proof.
;;;;
;;;; GOVERNING ADOPTED LAW, by its own name: L15 — Witness separation
;;;; (architecture/LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md:1553-1555):
;;;; "A process's unaided account of its own history is asserted testimony.
;;;; Observational standing requires a distinct, inspectable witnessing
;;;; mechanism."  Its operational ancestors — AP-JRN-1, AP-REC-1, AP-CAN-6 —
;;;; are written for the ADAPTER/PROVIDER boundary and are cited as governing
;;;; precedent whose reasoning transfers, never as automatically binding here.
;;;; MEMORY-LAYER-0-SPEC.md §3 says which clause is carried across.
;;;;
;;;; ADOPTED VOCABULARY, used instead of new coinages: Retrieve is EVIDENCE
;;;; REPLAY (Architecture 0.1 D6 replay triad) — never execution replay, never
;;;; output reproduction.  Consolidation obeys D4 verbatim: "cross-journal
;;;; merges are receipt-bearing transformations, never timestamp sorts".
;;;; Authority obeys D5/DK-3: a record that authority existed is not authority.
;;;;
;;;; ⚠ THE TWO LANE-LOCAL DISCRIMINANTS AND THE GAP THEY FILL.  Architecture
;;;; 0.1's four adopted outcome axes (execution · manifestation · external
;;;; effect · interpretation) are axes OF AN OUTCOME, held by a live actor.
;;;; They do NOT cover (a) OCCURRENCE STANDING — a later reader's warranted
;;;; reading of whether an act happened — or (b) ISSUANCE STANDING — whether a
;;;; language-level evidence account was minted.  This lane mints exactly those
;;;; two, lane-locally, and FLAGS THE GAP rather than silently amending the
;;;; architecture.  The world/effect question reuses the adopted external-effect
;;;; axis determinacies verbatim, as a SCOPED OBSERVATION of cap2's fold-derived
;;;; standing — never the standing itself.
;;;;
;;;; NO MACRO IS DEFINED HERE OR ANYWHERE IN THIS LANE, no surface head is
;;;; minted, no expansion machinery is touched, and Surface Account /0 is not
;;;; involved.  No §19.5 / §19.3 / §19.2 / §19.4 reserved Kernel verb is minted:
;;;; this lane defines no `check-capability`, `prepare-effect`, `cross-frontier`,
;;;; `settle-effect`, `record-bounded-effect`, `record-indeterminate-effect`,
;;;; `compensate-effect`, `begin-attempt`, `reconcile-attempt`, or
;;;; `supersede-attempt`.
;;;;
;;;; ZERO EDITS OUTSIDE THIS LANE.  No Core /0 change, no public evidence
;;;; constructor, no `continue-from` weakening, no adopted-lane edit, no ASDF
;;;; row, no floor registration.
;;;;
;;;; — TABULARIUS (Claude Opus 5, subagent), 2026-08-20

(defpackage #:lisp-plus-memory-layer0
  (:use #:cl)
  (:import-from #:lisp-plus-journal0
                #:create-journal
                #:open-store
                #:validate-journal
                #:append-event
                #:journal-store-store-id
                #:journal-store-directory
                #:journal-store-durability
                #:prefix-report-status
                #:prefix-report-frame-count
                #:prefix-report-events
                #:prefix-report-event-ids
                #:prefix-report-frame-digests
                #:prefix-report-tail-sha256
                #:prefix-report-condition-type
                #:prefix-report-condition-requirement
                #:identifier-from-segments
                #:identifier-segment-string
                #:record-field
                #:store-id-string
                #:validate-metadata-octets
                #:render-metadata-octets
                #:build-metadata-record
                #:sha256-hex
                #:sha256-octets)
  (:import-from #:lisp-plus-capability2
                #:world-cell-value
                #:world-cells-sha256
                #:world-ledger-sha256
                #:world-ledger-count
                #:world-ledger-lookup
                #:derive-effect-standing)
  (:import-from #:lisp-plus-language-act1
                #:make-act1-record
                #:act1-record-act-id
                #:act1-record-act-id-hex
                #:act1-record-normal-form
                #:act1-fixture-runtime-seat
                #:act1-fixture-attempt-name
                #:act1-journal-kinds
                #:act1-reconciliation-closes-seat-p
                #:external-request-key)
  (:export
   ;; ---- typed lane-local refusals (TYPES) --------------------------------
   ;; ⚠ THE PACKAGE INTERFACE IS AN IMPLEMENTATION CHOICE.  No normative export
   ;; list exists for a memory lane; the list below is constrained only by the
   ;; reserved-name discipline in the header and by this lane's own readiness
   ;; predicate (load.lisp), which asserts every name here is external and bound
   ;; as its kind requires before the lane is considered loaded.
   #:ml0-condition
   #:ml0-source-species-refused
   #:ml0-subject-identity-mismatch
   #:ml0-provenance-incomplete
   #:ml0-scope-undeclared
   #:ml0-standing-vocabulary-refused
   #:ml0-account-encoding-refused
   #:ml0-account-readback-refused
   #:ml0-consolidation-refused
   #:ml0-bridge-contract-violated
   #:ml0-run-void
   ;; ---- condition readers -------------------------------------------------
   #:ml0-condition-detail #:ml0-condition-requirement-id
   ;; ---- structure TYPES ---------------------------------------------------
   #:ml0-scope #:ml0-source #:ml0-effect-observation #:ml0-account
   #:ml0-bundle #:ml0-store-scope #:ml0-record-coverage-observation
   ;; ---- the declared observation scope ------------------------------------
   #:make-ml0-scope #:ml0-scope-p
   #:ml0-scope-universe #:ml0-scope-status #:ml0-scope-detail
   #:ml0-scope-record #:ml0-scope-from-record
   ;; ---- the typed source -------------------------------------------------
   #:make-ml0-source #:ml0-source-p
   #:ml0-source-species #:ml0-source-acquisition-route
   #:ml0-source-producer-principal #:ml0-source-recorder-principal
   #:ml0-source-coordinate #:ml0-source-observation-scope
   #:ml0-source-origin-as-read #:ml0-source-subject-act-id
   #:ml0-source-payload-digest #:ml0-source-frontier-relation
   #:ml0-source-attests #:ml0-source-observation-interval
   #:ml0-source-validation-standing #:ml0-source-door
   #:ml0-source-recorded-validation #:ml0-source-warranting-validation-p
   #:ml0-source-record #:ml0-source-from-record
   ;; ---- the scoped observation of the external-effect axis ----------------
   #:make-ml0-effect-observation #:ml0-effect-observation-p
   #:ml0-effect-observation-standing-as-read
   #:ml0-effect-observation-determinacy
   #:ml0-effect-observation-world-digest
   #:ml0-effect-observation-scope #:ml0-effect-observation-provenance
   #:ml0-effect-observation-record #:ml0-effect-observation-from-record
   ;; ---- the record-coverage door (R4): the ONLY producer of a finding ----
   #:ml0-observe-record-coverage #:ml0-record-coverage-observation-p
   #:ml0-record-coverage-observation-finding
   #:ml0-record-coverage-observation-scope
   #:ml0-record-coverage-observation-read-summary
   #:ml0-record-coverage-observation-account-hexes
   ;; ---- the source bundle Write accepts -----------------------------------
   #:make-ml0-bundle #:ml0-bundle-p
   #:ml0-bundle-fixture-row #:ml0-bundle-claimed-act-id
   #:ml0-bundle-subject-principal #:ml0-bundle-sources
   #:ml0-bundle-issuance-standing #:ml0-bundle-issuance-scope
   #:ml0-bundle-record-coverage #:ml0-bundle-record-coverage-scope
   #:ml0-bundle-record-coverage-observation
   #:ml0-bundle-observations #:ml0-bundle-testimony
   #:ml0-bundle-issuance-observation
   #:ml0-bundle-effect-observation
   ;; ---- THE SEMANTIC OBJECT ----------------------------------------------
   #:ml0-account-p
   #:ml0-account-id #:ml0-account-id-hex #:ml0-account-id-datum
   #:ml0-account-act-id #:ml0-account-act-id-hex
   #:ml0-account-subject-seat #:ml0-account-subject-attempt
   #:ml0-account-occurrence-standing #:ml0-account-occurrence-scope
   #:ml0-account-issuance-standing #:ml0-account-issuance-scope
   #:ml0-account-record-coverage #:ml0-account-record-coverage-scope
   #:ml0-account-effect-observation #:ml0-account-sources
   #:ml0-account-derivation #:ml0-account-predecessors
   #:ml0-account-recorder-principal #:ml0-account-subject-principal
   #:ml0-account-retrieval-origin #:ml0-account-body-record
   #:ml0-account-standing-authority #:ml0-account-carried-standings
   ;; ---- the public readers (what a reader may ASK an account) -------------
   #:ml0-account-occurred-p #:ml0-account-issuance-only-p
   #:ml0-account-carries-no-current-image-evidence-p
   #:ml0-account-may-continue-p
   #:ml0-render-account
   ;; ---- THE PROMOTION RULE, one public function --------------------------
   #:ml0-occurrence-warranted-p
   #:ml0-nonoccurrence-warranted-p
   #:ml0-species-may-warrant-occurrence-p
   #:ml0-derive-occurrence-standing
   #:ml0-occurrence-conjuncts #:ml0-failing-leg #:ml0-print-conjuncts
   #:ml0-warrants-commensurable-p
   #:ml0-acquisition-route-identifier
   #:ml0-evidence-projection-digest
   #:ml0-mint-account-identity
   ;; ---- THE CANONICAL SUBJECT CARRIER (R2-BLOCK 2's cure) ----------------
   #:ml0-subject #:ml0-subject-p #:ml0-subject-from-fixture-row
   #:ml0-subject-fixture-row #:ml0-subject-act-id #:ml0-subject-act-id-hex
   #:ml0-subject-seat #:ml0-subject-attempt
   #:ml0-subject-external-request-key #:ml0-subject-canonical-request
   ;; ---- THE PRODUCTION OBSERVATION DOORS (the BLOCK 1 cure) ---------------
   #:ml0-observation #:ml0-observation-p
   #:ml0-observation-source #:ml0-observation-door
   #:ml0-observation-read-summary #:ml0-observation-species
   #:ml0-observation-issued-p
   #:ml0-observe-journal #:ml0-observe-world #:ml0-observe-reconciliation
   #:ml0-observe-absence #:ml0-observe-issuance
   ;; ---- the host-fault gate and the non-performing identity door ----------
   #:ml0-through #:ml0-rederive-act-identity
   ;; ---- the three operations ----------------------------------------------
   #:ml0-write #:ml0-retrieve #:ml0-consolidate
   ;; R4.1: the typed consolidation carrier and its one materialization route
   #:ml0-consolidation #:ml0-consolidation-p #:ml0-materialize-consolidation
   #:ml0-consolidation-act-id #:ml0-consolidation-act-id-hex
   #:ml0-consolidation-subject-seat #:ml0-consolidation-subject-attempt
   #:ml0-consolidation-subject-principal
   #:ml0-consolidation-occurrence-standing #:ml0-consolidation-occurrence-scope
   #:ml0-consolidation-issuance-standing #:ml0-consolidation-issuance-scope
   #:ml0-consolidation-record-coverage #:ml0-consolidation-record-coverage-scope
   #:ml0-consolidation-sources #:ml0-consolidation-predecessors
   #:ml0-consolidation-inputs #:ml0-consolidation-clash
   #:ml0-fold-issuance #:ml0-fold-record-coverage
   #:ml0-account-hex-of-event #:ml0-account-from-event
   #:ml0-list-account-ids
   ;; ---- the store-scope absence instrument --------------------------------
   #:ml0-store-scope-p
   #:ml0-store-scope-files #:ml0-store-scope-digests
   #:ml0-store-scope-directory
   #:ml0-take-store-scope #:ml0-store-scope-unchanged-p
   #:ml0-print-store-universe
   ;; ---- declared constants -------------------------------------------------
   #:+ml0-id-domain+ #:+ml0-lane-stem+ #:+ml0-runtime-process-name+
   #:+ml0-store-nonce+ #:+ml0-rendering-version+
   #:+ml0-source-species+ #:+ml0-occurrence-species+
   #:+ml0-nonoccurrence-species+ #:+ml0-acquisition-routes+
   #:+ml0-attestations+ #:+ml0-record-coverages+
   #:+ml0-source-validations+ #:+ml0-observation-doors+
   #:+ml0-occurred-proposition+ #:+ml0-promotion-legs+
   #:+ml0-occurrence-standings+ #:+ml0-issuance-standings+
   #:+ml0-effect-determinacies+ #:+ml0-derivations+ #:+ml0-scope-statuses+
   #:+ml0-env-class-i+ #:+ml0-env-class-ii+
   #:+ml0-env-class-iii-declared-out-of-stack+
   ;; ---- the in-process harness ---------------------------------------------
   #:*ml0-run-root* #:*ml0-account-store* #:*ml0-checks-passed*
   #:*ml0-checks-failed*
   #:ml0-check #:ml0-note #:ml0-env-preflight #:build-ml0-account-store))
