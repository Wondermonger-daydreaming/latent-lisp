;;;; writer.lisp — §9 append protocol, §10 durability, §11 locking, and the
;;;; §22 store surface (create-journal, open-store, validate-journal,
;;;; append-event, find-event, read-prefix-valid, explain-journal).
;;;;
;;;; PJ-READ-0: every file below is opened with :element-type
;;;; (unsigned-byte 8) — raw octets, binary mode, no text translation.
;;;; PJ-API-1: the ONLY supported append path is APPEND-EVENT, which performs
;;;; canonicalization, identity reconciliation, locking, framing, durability,
;;;; and receipt construction.  No raw-append helper is exported (PJ-API-2).

(in-package #:lisp-plus-journal0)

;;; ---------------------------------------------------------------------------
;;; Binary file plumbing.

(defun %read-file-octets (pathname)
  (with-open-file (stream pathname :direction :input
                                   :element-type '(unsigned-byte 8)
                                   :if-does-not-exist nil)
    (if (null stream)
        nil
        (let ((octets (make-array (file-length stream)
                                  :element-type '(unsigned-byte 8))))
          (read-sequence octets stream)
          octets))))

(defun %write-file-octets (pathname octets &key (if-exists :error) sync)
  (with-open-file (stream pathname :direction :output
                                   :element-type '(unsigned-byte 8)
                                   :if-exists if-exists
                                   :if-does-not-exist :create)
    (write-sequence octets stream)
    (finish-output stream)
    (when sync (%fsync-stream stream)))
  pathname)

(defun %fsync-stream (stream)
  "The declared §10.1 durability barrier: fsync(2) on the stream's
descriptor.  PJ-DUR-3: this is a host-contract belief, not physical proof."
  (handler-case
      (sb-posix:fsync (sb-sys:fd-stream-fd stream))
    (error (condition)
      (signal-pj0 'pj0-durability-barrier-failure
                  :requirement-id "PJ-DUR-3"
                  :detail (princ-to-string condition)))))

(defun %fsync-directory (directory)
  (handler-case
      (let ((fd (sb-posix:open (namestring directory) sb-posix:o-rdonly)))
        (unwind-protect (sb-posix:fsync fd)
          (sb-posix:close fd)))
    (sb-posix:syscall-error (condition)
      (signal-pj0 'pj0-durability-barrier-failure
                  :requirement-id "PJ-DUR-3"
                  :detail (princ-to-string condition)))))

(defun %random-nonce (&optional (count 16))
  (or (with-open-file (stream "/dev/urandom" :direction :input
                                             :element-type '(unsigned-byte 8)
                                             :if-does-not-exist nil)
        (when stream
          (let ((octets (make-array count :element-type '(unsigned-byte 8))))
            (read-sequence octets stream)
            octets)))
      ;; Fallback only; PJ-META-1 unpredictability is then NOT met and the
      ;; caller should treat the store as a test fixture.
      (let ((octets (make-array count :element-type '(unsigned-byte 8)))
            (state (make-random-state t)))
        (dotimes (index count octets)
          (setf (aref octets index) (random 256 state))))))

;;; ---------------------------------------------------------------------------
;;; Store handle.

(defstruct journal-store
  directory        ; pathname (directory)
  metadata         ; CD/0 record
  store-id         ; "pj0-store:HEX" string
  durability)      ; :synced | :best-effort

(defun %store-path (store name)
  (merge-pathnames name (journal-store-directory store)))

(defun %durability-keyword (metadata)
  (let ((durability (record-field metadata "pj0" "declared-durability")))
    (unless (lisp-plus-cd0:identifier-datum-p durability)
      (signal-pj0 'pj0-metadata-invalid :requirement-id "PJ-META-1"
                  :detail "declared-durability must be an identifier"))
    (let ((string (identifier-segment-string durability)))
      (cond ((string= string "pj0:synced") :synced)
            ((string= string "pj0:best-effort") :best-effort)
            (t (signal-pj0 'pj0-metadata-invalid :requirement-id "PJ-DUR-2"
                           :detail (format nil "unknown durability ~a"
                                           string)))))))

(defun open-store (directory)
  "Open and validate a §4 reference store directory (metadata + sidecar)."
  (let* ((directory (pathname directory))
         (metadata-octets (%read-file-octets
                           (merge-pathnames "JOURNAL-META.pjs" directory)))
         (sidecar-octets (%read-file-octets
                          (merge-pathnames "JOURNAL-META.pjs.sha256"
                                           directory))))
    (unless metadata-octets
      (signal-pj0 'pj0-metadata-invalid :requirement-id "PJ0-§4"
                  :detail (format nil "no JOURNAL-META.pjs under ~a"
                                  directory)))
    (let ((metadata (validate-metadata-octets metadata-octets
                                              :sidecar-octets sidecar-octets)))
      (make-journal-store :directory directory
                          :metadata metadata
                          :store-id (store-id-string metadata)
                          :durability (%durability-keyword metadata)))))

(defun create-journal (directory &key (declared-durability "synced")
                                      metadata-octets
                                      nonce-octets)
  "Create a §4 reference store.  Either build fresh §6 metadata (optionally
with NONCE-OCTETS) or adopt the exact METADATA-OCTETS supplied (used by
conformance tests to reproduce a frozen store identity).  Returns the open
JOURNAL-STORE."
  (let* ((directory (pathname directory))
         (metadata-octets
           (or metadata-octets
               (render-metadata-octets
                (build-metadata-record
                 :declared-durability declared-durability
                 :nonce-octets (or nonce-octets (%random-nonce))))))
         (metadata (validate-metadata-octets metadata-octets)))
    (ensure-directories-exist directory)
    (let ((sidecar (format nil "~a  JOURNAL-META.pjs~c"
                           (sha256-hex metadata-octets) #\Linefeed))
          (synced (eq (%durability-keyword metadata) :synced)))
      (%write-file-octets (merge-pathnames "JOURNAL-META.pjs" directory)
                          metadata-octets :sync synced)
      (%write-file-octets (merge-pathnames "JOURNAL-META.pjs.sha256" directory)
                          (map '(simple-array (unsigned-byte 8) (*))
                               #'char-code sidecar)
                          :sync synced)
      (%write-file-octets (merge-pathnames "EVENTS.pj0" directory)
                          (make-array 0 :element-type '(unsigned-byte 8))
                          :sync synced)
      ;; §10.1: store creation synchronizes required directory entries where
      ;; the host API exposes that operation.
      (when synced (%fsync-directory directory)))
    (open-store directory)))

;;; ---------------------------------------------------------------------------
;;; Validation surface.

(defun validate-journal (store-or-directory &key defect signal)
  "PJ-VAL-1 report for the store's EVENTS.pj0.  With :SIGNAL, a non-valid
terminal classification raises its typed §23 condition wrapped in the
PJ-CND-2 lawful restarts."
  (let* ((store (if (journal-store-p store-or-directory)
                    store-or-directory
                    (open-store store-or-directory)))
         (octets (or (%read-file-octets (%store-path store "EVENTS.pj0"))
                     (make-array 0 :element-type '(unsigned-byte 8))))
         (report (validate-event-octets octets (journal-store-store-id store)
                                        :defect defect)))
    (when (and signal (not (eq (prefix-report-status report) :valid)))
      (with-pj0-restarts (:abandon t
                          :inspect (lambda () report)
                          :salvage (lambda () report))
        (signal-pj0 (prefix-report-condition-type report)
                    :store-id (journal-store-store-id store)
                    :byte-offset (prefix-report-tail-offset report)
                    :expected-ordinal (1+ (prefix-report-frame-count report))
                    :terminal-digest (prefix-report-terminal-digest report)
                    :requirement-id (prefix-report-condition-requirement
                                     report)
                    :evidence (list :tail-sha256
                                    (prefix-report-tail-sha256 report))
                    :detail (prefix-report-detail report))))
    report))

(defun read-prefix-valid (store)
  "§22: decoded abstract events of the maximal valid prefix + the terminal
report.  Returns (values events-vector report)."
  (let ((report (validate-journal store)))
    (values (prefix-report-events report) report)))

(defun find-event (store event-id)
  "§22: coordinate of EVENT-ID in the valid prefix, or NIL.
Returns (values ordinal frame-digest-hex payload-octets) when present."
  (let* ((report (validate-journal store))
         (target (%event-id-key event-id)))
    (loop for index below (fill-pointer (prefix-report-event-ids report))
          for candidate = (aref (prefix-report-event-ids report) index)
          when (string= (%event-id-key candidate) target)
            do (return-from find-event
                 (values (1+ index)
                         (aref (prefix-report-frame-digests report) index)
                         (encode-pjs0 (aref (prefix-report-events report)
                                            index)))))
    nil))

;;; ---------------------------------------------------------------------------
;;; §11 single-writer lock.

(defun %acquire-lock (store)
  (let ((lock-path (%store-path store "LOCK")))
    (handler-case
        (with-open-file (stream lock-path :direction :output
                                          :element-type '(unsigned-byte 8)
                                          :if-exists :error
                                          :if-does-not-exist :create)
          (write-sequence
           (map '(simple-array (unsigned-byte 8) (*)) #'char-code
                (format nil "pid ~a~c" (sb-posix:getpid) #\Linefeed))
           stream))
      (file-error ()
        (signal-pj0 'pj0-lock-failure
                    :store-id (journal-store-store-id store)
                    :requirement-id "PJ-LOCK-1"
                    :detail "exclusive writer lock is already held")))
    lock-path))

(defun %release-lock (lock-path)
  (ignore-errors (delete-file lock-path)))

(defmacro %with-writer-lock ((store) &body body)
  (let ((lock (gensym "LOCK")))
    `(let ((,lock (%acquire-lock ,store)))
       (unwind-protect (progn ,@body)
         (%release-lock ,lock)))))

;;; ---------------------------------------------------------------------------
;;; §9.4 append receipts.

(defstruct append-receipt
  record       ; the §9.4 CD/0 receipt record
  origin       ; :delivered | :reconstructed (PJ-APP-4 facet, caller-side)
  disposition  ; :newly-committed | :already-committed-identical
  ordinal)

(defun %make-receipt-record (store disposition event-id ordinal
                             payload-hex frame-hex previous-hex)
  (flet ((field (key value)
           (lisp-plus-cd0:make-record-entry (identifier-from-segments key)
                                            value)))
    (lisp-plus-cd0:make-record-datum
     (list
      (field '("receipt" "append-disposition")
             (identifier-from-segments
              (list "pj0" (ecase disposition
                            (:newly-committed "newly-committed")
                            (:already-committed-identical
                             "already-committed-identical")))))
      (field '("receipt" "declared-durability")
             (identifier-from-segments
              (list "pj0" (ecase (journal-store-durability store)
                            (:synced "synced")
                            (:best-effort "best-effort")))))
      (field '("receipt" "event-id") event-id)
      (field '("receipt" "frame-digest")
             (lisp-plus-cd0:make-bytes-datum (hex->octets frame-hex)))
      (field '("receipt" "ordinal")
             (lisp-plus-cd0:make-integer-datum ordinal))
      (field '("receipt" "payload-digest")
             (lisp-plus-cd0:make-bytes-datum (hex->octets payload-hex)))
      (field '("receipt" "previous-frame-digest")
             (lisp-plus-cd0:make-bytes-datum (hex->octets previous-hex)))
      (field '("receipt" "store-id")
             (record-field (journal-store-metadata store) "pj0" "store-id"))))))

;;; ---------------------------------------------------------------------------
;;; §9 append.

(defun append-event (store event-datum &key (origin :delivered))
  "The §9.2 serialized critical section.  EVENT-DATUM is a canonicalizable
CD/0 record carrying (id \"event\" \"event-id\").  Returns an APPEND-RECEIPT.
PJ-APP-1..3 idempotency; PJ-LOCK-1: the current terminal prefix is
revalidated under the lock and an interrupted predecessor append is NEVER
assumed to have failed."
  ;; §9.1: canonicalize before taking the lock where practical.
  (let ((payload (encode-pjs0 event-datum))
        (event-id (record-field event-datum "event" "event-id")))
    (unless (and event-id (lisp-plus-cd0:identifier-datum-p event-id))
      (signal-pj0 'pj0-interior-corruption
                  :requirement-id "PJ0-§12.14"
                  :detail "a proposed event requires (id \"event\" ~
                           \"event-id\")"))
    (%with-writer-lock (store)
      ;; Step 1 — reopen/validate the current terminal prefix (PJ-LOCK-1).
      (let* ((octets (or (%read-file-octets (%store-path store "EVENTS.pj0"))
                         (make-array 0 :element-type '(unsigned-byte 8))))
             (report (validate-event-octets octets
                                            (journal-store-store-id store))))
        ;; Step 2 — event-identity lookup over the valid prefix.  This comes
        ;; BEFORE any damage refusal: a predecessor writer may have committed
        ;; this very event and died pre-receipt (CW-3 / PJ-LOCK-1).
        ;; Identity matching uses CD/0 canonical identity (RESTITUTOR repair;
        ;; see %EVENT-ID-KEY in reader.lisp).
        (let ((target (%event-id-key event-id)))
          (loop for index below (fill-pointer (prefix-report-event-ids report))
                for candidate = (aref (prefix-report-event-ids report) index)
                when (string= (%event-id-key candidate) target)
                  do (let ((prior-payload
                             (encode-pjs0 (aref (prefix-report-events report)
                                                index))))
                       (if (%octets-equal-p prior-payload payload)
                           ;; Step 3 / PJ-APP-2 — identical: reconcile, do
                           ;; NOT append.
                           (return-from append-event
                             (make-append-receipt
                              :record (%make-receipt-record
                                       store :already-committed-identical
                                       event-id (1+ index)
                                       (sha256-hex payload)
                                       (aref (prefix-report-frame-digests
                                              report)
                                             index)
                                       (if (zerop index)
                                           +genesis-digest-hex+
                                           (aref (prefix-report-frame-digests
                                                  report)
                                                 (1- index))))
                              :origin origin
                              :disposition :already-committed-identical
                              :ordinal (1+ index)))
                           ;; Step 4 / PJ-APP-3 — conflicting: refuse.
                           ;; Last-write-wins is prohibited.
                           (with-pj0-restarts (:abandon t)
                             (signal-pj0 'pj0-event-identity-collision
                                         :store-id (journal-store-store-id
                                                    store)
                                         :requirement-id "PJ-APP-3"
                                         :detail
                                         (format nil
                                                 "event identity ~a is ~
                                                  committed with a different ~
                                                  payload at ordinal ~a"
                                                 (identifier-segment-string
                                                  event-id)
                                                 (1+ index))))))))
        ;; A damaged store accepts no new appends (§14.1: opening never
        ;; truncates; appending after a torn tail would bury it).
        (unless (eq (prefix-report-status report) :valid)
          (with-pj0-restarts (:abandon t :salvage (lambda () report))
            (signal-pj0 (prefix-report-condition-type report)
                        :store-id (journal-store-store-id store)
                        :byte-offset (prefix-report-tail-offset report)
                        :requirement-id (prefix-report-condition-requirement
                                         report)
                        :detail (format nil "append refused: ~a"
                                        (prefix-report-detail report)))))
        ;; Steps 5–7 — assign ordinal, construct frame with the current
        ;; terminal digest, append the exact frame bytes.
        (let* ((ordinal (1+ (prefix-report-frame-count report)))
               (previous (prefix-report-terminal-digest report)))
          (multiple-value-bind (frame frame-hex payload-hex)
              (render-frame-octets (journal-store-store-id store) ordinal
                                   payload previous)
            (with-open-file (stream (%store-path store "EVENTS.pj0")
                                    :direction :output
                                    :element-type '(unsigned-byte 8)
                                    :if-exists :append
                                    :if-does-not-exist :create)
              (write-sequence frame stream)
              (finish-output stream)
              ;; Step 8 — the declared durability barrier (§10; PJ-DUR-1/2:
              ;; the journal's declared mode, never promoted or demoted).
              (when (eq (journal-store-durability store) :synced)
                (%fsync-stream stream)))
            ;; Step 9 — reopen and validate the new terminal frame (§10.1
            ;; reference behavior in conformance tests).
            (let ((verify (validate-event-octets
                           (%read-file-octets (%store-path store "EVENTS.pj0"))
                           (journal-store-store-id store))))
              (unless (and (eq (prefix-report-status verify) :valid)
                           (= (prefix-report-frame-count verify) ordinal)
                           (string= (prefix-report-terminal-digest verify)
                                    frame-hex))
                (signal-pj0 'pj0-interior-corruption
                            :store-id (journal-store-store-id store)
                            :requirement-id "PJ0-§9.2"
                            :detail "post-append reopen validation failed")))
            ;; Step 10 — append receipt.  PJ-APP-5: the frame, not this
            ;; receipt object, is the primary fact.
            (make-append-receipt
             :record (%make-receipt-record store :newly-committed event-id
                                           ordinal payload-hex frame-hex
                                           previous)
             :origin origin
             :disposition :newly-committed
             :ordinal ordinal)))))))

(defun explain-journal (store)
  "§22: human view + canonical facts."
  (let ((report (validate-journal store)))
    (format nil "store ~a: ~a, ~a frame~:p, ~a valid byte~:p, terminal ~a~@[, ~
                 excluded tail ~a octet~:p (sha256 ~a)~]"
            (journal-store-store-id store)
            (prefix-report-status report)
            (prefix-report-frame-count report)
            (prefix-report-valid-byte-count report)
            (prefix-report-terminal-digest report)
            (and (prefix-report-tail-octets report)
                 (length (prefix-report-tail-octets report)))
            (prefix-report-tail-sha256 report))))
