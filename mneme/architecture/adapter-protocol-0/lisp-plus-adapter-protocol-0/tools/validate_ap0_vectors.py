#!/usr/bin/env python3
"""Independent AP0 fixture validator.

This file does not import the vector generator and implements its own PJ-S/0
scanner/parser and semantic checks. It validates the frozen vectors, not live
providers. Its green standing is self-consistency certification.
"""
from pathlib import Path
import sys, re

class ParseError(Exception): pass

class Scanner:
    def __init__(self,s): self.s=s; self.i=0
    def ws(self):
        while self.i<len(self.s) and self.s[self.i] in ' \t\r\n': self.i+=1
    def peek(self): self.ws(); return self.s[self.i] if self.i<len(self.s) else ''
    def take(self,ch=None):
        self.ws()
        if self.i>=len(self.s): raise ParseError('eof')
        c=self.s[self.i]
        if ch and c!=ch: raise ParseError(f'expected {ch}')
        self.i+=1; return c
    def word(self):
        self.ws(); j=self.i
        while self.i<len(self.s) and self.s[self.i] not in '() \t\r\n': self.i+=1
        if j==self.i: raise ParseError('word')
        return self.s[j:self.i]
    def string(self):
        self.take('"'); out=[]
        while True:
            if self.i>=len(self.s): raise ParseError('string eof')
            c=self.s[self.i]; self.i+=1
            if c=='"': return ''.join(out)
            if c=='\\':
                if self.i>=len(self.s): raise ParseError('escape eof')
                e=self.s[self.i]; self.i+=1
                if e in ['"','\\']: out.append(e)
                elif e=='u':
                    if self.take()!='{': raise ParseError('unicode')
                    j=self.i
                    while self.i<len(self.s) and self.s[self.i]!='}': self.i+=1
                    out.append(chr(int(self.s[j:self.i],16))); self.take('}')
                else: raise ParseError('escape')
            else: out.append(c)

def parse(sc):
    sc.ws()
    if sc.s.startswith('#u',sc.i): sc.i+=2; return None
    if sc.s.startswith('#t',sc.i): sc.i+=2; return True
    if sc.s.startswith('#f',sc.i): sc.i+=2; return False
    if sc.s.startswith('#x"',sc.i):
        sc.i+=2; txt=sc.string(); return bytes.fromhex(txt)
    if sc.peek()=='"': return sc.string()
    if sc.peek()=='(':
        sc.take('('); tag=sc.word()
        if tag=='id':
            vals=[]
            while sc.peek()!=')': vals.append(sc.string())
            sc.take(')'); return ('id',tuple(vals))
        if tag=='seq':
            vals=[]
            while sc.peek()!=')': vals.append(parse(sc))
            sc.take(')'); return vals
        if tag=='rec':
            d={}
            while sc.peek()!=')':
                sc.take('('); key=parse(sc); val=parse(sc); sc.take(')')
                if key in d: raise ParseError('duplicate key')
                d[key]=val
            sc.take(')'); return d
        if tag=='rat':
            n=int(sc.word()); d=int(sc.word()); sc.take(')'); return ('rat',n,d)
        raise ParseError('tag '+tag)
    w=sc.word()
    if re.fullmatch(r'-?(0|[1-9][0-9]*)',w): return int(w)
    raise ParseError('token '+w)

def load(path):
    s=path.read_text(encoding='utf-8')
    sc=Scanner(s); x=parse(sc); sc.ws()
    if sc.i!=len(sc.s): raise ParseError('trailing')
    return x

def field(d,name): return d.get(('id',('ap0',name)))
def idtail(x): return x[1][-1] if isinstance(x,tuple) and len(x)==2 and x[0]=='id' else x

def check_case(d):
    cid=field(d,'case-id'); fam=idtail(field(d,'family')); exp=idtail(field(d,'expected-verdict'))
    errors=[]
    if not cid or not fam or exp not in ('accept','reject'): errors.append('registry fields')
    # Independent semantic rules
    if fam=='acknowledgment' and field(d,'promoted-to') and field(d,'ack-class')=='transport-accepted': errors.append('ack promotion')
    if fam=='request-identity' and field(d,'provider-request-timing')=='unavailable' and field(d,'provider-request-id'): errors.append('invented provider id')
    if fam=='stream':
        if field(d,'adapter-identity') is None: errors.append('missing adapter identity')
        if field(d,'stream-relation') is False: errors.append('missing stream relation')
        if field(d,'gap-hidden') is True: errors.append('hidden stream gap')
        chunks=field(d,'chunks') or []
        if chunks and field(d,'terminal') is False and field(d,'manifestation-status')=='absent-after-completion': errors.append('partial erased')
    if fam=='projection':
        if field(d,'envelope-captured') is False: errors.append('projection before capture')
        if field(d,'shape')=='unknown-new-shape' and field(d,'manifestation-status')!='present-invalid': errors.append('table miss improvised')
        if field(d,'shape')=='invalid-utf8' and field(d,'manifestation-status')!='present-invalid': errors.append('payload erased')
        if field(d,'semantic-truth')=='verified': errors.append('truth minting')
    if fam=='cost':
        amt=field(d,'amount')
        if isinstance(amt,float) or (isinstance(amt,str) and amt.startswith('binary-float:')): errors.append('float money')
        if field(d,'standing')=='missing': errors.append('missing standing')
    if fam=='cancellation' and field(d,'cancel-class')=='socket-closed' and field(d,'claimed')=='provider-settled': errors.append('socket cancellation promotion')
    if fam=='reconciliation' and field(d,'result')=='not-found' and field(d,'domain-complete') is False and field(d,'settles-no-effect') is True: errors.append('incomplete not-found')
    if fam=='exposure' and field(d,'provider-principal') is False: errors.append('provider omitted')
    if fam=='configuration' and field(d,'fallback') is True: errors.append('implicit fallback')
    if fam=='retry' and field(d,'predecessor-unresolved') is True and field(d,'automatic-retry') is True: errors.append('blind retry')
    if fam=='ergonomics':
        a=field(d,'lawful-route-steps'); b=field(d,'bypass-route-steps')
        if b is not None and a>b: errors.append('shorter bypass')
    if fam=='capability' and isinstance(field(d,'capability-standing'),bool): errors.append('boolean capability')
    if fam=='witnessing' and field(d,'self-report-origin')=='observed': errors.append('self testimony promoted')
    actual='reject' if errors else 'accept'
    return cid, exp, actual, errors

def main(root):
    root=Path(root); total=passed=0; failures=[]
    for p in sorted((root/'vectors'/'positive').glob('*.pjs'))+sorted((root/'vectors'/'adversarial').glob('*.pjs')):
        total+=1
        try: cid,exp,actual,errs=check_case(load(p))
        except Exception as e: failures.append((p.name,'parse',str(e))); continue
        if exp==actual: passed+=1
        else: failures.append((cid,exp,actual+':'+','.join(errs)))
    print(f'AP0 VECTOR VALIDATION: {passed}/{total} PASS')
    for f in failures: print('FAIL',f)
    return 0 if not failures else 1

if __name__=='__main__':
    sys.exit(main(sys.argv[1] if len(sys.argv)>1 else Path(__file__).resolve().parents[1]))
