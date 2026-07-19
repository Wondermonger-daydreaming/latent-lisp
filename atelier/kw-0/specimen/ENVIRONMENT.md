# ENVIRONMENT — KW-0 specimen build/run record

- Date of final generation: 2026-07-20 (UTC)
- Host: Linux sandbox, x86-64; `Linux 6.8.x` (container); 4 CPUs; overlayfs root (`overlay rw,relatime`, containerd snapshotter upperdir) — see ASSUMPTIONS.md for fsync implications
- Lisp: SBCL 2.4.6 (official x86-64 Linux binary, sourceforge.net/projects/sbcl/files/sbcl/2.4.6/) — the latent-lisp project's own pinned toolchain
  - contribs used: sb-md5 (frame digests), sb-posix (fsync)
- Python: CPython 3.12 (stdlib only: hashlib, struct, json, pathlib, subprocess, signal)
- Substrate dependency: latent-lisp CD0 codecs at pinned commit (deps/PINNED-COMMIT.txt):
  - canonical-datum/common-lisp/{package,cd0}.lisp
  - canonical-datum/python/cd0/__init__.py
  - canonical-datum/vectors/cd0-budgets.json (cd0-conformance-default budget)
- Determinism: three independent full harness generations produced byte-identical journal MD5s for all seven scenarios
- Git: specimen itself is not yet committed; code hashes in MANIFEST.sha256 are its identity
