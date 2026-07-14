(in-package #:lisp-plus-lci0)

;;;; Fixture-authority overlay 0.2 (LCI0-AC-001 .. LCI0-AC-010).
;;;;
;;;; The installed fixture root is the cross-language contract:
;;;;   <root>/ = 0.1 members (byte-unchanged)
;;;;           + lci0-fixture-overlay-0.2-2026-07-14/ (overlay package root)
;;;; A loader detects the overlay subdirectory, verifies its SHA256SUMS
;;;; against the extracted tree, and consults LCI0-FIXTURE-OVERLAY-0.2-INDEX.json
;;;; overlay-first for exactly the four supersession keys, falling through to
;;;; 0.1 for every other entry (Errata F0.2-1).
;;;;
;;;; A fixture root WITHOUT the overlay subdirectory behaves exactly as
;;;; before: every function below returns NIL and no caller changes behavior.

(defparameter +overlay-directory-name+ "lci0-fixture-overlay-0.2-2026-07-14")

(defparameter +overlay-index-name+ "LCI0-FIXTURE-OVERLAY-0.2-INDEX.json")

(defparameter +overlay-sums-name+ "LCI0-FIXTURE-OVERLAY-0.2-SHA256SUMS.txt")

(defstruct fixture-overlay
  root                ; overlay package root pathname
  index               ; parsed LCI0-FIXTURE-OVERLAY-0.2-INDEX.json
  supersessions       ; hash: 0.1 vector key -> index entry
  relation-failures   ; hash: machine path -> index entry
  hostile             ; hash: request slug -> index entry
  closure-records)    ; hash: closure id -> index entry

(defun %overlay-directory (root)
  (let ((directory
          (merge-pathnames
           (concatenate 'string +overlay-directory-name+ "/")
           (pathname (concatenate 'string
                                  (string-right-trim "/" root) "/")))))
    (and (probe-file (merge-pathnames +overlay-index-name+ directory))
         directory)))

(defun %read-file-octets (path)
  (with-open-file (stream path :direction :input
                               :element-type '(unsigned-byte 8))
    (let ((octets (make-array (file-length stream)
                              :element-type '(unsigned-byte 8))))
      (read-sequence octets stream)
      octets)))

(defun %verify-overlay-sums (directory)
  "Verify every member listed in the overlay SHA256SUMS against the extracted
tree before trusting any value (OVERLAY-BUILD-RECEIPT §7 step 4)."
  (with-open-file (stream (merge-pathnames +overlay-sums-name+ directory)
                          :direction :input :external-format :utf-8)
    (loop for line = (read-line stream nil nil)
          while line
          unless (zerop (length line))
            do (let* ((space (position #\Space line))
                      (expected (subseq line 0 space))
                      (member (string-left-trim
                               " *" (subseq line space)))
                      (path (merge-pathnames member directory)))
                 (unless (probe-file path)
                   (error "overlay member missing: ~A" member))
                 (let ((actual (sha256-hex (%read-file-octets path))))
                   (unless (string= actual expected)
                     (error "overlay member digest mismatch: ~A" member))))))
  t)

(defun %overlay-table (index key)
  (let ((table (make-hash-table :test #'equal)))
    (dolist (pair (jget index key nil) table)
      (setf (gethash (car pair) table) (cdr pair)))))

(defun load-fixture-overlay (&optional (root *fixture-root*))
  "Return a FIXTURE-OVERLAY for ROOT, or NIL when ROOT carries no overlay
subdirectory.  The overlay tree is digest-verified before any value is used."
  (let ((directory (%overlay-directory root)))
    (when directory
      (%verify-overlay-sums directory)
      (let ((index (read-json-document
                    (merge-pathnames +overlay-index-name+ directory))))
        (let ((keys (jget index "supersession_keys"))
              (supersessions (%overlay-table index "supersessions")))
          (unless (and (= (length keys) 4)
                       (= (hash-table-count supersessions) 4)
                       (every (lambda (key)
                                (nth-value 1 (gethash key supersessions)))
                              keys))
            (error "overlay supersession keys do not match index")))
        (make-fixture-overlay
         :root directory
         :index index
         :supersessions (%overlay-table index "supersessions")
         :relation-failures (%overlay-table index "relation_failures")
         :hostile (%overlay-table index "hostile")
         :closure-records (%overlay-table index "closure_records"))))))

(defun overlay-supersession (overlay vector-id)
  "The overlay INDEX entry superseding 0.1 vector VECTOR-ID, or NIL.
Fall-through to 0.1 is the caller keeping its existing expectation."
  (and overlay
       (gethash vector-id (fixture-overlay-supersessions overlay))))

(defun overlay-member-document (overlay member)
  "Read one overlay member JSON document by its index-relative member path."
  (read-json-document
   (merge-pathnames member (fixture-overlay-root overlay))))
