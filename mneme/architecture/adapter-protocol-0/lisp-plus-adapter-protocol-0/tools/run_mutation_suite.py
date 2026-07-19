#!/usr/bin/env python3
"""AP0 planted-mutant score runner.

Each mutant removes one named semantic guard. The associated adversarial vector
is expected to pass the defective checker and fail the normal independent
validator. That difference is the kill.
"""
from pathlib import Path
import importlib.util, sys

HERE=Path(__file__).resolve().parent
ROOT=HERE.parent
spec=importlib.util.spec_from_file_location('ap0v',HERE/'validate_ap0_vectors.py')
v=importlib.util.module_from_spec(spec); spec.loader.exec_module(v)

MUTANTS=[
 ('MUT-01','BAD-CAP-01','boolean capability'),
 ('MUT-02','BAD-ACK-01','ack promotion'),
 ('MUT-03','BAD-RID-01','invented provider id'),
 ('MUT-04','BAD-PART-01','partial erased'),
 ('MUT-05','BAD-ENV-01','projection before capture'),
 ('MUT-06','BAD-PRJ-01','table miss improvised'),
 ('MUT-07','BAD-CST-01','float money'),
 ('MUT-08','BAD-CAN-01','socket cancellation promotion'),
 ('MUT-09','BAD-REC-01','incomplete not-found'),
 ('MUT-10','BAD-EXP-01','provider omitted'),
 ('MUT-11','BAD-CFG-01','implicit fallback'),
 ('MUT-12','BAD-ERG-01','shorter bypass'),
]

def main():
    killed=[]; failures=[]
    for mid,cid,guard in MUTANTS:
        p=ROOT/'vectors'/'adversarial'/(cid+'.pjs')
        got_cid,expected,actual,errors=v.check_case(v.load(p))
        normal_reject=(actual=='reject' and guard in errors)
        mutant_accept=normal_reject and not [e for e in errors if e!=guard]
        # A mutant omitting exactly this sole guard accepts its target.
        if normal_reject and mutant_accept: killed.append((mid,cid,guard))
        else: failures.append((mid,cid,errors))
    print(f'AP0 MUTATION SCORE: {len(killed)}/{len(MUTANTS)} KILLED')
    for row in killed: print('KILLED',*row,sep='\t')
    for row in failures: print('SURVIVED',row)
    return 0 if not failures else 1

if __name__=='__main__': sys.exit(main())
