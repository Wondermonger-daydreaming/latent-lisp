# LCI/0 Python fixture implementation

This directory implements the authorized Lisp+ Located Claim Identity /0
fixture profile. It is deliberately inert: it exposes ClaimId projection,
WarrantTarget validation and pure matching, finite fixture-policy evaluation,
fixture calculi, represented-loss validation, and bounded v1 migration data. It
does not expose WarrantId, live warrants, production standing, capabilities,
cryptography, module authority, custody, or a legacy runtime loader.

The fixture JSON adapter in `lci0/adapter.py` is separate from and does not
modify the frozen CD/0 codec. The differential runner in `lci0/runner.py`
accepts only canonical vector-input CD/0 octets on standard input; it never
opens the vector package and cannot read expected results.

Run the seed suite from the repository root:

```sh
PYTHONPATH=mneme/lci0/python:canonical-datum/python \
  python3 -m unittest discover -s mneme/lci0/python/tests -v
```

Run one differential request:

```sh
printf '%s\n' '{"input_canonical_hex":"..."}' | \
  PYTHONPATH=mneme/lci0/python:canonical-datum/python python3 -m lci0.runner
```

The correct isolation statement is: independently seeded under shared
normative infrastructure, with procedural—not OS-enforced—isolation.
