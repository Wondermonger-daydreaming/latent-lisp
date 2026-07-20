# SS-0 Seat — Durable-Record Semantic Layer

Seat deliverables for the SS-0 brief. Primary implementation: **Python 3** (`ss0.py` —
scenario runner + cold-recovery program + all recovery modes). Independent second
reader: **Common Lisp/SBCL** (`ss0-reader.lisp`). No third-party dependencies; both
sides use only the frozen packet substrate.

## Layout

Place the two seat files beside the packet's `substrate/` directory:

```
<work>/ss0.py
<work>/ss0-reader.lisp
<work>/substrate/…   (frozen packet files, unmodified)
```

## Running

```sh
# death harness, all seven scenarios (each death is a real SIGKILL):
SS0_ENTRY="python3 $PWD/ss0.py" python3 substrate/ss0-harness.py

# runner contract (as invoked by the harness):
python3 ss0.py <run-dir>/ <kind> <killpoint-or-empty>   # kind ∈ effect|stream|refused
python3 ss0.py <run-dir>/ <scenario-name> [killpoint]   # S1-clean … S7-refused-unrecorded,
                                                        # P-complete, P-empty, P-invalid, P-stream
# cold recovery modes (run against any run-directory, live or corpse):
python3 ss0.py <run-dir>/ recover                 # full audit report (R1/R2/R6/R9)
python3 ss0.py <run-dir>/ canon                   # canonical rendering + digest only (R7)
python3 ss0.py <run-dir>/ redispatch <op>         # re-dispatch gate (R3/R4); exit 3 = refused
python3 ss0.py <run-dir>/ admit <op>              # admit provider receipt as evidence (R4)
python3 ss0.py <run-dir>/ succeed <old> <new> [tag]  # distinct successor (R5)

# independent second reader (R7): byte-identical canonical rendering + digest
sbcl --script ss0-reader.lisp <run-dir>/
```

## Record vocabulary (the semantic layer; all records are canonical ser maps)

| kind  | fields | meaning / write protocol |
|---|---|---|
| `op`    | `op`, `tag` | intent declaration. Always appended **durable, before dispatch**. |
| `succ`  | `op`, `sup`, `tag` | explicitly distinct successor declaration (R5): fresh identity, `sup` = superseded predecessor. Never presented as a first attempt or a retry. |
| `out`   | `op`, `st`, `pc`, `dur`, `pl` or `pd` | outcome as returned by the provider. `st` ∈ `executed`/`not-executed`/`payload`/`unknown-tag`. `pc` (payload class) ∈ `absent`/`valid`/`empty`/`invalid` (R2). `pl` = payload text (valid/empty); `pd` = crc32 of payload (invalid — invalid bytes are never enshrined). `dur` records whether the record itself was written with fsync. |
| `chunk` | `op`, `i`, `data` | one stream chunk, durable as written. |
| `done`  | `op` | completion/confirmation: the outcome is final and durable. |
| `att`   | `op`, `src`, `sdig`, `claims` | external attestation admitted into the record (R4): source receipt filename, crc32 of its bytes, and the outcome it claims. Provenance-carrying; never confused with direct observation. |

**Load-bearing invariant:** the declaration is fsynced before the provider is
contacted. Therefore an intact, clean-tailed log that contains *no* declaration for an
op-id *proves* that op was never dispatched; a torn tail destroys that proof.

## Derived standings (computed by recovery; never written back — R6)

`UNRESOLVED` (declaration only; histories “never dispatched” and “dispatched, outcome
unrecorded” are both consistent with the records and are both reported — R1),
`OUTCOME-UNCONFIRMED` (`out` without `done`; e.g. S5's un-fsynced outcome),
`SETTLED` (`out` + `done`), `ATTESTED` (resolved by `att` evidence only),
`CONFLICT` (contradictory attestations — reported, never silently resolved),
`STREAM-INCOMPLETE` / `STREAM-COMPLETE` (from `chunk` records vs `slow:<n>` in the tag).
Anomalies (orphan records, unknown kinds, undecodable frames, duplicate declarations,
attestation/outcome conflicts) are reported as anomalies; nothing is repaired or invented.

## Re-dispatch gate (R3/R4)

`redispatch` **never dispatches** — automatic re-dispatch is impossible by construction.
It refuses (exit 3) on `UNRESOLVED`, `OUTCOME-UNCONFIRMED`, `STREAM-INCOMPLETE`,
`CONFLICT`, settled/attested `executed`, redundant settled payloads, and whenever a torn
tail prevents certifying absence; every refusal cites the grounding record(s). It
certifies (exit 0) only (a) provable first attempts (no declaration, clean tail) and
(b) known-`not-executed` standings — and even then only as a *fresh identity* via
`succeed`. Resolution to `executed` via attestation never enables re-dispatch (R4).

## Digest spec `ss0-recovery/1` (R7)

Canonical recovery rendering: UTF-8 text, one `\n`-terminated line per item, in order:

```
ss0-recovery/1
tail=<clean|torn>
records=<intact frame count>
anomalies=<count>
anomaly=<text>            × count, generation order (load → scan → lineage → conflicts)
ops=<count>
op=<id>|role=<initial|successor>|sup=<id|->|tag=<tag>|class=<effect|payload|stream|unknown>|standing=<S>|st=<st|->|pc=<pc|->|conf=<0|1>|att=<src:sdig:claims,…|->|chunks=<sorted i csv|->|want=<n|->|succ=<id csv|->   × count, declaration order
digest=<crc32-hex of all bytes above>
```

`class` derives from the tag prefix only (`slow:`/`effect:`/`effect-ne:`/`complete:`/
`empty`/`invalid`); recovery never branches on effect labels. `st` mirrors the outcome
record, or the attested claim when standing is `ATTESTED`. `pc` mirrors the outcome
record (`absent` default). The Python (`canon`) and CL readers implement this spec
independently and agree byte-for-byte.

## Obligations map

- **R1** — recovery reports only surviving records; `UNRESOLVED` enumerates both possible histories; empty log (S2) reports nothing; torn log (S3) reports the torn tail and nothing else.
- **R2** — `pc` distinguishes `absent`/`valid`/`empty`/`invalid` end-to-end (`P-complete`, `P-empty`, `P-invalid` runs; `empty` keeps `pl=""`, `invalid` keeps digest `pd`).
- **R3** — the gate above; S4/S7 corpses refuse with record citations.
- **R4** — `admit` reads `receipt-<op>.txt`, verifies attempt identity, appends `att` with provenance; attested-executed permanently forbids re-dispatch; attested-not-executed permits only fresh identity.
- **R5** — `succeed` writes `succ` (fresh identity, `sup` link) then dispatches it; the predecessor's `UNRESOLVED` standing stays on record and visible.
- **R6** — recovery appends nothing; the report separates SURVIVING RECORDS from DERIVED state; re-running cannot upgrade derived to recorded.
- **R7** — `ss0-reader.lisp` (SBCL), zero shared application code, digest agreement verified on 25 run-directories (7 corpses, clean runs, payload family, 8 planted-fault logs).
- **R8** — effect types are data. A new effect type = a new tag string in a scenario row (`SCEN`) or `succeed … <tag>`; `record_outcome` dispatches on provider *status shape*, recovery is fully generic over records. Only a genuinely new provider status shape would add one branch in `record_outcome` (and possibly one `classify` rule) — recovery logic untouched.
- **R9** — `recover` prints every surviving record with its index, the basis of every standing, ambiguities, anomalies, and the canonical digest.

## Verified before freeze

- `ss0-selftest.py`: 11/11 PASS (SBCL 2.4.11, Python 3.12).
- Harness S1–S7: exit 0 for S1; real SIGKILL (−9) at every killpoint; provider world matches ground truth.
- Cross-language digest agreement: 25/25 run-directories.
- AFEL (`ss0-afel.py`): `ss0.py` 361, `ss0-reader.lisp` 121, total 482. The 8 excluded lines are exactly the 5 `window(…)` kill-waits and 3 `store_append_torn(…)` injections (audited list: 76, 80, 81, 86, 94, 101, 102, 107) — no production logic is marked.
