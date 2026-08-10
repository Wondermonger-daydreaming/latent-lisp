;; P3 — "peregrinatio" (border-crossing itinerary) — the post-freeze holdout program.
;; Authored by the chair against AUTHOR-GUIDE.md and the exported API ALONE, after the
;; implementation freeze (campaign log: frozen at dfafddad). One S-expression, pure data.
;;
;; Domain (third): a journey with three legs. A safe-conduct is granted (A); a shortcut
;; is attempted and lawfully REFUSED, which the itinerary treats as information — take
;; the long road — not as a halt (B-L2); the luggage cart crosses but its receipt is
;; lost (C-ii), and the derived record shows an uncertainty stood and was adjudicated.
;; The itinerary then refuses to declare arrival: no feast. The feast (arm D) sits in
;; the branch arm the evidence law makes unreachable, with its authority fully granted —
;; so if it does not run, that is the program's branching, nothing else.

(ma0-program (:name "peregrinatio")
  (:input (traveler))
  (:authority-slots (viaticum-road viaticum-shortcut viaticum-cart viaticum-feast))
  (:steps
    (act safe-conduct (:arm "A") (:authority-slot viaticum-road))
    (act shortcut (:arm "B-L2") (:authority-slot viaticum-shortcut))
    (branch shortcut
      ((:disposition :refused)
       (act luggage (:arm "C-ii") (:authority-slot viaticum-cart))
       (derive luggage-evidence (:seat "s-luggage"))
       (branch luggage-evidence
         ((:and (:execution :reconciled) (:evidence-class :reconciled))
          (refuse (:code :luggage-unsettled-no-arrival) (ref traveler)))
         ((:and (:execution :settled) (:evidence-class :none))
          (act feast (:arm "D") (:authority-slot viaticum-feast))
          (result (list "arrived" (ref traveler))))
         (otherwise
          (refuse (:code :unreadable-luggage-evidence) (ref traveler)))))
      (otherwise
       (refuse (:code :shortcut-unexpectedly-permitted) (ref traveler))))))
