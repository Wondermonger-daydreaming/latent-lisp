import argparse
import json
import re
from pathlib import Path

from conditions import (ForbiddenUnboundedClaim, InconclusiveNarratedAsNull,
                        LocalizedHarmOvergeneralized, MissingClaimCeilingRider,
                        ShamDiagnosticOverclaimed)


FORBIDDEN = (
    r"\blanguage a works\b", r"\blanguage a does not work\b", r"\blanguage a fails\b",
    r"\bthe approach is ineffective\b", r"\bthe pilot proves robustness\b",
    r"\bthe validator verified the answer\b", r"\bindependent models corroborated the result\b"
)
RIDERS = (
    ("pilot-scale", "frozen pilot"),
    ("first-pass emission",),
    ("sampled item", "item bank"),
    ("subject release",),
    ("route",),
    ("setting",),
    ("run window",),
    ("no inference to hidden reasoning", "does not establish hidden reasoning"),
    ("no inference to enforcement", "does not establish enforcement"),
    ("no inference to production custody", "does not establish production custody"),
    ("global independence",),
    ("totality",)
)


def lint_text(text, require_riders=False):
    normalized = " ".join(text.lower().split())
    for pattern in FORBIDDEN:
        if re.search(pattern, normalized):
            raise ForbiddenUnboundedClaim(pattern)
    if "sham" in normalized and re.search(r"(ruled out|eliminated|isolated|fully explained|causally removed|proves)", normalized) and re.search(r"(ceremonial|novelty|placebo|surface|salience)", normalized):
        raise ShamDiagnosticOverclaimed(text)
    if "inconclusive" in normalized and re.search(r"(is|means|establishes|shows) (a )?null", normalized):
        raise InconclusiveNarratedAsNull(text)
    if "b-harm" in normalized and re.search(r"language a (is harmful|harms|fails)\b", normalized) and not re.search(r"(family|subject|contrast|surface|localized|sampled)", normalized):
        raise LocalizedHarmOvergeneralized(text)
    if require_riders:
        missing = ["/".join(group) for group in RIDERS if not any(term in normalized for term in group)]
        if missing:
            raise MissingClaimCeilingRider(",".join(missing))


def claim_surfaces(path):
    path = Path(path)
    if path.suffix == ".json":
        value = json.loads(path.read_text(encoding="utf-8"))
        stack = [value]
        while stack:
            node = stack.pop()
            if isinstance(node, dict):
                for key, child in node.items():
                    if key.lower() in {"claim", "conclusion", "summary", "abstract", "claim_surface"} and isinstance(child, str):
                        yield child
                    else:
                        stack.append(child)
            elif isinstance(node, list):
                stack.extend(node)
    else:
        for line in path.read_text(encoding="utf-8").splitlines():
            if re.match(r"^(Conclusion|Summary|Abstract|Claim surface):", line, re.IGNORECASE):
                yield line.split(":", 1)[1].strip()


def lint_path(path):
    surfaces = list(claim_surfaces(path))
    for surface in surfaces:
        lint_text(surface, require_riders=True)
    return len(surfaces)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("paths", nargs="+")
    args = parser.parse_args()
    count = sum(lint_path(path) for path in args.paths)
    print(f"CLAIM-CEILING-LINT: PASS surfaces={count}")


if __name__ == "__main__":
    main()
