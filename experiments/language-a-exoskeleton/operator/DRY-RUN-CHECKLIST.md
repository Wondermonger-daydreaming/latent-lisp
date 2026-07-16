# Synthetic dry-run checklist

- Confirm inputs are marked synthetic-only and permanently tainted.
- Confirm only provider_dry_run.py is importable by the runner selection.
- Confirm no credential, provider route, model release, real item, key, or price table is present.
- Prove private-key-path open is denied, not merely absent.
- Generate design derivatives and verify schedule digest.
- Run request, response, raw, normalization, synthetic scoring, analysis, replay, lineage, and claim lint.
- Record network-call census as zero and billed cost as USD 0.00.
- Preserve output immutably; use a fresh directory for a successor run.
