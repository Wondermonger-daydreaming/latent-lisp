# Final nonregression command transcript

Date: 2026-07-14

Working directory: `/home/gauss/Codex-Lab/latent-lisp-lci0-integration-successor`

Tested integration-successor HEAD: `041d537` (raw-transcript commit; no
protected source changed by the contemporaneous documentation worktree edits)

Each command below exited 0. Standard output and standard error were captured
in the sibling files named here.

1. `env PYTHONDONTWRITEBYTECODE=1 python3 canonical-datum/tools/verify_phase0.py`
   - stdout: `phase0.stdout.txt`
   - stderr: `phase0.stderr.txt`
2. `sbcl --noinform --disable-debugger --script canonical-datum/common-lisp/run-tests.lisp`
   - stdout: `common-lisp-cd0.stdout.txt`
   - stderr: `common-lisp-cd0.stderr.txt`
3. `env PYTHONDONTWRITEBYTECODE=1 PYTHONPATH=canonical-datum/python python3 -m unittest discover -s canonical-datum/python/tests -v`
   - stdout: `python-cd0.stdout.txt`
   - stderr: `python-cd0.stderr.txt`
4. `env PYTHONDONTWRITEBYTECODE=1 python3 canonical-datum/integration/run_differential.py --json`
   - stdout: `cd0-differential.stdout.json`
   - stderr: `cd0-differential.stderr.txt`
5. `env PYTHONDONTWRITEBYTECODE=1 bash mneme/verify-all.sh`
   - stdout: `mneme-v1.stdout.txt`
   - stderr: `mneme-v1.stderr.txt`
6. `sha256sum` over the exact 20 paths frozen in
   `LCI0-CD0-FROZEN-INVENTORY.md`
   - output: `cd0-frozen-inventory.sha256`
7. `git diff --name-status 26ac543856e30c340cc2dd4359802442636f4b94..041d537 -- canonical-datum mneme/latent-mvp mneme/verify-all.sh`
   - output: empty
8. `git rev-parse` comparisons for the three protected objects
   - `canonical-datum`: `ce6e41deca3fe237ff6d0edafa2666d098ae62e8`
     at both commits
   - `mneme/latent-mvp`: `41c2934e34a04461cf50cb378394c32c7c11d344`
     at both commits
   - `mneme/verify-all.sh`: blob
     `b001ec4fde1e5e42c334589dc3fc0f34a0038a9b` at both commits

Observed results: Phase 0 PASS (17/17 worked, 71 classified negatives, 39
Errata vectors); Common Lisp CD/0 PASS (2,633 assertions, 3 declared N/A not
counted as pass); Python CD/0 PASS (167/167); CD/0 differential PASS (467
requests per codec, zero issues); existing Mneme/v1 floor PASS (6/6 suites).
All 20 frozen inventory hashes reproduced, and the protected object/diff checks
were exact and empty respectively.
