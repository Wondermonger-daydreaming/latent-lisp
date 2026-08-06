#!/usr/bin/env python3
"""R4 extraction: probe-identity.lisp -> production/surface-account.lisp.

Mechanical, so the correspondence is a diff, not a story. The deltas applied
here are exactly the ledger's D1-D5; everything else is byte-carried.
"""
import re, sys, pathlib

probe = pathlib.Path(sys.argv[1]).read_text()
out = pathlib.Path(sys.argv[2])

lines = probe.split("\n")  # 0-based

# --- D1: drop the probe banner (lines 1..144 1-based -> 0..143), keep from
# the (in-package ...) line onward.  Line 145 (0-based 144) must be the
# in-package form; verify rather than assume.
assert lines[145].strip() == "(in-package #:cl-user)", lines[145]
body = lines[145:]

# --- D5: omissions.
text = "\n".join(body)

# (a) the three witness-only state readers + the five symbol macros.
# The readers block: sa0-epoch-octets-value / sa0-performance-mutex /
# sa0-performance-counter one-liners; symbol macros block.
text = re.sub(
    r"\(defun sa0-epoch-octets-value \(\).*?\n", "", text)
text = re.sub(
    r"\(defun sa0-performance-mutex \(\).*?\n", "", text)
text = re.sub(
    r"\(defun sa0-performance-counter \(\).*?\n", "", text)
text = re.sub(
    r"\(define-symbol-macro [^\n]*\n", "", text)

# (b) everything from performance-identifier-from-texts to EOF except nothing
# after it that we keep -- the tail sections: performance-identifier-from-texts,
# performance-counter-of, performance-epoch-of, and the identity-bases section.
idx = text.index("(defun performance-identifier-from-texts")
# also drop the section comment block immediately preceding? that comment block
# belongs to ASCII alphabet section... no: from-texts has only its own docstring.
text = text[:idx]
# strip trailing whitespace-only remainder
text = text.rstrip() + "\n"

# --- D1: in-package
text = text.replace("(in-package #:cl-user)",
                    "(in-package #:lisp-plus-surface-account)")

# --- D4: renames to export names (code + prose casings).
renames = [
    ("sa0-initialize-image-identity", "initialize-image-identity"),
    ("sa0-identity-ready-p", "identity-ready-p"),
    ("sa0-epoch-gatherings", "epoch-gatherings"),
    ("sa0-election-count", "election-count"),
    ("sa0-epoch-hex", "image-epoch-hex"),
    ("sa0-epoch-datum", "image-epoch-datum"),
]
for old, new in renames:
    text = re.sub(re.escape(old), new, text)
    text = re.sub(re.escape(old.upper()), new.upper(), text)

# careful fallout: the state accessors sa0-state-epoch-hex / sa0-state-epoch-datum
# must NOT have been renamed (they contain '-epoch-hex' but with 'state-' prefix,
# and the regexes above required the literal 'sa0-epoch-hex').  Verify:
assert "sa0-state-epoch-hex" in text and "sa0-state-image-epoch" not in text

# the constructor read the epoch through the (now deleted) symbol macro:
text = text.replace("*image-epoch-hex*", "(image-epoch-hex)")
# ...but that also hits prose mentions; acceptable in comments, must be exact in
# the one code site:
assert '(list "performance" (image-epoch-hex) (format nil "~D" counter))' in text

# --- D2: refusal prefix.
text = text.replace("SA0 PROBE:", "SURFACE-ACCOUNT/0:")

# --- D3: lock/waitqueue diagnostic names.
text = text.replace("sa0-probe-identity-cell", "sa0-production-identity-cell")
text = text.replace("sa0-probe-performance-allocator",
                    "sa0-production-performance-allocator")

header = """;;;; surface-account.lisp — Surface Account /0, production implementation.
;;;;
;;;; ==========================================================================
;;;; R4 PRODUCTION SOURCE — the accepted R3.3.3 identity mechanism, extracted
;;;; conservatively from probes/probe-identity.lisp at tip 2c1ac711.  The
;;;; probe file is the executable oracle; this file is that mechanism given a
;;;; package and an address, and NOTHING ELSE.  The complete probe->production
;;;; delta is enumerated in ../R4/R4-PRODUCTION-DESIGN-LEDGER.md (D1-D6) and
;;;; is proven byte-honest by the extraction script recorded there; do not
;;;; edit this file without re-deriving that correspondence.
;;;;
;;;; THE MECHANISM (accepted and frozen as an executable contract; see the
;;;; oracle's own header for the full R3.3->R3.3.3 history, which is not
;;;; duplicated here):
;;;;   * one process-wide identity state, carried on the property list of the
;;;;     interned symbol SA0-IDENTITY-CARRIER (established by interning,
;;;;     always bound, CAS-able, written by exactly ONE CAS in this source —
;;;;     grep this file for SYMBOL-PLIST);
;;;;   * exactly one epoch gathering: sixteen octets from /dev/urandom, one
;;;;     lowercase-hex textual projection;
;;;;   * a single DISPOSITION slot: the complete state and the failure token
;;;;     compete by CAS-from-NIL for ONE place — state-present and
;;;;     failure-present are mutually exclusive by construction;
;;;;   * reserved-slot adjudication by a TOTAL read-only shape walk
;;;;     (SA0-SCAN-RESERVED: lawful NIL end / improper terminal atom / odd
;;;;     list / dotted value position / cycle, EQ-identity visited set);
;;;;   * a total election preserving unrelated carrier properties by identity;
;;;;   * bounded owner re-entry (EQ on the owning thread), terminal failure,
;;;;     waiting observers under a hard bound;
;;;;   * a mutex-linearizable allocator (counter starts 0, first allocation 1)
;;;;     and the ONE performance-identifier constructor
;;;;     ("performance" <epoch-hex> <counter-decimal>);
;;;;   * the canonical ASCII decimal counter alphabet (R3.3-C): explicit
;;;;     FIND/EQL membership in 0123456789, first character from 123456789 —
;;;;     DIGIT-CHAR-P, Unicode numeric properties, locale classification and
;;;;     PARSE-INTEGER-as-admission rejected by name;
;;;;   * NO DEFSTRUCT and NO DEFINE-CONDITION (the concurrent
;;;;     layout-redefinition scar — this source is loadable concurrently by
;;;;     design); refusals are plain errors with exact greppable text;
;;;;   * no defining form carries live once-only state (the delayed-DEFGLOBAL
;;;;     scar): the carrier and the election log live on interned symbols'
;;;;     property lists, the test hook on a third.  (The carrier-writer
;;;;     census — one CAS, no SETF — is checked mechanically by the hostile
;;;;     runner's ST-1; a bare grep of this file for SYMBOL-PLIST also hits
;;;;     the election-log symbol and two comments, so use ST-1's grep, not a
;;;;     bare one, to reproduce the count.)
;;;;
;;;; LOAD-TIME BEHAVIOUR — READ THIS BEFORE GUARDING A LOAD OF THIS FILE.
;;;; The once-only initialization runs at load time from a form that sits
;;;; MID-FILE — at line {{INIT-LINE}} of {{TOTAL-LINES}}, column-0
;;;; top-level form {{INIT-FORM}} of {{TOTAL-FORMS}} (both censuses
;;;; MACHINE-DERIVED by R4/extract-production.py from this very file at
;;;; generation time; a hand-written coordinate here went stale once,
;;;; R4.2) — the oracle-faithful placement, carried
;;;; verbatim under ledger delta D6, with several public functions
;;;; (IMAGE-EPOCH-HEX, IMAGE-EPOCH-DATUM, MINT-PERFORMANCE-IDENTIFIER,
;;;; PERFORMANCE-IDENTIFIER-SHAPE-P, LAWFUL-COUNTER-TEXT-P) defined AFTER
;;;; it.  Consequence (STRANGER's R4 finding): a load that fails AT the
;;;; initialization leaves the package present with those five exports
;;;; unbound, so "the package exists" NEVER means "this lane is loaded" —
;;;; and FBOUNDP alone never means "this is the public API" either (the
;;;; owner's R4.3 counterexample: nine INTERNAL fbound dummies satisfied
;;;; the R4.1 status-blind guard).  Every loader of this lane must
;;;; therefore guard on EXTERNAL-API completeness — every declared name
;;;; present with FIND-SYMBOL status :EXTERNAL and FBOUNDP, and the
;;;; identity carrier symbol present — repairing an incomplete package by
;;;; re-applying package.lisp BEFORE this file, and asserting the same
;;;; predicate after the load, as production/load.lisp and the umbrella's
;;;; SURFACE-ACCOUNT-API-COMPLETE-P row do (R4.3).  A fresh image gathers;
;;;; a reload observes (same epoch, counter continues); a recursive load
;;;; inside an unfinished initialization defers to its owner; a failed
;;;; image is terminal — and in a terminal image the five late exports
;;;; never become defined, which is exactly why the guarded loaders refuse
;;;; rather than certify.
;;;;
;;;; BOUNDARY: qualified external CD/0 symbols only; no other provider is
;;;; touched.  Supported: SBCL 2.4.6 on Linux, nothing else tested.
;;;; ==========================================================================

"""

# --- R4.2: the init-form coordinate is COMPUTED from the assembled output,
# never hand-written (R4.1-STALE-INIT-FORM-COORDINATE: a hand-maintained
# "form 1032 of 1191" survived a 17-line header growth and went stale; a
# number code can generate, code must generate).  The placeholders sit on
# lines whose COUNT the substitution cannot change, so the computed line
# numbers remain valid after substitution.
final = header + text
lines = final.split("\n")
total_lines = len(lines) - (1 if lines and lines[-1] == "" else 0)
init_line = None
form_index = None
total_forms = 0
for i, ln in enumerate(lines, start=1):
    if ln.startswith("("):
        total_forms += 1
        if ln == "(initialize-image-identity)":
            assert init_line is None, "init form found twice"
            init_line, form_index = i, total_forms
assert init_line is not None, "init form not found"
for k, v in (("{{INIT-LINE}}", init_line), ("{{TOTAL-LINES}}", total_lines),
             ("{{INIT-FORM}}", form_index), ("{{TOTAL-FORMS}}", total_forms)):
    assert final.count(k) == 1, k
    final = final.replace(k, str(v))

out.write_text(final)
print("wrote", out, total_lines, "lines;",
      f"init form at line {init_line} of {total_lines}, "
      f"column-0 top-level form {form_index} of {total_forms}")
