#!/usr/bin/env python3
r"""mutate.py — the planted faults the Errata 0.3 teeth controls need.

A GATE THAT HAS NEVER FIRED IS UNTESTED, NOT PASSING.  Every mutation here exists
to make one instrument lie in one specific way, so the runner can be SEEN refusing
it.  Nothing in this file ever touches the real tree: `teeth.sh` copies the subject
to a scratch directory and mutates the copy.

Subcommands, all operating in place on a scratch file:

  cut FILE FRACTION
      Truncate at the TOP-LEVEL FORM BOUNDARY nearest FRACTION of the file.  The
      result is a syntactically complete program, so `--load` exits 0 and the checks
      below the cut simply never run — the exact fail-open the stranger audit used.

  zero FILE ANCHOR
      Truncate at the first form boundary after the last line matching ANCHOR (the
      instrument's counter declarations), then RE-APPEND the instrument's own
      canonical result form.  Zero checks run and the summary is printed anyway:
      FOSSOR's T5/T11 shape, the one that scored `0 checks passed / 0 failed` and
      was waved through.

  crash FILE FRACTION
      Insert a signalling form at the boundary nearest FRACTION, so the instrument
      dies after doing real work and before printing its summary.

  rename FILE
      Rename the canonical label (`X-RESULT` -> `X-RESULTS`).  Everything else about
      the run is honest; only the machine-readable name is wrong.

  trailspace FILE
      Add ONE trailing space before the newline of the canonical line.  Invisible to
      a reader, fatal to a whole-line match — which is the point of matching whole
      lines.
"""
import re
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
            i += 3
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

def result_form(data: bytes) -> bytes:
    """The instrument's own canonical result form, extracted verbatim."""
    bs = boundaries(data)
    start = 0
    for end in bs:
        chunk = data[start:end]
        if b'-RESULT ' in chunk and b'format' in chunk:
            return chunk
        start = end
    raise SystemExit("mutate.py: no canonical -RESULT form found")

def result_line_index(lines):
    for k, ln in enumerate(lines):
        if re.search(rb'"[^"]*[A-Z0-9-]+-RESULT ', ln):
            return k
    raise SystemExit("mutate.py: no canonical -RESULT format string found")

def main():
    cmd, path = sys.argv[1], sys.argv[2]
    data = open(path, 'rb').read()

    if cmd == 'cut':
        frac = float(sys.argv[3])
        bs = boundaries(data)
        target = int(len(data) * frac)
        cut = max([b for b in bs if b <= target] or [bs[0]])
        open(path, 'wb').write(data[:cut])
        print(f"cut at byte {cut} of {len(data)} (clean top-level form boundary)")

    elif cmd == 'zero':
        anchor = sys.argv[3].encode()
        pos, off = None, 0
        for ln in data.split(b'\n'):
            off += len(ln) + 1
            if re.search(anchor, ln):
                pos = off
        if pos is None:
            raise SystemExit(f"mutate.py: anchor {anchor!r} not found in {path}")
        bs = boundaries(data)
        cut = min([b for b in bs if b >= pos])
        tail = result_form(data)
        open(path, 'wb').write(data[:cut] + b'\n' + tail)
        print(f"cut at byte {cut} (after the counters), canonical result form re-appended")

    elif cmd == 'crash':
        frac = float(sys.argv[3])
        bs = boundaries(data)
        target = int(len(data) * frac)
        cut = max([b for b in bs if b <= target] or [bs[0]])
        planted = b'\n(error "TEETH: planted crash before the summary")\n'
        open(path, 'wb').write(data[:cut] + planted + data[cut:])
        print(f"planted a signalling form at byte {cut}")

    elif cmd == 'rename':
        lines = data.split(b'\n')
        k = result_line_index(lines)
        lines[k] = re.sub(rb'([A-Z0-9-]+-RESULT) ', rb'\1S ', lines[k], count=1)
        open(path, 'wb').write(b'\n'.join(lines))
        print(f"renamed the canonical label on line {k+1}")

    elif cmd == 'trailspace':
        lines = data.split(b'\n')
        k = result_line_index(lines)
        if b'~%"' not in lines[k]:
            raise SystemExit("mutate.py: canonical format string does not end its line")
        lines[k] = lines[k].replace(b'~%"', b' ~%"', 1)
        open(path, 'wb').write(b'\n'.join(lines))
        print(f"added one trailing space to the canonical line on line {k+1}")

    elif cmd == 'collide':
        # The planted fault the APPLICATION's repaired census check exists to catch:
        # an abbreviation that discriminates NOTHING.  Every printed identity comes
        # out as one string, so distinct-abbreviations < distinct-identities.  The
        # tautology this check replaced (`n` compared with its own defining
        # expression) could not have noticed.  FORMAT ignores surplus arguments, so
        # the call site is untouched.
        control = '(format nil "~A…~A [~D]"'.encode()
        if control not in data:
            raise SystemExit("mutate.py: abbreviation control string not found")
        open(path, 'wb').write(data.replace(control, b'(format nil "IDENTITY-ELIDED"', 1))
        print("abbreviation control replaced: every identity now prints identically")

    else:
        raise SystemExit(f"mutate.py: unknown subcommand {cmd}")

if __name__ == '__main__':
    main()
