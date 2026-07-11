#!/usr/bin/env python3
"""
gen_matched_pairs.py v0.1 — tree-space-paired item generator for E0/E1.

STATUS: conceptual skeleton with known-sound task targets. NOT preflight-
passed. Run AUDIT-0001 gates 1-7,9,10 against this before trusting output.
Stimuli are `synthetic-sexpr` (structure-isolating, distributionally
unrealistic). The realistic executable suite is an E4 deliverable.

v0.1 CORRECTIONS (per second cross-lineage audit, ledger @event-005):
  - Open-ended 70%-completion RETIRED: hidden suffix contained arbitrary
    generator choices; the target was unknowable. Replaced by
    delimiter-completion (closer suffix forced by balance) and synthesis.
  - Pairing in TREE SPACE: one abstract intervention chosen on the
    canonical AST (by node id), rendered into every condition.
  - Conditions B (anonymous), D (consistent-arbitrary label), and M
    (mismatch probe) added; B/D are the real controls, not padding.
  - All randomness flows from the passed rng (v0's pad_to_tokens used the
    global unseeded generator -> non-reproducible items).
  - Token matching measured on the PROMPT (executor: swap in the real
    tokenizer per model; report per-item per-condition counts; spread<=2%).

TRIVIAL-PASS WARNINGS (unchanged, still load-bearing):
  1. Never score 'what does @end:X close' (information availability).
  2. Generated items stay OUT of few-shot prompts.
  3. Judge in ONE stripped representation across conditions.
"""

import random, json, argparse
from dataclasses import dataclass, field

ATOMS = ["x", "y", "n", "xs", "acc", "k", "lo", "hi", "seed", "item"]
HEADS = ["let*", "if", "cond", "map", "fold", "when", "match", "begin"]

# ------------------------------------------------------------------ tree --

@dataclass
class Node:
    nid: int
    head: str
    kids: list = field(default_factory=list)
    atom: str | None = None

class TreeBuilder:
    def __init__(self, rng):
        self.rng, self.counter, self.registry = rng, 0, {}
    def new(self, **kw):
        n = Node(nid=self.counter, **kw); self.registry[self.counter] = n
        self.counter += 1; return n
    def gen_expr(self, depth):
        """Exact-depth tree: one spine child carries remaining depth,
        siblings are shallow distractors (failures concentrate where deep
        spines sit among plausible shallow content)."""
        if depth == 0:
            return self.new(head="", atom=self.rng.choice(ATOMS))
        spine = self.rng.randrange(1, 4)
        kids = [self.gen_expr(depth - 1) if i == spine
                else self.gen_expr(self.rng.randint(0, min(2, depth - 1)))
                for i in range(1, 4)]
        return self.new(head=self.rng.choice(HEADS), kids=kids)

# ------------------------------------------------------- shared rendering --
# The BODY is rendered once and shared verbatim across conditions, so any
# character offset inside the body corresponds across conditions exactly.

def render_body(node, indent=1, _offsets=None, _pos=0):
    """Render AND record each internal node's closing-paren offset in one
    pass. v0.1 lesson: a parallel offset-walk drifted from the renderer;
    instrumenting the renderer itself makes drift impossible."""
    if _offsets is None:
        s, _ = _render(node, indent, {}, 0)
        return s
    return _render(node, indent, _offsets, _pos)

def _render(node, indent, offsets, pos):
    if node.atom is not None:
        return node.atom, pos + len(node.atom)
    s = f"({node.head} "
    p = pos + len(s)
    parts = []
    first = True
    for k in node.kids:
        if not first:
            s += " "; p += 1
        if k.atom is not None:
            frag, p = _render(k, indent + 1, offsets, p)
        else:
            lead = "\n" + "  " * (indent + 1)
            s += lead; p += len(lead)
            frag, p = _render(k, indent + 1, offsets, p)
        s += frag
        first = False
    offsets[node.nid] = p          # this node's ")"
    return s + ")", p + 1

def render_body_with_offsets(node, indent=1):
    offsets = {}
    s, _ = _render(node, indent, offsets, 0)
    return s, offsets

def wrap(condition, name, body, rng, mismatch=False):
    """Only the wrapper differs across A/B/C/D; body is byte-identical."""
    if condition == "A":
        return f"(define ({name} xs)\n  {body})"
    if condition == "B":
        return f"(definition@ ({name} xs)\n  {body}\n@end)"
    if condition == "C":
        end = name if not mismatch else rng.choice(
            [a for a in ATOMS if a != name]) + "z"
        return f"(definition@{name} ({name} xs)\n  {body}\n@end:{end})"
    if condition == "D":
        g = f"g{rng.randrange(1000, 9999)}"
        return f"(definition@{g} ({name} xs)\n  {body}\n@end:{g})"
    if condition == "E":
        return (f"(definition@{name} ({name} xs)\n"
                f"  claims:\n    (example :input ((1 2 3)) :returns 2)\n"
                f"  effects: ()\n  {body}\n@end:{name})")
    raise ValueError(condition)

# ------------------------------------------------ tree-space interventions --

def make_interventions(builder, root_body_node, body, rng):
    """One abstract task set on the canonical tree; identical across
    conditions because it addresses the shared body string / node ids."""
    internal = [n for n in builder.registry.values()
                if n.atom is None and n is not root_body_node]
    corrupt_target = rng.choice(internal) if internal else root_body_node
    _, offsets = render_body_with_offsets(root_body_node)
    off = offsets[corrupt_target.nid]
    # delimiter-completion: strip trailing run of closers/whitespace
    i = len(body)
    while i > 0 and body[i-1] in ") \n":
        i -= 1
    # insertion: a validated internal node; append as its LAST child + 1
    ins = rng.choice(internal) if internal else root_body_node
    return {
        "delimiter_completion": {"shown": body[:i],
                                 "stripped_closers": body[i:]},
        "repair": {"target_nid": corrupt_target.nid, "closer_offset": off},
        "insertion": {"target_nid": ins.nid,
                      "position": len(ins.kids),   # append -> always valid
                      "form": "(probe acc)"},
    }

# -------------------------------------------------------- token matching --

def measure_tokens(text):
    """PLACEHOLDER (chars/4). Executor: replace with the actual tokenizer
    of each model under test; record real counts in the item; enforce
    <=2% cross-condition spread (preflight gate 6)."""
    return max(1, len(text) // 4)

def build_prompt(source_or_task_text, instruction, pad_lines):
    pad = "".join(f";; pad {w}\n" for w in pad_lines)
    return f"{pad}{instruction}\n\n{source_or_task_text}"

def match_prompts(prompts_by_cond, rng):
    """Pad SHORTER PROMPTS (the thing actually sent) up to the longest,
    with seeded inert comment lines placed identically (leading block)."""
    target = max(measure_tokens(p) for p in prompts_by_cond.values())
    out = {}
    for cond, p in prompts_by_cond.items():
        lines = []
        while measure_tokens(build_prompt(p, "", lines)) < target:
            lines.append(" ".join(rng.choices(ATOMS, k=3)))
        out[cond] = {"prompt": build_prompt(p, "", lines),
                     "measured_tokens_placeholder": measure_tokens(
                         build_prompt(p, "", lines))}
    return out

# ------------------------------------------------------------------ main --

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--n", type=int, default=200)
    ap.add_argument("--depths", type=str, default="4,8,12,16,20")
    ap.add_argument("--seed", type=int, default=33)
    ap.add_argument("--mismatch-frac", type=float, default=0.15)
    ap.add_argument("--out", type=str, default="items.jsonl")
    args = ap.parse_args()
    rng = random.Random(args.seed)
    depths = [int(d) for d in args.depths.split(",")]

    with open(args.out, "w") as f:
        for i in range(args.n):
            item_rng = random.Random((args.seed, i).__hash__())
            b = TreeBuilder(item_rng)
            d = depths[i % len(depths)]
            name = f"fn{i:03d}"
            body_node = b.gen_expr(d)
            body = render_body(body_node)
            tasks = make_interventions(b, body_node, body, item_rng)
            is_mismatch = item_rng.random() < args.mismatch_frac
            conds = {c: wrap(c, name, body, item_rng)
                     for c in "ABCDE"}
            record = {
                "id": i, "depth": d, "name": name,
                "stimulus_class": "synthetic-sexpr",
                "item_set": "M" if is_mismatch else "primary",
                "conditions": conds,
                "mismatch_variant": (wrap("C", name, body, item_rng,
                                          mismatch=True)
                                     if is_mismatch else None),
                "tasks": tasks,
                "prompts_delimiter_completion": match_prompts(
                    {c: conds[c][:len(conds[c])
                        - len(tasks["delimiter_completion"]["stripped_closers"])
                        - (0 if c == "A" else 0)]  # executor: per-cond suffix
                     for c in "ABCD"}, item_rng),
            }
            f.write(json.dumps(record) + "\n")
    print(f"wrote {args.n} items ({args.mismatch_frac:.0%} M-probe) -> {args.out}")
    print("REMINDER: run AUDIT-0001 gates before any API spend.")

if __name__ == "__main__":
    main()
