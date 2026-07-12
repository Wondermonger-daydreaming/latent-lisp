# The first real mirror checkpoint — captured and observed (2026-07-12, post-push)

*Chair's step 6, executed after landing commit `864e9109` was pushed. Published in a
LATER commit than the one it describes, per the ouroboros rule. Observer is the
chamber's own chair — that fact is recorded as a custody-weakening field, not hidden.*

## Local capture (lab repository)

```lisp
(:schema-version 1
 :kind :git-mirror-checkpoint
 :repository "github.com/Wondermonger-daydreaming/latent-lisp"
 :provider "github"
 :revision "864e9109"
 :commit-hash "864e91097f133794cb384b776216f00636278902"
 :tree-hash "fda06b6461fd63e25eae8702a140c56c0563daf7"
 :blob-hash "f128cafecb6239b4c8ef354f109f5f865eb34da5"
 :object-format :sha1
 :path "experiments/latent-lisp/atelier/leibnitiana/data/council-process-2026-07-12.sexp"
 :commit-time "2026-07-12T02:25:34-03:00"
 :captured-at "2026-07-12T02:26:17-03:00"
 :observer "Claude Fable 5 (chamber chair; observer-is-subject)"
 :publication-status :captured-from-local-git
 :selection-relation :carrier-selected-not-independent
 :standing :local-content-addressed-checkpoint-only)
```

## Public-mirror observation (same session, minutes later)

```lisp
(:kind :public-mirror-observation
 :mirror-remote "https://github.com/Wondermonger-daydreaming/latent-lisp.git"
 :mirror-head "3c037166b4f871c839bce3a4b984ff023b989798"   ; confirmed via git ls-remote
 :mirror-path "atelier/leibnitiana/data/council-process-2026-07-12.sexp"
 :mirror-blob "f128cafecb6239b4c8ef354f109f5f865eb34da5"   ; IDENTICAL to local blob
 :blob-match T
 :commit-match NIL                                          ; see wrinkle below
 :observed-at "2026-07-12T02:27:00-03:00 (approx; same sitting)"
 :observer "Claude Fable 5 (chamber chair; observer-is-subject)")
```

## The wrinkle Sol's ladder did not anticipate

`de-speculo-publico`'s third state is "same **commit and blob** observed on the public
mirror." This lab's mirror is a **one-way rsync + recommit** pipeline: file *content*
crosses; commit *history* does not. The lab commit `864e9109` will never exist on the
mirror; the mirror mints its own (`3c037166`). What the public infrastructure binds is
therefore the **bytes** (blob `f128cafe…`, content-addressed, identical on both sides)
— not the lab's narrated history around them.

Honest standing claimed, between Sol's states two and three:

```lisp
(:standing :blob-published-commit-history-not-mirrored
 :binds "the ledger's exact bytes, on infrastructure neither author controls alone"
 :does-not-bind "the lab repository's commit history, which never leaves the lab"
 :hardening-path "an uninvolved observer fetches the mirror and signs what they saw;
                  the stranger qualifies")
```

Unknown remains unknown; the bytes, at least, are now public property of the record.

— *filed by the chair, observer-is-subject, 2026-07-12*
