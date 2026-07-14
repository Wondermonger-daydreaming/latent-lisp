(in-package #:lisp-plus-lci0)

(defparameter *fixture-root* "/tmp/lci0-seed-fixtures-20260714")
(defparameter *registry-definition-cache* (make-hash-table :test #'equal))

(defun fixture-path (root name)
  (merge-pathnames name
                   (pathname (concatenate 'string
                                          (string-right-trim "/" root) "/"))))

(defun %read-json-object-from-opening-brace (stream)
  (let ((output (make-string-output-stream))
        (depth 1) (in-string nil) (escaped nil))
    (write-char #\{ output)
    (loop while (plusp depth)
          for character = (read-char stream nil nil)
          do (unless character (error "truncated registry JSON object"))
             (write-char character output)
             (cond
               (escaped (setf escaped nil))
               ((and in-string (char= character #\\)) (setf escaped t))
               ((char= character #\") (setf in-string (not in-string)))
               ((not in-string)
                (cond ((char= character #\{) (incf depth))
                      ((char= character #\}) (decf depth))))))
    (get-output-stream-string output)))

(defun map-registry-definitions (root function)
  "Call FUNCTION on each of the 675 definition JSON objects without retaining
the 151 MiB registry as one host object."
  (with-open-file (stream (fixture-path root "LCI0-FIXTURE-REGISTRY.json")
                          :direction :input :external-format :utf-8)
    (loop for line = (read-line stream nil nil)
          while line
          until (search "\"definitions\":" line))
    (loop
      for character = (read-char stream nil nil)
      while character
      do (cond
           ((member character '(#\Space #\Tab #\Newline #\Return #\,)
                    :test #'char=))
           ((char= character #\]) (return))
           ((char= character #\{)
            (funcall function
                     (parse-json (%read-json-object-from-opening-brace stream))))
           (t (error "unexpected registry definitions character ~S" character))))))

(defun map-registry-relation-entries (root table-name function)
  "Stream the entry objects of one sealed relation table."
  (with-open-file (stream (fixture-path root "LCI0-FIXTURE-REGISTRY.json")
                          :direction :input :external-format :utf-8)
    (let ((table-marker (format nil "\"~A\": {" table-name))
          (found-table nil) (found-entries nil))
      (loop for line = (read-line stream nil nil)
            while line
            when (search table-marker line)
              do (setf found-table t) (return))
      (unless found-table (error "missing registry relation table ~A" table-name))
      (loop for line = (read-line stream nil nil)
            while line
            when (search "\"entries\": [" line)
              do (setf found-entries t) (return))
      (unless found-entries (error "missing entries for relation table ~A"
                                   table-name))
      (loop
        for character = (read-char stream nil nil)
        while character
        do (cond
             ((member character '(#\Space #\Tab #\Newline #\Return #\,)
                      :test #'char=))
             ((char= character #\]) (return))
             ((char= character #\{)
              (funcall function
                       (parse-json
                        (%read-json-object-from-opening-brace stream))))
             (t (error "unexpected relation-entry character ~S" character)))))))

(defun find-registry-definition (fixture-id &optional (root *fixture-root*))
  (or (gethash fixture-id *registry-definition-cache*)
      (block found
        (map-registry-definitions
         root
         (lambda (definition)
           (when (string= (jget definition "fixture_id") fixture-id)
             (setf (gethash fixture-id *registry-definition-cache*) definition)
             (return-from found definition))))
        (internal-integrity-fail "fixture-package" "MissingRegistryDefinition"
                                 "fixture-registry"))))

(defun registry-datum (fixture-id &optional (root *fixture-root*))
  (fixture-json-to-datum
   (jget (find-registry-definition fixture-id root) "abstract_cd0")))

;;; Dependency-free SHA-256 used only to verify sealed package identities.

(defparameter +sha256-k+
  #(#x428a2f98 #x71374491 #xb5c0fbcf #xe9b5dba5 #x3956c25b #x59f111f1
    #x923f82a4 #xab1c5ed5 #xd807aa98 #x12835b01 #x243185be #x550c7dc3
    #x72be5d74 #x80deb1fe #x9bdc06a7 #xc19bf174 #xe49b69c1 #xefbe4786
    #x0fc19dc6 #x240ca1cc #x2de92c6f #x4a7484aa #x5cb0a9dc #x76f988da
    #x983e5152 #xa831c66d #xb00327c8 #xbf597fc7 #xc6e00bf3 #xd5a79147
    #x06ca6351 #x14292967 #x27b70a85 #x2e1b2138 #x4d2c6dfc #x53380d13
    #x650a7354 #x766a0abb #x81c2c92e #x92722c85 #xa2bfe8a1 #xa81a664b
    #xc24b8b70 #xc76c51a3 #xd192e819 #xd6990624 #xf40e3585 #x106aa070
    #x19a4c116 #x1e376c08 #x2748774c #x34b0bcb5 #x391c0cb3 #x4ed8aa4a
    #x5b9cca4f #x682e6ff3 #x748f82ee #x78a5636f #x84c87814 #x8cc70208
    #x90befffa #xa4506ceb #xbef9a3f7 #xc67178f2))

(declaim (inline %u32 %ror32))
(defun %u32 (integer) (ldb (byte 32 0) integer))
(defun %ror32 (value count)
  (%u32 (logior (ash value (- count)) (ash value (- 32 count)))))

(defun sha256-octets (octets)
  (let* ((input (if (typep octets 'octet-string) (octets-copy octets) octets))
         (length (length input))
         (bit-length (* length 8))
         (padded-length (* 64 (ceiling (+ length 9) 64)))
         (message (make-array padded-length :element-type '(unsigned-byte 8)
                                            :initial-element 0))
         (h (vector #x6a09e667 #xbb67ae85 #x3c6ef372 #xa54ff53a
                    #x510e527f #x9b05688c #x1f83d9ab #x5be0cd19)))
    (replace message input)
    (setf (aref message length) #x80)
    (loop for index from 0 below 8
          do (setf (aref message (- padded-length 1 index))
                   (ldb (byte 8 (* index 8)) bit-length)))
    (loop for offset from 0 below padded-length by 64
          do (let ((w (make-array 64 :element-type '(unsigned-byte 32))))
               (loop for index below 16
                     for base = (+ offset (* index 4))
                     do (setf (aref w index)
                              (logior (ash (aref message base) 24)
                                      (ash (aref message (+ base 1)) 16)
                                      (ash (aref message (+ base 2)) 8)
                                      (aref message (+ base 3)))))
               (loop for index from 16 below 64
                     for x = (aref w (- index 15))
                     for y = (aref w (- index 2))
                     for s0 = (logxor (%ror32 x 7) (%ror32 x 18) (ash x -3))
                     for s1 = (logxor (%ror32 y 17) (%ror32 y 19) (ash y -10))
                     do (setf (aref w index)
                              (%u32 (+ (aref w (- index 16)) s0
                                       (aref w (- index 7)) s1))))
               (let ((a (aref h 0)) (b (aref h 1)) (c (aref h 2))
                     (d (aref h 3)) (e (aref h 4)) (f (aref h 5))
                     (g (aref h 6)) (hh (aref h 7)))
                 (loop for index below 64
                       for s1 = (logxor (%ror32 e 6) (%ror32 e 11) (%ror32 e 25))
                       for choice = (logxor (logand e f) (logand (lognot e) g))
                       for temp1 = (%u32 (+ hh s1 choice (aref +sha256-k+ index)
                                             (aref w index)))
                       for s0 = (logxor (%ror32 a 2) (%ror32 a 13) (%ror32 a 22))
                       for majority = (logxor (logand a b) (logand a c)
                                              (logand b c))
                       for temp2 = (%u32 (+ s0 majority))
                       do (setf hh g g f f e e (%u32 (+ d temp1))
                                d c c b b a a (%u32 (+ temp1 temp2))))
                 (setf (aref h 0) (%u32 (+ (aref h 0) a))
                       (aref h 1) (%u32 (+ (aref h 1) b))
                       (aref h 2) (%u32 (+ (aref h 2) c))
                       (aref h 3) (%u32 (+ (aref h 3) d))
                       (aref h 4) (%u32 (+ (aref h 4) e))
                       (aref h 5) (%u32 (+ (aref h 5) f))
                       (aref h 6) (%u32 (+ (aref h 6) g))
                       (aref h 7) (%u32 (+ (aref h 7) hh))))))
    (let ((output (make-array 32 :element-type '(unsigned-byte 8))))
      (loop for word across h for word-index from 0
            do (loop for byte-index below 4
                     do (setf (aref output (+ (* word-index 4) byte-index))
                              (ldb (byte 8 (* 8 (- 3 byte-index))) word))))
      output)))

(defun sha256-hex (octets)
  (string-downcase
   (with-output-to-string (stream)
     (loop for octet across (sha256-octets octets)
           do (format stream "~2,'0x" octet)))))

(defun verify-fixture-document (document)
  (let* ((abstract (fixture-json-to-datum (jget document "abstract_cd0")))
         (expected-abstract (fixture-json-to-datum
                             (jget document "expected_decoded_abstract_value"
                                   (jget document "abstract_cd0"))))
         (hex (jget document "canonical_cd0_hex"))
         (recorded (hex-to-octets hex))
         (encoded (canonical-octets abstract))
         (count (jget document "canonical_octets_byte_count"
                      (jget document "canonical_octets_byte_count" nil)))
         (checksum (jget document "sha256_checksum_of_canonical_octets"
                         (jget document "sha256" nil))))
    (unless (string= (octets-to-hex encoded) hex)
      (internal-integrity-fail "fixture-package" "CanonicalOctetsMismatch"
                               "fixture-corpus"))
    (when (and count (/= count (octets-length encoded)))
      (internal-integrity-fail "fixture-package" "CanonicalByteCountMismatch"
                               "fixture-corpus"))
    (when (and checksum (not (string= checksum (sha256-hex (octets-copy encoded)))))
      (internal-integrity-fail "fixture-package" "CanonicalChecksumMismatch"
                               "fixture-corpus"))
    (let ((decoded (decode-exact (octets-copy recorded))))
      (unless (and (equal-datum decoded expected-abstract)
                   (string= (octets-to-hex (canonical-octets decoded)) hex))
        (internal-integrity-fail "fixture-package" "CanonicalRoundTripMismatch"
                                 "fixture-corpus")))
    t))

(defun %json-object-p (value)
  (and (consp value)
       (every (lambda (item) (and (consp item) (stringp (car item)))) value)))

(defun %map-magic-json-strings (value function)
  (cond
    ((%json-object-p value)
     (dolist (pair value)
       (let ((child (cdr pair)))
         (if (and (stringp child)
                  (>= (length child) 10)
                  (string= child "4c50434400" :end1 10 :end2 10))
             (funcall function (car pair) child)
             (%map-magic-json-strings child function)))))
    ((listp value)
     (dolist (child value) (%map-magic-json-strings child function)))))

(defun %count-quoted-magic-prefixes (path)
  "Independent shallow-key-agnostic census of JSON strings beginning in CD/0
magic.  The leading quote prevents embedded magic inside an outer hex document
from being counted as another document."
  (let ((pattern "\"4c50434400") (count 0))
    (with-open-file (stream path :direction :input :external-format :utf-8)
      (loop for line = (read-line stream nil nil)
            while line
            do (loop with start = 0
                     for position = (search pattern line :start2 start)
                     while position
                     do (incf count)
                        (setf start (+ position (length pattern))))))
    count))

(defun %verify-nested-magic-documents (row)
  (let* ((input (fixture-json-to-datum (jget (jget row "inputs") "abstract_cd0")))
         (payload (record-field-named input "payload"))
         (expectation (record-field-named payload "fixture-value"))
         (count 0))
    (%map-magic-json-strings
     row
     (lambda (key hex)
       (when (string= key "hex")
         (let* ((octets (hex-to-octets hex))
                (decoded (decode-exact (octets-copy octets))))
           (unless (and expectation (equal-datum decoded expectation)
                        (string= (octets-to-hex (canonical-octets decoded)) hex))
             (internal-integrity-fail
              "fixture-package" "NestedCanonicalRoundTripMismatch"
              "fixture-corpus"))
           (incf count)))))
    count))

(defun verify-fixture-corpus (&optional (root *fixture-root*))
  "Independently verify the official 1,105 documents and supplementary 488
documents in the frozen package.  Returns a closed count plist for evidence."
  (let ((definitions 0) (vectors 0) (vector-documents 0)
        (relation-documents 0) (nested-e1-documents 0))
    (map-registry-definitions
     root (lambda (definition)
            (verify-fixture-document definition)
            (incf definitions)))
    (with-open-file
        (stream (fixture-path root "LCI0-FIXTURE-VECTORS.jsonl")
                :direction :input :external-format :utf-8)
      (loop for line = (read-line stream nil nil)
            while line
            unless (zerop (length line))
              do (let ((row (parse-json line)))
                   (incf vectors)
                   (verify-fixture-document (jget row "inputs"))
                   (verify-fixture-document (jget row "expected"))
                   (incf vector-documents 2)
                   (incf nested-e1-documents
                         (%verify-nested-magic-documents row)))))
    (dolist (table '("scope_relation_table_0" "temporal_relation_table_0"))
      (map-registry-relation-entries
       root table
       (lambda (entry)
         (verify-fixture-document entry)
         (incf relation-documents))))
    (let* ((official (+ definitions vector-documents))
           (supplementary (+ relation-documents nested-e1-documents))
           (total (+ official supplementary))
           (magic-count
             (+ (%count-quoted-magic-prefixes
                 (fixture-path root "LCI0-FIXTURE-REGISTRY.json"))
                (%count-quoted-magic-prefixes
                 (fixture-path root "LCI0-FIXTURE-VECTORS.jsonl")))))
      (unless (and (= definitions 675) (= vectors 215)
                   (= official 1105) (= relation-documents 458)
                   (= nested-e1-documents 30) (= supplementary 488)
                   (= total 1593) (= magic-count total))
        (internal-integrity-fail "fixture-package"
                                 "FixtureCorpusCensusMismatch"
                                 "fixture-corpus"))
      (list :registry-definitions definitions
            :vectors vectors
            :official-documents official
            :relation-table-documents relation-documents
            :nested-e1-documents nested-e1-documents
            :supplementary-documents supplementary
            :total-documents total
            :magic-prefixed-json-values magic-count))))
