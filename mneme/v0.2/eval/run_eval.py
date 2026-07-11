#!/usr/bin/env python3
"""
run_eval.py — E0/E1 harness skeleton. ~90% right; last-mile fixes expected.

DESIGN INTENT:
  - implementation-as-judge: every model answer is PARSED; scoring is
    parse-validity + AST-equality against ground truth, never string match.
  - conditions C/E are stripped to A-surface before AST comparison
    (strip_annotations) so the judge is condition-blind.
  - condition F = condition A + tool loop: the model may call
    inspect(source) -> node listing before answering. If F >> C on
    reading tasks, the boundary feature lives in the INTERFACE (H-tools),
    which is a finding, not a failure — report it as such.
"""
import json, re, sys

def strip_annotations(src: str) -> str:
    """C/E surface -> A surface. Judge in one representation only."""
    src = re.sub(r"\(definition@(\w+)", r"(define", src)
    src = re.sub(r"@end:\w+\)", ")", src)
    src = re.sub(r"^\s*(claims:|effects:).*?$", "", src, flags=re.M)
    src = re.sub(r"^\s*\(example .*?\)$", "", src, flags=re.M)
    src = re.sub(r"^\s*;;.*$", "", src, flags=re.M)  # padding comments
    return src

def parse_sexpr(src: str):
    """Minimal s-expr reader; raises on imbalance. Executor: consider
    replacing with the E4 `lp` tooling once it exists — the language
    judging its own eval is the point."""
    toks = re.findall(r"\(|\)|[^\s()]+", src)
    def rd(i):
        if toks[i] == "(":
            out, i = [], i + 1
            while toks[i] != ")":
                node, i = rd(i)
                out.append(node)
            return out, i + 1
        return toks[i], i + 1
    tree, i = rd(0)
    if i != len(toks):
        raise ValueError("trailing tokens / imbalance")
    return tree

def ast_equal(a: str, b: str) -> bool:
    return parse_sexpr(strip_annotations(a)) == parse_sexpr(strip_annotations(b))

def call_model(model: str, prompt: str, tools: bool = False) -> str:
    """STUB — wire to live APIs. >=3 models, >=1 non-Anthropic (E1 spec).
    Keep generated items OUT of any few-shot examples (trivial-pass #2)."""
    raise NotImplementedError("wire me")

def score_item(item, condition, model):
    src = item["conditions"][condition]
    truncated = item["tasks"][condition[0] if condition != "F" else "A"]["truncate"]
    answer = call_model(model, f"Complete this program:\n\n{truncated}",
                        tools=(condition == "F"))
    try:
        ok = ast_equal(answer, src)
        return {"parse_valid": True, "ast_correct": ok}
    except Exception as e:
        return {"parse_valid": False, "ast_correct": False, "err": str(e)}

if __name__ == "__main__":
    print("skeleton — see HANDOFF.md per-experiment reporting block")

# ---------------------------------------------------------------------------
# v0.1: FakeModel fixtures — preflight gate 10. The scorer must report
# each of these with the exact known score through the FULL scoring path
# (per-condition and per-depth aggregation included) before API spend.
# Honest recharacterization (per @event-005): this file is ~25% of a
# functioning pipeline and a conceptual skeleton — missing: live API calls,
# condition F tool loop, insertion/repair scoring wiring, clustered stats
# (item-blocked permutation per EXPERIMENTS.md), CIs, plots, reporting
# blocks. The judge below is a TOY: preflight gate 8 expects it to FAIL on
# corpus/design specimens and thereby force E4 (Racket reader as judge).
# ---------------------------------------------------------------------------

class FakeModel:
    """kind: perfect | null | malformed | checksum_blind"""
    def __init__(self, kind, ground_truth=None):
        self.kind, self.gt = kind, ground_truth
    def __call__(self, prompt):
        if self.kind == "perfect":   return self.gt
        if self.kind == "null":      return "(begin x y)"
        if self.kind == "malformed": return "(define (f x"
        if self.kind == "checksum_blind":
            # completes a mismatch-probe item WITHOUT flagging the bad
            # @end label — must score 0 on the M detection metric.
            return self.gt
        raise ValueError(self.kind)

def preflight_gate_10():
    """Expected scores: perfect->1.0/1.0, null->parse 1.0 ast 0.0,
    malformed->0.0/0.0, checksum_blind-> M-flag 0.0. Wire through the real
    aggregation path, not a shortcut."""
    raise NotImplementedError("executor: implement against final score path")
