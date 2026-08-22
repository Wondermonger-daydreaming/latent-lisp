;; P5 — "xenobiological-quarantine" — the NON-AUTHOR holdout program.
;; Authored by Sol (GPT-5.6) from the P5 packet (AUTHOR-GUIDE + arm/seat addendum)
;; alone; received 2026-08-10; reproduced VERBATIM per the frozen protocol
;; (notes/2026-08-10-p5-sol-inhabitation-protocol.md, commit d1f640e4). The chair
;; edited NOTHING below this line.

(ma0-program
 (:name "p5-xenobiological-quarantine")
 (:input (probe-name))
 (:authority-slots
  (accession-grant containment-grant assay-grant sterilization-grant))
 (:steps
  (bind quarantine-dossier
        (list (ref probe-name)
              "subglacial-ocean-sample"
              :pending-clearance))

  (act accession
        (:arm "A")
        (:authority-slot accession-grant))

  (act containment
        (:arm "B-L1")
        (:authority-slot containment-grant))

  (act biosignature-assay
        (:arm "C-i")
        (:authority-slot assay-grant))

  (derive assay-record
          (:seat "assay-seat"))

  (branch assay-record
    ((:and (:execution :reconciled)
           (:evidence-class :reconciled))
     (refuse
      (:code :earth-entry-quarantined)
      (list (ref quarantine-dossier)
            (field assay-record :execution)
            (field assay-record :evidence-class))))

    (otherwise
     (act sterilization
           (:arm "D")
           (:authority-slot sterilization-grant))
     (result
      (list (ref quarantine-dossier)
            :sterilization-attempted))))))
