#!/usr/bin/env python3
"""Joint AP0/Kernel manifestation-algebra validator."""
from pathlib import Path
import importlib.util,sys
HERE=Path(__file__).resolve().parent;ROOT=HERE.parent
sp=importlib.util.spec_from_file_location('apv',HERE/'validate_ap0_vectors.py');v=importlib.util.module_from_spec(sp);sp.loader.exec_module(v)
STATUSES={'present','present-empty','present-invalid','present-partial','absent','withheld','redacted'}
def main(root=ROOT):
    root=Path(root); failures=[]
    files=list((root/'vectors/positive').glob('ABS-*.pjs'))+[root/'vectors/adversarial/BAD-PRJ-STATE-AS-STATUS.pjs']
    for p in sorted(files):
        d=v.load(p); status=v.field(d,'kernel-manifestation-status'); state=v.field(d,'no-payload-state')
        expected='reject' if p.name=='BAD-PRJ-STATE-AS-STATUS.pjs' else 'accept'
        errs=[]
        if status is not None and status not in STATUSES: errs.append('kernel-status-closed-set')
        if state=='absent-after-completion' and status!='absent': errs.append('kernel-state-status-pair')
        if status!='absent' and state is not None: errs.append('no-payload-state-on-nonabsent')
        actual='reject' if errs else 'accept'
        if actual!=expected: failures.append((p.name,expected,actual,errs))
    print(f'AP0/KERNEL JOINT ALGEBRA: {len(files)-len(failures)}/{len(files)} PASS')
    for f in failures: print('FAIL',f)
    return 0 if not failures else 1
if __name__=='__main__': sys.exit(main(Path(sys.argv[1]) if len(sys.argv)>1 else ROOT))
