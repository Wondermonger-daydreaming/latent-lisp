import json

from util import canonical_json_bytes


def normalize(raw_bytes):
    artifact = json.loads(raw_bytes.decode("utf-8"))
    return canonical_json_bytes({"normalization_version": "lae-normalizer/0.2", "content": artifact})
