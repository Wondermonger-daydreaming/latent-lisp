;;;; journal0-selftest.lisp — unit-level checks for the Process Journal /0
;;;; store.  Numbered [NNN] ok|FAIL verdicts; the final count is DERIVED from
;;;; the verdicts rendered, never hard-coded (house pattern).
;;;;
;;;; Run:  sbcl --script mneme/journal0/journal0-selftest.lisp
;;;; from the latent-lisp root (fixture paths are root-relative).

(load (merge-pathnames "load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-journal0)

(defvar *checks* 0)
(defvar *failures* 0)

(defun check (description thunk)
  (incf *checks*)
  (let ((outcome
          (handler-case (if (funcall thunk) :ok :fail)
            (error (condition)
              (list :error condition)))))
    (cond
      ((eq outcome :ok)
       (format t "[~3,'0d] ok   ~a~%" *checks* description))
      (t
       (incf *failures*)
       (format t "[~3,'0d] FAIL ~a~@[ (~a)~]~%" *checks* description
               (when (consp outcome) (second outcome)))))))

(defun expects (condition-type thunk)
  "True iff THUNK signals exactly CONDITION-TYPE (transferring via ABANDON
restart when one is offered)."
  (handler-case (progn (funcall thunk) nil)
    (error (condition) (typep condition condition-type))))

(defun ascii-octets (string)
  (map '(simple-array (unsigned-byte 8) (*)) #'char-code string))

(defun decode-status (text)
  (multiple-value-bind (datum status) (decode-pjs0 (ascii-octets text))
    (declare (ignore datum))
    status))

(defvar *scratch*
  (merge-pathnames
   "journal0-selftest-scratch/"
   (pathname (or (sb-posix:getenv "JOURNAL0_SCRATCH")
                 (format nil "/tmp/journal0-scratch-~a/" (sb-posix:getpid))))))

(defun scratch (name)
  (ensure-directories-exist (merge-pathnames name *scratch*)))

(defun fresh-scratch (name)
  (let ((directory (merge-pathnames name *scratch*)))
    (when (probe-file directory)
      (sb-ext:delete-directory directory :recursive t))
    (ensure-directories-exist directory)))

(defvar *fixtures* #p"mneme/architecture/process-journal-0/fixtures/")

(defun make-event (id-string &optional extra-body)
  "A minimal canonicalizable event record for writer tests."
  (flet ((field (key value)
           (lisp-plus-cd0:make-record-entry (identifier-from-segments key)
                                            value)))
    (lisp-plus-cd0:make-record-datum
     (append
      (list (field '("event" "event-id")
                   (identifier-from-segments (list "event" id-string)))
            (field '("event" "kind")
                   (identifier-from-segments '("selftest" "noted"))))
      (when extra-body
        (list (field '("event" "body")
                     (lisp-plus-cd0:make-string-datum extra-body))))))))

;;; --------------------------------------------------------------------------
;;; SHA-256 (FIPS 180-4 vectors + the spec's own genesis digest).

(check "sha256 FIPS: empty message"
  (lambda ()
    (string= (sha256-hex (ascii-octets ""))
             "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")))
(check "sha256 FIPS: abc"
  (lambda ()
    (string= (sha256-hex (ascii-octets "abc"))
             "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad")))
(check "sha256 FIPS: two-block message"
  (lambda ()
    (string= (sha256-hex (ascii-octets
                          "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"))
             "248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1")))
(check "genesis digest is SHA-256(PJ0-GENESIS-0) (§8.1)"
  (lambda ()
    (string= +genesis-digest-hex+
             (sha256-hex (ascii-octets "PJ0-GENESIS-0")))))
(check "genesis digest matches the frozen synced-demo metadata"
  (lambda ()
    (search "703ec8e3af3779ebc98dae5bd0e9aa791b18125eb1415656fa3f4bf5c16d63a6"
            +genesis-digest-hex+)))

;;; --------------------------------------------------------------------------
;;; Strict UTF-8 (PJ-READ-0 layer).

(check "utf8: overlong encoding rejected"
  (lambda ()
    (multiple-value-bind (scalars offset)
        (utf8-decode-scalars (coerce #(#xc0 #xaf) '(vector (unsigned-byte 8))))
      (and (null scalars) (eql offset 0)))))
(check "utf8: surrogate rejected"
  (lambda ()
    (multiple-value-bind (scalars offset)
        (utf8-decode-scalars (coerce #(#xed #xa0 #x80)
                                     '(vector (unsigned-byte 8))))
      (and (null scalars) (eql offset 0)))))
(check "utf8: truncated sequence rejected"
  (lambda ()
    (multiple-value-bind (scalars offset)
        (utf8-decode-scalars (coerce #(#xe2 #x82) '(vector (unsigned-byte 8))))
      (and (null scalars) (eql offset 0)))))
(check "utf8: 0xf5 lead byte rejected"
  (lambda ()
    (null (utf8-decode-scalars (coerce #(#xf5 #x80 #x80 #x80)
                                       '(vector (unsigned-byte 8)))))))
(check "utf8: bare continuation rejected"
  (lambda ()
    (null (utf8-decode-scalars (coerce #(#x80) '(vector (unsigned-byte 8)))))))
(check "utf8: four-octet scalar round-trips"
  (lambda ()
    (let ((octets (coerce #(#xf0 #x9f #x90 #xa6) '(vector (unsigned-byte 8)))))
      (multiple-value-bind (scalars offset) (utf8-decode-scalars octets)
        (and (null offset)
             (= 1 (length scalars))
             (= #x1f426 (aref scalars 0))
             (equalp (utf8-encode-scalars scalars) octets))))))

;;; --------------------------------------------------------------------------
;;; PJ-S/0 codec canonicality (§5, PJ-SYN-2; Annex E cases).

(check "codec: #u #t #f canonical"
  (lambda () (and (eq (decode-status "#u") :canonical)
                  (eq (decode-status "#t") :canonical)
                  (eq (decode-status "#f") :canonical))))
(check "codec: canonical integers"
  (lambda () (and (eq (decode-status "0") :canonical)
                  (eq (decode-status "-123456789") :canonical)
                  (eq (decode-status "100000000000000000000000000000000000000000000000000000000000000000000000000000000") :canonical))))
(check "codec: leading-zero integer noncanonical"
  (lambda () (eq (decode-status "007") :noncanonical)))
(check "codec: negative zero noncanonical"
  (lambda () (eq (decode-status "-0") :noncanonical)))
(check "codec: plus sign invalid"
  (lambda () (eq (decode-status "+7") :invalid)))
(check "codec: canonical rational (rat -355 113)"
  (lambda () (eq (decode-status "(rat -355 113)") :canonical)))
(check "codec: unreduced rational noncanonical (E-21)"
  (lambda () (eq (decode-status "(rat 4 2)") :noncanonical)))
(check "codec: denominator-one rational noncanonical (E-22)"
  (lambda () (eq (decode-status "(rat 3 1)") :noncanonical)))
(check "codec: negative denominator invalid"
  (lambda () (eq (decode-status "(rat 3 -2)") :invalid)))
(check "codec: newline as u{a} canonical (E-18)"
  (lambda () (eq (decode-status "\"a\\u{a}b\"") :canonical)))
(check "codec: raw newline in string invalid (E-17)"
  (lambda ()
    (eq (decode-status (format nil "\"a~cb\"" #\Linefeed)) :invalid)))
(check "codec: escaped printable scalar noncanonical (E-19)"
  (lambda () (eq (decode-status "\"\\u{41}\"") :noncanonical)))
(check "codec: uppercase escape hex noncanonical"
  (lambda () (eq (decode-status "\"\\u{A}\"") :noncanonical)))
(check "codec: surrogate escape invalid"
  (lambda () (eq (decode-status "\"\\u{d800}\"") :invalid)))
(check "codec: bytes lowercase canonical, empty canonical"
  (lambda () (and (eq (decode-status "#x\"00ff\"") :canonical)
                  (eq (decode-status "#x\"\"") :canonical))))
(check "codec: uppercase byte hex noncanonical (E-20)"
  (lambda () (eq (decode-status "#x\"00FF\"") :noncanonical)))
(check "codec: odd byte digit count invalid"
  (lambda () (eq (decode-status "#x\"0ff\"") :invalid)))
(check "codec: record key order reversed noncanonical (E-23)"
  (lambda ()
    (eq (decode-status
         "(rec ((id \"b\") #u) ((id \"a\") #u))")
        :noncanonical)))
(check "codec: duplicate record key invalid (E-24)"
  (lambda ()
    (eq (decode-status
         "(rec ((id \"a\") #u) ((id \"a\") #t))")
        :invalid)))
(check "codec: empty record and sequence canonical"
  (lambda () (and (eq (decode-status "(rec)") :canonical)
                  (eq (decode-status "(seq)") :canonical))))
(check "codec: doubled whitespace noncanonical"
  (lambda () (eq (decode-status "(seq  #u)") :noncanonical)))
(check "codec: trailing garbage noncanonical"
  (lambda () (eq (decode-status "#u #u") :noncanonical)))
(check "codec: empty identifier invalid"
  (lambda () (and (eq (decode-status "(id)") :invalid)
                  (eq (decode-status "(id \"\")") :invalid))))
(check "codec: PJ-S0-ALL-TYPES fixture round-trips canonically (C-01..05)"
  (lambda ()
    (let* ((octets (%read-file-octets
                    (merge-pathnames "positive/PJ-S0-ALL-TYPES.pjs"
                                     *fixtures*)))
           (body (subseq octets 0 (1- (length octets)))))
      (and (= #x0a (aref octets (1- (length octets))))
           (eq :canonical
               (nth-value 1 (decode-pjs0 body)))))))
(check "key order: corpus order, not CD/0 §14.3 ValueBytes order"
  (lambda ()
    (and (pjs0-key< (identifier-from-segments '("pj0" "cd0-version"))
                    (identifier-from-segments '("pj0" "store-id")))
         (pjs0-key< (identifier-from-segments '("fixture" "expected-error"))
                    (identifier-from-segments '("fixture" "id")))
         (pjs0-key< (identifier-from-segments '("a"))
                    (identifier-from-segments '("a" "b"))))))

;;; --------------------------------------------------------------------------
;;; Frame grammar + digests (§7/§8).

(check "header spelling: canonical decimals"
  (lambda () (and (canonical-decimal-p "0") (canonical-decimal-p "42")
                  (not (canonical-decimal-p "007"))
                  (not (canonical-decimal-p ""))
                  (not (canonical-decimal-p "4 2")))))
(check "header spelling: lowercase 64-hex"
  (lambda ()
    (and (lowercase-hex-64-p (make-string 64 :initial-element #\a))
         (not (lowercase-hex-64-p (make-string 64 :initial-element #\A)))
         (not (lowercase-hex-64-p (make-string 63 :initial-element #\a))))))
(check "frame digest + frame render reproduce frozen frame 1 (F-03)"
  (lambda ()
    (let* ((octets (%read-file-octets
                    (merge-pathnames "positive/synced-demo/EVENTS.pj0"
                                     *fixtures*)))
           (header-end (position #x0a octets))
           (header (map 'string #'code-char (subseq octets 0 header-end)))
           (fields (%split-single-sp header))
           (payload-length (parse-integer (fourth fields)))
           (payload (subseq octets (1+ header-end)
                            (+ 1 header-end payload-length)))
           (store-id "pj0-store:12b099a4b4fa66b1c4e07a1e076228d4a214588f558a35edf07523782fd1573c"))
      (multiple-value-bind (frame frame-hex)
          (render-frame-octets store-id 1 payload +genesis-digest-hex+)
        (and (string= frame-hex (seventh fields))
             (equalp frame (subseq octets 0 (length frame))))))))
(check "store identity derivation reproduces the frozen store id (F-01)"
  (lambda ()
    (let ((metadata (validate-metadata-octets
                     (%read-file-octets
                      (merge-pathnames "positive/synced-demo/JOURNAL-META.pjs"
                                       *fixtures*))
                     :sidecar-octets
                     (%read-file-octets
                      (merge-pathnames
                       "positive/synced-demo/JOURNAL-META.pjs.sha256"
                       *fixtures*)))))
      (string= (store-id-string metadata)
               "pj0-store:12b099a4b4fa66b1c4e07a1e076228d4a214588f558a35edf07523782fd1573c"))))

;;; --------------------------------------------------------------------------
;;; Reader terminal classification on synthetic stores (E-01..E-08).

(check "reader: empty event file is valid end at byte zero (E-01)"
  (lambda ()
    (let ((report (validate-event-octets
                   (make-array 0 :element-type '(unsigned-byte 8)) "pj0-store:x")))
      (and (eq (prefix-report-status report) :valid)
           (zerop (prefix-report-frame-count report))
           (string= (prefix-report-terminal-digest report)
                    +genesis-digest-hex+)))))

(fresh-scratch "unit-store/")
(defvar *unit-store*
  (create-journal (merge-pathnames "unit-store/" *scratch*)
                  :declared-durability "synced"))
(defvar *unit-receipt-1* (append-event *unit-store* (make-event "u-001" "one")))
(defvar *unit-receipt-2* (append-event *unit-store* (make-event "u-002" "two")))

(check "writer: two appends commit at ordinals 1 and 2 (PJ-APP-1)"
  (lambda ()
    (and (eq (append-receipt-disposition *unit-receipt-1*) :newly-committed)
         (= 1 (append-receipt-ordinal *unit-receipt-1*))
         (= 2 (append-receipt-ordinal *unit-receipt-2*))
         (let ((report (validate-journal *unit-store*)))
           (and (eq (prefix-report-status report) :valid)
                (= 2 (prefix-report-frame-count report)))))))
(check "writer: identical re-append reconciles without appending (PJ-APP-2)"
  (lambda ()
    (let ((before (sha256-hex (%read-file-octets
                               (merge-pathnames "unit-store/EVENTS.pj0"
                                                *scratch*))))
          (receipt (append-event *unit-store* (make-event "u-001" "one"))))
      (and (eq (append-receipt-disposition receipt)
               :already-committed-identical)
           (= 1 (append-receipt-ordinal receipt))
           (string= before
                    (sha256-hex (%read-file-octets
                                 (merge-pathnames "unit-store/EVENTS.pj0"
                                                  *scratch*))))))))
(check "writer: conflicting payload refuses, no last-write-wins (PJ-APP-3)"
  (lambda ()
    (let ((before (sha256-hex (%read-file-octets
                               (merge-pathnames "unit-store/EVENTS.pj0"
                                                *scratch*)))))
      (and (expects 'pj0-event-identity-collision
                    (lambda ()
                      (append-event *unit-store*
                                    (make-event "u-001" "DIFFERENT"))))
           (string= before
                    (sha256-hex (%read-file-octets
                                 (merge-pathnames "unit-store/EVENTS.pj0"
                                                  *scratch*))))))))
(check "identity: (id \"a:b\") and (id \"a\" \"b\") are distinct, not duplicates
       (RESTITUTOR repair regression — CD/0 identity, not joined strings)"
  (lambda ()
    (fresh-scratch "alias-store/")
    (let ((store (create-journal (merge-pathnames "alias-store/" *scratch*)))
          (event-a (lisp-plus-cd0:make-record-datum
                    (list (lisp-plus-cd0:make-record-entry
                           (identifier-from-segments '("event" "event-id"))
                           (identifier-from-segments '("a:b")))
                          (lisp-plus-cd0:make-record-entry
                           (identifier-from-segments '("event" "kind"))
                           (identifier-from-segments '("selftest" "noted"))))))
          (event-b (lisp-plus-cd0:make-record-datum
                    (list (lisp-plus-cd0:make-record-entry
                           (identifier-from-segments '("event" "event-id"))
                           (identifier-from-segments '("a" "b")))
                          (lisp-plus-cd0:make-record-entry
                           (identifier-from-segments '("event" "kind"))
                           (identifier-from-segments '("selftest" "noted")))))))
      (append-event store event-a)
      (append-event store event-b)
      (let ((report (validate-journal store)))
        (and (eq (prefix-report-status report) :valid)
             (= 2 (prefix-report-frame-count report)))))))
(check "writer: reconstructed receipt origin (PJ-APP-4)"
  (lambda ()
    (let ((receipt (append-event *unit-store* (make-event "u-002" "two")
                                 :origin :reconstructed)))
      (and (eq (append-receipt-origin receipt) :reconstructed)
           (eq (append-receipt-disposition receipt)
               :already-committed-identical)))))
(check "writer: held lock refuses with pj0-lock-failure (§11)"
  (lambda ()
    (let ((lock (merge-pathnames "unit-store/LOCK" *scratch*)))
      (%write-file-octets lock (ascii-octets "held"))
      (unwind-protect
           (expects 'pj0-lock-failure
                    (lambda ()
                      (append-event *unit-store* (make-event "u-003"))))
        (delete-file lock)))))
(check "reader: truncated frame classifies torn-tail, prefix intact (E-05/06)"
  (lambda ()
    (let* ((octets (%read-file-octets (merge-pathnames "unit-store/EVENTS.pj0"
                                                       *scratch*)))
           (report (validate-event-octets
                    (subseq octets 0 (- (length octets) 7))
                    (journal-store-store-id *unit-store*))))
      (and (eq (prefix-report-status report) :torn-tail)
           (= 1 (prefix-report-frame-count report))
           (eq (prefix-report-condition-type report) 'pj0-torn-tail)
           (prefix-report-tail-sha256 report)))))
(check "reader: complete payload missing frame LF is torn tail (E-07)"
  (lambda ()
    (let* ((octets (%read-file-octets (merge-pathnames "unit-store/EVENTS.pj0"
                                                       *scratch*)))
           (report (validate-event-octets
                    (subseq octets 0 (1- (length octets)))
                    (journal-store-store-id *unit-store*))))
      (and (eq (prefix-report-status report) :torn-tail)
           (= 1 (prefix-report-frame-count report))))))
(check "reader: trailing garbage — LF-complete line is corruption; LF-less
       bytes are a torn terminal header (Annex A step 5, PJ-TERM-1)"
  (lambda ()
    (let* ((octets (%read-file-octets (merge-pathnames "unit-store/EVENTS.pj0"
                                                       *scratch*)))
           (with-lf (concatenate '(vector (unsigned-byte 8))
                                 octets (ascii-octets "GARBAGE") #(#x0a)
                                 (ascii-octets "MORE")))
           (without-lf (concatenate '(vector (unsigned-byte 8))
                                    octets (ascii-octets "GARBAGE")))
           (corrupt-report (validate-event-octets
                            with-lf (journal-store-store-id *unit-store*)))
           (torn-report (validate-event-octets
                         without-lf (journal-store-store-id *unit-store*))))
      (and (eq (prefix-report-status corrupt-report) :corruption)
           (eq (prefix-report-condition-type corrupt-report)
               'pj0-header-invalid)
           (= 2 (prefix-report-frame-count corrupt-report))
           ;; Plausibility is not custody: LF-less trailing bytes classify as
           ;; a torn terminal header even when they could never open a frame.
           (eq (prefix-report-status torn-report) :torn-tail)
           (= 2 (prefix-report-frame-count torn-report))
           (prefix-report-tail-sha256 torn-report)))))
(check "writer: append onto a torn store refuses with pj0-torn-tail (§14.1)"
  (lambda ()
    (fresh-scratch "torn-store/")
    (let* ((source-octets (%read-file-octets
                           (merge-pathnames "unit-store/EVENTS.pj0" *scratch*))))
      (dolist (name '("JOURNAL-META.pjs" "JOURNAL-META.pjs.sha256"))
        (%write-file-octets (merge-pathnames (format nil "torn-store/~a" name)
                                             *scratch*)
                            (%read-file-octets
                             (merge-pathnames (format nil "unit-store/~a" name)
                                              *scratch*))))
      (%write-file-octets (merge-pathnames "torn-store/EVENTS.pj0" *scratch*)
                          (subseq source-octets 0
                                  (- (length source-octets) 7)))
      (let ((torn-store (open-store (merge-pathnames "torn-store/" *scratch*))))
        (and (expects 'pj0-torn-tail
                      (lambda ()
                        (append-event torn-store (make-event "u-101"))))
             ;; PJ-LOCK-1's other branch: the event already IN the valid
             ;; prefix reconciles even though the store is damaged behind it.
             (eq (append-receipt-disposition
                  (append-event torn-store (make-event "u-001" "one")))
                 :already-committed-identical))))))

;;; --------------------------------------------------------------------------
;;; Salvage (§14; PJ-SAL-1/2/3; R-PJ-1; K0E-16).

(check "salvage: source preserved, new identity, events preserved"
  (lambda ()
    (fresh-scratch "salvage-dest/")
    (sb-ext:delete-directory (merge-pathnames "salvage-dest/" *scratch*)
                             :recursive t)
    (let* ((source-directory (merge-pathnames "torn-store/" *scratch*))
           (before (sha256-hex (%read-file-octets
                                (merge-pathnames "EVENTS.pj0"
                                                 source-directory)))))
      (multiple-value-bind (destination receipt)
          (salvage-valid-prefix source-directory
                                (merge-pathnames "salvage-dest/" *scratch*)
                                '("selftest" "operator"))
        (let ((source-report (validate-journal
                              (open-store source-directory)))
              (destination-report (validate-journal destination)))
          (and
           ;; PJ-SAL-1: source bytes byte-identical.
           (string= before (sha256-hex (%read-file-octets
                                        (merge-pathnames "EVENTS.pj0"
                                                         source-directory))))
           (eq (prefix-report-status source-report) :torn-tail)
           ;; Destination: clean, same events, new identity.
           (eq (prefix-report-status destination-report) :valid)
           (= (prefix-report-frame-count destination-report)
              (prefix-report-frame-count source-report))
           (loop for index below (prefix-report-frame-count source-report)
                 always (lisp-plus-cd0:equal-datum
                         (aref (prefix-report-events source-report) index)
                         (aref (prefix-report-events destination-report)
                               index)))
           ;; PJ-SAL-2: frame digests regenerate.
           (not (string= (prefix-report-terminal-digest source-report)
                         (prefix-report-terminal-digest destination-report)))
           (not (string= (journal-store-store-id destination)
                         (store-id-string
                          (journal-store-metadata
                           (open-store source-directory)))))
           ;; R-PJ-1 origin facet on the receipt.
           (let ((origin (record-field receipt "salvage" "output-origin")))
             (and origin
                  (string= (identifier-segment-string origin)
                           "origin:derived")))))))))

;;; --------------------------------------------------------------------------
;;; Fold, reconstruction, unsupported reconstruction, merge.

(check "fold: seat resolution vacant / occupied / unsupported (PJ-FOLD-4)"
  (lambda ()
    (fresh-scratch "fold-store/")
    (let ((store (create-journal (merge-pathnames "fold-store/" *scratch*)))
          (seat '("seat" "s1")))
      (flet ((seat-event (id kind attempt)
               (lisp-plus-cd0:make-record-datum
                (list
                 (lisp-plus-cd0:make-record-entry
                  (identifier-from-segments '("event" "event-id"))
                  (identifier-from-segments (list "event" id)))
                 (lisp-plus-cd0:make-record-entry
                  (identifier-from-segments '("event" "kind"))
                  (identifier-from-segments kind))
                 (lisp-plus-cd0:make-record-entry
                  (identifier-from-segments '("event" "attempt"))
                  (identifier-from-segments (list "attempt" attempt)))
                 (lisp-plus-cd0:make-record-entry
                  (identifier-from-segments '("event" "seat-id"))
                  (identifier-from-segments seat))))))
        (and (eq :vacant (derive-seat-resolution store seat))
             (progn (append-event store (seat-event "f-001" '("attempt" "begun")
                                                    "a1"))
                    (eq :occupied (derive-seat-resolution store seat)))
             (progn (append-event store (seat-event "f-002" '("attempt" "begun")
                                                    "a2"))
                    (expects 'unsupported-reconstruction
                             (lambda () (derive-seat-resolution store seat))))
             (progn (append-event store
                                  (seat-event "f-003" '("attempt" "superseded")
                                              "a1"))
                    (eq :occupied (derive-seat-resolution store seat))))))))
(check "reconstruct: derived artifacts deleted first and attested (PJ-RCN-3)"
  (lambda ()
    (let* ((store (open-store (merge-pathnames "fold-store/" *scratch*)))
           (derived (merge-pathnames "fold-store/derived/snapshot.txt"
                                     *scratch*)))
      (ensure-directories-exist derived)
      (%write-file-octets derived (ascii-octets "stale snapshot"))
      (multiple-value-bind (view receipt)
          (reconstruct store '("lisp-plus-journal0" "fold" "event-ids" "0"))
        (let ((deleted (record-field receipt "reconstruction"
                                     "derived-artifacts-deleted"))
              (origin (record-field receipt "reconstruction" "origin")))
          (and view
               (null (probe-file derived))
               (= 1 (lisp-plus-cd0:sequence-datum-length deleted))
               (string= (identifier-segment-string origin)
                        "origin:reconstructed")))))))
(check "reconstruct: beyond the validated prefix refused (K0E-11)"
  (lambda ()
    (let ((store (open-store (merge-pathnames "fold-store/" *scratch*))))
      (expects 'unsupported-reconstruction
               (lambda ()
                 (reconstruct store '("lisp-plus-journal0" "fold" "0")
                              :requested-terminal-ordinal 99))))))
(check "merge: explicit precedence merges; duplicates coalesce (§20)"
  (lambda ()
    (fresh-scratch "merge-a/") (fresh-scratch "merge-b/")
    (fresh-scratch "merge-out/")
    (sb-ext:delete-directory (merge-pathnames "merge-out/" *scratch*)
                             :recursive t)
    (let ((a (create-journal (merge-pathnames "merge-a/" *scratch*)))
          (b (create-journal (merge-pathnames "merge-b/" *scratch*))))
      (append-event a (make-event "m-001" "shared"))
      (append-event a (make-event "m-002" "only-a"))
      (append-event b (make-event "m-001" "shared"))
      (append-event b (make-event "m-003" "only-b"))
      (multiple-value-bind (destination receipt)
          (merge-journals (list (merge-pathnames "merge-a/" *scratch*)
                                (merge-pathnames "merge-b/" *scratch*))
                          '(0 1)
                          (merge-pathnames "merge-out/" *scratch*)
                          '("selftest" "operator"))
        (let ((report (validate-journal destination))
              (coalesced (record-field receipt "merge"
                                       "coalesced-duplicates")))
          (and (eq (prefix-report-status report) :valid)
               (= 3 (prefix-report-frame-count report))
               (= 1 (lisp-plus-cd0:sequence-datum-length coalesced))))))))
(check "merge: missing explicit precedence refused (PJ-MRG-1 / E-40)"
  (lambda ()
    (expects 'pj0-merge-receipt-required
             (lambda ()
               (merge-journals (list (merge-pathnames "merge-a/" *scratch*))
                               nil
                               (merge-pathnames "merge-never/" *scratch*)
                               '("selftest" "operator"))))))
(check "merge: conflicting duplicate refused (E-42)"
  (lambda ()
    (fresh-scratch "merge-c/")
    (let ((c (create-journal (merge-pathnames "merge-c/" *scratch*))))
      (append-event c (make-event "m-001" "CONFLICT"))
      (expects 'pj0-event-identity-collision
               (lambda ()
                 (merge-journals
                  (list (merge-pathnames "merge-a/" *scratch*)
                        (merge-pathnames "merge-c/" *scratch*))
                  '(0 1)
                  (merge-pathnames "merge-never2/" *scratch*)
                  '("selftest" "operator")))))))
(check "merge: causal predecessor inversion refused (E-43)"
  (lambda ()
    (expects 'pj0-merge-causal-conflict
             (lambda ()
               (merge-journals
                (list (merge-pathnames "merge-a/" *scratch*)
                      (merge-pathnames "merge-b/" *scratch*))
                '(0 1)
                (merge-pathnames "merge-never3/" *scratch*)
                '("selftest" "operator")
                :causal-predecessors '(("event:m-003" "event:m-002")))))))

;;; --------------------------------------------------------------------------
;;; Joint structural+semantic report (K0E-26; Errata §8 control 10).

(check "joint report: demo store carries TWO verdicts, structural pass"
  (lambda ()
    (let* ((store (open-store (merge-pathnames "positive/synced-demo/"
                                               *fixtures*)))
           (report (joint-structural-semantic-report store)))
      (and (eq :pass (getf (getf report :structural-verdict) :value))
           (member (getf (getf report :semantic-verdict) :value)
                   '(:pass :fail))
           (= 7 (getf report :frame-count))))))
(check "joint report: kernel-illegal event in valid bytes = dual standing"
  (lambda ()
    (fresh-scratch "illegal-store/")
    (let ((store (create-journal (merge-pathnames "illegal-store/" *scratch*))))
      ;; attempt-begun with a seat that was never reserved: structurally a
      ;; perfect frame, semantically illegal under Kernel §13.5.
      (append-event
       store
       (lisp-plus-cd0:make-record-datum
        (list
         (lisp-plus-cd0:make-record-entry
          (identifier-from-segments '("event" "event-id"))
          (identifier-from-segments '("event" "x-001")))
         (lisp-plus-cd0:make-record-entry
          (identifier-from-segments '("event" "kind"))
          (identifier-from-segments '("attempt" "begun")))
         (lisp-plus-cd0:make-record-entry
          (identifier-from-segments '("event" "attempt"))
          (identifier-from-segments '("attempt" "x1")))
         (lisp-plus-cd0:make-record-entry
          (identifier-from-segments '("event" "seat-id"))
          (identifier-from-segments '("seat" "never-reserved"))))))
      (let ((report (joint-structural-semantic-report store)))
        (and (eq :pass (getf (getf report :structural-verdict) :value))
             (eq :fail (getf (getf report :semantic-verdict) :value))
             (member 'lisp-plus-kernel0:journal-illegal-transition
                     (getf (getf report :semantic-verdict)
                           :condition-ids)))))))
(check "joint report: torn tail carries evidence + could-hide-settlement"
  (lambda ()
    (let ((store (open-store (merge-pathnames "torn-store/" *scratch*))))
      (let ((report (joint-structural-semantic-report store)))
        (and (eq :fail (getf (getf report :structural-verdict) :value))
             (getf report :tail-evidence)
             (getf report :tail-could-hide-settlement-p))))))

;;; --------------------------------------------------------------------------
;;; Conditions and bounds.

(check "conditions: all 21 §23 types are pj0 conditions"
  (lambda ()
    (every (lambda (name)
             (subtypep name 'pj0-condition))
           '(pj0-metadata-invalid pj0-store-id-mismatch
             pj0-noncanonical-payload pj0-invalid-utf8 pj0-header-invalid
             pj0-ordinal-gap pj0-payload-length-invalid
             pj0-payload-digest-mismatch pj0-previous-digest-mismatch
             pj0-frame-digest-mismatch pj0-frame-separator-invalid
             pj0-torn-tail pj0-interior-corruption
             pj0-event-identity-collision pj0-duplicate-committed-event
             pj0-lock-failure pj0-durability-barrier-failure
             pj0-salvage-receipt-required pj0-merge-receipt-required
             pj0-merge-causal-conflict unsupported-reconstruction))))
(check "conditions: lawful restarts offered at a validation signal (PJ-CND-2)"
  (lambda ()
    (let ((restart-names nil))
      (handler-bind
          ((pj0-torn-tail
             (lambda (condition)
               (declare (ignore condition))
               (setf restart-names
                     (mapcar #'restart-name (compute-restarts)))
               (invoke-restart 'abandon))))
        (validate-journal (open-store (merge-pathnames "torn-store/" *scratch*))
                          :signal t))
      (and (member 'abandon restart-names)
           (member 'inspect-evidence restart-names)
           (member 'salvage-to-new-store restart-names)))))
(check "bounds: §34 refusal is a resource condition, not corruption (E-49)"
  (lambda ()
    (let ((*pjs0-bounds* (let ((bounds (make-pjs0-bounds)))
                           (setf (pjs0-bounds-max-nesting-depth bounds) 2)
                           bounds)))
      (expects 'pj0-resource-bound-exceeded
               (lambda ()
                 (decode-pjs0 (ascii-octets "(seq (seq (seq #u)))")))))))
(check "mutants: all six §28 modes are distinct and named"
  (lambda () (= 6 (length (remove-duplicates +planted-defects+)))))

;;; --------------------------------------------------------------------------
;;; Result — count DERIVED from verdicts rendered.

(format t "~%journal0-selftest: ~a check~:p, ~a failure~:p~%"
        *checks* *failures*)
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
