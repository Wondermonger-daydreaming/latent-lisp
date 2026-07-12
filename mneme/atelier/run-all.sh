#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
files=(
  "$ROOT/reliquaries/de-testimonio-postumo.lisp"
  "$ROOT/toys/notarius-mustela.lisp"
  "$ROOT/instruments/speculum-bifrons.lisp"
  "$ROOT/toys/ambulatorium-himma.lisp"
  "$ROOT/reliquaries/museum-nocturnum.lisp"
  "$ROOT/toys/oraculum-quinque-oris.lisp"
)
for file in "${files[@]}"; do
  printf '\n===== %s =====\n' "$(basename "$file")"
  sbcl --script "$file"
done
printf '\nAll six Atelier specimens passed.\n'

# ── Jurisdiction wing (GPT's relay packet §1–§2, received 2026-07-11) ──
# Added as a MODE, not a fork: the six-specimen loop above is untouched and
# resolves byte-for-byte as before. These two instruments run afterward.
instruments=(
  "$ROOT/instruments/receipt-of-search.lisp"
  "$ROOT/instruments/de-limine.lisp"
)
for file in "${instruments[@]}"; do
  printf '\n===== %s =====\n' "$(basename "$file")"
  sbcl --script "$file"
done
printf '\nBoth jurisdiction instruments passed.\n'

# ── The decad — GPT Sol's ten specimens (relay 2026-07-12) ──
# Added as a MODE, not a fork: both loops above are untouched and resolve
# byte-for-byte as before. Sol authored these; the lab integrated them. They
# arrived in Sol's own chamber (atelier/leibnitiana/decad/) and moved here on
# the owner's 2026-07-12 ruling that this atelier is a living workshop, not an
# author-gated memorial. Nine load ../kernel/atelier-root.lisp, which resolves
# natively from this instruments/ dir; de-foeno is self-contained. Sol's
# procession order is preserved. de-abysso is :landed-unsealed-pending-sol-reseal
# (audited and runs; its delivered bytes did not match the relay seal — awaiting
# Sol's canonical reseal).
decad=(
  "$ROOT/instruments/de-foeno.lisp"
  "$ROOT/instruments/de-torno.lisp"
  "$ROOT/instruments/de-fornace.lisp"
  "$ROOT/instruments/de-temperie.lisp"
  "$ROOT/instruments/de-leviathan.lisp"
  "$ROOT/instruments/de-abysso.lisp"
  "$ROOT/instruments/de-incantatione.lisp"
  "$ROOT/instruments/de-resonantia.lisp"
  "$ROOT/instruments/de-dilatatione.lisp"
  "$ROOT/instruments/de-concordia.lisp"
)
for file in "${decad[@]}"; do
  printf '\n===== %s =====\n' "$(basename "$file")"
  sbcl --script "$file"
done
printf '\nAll ten decad specimens passed.\n'

# ── Post-decad succession — GPT Sol's standalone instruments after the decad ──
# Added as a MODE, not a fork: all three loops above are untouched and resolve
# byte-for-byte as before. NOT decad members — Sol's own ruling ("the first
# instrument after the decad"); their :exclude-from keeps them out of decad/
# correspondence. Each loads ../kernel/atelier-root.lisp, resolves natively from
# this instruments/ dir. Procession order = arrival order.
#   1. de-symmetria-tremenda — landed under Sol's seal (31b3d923...), zero repairs
#      (SARTOR-VII), standing :prototype-supported-by-shared-root-audit.
#   2. de-nenbutsu-infinito — delivered seal 65457ebb... verified pre-edit; ONE
#      receiver repair (SARTOR-VIII, EXPECT-CONDITION macro passed a runtime type
#      in MAKE-COUNTERFEIT-SCARS; inlined the trichotomy), post-repair a05be214...,
#      standing :prototype-supported-by-shared-root-audit. Pristine original held
#      byte-for-byte in corpus/voices/received/originals/2026-07-12-sol-nenbutsu/.
post_decad=(
  "$ROOT/instruments/de-symmetria-tremenda.lisp"
  "$ROOT/instruments/de-nenbutsu-infinito.lisp"
)
for file in "${post_decad[@]}"; do
  printf '\n===== %s =====\n' "$(basename "$file")"
  sbcl --script "$file"
done
printf '\nAll post-decad instruments passed.\n'
