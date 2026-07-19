# KW-0 — interrupted-process recovery specimen

**Reproduction README** *(authored at packaging time, 2026-07-20, by the packager — see PACKAGING-NOTE.md for provenance of every file)*

This bundle contains the complete KW-0 specimen: sources, the shipped reference evidence generation (seven process deaths, retries, baselines), and a one-command reproduction that regenerates the specimen from a clean extraction and byte-compares it against the reference.

## Layout

```
kw-0-specimen/
  README-REPRODUCTION.md     this file
  PACKAGING-NOTE.md          provenance, packaging edits, declared absences
  ASSUMPTIONS.md             filesystem/sync/control-channel disclosures
  ENVIRONMENT.md             build/run environment record
  HOSTILE-BASELINE-COMMISSION.md  HB-0 (Fable's brief for the hardened control)
  reproduce.sh               the one command (see below)
  MANIFEST.sha256            SHA-256 over every delivered file
  src/                       specimen sources (byte-identical to the reference run)
  deps/PINNED-COMMIT.txt     latent-lisp commit + CD0 dependency hashes
  evidence/                  REFERENCE GENERATION (read-only; do not modify)
  run/                       substrate smoke-test residue (preserved, inert)
```

## The one command

```bash
tar -xzf kw-0-specimen.tar.gz && cd kw-0-specimen
SBCL_HOME=/path/to/sbcl-home bash reproduce.sh /path/to/latent-lisp /path/to/sbcl
```

- `/path/to/latent-lisp`: a checkout of `Wondermonger-daydreaming/latent-lisp` at commit `f8842f8c37ed80c5d0bd89cbec40f2c203058c10` (hashes in `deps/PINNED-COMMIT.txt`; the CD0 codecs are loaded from this checkout, not vendored).
- `/path/to/sbcl`: an SBCL 2.4.6 binary (arg 2, `$SBCL_BIN`, or `sbcl` on PATH).
- `SBCL_HOME`: the directory containing `sbcl.core` and the contrib modules (required; the official binary distribution's `obj/sbcl-home` after the core is placed beside the contribs, or an installed `/usr/local/lib/sbcl`).

**Expected successful exit status: `0`**, with final line
`REPRODUCTION: all differentials MATCH; all journals byte-identical to reference`.
Nonzero exit with per-scenario diagnostics otherwise.

Runtime: a few minutes (seven real SIGKILLs with readiness waits, reconstructions, baselines).

## Environment assumptions (beyond ASSUMPTIONS.md / ENVIRONMENT.md)

1. `/tmp` is writable and on a filesystem where `fsync` has ordinary POSIX semantics (the reproduction creates three symlinks there: `/tmp/kw`, `/tmp/sbcl-bin`, `/tmp/sbcl-2.4.6-x86-64-linux/obj/sbcl-home` — this is how the byte-identical sources run from any extraction path; see reproduce.sh PACKAGING-EDIT 1).
2. Linux x86-64, `md5sum`, `grep -P`, bash, Python ≥ 3.8 stdlib only.
3. SIGKILL semantics as recorded in ASSUMPTIONS.md: process death, page cache survives; the specimen does not simulate power loss.
4. Network access is needed only to obtain SBCL and the pinned repository; the specimen itself is offline.

## Verifying the bundle itself

```bash
cd kw-0-specimen && sha256sum -c MANIFEST.sha256
```

The archive's own SHA-256 is stated in the cover note that accompanied delivery (and should be verified against the received archive before extraction).
