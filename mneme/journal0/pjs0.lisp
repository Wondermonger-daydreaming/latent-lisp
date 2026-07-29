;;;; pjs0.lisp — the PJ-S/0 canonical human-readable datum codec (§5).
;;;;
;;;; Written FRESH from the §5 ABNF.  PJ-SYN-1: no host READ, no reader
;;;; macros, no symbol interning while decoding — the parser below is a data
;;;; parser over Unicode scalars decoded by this file's own strict UTF-8
;;;; layer.  PJ-SYN-2: decode → canonical re-encode → byte identity, refused
;;;; otherwise.  PJ-SYN-3: the abstract domain, identifier ordering, and
;;;; equality are Canonical Datum /0's (lisp-plus-cd0); PJ-S/0 is a text
;;;; RENDERING of that domain — CD/0's binary octets are never the payload
;;;; bytes.
;;;;
;;;; Identifier rendering convention (documented decision, §5.8 + CD/0 §11):
;;;; PJ-S/0 `(id s1 ... sn)` maps to CD/0 Id(namespace=[s1..s(n-1)],
;;;; path=[sn]).  The map is a bijection between PJ-S/0 identifier texts and
;;;; the CD/0 sub-domain of identifiers whose path has exactly one segment;
;;;; a CD/0 identifier with a multi-segment path has no PJ-S/0 rendering here
;;;; and is refused on encode.  Evidence for the convention: the store
;;;; identity's public string form "pj0-store:HEX" (§8.3) joins namespace and
;;;; path with a colon, and every frozen fixture identifier is expressible in
;;;; this sub-domain (proven by the byte-identity gate over the whole packet).

(in-package #:lisp-plus-journal0)

;;; ---------------------------------------------------------------------------
;;; §34 bounds — refusal is a resource condition, never a corruption claim.

(defstruct (pjs0-bounds (:constructor make-pjs0-bounds ()))
  (max-payload-length 16777216 :type fixnum)
  (max-nesting-depth 256 :type fixnum)
  (max-string-scalars 4194304 :type fixnum)
  (max-bytes-octets 4194304 :type fixnum)
  (max-identifier-segments 64 :type fixnum)
  (max-record-entries 65536 :type fixnum)
  (max-sequence-items 1048576 :type fixnum))

(defvar *pjs0-bounds* (make-pjs0-bounds))

(defun %bound-refusal (which value)
  (signal-pj0 'pj0-resource-bound-exceeded
              :requirement-id "PJ0-§34"
              :detail (format nil "configured bound ~a refused value ~a"
                              which value)))

;;; ---------------------------------------------------------------------------
;;; Strict UTF-8 (PJ-READ-0 rides above this: journal bytes are read in
;;; binary mode; this layer is the ONLY place octets become scalars).

(defun utf8-decode-scalars (octets &key (start 0) (end (length octets)))
  "Strictly decode OCTETS[START,END) to a vector of Unicode scalar values.
Returns (values scalar-vector nil) or (values nil error-offset).  Rejects
overlong forms, surrogates, scalars above #x10FFFF, truncated sequences, and
invalid continuation bytes."
  (let ((scalars (make-array (- end start) :fill-pointer 0))
        (index start))
    (loop while (< index end) do
      (let ((b0 (aref octets index)))
        (cond
          ((< b0 #x80)
           (vector-push b0 scalars)
           (incf index))
          ((< b0 #xc2)                  ; #x80..#xC1: continuation or overlong
           (return-from utf8-decode-scalars (values nil index)))
          ((< b0 #xe0)                  ; two octets
           (when (> (+ index 2) end)
             (return-from utf8-decode-scalars (values nil index)))
           (let ((b1 (aref octets (+ index 1))))
             (unless (<= #x80 b1 #xbf)
               (return-from utf8-decode-scalars (values nil index)))
             (vector-push (logior (ash (logand b0 #x1f) 6) (logand b1 #x3f))
                          scalars)
             (incf index 2)))
          ((< b0 #xf0)                  ; three octets
           (when (> (+ index 3) end)
             (return-from utf8-decode-scalars (values nil index)))
           (let ((b1 (aref octets (+ index 1)))
                 (b2 (aref octets (+ index 2))))
             (unless (and (<= #x80 b1 #xbf) (<= #x80 b2 #xbf))
               (return-from utf8-decode-scalars (values nil index)))
             (let ((scalar (logior (ash (logand b0 #x0f) 12)
                                   (ash (logand b1 #x3f) 6)
                                   (logand b2 #x3f))))
               (when (or (< scalar #x800)          ; overlong
                         (<= #xd800 scalar #xdfff)) ; surrogate
                 (return-from utf8-decode-scalars (values nil index)))
               (vector-push scalar scalars)
               (incf index 3))))
          ((< b0 #xf5)                  ; four octets
           (when (> (+ index 4) end)
             (return-from utf8-decode-scalars (values nil index)))
           (let ((b1 (aref octets (+ index 1)))
                 (b2 (aref octets (+ index 2)))
                 (b3 (aref octets (+ index 3))))
             (unless (and (<= #x80 b1 #xbf) (<= #x80 b2 #xbf) (<= #x80 b3 #xbf))
               (return-from utf8-decode-scalars (values nil index)))
             (let ((scalar (logior (ash (logand b0 #x07) 18)
                                   (ash (logand b1 #x3f) 12)
                                   (ash (logand b2 #x3f) 6)
                                   (logand b3 #x3f))))
               (when (or (< scalar #x10000) (> scalar #x10ffff))
                 (return-from utf8-decode-scalars (values nil index)))
               (vector-push scalar scalars)
               (incf index 4))))
          (t                            ; #xF5..#xFF: never valid
           (return-from utf8-decode-scalars (values nil index))))))
    (values scalars nil)))

(defun utf8-encode-scalars (scalars)
  "Encode a sequence of Unicode scalar values as UTF-8 octets."
  (let ((octets (make-array (* 4 (length scalars))
                            :element-type '(unsigned-byte 8) :fill-pointer 0)))
    (map nil
         (lambda (scalar)
           (cond
             ((< scalar #x80) (vector-push scalar octets))
             ((< scalar #x800)
              (vector-push (logior #xc0 (ash scalar -6)) octets)
              (vector-push (logior #x80 (logand scalar #x3f)) octets))
             ((< scalar #x10000)
              (vector-push (logior #xe0 (ash scalar -12)) octets)
              (vector-push (logior #x80 (logand (ash scalar -6) #x3f)) octets)
              (vector-push (logior #x80 (logand scalar #x3f)) octets))
             (t
              (vector-push (logior #xf0 (ash scalar -18)) octets)
              (vector-push (logior #x80 (logand (ash scalar -12) #x3f)) octets)
              (vector-push (logior #x80 (logand (ash scalar -6) #x3f)) octets)
              (vector-push (logior #x80 (logand scalar #x3f)) octets))))
         scalars)
    (let ((exact (make-array (fill-pointer octets)
                             :element-type '(unsigned-byte 8))))
      (replace exact octets)
      exact)))

;;; ---------------------------------------------------------------------------
;;; Identifier helpers — the documented (id s1 .. sn) <-> CD/0 convention.

(defun identifier-from-segments (segments)
  "SEGMENTS (a list of host strings, length >= 1) to a CD/0 identifier:
namespace = all but the last segment, path = the last segment."
  (lisp-plus-cd0:make-identifier-datum (butlast segments)
                                       (last segments)))

(defun identifier-segments (identifier)
  "All segments of a CD/0 identifier in PJ-S/0 rendering order
(namespace segments, then path segments), as host strings."
  (append
   (loop for index below (lisp-plus-cd0:identifier-datum-namespace-count
                          identifier)
         collect (lisp-plus-cd0:identifier-datum-namespace-segment
                  identifier index))
   (loop for index below (lisp-plus-cd0:identifier-datum-path-count identifier)
         collect (lisp-plus-cd0:identifier-datum-path-segment
                  identifier index))))

(defun identifier-segment-string (identifier &key (separator ":"))
  "Segments joined with SEPARATOR — e.g. the §8.3 public store-id string."
  (format nil (format nil "~~{~~a~~^~a~~}" separator)
          (identifier-segments identifier)))

(defun record-field (record &rest segments)
  "Value of the RECORD field whose key is (id . SEGMENTS); NIL if absent."
  (multiple-value-bind (value presentp)
      (lisp-plus-cd0:record-datum-ref record (identifier-from-segments segments))
    (values (and presentp value) presentp)))

;;; ---------------------------------------------------------------------------
;;; Parser — recursive descent over the scalar vector.  A parse failure
;;; throws %PJS0-PARSE with an offset and reason; the caller maps it to the
;;; strict-reader's classification.  No interning, no evaluation, no host
;;; READ (PJ-SYN-1, §34).

(defstruct (%cursor (:constructor %make-cursor (scalars)))
  (scalars nil)
  (index 0 :type fixnum)
  (depth 0 :type fixnum))

(defun %parse-fail (cursor reason)
  (throw '%pjs0-parse (list :invalid (%cursor-index cursor) reason)))

(defun %peek (cursor)
  (let ((scalars (%cursor-scalars cursor))
        (index (%cursor-index cursor)))
    (when (< index (length scalars)) (aref scalars index))))

(defun %next (cursor)
  (let ((scalar (%peek cursor)))
    (unless scalar (%parse-fail cursor "unexpected end of payload"))
    (incf (%cursor-index cursor))
    scalar))

(defun %whitespace-p (scalar)
  (member scalar '(#x20 #x09 #x0a #x0d)))

(defun %skip-whitespace (cursor)
  (loop while (let ((scalar (%peek cursor)))
                (and scalar (%whitespace-p scalar)))
        do (incf (%cursor-index cursor))))

(defun %expect (cursor scalar what)
  (let ((got (%next cursor)))
    (unless (eql got scalar)
      (%parse-fail cursor (format nil "expected ~a" what)))))

(defun %digit-p (scalar) (<= #x30 scalar #x39))

(defun %hex-value (scalar)
  (cond ((%digit-p scalar) (- scalar #x30))
        ((<= #x61 scalar #x66) (+ 10 (- scalar #x61)))   ; a-f
        ((<= #x41 scalar #x46) (+ 10 (- scalar #x41)))   ; A-F (parseable;
        (t nil)))                                        ; canonicality later)

(defun %parse-integer-token (cursor)
  "Lenient integer token: optional '-', one or more digits.  Canonicality
(no leading zero, no negative zero, no '+') is adjudicated by the re-encode
byte-identity gate (PJ-SYN-2)."
  (let ((negative nil)
        (digits '()))
    (when (eql (%peek cursor) #x2d)     ; -
      (setf negative t)
      (%next cursor))
    (loop while (let ((scalar (%peek cursor)))
                  (and scalar (%digit-p scalar)))
          do (push (- (%next cursor) #x30) digits))
    (when (null digits)
      (%parse-fail cursor "malformed integer"))
    (let ((value 0))
      (dolist (digit (reverse digits))
        (setf value (+ (* value 10) digit)))
      (if negative (- value) value))))

(defun %parse-string-token (cursor)
  "String literal.  Raw control scalars inside the literal are invalid
(E-17); escapes are limited to \\\" \\\\ and \\u{hex}; \\u{...} must name a
Unicode scalar value."
  (%expect cursor #x22 "string open quote")
  (let ((scalars (make-array 16 :fill-pointer 0 :adjustable t)))
    (loop
      (let ((scalar (%next cursor)))
        (cond
          ((eql scalar #x22)            ; closing quote
           (return))
          ((eql scalar #x5c)            ; backslash
           (let ((escape (%next cursor)))
             (cond
               ((eql escape #x22) (vector-push-extend #x22 scalars))
               ((eql escape #x5c) (vector-push-extend #x5c scalars))
               ((eql escape #x75)       ; u
                (%expect cursor #x7b "'{' in \\u escape")
                (let ((value 0) (count 0))
                  (loop for next = (%next cursor)
                        until (eql next #x7d)
                        do (let ((hex (%hex-value next)))
                             (unless hex
                               (%parse-fail cursor "bad \\u escape digit"))
                             (setf value (+ (* value 16) hex))
                             (incf count)
                             (when (> count 8)
                               (%parse-fail cursor "oversized \\u escape"))))
                  (when (zerop count)
                    (%parse-fail cursor "empty \\u escape"))
                  (when (or (> value #x10ffff) (<= #xd800 value #xdfff))
                    (%parse-fail cursor "\\u escape is not a Unicode scalar"))
                  (vector-push-extend value scalars)))
               (t (%parse-fail cursor "unknown escape")))))
          ((or (< scalar #x20) (eql scalar #x7f))
           (%parse-fail cursor "raw control scalar inside string literal"))
          (t (vector-push-extend scalar scalars)))
        (when (> (fill-pointer scalars)
                 (pjs0-bounds-max-string-scalars *pjs0-bounds*))
          (%bound-refusal "max-string-scalars" (fill-pointer scalars)))))
    (let ((string (make-string (fill-pointer scalars))))
      (loop for index below (fill-pointer scalars)
            do (setf (char string index)
                     (code-char (aref scalars index))))
      string)))

(defun %parse-bytes-token (cursor)
  ;; Caller consumed "#x".  Lenient about hex case (canonicality is the byte
  ;; identity gate's job); odd digit count is invalid.
  (%expect cursor #x22 "byte-string open quote")
  (let ((nibbles '()))
    (loop for scalar = (%next cursor)
          until (eql scalar #x22)
          do (let ((hex (%hex-value scalar)))
               (unless hex (%parse-fail cursor "bad byte-string digit"))
               (push hex nibbles)
               (when (> (length nibbles)
                        (* 2 (pjs0-bounds-max-bytes-octets *pjs0-bounds*)))
                 (%bound-refusal "max-bytes-octets" (length nibbles)))))
    (let ((nibbles (reverse nibbles)))
      (when (oddp (length nibbles))
        (%parse-fail cursor "odd byte-string digit count"))
      (let ((octets (make-array (/ (length nibbles) 2)
                                :element-type '(unsigned-byte 8))))
        (loop for (high low) on nibbles by #'cddr
              for index from 0
              do (setf (aref octets index) (logior (ash high 4) low)))
        octets))))

(defun %parse-word (cursor)
  "Lowercase ASCII word after '(' — rat / id / seq / rec."
  (let ((chars '()))
    (loop while (let ((scalar (%peek cursor)))
                  (and scalar (<= #x61 scalar #x7a)))
          do (push (code-char (%next cursor)) chars))
    (coerce (reverse chars) 'string)))

(defun %cd0-guard (cursor thunk)
  "Run THUNK; a CD/0 constructor refusal (duplicate key, empty segment, ...)
is an invalid payload, not a host error."
  (handler-case (funcall thunk)
    (lisp-plus-cd0:cd0-failure (failure)
      (%parse-fail cursor (format nil "CD/0 refusal: ~a"
                                  (lisp-plus-cd0:failure-code failure))))))

(defun %parse-datum (cursor)
  (when (> (incf (%cursor-depth cursor))
           (pjs0-bounds-max-nesting-depth *pjs0-bounds*))
    (%bound-refusal "max-nesting-depth" (%cursor-depth cursor)))
  (prog1
      (let ((scalar (%peek cursor)))
        (unless scalar (%parse-fail cursor "expected datum"))
        (cond
          ((eql scalar #x23)            ; #
           (%next cursor)
           (let ((tag (%next cursor)))
             (cond
               ((eql tag #x75) (lisp-plus-cd0:make-unit-datum))       ; u
               ((eql tag #x74) (lisp-plus-cd0:make-boolean-datum t))  ; t
               ((eql tag #x66) (lisp-plus-cd0:make-boolean-datum nil)); f
               ((eql tag #x78)                                        ; x
                (%cd0-guard cursor
                            (lambda ()
                              (lisp-plus-cd0:make-bytes-datum
                               (%parse-bytes-token cursor)))))
               (t (%parse-fail cursor "unknown # form")))))
          ((eql scalar #x22)            ; string
           (%cd0-guard cursor
                       (lambda ()
                         (lisp-plus-cd0:make-string-datum
                          (%parse-string-token cursor)))))
          ((or (%digit-p scalar) (eql scalar #x2d))
           (%cd0-guard cursor
                       (lambda ()
                         (lisp-plus-cd0:make-integer-datum
                          (%parse-integer-token cursor)))))
          ((eql scalar #x28)            ; (
           (%next cursor)
           (let ((word (%parse-word cursor)))
             (cond
               ((string= word "rat") (%parse-rational cursor))
               ((string= word "id") (%parse-identifier cursor))
               ((string= word "seq") (%parse-sequence cursor))
               ((string= word "rec") (%parse-record cursor))
               (t (%parse-fail cursor "unknown compound form")))))
          (t (%parse-fail cursor "unexpected scalar"))))
    (decf (%cursor-depth cursor))))

(defun %parse-rational (cursor)
  (%skip-whitespace cursor)
  (let ((numerator (%parse-integer-token cursor)))
    (%skip-whitespace cursor)
    (let ((denominator (%parse-integer-token cursor)))
      (%skip-whitespace cursor)
      (%expect cursor #x29 "')' closing rat")
      (when (minusp denominator)
        (%parse-fail cursor "rational denominator must be positive"))
      (when (zerop denominator)
        (%parse-fail cursor "rational denominator must be nonzero"))
      ;; CD/0 normalizes; a noncanonical spelling ((rat 4 2), (rat 3 1)) parses
      ;; here and is refused by the byte-identity gate.
      (%cd0-guard cursor
                  (lambda ()
                    (lisp-plus-cd0:make-rational-datum numerator denominator))))))

(defun %parse-identifier (cursor)
  (let ((segments '()))
    (loop
      (%skip-whitespace cursor)
      (let ((scalar (%peek cursor)))
        (cond
          ((eql scalar #x29) (%next cursor) (return))
          ((eql scalar #x22)
           (push (%parse-string-token cursor) segments)
           (when (> (length segments)
                    (pjs0-bounds-max-identifier-segments *pjs0-bounds*))
             (%bound-refusal "max-identifier-segments" (length segments))))
          (t (%parse-fail cursor "identifier expects string segments")))))
    (when (null segments)
      (%parse-fail cursor "identifier requires at least one segment"))
    (%cd0-guard cursor
                (lambda () (identifier-from-segments (reverse segments))))))

(defun %parse-sequence (cursor)
  (let ((elements '()))
    (loop
      (%skip-whitespace cursor)
      (let ((scalar (%peek cursor)))
        (cond
          ((eql scalar #x29) (%next cursor) (return))
          ((null scalar) (%parse-fail cursor "unterminated sequence"))
          (t (push (%parse-datum cursor) elements)
             (when (> (length elements)
                      (pjs0-bounds-max-sequence-items *pjs0-bounds*))
               (%bound-refusal "max-sequence-items" (length elements)))))))
    (%cd0-guard cursor
                (lambda ()
                  (lisp-plus-cd0:make-sequence-datum (reverse elements))))))

(defun %parse-record (cursor)
  (let ((entries '()))
    (loop
      (%skip-whitespace cursor)
      (let ((scalar (%peek cursor)))
        (cond
          ((eql scalar #x29) (%next cursor) (return))
          ((eql scalar #x28)
           (%next cursor)
           (%skip-whitespace cursor)
           ;; Field key: an (id ...) form.
           (%expect cursor #x28 "'(' opening record key")
           (let ((word (%parse-word cursor)))
             (unless (string= word "id")
               (%parse-fail cursor "record key must be an identifier")))
           (let ((key (%parse-identifier cursor)))
             (%skip-whitespace cursor)
             (let ((value (%parse-datum cursor)))
               (%skip-whitespace cursor)
               (%expect cursor #x29 "')' closing record field")
               (push (%cd0-guard cursor
                                 (lambda ()
                                   (lisp-plus-cd0:make-record-entry key value)))
                     entries)
               (when (> (length entries)
                        (pjs0-bounds-max-record-entries *pjs0-bounds*))
                 (%bound-refusal "max-record-entries" (length entries))))))
          (t (%parse-fail cursor "malformed record field")))))
    ;; CD/0's constructor sorts canonically (§14.3) and rejects duplicates.
    ;; Source order is NOT preserved; noncanonical source order is refused by
    ;; the byte-identity gate.
    (%cd0-guard cursor
                (lambda ()
                  (lisp-plus-cd0:make-record-datum (reverse entries))))))

;;; ---------------------------------------------------------------------------
;;; PJ-S/0 record-key ordering — NAMED DIVERGENCE, adjudicated to the frozen
;;; corpus (see JOURNAL-0-COMPARISON notes and README).
;;;
;;; §5.10 says record keys "appear in Canonical Datum /0 identifier order."
;;; CD/0's only defined record-field order (CD/0 §14.3) compares the keys'
;;; canonical binary ValueBytes — which are LENGTH-PREFIXED, so
;;; (id "pj0" "store-id") sorts BEFORE (id "pj0" "cd0-version") under §14.3
;;; (8 < 11 in the varint length byte).  Every frozen positive vector,
;;; however, orders keys by plain unsigned lexicographic comparison of the
;;; segment octets themselves ("cd0-version" first).  The two orders are
;;; irreconcilable; the §24-normative fixture corpus defines the byte-level
;;; rendering that PJ-SYN-2's byte-identity gate is anchored to, so this
;;; codec implements the corpus order: compare segments pairwise in
;;; rendering order (namespace, then path), each by unsigned lexicographic
;;; octet comparison of its UTF-8 bytes; a segment-list prefix sorts first.
;;; Identifier EQUALITY (duplicate detection) still delegates to CD/0.

(defun %segment-octets-list (identifier)
  (mapcar (lambda (segment)
            (utf8-encode-scalars
             (map 'vector #'char-code segment)))
          (identifier-segments identifier)))

(defun %octets< (left right)
  (loop for index below (min (length left) (length right))
        do (let ((l (aref left index)) (r (aref right index)))
             (cond ((< l r) (return-from %octets< :less))
                   ((> l r) (return-from %octets< :greater)))))
  (cond ((< (length left) (length right)) :less)
        ((> (length left) (length right)) :greater)
        (t :equal)))

(defun pjs0-key< (left-identifier right-identifier)
  "The PJ-S/0 rendering order over record keys (corpus-adjudicated)."
  (loop for left in (%segment-octets-list left-identifier)
        for right in (%segment-octets-list right-identifier)
        do (ecase (%octets< left right)
             (:less (return-from pjs0-key< t))
             (:greater (return-from pjs0-key< nil))
             (:equal)))
  (< (length (identifier-segments left-identifier))
     (length (identifier-segments right-identifier))))

;;; ---------------------------------------------------------------------------
;;; Canonical renderer — CD/0 datum to canonical PJ-S/0 octets.

(defun %render-scalar-string (string emit)
  "Render STRING as a canonical PJ-S/0 string token via EMIT (per §5.6)."
  (funcall emit #x22)
  (loop for character across string
        for scalar = (char-code character)
        do (cond
             ((eql scalar #x22) (funcall emit #x5c) (funcall emit #x22))
             ((eql scalar #x5c) (funcall emit #x5c) (funcall emit #x5c))
             ((or (< scalar #x20) (eql scalar #x7f))
              ;; \u{h} with lowercase minimal hex.
              (funcall emit #x5c) (funcall emit #x75) (funcall emit #x7b)
              (let ((hex (format nil "~(~x~)" scalar)))
                (loop for hex-char across hex
                      do (funcall emit (char-code hex-char))))
              (funcall emit #x7d))
             (t (funcall emit scalar))))
  (funcall emit #x22))

(defun %render-ascii (string emit)
  (loop for character across string
        do (funcall emit (char-code character))))

(defun %render-datum (datum emit)
  (cond
    ((lisp-plus-cd0:unit-datum-p datum) (%render-ascii "#u" emit))
    ((lisp-plus-cd0:boolean-datum-p datum)
     (%render-ascii (if (lisp-plus-cd0:boolean-datum-value datum) "#t" "#f")
                    emit))
    ((lisp-plus-cd0:integer-datum-p datum)
     (%render-ascii (format nil "~d" (lisp-plus-cd0:integer-datum-value datum))
                    emit))
    ((lisp-plus-cd0:rational-datum-p datum)
     (%render-ascii (format nil "(rat ~d ~d)"
                            (lisp-plus-cd0:rational-datum-numerator datum)
                            (lisp-plus-cd0:rational-datum-denominator datum))
                    emit))
    ((lisp-plus-cd0:string-datum-p datum)
     (%render-scalar-string (lisp-plus-cd0:string-datum-value datum) emit))
    ((lisp-plus-cd0:bytes-datum-p datum)
     (%render-ascii "#x\"" emit)
     ;; BYTES-DATUM-VALUE returns a fresh host octet vector (CD/0 public
     ;; behavior), not the octet-string wrapper.
     (let ((octets (lisp-plus-cd0:bytes-datum-value datum)))
       (loop for index below (length octets)
             for octet = (aref octets index)
             do (funcall emit (char-code (char +hex-digits+ (ash octet -4))))
                (funcall emit (char-code (char +hex-digits+
                                               (logand octet #xf))))))
     (funcall emit #x22))
    ((lisp-plus-cd0:identifier-datum-p datum)
     (%render-ascii "(id" emit)
     (dolist (segment (identifier-segments datum))
       (funcall emit #x20)
       (%render-scalar-string segment emit))
     (funcall emit #x29))
    ((lisp-plus-cd0:sequence-datum-p datum)
     (%render-ascii "(seq" emit)
     (loop for index below (lisp-plus-cd0:sequence-datum-length datum)
           do (funcall emit #x20)
              (%render-datum (lisp-plus-cd0:sequence-datum-ref datum index)
                             emit))
     (funcall emit #x29))
    ((lisp-plus-cd0:record-datum-p datum)
     ;; Fields render in PJ-S/0 corpus order (PJS0-KEY<), NOT CD/0 §14.3
     ;; ValueBytes order — see the named divergence above.
     (%render-ascii "(rec" emit)
     (let ((pairs (sort (loop for index below (lisp-plus-cd0:record-datum-size
                                               datum)
                              collect (cons (lisp-plus-cd0:record-datum-key-at
                                             datum index)
                                            (lisp-plus-cd0:record-datum-value-at
                                             datum index)))
                        #'pjs0-key< :key #'car)))
       (dolist (pair pairs)
         (funcall emit #x20)
         (funcall emit #x28)
         (%render-datum (car pair) emit)
         (funcall emit #x20)
         (%render-datum (cdr pair) emit)
         (funcall emit #x29)))
     (funcall emit #x29))
    (t (signal-pj0 'pj0-noncanonical-payload
                   :requirement-id "PJ-SYN-3"
                   :detail "unrenderable value is not a CD/0 datum"))))

(defun encode-pjs0 (datum)
  "Canonical PJ-S/0 octets of a CD/0 DATUM."
  (let ((scalars (make-array 256 :fill-pointer 0 :adjustable t)))
    (%render-datum datum (lambda (scalar) (vector-push-extend scalar scalars)))
    (utf8-encode-scalars scalars)))

(defun %octets-equal-p (left right)
  (and (= (length left) (length right))
       (loop for index below (length left)
             always (= (aref left index) (aref right index)))))

(defun decode-pjs0 (octets)
  "Decode payload OCTETS as one canonical PJ-S/0 datum.
Returns (values datum status detail):
  :canonical     — datum decoded AND canonical re-encoding is byte-identical;
  :noncanonical  — parseable, but re-encoding differs (PJ-SYN-2 refusal) or
                   trailing garbage after the datum;
  :invalid       — not parseable as PJ-S/0 (datum is NIL);
  :invalid-utf8  — OCTETS are not strict UTF-8 (datum is NIL).
A §34 bound refusal signals PJ0-RESOURCE-BOUND-EXCEEDED instead of returning."
  (when (> (length octets) (pjs0-bounds-max-payload-length *pjs0-bounds*))
    (%bound-refusal "max-payload-length" (length octets)))
  (multiple-value-bind (scalars error-offset) (utf8-decode-scalars octets)
    (when error-offset
      (return-from decode-pjs0
        (values nil :invalid-utf8
                (format nil "invalid UTF-8 at payload octet ~a" error-offset))))
    (let ((outcome
            (catch '%pjs0-parse
              (let ((cursor (%make-cursor scalars)))
                (let ((datum (%parse-datum cursor)))
                  (%skip-whitespace cursor)
                  (if (< (%cursor-index cursor) (length scalars))
                      (list :trailing (%cursor-index cursor) datum)
                      (list :ok datum)))))))
      (ecase (first outcome)
        (:invalid
         (values nil :invalid
                 (format nil "parse failure at scalar ~a: ~a"
                         (second outcome) (third outcome))))
        (:trailing
         (values (third outcome) :noncanonical
                 (format nil "trailing content at scalar ~a" (second outcome))))
        (:ok
         (let ((datum (second outcome)))
           (if (%octets-equal-p octets (encode-pjs0 datum))
               (values datum :canonical nil)
               (values datum :noncanonical
                       "canonical re-encoding is not byte-identical"))))))))

(defun pjs0-canonical-p (octets)
  (multiple-value-bind (datum status) (decode-pjs0 octets)
    (declare (ignore datum))
    (eq status :canonical)))
