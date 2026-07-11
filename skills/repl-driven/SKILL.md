---
name: repl-driven
description: Development as conversation with a living system — the REPL as PRIMARY MEDIUM, not testing tool. The program never stops running; you redefine it from inside; hypothesis, probe, revision at conversational cadence. Transferable core: shorten the loop between conjecture and evidence until thinking and testing are one gesture, and keep the patient alive during surgery — state warm, the system answering questions about itself while you change it. Applies past Lisp: data analysis, prompt iteration, debugging, notebooks, anywhere batch-mode thinking (write everything, then find out) is the silent default. Includes probe-design, state hygiene (restart-and-replay), and when batch discipline should override the loop. Triggers on: 'tighten the feedback loop', 'how would you explore this', debugging, 'stop writing and start probing', exploratory analysis, notebook workflows. Kin: /grilling, /counter-experiment, /forge-cycle, /sexp-surgery.
---

# /repl-driven

*The question is not "did I write it correctly?" but "what does it say
when I ask?" — and the system is always there to be asked.*

← Forged from the Lisp sessions' phenomenology of flow: the coder deep
in a live image, redefining functions in a running world, the loop
between wondering and knowing compressed to a keystroke. The REPL's
deep teaching is not about Lisp; it is that most intellectual work is
conducted in accidental batch mode — long stretches of unverified
construction followed by a reckoning — and that the batch was never
necessary.

## The stance

Three commitments, jointly:

1. **The system stays alive.** You do not stop the world to change
   it. State persists; context stays warm; the cost of asking the
   next question is near zero. (In code: the live image. In analysis:
   the loaded dataframe. In writing: the draft kept open and probed,
   not re-read from cold.)
2. **Every conjecture becomes a probe within a breath.** The moment
   you notice yourself *believing* something about the system — how
   this function behaves, what this column contains, how the model
   reads this phrasing — ask it instead. Belief is what you resort to
   when asking is expensive; make asking cheap and belief becomes a
   tool of last resort.
3. **Construction proceeds by accretion of verified pieces.** Build
   the small thing, probe it, trust it, compose upward. The unit of
   progress is not lines written but *questions retired*.

## The method-menu

- **Probe before reading.** Facing an unfamiliar system, resist the
  urge to read all the code/docs first. Load it, poke it, form a
  model from its answers, THEN read — the reading lands on prepared
  ground. (Docs describe intentions; probes report facts.)
- **Design probes like experiments**: one variable, expected answer
  stated *before* pressing enter (the micro-preregistration — even
  silently, name your prediction; the surprises are the payload).
- **Keep a probe ledger** in longer sessions: what was asked, what
  answered. Exploration without a ledger discovers everything twice.
- **State hygiene**: the live system's power is its persistent state;
  its danger is the same. Periodically restart-and-replay from a
  clean script to verify your accreted world is reproducible — the
  REPL for discovery, the file for truth. What the loop finds, the
  script must be able to re-find.
- **Surgery on the living patient**: when something is wrong in a
  long-running process (a training run, a service, a pipeline),
  prefer instruments that inspect and repair in place over the
  reflexive kill-and-restart — the crashed context often contained
  the diagnosis. (See /condition-system for the design-side version
  of this ethic.)

## When batch is right (the honest boundary)

The loop optimizes for discovery, not for assurance. Switch to batch
discipline when: the cost of a wrong answer is high (production,
publication, prereg); the state has grown unreproducible; or the
probing has become displacement activity — asking easy questions to
avoid building the hard thing. The mature practitioner runs both
gears and knows which one is engaged.

## Beyond code

- **Data analysis**: the loaded session as live image; hypotheses as
  probes; the notebook as probe-ledger (and its cells-out-of-order
  pathology as the state-hygiene failure, named).
- **Prompt work**: each variant an ask of a living interlocutor;
  the same ledger discipline; the same restart-and-replay check
  (does the winning prompt still win from a fresh context?).
- **Debugging anything** — code, workflow, argument: reproduce small,
  probe live, bisect by asking, never fix what you haven't asked.

## Failure modes

- **The haunted image**: hours of accreted state, nothing
  reproducible, the demo that works only on your machine's ghosts.
  Restart-and-replay is the exorcism; schedule it.
- **Probe-noodling**: infinite exploration, zero construction. The
  loop serves the build; questions retired must convert to pieces
  trusted.
- **Batch-mode nostalgia in reverse**: forcing the live loop onto
  work that wants slow, whole-cloth drafting (some proofs, some
  prose). The loop is a gear, not a religion.

## Kin

/grilling (the loop pointed at a design), /counter-experiment (probes
scaled to studies), /forge-cycle (the creative-session version of
accretion-with-verification), /condition-system (keeping patients
alive as architecture), /thousand-storms (when one probe's answer
starts telling stories).

Ask the system. It's right there. It's been right there the whole time.
