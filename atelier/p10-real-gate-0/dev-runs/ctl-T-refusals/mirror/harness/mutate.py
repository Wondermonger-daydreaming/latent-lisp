#!/usr/bin/env python3
"""mutate.py <case> <subject-root> [--pinned FILE] [--git-repo DIR]

Applies the PREREG-P10-RG-0 §3 mutation for <case> to
<subject-root>/mneme/memory-layer-0/ml0.lisp, under an EXACT-MATCH guard
(every old text must occur exactly once), and writes the unified diff against a
PRISTINE copy of the same file to <subject-root>/MUTATION-DIFF.txt.

Pristine provenance, in order of preference (recorded in the diff header):
  1. `git show <commit>:experiments/latent-lisp/mneme/memory-layer-0/ml0.lisp`
     from --git-repo (or $P10_LAB_REPO), when a repo is reachable;
  2. a copy of the subject's own file taken BEFORE mutation, whose sha256 is
     asserted equal to the row for that path in the pinned list (--pinned or
     $P10_PINNED).  The pinned-sha check is what makes route 2 equivalent to
     route 1; the runner also verifies all 70 shas before calling this script.
At least one of the two must be available, or this script refuses (exit 2).

Cases: B0, B0-I, U1 -> no mutation (empty MUTATION-DIFF.txt, prints "none").
       M1-C, M1-U, M2-P, M2-X -> the named mutation.
       M1-U-I -> M1-U's mutation.  U1-M -> M2-P's mutation.
Exit 0 on success; 2 on any guard failure (nothing is written on a guard
failure except, possibly, nothing at all -- the write happens last).
"""

import difflib
import hashlib
import os
import subprocess
import sys

COMMIT = "244580e81a9002ea61a435ed185e85133a994fd9"
REL = "mneme/memory-layer-0/ml0.lisp"
GIT_PATH = "experiments/latent-lisp/" + REL

# case -> mutation kind
CASES = {
    "B0": None,
    "B0-I": None,
    "U1": None,
    "M1-C": "M1-C",
    "M1-U": "M1-U",
    "M1-U-I": "M1-U",
    "M2-P": "M2-P",
    "M2-X": "M2-X",
    "U1-M": "M2-P",
}


def die(msg):
    sys.stderr.write("mutate.py: REFUSED: %s\n" % msg)
    sys.exit(2)


def sha256_bytes(b):
    return hashlib.sha256(b).hexdigest()


# ---------------------------------------------------------------- form scanner
def scan_form(text, start):
    """Reader-aware scan of one top-level form starting at index `start`
    (which must be an open paren).  Handles strings with backslash escapes,
    `;` comments to end of line, and #\\( character literals -- ml0.lisp:1849
    has an unbalanced ')' inside a docstring/format string, so naive paren
    counting is wrong.  Returns the index just past the closing paren."""
    if text[start] != "(":
        die("form scan: index %d is %r, not '('" % (start, text[start]))
    depth = 0
    i = start
    n = len(text)
    while i < n:
        c = text[i]
        if c == "\\":                      # escape outside a string: #\( etc.
            i += 2
            continue
        if c == ";":
            j = text.find("\n", i)
            i = n if j < 0 else j + 1
            continue
        if c == '"':
            i += 1
            while i < n:
                if text[i] == "\\":
                    i += 2
                    continue
                if text[i] == '"':
                    i += 1
                    break
                i += 1
            continue
        if c == "#" and i + 1 < n and text[i + 1] == "\\":
            i += 3                          # #\x  (incl. #\( and #\) )
            continue
        if c == "(":
            depth += 1
        elif c == ")":
            depth -= 1
            if depth == 0:
                return i + 1
        i += 1
    die("form scan: unterminated form starting at index %d" % start)


def line_of(text, index):
    return text.count("\n", 0, index) + 1


def replace_once(text, old, new, label):
    k = text.count(old)
    if k != 1:
        die("%s: old text occurs %d times, expected exactly 1\n---\n%s\n---"
            % (label, k, old))
    line = line_of(text, text.index(old))
    sys.stdout.write("mutate.py: GUARD OK  %s  (unique; at line %d)\n"
                     % (label, line))
    return text.replace(old, new, 1)


# ------------------------------------------------------------------- mutations
def mut_m1_c(text):
    """Delete the whole (defun ml0-print-store-universe ...) form (l.1846-1858
    per INSPECTOR) plus the single blank line that followed it, so the file
    keeps one blank line between neighbours."""
    marker = "(defun ml0-print-store-universe (label before after)"
    if text.count(marker) != 1:
        die("M1-C: defun header occurs %d times, expected 1" % text.count(marker))
    start = text.index(marker)
    if start > 0 and text[start - 1] != "\n":
        die("M1-C: defun header is not at the start of a line")
    end = scan_form(text, start)
    first, last = line_of(text, start), line_of(text, end - 1)
    if (first, last) != (1846, 1858):
        die("M1-C: measured form boundaries are l.%d-%d, INSPECTOR said "
            "l.1846-1858 -- refusing rather than guessing" % (first, last))
    # swallow the newline ending the form and one following blank line
    tail = end
    if text[tail:tail + 1] == "\n":
        tail += 1
    if text[tail:tail + 1] == "\n":
        tail += 1
    sys.stdout.write("mutate.py: GUARD OK  M1-C form boundaries verified by "
                     "reader-aware scan: l.%d-%d (%d bytes) + 1 blank line\n"
                     % (first, last, end - start))
    return text[:start] + text[tail:]


DEFSTRUCT_511_514 = (
    "(defstruct (ml0-subject (:constructor %make-ml0-subject "
    "(&key fixture-row act-id act-id-hex seat attempt external-request-key "
    "canonical-request)) (:copier nil))\n"
    '  "THE ONE CANONICAL SUBJECT CARRIER a door is given.  Every field is DERIVED\n'
    'together from the one declared fixture row; none is accepted separately."\n'
    "  (fixture-row nil :read-only t)\n")

DEFSTRUCT_511_514_NEW = (
    "(defstruct (ml0-subject (:constructor %make-ml0-subject "
    "(&key act-id act-id-hex seat attempt external-request-key "
    "canonical-request)) (:copier nil))\n"
    '  "THE ONE CANONICAL SUBJECT CARRIER a door is given.  Every field is DERIVED\n'
    'together from the one declared fixture row; none is accepted separately."\n')

MAKE_537_539 = ("       (%make-ml0-subject\n"
                "        :fixture-row fixture-row\n"
                "        :act-id (act1-record-act-id record)\n")
MAKE_537_539_NEW = ("       (%make-ml0-subject\n"
                    "        :act-id (act1-record-act-id record)\n")


def mut_m1_u(text):
    """Remove the fixture-row slot of ml0-subject: the BOA constructor key
    (l.511), the slot (l.514) and the :fixture-row argument (l.538).

    ⚠ The bare slot line `  (fixture-row nil :read-only t)` occurs TWICE in
    ml0.lisp (l.514 in ml0-subject, l.1112 in ml0-bundle) -- the exact-match
    guard caught it.  Both l.511/514 edits are therefore made as ONE
    replacement of the defstruct header + docstring + slot (unique by the
    docstring), and the l.538 edit is anchored on the %make-ml0-subject call
    head + the following line (l.1257's `:fixture-row fixture-row` in
    make-ml0-bundle is a different text, and the 8-space form is unique, but
    the anchor is kept for the audit trail).  ml0-bundle is untouched."""
    text = replace_once(text, DEFSTRUCT_511_514, DEFSTRUCT_511_514_NEW,
                        "M1-U/1+2 BOA constructor key + slot (l.511,514), "
                        "anchored on the ml0-subject docstring")
    text = replace_once(text, MAKE_537_539, MAKE_537_539_NEW,
                        "M1-U/3 constructor argument (l.538), anchored on "
                        "%make-ml0-subject (l.537)")
    return text


def mut_m2(text, newargs, label):
    return replace_once(
        text,
        "(defun ml0-evidence-projection-digest (evidence)",
        "(defun ml0-evidence-projection-digest %s" % newargs,
        label)


# ------------------------------------------------------------------------ main
def main():
    argv = sys.argv[1:]
    pinned = os.environ.get("P10_PINNED")
    gitrepo = os.environ.get("P10_LAB_REPO")
    pos = []
    i = 0
    while i < len(argv):
        if argv[i] == "--pinned":
            pinned = argv[i + 1]; i += 2
        elif argv[i] == "--git-repo":
            gitrepo = argv[i + 1]; i += 2
        else:
            pos.append(argv[i]); i += 1
    if len(pos) != 2:
        sys.stderr.write(__doc__)
        sys.exit(2)
    case, root = pos[0], os.path.abspath(pos[1])
    if case not in CASES:
        die("unknown case %r (known: %s)" % (case, " ".join(sorted(CASES))))

    target = os.path.join(root, REL)
    if not os.path.isfile(target):
        die("subject file not found: %s" % target)
    diff_path = os.path.join(root, "MUTATION-DIFF.txt")

    with open(target, "rb") as f:
        before = f.read()
    kind = CASES[case]

    if kind is None:
        with open(diff_path, "w") as f:
            f.write("")
        sys.stdout.write("mutate.py: %s: none (unmutated subject); wrote empty "
                         "%s\n" % (case, diff_path))
        return 0

    # ---- pristine, two routes
    prov = None
    pristine = None
    if gitrepo and os.path.isdir(os.path.join(gitrepo, ".git")):
        try:
            pristine = subprocess.check_output(
                ["git", "-C", gitrepo, "show", "%s:%s" % (COMMIT, GIT_PATH)])
            prov = ("git show %s:%s  (repo %s)" % (COMMIT[:9], GIT_PATH, gitrepo))
        except subprocess.CalledProcessError as e:
            sys.stdout.write("mutate.py: git show unavailable (%s); "
                             "falling back to the pinned-sha route\n" % e)
    if pristine is not None and pristine != before:
        die("pristine from git differs from the subject's pre-mutation file "
            "(git %s vs subject %s)"
            % (sha256_bytes(pristine)[:12], sha256_bytes(before)[:12]))
    if pristine is None:
        if not pinned or not os.path.isfile(pinned):
            die("no pristine route: git repo unusable and pinned list %r absent"
                % pinned)
        want = None
        for line in open(pinned):
            parts = line.split()
            if len(parts) == 2 and parts[1] == REL:
                want = parts[0]
        if want is None:
            die("pinned list %s has no row for %s" % (pinned, REL))
        got = sha256_bytes(before)
        if got != want:
            die("pre-mutation subject file sha256 %s != pinned %s" % (got, want))
        pristine = before
        prov = ("pre-mutation copy of the subject's own file, sha256 %s "
                "asserted equal to the pinned row in %s" % (got, pinned))
    sys.stdout.write("mutate.py: PRISTINE PROVENANCE: %s\n" % prov)

    text = pristine.decode("utf-8")
    if kind == "M1-C":
        new = mut_m1_c(text)
    elif kind == "M1-U":
        new = mut_m1_u(text)
    elif kind == "M2-P":
        new = mut_m2(text, "(evidence &key defect)", "M2-P lambda list (l.3095)")
    elif kind == "M2-X":
        new = mut_m2(text, "(evidence extra)", "M2-X lambda list (l.3095)")
    else:
        die("internal: unhandled kind %r" % kind)
    if new == text:
        die("mutation produced no change")

    nb = new.encode("utf-8")
    with open(target, "wb") as f:
        f.write(nb)

    diff = list(difflib.unified_diff(
        text.splitlines(True), new.splitlines(True),
        fromfile="a/%s (pristine)" % REL, tofile="b/%s (%s)" % (REL, case),
        n=3))
    with open(diff_path, "w") as f:
        f.write("# P10 REAL GATE /0 mutation diff\n")
        f.write("# case: %s   mutation: %s\n" % (case, kind))
        f.write("# subject root: %s\n" % root)
        f.write("# pristine provenance: %s\n" % prov)
        f.write("# pristine sha256: %s\n" % sha256_bytes(pristine))
        f.write("# mutated  sha256: %s\n" % sha256_bytes(nb))
        f.writelines(diff)
    sys.stdout.write("mutate.py: %s: applied %s; mutated sha256 %s; diff -> %s\n"
                     % (case, kind, sha256_bytes(nb), diff_path))
    return 0


if __name__ == "__main__":
    sys.exit(main())
