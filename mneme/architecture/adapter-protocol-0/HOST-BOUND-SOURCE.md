# Adapter Protocol /0 — probe files that are HOST-BOUND SOURCE (historical evidence, not instruments)

*Labeling only, by census correction C6 (2026-08-22, Sol I: "authorize labeling only; do not rewrite the
historical probes"). Same category and same reason as `mneme/language-surface-1/HISTORICAL-EVIDENCE-NOT-RUNNABLE.md`
and the `HOST-BOUND-SOURCE` rows of `mneme/integration-baseline-0/PROBE-SOURCE-INVENTORY.tsv` (which is
closed and is not amended).*

These three Python probes hard-code absolute paths under `/home/gauss/Claude-Code-Lab/…` — the lab host
on the day they ran. From a clean checkout of this mirror they do not resolve their targets. They are
**records of what a hostile pass saw on 2026-07-18/19**, cited as evidence sources in
`mneme/adapter0/ALLOWED-SOURCES.md` (items 11–13), and are not to be run as instruments. Rewriting their
paths would manufacture a new result under an old probe's name.

| path | sha256 (first 16) | host-bound line(s) |
|---|---|---|
| `hostile-pass/attacks-breakpoint/attack_breakpoint.py` | `b2c1b71b721cd670` | 18 |
| `hostile-pass/attacks-undertow/probe_custody.py` | `3876de2e78374359` | 8 |
| `reissue-verification/ap0_reissue_hostile_regression.py` | `849d753e99cbeb5b` | 7, 14, 44 |

Their recorded outputs (`hostile-regression-rerun.out`, the `hostile-*.md` narratives) are the evidence;
the scripts are how it was obtained, on that host, then.
