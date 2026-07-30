;;;; descriptor.lisp — canonical descriptors, the absence table, and the
;;;; descriptor/live-object boundary.
;;;;
;;;; AP-DESC-1: the descriptor is durable evidence, not a live adapter.
;;;; This file keeps the two mechanically distinct: a descriptor is a CD/0
;;;; record datum; a live adapter is an opaque host struct that RESOLVES to
;;;; exactly one descriptor identity and version (AP-DESC-2) and is never
;;;; serialized as evidence (§3.3).  Passing one where the other is
;;;; required is a typed refusal, checked by the permanent controls.
;;;;
;;;; — CLAVIGER-IV (Claude Fable 5 subagent), 2026-07-30

(in-package #:lisp-plus-adapter0)

(defvar *descriptors* nil
  "Alist of (identity-leaf . descriptor-record), loaded from the frozen
canonical descriptor fixtures.")

(defvar *absence-table* nil
  "The loaded absence-mapping table record.")

(defun load-canonical-descriptors ()
  (setf *descriptors*
        (loop for file in '("descriptors/FAKE-ADAPTER-DESCRIPTOR-0.pjs"
                            "descriptors/FAKE-ADAPTER-DESCRIPTOR-LIMITED-ACK-0.pjs")
              for record = (read-pjs-fixture
                            (merge-pathnames file +reissue-root+))
              collect (cons (%id-leaf record "adapter-identity") record)))
  *descriptors*)

(defun descriptor-by-identity (identity-leaf)
  "Descriptor record for an adapter identity leaf (e.g.
\"fake-reference-0\"); NIL if unknown."
  (unless *descriptors* (load-canonical-descriptors))
  (cdr (assoc identity-leaf *descriptors* :test #'string=)))

(defun descriptor-witnessable-classes (descriptor)
  "The descriptor's declared witnessable acknowledgment classes, as a list
of leaf strings (AP-ACK-2)."
  (let ((field (case-field descriptor "witnessable-acknowledgment-classes")))
    (when (and field (sequence-datum-p field))
      (loop for index below (sequence-datum-length field)
            for element = (sequence-datum-ref field index)
            when (identifier-datum-p element)
              collect (car (last (identifier-segments element)))))))

(defun descriptor-adapter-version (descriptor)
  (case-string descriptor "adapter-version"))

;;; ---------------------------------------------------------------------------
;;; Absence-mapping table (§14, Appendix C).

(defun load-absence-table ()
  (setf *absence-table*
        (read-pjs-fixture
         (merge-pathnames "descriptors/FAKE-ABSENCE-MAPPING-TABLE-0.pjs"
                          +reissue-root+)))
  *absence-table*)

(defun %absence-rows ()
  (unless *absence-table* (load-absence-table))
  (let ((rows (case-field *absence-table* "rows")))
    (loop for index below (sequence-datum-length rows)
          collect (sequence-datum-ref rows index))))

(defun absence-row-for-shape (shape-leaf)
  "The table row whose shape leaf equals SHAPE-LEAF, or NIL — a NIL here
is a table miss and, per AP-ABS-1, the caller must refuse rather than
improvise an absence verdict."
  (find shape-leaf (%absence-rows)
        :key (lambda (row) (%id-leaf row "shape"))
        :test #'string=))

(defun absence-row-status (row)
  "Kernel manifestation status leaf of the row (e.g. \"present-empty\")."
  (%id-leaf row "kernel-manifestation-status"))

(defun absence-row-state (row)
  "No-payload state leaf of the row, or NIL when the row carries #u."
  (%id-leaf row "no-payload-state"))

(defun +absence-shapes+ ()
  "All shape leaves the loaded table declares (derived live, never
hardcoded)."
  (mapcar (lambda (row) (%id-leaf row "shape")) (%absence-rows)))

;;; ---------------------------------------------------------------------------
;;; Live adapter object (§3.3).  Opaque, never serialized as evidence.

(defstruct (live-adapter
            (:constructor %make-live-adapter
                (descriptor descriptor-identity descriptor-version
                 instance-label))
            (:print-object
             (lambda (object stream)
               ;; §3.3: the live object is not evidence; only descriptor
               ;; identity + instance label are printable.
               (print-unreadable-object (object stream :type t)
                 (format stream "~a ~a"
                         (live-adapter-descriptor-identity object)
                         (live-adapter-instance-label object))))))
  descriptor
  descriptor-identity
  descriptor-version
  instance-label)

(defun bind-live-adapter (descriptor &key (instance-label "live-0"))
  "Resolve DESCRIPTOR (a CD/0 record datum) to a live adapter object.
AP-DESC-2: exactly one descriptor identity and version, resolved before
any preparation.  A non-descriptor argument — including a live adapter,
the descriptor/live-object collapse — is a typed refusal."
  (when (live-adapter-p descriptor)
    (signal-ap0 'adapter-descriptor-invalid
                :requirement-id "AP-DESC-1"
                :frontier-crossed nil
                :detail "a live adapter object was presented where a ~
                         descriptor record is required; the descriptor ~
                         and the live object are distinct"))
  (unless (and (datum-p descriptor) (record-datum-p descriptor))
    (signal-ap0 'adapter-descriptor-invalid
                :requirement-id "AP-DESC-2"
                :frontier-crossed nil
                :detail "descriptor must be a canonical record datum"))
  (let ((identity (%id-leaf descriptor "adapter-identity"))
        (version (case-string descriptor "adapter-version")))
    (unless identity
      (signal-ap0 'adapter-identity-missing
                  :requirement-id "AP-DESC-2"
                  :frontier-crossed nil
                  :detail "descriptor carries no adapter identity"))
    (unless version
      (signal-ap0 'adapter-descriptor-invalid
                  :requirement-id "AP-DESC-2"
                  :frontier-crossed nil
                  :detail "descriptor carries no adapter version"))
    (%make-live-adapter descriptor identity version instance-label)))
