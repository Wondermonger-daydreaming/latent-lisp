;;;; data.lisp — Class A fixture access.
;;;;
;;;; Every fixture (registry, descriptors, absence table, scripts, vectors,
;;;; mutants) is a one-line PJ-S/0 canonical datum with a trailing newline.
;;;; Reading is binary (AP-JRN-2 / §7.3 discipline: octets in, the PJ-S/0
;;;; codec is the only place octets become scalars); the trailing newline
;;;; is stripped and the remaining octets MUST decode :canonical — a
;;;; fixture that fails that gate is refused, never patched.
;;;;
;;;; — CLAVIGER-IV (Claude Fable 5 subagent), 2026-07-30

(in-package #:lisp-plus-adapter0)

(defparameter +reissue-root+
  #p"mneme/architecture/adapter-protocol-0/lisp-plus-adapter-protocol-0-reissue/"
  "Root of the adopted AP0 reissue packet (all runs start at the
latent-lisp root, the house convention).")

(defun %read-octets (pathname)
  (with-open-file (stream pathname :direction :input
                                   :element-type '(unsigned-byte 8))
    (let ((octets (make-array (file-length stream)
                              :element-type '(unsigned-byte 8))))
      (read-sequence octets stream)
      octets)))

(defun %strip-trailing-newlines (octets)
  (let ((end (length octets)))
    (loop while (and (> end 0) (= 10 (aref octets (1- end))))
          do (decf end))
    (subseq octets 0 end)))

(defun read-pjs-fixture (pathname)
  "Read PATHNAME (binary), strip the trailing newline, decode as one
canonical PJ-S/0 datum.  Refuses (typed) on any non-:canonical status."
  (multiple-value-bind (datum status detail)
      (decode-pjs0 (%strip-trailing-newlines (%read-octets pathname)))
    (unless (eq status :canonical)
      (signal-ap0 'adapter-descriptor-invalid
                  :requirement-id "AP0-§19"
                  :frontier-crossed nil
                  :identities (list (namestring pathname))
                  :detail (format nil "fixture is not canonical PJ-S/0 ~
                                       (~a~@[: ~a~])" status detail)))
    datum))

;;; ---------------------------------------------------------------------------
;;; Case-record field access.  Vector case records key every field as
;;; (id "ap0" NAME).  A field may hold a string, integer, boolean, #u,
;;; an identifier, or a sequence.

(defun case-field (case-record name)
  "Raw CD/0 datum of field (id \"ap0\" NAME), or NIL if absent."
  (record-field case-record "ap0" name))

(defun case-field-present-p (case-record name)
  "True iff the field exists at all (a #u value still counts as present)."
  (nth-value 1 (record-field case-record "ap0" name)))

(defun %unitp (datum)
  (and datum (unit-datum-p datum)))

(defun case-string (case-record name)
  "String value of the field; NIL when absent, #u, or not a string."
  (let ((datum (case-field case-record name)))
    (when (and datum (string-datum-p datum))
      (string-datum-value datum))))

(defun case-integer (case-record name)
  (let ((datum (case-field case-record name)))
    (when (and datum (integer-datum-p datum))
      (integer-datum-value datum))))

(defun case-boolean (case-record name)
  "Three-valued: :true, :false, or NIL (absent / #u / not a boolean)."
  (let ((datum (case-field case-record name)))
    (when (and datum (boolean-datum-p datum))
      (if (boolean-datum-value datum) :true :false))))

(defun case-id-string (case-record name)
  "Identifier field rendered as its colon-joined segment string; for an
identifier like (id \"verdict\" \"accept\") returns \"verdict:accept\".
NIL when absent or not an identifier."
  (let ((datum (case-field case-record name)))
    (when (and datum (identifier-datum-p datum))
      (identifier-segment-string datum))))

(defun %id-leaf (case-record name)
  "Last segment of an identifier field — e.g. \"accept\" of
(id \"verdict\" \"accept\").  NIL when absent or not an identifier."
  (let ((datum (case-field case-record name)))
    (when (and datum (identifier-datum-p datum))
      (car (last (identifier-segments datum))))))

(defun %field-defined-p (case-record name)
  "Present AND not #u."
  (let ((datum (case-field case-record name)))
    (and datum (not (%unitp datum)))))

(defun %sequence-integers (case-record name)
  "Field as a list of integers; NIL when absent or not a sequence."
  (let ((datum (case-field case-record name)))
    (when (and datum (sequence-datum-p datum))
      (loop for index below (sequence-datum-length datum)
            for element = (sequence-datum-ref datum index)
            when (integer-datum-p element)
              collect (integer-datum-value element)))))

(defun %sequence-strings (case-record name)
  (let ((datum (case-field case-record name)))
    (when (and datum (sequence-datum-p datum))
      (loop for index below (sequence-datum-length datum)
            for element = (sequence-datum-ref datum index)
            when (string-datum-p element)
              collect (string-datum-value element)))))
