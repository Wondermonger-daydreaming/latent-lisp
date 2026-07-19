#!/usr/bin/env python3
"""Separately maintained AP0 vector validator.

This source is not emitted by the vector generator and does not import it. It
parses PJ-S/0 independently, loads the normative descriptor/table artifacts,
and applies named semantic rules. Standing: co-authored self-consistency only;
independent Common Lisp conformance remains outstanding.
"""
from pathlib import Path
import re, sys

class ParseError(Exception): pass
class Scanner:
    def __init__(self,text): self.text=text; self.pos=0
    def skip(self):
        while self.pos<len(self.text) and self.text[self.pos].isspace(): self.pos+=1
    def starts(self,x): self.skip(); return self.text.startswith(x,self.pos)
    def char(self,c=None):
        self.skip()
        if self.pos>=len(self.text): raise ParseError('unexpected eof')
        got=self.text[self.pos]
        if c is not None and got!=c: raise ParseError(f'expected {c!r}, got {got!r}')
        self.pos+=1; return got
    def atom(self):
        self.skip(); start=self.pos
        while self.pos<len(self.text) and self.text[self.pos] not in '() \t\r\n': self.pos+=1
        if start==self.pos: raise ParseError('missing atom')
        return self.text[start:self.pos]
    def string(self):
        self.char('"'); out=[]
        while True:
            if self.pos>=len(self.text): raise ParseError('unterminated string')
            ch=self.text[self.pos]; self.pos+=1
            if ch=='"': return ''.join(out)
            if ch!='\\': out.append(ch); continue
            if self.pos>=len(self.text): raise ParseError('truncated escape')
            esc=self.text[self.pos]; self.pos+=1
            if esc in ('"','\\'): out.append(esc)
            elif esc=='u':
                self.char('{'); start=self.pos
                while self.pos<len(self.text) and self.text[self.pos]!='}': self.pos+=1
                if self.pos>=len(self.text): raise ParseError('unicode escape')
                out.append(chr(int(self.text[start:self.pos],16))); self.pos+=1
            else: raise ParseError('unknown escape')

def parse_value(sc):
    if sc.starts('#u'): sc.pos+=2; return None
    if sc.starts('#t'): sc.pos+=2; return True
    if sc.starts('#f'): sc.pos+=2; return False
    if sc.starts('#x"'): sc.pos+=2; return bytes.fromhex(sc.string())
    sc.skip()
    if sc.pos<len(sc.text) and sc.text[sc.pos]=='"': return sc.string()
    if sc.pos<len(sc.text) and sc.text[sc.pos]=='(':
        sc.char('('); tag=sc.atom()
        if tag=='id':
            vals=[]
            while True:
                sc.skip()
                if sc.pos<len(sc.text) and sc.text[sc.pos]==')': break
                vals.append(sc.string())
            sc.char(')'); return ('id',tuple(vals))
        if tag=='seq':
            vals=[]
            while True:
                sc.skip()
                if sc.pos<len(sc.text) and sc.text[sc.pos]==')': break
                vals.append(parse_value(sc))
            sc.char(')'); return vals
        if tag=='rec':
            d={}
            while True:
                sc.skip()
                if sc.pos<len(sc.text) and sc.text[sc.pos]==')': break
                sc.char('('); k=parse_value(sc); v=parse_value(sc); sc.char(')')
                if k in d: raise ParseError('duplicate key')
                d[k]=v
            sc.char(')'); return d
        if tag=='rat':
            n=int(sc.atom()); d=int(sc.atom()); sc.char(')'); return ('rat',n,d)
        raise ParseError('unknown tag '+tag)
    token=sc.atom()
    if re.fullmatch(r'-?(0|[1-9][0-9]*)',token): return int(token)
    raise ParseError('bad token '+token)

def load(path):
    text=Path(path).read_text(encoding='utf-8'); sc=Scanner(text); val=parse_value(sc); sc.skip()
    if sc.pos!=len(text): raise ParseError('trailing data')
    return val

def key(name): return ('id',('ap0',name))
def field(d,name,default=None): return d.get(key(name),default)
def tail(x): return x[1][-1] if isinstance(x,tuple) and len(x)==2 and x[0]=='id' else x
def tails(xs): return [tail(x) for x in (xs or [])]

class Contract:
    def __init__(self,root):
        self.root=Path(root); self.tables={}; self.descriptors={}
        for path in (self.root/'descriptors').glob('*ABSENCE-MAPPING-TABLE*.pjs'):
            d=load(path); tid=tail(field(d,'table-id')); mapping={}
            for row in field(d,'rows',[]): mapping[tail(field(row,'shape'))]=(tail(field(row,'kernel-manifestation-status')),tail(field(row,'no-payload-state')))
            self.tables[tid]=mapping
        for path in (self.root/'descriptors').glob('*ADAPTER-DESCRIPTOR*.pjs'):
            d=load(path); aid=tail(field(d,'adapter-identity')); self.descriptors[aid]={'acks':set(tails(field(d,'witnessable-acknowledgment-classes')))}
        self.absence=self.tables['fake-absence-map-0']

RULES={}
def rule(name):
    def deco(fn): RULES[name]=fn; return fn
    return deco

@rule('registry-fields')
def r_registry(d,c):
    return not field(d,'case-id') or not tail(field(d,'family')) or tail(field(d,'expected-verdict')) not in ('accept','reject')
@rule('ack-promotion')
def r_ack_promotion(d,c): return tail(field(d,'family'))=='acknowledgment' and field(d,'promoted-to') and field(d,'ack-class')=='transport-accepted'
@rule('ack-outside-witness-set')
def r_ack_set(d,c):
    if tail(field(d,'family'))!='acknowledgment': return False
    aid=tail(field(d,'adapter-descriptor-id')); ack=field(d,'ack-class')
    return aid not in c.descriptors or ack not in c.descriptors[aid]['acks']
@rule('ack-witness-missing')
def r_ack_witness(d,c):
    if tail(field(d,'family'))!='acknowledgment' or field(d,'ack-class')=='no-acknowledgment': return False
    return any(field(d,n) in (None,'') for n in ('witness-boundary','raw-evidence-id','witness-procedure-id')) or field(d,'validation-standing') not in ('validated','independently-verified')
@rule('provider-id-unavailable')
def r_pid_unavail(d,c): return tail(field(d,'family'))=='request-identity' and field(d,'provider-request-timing')=='unavailable' and field(d,'provider-request-id') is not None
@rule('provider-id-invented')
def r_pid_source(d,c):
    if tail(field(d,'family'))!='request-identity' or field(d,'provider-request-id') is None: return False
    allowed={'pre-dispatch':{'pre-dispatch-provider-field'},'acknowledgment':{'acknowledgment-field'},'response-header':{'response-header-field'},'terminal-envelope':{'terminal-envelope-field'},'reconciliation-only':{'reconciliation-response-field'},'conditional':{'pre-dispatch-provider-field','acknowledgment-field','response-header-field','terminal-envelope-field','reconciliation-response-field'}}
    return field(d,'provider-request-source') not in allowed.get(field(d,'provider-request-timing'),set())
@rule('provider-id-conflict')
def r_pid_conflict(d,c):
    return tail(field(d,'family'))=='request-identity' and field(d,'prior-provider-request-id') is not None and field(d,'provider-request-id') is not None and field(d,'prior-provider-request-id')!=field(d,'provider-request-id')
@rule('missing-adapter-identity')
def r_stream_adapter(d,c): return tail(field(d,'family'))=='stream' and field(d,'adapter-identity') is None
@rule('missing-stream-relation')
def r_stream_rel(d,c): return tail(field(d,'family'))=='stream' and field(d,'stream-relation') is not True
@rule('hidden-stream-gap')
def r_gap(d,c): return tail(field(d,'family'))=='stream' and field(d,'gap-hidden') is True
@rule('partial-erased')
def r_partial(d,c): return tail(field(d,'family'))=='stream' and bool(field(d,'chunks')) and field(d,'terminal') is False and field(d,'kernel-manifestation-status')=='absent'
@rule('stream-persistence-invalid')
def r_persist(d,c):
    if tail(field(d,'family'))!='stream': return False
    order=field(d,'persistence-order'); hist=field(d,'history') or []
    if order not in ('journal-before-delivery','delivery-before-journal'): return True
    try: j=hist.index('chunk-journaled'); x=hist.index('chunk-delivered')
    except ValueError: j=x=None
    if order=='journal-before-delivery': return j is None or x is None or j>x
    return not (field(d,'loss-window-declared') is True and field(d,'loss-window-id') and field(d,'standing')=='reduced' and x is not None and (j is None or x<j))
@rule('projection-before-capture')
def r_capture(d,c): return tail(field(d,'family'))=='projection' and field(d,'envelope-captured') is not True
@rule('absence-table-miss')
def r_table(d,c): return tail(field(d,'family'))=='projection' and field(d,'shape') not in c.absence
@rule('absence-mapping-mismatch')
def r_mapping(d,c):
    if tail(field(d,'family'))!='projection' or field(d,'shape') not in c.absence: return False
    return (field(d,'kernel-manifestation-status'),field(d,'no-payload-state'))!=c.absence[field(d,'shape')]
@rule('truth-minting')
def r_truth(d,c): return tail(field(d,'family'))=='projection' and field(d,'semantic-truth')=='verified'
@rule('projection-origin-invalid')
def r_origin(d,c): return tail(field(d,'family'))=='projection' and field(d,'projection-origin')!='derived'
@rule('redaction-custody-invalid')
def r_redact(d,c):
    if tail(field(d,'family'))!='envelope-custody': return False
    return field(d,'raw-replaced') is not False or not field(d,'transformation-receipt-id') or field(d,'raw-envelope-id')==field(d,'derived-envelope-id') or field(d,'output-origin')!='derived'
@rule('float-money')
def r_float(d,c):
    a=field(d,'amount'); return tail(field(d,'family'))=='cost' and isinstance(a,str) and a.startswith('binary-float:')
@rule('missing-standing')
def r_cost_standing(d,c): return tail(field(d,'family'))=='cost' and field(d,'standing')=='missing'
@rule('socket-cancellation-promotion')
def r_socket(d,c): return tail(field(d,'family'))=='cancellation' and field(d,'cancel-class')=='socket-closed' and field(d,'claimed')=='provider-settled'
@rule('cancellation-witness-missing')
def r_cancel_witness(d,c):
    if tail(field(d,'family'))!='cancellation' or field(d,'cancel-class')!='provider-settled': return False
    return field(d,'settlement-origin')!='observed' or any(not field(d,n) for n in ('settlement-witness-boundary','settlement-evidence-id','settlement-procedure-id')) or field(d,'settlement-validation-standing') not in ('validated','independently-verified')
@rule('reconciliation-incomplete-not-found')
def r_rec_incomplete(d,c): return tail(field(d,'family'))=='reconciliation' and field(d,'result')=='not-found' and field(d,'settles-no-effect') is True and field(d,'domain-complete') is not True
@rule('reconciliation-identity-missing')
def r_rec_id(d,c): return tail(field(d,'family'))=='reconciliation' and field(d,'result')=='not-found' and field(d,'settles-no-effect') is True and not field(d,'provider-request-id')
@rule('reconciliation-witness-missing')
def r_rec_witness(d,c):
    if tail(field(d,'family'))!='reconciliation' or field(d,'result')!='not-found' or field(d,'settles-no-effect') is not True: return False
    return field(d,'completeness-origin')!='observed' or any(not field(d,n) for n in ('completeness-witness-boundary','completeness-evidence-id','completeness-procedure-id')) or field(d,'completeness-validation-standing') not in ('validated','independently-verified')
@rule('provider-omitted')
def r_provider(d,c): return tail(field(d,'family'))=='exposure' and field(d,'provider-principal') is not True
@rule('implicit-fallback')
def r_fallback(d,c): return tail(field(d,'family'))=='configuration' and field(d,'fallback') is True
@rule('blind-retry')
def r_retry(d,c): return tail(field(d,'family'))=='retry' and field(d,'predecessor-unresolved') is True and field(d,'automatic-retry') is True
@rule('shorter-bypass')
def r_erg(d,c):
    if tail(field(d,'family'))!='ergonomics': return False
    a,b=field(d,'lawful-route-steps'),field(d,'bypass-route-steps'); return b is not None and a>b
@rule('boolean-capability')
def r_cap(d,c): return tail(field(d,'family'))=='capability' and isinstance(field(d,'capability-standing'),bool)
@rule('self-testimony-promoted')
def r_self(d,c): return tail(field(d,'family'))=='witnessing' and field(d,'self-report-origin')=='observed'
@rule('journal-down-misclassified')
def r_jdown(d,c): return tail(field(d,'family'))=='crash-window' and field(d,'frontier-crossed') is True and field(d,'journal-available') is False and field(d,'expected-fold')!='unresolved-effect'

def check_case(d,contract,disabled=frozenset()):
    errors=[]
    for name,fn in RULES.items():
        if name not in disabled and fn(d,contract): errors.append(name)
    actual='reject' if errors else 'accept'
    return field(d,'case-id'),tail(field(d,'expected-verdict')),actual,errors

def main(root):
    root=Path(root); c=Contract(root); files=sorted((root/'vectors/positive').glob('*.pjs'))+sorted((root/'vectors/adversarial').glob('*.pjs')); failures=[]
    for path in files:
        try: cid,exp,actual,errors=check_case(load(path),c)
        except Exception as exc: failures.append((path.name,'parse',str(exc))); continue
        if exp!=actual: failures.append((cid,exp,actual,errors))
    print(f'AP0 VECTOR VALIDATION: {len(files)-len(failures)}/{len(files)} PASS')
    for x in failures: print('FAIL',x)
    return 0 if not failures else 1
if __name__=='__main__': sys.exit(main(sys.argv[1] if len(sys.argv)>1 else Path(__file__).resolve().parents[1]))
