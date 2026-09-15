# Pin census — sha256 / tree-OID pins on the two S1/S2 files, the lane, and the latent-lisp subtree

Date: Tue Sep 15 01:48:48 PM -03 2026

## Computed hashes at current HEAD/working tree

```
sha256sum experiments/latent-lisp/mneme/memory-layer-0/ml0-consolidation-proof.lisp
  = 6e83648eaada296e8f05169756565811a4d4815e7954f97462c36be63d49bd4b
sha256sum experiments/latent-lisp/mneme/memory-layer-0/ml0.lisp
  = 784bc7f6e6d0b7c40485c23e994fb455934cac30682b7a58f22b3942cac4c6df
sha256sum experiments/latent-lisp/mneme/memory-layer-0/FILE-MANIFEST.txt
  = 3029ecba285e41546699ed0f108170f039cd04469b5bfa78d84a7bad01b15b13
lane tree OID  git rev-parse HEAD:mneme/memory-layer-0 (as recorded elsewhere) = 9458616a438fbce1de0433d439b458f83d76fbac
latent-lisp subtree OID (as of the 09-09 README-supersession crossing)       = e148d8a5344cd0bef88d0a8d5eba77684577d9f3
```

## H1 (ml0-consolidation-proof.lisp sha256) pins — every hit, full and 12-char prefix identical set

| file:line | type | excerpt |
|---|---|---|
| `./_staging/2026-09-03-fossil-publication-cargo-0.1/03-candidate-manifest.sha256:4750` | MANIFEST-RECORD (checkable via `sha256sum -c`; not itself a script) | 6e83648eaada296e8f05169756565811a4d4815e7954f97462c36be63d49bd4b  ./mneme/memory-layer-0/ml0-consolidation-proof.lisp |
| `./_staging/2026-08-30-next-cargo-0/CARGO-MANIFEST.txt:4749` | MANIFEST-RECORD (checkable via `sha256sum -c`; not itself a script) | mneme/memory-layer-0/ml0-consolidation-proof.lisp	d30a3a5b2a6aa0150d76bac7ebf9b3c01b679920	6e83648eaada296e8f05169756565811a4d4815e7954f97462c36be63d49bd4b |
| `./notes/one-act-1-audit/AUDITOR-CHECKOUT-MANIFEST-aeeefa40.txt:4745` | MANIFEST-RECORD (checkable via `sha256sum -c`; not itself a script) | 6e83648eaada296e8f05169756565811a4d4815e7954f97462c36be63d49bd4b  ./mneme/memory-layer-0/ml0-consolidation-proof.lisp |
| `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet/SHA256SUMS:57` | MANIFEST-RECORD (checkable via `sha256sum -c`; not itself a script) | 6e83648eaada296e8f05169756565811a4d4815e7954f97462c36be63d49bd4b  ./ENVELOPE-B/lane/ml0-consolidation-proof.lisp |
| `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet/ENVELOPE-A/FILE-MANIFEST.txt:79` | MANIFEST-RECORD (checkable via `sha256sum -c`; not itself a script) | 6e83648eaada296e8f05169756565811a4d4815e7954f97462c36be63d49bd4b  ml0-consolidation-proof.lisp |
| `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet-0.1/SHA256SUMS:58` | MANIFEST-RECORD (checkable via `sha256sum -c`; not itself a script) | 6e83648eaada296e8f05169756565811a4d4815e7954f97462c36be63d49bd4b  ./ENVELOPE-B/lane/ml0-consolidation-proof.lisp |
| `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet-0.1/ENVELOPE-A/FILE-MANIFEST.txt:79` | MANIFEST-RECORD (checkable via `sha256sum -c`; not itself a script) | 6e83648eaada296e8f05169756565811a4d4815e7954f97462c36be63d49bd4b  ml0-consolidation-proof.lisp |
| `./experiments/latent-lisp/mneme/memory-layer-0/FILE-MANIFEST.txt:79` | MANIFEST-RECORD (checkable via `sha256sum -c`; not itself a script) | 6e83648eaada296e8f05169756565811a4d4815e7954f97462c36be63d49bd4b  ml0-consolidation-proof.lisp |

## H2 (ml0.lisp sha256) pins

| file:line | type | excerpt |
|---|---|---|
| `./_staging/2026-09-03-fossil-publication-cargo-0.1/03-candidate-manifest.sha256:4760` | MANIFEST-RECORD (checkable via `sha256sum -c`; not itself a script) | 784bc7f6e6d0b7c40485c23e994fb455934cac30682b7a58f22b3942cac4c6df  ./mneme/memory-layer-0/ml0.lisp |
| `./_staging/2026-08-30-next-cargo-0/CARGO-MANIFEST.txt:4759` | MANIFEST-RECORD (checkable via `sha256sum -c`; not itself a script) | mneme/memory-layer-0/ml0.lisp	970c183554e923c6b657009b2eb07645e42cf3ae	784bc7f6e6d0b7c40485c23e994fb455934cac30682b7a58f22b3942cac4c6df |
| `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet/SHA256SUMS:67` | MANIFEST-RECORD (checkable via `sha256sum -c`; not itself a script) | 784bc7f6e6d0b7c40485c23e994fb455934cac30682b7a58f22b3942cac4c6df  ./ENVELOPE-B/lane/ml0.lisp |
| `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet/ENVELOPE-A/PROPOSITION-REGISTER.md:15` | MANIFEST-RECORD (checkable via `sha256sum -c`; not itself a script) | | `mneme/memory-layer-0/ml0.lisp` | `970c183554e923c6b657009b2eb07645e42cf3ae` | `784bc7f6e6d0b7c40485c23e994fb455934cac30682b7a58f22b3942cac4c6df` | |
| `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet/ENVELOPE-A/FILE-MANIFEST.txt:89` | MANIFEST-RECORD (checkable via `sha256sum -c`; not itself a script) | 784bc7f6e6d0b7c40485c23e994fb455934cac30682b7a58f22b3942cac4c6df  ml0.lisp |
| `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet-0.1/SHA256SUMS:68` | MANIFEST-RECORD (checkable via `sha256sum -c`; not itself a script) | 784bc7f6e6d0b7c40485c23e994fb455934cac30682b7a58f22b3942cac4c6df  ./ENVELOPE-B/lane/ml0.lisp |
| `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet-0.1/ENVELOPE-A/FILE-MANIFEST.txt:89` | MANIFEST-RECORD (checkable via `sha256sum -c`; not itself a script) | 784bc7f6e6d0b7c40485c23e994fb455934cac30682b7a58f22b3942cac4c6df  ml0.lisp |
| `./experiments/latent-lisp/mneme/memory-layer-0/FILE-MANIFEST.txt:89` | MANIFEST-RECORD (checkable via `sha256sum -c`; not itself a script) | 784bc7f6e6d0b7c40485c23e994fb455934cac30682b7a58f22b3942cac4c6df  ml0.lisp |
| `./notes/one-act-1-audit/AUDITOR-CHECKOUT-MANIFEST-aeeefa40.txt:4755` | MANIFEST-RECORD (checkable via `sha256sum -c`; not itself a script) | 784bc7f6e6d0b7c40485c23e994fb455934cac30682b7a58f22b3942cac4c6df  ./mneme/memory-layer-0/ml0.lisp |

## HM (FILE-MANIFEST.txt sha256) pins

| file:line | type | excerpt |
|---|---|---|
| `./_staging/2026-09-03-fossil-publication-cargo-0.1/03-candidate-manifest.sha256:4703` | MANIFEST-RECORD (checkable via `sha256sum -c`; not itself a script) | 3029ecba285e41546699ed0f108170f039cd04469b5bfa78d84a7bad01b15b13  ./mneme/memory-layer-0/FILE-MANIFEST.txt |
| `./_staging/2026-08-30-next-cargo-0/CARGO-MANIFEST.txt:4702` | MANIFEST-RECORD (checkable via `sha256sum -c`; not itself a script) | mneme/memory-layer-0/FILE-MANIFEST.txt	9663ac154b20dd91833adb2af92fcb08e2f5752d	3029ecba285e41546699ed0f108170f039cd04469b5bfa78d84a7bad01b15b13 |
| `./_staging/2026-09-01-ml0-sameroot-cold-audit/ELIGIBILITY-DECLARATION.md:114` | RECORD (prose citation) |   `3029ecba285e41546699ed0f108170f039cd04469b5bfa78d84a7bad01b15b13`, matching |
| `./_staging/2026-09-01-ml0-sameroot-cold-audit/THREAT-MODEL-AND-TEST-PLAN.md:34` | RECORD (prose citation) | | `FILE-MANIFEST.txt` against `IDENTITY-AND-MANIFEST-EVIDENCE.md` | `3029ecba285e41546699ed0f108170f039cd04469b5bfa78d84a7bad01b15b13` | same | **OK** | |
| `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet/SHA256SUMS:2` | MANIFEST-RECORD (checkable via `sha256sum -c`; not itself a script) | 3029ecba285e41546699ed0f108170f039cd04469b5bfa78d84a7bad01b15b13  ./ENVELOPE-A/FILE-MANIFEST.txt |
| `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet/ML0-STRANGER-AUDIT-INGRESS-0.md:20` | RECORD (prose citation) | | `FILE-MANIFEST.txt` sha256 (commissioned) | `3029ecba285e41546699ed0f108170f039cd04469b5bfa78d84a7bad01b15b13` | measured exact ✓ | |
| `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet-0.1/ML0-STRANGER-AUDIT-INGRESS-0.1.md:37` | RECORD (prose citation) | | `FILE-MANIFEST.txt` sha256 (commissioned) | `3029ecba285e41546699ed0f108170f039cd04469b5bfa78d84a7bad01b15b13` | measured exact ✓ | |
| `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet-0.1/SHA256SUMS:2` | MANIFEST-RECORD (checkable via `sha256sum -c`; not itself a script) | 3029ecba285e41546699ed0f108170f039cd04469b5bfa78d84a7bad01b15b13  ./ENVELOPE-A/FILE-MANIFEST.txt |
| `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet/ENVELOPE-A/IDENTITY-AND-MANIFEST-EVIDENCE.md:16` | RECORD (prose citation) | | `FILE-MANIFEST.txt` SHA-256 | `3029ecba285e41546699ed0f108170f039cd04469b5bfa78d84a7bad01b15b13` | |
| `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet-0.1/ENVELOPE-A/IDENTITY-AND-MANIFEST-EVIDENCE.md:16` | RECORD (prose citation) | | `FILE-MANIFEST.txt` SHA-256 | `3029ecba285e41546699ed0f108170f039cd04469b5bfa78d84a7bad01b15b13` | |
| `./notes/one-act-1-audit/AUDITOR-CHECKOUT-MANIFEST-aeeefa40.txt:4698` | MANIFEST-RECORD (checkable via `sha256sum -c`; not itself a script) | 3029ecba285e41546699ed0f108170f039cd04469b5bfa78d84a7bad01b15b13  ./mneme/memory-layer-0/FILE-MANIFEST.txt |
| `./corpus/voices/received/2026-09-01-sol-ii-terminal-return-ml0-stranger-audit-ingress-01-READY-FOR-STRANGER.md:65` | RECORD (prose citation) | * manifest SHA-256 `3029ecba285e41546699ed0f108170f039cd04469b5bfa78d84a7bad01b15b13`; |

## Lane tree OID `9458616a438f...` pins (git rev-parse HEAD:mneme/memory-layer-0) — count only, all RECORD (prose), none is a live script check

Hit count: 12
Files: 10

All hits are inside `_staging/2026-09-01-ml0-*` audit packets and `corpus/voices/received/2026-09-01-*` letters — i.e. the 09-01 stranger-audit-ingress commission's IDENTITY tables. None is checked by a live script; each is a prose/table row a human or Sol read against a freshly-run `git rev-parse`.

## latent-lisp subtree OID `e148d8a5344c...` pins (the WHOLE experiments/latent-lisp tree at the 09-09 README-supersession crossing) — count only

Hit count: 34
Files: 26

**Load-bearing note:** this OID is the hash of the ENTIRE `experiments/latent-lisp` subtree, not specific to the two S1/S2 files. A byte-edit to either file changes this subtree OID (and every SUBJ/subject-subtree pin listed above that names it — the 09-08 and 09-09 PUBLISHED crossings, the A13-reconciliation evidence, the 09-14 WARRANT-SESSION Astra commission's pinned baseline). All such hits are RECORD (prose citations in staging evidence/receipts and received letters); none is re-checked by a live script in this repo (the check, when it happened, was a human/Sol `git rev-parse`/`git archive` at ferry time, not a standing checker).

## Scripts (*.sh, *.py, *.lisp) that reference `FILE-MANIFEST` or run `sha256sum -c` under experiments/latent-lisp/ or tools/

`rg -n -F "FILE-MANIFEST" experiments/latent-lisp tools --glob '*.sh' --glob '*.py' --glob '*.lisp'` → **0 hits.** No script in this repo reads or checks `FILE-MANIFEST.txt` by name.

`rg -n "sha256sum -c" experiments/latent-lisp tools --glob '*.sh' --glob '*.py'` → 15 hits, none targets this lane's `FILE-MANIFEST.txt`; each checks a different, generically-named `SHA256SUMS` file for a DIFFERENT artifact (a parcel/cargo/dry-run payload, not `mneme/memory-layer-0/`):
```
tools/cron/remind-migration-1900.sh:18:3. **Verify on the laptop** before extracting (`sha256sum -c`), then extract and check the inner SHA256SUMS (77 files).
tools/parcel/teeth.sh:39:if [ "$rc" -eq 0 ] && [ -n "$TB" ] && ( cd "$O" && sha256sum -c --quiet "$(basename "$TB").sha256" ) \
tools/parcel/teeth.sh:40:   && mkdir -p "$T/x" && tar -xzf "$TB" -C "$T/x" && ( cd "$T/x/t5" && sha256sum -c --quiet SHA256SUMS ) \
tools/parcel/pack.sh:71:( cd "$PAY" && sha256sum -c --quiet SHA256SUMS ) || die "manifest does not verify against the payload it was just built from"
tools/latent-lisp/dry-run-cargo-reader.sh:148:  ( cd "$DIR" && LC_ALL=C sha256sum -c --quiet SHA256SUMS >/dev/null 2>&1 ) || reject "the hash chain SHA256SUMS ↦ files does not verify"
tools/stranger-harness/pack_01.sh:14:( cd "$P" && sha256sum -c SHA256SUMS | grep -c ': OK$' | sed 's/^/\/0 manifest OK: /' )
tools/stranger-harness/pack_01.sh:34:echo "== readback =="; RB=$W/rb; mkdir -p "$RB"; tar -xzf "$OUT/$BASE.tar.gz" -C "$RB"; ( cd "$RB" && sha256sum -c SHA256SUMS | grep -c ': OK$' | sed 's/^/OK: /' ); tar -tzvf "$OUT/$BASE.tar.gz" | awk '{print substr($1,1,10)}' | sort | uniq -c
tools/stranger-harness/pack_01.sh:35:chmod -R u+w "$W"; rm -rf "$W"; cp -p "$OUT/$BASE.tar.gz" "$OUT/$BASE.tar.gz.sha256" ~/Downloads/ && ( cd ~/Downloads && sha256sum -c "$BASE.tar.gz.sha256" )
tools/stranger-harness/pack_return.sh:64:RB=$(mktemp -d /tmp/rb.XXXXXX); tar -xzf "$OUT/$BASE.tar.gz" -C "$RB" && ( cd "$RB" && sha256sum -c SHA256SUMS | grep -c ': OK$' | sed 's/^/readback OK: /' ) && chmod -R u+w "$RB" "$(dirname "$P")" 2>/dev/null; rm -rf "$RB" "$(dirname "$P")"
tools/stranger-harness/pack_return.sh:65:cp -p "$OUT/$BASE.tar.gz" "$OUT/$BASE.tar.gz.sha256" ~/Downloads/ && ( cd ~/Downloads && sha256sum -c "$BASE.tar.gz.sha256" )
tools/latent-lisp/teeth-record.sh:57:#       | sha256sum -c - || { echo 'WRONG SUBJECT — do not trust the run'; exit 1; }
tools/latent-lisp/dry-run-cargo.sh:286:      ( cd "$p" && LC_ALL=C sha256sum -c --quiet SHA256SUMS >/dev/null 2>&1 ) || abort "T$t preflight ledger does not verify: $p"
tools/latent-lisp/dry-run-cargo.sh:865:    ( cd "$src" && LC_ALL=C sha256sum -c --quiet SHA256SUMS >/dev/null 2>&1 ) || { H10_WHY="1 (source ledger does not verify)"; return 1; }
tools/latent-lisp/dry-run-cargo.sh:931:    ( cd "$der" && LC_ALL=C sha256sum -c --quiet SHA256SUMS >/dev/null 2>&1 ) || { H10_WHY="derivation (derivative ledger does not verify)"; return 1; }
tools/latent-lisp/dry-run-cargo.sh:1636:  ( cd "$d" && LC_ALL=C sha256sum -c --quiet SHA256SUMS >/dev/null 2>&1 ) || return 1
tools/latent-lisp/dry-run-cargo.sh:2346:note $f "\$ cd $PREFLIGHT_ABS && LC_ALL=C sha256sum -c SHA256SUMS"
tools/latent-lisp/dry-run-cargo.sh:2349:LC_ALL=C sha256sum -c SHA256SUMS > "$SCR/pfledger.txt" 2>> "$OUT/$f.err"; rpl=$?
tools/latent-lisp/dry-run-cargo.sh:2354:{ [ $rpl -eq 0 ] && ! LC_ALL=C grep -q 'FAILED' "$SCR/pfledger.txt"; } || stop STOP-PREFLIGHT-LEDGER "sha256sum -c rc=$rpl"
```

**Conclusion:** `FILE-MANIFEST.txt` is verified only by hand (per its own header: "verified with `sha256sum -c` before it was committed" — a one-off human action at R5, 2026-08-21, not a standing/automated check). `verify-release.sh` (the lane's own live release-floor script) builds its OWN dynamic `git ls-tree`-derived manifest at run time and diffs that against an expected list — it does NOT read or check `FILE-MANIFEST.txt` at all (confirmed: no "FILE-MANIFEST" string anywhere in `verify-release.sh`). So a byte-edit at `ml0-consolidation-proof.lisp:42` or `ml0.lisp:3002` would silently desync `FILE-MANIFEST.txt`'s two rows unless someone regenerates it by hand — `verify-release.sh`'s floor would not itself catch or care about that desync.
