#!/usr/bin/env python3
"""run_stranger1_round.py — fire ONE round of the stranger-implementation-/1 seat.

Custodian harness. The seat is a clean, memoryless OpenRouter call
(default qwen36-plus => qwen/qwen3.6-plus — Qwen-family, lineage-distant,
and deliberately NOT DeepSeek, which was /0's seat). It receives ONLY the
allowed packet (Guide + API brief + Task) on round 1, and ONLY its current
program + the raw SBCL transcript on revision rounds. No other text ever
enters its context.

The exact OpenRouter model id is written into every round-N-meta.json; that
store, not the seat's self-report, is the ground truth of which model ran.

Usage:
  round 1 (initial):
    python3 run_stranger1_round.py 1
  revision round N (relay the CURRENT PROGRAM + its transcript):
    python3 run_stranger1_round.py N \\
        --program rounds/round-<N-1>-program.lisp \\
        --transcript rounds/round-<N-1>-run.txt

RELAY-FIX (the /0 harness bug, fixed here): a revision round ALWAYS sends
the seat its current program verbatim alongside the transcript. The seat is
stateless — it cannot revise code it cannot see. /0 lost two rounds to a
transcript-only relay; do not send a transcript without the program.

Everything is archived under rounds/. This script does NOT run SBCL and
does NOT judge output — it only relays. The custodian runs the extracted
program separately and feeds back (program + transcript).
"""
import argparse, os, sys, json, datetime

HERE = os.path.dirname(os.path.abspath(__file__))
LAB_ROOT = os.path.abspath(os.path.join(HERE, "..", "..", "..", "..", ".."))
sys.path.insert(0, os.path.join(LAB_ROOT, "tools", "voices"))
import openrouter_client as orc  # noqa: E402

# Qwen-family seat. qwen36-plus is the newest Qwen flagship (qwen/qwen3.6-plus,
# 1M ctx). Fallbacks (all Qwen-family, same protocol): "qwen" (qwen/qwen3-max),
# then "qwen-coder" (qwen/qwen3-coder). NOT DeepSeek — that was /0's seat, and
# /1 must be an independent draw from a different family.
MODEL_SHORTCUT = "qwen36-plus"       # => qwen/qwen3.6-plus
MODEL_ID = orc.MODELS[MODEL_SHORTCUT]

SYSTEM_PROMPT = """You are a competent Common Lisp programmer (SBCL). You are being \
asked to write ONE program against an embedded language called "Lisp+ Slice /0" that you have \
NEVER seen before. You are given exactly three things: a programmer Guide, an API brief, and a \
Task (with its three input files embedded). That is your entire world — there are no other files to \
read, no source to inspect, no one to ask. Everything you are permitted to use is in the message.

Rules you must follow:
- Use ONLY the single-colon exported symbols documented in the API brief (packages \
LISP-PLUS-SLICE0, LISP-PLUS-KERNEL0, and the ordinary SUPPLY-LAB verifier package). Never use \
double-colon (::) internal access. Never mutate a record slot with setf. Never stringify a host \
object and pass the string off as the object.
- If some required step genuinely cannot be done through the public surface documented here, STOP \
and say so plainly, naming the exact operation or relation you could not reach. That is an \
acceptable answer; do not invent a workaround through internals.
- Your program will be run verbatim with: sbcl --non-interactive --load STRANGER-PROGRAM.lisp

Return, in this order:
1. The COMPLETE program as ONE fenced ```lisp code block (this becomes STRANGER-PROGRAM.lisp verbatim).
2. A short report as markdown under a heading "## Implementer report", covering: your model/provider; \
any prior exposure to this language or lab (state 'none' if so); which documents you actually used; \
whether you inspected any implementation internals (you cannot here — say so); whether you wanted \
help outside the given material; which exported symbols you used, which you considered and rejected, \
which were unclear; every place you had to guess an argument convention; and anything you were unsure \
would compile."""

def read(rel):
    with open(os.path.join(HERE, rel), "r") as f:
        return f.read()

def build_round1_message():
    guide = read("../LANGUAGE-SLICE-0-GUIDE.md")
    api = read("../LANGUAGE-SLICE-0-API.md")
    task = read("TASK.md")
    return (
        "You will implement a program against Lisp+ Slice /0. Below are your ONLY references, "
        "in full, followed by the Task.\n\n"
        "==================== REFERENCE 1: PROGRAMMER GUIDE ====================\n\n"
        + guide +
        "\n\n==================== REFERENCE 2: API BRIEF ====================\n\n"
        + api +
        "\n\n==================== THE TASK ====================\n\n"
        + task +
        "\n\n==================== END OF MATERIAL ====================\n\n"
        "Now write the program and the implementer report as instructed in the system message."
    )

def build_revision_message(transcript_path, program_path):
    with open(transcript_path, "r") as f:
        transcript = f.read()
    with open(program_path, "r") as f:
        program = f.read()
    return (
        "Here is YOUR CURRENT PROGRAM (exactly as it was run), followed by the COMPLETE raw output "
        "of running it verbatim with `sbcl --non-interactive --load STRANGER-PROGRAM.lisp` "
        "(stdout+stderr + exit code). This transcript is all the diagnostic information you get — "
        "no hints, no commentary.\n\n"
        "==================== YOUR CURRENT PROGRAM ====================\n\n"
        "```lisp\n" + program + "\n```\n\n"
        "==================== RAW SBCL TRANSCRIPT ====================\n\n"
        "```\n" + transcript + "\n```\n\n"
        "==================== END ====================\n\n"
        "Revise the program above as needed to fix what the transcript shows. Keep everything that "
        "was already working; change only what the error requires. Return the FULL updated program "
        "in one ```lisp block (it replaces STRANGER-PROGRAM.lisp verbatim), then under "
        "'## Revision note' say exactly what you changed and why (referencing the transcript). "
        "If the transcript shows success and nothing needs changing, re-emit the program unchanged and say so."
    )

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("round", type=int)
    ap.add_argument("--transcript", default=None, help="path to prior round's run transcript (revision rounds)")
    ap.add_argument("--program", default=None, help="path to prior round's program file (revision rounds)")
    ap.add_argument("--max-tokens", type=int, default=16000)
    ap.add_argument("--temperature", type=float, default=0.3)
    args = ap.parse_args()

    os.makedirs(os.path.join(HERE, "rounds"), exist_ok=True)

    if args.round == 1:
        message = build_round1_message()
    else:
        if not args.transcript or not args.program:
            sys.exit("revision rounds require --transcript AND --program (relay-fix: the seat must see its current program)")
        message = build_revision_message(args.transcript, args.program)

    stamp = datetime.datetime.utcnow().isoformat() + "Z"
    result = orc.call_model(
        MODEL_ID, message, system_prompt=SYSTEM_PROMPT,
        temperature=args.temperature, no_thinking=False,
        max_tokens=args.max_tokens,
    )

    reply_path = os.path.join(HERE, "rounds", f"round-{args.round}-reply.md")
    meta_path = os.path.join(HERE, "rounds", f"round-{args.round}-meta.json")
    if not result.get("success"):
        print("SEAT CALL FAILED:", result.get("error"))
        with open(meta_path, "w") as f:
            json.dump({"round": args.round, "timestamp": stamp, "model_id": MODEL_ID, "result": result}, f, indent=2)
        sys.exit(1)

    content = result.get("content", "")
    with open(reply_path, "w") as f:
        f.write(content)
    with open(meta_path, "w") as f:
        json.dump({
            "round": args.round, "timestamp": stamp,
            "model_shortcut": MODEL_SHORTCUT, "model_id": MODEL_ID,
            "usage": result.get("usage"), "message_chars": len(message),
            "reply_chars": len(content),
        }, f, indent=2)
    print(f"ROUND {args.round} OK  model={MODEL_ID}")
    print(f"  reply -> {reply_path}  ({len(content)} chars)")
    print(f"  meta  -> {meta_path}")
    print(f"  usage: {result.get('usage')}")

if __name__ == "__main__":
    main()
