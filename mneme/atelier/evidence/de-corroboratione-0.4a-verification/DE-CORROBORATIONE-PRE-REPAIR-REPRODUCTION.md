# DE-CORROBORATIONE pre-repair reproduction

Status: reproduced byte-for-byte before repair on 2026-07-15.

## Custody and base

- Branch: `codex/de-corroboratione-0.4a-verification`
- Freshly fetched base commit: `5ae55d799c8f253926eaf91af9feda4a868e4fc8`
- Base tree: `7bd80217af438061eb4c613afbb8682f0ce9dcb0`
- Runtime: `SBCL 2.4.6`
- Candidate source: 46,682 bytes, 888 LF lines,
  SHA-256 `59786bcc799a4dd5126b21176f0e9db441fb643793a267a33aa4621f8faf9460`
- Supplied transcript: 7,240 bytes, 107 LF lines,
  SHA-256 `6b71939074ae667ea8afaf1c949ed9b5bb6a8e9bfc5a5b7a404abaad8dc716ae`

The delivered source was copied without alteration to its declared compatible
placement, `mneme/atelier/hinges/de-corroboratione.lisp`, only after a separate
byte-identical evidence copy had been preserved.

## Exact reproduction command

Both runs used fresh SBCL processes from the repository root:

```text
sbcl --noinform --disable-debugger --script mneme/atelier/hinges/de-corroboratione.lisp
```

Run 1: exit 0, 7,240 output bytes,
SHA-256 `6b71939074ae667ea8afaf1c949ed9b5bb6a8e9bfc5a5b7a404abaad8dc716ae`.

Run 2: exit 0, 7,240 output bytes,
SHA-256 `6b71939074ae667ea8afaf1c949ed9b5bb6a8e9bfc5a5b7a404abaad8dc716ae`.

`cmp` returned 0 between the two generated transcripts and between run 1 and
the supplied transcript. This establishes exact execution reproduction only;
it does not establish Erratum 0.4-A conformance or provenance truth.

## Outer and internal identity gates

Before extraction, the ZIP was 40,445 bytes with SHA-256
`0e1fe3bb83c0630b06a1f240d55a9e0c061745038ab1fbb078135aed5d90be54`.
The sidecar was exactly 120 bytes with final LF and SHA-256
`b6026eb80818397b107bd73cd397a76f11a3e912def1495ed6cece5cfed4e84e`.
The ZIP listed exactly eight members. After extraction, every entry named by
the delivered `SHA256SUMS.txt` returned `OK`. Draft 0.4 and Erratum 0.4-A also
matched their required byte counts and digests.
