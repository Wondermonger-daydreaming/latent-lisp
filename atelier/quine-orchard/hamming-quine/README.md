# HAMMING QUINE — the orchard's self-correcting transmission (r1)

*Specimen of the Quine Orchard, planted 2026-09-16 from the doormat of Shannon 1948 p. 28 (the [7,4] code printed above Appendix 1) and the owner's pick from the Appendix Committee's pitch desk. **r1 the same evening**, after the review of parcel `ed346f74…` (docked: `corpus/voices/received/originals/2026-09-16-shannon-atelier-play-review.md`). Claude Fable 5.1, session Only What It Read, carte blanche. A toy; nothing adopted.*

```
cd atelier/quine-orchard/hamming-quine
sbcl --script make.lisp                                   # find the fixed point from template.lisp; verifies in a fresh process
sbcl --script hamming-quine.lisp                          # prints itself, byte for byte
sbcl --script hamming-quine.lisp --transmit > t.sexp      # prints itself as [7,4] codewords, one per line
sbcl --script flip.lisp t.sexp noisy.sexp 100 3           # the channel: flip bit X3 of block 100
sbcl --script hamming-quine.lisp --receive noisy.sexp     # SYNDROMES … / OCTETS … / RECEIVED SELF: YES|NO    exit 0 iff YES
```

## The page

> *"Let a block of seven symbols be X₁, X₂, …, X₇. Of these X₃, X₅, X₆ and X₇ are message symbols and chosen arbitrarily by the source. The other three are redundant and calculated as follows: X₄ is chosen to make α = X₄+X₅+X₆+X₇ even; X₂ … β = X₂+X₃+X₆+X₇ even; X₁ … γ = X₁+X₃+X₅+X₇ even. When a block of seven is received α, β and γ are calculated and if even called zero, if odd called one. The binary number αβγ then gives the subscript of the X_i that is incorrect (if 0 there was no error)."* — p. 28.

## What it is

A **quine** with two more verbs. `--transmit`: its own UTF-8 octets → nibbles → one codeword `(X1 … X7)` per nibble, in Shannon's position convention. `--receive FILE`: for each block compute αβγ, flip the named subscript when nonzero, **count**, reassemble the octets, and answer the one question a quine can vouch for: **are the received octets this program's octets?** The receiver is the sender's twin; it needs no carried hash.

**r1 — what the review changed (two corrections, both reproduced here before a byte moved):**

1. **Identity is decided on bytes.** r0 decoded the received octets to text (with `?` for invalid UTF-8) and compared *strings*. That decoding is many-to-one: the source contains literal `?`; an invalid octet at such a position decodes to `?` and *matches*. The reviewer named byte 737 of the r0 source; I reproduced the collision on the receiver's own decode path (`octets equal: NIL · strings equal after ? replacement: T`). And since any nibble Hamming-encodes, the altered byte can arrive as **perfectly valid codewords** — no syndrome at all. r1 compares `(unsigned-byte 8)` vectors first; text is decoded afterwards for display only, with the replacement characters **counted** and named as such.
2. **Lengths are reported separately.** r0 counted differing characters over the common prefix, so a truncated copy could read "0 differing" while returning NO. r1 prints `differing-octets=` and `length-difference=` apart.

Also renamed, per the review's Q7: the decoder's count is `nonzero-syndromes=` / `bit-flips-applied=`, **never "corrected"** — under two errors the flip is wrong, under three it is absent, and the word would carry a claim the code cannot make. Malformed transmissions the reader anticipates (unreadable forms, non-bit elements, an odd codeword count) are *reported* as `RECEIVED SELF: NO (…)`; a shape it does not anticipate may still end the process before the verdict — the claim "the verdict always prints" was too broad and is withdrawn.

## The lineage (`hamming-lineage/`, r1; all transcripts retained; r0's in `hamming-lineage-r0/`, attempt 1's crash in `hamming-lineage-attempt-1/`)

| gen | channel | `nonzero-syndromes` | `differing-octets` | `length-diff` | `replacement-chars` | `RECEIVED SELF` |
|---|---|---|---|---|---|---|
| 00→01 | clean | 0 of 24,220 | 0 | 0 | 0 | **YES** |
| 01 | one bit (block 100, X3) | 1 | 0 | 0 | 0 | **YES** |
| 02 | two bits, two blocks | 2 | 0 | 0 | 0 | **YES** |
| 03 | **two bits, one block** | **1 — the flip was wrong** | 1 | 0 | 0 | **NO** |
| 04 | **three bits, one block** | **0 — it looked clean** | 1 | 0 | 1 | **NO** |
| 05 | **COLLISION**: the first literal `?` (octet 731) → `0xFF`, arriving as **valid codewords** (block 1462: `(1 1 1 1 1 1 1)`) | **0** | **1** | 0 | **1** | **NO** — by bytes; r0 would have said YES |
| 06 | last 100 codewords dropped | 0 | 0 | **−50** | 0 | **NO** — by length; r0 would have said "0 differing" |
| 07 | one form `(1 0 1 x 0 1 1)` | NIL | — | — | — | **NO** (malformed codewords) — reported, not crashed |

**Three distinctions, on the page.** Gen 03: *intervention without recovery*. Gen 04: *apparent cleanliness without identity*. Gen 05 (the review's gift): *a message can differ from its source and become indistinguishable after the receiver's display transformation* — the mirror was doing cosmetic surgery; r1 took away its licence.

## Scope

- The observed lineage is **eight cases on one 12,110-octet source**. It is not a general guarantee. Under a bounded-error model of **at most one flipped bit per block**, the plain [7,4] code recovers the message and "corrected" would be warranted; gens 03–05 deliberately cross that boundary, and the piece's language keeps the distinction it exists to show.
- **The twin's privilege, narrowed (review, Q5).** A non-twin receiver is *not* limited to the syndrome count: code structure plus an explicit error model gives guarantees; stronger codes or detection redundancy give more; a transmitted `m ‖ h(m)` is not the self-listing-manifest problem. What no receiver can do *under unrestricted corruption*, from the received word alone, is tell an untouched valid message from another valid message the channel produced. The twin supplies a complete reference *outside* the corrupted transmission — that, precisely, is its privilege, and nothing wider.
- The code is the plain (7,4) of p. 28, not the extended (8,4) that detects double errors.
- The fixed point is **found, not authored** (`make.lisp`: `template.lisp` → `(format nil s s)` → fresh-process check). Four fixed points today: 7,548 → 7,850 → 7,922 (r0) → 12,098 chars (r1).

## Files

`template.lisp` (body; one `~s`) · `make.lisp` · `hamming-quine.lisp` (**the r1 fixed point**, sha in `hamming-lineage/LINEAGE-SUMMARY.txt`) · `flip.lisp` (the channel, by hand; names its flips in its first line) · `hamming-lineage/` (r1: gen-00 and seven corruptions, eight receive transcripts, summary) · `hamming-lineage-r0/` (superseded, kept) · `hamming-lineage-attempt-1/` (the crash, kept) · `RECEPTION-2026-09-16.md` (pointer to the review).
