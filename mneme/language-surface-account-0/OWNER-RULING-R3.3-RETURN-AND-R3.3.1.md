# SURFACE ACCOUNT /0 — OWNER RULING: RETURN R3.3, EXCEPTIONAL INITIALIZATION ONLY (R3.3.1)

*Received 2026-08-05 from the lab owner (Tomás P. Pavan), filed verbatim by the chair
(Claude Fable 5) — sandbox artifact path preserved as received. This document is the
governing law of the R3.3.1 round.*

---

Got it. The R3.3 result is real, but it does **not** earn terminal closure yet.

One custody curiosity first: this newly surfaced `R3 (3).3` ZIP has outer hash
`9577c9a2…`, because it was re-zipped beneath an extra directory. After removing
that wrapper prefix, all **105 files are byte-identical** to the canonical R3.3
archive whose hash is exactly:

```text
2fbb921cdfb511e6ea03c636024748e0f090bd8a932eadf6ead7290e6288a3ec
```

So the specimen is intact; the packaging layer merely put on a second coat.

## Owner ruling: RETURN R3.3, exceptional initialization only

| Seam | Ruling |
|---|---|
| Canonical ASCII counter syntax | **PASS — LOCKED** |
| Delayed-`DEFGLOBAL` hostile schedule | **PASS — LOCKED** |
| Genuine recursive `LOAD` | **PASS — LOCKED** |
| Normal single-state publication | **PASS** |
| Failure immediately after carrier election | **RETURN** |
| Carrier with unrelated plist content | **RETURN** |
| Final evidence hygiene | **BOUNDED REPAIR** |
| Production / adoption / Surface `/3` | **NOT AUTHORIZED** |

Independent SBCL 2.4.6 execution confirms that R3.3 genuinely repairs its
commissioned defects:

* The delayed loader preserves one winning state, gathers exactly one epoch,
  and allocates counters `1–20`.
* Actual recursive loading reaches depth two, returns `:DEFERRED-OWNER-REENTRY`,
  publishes once, then allocates `1` and `2`.
* Arabic-Indic, extended Arabic-Indic, Devanagari, fullwidth, and mixed-script
  digits are rejected.
* All 21 supplied transcript/profile combinations pass.

Two new goblins remain.

First, after the carrier CAS succeeds, `sa0-note-election` runs **before**
execution enters the protective `unwind-protect`. A condition in that narrow
interval leaves:

```text
carrier present
state absent
failure marker absent
observers waiting forever
```

Second, election compares the entire symbol plist against `NIL`. If the carrier
symbol already has any unrelated property, the CAS can never succeed and
initialization spins indefinitely. The code checks one property but wagers
against the whole plist—a tiny mismatch with surprisingly carnivorous teeth.

There is also a minor evidence fossil:
[status-BEFORE-run1.txt](sandbox:/workspace/scratch/72427f1bb7e2/r33_unpack_20260805/statuses/status-BEFORE-run1.txt)
contains `exit=0\n`, despite being described as a zero-byte raw porcelain
capture. Two unstable gate lines also need `VOLATILE` treatment.

The proper next move is therefore **R3.3.1**, continuing from exact tip:

```text
4ef6c232fd2d89d7cbd3779944775b8b024afc2c
```

It should protect every post-election action, make plist election total while
preserving unrelated properties—or fail immediately on an invalid reserved
carrier—add deterministic teeth for both cases, repair the evidence fossils,
and rerun only the affected identity profiles. Everything R3.3 successfully
closed stays frozen; R4 remains reserved for production/adoption.
