# LCI/0 Successor Publication and Remote Read-Back Receipt

Date: 2026-07-14

Status: **three successor branches published non-force and verified by remote
read-back; main not merged or modified.** Overall LCI/0 conformance remains
BLOCKED pending authorial closure.

## Publication boundary

An initial `git ls-remote --heads` returned no existing remote refs for the
three successor branch names. The branches were then created together with one
atomic, non-force push:

```text
git push --atomic origin codex/lci0-common-lisp-successor:refs/heads/codex/lci0-common-lisp-successor codex/lci0-python-successor:refs/heads/codex/lci0-python-successor codex/lci0-integration-successor:refs/heads/codex/lci0-integration-successor
```

| Remote branch | Published/read-back commit |
| --- | --- |
| `codex/lci0-common-lisp-successor` | `2513c354721bac6120b8c0a5eef1ed13252cf75b` |
| `codex/lci0-python-successor` | `db627cb6ca23abc0626aebc6f9982ab9b4406dbf` |
| `codex/lci0-integration-successor` | `05d985bc015f06cd37ca01a7160f98a651a7be9a` |

The Common Lisp and Python tips are the reviewed successor commits. The
integration tip above includes corrected documentation, raw-evidence history,
the reproducible archive, and the archive-covered cleanup lifecycle.

## Remote verification

After the atomic push:

1. `git ls-remote --heads origin` returned each exact object ID above.
2. All three heads were fetched into their corresponding
   `refs/remotes/origin/...` refs.
3. Each fetched remote-tracking ref compared equal to its local branch.
4. Reading the archive blob from the fetched integration ref and hashing it
   produced
   `afad708a44b467c5945679001c0b49b5dbbfc6990e02a6c43d1fb4485b9a15fa`,
   exactly matching the local archive receipt.
5. The same remote census reported `refs/heads/main` at
   `26ac543856e30c340cc2dd4359802442636f4b94`, unchanged from the fetched
   preimplementation main boundary.

This receipt is committed after the content read-back it records and therefore
does not attempt the impossible self-reference of naming its own commit. Its
containing integration commit is pushed non-force and verified separately in
the final handoff; the receipt's factual subject remains the atomic content
publication above.

## Explicit non-actions

- No force push or history rewrite occurred.
- No immutable seed or reviewed successor commit was amended.
- Main was not checked out, merged, or pushed.
- No pull request, merge claim, release tag, production authority object, or
  live migration was created.

Publication makes the implementation and evidence reviewable; it does not
convert any blocked result into a pass. The bounded status remains: unaffected
implementation/evidence ready for independent audit; overall conformance
BLOCKED pending the ten authorial closures; no external reviewer PASS or merge
eligibility claim.
