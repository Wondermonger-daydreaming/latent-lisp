# Owner ruling — RETURN R4

```text
R4 RECOMMENDATION: HALT — R4-READINESS-GUARD-ACCEPTS-NONEXTERNAL-API
```

The production candidate is substantially sound, but its `ADOPT` recommendation is rejected. Adoption, merge, push, and Surface `/3` remain unauthorized.

| Area | Ruling |
| ---------------------------------- | ------------------ |
| Archive, manifests, bundle custody | **PASS** |
| Production identity implementation | **PASS — LOCKED** |
| ASDF/umbrella normal loading | **PASS** |
| Surface `/0` → `/2` inhabitance | **PASS** |
| Frozen R3.3.3 regressions | **PASS — LOCKED** |
| Hostile profiles and mutations | **PASS** |
| Loader completeness predicate | **RETURN** |
| R4 adoption | **NOT AUTHORIZED** |

### Custody

* ZIP SHA-256: `3cbce84b3a908fe798363cb4d1bea2560bc0d4d307df6b57513d6e2263af8835`
* Size: 1,565,125 bytes
* 906 files + 295 directories = 1,201 members
* Top manifest: 904/904 rows exact
* Evidence manifest: 875/875 rows exact
* Sole bundle prerequisite: `2c1ac711b039528fd6a9d665d37ac2a937bf532d`
* Twelve linear R4 commits
* Parcel tip: `c412a0a0906dec4dc5674d198b0f6836f89a7eaa`
* Seventeen declared changed paths
* Frozen probe tree: `8a8bf75f86fcc259312d5b303593c161137098ae`
* All 17 shipped tip snapshots matched the reconstructed subject tree byte-for-byte
* Public `main` remains `ced1b2ceb13f22cec188c2b3f73dcfc73e7d112e`
* No public `surface-account-0*` branch exists

### What independently passes

Under exact SBCL 2.4.6:

* Production self-test: 38 checks
* `/0` → `/2` inhabited specimen: 12 checks
* ASDF graph gate: 5 checks
* Seven hostile roles: 65 checks
* Six production disease comparators detected their mutations, with all controls clean
* Production source compiled without warnings or failure
* All 13 frozen probe profiles were accepted
* The complete R3.3.3 runner emitted its success sentinel
* Planting a failure made all 13 profiles refuse and the overall runner exit 1

The identity mechanism itself is not reopened.

### Blocking defect

Both `lisp-plus.asd` and `production/load.lisp` implement "full nine-export completeness" approximately as:

```lisp
(let ((symbol (find-symbol name package)))
  (and symbol (fboundp symbol)))
```

`FIND-SYMBOL` returns both a symbol and its accessibility status. The guard discards the status, so nine **internal** fbound symbols are accepted as the complete public API.

In a fresh image I pre-created `LISP-PLUS-SURFACE-ACCOUNT` with the nine expected names as internal dummy functions, then loaded the real umbrella and lane:

```text
BEFORE GUARD=T EXTERNALS=0
AFTER-UMBRELLA GUARD=T EXTERNALS=0 CARRIER-SYMBOL=NIL
AFTER-LANE GUARD=T EXTERNALS=0 CARRIER-SYMBOL=NIL
IDENTITY-READY-P STATUS=:INTERNAL
exit=0
```

The umbrella reports success without loading the production implementation. There are zero public exports, no identity carrier, and even explicitly loading the lane afterward does nothing because the same false completeness predicate returns true.

There is a second half of the same defect: when the predicate correctly notices an incomplete pre-existing package, `production/load.lisp` loads `package.lisp` only if the package is absent. Therefore it cannot repair an existing package whose export surface is incomplete.

This directly contradicts the R4 ledger's "full nine-export completeness" claim and the governing requirement that umbrella loading leave the nine correct public exports present.

### Proper successor: R4.3

Commission a narrow loader-finality repair from `c412a0a0…`:

* Require `FIND-SYMBOL` status `:EXTERNAL` for every API name, plus `FBOUNDP`.
* When an existing package is incomplete, apply `package.lisp` before loading the implementation.
* Assert the completeness predicate after loading and fail closed if it remains false.
* Add exact witnesses for:
  * nine internal fbound names;
  * a partial external API;
  * an existing empty namesake package;
  * lawful repeated loading after successful repair.
* Add a disease comparator restoring the current status-blind predicate and package-existence skip.
* Rerun every R4 gate and frozen R3.3.3 regression at the new final tip.
* Do not modify the accepted identity mechanism or Surface `/3`.

The supplied terminal floor records 94/94 gates. I credit that as manifest-bound builder evidence, not independent execution: the reconstructed review checkout lacks an obsolete private Surface `/1` commit required by two historical gates, and I stopped its long copied mutation suite after independently completing the R4-specific gates. That limitation does not affect the direct loader counterexample.
