import argparse
import tempfile
from pathlib import Path

from analyze import analyze
from conditions import ReceiptDigestMismatch
from run import execute
from score import score_run
from util import canonical_json_bytes, load_json, sha256_file, write_new_bytes


def full_replay(items, expected_analysis=None, output=None):
    if output is None:
        context = tempfile.TemporaryDirectory(prefix="lae-replay-")
        root = Path(context.name)
    else:
        context = None
        root = Path(output)
        root.mkdir(parents=True, exist_ok=True)
    execute(items, root / "run")
    rows = score_run(root / "run", root / "scores")
    receipt = analyze(rows)
    write_new_bytes(root / "analysis.json", canonical_json_bytes(receipt))
    if expected_analysis and Path(expected_analysis).read_bytes() != (root / "analysis.json").read_bytes():
        raise ReceiptDigestMismatch("synthetic analysis bytes diverged")
    result = {"analysis_sha256": sha256_file(root / "analysis.json"), "census_sha256": sha256_file(root / "run/census.json"), "root": str(root)}
    if context:
        context.cleanup()
    return result


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--items", required=True)
    parser.add_argument("--expected-analysis")
    parser.add_argument("--output", required=True)
    args = parser.parse_args()
    result = full_replay(args.items, args.expected_analysis, args.output)
    print(f"SYNTHETIC-REPLAY: PASS analysis_sha256={result['analysis_sha256']}")


if __name__ == "__main__":
    main()
