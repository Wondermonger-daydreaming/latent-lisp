(in-package #:lisp-plus-lci0)

(defun %adapter-fail (code &optional path)
  ;; Package-JSON adaptation precedes LCI semantic validation.  Its closed
  ;; surface diagnostics are implementation/package integrity faults, not
  ;; members of the frozen LCIFailure/0 vocabulary.
  (internal-integrity-fail "fixture-adapter" code "fixture-adapter" :path path))

(defun %json-object-keys (object)
  (unless (and (listp object)
               (every (lambda (pair)
                        (and (consp pair) (stringp (car pair))))
                      object))
    (%adapter-fail "UnknownFixtureShape"))
  (mapcar #'car object))

(defun %require-json-keys (object exact &optional path)
  (let ((actual (%json-object-keys object)))
    (unless (and (= (length actual) (length exact))
                 (every (lambda (key) (member key exact :test #'string=)) actual))
      (%adapter-fail "UnknownFixtureShape" path)))
  object)

(defun %decimal-fixture-integer (string path)
  (unless (and (stringp string) (plusp (length string)))
    (%adapter-fail "InvalidFixtureInteger" path))
  (let ((start 0) (negative nil) (value 0))
    (when (char= (char string 0) #\-)
      (setf negative t start 1)
      (when (= start (length string))
        (%adapter-fail "InvalidFixtureInteger" path)))
    (when (and negative (char= (char string start) #\0))
      (%adapter-fail "InvalidFixtureInteger" path))
    (when (and (> (- (length string) start) 1)
               (char= (char string start) #\0))
      (%adapter-fail "InvalidFixtureInteger" path))
    (loop for index from start below (length string)
          for character = (char string index)
          unless (char<= #\0 character #\9)
            do (%adapter-fail "InvalidFixtureInteger" path)
          do (setf value (+ (* value 10)
                            (- (char-code character) (char-code #\0)))))
    (if negative (- value) value)))

(defun %string-datum-utf8-hex (datum)
  (jget (datum-to-fixture-ast datum) "utf8_hex"))

(defun fixture-json-schema-shape (node)
  (unless (listp node) (return-from fixture-json-schema-shape :unknown))
  (let ((tag (jget node "t" nil)))
    (cond ((null tag)
           (if (and (jhas-p node "key") (jhas-p node "value"))
               :record-field-wrapper :unknown))
          ((not (stringp tag)) :unknown)
          ((string= tag "unit") :unit)
          ((string= tag "bool") :boolean)
          ((string= tag "int") :integer)
          ((string= tag "rat") :rational)
          ((string= tag "bytes") :bytes)
          ((string= tag "string") :string)
          ((string= tag "id") :identifier)
          ((string= tag "seq") :sequence)
          ((string= tag "record") :record)
          (t :unknown))))

(defun fixture-json-to-datum (node &optional (path nil))
  "Pure, total adapter from the package JSON surface to frozen CD/0 datum.
No lookup or semantic inference is performed.  Every surface schema is closed."
  (case (fixture-json-schema-shape node)
    (:unit
     (%require-json-keys node '("t") path)
     (make-unit-datum))
    (:boolean
     (%require-json-keys node '("t" "v") path)
     (let ((value (jget node "v")))
       (cond ((eq value :json-true) (make-boolean-datum t))
             ((eq value :json-false) (make-boolean-datum nil))
             (t (%adapter-fail "InvalidFixtureBoolean" path)))))
    (:integer
     (%require-json-keys node '("t" "v") path)
     (make-integer-datum
      (%decimal-fixture-integer (jget node "v") (append path '("v")))))
    (:rational
     (%require-json-keys node '("t" "num" "den") path)
     (let* ((numerator (%decimal-fixture-integer
                        (jget node "num") (append path '("num"))))
            (denominator (%decimal-fixture-integer
                          (jget node "den") (append path '("den")))))
       ;; The package surface represents an abstract rational, not CD/0
       ;; constructor input.  Translation from num/den to p/q therefore must
       ;; preserve an already-canonical value; reducing, moving a denominator
       ;; sign, or collapsing an integral/zero rational would be semantic
       ;; inference by the adapter.
       (unless (and (not (zerop numerator))
                    (> denominator 1)
                    (= 1 (gcd (abs numerator) denominator)))
         (%adapter-fail "NoncanonicalFixtureRational" path))
       (make-rational-datum numerator denominator)))
    (:bytes
     (%require-json-keys node '("t" "hex") path)
     (make-bytes-datum (octets-copy (hex-to-octets (jget node "hex")))))
    (:string
     (%require-json-keys node '("t" "text" "utf8_hex") path)
     (let* ((text (jget node "text"))
            (hex (jget node "utf8_hex")))
       (unless (stringp text) (%adapter-fail "InvalidFixtureString" path))
       (let ((datum (make-string-datum text)))
         (unless (string= (%string-datum-utf8-hex datum) hex)
           (%adapter-fail "RedundantFixtureFieldMismatch"
                          (append path '("text" "utf8_hex"))))
         datum)))
    (:identifier
     (%require-json-keys node '("t" "namespace" "path") path)
     (let ((namespace (jget node "namespace"))
           (id-path (jget node "path")))
       (unless (and (listp namespace) (every #'stringp namespace)
                    (listp id-path) (every #'stringp id-path)
                    (plusp (length id-path)))
         (%adapter-fail "InvalidFixtureIdentifier" path))
       (make-identifier-datum (copy-list namespace) (copy-list id-path))))
    (:sequence
     (%require-json-keys node '("t" "items") path)
     (let ((items (jget node "items")))
       (unless (listp items) (%adapter-fail "InvalidFixtureSequence" path))
       (make-sequence-datum
        (loop for item in items for index from 0
              collect (fixture-json-to-datum item
                                              (append path (list "items" index)))))))
    (:record
     (%require-json-keys node '("t" "fields") path)
     (let ((fields (jget node "fields")))
       (unless (listp fields) (%adapter-fail "InvalidFixtureRecord" path))
       (make-record-datum
        (loop for field in fields for index from 0
              collect
              (progn
                (%require-json-keys field '("key" "value")
                                    (append path (list "fields" index)))
                (let ((key (fixture-json-to-datum
                            (jget field "key")
                            (append path (list "fields" index "key")))))
                  (unless (identifier-datum-p key)
                    (%adapter-fail "InvalidFixtureRecordKey"
                                   (append path (list "fields" index "key"))))
                  (make-record-entry
                   key
                   (fixture-json-to-datum
                    (jget field "value")
                    (append path (list "fields" index "value"))))))))))
    (otherwise (%adapter-fail "UnknownFixtureShape" path))))

(defparameter +adapter-schema-shapes+
  '(:unit :boolean :integer :rational :bytes :string :identifier :sequence
    :record :record-field-wrapper))
