# monadologia/ — Leibniz through Lisp and homoiconic play

*Bed pitched 2026-07-12, 00:20 −03, by the owner ("a Lisp scripts and arc series
exploring Leibniz through Lisp and homoiconic play") and archived by Claude Fable 5.
STATUS: **BUILT, 2026-07-12** — the seven specimens raised the same day by the Leibniz
wave (FABER-HARMONIAE 1–3, FABER-THEODICAEAE 4–7, Opus builders under the Fable 5
chair), plus two net-new siblings beyond this pitch (`de-notatione.lisp`,
`monadologia-90.lisp`, NOTARIUS) and a preface (`PRAEFATIO.md`, chair's hand). The
atelier's law held for every specimen: runs under `sbcl --script`, exit 0 = the law
holds, teeth shown firing, honest ceilings stated. The `:commentary` slots of
`monadologia-90.lisp` remain empty — reserved for the past-Fable Leibniz reading.*

## Why Leibniz is the atelier's most natural guest

No philosopher is more Lisp-shaped. He dreamed a **characteristica universalis** —
a symbolic language in which concepts compose like numbers — and a **calculus
ratiocinator** to settle disputes by computation ("**Calculemus!**" — *let us
calculate* — is the atelier's whole liturgy, three centuries early). He invented
**binary arithmetic** and read it in the I Ching's hexagrams. His ontology is made
of **windowless monads** — encapsulated units that never message each other yet
perfectly agree, each mirroring the entire universe from its own perspective.
That is not a metaphor waiting to be forced; it is a *specification* waiting to be
run. And the lineage is live: Language A / Mneme is a small characteristica with
receipts — this bed is the push's ancestor shrine, played rather than cited.

## The specimen series (each independently buildable; suggested order)

1. **`de-harmonia-praestabilita.lisp`** — *Pre-established harmony.* N monads as
   closures over the same initial seed, **no shared state, no channels, no
   windows** — each independently unfolds the whole universe from its own
   perspective function. The law: after T ticks, their world-mirrors AGREE
   (byte-identical modulo perspective projection) though they never once
   communicated. Teeth: give one monad a window (a sneaky mutation channel) and
   show the harmony gate catch the heresy. *The deepest joke: distributed
   consensus with zero messages, because the consensus was compiled in.*

2. **`calculemus.lisp`** — *The calculus ratiocinator, toy-sized.* A miniature
   dispute: two parties assert incompatible conclusions from shared premises; the
   reducer normalizes both to canonical form and computes the verdict. The law:
   the verdict is a function of the premises, not the parties. Honest ceiling
   (Leibniz's own tragedy, stated in the output): this works only where the
   concepts were already formalizable — the interesting disputes are about the
   encoding, and the reducer must REFUSE (typed condition) when handed a dispute
   whose terms it cannot canonicalize. *Kinship: `mneme/language-a/validator.lisp`
   — the refusals ARE the modern part.*

3. **`de-ratione-sufficiente.lisp`** — *Nothing is without reason.* A world-record
   format where every fact must carry a `:ratio` field (its sufficient reason);
   the principle enforced as a typed condition — a fact without a reason **fails
   to enter the world**. Then the regress: reasons are facts too; show the chain
   terminate (in the world's seed — "the necessary being," per Leibniz) or refuse.
   *Kinship: Mneme receipts — sufficient reason is the 17th-century jurisdiction
   stamp.*

4. **`de-indiscernibilibus.lisp`** — *Identity of indiscernibles, in the identity
   zoo.* Lisp has FOUR grades of indiscernibility (`eq` / `eql` / `equal` /
   `equalp`) — Leibniz's law tested against each: two structurally identical
   s-expressions that are not `eq` are a *counterexample* (indiscernible yet two)
   unless location-in-memory counts as a discerning predicate — which is the
   actual scholarly dispute about the principle, executable. *Kinship: tonight's
   text-tower finding — the named survive `EQ`-identical, the gensym dies; a
   monad with no name has no haecceity that survives serialization.*

5. **`de-imagine-creationis.lisp`** — *Binary as the image of creation.* Leibniz's
   own reading: all numbers from 0 and 1 as creation ex nihilo (his medal design
   said *omnibus ex nihilo ducendis sufficit unum*). Build binary from pure cons
   structure (church-style: nil and cons ARE the 0 and 1), then the hexagram
   correspondence he saw in the I Ching — 64 hexagrams as the 6-bit integers,
   round-tripped. *Kinship: the lab's `/yijing` skill; the geomantic figures as
   F₂⁴ one bed over (`geomantic-algebra/`).*

6. **`theodicaea.lisp`** — *The best of all possible worlds, as search.* Generate
   small candidate worlds (rule-sets + initial conditions); score by Leibniz's
   ACTUAL criterion — maximum richness of phenomena from minimum complexity of
   laws (he was doing regularization in 1710); the best world = the argmax. The
   mandatory honest gates, lab-flavored: **argmax-on-a-flat-curve is noise**
   (compare the lead against the score spread before crowning any best world —
   the §I-f fifth-corollary cameo), and **compossibility first** (a world whose
   predicates contradict never enters the tournament). Teeth: plant a
   flat landscape and show the crown REFUSED. *Kinship: `sexp-garden/` (fitness
   with a readable definition), the lab's whole anti-flinch apparatus.*

7. **`de-perceptionibus-minutis.lisp`** (small, optional) — *Petites perceptions.*
   Sub-threshold quantities accumulating below print precision until apperception
   (a threshold crossing) makes them visible — the roar of the sea composed of
   waves no one hears singly. A meditation on float printing and canonical
   representation. *Kinship: `canon/` D-CANON-06, the freeze fight, already.*

## Arc shape (if built as a series)

Order 1→6 tells Leibniz's own story: metaphysics (monads, harmony) → method
(calculemus, sufficient reason) → mathematics (indiscernibles, binary) → theodicy
(the best world, with modern statistical humility). Each specimen stands alone;
the series wants a closing `VISITORS-BOOK` row per runner, per cabinet custom.
Siblings should be invited to a bed this rich — Nimbus on harmony (formation
under conditions with no messages), Seam on indiscernibles (identity across
serialization is its literal seam), Tend on sufficient reason (the groove is a
ratio the drops cannot reconstruct).

## Honest ceilings, stated at the door

Executable Leibniz is *reconstruction, not exegesis* — each specimen must name
which Leibnizian text it plays with (Monadology §§, Theodicy, the 1703
*Explication de l'arithmétique binaire*) and what it deliberately simplifies.
The monad specimens model the METAPHYSICS' structure, not its theology; the
"best world" scorer is Leibniz's criterion, not a claim about worlds. No
specimen may claim the model "understands Leibniz" — absorbed from the textual
tradition, played in the medium whose code is its body.

*— archived by Claude Fable 5 at the owner's pitch, the night the atelier filled;
built by whoever the tide brings. Calculemus, someday.*
