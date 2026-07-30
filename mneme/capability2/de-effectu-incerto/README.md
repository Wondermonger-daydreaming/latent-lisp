# de-effectu-incerto — the inhabited uncertain-effect restart specimen

**"Concerning the uncertain effect."** The Latin names the epistemic
residue this specimen exists to inhabit: not the crash (other lanes'
specimens own their crashes) but the *effect whose occurrence the
surviving evidence cannot, at first, decide* — and the discipline that
decides it lawfully.

> A recognized, current capability may justify attempting one exact
> protected effect — but neither the capability nor its presentation
> receipt proves that the effect occurred.

**Status: candidate** (part of the Capability /2 candidate lane; not
adopted, not frozen, no floor, no stranger audit; all greens are
same-family self-consistency; substrate statuses in the lane README).

Three processes: the **orchestrator** (`run-specimen.lisp` — supervises,
digests, preserves; renders no effect verdicts of its own), the **prima
vita** (`stage-first-life.lisp` — granted, minted, authorized, it
dispatches the one exact cell write and **dies inside the acknowledgment
window**: the dispatch durably landed in the world; the acknowledgment
never came home; its memory dies with it), and the **rediviva**
(`stage-restart.lisp` — a genuinely new process over durable bytes and
declared configuration only, which refuses blind retry from the bytes
alone, structures the §10.8 record, reconciles with evidence against the
surviving world, and only then finds the seat free).

The preserved `ARTIFACT-*` files include **both journal states** — as
the death left it (three frames, ending at `attempt:frontier-crossed`)
and as reconciliation closed it (five frames; the death-state bytes a
verbatim prefix) — plus the world's cell store and request ledger (the
outside that survived) and the dead life's authorization receipt
(testimony that licensed the attempt and proves nothing about the
effect). `ARTIFACT-SHA256SUMS.txt` carries the digests;
`ARTIFACT-MANIFEST.txt` the plain-language accounting.

Interruption mechanism, stated honestly: a planted deterministic env-var
early exit in the adapter's acknowledgment path (the capability1
planted-death precedent). **No SIGKILL and no mid-instruction byte
truncation is claimed** — `journal0/de-teste-occiso` owns real
crash-window truncation. What is exercised is byte-equivalent, in
surviving state, to any death in that window; the claims rest on the
surviving bytes, not on the death mechanics.

Run (from the latent-lisp root; SBCL 2.4.6):

```
sbcl --script mneme/capability2/de-effectu-incerto/run-specimen.lisp   # 29 checks, exit 0
```

Two runs byte-identical (`RUN-EXITCODES.txt`). Full accounting:
`SPECIMEN-RETURN.md`.

— CLAVIGER-III (Claude Fable 5 subagent), 2026-07-30
