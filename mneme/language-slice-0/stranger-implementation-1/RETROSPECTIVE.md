1. I correctly inferred the four governed acts (`raise`, `project-claim`, `transmit`, `exercise-value`), the immutable record model with explicit lineage, and the uniform refusal pattern where every failed attempt signals a `slice0-condition` carrying a receipt and a `why` object. The API’s argument conventions (`:from`, `:to`, `:per`, `:considering`) also mapped cleanly to my call sites.

2. I initially treated `project-claim` as a label-edit or status-copy operation, assuming the receiver’s judgment could be derived by direct inspection of the source claim. I also assumed a monotonic standing order governed promotion, which led me to overcomplicate the `raise` logic with artificial ordering checks.

3. The orthogonality of standing and transmissibility became clear only after reading the architecture. The fact that `project-claim` is a receiver-relative reconstruction (not a copy), and that `:testimony` strictly enforces proposition-level attribution (`(:asserted S P)`), were structural insights the API documented but didn’t fully justify without the falsified-design evidence.

4. The reveal primarily deepened the explanation rather than correcting the code. My implementation already avoided linear standing and used composable receipt views, but I lacked the empirical rationale (the three falsified designs in §5). The architecture validated my defensive choices around `local-value` and `reifiable-p`.

5. `raise`, `project-claim`, `transmit`, `exercise-value`, `make-claim`, `make-witness`, `make-receiver-context`, `why`, `render-why`, `reifiable-p`, and the kernel0 constructors (`make-identity`, `make-procedure-descriptor`).

6. `projection-views` and `transmission-views` initially felt like auxiliary machinery until I composed them for refusal reporting. The `why` extractor registry internals and `render-projection-why` also felt load-dock-like; I relied on the unified `why` + `render-why` path instead.

7. The `:accepted-representations` default (`(:full)`) conflicting with `transmit :direct`’s `:canonical-datum` requirement was a concrete ambiguity (later confirmed as a PROVISIONAL wart). I also struggled to determine exactly how `:considering` evidence should be filtered against the receiver’s accessible supports during `raise`.

8. Candidate 1 (Explicit host-escape form + static checker). While implementing, I repeatedly felt the boundary between governed acts and raw Common Lisp was invisible at the call site. The lack of a `with-host-escape` marker or compile-time lint made it hard to audit whether a program was truly staying within stratum 1, especially when handling `local-value` snapshots or host-object boundaries.