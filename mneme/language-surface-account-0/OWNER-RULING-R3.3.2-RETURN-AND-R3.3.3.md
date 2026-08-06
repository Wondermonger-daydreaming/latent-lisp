# SURFACE ACCOUNT /0 — OWNER RULING: RETURN R3.3.2, ONE MALFORMED-CARRIER TOTALITY SEAM (R3.3.3)

*Received 2026-08-05/06 from the lab owner (Tomás P. Pavan), filed verbatim by the
chair (Claude Fable 5) — sandbox path and external link preserved as received. This
document is the governing law of the R3.3.3 round.*

---

## Owner ruling — RETURN R3.3.2, one malformed-carrier totality seam

R3.3.2 genuinely closes the two defects it was commissioned to repair, but
terminal closure is withheld. The reserved-slot scanner rejects the malformed
shape it tests—an odd proper list—while silently accepting other malformed
property lists that exact SBCL 2.4.6 permits.

| Seam | Ruling |
|---|---|
| Archive, manifest, confinement | **PASS** |
| Bundle prerequisite enforcement | **PASS** |
| Publication finality / single disposition slot | **PASS — LOCKED** |
| NIL-valued reserved indicator | **PASS — LOCKED** |
| Duplicate or foreign reserved value | **PASS — LOCKED** |
| Unrelated proper-plist properties | **PASS — LOCKED** |
| Improper/dotted carrier plist | **RETURN** |
| Circular carrier plist | **RETURN** |
| Evidence honesty and hygiene | **PASS** |
| Production, adoption, Surface `/3` | **NOT AUTHORIZED** |

Custody is excellent:

* SHA-256 `9aa53abde372426792e83ab9938a701ea2bffab3693cf65c6500922c43099675`
* 491,461 bytes
* 133 regular files + 12 directories = 145 members
* 132/132 non-self manifest rows matched
* sole prerequisite `fd27d5a3eefc4624bbb099face9ce1e91c92ca18`
* four-commit, nine-path confined delta
* parcel tip `012c68f13b6a1d4c655d53f1f3d3d26ba55c8659`
* fetching into a repository without the prerequisite fails with **zero
  objects and zero refs imported**
* all eleven raw porcelain captures are genuinely zero bytes
* public `main` remains `ced1b2ce…`; no public `surface-account-0*` ref exists

### What closes cleanly

The publication repair is structurally sound. State and initialization
failure are now alternative values written by CAS-from-`NIL` into the same
`DISPOSITION` slot. Both cannot coexist; branch order no longer decides
reality. The lagging `published` flag is genuinely absent from the candidate
mechanism.

The reserved-indicator repair also correctly distinguishes absence from a
present `NIL` value, counts duplicates, refuses foreign values, preserves
ordinary proper-plist properties by identity, and routes reader and election
through one adjudication law. The two supplied mutation witnesses fail with
named checks when the old flag or `GETF` predicate is restored.

### Blocking defect — the plist walk is not total

The shipped `SA0-SCAN-RESERVED` (`probes/probe-identity.lisp`) loops only
while its current tail is a cons:

```lisp
(loop for tail = plist then (cddr tail)
      while (consp tail)
      ...)
```

A non-`NIL` atomic tail therefore terminates the scan as though the plist
ended lawfully. Exact SBCL 2.4.6 accepts improper values in `SYMBOL-PLIST`,
confirmed independently:

```text
DOTTED-SET OK EQ=T PLIST=(:A :B . :TAIL)
```

I then loaded the exact candidate identity source after planting:

```lisp
(UNRELATED :KEPT . DOTTED-TAIL)
```

The result was:

```text
load exit       0
ready-p         T
reserved count  1
carrier plist   (SA0-IDENTITY-CELL <lawful-cell>
                 UNRELATED :KEPT . DOTTED-TAIL)
```

The election silently prepended its cell and preserved the malformed dotted
tail. A later reader counted one lawful cell and accepted it. This directly
contradicts the source's categorical claim that a malformed property list is
rejected.

The adjacent cyclic case is worse. With a circular carrier plist containing
no reserved indicator, the exact candidate produced:

```text
CIRCULAR-LOAD TIMEOUT
```

The counting walk never finishes, so rejection is neither immediate nor
bounded. The present tooth covers only an odd finite list:

```lisp
(UNRELATED-PROPERTY "kept" SA0-IDENTITY-CELL)
```

That specimen is real, but it is not representative of the whole
malformed-plist class claimed by the implementation.

### Proper successor

Commission a tiny **R3.3.3 malformed-carrier totality closure** from exact
tip `012c68f1…`. It should:

* Reject any non-`NIL` terminal tail rather than treating it as
  end-of-plist.

* Detect cycles with an EQ-identity visited set or an equivalently total
  bounded algorithm.

* Add exact-source teeth for:

  * an improper plist with no reserved indicator;
  * an improper plist containing one otherwise-lawful reserved cell;
  * a circular plist, under a hard timeout converted into test failure.

* Require definitive rejection, no election, no gathering, no readiness, and
  the planted plist unchanged.

* Add a disease-reintroduction comparator that restores the current
  `while (consp tail)` termination behavior.

* Freeze publication finality, NIL/duplicate/foreign-value adjudication,
  every inherited profile, and all custody machinery.

* Keep R4 reserved.

This is not "concurrency in general" returning from the dead. Publication
finality is closed. Presence-versus-value is closed. The remaining creature
is one plist walker that recognizes an odd corpse but lets dotted and
circular revenants stroll past reception.
