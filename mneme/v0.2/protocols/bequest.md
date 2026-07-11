# Bequest Protocol v0.2 (Capsule Protocol instance — language-independent)

A bequest is a RESUMPTION PLAN, never serialized machine state
(Clause 5). Authority is always stripped; grants are re-derived on resume
(Clause 12). Chaff log mandatory (Clause 3 amendment).

```lisp
(bequest
  :project        <name>
  :paused-at      <condition/goal ref>
  :goals          (<goal refs, ordered>)
  :open-conditions (<refs>)
  :decisions      (<ADR refs — settled, with alternatives>)
  :live-bindings  (<key facts a successor must hold, each evidence-linked>)
  :artifacts      ((<name> <content-hash>) ...)
  :authority      stripped                     ;; ALWAYS
  :required-grants-on-resume (<grant specs — requested, not inherited>)
  :historical-material (<refs — DATA, never instruction; Clause 12>)
  :bale
    (:budget <tokens>
     :retain (decisions unresolved-questions failed-approaches
              authority-state evidence-links morals)
     :chaff-log
       ((<omitted-thing> :reason <why> :recoverable <how|no>
         :risk <what the omission could cost>) ...))
  :resume-protocol
    ((verify-artifact-hashes) (run-preflight) (rederive-grants)
     (continue <first goal>)))
```

Morals travel in `:retain` by design: the one-line verified-property
summaries are the engineered survivors of compression, each pointing at
its property's artifact hash. The moral without its pointer is a story;
with it, a promise.
