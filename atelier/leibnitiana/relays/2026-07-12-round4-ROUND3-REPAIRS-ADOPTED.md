# Round-three repairs adopted into round four

1. `+receipt-genesis-hash+` now uses the reload-safe EQL idiom for a string
   `defconstant`. `tests/reload-provenance.lisp` loads the provenance source twice
   in one image and requires object identity to survive.
2. `storms/tampered-receipt.lisp` now performs the advertised naïve in-place edit
   and requires `:event-hash-mismatch` before proceeding to the fully rechained
   forgery.

The repair count remains two. Round four does not rewrite the record into a false
zero merely because both defects are now covered.
