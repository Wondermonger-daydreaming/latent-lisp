# AP0 Generator / Validator Independence Note

The packet generator and vector validator are separate source files.

- `tools/generate_ap0_packet.py` owns fixture construction and its PJ-S/0 emitter.
- `tools/validate_ap0_vectors.py` does not import the generator. It implements an independent scanner/parser and independent semantic checks.
- `tools/run_fake_adapter.py` does not import either generator or validator.
- `tools/run_mutation_suite.py` imports only the validator to test its planted negative controls; it does not generate fixtures.

This separation is stronger than a copied validator but weaker than an independently seeded implementation in another language or team. The packet therefore claims self-consistency certification only.
