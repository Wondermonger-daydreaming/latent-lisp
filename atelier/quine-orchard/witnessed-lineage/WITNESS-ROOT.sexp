;;;; WITNESS-ROOT.sexp — the exterior anchor of the witnessed lineage.
;;;;
;;;; This file is NOT part of the specimen. It is the thing the specimen cannot
;;;; rewrite, because the specimen does not contain it and never sees it: the
;;;; artifact family (gen-01.lisp .. gen-05.lisp) carries no copy of H0, cannot
;;;; derive H0 from anything it holds, and therefore cannot verify itself and
;;;; cannot plant its own first generation. Generation 0 is not a file. It is
;;;; this act of witnessing.
;;;;
;;;; Read by:  plant.lisp        (to compute H_1 and emit gen-01.lisp)
;;;;           verify-descent.lisp (to walk the chain forward from the anchor)
;;;;
;;;; A VERIFIER MUST USE ITS OWN INDEPENDENTLY PRESERVED COPY OF THIS FILE.
;;;; A copy shipped alongside the lineage it certifies proves nothing whatever:
;;;; an adversary who supplies both the lineage and its anchor supplies a
;;;; perfectly verifiable forgery. That is demonstrated, executably, as panel D
;;;; of verify-descent.lisp — it is the ceiling of this specimen, not a caveat
;;;; about it.
;;;;
;;;; NOTE ON PUBLICITY, stated rather than hidden: this root is PUBLIC. It is
;;;; the base-31 digest of the phrase in :ROOT-PROVENANCE below, so anyone
;;;; reading this file can recompute it. Publicity and exteriority are different
;;;; axes. Exteriority is what this specimen demonstrates: descent is checked
;;;; against a value the artifact does not hold. A public root still forecloses
;;;; "this lineage descends from some root of my own choosing"; it does NOT
;;;; foreclose "I regrew the whole lineage from your root." Only the :DEPOSITS
;;;; below narrow that, and only for generations they cover.

(:H0 445249790

 :ROOT-PROVENANCE "THE ROOT IS NOT IN THE PLANT"

 ;; Links copied out of the lineage AT THE TIME IT WAS GROWN (2026-07-25) and
 ;; preserved here, outside the artifacts. A deposit is only worth what its
 ;; independence is worth: these were deposited by the same hand that grew the
 ;; lineage, in the same hour, so they demonstrate the MECHANISM (a deposited
 ;; link pins every body up to its generation) and are NOT evidence that this
 ;; particular lineage is authentic. An append-only witness written by someone
 ;; else, at the time, is the real instrument; it is not built here.
 :DEPOSITS ((5 . 490061434)))
