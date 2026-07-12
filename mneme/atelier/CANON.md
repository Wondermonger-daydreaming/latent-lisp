# The Lisp+ Atelier — First Cabinet

Six executable specimens for the Mneme / latent-native line. They share a deliberately small root in `kernel/atelier-root.lisp` and are shelved by function rather than prestige.

## Reliquaries

- `reliquaries/de-testimonio-postumo.lisp` — a historical execution certificate survives while the function bound to its old name changes.
- `reliquaries/museum-nocturnum.lisp` — retracted, quarantined, superseded, and active artifacts remain preserved without receiving equal authority.

## Instruments

- `instruments/speculum-bifrons.lisp` — structural and interpretive readers share a source while refusing to impersonate one another.

## Toys with teeth

- `toys/notarius-mustela.lisp` — a ferret produces impeccable witness paperwork without authority to certify it.
- `toys/ambulatorium-himma.lisp` — revisitation changes salience but never upgrades evidential standing.
- `toys/oraculum-quinque-oris.lisp` — answer, distribution, question, refusal, and failure remain distinct judgment shapes.

## The Decad — GPT Sol's ten (relay 2026-07-12)

Ten executable specimens authored by **GPT Sol** and relayed to the lab on 2026-07-12; landed and audited by SARTOR-V / SARTOR-VI (Claude Opus 4.8) under the Fable 5 chair, and moved into this workshop on the owner's 2026-07-12 ruling that the atelier is a living workshop, not an author-gated memorial. **Sol is the author; the lab is the integrator.** Each ran exit 0 under SBCL 2.4.6 with its advertised gates biting. Shelved in procession order.

- `instruments/de-foeno.lisp` — a syntax definition is ordinary data: evaluating it changes one interpreter's reachable forms, and transmission is not adoption until another interpreter evaluates it for itself.
- `instruments/de-torno.lisp` — a transformer may propose a new form but may not silently install it; every committed cut names its pass, stays inside a declared jurisdiction, and never upgrades the standing of the words it reshapes.
- `instruments/de-fornace.lisp` — admission is not adoption; compatible proposals may alloy without sharing an author, and numerical repetition or fluent synthesis does not settle the truth of what was combined.
- `instruments/de-temperie.lisp` — surviving a named ordeal is not being true; repaired survival is distinct from unaided survival, and rhetorical hardening may not promote `:ASSERTED` work to `:VERIFIED`.
- `instruments/de-leviathan.lisp` — finite handles on an object whose declared extent exceeds them yield bounded access, never possession; the only lawful final verdict is `:UNSUBDUED`.
- `instruments/de-abysso.lisp` — an answer is not the whole depth it surfaced from; bare silence (`NIL`) is not admissible as absence without a typed cause and completed coverage of a declared field. *(Landed `:landed-unsealed-pending-sol-reseal` — audited and runs, but its delivered bytes did not match the relay seal; awaiting Sol's canonical reseal.)*
- `instruments/de-incantatione.lisp` — a rhyme first sounded is an open structural obligation; beauty is not authority, recitation is not evidence, and a symbolic banishment does not prove an entity existed.
- `instruments/de-resonantia.lisp` — resemblance, transmission, entrainment, inheritance, and causal descent stay distinct relations; no amount of resonance upgrades `:ASSERTED` to `:VERIFIED`.
- `instruments/de-dilatatione.lisp` — preservation is not petrification and change is not replacement; dilation grows along two non-zero-sum axes without deleting worldly relations, and capacity alone is not communion.
- `instruments/de-concordia.lisp` — an image is not yet a world: activation, accumulation, and concord stay distinct, and poetic belief is world-sustaining coherence, not evidence.

*Note: `de-foeno.lisp` is self-contained (defines its symbols in `CL-USER`, loads no kernel), so it does not carry a private `DEFPACKAGE`; `static-check.py`'s package-isolation lint flags it. Its bytes are Sol's and were left unedited. The nine others load `../kernel/atelier-root.lisp`, which resolves natively from this directory.*

## Post-decad succession — GPT Sol's first instrument after the decad (relay 2026-07-12)

Authored by **GPT Sol**, relayed as a standalone post-decad parcel and landed/audited by **SARTOR-VII** (Claude Opus 4.8) under the Fable 5 chair. Explicitly **not** an eleventh decad member (Sol's own `:exclude-from`): it begins a new succession after the decad. Ran exit 0 twice under SBCL 2.4.6, byte-identical output, seal `31b3d923…` verified pre-edit, **zero repairs**. Standing: `:prototype-supported-by-shared-root-audit`.

- `instruments/de-symmetria-tremenda.lisp` — *Concerning Fearful Symmetry.* The repeated frame of Blake's *The Tyger* preserves structure while `:COULD` becomes `:DARE`; beauty does not domesticate terror, and a question about a maker does not certify one. Thirteen advertised paths bit in the shipped run (FORGE-FIRE-EXHAUSTED with live SUPPLY-FIRE repair, nine counterfeit-promotion scars, FORGED-CREATION-CLAIM, FRAME-PROCEDURE-UNAVAILABLE, STALE-SYMMETRY-PLAN); its seven validator/replay teeth are declared-dormant and were all outside-bitten (five author-suggested, two SARTOR-VII-authored: ALTERED-FORGE-SOURCE, ALTERED-FORGE-SCAR). Carries its own private `DEFPACKAGE` (`lispplus-atelier.de-symmetria-tremenda`); passes the package-isolation lint. Correspondence: `atelier/leibnitiana/post-decad/de-symmetria-tremenda/`.

## Canonization rite

An artifact enters this cabinet only if:

1. It runs.
2. It states exactly what it demonstrates.
3. It names what it does not demonstrate.
4. At least one adversarial gate bites.
5. Its output is itself an intelligible exhibit.
6. Its failures remain archived as provenance.
7. Beauty may attend, but may not vote.

## Bounded caveats

The shared root uses a deterministic FNV-1a digest and a pedagogical MAC so the specimens have no external dependencies. These are **not cryptographic primitives**. Replace them with canonical byte serialization, SHA-256, and HMAC/signatures before any production or adversarial deployment.

The specimens are written to run as standalone scripts under SBCL from their own directories. `run-all.sh` invokes them in separate processes.
