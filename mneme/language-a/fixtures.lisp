;;;; fixtures.lisp — the teeth for validator.lisp (Language A, GPT §3)
;;;;
;;;; Six lawful fixtures that MUST pass validation, and eight malformed fixtures
;;;; that MUST each fire their one declared typed condition. A fixture whose
;;;; expected condition never fires fails the suite. Exit 0 iff every expectation
;;;; is met. This is the conformance walk of the validator — its bricks are proved
;;;; here, over the loaded instrument, not in private civilizations.
;;;;
;;;; Kept SEPARATE from validator.lisp on purpose (the kernel/conformance-walk
;;;; pattern): the validator is a loadable instrument; this file is the executable
;;;; proof that its gates bite. All fixtures are local, synthetic, self-declaring.
;;;;
;;;; SBCL 2.4.6, `sbcl --script fixtures.lisp`, no external dependencies.

(load (merge-pathnames "validator.lisp" *load-truename*))
(in-package #:mneme.language-a)

;;; ── fixture record ───────────────────────────────────────────────────────────
(defstruct fixture name kind expect record)   ; kind :lawful | :malformed
                                               ; expect :valid | <condition-symbol>

;;; ══════════════════════════════════════════════════════════════════════════════
;;; SIX LAWFUL FIXTURES — each must PASS validation
;;; ══════════════════════════════════════════════════════════════════════════════

(defparameter *lawful*
  (list
   (make-fixture
    :name "L1 supported-answer" :kind :lawful :expect :valid
    :record
    '(judgment
      (:id j-l1) (:status :answer)
      (:question "Is 'The Glass Orchard' listed in catalog v3?")
      (:receipts (receipt-17))
      (:claims
       ((claim (:id c-1)
               (:proposition (listed-in "The Glass Orchard" catalog))
               (:standing :observed)
               (:boundary (:corpus catalog) (:version 3)
                          (:procedure exact-title-search) (:as-of "2026-07-11")))))
      (:support ((support (:id s-1) (:faces c-1) (:artifact receipt-17))))
      (:scope (:corpus catalog) (:version 3))
      (:unresolved ()) (:confidence 0.93) (:answer :yes)))

   (make-fixture
    :name "L2 explicit-uncertainty" :kind :lawful :expect :valid
    :record
    '(judgment
      (:id j-l2) (:status :uncertain)
      (:question "Will the reprint arrive before the fair?")
      (:receipts (receipt-22))
      (:claims
       ((claim (:id c-1)
               (:proposition (arrival-scheduled reprint fair-week))
               (:standing :asserted))))
      (:support ((support (:id s-1) (:faces c-1) (:artifact receipt-22))))
      (:unresolved (shipping-confirmation)) (:confidence 0.5) (:answer :undetermined)))

   (make-fixture
    :name "L3 refusal-missing-data" :kind :lawful :expect :valid
    :record
    '(judgment
      (:id j-l3) (:status :refusal)
      (:question "Is the manuscript's author still living?")
      (:receipts ()) (:claims ()) (:support ())
      (:unresolved (author-vital-status source-unavailable))
      (:confidence 0.0) (:answer :refused)))

   (make-fixture
    :name "L4 bounded-absence, completed scope" :kind :lawful :expect :valid
    :record
    '(judgment
      (:id j-l4) (:status :answer)
      (:question "Is 'The Tin Aviary' listed in catalog v4?")
      (:receipts (receipt-88))
      (:claims
       ((claim (:id c-1)
               (:proposition (not-listed-in "The Tin Aviary" catalog))
               (:standing :bounded-absence)
               (:boundary (:corpus catalog) (:version 4)
                          (:procedure exhaustive-scan) (:scope-complete t)
                          (:as-of "2026-07-11")))))
      (:support ((support (:id s-1) (:faces c-1) (:artifact receipt-88))))
      (:scope (:corpus catalog) (:version 4))
      (:unresolved ()) (:confidence 0.98) (:answer :no)))

   (make-fixture
    :name "L5 historical claim, versioned boundary" :kind :lawful :expect :valid
    :record
    '(judgment
      (:id j-l5) (:status :answer)
      (:question "Was 'The Glass Orchard' listed in catalog v1 (2026-01 snapshot)?")
      (:receipts (receipt-03))
      (:claims
       ((claim (:id c-1)
               (:proposition (listed-in "The Glass Orchard" catalog))
               (:standing :observed)
               (:boundary (:corpus catalog) (:version 1)
                          (:procedure exact-title-search) (:as-of "2026-01-15")
                          (:freshness :aging)))))
      (:support ((support (:id s-1) (:faces c-1) (:artifact receipt-03))))
      (:scope (:corpus catalog) (:version 1))
      (:unresolved ()) (:confidence 0.9) (:answer :yes)))

   (make-fixture
    :name "L6 judgment with unresolved residue" :kind :lawful :expect :valid
    :record
    '(judgment
      (:id j-l6) (:status :answer)
      (:question "Does record 5150 describe a first edition?")
      (:receipts (receipt-51))
      (:provenance (:summary-of j-l6-draft) (:prior-unresolved (binding-state plate-count)))
      (:claims
       ((claim (:id c-1)
               (:proposition (edition-of record-5150 first))
               (:standing :observed)
               (:boundary (:corpus rare-books) (:procedure metadata-read) (:as-of "2026-07-11"))
               (:resolves binding-state))))
      (:support ((support (:id s-1) (:faces c-1) (:artifact receipt-51))))
      (:unresolved (plate-count)) (:confidence 0.7) (:answer :probably)))))

;;; ══════════════════════════════════════════════════════════════════════════════
;;; EIGHT MALFORMED FIXTURES — each must fire its ONE declared typed condition
;;; ══════════════════════════════════════════════════════════════════════════════

(defparameter *malformed*
  (list
   (make-fixture
    :name "M1 duplicate IDs" :kind :malformed :expect 'duplicate-id
    :record
    '(judgment
      (:id j-m1) (:status :answer)
      (:receipts (receipt-17))
      (:claims
       ((claim (:id c-1) (:proposition (alpha)) (:standing :asserted))
        (claim (:id c-1) (:proposition (beta))  (:standing :asserted))))
      (:support ()) (:unresolved ()) (:confidence 0.5) (:answer :yes)))

   (make-fixture
    :name "M2 missing claim reference" :kind :malformed :expect 'unresolved-reference
    :record
    '(judgment
      (:id j-m2) (:status :answer)
      (:receipts (receipt-17))
      (:claims ((claim (:id c-1) (:proposition (alpha)) (:standing :asserted))))
      (:support ((support (:id s-1) (:faces c-99) (:artifact receipt-17))))
      (:unresolved ()) (:confidence 0.5) (:answer :yes)))

   (make-fixture
    :name "M3 confidence above 1" :kind :malformed :expect 'invalid-confidence
    :record
    '(judgment
      (:id j-m3) (:status :answer)
      (:receipts (receipt-17))
      (:claims ((claim (:id c-1) (:proposition (alpha)) (:standing :asserted))))
      (:support ((support (:id s-1) (:faces c-1) (:artifact receipt-17))))
      (:unresolved ()) (:confidence 1.4) (:answer :yes)))

   (make-fixture
    :name "M4 historical receipt applied to a later corpus version"
    :kind :malformed :expect 'scope-extension-requested
    :record
    '(judgment
      (:id j-m4) (:status :answer)
      (:question "Is 'The Glass Orchard' listed in catalog v3?")
      (:receipts (receipt-03))
      (:claims
       ((claim (:id c-1)
               (:proposition (listed-in "The Glass Orchard" catalog))
               (:standing :observed)
               (:boundary (:corpus catalog) (:version 1)
                          (:procedure exact-title-search) (:as-of "2026-01-15")))))
      (:support ((support (:id s-1) (:faces c-1) (:artifact receipt-03))))
      (:scope (:corpus catalog) (:version 3))
      (:unresolved ()) (:confidence 0.9) (:answer :yes)))

   (make-fixture
    :name "M5 heuristic retrieval represented as exhaustive"
    :kind :malformed :expect 'missing-boundary
    :record
    '(judgment
      (:id j-m5) (:status :answer)
      (:question "Is 'The Tin Aviary' listed in catalog v4?")
      (:receipts (receipt-90))
      (:claims
       ((claim (:id c-1)
               (:proposition (not-listed-in "The Tin Aviary" catalog))
               (:standing :bounded-absence)
               (:boundary (:corpus catalog) (:version 4)
                          (:procedure (heuristic top-k 10)) (:as-of "2026-07-11")))))
      (:support ((support (:id s-1) (:faces c-1) (:artifact receipt-90))))
      (:scope (:corpus catalog) (:version 4))
      (:unresolved ()) (:confidence 0.6) (:answer :no)))

   (make-fixture
    :name "M6 answer without a declared claim"
    :kind :malformed :expect 'answer-without-claim
    :record
    '(judgment
      (:id j-m6) (:status :answer)
      (:question "Is the book a forgery?")
      (:receipts ()) (:claims ()) (:support ())
      (:unresolved ()) (:confidence 0.8) (:answer :yes)))

   (make-fixture
    :name "M7 externally-verified standing without an external certificate"
    :kind :malformed :expect 'unsupported-standing
    :record
    '(judgment
      (:id j-m7) (:status :answer)
      (:question "Was the provenance externally audited?")
      (:receipts (receipt-77))
      (:claims
       ((claim (:id c-1)
               (:proposition (provenance-audited record-5150))
               (:standing :externally-verified)
               (:boundary (:corpus rare-books) (:procedure audit-read) (:as-of "2026-07-11")))))
      (:support ((support (:id s-1) (:faces c-1) (:artifact receipt-77))))
      (:unresolved ()) (:confidence 0.95) (:answer :yes)))

   (make-fixture
    :name "M8 unresolved field removed during summarization"
    :kind :malformed :expect 'unresolved-field-erasure
    :record
    '(judgment
      (:id j-m8) (:status :answer)
      (:question "Does record 5150 describe a first edition?")
      (:receipts (receipt-51))
      (:provenance (:summary-of j-m8-draft) (:prior-unresolved (binding-state plate-count)))
      (:claims
       ((claim (:id c-1)
               (:proposition (edition-of record-5150 first))
               (:standing :observed)
               (:boundary (:corpus rare-books) (:procedure metadata-read) (:as-of "2026-07-11")))))
      (:support ((support (:id s-1) (:faces c-1) (:artifact receipt-51))))
      (:unresolved ()) (:confidence 0.8) (:answer :probably)))))

;;; ── the runner ───────────────────────────────────────────────────────────────
(defvar *failures* 0)
(defvar *firings* '())   ; (condition-name fixture-name check-label) per malformed fixture

(defun run-lawful (f)
  (handler-case
      (progn (validate-judgment (fixture-record f))
             (format t "  PASS  ~a~28t→ VALID~%" (fixture-name f)))
    (validation-error (c)
      (incf *failures*)
      (format t "  FAIL  ~a~28t→ expected VALID, but ~a signaled ~a~%"
              (fixture-name f) (violated-check c) (type-of c)))))

(defun run-malformed (f)
  (handler-case
      (progn (validate-judgment (fixture-record f))
             (incf *failures*)
             (format t "  FAIL  ~a~48t→ expected ~a, but VALIDATED~%"
                     (fixture-name f) (fixture-expect f)))
    (validation-error (c)
      (cond
        ((typep c (fixture-expect f))
         (push (list (fixture-expect f) (fixture-name f) (violated-check c)) *firings*)
         (format t "  PASS  ~a~48t→ fired ~a~%" (fixture-name f) (type-of c)))
        (t
         (incf *failures*)
         (format t "  FAIL  ~a~48t→ expected ~a, fired ~a (~a)~%"
                 (fixture-name f) (fixture-expect f) (type-of c) (violated-check c)))))))

(defparameter *all-conditions*
  '(duplicate-id unresolved-reference missing-boundary unsupported-standing
    answer-without-claim invalid-confidence scope-extension-requested
    unresolved-field-erasure)
  "The eight typed conditions the suite must demonstrate firing.")

(format t "~%══════════════════════════════════════════════════════════════════════~%")
(format t "  FIXTURE SUITE — the twelve checks bite~%")
(format t "══════════════════════════════════════════════════════════════════════~%")

(format t "~%SIX LAWFUL FIXTURES (must validate):~%")
(dolist (f *lawful*) (run-lawful f))

(format t "~%EIGHT MALFORMED FIXTURES (must each fire their declared condition):~%")
(dolist (f *malformed*) (run-malformed f))

;;; ── the explicit condition → fixture firing map ──────────────────────────────
(format t "~%──────────────────────────────────────────────────────────────────────~%")
(format t "  TYPED CONDITION → FIXTURE THAT FIRED IT (→ CHECK)~%")
(format t "──────────────────────────────────────────────────────────────────────~%")
(let ((uncovered '()))
  (dolist (cond-name *all-conditions*)
    (let ((firing (find cond-name *firings* :key #'first)))
      (if firing
          (format t "  ~a~30t← ~a~%~34t[~a]~%"
                  cond-name (second firing) (third firing))
          (progn (push cond-name uncovered)
                 (incf *failures*)
                 (format t "  ~a~30t← *** NEVER FIRED — coverage gap ***~%" cond-name)))))
  (format t "~%  ~a/8 typed conditions demonstrated firing.~%"
          (- 8 (length uncovered))))

;;; ── verdict ──────────────────────────────────────────────────────────────────
(format t "~%──────────────────────────────────────────────────────────────────────~%")
(if (zerop *failures*)
    (progn
      (format t "  SUITE PASSED — 6/6 lawful validated · 8/8 malformed fired · 8/8 conditions covered.~%")
      (format t "  (Coherence proven. Truth NOT — see the four refusals above. The seam is relocated,~%")
      (format t "   not closed: a lying author can still emit a record that passes every line here.)~%")
      (format t "──────────────────────────────────────────────────────────────────────~%")
      (sb-ext:exit :code 0))
    (progn
      (format t "  SUITE FAILED — ~a unmet expectation(s).~%" *failures*)
      (format t "──────────────────────────────────────────────────────────────────────~%")
      (sb-ext:exit :code 1)))
