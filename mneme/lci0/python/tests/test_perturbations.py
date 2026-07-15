from __future__ import annotations

import json
import os
import random
import subprocess
import sys
import unittest

import cd0

from lci0.core import CD0_BUDGET, canonical_bytes, project_claim_id
from lci0.package import fixture_datum, iter_vectors
from lci0.protocol import request as differential_request
from lci0.runner import run_request


PROPERTY_SEED = 0x4C434930
PROPERTY_CASES = 256


class MutationAndPerturbationTests(unittest.TestCase):
    def test_deterministic_random_record_allocation_and_source_mutation(self):
        source = fixture_datum("claim-id.file-alpha-neutral")
        baseline = project_claim_id(source).canonical_bytes
        rng = random.Random(PROPERTY_SEED)
        for case in range(PROPERTY_CASES):
            fields = list(source.fields)
            rng.shuffle(fields)
            independently_allocated = cd0.record(fields)
            buffer = bytearray(canonical_bytes(independently_allocated))
            decoded = cd0.decode_exact(buffer, CD0_BUDGET)
            before = project_claim_id(decoded).canonical_bytes
            if buffer:
                buffer[rng.randrange(len(buffer))] ^= 0x01
            with self.subTest(case=case):
                self.assertEqual(before, baseline)
                self.assertEqual(project_claim_id(decoded).canonical_bytes, baseline)

    def test_json_dictionary_insertion_order_does_not_change_runner_result(self):
        row = next(iter_vectors())
        value = row["inputs"]["canonical_cd0_hex"]
        source = differential_request("perturbation:dictionary-order", row["operation"], value)
        baseline = run_request(source)
        # Perturb the containing JSON object through independently allocated,
        # insertion-order-distinct dictionaries.
        for _ in range(PROPERTY_CASES):
            request = dict(reversed(list(source.items())))
            self.assertEqual(run_request(request), baseline)

    def test_separate_process_hash_seed_locale_and_runtime_state(self):
        row = next(iter_vectors())
        request = json.dumps(
            differential_request(
                "perturbation:separate-process",
                row["operation"],
                row["inputs"]["canonical_cd0_hex"],
            ),
            separators=(",", ":"),
        ) + "\n"
        outputs = []
        for hash_seed, locale_name in (("0", "C"), ("1", "C"), ("42", "C.utf8"), ("4294967295", "POSIX")):
            environment = dict(os.environ)
            environment["PYTHONHASHSEED"] = hash_seed
            environment["LC_ALL"] = locale_name
            completed = subprocess.run(
                [sys.executable, "-m", "lci0.runner"],
                input=request,
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                check=False,
                env=environment,
            )
            with self.subTest(hash_seed=hash_seed, locale=locale_name):
                self.assertEqual(completed.returncode, 0, completed.stderr)
                outputs.append(completed.stdout)
        self.assertEqual(len(set(outputs)), 1)


if __name__ == "__main__":
    unittest.main()
