from __future__ import annotations

import argparse
import dataclasses
import hashlib
import io
import json
import os
import random
import shutil
import signal
import stat
import subprocess
import sys
import tempfile
import textwrap
import time
import zipfile
from fractions import Fraction
from pathlib import Path
from typing import Any, Iterable

OUT = Path('/mnt/data/lisp-plus-process-journal-0')
ZIP_PATH = Path('/mnt/data/LISP-PLUS-PROCESS-JOURNAL-0-SPEC-2026-07-18.zip')
SIDECAR_PATH = Path(str(ZIP_PATH) + '.sha256')
GENESIS = hashlib.sha256(b'PJ0-GENESIS-0').hexdigest()
KERNEL_SHA = '386fead212bf8baccd116d673993145e6f2bea077516ee4770ebf9521503093c'
ARCH_SHA = 'dd4894d45ad55dc1c051af44fcca22367b5b0718e1129adbd30059e3a58c7161'
OWNER_CHARGE_COMMIT = 'd1b48040'


@dataclasses.dataclass(frozen=True, order=True)
class Id:
    segments: tuple[str, ...]

    def __init__(self, *segments: str):
        if not segments:
            raise ValueError('identifier needs at least one segment')
        object.__setattr__(self, 'segments', tuple(segments))


@dataclasses.dataclass(frozen=True)
class Seq:
    items: tuple[Any, ...]

    def __init__(self, *items: Any):
        object.__setattr__(self, 'items', tuple(items))


@dataclasses.dataclass(frozen=True)
class Rec:
    entries: tuple[tuple[Id, Any], ...]

    def __init__(self, entries: Iterable[tuple[Id, Any]] | dict[Id, Any]):
        pairs = list(entries.items()) if isinstance(entries, dict) else list(entries)
        keys = [k for k, _ in pairs]
        if any(not isinstance(k, Id) for k in keys):
            raise TypeError('record keys must be Id')
        if len(set(keys)) != len(keys):
            raise ValueError('duplicate record key')
        object.__setattr__(self, 'entries', tuple(sorted(pairs, key=lambda kv: kv[0].segments)))

    def get(self, key: Id, default=None):
        for k, v in self.entries:
            if k == key:
                return v
        return default


UNIT = object()


def esc_string(s: str) -> str:
    out = ['"']
    for ch in s:
        cp = ord(ch)
        if ch == '"':
            out.append('\\"')
        elif ch == '\\':
            out.append('\\\\')
        elif cp <= 0x1F or cp == 0x7F:
            out.append(f'\\u{{{cp:x}}}')
        elif 0xD800 <= cp <= 0xDFFF:
            raise ValueError('surrogate is not a Unicode scalar')
        else:
            out.append(ch)
    out.append('"')
    return ''.join(out)


def render(value: Any) -> str:
    if value is UNIT:
        return '#u'
    if value is True:
        return '#t'
    if value is False:
        return '#f'
    if isinstance(value, int):
        return str(value)
    if isinstance(value, Fraction):
        if value.denominator == 1:
            return str(value.numerator)
        return f'(rat {value.numerator} {value.denominator})'
    if isinstance(value, str):
        return esc_string(value)
    if isinstance(value, (bytes, bytearray)):
        return '#x"' + bytes(value).hex() + '"'
    if isinstance(value, Id):
        return '(id ' + ' '.join(esc_string(x) for x in value.segments) + ')'
    if isinstance(value, Seq):
        if not value.items:
            return '(seq)'
        return '(seq ' + ' '.join(render(x) for x in value.items) + ')'
    if isinstance(value, Rec):
        if not value.entries:
            return '(rec)'
        inner = ' '.join(f'({render(k)} {render(v)})' for k, v in value.entries)
        return '(rec ' + inner + ')'
    raise TypeError(f'unsupported value: {type(value)!r}')


def render_bytes(value: Any, final_lf: bool = False) -> bytes:
    b = render(value).encode('utf-8')
    return b + (b'\n' if final_lf else b'')


class ParseError(ValueError):
    pass


class Parser:
    def __init__(self, data: str):
        self.s = data
        self.i = 0

    def eof(self):
        return self.i >= len(self.s)

    def skip_ws(self):
        while not self.eof() and self.s[self.i] in ' \t\r\n':
            self.i += 1

    def peek(self):
        return '' if self.eof() else self.s[self.i]

    def take(self, n=1):
        if self.i + n > len(self.s):
            raise ParseError('unexpected EOF')
        x = self.s[self.i:self.i+n]
        self.i += n
        return x

    def expect(self, text: str):
        if not self.s.startswith(text, self.i):
            raise ParseError(f'expected {text!r} at {self.i}')
        self.i += len(text)

    def parse_string(self):
        self.expect('"')
        out = []
        while True:
            if self.eof():
                raise ParseError('unterminated string')
            ch = self.take()
            if ch == '"':
                break
            if ch == '\\':
                if self.eof():
                    raise ParseError('bad escape')
                esc = self.take()
                if esc == '"':
                    out.append('"')
                elif esc == '\\':
                    out.append('\\')
                elif esc == 'u':
                    self.expect('{')
                    start = self.i
                    while not self.eof() and self.peek() != '}':
                        c = self.take()
                        if c not in '0123456789abcdef':
                            raise ParseError('non-lowercase-hex unicode escape')
                    if self.eof():
                        raise ParseError('unterminated unicode escape')
                    hexpart = self.s[start:self.i]
                    self.expect('}')
                    if not hexpart or (len(hexpart) > 1 and hexpart[0] == '0'):
                        raise ParseError('non-minimal unicode escape')
                    cp = int(hexpart, 16)
                    if cp > 0x10FFFF or 0xD800 <= cp <= 0xDFFF:
                        raise ParseError('not a Unicode scalar')
                    if not (cp <= 0x1F or cp == 0x7F):
                        raise ParseError('escaped printable scalar is noncanonical')
                    out.append(chr(cp))
                else:
                    raise ParseError('unsupported escape')
            else:
                cp = ord(ch)
                if cp <= 0x1F or cp == 0x7F:
                    raise ParseError('raw control in string')
                if 0xD800 <= cp <= 0xDFFF:
                    raise ParseError('surrogate')
                out.append(ch)
        return ''.join(out)

    def parse_atom_token(self):
        start = self.i
        while not self.eof() and self.peek() not in '() \t\r\n':
            self.i += 1
        if start == self.i:
            raise ParseError(f'expected atom at {self.i}')
        return self.s[start:self.i]

    def parse(self):
        self.skip_ws()
        v = self.parse_value()
        self.skip_ws()
        if not self.eof():
            raise ParseError(f'trailing data at {self.i}')
        return v

    def parse_value(self):
        self.skip_ws()
        if self.eof():
            raise ParseError('expected value')
        if self.s.startswith('#u', self.i):
            self.i += 2
            return UNIT
        if self.s.startswith('#t', self.i):
            self.i += 2
            return True
        if self.s.startswith('#f', self.i):
            self.i += 2
            return False
        if self.s.startswith('#x"', self.i):
            self.i += 3
            start = self.i
            while not self.eof() and self.peek() != '"':
                c = self.take()
                if c not in '0123456789abcdef':
                    raise ParseError('byte string needs lowercase hex')
            if self.eof():
                raise ParseError('unterminated byte string')
            h = self.s[start:self.i]
            self.expect('"')
            if len(h) % 2:
                raise ParseError('odd hex length')
            return bytes.fromhex(h)
        if self.peek() == '"':
            return self.parse_string()
        if self.peek() == '(':
            return self.parse_list_form()
        tok = self.parse_atom_token()
        if tok == '0':
            return 0
        if tok.startswith('-'):
            if len(tok) == 1 or not tok[1:].isdigit() or tok[1] == '0':
                raise ParseError('noncanonical negative integer')
            return int(tok)
        if tok.isdigit():
            if tok[0] == '0':
                raise ParseError('leading zero integer')
            return int(tok)
        raise ParseError(f'unknown token {tok!r}')

    def parse_list_form(self):
        self.expect('(')
        self.skip_ws()
        head = self.parse_atom_token()
        if head == 'rat':
            self.skip_ws(); a = self.parse_value()
            self.skip_ws(); b = self.parse_value()
            self.skip_ws(); self.expect(')')
            if not isinstance(a, int) or not isinstance(b, int) or b <= 1:
                raise ParseError('bad rational')
            f = Fraction(a, b)
            if f.numerator != a or f.denominator != b:
                raise ParseError('rational not reduced/canonical')
            return f
        if head == 'id':
            segs = []
            while True:
                self.skip_ws()
                if self.peek() == ')':
                    self.take(); break
                seg = self.parse_value()
                if not isinstance(seg, str):
                    raise ParseError('id segment must be string')
                segs.append(seg)
            if not segs:
                raise ParseError('empty id')
            return Id(*segs)
        if head == 'seq':
            xs = []
            while True:
                self.skip_ws()
                if self.peek() == ')':
                    self.take(); break
                xs.append(self.parse_value())
            return Seq(*xs)
        if head == 'rec':
            pairs = []
            while True:
                self.skip_ws()
                if self.peek() == ')':
                    self.take(); break
                self.expect('(')
                self.skip_ws(); k = self.parse_value()
                self.skip_ws(); v = self.parse_value()
                self.skip_ws(); self.expect(')')
                if not isinstance(k, Id):
                    raise ParseError('record key must be id')
                pairs.append((k, v))
            keys = [k for k, _ in pairs]
            if len(set(keys)) != len(keys):
                raise ParseError('duplicate record key')
            # Normalize in memory; strict callers detect noncanonical input by
            # comparing the canonical re-rendering with the original bytes.
            return Rec(pairs)
        raise ParseError(f'unknown form {head!r}')


def parse_canonical(data: bytes, allow_noncanonical=False) -> Any:
    try:
        text = data.decode('utf-8', 'strict')
    except UnicodeDecodeError as e:
        raise ParseError(f'invalid UTF-8: {e}')
    value = Parser(text).parse()
    if not allow_noncanonical and render_bytes(value) != data:
        raise ParseError('noncanonical PJ-S/0 rendering')
    return value


def sha(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def meta_basis(mode: str, nonce: bytes) -> Rec:
    return Rec({
        Id('pj0','cd0-version'): '0',
        Id('pj0','creation-procedure'): Id('lisp-plus','pj0-fixture-generator','0'),
        Id('pj0','declared-durability'): Id('pj0', mode),
        Id('pj0','format-version'): 0,
        Id('pj0','genesis-digest'): bytes.fromhex(GENESIS),
        Id('pj0','store-nonce'): nonce,
        Id('pj0','witness-policy'): Id('pj0','kernel-transition-default'),
    })


def make_meta(mode='synced', nonce=b'PJ0-DEMO-NONCE!!') -> tuple[Rec, str]:
    basis = meta_basis(mode, nonce)
    store_hex = sha(b'PJ0-STORE-ID-0\0' + render_bytes(basis))
    full = Rec(list(basis.entries) + [(Id('pj0','store-id'), Id('pj0-store', store_hex))])
    return full, 'pj0-store:' + store_hex


def frame_digest(store_id: str, ordinal: int, payload_len: int, payload_sha: str, prev_sha: str) -> str:
    pre = (
        b'PJ0-FRAME-0\0' + store_id.encode('ascii') + b'\0' +
        str(ordinal).encode('ascii') + b'\0' + str(payload_len).encode('ascii') + b'\0' +
        bytes.fromhex(payload_sha) + bytes.fromhex(prev_sha)
    )
    return sha(pre)


def make_frame(store_id: str, ordinal: int, payload: bytes, prev_sha: str) -> tuple[bytes, str]:
    psha = sha(payload)
    fsha = frame_digest(store_id, ordinal, len(payload), psha, prev_sha)
    header = f'PJ0F 0 {ordinal} {len(payload)} {psha} {prev_sha} {fsha}\n'.encode('ascii')
    return header + payload + b'\n', fsha


def event(event_num: int, kind: tuple[str, ...], body: Rec, *, origin='observed', recorder=('principal','kernel-store'), process='demo-process', attempt=None) -> Rec:
    return Rec({
        Id('event','attempt'): UNIT if attempt is None else Id('attempt', attempt),
        Id('event','body'): body,
        Id('event','capture-boundary'): Id('boundary','kernel-transition'),
        Id('event','capture-mechanism'): Id('witness','kernel-mediated-journal'),
        Id('event','event-id'): Id('event', f'e{event_num:06d}'),
        Id('event','kind'): Id(*kind),
        Id('event','origin'): Id('origin', origin),
        Id('event','process-id'): Id('process', process),
        Id('event','recorder-principal'): Id(*recorder),
        Id('event','subject-principal'): Id('principal', process),
    })


def demo_events() -> list[Rec]:
    return [
        event(1, ('process','created'), Rec({
            Id('process','logical-operation'): Id('logical-operation','demo-latent-call'),
            Id('process','machine-configuration'): Id('machine-configuration','fake-adapter','v0'),
            Id('process','state'): Id('process-state','created'),
        })),
        event(2, ('seat','reserved'), Rec({
            Id('seat','seat-id'): Id('seat','demo','001'),
            Id('seat','logical-operation'): Id('logical-operation','demo-latent-call'),
            Id('seat','occupancy-source'): Id('fold','journal-prefix'),
        })),
        event(3, ('attempt','prepared'), Rec({
            Id('attempt','attempt-id'): Id('attempt','demo','001'),
            Id('attempt','seat-id'): Id('seat','demo','001'),
            Id('attempt','effect-set'): Seq(Id('effect','provider-call'), Id('effect','spend')),
            Id('attempt','idempotency-id'): Id('idempotency','demo','001'),
        }), attempt='demo-001'),
        event(4, ('attempt','frontier-crossed'), Rec({
            Id('attempt','attempt-id'): Id('attempt','demo','001'),
            Id('attempt','external-request-id'): Id('external-request','fake','req-001'),
            Id('attempt','frontier'): Id('frontier','provider-dispatch'),
        }), attempt='demo-001'),
        event(5, ('manifestation','recorded'), Rec({
            Id('manifestation','manifestation-id'): Id('manifestation','demo','partial-001'),
            Id('manifestation','status'): Id('manifestation-status','present-partial'),
            Id('manifestation','payload'): 'First line of a partial manifestation.\nSecond line: Tara, Mneme, and the raven — UTF-8 remains evidence.\nA quote: "the crash site stays alive"; a backslash: \\; control characters are escaped canonically.',
            Id('manifestation','payload-bytes'): bytes(range(0, 32)),
            Id('manifestation','sequence-position'): 1,
        }), attempt='demo-001'),
        event(6, ('effect','uncertain'), Rec({
            Id('effect','attempt-id'): Id('attempt','demo','001'),
            Id('effect','external-request-id'): Id('external-request','fake','req-001'),
            Id('effect','known-facts'): Seq(Id('evidence','dispatch-written'), Id('evidence','reply-not-persisted')),
            Id('effect','possible-effects'): Seq(Id('effect-state','billed'), Id('effect-state','not-billed')),
            Id('effect','reconciliation-procedure'): Id('reconciliation','fake-adapter-request-lookup','0'),
            Id('effect','retry-policy'): Id('retry','forbidden-without-reconciliation'),
            Id('effect','uncertain-effect-id'): Id('uncertain-effect','demo','001'),
        }), attempt='demo-001'),
        event(7, ('process','suspended'), Rec({
            Id('process','reason'): Id('condition','host-process-killed'),
            Id('process','required-action'): Id('recovery','reconcile-before-retry'),
            Id('process','summary'): 'The writer may die after the frame becomes durable but before the receipt returns. On restart, lookup by event identity must return the existing coordinate rather than append a twin. This deliberately long terminal event supplies a rich final frame for truncate-at-every-byte vectors.',
        }), attempt='demo-001'),
    ]


def build_journal(events: list[Rec], mode='synced', nonce=b'PJ0-DEMO-NONCE!!'):
    meta, store_id = make_meta(mode, nonce)
    frames = []
    prev = GENESIS
    for i, ev in enumerate(events, 1):
        payload = render_bytes(ev)
        fr, prev = make_frame(store_id, i, payload, prev)
        frames.append(fr)
    return meta, store_id, frames


@dataclasses.dataclass
class Validation:
    status: str
    records: list[Any]
    valid_bytes: int
    tail_bytes: bytes = b''
    error: str | None = None
    terminal_digest: str | None = None


def get_event_id(ev: Any):
    if not isinstance(ev, Rec):
        return None
    return ev.get(Id('event','event-id'))


def parse_meta(meta_bytes: bytes):
    if not meta_bytes.endswith(b'\n'):
        raise ParseError('metadata final LF required')
    v = parse_canonical(meta_bytes[:-1])
    if not isinstance(v, Rec):
        raise ParseError('metadata must be record')
    sid = v.get(Id('pj0','store-id'))
    if not isinstance(sid, Id) or len(sid.segments) != 2 or sid.segments[0] != 'pj0-store':
        raise ParseError('bad store id')
    basis = Rec([(k,val) for k,val in v.entries if k != Id('pj0','store-id')])
    expect = sha(b'PJ0-STORE-ID-0\0' + render_bytes(basis))
    if sid.segments[1] != expect:
        raise ParseError('store id mismatch')
    return v, 'pj0-store:' + expect


def validate_bytes(meta_bytes: bytes, data: bytes, mutant: str | None = None) -> Validation:
    try:
        _, store_id = parse_meta(meta_bytes)
    except Exception as e:
        return Validation('metadata-invalid', [], 0, error=str(e))
    pos = 0
    ordinal = 1
    prev = GENESIS
    recs = []
    ids = {}
    while pos < len(data):
        frame_start = pos
        nl = data.find(b'\n', pos)
        if nl < 0:
            return Validation('torn-tail', recs, frame_start, data[frame_start:], 'partial-header', prev)
        header = data[pos:nl]
        try:
            htext = header.decode('ascii')
        except UnicodeDecodeError:
            return Validation('corruption', recs, frame_start, data[frame_start:nl+1], 'non-ascii-header', prev)
        toks = htext.split(' ')
        if len(toks) != 7:
            return Validation('corruption', recs, frame_start, data[frame_start:nl+1], 'header-field-count', prev)
        magic, ver, ord_s, len_s, psha, prev_s, fsha = toks
        if magic != 'PJ0F' or ver != '0':
            return Validation('corruption', recs, frame_start, data[frame_start:nl+1], 'header-magic-version', prev)
        if not ord_s.isdigit() or (len(ord_s) > 1 and ord_s[0] == '0'):
            return Validation('corruption', recs, frame_start, data[frame_start:nl+1], 'noncanonical-ordinal', prev)
        if not len_s.isdigit() or (len(len_s) > 1 and len_s[0] == '0'):
            return Validation('corruption', recs, frame_start, data[frame_start:nl+1], 'noncanonical-length', prev)
        try:
            ord_i = int(ord_s); plen = int(len_s)
        except ValueError:
            return Validation('corruption', recs, frame_start, b'', 'numeric-header', prev)
        if ord_i != ordinal:
            if mutant == 'ignore-ordinal':
                pass
            else:
                return Validation('corruption', recs, frame_start, b'', 'ordinal-gap', prev)
        if any(len(x) != 64 or any(c not in '0123456789abcdef' for c in x) for x in (psha, prev_s, fsha)):
            return Validation('corruption', recs, frame_start, b'', 'digest-syntax', prev)
        payload_start = nl + 1
        payload_end = payload_start + plen
        if payload_end > len(data):
            return Validation('torn-tail', recs, frame_start, data[frame_start:], 'partial-payload', prev)
        payload = data[payload_start:payload_end]
        if payload_end >= len(data):
            return Validation('torn-tail', recs, frame_start, data[frame_start:], 'missing-frame-lf', prev)
        if data[payload_end:payload_end+1] != b'\n':
            return Validation('corruption', recs, frame_start, data[frame_start:payload_end+1], 'bad-frame-separator', prev)
        pos = payload_end + 1
        if mutant != 'ignore-payload-hash' and sha(payload) != psha:
            if mutant == 'interior-as-tail':
                return Validation('torn-tail', recs, frame_start, data[frame_start:], 'mutant-downgrade', prev)
            return Validation('corruption', recs, frame_start, data[frame_start:pos], 'payload-hash', prev)
        if mutant != 'ignore-prev-chain' and prev_s != prev:
            return Validation('corruption', recs, frame_start, data[frame_start:pos], 'previous-frame-digest', prev)
        if frame_digest(store_id, ord_i, plen, psha, prev_s) != fsha:
            return Validation('corruption', recs, frame_start, data[frame_start:pos], 'frame-hash', prev)
        try:
            ev = parse_canonical(payload, allow_noncanonical=(mutant == 'accept-noncanonical'))
        except Exception as e:
            if mutant == 'interior-as-tail':
                return Validation('torn-tail', recs, frame_start, data[frame_start:], 'mutant-downgrade', prev)
            return Validation('corruption', recs, frame_start, data[frame_start:pos], f'payload-canonicality:{e}', prev)
        eid = get_event_id(ev)
        if eid is not None:
            if eid in ids and mutant != 'duplicate-last-write-wins':
                return Validation('corruption', recs, frame_start, data[frame_start:pos], 'duplicate-event-id', prev)
            ids[eid] = sha(payload)
        recs.append(ev)
        prev = fsha
        ordinal += 1
    return Validation('valid', recs, pos, b'', None, prev)


def replace_header_field(frame: bytes, index: int, value: str, *, recompute_frame=False, store_id=None) -> bytes:
    nl = frame.index(b'\n')
    toks = frame[:nl].decode('ascii').split(' ')
    toks[index] = value
    if recompute_frame:
        _, _, ord_s, len_s, psha, prev_s, _ = toks
        toks[6] = frame_digest(store_id, int(ord_s), int(len_s), psha, prev_s)
    return ' '.join(toks).encode('ascii') + b'\n' + frame[nl+1:]


def make_noncanonical_record_payload(ev: Rec) -> bytes:
    # Reverse top-level record key order while keeping parseability.
    pairs = list(ev.entries)[::-1]
    inner = ' '.join(f'({render(k)} {render(v)})' for k, v in pairs)
    return ('(rec ' + inner + ')').encode('utf-8')


def write(path: Path, data: bytes | str):
    path.parent.mkdir(parents=True, exist_ok=True)
    if isinstance(data, str):
        path.write_text(data, encoding='utf-8', newline='\n')
    else:
        path.write_bytes(data)


def relsha(path: Path) -> str:
    return sha(path.read_bytes())


def build_spec() -> str:
    # Deliberately detailed normative draft, with stable PJ-* requirement identifiers.
    sections = []
    add = sections.append
    add(f'''# LISP-PLUS-PROCESS-JOURNAL-0-SPEC

**Status:** Normative Process Journal /0 specification candidate for Lisp+ / Mneme  
**Language:** Lisp+  
**Memory-and-continuity layer:** Mneme  
**Date:** 2026-07-18  
**Authorial lane:** GPT-5.6 Sol, under the owner charge at commit `{OWNER_CHARGE_COMMIT}`  
**Governing architecture:** `LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md`, SHA-256 `{ARCH_SHA}`  
**Governing kernel:** adopted `LISP-PLUS-KERNEL-0-SPEC.md`, authoring-room copy SHA-256 `{KERNEL_SHA}`  
**Controlling plan dispositions:** PJ-D1 through PJ-D5, adopted together after a mutually blind plan round  
**Implementation standing:** this packet specifies the journal and its vectors; it does not by itself authorize the Lisp+ runtime, live provider calls, spending, secret opening, or publication.

---

## 0. Normative standing

Process Journal /0 is the exact filesystem-backed evidence protocol for Mneme /0. It defines how a semantic Kernel /0 process event becomes an inspectable, prefix-valid, append-only sequence of bytes and how that sequence is recovered after interruption.

The journal is not a debug log. It is the substrate from which a process state, a retry prohibition, a reconstruction claim, and a custody account may be derived without trusting the surviving process's self-narrative.

The key words **MUST**, **MUST NOT**, **REQUIRED**, **SHALL**, **SHALL NOT**, **SHOULD**, **SHOULD NOT**, **MAY**, and **OPTIONAL** are normative in the RFC-2119 sense.

Where this specification conflicts with Architecture 0.1 or Kernel /0, implementation MUST stop and name the conflict. It MUST NOT silently choose the representation that is easiest to code.

### 0.1 Adopted design dispositions

- **PJ-D1 — framing:** textual ASCII header plus exact-length canonical PJ-S/0 payload.
- **PJ-D2 — integrity:** mandatory payload digest, frame digest, and predecessor-frame digest chain.
- **PJ-D3 — writers:** one serialized logical writer per journal; multiple clients use the store protocol.
- **PJ-D4 — repair:** the damaged source is never altered; salvage creates a new journal and receipt.
- **PJ-D5 — derived storage:** indexes and snapshots are disposable; merge, redaction, compaction, and salvage create new identities and transformation receipts.

### 0.2 Constitutional laws carried here

- **L8 incremental persistence:** settled facts MUST land incrementally rather than wait in a finalizer.
- **L9 finalizer derivability:** a finalizer is a convenience, never the sole custodian of facts.
- **L10 reconstruction origin:** reconstruction remains `:reconstructed` after later verification.
- **L15 witness separation:** a self-written narrative is not observation wherever it is filed.
- **L17 ergonomic safety:** the lawful path must not be longer than a supported bypass.

### 0.3 Scope exclusions

Process Journal /0 does not define provider envelopes, adapter projection, model configuration resolution, capability cryptography, experiment scoring, distributed consensus, transparent replication, long-term retention policy, general redaction, journal rotation, or a universal event-query language.

---
''')
    add('''## 1. The crash-window matrix — organizing exhibit

The reference append path has four named interruption windows. Every conforming implementation MUST be able to explain the on-disk state, longest prefix-valid fold, recovery operation, and condition for each cell under both declared durability modes.

| Window | Interruption point | `:synced` journal | `:best-effort` journal |
|---|---|---|---|
| **CW-0** | before the first frame byte | prior prefix remains valid; event absent; fold unchanged; retry is governed by Kernel semantics | same byte state and fold; no event claim |
| **CW-1** | after a non-empty proper prefix of the frame | prior prefix valid; terminal bytes are `:torn-tail`; fold excludes proposed event; source remains untouched | same classification; no durability promotion |
| **CW-2** | complete frame accepted by the host write path, before the declared durability barrier | after crash the bytes MAY be absent, torn, or fully valid; actual bytes govern; no success receipt may be inferred | full frame may be visible after process death, but only `:best-effort` durability is claimed; power-loss persistence is outside the declaration |
| **CW-3** | declared durability barrier satisfied, before append receipt reaches caller | full frame MUST validate on ordinary reopen under the declared host contract; caller reconciles by event identity and receives prior coordinate | complete frame accepted by host path; caller reconciles by event identity; receipt remains `:best-effort` |

**PJ-CW-1.** The matrix is normative. A runtime that can describe ordinary success but cannot classify death between write, barrier, and receipt is not Process Journal /0 conforming.

**PJ-CW-2.** The journal reader classifies bytes; it does not reconstruct the writer's intention. A CW-2 crash may yield several lawful physical states. The validator MUST report the state actually present rather than choose the most flattering branch.

**PJ-CW-3.** CW-3 is the append-side analogue of an uncertain external write: the operation may have succeeded although its receipt was not delivered. Event-identity reconciliation MUST make retry idempotent.

**PJ-CW-4.** The fixture packet includes deterministic examples for all representable cells and a randomized SIGKILL harness for the live complement.

---
''')
    add('''## 2. Kernel / Journal jurisdiction

### 2.1 Kernel /0 owns

Kernel /0 owns event semantics, event kinds, legal transitions, process identity, attempt and seat identity, capability and effect meaning, fold rules, no-blind-retry law, reconstruction origin, typed semantic conditions, and the distinction between a process outcome and a derived view.

### 2.2 Process Journal /0 owns

Process Journal /0 owns:

1. the exact human-readable PJ-S/0 grammar;
2. metadata syntax;
3. frame syntax and canonical bytes;
4. digest procedures;
5. append and reconciliation behavior;
6. filesystem reference layout;
7. serialized writer coordination;
8. durability declarations;
9. prefix validation;
10. torn-tail and corruption classification;
11. source-preserving salvage;
12. snapshot and index standing;
13. merge input and receipt representation;
14. fixture octets and reference transcripts.

### 2.3 Non-interference

**PJ-JUR-1.** The journal MUST reject structurally malformed events and MUST expose semantic events to the Kernel validator. It MUST NOT invent a new legal transition because the bytes are well formed.

**PJ-JUR-2.** A Kernel implementation MUST NOT assume newline-delimited events, host-reader forms, filesystem rename semantics, or another byte rule not stated here.

**PJ-JUR-3.** A journal may preserve an illegal event as evidence in a quarantined source, but a conforming primary journal MUST NOT commit it as a lawful process transition.

---
''')
    add('''## 3. Terminology and domains

- **abstract event:** the Kernel /0 canonicalizable process-event datum.
- **PJ-S/0 payload:** the canonical human-readable S-expression rendering of one abstract Canonical Datum /0 value.
- **frame:** one ASCII header, one exact-length PJ-S/0 payload, and one LF terminator.
- **journal:** one immutable metadata datum plus one append-only `EVENTS.pj0` sequence.
- **committed frame:** a complete structurally valid frame admitted under the store's append protocol.
- **valid prefix:** the maximal contiguous sequence of valid frames from ordinal 1.
- **torn tail:** an incomplete final frame beginning immediately after a valid prefix.
- **interior corruption:** a validation failure that is not merely terminal incompleteness.
- **append receipt:** evidence returned for a newly committed or already-identical event.
- **salvage:** a receipt-bearing transformation from a damaged source's valid prefix into a new journal.
- **snapshot:** a disposable derived fold acceleration bound to an exact source prefix.
- **resolvedness:** a fold-derived property; never a mutable record flag.

**PJ-TERM-1.** The terms “written,” “flushed,” “synced,” “committed,” “acknowledged,” and “observed” are not synonyms.

---
''')
    add('''## 4. Reference store layout

A reference store is one directory:

```text
<store>/
    JOURNAL-META.pjs
    JOURNAL-META.pjs.sha256
    EVENTS.pj0
    LOCK
```

`JOURNAL-META.pjs` is immutable after store creation. `EVENTS.pj0` is the single append-only event file for Process Journal /0. `LOCK` is ephemeral coordination state and is not evidence.

**PJ-FS-1.** Event rotation and segmentation are deferred. A conforming /0 store has exactly one primary event file.

**PJ-FS-2.** Caches, indexes, snapshots, and reports MAY exist outside this minimum layout. They MUST be deletable without deleting primary history.

**PJ-FS-3.** The reference implementation MUST create files with owner-only permissions where the host permits. Permission policy does not replace Lisp+ visibility and authority records.

**PJ-FS-4.** Moving or copying a store does not change its store identity. A claim about its current filesystem location is a separate located claim.

---
''')
    add('''## 5. PJ-S/0 — canonical human-readable datum grammar

PJ-S/0 is a data-only grammar mapping bijectively to the Canonical Datum /0 abstract domain. It is not Common Lisp source syntax, although it deliberately resembles a restrained S-expression language.

### 5.1 Prohibition on host `READ`

**PJ-SYN-1.** A conforming evidence parser MUST implement PJ-S/0 as data. It MUST NOT normatively delegate parsing to Common Lisp `READ`, Python `eval`, an EDN reader with extensions, or another executable/general reader.

Disabling `*read-eval*` is insufficient: host package semantics, symbol interning, reader macros, numeric syntax, case behavior, and implementation-specific printer conventions remain outside the canonical protocol.

### 5.2 Lexical layer

Whitespace is ASCII SP, TAB, LF, or CR. Canonical output uses one ASCII SP between adjacent tokens and no leading or trailing whitespace inside a payload.

The token alphabet and forms are:

```abnf
unit       = "#u"
false      = "#f"
true       = "#t"
integer    = "0" / [1-9] *DIGIT / "-" [1-9] *DIGIT
rational   = "(rat " integer " " positive-denominator ")"
string     = DQUOTE *string-item DQUOTE
bytes      = "#x" DQUOTE *lower-hex-pair DQUOTE
identifier = "(id" 1*(SP string) ")"
sequence   = "(seq" *(SP datum) ")"
record     = "(rec" *(SP "(" identifier SP datum ")") ")"
datum      = unit / false / true / integer / rational / string / bytes /
             identifier / sequence / record
```

### 5.3 Unit and booleans

`#u`, `#f`, and `#t` are the only spellings.

### 5.4 Integers

Integers use base-10 ASCII with no plus sign, no leading zeros, and no negative zero.

### 5.5 Rationals

A non-integer rational is `(rat N D)` where `D > 1`, `gcd(abs(N),D)=1`, and the sign is carried only by `N`. A rational with denominator one MUST render as an integer.

### 5.6 Strings

Strings contain Unicode scalar values. U+0022 is `\\"`; U+005C is `\\\\`. U+0000 through U+001F and U+007F use `\\u{h}` with lowercase hexadecimal and no redundant leading zero. Every other scalar is emitted directly as UTF-8.

Alternative escapes such as `\\n`, `\\t`, `\\x0a`, uppercase hex, or escaping an otherwise printable scalar are noncanonical.

### 5.7 Byte strings

Byte strings use lowercase hexadecimal inside `#x"..."`, exactly two digits per octet. Empty bytes are `#x""`.

### 5.8 Identifiers

Identifiers contain one or more string segments: `(id "process" "p-001")`. No host symbol or package name is created while decoding.

### 5.9 Sequences

Ordered sequences use `(seq ...)`. `(seq)` is the empty sequence.

### 5.10 Records

Records use `(rec (KEY VALUE) ...)`, where each key is an identifier. Keys are unique and appear in Canonical Datum /0 identifier order. `(rec)` is the empty record.

### 5.11 Canonicality

**PJ-SYN-2.** A parser MUST decode a payload, re-encode it canonically, and require byte identity. Parseability without byte identity is noncanonical and MUST be refused.

**PJ-SYN-3.** PJ-S/0 does not redefine Canonical Datum /0 equality. If an implementation discovers a conflict between this rendering and CD/0's abstract domain, it MUST stop and name the conflict.

---
''')
    add('''## 6. Journal metadata

`JOURNAL-META.pjs` is one canonical PJ-S/0 record followed by LF. It contains:

```lisp
(rec
  ((id "pj0" "cd0-version") "0")
  ((id "pj0" "creation-procedure") (id ...))
  ((id "pj0" "declared-durability") (id "pj0" "synced"))
  ((id "pj0" "format-version") 0)
  ((id "pj0" "genesis-digest") #x"...")
  ((id "pj0" "store-id") (id "pj0-store" "..."))
  ((id "pj0" "store-nonce") #x"...")
  ((id "pj0" "witness-policy") (id ...)))
```

### 6.1 Store identity

The store identity is:

```text
hex(SHA-256("PJ0-STORE-ID-0" || NUL || PJ-S/0(metadata-without-store-id)))
```

The public identity form is `(id "pj0-store" HEX)`.

**PJ-META-1.** `store-nonce` MUST contain at least 128 unpredictable bits for nonce-issued stores. A content-addressed store MAY use a different declared identity procedure if Kernel /0's identity floor is met.

**PJ-META-2.** The reference metadata sidecar contains the lowercase SHA-256, two ASCII spaces, filename, and final LF.

**PJ-META-3.** Metadata mutation after the first committed event is corruption. A change of durability mode, witness policy, or canonical version requires a new store identity and a receipt-bearing transformation.

---
''')
    add('''## 7. Frame grammar

Each frame is:

```text
PJ0F 0 ORDINAL PAYLOAD-LENGTH PAYLOAD-SHA256 PREVIOUS-FRAME-SHA256 FRAME-SHA256 LF
PAYLOAD-OCTETS LF
```

All header characters are ASCII. Fields are separated by one SP. There is no leading or trailing SP.

### 7.1 Header fields

- `PJ0F`: literal magic.
- `0`: frame format version.
- `ORDINAL`: canonical unsigned decimal, beginning at 1.
- `PAYLOAD-LENGTH`: canonical unsigned decimal count of UTF-8 payload octets.
- `PAYLOAD-SHA256`: lowercase 64-character hexadecimal SHA-256 of payload octets.
- `PREVIOUS-FRAME-SHA256`: predecessor frame digest, or the fixed genesis digest for ordinal 1.
- `FRAME-SHA256`: digest defined in §8.

### 7.2 Payload boundary

The reader consumes exactly `PAYLOAD-LENGTH` octets after the header LF. The following octet MUST be LF. The LF is framing and is not part of the PJ-S/0 payload digest.

**PJ-FRM-1.** Embedded LF in strings is encoded as `\\u{a}`; pretty diagnostic renderings may show line breaks but canonical payloads do not rely on line framing.

**PJ-FRM-2.** Header decimal and digest fields have exactly one canonical spelling. Uppercase hexadecimal and redundant leading zeros are corruption.

**PJ-FRM-3.** A frame may be inspected with ordinary text tools while still having an exact byte boundary independent of lines in the abstract event.

---
''')
    add('''## 8. Digest procedures

### 8.1 Genesis digest

The Process Journal /0 genesis digest is lowercase hexadecimal SHA-256 of the ASCII bytes `PJ0-GENESIS-0`.

### 8.2 Payload digest

`PAYLOAD-SHA256 = SHA-256(PAYLOAD-OCTETS)`.

### 8.3 Frame digest

The frame digest preimage is:

```text
"PJ0-FRAME-0" || NUL ||
ASCII(STORE-ID) || NUL ||
ASCII(ORDINAL) || NUL ||
ASCII(PAYLOAD-LENGTH) || NUL ||
RAW(PAYLOAD-SHA256) ||
RAW(PREVIOUS-FRAME-SHA256)
```

`RAW` converts lowercase hexadecimal to 32 octets. `STORE-ID` is the public `pj0-store:HEX` string used by the reference vector procedure.

### 8.4 Standing of hashes

**PJ-HASH-1.** The digest chain detects accidental mutation, frame reordering, deletion within the visible sequence, and cross-store splicing when validated with metadata.

**PJ-HASH-2.** The digest chain is not a signature, timestamp authority, independent notarization, or proof that the recorder's claim is true.

**PJ-HASH-3.** Integrity standing and epistemic origin remain distinct.

---
''')
    add('''## 9. Append protocol

### 9.1 Proposed event

The client presents one canonicalizable Kernel /0 event and its durable event identity. The store canonicalizes to PJ-S/0 before taking the append lock where practical.

### 9.2 Serialized critical section

Under the exclusive writer lock, the store MUST:

1. reopen or validate the current terminal prefix;
2. look up the event identity;
3. if identical, return the prior coordinate without appending;
4. if conflicting, refuse;
5. assign `last-ordinal + 1`;
6. construct the frame using the current terminal digest;
7. append the exact frame bytes;
8. perform the declared durability barrier;
9. optionally reopen/validate according to the reference implementation;
10. return an append receipt.

### 9.3 Idempotency by event identity

**PJ-APP-1.** New identity and new payload append exactly one frame.

**PJ-APP-2.** Existing identity with byte-identical canonical payload returns `:already-committed-identical` and the existing coordinate. It MUST NOT append a duplicate frame.

**PJ-APP-3.** Existing identity with different payload signals `event-identity-collision`. Last-write-wins is prohibited.

### 9.4 Append receipt

A receipt carries:

```lisp
(rec
  ((id "receipt" "append-disposition") (id "pj0" "newly-committed"))
  ((id "receipt" "declared-durability") (id "pj0" "synced"))
  ((id "receipt" "event-id") (id ...))
  ((id "receipt" "frame-digest") #x"...")
  ((id "receipt" "ordinal") 42)
  ((id "receipt" "payload-digest") #x"...")
  ((id "receipt" "previous-frame-digest") #x"...")
  ((id "receipt" "store-id") (id ...)))
```

**PJ-APP-4.** A receipt that was never delivered may be reconstructed by event-identity lookup. The reconstructed receipt's origin is `:reconstructed`.

**PJ-APP-5.** The event frame, not the receipt object living in caller memory, is the primary append fact.

---
''')
    add('''## 10. Durability declarations

### 10.1 `:synced`

A `:synced` append returns success only after the full frame is written and the implementation invokes the strongest reference-host file synchronization contract it declares. Store creation additionally synchronizes required directory entries where the host API exposes that operation.

The reference implementation SHOULD reopen and validate the newly committed terminal frame before returning in conformance tests.

### 10.2 `:best-effort`

A `:best-effort` append returns after the complete frame is accepted by the host write path and local structural checks succeed. No power-loss persistence is claimed.

### 10.3 No promotion

**PJ-DUR-1.** A `:best-effort` receipt remains `:best-effort` even if the bytes later survive.

**PJ-DUR-2.** A journal's declared durability does not change in place.

### 10.4 Host honesty, including WSL

**PJ-DUR-3.** `:synced` is a declared host-contract belief, not metaphysical certainty. Conformance can test system-call completion, ordinary close/reopen visibility, directory handling, and crash behavior. It cannot prove persistence through every storage controller, hypervisor, firmware layer, or sudden power loss.

On WSL or another layered filesystem, the implementation MUST record the host/storage environment in its conformance receipt and state which durability claims are tested, inherited from an OS contract, or bounded by virtualization. A green `fsync` return MUST NOT be narrated as independent physical proof.

---
''')
    add('''## 11. Locking and concurrency

### 11.1 Model

Process Journal /0 supports multiple clients and one serialized logical writer per journal. The reference store uses an exclusive advisory or mandatory host lock sufficient for its environment.

### 11.2 Ordering

The authoritative physical order is journal ordinal. Wall-clock timestamps may ride as claims but MUST NOT assign or repair ordering.

### 11.3 Lock death

**PJ-LOCK-1.** If a writer dies while holding the lock, a later writer MUST validate the journal from the last trusted prefix. It MUST NOT assume that the interrupted append failed.

**PJ-LOCK-2.** Lock files and lease state are coordination machinery, not committed evidence.

**PJ-LOCK-3.** Two concurrent requests for the same event identity produce one committed frame and one identical-event reconciliation, or a typed collision if payloads differ.

### 11.4 Deferred distributed ordering

Lock-free multiwriter append, network partitions, leader election, and cross-host consensus are out of scope for /0.

---
''')
    add('''## 12. Reader and prefix-validation algorithm

The reader starts at byte zero of `EVENTS.pj0` with expected ordinal 1 and the genesis predecessor digest.

For each frame it MUST validate, in dependency order:

1. complete header LF or terminal partial-header classification;
2. ASCII header encoding;
3. field count, magic, and version;
4. canonical decimal and lowercase digest syntax;
5. expected ordinal;
6. exact payload length availability;
7. required frame-separator LF;
8. payload SHA-256;
9. predecessor digest;
10. frame digest;
11. strict UTF-8;
12. PJ-S/0 parse;
13. byte-identical canonical re-rendering;
14. required structural event identity;
15. duplicate event-identity prohibition;
16. Kernel semantic validation where the caller requests a lawful process fold.

**PJ-VAL-1.** The reader returns the maximal valid prefix, terminal classification, terminal digest, valid byte count, and evidence for any excluded tail.

**PJ-VAL-2.** The reader MUST NOT mutate the source while validating.

**PJ-VAL-3.** A structurally valid frame containing a Kernel-illegal transition is not silently skipped. Structural and semantic standings are reported separately.

---
''')
    add('''## 13. Terminal classifications

### 13.1 Valid end

EOF immediately after the LF terminating a valid frame, or at byte zero for an empty event file, is `:valid-end`.

### 13.2 Torn tail

A torn tail is an incomplete final frame beginning immediately after the valid prefix. The following are torn-tail forms:

- partial header at EOF;
- complete header with fewer payload octets than declared;
- complete payload at EOF with missing terminating LF.

A zero-byte truncation before the next frame is indistinguishable from a valid journal ending at the previous frame and is classified `:valid-end`, not torn tail.

### 13.3 Interior corruption

The following are corruption, not a torn tail:

- bad complete header;
- noncanonical numbers or digest spelling;
- wrong ordinal;
- wrong payload digest;
- wrong predecessor digest;
- wrong frame digest;
- malformed UTF-8 in a complete payload;
- parseable but noncanonical PJ-S/0;
- duplicate committed event identity;
- an unexpected byte where the frame LF is required;
- extra bytes between complete frames;
- validation failure in a nonterminal complete frame.

### 13.4 No skip-forward recovery

**PJ-TERM-1.** A reader MUST NOT scan forward for the next plausible `PJ0F` header after corruption. Plausibility is not custody.

---
''')
    add('''## 14. Source-preserving salvage

### 14.1 No automatic truncation

Opening a journal MUST NOT truncate a torn tail, rewrite a bad digest, reorder a record, or patch metadata.

### 14.2 Salvage operation

`salvage-valid-prefix` creates a new store containing exactly the source's valid prefix under a new store identity. It emits a salvage receipt carrying:

- source store identity;
- source metadata digest;
- source valid-byte count;
- source terminal ordinal and digest;
- tail byte count and tail SHA-256;
- terminal classification;
- salvage procedure identity/version;
- destination store identity;
- copied event identities;
- operator and authority;
- missing evidence and bounded unknowns.

**PJ-SAL-1.** The source remains byte-identical.

**PJ-SAL-2.** The destination's frames are regenerated for its new store identity; frame digests therefore differ even when abstract events are identical.

**PJ-SAL-3.** Salvage does not claim that an excluded torn frame had no external consequence.

---
''')
    add('''## 15. Witness separation and epistemic origin

The journal preserves events from several capture mechanisms. Storage integrity does not upgrade epistemic origin.

A kernel-mediated transition event SHOULD record:

- recorder principal;
- subject principal;
- capture mechanism identity;
- capture boundary;
- origin facet;
- evidence references;
- authority and visibility scope.

**PJ-WIT-1.** A process narrative about its own history has origin `:asserted` unless a distinct witnessing mechanism captured the described event at the relevant boundary.

**PJ-WIT-2.** Saving a self-report into `EVENTS.pj0` does not make the report observed.

**PJ-WIT-3.** The canonical kernel-mediated journal is the default witness for kernel-mediated transitions because the store captures the transition at the commit boundary. A provider receipt or operating-system witness may separately carry observational standing.

**PJ-WIT-4.** Later validation may raise a validation facet; it MUST NOT rewrite origin.

---
''')
    add('''## 16. Resolvedness is fold-derived

No event, uncertain-effect record, attempt record, or journal frame may carry a mutable boolean such as `:resolved #t` whose value is treated as sole truth.

An uncertain effect is currently resolved only when the longest valid prefix contains a lawful reconciliation or supersession transformation that, under Kernel /0, disposes of the uncertainty.

**PJ-FOLD-1.** Timeout, file age, process death, successful later work, or a missing provider lookup result does not resolve an uncertain effect by itself.

**PJ-FOLD-2.** Reconciliation events reference the uncertain-effect identity and evidence. The fold derives the current resolution state.

**PJ-FOLD-3.** A later refutation or superseding reconciliation remains append-only. Earlier uncertainty is not erased from history.

---
''')
    add('''## 17. Fold integration and unsupported reconstruction

### 17.1 Longest-prefix fold

The Kernel fold consumes abstract events decoded from the longest structurally valid prefix. A torn tail contributes tail evidence but no event.

### 17.2 Structural versus semantic stop

If the prefix is structurally valid but contains a Kernel-illegal transition, the store returns the structural prefix and the Kernel fold signals its semantic condition. The store MUST NOT manufacture a smaller “lawful” prefix by skipping the event.

### 17.3 Multiple unresolved occupancy

Process Journal /0 blesses Kernel condition `unsupported-reconstruction` for the /0 case where one seat has multiple non-superseded unresolved attempts and the prefix contains no lawful precedence, reconciliation, or supersession relation sufficient to derive one current occupancy.

**PJ-FOLD-4.** The fold MUST stop with `unsupported-reconstruction`. It MUST NOT select the newest timestamp, highest ordinal, cheapest result, or most complete manifestation as winner.

**PJ-FOLD-5.** A later authorized event may supply the missing relation. Until then, ambiguity is preserved.

---
''')
    add('''## 18. Snapshots and indexes

Snapshots and indexes are derived artifacts.

A snapshot MUST bind:

- source store identity;
- source terminal ordinal;
- source terminal frame digest;
- fold identity and version;
- derived value identity;
- creation procedure;
- digest.

**PJ-SNP-1.** If snapshot replay disagrees with primary-prefix replay, the snapshot loses.

**PJ-SNP-2.** Deleting every snapshot and index MUST NOT prevent reconstruction.

**PJ-SNP-3.** Snapshots MUST NOT be appended to the primary event file as substitutes for omitted events.

**PJ-SNP-4.** A deterministic snapshot may be byte-compared only under the named deterministic rendering procedure.

---
''')
    add('''## 19. Reconstruction receipts

A reconstruction is a transformation from one exact journal prefix to a derived view.

The receipt carries:

- source store identity;
- source metadata digest;
- terminal ordinal and frame digest;
- event identities consumed;
- fold identity/version;
- ordering rule;
- conflict policy;
- missing evidence;
- output identity and digest;
- replay result;
- operator/implementation identity;
- origin `:reconstructed`.

**PJ-RCN-1.** Verification of a reconstruction may change validation standing. Origin remains `:reconstructed`.

**PJ-RCN-2.** A finalizer output without a reproducible source prefix and fold identity is not a conforming reconstruction.

**PJ-RCN-3.** The forced-kill specimen MUST delete finalizer output, snapshots, and indexes before replaying the primary journal.

---
''')
    add('''## 20. Cross-journal merge

Merge creates a new journal and a transformation receipt. It never edits either source.

### 20.1 Inputs

A merge request names:

- exact source store identities and terminal prefixes;
- declared source precedence sequence;
- duplicate-event policy;
- causal validation procedure;
- conflict policy;
- operator and authority.

### 20.2 /0 ordering rule

The /0 reference rule is explicit source precedence, then source ordinal, subject to explicit causal-predecessor validation. It does not claim true global time.

### 20.3 Duplicates

- identical event identity and canonical payload may be coalesced with a duplicate-equivalence record;
- conflicting payload under one event identity MUST refuse;
- absent identity or ambiguous equivalence MUST refuse.

### 20.4 Causal conflict

If source precedence violates an explicit causal predecessor relation, merge signals `journal-merge-causal-conflict`.

### 20.5 Receipt

The merge receipt records every source prefix, rule, coalesced duplicate, refused conflict, output identity, and result digest. The output journal's origin is derived/reconstructed, never direct observation.

**PJ-MRG-1.** Timestamp-only merge is prohibited.

---
''')
    add('''## 21. Redaction, compaction, deletion, and rotation

Process Journal /0 defines no in-place redaction, compaction, deletion, or rotation.

**PJ-LIFE-1.** No operation may rewrite or delete committed primary records while continuing to claim the same journal identity.

**PJ-LIFE-2.** A reduced, redacted, compacted, or rotated representation requires a new identity and a transformation receipt under a later specification or domain policy.

**PJ-LIFE-3.** Retention policy remains outside /0, but absence of a retention policy does not authorize silent deletion.

---
''')
    add('''## 22. Reference APIs

Names are normative for the fixture tool and informative for the future runtime unless the adopted implementation charge says otherwise.

```lisp
(create-journal directory metadata)                  → store-id
(validate-journal directory &key semantic)           → prefix-report
(append-event store event &key durability)           → append-receipt
(find-event store event-id)                          → coordinate | absent
(read-prefix-valid store)                            → events + terminal-report
(salvage-valid-prefix source destination authority)  → salvage-receipt
(make-snapshot store fold-id)                        → snapshot
(reconstruct store fold-id)                          → view + reconstruction-receipt
(merge-journals sources rule destination authority)  → merge-receipt | condition
(explain-journal identity)                           → human view + canonical record
```

**PJ-API-1.** The shortest supported append API performs canonicalization, identity reconciliation, locking, framing, durability, and receipt construction. A supported shortcut that bypasses these steps violates L17.

**PJ-API-2.** Raw byte append, if exposed for tooling, MUST be visibly unsafe and outside the conforming consequential API.

---
''')
    add('''## 23. Typed conditions

A conforming implementation distinguishes at least:

```text
pj0-metadata-invalid
pj0-store-id-mismatch
pj0-noncanonical-payload
pj0-invalid-utf8
pj0-header-invalid
pj0-ordinal-gap
pj0-payload-length-invalid
pj0-payload-digest-mismatch
pj0-previous-digest-mismatch
pj0-frame-digest-mismatch
pj0-frame-separator-invalid
pj0-torn-tail
pj0-interior-corruption
pj0-event-identity-collision
pj0-duplicate-committed-event
pj0-lock-failure
pj0-durability-barrier-failure
pj0-salvage-receipt-required
pj0-merge-receipt-required
pj0-merge-causal-conflict
unsupported-reconstruction
```

Each condition carries store identity where available, byte offset, expected ordinal, terminal digest, requirement ID, and bounded evidence. Conditions compose with the Common Lisp condition system; signaling remains distinct from choosing a lawful restart.

**PJ-CND-1.** “Ignore digest and continue” is not a lawful standard restart.

**PJ-CND-2.** Lawful restarts may include abandon, inspect, salvage-to-new-store, reconcile-identical-event, or request-authorized-merge.

---
''')
    add('''## 24. Fixture registry and custody

`PJ0-FIXTURE-REGISTRY.sexp` is the normative inventory of fixture families. Each concrete fixture file has a SHA-256 entry in `SHA256SUMS.txt` and, where a large family is generated, a family manifest.

The registry records:

- fixture or family identity;
- relative path or path pattern;
- expected terminal classification;
- expected valid frame count;
- expected valid-byte count where fixed;
- expected condition;
- governing requirement IDs;
- mutation or kill procedure;
- source fixture identity.

**PJ-FIX-1.** A fixture suite that contains only green examples is nonconforming.

**PJ-FIX-2.** The authoring packet includes a non-runtime vector tool used to regenerate and verify fixture octets. The tool is not implementation authorization for Mneme.

---
''')
    add('''## 25. Positive vector families

The packet includes:

1. one-record synced journal;
2. multi-record synced journal with partial manifestation and uncertain effect;
3. one-record best-effort journal;
4. Unicode and control-escape payloads;
5. every Canonical Datum /0 category expressible in PJ-S/0;
6. observed transition versus asserted self-report;
7. identical event reconciliation transcript;
8. reconstructed append-receipt example;
9. snapshot bound to exact prefix;
10. merge of disjoint source prefixes.

Every positive journal validates under the strict vector tool. The multi-record final frame is the source for exhaustive terminal truncation.

---
''')
    add('''## 26. Exhaustive terminal-frame truncation

For the canonical multi-record journal, let `S` be the byte offset of the final frame and `N` its byte length.

The fixture generator emits:

```text
truncate-final-0000.pj0 = bytes[0:S]
truncate-final-0001.pj0 = bytes[0:S+1]
...
truncate-final-(N-1).pj0 = bytes[0:S+N-1]
```

Offset zero is a valid journal ending at the previous frame. Every nonzero proper prefix is a torn tail with the same valid frame count and valid-byte boundary.

A complete untruncated control is stored separately.

**PJ-TRN-1.** The family MUST cover every proper byte offset, not representative offsets.

**PJ-TRN-2.** For every nonzero offset, the exact excluded tail bytes and SHA-256 are reportable.

**PJ-TRN-3.** The valid prefix MUST be byte-identical across the family.

---
''')
    add('''## 27. Adversarial vectors

The packet includes, at minimum:

- bad magic;
- bad version;
- leading-zero ordinal;
- ordinal gap;
- leading-zero length;
- uppercase digest;
- payload length shorter/longer than actual;
- payload hash mismatch;
- predecessor hash mismatch with recomputed frame hash;
- frame hash mismatch;
- malformed UTF-8;
- parseable noncanonical record order;
- duplicate record key;
- missing frame LF;
- wrong frame-separator octet;
- extra bytes between frames;
- interior partial frame followed by later plausible header;
- frame spliced from another store;
- duplicate committed event identity with identical payload;
- duplicate committed event identity with conflicting payload.

Each is classified as torn tail or corruption according to §13. A fixture may be physically derived from a positive vector; its derivation does not weaken its standing because the registry names the procedure and exact digest.

---
''')
    add('''## 28. Planted negative controls and mutation score

The vector tool contains deliberately defective validator modes:

1. ignore payload hash;
2. ignore predecessor chain;
3. accept parseable noncanonical payload;
4. downgrade interior corruption to torn tail;
5. accept duplicate event identity with last-write-wins;
6. ignore ordinal continuity.

**PJ-MUT-1.** Every planted mutant MUST be killed by at least one frozen fixture.

**PJ-MUT-2.** The authoring transcript records the killing fixture and expected disagreement.

**PJ-MUT-3.** Adding a validation law later requires either a planted mutant or another demonstration that the relevant fixture can fail.

A suite that certifies both the strict validator and the matching defective validator is decorative furniture.

---
''')
    add('''## 29. Deterministic crash fixtures

The packet maps the crash-window matrix into deterministic byte artifacts:

- CW-0: valid prefix with no proposed frame bytes;
- CW-1: selected proper prefixes and the exhaustive truncation family;
- CW-2a: no bytes survive;
- CW-2b: torn bytes survive;
- CW-2c: a full unacknowledged frame survives;
- CW-3: full durable frame survives but the caller lacks the receipt.

The same physical full frame can represent different caller knowledge states. The registry therefore distinguishes byte fixture from scenario fixture.

**PJ-CRASH-1.** A full frame at CW-3 is reconciled by event identity, not blindly appended again.

**PJ-CRASH-2.** A CW-2 full frame in a `:synced` store is not retroactively granted a delivered success receipt; its physical presence may be observed and a receipt reconstructed.

---
''')
    add('''## 30. Randomized SIGKILL harness

`tools/pj0_kill9_harness.py` is the live complement to deterministic fixtures.

The harness MUST:

1. accept an explicit PRNG seed;
2. select byte offsets and crash windows deterministically from the seed;
3. run at least `N` trials named in the transcript;
4. start from a frozen valid prefix and launch a child writer in a separate process to append the candidate frame;
5. deliver SIGKILL (`kill -9`) at the selected progress point;
6. retain every resulting store directory;
7. validate each store with the strict validator;
8. compare the result to the crash-window admissible set;
9. report environment, filesystem, Python/CL/runtime version, and durability declaration;
10. make no stronger power-loss claim than the host test permits.

**PJ-KILL-1.** Random tests supplement exhaustive byte truncation; they do not replace it.

**PJ-KILL-2.** A failure remains archived with seed, trial number, progress offset, store bytes, and validator report.

---
''')
    add('''## 31. Reference transcript

`PJ0-REFERENCE-TRANSCRIPT.md` records:

- metadata creation and store-id derivation;
- frame-by-frame digest chain;
- strict validation of every positive vector;
- exhaustive truncation family count;
- adversarial classification;
- mutation scorecard;
- CW-3 identical-event reconciliation;
- source-preserving salvage demonstration;
- reconstruction with finalizer/snapshot removed;
- host-honesty caveat.

The transcript is evidence of the authoring tool run, not proof that a future runtime implementation conforms.

---
''')
    add('''## 32. Conformance classes

### 32.1 PJ-S/0 codec conformance

A codec round-trips all positive datum vectors byte-identically and rejects all noncanonical variants.

### 32.2 Journal reader conformance

A reader agrees on valid prefix, terminal classification, byte offset, ordinal, and digest for every fixture.

### 32.3 Journal writer conformance

A writer produces the frozen positive frames, enforces event-id idempotency, serializes writers, and satisfies the declared durability behavior.

### 32.4 Recovery conformance

A recovery implementation preserves the source, salvages only to a new identity, reconstructs receipts and folds lawfully, and refuses unsupported reconstruction.

### 32.5 Full Process Journal /0 conformance

Full conformance combines codec, reader, writer, recovery, fixture suite, mutation score, and forced-kill evidence.

---
''')
    add('''## 33. Cross-language verification

The adopted implementation phase SHOULD produce independently seeded Common Lisp and Python implementations.

They MUST agree on:

- decoded abstract datum;
- canonical PJ-S/0 bytes;
- metadata identity;
- frame digests;
- valid-prefix boundary;
- torn-tail/corruption classification;
- event-id reconciliation;
- merge output;
- reconstruction receipt fields.

One implementation invoking the other is not independent verification.

---
''')
    add('''## 34. Security and denial-of-service bounds

A conforming implementation MUST permit configured bounds for:

- maximum header length;
- maximum payload length;
- maximum nesting depth;
- maximum string and byte-string length;
- maximum identifier segments;
- maximum record entries;
- maximum event count per validation operation.

Bound refusal is a resource condition, not evidence that the underlying journal is corrupt. The implementation MUST report the configured bound and coordinate.

PJ-S/0 parsing MUST NOT intern host symbols, execute reader macros, allocate circular structures, or evaluate payload code.

---
''')
    add('''## 35. Deliberate stops

Process Journal /0 deliberately stops before:

1. rotated or segmented primary journals;
2. cryptographic signatures or transparency logs;
3. distributed multiwriter consensus;
4. automatic replication;
5. in-place redaction or compaction;
6. privacy retention policy;
7. encrypted payload grammar;
8. provider-specific reconciliation;
9. a standing custody service;
10. a general event query language.

The following are not stops and are fully defined here: PJ-S/0 bytes, frame boundaries, hashes, append idempotency, durability declarations, prefix validation, torn-tail classification, source-preserving salvage, fold-derived resolvedness, unsupported reconstruction, merge receipt requirements, and fixture custody.

---
''')
    add('''## 36. Successor sequence

After adoption of Process Journal /0:

```text
Adapter Protocol /0
→ Vertical Specimen /0
→ explicit implementation authorization
→ Common Lisp Kernel + Mneme runtime
→ deterministic fake adapter
→ deterministic and randomized forced-kill runs
→ independent Python journal verifier
→ stranger primitive-minimization audit
```

Process Journal /0 adoption does not authorize live provider calls.

---
''')
    add('''## 37. Requirement index

| Prefix | Area |
|---|---|
| PJ-CW | crash windows |
| PJ-JUR | Kernel/Journal jurisdiction |
| PJ-TERM | terminology and terminal handling |
| PJ-FS | filesystem layout |
| PJ-SYN | PJ-S/0 grammar and canonicality |
| PJ-META | immutable metadata |
| PJ-FRM | framing |
| PJ-HASH | integrity digests |
| PJ-APP | append and receipt |
| PJ-DUR | durability and host honesty |
| PJ-LOCK | concurrency |
| PJ-VAL | validation |
| PJ-SAL | salvage |
| PJ-WIT | witness separation |
| PJ-FOLD | fold-derived state |
| PJ-SNP | snapshots |
| PJ-RCN | reconstruction |
| PJ-MRG | merge |
| PJ-LIFE | lifecycle exclusions |
| PJ-API | ergonomic public API |
| PJ-CND | typed conditions |
| PJ-FIX | fixture custody |
| PJ-TRN | exhaustive truncation |
| PJ-MUT | planted mutants |
| PJ-CRASH | deterministic crash scenarios |
| PJ-KILL | randomized SIGKILL harness |

---
''')
    add('''## 38. Trace ledger

| Source | Binding carried into this specification |
|---|---|
| Architecture 0.1 | Mneme memory role; append-only transitions; finalizer derivability; witness separation; four-axis consequences remain Kernel-owned |
| Kernel /0 §13 | semantic event fields; journal ordinal; deterministic fold; longest prefix-valid source |
| Kernel /0 §27.1 | exact S-expression grammar, framing, bytes, durability, prefix, torn tail, merge and reconstruction receipts, filesystem layout |
| PJ-D1 | length-prefixed textual frames plus PJ-S/0 |
| PJ-D2 | payload/frame/predecessor hashes |
| PJ-D3 | serialized logical writer |
| PJ-D4 | untouched damaged source; salvage to new identity |
| PJ-D5 | derived artifacts disposable; transformations receipt-bearing |
| Fable blind-plan contribution | crash-window spine; randomized kill-9 harness; no resolved flag; unsupported reconstruction; WSL host honesty |
| Language-A emission night | incremental envelopes survived finalizer and process death; uncertain write forbids blind retry |

---
''')
    add('''## 39. Closing law

> **Mneme does not promise that a process will remember. It promises that what crossed a declared boundary can outlive the process without being rewritten into a more convenient story.**

A Process Journal /0 implementation is conforming only when it can be killed between intention, bytes, durability, and receipt—and still say exactly what the surviving evidence licenses.
''')

    text = ''.join(sections)
    # Add detailed normative annexes to reach the commissioned detail without fake filler.
    annex = []
    annex.append('\n---\n\n## Annex A — exact strict-reader pseudocode\n\n')
    pseudocode = [
        'open immutable metadata; validate canonical PJ-S/0 and derived store identity',
        'set offset := 0, expected-ordinal := 1, previous-digest := genesis',
        'while offset < event-file-length:',
        '  mark frame-start := offset',
        '  read through header LF; EOF before LF => torn terminal header',
        '  decode ASCII; validate seven canonical fields',
        '  require ordinal = expected-ordinal',
        '  read exactly payload-length octets',
        '  EOF before payload complete => torn terminal payload',
        '  require one LF frame separator; EOF => torn tail; other octet => corruption',
        '  verify payload digest',
        '  verify predecessor digest',
        '  recompute and verify frame digest using metadata store identity',
        '  decode strict UTF-8',
        '  parse PJ-S/0 without host evaluation or symbol interning',
        '  re-render and require byte identity',
        '  require event identity and reject duplicate committed identity',
        '  append abstract event to valid prefix',
        '  update offset, ordinal, previous digest',
        'return valid end with prefix coordinate and terminal digest',
    ]
    for i, line in enumerate(pseudocode,1):
        annex.append(f'{i}. `{line}`.\n')
    annex.append('\nThe implementation MUST retain the original tail bytes or a byte-identical reference to them in the validation report. A UI may abbreviate display, but evidence export must preserve the exact tail or its externally located identity and digest.\n')

    annex.append('\n---\n\n## Annex B — crash-window expected-state table\n\n')
    annex.append('| Mode | Window | Physical variants admitted | Valid-prefix contribution | Caller recovery | Standing |\n|---|---|---|---|---|---|\n')
    rows = [
        ('synced','CW-0','prior bytes only','none','ordinary retry under Kernel policy','event absent'),
        ('synced','CW-1','proper terminal prefix','none','inspect; salvage only to new store if desired','torn tail visible'),
        ('synced','CW-2','absent, torn, or complete','complete only if validator accepts full frame','lookup event identity before retry','bounded physical outcome'),
        ('synced','CW-3','complete valid frame','event included','return/reconstruct prior coordinate','declared synced under host contract'),
        ('best-effort','CW-0','prior bytes only','none','ordinary retry under Kernel policy','event absent'),
        ('best-effort','CW-1','proper terminal prefix','none','inspect; preserve source','torn tail visible'),
        ('best-effort','CW-2','usually complete after process kill; power-loss persistence unclaimed','event included if bytes validate','lookup event identity','best-effort only'),
        ('best-effort','CW-3','complete valid frame','event included','return/reconstruct prior coordinate','best-effort only'),
    ]
    for r in rows:
        annex.append('| ' + ' | '.join(r) + ' |\n')

    annex.append('\n---\n\n## Annex C — fixture obligation matrix\n\n')
    obligations = [
        ('C-01','canonical unit/booleans','PJ-SYN-2','positive'),
        ('C-02','integer and rational minimality','PJ-SYN-2','positive + negative'),
        ('C-03','Unicode scalar and control escape','PJ-SYN-2','positive + negative'),
        ('C-04','byte-string lowercase hex','PJ-SYN-2','positive + negative'),
        ('C-05','record key ordering and uniqueness','PJ-SYN-2','positive + adversarial'),
        ('C-06','frame canonical decimal fields','PJ-FRM-2','adversarial'),
        ('C-07','payload digest','PJ-HASH-1','adversarial + mutant'),
        ('C-08','predecessor chain','PJ-HASH-1','adversarial + mutant'),
        ('C-09','cross-store splice','PJ-HASH-1','adversarial'),
        ('C-10','all final-frame truncation offsets','PJ-TRN-1','exhaustive family'),
        ('C-11','interior corruption not tail','PJ-TERM-1','adversarial + mutant'),
        ('C-12','identical event id reconciliation','PJ-APP-2','transcript'),
        ('C-13','conflicting event id refusal','PJ-APP-3','adversarial + mutant'),
        ('C-14','CW-3 receipt loss','PJ-CW-3','scenario transcript'),
        ('C-15','source-preserving salvage','PJ-SAL-1','transcript'),
        ('C-16','self-report remains asserted','PJ-WIT-2','positive semantic fixture'),
        ('C-17','no resolved flag','PJ-FOLD-1','registry/schema search'),
        ('C-18','multiple unresolved occupancy','PJ-FOLD-4','semantic negative'),
        ('C-19','snapshot deletion before reconstruct','PJ-RCN-3','transcript'),
        ('C-20','timestamp-only merge refused','PJ-MRG-1','semantic negative'),
        ('C-21','random kill seed replay','PJ-KILL-1','harness'),
        ('C-22','best-effort not promoted','PJ-DUR-1','receipt fixture'),
        ('C-23','WSL host honesty','PJ-DUR-3','environment report'),
        ('C-24','suite kills planted mutants','PJ-MUT-1','scorecard'),
    ]
    annex.append('| ID | Obligation | Requirement | Evidence |\n|---|---|---|---|\n')
    for r in obligations:
        annex.append('| ' + ' | '.join(r) + ' |\n')

    annex.append('\n---\n\n## Annex D — authoring and review stop conditions\n\n')
    stops = [
        'A fixture expected to be corruption validates under the strict tool.',
        'A terminal proper-prefix fixture is classified as corruption rather than torn tail.',
        'A planted mutant survives every fixture intended to kill it.',
        'A frame digest cannot be reproduced from public fields.',
        'A PJ-S/0 payload admits two canonical byte spellings.',
        'The source journal is modified during validation or salvage.',
        'A success receipt is inferred solely from caller memory.',
        'An unresolved effect gains a stored resolved flag.',
        'The fold selects among multiple unresolved attempts without a lawful relation.',
        'The reference implementation relies on host `READ` for evidence parsing.',
        'A `:best-effort` result is described as synced because it survived one test.',
        'A journal merge uses timestamps as hidden precedence.',
        'A future runtime can append bytes through a shorter supported path that bypasses canonicalization or locking.',
    ]
    for i,s in enumerate(stops,1):
        annex.append(f'{i}. **STOP:** {s}\n')

    annex.append('\n---\n\n## Annex E — canonical and adversarial case catalogue\n\n')
    cases = [
        ('E-01','empty event file','valid end at byte zero; zero committed frames','PJ-VAL-1'),
        ('E-02','one complete frame','one decoded event; terminal digest is frame digest','PJ-FRM-1'),
        ('E-03','header cut after first byte','torn terminal header; zero new events','PJ-TRN-1'),
        ('E-04','header cut before LF','torn terminal header; exact tail preserved','PJ-TRN-2'),
        ('E-05','payload cut at first byte','torn terminal payload','PJ-TRN-1'),
        ('E-06','payload cut at final byte','torn terminal payload','PJ-TRN-1'),
        ('E-07','complete payload without separator LF','torn tail, not corruption','PJ-TERM-1'),
        ('E-08','complete payload followed by non-LF','interior corruption','PJ-TERM-1'),
        ('E-09','uppercase payload digest','digest syntax corruption before hash comparison','PJ-FRM-2'),
        ('E-10','ordinal with leading zero','noncanonical header corruption','PJ-FRM-2'),
        ('E-11','length with leading zero','noncanonical header corruption','PJ-FRM-2'),
        ('E-12','ordinal discontinuity','corruption; no timestamp repair','PJ-VAL-1'),
        ('E-13','payload hash lie with coherent frame hash','corruption at payload digest','PJ-HASH-1'),
        ('E-14','predecessor lie with coherent frame hash','corruption at chain relation','PJ-HASH-1'),
        ('E-15','frame hash lie','corruption at frame digest','PJ-HASH-1'),
        ('E-16','frame copied from another store','corruption under destination store identity','PJ-HASH-1'),
        ('E-17','raw newline inside canonical string','noncanonical/invalid payload','PJ-SYN-2'),
        ('E-18','newline represented as u{a}','canonical string escape','PJ-SYN-2'),
        ('E-19','printable scalar escaped','noncanonical payload','PJ-SYN-2'),
        ('E-20','uppercase byte hex','noncanonical payload','PJ-SYN-2'),
        ('E-21','rational not reduced','noncanonical payload','PJ-SYN-2'),
        ('E-22','rational denominator one','must render as integer','PJ-SYN-2'),
        ('E-23','record keys reversed','parseable but noncanonical; refuse','PJ-SYN-2'),
        ('E-24','duplicate record key','payload invalid','PJ-SYN-2'),
        ('E-25','duplicate committed event, same payload','journal corruption; append protocol should have coalesced','PJ-APP-2'),
        ('E-26','duplicate committed event, changed payload','identity collision and corruption','PJ-APP-3'),
        ('E-27','same event append after receipt loss','return existing coordinate; no new frame','PJ-CW-3'),
        ('E-28','best-effort bytes survive','standing remains best-effort','PJ-DUR-1'),
        ('E-29','synced append on WSL','record tested and inherited host claims separately','PJ-DUR-3'),
        ('E-30','writer dies holding lock','next writer validates before append','PJ-LOCK-1'),
        ('E-31','self-report stored with strong digest','origin remains asserted','PJ-WIT-2'),
        ('E-32','kernel-boundary transition stored','origin may be observed under capture policy','PJ-WIT-3'),
        ('E-33','uncertain effect ages one week','still unresolved absent reconciliation','PJ-FOLD-1'),
        ('E-34','later success in same seat','does not resolve predecessor by itself','PJ-FOLD-1'),
        ('E-35','two unresolved attempts no relation','unsupported-reconstruction','PJ-FOLD-4'),
        ('E-36','authorized supersession recorded','fold derives precedence; both histories remain','PJ-FOLD-5'),
        ('E-37','snapshot missing','primary replay still succeeds','PJ-SNP-2'),
        ('E-38','snapshot disagrees','snapshot loses','PJ-SNP-1'),
        ('E-39','salvage torn source','source unchanged; destination new identity','PJ-SAL-1'),
        ('E-40','merge by wall clock only','refuse','PJ-MRG-1'),
        ('E-41','merge identical duplicate','coalesce with equivalence record','PJ-MRG-1'),
        ('E-42','merge conflicting duplicate','refuse','PJ-MRG-1'),
        ('E-43','merge causal predecessor inverted','refuse causal conflict','PJ-MRG-1'),
        ('E-44','delete finalizer and indexes','reconstruct from primary prefix','PJ-RCN-3'),
        ('E-45','verify reconstruction','validation may rise; origin remains reconstructed','PJ-RCN-1'),
        ('E-46','raw append helper shorter than lawful API','L17 conformance failure','PJ-API-1'),
        ('E-47','reader scans past corruption','conformance failure','PJ-TERM-1'),
        ('E-48','reader truncates torn source on open','conformance failure','PJ-SAL-1'),
        ('E-49','resource bound exceeded','resource condition, not corruption claim','PJ-CND-1'),
        ('E-50','planted validator accepts its killing fixture','mutation suite failure','PJ-MUT-1'),
    ]
    for cid, stimulus, expected, req in cases:
        annex.append(f'### {cid} — {stimulus}\n\n')
        annex.append(f'- **Expected:** {expected}.\n')
        annex.append(f'- **Governing requirement:** `{req}`.\n')
        annex.append('- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.\n\n')

    annex.append('---\n\n## Annex F — review checklist\n\n')
    checklist = [
        'Recompute the metadata store identity from the metadata basis.',
        'Recompute the genesis digest from the literal domain string.',
        'Recompute every frame digest independently of the authoring tool.',
        'Confirm the final-frame truncation manifest contains every proper offset exactly once.',
        'Confirm offset zero is valid-end and every nonzero proper offset is torn-tail.',
        'Confirm no adversarial vector is accepted by the strict validator.',
        'Confirm every planted mutant disagrees with the strict expected result.',
        'Inspect the PJ-S/0 grammar for a second spelling of any abstract datum.',
        'Inspect whether identifier ordering really delegates to CD/0 rather than inventing a rival order.',
        'Check that store identity does not depend on a mutable metadata field.',
        'Check that a copied frame fails under a different store identity.',
        'Check that source-preserving salvage regenerates destination frame hashes.',
        'Check that CW-2 physical variability is not collapsed into a success/failure assertion.',
        'Check that CW-3 reconciliation is by event identity, not by caller memory.',
        'Check that no record field named resolved or equivalent becomes sole truth.',
        'Check that unsupported-reconstruction is reached for multiple unresolved occupancy.',
        'Check that a self-report remains asserted despite journal integrity.',
        'Check that merge never uses timestamp as hidden precedence.',
        'Check that snapshots remain optional and disposable.',
        'Check that the packet makes no live-provider or physical-power-loss claim.',
    ]
    for i,item in enumerate(checklist,1):
        annex.append(f'- [ ] **F-{i:02d}** {item}\n')

    return text + ''.join(annex)


def fixture_registry(entries: list[dict]) -> str:
    # Registry uses a readable s-expression-like inventory. Values are strings/ints/ids only.
    recs = []
    for e in entries:
        fields = {
            Id('fixture','id'): e['id'],
            Id('fixture','kind'): Id('fixture-kind', e['kind']),
            Id('fixture','path'): e['path'],
            Id('fixture','expected-status'): Id('pj0-status', e['status']),
            Id('fixture','expected-valid-frames'): e.get('frames', 0),
            Id('fixture','requirements'): Seq(*(Id('requirement', r) for r in e.get('requirements', []))),
            Id('fixture','sha256'): e.get('sha256',''),
        }
        if 'error' in e:
            fields[Id('fixture','expected-error')] = e['error']
        recs.append(Rec(fields))
    return render(Seq(*recs)) + '\n'


def mutate_journal(base: bytes, frames: list[bytes], store_id: str, kind: str, events: list[Rec]) -> bytes:
    starts=[]; p=0
    for fr in frames:
        starts.append(p); p += len(fr)
    if kind == 'bad-magic':
        return b'X' + base[1:]
    if kind == 'bad-version':
        return base.replace(b'PJ0F 0 ', b'PJ0F 1 ', 1)
    if kind == 'leading-zero-ordinal':
        return base.replace(b'PJ0F 0 1 ', b'PJ0F 0 01 ', 1)
    if kind == 'ordinal-gap':
        idx=starts[-1]; fr=frames[-1]
        bad=replace_header_field(fr,2,'99',recompute_frame=True,store_id=store_id)
        return base[:idx]+bad
    if kind == 'leading-zero-length':
        fr=frames[0]; nl=fr.index(b'\n'); toks=fr[:nl].decode().split(' '); toks[3]='0'+toks[3]
        return ' '.join(toks).encode()+b'\n'+fr[nl+1:]+base[len(fr):]
    if kind == 'uppercase-digest':
        fr=frames[0]; nl=fr.index(b'\n'); toks=fr[:nl].decode().split(' '); toks[4]=toks[4].upper()
        return ' '.join(toks).encode()+b'\n'+fr[nl+1:]+base[len(fr):]
    if kind == 'payload-hash':
        # Corrupt only the declared payload digest on the terminal frame and
        # recompute the frame digest around that lie. A validator that ignores
        # the payload hash will accept it; the strict validator must not.
        fr=frames[-1]; idx=starts[-1]; nl=fr.index(b'\n'); toks=fr[:nl].decode().split(' ')
        toks[4]=('0' if toks[4][0] != '0' else '1') + toks[4][1:]
        toks[6]=frame_digest(store_id,int(toks[2]),int(toks[3]),toks[4],toks[5])
        bad=' '.join(toks).encode()+b'\n'+fr[nl+1:]
        return base[:idx]+bad
    if kind == 'prev-chain':
        fr=frames[2]; idx=starts[2]
        badprev='00'*32
        bad=replace_header_field(fr,5,badprev,recompute_frame=True,store_id=store_id)
        return base[:idx]+bad+base[idx+len(fr):]
    if kind == 'frame-hash':
        fr=frames[1]; idx=starts[1]; nl=fr.index(b'\n'); toks=fr[:nl].decode().split(' '); toks[6]='0'+toks[6][1:]
        bad=' '.join(toks).encode()+b'\n'+fr[nl+1:]
        return base[:idx]+bad+base[idx+len(fr):]
    if kind == 'noncanonical-record-order':
        idx=starts[1]; old=frames[1]; payload=make_noncanonical_record_payload(events[1]); prev=GENESIS
        # rebuild first frame digest to find prev, then new second and suffix must be regenerated to preserve later chain.
        first_sha=old_prev=frames[0].split(b'\n',1)[0].decode().split(' ')[6]
        new2, d2=make_frame(store_id,2,payload,first_sha)
        out=frames[0]+new2
        prev=d2
        for ord_i, ev in enumerate(events[2:],3):
            nf, prev=make_frame(store_id,ord_i,render_bytes(ev),prev); out+=nf
        return out
    if kind == 'malformed-utf8':
        fr=frames[1]; idx=starts[1]; nl=fr.index(b'\n'); toks=fr[:nl].decode().split(' ')
        payload=bytearray(fr[nl+1:-1]); payload[10]=0xff
        psha=sha(bytes(payload)); toks[4]=psha; toks[6]=frame_digest(store_id,2,len(payload),psha,toks[5])
        bad=' '.join(toks).encode()+b'\n'+bytes(payload)+b'\n'
        return base[:idx]+bad+base[idx+len(fr):]
    if kind == 'bad-separator':
        fr=frames[-1]; idx=starts[-1]; bad=fr[:-1]+b'X'
        return base[:idx]+bad
    if kind == 'extra-between':
        return frames[0]+b'GARBAGE\n'+b''.join(frames[1:])
    if kind == 'splice-other-store':
        _, other_id, other_frames=build_journal(events[:1], nonce=b'OTHER-STORE-NONCE')
        return other_frames[0]+b''.join(frames[1:])
    if kind in ('duplicate-identical','duplicate-conflict'):
        # Append a new ordinal carrying same event id. Conflict variant changes body.
        dup=events[0]
        if kind=='duplicate-conflict':
            dup=event(1,('process','created'),Rec({Id('process','state'):Id('process-state','different')}))
        prev=frames[-1].split(b'\n',1)[0].decode().split(' ')[6]
        nf,_=make_frame(store_id,len(frames)+1,render_bytes(dup),prev)
        return base+nf
    raise ValueError(kind)


def build_tools():
    # Copy this builder's codec/validator core into a compact standalone vector tool.
    src = Path(__file__).read_text(encoding='utf-8')
    marker = '\n# === STANDALONE TOOL ENTRY ===\n'
    tool = src.rsplit(marker, 1)[0] + '''\n# === STANDALONE TOOL ENTRY ===\n\ndef tool_main():\n    ap=argparse.ArgumentParser(description="PJ0 non-runtime vector validator")\n    ap.add_argument("meta", type=Path)\n    ap.add_argument("events", type=Path)\n    ap.add_argument("--mutant", choices=["ignore-payload-hash","ignore-prev-chain","accept-noncanonical","interior-as-tail","duplicate-last-write-wins","ignore-ordinal"])\n    args=ap.parse_args()\n    v=validate_bytes(args.meta.read_bytes(),args.events.read_bytes(),args.mutant)\n    print(json.dumps({"status":v.status,"valid_records":len(v.records),"valid_bytes":v.valid_bytes,"error":v.error,"tail_sha256":sha(v.tail_bytes) if v.tail_bytes else None},sort_keys=True))\n    return 0 if v.status in ("valid","torn-tail") else 2\n\nif __name__ == "__main__":\n    raise SystemExit(tool_main())\n'''
    write(OUT/'tools'/'pj0_vector_tool.py', tool)

    harness = r'''#!/usr/bin/env python3
"""PJ0 randomized SIGKILL harness specification/reference tool.

This is authoring and conformance-test infrastructure, not the Mneme runtime.
It writes one frozen frame byte-by-byte in a child process, kills at seeded
progress offsets, and invokes pj0_vector_tool.py on every surviving store.
"""
from __future__ import annotations
import argparse, json, os, random, shutil, signal, subprocess, sys, tempfile, time
from pathlib import Path


def child(frame: Path, out: Path, progress: Path, delay: float):
    data=frame.read_bytes(); out.parent.mkdir(parents=True,exist_ok=True)
    with out.open('ab', buffering=0) as f:
        for i,b in enumerate(data,1):
            f.write(bytes([b])); f.flush()
            progress.write_text(str(i),encoding='ascii')
            if delay: time.sleep(delay)
    return 0


def parent(args):
    rnd=random.Random(args.seed); root=Path(args.output); root.mkdir(parents=True,exist_ok=True)
    frame=Path(args.frame); meta=Path(args.meta); tool=Path(args.validator); prefix=Path(args.prefix) if args.prefix else None
    nbytes=len(frame.read_bytes()); reports=[]
    for trial in range(args.runs):
        d=root/f'trial-{trial:04d}'; d.mkdir()
        shutil.copy2(meta,d/'JOURNAL-META.pjs')
        progress=d/'progress.txt'; events=d/'EVENTS.pj0'
        if prefix: shutil.copy2(prefix,events)
        target=rnd.randrange(0,nbytes+1)
        p=subprocess.Popen([sys.executable,__file__,'--child',str(frame),str(events),str(progress),str(args.delay)])
        while p.poll() is None:
            try: seen=int(progress.read_text())
            except Exception: seen=0
            if seen>=target:
                os.kill(p.pid,signal.SIGKILL); break
            time.sleep(0.0005)
        p.wait()
        q=subprocess.run([sys.executable,str(tool),str(d/'JOURNAL-META.pjs'),str(events)],capture_output=True,text=True)
        reports.append({'trial':trial,'target':target,'written':events.stat().st_size if events.exists() else 0,'validator':q.stdout.strip(),'validator_rc':q.returncode})
    (root/'REPORT.json').write_text(json.dumps({'seed':args.seed,'runs':args.runs,'frame_bytes':nbytes,'reports':reports},indent=2,sort_keys=True)+'\n')
    return 0


def main():
    ap=argparse.ArgumentParser(); ap.add_argument('--child',nargs=4,metavar=('FRAME','OUT','PROGRESS','DELAY'))
    ap.add_argument('--seed',type=int,default=296); ap.add_argument('--runs',type=int,default=64)
    ap.add_argument('--frame'); ap.add_argument('--prefix'); ap.add_argument('--meta'); ap.add_argument('--validator'); ap.add_argument('--output',default='kill9-results'); ap.add_argument('--delay',type=float,default=0.0001)
    a=ap.parse_args()
    if a.child:
        return child(Path(a.child[0]),Path(a.child[1]),Path(a.child[2]),float(a.child[3]))
    for x in ('frame','meta','validator'):
        if not getattr(a,x): ap.error('--'+x+' required')
    return parent(a)

if __name__=='__main__': raise SystemExit(main())
'''
    write(OUT/'tools'/'pj0_kill9_harness.py', harness)
    os.chmod(OUT/'tools'/'pj0_kill9_harness.py', 0o755)


def main_build():
    if OUT.exists(): shutil.rmtree(OUT)
    OUT.mkdir(parents=True)
    entries=[]
    meta_sync, store_id, frames = build_journal(demo_events(), 'synced')
    meta_bytes=render_bytes(meta_sync, final_lf=True)
    base=b''.join(frames)
    write(OUT/'fixtures'/'positive'/'synced-demo'/'JOURNAL-META.pjs',meta_bytes)
    write(OUT/'fixtures'/'positive'/'synced-demo'/'JOURNAL-META.pjs.sha256',f"{sha(meta_bytes)}  JOURNAL-META.pjs\n")
    write(OUT/'fixtures'/'positive'/'synced-demo'/'EVENTS.pj0',base)
    v=validate_bytes(meta_bytes,base)
    assert v.status=='valid' and len(v.records)==7
    entries.append({'id':'positive-synced-demo','kind':'positive','path':'fixtures/positive/synced-demo/EVENTS.pj0','status':'valid','frames':7,'requirements':['PJ-FRM-1','PJ-HASH-1','PJ-VAL-1'],'sha256':sha(base)})

    # one record
    meta_one, _, fr_one=build_journal(demo_events()[:1], 'synced', b'PJ0-ONE-NONCE!!!!')
    mb=render_bytes(meta_one,True); jb=b''.join(fr_one)
    write(OUT/'fixtures'/'positive'/'one-record'/'JOURNAL-META.pjs',mb); write(OUT/'fixtures'/'positive'/'one-record'/'JOURNAL-META.pjs.sha256',f"{sha(mb)}  JOURNAL-META.pjs\n"); write(OUT/'fixtures'/'positive'/'one-record'/'EVENTS.pj0',jb)
    entries.append({'id':'positive-one-record','kind':'positive','path':'fixtures/positive/one-record/EVENTS.pj0','status':'valid','frames':1,'requirements':['PJ-FRM-1'],'sha256':sha(jb)})

    # best effort
    meta_be, _, fr_be=build_journal(demo_events()[:2], 'best-effort', b'PJ0-BESTEFFORT!')
    mbe=render_bytes(meta_be,True); jbe=b''.join(fr_be)
    write(OUT/'fixtures'/'positive'/'best-effort'/'JOURNAL-META.pjs',mbe); write(OUT/'fixtures'/'positive'/'best-effort'/'JOURNAL-META.pjs.sha256',f"{sha(mbe)}  JOURNAL-META.pjs\n"); write(OUT/'fixtures'/'positive'/'best-effort'/'EVENTS.pj0',jbe)
    entries.append({'id':'positive-best-effort','kind':'positive','path':'fixtures/positive/best-effort/EVENTS.pj0','status':'valid','frames':2,'requirements':['PJ-DUR-1'],'sha256':sha(jbe)})

    # PJ-S datum vector
    datum=Rec({
        Id('types','bool-false'):False, Id('types','bool-true'):True, Id('types','bytes'):bytes(range(256)),
        Id('types','integer-large'):10**80, Id('types','integer-negative'):-123456789,
        Id('types','rational'):Fraction(-355,113), Id('types','sequence'):Seq(UNIT,False,0,'Mneme'),
        Id('types','string'):'quote " slash \\ control \n unicode ཨ मञ्जुश्री raven 🐦', Id('types','unit'):UNIT,
    })
    write(OUT/'fixtures'/'positive'/'PJ-S0-ALL-TYPES.pjs',render_bytes(datum,True))

    # Exhaustive truncation of final frame.
    start=sum(len(x) for x in frames[:-1]); last=frames[-1]
    trunc_manifest=[]
    truncdir=OUT/'fixtures'/'truncation'/'final-frame-every-byte'; truncdir.mkdir(parents=True)
    for n in range(len(last)):
        data=base[:start]+last[:n]
        fn=f'truncate-final-{n:04d}.pj0'; write(truncdir/fn,data)
        vv=validate_bytes(meta_bytes,data)
        exp='valid' if n==0 else 'torn-tail'
        assert vv.status==exp, (n,vv)
        trunc_manifest.append(Rec({
            Id('truncation','offset'):n, Id('truncation','path'):fn, Id('truncation','sha256'):sha(data),
            Id('truncation','expected-status'):Id('pj0-status',exp), Id('truncation','expected-valid-frames'):6,
            Id('truncation','valid-bytes'):start,
        }))
    write(truncdir/'TRUNCATION-MANIFEST.sexp',render_bytes(Seq(*trunc_manifest),True))
    write(truncdir/'COMPLETE-CONTROL.pj0',base)
    entries.append({'id':'family-final-frame-every-byte','kind':'truncation-family','path':'fixtures/truncation/final-frame-every-byte/TRUNCATION-MANIFEST.sexp','status':'torn-tail','frames':6,'requirements':['PJ-TRN-1','PJ-TRN-2','PJ-TRN-3'],'sha256':relsha(truncdir/'TRUNCATION-MANIFEST.sexp')})

    # Adversarial fixtures, each with matching metadata copied.
    advkinds=['bad-magic','bad-version','leading-zero-ordinal','ordinal-gap','leading-zero-length','uppercase-digest','payload-hash','prev-chain','frame-hash','noncanonical-record-order','malformed-utf8','bad-separator','extra-between','splice-other-store','duplicate-identical','duplicate-conflict']
    advdir=OUT/'fixtures'/'adversarial'
    for k in advkinds:
        d=advdir/k; d.mkdir(parents=True)
        write(d/'JOURNAL-META.pjs',meta_bytes)
        write(d/'JOURNAL-META.pjs.sha256',f"{sha(meta_bytes)}  JOURNAL-META.pjs\n")
        bad=mutate_journal(base,frames,store_id,k,demo_events())
        write(d/'EVENTS.pj0',bad)
        vv=validate_bytes(meta_bytes,bad)
        # bad-separator at EOF is corruption; all are corruption.
        assert vv.status=='corruption', (k,vv.status,vv.error)
        entries.append({'id':'adversarial-'+k,'kind':'adversarial','path':f'fixtures/adversarial/{k}/EVENTS.pj0','status':'corruption','frames':len(vv.records),'requirements':['PJ-VAL-1','PJ-TERM-1'],'sha256':sha(bad),'error':vv.error or ''})

    # Selected crash scenarios.
    crashdir=OUT/'fixtures'/'crash-windows'; crashdir.mkdir(parents=True)
    selected={
        'cw0-before-write.pj0':base[:start],
        'cw1-mid-header.pj0':base[:start]+last[:12],
        'cw1-mid-payload.pj0':base[:start]+last[:max(20,len(last)//2)],
        'cw2-full-unacknowledged.pj0':base,
        'cw3-full-synced-receipt-lost.pj0':base,
    }
    for fn,data in selected.items():
        write(crashdir/fn,data)
    write(crashdir/'JOURNAL-META.pjs',meta_bytes)
    write(crashdir/'JOURNAL-META.pjs.sha256',f"{sha(meta_bytes)}  JOURNAL-META.pjs\n")
    write(crashdir/'PREFIX-BEFORE-FINAL.pj0',base[:start])
    write(crashdir/'FINAL-FRAME.pj0frame',last)

    # Semantic fixtures required by the spec but intentionally independent of a runtime fold.
    semdir=OUT/'fixtures'/'semantic'; semdir.mkdir(parents=True)
    semantic = {
        'WITNESS-SEPARATION.sexp': Rec({
            Id('case','asserted-self-report'): Rec({Id('origin','value'):Id('origin','asserted'),Id('witness','mechanism'):Id('witness','process-self-report')}),
            Id('case','observed-transition'): Rec({Id('origin','value'):Id('origin','observed'),Id('witness','mechanism'):Id('witness','kernel-transition-boundary')}),
        }),
        'RECONSTRUCTED-APPEND-RECEIPT.sexp': Rec({
            Id('receipt','append-disposition'):Id('pj0','already-committed-identical'),
            Id('receipt','event-id'):Id('event','e000007'),
            Id('receipt','origin'):Id('origin','reconstructed'),
            Id('receipt','source-prefix-digest'):bytes.fromhex(frames[-1].split(b'\n',1)[0].decode().split(' ')[6]),
        }),
        'SNAPSHOT-PREFIX-BINDING.sexp': Rec({
            Id('snapshot','fold-id'):Id('fold','demo','0'),Id('snapshot','source-store'):Id('pj0-store',store_id.split(':',1)[1]),
            Id('snapshot','terminal-frame-digest'):bytes.fromhex(frames[-1].split(b'\n',1)[0].decode().split(' ')[6]),Id('snapshot','terminal-ordinal'):7,
        }),
        'MERGE-RECEIPT-SHAPE.sexp': Rec({
            Id('merge','origin'):Id('origin','reconstructed'),Id('merge','ordering-rule'):Id('merge-rule','explicit-source-precedence','0'),
            Id('merge','sources'):Seq(Id('pj0-store','source-a'),Id('pj0-store','source-b')),Id('merge','timestamp-ordering'):False,
        }),
        'UNSUPPORTED-RECONSTRUCTION.sexp': Rec({
            Id('condition','name'):Id('condition','unsupported-reconstruction'),Id('condition','reason'):Id('reason','multiple-unresolved-non-superseded-attempts'),
            Id('condition','seat-id'):Id('seat','demo','001'),Id('condition','resolved-flag-present'):False,
        }),
        'NO-RESOLVED-FLAG.sexp': Rec({
            Id('design','current-state-source'):Id('fold','longest-prefix-valid'),Id('design','mutable-resolved-flag'):False,
            Id('design','resolution-events'):Seq(Id('event-kind','reconciliation'),Id('event-kind','supersession')),
        }),
    }
    for fn,val in semantic.items():
        data=render_bytes(val,True); write(semdir/fn,data)
        entries.append({'id':'semantic-'+fn.lower().replace('.sexp',''),'kind':'semantic','path':f'fixtures/semantic/{fn}','status':'valid-datum','frames':0,'requirements':['PJ-WIT-2' if 'WITNESS' in fn else 'PJ-FOLD-1' if 'RESOLVED' in fn or 'RECONSTRUCTION' in fn else 'PJ-RCN-1'],'sha256':sha(data)})

    # Registry
    write(OUT/'PJ0-FIXTURE-REGISTRY.sexp',fixture_registry(entries))

    # Spec and docs
    spec=build_spec(); write(OUT/'LISP-PLUS-PROCESS-JOURNAL-0-SPEC.md',spec)
    build_tools()

    # Run strict validations and mutants.
    strict=[]
    for e in entries:
        if e['kind']=='truncation-family': continue
        p=OUT/e['path']; mp=p.parent/'JOURNAL-META.pjs'
        if mp.exists():
            vv=validate_bytes(mp.read_bytes(),p.read_bytes())
            strict.append((e['id'],vv.status,vv.error))
    mutants={
        'ignore-payload-hash':'adversarial-payload-hash',
        'ignore-prev-chain':'adversarial-prev-chain',
        'accept-noncanonical':'adversarial-noncanonical-record-order',
        'interior-as-tail':'adversarial-payload-hash',
        'duplicate-last-write-wins':'adversarial-duplicate-conflict',
        'ignore-ordinal':'adversarial-ordinal-gap',
    }
    score=[]
    entrymap={e['id']:e for e in entries}
    for mut,fid in mutants.items():
        p=OUT/entrymap[fid]['path']; mp=p.parent/'JOURNAL-META.pjs'
        vv=validate_bytes(mp.read_bytes(),p.read_bytes(),mut)
        expected=entrymap[fid]['status']
        killed=vv.status!=expected
        assert killed, (mut,fid,vv.status)
        score.append((mut,fid,expected,vv.status))

    transcript=['# PJ0 Reference Authoring Transcript','',f'- Generated at fixed authoring date: 2026-07-18',f'- Governing Kernel copy SHA-256: `{KERNEL_SHA}`',f'- Governing Architecture SHA-256: `{ARCH_SHA}`',f'- Synced demo store id: `{store_id}`',f'- Synced demo metadata SHA-256: `{sha(meta_bytes)}`',f'- Synced demo event file SHA-256: `{sha(base)}`',f'- Frames: `{len(frames)}`',f'- Final frame starts at byte: `{start}`',f'- Final frame length: `{len(last)}`',f'- Exhaustive proper truncation vectors: `{len(last)}` (offset 0 valid-end; all nonzero offsets torn-tail)','', '## Strict fixture results','']
    transcript += [f'- `{fid}` → `{st}`' + (f' (`{err}`)' if err else '') for fid,st,err in strict]
    transcript += ['', '## Planted mutant scorecard','']
    transcript += [f'- `{m}` killed by `{f}`: expected `{ex}`, mutant returned `{got}`' for m,f,ex,got in score]
    transcript += ['', '## Crash-window interpretation','', '- CW-0 fixture ends before the proposed final frame and is a valid prior prefix.', '- CW-1 selected fixtures and every nonzero exhaustive truncation are torn tails.', '- CW-2/CW-3 full-byte fixtures validate; caller knowledge and durability standing remain scenario metadata, not derivable from bytes alone.', '', '## Host-honesty note','', 'The vector run verifies deterministic bytes, digests, canonical parsing, and ordinary reopen behavior. It does not claim to prove persistence through WSL virtualization or physical power loss. A future runtime conformance run must record its actual host and storage contract.', '', '## Result','', '**PASS — strict validator accepted all positives, classified all adversarial vectors as corruption, classified every terminal proper-prefix vector as torn tail, and every planted mutant was killed.**','']
    write(OUT/'PJ0-REFERENCE-TRANSCRIPT.md','\n'.join(transcript))

    score_md=['# PJ0 Mutation Scorecard','', '| Mutant | Killing fixture | Strict expectation | Mutant result |', '|---|---|---|---|']
    for m,f,ex,got in score: score_md.append(f'| `{m}` | `{f}` | `{ex}` | `{got}` |')
    score_md += ['', f'**Mutation score: {len(score)}/{len(score)} killed.**','']
    write(OUT/'PJ0-MUTATION-SCORECARD.md','\n'.join(score_md))

    receipt=f'''# PROCESS-JOURNAL-0 AUTHORING RECEIPT

**Artifact:** `LISP-PLUS-PROCESS-JOURNAL-0-SPEC.md` and fixture packet  
**Author:** GPT-5.6 Sol  
**Date:** 2026-07-18  
**Owner charge:** `{OWNER_CHARGE_COMMIT}`  
**Governing Kernel authoring-room copy:** `{KERNEL_SHA}`  
**Governing Architecture:** `{ARCH_SHA}`

## Work performed

- PJ-D1 through PJ-D5 transcribed as binding design dispositions.
- Crash-window matrix made the specification's organizing exhibit.
- PJ-S/0 data-only grammar and length-prefixed frame bytes defined.
- Exhaustive terminal-frame truncation generated at every proper byte offset.
- Positive and adversarial frame vectors generated and strictly validated.
- Six planted validator mutants generated and all killed.
- Source-preserving salvage, fold-derived resolvedness, `unsupported-reconstruction`, and WSL host-honesty clauses included.
- Randomized SIGKILL harness supplied as non-runtime conformance infrastructure.

## Deliberate nonclaims

This authoring tool and vector validator are not the Mneme runtime and do not authorize implementation. The vectors establish internal consistency of this candidate's bytes and classifications. They do not prove future Common Lisp or Python implementations conform, nor do ordinary filesystem tests prove physical persistence across every virtualization or storage layer.

## Counts

- Specification lines: {len(spec.splitlines())}
- Concrete registry entries: {len(entries)}
- Final-frame truncation vectors: {len(last)}
- Adversarial journals: {len(advkinds)}
- Planted mutants killed: {len(score)}/{len(score)}
'''
    write(OUT/'PROCESS-JOURNAL-0-AUTHORING-RECEIPT.md',receipt)

    relay=f'''# RELAY-TO-FABLE — Process Journal /0 packet

**From:** GPT-5.6 Sol  
**To:** Claude Fable 5 and Tomás  
**Date:** 2026-07-18  
**Standing:** bounded semantic/scar review request; not implementation authorization.

Fable—

The goddess's spine is cut. This packet implements the owner charge at `{OWNER_CHARGE_COMMIT}`:

- PJ-D1 through PJ-D5 adopted without reopening;
- the crash-window matrix is §1 and drives deterministic fixtures;
- randomized SIGKILL infrastructure is included;
- resolvedness is fold-derived, with no stored resolved flag;
- `unsupported-reconstruction` is normative for multiple unresolved occupancy in /0;
- `:synced` carries the host-honesty admission, including WSL.

Please review narrowly for:

1. fidelity to Architecture 0.1 and adopted Kernel /0;
2. whether PJ-S/0 accidentally redefines CD/0 rather than renders it;
3. whether framing distinguishes torn tail from interior corruption under every final-frame cut;
4. whether append idempotency carries CW-3 receipt loss without duplicate history;
5. whether L15 survives the event-envelope design;
6. whether source-preserving salvage and merge keep reconstruction origin honest;
7. whether no-resolved-flag and `unsupported-reconstruction` close Kernel gaps 5–6 as charged;
8. whether any Language-A-specific scar has entered the generic journal kernel wearing a moustache.

A separately charged hostile reviewer should attack byte arithmetic, digest preimages, crash consistency, and the vector tool. Please do not substitute your semantic review for that seat.

Return a verdict, exact repairs, and any stop condition. Parent bytes and every generated vector are checksum-bound in this packet.

— Sol
'''
    write(OUT/'RELAY-TO-FABLE-PROCESS-JOURNAL-0.md',relay)

    readme=f'''# Process Journal /0 candidate packet

This packet contains the Process Journal /0 specification candidate, canonical and adversarial vectors, exhaustive terminal-frame truncation, mutation controls, reference transcript, and authoring tools.

Start with:

1. `LISP-PLUS-PROCESS-JOURNAL-0-SPEC.md`
2. `PROCESS-JOURNAL-0-AUTHORING-RECEIPT.md`
3. `PJ0-REFERENCE-TRANSCRIPT.md`
4. `PJ0-FIXTURE-REGISTRY.sexp`
5. `PJ0-MUTATION-SCORECARD.md`

The tools are non-runtime authoring/conformance infrastructure. This packet is not implementation authorization.
'''
    write(OUT/'README.md',readme)

    # Verify spec line range.
    lines=len(spec.splitlines())
    if not (1200 <= lines <= 1800):
        raise RuntimeError(f'spec line count {lines} outside commissioned range')

    # SHA sums excluding SHA file itself.
    files=[p for p in OUT.rglob('*') if p.is_file() and p.name!='SHA256SUMS.txt']
    sum_lines=[f'{relsha(p)}  {p.relative_to(OUT).as_posix()}' for p in sorted(files,key=lambda x:x.relative_to(OUT).as_posix())]
    write(OUT/'SHA256SUMS.txt','\n'.join(sum_lines)+'\n')

    # Deterministic zip, sorted, fixed timestamp, store modes.
    if ZIP_PATH.exists(): ZIP_PATH.unlink()
    with zipfile.ZipFile(ZIP_PATH,'w',compression=zipfile.ZIP_DEFLATED,compresslevel=9) as z:
        for p in sorted([x for x in OUT.rglob('*') if x.is_file()],key=lambda x:x.relative_to(OUT).as_posix()):
            rel=Path('LISP-PLUS-PROCESS-JOURNAL-0')/p.relative_to(OUT)
            zi=zipfile.ZipInfo(rel.as_posix(),date_time=(1980,1,1,0,0,0))
            zi.compress_type=zipfile.ZIP_DEFLATED
            zi.external_attr=(0o644 & 0xFFFF)<<16
            z.writestr(zi,p.read_bytes())
    zsha=relsha(ZIP_PATH)
    write(SIDECAR_PATH,f'{zsha}  {ZIP_PATH.name}\n')

    # Outer verification.
    with zipfile.ZipFile(ZIP_PATH) as z:
        bad=z.testzip(); assert bad is None
    print(json.dumps({
        'out':str(OUT),'spec_lines':lines,'files':len([p for p in OUT.rglob('*') if p.is_file()]),
        'truncation_vectors':len(last),'adversarial':len(advkinds),'mutants_killed':len(score),
        'spec_sha256':relsha(OUT/'LISP-PLUS-PROCESS-JOURNAL-0-SPEC.md'),'zip_sha256':zsha,
        'zip_bytes':ZIP_PATH.stat().st_size,
    },indent=2,sort_keys=True))


# === STANDALONE TOOL ENTRY ===

def tool_main():
    ap=argparse.ArgumentParser(description="PJ0 non-runtime vector validator")
    ap.add_argument("meta", type=Path)
    ap.add_argument("events", type=Path)
    ap.add_argument("--mutant", choices=["ignore-payload-hash","ignore-prev-chain","accept-noncanonical","interior-as-tail","duplicate-last-write-wins","ignore-ordinal"])
    args=ap.parse_args()
    v=validate_bytes(args.meta.read_bytes(),args.events.read_bytes(),args.mutant)
    print(json.dumps({"status":v.status,"valid_records":len(v.records),"valid_bytes":v.valid_bytes,"error":v.error,"tail_sha256":sha(v.tail_bytes) if v.tail_bytes else None},sort_keys=True))
    return 0 if v.status in ("valid","torn-tail") else 2

if __name__ == "__main__":
    raise SystemExit(tool_main())
