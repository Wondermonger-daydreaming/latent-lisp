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
