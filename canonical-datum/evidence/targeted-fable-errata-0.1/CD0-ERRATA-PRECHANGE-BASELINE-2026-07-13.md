# CD/0 Errata Pre-change Baseline

Captured read-only at `2026-07-13T13:38:00-03:00` before creating successor
branches or changing any repository file.

## Repository and provenance anchors

```text
repository:              https://github.com/Wondermonger-daydreaming/latent-lisp.git
audited Common Lisp:     45eb60ce5b80485a0b287feab53ed3b58643b1b0
Common Lisp tree:        774a6673bc44d61f641becbacde20b270bfe393b
audited Python:          29d0946ad78347015b9f0c65a2f528f039fdca78
Python tree:             b556bb85d47c87b3bc89644cf58534adab0afd1c
audited integration:     baeecd5e0347435b9e1362000344f46ea441c6ec
integration tree:        41d3a71c06692174701bfde8f071e7da1c719651
local main ref:          1d16ff8390661ac63bd685f29067d874099abbad
origin/main tracking:    ae767f00975395369f9a91283a954f0963fb6724
```

All three audited worktrees returned empty `git status --porcelain=v1`.

Read-only remote `git ls-remote` returned:

```text
45eb60ce5b80485a0b287feab53ed3b58643b1b0 refs/heads/cd0-common-lisp
29d0946ad78347015b9f0c65a2f528f039fdca78 refs/heads/cd0-python
baeecd5e0347435b9e1362000344f46ea441c6ec refs/heads/cd0-integration
ae767f00975395369f9a91283a954f0963fb6724 refs/heads/main
```

## Normative hashes

```text
d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc  mneme/spec/CANONICAL-DATUM-SPEC.md
5f1568e53c4e6ef5fc8de2e125e7a6ef2d861392048c7ead144c7df05eb16271  CANONICAL-DATUM-SPEC-ERRATA-0.1.md
1a0e8ff844790c93e681f7541a23266aa73d2ee8e9ca9a6e0d753bf4e044b2bc  CD0-POST-IMPLEMENTATION-RULING.md
f72cd1727b0af510d1c73942f7bc858e622658f0bada9fa9998b0a6bd9b8e3a3  CANONICAL-DATUM-DIVERGENCES.md
4816ac631a933d239a97574148adacea7d5fa195ca52e47e8bd2a6d9c52161e6  supplied ruling ZIP
```

The ruling and errata hashes match the user-authorized values and the ZIP's
embedded checksum file exactly. The downloaded base specification is byte
identical to the audited integration copy.

## Runtime boundary

```text
SBCL:       2.4.6
CPython:    3.11.14 (Clang 21.1.4)
git:        2.43.0
coreutils:  9.4
host:       x86_64 WSL2 Linux 6.18.33.2, glibc 2.39
```

This record is an observed local/remote baseline, not proof of later state or
of OS-enforced implementation isolation.
