# DE-INFANDO — expected failures, comparison, disposition

Companion to `SPECIMEN.lisp` (29/29), `BASELINE.lisp`, `ABLATION.lisp`;
grounds in `RUN-RECEIPT.txt`; adversarial audit in `IANUS-AUDIT.md`.

## 1. What the specimen catches (and on which axis)

| Check | Refusal | Axis named |
|---|---|---|
| I1c | closure through governed direct export | `value-not-reifiable` → `:reifiability` (the canonical boundary itself decides; nothing stringified) |
| I3b | declared-mute witness through direct export | `direct-transmission-impossible` → `:transmissibility` — a **governance** axis, distinct from structural reifiability |
| I8 | canonical datum to a receiver that accepts only `:signed-envelope` | `receiver-representation-unsupported` → `:representation`, blocker carries `:in-context` |
| I9b | exercise from an unauthorized position | `exercise-not-authorized` → `:exercise` — contextual authorization, not a property of the value |
| I12 | recipe-less subject through `:reproduction` | `reproduction-procedure-unavailable` → `:reproduction` |
| teeth-1 | stringified closure claiming `:kind :closure` | `malformed-slice0-shape` → kind is computed, never claimed |
| teeth-2 | a transmission receipt offered as a procedure | refused — a receipt is a record, not live authority |
| teeth-3 | flattened invocation testimony | unrepresentable at construction |
| teeth-6 | copy-constructed standing | no `:judgment` keyword exists |

Every refusal receipted; every receipt names the blocked axis
(`why-requirement-ids`); teeth-5a/5b prove the refusal is scoped
(`:mode :direct :object-local t`) and that a different lawful mode grants —
one failed export never becomes permanent impossibility.

## 2. The locally-usable / non-transmissible demonstration

The gate closure: exists (I1a), exercises before and after every refusal
(I1a/I2a/I9a — the call counter advances 1→2→3), mints support on which the
local claim verifies (I3a) — **and has zero direct transmissibility**
(I1c). Strong local standing and non-exportability coexist without tension,
which is the hypothesis. Meanwhile: its product travels (I4), its exercise
travels as attribution (I5), its recipe travels as data (teeth-5b), and a
receiver mints equivalent support and verifies the same proposition without
ever holding the object (I6/I7).

## 3. Lawful repairs — different acts, never relabels

`export-derived-result` → a **grant for the product** (receipt subject is
the derived result, not the gate); `construct-testimony-claim` → the
attribution claim **with the refusal receipt intact**; `exercise-locally` →
use, not transmission (decision stays `:refused`); `defer-transmission` →
only the record; `mint-equivalent-support-at-receiver` → receiver-side
support (I6). No repair path flips a refused direct export to `:granted`.

## 4. Ablation expectations — confirmed

One `:exportable` boolean in place of five axes: the printed description
ships as the value, testimony ships as the deed, the product ships as the
producer, and — the deepest loss — the refusal branch is unreachable, so
"locally real, locally strong, not carryable" becomes **unsayable**. 0
refusals, 0 receipts. The axes were the property.

## 5. The six WORK-ORDER-0 questions, against the baseline

**Both express** the honest acts: FABER-CL-III's baseline distinguishes all
six lawful modes by convention, competently. **Easier misleading act in
CL:** all six drifts are one line (`(format nil "~a" closure)` exported; a
flipped `:exportable` slot; a hash write; a `remove-if`; a copied flag).
**Where Lisp+ rejects/exposes:** the stringified closure cannot claim
closure-kind (computed, teeth-1); the five axes cannot collapse (they are
separate receipt fields with separate conditions); testimony cannot flatten
(construction law); refusal cannot become absence (the receipt holds the
subject and its alternatives — teeth-4). **Lawful repair:** §3 — six of
them. **Ceremony:** one `local-value` per admitted object, one `transmit`
per attempt; receipts free. **Library reproducibility:** yes,
constructively, as in both prior specimens — and this specimen's *distinct*
contribution is that the question was never "can CL host this" but "is the
escape explicit": see §6.

## 6. The escape boundary, sized honestly

The `::` escape stands, unchanged, now **three times measured**. This
specimen adds one more honest datum: the restart whitelist itself is
package state, extended visibly by this module at load time — the governed
vocabulary governs **well-formed programs**, not arbitrary same-image code.
Per the work order's language-claim discipline, the relevant question is
whether Lisp+ makes the escape **explicit, auditable, and outside ordinary
governed acts** — and today the answer is: the escape is *acknowledged and
receipted in prose*, not yet *marked in code*.

**Slice /1 candidate (recorded, not built):** an explicit host-escape
marker — a `with-host-escape (reason)` form that any `::` access or
whitelist mutation inside governed modules must be wrapped in, plus a
source-walking linter that inventories unmarked escapes. That would move
"the escape is visible" from documentation to checkable structure. No
compiler, no process isolation.

## 7. Adversarial audit — findings and dispositions

`IANUS-AUDIT.md` (Fable checker, run before banking; hunt areas
scalar-ladder / stringification / receipt-as-authority / exercise-laundering
all CLEAN with demonstrations; both prior specimens re-verified undisturbed).
Three findings, all dispositioned before this file's §8 was finalized:

1. **CORRECTION (applied):** charter §9's "frozen whitelist / not offered,
   ever" and the `with-slice0-restarts` docstring were overclaimed — IANUS
   minted `continue-anyway` into the package-state whitelist from a fresh
   package and expressed it through the very macro that claims to forbid it.
   Both texts now sized: the closed set is **surface discipline against
   well-formed programs, not host closure** (same R3-class escape as `::`).
   The charter carries the sizing with attribution.
2. **NOTE (fixed, then teethed):** the `local-value` accessors returned
   internal shared lists — an ordinary `NCONC` on the returned
   authorization list minted unauthorized access. The public accessors now
   return defensive copies (construction also snapshots); the audit's exact
   attack is replayed as **teeth-7** and shown dead.
3. **NOTE (sized, lawful under R3):** teeth-3's "unrepresentable" holds for
   the `:testimony` label; a caller that *lies about mode* (relabeling
   testimony-shaped content `:derivation` with a first-order `:for`) is a
   provenance lie the R3 ceiling explicitly leaves open — the gate guards
   the vocabulary, not caller honesty. The claim is hereby read at that
   size.

IANUS's overall verdict, quoted at its size: *"the packet is honest at its
stated size,"* conditional on the §9 sizing — which is applied.

## 8. Disposition — final, multidimensional (specimen 3 and Slice /0)

```lisp
(:de-infando-disposition
 :semantic-axes-orthogonal :validated
 :local-existence-vs-transmissibility :distinguished
 :refusal-names-axis :validated
 :repairs-are-distinct-acts :validated
 :governed-language-act :earned
 :host-level-enforcement :not-earned
 :escape-surface :common-lisp-package-internals
 :escape-visibility :prose-not-yet-structure
 :slice-1-candidate :host-escape-marker)

(:slice-0-final-disposition
 :governed-acts (:promotion :projection :transmission :exercise)
 :shared-semantic-algebra :validated
 :semantic-axes-orthogonal-to-standing :validated
 :testimony-level-discipline :held-across-all-three-specimens
 :receipt-composition :validated
 :embedded-language-fragment :earned
 :host-level-closure :not-earned
 :standalone-language-claim :not-yet-earned
 :escape-surface :common-lisp-package-internals
 :escape-visibility-candidate :slice-1-host-escape-marker)
```

**Public verbs genuinely forced by this specimen:** `local-value`,
`exercise-value`, `transmit`, `transmission-views`, `reifiable-p` — the
claim/witness/raise algebra could not express governed non-transport; the
domain forced the verbs.

**The specimen's answer to its question** — *what can exist, act, and
warrant locally without becoming an object that may be carried away?* — A
closure-shaped capability can exist, act, produce exportable products,
license local verification, ground testimony, seed receiver-side
equivalents — everything except *be carried*. And under the governed
surface, its not-being-carried is a **receipted, axis-named, scoped fact**
that erases nothing and forecloses nothing.

— Claude Fable 5 (CC seat), 2026-07-23
