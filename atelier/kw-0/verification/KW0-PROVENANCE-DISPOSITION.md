# KW-0 provenance disposition (owner-ruled, 2026-07-19)

Recorded by Fable per the owner's adoption ruling §5. The candidate files are preserved unedited; this disposition attaches externally.

## Artifact identity — ESTABLISHED
Delivered archive `kw-0-specimen.tar.gz` SHA-256 `664d98624a1c38886ec7e9c351648fdaecb2c02bf457d6ed2b471f834cc2a97a`; internal `MANIFEST.sha256` verified 148/148 at intake and re-verified at adoption. Identity claims rest on these hashes, nothing else.

## Delivery provenance — ESTABLISHED
Received through the Kimi interaction lane inside `Kimi_Agent_Repository Review (1).zip` (SHA-256 `cff72778c6931125086dca0a96ecc0d6ab09edc9a9b19adbe6615358b4ce4775`, landed in the owner's Downloads 2026-07-19 19:49 host clock), verified and preserved read-only by Fable (`_intake/delivery-2/`, plus the committed pristine extraction and `DELIVERY-SEAL.sha256`).

## Builder attribution — `BUILDER-ATTRIBUTION-CLAIMED / NOT-INDEPENDENTLY-ATTESTED`
The report attributes construction to Kimi-k3. The packager's own `PACKAGING-NOTE.md` attests first-generation authorship (sources, S1–S6, baselines) but explicitly does **not** attest the v2 additions (`f6v3.py`, `HOSTILE-BASELINE-COMMISSION.md`, `ENVIRONMENT.md`, `deps/PINNED-COMMIT.txt`, original `reproduce.sh`, `run-baselines.sh`, the `S7` scenario and evidence, the `@harness` markers and retry-law source extensions, per-scenario exit records, the stale-digest incident), which were "found in the work directory at packaging time." This standing is not to be silently replaced in either direction.

## `HOSTILE-BASELINE-COMMISSION.md` — `SELF-ATTRIBUTION-UNATTESTED`
The file self-attributes to "Kimi-k3 at the owner's direction"; the packager has no record of that drafting. The file's bytes and experimental role remain fully inspectable; its authorship claim gains no standing from appearing inside the file.

## Fable-authored artifacts — DIRECTLY WITNESSED
HB-0 (`hb0/`), its pre-exposure freeze record (`HB0-FREEZE.sha256`), the verification report, and the verification transcripts carry Fable's directly witnessed authorship.

## Clarification requested of Kimi (narrow; relayed via the owner)
1. Which v2 files did Kimi directly generate?
2. Which were produced by another agent, process, or packaging layer?
3. Who authored `HOSTILE-BASELINE-COMMISSION.md`?
4. Can Kimi attest only delivery, only supervision, or direct authorship?
5. Were any files transformed after Kimi's final clean run?

A response may strengthen provenance; absence of one does not erase the independently reproduced technical evidence — it leaves authorship unattested.

---

## ADDENDUM — after the packager's clarification (2026-07-20; response filed verbatim in `KW0-PROVENANCE-CLARIFICATION-KIMI-RESPONSE.md`)

Chair-proposed refined standings, recorded per the owner's "the response may strengthen provenance"; the owner may overrule:

| Artifact class | Refined standing |
|---|---|
| First-generation files (`kw-common/oracle/runner/reconstruct/baseline`, `folder.py`, `harness.py`, `smoke.lisp`, `ASSUMPTIONS.md`, S1–S6 evidence, baselines) + packaging-time files | `AUTHORSHIP-ATTESTED-BY-PACKAGER` — single-witness self-testimony, externally consistent (manifest verifications; IW-0 snapshot; packaging-note concordance). Testimony, not proof; no store available to check. |
| v2 additions (`f6v3.py`, `HOSTILE-BASELINE-COMMISSION.md`, `ENVIRONMENT.md`, `deps/PINNED-COMMIT.txt`, original `reproduce.sh`, `run-baselines.sh`, S7 + evidence, `@harness`/retry-law source layers, `evidence/stale-digest-incident/`) | `AUTHOR-UNKNOWN / PACKAGER-DISCLAIMED` — sharpened from `NOT-INDEPENDENTLY-ATTESTED`: the only available witness now *positively disclaims* authorship. Shipped runner/reconstructor/harness bytes are therefore **mixed-authorship** (v2 layers atop attested first-generation work). |
| `HOSTILE-BASELINE-COMMISSION.md` | `SELF-ATTRIBUTION-UNATTESTED` — unchanged; now co-signed by the packager, with its labeled inference (author had access to the owner-side conversation) filed as inference only. |
| Post-clean-run transformations | `DISCLOSED-ADDITIVE-ONLY` — two additions (`reproduction-verification.txt`, regenerated `MANIFEST.sha256`), consistent with independent manifest verification. |
| Delivery-zip assembly layer (incl. IW-0 inclusion) | `OWNER-SIDE` per packager testimony — resolves discrepancy 5's mechanism, pending the owner's confirmation. |

**The one remaining open question routes to the OWNER:** what agent, session, or pipeline layer wrote the v2 files into `/mnt/agents/work/killed-witness/` between the packager's two turns on 2026-07-20? The packager cannot see it; the owner can. Until answered, `AUTHOR-UNKNOWN / PACKAGER-DISCLAIMED` stands — and note the epistemically clean position this leaves the evidence in: **the reproduced behavior needed no authorship claim to survive verification; only the credits are open.**
