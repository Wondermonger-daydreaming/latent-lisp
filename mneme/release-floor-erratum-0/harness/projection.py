#!/usr/bin/env python3
"""projection.py — the CANONICAL SEMANTIC PROJECTION of a release-floor transcript.

    python3 projection.py <transcript> > projection.txt

Sol I §V asks for a comparison of row number, lane, command identity, executable status,
lane totals, carried statuses and terminal counts — NOT raw byte identity across
timestamps, temporary paths and run identifiers.  This tool extracts exactly those, in a
form that is stable across both the pre-erratum and post-erratum floor wordings, so that
any difference in the diff is a difference of FACT rather than of phrasing.

Lane totals are emitted as numbers (gates|passed|nonpassing|blocked) rather than as the
floor's prose, because the prose label changed by adjudication ("FAILED" -> "NON-PASSING")
while the arithmetic did not; the wording change is reported separately in RETURN.md.
"""
import re, sys

ROW = re.compile(r'^\[(\d{3})\] (.+?) +(INPL|COPY) (.*)$')
VERDICT = re.compile(r'^ {6}-> ([A-Z-]+) \(exit (\d+)')
LANE = re.compile(r'^(PASS|FAIL) {2,}(\S+) +(\d+) gate\(s\), (\d+) passed(.*)$')
COUNT = re.compile(r'^ {3}(attempted|passed|failed|blocked-external-input|rows carried) +: (\d+)$')
OFWHICH = re.compile(r'^ {3}of which ([A-Z-]+(?: \(elsewhere\))?) *: (\d+)$')
RESULT = re.compile(r'^FLOOR RESULT: (PASS|FAIL)')
ENUM = re.compile(r'^enumeration  : full (\d+)/(\d+) . light (\d+)/(\d+)')

def main(path):
    lines = open(path, encoding='utf-8', errors='replace').read().splitlines()
    rows, lanes, carried, counts, ofwhich = [], [], [], [], []
    result, enum = None, None
    in_declared = False
    pending = None
    for i, ln in enumerate(lines):
        m = ENUM.match(ln)
        if m and enum is None:
            enum = m.groups()
        m = ROW.match(ln)
        if m:
            pending = m.groups()
            continue
        m = VERDICT.match(ln)
        if m and pending:
            n, lane, tree, cmd = pending
            rows.append((n, lane.strip(), tree, cmd.strip(), m.group(1), m.group(2)))
            pending = None
            continue
        m = LANE.match(ln)
        if m and not in_declared:
            st, lane, gates, passed, tail = m.groups()
            nonpass = 0
            t = re.search(r'(\d+) (?:FAILED|NON-PASSING)', tail)
            if t:
                nonpass = int(t.group(1))
            b = re.search(r'(\d+) BLOCKED-EXTERNAL-INPUT', tail)
            blocked = int(b.group(1)) if b else 0
            lanes.append((lane, int(gates), int(passed), nonpass, blocked))
            continue
        if ln.startswith('-- declared, not executed'):
            in_declared = True
            continue
        m = RESULT.match(ln)
        if m:
            result = m.group(1)
            in_declared = False
            continue
        if in_declared and ln and not ln.startswith(' ') and not ln.startswith('=') \
           and not ln.startswith('FLOOR') and not ln.startswith('TERMINAL'):
            parts = ln.split(None, 2)
            if len(parts) == 3 and parts[0].isupper():
                carried.append((parts[0], parts[1], parts[2]))
            continue
        m = COUNT.match(ln)
        if m:
            counts.append(m.groups())
            continue
        m = OFWHICH.match(ln)
        if m:
            ofwhich.append((m.group(1).strip(), m.group(2)))
            continue
        m = RESULT.match(ln)
        if m:
            result = m.group(1)

    out = []
    out.append('# CANONICAL SEMANTIC PROJECTION')
    out.append('ENUMERATION|full %s/%s|light %s/%s' % enum if enum else 'ENUMERATION|?')
    out.append('')
    out.append('## ROWS  n|lane|tree|command|status|exit')
    for r in rows:
        out.append('|'.join(r))
    out.append('')
    out.append('## LANEORDER')
    out.append('|'.join(l[0] for l in lanes))
    out.append('')
    out.append('## LANES  lane|gates|passed|nonpassing|blocked')
    for l in lanes:
        out.append('%s|%d|%d|%d|%d' % l)
    out.append('')
    out.append('## CARRIED  status|lane|headline')
    for c in carried:
        out.append('|'.join(c))
    out.append('')
    out.append('## TERMINAL')
    for k, v in counts:
        out.append('%s|%s' % (k, v))
    for k, v in ofwhich:
        out.append('of which %s|%s' % (k, v))
    out.append('RESULT|%s' % result)
    out.append('')
    out.append('## TOTALS-CHECK')
    out.append('rows parsed|%d' % len(rows))
    out.append('rows PASS|%d' % sum(1 for r in rows if r[4] == 'PASS'))
    out.append('rows non-PASS|%d' % sum(1 for r in rows if r[4] != 'PASS'))
    out.append('lane gate sum|%d' % sum(l[1] for l in lanes))
    print('\n'.join(out))

if __name__ == '__main__':
    main(sys.argv[1])
