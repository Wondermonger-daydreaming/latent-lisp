#!/usr/bin/env python3
"""UNDERTOW custody probes: import the packet's OWN validator (read-only, no packet writes)
and feed it synthetic projection vectors to test what its accept/reject verdict actually PROVES.
We write .pjs fixtures HERE (outside the mirrored tree), never in the packet."""
import importlib.util, sys
from pathlib import Path

PKG = Path('/home/gauss/Claude-Code-Lab/experiments/latent-lisp/mneme/architecture/adapter-protocol-0/lisp-plus-adapter-protocol-0')
spec = importlib.util.spec_from_file_location('ap0v', PKG/'tools'/'validate_ap0_vectors.py')
v = importlib.util.module_from_spec(spec); spec.loader.exec_module(v)

# PJ-S/0 minimal emitter (id/rec/str) — enough to build projection cases the validator parses.
def esc(s):
    out=[]
    for ch in s:
        cp=ord(ch)
        if ch=='"': out.append('\\"')
        elif ch=='\\': out.append('\\\\')
        elif cp<=0x1f or cp==0x7f: out.append('\\u{%x}'%cp)
        else: out.append(ch)
    return ''.join(out)
def emit(x):
    if x is None: return '#u'
    if x is True: return '#t'
    if x is False: return '#f'
    if isinstance(x,int): return str(x)
    if isinstance(x,tuple) and x and x[0]=='id': return '(id '+' '.join('"'+esc(s)+'"' for s in x[1])+')'
    if isinstance(x,str): return '"'+esc(x)+'"'
    raise TypeError(x)
def ID(*s): return ('id', tuple(s))
def rec(d):
    items=[]
    for k,val in d.items():
        items.append('('+emit(ID('ap0',k))+' '+emit(val)+')')
    return '(rec'+('' if not items else ' '+' '.join(items))+')'

def probe(name, fields):
    p = Path(name+'.pjs'); p.write_text(rec(fields)+'\n', encoding='utf-8')
    cid,exp,actual,errs = v.check_case(v.load(p))
    print(f'{name:34s} verdict={actual:7s} errors={errs}')
    return actual

print("=== PROBE A: metadata-only shape (in spec §14 minimum list, ABSENT from generated table) ===")
probe('A_metadata_only_present', dict(**{'case-id':'A1','family':ID('family','projection'),
    'expected-verdict':ID('verdict','accept'),'shape':'metadata-only','manifestation-status':'present',
    'envelope-captured':True}))

print("\n=== PROBE B: arbitrary UNMAPPED shape (should trigger absence-mapping-table-miss per AP-ABS-1) ===")
probe('B_unknown_shape_not_sentinel', dict(**{'case-id':'B1','family':ID('family','projection'),
    'expected-verdict':ID('verdict','accept'),'shape':'provider-invented-shape-xyz','manifestation-status':'absent-after-completion',
    'envelope-captured':True}))

print("\n=== PROBE C: projection with envelope-captured field ABSENT entirely (AP-ENV-4) ===")
probe('C_envelope_field_absent', dict(**{'case-id':'C1','family':ID('family','projection'),
    'expected-verdict':ID('verdict','accept'),'shape':'nonempty','manifestation-status':'present'}))

print("\n=== PROBE D: control — the packet's own BAD-PRJ-01 sentinel (should reject) ===")
probe('D_sentinel_control', dict(**{'case-id':'D1','family':ID('family','projection'),
    'expected-verdict':ID('verdict','reject'),'shape':'unknown-new-shape','manifestation-status':'absent-after-completion',
    'envelope-captured':True}))
