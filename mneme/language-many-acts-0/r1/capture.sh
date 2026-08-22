#!/usr/bin/env bash
#
# capture.sh — run one defect witness in a fresh image and write its transcript
# with a header naming the command, the UTC clock, and what the run tests whether
# holds.
#
#   ./capture.sh pre-repair D1
#   ./capture.sh post-repair D3
#
# THE PRE-REPAIR TRANSCRIPTS ARE EVIDENCE.  They are captured once, before any
# repair, and are never regenerated and never deleted.  The post-repair
# transcripts are written beside them, never over them.
#
# D3 is run under an EXTERNAL WATCHDOG (`timeout`).  Before the repair the
# validator does not terminate on circular structure, so exit 124 — the watchdog
# killing the image — IS the red witness.
#
# ⚠ THE PRINTED LABEL WAS CHANGED FROM `PROVES     :' TO `TESTS WHETHER:' BY
# PARCEL B ITEM B3 (OWNER RULING 6, 2026-08-10, §3 B3: "OPTION 1 ADOPTED,
# MODIFIED"), completing Owner Ruling 2 §5 item 9 in the tool as well as in the
# fixture headers.
#
# ⚠ A DIVERGENCE NOW EXISTS BETWEEN THIS TOOL AND THE EVIDENCE IT PRODUCED, AND
# IT IS NOT REPAIRABLE.  The ten preserved captures in `pre-repair/' and
# `post-repair/' carry `PROVES     :' verbatim and are BYTE-UNTOUCHED; they are
# never regenerated and never annotated.  A transcript whose header reads
# `PROVES' was written before this ruling: the difference is the repair, not
# tampering.  Any future re-run of this script writes `TESTS WHETHER:' and will
# therefore differ from those ten in that header field, forever.
#
# ⚠ NO EXACT PRODUCING INSTRUMENT WAS RECOVERED OR PRESERVED.  Ruling 6 §3 B3
# rejected copying this script beside the captures, because Parcel A had already
# changed its prospective commentary: "A replica wearing the old script's coat is
# not the old script."  Nothing in this lane is the byte-state that produced the
# ten captures, and nothing here may be described as though it were.
#
# Rider 6's holding is unchanged and still governs QUOTATION: the header names
# the DEFECT CLASS the capture tests for, identically in red and green captures,
# and the repeated "PROVES … reachable" header must never be quoted as though
# the repaired version still exhibits the defect — the GREEN tally beside it
# governs the post-repair result.
#
# The divergence is recorded in three places, as ordered: this header, the
# Parcel-B execution return (MANY-ACTS-0-PARCEL-B-EXECUTION-RETURN.md §4, B3),
# and the supersession registry (MANY-ACTS-0-SUPERSESSIONS.md, entry S-5).
#
# CANDIDATE.  Running a candidate is not adopting it, and nothing this script
# prints is independent verification.

set -u
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

phase="${1:?usage: capture.sh <pre-repair|post-repair> <D1|D2|D3|D4|D5>}"
defect="${2:?usage: capture.sh <pre-repair|post-repair> <D1|D2|D3|D4|D5>}"

case "$defect" in
  D1) script="D1-ownership.lisp"
      proves="D1-OWNERSHIP — copy-tree copies cons structure and SHARES mutable string leaves, so exported readers hand out the very strings the validated program, the environment and the result retain; and the environment does not own the strings its caller declared." ;;
  D2) script="D2-branch-binding.lisp"
      proves="D2-BRANCH-BINDING — branch alternatives are validated sequentially against ONE mutable binding table, so a later alternative may reference a name bound only inside an earlier one: accepted at validation, dead at runtime when that alternative was not the selected one." ;;
  D3) script="D3-circular-source.lisp"
      proves="D3-CIRCULAR-SOURCE — the validator's total walk carries no visited set and does not terminate on circular cons structure; the declared node bound cannot save it, and only an external watchdog stops the image." ;;
  D4) script="D4-env-crosswire.lisp"
      proves="D4-ENV-CROSSWIRE — constructing a second environment overwrites the One Act /0 run-state specials; running the FIRST environment afterwards appends journal events and world effects into the SECOND environment's store before composition notices anything is wrong." ;;
  D5) script="D5-generation-seam.lisp"
      proves="D5-GENERATION-SEAM (owner's pre-freeze gate) — the window between the generation increment and the return of make-ma0-environment is REACHABLE from the public API, so a FAILED construction of a second environment kills a working first one: the counter advances, the good environment goes stale, and the five run-state specials are left pointing at a store no object owns. Also: the default struct printer exposes the generation (and the live store, bootstrap and minting context) on any environment." ;;
  *)  echo "capture.sh: unknown defect '$defect'" >&2; exit 2 ;;
esac

out_dir="$here/$phase"
mkdir -p "$out_dir"
out="$out_dir/$defect-$( [ "$phase" = pre-repair ] && echo red || echo green ).txt"

# D3 needs the watchdog; the others get a generous ceiling for the same reason
# every run here gets one — an unbounded run is not a witness.
limit=300
[ "$defect" = D3 ] && limit=60

{
  echo "=============================================================================="
  echo "MANY ACTS /0 — R1 REPAIR CAMPAIGN — ${phase^^} WITNESS — $defect"
  echo "=============================================================================="
  echo "command    : timeout $limit sbcl --script $script"
  echo "cwd        : mneme/language-many-acts-0/r1/"
  echo "date -u    : $(date -u)"
  echo "branch     : $(cd "$here" && git rev-parse --abbrev-ref HEAD)"
  echo "head       : $(cd "$here" && git rev-parse HEAD)"
  echo "sbcl       : $(sbcl --version)"
  echo
  echo "TESTS WHETHER: $proves"
  echo
  if [ "$phase" = pre-repair ]; then
    echo "READING    : a DEFECT-PRESENT line is the defect reproducing.  For D3 the red"
    echo "             is the WATCHDOG KILL — exit 124 with the transcript ending at"
    echo "             'entering the validator'."
  else
    echo "READING    : every line must read CLOSED / OWNED and the exit code must be 0."
  fi
  echo "=============================================================================="
  echo
} > "$out"

cd "$here"
timeout "$limit" sbcl --script "$script" >> "$out" 2>&1
code=$?

{
  echo
  echo "=============================================================================="
  echo "exit code  : $code$( [ $code -eq 124 ] && echo '   (124 = KILLED BY THE WATCHDOG — the validator did not terminate)' )"
  echo "=============================================================================="
} >> "$out"

echo "wrote $out (exit $code)"
exit 0
