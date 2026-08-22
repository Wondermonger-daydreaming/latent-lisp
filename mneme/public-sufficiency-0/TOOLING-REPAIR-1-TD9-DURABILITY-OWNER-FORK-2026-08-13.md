# TOOLING REPAIR /1 — TD-9 OFF-HOST DURABILITY OWNER FORK (2026-08-13)

**Returned per SOL-TR1-02. This document SPECIFIES the persistence
crossing; it EXECUTES nothing. Until an owner-authorized real persistence
crossing and a fresh materialization from the durable remote succeed,
TD-9's standing is: IMPLEMENTATION-CANDIDATE / OFF-HOST DURABILITY
UNREACHED — not CLOSED.**

## What SOL-TR1-02 established

The fresh-clone tooth fetched the record from the still-live local source
repository — proving *fetchability*, not *survival of lab-host loss*. The
ref `refs/latent-lisp/transport-record` has never reached a durable
remote. (The round-3 disposable tooth upgrades the model: bare remote →
source repo destroyed → clone from remote only → full-chain verify. Still
a model; the real crossing is this fork's subject.)

## Specification

- **Exact durable destination/ref:** the LAB repository's own remote —
  `https://github.com/Wondermonger-daydreaming/Claude-Code-Lab.git` —
  ref `refs/latent-lisp/transport-record`, pushed as
  `git push origin refs/latent-lisp/transport-record:refs/latent-lisp/transport-record`.
  Explicitly NOT the public mirror (`latent-lisp`).
- **Domain question (Channel Policy /1):** the accepted candidate's §0
  domain is the public mirror channel. The lab remote is OUTSIDE that
  domain: pushing this ref there is lab-repo custody, not a mirror
  publication act, and creates no PUBLISHED standing under CP/1. (It is
  the same class of act as pushing the branch itself, which the TR/1
  commission already authorizes.)
- **Prohibited-content analysis:** records carry only identities (commit
  shas, ref names, subtree path), event kinds, bounded scrubbed reasons
  (C0/DEL stripped, credential shapes redacted, 400-byte UTF-8-safe
  bound), exit codes, times, run-ids. No scoring-key content, no
  Language-A items, no subject outputs, no per-item findings, no live
  credentials — the §4 content prohibitions are satisfiable by
  construction and re-checked by `verify`'s schema walk. Caveat named
  plainly: whatever visibility the lab remote has, the record inherits;
  the reason texts originate partly from far-side `remote:` lines
  (scrubbed, bounded).
- **Authorized principal:** the same host credential that already pushes
  the lab repo. NO new credential, NO deploy key, NO mirror-side change —
  this fork is disjoint from TD-6's.
- **Automatic vs manual:** recommended AUTOMATIC, fail-soft — a
  `transport-record.sh push` subcommand invoked at the tail of each
  sync-reaching run: attempts a fast-forward push of the ref; on failure
  logs + leaves a durability marker and retries on the next run. Manual
  invocation documented as fallback. The push must never block or fail
  the transport itself (durability lag is reportable state, not an
  error in the transport).
- **Failure reporting / retry / CAS semantics:** the ref is append-only,
  so the push is always fast-forward from a healthy host. A non-FF
  rejection means local/remote divergence — that is an ALARM (RED,
  investigate; NEVER force-push, never rebase the record). Bounded
  retries across runs; status query reports DURABILITY: CURRENT /
  BEHIND-n-EVENTS / NEVER-PUSHED / DIVERGED(RED).
- **Rollback:** delete the remote ref
  (`git push origin :refs/latent-lisp/transport-record`). One reversible
  act; local record unaffected.
- **Exact closure criterion:** (1) owner authorizes this fork; (2) one
  real crossing executes (the ref lands on the lab remote); (3) a fresh
  materialization on a machine/clone that never held the record fetches
  the documented refspec from the real remote and `verify` walks the
  complete chain GREEN; (4) the transcript of (2)+(3) is returned and
  owner-accepted. Only then may TD-9 be reported repaired (acceptance
  still the owner's separate act).

## The fork (owner decision required)

☐ **AUTHORIZE** the crossing as specified (automatic fail-soft push to
the lab remote; closure per the criterion above). ·
☐ **AUTHORIZE, MANUAL-ONLY** (chair pushes the ref by hand at owner-named
moments; no automatic tail-push). ·
☐ **DEFER** — TD-9 remains IMPLEMENTATION-CANDIDATE / OFF-HOST DURABILITY
UNREACHED. ·
☐ other destination or wording the owner prefers.

*— prepared 2026-08-13 by the chair; nothing executed.*
