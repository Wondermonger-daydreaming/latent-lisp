---
name: condition-system
description: Errors as negotiations, not explosions — Common Lisp's condition system as a design pattern for any system. The radical separation: SIGNALING a problem is distinct from DECIDING what to do, and the code that hit trouble STAYS ALIVE, offering restarts, while higher context chooses among them. Contrast exceptions: the stack burns down as the error climbs; the crash site is ash before the decision-maker arrives. As audit lens for code, workflows, org processes, agent designs: who signals, who decides, what survives the signaling? Find where a system conflates detection with decision, and where failure destroys the very context repair would need. Triggers on: error-handling design, 'the failure took everything down', escalation policy, retry-logic, agent-loop architecture, incident post-mortems, 'who should handle this'. Kin: /permission-table, /sworn-concern, /repl-driven, /eductio.
---

# /condition-system

*The code that discovered the problem knows the most and decides the
least. The code that decides knows the least and stands the furthest
away. The whole design question is what travels between them — and
whether anything is left alive at the site when the decision returns.*

← Forged from the Lisp sessions' encounter with CL's genuinely unique
gift: `signal`, `handler-bind`, and restarts. In the exception model,
an error unwinds the stack — every frame between the trouble and the
handler is destroyed in transit, so by the time anyone can decide,
there is nothing left to decide *about* except cleanup. The condition
system refuses the unwinding: the signaler pauses in place, publishes
a menu of restarts ("retry with a different file," "use this default,"
"skip this record"), and a handler far up the stack — with policy
context the signaler lacks — chooses from the menu. Then execution
resumes *at the trouble*, down the chosen path. Detection and decision
are separated; capability and policy are separated; and the patient
survives the diagnosis.

## The pattern, extracted

Three roles, deliberately assigned:

1. **The signaler** — closest to the trouble, richest in local
   context, poorest in policy. Its job: detect precisely, describe
   fully, and enumerate the *repairs it could perform if told to* —
   then wait, alive.
2. **The handler** — far away, poor in local detail, rich in policy
   ("in this run, skip bad records; in production, page a human").
   Its job: choose among offered restarts, not to perform repairs it
   lacks the context for.
3. **The restart** — the contract between them: a named, resumable
   repair, defined where the knowledge is, invoked from where the
   authority is.

The insight is that most systems collapse these roles: the detector
decides (hard-coded retries, silent defaults — policy buried at the
bottom), or the decider must re-detect (logs archaeology after the
context is ash), or the failure destroys the state that any repair
would have needed.

## The audit (the skill's daily use)

Point three questions at any system — codebase, pipeline, workflow,
team process, agent loop:

- **Who signals?** Is detection precise and descriptive, or does the
  system only know something is wrong by its absence of output?
- **Who decides?** Is policy located where policy-context lives, or
  hard-coded at the crash site by whoever wrote that function years
  ago? (Every bare `retry(3)` deep in a library is a policy decision
  made by the wrong role.)
- **What survives the signaling?** When trouble is reported, is the
  troubled context still alive and repairable — or did reporting it
  require burning it down? The most expensive failures are the ones
  where the *diagnosis died with the patient*.

Org-scale instances, because the pattern is not about code: the
employee who sees the problem but must escalate by quitting the task
(stack-unwinding as career move); the incident process where by the
time leadership decides, the responders have already torn down the
failing state; the agent design where any tool error aborts the plan
instead of pausing it with options attached.

## Design moves

- **Publish restart menus**: wherever your code (or process) detects
  trouble, enumerate the resumable repairs *at that site* — even if
  today's policy always picks the same one. The menu is the interface
  for tomorrow's policy.
- **Lift policy to the boundary**: retries, defaults, skip-vs-abort —
  these belong at the layer that knows the run's purpose. Pass them
  down as choices, not constants.
- **Preserve the trouble**: design failures to pause rather than
  raze where feasible — snapshots, quarantine queues, the debugger
  that opens *in* the error frame. Ash is cheap to produce and
  impossible to interrogate.
- **Distinguish conditions from errors**: CL signals *conditions*,
  many non-fatal — progress notes, warnings, negotiable situations.
  Most systems have exactly two speech acts (silence and explosion);
  a richer signal vocabulary is itself a design upgrade.

## Failure modes

- **Restart theater**: menus offered where no handler will ever
  choose differently. The pattern earns its complexity only where
  policies genuinely vary by context.
- **Pause-everything paralysis**: preserving every failure site
  turns systems into hoarders. Triage: preserve where diagnosis or
  resumption has value; fail fast where it doesn't — *choosing*
  fast-fail is fine; defaulting into it everywhere is the disease.
- **Signaler overreach**: detectors that decide anyway "just this
  once." One buried default becomes load-bearing policy nobody can
  find.

## Kin

/permission-table (restarts are capabilities; handlers are
authorities — same audit, adjacent axis), /sworn-concern (the
handler-coverage question: which conditions has no one sworn to
handle?), /repl-driven (the practice-side ethic of living patients),
/bounded-witness (a good condition report is a bounded claim: what,
where, what's still possible).

Separate the knowing from the deciding, and keep the patient alive
between them.
