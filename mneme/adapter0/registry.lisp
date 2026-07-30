;;;; registry.lisp — the frozen fixture registry, folded live.
;;;;
;;;; ONE canonical record arbitrates the gate: AP0-FIXTURE-REGISTRY.sexp.
;;;; Every count is DERIVED from folding its entries — never hardcoded —
;;;; and the derived counts are cross-checked against the registry's own
;;;; scalar fields.  Mutants are not registry entries; they are enumerated
;;;; from vectors/mutants/ on disk.
;;;;
;;;; — CLAVIGER-IV (Claude Fable 5 subagent), 2026-07-30

(in-package #:lisp-plus-adapter0)

(defvar *registry* nil)

(defun load-registry ()
  (setf *registry*
        (read-pjs-fixture
         (merge-pathnames "AP0-FIXTURE-REGISTRY.sexp" +reissue-root+)))
  *registry*)

(defun registry-scalar (name)
  "Integer scalar field of the registry (e.g. \"vector-count\")."
  (unless *registry* (load-registry))
  (case-integer *registry* name))

(defun registry-entries ()
  "All entry records, in registry order."
  (unless *registry* (load-registry))
  (let ((entries (case-field *registry* "entries")))
    (loop for index below (sequence-datum-length entries)
          collect (sequence-datum-ref entries index))))

(defun registry-entry-case-id (entry) (case-string entry "case-id"))
(defun registry-entry-verdict (entry) (%id-leaf entry "expected-verdict"))
(defun registry-entry-family (entry) (%id-leaf entry "family"))
(defun registry-entry-path (entry) (case-string entry "path"))

(defun derive-registry-counts ()
  "Fold the entries: (values positive adversarial total families-alist).
FAMILIES-ALIST maps family leaf -> count, sorted by family name."
  (let ((positive 0) (adversarial 0) (families '()))
    (dolist (entry (registry-entries))
      (let ((verdict (registry-entry-verdict entry))
            (family (registry-entry-family entry)))
        (cond ((string= verdict "accept") (incf positive))
              ((string= verdict "reject") (incf adversarial)))
        (let ((cell (assoc family families :test #'string=)))
          (if cell (incf (cdr cell)) (push (cons family 1) families)))))
    (values positive adversarial (+ positive adversarial)
            (sort families #'string< :key #'car))))

(defun enumerate-mutants ()
  "Mutant records from vectors/mutants/ on disk, sorted by mutant id."
  (sort
   (mapcar #'read-pjs-fixture
           (directory (merge-pathnames "vectors/mutants/*.pjs"
                                       +reissue-root+)))
   #'string<
   :key (lambda (mutant) (case-string mutant "mutant-id"))))
