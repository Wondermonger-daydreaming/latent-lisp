;;;; reader.lisp — §12 reader / prefix-validation and §13 terminal
;;;; classification.
;;;;
;;;; PJ-READ-0 (PJ0-PRESEAL-REPAIRS R-PJ-2): all journal reads are raw octets
;;;; in binary mode; the octets reach this validator untouched.
;;;; PJ-VAL-1: return maximal valid prefix, terminal classification, terminal
;;;; digest, valid byte count, and evidence for any excluded tail.
;;;; PJ-VAL-2: never mutate the source.  PJ-TERM-1: never scan forward past
;;;; corruption — plausibility is not custody.
;;;;
;;;; *VALIDATOR-DEFECT* hosts the §28 planted defective modes (mutants.lisp);
;;;; NIL is the strict conforming validator.

(in-package #:lisp-plus-journal0)

(defvar *validator-defect* nil
  "NIL (strict) or one of the §28 planted defect keywords:
:ignore-payload-hash :ignore-prev-chain :accept-noncanonical
:interior-as-tail :duplicate-last-write-wins :ignore-ordinal")

(defvar *max-header-octets* 4096
  "§34 configured bound on header length.")

(defstruct prefix-report
  ;; :valid | :torn-tail | :corruption
  (status :valid)
  (frame-count 0)
  (valid-byte-count 0)
  ;; Lowercase-hex digest of the last valid frame (genesis when none).
  (terminal-digest nil)
  ;; Vectors, index = ordinal - 1.
  (events nil)
  (event-ids nil)
  (frame-digests nil)
  ;; For an excluded tail: the §23 condition type, its requirement id, and
  ;; the exact tail evidence (offset, octets, sha256) per PJ-VAL-1/PJ-TRN-2.
  (condition-type nil)
  (condition-requirement nil)
  (tail-offset nil)
  (tail-octets nil)
  (tail-sha256 nil)
  (detail nil))

(defun %ascii-string (octets start end)
  "OCTETS[START,END) as a host string when all octets are ASCII, else NIL."
  (let ((string (make-string (- end start))))
    (loop for index from start below end
          for octet = (aref octets index)
          do (if (< octet #x80)
                 (setf (char string (- index start)) (code-char octet))
                 (return-from %ascii-string nil)))
    string))

(defun %event-id-key (identifier)
  "Collision-free hash-table key for an event identity: lowercase hex of the
identifier's CD/0 canonical octets.  (RESTITUTOR repair, 2026-07-29: the
inherited key was IDENTIFIER-SEGMENT-STRING, under which the distinct
identifiers (id \"a:b\") and (id \"a\" \"b\") alias to one string — a false
duplicate the §12 step-15 / CD/0-equality law does not license.)
CANONICAL-OCTETS returns CD/0's read-only octet-string wrapper; its own
OCTETS-TO-HEX renders it."
  (lisp-plus-cd0:octets-to-hex (lisp-plus-cd0:canonical-octets identifier)))

(defun %split-single-sp (string)
  "Split STRING on single ASCII SP separators.  An empty field (leading,
trailing, or doubled SP) yields NIL — malformed."
  (let ((fields '()) (start 0))
    (loop for position = (position #\Space string :start start)
          do (let ((field (subseq string start (or position (length string)))))
               (when (zerop (length field))
                 (return-from %split-single-sp nil))
               (push field fields)
               (if position
                   (setf start (1+ position))
                   (return))))
    (reverse fields)))

(defun validate-event-octets (octets store-id-string
                              &key (defect *validator-defect*))
  "Validate raw EVENTS.pj0 OCTETS against STORE-ID-STRING per §12/§13.
Returns a PREFIX-REPORT.  Never signals for classification outcomes (the
report carries the §23 condition type); §34 bound refusals do signal."
  (let ((length (length octets))
        (offset 0)
        (expected-ordinal 1)
        (previous-digest +genesis-digest-hex+)
        (events (make-array 8 :fill-pointer 0 :adjustable t))
        (event-ids (make-array 8 :fill-pointer 0 :adjustable t))
        (frame-digests (make-array 8 :fill-pointer 0 :adjustable t))
        (seen-ids (make-hash-table :test #'equal)))
    (labels
        ((finish (status &key condition-type requirement tail-start detail)
           (let ((tail (when (and tail-start (< tail-start length))
                         (subseq octets tail-start length))))
             (make-prefix-report
              :status status
              :frame-count (fill-pointer events)
              :valid-byte-count (or tail-start length)
              :terminal-digest previous-digest
              :events events
              :event-ids event-ids
              :frame-digests frame-digests
              :condition-type condition-type
              :condition-requirement requirement
              :tail-offset tail-start
              :tail-octets tail
              :tail-sha256 (when tail (sha256-hex tail))
              :detail detail)))
         (torn (requirement tail-start detail)
           (finish :torn-tail
                   :condition-type 'pj0-torn-tail
                   :requirement requirement
                   :tail-start tail-start
                   :detail detail))
         (corrupt (condition-type requirement tail-start detail)
           ;; §28 defect 4: downgrade interior corruption to torn tail.
           (if (eq defect :interior-as-tail)
               (finish :torn-tail
                       :condition-type 'pj0-torn-tail
                       :requirement "DEFECT:interior-as-tail"
                       :tail-start tail-start
                       :detail detail)
               (finish :corruption
                       :condition-type condition-type
                       :requirement requirement
                       :tail-start tail-start
                       :detail detail))))
      (loop
        (when (>= offset length)
          ;; §13.1: EOF after a complete frame (or empty file) is valid end.
          (return-from validate-event-octets (finish :valid)))
        (let* ((frame-start offset)
               (header-search-end (min length (+ frame-start
                                                 *max-header-octets*)))
               (header-lf (position #x0a octets :start frame-start
                                                :end header-search-end)))
          ;; Step 1 — complete header LF or terminal partial header.
          (unless header-lf
            (if (< (- length frame-start) *max-header-octets*)
                (return-from validate-event-octets
                  (torn "PJ0-§13.2" frame-start "partial header at EOF"))
                (%bound-refusal "max-header-octets" (- length frame-start))))
          (let ((header-string (%ascii-string octets frame-start header-lf)))
            ;; Step 2 — ASCII header encoding.
            (unless header-string
              (return-from validate-event-octets
                (corrupt 'pj0-header-invalid "PJ0-§7" frame-start
                         "non-ASCII octet in header")))
            ;; Step 3 — field count, magic, version.
            (let ((fields (%split-single-sp header-string)))
              (unless (and fields (= (length fields) 7))
                (return-from validate-event-octets
                  (corrupt 'pj0-header-invalid "PJ0-§7.1" frame-start
                           (format nil "header field count ~a, need 7"
                                   (length fields)))))
              (destructuring-bind (magic version ordinal-field length-field
                                   payload-hex previous-hex frame-hex)
                  fields
                (unless (string= magic "PJ0F")
                  (return-from validate-event-octets
                    (corrupt 'pj0-header-invalid "PJ0-§7.1" frame-start
                             "bad frame magic")))
                (unless (string= version "0")
                  (return-from validate-event-octets
                    (corrupt 'pj0-header-invalid "PJ0-§7.1" frame-start
                             "bad frame format version")))
                ;; Step 4 — canonical decimal and lowercase digest syntax.
                (unless (canonical-decimal-p ordinal-field)
                  (return-from validate-event-octets
                    (corrupt 'pj0-header-invalid "PJ-FRM-2" frame-start
                             "noncanonical ordinal spelling")))
                (unless (canonical-decimal-p length-field)
                  (return-from validate-event-octets
                    (corrupt 'pj0-payload-length-invalid "PJ-FRM-2" frame-start
                             "noncanonical payload-length spelling")))
                (unless (and (lowercase-hex-64-p payload-hex)
                             (lowercase-hex-64-p previous-hex)
                             (lowercase-hex-64-p frame-hex))
                  (return-from validate-event-octets
                    (corrupt 'pj0-header-invalid "PJ-FRM-2" frame-start
                             "digest field is not lowercase 64-hex")))
                (let ((ordinal (parse-integer ordinal-field))
                      (payload-length (parse-integer length-field)))
                  ;; Step 5 — expected ordinal (§28 defect 6 skips).
                  (unless (or (eq defect :ignore-ordinal)
                              (= ordinal expected-ordinal))
                    (return-from validate-event-octets
                      (corrupt 'pj0-ordinal-gap "PJ0-§12.5" frame-start
                               (format nil "ordinal ~a where ~a expected"
                                       ordinal expected-ordinal))))
                  (when (> payload-length
                           (pjs0-bounds-max-payload-length *pjs0-bounds*))
                    (%bound-refusal "max-payload-length" payload-length))
                  ;; Step 6 — exact payload length availability.
                  (let* ((payload-start (1+ header-lf))
                         (separator-position (+ payload-start payload-length)))
                    (when (> separator-position length)
                      (return-from validate-event-octets
                        (torn "PJ0-§13.2" frame-start
                              "payload shorter than declared at EOF")))
                    ;; Step 7 — required frame-separator LF.
                    (when (= separator-position length)
                      (return-from validate-event-octets
                        (torn "PJ0-§13.2" frame-start
                              "complete payload with missing frame LF")))
                    (unless (= #x0a (aref octets separator-position))
                      (return-from validate-event-octets
                        (corrupt 'pj0-frame-separator-invalid "PJ0-§7.2"
                                 frame-start
                                 "non-LF octet at frame separator")))
                    (let ((payload (subseq octets payload-start
                                           separator-position)))
                      ;; Step 8 — payload SHA-256 (§28 defect 1 skips).
                      (unless (or (eq defect :ignore-payload-hash)
                                  (string= (sha256-hex payload) payload-hex))
                        (return-from validate-event-octets
                          (corrupt 'pj0-payload-digest-mismatch "PJ-HASH-1"
                                   frame-start "payload digest mismatch")))
                      ;; Step 9 — predecessor digest (§28 defect 2 skips).
                      (unless (or (eq defect :ignore-prev-chain)
                                  (string= previous-hex previous-digest))
                        (return-from validate-event-octets
                          (corrupt 'pj0-previous-digest-mismatch "PJ-HASH-1"
                                   frame-start
                                   "predecessor digest mismatch")))
                      ;; Step 10 — frame digest over metadata store identity.
                      (unless (string= (frame-digest-hex store-id-string
                                                         ordinal
                                                         payload-length
                                                         payload-hex
                                                         previous-hex)
                                       frame-hex)
                        (return-from validate-event-octets
                          (corrupt 'pj0-frame-digest-mismatch "PJ-HASH-1"
                                   frame-start "frame digest mismatch")))
                      ;; Steps 11–13 — strict UTF-8, PJ-S/0 parse, canonical
                      ;; re-rendering byte identity (§28 defect 3 skips 13).
                      (multiple-value-bind (datum status detail)
                          (decode-pjs0 payload)
                        (when (eq status :invalid-utf8)
                          (return-from validate-event-octets
                            (corrupt 'pj0-invalid-utf8 "PJ0-§12.11"
                                     frame-start detail)))
                        (when (eq status :invalid)
                          (return-from validate-event-octets
                            (corrupt 'pj0-noncanonical-payload "PJ-SYN-1"
                                     frame-start detail)))
                        (when (and (eq status :noncanonical)
                                   (not (eq defect :accept-noncanonical)))
                          (return-from validate-event-octets
                            (corrupt 'pj0-noncanonical-payload "PJ-SYN-2"
                                     frame-start detail)))
                        ;; Step 14 — required structural event identity.
                        (let ((event-id
                                (and (lisp-plus-cd0:record-datum-p datum)
                                     (record-field datum "event" "event-id"))))
                          (unless (and event-id
                                       (lisp-plus-cd0:identifier-datum-p
                                        event-id))
                            (return-from validate-event-octets
                              (corrupt 'pj0-interior-corruption "PJ0-§12.14"
                                       frame-start
                                       "missing structural event identity")))
                          ;; Step 15 — duplicate committed identity
                          ;; prohibition (§28 defect 5 accepts, last wins).
                          (let ((id-key (%event-id-key event-id)))
                            (when (and (gethash id-key seen-ids)
                                       (not (eq defect
                                                :duplicate-last-write-wins)))
                              (return-from validate-event-octets
                                (corrupt 'pj0-duplicate-committed-event
                                         "PJ0-§13.3" frame-start
                                         (format nil
                                                 "duplicate committed ~
                                                  event identity ~a"
                                                 id-key))))
                            (setf (gethash id-key seen-ids) t))
                          ;; Frame commits.  Step 16 (Kernel semantic fold)
                          ;; is the caller's semantic partner: fold.lisp.
                          (vector-push-extend datum events)
                          (vector-push-extend event-id event-ids)
                          (vector-push-extend frame-hex frame-digests)
                          (setf previous-digest frame-hex
                                expected-ordinal (1+ expected-ordinal)
                                offset (1+ separator-position)))))))))))))))
