;;;; mutants.lisp — §28 planted negative controls (defective validators).
;;;;
;;;; These six defects are THIS implementation's own planted mutants, written
;;;; from §28's normative mode list; the reference tool's implementations of
;;;; the same six modes were never opened (ALLOWED-SOURCES Class B — that
;;;; independence is the point).  PJ-MUT-1: every planted mutant MUST be
;;;; killed by at least one frozen fixture.  A suite that certifies both the
;;;; strict validator and the matching defective validator is decorative
;;;; furniture.
;;;;
;;;; Each defect lives at exactly one named check site in reader.lisp
;;;; (*VALIDATOR-DEFECT* dispatch):
;;;;   :ignore-payload-hash       — skips §12 step 8
;;;;   :ignore-prev-chain         — skips §12 step 9
;;;;   :accept-noncanonical       — skips §12 step 13 byte identity
;;;;   :interior-as-tail          — downgrades §13.3 corruption to torn tail
;;;;   :duplicate-last-write-wins — accepts a duplicate committed identity
;;;;   :ignore-ordinal            — skips §12 step 5 continuity

(in-package #:lisp-plus-journal0)

(defvar +planted-defects+
  '(:ignore-payload-hash
    :ignore-prev-chain
    :accept-noncanonical
    :interior-as-tail
    :duplicate-last-write-wins
    :ignore-ordinal))

(defun run-mutant-kill (defect fixture-octets store-id-string)
  "Run the strict validator and the DEFECT validator over the same fixture
bytes.  Returns (values killed-p strict-status mutant-status): KILLED-P is
true exactly when the mutant DISAGREES with the strict result (PJ-MUT-2's
expected disagreement)."
  (let ((strict (validate-event-octets fixture-octets store-id-string
                                       :defect nil))
        (mutant (validate-event-octets fixture-octets store-id-string
                                       :defect defect)))
    (values (not (and (eq (prefix-report-status strict)
                          (prefix-report-status mutant))
                      (= (prefix-report-frame-count strict)
                         (prefix-report-frame-count mutant))))
            (prefix-report-status strict)
            (prefix-report-status mutant))))
