;;;; salvage.lisp — §14 source-preserving salvage.
;;;;
;;;; PJ-SAL-1: the source remains byte-identical.  PJ-SAL-2: destination
;;;; frames are regenerated for the new store identity.  PJ-SAL-3: salvage
;;;; does not claim the excluded torn frame had no external consequence.
;;;; R-PJ-1 (PJ0-PRESEAL-REPAIRS): the receipt carries the output origin
;;;; facet — the destination journal's standing is :derived from the named
;;;; source; its events retain their original capture origins unchanged; the
;;;; salvage itself adds no observational standing.

(in-package #:lisp-plus-journal0)

(defun salvage-valid-prefix (source-directory destination-directory authority)
  "Create a new store at DESTINATION-DIRECTORY containing exactly the valid
prefix of the store at SOURCE-DIRECTORY.  AUTHORITY is a list of identifier
segments naming the operator/authority.  Returns (values destination-store
salvage-receipt-record).  §14.1: the source is never altered."
  (let* ((source (open-store source-directory))
         (source-events-path (merge-pathnames "EVENTS.pj0"
                                              (pathname source-directory)))
         (source-octets (or (%read-file-octets source-events-path)
                            (make-array 0 :element-type '(unsigned-byte 8))))
         (source-sha-before (sha256-hex source-octets))
         (source-metadata-octets (%read-file-octets
                                  (merge-pathnames "JOURNAL-META.pjs"
                                                   (pathname
                                                    source-directory))))
         (report (validate-event-octets source-octets
                                        (journal-store-store-id source)))
         (destination
           (create-journal destination-directory
                           :declared-durability
                           (ecase (journal-store-durability source)
                             (:synced "synced")
                             (:best-effort "best-effort")))))
    ;; Copy exactly the valid prefix, event by event; frames regenerate under
    ;; the destination identity (PJ-SAL-2).
    (loop for index below (fill-pointer (prefix-report-events report))
          do (append-event destination
                           (aref (prefix-report-events report) index)))
    ;; PJ-SAL-1 proof obligation: the source bytes are untouched.
    (let ((source-sha-after
            (sha256-hex (or (%read-file-octets source-events-path)
                            (make-array 0 :element-type '(unsigned-byte 8))))))
      (unless (string= source-sha-before source-sha-after)
        (signal-pj0 'pj0-salvage-receipt-required
                    :requirement-id "PJ-SAL-1"
                    :detail "source bytes changed during salvage — abort")))
    (flet ((field (key value)
             (lisp-plus-cd0:make-record-entry (identifier-from-segments key)
                                              value))
           (hex-bytes (hex) (lisp-plus-cd0:make-bytes-datum
                             (hex->octets hex))))
      (let ((receipt
              (lisp-plus-cd0:make-record-datum
               (list
                (field '("salvage" "source-store-id")
                       (record-field (journal-store-metadata source)
                                     "pj0" "store-id"))
                (field '("salvage" "source-metadata-digest")
                       (hex-bytes (sha256-hex source-metadata-octets)))
                (field '("salvage" "source-valid-byte-count")
                       (lisp-plus-cd0:make-integer-datum
                        (prefix-report-valid-byte-count report)))
                (field '("salvage" "source-terminal-ordinal")
                       (lisp-plus-cd0:make-integer-datum
                        (prefix-report-frame-count report)))
                (field '("salvage" "source-terminal-digest")
                       (hex-bytes (prefix-report-terminal-digest report)))
                (field '("salvage" "tail-byte-count")
                       (lisp-plus-cd0:make-integer-datum
                        (if (prefix-report-tail-octets report)
                            (length (prefix-report-tail-octets report))
                            0)))
                (field '("salvage" "tail-sha256")
                       (if (prefix-report-tail-sha256 report)
                           (hex-bytes (prefix-report-tail-sha256 report))
                           (lisp-plus-cd0:make-unit-datum)))
                (field '("salvage" "terminal-classification")
                       (identifier-from-segments
                        (list "pj0-status"
                              (ecase (prefix-report-status report)
                                (:valid "valid")
                                (:torn-tail "torn-tail")
                                (:corruption "corruption")))))
                (field '("salvage" "procedure")
                       (identifier-from-segments
                        '("lisp-plus-journal0" "salvage-valid-prefix" "0")))
                (field '("salvage" "destination-store-id")
                       (record-field (journal-store-metadata destination)
                                     "pj0" "store-id"))
                (field '("salvage" "copied-event-ids")
                       (lisp-plus-cd0:make-sequence-datum
                        (loop for index below (fill-pointer
                                               (prefix-report-event-ids
                                                report))
                              collect (aref (prefix-report-event-ids report)
                                            index))))
                (field '("salvage" "operator-authority")
                       (identifier-from-segments authority))
                ;; R-PJ-1 output origin facet.
                (field '("salvage" "output-origin")
                       (identifier-from-segments '("origin" "derived")))
                ;; §14.2: missing evidence and bounded unknowns.  PJ-SAL-3.
                (field '("salvage" "bounded-unknowns")
                       (lisp-plus-cd0:make-sequence-datum
                        (list
                         (lisp-plus-cd0:make-string-datum
                          (concatenate 'string
                                       "the excluded tail may describe an "
                                       "external consequence that did occur; "
                                       "salvage does not resolve it")))))))))
        (values destination receipt)))))
