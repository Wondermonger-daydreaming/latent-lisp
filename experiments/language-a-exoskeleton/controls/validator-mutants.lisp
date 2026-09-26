("VM-01-duplicate-id" duplicate-id
 (judgment (:id duplicate) (:status :uncertain)
  (:claims ((claim (:id duplicate) (:standing :asserted)))) (:support ())
  (:unresolved ()) (:confidence 0.5) (:answer :undetermined)))
("VM-02-unresolved-derived-from" unresolved-reference
 (judgment (:id vm-02) (:status :uncertain)
  (:claims ((claim (:id c-1) (:standing :asserted) (:derived-from absent)))) (:support ())
  (:unresolved ()) (:confidence 0.5) (:answer :undetermined)))
("VM-03-invalid-status" unsupported-standing
 (judgment (:id vm-03) (:status :certain) (:claims ()) (:support ())
  (:unresolved ()) (:confidence 0.5) (:answer :undetermined)))
("VM-04-invalid-confidence" invalid-confidence
 (judgment (:id vm-04) (:status :uncertain) (:claims ()) (:support ())
  (:unresolved ()) (:confidence 2.0) (:answer :undetermined)))
("VM-05-missing-boundary" missing-boundary
 (judgment (:id vm-05) (:status :answer)
  (:claims ((claim (:id c-1) (:standing :observed)))) (:support ())
  (:unresolved ()) (:confidence 0.5) (:answer :yes)))
("VM-06-scope-extension" scope-extension-requested
 (judgment (:id vm-06) (:status :answer)
  (:claims ((claim (:id c-1) (:standing :observed)
   (:boundary (:corpus catalog) (:version 1) (:procedure scan) (:as-of "synthetic")))))
  (:support ()) (:scope (:corpus catalog) (:version 2))
  (:unresolved ()) (:confidence 0.5) (:answer :yes)))
("VM-07-residue-erasure" unresolved-field-erasure
 (judgment (:id vm-07) (:status :uncertain)
  (:provenance (:prior-unresolved (missing-field))) (:claims ()) (:support ())
  (:unresolved ()) (:confidence 0.5) (:answer :undetermined)))
("VM-08-answer-without-claim" answer-without-claim
 (judgment (:id vm-08) (:status :answer) (:claims ()) (:support ())
  (:unresolved ()) (:confidence 0.5) (:answer :yes)))
