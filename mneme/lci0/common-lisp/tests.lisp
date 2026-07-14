(in-package #:cl-user)

(defvar *lci0-test-passes* 0)
(defvar *lci0-test-failures* 0)

(defmacro lci0-check (name form)
  `(handler-case
       (if ,form
           (progn (incf *lci0-test-passes*)
                  (format t "PASS ~A~%" ,name))
           (progn (incf *lci0-test-failures*)
                  (format t "FAIL ~A -- false~%" ,name)))
     (error (condition)
       (incf *lci0-test-failures*)
       (format t "FAIL ~A -- ~A~%" ,name condition))))

(defun lci0-refusal-code (thunk)
  (handler-case (progn (funcall thunk) nil)
    (lisp-plus-lci0:lci-failure (condition)
      (lisp-plus-lci0:lci-failure-code condition))))

(defun run-lci0-common-lisp-unit-tests ()
  (setf *lci0-test-passes* 0 *lci0-test-failures* 0)
  (let* ((samples
           (list
            (cons :unit "{\"t\":\"unit\"}")
            (cons :boolean "{\"t\":\"bool\",\"v\":true}")
            (cons :integer "{\"t\":\"int\",\"v\":\"1\"}")
            (cons :rational
                  "{\"t\":\"rat\",\"num\":\"2\",\"den\":\"4\"}")
            (cons :bytes "{\"t\":\"bytes\",\"hex\":\"00ff\"}")
            (cons :string
                  "{\"t\":\"string\",\"text\":\"A\",\"utf8_hex\":\"41\"}")
            (cons :identifier
                  "{\"t\":\"id\",\"namespace\":[\"N\"],\"path\":[\"P\"]}")
            (cons :sequence
                  "{\"t\":\"seq\",\"items\":[{\"t\":\"unit\"}]}")
            (cons :record
                  "{\"t\":\"record\",\"fields\":[{\"key\":{\"t\":\"id\",\"namespace\":[\"N\"],\"path\":[\"K\"]},\"value\":{\"t\":\"unit\"}}]}")
            (cons :record-field-wrapper
                  "{\"key\":{\"t\":\"unit\"},\"value\":{\"t\":\"unit\"}}")))
         (observed (mapcar (lambda (sample)
                             (lisp-plus-lci0:fixture-json-schema-shape
                              (lisp-plus-lci0:parse-json (cdr sample))))
                           samples)))
    (lci0-check "adapter-schema-census"
      (equal observed (mapcar #'car samples)))
    (lci0-check "adapter-all-datum-shapes-construct"
      (every (lambda (sample)
               (or (eq (car sample) :record-field-wrapper)
                   (lisp-plus-cd0:datum-p
                    (lisp-plus-lci0:fixture-json-to-datum
                     (lisp-plus-lci0:parse-json (cdr sample))))))
             samples)))
  (lci0-check "adapter-unknown-shape-fails-closed"
    (string= "UnknownFixtureShape"
             (lci0-refusal-code
              (lambda ()
                (lisp-plus-lci0:fixture-json-to-datum
                 (lisp-plus-lci0:parse-json
                  "{\"t\":\"future-datum\",\"v\":0}"))))))
  (lci0-check "adapter-nonstring-tag-fails-closed"
    (string= "UnknownFixtureShape"
             (lci0-refusal-code
              (lambda ()
                (lisp-plus-lci0:fixture-json-to-datum
                 (lisp-plus-lci0:parse-json "{\"t\":0}"))))))
  (lci0-check "adapter-redundant-string-verification"
    (string= "RedundantFixtureFieldMismatch"
             (lci0-refusal-code
              (lambda ()
                (lisp-plus-lci0:fixture-json-to-datum
                 (lisp-plus-lci0:parse-json
                  "{\"t\":\"string\",\"text\":\"A\",\"utf8_hex\":\"42\"}"))))))
  (let ((boolean (lisp-plus-lci0:fixture-json-to-datum
                  (lisp-plus-lci0:parse-json
                   "{\"t\":\"bool\",\"v\":true}")))
        (integer (lisp-plus-lci0:fixture-json-to-datum
                  (lisp-plus-lci0:parse-json
                   "{\"t\":\"int\",\"v\":\"1\"}"))))
    (lci0-check "adapter-preserves-boolean-versus-integer"
      (and (lisp-plus-cd0:boolean-datum-p boolean)
           (lisp-plus-cd0:integer-datum-p integer)
           (not (lisp-plus-cd0:equal-datum boolean integer)))))
  (let ((half-a (lisp-plus-lci0:fixture-json-to-datum
                 (lisp-plus-lci0:parse-json
                  "{\"t\":\"rat\",\"num\":\"2\",\"den\":\"4\"}")))
        (half-b (lisp-plus-lci0:fixture-json-to-datum
                 (lisp-plus-lci0:parse-json
                  "{\"t\":\"rat\",\"num\":\"1\",\"den\":\"2\"}"))))
    (lci0-check "adapter-exact-rational-normalization"
      (lisp-plus-cd0:equal-datum half-a half-b)))
  (let* ((source (lisp-plus-lci0:parse-json
                  "{\"t\":\"id\",\"namespace\":[\"Case\"],\"path\":[\"Segment\"]}"))
         (datum (lisp-plus-lci0:fixture-json-to-datum source))
         (before (lisp-plus-cd0:canonical-octets datum)))
    (let ((namespace (cdr (assoc "namespace" source :test #'string=))))
      (setf (char (first namespace) 0) #\x))
    (lci0-check "adapter-source-mutation-isolated"
      (string= (lisp-plus-lci0::octets-to-hex before)
               (lisp-plus-lci0::octets-to-hex
                (lisp-plus-cd0:canonical-octets datum)))))
  (lci0-check "cd0-sha256-known-answer"
    (string= (lisp-plus-lci0::sha256-hex
              (lisp-plus-lci0::hex-to-octets "616263"))
             "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"))
  (lci0-check "independently-allocated-values-equal"
    (let ((left (lisp-plus-cd0:make-identifier-datum '("N") '("P")))
          (right (lisp-plus-cd0:make-identifier-datum '("N") '("P"))))
      (and (not (eq left right)) (lisp-plus-cd0:equal-datum left right))))
  (lci0-check "record-insertion-order-neutral"
    (let* ((a (lisp-plus-cd0:make-identifier-datum '("N") '("a")))
           (b (lisp-plus-cd0:make-identifier-datum '("N") '("b")))
           (one (lisp-plus-cd0:make-record-datum
                 (list (lisp-plus-cd0:make-record-entry
                        a (lisp-plus-cd0:make-integer-datum 1))
                       (lisp-plus-cd0:make-record-entry
                        b (lisp-plus-cd0:make-integer-datum 2)))))
           (two (lisp-plus-cd0:make-record-datum
                 (list (lisp-plus-cd0:make-record-entry
                        b (lisp-plus-cd0:make-integer-datum 2))
                       (lisp-plus-cd0:make-record-entry
                        a (lisp-plus-cd0:make-integer-datum 1))))))
      (lisp-plus-cd0:equal-datum one two)))
  (lci0-check "source-list-mutation-snapshot"
    (lisp-plus-lci0:run-mutation-snapshot-test))
  (lci0-check "printer-package-readtable-ambient-neutrality"
    (let* ((claim (lisp-plus-lci0::registry-datum "claim-id.file-alpha-neutral"))
           (before (lisp-plus-cd0:canonical-octets claim))
           (package (make-package (symbol-name (gensym "LCI0-AMBIENT-"))
                                  :use '(#:cl))))
      (unwind-protect
           (let ((*package* package)
                 (*print-base* 16) (*print-radix* t) (*print-case* :downcase)
                 (*print-readably* nil) (*readtable* (copy-readtable nil)))
             (set-macro-character #\! (lambda (stream character)
                                        (declare (ignore stream character)) :ambient))
             (string= (lisp-plus-lci0::octets-to-hex before)
                      (lisp-plus-lci0::octets-to-hex
                       (lisp-plus-cd0:canonical-octets
                        (lisp-plus-lci0:project-claim-id claim)))))
        (delete-package package))))
  (lci0-check "filesystem-and-clock-ambient-neutrality"
    (let* ((claim (lisp-plus-lci0::registry-datum "claim-id.file-alpha-neutral"))
           (before (lisp-plus-cd0:canonical-octets
                    (lisp-plus-lci0:project-claim-id claim)))
           (cl:*default-pathname-defaults* #P"/definitely-unavailable-lci0/"))
      (get-universal-time)
      (string= (lisp-plus-lci0::octets-to-hex before)
               (lisp-plus-lci0::octets-to-hex
                (lisp-plus-cd0:canonical-octets
                 (lisp-plus-lci0:project-claim-id claim))))))
  (format t "LCI0 COMMON LISP UNIT SUMMARY: ~D passed, ~D failed, ~D total~%"
          *lci0-test-passes* *lci0-test-failures*
          (+ *lci0-test-passes* *lci0-test-failures*))
  (zerop *lci0-test-failures*))
