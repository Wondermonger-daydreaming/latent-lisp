#!/usr/bin/env python3
r"""form-boundaries.py — byte offsets of TOP-LEVEL FORM BOUNDARIES in a Lisp file.

ERRATA 0.3 / D4.  The fail-open the stranger audit exploited was a file CUT AT A
CLEAN TOP-LEVEL FORM BOUNDARY: the reader sees a complete program, `--load` exits 0,
and the checks below the cut simply never ran.  A teeth control that cut mid-form
would be testing the READER, not the gate.  So the cuts are computed, not eyeballed.

Scans with paren depth, honouring `;` line comments, `#| |#` block comments (nested),
`"` strings with backslash escapes, and `#\c` character literals.  Prints one byte
offset per line: the position just past each top-level form (and its trailing
newline, when there is one).
"""
import sys

def boundaries(b: bytes):
    out, i, n, depth = [], 0, len(b), 0
    while i < n:
        c = b[i:i+1]
        if c == b';':
            while i < n and b[i:i+1] != b'\n': i += 1
        elif c == b'#' and b[i+1:i+2] == b'|':
            i += 2; nest = 1
            while i < n and nest:
                if b[i:i+2] == b'#|': nest += 1; i += 2
                elif b[i:i+2] == b'|#': nest -= 1; i += 2
                else: i += 1
        elif c == b'#' and b[i+1:i+2] == b'\\':
            i += 3                      # `#\` plus the character itself
        elif c == b'"':
            i += 1
            while i < n:
                if b[i:i+1] == b'\\': i += 2
                elif b[i:i+1] == b'"': i += 1; break
                else: i += 1
        elif c == b'(':
            depth += 1; i += 1
        elif c == b')':
            depth -= 1; i += 1
            if depth == 0:
                j = i
                if b[j:j+1] == b'\n': j += 1
                out.append(j)
        else:
            i += 1
    return out

if __name__ == '__main__':
    data = open(sys.argv[1], 'rb').read()
    for off in boundaries(data):
        print(off)
