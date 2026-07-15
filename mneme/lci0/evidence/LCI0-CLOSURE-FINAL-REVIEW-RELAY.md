# LCI/0 Closure — Final Review Relay (paste-ready charge for a fresh independent reviewer)

Date: 2026-07-15
From: INTEGRATOR (Claude Fable 5)
Status: implementation-side closure COMPLETE and verified by the implementing
hands; this relay commissions the INDEPENDENT review. You owe nobody
agreement — every claim below is re-derivable from the repo and the
commands in §4.

---

## 1. Exact objects under review

Repository: the shared latent-lisp worktree family (Codex-Lab). Review
worktree: `/home/gauss/Codex-Lab/latent-lisp-lci0-integration-successor`
(or any fresh worktree of the same repo — do NOT check out a branch that is
checked out elsewhere; make a detached worktree if needed).

| Branch | Commit | Tree | Role |
|---|---|---|---|
| `codex/lci0-integration-successor` | `3693799fcd03b860dad85561382113593fcfe18b` | `d3fb045ecd031c2ffd4d5a75fd313e5cefae6639` | integration base (pre-closure) |
| `codex/lci0-common-lisp-closure` | `a6605403904406d3176f39433416d5a93e6427ee` | `96f5cccaa06e67f78558c20afbe094ea15c85f84` | CL forge (5 commits atop `2513c354`) |
| `codex/lci0-python-closure` | `dda8195a1e9dec25e870763eeaf78222c962e412` | `8226d260150474bd6310492b0698f126c340dd12` | Py forge (5 commits atop `db627cb6`) |
| `codex/lci0-integration-closure` | *branch tip — read with `git rev-parse`* | — | the integrated closure (under review) |

Integration-branch commit structure (verify with `git log --graph`):
merge of CL forge (`9502dbab`), merge of Py forge (`eebe6ed1`), harness
census-flip commit (`89ecfc62`), divergence-ledger addendum (`64a97e5e`),
then the evidence-receipts commit(s) at the tip. No pre-existing commit
rewritten; both forge heads must appear as ancestors, unmodified.

Normative authorities (read-only):
`_staging/lci0-closure-reverify/packet-extract/` (RULING, REGISTER,
VECTORS, PLAIN-ANSWERS) and fixture overlay 0.2
(`mneme/lci0/fixtures/archives/lci0-fixture-overlay-0.2-2026-07-14.zip`,
SHA-256 `5e03c2f5a17cf69f9b562dcfc5b7dfde85563fc7f88d52fcb01ffe858c1a10eb`).
Baseline RED evidence:
`_staging/lci0-closure-reverify/phase2/baseline/BASELINE-REPORT.md`.

## 2. What to verify (the claims)

1. **Merge integrity**: both forge heads are unmodified ancestors of the
   tip; the overlay zip in-tree hashes `5e03c2f5…`; `canonical-datum/`
   subtree object equals the bases' (`ce6e41deca3fe237ff6d0edafa2666d098ae62e8`);
   the 0.1 fixture archive blob equals the bases'
   (`dcaaa3ebd40ee505950ef5ea8215e18607d33271`).
2. **Census flip**: `mneme/lci0/differential/authorial_blockers.py` has
   empty blocker sets, all-passed counts (215/458/29/1593, sum 4590), and
   imports cleanly.
3. **Full convergence**: a fresh differential run reports
   `converged-authorial-closures-complete`, `authorial_return_required`
   false, 0 mismatches in each implementation, 0 cross-implementation
   mismatches, 2295 requests per implementation.
4. **Language batteries green** (commands in §4): CL 85/0/10-blocked +
   closure 50/50 + regressions 12/12 + pre-seed 15/15; vectors 215/215;
   corpus 1593; all four perturbation profiles 215/215; CD/0 CL exit 0.
   Python 110 tests OK (and under PYTHONHASHSEED 0/1/random); CD/0 Python
   167 OK.
5. **Post-convergence**: seed 1279478064, 329 cases, 6 adapter profiles,
   status `pass` (NOTE: its fixture root is PINNED in code to
   `/tmp/lci0-seed-fixtures-20260714` and that root must carry the
   additively materialized overlay — §4 step 0).
6. **Ledger integrity**: `LCI0-IMPLEMENTATION-DIVERGENCES.md` — the first
   1 135 lines are byte-identical to the pre-closure version (git history
   of the file), with only the 2026-07-15 closure addendum appended.
7. **Receipts internally consistent**: every number in
   `LCI0-CLOSURE-*-RECEIPT.md` / `LCI0-CLOSURE-IMPLEMENTATION-LEDGER.md`
   matches what your own runs produce.
8. **Non-regression boundary**: per
   `LCI0-CLOSURE-NONREGRESSION-RECEIPT.md` — protected hashes, the
   211/420/21 prior determinate results, zero live warrants (re-run the
   scan or your own equivalent).

## 3. What would BLOCK (fail the review loudly on any of these)

- Any forge branch commit rewritten/rebased, or either forge head not an
  ancestor of the tip.
- Overlay zip hash ≠ `5e03c2f5…`, or 0.1 archive/materialized member
  hashes changed.
- Any differential mismatch, any nonzero blocked count, any
  cross-implementation mismatch, or request count ≠ 2295/impl.
- Any suite red: CL unit failures ≠ 0, vectors < 215/215, perturbation
  < 215/215, Python suite failures, CD/0 failures, post-convergence
  status ≠ pass (with the overlay-bearing pinned root).
- Ledger history modified above the addendum line.
- A live-warrant coordinate ≠ false/0 anywhere, or a restoration vector
  not refused.
- Any new CL-vs-Python disagreement on a surface outside the 50 closed
  ones (that would be an ELEVENTH question — report it, do not adjudicate).
- Evidence archive not byte-reproducible (two builds differing).

## 4. How to run everything (exact commands; from the worktree root)

```sh
# 0. Fixture root (fresh) + the PINNED post-convergence root
python3 mneme/lci0/shared/fixture_package.py materialize --destination /tmp/lci0-review-fixtures
python3 mneme/lci0/shared/fixture_package.py materialize-overlay --fixture-root /tmp/lci0-review-fixtures
#    post_convergence pins /tmp/lci0-seed-fixtures-20260714 in code; ensure it exists
#    with the SAME two 0.1 member hashes plus the additively materialized overlay
#    (materialize + materialize-overlay to that exact path if absent).
export LCI0_FIXTURE_ROOT=/tmp/lci0-review-fixtures LCI0_FIXTURE_DIR=/tmp/lci0-review-fixtures

# 1. Common Lisp battery
sbcl --noinform --disable-debugger --script mneme/lci0/common-lisp/run-tests.lisp
sbcl --noinform --disable-debugger --script mneme/lci0/common-lisp/run-vectors.lisp
sbcl --noinform --disable-debugger --load mneme/lci0/common-lisp/load.lisp \
  --eval '(format t "~&LCI0 CORPUS SUMMARY: ~S~%" (lisp-plus-lci0:verify-fixture-corpus))' --quit
for P in package printer readtable hash-insertion; do
  LCI0_PERTURBATION=$P sbcl --noinform --disable-debugger --script mneme/lci0/common-lisp/run-perturbation.lisp
done
sbcl --noinform --disable-debugger --script canonical-datum/common-lisp/run-tests.lisp

# 2. Python battery
( cd mneme/lci0/python && PYTHONPATH=$PWD:$PWD/../../../canonical-datum/python \
  python3 -m unittest discover -s tests -p 'test_*.py' )
( cd canonical-datum/python && PYTHONPATH=$PWD python3 -m unittest discover -s tests -p 'test_*.py' )
for S in 0 1 random; do ( cd mneme/lci0/python && PYTHONHASHSEED=$S \
  PYTHONPATH=$PWD:$PWD/../../../canonical-datum/python python3 -m unittest discover -s tests -p 'test_*.py' ); done

# 3. Differential (fresh output dir each run)
PYTHONDONTWRITEBYTECODE=1 PYTHONPATH=mneme/lci0/differential:mneme/lci0/python:canonical-datum/python \
  python3 mneme/lci0/differential/run_differential.py --output /tmp/lci0-review-exact-$(date +%s)

# 4. Harness self-tests
( cd mneme/lci0/differential && PYTHONPATH=$PWD:$PWD/../python:$PWD/../../../canonical-datum/python \
  python3 -m unittest test_run_differential test_post_convergence test_python_adapter )

# 5. Post-convergence (against the step-3 output dir)
PYTHONDONTWRITEBYTECODE=1 PYTHONPATH=mneme/lci0/differential:mneme/lci0/python:canonical-datum/python \
  python3 mneme/lci0/differential/post_convergence.py --successor-artifacts <step-3 dir> \
  --output /tmp/lci0-review-post-$(date +%s) --seed 1279478064 --allocation-cases 64

# 6. Ledger history check
git log -p --follow -- mneme/lci0/evidence/LCI0-IMPLEMENTATION-DIVERGENCES.md | head
git show <pre-closure-commit>:mneme/lci0/evidence/LCI0-IMPLEMENTATION-DIVERGENCES.md | \
  diff - <(head -n 1135 mneme/lci0/evidence/LCI0-IMPLEMENTATION-DIVERGENCES.md)
```

## 5. Where the implementing hands' evidence lives (compare, don't trust)

- Receipts: `mneme/lci0/evidence/LCI0-CLOSURE-*.md` / `.txt` (this
  directory).
- Curated converged artifacts:
  `mneme/lci0/differential/artifacts/closure-converged-2026-07-15/`.
- Full logs: `_staging/lci0-closure-reverify/phase2/integrator/`
  (battery logs, forgewright harness logs, INTEGRATOR-REPORT.md) and
  `phase2/forge-{cl,py}/` (red/green forge evidence).
- Banked pre-closure baseline: `phase2/baseline/` +
  `/tmp/lci0-baseline-rerun-1784064852` (do not delete).

Sign your review with your model name. A clean disagreement, precisely
located, is worth more than a fast confirmation.
