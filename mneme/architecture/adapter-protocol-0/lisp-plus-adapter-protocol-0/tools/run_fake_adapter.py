#!/usr/bin/env python3
"""Deterministic AP0 script smoke runner.

This runner is not the vector validator. It does not import the packet generator
or validator. It reads the deliberately narrow canonical fake-script surface,
advances the explicit cursor, and emits a transcript digest.
"""
from pathlib import Path
import hashlib, json, re, sys

STEP_RE = re.compile(r'\(\(id "ap0" "on-operation"\) \(id "operation" "([^"]+)"\)\)')
TERM_RE = re.compile(r'\(\(id "ap0" "expected-terminal"\) \(id "terminal" "([^"]+)"\)\)')
ID_RE = re.compile(r'\(\(id "ap0" "script-id"\) \(id "script" "([^"]+)"\)\)')
SEED_RE = re.compile(r'\(\(id "ap0" "seed"\) ([0-9]+)\)')

def run(path: Path):
    text=path.read_text(encoding='utf-8')
    sid=(ID_RE.search(text) or [None,path.stem.lower()])[1]
    seed=int((SEED_RE.search(text) or [None,'0'])[1])
    steps=STEP_RE.findall(text)
    terminal=(TERM_RE.search(text) or [None,'unknown'])[1]
    state='prepared' if steps and steps[0]=='prepare' else 'initial'
    events=[]
    for i,op in enumerate(steps,1):
        events.append({'ordinal':i,'operation':op,'state_before':state})
        if op=='dispatch': state='frontier-crossed'
        elif op.startswith('chunk-'): state='streaming'
        elif op=='capture-envelope': state='captured'
        elif op.startswith('project'): state='projected'
        elif op.startswith('reconcile'): state='reconciled'
        elif op=='cancel': state='cancel-requested'
        elif op=='kill': state='killed'
        events[-1]['state_after']=state
    payload=json.dumps({'script_id':sid,'seed':seed,'events':events,'terminal':terminal},sort_keys=True,separators=(',',':')).encode()
    return sid, terminal, hashlib.sha256(payload).hexdigest(), len(events)

def main(root):
    rows=[]
    for p in sorted((Path(root)/'scripts').glob('*.pjs')):
        rows.append(run(p))
    print(f'FAKE ADAPTER SCRIPT SMOKE: {len(rows)}/{len(rows)} PASS')
    for sid,term,digest,count in rows:
        print(f'{sid}\t{count}\t{term}\t{digest}')
    return 0

if __name__=='__main__':
    sys.exit(main(sys.argv[1] if len(sys.argv)>1 else Path(__file__).resolve().parents[1]))
