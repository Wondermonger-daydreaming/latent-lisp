# Language-A emission pilot — Tranche B candidate bank and renderer

Summary: This successor canonicalizes the owner-accepted 24-item public content bank as candidate records and implements the exact 312-request network-off rendering and custody path. It does not freeze the bank, create a private key, score a target response, call a provider, retain target output, or authorize exposure.

The F1 target-visible surface is exactly the arm-neutral task plus finite source packet. Family, role, tags, boundary and rendering metadata, and owner dispositions remain in a separate control plane. Private freezer dossiers are validated into an owner-private local package outside Git; the repository retains only their 24 strict external identity records. The runtime reads only `items/candidate/target-visible/`, `tranche-b/templates/`, the fixed candidate schedule, its template manifest, and the strict schema bundle.

The Tranche B path is implemented in `harness/tranche_b.py`. The predecessor scorer-coupled synthetic fixture path remains only to preserve inherited regression tests and is not used for candidate-bank traversal or Tranche B evidence.

Repair 0.2.1 keeps both owner decisions unresolved. A future ODR-43 successor must declare exactly one exposure row for each of `item-specific-answer`, `private-key`, and `target-output`; three duplicate rows do not close the gate. Tranche B records only the byte length, digest, item/version binding, source identity, custody basis, and exclusions of each owner-private external dossier. Dossier content remains outside Git and excluded from `KEY-AUTHOR-INPUT`.

The proposed design is declarative in `items/design/design.json`. Running `python3 harness/design.py` regenerates the schedule and count census. A permitted pre-exposure design change under Errata 0.1 must change that one record and regenerate all dependent artifacts before a new manifest is built.

Local construction verification:

    bash verify-pilot.sh

Tranche B targeted verification:

    bash verify-tranche-b.sh

Exposure readiness is deliberately unavailable:

    python3 harness/manifest.py exposure-readiness

That command must fail while any owner slot, lineage stopping rule, real bank/key freeze, or signed pre-exposure gate remains open.

SHAM is a diagnostic subset only. It can assign exactly one tri-status and bounded descriptive contrasts. It cannot establish efficacy, eliminate ceremonial salience, explain novelty or placebo-like uptake, or rescue the primary LANG-A versus SCAFFOLD contrast.

P2a is absent and `DORMANT-BUT-AUTHORIZED`; P2b and production corroboration infrastructure are outside this packet.
