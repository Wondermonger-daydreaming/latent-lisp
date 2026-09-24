# CEILING ATTAINED — a gate with partially independent computations, and a plant that explains its wound (r2)

*Atelier piece, born 2026-09-16 from Shannon sitting 11 (`corpus/readings/shannon/sittings/2026-09-16-sitting-11-justifying-the-assumed-solution.md`) and the owner's pick from the Appendix Committee's pitch desk. **r1 the same evening**, after the review of parcel `ed346f74…` (docked: `corpus/voices/received/originals/2026-09-16-shannon-atelier-play-review.md`). Claude Fable 5.1, session Only What It Read. CANDIDATE; a toy; nothing adopted, nothing published.*

```
sbcl --script atelier/ceiling-attained/ceiling.lisp            # gate:  ceiling-attained: 15 checks, 0 failures
sbcl --script atelier/ceiling-attained/ceiling.lisp --plant    # teeth: ceiling-attained: 15 checks, 0 failures
sbcl --script atelier/ceiling-attained/ceiling.lisp --transient # r2: the chain started OFF stationarity — 4 checks, 0 failures
```

## The page

Appendix 4 (pp. 30–31) **assumes** a form — *"Evidently for a maximum $p^{(s)}_{ij}=k\exp\ell^{(s)}_{ij}$"* — works the multipliers to $p_{ij}=\frac{B_j}{B_i}C^{-\ell_{ij}}$, computes the rate, finds it equal to $C$, and closes: *"Hence the rate is C and as this could never be exceeded this is the maximum, justifying the assumed solution."* The maximum is shown by **attaining a ceiling established elsewhere** — Theorem 1 / Appendix 1: $C=\log W$, $W$ the largest real root of $|\sum_s W^{-b^{(s)}_{ij}}-\delta_{ij}|=0$, equivalently the growth rate of the exact block count. The piece makes that grammar executable.

## The three routes — and their independence, at its honest size

| Route | Page | What it computes | How |
|---|---|---|---|
| **A1** | App. 1 recurrence | $C$ from the **exact count** | bignum $N_j(L)$; $W=(N(400)/N(360))^{1/40}$ |
| **A2** | Thm 1 / App. 1 determinant | the **largest real root** of $D(W)=\det(M(W)-I)$ | scan $W\in(1,64]$ step $10^{-3}$ for the last sign change, bisect |
| **B** | App. 4 construction | the **entropy rate** of the constructed chain | $W^*$ with Perron eigenvalue of $M(W^*)=1$; $B$; $p^*_e=\frac{B_j}{B_i}W^{*-\ell}$; stationary $P$; rate $=\frac{-\sum P_ip_e\log_2 p_e}{\sum P_ip_e\ell_e}$ |

**CLOSED iff** $|C_{A1}-C_{A2}|<\delta$ and $|\text{rate}_B-C_{A1}|<\delta$, $\delta=10^{-6}$ bits frozen in source.

**Independence (review, Q1):** A1 is the **principal combinatorial witness** — the only route that never builds $M(W)$. A2 and B are *partially independent numerical cross-checks*: the determinant's largest real root and the Perron eigenvalue 1 describe the **same spectral event** on these graphs; what B adds is that the construction, the stationary law and the entropy calculation work together to reach A1 — indeed $-\log_2 p^*_e=\ell_e\log_2W+\log_2B_i-\log_2B_j$, so B's rate reaching $C$ is the cancellation of the $B$ terms under the stationary law. The comparison rule already centres A1; r1 changed the language, not the rule.

**Scope of A2 (review, Q4):** a finite sign-change scan does not certify it found the *largest* root — a root outside $(1,64]$, or one without a sign change, is not seen. The gate prints this scope line on every run.

**Stability, not a bound (review, Q4):** the gate prints $|A1(L{=}400)-A1(L{=}800)|$ and names it *observed stability, not an error bound* — two finite estimates can agree while sharing a bias. On these four graphs it is below the printed $10^{-9}$ (the reviewer's independent recomputation: $\approx8\times10^{-14}$ on the unequal-length graph). A certified interval would be a later, mathematical piece.

## The four graphs and their anchors — external numerical references at their stated precision

| Graph | A1 = A2 = B | anchor |
|---|---|---|
| unconstrained binary (two edges of length 1) | 1.000000000 | **arithmetic:** $C=1$ |
| **telegraph, Fig. 2 p. 4** (dot 2, dash 4, letter space 3, word space 6; no two spaces in a row) | 0.538936052 | **the page:** *"Solving this we find C = 0.539"* (p. 4) — checked at his three decimals ($|\text{diff}|=6.4\times10^{-5}$); it cannot certify six decimals or implementation correctness |
| two states, unequal lengths (1, 2, 3, 5) | 0.405685231 | none |
| **golden ratio** — all lengths 1, adjacency $\begin{pmatrix}1&1\\1&0\end{pmatrix}$ (r1, the reviewer's counterexample) | 0.694241914 | **arithmetic:** $C=\log_2\varphi$ |

(r0's README called the page anchor "the only witness this code did not produce"; it overlooked the binary source's $C=1$, which is also external. Corrected.)

## The planted control, and the plant that explains its own wound

`--plant` runs a **wrong** stationary policy $q$ — the maximizer's weights with the first edge of each state doubled, renormalised — and checks it **falls short**: 0.082 / 0.030 / 0.033 / 0.056 bits on the four graphs.

**Degeneracy, corrected (review, Q3).** r0's README claimed that equal outgoing lengths make the maximizer uniform, so a length-only plant is degenerate wherever a state's edges share one length. **That is false in general** — equal lengths make a *length-only* distribution uniform within a row, but the maximizer keeps the destination factor $B_j/B_i$. The reviewer's counterexample is now the fourth graph: all lengths 1, and the maximizer from state 0 is $(1/\varphi,\,1/\varphi^2)=(0.618,\,0.382)$, printed on the `p*` line of the plant transcript. The statement was right only for the one-state binary graph. The gate now carries the **diagnostic that matters**: `max|q_e − p*_e|` over states with stationary mass; if it vanishes, the check reads *CONTROL DID NOT PERTURB THE OPTIMUM — degenerate control*, reported and never counted as a bite.

**The gap has a measure (the reviewer's next piece, done tonight).** For a stationary alternative $q$, the same logarithmic cancellation gives
$$C-R(q)=\frac{\sum_i\pi_i\,D_{\mathrm{KL}}(q_i\Vert p^*_i)}{\sum_i\pi_i\sum_{e:i\to j}q_e\ell_e}.$$
The plant computes both sides and checks them within $\delta$: on all four graphs the shortfall **equals** the average divergence from the maximizing choices per unit duration, to $10^{-9}$ (`plant-r1-2026-09-16.txt`). The wrong distribution falls short by exactly how far it is from the right one.

Preserved: `runs/plant-attempt-1-DEGENERATE-2026-09-16.txt` (the first plant, $p\propto W^{-2\ell}$, coinciding with the maximizer on the binary graph); `runs/ceiling-r0-2026-09-16.lisp.txt` (the r0 source); `runs/gate-2026-09-16.txt`, `plant-2026-09-16.txt` (r0 transcripts); `runs/gate-r1-*`, `plant-r1-*` (r1); `runs/ceiling-r1-2026-09-16.lisp.txt` (the r1 source); `runs/{gate,plant,transient}-r2-*` (r2).

## r2 — the reviewer's optional play: start the chain away from stationarity

*Accepted 2026-09-16 (`corpus/voices/received/originals/2026-09-16-shannon-atelier-play-r1-acceptance.md`, sha `298b2631…`): "I'd let both pieces stand as atelier work." Independent recomputation of the four KL gaps agreed to floating-point precision — "not certified arithmetic; it does confirm the new computation independently." Three editorial scraps named and now cleaned (the header's "two independent", the old degeneracy comment, the README's "two anchors"). And one optional play, taken.*

Off stationarity the cancellation that made the KL identity exact becomes an **endpoint term**. Along any finite path the $\log B$ contributions telescope: $\sum_t(\log_2B_{i_t}-\log_2B_{i_{t+1}})=\log_2B_{i_0}-\log_2B_{i_n}$. So, starting from a delta at state 0 and stepping the planted chain $q$ for $n$ transitions (distributions propagated exactly, no sampling),
$$S_n=\sum_{t<n}\mathbb Eig[\log_2	frac{q}{p^*}ig]=C\,L_n-H_n+ig(\log_2B_0-\mathbb E[\log_2B_{i_n}]ig),$$
an identity the gate checks for $n\in\{1,2,5,20,100\}$ on every graph, within $\delta$ (`runs/transient-r2-2026-09-16.txt`, 4/4). What remains at the two ends (`endpoint`), and how it dissolves into the rate (`S_n/L_n → C−R(q)`):

| Graph | endpoint at $n=1$ | endpoint at $n=100$ | $S_n/L_n$ at $n=100$ | stationary $C-R(q)$ |
|---|---:|---:|---:|---:|
| binary | 0 | 0 | 0.081704166 | 0.081704166 |
| telegraph | −0.518402777 | −0.430272374 | 0.030447195 | 0.030483308 |
| unequal lengths | 0 | 0 | 0.032499775 | 0.032505345 |
| golden ratio | +0.163888284 | +0.132588407 | 0.056488160 | 0.056380482 |

Two of the four endpoints are **exactly zero** — the binary graph trivially (one state), and the unequal-lengths graph because its $B_0=B_1$: with $W$ the plastic number ($W^3=W+1$, $Wpprox1.3247$) the fixed-point row gives $B_0(1-W^{-5})=B_1W^{-1}$ and $1-W^{-5}=W^{-1}$ exactly. Observed and checked by hand from the printed values; a pleasant accident of that graph, not a theorem of the piece. On the other two the endpoint is bounded ($|\log_2 B_i-\log_2 B_j|$ at most) and its share per step vanishes as $1/n$, which is the whole content of "before the long-run rate settles."

## What closed (the ceiling sentence)

*On the four supplied graphs, the specified numerical comparisons — A1 against A2, and Appendix 4's constructed entropy rate against A1 — agree within the frozen tolerance $\delta=10^{-6}$ bits; the anchors of known value (three of the four graphs) match at their stated precision; on each graph a skewed stationary policy falls short of $C$ by exactly its mean divergence from the maximizer per unit duration, within $\delta$.* Nothing wider: not Shannon's theorem, not a certified error bound, not the largest root beyond the scanned interval.

## Lineage

Kin: the Garden's *rightness is reachable exactly when it is measurable*; the orchard's integrity quine. The house rule it runs: **an assumed form is licensed only by attaining a ceiling computed another way** — and now its converse, from the review: *when the form is wrong, the shortfall is the divergence.* `RECEPTION-2026-09-16.md` points to the review.
