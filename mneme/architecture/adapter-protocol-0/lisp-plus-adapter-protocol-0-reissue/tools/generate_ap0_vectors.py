#!/usr/bin/env python3
"""Generate AP0 descriptors, matrices, scripts, and fixture vectors.

This generator DOES NOT emit, embed, copy, or import the validator. The validator
is separately maintained from normative tables. Running this tool replaces only
generated artifacts beneath the selected packet root.
"""
from pathlib import Path
from typing import Any
import shutil, sys

class Id(tuple): pass
class Unit: pass
UNIT=Unit()
def esc(s):
    out=[]
    for ch in s:
        cp=ord(ch)
        if ch=='"': out.append('\\"')
        elif ch=='\\': out.append('\\\\')
        elif cp<=0x1f or cp==0x7f: out.append('\\u{%x}'%cp)
        else: out.append(ch)
    return ''.join(out)
def emit(x:Any)->str:
    if x is UNIT or x is None: return '#u'
    if x is False: return '#f'
    if x is True: return '#t'
    if isinstance(x,int): return str(x)
    if isinstance(x,Id): return '(id '+' '.join('"'+esc(v)+'"' for v in x)+')'
    if isinstance(x,str): return '"'+esc(x)+'"'
    if isinstance(x,(list,tuple)): return '(seq'+('' if not x else ' '+' '.join(emit(v) for v in x))+')'
    if isinstance(x,dict):
        items=[]
        for k in sorted(x,key=lambda z:tuple(z)):
            items.append('('+emit(k)+' '+emit(x[k])+')')
        return '(rec'+('' if not items else ' '+' '.join(items))+')'
    raise TypeError(type(x))
def I(*s): return Id(s)
def K(name): return I('ap0',name.replace('_','-'))
def rec(**kw): return {K(k):v for k,v in kw.items()}
def write(path,x): path.parent.mkdir(parents=True,exist_ok=True); path.write_text(emit(x)+'\n',encoding='utf-8',newline='\n')

def build(root:Path):
    for rel in ['descriptors','scripts','vectors/positive','vectors/adversarial','vectors/mutants','matrices']:
        q=root/rel
        if q.exists(): shutil.rmtree(q)
        q.mkdir(parents=True,exist_ok=True)

    ACKS=['transport-accepted','provider-received','provider-queued','provider-started','provider-terminal','provider-rejected','acknowledgment-ambiguous','no-acknowledgment']
    desc=rec(adapter_identity=I('adapter','fake-reference-0'),adapter_version='0.2.0-reissue',boundary_class=I('boundary','fake'),principal_id=I('principal','fake-provider-0'),protocol_version=0,witnessable_acknowledgment_classes=[I('ack',a) for a in ACKS],request_identity_policy=I('policy','provider-testimony-allowlist-0'),absence_mapping_table_id=I('table','fake-absence-map-0'),bounded_unknowns=[])
    limited=rec(adapter_identity=I('adapter','fake-limited-ack-0'),adapter_version='0.2.0-reissue',boundary_class=I('boundary','fake'),principal_id=I('principal','fake-provider-0'),protocol_version=0,witnessable_acknowledgment_classes=[I('ack','transport-accepted'),I('ack','no-acknowledgment')],request_identity_policy=I('policy','provider-testimony-allowlist-0'),absence_mapping_table_id=I('table','fake-absence-map-0'),bounded_unknowns=[])
    write(root/'descriptors/FAKE-ADAPTER-DESCRIPTOR-0.pjs',desc)
    write(root/'descriptors/FAKE-ADAPTER-DESCRIPTOR-LIMITED-ACK-0.pjs',limited)

    rows=[
      ('missing','absent','absent-after-completion'),('explicit-null','absent','absent-after-completion'),('metadata-only','absent','absent-after-completion'),
      ('empty-string','present-empty',None),('empty-sequence','present-empty',None),('invalid-utf8','present-invalid',None),('parser-rejected','present-invalid',None),
      ('partial','present-partial',None),('withheld','withheld',None),('redacted','redacted',None),('nonempty','present',None)]
    table=rec(table_id=I('table','fake-absence-map-0'),parser_id=I('parser','fake-projector-0'),rows=[rec(row_id=I('absence-row',f'{i:02d}'),shape=I('shape',shape),kernel_manifestation_status=I('manifestation',status),no_payload_state=(I('absence-state',state) if state else None),collapse_class=I('collapse',shape),notes='normative minimum mapping') for i,(shape,status,state) in enumerate(rows,1)],table_miss_condition=I('condition','absence-mapping-table-miss'))
    write(root/'descriptors/FAKE-ABSENCE-MAPPING-TABLE-0.pjs',table)

    cases=[]
    def add(cid,fam,expect,**f):
        d={'case_id':cid,'family':I('family',fam),'expected_verdict':I('verdict',expect),'lawful_route_steps':4,'bypass_route_steps':None};d.update(f);cases.append(d)

    # positives
    for i,a in enumerate(ACKS,1):
        fields=dict(adapter_descriptor_id=I('adapter','fake-reference-0'),ack_class=a,frontier_crossed=a not in ('acknowledgment-ambiguous','no-acknowledgment'))
        if a!='no-acknowledgment': fields.update(witness_boundary='fake-provider-boundary',raw_evidence_id=f'ack-evidence-{i}',witness_procedure_id='fake-ack-procedure-0',validation_standing='validated')
        add(f'ACK-{i:02d}','acknowledgment','accept',**fields)
    sources={'pre-dispatch':'pre-dispatch-provider-field','acknowledgment':'acknowledgment-field','response-header':'response-header-field','terminal-envelope':'terminal-envelope-field','reconciliation-only':'reconciliation-response-field','conditional':'acknowledgment-field'}
    timings=['pre-dispatch','acknowledgment','response-header','terminal-envelope','reconciliation-only','unavailable','conditional']
    for i,t in enumerate(timings,1): add(f'RID-{i:02d}','request-identity','accept',local_request_id='lr-001',provider_request_id=(None if t=='unavailable' else f'pr-{i:03d}'),provider_request_timing=t,provider_request_source=(None if t=='unavailable' else sources[t]))
    for i,(shape,status,state) in enumerate(rows,1): add(f'ABS-{i:02d}','projection','accept',shape=shape,kernel_manifestation_status=status,no_payload_state=state,adapter_identity='fake-reference-0',projection_receipt=True,projection_origin='derived',envelope_captured=True,envelope_identity=f'env-{i:02d}')
    add('STR-01','stream','accept',adapter_identity='fake-reference-0',chunks=[1,2,3],stream_relation=True,terminal=True,kernel_manifestation_status='present',persistence_order='journal-before-delivery',history=['chunk-captured','chunk-journaled','chunk-delivered'])
    add('STR-02','stream','accept',adapter_identity='fake-reference-0',chunks=[1,2],stream_relation=True,terminal=False,kernel_manifestation_status='present-partial',persistence_order='journal-before-delivery',history=['chunk-captured','chunk-journaled','chunk-delivered'])
    add('STR-03','stream','accept',adapter_identity='fake-reference-0',chunks=[1,1],stream_relation=True,duplicate_identical=True,persistence_order='journal-before-delivery',history=['chunk-captured','chunk-journaled','chunk-delivered'])
    add('STR-04','stream','accept',adapter_identity='fake-reference-0',chunks=[1],stream_relation=True,terminal=False,kernel_manifestation_status='present-partial',persistence_order='delivery-before-journal',history=['chunk-captured','chunk-delivered','chunk-journaled'],loss_window_declared=True,loss_window_id='loss-window-dbj-0',standing='reduced')
    add('CAN-01','cancellation','accept',cancel_class='provider-settled',billing='unknown',partial_preserved=True,settlement_origin='observed',settlement_witness_boundary='fake-provider-boundary',settlement_evidence_id='cancel-evidence-1',settlement_procedure_id='fake-cancel-witness-0',settlement_validation_standing='validated')
    add('CAN-02','cancellation','accept',cancel_class='local-interrupt-only',billing='bounded',partial_preserved=True)
    add('REC-01','reconciliation','accept',result='not-found',domain_complete=True,settles_no_effect=True,provider_request_id='pr-reconcile-1',provider_request_timing='reconciliation-only',completeness_origin='observed',completeness_witness_boundary='fake-provider-query-boundary',completeness_evidence_id='domain-enumeration-1',completeness_procedure_id='fake-domain-enumeration-0',completeness_validation_standing='validated')
    add('REC-02','reconciliation','accept',result='not-found',domain_complete=False,settles_no_effect=False,provider_request_id='pr-reconcile-2',provider_request_timing='reconciliation-only')
    add('REC-03','reconciliation','accept',result='completed',domain_complete=True,settles_no_effect=False,provider_request_id='pr-reconcile-3',provider_request_timing='reconciliation-only')
    add('BAT-01','batching','accept',batching_declared=True,max_unjournaled_events=0,ordering_preserved=True)
    add('CFG-01','configuration','accept',alias='model-latest',resolved='model-2026-07-18',fallback=False)
    add('CST-01','cost','accept',amount='1932912/1000000',currency='USD',standing='estimated')
    add('CST-02','cost','accept',amount='249/100',currency='USD',standing='dashboard-confirmed')
    add('ERG-01','ergonomics','accept')
    add('EXP-01','exposure','accept',provider_principal=True,invoker_exposed=True,undeclared_intermediary=False)
    add('FAKE-01','fake-determinism','accept',script='present-terminal',seed=42,expected_digest='deterministic')
    add('ENV-RED-01','envelope-custody','accept',raw_envelope_id='raw-env-1',derived_envelope_id='redacted-env-1',raw_replaced=False,transformation_receipt_id='redact-r-1',output_origin='derived')
    for n,fold in [(1,'unresolved-effect'),(2,'present-partial'),(3,'captured-unprojected'),(4,'projected-unconsumed')]: add(f'WIN-{n}','crash-window','accept',window=f'W{n}',expected_fold=fold,journal_available=True,frontier_crossed=n>=1)
    add('WIN-1-JOURNAL-DOWN','crash-window','accept',window='W1',expected_fold='unresolved-effect',journal_available=False,frontier_crossed=True)

    # adversarial single-defect cases
    add('BAD-CAP-01','capability','reject',capability_standing=True,condition='adapter-descriptor-invalid')
    add('BAD-ACK-01','acknowledgment','reject',adapter_descriptor_id=I('adapter','fake-reference-0'),ack_class='transport-accepted',promoted_to='provider-terminal',witness_boundary='fake-provider-boundary',raw_evidence_id='e',witness_procedure_id='p',validation_standing='validated',condition='acknowledgment-ambiguous')
    add('BAD-ACK-RELABELLED','acknowledgment','reject',adapter_descriptor_id=I('adapter','fake-limited-ack-0'),ack_class='provider-terminal',witness_boundary='fake-provider-boundary',raw_evidence_id='e',witness_procedure_id='p',validation_standing='validated',condition='adapter-witness-boundary-missing')
    add('BAD-ACK-NO-WITNESS','acknowledgment','reject',adapter_descriptor_id=I('adapter','fake-reference-0'),ack_class='provider-terminal',condition='adapter-witness-boundary-missing')
    add('BAD-RID-01','request-identity','reject',provider_request_timing='unavailable',provider_request_id='invented-from-hash',provider_request_source=None,condition='provider-request-id-unavailable')
    add('BAD-RID-COUNTER','request-identity','reject',provider_request_timing='acknowledgment',provider_request_id='adapter-counter-000042',provider_request_source='adapter-counter',condition='provider-request-id-invented')
    add('BAD-RID-CONFLICT','request-identity','reject',provider_request_timing='reconciliation-only',provider_request_id='pr-late-2',provider_request_source='reconciliation-response-field',prior_provider_request_id='pr-early-1',condition='provider-request-identity-conflict')
    add('BAD-STR-01','stream','reject',adapter_identity=None,chunks=[1,2],stream_relation=True,persistence_order='journal-before-delivery',history=['chunk-captured','chunk-journaled','chunk-delivered'],condition='stream-chunk-adapter-identity-missing')
    add('BAD-STR-02','stream','reject',adapter_identity='fake-reference-0',chunks=[1,2],stream_relation=False,persistence_order='journal-before-delivery',history=['chunk-captured','chunk-journaled','chunk-delivered'],condition='stream-sequence-conflict')
    add('BAD-STR-03','stream','reject',adapter_identity='fake-reference-0',chunks=[1,3],stream_relation=True,gap_hidden=True,persistence_order='journal-before-delivery',history=['chunk-captured','chunk-journaled','chunk-delivered'],condition='stream-sequence-gap')
    add('BAD-PART-01','stream','reject',adapter_identity='fake-reference-0',chunks=[1,2],stream_relation=True,terminal=False,kernel_manifestation_status='absent',no_payload_state='absent-after-completion',persistence_order='journal-before-delivery',history=['chunk-captured','chunk-journaled','chunk-delivered'],condition='partial-manifestation-erasure')
    add('BAD-STR-DBJ','stream','reject',adapter_identity='fake-reference-0',chunks=[1],stream_relation=True,terminal=False,kernel_manifestation_status='present-partial',persistence_order='delivery-before-journal',history=['chunk-captured','chunk-delivered'],condition='stream-persistence-order-invalid')
    add('BAD-ENV-01','projection','reject',shape='nonempty',kernel_manifestation_status='present',no_payload_state=None,envelope_captured=False,envelope_identity='env-x',projection_origin='derived',condition='provider-envelope-missing')
    add('BAD-ENV-MISSING-CAPTURE','projection','reject',shape='nonempty',kernel_manifestation_status='present',no_payload_state=None,envelope_identity='env-x',projection_origin='derived',condition='provider-envelope-missing')
    add('BAD-PRJ-01','projection','reject',shape='provider-invented-shape-xyz',kernel_manifestation_status='present-invalid',no_payload_state=None,envelope_captured=True,envelope_identity='env-x',projection_origin='derived',condition='absence-mapping-table-miss')
    add('BAD-PRJ-02','projection','reject',shape='invalid-utf8',kernel_manifestation_status='absent',no_payload_state='absent-after-completion',envelope_captured=True,envelope_identity='env-x',projection_origin='derived',condition='present-payload-erasure')
    add('BAD-PRJ-STATE-AS-STATUS','projection','reject',shape='missing',kernel_manifestation_status='absent-after-completion',no_payload_state=None,envelope_captured=True,envelope_identity='env-x',projection_origin='derived',condition='projection-output-noncanonical')
    add('BAD-TRUTH-01','projection','reject',shape='nonempty',kernel_manifestation_status='present',no_payload_state=None,envelope_captured=True,envelope_identity='env-x',projection_origin='derived',semantic_truth='verified',condition='adapter-truth-minting')
    add('BAD-PRJ-ORIGIN','projection','reject',shape='nonempty',kernel_manifestation_status='present',no_payload_state=None,envelope_captured=True,envelope_identity='env-x',projection_origin='observed',condition='projection-origin-invalid')
    add('BAD-ENV-REDACTION','envelope-custody','reject',raw_envelope_id='raw-env-1',derived_envelope_id='raw-env-1',raw_replaced=True,transformation_receipt_id=None,output_origin='observed',condition='provider-envelope-redaction-invalid')
    add('BAD-CST-01','cost','reject',amount='binary-float:1.23',currency='USD',standing='estimated',condition='cost-float-noncanonical')
    add('BAD-CST-02','cost','reject',amount=0,currency='USD',standing='missing',condition='cost-standing-missing')
    add('BAD-CAN-01','cancellation','reject',cancel_class='socket-closed',claimed='provider-settled',condition='cancellation-unconfirmed')
    add('BAD-CAN-RELABELLED','cancellation','reject',cancel_class='provider-settled',billing='unknown',partial_preserved=True,condition='adapter-truth-minting')
    add('BAD-REC-01','reconciliation','reject',result='not-found',domain_complete=False,settles_no_effect=True,provider_request_id='pr-r1',provider_request_timing='reconciliation-only',condition='reconciliation-insufficient')
    add('BAD-REC-RELABELLED','reconciliation','reject',result='not-found',domain_complete=True,settles_no_effect=True,provider_request_id='pr-r2',provider_request_timing='reconciliation-only',condition='adapter-witness-boundary-missing')
    add('BAD-REC-NO-ID','reconciliation','reject',result='not-found',domain_complete=True,settles_no_effect=True,provider_request_id=None,provider_request_timing='unavailable',completeness_origin='observed',completeness_witness_boundary='fake-provider-query-boundary',completeness_evidence_id='e',completeness_procedure_id='p',completeness_validation_standing='validated',condition='reconciliation-identity-missing')
    add('BAD-EXP-01','exposure','reject',provider_principal=False,invoker_exposed=False,condition='exposed-principal-boundary-unknown')
    add('BAD-CFG-01','configuration','reject',alias='model-latest',resolved=None,fallback=True,condition='implicit-provider-fallback')
    add('BAD-RETRY-01','retry','reject',predecessor_unresolved=True,automatic_retry=True,condition='reconciliation-insufficient')
    add('BAD-ERG-01','ergonomics','reject',lawful_route_steps=4,bypass_route_steps=1,condition='adapter-truth-minting')
    add('BAD-WIT-01','witnessing','reject',self_report_origin='observed',condition='adapter-witness-boundary-missing')
    add('BAD-WIN-JOURNAL-DOWN','crash-window','reject',window='W1',expected_fold='no-effect',journal_available=False,frontier_crossed=True,condition='reconciliation-insufficient')

    registry=[]
    for d in cases:
        target=root/'vectors'/('positive' if d['expected_verdict'][-1]=='accept' else 'adversarial')/(d['case_id']+'.pjs')
        datum=rec(**d); write(target,datum)
        registry.append(rec(case_id=d['case_id'],family=d['family'],expected_verdict=d['expected_verdict'],path=str(target.relative_to(root))))

    mutants=[
      ('MUT-01','BAD-CAP-01','boolean-capability'),('MUT-02','BAD-ACK-01','ack-promotion'),('MUT-03','BAD-ACK-RELABELLED','ack-outside-witness-set'),('MUT-04','BAD-ACK-NO-WITNESS','ack-witness-missing'),
      ('MUT-05','BAD-RID-COUNTER','provider-id-invented'),('MUT-06','BAD-RID-CONFLICT','provider-id-conflict'),('MUT-07','BAD-PART-01','partial-erased'),('MUT-08','BAD-STR-DBJ','stream-persistence-invalid'),
      ('MUT-09','BAD-ENV-MISSING-CAPTURE','projection-before-capture'),('MUT-10','BAD-PRJ-01','absence-table-miss'),('MUT-11','BAD-PRJ-02','absence-mapping-mismatch'),('MUT-12','BAD-PRJ-ORIGIN','projection-origin-invalid'),
      ('MUT-13','BAD-ENV-REDACTION','redaction-custody-invalid'),('MUT-14','BAD-CAN-RELABELLED','cancellation-witness-missing'),('MUT-15','BAD-REC-RELABELLED','reconciliation-witness-missing'),('MUT-16','BAD-REC-NO-ID','reconciliation-identity-missing'),
      ('MUT-17','BAD-CST-01','float-money'),('MUT-18','BAD-EXP-01','provider-omitted'),('MUT-19','BAD-CFG-01','implicit-fallback'),('MUT-20','BAD-WIN-JOURNAL-DOWN','journal-down-misclassified')]
    for mid,target,rule in mutants: write(root/'vectors/mutants'/(mid+'.pjs'),rec(mutant_id=mid,target_case=target,disabled_rule=rule,expected_verdict=I('verdict','mutant-must-accept')))

    reg=rec(protocol=I('protocol','ap0'),version=0,standing=I('standing','self-consistency-reissue-candidate'),vector_count=len(cases)+len(mutants),positive_count=sum(d['expected_verdict'][-1]=='accept' for d in cases),adversarial_count=sum(d['expected_verdict'][-1]=='reject' for d in cases),mutant_count=len(mutants),entries=registry)
    write(root/'AP0-FIXTURE-REGISTRY.sexp',reg)

    # deterministic fake scripts
    scripts={
      'PRESENT':('present-terminal',['prepare','dispatch','ack','capture-envelope','project'],'present'),
      'EMPTY':('present-empty',['prepare','dispatch','capture-envelope','project-empty'],'present-empty'),
      'INVALID':('present-invalid',['prepare','dispatch','capture-envelope','project-invalid'],'present-invalid'),
      'ABSENT':('absent-after-completion',['prepare','dispatch','capture-envelope','project-absent'],'absent-after-completion'),
      'CANCEL':('cancel-unsettled',['prepare','dispatch','chunk-1','cancel','kill'],'present-partial'),
      'RECONCILE':('reconcile-completed',['prepare','dispatch','kill','reconcile-completed'],'completed'),
      'W1':('post-send-pre-response',['prepare','dispatch','kill'],'unresolved-effect'),
      'W2':('mid-stream',['prepare','dispatch','ack','chunk-1','chunk-2','kill'],'present-partial'),
      'W3':('captured-unprojected',['prepare','dispatch','ack','capture-envelope','kill'],'captured-unprojected'),
      'W4':('projected-unconsumed',['prepare','dispatch','ack','capture-envelope','project','kill'],'projected-unconsumed')}
    for key,(name,ops,term) in scripts.items():
        datum=rec(version=0,script_id=I('script','script-'+key.lower()),name=name,adapter_descriptor_id=I('adapter','fake-reference-0'),seed=42,steps=[rec(ordinal=i,on_operation=I('operation',op),kill_point=(I('kill','kill') if op=='kill' else None)) for i,op in enumerate(ops,1)],expected_terminal=I('terminal',term))
        write(root/'scripts'/('SCRIPT-'+key+'.pjs'),datum)

    (root/'matrices/ACKNOWLEDGMENT-MATRIX.md').write_text('# AP0 Acknowledgment Matrix — repaired\n\nAn acknowledgment may be emitted only inside the descriptor-declared witnessable set and never settles an effect by itself.\n',encoding='utf-8')
    (root/'matrices/CRASH-WINDOWS-W1-W4.md').write_text('# AP0 Crash Windows W1–W4 — repaired\n\nW1 also governs journal-down discovered after frontier crossing.\n',encoding='utf-8')
    (root/'matrices/REQUEST-IDENTITY-TIMING.md').write_text('# AP0 Request Identity Timing — repaired\n\nEvery populated provider request identity must name an allowed provider-testimony source.\n',encoding='utf-8')
    (root/'matrices/L17-ROUTE-AUDIT.md').write_text('# AP0 L17 Route Audit\n\nThe lawful composite adapter route remains one public action; unsafe raw host calls are outside AP0 conformance.\n',encoding='utf-8')

if __name__=='__main__': build(Path(sys.argv[1] if len(sys.argv)>1 else Path(__file__).resolve().parents[1]))
