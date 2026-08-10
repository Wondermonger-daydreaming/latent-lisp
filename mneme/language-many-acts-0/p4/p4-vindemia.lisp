;; P4 — "vindemia" (the harvest) — the post-R1-freeze holdout program.
;; Authored by the chair from AUTHOR-GUIDE.md and the exported API alone, AFTER the R1
;; freeze (campaign log: frozen at 231873c7, freeze commit 9bff7d02). Pure data.
;;
;; Domain (fourth): a vintage. Three plots are worked in sequence — the north plot
;; yields cleanly (A); the east plot is lost to frost, its act refused before the
;; frontier, and the harvest SEQUENCES PAST the loss without branching on it (the
;; refusal is a fact of the year, not a decision point); the south plot's cart crosses
;; but its receipt is lost (C-ii), and the cellar's derived record shows the
;; uncertainty stood and was adjudicated. The pressing decision is gated on the
;; CELLAR'S RECORD, never on any act's return: an adjudicated-uncertain south plot
;; withholds the vintage. The press (arm D) is fully warranted and sits in the branch
;; arm the evidence law makes unreachable — its non-execution is the program's doing.
;; The north plot's standing, read from derived evidence, travels as ordinary data
;; into the withholding notice: the year's one good plot is named in the refusal.

(ma0-program (:name "vindemia")
  (:input (vintner))
  (:authority-slots (north-warrant east-warrant south-warrant press-warrant))
  (:steps
    (act plot-north (:arm "A") (:authority-slot north-warrant))
    (derive north-evidence (:seat "s-north"))
    (bind north-standing (field north-evidence :execution))
    (act plot-east (:arm "B-L1") (:authority-slot east-warrant))
    (act plot-south (:arm "C-ii") (:authority-slot south-warrant))
    (derive south-evidence (:seat "s-south"))
    (branch south-evidence
      ((:and (:execution :reconciled) (:evidence-class :reconciled))
       (refuse (:code :vintage-withheld) (list (ref vintner) (ref north-standing))))
      ((:and (:execution :settled) (:evidence-class :none))
       (act press (:arm "D") (:authority-slot press-warrant))
       (result (list "pressed" (ref vintner) (ref north-standing))))
      (otherwise
       (refuse (:code :cellar-unreadable) (ref vintner))))))
