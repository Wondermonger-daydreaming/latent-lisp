# OWNER RULING 6B — CENSUS R1 ACCEPTED; B7 CLOSED; INTEGRATION ORDERED (2026-08-10, filed verbatim)

**Filed verbatim by the chair (Claude Fable 5) from the owner's direct message,
2026-08-10/11. Append-only; the owner's words below are unedited.**

---

Fable — apply Owner Ruling 6B.

MA0 Export Census /0 R1 is ACCEPTED. No R2 is required. B7 is CLOSED, and Parcel B's eight-item implementation succession is complete.

The sealed R1 archive is authenticated as:

* SHA-256 `3e14f3510b7afb5d01919ab0809eaf8541b9fba4a97b195d9e7b5dc8ed5b0b9c`;
* 26,542 bytes;
* manifest 10/10 green, self-excluded;
* all nine advertised repository blobs exact.

Before integration, verify in the full lab repository:

1. Base `1e8e03d899c9b515b41b0c21ac87a9b0bb76c17e`.
2. Tip `ec60b34be1b5c25698c2c69d3cd7b47fea412a47`.
3. The full 40-character identity and ancestry of artifact commit `1e27f67e…`.
4. Exactly nine base-to-tip changed/added repository paths, matching the sealed archive.
5. Every resulting blob against the archive.
6. `EXPECTED-EXPORTS.txt`, the R0 return, R0 derivation and capture tools, and all four R0 transcripts byte-unchanged.
7. `package.lisp` at `a97d3c3e2f6baa21f21c52ae0c4986140eb1fa5c`.
8. `ma0-structures.lisp` at `7a2c093e62e260136bbd6c9dde04dd2df29b2848`.
9. Local and remote identities equal.

Then merge `ec60b34b…` into `many-acts-0-candidate` with provenance preserved. Do not rebuild or reseal Census R1 and do not rerun the transcript-producing harness in a way that rewrites its sealed transcripts.

File an integration receipt recording Owner Ruling 6B and this rider:

"On a quiescent checked-out tree, an alternate expected table supplied through the driver or directly to the Lisp half cannot obtain the normative success sentinel. No claim of hostile concurrent-filesystem mutation resistance, gate self-authentication, SHA-1 collision resistance, or general tamper resistance is adopted."

After the merge, verify the merged lane reproduces the census tip's nine paths and preserved-file identities. A clean census readback may be recorded, but it earns no new evidence. Push only after local verification, then perform remote readback and report the merge commit, receipt commit, tree, changed-path inventory, relevant blobs, and remote identities.

Stop after the integration receipt. Do not advance S-freeze or open the stranger audit, PortJ-F/0, hidden bank, J2, portability, conformance, or independent-implementation jurisdiction.

Evidence remains ZERO.
