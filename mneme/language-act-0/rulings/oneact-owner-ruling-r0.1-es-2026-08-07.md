# ONE ACT /0 — SECOND OWNER RULING (Spanish relay, 2026-08-07 late)

*Received via session relay 2026-08-07 ~20:4x −03, in Spanish ("for some reason
the feedback is in spanish" — owner). Transcribed verbatim below, followed by
the chair's reception note.*

**⚠ AUTHORSHIP CORRECTED SAME NIGHT (screenshot evidence):** this ruling was
authored by **GPT-5.6 Sol** (the owner's fresh chair, ChatGPT project "Lisp" /
"Owner Ruling R3.1 Review" thread; Sol: "My mistake — I inexplicably switched
into Spanish… I'll write the R0.1 instruction to Fable entirely in English
next"). **Standing: owner-relayed FRESH-CHAIR review, NOT a direct owner
instrument.** Two consequences, cutting opposite ways: (1) its **D2 "grant" is
Sol's proposed disposition, PENDING the owner's explicit adoption** — only
Tomás grants D2; treat D2 as PROPOSED-BY-SOL until the owner's word. (2) Its
Journal /0 event-id reading and its 5.9/6 convergence with the executed R1
round are **FRESH-WEIGHTS corroboration** (GPT substrate — genuinely outside
the Claude root), the strongest corroboration class the lab recognizes — the
same-root caveat written below is WITHDRAWN for this document. **A revised
English R0.1 instruction from Sol is expected next session; reconcile it
against the mapping below when it arrives.***

---

## Verbatim ruling

Habemus candidatum. **Non habemus sigillum.**

```text
ONE ACT /0 — OWNER RULING

RETURN —
ONE-ACT-0-FREEZE-CARRIES-OPEN-MUST-RESOLVE-REGISTER
```

No es `HALT`: la arquitectura merece continuar. Pero no autoriza apertura de
implementación, adopción ni publicación.

El defecto terminal es inequívoco: el propio Test Plan declara que el sello
"may not be taken" con MR-1…MR-11 abiertos; los once siguen abiertos, mientras
el freeze receipt proclama `READY FOR OWNER RULING`. El sello contradice su
propia ley de cierre.

Los bloqueos principales son:

* `act-id` aparece obligatoriamente en F1–F5, pero carece de regla de
  acuñación, igualdad, unicidad y constancia.

* El bridge no sabe qué acto atiende. Además, BIND-2 liga un nombre, no el
  objeto que realmente despacha. Esto está confirmado en Core /0
  (mneme/language-core-0/core0.lisp): un adapter object pasa directamente,
  mientras el frontier compara nombres.

* `:text`/`:cell` pueden introducir sintaxis en el ledger y hacer que ambos
  lados concuerden sobre evidencia fabricada. El formato y el interruptor
  ambiental de muerte están visibles en Capability /2 world
  (mneme/capability2/world.lisp).

* Falta un nonce fijo, por lo que el twin-run byte-idéntico no es realizable.
  Journal /0 (mneme/journal0/writer.lisp) confirma también la regla que MR-9
  dejó abierta: mismo event-id y payload idéntico es idempotente; payload
  diferente produce colisión.

* Permanecen contradictorios F1/F5 ante rechazo de Office L; NC-13 es vacuo;
  faltan V-F1…V-F5 y `W-ENV`.

### Comisión confinada R0.1

1. Acuñar `act-id` como identificador CD/0 determinista sobre
   `seat-id + canonical-request`, con igualdad de octetos, unicidad previa a
   F1 y constancia exacta en F1–F5.

2. Elegir la rama **un adapter object por acto**: construido después de F1 y
   de acuñar Office R, capturando un act-record inmutable; pasado directamente
   a `perform`; ligado por identidad `EQ`; sin registry global ni "current
   act".

3. Adoptar M-13a/M-13b, `F-STORE` con nonce fijo y `W-ENV`.

4. Resolver Office L así: el rechazo durante `perform` deja F1/F2/F5, pero
   ningún frame Capability /2 ni efecto de mundo. Sólo un rechazo anterior a
   la apertura deja el journal intacto.

5. Separar NC-13 en copia canónicamente idéntica positiva y copia alterada
   negativa; codificar la regla real de event-id; congelar V-F1…V-F5.

6. Reemitir los cinco documentos sin ningún MR abierto y con un nuevo receipt
   coherente. Todavía pre-code.

La disposición D2 queda concedida exactamente para esta lane y **no** nombra
autoridad canónica, no desbloquea Surface /3 y no involucra Surface Account /0.

Custodia limpia: el parcel One Act /0
(oneact-0-candidate-parcel-2026-08-07.tar.gz) tiene SHA-256
`ff37533967e1412f3124bde7ce1be8a8e639ef62fbba817bda1b5e3ead5c3bde`; 13
archivos regulares, sin duplicados, manifest 11/11 y sidecar válidos.

Veredicto corto: **habemus la arquitectura; todavía no habemus /0**.

---

## Chair reception note (Claude Fable 5, same evening)

**What this ruling adjudicates:** the FIRST freeze (`6c05a9e0`/`dd2d8787`,
parcel `ff37533967e1412f3124bde7ce1be8a8e639ef62fbba817bda1b5e3ead5c3bde`) —
i.e. the same state the English R1 ruling (filed at
`_staging/oneact-owner-ruling-r1-2026-08-07.md`) adjudicated earlier today.
The two rulings were evidently authored in parallel against the same parcel;
this one arrived AFTER the R1 repair round had already executed and returned
(R1 freeze `0f59cb8b`, receipt `80861ca7`, parcel
`f489d949642ca1c044ee508b4b64165de8c15c360e475039b8eb91eda7623a78`).

**Mapping — every R0.1 commission item against the executed R1 round:**

| R0.1 item | R1 status |
|---|---|
| 1. act-id minting law (equality, uniqueness-before-F1, constancy F1–F5) | **DONE** as §2A ACT-1..ACT-14 + T0 — **EXCEPT the derivation basis conflicts; see below** |
| 2. One adapter object per act, post-F1, immutable act-record, EQ-bound, no registry/current-act | **DONE** — M-3/M-3a/M-3b/M-3c/M-3d; matches this ruling's branch choice exactly |
| 3. M-13a/M-13b + F-STORE fixed nonce + W-ENV | **DONE** (nonce fixed 16 octets; W-ENV enumerates 13 switches; M-13a-3a docket pending on U+0020) |
| 4. Office L refusal: perform-reached refusal leaves F1/F2/F5, no cap2 frames, no world effect; pre-opening refusal leaves journal untouched | **DONE** — identical to English OR-7's single-trace branch as implemented |
| 5. NC-13 split + real event-id rule + freeze V-F1..V-F5 | **DONE** for NC-13 split and J-8 (this ruling's Journal /0 reading — same-id+identical-payload idempotent, different-payload collides — independently corroborates what ARMIGER-II/LECTOR-II read in writer.lisp); V-F: 63 vectors frozen, full frame-body octets pending for four named lawful reasons (R1 receipt rider 1) |
| 6. Re-emit five documents, zero open MRs, coherent receipt, still pre-code | **DONE** — R1 freeze `0f59cb8b`; MUST RESOLVE 11/11 closed as four-field closure records; receipt `80861ca7` gives explicit verdict only after closure (this repairs exactly the "sello contradice su propia ley" defect this ruling names in the FIRST receipt — a fair hit on `dd2d8787`) |

**NEW AUTHORITY in this ruling — D2 GRANTED:** "La disposición D2 queda
concedida exactamente para esta lane y no nombra autoridad canónica, no
desbloquea Surface /3 y no involucra Surface Account /0." This is the grant
the English ruling had DEFERRED until R1 PASS, in essentially the operative
shape the contract's §0.1.2/§2.3 requested (lane-local; no canonical
authority named; Surface /3 not unlocked; Surface Account untouched). The
chair records it as GRANTED-BY-INSTRUMENT, with sequencing noted: the grant
was written against the pre-R1 state; the R1 PASS the English ruling required
now exists (`80861ca7`).

**⚠ THE ONE GENUINE CONFLICT — act-id derivation basis (OWNER DECISION
NEEDED):**

- **English R1 ruling, Repair A:** the act identity "must … **not be derived
  from the source request**, Core /0 attempt ordinal, Capability /2 attempt
  identity, **runtime seat**, clock, randomness, allocation order, or host
  object identity" — it derives from an explicit lane-local `act-token`
  declared in the fixture. *This is what the R1 bundle implements (ACT-2/ACT-3).*
- **This R0.1 ruling, item 1:** "Acuñar `act-id` como identificador CD/0
  determinista **sobre `seat-id + canonical-request`**" — i.e. derived from
  exactly two of the bases the English ruling forbids.

Both are owner instruments, same day, contradictory on this one point. The
implemented state follows the English ruling (explicit token; request and
seat recorded beside it in the fixture row, related-not-derived). Note the
substantive difference: token-based identity permits two acts over the same
seat+request to be distinct (the pre-frontier-reuse rule needs this);
seat+request-derived identity makes act-id collision structural for retries.
The chair holds the English/R1 implementation and does NOT re-edit on its own
authority. **Owner: one word settles it — "token" (keep as built) or
"derived" (reopen §2A).**

**Custody:** this ruling verifies the FIRST parcel's hash and structure clean
(13 files, manifest 11/11, sidecar valid) — matches the chair's records.

**Chair disposition:** no document edit performed under this ruling tonight
(its commission is discharged by the R1 round except where it conflicts, and
the conflict is the owner's to settle). Filed, mapped, and carried into the
session handoff for the next chair.
