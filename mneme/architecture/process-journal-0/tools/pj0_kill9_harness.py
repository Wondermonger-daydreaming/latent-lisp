#!/usr/bin/env python3
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
