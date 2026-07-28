#!/usr/bin/env bash
#
# subject-digest.sh — the CONTENT-DERIVED identity of Language Surface /1's subject.
#
# ERRATA 0.3 / D6.  The stranger audit (FOSSOR §6, F6) showed the evidence wearing a
# nametag that was not its own: `git rev-parse HEAD` labelled two materially
# different subjects with one SHA, and the transcripts came out byte-identical.  A
# commit id answers "what was last committed here".  This answers "what is in these
# files", which is the only question a piece of evidence is entitled to have
# answered for it.
#
# USAGE
#   subject-digest.sh                 -> the 64-hex digest, one line
#   subject-digest.sh --short         -> the first 16 hex, one line (the form bound
#                                        into the instruments' canonical result lines)
#   subject-digest.sh --render        -> the exact byte rendering that is hashed
#   subject-digest.sh --explain       -> rendering + digest + framing note
#   any mode may be followed by an explicit SUBJECT DIRECTORY; the default is the
#   parent of the directory holding this script.
#
# IT DOES NOT USE GIT, AND MUST NOT.  It runs in a bare copy of the tree, outside any
# checkout, with no remote, on a dirty working tree — those are the ordinary
# conditions of an audit (the runner writes tracked transcripts, so an auditor is
# TOLD to work in a writable scratch copy), and they are exactly the conditions under
# which the old label lied.
#
# THE FRAMING, AND WHY IT IS SHAPED LIKE THIS.
#   rendering := "SURFACE1-SUBJECT-DIGEST-V1\n"
#                "members " <count> "\n"
#                for each member, sorted LC_ALL=C by path:
#                    <64 lowercase hex> "  " <path> "\n"
#   digest    := sha256(rendering)
#
#   The digest field is FIXED WIDTH (64) and the separator is exactly two spaces, so
#   the boundary between hash and path needs no escaping and cannot be forged by a
#   path that contains hex.  The path is terminated by a newline and is constrained
#   (below) to a character set that excludes whitespace and newline, so no path can
#   impersonate a line break.  The member COUNT is bound into the rendering, so a
#   truncated rendering cannot impersonate a shorter manifest.  Nowhere are two
#   variable-length fields concatenated raw: the classic `"ab"+"c"` == `"a"+"bc"`
#   collision has no seam to live in here.
#
# HARD FAILURES (exit 2, no digest on stdout — a digest is never guessed):
#   manifest absent · manifest empty · member absent or unreadable · duplicate
#   member · path outside the allowed character set · a member that names one of the
#   runner's own generated transcripts (a digest must not depend on the evidence it
#   labels) · no SHA-256 tool on the host.

set -uo pipefail

PROG="$(basename "$0")"
die() { printf '%s: HARD FAIL — %s\n' "$PROG" "$*" >&2; exit 2; }

MODE="digest"
case "${1:-}" in
  --short)   MODE="short";   shift ;;
  --render)  MODE="render";  shift ;;
  --explain) MODE="explain"; shift ;;
  --help|-h) sed -n '2,50p' "$0"; exit 0 ;;
  --*)       die "unknown option: $1" ;;
esac

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" || die "cannot locate this script"
SUBJECT="${1:-$(dirname "$HERE")}"
[ -d "$SUBJECT" ] || die "subject directory does not exist: $SUBJECT"
SUBJECT="$(cd "$SUBJECT" && pwd)"

MANIFEST="$HERE/SUBJECT-MANIFEST.txt"
[ -f "$MANIFEST" ] || die "manifest absent: $MANIFEST"

# The SHA-256 tool.  Independent of the subject on purpose: a subject that computed
# its own digest could rename itself.
if   command -v sha256sum >/dev/null 2>&1; then HASH() { sha256sum "$1" | cut -d' ' -f1; }
elif command -v shasum    >/dev/null 2>&1; then HASH() { shasum -a 256 "$1" | cut -d' ' -f1; }
elif command -v python3   >/dev/null 2>&1; then
  HASH() { python3 -c 'import hashlib,sys;print(hashlib.sha256(open(sys.argv[1],"rb").read()).hexdigest())' "$1"; }
else die "no SHA-256 tool on this host (sha256sum, shasum, python3 all absent)"; fi

HASH_STDIN() {
  if   command -v sha256sum >/dev/null 2>&1; then sha256sum | cut -d' ' -f1
  elif command -v shasum    >/dev/null 2>&1; then shasum -a 256 | cut -d' ' -f1
  else python3 -c 'import hashlib,sys;print(hashlib.sha256(sys.stdin.buffer.read()).hexdigest())'; fi
}

# The runner's own outputs, by EXACT RELATIVE PATH.  Never by basename: a file named
# RUN-SELFTEST.txt somewhere else in the closure is a DIFFERENT FILE, and excluding
# it by name would silently drop a real input.  (This lane has a scar from a
# basename exclusion; the scar is why this list is spelled out.)
GENERATED="RUN-SELFTEST.txt
RUN-STUB-IMAGE.txt
RUN-APPLICATION.txt
RUN-REPRODUCTION.txt
RUN-REPRODUCTION-II.txt
RUN-REPRODUCTION-III.txt
RUN-EXITCODES.txt"

# --- read the manifest -----------------------------------------------------
MEMBERS=()
while IFS= read -r raw || [ -n "$raw" ]; do
  line="${raw%%$'\r'}"
  case "$line" in ''|'#'*) continue ;; esac
  case "$line" in *[[:space:]]*) die "manifest path contains whitespace: [$line]" ;; esac
  if ! printf '%s' "$line" | grep -qE '^[A-Za-z0-9._/-]+$'; then
    die "manifest path outside the allowed character set: [$line]"
  fi
  while IFS= read -r g; do
    [ "$line" = "$g" ] && die "manifest names a GENERATED TRANSCRIPT: $line"
  done <<< "$GENERATED"
  MEMBERS+=("$line")
done < "$MANIFEST"

[ "${#MEMBERS[@]}" -gt 0 ] || die "manifest declares no members"

# --- sort, detect duplicates, verify presence ------------------------------
SORTED="$(printf '%s\n' "${MEMBERS[@]}" | LC_ALL=C sort)"
DUPES="$(printf '%s\n' "$SORTED" | LC_ALL=C uniq -d)"
[ -z "$DUPES" ] || die "duplicate manifest member(s): $(printf '%s' "$DUPES" | tr '\n' ' ')"

RENDER="SURFACE1-SUBJECT-DIGEST-V1
members ${#MEMBERS[@]}"

while IFS= read -r rel; do
  abs="$SUBJECT/$rel"
  [ -e "$abs" ] || die "manifest member ABSENT from the subject: $rel"
  [ -f "$abs" ] || die "manifest member is not a regular file: $rel"
  [ -r "$abs" ] || die "manifest member is not readable: $rel"
  h="$(HASH "$abs")" || die "hashing failed: $rel"
  [ "${#h}" -eq 64 ] || die "hash of $rel is not 64 hex characters: [$h]"
  RENDER="$RENDER
$h  $rel"
done <<< "$SORTED"

DIGEST="$(printf '%s\n' "$RENDER" | HASH_STDIN)"
[ "${#DIGEST}" -eq 64 ] || die "computed digest is not 64 hex characters"

case "$MODE" in
  digest)  printf '%s\n' "$DIGEST" ;;
  short)   printf '%s\n' "${DIGEST:0:16}" ;;
  render)  printf '%s\n' "$RENDER" ;;
  explain)
    printf '%s\n' "$RENDER"
    printf '\nsha256(the %d bytes above, newline-terminated) = %s\n' \
           "$(printf '%s\n' "$RENDER" | wc -c)" "$DIGEST"
    printf 'short form bound into canonical result lines: subject=%s\n' "${DIGEST:0:16}"
    printf 'subject directory: %s\n' "$SUBJECT"
    printf 'THIS MEASURES THE LAYER UNDER TEST.  It does not measure the instruments,\n'
    printf 'the transcripts, the host, or the image.  It is not an authentication:\n'
    printf 'it says WHICH BYTES, never that those bytes are the right ones.\n'
    ;;
esac
exit 0
