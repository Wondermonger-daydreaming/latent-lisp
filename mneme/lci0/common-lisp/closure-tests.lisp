(in-package #:cl-user)

;;;; Permanent regression witnesses for the ten LCI/0 authorial closures
;;;; (LCI0-AC-001 .. LCI0-AC-010).  Loaded by run-tests.lisp after tests.lisp
;;;; (it reuses that file's LCI0-CHECK counters and record helpers).  The
;;;; installed fixture root must carry the 0.2 fixture-authority overlay.
;;;;
;;;; The fifty successor vectors are the acceptance surface; every formerly
;;;; blocked coordinate they witness is executed here, together with the four
;;;; register-only closures (LCI0-AC-005/-006/-008/-009) whose exact tuples
;;;; the overlay's closure records instantiate.

(defun %closure-fixture-root ()
  lisp-plus-lci0::*fixture-root*)

(defun run-lci0-closure-regression-tests ()
  (setf *lci0-test-passes* 0 *lci0-test-failures* 0 *lci0-test-blocked* 0)

  ;; -------------------------------------------------------------------------
  ;; The fifty-vector acceptance surface (LCI0-ACV-ORIG-001..004,
  ;; LCI0-ACV-REL-001..038, LCI0-ACV-HOSTILE-001..008): 4 superseded
  ;; originals, 38 ruled relation companions (LCI0-AC-002), 8 retained
  ;; hostile requests (LCI0-AC-005, LCI0-AC-007).
  (lci0-check "all-fifty-successor-closure-vectors-pass"
    (multiple-value-bind (ok passed total)
        (lisp-plus-lci0:run-closure-vectors (%closure-fixture-root) nil)
      (and ok (= passed 50) (= total 50))))

  ;; The overlay itself: digest-verified, exactly four supersession keys,
  ;; and all four register-only closure records present.
  (lci0-check "overlay-0.2-loads-with-exactly-the-ruled-member-census"
    (let ((overlay (lisp-plus-lci0:load-fixture-overlay
                    (%closure-fixture-root))))
      (and overlay
           (= 4 (hash-table-count
                 (lisp-plus-lci0::fixture-overlay-supersessions overlay)))
           (= 38 (hash-table-count
                  (lisp-plus-lci0::fixture-overlay-relation-failures overlay)))
           (= 8 (hash-table-count
                 (lisp-plus-lci0::fixture-overlay-hostile overlay)))
           (every (lambda (closure-id)
                    (nth-value
                     1 (gethash closure-id
                                (lisp-plus-lci0::fixture-overlay-closure-records
                                 overlay))))
                  '("LCI0-AC-005-POLICY-EVALUATION-ORDER"
                    "LCI0-AC-006-CORPUS-BASIS-COHERENCE"
                    "LCI0-AC-008-MIGRATION-CLASSIFICATION"
                    "LCI0-AC-009-TARGET-BOUNDARY-COHERENCE")))))

  ;; -------------------------------------------------------------------------
  ;; LCI0-AC-001: both frozen scope rows stay wider/narrower on the direct
  ;; engine (entries/11 and entries/143 of scope_relation_table_0), while the
  ;; matcher-level symbolic guard preserves N012's frozen ScopeRelationUnknown
  ;; failure without consulting either policy.
  (let ((row-11 nil) (row-143 nil) (count 0))
    (lisp-plus-lci0::map-registry-relation-entries
     (%closure-fixture-root) "scope_relation_table_0"
     (lambda (entry)
       (when (= count 11)
         (setf row-11 (lisp-plus-lci0:fixture-json-to-datum
                       (lisp-plus-lci0::jget entry "abstract_cd0"))))
       (when (= count 143)
         (setf row-143 (lisp-plus-lci0:fixture-json-to-datum
                        (lisp-plus-lci0::jget entry "abstract_cd0"))))
       (incf count)))
    (flet ((direct (row)
             (lisp-plus-lci0::identifier-last
              (lisp-plus-lci0:scope-relation
               (lisp-plus-lci0::record-field-named row "left-scope")
               (lisp-plus-lci0::record-field-named row "right-scope")))))
      (lci0-check "ac-001-direct-scope-relation-agrees-with-frozen-rows"
        (and row-11 row-143
             (string= (direct row-11) "wider")
             (string= (direct row-143) "narrower")))))
  (let* ((payload (lci0-vector-payload "LCI0-N012"))
         (consultations nil)
         (original (symbol-function 'lisp-plus-lci0:evaluate-fixture-policy))
         (condition
           (unwind-protect
                (progn
                  (setf (symbol-function
                         'lisp-plus-lci0:evaluate-fixture-policy)
                        (lambda (&rest arguments)
                          (push arguments consultations)
                          (apply original arguments)))
                  (lci0-capture-refusal
                   (lambda ()
                     (lci0-execute-operation "match-target" payload))))
             (setf (symbol-function 'lisp-plus-lci0:evaluate-fixture-policy)
                   original))))
    (lci0-check "ac-001-n012-matcher-guard-fails-before-any-policy"
      (and condition
           (string= (lisp-plus-lci0:lci-failure-category condition)
                    "relation-undetermined")
           (string= (lisp-plus-lci0:lci-failure-code condition)
                    "ScopeRelationUnknown")
           (string= (lisp-plus-lci0:lci-failure-stage condition)
                    "target-relation")
           (equal (lisp-plus-lci0:lci-failure-path condition)
                  '("claim" "location" "scope"))
           (null consultations))))

  ;; -------------------------------------------------------------------------
  ;; LCI0-AC-005: Policy-A is consulted before Policy-B, and both are
  ;; consulted, on the official two-policy operation.
  (let* ((payload (lci0-vector-payload "LCI0-P022"))
         (order nil)
         (original (symbol-function 'lisp-plus-lci0:evaluate-fixture-policy)))
    (unwind-protect
         (progn
           (setf (symbol-function 'lisp-plus-lci0:evaluate-fixture-policy)
                 (lambda (policy relation &rest arguments)
                   (push (lisp-plus-lci0::%fixture-policy-letter policy) order)
                   (apply original policy relation arguments)))
           (lci0-execute-operation "evaluate-admissibility-under-two-policies"
                                   payload))
      (setf (symbol-function 'lisp-plus-lci0:evaluate-fixture-policy)
            original))
    (lci0-check "ac-005-policy-a-consulted-then-policy-b"
      (equal (reverse order) '("a" "b"))))

  ;; -------------------------------------------------------------------------
  ;; LCI0-AC-008: the retained classification-only mutation of
  ;; migration-result.inert-predecessor (classification rewritten to the
  ;; registered exact-after-explicit-tagging) is rejected with the exact
  ;; ruled tuple; the untouched fixture and the valid exact results remain
  ;; accepted.
  (let* ((inert (lisp-plus-lci0::registry-datum
                 "migration-result.inert-predecessor"))
         (mutated
           (lci0-record-replace
            inert "classification"
            (lisp-plus-lci0::fixture-id "migration-classification"
                                        "exact-after-explicit-tagging")))
         (condition
           (lci0-capture-refusal
            (lambda ()
              (lisp-plus-lci0:validate-migration-result mutated)))))
    (lci0-check "ac-008-classification-content-coupling-exact-tuple"
      (and condition
           (string= (lisp-plus-lci0:lci-failure-category condition)
                    "invalid-input")
           (string= (lisp-plus-lci0:lci-failure-code condition)
                    "InvalidMigrationResult")
           (string= (lisp-plus-lci0:lci-failure-stage condition)
                    "migration-result")
           (equal (lisp-plus-lci0:lci-failure-path condition)
                  '("classification"))
           (let ((context (lisp-plus-lci0:lci-failure-context condition)))
             (and (string= (lisp-plus-cd0:string-datum-value
                            (lisp-plus-lci0::record-field-named
                             context "classification"))
                           "exact-after-explicit-tagging")
                  (string= (lisp-plus-cd0:string-datum-value
                            (lisp-plus-lci0::record-field-named
                             context "incompatible_content_marker"))
                           "inert-predecessor")))))
    (lci0-check "ac-008-untouched-inert-predecessor-result-still-validates"
      (lisp-plus-lci0:lci-value-p
       (lisp-plus-lci0:validate-migration-result inert)))
    (lci0-check "ac-008-valid-exact-results-remain-accepted"
      (every (lambda (fixture-id)
               (lisp-plus-lci0:lci-value-p
                (lisp-plus-lci0:validate-migration-result
                 (lisp-plus-lci0::registry-datum fixture-id))))
             '("migration-result.corpus-r4" "migration-result.scope-tenant-b"
               "migration-result.time-100" "migration-result.time-124"))))

  ;; -------------------------------------------------------------------------
  ;; LCI0-AC-009: the retained premise mutation
  ;; (warrant-target.derived.one-equals-one with premise-claim-ids/0 replaced
  ;; by the valid claim-id.file-alpha-neutral) fails closed on the explicit
  ;; /0 deferral — unsupported-fixture-behavior /
  ;; LCI0-UNSUPPORTED-FIXTURE-BEHAVIOR / fixture at
  ;; /boundaries/premise-claim-ids/0 — never as an adjudicated mismatch and
  ;; never as an LCIFailure/0.  The pinned positive vector is retained.
  (let* ((target (lisp-plus-lci0::registry-datum
                  "warrant-target.derived.one-equals-one"))
         (boundaries (lisp-plus-lci0::record-field-named target "boundaries"))
         (neutral (lisp-plus-lci0::registry-datum "claim-id.file-alpha-neutral"))
         (mutated-boundaries
           (lci0-record-replace boundaries "premise-claim-ids"
                                (lisp-plus-cd0:make-sequence-datum
                                 (list neutral))))
         (mutated
           (lci0-record-replace target "boundaries" mutated-boundaries))
         (condition
           (handler-case
               (progn (lisp-plus-lci0:validate-warrant-target mutated) nil)
             (lisp-plus-lci0::lci-unsupported-fixture-behavior (condition)
               condition)
             (error () nil))))
    (lci0-check "ac-009-premise-mutation-fails-closed-on-the-deferral"
      (and condition
           (not (typep condition 'lisp-plus-lci0:lci-failure))
           (equal (lisp-plus-lci0::lci-unsupported-fixture-behavior-path
                   condition)
                  '("boundaries" "premise-claim-ids" "0"))))
    (lci0-check "ac-009-pinned-derived-positive-target-still-validates"
      (lisp-plus-lci0:lci-value-p
       (lisp-plus-lci0:validate-warrant-target target))))

  ;; -------------------------------------------------------------------------
  ;; LCI0-AC-006 (companion orientation): only the retained r3/r4 witness
  ;; carries the ruled BasisMismatch tuple; the reverse r4-basis/r3-manifest
  ;; orientation keeps the fail-closed InvalidBasis rejection (no inferred
  ;; inverse matrix beyond the declared checks).
  (let* ((r3 (lisp-plus-lci0::registry-datum
              "claim-basis.alpha-r3-all-manifest3"))
         (r4 (lisp-plus-lci0::registry-datum
              "claim-basis.alpha-r4-all-manifest4"))
         (r4-with-r3-boundary
           (lci0-record-replace
            r4 "semantic-boundary"
            (lisp-plus-lci0::record-field-named r3 "semantic-boundary"))))
    (lci0-check "ac-006-reverse-orientation-stays-fail-closed-invalid-basis"
      (string= "InvalidBasis"
               (lci0-refusal-code
                (lambda ()
                  (lisp-plus-lci0:validate-corpus-basis
                   r4-with-r3-boundary))))))

  ;; -------------------------------------------------------------------------
  ;; LCI0-AC-010 (mutation resistance): the defensive copy is a new
  ;; allocation — the operation result is computed from a CD/0 round trip of
  ;; the supplied predecessor, so its canonical octets are identical across
  ;; two executions of the same payload.
  (let* ((payload (lci0-vector-payload "LCI0-P024"))
         (first-run (lci0-execute-operation "revive-inert-occurrence" payload))
         (second-run (lci0-execute-operation "revive-inert-occurrence"
                                             payload)))
    (lci0-check "ac-010-revival-is-deterministic-and-defensively-copied"
      (and (not (eq first-run second-run))
           (lisp-plus-cd0:equal-datum first-run second-run)
           (string=
            (lisp-plus-lci0::octets-to-hex
             (lisp-plus-lci0::canonical-octets first-run))
            (lisp-plus-lci0::octets-to-hex
             (lisp-plus-lci0::canonical-octets second-run))))))

  (format t
          "LCI0 CLOSURE REGRESSION SUMMARY: ~D passed, ~D failed, ~D total~%"
          *lci0-test-passes* *lci0-test-failures*
          (+ *lci0-test-passes* *lci0-test-failures*))
  (zerop *lci0-test-failures*))
