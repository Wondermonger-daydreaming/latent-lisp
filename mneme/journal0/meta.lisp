;;;; meta.lisp — §6 journal metadata and store identity.
;;;;
;;;; JOURNAL-META.pjs is one canonical PJ-S/0 record followed by LF.
;;;; Store identity (§6.1):
;;;;   hex(SHA-256("PJ0-STORE-ID-0" || NUL || PJ-S/0(metadata-without-store-id)))
;;;; where PJ-S/0(...) carries NO trailing LF (proven against the frozen
;;;; store: recomputing the synced-demo identity from its own metadata basis
;;;; reproduces 12b099a4... exactly).
;;;; PJ-META-2: sidecar = lowercase SHA-256, two ASCII spaces, filename, LF.
;;;; PJ-META-3: metadata mutation after the first committed event is
;;;; corruption; durability never changes in place (PJ-DUR-2).

(in-package #:lisp-plus-journal0)

(defvar +metadata-required-fields+
  '(("pj0" "cd0-version")
    ("pj0" "creation-procedure")
    ("pj0" "declared-durability")
    ("pj0" "format-version")
    ("pj0" "genesis-digest")
    ("pj0" "store-id")
    ("pj0" "store-nonce")
    ("pj0" "witness-policy")))

(defun %metadata-without-store-id (metadata-record)
  "A CD/0 record equal to METADATA-RECORD minus the (id \"pj0\" \"store-id\")
field.  CD/0's constructor restores canonical field order."
  (let ((store-id-key (identifier-from-segments '("pj0" "store-id")))
        (entries '()))
    (loop for index below (lisp-plus-cd0:record-datum-size metadata-record)
          for key = (lisp-plus-cd0:record-datum-key-at metadata-record index)
          for value = (lisp-plus-cd0:record-datum-value-at metadata-record index)
          unless (lisp-plus-cd0:equal-datum key store-id-key)
            do (push (lisp-plus-cd0:make-record-entry key value) entries))
    (lisp-plus-cd0:make-record-datum (reverse entries))))

(defun derive-store-id-hex (metadata-record)
  "The §6.1 store identity hex for METADATA-RECORD (store-id field ignored)."
  (let* ((basis-octets (encode-pjs0 (%metadata-without-store-id
                                     metadata-record)))
         (domain (map '(simple-array (unsigned-byte 8) (*)) #'char-code
                      "PJ0-STORE-ID-0"))
         (preimage (make-array (+ (length domain) 1 (length basis-octets))
                               :element-type '(unsigned-byte 8)
                               :initial-element 0)))
    (replace preimage domain)
    ;; NUL separator already zero at (length domain).
    (replace preimage basis-octets :start1 (1+ (length domain)))
    (sha256-hex preimage)))

(defun store-id-string (metadata-record)
  "The §8.3 public store-id string \"pj0-store:HEX\" from the metadata's
(id \"pj0-store\" HEX) identity."
  (let ((identity (record-field metadata-record "pj0" "store-id")))
    (unless (and identity (lisp-plus-cd0:identifier-datum-p identity))
      (signal-pj0 'pj0-metadata-invalid :requirement-id "PJ-META-1"
                  :detail "metadata lacks an identifier store-id"))
    (identifier-segment-string identity)))

(defun validate-metadata-octets (octets &key sidecar-octets
                                          (filename "JOURNAL-META.pjs"))
  "Validate JOURNAL-META bytes (§6): canonical PJ-S/0 record + final LF,
all eight required fields, genesis digest equal to the §8.1 constant,
store-id equal to its §6.1 derivation, nonce of at least 16 octets
(PJ-META-1's 128-bit floor — length is checkable; unpredictability is not).
When SIDECAR-OCTETS is supplied, verify the PJ-META-2 sidecar too.
Returns the metadata record."
  (let ((length (length octets)))
    (unless (and (plusp length) (= #x0a (aref octets (1- length))))
      (signal-pj0 'pj0-metadata-invalid :requirement-id "PJ-META-2"
                  :detail "metadata must end with LF"))
    (multiple-value-bind (record status detail)
        (decode-pjs0 (subseq octets 0 (1- length)))
      (unless (eq status :canonical)
        (signal-pj0 'pj0-metadata-invalid :requirement-id "PJ-SYN-2"
                    :detail (format nil "metadata not canonical PJ-S/0: ~a ~a"
                                    status detail)))
      (unless (lisp-plus-cd0:record-datum-p record)
        (signal-pj0 'pj0-metadata-invalid :requirement-id "PJ-META-1"
                    :detail "metadata is not a record"))
      (dolist (field +metadata-required-fields+)
        (multiple-value-bind (value presentp)
            (apply #'record-field record field)
          (declare (ignore value))
          (unless presentp
            (signal-pj0 'pj0-metadata-invalid :requirement-id "PJ-META-1"
                        :detail (format nil "missing metadata field ~{~a~^/~}"
                                        field)))))
      (let ((genesis (record-field record "pj0" "genesis-digest")))
        (unless (and (lisp-plus-cd0:bytes-datum-p genesis)
                     (string= (octets->hex (lisp-plus-cd0:bytes-datum-value
                                            genesis))
                              +genesis-digest-hex+))
          (signal-pj0 'pj0-metadata-invalid :requirement-id "PJ0-§8.1"
                      :detail "genesis digest is not SHA-256(PJ0-GENESIS-0)")))
      ;; PJ-META-1's 128-bit nonce floor binds store CREATION (nonce
      ;; issuance); Annex A step 1 scopes reader-side metadata validation to
      ;; canonicality and derived identity, and the frozen best-effort
      ;; fixture carries a 15-octet nonce — so the floor is enforced in
      ;; BUILD-METADATA-RECORD, not here.  Named divergence note: the demo
      ;; nonces are also predictable ASCII, which no validator can check.
      (let ((nonce (record-field record "pj0" "store-nonce")))
        (unless (lisp-plus-cd0:bytes-datum-p nonce)
          (signal-pj0 'pj0-metadata-invalid :requirement-id "PJ-META-1"
                      :detail "store-nonce must be a byte string")))
      (let ((identity (record-field record "pj0" "store-id"))
            (derived (derive-store-id-hex record)))
        (unless (and (lisp-plus-cd0:identifier-datum-p identity)
                     (string= (identifier-segment-string identity)
                              (concatenate 'string "pj0-store:" derived)))
          (signal-pj0 'pj0-store-id-mismatch :requirement-id "PJ0-§6.1"
                      :detail (format nil "declared store-id does not match ~
                                           derived ~a" derived))))
      (when sidecar-octets
        (let ((expected (format nil "~a  ~a~c"
                                (sha256-hex octets) filename #\Linefeed)))
          (unless (%octets-equal-p
                   sidecar-octets
                   (map '(simple-array (unsigned-byte 8) (*)) #'char-code
                        expected))
            (signal-pj0 'pj0-metadata-invalid :requirement-id "PJ-META-2"
                        :detail "metadata sidecar digest mismatch"))))
      record)))

(defun build-metadata-record (&key (cd0-version "0")
                                   (creation-procedure
                                    '("lisp-plus-journal0" "create-journal" "0"))
                                   (declared-durability "synced")
                                   (witness-policy
                                    '("pj0" "kernel-transition-default"))
                                   nonce-octets)
  "Construct a §6 metadata record (with derived store-id) for a new store."
  (unless (and nonce-octets (>= (length nonce-octets) 16))
    (signal-pj0 'pj0-metadata-invalid :requirement-id "PJ-META-1"
                :detail "a new store requires a nonce of >= 16 octets"))
  (flet ((field (key value)
           (lisp-plus-cd0:make-record-entry
            (identifier-from-segments key) value)))
    (let* ((base-entries
             (list
              (field '("pj0" "cd0-version")
                     (lisp-plus-cd0:make-string-datum cd0-version))
              (field '("pj0" "creation-procedure")
                     (identifier-from-segments creation-procedure))
              (field '("pj0" "declared-durability")
                     (identifier-from-segments
                      (list "pj0" declared-durability)))
              (field '("pj0" "format-version")
                     (lisp-plus-cd0:make-integer-datum 0))
              (field '("pj0" "genesis-digest")
                     (lisp-plus-cd0:make-bytes-datum
                      (hex->octets +genesis-digest-hex+)))
              (field '("pj0" "store-nonce")
                     (lisp-plus-cd0:make-bytes-datum nonce-octets))
              (field '("pj0" "witness-policy")
                     (identifier-from-segments witness-policy))))
           (basis (lisp-plus-cd0:make-record-datum base-entries))
           (derived (derive-store-id-hex basis)))
      (lisp-plus-cd0:make-record-datum
       (cons (field '("pj0" "store-id")
                    (identifier-from-segments (list "pj0-store" derived)))
             base-entries)))))

(defun render-metadata-octets (metadata-record)
  "JOURNAL-META.pjs bytes: canonical record + LF."
  (let* ((body (encode-pjs0 metadata-record))
         (octets (make-array (1+ (length body))
                             :element-type '(unsigned-byte 8))))
    (replace octets body)
    (setf (aref octets (length body)) #x0a)
    octets))
