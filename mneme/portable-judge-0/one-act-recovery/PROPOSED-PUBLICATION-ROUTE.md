# ONE ACT /0 — PROPOSED PUBLICATION ROUTE (Round OA)

**CANDIDATE parcel — Round OA; not an adoption; frozen court-construction
baseline commit `71422395`; read-only over adopted history; zero evidence toward
any PortJ/0 station.**

**PROPOSAL ONLY. NOTHING HAS BEEN MOVED, COPIED, PROMOTED, OR COMMITTED.** This
document describes a route that becomes executable *only* if and when the owner
rules specific material **category 1 (adopted-but-failed-to-publish)**. On the
present record `RECOVERY-DETERMINATION.md` places **all five documents in
category 2**, so **the route below currently has an empty subject** and is
written for the case where an owner scope ruling changes that.

---

## 1. Scope discipline the route inherits

- Only **category 1** may travel this route: OA-I proven **and** OA-N
  incorporated. Category 2 (reviewed candidate material), category 3
  (post-adoption reconstruction) and category 4 (comment-only / new law) are
  **out of recovery scope** and route to an owner-reviewed candidate round.
- The route performs **no semantic adoption.** It publishes bytes the owner has
  already adopted, to the place they were always meant to be readable from.
- Nothing is deleted, retired, or moved out of `_staging/`.

## 2. The mechanical route (for whatever the owner rules category 1)

1. **Copy, byte-identical, no edit of any kind**, from
   `_staging/oneact-candidate/<DOC>.md` to
   `experiments/latent-lisp/mneme/language-act-0/<DOC>.md`.
   Verified by `cmp` and by `git hash-object` equality against the adopted blob
   sha listed in `RECOVERY-DETERMINATION.md` Part I.2 — the published copy's
   blob sha must equal the adopted blob sha exactly.
2. **Originals stay.** `_staging/oneact-candidate/` is left untouched: same
   paths, same blobs. The recovery adds a public copy; it does not relocate the
   record.
3. **One owner-ratified commit**, message labelled exactly:
   `publication recovery — no semantic adoption`
   with the owner's ruling referenced in the body, and the commit made only
   after the owner's explicit word (this parcel does not commit).
4. **Mirror settlement.** The destination is inside the mirror's
   `:source-scope "experiments/latent-lisp/**"`, so the next sync publishes it.
   Verify by content with `bash tools/latent-lisp/verify-sync.sh`, never by the
   sync commit message (§I-j mirror law).
5. **No `git push` while any builder is live** (the standing publication rule).

## 3. Per-file provenance header — the open design question

The chair's proposal asks each published copy to carry a provenance header. That
**conflicts with byte-identity**, and the conflict must be resolved by the owner
before a single byte moves. Three routes, stated with their costs:

| Route | Mechanism | Cost |
|---|---|---|
| **A — sidecar** (recommended) | Published `.md` is **byte-identical**; provenance travels in a sibling file `ONE-ACT-0-PUBLICATION-PROVENANCE.md` in the same directory, one section per document | Byte-identity preserved and independently checkable (`git hash-object` equality). Costs one extra file. |
| **B — inline header** | A provenance block is prepended to each published copy | **Breaks byte-identity**; the published document is no longer the adopted blob; every future audit must diff-modulo-header. Not recommended. |
| **C — commit-message-only** | Provenance lives solely in the ratifying commit | Byte-identity preserved, but provenance is invisible to a reader who fetches the mirror (the mirror does not carry lab commit history — `CHANNEL-POLICY … :history :not-mirrored`). Defeats the purpose. |

Under route A, each provenance record carries: adopted candidate commit
`461f2013d1a6feca2b13819ff6ae3f60617e8e82` · adopted tree
`1123c3c3326664f54d1d96547ba872a876cbd495` · closure bundle sha256
`598c0cfc…f90635` · original path `_staging/oneact-candidate/<DOC>.md` · git blob
sha1 and content sha256 (Part I.2 table) · the owner ruling that made it
category 1 · and the sentence *"published as publication recovery; no semantic
adoption occurred at publication."*

## 4. ⚠ THE SELF-DISCLAIMER PROBLEM — must be ruled before publication

The adopted bytes of all five documents declare their own nullity:

- contract §0 head: *"**Status: CANDIDATE PRE-CODE CONTRACT. Nothing here is
  adopted, accepted, frozen, audited, or on a governing floor.**… **Authority
  claimed: none.**"*
- matrix / identity table / test plan, line 3: *"**Standing: CANDIDATE STAGING.
  Adopts nothing, opens nothing, seals nothing.**"*
- specimen line 20: *"**Standing: CANDIDATE PRE-CODE. No implementation
  exists.**"* — false of the adopted tree, which contains the implementation.

Publishing a byte-identical category-1 document therefore publishes, to the
world, a document that says it is not law — beside an implementation that cites
it as law. **Editing the disclaimer is forbidden** (it would break byte-identity
and would be semantic adoption by the back door). The only lawful fixes are
external:

- (i) the route-A provenance sidecar states the standing correction explicitly;
  and/or
- (ii) a short owner-authored **publication note** in
  `language-act-0/` saying which documents the adoption reached and that their
  internal candidate-standing lines are pre-adoption fossils left unedited by
  design.

**This is an owner decision, not a chair or agent decision.**

## 5. What this route does NOT accomplish — stated plainly

Per `COMMENT-LAW-SWEEP.md` §3, publishing all five documents would still leave
the following **adopted** law with no public documentary home: fail-closed
loader completion · `act0-api-complete-p` · `ACT0-LANE-FILES` fresh-copy/non-EQ
semantics · total export-binding coverage · the gates-file-last ordering law ·
ASDF-only lane entry · run-root-outside-the-checkout · replica-only disease
protocol · `H-AP0-COLLIDE` terminal position · the 173-check sentinel ·
release-floor registration 97/77. Plus the resolved V-F octets, which live in
`_staging/oneact-impl-evidence/v-f-freeze-table.txt` and not in the test plan.

**So SD-13 is not closed by this route alone.** Closing it needs a separate,
owner-reviewed candidate round that gives the R2.2/R2.3 law a documentary home
— which is **category-4 work, new law, and explicitly not publication
recovery.** No draft of it exists and none was written here.

## 6. Routing for categories 2-4 (out of recovery scope)

| Category | Present membership | Route |
|---|---|---|
| 2 — reviewed candidate material | **all five documents, on the present record** | owner-reviewed candidate round; may be published as *candidate material with construction history*, never as adopted law, if the owner wants the record legible; nothing moves without that ruling |
| 3 — post-adoption reconstruction | test plan §5.7's pending octets vs. the frozen V-F table | owner-reviewed candidate round |
| 4 — comment-only law / new law | C4-01 … C4-14 in `COMMENT-LAW-SWEEP.md` | owner-reviewed candidate round, drafted only on owner commission |

## 7. THE OWNER DECISION POINTS

Nothing below may be decided by a chair or an agent.

1. **Scope of the terminal adoption.** Did the 2026-08-08 adoption incorporate
   the five documents as One Act /0 law? Its verbatim text is **not in the
   repository** (`RECOVERY-DETERMINATION.md` §II.4) — the owner is the only
   source. Sub-questions:
   a. all five, or only the three cited by adopted source (contract, specimen,
      test plan)?
   b. does the adoption reach the **adopted bytes** (post-seal, R2.1 chair
      erratum) or only the **sealed bytes** at `3c4e704d`?
2. **Do the OA-N tensions block category 1 for specific documents?** The failure
   matrix and identity table have **zero** citations from any adopted source or
   gate and declare themselves subordinate in their own headers. They are the
   two most likely to stay at category 2 even if the other three are elevated.
3. **Header format:** route A (sidecar, byte-identity preserved) · B (inline,
   breaks byte-identity) · C (commit-message only, invisible on the mirror)?
4. **The self-disclaimer problem (§4):** publication note, sidecar statement,
   both, or publish bare and accept the contradiction on the public record?
5. **Are the `_staging/` originals ever retired?** Recommended answer: **no** —
   they are the adopted blobs and the evidentiary spine of this determination.
   Retiring them would destroy the only in-tree object the adoption record's
   coordinates resolve against.
6. **Does anything published carry a claims-ceiling rider?** The adoption
   record's ceiling (*"self-consistency certification, never independent
   conformance"* + *"no stranger audit occurred"*) travels with every citation
   of the adoption; the owner should say whether it must appear beside the
   published documents too.
7. **Downstream reliance:** Many Acts /0 already calls the specimen's arms *"the
   seven adopted … arms"* (`AUTHOR-GUIDE.md:304`, `MANY-ACTS-0-GRAMMAR.md:63`).
   A narrow OA-N ruling on the specimen would unsettle that language. Does the
   owner want it addressed in the same ruling?

— determined by TABELLIO (Claude Opus), Round OA, commissioned by the chair (Claude Fable 5), 2026-08-10
