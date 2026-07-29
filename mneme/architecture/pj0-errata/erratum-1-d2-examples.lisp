;;;; erratum-1-d2-examples.lisp — executable examples for PJ0 Erratum 0.1 (D-2)
;;;;
;;;; Run from the latent-lisp root
;;;; (experiments/latent-lisp/ in the lab tree):
;;;;
;;;;   sbcl --script mneme/architecture/pj0-errata/erratum-1-d2-examples.lisp
;;;;
;;;; Exit 0 iff every check passes.  Standalone: no dependencies, no packages,
;;;; ASCII-only.  This script implements BOTH orders named by the erratum —
;;;; the PJ-S/0 record-key order (corpus order) and CD/0 Section 14.3
;;;; encoded-ValueBytes order — and demonstrates executably that
;;;;   (a) they disagree on the corpus-forced discriminating pair
;;;;       (id "pj0" "cd0-version") vs (id "pj0" "store-id"),
;;;;   (b) the disagreement is decided by the varint length octet (8 vs 11)
;;;;       before any text octet is reached,
;;;;   (c) the frozen positive fixture bytes render the corpus order, and
;;;;   (d) the differing-segment-count and segment-prefix clauses behave as
;;;;       the erratum states.
;;;;
;;;; Nothing here writes anything.  Frozen bytes are read, never touched.

;;; ---------------------------------------------------------------------------
;;; Check harness

(defvar *checks* 0)
(defvar *failures* 0)

(defun check (label got expected)
  (incf *checks*)
  (let ((ok (equal got expected)))
    (unless ok (incf *failures*))
    (format t "[~a] ~:[FAIL~;pass~] ~a~@[  (got ~s, expected ~s)~]~%"
            (format nil "E~2,'0d" *checks*) ok label
            (unless ok (list got expected)) (unless ok expected))
    ok))

;;; ---------------------------------------------------------------------------
;;; UTF-8 and UVAR (CD/0 Section 12.2, Section 15.2 — minimal unsigned LEB128)

(defun utf8-octets (string)
  "UTF-8 octets of STRING (scalar values; strict, no surrogates expected)."
  (let ((out (make-array 0 :element-type '(unsigned-byte 8)
                           :adjustable t :fill-pointer 0)))
    (loop for ch across string
          for cp = (char-code ch)
          do (cond ((< cp #x80) (vector-push-extend cp out))
                   ((< cp #x800)
                    (vector-push-extend (logior #xC0 (ash cp -6)) out)
                    (vector-push-extend (logior #x80 (logand cp #x3F)) out))
                   ((< cp #x10000)
                    (vector-push-extend (logior #xE0 (ash cp -12)) out)
                    (vector-push-extend (logior #x80 (logand (ash cp -6) #x3F)) out)
                    (vector-push-extend (logior #x80 (logand cp #x3F)) out))
                   (t
                    (vector-push-extend (logior #xF0 (ash cp -18)) out)
                    (vector-push-extend (logior #x80 (logand (ash cp -12) #x3F)) out)
                    (vector-push-extend (logior #x80 (logand (ash cp -6) #x3F)) out)
                    (vector-push-extend (logior #x80 (logand cp #x3F)) out))))
    (coerce out '(simple-array (unsigned-byte 8) (*)))))

(defun uvar (n)
  "Minimal unsigned LEB128 octets of nonnegative integer N (CD/0 Section 15.2)."
  (if (zerop n)
      (make-array 1 :element-type '(unsigned-byte 8) :initial-element 0)
      (let ((out (make-array 0 :element-type '(unsigned-byte 8)
                               :adjustable t :fill-pointer 0)))
        (loop while (plusp n)
              do (let ((group (logand n #x7F)))
                   (setf n (ash n -7))
                   (vector-push-extend (if (plusp n) (logior group #x80) group)
                                       out)))
        (coerce out '(simple-array (unsigned-byte 8) (*))))))

;;; ---------------------------------------------------------------------------
;;; The two orders

(defun octets-compare (left right)
  "Unsigned lexicographic comparison; exact prefix sorts first."
  (loop for index below (min (length left) (length right))
        do (let ((l (aref left index)) (r (aref right index)))
             (cond ((< l r) (return-from octets-compare :less))
                   ((> l r) (return-from octets-compare :greater)))))
  (cond ((< (length left) (length right)) :less)
        ((> (length left) (length right)) :greater)
        (t :equal)))

(defun corpus-key< (segments-a segments-b)
  "PJ-S/0 record-key order (the erratum's normative rule): compare segment
lists elementwise in rendering order, each segment by unsigned lexicographic
UTF-8 octet comparison; a segment-list prefix sorts first."
  (loop for a in segments-a
        for b in segments-b
        do (ecase (octets-compare (utf8-octets a) (utf8-octets b))
             (:less (return-from corpus-key< t))
             (:greater (return-from corpus-key< nil))
             (:equal)))
  (< (length segments-a) (length segments-b)))

(defun key-value-bytes (segments)
  "CD/0 Section 15.8 canonical value encoding of a PJ-S/0 identifier key.
PJ-S/0 (id s1 ... sn) maps to CD/0 namespace [s1 ... s(n-1)], path [sn]
(journal0 divergence D-4 convention, corpus-round-trip verified)."
  (let* ((namespace (butlast segments))
         (path (last segments))
         (out (make-array 0 :element-type '(unsigned-byte 8)
                            :adjustable t :fill-pointer 0)))
    (flet ((emit-octets (octets)
             (loop for octet across octets do (vector-push-extend octet out))))
      (vector-push-extend 22 out)
      (emit-octets (uvar (length namespace)))
      (dolist (segment namespace)
        (let ((octets (utf8-octets segment)))
          (emit-octets (uvar (length octets)))
          (emit-octets octets)))
      (emit-octets (uvar (length path)))
      (dolist (segment path)
        (let ((octets (utf8-octets segment)))
          (emit-octets (uvar (length octets)))
          (emit-octets octets))))
    (coerce out '(simple-array (unsigned-byte 8) (*)))))

(defun cd0-key< (segments-a segments-b)
  "CD/0 Section 14.3 canonical field ordering: unsigned lexicographic
comparison of the keys' encoded ValueBytes."
  (eq :less (octets-compare (key-value-bytes segments-a)
                            (key-value-bytes segments-b))))

;;; ---------------------------------------------------------------------------
;;; Example 1 — the corpus-forced discriminating pair

(let ((cd0-version '("pj0" "cd0-version"))
      (store-id    '("pj0" "store-id")))
  (check "corpus order: (id \"pj0\" \"cd0-version\") sorts BEFORE (id \"pj0\" \"store-id\")"
         (corpus-key< cd0-version store-id) t)
  (check "CD/0 14.3 order: (id \"pj0\" \"store-id\") sorts BEFORE (id \"pj0\" \"cd0-version\") — the orders disagree"
         (cd0-key< store-id cd0-version) t)
  ;; The disagreement is decided by the varint length octet, before any text.
  (let* ((bytes-v (key-value-bytes cd0-version))
         (bytes-s (key-value-bytes store-id))
         (first-diff (loop for index below (min (length bytes-v) (length bytes-s))
                           when (/= (aref bytes-v index) (aref bytes-s index))
                             return index)))
    (check "first differing ValueBytes octet is the path-segment length prefix: 11 (\"cd0-version\") vs 8 (\"store-id\")"
           (list (aref bytes-v first-diff) (aref bytes-s first-diff))
           '(11 8))
    (check "shared encoded prefix before the difference is tag 22, ns-count 1, len 3, \"pj0\", path-count 1"
           (coerce (subseq bytes-v 0 first-diff) 'list)
           (list 22 1 3 (char-code #\p) (char-code #\j) (char-code #\0) 1))))

;;; ---------------------------------------------------------------------------
;;; Example 2 — differing segment counts

(check "elementwise decision beats length: (id \"pj0\" \"a\" \"b\") sorts before (id \"pj0\" \"c\") (\"a\" < \"c\" at position 2)"
       (corpus-key< '("pj0" "a" "b") '("pj0" "c")) t)
(check "segment-list prefix sorts first: (id \"pj0\") sorts before (id \"pj0\" \"x\")"
       (corpus-key< '("pj0") '("pj0" "x")) t)
(check "and not the reverse"
       (corpus-key< '("pj0" "x") '("pj0")) nil)

;;; ---------------------------------------------------------------------------
;;; Example 3 — segment octet-prefix

(check "octet-prefix segment sorts first: (id \"pj0\" \"store\") sorts before (id \"pj0\" \"store-id\")"
       (corpus-key< '("pj0" "store") '("pj0" "store-id")) t)
(check "CD/0 14.3 AGREES on this pair (5 < 8 in the length octet) — the orders diverge only where length order opposes text order"
       (cd0-key< '("pj0" "store") '("pj0" "store-id")) t)

;;; ---------------------------------------------------------------------------
;;; Example 4 — the frozen corpus bytes render the corpus order

(defun fixture-record-keys (path)
  "Top-level record keys of a frozen JOURNAL-META.pjs, in file order.
Keys are exactly the string following each literal occurrence of
'((id \"pj0\" \"' — values render identifiers with a single open paren,
so the double paren uniquely marks a field's key in these fixtures."
  (with-open-file (stream path :direction :input
                               :external-format :utf-8)
    (let ((text (make-string (file-length stream))))
      (setf text (subseq text 0 (read-sequence text stream)))
      (let ((marker "((id \"pj0\" \"")
            (keys '()))
        (loop with start = 0
              for hit = (search marker text :start2 start)
              while hit
              do (let* ((key-start (+ hit (length marker)))
                        (key-end (position #\" text :start key-start)))
                   (push (subseq text key-start key-end) keys)
                   (setf start key-end)))
        (nreverse keys)))))

(let* ((fixture "mneme/architecture/process-journal-0/fixtures/positive/synced-demo/JOURNAL-META.pjs")
       (file-keys (fixture-record-keys fixture))
       (as-ids (mapcar (lambda (key) (list "pj0" key)) file-keys))
       (corpus-sorted (sort (copy-list as-ids) #'corpus-key<))
       (cd0-sorted (sort (copy-list as-ids) #'cd0-key<)))
  (check "frozen synced-demo metadata has the eight expected keys in file order"
         file-keys
         '("cd0-version" "creation-procedure" "declared-durability"
           "format-version" "genesis-digest" "store-id" "store-nonce"
           "witness-policy"))
  (check "file order EQUALS the erratum's PJ-S/0 record-key order"
         (equal as-ids corpus-sorted) t)
  (check "file order DIFFERS from CD/0 14.3 encoded-ValueBytes order"
         (equal as-ids cd0-sorted) nil)
  (check "under CD/0 14.3 the first key would be store-id, not cd0-version"
         (second (first cd0-sorted)) "store-id"))

;;; ---------------------------------------------------------------------------

(format t "~%RESULT: ~d checks, ~d failures~%" *checks* *failures*)
(sb-ext:exit :code (if (zerop *failures*) 0 1))
