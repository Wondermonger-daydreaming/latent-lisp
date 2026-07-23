#!/usr/bin/env python3
"""check-front-door.py — LIMES, the border-inspector.

Static "front-door purity" checker for a Common Lisp program written against
the governed Lisp+ Slice /0 public surface. It trusts NOTHING the program
claims about itself: it reads the bytes (regex/text checks) and the live
symbols (a loader-based external-symbol audit run as an SBCL subprocess).

Two layers:
  1. Byte-level text checks (this file): `::` access, record-slot mutation,
     stringify-laundering (heuristic), fallback serialization (heuristic).
  2. Symbol-level audit (check-external-symbols.lisp, run as a subprocess):
     every package-qualified reference to a governed package must resolve to
     an EXTERNAL (exported) symbol.

Verdict:
  HARD-VIOLATIONS: N
  HEURISTIC-FLAGS: M
  FRONT-DOOR: CLEAN                              (exit 0, when N == 0)
  FRONT-DOOR: N hard violation(s), M heuristic flag(s)   (exit 1, when N > 0)

stdlib only. Usage:  python3 check-front-door.py TARGET.lisp
"""

import os
import re
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))

# Record-accessor prefixes that identify a Lisp+/kernel0 record slot. A
# `(setf (<accessor> ...) ...)` into any of these is direct slot mutation.
ACCESSOR_PREFIXES = [
    "claim-", "witness-", "judgment-record-", "promotion-", "projection-",
    "transmission-", "receiver-context-", "local-value-", "derived-result-",
    "why-",
]

# Package qualifiers a mutation might carry (single-colon public surface).
_PKG_QUAL = r"(?:lisp-plus-slice0:|lisp-plus-kernel0:|dataset-lab:)?"


class Finding:
    __slots__ = ("severity", "line", "col", "check", "text", "note")

    def __init__(self, severity, line, col, check, text, note=""):
        self.severity = severity  # "hard" | "heuristic"
        self.line = line
        self.col = col
        self.check = check
        self.text = text
        self.note = note

    def render(self):
        loc = f"{self.line}:{self.col}" if self.line else "-"
        tag = "HARD" if self.severity == "hard" else "HEUR"
        s = f"  [{tag}] {self.check}  @{loc}  {self.text!r}"
        if self.note:
            s += f"\n         note: {self.note}"
        return s


def _line_col(text, pos):
    """1-based (line, col) for an absolute character offset."""
    line = text.count("\n", 0, pos) + 1
    last_nl = text.rfind("\n", 0, pos)
    col = pos - last_nl  # 1-based (col of first char after newline is 1)
    return line, col


def _in_string_or_comment_map(src):
    """Return a boolean list, one per char, True if that char is inside a
    Lisp string literal or a `;` line comment. A conservative lexer good enough
    to *annotate* (not to gate) — the `::` hard check flags raw regardless."""
    flags = [False] * len(src)
    i = 0
    n = len(src)
    in_str = False
    in_comment = False
    while i < n:
        c = src[i]
        if in_comment:
            flags[i] = True
            if c == "\n":
                in_comment = False
            i += 1
            continue
        if in_str:
            flags[i] = True
            if c == "\\":
                if i + 1 < n:
                    flags[i + 1] = True
                i += 2
                continue
            if c == '"':
                in_str = False
            i += 1
            continue
        # not in string/comment
        if c == ";":
            in_comment = True
            flags[i] = True
            i += 1
            continue
        if c == '"':
            in_str = True
            flags[i] = True
            i += 1
            continue
        i += 1
    return flags


# --------------------------------------------------------------------------
# Check 1: `::` package-internal access (HARD, raw text match — conservative).
# --------------------------------------------------------------------------
def check_double_colon(src, findings):
    smap = _in_string_or_comment_map(src)
    for m in re.finditer(r"::", src):
        pos = m.start()
        line, col = _line_col(src, pos)
        # Grab the qualified token around the `::` for the report.
        left = re.search(r"[A-Za-z0-9%*+<>=/!?.-]+$", src[:pos])
        right = re.match(r"[A-Za-z0-9%*+<>=/!?.-]+", src[pos + 2:])
        tok = (left.group(0) if left else "") + "::" + (right.group(0) if right else "")
        if smap[pos]:
            # `::` in a comment/string is TEXT, not package-internal access
            # (package-internal access happens only at the reader level, in
            # code). Surface it for human review, but do not fail a clean
            # program for mentioning `::` in prose. A laundering-via-eval-of-a-
            # string is the residual risk this heuristic hands to the custodian.
            findings.append(Finding(
                "heuristic", line, col, "double-colon-in-string/comment", tok,
                "HEURISTIC: `::` inside a string/comment — not package access "
                "by itself; flagged only in case a string is later eval'd."))
        else:
            findings.append(Finding(
                "hard", line, col, "double-colon-access", tok,
                "package-internal access via `::` — the front door forbids "
                "reaching non-exported symbols"))


# --------------------------------------------------------------------------
# Check 2: direct record-slot mutation (HARD): setf into an accessor, or
# any slot-value form.
# --------------------------------------------------------------------------
def check_slot_mutation(src, findings):
    acc_alt = "|".join(re.escape(p) for p in ACCESSOR_PREFIXES)
    # (setf (   [pkg:]<accessor-prefix><rest>   ...) ...)
    setf_re = re.compile(
        r"\(setf\s+\(\s*(" + _PKG_QUAL + r"(?:" + acc_alt + r")[A-Za-z0-9*+<>=/!?.-]*)",
        re.IGNORECASE,
    )
    for m in setf_re.finditer(src):
        line, col = _line_col(src, m.start())
        findings.append(Finding(
            "hard", line, col, "setf-record-slot", m.group(1),
            "direct mutation of a Lisp+/kernel0 record slot — governed records "
            "are read-only; refusals must come from governed acts"))
    # slot-value: reaching into a struct's slots directly.
    for m in re.finditer(r"\(\s*slot-value\b", src, re.IGNORECASE):
        line, col = _line_col(src, m.start())
        findings.append(Finding(
            "hard", line, col, "slot-value", src[m.start():m.start() + 40].split("\n")[0],
            "slot-value bypasses the public accessor surface"))


# --------------------------------------------------------------------------
# Check 3: host-object stringify-laundering (HEURISTIC).
# --------------------------------------------------------------------------
def check_stringify(src, findings):
    for m in re.finditer(r"\(\s*format\s+nil\b", src, re.IGNORECASE):
        line, col = _line_col(src, m.start())
        findings.append(Finding(
            "heuristic", line, col, "format-nil", "(format nil ...)",
            "HEURISTIC: `(format nil ...)` is fine for messages, but its output "
            "must NOT be handed to transmit/exercise as if it were the object. "
            "Human must confirm the string is not treated as the host object."))
    for fn in ("princ-to-string", "prin1-to-string", "write-to-string"):
        for m in re.finditer(r"\(\s*" + re.escape(fn) + r"\b", src, re.IGNORECASE):
            line, col = _line_col(src, m.start())
            findings.append(Finding(
                "heuristic", line, col, "stringify", f"({fn} ...)",
                "HEURISTIC: object->string; a laundering risk if the string is "
                "then transmitted/exercised as the object."))


# --------------------------------------------------------------------------
# Check 4: fallback serialization to force an object across the boundary
# (HEURISTIC).
# --------------------------------------------------------------------------
def check_serialization(src, findings):
    for pat, label, note in [
        (r"\bsb-ext\b", "sb-ext",
         "HEURISTIC: SBCL-internal namespace; watch for object-forcing "
         "(save-lisp-and-die, fasl tricks) to cross the boundary."),
        (r"\bmake-load-form\b", "make-load-form",
         "HEURISTIC: make-load-form serializes a host object's construction — "
         "a classic boundary-bypass; confirm it is not used to ship a value."),
        (r"\bwith-output-to-string\b", "with-output-to-string",
         "HEURISTIC: possible object->string capture; laundering risk if fed "
         "back across the boundary."),
        (r"\bread-from-string\b", "read-from-string",
         "HEURISTIC: string->object; paired with a stringify it is a manual "
         "write/read round-trip of a captured host object."),
    ]:
        for m in re.finditer(pat, src, re.IGNORECASE):
            line, col = _line_col(src, m.start())
            findings.append(Finding("heuristic", line, col, label, label, note))


# --------------------------------------------------------------------------
# Loader-based external-symbol audit (the robust layer), run as a subprocess.
# --------------------------------------------------------------------------
def run_symbol_audit(target_abspath):
    """Returns (hard_count, raw_output). hard_count counts governed
    internal-symbol references + read errors reported by the Lisp audit."""
    audit_lisp = os.path.join(HERE, "check-external-symbols.lisp")
    surface = os.path.join(HERE, "..", "slice0-transmissibility.lisp")
    validator = os.path.join(HERE, "task-inputs", "validator.lisp")
    for path, what in ((audit_lisp, "check-external-symbols.lisp"),
                       (validator, "task-inputs/validator.lisp")):
        if not os.path.exists(path):
            return (None, f"AUDIT-SETUP-ERROR: missing {what} at {path}")
    # Escape backslashes/quotes for the Lisp string literal.
    lisp_target = target_abspath.replace("\\", "\\\\").replace('"', '\\"')
    cmd = [
        "sbcl", "--non-interactive", "--no-userinit", "--no-sysinit",
        "--load", surface,
        "--load", validator,
        "--load", audit_lisp,
        "--eval", f'(check-external-symbols:audit "{lisp_target}")',
    ]
    try:
        proc = subprocess.run(cmd, cwd=HERE, capture_output=True, text=True,
                              timeout=180)
    except FileNotFoundError:
        return (None, "AUDIT-ERROR: sbcl not found on PATH")
    except subprocess.TimeoutExpired:
        return (None, "AUDIT-ERROR: sbcl audit timed out (>180s)")
    out = (proc.stdout or "") + (proc.stderr or "")
    n = None
    for line in out.splitlines():
        mm = re.search(r"EXTERNAL-SYMBOL-AUDIT:\s+(\d+)\s+internal-symbol", line)
        if mm:
            n = int(mm.group(1))
    if n is None:
        # The audit did not reach its summary line — surface as a finding but
        # do not silently pass. Non-zero returncode implies a problem.
        note = ("AUDIT-INCOMPLETE: no summary line produced; returncode="
                f"{proc.returncode}")
        return (None, out + "\n" + note)
    return (n, out)


# --------------------------------------------------------------------------
def main(argv):
    if len(argv) != 2:
        sys.stderr.write("usage: python3 check-front-door.py TARGET.lisp\n")
        return 2
    target = argv[1]
    if not os.path.exists(target):
        sys.stderr.write(f"error: target file not found: {target}\n")
        return 2
    target_abs = os.path.abspath(target)
    with open(target_abs, "r", encoding="utf-8", errors="replace") as f:
        src = f.read()

    findings = []
    check_double_colon(src, findings)
    check_slot_mutation(src, findings)
    check_stringify(src, findings)
    check_serialization(src, findings)

    print("=" * 72)
    print(f"LIMES front-door purity check :: {target_abs}")
    print("=" * 72)

    # --- byte-level findings ---
    hard = [f for f in findings if f.severity == "hard"]
    heur = [f for f in findings if f.severity == "heuristic"]

    print("\n-- byte-level checks --")
    if not findings:
        print("  (no text-level findings)")
    else:
        for f in findings:
            print(f.render())

    # --- symbol-level audit ---
    print("\n-- loader-based external-symbol audit --")
    audit_n, audit_out = run_symbol_audit(target_abs)
    for line in audit_out.splitlines():
        if (line.startswith(";") or "EXTERNAL-SYMBOL-AUDIT" in line
                or "AUDIT-" in line):
            print("  " + line)
    audit_hard = 0
    if audit_n is None:
        # Could not get a clean count — treat as a hard finding (fail closed).
        audit_hard = 1
        print("  [HARD] symbol-audit-incomplete  the loader audit did not "
              "produce a clean count; failing closed")
    else:
        audit_hard = audit_n
        if audit_n > 0:
            print(f"  [HARD] {audit_n} governed internal-symbol reference(s) "
                  "(see lines above)")

    # --- verdict ---
    hard_count = len(hard) + audit_hard
    heur_count = len(heur)
    print("\n" + "-" * 72)
    print(f"HARD-VIOLATIONS: {hard_count}")
    print(f"HEURISTIC-FLAGS: {heur_count}")
    if hard_count > 0:
        print(f"FRONT-DOOR: {hard_count} hard violation(s), "
              f"{heur_count} heuristic flag(s)")
        return 1
    print("FRONT-DOOR: CLEAN")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
