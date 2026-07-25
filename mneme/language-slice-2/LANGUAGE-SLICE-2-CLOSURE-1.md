# LANGUAGE SLICE /2 — CANDIDATE /1 CLOSURE

*What was built under `LANGUAGE-SLICE-2-WORK-ORDER-1.md`, what it costs, and what
it does not do. **Nothing here is frozen, and this is not an adoption record** —
the work order forbids writing one in this movement.*

```
specification-frozen:   no
public API:             candidate /1 surface
slice2 exports:         85 → 100   (+15, all readers and one condition)
core0 exports:          62 → 62    (byte-untouched — a stated non-goal)
slice1 exports:         74 → 74    (slice1.lisp byte-untouched)
slice0 / kernel0:       untouched
stranger audit:         OWED, against this closure too
```

---

## 1. Suites, as run

Complete language floor, **once**, after the focused suite was green — as
instructed, and without ceremonial repetition:

```
core0-substrate         29 /  0     unchanged
core0-issuance          73 /  0     unchanged
slice1-selftest        123 /  0     unchanged
slice1-smoke             9 /  9     unchanged
de-codice-restaurando  101 /  0     unchanged
de-cursore-aereo        23 /  0     unchanged
de-ponte-usto           17 /  0     unchanged
slice2-smoke            10 / 10     unchanged
slice2-selftest        108 /  0     was 75   (+33)
de-bibliotheca         116 /  0     was 108  (+8)
                       ─────────
                  10 floors · 609 checks · 0 failed     (was 568)
```

**Seven of ten floors did not move.** That is the load-bearing number here, not
the two that rose: an additive species that disturbed nothing is the only kind
this movement was authorized to build.

## 2. What the twenty required controls actually assert

Each names a typed condition, a disposition, a receipt field or a rendered
reason. **Not one of them measures merely "did it fail?"** — the work order says
so, and the reason is on this lane's record: a probe earlier the same day
observed three failures and would have reported a gate fired, when the failures
came from somewhere else entirely.

| | control | asserted |
|---|---|---|
| C1a | v0 contract refuses `(:derivation-basis)` | `unknown-admission-clause` |
| C1b | v1 accepts it, no options | clause list equality |
| C1c | unknown version refuses | `admission-contract-error` |
| C1d | the ceiling is not the source-basis ceiling | two distinct keywords |
| C1e–i | grant returns a third value | basis binds claim + receipt **by object** |
| C1j | refusal mints nothing | registry count unchanged **+** `:not-admitted` |
| C1k–o | the basis discharges | `:satisfied`, ceiling, rendered text |
| C1p–q | naked claim refused | `:not-admitted` **+** reason names `:route :naked` |
| C1r | ordinarily raised twin refused | `:not-admitted` |
| C1s–t | coherent unminted basis refused | established-p false **while coherent-p true** |
| C1u | structural copy refused | `EQ` registry |
| C1v | registered-but-inconsistent basis | **false anyway** — object answers for itself |
| C1w | shape with no carrier | residue at the caller's index, own reason |
| C1x | both roads offered | **admitted and refused in one derivation** |
| C1y | mismatched proposition | fails **through Slice /1**, not through admission |
| C1z | inaccessible | admission cannot reach past it |
| C1aa | refutation | retains precedence |
| C1ab–ac | three stages compose | chain walkable to the original source basis |
| NC3–4 | establishment conjunct removed | a coherent unminted basis is **ADMITTED**, then refused again |
| NC5–6 | naked-claim road opened | the bare claim **discharges**, then is refused again |

`C1s` is the one worth reading twice: a basis whose **every field agrees with a
real grant** — coherent by its own predicate — is refused, because it was not
minted here. That is the Candidate /0 lesson (`R-SOURCE-1.7`) holding one layer
up.

## 3. `[IX-10]`, closed in the inhabited application

Movement XI, using the **third value of the grant Movement X already made** — no
re-derivation:

```
[XI-1]  the desk's own NAKED granted claim   → recognized, :NOT-ADMITTED
[XI-2]  an ordinarily raised twin            → :NOT-ADMITTED
[XI-3]  the established derivation basis     → discharges; closure standing granted
[XI-4]  downstream receipt → prior receipt → source basis → the He-9 crossing,
        walked BY OBJECT, no resolver
[XI-5]  the recorded ceiling is the prior-judgment one — it did NOT inherit
        the account-report ceiling
[XI-6]  the rendering preserves the modest ceiling
[XI-7]  no courier script, adapter outcome, Core /0 event or source relation
        was altered for this movement
[XI-8]  the basis carries the ACCOUNT-STANDING proposition, never the closure
        conclusion — the domain step stays a schema the desk wrote
```

`[XI-1]` is the exact sentence `[IX-10]` reported, now **refused rather than
merely observed**: the claim is visible, and still not enough.

## 4. Costs and holes, named

**(a) The projection/record asymmetry.** The projection into Slice /1 is
deduplicated by `EQ`; the admission record is not. Necessary in both directions —
one claim object handed to Slice /1 twice could manufacture an ambiguity the
caller never created, and collapsing the two roads would erase the distinction
the species exists for. It is a real seam, and it is where a future defect in
this design is most likely to live.

**(b) The `EQ` registry, inherited deliberately.** A structural copy of a
derivation basis is refused, exactly as for a source basis. Stricter than Core
/0's exact-content rule, and said plainly rather than dressed up.

**(c) Candidate /0's discarded base grant is unchanged.** Every recognized
support still reaches the base derivation, so when the base grants and Slice /2
refuses, a Slice /1 grant is computed and dropped. Not touched here; the reason
it was chosen is in `SPEC-0`.

**(d) A basis is only as narrow as the contracts behind it.** `:PRIOR-EXPLICIT-
ADMISSION-JUDGMENT` says *there were explicit per-premise contracts and here is
the receipt* — **not** that those contracts were demanding. A prior derivation
every one of whose premises accepted an asserted witness produces a perfectly
valid derivation basis. The receipt is attached precisely so a downstream reader
can go and look, and `[XI-5]` asserts the ceiling does not silently upgrade. **A
premise that needs a Core /0 account report must still ask for a source basis.**

**(e) One check was reworded, not softened.** The renderer's *disclaimer*
contained the phrases the renderer is forbidden to print, and the blunt substring
test caught it. The disclaimer was reworded. Recorded because the opposite fix —
teaching the test to parse denials — was available and would have been worse.

**(f) Self-consistency, not corroboration.** One model family wrote the language,
the applications, the work order's execution, this closure, and the instrument
that graded it.

**(g) Every account is a labelled scripted fake adapter.** A real governed
in-image act, **never** evidence that any external deed occurred. A lying adapter
produces identical readers throughout.

## 5. The ceiling, once more

A derivation basis establishes **at most**:

> this image granted this exact claim under explicit per-premise admission
> contracts, and here is the receipt.

Not that any premise behind it was source-bound. Not that anything was checked
outside this image. Not that a deed took place or a matter closed. Not
cross-image, not durable, not serializable, not cryptographic.

---

*Built against lab `0d05b897` in an isolated clone with no remotes and disabled
hooks · SBCL 2.4.6 operation-checked through the wrapper · floor 10/609/0 ·
`specification-frozen: no`.*

— **Claude Opus 5 (1M context)**, 2026-07-25
