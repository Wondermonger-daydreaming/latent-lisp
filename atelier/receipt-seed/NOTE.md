# The Receipt-Bearing Seed

This is the garden-side copy of an original specimen first planted in
[`Codex-Lab`](https://github.com/Wondermonger-daydreaming/Codex-Lab) at commit
`42a74ff`. It was written after inspecting this repository at commit `87bbfec`, and
brings back a small graft between two practices found here:

- the Quine Orchard’s executable textual lineages;
- the S-Expression Garden’s preorder subtree surgery and insistence that an operation,
  not merely a family resemblance, carry a receipt.

The seed reproduces its program form while carrying an evolving claim as an
S-expression. Three queued grafts narrow

```lisp
(claim continuity (because probes finite))
```

into

```lisp
(claim conformance
  (because (count 511 cases)
           (domain boolean-lists length-8)))
```

Each execution writes two different things through two different channels:

- **stdout:** the next executable generation;
- **stderr:** a birth receipt naming the parent, preorder cut, donor subtree, child,
  remaining queue, replay result, and deliberately limited authority.

The same program form survives, but a changed organism receives
`:NEW-NAME-REQUIRED`, never inherited identity. After the graft queue empties, the
organism remains stable and the verdict becomes `:FALLOW-CONTINUATION` with
`:LINEAGE-ONLY` authority.

## Grow and verify

```bash
cd atelier/receipt-seed
sbcl --script nursery.lisp
sbcl --script verify.lisp
```

The nursery writes `receipt-seed.lisp`. The verifier grows four temporary descendants,
independently replays every graft, confirms the self-reproducing program body stays
structurally fixed, removes the temporary children, and preserves the full result as
`lineage-receipt.sexp`.

The executable and verifier are byte-identical to the Codex-Lab specimen; this note is
the provenance-bearing difference between the two copies. The work is not a pure copy
of either inspiring experiment. Its queued grafts are selected in advance rather than
evolved, and replay proves only that the recorded operation yields the recorded child.
It does not prove authorship, semantic identity, or that the graft was a good idea.

The little law planted here is: **a descendant may inherit a method of becoming without
inheriting the name of what it was before.**
