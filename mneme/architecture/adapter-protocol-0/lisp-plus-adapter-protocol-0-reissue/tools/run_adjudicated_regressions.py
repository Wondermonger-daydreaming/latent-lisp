#!/usr/bin/env python3
"""Re-run adjudicated BREAKPOINT/UNDERTOW counterexamples against reissue."""
from pathlib import Path
import importlib.util,sys
HERE=Path(__file__).resolve().parent;ROOT=HERE.parent
sp=importlib.util.spec_from_file_location('apv',HERE/'validate_ap0_vectors.py');v=importlib.util.module_from_spec(sp);sp.loader.exec_module(v)
def I(*x): return ('id',tuple(x))
def D(**kw): return {I('ap0',k.replace('_','-')):val for k,val in kw.items()}
CASES=[
 D(case_id='ATK-REC-LAUNDER',family=I('family','reconciliation'),expected_verdict=I('verdict','reject'),result='not-found',domain_complete=True,settles_no_effect=True,provider_request_id=None,provider_request_timing='unavailable'),
 D(case_id='ATK-RID-COUNTER',family=I('family','request-identity'),expected_verdict=I('verdict','reject'),local_request_id='lr-1',provider_request_id='adapter-counter-42',provider_request_timing='acknowledgment',provider_request_source='adapter-counter'),
 D(case_id='ATK-CAN-RELABEL',family=I('family','cancellation'),expected_verdict=I('verdict','reject'),cancel_class='provider-settled',billing='unknown',partial_preserved=True),
 D(case_id='ATK-STR-DBJ',family=I('family','stream'),expected_verdict=I('verdict','reject'),adapter_identity='fake-reference-0',chunks=[1],stream_relation=True,terminal=False,kernel_manifestation_status='present-partial',persistence_order='delivery-before-journal',history=['chunk-captured','chunk-delivered']),
 D(case_id='ATK-ABS-STATE-AS-STATUS',family=I('family','projection'),expected_verdict=I('verdict','reject'),envelope_captured=True,envelope_identity='e',shape='missing',kernel_manifestation_status='absent-after-completion',no_payload_state=None,projection_origin='derived'),
 D(case_id='BAD-CAN-01-RELABELLED',family=I('family','cancellation'),expected_verdict=I('verdict','reject'),cancel_class='provider-settled'),
 D(case_id='A-METADATA-ONLY',family=I('family','projection'),expected_verdict=I('verdict','accept'),shape='metadata-only',kernel_manifestation_status='absent',no_payload_state='absent-after-completion',envelope_captured=True,envelope_identity='e',projection_origin='derived'),
 D(case_id='B-UNMAPPED',family=I('family','projection'),expected_verdict=I('verdict','reject'),shape='provider-invented-shape-xyz',kernel_manifestation_status='present-invalid',no_payload_state=None,envelope_captured=True,envelope_identity='e',projection_origin='derived'),
 D(case_id='C-NO-CAPTURE-FIELD',family=I('family','projection'),expected_verdict=I('verdict','reject'),shape='nonempty',kernel_manifestation_status='present',no_payload_state=None,envelope_identity='e',projection_origin='derived'),
 D(case_id='D-SENTINEL-CONTROL',family=I('family','projection'),expected_verdict=I('verdict','reject'),shape='unknown-new-shape',kernel_manifestation_status='present-invalid',no_payload_state=None,envelope_captured=True,envelope_identity='e',projection_origin='derived')]
def main():
    c=v.Contract(ROOT);bad=[]
    for d in CASES:
        cid,exp,actual,errs=v.check_case(d,c);print(cid,actual,','.join(errs))
        if exp!=actual: bad.append((cid,exp,actual,errs))
    print(f'AP0 ADJUDICATED REGRESSIONS: {len(CASES)-len(bad)}/{len(CASES)} PASS')
    return 0 if not bad else 1
if __name__=='__main__':sys.exit(main())
