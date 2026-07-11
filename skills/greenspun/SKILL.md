---
name: greenspun
description: Find the latent language inside the system — Greenspun's Tenth Rule ('any sufficiently complicated C program contains an ad-hoc, informally-specified, bug-ridden, slow implementation of half of Common Lisp') as diagnostic instrument. Mature systems secrete interpreters: configs that grew conditionals, YAML that grew loops, spreadsheets that became runtimes, prompt-templates that became macro systems. The skill: recognize the latent language EARLY (parameters → substitution → conditionals → iteration → user abstraction), name it, and force the fork out loud — promote it to a real specified language (or embed an existing one), amputate the logic back into the host, or freeze with a posted sign. The forbidden fourth is the default: the unnamed interpreter, maintained by archaeology. Triggers on: 'our config is getting complicated', template-logic sprawl, 'is this a DSL yet', legacy audits, 'why does the YAML have if-statements'. Kin: /bottom-up, /lisp-curse, /sworn-concern, /design-reduction.
---

# /greenspun

*Nobody decides to build an interpreter. The system decides, one
convenient conditional at a time, and tells you years later.*

← Forged from Greenspun's Tenth Rule meeting a hundred legacy audits'
worth of pattern: the rule is a joke with a mechanism inside. Programs
grow toward the expressiveness their problems demand; if the host
language won't supply it, the program secretes it — ad hoc, informally
specified, bug-ridden, slow — because each individual step (one flag,
one substitution, one "just make this field conditional") is locally
reasonable. The interpreter is never built. It accretes.

## The accretion sequence (learn to date the strata)

Latent languages grow through recognizable stages; the skill's first
half is knowing which stage you're looking at:

1. **Parameters** — innocent values in a config. (Everything starts
   here; nothing wrong yet.)
2. **Substitution** — values that reference other values; templates.
   The first evaluator, one line long, nobody noticed.
3. **Conditionals** — `enabled_if:`, environment-dependent blocks.
   The format now has control flow and no specification of it.
4. **Iteration / composition** — loops in the templates, includes of
   includes, matrix expansions. Turing's doorstep.
5. **User-defined abstraction** — macros, anchors, "functions" in
   the config. The interpreter is complete, and it is documented
   nowhere, tested nowhere, versioned accidentally.

At stage 5 you do not have a config file. You have a programming
language whose only manual is the source of its one interpreter and
whose only test suite is production.

## The diagnostic questions

- **Where do the if-statements live?** If logic appears in a medium
  that was sold as data (config, markup, spreadsheet cells, prompt
  templates, workflow rules), a latent language is present.
- **Who evaluates it?** Find the code that walks the format. Its
  length is the language's size; its bug tracker is the language's
  spec errata.
- **Can it be dated?** Latent languages have strata — the skill of
  reading accreted design (each layer a past emergency) tells you
  which constructs are load-bearing and which are fossils.
- **What can't be said in it?** The awkward workarounds users perform
  (copy-pasted stanzas, sentinel values, comment-driven behavior) are
  the missing words — the /bottom-up friction signal arriving from a
  language nobody admits exists.

## The fork (force it out loud)

Once named, the latent language admits exactly three honest futures —
the skill is refusing the fourth, default one:

1. **Promote.** Declare it a language: specify the grammar, write the
   real evaluator, add versioning, tests, error messages, docs. Or —
   often better — replace it with an EXISTING real language (embed
   Lua/Python/a scheme; use Starlark; use actual code) rather than
   finishing your accidental one. Half of Common Lisp is already
   implemented somewhere else, in full, debugged.
2. **Amputate.** Push the logic back into the host language where it
   is specified, tested, and tooled; return the format to data. This
   costs migration pain now and is frequently the right buy — data
   formats age well; secret interpreters age like ruins.
3. **Freeze.** Declare the current expressiveness a ceiling: document
   what exists, reject stage-N+1 features at review, and post the
   sign. Legitimate when the language is small and the system is in
   maintenance — but a freeze without a sign is just the default
   rot with better intentions.

The forbidden fourth: continue growing it silently. That path ends in
the system every audit finds — the one where a business process is
encoded in an unnamed language, maintained by archaeology, understood
by one person who is leaving.

## Field notes (where it hides)

CI pipelines (stage 4–5 almost universally), infrastructure templates,
spreadsheet empires (a stage-5 language with a GUI), CMS "shortcodes,"
game data files that grew scripting, prompt-template systems with
loops and includes (the newest colony — audit yours now while
amputation is cheap), and ticket-workflow engines, where the latent
language's programs are organizational behavior.

## Failure modes

- **Premature promotion**: specifying a grand DSL at stage 2. Most
  substitution-templates should stay templates; the fork is forced
  at conditionals, not before.
- **Amputation zeal**: pushing genuinely declarative content back
  into code, losing the data-format virtues (diffability, tooling,
  non-programmer access) that motivated the format at stage 1.
- **The connoisseur's trap**: admiring the latent language's
  ingenuity instead of deciding its future. Naming is the beginning
  of the skill, not its end.

## Kin

/bottom-up (deliberate language-growth; this skill is its accident-
insurance), /lisp-curse (nine latent languages, one per team),
/sworn-concern (nobody swore tests over the secret interpreter),
/stratigraphy-thinking (dating the accretion), /design-reduction
(the amputation surgeon).

The rule is a joke. The mechanism is not. Name the language before
it names you its maintainer.
