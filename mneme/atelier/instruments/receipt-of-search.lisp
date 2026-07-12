;;;; receipt-of-search.lisp — The Receipt of Search
;;;; A search returns a value. A receipt says where the search stood when it did.
;;;; Faithful build of GPT's jurisdiction-relay packet §1 (received 2026-07-11).
;;;;
;;;; An empty result describes the return value of a procedure.
;;;; It does not, by itself, describe the contents of the world.
;;;;
;;;; ── WHAT THIS DOES NOT ESTABLISH ─────────────────────────────────────────
;;;; The receipt's own completeness fields (INSPECTED-ITEMS, MISSING-REGIONS,
;;;; normal termination) are TESTIMONY BY THE SAME PROCEDURE THE RECEIPT
;;;; DESCRIBES. This instrument disciplines a COOPERATIVE CALLER: a lying or
;;;; sloppy procedure can mint an honest-looking receipt whose census fields are
;;;; wrong, and MINT-BOUNDED-ABSENCE will admit it. This relocates the forgeable
;;;; seam (from "bare NIL" to "the receipt's self-report"); it does not close it.
;;;; A receipt has no witness for its own census. The digests here are the
;;;; atelier's pedagogical FNV-1a, not cryptographic primitives.
;;;; ─────────────────────────────────────────────────────────────────────────

(eval-when (:compile-toplevel :load-toplevel :execute)
  (load (merge-pathnames "../kernel/atelier-root.lisp" *load-truename*)))
(defpackage #:lispplus-atelier.receipt-of-search
  (:use #:cl #:lispplus-atelier))
(in-package #:lispplus-atelier.receipt-of-search)

(reset-clock 7600)

;;; ── The three structs (packet §1) ───────────────────────────────────────

(defstruct search-scope
  corpus-id corpus-version query-id expected-items)

(defstruct search-receipt
  scope inspected-items status matches missing-regions procedure-id)

;; The raw constructor is hidden. BOUNDED-ABSENCE may be minted ONLY through
;; the lawful constructor MINT-BOUNDED-ABSENCE below.
(defstruct (bounded-absence (:constructor %make-bounded-absence))
  query-id corpus-id corpus-version receipt-id)

;;; ── The six statuses (packet §1) ────────────────────────────────────────
;;;   :found                        a match was found
;;;   :not-found-in-completed-scope no match within a completed finite scope
;;;   :incomplete                   ended before the declared scope was done
;;;   :query-invalid                the query was not valid for the corpus
;;;   :corpus-changed               the corpus changed after the search
;;;   :no-candidate-returned        a heuristic procedure returned no candidates

(defparameter *statuses*
  '(:found :not-found-in-completed-scope :incomplete
    :query-invalid :corpus-changed :no-candidate-returned))

;;; ── The five typed conditions (packet §1) ───────────────────────────────

(define-condition receipt-error (error)
  ((detail :initarg :detail :reader receipt-error-detail :initform ""))
  (:report (lambda (c s) (format s "~a" (receipt-error-detail c)))))

(define-condition incomplete-inspection   (receipt-error) ())
(define-condition query-receipt-mismatch  (receipt-error) ())
(define-condition scope-extension-requested (receipt-error) ())
(define-condition corpus-version-mismatch (receipt-error) ())
(define-condition nonexhaustive-procedure (receipt-error) ())

(defun fire (type control &rest args)
  (error type :detail (apply #'format nil control args)))

;; Teeth-check macro: the named condition must fire. If nothing fires, or the
;; WRONG condition fires, the run fails — a gate never seen biting counts for
;; nothing.
(defmacro expect (type &body body)
  (let ((c (gensym)))
    `(handler-case (progn ,@body
                          (error "expected ~a, but no condition fired" ',type))
       (,type (,c) (format t "   ✓ ~a fired: ~a~%" ',type (receipt-error-detail ,c)) t)
       (receipt-error (,c)
         (error "expected ~a, got ~a" ',type (type-of ,c))))))

;;; ── Miniature synthetic corpora ─────────────────────────────────────────
;;; The target ("The Glass Orchard") sits at index 7 — beyond a first window of 5.

(defparameter *catalog-file-a-v1*
  '((r0 . "Aardvark Almanac")
    (r1 . "Basilisk Bestiary")
    (r2 . "Cartographer's Lament")
    (r3 . "Duskfall Register")
    (r4 . "Ember Catalogue")
    (r5 . "Fenwick's Folios")
    (r6 . "Grackle Gazette")
    (r7 . "The Glass Orchard")     ; present — but only a COMPLETE traversal reaches it
    (r8 . "Hollow Verses")))

;; Version 2 introduces a record absent from version 1.
(defparameter *catalog-file-a-v2*
  (append *catalog-file-a-v1* '((r9 . "The Nonexistent Codex"))))

(defparameter *queries*
  (list (list :id 'q-glass :kind :exact-title :title "The Glass Orchard")
        (list :id 'q-codex :kind :exact-title :title "The Nonexistent Codex")
        (list :id 'q-blank :kind :exact-title :title "")))          ; not valid for the corpus

(defun lookup-query (qid) (find qid *queries* :key (lambda (q) (getf q :id))))

;; Procedure registry: each procedure declares its kind. EXHAUSTIVE census vs
;; HEURISTIC ranking is a TYPE distinction, not a footnote.
(defparameter *procedures*
  '((exhaustive-scan . :exhaustive)   ; a full census when run to completion
    (windowed-scan   . :exhaustive)   ; census-typed, but may stop at a window
    (topk-ranker     . :heuristic)))  ; returns candidates above a threshold, never a census

(defun procedure-kind (pid)
  (or (cdr (assoc pid *procedures*))
      (error "unknown procedure ~a" pid)))

;;; ── The search ─────────────────────────────────────────────────────────

(defun run-search (&key procedure-id query-id corpus-id
                        declared-version live-corpus live-version window)
  "Inspect LIVE-CORPUS and return a SEARCH-RECEIPT. WINDOW, when set, truncates
inspection to a prefix (an incomplete traversal). Never returns bare NIL."
  (let* ((query (lookup-query query-id))
         (kind (procedure-kind procedure-id))
         (expected (length live-corpus))
         (scope (make-search-scope :corpus-id corpus-id
                                   :corpus-version declared-version
                                   :query-id query-id
                                   :expected-items expected)))
    (cond
      ;; the query is not valid for the supplied corpus
      ((or (null query) (string= (getf query :title) ""))
       (make-search-receipt :scope scope :inspected-items 0 :status :query-invalid
                            :matches nil :missing-regions (mapcar #'car live-corpus)
                            :procedure-id procedure-id))
      ;; the corpus changed after the search was declared
      ((/= declared-version live-version)
       (make-search-receipt :scope scope :inspected-items 0 :status :corpus-changed
                            :matches nil :missing-regions (mapcar #'car live-corpus)
                            :procedure-id procedure-id))
      (t
       (let* ((limit (min (or window (length live-corpus)) (length live-corpus)))
              (inspected (subseq live-corpus 0 limit))
              (skipped (nthcdr limit live-corpus))
              (title (getf query :title))
              (hits (remove-if-not (lambda (rec) (string= (cdr rec) title)) inspected))
              (complete (null skipped)))
         (make-search-receipt
          :scope scope
          :inspected-items (length inspected)
          :matches (mapcar #'car hits)
          :missing-regions (mapcar #'car skipped)
          :procedure-id procedure-id
          :status (cond (hits :found)
                        ((eq kind :heuristic) :no-candidate-returned)
                        ((not complete) :incomplete)
                        (t :not-found-in-completed-scope))))))))

;;; ── The lawful constructor (packet §1: all six requirements) ────────────

(defun mint-bounded-absence (receipt &key receipt-id)
  "Mint a BOUNDED-ABSENCE from RECEIPT only if every requirement holds:
   1. a valid query;  2. fixed corpus identity + version;  3. complete
   inspection of the declared scope;  4. zero missing regions;  5. no matches;
   6. exact agreement between expected and inspected counts.
A heuristic result NEVER mints a bounded absence, even at zero candidates."
  (let* ((scope (search-receipt-scope receipt))
         (kind (procedure-kind (search-receipt-procedure-id receipt)))
         (status (search-receipt-status receipt)))
    ;; 1. valid query
    (unless (lookup-query (search-scope-query-id scope))
      (fire 'query-receipt-mismatch "receipt query ~a is not resolvable"
            (search-scope-query-id scope)))
    ;; 6b. heuristic procedures never mint — the type distinction, enforced first
    (unless (eq kind :exhaustive)
      (fire 'nonexhaustive-procedure
            "procedure ~a is heuristic; it cannot represent exhaustive inspection"
            (search-receipt-procedure-id receipt)))
    (when (eq status :no-candidate-returned)
      (fire 'nonexhaustive-procedure
            "status :no-candidate-returned is a threshold event, not a census"))
    ;; 3. complete inspection: only a completed-scope negative may pass
    (unless (eq status :not-found-in-completed-scope)
      (fire 'incomplete-inspection
            "status ~a is not a completed-scope negative" status))
    ;; 4. zero missing regions
    (when (search-receipt-missing-regions receipt)
      (fire 'incomplete-inspection
            "declared scope not fully inspected; missing regions ~a"
            (search-receipt-missing-regions receipt)))
    ;; 6. exact expected/inspected agreement
    (unless (= (search-receipt-inspected-items receipt)
               (search-scope-expected-items scope))
      (fire 'incomplete-inspection
            "inspected ~a of ~a expected items"
            (search-receipt-inspected-items receipt)
            (search-scope-expected-items scope)))
    ;; 5. no matches (a receipt with matches is a :found, not an absence)
    (when (search-receipt-matches receipt)
      (fire 'query-receipt-mismatch "a receipt with matches is not an absence"))
    (%make-bounded-absence
     :query-id (search-scope-query-id scope)
     :corpus-id (search-scope-corpus-id scope)
     :corpus-version (search-scope-corpus-version scope)
     :receipt-id receipt-id)))

;;; ── Using an absence within its jurisdiction ────────────────────────────

(defun absence-answers-query (absence query-id)
  "A receipt for query A cannot support a statement about query B."
  (unless (eq (bounded-absence-query-id absence) query-id)
    (fire 'query-receipt-mismatch
          "absence is about ~a; it was asked about ~a"
          (bounded-absence-query-id absence) query-id))
  absence)

(defun absence-answers-version (absence version)
  "A receipt for corpus version 1 cannot answer corpus version 2."
  (unless (= (bounded-absence-corpus-version absence) version)
    (fire 'corpus-version-mismatch
          "absence describes version ~a; it was asked about version ~a"
          (bounded-absence-corpus-version absence) version))
  absence)

(defun absence-widened-to (absence corpus-id)
  "A receipt over one file cannot be widened to the entire repository."
  (unless (eq (bounded-absence-corpus-id absence) corpus-id)
    (fire 'scope-extension-requested
          "absence covers ~a; it cannot be widened to ~a"
          (bounded-absence-corpus-id absence) corpus-id))
  absence)

;;; ══ The demonstration ═══════════════════════════════════════════════════

(banner "receipt of search")

(format t "An empty result describes the return value of a procedure.~%")
(format t "It does not, by itself, describe the contents of the world.~%")

;; The six statuses, each realized on the synthetic corpus.
(section "the six status shapes (no bare NIL among them):")
(let ((found     (run-search :procedure-id 'exhaustive-scan :query-id 'q-glass
                             :corpus-id 'catalog-file-a :declared-version 1
                             :live-corpus *catalog-file-a-v1* :live-version 1))
      (partial   (run-search :procedure-id 'windowed-scan :query-id 'q-glass
                             :corpus-id 'catalog-file-a :declared-version 1
                             :live-corpus *catalog-file-a-v1* :live-version 1 :window 5))
      (bounded   (run-search :procedure-id 'exhaustive-scan :query-id 'q-codex
                             :corpus-id 'catalog-file-a :declared-version 1
                             :live-corpus *catalog-file-a-v1* :live-version 1))
      (invalid   (run-search :procedure-id 'exhaustive-scan :query-id 'q-blank
                             :corpus-id 'catalog-file-a :declared-version 1
                             :live-corpus *catalog-file-a-v1* :live-version 1))
      (changed   (run-search :procedure-id 'exhaustive-scan :query-id 'q-codex
                             :corpus-id 'catalog-file-a :declared-version 1
                             :live-corpus *catalog-file-a-v2* :live-version 2))
      (heuristic (run-search :procedure-id 'topk-ranker :query-id 'q-codex
                             :corpus-id 'catalog-file-a :declared-version 1
                             :live-corpus *catalog-file-a-v1* :live-version 1)))
  (dolist (r (list found partial bounded invalid changed heuristic))
    (format t "   ~26a inspected ~a/~a  matches=~a  missing=~a~%"
            (search-receipt-status r)
            (search-receipt-inspected-items r)
            (search-scope-expected-items (search-receipt-scope r))
            (or (search-receipt-matches r) '-)
            (length (search-receipt-missing-regions r))))

  (format t "~%[note: the PARTIAL windowed search returned no match, yet the target~%")
  (format t " is present at r7 — a complete traversal finds it. Emptiness was the~%")
  (format t " procedure's, not the world's.]~%")

  ;; Mint the lawful bounded-absence once, use it in the jurisdiction checks.
  (let ((absence (mint-bounded-absence bounded :receipt-id 'receipt-17)))

    (section "the seven required checks:")

    ;; 1. partial inspection cannot produce bounded absence
    (format t " 1. partial inspection cannot mint bounded absence~%")
    (expect incomplete-inspection (mint-bounded-absence partial))

    ;; 2. complete finite inspection may produce bounded absence
    (format t " 2. complete finite inspection may mint bounded absence~%")
    (ensure (bounded-absence-p absence) "complete scope failed to mint an absence")
    (format t "   ✓ minted bounded-absence over ~a v~a for ~a~%"
            (bounded-absence-corpus-id absence)
            (bounded-absence-corpus-version absence)
            (bounded-absence-query-id absence))

    ;; 3. a receipt for query A cannot support a statement about query B
    (format t " 3. an absence for query A cannot answer query B~%")
    (expect query-receipt-mismatch (absence-answers-query absence 'q-glass))

    ;; 4. a receipt for corpus version 1 cannot answer version 2
    (format t " 4. an absence for version 1 cannot answer version 2~%")
    (expect corpus-version-mismatch (absence-answers-version absence 2))

    ;; 5. a receipt over one file cannot be widened to the repository
    (format t " 5. an absence over one file cannot be widened to the repository~%")
    (expect scope-extension-requested (absence-widened-to absence 'whole-repository))

    ;; 6. a heuristic top-k procedure cannot represent exhaustive inspection
    (format t " 6. a heuristic top-k result cannot mint bounded absence~%")
    (expect nonexhaustive-procedure (mint-bounded-absence heuristic))

    ;; 7. historical receipts remain valid descriptions of their original run
    (format t " 7. the historical absence remains valid for its own version~%")
    (ensure (eq (absence-answers-version absence 1) absence)
            "historical absence lost standing over its own version")
    (let ((v2-hit (run-search :procedure-id 'exhaustive-scan :query-id 'q-codex
                              :corpus-id 'catalog-file-a :declared-version 2
                              :live-corpus *catalog-file-a-v2* :live-version 2)))
      (ensure (eq (search-receipt-status v2-hit) :found)
              "v2 should now contain the codex"))
    (pass "v1-absence-still-describes-v1 (v2 now contains the record; jurisdiction, not falsity)"))

  (section "what this instrument does NOT establish:")
  (format t "   INSPECTED-ITEMS, MISSING-REGIONS and normal termination are~%")
  (format t "   testimony by the SAME procedure the receipt describes. This~%")
  (format t "   disciplines a cooperative caller; a lying procedure can mint an~%")
  (format t "   honest-looking receipt. This relocates the forgeable seam — it~%")
  (format t "   does not close it. A receipt has no witness for its own census.~%")

  (format t "~%── The search completed somewhere. ──~%")
  (format t "── The receipt must say where. ──~%"))
