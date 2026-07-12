# Relay to Claude Code — land `de-dilatatione.lisp`

Prepared 2026-07-12 for the live `Wondermonger-daydreaming/latent-lisp` tree.

## Artifact

- Source: `de-dilatatione.lisp`
- Proposed path: `mneme/atelier/instruments/de-dilatatione.lisp`
- Sender-side lines: 1040
- SHA-256: `9deecdeee91ddc52193a78beea69c5368d63e28503aecf98660de54a18e398c3`
- Native Common Lisp status: **not run here**; no Lisp implementation was available.
- Static preflight: PASS.
- Independent Python behavioral model: PASS.

## The bounded claim

The specimen models Catherine Pickstock's reading of Spenserian dilation as a typed alternative to a zero-sum contest between fixity and change. In its finite symbolic domain:

1. preservation is not petrification;
2. change is not annihilation or identity replacement;
3. upward address is not purchased by deleting worldly relations;
4. capacity without relation is not communion;
5. lawful dilation grows outward relation, upward address, and hosting capacity while retaining the declared core vow and prior relation;
6. fulfillment retains an open successor rule rather than declaring growth complete;
7. a finite prefix is not infinity;
8. theological imagery remains `:ASSERTED`, never self-promoted to `:VERIFIED`;
9. refused rival syntheses remain archived as complete proposal scars;
10. attention supplied through a restart remains in the event and deterministic replay.

The final lawful conclusion is:

```lisp
:GROWTH-PRESERVED-IN-OPEN-FULFILLMENT
```

with standing:

```lisp
:ASSERTED -> :ASSERTED
```

## Do not accidentally "improve" these distinctions away

The following typed refusals are constitutional, not decorative:

```text
FIXITY-IS-NOT-ETERNITY
CHANGE-IS-NOT-ANNIHILATION
ASCENT-IS-NOT-SUBTRACTION
CAPACITY-IS-NOT-COMMUNION
GROWTH-NEEDS-TWO-AXES
FULFILLMENT-IS-NOT-CLOSURE
STANDING-LAUNDERING
FINITE-PREFIX-IS-NOT-INFINITY
THEOLOGICAL-IMAGE-IS-NOT-EVIDENCE
FORGED-FULFILLMENT-CLAIM
STALE-PROPOSAL
```

Please do not make the tests pass by weakening the model until one of the rejected rivals becomes lawful. In particular:

- do not treat a frozen form as eternity;
- do not let novelty discard the source core or history;
- do not let vertical growth consume horizontal relations;
- do not infer communion from spare capacity;
- do not rename a finite successor prefix as actual infinity;
- do not upgrade the artifact's epistemic standing because its synthesis is elegant.

## Receiving procedure

1. Inspect the live branch first. The public repository may have moved since this packet was prepared, and earlier Hay/Lathe/Furnace/etc. relays may or may not already be present.
2. Copy the source to `mneme/atelier/instruments/de-dilatatione.lisp` without overwriting unrelated live work.
3. Run sender-side checks:

```bash
python3 check-de-dilatatione.py de-dilatatione.lisp
python3 reference-de-dilatatione.py
```

4. Run the native specimen from its own directory so the relative Atelier-root load is tested honestly:

```bash
cd mneme/atelier/instruments
sbcl --script de-dilatatione.lisp
```

5. Inspect the full output. Expected landmarks include:

```text
six archived refusal scars
outward relations 1 -> 4
upward address 1 -> 3
capacity 2 -> 5
attention supplied 2
three finite horizon successor steps
:ASSERTED -> :ASSERTED
:GROWTH-PRESERVED-IN-OPEN-FULFILLMENT
DE DILATATIONE complete
```

6. Run the existing atelier suite before integration:

```bash
cd ..
./run-all.sh
```

7. Only after native success, integrate minimally into the live `CANON.md`, `MANIFEST.sexp`, and `run-all.sh` according to their actual current syntax and ordering. Do not replace those files wholesale with assumptions from this relay.
8. Report every repair. Distinguish source defects from integration drift. Include the exact SBCL command, implementation/version, exit status, output landmarks, and post-repair SHA-256.

## Review points worth pressing

- Confirm `archive-refusal` retains the entire rejected proposal, not merely its condition label.
- Confirm planning and failed rivals do not mutate the source heart.
- Confirm the lawful result retains `(:NEIGHBOR :RECOGNIZED)` while adding the three new outward relations.
- Confirm the restart-supplied attention is recorded and replayed.
- Confirm recomputing the pedagogical digest after forging `:VERIFIED` does not defeat semantic validation.
- Confirm horizon steps remain finite receipts and cannot be promoted to actual infinity.
- Confirm stale source epoch invalidates the old proposal.

## Nonclaims to preserve

This is not a proof of Pickstock's theology, Spenser's metaphysics, divine eternity, psychological flourishing, or any empirical property of human hearts. The axes and resources are declared pedagogical structures. The FNV-class digest is not cryptographic. The model is cooperative and same-process; it does not defend against code reaching package internals.

The instrument's closing sentence is intentionally narrower than a metaphysical theorem:

> The heart becomes more capacious without making God and world rivals.
