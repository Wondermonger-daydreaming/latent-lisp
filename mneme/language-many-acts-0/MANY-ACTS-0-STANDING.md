# MANY ACTS /0 — STANDING

STANDING: standing in this lane attaches to immutable object identities and explicit
dispositions, never merely to filenames, directories, or descent from an adopted commit
(Owner Ruling 6 §3 B1). This file states that rule; it does not confer standing on itself.
Nothing produced here is independent verification (AP0 adoption Rider 2, binding): the
phrases "independently verified" and "independently validated" may not appear in any
artifact of this lane.

Instrument: **OWNER RULING 6 — PARCEL B DISPOSED; EXECUTION ORDERED (2026-08-10)**, §3 item
B1 ("standing banners: AMENDED STRATIFICATION ADOPTED"), filed verbatim at
`experiments/latent-lisp/mneme/portable-judge-0/OWNER-RULING-6-PARCEL-B-DISPOSED-EXECUTION-ORDERED-2026-08-10.md`.
Options A, B and C of `parcel-b/B1-lane-standing-banner.md` were **rejected as drafted**;
their unchosen language is not adopted and is not restated here.

---

## 1. The governing rule (owner's words, quoted verbatim from Ruling 6 §3 B1)

> **Standing attaches to immutable object identities and explicit dispositions, never merely
> to filenames, directories, or descent from an adopted commit.**
>
> The Many Acts /0 R1 base consists of the exact coordinates named by the R1 adoption ruling.
> A current blob identical to an adopted blob may say that it reproduces an adopted-base
> byte-state. A modified descendant at the same path is a **candidate successor to an adopted
> base** until separately accepted or adopted.
>
> Owner rulings derive force from issuance. Historical returns, evidence, records, and
> candidate design documents retain the standing assigned by their own dispositions; they do
> not become adopted merely because they occupy the same lane.

## 2. The exact coordinates

Quoted from `MANY-ACTS-0-R1-ADOPTION-OWNER-RULING-2026-08-10.md` (the R1 adoption ruling,
filed verbatim in this lane); this document names them, it does not create them.

| Coordinate | Identity |
|---|---|
| R1 predecessor | `76952ea4f278d269f98f158555e412a095a3da6f` |
| transport patch SHA-256 | `913a1c9bd1158c855cca6f68f065af9228130cc9fa3c2bb374fb1fc364f20998` |
| **product freeze lane subtree** | `e94870bd9091e67f68e9cf238a6c5d0dcf302a05` |
| P4 holdout commit | `ef98ede12021889753babb6d368b218689cf311d` |
| R1 return commit | `e170e1d680b273e7906d1edd2b352cfb7aede458` |
| **return lane subtree** | `dd2a7a0aa36d6ddabfb6b66c569260bbc73edab7` |

The product freeze and the post-freeze evidence additions (P4, the R1 return) retain
different roles; the additions do not retroactively move the product freeze.

## 3. How a reader determines standing

A banner cannot answer the question. Two mechanical questions answer it:

1. **Is this blob one of the adopted ones?** Compare the blob at the path against the same
   path inside the two lane subtrees above:

   ```sh
   git ls-tree -r e94870bd9091e67f68e9cf238a6c5d0dcf302a05   # product freeze
   git ls-tree -r dd2a7a0aa36d6ddabfb6b66c569260bbc73edab7   # R1 return
   ```

   *Equal* → the current blob **reproduces an adopted-base byte-state**.
   *Different, same path* → **candidate successor to an adopted base**, until separately
   accepted or adopted.
   *No such path in either subtree* → not part of the adopted base at all; its standing is
   whatever its own disposition assigned it.

2. **What disposition does the artifact carry?** Owner rulings derive force from issuance.
   Returns, evidence, records and candidate design documents keep the standing their own
   dispositions gave them, and do not gain standing from the lane they sit in.

A classification of every lane file as of the Parcel-B execution return is tabulated in
`MANY-ACTS-0-PARCEL-B-EXECUTION-RETURN.md` §5. That table is a **measurement at one commit**,
not a standing grant, and it goes stale the moment a byte moves — which is exactly why the
rule above is written in identities and not in filenames.

## 4. What the adoption did **not** do

Quoted from Ruling 6 §3 B1, the scoped replacement now carried in `AUTHOR-GUIDE.md`:

> Programs written against this guide target the owner-adopted Many Acts /0 R1 implementation
> base. No consolidated, frozen, and published Many Acts /0 statute or portable-conformance
> standard has yet been adopted. Individual owner rulings settle the questions they expressly
> decide; they do not silently complete that statute.

Unchanged and unaffected by anything here: the R1 claim ceiling is Rider 1's exact sentence
and nothing stronger; Rider 2's prohibition on "independently verified" / "independently
validated" is invariant in this lane; the stranger audit remains **OWED**; the 28-place
semantic-extractability register stands.

## 5. Banners left byte-untouched, and why

- **Historical filings** — returns, receipts, records, filed rulings, sealed briefs, the
  frozen R1 captures, the disposed `parcel-b/` filings. Their banners are part of the
  testimony. They are preserved byte-for-byte (Owner Ruling 2 §5 item 10; Ruling 6 §3 B4),
  and §1's last paragraph is what governs them: they retain the standing their own
  dispositions assigned.
- **Live tools whose banner reads "CANDIDATE. Running a candidate is not adopting it
  (contract §0, §8)"** — that sentence is a true statement about the act of running and
  asserts nothing about the standing of the bytes. Under §1 no banner carries standing
  anyway, so rewriting these would move blobs without changing any legal fact. They are
  therefore left exactly as written, and this paragraph is the notice that they are not
  standing determinations.

— filed by Claude Opus (agent LICTOR) under Owner Ruling 6 §5.1, 2026-08-10
