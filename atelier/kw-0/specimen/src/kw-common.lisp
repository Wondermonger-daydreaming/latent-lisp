;;;; kw-common.lisp — Killed Witness shared substrate.
;;;; Frame format KWJ0 (PJ0-subset):
;;;;   magic "KWJ0"(4) || payload-len u32be(4) || payload(n)
;;;;   || md5(payload)(16) || prev-frame-digest(16) || frame-digest(16)
;;;;   frame-digest = md5(magic||len||payload||payload-digest||prev-digest)
;;;; Digest algorithm: MD5, pedagogical — matches the lab's own v1 practice;
;;;; real crypto is owed-ledger item 1. Recorded in ASSUMPTIONS.md.
;;;; Payloads: CD/0 documents (the project's own canonical datum substrate),
;;;; so the Python folder decodes with the project's own codec.

(require :sb-md5)
(require :sb-posix)

(load (merge-pathnames "canonical-datum/common-lisp/package.lisp"
                       *kw-repo-root*))
(load (merge-pathnames "canonical-datum/common-lisp/cd0.lisp"
                       *kw-repo-root*))

(defpackage #:kw
  (:use #:cl)
  (:export #:id #:str #:int #:event-datum #:encode-event #:decode-event
           #:field #:field-int
           #:open-journal #:append-frame #:append-event #:close-journal
           #:fsync-journal #:journal-synced
           #:validate-prefix #:fold-state #:classify-recovery
           #:sha-file-hex #:digest-hex #:journal-frame-payload
           #:journal-frame-frame-digest))

(in-package #:kw)

;;; --- CD0 helpers ---------------------------------------------------------

(defun id (path) (lisp-plus-cd0:make-identifier-datum '("kw") (list path)))
(defun str (s) (lisp-plus-cd0:make-string-datum s))
(defun int (n) (lisp-plus-cd0:make-integer-datum n))

(defun event-datum (alist)
  "ALIST of (field-name . string-or-integer) -> CD0 record datum."
  (lisp-plus-cd0:make-record-datum
   (mapcar (lambda (cell)
             (lisp-plus-cd0:make-record-entry
              (id (car cell))
              (etypecase (cdr cell)
                (string (str (cdr cell)))
                (integer (int (cdr cell))))))
           alist)))

(defun v2o (vec)
  "Host vector -> CD0 immutable octet-string (internal constructor; the codec's
   public surface is deliberately narrow, so the specimen says so here)."
  (lisp-plus-cd0::%make-octet-string (copy-seq vec) :trusted t))

(defun o2v (octet-string)
  "CD0 immutable octet-string -> host vector."
  (let* ((n (lisp-plus-cd0:octets-length octet-string))
         (v (make-array n :element-type '(unsigned-byte 8))))
    (dotimes (i n v) (setf (aref v i) (lisp-plus-cd0:octets-ref octet-string i)))))

(defun encode-event (datum) (o2v (lisp-plus-cd0:encode-exact datum)))

(defun decode-event (octets) (lisp-plus-cd0:decode-exact (v2o octets)))

(defun field (datum name)
  "String value of record field NAME, or NIL if absent."
  (dotimes (i (lisp-plus-cd0:record-datum-size datum))
    (let ((key (lisp-plus-cd0:record-datum-key-at datum i)))
      (when (and (lisp-plus-cd0:identifier-datum-p key)
                 (string= (lisp-plus-cd0:identifier-datum-path-segment key (1- (lisp-plus-cd0:identifier-datum-path-count key)))
                          name))
        (let ((v (lisp-plus-cd0:record-datum-value-at datum i)))
          (return (if (lisp-plus-cd0:string-datum-p v)
                      (lisp-plus-cd0:string-datum-value v)
                      nil)))))))

(defun field-int (datum name)
  "Integer value of record field NAME, or NIL."
  (dotimes (i (lisp-plus-cd0:record-datum-size datum))
    (let ((key (lisp-plus-cd0:record-datum-key-at datum i)))
      (when (and (lisp-plus-cd0:identifier-datum-p key)
                 (string= (lisp-plus-cd0:identifier-datum-path-segment key (1- (lisp-plus-cd0:identifier-datum-path-count key)))
                          name))
        (let ((v (lisp-plus-cd0:record-datum-value-at datum i)))
          (return (if (lisp-plus-cd0:integer-datum-p v)
                      (lisp-plus-cd0:integer-datum-value v)
                      nil)))))))

;;; --- digests --------------------------------------------------------------

(defun md5-octets (&rest octet-vectors)
  (let ((ctx (sb-md5:make-md5-state)))
    (dolist (v octet-vectors) (sb-md5:update-md5-state ctx v))
    (sb-md5:finalize-md5-state ctx)))

(defun digest-hex (octets)
  (with-output-to-string (s)
    (loop for b across octets do (format s "~2,'0x" b))))

(defun sha-file-hex (path)
  "MD5 of file contents, hex. (Pedagogical digest; see header note.)"
  (with-open-file (in path :element-type '(unsigned-byte 8))
    (let* ((len (file-length in))
           (buf (make-array len :element-type '(unsigned-byte 8))))
      (read-sequence buf in)
      (digest-hex (md5-octets buf)))))

;;; --- journal writer --------------------------------------------------------

(defstruct (journal (:constructor %make-journal))
  stream path (prev-digest (make-array 16 :element-type '(unsigned-byte 8)
                                        :initial-element 0))
  (synced nil) (frames 0))

(defstruct journal-frame payload payload-digest frame-digest offset end-offset)

(defconstant +magic+ #(75 87 74 48))          ; "KWJ0"

(defun open-journal (path)
  "Open for append. The chain head is recomputed from the valid prefix;
   appending across a torn tail is refused (a torn tail demands an explicit
   truncation decision, not a silent write)."
  (let ((prev (make-array 16 :element-type '(unsigned-byte 8) :initial-element 0)))
    (when (and (probe-file path)
               (plusp (with-open-file (s path) (file-length s))))
      (multiple-value-bind (frames status detail) (validate-prefix path)
        (unless (member status '(:clean :clean-empty))
          (error "refusing to append to ~A: ~A (~A)" path status detail))
        (when frames
          (setf prev (journal-frame-frame-digest (car (last frames)))))))
    (let ((stream (open path :direction :output :element-type '(unsigned-byte 8)
                             :if-exists :append :if-does-not-exist :create)))
      (%make-journal :stream stream :path path :prev-digest prev))))

(defun u32be (n)
  (vector (ldb (byte 8 24) n) (ldb (byte 8 16) n)
          (ldb (byte 8 8) n) (ldb (byte 8 0) n)))

(defun write-frame-bytes (stream payload prev-digest &key truncate-at)
  "Write one frame; TRUNCATE-AT simulates a mid-frame death (harness only)."
  (let* ((pd (md5-octets payload))
         (head (concatenate '(vector (unsigned-byte 8)) +magic+ (u32be (length payload))))
         (fd (md5-octets head payload pd prev-digest))
         (full (concatenate '(vector (unsigned-byte 8)) head payload pd prev-digest fd)))
    (write-sequence (if truncate-at (subseq full 0 truncate-at) full) stream)
    fd))

(defun append-frame (journal payload &key (sync t) truncate-at)
  "Append one frame. SYNC=T issues fsync before returning (receipt barrier).
   TRUNCATE-AT writes a partial frame (death-harness instrumentation only)."
  (let* ((stream (journal-stream journal))
         (fd (write-frame-bytes stream payload (journal-prev-digest journal)
                                :truncate-at truncate-at)))
    (finish-output stream)
    (when (and sync (not truncate-at))
      (sb-posix:fsync (sb-sys:fd-stream-fd stream))
      (setf (journal-synced journal) t))
    (unless truncate-at
      (setf (journal-prev-digest journal) fd)
      (incf (journal-frames journal)))
    fd))

(defun append-event (journal alist &key (sync t) truncate-at)
  (append-frame journal (encode-event (event-datum alist))
                :sync sync :truncate-at truncate-at))

(defun fsync-journal (journal)
  (sb-posix:fsync (sb-sys:fd-stream-fd (journal-stream journal)))
  (setf (journal-synced journal) t))

(defun close-journal (journal)
  (close (journal-stream journal)))

;;; --- prefix validator ------------------------------------------------------

(defun validate-prefix (path)
  "Return (values frames status detail). Frames = valid prefix frames.
   Status: :clean-empty | :clean | :torn-tail | :prefix-invalid."
  (with-open-file (in path :element-type '(unsigned-byte 8)
                           :if-does-not-exist nil)
    (unless in (return-from validate-prefix
                 (values nil :clean-empty "no journal file")))
    (let* ((len (file-length in))
           (buf (make-array len :element-type '(unsigned-byte 8)))
           (frames '())
           (pos 0)
           (prev (make-array 16 :element-type '(unsigned-byte 8)
                                 :initial-element 0)))
      (read-sequence buf in)
      (loop
        (when (= pos len) (return))
        (let* ((header-end (+ pos 8))
               (remaining (- len pos)))
          (when (< remaining 8)
            (return-from validate-prefix
              (values (nreverse frames) :torn-tail
                      (format nil "partial header at offset ~D (~D bytes)" pos remaining))))
          (unless (equalp (subseq buf pos (+ pos 4)) +magic+)
            (return-from validate-prefix
              (values (nreverse frames) :prefix-invalid
                      (format nil "bad magic at offset ~D" pos))))
          (let* ((plen (+ (* (aref buf (+ pos 4)) 16777216)
                          (* (aref buf (+ pos 5)) 65536)
                          (* (aref buf (+ pos 6)) 256)
                          (aref buf (+ pos 7))))
                 (frame-end (+ header-end plen 48)))
            (when (> frame-end len)
              (return-from validate-prefix
                (values (nreverse frames) :torn-tail
                        (format nil "partial frame at offset ~D (need ~D, have ~D)"
                                pos frame-end len))))
            (let* ((payload (subseq buf header-end (+ header-end plen)))
                   (pd-stored (subseq buf (+ header-end plen) (+ header-end plen 16)))
                   (prev-stored (subseq buf (+ header-end plen 16) (+ header-end plen 32)))
                   (fd-stored (subseq buf (+ header-end plen 32) frame-end))
                   (pd (md5-octets payload))
                   (head (subseq buf pos header-end))
                   (fd (md5-octets head payload pd prev)))
              (unless (equalp pd pd-stored)
                (return-from validate-prefix
                  (values (nreverse frames) :prefix-invalid
                          (format nil "payload digest mismatch at offset ~D" pos))))
              (unless (equalp prev-stored prev)
                (return-from validate-prefix
                  (values (nreverse frames) :prefix-invalid
                          (format nil "chain break at offset ~D" pos))))
              (unless (equalp fd fd-stored)
                (return-from validate-prefix
                  (values (nreverse frames) :prefix-invalid
                          (format nil "frame digest mismatch at offset ~D" pos))))
              (push (make-journal-frame :payload payload :payload-digest pd
                                        :frame-digest fd :offset pos
                                        :end-offset frame-end)
                    frames)
              (setf prev fd pos frame-end)))))
      (values (nreverse frames)
              (if frames :clean :clean-empty)
              "complete prefix"))))

;;; --- fold ------------------------------------------------------------------

(defun fold-state (frames)
  "Fold valid prefix frames into derived state (an alist).
   Deterministic: same prefix -> same state. No side inputs.
   Uncertainty is DERIVED from the event pattern (§14 semantics): an attempt
   that crossed the frontier with no settlement and no finalizer has an
   uncertain effect. It is not asserted by any single frame."
  (let ((begun '()) (crossed '()) (settled '()) (terminal '())
        (superseded '()) (supersessions '()) (receipts '()) (manifestations '())
        (seats '()))
    (dolist (f frames)
      (let ((d (ignore-errors (decode-event (journal-frame-payload f)))))
        (when d
          (let ((et (field d "event-type"))
                (aid (field d "attempt-id")))
            (cond
              ((string= et "seat-reserved") (push (field d "seat-id") seats))
              ((string= et "attempt-begun") (push aid begun))
              ((string= et "frontier-crossed") (pushnew aid crossed :test #'string=))
              ((string= et "effect-settled")
               (pushnew aid settled :test #'string=))
              ((member et '("attempt-completed" "attempt-failed" "attempt-reconciled")
                       :test #'string=)
               (pushnew aid terminal :test #'string=)
               (when (string= et "attempt-completed") (push f receipts)))
              ((string= et "attempt-superseded")
               (pushnew (field d "predecessor-attempt-id") superseded :test #'string=)
               (push d supersessions))
              ((string= et "manifestation-recorded") (push d manifestations)))))))
    (let ((uncertain (remove-if-not
                      (lambda (a) (and (member a crossed :test #'string=)
                                       (not (member a settled :test #'string=))
                                       (not (member a terminal :test #'string=))
                                       (not (member a superseded :test #'string=))))
                      begun)))
      (list (cons "seats" (nreverse seats))
            (cons "attempts" (nreverse begun))
            (cons "frontier-crossed" crossed)
            (cons "uncertain-effects" uncertain)
            (cons "settled-effects" settled)
            (cons "terminal" terminal)
            (cons "superseded" superseded)
            (cons "supersessions" (length supersessions))
            (cons "receipt-frames" (length receipts))
            (cons "manifestation-frames" (length manifestations))))))

;;; --- recovery classification (F1: observable states only) -----------------

(defun classify-recovery (path)
  "Classify ONLY what surviving bytes warrant. Never infers the causal window.
   Observable states (F1): no append / torn tail / effect settlement
   unresolved / complete frame present; durable-receipt standing absent /
   complete durable prefix. Where bytes cannot distinguish two causes,
   the ambiguity IS the answer."
  (multiple-value-bind (frames status detail) (validate-prefix path)
    (let ((state (fold-state frames)))
      (list (cons "prefix-status" (string-downcase (symbol-name status)))
            (cons "prefix-detail" detail)
            (cons "valid-frames" (length frames))
            (cons "uncertain-effects" (cdr (assoc "uncertain-effects" state :test #'string=)))
            (cons "classification"
                  (cond ((eq status :torn-tail) "torn tail")
                        ((cdr (assoc "uncertain-effects" state :test #'string=))
                         "effect settlement unresolved")
                        ((and (cdr (assoc "settled-effects" state :test #'string=))
                              (zerop (cdr (assoc "receipt-frames" state :test #'string=))))
                         "complete frame present; durable-receipt standing absent")
                        ((eq status :clean-empty) "no append")
                        ;; frames exist, but none begins an attempt: the phrase
                        ;; is defined RELATIVE TO THE INTERRUPTED FRAME, not
                        ;; the journal (owner's S2 wording correction)
                        ((null (cdr (assoc "attempts" state :test #'string=)))
                         "no attempt append")
                        (t "complete durable prefix")))))))
