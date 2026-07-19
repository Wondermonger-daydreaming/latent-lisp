#!/usr/bin/env python3
"""Execute rule-omission mutants against their designated adversarial targets."""
from pathlib import Path
import importlib.util,sys
HERE=Path(__file__).resolve().parent;ROOT=HERE.parent
sp=importlib.util.spec_from_file_location('apv',HERE/'validate_ap0_vectors.py');v=importlib.util.module_from_spec(sp);sp.loader.exec_module(v)
def main():
    c=v.Contract(ROOT);fail=[];rows=[]
    for mp in sorted((ROOT/'vectors/mutants').glob('*.pjs')):
        m=v.load(mp);mid=v.field(m,'mutant-id');target=v.field(m,'target-case');rule=v.field(m,'disabled-rule');d=v.load(ROOT/'vectors/adversarial'/(target+'.pjs'))
        _,_,normal,nerrs=v.check_case(d,c);_,_,mutant,merrs=v.check_case(d,c,{rule});ok=(normal=='reject' and rule in nerrs and mutant=='accept');rows.append((mid,target,rule,ok))
        if not ok: fail.append((mid,target,rule,normal,nerrs,mutant,merrs))
    print(f'AP0 EXECUTED MUTATION SCORE: {len(rows)-len(fail)}/{len(rows)} KILLED')
    for mid,target,rule,ok in rows: print(('KILLED' if ok else 'SURVIVED'),mid,target,rule,sep='\t')
    for x in fail: print('FAIL',x)
    return 0 if not fail else 1
if __name__=='__main__':sys.exit(main())
