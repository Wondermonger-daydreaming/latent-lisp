#!/usr/bin/env bash
#
# run-composite-demonstration.sh — the strongest demonstration this tree
# actually supports, in one command.
#
#   bash mneme/run-composite-demonstration.sh
#
# ---------------------------------------------------------------------------
# THIS IS A COMPOSITE RELEASE DEMONSTRATION.
# IT IS NOT A COMPLETE SEMANTIC END-TO-END LANGUAGE PATH.
# ---------------------------------------------------------------------------
#
# It runs three things that are real, in order, and then says plainly what each
# of them was exercised against:
#
#   PART I   — the Vertical Specimen /0 durable process path: canonical datum,
#              process identity, journal-backed durability, capability minting
#              and revocation, the effect frontier, the deterministic fake
#              adapter, process death, reconstruction, and inspection.
#
#   PART II  — Language Surface /2's read-only re-expression of the completed
#              result of that run.
#
#   PART III — the language's own derive/perform doors driving the journal-backed
#              durable substrate, ACROSS PROCESS DEATH.  Two ADOPTED specimens
#              run here, each rendering its own verdicts through its own stage
#              children; this runner only invokes them and relays:
#
#                · One Act /1 — de-actu-resurgente.  Adopted 2026-08-22
#                  (mneme/language-act-1/ADOPTION-RECORD-2026-08-22.md).
#                  perform → planted death inside the acknowledgment window →
#                  a GENUINELY NEW PROCESS over durable bytes that re-derives
#                  the act identity, REFUSES the same act pre-frontier (and
#                  refuses the disguised retry identically), structures the
#                  uncertainty, reconciles :applied with evidence, and only then
#                  settles a fresh act.
#
#                · Memory Layer /0 — de-actu-memorato.  Adopted AND PUBLISHED
#                  2026-08-22 (Sol I's terminal standing ruling; carried row
#                  `ml0` in mneme/verify-release.sh).  The durable, language-level
#                  ACCOUNT of an act no live process witnessed — occurrence and
#                  issuance kept on separate axes — plus retrieval, damage
#                  refusal, and consolidation.
#
# ---------------------------------------------------------------------------
# WHAT THIS HEADER USED TO SAY, AND WHY IT NO LONGER SAYS IT
# ---------------------------------------------------------------------------
#
# Until 2026-09-21 this header declared that "the language's derive/perform doors
# have never opened onto the durable substrate.  That is the first missing
# semantic seam."  That was TRUE when this runner was written (2026-08-02) and is
# OBSOLETE.  One Act /0 (adopted 2026-08-08,
# mneme/language-act-0/ADOPTION-RECORD-2026-08-08.md), One Act /1 (adopted
# 2026-08-22) and Memory Layer /0 (adopted and published 2026-08-22) built it.
#
# PART III EXPOSES AN EXISTING, ALREADY-ADOPTED CAPABILITY.  It introduces no new
# recovery semantics and claims none.  Nothing in PART III is a general
# power-loss or arbitrary-crash claim.
#
# ---------------------------------------------------------------------------
# CEILINGS PART III CARRIES — verbatim from the adoption records
# ---------------------------------------------------------------------------
#
# One Act /1 (ADOPTION-RECORD-2026-08-22.md, "Ceilings that travel (Sol's,
# verbatim)"), quoted:
#
#   · "SBCL 2.4.6/Linux only."
#   · "Frozen implementation and finite observed paths."
#   · "Deterministic planted process death; no general SIGKILL, power-loss, or
#      mid-write guarantee."
#   · "Fake world, scripted adapter subset, one seat/effect family, and
#      non-adversarial local recognition."
#   · "No alternative Act1/Core implementation."
#   · "The heterogeneous observer path shares the subject's semantic
#      implementation."
#   · "The inherited certificate was audit-defined; there is no public evidence
#      serializer/deserializer."
#   · "Package privacy is defense in depth, not a security boundary."
#   · "The 104-name export surface is an implementation choice, not an adopted
#      normative interface."
#   · "Do not say 'independently verified.'"
#
# Memory Layer /0 (carried row `ml0`, mneme/verify-release.sh, "Ceilings carried
# verbatim"), quoted:
#
#   · "durable account survives its writer"
#   · "occurrence requires its full admitted conjunction"
#   · "warrant issuance cannot manufacture the warranted event"
#   · "inadmissible evidence yields :unresolved"
#   · "§5.A append-only failure semantics + mandatory pre-append dry decode"
#   · "/0 same-store only"
#   · "receipt-bearing foreign lineage reserved to Memory Layer /1"
#   · "D6 PARTIAL"
#   · "D4 SHOWN-AS-AMENDED"
#   · "package privacy is defense in depth"
#   · "same-family execution is not independent audit"
#
# ML/0's STANDING is not taken from that row (whose standing sentence, at the base
# this script was written against, is itself superseded).  It is the status
# stone's: mneme/architecture/ARCHITECTURE-0-STATUS.md, ADDENDUM 25 item 6 —
# read it there and quote it whole.  The parts that bear on a demonstration:
# "STRICT STRANGER AUDIT PERFORMED AND RECEIVED · STRANGER-AUDIT OBLIGATION
# DISCHARGED · BOUNDED INDEPENDENT EVIDENCE OBTAINED", and beside them, still
# standing, "P9 FAIL STANDS IN THE REGISTER", "`ml0.lisp:3002` COMPANION COMMENT
# UNCORRECTED" and "NO SUPPORTED-PATH RUNTIME SEMANTIC FAILURE ESTABLISHED" —
# which is a ceiling on what has been found, not a proof that nothing is there.
# The same item: "This does not confer blanket 'independently verified' status."
# A DIFFERENT audit — the stranger primitive-minimization audit, the
# architecture's promotion gate — is still OWED and has never been commissioned.
#
# ---------------------------------------------------------------------------
# WHICH DEATHS ARE LIVE AND WHICH ARE REPLAYED — stated, not blurred
# ---------------------------------------------------------------------------
#
#   LIVE, in this run:      journal0's de-teste-occiso specimen kills real
#                           writer processes with real SIGKILL and restarts
#                           them, with negative controls.
#
#   LIVE, PLANTED, PART III: the two PART III specimens kill real processes in
#                           this run, but at a DECLARED point the code plants —
#                           CAP2_WORLD_DIE_IN_WINDOW=1 makes the child exit 7
#                           inside the acknowledgment window, after the fake
#                           world applied and ledgered the write.  This is a
#                           CONTROLLED TERMINATION BOUNDARY, not an arbitrary
#                           crash: "Deterministic planted process death; no
#                           general SIGKILL, power-loss, or mid-write guarantee"
#                           (One Act /1 adoption record, verbatim).
#
#   PRESERVED, verified:    Vertical /0's four-death campaign is NOT
#                           regenerated here.  Its two campaigns are preserved
#                           artifacts; this run byte-compares them and
#                           re-derives the census from campaign-2's exec tree.
#                           VERIFYING A PRESERVED CAMPAIGN IS NOT REPRODUCING
#                           IT, and this runner does not pretend otherwise.
#
#   CRASH MODEL:            SIGKILL only, one SBCL 2.4.6/Linux host.  No
#                           power-loss model, no torn-media model, no second
#                           host, no other implementation.  Nothing beyond
#                           SIGKILL on this host has ever been tested.
#
# ---------------------------------------------------------------------------
# HYGIENE — THE ACTUAL BOUNDARY, NOT A BLANKET CLAIM
# ---------------------------------------------------------------------------
#
# The tree is copied to a disposable directory under $TMPDIR and every step runs
# there; the copy is removed on success AND on failure.  The Vertical /0 gates
# deposit ~70 scratch directories per run and those land in the copy.  But the
# confinement is NOT total, and this runner states where it leaks instead of
# asserting that every write is absorbed:
#
#   · canonical-datum/evidence/ and canonical-datum/generated/ are NOT copied
#     (559 MB).  They are SYMLINKED from the copy back to YOUR tree, so any step
#     that wrote through those links would write into your checkout.
#   · mneme/vertical0/reconstruction/run-reconstruction-gate.lisp hard-codes a
#     FIXED, SHARED workspace — /tmp/vertical0-reconstruction-gate/ — and begins
#     by `rm -rf`-ing it (the path is a literal in a `defparameter` at
#     run-reconstruction-gate.lisp:90; the deletion is at :232).  It is read from
#     no environment variable and no argument, and because it is a `defparameter`
#     with a literal string, a `--eval` prelude that pre-set the same symbol is
#     OVERWRITTEN when the file loads (measured: `sbcl --eval '(defparameter *w*
#     "/tmp/OVERRIDE/")' --script f.lisp` still prints the literal).  A unique
#     location is therefore not available to any caller that does not edit that
#     adopted, pinned source — which this runner may not do.
#   · $TMPDIR scratch belonging to other tools is never touched.  cleanup()
#     removes only the paths this invocation created, tracked as they are made.
#
# ---------------------------------------------------------------------------
# WHY THIS RUNNER RE-EXECUTES ITSELF IN A PRIVATE MOUNT NAMESPACE
# ---------------------------------------------------------------------------
#
# Until 2026-09-21 the shared gate path was handled by an OWNERSHIP PROTOCOL:
# claim /tmp/vertical0-reconstruction-gate with a single atomic mkdir, refuse to
# start if it already existed, remove it at exit only if the claim succeeded.
# THAT PROTOCOL IS UNSOUND AND IS GONE.  The gate itself `rm -rf`s the path on
# entry, so the claim marker is destroyed by the very step it was meant to guard;
# a second caller's directory can then appear under the same name, and this
# runner's exit cleanup would delete a directory belonging to someone else.  The
# counterexample is reproducible with no lab run at all (see the returned
# evidence for this candidate).
#
# A lock does not fix it either.  The other callers of that path — the release
# floor's `vertical0` row in mneme/verify-release.sh (profile `both`), and any
# hand-run of the gate lisp — take no lock and consult no marker.  A lock only
# ever binds the callers that obey it, and none of them do.
#
# So the boundary is made STRUCTURAL instead of cooperative: this runner
# re-executes itself inside an unprivileged user + mount namespace with a fresh
# private tmpfs mounted over /tmp.  The gate's fixed path then exists only inside
# this invocation, the host's /tmp/vertical0-reconstruction-gate is never
# created, never claimed and never removed by this runner, and no other caller
# can see or be seen by this one.  There is no shared name left to fight over.
#
# THE SIDE EFFECTS OF THAT ROUTE, STATED:
#   · inside the namespace this process runs as uid 0 (mapped from your uid), so
#     permission bits on files owned by you are not enforced against it.  A
#     chmod-000 file under the project root IS readable and IS hashed here,
#     where on the host it would be refused.  The content witness is therefore
#     STRONGER inside (nothing drops out as UNREADABLE) but its unreadable-file
#     refusal cannot be exercised from inside.
#   · everything under /tmp is private to this run and vanishes with it.
#   · if unprivileged user namespaces are unavailable, or if isolation cannot be
#     VERIFIED after the re-execution, this runner REFUSES to start, non-zero,
#     before any scratch directory is created and before any workload runs.
#     There is no weaker shared-path route.  There is no environment variable
#     that turns one on.
#
# ---------------------------------------------------------------------------
# LAUNCHER AND WORKER — EVERY PUBLIC INVOCATION CREATES FRESH ISOLATION
# ---------------------------------------------------------------------------
#
# Until 2026-09-21 this script had ONE entry point with a branch: a process that
# arrived carrying COMPOSITE_DEMO_ISOLATED=1 together with two non-empty outer
# measurements was treated as the re-executed inner process and went straight to
# verification, skipping creation.  The six facts were then asked to carry the
# whole weight — and they cannot: F1 establishes a non-initial uid map, not
# creation BY THIS INVOCATION; F2 and F4 compare against SUPPLIED values; and an
# already-prepared namespace can perfectly well have an empty tmpfs /tmp and no
# gate path.  So two invocations inside ONE prepared namespace, inheriting the
# complete internal environment, could each print the private-workspace claim
# while sharing one mount namespace and one /tmp.  That is the defect, and it is
# fixed structurally, not by adding predicates:
#
#   · The PUBLIC entry point is the LAUNCHER.  It ALWAYS creates a fresh
#     namespace (unshare -rm --propagation private, fresh tmpfs over /tmp) or
#     REFUSES.  There is no branch in it that consults the environment for
#     permission to skip creation, and it SCRUBS every inherited COMPOSITE_DEMO_*
#     variable before it decides anything, announcing the scrub in its output.
#   · The WORKER is not reachable as a public mode through the environment.  It
#     is selected by a positional ARGUMENT, and only runs if it can verify a
#     CREDENTIAL the launcher generated for this invocation alone: a 64-hex-digit
#     nonce from /dev/urandom, passed on argv AND carried on an OPEN FILE
#     DESCRIPTOR over a file the launcher created and immediately UNLINKED.  The
#     worker requires that descriptor to be open, to be an unlinked regular file
#     (link count 0), and to carry exactly that nonce; then it closes it.
#     An inherited ENVIRONMENT cannot carry an open descriptor, and a person who
#     types `run-composite-demonstration.sh --composite-demo-worker <something>`
#     by hand has no such descriptor and is refused, non-zero, before anything is
#     created.
#   · The outer measurements F2 and F4 compare against travel on that same
#     descriptor, not through the environment, so no COMPOSITE_DEMO_* variable is
#     read by this script at all any more.  The name survives only as the prefix
#     the launcher scrubs.
#
# THE LIMIT OF THAT CLAIM, EXACTLY.  This closes inherited STATE and ordinary
# invocation: no environment an earlier run leaves behind, and no hand invocation
# of the worker role, can make a public invocation skip creating its own
# isolation.  It is NOT a claim against an adversary who can already execute
# arbitrary code as this user: such an adversary can build a fake launcher —
# nonce, unlinked file, open descriptor and all — and there is no defence here
# against that, nor is one attempted.  This is not general sandbox hardening and
# does not pretend to be.
#
# The six facts below are kept exactly where they belong: as VERIFICATION after
# creation, run by the worker before it will describe /tmp as private.  They are
# checks, never permission.  An environment can be inherited from the caller's
# shell or forged, and a claim made by a variable is not evidence about the
# machine; so the worker checks facts it can observe itself, and REFUSES if any
# of them fails:
#
#   F1  /proc/self/uid_map is NOT the initial mapping ("0 0 4294967295"): this
#       process is inside a NEW user namespace.  This is a kernel fact about the
#       running process.  Note what it does NOT say: it says a user namespace,
#       not a user namespace created by THIS invocation.  That is why it is only
#       a check now, and why the launcher creates unconditionally.
#   F2  the mount-namespace id (readlink /proc/self/ns/mnt) DIFFERS from the id
#       the outer process recorded of itself before re-executing: the mount
#       namespace actually changed across the re-execution.
#   F3  /proc/self/mountinfo contains a mount whose mount point is exactly /tmp
#       and whose filesystem type is tmpfs: /tmp in this namespace is a tmpfs
#       mount visible to this process.
#   F4  stat(2)'s device id for /tmp DIFFERS from the device id the outer process
#       recorded for /tmp: the /tmp seen here is not the filesystem object the
#       outer process saw.
#   F5  /tmp is EMPTY on entry.  The host /tmp is not: nothing of the caller's
#       /tmp is visible here.  (This is why no nonce file is planted on the host
#       — the shadowing is witnessed without writing anything outside.)
#   F6  /tmp/vertical0-reconstruction-gate does not exist on entry.
#
# WHAT THAT LEAVES UNESTABLISHED: /proc/<parent>/ns/mnt is not readable from
# inside this user namespace on this host, so the worker cannot read the parent's
# namespace id directly; F2 and F4 compare against values RECORDED by the
# launcher and carried in on the credential descriptor.  Those two facts are
# therefore only as good as that channel — which is why they are no longer what
# the decision rests on: the launcher has already created the namespace before
# the worker exists, and it did so unconditionally.  These checks say nothing
# about isolation of anything other
# than the mount view of /tmp: not network, not PIDs, not the rest of the
# filesystem, which is shared with your host and is what the content witness
# below is for.
#
# What backs the preservation claim is therefore not the copy but the CONTENT
# WITNESS: every tracked file and every untracked-not-ignored path under the
# project root is sha256'd before and after the run and the two manifests are
# compared, so a write through those symlinks — or anywhere else in that set —
# is NAMED and fails the run closed.  Files your checkout already had modified
# are INCLUDED in the witness and are never reset or stashed.  Ignored paths are
# NOT hashed and nothing is claimed about them.  If the witness cannot be built
# BEFORE the workload — no git, a failed enumeration, an empty path list, a file
# whose contents cannot be hashed — this runner exits non-zero without running
# any of PART I, II or III.
#
# WHAT THE WITNESS DOES AND DOES NOT CLAIM:
#   · it hashes the CONTENTS of every in-scope REGULAR file, and claims content
#     equality for exactly those.  If any in-scope regular file's contents cannot
#     be hashed, the witness is NOT ESTABLISHED and the run fails; an unreadable
#     file is never allowed to pass as a stable marker while its bytes change.
#   · the remaining in-scope paths have no file contents to hash — a symlink
#     (recorded by its target), a path absent from the filesystem (recorded
#     ABSENT), a directory or other non-regular node (recorded NOT-A-REGULAR-
#     FILE).  Those are recorded by TYPE/TARGET/ABSENCE only, and the two
#     populations are printed separately.  No content claim is made for them.
#   · before/after equality establishes ENDPOINT equality.  It does not show that
#     nothing was written during the interval: a file written and then restored
#     byte-for-byte between the two manifests is indistinguishable here from a
#     file never touched at all.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
SELF="$HERE/$(basename "${BASH_SOURCE[0]}")"

# --- gate-path isolation, decided BEFORE anything is created ----------------
# See "LAUNCHER AND WORKER" above.  The launcher creates the isolation
# unconditionally; the worker VERIFIES it from facts it can observe (F1..F6 in
# the header above) and refuses if any fails.  Nothing has been created at this
# point, so every exit below leaves no scratch behind.
#
# check_worker_credential <nonce-from-argv> <fd-number> — the hand-off the
# launcher makes to the worker.  It rests on something an inherited ENVIRONMENT
# cannot carry: an OPEN FILE DESCRIPTOR over a file the launcher created and
# immediately unlinked, whose first line is a 64-hex-digit nonce generated from
# /dev/urandom for this invocation and also passed on argv.  The remaining three
# lines carry the outer measurements F2/F4 compare against, so not even those
# arrive through the environment.  On success it sets WORKER_OUTER_*.
check_worker_credential() {
  local nonce="$1" fd="$2" target kind presented
  case "$fd" in
    ''|*[!0-9]*)
      echo "   credential FAIL: '${fd}' is not a file-descriptor number"
      return 1
      ;;
  esac
  case "$nonce" in
    ''|*[!0-9a-f]*)
      echo "   credential FAIL: the presented nonce is not hexadecimal"
      return 1
      ;;
  esac
  if [ "${#nonce}" -ne 64 ]; then
    echo "   credential FAIL: the presented nonce is not 64 hex digits"
    return 1
  fi
  if [ ! -e "/proc/self/fd/$fd" ]; then
    echo "   credential FAIL: file descriptor ${fd} is not open in this process"
    echo "                    — an environment cannot supply one; the worker role"
    echo "                    is reachable only from this script's own launcher."
    return 1
  fi
  target="$(readlink "/proc/self/fd/$fd" 2>/dev/null || true)"
  case "$target" in
    *' (deleted)') : ;;
    *)
      echo "   credential FAIL: descriptor ${fd} is '${target}', not an unlinked file"
      return 1
      ;;
  esac
  kind="$(stat -L -c '%F %h' "/proc/self/fd/$fd" 2>/dev/null || true)"
  if [ "$kind" != "regular file 0" ]; then
    echo "   credential FAIL: descriptor ${fd} is '${kind}', not an unlinked regular file"
    return 1
  fi
  presented=""
  if ! read -r -u "$fd" presented; then
    echo "   credential FAIL: nothing could be read from descriptor ${fd}"
    return 1
  fi
  if [ "$presented" != "$nonce" ]; then
    echo "   credential FAIL: descriptor ${fd} does not carry this invocation's nonce"
    return 1
  fi
  WORKER_OUTER_MNT_NS=""
  WORKER_OUTER_TMP_DEV=""
  WORKER_OUTER_TMP_ENTRIES=""
  read -r -u "$fd" WORKER_OUTER_MNT_NS || true
  read -r -u "$fd" WORKER_OUTER_TMP_DEV || true
  read -r -u "$fd" WORKER_OUTER_TMP_ENTRIES || true
  if [ -z "$WORKER_OUTER_MNT_NS" ] || [ -z "$WORKER_OUTER_TMP_DEV" ]; then
    echo "   credential FAIL: the descriptor's outer measurements are empty"
    return 1
  fi
  echo "   credential ok  : descriptor ${fd} is an open, UNLINKED regular file"
  echo "                    carrying this invocation's nonce"
  return 0
}

verify_isolation() {
  local ok=1 line ns dev entries

  line="$(tr -s ' ' ' ' < /proc/self/uid_map 2>/dev/null | sed 's/^ //;s/ $//' | head -1)"
  if [ "$line" = "0 0 4294967295" ] || [ -z "$line" ]; then
    echo "   F1 FAIL user namespace : uid_map is the initial mapping ('${line}')"
    echo "                            — this process is NOT in a new user namespace."
    ok=0
  else
    echo "   F1 ok   user namespace : /proc/self/uid_map = '${line}' (not the initial mapping)"
  fi

  ns="$(readlink /proc/self/ns/mnt 2>/dev/null || true)"
  if [ -z "$ns" ] || [ "$ns" = "$OUTER_MNT_NS" ]; then
    echo "   F2 FAIL mount namespace: id '${ns}' is unreadable or IDENTICAL to the"
    echo "                            id the outer process recorded ('${OUTER_MNT_NS}')."
    ok=0
  else
    echo "   F2 ok   mount namespace: ${ns} differs from the outer's ${OUTER_MNT_NS}"
  fi

  if awk '$5 == "/tmp" { for (i=6; i<=NF; i++) if ($i == "-") { print $(i+1); exit } }' \
       /proc/self/mountinfo 2>/dev/null | grep -qx tmpfs; then
    echo "   F3 ok   /tmp mount     : a tmpfs is mounted at /tmp in this namespace"
  else
    echo "   F3 FAIL /tmp mount     : no tmpfs mounted at /tmp in /proc/self/mountinfo"
    ok=0
  fi

  dev="$(stat -c '%d' /tmp 2>/dev/null || true)"
  if [ -z "$dev" ] || [ "$dev" = "$OUTER_TMP_DEV" ]; then
    echo "   F4 FAIL /tmp device    : device '${dev}' is unreadable or the SAME object"
    echo "                            the outer process saw ('${OUTER_TMP_DEV}')."
    ok=0
  else
    echo "   F4 ok   /tmp device    : ${dev} differs from the outer's ${OUTER_TMP_DEV}"
  fi

  entries="$(ls -A /tmp 2>/dev/null | wc -l)"
  if [ "$entries" -ne 0 ]; then
    echo "   F5 FAIL /tmp contents  : ${entries} entries visible — the caller's /tmp"
    echo "                            is not shadowed (the outer saw ${OUTER_TMP_ENTRIES})."
    ok=0
  else
    echo "   F5 ok   /tmp contents  : empty; none of the outer's ${OUTER_TMP_ENTRIES} /tmp entries is visible"
  fi

  if [ -e /tmp/vertical0-reconstruction-gate ]; then
    echo "   F6 FAIL gate path      : /tmp/vertical0-reconstruction-gate already exists here"
    ok=0
  else
    echo "   F6 ok   gate path      : /tmp/vertical0-reconstruction-gate absent on entry"
  fi

  [ "$ok" -eq 1 ]
}

# The worker role is selected by this positional argument and by nothing else.
WORKER_ROLE_ARG="--composite-demo-worker"

if [ "${1:-}" = "$WORKER_ROLE_ARG" ]; then
  # ----------------------------- WORKER -------------------------------------
  # Not a public entry point.  Reachable only with the launcher's per-invocation
  # credential, which an environment cannot carry.
  if [ "$#" -lt 3 ]; then
    echo "!! REFUSING TO RUN: the worker role was invoked without its credential."
    echo "   This role is not a public entry point and cannot be entered by hand."
    echo "   Run this script with no arguments: the launcher creates the isolation"
    echo "   itself and hands the worker a credential on an open, unlinked file"
    echo "   descriptor.  Nothing was created and no workload ran."
    exit 1
  fi
  WORKER_NONCE="$2"
  WORKER_FD="$3"
  shift 3
  echo "entry     : WORKER role requested — checking the launcher's credential"
  if ! check_worker_credential "$WORKER_NONCE" "$WORKER_FD"; then
    echo "!! REFUSING TO RUN: the worker credential did not verify.  This role runs"
    echo "   only when this script's own launcher created the isolation for it."
    echo "   Nothing was created and no workload ran."
    exit 1
  fi
  # The credential is consumed: close the descriptor so nothing downstream holds it.
  eval "exec ${WORKER_FD}<&-"
  OUTER_MNT_NS="$WORKER_OUTER_MNT_NS"
  OUTER_TMP_DEV="$WORKER_OUTER_TMP_DEV"
  OUTER_TMP_ENTRIES="$WORKER_OUTER_TMP_ENTRIES"
  echo "isolation : verifying what the launcher created (these are facts read"
  echo "            from this process and this namespace, never permission)"
  if verify_isolation; then
    : # every fact above holds; the run proceeds, isolated
  else
    echo "!! REFUSING TO RUN: the isolation the launcher created could not be"
    echo "   VERIFIED here.  Nothing was created and no workload ran."
    exit 1
  fi
else
  # ----------------------------- LAUNCHER -----------------------------------
  # The public entry point.  It creates fresh isolation or refuses; no state of
  # any kind can make it skip creation.  Inherited internal variables are
  # scrubbed FIRST, before anything is decided, and the scrub is announced.
  INHERITED="$(compgen -v 2>/dev/null | grep '^COMPOSITE_DEMO_' | sort | tr '\n' ' ' || true)"
  if [ -n "${INHERITED// /}" ]; then
    echo "entry     : inherited internal state IGNORED and scrubbed: ${INHERITED}"
  fi
  # Deliberate word splitting: INHERITED is a space-separated list of names.
  # shellcheck disable=SC2086
  for _v in ${INHERITED}; do
    unset "$_v" 2>/dev/null || true
  done
  echo "entry     : LAUNCHER — this invocation creates its OWN isolation.  No"
  echo "            environment state can make it skip creation; the six facts"
  echo "            are verification AFTER creation, never permission."
  if command -v unshare >/dev/null 2>&1 && unshare -rm true >/dev/null 2>&1; then
    NONCE="$(head -c 32 /dev/urandom 2>/dev/null | od -An -tx1 | tr -d ' \n')"
    if [ "${#NONCE}" -ne 64 ]; then
      echo "!! REFUSING TO RUN: could not generate a per-invocation credential."
      exit 1
    fi
    CRED="$(mktemp "${TMPDIR:-/tmp}/.composite-demo-credential.XXXXXX")" || {
      echo "!! REFUSING TO RUN: could not create the credential file."
      exit 1
    }
    {
      printf '%s\n' "$NONCE"
      readlink /proc/self/ns/mnt 2>/dev/null || echo unreadable
      stat -c '%d' /tmp 2>/dev/null || echo unreadable
      ls -A /tmp 2>/dev/null | wc -l
    } > "$CRED" || {
      rm -f "$CRED"
      echo "!! REFUSING TO RUN: could not write the credential."
      exit 1
    }
    exec 9< "$CRED" || {
      rm -f "$CRED"
      echo "!! REFUSING TO RUN: could not open the credential descriptor."
      exit 1
    }
    # Unlinked immediately: the credential exists only as this invocation's open
    # descriptor from here on, and leaves nothing on any filesystem.
    rm -f "$CRED"
    echo "entry     : credential created and UNLINKED — handed to the worker as"
    echo "            open descriptor 9, which no inherited environment can carry"
    exec env TMPDIR=/tmp \
      unshare -rm --propagation private -- \
      bash -c 'mount -t tmpfs -o size=2G tmpfs /tmp || exit 70; exec bash "$0" "$@"' \
      "$SELF" "$WORKER_ROLE_ARG" "$NONCE" 9 "$@"
  fi
  echo "!! REFUSING TO RUN: unprivileged user namespaces are not available here."
  echo "   The Vertical /0 reconstruction gate uses a FIXED shared workspace"
  echo "   (/tmp/vertical0-reconstruction-gate, a literal at"
  echo "   mneme/vertical0/reconstruction/run-reconstruction-gate.lisp:90, deleted"
  echo "   at :232).  Without a private mount namespace this runner cannot hold a"
  echo "   boundary around that path against callers that do not cooperate — the"
  echo "   release floor's vertical0 row and any hand-run of the gate take no lock"
  echo "   and consult no marker — and it will not pretend otherwise."
  echo "   There is no weaker shared-path mode and no variable that enables one:"
  echo "   when isolation cannot be established, this runner refuses."
  exit 1
fi

# The reconstruction digest Vertical /0 declares in VERTICAL-0-RETURN.md.
# Reproducing it is a required exit condition of this demonstration.
EXPECTED_DIGEST="706f7e1e582e06cce14ba44428b7c0705bd6480a8dcbd5ebf5a9a85874cdd05a"

echo "==========================================================================="
echo " LISP+ COMPOSITE RELEASE DEMONSTRATION"
echo " Not a complete semantic end-to-end language path. See the boundary"
echo " statement printed at the end of this run."
echo "==========================================================================="
echo

command -v sbcl >/dev/null 2>&1 || { echo "!! sbcl not on PATH"; exit 127; }
SBCL_VERSION="$(sbcl --noinform --non-interactive \
  --eval '(progn (princ (lisp-implementation-version)) (terpri) (finish-output))' 2>/dev/null | tail -1)"
echo "toolchain : SBCL ${SBCL_VERSION}   (supported: 2.4.6/Linux — nothing else tested)"
if [ "$SBCL_VERSION" != "2.4.6" ]; then
  echo "!! FAIL CLOSED: authorized for SBCL 2.4.6 only; observed ${SBCL_VERSION}."
  exit 1
fi

# --- what this invocation created, and nothing else -------------------------
OWNED_PATHS=()
cleanup() {
  local p
  for p in "${OWNED_PATHS[@]:-}"; do
    [ -n "$p" ] && rm -rf "$p" 2>/dev/null || true
  done
}
trap cleanup EXIT INT TERM

# The Vertical /0 reconstruction gate's workspace is a FIXED shared path it
# `rm -rf`s on entry and cannot be pointed elsewhere.  In the isolated route that
# path lives on a private tmpfs belonging to this invocation alone: the gate
# creates and deletes it itself, this runner neither claims nor removes it, and
# the HOST path of that name is never touched.  There is no other route: the
# unsound claim/refuse protocol on the shared host path is gone, and so is the
# weaker shared-path mode it lived in.
GATE="/tmp/vertical0-reconstruction-gate"
echo "isolation : PRIVATE MOUNT NAMESPACE, VERIFIED ABOVE — /tmp is a fresh tmpfs"
echo "            belonging to this invocation.  $GATE exists only inside it; the"
echo "            host path of that name is never created, claimed or removed by"
echo "            this run.  (this process runs as uid 0 mapped from your uid:"
echo "            permission bits on your files are not enforced against it)"

RUNDIR="$(mktemp -d "${TMPDIR:-/tmp}/lisp-plus-composite-demo.XXXXXX")"
OWNED_PATHS+=("$RUNDIR")
COPY="$RUNDIR/tree"
echo "scratch   : $RUNDIR   (removed on success AND on failure)"

# manifest <outfile> — the CONTENT witness.  The set is explicit: every tracked
# file (git ls-files) plus every untracked-not-ignored path (git ls-files
# --others --exclude-standard) under $ROOT, including files that are ALREADY
# modified or already untracked in your checkout.  Each line is "<sha256>  <rel
# path>"; a symlink is recorded by its target and a path that is absent from the
# filesystem is recorded as ABSENT, so neither can pass as unchanged.  Ignored
# paths are outside the set and outside every claim made from it.
# Every stage of this function propagates its own failure EXPLICITLY and returns
# non-zero.  It is called through `|| ...`, which disables `set -e` inside it, so
# nothing here may rely on `set -e`; a stage that fails silently would produce a
# short or EMPTY manifest, and an empty manifest compared against an empty
# manifest is 0 == 0 — a failed enumeration passing as a clean witness.  An empty
# path list is itself a failure, and so is any regular file whose contents cannot
# be hashed.
MANIFEST_HASHED=0
MANIFEST_RECORDED=0
manifest() {
  local out="$1" p rc
  local list="$RUNDIR/.witness-paths"
  local tracked="$RUNDIR/.witness-tracked"
  local others="$RUNDIR/.witness-others"
  local special="$RUNDIR/.witness-special"
  local hashable="$RUNDIR/.witness-hashable"
  local hashes="$RUNDIR/.witness-hashes"
  local hasherr="$RUNDIR/.witness-hash-stderr"

  git -C "$ROOT" ls-files -z > "$tracked" \
    || { echo "!! witness NOT ESTABLISHED: 'git ls-files' (tracked paths) failed (exit $?)"; return 1; }
  git -C "$ROOT" ls-files --others --exclude-standard -z > "$others" \
    || { echo "!! witness NOT ESTABLISHED: 'git ls-files --others' (untracked-not-ignored) failed (exit $?)"; return 1; }
  LC_ALL=C sort -z -u "$tracked" "$others" > "$list" \
    || { echo "!! witness NOT ESTABLISHED: merge/sort of the two path lists failed (exit $?)"; return 1; }

  local want
  want="$(tr -cd '\0' < "$list" | wc -c)" \
    || { echo "!! witness NOT ESTABLISHED: could not count the enumerated paths"; return 1; }
  if [ "$want" -eq 0 ]; then
    echo "!! witness NOT ESTABLISHED: path enumeration produced ZERO paths."
    echo "   An empty list is a FAILED enumeration, not an empty project: comparing"
    echo "   nothing with nothing would say 'unchanged' while establishing nothing."
    return 1
  fi

  : > "$special" || return 1
  : > "$hashable" || return 1
  local unreadable=0
  while IFS= read -r -d '' p; do
    if [ -L "$ROOT/$p" ]; then
      printf 'symlink->%s  %s\n' "$(readlink "$ROOT/$p")" "$p" >> "$special" || return 1
    elif [ ! -e "$ROOT/$p" ]; then
      printf 'ABSENT  %s\n' "$p" >> "$special" || return 1
    elif [ ! -f "$ROOT/$p" ]; then
      printf 'NOT-A-REGULAR-FILE  %s\n' "$p" >> "$special" || return 1
    elif [ ! -r "$ROOT/$p" ]; then
      # A regular file whose CONTENTS cannot be read.  A marker here would be a
      # claim about type, not about bytes: the file could change underneath it
      # and the marker would be identical before and after.  Refuse instead.
      echo "   unhashable in-scope regular file: $p"
      unreadable=$((unreadable+1))
    else
      printf '%s\0' "$p" >> "$hashable" || return 1
    fi
  done < "$list"
  if [ "$unreadable" -ne 0 ]; then
    echo "!! witness NOT ESTABLISHED: $unreadable in-scope regular file(s) could not be"
    echo "   read, so their CONTENTS cannot be witnessed.  This runner claims content"
    echo "   equality only for files it actually hashed, and refuses to record an"
    echo "   unreadable file by a marker that its own bytes could change underneath."
    return 1
  fi

  cat "$special" > "$out" || { echo "!! witness NOT ESTABLISHED: could not write the type/target/absence records"; return 1; }
  : > "$hashes" || return 1
  if [ -s "$hashable" ]; then
    ( cd "$ROOT" && xargs -0 -r -n 256 -P 4 sha256sum < "$hashable" ) > "$hashes" 2> "$hasherr"
    rc=$?
    if [ "$rc" -ne 0 ]; then
      echo "!! witness NOT ESTABLISHED: hashing failed (exit $rc).  sha256sum said:"
      sed 's/^/      /' "$hasherr" | head -20
      return 1
    fi
  fi
  cat "$hashes" >> "$out" || { echo "!! witness NOT ESTABLISHED: could not append the content hashes"; return 1; }
  LC_ALL=C sort -k2 -o "$out" "$out" || { echo "!! witness NOT ESTABLISHED: could not sort the manifest"; return 1; }

  # fail closed if any listed path produced no manifest line: a hash error that repeats
  # identically before and after would otherwise drop out of BOTH manifests unseen
  local have
  have="$(wc -l < "$out")" || return 1
  [ "$want" -eq "$have" ] || { echo "!! witness NOT ESTABLISHED: manifest is incomplete: $have lines for $want listed paths"; return 1; }
  MANIFEST_HASHED="$(wc -l < "$hashes")"
  MANIFEST_RECORDED="$(wc -l < "$special")"
}

WITNESS_BEFORE="$RUNDIR/witness-before.txt"
WITNESS_AFTER="$RUNDIR/witness-after.txt"
WITNESS_SECONDS=0
WITNESS_BROKEN=0
BEFORE_HASHED=0
BEFORE_RECORDED=0
# The witness is established BEFORE the workload or the workload does not start.
# A run whose initial witness failed can establish nothing about preservation,
# and there is no reason to spend four minutes finding that out at the end.
if ! git -C "$ROOT" rev-parse --git-dir >/dev/null 2>&1; then
  echo "!! REFUSING TO RUN: $ROOT is not a git checkout, so the witness set"
  echo "   (tracked files + untracked-not-ignored paths) cannot be enumerated and"
  echo "   no before/after comparison is possible.  The absence of a check is not a"
  echo "   clean result, so this runner does not start the workload at all."
  exit 1
fi
_w0=$SECONDS
manifest "$WITNESS_BEFORE" || WITNESS_BROKEN=1
WITNESS_SECONDS=$((SECONDS - _w0))
if [ "$WITNESS_BROKEN" -ne 0 ]; then
  echo "!! REFUSING TO RUN: the initial content witness could not be established"
  echo "   (the reason is printed above).  Nothing in PART I, II or III has run."
  exit 1
fi
BEFORE_HASHED="$MANIFEST_HASHED"
BEFORE_RECORDED="$MANIFEST_RECORDED"
echo "witness   : $(wc -l < "$WITNESS_BEFORE") paths before the run (${WITNESS_SECONDS}s) —"
echo "            ${BEFORE_HASHED} regular files content-hashed (sha256);"
echo "            ${BEFORE_RECORDED} paths recorded by type/target/absence only"
echo

mkdir -p "$COPY"
if command -v rsync >/dev/null 2>&1; then
  rsync -a --exclude '.git/' --exclude 'canonical-datum/evidence/' \
           --exclude 'canonical-datum/generated/' "$ROOT"/ "$COPY"/
else
  ( cd "$ROOT" && tar -cf - --exclude=.git --exclude=canonical-datum/evidence \
      --exclude=canonical-datum/generated . ) | ( cd "$COPY" && tar -xf - )
fi
ln -sfn "$ROOT/canonical-datum/evidence"  "$COPY/canonical-datum/evidence"
ln -sfn "$ROOT/canonical-datum/generated" "$COPY/canonical-datum/generated"

FAILED=0
FAILED_NOTES=()
LAST_LOG=""

fail() {
  FAILED=$((FAILED+1))
  FAILED_NOTES+=("$1")
}

# cite <log> <id>... — echo the SPECIMEN'S OWN check lines, verbatim, by check
# number.  Nothing is reworded here; if a line is missing the citation says so
# and the run is failed.  (No truncation: these lines carry multibyte
# characters and a byte-wise cut would split them.)
cite() {
  local log="$1"; shift
  local id line
  for id in "$@"; do
    line="$(grep -m1 -F "[$id] " "$log")"
    if [ -z "$line" ]; then
      echo "   !! citation missing from the specimen transcript: check [$id]"
      fail "a cited check line was MISSING from a specimen transcript: [$id]"
    else
      printf '%s\n' "$line" | sed 's/^/     /'
    fi
  done
}

step() {
  local title="$1" expect="$2"; shift 2
  echo
  echo "---------------------------------------------------------------------------"
  echo ">> $title"
  echo "   \$ $*"
  echo "---------------------------------------------------------------------------"
  local log="$RUNDIR/$(echo "$title" | tr -cd '[:alnum:]' | cut -c1-40).log"
  LAST_LOG="$log"
  ( cd "$COPY" && "$@" ) >"$log" 2>&1
  local rc=$?
  tail -14 "$log" | sed 's/^/   | /'
  if [ "$rc" -ne 0 ]; then
    echo "   -> FAILED (exit $rc)"; fail "$title — exited $rc"; return 1
  fi
  if [ "$expect" != "-" ] && ! grep -qF -- "$expect" "$log"; then
    echo "   -> FAILED (exit 0 but the required line is absent: $expect)"
    fail "$title — required line absent: $expect"; return 1
  fi
  echo "   -> OK (exit 0)"
  return 0
}

echo "==========================================================================="
echo " PART I — the durable process path"
echo "==========================================================================="

step "I.1  journal0 de-teste-occiso — LIVE SIGKILL of real writer processes" \
     "RESULT: PASS" \
     sbcl --script mneme/journal0/de-teste-occiso/run-specimen.lisp

step "I.2  Vertical /0 integration controls — identity, capabilities, effect frontier, fake adapter" \
     "vertical0 integration controls: 37 checks, 0 failures" \
     sbcl --script mneme/vertical0/controls/run-integration-controls.lisp

step "I.3  Vertical /0 reconstruction gate — reconstruction and inspection after death" \
     "run-reconstruction-gate: 31 checks, 0 failures" \
     sbcl --script mneme/vertical0/reconstruction/run-reconstruction-gate.lisp

step "I.4  Vertical /0 repeatability — byte-compare the two PRESERVED four-death campaigns" \
     "-" \
     bash mneme/vertical0/harness/repeatability.sh

echo
echo "---------------------------------------------------------------------------"
echo ">> I.5  reconstruction digest check"
echo "---------------------------------------------------------------------------"
DIGEST_HITS="$(grep -rlF "$EXPECTED_DIGEST" "$RUNDIR"/*.log 2>/dev/null | wc -l)"
if [ "$DIGEST_HITS" -gt 0 ]; then
  echo "   required digest REPRODUCED by this run:"
  echo "     $EXPECTED_DIGEST"
  echo "   (found in $DIGEST_HITS of this run's transcripts)"
else
  echo "   !! required digest NOT reproduced: $EXPECTED_DIGEST"
  fail "I.5 reconstruction digest NOT reproduced"
fi

echo
echo "==========================================================================="
echo " PART II — the read-only re-expression"
echo "==========================================================================="

step "II.1 Surface /2 inhabited — re-expresses the COMPLETED census through the surface layer" \
     "surface2-inhabited: 18 checks, 0 failures" \
     sbcl --script mneme/language-surface-2/surface2-inhabited.lisp

step "II.2 Surface /2 selftest" \
     "surface2-selftest: 29 checks, 0 failures" \
     sbcl --script mneme/language-surface-2/surface2-selftest.lisp

echo
echo "==========================================================================="
echo " PART III — the language's derive/perform doors on the durable substrate"
echo "==========================================================================="
cat <<'PART3_INTRO'

  WHAT YOU ARE ABOUT TO SEE, for a reader who has never seen this project.

  A "language act" here is one request the language performs against a world it
  cannot undo.  The supported sequence PART III exercises is:

    1. PERFORM an effect.  A first process derives the act's identity from
       declared configuration alone, crosses the EFFECT FRONTIER (the point past
       which the outside world has already moved), and the world applies and
       ledgers the write.
    2. TERMINATE at the specimen's SPECIFIED point.  The process is made to exit
       inside the ACKNOWLEDGMENT WINDOW — after the effect, before any record of
       the effect.  The exit is planted by the specimen (exit code 7, no RESULT
       sentinel); it is not an arbitrary crash.
    3. RECOVER IN A LATER PROCESS.  A genuinely new image, given only the
       durable bytes and the declared configuration, re-derives the same act
       identity.  Nothing is carried in memory across the death.
    4. DERIVE THE SUPPORTED STANDING from those bytes, and
    5. REFUSE THE CONTINUATION where the lane requires it — the same act, and a
       disguised retry of it, are refused PRE-FRONTIER, so the world does not
       move twice.  Only a structured uncertainty record plus an evidence-carried
       reconciliation frees the seat.
    6. RECALL AND CONSOLIDATE.  A second lane then writes the first durable,
       language-level ACCOUNT of an act nobody was alive to witness, and folds
       accounts together under stated rules.

  TWO STANDINGS, AND WHY THEY DIFFER — the project's own words, not a paraphrase.

    Occurrence standing (mneme/memory-layer-0/MEMORY-LAYER-0-SPEC.md:221-226):
      "Occurrence standing — `:occurred | :nonoccurred | :unresolved |
       :contradicted`" ... "`:unresolved` is the lawful default and is never a
       defect."

    Issuance standing (same file, :238, :242-245):
      "Issuance standing — `:issued-in-writing-image | :unresolved`" ...
      "Core /0's issuance registry is a per-image hash table with no durable
       footprint (`core0.lisp:830-836`), so in any image but the issuing one
       `core0-evidence-current-image-issued-p` answers false for every possible
       input. A predicate that is false universally is not an absence warrant."

    So an account read by a later process can say the act OCCURRED while its
    issuance stays UNRESOLVED: the evidence registry died with the image that
    held it, and a predicate that answers false for everything cannot warrant
    "not issued".  UNRESOLVED is the honest word, not a failure.

  WHAT IS BEING EXERCISED, stated so it cannot be read larger than it is:
    · the world is the deterministic FAKE world of these lanes; no live provider;
    · the adapter is the SCRIPTED adapter subset, one seat/effect family;
    · the platform is ONE host, SBCL 2.4.6/Linux, and nothing else is supported;
    · the termination boundary is PLANTED and deterministic.

PART3_INTRO

if step "III.1 One Act /1 de-actu-resurgente — perform, planted death in the acknowledgment window, recovery and refusal in a LATER process" \
     "de-actu-resurgente: 49 checks, 0 failures" \
     sbcl --script mneme/language-act-1/de-actu-resurgente/run-specimen.lisp
then
  echo
  echo "   the specimen's own lines for the supported sequence (verbatim):"
  cite "$LAST_LOG" 005 007 023 024 031 037 040 045
fi

if step "III.2 Memory Layer /0 de-actu-memorato — the durable account of an act no live process witnessed; recall and consolidation" \
     "de-actu-memorato: 45 checks, 0 failures" \
     sbcl --script mneme/memory-layer-0/de-actu-memorato/run-specimen.lisp
then
  echo
  echo "   the specimen's own lines for occurrence/issuance, recall and consolidation (verbatim):"
  cite "$LAST_LOG" 010 032 033 035 036 042 043
fi

echo
echo "   NOTE ON ISOLATION: both specimens REWRITE their tracked ARTIFACT-* files"
echo "   in place on every run (11 files under de-actu-resurgente/, 13 under"
echo "   de-actu-memorato/) and create stage directories beside them.  That is"
echo "   why PART III runs inside the disposable copy.  The copy is not a total"
echo "   boundary — canonical-datum/evidence and canonical-datum/generated are"
echo "   symlinks back into your tree, and the Vertical /0 gate uses a fixed"
echo "   /tmp workspace, which this run put on a PRIVATE tmpfs of its own rather"
echo "   than share with other callers.  What is actually checked is the content"
echo "   witness below."

# --- cleanliness, fail closed ---------------------------------------------
echo
echo "---------------------------------------------------------------------------"
echo ">> checkout preservation — content witness"
echo "---------------------------------------------------------------------------"
WITNESS_OK=0
{
  _w1=$SECONDS
  manifest "$WITNESS_AFTER" || WITNESS_BROKEN=1
  WITNESS_SECONDS=$((WITNESS_SECONDS + SECONDS - _w1))
  if [ "$WITNESS_BROKEN" -ne 0 ]; then
    echo "   !! PRESERVATION NOT ESTABLISHED — the content witness is incomplete (see the manifest message above)."
    fail "preservation NOT ESTABLISHED (the content witness was incomplete)"
  elif diff -u "$WITNESS_BEFORE" "$WITNESS_AFTER" > "$RUNDIR/witness.diff" 2>&1; then
    WITNESS_OK=1
    echo "   ESTABLISHED, at exactly this size, for the set of every tracked file"
    echo "   and every untracked-not-ignored path under"
    echo "     $ROOT"
    echo "   — $(wc -l < "$WITNESS_AFTER") paths in all, in two populations:"
    echo "     · ${MANIFEST_HASHED} regular files whose CONTENTS were sha256'd before and after"
    echo "       this run and are byte-identical.  Content equality is claimed for"
    echo "       these and only these."
    echo "     · ${MANIFEST_RECORDED} paths with no file contents to hash, recorded by"
    echo "       type/target/absence only (symlink target, ABSENT, NOT-A-REGULAR-FILE)"
    echo "       and unchanged in that record.  No content claim is made for them."
    echo "   Had any in-scope regular file been unreadable, the witness would have"
    echo "   failed rather than record it by a marker.  Files already modified in"
    echo "   your checkout were INCLUDED and were neither reset nor stashed."
    echo "   IGNORED paths were not hashed and nothing is claimed about them."
    echo "   THIS IS ENDPOINT EQUALITY: the before and after states match.  It does"
    echo "   not show that nothing was written in between — a file written and then"
    echo "   restored byte-for-byte during the run is indistinguishable here from a"
    echo "   file never touched.  (witness cost: ${WITNESS_SECONDS}s total)"
  else
    echo "   !! FAIL CLOSED — content changed under $ROOT during this run."
    echo "   paths that differ between the before/after manifests:"
    LC_ALL=C awk '/^[-+][^-+]/ { sub(/^[-+]/,""); if (match($0, /  /)) print substr($0, RSTART+2) }' \
      "$RUNDIR/witness.diff" | LC_ALL=C sort -u | sed 's/^/      /'
    echo "   (full manifest diff, this run only: $RUNDIR/witness.diff)"
    fail "the content witness FAILED: paths under $ROOT changed during the run"
  fi
}

# --- the boundary statement -----------------------------------------------
echo
echo "==========================================================================="
echo " BOUNDARY STATEMENT"
echo "==========================================================================="
cat <<'BOUNDARY'

  STANDING FACTS ABOUT THE ADOPTED LANES — true before this run started, and
  unaffected by how it ended:

  The language's derive/perform doors DO open onto the journal-backed durable
  substrate across a planted process death. That capability was built and adopted
  by One Act /0 (adopted 2026-08-08), One Act /1 (adopted 2026-08-22) and Memory
  Layer /0 (adopted and published 2026-08-22); the seam this file once called
  "the first missing semantic seam" on 2026-08-02 is closed. PART III EXPOSES
  that adopted capability. It adds no recovery semantics, and no execution of
  this runner — passing or failing — establishes any.

  Part II is a read-only re-expression by construction: it reads Part I's
  finished result and never drives it. That is a property of the lane, not a
  result of this run.

  WHAT THE ADOPTED LANES DO NOT SHOW, AND WHAT PART III THEREFORE CANNOT SHOW:
    · not a general power-loss, torn-media, or arbitrary-crash guarantee. The
      death is planted by the specimen at a declared point: "Deterministic
      planted process death; no general SIGKILL, power-loss, or mid-write
      guarantee" (One Act /1 adoption record, verbatim);
    · not a real world and not a real provider — "Fake world, scripted adapter
      subset, one seat/effect family, and non-adversarial local recognition"
      (same record, verbatim);
    · not a second implementation — "No alternative Act1/Core implementation";
      and the heterogeneous observer path "shares the subject's semantic
      implementation" (same record, verbatim);
    · not cross-store memory — Memory Layer /0 is "/0 same-store only", with
      "receipt-bearing foreign lineage reserved to Memory Layer /1", "D6 PARTIAL"
      and "D4 SHOWN-AS-AMENDED" (carried row `ml0`, mneme/verify-release.sh,
      verbatim);
    · not an audit, and not a change of standing — ML/0's standing is the status
      stone's (mneme/architecture/ARCHITECTURE-0-STATUS.md, ADDENDUM 25 item 6):
      its strict stranger audit was "PERFORMED AND RECEIVED", the obligation
      "DISCHARGED", "BOUNDED INDEPENDENT EVIDENCE OBTAINED" — and, still standing,
      "P9 FAIL STANDS IN THE REGISTER", "`ml0.lisp:3002` COMPANION COMMENT
      UNCORRECTED", "NO SUPPORTED-PATH RUNTIME SEMANTIC FAILURE ESTABLISHED".
      "same-family execution is not independent audit" (carried row `ml0`).
      The stranger primitive-minimization audit is a DIFFERENT audit and is
      still OWED. DO NOT SAY "independently verified" (One Act /1 record).

  Further limits carried by this demonstration, none of them repaired here:
    · journal0's LIVE deaths in PART I are SIGKILL only, on one SBCL 2.4.6/Linux
      host — no power-loss model, no torn-media model, no second host;
    · the four-death campaign was VERIFIED as a preserved artifact, not
      regenerated — verifying an archive is not reproducing a campaign;
    · the adapter boundary is the deterministic fake; no live provider exists;
    · this is self-consistency certification, never independent conformance;
    · nothing here adopts any implementation or raises any lane's standing.

  The current claim ceiling is mneme/integration-baseline-0/CLAIM-CEILING-0.md.

BOUNDARY

echo
cat <<'ISO_NOTE'
  HOW THE SHARED-WORKSPACE BOUNDARY WAS OBTAINED, AND WHAT IT DOES NOT COVER:
  the Vertical /0 gate's fixed workspace path is a literal in adopted, pinned
  source and cannot be redirected by any caller.  This run therefore executed
  inside a private user + mount namespace with its own tmpfs over /tmp, so that
  path existed only within this invocation.  The host path of that name was never
  created, claimed or removed here, and no other caller — the release floor's
  vertical0 row, or any hand-run of the gate — could see or be affected by this
  run's workspace, or it by theirs.  The boundary is structural, not cooperative:
  it needs no agreement from callers that would not have given one.
  It does NOT make concurrent gate runs safe for anyone else: two callers on the
  HOST path still share and delete one workspace.  Only editing that pinned
  source, which this runner may not do, would fix that for them.
  Inside the namespace this process ran as uid 0 mapped from your uid, so your
  files' permission bits were not enforced against it.
  The isolation was not taken on the word of an environment variable: the
  re-executed process verified it against facts it read itself (a non-initial
  user-namespace uid_map, a changed mount-namespace id, a tmpfs mounted at /tmp
  with a different device id, an empty /tmp, no gate directory) and would have
  refused before creating anything had any of them failed.  There is no weaker
  shared-path route in this runner: when isolation cannot be established, it
  refuses.

ISO_NOTE
if [ "$FAILED" -eq 0 ] && [ "$WITNESS_OK" -eq 1 ]; then
  cat <<'THIS_RUN'
  ---------------------------------------------------------------------------
  WHAT THIS EXECUTION DID
  ---------------------------------------------------------------------------

  PART I's durable process/reconstruction path ran here and passed, and this run
  reproduced the required reconstruction digest.
  PART II's Surface /2 re-expression ran here and passed.
  PART III just ran the two adopted specimens end to end in this process tree:
  perform, planted death inside the acknowledgment window, recovery and refusal
  in a later process, and the durable account, each specimen rendering its own
  verdicts and every quoted line cited from its own transcript.
  The content witness held: the in-scope regular files under the project root are
  byte-identical to what they were before the run, and the remaining in-scope
  paths are unchanged in type/target/absence. That is ENDPOINT equality — not a
  claim that nothing was written and restored in between.

  This is a packaging result. PART III's semantics are the ones the adopted lanes
  already carry, at the ceilings above — this run raises nothing.

THIS_RUN
else
  echo "  ---------------------------------------------------------------------------"
  echo "  WHAT THIS EXECUTION DID NOT ESTABLISH"
  echo "  ---------------------------------------------------------------------------"
  echo
  echo "  This run did not complete. What failed or went unestablished:"
  for _n in "${FAILED_NOTES[@]:-}"; do
    [ -n "$_n" ] && echo "    · $_n"
  done
  echo
  echo "  Therefore this execution does NOT show that the composite path runs end"
  echo "  to end on this host, and no sentence above about what \"just ran\" applies"
  echo "  to it. The standing facts about the adopted lanes are unchanged by a"
  echo "  failed run — and so is the fact that this run did not demonstrate them."
  if [ "$WITNESS_OK" -ne 1 ]; then
    echo "  Preservation of your checkout is NOT established by this run."
  fi
  echo
fi

echo "==========================================================================="
if [ "$FAILED" -ne 0 ]; then
  echo " COMPOSITE DEMONSTRATION: FAIL ($FAILED failing item(s))"
  echo "==========================================================================="
  exit 1
fi
echo " COMPOSITE DEMONSTRATION: PASS"
echo "==========================================================================="
exit 0
