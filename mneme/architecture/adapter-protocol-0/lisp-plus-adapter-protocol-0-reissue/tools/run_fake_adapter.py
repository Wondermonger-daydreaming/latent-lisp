#!/usr/bin/env python3
"""Deterministic AP0 script runner with terminal comparison and two-pass replay."""
from pathlib import Path
import hashlib,json,re,sys
STEP_RE=re.compile(r'\(\(id "ap0" "on-operation"\) \(id "operation" "([^"]+)"\)\)')
TERM_RE=re.compile(r'\(\(id "ap0" "expected-terminal"\) \(id "terminal" "([^"]+)"\)\)')
ID_RE=re.compile(r'\(\(id "ap0" "script-id"\) \(id "script" "([^"]+)"\)\)')
SEED_RE=re.compile(r'\(\(id "ap0" "seed"\) ([0-9]+)\)')
def evaluate(path):
    text=path.read_text(encoding='utf-8');sid=ID_RE.search(text).group(1);seed=int(SEED_RE.search(text).group(1));declared=TERM_RE.search(text).group(1);ops=STEP_RE.findall(text)
    state='initial';partial=False;projected_terminal=None;events=[]
    for n,op in enumerate(ops,1):
        before=state
        if op=='prepare': state='prepared'
        elif op=='dispatch': state='frontier-crossed'
        elif op=='ack': state='acknowledged'
        elif op.startswith('chunk-'): partial=True;state='streaming'
        elif op=='capture-envelope': state='captured-unprojected'
        elif op=='project': projected_terminal='present';state='present'
        elif op=='project-empty': projected_terminal='present-empty';state='present-empty'
        elif op=='project-invalid': projected_terminal='present-invalid';state='present-invalid'
        elif op=='project-absent': projected_terminal='absent-after-completion';state='absent-after-completion'
        elif op=='reconcile-completed': state='completed'
        elif op=='cancel': state='cancel-requested'
        elif op=='kill':
            if projected_terminal is not None: state='projected-unconsumed'
            elif state=='captured-unprojected': state='captured-unprojected'
            elif partial: state='present-partial'
            else: state='unresolved-effect'
        events.append({'ordinal':n,'operation':op,'state_before':before,'state_after':state})
    computed=state
    payload=json.dumps({'script_id':sid,'seed':seed,'events':events,'computed_terminal':computed},sort_keys=True,separators=(',',':')).encode()
    return sid,declared,computed,hashlib.sha256(payload).hexdigest(),len(events)
def main(root):
    rows=[];fail=[]
    for p in sorted((Path(root)/'scripts').glob('*.pjs')):
        a=evaluate(p);b=evaluate(p);rows.append(a)
        if a[1]!=a[2]: fail.append((a[0],'terminal-mismatch',a[1],a[2]))
        if a[3]!=b[3]: fail.append((a[0],'replay-digest-mismatch',a[3],b[3]))
    print(f'FAKE ADAPTER SCRIPT REPLAY: {len(rows)-len(fail)}/{len(rows)} PASS')
    for sid,declared,computed,digest,count in rows: print(f'{sid}\t{count}\tdeclared={declared}\tcomputed={computed}\t{digest}')
    for f in fail: print('FAIL',f)
    return 0 if not fail else 1
if __name__=='__main__': sys.exit(main(sys.argv[1] if len(sys.argv)>1 else Path(__file__).resolve().parents[1]))
