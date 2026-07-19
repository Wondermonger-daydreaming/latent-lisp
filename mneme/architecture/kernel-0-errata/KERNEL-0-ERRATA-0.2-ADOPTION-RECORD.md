# KERNEL-0-ERRATA-0.2 ADOPTION RECORD

**Seal status: ✅ SEALED by the owner, 2026-07-19T03:29Z (2026-07-19 00:29 -03), live
interview.** `LISP-PLUS-KERNEL-0-ERRATA-0.2.md` (sha256 `ee542b06…be48434f`) **GOVERNS**
beside the sealed Kernel /0 specification. The 0.2 file's own header retains its
pre-seal "issuance candidate" status line **deliberately**: its bytes are frozen as the
exact artifact the seal named — this record, and the STATUS stone, carry the governing
status (PJ0-adoption precedent: the sealed artifact's bytes are never edited to
retroactively contain its own adoption).

```lisp
(:kernel-erratum-adoption
  :artifact "LISP-PLUS-KERNEL-0-ERRATA-0.2.md"
  :artifact-sha256 "ee542b06dbd5c7bed85282541eb15483510cde2c0ccd0739155ddd56be48434f"
  :artifact-lines 673
  :artifact-bytes 25549
  :body-provenance
    (:folded-body-sha256 "ce5d739a47b91d86e357dfb2002df19c3dcffa3083a4170c002d4a93e129a760"
     :frozen-synthesis-sha256 "85b17863402264874bd456c6430b3cb0cde7d4c9b9a74f36cb4660839e751627"
     :fable-delta-sha256 "ef9bef24b6e19e98093141bde67e5c5c2ccf40cd70ec00c5945ff08a4d503188"
     :verified-patch-sha256 "181d655d916d06e82cd45456b8a4e1d51b9c37cc98ff4236ada83906825a0433"
     :verification :dual  ; GPT mechanical 6/6 + Fable independent byte-identical replication
     :header-replacement-only-p #t)
  :adopted-by "Tomás Pavan (owner)"
  :adoption-time "2026-07-19T03:29Z"
  :adoption-mechanism "live interview (AskUserQuestion, owner selection)"
  :repository-commit "261122d15228c9214864fc3e28381c94651996b1"
  :parent-candidates
    ((:artifact "FABLE-LISP-PLUS-KERNEL-0-ERRATA-0.1-CANDIDATE.md"
      :sha256 "b09c5ead25104a27ee619802d175fc74e4251d8bf936b036f8d0ef4c9776ea34"
      :author "Claude Fable 5" :blind #t)
     (:artifact "GPT-LISP-PLUS-KERNEL-0-ERRATA-0.1-CANDIDATE.md"
      :sha256 "b0708a517e1ef985d0d78d4bed0bbf2fc3ef9fa96644d6549620e291826469b0"
      :author "GPT-5.6 Thinking" :blind #t))
  :synthesis-records
    ((:fable-concordance "0ed96b870a698a5981169e80819499f24356d5efc7c283ef55dbc357c37af0db")
     (:gpt-synthesis-relay-zip "9a2f2e54abc74728d2821b20c7a04ee3198090caff7fbbb6cf0670a49d6aaf1b")
     (:fable-reconciliation "678eb02b0492af25eba58db00a28218bd0b5186cfb999f6fb72acb9bbc1ad3ba")
     (:gpt-delta-verification-relay-zip "fa63b3a44f51a19106004430dc35b8cc56d862aa326a1ae7a126ec3d3ec3b439"))
  :fork-disposition-record
    (:artifact "KERNEL-0-ERRATA-FORK-DISPOSITION-RECORD-2026-07-19.md"
     :sha256 "516558211e1d57a84c375f6c1a480c0818ca524b16ff02421db8526a769e1715"
     :sealed-by-owner "2026-07-19, live interview"
     :dispositions (:fork-1 :a  :fork-2 :a  :fork-3 :a  :fork-4 :a
                    :fork-5 :a  :fork-6 :a  :fork-7 :a))
  :governing-effect :rides-beside            ; fork 7; folds at first freeze candidate
  :gap-dispositions
    (:gap-1 :closed-by-k0e-1-7               ; ≥2 rule; call-296 stayed non-constructible
     :gap-2 :closed-by-k0e-8-17              ; PJ0 evidence bundle + :attempt-indeterminate
     :gap-3 :closed-by-k0e-18-22             ; standing records; tests 43/44/47/48 executable
     :gap-4 :closed-by-k0e-23-33             ; judgment class; joint reports; A.2 replaced
     :status-gap-2 :folded-in                ; K0E-17
     :status-gap-3 :folded-in                ; §6 condition minting
     :status-gaps-5-6 :already-closed-by-pj0)
  :unchanged-inventory
    (:cd0-octets :pj-s0 :pj0-framing :ap0-vector-bytes
     :provider-semantics :language-a-classifications :capability-authority-law)
  :remaining-gates
    (:independent-cl-pj0 :independent-cl-ap0 :mneme-journal-store
     :capability-live-authority :deterministic-fake-adapter
     :vertical-specimen :hostile-implementation-review :stranger-audit)
  :bounded-unknowns
    (:call-296-completion-presupposition     ; K0E-7, row-class scale
     :call-296-complete-outcome-stayed       ; K0E-5a named exclusion
     :section-13.8-bounded-manifestation-vocabulary-limit)
  :implementation-charge :erratum-section-7  ; kernel0 files; opens on the standing green word
  :publication-disposition :full-chain-committed-to-tree)  ; owner: PUBLIC on sync
```

**Owner seal:** "Seal — 0.2 governs" + "Commit full chain to tree" — Tomás Pavan, live interview, 2026-07-19T03:29Z

*Drafted by Claude Fable 5, 2026-07-19, from the dual-verified chain; every hash above
recomputed by the chair from the on-disk artifacts before drafting.*
