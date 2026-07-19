# Killed Witness — Recorded Assumptions

Everything the specimen's evidence depends on. Recorded before any verdict.

## Filesystem and synchronization

- Journal filesystem: **overlayfs** (`overlay rw,relatime`, upperdir on containerd snapshotter) — the root filesystem of the sandbox; `/tmp/kw` lives on it.
- Writer: single writer, `O_APPEND`-equivalent append, `finish-output` + `fsync(fd)` via `sb-posix:fsync` before any frame is called durable.
- **SIGKILL ≠ power loss.** SIGKILL kills the process; the host's page cache survives. Therefore the `cw2cw3` window (write flushed, fsync never issued, process killed) leaves *the complete frame present* on this host. The specimen's honest reading — and the reconstructor's — is the F1-repaired classification: **"complete frame present; durable-receipt standing absent."** A true power-loss CW-2 (bytes lost) would present as a torn or absent tail instead; this specimen does not simulate power loss and says so.
- overlayfs fsync semantics: fsync on an overlay file syncs the upper filesystem. No exotic mount options observed (`index=off`). No `O_DIRECT`.

## Digests

- Frame chain and evidence digests: **MD5, pedagogical** — matches the lab's own latent-mvp v1 practice; real crypto is owed-ledger item 1. Collision resistance is not load-bearing for this specimen (no adversary; integrity chaining only). SBCL `sb-md5` (CL) vs Python `hashlib.md5` — independent implementations, cross-verified.

## Control channel

- The `READY-<killpoint>` marker files and the harness's `time.sleep` windows are **death-harness instrumentation**, not journal content. The reconstructor never reads them; it sees only `witness.journal` bytes (and, in F3a, the provider receipt it fetches and appends).
- The harness knows the injected crash point (ground truth). The reconstructor does not. Where two causes leave identical bytes, the reconstructor's correct answer is the ambiguity.

## Determinism

- Oracle responses are pure functions of (seed, request). The full six-death harness generation is **byte-reproducible**: two independent generations produced identical journal MD5s for all six scenarios (see report §4).

## Scope limits

- Single seat, single process, single provider. No concurrency, no fsync racing, no network. The specimen falsifies or supports the *classification and recovery discipline*, not distributed-systems claims.
- The Python folder shares no code with the CL side (hashlib/struct vs sb-md5/sb-posix); the CD0 codec is the project's own in both languages — that is the point of the differential, and also its declared limit: a codec-level bug shared by both CD0 implementations would not be caught here (covered instead by the CD0 vector suites).
